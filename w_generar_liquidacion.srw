HA$PBExportHeader$w_generar_liquidacion.srw
forward
global type w_generar_liquidacion from window
end type
type dw_secciones_espacio from datawindow within w_generar_liquidacion
end type
type em_espacio from editmask within w_generar_liquidacion
end type
type st_1 from statictext within w_generar_liquidacion
end type
end forward

global type w_generar_liquidacion from window
integer width = 3365
integer height = 1856
boolean titlebar = true
string title = "Generar Liquidaci$$HEX1$$f300$$ENDHEX$$n"
string menuname = "m_generar_liquidacion"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_grabar pbm_custom01
dw_secciones_espacio dw_secciones_espacio
em_espacio em_espacio
st_1 st_1
end type
global w_generar_liquidacion w_generar_liquidacion

type variables

Long il_ordencorte, il_agrupacion, il_basetrazo, il_trazo
boolean ib_grabar
String is_mensaje_correo
end variables

forward prototypes
public function long of_validar_liquidacion (long al_ordencorte, long al_agrupacion, long al_basetrazo, long al_trazo)
public function long of_validar_unidades ()
public function long of_traer_raya (long al_agrupacion, long al_base_trazos)
public function long of_validar_mercada (long al_ordencorte, long ai_raya)
public function long of_comparar_unidades_prog_liq ()
end prototypes

event ue_grabar;Long li_liquidacion, li_pdn, li_seccion, li_filas, li_filas_unids, li_capas, li_capas_prog,&
			li_fab, li_lin
Long ll_capas, ll_paquetes, ll_ref,ll_color_pt
String ls_error, ls_filtro, ls_mensaje, ls_usuario
u_ds_base lds_unidades
n_cts_capas_prog_x_liq luo_capas

ls_usuario = gstr_info_usuario.codigo_usuario

IF dw_secciones_espacio.RowCount() > 0 THEN
	 dw_secciones_espacio.AcceptText() 
	 //en este punto se debe validar si las unidades a liquidar son un 5% menores a las unidades programadas
	 //jcrm
	 //abril 11 de 2007
	 	 
	 IF ib_grabar = True THEN
	// Vamos a generar la liquidaci$$HEX1$$f300$$ENDHEX$$n con las capas del primer registro, despues se 
	// actualizan las capas para cada seccion y pdn en la liquidacion
	
		ll_capas = dw_secciones_espacio.GetItemNumber(1, 'capas_liq')
		DECLARE sp_crear_liquidacion PROCEDURE FOR
			pr_crear_liquidacion(:il_ordencorte, :il_agrupacion, :il_basetrazo, :il_trazo, :ll_capas);
			
		EXECUTE sp_crear_liquidacion;
		
		IF SQLCA.SQLCode = -1 THEN
			ls_error = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox("Error Base Datos","Error al generar la liquidaci$$HEX1$$f300$$ENDHEX$$n " + ls_error,StopSign!)
			Close sp_crear_liquidacion;
			Return
		END IF
		
		Close sp_crear_liquidacion;
		
		lds_unidades = Create u_ds_base
		lds_unidades.DataObject = 'dtb_liq_unidadesxespacio'
		
		IF lds_unidades.SetTransObject(SQLCA) = -1 THEN
			ROLLBACK;
			MessageBox("Error","Error al asignar el objeto transaccion de unidades",StopSign!)
			Destroy lds_unidades;
			Return
		END IF
		
		lds_unidades.Retrieve(il_ordencorte, il_agrupacion, il_basetrazo, il_trazo, 1)
		
		FOR li_filas = 1 TO dw_secciones_espacio.RowCount()
			
			li_capas 	= dw_secciones_espacio.GetItemNumber(li_filas, 'capas_liq')
			li_capas_prog = dw_secciones_espacio.GetItemNumber(li_filas,'capas')
			
			IF li_capas > li_capas_prog THEN
				li_fab			= dw_secciones_espacio.GetItemNumber(li_filas,'co_fabrica_pt')
				li_lin			= dw_secciones_espacio.GetItemNumber(li_filas,'co_linea')	
				ll_ref			= dw_secciones_espacio.GetItemNumber(li_filas,'co_referencia')
				ll_color_pt		= dw_secciones_espacio.GetItemNumber(li_filas,'co_color_pt')
			
				IF luo_capas.of_preliquidarcapaslinea(li_fab,li_lin,ll_ref,ll_color_pt,ls_mensaje) = -1 THEN
					ROLLBACK;
					MessageBox('Error','Las capas Liquidadas son mayores  a las capas programadas ',StopSign!)
					Destroy lds_unidades;
					ib_grabar = False
					Return 
				END IF
			END IF
			
			li_seccion = dw_secciones_espacio.GetItemNumber(li_filas, "cs_seccion")
			li_pdn = dw_secciones_espacio.GetItemNumber(li_filas, "cs_pdn")
			ll_capas = dw_secciones_espacio.GetItemNumber(li_filas, "capas_liq")
			ls_filtro = "cs_seccion = " + String(li_seccion) + " and cs_pdn = " + String(li_pdn)
			lds_unidades.SetFilter(ls_filtro)
			lds_unidades.Filter()
			FOR li_filas_unids = 1 TO lds_unidades.RowCount()
				ll_paquetes = lds_unidades.GetItemNumber(li_filas_unids, "paquetes")
				lds_unidades.SetItem(li_filas_unids, "capas", ll_capas)
				lds_unidades.SetItem(li_filas_unids, "ca_liquidadas", (ll_capas*ll_paquetes))
			NEXT
		NEXT
		IF lds_unidades.AcceptText() = 1 THEN
		  IF lds_unidades.Update() = 1 THEN
			  //validar que las unidades generadas de la raya no sean diferentes a las unidades
			  //de las demas rayas
			  //esto se hace para el sue$$HEX1$$f100$$ENDHEX$$on de recipiente perfecto
			  //jcrm
			  //agosto 23 de 2007
			   IF of_validar_unidades() = 0 THEN
					
					If of_comparar_unidades_prog_liq() <= 0 Then
						Rollback;
						Destroy lds_unidades;
						ib_grabar = False
						Return 
					End if
					
					COMMIT;
			  		MessageBox("Exito","Generada exitosamente la preliquidaci$$HEX1$$f300$$ENDHEX$$n")
					
					//mira si envia correo
					If trim(is_mensaje_correo) <> '' Then
						//ls_mensaje = 'Preliquidacion OC ' + String(il_ordencorte)
						//se envia correo 
						//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 33 es el que pertenece a este proceso en la tabla m_usu_correo
						/*
						Declare pr_envia_correo Procedure For pr_envia_correo(:ls_mensaje, &
									:is_mensaje_correo,33, :ls_usuario);
						Execute pr_envia_correo;
						If SQLCA.SQLCODE = -1 Then
							ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
							RollBack;
							MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Error enviando correo por inconveniente en el generar liquidacion" + ls_error, StopSign!)
							Close pr_envia_correo;
							Destroy lds_unidades;
							Return -1
						End If
						// Cierra el procedimiento almacenado declarado
						Close pr_envia_correo;
						*/
						uo_correo	lnv_correo
						lnv_correo = CREATE uo_correo
						
						TRY
							lnv_correo.of_enviar_correo('Preliquidacion OC ' + String(il_ordencorte), is_mensaje_correo,'generar_liquidacion', ls_usuario)
						CATCH(Exception ex)
							Messagebox("Error", ex.getmessage())
						END TRY
						
						DESTROY lnv_correo

						
					End if
					  
					Destroy lds_unidades;
					Return
				ELSE
					ROLLBACK;
					MessageBox('Error','No se pudo generar la preliquidaci$$HEX1$$f300$$ENDHEX$$n por diferencias de unidades.',StopSign!)
				END IF	 	  
		  ELSE
			  ROLLBACK;
			  MessageBox("Error Base Datos","Error al actualizar la base de datos",StopSign!)
			  Destroy lds_unidades;
			  Return
		  END IF
		ELSE
		  ROLLBACK;
		  MessageBox("Error DataWindow","Error al actualizar la informaci$$HEX1$$f300$$ENDHEX$$n de las capas",StopSign!)
		  Destroy lds_unidades;
		  Return
		END IF
	END IF
END IF

Destroy lds_unidades;
Return
end event

public function long of_validar_liquidacion (long al_ordencorte, long al_agrupacion, long al_basetrazo, long al_trazo);
Long ll_n, ll_reg, ll_orden_corte, ll_agrupacion, ll_basetrazo, ll_trazo, ll_raya
Long li_registros
uo_dsbase lds_raya10, lds_rayas, lds_preliquida


SELECT Count(*)
INTO :li_registros
FROM dt_liquidaxespacio
WHERE cs_orden_corte = :al_ordencorte AND
		cs_agrupacion = :al_agrupacion AND
		cs_base_trazos = :al_basetrazo AND
		cs_trazo = :al_trazo;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar existencia de la preliquidaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
	Return -1
END IF

IF li_registros > 0 THEN
	MessageBox("Advertencia...","Este espacio ya tiene preliquidaci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
END IF

//Traer la raya que se esta preliquidando para saber si es raya 10.
lds_raya10 = Create uo_dsbase
lds_raya10.DataObject = 'd_gr_raya_x_orden_corte_agrupacion'
lds_raya10.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

lds_rayas = Create uo_dsbase
lds_rayas.DataObject = 'd_gr_rayas_dif_10_x_orden_corte'
lds_rayas.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

lds_preliquida = Create uo_dsbase
lds_preliquida.DataObject = 'd_gr_liquidacion_x_orden_corte_agrupacio'
lds_preliquida.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())


//consulta la raya que se esta preliquidando para saber si es raya 10.
ll_n = lds_raya10.Of_Retrieve(al_ordencorte,al_agrupacion,al_basetrazo,al_trazo )

If ll_n > 0 Then
	//mira si la raya es 10
	If lds_raya10.GetItemNumber(1,'raya') = 10 Then
		//	El sistema busca las dem$$HEX1$$e100$$ENDHEX$$s rayas que tiene la orden de corte diferentes a la raya principal y que llevan trazos
		ll_n = lds_rayas.Of_Retrieve(al_ordencorte )
		If ll_n > 0 Then
			//recorre las rayas 
			For ll_n = 1 to lds_rayas.RowCount()
				//toma los datos
				ll_orden_corte = lds_rayas.GetItemNumber(ll_n,'cs_orden_corte')
				ll_agrupacion = lds_rayas.GetItemNumber(ll_n,'cs_agrupacion')
				ll_basetrazo = lds_rayas.GetItemNumber(ll_n,'cs_base_trazos')
				ll_trazo = lds_rayas.GetItemNumber(ll_n,'cs_trazo')
				ll_raya = lds_rayas.GetItemNumber(ll_n,'raya') 
				
				//mira si la raya ya esta preliquidada
				ll_reg = lds_preliquida.Of_Retrieve(ll_orden_corte, ll_agrupacion, ll_basetrazo, ll_trazo )
				If ll_reg > 0 Then
					If lds_preliquida.GetItemNumber(1,'liquidacion') = 0 Then
						MessageBox("Advertencia...","Se cancela el proceso porque primero debe preliquidar los complementos de la raya " &
										+ String(ll_raya) + ' Orden Corte ' + String(ll_orden_corte))
						Destroy lds_raya10
						Destroy lds_rayas
						Destroy lds_preliquida
						Return -1
					End if
				ElseIf ll_reg = 0 Then
					MessageBox("Advertencia...","Se cancela el proceso porque primero debe preliquidar los complementos de la raya " &
										+ String(ll_raya) + ' Orden Corte ' + String(ll_orden_corte))
					Destroy lds_raya10
					Destroy lds_rayas
					Destroy lds_preliquida
					Return -1
				ElseIf ll_reg < 0 Then
					MessageBox("Advertencia...","Ocurrio un inconveniente al consultar si las rayas distintas a 10 estan preliquidadas")
					Destroy lds_raya10
					Destroy lds_rayas
					Destroy lds_preliquida
					Return -1
				End if
			Next
		
		ElseIf ll_n < 0 Then
			MessageBox("Advertencia...","Ocurrio un inconveniente al consultar las rayas distintas a 10 para la Orden de Corte.")
			Destroy lds_raya10
			Destroy lds_rayas
			Destroy lds_preliquida
			Return -1
		End if
	End if
ElseIf ll_n < 0 Then
	MessageBox("Advertencia...","Ocurrio un inconveniente al revisar la raya para la Orden de Corte.")
	Destroy lds_raya10
	Destroy lds_rayas
	Destroy lds_preliquida
	Return -1
End if

Destroy lds_raya10
Destroy lds_rayas
Destroy lds_preliquida

Return 1
end function

public function long of_validar_unidades ();//metodo para determinar si las unidades de la raya que estan liquidando es igual a las unidades de
//las otras rayas
//jcrm
//agosto 23 de 2007
Long li_rayas
Long ll_result, ll_fila, ll_oc_hermana
Long ll_ordenes[]
Decimal{2} ldc_cantidad, ldc_cantraya,ldc_porc
DataStore lds_unidliq, lds_oc_hermanas
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte

//no validar mientras se organiza lo de duos
Return 0

lstr_parametros.entero[1] = il_ordencorte
lstr_parametros.entero[2] = il_agrupacion

lds_unidliq = Create DataStore
lds_unidliq.DataObject = 'ds_unidxrayaliq'
lds_unidliq.SetTransObject(sqlca)

lds_oc_hermanas = Create DataStore
lds_oc_hermanas.DataObject = 'dgr_oc_hermanas'
lds_oc_hermanas.SetTransObject(sqlca)

//	consulto el porcentaje permito en m_constantes_corte para la diferencia entre las unidades de ordenes de corte hermanas y rayas
	ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_PROG_LIQ')
//		
	If ldc_porc = -1 Then
      MessageBox('Error','No fue posible establecer el porcentaje permitido entre lo programado y lo liquidado.')		
		Return -1
	End if
		
	ldc_porc = ldc_porc/100

//primero se determina si hay mas rayas 
//se va a quitar este count para que siempre lo haga, si es una sola raya 
//no debe tener problemas, pero si son ordenes de corte hermanas hay que
//validar en las hermanas la cantidad
//jfzuleta  jorodrig   julio 3 - 09
//
//SELECT count(distinct cs_base_trazos)
//  INTO :li_rayas
//  FROM dt_liq_unixespacio
// WHERE cs_orden_corte = :il_ordencorte AND
// 		 cs_agrupacion  = :il_agrupacion;

	  
//IF li_rayas > 1 THEN
	SELECT sum(ca_liquidadas)
	  INTO :ldc_cantraya
	  FROM dt_liq_unixespacio
	 WHERE cs_orden_corte = :il_ordencorte AND
			 cs_agrupacion  = :il_agrupacion AND
			 cs_base_trazos = :il_basetrazo;

	ll_result = lds_oc_hermanas.Retrieve(il_ordencorte)
	FOR ll_fila = 1 TO ll_result
		ll_ordenes[ll_fila] = lds_oc_hermanas.GetitemNumber(ll_fila,'cs_asignacion')
	NEXT
	IF ll_result = 0 THEN
		ll_ordenes[1] = il_ordencorte
	END IF
	//se determina el numero de unidades liquidadas por raya
	ll_result = lds_unidliq.Retrieve(ll_ordenes, il_agrupacion, il_basetrazo)
	
	FOR ll_fila = 1 To ll_result
		ldc_cantidad = lds_unidliq.GetItemNumber(ll_fila,'ca_liquidadas')
		ll_oc_hermana = lds_unidliq.GetItemNumber(ll_fila,'cs_orden_corte')
		
		
		IF (ldc_cantraya >= (ldc_cantidad + (ldc_cantidad * ldc_porc))) OR  &
   		(ldc_cantraya <= (ldc_cantidad - (ldc_cantidad * ldc_porc)))THEN
		  
			// se muestra la ventana de unidades diferentes
			MessageBox('Advertencia','Las unidades Liquidadas no corresponden en todas las rayas, OC con diferentes Unidades: '+string(ll_oc_hermana))
			OpenWithParm(w_unidliqxraya, lstr_parametros,w_generar_liquidacion)
//			IF il_ordencorte <> ll_oc_hermana THEN
//				return -1				
//			END IF
//
		END IF
	NEXT
//ELSE
//	//solo existe una raya en la liquidaci$$HEX1$$f300$$ENDHEX$$n no debe validar aun
//	Return 0
//END IF

Return 0



//Este es el metodo que hay antes de hacer la validacion para las ordenes de corte hermanas, 
//se cambia el 3 de julio  jfzuleta y jorodrig.


////metodo para determinar si las unidades de la raya que estan liquidando es igual a las unidades de
////las otras rayas
////jcrm
////agosto 23 de 2007
//Long li_rayas
//Long ll_result, ll_fila
//Decimal{2} ldc_cantidad, ldc_cantraya
//DataStore lds_unidliq
//s_base_parametros lstr_parametros
//
//lstr_parametros.entero[1] = il_ordencorte
//lstr_parametros.entero[2] = il_agrupacion
//
//lds_unidliq = Create DataStore
//lds_unidliq.DataObject = 'ds_unidxrayaliq'
//lds_unidliq.SetTransObject(sqlca)
//
////primero se determina si hay mas rayas 
//
//SELECT count(distinct cs_base_trazos)
//  INTO :li_rayas
//  FROM dt_liq_unixespacio
// WHERE cs_orden_corte = :il_ordencorte AND
// 		 cs_agrupacion  = :il_agrupacion;
//		  
//IF li_rayas > 1 THEN
//	SELECT sum(ca_liquidadas)
//	  INTO :ldc_cantraya
//	  FROM dt_liq_unixespacio
//	 WHERE cs_orden_corte = :il_ordencorte AND
//			 cs_agrupacion  = :il_agrupacion AND
//			 cs_base_trazos = :il_basetrazo;
//
//	//se determina el numero de unidades liquidadas por raya
//	ll_result = lds_unidliq.Retrieve(il_ordencorte, il_agrupacion, il_basetrazo)
//	
//	FOR ll_fila = 1 To ll_result
//		ldc_cantidad = lds_unidliq.GetItemNumber(ll_fila,'ca_liquidadas')
//		
//		IF ldc_cantidad <> ldc_cantraya THEN
//			// se muestra la ventana de unidades diferentes
//			MessageBox('Advertencia','Las unidades Liquidadas no corresponden en todas las rayas.')
//			OpenWithParm(w_unidliqxraya, lstr_parametros,w_generar_liquidacion)
//		END IF
//	NEXT
//ELSE
//	//solo existe una raya en la liquidaci$$HEX1$$f300$$ENDHEX$$n no debe validar aun
//	Return 0
//END IF
//
//Return 0
//
end function

public function long of_traer_raya (long al_agrupacion, long al_base_trazos);Long	li_raya

SELECT MAX(raya)
INTO :li_raya
FROM h_base_trazos
WHERE cs_agrupacion = :al_agrupacion
AND cs_base_trazos = :al_base_trazos;

IF li_raya > 0 THEN
	Return li_raya
ELSE
	Return 0
END IF
end function

public function long of_validar_mercada (long al_ordencorte, long ai_raya);Long li_asignada, li_tipocorte, li_registros, li_result, li_fila, li_centro, li_estado_oc_raya, li_tipo
Long ll_rollo
n_cts_constantes luo_constantes
DataStore lds_rollos

lds_rollos = Create DataStore
lds_rollos.DataObject = 'ds_rollos_mercada_90'
lds_rollos.SetTransObject(sqlca)

luo_constantes = Create n_cts_constantes

li_asignada = luo_constantes.of_consultar_numerico("MERCADA ASIGNADA")

IF li_asignada = -1 THEN
	Return -1
END IF

li_tipocorte = luo_constantes.of_consultar_numerico("TIPO CORTE")

IF li_tipocorte = -1 THEN
	Return -1
END IF

SELECT Count(*)
INTO :li_registros
FROM h_mercada
WHERE cs_orden_corte = :al_ordencorte AND
		co_tipo_mercada = :li_tipocorte AND
		co_estado_mercada = :li_asignada;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar la mercada " + SQLCA.SQLErrText)
	Return -1
END IF

IF li_registros = 0 THEN
	MessageBox("Advertencia...","La mercada de esta orden de corte no ha sido asignada a la mesa")
	Return -1
END IF

//validar que los rollos esten el 90
//jorodrig - jcrm
//mayo 4 de 2009
li_result = lds_rollos.Retrieve(al_ordencorte,li_tipocorte,li_asignada)

FOR li_fila = 1 TO li_result
	li_centro = lds_rollos.GetItemNumber(li_fila,'co_centro')
	ll_rollo  = lds_rollos.GetItemNumber(li_fila,'cs_rollo')
	li_tipo   = lds_rollos.GetItemNumber(li_fila,'co_tipo')
	
	IF li_tipo <> 5 THEN
		MessageBox("Advertencia...","Rollo: "+String(ll_rollo)+' en un centro que no esta marcado como tipo corte.')
		Return -1
	END IF
NEXT


//Validar que este leida en el PDP en el proceso de Extendidoa (en dt_rayas_telaxoc en estado 13 o 14)
//jorodrig agosto 10 - 09
SELECT MAX(co_estado)
  INTO :li_estado_oc_raya
  FROM dt_rayas_telaxoc
 WHERE cs_orden_corte = :al_ordencorte
 AND raya = :ai_raya;
 IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar estado de la mercada " + SQLCA.SQLErrText)
	Return -1
END IF
 
IF li_estado_oc_raya < 13 THEN  //la orden aun no esta leida en extendido
	MessageBox("Advertencia","La orden de corte aun no se ha leido en Extendido en el PDP, lea primero el extendido y despues preliquide")
	Return -1
END IF


Return 1
end function

public function long of_comparar_unidades_prog_liq ();
/*
	se genera un correo autom$$HEX1$$e100$$ENDHEX$$tico, cuando las unidades cortadas sean inferiores a las unidades programadas en la Orden de producci$$HEX1$$f300$$ENDHEX$$n. 

*/

Long ll_filas, ll_ref, ll_reg, ll_color_prioridad
Long li_raya, li_fab, li_lin
Dec ldc_ca_liquidadas, ldc_programadas
String ls_cliente, ls_referencia, ls_color_prioridad
uo_dsbase lds_tipo_cliente, lds_cantidades


//se trae la raya
li_raya = of_traer_raya(il_agrupacion, il_basetrazo)

lds_tipo_cliente = Create uo_dsbase
lds_tipo_cliente.DataObject = 'd_gr_cliente_marca_x_oc_ref'
lds_tipo_cliente.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

lds_cantidades = Create uo_dsbase
lds_cantidades.DataObject = 'd_gr_cantidades_liq_prog_x_oc'
lds_cantidades.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

//limpia el campo del mensaje de correo
is_mensaje_correo = ''

//si es raya 10 se compara las unidades
If li_raya = 10 Then
	
	//consulta las cantidades
	ll_reg = lds_cantidades.Of_Retrieve(il_ordencorte)
	If ll_reg > 0 Then
		//mira si el estado para toda la OC es 6 (LIQ.COMPLETA), si vale 0 es porque no todas estan en estado 6
		If lds_cantidades.Getitemdecimal(1,'estado_liq') = 0 Then
			Destroy lds_tipo_cliente
			Destroy lds_cantidades
			Return 1
		End if
		
		//toma las cantidades
		ldc_ca_liquidadas = lds_cantidades.Getitemdecimal(1,'ca_liquidadas')
		ldc_programadas = lds_cantidades.Getitemdecimal(1,'ca_programadas')
	Elseif ll_reg = 0 Then
		Rollback;
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se encontro las cantidades liquidades y programadas para la Orden Corte " + String(il_ordencorte) + &
										' agrupacion ' + String(il_agrupacion) + ' base trazo'+ String(il_basetrazo) + 'trazo ' + String(il_trazo))
		Destroy lds_tipo_cliente
		Destroy lds_cantidades
		Return -1
	Else
		Rollback;
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al consultar las cantidades liquidades y programadas para la Orden Corte " + String(il_ordencorte) + &
										' agrupacion ' + String(il_agrupacion) + ' base trazo'+ String(il_basetrazo) + 'trazo ' + String(il_trazo))
		Destroy lds_tipo_cliente
		Destroy lds_cantidades
		Return -1
	End if
	
	//se mira que sea el cliente tipo exportacion o marca punto blanco
	FOR ll_filas = 1 TO dw_secciones_espacio.RowCount()
		//se toma la referencia
		li_fab = dw_secciones_espacio.GetItemNumber(ll_filas,'co_fabrica_pt')
		li_lin = dw_secciones_espacio.GetItemNumber(ll_filas,'co_linea')	
		ll_ref = dw_secciones_espacio.GetItemNumber(ll_filas,'co_referencia')
		
		//consulta el tipo cliente y marca
		ll_reg = lds_tipo_cliente.Of_Retrieve(il_ordencorte,li_fab,li_lin,ll_ref)
		If ll_reg > 0 Then
			//mira si el cliente es exportacion o la marca es puto blanco
			If trim(lds_tipo_cliente.GetItemString(1,'tipo_cliente')) = 'EX' or trim(lds_tipo_cliente.GetItemString(1,'co_marca')) = '07' Then
				// compara las cantidades
				If ldc_ca_liquidadas < ldc_programadas Then
					ls_cliente = trim(lds_tipo_cliente.GetItemString(1,'de_cliente'))
					If Isnull(ls_cliente) Then ls_cliente = ''
					ls_referencia = trim(lds_tipo_cliente.GetItemString(1,'de_referencia'))
					If Isnull(ls_referencia) Then ls_referencia = ''
					ll_color_prioridad = lds_tipo_cliente.GetItemNumber(1,'color_prioridad')
					If Isnull(ll_color_prioridad) Then ll_color_prioridad = 0
					//verifica la prioridad para dar el color
					Choose Case ll_color_prioridad
						Case 1
							ls_color_prioridad = 'NEGRO'
						Case 2
							ls_color_prioridad = 'ROJO'
						Case 3
							ls_color_prioridad = 'AMARILLO'
						Case 4
							ls_color_prioridad = 'VERDE'
						Case 5
							ls_color_prioridad = 'CYAN'
						Case else
							ls_color_prioridad = ''
					End Choose
					
					//se marca para que envie el correo
					is_mensaje_correo =ls_color_prioridad + ' - ' + ls_cliente + ' - ' + ls_referencia + ' U. Liquidadas ' + &
											String(ldc_ca_liquidadas) + ' U. Programadas ' + String(ldc_programadas) 


				End if
			End if
		Elseif ll_reg = 0 Then
			Rollback;
			MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se encontro tipo cliente y marca para la Orden Corte " + String(il_ordencorte) + &
											' Referencia ' + String(li_fab) + '-'+ String(li_lin)+'-'+String(ll_ref))
			Destroy lds_tipo_cliente
			Destroy lds_cantidades
			Return -1
		Else
			Rollback;
			MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al consultar el tipo cliente y marca para la Orden Corte " + String(il_ordencorte) + &
											' Referencia ' + String(li_fab) + '-'+ String(li_lin)+'-'+String(ll_ref))
			Destroy lds_tipo_cliente
			Destroy lds_cantidades
			Return -1
		End if
	Next
	
End if

Destroy lds_tipo_cliente
Destroy lds_cantidades
Return 1
end function

on w_generar_liquidacion.create
if this.MenuName = "m_generar_liquidacion" then this.MenuID = create m_generar_liquidacion
this.dw_secciones_espacio=create dw_secciones_espacio
this.em_espacio=create em_espacio
this.st_1=create st_1
this.Control[]={this.dw_secciones_espacio,&
this.em_espacio,&
this.st_1}
end on

on w_generar_liquidacion.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_secciones_espacio)
destroy(this.em_espacio)
destroy(this.st_1)
end on

event open;This.x = 1
This.y = 1

IF dw_secciones_espacio.SetTransObject(SQLCA) = -1 THEN
	MessageBox("Error","Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n")
	Close(This)
END IF

ib_grabar = True

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

type dw_secciones_espacio from datawindow within w_generar_liquidacion
integer x = 37
integer y = 128
integer width = 3232
integer height = 1308
integer taborder = 20
string title = "none"
string dataobject = "dgr_secciones_por_espacio"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Long li_capas, li_capas_prog, li_fab, li_lin, li_talla, li_espacio, li_capas_min, li_result, li_tipo_validar
Long ll_result, ll_ordencorte, ll_ref, ll_cliente, ll_unir_oc, ll_color_pt
Decimal ldc_porc
String ls_password, ls_password_ingresado, ls_mensaje
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte
n_cts_capas_prog_x_liq luo_capas
This.AcceptText()

choose case GetColumnName()
	case 'capas_liq'
	
	//primero se verifica que la variacion entre las capas programadas y liquidadas
	//no sea superior al porcentaje establecido
	li_capas 	= This.GetItemNumber(Row, 'capas_liq')
	li_capas_prog = This.GetItemNumber(Row,'capas')
	
//	ll_result = (li_capas * 100) / li_capas_prog
//	
//	if ll_result >= 100 Then
//		ll_result = ll_result - 100
//	else
//		ll_result = 100 - ll_result
//	end if	
//		
//	IF li_result > 5 Then
//		Messagebox('Error','La capas no estan dentro del rango permitido.',StopSign!)
//		ib_grabar = False
//		Return 2
//	End if
		
		
//	consulto el porcentaje permito en m_constantes_corte
	ldc_porc = lpo_const_corte.of_consultar_numerico('DIF_PROG_LIQ_JOCKEY')
//		
//	If ldc_porc = -1 Then
//      MessageBox('Error','No fue posible establecer el porcentaje permitido entre lo programado y lo liquidado.')		
//		ib_grabar = False
//		Return 
//	End if
		
	//**se comentarea a peticion de las personas del sue$$HEX1$$f100$$ENDHEX$$o de BTT octubre 29 de 2008	
	IF li_capas > li_capas_prog THEN
		//si la referencia es de linea y son de una o dos telas sin rectilineos se deja liquidar
		//reunion sue$$HEX1$$f100$$ENDHEX$$o de btt
		//abril 22 de 2009
		//jcrm
		li_fab			= This.GetItemNumber(row,'co_fabrica_pt')
		li_lin			= This.GetItemNumber(row,'co_linea')	
		ll_ref			= This.GetItemNumber(row,'co_referencia')
		ll_color_pt		= This.GetItemNumber(row,'co_color_pt')
		
		IF luo_capas.of_preliquidarcapaslinea(li_fab,li_lin,ll_ref,ll_color_pt,ls_mensaje) = -1 THEN
			MessageBox('Advertencia','Este estilo no es posible preliquidarlo con m$$HEX1$$e100$$ENDHEX$$s capas de las programadas.')
			//MessageBox('Error','Las capas Liquidadas son mayores  a las capas programadas. ',StopSign!)
		   ib_grabar = False
		   Return 2
		END IF

		//Maria Fernanda pide en marzo 25 del 2010 que no se deje liqudiar jockey en surtidos por encima del 102%,  
		//como al liberar se permite al 102 al liquidar solo se deja lo programado  realiza jorodrig marzo30-2010
		ll_cliente   = This.GetItemNumber(row,'co_cliente')
		ll_unir_oc   = This.GetItemNumber(row,'cs_unir_oc')
		li_tipo_validar   = This.GetItemNumber(row,'tipo_validar')
		
//se quita validacion, segun reunion del 19 de abril y correo de jdpelaez abril 20, el control queda en 
//el loteo, donde se mueve el sobrante a otra po.  jorodrig   abril 20-2010
//		IF ll_cliente = 9991 AND ll_unir_oc > 0 AND li_tipo_validar <> 4 THEN  //jockey surtidos
//			MessageBox('Advertencia','El cliente Jockey, en surtidos no permite liquidar capas por encima de lo programado, este control lo pide Planeacion.')
//		   ib_grabar = False
//		   Return 2
//		END IF
//				
		
	END IF
		
		//A peticion de Javier Garcia, se quita la opcion de que los jefes de salon autorizen
		//un numero de capas liquidadas diferentes en mas o menos un 5% a las capas programadas.
		//jcrm febrero 5 de 2007
		
	//**	MessageBox('Error','Las capas Liquidadas son mayores  a las capas programadas ',StopSign!)
		
		ll_ordencorte = This.GetItemNumber(row,'cs_orden_corte')
		li_fab			= This.GetItemNumber(row,'co_fabrica_pt')
		li_lin			= This.GetItemNumber(row,'co_linea')	
		ll_ref			= This.GetItemNumber(row,'co_referencia')
		li_talla			= 9999
		li_espacio     = This.GetItemNumber(row,'cs_trazo')
		
//grabar en log de capas liquidadas	
		if li_capas_prog <> li_capas THEN
			if luo_capas.of_validarCapas(ll_ordencorte,li_fab,li_lin,ll_ref,li_talla, li_capas_prog,li_capas,li_espacio) = -1 Then
//			This.SetItem(Row,'capas_liq',li_capas_prog)
//			This.AcceptText() 
//	**		ib_grabar = False
//**			Return 2
			end if
		end if
	//************************************ inicio modificaci$$HEX1$$f300$$ENDHEX$$n **************************************
	//modificacion solicitada en el sue$$HEX1$$f100$$ENDHEX$$o de recipiente perfecto, se necesita
	//validar que el numero de capas liquidadas no sea menor a las programadas
	//en un porcentaje mayor del 5%, de ser as$$HEX2$$ed002000$$ENDHEX$$el sistema exigira una clave para continuar
	//inicialmente la clave la tendra Javier Garcia, hasta que se tenga la forma de que sea
	//el encargado de calidad que validara el espacio antes de ser cortado, y no se dejaria 
	//preliquidar antes de tener la aceptaci$$HEX1$$f300$$ENDHEX$$n de calidad.
	//abril 9 de 2007
	//jcrm
	//se cambia la validacion del % de diferencia que estaba en el 1 % al 5% seguns e habia definido inicialmente
	//nov 11-2010 jorodrig

	//ahora se validad que las capas liquidadas no esten por debajo de las capas programadas
	//en porcentaje mayor al autorizado.
	
	li_result = luo_capas.of_preliquidacionCapas(il_ordencorte,il_agrupacion,il_basetrazo,il_trazo,li_capas)
	
	If li_result = 2 Then
		//mensage de utilizacion del trazo, no de be ser usado sin autorizaci$$HEX1$$f300$$ENDHEX$$n superior.
		MessageBox('Advertencia','Unidades preliquidadas por fuera del rango permitido, se necesita autorizaci$$HEX1$$f300$$ENDHEX$$n para programarlas.')
		IF gstr_info_usuario.co_planta_pro = 2 THEN
			ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZA UNID PRELIQ'))
		ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
			ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO NICOLE'))
		END IF
		//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
		Open(w_password_trazos)
		lstr_parametros = message.PowerObjectParm
		
		If lstr_parametros.hay_parametros = true Then
			ls_password_ingresado = Trim(lstr_parametros.cadena[1])
						
			If ls_password_ingresado = ls_password Then
				lstr_parametros.entero[1] = il_ordencorte
				OpenWithParm(w_observaciones_ordcte, lstr_parametros)
			Else
				MessageBox('Error','Password, no valido.')
				ib_grabar = False
				Return 2
			End if
		Else
			ib_grabar = False
			Return 2
		End if
	End if
	
	If li_result = -1 Then
		ib_grabar = False
		Return 2
	End if
	
	//************************************* fin modificaci$$HEX1$$f300$$ENDHEX$$n *****************************************
	ib_grabar = True
	
end choose

end event

type em_espacio from editmask within w_generar_liquidacion
integer x = 251
integer y = 28
integer width = 773
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "################"
end type

event modified;String ls_espacio
Long ll_count, ll_unir_oc, ll_valida_orden
Long	li_raya
s_base_parametros lstr_parametros
n_cst_orden_corte luo_corte

ls_espacio = em_espacio.Text

IF Len(ls_espacio) > 0 THEN
	IF Len(ls_espacio) = 15 THEN
		il_ordencorte = Long(Mid(ls_espacio, 1, 6))
		il_agrupacion = Long(Mid(ls_espacio, 7, 5))
		il_basetrazo  = Long(Mid(ls_espacio, 12, 2))
		il_trazo      = Long(Mid(ls_espacio, 14, 15))
	ELSEIF len(ls_espacio) = 14 THEN
		il_ordencorte = Long(Mid(ls_espacio, 1, 6))
		il_agrupacion = Long(Mid(ls_espacio, 7, 4))
		il_basetrazo  = Long(Mid(ls_espacio, 11, 2))
		il_trazo      = Long(Mid(ls_espacio, 13, 14))
	ELSEIF len(ls_espacio) = 16 THEN
		il_ordencorte = Long(Mid(ls_espacio, 1, 6))
		il_agrupacion = Long(Mid(ls_espacio, 7, 6))
		il_basetrazo  = Long(Mid(ls_espacio, 13, 2))
		il_trazo      = Long(Mid(ls_espacio, 15, 16))
	END IF

	li_raya = of_traer_raya(il_agrupacion, il_basetrazo)

   //valida que preliquide la O.C segun el orden del pdp
	ll_valida_orden = luo_corte.of_oc_a_preliquidar(il_ordencorte,li_raya)
	
	IF ll_valida_orden = -1 THEN
		MessageBox('Error',"O.C. no es la que sigue en el PDP")
		Return 
	END IF


	//modificacion pedida en el sue$$HEX1$$f100$$ENDHEX$$o de recipiente perfecto, para que pida autorizacion del auditor de calidad
	//antes de preliquidar un espacio.
	//mayo 9 de 2007
	//jcrm
	//se carga la aceptacion del auditor
//se comentarea la autorizacion del auditor a peticion de Javier Garcia
//jcrm
//junio 5 de 2007
//	OPen(w_autorizacion_espacio_calidad)
//	
//	SELECT COUNT(*)
//	  INTO :ll_count
//	  FROM mv_pre_espacio_auditor 
//	 WHERE cs_orden_corte = :il_ordencorte AND
//			 cs_agrupacion  = :il_agrupacion AND
//			 cs_base_trazos = :il_basetrazo AND
//			 cs_trazo 		 = :il_trazo;
//			 
//	IF sqlca.sqlcode = -1 Then
//		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar el auditor, ERROR: '+sqlca.SqlErrText, StopSign!)
//		Return
//	End if
//	
//	IF ll_count <= 0 Then
//		MessageBox('Error','El espacio no tiene la validaci$$HEX1$$f300$$ENDHEX$$n del auditor de calidad.', StopSign!)
//		Return
//	End if
//
	IF of_validar_mercada(il_ordencorte,li_raya) = 1 THEN
		IF of_validar_liquidacion(il_ordencorte, il_agrupacion, il_basetrazo, il_trazo) = 1 THEN
			//antes de mostrar los datos del espacio se verifica si esta orden de corte hace parte de un duo o conjunto
			ll_unir_oc = luo_corte.of_duo_conjunto(il_ordencorte)
			IF ll_unir_oc > 0 THEN
				//se muestran las demas ordenes de corte que componen dicho duo o conjunto.
				lstr_parametros.entero[1] = il_ordencorte
				lstr_parametros.entero[2] = ll_unir_oc
				OpenWithParm ( w_duo_conjunto, lstr_parametros )
			END IF
			
			dw_secciones_espacio.Retrieve(il_ordencorte, il_agrupacion, il_basetrazo, il_trazo)
		END IF
	END IF
END IF

end event

type st_1 from statictext within w_generar_liquidacion
integer x = 37
integer y = 36
integer width = 210
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Espacio:"
boolean focusrectangle = false
end type

