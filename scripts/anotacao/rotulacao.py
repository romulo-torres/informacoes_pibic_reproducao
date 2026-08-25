"""
rotulacao.py
================================
Pipeline de Anotação de Raciocínio com Tags (OpenAI) -- versão por ÂNCORAS.

Lê prompts_recuperados.csv e para cada variante envia APENAS o raciocínio
(txt_*) ao modelo -- sem a questão original.

DIFERENÇA-CHAVE em relação à versão anterior: o modelo NÃO reescreve o
texto inteiro com as tags já inseridas (isso é frágil -- LLMs "copiando"
textos longos sempre introduzem pequenas divergências de aspas, espaços,
parafraseio etc., o que corrompe o texto original). Em vez disso, o
modelo devolve um JSON com uma lista de EVENTOS DE ÂNCORA:

    [
      {"tag": "DEFINE", "side": "open",  "anchor": "Okay, so I've got this"},
      {"tag": "DEFINE", "side": "close", "anchor": "work from home."},
      ...
    ]

Cada evento diz apenas ONDE uma tag de abertura/fechamento deve entrar,
citando um trecho curto e VERBATIM do texto original (a âncora). A
inserção real das tags é feita de forma determinística por
`insere_tags.aplicar_ancoras`, que localiza a âncora no texto original
(com tolerância tipográfica e fallback fuzzy) e insere a tag sem tocar
em mais nada. Depois, `insere_tags.verificar_integridade` confirma que,
removendo as tags, o texto volta a ser exatamente o original.

Isso é o que permite ao pipeline_anotacao_completo.py (e a este arquivo)
chamar pa.parse_anchors_json / pa.aplicar_ancoras / pa.verificar_integridade
/ pa.NATIVE_TAGS / pa.REQUESTED_TAGS / pa.validate_annotation(eventos).

Como rodar:
-----------
1. pip install openai pandas python-dotenv
2. Crie um .env com OPENAI_KEY=sk-...
3. Edite a seção CONFIGURAÇÃO abaixo
4. python rotulacao.py
"""

import gc
import json
import os
import re
import time
import traceback

import pandas as pd
from dotenv import load_dotenv
from openai import OpenAI

from insere_tags import aplicar_ancoras, verificar_integridade

load_dotenv()

# =============================================================================
# CONFIGURAÇÃO
# =============================================================================

OPENAI_KEY  = os.getenv("OPENAI_KEY")
MODEL_NAME  = "gpt-5.6-terra"

# Variantes a processar — correspondem aos campos txt_{v} do CSV
ALL_VARIANTS = [
    "original",
    "nl",
    "complex",
    "shuffled",
    "junto",
    "irrelevant",
    "contradiction",
    "negation",
    "missing",
]

# Quais variantes processar (None = todas)
VARIANTS_TO_RUN = ["original", "nl", "contradiction", "missing"]

# Quais IDs processar (None = todos)
IDS_TO_RUN = [102, 125, 162, 168, 192]

# Caminhos
PATH_INPUT  = "prompts_recuperados.csv"
PATH_OUTPUT = "resultados_anotados.csv"

SAVE_EVERY          = 5    # salva a cada N linhas
SLEEP_BETWEEN_CALLS = 1.0  # pausa entre chamadas (segundos)
MAX_ANCHOR_REPAIRS  = 4    # tentativas extras de reparo quando aplicar_ancoras reporta erros
                            # (voltou a mandar o LOTE inteiro de erros por
                            # rodada -- ver annotate_with_retry -- entao nao
                            # precisa de tantas rodadas quanto quando cada
                            # uma corrigia so 1 anchor; o early-stop por
                            # "sem progresso" corta rodadas desperdicadas
                            # de qualquer forma)

# Trechos de mensagem de erro da API que indicam bloqueio por política de
# conteúdo/moderação -- repetir a MESMA chamada nunca vai funcionar, então
# tratamos como falha definitiva em vez de gastar as 3 tentativas de retry.
NON_RETRYABLE_ERROR_MARKERS = (
    "invalid_prompt",
    "flagged as potentially violating",
)

# Preços por 1 M tokens (verifique em platform.openai.com/pricing)
PRICE_INPUT_PER_1M  = 0.15   # gpt-4o-mini input
PRICE_OUTPUT_PER_1M = 0.60   # gpt-4o-mini output

# Tags "nativas" do texto (já presentes antes da anotação) vs. tags que
# PEDIMOS ao modelo para localizar via âncora. `verificar_integridade`
# precisa saber de todas as tags que podem aparecer no texto final para
# poder removê-las e comparar com o texto original.
NATIVE_TAGS    = ["think"]
REQUESTED_TAGS = ["DEFINE", "BLOOM", "CYCLE", "FINAL", "r", "v"]

# Tags mínimas que uma anotação válida precisa conter (abertura + fechamento)
TAGS_OBRIGATORIAS = ["DEFINE", "BLOOM", "FINAL"]


# =============================================================================
# PARSER: LIMPEZA DO txt_*
# =============================================================================

def clean_reasoning(text: str) -> str:
    """
    Limpa o campo txt_* e o envolve em <think>...</think>.

    Passos aplicados antes do envio ao modelo de anotação:

    1. Se há <think>...</think> no texto, extrai APENAS o interior —
       descartando tudo antes (cabeçalho concatenado) e tudo depois
       (resposta final, \\boxed{}, etc.).
    2. Caso não haja <think>, remove cabeçalho do prompt concatenado:
       - Padrão A: tudo antes de <｜Assistant｜>
       - Padrão B: tudo até o fim de "putyourfinalanswer..." / "Pleasereasonstepbystep..."
    3. Remove tags <think> / </think> residuais.
    4. Remove \\boxed{...} (marcadores de resposta final inline).
    5. Remove linhas residuais com só marcação.
    6. Envolve o resultado em <think>...</think>.
    """
    if not text or str(text) == "nan":
        return str(text)

    text = str(text)

    # ── Passo 1: extrai interior do <think>...</think> se existir ────────────
    think_match = re.search(r"<think>(.*?)</think>", text, re.DOTALL | re.IGNORECASE)
    if think_match:
        text = think_match.group(1).strip()
    else:
        # ── Passo 2: remove cabeçalho antes do raciocínio ────────────────────
        if "<｜Assistant｜>" in text:
            text = text.split("<｜Assistant｜>", 1)[1]
        else:
            header_end = re.search(
                r"(?:putyourfinalanswer(?:within)?|please\s*reason\s*step\s*by\s*step)"
                r"(?:.*?\\boxed\{[^}]*\})*",
                text,
                re.IGNORECASE | re.DOTALL,
            )
            if header_end:
                text = text[header_end.end():]

        # ── Passo 3: remove tags <think> / </think> residuais ────────────────
        text = re.sub(r"</?think>", "", text)

    # ── Passo 4: remove \boxed{...} (respostas finais inline) ────────────────
    text = re.sub(r"\\boxed\{[^}]*\}", "", text)

    # ── Passo 5: remove linhas residuais com só marcação ─────────────────────
    skip = {"**answer:**", "the answer is", ""}
    lines = [l for l in text.splitlines() if l.strip().lower() not in skip]
    text = "\n".join(lines).strip()

    # ── Passo 6: envolve em <think>...</think> ───────────────────────────────
    text = f"<think>\n{text}\n</think>"

    return text


# =============================================================================
# PROMPT DE ANOTAÇÃO (por ÂNCORAS -- o modelo não reescreve o texto)
# =============================================================================

SYSTEM_MESSAGE = (
    "You are a precise annotation assistant specialized in tagging chain-of-thought "
    "reasoning. You NEVER reproduce, rewrite, paraphrase, or summarize the source "
    "text. You only output a strict JSON array of short verbatim anchors indicating "
    "where tags should be inserted. Your entire response must be valid JSON and "
    "nothing else -- no markdown code fences, no leading/trailing commentary, no "
    "explanations. Follow the instructions exactly."
)

# Exemplos condensados: mostram o formato de entrada/saída, não o texto
# completo dos exemplos originais (que eram muito longos). Ambos foram
# testados de ponta a ponta contra insere_tags.aplicar_ancoras: zero erros,
# zero avisos, integridade do texto original 100% preservada. Para o
# dataset real, vale a pena substituir/complementar estes exemplos com
# casos extraídos dos seus próprios dados já anotados manualmente -- desde
# que também sejam validados da mesma forma antes de entrar no prompt.
EXAMPLES = """Example 1:
Input reasoning:
<DEFINE>Alright, so I've got this logic problem here, and I need to figure out if the conclusion logically follows from the premises. Let me try to break it down step by step.

First, let's list out all the premises and the conclusion clearly. The premises are:

1. ∀x (Employee(x) ∧ Schedule(x, meeting, customers)) → AppearIn(x, company)
2. ∀x (Employee(x) ∧ HasLunch(x, company)) → Schedule(x, meeting, customers)
3. ∀x (Employee(x) → (HasLunch(x, company) XOR HasLunch(x, home)))
4. ∀x (Employee(x) ∧ HasLunch(x, home)) → Work(x, home)
5. ∀x (Employee(x) ∧ (¬In(x, homecountry))) → Work(x, home)
6. ∀x (Manager(x) → ¬Work(x, home))

And the conclusion is:

Manager(james) → ¬Work(james, home)</DEFINE>

<BLOOM>Okay, so I need to see if Manager(james) implies not working from home. Let's start by understanding each premise.

Premise 1: If someone is an employee and has scheduled a meeting with customers, then they appear at the company. So, being an employee with a customer meeting schedule means they're present at the company.

Premise 2: If someone is an employee and has lunch at the company, then they schedule a customer meeting. So, having lunch at the company leads to scheduling a customer meeting.

Premise 3: For all employees, if they have lunch at the company, they don't have lunch at home. It's an exclusive or—either company or home, but not both. So, employees either have lunch at the company or at home, but not both.

Premise 4: If an employee has lunch at home, then they work from home. So, home lunch implies working from home.

Premise 5: If an employee doesn't work in the home country, then they work from home. <r>Wait, that's a bit confusing. So, if someone is an employee and doesn't work in their home country, then they work from home. Hmm, that seems a bit counterintuitive, but I'll go with it.</r>

Premise 6: If someone is a manager, they don't work from home. So, managers must work at the company.

Now, the conclusion is that if James is a manager, then he doesn't work from home.

Given that, let's see if we can derive this conclusion from the premises.

First, let's consider that James is a manager. From Premise 6, we know that all managers do not work from home. So, if James is a manager, he doesn't work from home. <v>That seems straightforward, right?</v> So, the conclusion directly follows from Premise 6.</BLOOM>

<CYCLE><r>Wait, but let me make sure I'm not missing anything. Maybe there's a hidden assumption or a chain of reasoning needed.</r>

Let me think about the other premises. Maybe they provide additional context or constraints that could affect the conclusion.</CYCLE>

<CYCLE>Premise 1 and 2 talk about scheduling meetings and having lunch at the company or home. Premise 3 establishes that employees can't have both lunches. Premise 4 and 5 link having lunch at home to working from home, either because they don't work in their home country or because they do.

<r>But since the conclusion is specifically about managers, and Premise 6 directly states that managers don't work from home, I think that's the key point here.</r> The other premises might be relevant for employees, but for managers, the conclusion is directly given by Premise 6.</CYCLE>

<FINAL>So, if James is a manager, then by definition, he doesn't work from home. Therefore, the conclusion follows directly from Premise 6.

<v>I don't see any contradictions or missing links here. The other premises might be there for a different part of the problem, but for this conclusion, it's straightforward.</v></FINAL>
</think>


Output (JSON only):
[
  {"tag": "DEFINE", "side": "open", "anchor": "Alright, so I've got this logic problem"},
  {"tag": "DEFINE", "side": "close", "anchor": "¬Work(james, home)"},
  {"tag": "BLOOM", "side": "open", "anchor": "Okay, so I need to see if Manager(james)"},
  {"tag": "r", "side": "open", "anchor": "Wait, that's a bit confusing"},
  {"tag": "r", "side": "close", "anchor": "but I'll go with it."},
  {"tag": "v", "side": "open", "anchor": "That seems straightforward,"},
  {"tag": "v", "side": "close", "anchor": "right?"},
  {"tag": "BLOOM", "side": "close", "anchor": "directly follows from Premise 6."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "let me make sure I'm not missing anything."},
  {"tag": "r", "side": "close", "anchor": "or a chain of reasoning needed."},
  {"tag": "CYCLE", "side": "close", "anchor": "could affect the conclusion."},
  {"tag": "CYCLE", "side": "open", "anchor": "Premise 1 and 2 talk about scheduling meetings"},
  {"tag": "r", "side": "open", "anchor": "But since the conclusion is specifically about managers"},
  {"tag": "r", "side": "close", "anchor": "I think that's the key point here."},
  {"tag": "CYCLE", "side": "close", "anchor": "directly given by Premise 6."},
  {"tag": "FINAL", "side": "open", "anchor": "So, if James is a manager, then by definition"},
  {"tag": "v", "side": "open", "anchor": "I don't see any contradictions"},
  {"tag": "v", "side": "close", "anchor": "for this conclusion, it's straightforward."},
  {"tag": "FINAL", "side": "close", "anchor": "it's straightforward."}
]

Note two details in this example:
- <CYCLE> opens at "Wait, but" while the nested <r> right after it opens a few
  words later, at "let me make sure...". Both tags start at (almost) the same
  point in the text, so their OPEN anchors were kept different on purpose --
  see the ANCHOR RULES below for why.
- The <v> tag ("That seems straightforward, right?") uses a SHORT open anchor
  ("That seems straightforward,") and a SHORT, DIFFERENT close anchor
  ("right?") instead of repeating the whole phrase for both -- also explained
  below.

Example 2:
Input reasoning:
<DEFINE><think>
Okay, so I need to figure out whether the conclusion logically follows from the premises. Let me start by breaking down each premise and the conclusion one by one.

First, the premises:

1. ∀x (At(x, mary's School) ∧ OrderFrequently(x, takeout) → WorkIn(x, studentJob, campus))
   - This means that for any x, if x is at Mary's school and frequently orders takeout, then x works in a student job on campus.

2. ∀x (At(x, mary's School) ∧ (OrderFrequently(x, takeout) ∨ Enjoy(x, diningHallMeal)) )
   - For any x, if x is at Mary's school and either frequently orders takeout or enjoys dining hall meals, then... Hmm, wait, this premise doesn't have a conclusion. It seems like it's just a condition, but maybe it's a premise for something else.

3. ∀x (At(x, mary's School) ∧ Enjoy(x, diningHallMeal) → NOT PickyEater(x))
   - If x is at Mary's school and enjoys dining hall meals, then x is not a picky eater.

4. ∀x (At(x, mary's School) ∧ Enjoy(x, diningHallMeal) → Spend(x, aLotOfTime, eating) ∧ Spend(x, aLotOfTime, catchingUpWithFriends, diningHall))
   - If x is at Mary's school and enjoys dining hall meals, then x spends a lot of time eating and a lot of time catching up with friends in the dining hall.

Now, the conclusion is:

¬ (PickyEater(hannah) ∧ Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall))</DEFINE>

<BLOOM>So, we need to see if this conclusion follows from the premises, given that At(hannah, mary's School) is true.

Let me note that At(hannah, mary's School) is a premise, so we know Hannah is at Mary's school.

Let me try to piece this together step by step.

From premise 3: If At(x, mary's School) ∧ Enjoy(x, diningHallMeal), then ¬PickyEater(x). So, if someone is at Mary's school and enjoys dining hall meals, they are not a picky eater.

From premise 4: If At(x, mary's School) ∧ Enjoy(x, diningHallMeal), then Spend(x, aLotOfTime, eating) ∧ Spend(x, aLotOfTime, catchingUpWithFriends, diningHall). So, they spend a lot of time eating and a lot of time catching up with friends in the dining hall.

Now, the conclusion is ¬(PickyEater(hannah) ∧ Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall)). So, it's saying that Hannah is not a picky eater, and she doesn't spend a lot of time eating and catching up with friends in the dining hall.

<r>But wait, from premise 3, if she is at Mary's school and enjoys dining hall meals, she is not a picky eater.</r> So, ¬PickyEater(hannah) is part of the conclusion, which seems to align.

From premise 4, if she is at Mary's school and enjoys dining hall meals, she does spend a lot of time eating and catching up with friends. So, Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall) is true.

Therefore, if both ¬PickyEater(hannah) and Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall) are true, then the conclusion ¬(PickyEater(hannah) ∧ Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall)) would be true.</BLOOM>

<CYCLE><r>Wait, but the conclusion is a negation of the conjunction.</r> So, if both ¬PickyEater and Spend... are true, then the conclusion is ¬(P ∧ Q) which is equivalent to ¬P ∨ ¬Q. But in this case, ¬P is true, so the entire conclusion would be true.</CYCLE>

<CYCLE><r>But wait, the conclusion is saying that it's not the case that all three are true.</r> But the premises only tell us that if she enjoys dining hall meals, she is not picky and she spends time eating and catching up. So, the conclusion is saying that she is not picky, and she doesn't spend time on both eating and catching up. But from the premises, we don't know whether she spends time on both or not. <r>Wait, premise 4 says that if she enjoys dining hall meals, then she does spend time on both.</r> So, if she is at Mary's school and enjoys dining hall meals, then she does spend time on both. <r>But the conclusion is saying that she doesn't spend time on both. So, there's a contradiction here.</r></CYCLE>

<CYCLE><r>Wait, maybe I'm misunderstanding the conclusion. Let me parse it again</r>

The conclusion is: ¬(PickyEater(hannah) ∧ Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall))

So, it's the negation of the conjunction. So, if any of the three is false, the whole thing is false. But if all three are true, the conclusion is false.</CYCLE>

<CYCLE><r>But from the premises, if she is at Mary's school and enjoys dining hall meals, then she is not a picky eater (so ¬PickyEater is true) and she spends a lot of time eating and catching up (so Spend... is true).</r> Therefore, if she is at Mary's school and enjoys dining hall meals, then ¬PickyEater and Spend... are both true. Therefore, the conjunction PickyEater ∧ Spend... would be ¬PickyEater ∧ Spend... which is true because both are true. Therefore, the conclusion ¬(PickyEater ∧ Spend...) would be false.</CYCLE>

<CYCLE><r>But wait, the conclusion is saying that ¬(PickyEater ∧ Spend...).</r> So, if both ¬PickyEater and Spend... are true, then PickyEater is false, and Spend... is true. So, the conjunction PickyEater ∧ Spend... is false ∧ true, which is false. Therefore, ¬(false) is true.</CYCLE>

<CYCLE><r>Wait, this is getting confusing.

Let me approach it differently.</r> The conclusion is ¬(A ∧ B ∧ C), where A is PickyEater, B is Spend eating, and C is Spend catching up.

From the premises, if At(x) ∧ Enjoy(x), then ¬A and B ∧ C. So, if A is false, and B and C are true, then A ∧ B ∧ C is false, so ¬(A ∧ B ∧ C) is true.</CYCLE>

<CYCLE><r>But wait, the conclusion is ¬(A ∧ B ∧ C).</r> If A is false, regardless of B and C, the whole conjunction A ∧ B ∧ C is false, so the negation is true.

But the conclusion is specifically ¬(A ∧ B ∧ C), which is equivalent to ¬A ∨ ¬B ∨ ¬C.

From the premises, we have ¬A (since if Enjoy, then ¬A) and B ∧ C (if Enjoy, then B ∧ C). So, we have ¬A is true, and B ∧ C is true. Therefore, ¬(A ∧ B ∧ C) is equivalent to ¬A ∨ ¬B ∨ ¬C. Since ¬A is true, the entire statement is true.</CYCLE>

<CYCLE><r>Wait, but the conclusion is specifically ¬(A ∧ B ∧ C), which is true because A is false.</r> So, regardless of B and C, the conclusion holds because A is false.</CYCLE>

<CYCLE><r>But wait, the conclusion is saying that it's not the case that all three are true</r>. But in reality, A is false, so all three can't be true. Therefore, the conclusion is true.</CYCLE>

<CYCLE><r>But wait, the conclusion is specifically ¬(A ∧ B ∧ C).</r> So, if A is false, then A ∧ B ∧ C is false, so ¬(A ∧ B ∧ C) is true. Therefore, the conclusion is true.</CYCLE>

<CYCLE><r>But wait, the conclusion is also saying that ¬A ∧ ¬B ∨ ¬C.</r> But we know ¬A is true, so regardless of B and C, the conclusion is true.</CYCLE>

<CYCLE><r>But let me think again.</r> The conclusion is ¬(PickyEater ∧ Spend...). So, if PickyEater is false, then the conjunction is false, so the negation is true. So, regardless of whether Spend... is true or not, if PickyEater is false, the conclusion is true.</CYCLE>

<CYCLE><r>But from the premises, we have that if she is at Mary's school and enjoys dining hall meals, then she is not a picky eater (¬PickyEater) and she does spend time on both (Spend...).</r> So, in that case, ¬PickyEater is true, and Spend... is true. Therefore, the conjunction PickyEater ∧ Spend... is false, so the conclusion ¬(PickyEater ∧ Spend...) is true.</CYCLE>

<CYCLE><r>But wait, the conclusion is a specific statement about Hannah</r>. We know that At(hannah, mary's School) is true, so we can apply the premises to her.

So, from premise 3: At(hannah) ∧ Enjoy(hannah, diningHallMeal) → ¬PickyEater(hannah). So, if she enjoys dining hall meals, then she's not picky.

From premise 4: At(hannah) ∧ Enjoy(hannah, diningHallMeal) → Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall). So, if she enjoys dining hall meals, she does spend time on both.

But the conclusion is ¬(PickyEater(hannah) ∧ Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall)).

So, if she enjoys dining hall meals, then ¬PickyEater is true and Spend... is true. Therefore, the conjunction PickyEater ∧ Spend... is false, so the conclusion is ¬(false) which is true.</CYCLE>

<CYCLE><r>But the conclusion is specifically saying that ¬(PickyEater ∧ Spend...).</r> So, if she is not a picky eater and she does spend time on both, then the conclusion is true because the inner conjunction is false.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a single statement, not a conditional.</r> So, the conclusion is a fact: it's stating that it's not the case that all three are true. But from the premises, we don't know whether she enjoys dining hall meals or not.</CYCLE>

<CYCLE><r>Wait, the conclusion is about Hannah specifically.</r> We know she is at Mary's school, but we don't know if she enjoys dining hall meals or not. So, maybe she doesn't enjoy dining hall meals. Let me consider that possibility.

If she doesn't enjoy dining hall meals, then premise 3 and 4 don't apply. So, from premise 3: If At(x) ∧ Enjoy(x), then ¬PickyEater. But if she doesn't enjoy, we don't know about ¬PickyEater.

Similarly, premise 4: If At(x) ∧ Enjoy(x), then Spend... But if she doesn't enjoy, we don't know.

So, if she doesn't enjoy dining hall meals, then we don't have any information from premises 3 and 4. So, we don't know if she is a picky eater or not, and we don't know if she spends time on eating or catching up.

Therefore, the conclusion is making a statement about her, but if she doesn't enjoy dining hall meals, we don't have the premises to support the conclusion.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a universal statement? No, it's specific to Hannah.</r> So, we have to consider whether the conclusion necessarily follows from the premises given that At(hannah, mary's School) is true.

So, the conclusion is ¬(PickyEater(hannah) ∧ Spend(hannah, aLotOfTime, eating) ∧ Spend(hannah, aLotOfTime, catchingUpWithFriends, diningHall)).</CYCLE>

<CYCLE>We need to see if this conclusion must be true given the premises and At(hannah, mary's School).

From the premises:

If she enjoys dining hall meals, then she is not picky and she spends time on both.

If she is not enjoying dining hall meals, we don't know.

Therefore, the conclusion is only necessarily true if she is not a picky eater and does not spend time on both.

But from the premises, if she enjoys dining hall meals, she is not picky and spends time on both. So, if she is not enjoying dining hall meals, we don't know.

Therefore, the conclusion doesn't necessarily follow because it's possible that she is not a picky eater but doesn't spend time on both, or she is a picky eater but doesn't spend time on both.</CYCLE>

<CYCLE><r>Wait, but the conclusion is specifically about her not being picky and not spending time on both.</r> So, it's saying that both ¬PickyEater and ¬Spend... are true.

But from the premises, we only know that if she enjoys dining hall meals, then ¬PickyEater and Spend... are true. If she doesn't enjoy, we don't know.

Therefore, the conclusion may or may not be true. It's not necessarily true because it depends on whether she enjoys dining hall meals or not.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a specific statement about Hannah.</r> Since we know she is at Mary's school, but we don't know if she enjoys dining hall meals or not. Therefore, the conclusion isn't necessarily entailed by the premises because it's possible that she is not a picky eater but does spend time on both, or she is a picky eater but doesn't spend time on both.</CYCLE>

<FINAL><r>Alternatively, if she is at Mary's school and doesn't enjoy dining hall meals, we don't have any information about her pickiness or her spending time.</r>

Therefore, the conclusion is not necessarily true because it depends on additional information not provided by the premises.

So, the answer is Uncertain.</FINAL>
</think>

Output (JSON only):
[
  {"tag": "DEFINE", "side": "open", "anchor": "Okay, so I need to figure out whether"},
  {"tag": "DEFINE", "side": "close", "anchor": "aLotOfTime, catchingUpWithFriends, diningHall))"},
  {"tag": "BLOOM", "side": "open", "anchor": "So, we need to see if this conclusion"},
  {"tag": "r", "side": "open", "anchor": "But wait, from premise 3"},
  {"tag": "r", "side": "close", "anchor": "she is not a picky eater."},
  {"tag": "BLOOM", "side": "close", "anchor": "would be true."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a negation"},
  {"tag": "r", "side": "close", "anchor": "a negation of the conjunction."},
  {"tag": "CYCLE", "side": "close", "anchor": "the entire conclusion would be true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is saying that it's not the case"},
  {"tag": "r", "side": "close", "anchor": "all three are true."},
  {"tag": "r", "side": "open", "anchor": "Wait, premise 4 says"},
  {"tag": "r", "side": "close", "anchor": "spend time on both."},
  {"tag": "r", "side": "open", "anchor": "But the conclusion is saying that she doesn't spend"},
  {"tag": "r", "side": "close", "anchor": "there's a contradiction here."},
  {"tag": "CYCLE", "side": "close", "anchor": "there's a contradiction here."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, maybe"},
  {"tag": "r", "side": "open", "anchor": "I'm misunderstanding the conclusion."},
  {"tag": "r", "side": "close", "anchor": "Let me parse it again"},
  {"tag": "CYCLE", "side": "close", "anchor": "all three are true, the conclusion is false."},
  {"tag": "CYCLE", "side": "open", "anchor": "But from"},
  {"tag": "r", "side": "open", "anchor": "the premises, if she is at Mary's school"},
  {"tag": "r", "side": "close", "anchor": "so Spend... is true)."},
  {"tag": "CYCLE", "side": "close", "anchor": "the conclusion ¬(PickyEater ∧ Spend...) would be false."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is saying that ¬(PickyEater"},
  {"tag": "r", "side": "close", "anchor": "¬(PickyEater ∧ Spend...)."},
  {"tag": "CYCLE", "side": "close", "anchor": "Therefore, ¬(false) is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, this"},
  {"tag": "r", "side": "open", "anchor": "is getting confusing."},
  {"tag": "r", "side": "close", "anchor": "Let me approach it differently."},
  {"tag": "CYCLE", "side": "close", "anchor": "so ¬(A ∧ B ∧ C) is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is"},
  {"tag": "r", "side": "close", "anchor": "¬(A ∧ B ∧ C)."},
  {"tag": "CYCLE", "side": "close", "anchor": "the entire statement is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is specifically ¬(A ∧ B ∧ C)"},
  {"tag": "r", "side": "close", "anchor": "because A is false."},
  {"tag": "CYCLE", "side": "close", "anchor": "the conclusion holds because A is false."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is saying that it's not the case"},
  {"tag": "r", "side": "close", "anchor": "all three are true"},
  {"tag": "CYCLE", "side": "close", "anchor": "Therefore, the conclusion is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is specifically"},
  {"tag": "r", "side": "close", "anchor": "¬(A ∧ B ∧ C)."},
  {"tag": "CYCLE", "side": "close", "anchor": "Therefore, the conclusion is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is also saying"},
  {"tag": "r", "side": "close", "anchor": "¬A ∧ ¬B ∨ ¬C."},
  {"tag": "CYCLE", "side": "close", "anchor": "so regardless of B and C, the conclusion is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But let"},
  {"tag": "r", "side": "open", "anchor": "me think"},
  {"tag": "r", "side": "close", "anchor": "think again."},
  {"tag": "CYCLE", "side": "close", "anchor": "if PickyEater is false, the conclusion is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But from"},
  {"tag": "r", "side": "open", "anchor": "the premises, we have that if she is at Mary's school"},
  {"tag": "r", "side": "close", "anchor": "she does spend time on both (Spend...)."},
  {"tag": "CYCLE", "side": "close", "anchor": "the conclusion ¬(PickyEater ∧ Spend...) is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a specific"},
  {"tag": "r", "side": "close", "anchor": "statement about Hannah"},
  {"tag": "CYCLE", "side": "close", "anchor": "so the conclusion is ¬(false) which is true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But the"},
  {"tag": "r", "side": "open", "anchor": "conclusion is specifically saying"},
  {"tag": "r", "side": "close", "anchor": "¬(PickyEater ∧ Spend...)."},
  {"tag": "CYCLE", "side": "close", "anchor": "the inner conjunction is false."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a single statement"},
  {"tag": "r", "side": "close", "anchor": "not a conditional."},
  {"tag": "CYCLE", "side": "close", "anchor": "we don't know whether she enjoys dining hall meals or not."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, the"},
  {"tag": "r", "side": "open", "anchor": "conclusion is about Hannah"},
  {"tag": "r", "side": "close", "anchor": "Hannah specifically."},
  {"tag": "CYCLE", "side": "close", "anchor": "we don't have the premises to support the conclusion."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a universal statement?"},
  {"tag": "r", "side": "close", "anchor": "specific to Hannah."},
  {"tag": "CYCLE", "side": "close", "anchor": "catchingUpWithFriends, diningHall))."},
  {"tag": "CYCLE", "side": "open", "anchor": "We need to see if this conclusion must be true"},
  {"tag": "CYCLE", "side": "close", "anchor": "she is a picky eater but doesn't spend time on both."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is specifically about her not being picky"},
  {"tag": "r", "side": "close", "anchor": "not spending time on both."},
  {"tag": "CYCLE", "side": "close", "anchor": "whether she enjoys dining hall meals or not."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a specific"},
  {"tag": "r", "side": "close", "anchor": "statement about Hannah."},
  {"tag": "CYCLE", "side": "close", "anchor": "or she is a picky eater but doesn't spend time on both."},
  {"tag": "FINAL", "side": "open", "anchor": "Alternatively,"},
  {"tag": "r", "side": "open", "anchor": "if she is at Mary's school and doesn't enjoy"},
  {"tag": "r", "side": "close", "anchor": "her pickiness or her spending time."},
  {"tag": "FINAL", "side": "close", "anchor": "So, the answer is Uncertain."}
]

Example 3:
Input reasoning:
<DEFINE>Okay, so I have this logic problem here, and I need to figure out if the conclusion logically follows from the premises. Let me try to break it down step by step. 

First, let me list out the premises and the conclusion again to make sure I have everything straight.

Premises:
1. Exists x (Owns(joe, x) AND VehicleRegistrationPlateIn(x, istanbul))
2. For all x, (BeginWith(x, num35) -> NOT BeginWith(x, num34))
3. For all x, (NOT BeginWith(x, num34) -> NOT FromIstanbul(x))
4. NOT (Exists x (Owns(tom, x) AND BeginWith(x, num35)))
5. Exists x (Owns(tom, x) AND BeginWith(x, num35))

Conclusion:
Exists x (Owns(joe, x) AND BeginWith(x, num34))</DEFINE>

<BLOOM>Hmm, okay. So, let's try to parse each of these.

Premise 1: There exists an x such that Joe owns x and x has a vehicle registration plate from Istanbul. So, Joe owns some vehicle, and it's registered in Istanbul. Let's call this vehicle Joe's Istanbul-registered vehicle.

Premise 2: For all x, if a vehicle's plate starts with num35, then it does not start with num34. So, any vehicle with a plate starting with 35 doesn't start with 34. That seems a bit odd because 35 and 34 are consecutive numbers. Maybe it's a typo, but I'll go with it.

Premise 3: For all x, if a vehicle's plate does not start with num34, then it's not from Istanbul. So, if a plate doesn't start with 34, it's not registered in Istanbul.

Premise 4: It is not the case that there exists an x such that Tom owns x and x's plate starts with num35. So, Tom does not own any vehicle with a plate starting with 35.

Premise 5: There exists an x such that Tom owns x and x's plate starts with num35. <r>Wait, but Premise 4 says that it's not the case that such an x exists.</r> So, Premise 5 is actually the negation of Premise 4. That's confusing because Premise 4 is NOT (Exists x (Owns(tom, x) AND BeginWith(x, num35))), and Premise 5 is Exists x (Owns(tom, x) AND BeginWith(x, num35)). So, Premise 5 is the same as the negation of Premise 4, meaning that both cannot be true at the same time. That seems contradictory. <r>Maybe I'm misinterpreting something.</r>

<r>Wait, no.</r> Actually, in logic, if Premise 4 is NOT (A), then Premise 5 is A. So, if Premise 4 is NOT (A), and Premise 5 is A, then we have a contradiction unless they are both false. But in logic, if you have both NOT A and A, that's a contradiction. So, if Premise 4 and Premise 5 are both given as premises, that's a problem because they can't both be true. But maybe I need to check if I'm interpreting them correctly.

<r>Wait, let me look again.</r> Premise 4 is NOT (Exists x (Owns(tom, x) AND BeginWith(x, num35))). Premise 5 is Exists x (Owns(tom, x) AND BeginWith(x, num35)). So, Premise 5 is the direct negation of Premise 4. So, if both are given as premises, that would mean that Premise 4 is false, and Premise 5 is true, but they contradict each other. So, that's a problem because you can't have both as premises. <r>Wait, maybe the user made a mistake in formulating the premises. Or perhaps I'm misinterpreting them.</r>

<r>Wait, maybe the user meant that Premise 4 is the negation of Premise 5, but both are given as premises.</r> So, that would create a contradiction. Hmm, but in logic, if you have a set of premises that include both A and NOT A, then the entire set is contradictory, meaning that there's no possible model that satisfies all of them. So, in that case, the conclusion might be uncertain because the premises themselves are contradictory.</BLOOM>

<CYCLE>But let's not get ahead of ourselves. Let's see if the conclusion follows from the premises, assuming that the premises are consistent.

Conclusion: Exists x (Owns(joe, x) AND BeginWith(x, num34)). So, Joe owns some vehicle that starts with num34.

So, from the premises, we know that Joe owns a vehicle from Istanbul (Premise 1). Now, in Premise 2, we have that if a plate starts with num35, it doesn't start with num34. So, a plate starting with 35 can't start with 34. <r>But what about the converse?</r> Does Premise 2 tell us anything about plates that start with 34? Not directly, except that they could be from Istanbul, because Premise 3 says that if a plate doesn't start with num34, then it's not from Istanbul. So, if a plate starts with num34, it could be from Istanbul or not, but if it doesn't start with num34, it's definitely not from Istanbul.</CYCLE>

<CYCLE><r>Wait, let me think about this again.</r>

Premise 3: For all x, NOT BeginWith(x, num34) -> NOT FromIstanbul(x). So, if a plate doesn't start with 34, it's not from Istanbul. The contrapositive of this is that if a plate is from Istanbul, then it must start with 34. So, FromIstanbul(x) -> BeginWith(x, num34). That's an important point. So, if a vehicle is registered in Istanbul, its plate must start with 34.

But Premise 1 says that Joe owns a vehicle registered in Istanbul. So, that vehicle must start with num34. Therefore, there exists an x (specifically, Joe's Istanbul-registered vehicle) such that Owns(joe, x) AND BeginWith(x, num34). Therefore, the conclusion follows.</CYCLE>

<CYCLE><r>Wait, but let's check if there's any conflict with the other premises.</r>

Premise 5 says that there exists an x such that Tom owns x and it starts with num35. But from Premise 4, it's not the case that such an x exists. So, Premise 4 and 5 are contradictory. That suggests that there's a problem with the premises themselves because they can't both be true. If Premise 4 is given as a premise, then Premise 5 cannot be, and vice versa. So, if both are given as premises, the set is contradictory, meaning that there's no possible world where both are true. Therefore, the premises are inconsistent.

But in logic, if the premises are inconsistent, then the conclusion doesn't necessarily follow. It depends on whether the conclusion is true in a possible world where the premises are consistent.</CYCLE>

<CYCLE><r>Wait, but the question is whether the conclusion logically follows from the premises.</r> If the premises are contradictory, then the conclusion might not follow because the premises themselves cannot be satisfied together.</CYCLE>

<CYCLE><r>Alternatively, maybe I'm overcomplicating it.</r> Let's try to see if the conclusion necessarily follows.

From Premise 1: Joe owns some vehicle from Istanbul. From Premise 3, we have that FromIstanbul(x) implies BeginWith(x, num34). Therefore, Joe's vehicle starts with num34. Therefore, the conclusion exists x (Owns(joe, x) AND BeginWith(x, num34)) is true.

So, regardless of the other premises, as long as Premise 1 and Premise 3 are consistent, the conclusion follows. But wait, Premise 5 is conflicting with Premise 4. So, if Premise 4 is NOT (Tom owns x and starts with 35), and Premise 5 is Tom owns x and starts with 35, then these are contradictory. So, in the set of premises, if both are given, then the premises are contradictory, meaning that there's no possible model where both are true. Therefore, the conclusion may not necessarily follow because the premises themselves are inconsistent.</CYCLE>

<CYCLE><r>Wait, but in logic, if you have a set of premises that includes both A and NOT A, then the set is contradictory, and no conclusion can be drawn because there's no consistent model.</r> So, in that case, the conclusion is uncertain because the premises are contradictory.

<r>But let me think again.</r> The conclusion is that Joe owns a vehicle starting with 34. From Premise 1 and 3, we can derive that conclusion regardless of the other premises. So, even if the other premises are contradictory, the conclusion could still hold in some models. <r>Wait, but no, because if Premise 4 and 5 are both given, they create a contradiction, which means that the entire set of premises is contradictory, so the conclusion can't be necessarily true.</r></CYCLE>

<CYCLE><r>Wait, no.</r> The conclusion is a separate statement. Let me see. The conclusion is that there exists an x such that Joe owns x and it starts with 34. From Premise 1 and 3, we can derive that conclusion. So, regardless of the other premises, as long as Premise 1 and 3 are true, the conclusion is true. But Premise 4 and 5 are contradictory, so if both are given, then the premises are contradictory, meaning that the entire set is impossible. Therefore, the conclusion might not follow because the premises are contradictory.</CYCLE>

<CYCLE><r>But wait, in logic, if you have a set of premises that is contradictory, then any conclusion that can be drawn from a subset of them can also be considered.</r> But in this case, the conclusion is derived from Premise 1 and 3, which are consistent. So, even if the entire set of premises is contradictory, the conclusion could still be true in some model where Premise 1 and 3 are true, but Premise 4 and 5 are false.</CYCLE>

<CYCLE><r>But wait, in the given premises, both Premise 4 and 5 are given as premises, which is contradictory.</r> So, the set of premises is contradictory, meaning that there's no model where all premises are true. Therefore, the conclusion doesn't follow because the premises themselves are contradictory, making the entire premise set unsatisfiable.</CYCLE>

<CYCLE><r>Alternatively, maybe I should approach it differently. Let's try to model it.</r>

From Premise 1: ∃x (Owns(joe, x) ∧ VehicleRegistrationPlateIn(x, istanbul)).

From Premise 3: ∀x (¬BeginWith(x, num34) → ¬FromIstanbul(x)).

The contrapositive of Premise 3 is ∀x (FromIstanbul(x) → BeginWith(x, num34)).

Therefore, for the vehicle that Joe owns and is registered in Istanbul, it must start with num34. So, ∃x (Owns(joe, x) ∧ BeginWith(x, num34)). That's the conclusion.

So, regardless of the other premises, the conclusion follows from Premise 1 and 3. The other premises (4 and 5) are contradictory, but they don't affect the conclusion because the conclusion is derived from a consistent subset of the premises.</CYCLE>

<CYCLE><r>Wait, but in the given premises, both 4 and 5 are given as premises.</r> So, if Premise 4 is NOT (Exists x (Owns(tom, x) AND BeginWith(x, num35))), and Premise 5 is Exists x (Owns(tom, x) AND BeginWith(x, num35)), then both can't be true at the same time. Therefore, the premises are contradictory, meaning that there's no possible model where all premises are true. However, the conclusion is a separate statement that can be true in some model where Premise 1 and 3 are true, and Premise 4 and 5 are false.

But in logic, if the premises are contradictory, then the conclusion doesn't necessarily follow because the premises can't all be true. Therefore, the conclusion might not follow because the premises themselves are contradictory.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a separate statement.</r> Let me think about it in terms of logical implication. If the premises are contradictory, then there is no model where all premises are true, but the conclusion might still be true in some model where some premises are true and others are false. However, in this case, the conclusion is derived from Premise 1 and 3, which are consistent. So, even if the other premises are contradictory, the conclusion can still hold.

But in the given set of premises, both Premise 4 and 5 are given, which are contradictory. So, the set of premises is contradictory, meaning that the entire set is false. Therefore, the conclusion doesn't follow because the premises are contradictory.</CYCLE>

<CYCLE><r>Alternatively, perhaps the conclusion is independent of the contradictory premises.</r> Let me see. The conclusion is ∃x (Owns(joe, x) ∧ BeginWith(x, num34)). From Premise 1 and 3, we can derive this conclusion regardless of the other premises. So, even if the other premises are contradictory, the conclusion is still valid.</CYCLE>

<CYCLE><r>But wait, no.</r> Because in logic, if you have a set of premises that includes both A and ¬A, then the set is contradictory, and no conclusion can be drawn because there's no model where all premises are true. Therefore, the conclusion doesn't follow because the premises are contradictory.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a separate statement.</r> Let me think about it differently. The conclusion is a statement that can be true or false. The question is whether the conclusion must be true if the premises are true. But since the premises are contradictory, they can't all be true at the same time. Therefore, the conclusion might not be necessarily true because the premises can't all be true.</CYCLE>

<CYCLE><r>Alternatively, maybe the conclusion is entailed by the premises regardless of their consistency.</r> Let me try to see.

From Premise 1 and 3, we can derive the conclusion. So, if we assume that Premise 1 and 3 are true, the conclusion must be true. But since Premise 4 and 5 are contradictory, the entire set of premises can't be true. However, the conclusion is a consequence of a subset of the premises, so it can still be true even if the premises are contradictory.</CYCLE>

<CYCLE><r>Wait, but in logic, if you have a set of premises that includes a contradiction, then the set is unsatisfiable, meaning that there's no model where all premises are true.</r> Therefore, the conclusion can't be necessarily true because the premises themselves can't be satisfied together.</CYCLE>

<CYCLE><r>Hmm, this is a bit confusing. Let me try to approach it with a truth table or model.</r>

<r>Suppose we have a model where Premise 1 and 3 are true, and Premise 4 and 5 are false. Is that possible?</r>

Premise 1: True (Joe owns a vehicle from Istanbul)

Premise 3: True (If a vehicle doesn't start with 34, it's not from Istanbul)

Premise 4: False (There exists a Tom-owned vehicle starting with 35)

Premise 5: False (There does not exist a Tom-owned vehicle starting with 35)</CYCLE>

<CYCLE><r>Wait, no, because Premise 5 is the same as NOT Premise 4. So, if Premise 4 is false, Premise 5 is true.</r> But in the premises, both Premise 4 and 5 are given as premises. So, if Premise 4 is false, Premise 5 must be true, but they are both given as premises, which is a contradiction.</CYCLE>

<CYCLE><r>Wait, no.</r> Let me clarify. Premise 4 is NOT (Exists x (Owns(tom, x) AND BeginWith(x, num35))). So, if Premise 4 is false, that means Exists x (Owns(tom, x) AND BeginWith(x, num35)) is true. So, Premise 5 is that very same statement. Therefore, if Premise 4 is false, Premise 5 is true. So, in the premises, both Premise 4 and 5 are given, which is a contradiction because Premise 4 is the negation of Premise 5.

Therefore, the premises are contradictory, meaning that there's no model where all premises are true. Therefore, the conclusion doesn't necessarily follow because the premises can't all be true.</CYCLE>

<CYCLE><r>But wait, the conclusion is derived from Premise 1 and 3, which are consistent.</r> So, even if the premises are contradictory, the conclusion can still be true in some model where Premise 1 and 3 are true, and Premise 4 and 5 are false. But in the given premises, both Premise 4 and 5 are given as premises, which means that in the set of premises, they are both included, making the set contradictory.

Therefore, since the premises are contradictory, the conclusion doesn't logically follow because the premises themselves can't be satisfied together. Hence, the conclusion is uncertain because the premises are contradictory.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a separate statement. Let me think again.</r> The conclusion is ∃x (Owns(joe, x) AND BeginWith(x, num34)). From Premise 1 and 3, we can derive this conclusion. So, regardless of the other premises, if Premise 1 and 3 are true, the conclusion is true. But since the other premises are contradictory, the entire set is contradictory, so the conclusion might not be necessarily true.

But in logic, if you have a set of premises that includes a contradiction, then any conclusion that can be drawn from a subset of them can also be considered. So, the conclusion is entailed by a subset of the premises (Premise 1 and 3), regardless of the other premises. Therefore, the conclusion is entailed by the premises, even if the premises as a whole are contradictory.</CYCLE>

<CYCLE><r>Wait, but in classical logic, if the premises are contradictory, then no conclusion is entailed because there's no model where all premises are true.</r> However, in this case, the conclusion is entailed by a subset of the premises that is consistent. So, the conclusion is a consequence of the premises, even if the premises as a whole are contradictory.</CYCLE>

<CYCLE><r>But I'm not entirely sure. Let me look up the definition.</r> In logic, if a conclusion is entailed by a set of premises, it means that in every model where the premises are true, the conclusion is also true. However, if the premises are contradictory, there is no model where all premises are true, so the conclusion doesn't have to be true in any model. Therefore, the conclusion is not entailed by contradictory premises.

But in this case, the conclusion is entailed by a subset of the premises that is consistent. So, even if the entire set is contradictory, the conclusion can still be true in some model where the premises are consistent. Therefore, the conclusion is entailed by the premises because it can be derived from a consistent subset.</CYCLE>

<CYCLE><r>Hmm, I'm still a bit confused. Let me try to think of it this way: if the premises are contradictory, then the conclusion might not follow because the premises can't all be true.</r> However, the conclusion can still be true in some model where the premises are consistent. Therefore, the conclusion is not necessarily entailed by the premises as a whole, but it can be entailed by a subset.

But in the context of the question, it's asking whether the conclusion logically follows from the premises. If the premises are contradictory, then the conclusion doesn't necessarily follow because there's no model where all premises are true. Therefore, the conclusion is uncertain because the premises are contradictory.</CYCLE>

<CYCLE><r>Wait, but the conclusion is a separate statement. Let me see if I can derive it regardless of the other premises.</r>

From Premise 1: ∃x (Owns(joe, x) ∧ VehicleRegistrationPlateIn(x, istanbul)).

From Premise 3: ∀x (¬BeginWith(x, num34) → ¬FromIstanbul(x)).

The contrapositive of Premise 3 is ∀x (FromIstanbul(x) → BeginWith(x, num34)).

Therefore, for the x in Premise 1, which is registered in Istanbul, it must start with num34. Therefore, ∃x (Owns(joe, x) ∧ BeginWith(x, num34)). So, the conclusion follows.

Therefore, even if the other premises are contradictory, the conclusion can still be derived from Premise 1 and 3. So, the conclusion is entailed by the premises, regardless of the other premises.

Therefore, the answer is True.</CYCLE>

<FINAL><r>Wait, but the other premises are contradictory, so how can the conclusion still hold?</r> Because the conclusion is derived from a subset of the premises that is consistent. So, in the context of the entire set of premises, the conclusion might not hold because the premises are contradictory, but in the context of the consistent subset, it does hold. Therefore, in terms of logical implication, the conclusion is entailed by the premises as a whole because it can be derived from a consistent subset.

Therefore, the conclusion logically follows from the premises.</FINAL>
</think>

Output (JSON only):
[
  {"tag": "DEFINE", "side": "open", "anchor": "Okay, so I have this logic problem"},
  {"tag": "DEFINE", "side": "close", "anchor": "BeginWith(x, num34))"},
  {"tag": "BLOOM", "side": "open", "anchor": "Hmm, okay. So, let's try to parse"},
  {"tag": "r", "side": "open", "anchor": "Wait, but Premise 4 says"},
  {"tag": "r", "side": "close", "anchor": "such an x exists."},
  {"tag": "r", "side": "open", "anchor": "Maybe I'm"},
  {"tag": "r", "side": "close", "anchor": "misinterpreting something."},
  {"tag": "r", "side": "open", "anchor": "Wait,"},
  {"tag": "r", "side": "close", "anchor": "no."},
  {"tag": "r", "side": "open", "anchor": "Wait, let"},
  {"tag": "r", "side": "close", "anchor": "look again."},
  {"tag": "r", "side": "open", "anchor": "Wait, maybe the user made a mistake"},
  {"tag": "r", "side": "close", "anchor": "Or perhaps I'm misinterpreting them."},
  {"tag": "r", "side": "open", "anchor": "Wait, maybe the user meant that Premise 4"},
  {"tag": "r", "side": "close", "anchor": "but both are given as premises."},
  {"tag": "BLOOM", "side": "close", "anchor": "the premises themselves are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "But let's not get ahead of ourselves."},
  {"tag": "r", "side": "open", "anchor": "But what"},
  {"tag": "r", "side": "close", "anchor": "the converse?"},
  {"tag": "CYCLE", "side": "close", "anchor": "it's definitely not from Istanbul."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, let"},
  {"tag": "r", "side": "open", "anchor": "me think about"},
  {"tag": "r", "side": "close", "anchor": "this again."},
  {"tag": "CYCLE", "side": "close", "anchor": "Therefore, the conclusion follows."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "let's check if there's any conflict"},
  {"tag": "r", "side": "close", "anchor": "the other premises."},
  {"tag": "CYCLE", "side": "close", "anchor": "where the premises are consistent."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the question is whether the conclusion"},
  {"tag": "r", "side": "close", "anchor": "follows from the premises."},
  {"tag": "CYCLE", "side": "close", "anchor": "cannot be satisfied together."},
  {"tag": "CYCLE", "side": "open", "anchor": "Alternatively,"},
  {"tag": "r", "side": "open", "anchor": "maybe I'm"},
  {"tag": "r", "side": "close", "anchor": "overcomplicating it."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises themselves are inconsistent."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "in logic, if you have a set"},
  {"tag": "r", "side": "close", "anchor": "there's no consistent model."},
  {"tag": "r", "side": "open", "anchor": "But let"},
  {"tag": "r", "side": "close", "anchor": "think again."},
  {"tag": "r", "side": "open", "anchor": "Wait, but no, because if Premise 4"},
  {"tag": "r", "side": "close", "anchor": "can't be necessarily true."},
  {"tag": "CYCLE", "side": "close", "anchor": "can't be necessarily true."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, no."},
  {"tag": "r", "side": "open", "anchor": "Wait,"},
  {"tag": "r", "side": "close", "anchor": "no."},
  {"tag": "CYCLE", "side": "close", "anchor": "doesn't follow because the premises are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "in logic, if you have a set"},
  {"tag": "r", "side": "close", "anchor": "can also be considered."},
  {"tag": "CYCLE", "side": "close", "anchor": "Premise 4 and 5 are false."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "in the given premises, both Premise 4"},
  {"tag": "r", "side": "close", "anchor": "which is contradictory."},
  {"tag": "CYCLE", "side": "close", "anchor": "making the entire premise set unsatisfiable."},
  {"tag": "CYCLE", "side": "open", "anchor": "Alternatively, maybe"},
  {"tag": "r", "side": "open", "anchor": "I should approach it differently."},
  {"tag": "r", "side": "close", "anchor": "Let's try to model it."},
  {"tag": "CYCLE", "side": "close", "anchor": "a consistent subset of the premises."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "in the given premises, both 4 and 5"},
  {"tag": "r", "side": "close", "anchor": "given as premises."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises themselves are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a"},
  {"tag": "r", "side": "close", "anchor": "separate statement."},
  {"tag": "CYCLE", "side": "close", "anchor": "the conclusion doesn't follow because the premises are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "Alternatively, perhaps"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is independent"},
  {"tag": "r", "side": "close", "anchor": "contradictory premises."},
  {"tag": "CYCLE", "side": "close", "anchor": "the conclusion is still valid."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait, no."},
  {"tag": "r", "side": "open", "anchor": "wait, no."},
  {"tag": "r", "side": "close", "anchor": "no."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a"},
  {"tag": "r", "side": "close", "anchor": "separate statement."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises can't all be true."},
  {"tag": "CYCLE", "side": "open", "anchor": "Alternatively, maybe"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is entailed"},
  {"tag": "r", "side": "close", "anchor": "regardless of their consistency."},
  {"tag": "CYCLE", "side": "close", "anchor": "even if the premises are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "in logic, if you have a set"},
  {"tag": "r", "side": "close", "anchor": "all premises are true."},
  {"tag": "CYCLE", "side": "close", "anchor": "can't be satisfied together."},
  {"tag": "CYCLE", "side": "open", "anchor": "Hmm, this"},
  {"tag": "r", "side": "open", "anchor": "is a bit confusing."},
  {"tag": "r", "side": "close", "anchor": "truth table or model."},
  {"tag": "r", "side": "open", "anchor": "Suppose we have a model"},
  {"tag": "r", "side": "close", "anchor": "Is that possible?"},
  {"tag": "CYCLE", "side": "close", "anchor": "starting with 35)"},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, no,"},
  {"tag": "r", "side": "open", "anchor": "because Premise 5 is the same"},
  {"tag": "r", "side": "close", "anchor": "Premise 5 is true."},
  {"tag": "CYCLE", "side": "close", "anchor": "which is a contradiction."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, no."},
  {"tag": "r", "side": "open", "anchor": "Wait,"},
  {"tag": "r", "side": "close", "anchor": "no."},
  {"tag": "CYCLE", "side": "close", "anchor": "can't all be true."},
  {"tag": "CYCLE", "side": "open", "anchor": "But wait,"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is derived from Premise 1"},
  {"tag": "r", "side": "close", "anchor": "which are consistent."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a separate statement."},
  {"tag": "r", "side": "close", "anchor": "Let me think again."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises as a whole are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "But in"},
  {"tag": "r", "side": "open", "anchor": "classical logic, if the premises"},
  {"tag": "r", "side": "close", "anchor": "all premises are true."},
  {"tag": "CYCLE", "side": "close", "anchor": "even if the premises as a whole are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "But I'm"},
  {"tag": "r", "side": "open", "anchor": "not entirely sure."},
  {"tag": "r", "side": "close", "anchor": "look up the definition."},
  {"tag": "CYCLE", "side": "close", "anchor": "derived from a consistent subset."},
  {"tag": "CYCLE", "side": "open", "anchor": "Hmm, I'm"},
  {"tag": "r", "side": "open", "anchor": "still a bit confused."},
  {"tag": "r", "side": "close", "anchor": "premises can't all be true."},
  {"tag": "CYCLE", "side": "close", "anchor": "the premises are contradictory."},
  {"tag": "CYCLE", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the conclusion is a separate statement. Let me see"},
  {"tag": "r", "side": "close", "anchor": "regardless of the other premises."},
  {"tag": "CYCLE", "side": "close", "anchor": "the answer is True."},
  {"tag": "FINAL", "side": "open", "anchor": "Wait, but"},
  {"tag": "r", "side": "open", "anchor": "the other premises are contradictory"},
  {"tag": "r", "side": "close", "anchor": "so how can the conclusion still hold?"},
  {"tag": "FINAL", "side": "close", "anchor": "the conclusion logically follows from the premises."}
]
"""


def build_prompt(reasoning_chain: str) -> str:
    """
    Monta o prompt passando APENAS o raciocínio já limpo.
    A questão original NÃO é incluída — o modelo recebe só o chain-of-thought.
    """
    return f"""Given a chain of reasoning, we have identified several steps we would like you to tag. The steps are as follows:
1. Problem definition (denoted by <DEFINE> tags). This cycle redefines the problem to answer and often ends by indicating what it needs to deliver as the final answer, e.g., "I need to find ...". This step does not contain any reasoning towards a solution. There is only one Definition step.
2. The Blooming Step (denoted by <BLOOM> tags). First cycle of reasoning. This includes an initial exploration of the problem and defines some premises, by breaking the problem into subproblems. It must give an answer to the given question and may or may not qualify its confidence with something like "That sounds right" or "That doesn't make sense" (this is denoted by <v> tags). There is only one Bloom step.
3. Reconsideration Step(s) (denoted by <CYCLE> tags). These stages reconsider some of the initial assumptions, double-check a potential error, or introduce a new approach to solve the problem (these reconsiderations are denoted by <r> tags). Through this cycle of reasoning, an answer may be reached. It may or may not end with some confidence qualification in the answer (denoted with <v> tags). There may be several reasoning cycles, including zero.
4. Final decision (denoted by <FINAL> tags). A final answer is reached. This may be indicated by a phrase like "I'm confident..." and denotes the final answer. There is only one Final step. It may also contain <v> confidence-qualification tags.
Note: <r> and <v> tags may occur inside <BLOOM>, <CYCLE>, or <FINAL> -- never inside <DEFINE>, and never spanning across the boundary of the tag that contains them. A reconsideration during the initial exploration phase should still be tagged as <r> within <BLOOM>.
The stage may change within a single paragraph.

STRUCTURE CHECKLIST (verify before answering):
- Exactly one <DEFINE> open/close pair, exactly one <BLOOM> open/close pair,
  exactly one <FINAL> open/close pair.
- Zero or more <CYCLE> open/close pairs.
- Zero or more <r> and <v> pairs, each fully nested inside a single
  <BLOOM>/<CYCLE>/<FINAL> segment.
- Every open event has a matching close event of the same tag, and events are
  listed in the JSON array in the same left-to-right order they occur in the
  text (no overlapping/interleaved tags).

IMPORTANT -- OUTPUT FORMAT:
Do NOT reproduce, rewrite, paraphrase or copy the reasoning text in your answer.
Output ONLY a JSON array of tag-placement events, nothing else (no markdown
fences, no commentary, no leading "Here is the JSON:"). Each event has this
shape:
  {{"tag": "<DEFINE|BLOOM|CYCLE|FINAL|r|v>", "side": "<open|close>", "anchor": "<short verbatim excerpt>"}}
An event MAY also include an optional "occurrence" field (see ANCHOR RULE 8):
  {{"tag": "...", "side": "...", "anchor": "...", "occurrence": <integer >= 1>}}
Use standard JSON: double quotes only, no trailing commas, and escape any
double-quote character that appears inside an anchor (e.g. \\"like this\\").

ANCHOR RULES (read carefully -- these prevent the most common mistakes):
1. Copy the anchor VERBATIM from the input text: exact words, exact
   punctuation, exact capitalization. Do not fix typos or reword anything.
2. Keep anchors SHORT: 3 to 10 words is normally enough to locate a position
   uniquely. Longer anchors are not more accurate and increase the chance of
   whitespace/line-break mismatches.
3. side="open" -> the anchor is the FIRST few words of the segment the tag is
   opening (the tag is inserted immediately BEFORE the anchor).
   side="close" -> the anchor is the LAST few words of the segment the tag is
   closing (the tag is inserted immediately AFTER the anchor).
4. NEVER use the exact same anchor string for a tag's own open and close
   event. If a <r> or <v> span is very short, split it: use just the first
   couple of words as the open anchor and a different, later couple of words
   (the true tail of the span) as the close anchor -- never repeat the whole
   phrase for both. (See the <v> tag in Example 1.)
5. When a tag opens at (nearly) the same point where a tag nested inside it
   also opens -- e.g. a <CYCLE> immediately followed by a <r> with no plain
   text in between -- do NOT give both of them the identical open anchor.
   Give the OUTER tag a short anchor covering just its first word or two, and
   give the INNER tag an anchor starting a little further into the sentence.
   It is fine if this shifts the inner tag's exact starting character by a
   word or two -- correct nesting and approximate location matter more than
   pixel-perfect placement. (See <CYCLE>/<r> in both examples.)
6. Avoid anchoring on a generic filler phrase alone (just "Wait," or "Hmm,"
   or "Now," with nothing else) -- these words repeat many times throughout
   a reasoning chain and an anchor built only from them can match the wrong
   occurrence. Always include a few extra, more specific words so the anchor
   is unlikely to appear anywhere else in the text.
7. It is normal and fine for a tag's close anchor to coincide with the close
   anchor of a tag nested inside it (e.g. a <v> that ends exactly where the
   enclosing <FINAL> ends) -- unlike rule 5, this does not need to be worked
   around; simply anchor each close event on the true last words of its own
   segment.
8. LAST RESORT ONLY: if a phrase genuinely repeats VERBATIM more than once
   close together and no amount of extra words makes your intended anchor
   text unique (this is rare -- almost always rule 6's fix, adding more
   words, is enough), you may add an "occurrence" field: an integer (1-based)
   counting matches of the anchor text starting from the point immediately
   after the PREVIOUS event in your array. Example: if the exact sentence
   "Wait, that can't be right." appears twice in a row and you mean the
   second one, use {{"anchor": "Wait, that can't be right.", "occurrence": 2}}.
   Only use this when you are certain the duplication is real -- prefer a
   longer, more specific anchor whenever that would already disambiguate it.

We have annotated two examples for you here (both anchor sets were verified
to reconstruct the tagged text with zero errors and full text integrity):

{EXAMPLES}

Now, please annotate this chain of reasoning following the previous examples
and the ANCHOR RULES above. Return ONLY the JSON array of anchor events --
do not include the text itself:
{reasoning_chain}"""


# =============================================================================
# CLIENTE E FUNÇÕES
# =============================================================================

client = OpenAI(api_key=OPENAI_KEY)


def _call_openai_raw(messages: list) -> dict:
    """Chama a API com retry exponencial. Recebe a lista de mensagens já
    pronta (system + turnos de usuário/assistente) -- usada tanto pela
    primeira chamada (call_openai) quanto pela chamada de reparo
    (call_openai_repair), para não duplicar a lógica de retry/erro."""
    max_retries = 3

    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model=MODEL_NAME,
                max_completion_tokens=16000,  # evita corte da resposta
                messages=messages,
            )

            finish_reason = response.choices[0].finish_reason
            text = response.choices[0].message.content.strip()

            if finish_reason == "length":
                print(f"  ⚠️  Resposta cortada por max_tokens! "
                      f"(out={response.usage.completion_tokens})")

            return {
                "text":          text,
                "input_tokens":  response.usage.prompt_tokens,
                "output_tokens": response.usage.completion_tokens,
                "erro":          None,
            }

        except Exception as e:
            erro = str(e)

            # Erros de política de conteúdo (invalid_prompt / moderação) não
            # se resolvem tentando de novo com o MESMO texto -- a API vai
            # recusar sempre da mesma forma. Insistir só queima tempo e,
            # pior, o texto do reparo é ainda maior que o original (inclui
            # o JSON anterior inteiro), então cada tentativa inútil custa
            # mais que a chamada original. Falha imediatamente e sinaliza
            # de forma distinguível (para não contar como "JSON invalido").
            if any(marca in erro for marca in NON_RETRYABLE_ERROR_MARKERS):
                print(f"  🚫 Prompt sinalizado pela política de uso da API "
                      f"-- não adianta repetir com o mesmo texto.")
                return {
                    "text": None, "input_tokens": 0, "output_tokens": 0,
                    "erro": f"CONTEUDO_SINALIZADO_PELA_API: {erro}",
                }

            wait = 2 ** attempt
            print(f"  Erro API (tentativa {attempt+1}/{max_retries})"
                  f" → aguardando {wait}s")
            print(f"  {erro}")
            time.sleep(wait)

    return {
        "text":          None,
        "input_tokens":  0,
        "output_tokens": 0,
        "erro":          "Falha após todas as tentativas.",
    }


def call_openai(reasoning_chain: str) -> dict:
    """Primeira chamada: monta o prompt completo (regras + exemplos) e pede
    a lista de âncoras do zero."""
    messages = [
        {"role": "system", "content": SYSTEM_MESSAGE},
        {"role": "user", "content": build_prompt(reasoning_chain)},
    ]
    return _call_openai_raw(messages)


def _find_event_index(eventos: list, erro: dict):
    """Localiza a posição do evento que falhou dentro da lista `eventos`,
    para podermos mostrar ao modelo as âncoras VIZINHAS (evento anterior e
    seguinte) como limites de fronteira durante o reparo."""
    for i, ev in enumerate(eventos):
        if (ev.get("tag") == erro.get("tag")
                and ev.get("side") == erro.get("side")
                and ev.get("anchor") == erro.get("anchor")):
            return i
    return None


def build_repair_prompt(eventos: list, erros: list) -> str:
    """Monta o turno de reparo: mostra ao modelo exatamente quais âncoras
    falharam (e por quê) e pede a lista COMPLETA corrigida.

    Isso existe porque, na prática, boa parte das falhas de âncora não vêm
    de um erro pontual e sim de um padrão sistemático: o Example 2 do
    prompt (o mais longo e detalhado, portanto o que mais pesa por
    imitação) reusa âncoras curtas e genéricas como "Wait, but" ou "Wait,
    no." dezenas de vezes -- exatamente o que a ANCHOR RULE 6 pede para
    evitar. Como o raciocínio real do LRM é cheio de "Wait, but..." (em
    especial na variante contradiction), o modelo aprende a repetir esse
    padrão ambíguo e aplicar_ancoras reporta ANCORA_FORA_DE_ORDEM (a
    âncora existe, mas em uma ocorrência que não é a pretendida, quebrando
    o aninhamento).

    IMPORTANTE (aprendido rodando isso de verdade): simplesmente pedir para
    "alongar a âncora" sem mais contexto faz o modelo às vezes alongar
    DEMAIS -- a ponto da âncora de uma tag externa (ex.: CYCLE) invadir o
    território de uma tag aninhada logo em seguida (ex.: r), criando um
    NOVO erro de ordem em vez de resolver o antigo. Por isso incluímos
    abaixo, para cada âncora com problema, a âncora do evento imediatamente
    anterior e do imediatamente seguinte na sequência -- como limites que a
    correção não pode ultrapassar."""
    linhas = []
    for e in erros:
        idx = _find_event_index(eventos, e)
        limites = []
        if idx is not None:
            if idx > 0:
                prev = eventos[idx - 1]
                limites.append(f'right after {prev["tag"]}/{prev["side"]} anchor="{prev["anchor"]}"')
            if idx < len(eventos) - 1:
                nxt = eventos[idx + 1]
                limites.append(f'right before {nxt["tag"]}/{nxt["side"]} anchor="{nxt["anchor"]}"')
        contexto = f" [boundaries: {'; '.join(limites)}]" if limites else ""
        linhas.append(f'- tag="{e["tag"]}" side="{e["side"]}" anchor="{e["anchor"]}" -> {e["motivo"]}{contexto}')
    erros_fmt = "\n".join(linhas)
    eventos_json = json.dumps(eventos, ensure_ascii=False, indent=2)
    return f"""Some of the anchors in your previous JSON array did not resolve correctly against the source text. Here are the specific failures, each with the neighboring events (in your own event sequence) as boundaries:

{erros_fmt}

Your previous JSON array was:
{eventos_json}

These failures happen when an anchor is too short/generic (e.g. just "Wait," or "Wait, but" alone) and matches multiple positions in the text, so the wrong occurrence gets picked and the resulting nesting order breaks.

Fix ONLY the anchors listed above, following these constraints:
1. Make each fixed anchor longer and more specific -- add enough extra verbatim words (up to 15-20 words if needed) so it occurs at exactly one position in the text, at the point you actually intended. If (and only if) the phrase truly repeats verbatim and no amount of added words makes it unique, add an "occurrence" field instead (1-based index counting matches starting right after the previous event in the array) -- see ANCHOR RULE 8.
2. Do NOT let a fixed anchor's text cross into or past the "boundaries" shown for it above -- an open anchor must stay entirely within the text that comes AFTER its "right after" boundary and BEFORE its "right before" boundary (and likewise for close anchors). If you make an anchor so long it swallows the neighboring tag's own anchor text, that creates a new ordering error instead of fixing this one.
3. Tag values must be bare names exactly as given: DEFINE, BLOOM, CYCLE, FINAL, r, v -- never with angle brackets like "<DEFINE>" or "</DEFINE>".
4. Do NOT change, remove, reorder, or merge any event that was not listed as a failure above. The corrected array must have the exact same number of events, in the exact same order, as your previous array -- only the anchor text of the listed failures may change.

Return the COMPLETE corrected JSON array (all events, fixed and unfixed alike), in the same format as before. Output ONLY the JSON array -- no markdown fences, no commentary."""


def call_openai_repair(reasoning_chain: str, eventos: list, erros: list) -> dict:
    """Segunda (ou terceira) chamada: reaproveita o turno original como
    contexto e pede a correção apenas das âncoras que aplicar_ancoras
    reportou como problemáticas."""
    messages = [
        {"role": "system", "content": SYSTEM_MESSAGE},
        {"role": "user", "content": build_prompt(reasoning_chain)},
        {"role": "assistant", "content": json.dumps(eventos, ensure_ascii=False)},
        {"role": "user", "content": build_repair_prompt(eventos, erros)},
    ]
    return _call_openai_raw(messages)


# =============================================================================
# PARSE DO JSON DE ÂNCORAS
# =============================================================================

_TAGS_VALIDAS  = set(REQUESTED_TAGS)
_SIDES_VALIDOS = {"open", "close"}


def parse_anchors_json(raw_text: str) -> list:
    """
    Converte o texto bruto devolvido pelo modelo (deveria ser só um JSON
    array) na lista de eventos [{"tag","side","anchor"}, ...].

    Tolera que o modelo tenha envolvido o JSON em ```json ... ``` (comum
    em respostas de LLM apesar da instrução em contrário). Levanta
    ValueError / json.JSONDecodeError se o conteúdo não puder ser
    interpretado como uma lista de eventos válida.
    """
    if raw_text is None:
        raise ValueError("resposta vazia do modelo")

    text = raw_text.strip()

    # Remove cercas de markdown ```json ... ``` ou ``` ... ``` se presentes
    fence_match = re.search(r"```(?:json)?\s*(.*?)\s*```", text, re.DOTALL | re.IGNORECASE)
    if fence_match:
        text = fence_match.group(1).strip()

    # Se ainda sobrou texto antes/depois do array, tenta isolar o array
    if not text.startswith("["):
        array_match = re.search(r"\[.*\]", text, re.DOTALL)
        if array_match:
            text = array_match.group(0)

    eventos = json.loads(text)

    if not isinstance(eventos, list):
        raise ValueError("JSON de âncoras não é uma lista")

    for i, ev in enumerate(eventos):
        if not isinstance(ev, dict):
            raise ValueError(f"evento {i} não é um objeto")
        for campo in ("tag", "side", "anchor"):
            if campo not in ev:
                raise ValueError(f"evento {i} sem campo obrigatório '{campo}'")

        # Normaliza a tag: o modelo ocasionalmente devolve "<DEFINE>" ou
        # "</DEFINE>" em vez do nome puro "DEFINE", apesar da instrução em
        # contrário -- provavelmente por imitação da notação usada no
        # resto do prompt (exemplos, explicação da estrutura). Como isso
        # acontecia ANTES de qualquer chamada de reparo (o erro aqui é
        # levantado direto em annotate_with_retry, sem sequer chegar em
        # aplicar_ancoras), um unico evento com esse formato jogava fora
        # a resposta inteira -- mesmo com todos os outros eventos certos.
        # Normalizar aqui e' mais barato e confiavel do que depender do
        # modelo obedecer a instrucao de formato.
        if isinstance(ev["tag"], str):
            ev["tag"] = ev["tag"].strip().strip("<>/")

        if ev["tag"] not in _TAGS_VALIDAS:
            raise ValueError(f"evento {i} com tag inválida: {ev['tag']!r}")
        if ev["side"] not in _SIDES_VALIDOS:
            raise ValueError(f"evento {i} com side inválido: {ev['side']!r}")
        if not isinstance(ev["anchor"], str) or not ev["anchor"].strip():
            raise ValueError(f"evento {i} com anchor vazia")
        if "occurrence" in ev and ev["occurrence"] is not None:
            if not isinstance(ev["occurrence"], int) or isinstance(ev["occurrence"], bool) or ev["occurrence"] < 1:
                raise ValueError(f"evento {i} com occurrence invalida (deve ser inteiro >= 1): {ev['occurrence']!r}")

    return eventos


def validate_annotation(eventos: list) -> bool:
    """
    Confere que as tags mínimas (DEFINE, BLOOM, FINAL) foram abertas E
    fechadas na lista de eventos de âncora. Não olha para o texto final --
    isso é papel de `verificar_integridade` / do relatório de erros de
    `aplicar_ancoras`.
    """
    if not eventos:
        return False

    presentes = {(ev["tag"], ev["side"]) for ev in eventos}
    for tag in TAGS_OBRIGATORIAS:
        if (tag, "open") not in presentes or (tag, "close") not in presentes:
            return False
    return True


def annotate_with_retry(reasoning_text: str, max_repairs: int = MAX_ANCHOR_REPAIRS) -> dict:
    """
    Executa uma anotação completa de `reasoning_text`: chamada inicial,
    parse do JSON, aplicação determinística das âncoras e, se
    aplicar_ancoras reportar erros, até `max_repairs` chamadas extras de
    reparo (ver call_openai_repair / build_repair_prompt) mandando de volta
    exatamente quais âncoras falharam e por quê.

    Concentra em um único lugar a lógica que antes estava duplicada entre
    rotulacao.main() e pipeline_anotacao_completo.main() -- ambos devem
    chamar esta função em vez de reimplementar o laço
    call_openai -> parse_anchors_json -> aplicar_ancoras -> validate.

    Retorna:
        {
          "texto_final":    str | None,
          "erro":           str | None,   # None == sucesso
          "input_tokens":   int,          # soma de todas as chamadas (1a + reparos)
          "output_tokens":  int,
          "tentativas_reparo": int,
        }
    """
    result = call_openai(reasoning_text)
    if result["erro"]:
        return {
            "texto_final": None, "erro": result["erro"],
            "input_tokens": 0, "output_tokens": 0, "tentativas_reparo": 0,
        }

    total_in, total_out = result["input_tokens"], result["output_tokens"]

    try:
        eventos = parse_anchors_json(result["text"])
    except (ValueError, json.JSONDecodeError) as e:
        return {
            "texto_final": None, "erro": f"JSON invalido: {e}",
            "input_tokens": total_in, "output_tokens": total_out, "tentativas_reparo": 0,
        }

    texto_final, relatorio = aplicar_ancoras(reasoning_text, eventos)

    tentativa = 0
    # Assinatura do(s) erro(s) que foi mandado pro reparo na ultima rodada,
    # usada para detectar "reparo sem progresso" (ver abaixo).
    assinatura_alvo_anterior = None
    while relatorio["erros"] and tentativa < max_repairs:
        tentativa += 1

        # A maioria dos erros "FECHAMENTO_SEM_ABERTURA_CORRESPONDENTE" não é
        # um problema independente -- é um efeito cascata de um
        # ANCORA_FORA_DE_ORDEM (ou ANCORA_AMBIGUA) anterior que já
        # corrompeu a pilha de tags. Pedir para o modelo "corrigir" esses
        # fechamentos fantasmas (cuja âncora em si costuma estar certa) só
        # confunde o reparo e pode fazer ele mexer em âncoras que não
        # precisavam de ajuste. Manda só os erros de causa raiz; se não
        # sobrar nenhum (caso raro em que só há cascata, por exemplo por um
        # evento fora de ordem no array), cai de volta para a lista
        # completa.
        erros_raiz = [
            e for e in relatorio["erros"]
            if "FECHAMENTO_SEM_ABERTURA_CORRESPONDENTE" not in e["motivo"]
        ]
        erros_candidatos = erros_raiz if erros_raiz else relatorio["erros"]

        # IMPORTANTE: manda so o PRIMEIRO erro de causa raiz por rodada de
        # reparo, nao a lista inteira. Na pratica, um unico evento
        # dessincroniza o cursor e todos os eventos seguintes na sequencia
        # (que sao subsequentes ao cursor) tendem a aparecer como "erro"
        # tambem -- mesmo estando corretos -- porque a busca deles parte de
        # uma posicao errada. Pedir pro modelo corrigir 20-30 ancoras de
        # uma vez, cada uma com seu proprio par de "boundaries" derivado da
        # MESMA lista de eventos ja corrompida, e' uma tarefa muito mais
        # dificil (e cara em tokens) do que corrigir so a ancora que
        # causou a dessincronizacao original -- e corrigir essa primeira
        # costuma resolver a cascata inteira nas rodadas seguintes, sem
        # nunca ter pedido pro modelo mexer nas ancoras que ja estavam
        # certas. MAX_ANCHOR_REPAIRS foi aumentado de acordo, ja que agora
        # cada rodada resolve tipicamente 1 causa raiz por vez.
        # IMPORTANTE (revisado apos observar resultados reais): a principio
        # a hipotese era que a maioria dos erros de uma rodada e' efeito
        # cascata de UMA unica causa raiz (um evento que dessincroniza o
        # cursor), entao mandar so' o primeiro erro por rodada bastaria
        # para resolver o resto de graca nas rodadas seguintes. Na pratica
        # (ver logs de producao) isso NEM SEMPRE e' verdade: em textos
        # longos o modelo erra a ordem/ambiguidade em dezenas de pontos
        # GENUINAMENTE INDEPENDENTES ao longo do documento inteiro -- nao
        # ha uma unica causa raiz a corrigir. Nesses casos, corrigir 1 por
        # rodada precisaria de tantas rodadas quanto erros existem (ex: 26
        # erros = 26 rodadas), o que estoura MAX_ANCHOR_REPAIRS de longe e
        # gasta o orcamento inteiro sem nunca convergir -- e cada rodada
        # reenvia reasoning_text + eventos inteiros, entao o custo escala
        # linearmente com o numero de rodadas gastas em vao (na pratica:
        # custo subiu de US$0.28 para US$1.05 nos mesmos 5 IDs, com MAIS
        # falhas, nao menos). Por isso voltamos a mandar o LOTE inteiro de
        # erros de causa raiz por rodada -- uma chamada resolve N erros de
        # uma vez em vez de 1, o que e' muito mais barato quando o
        # problema e' "varios erros espalhados" em vez de "um so que
        # cascateia". O early-stop (comparacao de assinatura antes/depois)
        # continua util para parar cedo se uma rodada nao mudar nada.
        erros_para_reparo = erros_candidatos

        assinatura_alvo = {
            (e["tag"], e["side"], e["motivo"], e["anchor"]) for e in erros_para_reparo
        }

        rep = call_openai_repair(reasoning_text, eventos, erros_para_reparo)
        total_in  += rep["input_tokens"]
        total_out += rep["output_tokens"]

        if rep["erro"]:
            break  # sem nova tentativa possível; sai com o último relatorio já calculado

        try:
            eventos = parse_anchors_json(rep["text"])
        except (ValueError, json.JSONDecodeError):
            break  # resposta de reparo não veio em JSON válido; mantém último resultado válido

        texto_final, relatorio = aplicar_ancoras(reasoning_text, eventos)

        assinatura_atual = {
            (e["tag"], e["side"], e["motivo"], e["anchor"]) for e in relatorio["erros"]
        }
        # Se o(s) erro(s) que acabamos de mandar pro reparo reaparecem
        # IDENTICOS (mesma tag/side/motivo/texto da ancora) na nova lista
        # de erros, o modelo devolveu a mesma ancora problematica de novo
        # -- nao houve progresso nenhum nessa rodada. Insistir nas rodadas
        # restantes so repete o mesmo resultado e queima tokens (cada
        # rodada reenvia reasoning_text + eventos inteiros). Para aqui.
        if assinatura_alvo & assinatura_atual:
            break
        # Mesma logica para o caso raro em que a lista INTEIRA de erros nao
        # mudou de uma rodada de reparo pra outra (ex: quando cai no
        # fallback `erros_candidatos = relatorio["erros"]` com mais de um
        # item e nenhum deles muda).
        if assinatura_atual and assinatura_atual == assinatura_alvo_anterior:
            break
        assinatura_alvo_anterior = assinatura_atual

    if relatorio["erros"]:
        motivos = " | ".join(
            f"{e['tag']}/{e['side']} [{e['motivo']}]: \"{e['anchor']}\""
            for e in relatorio["erros"]
        )
        sufixo = f" apos {tentativa} reparo(s)" if tentativa else ""
        return {
            "texto_final": texto_final,
            "erro": f"ancora(s) nao encontrada(s){sufixo}: {motivos}",
            "input_tokens": total_in, "output_tokens": total_out, "tentativas_reparo": tentativa,
        }

    if not validate_annotation(eventos):
        return {
            "texto_final": texto_final,
            "erro": "tags minimas ausentes (DEFINE/BLOOM/FINAL)",
            "input_tokens": total_in, "output_tokens": total_out, "tentativas_reparo": tentativa,
        }

    if not verificar_integridade(reasoning_text, texto_final, REQUESTED_TAGS):
        return {
            "texto_final": texto_final,
            "erro": "ALERTA: texto original nao foi preservado apos insercao",
            "input_tokens": total_in, "output_tokens": total_out, "tentativas_reparo": tentativa,
        }

    return {
        "texto_final": texto_final, "erro": None,
        "input_tokens": total_in, "output_tokens": total_out, "tentativas_reparo": tentativa,
    }


def load_or_create_output(path: str, variants: list) -> pd.DataFrame:
    base_cols   = ["id", "gt", "nl_bin", "fol_bin"]
    result_cols = [f"gpt_{v}" for v in variants]
    error_cols  = [f"erro_{v}" for v in variants]
    all_cols    = base_cols + result_cols + error_cols

    if os.path.exists(path):
        df = pd.read_csv(path)
        for col in all_cols:
            if col not in df.columns:
                df[col] = None
        print(f"▶ Retomando. Linhas já no CSV: {len(df)}")
    else:
        df = pd.DataFrame(columns=all_cols)
        print("▶ Iniciando nova execução.")
    return df


# =============================================================================
# PIPELINE PRINCIPAL
# =============================================================================

def main():
    variants = VARIANTS_TO_RUN if VARIANTS_TO_RUN is not None else ALL_VARIANTS
    print(f"\n🔧 Variantes : {variants}")

    total_input_tokens  = 0
    total_output_tokens = 0
    total_calls         = 0
    total_erros         = 0
    total_invalidos     = 0
    usage_log           = []

    print(f"📂 Carregando {PATH_INPUT}...")
    df_input = pd.read_csv(PATH_INPUT)
    print(f"   Linhas: {len(df_input)}")

    if IDS_TO_RUN is not None:
        ids_set  = set(IDS_TO_RUN)
        df_input = df_input[df_input["id"].isin(ids_set)].reset_index(drop=True)
        print(f"   IDs selecionados: {sorted(ids_set)}")
        print(f"   Após filtro: {len(df_input)} linhas")
    else:
        print(f"   IDs: todos ({len(df_input)})")

    df_output = load_or_create_output(PATH_OUTPUT, variants)

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

                # Só considera "já processado" se o texto foi gerado E não
                # há erro registrado. Antes, uma linha com erro (mas
                # texto_final parcial não-nulo -- comum em falhas de
                # âncora, onde aplicar_ancoras ainda devolve um texto
                # parcialmente tageado) era erroneamente pulada em
                # reexecuções, porque só col_out era checado.
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

                # ── LIMPEZA DO RACIOCÍNIO ─────────────────────────────────
                reasoning_text = clean_reasoning(str(row[col_txt]))

                if not reasoning_text or reasoning_text == "nan":
                    result_row[col_out]  = None
                    result_row[col_erro] = "txt vazio após limpeza"
                    print(f"  ⏭  {variant:15s} | txt vazio após limpeza")
                    continue

                # ── ANOTAÇÃO (chamada + parse + aplicação + reparo automático) ──
                anot = annotate_with_retry(reasoning_text)

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

                time.sleep(SLEEP_BETWEEN_CALLS)

            df_output = df_output[df_output["id"] != item_id].reset_index(drop=True)
            results_buffer.append(result_row)

            if (idx + 1) % SAVE_EVERY == 0:
                df_new    = pd.DataFrame(results_buffer)
                df_output = pd.concat([df_output, df_new], ignore_index=True)
                df_output.to_csv(PATH_OUTPUT, index=False)
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

    df_output.to_csv(PATH_OUTPUT, index=False)
    print(f"\n✅ Concluído. CSV salvo em: {PATH_OUTPUT}")

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
            (proj_in  / 1e6) * PRICE_INPUT_PER_1M
            + (proj_out / 1e6) * PRICE_OUTPUT_PER_1M
        )

        print(
            f"\nPROJEÇÃO "
            f"({n_ids} IDs × {n_variants} variantes = {proj_calls:,} chamadas)"
        )
        print(f"  Input     : {proj_in:,.0f} tokens")
        print(f"  Output    : {proj_out:,.0f} tokens")
        print(f"  Custo est.: US$ {cost:.2f}  ({MODEL_NAME})")

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