HA$PBExportHeader$w_parametros_asignacion.srw
forward
global type w_parametros_asignacion from w_base_maestroff_detalletb
end type
end forward

global type w_parametros_asignacion from w_base_maestroff_detalletb
integer x = 0
integer y = 0
integer width = 3616
integer height = 1872
string menuname = "m_mantenimiento_parametros_asignacion"
end type
global w_parametros_asignacion w_parametros_asignacion

type variables
DataStore ids_confeccion
Long ii_borrando_detalle=0
Long ii_insertando_det=0
DATETIME  idt_fe_inicio_prog_tot,idt_fe_prog_desp,idt_fe_entra_pdn

end variables

forward prototypes
public function date wf_traer_fechas (long an_co_fabrica_mod, long an_co_planta_mod, long an_co_modulo, long an_co_turno, datetime adt_fecha, long an_numero_dias, long an_tipo_avance)
public function long wf_distribuir_unidades_base (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, ref datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_dias_programados, long an_unid_que_lleva, datetime adt_fe_fin_ant, long an_base_dia, datetime adt_fe_prog_desp, ref datetime adt_fe_entra_pdn, long an_li_cod_tur)
public function long wf_distribuir_unidades (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_li_ind_camb_est, long an_li_cod_tur, datetime adt_fe_prog_desp, datetime adt_fe_entra_pdn, long an_co_tipo_asignacion)
end prototypes

public function date wf_traer_fechas (long an_co_fabrica_mod, long an_co_planta_mod, long an_co_modulo, long an_co_turno, datetime adt_fecha, long an_numero_dias, long an_tipo_avance);LONG			ll_dias_que_lleva

DATE			ldt_fe_retorno,ldt_fe_cursor,ldt_fe_calendario_modulo 


SETNULL(ldt_fe_retorno)

//-------------------------- Busca Fecha siguiente en Calenario General ----------------//

// Debe hacer un ciclo para saber que fecha le corresponde en el calendario
// Hacia Adelante 
IF an_tipo_avance = 1 THEN 
	DECLARE cur_calendario_ade CURSOR FOR  
	  SELECT m_calendario_cont.fe_calendario  
		 FROM m_calendario_cont  
		WHERE ( m_calendario_cont.ano > 0 ) AND  
				( m_calendario_cont.fe_calendario > EXTEND(:adt_fecha, YEAR TO DAY) )   
	ORDER BY m_calendario_cont.fe_calendario ASC;
	
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","No Pudo Posicionar Fecha Siguiente en Calendario General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	OPEN cur_calendario_ade;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","No Pudo Abrir Busqueda Fecha Siguiente en Calendario General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	FETCH  cur_calendario_ade INTO :ldt_fe_cursor;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Siguiente en Calendario General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF

	// -------------------------- Busca Fecha en Calenario por Modulo -------------------- //
	ll_dias_que_lleva=0
	DO WHILE SQLCA.SQLCODE =0 
		
		ll_dias_que_lleva=ll_dias_que_lleva + 1
		
		IF ll_dias_que_lleva = an_numero_dias THEN
			//busca en calendario por modulo
			SELECT dt_mod_calendario.fe_mod_calendario  
			 INTO :ldt_fe_calendario_modulo  
			 FROM dt_mod_calendario  
			WHERE ( dt_mod_calendario.co_fabrica 			= :an_co_fabrica_mod ) AND  
					( dt_mod_calendario.co_planta 			= :an_co_planta_mod ) 	AND  
					( dt_mod_calendario.co_modulo 			= :an_co_modulo ) 			AND  
					( dt_mod_calendario.fe_mod_calendario 	= :ldt_fe_cursor )   AND
					( dt_mod_calendario.co_tipo_dia 			<> "T" )   					;
					
			IF SQLCA.SQLCODE=0 THEN				
				//la fecha esta marcada como excepci$$HEX1$$f300$$ENDHEX$$n en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo, continue		
				ll_dias_que_lleva=ll_dias_que_lleva - 1
				
				FETCH  cur_calendario_ade INTO :ldt_fe_cursor;
				IF SQLCA.SQLCODE=-1 THEN
					MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Siguiente en Calendario General")
					SETNULL(ldt_fe_retorno)
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=100 THEN
					ldt_fe_retorno=ldt_fe_cursor
					SQLCA.SQLCODE=-1
				ELSE
					IF SQLCA.SQLCODE=-1 THEN
						MESSAGEBOX("ERROR BASE DATOS","No Pudo Hallar Fecha Siguiente en Calendario Modulo")
						SETNULL(ldt_fe_retorno)
					ELSE
					END IF
				END IF
			END IF
		// Ultimo Dia Encontrado
		ELSE
			FETCH  cur_calendario_ade INTO :ldt_fe_cursor;
			IF SQLCA.SQLCODE=-1 THEN
				MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Siguiente en Calendario General")
				SETNULL(ldt_fe_retorno)
			ELSE
			END IF
		END IF
		
	LOOP	// 	DO WHILE SQLCA.SQLCODE =0 
	
	CLOSE cur_calendario_ade;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO CERRAR BUSQUEDA DE FECHA SIGUIENTE EN CALENDARIO GENERAL")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF

//-------------------------- Busca Fecha Anterior en Calenario General ----------------//
// tipo avance=2 

ELSE 	
	DECLARE cur_calendario_atr CURSOR FOR  
	  SELECT m_calendario_cont.fe_calendario  
		 FROM m_calendario_cont  
		WHERE ( m_calendario_cont.ano > 0 ) AND  
				( m_calendario_cont.fe_calendario < EXTEND(:adt_fecha, YEAR TO DAY) )   
	ORDER BY m_calendario_cont.fe_calendario DESC;
	
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","No Pudo Posicionar Fecha Anterior en Calendario General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	OPEN cur_calendario_atr;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","No Pudo Abrir Fecha Anterior en Calendario General")
		SETNULL(ldt_fe_retorno)
		
	ELSE
	END IF
	
	FETCH  cur_calendario_atr INTO :ldt_fe_cursor;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Anterior en Calendario General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	// -------------------- Busca fecha en Calendario por Modulo -------------------------- //
	ll_dias_que_lleva=0
	DO WHILE SQLCA.SQLCODE =0 
		
		ll_dias_que_lleva=ll_dias_que_lleva + 1
		
		IF ll_dias_que_lleva = an_numero_dias THEN
			//busca en calendario por modulo
			SELECT dt_mod_calendario.fe_mod_calendario  
			 INTO :ldt_fe_calendario_modulo  
			 FROM dt_mod_calendario  
			WHERE ( dt_mod_calendario.co_fabrica 			= :an_co_fabrica_mod ) AND  
					( dt_mod_calendario.co_planta 			= :an_co_planta_mod ) 	AND  
					( dt_mod_calendario.co_modulo 			= :an_co_modulo ) 			AND  
					( dt_mod_calendario.fe_mod_calendario 	= :ldt_fe_cursor )   AND
					( dt_mod_calendario.co_tipo_dia 			<> "T" )   					;
			IF SQLCA.SQLCODE=0 THEN
				//la fecha esta marcada como excepci$$HEX1$$f300$$ENDHEX$$n en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo, continue
				ll_dias_que_lleva=ll_dias_que_lleva - 1
				
				FETCH  cur_calendario_atr INTO :ldt_fe_cursor;
				IF SQLCA.SQLCODE=-1 THEN
					MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Anterior en Calendario General")
					SETNULL(ldt_fe_retorno)
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=100 THEN
					ldt_fe_retorno=ldt_fe_cursor
					SQLCA.SQLCODE=-1
				ELSE
					IF SQLCA.SQLCODE=-1 THEN
						MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Anterior en Calendario Modulo")
						SETNULL(ldt_fe_retorno)
					ELSE
					END IF
				END IF
			END IF

		ELSE
			FETCH  cur_calendario_atr INTO :ldt_fe_cursor;
			IF SQLCA.SQLCODE=-1 THEN
				MESSAGEBOX("ERROR BASE DATOS","No Pudo Leer Fecha Anterior en Calendario General")
				SETNULL(ldt_fe_retorno)
			ELSE
			END IF
		END IF
		
	LOOP		// 	DO WHILE SQLCA.SQLCODE =0 
	
	CLOSE cur_calendario_atr;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO CERRAR BUSQUEDA DE FECHA ANTERIOR EN CALENDARIO GENERAL")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF

	
END IF


RETURN ldt_fe_retorno
end function

public function long wf_distribuir_unidades_base (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, ref datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_dias_programados, long an_unid_que_lleva, datetime adt_fe_fin_ant, long an_base_dia, datetime adt_fe_prog_desp, ref datetime adt_fe_entra_pdn, long an_li_cod_tur);DateTime 			ldt_fechahora
Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo, li_simulacion
s_base_parametros lstr_parametros
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long           li_ca_pendiente_ant, li_ca_unid_base_dia_ant
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia
LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_personasxmodulo,ll_ca_unid_posibles
LONG 					ll_ca_programada_manual, ll_dias_programados_manual

Long				li_co_fabrica_exp_ant,li_co_fabrica_ref_ant,li_co_linea_ref_ant,li_cs_estilocolortono_ant
Long				li_cs_particion_ant,li_prioridad_ant,li_dia,li_cs_fechas,li_duracion,li_co_est_prog_dia
LONG         		ll_pedido_ant,ll_cs_liberacion_ant,ll_co_referencia_ant,ll_color_pt_ant,ll_unidades_empate  
LONG					ll_unidades_disponibles,ll_ca_pendiente
STRING				ls_nu_orden_ant,ls_tono_ant,ls_nombre_dia, ls_mensaje
DECIMAL				ld_minutos_empate,ld_ca_min_dispon_fin,ld_ca_min_dispon_ant,ld_minutos_disponibles
DATETIME				ldt_fe_inicio,ldt_fe_fin,ldt_fe_creacion,ldt_fe_actualizacion,ldt_fe_fin_ant
DATETIME				ldt_fe_inicio_prog_tot,ldt_fe_fin_prog_tot,ldt_fe_calculada_despacho
DATE					ld_fecha_despacho, ld_fe_inicio
Long				li_tipo_avance_calendario, li_numero_dias

				
	// ------------------------------- inicio de traer datos iniciales -------------------------------------------//

	// traer unidades disponibles 
	// an_unid_que_lleva = unidades pendientes - unidades programadas
	ll_unidades_disponibles= an_unid_que_lleva		
	
	// traer minutos disponibles
	// variables que afectan: 
	li_cs_prioridad=an_prioridad
	li_tipo_empate=an_tipo_empate
	ld_ca_min_dispon_ant=ad_minutos_jornada 
	
	// 1. si es prioridad 1: las fechas iniciales son las de inicio de programacion
	IF li_cs_prioridad = 1 THEN
		ldt_fe_fin_ant			=adt_fe_inicio_prog
		ldt_fe_inicio			=adt_fe_inicio_prog
	ELSE
	// 2. Si es prioridad > 1 : las fechas iniciales son las finales de la prioridad anterior
		ldt_fe_fin_ant  		=adt_fe_fin_ant
		ldt_fe_inicio			=adt_fe_fin_ant
	END IF
	
	// traer minutos estandar
	ld_ca_minutos_std=ad_minutos_std
	
	// traer personas por modulo
	ll_personasxmodulo=an_personasxmodulo
	
	// ---------------------*** inicio de programaci$$HEX1$$f300$$ENDHEX$$n hacia A D E L A N T E ***------------ // 
	IF ISNULL(adt_fe_prog_desp) THEN  
		// Busca datos referencia anterior para tomar
		// Unidades base, utima fecha programada, ultimas unidades programadas
	
		IF li_cs_prioridad >1 THEN
			li_prioridad_ant=li_cs_prioridad - 1
			SELECT dt_pdnxmodulo.ca_unid_base_dia,   
				dt_pdnxmodulo.co_fabrica_exp, 		
				dt_pdnxmodulo.pedido, 					
				dt_pdnxmodulo.cs_liberacion, 		
				dt_pdnxmodulo.po, 						
				dt_pdnxmodulo.co_fabrica_pt, 			
				dt_pdnxmodulo.co_linea, 				
				dt_pdnxmodulo.co_referencia, 			
				dt_pdnxmodulo.co_color_pt,			
				dt_pdnxmodulo.tono, 						
				dt_pdnxmodulo.cs_estilocolortono, 	
				dt_pdnxmodulo.cs_particion 			
		 INTO :li_ca_unid_base_dia_ant,				
				:li_co_fabrica_exp_ant,
				:ll_pedido_ant,
				:ll_cs_liberacion_ant,
				:ls_nu_orden_ant,
				:li_co_fabrica_ref_ant,
				:li_co_linea_ref_ant,
				:ll_co_referencia_ant,
				:ll_color_pt_ant,
				:ls_tono_ant,
				:li_cs_estilocolortono_ant,
				:li_cs_particion_ant
		 FROM dt_pdnxmodulo  
		WHERE ( dt_pdnxmodulo.simulacion 	= 	:an_simulacion ) AND  
				( dt_pdnxmodulo.co_fabrica 	=	:an_fabrica_modulo ) AND  
				( dt_pdnxmodulo.co_planta 		=  :an_planta_modulo) AND  
				( dt_pdnxmodulo.co_modulo 		=  :an_modulo) AND  
				( dt_pdnxmodulo.cs_prioridad 	=  :li_prioridad_ant)   ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo encontrar parametros de la prioridad anterior")
		ELSE
			// ---------------  Busca ultimo dia programado de la prioridad anterior -----------//
			//                  toma informacion (minutos, unidades, fecha,...) 
			SELECT dt_programa_diario.fe_inicio, dt_programa_diario.ca_pendiente
			 INTO :ldt_fe_fin_ant, :li_ca_pendiente_ant
			 FROM dt_programa_diario  
			WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
					( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
					( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
					( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
					( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
					( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
					( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
					( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
					( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
					( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
					( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
					( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
					( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
					( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
					( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) AND  
					( dt_programa_diario.cs_fechas 				= 	
					(
						SELECT MAX(dt_programa_diario.cs_fechas  )
						 FROM dt_programa_diario  
						WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
								( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
								( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
								( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
								( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
								( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
								( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
								( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
								( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
								( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
								( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
								( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
								( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
								( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
								( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) 
					)
			)   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo encontrar informacion ultimo dia programado prioridad anterior")
			ELSE
			END IF
		END IF		
	ELSE
	END IF
	// --------------------- fin de traer datos iniciales ---------------------------------- //


	//------------inicio de ciclo para calcular unidades a asignar a diario -----------------------//
	
	li_dia=an_dias_programados
	DO WHILE ll_unidades_disponibles > 0
		
		li_dia=li_dia + 1
		
		// Establece % de eficiencia de 100  
		ld_porc_eficiencia=100
	
		// Minutos disponibles
		IF li_dia=1 THEN
			ld_minutos_disponibles=ld_ca_min_dispon_ant
		ELSE
			ld_minutos_disponibles=ad_minutos_jornada
		END IF
		
		// ------------------- UNIDADES POSIBLES ---------------------------------- //
		// Obtiene unidades seg$$HEX1$$fa00$$ENDHEX$$n el tipo de empate para el primer dia
		// estas son las del primer dia 0 autom, 1 manual, 2 no empate
		
		// Prioridades > 1
		IF li_cs_prioridad > 1 THEN
			IF li_dia=1 THEN
				// Empate Automatico
				IF li_tipo_empate=0 THEN
					ll_ca_unid_posibles=li_ca_unid_base_dia_ant - li_ca_pendiente_ant 
				ELSE
					// Empate Manual
					IF li_tipo_empate=1 THEN
						ll_ca_unid_posibles=an_unidades_empate
					// No empate
					ELSE					
						ll_ca_unid_posibles=an_base_dia
					END IF
				END IF
			// Dias posteriores al primero
			ELSE
				ll_ca_unid_posibles=an_base_dia
			END IF 
		// Prioridad 1. Verificar si se incluyen otros controles de inicio
		ELSE
			ll_ca_unid_posibles=an_base_dia
		END IF
	
		// -------------------- Determina fechas a utlizar -----------------------------------//
		
		// fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n
		IF li_dia=1 THEN		
			IF li_cs_prioridad=1 THEN
				// Controla Fecha Entrada Produccion Prioridad 1
				IF ISNULL(adt_fe_entra_pdn) THEN								
					IF ISNULL(adt_fe_inicio_prog) THEN
						MessageBox("Error de Datos","Para la primera asignaci$$HEX1$$f300$$ENDHEX$$n debe tener fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n")
						RETURN 0
					ELSE
						ldt_fe_inicio=adt_fe_inicio_prog
					END IF
				ELSE
					ldt_fe_inicio=adt_fe_entra_pdn
				END IF
			ELSE			
				// Organiza fecha para prioridades > 1
				// No hay fecha de entrada a produccion
				IF ISNULL(adt_fe_entra_pdn)	THEN
					// Usa fecha terminacion prioridad anterior
					ldt_fe_inicio=ldt_fe_fin_ant		
					// Verifica Tipo de Empate
					IF li_tipo_empate=2 THEN
						// Avanza un dia en el Calendario hacia adelante
						li_tipo_avance_calendario=1 
						li_numero_dias=1
						ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
															ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
						IF ISNULL(ld_fe_inicio) THEN
							ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ldt_fe_inicio)
							MessageBox("Error de Datos",ls_mensaje)
							RETURN 0
						ELSE
							ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
						END IF
					ELSE
					END IF
				// hay fecha de entrada a produccion
				ELSE // IF ISNULL(adt_fe_entra_pdn)	
					ldt_fe_inicio=adt_fe_entra_pdn
 					// debe verificar que la fecha de inicio no halla quedado mayor 
					// que la fecha de fin anterior, o sino cambiarla
					IF ldt_fe_inicio > ldt_fe_fin_ant THEN
								// --------
								// Organiza las unidades con base dia 
								// si la fecha de entrada a produccion es mayor a la fecha anterior
								// --------
								ll_ca_unid_posibles=an_base_dia
					ELSE
						ldt_fe_inicio=ldt_fe_fin_ant
						// No Empata
						IF li_tipo_empate=2 THEN 
							// Avanza un dia en el Calendario hacia adelante
							li_tipo_avance_calendario=1 
							li_numero_dias=1
							ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
																	ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
							IF ISNULL(ld_fe_inicio) THEN
								ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ldt_fe_inicio)
								MessageBox("Error de Datos",ls_mensaje)
								RETURN 0
							ELSE
								ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
							END IF
						ELSE
						END IF		
					END IF
				END IF
			END IF
			// Guarda Fecha Dia 1
			ldt_fe_inicio_prog_tot=ldt_fe_inicio
			
		// ----------- Dias Posteriores al Primero ------------------------- //
		
		ELSE // IF li_dia=1 		
			ldt_fe_inicio=ldt_fe_fin_ant
			// Avanza un dia en el Calendario hacia adelante
			li_tipo_avance_calendario=1 
			li_numero_dias=1
			ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
												ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
			IF ISNULL(ld_fe_inicio) THEN
					ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ldt_fe_inicio)
					MessageBox("Error de Datos",ls_mensaje)
					RETURN 0
			ELSE
					ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
			END IF
		END IF // IF li_dia=1 		
		
		// -------------------------- ORGANIZA SALDO A PROGRAAMR ----------------------- //
		// UNIDADES A ASIGNAR, Verifica no sobrepasar unidades posibles de programacion	//
		// ---------
		IF ll_unidades_disponibles > ll_ca_unid_posibles THEN
			ll_ca_pendiente		=ll_ca_unid_posibles
			ld_ca_min_dispon_fin	=0
		ELSE
			ll_ca_pendiente		=ll_unidades_disponibles
			ld_ca_min_dispon_fin	=ld_minutos_disponibles - ((ad_minutos_std * ll_ca_pendiente) / ( an_personasxmodulo)) * (ld_porc_eficiencia/100) 	
		END IF
		
		// UNIDADES QUE QUEDAN
		ll_ca_unid_dispon_fin=ll_unidades_disponibles - ll_ca_pendiente
			
		li_cs_fechas=li_dia
		
		// ------------- GUARDA FECHAS DE PROGRAMACION ------------------- //
		// Guarda Fecha programada como ultima fecha de programacion
		ldt_fe_fin = ldt_fe_inicio
		ldt_fe_fin_ant = ldt_fe_inicio
		
		li_co_est_prog_dia=1
		li_fuente_dato=1
		
		ldt_fechahora = f_fecha_servidor()
		ldt_fe_creacion=ldt_fechahora   
		ldt_fe_actualizacion=ldt_fe_creacion
	
		
		// -------------------- inicio de datos de salida - Actualizaciones ------------------ //
		
		// -------------------- Actualiza Archivo de Programacion Diaria ----------------------//
		INSERT INTO dt_programa_diario  
				( simulacion,   
				  co_fabrica,   
				  co_planta,   
				  co_modulo,   
				  co_fabrica_exp,   
				  pedido,   
				  cs_liberacion,   
				  po,   
				  co_fabrica_pt,   
				  co_linea,   
				  co_referencia,   
				  co_color_pt,   
				  tono,   
				  cs_estilocolortono,   
				  cs_particion,   
				  cs_fechas,   
				  fe_inicio,   
				  ca_unid_dispon_ini,   
				  ca_min_dispon_ini,   
				  ca_unid_dispon_fin,   
				  ca_min_dispon_fin,   
				  personasxmodulo,
				  dia_curva,
				  porc_eficiencia,   
				  ca_unid_posibles,   
				  duracion,   
				  fe_fin,   
				  ca_programada,   
				  ca_producida,   
				  ca_pendiente,   
				  co_est_prog_dia,   
				  fuente_dato,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia )  
	  VALUES ( :an_simulacion,   
				  :an_fabrica_modulo,   
				  :an_planta_modulo,   
				  :an_modulo,   
				  :an_co_fabrica_exp,   
				  :an_pedido,   
				  :an_cs_liberacion,   
				  :as_po,   
				  :an_co_fabrica_ref,   
				  :an_co_linea_ref,   
				  :an_co_referencia,   
				  :an_color_pt,   
				  :as_tono,   
				  :an_cs_estilocolortono,   
				  :an_cs_particion,   
				  :li_cs_fechas,   
				  :ldt_fe_inicio,   
				  :ll_unidades_disponibles, 
				  :ld_minutos_disponibles, 
				  :ll_ca_unid_dispon_fin, 
				  :ld_ca_min_dispon_fin, 
				  :an_personasxmodulo,   
				  0,//dia_curva
				  :ld_porc_eficiencia, 
				  :ll_ca_unid_posibles,   
				  :li_duracion, 
				  :ldt_fe_fin,   
				  :ll_ca_pendiente,   
				  0,   
				  :ll_ca_pendiente,   
				  :li_co_est_prog_dia,   
				  :li_fuente_dato,   
				  :ldt_fe_creacion,   
				  :ldt_fe_actualizacion,   
				  :gstr_info_usuario.codigo_usuario,   
				  :gstr_info_usuario.instancia )  ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo insertar unidades en dias")
			RETURN 0
		ELSE
		END IF
		// ------------------------------- fin de datos de salida ------------------------- //
		
		ll_unidades_disponibles=ll_unidades_disponibles - ll_ca_pendiente
	
	LOOP  // DO WHILE ll_unidades_disponibles > 0
	
	//------------fin de ciclo para calcular unidades a asignar a diario -----------------------//
			
	//------------  inicio de calculo de fecha de despacho -----------------------//
	ldt_fe_fin_prog_tot=ldt_fe_fin
	
	// Calcula fecha de despacho con base en ultimo dia programado 
	// ---------------------------------------------------------------------------
	// Nota : Queda pendiente definir de donde se tomaran los dias de despacho
	// por fabrica, para que no sean estaticos.
	// ---------------------------------------------------------------------------
	
	IF NOT isnull(ldt_fe_fin_prog_tot) THEN		
		ls_nombre_dia = UPPER(string(ldt_fe_fin_prog_tot, "ddd"))
		ld_fecha_despacho = date(ldt_fe_fin_prog_tot)
		CHOOSE CASE ls_nombre_dia
			CASE 'MON'
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)				
			CASE 'TUE'				
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 4)
			CASE 'WED'				
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)	
			CASE 'THU'
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
			CASE 'FRI'
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)
			CASE 'SAT'
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)
			CASE 'SUN'
				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
		END CHOOSE				
			
	END IF
	
	ldt_fe_calculada_despacho=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))
	
	//------------  fin de calculo de fecha de despacho -----------------------//
		
	// ------------------------- inicio de Actualizaci$$HEX1$$f300$$ENDHEX$$n Archivo de Parametros ------------------------ //
  	UPDATE dt_pdnxmodulo  
		  SET fe_inicio_prog 	= :ldt_fe_inicio_prog_tot,   
				fe_fin_prog 		= :ldt_fe_fin_prog_tot,
				fe_requerida_desp	= :ldt_fe_calculada_despacho
		WHERE ( dt_pdnxmodulo.simulacion 			= :an_simulacion ) AND  
				( dt_pdnxmodulo.co_fabrica 			= :an_fabrica_modulo ) AND  
				( dt_pdnxmodulo.co_planta 				= :an_planta_modulo ) AND  
				( dt_pdnxmodulo.co_modulo 				= :an_modulo ) AND  
				( dt_pdnxmodulo.co_fabrica_exp 		= :an_co_fabrica_exp) AND  
				( dt_pdnxmodulo.pedido 					= :an_pedido ) AND  
				( dt_pdnxmodulo.cs_liberacion 		= :an_cs_liberacion ) AND  
				( dt_pdnxmodulo.po 						= :as_po ) AND  
				( dt_pdnxmodulo.co_fabrica_pt 		= :an_co_fabrica_ref ) AND  
				( dt_pdnxmodulo.co_linea 				= :an_co_linea_ref ) AND  
				( dt_pdnxmodulo.co_referencia 		= :an_co_referencia ) AND  
				( dt_pdnxmodulo.co_color_pt 			= :an_color_pt ) AND  
				( dt_pdnxmodulo.tono 					= :as_tono ) AND  
				( dt_pdnxmodulo.cs_estilocolortono 	= :an_cs_estilocolortono ) AND  
				( dt_pdnxmodulo.cs_particion 			= :an_cs_particion  )   ;
				
	IF SQLCA.SQLCODE = -1 THEN
		MessageBox("Error Base Datos","No pudo Actualizar fechas de inicio y fin de asignaci$$HEX1$$f300$$ENDHEX$$n")
		RETURN 0
	ELSE
	END IF
	
// ------------------------- fin de Actualizaci$$HEX1$$f300$$ENDHEX$$n Archivo de Parametros ------------------------ //

// ------------------------------- fin de programacion hacia adelante -------------------------------------------//


// -----------------------*** inicio de programaci$$HEX1$$f300$$ENDHEX$$n hacia A T R A S *** --------------------------------------- //
ELSE
		//------------  inicio de calculo de fecha de despacho -----------------------//
	
		// Calcula fecha de ultima produccion con base en fecha de despacho programada
		// ---------------------------------------------------------------------------
		// Nota : Queda pendiente definir de donde se tomaran los dias de despacho
		// por fabrica, para que no sean estaticos.
		// ---------------------------------------------------------------------------
		ldt_fe_calculada_despacho=adt_fe_prog_desp
		ldt_fe_fin_prog_tot=adt_fe_prog_desp
		
		IF NOT isnull(ldt_fe_fin_prog_tot) THEN		
				ls_nombre_dia = UPPER(string(ldt_fe_fin_prog_tot, "ddd"))
				ld_fecha_despacho = date(ldt_fe_fin_prog_tot)
				CHOOSE CASE ls_nombre_dia
					CASE 'MON'
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -5)				
					CASE 'TUE'				
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -4)
					CASE 'WED'				
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -7)	
					CASE 'THU'
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -6)
					CASE 'FRI'
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -5)
					CASE 'SAT'
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -7)
					CASE 'SUN'
						ld_fecha_despacho = Relativedate(ld_fecha_despacho, -6)
				END CHOOSE				
				
		END IF
	
		ldt_fe_fin_prog_tot=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))
		
		// Lleva ultima fecha de programacion calculada como fecha terminacion anterior
		ldt_fe_fin_ant=ldt_fe_fin_prog_tot
		
	//------------  fin de calculo de fecha de despacho -----------------------//
	
	
	//------------ inicio de ciclo para definir fechas de inicio de prog -------------------//
		li_dia=an_dias_programados
		DO WHILE ll_unidades_disponibles > 0
			
			li_dia=li_dia + 1
			
			// Establece % de eficiencia de 100  
			ld_porc_eficiencia=100
		
			// Minutos disponibles
			ld_minutos_disponibles=ad_minutos_jornada
		
			// UNIDADES POSIBLES CORRESPONDEN A LA BASE DIARIA
			ll_ca_unid_posibles=an_base_dia
		
			// UNIDADES A ASIGNAR, Verifica no sobrepasar unidades posibles de programacion
			IF ll_unidades_disponibles >  ll_ca_unid_posibles THEN
				ll_ca_pendiente=ll_ca_unid_posibles
				ld_ca_min_dispon_fin=0
			ELSE
				ll_ca_pendiente=ll_unidades_disponibles
				ld_ca_min_dispon_fin=ld_minutos_disponibles - ((ad_minutos_std * ll_ca_pendiente) / ( an_personasxmodulo)) * (ld_porc_eficiencia/100) 	
			END IF
			
			// UNIDADES QUE QUEDAN
			ll_ca_unid_dispon_fin=ll_unidades_disponibles - ll_ca_pendiente
				
			li_cs_fechas=li_dia
			
			// -------------------- Determina fechas a utlizar -----------------------------------//
			
			// fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n
			ldt_fe_inicio=adt_fe_fin_ant
			// Retrocede un dia en el Calendario hacia atras
			li_tipo_avance_calendario=2 
			li_numero_dias=1
			ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
												ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
			IF ISNULL(ld_fe_inicio) THEN
					ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ldt_fe_inicio)
					MessageBox("Error de Datos",ls_mensaje)
				RETURN 0
			ELSE
					ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
			END IF
			
			// Guarda Fecha programada como ultima fecha de programacion
			ldt_fe_fin_ant = ldt_fe_inicio
			
			li_co_est_prog_dia=1
			li_fuente_dato=1
			
			ldt_fechahora = f_fecha_servidor()
			ldt_fe_creacion=ldt_fechahora   
			ldt_fe_actualizacion=ldt_fe_creacion
		
			ll_unidades_disponibles=ll_unidades_disponibles - ll_ca_pendiente
		
		LOOP  // DO WHILE ll_unidades_disponibles > 0
		
	// --------
	// Organiza variables a ser usadas en el siguiente ciclo de programacion  
	// hacia adelante
	// --------
		ldt_fe_fin_prog_tot	=	ldt_fe_fin_ant
		adt_fe_entra_pdn		= 	ldt_fe_fin_ant 
		adt_fe_inicio_prog 	= 	ldt_fe_fin_ant 
				
	//------------ inicio de ciclo para definir fechas de inicio de prog -------------------//
	
	// ------------------------- inicio de Actualizar Archivo de Parametros ------------------------ //
		UPDATE dt_pdnxmodulo  
		  SET fe_entra_pdn	= :ldt_fe_fin_prog_tot,
				fe_inicio_prog = :ldt_fe_fin_prog_tot
		WHERE ( dt_pdnxmodulo.simulacion 			= :an_simulacion ) AND  
				( dt_pdnxmodulo.co_fabrica 			= :an_fabrica_modulo ) AND  
				( dt_pdnxmodulo.co_planta 				= :an_planta_modulo ) AND  
				( dt_pdnxmodulo.co_modulo 				= :an_modulo ) AND  
				( dt_pdnxmodulo.co_fabrica_exp 		= :an_co_fabrica_exp) AND  
				( dt_pdnxmodulo.pedido 					= :an_pedido ) AND  
				( dt_pdnxmodulo.cs_liberacion 		= :an_cs_liberacion ) AND  
				( dt_pdnxmodulo.po 						= :as_po ) AND  
				( dt_pdnxmodulo.co_fabrica_pt 		= :an_co_fabrica_ref ) AND  
				( dt_pdnxmodulo.co_linea 				= :an_co_linea_ref ) AND  
				( dt_pdnxmodulo.co_referencia 		= :an_co_referencia ) AND  
				( dt_pdnxmodulo.co_color_pt 			= :an_color_pt ) AND  
				( dt_pdnxmodulo.tono 					= :as_tono ) AND  
				( dt_pdnxmodulo.cs_estilocolortono 	= :an_cs_estilocolortono ) AND  
				( dt_pdnxmodulo.cs_particion 			= :an_cs_particion  )   ;
				
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox("Error Base Datos","No pudo Actualizar fechas de inicio y fin de asignaci$$HEX1$$f300$$ENDHEX$$n")
			RETURN 0
		ELSE
		END IF
	// ------------------------- fin de Actualizar Archivo de Parametros ------------------------ //

END IF
// --------------------------fin de programaci$$HEX1$$f300$$ENDHEX$$n hacia A T R A S ------------------------------------------------ //
RETURN 1 

end function

public function long wf_distribuir_unidades (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_li_ind_camb_est, long an_li_cod_tur, datetime adt_fe_prog_desp, datetime adt_fe_entra_pdn, long an_co_tipo_asignacion);LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_personasxmodulo,ll_ca_unid_posibles
LONG         		ll_pedido_ant,ll_cs_liberacion_ant,ll_co_referencia_ant,ll_color_pt_ant,ll_unidades_empate  
LONG					ll_unidades_disponibles,ll_ca_pendiente,ll_ca_proyectada,ll_ca_actual

Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion,li_cs_fechas_ant
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion,li_dia_curva_ant
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad,li_dia_curva
Long				li_co_fabrica_exp_ant,li_co_fabrica_ref_ant,li_co_linea_ref_ant,li_cs_estilocolortono_ant
Long				li_cs_particion_ant,li_prioridad_ant,li_dia,li_cs_fechas,li_duracion,li_co_est_prog_dia
Long 				li_anno,li_mes,li_dia_fec,li_tipo_avance_calendario,li_numero_dias,li_cs_fechas_cursor

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia
DECIMAL				ld_minutos_empate,ld_ca_min_dispon_fin,ld_ca_min_dispon_ant,ld_minutos_disponibles

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido
STRING				ls_nu_orden_ant,ls_tono_ant,ls_nombre_dia
STRING				ls_co_tipo_dia,ls_mensaje

DateTime 			ldt_fechahora,ldt_fe_inicio_cursor
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DATETIME				ldt_fe_inicio,ldt_fe_fin,ldt_fe_creacion,ldt_fe_actualizacion,ldt_fe_fin_ant
DATETIME				ldt_fe_inicio_prog_tot,ldt_fe_fin_prog_tot,ldt_fe_calculada_despacho

DATE					ld_fecha_despacho,ld_fe_inicio,ld_fe_fin

s_base_parametros lstr_parametros

//-----------------  PROGRAMACION HACIA ADELANTE --------------------------------------//

IF ISNULL(adt_fe_prog_desp) THEN 
	
	//validaciones de fechas
	IF ISNULL(adt_fe_entra_pdn) THEN
	
		IF ISNULL(adt_fe_inicio_prog) THEN
			
			li_anno=year(date(ldt_fe_inicio_prog))
			li_mes=month(date(ldt_fe_inicio_prog))
			li_dia_fec=day(date(ldt_fe_inicio_prog))
			
			//busca a ver si la fecha inicio programacion est$$HEX2$$e1002000$$ENDHEX$$en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo
			SELECT dt_mod_calendario.co_tipo_dia  
			 INTO :ls_co_tipo_dia  
			 FROM dt_mod_calendario  
			WHERE ( dt_mod_calendario.co_fabrica 	=:an_fabrica_modulo ) 	AND  
					( dt_mod_calendario.co_planta 	=:an_planta_modulo  ) 	AND  
					( dt_mod_calendario.co_modulo 	=:an_modulo  ) 			AND  
					( dt_mod_calendario.ano 			=:li_anno  ) 					AND  
					( dt_mod_calendario.mes 			=:li_mes ) 						AND  
					( dt_mod_calendario.dia 			=:li_dia_fec);
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error base datos","No pudo buscar fecha Inicio programacion en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
				RETURN 0
			ELSE
				IF SQLCA.SQLCODE=0 THEN
					IF MID(ls_co_tipo_dia,1,1)<>"T" THEN
						MessageBox("Error datos","Fecha inicio de programacion, no es un dia de trabajo en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
						RETURN 0
					ELSE
					END IF		
				ELSE
				END IF
			END IF
		ELSE
		END IF
	ELSE // IF ISNULL(adt_fe_entra_pdn) 
			li_anno=year(date(adt_fe_entra_pdn))
			li_mes=month(date(adt_fe_entra_pdn))
			li_dia_fec=day(date(adt_fe_entra_pdn))
			
			//busca a ver si la fecha de entrada produccion est$$HEX2$$e1002000$$ENDHEX$$en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo
			SELECT dt_mod_calendario.co_tipo_dia  
			 INTO :ls_co_tipo_dia  
			 FROM dt_mod_calendario  
			WHERE ( dt_mod_calendario.co_fabrica 	=:an_fabrica_modulo ) 	AND  
					( dt_mod_calendario.co_planta 	=:an_planta_modulo  ) 	AND  
					( dt_mod_calendario.co_modulo 	=:an_modulo  ) 			AND  
					( dt_mod_calendario.ano 			=:li_anno  ) 					AND  
					( dt_mod_calendario.mes 			=:li_mes ) 						AND  
					( dt_mod_calendario.dia 			=:li_dia_fec);
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error base datos","No pudo buscar fecha entrada producci$$HEX1$$f300$$ENDHEX$$n en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
				RETURN 0
			ELSE
				IF SQLCA.SQLCODE=0 THEN	
					IF MID(ls_co_tipo_dia,1,1)<>"T" THEN
						MessageBox("Error datos","Fecha Entrada producci$$HEX1$$f300$$ENDHEX$$n, no es dia de trabajo en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
						RETURN 0
					ELSE
					END IF		
				ELSE
				END IF
			END IF
	END IF

	//---------------------------- inicio de traer datos iniciales -------------------------//
	// traer unidades disponibles
	ll_unidades_disponibles=an_unidades
	
	// traer minutos disponibles
	// variables que afectan: 
	li_cs_prioridad=an_prioridad
	li_tipo_empate=an_tipo_empate

	// 1. si es prioridad 1: debe tener todos los minutos disponibles.
	IF li_cs_prioridad =1 THEN
	// Tiene todo la jornada disponible o segun tiempo disponible del modulo en la fecha		
		ld_ca_min_dispon_ant=ad_minutos_jornada 
	ELSE
	// 2. segun empate as$$HEX1$$ed00$$ENDHEX$$:
	//   0.Automatico: Si prioridad > 1 debe traer minutos disponibles de la asignaci$$HEX1$$f300$$ENDHEX$$n previa. 
	//   1.Manual    : no requiere minutos disponibles, de todas formas debe operar seg$$HEX1$$fa00$$ENDHEX$$n caso 0, para posterior validaci$$HEX1$$f300$$ENDHEX$$n.
	//   2.No empate : Debe tener todos los minutos disponibles, entonces debe operar como caso 0, y no debe tener
	//		             minutos disponibles y si tiene, debe saltar a la siguiente fecha del calendario del modulo 
	//			          para arrancar.
	//----------------------------------------------------------------------------------- //

	//------------- Busca Parametros de la Prioridad anterior ----------------------------//
		li_prioridad_ant=li_cs_prioridad - 1
		SELECT dt_pdnxmodulo.co_fabrica_exp,   
						dt_pdnxmodulo.pedido,   
						dt_pdnxmodulo.cs_liberacion,   
						dt_pdnxmodulo.po,   
						dt_pdnxmodulo.co_fabrica_pt,   
						dt_pdnxmodulo.co_linea,   
						dt_pdnxmodulo.co_referencia,   
						dt_pdnxmodulo.co_color_pt,   
						dt_pdnxmodulo.tono,   
						dt_pdnxmodulo.cs_estilocolortono,   
						dt_pdnxmodulo.cs_particion  
				 INTO :li_co_fabrica_exp_ant,   
						:ll_pedido_ant,   
						:ll_cs_liberacion_ant,   
						:ls_nu_orden_ant,   
						:li_co_fabrica_ref_ant,   
						:li_co_linea_ref_ant,   
						:ll_co_referencia_ant,   
						:ll_color_pt_ant,   
						:ls_tono_ant,   
						:li_cs_estilocolortono_ant,   
						:li_cs_particion_ant  
				 FROM dt_pdnxmodulo  
				WHERE ( dt_pdnxmodulo.simulacion 	= 	:an_simulacion ) AND  
						( dt_pdnxmodulo.co_fabrica 	=	:an_fabrica_modulo ) AND  
						( dt_pdnxmodulo.co_planta 		=  :an_planta_modulo) AND  
						( dt_pdnxmodulo.co_modulo 		=  :an_modulo) AND  
						( dt_pdnxmodulo.cs_prioridad 	=  :li_prioridad_ant)   ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo encontrar parametros de la prioridad anterior")
		ELSE
			// ---------------  Busca ultimo dia programado de la prioridad anterior -----------//
			//                  toma informacion (minutos, unidades, fecha,...) 
			SELECT dt_programa_diario.ca_min_dispon_fin,dt_programa_diario.fe_inicio,dt_programa_diario.cs_fechas,dt_programa_diario.dia_curva  
					 INTO :ld_ca_min_dispon_ant,:ldt_fe_fin_ant,:li_cs_fechas_ant,:li_dia_curva_ant  
					 FROM dt_programa_diario  
					WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
							( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
							( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
							( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
							( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
							( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
							( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
							( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
							( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
							( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
							( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
							( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
							( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
							( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
							( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) AND  
							( dt_programa_diario.cs_fechas 				= 	(
									SELECT MAX(dt_programa_diario.cs_fechas  )
									 FROM dt_programa_diario  
									WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
											( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
											( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
											( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
											( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
											( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
											( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
											( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
											( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
											( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
											( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
											( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
											( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
											( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
											( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) 
									)
							)   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo encontrar informacion ultimo dia programado prioridad anterior")
			ELSE
			END IF
		END IF
	END IF
	
	// trae minutos estandar
	ld_ca_minutos_std=ad_minutos_std
	
	// trae personas por modulo
	ll_personasxmodulo=an_personasxmodulo
	
	// ---------------- fin de traer datos iniciales --------------------------------------//
	
	// ---------------- inicio de procesar datos ------------------------------------------//  
	// hace ciclo para calcular unidades a asignar a diario
	li_dia=0
	DO WHILE ll_unidades_disponibles > 0
		
		li_dia=li_dia + 1
		
		IF li_dia=1 THEN
			IF an_prioridad = 1 THEN
				li_dia_curva=li_dia
			ELSE
				// Verificar si cambia el dia de curva seg$$HEX1$$fa00$$ENDHEX$$n indicador de cambio de estilo y empate autom$$HEX1$$e100$$ENDHEX$$tico=0
				// li_tipo_empate=0:AUTOMATICO, li_iind_camb_est=0:no cambia de estilo
				IF li_tipo_empate=0 AND an_li_ind_camb_est=0 THEN 
					//debe buscar el dia de curva en que termino la anterior asignaci$$HEX1$$f300$$ENDHEX$$n
					li_dia_curva=li_dia_curva_ant 
				ELSE
					li_dia_curva=li_dia
				END IF
			END IF
		ELSE
			li_dia_curva=li_dia_curva + 1
		END IF
		
		//trae % de eficiencia de la tabla dt_curva_eficiencia con an_co_curva y dia
		SELECT dt_curva_eficienci.prc_eficiencia  
			 INTO :ld_porc_eficiencia
			 FROM dt_curva_eficienci  
			WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
					( dt_curva_eficienci.dia_fin 		= :li_dia_curva )   ;
		IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo buscar % eficiencia en curva de un solo Dia")
				RETURN 0
		ELSE
			IF SQLCA.SQLCODE=100 THEN
				SELECT dt_curva_eficienci.prc_eficiencia
					INTO :ld_porc_eficiencia
				 FROM dt_curva_eficienci  
				WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
						( dt_curva_eficienci.dia_fin 		>= :li_dia_curva ) AND  
						( dt_curva_eficienci.dia_inicio 	<= :li_dia_curva )   ;
				IF SQLCA.SQLCODE=-1 THEN
					MessageBox("Error Base datos","No pudo buscar % eficiencia en curva de Varios Dias")
					RETURN 0
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=0 THEN
				ELSE
					MessageBox("Error Base datos","No pudo buscar % eficiencia en curva")
					RETURN 0
				END IF
			END IF
		END IF
		
		//Minutos disponibles
		IF li_dia=1 THEN
		// No Empata
			IF li_tipo_empate=2 THEN 
				ld_minutos_disponibles=ad_minutos_jornada
			ELSE
				ld_minutos_disponibles=ld_ca_min_dispon_ant
			END IF
		ELSE
			ld_minutos_disponibles=ad_minutos_jornada
		END IF

		// UNIDADES POSIBLES
		// Obtiene unidades seg$$HEX1$$fa00$$ENDHEX$$n el tipo de empate para el primer dia
		// estas son las del primer dia 0 autom, 1 manual, 2 no empate
		
		//---------------------- Dia Uno de Programacion ---------------------------------//
		IF li_dia=1 THEN
			  	//automatico o no empata
				IF an_tipo_empate=0  OR an_tipo_empate=2 THEN
					IF ad_minutos_std<=0 THEN
						MessageBox("Error de datos","Los minutos estandar no son mayores que cero")
						RETURN 0
					ELSE
					END IF
					ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
				ELSE
					// Manual, Debe usar unidades Empate digitadas 
					IF an_tipo_empate=1 THEN  
						ll_ca_unid_posibles=an_unidades_empate
					ELSE
						MessageBox("Error datos","Tipo de empate no permitido")
						RETURN 0
					END IF
				END IF
		ELSE
			// Calcula unidades a producir 
			ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
		END IF
	
		// UNIDADES A ASIGNAR
		IF ll_unidades_disponibles >  ll_ca_unid_posibles THEN
			ll_ca_pendiente=ll_ca_unid_posibles
			ld_ca_min_dispon_fin=0
		ELSE
			ll_ca_pendiente=ll_unidades_disponibles
			ld_ca_min_dispon_fin=ld_minutos_disponibles - ((ad_minutos_std * ll_ca_pendiente) / ( an_personasxmodulo)) * (ld_porc_eficiencia/100) 	
		END IF
		// UNIDADES QUE QUEDAN
		ll_ca_unid_dispon_fin=ll_unidades_disponibles - ll_ca_pendiente
			
		li_cs_fechas=li_dia
		
		// --------------- Fecha de Programaci$$HEX1$$f300$$ENDHEX$$n ----------------------------------------- //
		IF li_dia=1 THEN
			// No hay fecha de entrada a produccion
			IF ISNULL(adt_fe_entra_pdn)	THEN
				// Para el dia uno de la primera prioridad no importa tipo de empate
				IF li_cs_prioridad >1 THEN
					// Usa fecha terminacion prioridad anterior
					ldt_fe_inicio=ldt_fe_fin_ant		
					// No Empata
					IF li_tipo_empate=2 THEN
						// Avanza un dia en el Calendario hacia adelante
						li_tipo_avance_calendario=1 
						li_numero_dias=1
						ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
															ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
						IF ISNULL(ld_fe_inicio) THEN
							ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ldt_fe_inicio)
							MessageBox("Error de Datos",ls_mensaje)
							RETURN 0
						ELSE
							ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
						END IF
					ELSE
					END IF
				ELSE
					// Usa fecha inicial de la programacion
					ldt_fe_inicio=adt_fe_inicio_prog	
				END IF						
			ELSE // Hay Fecha de entrada de produccion
				ldt_fe_inicio=adt_fe_entra_pdn
				//debe verificar que la fecha de inicio no halla quedado mayor que la fecha de fin anterior, o sino cambiarla
				IF ldt_fe_inicio > ldt_fe_fin_ant THEN
				ELSE
					ldt_fe_inicio=ldt_fe_fin_ant
					// No Empata
					IF li_tipo_empate=2 THEN 
						// Avanza un dia en el Calendario hacia adelante
						li_tipo_avance_calendario=1 
						li_numero_dias=1
						ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
																ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
						IF ISNULL(ld_fe_inicio) THEN
							ls_mensaje="Por favor verifique fecha Siguiente calendario general:" + STRING(ldt_fe_inicio)
							MessageBox("Error de Datos",ls_mensaje)
							RETURN 0
						ELSE
							ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
						END IF
					ELSE
					END IF		
				END IF
			END IF
			// Lleva fecha final a utilizar a la fecha del dia a programar
			ldt_fe_inicio_prog_tot=ldt_fe_inicio
			
		//---------------------- Dias posteriores a Uno de Programacion ---------------------------------//
		ELSE 				
			// Avanza un dia en el Calendario hacia adelante
			li_tipo_avance_calendario=1
			li_numero_dias=1
			ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
												  ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
			IF ISNULL(ld_fe_inicio) THEN
				ls_mensaje="Por favor verifique fecha Siguiente calendario del m$$HEX1$$f300$$ENDHEX$$dulo:" + STRING(ldt_fe_inicio)
				MessageBox("Error de Datos",ls_mensaje)
				RETURN 0
			ELSE
				ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
			END IF
		END IF
		// fecha de fin de programacion por dia
		ldt_fe_fin=ldt_fe_inicio

		li_co_est_prog_dia=1
		li_fuente_dato=1
		
		ldt_fechahora = f_fecha_servidor()
		ldt_fe_creacion=ldt_fechahora   
		ldt_fe_actualizacion=ldt_fe_creacion

		// ----------------- Actualizacion de Datos Calculados ---------------------------- //
		// -------------------------------------------------------------------------------- //
		// Nota : Se debe definir manejo de tabla de simulaciones de programacion para no   //
		//        comparaciones fijas.																		//
		// -------------------------------------------------------------------------------- //
		// Allocations
		IF an_co_tipo_asignacion=1  THEN 
			ll_ca_proyectada	=ll_ca_pendiente	
		ELSE
		   ll_ca_actual		=ll_ca_pendiente
		END IF
		
		// Actualiza la tabla Programacion diaria
		INSERT INTO dt_programa_diario  
				( simulacion,   
				  co_fabrica,   
				  co_planta,   
				  co_modulo,   
				  co_fabrica_exp,   
				  pedido,   
				  cs_liberacion,   
				  po,   
				  co_fabrica_pt,   
				  co_linea,   
				  co_referencia,   
				  co_color_pt,   
				  tono,   
				  cs_estilocolortono,   
				  cs_particion,   
				  cs_fechas,   
				  fe_inicio,   
				  ca_unid_dispon_ini,   
				  ca_min_dispon_ini,   
				  ca_unid_dispon_fin,   
				  ca_min_dispon_fin,   
				  personasxmodulo, 
				  dia_curva,
				  porc_eficiencia,   
				  ca_unid_posibles,   
				  duracion,   
				  fe_fin,   
				  ca_programada,   
				  ca_producida,   
				  ca_pendiente,   
				  co_est_prog_dia,   
				  fuente_dato,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia,
				  ca_proyectada,
				  ca_actual,
				  ca_numerada)  
	  VALUES ( :an_simulacion,   
				  :an_fabrica_modulo,   
				  :an_planta_modulo,   
				  :an_modulo,   
				  :an_co_fabrica_exp,   
				  :an_pedido,   
				  :an_cs_liberacion,   
				  :as_po,   
				  :an_co_fabrica_ref,   
				  :an_co_linea_ref,   
				  :an_co_referencia,   
				  :an_color_pt,   
				  :as_tono,   
				  :an_cs_estilocolortono,   
				  :an_cs_particion,   
				  :li_cs_fechas,   
				  :ldt_fe_inicio,   
				  :ll_unidades_disponibles, 
				  :ld_minutos_disponibles, 
				  :ll_ca_unid_dispon_fin, 
				  :ld_ca_min_dispon_fin, 
				  :an_personasxmodulo, 
				  :li_dia_curva,
				  :ld_porc_eficiencia, 
				  :ll_ca_unid_posibles,   
				  :li_duracion, 
				  :ldt_fe_fin,   
				  :ll_ca_pendiente,   
				  0,   
				  :ll_ca_pendiente,   
				  :li_co_est_prog_dia,   
				  :li_fuente_dato,   
				  :ldt_fe_creacion,   
				  :ldt_fe_actualizacion,   
				  :gstr_info_usuario.codigo_usuario,   
				  :gstr_info_usuario.instancia,
				  :ll_ca_proyectada,
				  :ll_ca_actual,
				  0)  ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo insertar unidades en dias")
			RETURN 0
		ELSE
		END IF
		// ----------------------- Fin Actualizacion Datos Calculados --------------------- //
		
		ll_unidades_disponibles=ll_unidades_disponibles - ll_ca_pendiente
	
	LOOP		// de DO WHILE ll_unidades_disponibles > 0

	// Calcula fecha de despacho con base en ultimo dia programado 
	// ---------------------------------------------------------------------------
	// Nota : Queda pendiente definir de donde se tomaran los dias de despacho
	// por fabrica, para que no sean estaticos.
	// ---------------------------------------------------------------------------
	
	ldt_fe_fin_prog_tot=ldt_fe_fin
	
	IF NOT isnull(ldt_fe_fin_prog_tot) THEN		
			ls_nombre_dia = UPPER(string(ldt_fe_fin_prog_tot, "ddd"))
			ld_fecha_despacho = date(ldt_fe_fin_prog_tot)
			CHOOSE CASE ls_nombre_dia
				CASE 'MON'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)				
				CASE 'TUE'				
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 4)
				CASE 'WED'				
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)	
				CASE 'THU'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
				CASE 'FRI'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)
				CASE 'SAT'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)
				CASE 'SUN'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
			END CHOOSE				
	END IF
	
	ldt_fe_calculada_despacho=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))
	
	// Actualiza archivo de Parametros de programacion 
	UPDATE dt_pdnxmodulo  
		  SET fe_inicio_prog 	= :ldt_fe_inicio_prog_tot,   
				fe_fin_prog 		= :ldt_fe_fin_prog_tot,
				fe_requerida_desp	= :ldt_fe_calculada_despacho
		WHERE ( dt_pdnxmodulo.simulacion 			= :an_simulacion ) 			AND  
				( dt_pdnxmodulo.co_fabrica 			= :an_fabrica_modulo ) 		AND  
				( dt_pdnxmodulo.co_planta 				= :an_planta_modulo ) 		AND  
				( dt_pdnxmodulo.co_modulo 				= :an_modulo ) 				AND  
				( dt_pdnxmodulo.co_fabrica_exp 		= :an_co_fabrica_exp) 		AND  
				( dt_pdnxmodulo.pedido 					= :an_pedido ) 				AND  
				( dt_pdnxmodulo.cs_liberacion 		= :an_cs_liberacion ) 		AND  
				( dt_pdnxmodulo.po 						= :as_po ) 						AND  
				( dt_pdnxmodulo.co_fabrica_pt 		= :an_co_fabrica_ref ) 		AND  
				( dt_pdnxmodulo.co_linea 				= :an_co_linea_ref ) 		AND  
				( dt_pdnxmodulo.co_referencia 		= :an_co_referencia ) 		AND  
				( dt_pdnxmodulo.co_color_pt 			= :an_color_pt ) 				AND  
				( dt_pdnxmodulo.tono 					= :as_tono ) 					AND  
				( dt_pdnxmodulo.cs_estilocolortono 	= :an_cs_estilocolortono ) AND  
				( dt_pdnxmodulo.cs_particion 			= :an_cs_particion  )   ;
				
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox("Error Base Datos","No pudo Actualizar fechas de inicio y fin de asignaci$$HEX1$$f300$$ENDHEX$$n")
			RETURN 0
		ELSE
		END IF
	RETURN 1 
	
//----------------***  PROGRAMACION HACIA ATRAS ***-----------------------------//

ELSE		// de IF ISNULL(adt_fe_prog_desp)

// inicio para atr$$HEX1$$e100$$ENDHEX$$s 
	ldt_fe_calculada_despacho	=	adt_fe_prog_desp
	ldt_fe_fin_prog_tot			=	adt_fe_prog_desp
	
	// Busca ultima fecha de programacion con base en fecha de despacho digitada
	// ---------------------------------------------------------------------------
	// Nota : Queda pendiente definir de donde se tomaran los dias de despacho
	// por fabrica, para que no sean estaticos.
	// ---------------------------------------------------------------------------
	
	IF NOT isnull(ldt_fe_fin_prog_tot) THEN		
			ls_nombre_dia = UPPER(string(ldt_fe_fin_prog_tot, "ddd"))
			ld_fecha_despacho = date(ldt_fe_fin_prog_tot)
			CHOOSE CASE ls_nombre_dia
				CASE 'MON'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -5)				
				CASE 'TUE'				
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -6)
				CASE 'WED'				
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -7)	
				CASE 'THU'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -5)
				CASE 'FRI'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -6)
				CASE 'SAT'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -7)
				CASE 'SUN'
					ld_fecha_despacho = Relativedate(ld_fecha_despacho, -4)
			END CHOOSE				
	END IF

	ldt_fe_fin_prog_tot=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))
	
	// Valida Fecha Fin costura Calculada           
	IF ISNULL(ldt_fe_fin_prog_tot) THEN
		MessageBox("Error datos","Es nula Fecha Fin Costura calculada segun Fecha Programada de Despacho")
		RETURN 0
	ELSE	
		
		li_anno=year(date(ldt_fe_fin_prog_tot))
		li_mes=month(date(ldt_fe_fin_prog_tot))
		li_dia_fec=day(date(ldt_fe_fin_prog_tot))
		
		// busca si la fecha calculada ultima programacion est$$HEX2$$e1002000$$ENDHEX$$en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo
		SELECT dt_mod_calendario.co_tipo_dia  
		 INTO :ls_co_tipo_dia  
		 FROM dt_mod_calendario  
		WHERE ( dt_mod_calendario.co_fabrica 	=:an_fabrica_modulo ) 	AND  
				( dt_mod_calendario.co_planta 	=:an_planta_modulo  ) 	AND  
				( dt_mod_calendario.co_modulo 	=:an_modulo  ) 			AND  
				( dt_mod_calendario.ano 			=:li_anno  ) 					AND  
				( dt_mod_calendario.mes 			=:li_mes ) 						AND  
				( dt_mod_calendario.dia 			=:li_dia_fec);
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error base datos","No Encontro en calendario por m$$HEX1$$f300$$ENDHEX$$dulo, Fecha Fin Costura Calculada segun Fecha Programada de Despacho")
			RETURN 0
		ELSE
			IF SQLCA.SQLCODE=0 THEN
				IF MID(ls_co_tipo_dia,1,1)<>"T" THEN
					MessageBox("Error datos","Fecha Fin Costura Calculada segun Fecha Programada de Despacho, no es un dia de trabajo en Calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
					RETURN 0
				ELSE
				END IF		
			ELSE
			END IF
		END IF
	END IF
	
	// Trae unidades disponibles
	ll_unidades_disponibles=an_unidades
	ld_ca_min_dispon_ant=ad_minutos_jornada
	ldt_fe_fin_ant=ldt_fe_fin_prog_tot  
	li_cs_prioridad=an_prioridad
	li_tipo_empate=an_tipo_empate
	
	// Trae minutos estandar
	ld_ca_minutos_std=ad_minutos_std
	
	// Trae personas por modulo
	ll_personasxmodulo=an_personasxmodulo
	
	// Inicio de ciclo por dia
	li_dia=0
	DO WHILE ll_unidades_disponibles > 0
		
		li_dia=li_dia + 1
	
		IF li_dia=1 THEN
			IF an_prioridad = 1 THEN
				li_dia_curva=li_dia
			ELSE
				// Verificar si cambia el dia de curva seg$$HEX1$$fa00$$ENDHEX$$n indicador de cambio de estilo y empate autom$$HEX1$$e100$$ENDHEX$$tico=0
				IF li_tipo_empate=0 AND an_li_ind_camb_est=0 THEN // li_tipo_empate=0:AUTOMATICO, li_iind_camb_est=0:no cambia de estilo
					// Debe buscar el dia de curva en que termino la anterior asignaci$$HEX1$$f300$$ENDHEX$$n
					li_dia_curva=li_dia_curva_ant 
				ELSE
					li_dia_curva=li_dia
				END IF
			END IF
		ELSE
			li_dia_curva=li_dia_curva + 1
		END IF
		
		// Trae % de eficiencia de la tabla dt_curva_eficiencia con an_co_curva y dia
		SELECT dt_curva_eficienci.prc_eficiencia  
			 INTO :ld_porc_eficiencia
			 FROM dt_curva_eficienci  
			WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
					( dt_curva_eficienci.dia_fin 		= :li_dia_curva )   ;
		IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo buscar % eficiencia en curva de un solo Dia")
				RETURN 0
		ELSE
			IF SQLCA.SQLCODE=100 THEN
				SELECT dt_curva_eficienci.prc_eficiencia
					INTO :ld_porc_eficiencia
				 FROM dt_curva_eficienci  
				WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
						( dt_curva_eficienci.dia_fin 		>= :li_dia_curva ) AND  
						( dt_curva_eficienci.dia_inicio 	<= :li_dia_curva )   ;
				IF SQLCA.SQLCODE=-1 THEN
					MessageBox("Error Base datos","No pudo buscar % eficiencia en curva de varios Dias")
					RETURN 0
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=0 THEN
				ELSE
					MessageBox("Error Base datos","No pudo buscar % eficiencia en curva")
					RETURN 0
				END IF
			END IF
		END IF
		
		ld_minutos_disponibles=ad_minutos_jornada
		
		// UNIDADES POSIBLES
		ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
		
		// UNIDADES A ASIGNAR
		IF ll_unidades_disponibles >  ll_ca_unid_posibles THEN
			ll_ca_pendiente=ll_ca_unid_posibles
			ld_ca_min_dispon_fin=0
		ELSE
			ll_ca_pendiente=ll_unidades_disponibles
			ld_ca_min_dispon_fin=ld_minutos_disponibles - ((ad_minutos_std * ll_ca_pendiente) / ( an_personasxmodulo)) * (ld_porc_eficiencia/100) 	
		END IF
		
		// UNIDADES QUE QUEDAN
		ll_ca_unid_dispon_fin=ll_unidades_disponibles - ll_ca_pendiente
		
		li_cs_fechas=li_dia
		
		// Fecha de fin de programaci$$HEX1$$f300$$ENDHEX$$n
		IF li_dia=1 THEN
			ldt_fe_fin=ldt_fe_fin_prog_tot
			IF ISNULL(adt_fe_inicio_prog) THEN
				MessageBox("Error de Datos","Para la primera asignaci$$HEX1$$f300$$ENDHEX$$n debe tener fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n")
				RETURN 0
			ELSE
			END IF						
		ELSE
			// Retrocede un dia en el Calendario hacia atras
			li_tipo_avance_calendario=2 
			li_numero_dias=1
			ld_fe_fin=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
												  ldt_fe_fin,li_numero_dias,li_tipo_avance_calendario)
			IF ISNULL(ld_fe_fin) THEN
				ls_mensaje="Por favor verifique fecha Anterior calendario del m$$HEX1$$f300$$ENDHEX$$dulo:" + STRING(ldt_fe_fin)
				MessageBox("Error de Datos",ls_mensaje)
				RETURN 0
			ELSE
				ldt_fe_fin=datetime(ld_fe_fin, time(ldt_fe_fin))
			END IF
		END IF
		
		// Fecha de inicio de programacion por dia
		ldt_fe_inicio=ldt_fe_fin	
		
		li_co_est_prog_dia=1
		li_fuente_dato=1
		
		ldt_fechahora = f_fecha_servidor()
		ldt_fe_creacion=ldt_fechahora   
		ldt_fe_actualizacion=ldt_fe_creacion
				
		ll_unidades_disponibles=ll_unidades_disponibles - ll_ca_pendiente
	
	LOOP	// 	DO WHILE ll_unidades_disponibles > 0
	
	// Lleva Fecha inicio Programacion Calculada
	// ----------------------------------------------------------------------------------- //
	// Nota : Verificar si esta fecha si esta siendo usada como fecha entrada a produccion //
	//        en el siguiente ciclo                                                        //
	// ----------------------------------------------------------------------------------- //
	ldt_fe_inicio_prog_tot=ldt_fe_inicio
	idt_fe_inicio_prog_tot=ldt_fe_inicio

	// Actualiza archivo de Parametros de programacion 
	UPDATE dt_pdnxmodulo  
		  SET fe_entra_pdn	= :ldt_fe_inicio_prog_tot
		WHERE ( dt_pdnxmodulo.simulacion 			= :an_simulacion ) 			AND  
				( dt_pdnxmodulo.co_fabrica 			= :an_fabrica_modulo ) 		AND  
				( dt_pdnxmodulo.co_planta 				= :an_planta_modulo ) 		AND  
				( dt_pdnxmodulo.co_modulo 				= :an_modulo ) 				AND  
				( dt_pdnxmodulo.co_fabrica_exp 		= :an_co_fabrica_exp) 		AND  
				( dt_pdnxmodulo.pedido 					= :an_pedido ) 				AND  
				( dt_pdnxmodulo.cs_liberacion 		= :an_cs_liberacion ) 		AND  
				( dt_pdnxmodulo.po 						= :as_po ) 						AND  
				( dt_pdnxmodulo.co_fabrica_pt 		= :an_co_fabrica_ref ) 		AND  
				( dt_pdnxmodulo.co_linea 				= :an_co_linea_ref ) 		AND  
				( dt_pdnxmodulo.co_referencia 		= :an_co_referencia ) 		AND  
				( dt_pdnxmodulo.co_color_pt 			= :an_color_pt ) 				AND  
				( dt_pdnxmodulo.tono 					= :as_tono ) 					AND  
				( dt_pdnxmodulo.cs_estilocolortono 	= :an_cs_estilocolortono ) AND  
				( dt_pdnxmodulo.cs_particion 			= :an_cs_particion  )   ;
				
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox("Error Base Datos","No pudo Actualizar fechas de inicio y fin de asignaci$$HEX1$$f300$$ENDHEX$$n")
			RETURN 0
		ELSE
		END IF
	
	RETURN 1 
END IF 

end function

on w_parametros_asignacion.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_parametros_asignacion" then this.MenuID = create m_mantenimiento_parametros_asignacion
end on

on w_parametros_asignacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Long 					ll_fila,ll_hallados
DateTime 			ldt_fechahora
Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion
s_base_parametros lstr_parametros
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion,li_cs_prioridad,li_cs_prioridad_ant
STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido

LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog,ldt_fe_fin_programa
DECIMAL				ld_ca_minutos_std,ld_ca_minutos_disp

This.width =3616
This.height =1940

ids_confeccion = Create DataStore

ids_confeccion.DataObject = 'd_replicacion_confeccion'
ids_confeccion.SetTransObject(Sqlca)

lstr_parametros	=	Message.PowerObjectParm
	
IF lstr_parametros.hay_parametros THEN

	li_simulacion			=lstr_parametros.entero[1]
	li_co_fabrica_modulo	=lstr_parametros.entero[2]
	li_co_planta_modulo	=lstr_parametros.entero[3]
	li_co_modulo			=lstr_parametros.entero[4]	
	li_co_fabrica_exp		=lstr_parametros.entero[5]	
	ll_pedido				=lstr_parametros.entero[6]
	ll_cs_liberacion		=lstr_parametros.entero[7]
	ls_nu_orden				=lstr_parametros.cadena[1]
	li_co_fabrica_ref		=lstr_parametros.entero[8]
	li_co_linea_ref		=lstr_parametros.entero[9]
	ll_co_referencia		=lstr_parametros.entero[10]
	ll_color_pt				=lstr_parametros.entero[11]
	ls_tono					=lstr_parametros.cadena[2]
	li_cs_estilocolortono=lstr_parametros.entero[12]
	li_cs_particion		=lstr_parametros.entero[13]	


		IF ISNULL(li_simulacion) OR ISNULL(li_co_fabrica_modulo) OR ISNULL(li_co_planta_modulo) OR&
			ISNULL(li_co_modulo) OR ISNULL(li_co_fabrica_exp) OR ISNULL(ll_pedido) OR&
			ISNULL(ll_cs_liberacion) OR ISNULL(ls_nu_orden) OR ISNULL(li_co_fabrica_ref) OR&
			ISNULL(li_co_linea_ref) OR ISNULL(ll_color_pt) OR ISNULL(ls_tono) OR&
			ISNULL(li_cs_estilocolortono) OR ISNULL(li_cs_particion) THEN
			
			MessageBox("Error ","Existen datos nulos la ventana de modulo")
			
			RETURN
		ELSE
			ll_hallados = dw_maestro.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
														 li_co_modulo,li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
														 ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
														 ll_color_pt,ls_tono,&
														 li_cs_estilocolortono,li_cs_particion)
			IF isnull(ll_hallados) THEN
				MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
			ELSE
				CHOOSE CASE ll_hallados
					CASE -1
						il_fila_actual_maestro = -1
						MessageBox("Error buscando","Error de la base",StopSign!,&
	                         Ok!)
					CASE 0
						il_fila_actual_maestro = 0
						MessageBox("Sin Datos","No hay datos para su criterio",&
	                         Exclamation!,Ok!)
					CASE ELSE
						il_fila_actual_maestro = 1
												
						li_cs_prioridad	=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_prioridad")
						ldt_fe_inicio_prog=dw_maestro.GetitemDateTime(il_fila_actual_maestro,"fe_inicio_prog")
						
						IF ISNULL(ldt_fe_inicio_prog) THEN
							
							IF li_cs_prioridad=1 THEN
								ldt_fe_inicio_prog=f_fecha_servidor()
							ELSE
								li_cs_prioridad_ant=li_cs_prioridad - 1
								//traiga el fin de la asignacion del dia anterior
								SELECT dt_pdnxmodulo.fe_fin_prog  
								 INTO :ldt_fe_fin_programa  
								 FROM dt_pdnxmodulo  
								WHERE ( dt_pdnxmodulo.simulacion 			=:li_simulacion  ) AND  
										( dt_pdnxmodulo.co_fabrica 			=:li_co_fabrica_modulo  ) AND  
										( dt_pdnxmodulo.co_planta 				=:li_co_planta_modulo  ) AND  
										( dt_pdnxmodulo.co_modulo 				=:li_co_modulo  ) AND  
										( dt_pdnxmodulo.cs_prioridad 			=:li_cs_prioridad_ant  )   ;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo buscar fecha de fin de prioridad anterior")
									RETURN
								ELSE
									ldt_fe_inicio_prog=ldt_fe_fin_programa
								END IF
							END IF
							dw_maestro.setitem(il_fila_actual_maestro,"fe_inicio_prog",ldt_fe_inicio_prog)
							
						ELSE
							//tiene fecha de prog inicial 
						END IF
							
						//carga los otros datos que le faltaron en el insert detalle
						dw_maestro.SetItem(il_fila_actual_detalle,"tipo_fe_prog", 		1) //fecha de inicio
						dw_maestro.SetItem(il_fila_actual_detalle,"indicativo_base", 	1) //ingenier$$HEX1$$ed00$$ENDHEX$$a
						dw_maestro.SetItem(il_fila_actual_detalle,"ca_base_dia_prod", 	0)
						dw_maestro.SetItem(il_fila_actual_detalle,"ca_base_dia_prog", 	0)
						dw_maestro.SetItem(il_fila_actual_detalle,"ca_a_programar", 	0)
						
						ll_hallados = dw_detalle.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
														 li_co_modulo,li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
														 ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
														 ll_color_pt,ls_tono,&
														 li_cs_estilocolortono,li_cs_particion)
						IF isnull(ll_hallados) THEN
							MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
						ELSE
							CHOOSE CASE ll_hallados
								CASE -1
									il_fila_actual_detalle = -1
									MessageBox("Error buscando","Error de la base",StopSign!,&
												 Ok!)
								CASE 0
									il_fila_actual_detalle = 0
//									MessageBox("Sin Datos","No hay datos para su criterio",&
//												 Exclamation!,Ok!)
								CASE ELSE
									il_fila_actual_detalle = 1
									
							END CHOOSE
						END IF
				END CHOOSE
			END IF
		END IF 	
	ELSE
		li_simulacion			=0
		li_co_fabrica_modulo	=0
		li_co_planta_modulo	=0
		li_co_modulo			=0	
		li_co_fabrica_exp		=0
		ll_pedido				=0
		ll_cs_liberacion		=0
		ls_nu_orden				=""
		li_co_fabrica_ref		=0
		li_co_linea_ref		=0
		ll_co_referencia		=0
		ll_color_pt				=0
		ls_tono					=""
		li_cs_estilocolortono=0
		li_cs_particion		=0	
	END IF


end event

event ue_insertar_detalle;call super::ue_insertar_detalle;Long 					ll_fila,ll_hallados
DateTime 			ldt_fechahora
Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
s_base_parametros lstr_parametros
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido

LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate,ll_ca_asignadas_maestro,ll_fila_anterior
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_co_est_prog_dia,li_duracion,li_cs_prioridad
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia
LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_personasxmodulo,ll_ca_unid_posibles

IF il_fila_actual_maestro > 0 THEN
	li_simulacion 				= dw_maestro.GetitemNumber(il_fila_actual_maestro,"simulacion")
	li_co_fabrica_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
	li_co_planta_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
	li_co_modulo	 			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_modulo")
	li_co_fabrica_exp 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_exp")
	ll_pedido 					= dw_maestro.GetitemNumber(il_fila_actual_maestro,"pedido")
	ll_cs_liberacion 			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_liberacion")
	ls_nu_orden 				= dw_maestro.GetitemString(il_fila_actual_maestro,"po")
	li_co_fabrica_ref 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_pt")
	li_co_linea_ref 			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_linea")
	ll_co_referencia 			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_referencia")
	ll_color_pt 				= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_color_pt")
	ls_tono 						= dw_maestro.GetitemString(il_fila_actual_maestro,"tono")
	li_cs_estilocolton 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_estilocolortono")
	li_cs_particion 			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_particion")
	ll_personasxmodulo		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_personasxmod")
	li_cs_prioridad			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_prioridad")
	ll_ca_asignadas_maestro	= dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_pendiente")
	li_metodo_programa		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"metodo_programa")
	ll_ca_unidad_base_dia	= dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_unid_base_dia")
		
	IF li_metodo_programa=1 THEN
		MessageBox("Advertencia","No puede insertar detalle por el metodo de eficiencia dia")
		RETURN
	ELSE
	END IF
	IF IsNull(li_simulacion) OR IsNull(li_co_fabrica_modu) OR IsNull(li_co_fabrica_modu) OR&
		IsNull(li_co_modulo) OR IsNull(li_co_fabrica_exp) OR IsNull(ll_pedido) OR &
		IsNull(ll_cs_liberacion) OR IsNull(ls_nu_orden) OR IsNull(li_co_fabrica_ref) OR&
		IsNull(li_co_linea_ref) OR IsNull(ll_co_referencia) OR IsNull(ll_color_pt) OR&
		IsNull(ls_tono) OR IsNull(li_cs_estilocolton) OR IsNull(li_cs_particion) &
		THEN
		dw_detalle.DeleteRow(il_fila_actual_detalle)
		il_fila_actual_detalle = il_fila_actual_detalle - 1
	ELSE
		ll_ca_programada		=0
		ll_ca_producida		=0
		li_fuente_dato			=1
		li_co_est_prog_dia	=1

		ldt_fe_fin_prog		=ldt_fechahora
		
		IF il_fila_actual_detalle=1 THEN
			ll_ca_unid_dispon_ini=ll_ca_asignadas_maestro
		ELSE
			IF il_fila_actual_detalle > 1 THEN
				ll_fila_anterior=il_fila_actual_detalle - 1
				ll_ca_unid_dispon_ini=dw_detalle.GetitemNumber(ll_fila_anterior,"ca_unid_dispon_fin")
			ELSE
				MessageBox("Error datawindow","No tiene filas para calcular unidades anteriores")
				RETURN
			END IF
		END IF
		//coloca fecha inicial y minutos disponibles
		IF il_fila_actual_detalle=1 THEN
			ldt_fe_inicio_prog=dw_maestro.GetitemDateTime(1,"fe_inicio_prog")
		ELSE 
			ldt_fe_inicio_prog=dw_detalle.GetitemDateTime((il_fila_actual_detalle -1),"fe_fin")
		END IF
				
		ld_ca_min_dispon_ini=dw_maestro.GetitemDecimal(1,"minutos_jornada")
		
		ld_ca_minutos_std=dw_maestro.GetitemDecimal(1,"ca_minutos_std")
		
		ll_ca_unid_posibles=ll_ca_unidad_base_dia
		
		ll_ca_unid_dispon_fin=0
		ll_ca_min_dispon_fin=0
		ld_porc_eficiencia=0
		li_duracion=0
		
		
		dw_detalle.SetItem(il_fila_actual_detalle,"simulacion",li_simulacion)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica",li_co_fabrica_modu)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_planta",li_co_planta_modu)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_modulo",li_co_modulo)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica_exp",li_co_fabrica_exp)
		dw_detalle.SetItem(il_fila_actual_detalle,"pedido",ll_pedido)
		dw_detalle.SetItem(il_fila_actual_detalle,"cs_liberacion",ll_cs_liberacion)
		dw_detalle.SetItem(il_fila_actual_detalle,"po",ls_nu_orden)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica_pt",li_co_fabrica_ref)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_linea",li_co_linea_ref)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_referencia",ll_co_referencia)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_color_pt",ll_color_pt)
		dw_detalle.SetItem(il_fila_actual_detalle,"tono",ls_tono)
		dw_detalle.SetItem(il_fila_actual_detalle,"cs_estilocolortono",li_cs_estilocolton)
		dw_detalle.SetItem(il_fila_actual_detalle,"cs_particion",li_cs_particion)
		dw_detalle.SetItem(il_fila_actual_detalle,"cs_fechas",il_fila_actual_detalle)
		
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_programada",ll_ca_programada)
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_producida",ll_ca_producida)
		dw_detalle.SetItem(il_fila_actual_detalle,"fuente_dato",li_fuente_dato)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_est_prog_dia",li_co_est_prog_dia)
		dw_detalle.SetItem(il_fila_actual_detalle,"fe_inicio",ldt_fe_inicio_prog)
		
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_unid_dispon_ini",ll_ca_unid_dispon_ini)
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_min_dispon_ini",ld_ca_min_dispon_ini)
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_unid_dispon_fin",ll_ca_unid_dispon_fin)
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_min_dispon_fin",ll_ca_min_dispon_fin)
		dw_detalle.SetItem(il_fila_actual_detalle,"personasxmodulo",ll_personasxmodulo)
		dw_detalle.SetItem(il_fila_actual_detalle,"porc_eficiencia",ld_porc_eficiencia)
		dw_detalle.SetItem(il_fila_actual_detalle,"ca_unid_posibles",ll_ca_unid_posibles)
		dw_detalle.SetItem(il_fila_actual_detalle,"duracion",li_duracion)
		
		dw_detalle.SetItem(il_fila_actual_detalle,"fe_fin",ldt_fe_fin_prog)
							
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", ldt_fechahora)
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_actualizacion", ldt_fechahora)
		dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
		dw_detalle.SetItem(il_fila_actual_detalle, "instancia", gstr_info_usuario.instancia)
		
		dw_detalle.AcceptText()
		ii_insertando_det=1
	END IF
END IF






end event

event ue_buscar;//nada
end event

event ue_borrar_detalle;long ll_fila

ll_fila = dw_detalle.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
			ELSE
				il_fila_actual_detalle = ll_fila - 1
				ii_borrando_detalle=1
				This.TriggerEvent("ue_grabar")
				ii_borrando_detalle=0
			END IF
		ELSE
		END IF
END CHOOSE



end event

event closequery;call super::closequery;
Destroy ids_confeccion
end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_parametros_asignacion
integer x = 0
integer y = 4
integer width = 3593
integer height = 1008
boolean titlebar = false
string dataobject = "dff_parametros_asignacion"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
end type

event dw_maestro::itemchanged;call super::itemchanged;Long 					ll_fila,ll_hallados
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate

Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_anno,li_mes,li_dia

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_co_tipo_dia,ls_fe_inicio_prog

DateTime 			ldt_fechahora
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog

DATE					ld_fe_calendario

s_base_parametros lstr_parametros

dw_maestro.AcceptText()

IF il_fila_actual_maestro > 0 THEN

	IF Dwo.Name = "orige_uni_base_dia" THEN
		
		li_orige_uni_base_dia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "orige_uni_base_dia")
		li_co_planta_modulo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta")
		li_co_fabrica_ref = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica_pt")
		li_co_linea_ref = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
		ll_co_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
		
		IF li_orige_uni_base_dia= 1 THEN //INGENIERIA
			//buscar los minutos en m_estandares
			SELECT sum(m_estandares.tiempo_st) 
			 INTO :ld_ca_minutos_std
			 FROM m_estandares  
			WHERE ( m_estandares.co_planta 			= :li_co_planta_modulo ) AND  
					( m_estandares.co_fabrica 			= :li_co_fabrica_ref ) AND  
					( m_estandares.co_linea 			= :li_co_linea_ref ) AND  
					( m_estandares.co_referencia 		= :ll_co_referencia ) AND  
					( m_estandares.co_centro_pdn 		= 2 ) AND  //COSTURA
					( m_estandares.co_subcentro_pdn 	= 2 )   ;//ENSAMBLE
					
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo buscar minutos estandar")
			ELSE
				IF ISNULL(ld_ca_minutos_std) OR ld_ca_minutos_std=0 THEN
					MessageBox("Error datos","No hall$$HEX2$$f3002000$$ENDHEX$$minutos estandar")
				ELSE
					This.SetItem(il_fila_actual_maestro, "ca_minutos_std", ld_ca_minutos_std)
				END IF
			END IF
		ELSE
		END IF
		
	END IF
	
	IF Dwo.Name = "cod_tur" THEN
		li_cod_tur = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cod_tur")
		ld_minutos_jornada = dw_maestro.GetItemNumber(il_fila_actual_maestro, "minutos_jornada")
		ld_ca_minutos_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_minutos_std")
		ll_ca_personasxmod = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_personasxmod")
		
		IF (ISNULL(ld_ca_minutos_std)) OR (ld_ca_minutos_std<=0) THEN
			MessageBox("Error de datos","Minutos estandar no validos")
			RETURN 1
		ELSE
			
		END IF
		
		IF (ISNULL(ll_ca_personasxmod)) OR (ll_ca_personasxmod<=0) THEN
			MessageBox("Error de datos","Personas por m$$HEX1$$f300$$ENDHEX$$dulos no validas")
			RETURN 1
		ELSE
			
		END IF
	
		ll_ca_unidad_base_dia = (ld_minutos_jornada / ld_ca_minutos_std) * ll_ca_personasxmod
		
		This.SetItem(il_fila_actual_maestro, "ca_unid_base_dia", ll_ca_unidad_base_dia)
		
	END IF
	
	IF Dwo.Name = "ca_personasxmod" THEN
		li_cod_tur = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cod_tur")
		ld_minutos_jornada = dw_maestro.GetItemNumber(il_fila_actual_maestro, "minutos_jornada")
		ld_ca_minutos_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_minutos_std")
		ll_ca_personasxmod = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_personasxmod")
		
		IF (ISNULL(ld_ca_minutos_std)) OR (ld_ca_minutos_std<=0) THEN
			MessageBox("Error de datos","Minutos estandar no validos")
			RETURN 1
		ELSE
			
		END IF
		
		IF (ISNULL(ll_ca_personasxmod)) OR (ll_ca_personasxmod<=0) THEN
			MessageBox("Error de datos","Personas por m$$HEX1$$f300$$ENDHEX$$dulos no validas")
			RETURN 1
		ELSE
		END IF
		
		IF (ISNULL(ld_minutos_jornada)) OR (ld_minutos_jornada<=0) THEN
			MessageBox("Error de datos","Minutos de la jornada no validos")
			RETURN 1
		ELSE
		END IF
	
		ll_ca_unidad_base_dia = (ld_minutos_jornada / ld_ca_minutos_std) * ll_ca_personasxmod
		
		This.SetItem(il_fila_actual_maestro, "ca_unid_base_dia", ll_ca_unidad_base_dia)
		
	END IF
	
	IF Dwo.Name = "minutos_jornada" THEN
		li_cod_tur = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cod_tur")
		ld_minutos_jornada = dw_maestro.GetItemNumber(il_fila_actual_maestro, "minutos_jornada")
		ld_ca_minutos_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_minutos_std")
		ll_ca_personasxmod = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_personasxmod")
		
		IF (ISNULL(ld_ca_minutos_std)) OR (ld_ca_minutos_std<=0) THEN
			MessageBox("Error de datos","Minutos estandar no validos")
			RETURN 1
		ELSE
			
		END IF
		
		IF (ISNULL(ll_ca_personasxmod)) OR (ll_ca_personasxmod<=0) THEN
			MessageBox("Error de datos","Personas por m$$HEX1$$f300$$ENDHEX$$dulos no validas")
			RETURN 1
		ELSE
		END IF
		IF (ISNULL(ld_minutos_jornada)) OR (ld_minutos_jornada<=0) THEN
			MessageBox("Error de datos","Minutos de la jornada no validos")
			RETURN 1
		ELSE
		END IF
	
		ll_ca_unidad_base_dia = (ld_minutos_jornada / ld_ca_minutos_std) * ll_ca_personasxmod
		
		This.SetItem(il_fila_actual_maestro, "ca_unid_base_dia", ll_ca_unidad_base_dia)
		
	END IF
	
	IF Dwo.Name = "ca_minutos_std" THEN
		li_cod_tur = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cod_tur")
		ld_minutos_jornada = dw_maestro.GetItemNumber(il_fila_actual_maestro, "minutos_jornada")
		ld_ca_minutos_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_minutos_std")
		ll_ca_personasxmod = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_personasxmod")
		
		IF (ISNULL(ld_ca_minutos_std)) OR (ld_ca_minutos_std<=0) THEN
			MessageBox("Error de datos","Minutos estandar no validos")
			RETURN 1
		ELSE
			
		END IF
		
		IF (ISNULL(ll_ca_personasxmod)) OR (ll_ca_personasxmod<=0) THEN
			MessageBox("Error de datos","Personas por m$$HEX1$$f300$$ENDHEX$$dulos no validas")
			RETURN 1
		ELSE
		END IF
		IF (ISNULL(ld_minutos_jornada)) OR (ld_minutos_jornada<=0) THEN
			MessageBox("Error de datos","Minutos de la jornada no validos")
			RETURN 1
		ELSE
		END IF
	
		ll_ca_unidad_base_dia = (ld_minutos_jornada / ld_ca_minutos_std) * ll_ca_personasxmod
		
		This.SetItem(il_fila_actual_maestro, "ca_unid_base_dia", ll_ca_unidad_base_dia)
		
	END IF

	// ----------- Si no hay minutos y hay unidades base, 
	// ----------- calcula los minutos con las unidades
	IF Dwo.Name = "ca_base_dia_prog" THEN
		li_cod_tur = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cod_tur")
		ld_minutos_jornada = dw_maestro.GetItemNumber(il_fila_actual_maestro, "minutos_jornada")
		ld_ca_minutos_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_minutos_std")
		ll_ca_personasxmod = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_personasxmod")
		ll_ca_unidad_base_dia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_base_dia_prog")
		
		IF (ISNULL(ld_ca_minutos_std)) OR (ld_ca_minutos_std<=0) THEN
			IF (ISNULL(ll_ca_personasxmod)) OR (ll_ca_personasxmod<=0) THEN
				MessageBox("Error de datos","Personas por m$$HEX1$$f300$$ENDHEX$$dulos no validas")
				RETURN 1
			ELSE
			END IF
			IF (ISNULL(ld_minutos_jornada)) OR (ld_minutos_jornada<=0) THEN
				MessageBox("Error de datos","Minutos de la jornada no validos")
				RETURN 1
			ELSE
			END IF
	
			// Calcula minutos
			ld_ca_minutos_std = (ld_minutos_jornada * ll_ca_personasxmod) / ll_ca_unidad_base_dia
			This.SetItem(il_fila_actual_maestro, "ca_minutos_std", ld_ca_minutos_std)
			// Calcula base dia
			ll_ca_unidad_base_dia = (ld_minutos_jornada / ld_ca_minutos_std) * ll_ca_personasxmod
			This.SetItem(il_fila_actual_maestro, "ca_unid_base_dia", ll_ca_unidad_base_dia)
		END IF
	END IF

	
	IF Dwo.Name = "fe_inicio_prog" THEN
		ldt_fe_inicio_prog = dw_maestro.GetItemDatetime(il_fila_actual_maestro, "fe_inicio_prog")
	
		IF NOT(ISNULL(ldt_fe_inicio_prog))  THEN
			
			li_co_fabrica_modulo=dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
			li_co_planta_modulo=dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta")
			li_co_modulo=dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_modulo")
		
			li_anno=year(date(ldt_fe_inicio_prog))
			li_mes=month(date(ldt_fe_inicio_prog))
			li_dia=day(date(ldt_fe_inicio_prog))
			
			//busca a ver si la fecha de inicio est$$HEX2$$e1002000$$ENDHEX$$en el calendario General
			SELECT m_calendario_cont.fe_calendario  
			 INTO :ld_fe_calendario  
			 FROM m_calendario_cont  
			WHERE ( m_calendario_cont.ano 				> 0 ) AND  
					( m_calendario_cont.fe_calendario =DATE(:ldt_fe_inicio_prog)  )   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error base datos","No pudo buscar la fecha de inicio en el calendario General")
				RETURN 1
			ELSE
			END IF
			
			SELECT dt_mod_calendario.co_tipo_dia  
			 INTO :ls_co_tipo_dia  
			 FROM dt_mod_calendario  
			WHERE ( dt_mod_calendario.co_fabrica 	=: li_co_fabrica_modulo ) AND  
					( dt_mod_calendario.co_planta 	=:li_co_planta_modulo  ) AND  
					( dt_mod_calendario.co_modulo 	=:li_co_modulo  ) AND  
					( dt_mod_calendario.ano 			=:li_anno  ) AND  
					( dt_mod_calendario.mes 			=: li_mes ) AND  
					( dt_mod_calendario.dia 			=:li_dia  ) AND
					( dt_mod_calendario.co_tipo_dia  NOT LIKE "T" )
					  ;
			IF SQLCA.SQLCODE=0 THEN
				IF Mid(ls_co_tipo_dia,1,1) <> "T" THEN
					MessageBox("Error base datos","la fecha de inicio, no est$$HEX2$$e1002000$$ENDHEX$$marcada como dia de trabajo en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
					RETURN 1
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=100 THEN
				ELSE
					MessageBox("Error base datos","No pudo buscar la fecha de inicio en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
					RETURN 1
				END IF
			END IF
		ELSE
		END IF
	ELSE
	END IF
	
	IF Dwo.Name = "fe_fin_prog" THEN
		ldt_fe_inicio_prog = dw_maestro.GetItemDatetime(il_fila_actual_maestro, "fe_fin_prog")
		
		IF NOT(ISNULL(ldt_fe_inicio_prog)) THEN
			
			li_co_fabrica_modulo=dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
			li_co_planta_modulo=dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta")
			li_co_modulo=dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_modulo")
		
			li_anno=year(date(ldt_fe_inicio_prog))
			li_mes=month(date(ldt_fe_inicio_prog))
			li_dia=day(date(ldt_fe_inicio_prog))
			
			//busca a ver si la fecha de inicio est$$HEX2$$e1002000$$ENDHEX$$en el calendario General
			SELECT mardila.m_calendario_cont.fe_calendario  
			 INTO :ld_fe_calendario  
			 FROM mardila.m_calendario_cont  
			WHERE ( mardila.m_calendario_cont.ano 				> 0 ) AND  
					( mardila.m_calendario_cont.fe_calendario =DATE(:ldt_fe_inicio_prog)  )   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error base datos","No pudo buscar la fecha de FIN en el calendario General")
				RETURN 1
			ELSE
			END IF
			
			//busca a ver si la fecha de FIN est$$HEX2$$e1002000$$ENDHEX$$en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo
			SELECT dt_mod_calendario.co_tipo_dia  
			 INTO :ls_co_tipo_dia  
			 FROM dt_mod_calendario  
			WHERE ( dt_mod_calendario.co_fabrica 	=: li_co_fabrica_modulo ) AND  
					( dt_mod_calendario.co_planta 	=:li_co_planta_modulo  ) AND  
					( dt_mod_calendario.co_modulo 	=:li_co_modulo  ) AND  
					( dt_mod_calendario.ano 			=:li_anno  ) AND  
					( dt_mod_calendario.mes 			=: li_mes ) AND  
					( dt_mod_calendario.dia 			=:li_dia  )	AND
					( dt_mod_calendario.co_tipo_dia  NOT LIKE "T" )
					;
			IF SQLCA.SQLCODE=0 THEN
				IF Mid(ls_co_tipo_dia,1,1) <> "T" THEN
					MessageBox("Error base datos","la fecha de inicio, no est$$HEX2$$e1002000$$ENDHEX$$marcada como dia de trabajo en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
					RETURN 1
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=100 THEN
				ELSE
					MessageBox("Error base datos","No pudo buscar la fecha de inicio en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
					RETURN 1
				END IF
			END IF
		ELSE
		END IF
	ELSE
	END IF
ELSE
END IF
end event

event dw_maestro::updatestart;// verificar la curva de eficiencia y la distribuci$$HEX1$$f300$$ENDHEX$$n por dia en el detalle
Long 					ll_fila,ll_hallados
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia,ll_ca_unid_faltan
LONG					ll_unidades_empate,ll_sum_unid_asig,ll_ca_asignaxfila,ll_ca_unid_base_dia,ll_ca_a_programar

Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad,li_ind_camb_est
Long				li_rpta,ll_filas,ll_fila_actual,li_prioridad

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_sqlerr

DateTime 			ldt_fechahora,ldt_fe_prog_despacho,ldt_fe_entra_pdn
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog,ldt_fe_fin_anterior,ldt_inicioold

s_base_parametros lstr_parametros

dw_maestro.AcceptText()


//------------------------- inicio de cargar variables de dt_pdnxmodulo ----------------------------------//

li_simulacion				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"simulacion")
li_co_fabrica_modulo		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
li_co_planta_modulo		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
li_co_modulo				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_modulo")
li_cs_prioridad			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_prioridad")
li_metodo_programa		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"metodo_programa")
li_tipo_empate				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"tipo_empate")
ll_unidades_empate		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"unidades_empate")
ll_ca_unidades				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_pendiente")
ld_ca_minutos_std			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_minutos_std")
ll_ca_personasxmod		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_personasxmod")
li_co_curva					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_curva")

li_co_fabrica_exp			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_exp")
ll_pedido					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"pedido")
ll_cs_liberacion			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_liberacion")
ls_nu_orden					=dw_maestro.GetitemString(il_fila_actual_maestro,"po")
li_co_fabrica_ref			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_pt")
li_co_linea_ref			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_linea")
ll_co_referencia			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_referencia")
ll_color_pt					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_color_pt")
ls_tono						=dw_maestro.GetitemString(il_fila_actual_maestro,"tono")
li_cs_estilocolortono	=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_estilocolortono")
li_cs_particion			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_particion")
ldt_fe_inicio_prog		=dw_maestro.GetitemDatetime(il_fila_actual_maestro,"fe_inicio_prog")
ldt_inicioold           =dw_maestro.GetitemDatetime(il_fila_actual_maestro,"fe_inicio_prog",Primary!,True)
ldt_fe_fin_prog			=dw_maestro.GetitemDatetime(il_fila_actual_maestro,"fe_fin_prog")
ld_minutos_jornada		=dw_maestro.GetitemDecimal(il_fila_actual_maestro,"minutos_jornada")
li_ind_camb_est			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ind_cambio_estilo")
ll_ca_a_programar			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_a_programar")
li_cod_tur					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cod_tur")
ldt_fe_prog_despacho		=dw_maestro.Getitemdatetime(il_fila_actual_maestro,"fe_desp_programada")
ldt_fe_entra_pdn			=dw_maestro.Getitemdatetime(il_fila_actual_maestro,"fe_entra_pdn")
li_co_tipo_asignacion	=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_tipo_asignacion")

//------------------------- fin de cargar variables de dt_pdnxmodulo ----------------------------------//


////////////////////////////////////////////////////
// Claudio Fernando Hoyos O
// 25-10-2002
// Copia de las confecciones a corte
/////////////////////////////////////////////////////

If li_co_tipo_asignacion = 1 And Not IsNull(ldt_fe_inicio_prog) And IsNull(ldt_inicioold) And &
   li_co_planta_modulo = 2 Then
	If ids_confeccion.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,&
	               li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,ls_nu_orden,li_co_fabrica_ref,&
						li_co_linea_ref,ll_co_referencia,ll_color_pt,ls_tono,li_cs_estilocolortono,&
						li_cs_particion) <= 0 Then
		rollback ;
		MessageBox("Advertencia!","No se pudo recuperar los datos para ser copiados a corte.")
		Return 1
	Else
	End If
	
	select max(cs_prioridad)  
     into :li_prioridad  
     from dt_pdnxmodulo  
    where simulacion = 1 and
          co_fabrica = 91 and  
          co_planta = 1 and 
          co_modulo = 800    ;
			 
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlerrText
		rollback ;
		MessageBox("Advertencia!","No se pudo recuperar los datos para ser copiados a corte.~n~n~nNota: " + ls_sqlerr)
		Return 1
	Else
		li_prioridad += 1
	End If
	
	ids_confeccion.SetItemStatus(1,0,Primary!,NewModified!)
	
	ids_confeccion.SetItem(1,'co_planta',1)
	ids_confeccion.SetItem(1,'co_modulo',800)
	ids_confeccion.SetItem(1,'cs_prioridad',li_prioridad)
	ids_confeccion.SetItem(1,'fe_creacion',Today())
	ids_confeccion.SetItem(1,'fe_actualizacion',Today())
	ids_confeccion.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
	
	If ids_confeccion.Update() = -1 Then
		ls_sqlerr = Sqlca.SqlerrText
		rollback ;
		MessageBox("Advertencia!","No se pudo actualizar la confeccion en corte.~n~n~nNota: " + ls_sqlerr)
		Return 1
	End If
End If
//Fin copiar


//------------------------- inicio de verificar unidades a simular ----------------------------------//
IF ll_ca_a_programar > 0 THEN
	ll_ca_unidades=ll_ca_a_programar
ELSE
END IF
//------------------------- fin de verificar unidades a simular ----------------------------------//


//------------------------  inicio de si esta borrando detalle -------------------------------------//
IF ii_borrando_detalle=0 THEN
	
	//--------------------	  inicio de programaci$$HEX1$$f300$$ENDHEX$$n por base dia -------------------------------//	

	IF li_metodo_programa=0 THEN //Base dia, manual
		// Entra distribucion manual
		// Debe mirar si tiene unidades o sino completar con bases
		dw_detalle.AcceptText()
				
		//--------------------	  inicio de cuando tiene detalles -------------------------------//	
				
		IF il_fila_actual_detalle > 0 THEN
			
			// Determina ultima linea programada manual y toma fecha
			ll_filas = dw_detalle.RowCount()
			ldt_fe_fin_anterior=dw_detalle.GetItemDatetime(ll_filas, "fe_fin")

			//recorre el detalle sumando las unidades asignadas
			ll_sum_unid_asig	= 0
			FOR ll_fila_actual = 1 TO ll_filas
				//acumula las unidades asignadas		
				ll_ca_asignaxfila= dw_detalle.GetItemNumber(ll_fila_actual, "ca_pendiente")
				ll_sum_unid_asig=ll_sum_unid_asig + ll_ca_asignaxfila
			NEXT
		ELSE
				ll_sum_unid_asig=0				
  				ldt_fe_fin_anterior=ldt_fe_inicio_prog
		END IF
		
		//--------------------	  fin de cuando tiene detalles -------------------------------//				
		
		
		//--------------------	  inicio de si le faltan unidades por asignar --------------------//						
				
		IF ll_sum_unid_asig < ll_ca_unidades THEN
			   
			//--------------------	  inicio prog hacia atras  --------------------//								
						
				// Verifica si programa de atras para adelante o Normal
				IF NOT ISNULL(ldt_fe_prog_despacho) THEN
						//debe llamar a funcion que asigne unidades base con lo que le falte				
						ll_ca_unid_base_dia=dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_unid_base_dia")
						ll_ca_unid_faltan=ll_ca_unidades - ll_sum_unid_asig
						// Llama funcion para programacion manual
						li_rpta = f_distribuir_unidades_base(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
									li_co_modulo,li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
									ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
									li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
									ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
									ll_color_pt,ls_tono,&
									li_cs_estilocolortono,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,ld_minutos_jornada,&
									ll_filas,ll_ca_unid_faltan,ldt_fe_fin_anterior,ll_ca_unid_base_dia,&
									ldt_fe_prog_despacho,ldt_fe_entra_pdn,li_cod_tur)
						// Actualiza Fecha entrda produccion Calculada	
						IF li_rpta=1 THEN
							COMMIT;
						ELSE
							ROLLBACK;
							MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No se pudo distribuir unidadades en los dias")
						END IF
				END IF	
				
			//--------------------	  fin prog hacia atras  --------------------//											
						
			// --- inicio Programa Normalmente Hacia Adelante --- //
			
			
				SETNULL(ldt_fe_prog_despacho)
				//debe llamar a funcion que asigne unidades base con lo que le falte				
				ll_ca_unid_base_dia=dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_unid_base_dia")
				ll_ca_unid_faltan=ll_ca_unidades - ll_sum_unid_asig
				// Llama funcion para programacion manual
				li_rpta = f_distribuir_unidades_base(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
							li_co_modulo,li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
							ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
							li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
							ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
							ll_color_pt,ls_tono,&
							li_cs_estilocolortono,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,ld_minutos_jornada,&
							ll_filas,ll_ca_unid_faltan,ldt_fe_fin_anterior,ll_ca_unid_base_dia,&
							ldt_fe_prog_despacho,ldt_fe_entra_pdn,li_cod_tur)
			// --- fin Programa Normalmente Hacia Adelante --- //							
			
			
			// -------------------inicio asienta programaciones base dia ----------------------//
			IF li_rpta=1 THEN
				COMMIT;
			ELSE
				ROLLBACK;
				MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No se pudo distribuir unidades en los dias")
			END IF
			// ------------------- fin asienta programaciones base dia ----------------------//			
			
		//--------------------	  fin de si le faltan unidades por asignar --------------------//								
		
		ELSE
		//--- si no tiene unidades pendientes por asignar no hace nada ok.
			MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No puede mas unidades de las Disponibles")
		END IF
	//--------------------	  fin de programaci$$HEX1$$f300$$ENDHEX$$n por base dia -------------------------------//				

	ELSE 
		
	//------------------***  inicio de programaci$$HEX1$$f300$$ENDHEX$$n por eficiencia dia ***-----------------//			
		
		//--------------   inicio de borra el detalle de dt_programa_diario ----------------//
		DELETE FROM dt_programa_diario  
			WHERE ( dt_programa_diario.simulacion 				=:li_simulacion ) AND  
					( dt_programa_diario.co_fabrica 				=:li_co_fabrica_modulo  ) AND  
					( dt_programa_diario.co_planta 				=:li_co_planta_modulo  ) AND  
					( dt_programa_diario.co_modulo 				=:li_co_modulo ) AND  
					( dt_programa_diario.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
					( dt_programa_diario.pedido 					=:ll_pedido  ) AND  
					( dt_programa_diario.cs_liberacion 			=:ll_cs_liberacion  ) AND  
					( dt_programa_diario.po 						=:ls_nu_orden ) AND  
					( dt_programa_diario.co_fabrica_pt 			=:li_co_fabrica_ref ) AND  
					( dt_programa_diario.co_linea 				=:li_co_linea_ref  ) AND  
					( dt_programa_diario.co_referencia 			=:ll_co_referencia  ) AND  
					( dt_programa_diario.co_color_pt 			=:ll_color_pt  ) AND  
					( dt_programa_diario.tono 						=:ls_tono  ) AND  
					( dt_programa_diario.cs_estilocolortono 	=:li_cs_estilocolortono  ) AND  
					( dt_programa_diario.cs_particion 			=:li_cs_particion  )   ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base datos","No pudo borrar distribuci$$HEX1$$f300$$ENDHEX$$n diaria previa de unidades para reasignar")
			RETURN
		ELSE
		END IF
		//--------------   fin de borra el detalle de dt_programa_diario ----------------//		

		
		//--------------  inicio de prog eficiencia puede ser adelante o atras -------------------//
		// La funcion "f_distribuir_unidades" se puede ver por open/Tipo objeto : Functions/  		//
		// Seleccinando el PBL correspondiente																		//
		
		// Verifica si programa de atras 
		IF NOT ISNULL(ldt_fe_prog_despacho) THEN
			li_rpta = f_distribuir_unidades(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,&
							li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
							ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
							li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
							ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
							ll_color_pt,ls_tono,&
							li_cs_estilocolortono,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,ld_minutos_jornada,&
							li_ind_camb_est,li_cod_tur,ldt_fe_prog_despacho,ldt_fe_entra_pdn,li_co_tipo_asignacion) 
										
		//--------------  fin de prog eficiencia puede ser adelante o atras -------------------//							
		
		
		//--------------  inicio de asentar prog eficiencia puede ser adelante o atras -------------------//		
			IF li_rpta=1 THEN
				COMMIT;
			ELSE
				ROLLBACK;
				MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No se pudo distribuir unidadades en los dias")
			END IF
		END If
		//--------------  fin de asentar prog eficiencia puede ser adelante o atras -------------------//		
		
	
		//------------------- inicio de prog hacia adelante si hubo prog hacia atras en proceso anterior -----//
			idt_fe_prog_desp=ldt_fe_prog_despacho					

			SETNULL(ldt_fe_prog_despacho)

				
			li_rpta = f_distribuir_unidades(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,&
								li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
								ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
								li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
								ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
								ll_color_pt,ls_tono,&
								li_cs_estilocolortono,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,ld_minutos_jornada,&
								li_ind_camb_est,li_cod_tur,ldt_fe_prog_despacho,ldt_fe_entra_pdn,li_co_tipo_asignacion)					
			
		//------------------- fin de prog hacia adelante si hubo prog hacia atras en proceso anterior -----//
		
		
		//------------------- inicio de asentar de prog hacia adelante si hubo prog hacia atras en proceso anterior -----//
			IF li_rpta=1 THEN
				COMMIT;
			ELSE
				ROLLBACK;
				MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No se pudo distribuir unidadades en los dias")
			END IF
		//------------------ fin de asentar de prog hacia adelante si hubo prog hacia atras en proceso anterior -----//
		
		
	//---------------------  fin de programaci$$HEX1$$f300$$ENDHEX$$n por eficiencia dia --------------------------//			
	
	END IF
	
ELSE
END IF
//------------------------  fin de si esta borrando detalle -------------------------------------//
end event

event dw_maestro::updateend;//verificar la curva de eficiencia y la distribuci$$HEX1$$f300$$ENDHEX$$n por dia en el detalle
Long 					ll_fila,ll_hallados
DateTime 			ldt_fechahora
Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion
s_base_parametros lstr_parametros
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido

LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					ll_unidades_empate
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DECIMAL				ld_ca_minutos_std,ld_minutos_jornada

Long				li_rpta	

IF ii_borrando_detalle=0 THEN
	IF ii_insertando_det=0 THEN
		dw_maestro.AcceptText()
		
		li_simulacion				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"simulacion")
		li_co_fabrica_modulo		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
		li_co_planta_modulo		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
		li_co_modulo				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_modulo")
		li_cs_prioridad			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_prioridad")
		li_metodo_programa		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"metodo_programa")
		li_tipo_empate				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"tipo_empate")
		ll_unidades_empate		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"unidades_empate")
		ll_ca_unidades				=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_pendiente")
		ld_ca_minutos_std			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_minutos_std")
		ll_ca_personasxmod		=dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_personasxmod")
		li_co_curva					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_curva")
		
		li_co_fabrica_exp			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_exp")
		ll_pedido					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"pedido")
		ll_cs_liberacion			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_liberacion")
		ls_nu_orden					=dw_maestro.GetitemString(il_fila_actual_maestro,"po")
		li_co_fabrica_ref			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_pt")
		li_co_linea_ref			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_linea")
		ll_co_referencia			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_referencia")
		ll_color_pt					=dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_color_pt")
		ls_tono						=dw_maestro.GetitemString(il_fila_actual_maestro,"tono")
		li_cs_estilocolortono	=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_estilocolortono")
		li_cs_particion			=dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_particion")
		ldt_fe_inicio_prog		=dw_maestro.GetitemDatetime(il_fila_actual_maestro,"fe_inicio_prog")
		ldt_fe_fin_prog			=dw_maestro.GetitemDatetime(il_fila_actual_maestro,"fe_fin_prog")
		ld_minutos_jornada		=dw_maestro.GetitemDecimal(il_fila_actual_maestro,"minutos_jornada")
				
				
				//hacer retrieve
				IF ISNULL(li_simulacion) OR ISNULL(li_co_fabrica_modulo) OR ISNULL(li_co_planta_modulo) OR&
					ISNULL(li_co_modulo) OR ISNULL(li_co_fabrica_exp) OR ISNULL(ll_pedido) OR&
					ISNULL(ll_cs_liberacion) OR ISNULL(ls_nu_orden) OR ISNULL(li_co_fabrica_ref) OR&
					ISNULL(li_co_linea_ref) OR ISNULL(ll_color_pt) OR ISNULL(ls_tono) OR&
					ISNULL(li_cs_estilocolortono) OR ISNULL(li_cs_particion) THEN
					
					MessageBox("Error ","Existen datos nulos la ventana de modulo")
					
					RETURN
				ELSE
					ll_hallados = dw_maestro.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
																 li_co_modulo,li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
																 ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																 ll_color_pt,ls_tono,&
																 li_cs_estilocolortono,li_cs_particion)
					IF isnull(ll_hallados) THEN
						MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
					ELSE
						CHOOSE CASE ll_hallados
							CASE -1
								il_fila_actual_maestro = -1
								MessageBox("Error buscando","Error de la base",StopSign!,&
											 Ok!)
							CASE 0
								il_fila_actual_maestro = 0
								MessageBox("Sin Datos","No hay datos para su criterio",&
											 Exclamation!,Ok!)
							CASE ELSE
								il_fila_actual_maestro = 1
								//trae minutos de los estandares, esto va despues para el rowfocuschanged
								
								ll_hallados = dw_detalle.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
																 li_co_modulo,li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
																 ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																 ll_color_pt,ls_tono,&
																 li_cs_estilocolortono,li_cs_particion)
								IF isnull(ll_hallados) THEN
									MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
								ELSE
									CHOOSE CASE ll_hallados
										CASE -1
											il_fila_actual_detalle = -1
											MessageBox("Error buscando","Error de la base",StopSign!,&
														 Ok!)
										CASE 0
											il_fila_actual_detalle = 0
										CASE ELSE
											il_fila_actual_detalle = 1
				
									END CHOOSE
								END IF
						END CHOOSE
					END IF
				END IF 	
			ELSE
			END IF
ELSE
END IF
end event

event dw_maestro::adcnar_fla;//debe verificar si es nuevo o no
end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_parametros_asignacion
integer x = 0
integer y = 1012
integer width = 3579
integer height = 668
boolean titlebar = false
string dataobject = "dtb_dt_programa_diario"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

event dw_detalle::itemchanged;Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_co_est_prog_dia,li_cs_prioridad
Long				li_prior_mayores,li_cs_max_prioridad,li_rpta,li_cs_prioridad_ciclo,li_co_tipo_asignacion_inicial

LONG					ll_fila,ll_hallados,ll_rpta
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_ca_faltan
LONG					ll_personasxmodulo,ll_ca_unid_posibles,ll_unidades_empate

DateTime 			ldt_fechahora
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DATE					ldt_fe_despacho_allocation

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia,ld_ca_min_dispon_fin

s_base_parametros lstr_parametro


IF il_fila_actual_maestro > 0 THEN

	dw_detalle.AcceptText()
	
	li_co_fabrica_modu 		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	li_co_planta_modu 		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta")
	li_co_modulo 				= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_modulo")
	
	
	ldt_fechahora = f_fecha_servidor()
	dw_detalle.SetItem(il_fila_actual_detalle, "fe_actualizacion", ldt_fechahora)
	dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
	dw_detalle.SetItem(il_fila_actual_detalle, "instancia", gstr_info_usuario.instancia)
	
	//busca la fecha de despacho cuando es allocation
	
	IF Dwo.Name = "ca_pendiente" THEN
		ll_ca_programada = dw_detalle.GetItemNumber(il_fila_actual_detalle, "ca_pendiente")
		ll_ca_unid_dispon_ini=dw_detalle.GetItemNumber(il_fila_actual_detalle, "ca_unid_dispon_ini")
		ll_ca_unid_dispon_fin=ll_ca_unid_dispon_ini - ll_ca_programada
		dw_detalle.SetItem(il_fila_actual_detalle, "ca_unid_dispon_fin", ll_ca_unid_dispon_fin)
		
		ld_ca_min_dispon_ini=dw_detalle.GetItemDecimal(il_fila_actual_detalle, "ca_min_dispon_ini")
		ld_ca_minutos_std=dw_maestro.GetItemDecimal(il_fila_actual_maestro, "ca_minutos_std")
		ll_personasxmodulo=dw_maestro.GetItemDecimal(il_fila_actual_maestro, "ca_personasxmod")
		ld_ca_min_dispon_fin=ld_ca_min_dispon_ini - ((ld_ca_minutos_std * ll_ca_programada) / ( ll_personasxmodulo)) //* (ld_porc_eficiencia/100) 	
		
		ld_porc_eficiencia=((ll_ca_programada*ld_ca_minutos_std)/(ld_ca_min_dispon_ini*ll_personasxmodulo)) * 100
		dw_detalle.SetItem(il_fila_actual_detalle, "porc_eficiencia", ld_porc_eficiencia)	
		
		ldt_fe_inicio_prog=dw_detalle.GetItemDatetime(il_fila_actual_detalle, "fe_inicio")
		ldt_fe_fin_prog = datetime(RelativeDate(date(ldt_fe_inicio_prog),1), time(ldt_fe_inicio_prog))
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_fin", ldt_fe_fin_prog)	
		
		IF ll_ca_unid_dispon_fin=0 THEN
			dw_maestro.SetItem(il_fila_actual_maestro, "fe_fin_prog", ldt_fe_fin_prog)
		ELSE
		END IF
		
	ELSE
	END IF
ELSE
END IF


end event

event dw_detalle::updateend;ii_insertando_det=0
end event

