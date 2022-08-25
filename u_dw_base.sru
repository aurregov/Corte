HA$PBExportHeader$u_dw_base.sru
$PBExportComments$Control Datawindow Inteligente
forward
global type u_dw_base from datawindow
end type
end forward

global type u_dw_base from datawindow
integer width = 571
integer height = 600
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_enter pbm_dwnprocessenter
event type long of_insertrow ( long an_row )
end type
global u_dw_base u_dw_base

type variables

Private:
        Boolean lb_actualizacion = False
end variables

forward prototypes
public subroutine of_dobject (string as_dobject)
public function long of_conexion (transaction atr_conexion, boolean ab_live)
public function long of_deleterow ()
public function long of_insertrow (long an_row)
public function long of_save ()
public subroutine of_changed (boolean ab_update)
end prototypes

event ue_enter;If This.AcceptText() = 1 Then
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If	
end event

public subroutine of_dobject (string as_dobject);
This.DataObject = as_dobject
end subroutine

public function long of_conexion (transaction atr_conexion, boolean ab_live);
If ab_live Then
	Return This.SetTransObject(atr_conexion)
Else
	Return This.SetTrans(atr_conexion)
End If

end function

public function long of_deleterow ();
Long ll_row

If This.RowCount() = 0 Then Return 0

ll_row = This.GetRow()

If ll_row > 0 Then 
	This.DeleteRow(ll_row)
Else
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar la fila que desea borrar.")
End If
	
Return 0	

end function

public function long of_insertrow (long an_row);Long ll_fila

ll_fila = This.InsertRow(an_row)

If ll_fila <= 0 Then
	MessageBox("Advertencia!","No fue posible insertar la fila.",StopSign!)
	Return ll_fila
End If

This.ScrollToRow(ll_fila)
This.SetRow(ll_fila)

Return ll_fila
end function

public function long of_save ();
If This.AcceptText() = -1 Then 
	Return -1
ElseIf This.Update() = -1 Then
	Return -1
End If

Return 0


end function

public subroutine of_changed (boolean ab_update);
lb_actualizacion = ab_update
end subroutine

on u_dw_base.create
end on

on u_dw_base.destroy
end on

event itemchanged;

If Row > 0 And lb_actualizacion Then
	This.SetItem(Row,"fe_actualizacion",DateTime(Today(),Now()))
	This.SetItem(Row,"usuario",gstr_info_usuario.codigo_usuario)
	This.SetItem(Row,"instancia",gstr_info_usuario.instancia)
End If
	
end event

