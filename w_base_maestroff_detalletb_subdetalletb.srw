HA$PBExportHeader$w_base_maestroff_detalletb_subdetalletb.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para hacer mantenimientos maestro-detalle-subdetalle con un freeform en el maestro, tabular en el detalle y tabular en el subdetalle. Debe Heredarse y adaptar los eventos necesarios.
forward
global type w_base_maestroff_detalletb_subdetalletb from w_base_maestroff_detalletb
end type
type dw_subdetalle from uo_dtwndow within w_base_maestroff_detalletb_subdetalletb
end type
end forward

global type w_base_maestroff_detalletb_subdetalletb from w_base_maestroff_detalletb
integer width = 2240
integer height = 1244
string menuname = "m_mantenimiento_maestro_detalle_subdet"
event ue_insertar_subdetalle pbm_custom07
event ue_borrar_subdetalle pbm_custom08
dw_subdetalle dw_subdetalle
end type
global w_base_maestroff_detalletb_subdetalletb w_base_maestroff_detalletb_subdetalletb

type variables
Long il_fila_actual_subdetalle = 0
Long il_dx, il_dy, il_dw, il_dh
Long il_sx, il_sy, il_sw, il_sh
end variables

event ue_insertar_subdetalle;long ll_fila

//il_sx = dw_subdetalle.x
//il_sy = dw_subdetalle.y
//il_sw = dw_subdetalle.width
//il_sh = dw_subdetalle.height

//dw_subdetalle.x = 20
//dw_subdetalle.y = 20
//dw_subdetalle.ReSize(this.width - 20, this.height - 20)
//dw_subdetalle.BringToTop = TRUE

IF il_fila_actual_detalle > 0 THEN
	IF dw_subdetalle.AcceptText() = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del subdetalle porque habian ingresos previos con problemas" &
					,StopSign!)	
	ELSE
		ll_fila = dw_subdetalle.InsertRow(0)
		IF ll_fila = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del subdetalle",StopSign!)
		ELSE
			dw_subdetalle.SetFocus()
			dw_subdetalle.SetRow(ll_fila)
			dw_subdetalle.ScrollToRow(ll_fila)
			dw_subdetalle.SetColumn(1)
			il_fila_actual_subdetalle = ll_fila 
   		dw_subdetalle.SelectRow(il_fila_actual_subdetalle,FALSE)
			il_fila_actual_subdetalle = dw_subdetalle.GetRow()
			IF ((il_fila_actual_subdetalle <> -1) and (NOT ISNULL (il_fila_actual_subdetalle)) &
				and (il_fila_actual_subdetalle <> 0))THEN
   			dw_subdetalle.SelectRow(il_fila_actual_subdetalle,TRUE)
				If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_subdetalle.SetItem(il_fila_actual_subdetalle, "fe_creacion", f_fecha_servidor())
			ELSE
			END IF
		END IF
	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el subdetalle sin haber seleccionado un registro en el detalle",Exclamation!,OK!)
END IF

////////////////////////////////////////////////////////////////////
// Cuando herede debe capturar los campos claves del detalle en
// variables locales y asignarselas al registro insertado en el 
// subdetalle
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

event ue_borrar_subdetalle;call super::ue_borrar_subdetalle;long ll_fila

ll_fila = dw_subdetalle.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del subdetalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del subdetalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del subdetalle",Question!,YesNo!) = 1) THEN
			IF (dw_subdetalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del subdetalle",StopSign!,Ok!)
			ELSE
				This.TriggerEvent("ue_grabar")
			END IF
		ELSE
		END IF
END CHOOSE

il_fila_actual_subdetalle = il_fila_actual_subdetalle - 1

end event

on w_base_maestroff_detalletb_subdetalletb.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_maestro_detalle_subdet" then this.MenuID = create m_mantenimiento_maestro_detalle_subdet
this.dw_subdetalle=create dw_subdetalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_subdetalle
end on

on w_base_maestroff_detalletb_subdetalletb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_subdetalle)
end on

event open;call super::open;il_dx = dw_detalle.x
il_dy = dw_detalle.y
il_dw = dw_detalle.width
il_dh = dw_detalle.height

il_sx = dw_subdetalle.x
il_sy = dw_subdetalle.y
il_sw = dw_subdetalle.width
il_sh = dw_subdetalle.height

dw_subdetalle.SetTransObject(SQLCA)
end event

event ue_borrar_detalle;///////////////////////////////////////////////////////////////////////
// Se omite el script del papa. Se verifica de que no existan 
// detalles asociados con el registro del maestro a borrar.
///////////////////////////////////////////////////////////////////////

Long ll_resultado

IF dw_subdetalle.RowCount() > 0 THEN
	MessageBox("Advertencia","El registro detalle seleccionado tiene subdetalles asociados, no se puede borrar",Exclamation!,OK!)
ELSE
	ll_resultado = w_base_maestroff_detalletb::Event ue_borrar_detalle(ll_resultado,ll_resultado)
	Return ll_resultado
END IF


end event

event ue_buscar;call super::ue_buscar;///////////////////////////////////////////////////////////////////////////
// Luego de haberse verificado si hubo cambios en el maestro (script 
//	del abuelo), se verifica si hubo cambios en el detalle (script del
//	papa) y en este script se verifica si hubo cambios en el subdetalle.
///////////////////////////////////////////////////////////////////////////

IF (is_cambios = "no" AND is_accion = "nada") OR (is_cambios = "si" AND is_accion <> "cancelo") THEN
	CHOOSE CASE wf_detectar_cambios (dw_subdetalle)
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

//////////////////////////////////////////////////////////////////	
// Si usted desea utilizar el buscar lista debe mirar el script
// del bisabuelo y copiar todo lo que esta comentariado en el script
//	en este evento a su ventana y adaptar la parte de buscar a su 
//	datawindow. y adicionar despues de que sea exitoso el retrieve del
//	maestro las siguientes linea :
//		dw_detalle.Retrieve(argumentos)					
// adaptando argumentos segun la datawindow de detalle y...
//		dw_subdetalle.Retrieve(subargumentos)					
// adaptando argumentos segun la datawindow de subdetalle
//////////////////////////////////////////////////////////////////	

end event

event ue_grabar;call super::ue_grabar;//////////////////////////////////////////////////////////////////////////
// En este evento se realizar ACCEPTTEXT para llevar los cambios 
// del subdetalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////

IF is_accion = "si update" THEN
	IF dw_subdetalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		Messagebox("Error","No se pudieron realizar los cambios en el subdetalle",Exclamation!,Ok!)	
		RETURN
	ELSE
		IF dw_subdetalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el subdetalle para la base de datos",Exclamation!,Ok!)	
			RETURN
		ELSE
			is_accion = "si update"
			COMMIT;
			IF SQLCA.SQLCode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el subdetalle para la base de datos" &
								,Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF

dw_detalle.x = il_dx
dw_detalle.y = il_dy
dw_detalle.ReSize(il_dw, il_dh)
dw_detalle.SetColumn(1)

dw_subdetalle.x = il_sx
dw_subdetalle.y = il_sy
dw_subdetalle.ReSize(il_sw, il_sh)
dw_subdetalle.SetColumn(1)
end event

event ue_insertar_detalle;//////////////////////////////////////////////////////////////////////
// Se omite el script del papa.
// Se adicionan las lineas necesarias para insertar un registro 
// en el subdetalle.
/////////////////////////////////////////////////////////////////////

Long ll_resultado

//////////////////////////////////////////////////////////////////////
// En el siguiente CHOOSE CASE se esta verificando si hubo cambios en 
//	el Subdetalle.
//////////////////////////////////////////////////////////////////////

CHOOSE CASE wf_detectar_cambios (dw_subdetalle)
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
		CHOOSE CASE MessageBox("Cambios detectados en el subdetalle...", &
 	               "Desea grabar los cambios del maestro y el subdetalle", &
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

	ll_resultado = w_base_maestroff_detalletb::Event ue_insertar_detalle(ll_resultado,ll_resultado)

//	il_dx = dw_detalle.x
//	il_dy = dw_detalle.y
//	il_dw = dw_detalle.width
//	il_dh = dw_detalle.height
//	dw_detalle.x = 20
//	dw_detalle.y = 20
//	dw_detalle.ReSize(this.width - 20, this.height - 20)	
//	dw_detalle.BringToTop = TRUE

	IF (is_cambios = "no" AND is_accion = "nada") OR &
		(is_cambios = "si" AND is_accion <> "cancelo") THEN	
			dw_subdetalle.Reset()
	END IF
	Return ll_resultado
END IF







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

CHOOSE CASE wf_detectar_cambios (dw_subdetalle)
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
		CHOOSE CASE MessageBox("Cambios detectados en el subdetalle...",&
 	               "Desea grabar los cambios del maestro, detalle y subdetalle",&
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
	
	ll_resultado = w_base_maestroff_detalletb::Event ue_insertar_maestro(ll_resultado,ll_resultado)
	IF (is_cambios = "no" AND is_accion = "nada") OR &
		(is_cambios = "si" AND is_accion <> "cancelo") THEN	
			dw_subdetalle.Reset()
	END IF
	Return ll_resultado
END IF

end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_base_maestroff_detalletb_subdetalletb
integer width = 2135
integer taborder = 20
end type

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_base_maestroff_detalletb_subdetalletb
integer x = 37
integer y = 472
integer width = 1262
integer taborder = 30
end type

event dw_detalle::rowfocuschanged;call super::rowfocuschanged;
////////////////////////////////////////////////////////////////////////
//	LAS SIGUIENTES LINEAS DEBEN SER INCLUIDAS EN ESTE MISMO SCRIPT
//	ADAPTANDOLO A LAS DATAWINDOWS ASOCIADAS :
//
//????? ll_parametro1, ll_parametro2
//
//IF il_fila_actual_detalle > 0 THEN
//	ll_parametro1 = dw_detalle.GetitemNumber(il_fila_actual_detalle,&
//                                             	"ll_parametro1")
//	ll_parametro2 = dw_detalle.GetitemNumber(il_fila_actual_detalle,&
//                                         		"ll_parametro2")
//	dw_subdetalle.Retrieve(ll_parametro1, ll_parametro2)
//ELSE
//	dw_subdetalle.Reset()
//END IF
//
////////////////////////////////////////////////////////////////////////



end event

type dw_subdetalle from uo_dtwndow within w_base_maestroff_detalletb_subdetalletb
integer x = 1353
integer y = 464
integer width = 809
integer height = 488
integer taborder = 10
boolean bringtotop = true
boolean titlebar = true
string title = "Subdetalle :"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;//////////////////////////////////////////////////////////////////////
// Se evalua si se hizo click sobre una fila valida
//////////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	This.SelectRow(il_fila_actual_subdetalle,FALSE)
	il_fila_actual_subdetalle = row
ELSE
END IF
end event

event doubleclicked;//////////////////////////////////////////////////////////////////////
// Se evalua si se hizo click sobre una fila valida
//////////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	This.SelectRow(il_fila_actual_subdetalle,FALSE)
	il_fila_actual_subdetalle = row
ELSE
END IF

end event

event rowfocuschanged;This.SelectRow(il_fila_actual_subdetalle,FALSE)
il_fila_actual_subdetalle = This.GetRow()
This.SetRow(il_fila_actual_subdetalle)
This.SelectRow(il_fila_actual_subdetalle,TRUE)

end event

