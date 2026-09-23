"""
gera_tabela_acuracia.py
=======================
Lê o JSONL de resultados e gera a tabela LaTeX de acurácia no formato
do relatório PIBIC.

Versão restrita às tasks efetivamente rodadas no pipeline: "original" e "nl"
(demais perturbações — shuffled, junto, irrelevant, missing, complex,
contradiction, negation — foram removidas da tabela porque não fazem parte
do experimento atual; veja TASKS_TO_RUN em inference.py).

Uso (usando os caminhos padrão configurados abaixo):
    python3 gera_tabela_acuracia.py

Uso (sobrescrevendo os caminhos manualmente):
    python3 gera_tabela_acuracia.py \
        --instruct outro/caminho/results_Llama-3.1-8B-Instruct_fixed.jsonl \
        --rl       outro/caminho/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl

Parâmetros opcionais:
    --out          tabela.tex    Arquivo de saída (padrão: stdout)
"""

import json
import argparse
import sys
from pathlib import Path
from scipy.stats import chi2   # teste de McNemar (Dietterich 1998)


# ==============================================================================
# CAMINHOS DOS JSONLs DE RESULTADO (EDITE AQUI)
# ==============================================================================
# Esses sao os caminhos usados quando voce roda o script sem passar
# --instruct/--rl na linha de comando. Ajuste para onde os arquivos gerados
# pelo inference.py estao de fato na sua maquina (o nome do arquivo segue o
# padrao results/results_{file_tag}_fixed.jsonl, onde file_tag vem do
# model_name usado no inference.py).
DEFAULT_INSTRUCT_PATH = "results/results_Llama-3.1-8B-Instruct_fixed.jsonl"
DEFAULT_RL_PATH       = "results/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl"


# ==============================================================================
# CONFIGURAÇÃO DAS TASKS
# ==============================================================================

# Mapeamento: chave interna -> nome na tabela LaTeX.
# Restrito as tasks que de fato rodaram (original, nl).
TASK_DISPLAY = {
    "original": r"Original",
    "nl":       r"Linguagem Natural",
}

# Ordem em que as tasks aparecem na tabela.
TASK_ORDER = ["original", "nl"]

VALID_LABELS = {"True", "False", "Uncertain"}


# ==============================================================================
# LEITURA DO JSONL
# ==============================================================================

def load_jsonl(path: str) -> list[dict]:
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows


# ==============================================================================
# CÁLCULO DE ACURÁCIA
# ==============================================================================

def get_pred(row: dict, task: str) -> str:
    """Retorna a predição normalizada ou '' se inválida/SKIP/ERROR."""
    val = str(row.get(f"p_{task}", "")).strip().capitalize()
    if val in VALID_LABELS:
        return val
    return ""


def is_correct(pred: str, gt: str) -> bool:
    """pred é correto se bater exatamente com o ground truth."""
    return pred == gt


def accuracy(rows: list[dict], task: str) -> tuple[float, int, int]:
    """
    Calcula acurácia para uma task.
    Retorna (acurácia em %, n_corretos, n_validos)
    Denominador = exemplos com predição válida.
    """
    correct = 0
    total   = 0

    for row in rows:
        pred = get_pred(row, task)
        if not pred:
            continue

        total += 1
        gt = str(row.get("gt", "")).strip().capitalize()

        if is_correct(pred, gt):
            correct += 1

    acc = (correct / total * 100) if total > 0 else float("nan")
    return acc, correct, total


# ==============================================================================
# TESTE DE McNEMAR
# ==============================================================================

def mcnemar_p(rows_a: list[dict], rows_b: list[dict],
              task_a: str, task_b: str) -> float | None:
    """
    Teste de McNemar (Dietterich, 1998) com correção de continuidade de Edwards.
    Estatística: chi2 = (|b - c| - 1)^2 / (b + c), 1 grau de liberdade.

    Compara dois vetores de acerto/erro pareados por ID.

    Retorna p-valor bilateral ou None se b+c == 0 (teste indecidível).
    """
    index_a = {r["id"]: r for r in rows_a}
    index_b = {r["id"]: r for r in rows_b}

    ids = set(index_a) & set(index_b)

    n01 = n10 = 0  # a errou & b acertou / a acertou & b errou

    for idx in sorted(ids):
        ra = index_a[idx]
        rb = index_b[idx]

        pred_a = get_pred(ra, task_a)
        pred_b = get_pred(rb, task_b)

        if not pred_a or not pred_b:
            continue

        gt_a = str(ra.get("gt", "")).strip().capitalize()
        gt_b = str(rb.get("gt", "")).strip().capitalize()

        ok_a = is_correct(pred_a, gt_a)
        ok_b = is_correct(pred_b, gt_b)

        if ok_a and not ok_b:
            n10 += 1
        elif not ok_a and ok_b:
            n01 += 1

    b, c = n01, n10          # convenção: b = A errou / B acertou
    if b + c == 0:
        return None          # modelos concordam em tudo — teste indecidível

    # McNemar com correção de continuidade (Dietterich 1998 / Edwards 1948)
    stat = (abs(b - c) - 1) ** 2 / (b + c)
    p = chi2.sf(stat, df=1)  # survival function = 1 - CDF (bilateral)
    return p


# ==============================================================================
# FORMATAÇÃO LATEX
# ==============================================================================

ALPHA = 0.05


def fmt_acc(val: float, sig: bool) -> str:
    """Formata acurácia com asterisco se significativo."""
    if val != val:  # nan
        return r"\text{--}"
    s = f"{val:.1f}"
    if sig:
        s += r"*"
    return s


def fmt_gain(val: float, sig: bool) -> str:
    """Formata ganho relativo com sinal e asterisco."""
    if val != val:
        return r"\text{--}"
    s = f"{val:+.1f}"
    if sig:
        s += r"*"
    return s


def bold(s: str) -> str:
    return r"\textbf{" + s + "}"


# ==============================================================================
# GERAÇÃO DA TABELA
# ==============================================================================

def build_table(rows_llm: list[dict], rows_lrm: list[dict]) -> str:

    # Acurácias da condição original (denominador para ganho)
    acc_orig_llm, _, _ = accuracy(rows_llm, "original")
    acc_orig_lrm, _, _ = accuracy(rows_lrm, "original")

    lines = []

    # Cabeçalho
    lines += [
        r"\begin{table}[ht]",
        r"\centering",
        r"\caption{Comparação de acurácia e ganho relativo ($T=0{,}6$). "
        r"O símbolo (*) nas colunas de \textbf{Ganho} indica variação "
        r"estatisticamente significativa entre a condição Original e a perturbação, "
        r"dentro do mesmo modelo (teste de McNemar, $p<0{,}05$). "
        r"Nas colunas de \textbf{Acurácia}, (*) indica diferença significativa "
        r"entre LLM e LRM na mesma condição.}",
        r"\label{tab:comparacao_instruct_rl_t06}",
        r"\sisetup{",
        r"  output-decimal-marker={,},",
        r"  table-format=-2.1,",
        r"  table-space-text-post={*}",
        r"}",
        r"\resizebox{\textwidth*4/6}{!}{%",
        r"\begin{tabular}{l",
        r"  S[table-format=2.1, table-space-text-post={*}]",
        r"  S[table-format=2.1, table-space-text-post={*}]",
        r"  S[table-format=-2.1, table-space-text-post={*}]",
        r"  S[table-format=-2.1, table-space-text-post={*}]",
        r"}",
        r"\toprule",
        r"\textbf{Perturbação} & \multicolumn{2}{c}{\textbf{Acurácia (\%)}} "
        r"& \multicolumn{2}{c}{\textbf{Ganho (\%)}} \\",
        r"\cmidrule(lr){2-3} \cmidrule(lr){4-5}",
        r"& {LLM} & {LRM} & {LLM} & {LRM} \\",
        r"\midrule",
    ]

    for task in TASK_ORDER:
        display = TASK_DISPLAY[task]

        # Acurácias
        acc_llm, c_llm, n_llm = accuracy(rows_llm, task)
        acc_lrm, c_lrm, n_lrm = accuracy(rows_lrm, task)

        # Significância entre LLM e LRM na mesma task (McNemar entre modelos)
        p_llm_vs_lrm = mcnemar_p(rows_llm, rows_lrm, task, task)
        sig_acc = (p_llm_vs_lrm is not None and p_llm_vs_lrm < ALPHA)

        if task == "original":
            gain_llm = float("nan")
            gain_lrm = float("nan")
            sig_gain_llm = False
            sig_gain_lrm = False
        else:
            gain_llm = ((acc_llm - acc_orig_llm) / acc_orig_llm * 100
                        if acc_orig_llm > 0 else float("nan"))
            gain_lrm = ((acc_lrm - acc_orig_lrm) / acc_orig_lrm * 100
                        if acc_orig_lrm > 0 else float("nan"))

            # Significância ganho: original vs task, dentro do mesmo modelo
            p_gain_llm = mcnemar_p(rows_llm, rows_llm, "original", task)
            p_gain_lrm = mcnemar_p(rows_lrm, rows_lrm, "original", task)
            sig_gain_llm = (p_gain_llm is not None and p_gain_llm < ALPHA)
            sig_gain_lrm = (p_gain_lrm is not None and p_gain_lrm < ALPHA)

        # Decide qual modelo fica em negrito (maior acurácia)
        if acc_llm == acc_lrm or acc_llm != acc_llm or acc_lrm != acc_lrm:
            cell_llm = fmt_acc(acc_llm, sig_acc)
            cell_lrm = fmt_acc(acc_lrm, sig_acc)
        elif acc_llm > acc_lrm:
            cell_llm = bold(fmt_acc(acc_llm, sig_acc))
            cell_lrm = fmt_acc(acc_lrm, False)
        else:
            cell_llm = fmt_acc(acc_llm, False)
            cell_lrm = bold(fmt_acc(acc_lrm, sig_acc))

        cell_gain_llm = (r"\text{--}" if task == "original"
                         else fmt_gain(gain_llm, sig_gain_llm))
        cell_gain_lrm = (r"\text{--}" if task == "original"
                         else fmt_gain(gain_lrm, sig_gain_lrm))

        lines.append(
            rf"{display} & {cell_llm} & {cell_lrm} "
            rf"& {cell_gain_llm} & {cell_gain_lrm} \\"
        )

    lines += [
        r"\bottomrule",
        r"\end{tabular}%",
        r"}",
        r"\end{table}",
    ]

    return "\n".join(lines)


# ==============================================================================
# SUMÁRIO NUMÉRICO (para conferência)
# ==============================================================================

def print_summary(rows_llm, rows_lrm):
    print("\n" + "=" * 70)
    print("SUMÁRIO NUMÉRICO (para conferência com o relatório)")
    print("=" * 70)
    print(f"{'Task':<25} {'LLM acc':>9} {'LRM acc':>9} "
          f"{'LLM n':>7} {'LRM n':>7}")
    print("-" * 70)

    for task in TASK_ORDER:
        acc_llm, c_llm, n_llm = accuracy(rows_llm, task)
        acc_lrm, c_lrm, n_lrm = accuracy(rows_lrm, task)

        print(f"{task:<25} {acc_llm:>8.1f}% {acc_lrm:>8.1f}% "
              f"{n_llm:>7} {n_lrm:>7}")

    print("=" * 70)
    print()


def build_table_single(rows: list[dict], model_label: str = "RL") -> str:
    """
    Tabela para um unico modelo: compara 'original' vs 'nl' dentro do mesmo
    modelo (McNemar pareado por id), sem coluna de comparacao entre modelos.
    """
    acc_orig, c_orig, n_orig = accuracy(rows, "original")
    acc_nl,   c_nl,   n_nl   = accuracy(rows, "nl")

    p_orig_vs_nl = mcnemar_p(rows, rows, "original", "nl")
    sig = (p_orig_vs_nl is not None and p_orig_vs_nl < ALPHA)

    gain_nl = ((acc_nl - acc_orig) / acc_orig * 100) if acc_orig > 0 else float("nan")

    lines = []
    lines += [
        r"\begin{table}[ht]",
        r"\centering",
        rf"\caption{{Acurácia do modelo {model_label} nas condições Original e "
        r"Linguagem Natural, e ganho relativo da segunda em relação à primeira "
        r"($T=0{,}6$). O símbolo (*) indica diferença estatisticamente "
        r"significativa entre as duas condições (teste de McNemar pareado por "
        r"exemplo, $p<0{,}05$).}",
        r"\label{tab:original_vs_nl}",
        r"\sisetup{",
        r"  output-decimal-marker={,},",
        r"  table-format=-2.1,",
        r"  table-space-text-post={*}",
        r"}",
        r"\begin{tabular}{l",
        r"  S[table-format=2.1, table-space-text-post={*}]",
        r"  S[table-format=-2.1, table-space-text-post={*}]",
        r"}",
        r"\toprule",
        r"\textbf{Condição} & \textbf{Acurácia (\%)} & \textbf{Ganho (\%)} \\",
        r"\midrule",
        rf"Original & {fmt_acc(acc_orig, False)} & {{--}} \\",
        rf"Linguagem Natural & {fmt_acc(acc_nl, sig)} & {fmt_gain(gain_nl, sig)} \\",
        r"\bottomrule",
        r"\end{tabular}",
        r"\end{table}",
    ]
    return "\n".join(lines)


def print_summary_single(rows: list[dict], model_label: str = "RL"):
    acc_orig, c_orig, n_orig = accuracy(rows, "original")
    acc_nl,   c_nl,   n_nl   = accuracy(rows, "nl")
    p = mcnemar_p(rows, rows, "original", "nl")

    print("\n" + "=" * 70)
    print(f"SUMÁRIO NUMÉRICO — modelo único ({model_label}): original vs nl")
    print("=" * 70)
    print(f"{'Task':<20} {'Acurácia':>10} {'n válidos':>10}")
    print("-" * 70)
    print(f"{'original':<20} {acc_orig:>9.1f}% {n_orig:>10}")
    print(f"{'nl':<20} {acc_nl:>9.1f}% {n_nl:>10}")
    print("-" * 70)
    if p is None:
        print("McNemar (original vs nl): indecidível (modelo concorda em todos os pares válidos)")
    else:
        sig_txt = "SIGNIFICATIVO" if p < ALPHA else "não significativo"
        print(f"McNemar (original vs nl): p = {p:.4f}  ({sig_txt}, alpha={ALPHA})")
    print("=" * 70 + "\n")


# ==============================================================================
# MAIN
# ==============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="Gera tabela LaTeX de acurácia (tasks original e nl) "
                    "a partir dos JSONLs de resultado. Se --instruct nao for "
                    "passado, roda em modo single-model comparando original "
                    "vs nl dentro do modelo --rl (teste de McNemar pareado)."
    )
    parser.add_argument(
        "--instruct", default=None,
        help="JSONL do modelo LLM/Instruct (opcional). Se omitido, roda em "
             "modo single-model so com --rl, comparando original vs nl."
    )
    parser.add_argument(
        "--rl", default=DEFAULT_RL_PATH,
        help=f"JSONL do modelo LRM/R1 (padrão: {DEFAULT_RL_PATH})"
    )
    parser.add_argument(
        "--out", default=None,
        help="Arquivo de saída .tex (padrão: stdout)"
    )
    args = parser.parse_args()

    print(f"Carregando {args.rl} ...", file=sys.stderr)
    rows_lrm = load_jsonl(args.rl)
    print(f"  {len(rows_lrm)} linhas", file=sys.stderr)

    if args.instruct is None:
        # Modo single-model: so temos o RL, comparamos original vs nl dentro dele
        print("ℹ️  --instruct nao informado -> modo single-model "
              "(comparando original vs nl apenas dentro do --rl)", file=sys.stderr)
        print_summary_single(rows_lrm, model_label="RL")
        latex = build_table_single(rows_lrm, model_label="RL")
    else:
        print(f"Carregando {args.instruct} ...", file=sys.stderr)
        rows_llm = load_jsonl(args.instruct)
        print(f"  {len(rows_llm)} linhas", file=sys.stderr)

        print_summary(rows_llm, rows_lrm)
        latex = build_table(rows_llm, rows_lrm)

    if args.out:
        Path(args.out).write_text(latex, encoding="utf-8")
        print(f"Tabela salva em {args.out}", file=sys.stderr)
    else:
        print(latex)


if __name__ == "__main__":
    main()