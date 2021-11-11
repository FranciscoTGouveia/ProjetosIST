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
    return eh_posicao(p1) and eh_posicao(p2) and \
        obter_pos_x(p1) == obter_pos_x(p2) and obter_pos_y(p1) == obter_pos_y(p2)


# Transformador
def posicao_para_str(p):
    """Devolve a cadeia de caracteres que repesenta a posicao (argumento passado).
    posicao_para_str: posicao --->>> string"""
    return "(" + str(obter_pos_x(p)) + ", " + str(obter_pos_y(p)) + ")"


# Funcoes de Alto Nivel
def obter_posicoes_adjacentes(p):
    ################ QUESTAO #####################
    # Temos de impedir que sejam mostradas posicoes fora do prado, ou que correspondam a montanhas ?

    """Devolve um tuplo com as posicoes adjacentes a posicao p.
    As posicoes adjacentes seguem pelo sentido horario e começam pela posicao acima (12h)
    obter_posicoes_adjacentes: posicao --->>> tuplo"""
    tuplo_posicoes = ()
    x, y = obter_pos_x(p), obter_pos_y(p)
    if eh_posicao((x, y - 1)): tuplo_posicoes += (cria_posicao(x, y - 1),)
    if eh_posicao((x + 1, y)): tuplo_posicoes += (cria_posicao(x + 1, y),)
    if eh_posicao((x, y + 1)): tuplo_posicoes += (cria_posicao(x, y + 1),)
    if eh_posicao((x - 1, y)): tuplo_posicoes += (cria_posicao(x - 1, y),)

    return tuplo_posicoes


def ordenar_posicoes(t):
    """Devolve um tuplo contendo as mesmas posicoes mas de acordo com a ordem de leitura do prado.
    ordenar_posicoes: tuple --->>> tuple"""
    t = list(t)
    t.sort(key=lambda x: x[::-1])
    return tuple(t)


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

    return a.copy()


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
    """Verifica o argumento passado e se for um TAD animal, e devolve um valor logico de acordo.
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
    return a1 == a2


# Transformadores
def animal_para_char(a):
    """Devolve uma string com a letra inicial da espécie do animal passado como argumento.
    Se o animal for predador, a letra e maiuscula, se for presa, a letra e minuscula.
    animal_para_char: animal --->>> char"""
    return obter_especie(a)[0].upper() if eh_predador(a) else obter_especie(a)[0].lower()


def animal_para_str(a):
    """Devolve uma string com a especie, a idade/freq_reproducao e fome/freq_alimentacao.
    animal_para_str: animal --->>> str"""
    return "{} [{}/{};{}/{}]".format(obter_especie(a), obter_idade(a), obter_freq_reproducao(a), obter_fome(a),
                                     obter_freq_alimentacao(a))


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
# Representacao[prado]:
# Construtores
def cria_prado(d, r, a, p):
    """Recebe uma posicao d (montanho do canto inferior direito), um tuplo r com posicoes de rochedos, um tuplo a de animais, e um tuplo p com as posicoes ocupadas por esses animais.
    A funcao devole o prado que representa internamente o mapa e os animais presentes.
    cria_prado: posicao, tuplo, tuplo --->>> prado"""
    def verifica_rochedos(r):
        for rochedo in r:
            if not eh_posicao(rochedo):
                return False
        return True

    def verifica_animais(a):
        for animal in a:
            if not eh_animal(animal):
                return False
        return True

    def verifica_posicoes_animais(p):
        for posicao in p:
            if not eh_posicao(posicao):
                return False
        return True

    if not(eh_posicao(d) and type(r) == tuple and len(r) >= 0 and verifica_rochedos(r) and
            type(a) == tuple and len(a) > 0 and verifica_animais(a) and
            type(p) == tuple and len(p) == len(a) and verifica_posicoes_animais(p)):
        raise ValueError("cria_prado: argumentos invalidos")

    return {"rochedo_extremidade": d,
            "rochedos_prado": r,
            "animais_prado": a,
            "posicoes_animais": p
            }


def cria_copia_prado(m):
    ####################### QUESTAO ######################
    ### É necessário verificar a validade do argumento ?
    ### É possivel utilizar o .copy (visto que estamos a utilizar tuplos (n motaveis)) ?
    """Recebe um prado e devolve uma nova copia do prado.
    cria_copia_prado: prado --->>> prado"""
    return m.copy()

# Seletores
def obter_tamanho_x(m):
    """Devolve o valor correspondente à dimensao x do prado (comprimento).
    obter_tamanho: prado --->>> int"""
    return m["rochedo_extremidade"][0] + 1

def obter_tamanho_y(m):
    """Devolve o valor correspondente a dimensao y do prado (largura).
    obter_tamanho_y: prado --->>> int"""
    return m["rochedo_extremidade"][1] + 1
