HA$PBExportHeader$w_seleccionar_agrupacion_liberar.srw
forward
global type w_seleccionar_agrupacion_liberar from window
end type
type cb_1 from commandbutton within w_seleccionar_agrupacion_liberar
end type
type cb_aceptar from commandbutton within w_seleccionar_agrupacion_liberar
end type
type dw_lista from datawindow within w_seleccionar_agrupacion_liberar
end type
end forward

global type w_seleccionar_agrupacion_liberar from window
integer width = 1321
integer height = 1156
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
cb_aceptar cb_aceptar
dw_lista dw_lista
end type
global w_seleccionar_agrupacion_liberar w_seleccionar_agrupacion_liberar

type variables
Integer	il_fila_actual
end variables

event open;s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2],lstr_parametros.cadena[1] )
dw_lista.SetFocus()
end event

on w_seleccionar_agrupacion_liberar.create
this.cb_1=create cb_1
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.Control[]={this.cb_1,&
this.cb_aceptar,&
this.dw_lista}
end on

on w_seleccionar_agrupacion_liberar.destroy
destroy(this.cb_1)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
end on

type cb_1 from commandbutton within w_seleccionar_agrupacion_liberar
integer x = 590
integer y = 824
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

type cb_aceptar from commandbutton within w_seleccionar_agrupacion_liberar
integer x = 146
integer y = 824
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
IF (ll_fila = 0 OR IsNull(ll_fila)) AND dw_lista.RowCount() = 1 THEN
	ll_fila = 1
END IF

IF ll_fila > 0 THEN
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(ll_fila,'cs_agrupa_lib')
	
	lstr_parametros.hay_parametros = True
	CloseWithReturn ( Parent, lstr_parametros )
END IF



end event

type dw_lista from datawindow within w_seleccionar_agrupacion_liberar
integer x = 37
integer y = 24
integer width = 1211
integer height = 692
integer taborder = 10
boolean titlebar = true
string title = "Seleccione Agrupacion a Liberar"
string dataobject = "dtb_seleccionar_priori_liberacion_agru"
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

