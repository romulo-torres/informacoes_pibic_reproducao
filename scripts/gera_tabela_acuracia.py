"""
gera_tabela_acuracia_completa.py
================================
Lê os JSONLs de resultado e gera, para TODAS as perturbações presentes:

  1. tabela_acuracia.tex   -> acurácia + ganho relativo (com * de significância)
  2. tabela_detalhada.tex  -> acertos/n válidos + p-valores de McNemar
  3. resumo.csv            -> mesmos números da tabela detalhada, em CSV
  4. por_consulta.csv      -> uma linha por (modelo, task, id): gt, pred, correto

Só entram na tabela as tasks que tiverem pelo menos uma predição válida
no(s) JSONL(s) (colunas p_<task>), então tasks não rodadas são ignoradas.

Uso (dois modelos):
    python3 gera_tabela_acuracia_completa.py --instruct A.jsonl --rl B.jsonl

Uso (um modelo só):
    python3 gera_tabela_acuracia_completa.py --rl B.jsonl

Opções:
    --out-dir DIR     pasta de saída (padrão: tabelas_saida)
    --tasks a b c     restringe/ordena as tasks manualmente

Gabarito por task: se a linha tiver o campo "gt_<task>" ele é usado; caso
contrário usa "gt". Isso importa para perturbações que mudam a resposta
correta (ex.: missing, contradiction, negation).
"""

import argparse
import csv
import json
import sys
from pathlib import Path

from scipy.stats import chi2, binomtest

# ==============================================================================
# CONFIGURAÇÃO
# ==============================================================================
DEFAULT_INSTRUCT_PATH = None  # opcional
DEFAULT_RL_PATH = "results/results_DeepSeek-R1-Distill-Llama-8B_t06_fixed.jsonl"

TASK_DISPLAY = {
    "original":      "Original",
    "nl":            "Linguagem Natural",
    "shuffled":      "Embaralhado",
    "junto":         "Junto",
    "irrelevant":    "Irrelevante",
    "missing":       "Informação Ausente",
    "complex":       "Complexo",
    "contradiction": "Contradição",
    "negation":      "Negação",
}
TASK_ORDER = list(TASK_DISPLAY)
VALID_LABELS = {"True", "False", "Uncertain"}
ALPHA = 0.05
EXACT_THRESHOLD = 25  # b+c abaixo disso -> teste binomial exato


# ==============================================================================
# LEITURA E ACURÁCIA
# ==============================================================================
def load_jsonl(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows


def get_pred(row, task):
    val = str(row.get(f"p_{task}", "")).strip().capitalize()
    return val if val in VALID_LABELS else ""


def get_gt(row, task):
    raw = row.get(f"gt_{task}", row.get("gt", ""))
    return str(raw).strip().capitalize()


def accuracy(rows, task):
    """(acurácia %, corretos, válidos)"""
    c = n = 0
    for r in rows:
        p = get_pred(r, task)
        if not p:
            continue
        n += 1
        c += p == get_gt(r, task)
    return (c / n * 100 if n else float("nan")), c, n


def detect_tasks(*row_sets):
    found = set()
    for rows in row_sets:
        if rows is None:
            continue
        for t in TASK_ORDER:
            if any(get_pred(r, t) for r in rows):
                found.add(t)
    return [t for t in TASK_ORDER if t in found]


# ==============================================================================
# McNEMAR
# ==============================================================================
def mcnemar(rows_a, rows_b, task_a, task_b):
    """
    McNemar pareado por id. Retorna (p, b, c).
    b+c >= 25: qui-quadrado com correção de continuidade (Edwards/Dietterich).
    b+c <  25: binomial exato bilateral.
    p = None se b+c == 0.
    """
    ia = {r["id"]: r for r in rows_a}
    ib = {r["id"]: r for r in rows_b}
    b = c = 0  # b: A errou/B acertou ; c: A acertou/B errou
    for k in set(ia) & set(ib):
        pa, pb = get_pred(ia[k], task_a), get_pred(ib[k], task_b)
        if not pa or not pb:
            continue
        ok_a = pa == get_gt(ia[k], task_a)
        ok_b = pb == get_gt(ib[k], task_b)
        if ok_a and not ok_b:
            c += 1
        elif ok_b and not ok_a:
            b += 1
    if b + c == 0:
        return None, b, c
    if b + c < EXACT_THRESHOLD:
        p = binomtest(min(b, c), b + c, 0.5).pvalue
    else:
        p = chi2.sf((abs(b - c) - 1) ** 2 / (b + c), df=1)
    return p, b, c


# ==============================================================================
# ESTATÍSTICAS POR TASK
# ==============================================================================
def compute_stats(rows_llm, rows_lrm, tasks):
    """rows_llm pode ser None (modo single-model)."""
    models = {"LRM": rows_lrm}
    if rows_llm is not None:
        models = {"LLM": rows_llm, "LRM": rows_lrm}

    base = {m: accuracy(r, "original")[0] if "original" in tasks else float("nan")
            for m, r in models.items()}

    stats = []
    for t in tasks:
        s = {"task": t}
        for m, r in models.items():
            acc, c, n = accuracy(r, t)
            s[f"acc_{m}"], s[f"c_{m}"], s[f"n_{m}"] = acc, c, n
            if t == "original" or base[m] != base[m] or base[m] == 0:
                s[f"gain_{m}"], s[f"pgain_{m}"] = float("nan"), None
            else:
                s[f"gain_{m}"] = (acc - base[m]) / base[m] * 100
                s[f"pgain_{m}"] = mcnemar(r, r, "original", t)[0]
        if rows_llm is not None:
            s["pmodels"] = mcnemar(rows_llm, rows_lrm, t, t)[0]
        stats.append(s)
    return stats, list(models)


# ==============================================================================
# FORMATAÇÃO
# ==============================================================================
NA = r"\text{--}"


def sig(p):
    return p is not None and p < ALPHA


def fmt_num(v, star=False, signed=False):
    if v != v:
        return NA
    s = f"{v:+.1f}" if signed else f"{v:.1f}"
    return s + ("*" if star else "")


def fmt_p(p):
    if p is None:
        return "--"
    if p < 0.001:
        return "<0{,}001"
    return f"{p:.3f}".replace(".", "{,}")


def bold(s):
    return r"\textbf{" + s + "}"


def build_main_table(stats, models):
    two = len(models) == 2
    ncol = len(models)
    scol = "  S[table-format=2.1, table-space-text-post={*}]\n"
    gcol = "  S[table-format=-2.1, table-space-text-post={*}]\n"
    spec = "l\n" + scol * ncol + gcol * ncol

    L = [
        r"\begin{table}[ht]", r"\centering",
        r"\caption{Acurácia e ganho relativo por perturbação ($T=0{,}6$). "
        r"(*) em \textbf{Ganho}: variação significativa entre Original e a "
        r"perturbação no mesmo modelo (McNemar, $p<0{,}05$)."
        + (r" (*) em \textbf{Acurácia}: diferença significativa entre LLM e LRM "
           r"na mesma condição." if two else "") + "}",
        r"\label{tab:acuracia_completa}",
        r"\sisetup{output-decimal-marker={,}, table-format=-2.1, table-space-text-post={*}}",
        r"\resizebox{\textwidth}{!}{%",
        r"\begin{tabular}{" + spec + "}",
        r"\toprule",
        r"\textbf{Perturbação} & "
        + rf"\multicolumn{{{ncol}}}{{c}}{{\textbf{{Acurácia (\%)}}}} & "
        + rf"\multicolumn{{{ncol}}}{{c}}{{\textbf{{Ganho (\%)}}}} \\",
        rf"\cmidrule(lr){{2-{1+ncol}}} \cmidrule(lr){{{2+ncol}-{1+2*ncol}}}",
        "& " + " & ".join("{" + m + "}" for m in models * 2) + r" \\",
        r"\midrule",
    ]

    for s in stats:
        accs = {m: s[f"acc_{m}"] for m in models}
        star = two and sig(s.get("pmodels"))
        cells = {m: fmt_num(accs[m]) for m in models}
        if two and accs["LLM"] == accs["LLM"] and accs["LRM"] == accs["LRM"]:
            if accs["LLM"] == accs["LRM"]:
                cells = {m: fmt_num(accs[m], star) for m in models}
            else:
                w = "LLM" if accs["LLM"] > accs["LRM"] else "LRM"
                cells[w] = bold(fmt_num(accs[w], star))
        gains = [NA if s["task"] == "original"
                 else fmt_num(s[f"gain_{m}"], sig(s[f"pgain_{m}"]), signed=True)
                 for m in models]
        L.append(f"{TASK_DISPLAY[s['task']]} & "
                 + " & ".join(cells[m] for m in models) + " & "
                 + " & ".join(gains) + r" \\")

    L += [r"\bottomrule", r"\end{tabular}%", r"}", r"\end{table}"]
    return "\n".join(L)


def build_detail_table(stats, models):
    two = len(models) == 2
    spec = "l" + "c" * len(models) + ("c" if two else "") + "c" * len(models)
    head = ["\\textbf{Perturbação}"]
    head += [rf"\textbf{{Acertos/n ({m})}}" for m in models]
    if two:
        head.append(r"\textbf{$p$ (LLM vs LRM)}")
    head += [rf"\textbf{{$p$ ganho ({m})}}" for m in models]

    L = [
        r"\begin{table}[ht]", r"\centering",
        r"\caption{Detalhamento: acertos sobre predições válidas e $p$-valores "
        r"de McNemar (exato quando $b+c<25$). ``--'' = teste indecidível "
        r"ou não aplicável.}",
        r"\label{tab:detalhe_completo}",
        r"\resizebox{\textwidth}{!}{%",
        r"\begin{tabular}{" + spec + "}",
        r"\toprule", " & ".join(head) + r" \\", r"\midrule",
    ]
    for s in stats:
        row = [TASK_DISPLAY[s["task"]]]
        row += [f"{s[f'c_{m}']}/{s[f'n_{m}']}" for m in models]
        if two:
            row.append(f"${fmt_p(s['pmodels'])}$")
        row += ["--" if s["task"] == "original" else f"${fmt_p(s[f'pgain_{m}'])}$"
                for m in models]
        L.append(" & ".join(row) + r" \\")
    L += [r"\bottomrule", r"\end{tabular}%", r"}", r"\end{table}"]
    return "\n".join(L)


# ==============================================================================
# CSVs
# ==============================================================================
def write_summary_csv(path, stats, models):
    cols = ["task"]
    for m in models:
        cols += [f"acc_{m}", f"corretos_{m}", f"validos_{m}", f"gain_{m}", f"p_gain_{m}"]
    if len(models) == 2:
        cols.append("p_LLM_vs_LRM")
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(cols)
        for s in stats:
            row = [s["task"]]
            for m in models:
                row += [s[f"acc_{m}"], s[f"c_{m}"], s[f"n_{m}"],
                        s[f"gain_{m}"], s[f"pgain_{m}"]]
            if len(models) == 2:
                row.append(s["pmodels"])
            w.writerow(["" if (isinstance(v, float) and v != v) or v is None else v
                        for v in row])


def write_per_query_csv(path, model_rows, tasks):
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["modelo", "task", "id", "gt", "pred", "correto"])
        for m, rows in model_rows.items():
            for t in tasks:
                for r in rows:
                    raw = str(r.get(f"p_{t}", "")).strip()
                    if raw == "" and f"p_{t}" not in r:
                        continue
                    pred = get_pred(r, t)
                    gt = get_gt(r, t)
                    ok = "" if not pred else int(pred == gt)
                    w.writerow([m, t, r.get("id"), gt, pred or raw, ok])


# ==============================================================================
# MAIN
# ==============================================================================
def print_console(stats, models):
    print("\n" + "=" * 78)
    print("SUMÁRIO NUMÉRICO")
    print("=" * 78)
    for s in stats:
        parts = [f"{s['task']:<14}"]
        for m in models:
            parts.append(f"{m}: {s[f'acc_{m}']:5.1f}% ({s[f'c_{m}']}/{s[f'n_{m}']})")
        if len(models) == 2:
            parts.append(f"p={fmt_p(s['pmodels']).replace('{,}', ',')}")
        print("  ".join(parts))
    print("=" * 78 + "\n")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--instruct", default=DEFAULT_INSTRUCT_PATH)
    ap.add_argument("--rl", default=DEFAULT_RL_PATH)
    ap.add_argument("--out-dir", default="tabelas_saida")
    ap.add_argument("--tasks", nargs="+", default=None)
    args = ap.parse_args()

    rows_lrm = load_jsonl(args.rl)
    rows_llm = load_jsonl(args.instruct) if args.instruct else None
    print(f"LRM: {len(rows_lrm)} linhas"
          + (f" | LLM: {len(rows_llm)} linhas" if rows_llm else ""), file=sys.stderr)

    tasks = args.tasks or detect_tasks(rows_llm, rows_lrm)
    if not tasks:
        sys.exit("Nenhuma coluna p_<task> com predições válidas encontrada.")
    print("Tasks:", ", ".join(tasks), file=sys.stderr)

    stats, models = compute_stats(rows_llm, rows_lrm, tasks)
    print_console(stats, models)

    out = Path(args.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    (out / "tabela_acuracia.tex").write_text(build_main_table(stats, models), encoding="utf-8")
    (out / "tabela_detalhada.tex").write_text(build_detail_table(stats, models), encoding="utf-8")
    write_summary_csv(out / "resumo.csv", stats, models)

    model_rows = {"LRM": rows_lrm}
    if rows_llm is not None:
        model_rows = {"LLM": rows_llm, "LRM": rows_lrm}
    write_per_query_csv(out / "por_consulta.csv", model_rows, tasks)

    print(f"Arquivos gerados em {out}/", file=sys.stderr)


if __name__ == "__main__":
    main()