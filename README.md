# Reprodução dos Experimentos — PIBIC 2024/2025

**Título:** Caracterização da capacidade de raciocinar de LLMs adquirida por meio de Reinforcement Learning sob uma perspectiva de Lógica de Primeira Ordem  
**Autor:** Rômulo Fernandes Torres  
**Orientador:** Marco Antonio Pinheiro de Cristo  
**Instituição:** IComp / UFAM  

---

## Visão Geral

Este repositório contém os scripts para reproduzir os experimentos descritos no relatório final do PIBIC. O experimento avalia dois modelos de linguagem no benchmark FOLIO sob nove condições de perturbação lógica.

| Modelo | Papel |
|--------|-------|
| `meta-llama/Llama-3.1-8B-Instruct` | LLM — baseline |
| `deepseek-ai/DeepSeek-R1-Distill-Llama-8B` | LRM — refinado com RL |

**Dataset:** [FOLIO](https://huggingface.co/datasets/yale-nlp/FOLIO) — partição de validação (203 instâncias)

---

## Estrutura do Repositório

```
.
├── README.md
├── requirements.txt
├── data/
│   └── provenance_missing_ids.json      # IDs validados pelo Vampire + índices de premissas
├── scripts/
│   ├── inference.py                     # Inferência dos modelos nas 9 tasks
│   ├── identifica_contradiction.py      # Julgamento da task contradiction via GPT
│   ├── update_correct_column.py         # Integra julgamento externo ao CSV principal
│   └── anotacao/
│       ├── rotulacao.py                 # Pipeline de anotação das cadeias (OpenAI)
│       ├── pipeline_anotacao_completo.py  # Variante que lê resultados_completos.csv
│       └── insere_tags.py               # Inserção determinística de tags via âncoras
├── latex/
│   └── apendice.tex                     # Apêndice com os 9 prompts aplicados ao exemplo
└── results/
    └── .gitkeep                         # JSONLs de resultado (não versionados)
```

---

## Ambiente Computacional

Os experimentos foram executados em uma máquina virtual no **Google Cloud Platform**, região `us-east1` (Carolina do Sul), com GPU **NVIDIA L4 (23 GB VRAM)**.

| Item | Versão |
|------|--------|
| Python | 3.12 |
| PyTorch | 2.9.1+cu129 |
| CUDA | 13.0 |
| Driver NVIDIA | 580.159.03 |
| Kernel | Linux 6.17.0-1018-gcp (Ubuntu 24.04 LTS) |
| Implementação de atenção | FlashAttention-2 |
| Precisão | float16 |

> Os resultados temporais (tokens/s, duração) variam conforme hardware. Os valores de acurácia são reproduzíveis com semente `RANDOM_SEED = 42` e temperatura `T = 0.6`.

---

## Instalação

```bash
git clone https://github.com/<seu-usuario>/<seu-repo>.git
cd <seu-repo>
pip install -r requirements.txt
```

### Acesso aos modelos (HuggingFace)

```bash
# 1. Aceite os termos do Llama em: https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct
# 2. Autentique:
huggingface-cli login
```

---

## Reprodução Passo a Passo

### Passo 1 — Inferência

Edite `SELECTED_INDEX` no topo de `scripts/inference.py` para escolher o modelo:

```python
MODELS = [
    "meta-llama/Llama-3.1-8B-Instruct",        # índice 0 — LLM
    "deepseek-ai/DeepSeek-R1-Distill-Llama-8B", # índice 1 — LRM
]
SELECTED_INDEX = 0  # altere para 0 (LLM) ou 1 (LRM)
```

Para rodar um subconjunto de IDs ou tasks, edite no topo do arquivo:

```python
TARGET_IDS:   list | None = None  # ex: [102, 5] para IDs específicos; None = todos
TARGET_TASKS: list | None = None  # ex: ["original", "nl"]; None = todas as 9
```

Execute para cada modelo:

```bash
# LLM
python3 scripts/inference.py   # com SELECTED_INDEX = 0

# LRM
python3 scripts/inference.py   # com SELECTED_INDEX = 1
```

O script retoma automaticamente de onde parou se interrompido. Os resultados são salvos em `results/`:

```
results/results_Llama-3.1-8B-Instruct_fixed.jsonl
results/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl
```

Cada linha do JSONL contém, para cada instância × task:

| Campo | Descrição |
|-------|-----------|
| `p_<task>` | Label predito: `True`, `False`, `Uncertain`, `Error` ou `SKIP` |
| `txt_<task>` | Resposta completa do modelo |
| `tokens_<task>`, `time_<task>`, `tps_<task>` | Métricas de inferência |
| `gt` | Rótulo de referência do FOLIO |
| `nl_wc`, `fol_tc`, `nl_bin`, `fol_bin` | Métricas de complexidade |

**Tempo estimado com NVIDIA L4:**
- LLM (Llama Instruct): ~1–2 h para 203 instâncias
- LRM (DeepSeek R1): ~8–12 h (cadeias de raciocínio muito mais longas)

---

### Passo 2 — Anotação das Cadeias de Raciocínio (opcional)

A análise qualitativa das cadeias de raciocínio do LRM e o julgamento da task **Contradição Injetada** foram feitos com os scripts em `scripts/anotacao/`, que chamam a API da OpenAI (modelo `gpt-5.6-terra`).

> ⚠️ Esta etapa **não é determinística** e **tem custo** (tokens da API OpenAI). O CSV com as anotações já geradas está disponível em [link — preencher após publicar no Zenodo/HuggingFace].

Para reproduzir a anotação:

```bash
pip install openai python-dotenv

# Crie o arquivo .env com sua chave (nunca commite este arquivo)
echo "OPENAI_KEY=sk-..." > .env

# Configure IDS_TO_RUN e VARIANTS_TO_RUN em scripts/anotacao/rotulacao.py
# Depois execute:
python3 scripts/anotacao/pipeline_anotacao_completo.py
```

---

### Passo 3 — Julgamento da Contradição

```bash
python3 scripts/identifica_contradiction.py
```

Integra o veredicto do GPT ao CSV principal:

```bash
python3 scripts/update_correct_column.py \
    resultados_completos_contradiction_judged.csv \
    resultados_completos.csv \
    resultados_completos_atualizado.csv
```

> Se pular este passo, a acurácia de `contradiction` será ~47% em vez dos ~88–92% reportados.

---

### Passo 4 — Calcular Acurácia e Gerar Tabela LaTeX

O script `gera_tabela_acuracia.py` (disponível na conversa de desenvolvimento) lê os JSONLs e gera a tabela diretamente:

```bash
pip install scipy

python3 gera_tabela_acuracia.py \
    --instruct results/results_Llama-3.1-8B-Instruct_fixed.jsonl \
    --rl       results/results_DeepSeek-R1-Distill-Llama-8B_fixed.jsonl \
    --out      latex/tabela_acuracia.tex
```

O que o script calcula:
- Acurácia por model × task (denominador = predições válidas)
- Task `missing`: restrita aos 87 IDs de `data/provenance_missing_ids.json`
- Task `negation`: critério invertido (`gt=True → correto se pred=False`)
- Ganho relativo em relação à condição Original
- Teste de McNemar com correção de Edwards (Dietterich, 1998), α = 0,05

---

## Tasks e Perturbações

| # | Task | Descrição | Semente |
|---|------|-----------|---------|
| 1 | `original` | Instância original em FOL | — |
| 2 | `nl` | Linguagem natural (sem notação simbólica) | — |
| 3 | `shuffled` | Premissas embaralhadas | `42 + id` |
| 4 | `junto` | Premissas concatenadas por `AND` | — |
| 5 | `irrelevant` | Premissa irrelevante inserida + embaralhamento | `42 + id + 1000` |
| 6 | `missing` | Premissa relevante removida (validada pelo Vampire) | — |
| 7 | `complex` | Duas premissas duplicadas + embaralhamento | `42 + id + 2000` |
| 8 | `contradiction` | Negação de uma premissa inserida + embaralhamento | `42 + id + 3000` |
| 9 | `negation` | Conclusão negada | — |

Os IDs válidos para `missing` e os índices de premissas removíveis estão em `data/provenance_missing_ids.json`, gerado com o provador **Vampire 5.0.0** (limite: 360 s/instância).

---

## Parâmetros de Geração

| Parâmetro | Valor |
|-----------|-------|
| Temperatura | 0,6 |
| top_p | 0,95 |
| do_sample | True |
| max_new_tokens | 32.768 |
| Precisão | float16 |
| Atenção | FlashAttention-2 |
| Semente aleatória | 42 |

---

## Resultados Esperados

| Perturbação | LLM (%) | LRM (%) |
|-------------|---------|---------|
| Original | 50,2 | **56,7** |
| Linguagem Natural | 55,2 | **60,6** |
| Premissas Embaralhadas | 53,7 | **58,1** |
| Premissas Juntas (AND) | 54,2 | **60,1** |
| Ruído Irrelevante | **56,7** | 56,2 |
| Premissa Faltante | **25,3** | 13,8 |
| Duplicação de Premissas | 50,7 | **60,6\*** |
| Contradição Injetada† | 88,7 | **92,1** |
| Negação da Conclusão | 53,2 | **56,2** |

†Acurácia de reconhecimento da contradição, avaliada com julgamento externo (GPT-5.6 Terra).  
\* Diferença estatisticamente significativa entre LLM e LRM (McNemar, p < 0,05).

---

## Citação

```bibtex
@misc{torres2025pibic,
  author = {Rômulo Fernandes Torres},
  title  = {Caracterização da capacidade de raciocinar de LLMs adquirida
             por meio de Reinforcement Learning sob uma perspectiva de
             Lógica de Primeira Ordem},
  year   = {2025},
  note   = {Relatório Final PIBIC, Unioeste}
}
```

---

## Licença

MIT