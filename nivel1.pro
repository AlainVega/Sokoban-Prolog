% Tamanho del tablero (no tiene porque ser cuadrada)
filas(2).
columnas(2).

% Pistas del nivel
pista(1, 2, j).
pista(2, 2, c).
pista(2, 1, x).

% Importamos el programa principal, el "solucionador".
:- consult('sokoban.pro').