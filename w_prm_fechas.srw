HA$PBExportHeader$w_prm_fechas.srw
forward
global type w_prm_fechas from window
end type
type em_fini from editmask within w_prm_fechas
end type
type em_ffin from editmask within w_prm_fechas
end type
type cb_cancelar from commandbutton within w_prm_fechas
end type
type cb_aceptar from commandbutton within w_prm_fechas
end type
type st_2 from statictext within w_prm_fechas
end type
type st_1 from statictext within w_prm_fechas
end type
type gb_1 from groupbox within w_prm_fechas
end type
end forward

global type w_prm_fechas from window
integer width = 1742
integer height = 448
boolean titlebar = true
string title = "Ingrese las fechas que desea consultar..."
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
em_fini em_fini
em_ffin em_ffin
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_prm_fechas w_prm_fechas

type variables

end variables

on w_prm_fechas.create
this.em_fini=create em_fini
this.em_ffin=create em_ffin
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.em_fini,&
this.em_ffin,&
this.cb_cancelar,&
this.cb_aceptar,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_prm_fechas.destroy
destroy(this.em_fini)
destroy(this.em_ffin)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;em_fini.Text = string(RelativeDate(today(), - 1))
em_ffin.Text = string(RelativeDate(today(), - 1))
end event

type em_fini from editmask within w_prm_fechas
integer x = 398
integer y = 88
integer width = 430
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean autoskip = true
end type

type em_ffin from editmask within w_prm_fechas
integer x = 1193
integer y = 88
integer width = 430
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean autoskip = true
end type

type cb_cancelar from commandbutton within w_prm_fechas
integer x = 896
integer y = 248
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
end type

event clicked;close(w_prm_fechas)
end event

type cb_aceptar from commandbutton within w_prm_fechas
integer x = 471
integer y = 248
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
end type

event clicked;date ld_finicial,ld_ffin
s_base_parametros lstr_fechas

ld_finicial = date(em_fini.text)
ld_ffin = date(em_ffin.text)
IF ld_finicial > ld_ffin or em_fini.text = "" or em_ffin.text = "" THEN
	messagebox("Error...","Verifique que ha diligenciado correctamente el valor de las fechas.",StopSign!)
else	
	lstr_fechas.fecha[1] = ld_finicial
	lstr_fechas.fecha[2] = ld_ffin
	CloseWithReturn(parent, lstr_fechas)
end if
end event

type st_2 from statictext within w_prm_fechas
integer x = 923
integer y = 104
integer width = 288
integer height = 56
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

type st_1 from statictext within w_prm_fechas
integer x = 101
integer y = 104
integer width = 288
integer height = 56
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

type gb_1 from groupbox within w_prm_fechas
integer x = 32
integer width = 1655
integer height = 236
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Buscar Por:"
end type

