HA$PBExportHeader$w_buscar_espacioxcb.srw
forward
global type w_buscar_espacioxcb from w_base_buscar_interactivo
end type
end forward

global type w_buscar_espacioxcb from w_base_buscar_interactivo
end type
global w_buscar_espacioxcb w_buscar_espacioxcb

on w_buscar_espacioxcb.create
call super::create
end on

on w_buscar_espacioxcb.destroy
call super::destroy
end on

event open;call super::open;sle_parametro1.setfocus()
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_espacioxcb
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_espacioxcb
end type

event pb_buscar::clicked;call super::clicked;String 				ls_cadena
Long 				li_posicion
s_base_parametros lstr_parametros

ls_cadena = sle_parametro1.text

lstr_parametros.hay_parametros = TRUE
lstr_parametros.entero[1] = Long(Trim(Mid(ls_cadena, 1, 6)))
lstr_parametros.entero[2] = Long(Trim(Mid(ls_cadena, 7,4)))
lstr_parametros.entero[3] = Long(Trim(Mid(ls_cadena, 11,2)))
lstr_parametros.entero[4] = Long(Trim(Mid(ls_cadena, 13,2)))
CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_espacioxcb
string text = "Espacio:"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_espacioxcb
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_espacioxcb
end type

