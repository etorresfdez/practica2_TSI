%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 2 - Puzzle logico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";

% Constantes
% enumerado con los nombres de las personas involucradas
enum NOMBRES = {Lucia, Sofia, Juan, Cristina, Claudia, Pablo, Marcos, Jose, Marta, Pedro};
% enumerado con las ciudades de las que provienen las parejas
enum CIUDADES = {Madrid, Barcelona, Sevilla, Lyon, Parma};

% Variables
% asocia un anio de casados (num del 1 al 30) a cada persona, accediendo por su nombre
array [NOMBRES]  of var 1..30: nombresAnios;
% asocia un anio de casados (num del 1 al 30) a cada ciudad, accediendo por la ciudad
array [CIUDADES] of var 1..30: ciudadesAnios;


% Restricciones generales
% ninguna pareja lleva casada los mismos años
constraint alldifferent(ciudadesAnios);
% por cada año de casados en ciudades, hay exactamente dos valores en nombresAnios con ese valor
constraint forall(i in CIUDADES)(count(nombresAnios, ciudadesAnios[i]) == 2);
% las personas casadas tendran el mismo valor en el vector nombresAnios, correspondiente a los anios
% que lleven casadas y ese numero se repetira en la posicion del vector ciudadesAnios que nos indique 
% su ciudad de procedencia


% Restricciones adicionales segun el enunciado
% R1:
% Sofia no lleva casada tanto tiempo como Jose o los de Barcelona,
constraint (nombresAnios[Sofia] < nombresAnios[Jose]);
constraint (nombresAnios[Sofia] < ciudadesAnios[Barcelona]);
% pero si mas que Marcos o los de Madrid
constraint (nombresAnios[Sofia] > nombresAnios[Marcos]);
constraint (nombresAnios[Sofia] > ciudadesAnios[Madrid]);

% R2
% Cristina lleva casada el doble de tiempo que los de Sevilla
constraint (nombresAnios[Cristina] == (ciudadesAnios[Sevilla]*2));
% pero solo la mitad que Pablo
constraint ((2*nombresAnios[Cristina]) == nombresAnios[Pablo]);

% R3:
% Los de Parma llevan casados diez anios mas que Marta
constraint (ciudadesAnios[Parma] == (nombresAnios[Marta]+10));
% y diez anios menos que Juan
constraint ((ciudadesAnios[Parma]+10) == nombresAnios[Juan]);

% R4:
% Marcos y Claudia llevan los mismos anios casados, luego son pareja
constraint (nombresAnios[Marcos] == nombresAnios[Claudia]);
% Llevan 25 anios menos de casados que los de Lyon
constraint (nombresAnios[Marcos] == (ciudadesAnios[Lyon]-25));
% Los de Lyon llevan 30 anios casados y son los que más llevan
constraint (ciudadesAnios[Lyon] == 30);
constraint (max(ciudadesAnios)  == 30);

% R5:
% Ni Lucia ni los de Madrid son los que llevan casados menos tiempo
constraint (min(ciudadesAnios) != ciudadesAnios[Madrid]);
constraint (min(ciudadesAnios) != nombresAnios[Lucia]);

% R6:
% Pedro lleva 25 anios casado
constraint (nombresAnios[Pedro] == 25);


% Problema CSP
solve satisfy;

% Formato salida
output ["\(c): \(p1) y \(p2) \(fix(ciudadesAnios[c])) años\n"
        | c in CIUDADES,
          p1 in NOMBRES,
          p2 in NOMBRES where ( p1 < p2 /\
                                fix(ciudadesAnios[c]) == fix(nombresAnios[p1]) /\
                                fix(ciudadesAnios[c]) == fix(nombresAnios[p2]))];



