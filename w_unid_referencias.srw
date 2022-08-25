HA$PBExportHeader$w_unid_referencias.srw
forward
global type w_unid_referencias from window
end type
type dw_telas from datawindow within w_unid_referencias
end type
type gb_1 from groupbox within w_unid_referencias
end type
end forward

global type w_unid_referencias from window
integer width = 2880
integer height = 1832
boolean titlebar = true
string title = "Unidades por Referencia"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_telas dw_telas
gb_1 gb_1
end type
global w_unid_referencias w_unid_referencias

on w_unid_referencias.create
this.dw_telas=create dw_telas
this.gb_1=create gb_1
this.Control[]={this.dw_telas,&
this.gb_1}
end on

on w_unid_referencias.destroy
destroy(this.dw_telas)
destroy(this.gb_1)
end on

event open;This.Center = True

dw_telas.settransobject(sqlca)

s_base_parametros lstr_parametros

lstr_parametros = message.PowerObjectParm	

dw_telas.retrieve(lstr_parametros.cadena[1],lstr_parametros.entero[1],lstr_parametros.entero[2])
end event

type dw_telas from datawindow within w_unid_referencias
integer x = 37
integer y = 32
integer width = 2734
integer height = 1628
integer taborder = 10
string title = "none"
string dataobject = "dtb_datos_liberacion_unidades"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_unid_referencias
integer x = 23
integer width = 2775
integer height = 1684
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

