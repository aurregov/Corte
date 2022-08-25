HA$PBExportHeader$w_parametros_seccion_x_trazo.srw
forward
global type w_parametros_seccion_x_trazo from window
end type
type st_2 from statictext within w_parametros_seccion_x_trazo
end type
type cb_2 from commandbutton within w_parametros_seccion_x_trazo
end type
type em_1 from editmask within w_parametros_seccion_x_trazo
end type
type st_1 from statictext within w_parametros_seccion_x_trazo
end type
type dw_fabrica from u_dw_base within w_parametros_seccion_x_trazo
end type
type cb_1 from commandbutton within w_parametros_seccion_x_trazo
end type
type dw_trazo from u_dw_base within w_parametros_seccion_x_trazo
end type
type dw_agrupacion from u_dw_base within w_parametros_seccion_x_trazo
end type
type gb_1 from groupbox within w_parametros_seccion_x_trazo
end type
type gb_2 from groupbox within w_parametros_seccion_x_trazo
end type
end forward

global type w_parametros_seccion_x_trazo from window
integer width = 1477
integer height = 1836
boolean titlebar = true
string title = "Trazos por Agrupaci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_2 st_2
cb_2 cb_2
em_1 em_1
st_1 st_1
dw_fabrica dw_fabrica
cb_1 cb_1
dw_trazo dw_trazo
dw_agrupacion dw_agrupacion
gb_1 gb_1
gb_2 gb_2
end type
global w_parametros_seccion_x_trazo w_parametros_seccion_x_trazo

on w_parametros_seccion_x_trazo.create
this.st_2=create st_2
this.cb_2=create cb_2
this.em_1=create em_1
this.st_1=create st_1
this.dw_fabrica=create dw_fabrica
this.cb_1=create cb_1
this.dw_trazo=create dw_trazo
this.dw_agrupacion=create dw_agrupacion
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.st_2,&
this.cb_2,&
this.em_1,&
this.st_1,&
this.dw_fabrica,&
this.cb_1,&
this.dw_trazo,&
this.dw_agrupacion,&
this.gb_1,&
this.gb_2}
end on

on w_parametros_seccion_x_trazo.destroy
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.dw_fabrica)
destroy(this.cb_1)
destroy(this.dw_trazo)
destroy(this.dw_agrupacion)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;DataWindowChild ldwc_fabrica
Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If


dw_agrupacion.SetTransObject(Sqlca)
dw_trazo.SetTransObject(Sqlca)

dw_fabrica.GetChild('co_fabrica',ldwc_fabrica)
ldwc_fabrica.SetTransObject(Sqlca)
ldwc_fabrica.Retrieve()

dw_fabrica.InsertRow(0)
dw_fabrica.SetItem(1,'co_fabrica',91)
end event

type st_2 from statictext within w_parametros_seccion_x_trazo
integer x = 23
integer y = 52
integer width = 183
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "F$$HEX1$$e100$$ENDHEX$$brica"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_parametros_seccion_x_trazo
integer x = 393
integer y = 1580
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;n_cts_param luo_param
Long ll_fila


ll_fila = dw_trazo.GetRow()

If ll_fila <= 0 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar un trazo.")
	Return
End If

luo_param.il_Vector[1] = dw_trazo.GetItemNumber(ll_fila,'cs_agrupacion')
luo_param.il_Vector[2] = dw_trazo.GetItemNumber(ll_fila,'cs_base_trazos')

CloseWithReturn(Parent,luo_param)
end event

type em_1 from editmask within w_parametros_seccion_x_trazo
integer x = 1083
integer y = 40
integer width = 343
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###########"
end type

event modified;Long ll_agrupa


ll_agrupa = Long(This.Text)

If Not IsNull(ll_agrupa) Then
	dw_agrupacion.Retrieve(91,ll_agrupa)	
End If
end event

type st_1 from statictext within w_parametros_seccion_x_trazo
integer x = 914
integer y = 52
integer width = 169
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pedido"
boolean focusrectangle = false
end type

type dw_fabrica from u_dw_base within w_parametros_seccion_x_trazo
integer x = 201
integer y = 40
integer width = 699
integer height = 96
string dataobject = "d_fabrica_trazo_x_agrupacion"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_1 from commandbutton within w_parametros_seccion_x_trazo
integer x = 777
integer y = 1580
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;
Close(Parent)
end event

type dw_trazo from u_dw_base within w_parametros_seccion_x_trazo
integer x = 64
integer y = 912
integer width = 1312
integer taborder = 20
string dataobject = "d_lista_trazos_x_agrupacion"
end type

event clicked;call super::clicked;
If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

end event

type dw_agrupacion from u_dw_base within w_parametros_seccion_x_trazo
integer x = 64
integer y = 208
integer width = 1312
integer taborder = 10
string dataobject = "d_lista_h_agrupa_pdn"
end type

event rowfocuschanged;call super::rowfocuschanged;Long ll_agrupa


If currentrow <= 0 Then
	dw_trazo.Reset()
Else
	ll_agrupa = This.GetItemNumber(currentrow,'cs_agrupacion')
	dw_trazo.Retrieve(ll_agrupa)
	dw_trazo.Retrieve(ll_agrupa)
End If
end event

type gb_1 from groupbox within w_parametros_seccion_x_trazo
integer x = 23
integer y = 144
integer width = 1403
integer height = 704
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agrupaci$$HEX1$$f300$$ENDHEX$$n"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_parametros_seccion_x_trazo
integer x = 23
integer y = 848
integer width = 1403
integer height = 704
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trazo"
borderstyle borderstyle = stylelowered!
end type

