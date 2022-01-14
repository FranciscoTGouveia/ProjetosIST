%:- ['codigo_comum.pl', 'puzzles_publicos.pl'].
% Predicado: extrai_ilhas_linha/3
/* Objetivo: Transforma uma linha correspondente ao puzzle, numa lista
   com o numero de pontes de uma linha e a sua posicao no puzzle.
*/
extrai_ilhas_linha(N_L, Linha, Ilhas) :- extrai_ilhas_linha(N_L, Linha, [], Ilhas, 1). % Engorda do predicado
extrai_ilhas_linha(_N_L, [], Ilhas, Ilhas, _). % Condicao de paragem

extrai_ilhas_linha(N_L, [Cabeca | Resto], Acc, Ilhas, Index) :-
    Cabeca > 0, !,
    append(Acc, [ilha(Cabeca, (N_L, Index))], NovoAcc),
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, NovoAcc, Ilhas, NovoIndex).

extrai_ilhas_linha(N_L, [_Cabeca | Resto], Acc, Ilhas, Index) :-
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, Acc, Ilhas, NovoIndex).




% Predicado: ilhas/2
/* Objetivo: Devolve uma lista com todos os predicados ilha/2,
   ordenados por posicao no puzzle.
*/
ilhas(Puz, Ilhas) :- ilhas(Puz, [], Ilhas, 1). % Engorda do predicado
ilhas([], Ilhas, Ilhas, _). % Condicao de paragem

ilhas([Cabeca | Resto], Acc, Ilhas, Index) :-
    extrai_ilhas_linha(Index, Cabeca, Linha_Limpa),
    append(Acc, Linha_Limpa, NovoAcc),
    NovoIndex is Index + 1,
    ilhas(Resto, NovoAcc, Ilhas, NovoIndex).




% Predicado: vizinhas/3
/* Objetivo: Devolve a lista de ilhas vizinhas a Ilha.
   Criterio de vizinhanca:
       -> As ilhas encontram-se na mesma linha ou coluna;
       -> Entre elas nao existem outras ilhas;
       -> Entre elas nao existe nenhuma ponte que una duas outras ilhas;
*/
lista_cima(Ilhas, Ilha, ListaFinal) :- lista_cima(Ilhas, Ilha, [], ListaFinal).
lista_cima([], _Ilha, ListaFinal, ListaFinal).
lista_cima([ilha(P, (L,C)) | Resto], ilha(Pontes, (Linha, Coluna)), _Acc, ListaFinal) :-
    C == Coluna,
    L < Linha, !,
    NovoAcc = [ilha(P, (L,C))],
    lista_cima(Resto, ilha(Pontes,(Linha,Coluna)), NovoAcc, ListaFinal).
lista_cima([_Cabeca | Resto], ilha(Pontes, (Linha,Coluna)), Acc, ListaFinal) :-
    lista_cima(Resto, ilha(Pontes, (Linha, Coluna)), Acc, ListaFinal).

lista_esquerda(Ilhas, Ilha, ListaFinal) :- lista_esquerda(Ilhas, Ilha, [], ListaFinal).
lista_esquerda([], _Ilha, ListaFinal, ListaFinal).
lista_esquerda([ilha(P, (L,C)) | Resto], ilha(Pontes, (Linha, Coluna)), _Acc, ListaFinal) :-
    L == Linha,
    C < Coluna, !,
    NovoAcc = [ilha(P, (L,C))],
    lista_esquerda(Resto, ilha(Pontes,(Linha,Coluna)), NovoAcc, ListaFinal).
lista_esquerda([_Cabeca | Resto], ilha(Pontes, (Linha,Coluna)), Acc, ListaFinal) :-
    lista_esquerda(Resto, ilha(Pontes, (Linha, Coluna)), Acc, ListaFinal).

lista_baixo(Ilhas, Ilha, ListaFinal) :- lista_baixo(Ilhas, Ilha, [], ListaFinal).
lista_baixo([], _Ilha, ListaFinal, ListaFinal).
lista_baixo([ilha(P, (L,C)) | _Resto], ilha(Pontes, (Linha, Coluna)), _Acc, ListaFinal) :-
    C == Coluna,
    L > Linha, !,
    NovoAcc = [ilha(P, (L,C))],
    lista_baixo([], ilha(Pontes,(Linha,Coluna)), NovoAcc, ListaFinal).
lista_baixo([_Cabeca | Resto], ilha(Pontes, (Linha,Coluna)), Acc, ListaFinal) :-
    lista_baixo(Resto, ilha(Pontes, (Linha, Coluna)), Acc, ListaFinal).

lista_direita(Ilhas, Ilha, ListaFinal) :- lista_direita(Ilhas, Ilha, [], ListaFinal).
lista_direita([], _Ilha, ListaFinal, ListaFinal).
lista_direita([ilha(P, (L,C)) | _Resto], ilha(Pontes, (Linha, Coluna)), _Acc, ListaFinal) :-
    L == Linha,
    C > Coluna, !,
    NovoAcc = [ilha(P, (L,C))],
    lista_direita([], ilha(Pontes,(Linha,Coluna)), NovoAcc, ListaFinal).
lista_direita([_Cabeca | Resto], ilha(Pontes, (Linha,Coluna)), Acc, ListaFinal) :-
    lista_direita(Resto, ilha(Pontes, (Linha, Coluna)), Acc, ListaFinal).


vizinhas(Ilhas, Ilha, Vizinhas) :- vizinhas(Ilhas, Ilha, [], Vizinhas).
vizinhas([], _Ilha, Vizinhas, Vizinhas) :- !.
vizinhas(Ilhas, Ilha, Acc, Vizinhas) :-
    lista_cima(Ilhas, Ilha, LimiteCima),
    lista_esquerda(Ilhas, Ilha, LimiteEsquerda),
    lista_baixo(Ilhas, Ilha, LimiteBaixo),
    lista_direita(Ilhas, Ilha, LimiteDireita),
    append(Acc, LimiteCima, Acc1),
    append(Acc1, LimiteEsquerda, Acc2),
    append(Acc2, LimiteDireita, Acc3),
    append(Acc3, LimiteBaixo, NovoAcc),
    vizinhas([], Ilha, NovoAcc, Vizinhas).




% Predicado: estado/2
/* Objetivo: Representar o estado de um puzzle durante a sua resolucao,
   num dado momento na seguinte disposicao:
   -> O primeiro elemento e uma ilha;
   -> O segundo elemento e a lista das vizinhas dessa ilha;
   -> A terceira e a lista das pontes da ilha, (vazia no estado inicial);
*/
estado(Ilhas, Estado) :- estado(Ilhas, Ilhas, [], Estado).
estado([], _Ilhas, Estado, Estado).
estado([Ilha | Resto], Ilhas, Acc, Estado) :- 
    vizinhas(Ilhas, Ilha, Vizinhas),
    StatusIlha = [Ilha, Vizinhas, []],
    append(Acc, [StatusIlha], NovoAcc),
    estado(Resto, Ilhas, NovoAcc, Estado).




% Predicado: posicoes_entre/3
/* Objetivo: Devolve a lista ordenada de posicoes entre Pos1 e Pos2,
   salvaguardando, que, se Pos1 e Pos2 nao pertencerem a mesma linha 
   ou coluna, o resultado sera false.
*/
posicoes_entre((L1, C1), (L2, C2), Posicoes) :-
    (L1 == L2, C1 \== C2,
    ((C2 > C1) -> C1Novo is C1 + 1, C2Novo is C2 - 1; C1Novo is C1 - 1, C2Novo is C2 + 1),
    ((C2Novo > C1Novo) -> findall((L1, CC), between(C1Novo, C2Novo, CC), Posicoes); findall((L1, CC), between(C2Novo, C1Novo, CC), Posicoes));
    C1 == C2, L1 \== L2,
    ((L2 > L1) -> L1Novo is L1 + 1, L2Novo is L2 - 1; L1Novo is L1 - 1, L2Novo is L2 + 1),
    ((L2Novo > L1Novo) -> findall((LL, C1), between(L1Novo, L2Novo, LL), Posicoes); findall((LL, C1), between(L2Novo, L1Novo, LL), Posicoes))).
     
