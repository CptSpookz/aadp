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
retirar_elemento(Elem,[Cabeça|Cauda],[Cabeça|Resultado]) :- retirar_elemento(Elem,Cauda,Resultado).

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

% metodo para decidir os estados sucessores
s(X, Y) :- mover_direita(X,Y); mover_cima(X,Y,Cenario); recolher_sujeira(X,Y,Cenario,Cenario).

% metodo de movimentacao a direita, caso nao haja uma parede, incrementa a posicao Y do agente
mover_direita([X,Y|Cauda], [X,Y1|Cauda]) :- Y1 is Y + 1, pertence(Y1, [0,1,2,3,4,5,6,7,8,9]), not(parede([X,Y1])).

% metodo de movimentacao para cima, caso haja um elevador na posicao, incrementa a posicao X do agente
mover_cima([X,Y|Cauda], [X1,Y|Cauda], [_|[Elevador]]) :- pertence(Y, Elevador), X1 is X + 1, pertence(X1,[0,1,2,3,4]). 

% metodo para recolher sujeira, caso o reservatorio do agente não esteja cheio, recolhe 1 sujeira e atualiza o cenario
recolher_sujeira([Posicao|[Z]], [Posicao|[Z1]], [Sujeiras|_], Cenario) :- pertence(Posicao, Sujeiras), Z1 is Z + 1, Z < 2, retirar_elemento(Posicao, Sujeiras, Cenario).

