HA$PBExportHeader$w_buscar_estilos.srw
forward
global type w_buscar_estilos from w_base_buscar_lista_parametro
end type
end forward

global type w_buscar_estilos from w_base_buscar_lista_parametro
integer width = 2203
integer height = 1748
end type
global w_buscar_estilos w_buscar_estilos

on w_buscar_estilos.create
call super::create
end on

on w_buscar_estilos.destroy
call super::destroy
end on

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_estilos
integer width = 325
string text = "Buscar Estilo:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_estilos
integer x = 375
integer y = 36
integer width = 1010
textcase textcase = upper!
string mask = ""
end type

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_estilos
integer x = 475
integer y = 1356
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_estilos
integer x = 1074
integer y = 1472
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_estilos
integer x = 517
integer y = 1472
end type

event pb_aceptar::clicked;call super::clicked;
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_linea")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
	lstr_parametros.cadena[1]=dw_lista.getitemString(il_fila_actual,"de_linea")
	lstr_parametros.cadena[2]=dw_lista.getitemString(il_fila_actual,"de_referencia")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF
end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_estilos
integer width = 2144
integer height = 1160
string dataobject = "dtb_buscar_estilosxdescripcion"
end type

