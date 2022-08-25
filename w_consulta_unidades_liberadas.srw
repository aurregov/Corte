HA$PBExportHeader$w_consulta_unidades_liberadas.srw
forward
global type w_consulta_unidades_liberadas from window
end type
type dw_tallas_liberacion from datawindow within w_consulta_unidades_liberadas
end type
type cb_cancelar from commandbutton within w_consulta_unidades_liberadas
end type
type cb_aceptar from commandbutton within w_consulta_unidades_liberadas
end type
type gb_1 from groupbox within w_consulta_unidades_liberadas
end type
end forward

global type w_consulta_unidades_liberadas from window
integer width = 777
integer height = 1044
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_tallas_liberacion dw_tallas_liberacion
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_consulta_unidades_liberadas w_consulta_unidades_liberadas

on w_consulta_unidades_liberadas.create
this.dw_tallas_liberacion=create dw_tallas_liberacion
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.dw_tallas_liberacion,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_consulta_unidades_liberadas.destroy
destroy(this.dw_tallas_liberacion)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

dw_tallas_liberacion.SetTransObject(SQLCA)

lstr_parametros = Message.PowerObjectParm

dw_tallas_liberacion.Retrieve(lstr_parametros.entero[1], & 
	lstr_parametros.entero[2], lstr_parametros.entero[3], &
	lstr_parametros.entero[4], lstr_parametros.entero[5])
end event

type dw_tallas_liberacion from datawindow within w_consulta_unidades_liberadas
integer x = 69
integer y = 60
integer width = 608
integer height = 700
integer taborder = 20
string title = "none"
string dataobject = "dgr_consulta_unidades_liberadas"
boolean livescroll = true
end type

type cb_cancelar from commandbutton within w_consulta_unidades_liberadas
integer x = 375
integer y = 820
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.boolean[1] = False

CloseWithReturn(Parent, lstr_parametros)
end event

type cb_aceptar from commandbutton within w_consulta_unidades_liberadas
integer x = 23
integer y = 820
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.boolean[1] = True

CloseWithReturn(Parent, lstr_parametros)
end event

type gb_1 from groupbox within w_consulta_unidades_liberadas
integer x = 27
integer width = 686
integer height = 788
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "Unidades Liberadas"
borderstyle borderstyle = stylebox!
end type

