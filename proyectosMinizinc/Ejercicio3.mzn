%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 3 - Problema de la tabla binaria
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";

% Constantes
int: N = 12;
set of int: tam = 1..N;

% Variables
% matriz 12x12 de ceros y unos
array [tam, tam] of var 0..1: tablero;

% Restricciones
% valores iniciales del tablero:
constraint tablero[ 1,  2] = 1;      constraint tablero[ 7,  9] = 1;
constraint tablero[ 1,  3] = 0;      constraint tablero[ 8,  1] = 1;
constraint tablero[ 1,  8] = 0;      constraint tablero[ 8,  4] = 1;
constraint tablero[ 1, 11] = 0;      constraint tablero[ 8, 11] = 0;
constraint tablero[ 2,  2] = 1;      constraint tablero[ 9,  2] = 1;
constraint tablero[ 2,  3] = 1;      constraint tablero[ 9,  9] = 0;
constraint tablero[ 2,  6] = 1;      constraint tablero[10,  8] = 0;
constraint tablero[ 3,  9] = 1;      constraint tablero[11,  1] = 1;
constraint tablero[ 3, 12] = 0;      constraint tablero[11, 12] = 1;
constraint tablero[ 4,  3] = 0;      constraint tablero[12,  2] = 1;
constraint tablero[ 4,  4] = 0;      constraint tablero[12,  4] = 1;
constraint tablero[ 4, 12] = 0;      constraint tablero[12, 11] = 0;
constraint tablero[ 5,  7] = 1;      constraint tablero[12, 10] = 0;
constraint tablero[ 5,  8] = 1;      constraint tablero[ 6, 11] = 1;
constraint tablero[ 5, 10] = 0;      constraint tablero[ 6,  7] = 1;
constraint tablero[ 6,  2] = 1;      constraint tablero[ 6,  6] = 1;
constraint tablero[ 6,  4] = 0;

% ninguna fila/columna puede ser identica a otra fila/columna
constraint forall(i, j in tam where i < j)(tablero[i, ..] != tablero[j, ..]);
constraint forall(i, j in tam where i < j)(tablero[.., i] != tablero[.., j]);

% cada fila/columna tiene el mismo número de 0s que de 1s (tendran 6 unos y 6 ceros, pues 12/2=6)
constraint forall(i in tam)(sum(j in tam)(tablero[i,j]) == (N/2));
constraint forall(j in tam)(sum(i in tam)(tablero[i,j]) == (N/2));

% ninguna fila/columna contiene 3 o mas valores consecutivos iguales
constraint forall(j in tam)(forall(i in 1..(N-2))(((tablero[i,j] + tablero[i+1,j] + tablero[i+2,j]) < 3) /\ % no pueden ser 3 unos seguidos en la misma fila
                                                  ((tablero[i,j] + tablero[i+1,j] + tablero[i+2,j]) > 0))); % no pueden ser 3 ceros seguidos en la misma fila
constraint forall(i in tam)(forall(j in 1..(N-2))(((tablero[i,j] + tablero[i,j+1] + tablero[i,j+2]) < 3) /\ % no pueden ser 3 unos seguidos en la misma columna
                                                  ((tablero[i,j] + tablero[i,j+1] + tablero[i,j+2]) > 0))); % no pueden ser 3 ceros seguidos en la misma columna
 
% Problema CSP
solve satisfy;

% Formato salida
output ["Matriz binaria completada: \n\n"] ++ 
       [show(tablero[i,j]) ++
        if j = N then "\n" else " " endif
        | i in tam, j in tam];
  


