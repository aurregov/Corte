HA$PBExportHeader$w_conceptos_texografo_15.srw
forward
global type w_conceptos_texografo_15 from window
end type
type cb_cancelar from commandbutton within w_conceptos_texografo_15
end type
type cb_aceptar from commandbutton within w_conceptos_texografo_15
end type
type dw_conceptos from datawindow within w_conceptos_texografo_15
end type
type dw_rollos from datawindow within w_conceptos_texografo_15
end type
type gb_1 from groupbox within w_conceptos_texografo_15
end type
end forward

global type w_conceptos_texografo_15 from window
integer width = 1061
integer height = 1384
boolean titlebar = true
string title = "Conceptos Centro 15"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_conceptos dw_conceptos
dw_rollos dw_rollos
gb_1 gb_1
end type
global w_conceptos_texografo_15 w_conceptos_texografo_15

on w_conceptos_texografo_15.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_conceptos=create dw_conceptos
this.dw_rollos=create dw_rollos
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_conceptos,&
this.dw_rollos,&
this.gb_1}
end on

on w_conceptos_texografo_15.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_conceptos)
destroy(this.dw_rollos)
destroy(this.gb_1)
end on

event open;Long ll_liberacion
s_base_parametros lstr_parametros

dw_rollos.SetTransObject(sqlca)
dw_conceptos.SetTransObject(sqlca)


lstr_parametros = Message.PowerObjectParm	

ll_liberacion = lstr_parametros.entero[1]

dw_rollos.Retrieve(ll_liberacion)
dw_conceptos.Retrieve()
dw_conceptos.SetFocus()


end event

type cb_cancelar from commandbutton within w_conceptos_texografo_15
integer x = 558
integer y = 1132
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

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_conceptos_texografo_15
integer x = 91
integer y = 1128
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

event clicked;Long ll_fila, ll_cs_rollo, ll_fila1
Long li_concepto
String ls_error


ll_fila = dw_conceptos.GetRow()

If ll_fila > 0 Then
	li_concepto = dw_conceptos.GetItemNumber(ll_fila,'co_cpto_bodega')
	For ll_fila1 = 1 To dw_rollos.RowCount()
		ll_cs_rollo = dw_rollos.GetItemNumber(ll_fila1,'cs_rollo')
		UPDATE m_rollo
		   SET co_planeador = :li_concepto
		 WHERE cs_rollo = :ll_cs_rollo AND
		 		 co_centro = 15;
		 
		IF sqlca.sqlcode = -1 Then
			ls_error = sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el concepto en terminada, ERROR: '+ls_error)
			Return
		End if
		
	Next
	MessageBox('Exito','El concepto fue actualizado en terminada.')
Else
	MessageBox('Advertencia','Debe seleccionar un concepto')
	Return
	
End if

Close(Parent)

end event

type dw_conceptos from datawindow within w_conceptos_texografo_15
integer x = 46
integer y = 860
integer width = 942
integer height = 248
integer taborder = 10
string title = "none"
string dataobject = "dgr_conceptos_texografo_15"
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type dw_rollos from datawindow within w_conceptos_texografo_15
integer x = 165
integer y = 48
integer width = 649
integer height = 756
string title = "none"
string dataobject = "dgr_rollos_conceptos_texografo_15"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_conceptos_texografo_15
integer x = 142
integer width = 722
integer height = 836
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

