HA$PBExportHeader$w_observacion_corte.srw
forward
global type w_observacion_corte from w_base_tabular
end type
end forward

global type w_observacion_corte from w_base_tabular
integer width = 3090
integer height = 1088
string title = "Estados de Producci$$HEX1$$f300$$ENDHEX$$n Corte"
string menuname = "m_mantenimiento_simple"
end type
global w_observacion_corte w_observacion_corte

type variables
Long il_orden_corte
end variables

on w_observacion_corte.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_observacion_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insertar_maestro;Long ll_fila

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
	dw_maestro.SetItem(il_fila_actual_maestro, "cs_observa", il_fila_actual_maestro)
	dw_maestro.SetItem(il_fila_actual_maestro, "cs_orden_corte", il_orden_corte)
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
END IF

end event

event open;LONG		ll_cs_orden_corte
s_base_parametros lstr_parametros

This.X = 1
This.Y = 1

dw_maestro.SetTransObject(sqlca)

lstr_parametros = Message.PowerObjectParm

il_orden_corte = lstr_parametros.entero[1]

IF lstr_parametros.Hay_Parametros	=	TRUE	THEN
	dw_maestro.Retrieve(il_orden_corte)
ELSE
	MessageBox(this.title, "No hay parametros de busqueda")
END IF
end event

event ue_buscar;String ls
end event

type dw_maestro from w_base_tabular`dw_maestro within w_observacion_corte
integer x = 46
integer y = 124
integer width = 2944
integer height = 640
string dataobject = "dtb_observa_oc"
end type

event dw_maestro::itemchanged;IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
END IF
end event

type sle_argumento from w_base_tabular`sle_argumento within w_observacion_corte
boolean visible = false
integer y = 24
end type

type st_1 from w_base_tabular`st_1 within w_observacion_corte
boolean visible = false
integer y = 36
long backcolor = 81324524
end type

