# Correção da Documentação
def corrigir_palavra(palavra):
    """A função recebe uma palavra (potencialmente modificada por um surto de letras) e devolve-a corrigida.
    string --->>> string"""
    def par_minuscula_maiuscula(letra, letra_seguinte):
        """Avalia duas letras consecutivas e avalie se são um par minuscula/maiuscula.
        string, string --->>> boolean"""
        return ord(letra) == (ord(letra_seguinte) - 32) or ord(letra) == (ord(letra_seguinte) + 32)

    ### Encapsular toda a gigagoga de eleiminar pares min/maius numa funcao e devolver bool. Enquanto houver alterações (true), ir chamando a função
    limpa = False
    while not limpa:
        index = 0
        modificada = False
        while index < (len(palavra) - 1):  # Garante que não excedemos o comprimento da string
            if par_minuscula_maiuscula(palavra[index], palavra[index + 1]):
                palavra = palavra[:index] + palavra[index + 2:]
                modificada = True
            index += 1
        if not modificada:
            limpa = True
    return palavra


def eh_anagrama(palavra1, palavra2):
    """A função recebe 2 palavras e devolve um Boolean consoante se são anagramas uma da outra.
    string, string --->>> boolean"""
    # As strings passam a ser listas ordenadas.
    # Se as listas forem exatamente iguais, estamos na presença de um anagrama.
    palavra1 = list(palavra1.lower())
    palavra1.sort()
    palavra2 = list(palavra2.lower())
    palavra2.sort()
    return palavra1 == palavra2


def corrigir_doc(documento):
    """A função recebe uma cadeia de caracteres e devolve-a filtrada.
    Cadeia filtrada: com palavras corrigidas e anagramas retirados
    O argumento necessita de ser constituido apenas por letras para ser considerado válido.
    string --->>> string"""
    if not type(documento) == str:
        raise ValueError("corrigir_doc: argumento invalido")
    documento = documento.split(" ")
    for index, palavra in enumerate(documento):
        # Validar que não existem espaços a mais, e que apenas existem caracteres nas palavras.
        if not palavra.isalpha():
            raise ValueError("corrigir_doc: argumento invalido")
        documento[index] = corrigir_palavra(palavra)

    lista_a_eliminar = []
    i = 0
    while i < len(documento):
        if i not in lista_a_eliminar:
            for j in range(i + 1, len(documento)):
                # Depois eliminar a primeira parte do if
                if documento[j] not in documento[:j] and eh_anagrama(documento[i], documento[j]) and documento[i].lower() != documento[j].lower():
                    lista_a_eliminar.append(j)
        i += 1
    lista_a_eliminar.sort(reverse=True)
    lista_a_eliminar = list(dict.fromkeys(lista_a_eliminar))
    for index in lista_a_eliminar:
        del documento[index]

    documento_corrigido = " ".join(documento)
    return documento_corrigido


# Descoberta do PIN
def obter_posicao(direcao, posicao_atual):
    """A função recebe uma direção "c, b, e, d" e a posição inicial, devolvendo a próxima posição.
    string, int --->>> int"""
    # Garante-se a validade dos movimentos de acordo com as posições
    if direcao == "C" and posicao_atual not in (1, 2, 3):
        return posicao_atual - 3
    elif direcao == "B" and posicao_atual not in (7, 8, 9):
        return posicao_atual + 3
    elif direcao == "E" and posicao_atual not in (1, 4, 7):
        return posicao_atual - 1
    elif direcao == "D" and posicao_atual not in (3, 6, 9):
        return posicao_atual + 1
    else:
        return posicao_atual


def obter_digito(movimentos, posicao_inicial):
    """A função recebe uma sequência e uma posição inicial, e devolve o número após finalizar os movimentos.
    string, int --->>> int"""
    for direcao in movimentos:
        if direcao not in ("C", "B", "E", "D"):
            raise ValueError("obter_pin: argumento invalido")
        posicao_inicial = obter_posicao(direcao, posicao_inicial)
    return posicao_inicial


def obter_pin(sequencias_movimentos):
    """A função recebe um conjunto de sequencias de movimentos e devolve um pin.
    tuple --->>> tuple"""
    # Rever o comentario (não há necessidade de ter o i)
    pin = ()
    ultima_posicao_registada = 5
    if not (type(sequencias_movimentos) == tuple and 4 <= len(sequencias_movimentos) <= 10):
        raise ValueError("obter_pin: argumento invalido")
    for sequencia in sequencias_movimentos:
        if not (type(sequencia) == str and sequencia.isalpha() and sequencia.isupper()):
            raise ValueError("obter_pin: argumento invalido")

        ultima_posicao_registada = obter_digito(sequencia, ultima_posicao_registada)
        pin += (ultima_posicao_registada,)
    return pin



# Verificação de dados
def eh_entrada(entradas):
    """A funcao recebe uma cifra, checksum, e um numero de segurança e verifica se estes são válidos.
    universal ---> booleano"""
    if not (type(entradas) == tuple and len(entradas) == 3):
        return False
    return eh_cifra(entradas[0]) and eh_checksum(entradas[1]) and eh_num_seguranca(entradas[2])

def eh_cifra(cifra):
    if type(cifra) != str or not cifra:
        return False
    for index, carater in enumerate(cifra):
        if carater == "-":
            if not 0 < index < (len(cifra)-1):
                return False
            elif not (cifra[index - 1].isalpha() and cifra[index + 1].isalpha()):
                return False
        elif not((carater.islower() and carater.isalpha()) or carater == "-"):
            return False
    return True

def eh_checksum(checksum):
    if type(checksum) != str or not(len(checksum) == 7) or checksum[0] != "[" or checksum[-1] != "]":
        return False
    for letra in checksum[1:6]:
        if not (letra.isalpha() and letra.islower()):
            return False
    return True

def eh_num_seguranca(num_seguranca):
    """A funcao receve um num_seguranca e verifica se é válido.
    eh_num_seguranca: tuple --->>> boolean"""
    if not (type(num_seguranca) == tuple and len(num_seguranca) >= 2):
        return False
    for numero in num_seguranca:
        if type(numero) != int or numero < 0:
            return False
    return True




def validar_cifra(cifra, checksum):
    """Conta-se o numero de ocurrencias de cada letra.
    De seguida, organiza-se quais são as maiores.
    validar_cifra: string, string --->>> boolean """
    if not (eh_cifra(cifra) and eh_checksum(checksum)):
        return False
    ocurrencias = {}
    for letra in cifra:
        ocurrencias[letra] = ocurrencias[letra] + 1 if letra in ocurrencias else 1
    if "-" in ocurrencias:
        del ocurrencias["-"]
    ocurrencias_ordenadas = sorted(ocurrencias.items())
    def bubble_sort(lista):
        houve_mudanca = True
        tamanho = len(lista) - 1
        while houve_mudanca:
            houve_mudanca = False
            for i in range(tamanho):
                if lista[i][1] < lista[i + 1][1]:
                    lista[i], lista[i + 1] = lista[i + 1], lista[i]
                    houve_mudanca = True
            tamanho -= 1
        return lista

    ocurrencias_ordenadas = bubble_sort(ocurrencias_ordenadas)
    checksum_a_confirmar = ""
    for i in range(5):
        checksum_a_confirmar += ocurrencias_ordenadas[i][0]
    return checksum_a_confirmar in checksum


def filtrar_bdb(lista_entradas):
    lista_nao_coerentes = []
    if type(lista_entradas) != list or not lista_entradas:
        raise ValueError("filtrar_bdb: argumento invalido")
    for entrada in lista_entradas:
        if not eh_entrada(entrada):
            raise ValueError("filtrar_bdb: argumento invalido")
        if not validar_cifra(entrada[0], entrada[1]):
            lista_nao_coerentes.append(entrada)
    return lista_nao_coerentes


# Desencriptacao de dados
def obter_num_seguranca(tuplo):
    """A funcao recebe uma sequencia de seguranca e encontra o numero de seguranca.
    Numero de seguranca: menor diferenca entre numeros
    tuple --->>> int"""
    diferenca, i = None, 0
    while i < len(tuplo) - 1:
        for j in range(i + 1, len(tuplo)):
            if diferenca is None:
                if tuplo[i] - tuplo[j] > 0: diferenca = tuplo[i] - tuplo[j]
                if tuplo[j] - tuplo[i] > 0: diferenca = tuplo[j] - tuplo[i]
            else:
                if 0 < tuplo[i] - tuplo[j] < diferenca: diferenca = tuplo[i] - tuplo[j]
                if 0 < tuplo[j] - tuplo[i] < diferenca: diferenca = tuplo[j] - tuplo[i]
        i += 1
    return diferenca


def decifrar_texto(cifra, num_seguranca):
    """A funcao recebe uma cifra e numero de seguranca, com o qual decifra a cifra.
    string, int --->>> string"""
    i = 0
    def volta_alfabeto(num):
        """A funcao altera o codigo decimal ASCII, de forma a corresponder a uma letra minuscula.
        int --->>> int"""
        while num > 122:
            num -= 26
        return num

    decifrada = []
    while i < len(cifra):
        if cifra[i] == "-":
            decifrada.append(" ")
        else:
            if i % 2 == 0:
                troca = ord(cifra[i]) + num_seguranca + 1
                if troca < 122:
                    decifrada += [chr(troca)]
                else:
                    decifrada += [chr(volta_alfabeto(troca))]
            else:
                troca = ord(cifra[i]) + num_seguranca - 1
                if troca < 122:
                    decifrada += [chr(troca)]
                else:
                    decifrada += [chr(volta_alfabeto(troca))]
        i += 1
    decifrada = "".join(decifrada)
    return decifrada


def decifrar_bdb(entradas):
    """A funcao recebe uma lista de entradas e devolve aquelas cujas cifras nao sao coerentes com a checksum
    decifrar_bdb: lista -->>> lista"""
    if type(entradas) != list or len(entradas) < 1:
        raise ValueError("decifrar_bdb: argumento invalido")
    entradas_decifradas = []
    for entrada in entradas:
        if not eh_entrada(entrada):
            raise ValueError("decifrar_bdb: argumento invalido")
        cifra, num_seguranca = entrada[0], entrada[2]
        entradas_decifradas.append(decifrar_texto(cifra, obter_num_seguranca(num_seguranca)))
    return entradas_decifradas





# Depuração de Senhas
def eh_utilizador(informacao):
    """Recebe qualqer tipo de argumento e verifica se é um dicionário contendo informação do utilizador válida,
    universal --->>> boolean"""
    def avalia_dicionario(dicionario):
        """Funcao auxiliar que verifica a validade do dicionario passado.
        universal --->>> boolean"""
        if type(dicionario) == dict and len(dicionario) == 3 and \
            "name" in dicionario and "pass" in dicionario and "rule" in dicionario:
            return True
        return False
    def avalia_name(dicionario):
        """Funcao auxiliar que verifica o par chave-valor "name".
        dict --->>> boolean"""
        if type(dicionario["name"]) != str or dicionario["name"] == "":
            return False
        for letra in dicionario["name"]:
            if not(letra.isalpha() or letra == "."):
                return False
        return True
    ### Avaliar os fors, porque a função pode nao devolver nada se tiver IndexOutOfRange
    def avalia_pass(dicionario):
        """Funcao auxiliar que verifica o par chave-valor "pass".
        dict --->>> boolen"""
        return type(dicionario["pass"]) == str and dicionario["pass"].isalpha()
    def avalia_regra(dicionario_rule):
        """Funcao auxiliar que verifica a regra individual.
        dict --->>> boolean"""
        if not (len(dicionario_rule) == 2 and type(dicionario_rule["vals"]) == tuple and
                len(dicionario_rule["vals"]) == 2 and dicionario_rule["vals"][0] > 0 and
                dicionario_rule["vals"][1] > 0 and
                type(dicionario_rule["char"]) == str and len(dicionario_rule["char"]) == 1 and
                dicionario_rule["vals"][0] < dicionario_rule["vals"][1]):
            return False
        return True

    return avalia_dicionario(informacao) and avalia_name(informacao) and avalia_pass(informacao) and avalia_regra(informacao["rule"])



def eh_senha_valida(senha, dicionario_regras):
    """A funcao recebe uma senha e um dicionario e verifica que a senha cumpre as regras defenidas no dicionario.
    string, dict --->>> boolean"""
    def regras_gerais(senha):
        """Verifica se a senha cumpre as regras gerias, que sao:
        -> Conter pelo menos tres vogais minusculas;
        -> Conter pelo menos um carater que apareca duas vezes consecutivas
        string --->>> boolean"""
        contador_vogais = 0
        for letra in senha:
            if letra in "aeiou":
                contador_vogais += 1
        if contador_vogais < 3:
            return False
        i = 0
        eh_consecutivo = False
        while i < len(senha) - 1:
            if senha[i] == senha[i + 1]:
                eh_consecutivo = True
                break
            i += 1
        return eh_consecutivo

    def regras_especificas(senha, dicionario_regras):
        """Verifica se a senha cumpre a regra especifica, que e:
        -> Existe um determinado numero de ocurrencias (guardada em "vals") de uma certa letra (guardade em "char"):
        string, dict --->>> boolean"""

        min_ocurrencias = dicionario_regras["vals"][0]
        max_ocurrencias = dicionario_regras["vals"][1]
        count_ocurrencias = 0
        for letra in senha:
            if letra == dicionario_regras["char"]:
                count_ocurrencias += 1
        if min_ocurrencias <= count_ocurrencias <= max_ocurrencias:
            return True
        return False

    return regras_gerais(senha) and regras_especificas(senha, dicionario_regras)


def filtrar_senhas(lista_entradas):
    """A funcao recebe uma lista de entradas da BDB.
    Devolve a lista ordenada alfabeticamente dos utilizadores com senhas erradas.
    list ---> list"""
    if not lista_entradas or type(lista_entradas) != list:
        raise ValueError("filtrar_senhas: argumento invalido")
    lista_senhas_erradas = []
    for dicionario in lista_entradas:
        if not eh_utilizador(dicionario):
            raise ValueError("filtrar_senhas: argumento invalido")
        if not(eh_senha_valida(dicionario["pass"], dicionario["rule"])):
            lista_senhas_erradas.append(dicionario["name"])
    lista_senhas_erradas.sort()
    return lista_senhas_erradas
