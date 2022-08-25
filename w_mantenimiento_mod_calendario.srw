HA$PBExportHeader$w_mantenimiento_mod_calendario.srw
forward
global type w_mantenimiento_mod_calendario from w_base_maestroff_detalletb
end type
end forward

global type w_mantenimiento_mod_calendario from w_base_maestroff_detalletb
integer x = 0
integer y = 0
integer width = 2702
integer height = 1632
string title = "Administraci$$HEX1$$f300$$ENDHEX$$n de  Modificaciones al Calendario"
string menuname = "m_mantenimiento_maestro_detalle"
end type
global w_mantenimiento_mod_calendario w_mantenimiento_mod_calendario

type variables
long il_fabrica, il_planta, il_modulo
end variables

on w_mantenimiento_mod_calendario.create
call super::create
if this.MenuName = "m_mantenimiento_maestro_detalle" then this.MenuID = create m_mantenimiento_maestro_detalle
end on

on w_mantenimiento_mod_calendario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;///////////////////////////////////////////////////////////////////////////////////////////////
// Luego de haberse verificado si hubo cambios en el mastro (script del padre),
// en este script se verifica si hubo cambios en el detalle.
///////////////////////////////////////////////////////////////////////////////////////////////

IF (is_cambios = "no" AND is_accion = "nada") OR (is_cambios = "si" AND is_accion <> "cancelo") THEN
	CHOOSE CASE wf_detectar_cambios (dw_detalle)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		message.returnvalue = 1
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		// No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados en el detalle...","Desea grabar los cambios del maestro y el detalle",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				message.returnvalue = 1
				RETURN
		END CHOOSE
	END CHOOSE
END IF

////////////////////////////////////////////////////////////////////
//Las siguientes lineas se deben acondicionar seg$$HEX1$$fa00$$ENDHEX$$n la ventana.
///////////////////////////////////////////////////////////////////
s_base_parametros lstr_parametros
long ll_hallados

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_buscar_modulo_logico)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		il_fabrica = lstr_parametros.entero[1]
		il_planta  = lstr_parametros.entero[2]
		il_modulo  = lstr_parametros.entero[3]

		ll_hallados = dw_maestro.Retrieve(il_fabrica, il_planta, il_modulo)
		ll_hallados = dw_detalle.Retrieve(il_fabrica, il_planta, il_modulo)
	END IF
END IF

end event

event open;call super::open;This.width = 2702
This.height = 1632

m_mantenimiento_maestro_detalle.m_edicion.m_insertarmaestro.enabled = false
m_mantenimiento_maestro_detalle.m_edicion.m_borrarmaestro.enabled = false




end event

event ue_insertar_detalle;/////////////////////////////////////////////////////////////////////////
// En este evento se inserta un registro en el detalle.
/////////////////////////////////////////////////////////////////////////

Long ll_fila

/////////////////////////////////////////////////////////////////////////
// Lo primero que se debe tener presente antes de insertar un registro
// en el detalle, es que se haya seleccionado un registro del maestro;
// por eso se hace la pregunta si il_fila_actual_maestro > 0.
/////////////////////////////////////////////////////////////////////////

il_fila_actual_maestro = dw_maestro.getrow()

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
				dw_detalle.SetItem(il_fila_actual_detalle, "fe_actualizacion", DateTime(Today(), Now()))
				dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
				dw_detalle.SetItem(il_fila_actual_detalle, "instancia", gstr_info_usuario.instancia)
				dw_detalle.SetItem(il_fila_actual_detalle, "co_fabrica",il_fabrica)
				dw_detalle.SetItem(il_fila_actual_detalle, "co_planta", il_planta)
				dw_detalle.SetItem(il_fila_actual_detalle, "co_modulo", il_modulo)
			ELSE
			END IF
		END IF
	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
END IF

////////////////////////////////////////////////////////////////////
// Cuando herede debe capturar los campos claves del maestro en
// variables locales y asignarselas al registro insertado en el 
// detalle
////////////////////////////////////////////////////////////////////
//IF il_fila_actual_maestro > 0 THEN
//	clave1 = dw_maestro.GetitemString(il_fila_actual_maestro,"clave 1")
//	clave2 = dw_maestro.GetitemString(il_fila_actual_maestro,"clave 2")
//	......
//	IF IsNull(clave1) OR IsNull(clave2) THEN
//		dw_detalle.DeleteRow(il_fila_actual_detalle)
//		il_fila_actual_detalle = il_fila_actual_detalle - 1
//	ELSE
//		dw_detalle.SetItem(il_fila_actual_detalle,"clave 1",clave1)
//		dw_detalle.SetItem(il_fila_actual_detalle,"clave 2",clave2)
//		dw_detalle.AcceptText()
//	END IF
//END IF
////////////////////////////////////////////////////////////////////





end event

event ue_grabar;//////////////////////////////////////////////////////////////////////////
// En este evento se realizar ACCEPTTEXT para llevar los cambios 
// del detalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////


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


end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_mantenimiento_mod_calendario
integer x = 37
integer y = 28
integer width = 2254
integer height = 332
boolean titlebar = false
string dataobject = "dff_maestro_modulo_logico"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_mantenimiento_mod_calendario
integer x = 37
integer y = 408
integer width = 2610
integer height = 1012
boolean titlebar = false
string dataobject = "dtb_detalle_mod_calendario"
boolean hscrollbar = false
boolean hsplitscroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_detalle::itemchanged;call super::itemchanged;LONG ll_ano, ll_mes, ll_dia, ll_fila, ll_semana, ll_co_dia
DATE ld_fecha_festivo, ld_fecha

dw_detalle.accepttext()
ll_fila = dw_detalle.getrow()

CHOOSE CASE dwo.name
	CASE 'dia'
		ll_ano = dw_detalle.getitemnumber(ll_fila, 'ano')
		ll_mes = dw_detalle.getitemnumber(ll_fila, 'mes')
		ll_dia = dw_detalle.getitemnumber(ll_fila, 'dia')
		
		SELECT semana,
		       co_dia
		  INTO :ll_semana,
		       :ll_co_dia
		  FROM m_calendario_cont
		 WHERE ano = :ll_ano and
		       mes = :ll_mes and
				 dia = :ll_dia ;
				 
		IF SQLCA.SQLCODE = -1 THEN
			messagebox(parent.title,'Error de base de datos, al seleccionar la semana del calendario general.', stopsign!)
			RETURN 
		ELSE
			IF SQLCA.SQLCODE = 100 THEN
				messagebox(parent.title,'Error de base de datos, La fecha ingresada no se encuentra resgistrada en el calendario general.', stopsign!)
				RETURN 
			END IF
		END IF
		
		dw_detalle.setitem(ll_fila, 'semana', ll_semana)
		dw_detalle.setitem(ll_fila, 'co_dia', ll_co_dia)
		
		ld_fecha = date(ll_ano,ll_mes, ll_dia)
		
		dw_detalle.setitem(ll_fila, 'fe_mod_calendario', ld_fecha)
		
		SELECT fec_festivo
		  INTO :ld_fecha_festivo
		  FROM m_festivos
		 WHERE fec_festivo = :ld_fecha;
		
		IF SQLCA.SQLCODE = -1 THEN
			messagebox(parent.title, 'Error de Base de Datos, al validar la fecha en la tabla de festivos.', stopsign!)
			return
		END IF		
		
		IF ld_fecha_festivo = date(01/01/1900) THEN
			dw_detalle.setitem(ll_fila, 'co_tipo_dia', 'D')
		else
			dw_detalle.setitem(ll_fila, 'co_tipo_dia', 'F')
		END IF		
		
END CHOOSE

end event

event dw_detalle::updatestart;//hacer ciclo para grabar todas las fechas de fe_mod_calendario
LONG				ll_filas,ll_filaactual,ll_ano,ll_mes,ll_dia
DATE				ld_fecha

IF il_fila_actual_detalle > 0 THEN
	dw_detalle.AcceptText()
	ll_filas = dw_detalle.RowCount()

	FOR ll_filaactual = 1 TO ll_filas
		
		//debe actualizar 
		ll_ano = dw_detalle.getitemnumber(ll_filaactual, 'ano')
		ll_mes = dw_detalle.getitemnumber(ll_filaactual, 'mes')
		ll_dia = dw_detalle.getitemnumber(ll_filaactual, 'dia')
						
		ld_fecha = date(ll_ano,ll_mes, ll_dia)
		
		dw_detalle.setitem(ll_filaactual, 'fe_mod_calendario', ld_fecha)
		
		dw_detalle.AcceptText()
		
	END FOR
ELSE
END IF

end event

