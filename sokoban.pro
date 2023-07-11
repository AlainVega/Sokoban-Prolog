% Esto es un hecho, se puede comprobar corriendo en la terminal de swi-prolog (swipl) de esta forma:
game(sokoban).
/**
 * swipl sokoban.pro
 * game(sokoban)        ---> te va a responder true.
 * game(X).             ---> te va a responder X = sokoban.
 * X.                   ---> te va responder 42 (es un easter egg de nose que serie/pelicula)
 * 
 * Documentacion de swi-prolog: https://www.swi-prolog.org/pldoc/man?section=overview
 */
% la extension que instale se llama VSC-Prolog
% podemos usar la extension .pro o .pl (esta da problemas pq vscode piensa que es perl)

/**
 * Funcion principal para solucionar el sokoban.
 * Primero crea la plantilla de la solucion "inicializa la matriz".
 * Segundo carga las pistas del nivel a la plantilla solucion "inicializa el nivel".
 * Tercero escribe en consola la lista cargada.
*/
sokoban(L) :- crearPlantilla(L), cargarPistas(L), write(L).

% Crea la lista solucion, inicializa la lista con valor _
crearPlantilla(L) :- filas(FILAS), columnas(COLUMNAS), findall(casilla(F,C,_), (between(1,FILAS,F), between(1,COLUMNAS,C)), L).

% Mete las pistas a la plantilla creada antes.
cargarPistas(L) :- conseguirPistas(P), meterPistas(P, L).

% Consigue las pistas de un archivo externo y la retorna en P
conseguirPistas(P) :- findall(casilla(F,C,X), pista(F,C,X), P).

% Mete las pistas que estan en la primera lista a L
meterPistas([], _). % Caso base 
meterPistas([H|T], L) :- member(H, L), meterPistas(T, L). % Caso inductivo