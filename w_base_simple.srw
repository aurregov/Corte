HA$PBExportHeader$w_base_simple.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para hacer mantenimientos simples con un freeform en el maestro. Debe Heredarse y adaptar los eventos necesarios.
forward
global type w_base_simple from window
end type
type dw_maestro from uo_dtwndow within w_base_simple
end type
end forward

global type w_base_simple from window
integer x = 695
integer y = 436
integer width = 1339
integer height = 972
boolean titlebar = true
string menuname = "m_mantenimiento_simple"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_buscar pbm_custom01
event ue_grabar pbm_custom02
event ue_insertar_maestro pbm_custom03
event ue_borrar_maestro pbm_custom04
event systemcommand pbm_syscommand
event type long ue_activar_cxe ( )
event type long ue_desactivar_cxe ( )
dw_maestro dw_maestro
end type
global w_base_simple w_base_simple

type variables
s_base_parametros istr_parametros_error
String is_cambios,is_accion, is_grabada
Long il_fila_actual_maestro
Boolean ib_modo_consulta = False			//	Indica si la hoja esta en modo de Consulta por Ejemplo (CxE)
Boolean ib_cxe_enproceso = False			//	Indica si la hoja esta en proceso de activaci$$HEX1$$f300$$ENDHEX$$n de CxE
Boolean ib_cxe_criterio = False			//	Indica si existe un criterio de CxE en la hoja
uo_dtwndow idw_activo						//	Referencia el datawindow con foco en la ventana
end variables

forward prototypes
public function long wf_detectar_cambios (datawindow adw_datawindows)
public function long of_evento_sistema (long ai_xpos, long ai_ypos, unsignedlong aul_evento)
public function long of_desactivar_cxe ()
end prototypes

event ue_buscar;///////////////////////////////////////////////////////////////////
// En este evento se detecta si hubo cambios en el datawindow
// maestro y asigna valores a las variables de instancia is_cambio y
// is_accion. ademas se deja comentariado el script de hacer la
// busqueda, para que sea adpatado, de acuerdo a la ventana que se
// este contruyendo.
///////////////////////////////////////////////////////////////////
Long ll_ret

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN -1 // Fallo el AcceptText para el Maestro
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		RETURN 0	// No hay registros modificados en el Maestro
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios  en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
//				This.TriggerEvent("ue_grabar")
				ll_ret = This.Event ue_grabar(0,0)
				If ll_ret < 0 Then Return ll_ret
				RETURN 1	//	Logro grabar los datos del Maestro
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
				RETURN 2	
			CASE 3
				is_accion = "cancelo"
				RETURN 3
		END CHOOSE
END CHOOSE

////////////////////////////////////////////////////////////////////
//Las siguientes lineas se deben acondicionar seg$$HEX1$$fa00$$ENDHEX$$n la ventana.
///////////////////////////////////////////////////////////////////
//s_base_parametros lstr_parametros
//long ll_hallados
//
//IF is_cambios = "no" OR is_accion <> "cancelo" THEN
//	Open(w_buscar)
//	lstr_parametros=message.powerObjectparm
//
//	IF lstr_parametros.hay_parametros THEN
//		arg1=lstr_parametros.cadena[1]
//		arg2=lstr_parametros.cadena[2]
//		arg3=lstr_parametros.entero[1]
//
//		ll_hallados = dw_maestro.Retrieve(arg1)
//		IF isnull(ll_hallados) THEN
//			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//		ELSE
//			CHOOSE CASE ll_hallados
//				CASE -1
//					il_fila_actual_maestro = -1
//					MessageBox("Error buscando","Error de la base",StopSign!,&
//                         Ok!)
//				CASE 0
//					il_fila_actual_maestro = 0
//					MessageBox("Sin Datos","No hay datos para su criterio",&
//                         Exclamation!,Ok!)
//				CASE ELSE
//					il_fila_actual_maestro = 1
//					MessageBox("Busqueda ok","registros encontrados: "+&
//             	String(ll_hallados),Information!,Ok!)
//			END CHOOSE
//		END IF
//	ELSE
//	END IF
//ELSE
//END IF

end event

event ue_grabar;/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////

IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN -1
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN -2
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)
			RETURN -3
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

RETURN 1
end event

event ue_insertar_maestro;///////////////////////////////////////////////////////////////////////
// En este evento se detecta si hubo cambios en el datawindow, para 
// asignar valores a las variables de instancia is_cambio y is_accion.
//
// Ademas, se inserta una nueva linea, se le evalua el insert y si fue
// exitoso, se posiciona en dicha fila,hace el scroll a dicha fila y
// se posiciona en la primera columna de esta fila.
////////////////////////////////////////////////////////////////////////

long ll_fila

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

dw_maestro.Reset()
ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF


   

end event

event ue_borrar_maestro;long ll_fila

///////////////////////////////////////////////////////////////////
// Identifica la fila activa y la evalua, si la fila activa
// es mayor que cero, evalua mensaje de confirmacion y
// ademas evalua el delete y si este es valido, dispara el grabar,para
// que la fila sea borrada de la base de datos.
///////////////////////////////////////////////////////////////////

ll_fila=dw_maestro.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del maestro ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del maestro",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del maestro",Question!,YesNo!) = 1) THEN
			IF (dw_maestro.DeleteRow(ll_fila) = -1) THEN
				messagebox("Error datawindow","No pudo borrar del maestro",&
				            StopSign!,Ok!)
			ELSE
				il_fila_actual_maestro = ll_fila - 1				
				This.TriggerEvent("ue_grabar")
   		END IF
		ELSE
		END IF
END CHOOSE



end event

event systemcommand;/*	-----------------------------------------------------------------
	Evento que dispara la funcion of_evento_systema de la ventana
	Envia los argumentos de la posicion x,y asi como el evento del 
	sistema mapeado por PowerBuilder.
	
	Algunos Eventos:
	61536 - Boton Cerrar
	61472 - Boton Minimizar
	61488 - Boton Maximizar
	61728 - Boton Restaurar
	61458 - Click izquierdo del mouse sobre la barra de titulo
	61456 - "Move" desde el menu de control de la Ventana
	61440 - "Size" desde el menu de control de la Ventana
	61504 - "Next" desde el menu de control de la Ventana Hoja de MDI
	-----------------------------------------------------------------*/
	
	of_evento_sistema(xpos,ypos,commandtype)
end event

event type long ue_activar_cxe();/* --------------------------------------------------------------------------	
	Evento que activa el modo consulta del Datawindow maestro de esta ventana.
   --------------------------------------------------------------------------*/
Long li_boton, li_contador, li_numero_columnas
String ls_modificacion, ls_resultado

If IsValid(dw_maestro) Then	//	Si existe un Datawindow para validar en la ventana
	If dw_maestro.AcceptText() = -1 Then Return -1
	//	Si hay datos del usuario sin salvar pregunta si quiere salvarlos o no y 
	//	ejecuta de acuerdo a la opcion del usuario
	If dw_maestro.ModifiedCount() + dw_maestro.DeletedCount() > 0 Then
		li_boton = MessageBox("Activar Consulta por Ejemplo --> " + This.Title,"Desea guardar los cambios antes de continuar.",Question!,YesNOCancel! )
		Choose Case li_boton
			Case 1	//	Se dispara evento que graba en la base de datos y continua si se tiene exito
				This.TriggerEvent("ue_grabar")
				If is_grabada <> "si" Then
					If This.WindowState = Minimized! Then This.WindowState = Normal!
						BringToTop = True
						Return -1
				End If
			Case 2	//	Se posterga actualizar los cambios hechos a los datos
			Case 3	//	Se aborta el proceso de activaci$$HEX1$$f300$$ENDHEX$$n de Consulta por Ejemplo
				Return -3
			Case Else
				MessageBox("Error de Software","Manejo de Caja de Mensajes con problemas" &
							+ "~nPor favor avise al Administrador de este problema", StopSign!)
				Return -2
		End Choose
	End if
	
	//	Prepara el Datawindows Object para permitir sobreescribir las mascaras de edicion
	//	que tenga el datawindow maestro
	li_numero_columnas = Long(dw_maestro.Describe("DataWindow.Column.Count"))
	For li_contador = 1 To li_numero_columnas
		If  match("editmask",dw_maestro.Describe("#"+string(li_contador)+".Edit.Style")) Then
			ls_modificacion += "#"+string(li_contador)+".Criteria.Override_Edit=yes "
		End If
	Next

	//	Modifica el Datawindow Object con la informacion preparada
	If ls_modificacion <> "" Then
		ls_resultado = dw_maestro.Modify(ls_modificacion)
	End If	
	
	//	Coloca el Datawindow Maestro en modo de consulta x ejemplo (query by example)
	ls_resultado = dw_maestro.Modify("datawindow.querymode=yes")
	If ls_resultado <> "" Then Return -1
		ib_modo_consulta = True
//		cb_activacion.Text = "Desactivar"
Else
	MessageBox("Operaci$$HEX1$$f300$$ENDHEX$$n No Valida", "No hay un objeto de datos activo")
	Return 0
End If

Return 1
end event

event type long ue_desactivar_cxe();/* -------------------------------------------------------------------	
	Evento que desactiva el modo de Consulta por Ejemplo en dw_maestro.
	Ocurre solo cuando el usuario estando en modo de consulta vuelve
	a hacer click sobre el boton de consulta por ejemplo.
   -------------------------------------------------------------------*/
Long li_boton, li_contador, li_numero_columnas
String ls_nombre_columna, ls_resultado

If IsValid(dw_maestro) Then	//	Si existe un Datawindow para validar en la ventana
	dw_maestro.AcceptText()
//	li_boton = MessageBox("Desactivar Consulta por Ejemplo --> " + This.Title,"Desea borrar el criterio " &
//			+ "de selecci$$HEX1$$f300$$ENDHEX$$n antes de continuar." &
//			+"~n~nEn caso afirmativo, tenga en cuenta que la informaci$$HEX1$$f300$$ENDHEX$$n (registros borrados " &
//			+" y registros modificados o nuevos que estan filtrados) que no se haya guardado " &
//			+"antes de activar Consulta por Ejemplo; sera descartada de memoria.",Exclamation!,YesNOCancel!,2)
	li_boton = 1
	Choose Case li_boton
		Case 1	//	Se borra el criterio de selecci$$HEX1$$f300$$ENDHEX$$n
			ls_resultado = dw_maestro.Modify("datawindow.queryclear=yes")
			ls_resultado = dw_maestro.Modify("datawindow.querymode=no")
			If ls_resultado <> "" Then Return -1
			ib_modo_consulta = False
//			cb_activacion.Text = "Activar"
			ib_cxe_criterio = False
			Return 1
		Case 2	//	No se borra el criterio de seleccion pero si se desactiva el modo de consulta
			ls_resultado = dw_maestro.Modify("datawindow.querymode=no")
			If ls_resultado <> "" Then Return -1
			ib_modo_consulta = False
//			cb_activacion.Text = "Activar"
			ib_cxe_criterio = True
			Return 2
		Case 3	//	Se aborta el proceso de desactivar Consulta por Ejemplo
			Return 3
		Case Else
			MessageBox("Error de Software","Manejo de Caja de Mensajes con problemas" &
						+ "~nPor favor avise al Administrador de este problema", StopSign!)
			Return -2
	End Choose
Else
	MessageBox("Operaci$$HEX1$$f300$$ENDHEX$$n No Valida", "No hay un objeto de datos activo")
	Return 0
End If
end event

public function long wf_detectar_cambios (datawindow adw_datawindows);//////////////////////////////////////////////////////////////////////////
// FUNCION: wf_detectar_cambios
// DESCRIPCION: detecta los cambios realizados a un datawindow
// PARAMETRO: el datawindow (adw_datawindows)
// RETORNA: -1 hubo problemas
//           0 no hubo cambios
//           1 hubo cambios
/////////////////////////////////////////////////////////////////////////



IF adw_datawindows.accepttext() = -1 THEN
	Messagebox("Error","No se pudieron realizar los cambios",Exclamation!,ok!)	
	RETURN(-1)
ELSE
	//////////////////////////////////////////////////////////////////////
	// Con el siguiente IF, se esta comparando si los Buffers
	// de Delete y primary tienen datos y si tienen datos es retorna 1.
	////////////////////////////////////////////////////////////////////////
	IF adw_datawindows.deletedCount() + adw_datawindows.modifiedcount() > 0  THEN
		RETURN(1)
	ELSE
		RETURN(0)
	END IF
END IF

end function

public function long of_evento_sistema (long ai_xpos, long ai_ypos, unsignedlong aul_evento);/*	--------------------------------------------
	Funcion llamada por el evento systemcommand
	--------------------------------------------*/
Return 1
end function

public function long of_desactivar_cxe ();Long li_numero_columnas, li_contador
String ls_modificacion

li_numero_columnas = Long(dw_maestro.Describe("DataWindow.Column.Count"))
For li_contador = 1 To li_numero_columnas
	If  match("editmask",dw_maestro.Describe("#"+string(li_contador)+".Edit.Style")) Then
		ls_modificacion += "#"+string(li_contador)+".Criteria.Override_Edit=no "
	End If
Next

If ls_modificacion <> "" Then dw_maestro.Modify(ls_modificacion)
ls_modificacion = dw_maestro.Modify("datawindow.queryclear=yes")
This.ParentWindow().MenuId.item[3].item[1].Checked = False
This.ParentWindow().MenuId.item[3].item[1].ToolbarItemName = "Query!"
This.ParentWindow().MenuId.item[3].item[1].ToolbarItemDown = False
ib_cxe_criterio = False

If dw_maestro.Modify("datawindow.querymode=no") <> "" Then Return -1
ib_modo_consulta = False

Return 1
end function

on w_base_simple.create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.dw_maestro=create dw_maestro
this.Control[]={this.dw_maestro}
end on

on w_base_simple.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_maestro)
end on

event closequery;///////////////////////////////////////////////////////////////////////
// En este evento se evalua la el resultado de
// la funcion detectar cambios, 
// para determinar si se realizaron cambios en la datawindow maestro 
// y asi poder asigna valores a las siguientes variables de instancia:
// - is_cambio
// - is_accion
///////////////////////////////////////////////////////////////////////

CHOOSE CASE wf_detectar_cambios (dw_maestro)
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
		CHOOSE CASE MessageBox("Cambios detectados ", "Desea grabar los cambios del maestro",Question!,YesNoCancel!)
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

end event

event open;This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

event resize;//dw_maestro.Resize(This.Width - 120, This.Height - 300)
end event

type dw_maestro from uo_dtwndow within w_base_simple
integer x = 59
integer y = 36
integer width = 1143
integer height = 684
boolean hscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event rowfocuschanged;This.SelectRow(0,FALSE)
//This.SelectRow(CurrentRow,TRUE)
IF This.RowCount() > 1 THEN
	il_fila_actual_maestro = CurrentRow
   This.SelectRow(0,FALSE)
END IF

end event

