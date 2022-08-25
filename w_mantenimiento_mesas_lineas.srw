HA$PBExportHeader$w_mantenimiento_mesas_lineas.srw
forward
global type w_mantenimiento_mesas_lineas from w_base_tabular
end type
end forward

global type w_mantenimiento_mesas_lineas from w_base_tabular
integer width = 2217
integer height = 1864
string title = "Estados de Producci$$HEX1$$f300$$ENDHEX$$n Corte"
end type
global w_mantenimiento_mesas_lineas w_mantenimiento_mesas_lineas

on w_mantenimiento_mesas_lineas.create
call super::create
end on

on w_mantenimiento_mesas_lineas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_mesas_lineas
integer x = 46
integer y = 36
integer width = 2112
integer height = 1592
string dataobject = "dtb_mantenimiento_mesas_lineas"
end type

event dw_maestro::itemchanged;
IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
END IF

end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_mesas_lineas
boolean visible = false
integer y = 24
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_mesas_lineas
boolean visible = false
integer y = 36
long backcolor = 81324524
end type

