HA$PBExportHeader$w_buscar_cb_oc_raya_espacio.srw
forward
global type w_buscar_cb_oc_raya_espacio from w_base_buscar_interactivo
end type
end forward

global type w_buscar_cb_oc_raya_espacio from w_base_buscar_interactivo
end type
global w_buscar_cb_oc_raya_espacio w_buscar_cb_oc_raya_espacio

on w_buscar_cb_oc_raya_espacio.create
call super::create
end on

on w_buscar_cb_oc_raya_espacio.destroy
call super::destroy
end on

event open;call super::open;sle_parametro1.setfocus()
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_cb_oc_raya_espacio
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_cb_oc_raya_espacio
end type

event pb_buscar::clicked;call super::clicked;String 				ls_cadena
Long 				li_posicion
s_base_parametros lstr_parametros

ls_cadena = sle_parametro1.text

lstr_parametros.hay_parametros = TRUE
lstr_parametros.entero[1] = Long(Trim(Mid(ls_cadena, 1, 7)))
lstr_parametros.entero[2] = Long(Trim(Mid(ls_cadena, 8,3)))
lstr_parametros.entero[3] = Long(Trim(Mid(ls_cadena, 11,3)))
CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_cb_oc_raya_espacio
integer x = 73
integer width = 338
string text = "C$$HEX1$$f300$$ENDHEX$$digo Barras: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_cb_oc_raya_espacio
integer x = 407
integer width = 750
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_cb_oc_raya_espacio
end type

