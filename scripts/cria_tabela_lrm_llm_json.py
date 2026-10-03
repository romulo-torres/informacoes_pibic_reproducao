"""
cria_tabela_lrm_jsonl.py
========================
Versão do cria_tabela_lrm_csv.py cuja ENTRADA é o JSONL do pipeline
(formato largo: uma linha por id, com p_original, p_nl, p_shuffled, ...),
somente para o LRM (DeepSeek-R1-Distill).

O script calcula 'correct' por conta própria (predição == gabarito) e, se
você quiser, exporta o CSV em formato longo (model, id, task, p, correct, ...)
com --export-csv.

GABARITO POR TASK
  Regras aplicadas em gt_efetivo() (editáveis no topo do arquivo):
    - negation:      gt invertido (True<->False; Uncertain fica Uncertain)
    - missing:       sempre Uncertain
    - contradiction: gt original
    - demais tasks:  gt original
  Se a linha tiver um campo gt_<task>, ele tem prioridade sobre essas regras.

PROMPT E RESPOSTA
  - response: lido de txt_<task> do results JSONL, já sem a cauda do prompt
    que vazou (ver limpa_resposta). tokens/duration_s/tps vêm de
    tokens_<task>/time_<task>/tps_<task> (valores por BATCH, não por exemplo).
  - prompt: vem do prompts_*.jsonl via --prompts, casando (split, id, task).
    Em duplicados, escolhe o que tem n_tokens_prompt == input_len.

SPLIT (TREINO / VALIDAÇÃO)
  O CSV tem a coluna 'split'. Ela vem do campo split/subset/partition/set do
  JSONL (se existir) ou de --split. IDs de treino e validação podem coincidir;
  por isso os pareamentos (LLM vs LRM) usam uid = split:id. Use --only-split
  validation para descartar linhas de treino das análises e do CSV.

MODO COM LLM (OPCIONAL)
  Se você passar --llm arquivo_llm.jsonl, o script também analisa o LLM
  (Llama-3.1-8B-Instruct) e acrescenta: acurácia lado a lado, McNemar
  LLM vs LRM (pareado por id), tabela combinada por bins e a tabela LaTeX
  com as duas colunas (Acurácia e Ganho para LLM e LRM). Sem --llm, tudo
  roda só para o LRM, como antes.

Uso (só LRM):
    python3 cria_tabela_lrm_jsonl.py results/results_DeepSeek-R1-Distill-Llama-8B_t06_fixed.jsonl
    python3 cria_tabela_lrm_jsonl.py arquivo.jsonl --out tabela_lrm.tex --export-csv resultados_lrm.csv

Uso (LLM + LRM):
    python3 cria_tabela_lrm_jsonl.py lrm.jsonl --llm llm.jsonl --out tabela.tex --export-csv resultados.csv
"""

import argparse
import json
import re
import sys
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path

import numpy as np
import pandas as pd
from scipy.stats import chi2, binomtest


DEFAULT_JSONL_PATH = "results/results_DeepSeek-R1-Distill-Llama-8B_t06_fixed.jsonl"
DEFAULT_MODEL = "LRM"
ALFA = 0.05
VALID_LABELS = {"True", "False", "Uncertain"}

TASK_TO_CAMPO = {
    "original":      "p_original",
    "nl":            "p_nl",
    "shuffled":      "p_shuffled",
    "junto":         "p_junto",
    "irrelevant":    "p_irrelevant",
    "missing":       "p_missing",
    "complex":       "p_complex",
    "contradiction": "p_contradiction",
    "negation":      "p_negation",
}
CAMPOS_PRED = list(TASK_TO_CAMPO.values())

# tasks em que o gabarito efetivo pode diferir de 'gt'
TASKS_GT_AJUSTADO = ["negation", "missing", "contradiction"]

NOMES_LEGIVEIS = {
    "p_original": "Original",
    "p_nl": "Linguagem Natural",
    "p_shuffled": "Premissas Embaralhadas",
    "p_junto": "Premissas Juntas (AND)",
    "p_irrelevant": "Ruído Irrelevante",
    "p_missing": "Premissa Faltante",
    "p_complex": "Duplicação de Premissas",
    "p_contradiction": "Contradição Injetada",
    "p_negation": "Negação Conclusão",
}


# ==============================================================================
# GABARITO EFETIVO (EDITE AQUI SE PRECISAR DE UMA REGRA PRÓPRIA)
# ==============================================================================
INVERTE_LABEL = {"True": "False", "False": "True", "Uncertain": "Uncertain"}


def gt_efetivo(row, task):
    """Gabarito usado para corrigir a predição da task.
      - se a linha tiver o campo gt_<task>, ele tem prioridade;
      - negation:     inverte o gt (True<->False, Uncertain fica Uncertain);
      - missing:      sempre Uncertain;
      - demais tasks (inclusive contradiction): gt original."""
    g = str(row.get("gt", "")).strip().capitalize()
    if f"gt_{task}" in row:
        return str(row[f"gt_{task}"]).strip().capitalize()
    if task == "negation":
        return INVERTE_LABEL.get(g, g)
    if task == "missing":
        return "Uncertain"
    return g


# ==============================================================================
# CARREGAMENTO DO JSONL -> DataFrame LARGO (com correct_<campo>)
# ==============================================================================
def load_jsonl(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows


# Campos por-consulta que vão para o CSV. Para cada um, o script procura no
# JSONL, para cada task, chaves como "<alias>_<task>" ou "<task>_<alias>"
# (ex.: response_original, r_nl, tokens_shuffled), ou um dict aninhado em
# row["<task>"]. Se o seu JSONL usa outros nomes, acrescente o alias aqui.
EXTRA_ALIASES = {
    "prompt":     ["prompt"],
    "response":   ["txt", "response", "resp", "r", "raw", "output", "completion", "generation"],
    "tokens":     ["tokens", "n_tokens", "out_tokens", "output_tokens"],
    "duration_s": ["time", "duration_s", "duration", "time_s", "elapsed_s", "elapsed"],
    "tps":        ["tps", "tokens_per_s"],
    "input_len":  ["input_len", "in_len", "prompt_len", "input_tokens"],
    "truncated":  ["truncated", "trunc"],
}
META_COLS = ["nl_wc", "fol_tc", "nl_bin", "fol_bin"]

COLUNAS_CSV = ["model", "id", "split", "task", "gt", "gt_effective", "p", "correct",
               "prompt", "response", "tokens", "duration_s", "tps",
               "input_len", "truncated"] + META_COLS

# Campo do JSONL que diz de qual partição o exemplo veio (treino/validação)
SPLIT_ALIASES = ["split", "subset", "partition", "set", "dataset_split", "fold"]
_SPLITS = {
    "train": "train", "training": "train", "treino": "train", "treinamento": "train",
    "validation": "validation", "val": "validation", "valid": "validation",
    "dev": "validation", "validacao": "validation", "validação": "validation",
    "test": "test", "teste": "test",
}


# ---------------------------------------------------------------------------
# Resposta do modelo e prompt
# ---------------------------------------------------------------------------
# No seu JSONL, txt_<task> NÃO é só a resposta: com left-padding em batch, o
# corte foi feito com o input_len de cada exemplo (e não o do batch), então o
# texto começa dentro do prompt (cauda do prompt + <｜Assistant｜> + geração).
# A resposta correta é o que vem DEPOIS do marcador do assistente.
MARC_ASSISTANT = "<\uff5cAssistant\uff5c>"
RE_BOXED = re.compile(r"\\boxed\{\s*(True|False|Uncertain)\s*\}", re.I)


def limpa_resposta(txt, prompt=None):
    """Retorna (resposta, status).
    status: vazio | limpo | vazamento_removido | marcador_no_texto"""
    if txt is None or (isinstance(txt, float) and txt != txt):
        return None, "vazio"
    txt = str(txt)
    i = txt.find(MARC_ASSISTANT)
    if i == -1:
        return txt, "limpo"
    cabeca = txt[:i].lstrip(" \ufffd")
    resto = txt[i + len(MARC_ASSISTANT):]
    if prompt:
        corpo = prompt.split(MARC_ASSISTANT)[0]
        if not corpo.endswith(cabeca):
            # o que vem antes do marcador não é cauda do prompt: não mexe
            return txt, "marcador_no_texto"
        if prompt.rstrip().endswith("<think>"):
            resto = re.sub(r"^<think>\s*", "", resto, count=1)
    return resto, "vazamento_removido"


def carrega_prompts(path):
    idx = defaultdict(list)
    for r in load_jsonl(path):
        k = (normaliza_split(r.get("split", "")), r.get("id"), r.get("task"))
        idx[k].append(r)
    return idx


def escolhe_prompt(idx, split, rid, task, input_len, esperado, stats):
    """Escolhe o prompt de (split, id, task). Se houver duplicados (re-execuções),
    prefere o que tem n_tokens_prompt == input_len do results; empate -> o mais
    recente pelo timestamp."""
    cands = idx.get((split, rid, task), [])
    if not cands:
        if esperado:
            stats["sem_prompt"] += 1
        return None
    if len(cands) > 1:
        stats["duplicados"] += 1
    if input_len is not None:
        ok = [c for c in cands if c.get("n_tokens_prompt") == input_len]
        if ok:
            cands = ok
        else:
            stats["input_len_diverge"] += 1
    stats["casados"] += 1
    return sorted(cands, key=lambda c: str(c.get("timestamp", "")))[-1].get("prompt")


def normaliza_split(v):
    s = str(v).strip().lower()
    return _SPLITS.get(s, s)


def pega_split(row, default):
    for k in SPLIT_ALIASES:
        if k in row and row[k] not in (None, ""):
            return normaliza_split(row[k])
    return normaliza_split(default) if default else "unknown"


def diagnostico_ids(wide):
    """Mostra o que há de estranho nos ids: repetidos, colisão entre splits,
    buracos na sequência."""
    ids = wide["id"]
    n, nu = len(wide), ids.nunique()
    print(f"IDs: {n} linhas, {nu} únicos, min={ids.min()}, max={ids.max()}")
    print(f"  Distribuição por split: {dict(Counter(wide['split']))}")

    if n != nu:
        dup = ids[ids.duplicated(keep=False)].unique()[:10].tolist()
        print(f"  ⚠️  {n - nu} linhas com id repetido (ex.: {dup}).")

    multi = wide.groupby("id")["split"].nunique()
    colide = multi[multi > 1]
    if len(colide):
        print(f"  ⚠️  {len(colide)} ids aparecem em mais de um split "
              f"(ex.: {colide.index[:10].tolist()}): ids colidem entre treino e "
              "validação. O script usa uid = split:id para parear/juntar.")

    if (wide["split"] == "unknown").all():
        print("  ℹ️  JSONL sem campo de split. Use --split validation|train para "
              "marcar a origem.")

    num = pd.to_numeric(ids, errors="coerce").dropna()
    if len(num) and num.nunique() != int(num.max() - num.min() + 1):
        print(f"  ℹ️  ids não contíguos: {int(num.max() - num.min() + 1) - num.nunique()} "
              "buracos entre min e max (normal se o dataset foi filtrado/subamostrado).")


def pega_extra(row, task, field):
    nested = row.get(task)
    if isinstance(nested, dict):
        for a in EXTRA_ALIASES[field]:
            if a in nested:
                return nested[a]
    for a in EXTRA_ALIASES[field]:
        for k in (f"{a}_{task}", f"{task}_{a}"):
            if k in row:
                return row[k]
    return None


def carregar_wide(path, split_default=None, only_split=None, prompts_path=None):
    rows = load_jsonl(path)
    if not rows:
        sys.exit(f"Arquivo vazio: {path}")

    campos_presentes = [c for c in CAMPOS_PRED if any(c in r for r in rows)]
    if not campos_presentes:
        sys.exit("Nenhuma coluna p_<task> encontrada no JSONL.")


    prompts_idx = carrega_prompts(prompts_path) if prompts_path else None
    stats_p, stats_r = Counter(), Counter()
    ids = [r.get("id") for r in rows]
    splits = [pega_split(r, split_default) for r in rows]
    out = {"id": ids, "split": splits,
           "uid": [f"{s}:{i}" for s, i in zip(splits, ids)],
           "gt": [r.get("gt") for r in rows]}
    for meta in ["nl_wc", "fol_tc", "nl_bin", "fol_bin"]:
        if any(meta in r for r in rows):
            out[meta] = [r.get(meta) for r in rows]

    for campo in campos_presentes:
        task = campo[2:]
        preds_brutas, corretos, gts = [], [], []
        extras = {f: [] for f in EXTRA_ALIASES}
        for r in rows:
            bruta = r.get(campo, "")
            pred = str(bruta).strip().capitalize()
            g = gt_efetivo(r, task)
            preds_brutas.append(bruta)
            gts.append(g)
            if pred in VALID_LABELS:
                corretos.append(pred == g)
            else:
                corretos.append(np.nan)   # SKIP / ERROR / inválida
            for f in EXTRA_ALIASES:
                extras[f].append(pega_extra(r, task, f))

        # tps: se não veio no JSONL, calcula tokens / duration_s quando possível
        if all(v is None for v in extras["tps"]):
            extras["tps"] = [
                (t / d) if (t is not None and d not in (None, 0)) else None
                for t, d in zip(extras["tokens"], extras["duration_s"])
            ]

        # prompt vem do prompts_*.jsonl (se informado)
        if prompts_idx is not None:
            for j, r in enumerate(rows):
                if extras["prompt"][j] is None:
                    esperado = str(r.get(campo, "")).strip() not in ("", "SKIP")
                    extras["prompt"][j] = escolhe_prompt(
                        prompts_idx, splits[j], ids[j], task,
                        extras["input_len"][j], esperado, stats_p)

        # resposta: remove a cauda do prompt que vazou em txt_<task>
        for j in range(len(rows)):
            resp, st = limpa_resposta(extras["response"][j], extras["prompt"][j])
            extras["response"][j] = resp
            stats_r[st] += 1
            pred = str(preds_brutas[j]).strip().capitalize()
            if resp is not None and pred in VALID_LABELS:
                achados = RE_BOXED.findall(resp)
                stats_r["boxed_checados"] += 1
                if not achados:
                    stats_r["boxed_ausente"] += 1
                elif achados[-1].capitalize() != pred:
                    stats_r["boxed_diverge"] += 1

        out[campo] = preds_brutas
        out[f"correct_{campo}"] = corretos
        out[f"gt_effective_{campo}"] = gts
        for f, vals in extras.items():
            out[f"{campo}__{f}"] = vals

    if stats_r.get("vazio", 0) < sum(stats_r[k] for k in
            ("vazio", "limpo", "vazamento_removido", "marcador_no_texto")):
        print("Respostas (arquivo inteiro): "
              f"vazamento de prompt removido={stats_r['vazamento_removido']} | "
              f"já limpas={stats_r['limpo']} | "
              f"marcador sem cauda de prompt (mantidas)={stats_r['marcador_no_texto']} | "
              f"sem texto={stats_r['vazio']}")
        print("  Checagem do \\boxed (última ocorrência da resposta vs p_<task>): "
              f"checados={stats_r['boxed_checados']} | divergem={stats_r['boxed_diverge']} | "
              f"sem \\boxed={stats_r['boxed_ausente']}")
    if prompts_idx is not None:
        print("Prompts: "
              f"casados={stats_p['casados']} | sem prompt={stats_p['sem_prompt']} | "
              f"(id,task) duplicados no arquivo={stats_p['duplicados']} | "
              f"n_tokens_prompt != input_len={stats_p['input_len_diverge']}")
    df = pd.DataFrame(out)
    if only_split:
        alvo = normaliza_split(only_split)
        antes = len(df)
        df = df[df["split"] == alvo].reset_index(drop=True)
        print(f"Filtro --only-split {alvo}: {antes} -> {len(df)} linhas")
        if df.empty:
            sys.exit(f"Nenhuma linha com split == '{alvo}'.")
    df.attrs["chaves_jsonl"] = sorted({k for r in rows for k in r})
    df.attrs["extras_faltando"] = [
        f for f in EXTRA_ALIASES
        if all(df[f"{c}__{f}"].isna().all() for c in campos_presentes)
    ]
    df.attrs["meta_faltando"] = [m for m in META_COLS if m not in df.columns]
    return df


def exportar_csv_longo(modelos, path):
    """Gera o CSV em formato longo: model, id, task, p, correct, gt, metas.
    'modelos' é um dict {rótulo_do_modelo: DataFrame largo}."""
    partes = []
    for model_label, wide in modelos.items():
        for campo in CAMPOS_PRED:
            if campo not in wide.columns:
                continue
            sub = pd.DataFrame({
                "model": model_label,
                "id": wide["id"],
                "split": wide["split"],
                "task": campo[2:],
                "gt": wide["gt"],
                "gt_effective": wide[f"gt_effective_{campo}"],
                "p": wide[campo],
                "correct": wide[f"correct_{campo}"],
            })
            for f in EXTRA_ALIASES:
                sub[f] = wide[f"{campo}__{f}"]
            for m in META_COLS:
                sub[m] = wide[m] if m in wide.columns else None
            partes.append(sub)

        faltam = wide.attrs.get("extras_faltando", []) + wide.attrs.get("meta_faltando", [])
        if faltam:
            print(f"⚠️  [{model_label}] colunas sem fonte no JSONL (saíram vazias no CSV): "
                  f"{faltam}\n    chaves encontradas no JSONL: "
                  f"{wide.attrs.get('chaves_jsonl')}\n    "
                  "Se existirem com outro nome, acrescente o alias em EXTRA_ALIASES.")

    longo = pd.concat(partes, ignore_index=True)
    longo["p"] = longo["p"].replace("", "SKIP").fillna("SKIP")
    longo[COLUNAS_CSV].to_csv(path, index=False)
    print(f"CSV longo salvo em {path} ({len(longo)} linhas)")


# ==============================================================================
# 1. DIAGNÓSTICO GERAL
# ==============================================================================
def diagnostico_geral(wide, label):
    print("=" * 70)
    print(f"DIAGNÓSTICO GERAL -- {label}")
    print("=" * 70)
    print(f"Número de exemplos (ids): {len(wide)}")
    diagnostico_ids(wide)
    campos_p = [c for c in CAMPOS_PRED if c in wide.columns]
    print(f"Campos de predição encontrados: {campos_p}")
    print(f"\nDistribuição do gold label (gt): {dict(Counter(wide['gt']))}")
    for campo in ["nl_bin", "fol_bin"]:
        if campo in wide.columns:
            print(f"Distribuição de {campo}: {dict(Counter(wide[campo]))}")


# ==============================================================================
# 2. ACURÁCIA
# ==============================================================================
def acuracia(wide, campo_pred):
    """(corretos, válidos, acurácia %)"""
    col = f"correct_{campo_pred}"
    if col not in wide.columns:
        return 0, 0, float("nan")
    serie = wide[col]
    tot = int(serie.notna().sum())
    c = int(serie.eq(True).sum())
    return c, tot, (100 * c / tot if tot else float("nan"))


def tabela_acuracia(wide, label):
    print("\n" + "=" * 70)
    print(f"ACURÁCIA POR TRANSFORMAÇÃO -- {label}")
    print("=" * 70)
    print(f"  {'Transformação':<26s}{'corretos':>10s}{'n':>7s}{'acc':>10s}")
    print("  " + "-" * 53)
    for campo in CAMPOS_PRED:
        if campo not in wide.columns:
            continue
        c, n, pct = acuracia(wide, campo)
        print(f"  {NOMES_LEGIVEIS[campo]:<26s}{c:>10d}{n:>7d}{pct:>9.2f}%")


# ==============================================================================
# 3. PREDIÇÕES IDÊNTICAS (bug de pipeline) -- compara predição BRUTA
# ==============================================================================
def checar_predicoes_identicas(wide, label):
    print("\n" + "=" * 70)
    print(f"VERIFICANDO PREDIÇÕES IDÊNTICAS ENTRE TRANSFORMAÇÕES -- {label}")
    print("=" * 70)

    alerta = False
    for a, b in combinations(CAMPOS_PRED, 2):
        if a not in wide.columns or b not in wide.columns:
            continue
        sa, sb = wide[a].astype(str), wide[b].astype(str)
        ok = (~sa.isin(["SKIP", "", "nan"])) & (~sb.isin(["SKIP", "", "nan"]))
        n = int(ok.sum())
        if n == 0:
            continue
        iguais = int(((sa == sb) & ok).sum())
        pct = 100 * iguais / n
        if pct == 100.0:
            alerta = True
            print(f"  [ALERTA] {a} == {b} em TODAS as {n} linhas comparáveis.")
        elif pct >= 95.0:
            alerta = True
            print(f"  [suspeito] {a} vs {b}: {iguais}/{n} idênticas ({pct:.2f}%).")
    if not alerta:
        print("  Nenhum par de transformações com predições >=95% idênticas.")


# ==============================================================================
# 4. McNEMAR -- Original vs. cada perturbação
# ==============================================================================
def mcnemar_manual(b, c):
    """(estatística, p). Exato (binomial) se b+c < 25; senão qui-quadrado com
    correção de continuidade. Estatística = nan quando exato."""
    n_disc = b + c
    if n_disc == 0:
        return 0.0, 1.0
    if n_disc < 25:
        return float("nan"), binomtest(min(b, c), n_disc, 0.5).pvalue
    estat = (abs(b - c) - 1) ** 2 / n_disc
    return estat, float(chi2.sf(estat, df=1))


def teste_mcnemar_geral(wide, label, campo_base="p_original", alfa=ALFA):
    print("\n" + "=" * 70)
    print(f"TESTE DE MCNEMAR -- {label} ({campo_base} vs. cada perturbação)")
    print("=" * 70)

    col_base = f"correct_{campo_base}"
    resultado = {}
    if col_base not in wide.columns:
        print("  p_original não encontrado; teste não aplicável.")
        return resultado

    for campo in CAMPOS_PRED:
        col_pert = f"correct_{campo}"
        if campo == campo_base or col_pert not in wide.columns:
            continue

        validos = wide[col_base].notna() & wide[col_pert].notna()
        n = int(validos.sum())
        if n == 0:
            continue

        base_ok = wide.loc[validos, col_base].astype(bool)
        pert_ok = wide.loc[validos, col_pert].astype(bool)

        b = int((base_ok & ~pert_ok).sum())   # original acertou, perturbação errou
        c = int((~base_ok & pert_ok).sum())   # original errou, perturbação acertou

        estat, p = mcnemar_manual(b, c)
        sig = p < alfa

        acc_base = 100 * base_ok.mean()
        acc_pert = 100 * pert_ok.mean()
        ganho = 100 * (acc_pert - acc_base) / acc_base if acc_base else float("nan")

        estat_str = "  exato " if np.isnan(estat) else f"{estat:7.3f}"
        print(
            f"  {NOMES_LEGIVEIS[campo]:26s} n={n:4d}  acc_orig={acc_base:6.2f}%  "
            f"acc_pert={acc_pert:6.2f}%  ganho={ganho:+6.1f}%  "
            f"b={b:3d} c={c:3d}  estat={estat_str}  p={p:.4f} {'*' if sig else ' '}"
        )
        resultado[campo] = {"b": b, "c": c, "estat": estat, "p": p,
                            "sig": sig, "ganho": ganho, "n": n}

    print(f"\n(*) p < {alfa}: diferença significativa (McNemar). "
          "b = original acertou/perturbação errou; c = o inverso.")
    return resultado


# ==============================================================================
# 5/6. TABELAS POR TAMANHO (só se o JSONL tiver os campos de meta-dados)
# ==============================================================================
def tabela_por_tercis(wide, label, campo_wc="nl_wc", campo_pred="p_original"):
    print("\n" + "=" * 70)
    print(f"TABELA POR TERCIS DE {campo_wc} -- {label} (campo_pred={campo_pred})")
    print("=" * 70)

    col = f"correct_{campo_pred}"
    if campo_wc not in wide.columns or col not in wide.columns:
        print(f"  Campo '{campo_wc}' não existe no JSONL; seção ignorada.")
        return

    df = wide[wide[col].notna() & wide[campo_wc].notna()].copy()
    df["tercil"], bins = pd.qcut(df[campo_wc], 3, retbins=True, labels=False,
                                 duplicates="drop")
    df = df.dropna(subset=["tercil"])
    if df.empty:
        print(f"  Valores de {campo_wc} insuficientes/idênticos para formar tercis.")
        return
    for t in sorted(df["tercil"].unique()):
        sub = df[df["tercil"] == t]
        acc = 100 * sub[col].astype(bool).mean()
        print(f"  Tercil {int(t)+1}: faixa {sub[campo_wc].min()}-{sub[campo_wc].max()} "
              f"| n={len(sub)} | acurácia={acc:.2f}%")
    print(f"\n  (cortes reais dos tercis: {bins.round(1).tolist()})")


def tabela_por_bins(wide, label, campo_pred="p_original"):
    print("\n" + "=" * 70)
    print(f"TABELA POR BINS Q1-Q4 -- {label} (campo_pred={campo_pred})")
    print("=" * 70)

    col = f"correct_{campo_pred}"
    if col not in wide.columns:
        return
    df = wide[wide[col].notna()].copy()

    for campo_bin, campo_val, unidade, titulo in [
        ("nl_bin", "nl_wc", "palavras", "nl_bin (nº de palavras)"),
        ("fol_bin", "fol_tc", "tokens FOL", "fol_bin (nº de tokens FOL)"),
    ]:
        if campo_bin not in df.columns or campo_val not in df.columns:
            print(f"{titulo}: campos ausentes no JSONL; ignorado.\n")
            continue
        print(f"{titulo}:")
        for b in ["Q1", "Q2", "Q3", "Q4"]:
            sub = df[df[campo_bin] == b]
            if len(sub) == 0:
                continue
            acc = 100 * sub[col].astype(bool).mean()
            print(f"  {b}: faixa {sub[campo_val].min()}-{sub[campo_val].max()} {unidade} "
                  f"| n={len(sub)} | acurácia={acc:.2f}%")
        print()


# ==============================================================================
# 7. TABELA LATEX (modelo único)
# ==============================================================================
def gerar_tabela_latex(wide, resultado_mcnemar, model_label):
    _, _, acc_orig = acuracia(wide, "p_original")

    linhas = [
        r"\begin{table}[ht]",
        r"\centering",
        rf"\caption{{Acurácia e ganho relativo do modelo {model_label} por "
        r"perturbação ($T=0{,}6$). O símbolo (*) em \textbf{Ganho} indica "
        r"variação estatisticamente significativa entre a condição Original e "
        r"a perturbação (teste de McNemar pareado por exemplo, $p<0{,}05$; "
        r"exato quando $b+c<25$).}",
        r"\label{tab:lrm_perturbacoes}",
        r"\sisetup{",
        r"  output-decimal-marker={,},",
        r"  table-format=-2.1,",
        r"  table-space-text-post={*}",
        r"}",
        r"\begin{tabular}{l",
        r"  S[table-format=2.1]",
        r"  S[table-format=-3.1, table-space-text-post={*}]",
        r"  S[table-format=3.0]",
        r"}",
        r"\toprule",
        r"\textbf{Perturbação} & {\textbf{Acurácia (\%)}} & "
        r"{\textbf{Ganho (\%)}} & {\textbf{$n$}} \\",
        r"\midrule",
    ]

    for campo in CAMPOS_PRED:
        if campo not in wide.columns:
            continue
        _, n, acc = acuracia(wide, campo)
        if n == 0:
            continue
        nome = NOMES_LEGIVEIS[campo]
        if campo == "p_original":
            ganho_str = "{--}"
        else:
            r = resultado_mcnemar.get(campo)
            ganho = 100 * (acc - acc_orig) / acc_orig if acc_orig else float("nan")
            estrela = "*" if (r and r["sig"]) else ""
            ganho_str = "{--}" if ganho != ganho else f"{ganho:+.1f}{estrela}"
        linhas.append(rf"{nome} & {acc:.1f} & {ganho_str} & {n} \\")

    linhas += [r"\bottomrule", r"\end{tabular}", r"\end{table}"]
    return "\n".join(linhas)


# ==============================================================================
# EXTRAS (SÓ COM --llm): COMPARAÇÃO LLM vs LRM
# ==============================================================================
def acuracia_combinada(wide_llm, wide_lrm):
    print("\n" + "=" * 70)
    print("ACURÁCIA POR TRANSFORMAÇÃO -- LLM vs LRM, LADO A LADO")
    print("=" * 70)
    print(f"  {'Transformação':<26s}{'n_LLM':>7s}{'acc_LLM':>10s}"
          f"{'n_LRM':>7s}{'acc_LRM':>10s}")
    print("  " + "-" * 60)
    for campo in CAMPOS_PRED:
        if campo not in wide_llm.columns and campo not in wide_lrm.columns:
            continue
        _, n_llm, p_llm = acuracia(wide_llm, campo)
        _, n_lrm, p_lrm = acuracia(wide_lrm, campo)
        print(f"  {NOMES_LEGIVEIS[campo]:<26s}{n_llm:>7d}{p_llm:>9.2f}%"
              f"{n_lrm:>7d}{p_lrm:>9.2f}%")


def teste_mcnemar_llm_vs_lrm(wide_llm, wide_lrm, alfa=ALFA):
    """McNemar pareado por id, mesma condição, LLM vs LRM."""
    print("\n" + "=" * 70)
    print("TESTE DE MCNEMAR -- LLM vs. LRM (pareado por id, mesma condição)")
    print("=" * 70)

    resultado = {}
    for campo in CAMPOS_PRED:
        col = f"correct_{campo}"
        if col not in wide_llm.columns or col not in wide_lrm.columns:
            continue

        m = wide_llm[["uid", col]].merge(wide_lrm[["uid", col]], on="uid",
                                        suffixes=("_llm", "_lrm"))
        m = m[m[f"{col}_llm"].notna() & m[f"{col}_lrm"].notna()]
        n = len(m)
        if n == 0:
            continue

        ok_llm = m[f"{col}_llm"].astype(bool)
        ok_lrm = m[f"{col}_lrm"].astype(bool)

        b = int((ok_llm & ~ok_lrm).sum())   # LLM acertou, LRM errou
        c = int((~ok_llm & ok_lrm).sum())   # LLM errou, LRM acertou

        estat, p = mcnemar_manual(b, c)
        sig = p < alfa
        estat_str = "  exato " if np.isnan(estat) else f"{estat:7.3f}"
        print(
            f"  {NOMES_LEGIVEIS[campo]:26s} n={n:4d}  "
            f"acc_LLM={100 * ok_llm.mean():6.2f}%  acc_LRM={100 * ok_lrm.mean():6.2f}%  "
            f"b={b:3d} c={c:3d}  estat={estat_str}  p={p:.4f} {'*' if sig else ' '}"
        )
        resultado[campo] = {"b": b, "c": c, "estat": estat, "p": p,
                            "sig": sig, "n": n}

    print(f"\n(*) p < {alfa}. b = LLM acertou/LRM errou; c = LLM errou/LRM acertou.")
    return resultado


def tabela_combinada_por_bins(wide_llm, wide_lrm, campo_pred="p_original"):
    print("\n" + "=" * 70)
    print(f"TABELA COMBINADA LLM vs LRM POR BIN (campo_pred={campo_pred})")
    print("=" * 70)

    col = f"correct_{campo_pred}"
    if col not in wide_llm.columns or col not in wide_lrm.columns:
        return

    for campo_bin, titulo in [("nl_bin", "nl_bin (nº de palavras)"),
                              ("fol_bin", "fol_bin (nº de tokens FOL)")]:
        if campo_bin not in wide_llm.columns:
            print(f"{titulo}: campo ausente no JSONL do LLM; ignorado.\n")
            continue
        m = wide_llm[["uid", campo_bin, col]].merge(
            wide_lrm[["uid", col]], on="uid", suffixes=("_LLM", "_LRM"))
        print(f"Por {titulo}:")
        for b in ["Q1", "Q2", "Q3", "Q4"]:
            sub = m[m[campo_bin] == b]
            if len(sub) == 0:
                continue
            s_llm = sub[sub[f"{col}_LLM"].notna()]
            s_lrm = sub[sub[f"{col}_LRM"].notna()]
            a_llm = 100 * s_llm[f"{col}_LLM"].astype(bool).mean() if len(s_llm) else float("nan")
            a_lrm = 100 * s_lrm[f"{col}_LRM"].astype(bool).mean() if len(s_lrm) else float("nan")
            print(f"  {b}: n={len(sub):3d} | LLM: n={len(s_llm):3d} acc={a_llm:6.2f}% | "
                  f"LRM: n={len(s_lrm):3d} acc={a_lrm:6.2f}%")
        print()


def gerar_tabela_latex_dupla(wide_llm, wide_lrm, mc_llm, mc_lrm, mc_cross):
    _, _, base_llm = acuracia(wide_llm, "p_original")
    _, _, base_lrm = acuracia(wide_lrm, "p_original")

    def f(v, star=False, signed=False):
        if v != v:
            return "{--}"
        s = f"{v:+.1f}" if signed else f"{v:.1f}"
        return s + ("*" if star else "")

    linhas = [
        r"\begin{table}[ht]",
        r"\centering",
        r"\caption{Comparação de acurácia e ganho relativo entre LLM e LRM "
        r"($T=0{,}6$). O símbolo (*) em \textbf{Ganho} indica variação "
        r"significativa entre Original e a perturbação, no mesmo modelo "
        r"(McNemar, $p<0{,}05$). Em \textbf{Acurácia}, (*) indica diferença "
        r"significativa entre LLM e LRM na mesma condição (McNemar pareado).}",
        r"\label{tab:comparacao_llm_lrm}",
        r"\sisetup{",
        r"  output-decimal-marker={,},",
        r"  table-format=-2.1,",
        r"  table-space-text-post={*}",
        r"}",
        r"\resizebox{\textwidth*4/6}{!}{%",
        r"\begin{tabular}{l",
        r"  S[table-format=2.1, table-space-text-post={*}]",
        r"  S[table-format=2.1, table-space-text-post={*}]",
        r"  S[table-format=-3.1, table-space-text-post={*}]",
        r"  S[table-format=-3.1, table-space-text-post={*}]",
        r"}",
        r"\toprule",
        r"\textbf{Perturbação} & \multicolumn{2}{c}{\textbf{Acurácia (\%)}} "
        r"& \multicolumn{2}{c}{\textbf{Ganho (\%)}} \\",
        r"\cmidrule(lr){2-3} \cmidrule(lr){4-5}",
        r"& {LLM} & {LRM} & {LLM} & {LRM} \\",
        r"\midrule",
    ]

    for campo in CAMPOS_PRED:
        if campo not in wide_llm.columns or campo not in wide_lrm.columns:
            continue
        _, _, acc_llm = acuracia(wide_llm, campo)
        _, _, acc_lrm = acuracia(wide_lrm, campo)

        star = campo in mc_cross and mc_cross[campo]["sig"]
        if acc_llm == acc_lrm or acc_llm != acc_llm or acc_lrm != acc_lrm:
            cell_llm, cell_lrm = f(acc_llm, star), f(acc_lrm, star)
        elif acc_llm > acc_lrm:
            cell_llm = "{" + r"\textbf{" + f(acc_llm, star) + "}}"
            cell_lrm = f(acc_lrm)
        else:
            cell_llm = f(acc_llm)
            cell_lrm = "{" + r"\textbf{" + f(acc_lrm, star) + "}}"

        if campo == "p_original":
            g_llm = g_lrm = "{--}"
        else:
            gl = 100 * (acc_llm - base_llm) / base_llm if base_llm else float("nan")
            gr = 100 * (acc_lrm - base_lrm) / base_lrm if base_lrm else float("nan")
            g_llm = f(gl, mc_llm.get(campo, {}).get("sig", False), signed=True)
            g_lrm = f(gr, mc_lrm.get(campo, {}).get("sig", False), signed=True)

        linhas.append(rf"{NOMES_LEGIVEIS[campo]} & {cell_llm} & {cell_lrm} "
                      rf"& {g_llm} & {g_lrm} \\")

    linhas += [r"\bottomrule", r"\end{tabular}%", r"}", r"\end{table}"]
    return "\n".join(linhas)


# ==============================================================================
# MAIN
# ==============================================================================
def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("jsonl", nargs="?", default=DEFAULT_JSONL_PATH,
                    help="JSONL de resultados do LRM")
    ap.add_argument("--model", default=DEFAULT_MODEL,
                    help=f"rótulo do modelo usado nas saídas (padrão: {DEFAULT_MODEL})")
    ap.add_argument("--llm", default=None,
                    help="(opcional) JSONL do LLM/Instruct; ativa a comparação LLM vs LRM")
    ap.add_argument("--llm-model", default="LLM",
                    help="rótulo do LLM nas saídas (padrão: LLM)")
    ap.add_argument("--prompts", default=None,
                    help="prompts_*.jsonl do LRM (preenche a coluna 'prompt')")
    ap.add_argument("--prompts-llm", default=None,
                    help="prompts_*.jsonl do LLM (só com --llm)")
    ap.add_argument("--split", default=None,
                    help="origem dos exemplos quando o JSONL não tem campo de split "
                         "(ex.: validation ou train); vai para a coluna 'split'")
    ap.add_argument("--only-split", default=None,
                    help="usa só linhas desse split (ex.: validation) nas análises e no CSV")
    ap.add_argument("--out", default=None, help="salva a tabela LaTeX (.tex)")
    ap.add_argument("--export-csv", default=None,
                    help="salva o CSV em formato longo (model,id,task,p,correct,...)")
    args = ap.parse_args()

    print(f"Arquivo JSONL (LRM): {args.jsonl}\n")
    wide = carregar_wide(args.jsonl, args.split, args.only_split, args.prompts)
    label = f"{args.model} (DeepSeek-R1-Distill)"

    wide_llm = None
    label_llm = f"{args.llm_model} (Llama-3.1-8B-Instruct)"
    if args.llm:
        print(f"Arquivo JSONL (LLM): {args.llm}\n")
        wide_llm = carregar_wide(args.llm, args.split, args.only_split, args.prompts_llm)

    if args.export_csv:
        modelos = {args.model: wide}
        if wide_llm is not None:
            modelos[args.llm_model] = wide_llm
        exportar_csv_longo(modelos, args.export_csv)

    # --- análises individuais -------------------------------------------------
    resultado_llm = None
    if wide_llm is not None:
        diagnostico_geral(wide_llm, label_llm)
    diagnostico_geral(wide, label)

    if wide_llm is not None:
        acuracia_combinada(wide_llm, wide)
    else:
        tabela_acuracia(wide, label)

    if wide_llm is not None:
        checar_predicoes_identicas(wide_llm, label_llm)
    checar_predicoes_identicas(wide, label)

    if wide_llm is not None:
        resultado_llm = teste_mcnemar_geral(wide_llm, label_llm)
    resultado = teste_mcnemar_geral(wide, label)

    resultado_cross = None
    if wide_llm is not None:
        resultado_cross = teste_mcnemar_llm_vs_lrm(wide_llm, wide)

    if wide_llm is not None:
        tabela_por_tercis(wide_llm, label_llm)
    tabela_por_tercis(wide, label)
    if wide_llm is not None:
        tabela_por_bins(wide_llm, label_llm)
    tabela_por_bins(wide, label)
    if wide_llm is not None:
        tabela_combinada_por_bins(wide_llm, wide)

    if wide_llm is not None:
        latex = gerar_tabela_latex_dupla(wide_llm, wide, resultado_llm,
                                         resultado, resultado_cross)
    else:
        latex = gerar_tabela_latex(wide, resultado, args.model)
    print("\n" + "=" * 70)
    print("TABELA LATEX")
    print("=" * 70)
    print(latex)

    if args.out:
        Path(args.out).write_text(latex, encoding="utf-8")
        print(f"\nTabela salva em {args.out}")


if __name__ == "__main__":
    main()