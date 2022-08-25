HA$PBExportHeader$n_cts_recalcular_unidades.sru
forward
global type n_cts_recalcular_unidades from nonvisualobject
end type
end forward

global type n_cts_recalcular_unidades from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_casosegunporc (long al_trazo, decimal adc_porc_trazo, decimal adc_porc_ficha)
public function long of_iniciartemporales (ref string as_mensaje)
public function long of_calcularmtsmod (ref string as_mensaje)
public function long of_recalcularoc (long al_agrupacion, long al_orden)
public function long of_validar_proporcion (long al_ordencorte, ref string as_mensaje)
public function long of_determinar_liberacion (long al_ordencorte, ref string as_mensaje)
public function long of_carga_automatica_trazos (long al_agrupacion, long al_orden_corte)
public function decimal of_metrosliberacionmodelo (long al_lib, string as_po, long ai_fab, long ai_lin, long al_ref, long al_color_pt, long al_modelo, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, ref string as_mensaje)
public function long of_trazomayorficha (long al_op, string as_po, long ai_talla, long al_color_pt, ref string as_mensaje, long al_lib, long al_modelo, decimal adc_porc_trazo, decimal adc_porc_ficha, long al_orden_corte, long ai_fab, long ai_lin, long al_ref, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, long al_unid_prog, long al_trazo)
public function long of_cargartempmt (long al_lib, long al_orden_corte, long al_modelo, long ai_talla, long al_trazo, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, decimal adc_metros, ref string as_mensaje)
public function long of_cargartempunid (long al_lib, string as_po, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long al_modelo, long ai_talla, long al_unidades, ref string as_mensaje, long al_unid_menos)
public function long of_trazomenorficha (long al_lib, string as_po, long ai_fab, long ai_lin, long al_ref, long al_color_pt, long al_modelo, long ai_talla, long al_unidades, decimal adc_porc_trazo, decimal adc_porc_ficha, ref string as_mensaje)
public function long of_calcularunidmodmin (long al_lib, string as_po, long ai_fab, long ai_lin, long al_ref, long al_color_pt, string as_mensaje)
end prototypes

public function long of_casosegunporc (long al_trazo, decimal adc_porc_trazo, decimal adc_porc_ficha);//metodo para determinar el procedimeinto que se debe seguir segun la diferencia entre los porcentajes
//de utilizacion
//jcrm - jorodrig
//enero 10 de 2008
Decimal{2} ldc_diferencia

If al_trazo = 0 Then Return 3 //no se debe hacer nada

ldc_diferencia = adc_porc_ficha - adc_porc_trazo

IF abs(ldc_diferencia) <= 0.1 Then Return 3 //no se debe hacer nada

If ldc_diferencia > 0.1 Then
	Return 2 //utilizacion trazo menor que el de la ficha
Else
	Return 1 //utilizacion trazo mayor que el de la ficha
End if





end function

public function long of_iniciartemporales (ref string as_mensaje);//metodo para borrar todos los datos de las temporales de unidades y metros
//utilizadas en el recalculo de unidades, por usuario


//se borran los datos de los metros
DELETE FROM temp_metros_sobra
WHERE usuario = :gstr_info_usuario.codigo_usuario;

IF sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.SqlErrText
	Return -1
End if


DELETE FROM temp_unidades_mas
WHERE usuario = :gstr_info_usuario.codigo_usuario;

IF sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.SqlErrText
	Return -1
End if

Return 0
end function

public function long of_calcularmtsmod (ref string as_mensaje);//metodo para actualizar los metros de los rollos cuando sobra tela para generar las unidades necesarias
//jcrm
//enero 17 de 2008
Decimal{2} ldc_metros_restar, ldc_metros_rollo
Long ll_rollo, ll_lib, ll_modelo, ll_reftel, ll_count, ll_color_te
Long li_result, li_fila, ll_i, li_metros, li_caract, li_diametro
DataStore lds_rollos, lds_metros

lds_rollos = Create DataStore
lds_metros = Create DataStore

lds_rollos.DataObject = 'ds_rollos_restar'
lds_metros.DataObject = 'ds_temp_metros_sobra'

lds_rollos.SetTransObject(sqlca)
lds_metros.SetTransObject(sqlca)

li_metros = lds_metros.Retrieve(gstr_info_usuario.codigo_usuario)

For ll_i = 1 To li_metros
	ll_lib		= lds_metros.GetItemNumber(ll_i,'cs_liberacion')
	ll_modelo	= lds_metros.GetItemNumber(ll_i,'co_modelo')
	ll_reftel	= lds_metros.GetItemNumber(ll_i,'co_reftel')	
	ll_color_te	= lds_metros.GetItemNumber(ll_i,'co_color_te')
	li_caract	= lds_metros.GetItemNumber(ll_i,'co_caract')
	li_diametro	= lds_metros.GetItemNumber(ll_i,'diametro')
	ldc_metros_restar	= lds_metros.GetItemNumber(ll_i,'kg_restar')
	
//se coloca en comentario y se cargan los kilos desde el datastore, pues este se encontr$$HEX1$$f300$$ENDHEX$$
//que sobra   jorodrig -  jcrestme  junio 16 2008
/*
	SELECT sum(ca_mts_restar)
	  INTO :ldc_metros_restar
	  FROM temp_metros_sobra
	 WHERE usuario = :gstr_info_usuario.codigo_usuario AND
			 cs_liberacion	= :ll_lib AND
			 co_modelo		= :ll_modelo AND
			 co_reftel		= :ll_reftel AND
			 co_color_te	= :ll_color_te AND
			 diametro		= :li_diametro AND
			 co_caract		= :li_caract;   
			 
	If sqlca.sqlcode = -1 Then
		as_mensaje = sqlca.SqlErrText
		Destroy lds_rollos
		Destroy lds_metros
		Return -1
	End if				 
*/

	IF ldc_metros_restar > 0 Then
		//se tienen los metros que se deben restar de los rollos utilizados en la liberacion, se deben recorrer los rollos
		//de menor a mayor
		li_result = lds_rollos.Retrieve(ll_lib,ll_modelo,ll_reftel,ll_color_te)
		
		For li_fila = 1 To li_result
			ll_rollo = lds_rollos.GetItemNumber(li_fila,'cs_rollo')
			ldc_metros_rollo = lds_rollos.GetItemNumber(li_fila,'ca_metros')
			
			If ldc_metros_rollo <= ldc_metros_restar Then
				//es porque no se debe tener en cuenta este rollo en la liberacion
				DELETE FROM dt_rollos_libera
				WHERE cs_liberacion 	= :ll_lib AND
						co_modelo		= :ll_modelo AND
						co_reftel		= :ll_reftel AND
						co_color_tela	= :ll_color_te AND
						cs_rollo			= :ll_rollo;
						
				If sqlca.sqlcode = -1 Then
					as_mensaje = sqlca.SqlErrText
					Destroy lds_rollos
					Destroy lds_metros
					Return -1
				End if				
				
				UPDATE dt_consumo_rollos
					SET ca_metros = ca_metros - :ldc_metros_rollo
				 WHERE cs_rollo = :ll_rollo;	
				
				If sqlca.sqlcode = -1 Then
					as_mensaje = sqlca.SqlErrText
					Destroy lds_rollos
					Destroy lds_metros
					Return -1
				End if	
				
				ldc_metros_restar -= ldc_metros_rollo;
				
			Else
			//los metros del rollo son mayores que los sobran se deben actualizar las cantidades.	
			  UPDATE dt_rollos_libera
				  SET ca_metros = ca_metros - :ldc_metros_restar
				WHERE cs_liberacion 	= :ll_lib AND
						co_modelo		= :ll_modelo AND
						co_reftel		= :ll_reftel AND
						co_color_tela	= :ll_color_te AND
						cs_rollo			= :ll_rollo;
						
				If sqlca.sqlcode = -1 Then
					as_mensaje = sqlca.SqlErrText
					Destroy lds_rollos
					Destroy lds_metros	
					Return -1
				Else
//					SElECT count(*)
//					  INTO :ll_count
//					  FROM dt_rollos_libera
//					 WHERE cs_liberacion = :ll_lib AND
//					 		 cs_rollo 		= :ll_rollo AND
//					 		 ca_metros 		= 0 AND
//							 ca_unidades 	= 0;
//							 
//					IF ll_count = 1 THEN
//						as_mensaje = 'Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.'
//						Return -1
//					END IF
				End if				
				
				UPDATE dt_consumo_rollos
					SET ca_metros = ca_metros - :ldc_metros_restar
				 WHERE cs_rollo = :ll_rollo;	
				
				If sqlca.sqlcode = -1 Then
					as_mensaje = sqlca.SqlErrText
					Destroy lds_rollos
					Destroy lds_metros
					Return -1
				End if	
			End if
		Next
	End if
Next

Destroy lds_rollos
Destroy lds_metros

Return 0
end function

public function long of_recalcularoc (long al_agrupacion, long al_orden);//metodo para generar el recalculo de unidades a partir de la agrupacion
//jcrm
//enero 9 de 2008
Long li_result, li_fila, li_dia, li_caract, li_talla, li_caso, &
		  li_caso1, li_fab, li_lin, li_caso2
Long ll_lib, ll_oc, ll_modelo, ll_trazo, ll_reftel, ll_op, ll_unid_prog, ll_ref, ll_color_te, ll_color_pt
Decimal{2} ldc_porc_trazo, ldc_porc_ficha
String ls_po, ls_mensaje
DataStore lds_datos_agrupacion

//se inicializan las tablas temporales de metros y unidades
If of_iniciarTemporales(ls_mensaje) = -1 Then
	Rollback;
	MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de inicializar las tablas temporales, ERROR: '+ls_mensaje,StopSign!)
	Return -1
End if
Commit;

lds_datos_agrupacion = Create DataStore
lds_datos_agrupacion.dataObject = 'ds_datos_agrupacion'
lds_datos_agrupacion.SetTransObject(sqlca)

li_result = lds_datos_agrupacion.Retrieve(al_agrupacion,al_orden)

//se traen los datos de la agrupacion
FOR li_fila = 1 To li_result
	 ll_lib 				= lds_datos_agrupacion.GetItemNumber(li_fila,'cs_liberacion')
	 ll_oc 				= lds_datos_agrupacion.GetItemNumber(li_fila,'cs_orden_corte')
	 ll_modelo 			= lds_datos_agrupacion.GetItemNumber(li_fila,'co_modelo')
	 ll_trazo 			= lds_datos_agrupacion.GetItemNumber(li_fila,'co_trazo')
	 li_talla 			= lds_datos_agrupacion.GetItemNumber(li_fila,'co_talla')
	 ldc_porc_trazo 	= lds_datos_agrupacion.GetItemNumber(li_fila,'porc_util')
	 ldc_porc_ficha 	= lds_datos_agrupacion.GetItemNumber(li_fila,'porc_utilizacion')
	 ll_unid_prog 		= lds_datos_agrupacion.GetItemNumber(li_fila,'ca_disponibles')
	 ll_op 				= lds_datos_agrupacion.GetItemNumber(li_fila,'cs_ordenpd_pt')
	 ls_po 				= lds_datos_agrupacion.GetItemString(li_fila,'po')
	 ll_reftel 			= lds_datos_agrupacion.GetItemNumber(li_fila,'co_reftel')
	 li_dia 				= lds_datos_agrupacion.GetItemNumber(li_fila,'diametro')
	 ll_color_te 		= lds_datos_agrupacion.GetItemNumber(li_fila,'co_color_te')
	 li_caract 			= lds_datos_agrupacion.GetItemNumber(li_fila,'co_caract')
	 ll_color_pt 		= lds_datos_agrupacion.GetItemNumber(li_fila,'co_color_pt')
	 li_fab 				= lds_datos_agrupacion.GetItemNumber(li_fila,'co_fabrica_pt')
	 li_lin 				= lds_datos_agrupacion.GetItemNumber(li_fila,'co_linea')
	 ll_ref 				= lds_datos_agrupacion.GetItemNumber(li_fila,'co_referencia')
	
	//se llama funcion para determinar que hacer dependiendo de la diferencia entre
	//los porcentajes de utilizacion del trazo y la ficha
	//li_caso = 3 no se hace nada
	//li_caso = 1 se ejecuta metodo of_trazoMayorFicha()
	//li_caso = 2 se ejecuta metodo of_trazoMenorFicha()
	li_caso = of_casoSegunPorc(ll_trazo,ldc_porc_trazo,ldc_porc_ficha)
	
	IF li_caso = 1 THEN
		//primero se verifica si la op - po se encuentra cumplida
		li_caso1 = of_trazomayorficha(ll_op,ls_po,li_talla,ll_color_pt,ls_mensaje,ll_lib,ll_modelo,ldc_porc_trazo,&
												ldc_porc_ficha,ll_oc,li_fab,li_lin,ll_ref,ll_reftel,li_caract,li_dia,ll_color_te,&
												ll_unid_prog,ll_trazo)
		If li_caso1 = -1 Then
			ls_mensaje = sqlca.sqlerrtext
			Rollback;
			Destroy lds_datos_agrupacion
			MessageBox('Error Base de Datos 1','Ocurri$$HEX2$$f3002000$$ENDHEX$$un problema al momento de consultar las unidades, ERROR: '+ls_mensaje,StopSign!)
			Return -1
		End if
	ELSEIF li_caso = 2 THEN
		li_caso2 = of_trazomenorficha(ll_lib,ls_po,li_fab,li_lin,ll_ref,ll_color_pt,ll_modelo,li_talla,ll_unid_prog,ldc_porc_trazo,ldc_porc_ficha,ls_mensaje)
		If li_caso2 = -1 Then
			ls_mensaje = sqlca.sqlerrtext
			Rollback;
			Destroy lds_datos_agrupacion
			MessageBox('Error Base de Datos 2','Ocurri$$HEX2$$f3002000$$ENDHEX$$un problema al momento de consultar las unidades, ERROR: '+ls_mensaje,StopSign!)
			Return -1
		End if
	END IF
NEXT

//actualizar unidades
//se recorre nuevamente los datos de la agrupacion para buscar que registros sufrieron alguna modificacion
FOR li_fila = 1 To li_result
	ll_lib 		= lds_datos_agrupacion.GetItemNumber(li_fila,'cs_liberacion')
   ls_po 		= lds_datos_agrupacion.GetItemString(li_fila,'po')
	ll_color_pt = lds_datos_agrupacion.GetItemNumber(li_fila,'co_color_pt')
	li_fab 		= lds_datos_agrupacion.GetItemNumber(li_fila,'co_fabrica_pt')
	li_lin 		= lds_datos_agrupacion.GetItemNumber(li_fila,'co_linea')
	ll_ref		= lds_datos_agrupacion.GetItemNumber(li_fila,'co_referencia')
	 
	If of_calcularunidmodmin(ll_lib,ls_po,li_fab,li_lin,ll_ref,ll_color_pt,ls_mensaje) = -1 Then
		ls_mensaje = sqlca.sqlerrtext
		Rollback;
		Destroy lds_datos_agrupacion
		MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades, ERROR: '+ls_mensaje,StopSign!)
		Return -1
	End if
NEXT

//se coloca en comentario ya que en la reunion de sue$$HEX1$$f100$$ENDHEX$$o de BTT, se solicito que el sistema no debe
//restar metros a los rollos utilizados en la liberacion, se va a crear una opcion en la mercada
//para que sea este el que determine si el rollo debe ser partido o si utiliza toda la tela
//jcrm
//octubre 31 de 2008

////actualizar metros
////se recorre nuevamente los datos de la agrupacion para buscar que registros sufrieron alguna modificacion
//FOR li_fila = 1 To li_result
//	If of_calcularmtsmod(ls_mensaje) = -1 Then
//		ls_mensaje = sqlca.sqlerrtext
//		Rollback;
//		Destroy lds_datos_agrupacion
//		MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los metros, ERROR: '+ls_mensaje,StopSign!)
//		Return -1
//	End if
//NEXT

UPDATE h_agrupa_pdn
   SET co_estado = 2
WHERE cs_agrupacion = :al_agrupacion;

IF sqlca.sqlcode = -1 Then
	ls_mensaje = sqlca.sqlerrtext
	Rollback;
	Destroy lds_datos_agrupacion
	MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la agrupaci$$HEX1$$f300$$ENDHEX$$n, ERROR: '+ls_mensaje,StopSign!)
	Return -1
End if


Commit;
MessageBox('Exito','Se genero el recalculo de unidades, por favor verifique los datos.',Exclamation!)

Destroy lds_datos_agrupacion

Return 0
end function

public function long of_validar_proporcion (long al_ordencorte, ref string as_mensaje);//metodo para validar la proporcion utilizada en el trazo respecto a la utilizada en
//la liberacion
//jcrm
//abril 29 de 2008
Long li_fila, li_result, li_fabrica, li_linea, li_result2, li_fila2, li_talla,&
  		  li_prop_talla, li_result3, li_prop_trazo
Long ll_liberacion, ll_ref
DataStore lds_pdn, lds_trazos, lds_talla

lds_pdn = Create DataStore
lds_trazos = Create DataStore
lds_talla = Create DataStore

lds_pdn.DataObject = 'ds_dt_pdnxmodulo_proporcion' //datos de dt_pdnxmodulo
lds_trazos.DataObject = 'ds_trazos_x_ordencorte' //datos de dt_trazosxoc
lds_talla.DataObject = 'ds_proporcion_talla' //datos de dt_talla_pdnmodulo

lds_pdn.SetTransObject(sqlca)
lds_trazos.SetTransObject(sqlca)
lds_talla.SetTransObject(sqlca)

//inicialmente esta liberacion solo se realizara para las liberacion make to stop
//por lo tanto se verifica que la orden de corte halla sido liberada de esta manera.
//*********************************************************************************
IF of_determinar_liberacion(al_ordencorte,as_mensaje) = -1 THEN
	as_mensaje = ''
	Return 100
END IF
//*********************************************************************************
//se traen los datos de dt_pdnxmodulo, para establecer la liberacion y la fabrica,
//linea y referencia
li_result = lds_pdn.Retrieve(al_ordencorte)
IF li_result > 0 THEN
	FOR li_fila = 1 TO li_result
		ll_liberacion = lds_pdn.GetItemNumber(li_fila,'cs_liberacion')
		li_fabrica = lds_pdn.GetItemNumber(li_fila,'co_fabrica_pt')
		li_linea = lds_pdn.GetItemNumber(li_fila,'co_linea')
		ll_ref = lds_pdn.GetItemNumber(li_fila,'co_referencia')
		//se establecen las tallas y la proporcion conque fue liberado
		li_result2 = lds_talla.Retrieve(ll_liberacion,li_fabrica,li_linea,ll_ref)
		IF li_result2 > 0 THEN
			FOR li_fila2 = 1 TO li_result2
				li_talla = lds_talla.GetItemnumber(li_fila2,'co_talla')
				li_prop_talla = lds_talla.GetItemNumber(li_fila2,'proporcion')
				//en este punto tenemos todos los datos para poder comparar la proporcion
				//de la liberacion con los paquetes de los trazos utilizados
				li_result3 = lds_trazos.Retrieve(al_ordencorte, li_fabrica, li_linea, ll_ref, li_talla)
				IF li_result3 > 0 THEN
					li_prop_trazo = lds_trazos.GetItemNumber(1,'ca_paquetes')
					//se comparan los resultados deben dar igual
					IF li_prop_trazo <> li_prop_talla THEN
						as_mensaje = 'Proporci$$HEX1$$f300$$ENDHEX$$n incorrecta, talla: '+String(li_talla)+' - Liberaci$$HEX1$$f300$$ENDHEX$$n: '+String(li_prop_talla)+ ' - Trazo: '+String(li_prop_trazo)
						Return -1
					END IF
				ELSE
					as_mensaje = 'No fue posible determinar los trazos asignados a la orden de corte.'
					Return -1
				END IF
			NEXT
		ELSE
			as_mensaje = 'No fue posible determinar la proporci$$HEX1$$f300$$ENDHEX$$n de la liberaci$$HEX1$$f300$$ENDHEX$$n.'
			Return -1
		END IF
	NEXT
ELSE
	as_mensaje = 'No se posible determinar la informaci$$HEX1$$f300$$ENDHEX$$n de la orden de corte.'
	Return -1
END IF

DESTROY lds_pdn;
DESTROY lds_trazos;
DESTROY lds_talla;

Return 0
end function

public function long of_determinar_liberacion (long al_ordencorte, ref string as_mensaje);//metodo para establecer a partir de la orden de corte si la liberacxion de la misma
//fue realizada por make to stop o make to order.
//jcrm
//abril 29 de 2008
Long ll_liberacion
Long li_est_lib


SELECT DISTINCT cs_liberacion
  INTO :ll_liberacion
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_ordencorte;

IF sqlca.sqlcode <> 0 THEN
	as_mensaje = 'No fue posible establecer la liberaci$$HEX1$$f300$$ENDHEX$$n, ERROR:'+ sqlca.SqlErrTExt
	Return -1
END IF

SELECT co_est_liberacion
  INTO :li_est_lib
  FROM h_liberar_escalas
 WHERE cs_liberacion = :ll_liberacion;

IF sqlca.sqlcode <> 0 THEN
	as_mensaje = 'No fue posible establecer el estado de la liberaci$$HEX1$$f300$$ENDHEX$$n, ERROR:'+ sqlca.SqlErrTExt
	Return -1
END IF

IF li_est_lib = 1 THEN
	Return 0
ELSE
	as_mensaje = ''
	Return -1
END IF


end function

public function long of_carga_automatica_trazos (long al_agrupacion, long al_orden_corte);//cargar los estilos, modelos, rayas, tallas y anchos que lleva la agrupacion
//por cada uno se busca que trazos cumplen

Long		li_filas, posi, posi2, li_filas2, posi3, li_filas3
Long		li_fab, li_lin, li_raya, li_tllas_prg, li_tlla_trazos, li_capas, li_raya_trazo, li_talla, li_propor
Long		ll_unid_tlla, li_inserto, li_tot_propor, li_tipo_trazo, li_existe, li_cs_pdn
Long			ll_ref, ll_trazo, ll_tela, ll_unit_tot
Decimal{2}	ld_ancho, ld_ancho_men, ld_util,ld_cm_restar, ld_ancho_trzo, ld_prc_uti_trzo
Decimal{2}	ld_prc_uti_fic, ldc_porc, ldc_porc_resta, ldc_porc_suma, ld_cal_prop_prog, ld_cal_prop_trzo
String		ls_de_trazo, ls_usuario
DataStore 	lds_estilos_rayas, lds_trazos_prob, lds_tallas_trazo, lds_unid_x_tlla_x_agrupa
n_cts_constantes_corte lpo_const_corte

li_inserto = 0
ld_cm_restar = 1

lds_estilos_rayas = Create DataStore
lds_estilos_rayas.DataObject = 'ds_estilos_rayas_tallas_x_agrupacion' //Datos de estilos ancho, rayas
lds_estilos_rayas.SetTransObject(sqlca)

lds_trazos_prob = Create DataStore
lds_trazos_prob.DataObject = 'ds_trazos_prob_x_estilo_ancho' //Datos de estilos ancho, rayas
lds_trazos_prob.SetTransObject(sqlca)


lds_tallas_trazo = Create DataStore
lds_tallas_trazo.DataObject = 'ds_tallas_trazo' //Datos de tallas de un trazo
lds_tallas_trazo.SetTransObject(sqlca)

lds_unid_x_tlla_x_agrupa = Create DataStore
lds_unid_x_tlla_x_agrupa.DataObject = 'ds_unid_x_tlla_x_agrupa' //Datos de unidades x talla programadas
lds_unid_x_tlla_x_agrupa.SetTransObject(sqlca)

ldc_porc = lpo_const_corte.of_consultar_numerico('PORC UTILIZACION TRAZO')
ls_usuario =  gstr_info_usuario.codigo_usuario

DELETE FROM tmp_trazos_sirve
WHERE usuario = :ls_usuario; 

li_filas = lds_estilos_rayas.Retrieve(al_agrupacion)

FOR posi =  1 TO li_filas
	li_fab 			= lds_estilos_rayas.GetitemNumber(posi,'co_fabrica_pt')
	li_lin 			= lds_estilos_rayas.GetitemNumber(posi,'co_linea')
	ll_ref 			= lds_estilos_rayas.GetitemNumber(posi,'co_referencia')
	ld_ancho 		= lds_estilos_rayas.GetitemNumber(posi,'ancho_cortable')
	ld_ancho_men  	= ld_ancho - ld_cm_restar
	li_raya  		= lds_estilos_rayas.GetitemNumber(posi,'raya')
	li_tllas_prg	= lds_estilos_rayas.GetitemNumber(posi,'talla_prog')
	ld_prc_uti_fic = lds_estilos_rayas.GetitemNumber(posi,'porc_util_ficha')
	ll_unit_tot 	= lds_estilos_rayas.GetitemNumber(posi,'ca_unidades')
	li_cs_pdn 		= lds_estilos_rayas.GetitemNumber(posi,'cs_pdn')
	ldc_porc_resta = ld_prc_uti_fic - ldc_porc
	ldc_porc_suma  = ld_prc_uti_trzo + ldc_porc
	
	//traer los trazos probables
	li_filas2 = lds_trazos_prob.Retrieve(li_fab, li_lin, ll_ref, li_raya)
//	li_filas2 = lds_trazos_prob.Retrieve(2, 81, 106019, 10)
	FOR posi2 = 1 TO li_filas2 
		ll_trazo 		= lds_trazos_prob.GetitemNumber(posi2,'co_trazo')
		ls_de_trazo 	= lds_trazos_prob.GetitemString(posi2,'de_trazo')
		ld_ancho_trzo	= lds_trazos_prob.GetitemNumber(posi2,'ancho')
		ld_prc_uti_trzo= lds_trazos_prob.GetitemNumber(posi2,'porc_util')
		li_tlla_trazos = lds_trazos_prob.GetitemNumber(posi2,'tot_tallas')
		li_raya_trazo  = lds_trazos_prob.GetitemNumber(posi2,'co_raya')
		
//		IF li_tllas_prg <> li_tlla_trazos THEN  //el trazo no servir, no tiene todas las tallas, busca el siguiente
//			Continue   
//		END IF
		IF ( ld_prc_uti_trzo < ldc_porc_resta) THEN // utilizacion del trazo inferior, no sirve
			Continue	//la utilizacion del trazo es menor que el de la ficha, el trazo no sirve
		END IF
		IF (ld_ancho_trzo = ld_ancho) OR (ld_ancho_men <= ld_ancho_trzo AND ld_ancho_trzo <= ld_ancho) THEN
		ELSE
			Continue  //el ancho del trazo esta por fuera del limite
		END IF
		
		li_filas3 = lds_tallas_trazo.Retrieve(ll_trazo,li_fab,li_lin,ll_ref)
		FOR posi3 = 1 TO li_filas3
			li_talla = lds_tallas_trazo.GetitemNumber(posi3,'co_talla')
			li_propor = lds_tallas_trazo.GetitemNumber(posi3,'ca_paquetes')
			li_tot_propor = lds_tallas_trazo.GetitemNumber(posi3,'tot_pqtes')
			ld_cal_prop_trzo = li_propor / li_tot_propor
			
			IF lds_unid_x_tlla_x_agrupa.Retrieve(al_agrupacion,li_cs_pdn,li_fab,li_lin,ll_ref,li_talla) > 0 THEN
				ll_unid_tlla = lds_unid_x_tlla_x_agrupa.GetitemNumber(1,'unid_tlla')
			ELSE
				ll_unid_tlla = 0
			END IF
			
			ld_cal_prop_prog = ll_unid_tlla / ll_unit_tot
			
			IF ld_cal_prop_prog = ld_cal_prop_trzo THEN
				li_tipo_trazo = 1
			ELSE
				//por ahora no se va a borrar, solo se va a marcar el trazo que cumple la condiccion de la proporcion
				//si no se encuentra ninguno que cumpla la proporcion hay si se pide al usuario que seleccione trazo
//				posi3 = li_filas3 + 1
//				If posi3 > 1 THEN   //ya inserto algo en la temporal, pero el trazo realmente no sirve, se borra de la temporal
//					DELETE FROM tmp_trazos_sirve WHERE usuario = :ls_usuario AND cs_agrupacion = :al_agrupacion
//					 		                         AND raya = :li_raya AND co_trazo = :ll_trazo;
//				END IF
//				Continue
				li_tipo_trazo = 0
			END IF
			
			li_capas = ceiling(ll_unit_tot / li_tot_propor)
			
			INSERT INTO tmp_trazos_sirve (usuario, cs_agrupacion, cs_pdn, cs_orden_corte, co_fabrica,
							co_linea, co_referencia, raya, porc_util_ficha, co_reftel, ancho_std, co_trazo, 
							de_trazo, capas, ancho_trazo, porc_util_trzo, co_talla, proporcion, unidades, tipo_trazo)
				VALUES ( :ls_usuario, :al_agrupacion, :li_cs_pdn, :al_orden_corte, :li_fab, :li_lin, :ll_ref,
				         :li_raya, :ld_prc_uti_fic, :ll_tela, :ld_ancho, :ll_trazo, :ls_de_trazo, :li_capas, 
							:ld_ancho_trzo, :ld_prc_uti_trzo, :li_talla, :li_propor, :ll_unid_tlla, :li_tipo_trazo);
			li_inserto = 1				
		NEXT

	NEXT
	
NEXT

//cerrar la transaccion, solo se ha cargado la tabla temporal
COMMIT;

IF li_inserto = 1 THEN
	Return 1   //se encontr$$HEX2$$f3002000$$ENDHEX$$algun trazo
ELSE
	Return 0
END IF



//si cumple las condiciones anteriores se hace un calculo de las capas probables a programar
//segun la proporcion y las unidades programadas
//si no qued ningun trazo se informa al usuario no existen trazos probables, si desea programar sin trazo


//mostrar la ventana para aceptar o rechazar.
DESTROY lds_estilos_rayas;
DESTROY lds_trazos_prob;
DESTROY lds_tallas_trazo;
DESTROY lds_unid_x_tlla_x_agrupa;

return 1

end function

public function decimal of_metrosliberacionmodelo (long al_lib, string as_po, long ai_fab, long ai_lin, long al_ref, long al_color_pt, long al_modelo, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, ref string as_mensaje);Decimal{2} ldc_metros

SELECT sum(ca_metros)
  INTO :ldc_metros
  FROM dt_rollos_libera
 WHERE cs_liberacion = :al_lib AND
 		 nu_orden		= :as_po AND
		 co_fabrica_pt	= :ai_fab AND
		 co_linea		= :ai_lin AND
		 co_referencia	= :al_ref AND
		 co_color_pt	= :al_color_pt AND
		 co_modelo		= :al_modelo AND
		 co_reftel		= :al_reftel AND
		 co_caract		= :ai_caract AND
		 diametro		= :ai_diametro AND
		 co_color_tela	= :al_color_te;
		 
IF sqlca.sqlcode = -1 OR IsNull(ldc_metros)Then
	as_mensaje = sqlca.SqlErrText
	Return -1
End if		 

Return ldc_metros
end function

public function long of_trazomayorficha (long al_op, string as_po, long ai_talla, long al_color_pt, ref string as_mensaje, long al_lib, long al_modelo, decimal adc_porc_trazo, decimal adc_porc_ficha, long al_orden_corte, long ai_fab, long ai_lin, long al_ref, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, long al_unid_prog, long al_trazo);//metodo para establecer si op - po estan cumplidas, y dependiendo de esto se sacan mas unidades o se resta tela.
//jcrm - jorodrig
//enero 10 de 2008

//modificacion mayo 14, sacar las unidades de mas, no dejar un poquito de tela sobrante
//jorodrig   mayo  14 -09 por reunion con ubeimar, jdpelaez, edwin serna, jhony martinez, chucho
Long ll_diferencia, ll_unid_mas, ll_result
Decimal{2} ldc_metros, ldc_met_nec

SELECT NVL(sum(ca_programada),0) - NVL(sum(ca_liberadas),0)
  INTO :ll_diferencia
  FROM dt_caxpedidos
 WHERE cs_ordenpd_pt = :al_op AND
 		 nu_orden		= :as_po AND
		 co_talla		= :ai_talla AND
		 co_color		= :al_color_pt;
	
IF sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.SqlErrText
	Return -1
End if

//ll_diferencia <= 0 se ejecuta metodo of_restarTela()
//ll_diferencia > 0 se ejecuta metodo of_aumentarUnidades()

//para que siempre se calculen las unidades de mas y no se reste tela se coloca la diferencia
//en cero, asi se va por el else siempre  jorodrig  mayo 14 - 09
ll_diferencia = 0

IF ll_diferencia < 0 Then  //se comenta mientras se determina que hacer con las unidades de mas
	//calcular metros
	ldc_metros = of_metrosLiberacionModelo(al_lib,as_po,ai_fab,ai_lin,al_ref,al_color_pt,al_modelo,al_reftel,ai_caract,ai_diametro,al_color_te,as_mensaje)
	If ldc_metros = -1 Then
		Return -1
	End if
	//se calculan los metros que sobran
	ldc_met_nec = ((100 * adc_porc_trazo) * ldc_metros) / (100 * adc_porc_ficha)
	ldc_metros = ldc_metros - ldc_met_nec
	//se inserta en la temporal temp_metros_sobra, esto para saber cuantos metros
	//se deben restar de los metros de la liberacion original
	If  of_cargartempmt(al_lib,al_orden_corte,al_modelo,ai_talla,al_trazo,al_reftel,ai_caract,ai_diametro,al_color_te,ldc_metros,as_mensaje) = -1 Then
		return -1
	End if
	//el else esta comentariado este se quita para permitir aumentar las unidades, esto se pidio en la reunion del sue$$HEX1$$f100$$ENDHEX$$o de BTT
	//jcrm
	//octubre 31 de 2008
Else
	ll_unid_mas =  (adc_porc_trazo * al_unid_prog) / adc_porc_ficha
	//se inserta o actualiza en la temporal temp_unidades_mas, esto para saber cuantas
	//unidades de mas se pueden programar
	if of_cargartempunid(al_lib,as_po,ai_fab,ai_lin,al_ref,al_color_pt,al_modelo,ai_talla,ll_unid_mas,as_mensaje,0) = -1 Then
		return -1
	End if
End if

Return 0

		 



end function

public function long of_cargartempmt (long al_lib, long al_orden_corte, long al_modelo, long ai_talla, long al_trazo, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, decimal adc_metros, ref string as_mensaje);//metodo para cargar la temporal de metros sobrantes
//jcrm - jorodrig
//enero 10 de 2008
INSERT INTO temp_metros_sobra  
         ( usuario,   
           cs_liberacion,   
           cs_orden_corte,   
           co_modelo,   
           co_talla,   
           co_trazo,   
           co_reftel,   
           co_caract,   
           diametro,   
           co_color_te,   
           ca_mts_restar )  
  VALUES ( :gstr_info_usuario.codigo_usuario,   
           :al_lib,   
           :al_orden_corte,   
           :al_modelo,   
           :ai_talla,   
           :al_trazo,   
           :al_reftel,   
           :ai_caract,   
           :ai_diametro,   
           :al_color_te,   
           :adc_metros )  ;

IF sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.SqlErrText
	Return -1
End if

Return 0
end function

public function long of_cargartempunid (long al_lib, string as_po, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long al_modelo, long ai_talla, long al_unidades, ref string as_mensaje, long al_unid_menos);//metodo para cargar la temporal de unidades de mas
//jcrm - jorodrig
//enero 10 de 2008
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM temp_unidades_mas  
 WHERE ( temp_unidades_mas.usuario 			= :gstr_info_usuario.codigo_usuario ) AND  
		 ( temp_unidades_mas.cs_liberacion 	= :al_lib ) AND  
		 ( temp_unidades_mas.po 				= :as_po ) AND  
		 ( temp_unidades_mas.co_fabrica 		= :ai_fab ) AND  
		 ( temp_unidades_mas.co_linea 		= :ai_linea ) AND  
		 ( temp_unidades_mas.co_referencia 	= :al_ref ) AND  
		 ( temp_unidades_mas.co_color_pt 	= :al_color_pt ) AND  
		 ( temp_unidades_mas.co_modelo 		= :al_modelo ) AND  
		 ( temp_unidades_mas.co_talla 		= :ai_talla )  ;

IF sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.SqlErrText
	Return -1
End if

If ll_count > 0 then
	UPDATE temp_unidades_mas
	   SET ca_unid_mas = ca_unid_mas + :al_unidades,
		    ca_unid_menos = ca_unid_menos + :al_unid_menos
	 WHERE ( temp_unidades_mas.usuario 		= :gstr_info_usuario.codigo_usuario ) AND  
		 ( temp_unidades_mas.cs_liberacion 	= :al_lib ) AND  
		 ( temp_unidades_mas.po 				= :as_po ) AND  
		 ( temp_unidades_mas.co_fabrica 		= :ai_fab ) AND  
		 ( temp_unidades_mas.co_linea 		= :ai_linea ) AND  
		 ( temp_unidades_mas.co_referencia 	= :al_ref ) AND  
		 ( temp_unidades_mas.co_color_pt 	= :al_color_pt ) AND  
		 ( temp_unidades_mas.co_modelo 		= :al_modelo ) AND  
		 ( temp_unidades_mas.co_talla 		= :ai_talla )  ;	
		 
	IF sqlca.sqlcode = -1 Then
		as_mensaje = sqlca.SqlErrText
		Return -1
	End if	 
Else
	INSERT INTO temp_unidades_mas  
         ( usuario,   
           cs_liberacion,   
           po,   
           co_fabrica,   
           co_linea,   
           co_referencia,   
           co_color_pt,   
           co_modelo,   
           co_talla,   
           ca_unid_mas,	
			  ca_unid_menos)  
  VALUES ( :gstr_info_usuario.codigo_usuario,   
           :al_lib,   
           :as_po,   
           :ai_fab,   
           :ai_linea,   
           :al_ref,   
           :al_color_pt,   
           :al_modelo,   
           :ai_talla,   
           :al_unidades,
			  :al_unid_menos)  ;
			
	IF sqlca.sqlcode = -1 Then
		as_mensaje = sqlca.SqlErrText
		Return -1
	End if		
End if

return 0
end function

public function long of_trazomenorficha (long al_lib, string as_po, long ai_fab, long ai_lin, long al_ref, long al_color_pt, long al_modelo, long ai_talla, long al_unidades, decimal adc_porc_trazo, decimal adc_porc_ficha, ref string as_mensaje);//metodo para restar unidades por utilizacion de trazo menor al de la ficha
//jcrm - jorodrig
//enero 10 de 2008
Long ll_unid_menos

ll_unid_menos = (adc_porc_trazo * al_unidades) / adc_porc_ficha


if of_cargartempunid(al_lib,as_po,ai_fab,ai_lin,al_ref,al_color_pt,al_modelo,ai_talla,0,as_mensaje,ll_unid_menos) = -1 Then
	return -1
End if



return 0
end function

public function long of_calcularunidmodmin (long al_lib, string as_po, long ai_fab, long ai_lin, long al_ref, long al_color_pt, string as_mensaje); //metodo para calcular las unidades minimas por modelo
//jcrm - jorodrig
//enero 11 de 2008
Long li_cont_min, li_cont_mas, li_talla, li_fila, li_cont_talla
Long ll_unid
DataStore lds_tallas

lds_tallas	 = Create DataStore
lds_tallas.DataObject = "ds_tallas_liberacion"
lds_tallas.SetTransObject(sqlca)

li_cont_talla = lds_tallas.Retrieve(al_lib,as_po,ai_fab,ai_lin,al_ref,al_color_pt)
//se recorren todas las tallas de la referencia
FOR li_fila = 1 To li_cont_talla
	li_talla = lds_tallas.GetItemNumber(li_fila,'co_talla')
	//se trae el valor minimo para la talla actual
	SELECT min(ca_unid_menos)
	  INTO :ll_unid
	  FROM temp_unidades_mas
	 WHERE cs_liberacion = :al_lib AND
	 		 po				= :as_po AND
			 co_fabrica		= :ai_fab AND
			 co_linea		= :ai_lin AND
			 co_referencia	= :al_ref AND
			 co_color_pt	= :al_color_pt AND
			 co_talla		= :li_talla;
			 
	If sqlca.sqlcode = -1 Then
		as_mensaje = sqlca.SqlErrText
		Destroy lds_tallas
		Return -1
	End if		 
	
	//si la talla no tiene valor menos se busca en el valor de mas
	If ll_unid = 0 Then
		SELECT min(ca_unid_mas)
		  INTO :ll_unid
		  FROM temp_unidades_mas
		 WHERE cs_liberacion = :al_lib AND
				 po				= :as_po AND
				 co_fabrica		= :ai_fab AND
				 co_linea		= :ai_lin AND
				 co_referencia	= :al_ref AND
				 co_color_pt	= :al_color_pt AND
				 co_talla		= :li_talla;
				 
		If sqlca.sqlcode = -1 Then
			as_mensaje = sqlca.SqlErrText
			Destroy lds_tallas
			Return -1
		End if		 
	End if
	
	//se verifica si existe valor, si es asi se modifica el dato en dt_talla_pdnmodulo,
	//de lo contrario el valor queda igual a como fue liberado y actualizo dt_talla_pdnmodulo (ca_programada)
	If ll_unid > 0 Then
		
		
//lo pongo en comentario el 14 de mayo para ver si es donde da$$HEX1$$f100$$ENDHEX$$a las unidades
//de tabla dt_talla_pndmodulo, jorodrig  mayo 14 - 09
		
		UPDATE dt_talla_pdnmodulo
		   //SET (ca_programada,ca_actual) = (:ll_unid,:ll_unid)   se coloca en comentario nov 24  por problema de unidades mas de las liberadas
			SET (ca_actual) = (:ll_unid)
			     
		 WHERE cs_liberacion = :al_lib AND
				 po				= :as_po AND
				 co_fabrica_pt	= :ai_fab AND
				 co_linea		= :ai_lin AND
				 co_referencia	= :al_ref AND
				 co_color_pt	= :al_color_pt AND
				 co_talla		= :li_talla;
				 
		If sqlca.sqlcode = -1 Then
			as_mensaje = sqlca.SqlErrText
			Destroy lds_tallas
			Return -1
		End if		 
	End if

NEXT

Destroy lds_tallas

return 0
end function

on n_cts_recalcular_unidades.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_recalcular_unidades.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

