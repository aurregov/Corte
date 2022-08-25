HA$PBExportHeader$u_tabpage_base.sru
$PBExportComments$Phone directory tab page
forward
global type u_tabpage_base from userobject
end type
end forward

global type u_tabpage_base from userobject
integer width = 1769
integer height = 484
long backcolor = 73955432
long tabtextcolor = 33554432
long tabbackcolor = 73955432
long picturemaskcolor = 553648127
event type long ue_itemchanged_dw ( long row,  dwobject dwo,  string data,  string as_datawindow )
event type long ue_buttonclicked_dw ( long row,  long actionreturncode,  dwobject dwo,  string as_datawindow )
event type long ue_clicked_dw ( integer xpos,  integer ypos,  long row,  dwobject dwo,  string as_datawindow )
event type long ue_doubleclicked_dw ( integer xpos,  integer ypos,  long row,  dwobject dwo,  string as_datawindow )
event type long ue_itemfocuschanged_dw ( long row,  dwobject dwo,  string as_datawindow )
end type
global u_tabpage_base u_tabpage_base

type variables
/* variable para indicar cuando debe cargar el objeto como tabpage
si el valor es 1 carga cuando se hace clic en dw_item del planeador si es 2 
carga cuando se hace clic sobre las barras*/
Integer  ii_objeto
end variables

forward prototypes
public function integer of_resize ()
end prototypes

event type long ue_itemchanged_dw(long row, dwobject dwo, string data, string as_datawindow);long ll_retorno

If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event ue_itemchanged_dw(row,dwo,data,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_buttonclicked_dw(long row, long actionreturncode, dwobject dwo, string as_datawindow);Long ll_retorno

If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event ue_buttonclicked_dw(row,actionreturncode,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_clicked_dw(integer xpos, integer ypos, long row, dwobject dwo, string as_datawindow);long ll_retorno
If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event ue_clicked_dw(xpos,ypos,row,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_doubleclicked_dw(integer xpos, integer ypos, long row, dwobject dwo, string as_datawindow);long ll_retorno
If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event ue_doubleclicked_dw(xpos,ypos,row,dwo,as_datawindow)
Else
	ll_retorno = 0
End If

Return ll_retorno
end event

event type long ue_itemfocuschanged_dw(long row, dwobject dwo, string as_datawindow);Long ll_retorno
If Parent.TriggerEvent("ue_eventos_tab") = 1 Then
	ll_retorno = Parent.Dynamic Event ue_itemfocuschanged_dw(row,dwo,as_datawindow)
Else
	ll_retorno = 0
End If
Return ll_retorno


end event

public function integer of_resize ();Return 1
end function

on u_tabpage_base.create
end on

on u_tabpage_base.destroy
end on

