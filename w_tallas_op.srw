HA$PBExportHeader$w_tallas_op.srw
forward
global type w_tallas_op from window
end type
type st_1 from statictext within w_tallas_op
end type
type cb_cancelar from commandbutton within w_tallas_op
end type
type cb_aceptar from commandbutton within w_tallas_op
end type
type dw_lista from datawindow within w_tallas_op
end type
type gb_1 from groupbox within w_tallas_op
end type
end forward

global type w_tallas_op from window
integer width = 1376
integer height = 1408
boolean titlebar = true
string title = "Tallas O.P."
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_tallas_op w_tallas_op

on w_tallas_op.create
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_tallas_op.destroy
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2])
dw_lista.SetFocus()
end event

type st_1 from statictext within w_tallas_op
integer x = 59
integer y = 20
integer width = 1138
integer height = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencia BodySize, debe seleccionar la talla a liberar"
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_tallas_op
integer x = 718
integer y = 1108
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_tallas_op
integer x = 183
integer y = 1108
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_lista.GetRow()

IF ll_fila > 0 THEN
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(ll_fila,'co_talla')
	lstr_parametros.hay_parametros = True
	CloseWithReturn ( Parent, lstr_parametros )
END IF



end event

type dw_lista from datawindow within w_tallas_op
integer x = 73
integer y = 176
integer width = 1230
integer height = 820
integer taborder = 10
string title = "none"
string dataobject = "dgr_tallas_op_color"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_tallas_op
integer x = 46
integer y = 128
integer width = 1285
integer height = 896
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

