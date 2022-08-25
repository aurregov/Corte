HA$PBExportHeader$w_rutas_etapas.srw
forward
global type w_rutas_etapas from window
end type
type cb_cerrar from commandbutton within w_rutas_etapas
end type
type dw_lista from datawindow within w_rutas_etapas
end type
end forward

global type w_rutas_etapas from window
integer width = 2857
integer height = 1408
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cerrar cb_cerrar
dw_lista dw_lista
end type
global w_rutas_etapas w_rutas_etapas

event open;dw_lista.SetTransObject(sqlca)
dw_lista.retrieve()
dw_lista.SetFocus()
end event

on w_rutas_etapas.create
this.cb_cerrar=create cb_cerrar
this.dw_lista=create dw_lista
this.Control[]={this.cb_cerrar,&
this.dw_lista}
end on

on w_rutas_etapas.destroy
destroy(this.cb_cerrar)
destroy(this.dw_lista)
end on

type cb_cerrar from commandbutton within w_rutas_etapas
boolean visible = false
integer x = 421
integer y = 1280
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "none"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = 'NO'

CloseWithReturn(w_movimientos,lstr_parametros)

end event

type dw_lista from datawindow within w_rutas_etapas
integer x = 9
integer y = 24
integer width = 2816
integer height = 1212
integer taborder = 10
string title = "none"
string dataobject = "dtb_rutas_etapas"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 Then Return

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If
end event

event doubleclicked;s_base_parametros lstr_parametros


lstr_parametros.cadena[1] = 'SI'
lstr_parametros.cadena[2] = This.GetItemString(row,'de_transaccion')
lstr_parametros.entero[1] = This.GetItemNumber(row,'co_transaccion')
lstr_parametros.entero[2] = This.GetItemNumber(row,'co_ruta_etapa')

CloseWithReturn(Parent,lstr_parametros)

end event

