import time, random, re, torch, os, gc, string, json
import pandas as pd
from tqdm import tqdm
from transformers import (
    AutoTokenizer, AutoModelForCausalLM,
    StoppingCriteria, StoppingCriteriaList, AutoConfig
)
from datasets import load_dataset

os.environ["PYTORCH_CUDA_ALLOC_CONF"] = "expandable_segments:True"

# ==============================================================================
# REGEX CENTRALIZADA
# ==============================================================================
BOXED_PATTERN = re.compile(
    r'\\boxed\s*\{?\s*(True|False|Uncertain)\s*\}?',
    re.IGNORECASE
)
BARE_PATTERN = re.compile(
    r'\b(True|False|Uncertain)\b',
    re.IGNORECASE
)

THINK_OPEN_PATTERN  = re.compile(r'<think>', re.IGNORECASE)
THINK_CLOSE_PATTERN = re.compile(r'</think>', re.IGNORECASE)


# ==============================================================================
# NORMALIZACAO FOL -> ASCII
# ==============================================================================
FOL_REPLACEMENTS = [
    ('\u2200', 'forall '),
    ('\u2203', 'exists '),
    ('\u2227', ' AND '),
    ('\u2228', ' OR '),
    ('\u2192', ' -> '),
    ('\u2194', ' <-> '),
    ('\xac', 'NOT '),
    ('\u2295', ' XOR '),
    ('\u2260', ' != '),
    ('\u27f7', ' <-> '),
    ('\u21d4', ' <-> '),
    ('\u27ba', ' <-> '),
]

def normalize_fol(text: str) -> str:
    for symbol, replacement in FOL_REPLACEMENTS:
        text = text.replace(symbol, replacement)
    text = re.sub(r'  +', ' ', text)
    return text.strip()


# ==============================================================================
# LIMPEZA DE ARTEFATOS BPE
# ==============================================================================
def clean_bpe_artifacts(text: str) -> str:
    text = text.replace("\u0121", " ").replace("\u010a", "\n")
    text = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]', '', text)
    if any(0x80 <= ord(c) <= 0xFF for c in text):
        try:
            text = text.encode('latin-1').decode('utf-8')
        except (UnicodeDecodeError, UnicodeEncodeError):
            pass
    return text


# ==============================================================================
# EXTRACAO DE LABEL
# ==============================================================================
def extract_label(full_text: str, idx=None) -> str:
    think_end   = full_text.rfind("</think>")
    after_think = full_text[think_end:] if think_end != -1 else None

    if after_think:
        matches = BOXED_PATTERN.findall(after_think)
        if matches:
            return matches[-1].capitalize()

    if BOXED_PATTERN.search(full_text) and think_end != -1:
        print(f"❌ \\boxed{{}} apenas dentro do <think> -> id={idx} | tratando como Error")
        return "Error"

    if BOXED_PATTERN.search(full_text) and think_end == -1:
        matches = BOXED_PATTERN.findall(full_text)
        label = matches[-1].capitalize()
        print(f"⚠️  \\boxed{{}} sem </think> -> id={idx} | label={label}")
        return label

    if after_think:
        matches = BARE_PATTERN.findall(after_think)
        if matches:
            label = matches[-1].capitalize()
            print(f"⚠️  Fallback bare (apos </think>) -> id={idx} | label={label}")
            return label

    if think_end == -1:
        matches = BARE_PATTERN.findall(full_text)
        if matches:
            label = matches[-1].capitalize()
            print(f"⚠️  Fallback bare (sem </think>) -> id={idx} | label={label}")
            return label

    print(f"❌ Nenhum label encontrado -> id={idx} | tratando como Error")
    print(f"   Texto (ultimos 200 chars): {full_text[-200:]}")
    return "Error"


# ==============================================================================
# FUNCOES DE COMPLEXIDADE
# ==============================================================================
def word_count(text):
    translator = str.maketrans('', '', string.punctuation)
    return len(text.translate(translator).split())


def count_logic_tokens(text):
    text = text.replace("->", "->").replace(".", "")
    patterns = [r'[\u2200\u2203]', r'[\xac\u2227\u2228\u2192\u2194\u27f7\u21d4\u27ba\u2295]',
                r'[=\u2260]', r'[(),]', r'[a-zA-Z_][a-zA-Z0-9_]*', r'\s+']
    token_pattern = re.compile('|'.join(patterns))
    tokens = token_pattern.findall(text)
    return len([t for t in tokens if not t.isspace()])


def build_complexity_map(data):
    records = []
    for i, ex in enumerate(data):
        nl_wc  = word_count(ex['premises'] + ex['conclusion'])
        fol_tc = count_logic_tokens(ex['premises-FOL'] + ex['conclusion-FOL'])
        records.append({'idx': i, 'nl_wc': nl_wc, 'fol_tc': fol_tc})

    df = pd.DataFrame(records)
    df['nl_bin']  = pd.qcut(df['nl_wc'],  4, labels=['Q1', 'Q2', 'Q3', 'Q4'])
    df['fol_bin'] = pd.qcut(df['fol_tc'], 4, labels=['Q1', 'Q2', 'Q3', 'Q4'])

    return {
        row['idx']: (int(row['nl_wc']), int(row['fol_tc']),
                     str(row['nl_bin']), str(row['fol_bin']))
        for _, row in df.iterrows()
    }


# ==============================================================================
# STOPPING CRITERIA
# ==============================================================================
class StopOnBoxed(StoppingCriteria):
    def __init__(self, tokenizer, initial_length: int, idx=None, task=None):
        self.tokenizer      = tokenizer
        self.initial_length = initial_length
        self._buffer        = ""
        self.idx            = idx
        self.task           = task
        self._last_printed  = 0

    def reset(self, new_initial_length: int, idx=None, task=None):
        self.initial_length = new_initial_length
        self._buffer        = ""
        self.idx            = idx
        self.task           = task
        self._last_printed  = 0

    def _is_inside_think(self, text: str) -> bool:
        opens  = len(THINK_OPEN_PATTERN.findall(text))
        closes = len(THINK_CLOSE_PATTERN.findall(text))
        return opens > closes

    def __call__(self, input_ids, scores, **kwargs):
        new_tokens = input_ids[0][self.initial_length:]
        n = new_tokens.shape[0]
        if n == 0:
            return False

        if n - self._last_printed >= 500:
            self._last_printed = (n // 500) * 500
            print(f"   ⏳ id={self.idx} | task={self.task} | tokens={n}", flush=True)

        last_token = input_ids[0][-1:]
        self._buffer += self.tokenizer.decode(last_token, skip_special_tokens=True)

        tail = self._buffer[-200:]
        if BOXED_PATTERN.search(tail):
            full_new = self.tokenizer.decode(new_tokens, skip_special_tokens=True)
            if not self._is_inside_think(full_new):
                return True

        return False


# ==============================================================================
# 1. ESCOLHA DO MODELO
# ==============================================================================
MODELS = [
    "meta-llama/Llama-3.1-8B-Instruct",
    "deepseek-ai/DeepSeek-R1-Distill-Llama-8B",
]

SELECTED_INDEX = 1
model_name = MODELS[SELECTED_INDEX]

IS_INSTRUCT       = "Instruct" in model_name
IS_R1_MODEL       = "DeepSeek-R1" in model_name
USE_CHAT_TEMPLATE = IS_INSTRUCT or IS_R1_MODEL

file_tag   = model_name.split("/")[-1]
OUTPUT_DIR = "resultados_pibic_v2"
os.makedirs(OUTPUT_DIR, exist_ok=True)

print(f"Modelo selecionado : {model_name}")
print(f"  IS_INSTRUCT      : {IS_INSTRUCT}")
print(f"  IS_R1_MODEL      : {IS_R1_MODEL}")
print(f"  OUTPUT_DIR       : {OUTPUT_DIR}")


# ==============================================================================
# 2. LISTAS PARA MISSING PREMISE
# ==============================================================================
raw_ids_list = [
    5,6,9,10,12,14,15,18,19,20,21,22,24,28,29,31,32,33,35,37,
    46,49,50,53,54,55,59,63,64,65,68,69,73,76,78,79,81,82,84,87,
    88,96,97,102,111,113,114,115,119,125,126,131,134,138,146,147,
    149,153,154,157,158,160,162,166,167,168,170,171,176,177,178,
    179,180,182,183,184,188,189,190,191,192,193,196,197,198,199,200
]

raw_premise_list = [
    5,1,0,1,0,0,0,0,0,0,0,1,4,0,0,0,0,0,0,0,
    1,0,0,0,0,2,1,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,1,4,1,0,0,1,1,1,0,0,1,0,0,5,
    5,0,0,0,0,0,0,0,1,1,0,0,1,0,0,2,1,1,1,1,
    0,0,0,0,2,2,1
]

proven_missing_dict = {
    raw_ids_list[i]: [raw_premise_list[i]]
    for i in range(len(raw_ids_list))
}


# ==============================================================================
# 3. CARREGAMENTO DO MODELO E DATASET
# ==============================================================================
print(f"\n🚀 Carregando {model_name}...")

tokenizer = AutoTokenizer.from_pretrained(
    model_name,
    clean_up_tokenization_spaces=False
)

if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

# Padding à esquerda para geração em batch
tokenizer.padding_side = "left"

config = AutoConfig.from_pretrained(model_name)
if hasattr(config, "rope_scaling") and config.rope_scaling is not None:
    if "attn_factor" in config.rope_scaling:
        del config.rope_scaling["attn_factor"]

model = AutoModelForCausalLM.from_pretrained(
    model_name,
    config=config,
    device_map="auto",
    torch_dtype=torch.float16,
    attn_implementation="flash_attention_2"
)
model.eval()

try:
    EOT_ID = tokenizer.convert_tokens_to_ids("<|eot_id|>")
    if EOT_ID == tokenizer.unk_token_id:
        EOT_ID = tokenizer.eos_token_id
except Exception:
    EOT_ID = tokenizer.eos_token_id

EOS_IDS = list({tokenizer.eos_token_id, EOT_ID})
print(f"✅ EOS ids: {EOS_IDS}")

print("📦 Carregando dataset FOLIO...")
folio_data = load_dataset("yale-nlp/FOLIO", split="validation")
print(f"✅ {len(folio_data)} exemplos carregados")

print("📊 Calculando estratificacao de complexidade...")
complexity_map = build_complexity_map(folio_data)
print(f"✅ {len(complexity_map)} exemplos estratificados")


# ==============================================================================
# 4. CONSTRUCAO DE MENSAGENS
# ==============================================================================
def build_messages(premises_text: str, conclusion_text: str) -> list:
    user_msg = (
        "You are a logic expert.\n\n"
        "Given the following premises and a conclusion, determine whether "
        "the conclusion logically follows from the premises.\n\n"
        f"Premises:\n{premises_text}\n\n"
        f"Conclusion:\n{conclusion_text}\n\n"
        "Please reason step by step. "
        r"Then put your final answer within \boxed{True}, \boxed{False}, "
        r"or \boxed{Uncertain}."
    )
    return [{"role": "user", "content": user_msg}]


# ==============================================================================
# 5. TOKENIZACAO
# ==============================================================================
def tokenize_messages(messages: list) -> torch.Tensor:
    text = tokenizer.apply_chat_template(
        messages, tokenize=False, add_generation_prompt=True
    )
    ids = tokenizer(text, return_tensors="pt", truncation=False)["input_ids"]
    return ids


# ==============================================================================
# 6. AUXILIARES
# ==============================================================================
IRRELEVANT_PREMISES_BANK = [
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

def get_fol_list(ex) -> list:
    fol = ex['premises-FOL']
    lines = fol.split('\n') if isinstance(fol, str) else list(fol)
    return [normalize_fol(line) for line in lines if line.strip()]

def get_conclusion_fol(ex) -> str:
    return normalize_fol(ex['conclusion-FOL'])

def get_text_display(p_list: list) -> str:
    return "\n".join(f"- {p}" for p in p_list)


# ==============================================================================
# 7. PROMPTS DE PERTURBACAO
# ==============================================================================
def prompt_original(ex, idx=None):
    return build_messages(get_text_display(get_fol_list(ex)), get_conclusion_fol(ex))

def prompt_shuffled(ex, idx=None):
    rng = random.Random(RANDOM_SEED + (idx if idx is not None else 0))
    p = get_fol_list(ex)[:]
    rng.shuffle(p)
    return build_messages(get_text_display(p), get_conclusion_fol(ex))

def prompt_junto(ex, idx=None):
    p = get_fol_list(ex)
    joined = " AND ".join(f"({x})" for x in p)
    return build_messages(joined, get_conclusion_fol(ex))

def prompt_irrelevant(ex, idx=None):
    rng = random.Random(RANDOM_SEED + (idx if idx is not None else 0) + 1000)
    p = get_fol_list(ex)[:]
    p.append(rng.choice(IRRELEVANT_PREMISES_BANK))
    rng.shuffle(p)
    return build_messages(get_text_display(p), get_conclusion_fol(ex))

def prompt_missing(ex, idx):
    if idx not in proven_missing_dict:
        return None
    all_premises   = get_fol_list(ex)
    idxs_to_remove = proven_missing_dict[idx]
    valid_indices  = [i for i in idxs_to_remove if 0 <= i < len(all_premises)]
    if not valid_indices:
        return None
    kept = [p for i, p in enumerate(all_premises) if i not in valid_indices]
    if not kept:
        return None
    return build_messages(get_text_display(kept), get_conclusion_fol(ex))

def prompt_complex(ex, idx=None):
    rng = random.Random(RANDOM_SEED + (idx if idx is not None else 0) + 2000)
    p        = get_fol_list(ex)[:]
    original = p[:]
    p.append(rng.choice(original))
    p.append(rng.choice(original))
    rng.shuffle(p)
    return build_messages(get_text_display(p), get_conclusion_fol(ex))

def prompt_contradiction(ex, idx=None):
    rng = random.Random(RANDOM_SEED + (idx if idx is not None else 0) + 3000)
    p = get_fol_list(ex)[:]
    if p:
        p.append(f"NOT ({rng.choice(p)})")
    rng.shuffle(p)
    return build_messages(get_text_display(p), get_conclusion_fol(ex))

def prompt_negation(ex, idx=None):
    return build_messages(
        get_text_display(get_fol_list(ex)),
        f"NOT ({get_conclusion_fol(ex)})"
    )

def prompt_nl(ex, idx=None):
    p = ex['premises']
    if not isinstance(p, list):
        p = p.split('\n')
    return build_messages("\n".join(f"- {x}" for x in p), ex['conclusion'])


# ==============================================================================
# 8. PARAMETROS DE GERACAO
# ==============================================================================
MAX_CONTEXT    = 32768
MAX_NEW_TOKENS = 32768
CHUNK_SIZE     = 5       # tasks por chamada ao model.generate()

OFFICIAL_GEN_PARAMS = {
    "do_sample":   True,
    "temperature": 0.6,
    "top_p":       0.95,
}


# ==============================================================================
# 9. GERACAO DE RESPOSTA — BATCHED
# ==============================================================================
def generate_batch(task_messages: list, idx=None):
    """
    task_messages: lista de (name, messages_list)
    Retorna: lista de dicts com campos de resultado, mesma ordem da entrada.
    """
    names = [t[0] for t in task_messages]
    msgs  = [t[1] for t in task_messages]
    n     = len(msgs)

    # Tokeniza cada mensagem
    encoded = []
    for m in msgs:
        text = tokenizer.apply_chat_template(m, tokenize=False, add_generation_prompt=True)
        ids  = tokenizer(text, return_tensors="pt", truncation=False)["input_ids"][0]
        encoded.append(ids)

    # Filtra prompts que excedem MAX_CONTEXT
    results       = [None] * n
    valid_indices = []
    for i, enc in enumerate(encoded):
        if enc.shape[0] > MAX_CONTEXT:
            print(f"⚠️  Prompt excede MAX_CONTEXT -> id={idx} task={names[i]} | tokens={enc.shape[0]}")
            results[i] = {
                "label": "Error", "text": "", "duration": 0.0, "tps": 0.0,
                "tokens": 0, "chars": 0, "words": 0,
                "truncated": True, "input_len": enc.shape[0]
            }
        else:
            valid_indices.append(i)

    if not valid_indices:
        return results

    # Padding a esquerda (necessario para batch em geracao)
    valid_enc  = [encoded[i] for i in valid_indices]
    max_len    = max(e.shape[0] for e in valid_enc)
    pad_id     = tokenizer.eos_token_id

    input_ids_list = []
    attn_mask_list = []
    for enc in valid_enc:
        pad_len = max_len - enc.shape[0]
        padded  = torch.cat([torch.full((pad_len,), pad_id, dtype=torch.long), enc])
        mask    = torch.cat([torch.zeros(pad_len, dtype=torch.long),
                             torch.ones(enc.shape[0], dtype=torch.long)])
        input_ids_list.append(padded)
        attn_mask_list.append(mask)

    input_ids  = torch.stack(input_ids_list).to(model.device)
    attn_mask  = torch.stack(attn_mask_list).to(model.device)
    input_lens = [encoded[i].shape[0] for i in valid_indices]

    start = time.time()

    with torch.no_grad():
        outputs = model.generate(
            input_ids      = input_ids,
            attention_mask = attn_mask,
            max_new_tokens = MAX_NEW_TOKENS,
            use_cache      = True,
            pad_token_id   = pad_id,
            eos_token_id   = EOS_IDS,
            **OFFICIAL_GEN_PARAMS,
        )

    duration = time.time() - start

    for batch_pos, orig_idx in enumerate(valid_indices):
        # Usa o input_len real de cada sequencia (nao max_len)
        input_len_i = input_lens[batch_pos]
        gen_part    = outputs[batch_pos][input_len_i:]
        total_gen   = gen_part.shape[0]

        full_text = tokenizer.decode(gen_part, skip_special_tokens=True,
                                     clean_up_tokenization_spaces=False)
        full_text = clean_bpe_artifacts(full_text)
        label     = extract_label(full_text, idx=idx)

        tps       = total_gen / duration if duration > 0 else 0.0
        truncated = total_gen >= MAX_NEW_TOKENS

        if truncated:
            print(f"⛔ MAX_NEW_TOKENS atingido -> id={idx} task={names[orig_idx]}")

        print(f"✅ id={idx} task={names[orig_idx]} | tokens={total_gen} | "
              f"tps={tps:.2f} | label={label}", flush=True)

        results[orig_idx] = {
            "label":     label,
            "text":      full_text,
            "duration":  round(duration, 2),
            "tps":       round(tps, 2),
            "tokens":    total_gen,
            "chars":     len(full_text),
            "words":     len(full_text.split()),
            "truncated": truncated,
            "input_len": input_len_i,
        }

    return results


# Mantém assinatura antiga para compatibilidade
def generate_long_response(messages: list, idx=None):
    res = generate_batch([("single", messages)], idx=idx)[0]
    if res is None:
        return ("Error", "", 0.0, 0.0, 0, 0, 0, True, 0, 0)
    return (res["label"], res["text"], res["duration"], res["tps"],
            res["tokens"], res["chars"], res["words"], res["truncated"],
            res["input_len"], res["input_len"])


# ==============================================================================
# VERIFICACAO DE QUALIDADE DO LABEL
# ==============================================================================
def is_label_reliable(pred: str, txt: str) -> bool:
    if not pred:
        return False
    if pred in ("Error", "SKIP") or str(pred).startswith("ERROR"):
        return False
    if pred not in ("True", "False", "Uncertain"):
        return False

    think_end   = txt.rfind("</think>")
    after_think = txt[think_end:] if think_end != -1 else None

    if after_think and BOXED_PATTERN.search(after_think):
        return True
    if after_think and BOXED_PATTERN.search(txt):
        return False
    if think_end == -1 and BOXED_PATTERN.search(txt):
        return True

    return False


# ==============================================================================
# 10. UTILITARIOS PARA RERUNS
# ==============================================================================
def find_incomplete_ids(jsonl_path: str) -> list:
    if not os.path.exists(jsonl_path):
        print("ℹ️  Nenhum JSONL encontrado — primeira execucao, nada a verificar.")
        return []

    incomplete        = []
    unreliable_counts = {}
    tasks = [
        "original", "complex", "nl", "shuffled", "junto",
        "irrelevant", "contradiction", "negation", "missing"
    ]

    with open(jsonl_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
                idx = row["id"]
                bad_tasks = []
                for task in tasks:
                    pred = row.get(f"p_{task}", "")
                    txt  = row.get(f"txt_{task}", "")
                    if pred == "SKIP" or str(pred).startswith("ERROR"):
                        continue
                    if not is_label_reliable(pred, txt):
                        bad_tasks.append(task)
                if bad_tasks:
                    incomplete.append(idx)
                    unreliable_counts[idx] = bad_tasks
                    for task in bad_tasks:
                        pred = row.get(f"p_{task}", "")
                        print(f"❌ ID invalido -> id={idx} | perturbacao={task} | label={pred!r}")
            except Exception as e:
                print(f"Erro ao ler linha: {e}")

    if unreliable_counts:
        print(f"\n📋 IDs com label nao confiavel:")
        for idx, tasks_ruins in sorted(unreliable_counts.items()):
            print(f"   id={idx} | tasks problematicas: {tasks_ruins}")
    else:
        print("✅ Nenhum ID com label nao confiavel encontrado.")

    return sorted(set(incomplete))


def remove_ids_from_jsonl(jsonl_path: str, ids_to_remove: list):
    ids_set  = set(ids_to_remove)
    tmp_path = jsonl_path + ".tmp"
    kept, removed = 0, 0
    with open(jsonl_path, "r", encoding="utf-8") as fin, \
         open(tmp_path,   "w", encoding="utf-8") as fout:
        for line in fin:
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
                if row["id"] in ids_set:
                    removed += 1
                    continue
                fout.write(line + "\n")
                kept += 1
            except Exception:
                fout.write(line + "\n")
    os.replace(tmp_path, jsonl_path)
    print(f"✅ Removidos: {removed} | Mantidos: {kept}")


# ==============================================================================
# 11. EXPERIMENTO — BATCHED COM CHUNKS
# ==============================================================================
def run_full_experiment(specific_ids=None):
    global_start     = time.time()
    total_tokens_all = 0

    target_indices = sorted(specific_ids) if specific_ids else range(len(folio_data))
    configs        = [("fixed", OFFICIAL_GEN_PARAMS)]

    for conf_name, conf_params in configs:

        jsonl_path = f"{OUTPUT_DIR}/results_{file_tag}_{conf_name}.jsonl"

        if os.path.exists(jsonl_path) and os.path.getsize(jsonl_path) > 0:
            processed_ids = set()
            with open(jsonl_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line:
                        try:
                            processed_ids.add(json.loads(line)["id"])
                        except Exception:
                            pass
            print(f"🔄 Retomando — {len(processed_ids)} IDs ja processados")
        else:
            processed_ids = set()

        print(f"\n🟢 Rodada: {conf_name} | modelo: {file_tag}")

        for idx in tqdm(target_indices):

            if idx in processed_ids:
                continue

            torch.cuda.empty_cache()
            gc.collect()

            example = folio_data[idx]
            row     = {"id": idx, "gt": example['label']}

            nl_wc, fol_tc, nl_bin, fol_bin = complexity_map.get(
                idx, (None, None, None, None)
            )
            row["nl_wc"]   = nl_wc
            row["fol_tc"]  = fol_tc
            row["nl_bin"]  = nl_bin
            row["fol_bin"] = fol_bin

            tasks = [
                ("original",      lambda ex=example, i=idx: prompt_original(ex, i)),
                ("complex",       lambda ex=example, i=idx: prompt_complex(ex, i)),
                ("nl",            lambda ex=example, i=idx: prompt_nl(ex, i)),
                ("shuffled",      lambda ex=example, i=idx: prompt_shuffled(ex, i)),
                ("junto",         lambda ex=example, i=idx: prompt_junto(ex, i)),
                ("irrelevant",    lambda ex=example, i=idx: prompt_irrelevant(ex, i)),
                ("contradiction", lambda ex=example, i=idx: prompt_contradiction(ex, i)),
                ("negation",      lambda ex=example, i=idx: prompt_negation(ex, i)),
            ]

            if idx in proven_missing_dict:
                tasks.append(("missing", lambda ex=example, i=idx: prompt_missing(ex, i)))
            else:
                row["p_missing"] = "SKIP"

            # Prepara batch de todas as tasks validas
            batch_input = []
            for name, func in tasks:
                try:
                    messages = func()
                    if messages is None:
                        row[f"p_{name}"] = "SKIP"
                    else:
                        batch_input.append((name, messages))
                except Exception as e:
                    row[f"p_{name}"] = f"ERROR: {e}"
                    print(f"❌ Erro preparando id={idx} task={name}: {e}")

            # Roda tasks em chunks de CHUNK_SIZE para evitar OOM
            if batch_input:
                batch_results = []
                for i in range(0, len(batch_input), CHUNK_SIZE):
                    chunk = batch_input[i:i + CHUNK_SIZE]
                    gc.collect()
                    torch.cuda.empty_cache()
                    try:
                        chunk_results = generate_batch(chunk, idx=idx)
                    except Exception as e:
                        print(f"❌ Erro no batch id={idx}: {e}")
                        chunk_results = [None] * len(chunk)
                    batch_results.extend(chunk_results)

                for (name, _), res in zip(batch_input, batch_results):
                    if res is None:
                        row[f"p_{name}"] = "ERROR: batch returned None"
                        continue
                    tokens = res["tokens"]
                    chars  = res["chars"]
                    words  = res["words"]
                    total_tokens_all += tokens
                    row[f"p_{name}"]               = res["label"]
                    row[f"truncated_{name}"]        = res["truncated"]
                    row[f"input_len_{name}"]        = res["input_len"]
                    row[f"full_len_{name}"]         = res["input_len"]
                    row[f"txt_{name}"]              = res["text"]
                    row[f"time_{name}"]             = res["duration"]
                    row[f"tps_{name}"]              = res["tps"]
                    row[f"tokens_{name}"]           = tokens
                    row[f"chars_{name}"]            = chars
                    row[f"words_{name}"]            = words
                    row[f"chars_per_token_{name}"]  = round(chars / tokens, 4) if tokens > 0 else 0
                    row[f"words_per_token_{name}"]  = round(words / tokens, 4) if words > 0 else 0
                    row[f"tokens_per_word_{name}"]  = round(tokens / words, 4) if words > 0 else 0

            with open(jsonl_path, "a", encoding="utf-8") as f:
                json.dump(row, f, ensure_ascii=False)
                f.write("\n")
                f.flush()
                os.fsync(f.fileno())

    total_time = time.time() - global_start
    print("\n========== RELATORIO ==========")
    print(f"Tempo total:       {total_time / 60:.2f} min")
    print(f"Tokens gerados:    {total_tokens_all:,}")
    print(f"Velocidade media:  {total_tokens_all / total_time:.2f} tok/s")


# ==============================================================================
# 12. ANALISE GERAL DO JSONL
# ==============================================================================
ALL_TASKS = [
    "original", "complex", "nl", "shuffled", "junto",
    "irrelevant", "contradiction", "negation", "missing"
]

def analyze_results(jsonl_path: str):
    if not os.path.exists(jsonl_path):
        print("ℹ️  Nenhum JSONL encontrado — nada para analisar.")
        return

    rows = []
    with open(jsonl_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                try:
                    rows.append(json.loads(line))
                except Exception as e:
                    print(f"⚠️  Linha invalida no JSONL: {e}")

    if not rows:
        print("ℹ️  JSONL vazio.")
        return

    n_total_dataset = len(folio_data) if 'folio_data' in dir() else 204
    ids_processados = {r["id"] for r in rows}
    ids_faltando    = sorted(set(range(n_total_dataset)) - ids_processados)

    print("\n" + "=" * 60)
    print("           📊 ANALISE GERAL DOS RESULTADOS")
    print("=" * 60)
    print(f"  IDs no dataset          : {n_total_dataset}")
    print(f"  IDs processados         : {len(ids_processados)}")
    print(f"  IDs faltando            : {len(ids_faltando)}")
    if ids_faltando:
        print(f"  IDs faltando (lista)    : {ids_faltando}")

    print("\n  --- Contagem de labels por task ---")
    label_vals = ["True", "False", "Uncertain", "Error", "SKIP"]
    header = f"  {'Task':<15}" + "".join(f"{v:>10}" for v in label_vals) + f"{'ERROR:':<10}"
    print(header)
    print("  " + "-" * (15 + 10 * len(label_vals) + 10))

    task_error_counts = {}
    ids_with_error    = set()

    for task in ALL_TASKS:
        counts = {v: 0 for v in label_vals}
        n_exc  = 0
        for row in rows:
            pred = str(row.get(f"p_{task}", ""))
            if pred.startswith("ERROR:"):
                n_exc += 1
                ids_with_error.add(row["id"])
            elif pred in counts:
                counts[pred] += 1
            else:
                counts["Error"] = counts.get("Error", 0) + 1
        task_error_counts[task] = counts["Error"] + n_exc
        line = f"  {task:<15}" + "".join(f"{counts[v]:>10}" for v in label_vals) + f"{n_exc:<10}"
        print(line)

    print("\n  --- Tasks com mais falhas ---")
    for task, cnt in sorted(task_error_counts.items(), key=lambda x: -x[1]):
        bar = "█" * min(cnt, 40)
        print(f"  {task:<15} {cnt:>4}  {bar}")

    ids_any_error = []
    for row in rows:
        for task in ALL_TASKS:
            pred = str(row.get(f"p_{task}", ""))
            if pred in ("Error",) or pred.startswith("ERROR:"):
                ids_any_error.append(row["id"])
                break

    ids_any_error = sorted(set(ids_any_error))
    print(f"\n  IDs com >= 1 Error/excecao : {len(ids_any_error)}")
    if ids_any_error:
        print(f"  Lista                      : {ids_any_error}")

    ids_all_failed = []
    for row in rows:
        tasks_ok = sum(1 for task in ALL_TASKS
                       if str(row.get(f"p_{task}", "")) in ("True", "False", "Uncertain"))
        if tasks_ok == 0:
            ids_all_failed.append(row["id"])

    print(f"\n  IDs onde TODAS tasks falharam : {len(ids_all_failed)}")
    if ids_all_failed:
        print(f"  Lista                         : {sorted(ids_all_failed)}")

    correct, total_valid = 0, 0
    for row in rows:
        gt   = str(row.get("gt", "")).strip().capitalize()
        pred = str(row.get("p_original", "")).strip().capitalize()
        if pred in ("True", "False", "Uncertain"):
            total_valid += 1
            if pred == gt:
                correct += 1

    if total_valid > 0:
        acc = correct / total_valid * 100
        print(f"\n  Acuracia task 'original'  : {correct}/{total_valid} = {acc:.1f}%")
    else:
        print("\n  Acuracia task 'original'  : sem dados validos suficientes")

    print("=" * 60 + "\n")
    return ids_any_error, ids_faltando


# ==============================================================================
# 13. EXECUCAO PRINCIPAL
# ==============================================================================
RANDOM_SEED = 42
random.seed(RANDOM_SEED)

jsonl_path = f"{OUTPUT_DIR}/results_{file_tag}_fixed.jsonl"

print("\n🔍 Analisando resultados existentes...")
result = analyze_results(jsonl_path)
ids_com_error = result[0] if result else []
ids_faltando  = result[1] if result else list(range(len(folio_data)))

print("\n🔍 Verificando qualidade dos labels existentes...")
ids_incompletos = find_incomplete_ids(jsonl_path)

ids_para_remover = sorted(set(ids_com_error) | set(ids_incompletos))

if ids_para_remover:
    print(f"\n⚠️  {len(ids_para_remover)} IDs problematicos — removendo para reprocessamento...")
    remove_ids_from_jsonl(jsonl_path, ids_para_remover)
else:
    print("✅ Nenhum ID problematico encontrado nos dados existentes.")

processed_ids = set()
if os.path.exists(jsonl_path):
    with open(jsonl_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                try:
                    processed_ids.add(json.loads(line)["id"])
                except Exception:
                    pass

todos_os_ids   = list(range(len(folio_data)))
ids_para_gerar = sorted(set(todos_os_ids) - processed_ids)

print(f"\n  Total dataset             : {len(folio_data)}")
print(f"  Ja processados (validos)  : {len(processed_ids)}")
print(f"  Para gerar/regerar        : {len(ids_para_gerar)}")

if ids_para_gerar:
    print(f"\n▶️  Parametros de geracao:")
    print(f"   MAX_NEW_TOKENS = {MAX_NEW_TOKENS}")
    print(f"   MAX_CONTEXT    = {MAX_CONTEXT}")
    print(f"   CHUNK_SIZE     = {CHUNK_SIZE}")
    for k, v in OFFICIAL_GEN_PARAMS.items():
        print(f"   {k} = {v}")
    print("\n▶️  Iniciando geracao (BATCHED)...")
    run_full_experiment(ids_para_gerar)
else:
    print("\n✅ Todos os IDs ja foram processados e validados.")

print("\n📊 Analise final apos geracao completa:")
analyze_results(jsonl_path)