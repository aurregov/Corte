HA$PBExportHeader$w_seleccion_rollos.srw
forward
global type w_seleccion_rollos from window
end type
type cb_incluir_rollos from commandbutton within w_seleccion_rollos
end type
type cb_cancelar from commandbutton within w_seleccion_rollos
end type
type cb_cerrar from commandbutton within w_seleccion_rollos
end type
type cb_descartar_rollos from commandbutton within w_seleccion_rollos
end type
type dw_lista from datawindow within w_seleccion_rollos
end type
type gb_1 from groupbox within w_seleccion_rollos
end type
end forward

global type w_seleccion_rollos from window
integer width = 2990
integer height = 1316
boolean titlebar = true
string title = "Selecci$$HEX1$$f300$$ENDHEX$$n Rollos"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_incluir_rollos cb_incluir_rollos
cb_cancelar cb_cancelar
cb_cerrar cb_cerrar
cb_descartar_rollos cb_descartar_rollos
dw_lista dw_lista
gb_1 gb_1
end type
global w_seleccion_rollos w_seleccion_rollos

event open;String ls_usuario
s_base_parametros lstr_parametros

dw_lista.SetTransObject(sqlca)

lstr_parametros = Message.PowerObjectParm
ls_usuario = lstr_parametros.cadena[1]

dw_lista.Retrieve(ls_usuario)
dw_lista.SetFocus()
end event

on w_seleccion_rollos.create
this.cb_incluir_rollos=create cb_incluir_rollos
this.cb_cancelar=create cb_cancelar
this.cb_cerrar=create cb_cerrar
this.cb_descartar_rollos=create cb_descartar_rollos
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_incluir_rollos,&
this.cb_cancelar,&
this.cb_cerrar,&
this.cb_descartar_rollos,&
this.dw_lista,&
this.gb_1}
end on

on w_seleccion_rollos.destroy
destroy(this.cb_incluir_rollos)
destroy(this.cb_cancelar)
destroy(this.cb_cerrar)
destroy(this.cb_descartar_rollos)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

type cb_incluir_rollos from commandbutton within w_seleccion_rollos
string tag = "Utiliza solo los rollos chuleados"
integer x = 1957
integer y = 1084
integer width = 411
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Incluir Rollos"
end type

event clicked;Long ll_fila
Long li_marca

dw_lista.AcceptText()

For ll_fila = 1 To dw_lista.RowCount()
	li_marca = dw_lista.GetItemNumber(ll_fila,'marca')
	
	If li_marca = 1 Then
	Else
		dw_lista.DeleteRow(ll_fila)
		ll_fila -= ll_fila
	End if
	
Next

if dw_lista.Update() = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los rollos.')
Else
	MessageBox('Exito','Los rollos fueron actualizados exitosamente.')
End if
end event

type cb_cancelar from commandbutton within w_seleccion_rollos
integer x = 1550
integer y = 1084
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )

end event

type cb_cerrar from commandbutton within w_seleccion_rollos
integer x = 1125
integer y = 1084
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Continuar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = True

CloseWithReturn ( Parent, lstr_parametros )

end event

type cb_descartar_rollos from commandbutton within w_seleccion_rollos
string tag = "No utilizar los rollos marcados"
integer x = 585
integer y = 1084
integer width = 411
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Descartar Rollos"
end type

event clicked;Long ll_fila
Long li_marca

dw_lista.AcceptText()

For ll_fila = 1 To dw_lista.RowCount()
	li_marca = dw_lista.GetItemNumber(ll_fila,'marca')
	
	If li_marca = 1 Then
		dw_lista.DeleteRow(ll_fila)
		ll_fila -= ll_fila
	End if
	
Next

if dw_lista.Update() = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los rollos.')
Else
	MessageBox('Exito','Los rollos fueron actualizados exitosamente.')
End if
end event

type dw_lista from datawindow within w_seleccion_rollos
integer x = 41
integer y = 92
integer width = 2903
integer height = 916
integer taborder = 10
string title = "none"
string dataobject = "dgr_lista_seleccionar_rollos"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_seleccion_rollos
integer x = 23
integer y = 24
integer width = 2935
integer height = 1012
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rollos "
end type

