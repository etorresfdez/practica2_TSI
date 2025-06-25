%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 1 - Problema del cambio de monedas
% Apartado d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";

% Constantes
% Distintos importes: 13, 147, 230, 299 (122233367 para 1d)
int: importe = 122233367;
% vector con el valor de las 9 monedas en notacion entera (centimos)  
set of int: POS = 1..9;
array [POS] of int: monedas = [1, 3, 5, 10, 25, 50, 100, 200, 500];

% Variable
% vector que contiene la cantidad necesaria de cada una de las 9 monedas
array [POS] of var int: cantidades;

% Restricciones
% obtenemos el importe
constraint sum(i in POS)(cantidades[i] * monedas[i]) = importe;
% todas las cantidades deben ser positivas o 0
constraint forall(i in POS)(cantidades[i] >= 0);
% imponemos completar con monedas de unidades siempre que sea posible
constraint (if (((importe div 100) mod 5) == 0)
            then (cantidades[9] == ((importe div 100) div 5))
            else (if (((importe div 100) mod 2) == 0)
                  then (cantidades[8] == ((importe div 100) div 2))
                  else (cantidades[7] == (importe div 100))
                  endif)
            endif);

% Problema de satisfaccion de restricciones
solve satisfy;

% Formato salida
output ["monedas: "] ++ ["\(fix(cantidades[i])) " | i in POS] ++
["\ntotal monedas: \(sum(i in POS)(fix(cantidades[i])))"]
