HA$PBExportHeader$n_ds_t_oc_imp_bolsas.sru
$PBExportComments$/********************************************************************~r~nSASA51561 - E00487 ~r~nObjectName: t_oc_imp_bolsas~r~n<OBJECT> Object Description</OBJECT> ~r~n<USAGE> Object Usage.</USAGE>
forward
global type n_ds_t_oc_imp_bolsas from uo_dsbase
end type
end forward

global type n_ds_t_oc_imp_bolsas from uo_dsbase
string dataobject = "d_sq_gr_t_oc_imp_bolsas"
end type
global n_ds_t_oc_imp_bolsas n_ds_t_oc_imp_bolsas

type variables
Long il_NewFila
end variables

forward prototypes
public function long of_getordencorte (readonly long al_fila)
public subroutine of_setordencorte (readonly long al_fila, readonly long al_valor)
public function long of_getcanasta (readonly long al_fila)
public function long of_getturno (readonly long al_fila)
public function long of_getunidadimpresa (readonly long al_fila)
public function long of_getestilopdn (readonly long al_fila)
public subroutine of_setcanasta (readonly long al_fila, readonly long al_valor)
public subroutine of_setturno (readonly long al_fila, readonly long al_valor)
public subroutine of_setunidadimpresa (readonly long al_fila, readonly long al_valor)
public subroutine of_setestilopdn (readonly long al_fila, readonly long al_valor)
public subroutine of_setfechaactualizacion ()
public subroutine of_insertarnewrow ()
public function long of_getnumultimafila ()
public subroutine of_setdatosusuario_fechas (readonly long al_fila)
public subroutine of_setcodempleado (readonly long al_fila, readonly long al_valor)
public function long of_setcodempleado (readonly long al_fila)
end prototypes

public function long of_getordencorte (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar la Orden de corte </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"cs_orden_corte")
end function

public subroutine of_setordencorte (readonly long al_fila, readonly long al_valor);/********************************************************************
SA51561 - E00487- of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna(al_fila,al_valor)
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE>  Set Valor </USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"cs_orden_corte",al_valor)
end subroutine

public function long of_getcanasta (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar la canasta </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"cs_canasta")
end function

public function long of_getturno (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar turno </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"co_turno")
end function

public function long of_getunidadimpresa (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar unidad impresa </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"ca_unidad_impre")
end function

public function long of_getestilopdn (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar estilo </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"estilo_pdn")
end function

public subroutine of_setcanasta (readonly long al_fila, readonly long al_valor);/********************************************************************
SA51561 - E00487- of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna(al_fila,al_valor)
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> retornar la Orden de corte </USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"cs_canasta",al_valor)
end subroutine

public subroutine of_setturno (readonly long al_fila, readonly long al_valor);/********************************************************************
SA51561 - E00487- of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna(al_fila,al_valor)
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> Set Valor </USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"co_turno",al_valor)
end subroutine

public subroutine of_setunidadimpresa (readonly long al_fila, readonly long al_valor);/********************************************************************
SA51561 - E00487- of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna(al_fila,al_valor)
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> Set Valor</USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"ca_unidad_impre",al_valor)
end subroutine

public subroutine of_setestilopdn (readonly long al_fila, readonly long al_valor);/********************************************************************
SA51561 - E00487- of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna(al_fila,al_valor)
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> Set Valor </USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"estilo_pdn",al_valor)
end subroutine

public subroutine of_setfechaactualizacion ();/********************************************************************
SA51561 - E00487- of_setFechaActualizacion()
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> set valores aduitoria actualizacion  </USAGE>
********************************************************************/	
THIS.SetItem(THIS.getrow(),"fe_actualizacion",f_fecha_servidor())
end subroutine

public subroutine of_insertarnewrow ();/********************************************************************
SA51561 - E00487- of_insertarNewRow
<DESC> Description: Permite Insertar una nueva fila </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> none </ARGS> 
<USAGE> none </USAGE>
********************************************************************/	
il_NewFila = THIS.insertrow(0)
end subroutine

public function long of_getnumultimafila ();/********************************************************************
SA51561 - E00487- of_getNumUltimaFila
<DESC> Description: Permite cargar el numero de la ultima fila </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar la canasta </USAGE>
********************************************************************/	
RETURN il_NewFila
end function

public subroutine of_setdatosusuario_fechas (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_setdatosusuario_fechas()
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> set valores aduitoria  </USAGE>
********************************************************************/	
THIS.SetItem(al_Fila,"usuario",gstr_info_usuario.codigo_usuario)
THIS.SetItem(al_Fila,"hora_impresion",f_fecha_servidor())
THIS.SetItem(al_Fila,"instancia",gstr_info_usuario.instancia)
THIS.SetItem(al_Fila,"fe_creacion",f_fecha_servidor())
end subroutine

public subroutine of_setcodempleado (readonly long al_fila, readonly long al_valor);/********************************************************************
SA51561 - E00487- of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna(al_fila,al_valor)
<DESC> Description: Permite setear el dato en la dato Indicado</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila, Long : al_valor,</ARGS> 
<USAGE> Set Valor </USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"cod_empleado",al_valor)
end subroutine

public function long of_setcodempleado (readonly long al_fila);/********************************************************************
SA51561 - E00487- of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar turno </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"cod_empleado")
end function

on n_ds_t_oc_imp_bolsas.create
call super::create
end on

on n_ds_t_oc_imp_bolsas.destroy
call super::destroy
end on

event constructor;call super::constructor;il_NewFila = 0 
end event

