HA$PBExportHeader$n_cst_tiempos_maq_marquillado.sru
$PBExportComments$/***********************************************************~r~nSA52689 - Ceiba/jjmonsal - 09-11-2015~r~nComentario:Reporte tiempos perdidos m$$HEX1$$e100$$ENDHEX$$quinas marquilladoras~r~n***********************************************************/
forward
global type n_cst_tiempos_maq_marquillado from uo_dsbase
end type
end forward

global type n_cst_tiempos_maq_marquillado from uo_dsbase
end type
global n_cst_tiempos_maq_marquillado n_cst_tiempos_maq_marquillado

type variables
PRIVATE:
String			is_NombreDataObjectRep
end variables

forward prototypes
public subroutine of_setnombredataobject (readonly string as_nombredataobject) throws exception
public function string of_getnombredataobject () throws exception
public function uo_dsbase of_getinformacionreporte () throws exception
public subroutine of_recuperarinformacion (readonly uo_dsbase ads_param) throws exception
public subroutine of_generarreporte (readonly uo_dsbase ads_param) throws exception
public subroutine of_asignardataobject () throws exception
end prototypes

public subroutine of_setnombredataobject (readonly string as_nombredataobject) throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 Function name: of_setnombredataobject
<DESC> Description: CAMBIAR EL Nombre Dataobject</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public 
<ARGS> </ARGS> 
<USAGE> Se cambia el Nombre Dataobject por el requerido </USAGE>
********************************************************************/	
Exception ex
ex = CREATE Exception
TRY 
	is_NombreDataObjectRep 	= as_NombreDataobject
CATCH (Throwable ex1)
	ex.setmessage( "Se presentaron problemas en la asignacion de ojetos al reporte - Set Nombre DataObject")
	THROW ex1
END TRY 
end subroutine

public function string of_getnombredataobject () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 Function name: of_getNombreDataObject
<DESC> Description: retornar Nombre Dataobject</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public 
<ARGS> </ARGS> 
<USAGE> retornar Nombre Dataobject</USAGE>
********************************************************************/	
Exception ex
ex = CREATE Exception
TRY 
	RETURN is_NombreDataObjectRep
CATCH (Throwable ex1)
	ex.setmessage( "Se presentaron problemas en la asignacion de ojetos al reporte - Set Nombre DataObject")
	THROW ex1
END TRY 
end function

public function uo_dsbase of_getinformacionreporte () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 Function name: of_getinformacionreporte
<DESC> Description: retornar datastore con la iformacion </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public 
<ARGS> </ARGS> 
<USAGE> retornar ds</USAGE>
********************************************************************/	
Exception ex
ex = create Exception
Try
	RETURN THIS	
catch( Throwable ex1 )
	Throw ex1
End try
end function

public subroutine of_recuperarinformacion (readonly uo_dsbase ads_param) throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 Function name: of_recuperarInformacion
<DESC> Description: Cargar la informacion de reporte  </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public 
<ARGS> </ARGS> 
<USAGE> Cargar set de datos </USAGE>
********************************************************************/	
Long			ll_fila,ll_turno,ll_maquina
Date			ld_fechaI, ld_fechaF
String		ls_paro
Exception 	ex
ex = create Exception

Try
	ll_fila		= ads_param.getrow()
	ll_turno		= ads_param.getItemNumber(ll_fila,"turno")
	ll_maquina	= ads_param.getItemNumber(ll_fila,"maquina")
	ls_paro		= ads_param.getItemString(ll_fila,"paro")
	ld_fechaI	= ads_param.getitemdate(ll_fila,"fecha_ini")
	ld_fechaF	= ads_param.getitemdate(ll_fila,"fecha_fin")

	THIS.of_retrieve(ll_turno,ll_maquina,ls_paro,ld_fechaI,ld_fechaF) 

catch( Throwable ex1 )
	Return 
	Throw ex1
End try
end subroutine

public subroutine of_generarreporte (readonly uo_dsbase ads_param) throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 Function name: of_generarreporte
<DESC> Description: generar el reporte  </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public 
<ARGS> </ARGS> 
<USAGE> Cargar el dataobject y recuperacion de la informacion </USAGE>
********************************************************************/	
Exception 	ex
ex 			= Create Exception
Try 
	of_setNombreDataobject('d_sq_gr_rep_tiempo_maq_marquilladora')
	of_asignarDataobject()
	of_recuperarInformacion(ads_param)	
catch( Throwable ex1 )
	ex.setmessage("Error generando el reporte, No se recupero la informaci$$HEX1$$f300$$ENDHEX$$n") 
	Throw ex1
End try
end subroutine

public subroutine of_asignardataobject () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 Function name: of_asignarDataObject
<DESC> Description: Cargar el dataobject y la transaccional </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public 
<ARGS> </ARGS> 
<USAGE> Cargar el dataobject y la transaccional </USAGE>
********************************************************************/	
Exception ex
ex = CREATE Exception
TRY 	
	THIS.DATAOBJECT= THIS.of_getNombreDataObject()
	THIS.settransobject(gnv_recursos.of_get_transaccion_sucia())
CATCH (Throwable ex1)
	ex.setmessage( "Se presentaron problemas en la asignacion de ojetos al reporte")
	THROW ex1
END TRY 
end subroutine

on n_cst_tiempos_maq_marquillado.create
call super::create
end on

on n_cst_tiempos_maq_marquillado.destroy
call super::destroy
end on

