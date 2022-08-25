HA$PBExportHeader$w_selec_op_indiv_x_agrupar.srw
forward
global type w_selec_op_indiv_x_agrupar from window
end type
type cb_cancelar from commandbutton within w_selec_op_indiv_x_agrupar
end type
type cb_aceptar from commandbutton within w_selec_op_indiv_x_agrupar
end type
type dw_lista from datawindow within w_selec_op_indiv_x_agrupar
end type
end forward

global type w_selec_op_indiv_x_agrupar from window
integer width = 1934
integer height = 1796
boolean titlebar = true
string title = "Seleccione OP base para liberar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
end type
global w_selec_op_indiv_x_agrupar w_selec_op_indiv_x_agrupar

type variables
Integer	il_fila_actual
end variables

on w_selec_op_indiv_x_agrupar.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista}
end on

on w_selec_op_indiv_x_agrupar.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
end on

event open;s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2],lstr_parametros.entero[3])
dw_lista.SetFocus()
end event

type cb_cancelar from commandbutton within w_selec_op_indiv_x_agrupar
integer x = 1545
integer y = 508
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

type cb_aceptar from commandbutton within w_selec_op_indiv_x_agrupar
integer x = 1545
integer y = 336
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
boolean default = true
end type

event clicked;Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_lista.GetRow()

IF (ll_fila= 0 OR IsNull(ll_fila)) AND dw_lista.RowCount() > 0 THEN
	ll_fila = 1
END IF


IF ll_fila > 0 THEN
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	
	lstr_parametros.hay_parametros = True
	CloseWithReturn ( Parent, lstr_parametros )
END IF



end event

type dw_lista from datawindow within w_selec_op_indiv_x_agrupar
integer x = 41
integer width = 1449
integer height = 1660
integer taborder = 10
string title = "none"
string dataobject = "dtb_selec_op_indiv_x_agrupar"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	IF dw_lista.IsSelected(row) THEN
		this.selectrow(row, False)
	ELSE
		this.selectrow(row, True)		
	END IF
END IF
end event

event doubleclicked;IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	this.selectrow(il_fila_actual,false)
	il_fila_actual = row
	cb_aceptar.triggerevent(clicked!)
ELSE
END IF

end event

