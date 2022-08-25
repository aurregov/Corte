HA$PBExportHeader$w_filtro_liberacion.srw
forward
global type w_filtro_liberacion from window
end type
type cb_limpiar from commandbutton within w_filtro_liberacion
end type
type cb_salir from commandbutton within w_filtro_liberacion
end type
type cb_aceptar from commandbutton within w_filtro_liberacion
end type
type dw_criterio from datawindow within w_filtro_liberacion
end type
type gb_1 from groupbox within w_filtro_liberacion
end type
end forward

global type w_filtro_liberacion from window
integer width = 1641
integer height = 1624
boolean titlebar = true
string title = "Filtro Liberaci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_limpiar cb_limpiar
cb_salir cb_salir
cb_aceptar cb_aceptar
dw_criterio dw_criterio
gb_1 gb_1
end type
global w_filtro_liberacion w_filtro_liberacion

type variables
uo_calendario ipo_calendario
n_cst_ole_calendario ipo_calendario_ole 
DataWindowChild dwc_fabrica_proceso, dwc_planta_proceso
end variables

on w_filtro_liberacion.create
this.cb_limpiar=create cb_limpiar
this.cb_salir=create cb_salir
this.cb_aceptar=create cb_aceptar
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.Control[]={this.cb_limpiar,&
this.cb_salir,&
this.cb_aceptar,&
this.dw_criterio,&
this.gb_1}
end on

on w_filtro_liberacion.destroy
destroy(this.cb_limpiar)
destroy(this.cb_salir)
destroy(this.cb_aceptar)
destroy(this.dw_criterio)
destroy(this.gb_1)
end on

event open;//IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
//	HALT Close
//END IF


This.Center = True
dw_criterio.SetTransObject(sqlca)
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
dw_criterio.GetChild("ai_fabrica_proceso", dwc_fabrica_proceso)
dwc_fabrica_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

dw_criterio.GetChild("ai_planta_proceso", dwc_planta_proceso)
dwc_planta_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia())


dwc_fabrica_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ))
dwc_planta_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ))
dwc_fabrica_proceso.Retrieve()
dwc_planta_proceso.Retrieve()



OpenUserObject(ipo_calendario)
ipo_calendario.hide( ) 

end event

event closequery;CloseUserObject(ipo_calendario) 
end event

type cb_limpiar from commandbutton within w_filtro_liberacion
integer x = 1079
integer y = 1288
integer width = 398
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar Criterios"
end type

event clicked;dw_criterio.Reset()
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
end event

type cb_salir from commandbutton within w_filtro_liberacion
integer x = 663
integer y = 1288
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;close(Parent)
end event

type cb_aceptar from commandbutton within w_filtro_liberacion
integer x = 247
integer y = 1288
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;//evento para desplegar los criterios de busqueda para liberar ya sea por demanada o por proyeccion
//segun criterio del usuario
//jcrm
//marzo 12 de 2008
Long li_tipo, li_fab, li_lin,  li_talla, li_marca, li_fabrica_proceso,li_planta_proceso
Long ll_ref, ll_ordenpd_pt, ll_cliente, ll_color
String ls_po, ls_marca
Date ld_fecha_ini, ld_fecha_fin
s_base_parametros lstr_parametros

dw_criterio.AcceptText()

//se cargan los criterios seleccinados por el usuario
li_fab 			= dw_criterio.GetItemNumber(1,'co_fabrica')
li_lin 			= dw_criterio.GetItemNumber(1,'co_linea')
ll_ref 			= dw_criterio.GetItemNumber(1,'co_referencia')
ll_ordenpd_pt	= dw_criterio.GetItemNumber(1,'cs_ordenpd_pt')
ll_color 		= dw_criterio.GetItemNumber(1,'co_color')
li_talla 		= dw_criterio.GetItemNumber(1,'co_talla')
ls_po  			= dw_criterio.GetItemString(1,'po')
ll_cliente		= dw_criterio.GetItemNumber(1,'co_cliente')
//li_marca 		= dw_criterio.GetItemNumber(1,'co_marca')
ls_marca 		= dw_criterio.GetItemString(1,'co_marca')
ld_fecha_ini	= dw_criterio.GetItemDate(1,'fecha_ini')
ld_fecha_fin	= dw_criterio.GetItemDate(1,'fecha_fin')
li_fabrica_proceso= dw_criterio.GetItemNumber(1,'ai_fabrica_proceso')
li_planta_proceso	= dw_criterio.GetItemNumber(1,'ai_planta_proceso')


////se verifica que exista al menos algun criterio de busqueda
li_tipo = dw_criterio.GetItemNUmber(1,'lib_demanda')
IF li_tipo = 1 THEN 
IF IsNull(li_fab) & 
   AND  IsNull(li_lin) &
	AND IsNull(ll_ref) &
	AND IsNull(ll_ordenpd_pt) &
	AND IsNull(ll_color) &
	AND IsNull(li_talla) &
	AND IsNull(ls_po) &
	AND IsNull(ll_cliente) &
	AND (IsNull(li_marca) OR trim(ls_marca) = '') &
	AND IsNull(ld_fecha_ini) &
	AND IsNull(ld_fecha_fin) THEN
	MessageBox('Advertencia','Debe ingresar algun criterio para que el proceso pueda ajecutarse',StopSign!)
	Return
END IF
END IF

//se inicializan las variables en caso de estar nulas
IF IsNull(li_fab) THEN li_fab = 0
IF IsNull(li_lin) THEN li_lin = 0
IF IsNull(ll_ref) THEN ll_ref = 0
IF IsNull(ll_ordenpd_pt) THEN ll_ordenpd_pt = 0
IF IsNull(ll_color) THEN ll_color = 0
IF IsNull(li_talla) THEN li_talla = 0
IF IsNull(ls_po) THEN ls_po = ''
IF IsNull(ll_cliente) THEN ll_cliente = 0
IF (IsNull(ls_marca) OR trim(ls_marca) = '') THEN ls_marca = ''
IF IsNull(ld_fecha_ini) THEN ld_fecha_ini = Date("01-01-1900")
IF IsNull(ld_fecha_fin) THEN ld_fecha_fin = Date("01-01-1900")
IF IsNull(li_fabrica_proceso) THEN  li_fabrica_proceso = 0
IF IsNull(li_planta_proceso) THEN li_planta_proceso = 0

//se llena la estructura. 
lstr_parametros.entero[2] = li_fab
lstr_parametros.entero[3] = li_lin
lstr_parametros.entero[4] = ll_ref
lstr_parametros.entero[5] = ll_ordenpd_pt
lstr_parametros.entero[6] = ll_color
lstr_parametros.entero[7] = li_talla
lstr_parametros.cadena[1] = ls_po
lstr_parametros.entero[8] = ll_cliente
//lstr_parametros.entero[9] = li_marca
lstr_parametros.cadena[2] = ls_marca
lstr_parametros.fecha[1]  = ld_fecha_ini
lstr_parametros.fecha[2]  = ld_fecha_fin
lstr_parametros.entero[9] = li_fabrica_proceso
lstr_parametros.entero[10] = li_planta_proceso

////se determina dependiendo de lo seleccionado por el usuario la ventana que se tiene que abrir.
//li_tipo = dw_criterio.GetItemNUmber(1,'lib_demanda')
//IF IsNull(li_tipo) THEN li_tipo = 0
//
//IF li_tipo = 0 THEN
//	li_tipo = dw_criterio.GetItemNUmber(1,'lib_proyeccion')
//	IF li_tipo = 0 OR IsNull(li_tipo) THEN
//		MessageBox('Advertencia','Se debe especificar si la liberaci$$HEX1$$f300$$ENDHEX$$n es por demanda o proyecci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
//	ELSE
//		lstr_parametros.hay_parametros = True
//		lstr_parametros.entero[1] = li_tipo
//		OpenSheetWithParm ( w_reporte_criticas_liberacion, lstr_parametros,w_principal,2, Original! )
//	END IF
//ELSE
	lstr_parametros.hay_parametros = True
	lstr_parametros.entero[1] = 1
	//OpenSheetWithParm ( w_inicial_liberacion_semiautomatica, lstr_parametros,w_principal, 2, Original! )
	CloseWithReturn ( Parent, lstr_parametros )
	
	//OpenSheetWithParm ( w_liberacion_semiautomatica, lstr_parametros,w_principal, 2, Original! )
//END IF






end event

type dw_criterio from datawindow within w_filtro_liberacion
integer x = 82
integer y = 56
integer width = 1467
integer height = 1132
integer taborder = 10
string title = "none"
string dataobject = "dff_filtro_liberacion"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_marca, li_fab, li_lin, li_marca_prn
String ls_descripcion, ls_marca_prn
Long ll_cli, ll_reftel, ll_ref , ll_color
n_cts_descripciones luo_descripcion

choose case dwo.name
	case 'lib_proyeccion'
		li_marca = Long(Data)
		If li_marca = 1 Then
			This.SetItem(1,'lib_demanda',0)
		End if
	case 'lib_demanda'	
		li_marca = Long(Data)
		If li_marca = 1 Then
			This.SetItem(1,'lib_proyeccion',0)
		End if
	case 'co_fabrica'
		li_fab = Long(Data)
		ls_descripcion = luo_descripcion.of_fabrica(li_fab)
		If ls_descripcion = '' Then
			MessageBox('Error','Verifique la Fabrica.')
			Return 2
		End if
		This.SetItem(1,'de_fabrica',ls_descripcion)
		
	case 'co_linea'
		li_lin = Long(Data)
		ls_descripcion = luo_descripcion.of_linea(li_lin)
		If ls_descripcion = '' Then
			MessageBox('Error','Verifique la l$$HEX1$$ed00$$ENDHEX$$nea.')
			Return 2
		End if
		This.SetItem(1,'de_linea',ls_descripcion)
		
	case 'co_cliente'
		ll_cli = Long(Data)
		ls_descripcion = luo_descripcion.of_cliente(ll_cli)
		If ls_descripcion = '' Then
			MessageBox('Error','Verifique el cliente.')
			Return 2
		End if
		This.SetItem(1,'de_cliente',ls_descripcion)
	
	case 'co_marca'
		//li_marca_prn = Long(Data)
		ls_marca_prn = string(Data)
		ls_descripcion = luo_descripcion.of_marca(ls_marca_prn)

		If ls_descripcion = '' Then
			MessageBox('Error','Verifique la marca.')
			Return 2
		End if
		This.SetItem(1,'de_marca',ls_descripcion)
	
	case 'co_color'
		ll_color = Long(Data)
		ls_descripcion = luo_descripcion.of_color(ll_color)
		If ls_descripcion = '' Then
			MessageBox('Error','Verifique el color.')
			Return 2
		End if
		This.SetItem(1,'de_color',ls_descripcion)
		
	case 'co_referencia'
		li_fab = This.GetItemNumber(1,'co_fabrica')
		li_lin = This.GetItemNumber(1,'co_linea')
		ll_ref = Long(Data)
		If IsNull(li_fab) OR IsNull(li_lin) Then
			MessageBox('Advertencia','Para poder buscar la referencia debe ingresar antes la fabrica y la l$$HEX1$$ed00$$ENDHEX$$nea.',Exclamation!)
			Return
		End if
		
		ls_descripcion = luo_descripcion.of_referencia(ll_ref,li_fab,li_lin)
		If ls_descripcion = '' Then
			MessageBox('Error','Verifique la Referencia.')
			Return 2
		End if
		This.SetItem(1,'de_referencia',ls_descripcion)	
		
	
end choose

end event

event doubleclicked;s_base_parametros lstr_parametros


choose case GetColumnName()
	case 'co_fabrica'
		lstr_parametros.cadena[1] = 'dgr_buscar_fabrica'
		OpenWithParm ( w_buscar, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(row,'co_fabrica',lstr_parametros.entero[1])
			This.SetItem(row,'de_fabrica',lstr_parametros.cadena[1])
		End if
		
	case 'co_linea'
		lstr_parametros.cadena[1] = 'dgr_buscar_lineas'
		OpenWithParm ( w_buscar, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(row,'co_linea',lstr_parametros.entero[1])
			This.SetItem(row,'de_linea',lstr_parametros.cadena[1])
		End if
		
	case 'co_referencia'
		lstr_parametros.cadena[1] = 'dgr_buscar_referencia'
		lstr_parametros.entero[1] = This.GetItemNumber(1,'co_fabrica')
		lstr_parametros.entero[2] = This.GetItemNumber(1,'co_linea')
		
		If IsNull(lstr_parametros.entero[1]) Or IsNull(lstr_parametros.entero[2]) Then
			MessageBox('Advertencia','Para poder buscar la referencia debe ingresar antes la fabrica y la l$$HEX1$$ed00$$ENDHEX$$nea.',Exclamation!)
			Return
		End if
		
		OpenWithParm ( w_buscar_referencia, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(1,'co_referencia',lstr_parametros.entero[1])
			This.SetItem(1,'de_referencia',lstr_parametros.cadena[1])
		End if	
		
		
	case 'co_cliente'
		lstr_parametros.cadena[1] = 'dgr_buscar_clientes'
		OpenWithParm ( w_buscar, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(row,'co_cliente',lstr_parametros.entero[1])
			This.SetItem(row,'de_cliente',lstr_parametros.cadena[1])
		End if		
				
	case 'co_reftel'
		lstr_parametros.cadena[1] = 'dgr_buscar_tela'
		OpenWithParm ( w_buscar, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(row,'co_reftel',lstr_parametros.entero[1])
			This.SetItem(row,'de_reftel',lstr_parametros.cadena[1])
		End if		
					
	case 'co_color'
		lstr_parametros.cadena[1] = 'dgr_buscar_color'
		OpenWithParm ( w_buscar, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(row,'co_color',lstr_parametros.entero[1])
			This.SetItem(row,'de_color',lstr_parametros.cadena[1])
		End if
		
	case 'co_marca'
		lstr_parametros.cadena[1] = 'dgr_buscar_marca_prenda'
		OpenWithParm ( w_buscar_dato_string, lstr_parametros )
		
		lstr_parametros = Message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			This.SetItem(row,'co_marca',lstr_parametros.cadena[2])
			This.SetItem(row,'de_marca',lstr_parametros.cadena[1])
		End if	
		
	case 'fecha_ini'
			ipo_calendario.of_Show_Calendar(This)
		
	case 'fecha_fin'
			ipo_calendario.of_Show_Calendar(This)
	
end choose

end event

event buttonclicked;
Long li_fab, li_lin
Long ll_ref, ll_ordenpd_pt, ll_fila
s_base_parametros lstr_parametros

choose case dwo.name  
	case 'b_make_to_order'

	OpenSheetWithParm(w_inicial_liberacion_semiautomatica,0,w_principal,2,Original!)
	
	lstr_parametros = message.PowerObjectParm	
	
	If lstr_parametros.hay_parametros Then
	
	lstr_parametros.hay_parametros = True

	OpenSheetWithParm(w_liberacion_semiautomatica, lstr_parametros, w_principal, 2, Original!)

		
		
		
	End if
	
	dw_criterio.SetFocus()

end choose
end event

type gb_1 from groupbox within w_filtro_liberacion
integer x = 69
integer y = 8
integer width = 1513
integer height = 1196
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

