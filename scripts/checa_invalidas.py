#!/usr/bin/env python3
"""
checa_invalidas.py
===================
Lista, para cada task, os ids cuja predicao NAO foi extraida com sucesso
(p_{task} nao esta em {True, False, Uncertain} -- ou seja, deu Error, SKIP,
ou ficou vazia/malformada), e mostra o final do texto gerado (txt_{task})
para voce entender o motivo (sem \\boxed{}, truncado, etc.).

Uso:
    python3 checa_invalidas.py results/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl

    # so uma task especifica:
    python3 checa_invalidas.py results/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl --task nl

    # quantos caracteres do final do texto mostrar (padrao 400):
    python3 checa_invalidas.py results/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl --tail 800
"""

import json
import argparse
import sys

VALID_LABELS = {"True", "False", "Uncertain"}


def load_jsonl(path: str) -> list[dict]:
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows


def main():
    parser = argparse.ArgumentParser(description="Lista respostas invalidas (label nao extraido) por task.")
    parser.add_argument("jsonl_path", help="Caminho do results_..._fixed.jsonl")
    parser.add_argument("--task", default=None,
                         help="Restringe a uma task (ex: original, nl). Padrao: todas as tasks encontradas no arquivo.")
    parser.add_argument("--tail", type=int, default=400,
                         help="Quantos caracteres do FINAL do texto gerado mostrar (padrao: 400)")
    args = parser.parse_args()

    rows = load_jsonl(args.jsonl_path)
    print(f"Total de linhas (ids) no arquivo: {len(rows)}\n", file=sys.stderr)

    # Descobre todas as tasks presentes no arquivo (colunas p_*)
    if args.task:
        tasks = [args.task]
    else:
        tasks = sorted({
            k[2:] for row in rows for k in row.keys()
            if k.startswith("p_")
        })

    for task in tasks:
        invalid_rows = []
        skipped_count = 0
        for row in rows:
            pred = str(row.get(f"p_{task}", "")).strip()
            pred_norm = pred.capitalize()
            if pred_norm in VALID_LABELS:
                continue
            if pred_norm == "Skip":
                # SKIP e esperado (ex.: task 'missing' nao aplicavel a esse id
                # porque nao esta em proven_missing_dict) -- nao e uma
                # resposta "estranha" do modelo, entao nao entra na listagem.
                skipped_count += 1
                continue
            invalid_rows.append((row, pred))

        print("=" * 78)
        print(f"TASK: {task}  |  invalidas (resposta estranha): {len(invalid_rows)} / {len(rows)}"
              f"  |  SKIP (ignorado, esperado): {skipped_count}")
        print("=" * 78)

        if not invalid_rows:
            print("  (nenhuma invalida)\n")
            continue

        for row, pred in invalid_rows:
            gid   = row.get("id")
            split = row.get("split", "?")
            local = row.get("local_idx", "?")
            gt    = row.get("gt", "?")
            txt   = row.get(f"txt_{task}", "") or ""
            tail  = txt[-args.tail:] if txt else "(sem texto gerado / campo ausente)"

            print(f"\n--- id={gid} split={split} local_idx={local} gt={gt} | p_{task}={pred!r} ---")
            print(f"[ultimos {min(len(txt), args.tail)} chars do texto gerado]")
            print(tail)
        print()


if __name__ == "__main__":
    main()