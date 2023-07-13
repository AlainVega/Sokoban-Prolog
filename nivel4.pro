% Archivo que contiene la disposicion inicial del juego, se podria ver como un "nivel".

% Por ejemplo: un nivel con un tablero 10x10
filas(7).
columnas(10).

% 5 caja, sus destinos, el jugador y 8 obstaculos.
pista(2, 8, c). 
pista(3, 5, c).
pista(4, 4, c).
pista(4, 6, c).
pista(5, 5, c).
pista(2, 1, x).
pista(1, 7, x).
pista(7, 1, x).
pista(6, 5, x).
pista(7, 10, x).
pista(4, 5, j).
pista(3, 8, o).
pista(4, 8, o).
pista(5, 8, o).
pista(6, 8, o).
pista(6, 7, o).
pista(1, 1, o).
pista(2, 3, o).
pista(6, 2, o).

% "Importamos" el archivo que resuelve el juego.
:- consult('sokoban.pro').