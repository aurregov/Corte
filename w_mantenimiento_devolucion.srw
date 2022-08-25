HA$PBExportHeader$w_mantenimiento_devolucion.srw
forward
global type w_mantenimiento_devolucion from w_base_tabular
end type
end forward

global type w_mantenimiento_devolucion from w_base_tabular
integer height = 1048
string title = "Maestro de Anulaciones"
end type
global w_mantenimiento_devolucion w_mantenimiento_devolucion

on w_mantenimiento_devolucion.create
call super::create
end on

on w_mantenimiento_devolucion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;dw_maestro.Retrieve()
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_devolucion
integer y = 60
integer width = 1239
integer height = 760
string dataobject = "dgr_motivos_anulacion"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_devolucion
boolean visible = false
integer width = 73
integer height = 52
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_devolucion
boolean visible = false
integer x = 265
integer y = 0
integer width = 59
integer height = 52
end type

