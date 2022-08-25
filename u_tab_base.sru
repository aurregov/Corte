HA$PBExportHeader$u_tab_base.sru
$PBExportComments$//tab control base
forward
global type u_tab_base from u_tab
end type
end forward

global type u_tab_base from u_tab
event type long ue_itemchanged_dw ( long row,  dwobject dwo,  string data,  string as_datawindow )
event type long ue_buttonclicked_dw ( long row,  long actionreturncode,  dwobject dwo,  string as_datawindow )
event type long ue_clicked_dw ( integer xpos,  integer ypos,  long row,  dwobject dwo,  string as_datawindow )
event type integer ue_eventos_tab ( )
event type long ue_doubleclicked_dw ( integer xpos,  integer ypos,  long row,  dwobject dwo,  string as_datawindow )
event type long ue_itemfocuschanged_dw ( long row,  dwobject dwo,  string as_datawindow )
end type
global u_tab_base u_tab_base

forward prototypes
public function integer of_resize ()
end prototypes

event type long ue_itemchanged_dw(long row, dwobject dwo, string data, string as_datawindow);Long ll_retorno

If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event itemchanged_dw(row,dwo,data,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_buttonclicked_dw(long row, long actionreturncode, dwobject dwo, string as_datawindow);Long ll_retorno

If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.dynamic Event buttonclicked_dw(row,actionreturncode,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_clicked_dw(integer xpos, integer ypos, long row, dwobject dwo, string as_datawindow);long ll_retorno

If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event clicked_dw(xpos,ypos,row,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type integer ue_eventos_tab();Return 1
end event

event type long ue_doubleclicked_dw(integer xpos, integer ypos, long row, dwobject dwo, string as_datawindow);long ll_retorno

If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event doubleclicked_dw(xpos,ypos,row,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_itemfocuschanged_dw(long row, dwobject dwo, string as_datawindow);Long ll_retorno
If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event itemfocuschanged_dw(row,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno


end event

public function integer of_resize ();u_tabpage_base luo_page
Long ll_i

For ll_i = 1 To UpperBound(This.Control)
	luo_page = This.Control[ll_i]
	If IsValid(luo_page) Then
		luo_page.of_resize( )
	End If
Next


Return 1
end function

event selectionchanged;call super::selectionchanged;u_tabpage_base luo_tabpage
datawindow ldw_datos

If oldindex > 0 Then
		This.Control[oldindex].TabTextColor =  RGB(0,0,0)
		This.Control[newindex].TabTextColor = RGB(0,0,255) 
		luo_tabpage = This.Control[newindex]
		If TypeOf(luo_tabpage.Control[1]) = datawindow! Then
			ldw_datos = luo_tabpage.Control[1]
			ldw_datos.Setfocus( )
		End If
End If

end event

