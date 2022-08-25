HA$PBExportHeader$w_usuariosxaplicacion.srw
forward
global type w_usuariosxaplicacion from window
end type
type cb_2 from commandbutton within w_usuariosxaplicacion
end type
type cb_1 from commandbutton within w_usuariosxaplicacion
end type
type dw_1 from datawindow within w_usuariosxaplicacion
end type
end forward

global type w_usuariosxaplicacion from window
integer width = 3154
integer height = 1236
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_usuariosxaplicacion w_usuariosxaplicacion

on w_usuariosxaplicacion.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_usuariosxaplicacion.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;dw_1.SetTransobject(SQLCA)
dw_1.retrieve()
end event

type cb_2 from commandbutton within w_usuariosxaplicacion
integer x = 2743
integer y = 232
integer width = 357
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Enviar Mensaje"
end type

event clicked;open(w_ventana_emergente)
end event

type cb_1 from commandbutton within w_usuariosxaplicacion
integer x = 2743
integer y = 52
integer width = 357
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Actualizar"
end type

event clicked;dw_1.retrieve()
end event

type dw_1 from datawindow within w_usuariosxaplicacion
integer x = 9
integer y = 16
integer width = 2697
integer height = 1052
integer taborder = 10
string title = "none"
string dataobject = "dtb_usuariosxaplicacion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

