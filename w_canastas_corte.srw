HA$PBExportHeader$w_canastas_corte.srw
forward
global type w_canastas_corte from w_base_tabular
end type
end forward

global type w_canastas_corte from w_base_tabular
integer width = 3186
integer height = 1592
string title = "Canastas"
end type
global w_canastas_corte w_canastas_corte

on w_canastas_corte.create
call super::create
end on

on w_canastas_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;f_rcpra_dtos_dddw_param1(dw_maestro, "co_modulo", sqlca, 91, 1)

This.x = 1
This.y = 1

m_mantenimiento_simple.m_edicion.m_insertarmaestro.Enabled = false
m_mantenimiento_simple.m_edicion.m_borrarmaestro.Enabled = false
m_mantenimiento_simple.m_edicion.m_buscar.Enabled = false

dw_maestro.SetTransObject(SQLCA)

dw_maestro.Retrieve()
end event

type dw_maestro from w_base_tabular`dw_maestro within w_canastas_corte
integer y = 4
integer width = 3081
integer height = 1216
string dataobject = "dgr_dt_canastas_corte"
boolean hscrollbar = false
end type

type sle_argumento from w_base_tabular`sle_argumento within w_canastas_corte
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_canastas_corte
boolean visible = false
end type

