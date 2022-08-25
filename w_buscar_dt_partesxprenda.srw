HA$PBExportHeader$w_buscar_dt_partesxprenda.srw
forward
global type w_buscar_dt_partesxprenda from w_base_buscar_interactivo
end type
type st_linea from statictext within w_buscar_dt_partesxprenda
end type
type st_referencia from statictext within w_buscar_dt_partesxprenda
end type
type sle_linea from singlelineedit within w_buscar_dt_partesxprenda
end type
type sle_referencia from singlelineedit within w_buscar_dt_partesxprenda
end type
end forward

global type w_buscar_dt_partesxprenda from w_base_buscar_interactivo
integer height = 972
st_linea st_linea
st_referencia st_referencia
sle_linea sle_linea
sle_referencia sle_referencia
end type
global w_buscar_dt_partesxprenda w_buscar_dt_partesxprenda

on w_buscar_dt_partesxprenda.create
int iCurrent
call super::create
this.st_linea=create st_linea
this.st_referencia=create st_referencia
this.sle_linea=create sle_linea
this.sle_referencia=create sle_referencia
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_linea
this.Control[iCurrent+2]=this.st_referencia
this.Control[iCurrent+3]=this.sle_linea
this.Control[iCurrent+4]=this.sle_referencia
end on

on w_buscar_dt_partesxprenda.destroy
call super::destroy
destroy(this.st_linea)
destroy(this.st_referencia)
destroy(this.sle_linea)
destroy(this.sle_referencia)
end on

event open;call super::open;sle_parametro1.setfocus()
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_dt_partesxprenda
integer x = 626
integer y = 696
integer taborder = 50
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_dt_partesxprenda
integer x = 160
integer y = 696
integer taborder = 40
end type

event pb_buscar::clicked;call super::clicked;s_base_parametros lstr_parametros
lstr_parametros.hay_parametros = TRUE
lstr_parametros.entero[1]=Long(sle_parametro1.text)
lstr_parametros.entero[2]=Long(sle_linea.text)
lstr_parametros.entero[3]=Long(sle_referencia.text)

CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_dt_partesxprenda
string text = "Fabrica: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_dt_partesxprenda
integer width = 384
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_dt_partesxprenda
integer height = 648
integer taborder = 0
end type

type st_linea from statictext within w_buscar_dt_partesxprenda
integer x = 151
integer y = 288
integer width = 165
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "L$$HEX1$$ed00$$ENDHEX$$nea:"
boolean focusrectangle = false
end type

type st_referencia from statictext within w_buscar_dt_partesxprenda
integer x = 105
integer y = 436
integer width = 274
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "Referencia:"
boolean focusrectangle = false
end type

type sle_linea from singlelineedit within w_buscar_dt_partesxprenda
integer x = 471
integer y = 272
integer width = 384
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_referencia from singlelineedit within w_buscar_dt_partesxprenda
integer x = 471
integer y = 416
integer width = 384
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

