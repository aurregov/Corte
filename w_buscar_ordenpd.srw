HA$PBExportHeader$w_buscar_ordenpd.srw
forward
global type w_buscar_ordenpd from w_base_buscar_interactivo
end type
end forward

global type w_buscar_ordenpd from w_base_buscar_interactivo
integer x = 727
integer y = 524
integer height = 612
string title = "Buscar Orden Producci$$HEX1$$f300$$ENDHEX$$n"
end type
global w_buscar_ordenpd w_buscar_ordenpd

on w_buscar_ordenpd.create
call super::create
end on

on w_buscar_ordenpd.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_ordenpd
integer x = 837
integer y = 320
integer width = 361
integer height = 164
integer taborder = 30
integer textsize = -8
fontcharset fontcharset = defaultcharset!
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_ordenpd
integer x = 425
integer y = 320
integer width = 361
integer height = 164
integer taborder = 20
integer textsize = -8
fontcharset fontcharset = defaultcharset!
end type

event pb_buscar::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = TRUE
lstr_parametros.entero[1]=Long(Trim(sle_parametro1.text))

CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_ordenpd
integer x = 78
integer width = 576
long backcolor = 12632256
string text = "Orden de Producci$$HEX1$$f300$$ENDHEX$$n No: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_ordenpd
integer x = 699
integer y = 124
integer width = 430
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_ordenpd
integer height = 284
integer taborder = 0
long backcolor = 12632256
end type

