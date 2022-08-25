HA$PBExportHeader$w_buscar_curva_eficiencia.srw
forward
global type w_buscar_curva_eficiencia from w_base_buscar_lista
end type
end forward

global type w_buscar_curva_eficiencia from w_base_buscar_lista
int Width=1609
boolean TitleBar=true
string Title="Buscar Curva de Eficiencia"
end type
global w_buscar_curva_eficiencia w_buscar_curva_eficiencia

on w_buscar_curva_eficiencia.create
call super::create
end on

on w_buscar_curva_eficiencia.destroy
call super::destroy
end on

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_curva_eficiencia
int X=297
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_curva_eficiencia
int X=887
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_curva_eficiencia
int X=329
end type

event pb_aceptar::clicked;///////////////////////////////////////////////////////////////////
// En este evento se le asigna al campo entero de la estructura 
// s_base_parametros el contenido del campo clave de la fila actual.
///////////////////////////////////////////////////////////////////
//
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_curva")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_curva_eficiencia
int Width=1541
string DataObject="dtb_buscar_curva_eficiencia"
end type

