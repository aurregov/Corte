HA$PBExportHeader$w_lanzamientos_response.srw
forward
global type w_lanzamientos_response from window
end type
type cb_cancelar from commandbutton within w_lanzamientos_response
end type
type cb_aceptar from commandbutton within w_lanzamientos_response
end type
type dw_1 from datawindow within w_lanzamientos_response
end type
type gb_1 from groupbox within w_lanzamientos_response
end type
end forward

global type w_lanzamientos_response from window
integer width = 901
integer height = 1480
boolean titlebar = true
string title = "Lineas"
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
global w_lanzamientos_response w_lanzamientos_response

on w_lanzamientos_response.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_1,&
this.gb_1}
end on

on w_lanzamientos_response.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;This.Center = True
s_base_parametros lstr_parametros

dw_1.SetTransObject(sqlca)

lstr_parametros = message.PowerObjectParm	

dw_1.Retrieve(lstr_parametros.entero[1], lstr_parametros.entero[2],lstr_parametros.entero[3])
dw_1.SetFocus()
end event

type cb_cancelar from commandbutton within w_lanzamientos_response
integer x = 457
integer y = 1148
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

type cb_aceptar from commandbutton within w_lanzamientos_response
integer x = 73
integer y = 1148
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
   lstr_parametros.entero[1] = dw_1.GetItemNumber(ll_fila,'co_lanzamiento')
	
Else
	lstr_parametros.hay_parametros = False
End if

CloseWithReturn ( Parent, lstr_parametros )

end event

type dw_1 from datawindow within w_lanzamientos_response
integer x = 101
integer y = 96
integer width = 654
integer height = 908
integer taborder = 10
string title = "none"
string dataobject = "dddw_m_lanzamientos"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.SelectRow(0,FALSE)
dw_1.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_lanzamientos_response
integer x = 64
integer y = 52
integer width = 763
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

