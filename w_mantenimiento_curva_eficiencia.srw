HA$PBExportHeader$w_mantenimiento_curva_eficiencia.srw
forward
global type w_mantenimiento_curva_eficiencia from w_base_maestroff_detalletb
end type
end forward

global type w_mantenimiento_curva_eficiencia from w_base_maestroff_detalletb
integer x = 0
integer y = 0
integer width = 2327
integer height = 1488
string title = "Administraci$$HEX1$$f300$$ENDHEX$$n de Curvas de Eficiencia"
string menuname = "m_mantenimiento_maestro_detalle"
end type
global w_mantenimiento_curva_eficiencia w_mantenimiento_curva_eficiencia

type variables
datawindowchild idw_planta, idw_salon
end variables

on w_mantenimiento_curva_eficiencia.create
call super::create
if this.MenuName = "m_mantenimiento_maestro_detalle" then this.MenuID = create m_mantenimiento_maestro_detalle
end on

on w_mantenimiento_curva_eficiencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;this.width = 2327
this.height = 1488

dw_maestro.getchild('co_planta',idw_planta)
dw_maestro.getchild('co_salon',idw_salon)

idw_planta.settransobject(sqlca)
idw_salon.settransobject(sqlca)

IF idw_planta.Retrieve(0) = 0 THEN
	idw_planta.InsertRow(0)
END IF

IF idw_salon.Retrieve(0,0,0) = 0 THEN
	idw_salon.InsertRow(0)
END IF


end event

event ue_insertar_maestro;call super::ue_insertar_maestro;long ll_curva
string ls_usuario, ls_instancia
DateTime 			ldt_fechahora

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia

dw_maestro.getchild('co_planta',idw_planta)
dw_maestro.getchild('co_salon',idw_salon)

idw_planta.settransobject(sqlca)
idw_salon.settransobject(sqlca)

IF idw_planta.Retrieve(0) = 0 THEN
	idw_planta.InsertRow(0)
END IF

IF idw_salon.Retrieve(0,0,0) = 0 THEN
	idw_salon.InsertRow(0)
END IF
ldt_fechahora = f_fecha_servidor()
dw_maestro.setitem(il_fila_actual_maestro ,'fe_creacion',ldt_fechahora)
dw_maestro.setitem(il_fila_actual_maestro ,'fe_actualizacion',ldt_fechahora)
dw_maestro.setitem(il_fila_actual_maestro ,'instancia',ls_instancia)
dw_maestro.setitem(il_fila_actual_maestro ,'usuario',ls_usuario)

SELECT max(co_curva)
  INTO :ll_curva
  FROM m_curva_eficiencia;
  
IF SQLCA.SQLCODE = -1 THEN
	messagebox(this.title, "Error de Base de Datos, al seleccionar el m$$HEX1$$e100$$ENDHEX$$ximo c$$HEX1$$f300$$ENDHEX$$digo de curva.", stopsign!)	
	return -1
END IF

IF ll_curva = 0 OR ISNULL(ll_curva) THEN
	ll_curva = 1
ELSE
	ll_curva = ll_curva + 1
END IF
 
dw_maestro.setitem(il_fila_actual_maestro ,'co_curva',ll_curva)
dw_maestro.SetRow(1)
dw_maestro.ScrollToRow(1)
dw_maestro.SetColumn(2)


end event

event ue_insertar_detalle;DateTime 			ldt_fechahora

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



/////////////////////////////////////////////////////////////////////////
// En este evento se inserta un registro en el detalle.
/////////////////////////////////////////////////////////////////////////

Long ll_fila, ll_curva, ll_secuencia

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
//				dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", DateTime(Today(), Now()))
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
IF il_fila_actual_maestro > 0 THEN
	ll_curva = dw_maestro.Getitemnumber(il_fila_actual_maestro,"co_curva")
	
	IF IsNull(ll_curva) THEN
		dw_detalle.DeleteRow(il_fila_actual_detalle)
		il_fila_actual_detalle = il_fila_actual_detalle - 1
	ELSE
		dw_detalle.SetItem(il_fila_actual_detalle,"co_curva",ll_curva)
		SELECT max(cs_secuencia)
		  INTO :ll_secuencia
		  FROM dt_curva_eficienci
		 WHERE co_curva = :ll_curva;
		
		IF SQLCA.SQLCODE = -1 THEN 
			messagebox(this.title,'Error de Base de Datos, al seleccionar la m$$HEX1$$e100$$ENDHEX$$xima secuencia de porcentaje de curva.', stopsign!)
			return -1
		END IF
		
		IF ll_secuencia = 0 OR ISNULL(ll_secuencia) THEN
			ll_secuencia = 1
		ELSE
			ll_secuencia = ll_secuencia + 1
	   END IF
		ldt_fechahora = f_fecha_servidor()
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", ldt_fechahora)
		dw_detalle.SetItem(il_fila_actual_detalle,"cs_secuencia",ll_secuencia)		  
		dw_detalle.AcceptText()
	END IF
END IF

end event

event ue_buscar;///////////////////////////////////////////////////////////////////
// En este evento se detecta si hubo cambios en el datawindow
// maestro y asigna valores a las variables de instancia is_cambio y
// is_accion. ademas se deja comentariado el script de hacer la
// busqueda, para que sea adpatado, de acuerdo a la ventana que se
// este contruyendo.
///////////////////////////////////////////////////////////////////

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
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios  en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

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
long ll_hallados, ll_curva

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_buscar_curva_eficiencia)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ll_curva =lstr_parametros.entero[1]

		ll_hallados = dw_maestro.Retrieve(ll_curva)
		IF isnull(ll_hallados) THEN
			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
		ELSE
			CHOOSE CASE ll_hallados
				CASE -1
					il_fila_actual_maestro = -1
					MessageBox("Error buscando","Error de la base",StopSign!,&
                         Ok!)
				CASE 0
					il_fila_actual_maestro = 0
					MessageBox("Sin Datos","No hay datos para su criterio",&
                         Exclamation!,Ok!)
				CASE ELSE
					il_fila_actual_maestro = 1
					dw_detalle.retrieve(ll_curva)
//					MessageBox("Busqueda ok","registros encontrados: "+&
//             	String(ll_hallados),Information!,Ok!)
			END CHOOSE
		END IF
	ELSE
		dw_maestro.reset()
	END IF
ELSE
END IF

end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_mantenimiento_curva_eficiencia
integer x = 14
integer y = 8
integer width = 1998
integer height = 236
boolean titlebar = false
string dataobject = "dff_mantenimiento_curva_eficiencia"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_mantenimiento_curva_eficiencia
integer y = 276
integer width = 2226
integer height = 948
boolean titlebar = false
string dataobject = "dtb_mantenimiento_detalle_curva"
borderstyle borderstyle = stylelowered!
end type

event dw_detalle::itemchanged;call super::itemchanged;long ll_dias, ll_fila,li_dia_inicio,li_dia_fin,li_cs_secuencia,li_dia_fin_ant,ll_fila_ant

dw_detalle.accepttext()
ll_fila = dw_detalle.getrow()

CHOOSE CASE dwo.name
	CASE 'nu_dias'
			ll_dias = dw_detalle.getitemnumber(ll_fila, 'nu_dias')		
			
			IF ll_dias = 999 THEN
				dw_detalle.setitem(ll_fila, 'observacion', '<<RESTANTES>>')	
			END IF
			
			li_cs_secuencia = dw_detalle.getitemnumber(ll_fila, 'cs_secuencia')		
						
			IF li_cs_secuencia=1 THEN
				li_dia_inicio	=0
			ELSE
				ll_fila_ant		=ll_fila - 1
				li_dia_fin_ant	=dw_detalle.getitemnumber(ll_fila_ant, 'dia_fin')
				li_dia_inicio	=li_dia_fin_ant
			END IF
			
			li_dia_fin		=li_dia_inicio + ll_dias
			
			dw_detalle.setitem(ll_fila, 'dia_inicio', li_dia_inicio)	
			dw_detalle.setitem(ll_fila, 'dia_fin', li_dia_fin)	
			
END CHOOSE

end event

