HA$PBExportHeader$w_parametro_unidades_cortadasxgrupo.srw
forward
global type w_parametro_unidades_cortadasxgrupo from w_base_buscar_interactivo
end type
end forward

global type w_parametro_unidades_cortadasxgrupo from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer height = 637
end type
global w_parametro_unidades_cortadasxgrupo w_parametro_unidades_cortadasxgrupo

on w_parametro_unidades_cortadasxgrupo.create
call super::create
end on

on w_parametro_unidades_cortadasxgrupo.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_parametro_unidades_cortadasxgrupo
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_parametro_unidades_cortadasxgrupo
end type

event pb_buscar::clicked;call super::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = TRUE
lstr_parametros.cadena[1]=sle_parametro1.text


OpenSheetWithParm(w_preview_unidades_cortadas, lstr_parametros, w_principal, 1, Layered!)
close (parent)
//CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_parametro_unidades_cortadasxgrupo
string text = "GRUPO:"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_parametro_unidades_cortadasxgrupo
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_parametro_unidades_cortadasxgrupo
end type

