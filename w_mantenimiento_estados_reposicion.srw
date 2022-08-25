HA$PBExportHeader$w_mantenimiento_estados_reposicion.srw
forward
global type w_mantenimiento_estados_reposicion from w_base_tabular
end type
end forward

global type w_mantenimiento_estados_reposicion from w_base_tabular
integer width = 1280
integer height = 1500
string title = "Estados Reposici$$HEX1$$f300$$ENDHEX$$n"
end type
global w_mantenimiento_estados_reposicion w_mantenimiento_estados_reposicion

on w_mantenimiento_estados_reposicion.create
call super::create
end on

on w_mantenimiento_estados_reposicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;This.width = 1280
This.height = 1500
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_estados_reposicion
integer y = 100
integer width = 1193
integer height = 1176
string dataobject = "dtb_estados_reposicion"
boolean hscrollbar = false
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_estados_reposicion
integer x = 302
integer y = 16
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_estados_reposicion
integer x = 32
end type

