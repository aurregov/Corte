HA$PBExportHeader$w_buscar_mercada.srw
forward
global type w_buscar_mercada from w_base_buscar_interactivo
end type
end forward

global type w_buscar_mercada from w_base_buscar_interactivo
string title = "Mercada"
end type
global w_buscar_mercada w_buscar_mercada

on w_buscar_mercada.create
call super::create
end on

on w_buscar_mercada.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_mercada
integer taborder = 30
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_mercada
integer taborder = 20
end type

event pb_buscar::clicked;
s_base_parametros lstr_parametros
lstr_parametros.hay_parametros = TRUE
lstr_parametros.entero[1]= Long(sle_parametro1.text)

CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_mercada
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_mercada
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_mercada
end type

