HA$PBExportHeader$w_buscar_produccion_base.srw
forward
global type w_buscar_produccion_base from window
end type
type pb_2 from picturebutton within w_buscar_produccion_base
end type
type pb_1 from picturebutton within w_buscar_produccion_base
end type
type dw_1 from datawindow within w_buscar_produccion_base
end type
type gb_1 from groupbox within w_buscar_produccion_base
end type
end forward

global type w_buscar_produccion_base from window
integer width = 2235
integer height = 1272
boolean titlebar = true
string title = "Producciones"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
pb_2 pb_2
pb_1 pb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_buscar_produccion_base w_buscar_produccion_base

on w_buscar_produccion_base.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.dw_1,&
this.gb_1}
end on

on w_buscar_produccion_base.destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;n_cts_param luo_param

Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = ((PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2) + 150
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

luo_param = Message.PowerObjectParm

dw_1.SetTransObject(sqlca)

dw_1.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2])
end event

type pb_2 from picturebutton within w_buscar_produccion_base
integer x = 1157
integer y = 1024
integer width = 375
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cacelar"
string picturename = "C:\graficos\Cancelar.bmp"
alignment htextalign = right!
end type

event clicked;n_cts_param luo_raya
Long ll_fila

luo_raya.il_vector[3] = 0

CloseWithReturn(Parent,luo_raya)
end event

type pb_1 from picturebutton within w_buscar_produccion_base
integer x = 617
integer y = 1024
integer width = 375
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
string picturename = "C:\graficos\Ok.bmp"
alignment htextalign = right!
end type

event clicked;n_cts_param luo_pdn
Long ll_fila,ll_fila1

//luo_raya = Create n_cts_param_raya


For ll_fila = 1 To dw_1.RowCount()
	IF dw_1.IsSelected(ll_fila) = TRUE THEN
		ll_fila1 ++
		luo_pdn.il_vector2[ll_fila1] = dw_1.GetItemNumber(ll_fila,'cs_pdn')
	END IF
Next

luo_pdn.il_vector[3] = ll_fila1 
CloseWithReturn(Parent,luo_pdn)
end event

type dw_1 from datawindow within w_buscar_produccion_base
integer x = 46
integer y = 44
integer width = 2126
integer height = 836
integer taborder = 10
string title = "none"
string dataobject = "dtb_buscar_produccion_raya"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF IsSelected (Row ) = FALSE THEN
	dw_1.SelectRow(Row,TRUE)
ELSE 
	dw_1.SelectRow(Row,FALSE)
END IF
end event

event rbuttondown;Long ll_fila

For ll_fila = 1 To dw_1.RowCount()
	dw_1.SelectRow(ll_fila,TRUE)
Next
end event

type gb_1 from groupbox within w_buscar_produccion_base
integer x = 23
integer width = 2176
integer height = 904
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

