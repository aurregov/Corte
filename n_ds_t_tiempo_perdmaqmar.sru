HA$PBExportHeader$n_ds_t_tiempo_perdmaqmar.sru
$PBExportComments$/***********************************************************~r~nSA52689 - Ceiba/jjmonsal - 09-11-2015~r~nComentario:Reporte tiempos perdidos m$$HEX1$$e100$$ENDHEX$$quinas marquilladoras~r~n***********************************************************/
forward
global type n_ds_t_tiempo_perdmaqmar from uo_dsbase
end type
end forward

global type n_ds_t_tiempo_perdmaqmar from uo_dsbase
string dataobject = "d_sq_gr_rep_tiempo_maq_marquilladora"
end type
global n_ds_t_tiempo_perdmaqmar n_ds_t_tiempo_perdmaqmar

forward prototypes
public function long of_getnum_maq (readonly long al_fila)
public function long of_getturno (readonly long al_fila)
public function long of_getnumrepeticiones (readonly long al_fila)
public function long of_gettiempotot (readonly long al_fila)
public subroutine of_setnum_maq (readonly long al_fila, readonly long al_valor)
public function String of_getdataobject ()
public function long of_cargarsqlca ()
public function string of_getparo (readonly long al_fila)
end prototypes

public function long of_getnum_maq (readonly long al_fila);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las maquinas </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el numero de la maquina </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"num_maq")
end function

public function long of_getturno (readonly long al_fila);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion turno</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el turno </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"co_turno")
end function

public function long of_getnumrepeticiones (readonly long al_fila);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion del numero de repeticiones </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el numero de repeticiones </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"num_repeticiones")
end function

public function long of_gettiempotot (readonly long al_fila);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion del tiempo total </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el numero del tiempo total </USAGE>
********************************************************************/	
RETURN THIS.getitemnumber(al_fila,"tiempo_total")
end function

public subroutine of_setnum_maq (readonly long al_fila, readonly long al_valor);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_SetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion de las maquinas </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el numero de la maquina </USAGE>
********************************************************************/	
THIS.SetItem(al_fila,"num_maq",al_valor)
end subroutine

public function String of_getdataobject ();/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_getDataObject
<DESC> Description: Retornar DataObject</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el DataObject </USAGE>
********************************************************************/	
RETURN THIS.DataObject 
end function

public function long of_cargarsqlca ();/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_cargarSQLCA
<DESC> Description: Permite cargar la transaccional SQLCA </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> cargar la transaccional SQLCA</USAGE>
********************************************************************/	
RETURN THIS.setTransObject(SQLCA)
end function

public function string of_getparo (readonly long al_fila);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 of_GetNombreNemot$$HEX1$$e900$$ENDHEX$$cnicoColumna
<DESC> Description: Permite cargar la informacion del codigo de paro</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_fila </ARGS> 
<USAGE> retornar el codigo del paro </USAGE>
********************************************************************/	
RETURN THIS.getitemstring(al_fila,"de_paro")
end function

on n_ds_t_tiempo_perdmaqmar.create
call super::create
end on

on n_ds_t_tiempo_perdmaqmar.destroy
call super::destroy
end on

