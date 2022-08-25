HA$PBExportHeader$w_buscar_op_liberacion_duo.srw
forward
global type w_buscar_op_liberacion_duo from window
end type
type cb_cancelar from commandbutton within w_buscar_op_liberacion_duo
end type
type cb_aceptar from commandbutton within w_buscar_op_liberacion_duo
end type
type dw_lista from datawindow within w_buscar_op_liberacion_duo
end type
type gb_1 from groupbox within w_buscar_op_liberacion_duo
end type
end forward

global type w_buscar_op_liberacion_duo from window
integer width = 1563
integer height = 1948
boolean titlebar = true
string title = "Orden de Producci$$HEX1$$f300$$ENDHEX$$n"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_buscar_op_liberacion_duo w_buscar_op_liberacion_duo

on w_buscar_op_liberacion_duo.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_buscar_op_liberacion_duo.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

dw_lista.SetTransObject(sqlca)
IF dw_lista.Retrieve(lstr_parametros.entero[1],&
						lstr_parametros.entero[2],&	
						lstr_parametros.entero[3],&
						lstr_parametros.entero[4],&
						lstr_parametros.entero[5]) <= 0 THEN
	MessageBox('Advertencia','No existe OP activa o con unidades pendientes que pueda ser utilizada.', Exclamation!)
END IF


dw_lista.SetFocus()
end event

type cb_cancelar from commandbutton within w_buscar_op_liberacion_duo
integer x = 791
integer y = 1684
integer width = 343
integer height = 100
integer taborder = 20
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

CloseWithreturn(Parent, lstr_parametros)
end event

type cb_aceptar from commandbutton within w_buscar_op_liberacion_duo
integer x = 352
integer y = 1684
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

event clicked;s_base_parametros lstr_parametros
Long ll_fila

ll_fila = dw_lista.GetRow()

If ll_fila > 0 THEN
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(ll_fila,'cs_ordenpd_pt')
ELSE
	MessageBox('Error','La fila seleccionada no es valida.',StopSign!)
	Return
END IF


lstr_parametros.hay_parametros = True

CloseWithreturn(Parent, lstr_parametros)
end event

type dw_lista from datawindow within w_buscar_op_liberacion_duo
integer x = 73
integer y = 72
integer width = 1403
integer height = 1480
integer taborder = 10
string title = "none"
string dataobject = "dgr_buscar_op_liberacion_duo"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_buscar_op_liberacion_duo
integer x = 46
integer width = 1472
integer height = 1616
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

