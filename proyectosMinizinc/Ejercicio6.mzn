%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elena Torres Fernandez
% TSI Practica 2 - MiniZinc
% Ejercicio 6 - Problema de conformacion de tribunales de TFG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include "globals.mzn";


% Constantes
int: nTFG = 10;
set of int: PROF = 1..9;
enum diasSemana = {Lunes, Martes, Miercoles, Jueves, Viernes};
enum departamento = {DECSAI, LSI, ICAR};
% suponemos que los 9 profesores son de estos departamentos (3 de cada)
array [PROF] of departamento: profDepartamento = [DECSAI, DECSAI, DECSAI, LSI, LSI, LSI, ICAR, ICAR, ICAR];


% Variables
% profTribunal: contiene 0, 1 o 2 para cada profesor;
% 0: si no pertenece a ningun tribunal, 1: pertenece al primero, 2: pertenece al segundo
% con esta definicion de const se tiene la restriccion "un profesor solo puede estar en un unico tribunal evaluador"
array [PROF] of var 0..2: profTribunal;
% evaluadoresTFG: contiene 0, 1 para cada TFG;
% 0: si lo evalua el tribunal1; 1: si lo evalua el tribunal2
array [1..nTFG] of var 0..1: evaluadoresTFG;
% dias de evaluacion de cada tribunal   
var diasSemana: diaEvaluacionTrib1;
var diasSemana: diaEvaluacionTrib2;


% Restricciones
% cada tribunal evalua 5 TFGs exactamente
constraint sum(evaluadoresTFG) == 5;

% cada tribunal consta de 3 profesores y un profesor solo puede estar un unico tribunal o ninugno
constraint ( count(profTribunal, 1) == 3 /\ count(profTribunal, 2) == 3 );

% los tribunales estan formados por profesores pertenecientes a departamentos diferentes
constraint ((profTribunal[1] != profTribunal[2] /\ profTribunal[1] != profTribunal[3]) \/ (profTribunal[1] == 0)) /\
           ((profTribunal[2] != profTribunal[1] /\ profTribunal[2] != profTribunal[3]) \/ (profTribunal[2] == 0)) /\
           ((profTribunal[3] != profTribunal[1] /\ profTribunal[3] != profTribunal[2]) \/ (profTribunal[3] == 0)) /\
           ((profTribunal[4] != profTribunal[5] /\ profTribunal[4] != profTribunal[6]) \/ (profTribunal[4] == 0)) /\
           ((profTribunal[5] != profTribunal[4] /\ profTribunal[5] != profTribunal[6]) \/ (profTribunal[5] == 0)) /\
           ((profTribunal[6] != profTribunal[4] /\ profTribunal[6] != profTribunal[5]) \/ (profTribunal[6] == 0)) /\
           ((profTribunal[7] != profTribunal[8] /\ profTribunal[7] != profTribunal[9]) \/ (profTribunal[7] == 0)) /\
           ((profTribunal[8] != profTribunal[7] /\ profTribunal[8] != profTribunal[9]) \/ (profTribunal[8] == 0)) /\
           ((profTribunal[9] != profTribunal[7] /\ profTribunal[9] != profTribunal[8]) \/ (profTribunal[9] == 0));

% dia de evaluacion diferente para cada tribunal
constraint (diaEvaluacionTrib1 != diaEvaluacionTrib2);

% restricciones dias de la semana segun agenda de los profesores
% el profesor 1 solo podria participar en el tribunal el martes
constraint (diaEvaluacionTrib1 == Martes /\ profTribunal[1] == 1) \/
           (diaEvaluacionTrib2 == Martes /\ profTribunal[1] == 2) \/
           (profTribunal[1] == 0);
% los profesores 2 y 3 solo pueden lunes, miercoles y viernes
constraint (diaEvaluacionTrib1 == Lunes     /\ profTribunal[2] == 1) \/
           (diaEvaluacionTrib1 == Miercoles /\ profTribunal[2] == 1) \/
           (diaEvaluacionTrib1 == Viernes   /\ profTribunal[2] == 1) \/
           (diaEvaluacionTrib2 == Lunes     /\ profTribunal[2] == 2) \/
           (diaEvaluacionTrib2 == Miercoles /\ profTribunal[2] == 2) \/
           (diaEvaluacionTrib2 == Viernes   /\ profTribunal[2] == 2) \/
           (profTribunal[2] == 0);
constraint (diaEvaluacionTrib1 == Lunes     /\ profTribunal[3] == 1) \/
           (diaEvaluacionTrib1 == Miercoles /\ profTribunal[3] == 1) \/
           (diaEvaluacionTrib1 == Viernes   /\ profTribunal[3] == 1) \/
           (diaEvaluacionTrib2 == Lunes     /\ profTribunal[3] == 2) \/
           (diaEvaluacionTrib2 == Miercoles /\ profTribunal[3] == 2) \/
           (diaEvaluacionTrib2 == Viernes   /\ profTribunal[3] == 2) \/
           (profTribunal[3] == 0);
% el profesor 4 solo miercoles y jueves
constraint (diaEvaluacionTrib1 == Miercoles /\ profTribunal[4] == 1) \/
           (diaEvaluacionTrib1 == Jueves    /\ profTribunal[4] == 1) \/
           (diaEvaluacionTrib2 == Miercoles /\ profTribunal[4] == 2) \/
           (diaEvaluacionTrib2 == Jueves    /\ profTribunal[4] == 2) \/
           (profTribunal[4] == 0);
% el profesor 5 solo lunes y jueves
constraint (diaEvaluacionTrib1 == Lunes  /\ profTribunal[5] == 1) \/
           (diaEvaluacionTrib1 == Jueves /\ profTribunal[5] == 1) \/
           (diaEvaluacionTrib2 == Lunes  /\ profTribunal[5] == 2) \/
           (diaEvaluacionTrib2 == Jueves /\ profTribunal[5] == 2) \/
           (profTribunal[5] == 0);
% el profesor 6 es el unico disponible todos los dias ( no ponemos restricciones)
% el profesor 7 solo el viernes
constraint (diaEvaluacionTrib1 == Viernes /\ profTribunal[7] == 1) \/
           (diaEvaluacionTrib2 == Viernes /\ profTribunal[7] == 2) \/
           (profTribunal[7] == 0);
% los profesores 8 y 9 estan disponibles todos los dias menos el miercoles
constraint (diaEvaluacionTrib1 != Miercoles /\ profTribunal[8] == 1) \/
           (diaEvaluacionTrib2 != Miercoles /\ profTribunal[8] == 2) \/
           (profTribunal[8] == 0);
constraint (diaEvaluacionTrib1 != Miercoles /\ profTribunal[9] == 1) \/
           (diaEvaluacionTrib2 != Miercoles /\ profTribunal[9] == 2) \/
           (profTribunal[9] == 0);

% restricciones segun profesores tutores
constraint (evaluadoresTFG[1]  != 0 \/ profTribunal[2] != 1) /\
           (evaluadoresTFG[1]  != 1 \/ profTribunal[2] != 2);
constraint (evaluadoresTFG[10] != 0 \/ profTribunal[2] != 1) /\
           (evaluadoresTFG[10] != 1 \/ profTribunal[2] != 2);
constraint (evaluadoresTFG[2]  != 0 \/ profTribunal[5] != 1) /\
           (evaluadoresTFG[2]  != 1 \/ profTribunal[5] != 2);
constraint (evaluadoresTFG[3]  != 0 \/ profTribunal[7] != 1) /\
           (evaluadoresTFG[3]  != 1 \/ profTribunal[7] != 2);
constraint (evaluadoresTFG[3]  != 0 \/ profTribunal[6] != 1) /\
           (evaluadoresTFG[3]  != 1 \/ profTribunal[6] != 2);
constraint (evaluadoresTFG[7]  != 0 \/ profTribunal[8] != 1) /\
           (evaluadoresTFG[7]  != 1 \/ profTribunal[8] != 2);


% Problema de satisfaccion de restricciones
solve satisfy;

% Formato salida
output ["Tribunal 1: "] ++
       ["Prof\(p) (\(fix(profDepartamento[p]))), "           
          | p in PROF where fix(profTribunal[p]) == 1] ++
       ["Día: \(fix(diaEvaluacionTrib1)).\n"] ++
       ["TFGs a evaluar: "] ++
       ["\(t), "                                                 
          | t in [t | t in 1..nTFG where fix(evaluadoresTFG[t]) == 0][1..4]] ++
       ["\(t)."                                                 
          | t in [t | t in 1..nTFG where fix(evaluadoresTFG[t]) == 0][5..5]] ++
          
       ["\n\nTribunal 2: "] ++
       ["Prof\(p) (\(fix(profDepartamento[p]))), "           
          | p in PROF where fix(profTribunal[p]) == 2] ++
       ["Día: \(fix(diaEvaluacionTrib2)).\n"] ++
       ["TFGs a evaluar: "] ++
       ["\(t), "                                               
          | t in [t | t in 1..nTFG where fix(evaluadoresTFG[t]) == 1][1..4]] ++
       ["\(t)."                                                 
          | t in [t | t in 1..nTFG where fix(evaluadoresTFG[t]) == 1][5..5]];




