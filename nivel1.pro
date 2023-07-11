% Tamanho del tablero (no tiene porque ser cuadrada)
filas(2).
columnas(2).

% Pistas del nivel
pista(0, 1, j).
pista(1, 1, c).
pista(2, 1, x).

% Importamos el programa principal, el "solucionador".
:- consult('sokoban.pro').