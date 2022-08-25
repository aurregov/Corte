HA$PBExportHeader$w_convenciones.srw
forward
global type w_convenciones from window
end type
type cb_1 from commandbutton within w_convenciones
end type
type dw_lista from datawindow within w_convenciones
end type
type gb_1 from groupbox within w_convenciones
end type
end forward

global type w_convenciones from window
integer width = 1221
integer height = 1904
boolean titlebar = true
string title = "Convenciones"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
dw_lista dw_lista
gb_1 gb_1
end type
global w_convenciones w_convenciones

on w_convenciones.create
this.cb_1=create cb_1
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_1,&
this.dw_lista,&
this.gb_1}
end on

on w_convenciones.destroy
destroy(this.cb_1)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;dw_lista.SetTransObject(sqlca)
dw_lista.retrieve()
end event

type cb_1 from commandbutton within w_convenciones
integer x = 320
integer y = 1652
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Close(Parent)
end event

type dw_lista from datawindow within w_convenciones
integer x = 41
integer y = 56
integer width = 1102
integer height = 1512
string title = "none"
string dataobject = "dgr_m_convenciones"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_convenciones
integer x = 18
integer y = 4
integer width = 1157
integer height = 1612
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

