% Tamanho del tablero (no tiene porque ser cuadrada)
filas(3).
columnas(3).

% Pistas del nivel
pista(1, 1, j).
pista(2, 2, c).
pista(3, 2, c).
pista(2, 3, x).
pista(3, 3, x).
pista(1, 3, o).

% Importamos el programa principal, el "solucionador".
:- consult('sokoban.pro').