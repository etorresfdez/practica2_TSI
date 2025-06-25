%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 5 - Problema de planificacion de tareas
% Apartado a - Optimizacion de restricciones (COP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";

% Constantes
% enumerado con las letras asociadas a cada tarea
enum letras = {A, B, C, D, E, F, G, H, I, J};

% vector con el nombre completo de las tareas cuyos indices son las letras anteriores
array [letras] of string: nombreTareas =
  ["Montar chasis              ", "Instalar ruedas            ", "Cableado eléctrico         ",
   "Motor de fusión nuclear    ", "Tablero de control         ", "Inst. condensador de fluzo ",
   "Ajuste aerodinámico        ", "Inst. puertas de gaviota   ", "Panel de tiempo            ",
   "Impl. alg. de búsqueda heu."];

% vectores con la duracion que tarda cada personaje en realizar cada tarea
% accedemos por la letra asociada a cada tarea
array [letras] of int:  duracionMarty  = [10, 1, 4, 15, 14, 13, 7, 3, 2, 4];
array [letras] of int:  duracionDoc    = [16, 2, 3,  5,  3,  5, 6, 4, 2, 2];

int: maxAyudaBiff = 4;
enum trabajadores = {Marty, Doc};


% Variables
% asigna un trabajador a cada tarea
array [letras] of var trabajadores: trabajadorTarea;
% indica si Biff ayuda (1) o no (0) en cada tarea
array [letras] of var 0..1: ayudaBiff;
% calcula el dia de inicio de cada tarea
array [letras] of var 1..80: inicioTarea; % 80 = suma{maximo_duracion_de_cada_tarea} -1
% calcula el dia de fin de cada tarea
array [letras] of var 2..81: finTarea;    % 81 = suma{maximo_duracion_de_cada_tarea}
% dia en el que se acaban todas las tareas
var int: duracionMontaje;


% Restricciones
% buscamos minimizar la duracion del montaje, que coincide con el ultimo dia que se completa una tarea
constraint (duracionMontaje == max(finTarea));

% Biff solo puede ayudar en 4 tareas en total como maximo
% (aprovechamos que el vector ayudaBif solo contiene ceros y unos, segun lo hemos definido)
constraint (sum(ayudaBiff) <= maxAyudaBiff);

% Biff no ayuda en tareas con duracion < 3 dias, para cualquier trabajador
constraint forall(i in letras where (duracionMarty[i]< 3 /\ trabajadorTarea[i]==Marty) \/
                                    (  duracionDoc[i]< 3 /\ trabajadorTarea[i]==Doc  ))
                 (ayudaBiff[i] == 0);

% tareas predecesoras, respetamos las dependencias de tareas indicadas en el guion
constraint (inicioTarea[B] > finTarea[A]);
constraint (inicioTarea[C] > finTarea[B]);
constraint (inicioTarea[D] > finTarea[A]) /\ (inicioTarea[D] > finTarea[C]);
constraint (inicioTarea[E] > finTarea[C]);
constraint (inicioTarea[F] > finTarea[C]) /\ (inicioTarea[F] > finTarea[D]) /\ (inicioTarea[F] > finTarea[E]);
constraint (inicioTarea[G] > finTarea[C]) /\ (inicioTarea[G] > finTarea[D]);
constraint (inicioTarea[H] > finTarea[G]);
constraint (inicioTarea[I] > finTarea[F]) /\ (inicioTarea[I] > finTarea[H]);
constraint (inicioTarea[J] > finTarea[G]) /\ (inicioTarea[J] > finTarea[I]);

% establecemos el fin de la tarea segun el trabajador (Marty o Doc) y si recibe ayuda de Biff o no
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


% Problema optimización de restricciones (COP)
solve minimize duracionMontaje;

% Formato salida
output ["\(nombreTareas[t]) inicio día \(fix(inicioTarea[t])) fin día \(fix(finTarea[t])). Asignada a \(fix(trabajadorTarea[t]))"
        ++ if (fix(ayudaBiff[t]) == 1) then " con apoyo de Biff\n" else "\n" endif
          | t in letras];





