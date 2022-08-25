HA$PBExportHeader$w_asignar_modulo_bongo.srw
forward
global type w_asignar_modulo_bongo from w_base_maestroff_detalletb
end type
end forward

global type w_asignar_modulo_bongo from w_base_maestroff_detalletb
integer width = 3099
integer height = 1748
string title = "Asignar M$$HEX1$$f300$$ENDHEX$$dulo a Bongos"
string menuname = "m_mantenimiento_simple"
end type
global w_asignar_modulo_bongo w_asignar_modulo_bongo

type variables
DataWindowChild idw_planta,idw_modulo
end variables

on w_asignar_modulo_bongo.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_asignar_modulo_bongo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;s_base_parametros lstr_parametros

Open(w_buscar_bongo)

lstr_parametros=message.powerObjectparm

If lstr_parametros.cadena[1] = 'S' Then
	dw_detalle.Visible = False
	dw_maestro.Visible = False
	If lstr_parametros.cadena[2] <> '' Then
		dw_maestro.Retrieve(lstr_parametros.cadena[2])
		dw_detalle.Retrieve(lstr_parametros.cadena[2])
	Else
		MessageBox('Advertencia','El n$$HEX1$$fa00$$ENDHEX$$mero de Recipiente seleccionado no es valido, por favor verifique.')
	End if
End if
end event

event open;call super::open;dw_maestro.GetChild('co_planta_modulo',idw_planta)
dw_maestro.GetChild('co_modulo',idw_modulo)


idw_planta.SetTransObject(SQLCA)
idw_modulo.SetTransObject(SQLCA)

dw_maestro.InsertRow(0)
dw_maestro.SetFocus()

idw_planta.Retrieve(91)
idw_modulo.Retrieve(91,1)

m_mantenimiento_simple.m_edicion.m_insertarmaestro.Enabled = False
m_mantenimiento_simple.m_edicion.m_borrarmaestro.Enabled = False
end event

event ue_grabar;//grabar los registros en el detalle con los datos del maestro
Long li_fab,li_pla,li_mod
Long ll_filas

li_fab = dw_maestro.GetItemNumber(1,'co_fabrica_modulo')
li_pla = dw_maestro.GetItemNumber(1,'co_planta_modulo')
li_mod = dw_maestro.GetItemNumber(1,'co_modulo')

If isnull(li_fab) Or isnull(li_pla) Or isnull(li_mod) Or li_fab = 0 Then
	MessageBox('Error','Debe ingresar todos los datos necesarios, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n')
	Return
End if

For ll_filas = 1 To dw_detalle.RowCount()
	dw_detalle.SetItem(ll_filas,'co_fabrica_modulo',li_fab)
	dw_detalle.SetItem(ll_filas,'co_planta_modulo',li_pla)
	dw_detalle.SetItem(ll_filas,'co_modulo',li_mod)
Next

//////////////////////////////////////////////////////////////////////////
// En este evento se realizar ACCEPTTEXT para llevar los cambios 
// del detalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////

//IF is_accion = "si update" THEN
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
//END IF

dw_maestro.Reset()
dw_detalle.Reset()
dw_maestro.InsertRow(0)

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
//	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF


   

end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_asignar_modulo_bongo
integer x = 530
integer y = 16
integer width = 1801
integer height = 504
string dataobject = "dff_asignar_modulo_bongo_maestro"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_maestro::retrieveend;call super::retrieveend;Long li_fab,li_pla,li_mod

If This.RowCount() > 0 Then
	li_fab = This.GetItemNumber(1,'co_fabrica_modulo')
	li_pla = This.GetItemNumber(1,'co_planta_modulo')
	li_mod = This.GetItemNumber(1,'co_modulo')
	
	If li_fab = 91 And li_pla = 2 and li_mod = 0 Then
		This.SetItem(1,'co_fabrica_modulo',0)
		This.SetItem(1,'de_planta','Sin Asignar')
		This.SetItem(1,'co_planta_modulo',0)
		This.SetItem(1,'co_modulo',0)
		
	End if
End if
end event

event dw_maestro::itemchanged;Long li_fab,li_pla,li_mod
String ls_planta,ls_mod,ls_bongo

choose case GetColumnName()
	case 'co_planta_modulo'
		li_fab = This.GetItemNumber(1,'co_fabrica_modulo')
		li_mod = This.GetItemNumber(1,'co_modulo')
		li_pla = Long(Data)
		select de_planta
		into :ls_planta
		from m_plantas
		where co_fabrica = :li_fab and
				co_planta = :li_pla;
				
		This.SetItem(1,'de_planta',ls_planta)	
		
		select de_modulo
		into :ls_mod
		from m_modulos
		where co_fabrica = :li_fab and
				co_planta = :li_pla and
				co_modulo = :li_mod;
				
		This.SetItem(1,'de_modulo',ls_mod)
		
		idw_modulo.Retrieve(li_fab,li_pla)
	
	case 'co_fabrica_modulo'
		li_pla = This.GetItemNumber(1,'co_planta_modulo')
		li_mod = This.GetItemNumber(1,'co_modulo')
		li_fab = Long(Data)
		select de_planta
		into :ls_planta
		from m_plantas
		where co_fabrica = :li_fab and
				co_planta = :li_pla;
				
		This.SetItem(1,'de_planta',ls_planta)
		
		select de_modulo
		into :ls_mod
		from m_modulos
		where co_fabrica = :li_fab and
				co_planta = :li_pla and
				co_modulo = :li_mod;
				
		This.SetItem(1,'de_modulo',ls_mod)		
				
		idw_planta.Retrieve(li_fab)
		idw_modulo.Retrieve(li_fab,li_pla)
		
	case 'co_modulo'
		li_fab = This.GetItemNumber(1,'co_fabrica_modulo')
		li_pla = This.GetItemNumber(1,'co_planta_modulo')
		li_mod = Long(Data)
		select de_modulo
		into :ls_mod
		from m_modulos
		where co_fabrica = :li_fab and
				co_planta = :li_pla and
				co_modulo = :li_mod;
				
		This.SetItem(1,'de_modulo',ls_mod)		
		
	case 'h_canasta_corte_pallet_id'
		ls_bongo = Data
		dw_maestro.retrieve(ls_bongo)
		dw_detalle.Retrieve(ls_bongo)
		
		If dw_maestro.RowCount() > 0 Then
		Else
			MessageBox('Advertencia','No existe Recipiente con este n$$HEX1$$fa00$$ENDHEX$$mero, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n')
			dw_maestro.InsertRow(0)
			dw_detalle.SetFocus()
			
		End if
		
		
		
end choose

end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_asignar_modulo_bongo
integer x = 37
integer y = 568
integer width = 2912
integer height = 944
string dataobject = "dtb_asignar_modulo_bongo_detalle"
boolean hsplitscroll = false
end type

event dw_detalle::retrieveend;call super::retrieveend;Long ll_filas


For ll_filas = 1 To This.RowCount()
	If This.GetItemNumber(ll_filas,'sw_cerrados') <> 2 Then
		MessageBox('Error','El Recipiente no se encuentra disponible, por favor verifique')
		dw_maestro.Reset()
		dw_detalle.Reset()
		dw_maestro.Visible = True
		dw_detalle.Visible = True
		Return
	End if
Next

dw_maestro.Visible = True
dw_detalle.Visible = True
end event

event dw_detalle::clicked;String ls
end event

event dw_detalle::rowfocuschanged;String ls
end event

