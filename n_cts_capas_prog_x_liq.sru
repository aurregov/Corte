HA$PBExportHeader$n_cts_capas_prog_x_liq.sru
forward
global type n_cts_capas_prog_x_liq from nonvisualobject
end type
end forward

global type n_cts_capas_prog_x_liq from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_validarcapas (long al_ordencorte, long ai_fabrica, long ai_linea, long al_ref, long ai_talla, long ai_capas_prog, long ai_capas_liq, long ai_espacio)
public function long of_preliquidacioncapas (long al_ordencorte, long al_agrupacion, long ai_base_trazo, long ai_trazo, long ai_capas_new)
public function long of_tiporeferencia (long al_oc, ref string as_mensaje)
public function long of_traer_raya_oc (long al_orden_corte, long al_agrupacion, long ai_base_trazos, long ai_trazo)
public function long of_preliquidarcapaslinea (long ai_fab, long ai_lin, long al_ref, long al_color_pt, ref string as_mensaje)
end prototypes

public function long of_validarcapas (long al_ordencorte, long ai_fabrica, long ai_linea, long al_ref, long ai_talla, long ai_capas_prog, long ai_capas_liq, long ai_espacio);//funcion para generar la validacion cuando las capas liquidadas son diferentes mas o menos un 5%
//a las capas programadas.
//elaborado por Juan Carlos Restrepo Medina
//fecha: Octubre de 2005
String ls_usuario, ls_usu_autoriza, ls_instancia, ls_password
Datetime ldt_fecha
Long ll_count
Long li_concepto
s_base_parametros lstr_parametros

ls_usuario = gstr_info_usuario.codigo_usuario
//ls_instancia = gstr_info_usuario.instancia
ldt_fecha = f_fecha_servidor()
//
////primero se debe llamar la ventana para ingresar el usuario que autoriza
//open(w_autorizacion_capas)
//lstr_parametros = message.PowerObjectParm	
//
//IF lstr_parametros.hay_parametros THEN
//   ls_usu_autoriza = lstr_parametros.cadena[1]	
//	ls_password = lstr_parametros.cadena[2]
//	li_concepto = lstr_parametros.entero[1]
//	
//	//si el usuario y password son validos se validad en dt_usuxper que el perfil del usuario
//	//sea 12 $$HEX2$$f3002000$$ENDHEX$$13 en tal caso se deja realizar el cambio, de lo contrario el usuario no esta autorizado 
//	SELECT count(*)
//	  INTO :ll_count
//	  FROM dt_usuxper
//	 WHERE co_aplicacion = 40 AND
//	       co_perfil in (12,13) AND
//	       co_usuario = :ls_usu_autoriza;
//	
//	IF ll_count > 0 THEN
		//se inserta registro en el log
		
		 INSERT INTO log_capas_liq  
				( cs_orden_corte,   
				  co_fabrica,   
				  co_linea,   
				  co_referencia,   
				  co_talla,   
				  capas_prog,   
				  capas_liq,   
				  autorizacion,   
				  fe_creacion,   
				  usuario,   
				  instancia,	
				  espacio,	
				  concepto)  
	  VALUES ( :al_ordencorte,   
				  :ai_fabrica,   
				  :ai_linea,   
				  :al_ref,   
				  :ai_talla,   
				  :ai_capas_prog,   
				  :ai_capas_liq,   
				  :ls_usuario,   
				  :ldt_fecha,   
				  :ls_usuario,   
				  :ls_instancia,
				  :ai_espacio,
				  :li_concepto) 
				  USING sqlca;
				  
		IF sqlca.sqlcode = -1 THEN
			ROLLBACK;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar el log de cambios. '+ Sqlca.SqlErrText)
			Return -1
		END IF
		COMMIT;
//   ELSE
//		MessageBox('Error','El usuario no esta autorizado para permitir este cambio de capas, debe ser uno de los jefes de salon')
//		Return -1
//	END IF
//ELSE //no se selecciono ningun usuario autorizado
//	Return -1
//END IF
//
Return 0
end function

public function long of_preliquidacioncapas (long al_ordencorte, long al_agrupacion, long ai_base_trazo, long ai_trazo, long ai_capas_new);//metodo para determinar si las unidades generadas con las capas preliquidadas son menores en un %
//a las unidades programadas   esta en el 5% por debajo, por encima no controla  nov 10 - 2010 jorodrig - hablado con ljgarcia
//jcrm
//abril 11 de 2007
Long li_paquetes, li_result
Long ll_unidades, ll_programada, ll_unid_prog
Decimal ldc_porc
String ls_mensaje
n_cts_constantes_corte lpo_const_corte

SELECT Sum(dt_unidadesxtrazo.paquetes)/* / Count(*) */paquetes,
       Sum(dt_unidadesxtrazo.ca_programada)/*/ Count(*)*/ ca_programada
  INTO :li_paquetes,
		 :ll_programada
  FROM dt_unidadesxtrazo,dt_trazosxoc
 WHERE dt_unidadesxtrazo.cs_orden_corte 	= :al_ordencorte AND
		 dt_unidadesxtrazo.cs_agrupacion 	= :al_agrupacion AND
		 dt_unidadesxtrazo.cs_base_trazos 	= :ai_base_trazo AND
		 dt_unidadesxtrazo.cs_trazo 			= :ai_trazo AND
		 dt_unidadesxtrazo.cs_orden_corte	= dt_trazosxoc.cs_orden_corte and
		 dt_unidadesxtrazo.cs_agrupacion		= dt_trazosxoc.cs_agrupacion and
		 dt_unidadesxtrazo.cs_base_trazos	= dt_trazosxoc.cs_base_trazos and
		 dt_unidadesxtrazo.cs_pdn				= dt_trazosxoc.cs_pdn and
		 dt_unidadesxtrazo.cs_trazo			= dt_trazosxoc.cs_trazo and
		 dt_unidadesxtrazo.cs_seccion			= dt_trazosxoc.cs_seccion and
		 dt_unidadesxtrazo.co_modelo			= dt_trazosxoc.co_modelo and
		 dt_unidadesxtrazo.co_fabrica_tela	= dt_trazosxoc.co_fabrica_tela and
		 dt_unidadesxtrazo.co_reftel			= dt_trazosxoc.co_reftel and
		 dt_unidadesxtrazo.co_caract			= dt_trazosxoc.co_caract and
		 dt_unidadesxtrazo.diametro			= dt_trazosxoc.diametro and
		 dt_unidadesxtrazo.co_color_te		= dt_trazosxoc.co_color_te;

If sqlca.sqlcode = -1 Then
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer las unidades a preliquidar.',StopSign!)
	Return -1
End if			

ll_unidades = li_paquetes * ai_capas_new

//el porcentaje depende de si es linea o moda
li_result = of_tiporeferencia(al_ordencorte,ls_mensaje)

IF li_result = 0 THEN
	//linea
	ldc_porc = lpo_const_corte.of_consultar_numerico('DIF_PROG_LIQ_LINEA')
ELSEIF li_result = 100 THEN
	//moda
	ldc_porc = lpo_const_corte.of_consultar_numerico('DIF_PROG_LIQ_MODA')
ELSE
	//genero error
	Rollback;
	Messagebox('Error',ls_mensaje)
	Return -1
END IF

////	consulto el porcentaje permito en m_constantes_corte
//IF gstr_info_usuario.co_planta_pro = 2 THEN
//	ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_PROG_LIQ')
//ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
//	ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_PROG_LIQ NICOLE')
//END IF
	
If ldc_porc = -1 Then
	MessageBox('Error','No fue posible establecer el porcentaje permitido entre lo programado y lo liquidado.')		
	Return -1
End if

ll_unid_prog = (ll_programada * ldc_porc) / 100 

//para establecer las unidades de menos que se pueden programar
ll_programada -= ll_unid_prog

If ll_unidades < ll_programada Then
	//Rollback;
	Return 2
End if


//para establecer las unidades de mas que se pueden programar
ll_programada += ll_unid_prog

If ll_unidades > ll_programada Then
	//Rollback;
	//Return 2
	Return 0
	//por encima se puede dejar preliquidar la orden, solo controla por debajo  
End if


Return 0
  
end function

public function long of_tiporeferencia (long al_oc, ref string as_mensaje);//metodo para establecer si la orden de corte es de linea o moda
//jcrm
//febrero 26 de 2009
Long li_fab, li_lin, li_result
Long ll_ref
n_cts_cargar_temporales_liberacion luo_linea

SELECT FIRST 1 co_fabrica_pt, co_linea, co_referencia
  INTO :li_fab, :li_lin, :ll_ref
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_oc;
 
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	return -1
END IF
	
 
li_result =  luo_linea.of_verificacionlinea(li_fab,li_lin,ll_ref) 

Return li_result
end function

public function long of_traer_raya_oc (long al_orden_corte, long al_agrupacion, long ai_base_trazos, long ai_trazo);//
Long	li_raya
DataStore ld_gr_raya_x_orden_corte_agrupacion


ld_gr_raya_x_orden_corte_agrupacion = Create DataStore
ld_gr_raya_x_orden_corte_agrupacion.DataObject = 'd_gr_raya_x_orden_corte_agrupacion'
ld_gr_raya_x_orden_corte_agrupacion.SetTransObject(sqlca)

ld_gr_raya_x_orden_corte_agrupacion.Retrieve(al_orden_corte, al_agrupacion, ai_base_trazos, ai_trazo)

IF ld_gr_raya_x_orden_corte_agrupacion.rowcount() > 0 THEN
	li_raya = ld_gr_raya_x_orden_corte_agrupacion.GetItemNumber(1,'raya')
	
	Return li_raya
	
END IF

Return -1

end function

public function long of_preliquidarcapaslinea (long ai_fab, long ai_lin, long al_ref, long al_color_pt, ref string as_mensaje);//metodo para determinar si la orden de corte que estan preliquidando con capas por encima es de linea y no tiene mas de dos telas
//y que ninguna sea de rectilineos
//jcrm
//abril 22 de 2009
Long li_result, li_fila, li_caract, li_contador, li_linea
Long ll_reftel, li_cliente
DataStore lds_telas
n_cts_cargar_temporales_liberacion luo_liberar

lds_telas = Create DataStore
lds_telas.DataObject = 'dtb_telas_ficha'
lds_telas.SetTransObject(sqlca)

//traigo las telas de la referencias que se esta preliquidando
li_result = lds_telas.Retrieve(ai_fab,ai_lin,al_ref,al_color_pt)

IF li_result <= 0 THEN
	as_mensaje = 'No se posible determinar la ficha del estilo'
	Return -1
END IF

FOR li_fila = 1 TO li_result
	li_contador = lds_telas.GetItemNumber(li_fila,'cantidad_telas')
	li_caract	= lds_telas.GetItemNumber(li_fila,'co_caract')
	ll_reftel	= lds_telas.GetItemNumber(li_fila,'co_reftel')
   
	//severifica que sea una referencia de linea
	li_linea = luo_liberar.of_verificacionlinea(ai_fab, ai_lin, al_ref)  
	IF li_linea = 100 THEN
		Return 0 //no es de linea 
	ELSEIF li_linea = 0 THEN
		IF li_contador > 2 THEN
			SELECT co_cliente INTO :li_cliente
			  FROM h_preref_pv
			 WHERE co_fabrica =  :ai_fab
			   AND co_linea = :ai_lin
				AND (Cast(:al_ref as char(15) ) = h_preref_pv.co_referencia )
				AND co_tipo_ref = 'P' ;
			IF li_cliente	 = 9991 THEN
				//en el cliente Jockey se va a dejar liquidar por encima asi tenga mas unidades
				//pide ljgacia oct 7 - 09
				Return 0
			END IF
			//se trata de una referencia de mas de dos telas no se puede liquidar la tela
			//javier garcia pide con correo que todo lo de linea se deje liberar asi tenga mas de dos telas  
			//oct 15 - 09  realiza jorodrig
			Return 0
			//Return -1
		END IF
	ELSEIF li_linea = -1 THEN
		Return -1
	END IF
		
	//se verifica si al tela es rectilinea
	IF luo_liberar.of_rectilineo(ll_reftel,li_caract) <> 0 THEN
		REturn -1 //no es rectilineo o no fue posible establecer esto
	END IF

NEXT


Return 0
end function

on n_cts_capas_prog_x_liq.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_capas_prog_x_liq.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

