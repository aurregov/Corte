HA$PBExportHeader$w_grupos.srw
forward
global type w_grupos from window
end type
type cb_cerrar from commandbutton within w_grupos
end type
type dw_lista from datawindow within w_grupos
end type
type gb_1 from groupbox within w_grupos
end type
end forward

global type w_grupos from window
integer width = 2917
integer height = 1384
boolean titlebar = true
string title = "Grupos"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cerrar cb_cerrar
dw_lista dw_lista
gb_1 gb_1
end type
global w_grupos w_grupos

on w_grupos.create
this.cb_cerrar=create cb_cerrar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cerrar,&
this.dw_lista,&
this.gb_1}
end on

on w_grupos.destroy
destroy(this.cb_cerrar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

lstr_parametros = message.PowerObjectParm

This.Title = 'Ventana de grupos para la P.O. '+lstr_parametros.cadena[1]

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1],&
						lstr_parametros.cadena[1])
end event

type cb_cerrar from commandbutton within w_grupos
integer x = 1289
integer y = 1092
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
boolean default = true
end type

event clicked;Close(Parent)
end event

type dw_lista from datawindow within w_grupos
integer x = 64
integer y = 72
integer width = 2784
integer height = 924
integer taborder = 10
string title = "none"
string dataobject = "dgr_grupos"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_grupos
integer x = 41
integer y = 12
integer width = 2834
integer height = 1036
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

