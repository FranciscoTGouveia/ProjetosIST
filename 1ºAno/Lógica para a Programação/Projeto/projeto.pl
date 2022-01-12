:- ['codigo_comum.pl', 'puzzles_publicos.pl'].
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
vizinhas(Ilhas, Ilha, Vizinhas) :- vizinhas(Ilhas, Ilha, [], Vizinhas). % Engorda do predicado
vizinhas([], Ilha, Vizinhas, Vizinhas). % Condicao de paragem

vizinhas([Cabeca | Resto], Ilha, Acc, Vizinhas) :-
    % uma serie de comparacoes para verificar criterios
    % nao esquecer de escrever o corte
    append(Acc, [Cabeca], NovoAcc),
    vizinhas(Resto, Ilha, NovoAcc, Vizinhas).

vizinhas([Cabeca | Resto], Ilha, Acc, Vizinhas) :-
    vizinhas(Resto, Ilha, Acc, Vizinhas).
