HA$PBExportHeader$w_base_maestroff_detalletb_para_tabs.srw
forward
global type w_base_maestroff_detalletb_para_tabs from w_base_simple
end type
type tab_1 from tab within w_base_maestroff_detalletb_para_tabs
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tab_1 from tab within w_base_maestroff_detalletb_para_tabs
tabpage_1 tabpage_1
end type
type dw_detalle from uo_dtwndow within w_base_maestroff_detalletb_para_tabs
end type
end forward

global type w_base_maestroff_detalletb_para_tabs from w_base_simple
integer x = 0
integer y = 0
integer width = 1294
integer height = 1164
string menuname = ""
event ue_insertar_detalle pbm_custom05
event ue_borrar_detalle pbm_custom06
tab_1 tab_1
dw_detalle dw_detalle
end type
global w_base_maestroff_detalletb_para_tabs w_base_maestroff_detalletb_para_tabs

type variables
Long il_fila_actual_detalle[]

DataWindow idw_arreglo_dw[]

Long ii_dw_actual = 1, ii_num_dw

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
	IF idw_arreglo_dw[ii_dw_actual].AcceptText() = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del detalle porque habian ingresos previos con problemas" &
					,StopSign!)	
	ELSE
		ll_fila = idw_arreglo_dw[ii_dw_actual].InsertRow(0)
		IF ll_fila = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
		ELSE
			idw_arreglo_dw[ii_dw_actual].SetRow(ll_fila)
			idw_arreglo_dw[ii_dw_actual].ScrollToRow(ll_fila)
			idw_arreglo_dw[ii_dw_actual].SetColumn(1)
			il_fila_actual_detalle[ii_dw_actual] = ll_fila 
   		idw_arreglo_dw[ii_dw_actual].SelectRow(il_fila_actual_detalle[ii_dw_actual],FALSE)
			il_fila_actual_detalle[ii_dw_actual] = idw_arreglo_dw[ii_dw_actual].GetRow()
			IF ((il_fila_actual_detalle[ii_dw_actual]<> -1) and (NOT ISNULL (il_fila_actual_detalle[ii_dw_actual])) and (il_fila_actual_detalle[ii_dw_actual]<>0))THEN
   			idw_arreglo_dw[ii_dw_actual].SelectRow(il_fila_actual_detalle[ii_dw_actual],TRUE)
				If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "fe_creacion", DateTime(Today(), Now()))
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
//		idw_arreglo_dw[ii_dw_actual].DeleteRow(il_fila_actual_detalle[ii_dw_actual])
//		il_fila_actual_detalle[ii_dw_actual] = il_fila_actual_detalle[ii_dw_actual] - 1
//	ELSE
//		idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual],"clave 1",clave1)
//		idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual],"clave 2",clave2)
//		idw_arreglo_dw[ii_dw_actual].AcceptText()
//	END IF
//END IF
////////////////////////////////////////////////////////////////////





end event

event ue_borrar_detalle;long ll_fila

ll_fila = idw_arreglo_dw[ii_dw_actual].GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			IF (idw_arreglo_dw[ii_dw_actual].DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
			ELSE
				il_fila_actual_detalle[ii_dw_actual] = ll_fila - 1
				This.TriggerEvent("ue_grabar")
			END IF
		ELSE
		END IF
END CHOOSE



end event

on w_base_maestroff_detalletb_para_tabs.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_detalle
end on

on w_base_maestroff_detalletb_para_tabs.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.dw_detalle)
end on

event closequery;call super::closequery;/////////////////////////////////////////////////////////////////////////
// Una  vez verificado si hubo o no cambios en el maestro, se verifica
// si hay cambios en el detalle.
/////////////////////////////////////////////////////////////////////////


IF (is_cambios = "no") OR (is_cambios = "si" AND is_accion = "no grabo") THEN
	CHOOSE CASE wf_detectar_cambios (idw_arreglo_dw[ii_dw_actual])
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
					                 "Desea grabar los cambios del maestro "+ &
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
Boolean lb_encontro = FALSE
Long li_dw_a_inicializar

li_dw_a_inicializar = 1
DO WHILE (li_dw_a_inicializar <= ii_num_dw) AND (NOT lb_encontro)
	IF idw_arreglo_dw[ii_dw_actual].RowCount() > 0 THEN
		lb_encontro = TRUE
		MessageBox("Advertencia","El registro maestro seleccionado tiene detalles asociados, no se puede borrar",Exclamation!,OK!)
	END IF	
	li_dw_a_inicializar++
LOOP

IF NOT lb_encontro THEN
	ll_resultado = w_base_simple::Event ue_borrar_maestro(ll_resultado,ll_resultado)
	Return ll_resultado
END IF

end event

event ue_buscar;call super::ue_buscar;///////////////////////////////////////////////////////////////////////////////////////////////
// Luego de haberse verificado si hubo cambios en el mastro (script del padre),
// en este script se verifica si hubo cambios en el detalle.
///////////////////////////////////////////////////////////////////////////////////////////////

IF (is_cambios = "no" AND is_accion = "nada") OR (is_cambios = "si" AND is_accion <> "cancelo") THEN
	CHOOSE CASE wf_detectar_cambios (idw_arreglo_dw[ii_dw_actual])
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
// del abuelo y copiar todo lo que esta comentariado en el script a 
// su ventana en este evento y adaptar la parte de buscar a su 
//	datawindow. y adicionar despues de que sea exitoso el retrieve del
//	maestro la siguiente linea :
//
//Long li_dw_a_inicializar
//
//li_dw_a_inicializar = 1
//DO WHILE li_dw_a_inicializar <= ii_num_dw
//	idw_arreglo_dw[li_dw_a_inicializar].Retrieve(argumentos)
//	li_dw_a_inicializar++
//LOOP
// adaptando argumentos segun las datawindow de detalle
//////////////////////////////////////////////////////////////////	

end event

event ue_grabar;call super::ue_grabar;//////////////////////////////////////////////////////////////////////////
// En este evento se realiza ACCEPTTEXT para llevar los cambios 
// del detalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////

IF is_accion = "si update" THEN
	IF idw_arreglo_dw[ii_dw_actual].AcceptText() = -1 THEN
		is_accion = "no accepttext"
		Messagebox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN
	ELSE
		IF idw_arreglo_dw[ii_dw_actual].Update() = -1 THEN
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

event ue_insertar_maestro;////////////////////////////////////////////////////////////////////////
// Se omite el script del papa.
// Se adicionan las lineas necesarias para insertar un registro 
// en el maestro.
///////////////////////////////////////////////////////////////////////

Long ll_resultado
Long li_dw_a_inicializar

/////////////////////////////////////////////////////////////////////////
// En el siguiente CHOOSE CASE se esta verificando si hubo cambios en el 
// Detalle.
/////////////////////////////////////////////////////////////////////////

CHOOSE CASE wf_detectar_cambios (idw_arreglo_dw[ii_dw_actual])
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
			li_dw_a_inicializar = 1
			DO WHILE li_dw_a_inicializar <= ii_num_dw
				idw_arreglo_dw[li_dw_a_inicializar].Reset()
				il_fila_actual_detalle[li_dw_a_inicializar] = 0
				li_dw_a_inicializar++
			LOOP		
	END IF
	Return ll_resultado
END IF

end event

event open;call super::open;Long li_dw_a_inicializar // vble usada para controlar la posicion del
                            // arreglo que almacena los datawindows que
									 // se van a usar en las carpetas
This.x = 1
This.y = 1

dw_maestro.SetTransObject(SQLCA)

li_dw_a_inicializar = 1

DO WHILE li_dw_a_inicializar <= ii_num_dw
	idw_arreglo_dw[li_dw_a_inicializar].SetTransObject(SQLCA)
	idw_arreglo_dw[li_dw_a_inicializar].Visible = FALSE
	il_fila_actual_detalle[li_dw_a_inicializar] = 0
	li_dw_a_inicializar = li_dw_a_inicializar + 1
LOOP

il_fila_actual_maestro = 0
ii_dw_actual = 1
tab_1.SelectTab(ii_dw_actual)
idw_arreglo_dw[ii_dw_actual].Visible = TRUE
idw_arreglo_dw[ii_dw_actual].BringToTop = TRUE

/////////////////////////////////////////////////////////////////////////
//	LO SIGUIENTE ES LO QUE SE DEBE HACER EN EL HIJO
//
//This.Width = 2920
//This.Height = 1545
//
//ii_num_dw = 3 // Numero de datawindows que va a contener las carpetas
// 
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// Con las siguientes lineas, estamos asignando al arreglo los datawindows
// que se van a usar para las carpetas.
//
//idw_arreglo_dw[1] = dw_descuentos
//idw_arreglo_dw[2] = dw_observaciones
//idw_arreglo_dw[3] = dw_detalle_pedido
//
//ll_resultado = w_base_maestroff_detalletb_para_tabs::Event open()
//Return ll_resultado
//
//	Y por ultimo no olvidar poner OVERRIDE este evento en el hijo.
/////////////////////////////////////////////////////////////////////////
end event

event resize;//////////////////////////////////////////////////
//
//	Se omite el script del papa
//
//////////////////////////////////////////////////
end event

type dw_maestro from w_base_simple`dw_maestro within w_base_maestroff_detalletb_para_tabs
integer x = 41
integer width = 1166
integer height = 256
integer taborder = 20
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type tab_1 from tab within w_base_maestroff_detalletb_para_tabs
event selectionchanging pbm_tcnselchanging
event selectionchanged pbm_tcnselchanged
event create ( )
event destroy ( )
integer x = 41
integer y = 348
integer width = 1166
integer height = 240
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean multiline = true
boolean raggedright = true
boolean powertips = true
boolean createondemand = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

event selectionchanging;// en este script se verifica si hubo cambios en el detalle.
///////////////////////////////////////////////////////////////////////////////////////////////
IF ii_dw_actual > 0 THEN
	CHOOSE CASE wf_detectar_cambios (idw_arreglo_dw[ii_dw_actual])
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
				Parent.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				return 1
				RETURN
	END CHOOSE
END CHOOSE


idw_arreglo_dw[ii_dw_actual].Visible = FALSE
END IF
end event

event selectionchanged;ii_dw_actual = tab_1.SelectedTab
idw_arreglo_dw[ii_dw_actual].Visible = TRUE
idw_arreglo_dw[ii_dw_actual].BringToTop = TRUE

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1129
integer height = 112
long backcolor = 79741120
string text = "Base"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "NotFound!"
long picturemaskcolor = 553648127
end type

type dw_detalle from uo_dtwndow within w_base_maestroff_detalletb_para_tabs
integer x = 41
integer y = 624
integer width = 1166
integer height = 228
integer taborder = 10
boolean bringtotop = true
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;////////////////////////////////////////////////////////////////
// Se verifica si la fila en la que esta posicionada es valida.
////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT ISNULL(row) THEN
	This.SelectRow(0,FALSE)
	il_fila_actual_detalle[ii_dw_actual] = row
ELSE
END IF

end event

event doubleclicked;call super::doubleclicked;////////////////////////////////////////////////////////////////
// Se verifica si la fila en la que esta posicionada es valida.
////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT ISNULL(row) THEN
	This.SelectRow(0,FALSE)
	il_fila_actual_detalle[ii_dw_actual] = row
ELSE
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0,FALSE)
il_fila_actual_detalle[ii_dw_actual] = This.GetRow()
This.SetRow(il_fila_actual_detalle[ii_dw_actual])
This.SelectRow(il_fila_actual_detalle[ii_dw_actual],TRUE)
end event

