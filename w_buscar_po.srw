HA$PBExportHeader$w_buscar_po.srw
forward
global type w_buscar_po from window
end type
type cb_cancelar from commandbutton within w_buscar_po
end type
type cb_aceptar from commandbutton within w_buscar_po
end type
type dw_1 from datawindow within w_buscar_po
end type
type gb_1 from groupbox within w_buscar_po
end type
end forward

global type w_buscar_po from window
integer width = 878
integer height = 1400
boolean titlebar = true
string title = "Buscar P.O."
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_1 dw_1
gb_1 gb_1
end type
global w_buscar_po w_buscar_po

on w_buscar_po.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_1,&
this.gb_1}
end on

on w_buscar_po.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;This.Center = True

s_base_parametros lstr_parametros

dw_1.SetTransObject(sqlca)

lstr_parametros = message.PowerObjectParm	

dw_1.Retrieve(lstr_parametros.entero[1])

end event

type cb_cancelar from commandbutton within w_buscar_po
integer x = 453
integer y = 1140
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

type cb_aceptar from commandbutton within w_buscar_po
integer x = 73
integer y = 1140
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

lstr_parametros.hay_parametros = True

ll_fila = dw_1.GetRow()

If ll_fila > 0 Then
	lstr_parametros.cadena[1] = dw_1.GetItemString(ll_fila,'po')
Else
	MessageBox('Advertencia','No ha seleccionado ninguna P.O.')
	Return 
End if
	

CloseWithReturn (Parent,lstr_parametros)
end event

type dw_1 from datawindow within w_buscar_po
integer x = 151
integer y = 140
integer width = 581
integer height = 844
integer taborder = 10
string title = "none"
string dataobject = "dgr_buscar_po"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_buscar_po
integer x = 73
integer y = 36
integer width = 718
integer height = 1008
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "P.O. "
end type

