HA$PBExportHeader$w_buscar_escalas_tela.srw
forward
global type w_buscar_escalas_tela from window
end type
type pb_2 from picturebutton within w_buscar_escalas_tela
end type
type pb_1 from picturebutton within w_buscar_escalas_tela
end type
type dw_1 from datawindow within w_buscar_escalas_tela
end type
type gb_1 from groupbox within w_buscar_escalas_tela
end type
end forward

global type w_buscar_escalas_tela from window
integer width = 777
integer height = 1300
boolean titlebar = true
string title = "Buscar Escalas Telas"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
pb_2 pb_2
pb_1 pb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_buscar_escalas_tela w_buscar_escalas_tela

on w_buscar_escalas_tela.create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.pb_2,&
this.pb_1,&
this.dw_1,&
this.gb_1}
end on

on w_buscar_escalas_tela.destroy
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

dw_1.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3])


end event

type pb_2 from picturebutton within w_buscar_escalas_tela
integer x = 407
integer y = 1080
integer width = 297
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
string picturename = "C:\graficos\Cancelar.bmp"
alignment htextalign = right!
end type

event clicked;n_cts_param_raya luo_raya
Long ll_fila

luo_raya = Create n_cts_param_raya

luo_raya.il_fila[1] = 0

CloseWithReturn(Parent,luo_raya)
end event

type pb_1 from picturebutton within w_buscar_escalas_tela
integer x = 55
integer y = 1080
integer width = 297
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

event clicked;n_cts_param_raya luo_raya
Long ll_fila,ll_fila1

luo_raya = Create n_cts_param_raya


For ll_fila = 1 To dw_1.RowCount()
	
	IF dw_1.IsSelected(ll_fila) = TRUE THEN
		ll_fila1 ++
		luo_raya.il_modelo[ll_fila1] = dw_1.GetItemNumber(ll_fila,'co_talla')
		luo_raya.il_reftel[ll_fila1] = dw_1.GetItemNumber(ll_fila,'cs_talla')
		luo_raya.il_caract[ll_fila1] = dw_1.GetItemNumber(ll_fila,'co_estado')
		luo_raya.il_diametro[ll_fila1] = dw_1.GetItemNumber(ll_fila,'ca_unidades')
	END IF
	
Next

luo_raya.il_fila[1] = ll_fila1 
CloseWithReturn(Parent,luo_raya)
end event

type dw_1 from datawindow within w_buscar_escalas_tela
integer x = 82
integer y = 56
integer width = 603
integer height = 892
integer taborder = 10
string title = "none"
string dataobject = "dtb_buscar_escalas_tela"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Long ll_fila

For ll_fila = 1 To dw_1.RowCount()
	dw_1.SelectRow(ll_fila,TRUE)
Next
end event

event clicked;IF IsSelected (Row ) = FALSE THEN
	dw_1.SelectRow(Row,TRUE)
ELSE 
	dw_1.SelectRow(Row,FALSE)
END IF
end event

type gb_1 from groupbox within w_buscar_escalas_tela
integer x = 55
integer y = 8
integer width = 654
integer height = 968
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

