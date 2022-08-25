HA$PBExportHeader$n_cst_loteo_bongo.sru
forward
global type n_cst_loteo_bongo from nonvisualobject
end type
end forward

global type n_cst_loteo_bongo from nonvisualobject autoinstantiate
end type

type variables

String is_mensaje
Boolean ib_mostrar_mensaje = True, ib_enviar_correo = True, ib_crear_log_bongo_sin_pdp = True
end variables

forward prototypes
public function long of_devolver_loteo (string as_bongo)
public function long of_cargar_despachos (string as_bongo)
public function long of_loteo_bongo (string as_bongo, long ai_tipocentro, long al_ordencorte, string as_loteo_max)
public function long of_cargar_auditor (long al_ordencorte, string as_po)
public function long of_verificar_unidades_liq (long al_orden_corte)
public function long of_validar_oc_loteada (long al_ordencorte, long ai_fab, long ai_lin, long al_ref)
public function long of_generarconsecutivobongo ()
public function long of_actualizar_unidades_liberadas_op (long al_ordencorte)
public function long of_act_pdp_corte (long al_oc)
public function long of_validar_unid_iguales_duo (long al_cs_unir_oc)
public function long of_validar_unid_lotear_vs_po (long al_orden_corte, string as_po, long ai_fabrica, long ai_linea, long al_referencia, string as_bongo, ref datastore ads_unid_sobrantes_loteo)
public function long of_actualiza_pdp_confeccion (string as_bongo)
public function long of_actualiza_pdp_confeccion_x_oc (long an_orden_corte)
public function long of_tipo_orden_corte (long al_orden_corte)
public function long of_crea_bongos_loeados_pdp_confeccion ()
public function integer of_ubicar_auto_bongo_loteado (long al_orden_corte)
public function long of_validar_unid_lotear_vs_po_agrupa (long al_orden_corte, string as_po, long ai_fabrica, long ai_linea, long al_referencia, string as_bongo, ref datastore ads_unid_sobrantes_loteo)
end prototypes

public function long of_devolver_loteo (string as_bongo);Long li_estadocanasta
Long ll_fila2
String ls_canasta
DataStore lds_canasta

SELECT	unique co_estado
INTO :li_estadocanasta
FROM h_canasta_corte
WHERE cs_canasta > 0 AND
		co_estado = 30 AND
		pallet_id = :as_bongo;
		
IF SQLCA.SQLCode = -1 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","Error al validar el estado de las canastas " + SQLCA.SQLErrText)
	Return -1
ELSE
	IF SQLCA.SQLCode = 100 THEN
		ROLLBACK;
		MessageBox("Advertencia...","El recipiente no se encuentra loteado")
		Return -1
	END IF
END IF

DECLARE sp_borrar_lotes PROCEDURE FOR
	pr_borrar_lotesxcanasta(:as_bongo);
	
EXECUTE sp_borrar_lotes;
IF SQLCA.SQLCode = -1 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","Error al borrar los lotes del despacho " + SQLCA.SQLErrText)
	Return -1
END IF

DECLARE sp_devloteo PROCEDURE FOR
	pr_devlotxcan(:as_bongo);
	
EXECUTE sp_devloteo;
IF SQLCA.SQLCode = -1 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","Error al devolver el loteo " + SQLCA.SQLErrText)
	Return -1
END IF

//***********************ahorra se actualizan las tablas  de la canasta
UPDATE h_canasta_corte
	SET co_estado = 10
 WHERE pallet_id = :as_bongo;	
 
IF sqlca.sqlcode <> 0 THEN
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado de las bolsas del recipiente. '+sqlca.SqlErrText)
	Return -1
END IF

//*********************creo datastore para recorrer los bongos y sus respectivas bolsas
lds_canasta = Create DataStore
lds_canasta.DataObject = 'ds_h_canasta_corte_bongo' //*********recorro las bolsas de un bongo
lds_canasta.SetTransObject(sqlca)

//se hace datastore para recorrer todas las bolsas del bongo e ir actualizando  el campo sw_cerrados en la
//tabla dt_canasta_corte
lds_canasta.Retrieve(as_bongo)

For ll_fila2 = 1 To lds_canasta.RowCount()
	ls_canasta = lds_canasta.GetItemString(ll_fila2,'cs_canasta')
	UPDATE dt_canasta_corte
		SET sw_cerrados = 0
	 WHERE cs_canasta = :ls_canasta;	
	 
	IF sqlca.sqlcode <> 0 THEN
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cerrar las bolsas del recipiente. '+sqlca.SqlErrText)
		Return -1
	END IF
Next

Return 1
end function

public function long of_cargar_despachos (string as_bongo);//*************************carga las canastas de despachos
DECLARE canastas PROCEDURE &
	FOR pr_carga_canasta_desp(:as_bongo,1);
EXECUTE canastas;

IF SQLCA.SQLCode = -1 THEN
	//ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_carga_canasta_desp. "+ SQLCA.SQLErrText)			
	Return -1
END IF

CLOSE canastas;

//*******************************se cargan los lotes por canasta //proceso
DECLARE lotesxcanasta PROCEDURE &
  	FOR pr_invoca_lotesxcanasta(:as_bongo) ;
EXECUTE lotesxcanasta;

IF sqlca.SQLCode = -1 THEN
	//ROLLBACK  ;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_cargar_lotesxcanasta." + SQLCA.SQLErrText)			
	Return -1
END IF

CLOSE lotesxcanasta ;


Return 1

end function

public function long of_loteo_bongo (string as_bongo, long ai_tipocentro, long al_ordencorte, string as_loteo_max);Long li_fab,  li_fabrica, li_fab_inf, li_corte_adelantado, li_centro_corte, li_fabrica_loteo
String ls_canasta, ls_po, ls_error, ls_tipo_atributo, ls_sw_origen
Long ll_fila, ll_fila2, ll_result, ll_found, ll_orden_corte, ll_insumos, ll_tipo
Long	li_fabrica_confeccion, li_planta_confeccion, li_cpto_critica
DataStore lds_canasta
n_cts_constantes lpo_constantes
lpo_constantes = Create n_cts_constantes

li_fabrica_loteo = lpo_constantes.of_consultar_numerico('FABRICA PLANTA')


//***** traer el centro al que se asigno la orden de corte ******//
SELECT MAX(co_centro_corte)
  INTO :li_centro_corte
  FROM h_mercada
 WHERE cs_orden_corte =  :al_ordencorte
   AND co_tipo_mercada = 1;
IF IsNull(li_centro_corte) OR li_centro_corte = 0 THEN
	li_centro_corte = 90   //por defecto se deja con el centro 90 que es el de corte Marinilla.  esto cuando este todo poblado con datos se puede quitar.
END IF

//*******Traer la fabrica y planta de confeccion en la cual se debe cargar la canasta segun el centro donde se esta loteando ******* //
SELECT co_fabrica_confeccion, co_planta_confeccion
  INTO :li_fabrica_confeccion, :li_planta_confeccion
  FROM m_centros a, m_plantas b
 WHERE a.co_planta_centro = b.co_planta
   AND b.co_fabrica = :li_fabrica_loteo
	AND a.co_centro = :li_centro_corte;
IF IsNull(li_fabrica_confeccion) OR li_fabrica_confeccion = 0 THEN
	ROLLBACK;
	MessageBox('Error','La fabrica de confeccion a la cual se debe cargar la canasta esta en cero, debe configurar esta en el maestro de plantas, segun el centro de corte y la planta del centro')
	Return -1
END IF
IF IsNull(li_fabrica_confeccion) OR li_fabrica_confeccion = 0 THEN
	ROLLBACK;
	MessageBox('Error','La fabrica de confeccion a la cual se debe cargar la canasta esta en cero o nulo, debe configurar esta en el maestro de plantas, segun el centro de corte y la planta del centro')
	Return -1
END IF 
IF IsNull(li_planta_confeccion) OR li_planta_confeccion = 0 THEN
	ROLLBACK;
	MessageBox('Error','La planta de confeccion a la cual se debe cargar la canasta esta en cero o nulo, debe configurar esta en el maestro de plantas, segun el centro de corte y la planta del centro')
	Return -1
END IF 





//*********************creo datastore para recorrer los bongos y sus respectivas bolsas
lds_canasta = Create DataStore
lds_canasta.DataObject = 'ds_h_canasta_corte_bongo' //*********recorro las bolsas de un bongo
lds_canasta.SetTransObject(sqlca)
		
li_fabrica = Long(Mid(as_bongo,1,1))
//*********************************se lotean las canastas
DECLARE lotear PROCEDURE &
	FOR pr_lotxcan(:as_bongo,:li_fabrica_loteo,:li_planta_confeccion,:ai_tipocentro);
EXECUTE lotear;

IF SQLCA.SQLCode = -1 THEN
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_lotxcan. "+ ls_error)			
	Return -1
END IF

CLOSE lotear;



//Se realiza este query para saber si la orden de corte es corte adelantado, esto s sabe si se compara la fecha de incio
//de corte contra la fecha actual y si es mayor es corte adelantado.  Si la orden es corte adelantado se coloca una marca 
//en h_canasta_corte (campo co_tipo_atributo = CA)   realiza fcanooca y jorodrig enero 18 - 2011
SELECT count(*) 
INTO :li_corte_adelantado
FROM dt_cronograma c, dt_arbol_pedido a, dt_canasta_corte d
WHERE c.pedido 			= a.pedido_raiz and
      d.pedido 			= a.pedido_hijo and
      c.co_tipoprod 		= 99 and
      c.co_centro_pdn	= 99 and
      c.co_subcentro_pdn= 110 and
      a.co_fabrica 		= d.co_fabrica_ref and
      a.co_linea 			= d.co_linea and
      a.co_referencia 	= d.co_referencia and
		d.cs_orden_corte 	= :al_ordencorte and
      c.fe_inicio_progs > today;
		
//se revisa que la fecha de llegada de insumos sea mayor a la fecha actual
SELECT count(*) 
INTO :ll_insumos
FROM dt_cronograma c, dt_arbol_pedido a, dt_canasta_corte d
WHERE c.pedido 			= a.pedido_raiz and
      d.pedido 			= a.pedido_hijo and
      c.co_tipoprod 		= 99 and
      c.co_centro_pdn	= 99 and
      c.co_subcentro_pdn= 107 and
      a.co_fabrica 		= d.co_fabrica_ref and
      a.co_linea 			= d.co_linea and
      a.co_referencia 	= d.co_referencia and
		d.cs_orden_corte 	= :al_ordencorte and
      c.fe_final_progs > today;

//para verifica que no sea lote piloto li_cpto_critica = 3
SELECT MAX(nvl(co_cpto_critica,0))
  INTO :li_cpto_critica
  FROM h_ordenes_corte
 WHERE cs_orden_corte = :al_ordencorte; 
	
If Isnull(li_cpto_critica) Then li_cpto_critica = 0
	
//verifica si la orden de corte es MUESTRA VENDEDOR - LOTE PILOTO, tipo = 2 
ll_tipo = of_tipo_orden_corte(al_ordencorte)

IF li_corte_adelantado > 0 and ll_insumos > 0 and li_cpto_critica <> 3 and ll_tipo <>  2 THEN
	ls_tipo_atributo = 'CA'
ELSE
	ls_tipo_atributo = 'N'
END IF

IF IsNull(li_fabrica)  OR li_fabrica = 0 THEN
	ROLLBACK;
	MessageBox('Error','La fabrica propietario de la canasta va a quedar en blanco, se cancela el proceso, informe a sistemas')
	Return -1
END IF

//mira si el bongo es sobrante, se coloca tipo atributo corte por encima
select max(sw_origen) into :ls_sw_origen
from h_canasta_corte
 WHERE pallet_id = :as_bongo;	
 
If ls_sw_origen = 'S' Then
	ls_tipo_atributo = 'CE'
End if
//***********************ahorra se actualizan las tablas  de la canasta
UPDATE h_canasta_corte
	SET co_estado = 30,
		 co_fabrica_pro = :li_fabrica,
		 co_fabric_pro_des = :li_fabrica,
		 co_tipo_atributo   = :ls_tipo_atributo,
		 atributo3 = :as_loteo_max,
		 co_fabrica_act = :li_fabrica_confeccion,
		 co_planta_act = :li_planta_confeccion,
		 co_planta = :li_planta_confeccion,
		 fe_planta = current,
		 fe_loteo = current,
		 fe_subcentro = current
 WHERE pallet_id = :as_bongo;	
 
IF sqlca.sqlcode <> 0 THEN
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado de las bolsas del recipiente. '+sqlca.SqlErrText)
	Return -1
END IF

//se hace datastore para recorrer todas las bolsas del bongo e ir actualizando  el campo sw_cerrados en la
//tabla dt_canasta_corte
lds_canasta.Retrieve(as_bongo)

For ll_fila2 = 1 To lds_canasta.RowCount()
	ls_canasta = lds_canasta.GetItemString(ll_fila2,'cs_canasta')
	UPDATE dt_canasta_corte
		SET sw_cerrados = 1
	 WHERE cs_canasta = :ls_canasta;	
	 
	IF sqlca.sqlcode <> 0 THEN
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cerrar las bolsas del recipiente. '+sqlca.SqlErrText)
		Return -1
	END IF
Next

//**********************************se actualiza la liberacion
DECLARE liberar PROCEDURE &
	FOR pr_act_liberacion(:as_bongo,1);
EXECUTE liberar;

IF SQLCA.SQLCode = -1 THEN
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_act_liberacion." + ls_error)			
	Return -1
END IF

CLOSE liberar;

//***********************************se carga el kardex por po
DECLARE kardexpo PROCEDURE &
		FOR Pr_invoca_kardex(:as_bongo);
EXECUTE kardexpo;

IF SQLCA.SQLCode = -1 THEN
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_graba_pdn. "+ ls_error)			
	Return -1
END IF

CLOSE kardexpo;

Destroy lds_canasta;	


Return 0
end function

public function long of_cargar_auditor (long al_ordencorte, string as_po);/***********************************************************
SA54608 - Ceiba/jjmonsal - 14-06-2016
Comentario:Creaci$$HEX1$$f300$$ENDHEX$$n de campo para el empacador en la O.C
Se altera las tablas mv_loteo_auditor y m_auditor_po para almacenar el Empacador 
***********************************************************/
long 		li_max_loteo, li_fabrica, li_linea, li_result
Long 			ll_referencia, ll_codigo, ll_result, ll_unidades, ll_fila, ll_duo, li_ordencorte, ll_row, ll_color, ll_co_empacador
string 		ls_usuario,ls_instancia,ls_error, ls_po, ls_empacador
datetime 	dt_fe_actualiza, ldt_fecha
DataStore 	lds_loteo, lds_oc_po

n_cst_orden_corte luo_corte

lds_loteo = Create DataStore
lds_oc_po = Create DataStore

lds_loteo.DataObject = 'ds_auditor_dt_canasta_corte'

lds_loteo.SetTransObject(sqlca)

dt_fe_actualiza = f_fecha_servidor()
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
		
//se debe estlabecer si la orden de corte es duo o conjunto - jcrm -Noviembre 10 de 2008
ll_duo = luo_corte.of_duo_conjunto(al_ordencorte)
IF ll_duo <= 0 THEN
	//no es duo se averigua el auditor por la orden en particular
	lds_oc_po.DataObject = 'dgr_oc_po'
	lds_oc_po.SetTransObject(sqlca)	
	li_result = lds_oc_po.Retrieve(al_ordencorte)
ELSE
	//es duo se deben traer todas las ordenes - po, que componen el duo y
	//y cargar el auditor de calidad
	lds_oc_po.DataObject = 'dgr_oc_po_duo'
	lds_oc_po.SetTransObject(sqlca)
	li_result =	lds_oc_po.Retrieve(ll_duo)
END IF
	
For ll_row = 1 TO li_result	
	li_ordencorte = lds_oc_po.GetItemNumber(ll_row,'cs_asignacion')
	ls_po	 = lds_oc_po.GetItemString(ll_row,'po')

	//se debe extraer el codigo del auditor de calidad que autorizo el loteo, SA54608 - Ceiba/jjmonsal - 14-06-2016: se recupera el empacador
	SELECT auditor, co_empacador, max(fe_creacion)
	  INTO :ll_codigo, :ll_co_empacador, :ldt_fecha
	  FROM m_auditor_po
	 WHERE cs_orden_corte = :li_ordencorte AND
			 po				 = :ls_po AND
			 co_fabrica_pro = :gstr_info_usuario.co_planta_pro
	GROUP BY 1,2		 ;	
		
	IF IsNull(ll_codigo) Or ll_codigo = 0 THEN
		ROLLBACK;
		MessageBox('Error','LA O.C. '+String(li_ordencorte)+ ' no tiene la validaci$$HEX1$$f300$$ENDHEX$$n del auditor de calidad.')
		Return -1
	END IF
	
	ls_empacador = string(ll_co_empacador)
			
	//se recorren los registros a lotear	
	ll_result = lds_loteo.Retrieve(li_ordencorte,ls_po)	
		
	For ll_fila = 1 To ll_result
		li_fabrica 		= lds_loteo.GetItemNumber(ll_fila,'co_fabrica_ref')
		li_linea 		= lds_loteo.GetItemNumber(ll_fila,'co_linea')
		ll_referencia 	= lds_loteo.GetItemNumber(ll_fila,'co_referencia')
		ll_color 		= lds_loteo.GetItemNumber(ll_fila,'co_color')
		ll_unidades 	= lds_loteo.GetItemNumber(ll_fila,'ca_actual')
			
		SELECT max(cs_loteo)
		INTO: li_max_loteo
		FROM  mv_loteo_auditor
		WHERE mv_loteo_auditor.cs_orden_corte 	= :li_ordencorte  AND  
				mv_loteo_auditor.co_fabrica 		= :li_fabrica  AND  
				mv_loteo_auditor.co_linea 			= :li_linea  AND  
				mv_loteo_auditor.co_referencia 	= :ll_referencia and
				mv_loteo_auditor.co_color        = :ll_color AND
				mv_loteo_auditor.ca_unidades     = :ll_unidades	;
		
		IF isnull(li_max_loteo) THEN li_max_loteo = 0
				
		//insert
		INSERT INTO mv_loteo_auditor  
		( cs_orden_corte,   
		  co_fabrica,   
		  co_linea,   
		  co_referencia,   
		  auditor,   
		  fe_creacion,   
		  fe_actualizacion,   
		  lider,   
		  instancia,   
		  cs_loteo,
		  co_color,
		  ca_unidades,
		  cs_empaca)  
		VALUES ( :li_ordencorte,   
		  :li_fabrica,   
		  :li_linea,   
		  :ll_referencia,   
		  :ll_codigo,   
		  :dt_fe_actualiza,   
		  :dt_fe_actualiza,   
		  :ls_usuario,   
		  :ls_instancia,   
		  :li_max_loteo + 1,
		  :ll_color,
		  :ll_unidades,
		  :ls_empacador)  ;
			
			IF sqlca.sqlcode <> 0 THEN
				ls_error = Sqlca.SqlErrtext
				ROLLBACK;
				MessageBox('Error','No fue posible establecer el auditor de calidad. '+ ls_error)
				Return -1
			END IF
			
	Next
NEXT

Destroy lds_loteo
Destroy lds_oc_po

return 0
end function

public function long of_verificar_unidades_liq (long al_orden_corte);Long	li_rectilineo1, li_rectilineo2, li_existe, ll_result, ll_fila1
Long	li_fabrica, li_linea, ll_result1,ll_fila2, li_raya, li_mensaje
LONG		ll_referencia, ll_unid_liq, ll_unid_liq_ant, ll_color
STRING	ls_po
n_cts_constantes luo_constantes
DataStore lds_po_color_x_oc, lds_po_color_tot_raya

luo_constantes = Create n_cts_constantes

li_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")
IF li_rectilineo1 = -1 THEN
	Return -1
END IF
li_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 2")
IF li_rectilineo2 = -1 THEN
	Return -1
END IF

SELECT COUNT(*)
  INTO :li_existe
  FROM dt_total_ordcr_po
 WHERE cs_orden_corte = :al_orden_corte
   AND tipo in (:li_rectilineo1, :li_rectilineo2);
	
li_mensaje = 0

IF li_existe > 0 THEN  //la orden si tiene rectilineos, se debe verificar

	//*********************creo datastore para recorrer los Po y sus respectivos colores
	lds_po_color_x_oc = Create DataStore
	lds_po_color_x_oc.DataObject = 'ds_po_ref_col_x_orden_corte' //**********recorro los bongos de una O.C. - P.O.
	lds_po_color_x_oc.SetTransObject(sqlca)

	lds_po_color_tot_raya = Create DataStore
	lds_po_color_tot_raya.DataObject = 'ds_po_ref_col_total_x_raya' //**********recorro los bongos de una O.C. - P.O.
	lds_po_color_tot_raya.SetTransObject(sqlca)
	
	ll_result = lds_po_color_x_oc.Retrieve(al_orden_corte)
	FOR ll_fila1 = 1 To lds_po_color_x_oc.RowCount()
		ls_po = lds_po_color_x_oc.GetItemString(ll_fila1,'po')
		li_fabrica = lds_po_color_x_oc.GetItemNumber(ll_fila1,'co_fabrica')
		li_linea = lds_po_color_x_oc.GetItemNumber(ll_fila1,'co_linea')
		ll_referencia = lds_po_color_x_oc.GetItemNumber(ll_fila1,'co_referencia')
		ll_color = lds_po_color_x_oc.GetItemNumber(ll_fila1,'co_color')
		
		ll_result1 = lds_po_color_tot_raya.Retrieve(al_orden_corte,ls_po,li_fabrica,li_linea,ll_referencia,ll_color)
		ll_unid_liq_ant = 0
		FOR ll_fila2 = 1 TO ll_result1
			li_raya = lds_po_color_tot_raya.GetItemNumber(ll_fila2,'raya')
			ll_unid_liq = lds_po_color_tot_raya.GetItemNumber(ll_fila2,'unid_liquida')
			IF (ll_unid_liq <> ll_unid_liq_ant) AND (ll_unid_liq_ant > 0) AND ( li_mensaje = 0) THEN
				MessageBox('Advertencia','El modelo principal tiene diferente las unidades liquidadas a los modelos de rectilineos,&
				                          FAVOR HACER PARTIR LOS RECTILINEOS')
				li_mensaje = 1				
			  Return 1
			END IF
			ll_unid_liq_ant = ll_unid_liq
		NEXT
	NEXT

END IF
return 1


end function

public function long of_validar_oc_loteada (long al_ordencorte, long ai_fab, long ai_lin, long al_ref);//metodo para saber si una orden de corte ya fue loteada.
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM h_canasta_corte h, 
  		 dt_canasta_corte d
 WHERE d.cs_orden_corte = :al_ordencorte AND
 		 d.co_fabrica_ref = :ai_fab AND
		 d.co_linea = :ai_lin AND
		 d.co_referencia = :al_ref AND
		 h.cs_canasta = d.cs_canasta AND
		 h.co_estado > 10;

IF ll_count > 0 THEN
	//la orden de corte ya fue loteada
	Return -1
END IF

Return 0
end function

public function long of_generarconsecutivobongo ();Long ll_consecutivo, ll_incremento
String ls_error, ls_canasta, ls_prefijo, ls_de_tipo
DateTime ldt_fecha
Decimal ldc_nu_aviso
Transaction itr_tela

itr_tela 				= Create Transaction
itr_tela.DBMS			= ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		= ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		= SQLCA.USERID
itr_tela.DBPASS		= SQLCA.DBPASS
itr_tela.DBPARM		= "connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Cursor Stability")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +itr_tela.sqlerrtext,Stopsign!,OK!)
	Return -1
END IF

//se trae el numero de consecutivo
SELECT nu_enque_esta, incremento, nu_aviso, prefijo, de_tipo
  INTO :ll_consecutivo, :ll_incremento, :ldc_nu_aviso, :ls_prefijo, :ls_de_tipo
  FROM cf_consecutivos_ean 
 WHERE tipo = 'BC'
 USING itr_tela;
	
IF itr_tela.sqlcode = -1 THEN
	ls_error = itr_tela.sqlerrtext
	MessageBox("Error Base Datos","Error generando el consecutivo del recipiente, ERROR: "+ls_error)
	DISCONNECT USING itr_tela ;
	RETURN -1
END IF
	
IF ll_consecutivo = 0 OR ISNULL(ll_consecutivo) THEN
	ll_consecutivo = 1
ELSE
	ll_consecutivo = ll_consecutivo + ll_incremento
END IF

//se actualiza el consecutivo
UPDATE cf_consecutivos_ean 
   SET nu_enque_esta	= :ll_consecutivo
 WHERE tipo = 'BC'
 USING itr_tela;	

IF itr_tela.sqlcode = -1 THEN
	ls_error = itr_tela.sqlerrtext
	MessageBox("Error Base Datos","Error actualizando el consecutivo del recipiente, ERROR: "+ls_error)
	DISCONNECT USING itr_tela ;
	RETURN -1
ELSE
	Commit USING itr_tela;
END IF

//************************************************************************************************
//se coloca en comentario ya que se esta compartiendo la forma de generar el consecutivo
//con las personas de Nicole
//jcrm
//marzo 31 de 2009
//	ldt_fecha = f_fecha_servidor()
//	
//	INSERT INTO m_canasta  
//				( co_fabrica,   
//				  co_planta,   
//				  co_canasta,   
//				  co_tipo_canasta,  
//				  co_estado,
//				  fe_creacion,   
//				  fe_actualizacion,   
//				  usuario,   
//				  instancia)  
//	  VALUES ( 2,   
//				  2,   
//				  :ll_cs_canasta,   
//				  1, 
//				  50,
//				  :ldt_fecha,   
//				  :ldt_fecha,   
//				  :gstr_info_usuario.codigo_usuario,   
//				  :gstr_info_usuario.instancia  )  ;
//	IF sqlca.SQLCODE = 0 THEN
//		COMMIT ;
//	ELSE
//		ls_error = sqlca.sqlerrtext
//		ROLLBACK ;
//		MessageBox("Error Base Datos","No se pudo insertar el consecutivo de recipiente, ERROR: " +ls_error)
//		RETURN -1
//	END IF

//************************************************************************************************	
ls_canasta = '22'+String(ll_consecutivo)
ll_consecutivo = Long(ls_canasta)

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +itr_tela.sqlerrtext,Stopsign!,OK!)
   Return -1
END IF

RETURN ll_consecutivo
end function

public function long of_actualizar_unidades_liberadas_op (long al_ordencorte);//metodo para actualizar las unidades liberadas en dt_caxpedidos, esto para que no
//se liberen unidades y cuando lotean sean menos pero que la persona encargada de
//liberar no tenga en el sistema que hacen falta dichas unidades.
//jcrm
//mayo  27 de 2008
Long ll_inicial, ll_actual, ll_diferencia, ll_ordenpd_pt, ll_pedido, ll_ca_liberadas, ll_color
Long li_result, li_fila, li_talla 
String ls_po, ls_error
DataStore lds_loteo

lds_loteo = Create DataStore
lds_loteo.DataObject = 'ds_loteado_vs_liberado'
lds_loteo.SetTransObject(sqlca)

li_result = lds_loteo.Retrieve(al_ordencorte)
For li_fila = 1 TO li_result
	ll_inicial 	= lds_loteo.GetItemNumber(li_fila,'ca_inicial')
	ll_actual 	= lds_loteo.GetItemNumber(li_fila,'ca_actual')
	li_talla		= lds_loteo.GetItemNumber(li_fila,'co_talla')
	ll_color		= lds_loteo.GetItemNumber(li_fila,'co_color')
	ll_pedido	= lds_loteo.GetItemNumber(li_fila,'cs_pedido')
	ls_po       = lds_loteo.GetItemString(li_fila,'po')
	ll_ordenpd_pt = lds_loteo.GetItemNumber(li_fila,'cs_ordenpd')

	IF ll_inicial <> ll_actual THEN
		ll_diferencia = ll_inicial - ll_actual
		
		IF ll_diferencia > 0 THEN 					
			UPDATE dt_caxpedidos
				SET ca_liberadas = ca_liberadas - :ll_diferencia
			 WHERE cs_ordenpd_pt = :ll_ordenpd_pt
				AND nu_orden		= :ls_po
				AND co_talla		= :li_talla
				AND co_color		= :ll_color
				AND pedido        = :ll_pedido;
		ELSE
			ll_diferencia = ll_diferencia * (-1)
			UPDATE dt_caxpedidos
				SET ca_liberadas = ca_liberadas + :ll_diferencia
			 WHERE cs_ordenpd_pt = :ll_ordenpd_pt
			   AND pedido        = :ll_pedido
				AND nu_orden		= :ls_po
				AND co_talla		= :li_talla
				AND co_color		= :ll_color;
		END IF
		IF SQLCA.SQLCODE <> 0 THEN
			ls_error = sqlca.SqlErrText
			ROLLBACK;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades loteadas en la orden de produccion. '+ls_error)
			Return -1
		END IF
		
		SELECT SUM(ca_liberadas) 
		  INTO :ll_ca_liberadas
		  FROM dt_caxpedidos
		 WHERE cs_ordenpd_pt = :ll_ordenpd_pt
		   AND pedido        = :ll_pedido
			AND nu_orden		= :ls_po
			AND co_talla		= :li_talla
			AND co_color		= :ll_color;
		IF SQLCA.SQLCODE <> 0 THEN
			ls_error = sqlca.SqlErrText
			ROLLBACK;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de buscar las unidades loteadas en la orden de produccion. '+ls_error)
			Return -1
		END IF

		IF ll_ca_liberadas < 0 OR (ll_ca_liberadas < ll_actual)  THEN
			UPDATE dt_caxpedidos
			   SET ca_liberadas = :ll_actual
			 WHERE cs_ordenpd_pt = :ll_ordenpd_pt
			   AND pedido        = :ll_pedido
				AND nu_orden		= :ls_po
				AND co_talla		= :li_talla
				AND co_color		= :ll_color;
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.SqlErrText
				ROLLBACK;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar  a Cero para no quedar negativas las unidades loteadas en la orden de produccion. '+ls_error)
				Return -1
			END IF

		END IF

		  
	
	END IF
	
	
NEXT
Return 0
end function

public function long of_act_pdp_corte (long al_oc);//metodo para modificar el estado de la orden de corte en dt_simulacion, esto es para cuando
//loteen una produccion esta no siga apareciendo en el pdp de corte
//jcrm
//diciembre 15 de 2008
String ls_error

UPDATE dt_simulacion
   SET co_estado = 'I'
 WHERE pedido = :al_oc
   AND co_tipo_negocio = 7;
 
 IF SQLCA.SQLCODE <> 0 THEN
	ls_error = sqlca.SqlErrText
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado la simulacion(dt_simulacion). '+ls_error)
	Return -1
 END IF

 Return 0
  	
end function

public function long of_validar_unid_iguales_duo (long al_cs_unir_oc);////La funcion toma el cs_unir_oc y con este busca las ordenes de corte o si es una sola orden busca los colores
////para validar que las unidades entre estas ordenes sean iguales o con diferencia del % permitido, se debe tener
////en cuenta cuando es  la participacion segun el maestro de equivalencias.
Long	li_linea_exp, li_fab_pt, li_linea
STRING	ls_ref_exp,	ls_color_exp
LONG		ll_referencia, ll_orden_corte, ll_color_pt

//
////traemos los datos de ventas y produccion con el consecutivo de duo
//
select unique cs_asignacion,co_linea_exp, co_ref_exp, co_color_exp, co_fabrica_pt, co_linea, co_referencia, co_color_pt
  into :ll_orden_corte, :li_linea_exp, :ls_ref_exp, :ls_color_exp, :li_fab_pt, :li_linea, :ll_referencia, :ll_color_pt
  from dt_pdnxmodulo
 where cs_unir_oc = :al_cs_unir_oc
   and co_estado_asigna <> 28;
//
////luego miramos por cada uno de estos como es el empaque si es por una o dos unidades o mas.
//
//select ca_proyectada de dt_talla_pdnmodulo
//
////luego segun las unidades por las que son el empaque se valida lo que se esta loteando  teniendo en cuenta en % permitido
//
//select sum(ca_loteada) from m_lotes_conf
//
//
return 1
//
//
//
end function

public function long of_validar_unid_lotear_vs_po (long al_orden_corte, string as_po, long ai_fabrica, long ai_linea, long al_referencia, string as_bongo, ref datastore ads_unid_sobrantes_loteo);//funcion para validar las unidades loteadas de una po contra las unidades del pedido
//esto para que cuando son superiores hacer partir el bongo
//Modifiacion: a la cantidad de la po se le suma un % en algunos cliente, esto temporal mientras el pedido llega con 
//esa cantidad de mas
//Modificacion:  Se cambia la cantidad programada a traer desde la op y no desde el pedido, esto los solicita 
//jhonny martinez en correo 27/01/2011 realiza jorodrig con esto ya no es necesario hacer la adicion por cliente
//se cambia para que se toma la cantidad pedida a comprar desde el pedido 25/11/14

Long	li_result, li_fila, li_result2, li_fila2, li_talla, li_result3, li_bongos, li_fila3, li_fabrica, li_result4, li_row, li_interto, li_porc_mas_pedido
Long		ll_op_estilo, ll_pedido, ll_unid_pedido, ll_unid_loteo, ll_unid_loteando, ll_diferencia, ll_cliente, li_co_linea, &
			ll_co_referencia, ll_color_pt, ll_ca_pedida, ll_ca_pedida_comprar, ll_tipo,ll_ca_tejido, ll_unid_toleracion
String	 ls_de_estilo
DataStore lds_op_estilo_color_x_oc, lds_unid_pedido_x_ped_estilo,lds_unid_loteadas_por_po_ref, lds_cantidad_loteando_bongo
n_cts_constantes_corte lpo_const_corte


ll_unid_toleracion = lpo_const_corte.of_consultar_numerico('DIFERENCIA_LOTEO_ENCIMA')  
If ll_unid_toleracion < 0 Then
	Return -1
End If


lds_op_estilo_color_x_oc = Create DataStore  //para cargar la op y el color con la oc y po
lds_op_estilo_color_x_oc.DataObject = 'ds_op_estilo_color_x_oc'
lds_op_estilo_color_x_oc.SetTransObject(sqlca)

lds_unid_pedido_x_ped_estilo = Create DataStore  //para cargar las unidades del pedido
lds_unid_pedido_x_ped_estilo.DataObject = 'ds_unid_pedido_x_ped_estilo'
lds_unid_pedido_x_ped_estilo.SetTransObject(sqlca)

lds_unid_loteadas_por_po_ref = Create DataStore  //para traer las unidades loteadas por po estilo -talla
lds_unid_loteadas_por_po_ref.DataObject = 'ds_unid_loteadas_por_po_ref'
lds_unid_loteadas_por_po_ref.SetTransObject(sqlca)

lds_cantidad_loteando_bongo = Create DataStore  //para traer las unidades loteadas por po estilo -talla
lds_cantidad_loteando_bongo.DataObject = 'ds_cantidad_loteando_bongo'
lds_cantidad_loteando_bongo.SetTransObject(sqlca)

/* FACL - 2021/09/23 - ID530 - Se desactiva funcionalida porque tipo = 2 ya es una OC normal
//verifica si la orden de corte es MUESTRA VENDEDOR - LOTE PILOTO, tipo = 2 
ll_tipo = of_tipo_orden_corte(al_orden_corte)
//si es para muestras
If ll_tipo = 2 Then
	Destroy lds_op_estilo_color_x_oc
	Destroy lds_unid_pedido_x_ped_estilo
	Destroy lds_unid_loteadas_por_po_ref
	Destroy lds_cantidad_loteando_bongo
	Return 0
Elseif ll_tipo < 0 Then
	Destroy lds_op_estilo_color_x_oc
	Destroy lds_unid_pedido_x_ped_estilo
	Destroy lds_unid_loteadas_por_po_ref
	Destroy lds_cantidad_loteando_bongo
	MessageBox('Advertencia','No se encontro tipo de la orden de corte para validar las unidades')
	Return -1
End if
*/

li_interto = 0
//traemos la orden de produccion y el color
li_result = lds_op_estilo_color_x_oc.Retrieve(al_orden_corte,as_po,ai_fabrica,ai_linea,al_referencia)
IF li_result <=0 THEN
	MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$la orden de produccion y po para validar las unidades')
	return -1
END IF
FOR li_fila = 1 TO li_result
	ll_op_estilo = lds_op_estilo_color_x_oc.GetitemNumber(li_fila,'cs_ordenpd_pt')
	ll_color_pt  = lds_op_estilo_color_x_oc.GetitemNumber(li_fila,'co_color_pt')
	ll_pedido	 = lds_op_estilo_color_x_oc.GetitemNumber(li_fila,'pedido')
	ls_de_estilo = lds_op_estilo_color_x_oc.GetitemString(li_fila,'de_referencia')
	li_fabrica = lds_op_estilo_color_x_oc.GetitemNumber(li_fila,'co_fabrica_pt')
	li_co_linea = lds_op_estilo_color_x_oc.GetitemNumber(li_fila,'co_linea')
	ll_co_referencia = lds_op_estilo_color_x_oc.GetitemNumber(li_fila,'co_referencia')
	
	
	//traemos las unidades de la po por talla color
	li_result2 = lds_unid_pedido_x_ped_estilo.Retrieve(ll_pedido,li_fabrica,li_co_linea,ll_co_referencia,ll_color_pt)
	IF li_result2 <=0 THEN
		MessageBox('Advertencia','No se encontraron las unidades de la po' )
		return -1
	END IF
	FOR li_fila2 = 1 TO li_result2
		li_talla 		= lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'co_talla')
		//ll_unid_pedido = lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'ca_pedida')
		//ll_unid_pedido = lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'ca_ped_op')
		
		ll_ca_pedida = lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'ca_pedida')
		ll_ca_pedida_comprar = lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'ca_pedida_comprar')
		ll_ca_tejido = lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'ca_tejido')
		//mira la cantidad mayor
		If ll_ca_pedida < ll_ca_pedida_comprar Then
			ll_unid_pedido = ll_ca_pedida_comprar
		Else
			ll_unid_pedido = ll_ca_pedida
		End if
		//mira si la cantidad es mas peque$$HEX1$$f100$$ENDHEX$$a que ca_tejido
		If ll_unid_pedido < ll_ca_tejido Then
			ll_unid_pedido = ll_ca_tejido
		End if
		
		ll_cliente     = lds_unid_pedido_x_ped_estilo.GetitemNumber(li_fila2,'co_cliente_exp')


//Solicitan en reunion junio 4 2012 que jockey se trabaje con un 2% mas otras necesidades que se solicitan por intranet, 
//participan en reunion JAvier, Ubeimar, Hugo, Jhonny, Edwin, Maria Fda, Oswaldo.
		IF ll_cliente = 9991 THEN  //cliente jockey
			li_porc_mas_pedido = lpo_const_corte.of_consultar_numerico('PORC_MAS_PEDIDO')  
			ll_unid_pedido =  ll_unid_pedido + (ll_unid_pedido * li_porc_mas_pedido)/100
		END IF


				//***************genero ciclo para recorrer todos los bongos de la orden de corte para la po actual
		li_result4 = lds_cantidad_loteando_bongo.Retrieve(al_orden_corte,li_fabrica,li_co_linea,ll_co_referencia,ll_color_pt,li_talla,ll_pedido)
		IF li_result4 <0 THEN
			MessageBox('Advertencia','No se encontro el total de unidades que esta loteando en este bongo' )
			return -1
		END IF
		IF li_result4 > 0 THEN
			ll_unid_loteando = lds_cantidad_loteando_bongo.GetitemNumber(1,'ca_loteando')
		ELSE
			ll_unid_loteando = 0   //estas no se suman porque este proceso se realiza despues de lotear
		END IF
	
		IF ll_unid_loteando = 0 THEN  //si en la oc que esta loteando no esta esa talla no se saca mensaje
			CONTINUE
		END IF
		
		//traemos las unidades loteadas de la po, color, talla para comparar
		li_result3 = lds_unid_loteadas_por_po_ref.Retrieve(li_fabrica,li_co_linea,ll_co_referencia,ll_color_pt,li_talla,ll_op_estilo,as_po)
		IF li_result3 <0 THEN
			MessageBox('Advertencia','No se encontro el total de unidades loteadas de la PO' )
			return -1
		END IF
		IF li_result3 > 0 THEN
			ll_unid_loteo = lds_unid_loteadas_por_po_ref.GetItemNumber(1,'ca_loteada')
		Else
			ll_unid_loteo = 0 //sino han loteado
		End if
		// FACL - 2021/09/28 - ID530 - Se agrega manejo de constante de tolerancia para sobrantes
		IF (ll_unid_loteo + ll_unid_loteando) - ll_unid_toleracion > ll_unid_pedido THEN   //comparamos las unidades
			//esta loteando mas de lo que se puede. debe partir el bongo se carga a tabla temporal 
			ll_diferencia = (ll_unid_loteo + ll_unid_loteando) - ll_unid_pedido
			// stvalenc 2020-01-06 soporte - Ajuste en el loteo
			IF ll_diferencia > ll_unid_loteando then
				ll_diferencia = ll_unid_loteando
			END IF
			li_row = ads_unid_sobrantes_loteo.InsertRow(0)
			IF li_row > 0 THEN
				ads_unid_sobrantes_loteo.SetItem(li_row,'bongo',as_bongo )
				ads_unid_sobrantes_loteo.SetItem(li_row,'orden_corte',al_orden_corte )
				ads_unid_sobrantes_loteo.SetItem(li_row,'fabrica',li_fabrica )					
				ads_unid_sobrantes_loteo.SetItem(li_row,'linea',li_co_linea )
				ads_unid_sobrantes_loteo.SetItem(li_row,'estilo',ll_co_referencia)
				ads_unid_sobrantes_loteo.SetItem(li_row,'de_estilo',ls_de_estilo)
				ads_unid_sobrantes_loteo.SetItem(li_row,'color',ll_color_pt )
				ads_unid_sobrantes_loteo.SetItem(li_row,'talla',li_talla )
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_loteando',ll_unid_loteando )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_pedido',ll_unid_pedido )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_sobrantes',ll_diferencia )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_loteadas',ll_unid_loteo )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'op_estilo',ll_op_estilo )		
				ads_unid_sobrantes_loteo.Accepttext()
				li_interto = 1
			END IF
		END IF

	NEXT
NEXT

Destroy lds_op_estilo_color_x_oc
Destroy lds_unid_pedido_x_ped_estilo
Destroy lds_unid_loteadas_por_po_ref
Destroy lds_cantidad_loteando_bongo
	
IF li_interto = 1 THEN  //inserto datos en el ds, se retorna 1 para abrir ventana mostrando a usuario lo sobrante
	Return 1
ELSE
	Return 0
END IF



end function

public function long of_actualiza_pdp_confeccion (string as_bongo);
/*
Funcion para actualizar pdp de confeccion con el bongo loteado
El sistema verifica en el PDP de confecci$$HEX1$$f300$$ENDHEX$$n si existen unidades reservadas del  pedido seleccionado.
Si no existen unidades reservadas del pedido seleccionado; el sistema busca con los datos del pedido la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual,  inserta una barra en el PDP de confecci$$HEX1$$f300$$ENDHEX$$n a la barra m$$HEX1$$e100$$ENDHEX$$s cercana a la fecha actual  con los datos del pedido seleccionado
Si no existe barras, el sistema debe buscar la referencia de venta en  la f$$HEX1$$e100$$ENDHEX$$brica planta del portafolio; y en esta f$$HEX1$$e100$$ENDHEX$$brica planta busca la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada o reservada a la fecha actual; e insertar la barra nueva con la informaci$$HEX1$$f300$$ENDHEX$$n del pedido seleccionado
Si la cantidad de la barra reservada es igual a la cantidad del pedido seleccionado; el sistema inserta la cantidad del pedido seleccionado en la posici$$HEX1$$f300$$ENDHEX$$n de la barra reservada. 
Si la cantidad de la barra reservada encontrada es mayor a la cantidad del pedido seleccionado; el sistema inserta los datos en esta barra del PDP de confecci$$HEX1$$f300$$ENDHEX$$n dejando la barra con la cantidad del pedido seleccionado y  detr$$HEX1$$e100$$ENDHEX$$s la barra con la cantidad sobrante de la barra reservada.
Si la cantidad de la barra reservada encontrada es menor a la cantidad del pedido seleccionado; el sistema debe buscar una siguiente barra reservada m$$HEX1$$e100$$ENDHEX$$s cercana a la fecha actual. El sistema debe verificar la cantidad que necesita para cumplir con la cantidad del pedido seleccionado; partir esta barra reservada con la cantidad que se necesita para cumplir con la cantidad del pedido seleccionado, y unirla a la barra anterior. 
Si la cantidad de la barra resultante de la uni$$HEX1$$f300$$ENDHEX$$n de estas barras es menor que la cantidad del pedido seleccionado, se continua uniendo barras, hasta que la cantidad sea igual a la cantidad del pedido seleccionado; 
Si la cantidad de la barra reservada encontrada, es menor a la cantidad del pedido seleccionado; y no existen m$$HEX1$$e100$$ENDHEX$$s barras reservadas, esta se debe ampliar a la cantidad del pedido seleccionado.
*/

Long ll_reg, ll_n, ll_m,ll_pedido, ll_nulo,ll_modulos[], ll_cantidad, ll_cant_restante, ll_cantbarra1, ll_cantbarra2, ll_retorno, ll_reg_caja 
String ls_referencia, ls_expresion,ls_error, ls_usuario, ls_bongo_agrupador, ls_expresion_modulo_2
Boolean lb_barra_reservada, lb_sw_fecha_act, lb_pedido_agrupado, lb_bongo_agrupador = False
Datetime ldt_fecha
uo_dsbase lds_bongo, lds_barras, lds_modulos_cambio, lds_cajas, lds_barras_portafolio, lds_bongo_sin_pdp
s_parametros_calendario lstr_parametros
uo_dsbase lds_pedido_agrupa
long ll_n_pedido_agrupa, ll_n_bongo_agrupa, ll_pedido_agrupa, ll_tipo_agrupa, ll_orden_corte_agrupa
long ll_co_fabrica, ll_co_linea, ll_co_referencia, ll_co_talla, ll_co_color
n_utilidades_simulacion lnvo_simulacion
uo_dsbase lds_agrupacion_pedido, lds_barras_bongo_agrupado

ll_retorno = 1
SetNull(ll_nulo)

ls_usuario = gstr_info_usuario.codigo_usuario

lds_bongo = Create uo_dsbase
lds_bongo.DataObject = 'd_gr_pedido_ref_x_bongo'
lds_bongo.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

ldt_fecha = f_fecha_servidor()
lnvo_simulacion.ib_hacer_commit = False
lstr_parametros.Hay_parametros = True

//trae el pedido-referencia del bongo
ll_reg = lds_bongo.of_retrieve(as_bongo) 

//si encuentra datos
If ll_reg > 0 Then
	 lb_pedido_agrupado = False
	 lb_bongo_agrupador = False
	
	lds_barras = Create uo_dsbase
	lds_barras.DataObject = 'd_gr_barras_pdp_conf_x_pedido_ref'
	lds_barras.SetTransObject(SQLCA)
	
	lds_cajas = Create uo_dsbase
	lds_cajas.DataObject = 'd_gr_cajas_pdp_confeccion'
	lds_cajas.SetTransObject(SQLCA)


	lds_modulos_cambio = Create uo_dsbase
	lds_modulos_cambio.DataObject = 'd_ff_parametros_subcentro_modulo'
	lds_modulos_cambio.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

	//recorre el pedido-referencia del bongo
	For ll_reg = 1 to lds_bongo.RowCount()
		
		//toma el dato del pedido y referencia
		ll_pedido = lds_bongo.GetItemNumber(ll_reg,'pedido')
		ls_referencia = left( String(lds_bongo.GetItemNumber(ll_reg,'co_fabrica_ref'))+'     ' , 5) + &
							 left( String(lds_bongo.GetItemNumber(ll_reg,'co_linea'))+'     ' , 5) + &
							 left( String(lds_bongo.GetItemNumber(ll_reg,'co_referencia'))+fill(' ',20), 20) 
	
							 
		ll_cantidad = lds_bongo.GetItemDecimal(ll_reg,'ca_actual')
		//mira si hay datos en el pdp para el pedido-referencia
		ll_n = lds_barras.of_retrieve(ll_pedido, ls_referencia)
		// si encontro barras, miramos si tiene barra reservada, si no es asi buscamos si por pedido agrupado
		//encuentra barra reservada
		if ll_n > 0 then
			lds_barras.SetFilter("ca_programada - ca_asignada > 0 and sw_asignada = 0")
			lds_barras.Filter()			
			//buscamos si existen barras reservadas
			If lds_barras.RowCount() > 0 Then
				// si existen barras reservadas desasemos el filtro, y dejamos que continue el flujo normal
				lds_barras.SetFilter("")
				lds_barras.Filter()
			else
				// si no ecuntra barra reservada buscamos cambiamos la variable para que entra a buscar por pedido agrupado
				ll_n = 0
			end if
		end if
		// stvalenc  2021-11-22 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
		// si no encuentra datos con el pedido y referencia en el pdp, buscamos si existe con pedido agrupado
		if ll_n = 0 then
			//ds usado para consultar el pedido agrupado con la orden de corte de la canasta actual
			lds_pedido_agrupa = Create uo_dsbase
			lds_pedido_agrupa.DataObject = 'd_gr_pedido_agrupado_x_orden_corte'
			lds_pedido_agrupa.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
			//validamos que se obtengan registros
			ll_orden_corte_agrupa = lds_bongo.GetItemNumber(ll_reg,'cs_orden_corte')
			ll_n_pedido_agrupa = lds_pedido_agrupa.Retrieve(ll_orden_corte_agrupa)
			if ll_n_pedido_agrupa < 0 then
				rollback;
				Destroy lds_bongo
				Destroy lds_barras
				Destroy lds_modulos_cambio
				Destroy lds_cajas
				Destroy lds_barras_portafolio
				Destroy lds_agrupacion_pedido
				Destroy lds_pedido_agrupa
				MessageBox("Error","ocurrio un error al consultar el pedido individual")
				ll_retorno = -1
				exit
			else
				//obtenemos el pedido agrupado
				ll_pedido_agrupa = lds_pedido_agrupa.getItemNumber(1,"pedido_agrupa")
				//consultamos si con el pedido agrupado existen datos en el pdp
				// validamos primero que el pedido agrupado exista y no sea nulo
				if isnull(ll_pedido_agrupa) or ll_n_pedido_agrupa = 0 then
					// si no encontro barras con pedido liberado individual, buscamos con el pedido agrupado
					lds_agrupacion_pedido = Create uo_dsbase
					lds_agrupacion_pedido.DataObject = 'd_gr_agrupacion_pedido_x_pedido'
			   	 	lds_agrupacion_pedido.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
					//obtenemos variables para consultar el pedido agrupado
					ll_co_fabrica= lds_bongo.GetItemNumber(ll_reg,'co_fabrica_ref')
					ll_co_linea= lds_bongo.GetItemNumber(ll_reg,'co_linea')
					ll_co_referencia= lds_bongo.GetItemNumber(ll_reg,'co_referencia')
					ll_n_pedido_agrupa =  lds_agrupacion_pedido.Retrieve(ll_pedido,ll_co_fabrica, ll_co_linea, ll_co_referencia)
					if ll_n_pedido_agrupa < 0 then
						rollback;
						Destroy lds_bongo
						Destroy lds_barras
						Destroy lds_modulos_cambio
						Destroy lds_cajas
						Destroy lds_barras_portafolio
						Destroy lds_agrupacion_pedido
						Destroy lds_pedido_agrupa
						MessageBox("Error","ocurrio un error al consultar el pedido agrupadol")
						ll_retorno = -1
						exit
					else
						if ll_n_pedido_agrupa = 0 then
							ll_n = 0
						else
							ll_pedido_agrupa = lds_agrupacion_pedido.getItemNumber(1,"pedido_agrupa")
							ll_tipo_agrupa = lds_agrupacion_pedido.getItemNumber(1,"tipo_agrupacion")
							// si el tipo de agrupacion es menor a 3, debe retomar el pedido individual, no el pedido agrupado
							If ll_tipo_agrupa < 3 then
								ll_pedido_agrupa = ll_pedido
							end if
						end if
					end if 
				end if //isnull(ll_pedido_agrupa) then
				//buscamos las barras con el pedido agrupado, o por pedido, si no encontro pedido agrupado
				lds_barras.SetFilter("")
				lds_barras.Filter()
				if ll_pedido_agrupa > 0 then
					ll_n = lds_barras.of_retrieve(ll_pedido_agrupa,ls_referencia)
					if ll_n > 0 then
						lb_pedido_agrupado = True
					elseif ll_n = 0 then
						ll_n = lds_barras.of_retrieve(ll_pedido, ls_referencia)
					end if
				else
					ll_n = lds_barras.of_retrieve(ll_pedido, ls_referencia)
				end if
				//asignamos el valor del pedido agrupado a ll_pedido para continuar con el proceso 
				//si encontramos barras con el pedido agrupado
			end if
		end if
		//stvlenc 2021-12-06 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
		//verificamos si el bongo pertenece a un bongo agrupador.
		//para que la barra nueva quede despues de la ultima del bongo abrupador
		ls_bongo_agrupador =  lds_bongo.GetItemString(ll_reg,'bongo_agrupador')
		if ls_bongo_agrupador <> '' then
			lds_barras_bongo_agrupado = Create uo_dsbase
			lds_barras_bongo_agrupado.DataObject = 'd_gr_barra_x_bongo_agrupador'
			lds_barras_bongo_agrupado.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
			ll_n_bongo_agrupa = lds_barras_bongo_agrupado.retrieve(lds_bongo.GetItemString(ll_reg,'bongo_agrupador'))
			if ll_n_bongo_agrupa < 0 then
				Destroy lds_bongo
				Destroy lds_barras
				Destroy lds_modulos_cambio
				Destroy lds_cajas
				Destroy lds_barras_bongo_agrupado
				//expresion para el envio de correo
				ls_expresion = 'No se encontro informaci$$HEX1$$f300$$ENDHEX$$n del bongo agrupador ' + trim(as_bongo) + ' en el Pdp Confeccion.'
				ll_retorno = -1
				Exit
			end if
			if ll_n_bongo_agrupa = 0 then
				// si no hay un bongo agrupado como barra en el pdp
				// y seguimos la ejecucion normal
				lb_bongo_agrupador = False
			elseif ll_n_bongo_agrupa > 0 then
				//si encuentra barras de bongo agrupador en el PDP
				//si encotnro barras ordenamos para encontrar la ultima barra programada
				lds_barras_bongo_agrupado.SetSort('fe_final_progs Desc')
				lds_barras_bongo_agrupado.Sort()
				//Cambiamos la variable para indicar que se encontro una barra con bongo agrupador
				lb_bongo_agrupador = True
			else
				//Si no encuentra barras programadas en el pdp con el bongo agrupador limpiamos la bandera
				lb_bongo_agrupador = False
			end if
		else 
			// si no es bongo agrupador dejamos la bandera en false para indicarlo
			lb_bongo_agrupador = False
		end if
				
		//si no encontro datos ni con pedido, ni pedido agrupado, crea la barra con el pedido indivual con la informacion de d_gr_pdp_conf_x_bongo_portafolio
		If ll_n = 0 Then
						
			//busca barra para la referencia que tiene el bongo en la planta que indica el portafolio
			lds_barras_portafolio = Create uo_dsbase
			lds_barras_portafolio.DataObject = 'd_gr_pdp_conf_x_bongo_portafolio'
			lds_barras_portafolio.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
			
			ll_n = lds_barras_portafolio.Of_Retrieve(as_bongo) 
			
			If ll_n > 0 Then
				//busca la barra mas proxima a la fecha actual para insertar la barra nueva
				lds_barras_portafolio.SetFilter('fe_final_progs > ' + String(Date(ldt_fecha), 'yyyy-mm-dd'))
				lds_barras_portafolio.Filter( ) 
				//si hay barras se toma la mas cercana a la fecha actual
				If lds_barras_portafolio.RowCount() > 0 Then
					//se ordena para mirar cual es la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual
					lds_barras_portafolio.SetSort('fe_final_progs Asc')
					lds_barras_portafolio.Sort()
					lb_sw_fecha_act = True
				Else
					lds_barras_portafolio.SetFilter('')
					lds_barras_portafolio.Filter( ) 
					//se ordena para mirar cual es la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual
					lds_barras_portafolio.SetSort('fe_final_progs Desc')
					lds_barras_portafolio.Sort()
					lb_sw_fecha_act = False
				End if
			ElseIf ll_n = 0 Then
				//busca barra para la referencia venta que tiene el bongo en la planta que indica el portafolio, no se tiene en cuenta la ref produccion
				lds_barras_portafolio.DataObject = 'd_gr_pdp_conf_x_bongo_portafolio_ref_vta'
				lds_barras_portafolio.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
			
				ll_n = lds_barras_portafolio.Of_Retrieve(as_bongo) 
			
				If ll_n > 0 Then
					//busca la barra mas proxima a la fecha actual para insertar la barra nueva
					lds_barras_portafolio.SetFilter('fe_final_progs > ' + String(Date(ldt_fecha), 'yyyy-mm-dd'))
					lds_barras_portafolio.Filter( ) 
					//si hay barras se toma la mas cercana a la fecha actual
					If lds_barras_portafolio.RowCount() > 0 Then
						//se ordena para mirar cual es la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual
						lds_barras_portafolio.SetSort('fe_final_progs Asc')
						lds_barras_portafolio.Sort()
						lb_sw_fecha_act = True
					Else
						lds_barras_portafolio.SetFilter('')
						lds_barras_portafolio.Filter( ) 
						//se ordena para mirar cual es la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual
						lds_barras_portafolio.SetSort('fe_final_progs Desc')
						lds_barras_portafolio.Sort()
						lb_sw_fecha_act = False
					End if
				ElseIf ll_n = 0 Then
					Destroy lds_barras_portafolio
					Rollback;
					//si debe mostrar mensaje
					If ib_mostrar_mensaje Then
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' en el Pdp Confeccion.' )
					Else
						//se copia el mensaje del error
						is_mensaje = 'No se encontro informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' en el Pdp Confeccion.' 
					End if
					Destroy lds_bongo
					Destroy lds_barras
					Destroy lds_modulos_cambio
					Destroy lds_cajas
					Destroy lds_barras_portafolio
					//expresion para el envio de correo
					ls_expresion = 'No se encontro informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' en el Pdp Confeccion.'
					ll_retorno = -1
					Exit
				Else
					Rollback;
					//si debe mostrar mensaje
					If ib_mostrar_mensaje Then
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' para la referencia en el Pdp Confeccion.' )
					Else
						//se copia el mensaje del error
						is_mensaje = 'Ocurrio un inconveniente al consultar informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' para la referencia en el Pdp Confeccion.' 
					End if
					
					Destroy lds_bongo
					Destroy lds_barras
					Destroy lds_modulos_cambio
					Destroy lds_cajas
					Destroy lds_barras_portafolio
					//expresion para el envio de correo
					ls_expresion = 'Ocurrio un inconveniente al consultar informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' para la referencia en el Pdp Confeccion.'
					ll_retorno = -1
					Exit
				End if
			
			Else
				Rollback;
				//si debe mostrar mensaje
				If ib_mostrar_mensaje Then
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' para la referencia en el Pdp Confeccion.' )
				Else
					//se copia el mensaje del error
					is_mensaje = 'Ocurrio un inconveniente al consultar informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' para la referencia en el Pdp Confeccion.'
				End if
				
				Destroy lds_bongo
				Destroy lds_barras
				Destroy lds_modulos_cambio
				Destroy lds_cajas
				Destroy lds_barras_portafolio
				//expresion para el envio de correo
				ls_expresion = 'Ocurrio un inconveniente al consultar informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' para la referencia en el Pdp Confeccion.'
				ll_retorno = -2
				Exit
			End if
			
			lb_barra_reservada = False
			//se quita el filtro
			lds_barras.SetFilter("")
			lds_barras.Filter()
		
			ll_n = lds_barras.RowCount()
			
			//se inserta barra nueva
			lds_barras_portafolio.RowsCopy(1, 1, Primary!, lds_barras, ll_n + 1, Primary!)
			
			ll_n = ll_n + 1
			//se coloca las unidades igual a la cantidad del bongo
			lds_barras.SetItem(ll_n,'ca_programada',ll_cantidad)
			/*lds_barras.SetItem(ll_n,'ca_asignada',ll_cantidad)*/
			lds_barras.SetItem(ll_n,'ca_asignada',0)
			lds_barras.SetItem(ll_n,'ca_producida',0)
			If lb_sw_fecha_act = True Then
				//coloca la barra despues de la barra encontrada
				lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_final_progs')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_final_progs')), 1 ) ))
				lds_barras.SetItem(ll_n,'fe_final_progs',datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_final_progs')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_final_progs')), 2 ) ))
			Else
				lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( ldt_fecha),RelativeTime ( Time(ldt_fecha), 1 ) ))
				lds_barras.SetItem(ll_n,'fe_final_progs',datetime(Date(ldt_fecha),RelativeTime ( Time(ldt_fecha), 2 ) ))
			End if
			// stvalenc se deja el pedido encontrado como individual
			//stvalenc 2021-11-30 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
			if lb_pedido_agrupado then
				lds_barras.SetItem(ll_n,'pedido',ll_pedido_agrupa)
			else
				// IN656303 -- Se corrige error en pdp, bongos con pedido erroneo
				// que se cargaba desde el portafolio
				lds_barras.SetItem(ll_n,'pedido',ll_pedido)
		    end if
			lds_barras.SetItem(ll_n,'co_referencia',ls_referencia)
			lds_barras.SetItem(ll_n,'secuencia',ll_nulo)
			lds_barras.SetItem(ll_n,'fe_creacion',ldt_fecha)
			lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
			lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
			lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
			
			
			//se guarda el modulo para actualizar la produccion
			ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
								'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
								'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
								'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
								'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
								
			If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
				ll_m = lds_modulos_cambio.InsertRow(0)
				lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
				lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
				lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
				lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
				lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
			End if
			
			//inserta en la tabla que indica que la caja se ingreso a Pdp
			ll_reg_caja = lds_cajas.InsertRow(0)
			lds_cajas.SetItem(ll_reg_caja,'pallet_id', as_bongo)
			//stvalenc 2021-11-30 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
			if lb_pedido_agrupado then
				lds_cajas.SetItem(ll_reg_caja,'pedido',ll_pedido)
			else
				lds_cajas.SetItem(ll_reg_caja,'pedido', lds_barras.GetItemNumber(ll_n,'pedido'))
		    end if
			lds_cajas.SetItem(ll_reg_caja,'co_fabrica_sim', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
			lds_cajas.SetItem(ll_reg_caja,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
			lds_cajas.SetItem(ll_reg_caja,'co_centro_pdn', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
			lds_cajas.SetItem(ll_reg_caja,'co_subcentro_pdn', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
			lds_cajas.SetItem(ll_reg_caja,'co_tipo_negocio', lds_barras.GetItemNumber(ll_n,'co_tipo_negocio'))
			lds_cajas.SetItem(ll_reg_caja,'co_maquina', lds_barras.GetItemNumber(ll_n,'co_maquina'))
			lds_cajas.SetItem(ll_reg_caja,'simulacion', lds_barras.GetItemNumber(ll_n,'simulacion'))
			lds_cajas.SetItem(ll_reg_caja,'co_referencia', lds_barras.GetItemString(ll_n,'co_referencia'))
			lds_cajas.SetItem(ll_reg_caja,'ca_programada', lds_barras.GetItemDecimal(ll_n,'ca_programada'))
				
			Destroy lds_barras_portafolio
			
		//si encontro datos
		ElseIf ll_n > 0 Then
			
			//se busca la barra reservada (que no este asignada)
			lds_barras.SetFilter("ca_programada - ca_asignada > 0 and sw_asignada = 0")
			lds_barras.Filter()
			
			//si hay barras reservadas
			If lds_barras.RowCount() > 0 Then
				
				lb_barra_reservada = True
				//se ordena para mirar cual es la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual
				lds_barras.SetSort('fe_final_progs Asc')
				lds_barras.Sort()
				
				//busca si hay una barra con la misma cantidad del pedido-referencia
				ls_expresion = "ca_programada - ca_asignada = " + String(ll_cantidad)
				ll_n = lds_barras.Find(ls_expresion,1,lds_barras.RowCount()+1)
				//encuentra la barra
				If ll_n > 0 Then
					/*lds_barras.SetItem(ll_n,'ca_asignada', lds_barras.getItemDecimal(ll_n,'ca_asignada') + ll_cantidad)*/
					lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
					lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
					lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
					//si era un pedido agrupado conservamos el pedido individual
					if lb_bongo_agrupador then
						// stvalenc antes de realizar el cambio de en los campos al nuevo modulo
						//verificamos que se ingresara el modulo donde se encontro la barra reservada para recalcular este modulo
						ls_expresion_modulo_2 = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
															'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
															'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
															'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
															'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
						If lds_modulos_cambio.Find(ls_expresion_modulo_2 ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
							ll_m = lds_modulos_cambio.InsertRow(0)
							lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
							lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
							lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
							lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
							lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
						End if
						//Si es bongo agrupador, y se encontro barra en el pdp, se debe agruegar la barra al final de la encontrada con bongo agrupador
						lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 1 ) ))
						lds_barras.SetItem(ll_n,'fe_final_progs',datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 2 ) ))	
						lds_barras.SetItem(ll_n,'co_maquina', lds_barras_bongo_agrupado.GetItemNumber(1,'co_maquina'))
						lds_barras.SetItem(ll_n,'co_fabrica_sim',lds_barras_bongo_agrupado.GetItemNumber(1,'co_fabrica_sim'))
						lds_barras.SetItem(ll_n,'co_planta',lds_barras_bongo_agrupado.GetItemNumber(1,'co_planta'))
						lds_barras.SetItem(ll_n,'co_centro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_centro_pdn'))
						lds_barras.SetItem(ll_n,'co_subcentro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_subcentro_pdn'))
						lds_barras.SetItem(ll_n,'tiempo_estandar', lds_barras_bongo_agrupado.GetItemDecimal(1,'tiempo_estandar'))
						lds_barras.SetItem(ll_n,'co_recurso', lds_barras_bongo_agrupado.GetItemNumber(1,'co_recurso'))
						lds_barras.SetItem(ll_n,'ca_programada',ll_cantidad)
						lds_barras.SetItem(ll_n,'ca_asignada',ll_cantidad)
						lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
					end if
					if lb_pedido_agrupado then
						lds_barras.SetItem(ll_n,'pedido',ll_pedido)
					end if
					
					//se guarda el modulo para actualizar la produccion
					ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
										'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
										'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
										'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
										'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
										
					If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
						ll_m = lds_modulos_cambio.InsertRow(0)
						lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
						lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
						lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
						lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
						lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
					End if
					
					//inserta en la tabla que indica que la caja se ingreso a Pdp
					ll_reg_caja = lds_cajas.InsertRow(0)
					if lb_bongo_agrupador then
						//se inserta la secuencia al final de del update de lds_barras, para obtener el nuevo valor
					else
						lds_cajas.SetItem(ll_reg_caja,'secuencia_pdp', lds_barras.GetItemNumber(ll_n,'secuencia'))
					end if
					lds_cajas.SetItem(ll_reg_caja,'secuencia_pdp', lds_barras.GetItemNumber(ll_n,'secuencia'))
					lds_cajas.SetItem(ll_reg_caja,'pallet_id', as_bongo)
					//stvalenc se conserva el pedido individual
					if lb_pedido_agrupado then
						lds_cajas.SetItem(ll_reg_caja,'pedido',ll_pedido)
					else
						lds_cajas.SetItem(ll_reg_caja,'pedido', lds_barras.GetItemNumber(ll_n,'pedido'))
		   			 end if
					lds_cajas.SetItem(ll_reg_caja,'co_fabrica_sim', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
					lds_cajas.SetItem(ll_reg_caja,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
					lds_cajas.SetItem(ll_reg_caja,'co_centro_pdn', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
					lds_cajas.SetItem(ll_reg_caja,'co_subcentro_pdn', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
					lds_cajas.SetItem(ll_reg_caja,'co_tipo_negocio', lds_barras.GetItemNumber(ll_n,'co_tipo_negocio'))
					lds_cajas.SetItem(ll_reg_caja,'co_maquina', lds_barras.GetItemNumber(ll_n,'co_maquina'))
					lds_cajas.SetItem(ll_reg_caja,'simulacion', lds_barras.GetItemNumber(ll_n,'simulacion'))
					lds_cajas.SetItem(ll_reg_caja,'co_referencia', lds_barras.GetItemString(ll_n,'co_referencia'))
					lds_cajas.SetItem(ll_reg_caja,'ca_programada', lds_barras.GetItemDecimal(ll_n,'ca_programada'))
					
				//no encuentra la barra ca_programada - ca_asignada = cantidad
				ElseIf ll_n = 0 Then
					
					//busca si hay una barra con la cantidad mayor a la del pedido-referencia
					ls_expresion = "ca_programada - ca_asignada > " + String(ll_cantidad)
					ll_n = lds_barras.Find(ls_expresion,1,lds_barras.RowCount()+1)
					//encuentra la barra
					If ll_n > 0 Then
						//halla la cantidad restante que debe tener la barra que se parte
						//stvalenc si era un pedido individual de un pedido agrupado
						//stvalenc 2021-11-30 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
						// se resta la cantidad a la barra encontrada del pedido agrupado, ya que este es el cargado en lds_barras.
						ll_cant_restante = lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada') - ll_cantidad
						lds_barras.SetItem(ll_n,'ca_programada', lds_barras.getItemDecimal(ll_n,'ca_programada') - ll_cant_restante)
						/*lds_barras.SetItem(ll_n,'ca_asignada', lds_barras.getItemDecimal(ll_n,'ca_asignada') + ll_cantidad)*/
						lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
						lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
						lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
						if lb_bongo_agrupador then
							// stvalenc antes de realizar el cambio de en los campos al nuevo modulo
							//verificamos que se ingresara el modulo donde se encontro la barra reservada para recalcular este modulo
							ls_expresion_modulo_2 = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
															'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
															'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
															'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
															'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
							If lds_modulos_cambio.Find(ls_expresion_modulo_2 ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
								ll_m = lds_modulos_cambio.InsertRow(0)
								lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
								lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
								lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
								lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
								lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
							End if
							//Si es bongo agrupador, y se encontro barra en el pdp, se debe agruegar la barra al final de la encontrada con bongo agrupador
							lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 1 ) ))
							lds_barras.SetItem(ll_n,'fe_final_progs',datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 2 ) ))	
							lds_barras.SetItem(ll_n,'co_maquina', lds_barras_bongo_agrupado.GetItemNumber(1,'co_maquina'))
							lds_barras.SetItem(ll_n,'co_fabrica_sim',lds_barras_bongo_agrupado.GetItemNumber(1,'co_fabrica_sim'))
							lds_barras.SetItem(ll_n,'co_planta',lds_barras_bongo_agrupado.GetItemNumber(1,'co_planta'))
							lds_barras.SetItem(ll_n,'co_centro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_centro_pdn'))
							lds_barras.SetItem(ll_n,'co_subcentro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_subcentro_pdn'))
							lds_barras.SetItem(ll_n,'tiempo_estandar', lds_barras_bongo_agrupado.GetItemDecimal(1,'tiempo_estandar'))
							lds_barras.SetItem(ll_n,'co_recurso', lds_barras_bongo_agrupado.GetItemNumber(1,'co_recurso'))
							lds_barras.SetItem(ll_n,'ca_programada',ll_cantidad)
							lds_barras.SetItem(ll_n,'ca_asignada',ll_cantidad)
							lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
						end if
						// si es un pedido agrupado realizamos el cambio al pedido individual para guardar en pdp
						if lb_pedido_agrupado then
							lds_barras.SetItem(ll_n,'pedido',ll_pedido)
						end if
						
						//inserta en la tabla que indica que la caja se ingreso a Pdp
						ll_reg_caja = lds_cajas.InsertRow(0)
						if lb_bongo_agrupador then
							// si es bongo agrupado insetamos la nueva secuencia despues del update de lds_barras
						else
							lds_cajas.SetItem(ll_reg_caja,'secuencia_pdp', lds_barras.GetItemNumber(ll_n,'secuencia'))
						end if
						lds_cajas.SetItem(ll_reg_caja,'pallet_id', as_bongo)
						//stvalenc se conserva el pedido individual
						if lb_pedido_agrupado then
							lds_cajas.SetItem(ll_reg_caja,'pedido',ll_pedido)
						else
							lds_cajas.SetItem(ll_reg_caja,'pedido', lds_barras.GetItemNumber(ll_n,'pedido'))
						end if
						lds_cajas.SetItem(ll_reg_caja,'co_fabrica_sim', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
						lds_cajas.SetItem(ll_reg_caja,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
						lds_cajas.SetItem(ll_reg_caja,'co_centro_pdn', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
						lds_cajas.SetItem(ll_reg_caja,'co_subcentro_pdn', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
						lds_cajas.SetItem(ll_reg_caja,'co_tipo_negocio', lds_barras.GetItemNumber(ll_n,'co_tipo_negocio'))
						lds_cajas.SetItem(ll_reg_caja,'co_maquina', lds_barras.GetItemNumber(ll_n,'co_maquina'))
						lds_cajas.SetItem(ll_reg_caja,'simulacion', lds_barras.GetItemNumber(ll_n,'simulacion'))
						lds_cajas.SetItem(ll_reg_caja,'co_referencia', lds_barras.GetItemString(ll_n,'co_referencia'))
						lds_cajas.SetItem(ll_reg_caja,'ca_programada', lds_barras.GetItemDecimal(ll_n,'ca_programada'))
						
						//si queda cantidad para la barra, se adiciona una nueva
						If ll_cant_restante > 0 Then
							//se inserta barra nueva con cantidad restante
							lds_barras.RowsCopy(ll_n, ll_n, Primary!, lds_barras, lds_barras.RowCount() + 1, Primary!)
							// stvalenc si el queda cantidad restante conservamos la barra con el pedido agrupado que ya traia la barra
							////stvalenc 2021-11-30 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
							ll_n = lds_barras.RowCount()
							//se coloca las unidades faltantes
							if lb_pedido_agrupado then
								lds_barras.SetItem(ll_n,"pedido",ll_pedido_agrupa)
							end if
							lds_barras.SetItem(ll_n,'ca_programada',ll_cant_restante)
							lds_barras.SetItem(ll_n,'ca_asignada',0)
							//coloca la barra despues de la barra 
							lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_inicio_progs')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_inicio_progs')), 1 ) ))
							lds_barras.SetItem(ll_n,'secuencia',ll_nulo)
							lds_barras.SetItem(ll_n,'fe_creacion',ldt_fecha)
							lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
							lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
							lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
						End if
						
						//se guarda el modulo para actualizar la produccion
						ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
											'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
											'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
											'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
											'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
											
						If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
							ll_m = lds_modulos_cambio.InsertRow(0)
							lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
							lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
							lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
							lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
							lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
						End if
						
					//no encuentra la barra ca_programada - ca_asignada > cantidad
					ElseIf ll_n = 0 Then
						//se miran las barras y se unen hasta que cumpla con la cantidad del pedido-referencia
						//inicia el contador de las barras
						ll_n = 1
						 
						//toma la cantidad faltante en la primera barra
						ll_cant_restante = ll_cantidad - (lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada'))
						Do 
							//mira si hay solo una barra o no hay mas barras para unir
							If ll_n  > ( lds_barras.RowCount() - 1) Then
								lds_barras.SetItem(1,'ca_programada', lds_barras.getItemDecimal(1,'ca_programada') + ll_cant_restante)
								/*lds_barras.SetItem(1,'ca_asignada', lds_barras.getItemDecimal(1,'ca_asignada') + ll_cantidad)*/
								lds_barras.SetItem(1,'fe_actualizacion',ldt_fecha)
								lds_barras.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
								lds_barras.SetItem(1,'instancia', gstr_info_usuario.instancia)
								if lb_bongo_agrupador then
									// stvalenc antes de realizar el cambio de en los campos al nuevo modulo
									//verificamos que se ingresara el modulo donde se encontro la barra reservada para recalcular este modulo
									ls_expresion_modulo_2 = 'co_fabrica = ' + String(lds_barras.GetItemNumber(1,'co_fabrica_sim')) + ' and ' + &
															'co_planta = ' + String(lds_barras.GetItemNumber(1,'co_planta')) + ' and ' + &
															'co_centro = ' + String(lds_barras.GetItemNumber(1,'co_centro_pdn')) + ' and ' + &
															'co_subcentro = ' + String(lds_barras.GetItemNumber(1,'co_subcentro_pdn')) + ' and ' + &
															'co_modulo = ' + String(lds_barras.GetItemNumber(1,'co_maquina')) 
									If lds_modulos_cambio.Find(ls_expresion_modulo_2 ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
										ll_m = lds_modulos_cambio.InsertRow(0)
										lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(1,'co_fabrica_sim'))
										lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(1,'co_planta'))
										lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(1,'co_centro_pdn'))
										lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(1,'co_subcentro_pdn'))
										lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(1,'co_maquina'))
									End if
									//Si es bongo agrupador, y se encontro barra en el pdp, se debe agruegar la barra al final de la encontrada con bongo agrupador
									lds_barras.SetItem(1,'fe_inicio_progs', datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 1 ) ))
									lds_barras.SetItem(1,'fe_final_progs',datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 2 ) ))	
									lds_barras.SetItem(1,'co_maquina', lds_barras_bongo_agrupado.GetItemNumber(1,'co_maquina'))
									lds_barras.SetItem(1,'co_fabrica_sim',lds_barras_bongo_agrupado.GetItemNumber(1,'co_fabrica_sim'))
									lds_barras.SetItem(1,'co_planta',lds_barras_bongo_agrupado.GetItemNumber(1,'co_planta'))
									lds_barras.SetItem(1,'co_centro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_centro_pdn'))
									lds_barras.SetItem(1,'co_subcentro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_subcentro_pdn'))
									lds_barras.SetItem(1,'tiempo_estandar', lds_barras_bongo_agrupado.GetItemDecimal(1,'tiempo_estandar'))
									lds_barras.SetItem(1,'co_recurso', lds_barras_bongo_agrupado.GetItemNumber(1,'co_recurso'))
									lds_barras.SetItem(1,'fe_actualizacion',ldt_fecha)
								end if
								//stvalenc 2021-11-30 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
								//conservamos el pedido individual
								if lb_pedido_agrupado then
									lds_barras.SetItem(1,"pedido",ll_pedido)
								end if

								ll_cant_restante = 0
							//si hay mas barras
							Else
								//toma la siguiente barra
								ll_n ++
								//mira si la cantidad de la segunda barra alcanza completar la cantidad del pedido-referencia
								If ll_cant_restante <= (lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada')) Then
									//aumenta la cantidad de la primera barra
									lds_barras.SetItem(1,'ca_programada', lds_barras.getItemDecimal(1,'ca_programada') + ll_cant_restante)
									/*lds_barras.SetItem(1,'ca_asignada', lds_barras.getItemDecimal(1,'ca_asignada') + ll_cantidad)*/
									lds_barras.SetItem(1,'fe_actualizacion',ldt_fecha)
									lds_barras.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
									lds_barras.SetItem(1,'instancia', gstr_info_usuario.instancia)
									if lb_bongo_agrupador then
										ls_expresion_modulo_2 = 'co_fabrica = ' + String(lds_barras.GetItemNumber(1,'co_fabrica_sim')) + ' and ' + &
															'co_planta = ' + String(lds_barras.GetItemNumber(1,'co_planta')) + ' and ' + &
															'co_centro = ' + String(lds_barras.GetItemNumber(1,'co_centro_pdn')) + ' and ' + &
															'co_subcentro = ' + String(lds_barras.GetItemNumber(1,'co_subcentro_pdn')) + ' and ' + &
															'co_modulo = ' + String(lds_barras.GetItemNumber(1,'co_maquina')) 
										If lds_modulos_cambio.Find(ls_expresion_modulo_2 ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
											ll_m = lds_modulos_cambio.InsertRow(0)
											lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(1,'co_fabrica_sim'))
											lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(1,'co_planta'))
											lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(1,'co_centro_pdn'))
											lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(1,'co_subcentro_pdn'))
											lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(1,'co_maquina'))
										End if
										//Si es bongo agrupador, y se encontro barra en el pdp, se debe agruegar la barra al final de la encontrada con bongo agrupador
										lds_barras.SetItem(1,'fe_inicio_progs', datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 1 ) ))
										lds_barras.SetItem(1,'fe_final_progs',datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 2 ) ))	
										lds_barras.SetItem(1,'co_maquina', lds_barras_bongo_agrupado.GetItemNumber(1,'co_maquina'))
										lds_barras.SetItem(1,'co_fabrica_sim',lds_barras_bongo_agrupado.GetItemNumber(1,'co_fabrica_sim'))
										lds_barras.SetItem(1,'co_planta',lds_barras_bongo_agrupado.GetItemNumber(1,'co_planta'))
										lds_barras.SetItem(1,'co_centro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_centro_pdn'))
										lds_barras.SetItem(1,'co_subcentro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_subcentro_pdn'))
										lds_barras.SetItem(1,'tiempo_estandar', lds_barras_bongo_agrupado.GetItemDecimal(1,'tiempo_estandar'))
										lds_barras.SetItem(1,'co_recurso', lds_barras_bongo_agrupado.GetItemNumber(1,'co_recurso'))
										lds_barras.SetItem(1,'fe_creacion',ldt_fecha)
									end if
									//stvalenc se cambia el pedido al invidual si es pedido agrupado
									if lb_pedido_agrupado then
										lds_barras.SetItem(1,"pedido",ll_pedido)
									end if
									
									//se descuenta de la siguiente barra
									lds_barras.SetItem(ll_n,'ca_programada', lds_barras.getItemDecimal(ll_n,'ca_programada') - ll_cant_restante)
									//mira si la segunda barra queda sin unidades
									If lds_barras.getItemDecimal(ll_n,'ca_programada') = 0 Then
										//coloca la simulacion en 200 para que no se tenga en cuenta cuando se recalcula el Pdp
										lds_barras.SetItem(ll_n,'simulacion', 200)	
									End if
									//stvalenc 2021-11-30 ID530 - Agrupacion de pedidos - Cambios en liberacion  y loteo
									//stvalenc se cambia el pedido al invidual si es pedido agrupado
									if lb_pedido_agrupado then
										lds_barras.SetItem(ll_n,"pedido",ll_pedido)
									end if
									
									lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
									lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
									lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
									
									ll_cant_restante = 0
								//sino alcanza a cubrir toda la cantidad
								Else
									//la cantidad de la primera barra se tiene en cuenta solo la primera vez
									IF ll_n = 2 Then
										 ll_cantbarra1 = lds_barras.getItemDecimal(1,'ca_programada') - lds_barras.getItemDecimal(1,'ca_asignada')
									Else
										ll_cantbarra1 = 0
									End if
									
									ll_cantbarra2 = lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada')
									
									//aumenta la cantidad de la primera barra
									lds_barras.SetItem(1,'ca_programada', lds_barras.getItemDecimal(1,'ca_programada') + &
																						(lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada')))
									/*lds_barras.SetItem(1,'ca_asignada', lds_barras.getItemDecimal(1,'ca_programada') )*/
									lds_barras.SetItem(1,'fe_actualizacion',ldt_fecha)
									lds_barras.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
									lds_barras.SetItem(1,'instancia', gstr_info_usuario.instancia)
									if lb_bongo_agrupador then
										// stvalenc antes de realizar el cambio de en los campos al nuevo modulo
										//verificamos que se ingresara el modulo donde se encontro la barra reservada para recalcular este modulo
										ls_expresion_modulo_2 = 'co_fabrica = ' + String(lds_barras.GetItemNumber(1,'co_fabrica_sim')) + ' and ' + &
															'co_planta = ' + String(lds_barras.GetItemNumber(1,'co_planta')) + ' and ' + &
															'co_centro = ' + String(lds_barras.GetItemNumber(1,'co_centro_pdn')) + ' and ' + &
															'co_subcentro = ' + String(lds_barras.GetItemNumber(1,'co_subcentro_pdn')) + ' and ' + &
															'co_modulo = ' + String(lds_barras.GetItemNumber(1,'co_maquina')) 
										If lds_modulos_cambio.Find(ls_expresion_modulo_2 ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
											ll_m = lds_modulos_cambio.InsertRow(0)
											lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(1,'co_fabrica_sim'))
											lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(1,'co_planta'))
											lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(1,'co_centro_pdn'))
											lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(1,'co_subcentro_pdn'))
											lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(1,'co_maquina'))
										End if
										//Si es bongo agrupador, y se encontro barra en el pdp, se debe agruegar la barra al final de la encontrada con bongo agrupador
										lds_barras.SetItem(1,'fe_inicio_progs', datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 1 ) ))
										lds_barras.SetItem(1,'fe_final_progs',datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 2 ) ))	
										lds_barras.SetItem(1,'co_maquina', lds_barras_bongo_agrupado.GetItemNumber(1,'co_maquina'))
										lds_barras.SetItem(1,'co_fabrica_sim',lds_barras_bongo_agrupado.GetItemNumber(1,'co_fabrica_sim'))
										lds_barras.SetItem(1,'co_planta',lds_barras_bongo_agrupado.GetItemNumber(1,'co_planta'))
										lds_barras.SetItem(1,'co_centro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_centro_pdn'))
										lds_barras.SetItem(1,'co_subcentro_pdn',lds_barras_bongo_agrupado.GetItemNumber(1,'co_subcentro_pdn'))
										lds_barras.SetItem(1,'tiempo_estandar', lds_barras_bongo_agrupado.GetItemDecimal(1,'tiempo_estandar'))
										lds_barras.SetItem(1,'co_recurso', lds_barras_bongo_agrupado.GetItemNumber(1,'co_recurso'))
										lds_barras.SetItem(1,'fe_creacion',ldt_fecha)
									end if
									if lb_pedido_agrupado then
										lds_barras.SetItem(1,"pedido",ll_pedido)
									end if
									
									//se descuenta de la siguiente barra
									lds_barras.SetItem(ll_n,'ca_programada', lds_barras.getItemDecimal(ll_n,'ca_programada') - &
																						(lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada')))
									//mira si la segunda barra queda sin unidades
									If lds_barras.getItemDecimal(ll_n,'ca_programada') = 0 Then
										//coloca la simulacion en 200 para que no se tenga en cuenta cuando se recalcula el Pdp
										lds_barras.SetItem(ll_n,'simulacion', 200)	
									End if
									if lb_pedido_agrupado then
										lds_barras.SetItem(ll_n,"pedido",ll_pedido)
									end if
									
									lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
									lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
									lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
									
									//mira cuanto es la cantidad faltante
									ll_cant_restante = ll_cantidad - ll_cantbarra1 - ll_cantbarra2
									ll_cantidad = ll_cant_restante
								End if//If ll_cant_restante <= (lds_barras.getItemDecimal(ll_n,'ca_programada') - lds_barras.getItemDecimal(ll_n,'ca_asignada')) Then
								
							End if//If ll_n  > ( lds_barras.RowCount() - 1) Then
							
							//si modifica mas de una barra
							If ll_n > 1 Then
								//se guarda el modulo para actualizar la produccion
								ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(1,'co_fabrica_sim')) + ' and ' + &
													'co_planta = ' + String(lds_barras.GetItemNumber(1,'co_planta')) + ' and ' + &
													'co_centro = ' + String(lds_barras.GetItemNumber(1,'co_centro_pdn')) + ' and ' + &
													'co_subcentro = ' + String(lds_barras.GetItemNumber(1,'co_subcentro_pdn')) + ' and ' + &
													'co_modulo = ' + String(lds_barras.GetItemNumber(1,'co_maquina')) 
													
								If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
									ll_m = lds_modulos_cambio.InsertRow(0)
									lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(1,'co_fabrica_sim'))
									lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(1,'co_planta'))
									lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(1,'co_centro_pdn'))
									lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(1,'co_subcentro_pdn'))
									lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(1,'co_maquina'))
								End if
							End if
							
							//se guarda el modulo para actualizar la produccion
							ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
												'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
												'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
												'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
												'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
												
							If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
								ll_m = lds_modulos_cambio.InsertRow(0)
								lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
								lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
								lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
								lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
								lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
							End if

						Loop while ll_cant_restante > 0
						
						//inserta en la tabla que indica que la caja se ingreso a Pdp
						ll_reg_caja = lds_cajas.InsertRow(0)
						if lb_bongo_agrupador then
							// si es bongo agrupado se agrega al final la secuencia, despues del update de lds_barras
						else
							lds_cajas.SetItem(ll_reg_caja,'secuencia_pdp', lds_barras.GetItemNumber(1,'secuencia'))
						end if
						lds_cajas.SetItem(ll_reg_caja,'pallet_id', as_bongo)
						if lb_pedido_agrupado then
							lds_cajas.SetItem(ll_reg_caja,'pedido',ll_pedido)
						else
							lds_cajas.SetItem(ll_reg_caja,'pedido', lds_barras.GetItemNumber(ll_n,'pedido'))
						end if
						lds_cajas.SetItem(ll_reg_caja,'co_fabrica_sim', lds_barras.GetItemNumber(1,'co_fabrica_sim'))
						lds_cajas.SetItem(ll_reg_caja,'co_planta', lds_barras.GetItemNumber(1,'co_planta'))
						lds_cajas.SetItem(ll_reg_caja,'co_centro_pdn', lds_barras.GetItemNumber(1,'co_centro_pdn'))
						lds_cajas.SetItem(ll_reg_caja,'co_subcentro_pdn', lds_barras.GetItemNumber(1,'co_subcentro_pdn'))
						lds_cajas.SetItem(ll_reg_caja,'co_tipo_negocio', lds_barras.GetItemNumber(1,'co_tipo_negocio'))
						lds_cajas.SetItem(ll_reg_caja,'co_maquina', lds_barras.GetItemNumber(1,'co_maquina'))
						lds_cajas.SetItem(ll_reg_caja,'simulacion', lds_barras.GetItemNumber(1,'simulacion'))
						lds_cajas.SetItem(ll_reg_caja,'co_referencia', lds_barras.GetItemString(1,'co_referencia'))
						lds_cajas.SetItem(ll_reg_caja,'ca_programada', lds_barras.GetItemDecimal(1,'ca_programada'))
						
					Else
						Rollback;
						//si debe mostrar mensaje
						If ib_mostrar_mensaje Then
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al buscar barras en el Pdp Confeccion para la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) )
						Else
							//se copia el mensaje del error
							is_mensaje = 'Ocurrio un inconveniente al buscar barras en el Pdp Confeccion para la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) 
						End if
						
						Destroy lds_bongo
						Destroy lds_barras
						Destroy lds_modulos_cambio
						Destroy lds_cajas
						
						ls_expresion = 'Ocurrio un inconveniente al buscar barras en el Pdp Confeccion para la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo)
						ll_retorno = -1
						
						Exit
						
					End if
					
				Else
					Rollback;
					//si debe mostrar mensaje
					If ib_mostrar_mensaje Then
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al buscar barras en el Pdp Confeccion para la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) )
					Else
						//se copia el mensaje del error
						is_mensaje = 'Ocurrio un inconveniente al buscar barras en el Pdp Confeccion para la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) 
					End if
						
					Destroy lds_bongo
					Destroy lds_barras
					Destroy lds_modulos_cambio
					Destroy lds_cajas
					
					ls_expresion = 'Ocurrio un inconveniente al buscar barras en el Pdp Confeccion para la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo)
					ll_retorno = -1
					
					Exit
				End if
				
			//sino hay barras reservadas
			Else
				lb_barra_reservada = False
				//se quita el filtro
				lds_barras.SetFilter("")
				lds_barras.Filter()
			
				ll_n = lds_barras.RowCount()
				//se ordena para mirar cual es la barra m$$HEX1$$e100$$ENDHEX$$s pr$$HEX1$$f300$$ENDHEX$$xima asignada a la fecha actual
				lds_barras.SetSort('fe_final_progs Asc')
				lds_barras.Sort()
				
				//se inserta barra nueva
				lds_barras.RowsCopy(1, 1, Primary!, lds_barras, ll_n + 1, Primary!)
				
				ll_n = ll_n + 1
				//se coloca las unidades igual a la cantidad del bongo
				if lb_bongo_agrupador then
					//Si es bongo agrupador, y se encontro barra en el pdp, se debe agruegar la barra al final de la encontrada con bongo agrupador
					lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 1 ) ))
					lds_barras.SetItem(ll_n,'fe_final_progs',datetime(Date( lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')),RelativeTime ( Time(lds_barras_bongo_agrupado.GetItemDatetime(1,'fe_final_progs')), 2 ) ))	
					lds_barras.SetItem(ll_n,'co_maquina', lds_barras_bongo_agrupado.GetItemNumber(1,'co_maquina'))
					lds_barras.SetItem(ll_n,'tiempo_estandar', lds_barras_bongo_agrupado.GetItemDecimal(1,'co_maquina'))
					lds_barras.SetItem(ll_n,'co_recurso', lds_barras_bongo_agrupado.GetItemNumber(1,'co_recurso'))
				else
					//si no la coloca con el flujo normal de ejecucion coloca la barra despues de la barra encontrada
					lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_final_progs')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_final_progs')), 1 ) ))
					lds_barras.SetItem(ll_n,'fe_final_progs',datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_final_progs')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_final_progs')), 2 ) ))	
				end if
				lds_barras.SetItem(ll_n,'ca_programada',ll_cantidad)
				/*lds_barras.SetItem(ll_n,'ca_asignada',ll_cantidad)*/
				lds_barras.SetItem(ll_n,'ca_asignada',0)
				lds_barras.SetItem(ll_n,'secuencia',ll_nulo)
				lds_barras.SetItem(ll_n,'fe_creacion',ldt_fecha)
				lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
				lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
				lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
				//stvalenc si es de un pedido agrupado guardamos la barra con la informacion del pedido individual
				if lb_pedido_agrupado then
					lds_barras.SetItem(ll_n,"pedido",ll_pedido)
				end if
				
				
				
				//se guarda el modulo para actualizar la produccion
				ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
									'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
									'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
									'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
									'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
									
				If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
					ll_m = lds_modulos_cambio.InsertRow(0)
					lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
					lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
					lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
					lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
					lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
				End if
				
				//inserta en la tabla que indica que la caja se ingreso a Pdp
					ll_reg_caja = lds_cajas.InsertRow(0)
					lds_cajas.SetItem(ll_reg_caja,'pallet_id', as_bongo)
					//si es un pedido agrupado se deja la logica igual, ya que se busco el pedido agrupado
					if lb_pedido_agrupado then
						lds_cajas.SetItem(ll_reg_caja,'pedido',ll_pedido)
					else
						lds_cajas.SetItem(ll_reg_caja,'pedido', lds_barras.GetItemNumber(ll_n,'pedido'))
					end if
					lds_cajas.SetItem(ll_reg_caja,'co_fabrica_sim', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
					lds_cajas.SetItem(ll_reg_caja,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
					lds_cajas.SetItem(ll_reg_caja,'co_centro_pdn', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
					lds_cajas.SetItem(ll_reg_caja,'co_subcentro_pdn', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
					lds_cajas.SetItem(ll_reg_caja,'co_tipo_negocio', lds_barras.GetItemNumber(ll_n,'co_tipo_negocio'))
					lds_cajas.SetItem(ll_reg_caja,'co_maquina', lds_barras.GetItemNumber(ll_n,'co_maquina'))
					lds_cajas.SetItem(ll_reg_caja,'simulacion', lds_barras.GetItemNumber(ll_n,'simulacion'))
					lds_cajas.SetItem(ll_reg_caja,'co_referencia', lds_barras.GetItemString(ll_n,'co_referencia'))
					lds_cajas.SetItem(ll_reg_caja,'ca_programada', lds_barras.GetItemDecimal(ll_n,'ca_programada'))
				
			End if
			
		Else //If ll_n = 0 Then del retrieve de las barras
			Rollback;
			//si debe mostrar mensaje
			If ib_mostrar_mensaje Then
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al buscar la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' en el Pdp Confeccion.' )
			Else
				//se copia el mensaje del error
				is_mensaje = 'Ocurrio un inconveniente al buscar la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' en el Pdp Confeccion.'
			End if
			
			Destroy lds_bongo
			Destroy lds_barras
			Destroy lds_modulos_cambio
			Destroy lds_cajas
			
			ls_expresion = 'Ocurrio un inconveniente al buscar la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo) + ' en el Pdp Confeccion.'
			ll_retorno = -1
			
			Exit
		End if
		
		//se guardan los datos de las barras
		IF lds_barras.of_Update() <= 0 THEN
			ROLLBACK;
			//si debe mostrar mensaje
			If ib_mostrar_mensaje Then
				Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al actualizar los datos de las barras del Pdp de confeccion con la informacion del bongo " + trim(as_bongo))
			Else
				//se copia el mensaje del error
				is_mensaje = "Ocurrio un inconveniente al actualizar los datos de las barras del Pdp de confeccion con la informacion del bongo " + trim(as_bongo)
			End if
			
			Destroy lds_bongo
			Destroy lds_barras
			Destroy lds_modulos_cambio
			Destroy lds_cajas
			
			ls_expresion = "Ocurrio un inconveniente al actualizar los datos de las barras del Pdp de confeccion con la informacion del bongo " + trim(as_bongo)
			ll_retorno = -1
			
			Exit
		End if
		
		//sino habia barra reservada o bongo agrupador, se actualiza el campo de secuencia
		If lb_barra_reservada = False or lb_bongo_agrupador = True Then
			lds_cajas.SetItem(ll_reg_caja,'secuencia_pdp', lds_barras.GetItemNumber(ll_n,'secuencia'))
		End if
				
	Next

	//sino ocurrio ningun problema
	If ll_retorno > 0 Then
		
		//se guardan los datos de las cajas asignadas a Pdp
		IF lds_cajas.of_Update() <= 0 THEN
			ROLLBACK;
			//si debe mostrar mensaje
			If ib_mostrar_mensaje Then
				Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al actualizar el bongo y las barras del Pdp de confeccion con la informacion del bongo " + trim(as_bongo))
			Else
				//se copia el mensaje del error
				is_mensaje = "Ocurrio un inconveniente al actualizar el bongo y las barras del Pdp de confeccion con la informacion del bongo " + trim(as_bongo)
			End if
			
			Destroy lds_bongo
			Destroy lds_barras
			Destroy lds_modulos_cambio
			Destroy lds_cajas
			
			ls_expresion = "Ocurrio un inconveniente al actualizar el bongo y las barras del Pdp de confeccion con la informacion del bongo " + trim(as_bongo)
			ll_retorno = -1
			
		End if
	End if
		
	//sino ocurrio ningun problema
	If ll_retorno > 0 Then
		
		//se actualiza la produccion
		For ll_n = 1 to lds_modulos_cambio.RowCount()
			lstr_parametros.entero[1] = lds_modulos_cambio.GetItemNumber(ll_n,'co_modulo') 
			
			If lnvo_simulacion.of_recalcular( lstr_parametros, lds_modulos_cambio.GetItemNumber(ll_n,'co_fabrica') , lds_modulos_cambio.GetItemNumber(ll_n,'co_planta') , &
				lds_modulos_cambio.GetItemNumber(ll_n,'co_centro'),  lds_modulos_cambio.GetItemNumber(ll_n,'co_subcentro') , 1, 0, Date(ldt_fecha)) < 0 Then
				
				Rollback;
				//si debe mostrar mensaje
				If ib_mostrar_mensaje Then
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"Ocurrio un inconveniente al actualizar la producci$$HEX1$$f300$$ENDHEX$$n en PDP de confeccion con la informacion del bongo " + trim(as_bongo) + " fabrica " + &
									String(lds_modulos_cambio.GetItemNumber(ll_n,'co_fabrica')) + " planta " + String(lds_modulos_cambio.GetItemNumber(ll_n,'co_planta')))
				
				Else
					//se copia el mensaje del error
					is_mensaje = "Ocurrio un inconveniente al actualizar la producci$$HEX1$$f300$$ENDHEX$$n en PDP de confeccion con la informacion del bongo " + trim(as_bongo) + " fabrica " + &
									String(lds_modulos_cambio.GetItemNumber(ll_n,'co_fabrica')) + " planta " + String(lds_modulos_cambio.GetItemNumber(ll_n,'co_planta'))
				End if
				Destroy lds_bongo
				Destroy lds_barras
				Destroy lds_modulos_cambio
				Destroy lds_cajas
				
				ls_expresion = "Ocurrio un inconveniente al actualizar la producci$$HEX1$$f300$$ENDHEX$$n en PDP de confeccion con la informacion del bongo " + trim(as_bongo) + " fabrica " + &
									String(lds_modulos_cambio.GetItemNumber(ll_n,'co_fabrica')) + " planta " + String(lds_modulos_cambio.GetItemNumber(ll_n,'co_planta'))
				ll_retorno = -1
				
				Exit
			End if
		Next
		
		If ll_retorno > 0 Then
			If lds_barras.of_commit() > 0 Then
				//MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se modifico el Pdp Confeccion con $$HEX1$$e900$$ENDHEX$$xito.')
			Else
				Rollback;
				//si debe mostrar mensaje
				If ib_mostrar_mensaje Then
					Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo hacer los cambios en el Pdp de confeccion (COMMIT) con la informacion del bongo " + trim(as_bongo) ,Exclamation!,Ok!)
				Else
					//se copia el mensaje del error
					is_mensaje = "No se pudo hacer los cambios en el Pdp de confeccion (COMMIT) con la informacion del bongo " + trim(as_bongo)
				End if
				
				Destroy lds_bongo
				Destroy lds_barras
				Destroy lds_modulos_cambio
				Destroy lds_cajas
				
				ls_expresion = "No se pudo hacer los cambios en el Pdp de confeccion (COMMIT) con la informacion del bongo " + trim(as_bongo) 
				ll_retorno = -1
				
			End if
		
			Destroy lds_barras
			Destroy lds_modulos_cambio
			Destroy lds_cajas
		End if
	End if

//sino encuentra datos
Elseif ll_reg = 0 Then 
	rollback;
	return 0;
Else
	Rollback;
	//si debe mostrar mensaje
	If ib_mostrar_mensaje Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al traer la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo))
	Else
		//se copia el mensaje del error
		is_mensaje = 'Ocurrio un inconveniente al traer la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo)
	End if
	
	Destroy lds_bongo
	ls_expresion = 'Ocurrio un inconveniente al traer la informaci$$HEX1$$f300$$ENDHEX$$n del bongo ' + trim(as_bongo)
	ll_retorno = -1
End if

If ll_retorno < 0 Then
	//si debe enviar correo
	If ib_enviar_correo Then
		//se envia correo por el inconveniente
		//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 24 es el que pertenece a este proceso en la tabla m_usu_correo
		/*
		Declare pr_envia_correo Procedure For pr_envia_correo('No actualizo bongo loteado en Pdp Confeccion', &
					:ls_expresion,24, :ls_usuario);
		Execute pr_envia_correo;
		If SQLCA.SQLCODE = -1 Then
			ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
			RollBack;
			//si debe mostrar mensaje
			If ib_mostrar_mensaje Then
				MessageBox("Atencion", "Error enviando correo por inconveniente en el cambio de Pdp en el loteo" + ls_error, StopSign!)
			Else 
				//se copia el mensaje del error
				is_mensaje = "Error enviando correo por inconveniente en el cambio de Pdp en el loteo" + ls_error
			End if
			
			Close pr_envia_correo;
			Destroy lds_bongo
			Return -1
		End If
		// Cierra el procedimiento almacenado declarado
		Close pr_envia_correo;
		*/
		uo_correo	lnv_correo
		lnv_correo = CREATE uo_correo
		
		TRY
			lnv_correo.of_enviar_correo('No actualizo bongo loteado en Pdp Confeccion', ls_expresion, 'cambio_pdp_loteo', ls_usuario)
		CATCH(Exception ex)
			Messagebox("Error", ex.getmessage())
		END TRY
		
		DESTROY lnv_correo 
	End if
	
	//mira si debe crear log del bongo sin pdp de confeccion, esto para intentar crearlo mas tarde
	If ib_crear_log_bongo_sin_pdp = True Then
		
		lds_bongo_sin_pdp = Create uo_dsbase
		lds_bongo_sin_pdp.DataObject = 'd_gr_bongos_loteo_sin_pdp'
		lds_bongo_sin_pdp.SetTransObject(SQLCA)
		
		//inserta registro
		ll_reg = lds_bongo_sin_pdp.InsertRow(0)
		lds_bongo_sin_pdp.SetItem(ll_reg,'pallet_id',as_bongo)
		lds_bongo_sin_pdp.SetItem(ll_reg,'estado',0)
		lds_bongo_sin_pdp.SetItem(ll_reg,'observacion',is_mensaje)
		lds_bongo_sin_pdp.SetItem(ll_reg,'fe_creacion',ldt_fecha)
		lds_bongo_sin_pdp.SetItem(ll_reg,'fe_actualizacion',ldt_fecha)
		lds_bongo_sin_pdp.SetItem(ll_reg,'usuario',gstr_info_usuario.codigo_usuario)
		lds_bongo_sin_pdp.SetItem(ll_reg,'instancia', gstr_info_usuario.instancia)
		
		//se guardan los datos de la caja sin asignar a Pdp
		IF lds_bongo_sin_pdp.of_Update() <= 0 THEN
			ROLLBACK;
			Destroy lds_bongo_sin_pdp
			Return -1
		End if
		
		If lds_bongo_sin_pdp.of_commit() > 0 Then
			
		Else
			Rollback;
			Destroy lds_bongo_sin_pdp
			Return -1
		End if
	
		Destroy lds_bongo_sin_pdp
	End if
	
	
	Destroy lds_bongo
	Return -1
End if

Destroy lds_bongo

Return 1
end function

public function long of_actualiza_pdp_confeccion_x_oc (long an_orden_corte);

/*
Funcion que actualiza el Pdp con los bongos que pertenecen a la orden de corte y que no se hayan ingresado al Pdp
*/

Long ll_n
String ls_error, ls_expresion, ls_usuario
uo_dsbase lds_bongo

ls_usuario = gstr_info_usuario.codigo_usuario

lds_bongo = Create uo_dsbase
lds_bongo.DataObject = 'd_gr_bongos_loteo_sin_pdp_x_oc'
lds_bongo.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

ll_n = lds_bongo.Of_Retrieve(an_orden_corte)

If ll_n > 0 Then
	ls_expresion = ''
	//recorre los bongos y los pasa al Pdp de confeccion
	For ll_n = 1 to lds_bongo.RowCount()
		//se realiza la modificacion en el Pdp de confeccion con el bongo loteado
		IF of_actualiza_pdp_confeccion(Trim(lds_bongo.GetItemString(ll_n,'pallet_id'))) > 0 THEN
			ls_expresion = ls_expresion + ' ' +Trim(lds_bongo.GetItemString(ll_n,'pallet_id'))
		END IF
	Next
	
	If ls_expresion <> '' Then
		MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se modifico el Pdp Confeccion con $$HEX1$$e900$$ENDHEX$$xito con los siguientes bongos:' + ls_expresion)
	End if
Else

	If ll_n = 0 Then
		ls_expresion = 'No se encontraron los bongos loteados de la orden corte ' + String(an_orden_corte)
	Else
		ls_expresion = 'Ocurrio un inconveniente al traer los bongos loteados de la orden corte ' + String(an_orden_corte)
	End if
	//se envia correo por el inconveniente
	//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 24 es el que pertenece a este proceso en la tabla m_usu_correo
	/*
	Declare pr_envia_correo Procedure For pr_envia_correo('No actualizo bongo loteado en Pdp Confeccion', &
				:ls_expresion,24,:ls_usuario);
	Execute pr_envia_correo;
	If SQLCA.SQLCODE = -1 Then
		ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
		RollBack;
		MessageBox("Atencion", "Error enviando correo por inconveniente en el cambio de Pdp en el loteo" + ls_error, StopSign!)
		Close pr_envia_correo;
		Destroy lds_bongo
		Return -1
	End If
	// Cierra el procedimiento almacenado declarado
	Close pr_envia_correo;
	*/
	uo_correo	lnv_correo
	lnv_correo = CREATE uo_correo
	
	TRY
		lnv_correo.of_enviar_correo('No actualizo bongo loteado en Pdp Confeccion', ls_expresion,'cambio_pdp_loteo', ls_usuario)
	CATCH(Exception ex)
		Messagebox("Error", ex.getmessage())
	END TRY
	
	DESTROY lnv_correo
	Destroy lds_bongo
	Return -1
End if

Destroy lds_bongo
Return 1
end function

public function long of_tipo_orden_corte (long al_orden_corte);
Long ll_reg, ll_tipo
uo_dsbase lds_tipo

lds_tipo = Create uo_dsbase  
lds_tipo.DataObject = 'd_gr_tipo_orden_corte'
lds_tipo.SetTransObject(sqlca)

//consulta el tipo
ll_reg = lds_tipo.Retrieve(al_orden_corte)
If ll_reg > 0 Then
	//toma el tipo
	ll_tipo = lds_tipo.GetItemNumber(1,'co_tipo')
	If Isnull(ll_tipo) Then ll_tipo = 0
ElseIf ll_reg = 0 Then
	ll_tipo = 0
Else
	ll_tipo = -2
End if

Destroy lds_tipo
Return ll_tipo
end function

public function long of_crea_bongos_loeados_pdp_confeccion ();/*
	Funcion que mira los bongos que se han loteado pero que no se han subido al pdp de confeccion, se vuelve a intentar la 
	creacion del bongo en el pdp
*/

Long ll_n, ll_bongos_x_reproceso, ll_retorno
String ls_error, ls_expresion
Datetime ldt_fecha
uo_dsbase lds_bongo

n_cts_constantes_corte lpo_const_corte

// FACL - 2021/11/19 - Soporte - Se configura limite de bongos sin PDP a reprocesar
ll_bongos_x_reproceso = lpo_const_corte.of_consultar_numerico('BONGOS_REP_SIN_PDP')  


lds_bongo = Create uo_dsbase
lds_bongo.DataObject = 'd_gr_bongos_loteo_sin_pdp'
lds_bongo.SetTransObject(SQLCA)

//consulta los bongos loteados que no esten en el pdp de confeccion
ll_n = lds_bongo.Of_Retrieve()
If ll_n > 0 Then
	//configura variables para no mostrar mensajes
	ib_mostrar_mensaje = False
	ib_enviar_correo = False
	ib_crear_log_bongo_sin_pdp = False
	ls_expresion = ''
	ldt_fecha = f_fecha_servidor()
	//recorre los bongos y los pasa al Pdp de confeccion
	For ll_n = 1 to lds_bongo.RowCount()
		//se realiza la modificacion en el Pdp de confeccion con el bongo loteado
		ll_retorno = of_actualiza_pdp_confeccion(Trim(lds_bongo.GetItemString(ll_n,'pallet_id')))
		IF ll_retorno > 0 THEN
			//cambia estado para indicar que ya se crearon
			lds_bongo.SetItem(ll_n,'estado',1)
			lds_bongo.SetItem(ll_n,'observacion','Creado en el pdp confeccion')
			lds_bongo.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
			lds_bongo.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
			lds_bongo.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
		Elseif ll_retorno = 0 then
			//stvalenc Cambia el estado a 2 para indicar que es un bongo inexistente
			lds_bongo.SetItem(ll_n,'estado',2)
			lds_bongo.SetItem(ll_n,'observacion','Bongo Inexistente')
			lds_bongo.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
			lds_bongo.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
			lds_bongo.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
		Elseif ll_retorno < 0 then
			if ll_retorno = -2 then
				// stvalenc se crea nuevo estado para identificar los bongo que no enocntraron informacion en barras o portafolio
				lds_bongo.SetItem(ll_n,'estado',3)
				lds_bongo.SetItem(ll_n,'observacion','No se encontro informacion en pdp confeccion o portafolio')
				lds_bongo.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
				lds_bongo.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
				lds_bongo.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
			else
				// FACL - 2021/11/19 - Soporte - Marca la ultima fecha en que se intento ingresar el bongo en el PDP de confeccion
				lds_bongo.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
				lds_bongo.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
				lds_bongo.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
		end if
		END IF
		// FACL - 2021/11/19 - Soporte - Se limita a una constante la cantidad de bongos que se reprocesan
		If ll_n >= ll_bongos_x_reproceso Then
			Exit
		End If
	Next
	
	//se guardan los datos de las cajas asignadas a Pdp
	IF lds_bongo.of_Update() <= 0 THEN
		ROLLBACK;
		Destroy lds_bongo
		ib_mostrar_mensaje = True
		ib_enviar_correo = True
		ib_crear_log_bongo_sin_pdp = True
	End if
	
	If lds_bongo.of_commit() > 0 Then
		//MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se modifico el Pdp Confeccion con $$HEX1$$e900$$ENDHEX$$xito.')
	Else
		Rollback;
		Destroy lds_bongo
		ib_mostrar_mensaje = True
		ib_enviar_correo = True
		ib_crear_log_bongo_sin_pdp = True
	End if
	/*
	If ls_expresion <> '' Then
		MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se modifico el Pdp Confeccion con $$HEX1$$e900$$ENDHEX$$xito con los siguientes bongos:' + ls_expresion)
	End if
	*/
ElseIf ll_n < 0 Then
		
End if

ib_mostrar_mensaje = True
ib_enviar_correo = True
ib_crear_log_bongo_sin_pdp = True
Destroy lds_bongo
Return 1
end function

public function integer of_ubicar_auto_bongo_loteado (long al_orden_corte);/*
	FACL - 2019/02/25 - SA59605 - Se crea funcionalidad para ubicar automaticamente los bongos 
		que se lotearon en la Orden de Corte parametro, si el siguiente Subcentro en la Ruta es
		GBI/TERCEROS se ubica automaticamente
*/

Boolean lb_ubico
Long ll_filas, ll_row, ll_co_tipo
Integer li_co_centro_pdn, li_co_subcentro_pdn, li_ubicar_auto, li_resp
String ls_bongo, ls_ubicacion, ls_ubicacion_tercero, ls_ubicacion_tercero_congelada, ls_ubicacion_GBI_conf_terc, ls_ubicacion_tercero_conf_terc
String ls_ubicacion_GBI, ls_ubicacion_GBI_congelada
String ls_error, ls_bongos_gbi, ls_bongos_terceros, ls_msn, ls_subcentro_ubica
uo_dsbase lds_bongo, lds_ruta_bongo, lds_tipo_oc
n_cts_constantes_corte lnvo_constantes_corte

// Se verifica si la constante esta habilitada para ubicar automaticamente en el lote
li_ubicar_auto = lnvo_constantes_corte.of_Consultar_Numerico('UBICAR_AUTOMATICO_LOTEO')
If li_ubicar_auto <> 1 Or IsNull( li_ubicar_auto ) Then
	Return 0
End If

// Se cargan las ubicaciones automaticas para GBI y Terceros
ls_ubicacion_GBI 					= Trim( lnvo_constantes_corte.of_Consultar_Texto('UBICACION_AUTO_GBI') )
ls_ubicacion_GBI_congelada 	= Trim( lnvo_constantes_corte.of_Consultar_Texto('UBICACION_AUTO_GBI_CONGELADO') )
ls_ubicacion_tercero 			= Trim( lnvo_constantes_corte.of_Consultar_Texto('UBICACION_AUTO_TERCEROS') )
ls_ubicacion_tercero_congelada= Trim( lnvo_constantes_corte.of_Consultar_Texto('UBICACION_AUTO_TERCEROS_CONGELADO') )
ls_ubicacion_GBI_conf_terc		= Trim( lnvo_constantes_corte.of_Consultar_Texto('UBICACION_AUTO_GBI_CONF_TERC') )
ls_ubicacion_tercero_conf_terc	= Trim( lnvo_constantes_corte.of_Consultar_Texto('UBICACION_AUTO_TERCEROS_CONF_TERC') )

If ls_ubicacion_GBI = '' Or ls_ubicacion_GBI_congelada = '' Or ls_ubicacion_tercero = '' Or ls_ubicacion_tercero_congelada = '' Then Return -1


lb_ubico = False


// se cargan los bongos de la OC parametro
lds_bongo = Create uo_dsbase
lds_bongo.DataObject = 'd_gr_bongos_loteados_x_oc'
lds_bongo.SetTransObject(  gnv_recursos.Of_Get_Transaccion_Sucia() )

//SA 61237 Confecci$$HEX1$$f300$$ENDHEX$$n Terceros
//DataStore para consultar co_tipo en h_ordenes_corte
lds_tipo_oc = Create uo_dsbase
lds_tipo_oc.DataObject = 'd_gr_h_ordenes_corte_x_oc'
lds_tipo_oc.SetTransObject(  gnv_recursos.Of_Get_Transaccion_Sucia() )

//SA 61237 Confecci$$HEX1$$f300$$ENDHEX$$n Terceros
If lds_tipo_oc.Retrieve(al_orden_corte) <= 0 Then
	MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontr$$HEX2$$f3002000$$ENDHEX$$informaci$$HEX1$$f300$$ENDHEX$$n para la OC ' + String( al_orden_corte ) )
	Destroy lds_tipo_oc
	Return -1
Else
	ll_co_tipo = lds_tipo_oc.GetItemNumber(1,"co_tipo")
End If

// sw_origen = 'S' en h_canasta_corte cuando es bongo de corte por encima
ll_filas = lds_bongo.Of_Retrieve( al_orden_corte )
If ll_filas = 0 Then
	MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontraron bongo para la OC ' + String( al_orden_corte ) )
	Destroy lds_bongo
	Return -1
ElseIf ll_filas < 0 Then
	MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar los bongo para la OC ' + String( al_orden_corte ) + '~r~n' + lds_bongo.is_SQLErrText )
	Destroy lds_bongo
	Return -1
End If


lds_ruta_bongo = Create uo_dsbase
lds_ruta_bongo.DataObject = 'd_gr_ruta_corte_despues_preparacion'
lds_ruta_bongo.SetTransObject(  gnv_recursos.Of_Get_Transaccion_Sucia() )

ls_error = ''
ls_bongos_terceros = '' 
ls_bongos_gbi = ''

// Se recorreo los bongos de la Orden de Corte
For ll_row = 1 To lds_bongo.RowCount()
	ls_bongo = Trim( lds_bongo.GetItemString( ll_row, 'pallet_id' ) )
	// Se carga la informacion de la Ruta del Bongo
	ll_filas = lds_ruta_bongo.Of_Retrieve( ls_bongo )
	If ll_filas < 0 Then
		MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar la ruta del bongo ' + ls_bongo + '~r~n' + lds_bongo.is_SQLErrText )
		Destroy lds_bongo
		Destroy lds_ruta_bongo
		Return -1		
	ElseIf ll_filas = 0 Then 
		// ok
	ElseIf ll_filas > 0 Then	
		// Se toma el siguiente subcentro de la ruta
		li_co_centro_pdn = lds_ruta_bongo.GetItemNumber( 1, 'co_centro_pdn' )
		li_co_subcentro_pdn = lds_ruta_bongo.GetItemNumber( 1, 'co_subcentro_pdn' )
		
		ls_ubicacion = ''
		// Si el siguiente subcentro es Terceros se envia automaticamente a una ubicacion de Terceros
		If li_co_centro_pdn = 1 And li_co_subcentro_pdn = 29 Then
			lds_bongo.SetItem( ll_row, 'subcentro_ubica', 'TERCEROS' )
			ls_bongos_terceros += ls_bongo + ', ' 
		// Si el siguiente subcentro es GBI se envia automaticamente a una ubicacion de GBI
		ElseIf li_co_centro_pdn = 1 And li_co_subcentro_pdn = 50 Then
			lds_bongo.SetItem( ll_row, 'subcentro_ubica', 'GBI' )
			ls_bongos_gbi += ls_bongo + ', ' 
		End If
	End If
Next

// Si tiene bongos por ubicar automaticamente se pide confirmacion para ubicacion automatica
If ls_bongos_terceros <> '' Or ls_bongos_gbi <> '' Then
	ls_msn = 'Desea que el sistema ubique autom$$HEX1$$e100$$ENDHEX$$ticamente en el siguiente proceso:~r~n' 	
	If ls_bongos_terceros <> '' Then
		ls_msn += 'Terceros: ' + ls_bongos_terceros + '~r~n'
	End If
	
	If ls_bongos_gbi <> '' Then
		ls_msn += 'GBI: ' + ls_bongos_gbi
	End If
	li_resp = MessageBox( 'Ubicacion Automatica', ls_msn, Question!, YesNo! )
	If li_resp = 2 Then
		// FACL - 2020/08/12 - SA60974 - Control ubicacion automatica recipiente loteados
		s_base_parametros lstr_parametros		
		lstr_parametros.hay_parametros = true
		lstr_parametros.Cadena[1] = 'Ubicacion Automatica'
		lstr_parametros.Cadena[2] = ls_msn
		lstr_parametros.icono[1] = Question!
		lstr_parametros.boton[1] = YesNo!
		lstr_parametros.Entero[1] = 1 // boton por defecto - Si
		lstr_parametros.Boolean[1] = True // generar tecla aleatoria
		// Si es un Mensaje con icono de Error se saca la ventana pidiendo tecla aleatoria
		OpenWithParm( w_mensaje_error, lstr_parametros)		
		li_resp = Message.DoubleParm
		If li_resp = 2 Then
			Destroy lds_bongo
			Destroy lds_ruta_bongo
			Return 0
		End If
	End If
Else
	// no tiene bongos por ubicar
	Destroy lds_bongo
	Destroy lds_ruta_bongo
	Return 0
End If	
		
		
ls_bongos_terceros = '' 
ls_bongos_gbi = ''

// Se recorreo los bongos de la Orden de Corte
For ll_row = 1 To lds_bongo.RowCount()	
	ls_bongo = Trim( lds_bongo.GetItemString( ll_row, 'pallet_id' ) )
	ls_subcentro_ubica = Trim( lds_bongo.GetItemString( ll_row, 'subcentro_ubica' ) )
	If ls_subcentro_ubica <> '' Then
		ls_ubicacion = ''
		// Si el siguiente subcentro es Terceros se envia automaticamente a una ubicacion de Terceros
		If ls_subcentro_ubica = 'TERCEROS' Then
			//SA 61237 Confecci$$HEX1$$f300$$ENDHEX$$n Terceros
			If ll_co_tipo = 11 Then
				ls_ubicacion = ls_ubicacion_tercero_conf_terc
			Else
				If lds_bongo.GetItemString( ll_row, 'sw_origen' ) = 'S' Then
					ls_ubicacion = ls_ubicacion_tercero_congelada
				Else
					ls_ubicacion = ls_ubicacion_tercero
				End If
			End If
		// Si el siguiente subcentro es GBI se envia automaticamente a una ubicacion de GBI
		ElseIf ls_subcentro_ubica = 'GBI' Then
			//SA 61237 Confecci$$HEX1$$f300$$ENDHEX$$n Terceros
			If ll_co_tipo = 11 Then
				ls_ubicacion = ls_ubicacion_GBI_conf_terc
			Else 
				If lds_bongo.GetItemString( ll_row, 'sw_origen' ) = 'S' Then
					ls_ubicacion = ls_ubicacion_GBI_congelada
				Else
					ls_ubicacion = ls_ubicacion_GBI
				End If
			End If
		End If
		// si tiene ubicacion automatica
		If ls_ubicacion <> '' Then
			ls_msn = 'Desea que el sistema ubique autom$$HEX1$$e100$$ENDHEX$$ticamente el bongo en el siguiente proceso: '  + ls_msn
			
			// Se cambia la ubicacion co_programa:ULT - Ubicacion x Loteo
			DECLARE ubica_bongo_corte &
				PROCEDURE FOR pr_ubica_bongo_corte( :ls_bongo, :ls_ubicacion, 'ULT');
			EXECUTE ubica_bongo_corte;
			IF SQLCA.SQLCode = -1 THEN
				If ls_error <> '' Then ls_error += '~r~n'
				ls_error += 'Bongo ' + ls_bongo + ': ' + SQLCA.SQLErrText 
				ROLLBACK;
				CLOSE ubica_bongo_corte;
				//MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_ubica_bongo_corte. "+ ls_error)			
			Else
				CLOSE ubica_bongo_corte;
				COMMIT;
				If ls_subcentro_ubica = 'TERCEROS' Then
					ls_bongos_terceros += ls_bongo + ', ' 
				Else
					ls_bongos_gbi += ls_bongo + ', ' 
				End If				
			END IF
		End If
	End If
Next

IF ls_error <> '' Then
	Post MessageBox("Error Base Datos", "Fallo al ubicar automaticamente los bongos loteados:~r~n"+ ls_error)	
	/*
	uo_correo	lnv_correo
	lnv_correo = CREATE uo_correo
	
	TRY
		lnv_correo.of_enviar_correo('No ubico automaticamente los bongos loteados', ls_error, 'cambio_pdp_loteo', gstr_info_usuario.codigo_usuario )
	CATCH(Exception ex)
		Messagebox("Error", ex.getmessage())
	END TRY
	
	DESTROY lnv_correo
	*/
End If

// Se muestra de mensaje informando los bongos que fueron ubicados automaticamente
If ls_bongos_terceros <> '' Or ls_bongos_gbi <> '' Then
	If ls_bongos_terceros <> '' Then
		ls_msn = 'Bongos Ubicados en Terceros: ' + ls_bongos_terceros + '~r~n'
	End If
	
	If ls_bongos_gbi <> '' Then
		ls_msn += 'Bongos Ubicados en GBI: ' + ls_bongos_gbi
	End If
	Post MessageBox( 'Ubicacion Automatica', ls_msn, Information! )
End If


Destroy lds_bongo
Destroy lds_ruta_bongo

Return 1
end function

public function long of_validar_unid_lotear_vs_po_agrupa (long al_orden_corte, string as_po, long ai_fabrica, long ai_linea, long al_referencia, string as_bongo, ref datastore ads_unid_sobrantes_loteo);/*
	FACL - 2021/08/30 - ID530 - Se crea funcion para agrupacion basado en la funcion of_validar_unid_lotear_vs_po
		Validar las unidades loteadas de una po contra las unidades del pedido
			Cuando son superiores deben hacer partir el bongo

*/

Long	li_result, li_fila, li_result2, li_fila2, li_talla, li_result3, li_bongos, li_fila3, li_fabrica, li_result4, li_row, li_inserto, li_porc_mas_pedido
Long		ll_op_estilo, ll_pedido, ll_unid_pedido, ll_unid_loteo, ll_unid_loteando, ll_diferencia, ll_cliente, li_co_linea, &
			ll_co_referencia, ll_color_pt, ll_ca_pedida, ll_ca_pedida_comprar, ll_ca_tejido
Long ll_cs_agrupa_lib
Long ll_diferencia2, ll_rfind, ll_ca_loteando2, ll_ca_loteando_talla, ll_unid_toleracion = 3
String	 ls_de_estilo, ls_find
DataStore lds_cantidad_loteando_bongo
n_cts_constantes_corte lpo_const_corte


ll_unid_toleracion = lpo_const_corte.of_consultar_numerico('DIFERENCIA_LOTEO_ENCIMA')  
If ll_unid_toleracion < 0 Then
	Return -1
End If


lds_cantidad_loteando_bongo = Create DataStore  //para traer las unidades loteadas por po estilo -talla
lds_cantidad_loteando_bongo.DataObject = 'd_gr_validar_unidades_loteadas_agrupado'
lds_cantidad_loteando_bongo.SetTransObject(SQLCA)

li_inserto = 0
//traemos la orden de produccion y el color
li_result = lds_cantidad_loteando_bongo.Retrieve( al_orden_corte )
IF li_result =0 THEN
	MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$la orden de produccion y PO para validar las unidades')
	return -1
ElseIf li_result < 0 Then
	MessageBox('Advertencia','Ocurrio un error al consultar la orden de produccion y PO para validar las unidades')
	return -1
END IF

// Se ajusta la cantidad loteada por talla
For li_fila = 1 to lds_cantidad_loteando_bongo.RowCount()
	ll_color_pt  = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_color')
	li_talla 		= lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_talla')
	
	ll_unid_loteando = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'ca_loteando')

	ls_find = 'co_color = ' + String(ll_color_pt) + ' And co_talla = ' + String(li_talla)
	ll_rfind = lds_cantidad_loteando_bongo.Find( ls_find, 1, lds_cantidad_loteando_bongo.RowCount() )
	Do While ll_rfind > 0
		If ll_rfind <> li_fila Then
			ll_ca_loteando2 = lds_cantidad_loteando_bongo.GetItemNumber( ll_rfind, 'ca_loteando_talla' )			
			If ll_ca_loteando2 > 0 Then
				ll_ca_loteando2 -= ll_unid_loteando
				lds_cantidad_loteando_bongo.SetItem( ll_rfind, 'ca_loteando_talla',  ll_ca_loteando2 )
			End If				
		End If			
		ll_rfind = lds_cantidad_loteando_bongo.Find( ls_find, ll_rfind + 1, lds_cantidad_loteando_bongo.RowCount() + 1 )
	Loop
Next
lds_cantidad_loteando_bongo.Sort()
For li_fila = 1 to lds_cantidad_loteando_bongo.RowCount()
	ll_op_estilo = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'cs_ordenpd_pt')
	ll_pedido	 = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'pedido')
	ls_de_estilo = Trim(lds_cantidad_loteando_bongo.GetitemString(li_fila,'de_referencia'))
	li_fabrica = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_fabrica')
	li_co_linea = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_linea')
	ll_co_referencia = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_referencia')
	
	ll_color_pt  = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_color')
	li_talla 		= lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'co_talla')
		
	ll_ca_tejido = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'ca_tejido')
	
	ll_unid_pedido  = ll_ca_tejido

	ll_unid_loteando = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'ca_loteando')
	ll_ca_loteando_talla = lds_cantidad_loteando_bongo.GetitemNumber(li_fila,'ca_loteando_talla')
	
	ll_cs_agrupa_lib = lds_cantidad_loteando_bongo.GetitemNumber( li_fila, 'cs_agrupa_lib')

	IF ll_unid_loteando + ll_ca_loteando_talla = 0 THEN  //si en la oc que esta loteando no esta esa talla no se saca mensaje
		CONTINUE
	END IF
	
	If li_talla = 68 Then
		li_talla = li_talla
	End If
		
	ll_unid_loteo = lds_cantidad_loteando_bongo.GetItemNumber(li_fila,'ca_loteada')
	
	IF (ll_unid_loteo + ll_unid_loteando ) > ll_unid_pedido THEN   //comparamos las unidades
		//esta loteando mas de lo que se puede. debe partir el bongo se carga a tabla temporal 
		ll_diferencia = (ll_unid_loteo + ll_unid_loteando) - ll_unid_pedido
		// stvalenc 2020-01-06 soporte - Ajuste en el loteo
		IF ll_diferencia > ll_unid_loteando then
			ll_diferencia = ll_unid_loteando
		END IF
		
		ls_find = 'co_color = ' + String(ll_color_pt) + ' And co_talla = ' + String(li_talla) + ' and cs_agrupa_lib = ' + String( ll_cs_agrupa_lib )
		ll_rfind = lds_cantidad_loteando_bongo.Find( ls_find, 1, lds_cantidad_loteando_bongo.RowCount() )
		Do While ll_rfind > 0 And ll_diferencia > 0
			If ll_rfind <> li_fila Then
				ll_ca_loteando2 = lds_cantidad_loteando_bongo.GetItemNumber( ll_rfind, 'ca_loteando' )
				ll_diferencia2 = lds_cantidad_loteando_bongo.GetItemNumber( ll_rfind, 'ca_loteada' ) + ll_ca_loteando2 - lds_cantidad_loteando_bongo.GetItemNumber( ll_rfind, 'ca_tejido' )				
				If ll_diferencia2 < 0 Then
					ll_diferencia += ll_diferencia2
					
					If ll_ca_loteando2 > 0 Then
						If Abs(ll_diferencia2)> ll_ca_loteando2 Then
							ll_ca_loteando2 = 0 
						Else
							ll_ca_loteando2 += ll_diferencia2
						End If
						lds_cantidad_loteando_bongo.SetItem( ll_rfind, 'ca_loteando', ll_ca_loteando2 )
					End If
				End If				
			End If			
			ll_rfind = lds_cantidad_loteando_bongo.Find( ls_find, ll_rfind + 1, lds_cantidad_loteando_bongo.RowCount() + 1 )
		Loop
		
		If ll_diferencia - ll_unid_toleracion > 0 Then
			li_row = ads_unid_sobrantes_loteo.InsertRow(0)
			IF li_row > 0 THEN
				ads_unid_sobrantes_loteo.SetItem(li_row,'bongo',as_bongo )
				ads_unid_sobrantes_loteo.SetItem(li_row,'orden_corte',al_orden_corte )
				ads_unid_sobrantes_loteo.SetItem(li_row,'fabrica',li_fabrica )					
				ads_unid_sobrantes_loteo.SetItem(li_row,'linea',li_co_linea )
				ads_unid_sobrantes_loteo.SetItem(li_row,'estilo',ll_co_referencia)
				ads_unid_sobrantes_loteo.SetItem(li_row,'de_estilo',ls_de_estilo)
				ads_unid_sobrantes_loteo.SetItem(li_row,'color',ll_color_pt )
				ads_unid_sobrantes_loteo.SetItem(li_row,'talla',li_talla )
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_loteando',ll_unid_loteando )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_pedido',ll_unid_pedido )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_sobrantes',ll_diferencia )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'unid_loteadas',ll_unid_loteo )		
				ads_unid_sobrantes_loteo.SetItem(li_row,'op_estilo',ll_op_estilo )						
				li_inserto = 1
			END IF
		End If
	END IF
NEXT

Destroy lds_cantidad_loteando_bongo
	
IF li_inserto = 1 THEN  //inserto datos en el ds, se retorna 1 para abrir ventana mostrando a usuario lo sobrante
	Return 1
ELSE
	Return 0
END IF



end function

on n_cst_loteo_bongo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_loteo_bongo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

