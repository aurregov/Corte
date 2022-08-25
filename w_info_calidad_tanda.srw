HA$PBExportHeader$w_info_calidad_tanda.srw
forward
global type w_info_calidad_tanda from w_tallas_liberacion
end type
end forward

global type w_info_calidad_tanda from w_tallas_liberacion
integer width = 3177
integer height = 1512
end type
global w_info_calidad_tanda w_info_calidad_tanda

on w_info_calidad_tanda.create
call super::create
end on

on w_info_calidad_tanda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_tallas_liberacion`dw_maestro within w_info_calidad_tanda
integer width = 3072
integer height = 1288
string dataobject = "dtb_info_calidad_tanda"
end type

