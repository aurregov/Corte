HA$PBExportHeader$w_telas.srw
forward
global type w_telas from window
end type
type dw_telas from datawindow within w_telas
end type
type gb_1 from groupbox within w_telas
end type
end forward

global type w_telas from window
integer width = 3369
integer height = 1152
boolean titlebar = true
string title = "Rollos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_telas dw_telas
gb_1 gb_1
end type
global w_telas w_telas

type variables
Long ii_estadodisp, ii_centroterm
end variables

on w_telas.create
this.dw_telas=create dw_telas
this.gb_1=create gb_1
this.Control[]={this.dw_telas,&
this.gb_1}
end on

on w_telas.destroy
destroy(this.dw_telas)
destroy(this.gb_1)
end on

event open;This.Center = True
s_base_parametros lstr_parametros

dw_telas.settransobject(sqlca)

lstr_parametros = message.PowerObjectParm	

dw_telas.retrieve(lstr_parametros.entero[1],lstr_parametros.cadena[1])
	


end event

type dw_telas from datawindow within w_telas
integer x = 32
integer y = 36
integer width = 3282
integer height = 992
integer taborder = 10
string title = "none"
string dataobject = "dgr_temp_tela_n"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_telas
integer width = 3355
integer height = 1048
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

