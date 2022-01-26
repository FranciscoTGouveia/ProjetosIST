% Predicado: extrai_ilhas_linha/3
/* Ilhas e uma lista ordenada, da esquerda para a direita,
   cujos elementos sao ilhas presentes em Linha.
*/
extrai_ilhas_linha(N_L, Linha, Ilhas) :-
    extrai_ilhas_linha(N_L, Linha, [], Ilhas, 1).
extrai_ilhas_linha(_N_L, [], Ilhas, Ilhas, _). % Condicao de paragem
extrai_ilhas_linha(N_L, [Cabeca | Resto], Acc, Ilhas, Index) :-
    Cabeca > 0, !,
    append(Acc, [ilha(Cabeca, (N_L, Index))], NovoAcc),
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, NovoAcc, Ilhas, NovoIndex);
    NovoIndex is Index + 1,
    extrai_ilhas_linha(N_L, Resto, Acc, Ilhas, NovoIndex).




% Predicado: ilhas/2
/* Ilhas e a lista ordenada, da esquerda para a direita,
   e de cima para baixo, cujos elementos sao linhas,
   tendo cada uma as ilhas presentes nessa linha.
*/
ilhas(Puz, Ilhas) :- 
    ilhas(Puz, [], Ilhas, 1).
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




% Predicado: estado/2
/* Objetivo: Representar o estado de um puzzle durante a sua resolucao,
   num dado momento na seguinte disposicao:
   -> O primeiro elemento e uma ilha;
   -> O segundo elemento e a lista das vizinhas dessa ilha;
   -> A terceira e a lista das pontes da ilha, (vazia no estado inicial);
*/
estado(Ilhas, Estado) :-
    estado(Ilhas, Ilhas, Estado).
estado(Ilhas, IlhasFixas, Estado) :-
    findall([Ilha, Vizinhas, []], (member(Ilha, Ilhas), vizinhas(IlhasFixas, Ilha, Vizinhas)), Estado).




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
    L1 < L2, Ponte = ponte((L1,C1), (L2,C2));
    L2 > L1, Ponte = ponte((L2,C2), (L1,C1));
    ((C1 < C2) -> Ponte = ponte((L1,C1), (L2,C2)); Ponte = ponte((L2,C2), (L1,C1))).




% Predicado: caminho_livre/5
% Objetivo: Devolve um valor logico conforme o caminho esteja ou nao livre.
caminho_livre(_Pos1, _Pos2, Posicoes, ilha(_P1,(L_ilha, C_ilha)), ilha(_P2, (L_vz,C_vz))) :-
    posicoes_entre((L_ilha, C_ilha), (L_vz, C_vz), EntreIlhaVz),
    intersection(EntreIlhaVz, Posicoes, Intersecoes),
    Intersecoes == [].
caminho_livre(Pos1, Pos2, Posicoes, ilha(_P1,(L_ilha, C_ilha)), ilha(_P2, (L_vz,C_vz))) :-
    posicoes_entre((L_ilha, C_ilha), (L_vz, C_vz), EntreIlhaVz),
    EntreIlhaVz == Posicoes,
    ((Pos1 == (L_ilha, C_ilha), Pos2 == (L_vz, C_vz));
    (Pos1 == (L_vz, C_vz), Pos2 == (L_ilha, C_ilha))).





% Predicado: actualiza_vizinhas_entrada/5
/* Objetivo: Atualiza a entrada de uma determinada ilha e as suas respetivas
   vizinhas, apos a criacao de uma ponte entre Pos1 e Pos2. NovaEntrada ficara
   entao igual a Entrada com a respetiva atualizacao na lista das vizinhas.
*/
actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Vizinhas, Pontes], Novo_Estado) :-
    findall(Viz, (member(Viz, Vizinhas), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz)), VizinhasFinal),
    Novo_Estado = [Ilha, VizinhasFinal, Pontes].




% Predicado: actualiza_vizinhas_apos_pontes/4
/* Objetivo: Recebe um estado e atualiza cada entrada apois a colocaco de uma ponte
   entre Pos1 e Pos2.
*/
actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) :-
    posicoes_entre(Pos1, Pos2, PosicoesEntrePos1Pos2),
    maplist(actualiza_vizinhas_entrada(Pos1, Pos2, PosicoesEntrePos1Pos2), Estado, Novo_estado);
    Novo_estado = Estado.




% Predicado: ilhas_terminadas/2
/* Objetivo: Devolve as ilhas que ja tem todas as pontes associadas,
   tambem designdas por terminadas.
*/
ilhas_terminadas(Estado, Ilhas_term) :-
    findall(ilha(N_pontes, Pos),
    (member([ilha(N_pontes, Pos), _Vizinhas, Pontes], Estado), length(Pontes, LenPontes), LenPontes == N_pontes), 
    Ilhas_term).




% Predicado: tira_ilhas_terminadas_entrada/3
/* Objetivo: Retira as ilhas terminadas de uma entrada.
*/
tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizinhas, Pontes], Nova_Entrada) :-
    findall(Viz, (member(Viz, Vizinhas), \+member(Viz, Ilhas_term)), NovasVizinhas),
    Nova_Entrada = [Ilha, NovasVizinhas, Pontes].




% Predicado: tira_ilhas_terminadas/3
/* Objetivo: Recebe um estado e atualiza as vizinhas de cada ilha
   de acordo com as ilhas ja terminadas.
*/
tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
    maplist(tira_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).




% Predicado: marca_ilhas_terminadas_entrada/3
/* Objetivo: Caso a ilha de uma entrada esteja nas ilhas terminadas,
   o seu numero de pontes sera substituido por x.
*/
marca_ilhas_terminadas_entrada(Ilhas_term, [ilha(P,(L,C)), Vizinhas, Pontes], Nova_Entrada) :-
    member(ilha(P,(L,C)), Ilhas_term),
    Nova_Entrada = [ilha('X', (L,C)), Vizinhas, Pontes];
    Nova_Entrada = [ilha(P, (L,C)), Vizinhas, Pontes].




% Predicado: marca_ilhas_terminadas/3
/* Objetivo: Recebe um estado e atualiza as ilhas caso ja tenham
   sido marcadas com um x.
*/
marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
      maplist(marca_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).




% Predicado: trata_ilhas_terminadas/2
/* Objetivo: Atualiza estado apos a aplicacao dos prediacos
   tira_ilhas_terminadas e marca_ilhas_terminadas.
*/
trata_ilhas_terminadas(Estado, Novo_Estado) :-
    ilhas_terminadas(Estado, IlhasTerminadas),
    tira_ilhas_terminadas(Estado, IlhasTerminadas, EstadoAlpha),
    marca_ilhas_terminadas(EstadoAlpha, IlhasTerminadas, Novo_Estado).





% Predicado: junta_pontes/5
/* Objetivo: Atualiza o estado pela adicao das pontes entre Ilha1 e Ilha2.
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
