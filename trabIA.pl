estado_robo ([[X,Y],reservatorio]).

retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Cabeça|Cauda],[Cabeça| Resultado]) :- retirar_elemento(Elem,Cauda,Resultado).

cenario([[[6,4],[5,4][7,8]],[2,8]]).

sujeira([6,4]).
sujeira([5,4]).
sujeira([7,8]).
elevador(2).
elevador(8).

S(X, Y) :- mover_direita(X,Y); mover_cima(X,Y); recolher_sujeira(X,Y,Z).

mover_direita([X,Y|Cauda],[X1,Y|Cauda]) :- Y1 is Y + 1, pertence (Y1, [0,1,2,3,4,5,6,7,8,9]).
mover_cima([X,Y|Cauda],[X,Y1|Cauda]) :- elevador(Y),X1 is X + 1, pertence(X1,[0,1,2,3,4]).
recolher_sujeira([Posicao|[Z|_]],[Posicao|[Z1]],[Cabeca|_]) :- retirar_elemento(Posicao,Cabeca), Z1 is Z + 1, Z < 2.
