% Tamanho del tablero (no tiene porque ser cuadrada)
filas(7).
columnas(3).

% Pistas del nivel, j = jugador, c = caja, x = destino, o = obstaculo.

pista(4, 2, j).
pista(1, 1, c).
pista(2, 3, c).
pista(4, 3, c).
pista(6, 2, c).
pista(1, 1, x).
pista(1, 3, x).
pista(7, 1, x).
pista(7, 3, x).
/*
pista(4, 2, j).
pista(1, 1, c).
pista(1, 3, c).
pista(7, 1, c).
pista(7, 3, c).
pista(1, 1, x).
pista(1, 3, x).
pista(7, 1, x).
pista(7, 3, x).
*/
% Importamos el programa principal, el "solucionador".
:- consult('sokoban.pro').