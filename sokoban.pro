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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Planeamiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicados necesarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

samePosition([F1, C1], [F2, C2]) :- F1 = F2 , C1 = C2.

diffPosition([F1, C1], [F2, C2]) :- not(samePosition([F1, C1], [F2, C2])).

between(L, X, R) :- X >= L, X =< R.

% Esta Fila y columna estan dentro del tablero?
onTable([F, C]) :- filas(Num_Filas), columnas(Num_columnas), between(1, F, Num_Filas), between(1, C, Num_columnas).

% Estas 2 posiciones son adyacentes?
adjacent([X1, Y1], [X2, Y2]) :- onTable([X1, Y1]), onTable([X2, Y2]), diffPosition([X1, Y1], [X2, Y2]), 
        (right([X1, Y1], [X2, Y2]); left([X1, Y1], [X2, Y2]); up([X1, Y1], [X2, Y2]); down([X1, Y1], [X2, Y2])), !.

% El primer parametro esta a la derecha del segundo.
right([F1, C1], [F2, C2]) :- C1 is C2 + 1, F1 is F2.
% El primer parametro esta a la izquierda del segundo.
left([F1, C1], [F2, C2]) :- C1 is C2 - 1, F1 is F2.
% El primer parametro esta arriba del segundo.
up([F1, C1], [F2, C2]) :- F1 is F2 - 1, C1 is C2.
% El primer parametro esta abajo del segundo.
down([F1, C1], [F2, C2]) :- F1 is F2 + 1, C1 is C2.

% Cargar pistas de otro archivo.
at(j, [F, C]) :- pista(F, C, j).
at(c, [F, C]) :- pista(F, C, c).
at(x, [F, C]) :- pista(F, C, x).
at(o, [F, C]) :- pista(F, C, o).

% La celda esta sucia? sucia = hay un jugador o caja u obstaculo.
dirty([F, C]) :- (at(j, [F, C]); at(c, [F, C]); at(o, [F, C])), !.

clean([F, C]) :- onTable([F, C]), not(dirty([F, C])).

loadPlayerAndBoxPositions(L) :- findall([O, [F, C]], (at(O, [F, C]), O \= o, O \= x), L), write(L).

loadDestinyPositions(L) :- findall([x, [F, C]], (at(x, [F, C])), L), write(L).

loadObstaclesPositions(L) :- findall([o, [F, C]], (at(o, [F, C])), L), write(L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estados, estado inicial, goal test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/** Un estado cualquiera s es una lista [[at(j, [Fj, Cj]), [at(c, [Fc, Cc])], ..., [at(c, [Fc, Cc])]]  del jugador y todas las cajas
 * Es decir, un estado es donde esta el jugador y todas las cajas.
*/

defineInitialState(L) :- loadPlayerAndBoxPositions(L), initialState(L), !.

% Necesita una lista donde estan todos los at()
initialState([]).
initialState([H|T]) :- H = [O, [FO, CO]], at(O, [FO, CO]), initialState(T), !.

defineGoalTest(L) :- loadDestinyPositions(L), goalTest(L), !.

% Necesita una lista de las posiciones de los destinos x
goalTest([]). % Caso base.
goalTest([H|T]) :- H = [F, C], at(c, [F, C]), dirty([F, C]), goalTest(T). % Caso inductivo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Operadores STRIP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

move(j, [F1, C1], [F2, C2]) :- at(j, [F1, C1]), clean([F2, C2]), adjacent([F1, C1], [F2, C2]).

pushUp(c, [F1, C1], [F2, C2], [Fj, Cj]) :- at(c, [F1, C1]), clean([F2, C2]), down([Fj, Cj], [F1, C1]), down([F1, C1], [F2, C2]).
pushDown(c, [F1, C1], [F2, C2], [Fj, Cj]) :- at(c, [F1, C1]), clean([F2, C2]), up([Fj, Cj], [F1, C1]), up([F1, C1], [F2, C2]).
pushRight(c, [F1, C1], [F2, C2], [Fj, Cj]) :- at(c, [F1, C1]), clean([F2, C2]), left([Fj, Cj], [F1, C1]), left([F1, C1], [F2, C2]).
pushLeft(c, [F1, C1], [F2, C2], [Fj, Cj]) :- at(c, [F1, C1]), clean([F2, C2]), right([Fj, Cj], [F1, C1]), right([F1, C1], [F2, C2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resolver sokoban
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

