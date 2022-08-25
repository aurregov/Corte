HA$PBExportHeader$w_trazos_x_session_version2.srw
forward
global type w_trazos_x_session_version2 from window
end type
type cbx_1 from checkbox within w_trazos_x_session_version2
end type
type st_total from statictext within w_trazos_x_session_version2
end type
type st_trazo from statictext within w_trazos_x_session_version2
end type
type st_aprobado from statictext within w_trazos_x_session_version2
end type
type st_5 from statictext within w_trazos_x_session_version2
end type
type st_4 from statictext within w_trazos_x_session_version2
end type
type st_3 from statictext within w_trazos_x_session_version2
end type
type st_lsec from statictext within w_trazos_x_session_version2
end type
type st_2 from statictext within w_trazos_x_session_version2
end type
type st_ltz from statictext within w_trazos_x_session_version2
end type
type st_1 from statictext within w_trazos_x_session_version2
end type
type cbx_retazo from checkbox within w_trazos_x_session_version2
end type
type dw_oc from u_dw_base within w_trazos_x_session_version2
end type
type cb_2 from commandbutton within w_trazos_x_session_version2
end type
type dw_seccion from u_dw_base within w_trazos_x_session_version2
end type
type dw_pdn_talla from u_dw_base within w_trazos_x_session_version2
end type
type dw_produccion from u_dw_base within w_trazos_x_session_version2
end type
type dw_trazo from u_dw_base within w_trazos_x_session_version2
end type
type cb_1 from commandbutton within w_trazos_x_session_version2
end type
type gb_1 from groupbox within w_trazos_x_session_version2
end type
type gb_2 from groupbox within w_trazos_x_session_version2
end type
end forward

global type w_trazos_x_session_version2 from window
integer width = 3666
integer height = 2132
boolean titlebar = true
string title = "Secciones por Trazos"
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
event ue_habilitar_recalculo ( )
cbx_1 cbx_1
st_total st_total
st_trazo st_trazo
st_aprobado st_aprobado
st_5 st_5
st_4 st_4
st_3 st_3
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
gb_2 gb_2
end type
global w_trazos_x_session_version2 w_trazos_x_session_version2

type variables

Long il_orden,il_agrupa,il_numtalla,il_numpdn
Boolean ib_tzbs = False
Long ii_fabrica, ii_planta, ii_simulacion, ii_agrupada, ii_fab_corte
end variables

forward prototypes
public subroutine of_consumos (long an_agrupacion, long an_basetrazo, long an_espacio, long an_seccion)
public function long of_buscar ()
public function long of_calcapas ()
public function long of_devolver_orden (long al_ordencorte)
public function long of_cuadro (long an_fila)
public function long of_calseccion (long an_trazo, long an_seccion)
public function long of_trazodefinido (long an_row)
public function long of_yield (long an_row)
public function long of_cscutivotrazo ()
public function long of_agrupacion (long an_orden, ref long ai_estado_agrupa)
public function long of_verificar_estado (long al_ordencorte)
public function long of_validartrazosmodelo (long al_ordencorte)
public function long of_validacion_temporal_kg_rollos (long al_orden_corte)
end prototypes

event ue_buscar();n_cts_param luo_param
Long ll_result
Long li_estado_agrupa
n_cst_orden_corte luo_ordencorte


This.Title = "Secciones por Trazos"

dw_pdn_talla.Reset()
dw_produccion.Reset()
dw_seccion.Reset()
dw_trazo.Reset()
dw_oc.Reset()

Open(w_parametro_corte)
 
luo_param = Message.PowerObjectParm

If luo_param.is_vector[1] <> 'N' Then
	il_orden  = luo_param.il_vector[1]
	il_agrupa = of_agrupacion(il_orden, li_estado_agrupa)
	
	If il_agrupa = -1 Then Return
	
	If li_estado_agrupa <> 2 Then
		MessageBox("Advertencia...","Estado de agrupaci$$HEX1$$f300$$ENDHEX$$n inconsistente")
		Return
	End If	
	
	ll_result = of_verificar_estado(il_orden) 
	
// Vamos a consultar si la orden de corte es agrupada, esto para el momento
// de programar los trazos el sistema programe automaticamente el trazo seleccionado
// para todas las producciones.

	ii_agrupada = luo_ordencorte.of_validar_agrupada(il_orden)
	
IF ll_result = 1 THEN
	dw_seccion.Enabled = False
	dw_pdn_talla.Enabled = False
	dw_produccion.Enabled = False
ELSE
	dw_seccion.Enabled = True
	dw_pdn_talla.Enabled = True
	dw_produccion.Enabled = True
END IF
IF ll_result = 2 THEN Return
	
	Of_Buscar()

End If
end event

event ue_prog_manual();Long ll_fila


If dw_produccion.RowCount() = 0 Then
	If dw_pdn_talla.RowCount() > 0 And dw_pdn_talla.RowCount() = il_numpdn Then
		ll_fila = dw_pdn_talla.InsertRow(0)
		
		dw_pdn_talla.SetFocus()
		dw_pdn_talla.SetRow(ll_fila)
		dw_pdn_talla.SetItem(ll_fila,'prot',0)
		dw_pdn_talla.SetItem(ll_fila, 'co_trazo', 0)
		dw_pdn_talla.SetColumn('cs_liberacion')
	End If
	
	of_calcapas()
Else
	MessageBox("Advertencia...","Esta raya no se puede programar manual, tiene definici$$HEX1$$f300$$ENDHEX$$n de trazos")
End If
end event

event ue_borrar_seccion();DataStore lds_trazo
Long   ll_fila,ll_pdn,ll_trazo,ll_seccion,ll_fltz,ll_modelo,&
       ll_fab,ll_ref,ll_carac,ll_diamt,ll_color,ll_cstz,ll_rslt,&
		 ll_tzdf,ll_count
Long    li_i,li_co_estado_trazo,ll_trazos
String ls_sqlerr



lds_trazo = Create DataStore
lds_trazo.DataObject = 'd_lista_trazos_x_seccion'
lds_trazo.SetTransobject(Sqlca)


ll_fltz = 0
ll_fila = 0

ll_fltz = dw_trazo.GetSelectedRow(ll_fltz)

If ll_fltz <= 0 Then Return 

ll_trazo  = dw_trazo.GetItemNumber(ll_fltz,'cs_base_trazos')
ll_fab    = dw_trazo.GetItemNumber(ll_fltz,'co_fabrica_te')
ll_ref    = dw_trazo.GetItemNumber(ll_fltz,'co_reftel')
ll_carac  = dw_trazo.GetItemNumber(ll_fltz,'co_caract')
ll_diamt  = dw_trazo.GetItemNumber(ll_fltz,'diametro')

Do
	ll_fila = dw_seccion.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then 
		ll_pdn     = dw_seccion.GetItemNumber(ll_fila,'cs_pdn')
		ll_cstz    = dw_seccion.GetItemNumber(ll_fila,'cs_trazo')
		ll_seccion = dw_seccion.GetItemNumber(ll_fila,'cs_seccion')
		//ll_color  = dw_seccion.GetItemNumber(ll_fltz,'co_color_te')		
		ll_color  = dw_seccion.GetItemNumber(ll_fila,'co_color_te')		
		
		ll_rslt = lds_trazo.Retrieve(il_orden,il_agrupa,ll_trazo,ll_cstz,ll_seccion,ll_pdn,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color)
		
		delete 
		  from dt_trazosxbase  
   	 where cs_orden_corte = :il_orden and 
				 cs_agrupacion = :il_agrupa and  
				 cs_base_trazos = :ll_trazo and 
				 cs_trazo = :ll_cstz  and
				 cs_seccion = :ll_seccion and  
				 cs_pdn = :ll_pdn and
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
		
		SELECT count(*)  
		 INTO :ll_trazos  
		 FROM dt_trazosxbase  
		WHERE dt_trazosxbase.cs_orden_corte = :il_orden   ;
		
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ; 
			MessageBox("Advertencia!","No se pudo verificar cantidad de trazos generados.~n~n~nNota: " + ls_sqlerr)
			Return
		End If
		
		if ISNULL(ll_trazos) OR ll_trazos=0 then
			UPDATE dt_pdnxmodulo  
			  SET co_estado_asigna = 6  
			WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
					( dt_pdnxmodulo.co_fabrica = :ii_fabrica ) AND  
					( dt_pdnxmodulo.co_planta = :ii_planta ) AND  
					( dt_pdnxmodulo.cs_asignacion = :il_orden  );
					
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ; 
				MessageBox("Advertencia!","No se pudo actualizar el estado en el programa de corte.~n~n~nNota: " + ls_sqlerr)
				Return
			End If

		else
		end if
		
		
		
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
					Destroy lds_trazo
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
						Destroy lds_trazo
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
							Destroy lds_trazo
							Return
						End If
						
						delete 
						  from dt_refptxtrazo  
						 where co_trazo = :ll_tzdf ;
						  
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ; 
							MessageBox("Advertencia!","No se pudo borrar las referencias de los trazos definidos.~n~n~nNota: " + ls_sqlerr)
							Destroy lds_trazo
							Return
						End If
	
						delete 
						  from h_trazos  
						 where co_trazo = :ll_tzdf ;
						  
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ; 
							MessageBox("Advertencia!","No se pudo borrar las referencias de los trazos definidos.~n~n~nNota: " + ls_sqlerr)
							Destroy lds_trazo
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

event ue_generar_oc();DataStore ids_trazo
Long ll_ordencorte,ll_i, li_trazo, li_agrupacion, ll_cs_unir_oc, ll_n,ll_liberacion
Long	li_pos_cortar, li_pos_inicial,li_return,sw_trazo,  li_ancho, li_cancelado
Long li_filas, li_talla, li_paquetes, li_respuesta, li_seguir, ll_talla_pt
String ls_body,ls_trazo, ls_cuentacorreo, ls_error, ls_mensaje_correo, ls_usuario
String ls_tipo_orden_toc, ls_valida_tipo_orden, ls_asunto, ls_mensaje
Dec ld_porc_diferencia
s_base_parametros lstr_parametros_retro
n_cts_constantes luo_constantes
n_cst_orden_corte luo_orden_corte
OLEObject lole_outlook,lole_item,lole_attach
DataStore lds_tallas_trazo, lds_usuarios_correo
uo_dsbase lds_ean_sku, lds_rollos_centro_sesgo, lds_trazos_x_oc, lds_trazos_modelo
uo_dsbase lds_log, lds_talla,lds_referencia, lds_trazos_paq_x_oc, lds_tallas_cant
//SA48797 E00387
n_utilidades_simulacion luo_utilidades_simulacion
n_cts_constantes_corte lpo_const_corte
s_base_parametros lstr_parametros
uo_correo	lnv_correo
n_cts_constantes luo_cts_constantes

luo_cts_constantes = Create n_cts_constantes

ls_usuario = gstr_info_usuario.codigo_usuario
li_cancelado = luo_cts_constantes.of_consultar_numerico("ESTADO ANULADA");

ld_porc_diferencia = luo_cts_constantes.of_consultar_decimal("PORC_DIF_PERMITIDA");


ids_trazo = Create DataStore
ids_trazo.DataObject = 'ds_trazos'
lds_tallas_trazo = Create DataStore
lds_tallas_trazo.DataObject = 'd_lista_talla_referencia_dt_tallasxtr_v2'
lds_tallas_trazo.SetTransObject(SQLCA)

lds_usuarios_correo = Create DataStore
lds_usuarios_correo.DataObject = 'dtb_lista_usuarios_correo'
lds_usuarios_correo.SetTransObject(SQLCA)

ids_trazo.SetTransObject(Sqlca)

lds_rollos_centro_sesgo = Create uo_dsbase
lds_rollos_centro_sesgo.DataObject = 'd_gr_rollos_centro_sesgos'
lds_rollos_centro_sesgo.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )
		
lds_trazos_x_oc = Create uo_dsbase
lds_trazos_x_oc.DataObject = 'd_gr_dt_trazos_x_oc'
lds_trazos_x_oc.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_trazos_modelo = Create uo_dsbase
lds_trazos_modelo.DataObject = 'd_gr_dt_trazos_x_oc'
lds_trazos_modelo.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )


lds_trazos_paq_x_oc = Create uo_dsbase
lds_trazos_paq_x_oc.DataObject = 'd_gr_dt_trazos_paq_x_oc'
lds_trazos_paq_x_oc.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_tallas_cant = Create uo_dsbase
lds_tallas_cant.DataObject = 'd_gr_tallas_cantidad'
lds_tallas_cant.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_log = Create uo_dsbase
lds_log.DataObject = 'd_gr_m_log_generar_oc'
lds_log.SetTransObject(SQLCA)

lds_talla = Create uo_dsbase
lds_talla.DataObject = 'd_gr_talla_pdnmodulo_x_lib'
lds_talla.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
lds_referencia = Create uo_dsbase
lds_referencia.DataObject = 'd_gr_dt_pdnxmodulo_x_lib'
lds_referencia.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
IF dw_oc.Rowcount() > 0 THEN
//IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_oc.GetItemNumber(1, "dt_pdnxmodulo_cs_asignacion")
	li_agrupacion = dw_oc.GetItemNumber(1, "cs_agrupacion")
	
	ll_liberacion = dw_oc.GetItemNumber(1, "dt_agrupa_pdn_cs_liberacion")
	
	ls_tipo_orden_toc = trim(dw_oc.GetItemString(1, "tipo_orden_toc"))
	ls_valida_tipo_orden = Trim(lpo_const_corte.of_consultar_texto('VALIDA TIPO ORDEN TOC'))
	
	//verificamos si existe rollos en centro corte sesgo(92)
	If lds_rollos_centro_sesgo.Of_Retrieve(ll_liberacion) <= 0 Then
		Rollback;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar si existen rollos en centro corte sesgos para la liberacion ' + String(ll_liberacion))
		Destroy lds_ean_sku;
		DESTROY ids_trazo;
		DESTROY lds_tallas_trazo;
		DESTROY lds_usuarios_correo;
		Return 
	End if
	
	//mira si tiene rollos
	If lds_rollos_centro_sesgo.GetItemNumber(1,'cantidad') > 0 Then
		//pregunta si va a continuar sin mover los rollos que existen en centro 92
		If MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Existen rollos en centro corte sesgos. $$HEX1$$bf00$$ENDHEX$$Desea continuar sin mover los rollos que existen en centro 92?",Question!,YesNo!,2) = 2 Then
			Rollback;
			Destroy lds_ean_sku;
			DESTROY ids_trazo;
			DESTROY lds_tallas_trazo;
			DESTROY lds_usuarios_correo;
			Return
		End IF
	End if
	
	DESTROY lds_rollos_centro_sesgo
//	li_lote = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_parcial")
//	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_lote_con")
//	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_destino")
//	li_planta = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta_destino")
//	li_tipocentropdn = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_version")


//verificar si la orden de corte es un duo para controlar que las unidades sean iguales
//jorodrig agosto  6 - 09
	ll_cs_unir_oc = luo_orden_corte.of_duo_conjunto(ll_ordencorte)
	IF ll_cs_unir_oc > 1 THEN
		IF luo_orden_corte.of_valida_unid_duo_prog(ll_cs_unir_oc) <= 0 THEN
			MessageBox("Advertencia...","No se Puede generar el proceso")
			DESTROY ids_trazo;
			DESTROY lds_tallas_trazo;
			DESTROY lds_usuarios_correo;
			
			Return
		END IF
	END IF
 //fin control duos y conjuntos
	

	IF Not IsNull(ll_ordencorte)  THEN
		//si valida ean
		lds_ean_sku = Create uo_dsbase
		lds_ean_sku.DataObject = 'd_gr_ean_x_orden_corte'
		lds_ean_sku.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )
		
		//verifica si el ean esta en blanco
		ll_n = lds_ean_sku.Of_Retrieve(ll_ordencorte)
		//si trae datos
		If ll_n > 0 Then
			ls_mensaje_correo = ''
			//recorre los registros y valida que el ean no esten en blanco
			For ll_n = 1 to lds_ean_sku.RowCount()
				//verifica si el ean esta en blanco
				IF Isnull(lds_ean_sku.GetItemString(ll_n,'barcode')) or Trim(lds_ean_sku.GetItemString(ll_n,'barcode')) = '' &
					 or Trim(lds_ean_sku.GetItemString(ll_n,'barcode')) = '0' Then
					ls_mensaje_correo = ls_mensaje_correo + 'Ref Vta ' + Trim(lds_ean_sku.GetItemString(ll_n,'co_referencia')) + &
											 ' - ' + Trim(lds_ean_sku.GetItemString(ll_n,'de_referencia')) + ' Talla ' + &
											 Trim(lds_ean_sku.GetItemString(ll_n,'co_talla')) + ' Color ' + &
											 Trim(lds_ean_sku.GetItemString(ll_n,'co_color')) + ' ' 
				End if
			Next
			
			//si hay ean en cero se envia correo
			If ls_mensaje_correo <> '' Then
				//completa mensaje para el correo
				ls_mensaje_correo = 'Los siguientes SKU de venta no se pueden programar porque no tienen el ean. Por favor Crear URGENTE los eanes. ' + ls_mensaje_correo
				
				//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 34 es el que pertenece a este proceso en la tabla m_usu_correo
				/*
				Declare pr_envia_correo Procedure For pr_envia_correo('NO SE PUEDE PROGRAMAR LA ORDEN DE CORTE', &
							:ls_mensaje_correo,34, :ls_usuario);
				Execute pr_envia_correo;
				If SQLCA.SQLCODE = -1 Then
					ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
					RollBack;
					MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Error enviando correo por ean en cero" + ls_error, StopSign!)
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se puede generar la OC porque el sku de venta que tiene asociado no tiene ean creado.')
					Close pr_envia_correo;
					Destroy lds_ean_sku;
					DESTROY ids_trazo;
					DESTROY lds_tallas_trazo;
					DESTROY lds_usuarios_correo;
					Return 
				End If
				// Cierra el procedimiento almacenado declarado
				Close pr_envia_correo;
				*/
				
				lnv_correo = CREATE uo_correo
				
				TRY
					lnv_correo.of_enviar_correo('NO SE PUEDE PROGRAMAR LA ORDEN DE CORTE', ls_mensaje_correo,'EAN_en_cero',ls_usuario)
				CATCH(Exception ex)
					Messagebox("Error", ex.getmessage())
				END TRY
				
				DESTROY lnv_correo 
				
				//si debe validar el ean, no continua con el proceso
				If cbx_1.Checked  Then
					RollBack;
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se puede generar la OC porque el sku de venta que tiene asociado no tiene ean creado.')
					Destroy lds_ean_sku;
					DESTROY ids_trazo;
					DESTROY lds_tallas_trazo;
					DESTROY lds_usuarios_correo;
					Return 
				End if
			End if
		ElseIf ll_n = 0 Then
			RollBack;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontraron datos para validar ean para el sku presente en la OC')
			Destroy lds_ean_sku;
			DESTROY ids_trazo;
			DESTROY lds_tallas_trazo;
			DESTROY lds_usuarios_correo;
			Return 
		Else
			Rollback;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar los eanes para el sku presente en la OC')
			Destroy lds_ean_sku;
			DESTROY ids_trazo;
			DESTROY lds_tallas_trazo;
			DESTROY lds_usuarios_correo;
			Return 
		End if
		
		Destroy lds_ean_sku;
			
		luo_constantes = Create n_cts_constantes
		ls_cuentacorreo = luo_constantes.of_consultar_texto("CUENTA CORREO")
		
		IF Len(ls_cuentacorreo) = 0 THEN
			MessageBox("Advertencia...","No se encontr$$HEX2$$f3002000$$ENDHEX$$la cuenta de correo")
			DESTROY ids_trazo;
			DESTROY lds_tallas_trazo;
			DESTROY lds_usuarios_correo;

			Return
		END IF
		
		Long ll_modelo_ant,li_base_trazos,li_cs_trazo,ll_find, ll_find1, ll_ca_programadas_t, ll_talla
		Long li_pdn, ll_modelo, ll_reftel, li_caract, ll_color_te,ll_co_trazo, ll_capas, ll_ca_paquetes
		Long ll_fabrica_pt, ll_co_linea, ll_referencia,ll_color_pt,ll_ca_programadas, li_agrupacion_ant, ll_color_te_ant
		Dec ld_mts_tot_nec, ld_mts_nec,ld_largo, ld_mts_mercar, ld_mts_rollo, ld_porc_dif, ld_porc_dif_max
		Dec ld_cm_cabe_abi, ld_cm_cabe_tub, ld_m_necesario
		
		ld_cm_cabe_abi = lpo_const_corte.of_consultar_numerico('CM_CABECERA_ABIERTA') / 100
		ld_cm_cabe_tub = lpo_const_corte.of_consultar_numerico('CM_CABECERA_TUBULAR') / 100
		
		 li_agrupacion_ant = 0
		 ll_modelo_ant = 0
		 ll_color_te_ant = 0
		 ld_mts_nec = 0
		 ld_mts_tot_nec = 0
		 ld_porc_dif_max = 0
		 
		 //consulta informacion incluyendo los paquetes para el calculo de los totales
		 lds_trazos_paq_x_oc.Retrieve( ll_ordencorte)

		lds_trazos_x_oc.Retrieve( ll_ordencorte)
		For ll_n = 1 to lds_trazos_x_oc.RowCount()
			 li_agrupacion = lds_trazos_x_oc.GetItemNumber(ll_n,'cs_agrupacion')
			 li_base_trazos = lds_trazos_x_oc.GetItemNumber(ll_n,'cs_base_trazos')
			 li_cs_trazo = lds_trazos_x_oc.GetItemNumber(ll_n,'cs_trazo')
			 li_pdn = lds_trazos_x_oc.GetItemNumber(ll_n,'cs_pdn')
			 ll_modelo = lds_trazos_x_oc.GetItemNumber(ll_n,'co_modelo')
			 ll_reftel = lds_trazos_x_oc.GetItemNumber(ll_n,'co_reftel')
			 li_caract = lds_trazos_x_oc.GetItemNumber(ll_n,'co_caract')
			 ll_color_te = lds_trazos_x_oc.GetItemNumber(ll_n,'co_color_te')
			 ll_co_trazo = lds_trazos_x_oc.GetItemNumber(ll_n,'co_trazo')
			 ll_capas = lds_trazos_x_oc.GetItemNumber(ll_n,'capas')
			 ld_largo = lds_trazos_x_oc.GetItemDecimal(ll_n,'largo')
			 ll_fabrica_pt = lds_trazos_x_oc.GetItemNumber(ll_n,'co_fabrica_pt')
			 ll_co_linea = lds_trazos_x_oc.GetItemNumber(ll_n,'co_linea')
			 ll_referencia = lds_trazos_x_oc.GetItemNumber(ll_n,'co_referencia')
			 ll_color_pt = lds_trazos_x_oc.GetItemNumber(ll_n,'co_color_pt')
			 			 
			//calculamos los metros necesarios segun los trazos
			IF li_caract = 4 THEN
			  ld_largo = ld_largo + ld_cm_cabe_tub;
			ELSE
			  ld_largo = ld_largo + ld_cm_cabe_abi;
			END IF
			
			IF li_agrupacion <> li_agrupacion_ant THEN
				li_agrupacion_ant = li_agrupacion
				ll_modelo_ant = 0
				ll_color_te_ant = 0
			End if
			
			IF ll_modelo <> ll_modelo_ant or  ll_color_te_ant <> ll_color_te  Then
				ll_modelo_ant = ll_modelo
				ll_color_te_ant = ll_color_te
				
				//si no es el primer registro
				If ll_n <> 1 Then
					//copia el registro
					lds_trazos_x_oc.RowsCopy(ll_n - 1, ll_n - 1, Primary!, lds_trazos_modelo, lds_trazos_modelo.RowCount() + 1, Primary!)
					//copia total
					lds_trazos_modelo.Setitem(lds_trazos_modelo.RowCount(),'total',ld_mts_tot_nec)
				End if
				
				//pone total en cero
				ld_mts_tot_nec = 0
			End if
			
			//calcula totales
			ld_mts_nec = ld_largo * ll_capas;
			ld_mts_tot_nec = ld_mts_tot_nec + ld_mts_nec;
			
		Next
		
		//copia el ultimo modelo
		If lds_trazos_x_oc.RowCount() > 0 Then
			//copia el registro
			lds_trazos_x_oc.RowsCopy(ll_n - 1, ll_n - 1, Primary!, lds_trazos_modelo, lds_trazos_modelo.RowCount() + 1, Primary!)
			//copia total
			lds_trazos_modelo.Setitem(lds_trazos_modelo.RowCount(),'total',ld_mts_tot_nec)
		End if
		
		li_agrupacion_ant = 0
		
		For ll_n = 1 to lds_trazos_modelo.RowCount()
			 li_agrupacion = lds_trazos_modelo.GetItemNumber(ll_n,'cs_agrupacion')
			 li_base_trazos = lds_trazos_modelo.GetItemNumber(ll_n,'cs_base_trazos')
			 li_cs_trazo = lds_trazos_modelo.GetItemNumber(ll_n,'cs_trazo')
			 li_pdn = lds_trazos_modelo.GetItemNumber(ll_n,'cs_pdn')
			 ll_modelo = lds_trazos_modelo.GetItemNumber(ll_n,'co_modelo')
			 ll_reftel = lds_trazos_modelo.GetItemNumber(ll_n,'co_reftel')
			 li_caract = lds_trazos_modelo.GetItemNumber(ll_n,'co_caract')
			 ll_color_te = lds_trazos_modelo.GetItemNumber(ll_n,'co_color_te')
			 ll_co_trazo = lds_trazos_modelo.GetItemNumber(ll_n,'co_trazo')
			 ll_capas = lds_trazos_modelo.GetItemNumber(ll_n,'capas')
			 ld_largo = lds_trazos_modelo.GetItemDecimal(ll_n,'largo')
			 ll_fabrica_pt = lds_trazos_modelo.GetItemNumber(ll_n,'co_fabrica_pt')
			 ll_co_linea = lds_trazos_modelo.GetItemNumber(ll_n,'co_linea')
			 ll_referencia = lds_trazos_modelo.GetItemNumber(ll_n,'co_referencia')
			 ll_color_pt = lds_trazos_modelo.GetItemNumber(ll_n,'co_color_pt')
			 ld_mts_tot_nec = lds_trazos_modelo.GetItemDecimal(ll_n,'total')
			 
			IF li_agrupacion <> li_agrupacion_ant THEN
				li_agrupacion_ant = li_agrupacion
				ld_porc_dif_max = 0
			End if

			 SELECT sum(a.ca_metros) , sum(m.ca_mt)
			  INTO :ld_mts_mercar, :ld_mts_rollo
			  FROM dt_rollos_libera a,dt_pdnxmodulo b,m_rollo m
			 WHERE a.co_fabrica_exp = b.co_fabrica_exp
				AND a.cs_liberacion = b.cs_liberacion
				AND a.nu_orden = b.po
				AND a.nu_cut = b.nu_cut
				AND a.co_fabrica_pt = b.co_fabrica_pt
				AND a.co_linea = b.co_linea
				AND a.co_referencia = b.co_referencia
				AND a.co_color_pt = b.co_color_pt
				AND a.cs_rollo = m.cs_rollo
				AND b.cs_asignacion = :ll_ordencorte
				AND a.co_modelo = :ll_modelo
				AND a.co_reftel =  :ll_reftel
				AND a.co_caract = :li_caract
				AND a.co_color_tela = :ll_color_te;
				
				//calcula el porcentaje de los metros necesarios permitidos
				ld_m_necesario = ld_mts_tot_nec * ld_porc_diferencia /100
							
				//si la diferencia entre los metros necesarios y los metros asignados
				//es mayor a lo permitido
				IF (ld_mts_tot_nec  >  ld_mts_mercar) and ld_m_necesario < (ld_mts_tot_nec - ld_mts_mercar) THEN
					ld_porc_dif = 100 - ((ld_mts_mercar  / ld_mts_tot_nec) * 100)
					
					ll_n = lds_log.InsertRow(0)
					lds_log.SetItem(ll_n,'cs_orden_corte',ll_ordencorte)
					lds_log.SetItem(ll_n,'cs_agrupacion',li_agrupacion)
					lds_log.SetItem(ll_n,'cs_trazo',li_cs_trazo)
					lds_log.SetItem(ll_n,'cs_pdn',li_pdn)
					lds_log.SetItem(ll_n,'co_modelo',ll_modelo)
					lds_log.SetItem(ll_n,'co_reftel',ll_reftel)
					lds_log.SetItem(ll_n,'co_caract',li_caract)
					lds_log.SetItem(ll_n,'co_color_te',ll_color_te)
					lds_log.SetItem(ll_n,'co_fabrica_pt',ll_fabrica_pt)
					lds_log.SetItem(ll_n,'co_linea',ll_co_linea)
					lds_log.SetItem(ll_n,'co_referencia',ll_referencia)
					lds_log.SetItem(ll_n,'co_color_pt',ll_color_pt)
					lds_log.SetItem(ll_n,'largo_trazos_tot',ld_mts_tot_nec)
					lds_log.SetItem(ll_n,'largo_mts_rollos',ld_mts_mercar)
					lds_log.SetItem(ll_n,'porcentaje',ld_porc_dif)
					lds_log.SetItem(ll_n,'opcion_seleccionada',0)
					lds_log.SetItem(ll_n,'porc_max',0)
					lds_log.SetItem(ll_n, "fe_actualizacion", DateTime(Today(), Now()))
					lds_log.SetItem(ll_n, "fe_creacion", DateTime(Today(), Now()))
					lds_log.SetItem(ll_n, "usuario", gstr_info_usuario.codigo_usuario)
					lds_log.SetItem(ll_n, "instancia", gstr_info_usuario.instancia)
						
						
					If ld_porc_dif_max < ld_porc_dif Then
						ld_porc_dif_max = ld_porc_dif
						//busca registro con porcentaje mayor
						ll_find = lds_log.Find('cs_agrupacion = ' + String(li_agrupacion) &
									+ ' and porc_max = 1',1, lds_log.RowCount() +1)
						//coloca porc max en cero
						If ll_find > 0 Then
							lds_log.SetItem(ll_find, "porc_max", 0)
						End if 
						//coloca porc max en uno al ultimo registro ingresado
						lds_log.SetItem(ll_n, "porc_max", 1)
					End if
					
				End if
		Next
		
		ll_find1 = lds_log.Find('porc_max = 1',1, lds_log.RowCount() +1)
		Do while ll_find1 > 0
			li_agrupacion = lds_log.GetItemNumber(ll_find1,'cs_agrupacion')
			li_cs_trazo = lds_log.GetItemNumber(ll_find1,'cs_trazo')
			li_pdn = lds_log.GetItemNumber(ll_find1,'cs_pdn')
			ll_modelo = lds_log.GetItemNumber(ll_find1,'co_modelo')
			ll_reftel = lds_log.GetItemNumber(ll_find1,'co_reftel')
			li_caract = lds_log.GetItemNumber(ll_find1,'co_caract')
			ll_color_te = lds_log.GetItemNumber(ll_find1,'co_color_te')
			ll_fabrica_pt = lds_log.GetItemNumber(ll_find1,'co_fabrica_pt')
			ll_co_linea = lds_log.GetItemNumber(ll_find1,'co_linea')
			ll_referencia = lds_log.GetItemNumber(ll_find1,'co_referencia')
			ll_color_pt = lds_log.GetItemNumber(ll_find1,'co_color_pt')
			ld_mts_tot_nec = lds_log.GetItemDecimal(ll_find1,'largo_trazos_tot')
			ld_mts_mercar = lds_log.GetItemDecimal(ll_find1,'largo_mts_rollos')
			ld_porc_dif = lds_log.GetItemDecimal(ll_find1,'porcentaje')
			
			ls_mensaje_correo ="Los metros mercados para la OC: " + String(ll_ordencorte) +  " modelo: " + String(ll_modelo) + " son inferiores a los necesarios para extender, mts necesarios: " + String(ld_mts_tot_nec)+ " mts a mercar: "+ String(ld_mts_mercar) + ", porcentaje a disminuir en capas: " +string(truncate(ld_porc_dif,0)) + '%'
			 
			lstr_parametros.cadena[1] = ls_mensaje_correo +", $$HEX1$$bf00$$ENDHEX$$que accion va a realizar?:"
			OpenWithParm(w_seleccionar_control_generar_oc, lstr_parametros)
			lstr_parametros = Message.PowerObjectParm
			IF lstr_parametros.hay_parametros THEN
				choose case lstr_parametros.entero[1]
				case 2 
					For ll_n = 1 to lds_log.RowCount()
						If li_agrupacion = lds_log.GetItemNumber(ll_n,'cs_agrupacion') Then
							lds_log.SetItem(ll_n,'opcion_seleccionada',2)
						End if
					Next
					
					IF lds_log.Update() = 1 THEN
						COMMIT;
						Return 
					ELSE
						ROLLBACK;
						MessageBox("Error Base Datos","Error al actualizar el log en la base de datos")
						Return
					END IF
										
					case 3 
						For ll_n = 1 to lds_log.RowCount()
							If li_agrupacion = lds_log.GetItemNumber(ll_n,'cs_agrupacion') Then
								lds_log.SetItem(ll_n,'opcion_seleccionada',3)
							End if
						Next
						
						IF lds_log.Update() = 1 THEN
							COMMIT;
						ELSE
							ROLLBACK;
							MessageBox("Error Base Datos","Error al actualizar el log en la base de datos")
							Return
						END IF
					
						ls_asunto = 'NO SE PUEDE PROGRAMAR LA ORDEN DE CORTE ' + String(ll_ordencorte)
						
						DECLARE pr_envia_correo_genera_oc PROCEDURE FOR
								  pr_envia_correo_genera_oc(:ls_asunto, :ls_mensaje_correo, :ll_ordencorte ) USING SQLCA; 
									
						EXECUTE pr_envia_correo_genera_oc ;
						 
						IF SQLCA.SQLCODE = -1 THEN 
							CLOSE pr_envia_correo_genera_oc;
							rollback;
							MessageBox("Error enviando correo ", SQLCA.sqlerrtext)
						ELSE
							CLOSE pr_envia_correo_genera_oc;
						END IF
					
						Return
					case 4 
						For ll_n = 1 to lds_log.RowCount()
							If li_agrupacion = lds_log.GetItemNumber(ll_n,'cs_agrupacion') Then
								lds_log.SetItem(ll_n,'opcion_seleccionada',4)
							End if
						Next
						
						update h_ordenes_corte
						set co_estado = 10, 
							fe_actualizacion = current,
							usuario = user
						where cs_orden_corte = :ll_ordencorte;
						
						IF SQLCA.SQLCode = -1 THEN
							Rollback;
							MessageBox("Error Base Datos","Error al actualizar orden corte. " + SQLCA.SQLErrText)
							Return 
						END IF
						
						UPDATE dt_pdnxmodulo
						SET co_estado_asigna = :li_cancelado,
							 fe_actualizacion = current,
							 usuario = user
						WHERE cs_asignacion = :ll_ordencorte and
						 0 < (select count(*)
							  FROM dt_rollos_libera a
							 WHERE a.co_fabrica_exp = dt_pdnxmodulo.co_fabrica_exp
								AND a.cs_liberacion = dt_pdnxmodulo.cs_liberacion
								AND a.nu_orden = dt_pdnxmodulo.po
								AND a.nu_cut = dt_pdnxmodulo.nu_cut
								AND a.co_fabrica_pt = dt_pdnxmodulo.co_fabrica_pt
								AND a.co_linea = dt_pdnxmodulo.co_linea
								AND a.co_referencia = dt_pdnxmodulo.co_referencia
								AND a.co_color_pt = dt_pdnxmodulo.co_color_pt
								AND a.co_modelo = :ll_modelo
								AND a.co_reftel =  :ll_reftel
								AND a.co_caract = :li_caract
								AND a.co_color_tela = :ll_color_te);
								
						IF SQLCA.SQLCode = -1 THEN
							Rollback;
							MessageBox("Error Base Datos","Error al actualizar produccion por modulo. " + SQLCA.SQLErrText)
							Return 
						END IF
								
						IF lds_log.Update() = 1 THEN
							COMMIT;
						ELSE
							ROLLBACK;
							MessageBox("Error Base Datos","Error al actualizar el log en la base de datos")
							Return
						END IF
						 
						//trae informacion de tallas
						ll_n = lds_talla.Retrieve( ll_liberacion)
						If ll_n < 0 Then
							Rollback;
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informacion de tallas. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
							Return 
						ElseIf ll_n = 0 Then
							Rollback;
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informacion de tallas para la liberacion. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
							Return 
						End if
						
						//mira si tiene mas de una talla
						If ll_n > 1 Then
							ll_talla_pt = 9999
						Else
							ll_talla_pt = lds_talla.GetItemNumber(1,'co_talla')
						End if
						
						//trae informacion de referencia
						ll_n = lds_referencia.Retrieve(ll_liberacion)
						If ll_n < 0 Then
							Rollback;
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informacion de produccion. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
							Return 
						ElseIf ll_n = 0 Then
							Rollback;
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informacion de produccion. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
							Return 
						End if
							
						lstr_parametros.entero[1]  = lds_referencia.GetItemNumber(1,'co_fabrica_pt')
						lstr_parametros.entero[2]  = lds_referencia.GetItemNumber(1,'co_linea')
						lstr_parametros.entero[3]  = lds_referencia.GetItemNumber(1,'co_referencia')
						lstr_parametros.entero[4]  = lds_referencia.GetItemNumber(1,'co_color_pt')
						lstr_parametros.entero[5]  = 0
						lstr_parametros.entero[6]  = 0
						lstr_parametros.entero[7]  = ll_talla_pt
						lstr_parametros.entero[8]  = lds_referencia.GetItemNumber(1,'cs_ordenpd_pt')
						lstr_parametros.entero[9]  = lds_referencia.GetItemNumber(1,'co_linea_exp')
						lstr_parametros.entero[10] = lds_referencia.GetItemNumber(1,'co_fabrica_exp')
						lstr_parametros.cadena[1]  = lds_referencia.GetItemString(1,'co_ref_exp')
						lstr_parametros.cadena[2]  = lds_referencia.GetItemString(1,'co_color_exp')
						lstr_parametros.entero[11] = 1 //opcion_liberar: 1 = equilibrar, 2 = igualar
						lstr_parametros.entero[12] = lds_referencia.GetItemNumber(1,'cs_unir_oc')
						
						OpenSheetWithParm(w_existencias_tela_critica, lstr_parametros, W_PRINCIPAL,0,Original!)

						Return
						
					Case 1
						For ll_n = 1 to lds_log.RowCount()
							If li_agrupacion = lds_log.GetItemNumber(ll_n,'cs_agrupacion') Then
								lds_log.SetItem(ll_n,'opcion_seleccionada',1)
							End if
						Next
						IF lds_log.Update() < 0 THEN
							ROLLBACK;
							MessageBox("Error Base Datos","Error al actualizar el log en la base de datos")
							Return
						END IF
						
						UPDATE dt_trazosxbase
						SET ca_programadas = ca_paquetes * round(capas - (capas * :ld_porc_dif)/100,0),
							 capas = round(capas - (capas * :ld_porc_dif)/100,0),
							 fe_actualizacion = current,
							 usuario = user
						WHERE cs_agrupacion = :li_agrupacion and
								cs_orden_corte = :ll_ordencorte and
								capas > 1;
								
						IF SQLCA.SQLCode = -1 THEN
							Rollback;
							MessageBox("Error Base Datos","Error al actualizar trazos. " + SQLCA.SQLErrText)
							Return 
						END IF
								
						
						lds_trazos_paq_x_oc.SetFilter('cs_agrupacion = ' + String(li_agrupacion))
						lds_trazos_paq_x_oc.Filter()
						
						ll_ca_programadas_t = 0
						lds_tallas_cant.Reset()
						For ll_n = 1 to lds_trazos_paq_x_oc.RowCount()
							ll_talla = lds_trazos_paq_x_oc.GetItemNumber(ll_n,'co_talla')
			 				ll_capas = lds_trazos_paq_x_oc.GetItemNumber(ll_n,'capas')
							ll_ca_paquetes = lds_trazos_paq_x_oc.GetItemNumber(ll_n,'ca_paquetes')
							 
							//toma la programada
							If ll_capas = 1 Then 
								ll_ca_programadas = ll_ca_paquetes * ll_capas
							Else
								ll_ca_programadas = ll_ca_paquetes * round(ll_capas - (ll_capas * ld_porc_dif)/100,0)
							End if
							//acumula total
							ll_ca_programadas_t = ll_ca_programadas_t + ll_ca_programadas
							
							//busca talla
							ll_find = lds_tallas_cant.find('co_talla = '+string(ll_talla),1,lds_tallas_cant.RowCount() +1)
							If ll_find > 0 Then
								lds_tallas_cant.Setitem(ll_find,'cantidad',lds_tallas_cant.GetItemNumber(ll_find,'cantidad') + ll_ca_programadas)
							Else
								ll_find = lds_tallas_cant.InsertRow(0)
								lds_tallas_cant.Setitem(ll_find,'co_talla',ll_talla)
								lds_tallas_cant.Setitem(ll_find,'cantidad',ll_ca_programadas)
							End if
						Next
						
						UPDATE dt_pdnxmodulo
						SET ca_programada = :ll_ca_programadas_t,
							 fe_actualizacion = current,
							 usuario = user
						WHERE cs_asignacion = :ll_ordencorte and
							co_fabrica_pt = :ll_fabrica_pt and
							co_linea = :ll_co_linea and
							co_referencia = :ll_referencia and
							co_color_pt = :ll_color_pt and
							 0 < (select count(*)
								  FROM dt_rollos_libera a
								 WHERE a.co_fabrica_exp = dt_pdnxmodulo.co_fabrica_exp
									AND a.cs_liberacion = dt_pdnxmodulo.cs_liberacion
									AND a.nu_orden = dt_pdnxmodulo.po
									AND a.nu_cut = dt_pdnxmodulo.nu_cut
									AND a.co_fabrica_pt = dt_pdnxmodulo.co_fabrica_pt
									AND a.co_linea = dt_pdnxmodulo.co_linea
									AND a.co_referencia = dt_pdnxmodulo.co_referencia
									AND a.co_color_pt = dt_pdnxmodulo.co_color_pt
									AND a.co_modelo = :ll_modelo
									AND a.co_reftel =  :ll_reftel
									AND a.co_caract = :li_caract
									AND a.co_color_tela = :ll_color_te);
									
						IF SQLCA.SQLCode = -1 THEN
							Rollback;
							MessageBox("Error Base Datos","Error al actualizar produccion por modulo. " + SQLCA.SQLErrText)
							Return 
						END IF
						
						For ll_n = 1 to lds_tallas_cant.RowCount()
							ll_talla = lds_tallas_cant.GetItemNumber(ll_n,'co_talla')
			 				ll_ca_paquetes = lds_tallas_cant.GetItemNumber(ll_n,'cantidad')
							
							UPDATE dt_agrupaescalapdn
							SET ca_unidades = :ll_ca_paquetes,
								 fe_actualizacion = current,
								 usuario = user
							WHERE cs_agrupacion = :li_agrupacion and
									cs_pdn = :li_pdn and
									co_talla = :ll_talla
									;
									
							IF SQLCA.SQLCode = -1 THEN
								Rollback;
								MessageBox("Error Base Datos","Error al actualizar agrupaci$$HEX1$$f300$$ENDHEX$$n. " + SQLCA.SQLErrText)
								Return 
							END IF
						Next
						
						Commit;
						 
					Case 5
						For ll_n = 1 to lds_log.RowCount()
							If li_agrupacion = lds_log.GetItemNumber(ll_n,'cs_agrupacion') Then
								lds_log.SetItem(ll_n,'opcion_seleccionada',5)
								lds_log.SetItem(ll_n,'observacion',lstr_parametros.cadena[1])
							End if
						Next
						IF lds_log.Update() < 0 THEN
							ROLLBACK;
							MessageBox("Error Base Datos","Error al actualizar el log en la base de datos")
							Return
						END IF
						Commit;
						
					End choose
					
					ld_mts_tot_nec = 0
				Else
					Return
				End if
			
			//busca el siguiente
			ll_find1 = lds_log.Find('porc_max = 1', ll_find1 + 1, lds_log.RowCount() +1)
		Loop

		
		lstr_parametros_retro.cadena[1]="Procesando ..."
		lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
		lstr_parametros_retro.cadena[3]="reloj"
				
		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)		

		DECLARE loteo PROCEDURE FOR
			pr_generar_ordencr(:ll_ordencorte,:gstr_info_usuario.co_planta_pro);
		EXECUTE loteo;
		IF SQLCA.SQLCode = -1 THEN	
			IF SQLCA.SQLDBCode = -746 THEN
				ls_error = SQLCA.SQLErrText
				ROLLBACK;
				CLOSE(w_retroalimentacion)
				MessageBox("Error Base Datos",ls_error)
				DESTROY ids_trazo;
				DESTROY lds_tallas_trazo;
				DESTROY lds_usuarios_correo;

				Return
				//MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
			ELSE
				ls_error = SQLCA.SQLErrText
				ROLLBACK;
				CLOSE(w_retroalimentacion)
				MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_generar_ordencr. " +ls_error)
				Return
			END IF
			//ROLLBACK;
		ELSE
			
				//SA48797 E00387
				//Actualizar barras proyectadas de la orden corte
				Try
					//actualice las barras de las ordenes proyectadas	
					If luo_utilidades_simulacion.of_actualizar_barras_simulacion(ll_ordencorte) > 0 Then 
						//cree las barras de la orden real
						luo_utilidades_simulacion.of_crear_barra_ordencorte(ll_ordencorte)
					End if
				Catch(Exception le_error)
					ROLLBACK;
					CLOSE(w_retroalimentacion)
					MessageBox("Error",le_error.getMessage(),StopSign! )
					Return
				End try
				//para evitar bloqueo se termina la transaccion, si se desea devolver el proceso
				//se devuelve la orden de corte
				
				IF of_validacion_temporal_kg_rollos(ll_ordencorte) = -1 THEN
					ROLLBACK;
					CLOSE(w_retroalimentacion)
					MessageBox("Error","Validacion para evitar que los rollos no se dejen partir,  no se gener$$HEX2$$f3002000$$ENDHEX$$la orden de corte, informe a sistemas " )
					Return
				END IF
				
				COMMIT;	

				//se valida que la orden de corte si tenga todos sus modelos con trazo asignado
				//esto se hace para que no se genere mercada con rayas sin trazo lo que 
				//ocasiona problemas que despues solo se pueden corregir devolviendo la 
				//orden de corte y generando el trazo de los modelos faltantes
				//jcrm
				//marzo 4 de 2008
				//esto se hace a peticion de Fredy Serna (Texografo)
				li_respuesta = of_validarTrazosModelo(ll_ordencorte)
				IF li_respuesta = -1 THEN
					//MessageBox('Error','Orden incompleta.',StopSign!)
					li_seguir = MessageBox("Error",'No todos los modelos tienen trazo asignado, desea continuar con el proceso.' , Exclamation!, OKCancel!, 2)
					IF li_seguir = 2 THEN
						IF of_devolver_orden(ll_ordencorte) = 0 THEN
							Commit;
							MessageBox("Devoluci$$HEX1$$f300$$ENDHEX$$n","Proceso de Generacion Devuelto")
						ELSE
							Rollback;
							MessageBox("Devoluci$$HEX1$$f300$$ENDHEX$$n","Fallo el proceso de devolucion, la orden quedo generada")
							Return
						END IF

						
						
					END IF
				END IF
			
		//revisar si la variable tipo_orden_toc = MTO 
		If ls_tipo_orden_toc = ls_valida_tipo_orden Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Recuerde ingresar el % de liberaci$$HEX1$$f300$$ENDHEX$$n en la orden de corte.')
		End if

		END IF
		//This.TriggerEvent("ue_buscar")			
		CLOSE(w_retroalimentacion)
	ELSE
		MessageBox("Advertencia","Debe seleccionar una orden")
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
		OpenSheetWithParm(w_crear_ordenes_sin_busqueda, lstr_parametros, w_trazos_x_session_version2, 0, Layered!)		
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
		OpenSheetWithParm(w_reporte_orden_corte_sin_busqueda, lstr_parametros, w_trazos_x_session_version2, 0, Layered!)		
	ELSE
		MessageBox('Advertencia','La orden de corte que desea imprimir aun no ha sido generada, por favor verifique')
	END IF
ELSE
	MessageBox('Advertencia','No ha sido seleccionada ninguna orden de corte, por favor verifique')
END IF
end event

event ue_observacion();//llama ventana de oc
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
		OpenSheetWithParm(w_observacion_corte,lstr_parametros,w_trazos_x_session_version2,1, Original!)			
	ELSE
		MessageBox('Adveretencia','No es posible ingresar observaciones a una orden de corte sin haber sido generada con anterioridad, por favor revise sus datos e intente nuevamente.')
	END IF
ELSE
	MessageBox('Adveretencia','No ha sido seleccionada ninguna orden de corte, revise sus datos e intente nuevamente')
END IF

end event

event ue_devolver_oc();Long ll_ordencorte
Long li_estado
Long	li_pos_cortar, li_pos_inicial
String ls_error, ls_password,ls_password_ingresado
boolean ib_grabar
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte

//mensage de utilizacion del trazo, no debe ser usado sin autorizaci$$HEX1$$f300$$ENDHEX$$n superior.
MessageBox('Advertencia','Solo personal autorizado puede devolver ordenes de corte, ingrese la contrase$$HEX1$$f100$$ENDHEX$$a.')
//IF gstr_info_usuario.codigo_usuario = 'ljgarcia' THEN
	ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO'))
//ELSE
//	ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO NICOLE'))      
//END IF
//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n

IF gstr_info_usuario.codigo_usuario = 'fasernap' THEN
ELSE
	Open(w_password_trazos)
	lstr_parametros = message.PowerObjectParm
	
	If lstr_parametros.hay_parametros = true Then
		ls_password_ingresado = Trim(lstr_parametros.cadena[1])
					
		If ls_password_ingresado = ls_password Then
		Else
			MessageBox('Error','Password, no valido.')
			ib_grabar = False
			Return 
		End if
	Else
		ib_grabar = False
		Return 
	End if
END IF


IF dw_oc.Rowcount() > 0 THEN

	ll_ordencorte = dw_oc.GetItemNumber(1, "dt_pdnxmodulo_cs_asignacion")
	
	IF of_devolver_orden(ll_ordencorte) = 0 THEN
		Commit;
		MessageBox("Devoluci$$HEX1$$f300$$ENDHEX$$n","Orden de corte devuelta")
	ELSE
		Return
	END IF

//	pr_devlotgoc
	
		
//		lstr_parametros_retro.cadena[1]="Procesando ..."
//		lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
//		lstr_parametros_retro.cadena[3]="reloj"
		
		
//		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)			
//		DECLARE loteo PROCEDURE FOR
//			pr_devlotgoc(:ll_ordencorte);
//		EXECUTE loteo;
//		IF SQLCA.SQLCode = -1 THEN			
//			IF SQLCA.SQLDBCode = -746 THEN
//				li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
//				li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
//				MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
//			ELSE
//				MessageBox("Error Base Datos","Error al devolver loteo programado")
//			END IF
//			ROLLBACK;
//			
//			
//		ELSE
//		end if
	
ELSE
	MessageBox('Advertencia','No sea seleccionado ninguna orden de corte para devolver')
	Return
	
END IF
end event

event ue_pendientes();s_base_parametros lstr_parametros
Long li_estado_agrupa, ll_count

//Opensheet(w_reportes_ordenes_pendientes_programar,w_principal,0,layered!)
/*Open(w_pendientes_x_programar)

lstr_parametros = Message.PowerObjectParm

IF lstr_parametros.cadena[1] = 'S' THEN
	
	
	dw_pdn_talla.Reset()
	dw_trazo.Reset()
	dw_produccion.Reset()
	dw_oc.Reset()
	dw_seccion.Reset()
	
	il_orden = lstr_parametros.entero[1]
	il_agrupa = of_agrupacion(il_orden, li_estado_agrupa)
	
	IF li_estado_agrupa = 2 THEN
		of_buscar()
	ELSE
		Return
	END IF
END IF*/


//mira si la orden de corte ya esta preliquidada 
select count(*) into :ll_count
from dt_liq_unixespacio
where cs_orden_corte = :il_orden;

If ll_count = 0 Then
	//abre ventana para seleccionar tipo de impresion
	lstr_parametros.hay_parametros = True
	lstr_parametros.entero[1] = il_orden
	OpenWithParm(w_tipo_oc,lstr_parametros,w_principal)
End if
end event

event ue_trazo_balanceo();Long ll_fila, ll_trazo, ll_j, ll_sum, ll_capa, ll_paquetes, ll_totcapas



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
		ll_totcapas = ll_totcapas + ll_sum
	NEXT
	dw_pdn_talla.SetItem(il_numpdn + 1,"talla" + String(il_numtalla + 2),ll_totcapas)
End If

//of_calcapas()

end event

event ue_habilitar_recalculo();Long li_registros, li_aprobada, li_generada
Long ll_result
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes
li_aprobada = luo_constantes.of_consultar_numerico("LIBERACION APROBADA")
IF li_aprobada = -1 THEN
	Return
END IF

ll_result = of_verificar_estado(il_orden) 
If ll_result = 0 THEN

	SELECT Count(*)
	INTO :li_registros
	FROM dt_agrupa_pdn, dt_pdnxmodulo
	WHERE dt_agrupa_pdn.cs_agrupacion = :il_agrupa AND
			dt_agrupa_pdn.co_fabrica_exp = dt_pdnxmodulo.co_fabrica_exp AND
			dt_agrupa_pdn.cs_liberacion = dt_pdnxmodulo.cs_liberacion AND
			dt_agrupa_pdn.po = dt_pdnxmodulo.po AND
			dt_agrupa_pdn.nu_cut = dt_pdnxmodulo.nu_cut AND
			dt_agrupa_pdn.co_fabrica_pt = dt_pdnxmodulo.co_fabrica_pt AND
			dt_agrupa_pdn.co_linea = dt_pdnxmodulo.co_linea AND
			dt_agrupa_pdn.co_referencia = dt_pdnxmodulo.co_referencia AND
			dt_agrupa_pdn.co_color_pt = dt_pdnxmodulo.co_color_pt AND
			dt_pdnxmodulo.co_estado_asigna <> :li_aprobada;
			
	IF li_registros > 0 THEN
		MessageBox("Advertencia...","Tiene trazos programados, debe borrarlos primero")
		Return
	END IF
	
	li_generada = luo_constantes.of_consultar_numerico("AGRUPACION GENERADA")
	IF li_generada = -1 THEN
		Return
	END IF

	UPDATE h_agrupa_pdn
	SET	co_estado = 1,
			fe_actualizacion = Current,
			usuario = User,
			instancia = SiteName
	WHERE cs_agrupacion = :il_agrupa;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al actualizar el estado de la agrupaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
		ROLLBACK;
	ELSE
		DELETE FROM dt_trazosrecalculo
		WHERE cs_agrupacion = :il_agrupa;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al borrar los trazos definidos " + SQLCA.SQLErrText)
			ROLLBACK;
		ELSE		
			MessageBox("Habilitada","Agrupaci$$HEX1$$f300$$ENDHEX$$n habilitada")
			COMMIT;
			This.TriggerEvent("ue_buscar")
		END IF
	END IF
END IF
end event

public subroutine of_consumos (long an_agrupacion, long an_basetrazo, long an_espacio, long an_seccion);
end subroutine

public function long of_buscar ();Long ll_result

ll_result = dw_trazo.Retrieve(il_agrupa, il_orden)
	
If ll_result <= 0 Then
	MessageBox("Advertencia!","Hubo errores al recuperar la producci$$HEX1$$f300$$ENDHEX$$n.")
	dw_trazo.Reset()
	dw_produccion.Reset()
	Return -1
Else
	//This.Title = "Secciones por Trazos :=: N$$HEX1$$fa00$$ENDHEX$$mero Orden " + String(il_orden) + " Agrupaci$$HEX1$$f300$$ENDHEX$$n:" + String (il_agrupa)
End If

dw_oc.Retrieve (il_agrupa, ii_fabrica, ii_planta)

This.Title = "Secciones por Trazos :=: N$$HEX1$$fa00$$ENDHEX$$mero Orden " + String(il_orden) + " Agrupaci$$HEX1$$f300$$ENDHEX$$n:" + String (il_agrupa)

Return 0
end function

public function long of_calcapas ();Long  li_i,li_j
Long ll_cant,ll_capa,ll_nmtlla,ll_mncp,ll_raya,ll_fila, ll_totalcapas

ll_fila = dw_trazo.GetRow()
ll_raya = dw_trazo.GetItemNumber(ll_fila,'raya')

dw_pdn_talla.AcceptText()

ll_totalcapas = 0

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
	ll_totalcapas = ll_totalcapas + ll_mncp
Next
dw_pdn_talla.SetItem(il_numpdn + 1,"talla" + String(il_numtalla + 2), ll_totalcapas)
Return 0


end function

public function long of_devolver_orden (long al_ordencorte);Long li_estado, li_estado_mercada, li_anulada
Long li_pormercar, li_porcortar, li_registros, li_cortado
Long ll_rollo, ll_ordennueva, ll_mercada
n_cts_constantes luo_constantes
DataStore lds_rollosmercada

select co_estado
into :li_estado
from h_ordenes_corte
where cs_orden_corte = :al_ordencorte;
	
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurrio un error al momento de consultar la orden de corte')
	Return -1
END IF

luo_constantes = Create n_cts_constantes

li_porcortar = luo_constantes.of_consultar_numerico("ESTADO X CORTAR")
IF li_porcortar = -1 THEN
	Return -1
END IF

li_pormercar = luo_constantes.of_consultar_numerico("ESTADO X MERCAR")
IF li_pormercar = -1 THEN
	Return -1
END IF

li_anulada = luo_constantes.of_consultar_numerico("MERCADA ANULADA")
IF li_anulada = -1 THEN
	Return -1
END IF

IF li_estado = 1 OR li_estado = 2 THEN
	
	SELECT Max(co_estado_mercada)
	INTO :li_estado_mercada
	FROM h_mercada
	WHERE cs_orden_corte = :al_ordencorte;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al consultar el estado de la mercada")
		Return -1
	ELSE
		IF SQLCA.SQLCode = 0 THEN
			IF li_estado_mercada <> li_porcortar AND li_estado_mercada <> li_pormercar THEN
				MessageBox("Error","El estado de la mercada, hace que no sea posible devolverla.")
				Return -1
			END IF			
		END IF
	END IF
	
	lds_rollosmercada = Create DataStore
	
	lds_rollosmercada.DataObject = 'dgr_rollos_mercada_devoc'
	
	IF lds_rollosmercada.SetTransObject(SQLCA) = -1 THEN
		MessageBox("Error DataStore","Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n")
		Return -1
	END IF
	
	lds_rollosmercada.Retrieve(al_ordencorte, li_anulada)
	
	FOR li_registros = 1 TO lds_rollosmercada.RowCount()
		ll_rollo = lds_rollosmercada.GetItemNumber(li_registros, 'cs_rollo')
		
		SELECT Min(cs_orden_corte)
		INTO :ll_ordennueva
		FROM dt_rollosmercada, h_mercada
		WHERE dt_rollosmercada.cs_rollo = :ll_rollo AND
				dt_rollosmercada.co_estado_mercada < :li_cortado AND
				dt_rollosmercada.cs_mercada = h_mercada.cs_mercada AND
				h_mercada.cs_orden_corte <> :al_ordencorte;
						  
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al validar si el rollo est$$HEX2$$e1002000$$ENDHEX$$asignado a otra mercada " + SQLCA.SQLErrText)
			Return -1
		END IF
		IF IsNull(ll_ordennueva) THEN
			ll_ordennueva = 0
		END IF
		UPDATE m_rollo
		SET	cs_ordencr = :ll_ordennueva,
				fe_actualizacion = Current,
				usuario = User,
				instancia = SiteName
		WHERE cs_rollo = :ll_rollo;
		
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al actualizar la orden de corte de los rollos " + SQLCA.SQLErrText)
			Return -1
		END IF
	NEXT
	
	//antes de eliminar los datos de la mercada debo saber la mercada para borrar los datos
	//de los rollos a partir
	select cs_mercada
	  into :ll_mercada
	  from h_mercada
	 where cs_orden_corte = :al_ordencorte;
	 
	delete from temp_rollos_partir
	where cs_mercada = :ll_mercada
	  and proceso = 4;
	
	IF SQLCA.SQLCode = -1 THEN
		Rollback;
		MessageBox("Error Base Datos","Error al borrar los rollos a partir " + SQLCA.SQLErrText)
		Return -1
	END IF
		
	delete from dt_rollosmercada
	where cs_mercada in (	select cs_mercada
									from h_mercada
									where cs_orden_corte = :al_ordencorte);
									
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al borrar los rollos de la mercada " + SQLCA.SQLErrText)
		Return -1
	END IF
	
	delete from h_mercada
	where cs_orden_corte = :al_ordencorte;
	
	IF SQLCA.SQLCode = -1 THEN
		Rollback;
		MessageBox("Error Base Datos","Error al borrar la mercada " + SQLCA.SQLErrText)
		Return -1
	END IF
	
	delete from dt_observa_oc
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_observa_oc')
		
		Return -1
	END IF
	
	delete from dt_partes_kamban
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_partes_kamban')
		Return -1
	END IF		
	
	delete from dt_kamban_corte
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_kamban_corte ' + SQLCA.SQLErrText)
		Return -1
	END IF	
	
	delete from dt_lectura_bolsas
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox("Error","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar en dt_lectura_bolsas")
		Return -1
	END IF	
	
	delete from dt_partes_ordencr
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox("Error","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar en dt_partes_ordencr")
		Return -1
	END IF		
		
//	delete from dt_letraxpaquete 
//	where cs_orden_corte = :al_ordencorte;
//	
//	IF sqlca.sqlcode = -1 THEN
//		MessageBox('Error','Ocurrio un error al momento de borrar en dt_unidadesxtrazo')
//		Rollback;
//		Return -1
//	END IF	
		
	delete from dt_unidadesxtrazo 
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_unidadesxtrazo')
		Return -1
	END IF
	
	delete from dt_trazosxoc  
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_trazosxoc')
		Return -1
	END IF
	
	delete from dt_rayas_telaxoc
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_rayas_telaxoc')
		Return -1
	END IF
	
	delete from dt_escalasxoc 
	where cs_orden_corte = :al_ordencorte ;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_escalasxoc')
		Return -1
	END IF
	
	delete from dt_total_ordcr
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en dt_total_ordcr')
		Return -1
	END IF
	
	delete from h_ordenes_corte 
	where cs_orden_corte = :al_ordencorte;
	
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de borrar en h_ordenes_corte')
		Return -1
	END IF
	
	//el campo tipo_fe_prog se empieza a actualizar el 8 - 06 -2011 para identificar las ordenes que se anulan despues
	//de generarse, esto para ver si es por hay donde se pueden quedar rollos en bodega que ya estan programados y liquidados
	//el caso de la oc 450733 y 450734 realiza jorodrig 
	update dt_pdnxmodulo set (co_estado_asigna,indicativo_base, tipo_fe_prog) = (7, 0, 28)  
		where simulacion=1
		and   co_fabrica=:ii_fabrica
		and   co_planta=:ii_planta
		and   cs_asignacion=:al_ordencorte;
	IF sqlca.sqlcode = -1 THEN
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de actualizar el programa de corte')
		Return -1
	END IF
	
	
ELSE
	MessageBox('Error','El estado de la orden de corte, hace que no sea posible devolverla.')
	Return -1
END IF

Return 0
end function

public function long of_cuadro (long an_fila);DataStore lds_tallas,lds_cant,lds_trazob
Long    ll_i,li_swv,li_talla,li_j, li_fabricapt, li_raya
Long   ll_pdn,ll_pdnant,ll_fila,ll_cant,ll_total,ll_flfn,ll_ctpg,ll_trazo,&
       ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color,ll_rslt
String ls_title,ls_tag, ls_condicion,ls_talla

Long		li_co_fabrica_exp,li_cs_liberacion,li_co_linea
Long		li_cs_paticion
LONG			ll_co_referencia,ll_co_color_pt,ll_co_color_te
STRING		ls_po,ls_de_referencia,ls_tono,ls_de_color_1, ls_cut
DECIMAL		ld_ancho_cortable
Decimal{2}	ld_yield

st_ltz.Text  = ''
st_lsec.Text = ''
st_aprobado.Text = ''
st_trazo.Text = ''
st_total.Text = ''

cbx_retazo.Checked = False

ll_trazo  = dw_trazo.GetItemNumber(an_fila,'cs_base_trazos')
li_raya = dw_trazo.GetItemNumber(an_fila, 'raya')
ll_fab = dw_trazo.GetItemNumber(an_fila, 'co_fabrica_te')
ll_ref = dw_trazo.GetItemNumber(an_fila, 'co_reftel')
ll_carac = dw_trazo.GetItemNumber(an_fila, 'co_caract')
ll_diamt = dw_trazo.GetItemNumber(an_fila, 'diametro')

dw_pdn_talla.Reset()
dw_seccion.Retrieve(il_agrupa, ll_trazo, ll_fab, ll_ref, ll_carac, ll_diamt)
dw_seccion.Sort()

lds_tallas = Create DataStore
lds_cant   = Create DataStore
lds_trazob = Create DataStore 

lds_tallas.DataObject = 'd_distintas_tallas_trazos_produccion_v2'
lds_cant.DataObject   = 'd_lista_trazo_cantidad_talla_x_pdn_v2'
lds_trazob.DataObject = 'd_cantidad_trazos_produccion_v2'

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
		//ls_title = String(lds_tallas.GetItemString(ll_i,'de_talla'))
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


ll_rslt = lds_cant.Retrieve(il_agrupa, ll_trazo, ll_fab, ll_ref, ll_carac, ll_diamt)
lds_trazob.Retrieve(il_agrupa, ll_trazo, ll_fab, ll_ref, ll_carac, ll_diamt)

If ll_rslt > 0 Then
	ll_pdnant = lds_cant.GetItemNumber(1,'cs_pdn')
	ll_total  = 0
	il_numpdn = 1
	
	For ll_i = 1 To lds_cant.RowCount()
	
		ll_pdn    = lds_cant.GetItemNumber(ll_i,'cs_pdn')
		li_talla  = lds_cant.GetItemNumber(ll_i,'co_talla')
		ll_cant   = lds_cant.GetItemNumber(ll_i,'ca_unidades')
		ll_color	 = lds_cant.GetItemNumber(ll_i, 'co_color_te')
		//ls_talla  = lds_cant.GetItemString(ll_i,'de_talla')
		
//		ls_condicion = "co_modelo = " + String(ll_modelo) + " and co_fabrica_te = "+ String(ll_fab) + &
//							" and co_reftel = " + String(ll_ref) + " and co_caract = " + String(ll_carac) + &
//							" and diametro = " + String(ll_diamt) + " and co_color_te = " + String(ll_color) + &
//							" and cs_pdn = " + String(ll_pdn) + " and co_talla = " + String(li_talla)

		ls_condicion = "co_color_te = " + String(ll_color) + &
							" and cs_pdn = " + String(ll_pdn) + " and co_talla = " + String(li_talla)
		
		ll_flfn = lds_trazob.Find(ls_condicion,1,lds_trazob.RowCount()) 
		
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

		li_co_fabrica_exp			=lds_cant.GetItemNumber(ll_i,'co_fabrica_exp')
		li_cs_liberacion			=lds_cant.GetItemNumber(ll_i,'cs_liberacion')
		ls_po							=Trim(lds_cant.GetItemString(ll_i,'po'))
		ls_cut						=Trim(lds_cant.GetItemString(ll_i,'nu_cut'))		
		li_fabricapt				=lds_cant.GetItemNumber(ll_i,'co_fabrica_pt')
		li_co_linea					=lds_cant.GetItemNumber(ll_i,'co_linea')
		ll_co_referencia			=lds_cant.GetItemNumber(ll_i,'co_referencia')
		ls_de_referencia			=Trim(lds_cant.GetItemString(ll_i,'de_referencia'))
		ll_co_color_pt				=lds_cant.GetItemNumber(ll_i,'co_color_pt')
		ld_yield						=lds_cant.GetItemNumber(ll_i,'yield')
		ls_tono						=Trim(lds_cant.GetItemString(ll_i,'tono'))
		li_cs_paticion				=lds_cant.GetItemNumber(ll_i,'cs_particion')
		ll_co_color_te				=lds_cant.GetItemNumber(ll_i, 'co_color_te')
		ll_modelo					=lds_cant.GetItemNumber(ll_i, 'co_modelo')
		ls_de_color_1				=lds_cant.GetItemString(ll_i, 'de_color_1')
		ld_ancho_cortable			=lds_cant.GetItemNumber(ll_i, 'ancho_cortable')
		
		dw_pdn_talla.SetItem(ll_fila,"co_fabrica",li_co_fabrica_exp)
		dw_pdn_talla.SetItem(ll_fila,"cs_liberacion",li_cs_liberacion)
		dw_pdn_talla.SetItem(ll_fila,"po",ls_po)
		dw_pdn_talla.SetItem(ll_fila,"nu_cut",ls_cut)
		//dw_pdn_talla.SetItem(ll_fila,"co_linea",Trim(lds_cant.GetItemString(ll_i,'de_lin')))
		dw_pdn_talla.SetItem(ll_fila,"co_fabrica_pt",(lds_cant.GetItemNumber(ll_i,'co_fabrica_pt')))
		dw_pdn_talla.SetItem(ll_fila,"co_lin",(lds_cant.GetItemNumber(ll_i,'co_linea')))
		dw_pdn_talla.SetItem(ll_fila,"co_referencia",Trim(lds_cant.GetItemString(ll_i,'de_referencia')))
		dw_pdn_talla.SetItem(ll_fila,"co_ref",(lds_cant.GetItemNumber(ll_i,'co_referencia')))
		dw_pdn_talla.SetItem(ll_fila,"co_color",lds_cant.GetItemNumber(ll_i,'co_color_pt'))
		dw_pdn_talla.SetItem(ll_fila, "yield", ld_yield)
		dw_pdn_talla.SetItem(ll_fila,"tono",Trim(lds_cant.GetItemString(ll_i,'tono')))
		dw_pdn_talla.SetItem(ll_fila,"par",lds_cant.GetItemNumber(ll_i,'cs_particion'))
		dw_pdn_talla.SetItem(ll_fila, "co_color_te", lds_cant.GetItemNumber(ll_i, 'co_color_te'))
		dw_pdn_talla.SetItem(ll_fila, "de_color_te", lds_cant.GetItemString(ll_i, 'de_color_1'))
		dw_pdn_talla.SetItem(ll_fila, "ancho_cortable", lds_cant.GetItemNumber(ll_i, 'ancho_cortable'))
		dw_pdn_talla.SetItem(ll_fila, "orden", ll_fila)
		dw_pdn_talla.SetItem(ll_fila, "co_modelo", ll_modelo)
		
		ll_total += ll_cant
		
		ll_pdnant = ll_pdn
		
		For li_j = 1 To il_numtalla
			If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
			  //If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = ls_talla Then
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
dw_pdn_talla.Sort()
dw_pdn_talla.GroupCalc()

Return 0
end function

public function long of_calseccion (long an_trazo, long an_seccion);DataStore lds_trazodf
Long     li_i,li_j,li_sw,li_tzsw,li_swrtz,li_swex, li_orden, li_filas
Long    ll_capa,ll_pack,ll_seccion,ll_pdn,ll_cntpg,ll_talla,ll_disp,&
        ll_result,ll_fila,ll_trazo,ll_modelo,ll_fab,ll_ref,ll_carac,&
		  ll_diamt,ll_color,ll_found,ll_dftz,ll_fbpdn,ll_lnpdn, ll_revision, &
		  ll_rfpdn,ll_cpins,ll_numtll,ll_tztmp,ll_raya, ll_pdnant, ll_packpdn
String  ls_sqlerr,ls_deref, ls_orden
Decimal ldc_ancho
u_ds_base lds_siguientes_pdn

lds_trazodf = Create DataStore

lds_trazodf.DataObject = 'd_buscar_trazo_definido_para_utilizar_v2'

lds_trazodf.SetTransObject(Sqlca)

delete from t_trazos
where usuario = User;

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
ll_fab    = dw_trazo.GetItemNumber(ll_fila,'co_fabrica_te')
ll_ref    = dw_trazo.GetItemNumber(ll_fila,'co_reftel')
ll_carac  = dw_trazo.GetItemNumber(ll_fila,'co_caract')
ll_diamt  = dw_trazo.GetItemNumber(ll_fila,'diametro')
ll_raya	 = dw_trazo.GetItemNumber(ll_fila,'raya')
//ll_color  = dw_trazo.GetItemNumber(ll_fila,'co_color_te')
ldc_ancho = dw_pdn_talla.GetItemDecimal(il_numpdn,'ancho_cortable')



ll_dftz  = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount(),"co_trazo")	  
ll_found = 0
li_tzsw  = 0

For li_i = 1 To il_numpdn
	ll_pdn  = dw_pdn_talla.GetItemNumber(li_i,"pdn")
	ll_capa = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(il_numtalla + 2))
	
	ll_fbpdn = dw_pdn_talla.GetItemNumber(li_i,"co_fabrica_pt")
	ll_lnpdn = dw_pdn_talla.GetItemNumber(li_i,"co_lin")
	ll_rfpdn = dw_pdn_talla.GetItemNumber(li_i,"co_ref")
	ls_deref = dw_pdn_talla.GetItemString(li_i,"co_referencia")
	li_swex  = dw_pdn_talla.GetItemNumber(li_i,"exref")
	ll_color  = dw_pdn_talla.GetItemNumber(li_i,"co_color_te")	
	ll_modelo = dw_pdn_talla.GetItemNumber(li_i,'co_modelo')	
	li_orden = dw_pdn_talla.GetITemNumber(li_i, "orden")	
	li_sw = 0
	
	If (ll_capa > 0 Or cbx_retazo.Checked) And li_swex = 0 Then
		For li_j = 1 To il_numtalla
			ll_talla = Long(dw_pdn_talla.Describe("talla" + String(li_j) + ".tag"))
			ll_disp  = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(li_j))
			
// Se hace esta validaci$$HEX1$$f300$$ENDHEX$$n para que cuando en una agrupada se programen referencias 
// con distintas tallas, se tengan en cuenta solo las tallas que tienen unidades

			ll_packpdn  = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(li_j))
			
			ll_revision = dw_pdn_talla.GetItemNumber(il_numpdn + 1,"talla" + String(li_j))
			
			IF ll_packpdn <> 0 THEN  //estaba como <> 0,  se cambia a >=0 para informar cuando utilizan un trazo con una talla a la que no le faltan unidades (jorodrig  dic 3 2018)
				ll_pack  = dw_pdn_talla.GetItemNumber(il_numpdn + 1,"talla" + String(li_j))
			ELSE
				ll_pack = 0
			END IF			
			
			 IF (ll_packpdn = 0 AND ll_pack  > 0 ) or (ll_packpdn = 0 AND ll_revision > 0 ) THEN
              MessageBox("Advertencia!","Esa utilizando un trazo con una talla que no tiene unidades pendientes, talla: " + string(ll_talla))
          END IF

//			If (ll_pack > 0 and ll_disp > 0) Or ( ll_pack > 0 And cbx_retazo.Checked) or (ll_pack > 0 and ll_raya <> 10) Then
//			If (ll_pack > 0 and ll_disp > 0) Or ( ll_pack > 0 And cbx_retazo.Checked) Then				
			If (ll_pack > 0) Or ( ll_pack > 0 And cbx_retazo.Checked) Then								
				
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
						
															
					insert into dt_trazosxbase  
						 ( cs_orden_corte,cs_agrupacion,cs_base_trazos,cs_trazo,cs_seccion,   
							cs_pdn, co_talla,co_modelo,co_fabrica_te,co_reftel,co_caract,   
							diametro,co_color_te,ca_paquetes,capas,ca_programadas,ca_resulta,   
							co_trazo,ca_disponibles,co_estado,co_tipo,sw_retazos,fe_creacion,
							fe_actualizacion,usuario,instancia, cs_ordenpdn)  
					values ( :il_orden,:il_agrupa,:ll_trazo,:an_trazo,:an_seccion,:ll_pdn,   
							:ll_talla,:ll_modelo,:ll_fab,:ll_ref,:ll_carac,:ll_diamt,:ll_color,   
							:ll_pack,:ll_cpins,:ll_cntpg,:ll_result,:ll_dftz,:ll_disp,1,2,:li_swrtz,   
							current,current,user,sitename, :li_orden )  ;
	
					If Sqlca.SqlCode = -1 Then
						ls_sqlerr = Sqlca.SqlErrText
						rollback ; 
						MessageBox("Advertencia!","No se pudo recuperar el consecutivo de la seccion.~n~n~nNota: " + ls_sqlerr)
						Return -1
					End If
					
					UPDATE dt_pdnxmodulo  
					  SET co_estado_asigna = 7  
					WHERE ( dt_pdnxmodulo.simulacion = :ii_simulacion ) AND  
							( dt_pdnxmodulo.co_fabrica = :ii_fabrica ) AND  
							( dt_pdnxmodulo.co_planta = :ii_planta ) AND  
							( dt_pdnxmodulo.cs_asignacion = :il_orden ) AND
							( dt_pdnxmodulo.co_estado_asigna <> 9 );
							
					If Sqlca.SqlCode = -1 Then
						ls_sqlerr = Sqlca.SqlErrText
						rollback ; 
						MessageBox("Advertencia!","No se pudo actualizar el programa de corte.~n~n~nNota: " + ls_sqlerr)
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

// Cuando la orden es agrupada vamos a generar los registros de las otras producciones
// que tienen la misma PO de la programada
IF ii_agrupada = 1 THEN
	lds_siguientes_pdn = Create u_ds_base
	
	lds_siguientes_pdn.DataObject = 'dgr_trazos_agrupada_siguientes_pdn'
	
	IF lds_siguientes_pdn.SetTransObject(SQLCA) = -1 THEN
		ROLLBACK;
		MessageBox("Error","Error al asignar el objeto transacci$$HEX1$$f300$$ENDHEX$$n de las siguientes pdn")
		Return -1
	END IF

// Buscamos el primer registro que se program$$HEX1$$f300$$ENDHEX$$.

	For li_i = 1 To il_numpdn
		ll_capa = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(il_numtalla + 2))
		IF ll_capa > 0 THEN
			ll_pdn  = dw_pdn_talla.GetItemNumber(li_i,"pdn")		
			ls_orden = dw_pdn_talla.GetItemString(li_i,"po")
			ll_cpins = dw_pdn_talla.GetItemNumber(li_i,"talla" + String(il_numtalla + 2))
		END IF
	NEXT
	ll_pdnant = 0
	
	lds_siguientes_pdn.Retrieve(il_agrupa, ll_trazo, ll_pdn, ll_dftz, ls_orden)
	FOR li_filas = 1 TO lds_siguientes_pdn.RowCount()
		ll_pdn = lds_siguientes_pdn.GetItemNumber(li_filas, 'cs_pdn')
		IF ll_pdn <> ll_pdnant THEN
			an_seccion = an_seccion + 1
			ll_pdnant = ll_pdn
		END IF
		ll_talla = lds_siguientes_pdn.GetItemNumber(li_filas, 'co_talla')
		ll_modelo = lds_siguientes_pdn.GetItemNumber(li_filas, 'co_modelo')
		ll_fab = lds_siguientes_pdn.GetItemNumber(li_filas, 'co_fabrica_te')
		ll_ref = lds_siguientes_pdn.GetItemNumber(li_filas, 'co_reftel')
		ll_carac = lds_siguientes_pdn.GetItemNumber(li_filas, 'co_caract')
		ll_diamt = lds_siguientes_pdn.GetItemNumber(li_filas, 'diametro')
		ll_color = lds_siguientes_pdn.GetItemNumber(li_filas, 'co_color_te')
		ll_pack = lds_siguientes_pdn.GetItemNumber(li_filas, 'ca_paquetes')
		ll_cntpg = ll_pack * ll_cpins
		ll_disp = lds_siguientes_pdn.GetItemNumber(li_filas, 'ca_unidades')
		ll_result = ll_disp - ll_cntpg
		
		INSERT INTO dt_trazosxbase(cs_orden_corte, cs_agrupacion, cs_base_trazos,
			cs_trazo, cs_seccion, cs_pdn, co_talla, co_modelo, co_fabrica_te, co_reftel,
			co_caract, diametro, co_color_te, ca_paquetes, capas, ca_programadas, ca_resulta,   
			co_trazo, ca_disponibles, co_estado, co_tipo, sw_retazos, fe_creacion,
			fe_actualizacion, usuario, instancia, cs_ordenpdn)  
		VALUES(:il_orden, :il_agrupa, :ll_trazo, :an_trazo, :an_seccion, :ll_pdn,   
			:ll_talla, :ll_modelo, :ll_fab, :ll_ref, :ll_carac, :ll_diamt, :ll_color,   
			:ll_pack, :ll_cpins, :ll_cntpg, :ll_result, :ll_dftz, :ll_disp, 1, 2, :li_swrtz,   
			Current, Current, User, Sitename, :li_orden);
		
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ; 
			MessageBox("Advertencia!","No se pudo insertar registro de trazos siguientes pdn.~n~n~nNota: " + ls_sqlerr)
			Return -1
		End If		
	NEXT
END IF

commit ;

Return 0
end function

public function long of_trazodefinido (long an_row);DataStore lds_tallas,lds_ref 
Long ll_fila,ll_trazo,ll_ref,ll_flfnd,ll_oc,ll_agrupa, ll_filatrazo
Long  li_talla,li_capas,li_j,li_i,li_fab,li_lin
Decimal ld_anchotrazo, ld_anchotela

ll_filatrazo = dw_trazo.GetSelectedRow(ll_fila)

Of_Cuadro(ll_filatrazo)


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


lds_tallas.DataObject = 'd_lista_talla_referencia_dt_tallasxtr_v2'
lds_ref.DataObject = 'd_lista_referencias_x_un_trazo_definido'

lds_tallas.SetTransObject(Sqlca)
lds_ref.SetTransObject(Sqlca)

For li_i = 1 To il_numpdn
	dw_pdn_talla.SetItem(li_i,'exref',1)	
Next

ll_trazo = dw_produccion.GetItemNumber(an_row,'co_trazo')
ld_anchotrazo = dw_produccion.GetItemNumber(an_row, 'ancho')
li_fab	= dw_produccion.GetItemNumber(an_row, 'co_fabrica')
li_lin	= dw_produccion.GetItemNumber(an_row, 'co_linea')
ll_ref	= dw_produccion.GetItemNumber(an_row, 'co_referencia')

lds_ref.Retrieve(ll_trazo, li_fab, li_lin, ll_ref)

For li_i = 1 To lds_ref.RowCount() 
	
//	li_fab   = lds_ref.GetItemNumber(li_i,'co_fabrica')
//	li_lin   = lds_ref.GetItemNumber(li_i,'co_linea')
//	ll_ref   = lds_ref.GetItemNumber(li_i,'co_referencia')
	
	ll_flfnd = 1
	
	Do 
		ll_flfnd = dw_pdn_talla.Find("co_fabrica_pt = " + String(li_fab) + " and " + &
											  "co_lin = " + String(li_lin) + " and " + &
											  "co_ref = " + String(ll_ref),ll_flfnd,dw_pdn_talla.RowCount())
		
		If ll_flfnd > 0 Then
			ld_anchotela = dw_pdn_talla.GetItemNumber(ll_flfnd, 'ancho_cortable')
//			IF ld_anchotrazo  > (ld_anchotela + 3 ) THEN
//				MessageBox("Advertencia...", "El ancho del trazo no puede ser mayor que el liberado")
//				Of_Cuadro(ll_filatrazo)
//				Return -1
//			END IF
//			IF ld_anchotrazo < (ld_anchotela - 2.5) THEN
//				MessageBox("Advertencia...","El ancho del trazo esta por debajo de la tolerancia")
//				Of_Cuadro(ll_filatrazo)
//				Return -1
//			END IF
			dw_pdn_talla.SetItem(ll_flfnd,'exref',0)
			ll_flfnd ++
		End If	
				
	Loop Until ll_flfnd = 0 Or ll_flfnd > dw_pdn_talla.RowCount()
Next
	
dw_pdn_talla.SetItem(ll_fila,"co_trazo",ll_trazo)

lds_tallas.Retrieve(ll_trazo,il_agrupa, li_fab, li_lin, ll_ref)

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

public function long of_yield (long an_row);u_ds_base lds_trazo, lds_secciones
Long    ll_cstzo, ll_seccion, ll_trazo, ll_fltz, ll_pack, ll_cnt, ll_cntt,&
        ll_secaux, ll_secsel, ll_cotrazo, ll_cstrazoaux,ll_co_reftel, ll_unidades
Long     li_i, li_talla, li_talla_ant, li_fila, li_estado_trazo,li_co_caract
decimal ldc_grs, ldc_prom, ldc_largo, ldc_lgsec, ldc_consumoseccion, ldc_consumolib, ldc_consumototal
decimal ld_largotrazo, ld_largoseccion,ldc_porc_desperdicio
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes
ll_fltz = dw_trazo.GetRow()

ll_trazo  = dw_trazo.GetItemNumber(ll_fltz,'cs_base_trazos')
ll_co_reftel=dw_trazo.GetItemNumber(ll_fltz,'co_reftel')
li_co_caract=dw_trazo.GetItemNumber(ll_fltz,'co_caract')
ll_cstzo  = dw_seccion.GetItemNumber(an_row,'cs_trazo')
ll_secsel = dw_seccion.GetItemNumber(an_row,'cs_seccion')


lds_trazo   = Create u_ds_base
lds_secciones = Create u_ds_base

lds_trazo.DataObject   = 'd_gramos_trazo_v2'
lds_secciones.DataObject = 'd_secciones_trazo'

lds_trazo.SetTransObject(Sqlca)
lds_secciones.SetTransObject(Sqlca)

ll_pack   = 0
ll_cntt   = 0
ldc_prom  = 0 
ldc_largo = 0

// Vamos a calcular el largo de la secci$$HEX1$$f300$$ENDHEX$$n y el trazo, y el consumo de la secci$$HEX1$$f300$$ENDHEX$$n.
FOR li_fila = 1 TO lds_secciones.Retrieve(il_orden,il_agrupa,ll_trazo,ll_cstzo)
	ll_seccion = lds_secciones.GetItemNumber(li_fila, 'cs_seccion')
	ll_cotrazo = lds_secciones.GetItemNumber(li_fila, 'co_trazo')
// Vamos a consultar el ancho y estado del trazo. Si el estado del trazo es 1 ese es el ancho de la seccion
	SELECT largo, co_estado_trazo
	INTO :ld_largotrazo, :li_estado_trazo
	FROM h_trazos
	WHERE co_trazo = :ll_cotrazo;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al consultar el trazo")
	END IF
	If lds_trazo.Retrieve(il_orden,il_agrupa,ll_trazo,ll_cstzo, ll_seccion) > 0 Then
		li_talla_ant = 0
		For li_i = 1 To lds_trazo.RowCount()
			li_talla = lds_trazo.GetItemNumber(li_i, 'co_talla')
			ll_cnt  =  lds_trazo.GetItemNumber(li_i,'ca_programadas')			
			IF li_talla <> li_talla_ant THEN
				ll_pack += lds_trazo.GetItemNumber(li_i,'ca_paquetes')
				li_talla_ant = li_talla
			END IF
			ldc_grs =  lds_trazo.GetItemDecimal(li_i,'metros')
			ll_cntt  += ll_cnt
			ldc_prom += ll_cnt * ldc_grs 
		Next
		ldc_lgsec = ( ldc_prom / ll_cntt ) * ll_pack
	End If
	IF li_estado_trazo = 1 THEN
		ldc_lgsec = ld_largotrazo
		ldc_largo = ldc_largo + ld_largotrazo
	ELSE
		ldc_largo = ldc_largo + ldc_lgsec
	END IF
	IF ll_seccion = ll_secsel THEN
		ld_largoseccion = ldc_lgsec
		
		ldc_porc_desperdicio = luo_constantes.of_consultar_numerico("DESPERDICIO OC")
		
//		SELECT h_telas.prc_desperdicio  
//		 INTO :ldc_porc_desperdicio  
//		 FROM h_telas  
//		WHERE ( h_telas.co_reftel = :ll_co_reftel ) AND  
//				( h_telas.co_caract = :li_co_caract )   ;
//		IF SQLCA.SQLCODE=-1 THEN
//			MessageBox("Advertencia","No tiene % desperdicio del Maestro de tela")
//		ELSE
			ldc_porc_desperdicio=(ldc_porc_desperdicio/100) + 1
//		END IF
		if ll_cntt=0 then
			ldc_consumoseccion = 0
		else 
			ldc_consumoseccion = ( ldc_prom / ll_cntt ) * ldc_porc_desperdicio			
		end if
	END IF
NEXT

// Vamos a consultar el consumo de la liberaci$$HEX1$$f300$$ENDHEX$$n.

select Sum(dt_telaxmodelo_lib.ca_unidades)
into :ll_unidades
from dt_telaxmodelo_lib, dt_rayas_telaxbase, dt_agrupa_pdn
where dt_rayas_telaxbase.cs_agrupacion = :il_agrupa and
		dt_rayas_telaxbase.cs_base_trazos = :ll_trazo and
		dt_rayas_telaxbase.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion and
		dt_agrupa_pdn.co_fabrica_exp = dt_telaxmodelo_lib.co_fabrica_exp and
		dt_agrupa_pdn.cs_liberacion = dt_telaxmodelo_lib.cs_liberacion and
		dt_agrupa_pdn.po = dt_telaxmodelo_lib.nu_orden and
		dt_agrupa_pdn.nu_cut = dt_telaxmodelo_lib.nu_cut and
		dt_agrupa_pdn.co_fabrica_pt = dt_telaxmodelo_lib.co_fabrica_pt and
		dt_agrupa_pdn.co_linea = dt_telaxmodelo_lib.co_linea and
		dt_agrupa_pdn.co_referencia = dt_telaxmodelo_lib.co_referencia and
		dt_agrupa_pdn.co_color_pt = dt_telaxmodelo_lib.co_color_pt and
		dt_agrupa_pdn.tono = dt_telaxmodelo_lib.co_tono and
		dt_rayas_telaxbase.co_modelo = dt_telaxmodelo_lib.co_modelo and
		dt_rayas_telaxbase.co_reftel = dt_telaxmodelo_lib.co_reftel and
		dt_rayas_telaxbase.co_caract = dt_telaxmodelo_lib.co_caract and
		dt_rayas_telaxbase.diametro = dt_telaxmodelo_lib.diametro and
		dt_rayas_telaxbase.co_color_te = dt_telaxmodelo_lib.co_color_tela;

select Sum((dt_telaxmodelo_lib.yield * dt_telaxmodelo_lib.ca_unidades) / :ll_unidades)
into :ldc_consumolib
from dt_telaxmodelo_lib, dt_rayas_telaxbase, dt_agrupa_pdn
where dt_rayas_telaxbase.cs_agrupacion = :il_agrupa and
		dt_rayas_telaxbase.cs_base_trazos = :ll_trazo and
		dt_rayas_telaxbase.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion and
		dt_agrupa_pdn.co_fabrica_exp = dt_telaxmodelo_lib.co_fabrica_exp and
		dt_agrupa_pdn.cs_liberacion = dt_telaxmodelo_lib.cs_liberacion and
		dt_agrupa_pdn.po = dt_telaxmodelo_lib.nu_orden and
		dt_agrupa_pdn.nu_cut = dt_telaxmodelo_lib.nu_cut and
		dt_agrupa_pdn.co_fabrica_pt = dt_telaxmodelo_lib.co_fabrica_pt and
		dt_agrupa_pdn.co_linea = dt_telaxmodelo_lib.co_linea and
		dt_agrupa_pdn.co_referencia = dt_telaxmodelo_lib.co_referencia and
		dt_agrupa_pdn.co_color_pt = dt_telaxmodelo_lib.co_color_pt and
		dt_agrupa_pdn.tono = dt_telaxmodelo_lib.co_tono and
		dt_rayas_telaxbase.co_modelo = dt_telaxmodelo_lib.co_modelo and
		dt_rayas_telaxbase.co_reftel = dt_telaxmodelo_lib.co_reftel and
		dt_rayas_telaxbase.co_caract = dt_telaxmodelo_lib.co_caract and
		dt_rayas_telaxbase.diametro = dt_telaxmodelo_lib.diametro and
		dt_rayas_telaxbase.co_color_te = dt_telaxmodelo_lib.co_color_tela;
		
If SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar el consumo de la liberaci$$HEX1$$f300$$ENDHEX$$n")
END IF

// Vamos a calcular el consumo de todos los trazos programados.

lds_trazo.DataObject   = 'd_gramos_trazo_v2'

lds_trazo.SetTransObject(Sqlca)

ll_pack   = 0
ll_cntt   = 0
ldc_prom  = 0 

If lds_trazo.Retrieve(il_orden, il_agrupa, ll_trazo, 0, 0) > 0 Then
	For li_i = 1 To lds_trazo.RowCount()
		ll_cnt  =  lds_trazo.GetItemNumber(li_i,'ca_programadas')
		ldc_grs =  lds_trazo.GetItemDecimal(li_i,'metros')
		ll_cntt  += ll_cnt
		ldc_prom += ll_cnt * ldc_grs 
	Next
	ldc_consumototal = ( ldc_prom / ll_cntt ) * ldc_porc_desperdicio
End If

st_ltz.Text  = String(ldc_largo,"#,##0.00")
st_lsec.Text = String(ld_largoseccion,"#,##0.00")
st_trazo.Text = String(ldc_consumoseccion, "#,##0.00")
st_aprobado.Text = String(ldc_consumolib, "#,##0.00")
st_total.Text = String(ldc_consumototal, "#,##0.00")


Destroy lds_trazo
Destroy lds_secciones

IF st_aprobado.Text < st_total.Text THEN
	//MessageBox("Advertencia","El consumo de esta tela es mayor que el aprobado")
ELSE
END IF

Return 0
end function

public function long of_cscutivotrazo ();Long   ll_cs_documento
String ls_sqlerr



select max(cs_documento )  
  into :ll_cs_documento  
  from cf_consecutivos  
 where co_fabrica = :ii_fabrica and
		 id_documento = 55  ;
		 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	MessageBox("Advertencia!","Hubo un error al buscar el consecutivo para la base.~n~n~nNota: " + ls_sqlerr,Stopsign!)
	Return -1
End If

ll_cs_documento ++			
			
update cf_consecutivos  
   set cs_documento = cs_documento + 1  
 where cf_consecutivos.co_fabrica = :ii_fabrica and
		 cf_consecutivos.id_documento = 55  ;

If Sqlca.SqlCode = -1 Then	
	ls_sqlerr = Sqlca.SqlErrText
	rollback ; 
	MessageBox("Advertencia!","Hubo Problemas Actualizando Consecutivo de Trazo.~n~n~nNota: " + ls_sqlerr,Stopsign!,OK!)
	Return -1 
End If

Return ll_cs_documento

end function

public function long of_agrupacion (long an_orden, ref long ai_estado_agrupa);Long   ll_agrupa
Long li_estado
String ls_sqlerr


select distinct dt_agrupa_pdn.cs_agrupacion, dt_pdnxmodulo.co_estado_asigna,
			h_agrupa_pdn.co_estado
  into :ll_agrupa, :li_estado, :ai_estado_agrupa
  from dt_pdnxmodulo, dt_agrupa_pdn, h_agrupa_pdn
 where dt_pdnxmodulo.co_fabrica_exp 		= dt_agrupa_pdn.co_fabrica_exp and
       dt_pdnxmodulo.cs_liberacion 			= dt_agrupa_pdn.cs_liberacion and
       dt_pdnxmodulo.po 						= dt_agrupa_pdn.po and
		 dt_pdnxmodulo.nu_cut					= dt_agrupa_pdn.nu_cut and
       dt_pdnxmodulo.co_fabrica_pt 			= dt_agrupa_pdn.co_fabrica_pt and 
       dt_pdnxmodulo.co_linea 				= dt_agrupa_pdn.co_linea and
       dt_pdnxmodulo.co_referencia 			= dt_agrupa_pdn.co_referencia and  
       dt_pdnxmodulo.co_color_pt 			= dt_agrupa_pdn.co_color_pt and
       dt_pdnxmodulo.tono 						= dt_agrupa_pdn.tono and  
       dt_pdnxmodulo.cs_particion 			= dt_agrupa_pdn.cs_particion and
       dt_pdnxmodulo.cs_asignacion 			= :an_orden and
		 dt_agrupa_pdn.cs_agrupacion			= h_agrupa_pdn.cs_agrupacion;

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

public function long of_verificar_estado (long al_ordencorte);//si la orden de corte ya fue generada no se debe permitir que se realizen modificaciones sobre esta.
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM h_ordenes_corte
 WHERE cs_orden_corte = :al_ordencorte;
 
 IF sqlca.sqlcode = -1 THEN
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la orden de corte. '+Sqlca.SqlErrText)
	Return 2
END IF

IF ll_count > 0 THEN
	MessageBox('Advertencia','La orden de corte ya fue generada, el sistema no le permitira realizarle modificaciones.')
	Return 1
END IF


Return 0
end function

public function long of_validartrazosmodelo (long al_ordencorte);//funcion para validar que todos los modelos que componen la orden de corte tengan creado trazo.
//jcrm
//noviembre 29 de 2007
Long ll_trazo, ll_modelo, ll_referencia
Long li_fabrica, li_linea
String ls_error


//se verifica cuantos modelos tienen asignado trazo 
SELECT count(distinct co_modelo)
  INTO :ll_trazo 
  FROM dt_trazosxoc  
 WHERE cs_orden_corte = :al_ordencorte;
 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	//Rollback;
	MessageBox('Error','No fue posible establecer los trazos, ERROR: '+ ls_error,StopSign!)
	Return -1
END IF
	 
	
//se determina cuando modelos hacen parte de la referencia	
SELECT count(distinct dt_color_modelo.co_modelo)
  INTO :ll_modelo
  FROM dt_color_modelo, dt_pdnxmodulo 
 WHERE dt_color_modelo.co_fabrica = dt_pdnxmodulo.co_fabrica_pt AND
       dt_color_modelo.co_linea  = dt_pdnxmodulo.co_linea AND
       dt_color_modelo.co_referencia  = dt_pdnxmodulo.co_referencia AND
		 dt_color_modelo.co_color_pt  = dt_pdnxmodulo.co_color_pt AND
 		 dt_color_modelo.co_calidad   = 1 AND
		 dt_pdnxmodulo.cs_asignacion = :al_ordencorte
		 ;	

IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	//Rollback;
	MessageBox('Error','No fue posible establecer los modelos de la referencia, ERROR: '+ ls_error,StopSign!)
	Return -1
END IF

//cuando existen modelos sesgos no se debe verificar el trazo, pero no se ha identificado
//la forma de saber cuando un modelo lleva trazo o no.
//se esta averiguando esto con ficha tecnica

IF ll_modelo <> ll_trazo THEN
	Return -1
END IF

Return 0
end function

public function long of_validacion_temporal_kg_rollos (long al_orden_corte);LONG	ll_mercada
Long	posi
DECIMAL{3}	ld_kg_partir, ld_kg_rollo
DataStore lds_rollos

lds_rollos = Create DataStore
lds_rollos.DataObject = 'dtb_temp_validar_kg_rollos_partir' //datos de dt_pdnxmodulo
lds_rollos.SetTransObject(sqlca)


SELECT MAX(cs_mercada)
  INTO :ll_mercada
  FROM h_mercada
 WHERE cs_orden_corte = :al_orden_corte; 
 
 
IF ll_mercada > 0 THEN
	lds_rollos.Retrieve(ll_mercada)
	FOR posi = 1 TO lds_rollos.RowCount()
		ld_kg_partir =  lds_rollos.GetItemDecimal(posi,'kg_partir')
		ld_kg_rollo  =  lds_rollos.GetItemDecimal(posi,'kg_rollo')
		IF ld_kg_partir > ld_kg_rollo THEN
			Return -1
		END IF
	NEXT
	
END IF

 Return 1;
end function

on w_trazos_x_session_version2.create
if this.MenuName = "m_mantenimiento_seccion_trazos" then this.MenuID = create m_mantenimiento_seccion_trazos
this.cbx_1=create cbx_1
this.st_total=create st_total
this.st_trazo=create st_trazo
this.st_aprobado=create st_aprobado
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
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
this.gb_2=create gb_2
this.Control[]={this.cbx_1,&
this.st_total,&
this.st_trazo,&
this.st_aprobado,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_lsec,&
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
this.gb_1,&
this.gb_2}
end on

on w_trazos_x_session_version2.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.st_total)
destroy(this.st_trazo)
destroy(this.st_aprobado)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
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
destroy(this.gb_2)
end on

event open;TRANSACTION			itr_tela
STRING	ls_instruccion
n_cts_constantes luo_constantes

//IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
//	Close(This)
//END IF

itr_tela = Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

//se deshabilitan las opciones del menu para los usuarios que bo sean de texografo.
//jcrm
//marzo 27 de 2007
//IF gstr_info_usuario.codigo_perfil = 16 OR gstr_info_usuario.codigo_perfil = 19  OR gstr_info_usuario.codigo_perfil = 5  OR gstr_info_usuario.codigo_perfil = 17 Then
//ELSE
//	m_mantenimiento_seccion_trazos.m_edicion.m_programaci$$HEX1$$f300$$ENDHEX$$nmanual.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_generartrazobalanceo.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_borrarsecci$$HEX1$$f300$$ENDHEX$$n.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_generarordendecorte.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_devolvergeneraci$$HEX1$$f300$$ENDHEX$$ndeordendecorte.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_verordencorte.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_pendientesporprogramar.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_habilitarrecalculoliberaci$$HEX1$$f300$$ENDHEX$$n.ToolbarItemVisible = False
//	m_mantenimiento_seccion_trazos.m_archivo.m_grabar.ToolbarItemVisible = False
//	
//	m_mantenimiento_seccion_trazos.m_edicion.m_programaci$$HEX1$$f300$$ENDHEX$$nmanual.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_generartrazobalanceo.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_borrarsecci$$HEX1$$f300$$ENDHEX$$n.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_generarordendecorte.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_devolvergeneraci$$HEX1$$f300$$ENDHEX$$ndeordendecorte.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_verordencorte.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_pendientesporprogramar.Visible = False
//	m_mantenimiento_seccion_trazos.m_edicion.m_habilitarrecalculoliberaci$$HEX1$$f300$$ENDHEX$$n.Visible = False
//	m_mantenimiento_seccion_trazos.m_archivo.m_grabar.Visible = False
//	
//	
//	dw_pdn_talla.Object.DataWindow.ReadOnly
//	dw_trazo.Object.DataWindow.ReadOnly
//	dw_oc.Object.DataWindow.ReadOnly
//	dw_produccion.Object.DataWindow.ReadOnly
//	dw_seccion.Object.DataWindow.ReadOnly
//	
//END IF


dw_trazo.SetTransObject(itr_tela)
dw_seccion.SetTransObject(itr_tela)
dw_oc.SetTransObject(itr_tela)

ls_instruccion = "SET LOCK MODE TO WAIT 60 "
EXECUTE IMMEDIATE :ls_instruccion USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","Problemas con la base de datos en el modo de bloqueo: " + itr_tela.sqlerrtext, Stopsign!, OK!)
   Return(-1)
END IF

luo_constantes = Create n_cts_constantes
ii_fabrica = luo_constantes.of_consultar_numerico("FABRICA PLANTA")
IF ii_fabrica = -1 THEN
	Return
END IF
ii_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACIONES")
IF ii_planta = -1 THEN
	Return
END IF

ii_simulacion = luo_constantes.of_consultar_numerico("SIMULACION")
IF ii_simulacion = -1 THEN
	Return
END IF

This.TriggerEvent("ue_buscar")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" + itr_tela.sqlerrtext, Stopsign!, OK!)
   Return
END IF

dw_produccion.SetTransObject(sqlca)
dw_trazo.SetTransObject(sqlca)
dw_seccion.SetTransObject(sqlca)
dw_oc.SetTransObject(sqlca)
end event

type cbx_1 from checkbox within w_trazos_x_session_version2
integer x = 3232
integer y = 1600
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Validar Ean"
boolean checked = true
end type

event clicked;
String ls_clave_valida, ls_clave
n_cts_constantes_tela luo_constantes
s_base_parametros lstr_parametros

If cbx_1.Checked = False Then
	//se toma la clave para no validar el ean
	ls_clave_valida = luo_constantes.of_consultar_texto("PASSWORD_VALIDA_EAN")
	//abre ventana que pide clave
	Open(w_password_trazos)
	lstr_parametros = message.PowerObjectParm
	If lstr_parametros.hay_parametros = True Then
		//toma la clave digitada
		ls_clave = lstr_parametros.cadena[1]
		//compara las claves
		IF TRIM(ls_clave) <> TRIM(ls_clave_valida) THEN
			MessageBox('Advertencia','Clave Invalida')
			cbx_1.Checked =True
			Return 1
		END IF
	ELSE
		cbx_1.Checked = True
		Return 1
	END IF
End if

Return 1
end event

type st_total from statictext within w_trazos_x_session_version2
integer x = 2075
integer y = 1728
integer width = 251
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_trazo from statictext within w_trazos_x_session_version2
integer x = 1586
integer y = 1728
integer width = 251
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_aprobado from statictext within w_trazos_x_session_version2
integer x = 1115
integer y = 1728
integer width = 251
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_trazos_x_session_version2
integer x = 1915
integer y = 1728
integer width = 165
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_trazos_x_session_version2
integer x = 1413
integer y = 1728
integer width = 183
integer height = 52
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

type st_3 from statictext within w_trazos_x_session_version2
integer x = 841
integer y = 1728
integer width = 283
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobado:"
boolean focusrectangle = false
end type

type st_lsec from statictext within w_trazos_x_session_version2
integer x = 3291
integer y = 1724
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_trazos_x_session_version2
integer x = 3040
integer y = 1724
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

type st_ltz from statictext within w_trazos_x_session_version2
integer x = 2743
integer y = 1724
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_trazos_x_session_version2
integer x = 2551
integer y = 1724
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

type cbx_retazo from checkbox within w_trazos_x_session_version2
integer x = 503
integer y = 1716
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

type dw_oc from u_dw_base within w_trazos_x_session_version2
integer x = 1669
integer y = 644
integer width = 1925
integer height = 300
integer taborder = 30
string dataobject = "d_lista_oc_pdn_estilo_po_color_x_agrupa"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_2 from commandbutton within w_trazos_x_session_version2
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

type dw_seccion from u_dw_base within w_trazos_x_session_version2
integer x = 1669
integer y = 952
integer width = 1925
integer height = 616
integer taborder = 20
string dataobject = "d_lista_secciones_x_trazos_v2_copia21"
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

type dw_pdn_talla from u_dw_base within w_trazos_x_session_version2
integer x = 23
integer y = 8
integer width = 3557
integer height = 636
integer taborder = 10
string dataobject = "d_cuadro_pdn_x_tallas_pendientes_v2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;Long ll_cpnv,ll_cpvj, ll_capas, ll_totalcapas, ll_filas


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

If dwo.Name = ("talla" + String(il_numtalla + 2)) Then
	This.AcceptText()
	IF il_numpdn = This.RowCount() - 1 THEN
		FOR ll_filas = 1 TO il_numpdn
			ll_capas = This.GetItemNumber(ll_filas, "talla" + String(il_numtalla + 2))
			IF IsNull(ll_capas) THEN
				ll_capas = 0
			END IF
			ll_totalcapas = ll_totalcapas + ll_capas
		NEXT
		This.SetItem(This.RowCount(), "talla" + String(il_numtalla + 2), ll_totalcapas)
	END IF
	ll_cpnv = Long(Data)
	ll_cpvj = This.GetitemNumber(row,("talla" + String(il_numtalla + 2)))
	
	If ll_cpnv > ll_cpvj Then
		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","El n$$HEX1$$fa00$$ENDHEX$$mero de capas debe ser menor a " + String(ll_cpvj) + "." )
		Return  1
	End If
End If
end event

event itemerror;call super::itemerror;
Return 1
end event

type dw_produccion from u_dw_base within w_trazos_x_session_version2
integer y = 1024
integer width = 1641
integer height = 540
integer taborder = 10
string dataobject = "d_lista_trazos_tallasxtrazo_v2"
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

IF Of_TrazoDefinido(Row) = 0 THEN
	of_calcapas()
END IF
end event

type dw_trazo from u_dw_base within w_trazos_x_session_version2
integer x = 14
integer y = 644
integer width = 1641
integer height = 380
integer taborder = 10
string dataobject = "d_lista_base_rayasxbase_v2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;Long ll_trazo
Long li_raya

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

ib_tzbs = False

Of_Cuadro(Row)

li_raya = dw_trazo.GetItemNumber(Row, "raya")
dw_produccion.Retrieve(il_agrupa, li_raya)


	

end event

type cb_1 from commandbutton within w_trazos_x_session_version2
integer x = 73
integer y = 1708
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

event clicked;Long ll_trazo,ll_fila,ll_seccion,ll_found,ll_base, ll_fila_actual, ll_codtrazo
Long li_capas, li_capasec


If dw_pdn_talla.AcceptText() = -1 Then Return

ll_fila = 0 

If dw_pdn_talla.RowCount() > 0 And (il_numpdn + 1) = dw_pdn_talla.RowCount() Then
	
	ll_fila    = dw_trazo.GetSelectedRow(ll_fila)
	
	ll_base    	= dw_trazo.GetItemNumber(ll_fila,'cs_base_trazos')
	ll_trazo   	= dw_pdn_talla.GetItemNumber(il_numpdn + 1,'cs_liberacion')
	ll_seccion 	= dw_pdn_talla.GetItemNumber(il_numpdn + 1,'pdn')
	li_capas		= dw_trazo.GetItemNumber(ll_fila, "capas")
	ll_codtrazo = dw_pdn_talla.GetItemNumber(il_numpdn + 1, 'co_trazo')
	
// Vamos a validar las capas por cada uno de los trazos	
//	FOR ll_fila_actual = 1 TO il_numpdn
	IF ll_codtrazo <> 0 THEN
		li_capasec	= dw_pdn_talla.GetItemNumber(il_numpdn + 1, "talla" + String(il_numtalla + 2))
	
		IF li_capasec > li_capas THEN
			MessageBox("Advertencia!","Esta programando por encima las capas permitidas para el tipo de tela en la fila")
			Return
		END IF
	END IF
//	NEXT
	
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

type gb_1 from groupbox within w_trazos_x_session_version2
integer x = 2391
integer y = 1676
integer width = 1202
integer height = 124
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

type gb_2 from groupbox within w_trazos_x_session_version2
integer x = 805
integer y = 1676
integer width = 1545
integer height = 124
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consumos"
end type

