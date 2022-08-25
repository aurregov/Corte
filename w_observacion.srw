HA$PBExportHeader$w_observacion.srw
forward
global type w_observacion from w_base_maestroff_detalletb
end type
end forward

global type w_observacion from w_base_maestroff_detalletb
integer width = 2501
string title = "Observaciones"
end type
global w_observacion w_observacion

type variables
datawindowchild idw_area
end variables

on w_observacion.create
call super::create
end on

on w_observacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;n_cts_param luo_param
THIS.X = 1000
THIS.Y = 700
THIS.width = 2501
THIS.height = 1228

luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If


dw_maestro.getchild('co_area',idw_area)

idw_area.settransobject(sqlca)
dw_maestro.insertrow(0)
end event

event ue_insertar_detalle;/////////////////////////////////////////////////////////////////////////
// En este evento se inserta un registro en el detalle.
/////////////////////////////////////////////////////////////////////////
n_cts_param luo_param
Long ll_fila,ll_area

luo_param = Message.PowerObjectParm


/////////////////////////////////////////////////////////////////////////
// Lo primero que se debe tener presente antes de insertar un registro
// en el detalle, es que se haya seleccionado un registro del maestro;
// por eso se hace la pregunta si il_fila_actual_maestro > 0.
/////////////////////////////////////////////////////////////////////////

IF il_fila_actual_maestro > 0 THEN
	IF dw_detalle.AcceptText() = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del detalle porque habian ingresos previos con problemas" &
					,StopSign!)	
	ELSE
		ll_fila = dw_detalle.InsertRow(0)
		IF ll_fila = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
		ELSE
			dw_detalle.SetFocus()
			dw_detalle.SetRow(ll_fila)
			dw_detalle.ScrollToRow(ll_fila)
			dw_detalle.SetColumn(1)
			il_fila_actual_detalle = ll_fila 
   		dw_detalle.SelectRow(il_fila_actual_detalle,FALSE)
			il_fila_actual_detalle = dw_detalle.GetRow()
			IF ((il_fila_actual_detalle<> -1) and (NOT ISNULL (il_fila_actual_detalle)) and (il_fila_actual_detalle<>0))THEN
   			dw_detalle.SelectRow(il_fila_actual_detalle,TRUE)
	//			dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", f_fecha_servidor())
			ELSE
			END IF
		END IF
	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
END IF


IF il_fila_actual_maestro > 0 THEN
	ll_area = dw_maestro.getitemnumber(il_fila_actual_maestro,'co_area')

	If Not IsValid(luo_param) Then
		Return
	End If
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_simulacion",luo_param.il_vector[1])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_fabrica",luo_param.il_vector[2])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_planta",luo_param.il_vector[3] )
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_modulo",luo_param.il_vector[4])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_fabrica_exp",luo_param.il_vector[5])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_cs_liberacion",luo_param.il_vector[6])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_fabrica_pt",luo_param.il_vector[7])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_linea",luo_param.il_vector[8])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_referencia",luo_param.il_vector[9])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_co_color_pt",luo_param.il_vector[10])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_cs_particion",luo_param.il_vector[11])
	
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_po",luo_param.is_vector[1])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_tono",luo_param.is_vector[2])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_nu_cut",luo_param.is_vector[3])
	dw_detalle.SetItem(il_fila_actual_detalle,"dt_observaxmodulo_area",ll_area)

END IF






end event

event ue_grabar;is_accion = "si update"
IF is_accion = "si update" THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		Messagebox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			RETURN
		ELSE
			is_accion = "si update"
			COMMIT;
			IF SQLCA.SQLCode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
								,Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF

end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_observacion
integer x = 27
integer y = 40
integer height = 100
boolean titlebar = false
string title = "Area"
string dataobject = "dff_seleccion_area"
end type

event dw_maestro::itemchanged;n_cts_param luo_param
LONG ll_area
Long ll_fila

dw_maestro.AcceptText()

ll_fila = dw_maestro.GetRow()
il_fila_actual_maestro = ll_fila

CHOOSE CASE dwo.name
	CASE 'co_area'
			ll_area = dw_maestro.getitemnumber(ll_fila,'co_area')	
			dw_maestro.setitem(ll_fila,'area',string(ll_area))	
END CHOOSE

luo_param = Message.PowerObjectParm
ll_area = dw_maestro.getitemnumber(dw_maestro.getrow(),'co_area')

If Not IsValid(luo_param) Then
	Return
End If

dw_detalle.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
    			 luo_param.il_vector[4],luo_param.il_vector[5],luo_param.il_vector[6],&
				 luo_param.il_vector[7],luo_param.is_vector[1],luo_param.il_vector[8],&
				 luo_param.il_vector[9],luo_param.il_vector[10],luo_param.il_vector[11],&
				 luo_param.is_vector[2],luo_param.il_vector[12],luo_param.il_vector[13],ll_area)
								 
end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_observacion
integer x = 23
integer y = 156
integer width = 2395
integer height = 836
boolean titlebar = false
string title = "Observacion"
string dataobject = "dtb_observacion_modulo"
end type

event dw_detalle::itemchanged;IF il_fila_actual_detalle > 0 THEN
	dw_detalle.SetItem(il_fila_actual_detalle, "dt_observaxmodulo_fe_actualizacion", DateTime(Today(), Now()))
	dw_detalle.SetItem(il_fila_actual_detalle, "dt_observaxmodulo_fe_creacion", DateTime(Today(), Now()))
	dw_detalle.SetItem(il_fila_actual_detalle, "dt_observaxmodulo_usuario", gstr_info_usuario.codigo_usuario)
	dw_detalle.SetItem(il_fila_actual_detalle, "dt_observaxmodulo_instancia", gstr_info_usuario.instancia)
END IF
end event

