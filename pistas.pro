% Archivo que contiene la disposicion inicial del juego, se podria ver como un "nivel".

/**
 *  Hay que definir como se van a representar las cajas, los destinos y el jugador.
 * Una forma puede ser:
 * pista(fila, columna, caja). 
 * pista(fila, columna, destino).
 * pista(fila, columna, jugador).
*/

% Por ejemplo: un nivel con 1 caja, su destino y el juegador.

pista(2, 5, c). 
pista(3, 4, x).
pista(1, 1, j).

% Este archivo deberia ser importado por el sokoban.pro para inicializar la matriz del juego.