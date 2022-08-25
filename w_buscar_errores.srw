HA$PBExportHeader$w_buscar_errores.srw
$PBExportComments$OBJETO MANTENIMIENTO - Ventana utilizada para buscar errores de la base de datos. Es invocada por w_mantenimiento_errores.
forward
global type w_buscar_errores from w_base_buscar_lista
end type
end forward

global type w_buscar_errores from w_base_buscar_lista
int X=105
int Y=384
int Width=2729
int Height=1148
boolean TitleBar=true
string Title="Buscar Errores"
end type
global w_buscar_errores w_buscar_errores

on w_buscar_errores.create
call super::create
end on

on w_buscar_errores.destroy
call super::destroy
end on

event open;call super::open;This.Width = 2730
This.Height = 1149
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_errores
int X=562
int Y=788
int Width=1367
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_errores
int X=1394
int Y=900
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_errores
int X=786
int Y=900
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = TRUE

//////////////////////////////////////////////////////////////////////////
// En las siguientes ds lineas, se esta guardando el contenido de las
// columnas dbms y co_error de la fila activa.
//////////////////////////////////////////////////////////////////////////

lstr_parametros.cadena[1]=dw_lista.getitemstring(il_fila_actual,"dbms")
lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_error")

closewithreturn(parent,lstr_parametros)
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_errores
int Width=2656
int Height=728
string DataObject="dtb_buscar_errores"
boolean VScrollBar=true
end type

