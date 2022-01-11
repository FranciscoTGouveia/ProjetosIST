% Predicado: extrai_ilhas_linha/3
/* Objetivo: Transforma uma linha correspondente ao puzzle, numa lista
   com o numero de pontes de uma linha e a sua posicao no puzzle.
*/
extrai_ilhas_linha(N_L, Linha, Ilhas) :- extrai_ilhas_linha(N_L, Linha, [], Ilhas, 1).
extrai_ilhas_linha(N_L, [], Ilhas, Ilhas, _).

extrai_ilhas_linha(N_L, [Cabeca | Resto], Acc, Ilhas, Index) :-
    Cabeca > 0, !,
    append(Acc, [ilha(Cabeca, (N_L, Index))], NovoAcc),
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, NovoAcc, Ilhas, NovoIndex).

extrai_ilhas_linha(N_L, [_Cabeca | Resto], Acc, Ilhas, Index) :-
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, Acc, Ilhas, NovoIndex).

