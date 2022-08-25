HA$PBExportHeader$w_maestro_conceptos.srw
forward
global type w_maestro_conceptos from w_base_tabular
end type
end forward

global type w_maestro_conceptos from w_base_tabular
integer width = 1458
integer height = 1196
string title = "Maestro de Conceptos"
string menuname = "m_mantenimiento_simple"
end type
global w_maestro_conceptos w_maestro_conceptos

on w_maestro_conceptos.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_maestro_conceptos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_maestro_conceptos
integer y = 20
integer width = 1326
integer height = 780
string title = "m_mantenimiento_simple"
string dataobject = "dtb_maestro_conceptos"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_maestro_conceptos
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_maestro_conceptos
boolean visible = false
end type

