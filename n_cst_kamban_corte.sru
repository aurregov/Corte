HA$PBExportHeader$n_cst_kamban_corte.sru
forward
global type n_cst_kamban_corte from nonvisualobject
end type
end forward

global type n_cst_kamban_corte from nonvisualobject autoinstantiate
end type

type variables

end variables

forward prototypes
public function long of_validar_despacho (long al_ordencorte)
public function long of_generar_kamban_corte (long ai_fabrica, long ai_linea, long al_referencia, long al_op, long al_oc)
end prototypes

public function long of_validar_despacho (long al_ordencorte);Long li_subcentro, li_tipo, li_centro
Long ll_count
String ls_error
n_cts_constantes lpo_constantes

lpo_constantes = Create n_cts_constantes
//se capturan las constantes necesarias
li_subcentro = lpo_constantes.of_consultar_numerico('SUBCENTRO FIN CORTE')

IF li_subcentro = -1 THEN
	Return -1
END IF

li_tipo = lpo_constantes.of_consultar_numerico('TIPO CORTE')

IF li_tipo = -1 THEN
	Return -1
END IF

li_centro = lpo_constantes.of_consultar_numerico('CENTRO CORTE')

IF li_centro = -1 THEN
	Return -1
END IF

SELECT count(*)
  INTO :ll_count
  FROM dt_kamban_corte
 WHERE cs_orden_corte 	= :al_ordencorte AND
       co_tipoprod 		= :li_tipo AND
		 co_centro_pdn 	= :li_centro AND
		 co_subcentro_pdn = :li_subcentro and
		 fe_final 			is not null;	

IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurrio un error al momento de determinar si la orden habia sido despachada. ' +ls_error)
	Return -1
END IF

IF ll_count > 0 THEN
	Return -1
ELSE
	Return 0
END IF
end function

public function long of_generar_kamban_corte (long ai_fabrica, long ai_linea, long al_referencia, long al_op, long al_oc);Long		li_cargado, li_cancelado, li_tipoenvio, li_confeccion, li_fabricadesp, li_plantadesp
Long		li_result1, li_result2, li_result3, li_result4, li_result5
Long		li_fila, li_caract, li_fabrica, li_linea, li_estado, li_inserta, li_centropdn, li_subcentro
Long		li_secuencia, li_cpto_paro, li_cpto_critica, li_fila2
LONG			ll_ordencorte, ll_ordenpdn, ll_referencia, ll_liquidada, ll_loteada, ll_despachadas
LONG			ll_programada, ll_color
STRING		ls_muestrario, ls_po, ls_de_linea, ls_de_referencia, ls_centropdn, ls_subcentro, ls_mesa
STRING		ls_usuario
DECIMAL{2}	ld_kg
DATETIME		ldt_creacion, ldt_iniciokam, ldt_iniprog, ldt_finprog, ldt_despacho, ldt_fe_actual

DataStore lds_kamban_corte_1, lds_kamban_corte_2, lds_kamban_corte_3, lds_kamban_corte_4, lds_kamban_corte_5
n_cts_constantes luo_cts_constantes



ls_usuario = gstr_info_usuario.codigo_usuario
ldt_fe_actual = datetime(today(),now())
luo_cts_constantes = Create n_cts_constantes

li_cargado = luo_cts_constantes.of_consultar_numerico("MERCADA ASIGNADA");
li_cancelado = luo_cts_constantes.of_consultar_numerico("ESTADO ANULADA");
li_tipoenvio = luo_cts_constantes.of_consultar_numerico("TIPO ENVIO PRENDAS");
li_confeccion = luo_cts_constantes.of_consultar_numerico("ENVIO CONFECCION");
li_fabricadesp = luo_cts_constantes.of_consultar_numerico("FABRICA PLANTA");
li_plantadesp = luo_cts_constantes.of_consultar_numerico("PLANTA LIBERACIONES");

lds_kamban_corte_1 = Create DataStore
lds_kamban_corte_2 = Create DataStore
lds_kamban_corte_3 = Create DataStore
lds_kamban_corte_4 = Create DataStore
lds_kamban_corte_5 = Create DataStore

lds_kamban_corte_1.DataObject = 'ds_unidades_kamban_corte_1'
lds_kamban_corte_2.DataObject = 'ds_unidades_kamban_corte_2'
lds_kamban_corte_3.DataObject = 'ds_unidades_kamban_corte_3'
lds_kamban_corte_4.DataObject = 'ds_unidades_kamban_corte_4'
lds_kamban_corte_5.DataObject = 'ds_unidades_kamban_corte_5'

lds_kamban_corte_1.SetTransObject(sqlca)
lds_kamban_corte_2.SetTransObject(sqlca)
lds_kamban_corte_3.SetTransObject(sqlca)
lds_kamban_corte_4.SetTransObject(sqlca)
lds_kamban_corte_5.SetTransObject(sqlca)

li_result1 = lds_kamban_corte_1.Retrieve(ai_fabrica,ai_linea,al_referencia,al_oc)
li_result3 = lds_kamban_corte_3.Retrieve(ai_fabrica,ai_linea,al_referencia,al_op,al_oc)
li_result4 = lds_kamban_corte_4.Retrieve(ai_fabrica,ai_linea,al_referencia,al_op,al_oc)
li_result5 = lds_kamban_corte_5.Retrieve(ai_fabrica,ai_linea,al_referencia,al_op,al_oc,li_cancelado)

FOR li_fila = 1 TO li_result1
	ll_ordencorte 		= lds_kamban_corte_1.GetItemNumber(li_fila,'cs_orden_corte') 
	li_fabrica 			= lds_kamban_corte_1.GetItemNumber(li_fila,'co_fabrica')
	li_linea 			= lds_kamban_corte_1.GetItemNumber(li_fila,'co_linea')
	ll_referencia 		= lds_kamban_corte_1.GetItemNumber(li_fila,'co_referencia') 
	ls_de_linea 		= lds_kamban_corte_1.GetItemString(li_fila,'de_linea')
	ls_de_referencia 	= lds_kamban_corte_1.GetItemString(li_fila,'de_referencia')
	li_centropdn 		= lds_kamban_corte_1.GetItemNumber(li_fila,'co_centro_pdn')
	li_subcentro 		= lds_kamban_corte_1.GetItemNumber(li_fila,'co_subcentro_pdn')
	ls_centropdn 		= lds_kamban_corte_1.GetItemString(li_fila,'de_centro_pdn')
	ls_subcentro		= lds_kamban_corte_1.GetItemString(li_fila,'de_subcentro_pdn')
	ldt_creacion 		= lds_kamban_corte_1.GetItemDateTime(li_fila,'fe_creacion')
	ldt_iniciokam 		= lds_kamban_corte_1.GetItemDateTime(li_fila,'fe_inicial')
	li_estado 			= lds_kamban_corte_1.GetItemNumber(li_fila,'co_estado')
	li_cpto_paro		= lds_kamban_corte_1.GetItemNumber(li_fila,'co_cpto_liq_ordcr')
	li_cpto_critica	= lds_kamban_corte_1.GetItemNumber(li_fila,'co_cpto_critica')
	li_secuencia		= lds_kamban_corte_1.GetItemNumber(li_fila,'cs_secuencia')
		
	li_result2 	= lds_kamban_corte_2.Retrieve(ai_fabrica,ai_linea,al_referencia,al_op,ll_ordencorte,li_cancelado)
	FOR li_fila2 = 1 TO li_result2
		ll_ordenpdn 	= lds_kamban_corte_2.GetItemNumber(li_fila2,'cs_ordenpd_pt')
		ls_po 			= lds_kamban_corte_2.GetItemString(li_fila2,'po')
		ls_mesa			= lds_kamban_corte_2.GetItemString(li_fila2,'de_modulo')
		ll_color 		= lds_kamban_corte_2.GetItemNumber(li_fila2,'co_color_pt')
		ll_programada	= lds_kamban_corte_2.GetItemNumber(li_fila2,'compute_0004')
		ldt_iniprog		= lds_kamban_corte_2.GetItemDateTime(li_fila2,'compute_0005')
		ldt_finprog		= lds_kamban_corte_2.GetItemDateTime(li_fila2,'compute_0006')	
		ldt_despacho	= lds_kamban_corte_2.GetItemDateTime(li_fila2,'compute_0007')	
		
		SELECT m_muestrarios.de_muestrario
		  INTO :ls_muestrario
		  FROM h_ordenpd_pt, m_muestrarios
		 WHERE h_ordenpd_pt.cs_ordenpd_pt = :ll_ordenpdn AND
				 h_ordenpd_pt.co_fabrica = m_muestrarios.co_fabrica AND
				 h_ordenpd_pt.co_linea = m_muestrarios.co_linea AND
				 h_ordenpd_pt.co_muestrario = m_muestrarios.co_muestrario;
				 
		SELECT DISTINCT co_caract
		  INTO :li_caract
		  FROM dt_pdnxmodulo, dt_telaxmodelo_lib
		 WHERE dt_pdnxmodulo.cs_asignacion = :ll_ordencorte AND
				 dt_pdnxmodulo.co_fabrica_pt = :li_fabrica AND
				 dt_pdnxmodulo.co_linea = :li_linea AND
				 dt_pdnxmodulo.co_referencia = :ll_referencia AND
				 dt_pdnxmodulo.po = :ls_po AND 
				 dt_pdnxmodulo.co_fabrica_exp = dt_telaxmodelo_lib.co_fabrica_exp AND
				 dt_pdnxmodulo.cs_liberacion = dt_telaxmodelo_lib.cs_liberacion AND
				 dt_pdnxmodulo.po = dt_telaxmodelo_lib.nu_orden AND
				 dt_pdnxmodulo.nu_cut = dt_telaxmodelo_lib.nu_cut AND
				 dt_pdnxmodulo.co_fabrica_pt = dt_telaxmodelo_lib.co_fabrica_pt AND
				 dt_pdnxmodulo.co_linea = dt_telaxmodelo_lib.co_linea AND
				 dt_pdnxmodulo.co_referencia = dt_telaxmodelo_lib.co_referencia AND
				 dt_pdnxmodulo.co_color_pt = dt_telaxmodelo_lib.co_color_pt AND
				 dt_pdnxmodulo.tono = dt_telaxmodelo_lib.co_tono AND
				 dt_telaxmodelo_lib.raya = 10;
				 
		SELECT Nvl(Sum(dt_liq_unixespacio.ca_liquidadas), 0)
		  INTO :ll_liquidada
		  FROM dt_liq_unixespacio, dt_liquidaxespacio, dt_agrupa_pdn, h_base_trazos
		 WHERE dt_liq_unixespacio.cs_orden_corte = :ll_ordencorte AND
				 dt_liq_unixespacio.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion AND
				 dt_liq_unixespacio.cs_pdn = dt_agrupa_pdn.cs_pdn AND
				 dt_agrupa_pdn.co_fabrica_pt = :li_fabrica AND
				 dt_agrupa_pdn.co_linea = :li_linea AND
				 dt_agrupa_pdn.co_referencia = :ll_referencia AND
				 dt_liq_unixespacio.cs_orden_corte = dt_liquidaxespacio.cs_orden_corte AND
				 dt_liq_unixespacio.cs_agrupacion = dt_liquidaxespacio.cs_agrupacion AND
				 dt_liq_unixespacio.cs_base_trazos = dt_liquidaxespacio.cs_base_trazos AND
				 dt_liq_unixespacio.cs_trazo = dt_liquidaxespacio.cs_trazo AND
				 dt_liq_unixespacio.cs_liquidacion = dt_liquidaxespacio.cs_liquidacion AND
				 dt_liquidaxespacio.co_estado in (5, 6) AND
				 dt_liq_unixespacio.cs_agrupacion = h_base_trazos.cs_agrupacion AND
				 dt_liq_unixespacio.cs_base_trazos = h_base_trazos.cs_base_trazos AND
				 h_base_trazos.raya = 10 AND
				 dt_agrupa_pdn.po = :ls_po; 
				 
		SELECT nvl(sum(ca_programada),0)
		  INTO :ll_loteada
		  FROM m_lotes_conf
		 WHERE cs_ordencorte = :ll_ordencorte AND
				 co_fabrica = :li_fabrica AND
				 co_linea = :li_linea AND
				 co_referencia = :ll_referencia AND
				 co_calidad = 1 AND
				 po = :ls_po; 
				 
		SELECT sum(ca_kg)
		  INTO :ld_kg
		  FROM h_mercada, dt_rollosmercada, m_rollo
		 WHERE dt_rollosmercada.cs_rollo = m_rollo.cs_rollo AND
				 h_mercada.cs_mercada = dt_rollosmercada.cs_mercada AND
				 h_mercada.cs_orden_corte = :ll_ordencorte AND
				 dt_rollosmercada.co_estado_mercada = :li_cargado ;
				 
		IF ll_loteada > 0 THEN
			IF ll_loteada < ll_liquidada THEN
				IF (ll_liquidada * 0.97) < ll_loteada THEN
					li_estado = 8;  
				ELSE
					li_estado = 7;
				END IF
			END IF
		END IF
	
		IF IsNull(li_estado)  THEN
			li_estado = 1;
		END IF
	
		ll_despachadas  = 0;
		 
		li_inserta = 0;
		IF li_estado = 7 THEN
			li_inserta = 1;
		ELSE
			IF li_subcentro = 3 OR li_subcentro = 5 THEN
				li_inserta = 1;
			END IF
		END IF
		IF li_subcentro = 7 AND  ll_loteada = 0 THEN
			li_estado = 7;
			li_inserta = 1;
		END IF
		 
		IF li_inserta = 1 THEN
			IF li_subcentro = 5 THEN
				ls_subcentro = 'EXTENDIDO';
			END IF
			IF li_subcentro = 7 THEN
				ls_subcentro = 'DESPACHO';
			END IF
			
			INSERT INTO  tmp_kamban_cte_po  
			VALUES(:ls_usuario, :ldt_fe_actual, :ll_ordencorte, :li_fabrica, :li_linea,
			       :ls_de_linea, :ll_referencia, :ls_de_referencia, 1, :li_centropdn,
					 :ls_centropdn, :li_subcentro, :ls_subcentro, :ldt_creacion, :ldt_iniciokam, 
					 :ll_color,	:ll_programada, :ll_liquidada, :ll_loteada, :ldt_iniprog, :ldt_finprog,
					 :ls_mesa, :li_secuencia, :ld_kg, :ll_ordenpdn, :li_caract, :ls_muestrario, '', 
				    :li_estado, :li_cpto_paro, :li_cpto_critica, :ldt_despacho, :ll_despachadas, :ls_po );

		END IF
		
	NEXT
	
NEXT

return 1
end function

on n_cst_kamban_corte.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_kamban_corte.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

