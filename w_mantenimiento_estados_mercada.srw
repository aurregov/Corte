HA$PBExportHeader$w_mantenimiento_estados_mercada.srw
forward
global type w_mantenimiento_estados_mercada from w_base_tabular
end type
end forward

global type w_mantenimiento_estados_mercada from w_base_tabular
integer width = 1280
integer height = 1500
string title = "Estados Mercada"
end type
global w_mantenimiento_estados_mercada w_mantenimiento_estados_mercada

on w_mantenimiento_estados_mercada.create
call super::create
end on

on w_mantenimiento_estados_mercada.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;This.width = 1280
This.height = 1500
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_estados_mercada
integer y = 100
integer width = 1193
integer height = 1176
string dataobject = "dtb_estados_mercada"
boolean hscrollbar = false
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_estados_mercada
integer x = 302
integer y = 16
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_estados_mercada
integer x = 32
end type

