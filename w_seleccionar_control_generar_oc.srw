HA$PBExportHeader$w_seleccionar_control_generar_oc.srw
forward
global type w_seleccionar_control_generar_oc from w_base_buscar_lista
end type
type st_1 from statictext within w_seleccionar_control_generar_oc
end type
end forward

global type w_seleccionar_control_generar_oc from w_base_buscar_lista
integer x = 142
integer y = 64
integer width = 2213
integer height = 1184
st_1 st_1
end type
global w_seleccionar_control_generar_oc w_seleccionar_control_generar_oc

type variables
Long il_orden_corte, il_modelo, il_trazo, il_reftel, il_agrupacion, il_colorte
Long ii_seccion, ii_fabrica, ii_caract, ii_diametro, ii_liquidacion
Long ii_produccion, ii_base
end variables

on w_seleccionar_control_generar_oc.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_seleccionar_control_generar_oc.destroy
call super::destroy
destroy(this.st_1)
end on

event open;Long ll_numero_registros
Long li_centro
s_base_parametros lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	st_1.text= lstr_parametros.cadena[1]
	
	dw_lista.insertRow(0)
	
END IF
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_control_generar_oc
boolean visible = false
integer x = 37
integer y = 1376
integer width = 1207
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_control_generar_oc
integer x = 1024
integer y = 864
integer taborder = 90
string picturename = "cancelar.bmp"
end type

event pb_cancelar::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_control_generar_oc
integer x = 549
integer y = 864
integer taborder = 80
string text = "Acceptar"
boolean default = false
string picturename = "ok.bmp"
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados
String ls_observacion
s_base_parametros lstr_parametros

dw_lista.AcceptText()

lstr_parametros.entero[1] = dw_lista.GetItemNumber(1,'opcion')
lstr_parametros.cadena[1] = ''

lstr_parametros.hay_parametros = True

//si la opcion es 5 debe ingresar nota
If dw_lista.GetItemNumber(1,'opcion') = 5 Then
	ls_observacion = trim(dw_lista.GetItemString(1,'observacion'))
	If ls_observacion = '' or Isnull(ls_observacion) Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Para esta opci$$HEX1$$f300$$ENDHEX$$n debe ingresar una Nota.')
		Return 1
	End if
	
	lstr_parametros.cadena[1] = ls_observacion
End if

CloseWithReturn(Parent, lstr_parametros)

Return 1

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_control_generar_oc
integer x = 73
integer y = 288
integer width = 2085
integer height = 544
integer taborder = 50
string dataobject = "d_ff_seleccionar_control_generar_oc"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_lista::rowfocuschanged;// Se omite el script


end event

event dw_lista::doubleclicked;//	NO HACE NADA
end event

type st_1 from statictext within w_seleccionar_control_generar_oc
integer x = 37
integer y = 32
integer width = 2011
integer height = 288
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

