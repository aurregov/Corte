HA$PBExportHeader$w_rep_tiempos_maq_marquillado.srw
$PBExportComments$/***********************************************************  SA52689 - Ceiba/jjmonsal - 09-11-2015  Comentario:Se adiciciona nuevo reporte Reporte tiempos perdidos m$$HEX1$$e100$$ENDHEX$$quinas marquilladoras  ***********************************************************/
forward
global type w_rep_tiempos_maq_marquillado from w_preview_de_impresion
end type
type dw_parametros from datawindow within w_rep_tiempos_maq_marquillado
end type
type cb_aceptar from commandbutton within w_rep_tiempos_maq_marquillado
end type
type cb_importar from commandbutton within w_rep_tiempos_maq_marquillado
end type
type gb_1 from groupbox within w_rep_tiempos_maq_marquillado
end type
end forward

global type w_rep_tiempos_maq_marquillado from w_preview_de_impresion
integer width = 2999
integer height = 2288
windowstate windowstate = maximized!
dw_parametros dw_parametros
cb_aceptar cb_aceptar
cb_importar cb_importar
gb_1 gb_1
end type
global w_rep_tiempos_maq_marquillado w_rep_tiempos_maq_marquillado

type variables
DataWindowChild	idwc_turno
n_cst_tiempos_maq_marquillado	inv_Rep_tiem_MaqMarqui

PRIVATE:
CONSTANT Long FALLO = -1
end variables

forward prototypes
public function string wf_leerconstantestexto (readonly string as_constante)
public subroutine wf_cargarinformaciondeturnos () throws exception
public function long wf_leerconstantes (readonly string as_constante) throws exception
public subroutine wf_validarcamposvacios () throws exception
public subroutine wf_generarreporte () throws exception
public subroutine wf_cargarinformacion () throws exception
public subroutine wf_asignardataobjectdwrep () throws exception
public subroutine wf_reset () throws exception
end prototypes

public function string wf_leerconstantestexto (readonly string as_constante);/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_leerconstantestexto
<DESC> Description: leer constantes</DESC> 
<RETURN> Long: texto, ok <LI> '' failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description </ARGS> 
<USAGE>  Cargar constantes </USAGE>
********************************************************************/
String	ls_return
n_cts_constantes_tela	luo_constantes_tela //Autoinstanciable
	
Try
	ls_return = Trim(luo_constantes_tela.of_consultar_texto(as_constante))
	IF isNull(ls_return) or trim(ls_return) = '' THEN
		Post MessageBox('Error','Ocurrio un error al momento de leer una de las constantes',StopSign!)
		Return ''
	END IF
	
	RETURN ls_return
catch( Throwable ex1 )
	Return ''
	Throw ex1
End try
end function

public subroutine wf_cargarinformaciondeturnos () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_leerconstantestexto
<DESC> Description: cargar informacion de turnos </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long: al_fila, Long: fila , Son necesarios para la recuperacion orden corte y canasta </ARGS> 
<USAGE> Cargar la informacion m_turno </USAGE>
********************************************************************/
Long			ll_fila, ll_param[]

Exception 		ex
n_cst_string 	lnv_string
ex 			= 	CREATE Exception
lnv_string 	= 	CREATE n_cst_string

lnv_string.of_convertirstring_array(wf_LeerConstantestexto('RANGO_TURNOS'),ll_param)

Try
	IF idwc_turno.Retrieve(wf_LeerConstantes('FABRICA_TELA'),wf_LeerConstantes('PLANTA_MARINILLA'),ll_param) > 0 THEN 
	Else
		ex.setmessage("Se presentaron problemas al tratar de recuperar informaci$$HEX1$$f200$$ENDHEX$$n sobre los turnos")
		Throw ex
	End If
	
catch( Throwable ex1 )
	dw_parametros.Reset()
	Throw ex1
End try
end subroutine

public function long wf_leerconstantes (readonly string as_constante) throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_leerconstantestexto
<DESC> Description: leer constantes</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar constantes</USAGE>
********************************************************************/	
Long	ll_return
n_cts_constantes_tela	luo_constantes_tela //Autoinstanciable
Try
	ll_return = luo_constantes_tela.of_consultar_numerico(as_constante)
	IF ll_return = -1 THEN
		Post MessageBox('Error','Ocurrio un error al momento de leer una de las constantes',StopSign!)
		Return -1
	END IF
	
	RETURN ll_return
catch( Throwable ex1 )
	Return -1
	Throw ex1
End try
end function

public subroutine wf_validarcamposvacios () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 - FunctionName: wf_ValidarCamposVacios
<DESC> Description: validar campos vacios</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> se valida los datos vacios </USAGE>
********************************************************************/	
Long			ll_fila
Exception 	ex
ex = create Exception

Try
	dw_parametros.AcceptText()
	ll_fila = dw_parametros.getrow()
	//Si no tiene ningun valor cargar el por defecto 
	IF IsNULL(dw_parametros.getItemNumber(ll_fila,"turno")) THEN 
		dw_parametros.SetItem(ll_fila, "turno", 0)
	END IF 
	IF IsNULL(dw_parametros.getItemNumber(ll_fila,"maquina")) THEN 
		dw_parametros.SetItem(ll_fila, "maquina", 0)
	END IF 
	IF IsNULL(dw_parametros.getItemString(ll_fila,"paro")) THEN 
		dw_parametros.SetItem(ll_fila, "paro", '')
	END IF
	
	//Las fecha deben cargadas con el valor o valor por defecto desde la vista
	IF IsNull(dw_parametros.getitemdate(ll_fila,"fecha_ini")) AND &
		NOT(IsNull(dw_parametros.getitemdate(ll_fila,"fecha_fin"))) THEN 
		ex.setmessage('Debe ingresar el campo Fecha Inicial')
		Throw ex
		RETURN
	ELSEIF NOT(IsNull(dw_parametros.getitemdate(ll_fila,"fecha_ini"))) AND &
		IsNull(dw_parametros.getitemdate(ll_fila,"fecha_fin")) THEN 
		ex.setmessage('Debe ingresar el campo Fecha Final')	
		throw ex
		RETURN
	ELSEIF IsNull(dw_parametros.getitemdate(ll_fila,"fecha_ini")) AND &
		IsNull(dw_parametros.getitemdate(ll_fila,"fecha_fin")) THEN 
		dw_parametros.SetItem(ll_fila, "fecha_ini", Date("1900-01-01"))
		dw_parametros.SetItem(ll_fila, "fecha_fin", Date("1900-01-01"))
	END IF	

		
catch( Throwable ex1 )
	Throw ex1
End try
end subroutine

public subroutine wf_generarreporte () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_GenerarReporte  
<DESC> Description: Generar Reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar Reporte en la Entidad</USAGE>
********************************************************************/	
Long								ll_filas
uo_dsbase						lds_paramReporte
Exception 						ex
lds_paramReporte				= CREATE uo_dsbase
ex									= CREATE Exception

Try
	lds_paramReporte.dataobject = dw_parametros.dataobject 
	ll_filas = dw_parametros.rowcount()
	IF dw_parametros.rowscopy(1,ll_filas,primary!,lds_paramReporte,1, Primary!) = FALLO THEN 
		ex.setmessage( "Fallo al enviar parametros para generar el reporte")
		THROW ex
	END IF
	inv_Rep_tiem_MaqMarqui.of_GenerarReporte(lds_paramReporte)
catch( Throwable ex1 )
	Throw ex1
End try
end subroutine

public subroutine wf_cargarinformacion () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_CargarInformacion  
<DESC> Description: cargar la informacion del reporte </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar Informacion </USAGE>
********************************************************************/	
Long		ll_filaI, ll_filaF
Exception	ex
ex = CREATE Exception
Try
	//Obtener el ds con la informacion del reporte 
	ll_filaI = 1
	ll_filaF = inv_Rep_tiem_MaqMarqui.of_getInformacionReporte().RowCount()
	IF inv_Rep_tiem_MaqMarqui.of_getInformacionReporte().rowscopy(ll_filaI, ll_filaF, Primary!,dw_reporte, ll_filaI, Primary!) = FALLO THEN
		ex.setmessage( "Error obteniendo la informacion del reporte ")
	END IF
Catch( Throwable ex1 )
	Throw ex1
End try
end subroutine

public subroutine wf_asignardataobjectdwrep () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_asignarDataObjectDwRep  
<DESC> Description: Generar Reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar Reporte en la Entidad</USAGE>
********************************************************************/	

Try
	dw_reporte.DataObject = inv_Rep_tiem_MaqMarqui.of_getNombreDataObject()
catch( Throwable ex1 )
	Throw ex1
End try
end subroutine

public subroutine wf_reset () throws exception;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: wf_reset  
<DESC> Description: reset Reporte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> reset Reporte en la Entidad</USAGE>
********************************************************************/	

Try
	dw_reporte.Reset()
catch( Throwable ex1 )
	Throw ex1
End try
end subroutine

on w_rep_tiempos_maq_marquillado.create
int iCurrent
call super::create
this.dw_parametros=create dw_parametros
this.cb_aceptar=create cb_aceptar
this.cb_importar=create cb_importar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parametros
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.cb_importar
this.Control[iCurrent+4]=this.gb_1
end on

on w_rep_tiempos_maq_marquillado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_parametros)
destroy(this.cb_aceptar)
destroy(this.cb_importar)
destroy(this.gb_1)
end on

event open;inv_Rep_tiem_MaqMarqui	= CREATE n_cst_tiempos_maq_marquillado
dw_parametros.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
dw_parametros.insertRow(0)
dw_parametros.getChild("turno",idwc_turno)
idwc_turno.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
try
	wf_cargarInformacionDeTurnos()
catch( Throwable ex1 )
	Return -1
	Throw ex1
End try


end event

event resize;call super::resize;dw_reporte.Resize(This.Width - 100, This.Height - 500)
end event

event ue_filtro;call super::ue_filtro;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 - ue_filtro  
<DESC> Description: abrir venatan de filtrar de un datawindows</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> abrir venatan de filtrar de un datawindows</USAGE>
********************************************************************/	
String ls_empty 
ls_empty = ''
IF ib_filtro THEN 
	SetNull(ls_empty)
	dw_reporte.SetFilter(ls_empty)
	dw_reporte.Filter()
END IF
end event

event close;call super::close;Destroy inv_Rep_tiem_MaqMarqui

end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_rep_tiempos_maq_marquillado
integer y = 396
integer height = 1344
string dataobject = "d_sq_gr_rep_tiempo_maq_marquilladora"
end type

type dw_parametros from datawindow within w_rep_tiempos_maq_marquillado
integer x = 41
integer y = 64
integer width = 2793
integer height = 280
integer taborder = 20
boolean bringtotop = true
string title = "Reporte tiempos perdidos m$$HEX1$$e100$$ENDHEX$$quinas marquilladoras"
string dataobject = "d_ex_ff_param_tiempo_maq_marquilladora"
boolean border = false
boolean livescroll = true
end type

type cb_aceptar from commandbutton within w_rep_tiempos_maq_marquillado
integer x = 2062
integer y = 232
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: cb_aceptar clicked
<DESC> Description clicked para cb_aceptar </DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> Generar reporte </USAGE>
********************************************************************/
TRY
	wf_reset()
	wf_ValidarCamposVacios()
	wf_GenerarReporte()
	wf_CargarInformacion()
CATCH (Exception ex)
	Messagebox("Error Generando Reporte Producci$$HEX1$$f300$$ENDHEX$$n por Maquina Marquilladora", ex.getmessage(), StopSign!)
END TRY
end event

type cb_importar from commandbutton within w_rep_tiempos_maq_marquillado
integer x = 2441
integer y = 232
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar"
end type

event clicked;/********************************************************************
SA52689 - Ceiba/jjmonsal - 09-11-2015 FunctionName: cb_importar event click  
<DESC> Description: Generar Importarcion del archivo plano y almacenarlo en la tabla de tiemos perdidos </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar el archivo plano en la Entidad de tiempos perdidos </USAGE>
********************************************************************/	
n_cst_importfile				lnv_svc_importfile
n_ds_t_tiempo_perdmaqmar	lds_t_tiempo_perdMaqMar

lnv_svc_importfile 		= CREATE n_cst_importfile
lds_t_tiempo_perdMaqMar = CREATE n_ds_t_tiempo_perdmaqmar

IF lnv_svc_importFile.of_importFile(lds_t_tiempo_perdMaqMar) THEN 
	lds_t_tiempo_perdMaqMar.of_cargarSQLCA()
	IF lds_t_tiempo_perdMaqMar.of_update() < 0 THEN 
		MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se presento una falla al actualizar los datos importados')
	END IF 
ELSE 
	RETURN
END IF 
end event

type gb_1 from groupbox within w_rep_tiempos_maq_marquillado
integer x = 14
integer width = 2848
integer height = 380
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

