HA$PBExportHeader$w_unid_mas_oc.srw
forward
global type w_unid_mas_oc from window
end type
type dw_lista from datawindow within w_unid_mas_oc
end type
type gb_1 from groupbox within w_unid_mas_oc
end type
end forward

global type w_unid_mas_oc from window
integer width = 2107
integer height = 2236
boolean titlebar = true
string title = "Permiso de loteo superior"
string menuname = "m_mantenimiento_simple"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_grabar ( )
event ue_insertar_maestro ( )
event ue_borrar_maestro ( )
dw_lista dw_lista
gb_1 gb_1
end type
global w_unid_mas_oc w_unid_mas_oc

type variables
Long il_fila_actual
end variables

event ue_grabar();//evento para grabar las ordenes de corte que seran suceptibles a aumentar las unidades del loteo con respecto a las liquidadas.
//jcrm
//julio 31 de 2008

IF dw_lista.AcceptText() = -1 THEN
	Rollback;
	MessageBox('Error','Ocurrio un error al verificar la informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	Return
ELSE
	IF dw_lista.Update() = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al grabar la informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
		Return
	ELSE
		Commit;
		MessageBox('Exito','La informaci$$HEX1$$f300$$ENDHEX$$n fue grabada exitosamente.',Exclamation!)		
	END IF
END IF
end event

event ue_insertar_maestro();//evento para insertar una orden de corte 

il_fila_actual = dw_lista.InsertRow(0)
dw_lista.ScrollToRow(il_fila_actual)

dw_lista.SetItem(il_fila_actual,'fe_creacion',Today())
dw_lista.SetItem(il_fila_actual,'fe_actualizacion',Today())
dw_lista.SetItem(il_fila_actual,'usuario',gstr_info_usuario.codigo_usuario)
dw_lista.SetItem(il_fila_actual,'instancia',gstr_info_usuario.instancia)
end event

event ue_borrar_maestro();//evento para borrar una orden de corte
Long ll_ordencorte
Long li_result


ll_ordencorte = dw_lista.GetItemNumber(il_fila_actual,'cs_orden_corte')

li_result = MessageBox('Advertencia','Esta seguro de borrar la Orden de Corte: '+String(ll_ordencorte), Exclamation!, OKCancel!, 2)

IF li_result = 1 THEN
	dw_lista.DeleteRow(il_fila_actual)
	IF dw_lista.Update() = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al grabar la informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
		Return
	ELSE
		Commit;
		//MessageBox('Exito','La informaci$$HEX1$$f300$$ENDHEX$$n fue grabada exitosamente.',Exclamation!)		
	END IF
END IF





end event

on w_unid_mas_oc.create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.gb_1}
end on

on w_unid_mas_oc.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1
dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve()
dw_lista.SetFocus()
end event

type dw_lista from datawindow within w_unid_mas_oc
integer x = 64
integer y = 60
integer width = 1920
integer height = 1888
integer taborder = 10
string title = "none"
string dataobject = "dgr_unid_mas_oc"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;il_fila_actual = Row
end event

event itemchanged;//se valida que la orden de corte ingresada exista y este en estado valido
//jcrm
//julio 31 de 2008
Long ll_orden_corte
Long li_result
String ls_mensaje
n_cst_orden_corte luo_corte

choose case dwo.name
	case 'cs_orden_corte'
		ll_orden_corte = Long(data)
		li_result = luo_corte.of_validar_oc(ll_orden_corte,ls_mensaje)
		IF li_result = 0 THEN
			MessageBox('Error','No existe orden de corte con ese numero, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
			Return 2
		ELSEIF li_result = -1 THEN
			MessageBox('Error','Ocurrio un error al momento de verificar la validez de la orden de corte, ERROR: '+ls_mensaje,StopSign!)
			Return 2
		END IF
end choose

end event

type gb_1 from groupbox within w_unid_mas_oc
integer x = 41
integer y = 12
integer width = 1979
integer height = 1992
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

