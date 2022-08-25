HA$PBExportHeader$w_actualizar_modulo_kamban.srw
forward
global type w_actualizar_modulo_kamban from w_base_tabular
end type
end forward

global type w_actualizar_modulo_kamban from w_base_tabular
integer width = 3232
integer height = 1528
end type
global w_actualizar_modulo_kamban w_actualizar_modulo_kamban

event ue_buscar;Long li_respuesta

IF wf_detectar_cambios (dw_maestro) = 1 THEN
	li_respuesta = MessageBox("Cambios detectados","Desea grabar los cambios  en el maestro",Question!,YesNoCancel!)
	IF li_respuesta = 1 THEN
		This.TriggerEvent("ue_grabar")
	ELSE
		IF li_respuesta = 3 THEN
			Return
		END IF
	END IF
END IF

IF dw_maestro.Retrieve(Long(sle_argumento.text)) > 0 THEN
	il_fila_actual_maestro = 1
	dw_maestro.SetRow(il_fila_actual_maestro)
	dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
	dw_maestro.ScrollToRow(il_fila_actual_maestro)
	dw_maestro.SetColumn(1)
	dw_maestro.SetFocus()
ELSE
END IF
end event

on w_actualizar_modulo_kamban.create
call super::create
end on

on w_actualizar_modulo_kamban.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_actualizar_modulo_kamban
integer x = 27
integer y = 92
integer width = 3145
integer height = 1240
string dataobject = "dtb_actualizar_modulo_kamban"
end type

event dw_maestro::doubleclicked;call super::doubleclicked;s_base_parametros lstr_parametros

IF Row > 0 THEN
	IF Dwo.Name = 'co_modulo' THEN
		lstr_parametros.entero[1] = This.GetItemNumber(Row, 'co_fabrica_planta')
		lstr_parametros.entero[2] = This.GetItemNumber(Row, 'co_planta')
		lstr_parametros.entero[3] = This.GetItemNumber(Row, 'co_tipoprod')
		lstr_parametros.entero[4] = This.GetItemNumber(Row, 'co_centro_pdn')
		lstr_parametros.entero[5] = This.GetItemNumber(Row, 'co_subcentro_pdn')
		OpenWithParm(w_seleccionar_modulo_subcentro, lstr_parametros)
		lstr_parametros = Message.PowerObjectParm
		IF lstr_parametros.hay_parametros THEN
			This.SetItem(Row, 'co_modulo', lstr_parametros.entero[1])
			This.SetItem(Row, 'de_modulo', lstr_parametros.cadena[1])
		END IF
	END IF
END IF
end event

type sle_argumento from w_base_tabular`sle_argumento within w_actualizar_modulo_kamban
integer x = 297
integer y = 16
end type

type st_1 from w_base_tabular`st_1 within w_actualizar_modulo_kamban
integer x = 27
end type

