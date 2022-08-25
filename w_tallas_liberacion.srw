HA$PBExportHeader$w_tallas_liberacion.srw
forward
global type w_tallas_liberacion from w_base_simple
end type
end forward

global type w_tallas_liberacion from w_base_simple
integer width = 1381
integer height = 1136
end type
global w_tallas_liberacion w_tallas_liberacion

event open;n_cts_param luo_param

luo_param = Message.PowerObjectParm
IF IsValid(luo_param) THEN
	dw_maestro.SetTransObject(SQLCA)
	dw_maestro.Retrieve(luo_param.il_vector[1], luo_param.il_vector[2], luo_param.il_vector[3])
END IF
end event

on w_tallas_liberacion.create
call super::create
end on

on w_tallas_liberacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_base_simple`dw_maestro within w_tallas_liberacion
integer x = 32
integer y = 24
integer width = 1294
integer height = 884
string dataobject = "dtb_tallas_liberacion"
boolean border = true
end type

