%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 5 - Problema de planificación de tareas
% Apartado b - Satisfacción de restricciones (CSP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";

% Constantes
enum letras = {A, B, C, D, E, F, G, H, I, J};

array [letras] of string: nombreTareas =
  ["Montar chasis              ", "Instalar ruedas            ", "Cableado eléctrico         ",
   "Motor de fusión nuclear    ", "Tablero de control         ", "Inst. condensador de fluzo ",
   "Ajuste aerodinámico        ", "Inst. puertas de gaviota   ", "Panel de tiempo            ",
   "Impl. alg. de búsqueda heu."];

% accedemos por la letra asociada a cada tarea
array [letras] of int:  duracionMarty  = [10, 1, 4, 15, 14, 13, 7, 3, 2, 4];
array [letras] of int:  duracionDoc    = [16, 2, 3,  5,  3,  5, 6, 4, 2, 2];

int: maxAyudaBiff = 4;
enum trabajadores = {Marty, Doc};

% duracion de montaje minima encontrada
int: duracionMontaje = 26;


% Variables
array [letras] of var trabajadores: trabajadorTarea;
array [letras] of var 0..1: ayudaBiff;
array [letras] of var 1..80: inicioTarea; % 80 = suma{maximo_duracion_de_cada_tarea} -1
array [letras] of var 2..81: finTarea;    % 81 = suma{maximo_duracion_de_cada_tarea}


% Restricciones
% buscamos minimizar la duración del montaje, que coincide con el último día que se completa una tarea
constraint (duracionMontaje == max(finTarea));

% Biff solo puede ayudar en 4 tareas en total
constraint (sum(ayudaBiff) <= maxAyudaBiff);

% Biff no ayuda en tareas con duracion < 3 dias
constraint forall(i in letras where (duracionMarty[i]< 3 /\ trabajadorTarea[i]==Marty) \/
                                    (  duracionDoc[i]< 3 /\ trabajadorTarea[i]==Doc  ))
                 (ayudaBiff[i] == 0);

% tareas predecesoras
constraint (inicioTarea[B] > finTarea[A]);
constraint (inicioTarea[C] > finTarea[B]);
constraint (inicioTarea[D] > finTarea[A]) /\ (inicioTarea[D] > finTarea[C]);
constraint (inicioTarea[E] > finTarea[C]);
constraint (inicioTarea[F] > finTarea[C]) /\ (inicioTarea[F] > finTarea[D]) /\ (inicioTarea[F] > finTarea[E]);
constraint (inicioTarea[G] > finTarea[C]) /\ (inicioTarea[G] > finTarea[D]);
constraint (inicioTarea[H] > finTarea[G]);
constraint (inicioTarea[I] > finTarea[F]) /\ (inicioTarea[I] > finTarea[H]);
constraint (inicioTarea[J] > finTarea[G]) /\ (inicioTarea[J] > finTarea[I]);

% establecemos el fin de la tarea segun el trabajador (Marty o Doc) y si recibe ayuda o no
constraint forall(i in letras where (trabajadorTarea[i]==Marty /\ ayudaBiff[i]==0))
                 (finTarea[i] == inicioTarea[i] + duracionMarty[i] - 1);
constraint forall(i in letras where (trabajadorTarea[i]==Marty /\ ayudaBiff[i]==1 /\ (i==A \/ i==C \/ i==H)))
                 (finTarea[i] == inicioTarea[i] + duracionMarty[i] - 3);
constraint forall(i in letras where (trabajadorTarea[i]==Marty /\ ayudaBiff[i]==1 /\ i!=A /\ i!=C /\ i!=H))
                 (finTarea[i] == inicioTarea[i] + duracionMarty[i] - 2);
                 
constraint forall(i in letras where (trabajadorTarea[i]==Doc /\ ayudaBiff[i]==0))
                 (finTarea[i] == inicioTarea[i] + duracionDoc[i] - 1);
constraint forall(i in letras where (trabajadorTarea[i]==Doc /\ ayudaBiff[i]==1 /\ (i==A \/ i==C \/ i==H)))
                 (finTarea[i] == inicioTarea[i] + duracionDoc[i] - 3);
constraint forall(i in letras where (trabajadorTarea[i]==Doc /\ ayudaBiff[i]==1 /\ i!=A /\ i!=C /\ i!=H))
                 (finTarea[i] == inicioTarea[i] + duracionDoc[i] - 2);

% un mismo trabajador no puede hacer tareas a la vez
constraint forall(t1 in letras, t2 in letras where t1 < t2)          % para todo par de tareas diferentes
                 ((trabajadorTarea[t1] != trabajadorTarea[t2]) \/    % o las realizan dos trabajadores diferentes
                  (inicioTarea[t2] > finTarea[t1]) \/                % o la t2 empieza después de la t1
                  (inicioTarea[t1] > finTarea[t2]));                 % o la t1 empieza después de la t2


% Problema satisfacción de restricciones (CSP)
solve satisfy;

% Formato salida
output ["\(nombreTareas[t]) inicio día \(fix(inicioTarea[t])) fin día \(fix(finTarea[t])). Asignada a \(fix(trabajadorTarea[t]))"
        ++ if (fix(ayudaBiff[t]) == 1) then " con apoyo de Biff\n" else "\n" endif
          | t in letras];





