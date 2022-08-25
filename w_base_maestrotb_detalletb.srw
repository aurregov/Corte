HA$PBExportHeader$w_base_maestrotb_detalletb.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para hacer mantenimientos maestro-detalle con un tabular en el maestro y tabular en el detalle. Debe Heredarse y adaptar los eventos necesarios.
forward
global type w_base_maestrotb_detalletb from w_base_tabular
end type
type dw_detalle from uo_dtwndow within w_base_maestrotb_detalletb
end type
end forward

global type w_base_maestrotb_detalletb from w_base_tabular
integer width = 1211
integer height = 1236
string menuname = "m_mantenimiento_maestro_detalle"
event ue_insertar_detalle pbm_custom05
event ue_borrar_detalle pbm_custom06
dw_detalle dw_detalle
end type
global w_base_maestrotb_detalletb w_base_maestrotb_detalletb

type variables
long il_fila_actual_detalle
end variables

event ue_insertar_detalle;Long ll_fila

ll_fila = dw_detalle.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
ELSE
	dw_detalle.SetRow(ll_fila)
	dw_detalle.ScrollToRow(ll_fila)
	dw_detalle.SetColumn(1)
	il_fila_actual_detalle = ll_fila
   
	dw_detalle.SelectRow(il_fila_actual_detalle,FALSE)
	il_fila_actual_detalle = dw_detalle.GetRow()

	IF ((il_fila_actual_detalle<> -1) and (NOT ISNULL (il_fila_actual_detalle)) and (il_fila_actual_detalle<>0))THEN
   	dw_detalle.SelectRow(il_fila_actual_detalle,TRUE)
		If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", DateTime(Today(), Now()))
	ELSE
	END IF
END IF

////////////////////////////////////////////////////////////////////
// Cuando herede debe capturar los campos claves del maestro en
// variables locales y asignarselas al registro insertado en el 
// detalle
////////////////////////////////////////////////////////////////////
//clave1 = dw_maestro.GetitemString(il_fila_actual_maestro,"clave 1")
//clave2 = dw_maestro.GetitemString(il_fila_actual_maestro,"clave 2")
//......
//dw_detalle.SetItem(il_fila_actual_detalle,"clave 1",clave1)
//dw_detalle.SetItem(il_fila_actual_detalle,"clave 2",clave2)
//dw_detalle.AcceptText
////////////////////////////////////////////////////////////////////

end event

event ue_borrar_detalle;call super::ue_borrar_detalle;/////////////////////////////////////////////////////////////////////
//En este evento se borra la fila activa del detalle.
/////////////////////////////////////////////////////////////////////

long ll_fila

/////////////////////////////////////////////////////////////////////////
// A la variable local ll_fila se le esta asignando la fila activa del 
// datawindow del detalle.
/////////////////////////////////////////////////////////////////////////

ll_fila=dw_detalle.GetRow()
////////////////////////////////////////////////////////////////////////
// Con el siguiente CHOOSE CASE se esta verificando si la fila activa
// es valida.
////////////////////////////////////////////////////////////////////////

CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			
			/////////////////////////////////////////////////////////////
			// Con el siguiente IF se esta verificando si el borrado 
			// de la fila activa fue exitosa.
			/////////////////////////////////////////////////////////////
			
			IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",&
       		            StopSign!,Ok!)
			ELSE
				This.TriggerEvent("ue_grabar")
			END IF
		ELSE
		END IF
END CHOOSE

il_fila_actual_detalle = ll_fila - 1

end event

on w_base_maestrotb_detalletb.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_maestro_detalle" then this.MenuID = create m_mantenimiento_maestro_detalle
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detalle
end on

on w_base_maestrotb_detalletb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detalle)
end on

event closequery;call super::closequery;//////////////////////////////////////////////////////////////////////
// En este evento se verifica si hubo cambios en el datawindow del
// detalle, teniendo en cuenta la verificacion de cambios en el 
// maestro hecha por el padre.
/////////////////////////////////////////////////////////////////////

IF (is_cambios = "no") OR &
   (is_cambios = "si" AND is_accion = "no grabo") THEN
	CHOOSE CASE wf_detectar_cambios (dw_detalle)
		CASE -1
			is_cambios = "error"
			is_accion = "nada"
			Message.returnvalue = 1
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
					Message.returnvalue = 1
					RETURN
			END CHOOSE
	END CHOOSE
ELSE
END IF
end event

event ue_insertar_maestro;Long ll_resultado

//////////////////////////////////////////////////////////////////////////
// Con el siguiente CHOOSE CASE, se verifica si hubo cambios en el detalle.
///////////////////////////////////////////////////////////////////////////

CHOOSE CASE wf_detectar_cambios (dw_detalle)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		Message.ReturnValue = 1
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
				Message.ReturnValue = 1
				RETURN
		END CHOOSE
END CHOOSE

/////////////////////////////////////////////////////////////////////
// Con la dos lineas siguiente se dispara el userObject
// "ue_insertar_maestro" del padre.
//////////////////////////////////////////////////////////////////////
		
ll_resultado = w_base_tabular::Event ue_insertar_maestro(ll_resultado,ll_resultado)

Return ll_resultado
end event

event ue_borrar_maestro;////////////////////////////////////////////////////////////////////
// se omite el script del papa.
///////////////////////////////////////////////////////////////////

Long ll_resultado

////////////////////////////////////////////////////////////////
// Con el siguiente IF , se esta verificando que el registro
// maestro a borrar no tenenga asociado detalles.
///////////////////////////////////////////////////////////////
		
IF dw_detalle.RowCount() > 0 THEN
	MessageBox("Advertencia","El registro maestro seleccionado tiene detalles asociados no se puede borrar",Exclamation!,OK!)
ELSE
	/////////////////////////////////////////////////////////////////////
	// Con la siguiente instruccion, se esta disparando el userObject 
	// "ue_borrar" del padre. Siempre tiene como argumento la variable 
	// de retorno.
	/////////////////////////////////////////////////////////////////////
	
	ll_resultado = w_base_tabular::Event ue_borrar_maestro(ll_resultado,ll_resultado)
	Return ll_resultado
END IF
end event

event ue_buscar;//////////////////////////////////////////////////////////////////////////
// se omite el script del papa
///////////////////////////////////////////////////////////////////////////
		
Long ll_resultado

//////////////////////////////////////////////////////////////////////////
// Con el CHOOSE CASE Siguiente, se esta verificando si hubo cambios en el 
// datawindow del detalle.
///////////////////////////////////////////////////////////////////////////

CHOOSE CASE wf_detectar_cambios (dw_detalle)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		Message.ReturnValue = 1
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		// No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados en el detalle...","Desea grabar los cambios del maestro y el detalle",Question!,yesnocancel!,1)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				Message.ReturnValue = 1
				RETURN
		END CHOOSE
END CHOOSE

ll_resultado = w_base_tabular::Event ue_buscar(ll_resultado,ll_resultado)

IF dw_maestro.RowCount() = 0 THEN
	dw_detalle.Reset()
END IF	

dw_maestro.TriggerEvent("rowfocuschanged")

Return ll_resultado

//////////////////////////////////////////////////////////////////	
// Si usted desea utilizar el buscar lista debe mirar el script
// del abuelo y copiar lo que esta comentariado en el script de 
// su ventana en este evento y adaptarlo a sus datawindows.
// adicionalmente debe poner invisibles el static text y 
// sle_argumento
//////////////////////////////////////////////////////////////////	

//////////////////////////////////////////////////////////////////	
//	Si desea utilizar el sle_argumento debe poner en el hijo en
//	este mismo script las siguientes lineas y adaptarlas segun las 
//	datawindow
//
//IF dw_maestro.RowCount() > 0 THEN
//	dw_detalle.TriggerEvent("rowfocuschanged")
//END IF
//////////////////////////////////////////////////////////////////	


	
	
	
	
	
	
end event

event ue_grabar;call super::ue_grabar;/////////////////////////////////////////////////////////////////////////
// Con el ACCEPTTEXT para llevar los cambios al buffer.
// El UPDATE para preparar los datos en el servidor.
// El COMMIT para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////////

IF is_accion = "si update" THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		MessageBox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
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
			IF sqlca.sqlcode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF
end event

event open;////////////////////////////////////////////////////////////////////////
// se omite el script del papa.
// y se hace un settransobject al datawindow del detalle.
/////////////////////////////////////////////////////////////////////////

Long ll_var

dw_detalle.SetTransObject(SQLCA)

ll_var = w_base_tabular::EVENT Open()
end event

event resize;//////////////////////////////////////////////////
//
//	Se omite el script del papa
//
//////////////////////////////////////////////////
end event

type dw_maestro from w_base_tabular`dw_maestro within w_base_maestrotb_detalletb
integer x = 41
integer y = 116
integer width = 1115
integer height = 400
integer taborder = 10
boolean titlebar = true
string title = "Maestro: "
boolean border = true
boolean hsplitscroll = false
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = This.GetRow()
This.SetRow(il_fila_actual_maestro)
This.SelectRow(il_fila_actual_maestro,TRUE)


////////////////////////////////////////////////////////////////////////
//	LAS SIGUIENTES LINEAS DEBEN SER INCLUIDAS EN ESTE MISMO SCRIPT
//	ADAPTANDOLO A LAS DATAWINDOWS ASOCIADAS :
//
//Long ll_co_aplicacion, ll_co_perfil
//
//IF il_fila_actual_maestro > 0 THEN
//	ll_co_aplicacion = dw_maestro.GetitemNumber(il_fila_actual_maestro,&
//                                             "co_aplicacion")
//	ll_co_perfil = dw_maestro.GetitemNumber(il_fila_actual_maestro,&
//                                         "co_perfil")
//	dw_detalle.Retrieve(ll_co_perfil, ll_co_aplicacion)
//ELSE
//	dw_detalle.Reset()
//END IF
//
////////////////////////////////////////////////////////////////////////

end event

type sle_argumento from w_base_tabular`sle_argumento within w_base_maestrotb_detalletb
integer x = 320
integer y = 28
integer taborder = 30
end type

type st_1 from w_base_tabular`st_1 within w_base_maestrotb_detalletb
integer y = 32
end type

type dw_detalle from uo_dtwndow within w_base_maestrotb_detalletb
integer x = 41
integer y = 544
integer width = 1115
integer height = 400
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "Detalle:"
end type

event clicked;/////////////////////////////////////////////////////////////////////////
// se verifica que la fila activa sea valida.
/////////////////////////////////////////////////////////////////////////

IF Row <> 0 AND Row <> -1 AND NOT ISNULL(Row) THEN
	This.SelectRow(il_fila_actual_detalle,FALSE)
	il_fila_actual_detalle = Row
ELSE	
END IF
end event

event doubleclicked;IF Row <> 0 AND Row <> -1 AND NOT ISNULL(Row) THEN
	This.SelectRow(il_fila_actual_detalle,FALSE)
	il_fila_actual_detalle = Row
ELSE	
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(il_fila_actual_detalle,FALSE)
il_fila_actual_detalle = This.GetRow()
This.SetRow(il_fila_actual_detalle)
This.SelectRow(il_fila_actual_detalle,TRUE)
end event

