HA$PBExportHeader$w_conceptos_planeacion_centro_15.srw
forward
global type w_conceptos_planeacion_centro_15 from window
end type
type sle_lote from singlelineedit within w_conceptos_planeacion_centro_15
end type
type cb_cancelar from commandbutton within w_conceptos_planeacion_centro_15
end type
type cb_aceptar from commandbutton within w_conceptos_planeacion_centro_15
end type
type dw_conceptos from datawindow within w_conceptos_planeacion_centro_15
end type
type gb_1 from groupbox within w_conceptos_planeacion_centro_15
end type
end forward

global type w_conceptos_planeacion_centro_15 from window
integer width = 1111
integer height = 960
boolean titlebar = true
string title = "Concepto Centro 15"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_lote sle_lote
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_conceptos dw_conceptos
gb_1 gb_1
end type
global w_conceptos_planeacion_centro_15 w_conceptos_planeacion_centro_15

type variables
Long il_op, il_lote

end variables

on w_conceptos_planeacion_centro_15.create
this.sle_lote=create sle_lote
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_conceptos=create dw_conceptos
this.gb_1=create gb_1
this.Control[]={this.sle_lote,&
this.cb_cancelar,&
this.cb_aceptar,&
this.dw_conceptos,&
this.gb_1}
end on

on w_conceptos_planeacion_centro_15.destroy
destroy(this.sle_lote)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_conceptos)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

dw_conceptos.SetTransObject(sqlca)
dw_conceptos.Retrieve()
sle_lote.SetFocus()


lstr_parametros = Message.PowerObjectParm	

il_op = lstr_parametros.entero[1]







end event

type sle_lote from singlelineedit within w_conceptos_planeacion_centro_15
integer x = 338
integer y = 96
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_conceptos_planeacion_centro_15
integer x = 567
integer y = 640
integer width = 343
integer height = 100
integer taborder = 40
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

type cb_aceptar from commandbutton within w_conceptos_planeacion_centro_15
integer x = 142
integer y = 640
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Long li_concepto
Long ll_fila
String ls_error
DateTime		ldt_fecha

ldt_fecha = f_fecha_servidor()

ll_fila = dw_conceptos.GetRow()

li_concepto = dw_conceptos.GetItemNumber(ll_fila,'co_cpto_bodega')
il_lote = Long(sle_lote.Text)

If IsNull(li_concepto) or li_concepto = 0 Then
	MessageBox('Advertencia','Debe seleccionar un concepto.')
	Return
End if

If IsNull(il_lote) or il_lote = 0 Then
	MessageBox('Advertencia','Debe ingresar el lote del rollo')
	Return
End if

If IsNull(il_op) or il_op = 0 Then
	MessageBox('Advertencia','El numero de O.P. no es valido.')
	Return
End if

If ll_fila > 0 Then
	UPDATE m_rollo
	   SET (co_planeador, fe_act_cpto) = (:li_concepto, :ldt_fecha)
	 WHERE cs_orden_pr_act 	= :il_op AND
	       lote					= :il_lote AND
			 co_centro 			= 15 and
			 co_planeador 		<> :li_concepto;
			 
	IF sqlca.sqlcode = -1 Then
		ls_error = sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el concepto en terminada, ERROR: '+ls_error)
		Return
	End if	
	
	COMMIT;
	MessageBox('Exito','El concepto fue actualizado en terminada.')
	
Else
	MessageBox('Advertencia','Debe seleccionar un concepto.')
	Return
End if

Close(Parent)

end event

type dw_conceptos from datawindow within w_conceptos_planeacion_centro_15
integer x = 59
integer y = 296
integer width = 1001
integer height = 284
integer taborder = 20
string title = "none"
string dataobject = "dgr_conceptos_planeacion_centro15"
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_conceptos_planeacion_centro_15
integer x = 293
integer y = 32
integer width = 448
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lote "
end type

