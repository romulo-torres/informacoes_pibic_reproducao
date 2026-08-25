"""
judge_contradiction_gpt5mini.py
=================================
Reavalia a task 'contradiction' de resultados_completos.csv usando o
GPT-5.6 Terra como juiz: em vez de comparar p_contradiction com gt_effective
(que hoje e sempre fixado como 'Uncertain'), pergunta ao GPT-5-mini se o
texto de raciocinio do modelo (LLM ou LRM) IDENTIFICOU EXPLICITAMENTE que
as premissas sao contraditorias/inconsistentes entre si.

Criterio (definido pelo usuario):
    Conta como "identificou a contradicao" SOMENTE se o texto afirma
    explicitamente que as premissas sao contraditorias/inconsistentes/
    conflitantes -- mesmo que o modelo NAO tenha chegado a 'Uncertain'
    como resposta final. Nao conta apenas por o modelo ter dado Uncertain
    sem explicar o motivo, nem por duvida generica sobre a conclusao.

Uso:
    pip install openai pandas python-dotenv --break-system-packages   # se necessario
    # certifique-se de que existe um arquivo .env na pasta atual com:
    #   OPENAI_API_KEY=sk-...
    python3 judge_contradiction_gpt5mini.py resultados_completos.csv resultados_completos_judged.csv

Se nao passar argumentos, usa os nomes padrao definidos abaixo.
O .env eh carregado automaticamente da pasta onde o script for executado
(via python-dotenv). Se o seu .env estiver em outro lugar, edite a linha
load_dotenv() logo abaixo dos imports para apontar o caminho certo.

O script:
  1) Filtra as linhas com task == 'contradiction' (ambos os modelos).
  2) Pula linhas sem resposta valida (response vazio/NaN, p == 'SKIP' ou 'Error').
  3) Para cada linha restante, divide o texto em sentencas numeradas e
     manda ao GPT-5-mini, que responde com um JSON estruturado:
       - identified_contradiction: true/false
       - evidence_sentence_indices: indices das sentencas (0-based) que
         justificam a decisao (NAO pedimos ao modelo para citar o texto
         livremente -- ele so aponta o(s) indice(s), e o PRoPRIO CoDIGO
         reconstroi o trecho exato a partir do texto original, garantindo
         que a citacao nunca seja parafraseada/alterada pelo LLM juiz).
  4) Salva CHECKPOINT incremental (a cada N linhas) para poder retomar se
     cair no meio -- nao perde progresso nem refaz chamadas ja feitas.
  5) Ao final, adiciona as colunas ao CSV original e recalcula a acuracia
     da task 'contradiction' com o novo criterio (LLM vs LRM).
"""

import sys
import os
import re
import json
import time

import pandas as pd
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()  # le o arquivo .env na pasta atual (ou passe o caminho: load_dotenv("/caminho/para/.env"))

# ==============================================================================
# SPLIT EM SENTENCAS COM POSICOES EXATAS
# ==============================================================================
_SENTENCE_PATTERN = re.compile(r'[^.!?\n]*[.!?]+(?:\s+|$)|[^.!?\n]+(?:\n+|$)')


def split_into_sentences(text: str):
    """Divide o texto em 'sentencas' (por pontuacao final ou quebra de
    linha), preservando o texto EXATO original de cada uma (sem reescrever
    nada). Retorna lista de strings ja sem espacos nas pontas. Determinístico
    -- rodar duas vezes no mesmo texto sempre da os mesmos indices, entao
    e seguro reaplicar essa funcao depois (ao montar o CSV final) sem
    precisar guardar a sentenca inteira no checkpoint, so o indice."""
    sentences = []
    for m in _SENTENCE_PATTERN.finditer(text):
        s = m.group().strip()
        if s:
            sentences.append(s)
    return sentences

# ==============================================================================
# CONFIGURACAO
# ==============================================================================
DEFAULT_INPUT_CSV  = "./data/resultados_completos.csv"
DEFAULT_OUTPUT_CSV = "./data/resultados_completos_contradiction_judged.csv"
CHECKPOINT_JSON     = "contradiction_judgments_checkpoint.json"

MODEL_JUDGE   = "gpt-5.6-terra"
CHECKPOINT_EVERY = 10          # salva progresso a cada N chamadas
MAX_RETRIES   = 3
RETRY_SLEEP_S = 5

if not os.environ.get("OPENAI_API_KEY"):
    print("❌ OPENAI_API_KEY não encontrada. Verifique se o .env está na pasta "
          "atual e contém a linha: OPENAI_API_KEY=sk-...")
    sys.exit(1)

client = OpenAI()  # le OPENAI_API_KEY do ambiente (populado pelo load_dotenv acima)


SYSTEM_PROMPT = (
    "You are a strict evaluator. You will read a model's step-by-step "
    "reasoning about a logic problem (premises + conclusion), split into "
    "numbered sentences. One of the premises in the problem was "
    "deliberately injected to contradict another premise already in the "
    "set, making the premise set logically inconsistent.\n\n"
    "Your ONLY job: decide if the reasoning text EXPLICITLY states that "
    "the premises are contradictory, inconsistent, conflicting, or that "
    "one premise negates/contradicts another.\n\n"
    "Rules:\n"
    "- This must be an EXPLICIT statement ABOUT THE PREMISES THEMSELVES "
    "being in conflict with each other.\n"
    "- Simply concluding 'Uncertain' as the final answer, without "
    "explaining that the premises conflict, does NOT count.\n"
    "- General hedging or uncertainty about the conclusion (unrelated to "
    "premise conflict) does NOT count.\n"
    "- If the text points out that two specific premises say opposite "
    "things about the same fact (even without using the word "
    "'contradiction'), that DOES count.\n\n"
    "IMPORTANT -- do NOT quote or paraphrase the text yourself. Instead, "
    "point to the exact sentence(s) that justify your answer by their "
    "index number (shown in brackets before each sentence). Pick the "
    "MINIMUM number of sentence indices needed (usually just 1, at most 3) "
    "that best justify the decision. If identified_contradiction is false "
    "and no sentence is relevant, return an empty list.\n\n"
    "Always respond with valid JSON only, matching the requested schema."
)


def build_user_prompt(sentences: list) -> str:
    numbered = "\n".join(f"[{i}] {s}" for i, s in enumerate(sentences))
    return (
        "Reasoning text to evaluate (split into numbered sentences):\n"
        "-----\n"
        f"{numbered}\n"
        "-----\n\n"
        "Return ONLY a JSON object with exactly these fields:\n"
        '{\n'
        '  "identified_contradiction": true or false,\n'
        '  "evidence_sentence_indices": [list of integers, e.g. [3] or '
        '[2, 5], or [] if identified_contradiction is false and nothing '
        'is relevant]\n'
        '}'
    )


def judge_response(sentences: list) -> dict:
    """Chama o GPT-5.6-Terra e retorna
    {'identified_contradiction': bool, 'evidence_sentence_indices': list[int]}.
    Os indices se referem a posicoes na lista `sentences` (0-based)."""
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            resp = client.chat.completions.create(
                model=MODEL_JUDGE,
                messages=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": build_user_prompt(sentences)},
                ],
                response_format={"type": "json_object"},
            )
            content = resp.choices[0].message.content
            parsed = json.loads(content)
            raw_indices = parsed.get("evidence_sentence_indices", []) or []
            # sanitiza: mantem so indices validos (inteiros dentro do range)
            valid_indices = [
                i for i in raw_indices
                if isinstance(i, int) and 0 <= i < len(sentences)
            ]
            return {
                "identified_contradiction": bool(parsed.get("identified_contradiction", False)),
                "evidence_sentence_indices": valid_indices,
            }
        except Exception as e:
            print(f"⚠️  Tentativa {attempt}/{MAX_RETRIES} falhou: {e}")
            if attempt < MAX_RETRIES:
                time.sleep(RETRY_SLEEP_S)
            else:
                print("❌ Falhou definitivamente, marcando como erro.")
                return {
                    "identified_contradiction": None,
                    "evidence_sentence_indices": [],
                }


def extract_quote(sentences: list, indices: list) -> str:
    """Monta o trecho de evidencia a partir das sentencas ORIGINAIS (texto
    exato, nunca reescrito pelo modelo), unindo com ' [...] ' se os
    indices nao forem contiguos."""
    if not indices:
        return ""
    idx_sorted = sorted(indices)
    parts = []
    prev = None
    for i in idx_sorted:
        if prev is not None and i != prev + 1:
            parts.append("[...]")
        parts.append(sentences[i])
        prev = i
    return " ".join(parts)


# ==============================================================================
# CHECKPOINT (permite retomar sem refazer chamadas ja feitas)
# ==============================================================================
def load_checkpoint():
    if os.path.exists(CHECKPOINT_JSON):
        with open(CHECKPOINT_JSON, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}


def save_checkpoint(data):
    tmp = CHECKPOINT_JSON + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    os.replace(tmp, CHECKPOINT_JSON)


# ==============================================================================
# MAIN
# ==============================================================================
def main():
    input_csv  = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_INPUT_CSV
    output_csv = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_OUTPUT_CSV

    print(f"📂 Lendo {input_csv}...")
    df = pd.read_csv(input_csv)
    print(f"✅ {len(df)} linhas carregadas")

    mask_contradiction = df["task"] == "contradiction"
    mask_valid = (
        mask_contradiction
        & df["response"].notna()
        & (df["p"] != "SKIP")
        & (df["p"] != "Error")
    )
    subset = df[mask_valid]
    print(f"🎯 {len(subset)} linhas de 'contradiction' com resposta valida para julgar "
          f"(de {mask_contradiction.sum()} linhas totais dessa task)")

    checkpoint = load_checkpoint()
    print(f"🗄️  Checkpoint existente: {len(checkpoint)} julgamentos ja feitos")

    total = len(subset)
    done_now = 0

    for i, (idx, row) in enumerate(subset.iterrows(), start=1):
        key = f"{row['model']}_{row['id']}"

        if key in checkpoint:
            continue  # ja julgado em rodada anterior

        sentences = split_into_sentences(str(row["response"]))
        result = judge_response(sentences)
        checkpoint[key] = result
        done_now += 1

        status = "✅" if result["identified_contradiction"] else "❌"
        quote_preview = extract_quote(sentences, result["evidence_sentence_indices"])
        preview_short = (quote_preview[:80] + "...") if len(quote_preview) > 80 else quote_preview
        print(f"{status} [{i}/{total}] model={row['model']} id={row['id']} "
              f"-> identified={result['identified_contradiction']} | evidencia: {preview_short}")

        if done_now % CHECKPOINT_EVERY == 0:
            save_checkpoint(checkpoint)
            print(f"💾 Checkpoint salvo ({len(checkpoint)} julgamentos)")

    save_checkpoint(checkpoint)
    print(f"💾 Checkpoint final salvo ({len(checkpoint)} julgamentos)")

    # ==========================================================================
    # APLICA OS JULGAMENTOS DE VOLTA NO DATAFRAME COMPLETO
    # (o trecho de evidencia e reconstruido aqui, a partir do texto original
    # + indices salvos no checkpoint -- nunca do texto que o modelo "citou",
    # garantindo fidelidade 100% ao response original)
    # ==========================================================================
    df["identified_contradiction_gpt56terra"] = None
    df["evidence_quote_gpt56terra"] = None
    df["evidence_sentence_indices_gpt56terra"] = None
    df["correct_contradiction_v2"] = None  # so preenchido para task=='contradiction'

    for idx, row in df[mask_contradiction].iterrows():
        key = f"{row['model']}_{row['id']}"
        if key in checkpoint:
            j = checkpoint[key]
            sentences = split_into_sentences(str(row["response"])) if pd.notna(row["response"]) else []
            quote = extract_quote(sentences, j["evidence_sentence_indices"])
            df.at[idx, "identified_contradiction_gpt56terra"] = j["identified_contradiction"]
            df.at[idx, "evidence_quote_gpt56terra"] = quote
            df.at[idx, "evidence_sentence_indices_gpt56terra"] = json.dumps(j["evidence_sentence_indices"])
            df.at[idx, "correct_contradiction_v2"] = j["identified_contradiction"]

    df.to_csv(output_csv, index=False)
    print(f"\n✅ Salvo em: {output_csv}")

    # ==========================================================================
    # RELATORIO DE ACURACIA COM O NOVO CRITERIO
    # ==========================================================================
    print("\n" + "=" * 70)
    print("ACURÁCIA DA TASK 'contradiction' -- NOVO CRITÉRIO (GPT-5.6-Terra)")
    print("=" * 70)
    for model_label in ["LLM", "LRM"]:
        sub = df[(df["task"] == "contradiction") & (df["model"] == model_label)]
        julgados = sub[sub["identified_contradiction_gpt56terra"].notna()]
        n = len(julgados)
        if n == 0:
            print(f"  {model_label}: nenhum item julgado.")
            continue
        acertos = julgados["identified_contradiction_gpt56terra"].sum()
        print(f"  {model_label}: {acertos}/{n} = {100*acertos/n:.2f}% "
              f"identificaram explicitamente a contradição")


if __name__ == "__main__":
    main()