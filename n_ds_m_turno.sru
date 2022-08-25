HA$PBExportHeader$n_ds_m_turno.sru
forward
global type n_ds_m_turno from uo_dsbase
end type
end forward

global type n_ds_m_turno from uo_dsbase
string dataobject = "d_sq_gr_m_turno"
end type
global n_ds_m_turno n_ds_m_turno

forward prototypes
public function long of_getcodigoturno (readonly long al_fila)
end prototypes

public function long of_getcodigoturno (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_getCodigoTurno
<DESC> Description: permite retornar co_turno  </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar co_turno </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"co_turno")
end function

on n_ds_m_turno.create
call super::create
end on

on n_ds_m_turno.destroy
call super::destroy
end on

