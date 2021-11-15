### Nome: Francisco Catanho Barreto Tomé Gouveia
### IST_ID: ist1102571
### 1ªAno LEIC-T

# TAD posicao
# Representacao[posicao]: (x, y)
# Construtores
def cria_posicao(x, y):
    """Recebe as coordenadas e devolve a repsentacao da posicao: (x,y).
    cria_posicao: int, int --->>> posicao"""
    if type(x) != int or type(y) != int or x < 0 or y < 0:
        raise ValueError("cria_posicao: argumentos invalidos")
    return (x, y)


def cria_copia_posicao(p):
    """Recebe uma posicao e devovlve uma copia da posicao.
    cria_copia_posicao: posicao --->>> posicao"""
    if type(p) != tuple or len(p) != 2 or obter_pos_x(p) < 0 or obter_pos_y(p) < 0:
        raise ValueError("cria_copia_posicao: argumentos invalidos")
    return (obter_pos_x(p), obter_pos_y(p))


# Seletores
def obter_pos_x(p):
    """Devolve a componente x da posicao
    obter_pos_x: posicao --->>> int"""
    return p[0]


def obter_pos_y(p):
    """Devolve a componente y da posicao
    obter_pos_y: posicao --->>> int"""
    return p[1]


# Reconhecedor
def eh_posicao(arg):
    """Verifica se o argumento é um TAD posicao valido.
    universal --->>> boolean"""
    return type(arg) == tuple and len(arg) == 2 and \
        type(obter_pos_x(arg)) == int and type(obter_pos_y(arg)) == int and \
        obter_pos_x(arg) >= 0 and obter_pos_y(arg) >= 0


# Teste
def posicoes_iguais(p1, p2):
    """Compara as posicoes e devolve True se forem iguais.
    posicoes_iguais: posicao, posicao --->>> boolean"""
    return eh_posicao(p1) and eh_posicao(p2) and posicao_para_str(p1) == posicao_para_str(p2)


# Transformador
def posicao_para_str(p):
    """Devolve a cadeia de caracteres que repesenta a posicao (argumento passado).
    posicao_para_str: posicao --->>> string"""
    return "(" + str(obter_pos_x(p)) + ", " + str(obter_pos_y(p)) + ")"


# Funcoes de Alto Nivel
def obter_posicoes_adjacentes(p):
    """Devolve um tuplo com as posicoes adjacentes a posicao p.
    As posicoes adjacentes seguem pelo sentido horario e começam pela posicao acima (12h)
    obter_posicoes_adjacentes: posicao --->>> tuplo"""
    tuplo_posicoes = ()
    x, y = obter_pos_x(p), obter_pos_y(p)
    ### REVER A ABSTRACAO DE DADOS
    # No eh_posicao, utilizar a funcao criar_posicao
    try:
        if eh_posicao(cria_posicao(x, y - 1)):
            tuplo_posicoes += (cria_posicao(x, y - 1),)
    except:
        pass
    try:
        if eh_posicao(cria_posicao(x + 1, y)):
            tuplo_posicoes += (cria_posicao(x + 1, y),)
    except:
        pass
    try:
        if eh_posicao(cria_posicao(x, y + 1)):
            tuplo_posicoes += (cria_posicao(x, y + 1),)
    except:
        pass
    try:
        if eh_posicao(cria_posicao(x - 1, y)):
            tuplo_posicoes += (cria_posicao(x - 1, y),)
    except:
        pass

    return tuplo_posicoes


def ordenar_posicoes(t):
    """Devolve um tuplo contendo as mesmas posicoes mas de acordo com a ordem de leitura do prado.
    ordenar_posicoes: tuple --->>> tuple"""
    # Problema de Abstraçãooo
    #####  REVERRRR #########
    posicao_para_lista = []
    for posicao in t:
        posicao_para_lista += (posicao,)
    posicao_para_lista.sort(key=lambda x: x[::-1])
    return tuple(posicao_para_lista)


# TAD Animal
# Repsentacao[animal]: {especie: s, idade: 0, freq_rep: fr, fome: 0, freq_alim: fa, tipo: p}
# Construtores
def cria_animal(s, r, a):
    """Recebe a especie, a frequencia de reproducao e de alimentacao, e devolve um TAD animal.
    cria_animal: string, int, int --->>> animal"""
    if not (type(s) == str and s.isalpha() and
            type(r) == int and r > 0 and type(a) == int and a >= 0):
        raise ValueError("cria_animal: argumentos invalidos")
    return {"especie": s,
            "idade": 0,
            "frequencia_reproducao": r,
            "fome": 0,
            "frequencia_alimentacao": a
            }


def cria_copia_animal(a):
    """Recebe um animal e devolve uma copia desse animal.
    cria_copia_animal: animal --->>> animal"""
    if not (type(a) == dict and len(a) == 5 and
            type(obter_especie(a)) == str and type(obter_freq_reproducao(a)) == int and
            type(obter_freq_alimentacao(a)) == int and type(obter_idade(a)) == int and
            type(obter_fome(a)) == int and obter_freq_reproducao(a) > 0 and
            obter_freq_alimentacao(a) >= 0 and obter_idade(a) >= 0 and obter_fome(a) >= 0):
        raise ValueError("cria_copia_animal: argumentos invalidos")

    return {"especie": obter_especie(a),
            "idade": obter_idade(a),
            "frequencia_reproducao": obter_freq_reproducao(a),
            "fome": obter_fome(a),
            "frequencia_alimentacao": obter_freq_alimentacao(a)
            }


# Seletores
def obter_especie(a):
    """Devolve a componente especie do animal.
    obter_especie: animal --->>> string"""
    return a["especie"]


def obter_freq_reproducao(a):
    """Devolve a componente frequencia_reproducao do animal.
    obter_freq_reproducao: animal --->>> int"""
    return a["frequencia_reproducao"]


def obter_freq_alimentacao(a):
    """Devolve a componente frequencia_alimentacao do animal.
    obter_freq_alimentacao: animal --->>> int"""
    return a["frequencia_alimentacao"]


def obter_idade(a):
    """Devolve a componente idade do animal.
    obter_idade: animal --->>> int"""
    return a["idade"]


def obter_fome(a):
    """Devolve a componente fome do animal.
    obter_fome: animal --->>> int"""
    return a["fome"]


# Modificadores
def aumenta_idade(a):
    """Incrementa em uma unidade o valor da idade do animal, e devolve o proprio animal.
    Esta funcao modifica destrutivamente o animal a.
    aumenta_idade: animal --->>> idade"""
    a["idade"] = obter_idade(a) + 1
    return a


def reset_idade(a):
    """Define o valor da idade do animal para 0 (zero).
    Esta funcao modifica destrutivamente o animal a.
    reset_idade: animal --->>> animal"""
    a["idade"] = 0
    return a


def aumenta_fome(a):
    """Incrementa em uma unidade o valor da fome do predador, e devolve o proprio animal.
    Esta funcao modifica destrutivamente o animal a.
    aumenta_fome: animal --->>> animal"""
    if eh_predador(a):
        a["fome"] = obter_fome(a) + 1
    return a


def reset_fome(a):
    """Define o valor da fome do animal para 0 (zero).
    Esta funcao modifica destrutivamnte o animal a.
    reset_fome: animal --->>> animal"""
    if eh_predador(a):
        a["fome"] = 0
    return a


# Reconhecedores
def eh_animal(arg):
    """Verifica o argumento passado e se for um TAD animal devolve um valor logico de acordo.
    eh_animal: universal --->>> boolean"""
    return (type(arg) == dict and len(arg) == 5 and
            type(obter_especie(arg)) == str and type(obter_freq_reproducao(arg)) == int and
            type(obter_freq_alimentacao(arg)) == int and type(obter_idade(arg)) == int and
            type(obter_fome(arg)) == int and obter_freq_reproducao(arg) > 0 and
            obter_freq_alimentacao(arg) >= 0 and obter_idade(arg) >= 0 and obter_fome(arg) >= 0)


def eh_predador(arg):
    """Verifica se o argumento passado e um TAD animal do tipo predador, e devolve um valor logico de acordo.
    eh_predador: universal --->>> boolean"""
    return eh_animal(arg) and obter_freq_alimentacao(arg) > 0


def eh_presa(arg):
    """Verifica se o argumento passado e um TAD animal do tipo presa, e devolve um valor logico de acordo.
    eh_presa: universal --->>> boolean"""
    return eh_animal(arg) and not obter_freq_alimentacao(arg) > 0


# Teste
def animais_iguais(a1, a2):
    """Verifica se os dois animais passados como argumentos são iguais.
    animais_iguais: animal, animal --->>> boolean"""
    #return a1 == a2
    return eh_animal(a1) and eh_animal(a2) and \
            obter_especie(a1) == obter_especie(a2) and \
            obter_idade(a1) == obter_idade(a2) and \
            obter_freq_reproducao(a1) == obter_freq_reproducao(a2) and \
            obter_fome(a1) == obter_fome(a2) and \
            obter_freq_alimentacao(a1) == obter_freq_alimentacao(a2) and \
            eh_presa(a1) == eh_presa(a2) and eh_predador(a1) == eh_predador(a2)



# Transformadores
def animal_para_char(a):
    """Devolve uma string com a letra inicial da espécie do animal passado como argumento.
    Se o animal for predador, a letra e maiuscula, se for presa, a letra e minuscula.
    animal_para_char: animal --->>> char"""
    return obter_especie(a)[0].upper() if eh_predador(a) else obter_especie(a)[0].lower()


def animal_para_str(a):
    """Devolve uma string com a especie, a idade/freq_reproducao e fome/freq_alimentacao.
    animal_para_str: animal --->>> str"""
    if eh_presa(a):
        return "{} [{}/{}]".format(obter_especie(a), obter_idade(a), obter_freq_reproducao(a))
    else:
        return "{} [{}/{};{}/{}]".format(obter_especie(a), obter_idade(a), obter_freq_reproducao(a), obter_fome(a), obter_freq_alimentacao(a))


# Funcoes de Alto Nivel
def eh_animal_fertil(a):
    """Verifica se o animal atingiu a idade de reproducao, e devolve um valor logico de acordo.
    eh_animaL_fertil: animal --->>> boolean"""
    return obter_idade(a) >= obter_freq_reproducao(a)


def eh_animal_faminto(a):
    """Verifica se o valor da fome e igual ou superior a frequencia de alimentacao.
    As presas devolvem sempre False.
    eh_animal_faminto: animal --->>> boolean"""
    return eh_predador(a) and obter_fome(a) >= obter_freq_alimentacao(a)


def reproduz_animal(a):
    """Recebe um animal a devolvendo um novo animal da mesma especie, mas com idade e e fome igual a 0 (zero).
    Esta funcao modifica destrutivamente o animal passado como argumetno, alterando a sua idade para 0 (zero).
    reproduz_animal: animal --->>> animal"""
    novo_animal = reset_idade(reset_fome(cria_copia_animal(a)))
    reset_idade(a)
    return novo_animal


# TAD Prado
# Representacao[prado]: {roch_extr: d, roch_prad: r, animais_prado: a, posicoes_animais: p}
# Construtores:
def cria_prado(d, r, a, p):
    """Recebe uma posicao d (montanho do canto inferior direito), um tuplo r com posicoes de rochedos, um tuplo a de animais, e um tuplo p com as posicoes ocupadas por esses animais.
    A funcao devole o prado que representa internamente o mapa e os animais presentes.
    cria_prado: posicao, tuplo, tuplo --->>> prado"""
    if not(eh_posicao(d) and type(r) == tuple and len(r) >= 0 and verifica_rochedos(r, d) and
            type(a) == tuple and len(a) > 0 and verifica_animais(a) and
            type(p) == tuple and len(p) == len(a) and verifica_posicoes_animais(p, d, r)):
        raise ValueError("cria_prado: argumentos invalidos")

    return {"rochedo_extremidade": d,
            "rochedos_prado": r,
            "animais_prado": a,
            "posicoes_animais": p
            }
def verifica_rochedos(r, d):
    # Funcao auxiliar
    lim_direita = obter_pos_x(d)
    lim_baixo = obter_pos_y(d)
    return all(map(lambda x: eh_posicao(x) and 0 < obter_pos_x(x) < lim_direita and 0 < obter_pos_y(x) < lim_baixo, r))
def verifica_animais(a):
    # Funcao auxiliar
    return all(map(lambda x: eh_animal(x), a))
def verifica_posicoes_animais(p, d, r):
    # Funcao auxiliar
    lim_direita = obter_pos_x(d)
    lim_baixo = obter_pos_y(d)
    return any(map(lambda x: eh_posicao(x) and x not in r and 0 < obter_pos_x(x) < lim_direita and 0 < obter_pos_y(x) < lim_baixo, p))


def cria_copia_prado(m):
    """Recebe um prado e devolve uma nova copia do prado.
    cria_copia_prado: prado --->>> prado"""
    ### Problema de abstração
    return {"rochedo_extremidade": (obter_tamanho_x(m) - 1, obter_tamanho_y(m) - 1),
            "rochedos_prado": obter_rochedos(m),
            "animais_prado": obter_animais(m),
            "posicoes_animais": m["posicoes_animais"] #Rever expressao
            }


# Seletores
def obter_tamanho_x(m):
    """Devolve o valor correspondente à dimensao x do prado (comprimento).
    obter_tamanho: prado --->>> int"""
    return m["rochedo_extremidade"][0] + 1


def obter_tamanho_y(m):
    """Devolve o valor correspondente a dimensao y do prado (largura).
    obter_tamanho_y: prado --->>> int"""
    return m["rochedo_extremidade"][1] + 1


def obter_rochedos(m):
    # Funcao auxiliar
    """Devolve o conjunto de rochedos do prado.
    obter_rochedos: prado --->>> tuple"""
    return m["rochedos_prado"]

def obter_posicoes_nao_ordenadas(m):
    # Funcao auxiliar
    return m["posicoes_animais"]

def obter_animais(m):
    # Funcao auxiliar
    """ Devolve o conjunto de animais do prado.
    obter_animais: prado --->>> tuple"""
    return m["animais_prado"]


def obter_numero_predadores(m):
    """Devolve o numero de animais predadores no prado.
    obter_numero_predadores: prado --->>> int"""
    return len(list(filter(lambda x: eh_predador(x), list(obter_animais(m)))))


def obter_numero_presas(m):
    """Devolve o numero de presas no prado.
    obter_numero_presas: prado --->>> int"""
    return len(list(filter(lambda x: eh_presa(x), list(obter_animais(m)))))


def obter_posicao_animais(m):
    """Devolve um tuplo contendo as posicoes do prado ocupadas por animais.
    As posicoes do tuplo estao ordenadas em ordem de leitura do prado.
    obter_posicoes_animais: prado --->>> tuple(posicoes)"""
    return ordenar_posicoes(m["posicoes_animais"])


def obter_animal(m, p):
    """Devolve o animal do prado que se encontra na posicao p.
    obter_animal: prado, posicao --->>> animal"""
    return obter_animais(m)[m["posicoes_animais"].index(p)]


# Modificadores
def eliminar_animal(m, p):
    """Modifica destrutivamente o prado eliminando o animal da posicao, deixando-a livre.
    eliminar_animal: prado, posicao --->>> prado"""
    ind = obter_posicoes_nao_ordenadas(m).index(p)
    elimina_pos, elimina_anim = list(obter_posicoes_nao_ordenadas(m)), list(obter_animais(m))
    del elimina_pos[ind]
    del elimina_anim[ind]
    ##### REVER ######
    ### Cuidado com a abstracao da linha abaixo!
    m["posicoes_animais"], m["animais_prado"] = tuple(elimina_pos), tuple(elimina_anim)
    return m


def mover_animal(m, p1, p2):
    """Modifica destrutivamente o prado movimentando o animal da posicao p1 para a p2.
    Depois da movimentacao a posicao onde se encontrava passa a estar livre.
    mover_animal: prado, posicao, posicao"""
    ind = m["posicoes_animais"].index(p1)
    substitui = list(m["posicoes_animais"])
    substitui[ind] = p2
    m["posicoes_animais"] = tuple(substitui)
    return m


def inserir_animal(m, a, p):
    """Modifica destrutivamente o prado, acrescentando o animal passado como arg na posicao passada como arg.
    inserir_animal: prado, animal, posicao --->>> prado"""
    animal_adicionado = list(m["animais_prado"])
    animal_adicionado.append(a)
    posicao_adicionada = m["posicoes_animais"] + (p,)
    m["animais_prado"], m["posicoes_animais"] = tuple(animal_adicionado), posicao_adicionada
    return m


# Reconhecedores
def eh_prado(arg):
    """Verifica o argumento passado e se for um TAD prado devolve um valor logico de acordo.
    eh_prado: universal --->>> boolean"""
    return type(arg) == dict and  len(arg) == 4 and  \
            type(cria_posicao(obter_tamanho_x(arg)-1, obter_tamanho_y(arg)-1)) == tuple and eh_posicao(cria_posicao(obter_tamanho_x(arg)-1, obter_tamanho_y(arg)-1)) and \
            type(obter_rochedos(arg)) == tuple and verifica_rochedos(obter_rochedos(arg), cria_posicao(obter_tamanho_x(arg)-1, obter_tamanho_y(arg)-1)) and \
            type(obter_animais(arg)) == tuple and verifica_animais(obter_animais(arg)) and \
            type(obter_posicoes_nao_ordenadas(arg)) == tuple and verifica_posicoes_animais(obter_posicoes_nao_ordenadas(arg), cria_posicao(obter_tamanho_x(arg)-1, obter_tamanho_y(arg)-1), obter_rochedos(arg))


def eh_posicao_animal(m, p):
    """Verifica se a posicao p do prado esta ocupada por um animal, devolvendo um valor logico de acordo.
    eh_posicao_animal: prado, posicao --->>> boolean"""
    return p in obter_posicao_animais(m)


def eh_posicao_obstaculo(m, p):
    """Verifica se a posicao p do prado m esta ocupada por uma montanha ou rochedo, devolvendo um valor de logico de acordo.
    eh_posicao_obstaculo: prado, posicao --->>> boolean"""
    def verifica_rochedo():
        return p in obter_rochedos(m)
    def verifica_montanhas():
        return obter_pos_x(p) in (0, obter_tamanho_x(m) - 1) or obter_pos_y(p) in (0, obter_tamanho_y(m)-1)
    return verifica_rochedo() or verifica_montanhas()


def eh_posicao_livre(m, p):
    """Verifica se a posicao p do prado m corresponde a um espaco livre, devolvendo um valor logico de acordo.
    eh_posicao_livre: prado, posicao --->>> boolean"""
    return not (eh_posicao_animal(m, p) or eh_posicao_obstaculo(m, p))


# Teste
def prados_iguais(p1, p2):
    """Verifica se o prado p1 é igual ao prado p2, devolvendo um valor logico de acordo.
    prados_iguais: prado, prado --->>> boolean"""
    return obter_tamanho_x(p1) == obter_tamanho_x(p2) and \
            obter_tamanho_y(p1) == obter_tamanho_y(p2) and \
            obter_rochedos(p1) == obter_rochedos(p2) and \
            obter_animais(p1) == obter_animais(p2) and \
            obter_posicoes_nao_ordenadas(p1) == obter_posicoes_nao_ordenadas(p2)
            # Ter em atencao que "posicoes_animais" está pela ordem dos animais, e "obter_posicao_animais" esta ordenado de forma diferente.


# Transformador
def prado_para_str(m):
    """Devolve uma string que representa o prado.
    prado_para_str: prado --->>> string"""
    # Rever o codigo com alvo em eficiencia e facilidade de leitura.
    coord_x = obter_tamanho_x(m)
    coord_y = obter_tamanho_y(m)
    cantos = (cria_posicao(0, 0), cria_posicao(coord_x-1, 0), cria_posicao(0, coord_y-1), cria_posicao(coord_x-1, coord_y-1))
    string_final = ""
    for y in range(0, coord_y):
        for x in range(0, coord_x):
            pos = cria_posicao(x, y)
            if pos in cantos:
                string_final += "+"
            elif obter_pos_x(pos) in (0, coord_x-1):
                string_final += "|"
            elif obter_pos_y(pos) in (0, coord_y-1):
                string_final += "-"
            elif eh_posicao_obstaculo(m, pos):
                string_final += "@"
            else:
                try:
                    string_final += animal_para_char(obter_animal(m, pos))
                except:
                    string_final += "."
        string_final += "\n"
    return string_final[:-1]

# Funcoes de Alto Nivel
def obter_valor_numerico(m, p):
    """Devolve o valor numérico correspondente à leitura do prado.
    obter_valor_numerico: prado, posicao --->>> int"""
    return obter_pos_x(p) + obter_tamanho_x(m) * obter_pos_y(p)


def obter_movimento(m, p):
    """Devolve a posicao seguinte do animal na posicao p de acordo com as regras de movimento.
    Regras de movimento:
    --->>> Os animais movem-se para cima ou baixo, esquerda ou direita.
    --->>> As montanhas e rochedo não podem ser ocupados por nenhum animal.
    --->>> Se não houver posicoes adjacentes vazias, o animal permanece na posicao.
    --->>> Os predadores tentam mover-se para uma posicao adjacente que tenha uma presa.
    obter_movimento: prado, posicao --->>> prado"""
    def verifica_posicao(m, p):
        coord_x = obter_tamanho_x(m)
        coord_y = obter_tamanho_y(m)
        return 0 < obter_pos_x(p) < coord_x and 0 < obter_pos_y(p) < coord_y

    valor_n = obter_valor_numerico(m, p)
    if eh_predador(obter_animal(m,p)):
        posicoes_possiveis = tuple(filter(lambda x: verifica_posicao(m, x) and not eh_posicao_obstaculo(m, x), obter_posicoes_adjacentes(p)))
        if any(filter(lambda x: eh_posicao_animal(m, x) and eh_presa(obter_animal(m, x)), posicoes_possiveis)):
            posicoes_possiveis = tuple(filter(lambda x: eh_posicao_animal(m, x) and eh_presa(obter_animal(m,x)), posicoes_possiveis))
            # Os predadores só comem presas !!!!
        else:
            posicoes_possiveis = tuple(filter(lambda x: not (eh_posicao_animal(m,x) and eh_predador(obter_animal(m, x))), posicoes_possiveis))

        n_pos_possiveis = len(posicoes_possiveis)
        if not posicoes_possiveis:
            return p
        elif len(posicoes_possiveis) == 1:
            return posicoes_possiveis[0]
        else: # Se + que 1 posicao disponivel
            movimento = valor_n % n_pos_possiveis
            return posicoes_possiveis[movimento]

    else:
        posicoes_possiveis = tuple(filter(lambda x: verifica_posicao(m, x) and eh_posicao_livre(m, x), obter_posicoes_adjacentes(p)))
        n_pos_possiveis = len(posicoes_possiveis)
        if not posicoes_possiveis:
            return p
        elif len(posicoes_possiveis) == 1:
            return posicoes_possiveis[0]
        else: # Se + que 1 posicao disponivel
            movimento = valor_n % n_pos_possiveis
            return posicoes_possiveis[movimento]


# Funcoes Adicionais
def geracao(m):
    """Modifica o prado fornecido como argumento de acordo com a evolucao correspondente a uma geracao completa.
    Seguindo a ordem de leitura do prado, cada animal (vivo), realiza o seu turno de ação, de acordo com as regras.
    No inicio do turno de cada animal, a sua idade e fome sao incrementadas.
    A seguir, o animal tenta realizar um movimento e eventualmente reproduzir-se alimentar, ou morrer.
    Apos cada animal ter realizado o seu turno e devolvido o prado com as devidas alteracoes.
    Esta funcao modifica destrutivamente o prado m.
    geracao: prado --->>> prado"""
    copia_prado = cria_copia_prado(m)
    ####### Depois de um animal ter tido o seu turno não se pode mexer mais.
    for posicao in obter_posicao_animais(m):
        if obter_animal(m, posicao) == obter_animal(copia_prado, posicao):
            animal = obter_animal(m, posicao)
            if eh_predador(animal):
                aumenta_fome(animal)
                aumenta_idade(animal)
                if eh_animal_fertil(animal) and obter_movimento(m, posicao) != posicao:
                    try:
                        if eh_presa(obter_animal(m, obter_movimento(m, posicao))):
                            movimento_pretendido = obter_movimento(m, posicao)
                            eliminar_animal(m, movimento_pretendido)
                            reset_fome(animal)
                            mover_animal(m, posicao, movimento_pretendido)
                            inserir_animal(m, reproduz_animal(animal), posicao)
                    except:
                        mover_animal(m, posicao, obter_movimento(m, posicao))
                        inserir_animal(m, reproduz_animal(animal), posicao)

                if obter_movimento(m, posicao) != posicao:
                    try:
                        if eh_presa(obter_animal(m, obter_movimento(m, posicao))):
                            movimento_pretendido = obter_movimento(m, posicao)
                            eliminar_animal(m, movimento_pretendido)
                            reset_fome(animal)
                            mover_animal(m, posicao, movimento_pretendido)
                    except:
                        movimento_pretendido = obter_movimento(m, posicao)
                        mover_animal(m, posicao, movimento_pretendido)

                if eh_animal_faminto(animal):
                    eliminar_animal(m, movimento_pretendido)
            else:
                aumenta_idade(animal)
                if eh_animal_fertil(animal) and obter_movimento(m, posicao) != posicao:
                        mover_animal(m, posicao, obter_movimento(m, posicao))
                        inserir_animal(m, reproduz_animal(animal), posicao)
                else:
                    if obter_movimento(m, posicao) == posicao: pass
                    else: mover_animal(m, posicao, obter_movimento(m, posicao))
    return m


def simula_ecossistema(f, g, v):
    """A funcao recebe uma string f, correspondente ao nome do ficheiro de configuracao da simulacao.
    O valor inteiro g corresponde ao numero de geracoes a simular.
    O booleano v ativa o modo verboso se True, ou o modo quiet se False.
    simula_ecossistema: string, int, boolean --->>> tuple"""
    ficheiro = open(f, "r")
    d = eval(ficheiro.readline())
    dimensao = cria_posicao(d[0], d[1])
    obs = eval(ficheiro.readline())
    obstaculos = ()
    for rochedo in obs:
        obstaculos += (cria_posicao(rochedo[0], rochedo[1]),)
    animais = ()
    posicoes_animais = ()
    while True:
        linha = ficheiro.readline()
        if not linha:
            break
        linha = eval(linha)
        animais += (cria_animal(linha[0], linha[1], linha[2]),)
        posicoes_animais += (cria_posicao(linha[3][0], linha[3][1]),)

    prado = cria_prado(dimensao, obstaculos, animais, posicoes_animais)
    string_final = "Predadores: {} vs Presas: {} (Gen. 0)\n".format(obter_numero_predadores(prado), obter_numero_presas(prado))
    string_final += prado_para_str(prado)

    if v:
        for i in range(1, g+1):
            copia_prado = cria_copia_prado(prado)
            geracao(prado)
            if obter_numero_presas(prado) != obter_numero_presas(copia_prado) or obter_numero_predadores(prado) != obter_numero_predadores(copia_prado):
                string_final += "\nPredadores: {} vs Presas: {} (Gen. {})\n".format(obter_numero_predadores(prado), obter_numero_presas(prado), i)
                string_final += prado_para_str(prado)
            else:
                pass

    else:
        for i in range(g):
            geracao(prado)
        string_final += "\nPredadores: {} vs Presas: {} (Gen. {})\n".format(obter_numero_predadores(prado), obter_numero_presas(prado), g)
        string_final += prado_para_str(prado)

    print(string_final)
    tuplo_final = (obter_numero_predadores(prado), obter_numero_presas(prado))
    return tuplo_final
