HA$PBExportHeader$w_buscar_modulo_fisico.srw
forward
global type w_buscar_modulo_fisico from w_base_buscar_lista
end type
end forward

global type w_buscar_modulo_fisico from w_base_buscar_lista
int Width=2217
boolean TitleBar=true
string Title="B$$HEX1$$fa00$$ENDHEX$$scar M$$HEX1$$f300$$ENDHEX$$dulo F$$HEX1$$ed00$$ENDHEX$$sico"
end type
global w_buscar_modulo_fisico w_buscar_modulo_fisico

on w_buscar_modulo_fisico.create
call super::create
end on

on w_buscar_modulo_fisico.destroy
call super::destroy
end on

event open;call super::open;this.x = 500
this.y = 500
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_modulo_fisico
int X=599
int Y=620
int Width=1038
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_modulo_fisico
int X=1198
end type

event pb_cancelar::clicked;
s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_modulo_fisico
int X=640
end type

event pb_aceptar::clicked;
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_planta")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_tipoprod")
	lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"co_salon")
	lstr_parametros.entero[5]=dw_lista.getitemnumber(il_fila_actual,"co_modulo_fis")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_modulo_fisico
int X=32
int Width=2135
string DataObject="dtb_buscar_modulo_logico"
boolean HScrollBar=false
end type

