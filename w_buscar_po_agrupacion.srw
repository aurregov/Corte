HA$PBExportHeader$w_buscar_po_agrupacion.srw
forward
global type w_buscar_po_agrupacion from window
end type
type cb_aceptar from commandbutton within w_buscar_po_agrupacion
end type
type dw_1 from datawindow within w_buscar_po_agrupacion
end type
type gb_1 from groupbox within w_buscar_po_agrupacion
end type
end forward

global type w_buscar_po_agrupacion from window
integer width = 3214
integer height = 1400
boolean titlebar = true
string title = "Buscar P.O. Agrupada"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_aceptar cb_aceptar
dw_1 dw_1
gb_1 gb_1
end type
global w_buscar_po_agrupacion w_buscar_po_agrupacion

on w_buscar_po_agrupacion.create
this.cb_aceptar=create cb_aceptar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_aceptar,&
this.dw_1,&
this.gb_1}
end on

on w_buscar_po_agrupacion.destroy
destroy(this.cb_aceptar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;/*
	FACL - 2020/07/22 - SA60509 - Se crea ventana de seleccion de PO Agrupada
		Se busca la informacion de agrupacion y si la PO se separa en el loteo se muestra
*/

String ls_find
This.Center = True

s_base_parametros lstr_parametros, lstr_parametros_env

dw_1.SetTransObject(sqlca)

lstr_parametros = message.PowerObjectParm	

dw_1.Retrieve(lstr_parametros.entero[1] )


If dw_1.RowCount() = 0 Then
	lstr_parametros_env.hay_parametros = True
	lstr_parametros_env.cadena[1] = ''
	lstr_parametros_env.cadena[2] = ''
	lstr_parametros_env.cadena[3] = ''
	lstr_parametros_env.entero[1] = 0
Else
	lstr_parametros_env.hay_parametros = False
//	ls_find = 'po = "' + dw_1.GetItemString(1,'po') + '"'
//	If dw_1.Find( ls_find, 1, dw_1.RowCount() ) = 0 Then
//		lstr_parametros_env.hay_parametros = True
//		lstr_parametros_env.cadena[1] = dw_1.GetItemString(1,'po')
//	Else
//		lstr_parametros_env.hay_parametros = False
//	End If
End if

If lstr_parametros_env.hay_parametros Then
	CloseWithReturn (This,lstr_parametros_env)
End If

	

end event

type cb_aceptar from commandbutton within w_buscar_po_agrupacion
integer x = 1307
integer y = 1164
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
string text = "Aceptar"
end type

event clicked;s_base_parametros lstr_parametros
Long ll_fila

lstr_parametros.hay_parametros = True

ll_fila = dw_1.GetRow()

If ll_fila > 0 Then
	If dw_1.GetItemNumber( ll_fila, 'tipo_agrupacion' ) <= 2 Then
		lstr_parametros.cadena[1] = dw_1.GetItemString(ll_fila,'po')
		lstr_parametros.entero[1] = dw_1.GetItemNumber(ll_fila,'pedido')
	Else
		lstr_parametros.cadena[1] = dw_1.GetItemString(ll_fila,'po_agrupada')
		lstr_parametros.entero[1] = dw_1.GetItemNumber(ll_fila,'pedido_agrupa')
	End If
	lstr_parametros.cadena[2] = dw_1.GetItemString(ll_fila,'po_agrupada')
	lstr_parametros.cadena[3] = dw_1.GetItemString(ll_fila,'po_oc')
Else
	MessageBox('Advertencia','No ha seleccionado ninguna P.O.')
	Return 
End if
	

CloseWithReturn (Parent,lstr_parametros)
end event

type dw_1 from datawindow within w_buscar_po_agrupacion
integer x = 82
integer y = 108
integer width = 3026
integer height = 964
integer taborder = 10
string title = "none"
string dataobject = "d_gr_buscar_po_agrupada"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;

If row > 0 Then
	If This.GetItemNumber( row, 'tipo_agrupacion' ) > 2 Then
		If This.Find( 'tipo_agrupacion = 2 And ca_x_lotear > 0', 1, This.RowCount() ) > 0 Then
			Post MessageBox( 'Atencion', 'Primero debe lotear los pedidos que se separan en el loteo (tipo_agrupacion = 2)' )
			Return 1
		End If
	End If
End If


This.SelectRow( 0, False )
This.SelectRow( Row, True )
This.SetRow( Row )



end event

type gb_1 from groupbox within w_buscar_po_agrupacion
integer x = 37
integer y = 36
integer width = 3118
integer height = 1076
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

