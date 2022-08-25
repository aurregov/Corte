HA$PBExportHeader$w_parametros_variaciones_valorizado.srw
forward
global type w_parametros_variaciones_valorizado from w_base_buscar_interactivo
end type
type st_2 from statictext within w_parametros_variaciones_valorizado
end type
type st_4 from statictext within w_parametros_variaciones_valorizado
end type
type st_5 from statictext within w_parametros_variaciones_valorizado
end type
type em_op from editmask within w_parametros_variaciones_valorizado
end type
type em_fecha_inicio from editmask within w_parametros_variaciones_valorizado
end type
type em_fecha_fin from editmask within w_parametros_variaciones_valorizado
end type
type em_raya from editmask within w_parametros_variaciones_valorizado
end type
type st_7 from statictext within w_parametros_variaciones_valorizado
end type
end forward

global type w_parametros_variaciones_valorizado from w_base_buscar_interactivo
integer width = 1243
integer height = 760
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
global w_parametros_variaciones_valorizado w_parametros_variaciones_valorizado

type variables
LONG il_fila_actual,il_propietario
end variables

on w_parametros_variaciones_valorizado.create
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

on w_parametros_variaciones_valorizado.destroy
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

event open;This.width=1271
This.height=1400
em_fecha_fin.Text=string(today())
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_parametros_variaciones_valorizado
integer x = 818
integer y = 512
integer taborder = 90
end type

event pb_cancelar::clicked;call super::clicked;
Close(Parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_parametros_variaciones_valorizado
integer x = 379
integer y = 512
integer taborder = 80
end type

event pb_buscar::clicked;LONG						ll_ordencorte,ll_raya
DATE					ld_fe_inicio,ld_fe_fin
s_base_parametros 	lstr_parametros

ll_ordencorte		=LONG(em_op.TEXT)
ll_raya			   =LONG(em_raya.TEXT)
ld_fe_inicio		=DATE(em_fecha_inicio.TEXT)
ld_fe_fin			=DATE(em_fecha_fin.TEXT)


lstr_parametros.entero[1]			=	ll_ordencorte
lstr_parametros.entero[3]			=	ll_raya
lstr_parametros.fecha[1]			=	ld_fe_inicio
lstr_parametros.fecha[2]			=	ld_fe_fin	


lstr_parametros.Hay_Parametros	=	TRUE		
OpenSheetWithParm(w_preview_variaciones_valorizado, lstr_parametros, w_principal, 1, Layered!)	



	






end event

type st_1 from w_base_buscar_interactivo`st_1 within w_parametros_variaciones_valorizado
boolean visible = false
integer x = 402
integer y = 108
integer width = 169
string text = "Grupo: "
alignment alignment = right!
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_parametros_variaciones_valorizado
boolean visible = false
integer x = 585
integer y = 84
integer width = 585
integer taborder = 10
fontcharset fontcharset = ansi!
boolean enabled = false
textcase textcase = upper!
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_parametros_variaciones_valorizado
integer x = 41
integer y = 12
integer height = 476
integer taborder = 0
end type

type st_2 from statictext within w_parametros_variaciones_valorizado
integer x = 87
integer y = 80
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

type st_4 from statictext within w_parametros_variaciones_valorizado
integer x = 87
integer y = 272
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
string text = "Fecha de Inicio:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_parametros_variaciones_valorizado
integer x = 87
integer y = 368
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
string text = "Fecha de Fin:"
boolean focusrectangle = false
end type

type em_op from editmask within w_parametros_variaciones_valorizado
integer x = 585
integer y = 72
integer width = 585
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

type em_fecha_inicio from editmask within w_parametros_variaciones_valorizado
integer x = 585
integer y = 264
integer width = 585
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

type em_fecha_fin from editmask within w_parametros_variaciones_valorizado
integer x = 585
integer y = 360
integer width = 585
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

type em_raya from editmask within w_parametros_variaciones_valorizado
integer x = 585
integer y = 168
integer width = 585
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
string text = "10"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_7 from statictext within w_parametros_variaciones_valorizado
integer x = 87
integer y = 176
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
string text = "Raya:"
boolean focusrectangle = false
end type

