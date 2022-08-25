HA$PBExportHeader$n_ds_dt_canasta_corte.sru
$PBExportComments$/***********************************************************  SA51561 - 27-07-2015 Ceiba/JJ  Comentario: entidad ds para dt_canasta_corte  ***********************************************************/
forward
global type n_ds_dt_canasta_corte from uo_dsbase
end type
end forward

global type n_ds_dt_canasta_corte from uo_dsbase
string dataobject = "d_sq_gr_dt_canasta_corte"
end type
global n_ds_dt_canasta_corte n_ds_dt_canasta_corte

forward prototypes
public function long of_getcantidaddeunidades (long al_fila)
public function long of_getreferencia (long al_fila)
end prototypes

public function long of_getcantidaddeunidades (long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: permite retornar la cantidad de ca_actual </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar ca_actual </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"ca_actual")
end function

public function long of_getreferencia (long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: permite retornar la cantidad de co_referencia </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar co_referencia </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"co_referencia")
end function

on n_ds_dt_canasta_corte.create
call super::create
end on

on n_ds_dt_canasta_corte.destroy
call super::destroy
end on

