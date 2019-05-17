% estado_robo([[X,Y],Reservatorio]).

% Caso 1, sucesso, cenário 5x5
cenario([[4,4], [[3,4],[4,2],[1,1]], [3], [4,1], [4,4], [2,2], 3]).
% Caso 2, sucesso, cenário 10x5
cenario([[9,4], [[2,3],[4,1],[5,0],[6,4],[9,1]], [1,8], [[3,1], [5,2], [5,3]], [7,3], [3,2], 2]).
% Caso 3, falha, cenário 4x4
cenario([[3,3], [[2,3]], [1], [[3,2]], [3,3], [], 2]).
