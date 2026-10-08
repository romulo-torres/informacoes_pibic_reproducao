import json, re, sys
from collections import Counter

BOXED = re.compile(r'\\boxed\s*\{?\s*(True|False|Uncertain)\s*\}?', re.I)
VALID = {"True", "False", "Uncertain"}

def confiavel(pred, txt):
    if pred not in VALID:
        return False
    txt = txt or ""
    i = txt.rfind("</think>")
    if i != -1:
        return bool(BOXED.search(txt[i:]))
    return bool(BOXED.search(txt))

path = sys.argv[1]
train = json.load(open("estratificacao/train_ids_selecionados.json"))["ids_todos"]
universo = set(range(203)) | {100000 + i for i in train}

rows = [json.loads(l) for l in open(path) if l.strip()]
ids = {r["id"] for r in rows}
tasks = sorted({k[2:] for r in rows for k in r if k.startswith("p_")})

print(f"Arquivo: {path}")
print(f"Universo: {len(universo)} | no arquivo: {len(ids)} | faltam: {len(universo - ids)}")
print(f"Linhas duplicadas: {len(rows) - len(ids)}")
print(f"Fora do universo: {len(ids - universo)}\n")

print(f"{'task':<15}{'ok':>6}{'invalido':>10}{'ERROR:':>8}{'SKIP':>7}{'nao_conf':>10}")
ok_todas = None
for t in tasks:
    c = Counter()
    ok_ids = set()
    for r in rows:
        p = str(r.get(f"p_{t}", "")).strip()
        if p == "SKIP":
            c["skip"] += 1; ok_ids.add(r["id"])
        elif p.startswith("ERROR"):
            c["err"] += 1
        elif p not in VALID:
            c["inv"] += 1
        elif not confiavel(p, r.get(f"txt_{t}")):
            c["nc"] += 1
        else:
            c["ok"] += 1; ok_ids.add(r["id"])
    print(f"{t:<15}{c['ok']:>6}{c['inv']:>10}{c['err']:>8}{c['skip']:>7}{c['nc']:>10}")
    ok_todas = ok_ids if ok_todas is None else ok_todas & ok_ids

print(f"\nIds com TODAS as tasks ok: {len(ok_todas)} de {len(ids)}")
ruins = sorted(ids - ok_todas)
print(f"Ids com algum problema: {len(ruins)} {ruins[:15]}")
print(f"Por split (ok em todas): validation={sum(1 for i in ok_todas if i < 100000)} "
      f"train={sum(1 for i in ok_todas if i >= 100000)}")
