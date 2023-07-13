# Representacion de las pistas del juego.

Una pista es la referencia de un elemento del tablero en una casilla especifica. Cuya sintaxis es:
- pista(fila, columna, elemento)

por ejemplo, definir la posicion del jugador en fila 1, columna 1 con una caja en fila 1, columna 2 y su destino en fila 1 columna 3.
```
pista(1, 1, j).
pista(1, 2, c).
pista(1, 3, x).
```

Un elemento dentro del tablero puede ser: 
- El jugador ( j )
- Una caja cualquiera ( c )
- Un destino cualquiera ( x )
- Un obstaculo cualquiera ( o )