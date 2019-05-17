% estado_robo([[X,Y],Reservatorio]).

% Caso 1, sucesso, cenário 5x5
cenario([[4,4], [[3,4],[4,2],[1,1]], [3], [4,1], [4,4], [2,2], 3]).
% Caso 2, sucesso, cenário 10x5
cenario([[9,4], [[0,0],[4,2],[3,3]], [2,8], [[1,2], [3,1], [4,0], [4,3], [9,4]], [5,0], [3,4], 2]).
% Caso 3, falha, cenário 4x4
cenario([[3,3], [[2,3]], [1], [[3,2]], [3,3], [], 2]).
