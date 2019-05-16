% FUNÇÕES UTILITÁRIAS
% metodo que checa se um elemento pertence a uma lista
% caso elemento seja a cabeca, retorna true
pertence(Elem,[Elem|_]).
% caso contrario, procura na cauda
pertence(Elem,[_|Cauda]) :- pertence(Elem,Cauda).

% metodo que faz a extensao do caminho até os nós filhos do estado
% se o estado não tiver sucessor, falha e não procura mais (corte)
estende(_,[]).
estende([Estado|Caminho],ListaSucessores) :- bagof(
    [Sucessor,Estado|Caminho], 
    (s(Estado,Sucessor), not(pertence(Sucessor,[Estado|Caminho]))), 
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
    not(pertence(Sucessor,[Estado|Caminho])),
    bp([Estado|Caminho],Sucessor,Solucao).
 

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

% mover o robo para a direita. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[X,Y], Reservatorio], [[X2,Y], Reservatorio]) :- cenario(C),
	X2 is X + 1, valida([X2,Y], parede, C).

% mover o robo para a esquerda. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[X,Y], Reservatorio], [[X2,Y], Reservatorio]) :- cenario(C),
	X2 is X - 1, valida([X2,Y], parede, C).

% mover o robo para cima. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[X,Y], Reservatorio], [[X2,Y], Reservatorio]) :- cenario(C),
	valida(X, elevador, C), Y2 is Y + 1.

% mover o robo para baixo. X e Y representam respectivamente a coluna e o andar que o robo se encontra
s([[X,Y], Reservatorio], [[X,Y2], Reservatorio]) :- cenario(C),
	valida(X, elevador, C), Y2 is Y - 1.

% Coleta lixo
s([[X,Y],Reservatorio],[[X,Y], Reservatorio1]) :- cenario(C),
 	valida([X,Y], sujeira, C), Reservatorio1 is Reservatorio + 1,
 	valida(Reservatorio1, capacidade, C); 

% Deixa lixo
s([[X,Y],Reservatorio], [[X,Y], 0]) :- cenario(C),
	valida([X,Y], lixeira, C), pertence(Reservatorio,[1,2]).


% FUNÇÕES DO ROBÔ
% Regra objetivo do robô, chegar à dock station com nenhuma sujeira no reservatório ou no cenário
meta([Dockstation, 0]) :- cenario([_, [], _, _, Dockstation|_]).


% Método para checar se uma coordenada é válida
%
valida([X,Y], sujeira, [[Xmax,Ymax], Sujeiras|_]) :- integer(X), integer(Y),
	X > 0, X < Xmax,
	Y > 0, Y < Ymax,
	pertence([X,Y], Sujeiras), !.

%
valida(Y, elevador, [[_,Ymax], _, Elevadores|_]) :- integer(Y), 
	Y > 0, Y < Ymax, 
	pertence(Y, Elevadores), !.

%
valida([X,Y], parede, [[Xmax,Ymax], _, _, Paredes|_]) :- integer(X), integer(Y),
	Y > 0, Y < Ymax,
	X > 0, X < Xmax,
	not(pertence([X,Y], Paredes)), !.

%
valida(Reservatorio, capacidade, [_, _, _, _, _, _, CapacidadeRobo]) :- integer(Reservatorio),
	Reservatorio =< CapacidadeRobo, !.

%
valida(Lixeira, lixeira, [_, _, _, _, _, Lixeira|_]).
