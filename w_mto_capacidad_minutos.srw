HA$PBExportHeader$w_mto_capacidad_minutos.srw
forward
global type w_mto_capacidad_minutos from w_mto_base
end type
end forward

global type w_mto_capacidad_minutos from w_mto_base
integer width = 3611
integer height = 1552
string title = "Capacidad Minutos"
string menuname = "m_mantenimiento_simple"
boolean resizable = false
end type
global w_mto_capacidad_minutos w_mto_capacidad_minutos

on w_mto_capacidad_minutos.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_mto_capacidad_minutos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;This.X = 1
This.Y = 1

dw_1.Of_Changed(True)

If dw_1.Of_Conexion(Sqlca,True) = -1 Then
	MessageBox("Advertencia!","No se pudo establecer una conexi$$HEX1$$f300$$ENDHEX$$n con la base de datos.")
	Close(This)
	Return
End If

dw_1.Retrieve()
end event

event ue_borrar_maestro;call super::ue_borrar_maestro;
dw_1.Of_DeleteRow()
end event

event ue_insertar_maestro();call super::ue_insertar_maestro;Long ll_fila


ll_fila = dw_1.Of_InsertRow(0)

dw_1.SetRow(ll_fila)
dw_1.SetColumn(1)
dw_1.ScrollToRow(ll_fila)
end event

event ue_grabar;String ls_sqlerr



If dw_1.Of_Save() = 1 Then
	ls_sqlerr = Sqlca.SqlerrText
	rollback ;
	MessageBox("Advertencia!","No se pudo grabar los datos.~n~n~nNota: " + ls_sqlerr)
Else
	commit ;
End If
end event

type dw_1 from w_mto_base`dw_1 within w_mto_capacidad_minutos
integer x = 23
integer y = 20
integer width = 3547
integer height = 1304
string dataobject = "d_mto_capacidad_minutos"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::itemfocuschanged;call super::itemfocuschanged;n_cts_param luo_param



If dwo.Name = 'co_planta' Then
	
	luo_param.il_vector[1] = This.GetItemNumber(Row,'co_fabrica')
	
	OpenWithParm(w_fabrica_planta,luo_param)
	
	luo_param = Message.PowerObjectParm
	
	If IsValid(luo_param) Then
		This.SetItem(Row,'co_planta',luo_param.il_vector[1])
		This.SetItem(Row,'de_planta',luo_param.is_vector[1])
		This.SetColumn('co_centro_pdn')
	End If	
End If


If dwo.Name = 'co_centro_pdn' Then
	
	luo_param.il_vector[1] = This.GetItemNumber(Row,'co_tipoprod')
	
	OpenWithParm(w_centro_produccion,luo_param)
	
	luo_param = Message.PowerObjectParm
	
	If IsValid(luo_param) Then
		This.SetItem(Row,'co_centro_pdn',luo_param.il_vector[1])
		This.SetItem(Row,'de_centro_pdn',luo_param.is_vector[1])
		This.SetColumn('co_subcentro_pdn')
	End If	
End If

If dwo.Name = 'co_subcentro_pdn' Then
	
	luo_param.il_vector[1] = This.GetItemNumber(Row,'co_tipoprod')
	luo_param.il_vector[2] = This.GetItemNumber(Row,'co_centro_pdn')
	
	OpenWithParm(w_subcentro_produccion,luo_param)

	luo_param = Message.PowerObjectParm
	
	If IsValid(luo_param) Then
		This.SetItem(Row,'co_subcentro_pdn',luo_param.il_vector[1])
		This.SetItem(Row,'de_subcentro_pdn',luo_param.is_vector[1])
		This.SetColumn('co_proceso_pdn')
	End If	
End If

If dwo.Name = 'co_proceso_pdn' Then
	
	luo_param.il_vector[1] = This.GetItemNumber(Row,'co_tipoprod')
	luo_param.il_vector[2] = This.GetItemNumber(Row,'co_subcentro_pdn')
	luo_param.il_vector[3] = This.GetItemNumber(Row,'co_centro_pdn')
	
	OpenWithParm(w_producto,luo_param)

	luo_param = Message.PowerObjectParm
	
	If IsValid(luo_param) Then
		This.SetItem(Row,'co_proceso_pdn',luo_param.il_vector[1])
		This.SetItem(Row,'de_proceso_pdn',luo_param.is_vector[1])
		This.SetColumn('cs_nivel')
	End If	
End If
end event

