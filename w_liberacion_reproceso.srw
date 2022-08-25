HA$PBExportHeader$w_liberacion_reproceso.srw
forward
global type w_liberacion_reproceso from w_base_tabular
end type
type gb_1 from groupbox within w_liberacion_reproceso
end type
end forward

global type w_liberacion_reproceso from w_base_tabular
integer width = 3141
integer height = 1528
event ue_generar_liberacion ( )
gb_1 gb_1
end type
global w_liberacion_reproceso w_liberacion_reproceso

type variables

end variables

event ue_generar_liberacion();Long ll_fila
Long ll_colorant, ll_color
n_cst_liberacion_reproceso lpo_liber
s_base_parametros lstr_parametros

//primero valido que los registros sean con el mismo color
ll_colorant = dw_maestro.GetItemNumber(1,'co_color')
For ll_fila = 1 To dw_maestro.RowCount()
	ll_color = dw_maestro.GetItemNumber(ll_fila,'co_color')
	If ll_colorant <> ll_color Then
		MessageBox('Error','No se puede generar la liberaci$$HEX1$$f300$$ENDHEX$$n para diferentes colores, por favor verifique sus datos.')
		Return 
	End if
Next

If dw_maestro.Update() = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de grabar los datos.')
	Return 
End if

lstr_parametros.cadena[1] = 'Procesando...'
lstr_parametros.cadena[2] = 'El sistema esta generando los datos de la liberaci$$HEX1$$f300$$ENDHEX$$n, esta operaci$$HEX1$$f300$$ENDHEX$$n puede tardar unos minutos, espere un momento por favor.'
lstr_parametros.cadena[3] = 'Reloj'

OpenWithParm (w_retroalimentacion,lstr_parametros )

If lpo_liber.of_Genera_liberacion() = -1 Then
	Close(w_retroalimentacion)
	
	MessageBox('Error','No fue posible generar los datos de la liberaci$$HEX1$$f300$$ENDHEX$$n.')
Else
		
	DELETE FROM t_reposicion
	WHERE usuario = :gstr_info_usuario.codigo_usuario;
	
	dw_maestro.Retrieve(gstr_info_usuario.codigo_usuario)
	Close(w_retroalimentacion)
	
	MessageBox('Exito','Los datos para la liberaci$$HEX1$$f300$$ENDHEX$$n fueron generados exitosamente, por favor verifique sus datos.')

End if
end event

event open;This.x = 1
This.y = 1

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF 

m_mantenimiento_simple.m_opcin4.m_generardatosliberacion.ToolbarItemVisible = True
m_mantenimiento_simple.m_opcin4.m_generardatosliberacion.Enabled = True

dw_maestro.SetTransObject(SQLCA)
dw_maestro.Retrieve(gstr_info_usuario.codigo_usuario)
end event

on w_liberacion_reproceso.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_liberacion_reproceso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event ue_insertar_maestro;il_fila_actual_maestro = dw_maestro.InsertRow(0)
dw_maestro.SetItem(il_fila_actual_maestro,'usuario',gstr_info_usuario.codigo_usuario)
end event

event ue_activar_cxe;return 1
end event

event ue_desactivar_cxe;return 1
end event

event systemcommand;//
end event

event ue_buscar;dw_maestro.Retrieve(gstr_info_usuario.codigo_usuario)
end event

type dw_maestro from w_base_tabular`dw_maestro within w_liberacion_reproceso
integer x = 69
integer y = 68
integer width = 2994
integer height = 1192
string dataobject = "dtb_liberacion_reproceso"
end type

event dw_maestro::doubleclicked;Long ll_fila
s_base_parametros lstr_parametros

This.AcceptText()

ll_fila = dw_maestro.GetRow()

choose case GetColumnName()
	case 'co_linea'
		lstr_parametros.entero[1] = This.GetItemNumber(ll_fila,'co_fabrica')
		OpenWithParm ( w_lineas_response,lstr_parametros  )
				
		lstr_parametros = message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros = True Then
			This.SetItem(ll_fila,'co_linea',lstr_parametros.entero[1])
			This.SetItem(ll_fila,'de_linea',lstr_parametros.cadena[1])
		End if
		
		
	case 'co_referencia'	
		Open(w_referencias_response)
		
		lstr_parametros = message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros = True Then
			This.SetItem(ll_fila,'co_referencia',lstr_parametros.entero[1])
			This.SetItem(ll_fila,'de_referencia',lstr_parametros.cadena[1])
		End if
	
	case 'co_lanzamiento'	
		lstr_parametros.entero[1] = This.GetItemNumber(ll_fila,'co_fabrica')
		lstr_parametros.entero[2] = This.GetItemNumber(ll_fila,'co_linea')
		lstr_parametros.entero[3] = This.GetItemNumber(ll_fila,'co_referencia')
		
		OpenWithParm (w_lanzamientos_response, lstr_parametros)
		
		lstr_parametros = message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros = True Then
			This.SetItem(ll_fila,'co_lanzamiento',lstr_parametros.entero[1])
			
		End if
		
end choose

end event

event dw_maestro::itemchanged;Long ll_ref, ll_count
Long li_fab, li_lin, li_lan
String ls_linea, ls_referencia

This.AcceptText()

choose case GetColumnName()
	case 'co_linea'
			li_fab = This.GetItemNumber(row,'co_fabrica')
			li_lin = This.GetItemNumber(row,'co_linea')
			SELECT de_linea
			  INTO :ls_linea
			  FROM m_lineas
			 WHERE co_fabrica = :li_fab AND
			       co_linea   = :li_lin;
			
			This.SetItem(row,'de_linea',ls_linea)
	
		
	case 'co_referencia'	
			li_fab = This.GetItemNumber(row,'co_fabrica')
		   li_lin = This.GetItemNumber(row,'co_linea')
			ll_ref = This.GetItemNumber(row,'co_referencia')
			SELECT de_referencia
			  INTO :ls_referencia
			  FROM h_preref_pv
			 WHERE co_fabrica 	= :li_fab AND
			 		 co_linea   	= :li_lin AND
 				    (Cast(:ll_ref as char(15) ) = h_preref_pv.co_referencia ) and
					 co_tipo_ref = 'P';  
			
			This.SetItem(row,'de_referencia',ls_referencia)
			
	case 'co_lanzamiento'		
			li_fab = This.GetItemNumber(row,'co_fabrica')
		   li_lin = This.GetItemNumber(row,'co_linea')
			ll_ref = This.GetItemNumber(row,'co_referencia')
			li_lan = This.GetItemNumber(row,'co_lanzamiento')
			
			SELECT count(*)
			  INTO :ll_count
			  FROM dt_lanzamientos
			 WHERE co_fabrica 	 = :li_fab AND 
			 		 co_linea 		 = :li_lin AND
					 co_referencia  = :ll_ref AND
					 co_lanzamiento = :li_lan;
					 
			If ll_count = 0 Then
				MessageBox('Error','El c$$HEX1$$f300$$ENDHEX$$digo del lanzamiento no existe para dicha fabrica, l$$HEX1$$ed00$$ENDHEX$$nea, referencia.')
				This.SetItem(row,'co_lanzamiento',0)
				Return 1
			End if
			
end choose

end event

type sle_argumento from w_base_tabular`sle_argumento within w_liberacion_reproceso
boolean visible = false
integer x = 133
integer y = 8
integer width = 55
end type

type st_1 from w_base_tabular`st_1 within w_liberacion_reproceso
boolean visible = false
integer width = 64
integer height = 72
end type

type gb_1 from groupbox within w_liberacion_reproceso
integer x = 46
integer y = 20
integer width = 3026
integer height = 1252
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
end type

