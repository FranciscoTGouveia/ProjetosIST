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
vizinhas([], _Ilha, Vizinhas, Vizinhas).
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


