HA$PBExportHeader$w_buscar_recipientes.srw
forward
global type w_buscar_recipientes from window
end type
type dw_1 from datawindow within w_buscar_recipientes
end type
type cb_cancelar from commandbutton within w_buscar_recipientes
end type
type cb_aceptar from commandbutton within w_buscar_recipientes
end type
type gb_1 from groupbox within w_buscar_recipientes
end type
end forward

global type w_buscar_recipientes from window
integer width = 992
integer height = 1384
boolean titlebar = true
string title = "Recipientes"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_1 dw_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_buscar_recipientes w_buscar_recipientes

on w_buscar_recipientes.create
this.dw_1=create dw_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.dw_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_buscar_recipientes.destroy
destroy(this.dw_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;This.Center = True

s_base_parametros lstr_parametros

dw_1.SetTransObject(sqlca)

lstr_parametros = message.PowerObjectParm	

dw_1.Retrieve(lstr_parametros.entero[1],lstr_parametros.cadena[1])

end event

type dw_1 from datawindow within w_buscar_recipientes
integer x = 133
integer y = 88
integer width = 750
integer height = 988
integer taborder = 10
string title = "none"
string dataobject = "dgr_bongos_usados_oc_po"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cb_cancelar from commandbutton within w_buscar_recipientes
integer x = 521
integer y = 1124
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

CloseWithReturn (Parent,lstr_parametros)
end event

type cb_aceptar from commandbutton within w_buscar_recipientes
integer x = 110
integer y = 1124
integer width = 343
integer height = 100
integer taborder = 10
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

lstr_parametros.hay_parametros = True

ll_fila = dw_1.GetRow()

If ll_fila > 0 Then
	lstr_parametros.cadena[1] = Trim(dw_1.GetItemString(ll_fila,'pallet_id'))
Else
	MessageBox('Advertencia','No ha seleccionado ningun recipiente')
	Return 
End if
	

CloseWithReturn (Parent,lstr_parametros)
end event

type gb_1 from groupbox within w_buscar_recipientes
integer x = 73
integer y = 28
integer width = 859
integer height = 1064
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Recipientes "
end type

