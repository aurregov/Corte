HA$PBExportHeader$w_mantenimiento_bolsas.srw
forward
global type w_mantenimiento_bolsas from window
end type
type dw_lectura_bolsas from datawindow within w_mantenimiento_bolsas
end type
type st_1 from statictext within w_mantenimiento_bolsas
end type
type dw_lista from datawindow within w_mantenimiento_bolsas
end type
type sle_parametros from singlelineedit within w_mantenimiento_bolsas
end type
type gb_1 from groupbox within w_mantenimiento_bolsas
end type
end forward

global type w_mantenimiento_bolsas from window
integer width = 2624
integer height = 2152
boolean titlebar = true
string title = "Mantenimientos Bolsas"
string menuname = "m_mantenimiento_bolsas"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_grabar ( )
event ue_crear ( )
event ue_borrar ( )
dw_lectura_bolsas dw_lectura_bolsas
st_1 st_1
dw_lista dw_lista
sle_parametros sle_parametros
gb_1 gb_1
end type
global w_mantenimiento_bolsas w_mantenimiento_bolsas

type variables
Long il_ordencorte
end variables

event ue_grabar();//se realiza commit de todo lo hecho
end event

event ue_crear();Long ll_fila, ll_cs_bolsa, ll_cant_new, ll_cant_talla, ll_fila2, ll_talla, ll_liq_talla, ll_hallado
Boolean result
Long li_estado, li_result, li_talla, li_tipo, li_centro, li_subcentro, li_fabrica, li_planta,&
        li_fabact, li_plact
String ls_bolsa, ls_cs_bolsa
DateTime ldt_fecha,ldt_fe_actualizacion
DataStore lds_hcan, lds_dtcan, lds_lectura, lds_liq
n_cts_constantes lpo_constantes

dw_lista.AcceptText()

//se determina el perfil para saber si puede realizar dichos cambios
IF gstr_info_usuario.codigo_perfil <> 24 AND gstr_info_usuario.codigo_perfil <> 2 and gstr_info_usuario.codigo_usuario <> 'jorodrig'  THEN
	MessageBox('Advertencia','Perfil no autorizado para crear bolsas.',StopSign!)
	Return
END IF


lpo_constantes = Create n_cts_constantes
SetNull(ldt_fecha)
ldt_fe_actualizacion = f_fecha_servidor()
//se crean los datastore de las tablas h_canasta_corte, dt_canasta_corte, dt_lectura_bolsas y 
//de unidades liquidadas por talla
lds_hcan  = Create DataStore
lds_dtcan = Create DataStore
lds_lectura  = Create DataStore
lds_liq   = Create DataStore

lds_hcan.DataObject  = 'ds_h_canasta_corte'
lds_dtcan.DataObject = 'ds_dt_canasta_corte'
lds_lectura.DataObject  = 'ds_lectura_bolsas'
lds_liq.DataObject   = 'ds_liquidacion_talla'

lds_hcan.SetTransObject(Sqlca)
lds_dtcan.SetTransObject(Sqlca)
lds_lectura.SetTransObject(Sqlca)
lds_liq.SetTransObject(Sqlca)

//conozco el total loteado de la orden de corte
FOR ll_fila2 = 1 To dw_lista.RowCount()
	 ll_talla = dw_lista.GetItemNumber(ll_fila2,'ca_actual')
	 ll_cant_talla += ll_talla
NEXT

//se recorre la data windos verificando las filas seleccionadas, y si estas tienen un estado mayor a 10
FOR ll_fila = 1 To dw_lista.RowCount()
	
	ls_bolsa    = dw_lista.GetItemString(ll_fila,'cs_canasta')
	ll_cant_new = dw_lista.GetItemNumber(ll_fila,'ca_actual_new')
	li_talla    = dw_lista.GetItemNumber(ll_fila,'co_talla')
	result = dw_lista.IsSelected(ll_fila)  
		
	IF result THEN
		
		//total con el cual quedara la talla sumandole la cantidad asignada a la nueva talla
		ll_cant_talla += ll_cant_new
		
		//traemos el total liquidado
		ll_hallado = lds_liq.Retrieve(il_ordencorte)
		
		IF ll_hallado > 0 THEN
			ll_liq_talla = lds_liq.GetItemNumber(1,'ca_liquidada')
					
			IF ll_cant_talla > ll_liq_talla THEN
				Rollback;
				MessageBox('Error','La cantidad ingresada para la talla: '+String(li_talla)+' es superior a la liquidada.')
				Return
			END IF
		ELSE
			Rollback;
			MessageBox('Error','No fue posible establecer la cantidad liquidada para la talla: '+String(li_talla))
			Return
		END IF
		
		//se verifica que el estado sea mayor a 10
		li_estado = dw_lista.GetItemNumber(ll_fila,'co_estado')
		
		IF li_estado > 10 THEN
			//se copia la fila del datastore, con cero para el valor del campo ca_actual en dt_canasta_corte,
			//y co_estado = 10 y pallet_id nulo en h_canasta_corte
			
			//consulto el consecutivo de la nueva bolsa
			ll_cs_bolsa = f_crear_bolsa()
			IF ll_cs_bolsa = -1 THEN 
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el consecutivo de la bolsa.')
				Return
			END IF
			ls_cs_bolsa = string(ll_cs_bolsa)
		
			//*************************realizo el copiado de h_canasta_corte
			li_result = lds_hcan.Retrieve(ls_bolsa)
			
			IF li_result > 0 THEN
				IF lds_hcan.GetItemNumber(1,'co_fabrica') = 0 THEN
					Rollback;
					MessageBox('Error','LA canasta va a quedar con la fabrica en cero, se cancela.')
					Return
				END IF
				
				//se copia la fila
				lds_hcan.RowsCopy(1, li_result, Primary!, lds_hcan, lds_hcan.RowCount() + 1 , Primary!)
				lds_hcan.AcceptText()
								
				//se capturan las constantes necesarias
				li_subcentro = lpo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
				
				IF li_subcentro = -1 THEN
					Rollback;
					Return 
				END IF
				
				li_tipo = lpo_constantes.of_consultar_numerico('PRENDAS')
				
				IF li_tipo = -1 THEN
					Rollback;
					Return 
				END IF
				
				li_centro = lpo_constantes.of_consultar_numerico('CENTRO CORTE')
				
				IF li_centro = -1 THEN
					Rollback;
					Return 
				END IF
				
				li_fabrica = lpo_constantes.of_consultar_numerico('FABRICA LOTEO')
				
				IF li_fabrica = -1 THEN
					Rollback;
					Return 
				END IF
				
				li_planta = lpo_constantes.of_consultar_numerico('PLANTA LOTEO')
				
				IF li_planta = -1 THEN
					Rollback;
					Return 
				END IF
							
				//identifico que la fabrica no sea infantiles
				
				li_fabact = lds_hcan.GetItemNumber(lds_hcan.RowCount(),'co_fabrica')
				li_plact  = lds_hcan.GetItemNumber(lds_hcan.RowCount(),'co_planta')
							
				IF li_fabact = 4 THEN
					li_fabrica = li_fabact
					li_planta  = li_plact
				END IF
							
				lds_hcan.SetItem(lds_hcan.RowCount(),'pallet_id','')
				lds_hcan.SetItem(lds_hcan.RowCount(),'atributo3','')
				lds_hcan.SetItem(lds_hcan.RowCount(),'atributo2','')
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_estado',10)
				lds_hcan.SetItem(lds_hcan.RowCount(),'cs_canasta',ls_cs_bolsa)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_tipoprod',li_tipo)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_centro_pdn',li_centro)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_subcentro_pdn',li_subcentro)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_fabrica',li_fabrica)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_planta',li_planta)
				lds_hcan.SetItem(lds_hcan.RowCount(),'fe_actualizacion',ldt_fe_actualizacion)
				lds_hcan.SetItem(lds_hcan.RowCount(),'usuario',gstr_info_usuario.codigo_usuario)
				lds_hcan.SetItem(lds_hcan.RowCount(),'instancia',gstr_info_usuario.instancia)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_fabrica_pro',li_fabrica)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_fabric_pro_des',li_fabrica)
				lds_hcan.SetItem(lds_hcan.RowCount(),'ubicacion_actual','0000')
				lds_hcan.SetItem(lds_hcan.RowCount(),'ubicacion_anterior','0000')
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_fabrica_act',li_fabrica)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_planta_act',li_planta)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_centro_act',li_centro)
				lds_hcan.SetItem(lds_hcan.RowCount(),'co_subcentro_act',li_subcentro)
				lds_hcan.AcceptText()
				
			ELSE
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de copiar la bolsa: '+ls_bolsa)
				Return
			END IF
			
			
			//*********************se copia dt_canasta_corte
			li_result = lds_dtcan.Retrieve(ls_bolsa)
			
			IF li_result > 0 THEN
				//se copia la fila
				lds_dtcan.RowsCopy(1, li_result, Primary!, lds_dtcan, lds_dtcan.RowCount() + 1 , Primary!)
				lds_dtcan.AcceptText()
				
				
				lds_dtcan.SetItem(lds_dtcan.RowCount(),'ca_actual',ll_cant_new)
				lds_dtcan.SetItem(lds_dtcan.RowCount(),'sw_leido',0)
				lds_dtcan.SetItem(lds_dtcan.RowCount(),'cs_canasta',ls_cs_bolsa)
				lds_dtcan.SetItem(lds_dtcan.RowCount(),'fe_actualizacion',ldt_fe_actualizacion)
				lds_dtcan.SetItem(lds_dtcan.RowCount(),'usuario',gstr_info_usuario.codigo_usuario)
				lds_dtcan.SetItem(lds_dtcan.RowCount(),'instancia',gstr_info_usuario.instancia)
				lds_dtcan.AcceptText()
				
			ELSE
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de copiar la bolsa: '+ls_bolsa)
				Return
			END IF
			
			
			
			//*******************se copia dt_lectura_bolsas
         li_result = lds_lectura.Retrieve(ls_bolsa)
//			li_result = dw_lectura_bolsas.Retrieve(ls_bolsa)
			IF li_result > 0 THEN
				//se copia la fila
//				dw_lectura_bolsas.RowsCopy(li_result, li_result, Primary!, dw_lectura_bolsas, dw_lectura_bolsas.RowCount() + 1 , Primary!)
//				dw_lectura_bolsas.AcceptText()
//				For ll_fila2 = li_result + 1 To dw_lectura_bolsas.RowCount()
//				
//					dw_lectura_bolsas.SetItem(dw_lectura_bolsas.RowCount(),'fe_lectura',ldt_fecha)
//					dw_lectura_bolsas.SetItem(dw_lectura_bolsas.RowCount(),'cs_canasta',ls_cs_bolsa)
//					dw_lectura_bolsas.SetItem(dw_lectura_bolsas.RowCount(),'fe_actualizacion',ldt_fe_actualizacion)
//					dw_lectura_bolsas.SetItem(dw_lectura_bolsas.RowCount(),'usuario',gstr_info_usuario.codigo_usuario)
//					dw_lectura_bolsas.SetItem(dw_lectura_bolsas.RowCount(),'instancia',gstr_info_usuario.instancia)
//					dw_lectura_bolsas.AcceptText()
//				Next
				
				
				lds_lectura.RowsCopy(1, li_result, Primary!, lds_lectura, lds_lectura.RowCount() + 1 , Primary!)
				lds_lectura.AcceptText()
				For ll_fila2 = li_result + 1 To lds_lectura.RowCount()
				
					lds_lectura.SetItem(ll_fila2,'fe_lectura',ldt_fecha)
					lds_lectura.SetItem(ll_fila2,'cs_canasta',ls_cs_bolsa)
					lds_lectura.SetItem(ll_fila2,'fe_actualizacion',ldt_fe_actualizacion)
					lds_lectura.SetItem(ll_fila2,'usuario',gstr_info_usuario.codigo_usuario)
					lds_lectura.SetItem(ll_fila2,'instancia',gstr_info_usuario.instancia)
					lds_lectura.AcceptText()
				Next
	//				
			ELSEIF li_result = 0 THEN
				ll_fila2 = lds_lectura.InsertRow(0)
				lds_lectura.AcceptText()
				lds_lectura.SetItem(ll_fila2,'cs_orden_corte',il_ordencorte)
				lds_lectura.SetItem(ll_fila2,'cs_canasta',ls_cs_bolsa)
				lds_lectura.SetItem(ll_fila2,'co_tipoprod',1)
				lds_lectura.SetItem(ll_fila2,'co_centro_pdn',1)
				lds_lectura.SetItem(ll_fila2,'co_subcentro_pdn',3)
				lds_lectura.SetItem(ll_fila2,'fe_lectura',ldt_fecha)
				lds_lectura.SetItem(ll_fila2,'fe_actualizacion',ldt_fe_actualizacion)
				lds_lectura.SetItem(ll_fila2,'usuario',gstr_info_usuario.codigo_usuario)
				lds_lectura.SetItem(ll_fila2,'instancia',gstr_info_usuario.instancia)
				lds_lectura.AcceptText()
				
			ELSE
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de copiar la bolsa: '+ls_bolsa)
				Return
			END IF
			
		//grabo los cambios realizados
		IF lds_hcan.Update() = -1 THEN
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar h_canasta_corte.')
			Return
		END IF
		
		IF lds_dtcan.Update() = -1 THEN
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar dt_canasta_corte.')
			Return
		END IF
		
		
//		IF ds_dt_lectura_bolsas.Update() = -1 THEN
//			Rollback;
//			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar dt_lectura_bolsas.')
//			Return
//		END IF
		IF lds_lectura.Update() = -1 THEN
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar dt_lectura_bolsas.')
			Return
		END IF
			
		ELSE
			//el estado no permite su creacion
			Rollback;
			MessageBox('Error','El estado de la bolsa: '+ls_bolsa+' No permite que esta sea modificada.')
		END IF
	END IF
NEXT


IF lds_hcan.Update() = -1 THEN
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar h_canasta_corte.')
	Return
END IF

IF lds_dtcan.Update() = -1 THEN
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar dt_canasta_corte.')
	Return
END IF

//IF ds_dt_lectura_bolsas.Update() = -1 THEN
//	Rollback;
//	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar dt_lectura_bolsas.')
//	Return
//END IF
IF lds_lectura.Update() = -1 THEN
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al cargar dt_lectura_bolsas.')
	Return
END IF

Commit;

Destroy lds_hcan;
Destroy lds_dtcan;
Destroy lds_lectura;
Destroy lds_liq;

dw_lista.Retrieve(il_ordencorte)

end event

event ue_borrar();Long ll_fila, ll_cantidad, ll_fila2, ll_talla, ll_cant_talla, ll_hallado, ll_liq_talla
boolean result
Long li_estado, li_result, li_talla, li_espacio
String ls_canasta, ls_error
u_ds_base lds_liq

dw_lista.AcceptText()

//se determina el perfil para saber si puede realizar dichos cambios
IF gstr_info_usuario.codigo_perfil <> 24 AND gstr_info_usuario.codigo_perfil <> 2 THEN
	MessageBox('Advertencia','Perfil no autorizado para borrar bolsas.',StopSign!)
	Return
END IF


lds_liq = Create u_ds_base
lds_liq.DataObject   = 'ds_liquidacion_talla'
lds_liq.SetTransObject(SQLCA)

li_result = MessageBox("Advertencia", 'Esta seguro de eliminar las bolsas seleccionadas.', Exclamation!, OKCancel!, 2)

IF li_result = 1 THEN
	//se recore toda la dw verificando las filas seleccionadas y cada una de estas se verifica
	//que los campos co_estado = 10 si es asi se procede a eliminar de lo contrario
	//mensaje de error y rollback
	FOR ll_fila = 1 TO dw_lista.RowCount()
		result = dw_lista.IsSelected(ll_fila)
	
		IF result THEN
			//se pretende borrar esta bolsa, por lo tanto se verifica la ca_actual y el estado
			ll_cantidad = dw_lista.GetItemNumber(ll_fila,'ca_actual')
			li_estado   = dw_lista.GetItemNumber(ll_fila,'co_estado')
			ls_canasta  = Trim(dw_lista.GetItemString(ll_fila,'cs_canasta'))
			li_talla    = dw_lista.GetItemNumber(ll_fila,'co_talla')
			li_espacio  = dw_lista.GetItemNumber(ll_fila,'cs_espacio')
			IF li_estado = 10 THEN
				//se eliminan las bolsas
				DELETE FROM dt_lectura_bolsas
				WHERE cs_canasta     = :ls_canasta AND
						cs_orden_corte = :il_ordencorte;
				
				IF sqlca.sqlcode = -1 THEN
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar las bolsas. '+ls_error)
					Return
				END IF
				
				DELETE FROM dt_canasta_corte
				WHERE cs_canasta = :ls_canasta AND
				      cs_orden_corte = :il_ordencorte AND
						cs_secuencia = 1;
				
				IF sqlca.sqlcode = -1 THEN
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar las bolsas. '+ls_error)
					Return
				END IF
				
				DELETE FROM h_canasta_corte
				WHERE cs_canasta = :ls_canasta;
				
				IF sqlca.sqlcode = -1 THEN
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar las bolsas. '+ls_error)
					Return
				END IF
			ELSE
				Rollback;
				MessageBox('Error','La bolsa: '+ls_canasta+' No puede ser borrada, por que la cantidad es: '+String(ll_cantidad)+' y su estado es: '+String(li_estado))
				Return 
			END IF
		END IF
	NEXT
	//todo el proceso termino con exito, por lo tanto se cierra la transaccion.
	Commit;
	//se realiza un retrieve de la dw para que el usuario pueda verificar los cambios realizados
	dw_lista.Retrieve(il_ordencorte)
END IF



end event

on w_mantenimiento_bolsas.create
if this.MenuName = "m_mantenimiento_bolsas" then this.MenuID = create m_mantenimiento_bolsas
this.dw_lectura_bolsas=create dw_lectura_bolsas
this.st_1=create st_1
this.dw_lista=create dw_lista
this.sle_parametros=create sle_parametros
this.gb_1=create gb_1
this.Control[]={this.dw_lectura_bolsas,&
this.st_1,&
this.dw_lista,&
this.sle_parametros,&
this.gb_1}
end on

on w_mantenimiento_bolsas.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lectura_bolsas)
destroy(this.st_1)
destroy(this.dw_lista)
destroy(this.sle_parametros)
destroy(this.gb_1)
end on

event open;This.X = 1
This.y = 1



DISCONNECT ;
SQLCA.Lock = "Dirty Read"					
CONNECT ;

dw_lista.SetTransObject(sqlca)
dw_lectura_bolsas.SetTransObject(sqlca)

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

event closequery;DISCONNECT ;
SQLCA.Lock = "cursor stability"					
CONNECT ;
end event

type dw_lectura_bolsas from datawindow within w_mantenimiento_bolsas
boolean visible = false
integer x = 1207
integer y = 8
integer width = 105
integer height = 112
integer taborder = 30
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_mantenimiento_bolsas
integer x = 91
integer y = 40
integer width = 366
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Corte:"
boolean focusrectangle = false
end type

type dw_lista from datawindow within w_mantenimiento_bolsas
integer x = 119
integer y = 180
integer width = 2377
integer height = 1476
integer taborder = 20
string dataobject = "dgr_mantenimiento_bolsas"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Boolean result

result = This.IsSelected(Row)

IF result THEN
   This.SelectRow(Row, FALSE)
ELSE
   This.SelectRow(Row, TRUE)
END IF


end event

type sle_parametros from singlelineedit within w_mantenimiento_bolsas
integer x = 471
integer y = 32
integer width = 599
integer height = 84
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

event modified;Long ll_result
String ls_orden
n_cst_kamban_corte lpo_kamban
n_cts_ocfabrica luo_oc

ls_orden = sle_parametros.text

il_ordencorte = Long(ls_orden)

IF isnull(il_ordencorte) THEN
	MessageBox('Advertencia','N$$HEX1$$fa00$$ENDHEX$$mero de O.C. no es valido.')
	Return 
END IF

//se valida que la orden de corte sea de la fabrica que se esta trabajando
IF luo_oc.of_validarocfabrica(il_ordencorte) = - 1 THEN
	Return
END IF

//se valida que la orden de corte no halla sido despachada
IF lpo_kamban.of_validar_despacho(il_ordencorte) = -1 THEN
	MessageBox('Advertencia','La O.C. se encuentra con fecha de despacho, no es posible modificar sus bolsas.')
	//sle_parametros.Text = ''
	//Return 
ELSE
	
END IF
ll_result = dw_lista.Retrieve(il_ordencorte)

IF ll_result > 0 THEN
ELSE
	MessageBox('Advertencia...','No se recuperaron datos para la orden de corte.')
	Return
END IF

end event

type gb_1 from groupbox within w_mantenimiento_bolsas
integer x = 96
integer y = 124
integer width = 2418
integer height = 1564
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

