HA$PBExportHeader$n_curva.sru
forward
global type n_curva from nonvisualobject
end type
end forward

global type n_curva from nonvisualobject autoinstantiate
end type

type variables
//constantes a y b de la ecuacion logaritmica de tipo y = a ln(x) + b que describe la curva
decimal{4} idc_a, idc_b, idc_eficiencia
Long ii_no_modulos, ii_no_dias


end variables

forward prototypes
public function decimal of_eficienciaacumulada (long ai_dias)
public function decimal of_geteficiencia ()
public function long of_setconstantes (decimal adc_a, decimal adc_b)
public function decimal of_calcularmodulos (long ai_no_dias, double ai_no_unidades, decimal adc_estandar, long ai_no_personas, long ai_minutos_turno, long ai_turnos)
public function long of_calculardias (long ai_modulos, double ai_unidades, decimal adc_estandar, long ai_personas, long ai_minutos_turno, long ai_turnos)
public function decimal of_eficiencialogaritmica (long ai_dia)
public function long of_calcular_dias_modulos (decimal adc_eficiencia, double adc_unidades, decimal adc_estandar, long ai_personas, long ai_minutos_turno, long ai_turnos)
end prototypes

public function decimal of_eficienciaacumulada (long ai_dias);/* -----------------------------------------------------------------------------------
	calcula la eficiencia acumulada en n dias, Se hace suman todas las eficiencias de 
	n dias y luego se promedian
	----------------------------------------------------------------------------------- */

long li_contador
decimal{4} ldc_suma_eficiencias = 0, ldc_eficiencia_logaritmica
decimal{4} ldc_retorno

// se hace un ciclo haciendo una sumatoria de las eficiencias diarias
for li_contador = 1 to ai_dias
	
	//la eficiencia esta dada por la ecuacion logar$$HEX1$$ed00$$ENDHEX$$tmica y = a* ln(x) + b
	ldc_eficiencia_logaritmica = (idc_a * log(li_contador)) + idc_b
	
	//se suman las eficiencias
	ldc_suma_eficiencias = ldc_suma_eficiencias + ldc_eficiencia_logaritmica
next
// se obtiene el promedio de la sumatoria (eficiencia acumulada)
ldc_retorno = ldc_suma_eficiencias/double(ai_dias)
return ldc_retorno
end function

public function decimal of_geteficiencia ();/*	--------------------------------------------------------------------------------------
	la funci$$HEX1$$f300$$ENDHEX$$n Of_GetEficiencia Retorna la ultima eficiencia calculada, 
	si no se ha calculado ninguna eficiencia retorna -1, cuando se llaman las
	funciones "calculardias" y "calcular modulos", la variable idc_eficiencia
	toma el valor de la eficiencia, con esta funci$$HEX1$$f300$$ENDHEX$$n se obtiene ese valor 
	-------------------------------------------------------------------------------------- */

if IsNull(idc_Eficiencia) Then
	Return -1
else
	Return idc_Eficiencia
End If
end function

public function long of_setconstantes (decimal adc_a, decimal adc_b);/* ------------------------------------------------------------------------------------
	asigna los valores a las constantes a y b de la ecuaci$$HEX1$$f300$$ENDHEX$$n logar$$HEX1$$ed00$$ENDHEX$$tmica y = a ln(x) + b.
	Esta ecuaci$$HEX1$$f300$$ENDHEX$$n sirve para hallar la eficiencia del m$$HEX1$$f100$$ENDHEX$$odulo seg$$HEX1$$fa00$$ENDHEX$$n la curva 
	------------------------------------------------------------------------------------ */
If IsNUll(adc_a) Or IsNUll(adc_b) Then
	Return -1
Else
	idc_a = adc_a
	idc_b = adc_b
	Return 1
End if
end function

public function decimal of_calcularmodulos (long ai_no_dias, double ai_no_unidades, decimal adc_estandar, long ai_no_personas, long ai_minutos_turno, long ai_turnos);/* ----------------------------------------------------------------------------------
	calcula el n$$HEX1$$fa00$$ENDHEX$$mero de m$$HEX1$$f300$$ENDHEX$$dulos que se necesitan para producir el pedido en n dias.
	La formula es:
	
		Modulos = minutos disponibles * eficiencia promedio * n$$HEX1$$fa00$$ENDHEX$$mero de dias
	
	donde 
		minutos disponibles = minutos turno* turnos * n$$HEX1$$fa00$$ENDHEX$$mero de personas
  	---------------------------------------------------------------------------------- */
	  
decimal{4} ldc_no_modulos
decimal{4}	ldc_minutos_disponibles,ldc_minutos_necesidad,ldc_minutos_eficiencia_promedio

// se calculan los minutos disponibles por dia
ldc_minutos_disponibles = ai_minutos_turno * ai_turnos * ai_no_personas

// se calculan los minutos necesarios para producir el estilo con eficiencia al 100 %
ldc_minutos_necesidad = ai_no_unidades*adc_estandar

//calcula la eficiencia a la que se producir$$HEX1$$ed00$$ENDHEX$$a con n m$$HEX1$$f300$$ENDHEX$$dulos
idc_eficiencia = This.Of_eficienciaAcumulada(ai_no_dias)

// se calculan los minutos necesarios para producir el estilo con la eficiencia acumulada hasta ese dia
ldc_minutos_eficiencia_promedio = ldc_minutos_necesidad / idc_eficiencia

// Se calculan los modulos necesarios para producir en esos dias el estilo
ldc_no_modulos =ldc_minutos_eficiencia_promedio / ldc_minutos_disponibles / ai_no_dias

If ldc_no_modulos < 1 And ldc_no_modulos > 0 Then
	ldc_no_modulos = 1
End IF
Return ldc_no_modulos
end function

public function long of_calculardias (long ai_modulos, double ai_unidades, decimal adc_estandar, long ai_personas, long ai_minutos_turno, long ai_turnos);/* -------------------------------------------------------------------------------------
	calcula el n$$HEX1$$fa00$$ENDHEX$$mero de dias que se demora en producir el pedido en n modulos.
	Va calculando cuantas unidades produce cada dia y las va sumando hasta que
	el n$$HEX1$$fa00$$ENDHEX$$mero de unidades acumulada sea mayor que el n$$HEX1$$fa00$$ENDHEX$$mero de unidades a producir.
	Las unidades producidas en un dia se calculan con la formula :
	
	unidades = N$$HEX1$$fa00$$ENDHEX$$mero de personas * Minutos turno * N$$HEX1$$fa00$$ENDHEX$$mero de m$$HEX1$$f300$$ENDHEX$$dulos * Eficiencia del dia / tiempo estandar
	------------------------------------------------------------------------------------- */
	
decimal{4} ldc_unidades_acumuladas

ii_no_dias = 0
ldc_unidades_acumuladas = 0
//mientras las unidades acumuladas sean menores que las unidades a producir
do while ldc_unidades_acumuladas <= ai_unidades
	ii_no_dias++
	//se calculan las unidades producidas en el dia y se le suman a las unidades acumuladas
	ldc_unidades_acumuladas += (ai_personas*ai_minutos_turno*ai_turnos*ai_modulos*Of_EficienciaLogaritmica(ii_no_dias)/adc_estandar) 
loop
//calcula la eficiencia seg$$HEX1$$fa00$$ENDHEX$$n el n$$HEX1$$fa00$$ENDHEX$$mero de dias que se demore en producir el pedido
idc_eficiencia = of_eficienciaacumulada(ii_no_dias)
return ii_no_dias


end function

public function decimal of_eficiencialogaritmica (long ai_dia);/* ------------------------------------------------------------------------------------
	calcula la eficiencia logaritmica el dia que se le pase como argumento
	------------------------------------------------------------------------------------ */
Return ((idc_a * log(ai_dia)) + idc_b)
end function

public function long of_calcular_dias_modulos (decimal adc_eficiencia, double adc_unidades, decimal adc_estandar, long ai_personas, long ai_minutos_turno, long ai_turnos);/*----------------------- FUNCION CALCULAR DIAS Y MODULOS ------------------------------------------

Esta funcion realiza el calculo de modulos y dias para llegar a una eficiencia dada con los 
parametros ingresados.
--------------------------------------------------------------------------------------------------*/
Decimal{4} ldc_eficiencias_acumuladas[], ldc_diferencia1, ldc_diferencia2

// se inicializa el numero de modulos
ii_no_modulos = 0
Do
	ii_no_modulos ++
	// se calcula el numero de dias necesarios en estos modulos
	This.of_calculardias( ii_no_modulos, adc_unidades, adc_estandar, ai_personas, ai_minutos_turno, ai_turnos )
	// se obtiene la eficiencia acumulada
	ldc_eficiencias_acumuladas[ii_no_modulos] = This.of_geteficiencia( )	
// si la eficiencia acumulada es menor que la que se quiere o el numero de dias es 1 se termina el ciclo 
Loop Until ldc_eficiencias_acumuladas[ii_no_modulos] < adc_eficiencia Or ii_no_dias = 1

// si son mas de un modulo 
If ii_no_modulos > 1 Then
	// se comparan cual de las dos eficiencias esta mas cercana
	ldc_diferencia1 = Abs(adc_eficiencia - ldc_eficiencias_acumuladas[ii_no_modulos - 1])
	ldc_diferencia2 = Abs(adc_eficiencia - ldc_eficiencias_acumuladas[ii_no_modulos])	
	If ldc_diferencia1 < ldc_diferencia2 Then
		// si la eficiencia anterior esta mas cercana se toma la eficiencia de dicha cantidad de modulos
		ii_no_modulos --
		This.of_calculardias( ii_no_modulos, adc_unidades, adc_estandar, ai_personas, ai_minutos_turno, ai_turnos )
	End If
End If

// se retorna la cantidad de modulos
return ii_no_modulos


end function

on n_curva.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_curva.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

