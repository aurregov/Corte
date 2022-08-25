HA$PBExportHeader$w_buscar_dato.srw
forward
global type w_buscar_dato from w_buscar
end type
type dw_dato from datawindow within w_buscar_dato
end type
end forward

global type w_buscar_dato from w_buscar
event ue_open ( )
dw_dato dw_dato
end type
global w_buscar_dato w_buscar_dato

type variables
string is_name
boolean ib_activa

end variables

event ue_open();/*se ordena el datawindows por la segunda columna
dbelalca
*/

dw_dato.InsertRow(0)
dw_lista.SetRedraw(False)
dw_lista.SetSort("#2 A")
dw_lista.Sort()
dw_lista.SetRedraw(True)
dw_dato.setfocus( )
end event

on w_buscar_dato.create
int iCurrent
call super::create
this.dw_dato=create dw_dato
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dato
end on

on w_buscar_dato.destroy
call super::destroy
destroy(this.dw_dato)
end on

event open;call super::open;PostEvent("ue_open")
end event

event key;call super::key;
If Key = keyEnter! Then
	cb_aceptar.event clicked( )
End If
end event

type cb_cancelar from w_buscar`cb_cancelar within w_buscar_dato
end type

type cb_aceptar from w_buscar`cb_aceptar within w_buscar_dato
end type

type dw_lista from w_buscar`dw_lista within w_buscar_dato
integer x = 87
integer y = 248
integer width = 1097
integer height = 820
string title = ""
end type

event dw_lista::clicked;call super::clicked;If dwo.type = "text" then
	is_name = dwo.Name
	is_name = Left(is_name, Len(is_name) - 2)
	If ib_activa then
		ib_activa = false
	This.SetSort(is_name + ", A")
	Else
	This.SetSort(is_name + " D")
		ib_activa = true
	End if
	this.Sort()
	this.SetRedraw( true )
	This.SelectRow(0, FALSE)
End if


end event

type gb_1 from w_buscar`gb_1 within w_buscar_dato
integer x = 59
integer y = 176
integer width = 1157
integer height = 920
end type

type dw_dato from datawindow within w_buscar_dato
event enter pbm_dwnprocessenter
integer x = 87
integer y = 44
integer width = 1106
integer height = 120
integer taborder = 10
boolean bringtotop = true
string dataobject = "dff_campo_busqueda"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event enter;/* Al precionar el enter en el dw se dispara el evento
  clicked del boton aceptar
dbelalca

*/
if dw_lista.GetRow() > 0 Then
	cb_aceptar.event clicked( )
End If
end event

event editchanged;/*
Realiza el find busca la descripcion y se 
posiciona sobre el registro arrojado por el find
dbelalca
*/

long ll_row

Choose Case dwo.name
	Case "buscar_texto"
		ll_row = dw_lista.Find("de_codigo like '"+data+'%'+"'",&
					1, dw_lista.RowCount())
		
		If ll_row > 0 Then
			 dw_lista.SelectRow(0, FALSE)
			 dw_lista.ScrollToRow(ll_row)
		    dw_lista.SelectRow(ll_row, TRUE)
		
	End If

End Choose


Return 1
end event

