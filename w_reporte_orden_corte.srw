HA$PBExportHeader$w_reporte_orden_corte.srw
$PBExportComments$Reporte de OC, no permite imprimir
forward
global type w_reporte_orden_corte from w_preview_de_impresion
end type
type st_1 from statictext within w_reporte_orden_corte
end type
type pb_test from picturebutton within w_reporte_orden_corte
end type
type dw_raya_sesgo from datawindow within w_reporte_orden_corte
end type
end forward

global type w_reporte_orden_corte from w_preview_de_impresion
integer width = 3945
integer height = 2620
string title = "Reporte OC"
event ue_buscar ( )
event type integer ue_postopen ( )
event ue_salir ( )
st_1 st_1
pb_test pb_test
dw_raya_sesgo dw_raya_sesgo
end type
global w_reporte_orden_corte w_reporte_orden_corte

type variables
Long ii_centroConfe, ii_subcentroEstam, ii_procesoEstampa, ii_imprimir

Integer ii_nro_paginas
Long il_ordencorte

Boolean ib_permiso_imprimir = False, ib_sin_busqueda = False
end variables

forward prototypes
public function long wf_leerconstantes (readonly string as_constante, readonly string as_error)
public subroutine wf_cargarconstantes ()
public function long of_validar_extendido (long al_orden_corte)
public function integer of_valida_marca_agua (long al_orden_corte)
end prototypes

event ue_buscar();LONG ll_orden
n_cts_param lstr_parametros


//dw_reporte.settransobject(sqlca)

Open(w_parametro_corte)
//
//ii_ancho= dw_reporte.width 
//ii_alto = dw_reporte.height
//ii_posx = dw_reporte.x   
//ii_posy = dw_reporte.y 

lstr_parametros = Message.PowerObjectParm

/* Verifica que hayan parametros */
IF lstr_parametros.is_vector[1] = 'S' THEN
	ll_orden = lstr_parametros.il_vector[1]
		
	dw_reporte.Retrieve(ll_orden,ii_centroConfe, ii_subcentroEstam, ii_procesoEstampa)
	dw_reporte.GroupCalc()
	//valida que exista instrucciones de extendido, sino existe no se deja imprimir
	If dw_reporte.RowCount() > 0 Then
		of_validar_extendido(ll_orden)
	End if
	
	//cambia marca de agua
	of_valida_marca_agua(il_ordencorte)
ELSE
	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
	return 
END IF


end event

event type integer ue_postopen();/*
	FACL - 2020/01/27 - SA59815 - Se crea evento para mejorar el tiempo de espera al usuario
*/

dw_reporte.SetTransObject( gnv_recursos.of_get_transaccion_sucia() )

dw_reporte.Retrieve(il_ordencorte, gstr_info_usuario.codigo_usuario,  ii_centroConfe, ii_subcentroEstam, ii_procesoEstampa) //SA53871 - Ceiba/jjmonsal - 13-11-2015
dw_reporte.GroupCalc()

// Se carga el sesgo
dw_raya_sesgo.SetTransObject( gnv_recursos.of_get_transaccion_sucia() )
dw_raya_sesgo.Retrieve( il_ordencorte, 1 )

//valida que exista instrucciones de extendido, sino existe no se deja imprimir
If dw_reporte.RowCount() > 0 Then
	of_validar_extendido(il_ordencorte)
End if
//cambia marca de agua
of_valida_marca_agua(il_ordencorte)

If gstr_info_usuario.codigo_usuario = 'facanola' Then
	pb_test.visible = True
End If

Return 1
end event

event ue_salir();Close(This)
end event

public function long wf_leerconstantes (readonly string as_constante, readonly string as_error);/********************************************************************
SA53871 - Ceiba/jjmonsal - 13-11-2015 FunctionName : wf_leerConstantes
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes 	luo_constantes

luo_constantes = Create n_cts_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

public subroutine wf_cargarconstantes ();/********************************************************************
SA53871 - Ceiba/jjmonsal - 13-11-2015 FunctionName : wf_CargarConstantes
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
ii_centroConfe = wf_leerconstantes('CONFECCION','el centro de CONFECCION')
IF ii_centroConfe = -1 THEN RETURN 

ii_subcentroEstam = wf_leerconstantes('ESTAMPADO','el subcentro de ESTAMPADO') 
IF ii_subcentroEstam = -1 THEN RETURN 

ii_procesoEstampa = wf_leerconstantes('ESTAMPACION','el proceso de ESTAMPACION')
IF ii_procesoEstampa = -1 THEN RETURN 


end subroutine

public function long of_validar_extendido (long al_orden_corte);
Long ll_reg
String ls_expresion, ls_usuario, ls_error
Integer	li_obs_cte
uo_dsbase lds_extendido

lds_extendido = Create uo_dsbase
lds_extendido.DataObject = 'd_gr_valida_extendido_orden_corte'
lds_extendido.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//coloca marca para imprimir
ii_imprimir = 1
//consulta si existe instrucciones de extendido para la orden de corte
ll_reg = lds_extendido.Of_Retrieve(al_orden_corte)
//si no encuentra datos
If ll_reg <= 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontr$$HEX2$$f3002000$$ENDHEX$$informaci$$HEX1$$f300$$ENDHEX$$n para validar instrucciones de extendido para la orden corte ' + String(al_orden_corte))
	ii_imprimir = 0
	Return -1
//si encuentra datos
Else
	//valida estado de la orden. si es mayor a 9 no valida
	If lds_extendido.GetItemNumber(1,'estado_orden') > 9 Then
		Destroy lds_extendido
		Return 1
	End if
	
	li_obs_cte =  lds_extendido.GetItemNumber(1,'tiene_obs') 
	
	IF li_obs_cte = 0 THEN
		ii_imprimir = 0
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La Orden de Corte no tiene creadas las Observaciones, no se puede imprimir hasta que quede ingresada la informaci$$HEX1$$f300$$ENDHEX$$n por parte de liberaciones')
		Destroy lds_extendido
		Return -1
	END IF
	
	//valida si hay datos de extendido
	If lds_extendido.GetItemNumber(1,'extendido') <= 0 Then
	
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La referencia no tiene creadas las instrucciones de Extendido, se env$$HEX1$$ed00$$ENDHEX$$a correo a los t$$HEX1$$e900$$ENDHEX$$cnicos de corte, no se puede imprimir hasta que quede ingresada la informaci$$HEX1$$f300$$ENDHEX$$n')
		//asigna valor para no dejar imprimir
		ii_imprimir = 0
		ls_usuario = gstr_info_usuario.codigo_usuario
		ls_expresion = 'La orden de corte: ' + String(al_orden_corte) + ' de la referencia ' + &
				String(lds_extendido.GetItemNumber(1,'co_referencia'))  + ' - ' + &
				trim(lds_extendido.GetItemString(1,'de_referencia')) + ', no tiene creadas las instrucciones de extendido, queda la orden de corte parada hasta que se ingrese la informaci$$HEX1$$f300$$ENDHEX$$n.'
		
		//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 44 es el que pertenece a este proceso en la tabla m_usu_correo
		/*
		Declare pr_envia_correo Procedure For pr_envia_correo('No existe instrucciones de extendido', &
					:ls_expresion,44,:ls_usuario);
		Execute pr_envia_correo;
		If SQLCA.SQLCODE = -1 Then
			ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
			RollBack;
			MessageBox("Atencion", "Error enviando correo por validacion de existencia de instrucciones de extendido" + ls_error, StopSign!)
			Close pr_envia_correo;
			Destroy lds_extendido
			Return -1
		End If
		// Cierra el procedimiento almacenado declarado
		Close pr_envia_correo;
		*/
		uo_correo	lnv_correo
		lnv_correo = CREATE uo_correo  
		
		TRY
			lnv_correo.of_enviar_correo('No existe instrucciones de extendido', ls_expresion, 'instrucciones_ext')
		CATCH(Exception ex)
			Messagebox("Error", ex.getmessage())
		END TRY
		
		DESTROY lnv_correo
		Destroy lds_extendido
		Return -1
	End if
End if

Destroy lds_extendido
Return 1
end function

public function integer of_valida_marca_agua (long al_orden_corte);Long ll_n, ll_datos[], ll_cambio, ll_reg, ll_find
String ls_datos
n_cts_constantes_tela luo_constantes
n_cst_string lnv_string
uo_dsbase lds_dato

lds_dato = Create uo_dsbase
lds_dato.DataObject = 'd_gr_proc_esp_acabado_x_oc'
lds_dato.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//consulta si existe instrucciones de extendido para la orden de corte
ll_reg = lds_dato.Of_Retrieve(al_orden_corte)
If ll_reg > 0 Then

	//busca datos para saber si se le coloca marca de agua
	ls_datos = luo_constantes.of_consultar_texto("PROC_ACAB_MARCA_AGUA")
	lnv_string = CREATE n_cst_string
	lnv_string.of_convertirstring_array(ls_datos,ll_datos)
	Destroy lnv_string
	
		ll_cambio = 0
		//miraa si coloca marca de agua
	//	FOR ll_n=1 to upperbound(ll_datos[]) //Limite
	//		IF lds_dato.GetItemNumber(1,'proc_esp_acabado') = Long(ll_datos[ll_n]) THEN
			ll_find = lds_dato.Find('sw_organico = 1', 1, lds_dato.RowCount() + 1)
			IF ll_find > 0 THEN
				dw_reporte.Modify("DataWindow.BrushMode=6")
				ll_cambio = 1
			END IF
	//	NEXT
		//sino cambio nada quita la marca de agua
		If ll_cambio = 0 Then
			dw_reporte.Modify("DataWindow.BrushMode=0")
		End if
Else
	dw_reporte.Modify("DataWindow.BrushMode=0")
End if

Return 1
end function

on w_reporte_orden_corte.create
int iCurrent
call super::create
this.st_1=create st_1
this.pb_test=create pb_test
this.dw_raya_sesgo=create dw_raya_sesgo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_test
this.Control[iCurrent+3]=this.dw_raya_sesgo
end on

on w_reporte_orden_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_test)
destroy(this.dw_raya_sesgo)
end on

event open;/***********************************************************
SA53871 - Ceiba/jjmonsal - 13-11-2015 Sol: Informacion de estampado pieza en Ord Cte
Comentario: Se Modifica dct_reporte_ordencorte2.dtb_ruta_orden_corte se adiciona
el dw_procesos_estampados con el subreport creado: d_sq_gr_ficha_procesos_estampados
tambien se adicionan las constantes del proceso de Estampacion (centro 2, subcentro 8,  proceso 3)
para la lectura de constantes se adiciona: wf_CargarConstantes
Al retrieve se le adiciona las constantes recuperadas del centro de estampacion
***********************************************************/
/***********************************************************
SA53416 - Ceiba/jjmonsal - 20-02-2016
Comentario: Se modifica en el report dct_reporte_ordencorte2 el reporte 
dff_reporte_ordencorte_rayas para adicionarle en el campo tipo el dddw_m_cptos_corte
***********************************************************/
LONG 					ll_orden
STRING				ls_usuario
n_cts_param lstr_parametros


dw_reporte.SetTransObject(SQLCA)

ls_usuario = gstr_info_usuario.codigo_usuario

// FACL -  2020/01/28 - SA59815 - Se deshabilita las opciones de impresion si no esta el permiso ( ib_permiso_imprimir )
If Not ib_permiso_imprimir And IsValid( m_vista_previa_filtro ) Then
	m_vista_previa_filtro.m_vistaprevia.m_imprimir.ToolbarItemVisible = False
	m_vista_previa_filtro.m_vistaprevia.m_guardarcomo.ToolbarItemVisible = False
	
	m_vista_previa_filtro.m_vistaprevia.m_imprimir.Visible = False
	m_vista_previa_filtro.m_vistaprevia.m_guardarcomo.Visible = False
	
	m_vista_previa_filtro.m_vistaprevia.m_imprimir.Enabled = False
	m_vista_previa_filtro.m_vistaprevia.m_guardarcomo.Enabled = False
End If

wf_CargarConstantes() //SA53871 - Ceiba/jjmonsal - 13-11-2015

// FACL -  2020/01/28 - SA59815 - Solo se pide OC cuando tiene apagada la bandera sin busqueda
If Not ib_sin_busqueda Then
	Open(w_parametro_corte)
End If

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

lstr_parametros = Message.PowerObjectParm

/* Verifica que hayan parametros */
IF lstr_parametros.is_vector[1] = 'S' THEN
	il_ordencorte = lstr_parametros.il_vector[1]
	// FACL -  2020/01/28 - SA59815 - Se postea el evento para cargar la informacion	
	This.PostEvent( 'ue_postopen' )
ELSE
	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
	return -1
END IF




end event

event ue_imprimir;//se omite el script del ancestro
/*
	FACL - 2020/01/29 - SA59815 - Basado de la version anterior w_reporte_orden_corte_sin_busqueda y se ajusta a manejo de datastore
*/


Long ll_filas
Boolean lb_puede_imprimir = False
uo_dsbase lds_oc
s_base_parametros lstr_parmetros


Long li_impresion

//mira si se puede imprimir, sino tiene instrucciones de extendido no se imprime
If ii_imprimir = 1 And ib_permiso_imprimir Then
	IF gstr_info_usuario.codigo_perfil = 16 OR gstr_info_usuario.codigo_perfil = 13 OR gstr_info_usuario.codigo_perfil = 27 OR gstr_info_usuario.codigo_perfil = 17 OR gstr_info_usuario.codigo_perfil = 15 Then
		//se establece si es reimpresion o primera ves que se impresion
		lds_oc = Create uo_dsbase
		lds_oc.DataObject = 'd_gr_h_ordenes_corte'
		lds_oc.SetTransObject( SQLCA )
		ll_filas = lds_oc.Retrieve( il_ordencorte )
		
		If ll_filas > 0 Then
			li_impresion = lds_oc.GetItemNumber( 1, 'sw_impresion' )
		ElseIf ll_filas = 0 Then
			MessageBox('Advertencia','No se encontro informacion de la O.C.',Exclamation!)
			Return
		Else
			MessageBox('Advertencia','Ocurrio un error consultando la O.C.',Exclamation!)
			Return
		End If
		
		IF li_impresion > 0 THEN
	//		se trata de una reimpresion, solo pueden imprimirlo los usuarios del perfil 13
			IF gstr_info_usuario.codigo_perfil = 13 OR gstr_info_usuario.codigo_perfil = 17 OR gstr_info_usuario.codigo_perfil = 27 Then
				lb_puede_imprimir = True
			ELSE
				MessageBox('Advertencia','Solo el jefe de corte puede realizar reimpresiones de O.C.',Exclamation!)
				Return
			END IF
		ELSE
			lb_puede_imprimir = True
		END IF
		
		If lb_puede_imprimir Then
			dw_reporte.setFocus()	
	
			lstr_parmetros.hay_parametros = True
			lstr_parmetros.Any[1] = dw_reporte
			lstr_parmetros.Any[2] = dw_raya_sesgo // dw de los sesgos para identificar cuantas hojas a una sola cara se envian a imprimir
			lstr_parmetros.Entero[1] = il_ordencorte
			
			OpenWithParm(w_opciones_impresion_oc, lstr_parmetros)			
			// Se actualiza el contador de impresion
			lds_oc.SetItem( 1, 'sw_impresion', li_impresion + 1 )
			lds_oc.SetItem( 1, 'usuario', gstr_info_usuario.codigo_usuario )
			lds_oc.SetItem( 1, 'fe_actualizacion', f_fecha_servidor() )						
			If lds_oc.Update() < 0 Then
				ROLLBACK;
				Close( w_opciones_impresion_oc )
				MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error actualizando la orden de corte como impresa')
			Else
				COMMIT USING SQLCA;
			End If
		End If
		
	ELSE
		MessageBox('Advertencia','Solo estan autorizados los usuarios de Texografo, para imprimir el reporte de la orden de corte.',Exclamation!)
		Return
	END IF
End if

end event

event resize;// Se omite el script del ancestro
dw_reporte.Resize(NewWidth - dw_reporte.x - 50, NewHeight - dw_reporte.y - 50)
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_orden_corte
string tag = "dct_reporte_ordencorte2"
integer x = 14
integer y = 112
integer width = 3849
integer height = 2244
string dataobject = "dct_reporte_ordencorte19"
end type

type st_1 from statictext within w_reporte_orden_corte
integer x = 23
integer y = 32
integer width = 974
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Reporte para imprimir en Hoja Tama$$HEX1$$f100$$ENDHEX$$o Oficio"
boolean focusrectangle = false
end type

type pb_test from picturebutton within w_reporte_orden_corte
boolean visible = false
integer x = 1691
integer y = 12
integer width = 110
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Print!"
alignment htextalign = left!
end type

event clicked;


/*
s_base_parametros lstr_parmetros

lstr_parmetros.hay_parametros = True
lstr_parmetros.Any[1] = dw_reporte
lstr_parmetros.Any[2] = dw_raya_sesgo
lstr_parmetros.Entero[1] = il_ordencorte

OpenWithParm(w_opciones_impresion_oc, lstr_parmetros)
*/

// perfil de prueba con permisos de impresion
gstr_info_usuario.codigo_perfil = 13

Parent.TriggerEvent( 'ue_imprimir' )
end event

type dw_raya_sesgo from datawindow within w_reporte_orden_corte
boolean visible = false
integer x = 2638
integer y = 336
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "Sesgos"
string dataobject = "dff_reporte_ordencorte_rayas19"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

