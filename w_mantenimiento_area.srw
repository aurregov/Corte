HA$PBExportHeader$w_mantenimiento_area.srw
forward
global type w_mantenimiento_area from w_base_tabular
end type
end forward

global type w_mantenimiento_area from w_base_tabular
integer width = 1504
integer height = 1864
string title = "Estados de Producci$$HEX1$$f300$$ENDHEX$$n Corte"
string menuname = "m_mantenimiento_simple"
end type
global w_mantenimiento_area w_mantenimiento_area

on w_mantenimiento_area.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_mantenimiento_area.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insertar_maestro;long ll_fila

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"	
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				dw_maestro.Reset()
				is_accion = "no grabo"
				// NO GRABA Y SIGUE LA INSERCION
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

//dw_maestro.Reset()
ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
//	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
//	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
//	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
//	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
END IF

end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_area
integer x = 46
integer width = 1353
integer height = 1472
string dataobject = "dgr_mantenimiento_area"
end type

event dw_maestro::itemchanged;//IF il_fila_actual_maestro > 0 THEN
//	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
//	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
//	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
//	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
//END IF
end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_area
integer y = 24
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_area
integer y = 36
long backcolor = 81324524
end type

