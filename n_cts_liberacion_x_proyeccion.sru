HA$PBExportHeader$n_cts_liberacion_x_proyeccion.sru
forward
global type n_cts_liberacion_x_proyeccion from nonvisualobject
end type
end forward

global type n_cts_liberacion_x_proyeccion from nonvisualobject autoinstantiate
end type

type variables
Boolean ib_tanda

Datastore ids_rollos_liberacion_duo, ids_consumo_rollo_duo, ids_dt_talla_unid_duo, ids_dt_pdnxmodulo_duo, ids_dt_escalasxtela_duo
s_base_parametros  istr_param
cst_adm_conexion icst_lectura

end variables

forward prototypes
public function long of_cargar_unid_liberar ()
public function long of_borrarrollos (long al_rollo, string as_usuario, ref string as_mensaje)
public function long of_resetiarmarca (ref string as_mensaje)
public function long of_consecutivosolicitudcalidad (ref string as_mensaje)
public function long of_updaterollo (long al_rollo, string as_tono, long ai_estado, ref string as_mensaje)
public function long of_verificarconsumo (long al_rollo, ref string as_mensaje, long al_op)
public function long of_cons_lib_duo (ref long al_consecutivo, ref string as_mensaje)
public function long of_tipo_tejido (long al_reftel)
public function long of_verificar_duo_conjunto (long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, long ai_ano, long ai_semana)
public function long of_anular_liberacion_duo_conjunto (long al_cons_lib_duo)
public function long of_calcular_mt_sobra (long al_cons_lib_duo)
public function long of_igualar_unidades_duo (long al_cons_lib_duo)
public function long of_act_metros_lib_duo (long al_cons_lib_duo)
public function long of_igualar_dt_caxpedidos_duos (long al_cons_lib_duo)
public function long of_proporcion_duo (long al_unir_oc, long ai_talla)
public function long of_verificar_liberacion (long al_unir_oc)
public function long of_validar_duo_conjunto_op (long al_unir_op, ref string as_mensaje)
public function long of_consumo_rollo_15 (long al_rollo, ref decimal adc_metros, ref long al_unidades, ref long ai_centro, ref string as_mensaje)
public function long of_act_rollos_mt_unidades (long al_rollo, ref string as_mensaje)
public function long of_solicitud_partir_rollo (long al_rollo, long al_unidades, decimal adc_kilos, ref string as_mensaje)
public function long of_cargarrolloscalidad (ref string as_mensaje, string as_tono_requerido)
public function long of_estadorolloscalidad (string as_estado, long al_solicitud, long al_rollo)
public function long of_marcarrollos (string as_tono, long ai_fab, long ai_lin, long al_ref, long ai_caract, long ai_diametro, long al_color, long ai_tipo, ref string as_mensaje)
public function long of_revisar_si_bodysize (long ai_fabrica, long ai_linea, long al_referencia, long al_color_pt)
public function long of_contarmodelos (long ai_fab, long ai_lin, long al_ref, long al_color_pt, ref string as_mensaje)
public function long of_total_kg_proceso (long ai_fabrica, long ai_linea, long al_ref, long al_color_pt, long al_reftel, long al_color_te)
public function long of_buscar_op_estilo (long ai_fabrica, long ai_linea, long al_referencia, long al_color_pt, long ai_talla, long ai_anno, long ai_semana, long ai_tipo, long ai_duo)
public function long of_pedido_vs_liberacion (long ai_fab, long ai_linea, long al_ref, long al_color, long ai_talla, long ai_fab_exp, long ai_lin_exp, string as_ref_exp, string as_color_exp, string as_po, string as_talla_exp)
public function long of_cargar_rollos_tablas_liberacion (string as_usuario, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long al_ordenpd_pt, long ai_talla, decimal ad_porc_aplicar)
public function integer of_validar_op_rollo_consumido (long al_cs_rollo, long al_op_liberar, long al_op_agrupada)
public function long of_cargar_ref_tablas_liberacion (long ano, long semana, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long al_unid_color, long al_ordenpd_pt, string as_po, long ai_talla, string as_usuario, long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, integer ai_op_agrupada)
public function long of_cargar_temp_ref_liberar (string as_usuario, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long ai_talla_pt, long sw_bodysize, long a$$HEX1$$f100$$ENDHEX$$o, long semana, long al_op_estilo, long ai_fabrica_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, long al_op_agrupada, integer ai_cs_agrupa_lib)
end prototypes

public function long of_cargar_unid_liberar ();Long		ll_result
n_cts_cargar_temporales_liberacion luo_temporal
	
If luo_temporal.of_validarficha() = -1 Then//descomentado
	open(w_log_errores_liberacion)//abrir ventana del log de errores de liberacion
	Rollback;
	Return -1
Else
	If luo_temporal.of_cargar_modelos_unid() = -1 Then
		Rollback;
		Return -1
	End if
End if

Commit;

//ll_result = dw_maestro.Retrieve(ls_usuario)

//If ll_result > 0 Then
//Else
//	//MessageBox('Advertencia','No existe tela para cumplir el criterio.')//comentado
//	open(w_log_errores_liberacion)//abrir ventana del log de errores de liberacion
//End if
//	
	
Return 1
end function

public function long of_borrarrollos (long al_rollo, string as_usuario, ref string as_mensaje);//metodo para borrar rollos descartados por el usuario en la liberacion de ciritcas
//jcrm
//febrero 19 de 2008

DELETE FROM temp_ref_liberar
WHERE cs_rollo = :al_rollo AND
		usuario  = :as_usuario;
	
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
ELSE
	return 0
END IF
		
end function

public function long of_resetiarmarca (ref string as_mensaje);//metodo para marcar los rollos seleccionados por el usuario para la liberacion
//jcrm
//febrero 18 de 2008

UPDATE temp_ref_liberar  
  SET sw_marca = 0  
WHERE usuario		= :gstr_info_usuario.codigo_usuario;
		
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	return -1
END IF

Return 0
end function

public function long of_consecutivosolicitudcalidad (ref string as_mensaje);//metodo para obtener el consecutivo de la solictud de aprobacion de tonos
//para liberar produccion
//jcrm
//marzo 18 de 2008
Long ll_consecutivo

UPDATE cf_consecutivos
   SET cs_documento = cs_documento + 1
 WHERE co_fabrica = 2 AND
       id_documento = 61;
		 
IF sqlca.sqlcode = 0 THEN
	SELECT cs_documento
	  INTO :ll_consecutivo
	  FROM cf_consecutivos
	 WHERE co_fabrica = 2 AND
          id_documento = 61;
	IF sqlca.sqlcode <> 0 THEN
		as_mensaje = sqlca.sqlerrtext
		Rollback;
		Return -1
	END IF
ELSE
	as_mensaje = sqlca.sqlerrtext
	Rollback;
	Return -1
END IF

Return ll_consecutivo

end function

public function long of_updaterollo (long al_rollo, string as_tono, long ai_estado, ref string as_mensaje);//metodo para actualizar el estado del rollo y el tono en caso de ser diferente de ''
//jcrm
//abril 2 de 2008

IF as_tono <> '' THEN
	UPDATE m_rollo
	   SET co_estado_rollo = :ai_estado,
		    co_tono = :as_tono
	 WHERE cs_rollo = :al_rollo;
	 
	IF sqlca.sqlcode <> 0 THEN
		Rollback;
		as_mensaje = sqlca.SqlErrText
		Return -1
	END IF
ELSE
	UPDATE m_rollo
	   SET co_estado_rollo = :ai_estado
	 WHERE cs_rollo = :al_rollo;
	 
	IF sqlca.sqlcode <> 0 THEN
		Rollback;
		as_mensaje = sqlca.SqlErrText
		Return -1
	END IF
END IF

Return 0
end function

public function long of_verificarconsumo (long al_rollo, ref string as_mensaje, long al_op);//metodo para verificar si un rollo aparece con unidades o metros en dt_consumo_rollo
//esto es para evitar que este sea utilizado en las liberaciones hasta que no este
//completamente disponible
//esto se pidio por Federico Ospina en reunion con las personas de calidad
//Luz Amparo Ceballos.
//jcrm
//abril 1 de 2008
Decimal{2} ldc_metros, ldc_kilos
Long ll_unidades, ll_count, ll_tela, ll_tanda
Long li_existe

SELECT nvl(sum(ca_metros),0), nvl(sum(ca_unidades),0),  nvl(sum(kg_liberados),0)
  INTO :ldc_metros, :ll_unidades, :ldc_kilos
  FROM dt_consumo_rollos
 WHERE cs_rollo = :al_rollo;
 
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	return -1
END IF

IF ldc_metros = 0 AND ll_unidades = 0 OR ldc_kilos = 0 THEN
	//rollos sin ser usado, se permite ser usado en la liberaci$$HEX1$$f300$$ENDHEX$$n
	Return 0 
ELSE
	//rollo utilizado, debe verificarse si la liberacion es para la misma OP
	//del rollo, y no este en la tabla de calidad
	
	SELECT count(*)
	  INTO :ll_count
	  FROM h_aprueba_calidad_rollo
	 WHERE cs_rollo = :al_rollo AND
	 		 sw_marca = 0;
			  
	IF ll_count > 0 THEN
		as_mensaje = 'Rollo en espera de aprobaci$$HEX1$$f300$$ENDHEX$$n de calidad.'
		Return 2 
	ELSE
		//el rollo no esta en calidad, se verifica que pertenzca a la misma OP
		IF al_op = 0 THEN 
			Return 0 //el rollo es para ser utilizado para cargar la tabla de calidad, solo se validad que no tenga otras liberaciones
		ELSE
			SELECT count(*)
			  INTO :ll_count
			  FROM m_rollo
			 WHERE cs_rollo = :al_rollo AND
					 cs_orden_pr_act = :al_op;
					 
			IF ll_count > 0 THEN
				//el rollo es de la misma OP pude utilizarse
				
				//pero antes se verifica si el rollo tiene los chequeos de calidad
				//jcrm - jorodrig
				//mayo 20 de 2008
			
					 SELECT co_reftel_act
					   INTO :ll_tela
					   FROM m_rollo
					  WHERE cs_rollo = :al_rollo;
					
					 SELECT SUM(peso_desp_compac)
					   INTO :li_existe
					   FROM m_norma_cal
					  WHERE cs_tanda =  :ll_tanda
					    AND co_reftel = :ll_tela;
				
					IF li_existe > 0 THEN
						//No hay problema puede continuar
						Return 0
					ELSE
						//se va a verificar si es una OP agrupada.
						SELECT count(*) 
						  INTO :li_existe
						  FROM dt_ordenes_agrupad
						WHERE (cs_ordenpd_pt = :al_op OR cs_ordenpd_pt_agru = :al_op);
						IF li_existe > 0 THEN
							Return 0
						ELSE
					  //Rollo no se puede cargar porque no tiene chequeos
					  		Return 2
						END IF
					END IF
         		//fin modificacion
				Return 0
			ELSE
				//se va a verificar si es una OP agrupada.
				SELECT count(*) 
				  INTO :li_existe
				  FROM dt_ordenes_agrupad
				WHERE (cs_ordenpd_pt = :al_op OR cs_ordenpd_pt_agru = :al_op);
				IF li_existe > 0 THEN
					Return 0
				ELSE
			  //Rollo no se puede cargar porque no tiene chequeos
			  		Return 2
				END IF
			END IF
		END IF
	END IF
END IF
end function

public function long of_cons_lib_duo (ref long al_consecutivo, ref string as_mensaje);//metodo para establecer el consecutivo con el que van a quedar las liberaciones
//y de esta manera saber que liberaciones deben ir juntas en el proceso
//ya sea por que se trate de duos o conjuntos
//inicialmente solo se colocara a diferentes liberaciones el mismo consecutivo
//si es make to stock y las liberar en el mismo momento sin iniciar la ventana
//de telas existentes entre ambas liberaciones
//jcrm - jorodrig
//junio 26 de junio

UPDATE cf_consecutivos
   SET cs_documento = cs_documento + 1
 WHERE co_fabrica = 2 AND
       id_documento = 6;
		 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF

SELECT cs_documento
  INTO :al_consecutivo
  FROM cf_consecutivos
 WHERE co_fabrica = 2 AND
       id_documento = 6;
		 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = sqlca.sqlerrtext
	ROLLBACK;
	Return -1
ELSE
	COMMIT;
END IF		 

Return 0
end function

public function long of_tipo_tejido (long al_reftel);//para saber el tipo de tejido de una tela
//jcrm
//julio 28 de 2008
Long li_ttejido
String ls_error

SELECT co_ttejido
  INTO :li_ttejido
  FROM h_telas
 WHERE co_reftel = :al_reftel
   AND co_caract = 0;
	
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$el siguiente error al momento de consultar el tipo de tejido de la tela, ERROR: '+ls_error,StopSign!)
	Return -1
END IF

Return li_ttejido
end function

public function long of_verificar_duo_conjunto (long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, long ai_ano, long ai_semana);//metodo para verificar si una referencia de ventas es duo o cunjunto
//jcrm
//agosto 21 de 2008
Long ll_count
DataStore lds_duo

lds_duo = Create DataStore
lds_duo.DataObject = 'dgr_ref_equivalentes_make_to_order'
lds_duo.SetTransObject(sqlca)

ll_count = lds_duo.Retrieve(ai_fab_exp,&
									 ai_linea_exp,&
									 as_ref_exp,&
									 as_color_exp)
			 
Destroy lds_duo			 
IF ll_count > 1 THEN
	Return 1 //es duo o conjunto
Else
	IF ll_count = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error de bloqueo al momento de verificar el tipo de referencia, intente de nuevo.',StopSign!)
		Return -1
	ELSE
		Return 0 //es uno a uno en la equivalencia
	END IF
END IF





end function

public function long of_anular_liberacion_duo_conjunto (long al_cons_lib_duo);//metodo para anular las liberaciones de un duo o conjunto por deseo del usuario
//se envia el consecutivo de union de liberaciones y se colocan en estado anulado todas
//las liberaciones.
//jcrm - jorodrig
//agosto 26 de 2008
Long li_estado
String ls_error
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes;
//colocamos las liberaciones en estado anulado
li_estado = luo_constantes.of_consultar_numerico("ESTADO ANULADA")
IF li_estado = -1 THEN
	Messagebox("Error!","No se pudo anular la producci$$HEX1$$f300$$ENDHEX$$n, al determinar la constante de anulaci$$HEX1$$f300$$ENDHEX$$n.",StopSign!)
	Return -1
END IF

UPDATE dt_pdnxmodulo
   SET co_estado_asigna = :li_estado
 WHERE cs_unir_oc = :al_cons_lib_duo
   AND co_estado_asigna = 0;
 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','No fue posible anular las liberaciones, ERROR: '+ls_error,StopSign!)
	Return -1
END IF

//borramos la tabla temporal
DELETE FROM temp_unid_liberar_duo
 WHERE cs_lib_duo = :al_cons_lib_duo;

Return 0
 
 


end function

public function long of_calcular_mt_sobra (long al_cons_lib_duo);//Proceso para calcular en la tabla temporal de liberaciones t_unid_liberar_duo de duos y conjuntos cuantas
//unidades se deben liberar y con cuantos metros se debe dejar
//jcrestme - jorodrig   agosto 26 - 2008

Long	li_filas, li_fab_exp, li_linea_exp, posi, posi1, li_fab, li_linea, li_participacion
String	ls_ref_exp, ls_talla_exp, ls_color_exp, ls_filtro, ls_error, ls_ordenar	
Long		ll_unid_min, ll_unid_liberar, ll_ref, ll_cant_minima, ll_unid_min_pedido, ll_unid_pedido, ll_color
Decimal{2}	ld_mt_utiliza, ldc_mt_tot_lib
datastore	lds_temp_unid_liberar_duo, lds_mt_lib_ref, lds_sum_uni_temp_lid_duo
Decimal ld_participacion
s_base_parametros  lstr_parametros_retro

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Analizando unidades y metros minimos a liberar 2/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

lds_temp_unid_liberar_duo = Create DataStore
lds_mt_lib_ref = Create DataStore
lds_sum_uni_temp_lid_duo = Create DataStore

lds_temp_unid_liberar_duo.DataObject = 'ds_temp_unid_liberar_duo'
lds_mt_lib_ref.DataObject				 = 'dgr_mt_lib_x_ref'
lds_sum_uni_temp_lid_duo.DataObject  = 'dgr_sum_uni_temp_lid_duo'

lds_temp_unid_liberar_duo.SetTransObject(sqlca)
lds_mt_lib_ref.SetTransObject(sqlca)
lds_sum_uni_temp_lid_duo.SetTransObject(sqlca)

//hacemos un datastore de la tabla temporal duos y conjuntos con todos los datos por consecutivo
li_filas = lds_temp_unid_liberar_duo.Retrieve(al_cons_lib_duo)

IF li_filas = -1 THEN
	CLOSE(w_retroalimentacion)
	Return -2
End if

For posi = 1 To li_filas
	li_fab_exp = lds_temp_unid_liberar_duo.GetItemNumber(posi, 'co_fabrica_exp')
	li_linea_exp = lds_temp_unid_liberar_duo.GetItemNumber(posi, 'co_linea_exp')
	ls_ref_exp = lds_temp_unid_liberar_duo.GetItemString(posi, 'co_ref_exp')
	ls_talla_exp = lds_temp_unid_liberar_duo.GetItemString(posi, 'co_talla_exp')
	ls_color_exp = lds_temp_unid_liberar_duo.GetItemString(posi, 'co_color_exp')
	ll_cant_minima = lds_temp_unid_liberar_duo.GetItemNumber(posi, 'ca_minima')
	ls_filtro = 'co_fabrica_exp='+string(li_fab_exp) + ' and co_linea_exp='+string(li_linea_exp) &
	+ ' and co_ref_exp= '+"'"+ls_ref_exp+"'" + ' and co_color_exp='+"'"+ ls_color_exp +"'"+ 'and co_talla_exp='+"'"+ls_talla_exp+"'"
	lds_temp_unid_liberar_duo.SetFilter(ls_filtro) 
	lds_temp_unid_liberar_duo.Filter()
		
  
		
	//se trae el primer registro porque el dw esta ordenado por unidades
	ll_unid_min = lds_temp_unid_liberar_duo.GetItemNumber(1, 'ca_programada')
	ll_unid_min_pedido = lds_temp_unid_liberar_duo.GetItemNumber(1, 'ca_pedida')  //traer la cantidad del pedido para hacer la proporcion en los duos que van el doble de unidades en una talla
	//ahora actualizamos el dw con esta cantidad en el campo ca_minima
	FOR posi1 = 1 TO lds_temp_unid_liberar_duo.RowCount()
		//lds_temp_unid_liberar_duo.SetItem(posi1, 'ca_minima',ll_unid_min)
		ll_unid_pedido = lds_temp_unid_liberar_duo.GetItemNumber(posi1, 'ca_pedida')
		ld_participacion =  (ll_unid_pedido / ll_unid_min_pedido)
		li_participacion = (ld_participacion)
		lds_temp_unid_liberar_duo.SetItem(posi1, 'proporcion_tlla',li_participacion)
	NEXT
	
	
   ls_ordenar = "prog_calculada as"
	lds_temp_unid_liberar_duo.SetSort(ls_ordenar)
	lds_temp_unid_liberar_duo.Sort( )
	lds_temp_unid_liberar_duo.GroupCalc()
	
	ll_unid_min = lds_temp_unid_liberar_duo.GetItemNumber(1, 'prog_calculada')
	FOR posi1 = 1 TO lds_temp_unid_liberar_duo.RowCount()
		li_participacion = lds_temp_unid_liberar_duo.GetItemNumber(posi1, 'proporcion_tlla')
		lds_temp_unid_liberar_duo.SetItem(posi1, 'ca_minima',(ll_unid_min * li_participacion))
	NEXT
	
	//se quita el filtro para seguir con las demas tallas
	ls_filtro = ''
	lds_temp_unid_liberar_duo.SetFilter(ls_filtro) 
	lds_temp_unid_liberar_duo.Filter()
	
   ls_ordenar = "cs_lib_duo, co_fabrica_exp, co_linea_exp, co_ref_exp, co_color_exp, co_talla_exp, ca_pedida as, ca_programada"
	lds_temp_unid_liberar_duo.SetSort(ls_ordenar)
	lds_temp_unid_liberar_duo.Sort()
Next
//actualizamos los cambios en el datastore para utilizar el campo de unidades minimas mas adelante
lds_temp_unid_liberar_duo.Accepttext()
lds_temp_unid_liberar_duo.Update()
Commit;

//metros a liberar por referencia y modelo principal
li_filas = lds_mt_lib_ref.Retrieve(al_cons_lib_duo)  //este ds tiene el total de metros por estilo-color del modelo principal

IF li_filas = -1 THEN
	CLOSE(w_retroalimentacion)
	Return -2
End if

//segun las unidades por referencia se sabe si se va a utilizar toda la tela o se debe
//restar tela en la liberacion, se calcula el porcentaje de tela a utilizar en cada estilo del duo o conjunto
FOR posi = 1 To li_filas
	li_fab = lds_mt_lib_ref.GetItemNumber(posi,'co_fabrica_pt')
	li_linea = lds_mt_lib_ref.GetItemNumber(posi,'co_linea')
	ll_ref = lds_mt_lib_ref.GetItemNumber(posi,'co_referencia')
	ll_color = lds_mt_lib_ref.GetItemNumber(posi,'co_color_pt')
	ldc_mt_tot_lib = lds_mt_lib_ref.GetItemNumber(posi,'ca_metros')
	
	//ca_programadas y minimas por referencia - color
	lds_sum_uni_temp_lid_duo.Retrieve(al_cons_lib_duo,li_fab,li_linea,ll_ref,ll_color)  //este ds suma en la temporal de liberaciones las unidades
	ll_unid_liberar = lds_sum_uni_temp_lid_duo.GetItemNumber(1, 'ca_programada')
	ll_unid_min     = lds_sum_uni_temp_lid_duo.GetItemNumber(1, 'ca_minima')
		
	//calculamos los metros necesarios para las unidades minimas
	ld_mt_utiliza = (ll_unid_min * ldc_mt_tot_lib)  / ll_unid_liberar

	//convertirnos los metros necesarios a procentaje
	ld_mt_utiliza = (ld_mt_utiliza * 100 ) / ldc_mt_tot_lib
	UPDATE temp_unid_liberar_duo
	   SET porc_mt_utili = :ld_mt_utiliza
    WHERE cs_lib_duo 	= :al_cons_lib_duo
	   AND co_fabrica_pt	= :li_fab
		AND co_linea		= :li_linea
		AND co_referencia	= :ll_ref
		AND co_color_pt	= :ll_color;	
			
	IF sqlca.sqlcode = -1 THEN
		CLOSE(w_retroalimentacion)
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de modificar los metros por referencia, ERROR: '+ls_error,StopSign!)
		Return -1
	END IF	
NEXT

CLOSE(w_retroalimentacion)

//invocar funcion para modificar unidades en dt_talla_pdnmodulo, dt_escalasxtela y dt_pdnxmodulo
IF of_igualar_unidades_duo(al_cons_lib_duo) <> 1 THEN
	RETURN -2
END IF


//se va a colocar en comentario para no mandar a cortar rollos, pues desde la liberacion ya se definio la cantidad del rollo
//ensayo de jorodrig   agosto - 4-09
//////invocar funcion para actualizar los metros de los rollos
////IF of_act_metros_lib_duo(al_cons_lib_duo) <> 1 THEN
////	RETURN -2
////END IF
//
//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Grabando los datos de rollos y unidades por talla 5/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

//como se comentario la parte anterior donde llama la funcion of_act_metros_lib_duo tambien se quita esta parte
//dt_rollos_libera
//if ids_rollos_liberacion_duo.Update() = -1 THEN
//	Rollback;
//	CLOSE(w_retroalimentacion)
//	MessageBox('Error 1','No fue posible actualizar correctamente las liberaciones. ',StopSign!)
//	Return -1
//END IF
//
//dt_talla_pdnmodulo en ca_programada y ca_pendiente
IF ids_dt_talla_unid_duo.Update()  = -1 THEN
	Rollback;
	CLOSE(w_retroalimentacion)
	MessageBox('Error 4','No fue posible actualizar correctamente las liberaciones. ',StopSign!)
	Return -1
END IF

CLOSE(w_retroalimentacion)
//funcion para modificar las unidades en dt_caxpedidos
IF of_igualar_dt_caxpedidos_duos(al_cons_lib_duo) <> 1 THEN
	Return -1
END IF
//funcion para igualar las proporciones en dt_talla_pdnmodulo

Destroy lds_temp_unid_liberar_duo 
Destroy lds_mt_lib_ref 
Destroy lds_sum_uni_temp_lid_duo 



Commit;
MessageBox('Exito','Se igualaron las liberaciones exitosamente, por favor verificar la informaci$$HEX1$$f300$$ENDHEX$$n',Exclamation!)
return 1
end function

public function long of_igualar_unidades_duo (long al_cons_lib_duo);//metodo para igualar unidades a la menor por talla en las liberaciones de duos o conjuntos
//jcrm - jorodrig
//agosto 27 de 2008
Long li_fila, li_fila_talla, li_fab_exp, li_fab, li_linea_exp, li_linea, li_talla,li_filas_duo,&
	     li_fila1, li_fila_color, li_proporcion,ll_unid_restar, li_propor_tlla
String ls_ref_exp, ls_color_exp, ls_filtro, ls_error,ls_po
Long ll_ref, ll_unidades, ll_count, ll_unid_tot, ll_unid_talla, ll_liberacion, ll_op_estilo, ll_color
Decimal{5} ldc_tela, ldc_yield
DataStore lds_temp_unid_liberar_duo, lds_cant_lib_color, lds_mod_lib
s_base_parametros  lstr_parametros_retro

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Actualizando Unidades m$$HEX1$$ed00$$ENDHEX$$nimas en liberaciones 3/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

//crear data store de dt_talla_pdnmodulo y dt_pdnxmodulo que tengan el mismo al_cons_lib_duo, recorrer
ids_dt_talla_unid_duo = Create DataStore
lds_temp_unid_liberar_duo = Create DataStore
lds_cant_lib_color = Create DataStore
ids_dt_pdnxmodulo_duo = Create DataStore
ids_dt_escalasxtela_duo = Create DataStore
lds_mod_lib = Create DataStore

ids_dt_talla_unid_duo.DataObject = 'dgr_igualar_unidades_duos'
lds_temp_unid_liberar_duo.DataObject = 'ds_temp_unid_liberar_duo'
lds_cant_lib_color.DataObject = 'dgr_cantidades_liberaciones'
ids_dt_pdnxmodulo_duo.DataObject = 'ds_dt_pdnxmodulo_duo'
ids_dt_escalasxtela_duo.DataObject = 'ds_dt_escalasxtela_duo'
lds_mod_lib.DataObject = 'ds_dt_telasxmodelo_lib_duo'

ids_dt_talla_unid_duo.SetTransObject(sqlca)
lds_temp_unid_liberar_duo.SetTransObject(sqlca)
lds_cant_lib_color.SetTransObject(sqlca)
ids_dt_pdnxmodulo_duo.SetTransObject(sqlca)
ids_dt_escalasxtela_duo.SetTransObject(sqlca)
lds_mod_lib.SetTransObject(sqlca)

//retrieve de la tabla temporal duos y conjuntos con todos los datos por consecutivo
li_filas_duo = lds_temp_unid_liberar_duo.Retrieve(al_cons_lib_duo)

IF li_filas_duo = -1 THEN
	CLOSE(w_retroalimentacion)
	Return -2
End if
li_fila_talla = ids_dt_talla_unid_duo.Retrieve(al_cons_lib_duo)

IF li_fila_talla = -1 THEN
	CLOSE(w_retroalimentacion)
	Return -2
End if
FOR li_fila1 = 1 to li_filas_duo
	 li_fab_exp 	= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_fabrica_exp')
	 li_linea_exp 	= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_linea_exp')
	 ls_ref_exp 	= lds_temp_unid_liberar_duo.GetItemString(li_fila1,'co_ref_exp')
	 ls_color_exp 	= lds_temp_unid_liberar_duo.GetItemString(li_fila1,'co_color_exp')
	 li_fab 			= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_fabrica_pt')
	 li_linea 		= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_linea')
	 ll_color 		= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_color_pt')
	 li_talla 		= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_talla')
	 ll_ref 			= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'co_referencia')
	 ll_unidades 	= lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'ca_minima')
	 ll_unid_tot   = lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'ca_programada')
 	 li_propor_tlla  = lds_temp_unid_liberar_duo.GetItemNumber(li_fila1,'proporcion_tlla')
	 
	 
	
		 
	 ls_filtro = 'co_linea_exp='+string(li_linea_exp) &
		+ ' and co_ref_exp='+"'"+ls_ref_exp +"'"+ ' and co_color_exp='+"'"+ ls_color_exp +"'"+ ' and co_talla='+String(li_talla)&
		+ ' and co_color_pt='+String(ll_color)+' and co_referencia='+String(ll_ref)
		ids_dt_talla_unid_duo.SetFilter(ls_filtro) 
		ids_dt_talla_unid_duo.Filter() 			
		
	FOR li_fila_talla = 1 TO ids_dt_talla_unid_duo.RowCount()
		ll_unid_talla = ids_dt_talla_unid_duo.GetItemNumber(li_fila_talla,'ca_programada')
		ll_unid_talla = (ll_unid_talla * ll_unidades) / ll_unid_tot
				
		//actualizamos las cantidades en dt_talla_pdnmodulo
		ids_dt_talla_unid_duo.SetItem(li_fila_talla,'ca_programada',ll_unid_talla)
		ids_dt_talla_unid_duo.SetItem(li_fila_talla,'ca_pendiente',ll_unid_talla)
		ids_dt_talla_unid_duo.SetItem(li_fila_talla,'ca_proyectada',li_propor_tlla)
		
		
		//traemos los datos para realizar el update en dt_escalasxtela
		ll_liberacion = ids_dt_talla_unid_duo.GetItemNumber(li_fila_talla,'cs_liberacion')
		
		//se modifican las unidades en dt_escalasxtela
		ids_dt_escalasxtela_duo.Retrieve(ll_liberacion,li_fab,li_linea,ll_ref,ll_color,li_talla)
		
		IF ids_dt_escalasxtela_duo.RowCount() <= 0 THEN
			CLOSE(w_retroalimentacion)
			Return -2
		End if
		
		FOR li_fila = 1 To ids_dt_escalasxtela_duo.RowCount()
			 ids_dt_escalasxtela_duo.SetItem(li_fila,'ca_unidades',ll_unid_talla)
			 ids_dt_escalasxtela_duo.SetItem(li_fila,'usuario',gstr_info_usuario.codigo_usuario)
			 ids_dt_escalasxtela_duo.SetItem(li_fila,'fe_actualizacion',dateTime(Today(),Now()))
		NEXT
		ids_dt_escalasxtela_duo.AcceptText()
		
		IF ids_dt_escalasxtela_duo.Update() = -1 THEN
			Rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Error 3','No fue posible actualizar correctamente las unidades por talla. ',StopSign!)
			Return -1
		END IF
	NEXT
NEXT
ids_dt_talla_unid_duo.AcceptText()

//hacer modificacion de las unidades en dt_pdnxmodulo
li_fila_color = lds_cant_lib_color.Retrieve(al_cons_lib_duo)
IF li_fila_color = -1 THEN
	Return -2
End if
FOR  li_fila = 1 TO li_fila_color
	ll_liberacion = lds_cant_lib_color.GetItemNumber(li_fila,'cs_liberacion')
	ll_color 	  = lds_cant_lib_color.GetItemNumber(li_fila,'co_color_pt')
	ll_unidades   = lds_cant_lib_color.GetItemNumber(li_fila,'ca_programada')
	li_fab 		  = lds_cant_lib_color.GetItemNumber(li_fila,'co_fabrica_pt')
	li_linea 	  = lds_cant_lib_color.GetItemNumber(li_fila,'co_linea')
	ll_ref 		  = lds_cant_lib_color.GetItemNumber(li_fila,'co_referencia')
	
	ids_dt_pdnxmodulo_duo.Retrieve(ll_liberacion,ll_color)
	
	IF ids_dt_pdnxmodulo_duo.RowCount() <= 0 THEN
		CLOSE(w_retroalimentacion)
		Return -2
	End if
	
	ids_dt_pdnxmodulo_duo.SetItem(1,'ca_programada',ll_unidades)
	ids_dt_pdnxmodulo_duo.SetItem(1,'ca_pendiente',ll_unidades)
	ids_dt_pdnxmodulo_duo.SetItem(1,'co_estado_asigna',1)
	ids_dt_pdnxmodulo_duo.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
	ids_dt_pdnxmodulo_duo.SetItem(1,'fe_actualizacion',DateTime(Today(),Now()))
	ids_dt_pdnxmodulo_duo.AcceptText()
	IF ids_dt_pdnxmodulo_duo.Update() = -1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Error 5','No fue posible actualizar correctamente las liberaciones. ',StopSign!)
		Return -1
	END IF
	
	//se modifica la informacion en dt_telasxmodelo_lib
	li_filas_duo = lds_mod_lib.retrieve(ll_liberacion,li_fab,li_linea,ll_ref,ll_color)
	IF li_filas_duo = -1 THEN
		CLOSE(w_retroalimentacion)
		Return -2
	End if
	
	FOR li_fila1 = 1 TO li_filas_duo
		//traigo el yiel, y multiplicados las unidades tengo la ca_tela, en este punto modifico 
		//ca_unidades y ca_tela
		ldc_yield = lds_mod_lib.GetItemNumber(li_fila1,'yield')
		ldc_tela = ldc_yield * ll_unidades
		
		lds_mod_lib.SetItem(li_fila1,'ca_unidades',ll_unidades)
		lds_mod_lib.SetItem(li_fila1,'ca_tela',ldc_tela)
		lds_mod_lib.SetItem(li_fila1,'usuario',gstr_info_usuario.codigo_usuario)
		lds_mod_lib.SetItem(li_fila1,'fe_actualizacion',DateTime(Today(),Now()))
	NEXT
	
	lds_mod_lib.AcceptText()
	IF lds_mod_lib.Update() = -1 THEN
		//ensayo jorodrig,  estos datos que se actualizan en esta tabla no son tan necesarios y esta sacando constantemente
		//error de bloqueo se va a probar,  si hay problema entonces vamos a tener que cambiar este update por un update por sql.
//		Rollback;
//		CLOSE(w_retroalimentacion)
//		MessageBox('Error','No fue posible actualizar correctamente las unidades por modelo. ',StopSign!)
//		Return -1
	END IF
NEXT
ids_dt_pdnxmodulo_duo.AcceptText()
ids_dt_escalasxtela_duo.AcceptText()
CLOSE(w_retroalimentacion)

Destroy lds_temp_unid_liberar_duo
Destroy lds_cant_lib_color
Destroy lds_mod_lib

Return 1
end function

public function long of_act_metros_lib_duo (long al_cons_lib_duo);Long	li_filas, li_fab, li_linea, li_color_pt, posi, li_filas1, posi1
Long		ll_ref, ll_cs_rollo, ll_unidades, ll_unid_utilizar, ll_unid_lib
Decimal{2} ldc_mt_rollo, ldc_porc_mt, ldc_mt_lib, ldc_mt_utilizar
Datastore ldtb_porc_mt_temp_duo
s_base_parametros  lstr_parametros_retro

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Actualizando metros en liberaciones 4/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

ldtb_porc_mt_temp_duo 				= Create DataStore
ldtb_porc_mt_temp_duo.DataObject = 'dtb_porc_mt_temp_duo'
ldtb_porc_mt_temp_duo.SetTransObject(sqlca)

ids_rollos_liberacion_duo 				= Create DataStore
ids_rollos_liberacion_duo.DataObject = 'ds_rollos_liberacion_duo'
ids_rollos_liberacion_duo.SetTransObject(sqlca)

ids_consumo_rollo_duo = Create DataStore
ids_consumo_rollo_duo.DataObject = 'ds_consumo_rollo_duo'
ids_consumo_rollo_duo.SetTransObject(sqlca)

//hacemos un datastore de la tabla temporal duos y conjuntos con todos los datos por consecutivo
li_filas = ldtb_porc_mt_temp_duo.Retrieve(al_cons_lib_duo)

IF li_filas = -1 THEN
	CLOSE(w_retroalimentacion)
	Return -2
End if

FOR posi = 1 TO li_filas
	li_fab      = ldtb_porc_mt_temp_duo.GetitemNumber(posi, 'co_fabrica_pt')
	li_linea    = ldtb_porc_mt_temp_duo.GetitemNumber(posi, 'co_linea')
	ll_ref      = ldtb_porc_mt_temp_duo.GetitemNumber(posi, 'co_referencia')
	li_color_pt = ldtb_porc_mt_temp_duo.GetitemNumber(posi, 'co_color_pt')
	ldc_porc_mt	= ldtb_porc_mt_temp_duo.GetitemNumber(posi, 'porc_mt_utili')
	li_filas1   = ids_rollos_liberacion_duo.Retrieve(al_cons_lib_duo, li_fab, li_linea, ll_ref, li_color_pt)
	
	IF li_filas1 = -1 THEN
		CLOSE(w_retroalimentacion)
		Return -2
	End if
	
	FOR posi1 = 1 TO li_filas1
		ldc_mt_rollo = ids_rollos_liberacion_duo.GetItemNumber(posi1,'ca_metros')
		ll_cs_rollo	 = ids_rollos_liberacion_duo.GetItemNumber(posi1,'cs_rollo')
		ll_unidades	 = ids_rollos_liberacion_duo.GetItemNumber(posi1,'ca_unidades')
		//se determinan los metros a restar a el rollo
		ldc_mt_utilizar = (ldc_mt_rollo * ldc_porc_mt ) / 100 
		ll_unid_utilizar = (ll_unidades * ldc_porc_mt ) / 100
		
		//se actualiza el dato de metros en dt_rollos_libera
		ids_rollos_liberacion_duo.SetItem(posi1,'ca_metros',ldc_mt_utilizar)
		ids_rollos_liberacion_duo.SetItem(posi1,'ca_unidades',ll_unid_utilizar)
				
		//se actualiza en dt_consumo_rollos
		ids_consumo_rollo_duo.Retrieve(ll_cs_rollo)
		ldc_mt_lib  = ids_consumo_rollo_duo.GetItemNumber(1,'ca_metros')
		ll_unid_lib = ids_consumo_rollo_duo.GetItemNumber(1,'ca_unidades')
		
		ldc_mt_lib = ldc_mt_lib - (ldc_mt_rollo - ldc_mt_utilizar)
		ll_unid_lib = ll_unid_lib - ( ll_unidades - ll_unid_utilizar)
		ids_consumo_rollo_duo.SetItem(1,'ca_metros',ldc_mt_lib)
		ids_consumo_rollo_duo.SetItem(1,'ca_unidades',ll_unid_lib)
		ids_consumo_rollo_duo.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
		ids_consumo_rollo_duo.SetItem(1,'fe_actualizacion',DateTime(Today(),now()))
		
		//se graba dt_consumo_rollos
		ids_consumo_rollo_duo.Accepttext()
		IF ids_consumo_rollo_duo.Update()  = -1 THEN
			Rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Error 2','No fue posible actualizar correctamente los metros utilizados. (dt_consumo_rollos) ',StopSign!)
			Return -1
		END IF
	NEXT
	
	//se graba dt_rollos_libera
	ids_rollos_liberacion_duo.AcceptText()
	IF ids_rollos_liberacion_duo.Update()  = -1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Error 2.1','No fue posible actualizar correctamente los metros consumidos por las liberaciones. (dt_rollos_libera) ',StopSign!)
		Return -1
	END IF
NEXT

Destroy ldtb_porc_mt_temp_duo


CLOSE(w_retroalimentacion)
Return 1



end function

public function long of_igualar_dt_caxpedidos_duos (long al_cons_lib_duo);//metodo para actualizar las unidades en dt_caxpedidos, al momento de liberar duos y conjuntos
Long li_fila, li_i, li_fila_uni, li_fabrica, li_linea, li_talla, li_color
Long ll_ref, ll_op, ll_programada, ll_minima, ll_restar
String ls_filtro, ls_po, ls_error, ls_color_exp
DataStore lds_unidades, lds_temp_unid_lib_duo
s_base_parametros  lstr_parametros_retro

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Actualizando unidades liberadas en la OP 6/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

lds_unidades = Create DataStore
lds_temp_unid_lib_duo = Create DataStore

lds_unidades.DataObject = 'ds_tallas_cantidades_duos'
lds_temp_unid_lib_duo.DataObject = 'ds_temp_unid_liberar_duo'

lds_unidades.SetTransObject(sqlca)
lds_temp_unid_lib_duo.SetTransObject(sqlca)

li_fila_uni = lds_temp_unid_lib_duo.retrieve(al_cons_lib_duo)
IF li_fila_uni <= 0 THEN
	CLOSE(w_retroalimentacion)
	Return -2
END IF

li_fila = lds_unidades.Retrieve(al_cons_lib_duo)
IF li_fila <= 0 THEN
	CLOSE(w_retroalimentacion)
	Return -2
END IF

FOR li_i = 1 TO li_fila
	li_fabrica = lds_unidades.GetItemNumber(li_i,'co_fabrica_pt')
	li_linea   = lds_unidades.GetItemNumber(li_i,'co_linea')
	ll_ref 	  = lds_unidades.GetItemNumber(li_i,'co_referencia')
	li_talla   = lds_unidades.GetItemNumber(li_i,'co_talla')
	li_color   = lds_unidades.GetItemNumber(li_i,'co_color_pt')
	ll_op 	  = lds_unidades.GetItemNumber(li_i,'cs_ordenpd_pt')
	ls_po		  = lds_unidades.GetItemString(li_i,'po')	 
	ls_color_exp = lds_unidades.GetItemString(li_i,'co_color_exp')
	
	
	ls_filtro = 'co_fabrica_pt='+String(li_fabrica)+' and co_linea='+string(li_linea) &
		+ ' and co_referencia='+String(ll_ref) + ' and co_color_pt='+ String(li_color) + 'and co_talla='+String(li_talla)
	lds_temp_unid_lib_duo.SetFilter(ls_filtro) 
	lds_temp_unid_lib_duo.Filter() 			
	
	ll_programada = lds_temp_unid_lib_duo.GetItemNumber(1,'ca_programada')
	ll_minima	= lds_temp_unid_lib_duo.GetItemNumber(1,'ca_minima')
	
	IF ll_programada <> ll_minima THEN
		ll_restar = ll_programada - ll_minima
		UPDATE dt_caxpedidos
		   SET ca_liberadas = ca_liberadas - :ll_restar
		 WHERE cs_ordenpd_pt = :ll_op
		   AND nu_orden 		= :ls_po
			AND co_talla 		= :li_talla
			AND co_color 		= :li_color
			AND color_exp  = :ls_color_exp;
		
		IF sqlca.sqlcode <> 0 THEN
			ls_error = sqlca.sqlerrtext
			Rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades liberadas de la O.P. ERROR. '+ls_error,StopSign!)
			Return -1
		END IF
	END IF
NEXT

Destroy lds_unidades
Destroy lds_temp_unid_lib_duo

CLOSE(w_retroalimentacion)
Return 1
end function

public function long of_proporcion_duo (long al_unir_oc, long ai_talla);//metodo para establecer la proporcion para una talla de una liberacion de duo o conjunto
//jcrm
//septiembre 9 de 2008
Long li_proporcion

icst_lectura = create  cst_adm_conexion

SELECT DISTINCT proporcion
  INTO :li_proporcion 
  FROM dt_talla_pdnmodulo a, 
  		 dt_pdnxmodulo b
 WHERE a.cs_liberacion = b.cs_liberacion
   AND b.cs_unir_oc = :al_unir_oc
	AND a.co_talla = :ai_talla
 USING icst_lectura.of_get_transaccion_sucia()	; 
	
IF IsNull(li_proporcion) THEN li_proporcion = 0 	
  
icst_lectura.of_destruir_dirty_read( )  
Return li_proporcion
end function

public function long of_verificar_liberacion (long al_unir_oc);//metodo para determinar si una liberacion de duo o conjunto ya fue realizada,, esto para no permitir volver a generarla
//jcrm - jorodrig
//septiembre 9 de 2008
//li_result = 0 ya se genero la liberacion
//li_result > 0 la liberacion esta pendiente de ser igualada.
Long li_result

icst_lectura = create  cst_adm_conexion

SELECT count(*)
  INTO :li_result
  FROM dt_pdnxmodulo
 WHERE cs_unir_oc = :al_unir_oc
   AND co_estado_asigna = 0
 USING icst_lectura.of_get_transaccion_sucia()		;
	
icst_lectura.of_destruir_dirty_read( )  	

Return li_result
end function

public function long of_validar_duo_conjunto_op (long al_unir_op, ref string as_mensaje);//metodo para establecer si una OP de estilo tiene asociadas otras OP, esto para saber si deben ser liberadas
//de manera conjunta
//jcrm
//enero 22 de 2009
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM h_ordenpd_pt
 WHERE cs_unir_op = :al_unir_op;

IF sqlca.sqlcode <> 0 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF
 
IF ll_count > 1 THEN
	Return 0 //tiene asociadas otras OP
Else
	Return 2 //no tiene asociadas otras OP
END IF
 
 
 
 
end function

public function long of_consumo_rollo_15 (long al_rollo, ref decimal adc_metros, ref long al_unidades, ref long ai_centro, ref string as_mensaje);//se establecen los metros o unidades que tiene un rollo en dt_consumo_rollos y el centro del rollo
//jcrm
//febrero 13 de 2009

SELECT ca_metros, ca_unidades
  INTO :adc_metros, :al_unidades
  FROM dt_consumo_rollos
 WHERE cs_rollo = :al_rollo;
 
IF sqlca.sqlcode = 100 THEN 
	adc_metros = 0
	al_unidades = 0
	as_mensaje = 'El rollo no tiene ni metros ni unidades liberados.'
	Return -1
END IF

//se determina el centro del rollo
SELECT co_centro
  INTO :ai_centro
  FROM m_rollo
 WHERE cs_rollo = :al_rollo; 
 
IF ai_centro <> 15 THEN
	as_mensaje = 'Rollo en centro: '+String(ai_centro)
	//ai_centro = 0
	Return -1
END IF

Return 0
end function

public function long of_act_rollos_mt_unidades (long al_rollo, ref string as_mensaje);//metodo para colocar en cero los metros y unidades de los rollos para que estos puedan ser utilizados
//en las liberaciones
//jcrm
//febrero 13 de 2009
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM dt_rollos_libera, dt_pdnxmodulo
 WHERE dt_rollos_libera.cs_liberacion = dt_pdnxmodulo.cs_liberacion AND
       dt_rollos_libera.cs_rollo = :al_rollo AND
		 dt_pdnxmodulo.co_estado_asigna not in (15,28);
		 
IF sqlca.sqlcode = -1 THEN
	as_mensaje = 'Error base de datos: '+sqlca.sqlerrtext
	Return -1
END IF

IF ll_count = 0 THEN
	//se mira si el rollo no existe en una reposicion
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_rollosreposicio dt, h_reposicion_tela h 
	 WHERE dt.cs_rollo = :al_rollo AND
	  		 dt.cs_reposicion = h.cs_reposicion AND
			 h.co_estadoreposicio = 1;
	 
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = 'Error base de datos: '+sqlca.sqlerrtext
		Return -1
	END IF
	IF ll_count = 0 THEN
		//se pueden colocar unidades y metros en cero
		UPDATE dt_consumo_rollos
			SET ca_metros = 0,
				 ca_unidades = 0
		 WHERE cs_rollo = :al_rollo;
		 
		IF sqlca.sqlcode = -1 THEN
			as_mensaje = 'Error base de datos: '+sqlca.sqlerrtext
			Return -1
		END IF
		
		//se puede colocar la orden de corte en cero en el rollo
		UPDATE m_rollo
		   SET cs_ordencr = 0
		 WHERE cs_rollo = :al_rollo;	
		
		IF sqlca.sqlcode = -1 THEN
			as_mensaje = 'Error base de datos: '+sqlca.sqlerrtext
			Return -1
		END IF
		
		Return 0
	ELSE
		as_mensaje = 'El rollo esta siendo utilizado en una reposici$$HEX1$$f300$$ENDHEX$$n.'
		return -1
	END IF
ELSE
	as_mensaje = 'Existen liberaciones activas que estan usando el rollo'
	return -1
END IF


end function

public function long of_solicitud_partir_rollo (long al_rollo, long al_unidades, decimal adc_kilos, ref string as_mensaje);//se genera la solicitud para partir rollo y que este pueda ser utilizado en la liberacion,
//esta opcion sera utilizada por el personal de planeacion
//jcrm
//marzo 31 de 2009

INSERT INTO temp_rollos_partir  
         ( cs_rollo_padre,   
           ca_kg,   
           asignado,   
           cs_orden_pr_act,   
           proceso,   
           partido_fisico,   
           cs_mercada,   
           raya,   
           ca_metros )  
  VALUES ( :al_rollo,   
           :adc_kilos,   
           :al_unidades,   
           0,   
           5,   
           'f',   
           0,   
           0,   
           0 )  ;
			  
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF


Return 0
end function

public function long of_cargarrolloscalidad (ref string as_mensaje, string as_tono_requerido);//metodo para cargar los rollos selecionados a la tabla que sera utilizada por las personas de calidad
//jcrm
//febrero 21 de 2008
Long li_fab, li_lin, li_color_pt, li_color_te, li_dia, li_caract,&
		  li_rollos, li_fila, li_dias_criticas, li_result
Long ll_ref, ll_reftel, ll_unid, ll_rollo, ll_unid_rollo, ll_solicitud,&
     ll_tanda, ll_count
Decimal{2} ldc_kilos_nec, ldc_kg_rollo, ldc_mt_nec, ldc_mt_rollo
String ls_tono, ls_mensaje
DataStore lds_rollos

lds_rollos = Create DataStore
lds_rollos.DataObject = 'ds_temp_ref_liberar'
lds_rollos.SetTransObject(sqlca)

li_rollos = lds_rollos.Retrieve(gstr_info_usuario.codigo_usuario)

IF li_rollos <= 0 THEN
	as_mensaje = 'No fue posible determinar los rollos.'
	Return -1
END IF

//se obtiene el numero de solicitud 
ll_solicitud = of_consecutivoSolicitudCalidad(as_mensaje)
IF ll_solicitud = -1 THEN
	Rollback;
	Return -1
END IF

FOR li_fila = 1 TO li_rollos
	li_fab 			= lds_rollos.GetItemNumber(li_fila,'co_fabrica')  
	li_lin 			= lds_rollos.GetItemNumber(li_fila,'co_linea')
	ll_ref 			= lds_rollos.GetItemNumber(li_fila,'co_referencia')   
	li_color_pt 	= lds_rollos.GetItemNumber(li_fila,'co_color_pt')  
	ll_reftel 		= lds_rollos.GetItemNumber(li_fila,'co_reftel')   
	li_caract 		= lds_rollos.GetItemNumber(li_fila,'co_caract')   
	li_dia 			= lds_rollos.GetItemNumber(li_fila,'diametro')   
	li_color_te 	= lds_rollos.GetItemNumber(li_fila,'co_color_te')   
	ll_unid 			= lds_rollos.GetItemNumber(li_fila,'unid_liberar')   
//	ldc_kilos_nec 	= lds_rollos.GetItemNumber(li_fila,'kg_necesarios')   
	ldc_mt_nec 		= lds_rollos.GetItemNumber(li_fila,'mt_necesarios')   
	ll_rollo 		= lds_rollos.GetItemNumber(li_fila,'cs_rollo')  
	ls_tono 			= lds_rollos.GetItemString(li_fila,'tono')  
	ldc_kg_rollo 	= lds_rollos.GetItemNumber(li_fila,'ca_kg')   
	ldc_mt_rollo 	= lds_rollos.GetItemNumber(li_fila,'ca_mt')  
	ll_unid_rollo 	= lds_rollos.GetItemNumber(li_fila,'ca_unidad')  
		
	//metodo para determinar si un rollo tiene metros o unidades reservadas
	//en dt_consumo_rollo, retorna
	//-1 si sucede un error
	//0 si el rollo no esta siendo utilizado en ninguna liberacion
	//2 el rollo esta siendo utilizado en una liberacion
	//jcrm
	//abril 1 de 2008
	li_result = of_verificarconsumo(ll_rollo, ls_mensaje,0)	
	
	IF li_result = -1 THEN
		Rollback;
		as_mensaje = ls_mensaje
		Return -1
	END IF
	
	IF li_result = 2 THEN
		CONTINUE
	END IF
	
	SELECT cs_tanda
	  INTO :ll_tanda
	  FROM m_rollo
	 WHERE cs_rollo = :ll_rollo; 
	 
	SELECT kg_necesarios
	  INTO :ldc_kilos_nec
	  FROM temp_ref_liberar
	 WHERE co_fabrica 	= :li_fab AND
	  		 co_linea 		= :li_lin AND
			 co_referencia = :ll_ref AND
			 co_color_pt 	= :li_color_pt AND
			 co_reftel 		= :ll_reftel AND
			 co_caract 		= :li_caract AND
			 co_color_te 	= :li_color_te AND
			 co_tipo 		= 0 AND
			 cs_rollo 		= 0 AND
			 usuario 		= :gstr_info_usuario.codigo_usuario;
			 
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.SqlErrText
		Rollback;
		Return -1
	END IF
	 	
	 INSERT INTO h_aprueba_calidad_rollo  
				( cs_solicitud,
				  co_fabrica,   
				  co_linea,   
				  co_referencia,   
				  co_color_pt,   
				  co_reftel,   
				  co_caract,   
				  diametro,   
				  co_color_te,
				  cs_tanda,
				  dias_criticas,
				  tono_requerido,
				  unid_liberar,   
				  kg_necesarios,   
				  mt_necesarios,   
				  cs_rollo,   
				  tono,   
				  ca_kg,   
				  ca_mt,   
				  ca_unidad,   
				  usuario,   
				  instancia,   
				  fe_creacion,   
				  fe_actualizacion,   
				  sw_marca,		
				  sw_estado	)  
	  VALUES ( :ll_solicitud,
	  			  :li_fab,   
				  :li_lin,   
				  :ll_ref,   
				  :li_color_pt,   
				  :ll_reftel,   
				  :li_caract,   
				  :li_dia,   
				  :li_color_te, 
				  :ll_tanda,
				  :li_dias_criticas,
				  :as_tono_requerido,
				  :ll_unid,   
				  :ldc_kilos_nec,   
				  :ldc_mt_nec,   
				  :ll_rollo,   
				  :ls_tono,   
				  :ldc_kg_rollo,   
				  :ldc_mt_rollo,   
				  :ll_unid_rollo,   
				  :gstr_info_usuario.codigo_usuario,   
				  :gstr_info_usuario.instancia,   
				  current,   
				  current,   
				  0,
				  'P')  ;
				  
   IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.SqlErrText
		Rollback;
		Return -1
	END IF
	
	//ya se cargo el rollo en la temporal ahora se debe de colocar el campo 
	//co_estado_rollo en 1 en la tabla m_rollo esto para que no pueda ser utilizado
	//para otra liberacion
	UPDATE m_rollo
	   SET co_estado_rollo = 1
	 WHERE cs_rollo = :ll_rollo;
	 
	IF sqlca.sqlcode <> 0 THEN
		as_mensaje = sqlca.SqlErrText
		Rollback;
		Return -1
	END IF
	
	
NEXT
Destroy lds_rollos
Return 0
end function

public function long of_estadorolloscalidad (string as_estado, long al_solicitud, long al_rollo);//metodo para modificar el estado d elos rollos pendientes de aprobacion calidad
//para que el operario sepa a cuales solicitudes debe aun sacar la muestra fisica
//jcrm
//abril 4 de 2008
//estado = P (Pendiente)
//estado = E (En Proceso)
String ls_error, ls_usuario
Datetime	ldt_fe_hoy

ldt_fe_hoy = f_fecha_servidor()
ls_usuario = gstr_info_usuario.codigo_usuario

UPDATE h_aprueba_calidad_rollo
   SET sw_estado = :as_estado
 WHERE cs_solicitud = :al_solicitud;
 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.SqlErrText
	Rollback;
	MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado, ERROR: '+ls_error)
	Return -1
END IF

IF as_estado = 'E' AND al_rollo > 0  THEN
	//se cambian los rollos a estado disponible
	UPDATE m_rollo
	SET (co_estado_rollo, fe_actualizacion, usuario)
	  = ( 2, :ldt_fe_hoy, :ls_usuario)
	WHERE cs_rollo =  :al_rollo
	  AND co_estado_rollo = 1;
   IF sqlca.sqlcode = -1 THEN
	   ls_error = sqlca.SqlErrText
		Rollback;
		MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado del rollo a disponible, ERROR: '+ls_error)
		Return -1
	END IF

	
END IF

COMMIT;

Return 0
end function

public function long of_marcarrollos (string as_tono, long ai_fab, long ai_lin, long al_ref, long ai_caract, long ai_diametro, long al_color, long ai_tipo, ref string as_mensaje);//metodo para marcar los rollos seleccionados por el usuario para la liberacion
//jcrm
//febrero 18 de 2008

UPDATE temp_ref_liberar  
  SET sw_marca = 1  
WHERE tono 			= :as_tono  	AND  
		co_fabrica 	= :ai_fab  		AND  
		co_linea 	= :ai_lin  		AND  
		co_reftel 	= :al_ref  		AND  
		co_caract 	= :ai_caract 	AND  
		diametro 	= :ai_diametro	AND  
		co_color_te = :al_color  	AND  
		co_tipo 		= :ai_tipo		AND
		usuario		= :gstr_info_usuario.codigo_usuario;
		
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	return -1
END IF

Return 0
end function

public function long of_revisar_si_bodysize (long ai_fabrica, long ai_linea, long al_referencia, long al_color_pt);//Esta funcion mira si un estilo es bodysize, se le pasa la fabrica-linea-referencia-color y 
//mira cuantos diametros tiene el modelo principal, si tiene mas de un diametro se dice que el 
//estilo es bodysize.
//si es bodysize se retorna 1 de lo contrario retorna 0
//jorodrig feb29-07

Long	ll_result
datastore   lds_gr_diametros_x_estilo_raya_10

//defino el data object
lds_gr_diametros_x_estilo_raya_10= Create DataStore
lds_gr_diametros_x_estilo_raya_10.DataObject = 'ds_gr_diametros_x_estilo_raya_10'
lds_gr_diametros_x_estilo_raya_10.SettransObject(sqlca)

ll_result = lds_gr_diametros_x_estilo_raya_10.Retrieve(ai_fabrica,ai_linea,al_referencia,al_color_pt)
Destroy lds_gr_diametros_x_estilo_raya_10
IF ll_result > 1 THEN
	//posiblemente la ref es bodysize, pues se encontraron varios diametros en la raya 10
	return 1
ELSE
	return 0
END IF
end function

public function long of_contarmodelos (long ai_fab, long ai_lin, long al_ref, long al_color_pt, ref string as_mensaje);//evento para determinar el numero de telas y modelos necesarios para la prenda
//si es una tela y un modelo se devuelve 1, de lo contrario se devuelve 100
//esto es para saber si se deben validar los tonos, ya que si se trata de una
//tela y un modelo no debe importar si se mezclan tonos o si los rollos no llevan
//tono.
//jcrm
//marzo 17 de 2008
Long li_count
DataStore lds_modelos

lds_modelos = Create DataStore
lds_modelos.DataObject = 'ds_telas_modelo_ficha'
lds_modelos.SetTransObject(sqlca)

li_count = lds_modelos.Retrieve(ai_fab, ai_lin, al_ref, al_color_pt)

If li_count > 1 Then
	//tiene mas de una tela o de un modelo se deben validar los tonos
	Return 100
End if
	
If li_count = -1 Then
	as_mensaje = 'No fue posible establecer la terlas y modelos de la referencia'
	Destroy lds_modelos
	Return -1
End if


If li_count = 1 Then
	Destroy lds_modelos
	Return 1
End if
  

end function

public function long of_total_kg_proceso (long ai_fabrica, long ai_linea, long al_ref, long al_color_pt, long al_reftel, long al_color_te);//sumar los kilos en proceso tintoreria y acabados
DECIMAL{2}	ld_kg_proc

SELECT sum(kilos)
  INTO :ld_kg_proc
  FROM temp_kamban_tinto a, h_tandas b
 WHERE a.cs_tanda = b.cs_tanda
   AND a.cs_secundario = b.cs_secundario
   AND a.co_fabrica = :ai_fabrica
   AND a.co_linea = :ai_linea
	AND a.co_referencia = :al_ref
	AND a.co_reftel = :al_reftel
	AND b.co_color = :al_color_te
	ANd a.co_usuario = 'admtelas';

IF ld_kg_proc > 0 THEN
	RETURN ld_kg_proc
ELSE
	RETURN 0
END IF


end function

public function long of_buscar_op_estilo (long ai_fabrica, long ai_linea, long al_referencia, long al_color_pt, long ai_talla, long ai_anno, long ai_semana, long ai_tipo, long ai_duo);LONG	ll_op_estilo, ll_count

IF ai_tipo = 1 THEN
	
	//antes se determina si la referncia es body size
	If of_revisar_si_bodysize(ai_fabrica,ai_linea,al_referencia,al_color_pt) = 1 THEN
		SELECT min(a.cs_ordenpd_pt)
		  INTO :ll_op_estilo
		  FROM h_ordenpd_pt a, dt_caxpedidos b, t_criticas_cedi t, peddig p
		 WHERE a.cs_ordenpd_pt = b.cs_ordenpd_pt
			AND a.co_fabrica = :ai_fabrica
			AND a.co_linea = :ai_linea
			AND a.co_referencia = :al_referencia
			AND b.co_color = :al_color_pt
			AND a.co_fabrica = t.co_fabrica
			AND a.co_linea = t.co_linea
			AND a.co_referencia = t.co_referencia
			AND t.co_calidad = 1
			AND t.co_color = b.co_color
			AND t.ano = :ai_anno
			AND t.semana = :ai_semana
			AND t.co_talla = b.co_talla
			AND a.co_estado_orden NOT IN (5,6)
			AND b.ca_liberadas < b.ca_programada
			AND b.pedido = p.pedido
			AND p.co_tipo_orden = 'S' 
			AND t.co_talla = :ai_talla;
	ELSE
		IF ai_duo = 2 THEN
			//ai_duo = 2 es liberacion duo con cantidades iguales se trabaja con las unidades originales a liberar
			SELECT FIRST 1 a.cs_ordenpd_pt, count(a.cs_ordenpd_pt)
			  INTO :ll_op_estilo, :ll_count
			  FROM h_ordenpd_pt a, dt_caxpedidos b, t_criticas_cedi t, peddig p
			 WHERE a.cs_ordenpd_pt = b.cs_ordenpd_pt
				AND a.co_fabrica = :ai_fabrica
				AND a.co_linea = :ai_linea
				AND a.co_referencia = :al_referencia
				AND b.co_color = :al_color_pt
				AND a.co_fabrica = t.co_fabrica
				AND a.co_linea = t.co_linea
				AND a.co_referencia = t.co_referencia
				AND t.co_calidad = 1
				AND t.co_color = b.co_color
				AND t.ano = :ai_anno
				AND t.semana = :ai_semana
				AND t.co_talla = b.co_talla
				AND a.co_estado_orden NOT IN (5,6)
				AND b.ca_liberadas < b.ca_programada
				AND b.pedido = p.pedido
				AND p.co_tipo_orden = 'S' AND (select count(distinct t_criticas_cedi.co_talla)
						from t_criticas_cedi
						where t_criticas_cedi.co_fabrica = t.co_fabrica
							and t_criticas_cedi.co_linea = t.co_linea 
							and t_criticas_cedi.co_referencia = t.co_referencia
							and t_criticas_cedi.co_color = t.co_color 
							and t_criticas_cedi.ano = t.ano
							and t_criticas_cedi.semana = t.semana
							and (t_criticas_cedi.cant_terminado_ant ) > 0) <= (select count(distinct co_talla)
																						from dt_caxpedidos
																						where dt_caxpedidos.cs_ordenpd_pt = b.cs_ordenpd_pt
																							and dt_caxpedidos.co_color = b.co_color
																							and dt_caxpedidos.pedido = p.pedido 
																							and dt_caxpedidos.ca_liberadas < dt_caxpedidos.ca_programada)
				GROUP BY 1
				ORDER BY 2 DESC;
		ELSE
				//ai_duo = 1 es liberacion para equilibrar unidades o normal y se trabaja con las unidades a liberar 
			SELECT FIRST 1 a.cs_ordenpd_pt, count(a.cs_ordenpd_pt)
			  INTO :ll_op_estilo, :ll_count
			  FROM h_ordenpd_pt a, dt_caxpedidos b, t_criticas_cedi t, peddig p
			 WHERE a.cs_ordenpd_pt = b.cs_ordenpd_pt
				AND a.co_fabrica = :ai_fabrica
				AND a.co_linea = :ai_linea
				AND a.co_referencia = :al_referencia
				AND b.co_color = :al_color_pt
				AND a.co_fabrica = t.co_fabrica
				AND a.co_linea = t.co_linea
				AND a.co_referencia = t.co_referencia
				AND t.co_calidad = 1
				AND t.co_color = b.co_color
				AND t.ano = :ai_anno
				AND t.semana = :ai_semana
				AND t.co_talla = b.co_talla
				AND a.co_estado_orden NOT IN (5,6)
				AND b.ca_liberadas < b.ca_programada
				AND b.pedido = p.pedido
				AND p.co_tipo_orden = 'S' AND (select count(distinct t_criticas_cedi.co_talla)
						from t_criticas_cedi
						where t_criticas_cedi.co_fabrica = t.co_fabrica
							and t_criticas_cedi.co_linea = t.co_linea 
							and t_criticas_cedi.co_referencia = t.co_referencia
							and t_criticas_cedi.co_color = t.co_color 
							and t_criticas_cedi.ano = t.ano
							and t_criticas_cedi.semana = t.semana
							and (t_criticas_cedi.cant_terminado_ant -  t_criticas_cedi.cant_liberado -  t_criticas_cedi.cant_prog_corte -  t_criticas_cedi.cant_cortado - t_criticas_cedi.cant_kpo_corte -  t_criticas_cedi.cant_kpo_confeccion  ) > 0) <= (select count(distinct co_talla)
																							from dt_caxpedidos
																							where dt_caxpedidos.cs_ordenpd_pt = b.cs_ordenpd_pt
																								and dt_caxpedidos.co_color = b.co_color
																								and dt_caxpedidos.pedido = p.pedido 
																								and dt_caxpedidos.ca_liberadas < dt_caxpedidos.ca_programada)
				GROUP BY 1
				ORDER BY 2 DESC;
			END IF																			
		END IF
	
ELSE
	SELECT min(a.cs_ordenpd_pt)
	  INTO :ll_op_estilo
	  FROM h_ordenpd_pt a, dt_caxpedidos b, peddig p
	 WHERE a.cs_ordenpd_pt = b.cs_ordenpd_pt
		AND a.co_fabrica = :ai_fabrica
		AND a.co_linea = :ai_linea
		AND a.co_referencia = :al_referencia
		AND b.co_color = :al_color_pt
		AND b.co_talla = :ai_talla
		AND a.co_estado_orden NOT IN (5,6)
		AND b.ca_liberadas < b.ca_programada
		AND b.pedido = p.pedido
      AND p.co_tipo_orden = 'S';
	
END IF
IF IsNull(ll_op_estilo) OR ll_op_estilo = 0  THEN
	Return -1
END IF
	
RETURN	ll_op_estilo;

end function

public function long of_pedido_vs_liberacion (long ai_fab, long ai_linea, long al_ref, long al_color, long ai_talla, long ai_fab_exp, long ai_lin_exp, string as_ref_exp, string as_color_exp, string as_po, string as_talla_exp);//metodo para determinar si los datos que se van ha utilizar en la liberacion no han sido modificados
//en el pedido
//jcrm
//febrero 11 de 2009
Long ll_count

IF IsNull(ai_lin_exp) OR IsNull(as_ref_exp) OR as_ref_exp = '' THEN
	SELECT count(*)
		 INTO :ll_count
		 FROM pedpend_exp  
		WHERE ( pedpend_exp.co_fabrica 		= :ai_fab ) AND  
				( pedpend_exp.co_linea 			= :ai_linea ) AND  
				( pedpend_exp.co_referencia 	= :al_ref ) AND  
				( pedpend_exp.co_color 			= :al_color ) AND  
				( pedpend_exp.co_color_exp 	= :as_color_exp ) AND  
				( pedpend_exp.nu_orden 			= :as_po ) AND
				( pedpend_exp.co_talla			= :ai_talla) AND
				( pedpend_exp.co_talla_exp		= :as_talla_exp);
ELSE
	SELECT count(*)
		 INTO :ll_count
		 FROM pedpend_exp  
		WHERE ( pedpend_exp.co_fabrica 		= :ai_fab ) AND  
				( pedpend_exp.co_linea 			= :ai_linea ) AND  
				( pedpend_exp.co_referencia 	= :al_ref ) AND  
				( pedpend_exp.co_color 			= :al_color ) AND  
				( pedpend_exp.co_linea_exp 	= :ai_lin_exp ) AND  
				( pedpend_exp.co_ref_exp 		= :as_ref_exp ) AND  
				( pedpend_exp.co_color_exp 	= :as_color_exp ) AND  
				( pedpend_exp.nu_orden 			= :as_po ) AND
				( pedpend_exp.co_talla			= :ai_talla) AND
				( pedpend_exp.co_talla_exp		= :as_talla_exp);
END IF
			
IF ll_count <= 0 THEN
	Return -1 //el pedido fue modificado
END IF


Return 0
end function

public function long of_cargar_rollos_tablas_liberacion (string as_usuario, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long al_ordenpd_pt, long ai_talla, decimal ad_porc_aplicar);///cargamos la tabla de_rollos temp_tela_n para liberar
//se adiciona que si una de las telas tiene color 601 (APT) no se debe dejar liberar por tono  julio 13 - 2011
//SA60507 liberar op agrupada   aplicar porcentaje a la tela a liberar

Long		ll_result, pos, li_caract, li_diametro, li_talla, li_estado_final, li_marca, li_tipo_tela,&
			   li_inserto, li_result
Long			ll_cs_rollo,  ll_reftel, ll_unidades, ll_unid_consu, ll_tanda, li_diam_rollo, ll_lote, ll_color
String		ls_tono, ls_error, ls_mensaje, ls_disenno_rollo,ls_disenno_ficha
Decimal{3}	ldc_ancho, ldc_mt, ldc_kg, ldc_metros_consu, ldc_kg_liberados, ld_kg_rollo, ld_mt_rollo
Integer	li_rollo_completo
datastore   ldgr_rollos_tabla_temp_ref_liberar
n_cts_cargar_temporales_liberacion luo_tempo_liberacion

//defino el data object
ldgr_rollos_tabla_temp_ref_liberar= Create DataStore
ldgr_rollos_tabla_temp_ref_liberar.DataObject = 'dgr_rollos_tabla_temp_ref_liberar'
ldgr_rollos_tabla_temp_ref_liberar.SettransObject(sqlca)

DELETE FROM temp_tela_n
WHERE usuario = :as_usuario;
COMMIT;

li_inserto = 0

ll_result = ldgr_rollos_tabla_temp_ref_liberar.Retrieve(as_usuario,ai_fab,ai_linea,al_ref,al_color_pt)
IF ll_result <= 0 THEN
	MessageBox('Error','No se encontro ningun rollo disponible para liberar para esta referencia color, verifique los rollos')
	Return -1
END If
FOR pos = 1 TO ll_result
		ll_cs_rollo 		= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'cs_rollo')
		ll_reftel 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'co_reftel')
  	     li_caract 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'co_caract')
		li_diametro 		= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'diametro')
		ll_color 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'co_color_te')
		li_talla 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'co_talla')
		ls_tono 				= ldgr_rollos_tabla_temp_ref_liberar.GetItemString(pos,'tono')
		ldc_ancho 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'ancho_tub_term')
		ldc_mt 				= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'ca_mt')
		ldc_kg 				= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'ca_kg')
		ll_unidades 		= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'ca_unidad')
		li_estado_final 	= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'co_caract_final')
		li_diam_rollo	 	= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'diam_rollo')
		ll_lote	 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'lote')
		ll_tanda	 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'cs_tanda')
		
		ls_disenno_rollo	= ldgr_rollos_tabla_temp_ref_liberar.GetItemString(pos,'co_disenno')
		ls_disenno_ficha	= ldgr_rollos_tabla_temp_ref_liberar.GetItemString(pos,'disenno_ficha')
		
		li_rollo_completo =  ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'sw_completo')
		
		ld_kg_rollo	=  ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'kg_rollo')
		ld_mt_rollo	=  ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'m_rollo_mt_rollo')
//		IF (li_caract = 7 OR li_caract = 10 OR li_caract = 11) AND Not IsNull(ls_disenno_rollo) THEN
//			IF TRIM(ls_disenno_rollo) <> TRIM(ls_disenno_ficha) THEN
//				//el rollo es estampado y no sirve, por ahora es solo informativo enero 27 - 2010  jorodrig
//				MessageBox('Advertencia','Esta cargando un rollo estampado que no tiene el mismo dise$$HEX1$$f100$$ENDHEX$$o de la pinta a liberar, Por ahora el mensaje es solo informativo, pero proximamente no podr$$HEX2$$e1002000$$ENDHEX$$tomar estos rollos para la liberacion, el rollo es el: '+string(ll_cs_rollo) + ' Y la tela es la: '+string(ll_reftel))
//			END IF
//		END IF
		
	//	li_marca 			= ldgr_rollos_tabla_temp_ref_liberar.GetItemNumber(pos,'sw_bodysize')
	
	   //metodo para determinar si un rollo tiene metros o unidades reservadas
		//en dt_consumo_rollo, retorna
		//-1 si sucede un error
		//0 si el rollo no esta siendo utilizado en ninguna liberacion
		//2 el rollo esta siendo utilizado en una liberacion
		//jcrm
		//abril 1 de 2008
		li_result = of_verificarconsumo(ll_cs_rollo, ls_mensaje,al_ordenpd_pt)	
		IF li_result = -1 THEN
			Rollback;
			MessageBox('Error',ls_mensaje)
			Return -1
		END IF
		IF li_result = 2 THEN
			CONTINUE
		END IF
	
	
		If isnull(ldc_ancho) Then ldc_ancho = 0
		
		li_tipo_tela = luo_tempo_liberacion.of_rectilineo(ll_reftel,li_caract)
		IF li_tipo_tela = 3 THEN  //son rectilineos
			li_marca = 3   //marca 3 son rectilineos
		ELSE
			li_talla = 9999    //es tela se crea talla generica
//			If isnull(ldc_ancho) or ldc_ancho = 0 Then
//				ls_descripcion = 'El rollo: '+String(ll_cs_rollo)+' no tiene ancho o esta en nulo. '
//				of_cargar_log_problemas(ls_descripcion,al_op,as_po,al_ref,al_color,0,0,0,0,1)
//			End if
//			
		END IF
		
		IF ib_tanda = true Then
			ll_tanda = ll_lote
		ELSE	
			IF ls_tono = 'A' THEN
				ll_tanda = 10
			ELSEIF ls_tono = 'B' THEN
				ll_tanda = 20
			ELSEIF ls_tono = 'C' THEN
				ll_tanda = 30
			END IF
			
			//no dejar liberar por tono el color 601
			IF ll_color = 601 THEN
				Rollback;
				MessageBox('Advertencia','La pinta tiene color 601, y este no se puede liberar por tono, debe ser por tanda')
				Return -1
			END IF
		END IF
				
		ldc_metros_consu = 0
		ll_unid_consu = 0
		ldc_kg_liberados = 0
		
		//Se descomentarea esta parte  (estaba en comentario)  esto para poder que los rollos que repartan para varias liberaciones
		 //verificar esta parte muy bien SA60507 liberar op agrupada jorodrig junio 26 - 2020
		//averiguo el total a cargar del rollo
		SELECT nvl(ca_metros,0), nvl(ca_unidades,0),nvl(kg_liberados,0)
		  INTO :ldc_metros_consu, :ll_unid_consu, :ldc_kg_liberados
		  FROM dt_consumo_rollos
		 WHERE cs_rollo = :ll_cs_rollo;
		 
		IF ISNULL(ldc_metros_consu) THEN ldc_metros_consu = 0
		IF ISNULL(ll_unid_consu) THEN ll_unid_consu = 0
		IF ISNULL(ldc_kg_liberados) THEN ldc_kg_liberados = 0
		
		IF ldc_kg_liberados > 0 THEN		//verificar si hay un cambio entre los kilos cargados y los liberados del rollo
			IF ldc_kg <> (ld_kg_rollo - ldc_kg_liberados) THEN
			END IF
		END IF
		IF ldc_kg = ld_kg_rollo THEN
			ldc_mt -= ldc_metros_consu
			ll_unidades -= ll_unid_consu
			ldc_kg -= ldc_kg_liberados
		END IF
		
		
		//Aplicar el porcentaje para las ordenes agrupadas  SA60507   liberar OP agrupada jorodrig junio 26 -2020
		//este porcentaje se aplica porque se necesita repartir la tela existente ente las liberaciones a realizar, se definio
		//que las agrupadas tienen la misma tela.
		//inicialmente se define con Kevn que no se aplica automatico sino que ellos definen los rollos a utilizar
//		ldc_mt = ldc_mt * ad_porc_aplicar
//		ll_unidades = ll_unidades * ad_porc_aplicar
//		ldc_kg = ldc_kg * ad_porc_aplicar
		
		
		
		IF ldc_kg > 0.01 Or ll_unidades > 0 THEN
			//inserto en la temporal de telas
			INSERT INTO temp_tela_n  
					( usuario,   
					  cs_rollo,   
					  cs_ordenpd_pt,   
					  co_reftel,   
					  co_caract,   
					  co_color,   
					  co_talla,   
					  co_tono,   
					  ancho,   
					  diametro,   
					  ca_mt,   
					  ca_kg,   
					  sw_marca,   
					  estado_final,   
					  ca_unidades,
					  ancho_agrupa,
					  cs_tanda,
					  lote,
					  diametro_ant,
					  co_disenno,
					  sw_completo)  
		   VALUES (:as_usuario,   
					  :ll_cs_rollo,   
					  :al_ordenpd_pt,   
					  :ll_reftel,   
					  :li_caract,   
					  :ll_color,   
					  :li_talla,   
					  :ls_tono,   
					  :ldc_ancho,   
					  :li_diametro,   
					  :ldc_mt,   
					  :ldc_kg,   
					  :li_marca,   
					  :li_estado_final,   
					  :ll_unidades,
				     :ldc_ancho,
					  :ll_tanda,
					  0,
					  :li_diam_rollo,
					  :ls_disenno_rollo,
					  :li_rollo_completo)  ;
  			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.SqlErrText
				Rollback;
				MessageBox('Error', 'Se produjo error insertando datos de tela en bodega: '+ls_error )
				Return -1;
			END IF
			li_inserto = 1
		END IF

NEXT

IF li_inserto = 0 THEN
	Rollback;
	MessageBox('Error', 'No existe tela suficiente para realizar liberacion')
	Return 0
END IF
Destroy ldgr_rollos_tabla_temp_ref_liberar 
return 1



end function

public function integer of_validar_op_rollo_consumido (long al_cs_rollo, long al_op_liberar, long al_op_agrupada);LONG	ll_op_agrupada_liberada, ll_op_rollo_liberado

SELECT max(a.cs_ordenpd_pt)
INTO :ll_op_rollo_liberado
FROM dt_pdnxmodulo a, dt_rollos_libera b
WHERE a.co_fabrica_exp = b.co_fabrica_exp
AND a.cs_liberacion = b.cs_liberacion
AND a.po = b.nu_orden
AND a.nu_cut = b.nu_cut
AND a.co_fabrica_pt = b.co_fabrica_pt
AND a.co_linea = b.co_linea
AND a.co_referencia = b.co_referencia
AND a.co_color_pt = b.co_color_pt
AND a.co_estado_asigna < 9
AND b.cs_rollo = :al_cs_rollo
;
IF ll_op_rollo_liberado > 0 THEN
	SELECT MAX(a.cs_ordenpd_pt_agrupa)
	  INTO :ll_op_agrupada_liberada
	  FROM agrupacion_pedido a, h_ordenpd_pt b
	WHERE a.cs_ordenpd_pt =  b.cs_ordenpd_pt
		  AND b.co_estado_orden < 5
		  AND a.cs_ordenpd_pt = :ll_op_rollo_liberado;
     IF ll_op_agrupada_liberada =  al_op_agrupada THEN
		Return 1
	END IF
END IF

Return 0
end function

public function long of_cargar_ref_tablas_liberacion (long ano, long semana, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long al_unid_color, long al_ordenpd_pt, string as_po, long ai_talla, string as_usuario, long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, integer ai_op_agrupada);//cargamos la tabla de_rollos temp_tela_n para liberar
Long		pos, li_talla, ll_result, li_marca, li_bodysize
String		ls_po, ls_cut, ls_error
Decimal{4}	ldc_porc_partic, ld_tot_prog, ld_tot_particip
Long li_cant_lib, ll_cant_crit,ll_tot_color, ll_gran_total
datastore   ldgr_unid_x_talla_t_criticas_cedi

DELETE FROM temp_referen_n
WHERE usuario = :as_usuario;
COMMIT;

//defino el data object
ldgr_unid_x_talla_t_criticas_cedi= Create DataStore
IF ai_op_agrupada > 0 THEN

		ldgr_unid_x_talla_t_criticas_cedi.DataObject = 'ds_refer_exp_agrupada'

ELSE
	//es una liberacion make to order
   ldgr_unid_x_talla_t_criticas_cedi.DataObject = 'ds_refer_exp_prueba'
END IF
ldgr_unid_x_talla_t_criticas_cedi.SettransObject(sqlca)


ll_result = ldgr_unid_x_talla_t_criticas_cedi.Retrieve(as_usuario, al_color_pt, as_po, as_color_exp)

IF ll_result <= 0 THEN
	IF ai_op_agrupada > 0 THEN
		 ldgr_unid_x_talla_t_criticas_cedi.DataObject = 'ds_refer_exp_prueba'
		 ldgr_unid_x_talla_t_criticas_cedi.SettransObject(sqlca)
		 ll_result = ldgr_unid_x_talla_t_criticas_cedi.Retrieve(as_usuario, al_color_pt, as_po, as_color_exp)
		 IF ll_result <= 0 THEN
			MessageBox('Error','No se encontro ninguna referencia en la op con el color, po, y telas relacionados, revise que la op tenga todos los datos correctos')
			Return -1
		END IF
	ELSE
		MessageBox('Error','No se encontro ninguna referencia en la op con el color, po, y telas relacionados, revise que la op tenga todos los datos correctos')
		Return -1
	END IF
END IF

FOR pos = 1 TO ll_result
	IF ano > 0 THEN
//		li_talla 	= ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'co_talla')
//		IF al_cons_lib_duo > 0 THEN
//			//es duo se trabaja con el archivo de criticas
//			li_talla 	= ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'co_talla')
//			li_cant_lib = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'cant_terminado_ant')
//		ELSE
			//es critica pero se trabaja con los datos de la OP seleccionada por el usuario
			li_talla 	= ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'dt_caxpedidos_co_talla')
//			li_cant_lib = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'ca_programada')
			li_cant_lib = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'total_color_bdsize')
			//se encontro la cantidad de la talla de la OP, ahora se debe saber con es esta con relacion
			//al archivo de criticas
//			SELECT nvl((cant_terminado - cant_liberado - cant_prog_corte - cant_cortado),0) 
//			  INTO :ll_cant_crit		 
//			  FROM t_criticas_cedi
//			 WHERE ano 				= :ano
//			   AND semana 			= :semana
//			   AND co_fabrica 	= :ai_fab
//			   AND co_linea  		= :ai_linea
//			   AND co_referencia = :al_ref
//			   AND co_color 		= :al_color_pt
//			   AND co_talla 		= :li_talla
//			   AND co_fabrica_exp= :ai_fab_exp
//			   AND co_linea_exp	= :ai_linea_exp
//			   AND co_ref_exp	 	= :as_ref_exp
//			   AND co_color_exp	= :as_color_exp;		
//						
//			   IF li_cant_lib > ll_cant_crit THEN
//					li_cant_lib = ll_cant_crit
//				END IF
//			
			//li_cant_lib = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'cant_liberar')
//		END IF
	ELSE
		//es make to order, los datos son los de dt_caxpedidos
		li_talla 	= ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'dt_caxpedidos_co_talla')
//		li_cant_lib = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'ca_programada')
		li_cant_lib = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'total_color_bdsize')
		
	END IF
		
	//Buscar si la prenda tiene alguna tela que sea bodysize, en caso de que
	//alguna de las telas sea bodysize se marca la prenda como 1=bodysize
	li_bodysize = of_revisar_si_bodysize(ai_fab, ai_linea, al_ref, al_color_pt)
	IF li_bodysize = 1 THEN
		li_marca = 1
		ll_tot_color = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'total_color_bdsize')
	ELSE
		li_marca = 0
		ll_tot_color = ldgr_unid_x_talla_t_criticas_cedi.GetItemNumber(pos,'total_color')
	END IF
	
	
	
	
			
	IF al_unid_color = 0 THEN al_unid_color = 1 		
			
	//calculamos el porcentaje de participacion de la talla
	//ldc_porc_partic = li_cant_lib / al_unid_color
	ldc_porc_partic = li_cant_lib / ll_tot_color
	ll_gran_total = ll_gran_total + li_cant_lib
	IF ai_talla <> 9999  THEN
		IF ai_talla = li_talla THEN
			INSERT INTO temp_referen_n
						(usuario, 
						 cs_ordenpd_pt, 
						 po, 
						 co_fabrica, 
						 co_linea, 
						 co_referencia, 
						 co_color,
						 co_talla, 
						 unid_prog, 
						 unid_liberadas, 
						 porc_particip, 
						 sw_marca, 
						 nu_cut,
						 co_color_exp)
					VALUES (
						:as_usuario, 
						:al_ordenpd_pt, 
						:as_po, 
						:ai_fab, 
						:ai_linea,
						:al_ref, 
						:al_color_pt, 
						:li_talla, 
						:li_cant_lib, 
						0,
						:ldc_porc_partic, 
						:li_marca, 
						'0',
						:as_color_exp);
					IF SQLCA.SQLCODE <> 0 THEN
						ls_error = sqlca.sqlerrtext
						Rollback;
						MessageBox('Error','Ocurrio un error al momento de cargar las telas a liberar, ERROR: '+ls_error)
						Return -1
					END IF
		END IF
	ELSE
		IF ai_op_agrupada > 0 THEN	//como es agrupada pueden estar liberando varias OP, por eso se debe sumar las cantidades
			SELECT SUM(unid_prog)
			  INTO :ld_tot_prog
			  FROM temp_referen_n
		    WHERE usuario = :as_usuario
			    AND cs_ordenpd_pt = :al_ordenpd_pt
				AND po = :as_po
				AND co_fabrica = :ai_fab
				AND co_linea = :ai_linea
				AND co_referencia = :al_ref
				AND co_color = :al_color_pt
				AND co_talla = :li_talla;
			IF 	ld_tot_prog > 0 THEN
				ld_tot_prog = ld_tot_prog + li_cant_lib
				UPDATE temp_referen_n
				SET unid_prog =  :ld_tot_prog
			    WHERE usuario = :as_usuario
			    AND cs_ordenpd_pt = :al_ordenpd_pt
				AND po = :as_po
				AND co_fabrica = :ai_fab
				AND co_linea = :ai_linea
				AND co_referencia = :al_ref
				AND co_color = :al_color_pt
				AND co_talla = :li_talla;
				IF SQLCA.SQLCODE <> 0 THEN
					ls_error = sqlca.sqlerrtext
					Rollback;
					MessageBox('Error','Ocurrio un error al momento de actualizar las unidades en OP agrupada, ERROR: '+ls_error)
					Return -1
				END IF
				CONTINUE
		     END IF
		END IF
			INSERT INTO temp_referen_n
							(usuario, 
							 cs_ordenpd_pt, 
							 po, 
							 co_fabrica, 
							 co_linea, 
							 co_referencia, 
							 co_color,
							 co_talla, 
							 unid_prog, 
							 unid_liberadas, 
							 porc_particip, 
							 sw_marca, 
							 nu_cut,
							 co_color_exp)
						VALUES (
							:as_usuario, 
							:al_ordenpd_pt, 
							:as_po, 
							:ai_fab, 
							:ai_linea,
							:al_ref, 
							:al_color_pt, 
							:li_talla, 
							:li_cant_lib, 
							0,
							:ldc_porc_partic, 
							:li_marca, 
							'0',
							:as_color_exp);
						IF SQLCA.SQLCODE <> 0 THEN
							ls_error = sqlca.sqlerrtext
							Rollback;
							MessageBox('Error','Ocurrio un error al momento de cargar las telas a liberar, ERROR: '+ls_error)
							Return -1
						END IF
		//END IF
	END IF
	
	
				
NEXT

 IF ai_op_agrupada > 0 THEN    //es necesario recalcular el porcentaje de participacion
	UPDATE temp_referen_n
	SET porc_particip =  unid_prog / :ll_gran_total
	 WHERE usuario = :as_usuario
	 AND cs_ordenpd_pt = :al_ordenpd_pt
	AND po = :as_po
	AND co_fabrica = :ai_fab
	AND co_linea = :ai_linea
	AND co_referencia = :al_ref
	AND co_color = :al_color_pt ;
END IF
Destroy ldgr_unid_x_talla_t_criticas_cedi 
return 1
end function

public function long of_cargar_temp_ref_liberar (string as_usuario, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long ai_talla_pt, long sw_bodysize, long a$$HEX1$$f100$$ENDHEX$$o, long semana, long al_op_estilo, long ai_fabrica_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, long al_op_agrupada, integer ai_cs_agrupa_lib);Long		li_result, posi, li_caract, li_diametro,  li_existe, li_mismo_estilo, li_fila, li_stock,&
  				li_otro_estilo, li_talla_new, li_talla_old, li_diametro_traer, li_mensaje, li_ref_marcada
LONG			ll_modelo, ll_reftel, ll_unid_liberar, ll_unid, ll_rollo, ll_unid_consumidos, ll_tanda
LONG			ll_unid_prog, ll_unid_libero, ll_color_te, ll_co_ref_agrupa
DECIMAL{2}	ld_kg_necesario, ld_kg_proceso1, lds_porc_perd_orillo, ldc_porc_liberar, ld_porc_perd_orillo_cte, ld_porc_perd_cabecera
DECIMAL{2}  ldc_mt, ldc_kg, ldc_mt_consumidos, ldc_kg_restar, ldc_gramos, ldc_kg_consumidos
DATETIME 	ldt_fecha
STRING      ls_tono, ls_error, ls_disenno, ls_diseno_rollo
datastore ldgr_modelos_x_ref_pre_liberacion, lds_telas_mismo_estilo, lds_stock, lds_otro_estilo, lds_perd_orillo
n_cts_constantes_tela luo_constantes_tela
//en la tabla temp_ref_liberar en el campo co_tipo se manejara de la siguiente manera
//0 = registro original
//1 = rollos de la op del mismo estilo
//2 = rollos de stock o prototipo
//3 = rollos de diferente estilo

DELETE FROM temp_ref_liberar
WHERE usuario = :as_usuario;

IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar la temporal de referencias, ERROR: '+ls_error,StopSign!)
	Return -1
END IF

COMMIT;

ldt_fecha = f_fecha_servidor()
li_mensaje = 0

ldgr_modelos_x_ref_pre_liberacion   = Create DataStore
lds_telas_mismo_estilo					= Create DataStore
lds_stock									= Create DataStore
lds_otro_estilo							= Create DataStore
lds_perd_orillo                     = Create DataStore

//defino el data object
IF al_op_agrupada > 0 AND ai_cs_agrupa_lib > 0 THEN
	//se trata de una liberacion make to stock
	ldgr_modelos_x_ref_pre_liberacion.DataObject    = 'dgr_modelos_x_ref_pre_liberacion_x_agrupa'
	lds_telas_mismo_estilo.DataObject    				= 'ds_telas_op_mismo_estilo_x_pedid'
ELSE
	//se trata de una liberacion make to order
	ldgr_modelos_x_ref_pre_liberacion.DataObject    = 'dgr_modelos_x_ref_pre_liberacion_x_pedid'
	lds_telas_mismo_estilo.DataObject					= 'ds_telas_op_mismo_estilo_x_pedid'
END IF

lds_stock.DataObject    								= 'ds_telas_op_stock_prototipo'
lds_otro_estilo.DataObject    						= 'ds_telas_op_otro_estilo'
lds_perd_orillo.DataObject                      = 'dtb_dato_porc_perd_proceso'

ldgr_modelos_x_ref_pre_liberacion.SettransObject(sqlca)
lds_telas_mismo_estilo.SettransObject(sqlca)
lds_stock.SettransObject(sqlca)
lds_otro_estilo.SettransObject(sqlca)
lds_perd_orillo.SettransObject(sqlca)

//se carga al informacion de la ficha de la prenda en la talla si es bodysize  o con todas las tallas si no lo es
//IF al_op_estilo = 0 THEN
//	li_result = ldgr_modelos_x_ref_pre_liberacion.Retrieve(a$$HEX1$$f100$$ENDHEX$$o,semana,ai_fab,ai_linea,al_ref,al_color_pt,ai_talla_pt,ai_fabrica_exp, ai_linea_exp, as_ref_exp, as_color_exp)
//ELSE
	li_result = ldgr_modelos_x_ref_pre_liberacion.Retrieve(al_op_estilo,ai_fab,ai_linea,al_ref,al_color_pt,ai_talla_pt,as_color_exp,al_op_agrupada,ai_cs_agrupa_lib)
//END IF
IF li_result = -1 OR li_result = 0  THEN
	//revisa si  es una OP agrupada y la referencia es diferente a la que esta en la OP agrupada,  primero traemos la referencia que tenga el color que estamos liberando
	
	SELECT max(h.co_referencia)
	  INTO :ll_co_ref_agrupa
      FROM h_ordenpd_pt h, dt_ordenes_agrupad d, dt_caxpedidos c
    WHERE d.cs_ordenpd_pt = :al_op_estilo
        AND d.cs_ordenpd_pt_agru = c.cs_ordenpd_pt
        AND d.cs_ordenpd_pt_agru = h.cs_ordenpd_pt
        AND c.co_color = :al_color_pt;
	IF	ll_co_ref_agrupa  > 0 THEN
		al_ref = ll_co_ref_agrupa
		ldgr_modelos_x_ref_pre_liberacion.DataObject    = 'dgr_modelos_x_ref_pre_liberacion_x_pedid'
		ldgr_modelos_x_ref_pre_liberacion.SettransObject(sqlca)
		li_result = ldgr_modelos_x_ref_pre_liberacion.Retrieve(al_op_estilo,ai_fab,ai_linea,al_ref,al_color_pt,ai_talla_pt,as_color_exp,0,0)
		IF li_result = -1 OR li_result = 0  THEN
			MessageBox('Error','La fabrica '+String(ai_fab)+', l$$HEX1$$ed00$$ENDHEX$$nea '+String(ai_linea)+', referencia '+string(al_ref)+' y color '+String(al_color_pt)+ ' no existe en la ficha de prenda,')
			Return -1
		END IF
	END IF
END IF
li_talla_old = -1
li_ref_marcada = 0
FOR posi = 1 TO li_result
	//ll_modelo = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'co_modelo')
	ll_reftel = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'co_reftel')
	li_caract = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'co_caract')
	li_diametro = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'diametro')
	ll_color_te = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'co_color_te')
	ldc_gramos = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'consumo_gr')
	ls_disenno = TRIM(ldgr_modelos_x_ref_pre_liberacion.GetitemString(posi,'co_disenno'))
	IF IsNull(ls_disenno) OR ls_disenno = '' THEN
		ls_disenno = '0'
	END IF
	

	li_talla_new = ldgr_modelos_x_ref_pre_liberacion.GetitemNumber(posi,'co_talla')
	//IF li_talla_old <> li_talla_new THEN
		IF al_cons_lib_duo > 1 THEN
			//ll_unid_liberar = ldgr_modelos_x_ref_pre_liberacion.GetItemNumber(posi,'cant_terminado_ant')
			ll_unid_liberar = ldgr_modelos_x_ref_pre_liberacion.GetItemNumber(posi,'unid_lib')
		ELSE
			ll_unid_liberar = ldgr_modelos_x_ref_pre_liberacion.GetItemNumber(posi,'unid_lib')
		END IF
		//si ya esta todo liberado se trae la diferencia para sumarle lo permitido y permitir liberar mas
		//jorodrig oct 30-09
		//como Leon creo tabla para cargar estas referencias que tienen esta condicion se busca en la tabla si existe la ref
		IF ll_unid_liberar <= 0 THEN
			SELECT COUNT(*)
			  INTO :li_ref_marcada
			  FROM dt_grupo_cambio_referencia
			 WHERE co_fabrica = :ai_fab
			   AND co_linea 	= :ai_linea
				AND co_referencia = :al_ref;
			
			//solo en estas referencias se permite pasar de lo programado esto lo pide yaneth cardozo con correo nov 5 - 09 realiza jorodrig
			IF li_ref_marcada > 0  THEN
				IF li_mensaje = 0 THEN
					IF MessageBox("Verificacion", "La OP esta liberada completa, Desea continuar hasta el porcentaje permitido?", Question!, YesNo!, 2) = 2 THEN
						Return -1
					END IF
				END IF
				li_mensaje = 1
			
				ll_unid_prog   = ldgr_modelos_x_ref_pre_liberacion.GetItemNumber(posi,'unid_prog')
				ll_unid_libero = ldgr_modelos_x_ref_pre_liberacion.GetItemNumber(posi,'unid_libero')
		
				SELECT MAX(porc_liberar)
				INTO :ldc_porc_liberar
				FROM m_porc_permitido
				WHERE co_fabrica 	   = :ai_fab AND
						co_linea 		= :ai_linea AND
						co_referencia  = :al_ref AND
						co_color 		= :al_color_pt;
				IF IsNull(ldc_porc_liberar) THEN
					ldc_porc_liberar = 0
				END IF
						  
				ll_unid_prog = ll_unid_prog + (ll_unid_prog * ldc_porc_liberar/100) 		  
				ll_unid_liberar = ll_unid_prog - ll_unid_libero 	
				IF ll_unid_liberar < 0 THEN ll_unid_liberar = 0
			ELSE
				ll_unid_liberar = 0
			END IF
		END IF
	

	ld_porc_perd_cabecera = luo_constantes_tela.of_consultar_numerico("PORC_PERD_ORILLO_CTE")/100 
		
		
	ld_kg_necesario = (ll_unid_liberar * ldc_gramos) / 1000
	
	//se va a sumar la perdida en el orillo al calculo anterior, esto se decide en reunion con planeacio
	//el dia 10 de julio del 2009 (jdtirado, jjmartin, lmsuarez,mrmedina, fsmartin, jorodrig) realiza jorodrig
	IF lds_perd_orillo.Retrieve(ll_reftel,li_caract) > 0 THEN
		lds_porc_perd_orillo = lds_perd_orillo.GetItemNumber(1,'porc_perd_orillo')
		lds_porc_perd_orillo = 1 + lds_porc_perd_orillo
		
	   ld_porc_perd_cabecera = 1  + ld_porc_perd_cabecera
	ELSE
		lds_porc_perd_orillo = 1
		ld_porc_perd_cabecera = 1  
	END IF
	
	ld_kg_necesario = ld_kg_necesario * lds_porc_perd_orillo
	ld_kg_necesario = ld_kg_necesario * ld_porc_perd_cabecera
		
	//sumar los kilos que hay en tintoreria y acabados
	ld_kg_proceso1 = of_total_kg_proceso(ai_fab,ai_linea,al_ref,al_color_pt,ll_reftel,ll_color_te)	
	
	
	SELECT COUNT(*)
	  INTO :li_existe
	  FROM temp_ref_liberar
	 WHERE usuario 			= :as_usuario
	   AND co_fabrica 		= :ai_fab
		AND co_linea 			= :ai_linea
		AND co_referencia 	= :al_ref
		AND co_color_pt 		= :al_color_pt
		//AND co_modelo = :ll_modelo
		AND co_reftel 			= :ll_reftel
		ANd co_caract 			= :li_caract
		AND diametro 			= :li_diametro
		AND co_color_te 		= :ll_color_te
		AND co_fabrica_exp 	= :ai_fabrica_exp
		AND co_linea_exp 		= :ai_linea_exp
		AND co_ref_exp 		= :as_ref_exp
		AND co_color_exp 		= :as_color_exp
		AND co_estampado		= :ls_disenno;
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar la temporal de referencias, ERROR: '+ls_error,StopSign!)
		Return -1
	END IF
	IF IsNull(ll_unid_liberar) THEN
		ll_unid_liberar = 0
	END IF
	IF IsNull(ld_kg_necesario) THEN
		ld_kg_necesario = 0
	END IF

	IF li_existe > 0 THEN
		UPDATE temp_ref_liberar
		SET (unid_liberar , kg_necesarios) 
		  = ((unid_liberar + :ll_unid_liberar), (kg_necesarios + :ld_kg_necesario))
		WHERE usuario 		 = :as_usuario
	   AND co_fabrica 	 = :ai_fab
		AND co_linea 		 = :ai_linea
		AND co_referencia  = :al_ref
		AND co_color_pt 	 = :al_color_pt
		//AND co_modelo 		= :ll_modelo
		AND co_reftel 		 = :ll_reftel
		ANd co_caract 		 = :li_caract
		AND diametro 		 = :li_diametro
		AND co_color_te 	 = :ll_color_te
		AND co_tipo 		 = 0
		AND co_fabrica_exp = :ai_fabrica_exp
		AND co_linea_exp 	 = :ai_linea_exp
		AND co_ref_exp 	 = :as_ref_exp
		AND co_color_exp 	 = :as_color_exp
		AND co_estampado	 = :ls_disenno;
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la temporal de referencias, ERROR: '+ls_error,StopSign!)
		Return -1
	END IF


	ELSE
	 INSERT INTO temp_ref_liberar  
         ( usuario,   
           co_fabrica,   
           co_linea,   
           co_referencia,   
           co_color_pt,   
          // co_modelo,   
           co_reftel,   
           co_caract,   
           diametro,   
           co_color_te,   
           unid_liberar,   
           kg_necesarios,   
           mt_necesarios,   
           cs_rollo,   
           tono,   
           ca_kg,   
           ca_mt,   
           ca_unidad,   
           fe_creacion,
			  co_tipo,
			  co_fabrica_exp,
			  co_linea_exp,
			  co_ref_exp,
			  co_color_exp,
			  kg_proc1,
			  co_estampado)  
  VALUES ( :as_usuario,   
           :ai_fab,   
           :ai_linea,   
           :al_ref,   
           :al_color_pt,   
           //:ll_modelo,   
           :ll_reftel,   
           :li_caract,   
           :li_diametro,   
           :ll_color_te,   
           :ll_unid_liberar,   
           :ld_kg_necesario,   
           0,
			  0,
           '',   
           0,   
           0,   
           0,   
           :ldt_fecha,
			  0,
			  :ai_fabrica_exp,
			  :ai_linea_exp,
			  :as_ref_exp,
			  :as_color_exp,
			  :ld_kg_proceso1,
			  :ls_disenno)  ;
	 IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en la temporal de referencias, ERROR: '+ls_error,StopSign!)
		Return -1
	END IF

	END IF
	
	COMMIT;
	
	//si la prenda no es bodyze se decide en reunion de sue$$HEX1$$f100$$ENDHEX$$o de tt el 7 de marzo del 2008 que no hay necedidad
	//de validar los diametros,  se puede tomar rollos de cualquier diametro. se manda un valor generico para que no valide
   //y cargue todos los rollos existentes	jorodrig marzo 14-08
	
	IF sw_bodysize = 0 THEN
		li_diametro_traer = 9999
	ELSE
		li_diametro_traer = li_diametro
	END IF
	
	//en este punto se tienen los datos iniciales, ahora se procede a cargar los datos correspondientes
	//a las op que son de la misma referencia, las de stock de tela y las op de otras referencias con
	//igual tela en alguno de sus modelos
	//jcrm
	//febrero 12 de 2008
	
	IF al_op_estilo = 0 THEN
		li_mismo_estilo = lds_telas_mismo_estilo.Retrieve(ai_fab,ai_linea,al_ref,ll_reftel,li_caract,li_diametro_traer,ll_color_te, ai_linea_exp, as_ref_exp, as_color_exp)
	ELSE
		li_mismo_estilo = lds_telas_mismo_estilo.Retrieve(al_op_estilo,ll_color_te,ll_reftel,li_caract,li_diametro_traer, ls_disenno) 
	END IF
	
	FOR li_fila = 1 TO li_mismo_estilo
		ls_tono 	= lds_telas_mismo_estilo.GetItemString(li_fila,'co_tono')
		ldc_mt  	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'ca_mt')	
		ldc_kg	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'ca_kg')	
		ll_unid	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'ca_unidades')
		ll_rollo	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'cs_rollo')
		ll_tanda	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'cs_tanda')
		ls_diseno_rollo	= TRIM(lds_telas_mismo_estilo.GetItemstring(li_fila,'co_disenno'))
		IF IsNull(ls_diseno_rollo) OR ls_diseno_rollo = '' THEN
			ls_diseno_rollo = '0'
		END IF
		
		IF ls_disenno = '0' THEN
			ls_diseno_rollo = '0'
		END IF

		ldc_mt_consumidos	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'mt_consumidos')	
		ll_unid_consumidos = lds_telas_mismo_estilo.GetItemNumber(li_fila,'unid_consumidos')	
		ldc_kg_consumidos	= lds_telas_mismo_estilo.GetItemNumber(li_fila,'kg_consumidos')	
		
		//vamos a validar que si el rollo tiene kilos consumidos sea en una op de una agrupacion, si es de otra OP no se puede cargar    --liberar op agrupada
		
		//Fin validacion
		
		//se valida que los kilos y metros del rollo sena validos, esto es porque cuando uno de estos
		//es cero el sistema no es capaz de generar el valor de ldc_kg_restar y no genera error interno
		//pero no lo despliega en pantalla para el usuario es como si estuviera intentando
		//liberar
		//jcrm
		//julio 22 de 2008
		IF (ldc_mt <= 0 OR ldc_kg <= 0) THEN
			IF ll_unid <= 0 OR IsNull(ll_unid) THEN
				Continue
			END IF
		END IF
				
		//el rollo no tiene kg disponibles para liberar, por lo tanto no se carga		
		IF	ldc_kg = ldc_kg_consumidos THEN
			Continue
		END IF
		//por el proyecto de agrupacion de pedidos se coloca que si el rollo ya tiene algo liberado solo se carga si esta en una OP de la misma agrupacio
		IF ldc_kg_consumidos > 0 OR ll_unid_consumidos > 0 THEN
			IF of_validar_op_rollo_consumido(ll_rollo, al_op_estilo, al_op_agrupada) = 1 THEN
				//el rollo esta en otra liberacion pero es de la misma agrupacion , por lo tanto se puede utilizar la parte que queda
			ELSE
				Continue
			END IF
		END IF
		//los rollos que no tienen tono pueden estar con nulo o con espacio en blanco por lo que deben
		//unificarse en la tabla que utilizaremos para trabajarlos, ya que el tono hace parte de los
		//criterios de busqueda que utilizamos y cuando no tiene tono no esta trayendo todos estos
		//rollo solo trae los que cumplan con el '' o los A, B o C
		IF trim(ls_tono) = 'A' THEN
		ELSEIF Trim(ls_tono) = 'B' THEN
		ELSEIF trim(ls_tono) = 'C' THEN
		ELSE
			ls_tono = ''
		END IF
		
		//si hay metros liberados se realiza regla de tres para calcular los kilos disponibles
		IF ldc_mt_consumidos > 0 OR ldc_kg_consumidos > 0 THEN
			IF ldc_mt = 0 THEN
				MessageBox('Advertencia','Existen Rollos con cero metros, rollo: '+string(ll_rollo)+ ' Se continua el proceso, pero el calculo de kilos puede no quedar correcto')
				ldc_mt = 1
			END IF
			IF ldc_kg_consumidos > 0 THEN   //el rollo tiene liberaciones por kilos, se toma de la tabla sin regla de 3
				ldc_kg = ldc_kg - ldc_kg_consumidos
			ELSE
				ldc_kg_restar= (ldc_mt_consumidos * ldc_kg) / ldc_mt
				ldc_kg = ldc_kg - ldc_kg_restar
			END IF
		END IF
		
		//Restar los metros o unidades  consumidos
		ldc_mt = ldc_mt - ldc_mt_consumidos
		ll_unid = ll_unid - ll_unid_consumidos
				
		IF IsNull(ll_unid) THEN ll_unid = 0
		
			SELECT COUNT(*)
			  INTO :li_existe
			  FROM temp_ref_liberar
			 WHERE usuario 			= :as_usuario
				AND co_fabrica 		= :ai_fab
				AND co_linea 			= :ai_linea
				AND co_referencia 	= :al_ref
				AND co_color_pt 		= :al_color_pt
				//AND co_modelo 		= :ll_modelo
				AND co_reftel 			= :ll_reftel
				ANd co_caract 			= :li_caract
				AND diametro 			= :li_diametro
				AND co_color_te 		= :ll_color_te
				AND cs_rollo 			= :ll_rollo
				AND co_tipo				= 1
				AND co_fabrica_exp 	= :ai_fabrica_exp
				AND co_linea_exp 	 	= :ai_linea_exp
				AND co_ref_exp 	 	= :as_ref_exp
				AND co_color_exp 	 	= :as_color_exp
				AND co_estampado		= :ls_diseno_rollo;
			IF li_existe = 0 THEN
				INSERT INTO temp_ref_liberar  
				( usuario,   
				  co_fabrica,   
				  co_linea,   
				  co_referencia,   
				  co_color_pt,   
				  //co_modelo,   
				  co_reftel,   
				  co_caract,   
				  diametro,   
				  co_color_te,   
				  cs_rollo,   
				  tono,   
				  ca_kg,   
				  ca_mt, 
				  ca_unidad,
				  fe_creacion,
				  co_tipo,
				  co_fabrica_exp,
				  co_linea_exp,
				  co_ref_exp,
				  co_color_exp,
				  kg_proc1,    
				  kg_necesarios,   
              mt_necesarios,
				  co_estampado,
				  cs_tanda)  
				VALUES 
				  ( :as_usuario,   
				  :ai_fab,   
				  :ai_linea,   
				  :al_ref,   
				  :al_color_pt,   
				  //:ll_modelo,   
				  :ll_reftel,   
				  :li_caract,   
				  :li_diametro,   
				  :ll_color_te,   
				  :ll_rollo,
				  :ls_tono,   
				  :ldc_kg,   
				  :ldc_mt, 
				  :ll_unid,
				  :ldt_fecha,
				  1,
				  :ai_fabrica_exp,
				  :ai_linea_exp,
				  :as_ref_exp,
				  :as_color_exp,
				  0,
				  0,
				  0,
				  :ls_diseno_rollo,
				  :ll_tanda)  ;
		 	 IF sqlca.sqlcode = -1 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en la temporal de referencias, ERROR: '+ls_error,StopSign!)
				Return -1
			END IF
			
		END IF
	NEXT
	IF li_mismo_estilo > 0 THEN	
		COMMIT;
	END IF
	

NEXT
Destroy ldgr_modelos_x_ref_pre_liberacion
Destroy lds_telas_mismo_estilo
Destroy lds_stock
Destroy lds_otro_estilo
Destroy lds_perd_orillo


//COMMIT;
return 1

end function

on n_cts_liberacion_x_proyeccion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_liberacion_x_proyeccion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Destroy ids_rollos_liberacion_duo
Destroy ids_consumo_rollo_duo
Destroy ids_dt_talla_unid_duo
Destroy ids_dt_pdnxmodulo_duo
Destroy ids_dt_escalasxtela_duo
end event

