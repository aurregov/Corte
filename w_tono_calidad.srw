HA$PBExportHeader$w_tono_calidad.srw
forward
global type w_tono_calidad from window
end type
type cb_cancelar from commandbutton within w_tono_calidad
end type
type cb_aceptar from commandbutton within w_tono_calidad
end type
type sle_tono from singlelineedit within w_tono_calidad
end type
type gb_1 from groupbox within w_tono_calidad
end type
end forward

global type w_tono_calidad from window
integer width = 864
integer height = 624
boolean titlebar = true
string title = "Tono"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_tono sle_tono
gb_1 gb_1
end type
global w_tono_calidad w_tono_calidad

on w_tono_calidad.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_tono=create sle_tono
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.sle_tono,&
this.gb_1}
end on

on w_tono_calidad.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_tono)
destroy(this.gb_1)
end on

event open;This.Center = True
sle_tono.SetFocus()
end event

type cb_cancelar from commandbutton within w_tono_calidad
integer x = 430
integer y = 324
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

type cb_aceptar from commandbutton within w_tono_calidad
integer x = 37
integer y = 324
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

event clicked;String ls_tono
s_base_parametros lstr_parametros

ls_tono = sle_tono.Text

IF ls_tono <> 'A' and ls_tono <> 'B' and ls_tono <> 'C' THEN
	MessageBox('Advertencia','El tono debe ser A, B o C, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n',StopSign!)
	Return
ELSE
	lstr_parametros.cadena[1] = ls_tono
END IF

lstr_parametros.hay_parametros = True
CloseWithReturn ( Parent, lstr_parametros )
end event

type sle_tono from singlelineedit within w_tono_calidad
integer x = 247
integer y = 120
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_tono_calidad
integer x = 197
integer y = 48
integer width = 448
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tono Requerido "
end type

