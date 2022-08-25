HA$PBExportHeader$w_maestro_etapas.srw
forward
global type w_maestro_etapas from w_base_tabular
end type
end forward

global type w_maestro_etapas from w_base_tabular
integer width = 2478
integer height = 1308
string title = "Maestro de Etapas"
string menuname = "m_mantenimiento_simple"
end type
global w_maestro_etapas w_maestro_etapas

on w_maestro_etapas.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_maestro_etapas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_maestro_etapas
integer y = 28
integer width = 2359
integer height = 1048
string dataobject = "dtb_maestro_etapas"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_maestro_etapas
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_maestro_etapas
boolean visible = false
end type

