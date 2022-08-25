HA$PBExportHeader$w_parametros_variaciones_detallado.srw
forward
global type w_parametros_variaciones_detallado from w_base_buscar_interactivo
end type
type st_2 from statictext within w_parametros_variaciones_detallado
end type
type st_4 from statictext within w_parametros_variaciones_detallado
end type
type st_5 from statictext within w_parametros_variaciones_detallado
end type
type em_op from editmask within w_parametros_variaciones_detallado
end type
type em_fecha_inicio from editmask within w_parametros_variaciones_detallado
end type
type em_fecha_fin from editmask within w_parametros_variaciones_detallado
end type
type em_raya from editmask within w_parametros_variaciones_detallado
end type
type st_7 from statictext within w_parametros_variaciones_detallado
end type
end forward

global type w_parametros_variaciones_detallado from w_base_buscar_interactivo
integer width = 1111
integer height = 784
string title = "Par$$HEX1$$e100$$ENDHEX$$metros para variaciones de Corte"
st_2 st_2
st_4 st_4
st_5 st_5
em_op em_op
em_fecha_inicio em_fecha_inicio
em_fecha_fin em_fecha_fin
em_raya em_raya
st_7 st_7
end type
global w_parametros_variaciones_detallado w_parametros_variaciones_detallado

on w_parametros_variaciones_detallado.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_4=create st_4
this.st_5=create st_5
this.em_op=create em_op
this.em_fecha_inicio=create em_fecha_inicio
this.em_fecha_fin=create em_fecha_fin
this.em_raya=create em_raya
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.em_op
this.Control[iCurrent+5]=this.em_fecha_inicio
this.Control[iCurrent+6]=this.em_fecha_fin
this.Control[iCurrent+7]=this.em_raya
this.Control[iCurrent+8]=this.st_7
end on

on w_parametros_variaciones_detallado.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.em_op)
destroy(this.em_fecha_inicio)
destroy(this.em_fecha_fin)
destroy(this.em_raya)
destroy(this.st_7)
end on

event open;this.width=1271
this.height=1400
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_parametros_variaciones_detallado
integer x = 681
integer y = 532
integer taborder = 70
end type

event pb_cancelar::clicked;call super::clicked;
Close(Parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_parametros_variaciones_detallado
integer x = 265
integer y = 532
integer taborder = 60
end type

event pb_buscar::clicked;LONG						ll_ordencorte,ll_raya
DATE					ld_fe_inicio,ld_fe_fin
TIME					lt_hora
DATE          ldt_fe_inicio, ldt_fe_fin


s_base_parametros 	lstr_parametros

lt_hora = TIME("00:00:00000")

ll_ordencorte		=LONG(em_op.TEXT)
ll_raya			   =LONG(em_raya.TEXT)
ld_fe_inicio		=DATE(em_fecha_inicio.TEXT)
ld_fe_fin			=DATE(em_fecha_fin.TEXT)


ldt_fe_inicio		=DATE(ld_fe_inicio)
ldt_fe_fin		=DATE(ld_fe_fin)

lstr_parametros.entero[1]			=	ll_ordencorte
lstr_parametros.entero[3]			=	ll_raya
lstr_parametros.fecha[1]		=	ld_fe_inicio
lstr_parametros.fecha[2]		=	ld_fe_fin	

lstr_parametros.Hay_Parametros	=	TRUE		
OpenSheetWithParm(w_preview_variaciones_detalle, lstr_parametros, w_principal, 1, Layered!)	



	






end event

type st_1 from w_base_buscar_interactivo`st_1 within w_parametros_variaciones_detallado
boolean visible = false
integer x = 389
integer y = 104
integer width = 169
string text = "Grupo: "
alignment alignment = right!
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_parametros_variaciones_detallado
boolean visible = false
integer x = 571
integer y = 80
integer width = 457
integer taborder = 10
fontcharset fontcharset = ansi!
boolean enabled = false
textcase textcase = upper!
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_parametros_variaciones_detallado
integer x = 27
integer y = 8
integer width = 1051
integer height = 500
integer taborder = 0
end type

type st_2 from statictext within w_parametros_variaciones_detallado
integer x = 73
integer y = 68
integer width = 485
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Orden de Corte:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_parametros_variaciones_detallado
integer x = 73
integer y = 268
integer width = 357
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Fecha de Inicio:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_parametros_variaciones_detallado
integer x = 73
integer y = 368
integer width = 306
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Fecha de Fin:"
boolean focusrectangle = false
end type

type em_op from editmask within w_parametros_variaciones_detallado
integer x = 571
integer y = 60
integer width = 457
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####0"
end type

type em_fecha_inicio from editmask within w_parametros_variaciones_detallado
integer x = 571
integer y = 260
integer width = 457
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy-mm-dd"
end type

type em_fecha_fin from editmask within w_parametros_variaciones_detallado
integer x = 571
integer y = 360
integer width = 457
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy-mm-dd"
end type

type em_raya from editmask within w_parametros_variaciones_detallado
integer x = 571
integer y = 160
integer width = 457
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_7 from statictext within w_parametros_variaciones_detallado
integer x = 73
integer y = 168
integer width = 146
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Raya:"
boolean focusrectangle = false
end type

