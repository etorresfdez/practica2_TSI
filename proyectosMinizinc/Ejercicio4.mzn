%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 4 - Problema de los cuadrados
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";

% Constantes
int: x = 110;                % 4, 5, 6, 7, 8, 9, 10, 15, 30, 60, 120
int: xCuadrado = x*x;
int: max = (x-1);
set of int: POS = 1..max;

% Variables
% variable que queremos maximizar
var int: cardinalidad;
% vector con (x-1) casillas, habra (x-1) cuadrados como maximo
% en dichas casillas ponemos el valor de los numero escogidos o 0
% al final, la suma de todos los valores de este vector al cuadrado debe dar x²
array [POS] of var 0..max: S;

% Restricciones
% todos los numeros en S deben ser diferentes
constraint all_different_except_0(S);
% comenzamos probando con cuadrados de numeros mas grandes para reducir el tiempo de busqueda
constraint decreasing(S);
% imponemos que la suma de todos los elementos de S sea x²
constraint ( sum(s in POS)(pow(S[s],2)) == xCuadrado );
% cardinalidad es el numero de elementos no nulos en S, numero de cuadrados que suman x²
constraint ( cardinalidad == (max - count(S, 0)) );


% Problema optimizacion
solve maximize cardinalidad;

% Formato salida
output ["x = \(x) \nS = {"] ++ 
       ["\(fix(S[i]))" ++ if i = fix(cardinalidad) then "}" else ", " endif | i in 1..fix(cardinalidad)] ++
       ["\nCardinalidad = \(fix(cardinalidad))"] ++
       ["\nSuma de cuadrados = \(pow(x,2))"];


