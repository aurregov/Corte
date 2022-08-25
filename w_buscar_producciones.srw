HA$PBExportHeader$w_buscar_producciones.srw
forward
global type w_buscar_producciones from window
end type
type cb_cancelar from commandbutton within w_buscar_producciones
end type
type cb_aceptar from commandbutton within w_buscar_producciones
end type
type dw_lista from datawindow within w_buscar_producciones
end type
type gb_1 from groupbox within w_buscar_producciones
end type
end forward

global type w_buscar_producciones from window
integer width = 1824
integer height = 1216
boolean titlebar = true
string title = "Producciones"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_buscar_producciones w_buscar_producciones

on w_buscar_producciones.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_buscar_producciones.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;Long ll_result
s_base_parametros lstr_parametros

dw_lista.SetTransObject(sqlca)

lstr_parametros=message.powerObjectparm

ll_result = dw_lista.retrieve(lstr_parametros.entero[1])

If ll_result <= 0 Then
	MessageBox('Error','No fue posible consultar la producci$$HEX1$$f300$$ENDHEX$$n para la O.C. '+String(lstr_parametros.entero[1]))
End if

Title = 'Producciones para la O.C. '+String(lstr_parametros.entero[1])
end event

type cb_cancelar from commandbutton within w_buscar_producciones
integer x = 974
integer y = 936
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
boolean cancel = true
end type

event clicked;s_base_parametros lst_parametros

lst_parametros.cadena[1] = 'NO'

CloseWithReturn(Parent, lst_parametros)
end event

type cb_aceptar from commandbutton within w_buscar_producciones
integer x = 334
integer y = 932
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
boolean default = true
end type

event clicked;Long ll_filas
s_base_parametros lst_parametros

ll_filas = dw_lista.GetRow()

IF ll_filas >= 1 THEN

	lst_parametros.entero[1] = dw_lista.GetItemNumber(ll_filas,'dt_agrupa_pdn_cs_pdn')
	lst_parametros.cadena[1] = 'SI'
	CloseWithReturn(Parent, lst_parametros)

END IF
end event

type dw_lista from datawindow within w_buscar_producciones
integer x = 50
integer y = 56
integer width = 1719
integer height = 736
integer taborder = 10
string title = "none"
string dataobject = "dtb_buscar_producciones"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 Then Return

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If
end event

event doubleclicked;If Row <= 0 Then Return
cb_aceptar.TriggerEvent(Clicked!)
end event

type gb_1 from groupbox within w_buscar_producciones
integer x = 37
integer width = 1751
integer height = 828
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

