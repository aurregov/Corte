HA$PBExportHeader$w_porcentaje.srw
forward
global type w_porcentaje from window
end type
type sle_porcentaje from singlelineedit within w_porcentaje
end type
type cb_cancelar from commandbutton within w_porcentaje
end type
type cb_aceptar from commandbutton within w_porcentaje
end type
type gb_1 from groupbox within w_porcentaje
end type
end forward

global type w_porcentaje from window
integer width = 896
integer height = 664
boolean titlebar = true
string title = "Porcentaje"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_porcentaje sle_porcentaje
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_porcentaje w_porcentaje

on w_porcentaje.create
this.sle_porcentaje=create sle_porcentaje
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.sle_porcentaje,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_porcentaje.destroy
destroy(this.sle_porcentaje)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

type sle_porcentaje from singlelineedit within w_porcentaje
integer x = 229
integer y = 116
integer width = 366
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

type cb_cancelar from commandbutton within w_porcentaje
integer x = 434
integer y = 304
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
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = false

CloseWithReturn ( Parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_porcentaje
integer x = 46
integer y = 304
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
end type

event clicked;String ls_porcentaje
s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = True

ls_porcentaje = sle_porcentaje.Text

If isnull(ls_porcentaje) Then
	MessageBox('Error','El porcentaje no es valido.')
	Return 
Else
	lstr_parametros.cadena[1] = ls_porcentaje
End if

CloseWithReturn ( Parent, lstr_parametros )
end event

type gb_1 from groupbox within w_porcentaje
integer x = 160
integer y = 48
integer width = 498
integer height = 192
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

