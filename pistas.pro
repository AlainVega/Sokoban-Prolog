% Archivo que contiene la disposicion inicial del juego, se podria ver como un "nivel".

/**
 *  Hay que definir como se van a representar las cajas, los destinos y el jugador.
 * Una forma puede ser:
 * pista(fila, columna, caja). 
 * pista(fila, columna, destino).
 * pista(fila, columna, jugador).
 * pista(fila, columna, obstaculo).
*/

% Por ejemplo: un nivel con un tablero 3x3
filas(3).
columnas(3).

% 1 caja, su destino y el jugador.
pista(1, 1, c). 
pista(1, 2, x).
pista(2, 1, j).

% "Importamos" el archivo que resuelve el juego.
:- consult('sokoban.pro').