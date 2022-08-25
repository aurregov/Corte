HA$PBExportHeader$n_cst_pdn_maq_marquillado.sru
$PBExportComments$/***********************************************************  SA53142 - Ceiba/JJ - 05-08-2015  Comentario: Entidad para controlar el Reporte Produccion por Maquina Marquilladora  ***********************************************************/
forward
global type n_cst_pdn_maq_marquillado from uo_dsbase
end type
end forward

global type n_cst_pdn_maq_marquillado from uo_dsbase
string dataobject = "d_sq_gr_rep_pdn_x_maq_marquilladora"
end type
global n_cst_pdn_maq_marquillado n_cst_pdn_maq_marquillado

type variables
String	is_NombreDataObjectRep

PRIVATE:
CONSTANT Long GENERAL = 1
end variables

forward prototypes
public subroutine of_generarreporte (readonly uo_dsbase ads_param) throws exception
public subroutine of_recuperarinformacion (readonly uo_dsbase ads_param) throws exception
public function uo_dsbase of_getinformacionreporte () throws exception
public function string of_getnombredataobjectrep () throws exception
public subroutine of_asignardataobject (readonly long al_parametro) throws exception
end prototypes

public subroutine of_generarreporte (readonly uo_dsbase ads_param) throws exception;/********************************************************************
SA53142 - of_generarReporte Ceiba/JJ - 05-08-2015
<DESC> Description: Generar reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Generar Reporte</USAGE>
********************************************************************/	
Exception 	ex
ex 			= create Exception
Try 
	of_asignarDataobject(ads_param.GetItemNumber(1,"swrepgeneral"))
	of_recuperarInformacion(ads_param)	
catch( Throwable ex1 )
	ex.setmessage("Error generando el reporte, No se recupero la informaci$$HEX1$$f300$$ENDHEX$$n") 
	Throw ex1
End try
end subroutine

public subroutine of_recuperarinformacion (readonly uo_dsbase ads_param) throws exception;/********************************************************************
SA53142 - of_RecuperarInformacion	Ceiba/JJ - 05-08-2015
<DESC> Description: Generar reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Generar Reporte</USAGE>
********************************************************************/	
Long			ll_fila,ll_bolsa,ll_oc,ll_turno,ll_estilopdn
String		ls_usuario
Date			ld_fechaI, ld_fechaF
Exception 	ex
ex = create Exception

Try
	ll_fila		= ads_param.getrow()
	ll_bolsa		= ads_param.getItemNumber(ll_fila,"bolsa")
	ls_usuario	= ads_param.getItemString(ll_fila,"usuario") 
	ll_oc			= ads_param.getItemNumber(ll_fila,"orden_corte")
	ll_turno		= ads_param.getItemNumber(ll_fila,"turno")
	ll_estilopdn= ads_param.getItemNumber(ll_fila,"estilo_pdn")
	ld_fechaI	= ads_param.getitemdate(ll_fila,"fecha_ini")
	ld_fechaF	= ads_param.getitemdate(ll_fila,"fecha_fin")

	THIS.OF_RETRieve(ll_oc,ll_bolsa,ls_usuario,ll_turno,ll_estilopdn,ld_fechaI,ld_fechaF) 

catch( Throwable ex1 )
	Return 
	Throw ex1
End try
end subroutine

public function uo_dsbase of_getinformacionreporte () throws exception;/********************************************************************
SA53142 - of_getinformacionreporte Ceiba/JJ - 05-08-2015
<DESC> Description: Generar reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Generar Reporte</USAGE>
********************************************************************/	
Exception ex
ex = create Exception
Try
	RETURN THIS	
catch( Throwable ex1 )
	Throw ex1
End try
end function

public function string of_getnombredataobjectrep () throws exception;/********************************************************************
SA53142 - of_getNombreDataObjectRep Ceiba/JJ - 05-08-2015
<DESC> Description: Generar reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Generar Reporte</USAGE>
********************************************************************/	
Exception ex
ex = create Exception
Try
	RETURN is_NombreDataObjectRep	
catch( Throwable ex1 )
	Throw ex1
End try
end function

public subroutine of_asignardataobject (readonly long al_parametro) throws exception;/********************************************************************
SA53142 - of_asignardataobject  Ceiba/JJ - 05-08-2015
<DESC> Description: Asignar Dataobject</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar Dataobject segun sea general o no</USAGE>
********************************************************************/	
Exception ex
ex = CREATE Exception
TRY 
	IF al_parametro = GENERAL  THEN
		THIS.DATAOBJECT= "d_sq_gr_rep_pdn_x_maq_marquilladora_gen"
	ELSE //GENERICO
		THIS.DATAOBJECT= "d_sq_gr_rep_pdn_x_maq_marquilladora"
	END IF
	is_NombreDataObjectRep = THIS.DataObject
	THIS.settransobject(gnv_recursos.of_get_transaccion_sucia())
CATCH (Throwable ex1)
	ex.setmessage( "Se presentaron problemas en la asignacion de ojetos al reporte")
	THROW ex1
END TRY 
end subroutine

on n_cst_pdn_maq_marquillado.create
call super::create
end on

on n_cst_pdn_maq_marquillado.destroy
call super::destroy
end on

