"""
pipeline_anotacao_completo.py
================================
Variante de pipeline_anotacao.py que le a entrada de resultados_completos.csv
(formato LONGO: uma linha por model x id x task, coluna 'response' com o
texto) em vez de prompts_recuperados.csv (formato LARGO: uma linha por id,
colunas txt_<variant>). Filtra so o modelo LRM (DeepSeek-R1-Distill), que
e' o que tem raciocinio em <think>...</think> (o formato que esse pipeline
de anotacao foi desenhado para tagear).

Reaproveita 100% da logica de limpeza/anotacao/insercao de tags de
pipeline_anotacao.py (clean_reasoning, build_prompt, call_openai,
parse_anchors_json, aplicar_ancoras, verificar_integridade) -- so troca a
etapa de carregamento/pivot do CSV de entrada. Nada de logica duplicada
ou divergente: qualquer ajuste no comportamento de limpeza/anotacao deve
continuar sendo feito em pipeline_anotacao.py, e este script automaticamente
usa a versao atualizada (via import).

Uso:
    python3 pipeline_anotacao_completo.py

As configuracoes de quais variantes/ids processar continuam sendo lidas
de pipeline_anotacao.py (VARIANTS_TO_RUN / IDS_TO_RUN) -- edite la, nao
aqui, para manter uma unica fonte de verdade.
"""

import gc
import json
import time
import traceback

import pandas as pd

import rotulacao as pa  # reaproveita toda a logica ja existente (arquivo renomeado de pipeline_anotacao.py)

# ==============================================================================
# CONFIGURACAO ESPECIFICA DESTA VARIANTE
# ==============================================================================
PATH_INPUT_LONGO = "resultados_completos.csv"
MODEL_LABEL = "LRM"  # so DeepSeek-R1-Distill tem raciocinio <think> rico


def carregar_input_long_para_wide(path: str, model_label: str) -> pd.DataFrame:
    """Le resultados_completos.csv (formato longo) e converte para o mesmo
    formato largo que pipeline_anotacao.py espera: uma linha por id, com
    colunas txt_<task> para cada task (equivalente ao txt_<variant> do
    prompts_recuperados.csv original)."""
    df_full = pd.read_csv(path)
    df = df_full[df_full["model"] == model_label].copy()

    if df.empty:
        raise ValueError(
            f"Nenhuma linha encontrada para model == '{model_label}' em {path}. "
            f"Valores de 'model' presentes: {sorted(df_full['model'].unique())}"
        )

    pivot_resp = df.pivot(index="id", columns="task", values="response")
    pivot_resp.columns = [f"txt_{c}" for c in pivot_resp.columns]

    meta = (
        df.drop_duplicates(subset="id")
        .set_index("id")[["gt", "nl_bin", "fol_bin"]]
    )

    wide = meta.join(pivot_resp).reset_index()
    return wide


# ==============================================================================
# MAIN -- copia adaptada de pipeline_anotacao.main(): so muda o carregamento
# do df_input (via pivot acima). Todo o resto reaproveita pa.<funcao/const>.
# ==============================================================================
def main():
    variants = pa.VARIANTS_TO_RUN if pa.VARIANTS_TO_RUN is not None else pa.ALL_VARIANTS
    print(f"\n🔧 Variantes : {variants}")
    print(f"🔧 Modelo    : {MODEL_LABEL}")
    print(f"🔧 Entrada   : {PATH_INPUT_LONGO} (formato longo, pivotado para largo)")

    total_input_tokens  = 0
    total_output_tokens = 0
    total_calls         = 0
    total_erros         = 0
    total_invalidos     = 0
    usage_log           = []

    print(f"\n📂 Carregando {PATH_INPUT_LONGO}...")
    df_input = carregar_input_long_para_wide(PATH_INPUT_LONGO, MODEL_LABEL)
    print(f"   IDs únicos ({MODEL_LABEL}): {len(df_input)}")

    if pa.IDS_TO_RUN is not None:
        ids_set  = set(pa.IDS_TO_RUN)
        df_input = df_input[df_input["id"].isin(ids_set)].reset_index(drop=True)
        print(f"   IDs selecionados: {sorted(ids_set)}")
        print(f"   Após filtro: {len(df_input)} linhas")
    else:
        print(f"   IDs: todos ({len(df_input)})")

    df_output = pa.load_or_create_output(pa.PATH_OUTPUT, variants)

    def already_done(row_id):
        # Mesma correção do skip por variante: uma coluna gpt_ não-nula
        # não significa sucesso -- aplicar_ancoras pode ter devolvido um
        # texto parcial junto com um erro registrado em erro_. Sem checar
        # erro_ aqui, uma linha inteira com falhas era pulada para sempre.
        sub = df_output[df_output["id"] == row_id]
        if len(sub) == 0:
            return False
        for v in variants:
            col_gpt  = f"gpt_{v}"
            col_erro = f"erro_{v}"
            if col_gpt not in sub.columns or pd.isna(sub.iloc[0].get(col_gpt)):
                return False
            if col_erro in sub.columns and not pd.isna(sub.iloc[0].get(col_erro)):
                return False
        return True

    ids_pending = [rid for rid in df_input["id"] if not already_done(rid)]
    df_pending  = df_input[df_input["id"].isin(ids_pending)].reset_index(drop=True)
    print(f"   Pendentes: {len(df_pending)} / {len(df_input)}\n")

    if len(df_pending) == 0:
        print("✅ Nada a processar.")
        return

    results_buffer = []

    for idx, row in df_pending.iterrows():
        item_id = row["id"]
        try:
            print(f"📝 ID {item_id}  ({idx+1}/{len(df_pending)})")

            existing   = df_output[df_output["id"] == item_id]
            result_row = existing.iloc[0].to_dict() if len(existing) > 0 else {
                "id":      item_id,
                "gt":      row.get("gt",      None),
                "nl_bin":  row.get("nl_bin",  None),
                "fol_bin": row.get("fol_bin", None),
            }

            for variant in variants:
                col_txt  = f"txt_{variant}"
                col_out  = f"gpt_{variant}"
                col_erro = f"erro_{variant}"

                # Só considera "já processado" se não há erro registrado
                # (ver mesma correção e explicação em rotulacao.py).
                erro_previo = result_row.get(col_erro)
                erro_previo_existe = erro_previo is not None and not pd.isna(erro_previo)
                if col_out in result_row and result_row.get(col_out) is not None \
                        and not pd.isna(result_row.get(col_out, float("nan"))) \
                        and not erro_previo_existe:
                    print(f"  ⏩ {variant:15s} | já processado")
                    continue

                if col_txt not in row or pd.isna(row.get(col_txt)):
                    result_row[col_out]  = None
                    result_row[col_erro] = "txt ausente"
                    print(f"  ⏭  {variant:15s} | txt ausente, pulando")
                    continue

                # ── LIMPEZA DO RACIOCÍNIO (reaproveita pipeline_anotacao) ──
                reasoning_text = pa.clean_reasoning(str(row[col_txt]))

                if not reasoning_text or reasoning_text == "nan":
                    result_row[col_out]  = None
                    result_row[col_erro] = "txt vazio após limpeza"
                    print(f"  ⏭  {variant:15s} | txt vazio após limpeza")
                    continue

                # ── ANOTAÇÃO (chamada + parse + aplicação + reparo automático) ──
                # Reaproveita pa.annotate_with_retry: única fonte de verdade
                # do laço call_openai -> parse -> aplicar_ancoras -> reparo,
                # compartilhada com rotulacao.py (ver docstring deste arquivo).
                anot = pa.annotate_with_retry(reasoning_text)

                total_input_tokens  += anot["input_tokens"]
                total_output_tokens += anot["output_tokens"]

                if anot["erro"] is None:
                    result_row[col_out]  = anot["texto_final"]
                    result_row[col_erro] = None
                    total_calls += 1
                    reparo_info = f" (após {anot['tentativas_reparo']} reparo(s))" if anot["tentativas_reparo"] else ""
                    print(f"  ✅ {variant:15s} | in={anot['input_tokens']:5d} out={anot['output_tokens']:5d}{reparo_info}")
                    usage_log.append({
                        "id": item_id, "variant": variant,
                        "input_tokens":  anot["input_tokens"],
                        "output_tokens": anot["output_tokens"],
                    })
                else:
                    result_row[col_out]  = anot["texto_final"]
                    result_row[col_erro] = anot["erro"]
                    if anot["texto_final"] is None and "JSON invalido" not in anot["erro"]:
                        total_erros += 1
                        print(f"  ❌ {variant:15s} | ERRO: {anot['erro']}")
                    else:
                        total_invalidos += 1
                        print(f"  ⚠️  {variant:15s} | {anot['erro'][:120]}")

                time.sleep(pa.SLEEP_BETWEEN_CALLS)

            df_output = df_output[df_output["id"] != item_id].reset_index(drop=True)
            results_buffer.append(result_row)

            if (idx + 1) % pa.SAVE_EVERY == 0:
                df_new    = pd.DataFrame(results_buffer)
                df_output = pd.concat([df_output, df_new], ignore_index=True)
                df_output.to_csv(pa.PATH_OUTPUT, index=False)
                results_buffer = []
                print(f"  💾 Salvo ({idx+1} processados)\n")

            gc.collect()

        except Exception:
            print(f"\n❌ Erro inesperado no ID {item_id}")
            traceback.print_exc()
            continue

    if results_buffer:
        df_new    = pd.DataFrame(results_buffer)
        df_output = pd.concat([df_output, df_new], ignore_index=True)

    df_output.to_csv(pa.PATH_OUTPUT, index=False)
    print(f"\n✅ Concluído. CSV salvo em: {pa.PATH_OUTPUT}")

    print("\n" + "=" * 50)
    print("TOKEN REPORT")
    print("=" * 50)
    print(f"Chamadas       : {total_calls}")
    print(f"Erros de API   : {total_erros}")
    print(f"Inválidos      : {total_invalidos}")
    print(f"Input tokens   : {total_input_tokens:,}")
    print(f"Output tokens  : {total_output_tokens:,}")

    if total_calls > 0:
        avg_in     = total_input_tokens  / total_calls
        avg_out    = total_output_tokens / total_calls
        n_ids      = len(df_input)
        n_variants = len(variants)
        proj_calls = n_ids * n_variants
        proj_in    = avg_in  * proj_calls
        proj_out   = avg_out * proj_calls
        cost = (
            (proj_in  / 1e6) * pa.PRICE_INPUT_PER_1M
            + (proj_out / 1e6) * pa.PRICE_OUTPUT_PER_1M
        )

        print(
            f"\nPROJEÇÃO "
            f"({n_ids} IDs × {n_variants} variantes = {proj_calls:,} chamadas)"
        )
        print(f"  Input     : {proj_in:,.0f} tokens")
        print(f"  Output    : {proj_out:,.0f} tokens")
        print(f"  Custo est.: US$ {cost:.2f}  ({pa.MODEL_NAME})")

        if usage_log:
            df_log = pd.DataFrame(usage_log)
            print("\nMÉDIA POR VARIANTE")
            print(
                df_log.groupby("variant")[["input_tokens", "output_tokens"]]
                .mean()
                .round(1)
                .to_string()
            )


if __name__ == "__main__":
    main()