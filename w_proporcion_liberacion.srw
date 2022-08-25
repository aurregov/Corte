HA$PBExportHeader$w_proporcion_liberacion.srw
forward
global type w_proporcion_liberacion from window
end type
type cb_cerrar from commandbutton within w_proporcion_liberacion
end type
type dw_lista from datawindow within w_proporcion_liberacion
end type
type gb_1 from groupbox within w_proporcion_liberacion
end type
end forward

global type w_proporcion_liberacion from window
integer width = 818
integer height = 1304
boolean titlebar = true
string title = "Proporci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cerrar cb_cerrar
dw_lista dw_lista
gb_1 gb_1
end type
global w_proporcion_liberacion w_proporcion_liberacion

event open;This.Center = True

s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1])
dw_lista.SetFocus()
end event

on w_proporcion_liberacion.create
this.cb_cerrar=create cb_cerrar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cerrar,&
this.dw_lista,&
this.gb_1}
end on

on w_proporcion_liberacion.destroy
destroy(this.cb_cerrar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

type cb_cerrar from commandbutton within w_proporcion_liberacion
integer x = 215
integer y = 988
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

type dw_lista from datawindow within w_proporcion_liberacion
integer x = 41
integer y = 40
integer width = 713
integer height = 848
integer taborder = 10
string title = "none"
string dataobject = "dgr_proporcion_liberacion"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_proporcion_liberacion
integer x = 27
integer width = 763
integer height = 912
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

