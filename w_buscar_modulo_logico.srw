HA$PBExportHeader$w_buscar_modulo_logico.srw
forward
global type w_buscar_modulo_logico from w_base_buscar_lista
end type
end forward

global type w_buscar_modulo_logico from w_base_buscar_lista
int X=567
int Y=192
int Width=2382
int Height=1760
boolean TitleBar=true
string Title="B$$HEX1$$fa00$$ENDHEX$$scar M$$HEX1$$f300$$ENDHEX$$dulo L$$HEX1$$f300$$ENDHEX$$gico"
end type
global w_buscar_modulo_logico w_buscar_modulo_logico

on w_buscar_modulo_logico.create
call super::create
end on

on w_buscar_modulo_logico.destroy
call super::destroy
end on

event open;call super::open;this.x = 500
this.y = 500
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_modulo_logico
int Y=1392
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_modulo_logico
int X=1088
int Y=1504
end type

event pb_cancelar::clicked;
s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_modulo_logico
int X=530
int Y=1504
end type

event pb_aceptar::clicked;
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_planta")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_modulo")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_modulo_logico
int X=23
int Width=2309
int Height=1312
string DataObject="dtb_buscar_modulo_logico"
boolean HScrollBar=false
end type

