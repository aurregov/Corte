HA$PBExportHeader$w_loteo.srw
forward
global type w_loteo from w_base_maestrotb_detalletb
end type
type dw_encabezado from datawindow within w_loteo
end type
end forward

global type w_loteo from w_base_maestrotb_detalletb
integer x = 0
integer y = 0
integer width = 2917
integer height = 1500
string title = "Administraci$$HEX1$$f300$$ENDHEX$$n Loteo"
string menuname = "m_lotear"
event ue_loteo pbm_custom07
event ue_devolver pbm_custom08
dw_encabezado dw_encabezado
end type
global w_loteo w_loteo

type variables
Boolean ib_insercion
Long ii_evento
DataStore ids_escala,ids_agrupa,ids_libera

Long il_ordencorte,il_op,il_pedido,il_ref,il_colpt,il_ca_numerada,il_co_reftel,il_colte,il_ca_numeradaxtalla
Long ii_sec,ii_cs_loteo,ii_fab_exp,ii_lib,ii_fab_pt,ii_linea,ii_fab_tela,ii_diametro,ii_cant_sec_con_talla,ii_co_talla_loteo
Double idb_ancho,idb_ca_tela
String is_po,is_tono



Long il_pedido_po,il_cs_pdn


Transaction itr_tela


end variables

forward prototypes
public function boolean wf_verificar_rayas ()
public function long wf_act_unid_num_lib_102 ()
public function long wf_hallar_datos_lote (long an_op)
public function long wf_trae_tela ()
public function long wf_contar_secuencias ()
public function long wf_buscar_secuencia ()
public function long wf_act_escalas_lib (long an_ca_unidades)
public function long wf_upd_lib_estilos (long al_ca_unidades)
public function long wf_upd_talla_pdnmodulo (long al_ca_unidades)
public function long wf_upd_pdnmodulo (long al_ca_unidades)
end prototypes

event ue_loteo;Long ll_ordencorte,ll_fila,ll_agrupa,ll_pdn,ll_pedido,ll_libera,ll_ref,ll_color
Long li_lote,li_estado,li_pos_cortar,li_pos_inicial,li_fabrica,li_planta,li_fabexp,li_Fabpt,li_linea
Long li_tipocentropdn,li_estilo
String ls_po,ls_tono
s_base_parametros lstr_parametros_retro

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	li_lote = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_parcial")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_lote_con")
	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_destino")
	li_planta = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta_destino")
	li_tipocentropdn = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_version")
	
	
//	il_op			=ll_cs_ordenpd_pt
//	ii_sec		=ll_secuencia
	ii_cs_loteo	=li_lote
//	il_ca_numerada=ll_ca_numeradas
	
	ii_evento=1

	
	//script de actualizar escalas de numeracion en liberacion y 102
//	IF wf_act_unid_num_lib_102() =1 THEN										 
//	ELSE
//		MessageBox("Error Datos","No pudo traer enlace de tela para actualizar la escala")
//		ROLLBACK ;//USING itr_tela;
//		Close(w_retroalimentacion)
//		Return
//	END IF
	//verifico las escalas en dt_escalas_reales
	
	ids_escala.Retrieve(ll_ordencorte,li_lote)
	ids_escala.AcceptText()
	
	For ll_fila = 1 To ids_escala.RowCount()
		
		ll_agrupa = ids_escala.GetItemNumber(ll_fila,'cs_agrupacion')
		ll_pdn = ids_escala.GetItemNumber(ll_fila,'cs_pdn')
		
		ids_agrupa.Retrieve(ll_agrupa,ll_pdn)
		ids_agrupa.AcceptText()
		
		li_fabexp = ids_agrupa.GetItemNumber(1,'co_fabrica_exp')
		ll_pedido = ids_agrupa.GetItemNumber(1,'pedido')
		ll_libera = ids_agrupa.GetItemNumber(1,'cs_liberacion')
		ls_po		 = ids_agrupa.GetItemString(1,'po')
		li_fabpt  = ids_agrupa.GetItemNumber(1,'co_fabrica_pt')
		li_linea  = ids_agrupa.GetItemNumber(1,'co_linea')
		ll_ref    = ids_agrupa.GetItemNumber(1,'co_referencia')
		ll_color  = ids_agrupa.GetItemNumber(1,'co_color_pt')
		ls_tono   = ids_agrupa.GetItemString(1,'tono')
		li_estilo = ids_agrupa.GetItemNumber(1,'cs_estilocolortono')
		
		ids_libera.Retrieve(li_fabexp,ll_pedido,ll_libera,ls_po,li_fabpt,li_linea,ll_ref,ll_color,ls_tono,li_estilo)
			
		
	Next
	
		
	IF Not IsNull(ll_ordencorte) AND Not IsNull(li_lote) THEN
		IF li_estado = 1 THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion puede durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
		
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)			
			DECLARE loteo PROCEDURE FOR
				pr_lot_oc_nueva(:ll_ordencorte, :li_lote, :li_fabrica, :li_planta, :li_tipocentropdn, 1);
			EXECUTE loteo;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
//					li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
				ELSE
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
				END IF
				ROLLBACK;
			ELSE
				COMMIT;
			END IF
			This.TriggerEvent("ue_buscar")			
			CLOSE(w_retroalimentacion)
		ELSE
			MessageBox("Advertencia","El loteo debe estar en estado programado")
		END IF
	ELSE
		MessageBox("Advertencia","Debe seleccionar un lote para realizar el loteo")
	END IF
ELSE
	MessageBox("Advertencia","Debe seleccionar un lote para realizar el loteo")
END IF
end event

event ue_devolver;Long ll_ordencorte
Long li_lote, li_estado, li_pos_cortar, li_pos_inicial, li_fabrica, li_planta
Long li_tipocentropdn
s_base_parametros lstr_parametros_retro

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	li_lote = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_parcial")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_lote_con")
	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_destino")
	li_planta = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta_destino")
	li_tipocentropdn = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_version")
	
	//script de restar a escalas de numeracion de liberacion y 102
	il_ordencorte=ll_ordencorte
	ii_cs_loteo	=li_lote
//	il_ca_numerada=ll_ca_numeradas
	
	ii_evento=2

	
	//script de actualizar escalas de numeracion en liberacion y 102
//	IF wf_act_unid_num_lib_102() =1 THEN	
//	ELSE
//		MessageBox("Error Datos","No pudo actualizar escalas de numeracion")
//		ROLLBACK ;//USING itr_tela;
//		Close(w_retroalimentacion)
//		Return
//	END IF
	
	IF Not IsNull(ll_ordencorte) AND Not IsNull(li_lote) THEN
		IF li_estado = 8 THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
		
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)			
			DECLARE loteo PROCEDURE FOR
				pr_dev_lot_oc_new(:ll_ordencorte, :li_lote, :li_fabrica, :li_planta);
			EXECUTE loteo;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
//					li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
				ELSE
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
				END IF
				ROLLBACK;
			ELSE
				COMMIT;
			END IF
			This.TriggerEvent("ue_buscar")			
			CLOSE(w_retroalimentacion)
		ELSE
			MessageBox("Advertencia","El loteo debe estar loteado para poder devolver")
		END IF
	ELSE
		MessageBox("Advertencia","Debe seleccionar un lote para devolver")
	END IF
ELSE
	MessageBox("Advertencia","Debe seleccionar un lote para devolver")
END IF
end event

public function boolean wf_verificar_rayas ();Long ll_agrupacion, ll_base, ll_ordencorte
Long li_raya, li_registros

ll_ordencorte = dw_encabezado.GetItemNumber(1, "cs_orden_corte")

DECLARE rayas CURSOR FOR
SELECT DISTINCT h_base_trazos.cs_agrupacion, h_base_trazos.cs_base_trazos, h_base_trazos.raya
FROM dt_rayas_telaxoc, h_base_trazos
WHERE dt_rayas_telaxoc.cs_orden_corte = :ll_ordencorte AND
		dt_rayas_telaxoc.cs_agrupacion = h_base_trazos.cs_agrupacion AND
		dt_rayas_telaxoc.cs_base_trazos = h_base_trazos.cs_base_trazos;

OPEN rayas;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al abrir el cursor de verificaci$$HEX1$$f300$$ENDHEX$$n de liquidaci$$HEX1$$f300$$ENDHEX$$n")
	close rayas;
	Return False
END IF

FETCH rayas INTO :ll_agrupacion, :ll_base, :li_raya;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al leer el primer registro del cursor de verificaci$$HEX1$$f300$$ENDHEX$$n")
	close rayas;
	Return False
END IF
DO WHILE SQLCA.SQLCode = 0
	SELECT Count(*)
	INTO :li_registros
	FROM dt_rayas_telaxoc
	WHERE cs_orden_corte = :ll_ordencorte AND
			cs_agrupacion = :ll_agrupacion AND
			cs_base_trazos = :ll_base AND
			co_estado In (5, 6);
			
	IF li_registros = 0 THEN
		MessageBox("Advertencia...","No puede hacer loteo, la raya " + String(li_raya) + " no est$$HEX2$$e1002000$$ENDHEX$$liquidada")
		close rayas;
		Return False
	END IF
	
	FETCH rayas INTO :ll_agrupacion, :ll_base, :li_raya;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer registro del cursor de verificaci$$HEX1$$f300$$ENDHEX$$n")
		close rayas;
		Return False
	END IF	
LOOP
close rayas;
Return True
end function

public function long wf_act_unid_num_lib_102 ();LONG			ll_ca_numeradaxtalla,ll_ca_producidaxtalla,ll_ca_progxtalla,ll_entro_a_producidas
LONG			ll_ca_numeradaxactualizar,ll_ca_producida_a_actualizar
LONG			ll_ca_prog_a_actualizar

Long		li_correcto,li_co_talla,li_cant_sec_con_talla, li_secuencia_talla,li_entro_a_programada

li_correcto=1

//ciclo para buscar por producci$$HEX1$$f300$$ENDHEX$$n o sea por op

DECLARE cur_pdn CURSOR FOR  
  SELECT dt_escalas_reales.cs_pdn,   
         dt_libera_estilos.cs_ordenpd_pt,
			dt_libera_estilos.cs_estilocolortono,
			sum(dt_escalas_reales.ca_loteada)
    FROM dt_escalas_reales,   
         dt_agrupa_pdn,   
         dt_libera_estilos  
   WHERE ( dt_escalas_reales.cs_agrupacion 		= dt_agrupa_pdn.cs_agrupacion ) and  
         ( dt_escalas_reales.cs_pdn 				= dt_agrupa_pdn.cs_pdn ) and  
         ( dt_agrupa_pdn.co_fabrica_exp 			= dt_libera_estilos.co_fabrica_exp ) and  
         ( dt_agrupa_pdn.pedido 						= dt_libera_estilos.pedido ) and  
         ( dt_agrupa_pdn.cs_liberacion 			= dt_libera_estilos.cs_liberacion ) and  
         ( dt_agrupa_pdn.po 							= dt_libera_estilos.nu_orden ) and  
         ( dt_agrupa_pdn.co_fabrica_pt 			= dt_libera_estilos.co_fabrica ) and  
         ( dt_agrupa_pdn.co_linea 					= dt_libera_estilos.co_linea ) and  
         ( dt_agrupa_pdn.co_referencia 			= dt_libera_estilos.co_referencia ) and  
         ( dt_agrupa_pdn.co_color_pt 				= dt_libera_estilos.co_color_pt ) and  
         ( dt_agrupa_pdn.tono 						= dt_libera_estilos.tono ) and  
         ( dt_agrupa_pdn.cs_estilocolortono 		= dt_libera_estilos.cs_estilocolortono ) and  
         ( ( dt_escalas_reales.cs_orden_corte 	= :il_ordencorte ) AND  
         ( dt_escalas_reales.cs_parcial 			= :ii_cs_loteo ) )   
group by 1,2,3
order by 1,2,3;

open cur_pdn;

if sqlca.sqlcode=-1 then

	MessageBox("Error base Datos","No pudo abrir busqueda por producci$$HEX1$$f300$$ENDHEX$$n")
	li_correcto=0
	RETURN li_correcto
else
end if

fetch cur_pdn into :il_cs_pdn,:il_op,:ii_sec,:il_ca_numerada;

do while sqlca.sqlcode =0
	
	
	IF wf_hallar_datos_lote(il_op) =1 THEN										 
	ELSE
		MessageBox("Error Datos","No pudo traer datos del estilo lote")
		li_correcto=0
		RETURN li_correcto
	END IF
	
	
	//busqueda de unidades por talla en la tabla de num, esto es x oc y cs_loteo
	
	//ciclo sobre dt_lote_confe trayendo talla y unidades para actualizar escalas de liberacion
	DECLARE cur_tallas_lote CURSOR FOR
	  SELECT dt_escalas_reales.co_talla,   
				Sum(dt_escalas_reales.ca_loteada)
		 FROM dt_escalas_reales  
		WHERE ( dt_escalas_reales.cs_orden_corte = :il_ordencorte ) AND  
				( dt_escalas_reales.cs_parcial = :ii_cs_loteo )   
	GROUP BY dt_escalas_reales.co_talla  			
	ORDER BY dt_escalas_reales.co_talla ASC  ;
	//USING itr_tela;
	
	IF sqlca.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al armar la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
		li_correcto=0
		RETURN li_correcto
	ELSE
	END IF
	
	OPEN cur_tallas_lote;
	IF sqlca.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al abrir la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
		li_correcto=0
		RETURN li_correcto
	ELSE
	END IF
	
	FETCH cur_tallas_lote INTO :ii_co_talla_loteo,:ll_ca_numeradaxtalla;  
	IF sqlca.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al traer datos en la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
		li_correcto=0
		RETURN li_correcto
	ELSE
	END IF
		
	
	DO WHILE sqlca.SQLCODE =0 
		
		IF ii_evento=1 THEN
		ELSE
			ll_ca_numeradaxtalla=ll_ca_numeradaxtalla * -1
		END IF
		
		IF wf_trae_tela() =1 THEN
		ELSE
			//MessageBox("Error Datos","No pudo traer enlace de tela para la escala")
			//li_correcto=0
			RETURN li_correcto
		END IF
		
		IF wf_contar_secuencias() =1 THEN
		ELSE
			MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
			li_correcto=0
			RETURN li_correcto
		END IF
			
		IF ISNULL(ii_cant_sec_con_talla)  THEN //OR ii_cant_sec_con_talla=0 THEN
			MessageBox("Error Datos","Error al traer datos en la busqueda de tallas en las diferentes secuencias" + sqlca.SQLErrText)
			li_correcto=0
			RETURN li_correcto
		ELSE
		END IF
		
		IF ii_cant_sec_con_talla =1 THEN
			
			IF wf_buscar_secuencia() =1 THEN
			ELSE
				MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
				li_correcto=0
				RETURN li_correcto
			END IF
			
			IF wf_act_escalas_lib(ll_ca_numeradaxtalla) =1 THEN
			ELSE
				MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
				li_correcto=0
				RETURN li_correcto
			END IF
			
			//update dt_libera_estilos
			IF wf_upd_lib_estilos(ll_ca_numeradaxtalla) =1 THEN
			ELSE
				MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
				li_correcto=0
				RETURN li_correcto
			END IF
			
			//update dt_talla_pdnmodulo
			IF wf_upd_talla_pdnmodulo(ll_ca_numeradaxtalla) =1 THEN
			ELSE
				MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
				li_correcto=0
				RETURN li_correcto
			END IF
					
			//update dt_pdnmodulo
			IF wf_upd_pdnmodulo(ll_ca_numeradaxtalla) =1 THEN
			ELSE
				MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
				li_correcto=0
				RETURN li_correcto
			END IF
			
			
		ELSE
			//la talla tiene varias secuencias
			DECLARE cur_buscar_sec CURSOR FOR
			SELECT dt_talla_pdnmodulo.cs_estilocolortono,ca_producida
			FROM dt_talla_pdnmodulo  
			WHERE ( dt_talla_pdnmodulo.simulacion 			= 1 ) AND  
					( dt_talla_pdnmodulo.co_fabrica_exp 	= :ii_fab_exp ) AND  
					( dt_talla_pdnmodulo.pedido 				= :il_pedido ) AND  
					( dt_talla_pdnmodulo.cs_liberacion 		= :ii_lib ) AND  
					( dt_talla_pdnmodulo.po 					= :is_po ) AND  
					( dt_talla_pdnmodulo.co_fabrica_pt 		= :ii_fab_pt ) AND  
					( dt_talla_pdnmodulo.co_linea 			= :ii_linea ) AND  
					( dt_talla_pdnmodulo.co_referencia 		= :il_ref ) AND  
					( dt_talla_pdnmodulo.co_color_pt 		= :il_colpt ) AND  
					( dt_talla_pdnmodulo.tono 					= :is_tono ) AND  
					( dt_talla_pdnmodulo.co_talla				= :ii_co_talla_loteo ) AND
					( dt_talla_pdnmodulo.ca_producida 		> 0 ) 
			ORDER BY 1;
			//USING itr_tela;
			
			IF sqlca.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al declarar la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
				li_correcto=0
				RETURN li_correcto
			ELSE
			END IF
			
			OPEN cur_buscar_sec;
			
			IF sqlca.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al abrir la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
				li_correcto=0
				RETURN li_correcto
			ELSE
			END IF
			
			FETCH cur_buscar_sec INTO   :ii_sec,:ll_ca_producidaxtalla;
			IF sqlca.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al traer datos en la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
				li_correcto=0
				RETURN li_correcto
			ELSE
			END IF
			
			ll_entro_a_producidas=0
			
			ll_ca_numeradaxactualizar=ll_ca_numeradaxtalla
			
			DO WHILE (sqlca.SQLCODE=0 AND ll_ca_numeradaxactualizar > 0)
				
				ll_entro_a_producidas=1
							
				//define unidades a actualizar
				IF ll_ca_producidaxtalla >= ll_ca_numeradaxtalla THEN
					ll_ca_numeradaxactualizar		=0
					ll_ca_producida_a_actualizar	=ll_ca_numeradaxtalla
				ELSE
					ll_ca_numeradaxactualizar		=ll_ca_numeradaxactualizar - ll_ca_producidaxtalla
					ll_ca_producida_a_actualizar	=ll_ca_producidaxtalla
				END IF
				
				//upd_talla_pdnmodulo
				IF wf_upd_talla_pdnmodulo(ll_ca_producida_a_actualizar) =1 THEN
				ELSE
					MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
					li_correcto=0
					RETURN li_correcto
				END IF
				//upd_dt_pdn_modulo
				IF wf_upd_pdnmodulo(ll_ca_producida_a_actualizar) =1 THEN
				ELSE
					MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
					li_correcto=0
					RETURN li_correcto
				END IF
				//upd_dt_escalasxtela
				IF wf_act_escalas_lib(ll_ca_producida_a_actualizar) =1 THEN
				ELSE
					MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
					li_correcto=0
					RETURN li_correcto
				END IF
				//upd_dt_libera_estilo
				IF wf_upd_lib_estilos(ll_ca_producida_a_actualizar) =1 THEN
				ELSE
					MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
					li_correcto=0
					RETURN li_correcto
				END IF
				
				
				FETCH cur_buscar_sec INTO   :ii_sec,:ll_ca_producidaxtalla;
				
				IF sqlca.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al traer datos en la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
					li_correcto=0
					RETURN li_correcto
				ELSE
				END IF
				
			LOOP
			
			CLOSE cur_buscar_sec;
			IF sqlca.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al Cerrar la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
				li_correcto=0
				RETURN li_correcto
			ELSE
			END IF
				
			DO WHILE ll_ca_numeradaxactualizar > 0
				
				//ciclo en orden de sec buscando la cantidad programada
				DECLARE cur_busca_sec CURSOR FOR
				SELECT dt_talla_pdnmodulo.cs_estilocolortono,ca_programada
				FROM dt_talla_pdnmodulo  
				WHERE ( dt_talla_pdnmodulo.simulacion 			= 1 ) AND  
						( dt_talla_pdnmodulo.co_fabrica_exp 	= :ii_fab_exp ) AND  
						( dt_talla_pdnmodulo.pedido 				= :il_pedido ) AND  
						( dt_talla_pdnmodulo.cs_liberacion 		= :ii_lib ) AND  
						( dt_talla_pdnmodulo.po 					= :is_po ) AND  
						( dt_talla_pdnmodulo.co_fabrica_pt 		= :ii_fab_pt ) AND  
						( dt_talla_pdnmodulo.co_linea 			= :ii_linea ) AND  
						( dt_talla_pdnmodulo.co_referencia 		= :il_ref ) AND  
						( dt_talla_pdnmodulo.co_color_pt 		= :il_colpt ) AND  
						( dt_talla_pdnmodulo.tono 					= :is_tono )  AND
						( dt_talla_pdnmodulo.co_talla				= :ii_co_talla_loteo ) 
				ORDER BY 1;
				//USING itr_tela;
				
				IF sqlca.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al declarar la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
					li_correcto=0
					RETURN li_correcto
				ELSE
				END IF
				
				OPEN cur_busca_sec;
				
				IF sqlca.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al abrir la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
					li_correcto=0
					RETURN li_correcto
				ELSE
				END IF
				
				li_entro_a_programada=0
				
				FETCH cur_busca_sec INTO   :ii_sec,:ll_ca_progxtalla;
				IF sqlca.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al traer datos en la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
					li_correcto=0
					RETURN li_correcto
				ELSE
				END IF
				
				DO WHILE (sqlca.SQLCODE=0 AND ll_ca_numeradaxactualizar > 0)
					
					li_entro_a_programada=1
					
					//define unidades a actualizar
					IF ll_ca_progxtalla >= ll_ca_numeradaxactualizar THEN	
						ll_ca_prog_a_actualizar		=ll_ca_numeradaxactualizar
						ll_ca_numeradaxactualizar	=0
					ELSE
						ll_ca_prog_a_actualizar		=ll_ca_progxtalla
						ll_ca_numeradaxactualizar	=ll_ca_numeradaxactualizar - ll_ca_progxtalla
					END IF
									
					//upd_talla_pdnmodulo
					IF wf_upd_talla_pdnmodulo(ll_ca_prog_a_actualizar) =1 THEN
					ELSE
						MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
						li_correcto=0
						RETURN li_correcto
					END IF
					//upd_dt_pdn_modulo
					IF wf_upd_pdnmodulo(ll_ca_prog_a_actualizar) =1 THEN
					ELSE
						MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
						li_correcto=0
						RETURN li_correcto
					END IF
					//upd_dt_escalasxtela
					IF wf_act_escalas_lib(ll_ca_prog_a_actualizar) =1 THEN
					ELSE
						MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
						li_correcto=0
						RETURN li_correcto
					END IF
					//upd_dt_libera_estilo
					IF wf_upd_lib_estilos(ll_ca_prog_a_actualizar) =1 THEN
					ELSE
						MessageBox("Error Datos","No pudo buscar las secuencias asociadas")
						li_correcto=0
						RETURN li_correcto
					END IF
					
					
					FETCH cur_busca_sec INTO   :ii_sec,:ll_ca_progxtalla;
					
					IF sqlca.SQLCode = -1 THEN
						MessageBox("Error Base Datos","Error al traer datos en la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
						li_correcto=0
						RETURN li_correcto
					ELSE
					END IF
					
				LOOP
				
				CLOSE cur_busca_sec;
				IF sqlca.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al traer datos en la busqueda de secuencias con cant.producida" + sqlca.SQLErrText)
					li_correcto=0
					RETURN li_correcto
				ELSE
				END IF
				
				IF li_entro_a_programada=0 THEN
					//NO ENTRO
					//Debe hacer ciclo sobre la liberaci$$HEX1$$f300$$ENDHEX$$n para actualizarle la escala de numeraci$$HEX1$$f300$$ENDHEX$$n
					ll_ca_numeradaxactualizar=0
				ELSE 
				END IF
				
			LOOP
			
			IF ll_ca_numeradaxactualizar > 0 THEN
				MessageBox("Error Datos","Sobran unidades numeradas por actualizar" + sqlca.SQLErrText)
				li_correcto=0
				RETURN li_correcto			
			ELSE 
			END IF
	
		END IF
		
		
		FETCH cur_tallas_lote INTO :ii_co_talla_loteo,:ll_ca_numeradaxtalla;
		IF sqlca.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al traer datos en la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
			li_correcto=0
			RETURN li_correcto
		ELSE
		END IF
		
	LOOP
	
	CLOSE cur_tallas_lote;
	IF sqlca.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al cerrar la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
		li_correcto=0
		RETURN li_correcto
	ELSE
		
	END IF
	
	fetch cur_pdn into :il_cs_pdn,:il_op,:ii_sec,:il_ca_numerada;


loop

close cur_pdn;
if sqlca.sqlcode=-1 then

	MessageBox("Error base Datos","No pudo cerrar busqueda por producci$$HEX1$$f300$$ENDHEX$$n")
	li_correcto=0
	RETURN li_correcto
else
end if


RETURN li_correcto



end function

public function long wf_hallar_datos_lote (long an_op);Long 	li_correcto


li_correcto=1

SELECT 	UNIQUE dt_libera_estilos.co_fabrica_exp,   
			dt_libera_estilos.pedido, 
			dt_libera_estilos.pedido_po,
			dt_libera_estilos.cs_liberacion,   
			dt_libera_estilos.nu_orden,   
			dt_libera_estilos.co_fabrica,   
			dt_libera_estilos.co_linea,   
			dt_libera_estilos.co_referencia,   
			dt_libera_estilos.co_color_pt,   
			dt_libera_estilos.tono  
	 INTO :ii_fab_exp,   
			:il_pedido, 
			:il_pedido_po,
			:ii_lib,   
			:is_po,   
			:ii_fab_pt,   
			:ii_linea,   
			:il_ref,   
			:il_colpt,   
			:is_tono  
	 FROM dt_libera_estilos  
	WHERE ( dt_libera_estilos.co_fabrica_exp 			> 0 ) AND  
			( dt_libera_estilos.cs_ordenpd_pt 			= :il_op );   
//USING itr_tela;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al traer datos de liberaci$$HEX1$$f300$$ENDHEX$$n para actualizarla" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto
end function

public function long wf_trae_tela ();Long		li_correcto

li_correcto=1

//ciclo para traer de dt_telaxmodelo_lib las raya 10, order by yardas
DECLARE cur_telas CURSOR FOR
  SELECT UNIQUE dt_telaxmodelo_lib.co_fabrica_tela,   
         dt_telaxmodelo_lib.co_reftel,   
         dt_telaxmodelo_lib.diametro,   
         dt_telaxmodelo_lib.co_color_tela,   
         dt_telaxmodelo_lib.ancho_cortable,
			dt_telaxmodelo_lib.ca_tela
    FROM dt_telaxmodelo_lib  
   WHERE ( dt_telaxmodelo_lib.co_fabrica_exp 		= :ii_fab_exp ) AND  
         ( dt_telaxmodelo_lib.pedido 					= :il_pedido ) AND  
         ( dt_telaxmodelo_lib.cs_liberacion 			= :ii_lib ) AND  
         ( dt_telaxmodelo_lib.nu_orden 				= :is_po ) AND  
         ( dt_telaxmodelo_lib.co_fabrica_pt 			= :ii_fab_pt ) AND  
         ( dt_telaxmodelo_lib.co_linea 				= :ii_linea ) AND  
         ( dt_telaxmodelo_lib.co_referencia 			= :il_ref ) AND  
         ( dt_telaxmodelo_lib.co_color_pt 			= :il_colpt ) AND  
         ( dt_telaxmodelo_lib.tono 						= :is_tono ) AND  
         //( dt_telaxmodelo_lib.cs_estilocolortono 	= :ii_sec ) AND  
         ( dt_telaxmodelo_lib.raya 						= 10 )   
ORDER BY dt_telaxmodelo_lib.ca_tela DESC;
//USING itr_tela;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al armar la busqueda de telas para la escala de liberacion" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF
			
OPEN cur_telas ;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al abrir la busqueda de telas para la escala de liberacion" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

FETCH cur_telas 	INTO :ii_fab_tela,:il_co_reftel,:ii_diametro,:il_colte,:idb_ancho,:idb_ca_tela;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al traer datos en la busqueda de telas para la escala de liberacion" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF			


//DO WHILE itr_tela.SQLCODE=0
//	
//	itr_tela.SQLCODE=-1
//	
//	
//	FETCH cur_telas INTO :ii_fab_tela,:il_co_reftel,:ii_diametro,&
//							:il_colte,:idb_ancho,:idb_ca_tela;
//			
//	IF itr_tela.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","Error al traer datos en la busqueda de telas para la escala de liberacion" + itr_tela.SQLErrText)
//		li_correcto=0
//		RETURN li_correcto
//	ELSE
//	END IF
//	
//LOOP

CLOSE cur_telas ;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al cerrar la busqueda de telas para la escala de liberacion" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN	li_correcto
end function

public function long wf_contar_secuencias ();Long li_correcto

li_correcto=1

SELECT COUNT(*)
INTO   :ii_cant_sec_con_talla
FROM dt_escalasxtela  
  //SET ca_numerada = ca_numerada + :ll_ca_numeradaxtalla  
WHERE ( dt_escalasxtela.co_fabrica_exp 	= :ii_fab_exp ) AND  
		( dt_escalasxtela.pedido 				= :il_pedido ) AND  
		( dt_escalasxtela.cs_liberacion 		= :ii_lib ) AND  
		( dt_escalasxtela.nu_orden 			= :is_po ) AND  
		( dt_escalasxtela.co_fabrica_pt 		= :ii_fab_pt ) AND  
		( dt_escalasxtela.co_linea 			= :ii_linea ) AND  
		( dt_escalasxtela.co_referencia 		= :il_ref ) AND  
		( dt_escalasxtela.co_color_pt 		= :il_colpt ) AND  
		( dt_escalasxtela.tono 					= :is_tono ) AND  
		//( dt_escalasxtela.cs_estilocolortono= :ii_sec ) AND  
		( dt_escalasxtela.co_fabrica_tela 	= :ii_fab_tela ) AND  
		( dt_escalasxtela.co_reftel 			= :il_co_reftel ) AND  
		( dt_escalasxtela.diametro 			= :ii_diametro ) AND  
		( dt_escalasxtela.co_color_tela 		= :il_colte ) AND  
		( dt_escalasxtela.co_talla 			= :ii_co_talla_loteo ) and
		( 
		 (dt_Escalasxtela.cs_estilocolortono = 1 and dt_escalasxtela.sw_partida = 0)
		 or dt_Escalasxtela.cs_estilocolortono > 1
		);
		
		
//USING itr_tela;

IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al traer datos en la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto
end function

public function long wf_buscar_secuencia ();Long	li_correcto

li_correcto=1

SELECT dt_escalasxtela.cs_estilocolortono
INTO   :ii_sec
FROM dt_escalasxtela  
WHERE ( dt_escalasxtela.co_fabrica_exp 	= :ii_fab_exp ) AND  
		( dt_escalasxtela.pedido 				= :il_pedido ) AND  
		( dt_escalasxtela.cs_liberacion 		= :ii_lib ) AND  
		( dt_escalasxtela.nu_orden 			= :is_po ) AND  
		( dt_escalasxtela.co_fabrica_pt 		= :ii_fab_pt ) AND  
		( dt_escalasxtela.co_linea 			= :ii_linea ) AND  
		( dt_escalasxtela.co_referencia 		= :il_ref ) AND  
		( dt_escalasxtela.co_color_pt 		= :il_colpt ) AND  
		( dt_escalasxtela.tono 					= :is_tono ) AND  
		//( dt_escalasxtela.cs_estilocolortono= :ii_sec ) AND  
		( dt_escalasxtela.co_fabrica_tela 	= :ii_fab_tela ) AND  
		( dt_escalasxtela.co_reftel 			= :il_co_reftel ) AND  
		( dt_escalasxtela.diametro 			= :ii_diametro ) AND  
		( dt_escalasxtela.co_color_tela 		= :il_colte ) AND  
		( dt_escalasxtela.co_talla 			= :ii_co_talla_loteo )  and
		( (dt_escalasxtela.cs_estilocolortono=1 and dt_escalasxtela.sw_partida=0) OR
			(dt_escalasxtela.cs_estilocolortono>1) )	;
//USING itr_tela;

IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al traer datos en la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto
end function

public function long wf_act_escalas_lib (long an_ca_unidades);Long	li_correcto

li_correcto=1

UPDATE dt_escalasxtela  
  SET ca_numerada = ca_numerada + :an_ca_unidades  
WHERE ( dt_escalasxtela.co_fabrica_exp 	= :ii_fab_exp ) AND  
		( dt_escalasxtela.pedido 				= :il_pedido ) AND  
		( dt_escalasxtela.cs_liberacion 		= :ii_lib ) AND  
		( dt_escalasxtela.nu_orden 			= :is_po ) AND  
		( dt_escalasxtela.co_fabrica_pt 		= :ii_fab_pt ) AND  
		( dt_escalasxtela.co_linea 			= :ii_linea ) AND  
		( dt_escalasxtela.co_referencia 		= :il_ref ) AND  
		( dt_escalasxtela.co_color_pt 		= :il_colpt ) AND  
		( dt_escalasxtela.tono 					= :is_tono ) AND  
		( dt_escalasxtela.cs_estilocolortono= :ii_sec ) AND  
		( dt_escalasxtela.co_fabrica_tela 	= :ii_fab_tela ) AND  
		( dt_escalasxtela.co_reftel 			= :il_co_reftel ) AND  
		( dt_escalasxtela.diametro 			= :ii_diametro ) AND 
		( dt_escalasxtela.co_caract			= 99) AND
		( dt_escalasxtela.co_color_tela 		= :il_colte ) AND  
		( dt_escalasxtela.co_talla 			= :ii_co_talla_loteo ); 
		//USING itr_tela;
		  
		UPDATE pedpend_exp  
					  SET ca_confecc = ca_confecc + :an_ca_unidades  
					WHERE ( pedpend_exp.pedido 			= :il_pedido_po ) AND  
							( pedpend_exp.nu_orden 			= :is_po ) 			AND  
							( pedpend_exp.co_fabrica 		= :ii_fab_pt ) 	AND  
							( pedpend_exp.co_linea 			= :ii_linea ) 		AND  
							( pedpend_exp.co_referencia 	= :il_ref ) 	   AND  
							( pedpend_exp.co_color 			= :il_colpt )     AND
							( pedpend_exp.co_talla 			= :ii_co_talla_loteo ) 	;	
		
		
//USING itr_tela;

IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al traer datos en la busqueda de tallas en la escala de unidades numeradas" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto

end function

public function long wf_upd_lib_estilos (long al_ca_unidades);Long li_correcto

li_correcto=1

UPDATE dt_libera_estilos  
  SET ca_numerada = ca_numerada + :al_ca_unidades  
WHERE ( dt_libera_estilos.co_fabrica_exp 		= :ii_fab_exp ) AND  
		( dt_libera_estilos.pedido 				= :il_pedido ) AND  
		( dt_libera_estilos.cs_liberacion 		= :ii_lib ) AND  
		( dt_libera_estilos.nu_orden 				= :is_po ) AND  
		( dt_libera_estilos.co_fabrica 			= :ii_fab_pt ) AND  
		( dt_libera_estilos.co_linea 				= :ii_linea ) AND  
		( dt_libera_estilos.co_referencia 		= :il_ref ) AND  
		( dt_libera_estilos.co_color_pt 			= :il_colpt ) AND  
		( dt_libera_estilos.tono 					= :is_tono ) AND  
		( dt_libera_estilos.cs_estilocolortono	= :ii_sec ) ;  
//USING itr_tela;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar el estilo en la liberaci$$HEX1$$f300$$ENDHEX$$n" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto





end function

public function long wf_upd_talla_pdnmodulo (long al_ca_unidades);Long	li_correcto

li_correcto=1

UPDATE dt_talla_pdnmodulo  
  SET ca_numerada = ca_numerada + :al_ca_unidades  
WHERE ( dt_talla_pdnmodulo.simulacion 			= 1 ) AND  
		( dt_talla_pdnmodulo.co_fabrica_exp 	= :ii_fab_exp ) AND  
		( dt_talla_pdnmodulo.pedido 				= :il_pedido ) AND  
		( dt_talla_pdnmodulo.cs_liberacion 		= :ii_lib ) AND  
		( dt_talla_pdnmodulo.po 					= :is_po ) AND  
		( dt_talla_pdnmodulo.co_fabrica_pt 		= :ii_fab_pt ) AND  
		( dt_talla_pdnmodulo.co_linea 			= :ii_linea ) AND  
		( dt_talla_pdnmodulo.co_referencia 		= :il_ref ) AND  
		( dt_talla_pdnmodulo.co_color_pt 		= :il_colpt ) AND  
		( dt_talla_pdnmodulo.tono 					= :is_tono ) AND  
		( dt_talla_pdnmodulo.cs_estilocolortono= :ii_sec ) AND  
		( dt_talla_pdnmodulo.cs_particion 		= 1 ) AND
		( dt_talla_pdnmodulo.co_talla 			= :ii_co_talla_loteo ) ;  
//USING itr_tela;

IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar en tallas en la escala de 102" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto



end function

public function long wf_upd_pdnmodulo (long al_ca_unidades);Long	li_correcto

li_correcto=1

UPDATE dt_pdnxmodulo  
  SET ca_numerada = ca_numerada + :al_ca_unidades  
WHERE ( dt_pdnxmodulo.simulacion 			= 1 ) AND  
		( dt_pdnxmodulo.co_fabrica_exp 		= :ii_fab_exp ) AND  
		( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
		( dt_pdnxmodulo.cs_liberacion 		= :ii_lib ) AND  
		( dt_pdnxmodulo.po 						= :is_po ) AND  
		( dt_pdnxmodulo.co_fabrica_pt 		= :ii_fab_pt ) AND  
		( dt_pdnxmodulo.co_linea 				= :ii_linea ) AND  
		( dt_pdnxmodulo.co_referencia 		= :il_ref ) AND  
		( dt_pdnxmodulo.co_color_pt 			= :il_colpt ) AND  
		( dt_pdnxmodulo.tono 					= :is_tono ) AND  
		( dt_pdnxmodulo.cs_estilocolortono 	= :ii_sec ) AND  
		( dt_pdnxmodulo.cs_particion 			= 1 );   
//USING itr_tela;
IF sqlca.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar el estilo en la 102" + sqlca.SQLErrText)
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

RETURN li_correcto





end function

on w_loteo.create
int iCurrent
call super::create
if this.MenuName = "m_lotear" then this.MenuID = create m_lotear
this.dw_encabezado=create dw_encabezado
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_encabezado
end on

on w_loteo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_encabezado)
end on

event ue_buscar;s_base_parametros lstr_parametros_retro
Long ll_orden_corte, ll_hallados

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios  en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	lstr_parametros_retro.cadena[1]="Cargando datos ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
	ll_orden_corte = Long(sle_argumento.Text)
	IF ll_orden_corte > 0 THEN
		ll_hallados = dw_encabezado.Retrieve(ll_orden_corte)
		IF ll_hallados > 0 THEN
			CHOOSE CASE dw_maestro.Retrieve(ll_orden_corte)
				CASE -1
					Close(w_retroalimentacion)
					MessageBox("Error datawindow","No se pudo cargar datos", &
									Exclamation!,Ok!)
					 
					istr_parametros_error.cadena[1]=sqlca.dbms
					istr_parametros_error.entero[1]=sqlca.sqlcode
					istr_parametros_error.cadena[2]=this.classname()
					istr_parametros_error.cadena[3]="modified"
					istr_parametros_error.cadena[4]=""
					OpenWithParm(w_reporte_errores,istr_parametros_error)
					Close(This)
				CASE 0
					Close(w_retroalimentacion)
				CASE ELSE
					Close(w_retroalimentacion)
					il_fila_actual_maestro = 1
					dw_maestro.SetRow(il_fila_actual_maestro)
					dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
					dw_maestro.ScrollToRow(il_fila_actual_maestro)
					dw_maestro.SetColumn(1)
					dw_maestro.SetFocus()
			END CHOOSE
			dw_maestro.TriggerEvent("rowfocuschanged")
		ELSE
			MessageBox("Error","La orden de corte no existe o no tiene liquidaciones")
		END IF
	END IF
	Close(w_retroalimentacion)
ELSE
END IF
end event

event ue_insertar_maestro;Long ll_orden_corte
Long li_registros, li_lote, li_estado

ll_orden_corte = Long(sle_argumento.Text)
IF dw_encabezado.Rowcount() > 0 THEN
	li_estado = dw_encabezado.GetItemNumber(1, "co_estado")
	IF li_estado = 6 OR li_estado = 5 THEN
		IF wf_verificar_rayas() THEN
			CALL w_base_maestrotb_detalletb::ue_insertar_maestro
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_orden_corte", ll_orden_corte)
			SELECT	Max(cs_parcial)
			INTO	:li_lote
			FROM	h_unidades_reales
			WHERE	cs_orden_corte = :ll_orden_corte;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al consultar el n$$HEX1$$fa00$$ENDHEX$$mero del lote siguiente")
				dw_maestro.DeleteRow(il_fila_actual_maestro)
				il_fila_actual_maestro = il_fila_actual_maestro - 1
				Return
			END IF
			IF IsNull(li_lote) THEN
				li_lote = 1
			ELSE
				li_lote = li_lote + 1
			END IF
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_parcial", li_lote)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_estado_lote_con" , 1)
			dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))
			dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
			dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
			dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
		END IF
	ELSE
		MessageBox("Advertencia...","La orden de corte no esta liquidada")
	END IF
END IF
end event

event ue_insertar_detalle;Long ll_orden_corte
Long li_lote, li_estado
s_base_parametros lstr_parametros

IF il_fila_actual_maestro > 0 THEN
	ll_orden_corte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	li_lote = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_parcial")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_lote_con")
	IF li_estado = 1 THEN
		IF Not IsNull(ll_orden_corte) AND Not IsNull(li_lote) THEN
			lstr_parametros.entero[1] = ll_orden_corte
			lstr_parametros.entero[2] = li_lote
			OpenWithParm(w_seleccionar_unidades_loteo, lstr_parametros)
			dw_detalle.Retrieve(ll_orden_corte, li_lote)
		END IF
	END IF
END IF
end event

event open;This.width = 2898
This.height = 1500

ids_escala = Create DataStore
ids_agrupa = Create DataStore
ids_libera = Create DataStore

ids_escala.DataObject = 'dgr_dt_escalas_reales'
ids_agrupa.DataObject = 'dgr_dt_agrupa_pdn'
ids_libera.DataObject = 'dgr_libera_estilos'

ids_escala.SetTransObject(SQLCA)
ids_agrupa.SetTransObject(SQLCA)
ids_libera.SetTransObject(SQLCA)


dw_encabezado.SetTransObject(SQLCA)
CALL w_base_maestrotb_detalletb::open
end event

event ue_borrar_detalle;long ll_fila
Long li_estado

ll_fila=dw_detalle.GetRow()
li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_lote_con")
If li_estado = 1 THEN
	CHOOSE CASE ll_fila
		CASE -1
			MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
		CASE 0
			MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
		CASE ELSE
			IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
				
				/////////////////////////////////////////////////////////////
				// Con el siguiente IF se esta verificando si el borrado 
				// de la fila activa fue exitosa.
				/////////////////////////////////////////////////////////////
				
				IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
					MessageBox("Error datawindow","No pudo borrar del detalle",&
									StopSign!,Ok!)
				ELSE
					This.TriggerEvent("ue_grabar")
				END IF
			ELSE
			END IF
	END CHOOSE
	
	il_fila_actual_detalle = ll_fila - 1
ELSE
	MessageBox("Advertencia","Est$$HEX2$$e1002000$$ENDHEX$$intentando borrar un registro de lote que ya ha sido procesado")
END IF

end event

event ue_grabar;call super::ue_grabar;This.TriggerEvent("ue_buscar")
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_loteo
integer x = 0
integer y = 228
integer width = 2875
integer height = 520
integer taborder = 30
boolean titlebar = false
string dataobject = "dtb_lotes_confeccion"
boolean hscrollbar = false
end type

event dw_maestro::itemchanged;Long li_tipo, li_filas, li_fabrica, li_planta
String ls_planta

IF Dwo.Name = "tipo" THEN
	li_tipo = Long(Data)
	IF li_tipo = 1 THEN
		li_filas = This.RowCount()
		IF li_filas > 1 THEN
			MessageBox("Error","Cuando se va a realizar un loteo total, no pueden existir m$$HEX1$$e100$$ENDHEX$$s loteos")
			Return 1
		END IF
	END IF
END IF
IF Dwo.Name = "co_planta_destino" THEN
	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_destino")
	li_planta = Long(Data)
	SELECT 	de_planta
	INTO		:ls_planta
	FROM		m_plantas
	WHERE		co_fabrica = :li_fabrica AND
				co_planta = :li_planta;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar la planta")
		Return(2)
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			MessageBox("Error","La planta no existe en la base de datos")
			Return(2)
		ELSE
			dw_maestro.SetItem(il_fila_actual_maestro, "m_plantas_de_planta", ls_planta)
		END IF
	END IF
END IF
dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
end event

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long ll_orden_corte
Long li_lote, li_estado

IF il_fila_actual_maestro > 0 THEN
	ll_orden_corte = dw_maestro.GetitemNumber(il_fila_actual_maestro, "cs_orden_corte")
	li_lote = dw_maestro.GetitemNumber(il_fila_actual_maestro, "cs_parcial")
	li_estado = dw_maestro.GetitemNumber(il_fila_actual_maestro, "co_estado_lote_con")
	dw_detalle.Retrieve(ll_orden_corte, li_lote)
	IF li_estado <> 1 THEN
		dw_detalle.Modify("DataWindow.ReadOnly=YES")
		dw_maestro.Modify("DataWindow.ReadOnly=YES")
	ELSE
		dw_detalle.Modify("DataWindow.ReadOnly=NO")		
		dw_maestro.Modify("DataWindow.ReadOnly=NO")		
	END IF
ELSE
	dw_detalle.Reset()
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_loteo
integer x = 315
integer y = 8
integer taborder = 10
fontcharset fontcharset = ansi!
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_loteo
integer x = 50
integer y = 4
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_loteo
integer x = 5
integer y = 752
integer width = 2866
integer height = 600
integer taborder = 40
boolean titlebar = false
string dataobject = "dtb_detalle_lotes_confeccion"
end type

event dw_detalle::itemchanged;Long li_respuesta
Long ll_uniniciales, ll_unnuevas

IF Dwo.Name = "co_color_pt" OR Dwo.Name = "co_talla" OR &
	Dwo.Name = "co_fabrica" OR Dwo.Name = "co_linea" OR Dwo.Name = "co_referencia" THEN
	li_respuesta = MessageBox("Advertencia...","Est$$HEX2$$e1002000$$ENDHEX$$modificando la referencia, esta seguro?", Question!, YesNo!, 1)
	IF li_respuesta = 2 THEN
		Return(2)
	END IF
END IF
IF Dwo.Name = "ca_loteada" THEN
	ll_uniniciales = dw_detalle.GetItemNumber(Row, "ca_loteada", Primary!, True)
	ll_unnuevas = Long(Data)
	IF ll_unnuevas > ll_uniniciales THEN
		MessageBox("Advertencia","No puede lotear m$$HEX1$$e100$$ENDHEX$$s de las unidades disponibles")
		Return(2)
	END IF
END IF
end event

type dw_encabezado from datawindow within w_loteo
integer y = 92
integer width = 2875
integer height = 132
integer taborder = 20
boolean bringtotop = true
string dataobject = "dff_consulta_ordencorte"
boolean livescroll = true
end type

