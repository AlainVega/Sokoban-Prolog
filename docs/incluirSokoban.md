# Incluir archivo sokoban.pro a un nivel

Cada nivel necesita incluir el archivo _sokoban.pro_ para la utilizacion de predicados definidos alli. Por convencion esta directiva se situa al final de cada archivo nivel, la sintaxis es:

```
:- consult('sokoban.pro').
```

Importante: es estricamente necesario realizar esta "inclusion" ya que el archivo _sokoban.pro_ es quien realiza la solucion del nivel.