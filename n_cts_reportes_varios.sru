HA$PBExportHeader$n_cts_reportes_varios.sru
forward
global type n_cts_reportes_varios from nonvisualobject
end type
end forward

global type n_cts_reportes_varios from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_cargar_tela_bodega (long ai_centro)
public function long of_disponibles ()
public function long of_sobrantes ()
public function long of_inicializar_datos ()
public function long of_update_temp_rep_kilos_centro (long ai_tipo_tela, long ai_tipo_concepto, decimal ad_kilos, long al_rollos, decimal ad_kilosm5, long al_rollosm5, decimal ad_kilostono, long al_rollostono)
end prototypes

public function long of_cargar_tela_bodega (long ai_centro);/*Esta funcion recorrre el maestro de rollos en un centro pasado como parametro
y carga todos los rollos que hay que no son ni sobrantes ni disponibles (concepto planeador del rollo)
por cada rollo examina si el rollo esta programado para una op de estilo o si es un
stock de tela reservado para un grupo o es stock de tela sobrante,  ademas verica de cada rollo
si los kilos son menores a 5 y si el rollo esta sin tanda.
Al final se insertan los datos en una tabla temporal

jorodrig - jcrestme    junio 5 - 2008   (solicit$$HEX2$$f3002000$$ENDHEX$$Federico Ospina)
*/


Long		li_planeador, li_tipotela, li_tipo_pedido, li_tipo_cpto
Long		li_tot_menor, li_tot_sintono
LONG			ll_cs_rollo, ll_ordenpd_pt, ll_referencia, posi, li_filas
STRING		ls_tono
DECIMAL{2}	ld_ca_kg, ld_kg_menor, ld_kg_sintono

DataStore ld_rollos_centro

ld_rollos_centro = Create Datastore 
ld_rollos_centro.DataObject = 'd_rollos_centro'
ld_rollos_centro.SetTransObject(sqlca)


of_inicializar_datos()

li_filas = ld_rollos_centro.Retrieve(ai_centro)
FOR posi = 1 TO li_filas
	ll_cs_rollo    = ld_rollos_centro.GetItemNumber(posi, 'cs_rollo')
	ll_ordenpd_pt  = ld_rollos_centro.GetItemNumber(posi, 'cs_orden_pr_act')
	ld_ca_kg       = ld_rollos_centro.GetItemNumber(posi, 'ca_kg')
	ls_tono        = ld_rollos_centro.GetItemString(posi, 'co_tono')
	li_planeador   = ld_rollos_centro.GetItemNumber(posi, 'co_planeador')
	li_tipotela    = ld_rollos_centro.GetItemNumber(posi, 'co_tiptel')
	
	IF li_tipotela = 2 OR li_tipotela = 11 THEN
		li_tipotela = 2  //tela plana
	ELSE
		li_tipotela = 1  //tejido punto
	END IF
	
	SELECT tipo_pedido, co_referencia
	  INTO :li_tipo_pedido, :ll_referencia
	  FROM h_ordenpd_pt
	 WHERE cs_ordenpd_pt = :ll_ordenpd_pt;
	 
	IF li_tipo_pedido = 0 OR li_tipo_pedido = 1 OR li_tipo_pedido = 2 OR li_tipo_pedido = 3 THEN
		li_tipo_cpto = 2   //op estilo tradicional
   ELSEIF (li_tipo_pedido = 8  AND ll_referencia <> 100949) OR li_tipo_pedido = 10 THEN
		li_tipo_cpto = 1   //Reserva para coleccion nueva
	ELSE
		li_tipo_cpto = 4   //stock de tela
	END IF
	
	IF ld_ca_kg < 5 THEN
		ld_kg_menor = ld_ca_kg
		li_tot_menor = 1
	ELSE
		ld_kg_menor = 0
		li_tot_menor = 0
	END IF
		
	IF IsNull(ls_tono) THEN
		ld_kg_sintono = ld_ca_kg
		li_tot_sintono = 1
	ELSE
		ld_kg_sintono = 0
		li_tot_sintono = 0
	END IF
		
	//actualizamos los datos en bd
	of_update_temp_rep_kilos_centro(li_tipotela,li_tipo_cpto,ld_ca_kg,1,ld_kg_menor,li_tot_menor,ld_kg_sintono,li_tot_sintono)
		
		
NEXT

//actualizar datos en la tabla temporal del reporte
of_disponibles()
of_sobrantes()


commit;

Return 1

end function

public function long of_disponibles ();Decimal{2} ldc_kilos, ldc_kilos_menos5, ldc_kilos_tono
Long ll_rollos, ll_rollos_menos5, ll_rollos_tono
String	ls_error


//primero hacemos el update del tipo de tela plana
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos,
       :ll_rollos
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND
		 ( m_rollo.co_planeador 		  = 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar disponibles plano de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 
IF IsNull(ldc_kilos) THEN ldc_kilos = 0
IF IsNull(ll_rollos) THEN ll_rollos = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo)		 
  INTO :ldc_kilos_menos5,
       :ll_rollos_menos5
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  = 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.ca_kg					  < 5) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);	
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar disponibles plano menor a 5 de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 
IF IsNull(ldc_kilos_menos5) THEN ldc_kilos_menos5 = 0	
IF IsNull(ll_rollos_menos5) THEN ll_rollos_menos5 = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos_tono,
       :ll_rollos_tono
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  = 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_tono not in ('A','B','C') ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);		
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar disponibles plano sin tono de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 
IF IsNull(ldc_kilos_tono) THEN ldc_kilos_tono = 0
IF IsNull(ll_rollos_tono) THEN ll_rollos_tono = 0
		 
//aca realizamos el update para la tela plana
of_update_temp_rep_kilos_centro(2,3,ldc_kilos,ll_rollos,ldc_kilos_menos5,ll_rollos_menos5,ldc_kilos_tono,ll_rollos_tono)
		

//buscamos la informacion para la tela de punto
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos,
       :ll_rollos
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND
		 ( m_rollo.co_planeador 		  = 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  not in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar disponibles punto de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

IF IsNull(ldc_kilos) THEN ldc_kilos = 0
IF IsNull(ll_rollos) THEN ll_rollos = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo)		 
  INTO :ldc_kilos_menos5,
       :ll_rollos_menos5
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  = 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.ca_kg					  < 5) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  not in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);	
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar disponibles punto menor a 5 de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

IF IsNull(ldc_kilos_menos5) THEN ldc_kilos_menos5 = 0	
IF IsNull(ll_rollos_menos5) THEN ll_rollos_menos5 = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos_tono,
       :ll_rollos_tono
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  = 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_tono not in ('A','B','C') ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  not in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);		
 IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar disponibles punto sin tono de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

IF IsNull(ldc_kilos_tono) THEN ldc_kilos_tono = 0
IF IsNull(ll_rollos_tono) THEN ll_rollos_tono = 0
		 
//realizamos el update para la tela de punto		 
of_update_temp_rep_kilos_centro(1,3,ldc_kilos,ll_rollos,ldc_kilos_menos5,ll_rollos_menos5,ldc_kilos_tono,ll_rollos_tono)		 
Return 0		 
end function

public function long of_sobrantes ();Decimal{2} ldc_kilos, ldc_kilos_menos5, ldc_kilos_tono
Long ll_rollos, ll_rollos_menos5, ll_rollos_tono
String	ls_error


//primero hacemos el update del tipo de tela plana
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos,
       :ll_rollos
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND
		 ( m_rollo.co_planeador 		  <> 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar sobrantes plano de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 
IF IsNull(ldc_kilos) THEN ldc_kilos = 0
IF IsNull(ll_rollos) THEN ll_rollos = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo)		 
  INTO :ldc_kilos_menos5,
       :ll_rollos_menos5
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  <> 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.ca_kg					  < 5) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);	
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar sobrantes plano menor a 5 de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

 IF IsNull(ldc_kilos_menos5) THEN ldc_kilos_menos5 = 0
 IF IsNull(ll_rollos_menos5) THEN ll_rollos_menos5 = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos_tono,
       :ll_rollos_tono
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  <> 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_tono not in ('A','B','C') ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);	
 IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar sobrantes plano sin tono de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		
 IF IsNull(ldc_kilos_tono) THEN ldc_kilos_tono = 0
 IF IsNull(ll_rollos_tono) THEN ll_rollos_tono = 0
		 
//aca realizamos el update para la tela plana
of_update_temp_rep_kilos_centro(2,5,ldc_kilos,ll_rollos,ldc_kilos_menos5,ll_rollos_menos5,ldc_kilos_tono,ll_rollos_tono)


//buscamos la informacion para la tela de punto
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos,
       :ll_rollos
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND
		 ( m_rollo.co_planeador 		  <> 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  not in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar sobrantes punto de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

IF IsNull(ldc_kilos) THEN ldc_kilos = 0
IF IsNull(ll_rollos) THEN ll_rollos = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo)		 
  INTO :ldc_kilos_menos5,
       :ll_rollos_menos5
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  <> 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.ca_kg					  < 5) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  not in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);	
IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar sobrantes punto menor a 5 de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

IF IsNull(ldc_kilos_menos5) THEN ldc_kilos_menos5 = 0
IF IsNull(ll_rollos_menos5) THEN ll_rollos_menos5 = 0
		 
SELECT sum(m_rollo.ca_kg),
		 count( distinct cs_rollo) 
  INTO :ldc_kilos_tono,
       :ll_rollos_tono
  FROM m_cpto_bodega,   
		 m_rollo,
		 h_telas
 WHERE ( m_cpto_bodega.co_cpto_bodega = m_rollo.co_planeador ) AND  
		 ( m_rollo.co_planeador 		  <> 2 ) AND  
		 ( m_cpto_bodega.tipo 			  = 1  ) AND
		 ( m_rollo.co_tono not in ('A','B','C') ) AND
		 ( m_rollo.co_reftel_act		  = h_telas.co_reftel ) AND
		 ( m_rollo.co_caract_act		  = h_telas.co_caract ) AND
		 ( h_telas.co_tiptel				  not in (2, 11) ) AND
		 ( m_rollo.co_centro				  = 15	);		
 IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Error al momento de consultar sobrantes punto sin tono de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF		 

IF IsNull(ldc_kilos_tono) THEN ldc_kilos_tono = 0
IF IsNull(ll_rollos_tono) THEN ll_rollos_tono = 0
		 
//realizamos el update para la tela de punto		 
of_update_temp_rep_kilos_centro(1,5,ldc_kilos,ll_rollos,ldc_kilos_menos5,ll_rollos_menos5,ldc_kilos_tono,ll_rollos_tono)		 
Return 0		 
end function

public function long of_inicializar_datos ();Long li_fila
String ls_error

//se inicializa la tabla temporal, primero se eliminan todos los registros
//que halla creado dicho usuario y luego se realiza la carga de los datos
//con valores en cero para poder utilizar la sentencia update en las 
//demas funciones que generan el reporte
//jcrm
//junio 6 de 2008

DELETE FROM temp_rep_kilos_centro
WHERE usuario = :gstr_info_usuario.codigo_usuario;

IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Borrando','No fue posible inicializar la tabla temporal, ERROR: '+ls_error)
	Return -1
END IF

FOR li_fila = 1 TO 5
	INSERT INTO temp_rep_kilos_centro  
				( tipo_pedido,   
				  tipo_tela,   
				  usuario,   
				  ca_kg,   
				  ca_rollo,   
				  ca_kg_menos5,   
				  ca_rollo_menos5,   
				  ca_kg_tono,   
				  ca_rollo_tono )  
	  VALUES ( :li_fila,   
				  1,   
				  :gstr_info_usuario.codigo_usuario,   
				  0,   
				  0,   
				  0,   
				  0,   
				  0,   
				  0 )  ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error Insertando 1','No fue posible inicializar la tabla temporal, ERROR: '+ls_error)
		Return -1
	END IF

	INSERT INTO temp_rep_kilos_centro  
				( tipo_pedido,   
				  tipo_tela,   
				  usuario,   
				  ca_kg,   
				  ca_rollo,   
				  ca_kg_menos5,   
				  ca_rollo_menos5,   
				  ca_kg_tono,   
				  ca_rollo_tono )  
	  VALUES ( :li_fila,   
				  2,   
				  :gstr_info_usuario.codigo_usuario,   
				  0,   
				  0,   
				  0,   
				  0,   
				  0,   
				  0 )  ;
				  
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error Insertando 2','No fue posible inicializar la tabla temporal, ERROR: '+ls_error)
		Return -1
	END IF
	
NEXT 

COMMIT;

Return 0
end function

public function long of_update_temp_rep_kilos_centro (long ai_tipo_tela, long ai_tipo_concepto, decimal ad_kilos, long al_rollos, decimal ad_kilosm5, long al_rollosm5, decimal ad_kilostono, long al_rollostono);String ls_error

UPDATE temp_rep_kilos_centro  
   SET ca_kg 				= ca_kg + :ad_kilos,   
		 ca_rollo 			= ca_rollo + :al_rollos,   
		 ca_kg_menos5 		= ca_kg_menos5 + :ad_kilosm5,   
		 ca_rollo_menos5 	= ca_rollo_menos5 + :al_rollosm5,   
		 ca_kg_tono 		= ca_kg_tono + :ad_kilostono,   
		 ca_rollo_tono 	= ca_rollo_tono + :al_rollostono 
 WHERE usuario 	 = :gstr_info_usuario.codigo_usuario	AND
 		 tipo_pedido = :ai_tipo_concepto AND  
       tipo_tela 	 = :ai_tipo_tela;

IF sqlca.sqlcode <> 0 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de ingresar la informacion de kilos y rollos, ERROR: '+ls_error)
	Return -1
END IF
		
COMMIT;

Return 0
end function

on n_cts_reportes_varios.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_reportes_varios.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

