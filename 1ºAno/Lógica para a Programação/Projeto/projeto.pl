/*
  Nome: Francisco Catanho Barreto Tome Gouveia
  IST ID: ist1102571
  1Ano LEIC-T
*/

/*Introducao:
    O proposito deste projeto e escrever a primeira parte
    de um solucionador de puzzles Hashi.
    Um puzzle e constituido por uma grelha n*m (n linhas, m colunas),
    sendo portanto representada por uma matriz (lista de listas).
    O puzzle so fica terminado quando todas as ilhas estiverem
    ligadas por pontes, e a passagem for permitida entre quaisquer duas ilhas.
    Nao pode haver mais que duas pontes entre duas ilhas.
    As pontes apenas poderam ser horizontais ou verticais.
    As pontes nao podem cruzar outras ilhas ou pontes.
*/

:- ['codigo_comum.pl'].

%==============================================%
%          2.1 - extrai_ilhas_linha/3          %
%==============================================%

/*Objetivo:
    Sendo N_L o numero da linha, e Linha uma lista correspondente
    a uma linha do puzzle, Ilhas sera a lista ordenada, da esquerda
    para a direita, cujos elementos sao ilhas da Linha.
*/
extrai_ilhas_linha(N_L, Linha, Ilhas) :-
    extrai_ilhas_linha(N_L, Linha, [], Ilhas, 1). % Adicao de um contador
extrai_ilhas_linha(_N_L, [], Ilhas, Ilhas, _). % Condicao de paragem
extrai_ilhas_linha(N_L, [Cabeca | Resto], Acc, Ilhas, Index) :-
    Cabeca > 0, !,
    append(Acc, [ilha(Cabeca, (N_L, Index))], NovoAcc),
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, NovoAcc, Ilhas, NovoIndex);
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, Acc, Ilhas, NovoIndex).




%=================================%
%          2.2 - ilhas/2          %
%=================================%

/*Objetivo:
    Sendo Puz um puzzle, Ilhas sera a lista ordenada, da esquerda
    para a direita e de cima para baixo, de ilhas.
*/
ilhas(Puz, Ilhas) :- 
    ilhas(Puz, [], Ilhas, 1). % Adicao de um acumulador e contador
ilhas([], Ilhas, Ilhas, _). % Condicao de paragem

ilhas([Cabeca | Resto], Acc, Ilhas, Index) :-
    extrai_ilhas_linha(Index, Cabeca, Linha_Limpa),
    append(Acc, Linha_Limpa, NovoAcc),
    NovoIndex is Index + 1,
    ilhas(Resto, NovoAcc, Ilhas, NovoIndex).




%====================================%
%          2.3 - vizinhas/3          %
%====================================%

/*Objetivo:
    Sendo Ilhas a lista de ilhas do puzzle e Ilha uma determinada
    ilha desse puzzle, Vizinhas sera a lista ordenada das ilhas vizinhas.
  Criterio de vizinhanca:
    -> As ilhas encontram-se na mesma linha ou coluna;
    -> Entre elas nao existem outras ilhas;
    -> Entre elas nao existe nenhuma ponte que una duas outras ilhas;
  Raciocinio:
    Criar 4 listas, contendo as ilhas que se encontram acima,
    a esquerda, a baixo e a direita da ilha em questao. Depois,
    escolher a ultima ilha das listas cima e esquerda, e a primeira
    ilha das listas baixo e direita.
*/
lista_cima(Ilhas, ilha(_Pontes, (Linha, Coluna)), ListaFinal) :-
    findall(ilha(P, (L,C)), (member(ilha(P,(L,C)), Ilhas), C == Coluna, L < Linha), Aux),
    length(Aux, LenLista),
    (LenLista == 0, ListaFinal = []; 
    last(Aux, UltimaIlha), ListaFinal = [UltimaIlha]).

lista_esquerda(Ilhas, ilha(_Pontes, (Linha, Coluna)), ListaFinal) :-
    findall(ilha(P, (L,C)), (member(ilha(P,(L,C)), Ilhas), L = Linha, C < Coluna), Aux),
    length(Aux, LenLista),
    (LenLista == 0, ListaFinal = []; 
    last(Aux, UltimaIlha), ListaFinal = [UltimaIlha]).

lista_baixo(Ilhas, ilha(_Pontes, (Linha, Coluna)), ListaFinal) :-
    findall(ilha(P, (L,C)), (member(ilha(P,(L,C)), Ilhas), C == Coluna, L > Linha), Aux),
    length(Aux, LenLista),
    (LenLista == 0, ListaFinal = []; 
    nth1(1, Aux, UltimaIlha), ListaFinal = [UltimaIlha]).

lista_direita(Ilhas, ilha(_Pontes, (Linha, Coluna)), ListaFinal) :-
    findall(ilha(P, (L,C)), (member(ilha(P,(L,C)), Ilhas), L == Linha, C > Coluna), Aux),
    length(Aux, LenLista),
    (LenLista == 0, ListaFinal = []; 
    nth1(1, Aux, UltimaIlha), ListaFinal = [UltimaIlha]).

vizinhas(Ilhas, Ilha, Vizinhas) :-
    lista_cima(Ilhas, Ilha, LimiteCima),
    lista_esquerda(Ilhas, Ilha, LimiteEsquerda),
    lista_baixo(Ilhas, Ilha, LimiteBaixo),
    lista_direita(Ilhas, Ilha, LimiteDireita),
    append([LimiteCima, LimiteEsquerda, LimiteDireita, LimiteBaixo], Vizinhas).




%==================================%
%          2.4 - estado/2          %
%==================================%

/*Objetivo:
    Sendo Ilhas a lista de ilhas do puzzle, Estado sera a lista com todas
    as ilhas e respetivas informacoes.
  Organizao do Estado:  
    -> O primeiro elemento eh uma ilha;
    -> O segundo elemento eh a lista das vizinhas dessa ilha;
    -> O ultimo elemento eh a lista das pontes da ilha (vazia no estado inicial).
*/
estado(Ilhas, Estado) :-
    estado(Ilhas, Ilhas, Estado).
estado(Ilhas, IlhasFixas, Estado) :-
    findall([Ilha, Vizinhas, []], (member(Ilha, Ilhas), vizinhas(IlhasFixas, Ilha, Vizinhas)), Estado).




%==========================================%
%          2.5 - posicoes_entre/3          %
%==========================================%

/*Objetivo:
    Sendo Pos1 e Pos2 posicoes no puzzle, representadas por (Linha, Coluna),
    Posicoes sera a lista ordenada de posicoes entre Pos1 e Pos2.
    Caso Pos1 e Pos2 nao se encontrem na mesma linha ou coluna,
    entao nao havera unificacao possivel e o resultado sera false.
*/
posicoes_entre((L1,C1), (L2, C2), Posicoes) :-
    L1 == L2, C2 > C1, C1Novo is C1+1, C2Novo is C2-1, !,
    findall((L1, CC), between(C1Novo, C2Novo, CC), Posicoes).

posicoes_entre((L1,C1), (L2,C2), Posicoes) :-
    L1 == L2, C2 < C1, C1Novo is C1-1, C2Novo is C2+1, !,
    findall((L1, CC), between(C2Novo, C1Novo, CC), Posicoes).

posicoes_entre((L1,C1), (L2, C2), Posicoes) :-
    C1 == C2, L2 > L1, L1Novo is L1+1, L2Novo is L2-1, !,
    findall((LL, C1), between(L1Novo, L2Novo, LL), Posicoes).

posicoes_entre((L1,C1), (L2,C2), Posicoes) :-
    C1 == C2, L2 < L1, L1Novo is L1-1, L2Novo is L2+1, !,
    findall((LL, C1), between(L2Novo, L1Novo, LL), Posicoes).




%======================================%
%          2.6 - cria_ponte/3          %
%======================================%

/*Objetivo:
    Sendo Pos1 e Pos2 duas posicoes, Ponte sera uma ponte que une
    essas duas posicoes, tendo o formato, ponte(Pos1, Pos2).
*/
cria_ponte((L1, C1), (L2, C2), Ponte) :-
    L1 < L2, Ponte = ponte((L1,C1), (L2,C2));
    L1 > L2, Ponte = ponte((L2,C2), (L1,C1));
    C1 < C2, Ponte = ponte((L1,C1), (L2,C2));
    C1 > C2, Ponte = ponte((L2,C2), (L1,C1)).




%=========================================%
%          2.7 - caminho_livre/5          %
%=========================================%

/*Objetivo:
    Sendo Pos1 e Pos2 posicoes no puzzle, Posicoes a lista de
    posicoes entre Pos1 e Pos2, I uma ilha do puzzle e Vz uma vizinha
    de I, o predicado sera passivel de ser unificado caso a adicao
    de uma ponte entre Pos1 e Pos2 nao invalide o facto de I e Vz
    serem vizinhas.
    Caso a colocacao de uma ponte faca com que I e Vz deixem de ser
    vizinhas, o predicado nao ira conseguir unificar, devolvendo false.
  Raciocinio:
    Criar a lista de posicoes entre a ilha I e a sua vizinha Vz,
    fazendo depois a sua intersecao com Posicoes, lista de posicoes
    que a nova ponte ira ocupar. Caso a lista resultante da intersecao
    seja vazia, entao o caminho estara livre, se ouver um elemento na 
    intersecao, significara que a colocacao dessa ponte ira bloquear o
    caminho entre a ilha I e a sua vizinha Vz.
*/
caminho_livre(_Pos1, _Pos2, Posicoes, ilha(_P1,(L_ilha, C_ilha)), ilha(_P2, (L_vz,C_vz))) :-
    posicoes_entre((L_ilha, C_ilha), (L_vz, C_vz), EntreIlhaVz),
    intersection(EntreIlhaVz, Posicoes, Intersecoes),
    Intersecoes == [].
caminho_livre(Pos1, Pos2, Posicoes, ilha(_P1,(L_ilha, C_ilha)), ilha(_P2, (L_vz,C_vz))) :-
    posicoes_entre((L_ilha, C_ilha), (L_vz, C_vz), EntreIlhaVz),
    EntreIlhaVz == Posicoes,
    ((Pos1 == (L_ilha, C_ilha), Pos2 == (L_vz, C_vz));
    (Pos1 == (L_vz, C_vz), Pos2 == (L_ilha, C_ilha))).




%======================================================%
%          2.8 - actualiza_vizinhas_entrada/5          %
%======================================================%

/*Objetivo:
    Sendo Pos1 e Pos2 as posicoes entre as quais sera inserida uma 
    ponte, Posicoes a lista ordenada de posicoes entre Pos1 e Pos2
    e Entrada uma entrada do puzzle, Nova_Entrada sera a entrada
    mas com o paremetro Vizinhas atualizado tendo em conta a adicao
    da nova ponte, e as possiveis ilhas que deixaram de ser vizinhas.
*/
actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Vizinhas, Pontes], Nova_Entrada) :-
    findall(Viz, (member(Viz, Vizinhas), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz)), VizinhasFinal),
    Nova_Entrada = [Ilha, VizinhasFinal, Pontes].




%==========================================================%
%          2.9 - actualiza_vizinhas_apos_pontes/4          %
%==========================================================%

/*Objetivo:
    Sendo Estado um estado e Pos1 e Pos2 posicoes entre as quais
    foi colocada uma ponte, Novo_estado sera o estado que se 
    obtem apos a atualizacao das ilhas vizinhas de cada entrada.
*/
actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) :-
    posicoes_entre(Pos1, Pos2, PosicoesEntrePos1Pos2),
    maplist(actualiza_vizinhas_entrada(Pos1, Pos2, PosicoesEntrePos1Pos2), Estado, Novo_estado);
    Novo_estado = Estado.




%=============================================%
%          2.10 - ilhas_terminadas/2          %
%=============================================%

/*Objetivo:
    Sendo Estado um Estado, Ilhas_term sera a lista de ilhas
    terminadas, ou seja, que ja tem todas as pontes associadas.
    A ilhas ja terminadas teram o comprimento da lista Pontes
    igual a N_pontes.
*/
ilhas_terminadas(Estado, Ilhas_term) :-
    findall(ilha(N_pontes, Pos),
    (member([ilha(N_pontes, Pos), _Vizinhas, Pontes], Estado), length(Pontes, LenPontes), LenPontes == N_pontes), 
    Ilhas_term).




%==========================================================%
%          2.11 - tira_ilhas_terminadas_entrada/3          %
%==========================================================%

/*Objetivo:
    Sendo Ilhas_term a lista de ilhas terminadas e Entrada uma
    entrada do puzzle, Nova_entrada sera a entrada atualizada 
    apos a remocao das ilhas terminadas da lista de vizinhas
    de cada ilha na entrada.
*/
tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizinhas, Pontes], Nova_Entrada) :-
    findall(Viz, (member(Viz, Vizinhas), \+member(Viz, Ilhas_term)), NovasVizinhas),
    Nova_Entrada = [Ilha, NovasVizinhas, Pontes].




%==================================================%
%          2.12 - tira_ilhas_terminadas/3          %
%==================================================%

/*Objetivo:
    Sendo Estado um estado e Ilhas_term a lista de ilhas
    terminadas, Novo_estado sera o estado resultante de
    retirar as ilhas terminadas da lista de vizinhas de
    cada ilha do estado, fazendo recurso do predicado 
    definido imediatamente antes.
*/
tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
    maplist(tira_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).




%===========================================================%
%          2.13 - marca_ilhas_terminadas_entrada/3          %
%===========================================================%

/*Objetivo:
    Sendo Ilhas_term a lista de ilhas terminadas e Entrada uma
    entrada do puzzle, Nova_entrada sera a entrada obtida apos
    substituir o numero de pontes por um 'X' caso a ilha da 
    Entrada pertencer a Ilhas_Term.
*/
marca_ilhas_terminadas_entrada(Ilhas_term, [ilha(P,(L,C)), Vizinhas, Pontes], Nova_Entrada) :-
    member(ilha(P,(L,C)), Ilhas_term),
    Nova_Entrada = [ilha('X', (L,C)), Vizinhas, Pontes];
    Nova_Entrada = [ilha(P, (L,C)), Vizinhas, Pontes].




%===================================================%
%          2.14 - marca_ilhas_terminadas/3          %
%===================================================%

/*Objetivo:
    Sendo Estado um estado e Ilhas_term a lista de ilhas
    terminadas de um puzzle, Novo_estado sera o estado
    resultante de substituir por 'X' o numero de pontes
    das ilhas ja terminadas, fazendo recurso do predicado
    definido imediatamente antes.
*/
marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
      maplist(marca_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).




%===================================================%
%          2.15 - trata_ilhas_terminadas/2          %
%===================================================%

/*Objetivo:
    Sendo Estado um estado do puzzle, Novo_estado sera
    o estado resultante de retirar as ilhas terminadas
    das vizinhas e substituir por um 'X' o numero de pontes
    de uma ilha caso esta ja esteja terminada, fazendo
    recurso dos predicados definidos anteriormente.
*/
trata_ilhas_terminadas(Estado, Novo_Estado) :-
    ilhas_terminadas(Estado, IlhasTerminadas),
    tira_ilhas_terminadas(Estado, IlhasTerminadas, EstadoAlpha),
    marca_ilhas_terminadas(EstadoAlpha, IlhasTerminadas, Novo_Estado).




%=========================================%
%          2.16 - junta_pontes/5          %
%=========================================%

/*Objetivo:
    Sendo Estado um estado do puzzle, Ilha1 e Ilha2 duas
    ilhas do puzzle e num_pontes um determinado numero de
    pontes (max 2), Novo_estado sera o estado resultante
    de adicionar as pontes entre a Ilha1 e Ilha2.
  Raciocinio:
    Antes de efetuar as alteracoes necessarias devido ah
    adicao da ponte, criou-se um predicado auxiliar com o
    intuito de adicionar as pontes as ilhas respetivas. 
*/
adiciona_ponte(Ilha1, Ilha2, Num_pontes, Ponte, [ilha(P,(L,C)), Viz, Pont], Nova_entrada) :-
    ((ilha(P,(L,C)) == Ilha1; ilha(P,(L,C)) == Ilha2),
    ((Num_pontes == 1, !,
    append(Pont, [Ponte], NovaPont));
    (Num_pontes == 2, !,
    append(Pont, [Ponte,Ponte], NovaPont))),
    Nova_entrada = [ilha(P,(L,C)), Viz, NovaPont]);
    Nova_entrada = [ilha(P,(L,C)), Viz, Pont].

junta_pontes(Estado, Num_pontes, ilha(P1,(L1,C1)), ilha(P2,(L2,C2)), Novo_estado) :-
    cria_ponte((L1,C1), (L2,C2), Ponte),
    maplist(adiciona_ponte(ilha(P1,(L1,C1)), ilha(P2,(L2,C2)), Num_pontes, Ponte), Estado, EstadoAlpha),
    actualiza_vizinhas_apos_pontes(EstadoAlpha,(L1,C1),(L2,C2), EstadoPosPontes),
    trata_ilhas_terminadas(EstadoPosPontes, Novo_estado).
