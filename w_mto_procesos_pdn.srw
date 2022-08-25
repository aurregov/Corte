HA$PBExportHeader$w_mto_procesos_pdn.srw
forward
global type w_mto_procesos_pdn from w_mto_base
end type
end forward

global type w_mto_procesos_pdn from w_mto_base
integer width = 2414
integer height = 1552
string title = "Procesos Producci$$HEX1$$f300$$ENDHEX$$n"
string menuname = "m_mantenimiento_simple"
boolean resizable = false
end type
global w_mto_procesos_pdn w_mto_procesos_pdn

on w_mto_procesos_pdn.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_mto_procesos_pdn.destroy
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

event ue_insertar_maestro;call super::ue_insertar_maestro;
dw_1.Of_InsertRow(0)
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

type dw_1 from w_mto_base`dw_1 within w_mto_procesos_pdn
integer x = 23
integer y = 20
integer width = 2336
integer height = 1304
string dataobject = "d_mto_procesos_pdn"
boolean vscrollbar = true
end type

event dw_1::itemfocuschanged;call super::itemfocuschanged;n_cts_param luo_param


If dwo.Name = 'co_centro_pdn' Then
	
	luo_param.il_vector[1] = This.GetItemNumber(Row,'co_tipoprod')
	
	OpenWithParm(w_centro_produccion,luo_param)
	
	luo_param = Message.PowerObjectParm
	
	If IsValid(luo_param) Then
		This.SetItem(Row,'co_centro_pdn',luo_param.il_vector[1])
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
		This.SetColumn('co_proceso_pdn')
	End If	
End If

end event

