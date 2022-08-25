HA$PBExportHeader$w_password_max_lotes.srw
forward
global type w_password_max_lotes from window
end type
type cb_cancelar from commandbutton within w_password_max_lotes
end type
type cb_aceptar from commandbutton within w_password_max_lotes
end type
type sle_password from singlelineedit within w_password_max_lotes
end type
type gb_1 from groupbox within w_password_max_lotes
end type
end forward

global type w_password_max_lotes from window
integer width = 978
integer height = 684
boolean titlebar = true
string title = "Password"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_password sle_password
gb_1 gb_1
end type
global w_password_max_lotes w_password_max_lotes

on w_password_max_lotes.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_password=create sle_password
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.sle_password,&
this.gb_1}
end on

on w_password_max_lotes.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_password)
destroy(this.gb_1)
end on

event open;This.Center = True

sle_password.SetFocus()
end event

type cb_cancelar from commandbutton within w_password_max_lotes
integer x = 521
integer y = 408
integer width = 343
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

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_password_max_lotes
integer x = 96
integer y = 408
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

event clicked;String ls_password, ls_password_valido
s_base_parametros lstr_parametros

ls_password = sle_password.text

if isnull(ls_password) Or ls_password = '' Then
	MessageBox('Error','Debe ingresar el Password de validaci$$HEX1$$f300$$ENDHEX$$n de lotes.')
	Return
End if

lstr_parametros.hay_parametros = True
lstr_parametros.cadena[1] = ls_password

CloseWithReturn ( Parent, lstr_parametros )
end event

type sle_password from singlelineedit within w_password_max_lotes
integer x = 187
integer y = 168
integer width = 585
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_password_max_lotes
integer x = 146
integer y = 92
integer width = 672
integer height = 224
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password "
end type

