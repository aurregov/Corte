HA$PBExportHeader$w_trazos_x_session2.srw
forward
global type w_trazos_x_session2 from window
end type
type st_lsec from statictext within w_trazos_x_session2
end type
type st_2 from statictext within w_trazos_x_session2
end type
type st_ltz from statictext within w_trazos_x_session2
end type
type st_1 from statictext within w_trazos_x_session2
end type
type cbx_retazo from checkbox within w_trazos_x_session2
end type
type dw_oc from u_dw_base within w_trazos_x_session2
end type
type cb_2 from commandbutton within w_trazos_x_session2
end type
type dw_seccion from u_dw_base within w_trazos_x_session2
end type
type dw_pdn_talla from u_dw_base within w_trazos_x_session2
end type
type dw_produccion from u_dw_base within w_trazos_x_session2
end type
type dw_trazo from u_dw_base within w_trazos_x_session2
end type
type cb_1 from commandbutton within w_trazos_x_session2
end type
type gb_1 from groupbox within w_trazos_x_session2
end type
end forward

global type w_trazos_x_session2 from window
integer width = 3657
integer height = 1932
boolean titlebar = true
string title = "Secciones por Trazos ."
string menuname = "m_mantenimiento_seccion_trazos"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_buscar ( )
event ue_prog_manual ( )
event ue_borrar_seccion ( )
event ue_generar_oc ( )
event ue_ventana_oc ( long an_cs_orden_corte )
event ue_imprimir_oc ( )
event ue_observacion ( )
event ue_devolver_oc ( )
event ue_pendientes ( )
event ue_trazo_balanceo ( )
st_lsec st_lsec
st_2 st_2
st_ltz st_ltz
st_1 st_1
cbx_retazo cbx_retazo
dw_oc dw_oc
cb_2 cb_2
dw_seccion dw_seccion
dw_pdn_talla dw_pdn_talla
dw_produccion dw_produccion
dw_trazo dw_trazo
cb_1 cb_1
gb_1 gb_1
end type
global w_trazos_x_session2 w_trazos_x_session2

type variables

Long il_orden,il_agrupa,il_numtalla,il_numpdn
Boolean ib_tzbs = False
end variables

forward prototypes
public function long of_cscutivotrazo ()
public function long of_calseccion (long an_trazo, long an_seccion)
public function long of_devolver_orden (long al_ordencorte)
public function long of_buscar ()
public function long of_cuadro (long an_fila)
public function long of_trazodefinido (long an_row)
public function long of_agrupacion (long an_orden)
public function long of_calcapas ()
public function long of_yield (long an_row)
end prototypes

event ue_buscar();n_cts_param luo_param
Long ll_result


This.Title = "Secciones por Trazos"

dw_pdn_talla.Reset()
dw_produccion.Reset()
dw_seccion.Reset()
dw_trazo.Reset()
dw_oc.Reset()

Open(w_parametro_corte)
 
luo_param = Message.PowerObjectParm

If IsValid(luo_param) Then
	il_orden  = luo_param.il_vector[1]
	il_agrupa = of_agrupacion(il_orden)
	
	If il_agrupa = -1 Then Return
	
	Of_Buscar()

End If
end event

event ue_prog_manual;Long ll_fila


If dw_pdn_talla.RowCount() > 0 And dw_pdn_talla.RowCount() = il_numpdn Then
	ll_fila = dw_pdn_talla.InsertRow(0)
	
	dw_pdn_talla.SetFocus()
	dw_pdn_talla.SetRow(ll_fila)
	dw_pdn_talla.SetItem(ll_fila,'prot',0)
	dw_pdn_talla.SetColumn('cs_liberacion')
End If

end event

event ue_borrar_seccion;DataStore lds_trazo
Long   ll_fila,ll_pdn,ll_trazo,ll_seccion,ll_fltz,ll_modelo,&
       ll_fab,ll_ref,ll_carac,ll_diamt,ll_color,ll_cstz,ll_rslt,&
		 ll_tzdf,ll_count
Long    li_i,li_co_estado_trazo
String ls_sqlerr



lds_trazo = Create DataStore
lds_trazo.DataObject = 'd_lista_trazos_x_seccion'
lds_trazo.SetTransobject(Sqlca)


ll_fltz = 0
ll_fila = 0

ll_fltz = dw_trazo.GetSelectedRow(ll_fltz)

If ll_fltz <= 0 Then Return 

ll_trazo  = dw_trazo.GetItemNumber(ll_fltz,'cs_base_trazos')
ll_modelo = dw_trazo.GetItemNumber(ll_fltz,'co_modelo')
ll_fab    = dw_trazo.GetItemNumber(ll_fltz,'co_fabrica_te')
ll_ref    = dw_trazo.GetItemNumber(ll_fltz,'co_reftel')
ll_carac  = dw_trazo.GetItemNumber(ll_fltz,'co_caract')
ll_diamt  = dw_trazo.GetItemNumber(ll_fltz,'diametro')
ll_color  = dw_trazo.GetItemNumber(ll_fltz,'co_color_te')

Do
	ll_fila = dw_seccion.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then 
		ll_pdn     = dw_seccion.GetItemNumber(ll_fila,'cs_pdn')
		ll_cstz    = dw_seccion.GetItemNumber(ll_fila,'cs_trazo')
		ll_seccion = dw_seccion.GetItemNumber(ll_fila,'cs_seccion')
		
		ll_rslt = lds_trazo.Retrieve(il_orden,il_agrupa,ll_trazo,ll_cstz,ll_seccion,ll_pdn,ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color)
		
		delete 
		  from dt_trazosxbase  
   	 where cs_orden_corte = :il_orden and 
				 cs_agrupacion = :il_agrupa and  
				 cs_base_trazos = :ll_trazo and 
				 cs_trazo = :ll_cstz  and
				 cs_seccion = :ll_seccion and  
				 cs_pdn = :ll_pdn and
		   	 co_modelo = :ll_modelo and
				 co_fabrica_te = :ll_fab and 
				 co_reftel = :ll_ref and 
				 co_caract = :ll_carac and
				 diametro = :ll_diamt and
				 co_color_te = :ll_color  ;
				
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ; 
			MessageBox("Advertencia!","No se pudo borrar la secci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
			Return
		End If
		
		
		
		If ll_rslt = -1 Then
			rollback ; 
			MessageBox("Advertencia!","No se pudo recuperar los trazos de la secci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
			Return
		ElseIf ll_rslt > 0 Then
			For li_i = 1 To lds_trazo.RowCount()
				ll_tzdf = lds_trazo.GetItemNumber(li_i,'co_trazo')
				
				select count(*)
				  into :ll_count 
				  from dt_trazosxbase
				 where co_trazo =  :ll_tzdf ;
				 
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ; 
					MessageBox("Advertencia!","No se pudo recuperar los trazos de la secci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
					Return
				ElseIf ll_count = 0 Then
					
					//valida que el trazo sea tipo 3 de lo contrario no borra
					SELECT h_trazos.co_estado_trazo  
					 INTO :li_co_estado_trazo  
					 FROM h_trazos  
					WHERE h_trazos.co_trazo = :ll_tzdf   ;
									
					If Sqlca.SqlCode = -1 Then
						ls_sqlerr = Sqlca.SqlErrText
						rollback ; 
						MessageBox("Advertencia!","No se pudo recuperar el trazo del maestro.~n~n~nNota: " + ls_sqlerr)
						Return
					Else
					end if
									
					IF li_co_estado_trazo=3 THEN
						
						delete 
						  from dt_tallasxtrazo  
						 where co_trazo = :ll_tzdf ;
						  
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ; 
							MessageBox("Advertencia!","No se pudo borrar las tallas de los trazos definidos.~n~n~nNota: " + ls_sqlerr)
							Return
						End If
						
						delete 
						  from dt_refptxtrazo  
						 where co_trazo = :ll_tzdf ;
						  
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ; 
							MessageBox("Advertencia!","No se pudo borrar las referencias de los trazos definidos.~n~n~nNota: " + ls_sqlerr)
							Return
						End If
	
						delete 
						  from h_trazos  
						 where co_trazo = :ll_tzdf ;
						  
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ; 
							MessageBox("Advertencia!","No se pudo borrar las referencias de los trazos definidos.~n~n~nNota: " + ls_sqlerr)
							Return
						End If						
						
					ELSE
						//el estado del trazo es <>3, no borre
					END IF

				End If
			Next
		End If
		
		
	End If	
loop Until ll_fila = 0

commit ;

Destroy lds_trazo

Of_Cuadro(ll_fltz)
end event

event ue_generar_oc();////llamar a stored procedure
DataStore ids_trazo
Long ll_ordencorte,ll_i
////Long li_lote, li_estado, 
Long	li_pos_cortar, li_pos_inicial,li_return,li_trazo,sw_trazo
String ls_body,ls_trazo
//, li_fabrica, li_planta
////Long li_tipocentropdn
s_base_parametros lstr_parametros_retro
OLEObject lole_outlook,lole_item,lole_attach

ids_trazo = Create DataStore
ids_trazo.DataObject = 'ds_trazos'
ids_trazo.Retrieve(SQLCA)

////
IF dw_oc.Rowcount() > 0 THEN
//IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_oc.GetItemNumber(1, "dt_pdnxmodulo_cs_asignacion")
//	li_lote = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_parcial")
//	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_lote_con")
//	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_destino")
//	li_planta = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta_destino")
//	li_tipocentropdn = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_version")
	IF Not IsNull(ll_ordencorte)  THEN

		lstr_parametros_retro.cadena[1]="Procesando ..."
		lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
		lstr_parametros_retro.cadena[3]="reloj"
	
		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)			
		DECLARE loteo PROCEDURE FOR
			pr_generar_ordencr(:ll_ordencorte);
		EXECUTE loteo;
		IF SQLCA.SQLCode = -1 THEN			
			IF SQLCA.SQLDBCode = -746 THEN
				li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
				li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
				MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
			ELSE
				MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
			END IF
			ROLLBACK;
		ELSE
			commit;
			//genero correo avisando de la nueva orden de corte
			//realizo retrieve de la data store
			ids_trazo.Retrieve(ll_ordencorte)
			
			//recorro la data store y armo el cuerpo del e-mail			
			FOR ll_i = 1 TO ids_trazo.RowCount()
				li_trazo = ids_trazo.GetItemNumber(ll_i,'co_trazo')
				IF isnull(li_trazo) THEN 
					li_trazo = 0
				ELSE
					sw_trazo = 1
				END IF
				
				ls_trazo = ids_trazo.GetItemString(ll_i,'de_trazo')
				IF isnull(ls_trazo) THEN ls_trazo = ''
				IF IsNull(ls_body) THEN ls_body = " "
		
				ls_body = ls_body + ' Trazo: ' + String(li_trazo) + ' Descripci$$HEX1$$f300$$ENDHEX$$n: ' +String(ls_trazo)
				
			NEXT
			
			//envio el correo
			ls_body = 'Orden de corte: ' + String(ll_ordencorte) + '  ' + ls_body
			
			IF sw_trazo <> 1 THEN
			ELSE
				/*Dbedocal
				lole_outlook = Create OLEObject
				
				li_return = lole_outlook.ConnectToNewObject("outlook.application")
				
				If li_return <> 0 Then
					Messagebox("Advertencia!","No se pudo establecer conexi$$HEX1$$f300$$ENDHEX$$n con Outlook.~n~nError : " &
								 + String(li_return) )
					Destroy lole_outlook
					Return 
				End If
				
				lole_item = lole_outlook.CreateItem(0)
				
				lole_item.To      = "cgm_corte@saraintl.com"
				lole_item.Subject = "Orden de corte generada"
				lole_item.Body    = ls_body
				
				lole_item.Send
				
				Destroy lole_item
				*/
				
				uo_correo	lnv_correo
				lnv_correo = CREATE uo_correo
				
				TRY
					lnv_correo.of_enviar_correo('Orden de corte generada', ls_body,'orden_corte_gen')
				CATCH(Exception ex)
					Messagebox("Error", ex.getmessage())
				END TRY
				DESTROY lnv_correo 
			END IF
			
			COMMIT;
		END IF
		//This.TriggerEvent("ue_buscar")			
		CLOSE(w_retroalimentacion)
	ELSE
		MessageBox("Advertencia","Debe seleccionar un lote para realizar el loteo")
	END IF
ELSE
	MessageBox("Advertencia","Debe tener N$$HEX1$$fa00$$ENDHEX$$mero de Orden de Corte Generada.")
END IF
end event

event ue_ventana_oc;//llama ventana de oc
LONG		ll_cs_orden_corte,ll_count
n_cts_param lstr_parametros

IF dw_oc.Rowcount() > 0 THEN
	ll_cs_orden_corte=dw_oc.GetitemNumber(1,"dt_pdnxmodulo_cs_asignacion")	
	
	select count(*)
	into :ll_count
	from h_ordenes_corte
	where cs_orden_corte = :ll_cs_orden_corte;
	
	IF ll_count >= 1 THEN
		lstr_parametros.il_vector[1]	=	ll_cs_orden_corte
		lstr_parametros.is_vector[1] = 'S'			
		OpenSheetWithParm(w_crear_ordenes_sin_busqueda, lstr_parametros, w_trazos_x_session2, 0, Layered!)		
	ELSE
		MessageBox('Advertencia','La orden de corte que desea imprimir aun no ha sido generada, por favor verifique')
	END IF
ELSE
	MessageBox('Advertencia','No ha sido seleccionada ninguna orden de corte, por favor verifique')
END IF




end event

event ue_imprimir_oc;//imprime oc
LONG		ll_cs_orden_corte,ll_count
n_cts_param lstr_parametros

IF dw_oc.Rowcount() > 0 THEN
	ll_cs_orden_corte=dw_oc.GetitemNumber(1,"dt_pdnxmodulo_cs_asignacion")	
	
	select count(*)
	into :ll_count
	from h_ordenes_corte
	where cs_orden_corte = :ll_cs_orden_corte;
	
	IF ll_count >= 1 THEN
		lstr_parametros.il_vector[1]	=	ll_cs_orden_corte
		lstr_parametros.is_vector[1] = 'S'			
		OpenSheetWithParm(w_reporte_orden_corte_sin_busqueda, lstr_parametros, w_trazos_x_session2, 0, Layered!)		
	ELSE
		MessageBox('Advertencia','La orden de corte que desea imprimir aun no ha sido generada, por favor verifique')
	END IF
ELSE
	MessageBox('Advertencia','No ha sido seleccionada ninguna orden de corte, por favor verifique')
END IF
end event

event ue_observacion;//llama ventana de oc
LONG		ll_cs_orden_corte,ll_count
s_base_parametros lstr_parametros

IF dw_oc.Rowcount() > 0 THEN
	ll_cs_orden_corte=dw_oc.GetitemNumber(1,"dt_pdnxmodulo_cs_asignacion")	
	
	select count(*)
	into :ll_count
	from h_ordenes_corte
	where cs_orden_corte = :ll_cs_orden_corte;
	
	IF ll_count >= 1 THEN
		lstr_parametros.entero[1]	=	ll_cs_orden_corte
		lstr_parametros.Hay_Parametros =	TRUE		
		OpenSheetWithParm(w_observacion_corte,lstr_parametros,w_trazos_x_session2,1, Original!)			
	ELSE
		MessageBox('Adveretencia','No es posible ingresar observaciones a una orden de corte sin haber sido generada con anterioridad, por favor revise sus datos e intente nuevamente.')
	END IF
ELSE
	MessageBox('Adveretencia','No ha sido seleccionada ninguna orden de corte, revise sus datos e intente nuevamente')
END IF

end event

event ue_devolver_oc;Long ll_ordencorte
Long li_estado

IF dw_oc.Rowcount() > 0 THEN

	ll_ordencorte = dw_oc.GetItemNumber(1, "dt_pdnxmodulo_cs_asignacion")
	
	IF of_devolver_orden(ll_ordencorte) = -1 THEN Return
	
ELSE
	MessageBox('Advertencia','No sea seleccionado ninguna orden de corte para devolver')
	Return
	
END IF
end event

event ue_pendientes;s_base_parametros lstr_parametros

//Opensheet(w_reportes_ordenes_pendientes_programar,w_principal,0,layered!)
Open(w_pendientes_x_programar)

lstr_parametros = Message.PowerObjectParm

IF lstr_parametros.cadena[1] = 'S' THEN
	
	
	dw_pdn_talla.Reset()
	dw_trazo.Reset()
	dw_produccion.Reset()
	dw_oc.Reset()
	dw_seccion.Reset()
	
	il_orden = lstr_parametros.entero[1]
	il_agrupa = of_agrupacion(il_orden)
	of_buscar()
	
END IF
end event

event ue_trazo_balanceo;Long ll_fila, ll_trazo, ll_j, ll_sum, ll_capa, ll_paquetes



If dw_pdn_talla.RowCount() > 0 And dw_pdn_talla.RowCount() = il_numpdn Then
	ll_fila = dw_pdn_talla.InsertRow(0)
	dw_pdn_talla.SetFocus()
	dw_pdn_talla.SetRow(ll_fila)
	dw_pdn_talla.SetItem(ll_fila,'prot',0)
	dw_pdn_talla.SetColumn('cs_liberacion')
	IF dw_seccion.RowCount() >= 1 THEN
		ll_trazo = dw_seccion.GetItemNumber(dw_seccion.RowCount(),'cs_trazo')
	ELSE
		ll_trazo = 0
	END IF
	dw_pdn_talla.SetItem(ll_fila,'cs_liberacion',ll_trazo + 1)
	dw_pdn_talla.SetItem(ll_fila,'pdn',1)
	
	
	For ll_j = 1 To il_numtalla
		dw_pdn_talla.SetItem(ll_fila,"talla" + String(ll_j),1)
		ll_paquetes += 1
	Next 
	
	FOR ll_fila = 1 TO dw_pdn_talla.RowCount() - 1
		ll_capa = dw_pdn_talla.GetItemNumber(ll_fila,'talla'+String(il_numtalla + 1))
		
		ll_sum = Truncate((ll_capa * 0.1) / ll_paquetes, 0)
		
		dw_pdn_talla.SetItem(ll_fila,"talla" + String(il_numtalla + 2),ll_sum)
	NEXT
End If
end event

public function long of_cscutivotrazo ();Long   ll_cs_documento
String ls_sqlerr



select max(cs_documento )  
  into :ll_cs_documento  
  from cf_consecutivos  
 where co_fabrica = 91 and
		 id_documento = 55  ;
		 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	MessageBox("Advertencia!","Hubo un error al buscar el consecutivo para la base.~n~n~nNota: " + ls_sqlerr,Stopsign!)
	Return -1
End If

ll_cs_documento ++			
			
update cf_consecutivos  
   set cs_documento = cs_documento + 1  
 where cf_consecutivos.co_fabrica = 91 and
		 cf_consecutivos.id_documento = 55  ;

If Sqlca.SqlCode = -1 Then	
	ls_sqlerr = Sqlca.SqlErrText
	rollback ; 
	MessageBox("Advertencia!","Hubo Problemas Actualizando Consecutivo de Trazo.~n~n~nNota: " + ls_sqlerr,Stopsign!,OK!)
	Return -1 
End If

Return ll_cs_documento

end function

public function long of_calseccion (long an_trazo, long an_seccion);DataStore lds_trazodf
Long     li_i,li_j,li_sw,li_tzsw,li_swrtz,li_swex
Long    ll_capa,ll_pack,ll_seccion,ll_pdn,ll_cntpg,ll_talla,ll_disp,&
        ll_result,ll_fila,ll_trazo,ll_modelo,ll_fab,ll_ref,ll_carac,&
		  ll_diamt,ll_color,ll_found,ll_dftz,ll_fbpdn,ll_lnpdn,&
		  ll_rfpdn,ll_cpins,ll_numtll,ll_tztmp
String  ls_sqlerr,ls_deref
Decimal ldc_ancho



lds_trazodf = Create DataStore

lds_trazodf.DataObject = 'd_buscar_trazo_definido_para_utilizar'

lds_trazodf.SetTransObject(Sqlca)

delete from t_trazos ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ; 
	MessageBox("Advertencia!","No se pudo borrar la tabla temporal de las tallas.~n~n~nNota: " + ls_sqlerr)
	Return -1
Else 
	commit ;
End If

dw_pdn_talla.AcceptText()

ll_fila   = dw_trazo.GetSelectedRow(0)

ll_trazo  = dw_trazo.GetItemNumber(ll_fila,'cs_base_trazos')
ll_modelo = dw_trazo.GetItemNumber(ll_fila,'co_modelo')
ll_fab    = dw_trazo.GetItemNumber(ll_fila,'co_fabrica_te')
ll_ref    = dw_trazo.GetItemNumber(ll_fila,'co_reftel')
ll_carac  = dw_trazo.GetItemNumber(ll_fila,'co_caract')
ll_diamt  = dw_trazo.GetItemNumber(ll_fila,'diametro')
ll_color  = dw_trazo.GetItemNumber(ll_fila,'co_color_te')
ldc_ancho = dw_trazo.GetItemDecimal(ll_fila,'ancho_cortable')

//select max(cs_seccion)  
//  into :ll_seccion  
//  from dt_trazosxbase  
// where cs_agrupacion = :il_agrupa and
//		 cs_base_trazos = :ll_trazo and
//		 cs_trazo = :an_trazo ;
//
//
//If Sqlca.SqlCode = -1 Then
//	ls_sqlerr = Sqlca.SqlErrText
//	rollback ; 
//	MessageBox("Advertencia!","No se pudo recuparar el consecutivo de la seccion.~n~n~nNota: " + ls_sqlerr)
//	Return -1
//ElseIf IsNull(ll_seccion) Then
//	ll_seccion = 0
//End If

//ll_seccion ++

If Not ib_tzbs Then
	For li_i = 1 To il_numpdn
		
		ll_fbpdn = dw_pdn_talla.GetItemNumber(li_i,"co_fabrica")
		ll_lnpdn = dw_pdn_talla.GetItemNumber(li_i,"co_lin")
		ll_rfpdn = dw_pdn_talla.GetItemNumber(li_i,"co_ref")
		
		ll_numtll = 0
		
		For li_j = 1 To il_numtalla
			ll_talla = Long(dw_pdn_talla.Describe("talla" + String(li_j) + ".tag"))
			ll_pack  = dw_pdn_talla.GetItemNumber(il_numpdn + 1,"talla" + String(li_j))
			
			If ll_pack > 0 Then 
				
				
				select count(*)
				  into :ll_found
				  from t_trazos
				 where co_fabrica = :ll_fbpdn and
				       co_linea = :ll_lnpdn and
						 co_referencia = :ll_rfpdn and
						 co_talla = :ll_talla ;
				
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ; 
					MessageBox("Advertencia!","No se pudo insertar en la tabla temporal de las tallas.~n~n~nNota: " + ls_sqlerr)
					Return -1
				ElseIf ll_found = 0 Then
			
					ll_numtll ++
					
					insert into t_trazos  
						( co_fabrica,co_linea,co_referencia,co_talla,ca_paquetes )  
					values ( :ll_fbpdn,:ll_lnpdn,:ll_rfpdn,:ll_talla,:ll_pack )  ;
		
					If Sqlca.SqlCode = -1 Then
						ls_sqlerr = Sqlca.SqlErrText
						rollback ; 
						MessageBox("Advertencia!","No se pudo insertar en la tabla temporal de las tallas.~n~n~nNota: " + ls_sqlerr)
						Return -1
					End If
				End If
			End If
		Next 	
	Next
	
	lds_trazodf.Retrieve(ldc_ancho)
	
	ll_fila = 1
	
	Do
		ll_fila = lds_trazodf.Find("contador = " + String(ll_numtll),ll_fila,lds_trazodf.RowCount())
	
		If ll_fila > 0 Then
			ll_tztmp = lds_trazodf.GetItemNumber(ll_fila,'co_trazo')
			ll_fbpdn = lds_trazodf.GetItemNumber(ll_fila,"co_fabrica")
			ll_lnpdn = lds_trazodf.GetItemNumber(ll_fila,"co_linea")
			ll_rfpdn = lds_trazodf.GetItemNumber(ll_fila,"co_referencia")
			
			ll_fila ++
			
			select count(*)  
           into :ll_found  
           from dt_tallasxtrazo  
          where co_trazo = :ll_tztmp and
                co_fabrica = :ll_fbpdn and
                co_linea = :ll_lnpdn and  
                co_referencia = :ll_rfpdn   ;

			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ; 
				MessageBox("Advertencia!","No se pudo insertar en la tabla temporal de las tallas.~n~n~nNota: " + ls_sqlerr)
				Return -1
			End If
			
			If ll_found = ll_numtll Then
				If MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","El trazo " + String(ll_tztmp) + " es similar al que a ingresado $$HEX1$$bf00$$ENDHEX$$Desea utilizarlo?",Question!,YesNo!) = 1 Then
					
					ll_fila = 1
					ll_fila = dw_produccion.Find("co_trazo = " + String(ll_tztmp),ll_fila,dw_produccion.RowCount())
					If ll_fila <= 0 Then
						MessageBox("Advetencia!","Hubo un error al buscar la producci$$HEX1$$f300$$ENDHEX$$n.")
					Else
						Of_TrazoDefinido(ll_fila)
					End If
					
					Return -1
				End If
			End If
		End If
		
	Loop Until ll_fila = 0 Or ll_fila > lds_trazodf.RowCount()
End If


ll_dftz  = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount(),"co_trazo")	  
ll_found = 0
li_tzsw  = 0

For li_i = 1 To il_numpdn
	ll_pdn  = dw_pdn_talla.GetItemNumber(li_i,"pdn")
	ll_capa = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(il_numtalla + 2))
	
	ll_fbpdn = dw_pdn_talla.GetItemNumber(li_i,"co_fabrica")
	ll_lnpdn = dw_pdn_talla.GetItemNumber(li_i,"co_lin")
	ll_rfpdn = dw_pdn_talla.GetItemNumber(li_i,"co_ref")
	ls_deref = dw_pdn_talla.GetItemString(li_i,"co_referencia")
	li_swex  = dw_pdn_talla.GetItemNumber(li_i,"exref")
	li_sw = 0
	
	If (ll_capa > 0 Or cbx_retazo.Checked) And li_swex = 0 Then
		For li_j = 1 To il_numtalla
			ll_talla = Long(dw_pdn_talla.Describe("talla" + String(li_j) + ".tag"))
			ll_disp  = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(li_j))
			ll_pack  = dw_pdn_talla.GetItemNumber(il_numpdn + 1,"talla" + String(li_j))
			
			If (ll_pack > 0 and ll_disp > 0) Or ( ll_pack > 0 And cbx_retazo.Checked) Then
				
				ll_cntpg  = ll_pack * ll_capa
				ll_cpins  = ll_capa
				ll_result = ll_disp - ll_cntpg
				li_swrtz  = 2
				
				If cbx_retazo.Checked Then li_swrtz  = 1
							
				select cs_orden_corte  
				  into :ll_found  
				  from dt_trazosxbase  
				 where cs_orden_corte = :il_orden and 
						 cs_agrupacion = :il_agrupa and  
						 cs_base_trazos = :ll_trazo and 
						 cs_trazo = :an_trazo  and
						 cs_seccion = :an_seccion and  
						 cs_pdn = :ll_pdn and
						 co_talla = :ll_talla and
						 co_modelo = :ll_modelo and
						 co_fabrica_te = :ll_fab and 
						 co_reftel = :ll_ref and 
						 co_caract = :ll_carac and
						 diametro = :ll_diamt and
						 co_color_te = :ll_color  ;
				
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ; 
					MessageBox("Advertencia!","Hubo un error al consultar la talla en las secciones por trazos.~n~n~nNota: " + ls_sqlerr)
					Return -1
				ElseIf Sqlca.SqlCode = 0 Then
					rollback ; 
					MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La talla " + String(ll_talla) + " ya esta en la secci$$HEX1$$f300$$ENDHEX$$n " + String(an_seccion) + " del trazo " + String(an_trazo) + "."  )
					Return -1
				End If
						
//				If ll_cntpg <= (ll_disp + 10) Or cbx_retazo.Checked Then 
					
					If Not ib_tzbs Then
						
						If li_tzsw = 0 Then
							
							li_tzsw = 1
							
							ll_dftz = Of_CscutivoTrazo()
		
							If ll_dftz = -1 Then Return -1 
							
							ls_deref += " " + String(ll_dftz)
							
							insert into h_trazos  
								( co_trazo,de_trazo,molderia,ancho,largo,porc_util,tipo,extendido,   
								  fe_creacion,fe_actualizacion,usuario,instancia,co_estado_trazo )  
							values ( :ll_dftz,:ls_deref,:ls_deref,:ldc_ancho,0,0,1,2,current,current,user,   
								  sitename,3 )  ;
								  
							If Sqlca.SqlCode = -1 Then
								ls_sqlerr = Sqlca.SqlErrText
								rollback ; 
								MessageBox("Advertencia!","No se pudo insertar el encabezado de los trazos.~n~n~nNota: " + ls_sqlerr)
								Return -1
							End If
						End If
						
						
						If li_sw = 0 Then
							li_sw = 1
							
							select count(*)  
							  into :ll_found  
							  from dt_refptxtrazo  
							 where co_trazo = :ll_dftz and
									 co_fabrica = :ll_fbpdn and
									 co_linea = :ll_lnpdn and
									 co_referencia = :ll_rfpdn  ;

							If Sqlca.SqlCode = -1 Then
								ls_sqlerr = Sqlca.SqlErrText
								rollback ; 
								MessageBox("Advertencia!","No se pudo consultar las referencias del trazo.~n~n~nNota: " + ls_sqlerr)
								Return -1
							ElseIf ll_found = 0 Then
								insert into dt_refptxtrazo  
									( co_trazo,co_fabrica,co_linea,co_referencia,fe_actualizacion,   
									  fe_creacion,usuario,instancia )  
								values ( :ll_dftz,:ll_fbpdn,:ll_lnpdn,:ll_rfpdn,current,current,   
									 user,sitename)  ;
		
								If Sqlca.SqlCode = -1 Then
									ls_sqlerr = Sqlca.SqlErrText
									rollback ; 
									MessageBox("Advertencia!","No se pudo insertar la referencia en el trazo.~n~n~nNota: " + ls_sqlerr)
									Return -1
								End If
							End If
						End If
						
						select count(*)  
						  into :ll_found  
						  from dt_tallasxtrazo  
						 where co_trazo = :ll_dftz and
								 co_fabrica = :ll_fbpdn and
								 co_linea = :ll_lnpdn and
								 co_referencia = :ll_rfpdn and
								 co_talla = :ll_talla ;
						
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ; 
							MessageBox("Advertencia!","No se pudo insertar la referencia en el trazo.~n~n~nNota: " + ls_sqlerr)
							Return -1
						ElseIf ll_found = 0 Then
						
							insert into dt_tallasxtrazo  
								( co_trazo,co_fabrica,co_linea,co_referencia,co_talla,ca_paquetes,   
								  fe_creacion,fe_actualizacion,usuario,instancia )  
							values ( :ll_dftz,:ll_fbpdn,:ll_lnpdn,:ll_rfpdn,:ll_talla,:ll_pack,current,   
										current,user,sitename )  ;
		
							If Sqlca.SqlCode = -1 Then
								ls_sqlerr = Sqlca.SqlErrText
								rollback ; 
								MessageBox("Advertencia!","No se pudo insertar las tallas de los trazos.~n~n~nNota: " + ls_sqlerr)
								Return -1
							End If
						End If
					End If
															
					insert into dt_trazosxbase  
						 ( cs_orden_corte,cs_agrupacion,cs_base_trazos,cs_trazo,cs_seccion,   
							cs_pdn, co_talla,co_modelo,co_fabrica_te,co_reftel,co_caract,   
							diametro,co_color_te,ca_paquetes,capas,ca_programadas,ca_resulta,   
							co_trazo,ca_disponibles,co_estado,co_tipo,sw_retazos,fe_creacion,
							fe_actualizacion,usuario,instancia )  
					values ( :il_orden,:il_agrupa,:ll_trazo,:an_trazo,:an_seccion,:ll_pdn,   
							:ll_talla,:ll_modelo,:ll_fab,:ll_ref,:ll_carac,:ll_diamt,:ll_color,   
							:ll_pack,:ll_cpins,:ll_cntpg,:ll_result,:ll_dftz,:ll_disp,1,2,:li_swrtz,   
							current,current,user,sitename )  ;
	
					If Sqlca.SqlCode = -1 Then
						ls_sqlerr = Sqlca.SqlErrText
						rollback ; 
						MessageBox("Advertencia!","No se pudo recuparar el consecutivo de la seccion.~n~n~nNota: " + ls_sqlerr)
						Return -1
					End If
//				Else
//					rollback ; 
//					MessageBox("Advertencia!","La cantidad " + String(ll_cntpg) + " supera la disponible en la talla " + String(ll_talla) + " de la producci$$HEX1$$f300$$ENDHEX$$n " + String(ll_pdn) + ".")
//					Return -1
//				End If
			End If
		Next
	End If
Next

commit ;

Return 0
end function

public function long of_devolver_orden (long al_ordencorte);Long li_estado

select co_estado
into :li_estado
from h_ordenes_corte
where cs_orden_corte = :al_ordencorte;
	
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurrio un error al momento de consultar la orden de corte')
	Return -1
END IF

IF li_estado = 1 OR li_estado = 2 THEN
	
	delete from dt_observa_oc
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_observa_oc')
		Rollback;
		Return -1
	END IF
		
	delete from dt_unidadesxtrazo 
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_unidadesxtrazo')
		Rollback;
		Return -1
	END IF
	
	delete from dt_trazosxoc  
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_trazosxoc')
		Rollback;
		Return -1
	END IF
	
	delete from dt_rayas_telaxoc
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_rayas_telaxoc')
		Rollback;
		Return -1
	END IF
	
	delete from dt_escalasxoc 
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_escalasxoc')
		Rollback;
		Return -1
	END IF
	
	delete from h_ordenes_corte 
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurrio un error al momento de borrar en h_ordenes_corte')
		Rollback;
		Return -1
	END IF
	
ELSE
	MessageBox('Error','El estado de la orden de corte, hace que no sea posible devolverla.')
	Return -1
END IF

Return 0
end function

public function long of_buscar ();Long ll_result


ll_result = dw_trazo.Retrieve(il_agrupa)
	
If ll_result <= 0 Then
	MessageBox("Advertencia!","Hubo errores al recuperar la producci$$HEX1$$f300$$ENDHEX$$n.")
	dw_trazo.Reset()
	dw_produccion.Reset()
	Return -1
Else
	This.Title = "Secciones por Trazos :=: N$$HEX1$$fa00$$ENDHEX$$mero Orden " + String(il_orden)
End If

dw_oc.Retrieve (il_agrupa)

Return 0
end function

public function long of_cuadro (long an_fila);DataStore lds_tallas,lds_cant,lds_trazob
Long    ll_i,li_swv,li_talla,li_j
Long   ll_pdn,ll_pdnant,ll_fila,ll_cant,ll_total,ll_flfn,ll_ctpg,ll_trazo,&
       ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color,ll_rslt
String ls_title,ls_tag



st_ltz.Text  = ''
st_lsec.Text = ''

cbx_retazo.Checked = False

ll_trazo  = dw_trazo.GetItemNumber(an_fila,'cs_base_trazos')
ll_modelo = dw_trazo.GetItemNumber(an_fila,'co_modelo')
ll_fab    = dw_trazo.GetItemNumber(an_fila,'co_fabrica_te')
ll_ref    = dw_trazo.GetItemNumber(an_fila,'co_reftel')
ll_carac  = dw_trazo.GetItemNumber(an_fila,'co_caract')
ll_diamt  = dw_trazo.GetItemNumber(an_fila,'diametro')
ll_color  = dw_trazo.GetItemNumber(an_fila,'co_color_te')


dw_pdn_talla.Reset()
dw_produccion.Retrieve(il_agrupa,ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color)
dw_seccion.Retrieve(il_agrupa,ll_trazo,ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color)


lds_tallas = Create DataStore
lds_cant   = Create DataStore
lds_trazob = Create DataStore 

lds_tallas.DataObject = 'd_distintas_tallas_trazos_produccion'
lds_cant.DataObject   = 'd_lista_trazo_cantidad_talla_x_pdn'
lds_trazob.DataObject = 'd_cantidad_trazos_produccion'

lds_tallas.SetTransObject(Sqlca)
lds_cant.SetTransObject(Sqlca)
lds_trazob.SetTransObject(Sqlca)

il_numtalla = lds_tallas.Retrieve(il_agrupa,ll_trazo)

If il_numtalla <= 0 Then
	MessageBox("Advertencia!","Este agrupaci$$HEX1$$f300$$ENDHEX$$n no tiene tallas.")
	Return -1
End If

For ll_i = 1 To 23
	If il_numtalla >= ll_i Then
		li_swv   = 1
		ls_title = String(lds_tallas.GetItemNumber(ll_i,'co_talla'))
	Else
		li_swv = 0
		ls_title = 'Capas'
		If (il_numtalla + 1) = ll_i Then  ls_title = 'Total'
		If (il_numtalla + 2) >= ll_i Then li_swv   = 1
	End If
	
	dw_pdn_talla.Modify("talla" + String(ll_i) + "_t.Text='" + ls_title + "'")
	dw_pdn_talla.Modify("talla" + String(ll_i) + "_t.Visible='" + String(li_swv) + "'")
	dw_pdn_talla.Modify("talla" + String(ll_i) + ".Visible='" + String(li_swv) + "'")
	dw_pdn_talla.Modify("talla" + String(ll_i) + ".tag='" + ls_title + "'")
Next


ll_rslt = lds_cant.Retrieve(il_agrupa,ll_trazo,ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color)
lds_trazob.Retrieve(il_agrupa,ll_trazo,ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color)

If ll_rslt > 0 Then
	ll_pdnant = lds_cant.GetItemNumber(1,'cs_pdn')
	ll_total  = 0
	il_numpdn = 1
	
	For ll_i = 1 To lds_cant.RowCount()
	
		ll_pdn   = lds_cant.GetItemNumber(ll_i,'cs_pdn')
		li_talla = lds_cant.GetItemNumber(ll_i,'co_talla')
		ll_cant  = lds_cant.GetItemNumber(ll_i,'ca_unidades')
		
		ll_flfn = lds_trazob.Find("cs_pdn = " + String(ll_pdn) + " and co_talla = " + String(li_talla),1,lds_trazob.RowCount()) 
		
		ll_ctpg = 0
		
		If ll_flfn > 0 Then
			ll_ctpg = lds_trazob.GetItemNumber(ll_flfn,"cantidad")
		End If
		
		ll_cant -= ll_ctpg
		
		If ll_i = 1 Then 
			ll_fila = dw_pdn_talla.InsertRow(0)
		ElseIf ll_pdn <> ll_pdnant Then 
			ll_fila  = dw_pdn_talla.InsertRow(0)
			il_numpdn ++
			ll_total = 0
		End If
		
		dw_pdn_talla.SetItem(ll_fila,"co_fabrica",lds_cant.GetItemNumber(ll_i,'co_fabrica_exp'))
		dw_pdn_talla.SetItem(ll_fila,"pedido",lds_cant.GetItemNumber(ll_i,'pedido'))
		dw_pdn_talla.SetItem(ll_fila,"cs_liberacion",lds_cant.GetItemNumber(ll_i,'cs_liberacion'))
		dw_pdn_talla.SetItem(ll_fila,"po",Trim(lds_cant.GetItemString(ll_i,'po')))
		//dw_pdn_talla.SetItem(ll_fila,"co_linea",Trim(lds_cant.GetItemString(ll_i,'de_lin')))
		dw_pdn_talla.SetItem(ll_fila,"co_lin",(lds_cant.GetItemNumber(ll_i,'co_linea')))
		dw_pdn_talla.SetItem(ll_fila,"co_referencia",Trim(lds_cant.GetItemString(ll_i,'de_referencia')))
		dw_pdn_talla.SetItem(ll_fila,"co_ref",(lds_cant.GetItemNumber(ll_i,'co_referencia')))
		dw_pdn_talla.SetItem(ll_fila,"co_color",lds_cant.GetItemString(ll_i,'de_color'))
		dw_pdn_talla.SetItem(ll_fila,"tono",Trim(lds_cant.GetItemString(ll_i,'tono')))
		dw_pdn_talla.SetItem(ll_fila,"est",lds_cant.GetItemNumber(ll_i,'cs_estilocolortono'))
		dw_pdn_talla.SetItem(ll_fila,"par",lds_cant.GetItemNumber(ll_i,'cs_particion'))
		
		ll_total += ll_cant
		
		ll_pdnant = ll_pdn
		
		For li_j = 1 To il_numtalla
			If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
				dw_pdn_talla.SetItem(ll_fila,"talla" + String(li_j),ll_cant)
				Exit
			End If
		Next 
		
		dw_pdn_talla.SetItem(ll_fila,"pdn",ll_pdn)
		dw_pdn_talla.SetItem(ll_fila,"talla" + String(il_numtalla + 1),ll_total)
		
	Next
End If

Destroy lds_tallas
Destroy lds_cant
Destroy lds_trazob

Return 0
end function

public function long of_trazodefinido (long an_row);DataStore lds_tallas,lds_ref 
Long ll_fila,ll_trazo,ll_ref,ll_flfnd
Long  li_talla,li_capas,li_j,li_i,li_fab,li_lin



ll_fila = dw_trazo.GetSelectedRow(ll_fila)

Of_Cuadro(ll_fila)


If dw_pdn_talla.RowCount() > 0 And dw_pdn_talla.RowCount() = il_numpdn Then
	ll_fila = dw_pdn_talla.InsertRow(0)
	dw_pdn_talla.SetFocus()
	dw_pdn_talla.SetRow(ll_fila)
	dw_pdn_talla.SetItem(ll_fila,'prot',0)
	dw_pdn_talla.SetColumn('cs_liberacion')
Else
	Return -1
End If

ib_tzbs = True

lds_tallas = Create DataStore
lds_ref    = Create DataStore


lds_tallas.DataObject = 'd_lista_talla_referencia_dt_tallasxtrazo'
lds_ref.DataObject = 'd_lista_referencias_x_un_trazo_definido'

lds_tallas.SetTransObject(Sqlca)
lds_ref.SetTransObject(Sqlca)

For li_i = 1 To il_numpdn
	dw_pdn_talla.SetItem(li_i,'exref',1)	
Next

ll_trazo = dw_produccion.GetItemNumber(an_row,'co_trazo')

lds_ref.Retrieve(ll_trazo)

For li_i = 1 To lds_ref.RowCount() 
	
	li_fab   = lds_ref.GetItemNumber(li_i,'co_fabrica')
	li_lin   = lds_ref.GetItemNumber(li_i,'co_linea')
	ll_ref   = lds_ref.GetItemNumber(li_i,'co_referencia')
	
	ll_flfnd = 1
	
	Do 
		ll_flfnd = dw_pdn_talla.Find("co_fabrica = " + String(li_fab) + " and " + &
											  "co_lin = " + String(li_lin) + " and " + &
											  "co_ref = " + String(ll_ref),ll_flfnd,dw_pdn_talla.RowCount())
		
		If ll_flfnd > 0 Then
			dw_pdn_talla.SetItem(ll_flfnd,'exref',0)
			ll_flfnd ++
		End If	
				
	Loop Until ll_flfnd = 0 Or ll_flfnd > dw_pdn_talla.RowCount()
Next
	
dw_pdn_talla.SetItem(ll_fila,"co_trazo",ll_trazo)

lds_tallas.Retrieve(ll_trazo)

For li_i = 1 To lds_tallas.RowCount() 
	li_talla = lds_tallas.GetItemNumber(li_i,'co_talla')
	li_capas = lds_tallas.GetItemNumber(li_i,'ca_paquetes')
	For li_j = 1 To il_numtalla
		If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
			dw_pdn_talla.SetItem(il_numpdn + 1,"talla" + String(li_j),li_capas)
		End If
	Next 
Next
	
Of_CalCapas()

Destroy lds_tallas
Destroy lds_ref

Return 0
end function

public function long of_agrupacion (long an_orden);Long   ll_agrupa
String ls_sqlerr


select distinct dt_agrupa_pdn.cs_agrupacion  
  into :ll_agrupa  
  from dt_pdnxmodulo,   
       dt_agrupa_pdn  
 where dt_pdnxmodulo.co_fabrica_exp 		= dt_agrupa_pdn.co_fabrica_exp and
       dt_pdnxmodulo.pedido 					= dt_agrupa_pdn.pedido and
       dt_pdnxmodulo.cs_liberacion 			= dt_agrupa_pdn.cs_liberacion and
       dt_pdnxmodulo.po 						= dt_agrupa_pdn.po and
       dt_pdnxmodulo.co_fabrica_pt 			= dt_agrupa_pdn.co_fabrica_pt and 
       dt_pdnxmodulo.co_linea 				= dt_agrupa_pdn.co_linea and
       dt_pdnxmodulo.co_referencia 			= dt_agrupa_pdn.co_referencia and  
       dt_pdnxmodulo.co_color_pt 			= dt_agrupa_pdn.co_color_pt and
       dt_pdnxmodulo.tono 						= dt_agrupa_pdn.tono and  
       dt_pdnxmodulo.cs_estilocolortono 	= dt_agrupa_pdn.cs_estilocolortono and
       dt_pdnxmodulo.cs_particion 			= dt_agrupa_pdn.cs_particion and
       dt_pdnxmodulo.cs_asignacion 			= :an_orden ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","Hubo un error al recuperar la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~nNota: " + ls_sqlerr)
	Return -1
ElseIf Sqlca.SqlCode = 100 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Esta orden no tiene agrupaci$$HEX1$$f300$$ENDHEX$$n.")
	Return -1
End If

Return ll_agrupa
end function

public function long of_calcapas ();Long  li_i,li_j
Long ll_cant,ll_capa,ll_nmtlla,ll_mncp,ll_raya,ll_fila

ll_fila = dw_trazo.GetRow()
ll_raya = dw_trazo.GetItemNumber(ll_fila,'raya')

dw_pdn_talla.AcceptText()

For li_i = 1 To il_numpdn
	ll_mncp = 20000000
	For li_j = 1 To il_numtalla
		ll_nmtlla = dw_pdn_talla.GetItemNumber(il_numpdn + 1,"talla" + String(li_j))
		
		If ll_nmtlla > 0 Then
			ll_cant = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(li_j))
			
			If ll_cant > 0 Then
				If ll_raya <> 10 THEN
					ll_capa = Ceiling(ll_cant / ll_nmtlla)
				ELSE
					ll_capa = Truncate(ll_cant / ll_nmtlla , 0)
				END IF
				 
				If ll_mncp > ll_capa Then ll_mncp = ll_capa
			End If
		End If
			
	Next
	
	If ll_mncp = 20000000 Then ll_mncp = 0
	
	If ll_mncp > 0 Then dw_pdn_talla.SetItem(li_i,"talla" + String(il_numtalla + 2),ll_mncp)
Next

Return 0


end function

public function long of_yield (long an_row);u_ds_base lds_trazo
Long    ll_cstzo,ll_seccion,ll_trazo,ll_fltz,ll_pack,ll_cnt,ll_cntt,&
        ll_secaux,ll_secsel
Long     li_i, li_talla, li_talla_ant
decimal ldc_grs,ldc_prom,ldc_largo,ldc_lgsec


ll_fltz = dw_trazo.GetRow()

ll_trazo  = dw_trazo.GetItemNumber(ll_fltz,'cs_base_trazos')
ll_cstzo  = dw_seccion.GetItemNumber(an_row,'cs_trazo')
ll_secsel = dw_seccion.GetItemNumber(an_row,'cs_seccion')


lds_trazo   = Create u_ds_base

lds_trazo.DataObject   = 'd_gramos_trazo'

lds_trazo.SetTransObject(Sqlca)

ll_pack   = 0
ll_cntt   = 0
ldc_prom  = 0 
ldc_largo = 0

If lds_trazo.Retrieve(il_orden,il_agrupa,ll_trazo,ll_cstzo) > 0 Then
	
	ll_secaux = lds_trazo.GetItemNumber(1,'cs_seccion')
	li_talla_ant = 0
	
	For li_i = 1 To lds_trazo.RowCount()
		ll_seccion = lds_trazo.GetItemNumber(li_i,'cs_seccion')
		
		If ll_seccion <> ll_secaux Then 
			ldc_largo += ( ldc_prom / ll_cntt ) * ll_pack
			
			If ll_secaux = ll_secsel Then ldc_lgsec = ( ldc_prom / ll_cntt ) * ll_pack
			
			ll_pack   = 0
			ll_cntt   = 0
			ldc_prom  = 0 
		End If
		
		ll_secaux = ll_seccion
		
		li_talla = lds_trazo.GetItemNumber(li_i,'co_talla')
		ll_cnt  =  lds_trazo.GetItemNumber(li_i,'ca_programadas')
		IF li_talla <> li_talla_ant THEN
			ll_pack += lds_trazo.GetItemNumber(li_i,'ca_paquetes')
			li_talla_ant = li_talla
		ELSE
//			ll_pack = lds_trazo.GetItemNumber(li_i,'ca_paquetes')			
		END IF
		ldc_grs =  lds_trazo.GetItemDecimal(li_i,'grs')
	
		ll_cntt  += ll_cnt
		ldc_prom += ll_cnt * ldc_grs 
		
	Next
	ldc_largo += ( ldc_prom / ll_cntt ) * ll_pack
	If ll_seccion = ll_secsel Then ldc_lgsec = ( ldc_prom / ll_cntt ) * ll_pack
End If

st_ltz.Text  = String(ldc_largo,"#,##0.00")
st_lsec.Text = String(ldc_lgsec,"#,##0.00")

Destroy lds_trazo

Return 0
end function

on w_trazos_x_session2.create
if this.MenuName = "m_mantenimiento_seccion_trazos" then this.MenuID = create m_mantenimiento_seccion_trazos
this.st_lsec=create st_lsec
this.st_2=create st_2
this.st_ltz=create st_ltz
this.st_1=create st_1
this.cbx_retazo=create cbx_retazo
this.dw_oc=create dw_oc
this.cb_2=create cb_2
this.dw_seccion=create dw_seccion
this.dw_pdn_talla=create dw_pdn_talla
this.dw_produccion=create dw_produccion
this.dw_trazo=create dw_trazo
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.st_lsec,&
this.st_2,&
this.st_ltz,&
this.st_1,&
this.cbx_retazo,&
this.dw_oc,&
this.cb_2,&
this.dw_seccion,&
this.dw_pdn_talla,&
this.dw_produccion,&
this.dw_trazo,&
this.cb_1,&
this.gb_1}
end on

on w_trazos_x_session2.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_lsec)
destroy(this.st_2)
destroy(this.st_ltz)
destroy(this.st_1)
destroy(this.cbx_retazo)
destroy(this.dw_oc)
destroy(this.cb_2)
destroy(this.dw_seccion)
destroy(this.dw_pdn_talla)
destroy(this.dw_produccion)
destroy(this.dw_trazo)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;TRANSACTION			itr_tela
STRING	ls_instruccion


itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_produccion.SetTransObject(itr_tela)
dw_trazo.SetTransObject(itr_tela)
dw_seccion.SetTransObject(itr_tela)
dw_oc.SetTransObject(itr_tela)

ls_instruccion = "SET LOCK MODE TO WAIT 60 "
EXECUTE IMMEDIATE :ls_instruccion USING itr_tela;
IF SQLCA.SQLCODE = -1 THEN
   MessageBox("ERROR....","Problemas con la base de datos en el modo de bloqueo: " +sqlca.sqlerrtext,Stopsign!,OK!)
   Return(-1)
END IF

This.TriggerEvent("ue_buscar")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_produccion.SetTransObject(sqlca)
dw_trazo.SetTransObject(sqlca)
dw_seccion.SetTransObject(sqlca)
dw_oc.SetTransObject(sqlca)

end event

type st_lsec from statictext within w_trazos_x_session2
integer x = 3058
integer y = 1596
integer width = 402
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_2 from statictext within w_trazos_x_session2
integer x = 2807
integer y = 1596
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seccion:"
boolean focusrectangle = false
end type

type st_ltz from statictext within w_trazos_x_session2
integer x = 2286
integer y = 1596
integer width = 402
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_trazos_x_session2
integer x = 2094
integer y = 1596
integer width = 192
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trazo:"
boolean focusrectangle = false
end type

type cbx_retazo from checkbox within w_trazos_x_session2
integer x = 1006
integer y = 1596
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Retazo"
end type

type dw_oc from u_dw_base within w_trazos_x_session2
integer x = 1669
integer y = 540
integer width = 1925
integer height = 300
integer taborder = 30
string dataobject = "d_lista_oc_pdn_estilo_po_color_x_agrupa"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_2 from commandbutton within w_trazos_x_session2
boolean visible = false
integer x = 2322
integer y = 672
integer width = 347
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = ">> Trazo"
end type

event clicked;Long ll_fila,ll_trazo
Long  li_talla,li_capas,li_j


ll_fila = dw_produccion.GetSelectedRow(0)

If ll_fila > 0 and dw_pdn_talla.RowCount() > 0 And (il_numpdn + 1) = dw_pdn_talla.RowCount() Then
	li_talla = dw_produccion.GetItemNumber(ll_fila,'co_talla')
	li_capas = dw_produccion.GetItemNumber(ll_fila,'ca_paquetes')
			
	For li_j = 1 To il_numtalla
		If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
			dw_pdn_talla.SetItem(il_numpdn + 1,"talla" + String(li_j),li_capas)
			Of_CalCapas()
			Exit
		End If
	Next 
	
End If





//dw_pdn_talla.AcceptText()
//
//ll_fila = 0 
//
//If  Then
//	ll_fila = dw_trazo.GetSelectedRow(ll_fila)
//	ll_trazo = dw_pdn_talla.GetItemNumber(il_numpdn + 1,'pdn')
//	
//	If ll_trazo = 0 Or IsNull(ll_trazo) Then
//		MessageBox("Advertencia!","Debe indicar el trazo que desea adicionar.")
//	Else
//		If Of_CalSeccion(ll_trazo) = 0 Then
//			Of_Cuadro(ll_fila)
//		End If
//	End If	
//End If
end event

type dw_seccion from u_dw_base within w_trazos_x_session2
integer x = 1669
integer y = 848
integer width = 1925
integer height = 688
integer taborder = 20
string dataobject = "d_lista_secciones_x_trazos"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;


If dwo.Name = ("talla" + String(il_numtalla + 2)) Then
	//Of_CalCapas()
End If


If Row = (il_numpdn + 1) Then
	Of_CalCapas()
End If
end event

event clicked;call super::clicked;

If Row <= 0 Then Return


If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
	
	of_yield(Row)
	
End If
end event

type dw_pdn_talla from u_dw_base within w_trazos_x_session2
integer x = 23
integer y = 8
integer width = 3557
integer height = 520
integer taborder = 10
string dataobject = "d_cuadro_pdn_x_tallas_pendientes"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Long ll_cpnv,ll_cpvj


//If dwo.Name = ("talla" + String(il_numtalla + 2)) Then
//	ll_cpnv = Long(Data)
//	ll_cpvj = This.GetitemNumber(row,("talla" + String(il_numtalla + 2)))
//	
//	If ll_cpnv > ll_cpvj Then
//		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","El n$$HEX1$$fa00$$ENDHEX$$mero de capas debe ser menor a " + String(ll_cpvj) + "." )
//		Return  1
//	End If
//End If


If Row = (il_numpdn + 1) And Mid(dwo.Name ,1,5) = 'talla' Then
	If Not ib_tzbs Then
		Of_CalCapas()
	Else
		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","No puede modificar una trazo ya establecido.")
		Return 1
	End If
End If

end event

event itemerror;call super::itemerror;
Return 1
end event

type dw_produccion from u_dw_base within w_trazos_x_session2
integer x = 14
integer y = 848
integer width = 1641
integer height = 684
integer taborder = 10
string dataobject = "d_lista_trazos_tallasxtrazo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

//MessageBox("ad",This.GetColumnName())
end event

event doubleclicked;call super::doubleclicked;
If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

Of_TrazoDefinido(Row)
end event

type dw_trazo from u_dw_base within w_trazos_x_session2
integer x = 14
integer y = 540
integer width = 1641
integer height = 304
integer taborder = 10
string dataobject = "d_lista_base_rayasxbase"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;Long ll_trazo




If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

ib_tzbs = False

Of_Cuadro(Row)


	

end event

type cb_1 from commandbutton within w_trazos_x_session2
integer x = 430
integer y = 1588
integer width = 347
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_trazo,ll_fila,ll_seccion,ll_found,ll_base


If dw_pdn_talla.AcceptText() = -1 Then Return

ll_fila = 0 

If dw_pdn_talla.RowCount() > 0 And (il_numpdn + 1) = dw_pdn_talla.RowCount() Then
	
	ll_fila    = dw_trazo.GetSelectedRow(ll_fila)
	
	ll_base    = dw_trazo.GetItemNumber(ll_fila,'cs_base_trazos')
	ll_trazo   = dw_pdn_talla.GetItemNumber(il_numpdn + 1,'cs_liberacion')
	ll_seccion = dw_pdn_talla.GetItemNumber(il_numpdn + 1,'pdn')
	
	If ll_trazo = 0 Or IsNull(ll_trazo) Then
		MessageBox("Advertencia!","Debe indicar el trazo que desea adicionar.")
		Return 
	End If
	
	If ll_seccion = 0 Or IsNull(ll_seccion) Then
		MessageBox("Advertencia!","Debe indicar la secci$$HEX1$$f300$$ENDHEX$$n que desea adicionar.")
		Return 
	End If
	
	
	select count(*)  
     into :ll_found  
     from dt_trazosxbase  
    where cs_orden_corte = :il_orden and 
          cs_agrupacion = :il_agrupa and
          cs_base_trazos = :ll_base and
          cs_trazo = :ll_trazo and
          cs_seccion = :ll_seccion   ;

	If Sqlca.SqlCode = -1 Then
		MessageBox("Advertencia!","Hubo un error al buscar la secci$$HEX1$$f300$$ENDHEX$$n.")
		Return
	ElseIf ll_found > 0 Then
		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La secci$$HEX1$$f300$$ENDHEX$$n ya existe y no puede ser modificada.")
		Return
	End If
	
	If Of_CalSeccion(ll_trazo,ll_seccion) = 0 Then
		Of_Cuadro(ll_fila)
	End If
	
End If
end event

type gb_1 from groupbox within w_trazos_x_session2
integer x = 1669
integer y = 1540
integer width = 1925
integer height = 148
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Largo"
end type

