HA$PBExportHeader$w_mantenimiento_auditores_calidad.srw
forward
global type w_mantenimiento_auditores_calidad from window
end type
type cb_guardar from commandbutton within w_mantenimiento_auditores_calidad
end type
type cb_borrar_auditor from commandbutton within w_mantenimiento_auditores_calidad
end type
type cb_adicionar_auditor from commandbutton within w_mantenimiento_auditores_calidad
end type
type dw_print from datawindow within w_mantenimiento_auditores_calidad
end type
type cb_imprimir_adhesivo from commandbutton within w_mantenimiento_auditores_calidad
end type
type cb_cerrar from commandbutton within w_mantenimiento_auditores_calidad
end type
type cb_cambiar_codigo from commandbutton within w_mantenimiento_auditores_calidad
end type
type dw_lista from datawindow within w_mantenimiento_auditores_calidad
end type
type gb_1 from groupbox within w_mantenimiento_auditores_calidad
end type
end forward

global type w_mantenimiento_auditores_calidad from window
integer width = 2464
integer height = 1920
boolean titlebar = true
string title = "Auditores de Calidad en Corte "
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
cb_guardar cb_guardar
cb_borrar_auditor cb_borrar_auditor
cb_adicionar_auditor cb_adicionar_auditor
dw_print dw_print
cb_imprimir_adhesivo cb_imprimir_adhesivo
cb_cerrar cb_cerrar
cb_cambiar_codigo cb_cambiar_codigo
dw_lista dw_lista
gb_1 gb_1
end type
global w_mantenimiento_auditores_calidad w_mantenimiento_auditores_calidad

on w_mantenimiento_auditores_calidad.create
this.cb_guardar=create cb_guardar
this.cb_borrar_auditor=create cb_borrar_auditor
this.cb_adicionar_auditor=create cb_adicionar_auditor
this.dw_print=create dw_print
this.cb_imprimir_adhesivo=create cb_imprimir_adhesivo
this.cb_cerrar=create cb_cerrar
this.cb_cambiar_codigo=create cb_cambiar_codigo
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_guardar,&
this.cb_borrar_auditor,&
this.cb_adicionar_auditor,&
this.dw_print,&
this.cb_imprimir_adhesivo,&
this.cb_cerrar,&
this.cb_cambiar_codigo,&
this.dw_lista,&
this.gb_1}
end on

on w_mantenimiento_auditores_calidad.destroy
destroy(this.cb_guardar)
destroy(this.cb_borrar_auditor)
destroy(this.cb_adicionar_auditor)
destroy(this.dw_print)
destroy(this.cb_imprimir_adhesivo)
destroy(this.cb_cerrar)
destroy(this.cb_cambiar_codigo)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1

dw_print.SetTransObject(sqlca)
dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(gstr_info_usuario.co_planta_pro)
dw_lista.SetFocus()
end event

type cb_guardar from commandbutton within w_mantenimiento_auditores_calidad
integer x = 1847
integer y = 64
integer width = 434
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Guardar"
end type

event clicked;If dw_lista.AcceptText() = -1 Then
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar los datos en pantalla.')
	Return
ElseIf dw_lista.Update() = -1 Then
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de grabar la informaci$$HEX1$$f300$$ENDHEX$$n en pantalla.')
	Return
Else
	Commit;
	MessageBox('Exito','La informaci$$HEX1$$f300$$ENDHEX$$n fue grabada exitosamente.')
End if
end event

type cb_borrar_auditor from commandbutton within w_mantenimiento_auditores_calidad
boolean visible = false
integer x = 1842
integer y = 1092
integer width = 434
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Borrar Auditor"
end type

event clicked;//evento para eliminar el registro de un auditor
end event

type cb_adicionar_auditor from commandbutton within w_mantenimiento_auditores_calidad
integer x = 1847
integer y = 416
integer width = 434
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Nuevo Auditor"
end type

event clicked;Long ll_fila
DateTime ldt_fecha

ll_fila = dw_lista.InsertRow(0)

If ll_fila > 0 Then
	ldt_fecha = f_fecha_servidor()
	
	dw_lista.SetItem(ll_fila,'fe_creacion',ldt_fecha)
	dw_lista.SetItem(ll_fila,'fe_actualizacion',ldt_fecha)
	dw_lista.SetItem(ll_fila,'usuario',gstr_info_usuario.codigo_usuario)
	dw_lista.SetItem(ll_fila,'instancia',gstr_info_usuario.instancia)
	dw_lista.SetItem(ll_fila,'estado',1)
	dw_lista.SetItem(ll_fila,'co_fabrica_pro',gstr_info_usuario.co_planta_pro)
	
	dw_lista.ScrollToRow(ll_fila)
	
Else
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar la fila.')
	Return
End if


end event

type dw_print from datawindow within w_mantenimiento_auditores_calidad
boolean visible = false
integer x = 1637
integer y = 1480
integer width = 357
integer height = 252
integer taborder = 40
string dataobject = "dtb_reporte_user_auditor"
boolean border = false
boolean livescroll = true
end type

type cb_imprimir_adhesivo from commandbutton within w_mantenimiento_auditores_calidad
integer x = 1847
integer y = 592
integer width = 434
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir"
end type

event clicked;//evento para permitir la impresion de adhesivos de los auditores que el usuario se$$HEX1$$f100$$ENDHEX$$ale en la
//ventana.
long CurRow, ll_auditor[]
Long li_posicion, li_result
boolean result

li_posicion = 1

FOR CurRow = 1 TO dw_lista.RowCount()
	result = dw_lista.IsSelected(CurRow)
	IF result THEN
		//se trata de un registro selecionado para impresion
		ll_auditor[li_posicion] = dw_lista.GetItemNumber(CurRow,'auditor')
		li_posicion += 1
	END IF
NEXT

IF li_posicion > 1 THEN
	If dw_print.Retrieve(ll_auditor) > 0 Then
		li_result = MessageBox('Pregunta','Realmente desea imprimir el adhesivo.', Exclamation!, OKCancel!, 2)
		IF li_result = 1 THEN
			PrintSetup()
			dw_print.Print()
		Else
			Return
		END IF
	Else
		MessageBox('Error','No fue posible establecer el auditor.')
		Return
	End if
ELSE
	MessageBox('Advertencia','No fue seleccionado ningun auditor para imprimir.')
	Return
END IF
end event

type cb_cerrar from commandbutton within w_mantenimiento_auditores_calidad
integer x = 1847
integer y = 768
integer width = 434
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;Close(Parent)
end event

type cb_cambiar_codigo from commandbutton within w_mantenimiento_auditores_calidad
integer x = 1847
integer y = 240
integer width = 434
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cambiar C$$HEX1$$f300$$ENDHEX$$digo"
end type

event clicked;//evento para permitir cambiar el codigo del auditor de corte
Long ll_fila, ll_auditor_new, ll_auditor_old, ll_count
Long li_marca
String ls_auditor, ls_error

dw_lista.AcceptText()

For ll_fila = 1 To dw_Lista.RowCount() 
	ll_auditor_old = dw_lista.GetItemNumber(ll_fila,'auditor')
	ll_auditor_new = dw_lista.GetItemNumber(ll_fila,'auditor_nuevo')
	
	If ll_auditor_new > 0 Then
		li_marca = ll_fila
	   //se valida que el c$$HEX1$$f300$$ENDHEX$$digo del auditor ya no exista
	   SELECT count(*)
		  INTO :ll_count
		  FROM m_user_auditor
		 WHERE auditor = :ll_auditor_new;
		 
		IF sqlca.SqlCode = -1 Then
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el nuevo c$$HEX1$$f300$$ENDHEX$$digo, Error: '+Sqlca.SqlErrText)	
			Return
		End if
		 
		If ll_count > 0 Then //el c$$HEX1$$f300$$ENDHEX$$digo a crearse ya existe para otro auditor
			 ls_auditor = dw_lista.GetItemString(ll_fila,'nombre')
			 MessageBox('Error','El nuevo c$$HEX1$$f300$$ENDHEX$$digo para el auditor '+Trim(ls_auditor)+' ya fue asignado a otro auditor.')	
			 Return 2
		End if
		//se modifica en la tabla maestra de auditores
		UPDATE m_user_auditor
			SET auditor = :ll_auditor_new,
			    usuario = :gstr_info_usuario.codigo_usuario,
				 instancia = :gstr_info_usuario.instancia	
		 WHERE auditor = :ll_auditor_old;
		
		IF sqlca.SqlCode = -1 Then
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el nuevo c$$HEX1$$f300$$ENDHEX$$digo, Error: '+ls_error)	
			Return
		End if
		//se cambia en la tabla de movimientos de auditores
		UPDATE mv_loteo_auditor
			SET auditor = :ll_auditor_new,
			    instancia = :gstr_info_usuario.instancia	
		 WHERE auditor = :ll_auditor_old;
		
		IF sqlca.SqlCode = -1 Then
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el nuevo c$$HEX1$$f300$$ENDHEX$$digo, Error: '+ls_error)	
			Return
		End if
		//se cambia en la tabla de auditor y po verificadas.
		UPDATE m_auditor_po
			SET auditor = :ll_auditor_new,
			    usuario = :gstr_info_usuario.codigo_usuario,
				 instancia = :gstr_info_usuario.instancia	
		 WHERE auditor = :ll_auditor_old;
		 
		IF sqlca.SqlCode = -1 Then
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el nuevo c$$HEX1$$f300$$ENDHEX$$digo, Error: '+ls_error)	
			Return
		End if 
	End if
Next

Commit;
If li_marca > 1 Then
	MessageBox('Exito','La informaci$$HEX1$$f300$$ENDHEX$$n fue cambiada exitosamente.')
	dw_lista.Retrieve()
	dw_lista.SetFocus()
	dw_lista.ScrollToRow(li_marca)
	
Else
	MessageBox('Advertencia','No fue posible modificar ningun c$$HEX1$$f300$$ENDHEX$$digo.')
End if

end event

type dw_lista from datawindow within w_mantenimiento_auditores_calidad
integer x = 78
integer y = 56
integer width = 1714
integer height = 1636
integer taborder = 10
string title = "none"
string dataobject = "dtb_user_auditor_cambio"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;//long ll_fila
//boolean result
//
This.SelectRow(0, FALSE)
//This.AcceptText()

//ll_fila = This.GetRow()
//
//result = This.IsSelected(CurRow)
//
//IF result THEN
//   This.SelectRow(CurRow, FALSE)
//ELSE
//   This.SelectRow(CurRow, TRUE)
//END IF
//
//

This.SelectRow(Row, TRUE)



end event

type gb_1 from groupbox within w_mantenimiento_auditores_calidad
integer x = 27
integer y = 16
integer width = 1774
integer height = 1748
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

