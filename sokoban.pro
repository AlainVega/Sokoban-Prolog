% Esto es un hecho, se puede comprobar corriendo en la terminal de swi-prolog (swipl) de esta forma:
/**
 * swipl sokoban.pro
 * game(sokoban)        ---> te va a responder true.
 * game(X).             ---> te va a responder X = sokoban.
 * X.                   ---> te va responder 42 (es un easter egg de nose que serie/pelicula)
 * 
 * Documentacion de swi-prolog: https://www.swi-prolog.org/pldoc/man?section=overview
 */
game(sokoban).
% la extension que instale se llama VSC-Prolog
% podemos usar la extension .pro o .pl (esta da problemas pq vscode piensa que es perl)