#!/usr/bin/env python3
"""
valida_ruido_irrelevante.py
============================
Prova (ou refuta) que cada premissa do IRRELEVANT_PREMISES_BANK (usado na
perturbacao "irrelevant" de scripts/inference.py) e de fato semanticamente
inerte para o Vampire.

Para cada premissa do banco e para cada exemplo do FOLIO no escopo testado:
  1. roda o Vampire no exemplo normal (baseline)                 -> label_base
  2. roda o Vampire no exemplo + essa premissa extra              -> label_noisy
  3. se label_base != label_noisy em ALGUM exemplo, a premissa e
     marcada como INVALIDA (ela interfere na prova -- nao e "ruido puro").

Isso acontece tipicamente por colisao de simbolo: se o predicado/constante da
premissa "irrelevante" (ex.: Cat, Mortal, Gold) ja aparece no problema com
outro papel, ela deixa de ser um fato isolado e passa a interagir com a prova.

Reaproveita, sem modificar a logica, o parser FOL->TPTP (v9) e o runner do
Vampire (com cache) tal como estao no notebook
`folio_vampire_notebook_v10_5_4_train_parser_fixes_final5.ipynb`.

USO:
    # teste rapido, so nos primeiros 15 exemplos, time_limit curto
    python3 valida_ruido_irrelevante.py --n-max 15 --time-limit 15

    # rodada completa nos 528 exemplos (203 validation + 325 train
    # selecionados em estratificacao/train_ids_selecionados.json)
    python3 valida_ruido_irrelevante.py --time-limit 30

    # so testar algumas premissas do banco (indices 0-based, mesma ordem
    # do IRRELEVANT_PREMISES_BANK em inference.py)
    python3 valida_ruido_irrelevante.py --premises 0 3 7

ATENCAO DE CUSTO: cada (exemplo, premissa) chama vampire_label_v9, que roda
o Vampire DUAS vezes (entails + contra). Com N exemplos e P premissas isso e
N*P*2 chamadas de Vampire (+ N*2 para o baseline). Para 528 exemplos x 10
premissas isso da ~10.600 chamadas. Use --time-limit baixo (15-30s) para uma
varredura de sanidade; suba depois so se precisar confirmar um caso limite.
O cache (pickle) torna reruns muito mais rapidos.
"""

import os
import re
import json
import time
import hashlib
import pickle
import argparse
import subprocess
from dataclasses import dataclass
from typing import List, Tuple, Optional, Dict, Set

import pandas as pd
from datasets import load_dataset


# ==============================================================================
# CAMINHOS (EDITE AQUI)
# ==============================================================================
TRAIN_IDS_JSON_PATH = "estratificacao/train_ids_selecionados.json"
VAMPIRE_BIN         = "/usr/local/bin/vampire"

OUTDIR         = "estratificacao/out_v10/irrelevant_check"
CACHE_PATH     = os.path.join(OUTDIR, "vampire_cache_irrelevant.pkl")
RESULTS_CSV    = os.path.join(OUTDIR, "irrelevant_premises_check.csv")
SUMMARY_CSV    = os.path.join(OUTDIR, "irrelevant_premises_summary.csv")

TRAIN_ID_OFFSET = 100000  # mesmo esquema usado em inference.py


# ==============================================================================
# BANCO DE PREMISSAS IRRELEVANTES
# ==============================================================================
# Mantenha esta lista SEMPRE alinhada por indice com IRRELEVANT_PREMISES_BANK
# em scripts/inference.py. A versao abaixo esta em FOL unicode (formato
# original do FOLIO / esperado pelo parser v9), enquanto a de inference.py
# esta em ASCII (formato usado nos prompts da LLM: "forall", "->", etc.).
# Se voce editar uma lista, edite a outra tambem.
IRRELEVANT_PREMISES_BANK_ASCII = [
    "forall x (Cat(x) -> Mammal(x)).",
    "forall x (Fish(x) -> LivesIn(x, Water)).",
    "Blue(Sky).",
    "Mortal(Socrates).",
    "In(Paris, France).",
    "MadeOf(Moon, Rock).",
    "BoilingPoint(Water, 100C).",
    "RisesIn(Sun, East).",
    "Metal(Gold).",
    "Equals(Plus(2,2), 4).",
]

IRRELEVANT_PREMISES_BANK_FOL = [
    "∀x (Cat(x) → Mammal(x))",
    "∀x (Fish(x) → LivesIn(x, Water))",
    "Blue(Sky)",
    "Mortal(Socrates)",
    "In(Paris, France)",
    "MadeOf(Moon, Rock)",
    "BoilingPoint(Water, 100C)",
    "RisesIn(Sun, East)",
    "Metal(Gold)",
    "Equals(Plus(2,2), 4)",
]

assert len(IRRELEVANT_PREMISES_BANK_ASCII) == len(IRRELEVANT_PREMISES_BANK_FOL), \
    "As duas listas do banco de premissas irrelevantes precisam ter o mesmo tamanho/ordem."


# ==============================================================================
# PARSER FOL -> TPTP (v9) — extraido do notebook, sem alteracoes de logica
# ==============================================================================
@dataclass(frozen=True)
class Tok:
    kind: str
    val: str

class ParseError(Exception):
    pass

@dataclass(frozen=True)
class Term: ...
@dataclass(frozen=True)
class TConst(Term):
    name: str
@dataclass(frozen=True)
class TFun(Term):
    name: str
    args: List[Term]

@dataclass(frozen=True)
class Fml: ...
@dataclass(frozen=True)
class Atom(Fml):
    pred: str
    args: List[Term]
@dataclass(frozen=True)
class Not(Fml):
    x: Fml
@dataclass(frozen=True)
class Bin(Fml):
    op: str
    a: Fml
    b: Fml
@dataclass(frozen=True)
class Quant(Fml):
    q: str
    vars: List[str]
    body: Fml
@dataclass(frozen=True)
class Eq(Fml):
    op: str
    a: Term
    b: Term


def normalize_line_v9(s: str) -> str:
    import unicodedata
    if s is None:
        return ""
    s = s.strip()
    s = re.sub(r"[.]+\s*$", "", s)
    if " Never:" in s:
        s = s.split(" Never:")[0].strip()
    s = unicodedata.normalize("NFKD", s)
    s = "".join(ch for ch in s if not unicodedata.combining(ch))
    s = s.replace("—>", "→").replace("–>", "→").replace("->", "→")
    s = s.replace("⟷", "↔").replace("⇔", "↔").replace("⟺", "↔")
    s = re.sub(r"(?<=\s)v(?=\s)", "∨", s)

    decimals = {}
    def _dec_repl(m):
        key = f"__DEC{len(decimals)}__"
        decimals[key] = m.group(0)
        return key
    s = re.sub(r"\b\d+\.\d+\b", _dec_repl, s)

    s = s.replace("-", "_")
    s = s.replace("'", "_")
    s = s.replace(".", "_")

    for k, v in decimals.items():
        s = s.replace(k, v)

    s = re.sub(r"\s+", " ", s)
    s = s.replace(",)", ")").replace(",,", ",")
    s = re.sub(r"\bIn\(\s*([A-Za-z0-9_]+)\s*,\s*([A-Za-z0-9_]+)\s*∧", r"In(\1, \2) ∧", s)
    s = re.sub(r"([A-Za-z_][A-Za-z0-9_]*)\(\(\s*([A-Za-z_][A-Za-z0-9_]*)\s*\)", r"\1(\2)", s)
    s = re.sub(r"∃\s*\(", "∃x (", s)
    s = re.sub(r"∀\s*\(", "∀x (", s)

    def _maybe_commify_args(m):
        inner = m.group(1)
        if any(sym in inner for sym in ["∀","∃","¬","∧","∨","⊕","→","↔","=","≠"]):
            return "(" + inner + ")"
        if "," not in inner and " " in inner:
            inner2 = re.sub(r"\s+", ", ", inner.strip())
            return "(" + inner2 + ")"
        if "," in inner:
            parts = [p.strip() for p in inner.split(",")]
            new_parts = []
            for p in parts:
                if " " in p:
                    toks = [t for t in re.split(r"\s+", p) if t]
                    if all(re.fullmatch(r"[A-Za-z0-9_]+|\d+\.\d+|\d+", t) for t in toks):
                        new_parts.extend(toks)
                    else:
                        new_parts.append(p)
                else:
                    new_parts.append(p)
            return "(" + ", ".join(new_parts) + ")"
        return "(" + inner + ")"

    s = re.sub(r"\(([^()]*)\)", _maybe_commify_args, s)

    out_chars = []
    bal = 0
    for ch in s:
        if ch == "(":
            bal += 1
            out_chars.append(ch)
        elif ch == ")":
            if bal > 0:
                bal -= 1
                out_chars.append(ch)
            else:
                continue
        else:
            out_chars.append(ch)
    s = "".join(out_chars)

    if bal > 0:
        s = s + (")" * bal)

    return s


TOK_RE_V9 = re.compile(
    r"\s*(?:"
    r"(?P<FORALL>∀)|"
    r"(?P<EXISTS>∃)|"
    r"(?P<NOT>¬)|"
    r"(?P<AND>∧)|"
    r"(?P<OR>∨)|"
    r"(?P<XOR>⊕)|"
    r"(?P<IMPL>→)|"
    r"(?P<IFF>↔)|"
    r"(?P<EQ>=)|"
    r"(?P<NEQ>≠)|"
    r"(?P<LP>\()|"
    r"(?P<RP>\))|"
    r"(?P<COMMA>,)|"
    r"(?P<ID>(?:[A-Za-z_][A-Za-z0-9_]*|\d+[A-Za-z_][A-Za-z0-9_]*))|"
    r"(?P<NUM>\d+(?:\.\d+)?)"
    r")"
)

def tokenize_v9(s: str) -> List[Tok]:
    s = normalize_line_v9(s)
    out: List[Tok] = []
    i = 0
    n = len(s)
    while i < n:
        m = TOK_RE_V9.match(s, i)
        if not m:
            i += 1
            continue
        kind = None
        val = m.group(0).strip()
        for k, v in m.groupdict().items():
            if v is not None:
                kind = k
                val = v
                break
        out.append(Tok(kind, val))
        i = m.end()
    out.append(Tok("EOF", ""))
    return out


class Parser:
    def __init__(self, toks: List[Tok]):
        self.toks = toks
        self.i = 0

    def peek(self) -> Tok:
        return self.toks[self.i]

    def eat(self, kind: str) -> Tok:
        t = self.peek()
        if t.kind != kind:
            raise ParseError(f"Expected {kind}, got {t}")
        self.i += 1
        return t

    def accept(self, kind: str) -> Optional[Tok]:
        if self.peek().kind == kind:
            self.i += 1
            return self.toks[self.i - 1]
        return None

    def parse_fml(self) -> Fml:
        f = self.parse_iff()
        self.eat("EOF")
        return f

    def parse_iff(self) -> Fml:
        x = self.parse_impl()
        while self.accept("IFF"):
            y = self.parse_impl()
            x = Bin("IFF", x, y)
        return x

    def parse_impl(self) -> Fml:
        x = self.parse_xor()
        while self.accept("IMPL"):
            y = self.parse_xor()
            x = Bin("IMPL", x, y)
        return x

    def parse_xor(self) -> Fml:
        x = self.parse_or()
        while self.accept("XOR"):
            y = self.parse_or()
            x = Bin("XOR", x, y)
        return x

    def parse_or(self) -> Fml:
        x = self.parse_and()
        while self.accept("OR"):
            y = self.parse_and()
            x = Bin("OR", x, y)
        return x

    def parse_and(self) -> Fml:
        x = self.parse_not()
        while self.accept("AND"):
            y = self.parse_not()
            x = Bin("AND", x, y)
        return x

    def parse_not(self) -> Fml:
        if self.accept("NOT"):
            return Not(self.parse_not())
        return self.parse_atomlike()

    def parse_atomlike(self) -> Fml:
        if self.accept("LP"):
            f = self.parse_iff()
            self.eat("RP")
            return f
        if self.peek().kind in ("FORALL", "EXISTS"):
            segments = []
            while self.peek().kind in ("FORALL", "EXISTS"):
                qtok = self.eat(self.peek().kind)
                qkind = qtok.kind
                var_pat = re.compile(r"^[a-z][a-z0-9_]*$")
                vars_ = [self.eat("ID").val]
                while self.peek().kind == "ID" and var_pat.fullmatch(self.peek().val or ""):
                    vars_.append(self.eat("ID").val)
                while self.accept("COMMA"):
                    v = self.eat("ID").val
                    vars_.append(v)
                if not vars_:
                    raise ParseError(f"Quantifier without variables near {qtok}")
                segments.append((qkind, vars_))

            if self.accept("LP"):
                body = self.parse_iff()
                self.eat("RP")
            else:
                body = self.parse_atomlike()

            f = body
            for qkind, vars_ in reversed(segments):
                q = "FORALL" if qkind == "FORALL" else "EXISTS"
                f = Quant(q, vars_, f)
            return f

        t1 = self.parse_term()
        if self.peek().kind in ("EQ","NEQ"):
            op = "EQ" if self.accept("EQ") else "NEQ"
            t2 = self.parse_term()
            return Eq(op, t1, t2)

        if isinstance(t1, TConst):
            if self.accept("LP"):
                args: List[Term] = []
                if not self.accept("RP"):
                    while True:
                        args.append(self.parse_term())
                        if self.accept("COMMA"):
                            continue
                        self.eat("RP")
                        break
                return Atom(t1.name, args)
            return Atom(t1.name, [])
        if isinstance(t1, TFun):
            return Atom(t1.name, t1.args)

        raise ParseError("Unexpected atomlike")

    def parse_term(self) -> Term:
        idt = self.accept("ID")
        if idt:
            name = idt.val
            if self.accept("LP"):
                args: List[Term] = []
                if not self.accept("RP"):
                    while True:
                        args.append(self.parse_term())
                        if self.accept("COMMA"):
                            continue
                        self.eat("RP")
                        break
                return TFun(name, args)
            return TConst(name)

        numt = self.accept("NUM")
        if numt:
            return TConst(numt.val)

        raise ParseError(f"Expected term, got {self.peek()}")


def parse_folio_formula_v9(s: str) -> Fml:
    return Parser(tokenize_v9(s)).parse_fml()


NUM_LIKE = re.compile(r"^(?:y)?(\d+)$", re.IGNORECASE)

def canon_sym_v9(name: str, *, is_var: bool) -> str:
    if is_var:
        return name[:1].upper() + name[1:]
    m = NUM_LIKE.match(name)
    if m:
        return "num" + m.group(1)
    name2 = name.lower()
    name2 = re.sub(r"[^a-z0-9_]", "_", name2)
    name2 = re.sub(r"_+", "_", name2).strip("_")
    if not name2:
        name2 = "c"
    if name2[0].isdigit():
        name2 = "c_" + name2
    return name2


def term_to_tptp_v9(t: Term, bound: Set[str]) -> str:
    if isinstance(t, TConst):
        return canon_sym_v9(t.name, is_var=(t.name in bound))
    if isinstance(t, TFun):
        fname = canon_sym_v9(t.name, is_var=False)
        return f"{fname}({', '.join(term_to_tptp_v9(a, bound) for a in t.args)})"
    raise TypeError(t)


def fml_to_tptp_v9(f: Fml, bound: Optional[Set[str]] = None) -> str:
    bound = set(bound or set())
    if isinstance(f, Quant):
        vars_tptp = [canon_sym_v9(v, is_var=True) for v in f.vars]
        new_bound = set(bound) | set(f.vars)
        qsym = "!" if f.q == "FORALL" else "?"
        return f"{qsym} [{', '.join(vars_tptp)}] : ({fml_to_tptp_v9(f.body, new_bound)})"
    if isinstance(f, Atom):
        pred = canon_sym_v9(f.pred, is_var=False)
        if not f.args:
            return pred
        return f"{pred}({', '.join(term_to_tptp_v9(a, bound) for a in f.args)})"
    if isinstance(f, Not):
        return f"~({fml_to_tptp_v9(f.x, bound)})"
    if isinstance(f, Bin):
        op_map = {"AND":"&","OR":"|","IMPL":"=>","IFF":"<=>","XOR":"<~>"}
        op = op_map[f.op]
        return f"({fml_to_tptp_v9(f.a, bound)} {op} {fml_to_tptp_v9(f.b, bound)})"
    if isinstance(f, Eq):
        op = "=" if f.op == "EQ" else "!="
        return f"({term_to_tptp_v9(f.a, bound)} {op} {term_to_tptp_v9(f.b, bound)})"
    raise TypeError(f)


def folio_to_tptp_v9(formula: str) -> str:
    formula = normalize_line_v9(formula)
    return fml_to_tptp_v9(parse_folio_formula_v9(formula))


def safe_folio_to_tptp_v9(formula: str) -> Tuple[Optional[str], Optional[str]]:
    try:
        return folio_to_tptp_v9(formula), None
    except Exception as e:
        return None, str(e)


# ==============================================================================
# RUNNER DO VAMPIRE + CACHE — extraido do notebook, sem alteracoes de logica
# ==============================================================================
SZS_RE = re.compile(r"^\s*%?\s*SZS\s+status\s+(\w+)", re.IGNORECASE)
DECISIVE_SZS = {"unsatisfiable","satisfiable","theorem","countersatisfiable","contradictory"}

def _sha1_text(s: str) -> str:
    return hashlib.sha1(s.encode("utf-8")).hexdigest()

def _parse_szs(output: str) -> str:
    for line in output.splitlines():
        m = SZS_RE.search(line)
        if m:
            return m.group(1)
    return "Unknown"

def run_vampire_once(tptp_file: str, time_limit: int, schedule: str) -> Tuple[str, str]:
    cmd = [
        VAMPIRE_BIN,
        "--mode", "portfolio",
        "--schedule", schedule,
        "-t", str(time_limit),
        "--input_syntax", "tptp",
        "--output_mode", "szs",
        tptp_file,
    ]
    proc = subprocess.run(cmd, capture_output=True, text=True)
    out = (proc.stdout or "") + "\n" + (proc.stderr or "")
    return _parse_szs(out), out

def run_vampire(tptp_file: str, time_limit: int, casc_fraction: float) -> Tuple[str, str, Dict[str, object]]:
    t1 = max(1, int(time_limit * casc_fraction))
    t2 = max(1, time_limit - t1)
    szs1, out1 = run_vampire_once(tptp_file, t1, "casc")
    if szs1.lower() in DECISIVE_SZS:
        return szs1, out1, {"used_schedule":"casc","t_casc":t1,"t_casc_sat":t2,"szs_casc":szs1}
    szs2, out2 = run_vampire_once(tptp_file, t2, "casc_sat")
    return szs2, out2, {"used_schedule":"casc_sat","t_casc":t1,"t_casc_sat":t2,"szs_casc":szs1,"szs_casc_sat":szs2}

def is_unsat(szs: str) -> bool:
    return szs.lower() in {"unsatisfiable","contradictory"}

def write_tptp_problem_v9(premises_lines: List[str], extra_axioms_tptp: List[str], out_path: str, comment: str = "") -> Dict[str, object]:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    prem_tptp = []
    prem_errors = []
    for p in premises_lines:
        tptp, err = safe_folio_to_tptp_v9(p)
        if err or tptp is None:
            prem_errors.append((p, err))
        else:
            prem_tptp.append(tptp)

    with open(out_path, "w", encoding="utf-8") as fp:
        if comment:
            fp.write(f"% {comment}\n")
        for i, tptp in enumerate(prem_tptp, start=1):
            fp.write(f"fof(p{i}, axiom, {tptp}).\n")
        if prem_errors:
            fp.write(f"% [WARN] {len(prem_errors)} premise lines failed to parse and were skipped.\n")
            for (orig, err) in prem_errors[:10]:
                fp.write(f"%   line: {orig}\n")
                fp.write(f"%   err : {err}\n")
        for k, ax in enumerate(extra_axioms_tptp, start=1):
            fp.write(f"fof(extra{k}, axiom, {ax}).\n")

    return {"n_premises_skipped": len(prem_errors)}


VAMPIRE_CACHE: Dict[Tuple[str,int,float], Dict[str, object]] = {}

def load_cache(path: str) -> None:
    global VAMPIRE_CACHE
    if os.path.exists(path):
        try:
            with open(path, "rb") as f:
                VAMPIRE_CACHE = pickle.load(f)
            print(f"[cache] carregado: {len(VAMPIRE_CACHE)} entradas")
        except Exception as e:
            print("[cache] falha ao carregar, iniciando vazio:", e)
            VAMPIRE_CACHE = {}
    else:
        print("[cache] arquivo inexistente, iniciando vazio")

def save_cache(path: str) -> None:
    try:
        with open(path, "wb") as f:
            pickle.dump(VAMPIRE_CACHE, f)
    except Exception as e:
        print("[cache] falha ao salvar:", e)

def run_vampire_cached(tptp_file: str, time_limit: int, casc_fraction: float) -> Tuple[str, str, Dict[str, object]]:
    with open(tptp_file, "r", encoding="utf-8") as f:
        content = f.read()
    key = (_sha1_text(content), int(time_limit), float(casc_fraction))
    hit = VAMPIRE_CACHE.get(key)
    if hit is not None:
        return hit["szs"], hit["out"], hit["meta"]

    szs, out, meta = run_vampire(tptp_file, time_limit=time_limit, casc_fraction=casc_fraction)
    VAMPIRE_CACHE[key] = {"szs": szs, "out": out, "meta": meta}
    save_cache(CACHE_PATH)
    return szs, out, meta

def vampire_label_v9(premises_lines: List[str], conclusion_fol: str, out_prefix: str,
                      time_limit: int, casc_fraction: float) -> Dict[str, object]:
    concl_tptp, concl_err = safe_folio_to_tptp_v9(conclusion_fol.strip())
    if concl_err or concl_tptp is None:
        return {"vampire_label":"PARSE_ERROR","parse_error":f"Conclusion: {concl_err}"}

    entails_file = out_prefix + "_entails.p"
    write_tptp_problem_v9(premises_lines, [f"~({concl_tptp})"], entails_file,
                           comment="premises + ~conclusion (UNSAT => entails)")
    szs_e, out_e, _ = run_vampire_cached(entails_file, time_limit=time_limit, casc_fraction=casc_fraction)

    contra_file = out_prefix + "_contra.p"
    write_tptp_problem_v9(premises_lines, [f"({concl_tptp})"], contra_file,
                           comment="premises + conclusion (UNSAT => contradiction)")
    szs_c, out_c, _ = run_vampire_cached(contra_file, time_limit=time_limit, casc_fraction=casc_fraction)

    if is_unsat(szs_e):
        lab = "True"
    elif is_unsat(szs_c):
        lab = "False"
    else:
        lab = "Uncertain"

    return {
        "vampire_label": lab,
        "szs_entails": szs_e,
        "szs_contra": szs_c,
        "parse_error": None,
    }


# ==============================================================================
# CARREGAMENTO DO CONJUNTO DE EXEMPLOS (validation + treino selecionado, 528)
# ==============================================================================
def to_global_id(local_train_idx: int) -> int:
    return TRAIN_ID_OFFSET + int(local_train_idx)

def is_train_id(global_id: int) -> bool:
    return global_id >= TRAIN_ID_OFFSET

def get_split_name(global_id: int) -> str:
    return "train" if is_train_id(global_id) else "validation"

def get_local_idx(global_id: int) -> int:
    return global_id - TRAIN_ID_OFFSET if is_train_id(global_id) else global_id


def load_examples(n_max: Optional[int]) -> List[Tuple[int, dict]]:
    """Retorna lista de (global_id, exemplo) na mesma populacao usada em
    inference.py: todos os exemplos de validation + os de treino listados em
    train_ids_selecionados.json."""
    print("Carregando FOLIO (validation)...")
    ds_val = load_dataset("yale-nlp/FOLIO", split="validation")

    examples = [(i, ds_val[i]) for i in range(len(ds_val))]

    try:
        with open(TRAIN_IDS_JSON_PATH, "r", encoding="utf-8") as f:
            train_ids_data = json.load(f)
        ids_todos_train = sorted(set(train_ids_data["ids_todos"]))
        print(f"Carregando FOLIO (train) — {len(ids_todos_train)} ids selecionados...")
        ds_train = load_dataset("yale-nlp/FOLIO", split="train")
        for local_idx in ids_todos_train:
            examples.append((to_global_id(local_idx), ds_train[local_idx]))
    except FileNotFoundError:
        print(f"[aviso] {TRAIN_IDS_JSON_PATH} nao encontrado — usando so validation "
              f"({len(examples)} exemplos).")

    examples.sort(key=lambda t: t[0])
    if n_max is not None:
        examples = examples[:n_max]
    return examples


# ==============================================================================
# MAIN
# ==============================================================================
def main():
    global VAMPIRE_BIN
    parser = argparse.ArgumentParser(
        description="Testa se cada premissa do IRRELEVANT_PREMISES_BANK muda o "
                    "rotulo do Vampire em algum exemplo do FOLIO."
    )
    parser.add_argument("--time-limit", type=int, default=30,
                         help="Tempo (s) por checagem entails/contra do Vampire (padrao: 30). "
                              "O notebook original usa 600s, mas isso e inviavel para milhares "
                              "de chamadas; comece baixo.")
    parser.add_argument("--casc-fraction", type=float, default=0.67,
                         help="Fracao do tempo para o schedule 'casc' antes do fallback 'casc_sat' (padrao: 0.67).")
    parser.add_argument("--n-max", type=int, default=None,
                         help="Limita a quantidade de exemplos testados (para teste rapido).")
    parser.add_argument("--premises", type=int, nargs="*", default=None,
                         help="Indices (0-based) do banco a testar. Padrao: todas as 10.")
    parser.add_argument("--vampire-bin", default=None,
                         help=f"Caminho do binario do Vampire (padrao: {VAMPIRE_BIN}).")
    args = parser.parse_args()

    if args.vampire_bin:
        VAMPIRE_BIN = args.vampire_bin

    premise_indices = args.premises if args.premises is not None else list(range(len(IRRELEVANT_PREMISES_BANK_FOL)))

    os.makedirs(OUTDIR, exist_ok=True)
    load_cache(CACHE_PATH)

    examples = load_examples(args.n_max)
    print(f"Total de exemplos no escopo: {len(examples)}")
    print(f"Premissas do banco a testar: {premise_indices}")
    print(f"time_limit={args.time_limit}s  casc_fraction={args.casc_fraction}  vampire_bin={VAMPIRE_BIN}\n")

    # Retomada: pula pares (id, premise_idx) ja presentes no CSV de resultados
    done_pairs = set()
    if os.path.exists(RESULTS_CSV):
        try:
            df_prev = pd.read_csv(RESULTS_CSV)
            done_pairs = set(zip(df_prev["global_id"], df_prev["premise_idx"]))
            print(f"Retomando — {len(done_pairs)} pares (id, premissa) ja processados em {RESULTS_CSV}")
        except Exception:
            pass

    csv_is_new = not os.path.exists(RESULTS_CSV)
    fcsv = open(RESULTS_CSV, "a", encoding="utf-8", newline="")
    if csv_is_new:
        fcsv.write("global_id,split,local_idx,gold_label,base_label,premise_idx,premise_fol,"
                    "noisy_label,changed,base_parse_error,noisy_parse_error\n")
    fcsv.flush()

    t_start = time.time()
    base_label_cache: Dict[int, str] = {}

    for k, (gid, ex) in enumerate(examples, start=1):
        premises_fol = ex.get("premises-FOL") or ex.get("premises_fol") or ""
        conclusion_fol = ex.get("conclusion-FOL") or ex.get("conclusion_fol") or ""
        gold = ex.get("label")
        premises_lines = [ln.strip() for ln in str(premises_fol).splitlines() if ln.strip()]

        split_name = get_split_name(gid)
        local_idx = get_local_idx(gid)
        out_prefix_base = os.path.join(OUTDIR, f"ex{gid}_base")

        # Baseline (uma vez por exemplo, cacheado em memoria neste run tambem)
        if gid not in base_label_cache:
            base_res = vampire_label_v9(premises_lines, str(conclusion_fol), out_prefix_base,
                                         time_limit=args.time_limit, casc_fraction=args.casc_fraction)
            base_label_cache[gid] = base_res
        else:
            base_res = base_label_cache[gid]

        base_label = base_res.get("vampire_label")
        base_err = base_res.get("parse_error")

        elapsed = time.time() - t_start
        print(f"[{k}/{len(examples)}] id={gid} split={split_name} local_idx={local_idx} "
              f"base_label={base_label} elapsed={elapsed:.0f}s", flush=True)

        for p_idx in premise_indices:
            if (gid, p_idx) in done_pairs:
                continue

            premise_fol = IRRELEVANT_PREMISES_BANK_FOL[p_idx]

            if base_label not in {"True", "False", "Uncertain"}:
                # baseline nao decidiu (parse error) -> nao da pra comparar
                row = [gid, split_name, local_idx, gold, base_label, p_idx,
                       premise_fol, "SKIP_BASE_PARSE_ERROR", "", base_err, ""]
            else:
                out_prefix_noisy = os.path.join(OUTDIR, f"ex{gid}_noise{p_idx}")
                noisy_res = vampire_label_v9(premises_lines + [premise_fol], str(conclusion_fol),
                                              out_prefix_noisy, time_limit=args.time_limit,
                                              casc_fraction=args.casc_fraction)
                noisy_label = noisy_res.get("vampire_label")
                noisy_err = noisy_res.get("parse_error")

                if noisy_label not in {"True", "False", "Uncertain"}:
                    changed = ""
                else:
                    changed = (noisy_label != base_label)
                    if changed:
                        print(f"    ⚠️  MUDOU! premissa[{p_idx}]='{premise_fol}' "
                              f"base={base_label} -> noisy={noisy_label} (id={gid})", flush=True)

                row = [gid, split_name, local_idx, gold, base_label, p_idx,
                       premise_fol, noisy_label, changed, base_err, noisy_err]

            fcsv.write(",".join('"' + str(x).replace('"', "'") + '"' for x in row) + "\n")
            fcsv.flush()

    fcsv.close()
    save_cache(CACHE_PATH)

    # ---- Sumario final: por premissa, quantos exemplos mudaram? ----
    df = pd.read_csv(RESULTS_CSV)
    df["changed_bool"] = df["changed"].astype(str).str.strip().str.lower().eq("true")

    summary_rows = []
    for p_idx in range(len(IRRELEVANT_PREMISES_BANK_FOL)):
        sub = df[df["premise_idx"] == p_idx]
        n_tested = len(sub[sub["noisy_label"].isin(["True", "False", "Uncertain"])])
        n_changed = int(sub["changed_bool"].sum())
        changed_ids = sub[sub["changed_bool"]]["global_id"].tolist()
        valid_flag = "VALIDA (irrelevante confirmada)" if n_changed == 0 else "INVALIDA (muda resultado)"
        summary_rows.append({
            "premise_idx": p_idx,
            "premise_ascii": IRRELEVANT_PREMISES_BANK_ASCII[p_idx],
            "premise_fol": IRRELEVANT_PREMISES_BANK_FOL[p_idx],
            "n_exemplos_testados": n_tested,
            "n_exemplos_mudou": n_changed,
            "ids_que_mudaram": changed_ids,
            "veredito": valid_flag,
        })

    df_summary = pd.DataFrame(summary_rows)
    df_summary.to_csv(SUMMARY_CSV, index=False)

    print("\n" + "=" * 78)
    print("RESUMO — irrelevância das premissas do banco")
    print("=" * 78)
    for r in summary_rows:
        print(f"[{r['premise_idx']}] {r['premise_ascii']}")
        print(f"    testado em {r['n_exemplos_testados']} exemplos | mudou em {r['n_exemplos_mudou']}")
        print(f"    -> {r['veredito']}")
        if r["ids_que_mudaram"]:
            print(f"    ids afetados: {r['ids_que_mudaram']}")
        print()

    print(f"CSV detalhado: {RESULTS_CSV}")
    print(f"CSV resumo   : {SUMMARY_CSV}")


if __name__ == "__main__":
    main()