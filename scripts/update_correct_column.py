"""
update_correct_column.py
=========================
NAO adiciona colunas novas. Sobrescreve a coluna 'correct' JA EXISTENTE em
resultados_completos.csv, mas somente nas linhas task == 'contradiction',
usando o valor de 'correct_contradiction_v2' do CSV julgado
(resultados_completos_contradiction_judged.csv).

Regras:
  - Casa por (model, id, task) -- assim nunca mistura com outras tasks
    que tenham o mesmo id.
  - Se correct_contradiction_v2 for NaN (linha nao julgada: SKIP, Error,
    sem resposta, etc.) o valor original de 'correct' e MANTIDO como
    estava (nao vira NaN, nao perde a info antiga).
  - Nenhuma coluna e adicionada ou removida -- so o CONTEUDO de 'correct'
    muda nas linhas afetadas.

Uso:
    python3 update_correct_column.py judged.csv destino.csv saida.csv
"""

import sys
import pandas as pd

JUDGED_CSV  = "resultados_completos_contradiction_judged.csv"
TARGET_CSV  = "../codigos_pibic/resultados_completos.csv"
OUTPUT_CSV  = "resultados_completos_atualizado.csv"

VERDICT_COL = "correct_contradiction_v2"
TARGET_COL  = "correct"
KEY_COLS    = ["model", "id", "task"]


def main():
    judged_path = sys.argv[1] if len(sys.argv) > 1 else JUDGED_CSV
    target_path = sys.argv[2] if len(sys.argv) > 2 else TARGET_CSV
    output_path = sys.argv[3] if len(sys.argv) > 3 else OUTPUT_CSV

    print(f"📂 Lendo julgado: {judged_path}")
    judged = pd.read_csv(judged_path)

    print(f"📂 Lendo destino: {target_path}")
    target = pd.read_csv(target_path)

    missing_key = [c for c in KEY_COLS if c not in judged.columns or c not in target.columns]
    if missing_key:
        print(f"❌ Coluna(s) de chave ausente(s): {missing_key}")
        sys.exit(1)

    if VERDICT_COL not in judged.columns:
        print(f"❌ Coluna '{VERDICT_COL}' não existe no CSV julgado. "
              f"Disponíveis: {list(judged.columns)}")
        sys.exit(1)

    if TARGET_COL not in target.columns:
        print(f"❌ Coluna '{TARGET_COL}' não existe no CSV destino. "
              f"Disponíveis: {list(target.columns)}")
        sys.exit(1)

    print("\n🔎 Amostra de valores originais de 'correct' (task=contradiction):")
    print(target.loc[target["task"] == "contradiction", TARGET_COL].value_counts(dropna=False))

    print("\n🔎 Amostra de valores em correct_contradiction_v2 (judged):")
    print(judged.loc[judged["task"] == "contradiction", VERDICT_COL].value_counts(dropna=False))

    subset = judged.loc[
        judged["task"] == "contradiction", KEY_COLS + [VERDICT_COL]
    ].drop_duplicates(subset=KEY_COLS)

    merged = target.merge(subset, on=KEY_COLS, how="left", suffixes=("", "_new"))

    mask_overwrite = merged["task"].eq("contradiction") & merged[VERDICT_COL].notna()
    n_overwritten = mask_overwrite.sum()

    merged.loc[mask_overwrite, TARGET_COL] = merged.loc[mask_overwrite, VERDICT_COL]

    merged = merged.drop(columns=[VERDICT_COL])

    assert list(merged.columns) == list(target.columns), \
        "Conjunto de colunas mudou -- algo deu errado no merge!"

    merged.to_csv(output_path, index=False)

    print(f"\n✅ Salvo em: {output_path}")
    print(f"   {n_overwritten} linhas de 'contradiction' tiveram 'correct' sobrescrito")
    n_contradiction = (merged["task"] == "contradiction").sum()
    n_mantidas = n_contradiction - n_overwritten
    print(f"   {n_mantidas} linhas de 'contradiction' mantiveram o 'correct' original "
          f"(sem julgamento correspondente)")

    print("\n🔎 Distribuição final de 'correct' (task=contradiction):")
    print(merged.loc[merged["task"] == "contradiction", TARGET_COL].value_counts(dropna=False))


if __name__ == "__main__":
    main()
