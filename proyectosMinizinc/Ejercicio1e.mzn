%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 1 - Problema del cambio de monedas
% Apartado e: Codificacion flotante
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constantes
% Distintos importes: 0.13, 1.47, 2.30, 2.99
float: importe = 0.13;
% vector con el valor de las 9 monedas en notacion flotante
set of int: POS = 1..9;
array [POS] of float: monedas = [0.01, 0.03, 0.05, 0.1, 0.25, 0.5, 1, 2, 5];

% Variable
% vector que contiene la cantidad necesaria de cada una de las 9 monedas
array [POS] of var float: cantidades;

% Restricciones
% obtenemos el importe
constraint sum(i in POS)(cantidades[i] * monedas[i]) = importe;
% todas las cantidades deben ser positivas o 0
constraint forall(i in POS)(cantidades[i] >= 0);


% Problema de satisfaccion de restricciones
solve satisfy;

% Formato salida
output ["monedas: "] ++ ["\(fix(cantidades[i])) " | i in POS] ++
["\ntotal monedas: \(sum(i in POS)(fix(cantidades[i])))"]
