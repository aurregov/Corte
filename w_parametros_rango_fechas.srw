HA$PBExportHeader$w_parametros_rango_fechas.srw
forward
global type w_parametros_rango_fechas from window
end type
type cb_cancelar from commandbutton within w_parametros_rango_fechas
end type
type cb_aceptar from commandbutton within w_parametros_rango_fechas
end type
type em_final from editmask within w_parametros_rango_fechas
end type
type em_inicial from editmask within w_parametros_rango_fechas
end type
type st_2 from statictext within w_parametros_rango_fechas
end type
type st_1 from statictext within w_parametros_rango_fechas
end type
type gb_1 from groupbox within w_parametros_rango_fechas
end type
end forward

global type w_parametros_rango_fechas from window
integer width = 809
integer height = 492
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
em_final em_final
em_inicial em_inicial
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_parametros_rango_fechas w_parametros_rango_fechas

on w_parametros_rango_fechas.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.em_final=create em_final
this.em_inicial=create em_inicial
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.em_final,&
this.em_inicial,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_parametros_rango_fechas.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.em_final)
destroy(this.em_inicial)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

type cb_cancelar from commandbutton within w_parametros_rango_fechas
integer x = 416
integer y = 288
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_parametros_rango_fechas
integer x = 55
integer y = 288
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
end type

event clicked;Date ldt_inicial, ldt_final

ldt_inicial = Date(em_inicial.Text)
ldt_final = Date(em_final.Text)
w_preview_de_impresion.dw_reporte.Retrieve(ldt_inicial, ldt_final)
end event

type em_final from editmask within w_parametros_rango_fechas
integer x = 398
integer y = 144
integer width = 311
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_inicial from editmask within w_parametros_rango_fechas
integer x = 398
integer y = 60
integer width = 311
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_2 from statictext within w_parametros_rango_fechas
integer x = 64
integer y = 160
integer width = 311
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Final:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_parametros_rango_fechas
integer x = 64
integer y = 76
integer width = 311
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Inicial:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_parametros_rango_fechas
integer x = 23
integer y = 4
integer width = 731
integer height = 264
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango Fechas"
borderstyle borderstyle = stylelowered!
end type

