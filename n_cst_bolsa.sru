HA$PBExportHeader$n_cst_bolsa.sru
forward
global type n_cst_bolsa from nonvisualobject
end type
end forward

global type n_cst_bolsa from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_validar_bolsa (long al_orden_corte, string as_po, string as_bolsa)
public function long of_validar_bongo (long al_orden_corte, long al_bongo, long ai_fab, long ai_planta, string as_po, long ai_fabrica, long ai_linea, long al_referencia)
public function long of_validar_centro_corte (long al_ordencorte, ref string as_mensaje)
public function long of_cargar_bolsas_oc_calle (long al_ordencorte, string as_bongo, ref string as_mensaje)
public function long of_ultima_bolsa (long al_orden, string as_po, long ai_fabrica, long ai_linea, long al_referencia, string as_bolsa, ref long al_duo_conjunto, ref long ai_marca)
public function long of_cliente_linea_bolsa (long al_orden_corte, string as_bolsa, string as_po)
public function long of_actualizar_bolsa (long al_orden_corte, string as_po, long al_bongo, long ai_fab, long ai_planta, decimal adc_ca_actual, string as_bolsa, long ai_subcentro, long ai_tipo, long ai_centro, long al_modulo, long ai_marca_especial)
public function long of_validar_bongo_x_pedido (string as_cs_canasta, long al_orden_corte, long al_cs_bongo)
public function integer of_actualiza_lib_agrupa (string as_bolsa, decimal adc_ca_actual)
end prototypes

public function long of_validar_bolsa (long al_orden_corte, string as_po, string as_bolsa);Long ll_count, ll_es_agrupada

//ID987 Parcial de ordenes de corte agrupadas
//Se consulta si la Orden de Corte es Agrupada
SELECT max(tipo_empate)
   INTO :ll_es_agrupada
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_orden_corte;
 
 IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la agrupacion. '+Sqlca.SqlErrText)
	Return -1
END IF

IF ll_es_agrupada = 5 THEN
	SELECT count(d.cs_canasta)
	  INTO :ll_count
	  FROM h_canasta_corte h, dt_canasta_corte d
	 WHERE h.cs_canasta = d.cs_canasta AND 
	 		    d.cs_orden_corte = :al_orden_corte AND
			    d.cs_canasta = :as_bolsa AND
			    h.co_estado = 10;
			 
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la bolsa. '+Sqlca.SqlErrText)
		Return -1
	END IF
	
ELSE
	//se verifica que la bolsa pertenezca  a la orden de corte y a la P.O.
	SELECT count(d.cs_canasta)
	  INTO :ll_count
	  FROM h_canasta_corte h, dt_canasta_corte d
	 WHERE h.cs_canasta = d.cs_canasta AND 
	 		   d.cs_orden_corte = :al_orden_corte AND
			   d.po = :as_po AND
			   d.cs_canasta = :as_bolsa AND
			   h.co_estado = 10;
			 
	IF sqlca.sqlcode = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la bolsa. '+Sqlca.SqlErrText)
		Return -1
	END IF

END IF

IF ll_count <= 0 THEN
	MessageBox('Error','La bolsa no corresponde a la orden de corte o a la P.O.')
	Return -1
END IF

Return 0
end function

public function long of_validar_bongo (long al_orden_corte, long al_bongo, long ai_fab, long ai_planta, string as_po, long ai_fabrica, long ai_linea, long al_referencia);String ls_bongo,ls_bongo2, ls_po_agrupada
Long ll_count,ll_bongo
Long li_fab, li_planta, ll_es_agrupada, ll_count_po_agrupa

uo_dsbase lds_buscar_op_agrupada

lds_buscar_op_agrupada = Create uo_dsbase
lds_buscar_op_agrupada.DataObject = 'd_gr_buscar_po_agrupada'
lds_buscar_op_agrupada.SetTransObject( SQLCA )

ls_bongo = String(al_bongo)

//ID987 Parcial de ordenes de corte agrupadas
//Se consulta si la Orden de Corte es Agrupada
SELECT max(tipo_empate)
   INTO :ll_es_agrupada
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_orden_corte;
 
 IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la agrupacion. '+Sqlca.SqlErrText)
	Return -1
END IF

//se verifica que el bongo sea valido, es decir que no exista en h_canasta_corte, y que si existe no tenga
//otra po
SELECT count(h_canasta_corte.cs_canasta)
  INTO :ll_count
  FROM h_canasta_corte,
  		 dt_canasta_corte
 WHERE pallet_id = :ls_bongo AND
 		 h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta AND
 		 ( dt_canasta_corte.po <> :as_po OR
//		 	dt_canasta_corte.co_fabrica_ref <> :ai_fabrica OR
//			dt_canasta_corte.co_linea <> :ai_linea OR
//			dt_canasta_corte.co_referencia <> :al_referencia  OR
			dt_canasta_corte.cs_orden_corte <> :al_orden_corte) AND
			(h_canasta_corte.co_estado <> 10);		  

IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar el recipiente. '+Sqlca.SqlErrText)
	Return -1
END IF

IF ll_count > 0 THEN
	//ID987 Parcial de ordenes de corte agrupadas
	//Si la OC es Agrupada, busca con la PO Agrupada, esto es en caso que se est$$HEX2$$e9002000$$ENDHEX$$loteando una OC Parcial
	IF ll_es_agrupada = 5 THEN
		IF lds_buscar_op_agrupada.Retrieve(al_orden_corte) > 0 THEN
			ls_po_agrupada = lds_buscar_op_agrupada.GetItemString(1,"po_agrupada")
			SELECT count(h_canasta_corte.cs_canasta)
			    INTO :ll_count_po_agrupa
			   FROM h_canasta_corte,
					    dt_canasta_corte
			 WHERE pallet_id = :ls_bongo AND
					    h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta AND
					    ( dt_canasta_corte.po <> :ls_po_agrupada OR
						dt_canasta_corte.cs_orden_corte <> :al_orden_corte) AND
						(h_canasta_corte.co_estado <> 10);
						
			IF sqlca.sqlcode = -1 THEN
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar el recipiente con la PO Agrupada. '+Sqlca.SqlErrText)
				Return -1
			END IF
			
			IF ll_count_po_agrupa > 0 THEN
				MessageBox('Error','El recipiente ya esta siendo utilizado por otra P.O. o referencia, por favor verifique sus datos.')
				Return -1
			END IF
		END IF
	ELSE
		MessageBox('Error','El recipiente ya esta siendo utilizado por otra P.O. o referencia, por favor verifique sus datos.')
		Return -1
	END IF
END IF

//el bongo es valido ahora debemos verificar que no este siendo usado en despachos

ls_bongo2 = mid(ls_bongo,3)
ll_bongo = Long(ls_bongo2)
//
//SELECT count(*)
//  INTO :ll_count
//  FROM dt_subcanastas
// WHERE co_fabrica_canasta = :ai_fab AND
//       co_planta_canasta  = :ai_planta AND
//		 co_canasta = :ll_bongo;
//		 
//IF sqlca.sqlcode = -1 THEN
//	MessageBox('Error','Ocurrio un error al momento de validar el recipiente en la zona de despachos. ' +Sqlca.sqlErrText)
//	Return -1
//END IF
//
//IF ll_count > 0 THEN
//	MessageBox('Error','El recipiente ya esta siendo utilizado, por favor verifique sus datos.')
//	Return -1
//END IF

//*****************************************************************************************************
//se coloca en comentario ya que se cambio la forma de generar el consecutivo y compartirlo con las 
//personas de Nicole
//jcrm
//marzo 31 de 2009

//se valida el numero del bongo

//SELECT count(*)
//  INTO :ll_count
//  FROM m_canasta
// WHERE co_fabrica = :ai_fab AND
//       co_planta 	= :ai_planta AND
//		 co_canasta = :ll_bongo;
//		 
//IF sqlca.sqlcode = -1 THEN
//	MessageBox('Error','No fue posible establecer la validez del recipiente. '+Sqlca.SqlErrText)
//	Return -1
//END IF
//
//IF ll_count > 0 THEN
//ELSE
//	MessageBox('Advertencia','El n$$HEX1$$fa00$$ENDHEX$$mero del recipiente no es valido.')
//	Return -1
//END IF
//*****************************************************************************************************


//se ha presentado que utilizan un bongo que ya habia sido utilizado en otra orden de corte
//por lo tanto se validad que este bongo no este en una orden de corte diferente a la actual
//jcrm
//marzo 28 de 2007

SELECT count(cs_canasta)
  INTO :ll_count
  FROM dt_canasta_corte
 WHERE cs_canasta = :ls_bongo AND
 		 cs_orden_corte <> :al_orden_corte;
		  
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','No fue posible establecer si el recipiente esta siendo utilizado en otra Orden de Corte. '+Sqlca.SqlErrText)
	Return -1
END IF		  

IF ll_count > 0 Then
	MessageBox('Error','El recipiente ya habia sido utilizado con otra orden de corte, cambie de recipiente.',StopSign!)
	Return -1
End if

//ahorra se verifica que el bongo ya no figure en m_lotes_conf
SELECT count(lote)
  INTO :ll_count
  FROM m_lotes_conf
 WHERE atributo1 = :ls_bongo
   AND cs_ordencorte = :al_orden_corte;
	
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','No fue posible establecer si el recipiente fue utilizado en otro loteo. '+Sqlca.SqlErrText)
	Return -1
END IF		  

IF ll_count > 0 Then
	MessageBox('Error','El recipiente ya habia sido utilizado para la misma orden de corte en un loteo anterior, cambie de recipiente.',StopSign!)
	Return -1
End if	
	

//el bongo puede ser utilizado.

Return 0

end function

public function long of_validar_centro_corte (long al_ordencorte, ref string as_mensaje);//metoda para determinar donde esta siendo cortada una orden decorte
//co_centro 90 y 91 Vestimundo
//co_centro 93 Nicole
//co centro 92 Calle
//jcrm
//mayo 2 de 2008
Long li_centro_corte

SELECT co_centro_corte
  INTO :li_centro_corte
  FROM h_mercada
 WHERE cs_orden_corte = :al_ordencorte AND
 		 co_tipo_mercada = 1;
 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = sqlca.SqlErrText
	Return -1
END IF
 
IF li_centro_corte = 92 THEN
	//se corta en la calle no deben de imprimirse los adhesivos ni leerse los mismo
	//al momento de lotear
	Return 92
Else
	Return 0
End if
 
 
Return  0 
 
 
end function

public function long of_cargar_bolsas_oc_calle (long al_ordencorte, string as_bongo, ref string as_mensaje);//metodo para dar por leidas todas las bolsas de una orden de corte, esto es 
//para las ordenes de corte que se envian a la calle
//jcrm
//mayo 2 de 2008
Long li_result, li_fila
String ls_canasta
DataStore lds_canasta

//datastore para traer todas las bolsas creadas para la orden de corte
lds_canasta = Create DataStore
lds_canasta.DataObject = 'ds_canasta_corte'
lds_canasta.SetTransObject(sqlca)
li_result = lds_canasta.retrieve(al_ordencorte)

FOR li_fila = 1 TO li_result 
	ls_canasta = lds_canasta.GetItemString(li_fila,'cs_canasta')
	//se actualizan las canastas como leidas
	UPDATE dt_canasta_corte
	   SET sw_leido = 1
	 WHERE cs_canasta = :ls_canasta;
	 
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.sqlerrtext
		Return -1
	END IF
	
	//se actualiza la fecha de modificacion de las canastas
	UPDATE dt_lectura_bolsas
	   SET fe_lectura = Current
	 WHERE cs_canasta = :ls_canasta;
	 
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.sqlerrtext
		Return -1
	END IF
	
	//se actualiza el bongo de las canastas
	UPDATE h_canasta_corte
	   SET pallet_id = :as_bongo
	 WHERE cs_canasta = :ls_canasta;
	 
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.sqlerrtext
		Return -1
	END IF
NEXT
Return 0
end function

public function long of_ultima_bolsa (long al_orden, string as_po, long ai_fabrica, long ai_linea, long al_referencia, string as_bolsa, ref long al_duo_conjunto, ref long ai_marca);Long ll_count, ll_duo, ll_fila, ll_result, ll_oc
String	ls_instruccion
DataStore lds_oc_duo

lds_oc_duo = Create DataStore
lds_oc_duo.DataObject = 'dgr_oc_duo'
lds_oc_duo.SetTransObject(sqlca)


//para establecer la ultima bolsa se deden de tener en cuenta que las ordenes ya vienen en duos
//o conjuntos y en este caso solo puede lotearse cuando lean todas las bolsas que correspondan
//jcrm - jorodrig
//noviembre 6 de 2008

//se coloca esta instruccion para darle un tiempo mas al bloqueo de la tabla dt_pdnxmodulo
ls_instruccion = "SET LOCK MODE TO WAIT 30"
Execute Immediate :ls_instruccion ;
If SQLCA.SQLCODE = -1 Then
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la instrucci$$HEX1$$f300$$ENDHEX$$n SET LOCK MODE TO WAIT 30 ~n~n" &
    + "Otro usuario esta actualizando datos, espere unos segundos antes de reintentar.~n~n" + sqlca.sqlerrtext, StopSign!)
   Return -1
End If

//revsiar si la orden de corte tiene la marca de oc con sobrantes, esta marca se coloca si en la ultima oc van a sobrar unidades comparando contra la op
//cuando la orden tiene sobrante en el campo co_estado_loteo se coloca un 3 abril 23 - 2010 jorodrig  
SELECT co_estado_loteo
  INTO :ai_marca
  FROM h_ordenes_corte
 WHERE cs_orden_corte = :al_orden;
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer si la O.C. tiene marca de oc con unidades sobrantes.',StopSign!)
	Return -2
END IF
 


//con la orden de corte se verifica si tiene marca de duo o conjunto

SELECT DISTINCT nvl(cs_unir_oc,0)
  INTO :ll_duo
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_orden
   AND co_estado_asigna <> 28;
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer si la O.C. es un duo o conjunto.',StopSign!)
	Return -2
END IF
 
IF ll_duo <= 1 THEN
	//no es un duo se trabaja de forma normal
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_canasta_corte
	 WHERE cs_orden_corte = :al_orden AND
//			 po				 = :as_po AND               //pendiente por verificar con corte,  julio 15 2013, jorodrig
//			 co_fabrica_ref = :ai_fabrica AND
//			 co_linea		 = :ai_linea AND
//			 co_referencia  = :al_referencia AND
			 sw_leido		 <> 1 AND
			 cs_canasta     <>  :as_bolsa AND
			 cs_espacio 	 > 0;
	
	IF sqlca.sqlcode = -1 THEN
		//MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar la bolsa. '+Sqlca.SqlErrText)
		Return -2
	END IF
	
	IF ll_count > 0 THEN
		Return -1
	ELSEIF ll_count = 0 THEN
		Return 0
	END IF

ELSE
	//se trata de un duo o conjunto se deben establecer las OC que lo componen y verificar que todas
	//tengas bolsas creadas en dt_canasta_corte y que estas esten leidas.
	ll_result = lds_oc_duo.Retrieve(ll_duo)
	FOR ll_fila = 1 TO ll_result
		ll_oc = lds_oc_duo.GetItemNumber(ll_fila,'cs_asignacion')
		SELECT count(*)
		  INTO :ll_count
		  FROM dt_canasta_corte
		 WHERE cs_orden_corte = :ll_oc;
		
		IF ll_count <= 0 THEN
			MessageBox('Advertencia','La O.C. '+ String(ll_oc)+ ' es parte de este duo o conjunto, pero no tiene bolsas generadas.',StopSign!)
			Return -2
		END IF
	NEXT
	al_duo_conjunto = ll_duo
	
	//todas las oc que componen el duo o conjunto tienen bolsas ahora debemos establecer si es la ultima bolsa
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_canasta_corte dt, dt_pdnxmodulo d
	 WHERE sw_leido		 		<> 1 AND
			 cs_canasta     		<>  :as_bolsa AND
			 cs_espacio 	 		> 0 AND
			 dt.cs_orden_corte 	= d.cs_asignacion AND
			 d.cs_unir_oc 			= :ll_duo AND
			 d.co_estado_asigna <> 28 AND
			 d.cs_unir_oc			<> 0;
	
	 	IF sqlca.sqlcode = -1 THEN
			//MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar la bolsa. '+Sqlca.SqlErrText)
			Return -2
		END IF
		
		IF ll_count > 0 THEN
			Return -1
		ELSEIF ll_count = 0 THEN
			Return 0
		END IF
	
END IF

//Return 0
end function

public function long of_cliente_linea_bolsa (long al_orden_corte, string as_bolsa, string as_po);//Funcion para veriricar si la orden es del cliente vestimundo y si es de linea, en ese caso
//no se valida unidades por encima, esto lo solicita edwin serna y jose jhonny martinez sep 14 -2010   realiza jorodrig
//Modificacion  sep 21, Edwin Serna pide que sea todo lo de linea lo que no se tiene que controlar por unidades por encima (correo)
//Se adiciona los codigos de Linea y Estables de SAP (linea 01 y Estable 03) este dato lo pasa jfosolop)  dic 15 - 2010 jorodrig
//se adicionoa que busque la procedencia del estilo, si el la 6 (printex) no debe validar
LONG	li_cliente_vesma, li_cliente
Long li_procedencia
STRING	as_id_linea, ls_tipo_orden, ls_lineas
Long ll_co_cliente, ll_procedencia, ll_linea,ll_cont, ll_array[]
n_cst_string 				lnv_string
n_cts_constantes_tela	luo_constantes

//El $$HEX1$$e100$$ENDHEX$$rea de Planeacion (Oscar Mauricio Olano) solicita colocar el control de corte 
//por encima a partir del tipo de pedido (SA56591) y no del id l$$HEX1$$ed00$$ENDHEX$$nea de la referencia
//adem$$HEX1$$e100$$ENDHEX$$s de solicitar, con Alexander Restrepo (SA57064)

lnv_string	= CREATE n_cst_string	

//toma las lineas validas para corte por encima
ls_lineas = luo_constantes.of_consultar_texto('LINEA_CORTE_X_ENCIMA')
//las lineas las pasa a un arreglo
lnv_string.of_convertirstring_array(ls_lineas,ll_array)

Destroy lnv_string

SELECT UNIQUE c.tipo_orden_toc, c.co_cliente_exp, nvl(b.co_procedencia,0), a.co_linea
  into :ls_tipo_orden, :ll_co_cliente, :ll_procedencia, :ll_linea
  FROM dt_canasta_corte a, h_preref_pv b, pedpend_exp c
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_canasta = :as_bolsa                                                
   AND po = :as_po
   AND a.co_fabrica_ref = b.co_fabrica
   AND a.co_linea = b.co_linea
   AND a.co_referencia = b.co_referencia
   AND b.co_tipo_ref = 'P'
   AND a.pedido = c.pedido
   AND a.co_fabrica_ref = c.co_fabrica
   AND a.co_linea = c.co_linea
   AND a.co_referencia = c.co_referencia
   AND a.co_talla = c.co_talla
   AND a.co_color = c.co_color;

IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el cliente y el tipo de estilo. '+Sqlca.SqlErrText)
	Return -1
END IF

// FACL - 2021/08/30 - ID530 - Si es agrupado puede no tener la referencia color, la talla cuando agrupa varias referencias.
If IsNull(ll_linea) Or ll_linea = 0 Then
	SELECT MAX( c.tipo_orden_toc), Max( a.co_linea )
	  	Into :ls_tipo_orden, :ll_linea
	  FROM dt_canasta_corte a, pedpend_exp c
	 WHERE cs_orden_corte = :al_orden_corte
		AND cs_canasta = :as_bolsa                                                
		AND po = :as_po
		AND a.pedido = c.pedido
		AND a.co_fabrica_ref = c.co_fabrica
		AND a.co_linea = c.co_linea
		AND a.co_referencia = c.co_referencia
		AND a.co_color = c.co_color
		AND po like 'SM%-%';
End If

//busca la linea en el arreglo para el corte por encima
FOR ll_cont=1 to upperbound(ll_array[]) 
	IF ll_linea = Long(ll_array[ll_cont]) THEN
		RETURN 1
	END IF
NEXT


//sino encuentra la linea se mira que el tipo orden sea MTO
If Trim(ls_tipo_orden) = 'MTO' Then
	Return 1
End if

Return 2

/*

li_cliente_vesma = luo_tela.of_consultar_numerico('CLIENTE_VESTIMUNDO')

SELECT UNIQUE b.id_linea, c.co_cliente, nvl(b.co_procedencia,0)
  INTO :as_id_linea, :li_cliente, :li_procedencia
  FROM dt_canasta_corte a, h_preref_pv b, peddig c
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_canasta = :as_bolsa         
   AND po = :as_po
   AND a.co_fabrica_ref = b.co_fabrica
   AND a.co_linea = b.co_linea
   AND a.co_referencia = b.co_referencia
   AND b.co_tipo_ref = 'P'
   AND a.pedido = c.pedido;
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el cliente y el tipo de estilo. '+Sqlca.SqlErrText)
	Return -1
END IF

//IF li_cliente_vesma = li_cliente AND TRIM(as_id_linea) = 'L' THEN
//	Return 2
//END IF
IF TRIM(as_id_linea) = 'L' OR TRIM(as_id_linea) = 'E' OR TRIM(as_id_linea) = '01' OR TRIM(as_id_linea) = '03' OR li_procedencia = 6 THEN
	Return 2
END IF

RETURN 1
*/

end function

public function long of_actualizar_bolsa (long al_orden_corte, string as_po, long al_bongo, long ai_fab, long ai_planta, decimal adc_ca_actual, string as_bolsa, long ai_subcentro, long ai_tipo, long ai_centro, long al_modulo, long ai_marca_especial);DateTime ldt_fecha
String ls_bongo, ls_usuario, ls_instancia
Long ll_count, ll_filas, ll_i, ll_ca_leida, ll_ca_liberada, ll_ca_actual
Long	li_ctro_corte
n_cts_constantes luo_constantes
luo_constantes = Create n_cts_constantes

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
ls_bongo = String(al_bongo)

ldt_fecha = f_fecha_servidor()

// FACL - 2021/08/10 - ID530 - Se actualiza la cantidad leida y se actualiza la referencia si es diferente a la de la canasta
String ls_find
Long ll_rb, ll_ca_bolsa, ll_cn, ll_dcn
Boolean lb_ref_bolsa_leida, lb_separa_ref = False
uo_dsbase lds_dt_op_agrupa_lib_talla, lds_ref_bolsa
lds_dt_op_agrupa_lib_talla = Create uo_dsbase
lds_dt_op_agrupa_lib_talla.DataObject = 'd_gr_dt_op_agrupa_lib_talla_leido'
lds_dt_op_agrupa_lib_talla.SetTransObject( SQLCA )

lds_ref_bolsa = Create uo_dsbase
lds_ref_bolsa.DataObject = 'd_gr_dt_op_agrupa_lib_talla_leido'
lds_ref_bolsa.SetTransObject( SQLCA )

ll_filas = lds_dt_op_agrupa_lib_talla.Retrieve( as_bolsa )
If ll_filas > 0 Then
	lb_ref_bolsa_leida = False
	If ll_filas = 1 Then
		ll_ca_leida = lds_dt_op_agrupa_lib_talla.GetItemNumber( 1, 'ca_leida' )
		ll_ca_leida += adc_ca_actual
		ll_i = 1
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'ca_leida', ll_ca_leida )
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'fe_actualizacion', ldt_fecha )
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'usuario', ls_usuario )
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'instancia', ls_instancia )
		// Si no tiene la misma referencia se marca para actualizar la referencia
		If lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) <> lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia_bolsa' ) Then				
			ll_ca_bolsa = ll_ca_leida
			ll_rb = lds_ref_bolsa.InsertRow(0)
			lds_ref_bolsa.SetItem( ll_rb, 'co_fabrica', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_fabrica' ) )
			lds_ref_bolsa.SetItem( ll_rb, 'co_linea', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_linea' ) )
			lds_ref_bolsa.SetItem( ll_rb, 'co_referencia', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) )
			lds_ref_bolsa.SetItem( ll_rb, 'ca_leida', ll_ca_bolsa )
			lb_separa_ref = True
		Else
			lb_ref_bolsa_leida = True
		End If
	Else
		ll_ca_actual = adc_ca_actual
		lds_dt_op_agrupa_lib_talla.SetSort( 'ca_liberada' )
		lds_dt_op_agrupa_lib_talla.Sort()
		For ll_i = 1 to ll_filas		
			ll_ca_leida = lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'ca_leida' )
			ll_ca_liberada = lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'ca_liberada' )
			If ll_ca_leida < ll_ca_liberada Or ll_i = ll_filas Then
				If ll_ca_leida + ll_ca_actual <= ll_ca_liberada Or ll_i = ll_filas  Then
					ll_ca_bolsa = ll_ca_actual
					ll_ca_leida += ll_ca_actual
					ll_ca_actual = 0					
				Else
					ll_ca_bolsa = ll_ca_liberada - ll_ca_leida
					ll_ca_actual = ll_ca_actual - (ll_ca_liberada - ll_ca_leida)
					ll_ca_leida = ll_ca_liberada					
				End If
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'ca_leida', ll_ca_leida )
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'fe_actualizacion', ldt_fecha )
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'usuario', ls_usuario )
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'instancia', ls_instancia )
				
				// Se almacena las referencias que no pertenecen a la bolsa
				If lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) = lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia_bolsa' ) Then				
					lb_ref_bolsa_leida = True					
				End If
				
				ls_find = 'co_fabrica = ' + String( lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_fabrica' ) ) &
					+ ' And co_linea = ' + String( lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_linea' ) ) &
					+ ' And co_referencia = ' + String( lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) )
					
				ll_rb = lds_ref_bolsa.Find( ls_find, 1, lds_ref_bolsa.RowCount() )
				If ll_rb = 0 Then
					ll_rb = lds_ref_bolsa.InsertRow(0)
					lds_ref_bolsa.SetItem( ll_rb, 'co_fabrica', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_fabrica' ) )
					lds_ref_bolsa.SetItem( ll_rb, 'co_linea', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_linea' ) )
					lds_ref_bolsa.SetItem( ll_rb, 'co_referencia', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) )
					lds_ref_bolsa.SetItem( ll_rb, 'ca_leida', ll_ca_bolsa )
					If lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) <> lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia_bolsa' ) Then
						lb_separa_ref = True
					End If
				Else
					ll_ca_bolsa += lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' )
					lds_ref_bolsa.SetItem( ll_rb, 'ca_leida', ll_ca_bolsa )
				End If
				
				If ll_ca_actual <= 0 Then Exit
			End If			
		Next
	End If
	
	If lds_ref_bolsa.RowCount() > 0 Then
		uo_dsbase lds_h_canasta, lds_dt_canasta
		
		lds_h_canasta = Create uo_dsbase
		lds_h_canasta.DataObject = 'd_gr_h_canasta_corte_x_bolsa'
		lds_h_canasta.SetTransObject(SQLCA)
		
		lds_dt_canasta = Create uo_dsbase
		lds_dt_canasta.DataObject = 'd_gr_dt_canasta_corte_x_bolsa'
		lds_dt_canasta.SetTransObject(SQLCA)
		
		ll_filas = lds_h_canasta.of_Retrieve(as_bolsa)
		If ll_filas <= 0 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error la consultar la bolsa leida' )
			Return -1
		ElseIf ll_filas = 0 Then
			
		Else
			
		End If
		
		ll_filas = lds_dt_canasta.of_Retrieve(as_bolsa)
		If ll_filas <= 0 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error la consultar el detalle de la bolsa leida' )
			Return -1
		ElseIf ll_filas = 0 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro informacion del detalle de la bolsa leida' )
			Return -1
		End If
		
		// Si la referencia que tiene la bolsa no tiene la referencia, se actualiza por la primera referencia destion
		If Not lb_ref_bolsa_leida Then
			ll_rb = 1
			lds_dt_canasta.SetItem( 1, 'co_fabrica_ref', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_fabrica' ) )
			lds_dt_canasta.SetItem( 1, 'co_linea', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_linea' ) )
			lds_dt_canasta.SetItem( 1, 'co_referencia', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_referencia' ) )
			If lds_ref_bolsa.RowCount() = 1 Then
				lb_separa_ref = False
			Else
				lds_dt_canasta.SetItem( 1, 'sw_leido', 1 )
				lds_dt_canasta.SetItem( 1, 'ca_actual', lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' ) )
				lds_dt_canasta.SetItem( 1, 'fe_actualizacion', ldt_fecha )
				lds_dt_canasta.SetItem( 1, 'usuario', ls_usuario )
				lds_dt_canasta.SetItem( 1, 'instancia', ls_instancia )				
			End If
			// Se quita del ds porque ya se actualizo 
			lds_ref_bolsa.DeleteRow( ll_rb )
		End If
		
		long li_tipoorden = -1, li_fabrica = -1
		Long ll_documento
		
		
		n_cst_funciones_comunes lnvo_funcion
		// Se recorre los datos para actualizar la bolsa leida o para crear una nueva bolsa
		For ll_rb = 1 To lds_ref_bolsa.RowCount()
			If lds_dt_canasta.GetItemNumber( 1, 'co_referencia' ) = lds_ref_bolsa.GetItemNumber( ll_rb, 'co_referencia' ) Then
				ll_cn = 1
				ll_dcn = 1
				lds_dt_canasta.SetItem( ll_dcn, 'ca_actual', lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' ) )				
				lds_dt_canasta.SetItem( ll_dcn, 'sw_leido', 1 )
				lds_dt_canasta.SetItem( ll_dcn, 'fe_actualizacion', ldt_fecha )
				lds_dt_canasta.SetItem( ll_dcn, 'usuario', ls_usuario )
				lds_dt_canasta.SetItem( ll_dcn, 'instancia', ls_instancia )	
			Else
				ll_cn = lds_h_canasta.RowCount() + 1				
				lds_h_canasta.RowsCopy( 1, 1, Primary!, lds_h_canasta, ll_cn, Primary! )
				
				If li_fabrica < 0 Then
					luo_constantes = Create n_cts_constantes
					li_fabrica = luo_constantes.of_consultar_numerico("FABRICA TELA")
					IF li_fabrica = -1 THEN
						Destroy luo_constantes
						Return -1
					END IF
					
					li_tipoorden = luo_constantes.of_consultar_numerico("TIPO CANASTA")
					IF li_tipoorden = -1 THEN
						Destroy luo_constantes
						Return -1
					END IF
				End If
				
				ll_documento = lnvo_funcion.of_Consecutivo_Ordenes( li_fabrica, li_tipoorden)
				
				lds_h_canasta.SetItem( ll_cn, 'cs_canasta', String(ll_documento) )
				lds_h_canasta.SetItem( ll_cn, 'fe_creacion', ldt_fecha )
				lds_h_canasta.SetItem( ll_cn, 'fe_actualizacion', ldt_fecha )
				lds_h_canasta.SetItem( ll_cn, 'usuario', ls_usuario )
				lds_h_canasta.SetItem( ll_cn, 'instancia', ls_instancia )	
				
				ll_dcn = lds_dt_canasta.RowCount() + 1				
				lds_dt_canasta.RowsCopy( 1, 1, Primary!, lds_dt_canasta, ll_cn, Primary! )
				
				lds_dt_canasta.SetItem( ll_dcn, 'cs_canasta', String(ll_documento) )
				lds_dt_canasta.SetItem( ll_dcn, 'co_fabrica_ref', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_fabrica' ) )
				lds_dt_canasta.SetItem( ll_dcn, 'co_linea', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_linea' ) )
				lds_dt_canasta.SetItem( ll_dcn, 'co_referencia', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_referencia' ) )
				
				lds_dt_canasta.SetItem( ll_dcn, 'ca_actual', lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' ) )				
				lds_dt_canasta.SetItem( ll_dcn, 'sw_leido', 1 )
				lds_dt_canasta.SetItem( ll_dcn, 'fe_creacion', ldt_fecha )
				lds_dt_canasta.SetItem( ll_dcn, 'fe_actualizacion', ldt_fecha )
				lds_dt_canasta.SetItem( ll_dcn, 'usuario', ls_usuario )
				lds_dt_canasta.SetItem( ll_dcn, 'instancia', ls_instancia )				
			End If
			
		Next
		
		If lds_h_canasta.Update() <> 1 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error para actualizar el contador de cantidad leido!' )
			Destroy lds_h_canasta
			Destroy lds_dt_canasta
			Destroy lds_dt_op_agrupa_lib_talla
			Return -1
		End If		
		
		If lds_dt_canasta.Update() <> 1 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error para actualizar el contador de cantidad leido!' )
			Destroy lds_h_canasta
			Destroy lds_dt_canasta
			Destroy lds_dt_op_agrupa_lib_talla
			Return -1
		End If	
		Destroy lds_h_canasta
		Destroy lds_dt_canasta
	End If
	

	If lds_dt_op_agrupa_lib_talla.Update() <> 1 Then
		ROLLBACK;
		MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error para actualizar el contador de cantidad leido!' )
		Destroy lds_dt_op_agrupa_lib_talla
		Return -1
	End If	
End If

// Si no separa referencia se actualiza los datos de la bolsa
If Not lb_separa_ref Then
	UPDATE dt_canasta_corte
		SET ca_actual 			= :adc_ca_actual,
			 sw_leido 			= 1,
			 fe_actualizacion = :ldt_fecha,
			 usuario 			= :ls_usuario,
			 instancia 			= :ls_instancia
	 WHERE cs_canasta 		= :as_bolsa	AND
			 cs_orden_corte 	= :al_orden_corte ;
	
	IF sqlca.sqlcode <> 0 THEN
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la cantidad de la bolsa. '+Sqlca.SqlErrText)
		Return -1
	END IF
End If
			
UPDATE dt_lectura_bolsas
   SET fe_lectura 		= :ldt_fecha,
		 fe_actualizacion = :ldt_fecha,
		 usuario 			= :ls_usuario,
		 instancia 			= :ls_instancia
 WHERE cs_orden_corte 	= :al_orden_corte AND
       cs_canasta     	= :as_bolsa AND
		 co_tipoprod     	= :ai_tipo AND
		 co_centro_pdn  	= :ai_centro AND
		 co_subcentro_pdn = :ai_subcentro;	
		 
IF sqlca.sqlcode <> 0 THEN
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la fecha de lectura. '+Sqlca.SqlErrText)
	Return -1
END IF


/*
UPDATE h_canasta_corte
   SET  pallet_id 			= :ls_bongo,
		  co_modulo				= :al_modulo,
		  co_modulo_fis      = :al_modulo,	
		  fe_actualizacion 	= :ldt_fecha,
		  usuario 				= :ls_usuario,
		  instancia 			= :ls_instancia
 WHERE cs_canasta = (select a.cs_canasta
 								from dt_canasta_corte a
								where  cs_orden_corte = :al_orden_corte );

IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error ','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la bolsa. '+Sqlca.SqlErrText)
	Return -1
END IF */
//marca = 3 es lote piloto, se marca el bongo con una L en el campo sw_origen
IF ai_marca_especial = 3 THEN  //se separa porque en este mismo campo se coloca la marca de bongo sobrante antes de este update.
	UPDATE h_canasta_corte
   SET  pallet_id 			= :ls_bongo,
		  co_modulo				= :al_modulo,
		  co_modulo_fis      = :al_modulo,	
		  fe_actualizacion 	= :ldt_fecha,
		  sw_origen          = 'L',
		  ob_ordprod			= '',
		  usuario 				= :ls_usuario,
		  instancia 			= :ls_instancia
 WHERE cs_canasta = :as_bolsa;
ELSE
	UPDATE h_canasta_corte
		SET  pallet_id 			= :ls_bongo,
			  co_modulo				= :al_modulo,
			  co_modulo_fis      = :al_modulo,
	  		  fe_actualizacion 	= :ldt_fecha,
			  usuario 				= :ls_usuario,
			  instancia 			= :ls_instancia
	 WHERE cs_canasta = :as_bolsa;
END IF
IF sqlca.sqlcode <> 0 THEN
	Rollback;
	MessageBox('Error 1','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la bolsa. '+Sqlca.SqlErrText)
	Return -1
END IF 
 
SELECT count(distinct co_modulo_fis)
  INTO :ll_count
  FROM h_canasta_corte
 WHERE pallet_id 		= :ls_bongo;
		 
IF ll_count > 1 THEN
	UPDATE h_canasta_corte
		SET co_modulo			= :al_modulo,
			 co_modulo_fis    = :al_modulo,	
			 fe_actualizacion = :ldt_fecha,
			 usuario 			= :ls_usuario,
			 instancia 			= :ls_instancia
	 WHERE pallet_id 			= :ls_bongo;
	 
	IF sqlca.sqlcode <> 0 THEN
		Rollback;
		MessageBox('Error 2','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la bolsa. '+Sqlca.SqlErrText)
		Return -1
	END IF 
END IF
	
//Estos son los modulos de nicole, se coloca fijo porque estos son temporales
//julio 22-2010 jorodrig
IF (al_modulo = 317 OR al_modulo = 318) THEN
	SELECT MAX(co_centro_corte)
	  INTO :li_ctro_corte
	  FROM h_mercada
	 WHERE cs_orden_corte =  :al_orden_corte
	   AND co_tipo_mercada = 1;
	IF li_ctro_corte <> 93 THEN
		UPDATE h_mercada SET co_centro_corte = 93
		WHERE cs_orden_corte =  :al_orden_corte
	   AND co_tipo_mercada = 1;
		IF sqlca.sqlcode <> 0 THEN
			Rollback;
			MessageBox('Error 2','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el centro en la mercada. '+Sqlca.SqlErrText)
			Return -1
		END IF 

	END IF
END IF
	
Return 0

end function

public function long of_validar_bongo_x_pedido (string as_cs_canasta, long al_orden_corte, long al_cs_bongo);Long ll_count
LONG		ll_pedido
STRING	ls_bongo

ls_bongo = String(al_cs_bongo)

IF IsNull(as_cs_canasta) OR as_cs_canasta = '' THEN
	MessageBox('Advertencia','No se ha ingresado el numero de la bolsa para consultar el numero del Pedido')
	Return -1
END IF
//se verifica que la bolsa pertenezca  a la orden de corte y a la P.O.
SELECT max(d.pedido)
  INTO :ll_pedido
  FROM dt_canasta_corte d, h_canasta_corte h
 WHERE d.cs_canasta = h.cs_canasta
   AND h.cs_canasta = :as_cs_canasta 
	AND d.cs_orden_corte = :al_orden_corte ;
		 
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el pedido para verificar los bongos. '+Sqlca.SqlErrText)
	Return -1
END IF

SELECT COUNT(d.cs_canasta)
  INTO :ll_count
  FROM dt_canasta_corte d, h_canasta_corte h
 WHERE d.cs_canasta = h.cs_canasta
   AND d.cs_orden_corte = :al_orden_corte
	AND d.pedido <>  :ll_pedido
	AND h.pallet_id = :ls_bongo;


IF ll_count > 0 THEN
	MessageBox('Error','Este recipiente ya se esta utilizando para otro pedido en esta orden de corte,  utilice otro recipiente')
	Return -1
END IF

Return 0
end function

public function integer of_actualiza_lib_agrupa (string as_bolsa, decimal adc_ca_actual);// FACL - 2021/08/10 - ID530 - Se actualiza la cantidad leida y se actualiza la referencia si es diferente a la de la canasta
DateTime ldt_fecha
String ls_bongo, ls_usuario, ls_instancia
Long ll_count, ll_filas, ll_i, ll_ca_leida, ll_ca_liberada, ll_ca_actual

String ls_find
Long ll_rb, ll_ca_bolsa, ll_cn, ll_dcn
Boolean lb_ref_bolsa_leida, lb_separa_ref = False
uo_dsbase lds_dt_op_agrupa_lib_talla, lds_ref_bolsa

n_cts_constantes luo_constantes
luo_constantes = Create n_cts_constantes

lds_dt_op_agrupa_lib_talla = Create uo_dsbase
lds_dt_op_agrupa_lib_talla.DataObject = 'd_gr_dt_op_agrupa_lib_talla_leido'
lds_dt_op_agrupa_lib_talla.SetTransObject( SQLCA )

lds_ref_bolsa = Create uo_dsbase
lds_ref_bolsa.DataObject = 'd_gr_dt_op_agrupa_lib_talla_leido'
lds_ref_bolsa.SetTransObject( SQLCA )

ll_filas = lds_dt_op_agrupa_lib_talla.Retrieve( as_bolsa )
If ll_filas > 0 Then
	lb_ref_bolsa_leida = False
	If ll_filas = 1 Then
		ll_ca_leida = lds_dt_op_agrupa_lib_talla.GetItemNumber( 1, 'ca_leida' )
		ll_ca_leida += adc_ca_actual
		ll_i = 1
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'ca_leida', ll_ca_leida )
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'fe_actualizacion', ldt_fecha )
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'usuario', ls_usuario )
		lds_dt_op_agrupa_lib_talla.SetItem( 1, 'instancia', ls_instancia )
		// Si no tiene la misma referencia se marca para actualizar la referencia
		If lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) <> lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia_bolsa' ) Then				
			ll_ca_bolsa = ll_ca_leida
			ll_rb = lds_ref_bolsa.InsertRow(0)
			lds_ref_bolsa.SetItem( ll_rb, 'co_fabrica', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_fabrica' ) )
			lds_ref_bolsa.SetItem( ll_rb, 'co_linea', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_linea' ) )
			lds_ref_bolsa.SetItem( ll_rb, 'co_referencia', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) )
			lds_ref_bolsa.SetItem( ll_rb, 'ca_leida', ll_ca_bolsa )
			lb_separa_ref = True
		Else
			lb_ref_bolsa_leida = True
		End If
	Else
		ll_ca_actual = adc_ca_actual
		lds_dt_op_agrupa_lib_talla.SetSort( 'ca_liberada' )
		lds_dt_op_agrupa_lib_talla.Sort()
		For ll_i = 1 to ll_filas		
			ll_ca_leida = lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'ca_leida' )
			ll_ca_liberada = lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'ca_liberada' )
			If ll_ca_leida < ll_ca_liberada Or ll_i = ll_filas Then
				If ll_ca_leida + ll_ca_actual <= ll_ca_liberada Or ll_i = ll_filas  Then
					ll_ca_bolsa = ll_ca_actual
					ll_ca_leida += ll_ca_actual
					ll_ca_actual = 0					
				Else
					ll_ca_bolsa = ll_ca_liberada - ll_ca_leida
					ll_ca_actual = ll_ca_actual - (ll_ca_liberada - ll_ca_leida)
					ll_ca_leida = ll_ca_liberada					
				End If
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'ca_leida', ll_ca_leida )
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'fe_actualizacion', ldt_fecha )
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'usuario', ls_usuario )
				lds_dt_op_agrupa_lib_talla.SetItem( ll_i, 'instancia', ls_instancia )
				
				// Se almacena las referencias que no pertenecen a la bolsa
				If lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) = lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia_bolsa' ) Then				
					lb_ref_bolsa_leida = True					
				End If
				
				ls_find = 'co_fabrica = ' + String( lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_fabrica' ) ) &
					+ ' And co_linea = ' + String( lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_linea' ) ) &
					+ ' And co_referencia = ' + String( lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) )
					
				ll_rb = lds_ref_bolsa.Find( ls_find, 1, lds_ref_bolsa.RowCount() )
				If ll_rb = 0 Then
					ll_rb = lds_ref_bolsa.InsertRow(0)
					lds_ref_bolsa.SetItem( ll_rb, 'co_fabrica', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_fabrica' ) )
					lds_ref_bolsa.SetItem( ll_rb, 'co_linea', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_linea' ) )
					lds_ref_bolsa.SetItem( ll_rb, 'co_referencia', lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) )
					lds_ref_bolsa.SetItem( ll_rb, 'ca_leida', ll_ca_bolsa )
					If lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia' ) <> lds_dt_op_agrupa_lib_talla.GetItemNumber( ll_i, 'co_referencia_bolsa' ) Then
						lb_separa_ref = True
					End If
				Else
					ll_ca_bolsa += lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' )
					lds_ref_bolsa.SetItem( ll_rb, 'ca_leida', ll_ca_bolsa )
				End If
				
				If ll_ca_actual <= 0 Then Exit
			End If			
		Next
	End If
	
	If lds_ref_bolsa.RowCount() > 0 Then
		uo_dsbase lds_h_canasta, lds_dt_canasta
		
		lds_h_canasta = Create uo_dsbase
		lds_h_canasta.DataObject = 'd_gr_h_canasta_corte_x_bolsa'
		lds_h_canasta.SetTransObject(SQLCA)
		
		lds_dt_canasta = Create uo_dsbase
		lds_dt_canasta.DataObject = 'd_gr_dt_canasta_corte_x_bolsa'
		lds_dt_canasta.SetTransObject(SQLCA)
		
		ll_filas = lds_h_canasta.of_Retrieve(as_bolsa)
		If ll_filas <= 0 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error la consultar la bolsa leida' )
			Return -1
		ElseIf ll_filas = 0 Then
			
		Else
			
		End If
		
		ll_filas = lds_dt_canasta.of_Retrieve(as_bolsa)
		If ll_filas <= 0 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error la consultar el detalle de la bolsa leida' )
			Return -1
		ElseIf ll_filas = 0 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro informacion del detalle de la bolsa leida' )
			Return -1
		End If
		
		// Si la referencia que tiene la bolsa no tiene la referencia, se actualiza por la primera referencia destion
		If Not lb_ref_bolsa_leida Then
			ll_rb = 1
			lds_dt_canasta.SetItem( 1, 'co_fabrica_ref', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_fabrica' ) )
			lds_dt_canasta.SetItem( 1, 'co_linea', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_linea' ) )
			lds_dt_canasta.SetItem( 1, 'co_referencia', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_referencia' ) )
			If lds_ref_bolsa.RowCount() = 1 Then
				lb_separa_ref = False
			Else
				lds_dt_canasta.SetItem( 1, 'sw_leido', 1 )
				lds_dt_canasta.SetItem( 1, 'ca_actual', lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' ) )
				lds_dt_canasta.SetItem( 1, 'fe_actualizacion', ldt_fecha )
				lds_dt_canasta.SetItem( 1, 'usuario', ls_usuario )
				lds_dt_canasta.SetItem( 1, 'instancia', ls_instancia )				
			End If
			// Se quita del ds porque ya se actualizo 
			lds_ref_bolsa.DeleteRow( ll_rb )
		End If
		
		long li_tipoorden = -1, li_fabrica = -1
		Long ll_documento
		
		
		n_cst_funciones_comunes lnvo_funcion
		// Se recorre los datos para actualizar la bolsa leida o para crear una nueva bolsa
		For ll_rb = 1 To lds_ref_bolsa.RowCount()
			If lds_dt_canasta.GetItemNumber( 1, 'co_referencia' ) = lds_ref_bolsa.GetItemNumber( ll_rb, 'co_referencia' ) Then
				ll_cn = 1
				ll_dcn = 1
				lds_dt_canasta.SetItem( ll_dcn, 'ca_actual', lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' ) )
				lds_dt_canasta.SetItem( ll_dcn, 'fe_actualizacion', ldt_fecha )
				lds_dt_canasta.SetItem( ll_dcn, 'usuario', ls_usuario )
				lds_dt_canasta.SetItem( ll_dcn, 'instancia', ls_instancia )	
			Else
				ll_cn = lds_h_canasta.RowCount() + 1				
				lds_h_canasta.RowsCopy( 1, 1, Primary!, lds_h_canasta, ll_cn, Primary! )
				
				If li_fabrica < 0 Then
					luo_constantes = Create n_cts_constantes
					li_fabrica = luo_constantes.of_consultar_numerico("FABRICA TELA")
					IF li_fabrica = -1 THEN
						Destroy luo_constantes
						Return -1
					END IF
					
					li_tipoorden = luo_constantes.of_consultar_numerico("TIPO CANASTA")
					IF li_tipoorden = -1 THEN
						Destroy luo_constantes
						Return -1
					END IF
				End If
				
				ll_documento = lnvo_funcion.of_Consecutivo_Ordenes( li_fabrica, li_tipoorden)
				
				lds_h_canasta.SetItem( ll_cn, 'cs_canasta', String(ll_documento) )
				lds_h_canasta.SetItem( ll_cn, 'fe_creacion', ldt_fecha )
				lds_h_canasta.SetItem( ll_cn, 'fe_actualizacion', ldt_fecha )
				lds_h_canasta.SetItem( ll_cn, 'usuario', ls_usuario )
				lds_h_canasta.SetItem( ll_cn, 'instancia', ls_instancia )	
				
				ll_dcn = lds_dt_canasta.RowCount() + 1				
				lds_dt_canasta.RowsCopy( 1, 1, Primary!, lds_dt_canasta, ll_cn, Primary! )
				
				lds_dt_canasta.SetItem( ll_dcn, 'cs_canasta', String(ll_documento) )
				lds_dt_canasta.SetItem( ll_dcn, 'co_fabrica_ref', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_fabrica' ) )
				lds_dt_canasta.SetItem( ll_dcn, 'co_linea', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_linea' ) )
				lds_dt_canasta.SetItem( ll_dcn, 'co_referencia', lds_ref_bolsa.GetItemNumber( ll_rb, 'co_referencia' ) )
				
				lds_dt_canasta.SetItem( ll_dcn, 'ca_actual', lds_ref_bolsa.GetItemNumber( ll_rb, 'ca_leida' ) )				
				lds_dt_canasta.SetItem( ll_dcn, 'sw_leido', 1 )
				lds_dt_canasta.SetItem( ll_dcn, 'fe_creacion', ldt_fecha )
				lds_dt_canasta.SetItem( ll_dcn, 'fe_actualizacion', ldt_fecha )
				lds_dt_canasta.SetItem( ll_dcn, 'usuario', ls_usuario )
				lds_dt_canasta.SetItem( ll_dcn, 'instancia', ls_instancia )				
			End If
			
		Next
		
		If lds_h_canasta.Update() <> 1 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error para actualizar el contador de cantidad leido!' )
			Destroy lds_h_canasta
			Destroy lds_dt_canasta
			Destroy lds_dt_op_agrupa_lib_talla
			Return -1
		End If		
		
		If lds_dt_canasta.Update() <> 1 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error para actualizar el contador de cantidad leido!' )
			Destroy lds_h_canasta
			Destroy lds_dt_canasta
			Destroy lds_dt_op_agrupa_lib_talla
			Return -1
		End If	
		Destroy lds_h_canasta
		Destroy lds_dt_canasta
	End If
	

	If lds_dt_op_agrupa_lib_talla.Update() <> 1 Then
		ROLLBACK;
		MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error para actualizar el contador de cantidad leido!' )
		Destroy lds_dt_op_agrupa_lib_talla
		Return -1
	End If	
End If

Return 1
end function

on n_cst_bolsa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_bolsa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

