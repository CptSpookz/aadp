% FUNÇÕES UTILITÁRIAS
% metodo que checa se um elemento pertence a uma lista
% caso elemento seja a cabeca, retorna true
pertence(Elem,[Elem|_]).
% caso contrario, procura na cauda
pertence(Elem,[_|Cauda]) :- pertence(Elem,Cauda).

% metodo que faz a extensao do caminho até os nós filhos do estado
% se o estado não tiver sucessor, falha e não procura mais (corte)
estende(_,[]).
estende([Estado|Caminho],ListaSucessores) :- bagof([Sucessor,Estado|Caminho], 
    (s(Estado,Sucessor), \+ pertence(Sucessor,[Estado|Caminho])), 
    ListaSucessores),!.

% metodo que concatena duas listas
concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :- concatena(Cauda,L2,Resultado).

% metodo que retira um elemento de uma lista e retorna a lista sem o elemento
retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Cabeca|Cauda],[Cabeca|Resultado]) :- retirar_elemento(Elem,Cauda,Resultado).

% FUNÇÕES DE BUSCA
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
    \+ pertence(Sucessor, [Estado|Caminho]),
    bp([Estado|Caminho], Sucessor, Solucao).
 

% ESBOÇO DA REPRESENTAÇAO DO ESTADO DO ROBO
% estado(coordenadaRobo, reservatorio)
%          	 ^                 ^   
%          [X,Y] 	Número de Sujeiras Coletadas
% 
% ESBOÇO DA REPRESENTAÇAO DO CENARIO
% cenario(Limites, Sujeiras, Elevadores, Paredes, Dockstation, Lixeira, CapacidadeRobo).
% 		X/Y max | Lista de    | Lista de | Lista de    | Coordenada | Coordenada | Número
%		do Cen  | Coordenadas | Colunas  | Coordenadas |            |			 | Inteiro
 
% REGRAS DE SUCESSÃO DOS ESTADOS DO ROBÔ

% coleta lixo
s([[[X,Y], Reservatorio], [Lim, Sujeiras, Elev, Par, Dock, Lix, Capacidade]], 
  [[[X,Y], Reservatorio1], [Lim, Sujeiras1, Elev, Par, Dock, Lix, Capacidade]]) :- 
        pertence([X,Y], Sujeiras), retirar_elemento([X,Y], Sujeiras, Sujeiras1),
        Reservatorio1 is Reservatorio + 1, Reservatorio1 =< Capacidade.

% deixa lixo
s([[[X,Y], Reservatorio], C], [[[X,Y], 0], C]) :- valida([X,Y], lixeira, C), valida(Reservatorio, capacidade, C).

% mover o robo para a direita. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[[X,Y], Reservatorio], C], [[[X1,Y], Reservatorio], C]) :- X1 is X + 1, valida([X1,Y], parede, C).

% mover o robo para a esquerda. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[[X,Y], Reservatorio], C], [[[X2,Y], Reservatorio], C]) :- X2 is X - 1, valida([X2,Y], parede, C).

% mover o robo para cima. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[[X,Y], Reservatorio], C], [[[X,Y1], Reservatorio], C]) :- Y1 is Y + 1, valida([X,Y1], elevador, C).

% mover o robo para baixo. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[[X,Y], Reservatorio], C], [[[X,Y2], Reservatorio], C]) :- Y2 is Y - 1, valida([X,Y2], elevador, C).

% FUNÇÕES DO ROBÔ
% Regra objetivo do robô, chegar à dock station com nenhuma sujeira no reservatório ou no cenário
meta([[[DockX, DockY], 0], [_, [], _, _, [DockX, DockY]|_]]).


% Método para checar se um estado é válido
% checa se o robô está atualmente na mesma coluna que um dos elevadores do cenário, o que torna esta movimentação válida
valida([X,Y], elevador, [[Xmax,Ymax], _, Elevadores|_]) :- integer(X), integer(Y),
    X >= 0, X =< Xmax,
    Y >= 0, Y =< Ymax, 
	pertence(X, Elevadores).

% checa se a posição do robô é a mesma de uma das paredes do cenário, o que torna esta movimentação inválida
valida([X,Y], parede, [[Xmax,Ymax], _, _, Paredes|_]) :- integer(X), integer(Y),
	Y >= 0, Y =< Ymax,
	X >= 0, X =< Xmax,
	\+ pertence([X,Y], Paredes).

% checa se o reservatório do robô pode carregar a quantidade atual de sujeira
valida(Reservatorio, capacidade, [_, _, _, _, _, _, Capacidade]) :- Reservatorio =< Capacidade.

% checa se o robô está na posição da lixeira do cenário, o que torna esta movimentação válida
valida(Lixeira, lixeira, [_, _, _, _, _, Lixeira|_]).

