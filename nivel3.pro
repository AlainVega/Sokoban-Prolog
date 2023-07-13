% Tamanho del tablero (no tiene porque ser cuadrada)
filas(4).
columnas(6).

% Pistas del nivel, j = jugador, c = caja, x = destino, o = obstaculo.
pista(1, 2, j).
pista(1, 5, c).
pista(2, 5, c).
pista(3, 2, c).
pista(1, 1, x).
pista(2, 1, x).
pista(4, 6, x).
pista(2, 3, o).
pista(3, 3, o).
pista(1, 6, o).

% Importamos el programa principal, el "solucionador".
:- consult('sokoban.pro').