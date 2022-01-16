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
    

% Predicado: cria_ponte/3
% Objetivo: Cria uma ponte entre Pos1 e Pos2, em que Pos1 e Pos2 estao ordenadas.
cria_ponte((L1, C1), (L2, C2), Ponte) :-
    (L1 < L2, Ponte = ponte((L1,C1), (L2,C2));
    L2 > L1, Ponte = ponte((L2,C2), (L1,C1));
    ((C1 < C2) -> Ponte = ponte((L1,C1), (L2,C2)); Ponte = ponte((L2,C2), (L1,C1)))).




% Predicado: caminho_livre/5
% Objetivo: Devolve um valor logico conforme o caminho esteja ou nao livre.
caminho_livre(_Pos1, _Pos2, Posicoes, ilha(_P1,(L_ilha, C_ilha)), ilha(_P2, (L_vz,C_vz))) :-
    posicoes_entre((L_ilha, C_ilha), (L_vz, C_vz), EntreIlhaVz),
    intersection(EntreIlhaVz, Posicoes, Intersecoes),
    Intersecoes == [].
caminho_livre(_Pos1, _Pos2, Posicoes, ilha(_P1,(L_ilha, C_ilha)), ilha(_P2, (L_vz,C_vz))) :-
    posicoes_entre((L_ilha, C_ilha), (L_vz, C_vz), EntreIlhaVz),
    EntreIlhaVz == Posicoes.
    




% Predicado: actualiza_vizinhas_entrada/5
/* Objetivo: Atualiza a entrada de uma determinada ilha e as suas respetivas
   vizinhas, apos a criacao de uma ponte entre Pos1 e Pos2. NovaEntrada ficara
   entao igual a Entrada com a respetiva atualizacao na lista das vizinhas.
*/
lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, Vizinhas, ListaFinal) :-
    lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, Vizinhas, [], ListaFinal).
lista_vizinhas(_Pos1, _Pos2, _Posicoes, _Ilha, [], ListaFinal, ListaFinal).
lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, [Viz | Resto], Acc, ListaFinal) :-
    caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz),
    append(Acc, [Viz], NovoAcc),
    lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, Resto, NovoAcc, ListaFinal).
lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, [_Viz | Resto], Acc, ListaFinal) :-
    lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, Resto, Acc, ListaFinal).

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Vizinhas, Pontes], Novo_Estado) :-
    lista_vizinhas(Pos1, Pos2, Posicoes, Ilha, Vizinhas, ListaVizinhasFinal),
    Novo_Estado = [Ilha, ListaVizinhasFinal, Pontes].





% Predicado: actualiza_vizinhas_apos_pontes/4
/* Objetivo: Recebe um estado e atualiza cada entrada apois a colocaco de uma ponte
   entre Pos1 e Pos2.
*/
actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_Estado) :-
    actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, [], Novo_Estado).
actualiza_vizinhas_apos_pontes([], _Pos1, _Pos2, Novo_Estado, Novo_Estado).
actualiza_vizinhas_apos_pontes([Entrada | Resto], Pos1, Pos2, Acc, Novo_Estado) :-
    posicoes_entre(Pos1, Pos2, PosicoesEntrePos1Pos2),
    actualiza_vizinhas_entrada(Pos1, Pos2, PosicoesEntrePos1Pos2, Entrada, Nova_Entrada),
    append(Acc, [Nova_Entrada], NovoAcc),
    actualiza_vizinhas_apos_pontes(Resto, Pos1, Pos2, NovoAcc, Novo_Estado).
actualiza_vizinhas_apos_pontes([_Est | Resto], Pos1, Pos2, Acc, Novo_Estado) :-
    actualiza_vizinhas_apos_pontes(Resto, Pos1, Pos2, Acc, Novo_Estado).




% Predicado: ilhas_terminadas/2
/* Objetivo: Devolve as ilhas que ja tem todas as pontes associadas,
   tambem designdas por terminadas.
*/
ilhas_terminadas(Estado, Ilhas_term) :- ilhas_terminadas(Estado, [], Ilhas_term).
ilhas_terminadas([], Ilhas_term, Ilhas_term).
ilhas_terminadas([[ilha(N_pontes, Pos), _Vizinhas, Pontes] | Resto], Acc, Ilhas_term) :-
    N_pontes \== 'X',
    length(Pontes, LenPontes),
    LenPontes == N_pontes,
    append(Acc, [ilha(N_pontes, Pos)], NovoAcc),
    ilhas_terminadas(Resto, NovoAcc, Ilhas_term).
ilhas_terminadas([_Estado | Resto], Acc, Ilhas_term) :-
    ilhas_terminadas(Resto, Acc, Ilhas_term).




% Predicado: tira_ilhas_terminadas_entrada/3
/* Objetivo: Retira as ilhas terminadas de uma entrada.
*/
tira_ilhas(Ilhas_term, Vizinhas, NovasVizinhas) :- 
    tira_ilhas(Ilhas_term, Vizinhas, [], NovasVizinhas).
tira_ilhas(_Ilhas_term, [], NovasVizinhas, NovasVizinhas).
tira_ilhas(Ilhas_term, [Viz | Resto], Acc, NovasVizinhas) :-
    (member(Viz, Ilhas_term),
    tira_ilhas(Ilhas_term, Resto, Acc, NovasVizinhas);
    append(Acc, [Viz], NovoAcc),
    tira_ilhas(Ilhas_term, Resto, NovoAcc, NovasVizinhas)).

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizinhas, Pontes], Nova_Entrada) :-
    tira_ilhas(Ilhas_term, Vizinhas, NovasVizinhas),
    Nova_Entrada = [Ilha, NovasVizinhas, Pontes].    




% Predicado: tira_ilhas_terminadas/3
/* Objetivo: Recebe um estado e atualiza as vizinhas de cada ilha
   de acordo com as ilhas ja terminadas.
*/
tira_ilhas_terminadas(Estado, Ilhas_term, Novo_Estado) :-
    tira_ilhas_terminadas(Estado, Ilhas_term, [], Novo_Estado).
tira_ilhas_terminadas([], _Ilhas_term, Novo_Estado, Novo_Estado).
tira_ilhas_terminadas([Entrada | Resto], Ilhas_term, Acc, Novo_Estado) :-
    tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, AtualizaEntrada),
    append(Acc, [AtualizaEntrada], NovoAcc),
    tira_ilhas_terminadas(Resto, Ilhas_term, NovoAcc, Novo_Estado).




% Predicado: marca_ilhas_terminadas_entrada/3
/* Objetivo: Caso a ilha de uma entrada esteja nas ilhas terminadas,
   o seu numero de pontes sera substituido por x.
*/
marca_ilhas_terminadas_entrada(Ilhas_term, [ilha(P,(L,C)), Vizinhas, Pontes], Nova_Entrada) :-
    member(ilha(P,(L,C)), Ilhas_term),
    Nova_Entrada = [ilha('X', (L,C)), Vizinhas, Pontes].
marca_ilhas_terminadas_entrada(_Ilhas_term, [ilha(P,(L,C)), Vizinhas, Pontes], Nova_Entrada) :-
    Nova_Entrada = [ilha(P, (L,C)), Vizinhas, Pontes].



% Predicado: marca_ilhas_terminadas/3
/* Objetivo: Recebe um estado e atualiza as ilhas caso ja tenham
   sido marcadas com um x.
*/
marca_ilhas_terminadas(Estado, Ilhas_term, Novo_Estado) :-
    marca_ilhas_terminadas(Estado, Ilhas_term, [], Novo_Estado).
marca_ilhas_terminadas([], _Ilhas_term, Novo_Estado, Novo_Estado).
marca_ilhas_terminadas([Entrada | Resto], Ilhas_term, Acc, Novo_Estado) :-
    marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, AtualizaEntrada),
    append(Acc, [AtualizaEntrada], NovoAcc),
    marca_ilhas_terminadas(Resto, Ilhas_term, NovoAcc, Novo_Estado).




% Predicado: trata_ilhas_terminadas/2
/* Objetivo: Atualiza estado apos a aplicacao dos prediacos
   tira_ilhas_terminadas e marca_ilhas_terminadas.
*/
trata_ilhas_terminadas(Estado, Novo_Estado) :-
   ilhas_terminadas(Estado, IlhasTerminadas),
   tira_ilhas_terminadas(Estado, IlhasTerminadas, EstadoAlpha),
   marca_ilhas_terminadas(EstadoAlpha, IlhasTerminadas, Novo_Estado).
