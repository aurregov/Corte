HA$PBExportHeader$w_rollos_lote.srw
forward
global type w_rollos_lote from window
end type
type cb_cerrar from commandbutton within w_rollos_lote
end type
type dw_lista from datawindow within w_rollos_lote
end type
type gb_1 from groupbox within w_rollos_lote
end type
end forward

global type w_rollos_lote from window
integer width = 1349
integer height = 1476
boolean titlebar = true
string title = "Lotes"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cerrar cb_cerrar
dw_lista dw_lista
gb_1 gb_1
end type
global w_rollos_lote w_rollos_lote

on w_rollos_lote.create
this.cb_cerrar=create cb_cerrar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cerrar,&
this.dw_lista,&
this.gb_1}
end on

on w_rollos_lote.destroy
destroy(this.cb_cerrar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.Center = True

s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1])
dw_lista.SetFocus()
end event

type cb_cerrar from commandbutton within w_rollos_lote
integer x = 507
integer y = 1132
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
end type

event clicked;Close(Parent)
end event

type dw_lista from datawindow within w_rollos_lote
integer x = 50
integer y = 40
integer width = 1243
integer height = 1012
integer taborder = 10
string title = "none"
string dataobject = "dgr_rollos_lotes"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_rollos_lote
integer x = 32
integer width = 1294
integer height = 1068
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

