HA$PBExportHeader$w_tallas_cantidad_produccion.srw
forward
global type w_tallas_cantidad_produccion from window
end type
type dw_1 from u_dw_base within w_tallas_cantidad_produccion
end type
type cb_1 from commandbutton within w_tallas_cantidad_produccion
end type
end forward

global type w_tallas_cantidad_produccion from window
integer width = 882
integer height = 1248
boolean titlebar = true
string title = "Tallas"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
cb_1 cb_1
end type
global w_tallas_cantidad_produccion w_tallas_cantidad_produccion

on w_tallas_cantidad_produccion.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.dw_1,&
this.cb_1}
end on

on w_tallas_cantidad_produccion.destroy
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


luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If

dw_1.SetTransObject(Sqlca)

dw_1.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
    			 luo_param.is_vector[1],luo_param.il_vector[4],luo_param.il_vector[5],&
				 luo_param.il_vector[6],luo_param.il_vector[7],luo_param.is_vector[2],&
				 luo_param.il_vector[8],luo_param.il_vector[9])
								 

end event

type dw_1 from u_dw_base within w_tallas_cantidad_produccion
integer x = 23
integer y = 20
integer width = 809
integer height = 976
integer taborder = 10
string dataobject = "d_lista_tallas_produccion"
end type

type cb_1 from commandbutton within w_tallas_cantidad_produccion
integer x = 224
integer y = 1024
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cerrar"
end type

event clicked;n_cts_param_talla luo_pmtalla
Long li_i,ll_sw,li_cont


li_cont = 0

For li_i  = 1 To dw_1.RowCount()
	ll_sw = dw_1.GetItemNumber(li_i,'select')
	
	If ll_sw = 1 Then
		li_cont ++ 
		luo_pmtalla.il_orden[li_cont] = dw_1.GetItemNumber(li_i,'cs_orden_talla')
		luo_pmtalla.il_talla[li_cont] = dw_1.GetItemNumber(li_i,'co_talla')
		luo_pmtalla.il_cant[li_cont]  = dw_1.GetItemNumber(li_i,'ca_programada')
	End If
Next				


CloseWithReturn(Parent,luo_pmtalla)
end event

