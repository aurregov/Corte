HA$PBExportHeader$w_buscar_kamban_centros.srw
forward
global type w_buscar_kamban_centros from w_base_buscar_interactivo
end type
end forward

global type w_buscar_kamban_centros from w_base_buscar_interactivo
string title = "Buscar Ordenes de Corte"
end type
global w_buscar_kamban_centros w_buscar_kamban_centros

on w_buscar_kamban_centros.create
call super::create
end on

on w_buscar_kamban_centros.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_kamban_centros
integer taborder = 30
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_kamban_centros
integer taborder = 20
end type

event pb_buscar::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = True
lstr_parametros.entero[1]=Long(Trim(sle_parametro1.text))
CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_kamban_centros
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_kamban_centros
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_kamban_centros
end type

