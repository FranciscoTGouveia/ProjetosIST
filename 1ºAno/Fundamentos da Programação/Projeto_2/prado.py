### Nome: Francisco Catanho Barreto Tomé Gouveia
### IST_ID: ist1102571
### 1ªAno LEIC-T

# TAD posicao
# Repsentacao[posicao]: (x, y)
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
    # Verificar se é necessário a validação de argumentos
    # Se sim, podemos utilizar o metodo obter_pos_x/y, invés de p[0] e p[1] ?
    if type(p) != tuple or len(p) != 2 or p[0] < 0 or p[1] < 0:
        raise ValueError("cria_copia_posicao: argumentos invalidos")
    return p

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
    """Devolve um tuplo com as posicoes adjacentes a posicao p.
    As posicoes adjacentes seguem pelo sentido horario e começam pela posicao acima (12h)
    obter_posicoes_adjacentes: posicao --->>> tuplo"""
    tuplo_posicoes = ()
    if eh_posicao((obter_pos_x(p), obter_pos_y(p) - 1)):
        posicao_cima = cria_posicao(obter_pos_x(p), obter_pos_y(p) - 1)
        tuplo_posicoes += (posicao_cima,)

    if eh_posicao((obter_pos_x(p) + 1, obter_pos_y(p))):
        posicao_direita = cria_posicao(obter_pos_x(p) + 1, obter_pos_y(p))
        tuplo_posicoes += (posicao_direita,)

    if eh_posicao((obter_pos_x(p), obter_pos_y(p) + 1)):
        posicao_baixo = cria_posicao(obter_pos_x(p), obter_pos_y(p) + 1)
        tuplo_posicoes += (posicao_baixo,)

    if eh_posicao((obter_pos_x(p) - 1, obter_pos_y(p))):
        posicao_esquerda = cria_posicao(obter_pos_x(p) - 1, obter_pos_y(p))
        tuplo_posicoes += (posicao_esquerda,)

    return tuplo_posicoes

def ordenar_posicoes(t):
    """Devolve um tuplo contendo as mesmas posicoes mas de acordo com a ordem de leitura do prado.
    ordenar_posicoes: tuple --->>> tuple"""
    t = list(t)
    t.sort(key=lambda x:x[0])
    def bubble_sort(lista):
        houve_mudanca = True
        tamanho = len(lista) - 1
        while houve_mudanca:
            houve_mudanca = False
            for i in range(tamanho):
                if lista[i][1] > lista[i + 1][1]:
                    lista[i], lista[i + 1] = lista[i + 1], lista[i]
                    houve_mudanca = True
            tamanho -= 1
        return lista
    bubble_sort(t)
    return tuple(t)

