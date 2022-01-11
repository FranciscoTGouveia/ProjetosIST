% Predicado extrai_ilhas_linha
extrai_ilhas_linha(N_L, Linha, Ilhas) :- extrai_ilhas_linha(N_L, Linha, [], Ilhas, 1).
extrai_ilhas_linha(N_L, [], Ilhas, Ilhas).

extrai_ilhas_linha(N_L, [Cabeca | Resto], Acc, Ilhas, Index) :-
    Cabeca > 0, !,
    append(Acc, ilha(Cabeca, (N_L, Index)), NovoAcc),
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, NovoAcc, Ilhas, No).

extrai_ilhas_linha(N_L, [Cabeca | Resto], ListaFinal, Ilhas, Index) :-
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, ListaFinal, Ilhas, NovoIndex).

