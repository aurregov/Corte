HA$PBExportHeader$w_parametros_variaciones.srw
forward
global type w_parametros_variaciones from w_base_buscar_interactivo
end type
type st_2 from statictext within w_parametros_variaciones
end type
type st_3 from statictext within w_parametros_variaciones
end type
type st_4 from statictext within w_parametros_variaciones
end type
type st_5 from statictext within w_parametros_variaciones
end type
type em_op from editmask within w_parametros_variaciones
end type
type em_estilo from editmask within w_parametros_variaciones
end type
type em_fecha_inicio from editmask within w_parametros_variaciones
end type
type em_fecha_fin from editmask within w_parametros_variaciones
end type
type st_6 from statictext within w_parametros_variaciones
end type
type em_color from editmask within w_parametros_variaciones
end type
type em_raya from editmask within w_parametros_variaciones
end type
type st_7 from statictext within w_parametros_variaciones
end type
end forward

global type w_parametros_variaciones from w_base_buscar_interactivo
integer height = 1172
string title = "Par$$HEX1$$e100$$ENDHEX$$metros para variaciones de Corte"
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
em_op em_op
em_estilo em_estilo
em_fecha_inicio em_fecha_inicio
em_fecha_fin em_fecha_fin
st_6 st_6
em_color em_color
em_raya em_raya
st_7 st_7
end type
global w_parametros_variaciones w_parametros_variaciones

on w_parametros_variaciones.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.em_op=create em_op
this.em_estilo=create em_estilo
this.em_fecha_inicio=create em_fecha_inicio
this.em_fecha_fin=create em_fecha_fin
this.st_6=create st_6
this.em_color=create em_color
this.em_raya=create em_raya
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.em_op
this.Control[iCurrent+6]=this.em_estilo
this.Control[iCurrent+7]=this.em_fecha_inicio
this.Control[iCurrent+8]=this.em_fecha_fin
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.em_color
this.Control[iCurrent+11]=this.em_raya
this.Control[iCurrent+12]=this.st_7
end on

on w_parametros_variaciones.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.em_op)
destroy(this.em_estilo)
destroy(this.em_fecha_inicio)
destroy(this.em_fecha_fin)
destroy(this.st_6)
destroy(this.em_color)
destroy(this.em_raya)
destroy(this.st_7)
end on

event open;this.width=1271
this.height=1172
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_parametros_variaciones
integer x = 658
integer y = 892
integer taborder = 90
end type

event pb_cancelar::clicked;call super::clicked;
Close(Parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_parametros_variaciones
integer x = 192
integer y = 892
integer taborder = 80
end type

event pb_buscar::clicked;//s_parametros lstr_parametros
//lstr_parametros.hay_parametros = TRUE
//lstr_parametros.cadena[1]=sle_parametro1.text
//
//CloseWithReturn(parent,ls_parametro)

LONG						ll_cs_ordenpd_pt,ll_color_pt,ll_raya

STRING					ls_grupo,ls_estilo

DATE					ld_fe_inicio,ld_fe_fin
TIME					lt_hora
DATETIME          ldt_fe_inicio, ldt_fe_fin


s_base_parametros 	lstr_parametros

lt_hora = TIME("00:00:00000")

ls_grupo				=sle_parametro1.TEXT
ll_cs_ordenpd_pt	=LONG(em_op.TEXT)
ls_estilo			=em_estilo.TEXT
ll_color_pt			=LONG(em_color.TEXT)
ll_raya			   =LONG(em_raya.TEXT)
ld_fe_inicio		=DATE(em_fecha_inicio.TEXT)
ld_fe_fin			=DATE(em_fecha_fin.TEXT)


ldt_fe_inicio		=DATETIME(ld_fe_inicio,lt_hora)
ldt_fe_fin		=DATETIME(ld_fe_fin,lt_hora)

lstr_parametros.cadena[1]			=	ls_grupo
lstr_parametros.entero[1]			=	ll_cs_ordenpd_pt
lstr_parametros.entero[2]			=	ll_color_pt
lstr_parametros.entero[3]			=	ll_raya
lstr_parametros.cadena[2]			=	ls_estilo
lstr_parametros.fechahora[1]		=	ldt_fe_inicio
lstr_parametros.fechahora[2]		=	ldt_fe_fin	

lstr_parametros.Hay_Parametros	=	TRUE		
OpenSheetWithParm(w_preview_variaciones_detallado, lstr_parametros, w_principal, 1, Layered!)	



	






end event

type st_1 from w_base_buscar_interactivo`st_1 within w_parametros_variaciones
integer x = 402
integer y = 108
integer width = 169
string text = "Grupo: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_parametros_variaciones
integer x = 585
integer y = 84
integer width = 457
integer taborder = 10
fontcharset fontcharset = ansi!
textcase textcase = upper!
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_parametros_variaciones
integer x = 41
integer y = 12
integer height = 856
integer taborder = 0
end type

type st_2 from statictext within w_parametros_variaciones
integer x = 87
integer y = 192
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
string text = "Orden de Producci$$HEX1$$f300$$ENDHEX$$n:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_parametros_variaciones
integer x = 421
integer y = 304
integer width = 151
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
string text = "Estilo:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_parametros_variaciones
integer x = 215
integer y = 624
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

type st_5 from statictext within w_parametros_variaciones
integer x = 265
integer y = 728
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

type em_op from editmask within w_parametros_variaciones
integer x = 585
integer y = 188
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

type em_estilo from editmask within w_parametros_variaciones
integer x = 585
integer y = 296
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
maskdatatype maskdatatype = stringmask!
end type

type em_fecha_inicio from editmask within w_parametros_variaciones
integer x = 585
integer y = 616
integer width = 457
integer height = 88
integer taborder = 60
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

type em_fecha_fin from editmask within w_parametros_variaciones
integer x = 585
integer y = 724
integer width = 457
integer height = 88
integer taborder = 70
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

type st_6 from statictext within w_parametros_variaciones
integer x = 425
integer y = 412
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
string text = "Color:"
boolean focusrectangle = false
end type

type em_color from editmask within w_parametros_variaciones
integer x = 585
integer y = 404
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
string mask = "#########0"
end type

type em_raya from editmask within w_parametros_variaciones
integer x = 585
integer y = 508
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_7 from statictext within w_parametros_variaciones
integer x = 425
integer y = 512
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

