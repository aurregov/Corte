HA$PBExportHeader$w_mto_consumo_proceso.srw
forward
global type w_mto_consumo_proceso from w_mto_base
end type
end forward

global type w_mto_consumo_proceso from w_mto_base
integer width = 1253
integer height = 860
string title = "Consumo Proceso"
string menuname = "m_mantenimiento_simple"
boolean resizable = false
end type
global w_mto_consumo_proceso w_mto_consumo_proceso

on w_mto_consumo_proceso.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_mto_consumo_proceso.destroy
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

type dw_1 from w_mto_base`dw_1 within w_mto_consumo_proceso
integer x = 23
integer y = 20
integer width = 1175
string dataobject = "d_mto_consumo_proceso"
boolean vscrollbar = true
end type

