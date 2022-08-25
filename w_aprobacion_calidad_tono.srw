HA$PBExportHeader$w_aprobacion_calidad_tono.srw
forward
global type w_aprobacion_calidad_tono from window
end type
type dw_lista from datawindow within w_aprobacion_calidad_tono
end type
type gb_1 from groupbox within w_aprobacion_calidad_tono
end type
end forward

global type w_aprobacion_calidad_tono from window
integer width = 4549
integer height = 2176
boolean titlebar = true
string title = "Aprobaci$$HEX1$$f300$$ENDHEX$$n Tonos Calidad"
string menuname = "m_mantenimiento_simple"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_grabar ( )
dw_lista dw_lista
gb_1 gb_1
end type
global w_aprobacion_calidad_tono w_aprobacion_calidad_tono

type variables
s_base_parametros  istr_param
cst_adm_conexion icst_lectura
end variables

event ue_grabar();//evento para grabar la aprobacion o rechazo de tono por parte de calidad
Long li_fila, li_marca
Long ll_rollo
String ls_tono_calidad, ls_mensaje
n_cts_liberacion_x_proyeccion luo_liberacion

dw_lista.Accepttext()

IF dw_lista.RowCount() <= 0 THEN
	MessageBox('Advertencia','No existen datos para grabar', Exclamation!)
	Return
END IF

//se recorre la ventana y se verifican los datos
FOR li_fila = 1 TO dw_lista.RowCount()
	li_marca = dw_lista.GetItemNumber(li_fila,'sw_marca')
	ls_tono_calidad = dw_lista.GetItemString(li_fila,'tono_aprobado')
	ll_rollo = dw_lista.GetItemNumber(li_fila,'cs_rollo')
	IF li_marca = 0  THEN
		CONTINUE //el rollo no se le realizo ningun cambio
	ELSEIF li_marca = 1 THEN
		//se verifica que se halla colocado el tono con el cual se aprueba
		IF IsNull(ls_tono_calidad) OR ls_tono_calidad = '' THEN
			MessageBox('Advertencia','El rollo: '+String(ll_rollo)+' debe tener el tono de aprobaci$$HEX1$$f300$$ENDHEX$$n de calidad.',StopSign!)
			Rollback;
			Return
		ELSE
			//el rollo fue aprobado y se le coloco tono se debe modificar en m_rollo el tono y el estado
			IF luo_liberacion.of_updateRollo(ll_rollo,ls_tono_calidad,2,ls_mensaje) = -1 THEN
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de modificar la informaci$$HEX1$$f300$$ENDHEX$$n del rollo, ERROR: '+ls_mensaje)
				Return
			ELSE
				dw_lista.SetItem(li_fila,'usuario_actualiza',gstr_info_usuario.codigo_usuario)
			END IF
		END IF
	ELSEIF li_marca = 2 THEN
		//el rollo fue rechazado continua con el mismo tono pero se debe liberar para poder ser utilizado
		//en otra liberacion
		IF luo_liberacion.of_updateRollo(ll_rollo,'',2,ls_mensaje) = -1 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de modificar la informaci$$HEX1$$f300$$ENDHEX$$n del rollo, ERROR: '+ls_mensaje)
			Return
		ELSE
			dw_lista.SetItem(li_fila,'usuario_actualiza',gstr_info_usuario.codigo_usuario)
		END IF
	END IF
NEXT

commit;
//en este punto se debe grabar la informacion en la tabla de rollos calidad
IF dw_lista.Update(True,true) = -1 THEN
	Rollback;
	MessageBox('Error','Sucedio un error al momento de actualizar la informaci$$HEX1$$f300$$ENDHEX$$n.')
	Return
ELSE
	Commit;
	MessageBox('Exito','La informaci$$HEX1$$f300$$ENDHEX$$n fue modificada Exitosamente.')
	dw_lista.Retrieve() //para que no muestre mas los rollos que fueron marcados como aprobados o rechazados
END IF

end event

on w_aprobacion_calidad_tono.create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.gb_1}
end on

on w_aprobacion_calidad_tono.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1
icst_lectura = create  cst_adm_conexion

dw_lista.settransobject(icst_lectura.of_get_transaccion_sucia())
dw_lista.Retrieve()
dw_lista.SetFocus()
end event

event closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_lista from datawindow within w_aprobacion_calidad_tono
integer x = 59
integer y = 44
integer width = 4379
integer height = 1636
integer taborder = 10
string title = "none"
string dataobject = "dtb_aprobacion_calidad_tono"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;//Long ll_solicitud, ll_tanda, ll_reftel
//Long li_colorte
//s_base_parametros lstr_parametros
//
//lstr_parametros.entero[1] = This.GetItemNumber(Row,'cs_solicitud')
//lstr_parametros.entero[2] = This.GetItemNumber(Row,'cs_tanda')
//lstr_parametros.entero[3] = This.GetItemnumber(Row,'co_tela')
//lstr_parametros.entero[4] = This.GetItemNumber(Row,'color_te')
//
//
//OpenWithParm ( w_rollos_tanda_calidad, lstr_parametros )
//
//
//
end event

type gb_1 from groupbox within w_aprobacion_calidad_tono
integer x = 32
integer y = 12
integer width = 4439
integer height = 1732
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

