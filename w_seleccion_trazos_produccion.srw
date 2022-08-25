HA$PBExportHeader$w_seleccion_trazos_produccion.srw
forward
global type w_seleccion_trazos_produccion from window
end type
type cb_2 from commandbutton within w_seleccion_trazos_produccion
end type
type dw_1 from u_dw_base within w_seleccion_trazos_produccion
end type
type cb_1 from commandbutton within w_seleccion_trazos_produccion
end type
end forward

global type w_seleccion_trazos_produccion from window
integer width = 2245
integer height = 1260
boolean titlebar = true
string title = "Producci$$HEX1$$f300$$ENDHEX$$n - Trazos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_select ( long an_select )
event ue_menu ( )
cb_2 cb_2
dw_1 dw_1
cb_1 cb_1
end type
global w_seleccion_trazos_produccion w_seleccion_trazos_produccion

type variables

m_select im_select
end variables

event ue_select(long an_select);Long li_i


For li_i = 1 To dw_1.RowCount()
	dw_1.SetItem(li_i,'select',an_select)
Next

end event

event ue_menu();im_select.m_edicion.PopMenu(This.PointerX(),this.PointerY())
end event

on w_seleccion_trazos_produccion.create
this.cb_2=create cb_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.cb_2,&
this.dw_1,&
this.cb_1}
end on

on w_seleccion_trazos_produccion.destroy
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;n_cts_param luo_param
Long li_tpprod,li_centro,li_subcentro  



Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = ((PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2) + 150
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

im_select = Create m_select

luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If

dw_1.SetTransObject(Sqlca)

dw_1.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2])
								 

end event

event closequery;Destroy im_select
end event

type cb_2 from commandbutton within w_seleccion_trazos_produccion
integer x = 1184
integer y = 1024
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type dw_1 from u_dw_base within w_seleccion_trazos_produccion
integer x = 23
integer y = 20
integer width = 2176
integer height = 976
integer taborder = 10
string dataobject = "d_lista_trazos_produccion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event rbuttondown;call super::rbuttondown;Parent.TriggerEvent("ue_menu")
end event

type cb_1 from commandbutton within w_seleccion_trazos_produccion
integer x = 800
integer y = 1024
integer width = 343
integer height = 92
integer taborder = 40
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
Long li_i,ll_sw,li_cont


li_cont = 0

For li_i  = 1 To dw_1.RowCount()
	ll_sw = dw_1.GetItemNumber(li_i,'select')
	
	If ll_sw = 1 Then
		li_cont ++ 
		luo_param.il_vector[li_cont] = dw_1.GetItemNumber(li_i,'cs_pdn')
	End If
Next				

If li_cont = 0 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar la producci$$HEX1$$f300$$ENDHEX$$n.")
	Return
End If
	
CloseWithReturn(Parent,luo_param)
end event

