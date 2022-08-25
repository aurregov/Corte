HA$PBExportHeader$w_password_trazos.srw
forward
global type w_password_trazos from window
end type
type cb_cancelar from commandbutton within w_password_trazos
end type
type cb_aceptar from commandbutton within w_password_trazos
end type
type dw_lista from datawindow within w_password_trazos
end type
type gb_1 from groupbox within w_password_trazos
end type
end forward

global type w_password_trazos from window
integer width = 850
integer height = 660
boolean titlebar = true
string title = "Password Validaci$$HEX1$$f300$$ENDHEX$$n"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_password_trazos w_password_trazos

on w_password_trazos.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_password_trazos.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;dw_lista.SetTransObject(sqlca)

dw_lista.InsertRow(0)
dw_lista.SetFocus()
end event

type cb_cancelar from commandbutton within w_password_trazos
integer x = 425
integer y = 356
integer width = 297
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = false

CloseWithReturn (parent, lstr_parametros)
end event

type cb_aceptar from commandbutton within w_password_trazos
integer x = 50
integer y = 356
integer width = 297
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

event clicked;String ls_password
s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = true

dw_lista.AcceptText()

ls_password = dw_lista.GetItemString(1,'password')

If isnull(ls_password) Then
	MessageBox('Error','El password no es valido.')
	Return
Else
	lstr_parametros.cadena[1] = ls_password
	CloseWithReturn (parent, lstr_parametros)
End if
end event

type dw_lista from datawindow within w_password_trazos
integer x = 247
integer y = 168
integer width = 361
integer height = 72
integer taborder = 10
string title = "none"
string dataobject = "dff_password_trazos"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_password_trazos
integer x = 219
integer y = 108
integer width = 398
integer height = 160
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "   Password "
end type

