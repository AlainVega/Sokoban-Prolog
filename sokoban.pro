%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Planificacion: mundo Sokoban.

/** Integrantes:
 * Alain Vega
 * Mathias Martinez
*/

% Trabajo practico: programacion logica de la materia Informatica 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Planeamiento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predicados necesarios, "auxiliares"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

game(sokoban).

% Crea la lista solucion, inicializa la lista con valor _
% (EL NIVEL DEBE INCLUIR LOS HECHOS DE ESTE ARCHIVO).
crearPlantilla(L) :- filas(FILAS), columnas(COLUMNAS), findall(casilla(F,C,_), (between(1,FILAS,F), between(1,COLUMNAS,C)), L).

% Mete las pistas a la plantilla creada antes.
cargarPistas(L) :- conseguirPistas(P), meterPistas(P, L).

% Consigue las pistas de un archivo externo y la retorna en P
% (EL NIVEL DEBE INCLUIR LOS HECHOS DE ESTE ARCHIVO).
conseguirPistas(P) :- findall(casilla(F,C,X), pista(F,C,X), P).

% Mete las pistas que estan en la primera lista a L
meterPistas([], _). % Caso base 
meterPistas([H|T], L) :- member(H, L), meterPistas(T, L). % Caso inductivo

samePosition([F1, C1], [F2, C2]) :- F1 = F2 , C1 = C2.

diffPosition([F1, C1], [F2, C2]) :- not(samePosition([F1, C1], [F2, C2])).

between(L, X, R) :- X >= L, X =< R.

% Esta Fila y columna estan dentro del tablero?
% (EL NIVEL DEBE INCLUIR LOS HECHOS DE ESTE ARCHIVO).
onTable([F, C]) :- filas(Num_Filas), columnas(Num_columnas), between(1, F, Num_Filas), between(1, C, Num_columnas).

% Estas 2 posiciones son adyacentes?
adjacent([X1, Y1], [X2, Y2]) :-  
        (right([X1, Y1], [X2, Y2]), onTable([X1, Y1]), onTable([X2, Y2])); 
        (left([X1, Y1], [X2, Y2]), onTable([X1, Y1]), onTable([X2, Y2]));
        (up([X1, Y1], [X2, Y2]), onTable([X1, Y1]), onTable([X2, Y2])); 
        (down([X1, Y1], [X2, Y2]), onTable([X1, Y1]), onTable([X2, Y2])).

% El primer parametro esta a la derecha del segundo.
right([F1, C1], [F2, C2]) :-  F1 = F2, succ(C2, C1).
% El primer parametro esta a la izquierda del segundo.
left([F1, C1], [F2, C2]) :- F1 = F2, succ(C1, C2).
% El primer parametro esta arriba del segundo.
up([F1, C1], [F2, C2]) :- C1 = C2, succ(F1, F2).
% El primer parametro esta abajo del segundo.
down([F1, C1], [F2, C2]) :-  C1 = C2, succ(F2, F1).

% Cargar pistas del nivel (EL NIVEL DEBE INCLUIR LOS HECHOS DE ESTE ARCHIVO).
% Es decir, si queremos ejecutar el nivel1 lo que se debe hacer es asegurarse que en el archivo nivel1.pro este:
% :- consult('sokoban.pro').
at(j, [F, C]) :- pista(F, C, j).
at(c, [F, C]) :- pista(F, C, c).
at(x, [F, C]) :- pista(F, C, x).
at(o, [F, C]) :- pista(F, C, o).

% La celda esta sucia? sucia = hay un jugador o caja u obstaculo.
dirty([F, C]) :- (at(j, [F, C]); at(c, [F, C]); at(o, [F, C])), !.

clean([F, C]) :- onTable([F, C]), not(dirty([F, C])).

loadPlayerPosition(L) :- findall([j, [F, C]], (at(j, [F, C])), L).

loadPlayerAnyPosition(L) :- findall([j, [_, _]], (at(j, [_, _])), L).

loadPlayerAndBoxPositions(L) :- findall([O, [F, C]], (at(O, [F, C]), O \= o, O \= x), L).

loadDestinyPositions(L) :- findall([x, [F, C]], (at(x, [F, C])), L).

loadObstaclesPositions(L) :- findall([o, [F, C]], (at(o, [F, C])), L).

prepareFinalState(L) :- findall([c, [F, C]], (at(x, [F, C])), L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estados, estado inicial, goal test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/** Un estado cualquiera s es una lista [[at(j, [Fj, Cj]), [at(c, [Fc, Cc])], ..., [at(c, [Fc, Cc])]]  del jugador y todas las cajas
 * Es decir, un estado es donde esta el jugador y todas las cajas.
*/

defineInitialState(L) :- loadPlayerAndBoxPositions(L), write("El estado inicial es: "), write(L), nl,!.

% Necesita una lista donde estan todos los at()
initialState([]).
initialState([H|T]) :- H = [O, [FO, CO]], at(O, [FO, CO]), initialState(T), !.

defineGoalTest(L) :- prepareFinalState(L), write("La meta es: "), write(L), nl,!.

defineFinalState(L3) :- loadPlayerAnyPosition(L1), prepareFinalState(L2), append(L1, L2, L3), write("El estado final tiene la forma: "), write(L3), nl.

% Necesita una lista de las posiciones de los destinos x
goalTest([]). % Caso base.
goalTest([H|T]) :- H = [F, C], at(c, [F, C]), dirty([F, C]), goalTest(T). % Caso inductivo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algoritmo de planeamiento. Busqueda: iterative deepning.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Funcion principal 
sokoban(Plan) :- welcome, defineInitialState(Initial), defineFinalState(Final), solve(Initial, Final, Plan), foundPlan(Plan).

welcome :- write("======================================="), nl, nl,
        write("Planificacion: Mundo Sokoban"), nl, nl,
        write("======================================="), nl.

foundPlan(Plan) :- write("======================================="), nl,
        write("Se encontro el plan: "), write(Plan), nl,
        write("=======================================").

solve(Initial, Final, Plan) :- strips(Initial, Final, Plan).

/**
 * strips hace el trabajo pesado de conseguir el plan
 * Hay 2 casos que considerar:
 * Alcanzamos el estado final, el plan es vacio.
 * Todavia no alcanzamos el estado final, entonces producimos toda accion legal para llegar a un estado intermedio y repetimos.
*/
strips(Initial, Final, Plan) :- strips(Initial, Final, [Initial], Plan).

% Iterative deepening
strips(Initial, Final, Visited, Plan) :- deepening_strips(1, Initial, Final, Visited, Plan).

deepening_strips(Bound, Initial, Final, Visited, Plan) :- bounded_strips(Bound, Initial, Final, Visited, Plan).
deepening_strips(Bound, Initial, Final, Visited, Plan) :- succ(Bound, Successor), deepening_strips(Successor, Initial, Final, Visited, Plan).

bounded_strips(_, Final, Final, _, []).
bounded_strips(Bound, Initial, Final, Visited, [Action|Actions]) :-
        succ(Predecessor, Bound),
        action(Initial, Action),
        perform(Initial, Action, Intermediate),
        \+ member(Intermediate, Visited),
        bounded_strips(Predecessor, Intermediate, Final, [Intermediate|Visited], Actions).
/**
 * Determina las acciones legales que se pueden realizar en un estado cualquiera s
 * Es la precondicion de un operador.
*/
% Accion mover jugador.
action(State, moveUp(j, [F1, C1], [F2, C2])) :- 
        at(State, j, [F1, C1]), down([F1, C1], [F2, C2]), onTable([F2, C2]), free(State, [F2, C2]).
action(State, moveDown(j, [F1, C1], [F2, C2])) :- 
        at(State, j, [F1, C1]), up([F1, C1], [F2, C2]), onTable([F2, C2]), free(State, [F2, C2]).
action(State, moveRight(j, [F1, C1], [F2, C2])) :- 
        at(State, j, [F1, C1]), left([F1, C1], [F2, C2]), onTable([F2, C2]), free(State, [F2, C2]).
action(State, moveLeft(j, [F1, C1], [F2, C2])) :- 
        at(State, j, [F1, C1]), right([F1, C1], [F2, C2]), onTable([F2, C2]), free(State, [F2, C2]).
% Acciones de empujar la caja.
action(State, pushUp(c, [F1, C1], [F2, C2], [Fj, Cj])) :-
        at(State, c, [F1, C1]), at(State, j, [Fj, Cj]), down([Fj, Cj], [F1, C1]), down([F1, C1], [F2, C2]), free(State, [F2, C2]).
action(State, pushDown(c, [F1, C1], [F2, C2], [Fj, Cj])) :-
        at(State, c, [F1, C1]), at(State, j, [Fj, Cj]), up([Fj, Cj], [F1, C1]), up([F1, C1], [F2, C2]), free(State, [F2, C2]).
action(State, pushRight(c, [F1, C1], [F2, C2], [Fj, Cj])) :- 
        at(State, c, [F1, C1]), at(State, j, [Fj, Cj]), left([Fj, Cj], [F1, C1]), left([F1, C1], [F2, C2]), free(State, [F2, C2]).
action(State, pushLeft(c, [F1, C1], [F2, C2], [Fj, Cj])) :-
        at(State, c, [F1, C1]), at(State, j, [Fj, Cj]), right([Fj, Cj], [F1, C1]), right([F1, C1], [F2, C2]), free(State, [F2, C2]).

/*
action(State, move(j, [F1, C1], [F2, C2])) :- 
        at(State, j, [F1, C1]), adjacent([F1, C1], [F2, C2]), free(State, [F2, C2]).


action(State, pushUp(c, [F1, C1], [F2, C2], [Fj, Cj])) :-
        at(c, [F1, C1]), down([Fj, Cj], [F1, C1]), down([F1, C1], [F2, C2]), free(State, [F2, C2]).
action(State, pushDown(c, [F1, C1], [F2, C2], [Fj, Cj])) :-
        at(c, [F1, C1]), up([Fj, Cj], [F1, C1]), up([F1, C1], [F2, C2]), free(State, [F2, C2]).
action(State, pushRight(c, [F1, C1], [F2, C2], [Fj, Cj])) :- 
        at(c, [F1, C1]), left([Fj, Cj], [F1, C1]), left([F1, C1], [F2, C2]), free(State, [F2, C2]).
action(State, pushLeft(c, [F1, C1], [F2, C2], [Fj, Cj])) :-
        at(c, [F1, C1]), right([Fj, Cj], [F1, C1]), right([F1, C1], [F2, C2]), free(State, [F2, C2]).
*/

% at en el estado actual
at(State, j, [F, C]) :- member([j, [F, C]], State).
at(State, c, [F, C]) :- member([c, [F, C]], State).

% Mirar si esa posicion en el estado actual NO tiene un jugador, caja u obstaculo.
free(State, [F, C]) :- loadObstaclesPositions(O), append(State, O, L), onTable([F, C]),
        not(member([j, [F, C]], L)) , not(member([c, [F, C]], L)) , not(member([o, [F, C]], L)).

/**
 * Cambia el estado actual al nuevo estado con las acciones definidas. 
 * Es el efecto de un operador.
*/
% Cambia el estado actual al siguiente al realizar la accion mover jugador
/*perform(CurrentState, move(j, [F1, C1], [F2, C2]), NextState) :- 
        substitute([j,[F1,C1]], CurrentState, [j,[F2,C2]], NextState), write("El proximo estado es: "), write(NextState), nl.*/
perform(CurrentState, moveUp(j, [F1, C1], [F2, C2]), NextState) :- 
        substitute([j,[F1,C1]], CurrentState, [j,[F2,C2]], NextState), write("El proximo estado es: "), write(NextState), nl.

perform(CurrentState, moveDown(j, [F1, C1], [F2, C2]), NextState) :- 
        substitute([j,[F1,C1]], CurrentState, [j,[F2,C2]], NextState), write("El proximo estado es: "), write(NextState), nl.

perform(CurrentState, moveRight(j, [F1, C1], [F2, C2]), NextState) :- 
        substitute([j,[F1,C1]], CurrentState, [j,[F2,C2]], NextState), write("El proximo estado es: "), write(NextState), nl.

perform(CurrentState, moveLeft(j, [F1, C1], [F2, C2]), NextState) :- 
        substitute([j,[F1,C1]], CurrentState, [j,[F2,C2]], NextState), write("El proximo estado es: "), write(NextState), nl.
% Cambia el estado actual al siguiente al realizar la accion empujar caja hacia arriba
perform(CurrentState, pushUp(c, [F1, C1], [F2, C2], [Fj, Cj]), NextState) :- 
        substitute([c,[F1,C1]], CurrentState, [c,[F2, C2]], IntermediateState),
        substitute([j,[Fj,Cj]], IntermediateState, [j,[F1, C1]], NextState), write("El proximo estado es: "), write(NextState), nl.
% Cambia el estado actual al siguiente al realizar la accion empujar caja hacia abajo
perform(CurrentState, pushDown(c, [F1, C1], [F2, C2], [Fj, Cj]), NextState) :- 
        substitute([c,[F1,C1]], CurrentState, [c,[F2, C2]], IntermediateState),
        substitute([j,[Fj,Cj]], IntermediateState, [j,[F1, C1]], NextState), write("El proximo estado es: "), write(NextState), nl.
% Cambia el estado actual al siguiente al realizar la accion empujar caja hacia la derecha
perform(CurrentState, pushRight(c, [F1, C1], [F2, C2], [Fj, Cj]), NextState) :- 
        substitute([c,[F1,C1]], CurrentState, [c,[F2, C2]], IntermediateState),
        substitute([j,[Fj,Cj]], IntermediateState, [j,[F1, C1]], NextState), write("El proximo estado es: "), write(NextState), nl.
% Cambia el estado actual al siguiente al realizar la accion empujar caja hacia izquierda
perform(CurrentState, pushLeft(c, [F1, C1], [F2, C2], [Fj, Cj]), NextState) :- 
        substitute([c,[F1,C1]], CurrentState, [c,[F2, C2]], IntermediateState),
        substitute([j,[Fj,Cj]], IntermediateState, [j,[F1, C1]], NextState), write("El proximo estado es: "), write(NextState), nl.

substitute(_, [], _, []).
substitute(A, [A|As], B, [B|Bs]) :- substitute(A, As, B, Bs), !.
substitute(A, [X|As], B, [X|Bs]) :- substitute(A, As, B, Bs).

%:- debug.