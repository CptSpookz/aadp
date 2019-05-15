% metodo que checa se um elemento pertence a uma lista
% caso elemento seja a cabeca, retorna true
pertence(Elem,[Elem|_]).

% caso contrario, procura na cauda
pertence(Elem,[_|Cauda]) :- pertence(Elem,Cauda).

% se o estado não tiver sucessor, falha e não procura mais (corte)
estende(_,[]).

% metodo que faz a extensao do caminho até os nós filhos do estado
estende([Estado|Caminho],ListaSucessores) :- bagof(
    [Sucessor,Estado|Caminho], 
    (s(Estado,Sucessor), not(pertence(Sucessor,[Estado|Caminho]))), 
    ListaSucessores),!.

% metodo que concatena duas listas
concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :-concatena(Cauda,L2,Resultado).

% metodo que retira um elemento de uma lista e retorna a lista sem o elemento
retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Cabeca|Cauda],[Cabeca|Resultado]) :- retirar_elemento(Elem,Cauda,Resultado).

% solucao por busca em largura (bl)
solucao_bl(Inicial,Solucao) :- bl([[Inicial]],Solucao).

% se o primeiro estado de F for meta, entao o retorna com o caminho
bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).

% falha ao encontrar a meta, entao estende o primeiro estado ate seus sucessores e os coloca no final da fronteira
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), 
    concatena(Outros,Sucessores,NovaFronteira), 
    bl(NovaFronteira,Solucao).

% solucao por busca em profundidade (bp)
solucao_bp(Inicial,Solucao) :- bp([],Inicial,Solucao).

% se o primeiro estado da lista eh meta, retorna a meta
bp(Caminho,Estado,[Estado|Caminho]) :- meta(Estado).

% se falha, coloca o no caminho e continua a busca
bp(Caminho,Estado,Solucao) :- s(Estado,Sucessor), 
    not(pertence(Sucessor,[Estado|Caminho])),
    bp([Estado|Caminho],Sucessor,Solucao).
 
%ESBOCO DA REPRESENTACAO DO ESTADO DO ROBO%
%estado([cordenadaRobo], reservatorio, [[Lixos]], [Elevadores], [[Paredes]], [Dockstation], contadorLixos, [Lixeira]).
%          ^               ^              ^                         ^             ^                ^           ^
%         X,Y         numero inteiro    Lista com até             Lista         Coordenada      numero      Coordenada
 %                                                                                              Inteiro
%                                       3  coordenadas           coordenadas
 
%REGRAS DE SUCESSAO DOS ESTADOS DO ROBÔ

% mover o robo para a direita. X e Y representam respectivamente a
% coluna e o andar que o robo se encontr
s([[X,Y], Reservatorio,[LCabeca|[LCauda|[LResto]]]],
  [[X2,Y], Reservatorio, [LCabeca|[LCauda|[LResto]]]]):-
    X2 is X + 1,
    pertence(X2, [0,1,2,3,4,5,6,7,8,9]).


% Mover o robo para a esquerda. X e Y representam respectivamente a
% coluna e o andar que o robo se encontra
s([[X,Y], Reservatorio, [LCabeca|[LCauda|[LResto]]]],
  [[X2,Y], Reservatorio, [LCabeca|[LCauda|[LResto]]]]):-
    X2 is X-1,
    pertence(X2, [0,1,2,3,4,5,6,7,8,9]).

% mover o robo para cima. X e Y representam respectivamente a coluna e o
% andar que o robo se encontra
s([[X,Y], Reservatorio,[LCabeca|[LCauda|[LResto]]]],
  [[X,Y2], Reservatorio,[LCabeca|[LCauda|[LResto]]]]):-
    Y2 is Y+1,
    pertence(Y2,[0,1,2,3,4]), pertence(X,[2,8]).

% mover o robo para baixo. X e Y representam respectivamente a coluna e o
% andar que o robo se encontra
s([[X,Y], Reservatorio,[LCabeca|[LCauda|[LResto]]]],
  [[X,Y2], Reservatorio,[LCabeca|[LCauda|[LResto]]]]):-
    Y2 is Y-1,
    pertence(Y2,[0,1,2,3,4]), pertence(X,[2,8]).

%cata lixo
 s([[X,Y],Reservatorio, [LCabeca|[LCauda|[LResto]]]],[[X,Y], Reservatorio1,
 [LCabeca|[LCauda|[LResto]]]]):-pertence([X,Y],[LCabeca]) ,
    Reservatorio1 is Reservatorio + 1; pertence([X,Y],[LCauda]),
    Reservatorio1 is Reservatorio + 1;
    pertence([X,Y],[LResto]), Reservatorio1 is Reservatorio + 1.



%deixa lixo

S([[X,Y],Reservatorio, [LCabeca|[LCauda|[LResto]]],[Paredes],[Dockstation],contadorlixos,[X,Y]],
  [[X,Y],Reservatorio2, [LCabeca|[LCauda|[LResto]]],[Paredes],[Dockstation],contadorlixos][X,Y]) :-
  pertence(Reservatorio,[1,2]),
  Reservatorio2 is mod(Reservatorio, Reservatorio).