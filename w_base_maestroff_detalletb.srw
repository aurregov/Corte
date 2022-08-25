HA$PBExportHeader$w_base_maestroff_detalletb.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para hacer mantenimientos maestro-detalle con un freeform en el maestro y tabular en el detalle. Debe Heredarse y adaptar los eventos necesarios.
forward
global type w_base_maestroff_detalletb from w_base_simple
end type
type dw_detalle from uo_dtwndow within w_base_maestroff_detalletb
end type
end forward

global type w_base_maestroff_detalletb from w_base_simple
integer height = 1228
string menuname = "m_mantenimiento_maestro_detalle"
event ue_insertar_detalle pbm_custom05
event ue_borrar_detalle pbm_custom06
dw_detalle dw_detalle
end type
global w_base_maestroff_detalletb w_base_maestroff_detalletb

type variables
Long il_fila_actual_detalle
end variables

event ue_insertar_detalle;/////////////////////////////////////////////////////////////////////////
// En este evento se inserta un registro en el detalle.
/////////////////////////////////////////////////////////////////////////

Long ll_fila

/////////////////////////////////////////////////////////////////////////
// Lo primero que se debe tener presente antes de insertar un registro
// en el detalle, es que se haya seleccionado un registro del maestro;
// por eso se hace la pregunta si il_fila_actual_maestro > 0.
/////////////////////////////////////////////////////////////////////////

IF il_fila_actual_maestro > 0 THEN
	IF dw_detalle.AcceptText() = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del detalle porque habian ingresos previos con problemas" &
					,StopSign!)
		Return -1
	ELSE
		ll_fila = dw_detalle.InsertRow(0)
		IF ll_fila = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
			Return -2
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
				If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", f_fecha_servidor())
			ELSE
				Return -3
			END IF
		END IF
	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
END IF

Return 1
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

event ue_borrar_detalle;call super::ue_borrar_detalle;long ll_fila

ll_fila = dw_detalle.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
			ELSE
				il_fila_actual_detalle = ll_fila - 1
				This.TriggerEvent("ue_grabar")
			END IF
		ELSE
		END IF
END CHOOSE



end event

on w_base_maestroff_detalletb.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_maestro_detalle" then this.MenuID = create m_mantenimiento_maestro_detalle
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detalle
end on

on w_base_maestroff_detalletb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detalle)
end on

event closequery;call super::closequery;/////////////////////////////////////////////////////////////////////////
// Una  vez verificado si hubo o no cambios en el maestro, se verifica
// si hay cambios en el detalle.
/////////////////////////////////////////////////////////////////////////
 

IF (is_cambios = "no") OR (is_cambios = "si" AND is_accion = "no grabo") THEN
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
			CHOOSE CASE MessageBox("Cambios detectados en el detalle...",&
					                 "Desea grabar los cambios del maestro " + &
					                  "y el detalle",Question!,yesnocancel!,1)
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
ELSE
END IF
end event

event ue_borrar_maestro;///////////////////////////////////////////////////////////////////////
// Se omite el script del papa. Se verifica de que no existan 
// detalles asociados con el registro del maestro a borrar.
///////////////////////////////////////////////////////////////////////

Long ll_resultado

IF dw_detalle.RowCount() > 0 THEN
	MessageBox("Advertencia","El registro maestro seleccionado tiene detalles asociados, no se puede borrar",Exclamation!,OK!)
ELSE
	ll_resultado = w_base_simple::Event ue_borrar_maestro(ll_resultado,ll_resultado)
	Return ll_resultado
END IF
end event

event ue_buscar;call super::ue_buscar;///////////////////////////////////////////////////////////////////////////////////////////////
// Luego de haberse verificado si hubo cambios en el mastro (script del padre),
// en este script se verifica si hubo cambios en el detalle.
///////////////////////////////////////////////////////////////////////////////////////////////
Long ll_ret
IF (is_cambios = "no" AND is_accion = "nada") OR (is_cambios = "si" AND is_accion <> "cancelo") THEN
	CHOOSE CASE wf_detectar_cambios (dw_detalle)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		message.returnvalue = 1
		RETURN -1
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		RETURN 0	// No hay registros modificados en el Detalle
		// No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados en el detalle...","Desea grabar los cambios del maestro y el detalle",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
//				This.TriggerEvent("ue_grabar")
				ll_ret = This.Event ue_grabar(0,0)
				If ll_ret < 0 Then Return ll_ret
				RETURN 1	//	Logro grabar los datos del Detalle				
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
				RETURN 2
			CASE 3
				is_accion = "cancelo"
				message.returnvalue = 1
				RETURN 3
		END CHOOSE
	END CHOOSE
END IF

//////////////////////////////////////////////////////////////////	
// Si usted desea utilizar el buscar lista debe mirar el script
// del abuelo y copiar todo lo que esta comentariado en el script a 
// su ventana en este evento y adaptar la parte de buscar a su 
//	datawindow. y adicionar despues de que sea exitoso el retrieve del
//	maestro la siguiente linea :
//		dw_detalle.Retrieve(argumentos)					
// adaptando argumentos segun la datawindow de detalle
//////////////////////////////////////////////////////////////////	

end event

event ue_grabar;call super::ue_grabar;//////////////////////////////////////////////////////////////////////////
// En este evento se realizar ACCEPTTEXT para llevar los cambios 
// del detalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////

IF is_accion = "si update" THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		Messagebox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN -1
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			RETURN -2
		ELSE
			is_accion = "si update"
			COMMIT;
			IF SQLCA.SQLCode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
								,Exclamation!,Ok!)
				RETURN -3
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF

RETURN 1
end event

event ue_insertar_maestro;////////////////////////////////////////////////////////////////////////
// Se omite el script del papa.
// Se adicionan las lineas necesarias para insertar un registro 
// en el maestro.
///////////////////////////////////////////////////////////////////////

Long ll_resultado

/////////////////////////////////////////////////////////////////////////
// En el siguiente CHOOSE CASE se esta verificando si hubo cambios en el 
// Detalle.
/////////////////////////////////////////////////////////////////////////

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
		CHOOSE CASE MessageBox("Cambios detectados en el detalle...",&
 	               "Desea grabar los cambios del maestro y el detalle",&
               	 Question!,YesNoCancel!)
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

IF (is_cambios = "no" AND is_accion = "nada") OR &
	(is_cambios = "si" AND is_accion <> "cancelo") THEN
	
	ll_resultado = w_base_simple::Event ue_insertar_maestro(ll_resultado,ll_resultado)
	IF (is_cambios = "no" AND is_accion = "nada") OR &
		(is_cambios = "si" AND is_accion <> "cancelo") THEN	
			dw_detalle.Reset()
	END IF
	Return ll_resultado
END IF

end event

event open;call super::open;dw_detalle.SetTransObject(SQLCA)
end event

event resize;//////////////////////////////////////////////////
//
//	Se omite el script del papa
//
//////////////////////////////////////////////////
end event

type dw_maestro from w_base_simple`dw_maestro within w_base_maestroff_detalletb
integer x = 41
integer y = 20
integer height = 412
integer taborder = 10
boolean titlebar = true
string title = "Maestro :"
boolean border = true
end type

type dw_detalle from uo_dtwndow within w_base_maestroff_detalletb
integer x = 41
integer y = 488
integer width = 1143
integer height = 464
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "Detalle :"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;////////////////////////////////////////////////////////////////
// Se verifica si la fila en la que esta posicionada es valida.
////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT ISNULL(row) THEN
	This.SelectRow(il_fila_actual_detalle,FALSE)
	il_fila_actual_detalle = row
ELSE
END IF

end event

event doubleclicked;////////////////////////////////////////////////////////////////
// Se verifica si la fila en la que esta posicionada sea valida.
////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT ISNULL(row) THEN
	This.SelectRow(il_fila_actual_detalle,FALSE)
	il_fila_actual_detalle = row
ELSE
END IF




end event

event rowfocuschanged;This.SelectRow(il_fila_actual_detalle,FALSE)
il_fila_actual_detalle = This.GetRow()
This.SetRow(il_fila_actual_detalle)
This.SelectRow(il_fila_actual_detalle,TRUE)

end event

