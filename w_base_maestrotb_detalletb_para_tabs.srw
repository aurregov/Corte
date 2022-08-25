HA$PBExportHeader$w_base_maestrotb_detalletb_para_tabs.srw
forward
global type w_base_maestrotb_detalletb_para_tabs from w_base_maestroff_detalletb_para_tabs
end type
end forward

global type w_base_maestrotb_detalletb_para_tabs from w_base_maestroff_detalletb_para_tabs
end type
global w_base_maestrotb_detalletb_para_tabs w_base_maestrotb_detalletb_para_tabs

on w_base_maestrotb_detalletb_para_tabs.create
call super::create
end on

on w_base_maestrotb_detalletb_para_tabs.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;call super::ue_buscar;dw_maestro.TriggerEvent("rowfocuschanged")
end event

event ue_insertar_maestro;////////////////////////////////////////////////////////////////////////
// Se omite el script del papa.
// Se adicionan las lineas necesarias para insertar un registro 
// en el maestro.
///////////////////////////////////////////////////////////////////////

Long ll_resultado, ll_fila
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
			CHOOSE CASE MessageBox("Cambios detectados", "Desea grabar los cambios en el maestro", Question!, YesNoCancel!)
				CASE 1
					is_accion = "grabo"
					This.TriggerEvent("ue_grabar")
				CASE 2
					is_accion = "no grabo"
					// NO GRABA Y SIGUE LA INSERCION
				CASE 3
					is_accion = "cancelo"
					RETURN
			END CHOOSE
	END CHOOSE
	
	ll_fila = dw_maestro.InsertRow(0)
	IF ll_fila = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
	ELSE
		dw_maestro.SetRow(ll_fila)
		dw_maestro.ScrollToRow(ll_fila)
		dw_maestro.SetColumn(1)
		dw_maestro.SelectRow(0,False)
		il_fila_actual_maestro = ll_fila
		dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))
	END IF

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

event dw_maestro::rowfocuschanged;This.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = This.GetRow()
This.SetRow(il_fila_actual_maestro)
This.SelectRow(il_fila_actual_maestro,TRUE)

// Cuando se hace el cambio de fila en el maestro se debe hacer la consulta de las carpetas
// Este c$$HEX1$$f300$$ENDHEX$$digo se debe copiar en el objeto y hacer las modificaciones pertinentes.
//Long li_dw_a_inicializar
//arg1, arg2
//
//arg1 = dw_maestro.GetItemNumber(il_fila_actual_maestro, "arg1")
//arg2 = dw_maestro.GetItemString(il_fila_actual_maestro, "arg2")
//li_dw_a_inicializar = 1
//DO WHILE li_dw_a_inicializar <= ii_num_dw
//	idw_arreglo_dw[li_dw_a_inicializar].Retrieve(arg1, arg2)
//	li_dw_a_inicializar++
//LOOP

end event

type tab_1 from w_base_maestroff_detalletb_para_tabs`tab_1 within w_base_maestrotb_detalletb_para_tabs
boolean BringToTop=true
end type

type tabpage_1 from w_base_maestroff_detalletb_para_tabs`tabpage_1 within tab_1
int X=18
int Y=112
int Width=1129
int Height=112
end type

type dw_detalle from w_base_maestroff_detalletb_para_tabs`dw_detalle within w_base_maestrotb_detalletb_para_tabs
boolean BringToTop=true
end type

