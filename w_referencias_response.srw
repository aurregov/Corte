HA$PBExportHeader$w_referencias_response.srw
forward
global type w_referencias_response from window
end type
type cb_cancelar from commandbutton within w_referencias_response
end type
type cb_aceptar from commandbutton within w_referencias_response
end type
type dw_1 from datawindow within w_referencias_response
end type
type gb_1 from groupbox within w_referencias_response
end type
end forward

global type w_referencias_response from window
integer width = 2363
integer height = 1480
boolean titlebar = true
string title = "Referencias"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_1 dw_1
gb_1 gb_1
end type
global w_referencias_response w_referencias_response

on w_referencias_response.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_1,&
this.gb_1}
end on

on w_referencias_response.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;This.center = True
dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_1.SetFocus()
end event

type cb_cancelar from commandbutton within w_referencias_response
integer x = 1248
integer y = 1144
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_referencias_response
integer x = 713
integer y = 1144
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_1.GetRow()

If ll_fila > 0 Then
	lstr_parametros.hay_parametros = True
   lstr_parametros.entero[1] = dw_1.GetItemNumber(ll_fila,'co_referencia')
	lstr_parametros.cadena[1] = dw_1.GetItemString(ll_fila,'de_referencia')
Else
	lstr_parametros.hay_parametros = False
End if

CloseWithReturn ( Parent, lstr_parametros )

end event

type dw_1 from datawindow within w_referencias_response
integer x = 91
integer y = 96
integer width = 1993
integer height = 908
integer taborder = 10
string title = "none"
string dataobject = "dddw_h_preref"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.SelectRow(0,FALSE)
dw_1.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_referencias_response
integer x = 55
integer y = 52
integer width = 2085
integer height = 1000
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

