HA$PBExportHeader$w_centro_produccion.srw
forward
global type w_centro_produccion from window
end type
type cb_2 from commandbutton within w_centro_produccion
end type
type cb_1 from commandbutton within w_centro_produccion
end type
type dw_1 from u_dw_base within w_centro_produccion
end type
end forward

global type w_centro_produccion from window
integer width = 1248
integer height = 1252
boolean titlebar = true
string title = "Centros Producci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_centro_produccion w_centro_produccion

on w_centro_produccion.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_centro_produccion.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;n_cts_param luo_param

Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

luo_param = Message.PowerObjectParm

dw_1.Of_Conexion(Sqlca,True)
dw_1.Retrieve(luo_param.il_vector[1])

dw_1.SetFocus()

end event

type cb_2 from commandbutton within w_centro_produccion
integer x = 617
integer y = 1012
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_1 from commandbutton within w_centro_produccion
integer x = 242
integer y = 1012
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
end type

event clicked;n_cts_param luo_param
Long ll_fila


ll_fila = dw_1.GetRow()

If ll_fila <= 0 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe selaccionar un centro.")
	Return
End If


luo_param.il_vector[1] = dw_1.GetItemNumber(ll_fila,"co_centro_pdn")
luo_param.is_vector[1] = dw_1.GetItemString(ll_fila,"de_centro_pdn")

CloseWithReturn(Parent,luo_param)




end event

type dw_1 from u_dw_base within w_centro_produccion
integer x = 23
integer y = 16
integer width = 1166
integer height = 936
integer taborder = 10
string dataobject = "d_centros_produccion"
end type

event rowfocuschanged;

If currentrow > 0 Then
	This.SelectRow(0,False)
	This.SelectRow(currentrow,True)
End If
end event

event doubleclicked;call super::doubleclicked;

If Row > 0 Then
	cb_1.TriggerEvent(clicked!)	
End If
end event

