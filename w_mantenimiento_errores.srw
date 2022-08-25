HA$PBExportHeader$w_mantenimiento_errores.srw
$PBExportComments$OBJETO MANTENIMIENTO- Ventana heredada de w_base_tabular utilizada para el mantenimiento de Errores de la Base de Datos.
forward
global type w_mantenimiento_errores from w_base_tabular
end type
end forward

global type w_mantenimiento_errores from w_base_tabular
integer x = 0
integer y = 0
integer width = 2775
integer height = 1264
string title = "Errores Base de Datos"
end type
global w_mantenimiento_errores w_mantenimiento_errores

on w_mantenimiento_errores.create
call super::create
end on

on w_mantenimiento_errores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
this.width = 2775
this.height = 1265
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_errores
integer x = 23
integer y = 116
integer width = 2688
integer height = 948
string dataobject = "dtb_mantenimiento_errores"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_errores
integer y = 20
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_errores
integer y = 28
long textcolor = 8388608
end type

