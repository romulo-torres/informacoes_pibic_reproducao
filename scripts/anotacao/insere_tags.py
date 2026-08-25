import re
import json
import difflib

# Grupos de caracteres que o LLM costuma confundir ao "copiar" um trecho.
# Cada grupo lista variantes que devem ser tratadas como equivalentes na
# BUSCA (o texto_original nunca e modificado -- so a regex de busca aceita
# qualquer caractere do grupo no lugar de outro do mesmo grupo).
_GRUPOS_EQUIVALENTES = [
    ['\u2018', '\u2019', "'"],          # aspas simples curvas <-> reta
    ['\u201c', '\u201d', '"'],          # aspas duplas curvas <-> reta
    ['\u2013', '\u2014', '-', '--'],    # en/em-dash <-> hifen simples/duplo
    ['\u2026', '...'],                  # ellipsis unicode <-> 3 pontos
    ['\u00a0', ' '],                    # nbsp <-> espaco normal
]

# Mapa: caractere -> indice do grupo a que pertence (para lookup rapido)
_CHAR_PARA_GRUPO = {}
for _gi, _grupo in enumerate(_GRUPOS_EQUIVALENTES):
    for _ch in _grupo:
        if len(_ch) == 1:
            _CHAR_PARA_GRUPO[_ch] = _gi

# Para o caso especial de '--' (2 chars), tratamos separadamente na regex
_DASH_GRUPO_IDX = next(i for i, g in enumerate(_GRUPOS_EQUIVALENTES) if '-' in g)

# Limiar de similaridade minima para aceitar um match via fuzzy fallback
# (usado so quando a busca exata com tolerancia tipografica falha).
FUZZY_THRESHOLD = 0.82


def _classe_para_char(ch):
    """Gera o trecho de regex para um caractere, expandindo para uma
    classe [abc] se ele pertence a um grupo de equivalencia tipografica."""
    gi = _CHAR_PARA_GRUPO.get(ch)
    if gi is None:
        return re.escape(ch)
    # monta classe de caracteres so com os membros de 1 char do grupo
    membros_1char = [c for c in _GRUPOS_EQUIVALENTES[gi] if len(c) == 1]
    return '[' + ''.join(re.escape(c) for c in membros_1char) + ']'


def _palavra_para_regex(palavra):
    """Converte uma palavra (sem espacos) em um padrao regex que aceita
    variantes tipograficas de cada caractere, e onde um hifen simples
    tambem aceita um hifen duplo adjacente (caso '--')."""
    # primeiro, colapsa '--' na palavra-ancora para um marcador, para nao
    # quebrar a iteracao char-a-char
    padrao = []
    i = 0
    while i < len(palavra):
        if palavra[i:i+2] == '--':
            # aceita '--' OU qualquer variante de dash unica no original
            padrao.append('(?:--|[\u2013\u2014\\-])')
            i += 2
            continue
        ch = palavra[i]
        if ch in ('-', '\u2013', '\u2014'):
            padrao.append('(?:--|[\u2013\u2014\\-])')
        else:
            padrao.append(_classe_para_char(ch))
        i += 1
    return ''.join(padrao)


def _build_flexible_regex(anchor):
    """Cria uma regex a partir da ancora, tolerando:
    - diferencas de espacamento/quebra de linha entre palavras
    - diferencas tipograficas por caractere (aspas curvas/retas, dashes,
      ellipsis, nbsp) SEM jamais alterar o texto_original -- a tolerancia
      e' inteiramente do lado do padrao de busca.
    Continua INTOLERANTE a diferenca de palavras, ordem ou maiusculas."""
    partes = re.split(r'\s+', anchor.strip())
    partes_regex = [_palavra_para_regex(p) for p in partes if p != '']
    padrao = r'\s+'.join(partes_regex)
    return re.compile(padrao)


class _FuzzyMatch:
    """Objeto minimo com interface compativel com re.Match (so start()/
    end()), usado quando a posicao veio do fallback fuzzy em vez de uma
    regex de verdade."""
    def __init__(self, start, end):
        self._start = start
        self._end = end

    def start(self):
        return self._start

    def end(self):
        return self._end


def _fuzzy_search(anchor, texto_original, start=0, threshold=FUZZY_THRESHOLD):
    """Fallback usado SOMENTE quando a busca exata (com tolerancia
    tipografica) falha. Desliza uma janela com o mesmo numero de palavras
    da ancora, a partir da posicao `start` em diante, pelo texto ORIGINAL,
    e usa similaridade de string (difflib) para achar o trecho mais
    parecido de verdade.
    """
    todos_tokens = [(m.group(), m.start(), m.end()) for m in re.finditer(r'\S+', texto_original)]
    tokens = [t for t in todos_tokens if t[1] >= start]
    n = len(anchor.split())
    if n == 0 or len(tokens) < n:
        return None

    melhor_score = 0.0
    melhor_span = None
    for j in range(len(tokens) - n + 1):
        janela_texto = " ".join(t[0] for t in tokens[j:j + n])
        score = difflib.SequenceMatcher(None, anchor, janela_texto).ratio()
        if score > melhor_score:
            melhor_score = score
            melhor_span = (tokens[j][1], tokens[j + n - 1][2])

    if melhor_span is not None and melhor_score >= threshold:
        return melhor_span, melhor_score
    return None


def aplicar_ancoras(texto_original, eventos, busca_retroativa=True, usar_fuzzy=True):
    cursor = 0
    insercoes = []
    erros = []
    avisos = []
    pilha = []
    ultima_posicao_aceita = -1

    for i, ev in enumerate(eventos):
        tag = ev['tag']
        side = ev['side']
        anchor = ev['anchor']

        regex = _build_flexible_regex(anchor)

        occurrence_raw = ev.get('occurrence')
        occurrence_explicit = occurrence_raw is not None
        ambiguo = False

        if occurrence_explicit:
            try:
                occurrence = int(occurrence_raw)
            except (TypeError, ValueError):
                occurrence = None
            m = None
            if occurrence is not None and occurrence >= 1:
                for n, cand in enumerate(regex.finditer(texto_original, cursor), start=1):
                    if n == occurrence:
                        m = cand
                        break
            if m is None:
                erros.append({'index_evento': i, 'tag': tag, 'side': side,
                    'anchor': anchor,
                    'motivo': f'OCORRENCIA_INVALIDA_INDICE_FORA_DO_INTERVALO (occurrence={occurrence_raw!r})'})
                continue
        else:
            matches_it = regex.finditer(texto_original, cursor)
            m = next(matches_it, None)
            ambiguo = m is not None and next(matches_it, None) is not None

            if ambiguo:
                erros.append({'index_evento': i, 'tag': tag, 'side': side,
                    'anchor': anchor,
                    'motivo': 'ANCORA_AMBIGUA_MULTIPLAS_OCORRENCIAS_A_PARTIR_DO_CURSOR'})
                continue

        fora_de_ordem = False
        via_fuzzy = False
        fuzzy_score = None

        if m is None and busca_retroativa:
            m = regex.search(texto_original, 0)
            fora_de_ordem = m is not None

        if m is None and usar_fuzzy:
            resultado_fuzzy = _fuzzy_search(anchor, texto_original, start=cursor)
            if resultado_fuzzy is not None:
                (fs, fe), fuzzy_score = resultado_fuzzy
                m = _FuzzyMatch(fs, fe)
                via_fuzzy = True
            elif busca_retroativa:
                resultado_fuzzy = _fuzzy_search(anchor, texto_original, start=0)
                if resultado_fuzzy is not None:
                    (fs, fe), fuzzy_score = resultado_fuzzy
                    m = _FuzzyMatch(fs, fe)
                    via_fuzzy = True
                    fora_de_ordem = True

        if m is None:
            erros.append({'index_evento': i, 'tag': tag, 'side': side,
                'anchor': anchor, 'motivo': 'ANCORA_NAO_ENCONTRADA_NO_TEXTO_ORIGINAL'})
            continue

        idx = m.start() if side == 'open' else m.end()

        if idx < ultima_posicao_aceita:
            erros.append({'index_evento': i, 'tag': tag, 'side': side,
                'anchor': anchor,
                'motivo': 'ANCORA_FORA_DE_ORDEM_CAUSARIA_ENTRELACAMENTO'})
            continue

        if fora_de_ordem:
            avisos.append({'index_evento': i, 'tag': tag, 'side': side,
                'anchor': anchor, 'motivo': 'ANCORA_ENCONTRADA_FORA_DA_ORDEM_ESPERADA'})

        if via_fuzzy:
            avisos.append({'index_evento': i, 'tag': tag, 'side': side,
                'anchor': anchor,
                'motivo': f'ANCORA_ENCONTRADA_VIA_FUZZY_MATCH (similaridade={fuzzy_score:.2f})'})

        if side == 'close' and not (pilha and pilha[-1] == tag):
            erros.append({'index_evento': i, 'tag': tag, 'side': side,
                'anchor': anchor,
                'motivo': f'FECHAMENTO_SEM_ABERTURA_CORRESPONDENTE (pilha atual: {pilha})'})
            continue

        tag_str = f'<{tag}>' if side == 'open' else f'</{tag}>'
        insercoes.append((idx, i, tag_str))
        cursor = m.end()
        ultima_posicao_aceita = idx

        if side == 'open':
            pilha.append(tag)
        else:
            pilha.pop()

    insercoes.sort(key=lambda x: (x[0], x[1]))
    partes = []
    ultimo = 0
    for idx, _, tag_str in insercoes:
        partes.append(texto_original[ultimo:idx])
        partes.append(tag_str)
        ultimo = idx
    partes.append(texto_original[ultimo:])
    texto_final = ''.join(partes)

    relatorio = {'erros': erros, 'avisos': avisos, 'pilha_aberta': pilha,
                 'n_eventos': len(eventos), 'n_inseridos': len(insercoes)}
    return texto_final, relatorio


def verificar_integridade(texto_original, texto_final, tags):
    """Confere, por seguranca extra, que remover as tags do texto_final
    devolve exatamente o texto_original (ignorando so espacamento)."""
    tag_re = re.compile(r'</?(?:' + '|'.join(tags) + r')>')
    sem_tags = tag_re.sub(' ', texto_final)

    def to_words(t):
        return re.sub(r'\s+', ' ', t).strip().split(' ')

    return to_words(sem_tags) == to_words(texto_original)


if __name__ == '__main__':
    import sys

    if len(sys.argv) != 4:
        print('Uso: python inserir_tags.py <texto_original.txt> <ancoras.json> <saida.txt>')
        sys.exit(1)

    path_texto, path_json, path_saida = sys.argv[1], sys.argv[2], sys.argv[3]

    with open(path_texto, encoding='utf-8') as f:
        texto_original = f.read()
    with open(path_json, encoding='utf-8') as f:
        eventos = json.load(f)

    texto_final, relatorio = aplicar_ancoras(texto_original, eventos)

    with open(path_saida, 'w', encoding='utf-8') as f:
        f.write(texto_final)

    ok = verificar_integridade(texto_original, texto_final, ['DEFINE', 'BLOOM', 'CYCLE', 'FINAL', 'r', 'v'])

    print(f"Eventos recebidos: {relatorio['n_eventos']}")
    print(f"Tags inseridas:    {relatorio['n_inseridos']}")
    print(f"Integridade do texto original preservada: {'SIM' if ok else 'NAO -- revisar!'}")