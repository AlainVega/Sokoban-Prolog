# Sokoban-Prolog
Solucion a niveles simples del juego Sokoban mediante algoritmos de planeamiento.
### ¿Que es Sokoban?
Sokoban es un juego de lógica en el que el jugador debe empujar cajas para colocarlas en destinos específicos en un almacén, utilizando un número limitado de movimientos.

Inventado en Japón por Hiroyuki Imabayashi, Sokoban significa "encargado de almacén" en japonés.

Mas informacion: https://www.sokoban.jp/ 
#### Reglas del juego 
1. El jugador al empujar una caja (que no esté bloqueada por obstáculos) se mueve con ella (la caja es muy pesada como para empujarla y no moverse con ella)
Es decir, si el jugador empuja una caja, este pasa a la posición antigua de la caja.

2. No se puede empujar 2 o más cajas a la vez.
3. No se puede “tirar” una caja, solo empujarla.
### Lenguajes y herramientas utilizadas
- Lenguaje: Prolog
## Integrantes
- Alain Vega
- Mathias Martinez
# Como probar el proyecto
Realizar los siguientes pasos en orden.
## Clonar el repositorio, e ir a la carpeta base del proyecto:
```
git clone https://github.com/AlainVega/Sokoban-Prolog.git
cd Sokoban-Prolog
```
## Instalar SWI-Prolog:
En distros basadas en ubuntu:
```
sudo apt-get update
sudo apt-get install swi-prolog
```
Mas informacion en: https://www.swi-prolog.org/download/stable
## Ejecutar el interprete SWI-Prolog con un nivel, por ejemplo:
```
swipl nivel1.pro
```
## Darle la siguiente consulta:
```
sokoban(L).
```
En L estará la solución al problema del nivel1. (importante incluir el punto final.)
# Toda la documentacion pertinente se encuentra en [/docs](/docs/) 

Nota: Repositorio para el trabajo practico final de informatica 2
