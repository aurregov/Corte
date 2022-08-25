HA$PBExportHeader$w_fechas_requisito_independiente.srw
$PBExportComments$administraci$$HEX1$$f300$$ENDHEX$$n de asignaci$$HEX1$$f300$$ENDHEX$$n de m$$HEX1$$f300$$ENDHEX$$dulos
forward
global type w_fechas_requisito_independiente from w_base_maestroff_detalletb
end type
type cb_1 from commandbutton within w_fechas_requisito_independiente
end type
type cb_2 from commandbutton within w_fechas_requisito_independiente
end type
type cb_3 from commandbutton within w_fechas_requisito_independiente
end type
type gb_1 from groupbox within w_fechas_requisito_independiente
end type
type gb_2 from groupbox within w_fechas_requisito_independiente
end type
end forward

global type w_fechas_requisito_independiente from w_base_maestroff_detalletb
integer x = 0
integer y = 0
integer width = 3808
integer height = 2008
string title = "Asignaci$$HEX1$$f300$$ENDHEX$$n Corte"
string menuname = "m_mantenimiento_asignacion_modulos"
event ue_parametros pbm_custom07
event ue_escalasxtalla pbm_custom08
event ue_partir_escala pbm_custom09
event ue_recalcular pbm_custom10
event ue_reporte102 pbm_custom11
event ue_fecha_requisito ( )
event ue_agrupar ( )
event ue_observaciones ( )
event ue_liquidados ( )
event ue_prioridad ( )
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_fechas_requisito_independiente w_fechas_requisito_independiente

type variables
Long  ii_borrando_detalle=0
Long  ii_simulacion_base,sw_estado
Long	ii_co_fabrica_modu,ii_co_planta_modu,ii_co_modulo,ii_simulacion,ii_traslado
Long	ii_repriorizar,ii_incremento
STRING   is_body
DataWindowChild ids_modulo

end variables

forward prototypes
public function date wf_traer_fechas (long an_co_fabrica_mod, long an_co_planta_mod, long an_co_modulo, long an_co_turno, datetime adt_fecha, long an_numero_dias, long an_tipo_avance)
public function long wf_reordenar_prioridad_nueva (long al_modulo, long al_pract, long al_prnue)
public function long wf_reordenar_prioridad (long ai_modulo, long ai_prdact, long ai_prdnue)
public function long wf_reordenar (long al_modulo, long al_pract, long al_prnue)
public function long wf_reordenar_descendente (long al_modulo, long al_pract, long al_prnue)
public function long wf_insert_dt_telasxoc ()
protected function long wf_numero_prioridad (long pri_act, long pri_nue, long agr_act, long mod, long tipo)
public function long wf_distribuir_unidades (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_li_ind_camb_est, long an_li_cod_tur, datetime adt_fe_prog_desp, datetime adt_fe_entra_pdn, long an_co_tipo_asignacion)
public function long wf_distribuir_unidades_base (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, ref datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_dias_programados, long an_unid_que_lleva, datetime adt_fe_fin_ant, long an_base_dia)
public function long wf_ins_tallas (long an_simulacion, long an_co_fabrica_modulo, long an_co_planta_modulo, long an_co_modulo, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_pt, long an_co_linea, long an_co_referencia, long an_co_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, long an_co_tipo_asignacion)
end prototypes

event ue_parametros;//n_cts_param luo_param
//
//
//luo_param.il_vector[1] = dw_detalle.GetitemNumber(il_fila_actual_detalle,"simulacion")
//luo_param.il_vector[2] = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
//luo_param.il_vector[3] = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
//luo_param.il_vector[4] = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_modulo")
//luo_param.il_vector[5] = dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_prioridad")
//
//			
//OpenWithParm(w_parametros_corte,luo_param)
//
//
//commit ;
//
//dw_detalle.Retrieve(91,1,1)
//
//
//	






end event

event ue_escalasxtalla;//Long 					ll_fila
//DateTime 			ldt_fechahora
//Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
//s_base_parametros lstr_parametros
//Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
//LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
//Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
//STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido
//
//LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
//LONG					li_unidades_empate
//Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
//Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,ll_asignaciones
//DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
//DECIMAL				ld_ca_minutos_std
//w_escalas_asignacion_modulos	w_instancia
//
//li_simulacion 				= dw_detalle.GetitemNumber(il_fila_actual_detalle,"simulacion")
//li_co_fabrica_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
//li_co_planta_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
//li_co_modulo 				= dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_modulo")
//	
//li_co_fabrica_exp  	   =dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica_exp")  
//ll_pedido               =dw_detalle.GetitemNumber(il_fila_actual_detalle,"pedido")   
//ll_cs_liberacion        =dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_liberacion")   
//ls_nu_orden			      =dw_detalle.GetitemString(il_fila_actual_detalle,"po")   
//li_co_fabrica_ref       =dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica_pt")   
//li_co_linea_ref       	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_linea")   
//ll_co_referencia       	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_referencia")   
//ll_color_pt       		=dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_color_pt")   
//ls_tono       				=dw_detalle.GetitemString(il_fila_actual_detalle,"tono")   
//li_cs_estilocolton   	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_estilocolortono")   
//li_cs_particion       	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_particion")     
//	
//lstr_parametros.entero[1]			=	li_simulacion
//lstr_parametros.entero[2]			=	li_co_fabrica_modu
//lstr_parametros.entero[3]			=	li_co_planta_modu
//lstr_parametros.entero[4]			=	li_co_modulo	
//lstr_parametros.entero[5]			=	li_co_fabrica_exp	
//lstr_parametros.entero[6]			=	ll_pedido
//lstr_parametros.entero[7]			=	ll_cs_liberacion
//lstr_parametros.cadena[1]			=	ls_nu_orden
//lstr_parametros.entero[8]			=	li_co_fabrica_ref
//lstr_parametros.entero[9]			=	li_co_linea_ref
//lstr_parametros.entero[10]			=	ll_co_referencia
//lstr_parametros.entero[11]			=	ll_color_pt
//lstr_parametros.cadena[2]			=	ls_tono
//lstr_parametros.entero[12]			=	li_cs_estilocolton
//lstr_parametros.entero[13]			=	li_cs_particion
//	
//lstr_parametros.Hay_Parametros	=	TRUE		
//			
//OpenSheetWithParm(w_instancia, lstr_parametros, w_principal)
//
//	
//
//
//
//
//
//
end event

event ue_partir_escala;//LONG 					ll_fila,ll_hallados
//LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
//LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia,ll_ca_a_comparar
//LONG					ll_unidades_empate,ll_asignaciones,ll_ca_pendiente,ll_ca_faltan,ll_ca_a_asignar,ll_ca_a_sacar
//LONG					ll_ca_base_dia_prog,ll_ca_base_dia_prod,ll_inserto_tallas
//
//Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
//Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
//Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
//Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
//Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad,li_rpta,li_cambia_modulo
//Long				li_co_fabrica_modu_ant,li_co_planta_modu_ant,li_co_modulo_ant,li_max_particion,li_cs_particion_anterior
//Long				li_indicativo_base,li_tipo_fe_prog, li_cs_prioridad_ciclo
//
//DECIMAL				ld_ca_minutos_std,ld_minutos_jornada
//
//STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_de_modulo
//
//DateTime 			ldt_fechahora
//DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog,ldt_fe_requerida_desp
//DATETIME				ldt_fe_desp_programada,ldt_fe_entra_pdn,ldt_fe_lim_prog
//
//s_base_parametros lstr_parametros
//
//IF (MessageBox("Partir o Trasladar unidades ...","Esta seguro de Partir o trasladar?",Question!,YesNo!) = 1) THEN
//	IF il_fila_actual_maestro > 0 THEN
//		IF dw_detalle.AcceptText() = -1 THEN
//			MessageBox("Error datawindow","No se puede partir el registro del detalle porque habian ingresos previos con problemas" &
//						,StopSign!)	
//		ELSE
//			// --------------------
//			// Guarda Fabrica, Planta, Modulo Original 
//			// --------------------
//			li_co_fabrica_modu_ant 	= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
//			li_co_planta_modu_ant 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
//			li_co_modulo_ant 				= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_modulo")
//			
//			IF IsNull(li_co_fabrica_modu_ant) OR IsNull(li_co_planta_modu_ant) OR IsNull(li_co_modulo_ant)  THEN
//				dw_detalle.DeleteRow(il_fila_actual_detalle)
//				il_fila_actual_detalle = il_fila_actual_detalle - 1
//			ELSE
//				IF il_fila_actual_detalle > 0 THEN
//				ELSE
//					MessageBox("Advertencia","No hay registros en el detalle para partir")
//					RETURN
//				END IF
//				
//				// -------------------
//				// Guarda Valores originales de la asignacion a procesar
//				// -------------------
//				li_simulacion		   	= dw_detalle.GetitemNumber(il_fila_actual_detalle,"simulacion")
//				li_co_fabrica_exp			= dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica_exp")
//				ll_pedido		   		= dw_detalle.GetitemNumber(il_fila_actual_detalle,"pedido")
//				ls_gpa		   			= dw_detalle.GetitemString(il_fila_actual_detalle,"gpa")
//				li_co_tipo_asignacion	= dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_tipo_asignacion")
//				ls_nu_orden		   		= dw_detalle.GetitemString(il_fila_actual_detalle,"po")
//				li_co_fabrica_ref		   = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica_pt")
//				li_co_linea_ref		   = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_linea")
//				ll_co_referencia		   = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_referencia")
//				ll_color_pt		   		= dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_color_pt")
//				ll_cs_liberacion		   = dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_liberacion")
//				ll_ca_unidades		   	= dw_detalle.GetitemNumber(il_fila_actual_detalle,"ca_pendiente")
//				ls_tono		   			= dw_detalle.GetitemString(il_fila_actual_detalle,"tono")
//				li_cs_estilocolton		= dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_estilocolortono")
//				li_cs_particion_anterior= dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_particion")
//				
//				// -----------------
//				// Lleva Fabrica, Planta, Modulo, unidades originales a Parametros
//				// -----------------
//				lstr_parametros.entero[1]=li_co_fabrica_modu_ant
//				lstr_parametros.entero[2]=li_co_planta_modu_ant
//				lstr_parametros.entero[3]=li_co_modulo_ant
//				lstr_parametros.entero[4]=ll_ca_unidades
//				
//				lstr_parametros.hay_parametros=TRUE
//				
//				// --------------
//				// Llama Ventana para seleccion de Modulo Destino
//				// --------------
//				OpenWithParm(w_seleccionar_modulos,lstr_parametros)
//				lstr_parametros = Message.PowerObjectParm
//
//				IF lstr_parametros.hay_parametros THEN
//					lstr_parametros.hay_parametros = TRUE
//					li_cambia_modulo=lstr_parametros.entero[5]
//					// -----------------
//					// Lleva Fabrica, Planta, Modulo Seleccionados a Campos de Trabajo
//					// -----------------
//					IF li_cambia_modulo=1 THEN
//						li_co_fabrica_modu=lstr_parametros.entero[1]
//						li_co_planta_modu =lstr_parametros.entero[2]
//						li_co_modulo		=lstr_parametros.entero[3]
//					ELSE
//						li_co_fabrica_modu=li_co_fabrica_modu_ant
//						li_co_planta_modu =li_co_planta_modu_ant
//						li_co_modulo		=li_co_modulo_ant
//					END IF
//					
//					// -----------------------
//					// Valida que se haya seleccionado un Modulo diferente al actual
//					// si es una Asignacion no Proyectada (actual).
//					// -----------------------
//					IF (li_co_tipo_asignacion = 2) AND &
//					   (li_co_fabrica_modu = li_co_fabrica_modu_ant) AND &
//						(li_co_planta_modu = li_co_planta_modu_ant) AND &
//						(li_co_modulo = li_co_modulo_ant) THEN
//						MessageBox("Advertencia","Debe Seleccionar un Modulo diferente al actual para una asignaci$$HEX1$$f300$$ENDHEX$$n Actual")
//						RETURN
//					ELSE
//					END IF
//					
//					// -------------------
//					// Busca datos del modulo seleccionado (de_modulo)
//					// -------------------
//					SELECT m_modulos.de_modulo  
//					 INTO :ls_de_modulo  
//					 FROM m_modulos  
//					WHERE ( m_modulos.co_fabrica =:li_co_fabrica_modu_ant  ) AND  
//							( m_modulos.co_planta =:li_co_planta_modu_ant  ) AND  
//							( m_modulos.co_modulo =:li_co_modulo_ant  )   ;
//					IF SQLCA.SQLCODE = -1 THEN
//						MessageBox("Error Base Datos","No pudo traer descripci$$HEX1$$f300$$ENDHEX$$n del m$$HEX1$$f300$$ENDHEX$$dulo")
//						RETURN 0
//					ELSE
//					END IF
//					
//					// ---------------------
//					// trae el pedido po de dt_libera_estilos para la asignacion Actual 
//					// o usa pedido de parametros actuales para asignacion proyectada
//					// ---------------------
//					IF li_co_tipo_asignacion=1 THEN
//						ll_pedido_po=ll_pedido
//					ELSE
//						SELECT dt_libera_estilos.pedido_po  
//						 INTO :ll_pedido_po  
//						 FROM dt_libera_estilos  
//						WHERE ( dt_libera_estilos.co_fabrica_exp 			=:li_co_fabrica_exp  ) AND  
//								( dt_libera_estilos.pedido 					=:ll_pedido  ) AND  
//								( dt_libera_estilos.cs_liberacion 			=:ll_cs_liberacion  ) AND  
//								( dt_libera_estilos.nu_orden 					=:ls_nu_orden  ) AND  
//								( dt_libera_estilos.co_fabrica 				=:li_co_fabrica_ref  ) AND  
//								( dt_libera_estilos.co_linea 					=:li_co_linea_ref  ) AND  
//								( dt_libera_estilos.co_referencia 			=:ll_co_referencia  ) AND  
//								( dt_libera_estilos.co_color_pt 				=:ll_color_pt  ) AND  
//								( dt_libera_estilos.tono 						=:ls_tono  ) AND  
//								( dt_libera_estilos.cs_estilocolortono 	=:li_cs_estilocolton  )   ;
//						IF SQLCA.SQLCODE=-1 THEN
//							MessageBox("Error datawindow","No pudo buscar pedido de la P.O.",StopSign!)
//							RETURN 0
//						ELSE
//						END IF
//					END IF
//
//					// ----------------------------
//					// Identifica la fila en la cual esta el cursor para extraer informacion
//					// ----------------------------
//					ll_fila = dw_detalle.InsertRow(0)
//						
//					IF ll_fila = -1 THEN
//						MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
//					ELSE
//						dw_detalle.SetFocus()
//						dw_detalle.SetRow(ll_fila)
//						dw_detalle.ScrollToRow(ll_fila)
//						dw_detalle.SetColumn(1)
//						il_fila_actual_detalle = ll_fila 
//						dw_detalle.SelectRow(il_fila_actual_detalle,FALSE)
//						il_fila_actual_detalle = dw_detalle.GetRow()
//						IF ((il_fila_actual_detalle<> -1) and (NOT ISNULL (il_fila_actual_detalle)) and (il_fila_actual_detalle<>0))THEN
//							dw_detalle.SelectRow(il_fila_actual_detalle,TRUE)
//							
//							// ------------------------
//							// trae los par$$HEX1$$e100$$ENDHEX$$metros de la asignaci$$HEX1$$f300$$ENDHEX$$n que est$$HEX2$$e1002000$$ENDHEX$$sacando 
//							// ------------------------
//							SELECT   dt_pdnxmodulo.ind_cambio_estilo,	dt_pdnxmodulo.orige_uni_base_dia,   
//										dt_pdnxmodulo.ca_minutos_std,   	dt_pdnxmodulo.ca_unid_base_dia,   
//										dt_pdnxmodulo.ca_base_dia_prog, 	dt_pdnxmodulo.ca_base_dia_prod,   
//										dt_pdnxmodulo.indicativo_base,  	dt_pdnxmodulo.tipo_empate,   
//										dt_pdnxmodulo.unidades_empate,  	   
//										dt_pdnxmodulo.fe_desp_programada,dt_pdnxmodulo.fe_entra_pdn,   
//										dt_pdnxmodulo.fe_lim_prog,   		dt_pdnxmodulo.metodo_programa,   
//										dt_pdnxmodulo.cod_tur,   			dt_pdnxmodulo.co_curva,   
//										dt_pdnxmodulo.ca_personasxmod,   dt_pdnxmodulo.minutos_jornada,   
//										dt_pdnxmodulo.tipo_fe_prog,
//										dt_pdnxmodulo.ca_programada,
//										dt_pdnxmodulo.ca_producida,
//										dt_pdnxmodulo.ca_pendiente	
//								 INTO :li_ind_cambio_estilo,   			:li_orige_uni_base_dia,   
//										:ld_ca_minutos_std,   				:ll_ca_unidad_base_dia,   
//										:ll_ca_base_dia_prog, 				:ll_ca_base_dia_prod,   
//										:li_indicativo_base,  				:li_tipo_empate,   
//										:ll_unidades_empate,  				   
//										:ldt_fe_desp_programada,			:ldt_fe_entra_pdn,   
//										:ldt_fe_lim_prog,   					:li_metodo_programa,   
//										:li_cod_tur,   						:li_co_curva,   
//										:ll_ca_personasxmod,   				:ld_minutos_jornada,   
//										:li_tipo_fe_prog,  
//										:ll_ca_programada,
//										:ll_ca_producida,
//										:ll_ca_pendiente	
//								 FROM dt_pdnxmodulo  
//								WHERE ( dt_pdnxmodulo.simulacion 			=:li_simulacion  ) AND  
//										( dt_pdnxmodulo.co_fabrica 			=:li_co_fabrica_modu_ant  ) AND  
//										( dt_pdnxmodulo.co_planta 				=:li_co_planta_modu_ant  ) AND  
//										( dt_pdnxmodulo.co_modulo 				=:li_co_modulo_ant  ) AND  
//										( dt_pdnxmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
//										( dt_pdnxmodulo.pedido 					=:ll_pedido  ) AND  
//										( dt_pdnxmodulo.cs_liberacion 		=:ll_cs_liberacion  ) AND  
//										( dt_pdnxmodulo.po 						=:ls_nu_orden  ) AND  
//										( dt_pdnxmodulo.co_fabrica_pt 		=:li_co_fabrica_ref  ) AND  
//										( dt_pdnxmodulo.co_linea 				=:li_co_linea_ref  ) AND  
//										( dt_pdnxmodulo.co_referencia 		=:ll_co_referencia  ) AND  
//										( dt_pdnxmodulo.co_color_pt 			=:ll_color_pt  ) AND  
//										( dt_pdnxmodulo.tono 					=:ls_tono  ) AND  
//										( dt_pdnxmodulo.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
//										( dt_pdnxmodulo.cs_particion 			=:li_cs_particion_anterior );
//										
//							IF SQLCA.SQLCODE=-1 THEN
//								MessageBox("Error Base datos","No pudo buscar par$$HEX1$$e100$$ENDHEX$$metros anteriores de asignaci$$HEX1$$f300$$ENDHEX$$n")
//								RETURN
//							ELSE
//							END IF
//							// ---------------------
//							// Organizar unidades segun tipo de asignacion 
//							// para actuales respeta las leidas, para proyectadas las inicia porque
//							// en la pantalla de division se definira como quedan
//							// ---------------------
//							IF li_co_tipo_asignacion=1 THEN 
//								ll_ca_a_sacar			=0
//								ll_ca_producida			=ll_ca_a_sacar
//								ll_ca_programada			=ll_ca_a_sacar
//								ll_ca_pendiente			=ll_ca_a_sacar
//							END IF
//	
//							li_co_estado_asigna		=1
//							li_fuente_dato				=1 //datawindow
//							
//							//-----------------------------------------------------
//							// Determina el numero de asignaciones que tiene la referencia en el
//							// modulo destino, para organizar el campo cs_particion
//							//-------------------------------------------------------														
//							SELECT count(*)  
//							  INTO :ll_asignaciones  
//							FROM dt_pdnxmodulo  								
//							WHERE ( dt_pdnxmodulo.simulacion 			=  :li_simulacion) AND  
//									( dt_pdnxmodulo.co_fabrica 			=  :li_co_fabrica_modu) AND  
//									( dt_pdnxmodulo.co_planta		 		=  :li_co_planta_modu) AND  
//									( dt_pdnxmodulo.co_modulo 				=  :li_co_modulo) AND  
//									( dt_pdnxmodulo.co_fabrica_exp 		=  :li_co_fabrica_exp) AND  
//									( dt_pdnxmodulo.pedido 					=  :ll_pedido) AND  
//									( dt_pdnxmodulo.cs_liberacion 		=  :ll_cs_liberacion) AND  
//									( dt_pdnxmodulo.po 						=  :ls_nu_orden) AND  
//									( dt_pdnxmodulo.co_fabrica_pt 		=  :li_co_fabrica_ref) AND  
//									( dt_pdnxmodulo.co_linea 				=  :li_co_linea_ref) AND  
//									( dt_pdnxmodulo.co_referencia 		=  :ll_co_referencia) AND  
//									( dt_pdnxmodulo.co_color_pt 			=  :ll_color_pt) AND  
//									( dt_pdnxmodulo.tono 					=  :ls_tono) AND  
//									( dt_pdnxmodulo.cs_estilocolortono 	=  :li_cs_estilocolton) ;
//							IF SQLCA.SQLCODE=-1 THEN
//								MessageBox("Error Base Datos","No pudo buscar cuantas asignaciones tiene estos datos para el modulo")
//								RETURN 0
//							ELSE
//							END IF
//										
//							IF ll_asignaciones=0 OR ISNULL(ll_asignaciones) THEN
//								li_cs_particion=li_cs_particion_anterior
//							ELSE
//								// Busca la Particion Maxima y Suma 1
//								SELECT MAX(dt_pdnxmodulo.cs_particion)  
//								 INTO :li_max_particion  
//								 FROM dt_pdnxmodulo  								
//								WHERE ( dt_pdnxmodulo.simulacion 			=  :li_simulacion) AND  
//										( dt_pdnxmodulo.co_fabrica 			=  :li_co_fabrica_modu) AND  
//										( dt_pdnxmodulo.co_planta		 		=  :li_co_planta_modu) AND  
//										( dt_pdnxmodulo.co_modulo 				=  :li_co_modulo) AND  
//										( dt_pdnxmodulo.co_fabrica_exp 		=  :li_co_fabrica_exp) AND  
//										( dt_pdnxmodulo.pedido 					=  :ll_pedido) AND  
//										( dt_pdnxmodulo.cs_liberacion 		=  :ll_cs_liberacion) AND  
//										( dt_pdnxmodulo.po 						=  :ls_nu_orden) AND  
//										( dt_pdnxmodulo.co_fabrica_pt 		=  :li_co_fabrica_ref) AND  
//										( dt_pdnxmodulo.co_linea 				=  :li_co_linea_ref) AND  
//										( dt_pdnxmodulo.co_referencia 		=  :ll_co_referencia) AND  
//										( dt_pdnxmodulo.co_color_pt 			=  :ll_color_pt) AND  
//										( dt_pdnxmodulo.tono 					=  :ls_tono) AND  
//										( dt_pdnxmodulo.cs_estilocolortono 	=  :li_cs_estilocolton) ;
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo buscar la mayor partici$$HEX1$$f300$$ENDHEX$$n para estos datos para el modulo")
//									RETURN 0
//								ELSE
//								END IF
//								
//								IF ISNULL(li_max_particion ) THEN
//									li_max_particion=0
//								ELSE
//								END IF
//								
//								li_max_particion=li_max_particion + 1
//								li_cs_particion=li_max_particion
//							END IF
//							
//							// --------------------
//							// Busca la m$$HEX1$$e100$$ENDHEX$$xima prioridad para ubicar la referencia de ultima
//							// --------------------
//							SELECT max(dt_pdnxmodulo.cs_prioridad)  
//							 INTO :li_cs_prioridad  
//							 FROM dt_pdnxmodulo  
//							WHERE ( dt_pdnxmodulo.simulacion = :li_simulacion ) AND  
//									( dt_pdnxmodulo.co_fabrica = :li_co_fabrica_modu ) AND  
//									( dt_pdnxmodulo.co_planta =  :li_co_planta_modu) AND  
//									( dt_pdnxmodulo.co_modulo =  :li_co_modulo)   ;
//											
//							IF SQLCA.SQLCODE=-1 THEN
//								MessageBox("Error Base Datos","No pudo hallar prioridad para asignaci$$HEX1$$f300$$ENDHEX$$n")
//								RETURN
//							ELSE
//								IF ISNULL(li_cs_prioridad) THEN
//									li_cs_prioridad = 0
//								ELSE
//								END IF
//							END IF
//		
//							// ----------------------
//							// Incrementa la Prioridad en 1, lleva los valores de los campos de 
//							// trabajo a los campos de la linea de detalle 
//							// ----------------------
//							li_cs_prioridad=li_cs_prioridad + 1
//							
//							dw_detalle.SetItem(il_fila_actual_detalle,"simulacion",li_simulacion)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica",li_co_fabrica_modu)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_planta",li_co_planta_modu)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_modulo",li_co_modulo)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica_exp",li_co_fabrica_exp)
//							dw_detalle.SetItem(il_fila_actual_detalle,"pedido",ll_pedido)
//							dw_detalle.SetItem(il_fila_actual_detalle,"cs_liberacion",ll_cs_liberacion)
//							dw_detalle.SetItem(il_fila_actual_detalle,"po",ls_nu_orden)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica_pt",li_co_fabrica_ref)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_linea",li_co_linea_ref)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_referencia",ll_co_referencia)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_color_pt",ll_color_pt)
//							dw_detalle.SetItem(il_fila_actual_detalle,"tono",ls_tono)
//							dw_detalle.SetItem(il_fila_actual_detalle,"cs_estilocolortono",li_cs_estilocolton)
//							dw_detalle.SetItem(il_fila_actual_detalle,"cs_particion",li_cs_particion)
//							
//							dw_detalle.SetItem(il_fila_actual_detalle,"pedido_po",ll_pedido_po)
//							dw_detalle.SetItem(il_fila_actual_detalle,"cs_prioridad",li_cs_prioridad)
//							dw_detalle.SetItem(il_fila_actual_detalle,"ca_programada",ll_ca_programada)
//							dw_detalle.SetItem(il_fila_actual_detalle,"ca_producida",ll_ca_producida)
//							dw_detalle.SetItem(il_fila_actual_detalle,"ca_pendiente",ll_ca_pendiente)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_estado_asigna",li_co_estado_asigna)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_curva",li_co_curva)
//	
//							dw_detalle.SetItem(il_fila_actual_detalle,"ca_minutos_std",ld_ca_minutos_std)
//							dw_detalle.SetItem(il_fila_actual_detalle,"co_tipo_asignacion",li_co_tipo_asignacion)
//							dw_detalle.SetItem(il_fila_actual_detalle,"ca_personasxmod",ll_ca_personasxmod)
//							dw_detalle.SetItem(il_fila_actual_detalle,"cod_tur",li_cod_tur)
//							dw_detalle.SetItem(il_fila_actual_detalle,"minutos_jornada",ld_minutos_jornada)
//							dw_detalle.SetItem(il_fila_actual_detalle,"ind_cambio_estilo",li_ind_cambio_estilo)
//							dw_detalle.SetItem(il_fila_actual_detalle,"ca_unid_base_dia",ll_ca_unidad_base_dia)
//							dw_detalle.SetItem(il_fila_actual_detalle,"orige_uni_base_dia",li_orige_uni_base_dia)
//							dw_detalle.SetItem(il_fila_actual_detalle,"tipo_empate",li_tipo_empate)
//							dw_detalle.SetItem(il_fila_actual_detalle,"unidades_empate",ll_unidades_empate)
//							dw_detalle.SetItem(il_fila_actual_detalle,"metodo_programa",li_metodo_programa)
//							dw_detalle.SetItem(il_fila_actual_detalle,"fuente_dato",li_fuente_dato)
//							
//							ldt_fechahora = f_fecha_servidor()
//								
//							dw_detalle.SetItem(il_fila_actual_detalle,"fe_creacion",ldt_fechahora)
//							dw_detalle.SetItem(il_fila_actual_detalle,"fe_actualizacion",ldt_fechahora)
//							dw_detalle.SetItem(il_fila_actual_detalle,"usuario",gstr_info_usuario.codigo_usuario)
//							dw_detalle.SetItem(il_fila_actual_detalle,"instancia",gstr_info_usuario.instancia)
//							
//							dw_detalle.SetItem(il_fila_actual_detalle,"gpa",ls_gpa)
//									
//							dw_detalle.AcceptText()
//								
//							// ---------------
//							// Graba informacion movida a la linea de detalle (Parametros Programacion)
//							// ---------------
//							THIS.Triggerevent("ue_grabar")
//							
//							// ---------------------
//							// Prepara Parametros para llamar la pantalla de escalas
//							// ---------------------
//							lstr_parametros.entero[1] 		=  li_co_fabrica_exp   
//							lstr_parametros.entero[2]		=  ll_pedido   
//							lstr_parametros.cadena[1] 		=  ls_nu_orden 
//							lstr_parametros.entero[3] 		=  li_co_fabrica_ref
//							lstr_parametros.entero[4] 		=  li_co_linea_ref 
//							lstr_parametros.entero[5] 		=  ll_co_referencia
//							lstr_parametros.entero[6] 		=  ll_color_pt
//							lstr_parametros.entero[7]		=	li_simulacion
//							lstr_parametros.entero[8]		=	li_co_fabrica_modu_ant
//							lstr_parametros.entero[9]		=	li_co_planta_modu_ant			
//							lstr_parametros.entero[10]		=	li_co_modulo_ant			
//							lstr_parametros.entero[11]		=	ll_cs_liberacion
//							lstr_parametros.cadena[2]		=	ls_tono				
//							lstr_parametros.entero[12]		=	li_cs_estilocolton
//							lstr_parametros.entero[13]		=	li_cs_particion
//							lstr_parametros.entero[14]		=	ll_ca_a_sacar
//							lstr_parametros.entero[15]		=	li_co_fabrica_modu
//							lstr_parametros.entero[16]		=	li_co_planta_modu			
//							lstr_parametros.entero[17]		=	li_co_modulo
//							lstr_parametros.entero[18]		=	1
//							lstr_parametros.entero[19]		=	li_cs_particion_anterior
//																			
//							lstr_parametros.hay_parametros=TRUE
//							
//							// --------------------
//							// Asignacion ALLOCATION
//							// Pantalla para division de unidades proyectadas
//							// --------------------
//							IF li_co_tipo_asignacion=1 THEN 
//								OpenWithParm(w_asignar_unid_parciales,lstr_parametros)
//								lstr_parametros = Message.PowerObjectParm
//								IF lstr_parametros.hay_parametros THEN
//									ll_inserto_tallas=1
//								ELSE
//									MessageBox("Error","No se realiz$$HEX2$$f3002000$$ENDHEX$$declaraci$$HEX1$$f300$$ENDHEX$$n de escala a partir")
//									ll_inserto_tallas=0
//								END IF
//							END IF
//// -------------------------------------------
//// codificacion original con pantalla que permite divisones en actuales
//// ---------------------------------------------
////								OpenWithParm(w_asignar_parciales_liberacion,lstr_parametros)
////								lstr_parametros = Message.PowerObjectParm
////								IF lstr_parametros.hay_parametros THEN
////									ll_inserto_tallas=1
////								ELSE
////									MessageBox("Error","No se realiz$$HEX2$$f3002000$$ENDHEX$$declaraci$$HEX1$$f300$$ENDHEX$$n de escala a partir")
////									ll_inserto_tallas=0
////								END IF
//// -----------------------------------------------
//							// --------------------
//							// Asignacion ACTUAL
//							// Crea los registros correspondientes a Tallas en la nueva referencia 
//							// Borra datos de referencia Original  
//							// --------------------
//							IF li_co_tipo_asignacion=2 THEN 
//								// Borra Programacion de la Prioridad Original 
//								DELETE FROM dt_programa_diario  
//								WHERE ( dt_programa_diario.simulacion 				=:li_simulacion  ) AND  
//										( dt_programa_diario.co_fabrica 				=:li_co_fabrica_modu_ant  ) AND  
//										( dt_programa_diario.co_planta 				=:li_co_planta_modu_ant  ) AND  
//										( dt_programa_diario.co_modulo 				=:li_co_modulo_ant  ) AND  
//										( dt_programa_diario.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
//										( dt_programa_diario.pedido 					=:ll_pedido  ) AND  
//										( dt_programa_diario.cs_liberacion 			=:ll_cs_liberacion  ) AND  
//										( dt_programa_diario.po 						=:ls_nu_orden  ) AND  
//										( dt_programa_diario.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
//										( dt_programa_diario.co_linea 				=:li_co_linea_ref  ) AND  
//										( dt_programa_diario.co_referencia 			=:ll_co_referencia  ) AND  
//										( dt_programa_diario.co_color_pt 			=:ll_color_pt  ) AND  
//										( dt_programa_diario.tono 						=:ls_tono  ) AND  
//										( dt_programa_diario.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
//										( dt_programa_diario.cs_particion 			=:li_cs_particion_anterior )   ;
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo borrar Programacion Diaria Original, por favor verifique los datos")
//								ELSE
//								END IF									
//								// Cambia las tallas de la programacioN orignal a la nueva
//								UPDATE 	dt_talla_pdnmodulo
//									SET 	dt_talla_pdnmodulo.co_fabrica 	=:li_co_fabrica_modu,
//											dt_talla_pdnmodulo.co_planta 		=:li_co_planta_modu,
//											dt_talla_pdnmodulo.co_modulo 		=:li_co_modulo,
//											dt_talla_pdnmodulo.cs_particion 	=:li_cs_particion,
//											dt_talla_pdnmodulo.cs_prioridad 	=:li_cs_prioridad
//									WHERE ( dt_talla_pdnmodulo.simulacion 				=:li_simulacion ) AND  
//											( dt_talla_pdnmodulo.co_fabrica 				=:li_co_fabrica_modu_ant ) AND  
//											( dt_talla_pdnmodulo.co_planta 				=:li_co_planta_modu_ant ) AND  
//											( dt_talla_pdnmodulo.co_modulo 				=:li_co_modulo_ant ) AND  
//											( dt_talla_pdnmodulo.co_fabrica_exp 		=:li_co_fabrica_exp ) AND  
//											( dt_talla_pdnmodulo.pedido 					=:ll_pedido ) AND  
//											( dt_talla_pdnmodulo.cs_liberacion 			=:ll_cs_liberacion ) AND  
//											( dt_talla_pdnmodulo.po 						=:ls_nu_orden ) AND  
//											( dt_talla_pdnmodulo.co_fabrica_pt 			=:li_co_fabrica_ref ) AND  
//											( dt_talla_pdnmodulo.co_linea 				=:li_co_linea_ref ) AND  
//											( dt_talla_pdnmodulo.co_referencia 			=:ll_co_referencia ) AND  
//											( dt_talla_pdnmodulo.co_color_pt 			=:ll_color_pt ) AND  
//											( dt_talla_pdnmodulo.tono 						=:ls_tono ) AND  
//											( dt_talla_pdnmodulo.cs_estilocolortono 	=:li_cs_estilocolton ) AND  
//											( dt_talla_pdnmodulo.cs_particion 			=:li_cs_particion_anterior );
//									IF SQLCA.SQLCODE=-1 THEN
//										MessageBox("Error Base Datos","No pudo mover tallas a Modulo Destino, por favor verifique los datos")
//									ELSE
//										// Borra Parametros de Programacio Originales
//										DELETE FROM dt_pdnxmodulo  
//										WHERE ( dt_pdnxmodulo.simulacion 			= :li_simulacion) AND  
//												( dt_pdnxmodulo.co_fabrica 			= :li_co_fabrica_modu_ant ) AND  
//												( dt_pdnxmodulo.co_planta 				= :li_co_planta_modu_ant ) AND  
//												( dt_pdnxmodulo.co_modulo 				= :li_co_modulo_ant ) AND  
//												( dt_pdnxmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//												( dt_pdnxmodulo.pedido 					= :ll_pedido ) AND  
//												( dt_pdnxmodulo.cs_liberacion 		= :ll_cs_liberacion ) AND  
//												( dt_pdnxmodulo.po 						= :ls_nu_orden ) AND  
//												( dt_pdnxmodulo.co_fabrica_pt 		= :li_co_fabrica_ref ) AND  
//												( dt_pdnxmodulo.co_linea 				= :li_co_linea_ref ) AND  
//												( dt_pdnxmodulo.co_referencia 		= :ll_co_referencia ) AND  
//												( dt_pdnxmodulo.co_color_pt 			= :ll_color_pt ) AND  
//												( dt_pdnxmodulo.tono 					= :ls_tono ) AND  
//												( dt_pdnxmodulo.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
//												( dt_pdnxmodulo.cs_particion 			= :li_cs_particion_anterior );
//										IF SQLCA.SQLCODE=-1 THEN
//											MessageBox("Error Base Datos","No pudo borrar parametros programacion original,por favor verifique los datos ")
//										ELSE 
//											ll_inserto_tallas=1
//										END IF
//								END IF
//							END IF
//
//							// ---------------------------------
//							// En caso de Cancelar el proceso borra lo creado 			
//							// ---------------------------------
//							IF ll_inserto_tallas=1 THEN
//							ELSE
//								// -------------------
//								// Este juego de Borrados se hace si se cancela el proceso de 
//								// Traslado o division 
//								// -------------------
//								// Borra Programacion Diaria 
//								// -------------------
//								DELETE FROM dt_programa_diario  
//								WHERE ( dt_programa_diario.simulacion 					=:li_simulacion  ) AND  
//											( dt_programa_diario.co_fabrica 				=:li_co_fabrica_modu  ) AND  
//											( dt_programa_diario.co_planta 				=:li_co_planta_modu  ) AND  
//											( dt_programa_diario.co_modulo 				=:li_co_modulo  ) AND  
//											( dt_programa_diario.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
//											( dt_programa_diario.pedido 					=:ll_pedido  ) AND  
//											( dt_programa_diario.cs_liberacion 			=:ll_cs_liberacion  ) AND  
//											( dt_programa_diario.po 						=:ls_nu_orden  ) AND  
//											( dt_programa_diario.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
//											( dt_programa_diario.co_linea 				=:li_co_linea_ref  ) AND  
//											( dt_programa_diario.co_referencia 			=:ll_co_referencia  ) AND  
//											( dt_programa_diario.co_color_pt 			=:ll_color_pt  ) AND  
//											( dt_programa_diario.tono 						=:ls_tono  ) AND  
//											( dt_programa_diario.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
//											( dt_programa_diario.cs_particion 			=:li_cs_particion )   ;
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo borrar Programacion Diaria, por favor verifique los datos")
//								ELSE
//								END IF
//								// -------------------
//								// Borra Tallas de Escala 
//								// -------------------
//								DELETE FROM dt_talla_pdnmodulo  
//									WHERE ( dt_talla_pdnmodulo.simulacion 				=:li_simulacion  ) AND  
//											( dt_talla_pdnmodulo.co_fabrica 				=:li_co_fabrica_modu  ) AND  
//											( dt_talla_pdnmodulo.co_planta 				=:li_co_planta_modu  ) AND  
//											( dt_talla_pdnmodulo.co_modulo 				=:li_co_modulo  ) AND  
//											( dt_talla_pdnmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
//											( dt_talla_pdnmodulo.pedido 					=:ll_pedido  ) AND  
//											( dt_talla_pdnmodulo.cs_liberacion 			=:ll_cs_liberacion  ) AND  
//											( dt_talla_pdnmodulo.po 						=:ls_nu_orden  ) AND  
//											( dt_talla_pdnmodulo.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
//											( dt_talla_pdnmodulo.co_linea 				=:li_co_linea_ref  ) AND  
//											( dt_talla_pdnmodulo.co_referencia 			=:ll_co_referencia  ) AND  
//											( dt_talla_pdnmodulo.co_color_pt 			=:ll_color_pt  ) AND  
//											( dt_talla_pdnmodulo.tono 						=:ls_tono  ) AND  
//											( dt_talla_pdnmodulo.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
//											( dt_talla_pdnmodulo.cs_particion 			=:li_cs_particion )   ;
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo borrar tallas de asignaci$$HEX1$$f300$$ENDHEX$$n, por favor verifique los datos")
//								ELSE
//									// -------------------
//									// Borra Parametros de Porgramacion 
//									// -------------------
//									DELETE FROM dt_pdnxmodulo  
//										WHERE ( dt_pdnxmodulo.simulacion 			= :li_simulacion) AND  
//												( dt_pdnxmodulo.co_fabrica 			= :li_co_fabrica_modu ) AND  
//												( dt_pdnxmodulo.co_planta 				= :li_co_planta_modu ) AND  
//												( dt_pdnxmodulo.co_modulo 				= :li_co_modulo ) AND  
//												( dt_pdnxmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//												( dt_pdnxmodulo.pedido 					= :ll_pedido ) AND  
//												( dt_pdnxmodulo.cs_liberacion 		= :ll_cs_liberacion ) AND  
//												( dt_pdnxmodulo.po 						= :ls_nu_orden ) AND  
//												( dt_pdnxmodulo.co_fabrica_pt 		= :li_co_fabrica_ref ) AND  
//												( dt_pdnxmodulo.co_linea 				= :li_co_linea_ref ) AND  
//												( dt_pdnxmodulo.co_referencia 		= :ll_co_referencia ) AND  
//												( dt_pdnxmodulo.co_color_pt 			= :ll_color_pt ) AND  
//												( dt_pdnxmodulo.tono 					= :ls_tono ) AND  
//												( dt_pdnxmodulo.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
//												( dt_pdnxmodulo.cs_particion 			= :li_cs_particion )   ;
//									IF SQLCA.SQLCODE=-1 THEN
//										MessageBox("Error Base Datos","No pudo borrar dt_pdnxmodulo en asignaci$$HEX1$$f300$$ENDHEX$$n")
//									ELSE 
//									END IF
//								END IF
//							END IF 
//
//						// ---------------
//						// Graba la informacion actualizada 
//						// ---------------
//						THIS.Triggerevent("ue_grabar")
//
//						// ------------------------------------------------------------------------------ //
//						// ------------- Renumera Detalles para organizar Prioridades de Asignacion ----- //
//						// -------------       Extraido de itemchange() de dw_detalle               ----- //
//		
//						// Ciclo para recorrer las prioridades Prinicipio a Fin 
//		
//						// Arma Llave de Lectura de Programacion 
//						li_cs_prioridad_ciclo=0
//						DECLARE cur_asignaciones CURSOR FOR  
//	  					SELECT 	dt_pdnxmodulo.co_fabrica_exp,   
//									dt_pdnxmodulo.pedido,   
//									dt_pdnxmodulo.cs_liberacion,   
//									dt_pdnxmodulo.po,   
//									dt_pdnxmodulo.co_fabrica_pt,   
//									dt_pdnxmodulo.co_linea,   
//									dt_pdnxmodulo.co_referencia,   
//									dt_pdnxmodulo.co_color_pt,   
//									dt_pdnxmodulo.tono,   
//									dt_pdnxmodulo.cs_estilocolortono,   
//									dt_pdnxmodulo.cs_particion,   
//									dt_pdnxmodulo.cs_prioridad
//						FROM dt_pdnxmodulo  
//						WHERE ( dt_pdnxmodulo.simulacion 		= 	:li_simulacion ) AND  
//								( dt_pdnxmodulo.co_fabrica 		= 	:li_co_fabrica_modu_ant ) AND  
//								( dt_pdnxmodulo.co_planta 			= 	:li_co_planta_modu_ant ) AND  
//								( dt_pdnxmodulo.co_modulo 			= 	:li_co_modulo_ant )
//						ORDER BY dt_pdnxmodulo.cs_prioridad;			
//							
//						// Abre Archivo de Parametros de Programacion
//						OPEN cur_asignaciones;
//						IF SQLCA.SQLCODE=-1 THEN
//							MessageBox("Error Base Datos","No pudo abrir la busqueda de Asignaciones para reordenar prioridades")
//							RETURN 1
//						ELSE
//						END IF
//					
//						// Lee registros de Programaciones
//						FETCH cur_asignaciones INTO 	:li_co_fabrica_exp,
//																:ll_pedido,
//																:ll_cs_liberacion,
//																:ls_nu_orden,
//																:li_co_fabrica_ref,
//																:li_co_linea_ref,
//																:ll_co_referencia,
//																:ll_color_pt ,
//																:ls_tono,
//																:li_cs_estilocolton,
//																:li_cs_particion,
//																:li_cs_prioridad;
//						IF SQLCA.SQLCODE=-1 THEN
//							MessageBox("Error Base Datos","No pudo leer Asignaciones para reordenar prioridades")
//							RETURN 1
//						ELSE
//						END IF
//					
//						// Ciclo de Lectura de todas las Programaciones
//						DO WHILE SQLCA.SQLCODE=0 
//						
//							li_cs_prioridad_ciclo=li_cs_prioridad_ciclo + 1
//							// Actualiza Nueva Prioridad
//							UPDATE dt_pdnxmodulo SET cs_prioridad		=:li_cs_prioridad_ciclo
//							WHERE ( dt_pdnxmodulo.simulacion 			=:li_simulacion ) AND  
//									( dt_pdnxmodulo.co_fabrica 			=:li_co_fabrica_modu_ant ) AND  
//									( dt_pdnxmodulo.co_planta 				=:li_co_planta_modu_ant ) AND  
//									( dt_pdnxmodulo.co_modulo 				=:li_co_modulo_ant ) AND  
//									( dt_pdnxmodulo.co_fabrica_exp 		=:li_co_fabrica_exp ) AND  
//									( dt_pdnxmodulo.pedido 					=:ll_pedido ) AND  
//									( dt_pdnxmodulo.cs_liberacion 		=:ll_cs_liberacion ) AND  
//									( dt_pdnxmodulo.po 						=:ls_nu_orden ) AND  
//									( dt_pdnxmodulo.co_fabrica_pt 		=:li_co_fabrica_ref ) AND  
//									( dt_pdnxmodulo.co_linea 				=:li_co_linea_ref ) AND  
//									( dt_pdnxmodulo.co_referencia 		=:ll_co_referencia ) AND  
//									( dt_pdnxmodulo.co_color_pt 			=:ll_color_pt ) AND  
//									( dt_pdnxmodulo.tono 					=:ls_tono ) AND  
//									( dt_pdnxmodulo.cs_estilocolortono 	=:li_cs_estilocolton ) AND  
//									( dt_pdnxmodulo.cs_particion 			=:li_cs_particion);
//							IF SQLCA.SQLCODE= -1 THEN
//									MessageBox("Error Base Datos","No pudo Actualizar la prioridad en la nueva asignaci$$HEX1$$f300$$ENDHEX$$n")
//									RETURN	0
//							ELSE
//							END IF
//						
//							// Lee siguiente Registro de Programacion
//							FETCH cur_asignaciones INTO 	:li_co_fabrica_exp,
//																	:ll_pedido,
//																	:ll_cs_liberacion,
//																	:ls_nu_orden,
//																	:li_co_fabrica_ref,
//																	:li_co_linea_ref,
//																	:ll_co_referencia,
//																	:ll_color_pt ,
//																	:ls_tono,
//																	:li_cs_estilocolton,
//																	:li_cs_particion,
//																	:li_cs_prioridad;
//							IF SQLCA.SQLCODE=-1 THEN
//								MessageBox("Error Base Datos","No pudo Leer siguiente Asignacion para reordenar prioridades")
//							ELSE
//							END IF
//					
//
//						LOOP	// DO WHILE SQLCA.SQLCODE=0 
//						// ---------------
//						// Graba la informacion actualizada 
//						// ---------------
//						THIS.Triggerevent("ue_grabar")
//		
//						// -------------------
//						// Ejecuta recalculo de programacion de produccion
//						// Para Modulo Destino. Organiza variables instancia
//						// -------------------
//						ii_traslado = 1
//						ii_co_fabrica_modu 		= li_co_fabrica_modu
//						ii_co_planta_modu 		= li_co_planta_modu
//						ii_co_modulo 				= li_co_modulo
//						
//						This.Triggerevent("ue_recalcular")			
//
//						ii_traslado = 0
//						ii_co_fabrica_modu 		= 0
//						ii_co_planta_modu 		= 0
//						ii_co_modulo 				= 0
//						
//						// -------------------
//						// Ejecuta recalculo de programacion de produccion
//						// Para Modulo origen.
//						// -------------------
//						This.Triggerevent("ue_recalcular")		
//						
//						commit ;
//
//						// hacer retrieve de dw_maestro.
//									
//							ll_hallados = dw_maestro.Retrieve(ls_de_modulo)					
//							IF isnull(ll_hallados) THEN
//								MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//							ELSE
//								CHOOSE CASE ll_hallados
//									CASE -1
//										il_fila_actual_maestro = -1
//										MessageBox("Error buscando","Error de la base",StopSign!,&
//													 Ok!)
//									CASE 0
//										il_fila_actual_maestro = 0
//									CASE ELSE
//										il_fila_actual_maestro = 1
//										//hacer retrieve de dw_detalle.
//										ll_hallados = dw_detalle.Retrieve(li_co_fabrica_modu_ant,li_co_planta_modu_ant,li_co_modulo_ant,li_simulacion)					
//										IF isnull(ll_hallados) THEN
//											MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//										ELSE
//											CHOOSE CASE ll_hallados
//												CASE -1
//													il_fila_actual_detalle = -1
//													MessageBox("Error buscando","Error de la base",StopSign!,&
//																 Ok!)
//												CASE 0
//													il_fila_actual_detalle = 0
//												CASE ELSE
//													il_fila_actual_detalle = li_cs_prioridad
//											END CHOOSE
//										END IF
//								END CHOOSE
//							END IF //IF isnull(ll_hallados) THEN												
//						ELSE
//						END IF // IF ((il_fila_actual_detalle<> -1) and (NOT ISNULL (il_fila_actual_detalle)) and (il_fila_actual_detalle<>0))THEN
//					END IF // IF ll_fila = -1 THEN
//				//no trajo par$$HEX1$$e100$$ENDHEX$$metros de ventana de cambio de m$$HEX1$$f300$$ENDHEX$$dulo, cancel$$HEX2$$f3002000$$ENDHEX$$el cambio de m$$HEX1$$f300$$ENDHEX$$dulo
//				ELSE
//				END IF
//			END IF
//		END IF
//	ELSE
//		MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
//	END IF
//ELSE
//END IF
//
end event

event ue_recalcular;//Long	li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion,li_cs_prioridad
//LONG	ll_fila,ll_i,ll_result
//DATE ld_fecha
//STRING ls_sqlerr
//s_base_parametros lstr_parametro
//n_cts_corte luo_corte
//DataStore lds_mod
//
//luo_corte = Create n_cts_corte
//lds_mod = Create DataStore
//
//lds_mod.DataObject = 'd_lista_m_modulos'
//
//lds_mod.SetTransObject(sqlca)
//
//TriggerEvent("ue_grabar")
//
//dw_detalle.AcceptText()
//
//If il_fila_actual_detalle <= 0 Then 
//	MessageBox('Advertencia','Se debe seleccionar un registro, del modulo a recalcular')
//	Return
//End if
//	
//li_co_fabrica_modu = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
//li_co_planta_modu  = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_planta")
//
//
//ll_result = lds_mod.Retrieve(li_co_fabrica_modu,li_co_planta_modu)		
//
//For ll_fila = 1 To ll_result
// 
//	li_co_modulo = lds_mod.GetItemNumber(ll_fila, "co_modulo")		
//	
//	select min(cs_prioridad)
//	into :li_cs_prioridad
//	from dt_pdnxmodulo
//	where simulacion 			=  1 and
//			co_fabrica 			= :li_co_fabrica_modu and
//			co_planta 			= :li_co_planta_modu and
//			co_modulo 			= :li_co_modulo and
//			co_estado_asigna 	< 10;
//	
//	If Sqlca.SqlCode = -1 Then
//		ls_sqlerr = Sqlca.SqlErrText
//		rollback ;
//		MessageBox("Advertencia!","Hubo un error al buscar la prioridad.~n~n~nNota: " + ls_sqlerr )
//		Return
//	End If		
//		
//	
////	If li_cs_prioridad > 1 Then
////		select max(Date(dt_programa_diario.fe_inicio)) 
////		  into :ld_fecha
////		from dt_pdnxmodulo,   
////			  dt_programa_diario  
////	  where ( dt_programa_diario.simulacion 			= dt_pdnxmodulo.simulacion ) and  
////			  ( dt_programa_diario.co_fabrica 			= dt_pdnxmodulo.co_fabrica ) and  
////			  ( dt_programa_diario.co_planta 			= dt_pdnxmodulo.co_planta ) and  
////			  ( dt_programa_diario.co_modulo 			= dt_pdnxmodulo.co_modulo ) and  
////			  ( dt_programa_diario.co_fabrica_exp 		= dt_pdnxmodulo.co_fabrica_exp ) and  
////			  ( dt_programa_diario.pedido 				= dt_pdnxmodulo.pedido ) and  
////			  ( dt_programa_diario.cs_liberacion 		= dt_pdnxmodulo.cs_liberacion ) and  
////			  ( dt_programa_diario.po 						= dt_pdnxmodulo.po ) and  
////			  ( dt_programa_diario.co_fabrica_pt 		= dt_pdnxmodulo.co_fabrica_pt ) and  
////			  ( dt_programa_diario.co_linea 				= dt_pdnxmodulo.co_linea ) and  
////			  ( dt_programa_diario.co_referencia 		= dt_pdnxmodulo.co_referencia ) and  
////			  ( dt_programa_diario.co_color_pt 			= dt_pdnxmodulo.co_color_pt ) and  
////			  ( dt_programa_diario.tono 					= dt_pdnxmodulo.tono ) and  
////			  ( dt_programa_diario.cs_estilocolortono = dt_pdnxmodulo.cs_estilocolortono ) and  
////			  ( dt_programa_diario.cs_particion 		= dt_pdnxmodulo.cs_particion ) and  
////			  ( dt_pdnxmodulo.simulacion 					= 1 ) AND  
////			  ( dt_pdnxmodulo.co_fabrica 					= :li_co_fabrica_modu ) AND  
////			  ( dt_pdnxmodulo.co_planta 					= :li_co_planta_modu ) AND  
////			  ( dt_pdnxmodulo.co_modulo 					= :li_co_modulo ) AND  
////			  ( dt_pdnxmodulo.cs_prioridad 				= :li_cs_prioridad /*-1*/ )  ;
////			  
////		If Sqlca.SqlCode = -1 Then
////			ls_sqlerr = Sqlca.SqlErrText
////			rollback ;
////			MessageBox("Advertencia!","Hubo un error al buscar la fecha de inicio.~n~n~nNota: " + ls_sqlerr )
////			Return
////		End If
//		
////		If IsNull(ld_fecha) Then
////			ld_fecha = Date(f_fecha_servidor())
////		End IF
////	Else
////		If li_cs_prioridad = 1 Then
////			ld_fecha = date(dw_detalle.GetItemDatetime(il_fila_actual_detalle,'fe_inicio_prog'))
////		Else
//			ld_fecha = Date(f_fecha_servidor())
////		End if
////	End If
//
//	//calcula las fechas apartir de la prioridad para el modulo especifico
//	If luo_corte.Of_MetodoMinutos(1,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,&
//			 li_cs_prioridad,ld_fecha) = -1 Then
//	Else
//		//commit ;
//	End if
//
//Next
//
//ii_repriorizar = 0
//Commit;
//
//Destroy n_cts_corte
//Destroy lds_mod
//
//dw_detalle.Retrieve(91,1,1)
//il_fila_actual_maestro = 1
//
//
end event

event ue_reporte102;//Long 					ll_fila
//DateTime 			ldt_fechahora
//Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
//s_base_parametros lstr_parametros
//Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
//LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
//Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
//STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido
//
//LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
//LONG					li_unidades_empate
//Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
//Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,ll_asignaciones
//DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
//DECIMAL				ld_ca_minutos_std
//w_parametros_asignacion	w_instancia
//
//li_simulacion 				= dw_detalle.GetitemNumber(il_fila_actual_detalle,"simulacion")
//li_co_fabrica_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
//li_co_planta_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
//li_co_modulo 				= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_modulo")
//	
//	
//lstr_parametros.entero[1]			=	li_simulacion
//lstr_parametros.entero[2]			=	li_co_fabrica_modu
//lstr_parametros.entero[3]			=	li_co_planta_modu
//lstr_parametros.entero[4]			=	li_co_modulo	
//
//lstr_parametros.Hay_Parametros	=	TRUE		
//OpenSheetWithParm(w_preview_impresion_prog_102, lstr_parametros, w_principal, 1, Layered!)			
//
//	
//
//
//
//
//
//
end event

event ue_fecha_requisito();n_cts_param luo_param
Long ll_fila


ll_fila = dw_detalle.GetRow()


If ll_fila <= 0 Then Return

luo_param.il_vector[1] = dw_detalle.GetItemNumber(ll_fila,"simulacion")
luo_param.il_vector[2] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_fabrica")
luo_param.il_vector[3] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_planta")
luo_param.il_vector[4] = dw_detalle.GetItemNumber(ll_fila,"co_modulo")
luo_param.il_vector[5] = dw_detalle.GetItemNumber(ll_fila,"co_fabrica_exp")
luo_param.il_vector[6] = dw_detalle.GetItemNumber(ll_fila,"pedido")
luo_param.il_vector[7] = dw_detalle.GetItemNumber(ll_fila,"cs_liberacion")
luo_param.il_vector[8] = dw_detalle.GetItemNumber(ll_fila,"co_fabrica_pt")
luo_param.il_vector[9] = dw_detalle.GetItemNumber(ll_fila,"co_linea")
luo_param.il_vector[10] = dw_detalle.GetItemNumber(ll_fila,"co_referencia")
luo_param.il_vector[11] = dw_detalle.GetItemNumber(ll_fila,"co_color_pt")
luo_param.il_vector[12] = dw_detalle.GetItemNumber(ll_fila,"cs_estilocolortono")
luo_param.il_vector[13] = dw_detalle.GetItemNumber(ll_fila,"cs_particion")

luo_param.is_vector[1] = dw_detalle.GetItemString(ll_fila,"po")
luo_param.is_vector[2] = dw_detalle.GetItemString(ll_fila,"tono")

OpenWithParm(w_fecha_requisito,luo_param)
end event

event ue_agrupar;//este evento ya no es vigente en esta ventana
//
//If dw_detalle.GetSelectedRow(0) <= 0 Then 
//	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar las filas que desea en la agrupaci$$HEX1$$f300$$ENDHEX$$n.")
//	Return
//End If
//
//OpenWithParm(w_agrupaciones_2,dw_detalle)
end event

event ue_observaciones();//n_cts_param luo_param
//Long ll_fila
//
//
//ll_fila = dw_detalle.GetRow()
//
//
//If ll_fila <= 0 Then Return
//
//luo_param.il_vector[1] = dw_detalle.GetItemNumber(ll_fila,"simulacion")
//luo_param.il_vector[2] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_fabrica")
//luo_param.il_vector[3] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_planta")
//luo_param.il_vector[4] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_modulo")
//luo_param.il_vector[5] = dw_detalle.GetItemNumber(ll_fila,"co_fabrica_exp")
//luo_param.il_vector[6] = dw_detalle.GetItemNumber(ll_fila,"pedido")
//luo_param.il_vector[7] = dw_detalle.GetItemNumber(ll_fila,"cs_liberacion")
//luo_param.il_vector[8] = dw_detalle.GetItemNumber(ll_fila,"co_fabrica_pt")
//luo_param.il_vector[9] = dw_detalle.GetItemNumber(ll_fila,"co_linea")
//luo_param.il_vector[10] = dw_detalle.GetItemNumber(ll_fila,"co_referencia")
//luo_param.il_vector[11] = dw_detalle.GetItemNumber(ll_fila,"co_color_pt")
//luo_param.il_vector[12] = dw_detalle.GetItemNumber(ll_fila,"cs_estilocolortono")
//luo_param.il_vector[13] = dw_detalle.GetItemNumber(ll_fila,"cs_particion")
//
//luo_param.is_vector[1] = dw_detalle.GetItemString(ll_fila,"po")
//luo_param.is_vector[2] = dw_detalle.GetItemString(ll_fila,"tono")
//
//OpenSheetWithParm(w_observacion,luo_param,w_principal)
end event

event ue_liquidados();//Open(w_liquidados)
end event

event ue_prioridad();////reordena todos las prioridades de los m$$HEX1$$f300$$ENDHEX$$dulos eliminando huecos en estas
////elaborado por juan carlos restrepo medina, marzo 5 del 2003
//Long ll_result,ll_mod,ll_fila
//DataStore lds_mod
//
//lds_mod = Create DataStore
//lds_mod.DataObject = 'dddw_m_modulos'
//lds_mod.SetTransObject(sqlca)
//
//lds_mod.Retrieve(91,1)
//
//ll_result = lds_mod.RowCount()
//
//If ll_result > 0 Then
//	For ll_fila = 1 To lds_mod.RowCount()
//		ll_mod = lds_mod.GetItemNumber(ll_fila,'co_modulo')
//		If f_actualizar_prioridades(1,91,1,ll_mod) = -1 Then
//			Rollback;
//			Return
//		End if
//	Next
//End if
//
//TriggerEvent("ue_grabar")

end event

public function date wf_traer_fechas (long an_co_fabrica_mod, long an_co_planta_mod, long an_co_modulo, long an_co_turno, datetime adt_fecha, long an_numero_dias, long an_tipo_avance);LONG			ll_dias_que_lleva

DATE			ldt_fe_retorno,ldt_fe_cursor,ldt_fe_calendario_modulo 


SETNULL(ldt_fe_retorno)

//
////debe hacer un ciclo para saber que fecha le corresponde en el calendario
IF an_tipo_avance = 1 THEN //hacia adelante
	DECLARE cur_calendario_ade CURSOR FOR  
	  SELECT m_calendario_cont.fe_calendario  
		 FROM m_calendario_cont  
		WHERE ( m_calendario_cont.ano > 0 ) AND  
				( m_calendario_cont.fe_calendario > EXTEND(:adt_fecha, YEAR TO DAY) )   
	ORDER BY m_calendario_cont.fe_calendario ASC;
	
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO BUSCAR FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	OPEN cur_calendario_ade;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO ABRIR BUSQUEDA DE FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	FETCH  cur_calendario_ade INTO :ldt_fe_cursor;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO TRAER BUSQUEDA DE FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
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
					MESSAGEBOX("ERROR BASE DATOS","NO PUDO TRAER BUSQUEDA DE FECHA EN CALENDARIO General")
					SETNULL(ldt_fe_retorno)
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=100 THEN
					ldt_fe_retorno=ldt_fe_cursor
					SQLCA.SQLCODE=-1
				ELSE
					IF SQLCA.SQLCODE=-1 THEN
						MESSAGEBOX("ERROR BASE DATOS","NO pudo buscar excepci$$HEX1$$f300$$ENDHEX$$n en el calendario por modulo")
						SETNULL(ldt_fe_retorno)
					ELSE
					END IF
				END IF
			END IF

		ELSE
			FETCH  cur_calendario_ade INTO :ldt_fe_cursor;
			IF SQLCA.SQLCODE=-1 THEN
				MESSAGEBOX("ERROR BASE DATOS","NO PUDO TRAER BUSQUEDA DE FECHA EN CALENDARIO General")
				SETNULL(ldt_fe_retorno)
			ELSE
			END IF
		END IF
		
	LOOP
	
	CLOSE cur_calendario_ade;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO cerrar la BUSQUEDA DE FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF

ELSE //tipo avance=2
	
	DECLARE cur_calendario_atr CURSOR FOR  
	  SELECT m_calendario_cont.fe_calendario  
		 FROM m_calendario_cont  
		WHERE ( m_calendario_cont.ano > 0 ) AND  
				( m_calendario_cont.fe_calendario > EXTEND(:adt_fecha, YEAR TO DAY) )   
	ORDER BY m_calendario_cont.fe_calendario DESC;
	
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO BUSCAR FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
	OPEN cur_calendario_atr;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO ABRIR BUSQUEDA DE FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
		
	ELSE
	END IF
	
	FETCH  cur_calendario_atr INTO :ldt_fe_cursor;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO TRAER BUSQUEDA DE FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF
	
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
					MESSAGEBOX("ERROR BASE DATOS","NO PUDO TRAER BUSQUEDA DE FECHA EN CALENDARIO General")
					SETNULL(ldt_fe_retorno)
				ELSE
				END IF
			ELSE
				IF SQLCA.SQLCODE=100 THEN
					ldt_fe_retorno=ldt_fe_cursor
					SQLCA.SQLCODE=-1
				ELSE
					IF SQLCA.SQLCODE=-1 THEN
						MESSAGEBOX("ERROR BASE DATOS","NO pudo buscar excepci$$HEX1$$f300$$ENDHEX$$n en el calendario por modulo")
						SETNULL(ldt_fe_retorno)
					ELSE
					END IF
				END IF
			END IF

		ELSE
			FETCH  cur_calendario_atr INTO :ldt_fe_cursor;
			IF SQLCA.SQLCODE=-1 THEN
				MESSAGEBOX("ERROR BASE DATOS","NO PUDO TRAER BUSQUEDA DE FECHA EN CALENDARIO General")
				SETNULL(ldt_fe_retorno)
			ELSE
			END IF
		END IF
		
	LOOP
	
	CLOSE cur_calendario_atr;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("ERROR BASE DATOS","NO PUDO cerrar la BUSQUEDA DE FECHA EN CALENDARIO General")
		SETNULL(ldt_fe_retorno)
	ELSE
	END IF

	
END IF


RETURN ldt_fe_retorno
end function

public function long wf_reordenar_prioridad_nueva (long al_modulo, long al_pract, long al_prnue);String ls_expresion
Long ll_filact,ll_fila,ll_i,ll_co_modulo,ll_filnue,ll_prioridad


ll_fila = dw_detalle.GetRow()

ls_expresion = " cs_prioridad = " + String(al_pract) + " and co_modulo = " + String(al_modulo)
ll_filact = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())


ls_expresion = " cs_prioridad = " + String(al_prnue) + " and co_modulo = " + String(al_modulo)
ll_filnue = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())

If isnull(ll_filnue) Or ll_filnue = 0 Then
	ls_expresion = " co_modulo = " + String(al_modulo)
	ll_filnue = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())
End if



//reordeno la prioridades que dependiendo del caso se incrementan o se disminuyen,
//y ubico la prioridad que sera reasignada
If ll_filact < ll_filnue Then 
	//ll_prioridad = al_pract
	For ll_i = (ll_filact + 1) To ll_filnue
		ll_prioridad = dw_detalle.GetItemNumber(ll_i,'cs_prioridad')
		ll_prioridad -= 1
		ll_co_modulo = dw_detalle.getitemnumber(ll_i, 'co_modulo')
		IF al_modulo = ll_co_modulo THEN 
			dw_detalle.SetItem(ll_i,'cs_prioridad',ll_prioridad)
		END IF
	Next
	dw_detalle.SetItem(ll_fila,'cs_prioridad',al_prnue)
	il_fila_actual_detalle = ll_filact
Else
	ll_prioridad = al_prnue
	For ll_i = ll_filnue To (ll_filact - 1)
		
		ll_co_modulo = dw_detalle.getitemnumber(ll_i, 'co_modulo')
		ll_prioridad += 1
		IF al_modulo = ll_co_modulo THEN 
			dw_detalle.SetItem(ll_i,'cs_prioridad',ll_prioridad)
		END IF
		
	Next
	dw_detalle.SetItem(ll_fila,'cs_prioridad',al_prnue)
	il_fila_actual_detalle = ll_filnue
End If

dw_detalle.SetSort("co_modulo A,cs_prioridad A")
dw_detalle.Sort()

dw_detalle.SetRow(ll_fila)

//ii_repriorizar = 1

Return 0
end function

public function long wf_reordenar_prioridad (long ai_modulo, long ai_prdact, long ai_prdnue);Long ll_i,ll_co_modulo,ll_num_reg,ll_fila,ll_pos,ll_filact,ll_filnue,ll_simulacion,ll_fabrica,ll_planta
String ls_expresion,DWfilter2

SetPointer(HourGlass!)

//genero un filtro de dw_detalle para que solo esten los datos del modulo que sera afectado
DWfilter2 = "co_modulo = " +String(ai_modulo)
dw_detalle.SetFilter(DWfilter2)
dw_detalle.Filter( )

//busco la fila donde donde se encuentra ubicada la prioridad actual 
ls_expresion = " cs_prioridad = " + String(ai_prdact)
ll_filact = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())

//ll_fila = ii_incremento
ll_fila = ll_filact

//busco la fila donde se encuentra la prioridad nueva
Do
	ls_expresion = " cs_prioridad = " + String(ai_prdnue)
	ll_filnue = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())
	
	IF ai_prdact > ai_prdnue THEN
		ai_prdnue += 1
	ELSE 
		ai_prdnue -= 1
	END IF

Loop Until ll_filnue <> 0

//reordeno la prioridades que dependiendo del caso se incrementan o se disminuyen,
//y ubico la prioridad que sera reasignada
If ll_filact < ll_filnue Then 
	For ll_i = (ll_filact + 1) To ll_filnue
		ll_co_modulo = dw_detalle.getitemnumber(ll_i, 'co_modulo')
		IF ai_modulo = ll_co_modulo THEN 
			dw_detalle.SetItem(ll_i,'cs_prioridad',ll_i -1)
		END IF
	Next
	dw_detalle.SetItem(ll_fila,'cs_prioridad',ll_filnue)
	il_fila_actual_detalle = ll_filact
Else
	For ll_i = ll_filnue To (ll_filact - 1)
		ll_co_modulo = dw_detalle.getitemnumber(ll_i, 'co_modulo')
		IF ai_modulo = ll_co_modulo THEN 
			dw_detalle.SetItem(ll_i,'cs_prioridad',ll_i +1)
		END IF
	Next
	dw_detalle.SetItem(ll_fila,'cs_prioridad',ll_filnue)
	il_fila_actual_detalle = ll_filnue
End If

//grabo las cambios y restauro la dw_detalle a su filtro original
//dw_detalle.Update()
dw_detalle.SetFilter('')
dw_detalle.Filter()

//ordeno la dw_detalle por prioridad
dw_detalle.SetSort("co_modulo A,cs_prioridad A")
dw_detalle.Sort()
//ubico el cursor en la fila que fue afectada
dw_detalle.SetRow(ll_fila)

//ii_repriorizar igual a 1 al momento de salir me dice que se realizo una repriorizacion y no sean
//recalculado las fechas, igual a 0, me dices que puede salir normal.
//ii_repriorizar = 1

return 0
end function

public function long wf_reordenar (long al_modulo, long al_pract, long al_prnue);String ls_expresion
Long ll_fila

ls_expresion = " co_modulo = "+String(al_modulo)+ " and cs_prioridad >= "+String(al_prnue)+" and cs_prioridad < "+String(al_pract) 
dw_detalle.setFilter(ls_expresion)
dw_detalle.filter()

For ll_fila = 1 To dw_detalle.rowcount() - 1
	al_prnue += 1
	dw_detalle.setItem(ll_fila,'cs_prioridad',al_prnue)
Next

dw_detalle.SetFilter("")
dw_detalle.filter()

dw_detalle.Sort()

dw_detalle.acceptText()

ii_repriorizar = 1
return 0
end function

public function long wf_reordenar_descendente (long al_modulo, long al_pract, long al_prnue);String ls_expresion
Long ll_fila

ls_expresion = " co_modulo = "+String(al_modulo)+ " and cs_prioridad <= "+String(al_prnue)+" and cs_prioridad > "+String(al_pract) 
dw_detalle.setFilter(ls_expresion)
dw_detalle.filter()

For ll_fila = 2 To dw_detalle.rowcount() 
	dw_detalle.setItem(ll_fila,'cs_prioridad',al_pract)
	al_pract += 1
Next

dw_detalle.SetFilter("")
dw_detalle.Filter()

dw_detalle.Sort()

dw_detalle.AcceptText()

ii_repriorizar = 1
return 0
end function

public function long wf_insert_dt_telasxoc ();Long ll_fila,ll_est_new,old,ll_ordcorte,ll_i,ll_reftel,ll_caract,ll_diamet,ll_color,ll_fab,ll_count,ll_prioridad,&
	ll_tipo
String ls_tono
Decimal ldc_cant,ldc_requeridad,ldc_total,ldc_porc_desperdicio
DateTime ldt_fe_creacion,ldt_fe_actualizacion
DataStore lds_telasxoc

//Data store para saber las escalas que posee una orden de corte
lds_telasxoc = Create DataStore
lds_telasxoc.DataObject = 'ds_cargar_dt_telasxoc'
lds_telasxoc.SetTransObject(Sqlca)

dw_detalle.AcceptText()

//recorro la dw_detalle para conocer que registros estas en estado 6 (aprobado)
FOR ll_fila = 1 TO dw_detalle.RowCount()
	ll_est_new = dw_detalle.GetItemNumber(ll_fila,'co_estado_asigna')
	
	//IF ll_est_new = 6 THEN
		ll_ordcorte = dw_detalle.GetItemNumber(ll_fila,'cs_asignacion')
		
		IF ll_ordcorte > 1 THEN
				select count(*)
				into :ll_count
				from dt_telasxoc
				where cs_orden_corte = :ll_ordcorte;
				
				IF Sqlca.Sqlcode = -1 THEN
					MessageBox('Error','Se genero un error al momento de consultar en dt_telasxoc')
					Return -1
				END IF
						
				IF ll_count >= 1 Then
				ELSE
					//Es porque no existen datos en la tabla y por lo tanto se procede a insertar
					
					select min(cs_prioridad)
					into :ll_prioridad
					from dt_pdnxmodulo
					where cs_asignacion = :ll_ordcorte;
					
					IF Sqlca.Sqlcode = -1 THEN
						MessageBox('Error','Ocurrio un eroor al momento de consultar la priroridad en dt_pdnxmodulo')
						Return -1
					END IF
					
					lds_telasxoc.Retrieve(ll_ordcorte)
					lds_telasxoc.AcceptText()
					ldt_fe_creacion = f_fecha_servidor()
					ldt_fe_actualizacion = ldt_fe_creacion
													
					//recorro las escalas de la orden de corte												
					FOR ll_i = 1 TO lds_telasxoc.RowCount()
						
						ll_reftel = lds_telasxoc.GetITemNumber(ll_i,'co_reftel')
						ll_caract = lds_telasxoc.GetITemNumber(ll_i,'co_caract')
						ll_diamet = lds_telasxoc.GetITemNumber(ll_i,'diametro')
						ll_color  = lds_telasxoc.GetITemNumber(ll_i,'co_color_te')
						ls_tono   = lds_telasxoc.GetITemString(ll_i,'tono')
						ldc_cant  = lds_telasxoc.GetITemNumber(ll_i,'cant_gramos') * lds_telasxoc.GetITemNumber(ll_i,'ca_pendiente')
						ll_fab	 = lds_telasxoc.GetItemNumber(ll_i,'co_fabrica_te')	
																
					//si la tela no es la principal el tono debe ser I, de lo contrario es el tono que tiene la tela
					select co_tipo
					into :ll_tipo
					from h_telas
					where co_reftel = :ll_reftel;
					
					If ll_tipo <> 1 Then 
						ls_tono = 'I'
					END IF
					
					//determino la cantidad y si el registro ya se encuentra en la tabla dt_telasxoc
					select count(*)
					into :ll_count
					from dt_telasxoc
					where cs_orden_corte = :ll_ordcorte and
							co_fabrica 		= :ll_fab and
							co_reftel 		= :ll_reftel and
							co_caract 		= :ll_caract and
							diametro 		= :ll_diamet and
							co_color 		= :ll_color and
							tono 				= :ls_tono;
					
//					If ll_count = 1 Then
//						select ca_requerida
//						into :ldc_requeridad
//						from dt_telasxoc
//						where cs_orden_corte = :ll_ordcorte and
//								co_fabrica 		= :ll_fab and
//								co_reftel 		= :ll_reftel and
//								co_caract 		= :ll_caract and
//								diametro 		= :ll_diamet and
//								co_color 		= :ll_color and
//								tono 				= :ls_tono;
//					End if
					
					ldc_porc_desperdicio=1
		
					SELECT h_telas.prc_desperdicio  
					 INTO :ldc_porc_desperdicio  
					 FROM h_telas  
					WHERE ( h_telas.co_reftel = :ll_reftel ) AND  
							( h_telas.co_caract = :ll_caract )   ;
					IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Advertencia","No tiene % desperdicio del Maestro de tela")
					ELSE
						ldc_porc_desperdicio=(ldc_porc_desperdicio/100) + 1
					END IF
					//si se encuentra en dt_telasxoc realizo un update de lo contrario se realiza un insert
					IF ll_count = 1 THEN
//							ldc_total = ldc_cant + ldc_requeridad
//							
							ldc_cant=ldc_cant * ldc_porc_desperdicio
													 
							 update dt_telasxoc  
								  set ca_requerida 	= ca_requerida + :ldc_cant
								where cs_orden_corte = :ll_ordcorte and
										co_fabrica 		= :ll_fab and
										co_reftel 		= :ll_reftel and
										co_caract 		= :ll_caract and
										diametro 		= :ll_diamet and
										co_color 		= :ll_color and
										tono 				= :ls_tono  ;
								IF Sqlca.Sqlcode = -1 THEN
									MessageBox('Error','No fue posible actualizar en dt_telasxoc')
									Return -1
							END IF
					ELSE
						
						
						ldc_cant=ldc_cant * ldc_porc_desperdicio
						
						insert into dt_telasxoc  
						( cs_orden_corte,				co_fabrica,			co_reftel,			co_caract,			diametro,   
						  co_color,						tono,  				cs_prioridad,		ca_requerida,  	ca_preparada,   
						  ca_transito,					ca_entregada,   	ca_adicional,   	co_motivo_add,   	fe_entrega,   
						  fe_preparacion,   			fe_transito,   	fe_adicion,   		fe_envio_add,   	fe_creacion,   
						  fe_actualizacion,   		usuario,   			instancia )  
						values 
						( :ll_ordcorte,				:ll_fab,   			:ll_reftel,			:ll_caract,			:ll_diamet,   
						  :ll_color,					:ls_tono,			:ll_prioridad,		:ldc_cant,  		0,   
						  0,								0,						0,						0,						null,   
						  null,							null,					null,					null,					:ldt_fe_creacion,   
						  :ldt_fe_actualizacion,   :gstr_info_usuario.codigo_usuario,	:gstr_info_usuario.instancia )  ;
							
						IF Sqlca.Sqlcode = -1 THEN
							MessageBox('Error','No fue posible insertar en dt_telasxoc')
							Return -1
						END IF
					END IF//ll_count	
					NEXT
				END IF//ll_count
		END IF//ll_ordencorte > 1
	//END IF
NEXT
Return 0
end function

protected function long wf_numero_prioridad (long pri_act, long pri_nue, long agr_act, long mod, long tipo);String ls_filter
Long li_pri_min,li_pri_max,li_return
Long ll_result

ls_filter = "co_modulo = "+String(mod) + " and dt_agrupa_pdn_cs_agrupacion = "+String(agr_act)
dw_detalle.SetFilter(ls_filter)
dw_detalle.Filter()
ll_result = dw_detalle.RowCount()

If ll_result > 1 Then
	//tipo se refiere a 1 prioridad que sube, 0 prioridad que baja
	If tipo = 1 Then
		li_pri_max = dw_detalle.GetItemnumber(dw_detalle.RowCount(),'cs_prioridad') 
		li_return = li_pri_max
	Else
		li_pri_max = dw_detalle.GetItemnumber(dw_detalle.RowCount(),'cs_prioridad') + 1
		li_pri_min = dw_detalle.GetItemNumber(1,'cs_prioridad')
		If pri_nue <> li_pri_min Then
			li_return = li_pri_max
		Else
			li_return = pri_nue
		End if
	End if
Else
	li_return = pri_nue
End if

dw_detalle.SetFilter("")
dw_detalle.filter()

Return li_return
end function

public function long wf_distribuir_unidades (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_li_ind_camb_est, long an_li_cod_tur, datetime adt_fe_prog_desp, datetime adt_fe_entra_pdn, long an_co_tipo_asignacion);//LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
//LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
//LONG					li_unidades_empate,ll_cuantas_asignaciones
//LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_personasxmodulo,ll_ca_unid_posibles
//LONG         		ll_pedido_ant,ll_cs_liberacion_ant,ll_co_referencia_ant,ll_color_pt_ant,ll_unidades_empate  
//LONG					ll_unidades_disponibles,ll_ca_pendiente
//
//Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion,li_dia_curva
//Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla,li_cs_fechas_ant
//Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
//Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
//Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad,li_dia_curva_ant
//Long				li_co_fabrica_exp_ant,li_co_fabrica_ref_ant,li_co_linea_ref_ant,li_cs_estilocolortono_ant
//Long				li_cs_particion_ant,li_prioridad_ant,li_dia,li_cs_fechas,li_duracion,li_co_est_prog_dia
//Long				li_tipo_avance_calendario,li_numero_dias
//
//DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia
//DECIMAL				ld_minutos_empate,ld_ca_min_dispon_fin,ld_ca_min_dispon_ant,ld_minutos_disponibles
//
//STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_mensaje
//STRING				ls_nu_orden_ant,ls_tono_ant,ls_nombre_dia
//
//DateTime 			ldt_fechahora
//DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
//DATETIME				ldt_fe_inicio,ldt_fe_fin,ldt_fe_creacion,ldt_fe_actualizacion,ldt_fe_fin_ant
//DATETIME				ldt_fe_inicio_prog_tot,ldt_fe_fin_prog_tot,ldt_fe_calculada_despacho
//
//DATE					ld_fecha_despacho,ld_fe_inicio,ld_fe_fin
//
//s_base_parametros lstr_parametros
//            
/////////////////////////////////////////// inicio de traer datos iniciales /////////////////////////////////////
////traer unidades disponibles
//ll_unidades_disponibles=an_unidades
//
////traer minutos disponibles
//////variables que afectan: 
////////1. si es prioridad 1: debe tener todos los minutos disponibles.Si es prioridad >1. ver empates.
//li_cs_prioridad=an_prioridad
//li_tipo_empate=an_tipo_empate
//IF li_cs_prioridad =1 THEN
//	ld_ca_min_dispon_ant=ad_minutos_jornada //TIENE TODO EL TIEMPO DISPONIBLE, o segun tiempo disponible del modulo en la fecha
//
//ELSE
////////2. segun empate as$$HEX1$$ed00$$ENDHEX$$:
////////////0.AUTOMATICO: Si prioridad > 1 debe traer minutos disponibles de la asignaci$$HEX1$$f300$$ENDHEX$$n previa. 
////////////1.Manual: no requiere minutos disponibles, de todas formas debe operar seg$$HEX1$$fa00$$ENDHEX$$n caso 0, para posterior validaci$$HEX1$$f300$$ENDHEX$$n.
////////////2.No empate: Debe tener todos los minutos disponibles, entonces debe operar como caso 0, y no debe tener
////////////////				minutos disponibles y si tiene, debe saltar a la siguiente fecha del calendario del modulo 
//////////////////			para arrancar.
//	li_prioridad_ant=li_cs_prioridad - 1
//	SELECT dt_pdnxmodulo.co_fabrica_exp,   
//				dt_pdnxmodulo.pedido,   
//					dt_pdnxmodulo.cs_liberacion,   
//					dt_pdnxmodulo.po,   
//					dt_pdnxmodulo.co_fabrica_pt,   
//					dt_pdnxmodulo.co_linea,   
//					dt_pdnxmodulo.co_referencia,   
//					dt_pdnxmodulo.co_color_pt,   
//					dt_pdnxmodulo.tono,   
//					dt_pdnxmodulo.cs_estilocolortono,   
//					dt_pdnxmodulo.cs_particion  
//			 INTO :li_co_fabrica_exp_ant,   
//					:ll_pedido_ant,   
//					:ll_cs_liberacion_ant,   
//					:ls_nu_orden_ant,   
//					:li_co_fabrica_ref_ant,   
//					:li_co_linea_ref_ant,   
//					:ll_co_referencia_ant,   
//					:ll_color_pt_ant,   
//					:ls_tono_ant,   
//					:li_cs_estilocolortono_ant,   
//					:li_cs_particion_ant  
//			 FROM dt_pdnxmodulo  
//			WHERE ( dt_pdnxmodulo.simulacion 	= 	:an_simulacion ) AND  
//					( dt_pdnxmodulo.co_fabrica 	=	:an_fabrica_modulo ) AND  
//					( dt_pdnxmodulo.co_planta 		=  :an_planta_modulo) AND  
//					( dt_pdnxmodulo.co_modulo 		=  :an_modulo) AND  
//					( dt_pdnxmodulo.cs_prioridad 	=  :li_prioridad_ant)   AND
//					
//			NOT	( dt_pdnxmodulo.co_fabrica_exp 			=  :an_co_fabrica_exp   AND
//					 dt_pdnxmodulo.pedido 						=  :an_pedido   AND
//					 dt_pdnxmodulo.cs_liberacion 				=  :an_cs_liberacion   AND
//					 dt_pdnxmodulo.po 							=  :as_po   AND
//					 dt_pdnxmodulo.co_fabrica_pt 				=  :an_co_fabrica_ref   AND
//					 dt_pdnxmodulo.co_linea 					=  :an_co_linea_ref   AND
//					 dt_pdnxmodulo.co_referencia 				=  :an_co_referencia   AND
//					 dt_pdnxmodulo.co_color_pt 				=  :an_color_pt   AND
//					 dt_pdnxmodulo.tono 							=  :as_tono   AND
//					 dt_pdnxmodulo.cs_estilocolortono 		=  :an_cs_estilocolortono   AND
//					 dt_pdnxmodulo.cs_particion 				=  :an_cs_particion   )
//					;
//	IF SQLCA.SQLCODE=-1 THEN
//		MessageBox("Error Base Datos","No pudo buscar asignaciones de prioridad anterior")
//		RETURN 0
//	ELSE
//		//trae los minutos disponibles finales 
//		SELECT dt_programa_diario.ca_min_dispon_fin,dt_programa_diario.fe_fin,dt_programa_diario.cs_fechas,dt_programa_diario.dia_curva  
//				 INTO :ld_ca_min_dispon_ant,:ldt_fe_fin_ant,:li_cs_fechas_ant,:li_dia_curva_ant  
//				 FROM dt_programa_diario  
//				WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
//						( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
//						( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
//						( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
//						( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
//						( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
//						( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
//						( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
//						( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
//						( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
//						( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
//						( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
//						( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
//						( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
//						( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) AND  
//						( dt_programa_diario.cs_fechas 				= 	(
//								SELECT MAX(dt_programa_diario.cs_fechas  )
//								 FROM dt_programa_diario  
//								WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
//										( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
//										( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
//										( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
//										( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
//										( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
//										( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
//										( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
//										( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
//										( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
//										( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
//										( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
//										( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
//										( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
//										( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) 
//								)
//						)   ;
//		IF SQLCA.SQLCODE=-1 THEN
//			MessageBox("Error Base datos","No pudo buscar minutos disponibles de prioridad anterior")
//			RETURN 0
//		ELSE
//		END IF
//	END IF
//END IF
//
////traer minutos estandar
//////minutos prenda:ad_minutos_std
//ld_ca_minutos_std=ad_minutos_std
//
////traer personas por modulo
//////personasxmodulo:an_personasxmodulo
//ll_personasxmodulo=an_personasxmodulo
//
/////////////////////////////////////////// fin    de traer datos iniciales /////////////////////////////////////
//
//
/////////////////////////////////////////// inicio de procesar datos  /////////////////////////////////////
////hacer ciclo para calcular unidades a asignar a diario
//li_dia=0
//DO WHILE ll_unidades_disponibles > 0
//	
//	li_dia=li_dia + 1
//	
//	IF li_dia=1 THEN
//		IF an_prioridad = 1 THEN
//			li_dia_curva=li_dia
//		ELSE
//			//Verificar si cambia el dia de curva seg$$HEX1$$fa00$$ENDHEX$$n indicador de cambio de estilo y empate autom$$HEX1$$e100$$ENDHEX$$tico=0
//			IF li_tipo_empate=0 AND an_li_ind_camb_est=0 THEN // li_tipo_empate=0:AUTOMATICO, li_iind_camb_est=0:no cambia de estilo
//				//debe buscar el dia de curva en que termino la anterior asignaci$$HEX1$$f300$$ENDHEX$$n
//				li_dia_curva=li_dia_curva_ant 
//			ELSE
//				li_dia_curva=li_dia
//			END IF
//		END IF
//	ELSE
//		li_dia_curva=li_dia_curva + 1
//	END IF
//	
//	//trae % de eficiencia de la tabla dt_curva_eficiencia con an_co_curva y dia
//   SELECT dt_curva_eficienci.prc_eficiencia  
//	 INTO :ld_porc_eficiencia
//    FROM dt_curva_eficienci  
//   WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
//         ( dt_curva_eficienci.dia_fin 		= :li_dia_curva )   ;
//	IF SQLCA.SQLCODE=-1 THEN
//		MessageBox("Error Base datos","No pudo buscar eficiencia en curva")
//		RETURN 0
//	ELSE
//		IF SQLCA.SQLCODE=100 THEN
//			SELECT dt_curva_eficienci.prc_eficiencia
//				INTO :ld_porc_eficiencia
//			 FROM dt_curva_eficienci  
//			WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
//					( dt_curva_eficienci.dia_fin 		>= :li_dia_curva ) AND  
//					( dt_curva_eficienci.dia_inicio 	< :li_dia_curva )   ;
//			IF SQLCA.SQLCODE=-1 THEN
//				MessageBox("Error Base datos","No pudo buscar eficiencia en curva")
//				RETURN 0
//			ELSE
//			END IF
//		ELSE
//			IF SQLCA.SQLCODE=0 THEN
//			ELSE
//				MessageBox("Error Base datos","No pudo buscar eficiencia en curva")
//				RETURN 0
//			END IF
//		END IF
//	END IF
//	//Minutos disponibles
//	IF li_dia=1 THEN
//		IF an_tipo_empate=2 THEN //NO EMPATE
//			ld_minutos_disponibles=ad_minutos_jornada
//		ELSE
//			ld_minutos_disponibles=ld_ca_min_dispon_ant	
//		END IF
//		
//	ELSE
//		ld_minutos_disponibles=ad_minutos_jornada
//	END IF
//	////UNIDADES POSIBLES
//	//Obtiene unidades seg$$HEX1$$fa00$$ENDHEX$$n el tipo de empate para el primer dia
//	////  estas son las del primer dia 0 autom, 1 manual, 2 no empate
//	IF li_dia=1 THEN
//			IF an_tipo_empate=0  OR an_tipo_empate=2 THEN  //automatico o no empata
//				IF ad_minutos_std=0 THEN
//					ls_mensaje="Minutos estandar en cero en prioridad: " + STRING(an_prioridad)
//					MessageBox("Error datos ",ls_mensaje)
//					RETURN 0
//				ELSE
//				END IF
//				ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
//			ELSE
//				IF an_tipo_empate=1 THEN  //MANUAL, DEBE TRAER UNIDADES EMPATE
//					ll_ca_unid_posibles=an_unidades_empate
//				ELSE
//					MessageBox("Error datos","Tipo de empate no permitido")
//					RETURN 0
//				END IF
//			END IF
//	ELSE
//		ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
//	END IF
//
//	////UNIDADES A ASIGNAR
//	IF ll_unidades_disponibles >  ll_ca_unid_posibles THEN
//		ll_ca_pendiente=ll_ca_unid_posibles
//		ld_ca_min_dispon_fin=0
//	ELSE
//		ll_ca_pendiente=ll_unidades_disponibles
//		ld_ca_min_dispon_fin=ad_minutos_jornada - ((ad_minutos_std * ll_ca_pendiente) / ( an_personasxmodulo)) * (ld_porc_eficiencia/100) 	
//	END IF
//	////UNIDADES QUE QUEDAN
//	ll_ca_unid_dispon_fin=ll_unidades_disponibles - ll_ca_pendiente
//		
//	li_cs_fechas=li_dia
//	
//	//fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n
//	IF li_dia=1 THEN
//		IF ISNULL(adt_fe_entrada_pdn)	THEN
//			IF ISNULL(adt_fe_inicio_prog) THEN
//				ldt_fe_inicio=ldt_fe_fin_ant
//			ELSE
//				ldt_fe_inicio=adt_fe_inicio_prog
//			END IF
//			IF li_tipo_empate=2 THEN //NO EMPATA
//				li_tipo_avance_calendario=1 //hacia adelante
//				li_numero_dias=1
//				ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
//														ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
//				IF ISNULL(ld_fe_inicio) THEN
//					ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ldt_fe_inicio)
//					MessageBox("Error de Datos",ls_mensaje)
//					RETURN 0
//				ELSE
//					ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
//				END IF
//			ELSE
//			END IF
//		ELSE
//			//debe trabajar con fecha de entrada de produccion
//			ldt_fe_inicio=adt_fe_entrada_pdn
//			//debe verificar que la fecha de inicio no halla quedado mayor que la fecha de fin anterior, o sino cambiarla
//			IF ldt_fe_inicio > ldt_fe_fin_ant THEN
//			ELSE
//				ldt_fe_inicio=ldt_fe_fin_ant
//				IF li_tipo_empate=2 THEN //NO EMPATA
//					li_tipo_avance_calendario=1 //hacia adelante
//					li_numero_dias=1
//					ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
//															ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
//					IF ISNULL(ld_fe_inicio) THEN
//						ls_mensaje="Por favor verifique la fecha en el calendario general:" + STRING(ld_fe_inicio)
//						MessageBox("Error de Datos",ls_mensaje)
//						RETURN 0
//					ELSE
//						ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
//					END IF
//				ELSE
//				END IF		
//			END IF
//		END IF
//		
//
//		ldt_fe_inicio_prog_tot=ldt_fe_inicio
//	ELSE //no es el primer dia avance en el calendario general y verifique en el modulo para posibles excepciones
//		//ldt_fe_inicio=datetime(RelativeDate(date(ldt_fe_inicio),1), time(ldt_fe_inicio))
//		li_tipo_avance_calendario=1 //hacia adelante
//		li_numero_dias=1
//		ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
//											  ldt_fe_inicio,li_numero_dias,li_tipo_avance_calendario)
//		IF ISNULL(ld_fe_inicio) THEN
//			ls_mensaje="Por favor verifique la fecha en el calendario del m$$HEX1$$f300$$ENDHEX$$dulo:" + STRING(ld_fe_inicio)
//			MessageBox("Error de Datos",ls_mensaje)
//			RETURN 0
//		ELSE
//			ldt_fe_inicio=datetime(ld_fe_inicio, time(ldt_fe_inicio))
//		END IF
//	END IF	
//	li_duracion=1
//	
//	//fe_fin por dia
//	ldt_fe_fin =ldt_fe_inicio 
////	ldt_fe_fin = datetime(RelativeDate(date(ldt_fe_inicio),1), time(ldt_fe_inicio))
////	li_tipo_avance_calendario=1 //hacia adelante
////	li_numero_dias=1
////	ld_fe_inicio=wf_traer_fechas(an_fabrica_modulo,an_planta_modulo,an_modulo,an_li_cod_tur,&
////											ldt_fe_fin,li_numero_dias,li_tipo_avance_calendario)
////	IF ISNULL(ld_fe_fin) THEN
////		ls_mensaje="Por favor verifique la fecha en el calendario del m$$HEX1$$f300$$ENDHEX$$dulo:" + STRING(ld_fe_fin)
////		MessageBox("Error de Datos",ls_mensaje)
////		RETURN 0
////	ELSE
////		ldt_fe_fin=datetime(ld_fe_fin, time(ldt_fe_inicio))
////	END IF
//	
//	li_co_est_prog_dia=1
//	li_fuente_dato=1
//	
//	ldt_fechahora = f_fecha_servidor()
//	ldt_fe_creacion=ldt_fechahora   
//   ldt_fe_actualizacion=ldt_fe_creacion
//	//datos de salida
//	///////////////////////////////////////// inicio de datos de salida  /////////////////////////////////////
//
//	
//	//actualiza la tabla 
//	INSERT INTO dt_programa_diario  
//         ( simulacion,   
//           co_fabrica,   
//           co_planta,   
//           co_modulo,   
//           co_fabrica_exp,   
//           pedido,   
//           cs_liberacion,   
//           po,   
//           co_fabrica_pt,   
//           co_linea,   
//           co_referencia,   
//           co_color_pt,   
//           tono,   
//           cs_estilocolortono,   
//           cs_particion,   
//           cs_fechas,   
//           fe_inicio,   
//           ca_unid_dispon_ini,   
//           ca_min_dispon_ini,   
//           ca_unid_dispon_fin,   
//           ca_min_dispon_fin,   
//           personasxmodulo,
//			  dia_curva,
//           porc_eficiencia,   
//           ca_unid_posibles,   
//           duracion,   
//           fe_fin,   
//           ca_programada,   
//           ca_producida,   
//           ca_pendiente,   
//           co_est_prog_dia,   
//           fuente_dato,   
//           fe_creacion,   
//           fe_actualizacion,   
//           usuario,   
//           instancia )  
//  VALUES ( :an_simulacion,   
//           :an_fabrica_modulo,   
//           :an_planta_modulo,   
//           :an_modulo,   
//           :an_co_fabrica_exp,   
//           :an_pedido,   
//           :an_cs_liberacion,   
//           :as_po,   
//           :an_co_fabrica_ref,   
//           :an_co_linea_ref,   
//           :an_co_referencia,   
//           :an_color_pt,   
//           :as_tono,   
//           :an_cs_estilocolortono,   
//           :an_cs_particion,   
//           :li_cs_fechas,   
//           :ldt_fe_inicio,   
//           :ll_unidades_disponibles, 
//			  :ld_minutos_disponibles, 
//			  :ll_ca_unid_dispon_fin, 
//			  :ld_ca_min_dispon_fin, 
//			  :an_personasxmodulo,   
//			  :li_dia_curva,
//			  :ld_porc_eficiencia, 
//			  :ll_ca_unid_posibles,   
//			  :li_duracion, 
//			  :ldt_fe_fin,   
//           :ll_ca_pendiente,   
//           0,   
//           :ll_ca_pendiente,   
//           :li_co_est_prog_dia,   
//           :li_fuente_dato,   
//           :ldt_fe_creacion,   
//           :ldt_fe_actualizacion,   
//           :gstr_info_usuario.codigo_usuario,   
//           :gstr_info_usuario.instancia )  ;
//	IF SQLCA.SQLCODE=-1 THEN
//		MessageBox("Error Base Datos","No pudo insertar unidades en dias")
//		RETURN 0
//	ELSE
//	END IF
//	///////////////////////////////////////// fin    de datos de salida  /////////////////////////////////////
//	
//	ll_unidades_disponibles=ll_unidades_disponibles - ll_ca_pendiente
//
//LOOP
//ldt_fe_fin_prog_tot=ldt_fe_fin
//
//IF NOT isnull(ldt_fe_fin_prog_tot) THEN		
//		ls_nombre_dia = UPPER(string(ldt_fe_fin_prog_tot, "ddd"))
//		ld_fecha_despacho = date(ldt_fe_fin_prog_tot)
//		CHOOSE CASE ls_nombre_dia
//			CASE 'MON'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)				
//			CASE 'TUE'				
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 4)
//			CASE 'WED'				
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)	
//			CASE 'THU'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
//			CASE 'FRI'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)
//			CASE 'SAT'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)
//			CASE 'SUN'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
//		END CHOOSE				
//		
////		IF ld_fecha_despacho > ld_fecha_terminacion THEN
////			ll_desface = DaysAfter (ld_fecha_terminacion, ld_fecha_despacho)  			
////		ELSE
////			ll_desface = DaysAfter (ld_fecha_terminacion, ld_fecha_despacho)
////		END IF
//	
////		ad_datawindow.setitem(ll_fila, 'fe_despacho',ld_fecha_despacho)
////		ad_datawindow.setitem(ll_fila, 'dias_atrazo',ll_desface)	
////		ad_datawindow.setitem(ll_fila, 'fe_inicio_progs',ldt_fecha_inicial)			   	
////		ad_datawindow.setitem(ll_fila, 'fe_final_progs',ldt_fecha_final)	
//	END IF
//ldt_fe_calculada_despacho=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))
//
////update a dt_pdnxmodulo
//  UPDATE dt_pdnxmodulo  
//     SET fe_inicio_prog 	= :ldt_fe_inicio_prog_tot,   
//         fe_fin_prog 		= :ldt_fe_fin_prog_tot,
//			fe_requerida_desp	= :ldt_fe_calculada_despacho
//	WHERE ( dt_pdnxmodulo.simulacion 			= :an_simulacion ) AND  
//			( dt_pdnxmodulo.co_fabrica 			= :an_fabrica_modulo ) AND  
//			( dt_pdnxmodulo.co_planta 				= :an_planta_modulo ) AND  
//			( dt_pdnxmodulo.co_modulo 				= :an_modulo ) AND  
//			( dt_pdnxmodulo.co_fabrica_exp 		= :an_co_fabrica_exp) AND  
//			( dt_pdnxmodulo.pedido 					= :an_pedido ) AND  
//			( dt_pdnxmodulo.cs_liberacion 		= :an_cs_liberacion ) AND  
//			( dt_pdnxmodulo.po 						= :as_po ) AND  
//			( dt_pdnxmodulo.co_fabrica_pt 		= :an_co_fabrica_ref ) AND  
//			( dt_pdnxmodulo.co_linea 				= :an_co_linea_ref ) AND  
//			( dt_pdnxmodulo.co_referencia 		= :an_co_referencia ) AND  
//			( dt_pdnxmodulo.co_color_pt 			= :an_color_pt ) AND  
//			( dt_pdnxmodulo.tono 					= :as_tono ) AND  
//			( dt_pdnxmodulo.cs_estilocolortono 	= :an_cs_estilocolortono ) AND  
//			( dt_pdnxmodulo.cs_particion 			= :an_cs_particion  )   ;
//			
//	IF SQLCA.SQLCODE = -1 THEN
//		MessageBox("Error Base Datos","No pudo Actualizar fechas de inicio y fin de asignaci$$HEX1$$f300$$ENDHEX$$n")
//		RETURN 0
//	ELSE
//	END IF
//
// RETURN 1 
//

//----------------------------------------------------------------------------------------//
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
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
		
		// ----------------------------- Fechas de Programaci$$HEX1$$f300$$ENDHEX$$n ---------------------------- //
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
	
//-----------------  PROGRAMACION HACIA ATRAS --------------------------------------//

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

public function long wf_distribuir_unidades_base (long an_simulacion, long an_fabrica_modulo, long an_planta_modulo, long an_modulo, long an_prioridad, long an_tipo_empate, long an_unidades_empate, long an_unidades, decimal ad_minutos_std, long an_personasxmodulo, long an_co_curva, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_ref, long an_co_linea_ref, long an_co_referencia, long an_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, ref datetime adt_fe_inicio_prog, datetime adt_fe_fin_prog, decimal ad_minutos_jornada, long an_dias_programados, long an_unid_que_lleva, datetime adt_fe_fin_ant, long an_base_dia);LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_personasxmodulo,ll_ca_unid_posibles
LONG         		ll_pedido_ant,ll_cs_liberacion_ant,ll_co_referencia_ant,ll_color_pt_ant,ll_unidades_empate  
LONG					ll_unidades_disponibles,ll_ca_pendiente

Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion,ll_cs_fecha
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad
Long				li_co_fabrica_exp_ant,li_co_fabrica_ref_ant,li_co_linea_ref_ant,li_cs_estilocolortono_ant
Long				li_cs_particion_ant,li_prioridad_ant,li_dia,li_cs_fechas,li_duracion,li_co_est_prog_dia

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia
DECIMAL				ld_minutos_empate,ld_ca_min_dispon_fin,ld_ca_min_dispon_ant,ld_minutos_disponibles

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido
STRING				ls_nu_orden_ant,ls_tono_ant,ls_nombre_dia

DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog,ldt_fe_inicio_int,ldt_fe_fin_int
DATETIME				ldt_fe_inicio,ldt_fe_fin,ldt_fe_creacion,ldt_fe_actualizacion,ldt_fe_fin_ant
DATETIME				ldt_fe_inicio_prog_tot,ldt_fe_fin_prog_tot,ldt_fe_calculada_despacho
DateTime 			ldt_fechahora

DATE					ld_fecha_despacho


s_base_parametros lstr_parametros
 
li_cs_prioridad=an_prioridad 
li_prioridad_ant=li_cs_prioridad -1
//debe hacer ciclo para traer unidades programadas e insertar 
DECLARE cur_programa_dia CURSOR FOR
  SELECT dt_programa_diario.cs_fechas,   
         dt_programa_diario.fe_inicio,   
         dt_programa_diario.ca_unid_dispon_ini,   
         dt_programa_diario.ca_min_dispon_ini,   
         dt_programa_diario.ca_unid_dispon_fin,   
         dt_programa_diario.ca_min_dispon_fin,   
         dt_programa_diario.personasxmodulo,   
         dt_programa_diario.porc_eficiencia,   
         dt_programa_diario.ca_unid_posibles,   
         dt_programa_diario.duracion,   
         dt_programa_diario.fe_fin,   
         dt_programa_diario.ca_programada,   
         dt_programa_diario.ca_producida,   
         dt_programa_diario.ca_pendiente,   
         dt_programa_diario.co_est_prog_dia,   
         dt_programa_diario.fuente_dato  
    FROM dt_programa_diario  
   WHERE ( dt_programa_diario.simulacion 				=:an_simulacion  ) AND  
         ( dt_programa_diario.co_fabrica 				=:an_fabrica_modulo  ) AND  
         ( dt_programa_diario.co_planta 				=:an_planta_modulo  ) AND  
         ( dt_programa_diario.co_modulo 				=:an_modulo  ) AND  
         ( dt_programa_diario.co_fabrica_exp 		=:an_co_fabrica_exp  ) AND  
         ( dt_programa_diario.pedido			 		=:an_pedido  ) AND  
         ( dt_programa_diario.cs_liberacion 			=:an_cs_liberacion  ) AND  
         ( dt_programa_diario.po 						=:as_po  ) AND  
         ( dt_programa_diario.co_fabrica_pt 			=:an_co_fabrica_ref  ) AND  
         ( dt_programa_diario.co_linea 				=:an_co_linea_ref  ) AND  
         ( dt_programa_diario.co_referencia 			=:an_co_referencia  ) AND  
         ( dt_programa_diario.co_color_pt 			=:an_color_pt  ) AND  
         ( dt_programa_diario.tono 						=:as_tono  ) AND  
         ( dt_programa_diario.cs_estilocolortono 	=:an_cs_estilocolortono  ) AND  
         ( dt_programa_diario.cs_particion 			=:an_cs_particion  )   
	ORDER BY 1;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","No pudo abrir la busqueda de programaci$$HEX1$$f300$$ENDHEX$$n por bases")
	RETURN 0
ELSE
END IF
			
OPEN cur_programa_dia;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","No pudo abrir la busqueda de programaci$$HEX1$$f300$$ENDHEX$$n por bases")
	RETURN 0
ELSE
END IF

FETCH cur_programa_dia 
	    INTO :ll_cs_fecha,   
         :ldt_fe_inicio,   
         :ll_ca_unid_dispon_ini,   
         :ld_ca_min_dispon_ini,   
         :ll_ca_unid_dispon_fin,   
         :ld_ca_min_dispon_fin,   
         :ll_personasxmodulo,   
         :ld_porc_eficiencia,   
         :ll_ca_unid_posibles,   
         :li_duracion,   
         :ldt_fe_fin,   
         :ll_ca_programada,   
         :ll_ca_producida,   
         :ll_ca_pendiente,   
         :li_co_est_prog_dia,   
         :li_fuente_dato ;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","No pudo abrir la busqueda de programaci$$HEX1$$f300$$ENDHEX$$n por bases")
	RETURN 0
ELSE
END IF
			
DO WHILE SQLCA.SQLCODE=0
	IF ll_cs_fecha=1 THEN
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
			MessageBox("Error Base Datos","No pudo buscar asignaciones de prioridad anterior")
		ELSE
			//trae los minutos disponibles finales 
			SELECT dt_programa_diario.ca_min_dispon_fin,dt_programa_diario.fe_fin  
					 INTO :ld_ca_min_dispon_ant,:ldt_fe_fin_ant  
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
				MessageBox("Error Base datos","No pudo buscar minutos disponibles de prioridad anterior")
			ELSE
			END IF
		END IF
		ld_minutos_disponibles	=ld_ca_min_dispon_ant
		ldt_fe_inicio_int 		=datetime(RelativeDate(date(ldt_fe_fin_ant),1), time(ldt_fe_fin_ant))
	ELSE
		ld_minutos_disponibles=ad_minutos_jornada
		ldt_fe_inicio_int = datetime(RelativeDate(date(ldt_fe_inicio_int),1), time(ldt_fe_inicio_int))
	END IF
	ldt_fe_fin_int = datetime(RelativeDate(date(ldt_fe_inicio_int),1), time(ldt_fe_inicio_int))
	//update a tabla
	UPDATE dt_programa_diario  
     SET fe_inicio 	= :ldt_fe_inicio_int,   
         fe_fin 		= :ldt_fe_fin_int  
   WHERE ( dt_programa_diario.simulacion 				=:an_simulacion  ) AND  
         ( dt_programa_diario.co_fabrica 				=:an_fabrica_modulo  ) AND  
         ( dt_programa_diario.co_planta 				=:an_planta_modulo  ) AND  
         ( dt_programa_diario.co_modulo 				=:an_modulo  ) AND  
         ( dt_programa_diario.co_fabrica_exp 		=:an_co_fabrica_exp  ) AND  
         ( dt_programa_diario.pedido 					=:an_pedido  ) AND  
         ( dt_programa_diario.cs_liberacion 			=:an_cs_liberacion  ) AND  
         ( dt_programa_diario.po 						=:as_po  ) AND  
         ( dt_programa_diario.co_fabrica_pt 			=:an_co_fabrica_ref  ) AND  
         ( dt_programa_diario.co_linea 				=:an_co_linea_ref  ) AND  
         ( dt_programa_diario.co_referencia 			=:an_co_referencia  ) AND  
         ( dt_programa_diario.co_color_pt 			=:an_color_pt  ) AND  
         ( dt_programa_diario.tono 						=:as_tono  ) AND  
         ( dt_programa_diario.cs_estilocolortono 	=:an_cs_estilocolortono  ) AND  
         ( dt_programa_diario.cs_particion 			=:an_cs_particion  ) AND  
         ( dt_programa_diario.cs_fechas 				=:ll_cs_fecha  )   ;
  	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo actualizar fechas a asignaci$$HEX1$$f300$$ENDHEX$$n con bases dia")
		RETURN 0
   ELSE
	END IF

	FETCH cur_programa_dia 
			 INTO :ll_cs_fecha,   
				:ldt_fe_inicio,   
				:ll_ca_unid_dispon_ini,   
				:ld_ca_min_dispon_ini,   
				:ll_ca_unid_dispon_fin,   
				:ld_ca_min_dispon_fin,   
				:ll_personasxmodulo,   
				:ld_porc_eficiencia,   
				:ll_ca_unid_posibles,   
				:li_duracion,   
				:ldt_fe_fin,   
				:ll_ca_programada,   
				:ll_ca_producida,   
				:ll_ca_pendiente,   
				:li_co_est_prog_dia,   
				:li_fuente_dato ;
	IF SQLCA.SQLCODE=-1 THEN
		ROLLBACK;
		MessageBox("Error Base Datos","No pudo abrir la busqueda de programaci$$HEX1$$f300$$ENDHEX$$n por bases")
		RETURN 0
	ELSE
	END IF	
LOOP
CLOSE cur_programa_dia;
IF SQLCA.SQLCODE=-1 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","No pudo abrir la busqueda de programaci$$HEX1$$f300$$ENDHEX$$n por bases")
	RETURN 0
ELSE
END IF
ldt_fe_fin_prog_tot=ldt_fe_fin_int

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
		
//		IF ld_fecha_despacho > ld_fecha_terminacion THEN
//			ll_desface = DaysAfter (ld_fecha_terminacion, ld_fecha_despacho)  			
//		ELSE
//			ll_desface = DaysAfter (ld_fecha_terminacion, ld_fecha_despacho)
//		END IF
	
//		ad_datawindow.setitem(ll_fila, 'fe_despacho',ld_fecha_despacho)
//		ad_datawindow.setitem(ll_fila, 'dias_atrazo',ll_desface)	
//		ad_datawindow.setitem(ll_fila, 'fe_inicio_progs',ldt_fecha_inicial)			   	
//		ad_datawindow.setitem(ll_fila, 'fe_final_progs',ldt_fecha_final)	
	END IF
ldt_fe_calculada_despacho=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))

//update a dt_pdnxmodulo
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


	  
/////////////////////////////////////////// inicio de traer datos iniciales /////////////////////////////////////
////traer unidades disponibles
//ll_unidades_disponibles=an_unid_que_lleva
//
////traer minutos disponibles
//////variables que afectan: 
////////1. si es prioridad 1: debe tener todos los minutos disponibles.Si es prioridad >1. ver empates.
//li_cs_prioridad=an_prioridad
//li_tipo_empate=an_tipo_empate
//IF li_cs_prioridad =1 THEN
//	ld_ca_min_dispon_ant=480 //TIENE TODO EL TIEMPO DISPONIBLE, o segun tiempo disponible del modulo en la fecha
//ELSE
////////2. segun empate as$$HEX1$$ed00$$ENDHEX$$:
////////////0.AUTOMATICO: Si prioridad > 1 debe traer minutos disponibles de la asignaci$$HEX1$$f300$$ENDHEX$$n previa. 
////////////1.Manual: no requiere minutos disponibles, de todas formas debe operar seg$$HEX1$$fa00$$ENDHEX$$n caso 0, para posterior validaci$$HEX1$$f300$$ENDHEX$$n.
////////////2.No empate: Debe tener todos los minutos disponibles, entonces debe operar como caso 0, y no debe tener
////////////////				minutos disponibles y si tiene, debe saltar a la siguiente fecha del calendario del modulo 
//////////////////			para arrancar.
////	li_prioridad_ant=li_cs_prioridad - 1
////	SELECT dt_pdnxmodulo.co_fabrica_exp,   
////				dt_pdnxmodulo.pedido,   
////					dt_pdnxmodulo.cs_liberacion,   
////					dt_pdnxmodulo.po,   
////					dt_pdnxmodulo.co_fabrica_pt,   
////					dt_pdnxmodulo.co_linea,   
////					dt_pdnxmodulo.co_referencia,   
////					dt_pdnxmodulo.co_color_pt,   
////					dt_pdnxmodulo.tono,   
////					dt_pdnxmodulo.cs_estilocolortono,   
////					dt_pdnxmodulo.cs_particion  
////			 INTO :li_co_fabrica_exp_ant,   
////					:ll_pedido_ant,   
////					:ll_cs_liberacion_ant,   
////					:ls_nu_orden_ant,   
////					:li_co_fabrica_ref_ant,   
////					:li_co_linea_ref_ant,   
////					:ll_co_referencia_ant,   
////					:ll_color_pt_ant,   
////					:ls_tono_ant,   
////					:li_cs_estilocolortono_ant,   
////					:li_cs_particion_ant  
////			 FROM dt_pdnxmodulo  
////			WHERE ( dt_pdnxmodulo.simulacion 	= 	:an_simulacion ) AND  
////					( dt_pdnxmodulo.co_fabrica 	=	:an_fabrica_modulo ) AND  
////					( dt_pdnxmodulo.co_planta 		=  :an_planta_modulo) AND  
////					( dt_pdnxmodulo.co_modulo 		=  :an_modulo) AND  
////					( dt_pdnxmodulo.cs_prioridad 	=  :li_prioridad_ant)   ;
////	IF SQLCA.SQLCODE=-1 THEN
////		MessageBox("Error Base Datos","No pudo buscar asignaciones de prioridad anterior")
////	ELSE
////		//trae los minutos disponibles finales 
////		SELECT dt_programa_diario.ca_min_dispon_fin,dt_programa_diario.fe_fin  
////				 INTO :ld_ca_min_dispon_ant,:ldt_fe_fin_ant  
////				 FROM dt_programa_diario  
////				WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
////						( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
////						( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
////						( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
////						( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
////						( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
////						( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
////						( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
////						( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
////						( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
////						( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
////						( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
////						( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
////						( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
////						( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) AND  
////						( dt_programa_diario.cs_fechas 				= 	(
////								SELECT MAX(dt_programa_diario.cs_fechas  )
////								 FROM dt_programa_diario  
////								WHERE ( dt_programa_diario.simulacion 				= :an_simulacion ) AND  
////										( dt_programa_diario.co_fabrica 				= :an_fabrica_modulo ) AND  
////										( dt_programa_diario.co_planta 				= :an_planta_modulo ) AND  
////										( dt_programa_diario.co_modulo 				= :an_modulo ) AND  
////										( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp_ant) AND  
////										( dt_programa_diario.pedido 					= :ll_pedido_ant ) AND  
////										( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion_ant ) AND  
////										( dt_programa_diario.po 						= :ls_nu_orden_ant ) AND  
////										( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref_ant ) AND  
////										( dt_programa_diario.co_linea 				= :li_co_linea_ref_ant ) AND  
////										( dt_programa_diario.co_referencia 			= :ll_co_referencia_ant ) AND  
////										( dt_programa_diario.co_color_pt 			= :ll_color_pt_ant ) AND  
////										( dt_programa_diario.tono 						= :ls_tono_ant ) AND  
////										( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolortono_ant ) AND  
////										( dt_programa_diario.cs_particion 			= :li_cs_particion_ant  ) 
////								)
////						)   ;
////		IF SQLCA.SQLCODE=-1 THEN
////			MessageBox("Error Base datos","No pudo buscar minutos disponibles de prioridad anterior")
////		ELSE
////		END IF
////	END IF
//	ld_ca_min_dispon_ant	=0
//	ldt_fe_fin_ant  		=adt_fe_fin_ant
//END IF
//
////traer minutos estandar
//////minutos prenda:ad_minutos_std
//ld_ca_minutos_std=ad_minutos_std
//
////traer personas por modulo
//////personasxmodulo:an_personasxmodulo
//ll_personasxmodulo=an_personasxmodulo
//
/////////////////////////////////////////// fin    de traer datos iniciales /////////////////////////////////////
//
//
/////////////////////////////////////////// inicio de procesar datos  /////////////////////////////////////
////hacer ciclo para calcular unidades a asignar a diario
//li_dia=an_dias_programados
//DO WHILE ll_unidades_disponibles > 0
//	
//	li_dia=li_dia + 1
//	
//	//trae % de eficiencia de la tabla dt_curva_eficiencia con an_co_curva y dia
////   SELECT dt_curva_eficienci.prc_eficiencia  
////	 INTO :ld_porc_eficiencia
////    FROM dt_curva_eficienci  
////   WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
////         ( dt_curva_eficienci.dia_inicio 	= :li_dia )   ;
////	IF SQLCA.SQLCODE=-1 THEN
////		IF SQLCA.SQLCODE=100 THEN
////			SELECT dt_curva_eficienci.prc_eficiencia
////				INTO :ld_porc_eficiencia
////			 FROM dt_curva_eficienci  
////			WHERE ( dt_curva_eficienci.co_curva 	= :an_co_curva ) AND  
////					( dt_curva_eficienci.dia_fin 		>= :li_dia ) AND  
////					( dt_curva_eficienci.dia_inicio 	< :li_dia )   ;
////			IF SQLCA.SQLCODE=-1 THEN
////				MessageBox("Error Base datos","No pudo buscar eficiencia en curva")
////				RETURN 0
////			ELSE
////			END IF
////		ELSE
////			MessageBox("Error Base datos","No pudo buscar eficiencia en curva")
////			RETURN 0
////		END IF
////	ELSE
////	END IF
//	ld_porc_eficiencia=100
//	//Minutos disponibles
//	IF li_dia=1 THEN
//		ld_minutos_disponibles=ld_ca_min_dispon_ant
//	ELSE
//		ld_minutos_disponibles=ad_minutos_jornada
//	END IF
//	////UNIDADES POSIBLES
//	//Obtiene unidades seg$$HEX1$$fa00$$ENDHEX$$n el tipo de empate para el primer dia
//	////  estas son las del primer dia 0 autom, 1 manual, 2 no empate
////	IF li_dia=1 THEN
////			IF an_tipo_empate=0  OR an_tipo_empate=2 THEN  //automatico o no empata
////				ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
////			ELSE
////				IF an_tipo_empate=1 THEN  //MANUAL, DEBE TRAER UNIDADES EMPATE
////					ll_ca_unid_posibles=an_unidades_empate
////				ELSE
////					MessageBox("Error datos","Tipo de empate no permitido")
////					RETURN 0
////				END IF
////			END IF
////	ELSE
////		ll_ca_unid_posibles=(ld_minutos_disponibles / ad_minutos_std ) * an_personasxmodulo * (ld_porc_eficiencia/100)
////	END IF
//	ll_ca_unid_posibles=an_base_dia
//
//	////UNIDADES A ASIGNAR
//	IF ll_unidades_disponibles >  ll_ca_unid_posibles THEN
//		ll_ca_pendiente=ll_ca_unid_posibles
//		ld_ca_min_dispon_fin=0
//	ELSE
//		ll_ca_pendiente=ll_unidades_disponibles
//		ld_ca_min_dispon_fin=ld_minutos_disponibles - ((ad_minutos_std * ll_ca_pendiente) / ( an_personasxmodulo)) * (ld_porc_eficiencia/100) 	
//	END IF
//	
//	////UNIDADES QUE QUEDAN
//	ll_ca_unid_dispon_fin=ll_unidades_disponibles - ll_ca_pendiente
//		
//	li_cs_fechas=li_dia
//	
//	//fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n
//	IF li_dia=1 THEN
//		IF li_cs_prioridad=1 THEN
//			ldt_fe_inicio=adt_fe_inicio_prog
//			IF ISNULL(adt_fe_inicio_prog) THEN
//				MessageBox("Error de Datos","Para la primera asignaci$$HEX1$$f300$$ENDHEX$$n debe tener fecha de inicio de programaci$$HEX1$$f300$$ENDHEX$$n")
//				RETURN 0
//			ELSE
//			END IF
//		ELSE
//			//DEPENDE DE EL TIPO DE EMPATE 0 autom, 1 manual, 2 no empate
//			ldt_fe_inicio=ldt_fe_fin_ant
//			IF li_tipo_empate=0 THEN //NO EMPATA
//				ldt_fe_inicio=datetime(RelativeDate(date(ldt_fe_fin_ant),1), time(ldt_fe_fin_ant))
//			ELSE
//			END IF
//		END IF
//		ldt_fe_inicio_prog_tot=ldt_fe_inicio
//	ELSE
//		ldt_fe_inicio=adt_fe_fin_ant
//		ldt_fe_inicio=datetime(RelativeDate(date(ldt_fe_inicio),1), time(ldt_fe_inicio))
//	END IF
//	
//	li_duracion=1
//	ldt_fe_fin = datetime(RelativeDate(date(ldt_fe_inicio),1), time(ldt_fe_inicio))
//	
//	li_co_est_prog_dia=1
//	li_fuente_dato=1
//	
//	ldt_fechahora = f_fecha_servidor()
//	ldt_fe_creacion=ldt_fechahora   
//   ldt_fe_actualizacion=ldt_fe_creacion
//	//datos de salida
//	///////////////////////////////////////// inicio de datos de salida  /////////////////////////////////////
//
//	
//	//actualiza la tabla 
//	INSERT INTO dt_programa_diario  
//         ( simulacion,   
//           co_fabrica,   
//           co_planta,   
//           co_modulo,   
//           co_fabrica_exp,   
//           pedido,   
//           cs_liberacion,   
//           po,   
//           co_fabrica_pt,   
//           co_linea,   
//           co_referencia,   
//           co_color_pt,   
//           tono,   
//           cs_estilocolortono,   
//           cs_particion,   
//           cs_fechas,   
//           fe_inicio,   
//           ca_unid_dispon_ini,   
//           ca_min_dispon_ini,   
//           ca_unid_dispon_fin,   
//           ca_min_dispon_fin,   
//           personasxmodulo,   
//           porc_eficiencia,   
//           ca_unid_posibles,   
//           duracion,   
//           fe_fin,   
//           ca_programada,   
//           ca_producida,   
//           ca_pendiente,   
//           co_est_prog_dia,   
//           fuente_dato,   
//           fe_creacion,   
//           fe_actualizacion,   
//           usuario,   
//           instancia )  
//  VALUES ( :an_simulacion,   
//           :an_fabrica_modulo,   
//           :an_planta_modulo,   
//           :an_modulo,   
//           :an_co_fabrica_exp,   
//           :an_pedido,   
//           :an_cs_liberacion,   
//           :as_po,   
//           :an_co_fabrica_ref,   
//           :an_co_linea_ref,   
//           :an_co_referencia,   
//           :an_color_pt,   
//           :as_tono,   
//           :an_cs_estilocolortono,   
//           :an_cs_particion,   
//           :li_cs_fechas,   
//           :ldt_fe_inicio,   
//           :ll_unidades_disponibles, 
//			  :ld_minutos_disponibles, 
//			  :ll_ca_unid_dispon_fin, 
//			  :ld_ca_min_dispon_fin, 
//			  :an_personasxmodulo,   
//			  :ld_porc_eficiencia, 
//			  :ll_ca_unid_posibles,   
//			  :li_duracion, 
//			  :ldt_fe_fin,   
//           :ll_ca_pendiente,   
//           0,   
//           :ll_ca_pendiente,   
//           :li_co_est_prog_dia,   
//           :li_fuente_dato,   
//           :ldt_fe_creacion,   
//           :ldt_fe_actualizacion,   
//           :gstr_info_usuario.codigo_usuario,   
//           :gstr_info_usuario.instancia )  ;
//	IF SQLCA.SQLCODE=-1 THEN
//		MessageBox("Error Base Datos","No pudo insertar unidades en dias")
//		RETURN 0
//	ELSE
//	END IF
//	///////////////////////////////////////// fin    de datos de salida  /////////////////////////////////////
//	
//	ll_unidades_disponibles=ll_unidades_disponibles - ll_ca_pendiente
//
//LOOP
//ldt_fe_fin_prog_tot=ldt_fe_fin
//
//IF NOT isnull(ldt_fe_fin_prog_tot) THEN		
//		ls_nombre_dia = UPPER(string(ldt_fe_fin_prog_tot, "ddd"))
//		ld_fecha_despacho = date(ldt_fe_fin_prog_tot)
//		CHOOSE CASE ls_nombre_dia
//			CASE 'MON'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)				
//			CASE 'TUE'				
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 4)
//			CASE 'WED'				
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)	
//			CASE 'THU'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
//			CASE 'FRI'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 5)
//			CASE 'SAT'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 7)
//			CASE 'SUN'
//				ld_fecha_despacho = Relativedate(ld_fecha_despacho, 6)
//		END CHOOSE				
//		
////		IF ld_fecha_despacho > ld_fecha_terminacion THEN
////			ll_desface = DaysAfter (ld_fecha_terminacion, ld_fecha_despacho)  			
////		ELSE
////			ll_desface = DaysAfter (ld_fecha_terminacion, ld_fecha_despacho)
////		END IF
//	
////		ad_datawindow.setitem(ll_fila, 'fe_despacho',ld_fecha_despacho)
////		ad_datawindow.setitem(ll_fila, 'dias_atrazo',ll_desface)	
////		ad_datawindow.setitem(ll_fila, 'fe_inicio_progs',ldt_fecha_inicial)			   	
////		ad_datawindow.setitem(ll_fila, 'fe_final_progs',ldt_fecha_final)	
//	END IF
//ldt_fe_calculada_despacho=datetime(ld_fecha_despacho, time(ldt_fe_fin_prog_tot))
//
////update a dt_pdnxmodulo
//  UPDATE dt_pdnxmodulo  
//     SET fe_inicio_prog 	= :ldt_fe_inicio_prog_tot,   
//         fe_fin_prog 		= :ldt_fe_fin_prog_tot,
//			fe_requerida_desp	= :ldt_fe_calculada_despacho
//	WHERE ( dt_pdnxmodulo.simulacion 			= :an_simulacion ) AND  
//			( dt_pdnxmodulo.co_fabrica 			= :an_fabrica_modulo ) AND  
//			( dt_pdnxmodulo.co_planta 				= :an_planta_modulo ) AND  
//			( dt_pdnxmodulo.co_modulo 				= :an_modulo ) AND  
//			( dt_pdnxmodulo.co_fabrica_exp 		= :an_co_fabrica_exp) AND  
//			( dt_pdnxmodulo.pedido 					= :an_pedido ) AND  
//			( dt_pdnxmodulo.cs_liberacion 		= :an_cs_liberacion ) AND  
//			( dt_pdnxmodulo.po 						= :as_po ) AND  
//			( dt_pdnxmodulo.co_fabrica_pt 		= :an_co_fabrica_ref ) AND  
//			( dt_pdnxmodulo.co_linea 				= :an_co_linea_ref ) AND  
//			( dt_pdnxmodulo.co_referencia 		= :an_co_referencia ) AND  
//			( dt_pdnxmodulo.co_color_pt 			= :an_color_pt ) AND  
//			( dt_pdnxmodulo.tono 					= :as_tono ) AND  
//			( dt_pdnxmodulo.cs_estilocolortono 	= :an_cs_estilocolortono ) AND  
//			( dt_pdnxmodulo.cs_particion 			= :an_cs_particion  )   ;
//			
//	IF SQLCA.SQLCODE = -1 THEN
//		MessageBox("Error Base Datos","No pudo Actualizar fechas de inicio y fin de asignaci$$HEX1$$f300$$ENDHEX$$n")
//		RETURN 0
//	ELSE
//	END IF
//
//
RETURN 1 
//
end function

public function long wf_ins_tallas (long an_simulacion, long an_co_fabrica_modulo, long an_co_planta_modulo, long an_co_modulo, long an_co_fabrica_exp, long an_pedido, long an_cs_liberacion, string as_po, long an_co_fabrica_pt, long an_co_linea, long an_co_referencia, long an_co_color_pt, string as_tono, long an_cs_estilocolortono, long an_cs_particion, long an_co_tipo_asignacion);Long 			li_co_talla,li_secuencia
LONG				ll_ca_unidadesxtalla,ll_ca_proyectada,ll_ca_actual, ll_ca_numerada
DATETIME			ldt_fe_creacion,ldt_fe_actualizacion,ldt_fechahora

li_secuencia=0  
//ac$$HEX2$$e1002000$$ENDHEX$$debe insertar seg$$HEX1$$fa00$$ENDHEX$$n sea un allocation o una liberaci$$HEX1$$f300$$ENDHEX$$n
IF an_co_tipo_asignacion=1 THEN//allocation
	//cursor para buscar las tallas en allocation
	DECLARE cur_tallas_alloc CURSOR FOR
	  SELECT pedpend_exp.co_talla,   
         pedpend_exp.ca_pedida  
    FROM peddig,   
         pedpend_exp  
   WHERE ( peddig.pedido = pedpend_exp.pedido ) and  
         ( ( peddig.co_fabrica_vta 		= :an_co_fabrica_exp ) AND  
         ( peddig.pedido 					= :an_pedido ) AND  
         ( pedpend_exp.nu_orden 			= :as_po) AND  
         ( pedpend_exp.co_fabrica 		= :an_co_fabrica_pt ) AND  
         ( pedpend_exp.co_linea 			= :an_co_linea ) AND  
         ( pedpend_exp.co_referencia 	= :an_co_referencia ) AND  
         ( pedpend_exp.co_color 			= :an_co_color_pt ) )   
	ORDER BY pedpend_exp.co_talla;
				
	OPEN cur_tallas_alloc;			
	IF SQLCA.SQLCODE = -1 THEN
		MessageBox("Error base datos","No pudo buscar tallas del allocation para esta asignaci$$HEX1$$f300$$ENDHEX$$n")
	ELSE
	END IF
	
	FETCH cur_tallas_alloc INTO :li_co_talla,:ll_ca_unidadesxtalla;
	IF SQLCA.SQLCODE = -1 THEN
		MessageBox("Error base datos","No pudo abrir busqueda de tallas del allocation para esta asignaci$$HEX1$$f300$$ENDHEX$$n")
	ELSE
	END IF
	
	ldt_fechahora = f_fecha_servidor()
	ll_ca_proyectada=0
	ll_ca_actual=0
	IF an_co_tipo_asignacion=1 THEN
		ll_ca_proyectada=ll_ca_unidadesxtalla
	ELSE
		ll_ca_actual=ll_ca_unidadesxtalla
	END IF
	
	DO WHILE SQLCA.SQLCODE = 0
		li_secuencia=li_secuencia + 1
		ldt_fe_creacion		=ldt_fechahora
		ldt_fe_actualizacion	=ldt_fechahora
		ll_ca_proyectada=ll_ca_unidadesxtalla
		//inserte en dt_talla_pdnmodulo
			INSERT INTO dt_talla_pdnmodulo  
				( simulacion,						co_fabrica,						co_planta,						co_modulo,   
				  co_fabrica_exp,					pedido,							cs_liberacion,   				po,   
				  co_fabrica_pt,   				co_linea,						co_referencia,					co_color_pt,   
				  tono,   							cs_estilocolortono,			cs_particion,					co_talla,   
				  cs_orden_talla,   				cs_prioridad,					ca_programada,					ca_producida,   
				  ca_pendiente,   				co_est_prog_talla,			fuente_dato,					fe_creacion,   
				  fe_actualizacion,   			usuario,							instancia,						co_estado_merc,
				  ca_proyectada,					ca_actual,						ca_numerada)  
	  VALUES ( :an_simulacion,   				:an_co_fabrica_modulo,		:an_co_planta_modulo,		:an_co_modulo,   
				  :an_co_fabrica_exp,   		:an_pedido,   					:an_cs_liberacion,   		:as_po,   
				  :an_co_fabrica_pt,   			:an_co_linea,   				:an_co_referencia,   		:an_co_color_pt,   
				  :as_tono,   						:an_cs_estilocolortono,   	:an_cs_particion,   			:li_co_talla,   
				  :li_secuencia,   				1,   								:ll_ca_unidadesxtalla,   	0,
				  // Debe reconstrurse desde produccion..?
				  :ll_ca_unidadesxtalla,   	1,   								1,   								:ldt_fe_creacion,   
				  :ldt_fe_actualizacion,   	:gstr_info_usuario.codigo_usuario,   :gstr_info_usuario.instancia,	 "A",
				  :ll_ca_proyectada,				:ll_ca_actual,					0)  ;
				  // Debe reconstruirse desde Liberaciones..?
	
	
		FETCH cur_tallas_alloc INTO :li_co_talla,:ll_ca_unidadesxtalla;
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox("Error base datos","No pudo abrir busqueda de tallas del allocation para esta asignaci$$HEX1$$f300$$ENDHEX$$n")
		ELSE
		END IF
	
	LOOP
ELSE//pedidos
	//cursor para buscar las tallas en liberacion
	DECLARE cur_tallas CURSOR FOR  
	  SELECT dt_escalasxtela.co_talla,   
				dt_escalasxtela.ca_unidades,
				dt_escalasxtela.ca_numerada
		 FROM dt_pdnxmodulo,   
				dt_escalasxtela  
		WHERE ( dt_pdnxmodulo.co_fabrica_exp 			= dt_escalasxtela.co_fabrica_exp ) and  
				( dt_pdnxmodulo.pedido 						= dt_escalasxtela.pedido ) and  
				( dt_pdnxmodulo.cs_liberacion 			= dt_escalasxtela.cs_liberacion ) and  
				( dt_pdnxmodulo.po 							= dt_escalasxtela.nu_orden ) and  
				( dt_pdnxmodulo.co_fabrica_pt 			= dt_escalasxtela.co_fabrica_pt ) and  
				( dt_pdnxmodulo.co_linea 					= dt_escalasxtela.co_linea ) and  
				( dt_pdnxmodulo.co_referencia 			= dt_escalasxtela.co_referencia ) and  
				( dt_pdnxmodulo.co_color_pt 				= dt_escalasxtela.co_color_pt ) and  
				( dt_pdnxmodulo.tono 						= dt_escalasxtela.tono ) and  
				( dt_pdnxmodulo.cs_estilocolortono 		= dt_escalasxtela.cs_estilocolortono ) and 
				//la siguiente linea se debe habilitar para cuando se organize la liberacion
				//( dt_escalasxtela.raya					= 10 )
				( ( dt_pdnxmodulo.simulacion 				=: an_simulacion ) AND  
				( dt_pdnxmodulo.co_fabrica 				=: an_co_fabrica_modulo ) AND  
				( dt_pdnxmodulo.co_planta 					=: an_co_planta_modulo ) AND  
				( dt_pdnxmodulo.co_modulo 					=: an_co_modulo ) AND  
				( dt_pdnxmodulo.co_fabrica_exp 			=: an_co_fabrica_exp ) AND  
				( dt_pdnxmodulo.pedido 						=: an_pedido ) AND  
				( dt_pdnxmodulo.cs_liberacion 			=: an_cs_liberacion ) AND  
				( dt_pdnxmodulo.po 							=: as_po ) AND  
				( dt_pdnxmodulo.co_fabrica_pt 			=: an_co_fabrica_pt ) AND  
				( dt_pdnxmodulo.co_linea 					=: an_co_linea ) AND  
				( dt_pdnxmodulo.co_referencia 			=: an_co_referencia ) AND  
				( dt_pdnxmodulo.co_color_pt 				=: an_co_color_pt ) AND  
				( dt_pdnxmodulo.tono 						=: as_tono ) AND  
				( dt_pdnxmodulo.cs_estilocolortono 		=: an_cs_estilocolortono) AND  
				( dt_pdnxmodulo.cs_particion 				=: an_cs_particion ) )   
	ORDER BY dt_escalasxtela.co_talla;
				
	OPEN cur_tallas;			
	IF SQLCA.SQLCODE = -1 THEN
		MessageBox("Error base datos","No pudo buscar tallas de la liberaci$$HEX1$$f300$$ENDHEX$$n para esta asignaci$$HEX1$$f300$$ENDHEX$$n")
	ELSE
	END IF
	
	FETCH cur_tallas INTO :li_co_talla, :ll_ca_unidadesxtalla, :ll_ca_numerada;
	IF SQLCA.SQLCODE = -1 THEN
		MessageBox("Error base datos","No pudo abrir busqueda de tallas de la liberaci$$HEX1$$f300$$ENDHEX$$n para esta asignaci$$HEX1$$f300$$ENDHEX$$n")
	ELSE
	END IF
	
	ldt_fechahora = f_fecha_servidor()
	
	DO WHILE SQLCA.SQLCODE = 0
		li_secuencia=li_secuencia + 1
		ldt_fe_creacion		=ldt_fechahora
		ldt_fe_actualizacion	=ldt_fechahora
		ll_ca_actual=ll_ca_unidadesxtalla
		//inserte en dt_talla_pdnmodulo
			INSERT INTO dt_talla_pdnmodulo  
				( simulacion,						co_fabrica,   					co_planta,   						co_modulo,   
				  co_fabrica_exp,   				pedido,   						cs_liberacion,   					po,   
				  co_fabrica_pt,   				co_linea,   					co_referencia,   					co_color_pt,   
				  tono,   							cs_estilocolortono,   		cs_particion,   					co_talla,   
				  cs_orden_talla,   				cs_prioridad,   				ca_programada,   					ca_producida,   
				  ca_pendiente,   				co_est_prog_talla,   		fuente_dato,   					fe_creacion,   
				  fe_actualizacion,   			usuario,   						instancia,							co_estado_merc,
				  ca_proyectada,					ca_actual,						ca_numerada)  
	  VALUES ( :an_simulacion,   				:an_co_fabrica_modulo,   	:an_co_planta_modulo,   		:an_co_modulo,   
				  :an_co_fabrica_exp,   		:an_pedido,   					:an_cs_liberacion,   			:as_po,   
				  :an_co_fabrica_pt,   			:an_co_linea,   				:an_co_referencia,   			:an_co_color_pt,   
				  :as_tono,   						:an_cs_estilocolortono,   	:an_cs_particion,   				:li_co_talla,   
				  :li_secuencia,   				1,   								:ll_ca_unidadesxtalla,   		0,   								// Debe reconstruirse desde Produccion
				  :ll_ca_unidadesxtalla,   	1,   								1,   									:ldt_fe_creacion,   
				  :ldt_fe_actualizacion,   	:gstr_info_usuario.codigo_usuario,   :gstr_info_usuario.instancia,	"A",
				  :ll_ca_proyectada,				:ll_ca_actual,					:ll_ca_numerada);					
				  
				  FETCH cur_tallas INTO :li_co_talla,:ll_ca_unidadesxtalla, :ll_ca_numerada;
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox("Error base datos","No pudo abrir busqueda de tallas de la liberaci$$HEX1$$f300$$ENDHEX$$n para esta asignaci$$HEX1$$f300$$ENDHEX$$n")
		ELSE
		END IF
	
	LOOP
	
END IF

RETURN 1
end function

on w_fechas_requisito_independiente.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_asignacion_modulos" then this.MenuID = create m_mantenimiento_asignacion_modulos
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_fechas_requisito_independiente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_buscar;call super::ue_buscar;//////////////////////////////////////////////////////////////////////
////Las siguientes lineas se deben acondicionar seg$$HEX1$$fa00$$ENDHEX$$n la ventana.
/////////////////////////////////////////////////////////////////////
//s_base_parametros lstr_parametros
//Long ll_hallados
//Long li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion
//STRING	ls_de_modulo
//
//IF is_cambios = "no" OR is_accion <> "cancelo" THEN
//	Open(w_buscar_moduloxsimulacion)
//	lstr_parametros=message.powerObjectparm
//
//	IF lstr_parametros.hay_parametros THEN
//		li_co_fabrica_modulo	=lstr_parametros.entero[1]
//		li_co_planta_modulo	=lstr_parametros.entero[2]
//		li_co_modulo			=lstr_parametros.entero[3]
//		li_simulacion			=lstr_parametros.entero[4]
//		ls_de_modulo			=lstr_parametros.cadena[1]
//		ii_simulacion_base	=li_simulacion
//		ll_hallados = dw_maestro.Retrieve(ls_de_modulo)
//		IF isnull(ll_hallados) THEN
//			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//		ELSE
//			CHOOSE CASE ll_hallados
//				CASE -1
//					il_fila_actual_maestro = -1
//					MessageBox("Error buscando","Error de la base",StopSign!,&
//                         Ok!)
//				CASE 0
//					il_fila_actual_maestro = 0
//					MessageBox("Sin Datos","No hay datos para su criterio",&
//                         Exclamation!,Ok!)
//				CASE ELSE
//					il_fila_actual_maestro = 1
//					IF ISNULL(li_co_fabrica_modulo) OR ISNULL(li_co_planta_modulo) OR &
//						ISNULL(li_co_modulo) THEN
//						MessageBox("Error datos","Tiene alg$$HEX1$$fa00$$ENDHEX$$n dato nulo en el m$$HEX1$$f300$$ENDHEX$$dulo para traer asignaciones")
//					ELSE
//						IF  ISNULL(li_simulacion) THEN
//								dw_detalle.Reset()
//						ELSE
//							ll_hallados = dw_detalle.Retrieve(li_co_fabrica_modulo,li_co_planta_modulo,li_simulacion)					
//							IF isnull(ll_hallados) THEN
//								MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//							ELSE
//								CHOOSE CASE ll_hallados
//									CASE -1
//										il_fila_actual_detalle = -1
//										MessageBox("Error buscando","Error de la base",StopSign!,&
//													 Ok!)
//									CASE 0
//										il_fila_actual_detalle = 0										
//									CASE ELSE
//										il_fila_actual_detalle = 1			
//								END CHOOSE
//							END IF
//						END IF
//					END IF
//			END CHOOSE
//		END IF
//	ELSE
//	END IF
//ELSE
//END IF
//
end event

event ue_insertar_detalle;//LONG 					ll_fila,ll_hallados
//LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
//LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia,ll_ca_a_comparar
//LONG					ll_unidades_empate,ll_asignaciones,ll_ca_pendiente,ll_ca_faltan,ll_ca_a_asignar
//LONG					ll_ca_proyectada,ll_ca_actual, ll_ca_numerada
//
//Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion,li_max_particion
//Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla,li_max_cs_estilocolortono
//Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion,ll_inserto_tallas
//Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
//Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_cs_prioridad,li_rpta,li_cs_particion_anterior
//
//DECIMAL				ld_ca_minutos_std,ld_minutos_jornada
//
//STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_co_estado_merc
//
//DateTime 			ldt_fechahora
//DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog,ldt_fe_requerida_desp
//
//s_base_parametros lstr_parametros
//
//
////-------------------  inicio de verificacion de detalle --------------------------//
//IF il_fila_actual_maestro > 0 THEN
//	IF dw_detalle.AcceptText() = -1 THEN
//		
//		MessageBox("Error datawindow","No se pudo insertar el registro del detalle porque habian ingresos previos con problemas" &
//					,StopSign!)	
//					
////-------------------  fin de verificacion de detalle  ---------------------------//	
//
//
//	ELSE
////-------------------  inicio de traer datos de modulo  ---------------------------//							
//		li_co_fabrica_modu 	= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
//		li_co_planta_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
//		li_co_modulo 				= 0//dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_modulo")
//		
//		IF IsNull(li_co_fabrica_modu) OR IsNull(li_co_planta_modu) OR IsNull(li_co_modulo)  THEN
//			dw_detalle.DeleteRow(il_fila_actual_detalle)
//			il_fila_actual_detalle = il_fila_actual_detalle - 1
////-------------------  fin de traer datos de modulo  ---------------------------//										
//
//
//
//		ELSE
////-------------------  inicio de seleccionar datos a asignar  ---------------------------//													
//			lstr_parametros.entero[1]=ii_simulacion_base
//			lstr_parametros.hay_parametros=TRUE
//				
//			OpenWithParm(w_buscar_pendientesxasignar,lstr_parametros)
//				
//			lstr_parametros = Message.PowerObjectParm
//				
//			IF lstr_parametros.hay_parametros THEN
//				
//				li_co_fabrica_exp			=lstr_parametros.entero[1]
//				ll_pedido					=lstr_parametros.entero[2]
//				ls_gpa						=lstr_parametros.cadena[1]
//				ls_tipo_pedido				=lstr_parametros.cadena[2]
//				ls_nu_orden					=lstr_parametros.cadena[3]
//				li_co_fabrica_ref			=lstr_parametros.entero[3]
//				li_co_linea_ref			=lstr_parametros.entero[4]
//				ll_co_referencia			=lstr_parametros.entero[5]
//				ll_color_pt					=lstr_parametros.entero[6]
//				ll_cs_liberacion			=lstr_parametros.entero[7]
//				ll_ca_unidades				=lstr_parametros.entero[8]
//				ls_tono						=lstr_parametros.cadena[4]
//				li_cs_estilocolton		=lstr_parametros.entero[9]
//				li_simulacion				=lstr_parametros.entero[10]
//				ll_pedido_po				=lstr_parametros.entero[11]
//				ll_ca_a_asignar			=lstr_parametros.entero[12]
//				ll_ca_faltan				=lstr_parametros.entero[13]
//				
//				If li_simulacion <> 1 Then
//					MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Para insertar un detalle de corte debe seleccionar la silumaci$$HEX1$$f300$$ENDHEX$$n 1.")
//					Return
//				End If
//// 
////-------------------  fin de seleccionar datos a asignar  ---------------------------//																	
//
//
//
//
////-------------------  inicio de insertar fila vac$$HEX1$$ed00$$ENDHEX$$a en detalle  ---------------------------//																	
//				ll_fila = dw_detalle.InsertRow(0)
//					
//				IF ll_fila = -1 THEN
//					MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
//				ELSE
//					dw_detalle.SetFocus()
//					dw_detalle.SetRow(ll_fila)
//					dw_detalle.ScrollToRow(ll_fila)
//					dw_detalle.SetColumn(1)
//					il_fila_actual_detalle = ll_fila 
//					dw_detalle.SelectRow(il_fila_actual_detalle,FALSE)
//					il_fila_actual_detalle = dw_detalle.GetRow()
//					IF ((il_fila_actual_detalle<> -1) and (NOT ISNULL (il_fila_actual_detalle)) and (il_fila_actual_detalle<>0))THEN
//						dw_detalle.SelectRow(il_fila_actual_detalle,TRUE)
////-------------------  fin de insertar fila vac$$HEX1$$ed00$$ENDHEX$$a en detalle  ---------------------------//																							
//
//
//
////-------------------  inicio de organizar datos para grabar en fila detalle  ---------------------------//																							
//						//cargar variables para hacer setitem
//						ll_ca_proyectada=0
//						ll_ca_actual=0
//						CHOOSE CASE ls_tipo_pedido
//							CASE "AL"
//								li_co_tipo_asignacion=1
//								ll_ca_proyectada=ll_ca_a_asignar
//							CASE "EX"
//								li_co_tipo_asignacion=2
//								ll_ca_actual=ll_ca_a_asignar
//							CASE "NA"
//								li_co_tipo_asignacion=2
//								ll_ca_actual=ll_ca_a_asignar
//						END CHOOSE
//						
//						SELECT sum(m_estandares.tiempo_st) 
//						 INTO :ld_ca_minutos_std
//						 FROM m_estandares  
//						WHERE ( m_estandares.co_planta 			= :li_co_planta_modu ) AND  
//								( m_estandares.co_fabrica 			= :li_co_fabrica_ref ) AND  
//								( m_estandares.co_linea 			= :li_co_linea_ref ) AND  
//								( m_estandares.co_referencia 		= :ll_co_referencia ) AND  
//								( m_estandares.co_centro_pdn 		= 2 ) AND  //COSTURA
//								( m_estandares.co_subcentro_pdn 	= 2 )   ;//ENSAMBLE
//								
//						IF SQLCA.SQLCODE=-1 THEN
//							MessageBox("Error Base datos","No pudo buscar minutos estandar")
//						ELSE
//							IF ISNULL(ld_ca_minutos_std) OR ld_ca_minutos_std=0 THEN
//								ld_ca_minutos_std=0
//							ELSE
//							
//							END IF
//						END IF
//						
//						ll_ca_programada			=ll_ca_a_asignar
//						ll_ca_producida			=0						// Debe buscarse en Produccion
//						ll_ca_pendiente			=ll_ca_a_asignar - ll_ca_producida
//						li_co_estado_asigna		=1
//						li_co_curva					=1
//						ll_ca_personasxmod		=32
//						li_cod_tur					=1
//						li_ind_cambio_estilo		=1
//						li_orige_uni_base_dia	=1
//						li_tipo_empate				=2 					//no empate
//						ll_unidades_empate		=0
//						li_metodo_programa		=1
//						li_fuente_dato				=1 					//datawindow
//						ld_minutos_jornada		=480 					//tomar de modulo y fecha
//						ls_co_estado_merc			="A"
//						
//						IF ld_ca_minutos_std > 0 THEN
//							ll_ca_unidad_base_dia = (ld_minutos_jornada / ld_ca_minutos_std) * ll_ca_personasxmod
//						ELSE
//						END IF
//						
//						// Las siguientes lineas se colocan en comentario para poder hacer el cambio de 
//						// partir allocations y partir liberaciones
//						
//						SELECT count(*)  
//						INTO :ll_asignaciones  
//						 FROM dt_pdnxmodulo  								
//						WHERE ( dt_pdnxmodulo.simulacion 			=  :li_simulacion) AND  
//								( dt_pdnxmodulo.co_fabrica 			=  :li_co_fabrica_modu) AND  
//								( dt_pdnxmodulo.co_planta		 		=  :li_co_planta_modu) AND  
//								( dt_pdnxmodulo.co_modulo 				=  :li_co_modulo) AND  
//								( dt_pdnxmodulo.co_fabrica_exp 		=  :li_co_fabrica_exp) AND  
//								( dt_pdnxmodulo.pedido 					=  :ll_pedido) AND  
//								( dt_pdnxmodulo.cs_liberacion 		=  :ll_cs_liberacion) AND  
//								( dt_pdnxmodulo.po 						=  :ls_nu_orden) AND  
//								( dt_pdnxmodulo.co_fabrica_pt 		=  :li_co_fabrica_ref) AND  
//								( dt_pdnxmodulo.co_linea 				=  :li_co_linea_ref) AND  
//								( dt_pdnxmodulo.co_referencia 		=  :ll_co_referencia) AND  
//								( dt_pdnxmodulo.co_color_pt 			=  :ll_color_pt) AND  
//								( dt_pdnxmodulo.tono 					=  :ls_tono) AND  
//								( dt_pdnxmodulo.cs_estilocolortono 	=  :li_cs_estilocolton) ;
//								
//						IF SQLCA.SQLCODE=-1 THEN
//							MessageBox("Error Base Datos","No pudo buscar cuantas asignaciones tiene estos datos para el modulo")
//							RETURN 0
//						ELSE
//						END IF
//						
//						li_cs_particion=1	
//						
//						IF ll_asignaciones=0 OR ISNULL(ll_asignaciones) THEN
//							
//						ELSE //existe la secuencia de la liberaci$$HEX1$$f300$$ENDHEX$$n en el m$$HEX1$$f300$$ENDHEX$$dulo
//							
//							//se va a comentariar el if mientras se hace la opci$$HEX1$$f300$$ENDHEX$$n de partir escalas en la liberacion
//							IF li_co_tipo_asignacion=1 THEN //si es allocation, parte la secuencia (cs_estilocolortono)
//																		// dentro de la 102
//								
//								//debe buscar la max cs_estilocolortono e incrementar
//								SELECT MAX(dt_pdnxmodulo.cs_particion)  
//									INTO :li_max_cs_estilocolortono
//								 FROM dt_pdnxmodulo  								
//								WHERE ( dt_pdnxmodulo.simulacion 			=  :li_simulacion) AND  
//										( dt_pdnxmodulo.co_fabrica 			=  :li_co_fabrica_modu) AND  
//										( dt_pdnxmodulo.co_planta		 		=  :li_co_planta_modu) AND  
//										( dt_pdnxmodulo.co_modulo 				=  :li_co_modulo) AND  
//										( dt_pdnxmodulo.co_fabrica_exp 		=  :li_co_fabrica_exp) AND  
//										( dt_pdnxmodulo.pedido 					=  :ll_pedido) AND  
//										( dt_pdnxmodulo.cs_liberacion 		=  :ll_cs_liberacion) AND  
//										( dt_pdnxmodulo.po 						=  :ls_nu_orden) AND  
//										( dt_pdnxmodulo.co_fabrica_pt 		=  :li_co_fabrica_ref) AND  
//										( dt_pdnxmodulo.co_linea 				=  :li_co_linea_ref) AND  
//										( dt_pdnxmodulo.co_referencia 		=  :ll_co_referencia) AND  
//										( dt_pdnxmodulo.co_color_pt 			=  :ll_color_pt) AND  
//										( dt_pdnxmodulo.tono 					=  :ls_tono) ;//AND
//										//( dt_pdnxmodulo.cs_estilocolortono	=  :li_cs_estilocolton)
//										//;
//
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo buscar la mayor partici$$HEX1$$f300$$ENDHEX$$n para estos datos para el modulo")
//									RETURN 0
//								ELSE
//								END IF
//								
//								IF ISNULL(li_max_cs_estilocolortono ) THEN
//									li_max_cs_estilocolortono=0
//								ELSE
//								END IF
//									
//								li_max_cs_estilocolortono=li_max_cs_estilocolortono + 1
//								li_cs_estilocolton=li_max_cs_estilocolortono
//							ELSE
//								MessageBox("Error Datos","Ya existen los datos en el m$$HEX1$$f300$$ENDHEX$$dulo, si necesita generar secuencia, por favor use la opci$$HEX1$$f300$$ENDHEX$$n para ello")
//								RETURN 0
//							END IF
//						END IF
//								
//
//						//busca la m$$HEX1$$e100$$ENDHEX$$xima prioridad
////						SELECT max(dt_pdnxmodulo.cs_prioridad)  
////						 INTO :li_cs_prioridad  
////						 FROM dt_pdnxmodulo  
////						WHERE ( dt_pdnxmodulo.simulacion = :li_simulacion ) AND  
////								( dt_pdnxmodulo.co_fabrica = :li_co_fabrica_modu ) AND  
////								( dt_pdnxmodulo.co_planta =  :li_co_planta_modu) AND  
////								( dt_pdnxmodulo.co_modulo =  :li_co_modulo)   ;
////								
////						IF SQLCA.SQLCODE=-1 THEN
////							MessageBox("Error Base Datos","No pudo hallar prioridad para asignaci$$HEX1$$f300$$ENDHEX$$n")
////							RETURN
////						ELSE
////							IF ISNULL(li_cs_prioridad) THEN
////								li_cs_prioridad = 0
////							ELSE
////							END IF
////						END IF
//
//						//li_cs_prioridad=li_cs_prioridad + 1
//						li_cs_prioridad = ll_fila
////-------------------  fin de organizar datos para grabar en fila detalle  ---------------------------//																													
//
//
//
////-------------------  inicio de grabar datos en fila detalle  ---------------------------//																													
//						dw_detalle.SetItem(il_fila_actual_detalle,"simulacion",			li_simulacion)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica",			li_co_fabrica_modu)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_planta",			li_co_planta_modu)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_modulo",			li_co_modulo)
//							
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica_exp",		li_co_fabrica_exp)
//						dw_detalle.SetItem(il_fila_actual_detalle,"pedido",				ll_pedido)
//						dw_detalle.SetItem(il_fila_actual_detalle,"cs_liberacion",		ll_cs_liberacion)
//						dw_detalle.SetItem(il_fila_actual_detalle,"po",						ls_nu_orden)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica_pt",		li_co_fabrica_ref)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_linea",				li_co_linea_ref)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_referencia",		ll_co_referencia)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_color_pt",			ll_color_pt)
//						dw_detalle.SetItem(il_fila_actual_detalle,"tono",					ls_tono)
//						dw_detalle.SetItem(il_fila_actual_detalle,"cs_estilocolortono",li_cs_estilocolton)
//						dw_detalle.SetItem(il_fila_actual_detalle,"cs_particion", 		li_cs_particion)
//						dw_detalle.SetItem(il_fila_actual_detalle,"pedido_po",			ll_pedido_po)
//						dw_detalle.SetItem(il_fila_actual_detalle,"cs_prioridad", 		li_cs_prioridad)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_programada", 		ll_ca_programada)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_producida", 		ll_ca_producida)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_pendiente",		ll_ca_pendiente)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_estado_asigna", 	li_co_estado_asigna)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_curva", 			li_co_curva)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_minutos_std", 	ld_ca_minutos_std)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_tipo_asignacion",li_co_tipo_asignacion)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_personasxmod", 	ll_ca_personasxmod)
//						dw_detalle.SetItem(il_fila_actual_detalle,"cod_tur", 				li_cod_tur)
//						dw_detalle.SetItem(il_fila_actual_detalle,"minutos_jornada", 	ld_minutos_jornada)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ind_cambio_estilo", li_ind_cambio_estilo)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_unid_base_dia", 	ll_ca_unidad_base_dia)
//						dw_detalle.SetItem(il_fila_actual_detalle,"orige_uni_base_dia",li_orige_uni_base_dia)
//						dw_detalle.SetItem(il_fila_actual_detalle,"tipo_empate", 		li_tipo_empate)
//						dw_detalle.SetItem(il_fila_actual_detalle,"unidades_empate", 	ll_unidades_empate)
//						dw_detalle.SetItem(il_fila_actual_detalle,"metodo_programa", 	li_metodo_programa)
//						dw_detalle.SetItem(il_fila_actual_detalle,"fuente_dato", 		li_fuente_dato)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_proyectada",		ll_ca_proyectada)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_actual",			ll_ca_actual)
//						dw_detalle.SetItem(il_fila_actual_detalle,"ca_numerada",			0)
//						
//						ldt_fechahora = f_fecha_servidor()
//						
//						dw_detalle.SetItem(il_fila_actual_detalle,"fe_creacion", 		ldt_fechahora)
//						dw_detalle.SetItem(il_fila_actual_detalle,"fe_actualizacion", 	ldt_fechahora)
//						dw_detalle.SetItem(il_fila_actual_detalle,"usuario", 				gstr_info_usuario.codigo_usuario)
//						dw_detalle.SetItem(il_fila_actual_detalle,"instancia", 			gstr_info_usuario.instancia)
//							
//						dw_detalle.SetItem(il_fila_actual_detalle,"gpa",					ls_gpa)
//						dw_detalle.SetItem(il_fila_actual_detalle,"co_estado_merc",		ls_co_estado_merc)
//						
//						
//						dw_detalle.AcceptText()
//
//						THIS.Triggerevent("ue_grabar")
//						
//						
////-------------------  fin de grabar datos en fila detalle  ---------------------------//																																			
//
//						
//						
//						
////-------------------  inicio de manejo de tallas asociadas a la fila detalle  ---------------------------//
//						IF ISNULL(ll_ca_faltan) THEN
//							ll_ca_a_comparar=ll_ca_unidades
//						ELSE
//							ll_ca_a_comparar=ll_ca_faltan
//						END IF
//						
//						ll_inserto_tallas=1
//						
//						IF ll_ca_a_comparar > ll_ca_a_asignar THEN
//														
//							lstr_parametros.entero[1] 		=  li_co_fabrica_exp   
//							lstr_parametros.entero[2]		=  ll_pedido   
//							lstr_parametros.cadena[1] 		=  ls_nu_orden 
//							lstr_parametros.entero[3] 		=  li_co_fabrica_ref
//							lstr_parametros.entero[4] 		=  li_co_linea_ref 
//							lstr_parametros.entero[5] 		=  ll_co_referencia
//							lstr_parametros.entero[6] 		=  ll_color_pt
//							lstr_parametros.entero[7]		=	li_simulacion
//							lstr_parametros.entero[8]		=	li_co_fabrica_modu
//							lstr_parametros.entero[9]		=	li_co_planta_modu			
//							lstr_parametros.entero[10]		=	li_co_modulo			
//							lstr_parametros.entero[11]		=	ll_cs_liberacion
//							lstr_parametros.cadena[2]		=	ls_tono				
//							lstr_parametros.entero[12]		=	li_cs_estilocolton
//							lstr_parametros.entero[13]		=	li_cs_particion
//							lstr_parametros.entero[14]		=	ll_ca_a_asignar
//							lstr_parametros.entero[15]		=	li_co_fabrica_modu
//							lstr_parametros.entero[16]		=	li_co_planta_modu			
//							lstr_parametros.entero[17]		=	li_co_modulo
//							lstr_parametros.entero[18]		=	0
//							lstr_parametros.entero[19]		=	1 //particion anterior
//									
//							lstr_parametros.hay_parametros=TRUE
//								
//							IF li_co_tipo_asignacion=1 THEN //ALLOCATION
//							
//								OpenWithParm(w_asignar_unid_parciales,lstr_parametros)
//									
//								lstr_parametros = Message.PowerObjectParm
//										
//								IF lstr_parametros.hay_parametros THEN
//								ELSE
//									MessageBox("Error","No pudo insertar unidades parciales, por favor verifique")
//									ll_inserto_tallas=0
//								END IF
//								
//							ELSE// 2 PO$$HEX1$$b400$$ENDHEX$$S
////								OpenWithParm(w_asignar_parciales_liberacion,lstr_parametros)
//
////									
////								lstr_parametros = Message.PowerObjectParm
////										
////								IF lstr_parametros.hay_parametros THEN
////								ELSE
//									MessageBox("Error","La escala se debe asignar completa,si desea partirla use primero la opci$$HEX1$$f300$$ENDHEX$$n Partir Liberaciones")
//									ll_inserto_tallas=0
////								END IF
//							END IF
//						ELSE
//							li_rpta = wf_ins_tallas(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,&
//															li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
//															ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
//															ll_color_pt,ls_tono,&
//															li_cs_estilocolton,li_cs_particion,li_co_tipo_asignacion)
//							IF li_rpta=1 THEN
//								COMMIT;
//							ELSE
//								ROLLBACK;
//								ll_inserto_tallas=0
//							END IF								
//						END IF
////-------------------  fin de manejo de tallas asociadas a la fila detalle  ---------------------------//
//
//
//
////-------------------  inicio  de manejo de par$$HEX1$$e100$$ENDHEX$$metros asociadas a la fila detalle  ---------------------------//
//						IF ll_inserto_tallas=1 THEN
//							//  Calcula total unidades reales y numeradas de escala
//							SELECT SUM(dt_talla_pdnmodulo.ca_programada),SUM(dt_talla_pdnmodulo.ca_numerada) 
//							INTO 	:ll_ca_unidades, :ll_ca_numerada
//							FROM 	dt_talla_pdnmodulo  
//							WHERE 	( dt_talla_pdnmodulo.simulacion 				=:li_simulacion  ) AND  
//										( dt_talla_pdnmodulo.co_fabrica 				=:li_co_fabrica_modu  ) AND  
//										( dt_talla_pdnmodulo.co_planta 				=:li_co_planta_modu  ) AND  
//										( dt_talla_pdnmodulo.co_modulo 				=:li_co_modulo  ) AND  
//										( dt_talla_pdnmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
//										( dt_talla_pdnmodulo.pedido 					=:ll_pedido  ) AND  
//										( dt_talla_pdnmodulo.cs_liberacion 			=:ll_cs_liberacion  ) AND  
//										( dt_talla_pdnmodulo.po 						=:ls_nu_orden  ) AND  
//										( dt_talla_pdnmodulo.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
//										( dt_talla_pdnmodulo.co_linea 				=:li_co_linea_ref  ) AND  
//										( dt_talla_pdnmodulo.co_referencia 			=:ll_co_referencia  ) AND  
//										( dt_talla_pdnmodulo.co_color_pt 			=:ll_color_pt  ) AND  
//										( dt_talla_pdnmodulo.tono 						=:ls_tono  ) AND  
//										( dt_talla_pdnmodulo.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
//										( dt_talla_pdnmodulo.cs_particion 			=:li_cs_particion );
//							IF SQLCA.SQLCODE=-1 THEN
//								MessageBox("Error Base Datos","No Calcular total unidades y numeradas de tallas de asignaci$$HEX1$$f300$$ENDHEX$$n, por favor verifique los datos")
//							ELSE
//							// Actualiza Unidades programadas y numerdas de Parametros 
//									UPDATE dt_pdnxmodulo  
//									SET dt_pdnxmodulo.ca_programada 	= :ll_ca_unidades,
//										 dt_pdnxmodulo.ca_numerada 	= :ll_ca_numerada,
//										 dt_pdnxmodulo.ca_pendiente 	= :ll_ca_unidades - dt_pdnxmodulo.ca_producida
//									WHERE ( dt_pdnxmodulo.simulacion 			= :li_simulacion) AND  
//											( dt_pdnxmodulo.co_fabrica 			= :li_co_fabrica_modu ) AND  
//											( dt_pdnxmodulo.co_planta 				= :li_co_planta_modu ) AND  
//											( dt_pdnxmodulo.co_modulo 				= :li_co_modulo ) AND  
//											( dt_pdnxmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//											( dt_pdnxmodulo.pedido 					= :ll_pedido ) AND  
//											( dt_pdnxmodulo.cs_liberacion 		= :ll_cs_liberacion ) AND  
//											( dt_pdnxmodulo.po 						= :ls_nu_orden ) AND  
//											( dt_pdnxmodulo.co_fabrica_pt 		= :li_co_fabrica_ref ) AND  
//											( dt_pdnxmodulo.co_linea 				= :li_co_linea_ref ) AND  
//											( dt_pdnxmodulo.co_referencia 		= :ll_co_referencia ) AND  
//											( dt_pdnxmodulo.co_color_pt 			= :ll_color_pt ) AND  
//											( dt_pdnxmodulo.tono 					= :ls_tono ) AND  
//											( dt_pdnxmodulo.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
//											( dt_pdnxmodulo.cs_particion 			= :li_cs_particion )   ;
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo actualiar unidades en parametros de asignaci$$HEX1$$f300$$ENDHEX$$n")
//								ELSE 
//									dw_detalle.SetItem(il_fila_actual_detalle,"ca_programada", ll_ca_unidades)
//									dw_detalle.SetItem(il_fila_actual_detalle,"ca_numerada",	ll_ca_numerada)
//									dw_detalle.AcceptText()
//								END IF
//							END IF
//							
////							THIS.TriggerEvent("ue_parametros")
////							
//							commit ;
//							dw_detalle.Retrieve(91,1,1)
//						ELSE
//							//BORRE dt_pdnxmodulo, previo borrado de tallas
//							DELETE FROM dt_talla_pdnmodulo  
//								WHERE ( dt_talla_pdnmodulo.simulacion 				=:li_simulacion  ) AND  
//										( dt_talla_pdnmodulo.co_fabrica 				=:li_co_fabrica_modu  ) AND  
//										( dt_talla_pdnmodulo.co_planta 				=:li_co_planta_modu  ) AND  
//										( dt_talla_pdnmodulo.co_modulo 				=:li_co_modulo  ) AND  
//										( dt_talla_pdnmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
//										( dt_talla_pdnmodulo.pedido 					=:ll_pedido  ) AND  
//										( dt_talla_pdnmodulo.cs_liberacion 			=:ll_cs_liberacion  ) AND  
//										( dt_talla_pdnmodulo.po 						=:ls_nu_orden  ) AND  
//										( dt_talla_pdnmodulo.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
//										( dt_talla_pdnmodulo.co_linea 				=:li_co_linea_ref  ) AND  
//										( dt_talla_pdnmodulo.co_referencia 			=:ll_co_referencia  ) AND  
//										( dt_talla_pdnmodulo.co_color_pt 			=:ll_color_pt  ) AND  
//										( dt_talla_pdnmodulo.tono 						=:ls_tono  ) AND  
//										( dt_talla_pdnmodulo.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
//										( dt_talla_pdnmodulo.cs_particion 			=:li_cs_particion );
//							IF SQLCA.SQLCODE=-1 THEN
//								MessageBox("Error Base Datos","No pudo borrar tallas de asignaci$$HEX1$$f300$$ENDHEX$$n, por favor verifique los datos")
//							ELSE
//								//borra dt_pdnxmodulo
//								DELETE FROM dt_pdnxmodulo  
//									WHERE ( dt_pdnxmodulo.simulacion 			= :li_simulacion) AND  
//											( dt_pdnxmodulo.co_fabrica 			= :li_co_fabrica_modu ) AND  
//											( dt_pdnxmodulo.co_planta 				= :li_co_planta_modu ) AND  
//											( dt_pdnxmodulo.co_modulo 				= :li_co_modulo ) AND  
//											( dt_pdnxmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//											( dt_pdnxmodulo.pedido 					= :ll_pedido ) AND  
//											( dt_pdnxmodulo.cs_liberacion 		= :ll_cs_liberacion ) AND  
//											( dt_pdnxmodulo.po 						= :ls_nu_orden ) AND  
//											( dt_pdnxmodulo.co_fabrica_pt 		= :li_co_fabrica_ref ) AND  
//											( dt_pdnxmodulo.co_linea 				= :li_co_linea_ref ) AND  
//											( dt_pdnxmodulo.co_referencia 		= :ll_co_referencia ) AND  
//											( dt_pdnxmodulo.co_color_pt 			= :ll_color_pt ) AND  
//											( dt_pdnxmodulo.tono 					= :ls_tono ) AND  
//											( dt_pdnxmodulo.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
//											( dt_pdnxmodulo.cs_particion 			= :li_cs_particion )   ;
//								IF SQLCA.SQLCODE=-1 THEN
//									MessageBox("Error Base Datos","No pudo borrar dt_pdnxmodulo en asignaci$$HEX1$$f300$$ENDHEX$$n")
//								ELSE 
//								END IF
//							END IF
//						END IF
////-------------------  fin  de manejo de par$$HEX1$$e100$$ENDHEX$$metros asociadas a la fila detalle  ---------------------------//
//
//
//
//
//
////-------------------  inicio  de manejo de par$$HEX1$$e100$$ENDHEX$$metros asociadas a la fila detalle  ---------------------------//
//						//hacer retrieve de dw_detalle.
//						ll_hallados = dw_detalle.Retrieve(li_co_fabrica_modu,li_co_planta_modu,li_simulacion)					
//						IF isnull(ll_hallados) THEN
//							MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//						ELSE
//							CHOOSE CASE ll_hallados
//								CASE -1
//									il_fila_actual_detalle = -1
//									MessageBox("Error buscando","Error de la base",StopSign!,Ok!)
//								CASE 0
//									il_fila_actual_detalle = 0
//								CASE ELSE
//									il_fila_actual_detalle = 1
//							END CHOOSE
//						END IF
////-------------------  fin de manejo de par$$HEX1$$e100$$ENDHEX$$metros asociadas a la fila detalle  ---------------------------//
//
//
//					ELSE
//					END IF
//
//				END IF
//			ELSE
//				MessageBox("Advertencia","No trajo datos para insertar detalle",Exclamation!,OK!)				
//			END IF
//		END IF
//	END IF
//ELSE
//	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
//END IF
//
//
end event

event ue_grabar;///////////////////////////////////////////////////////////////////////
//// En este evento se realiza el ACCEPTTEXT para llevar los
//// datos al buffer. El UPDATE() para preparar los datos a grabar y
//// el COMMIT, para grabar los cambios en la base de datos
///////////////////////////////////////////////////////////////////////
//
//Long li_return
//Long ll_fila,ll_num_reg,ll_co_estado_asigna,ll_cs_liberacion,ll_cs_prioridad,ll_cs_asignacion
//String ls_po,ls_gpa,ls_referencia,ls_color,ls_body
//Datetime ldt_fe_ini_prog,ldt_fe_fin_prog
//
//is_accion = "si update"	
////////////////////////////////////////////////////////////////////////////
//// En este evento se realizar ACCEPTTEXT para llevar los cambios 
//// del detalle al buffer.
//// El  UPDATE para preparar los datos en el servidor.
//// El  COMMIT para grabar los cambios en la base de datos
////////////////////////////////////////////////////////////////////////////
//
//IF is_accion = "si update" THEN
//	IF dw_detalle.AcceptText() = -1 THEN
//		is_accion = "no accepttext"
//		Messagebox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
//		RETURN
//	ELSE
//		IF dw_detalle.Update() = -1 THEN
//			is_accion = "no update"
//			ROLLBACK;
//			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
//			RETURN
//		ELSE
//			IF sw_estado = 0 THEN
//				is_accion = "si update"
//				IF SQLCA.SQLCode = -1 THEN
//					is_grabada = "no"
//					MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
//									,Exclamation!,Ok!)	
//				ELSE
//					is_grabada = "si"
//					dw_detalle.Retrieve(91,1,1)
//				END IF
//			ELSE//sw_estado = 0
//				rollback;	
//				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
//				dw_detalle.Retrieve(91,1,1)
//				RETURN	
//			END IF//sw_estado = 0
//		END IF
//	END IF
//END IF
//
//COMMIT;
//Return
//
//
//
end event

event ue_insertar_maestro;/////////////////////////////////////////////////////////////////////////
//// En este evento se detecta si hubo cambios en el datawindow, para 
//// asignar valores a las variables de instancia is_cambio y is_accion.
////
//// Ademas, se inserta una nueva linea, se le evalua el insert y si fue
//// exitoso, se posiciona en dicha fila,hace el scroll a dicha fila y
//// se posiciona en la primera columna de esta fila.
//////////////////////////////////////////////////////////////////////////
//
//Long ll_fila
//DateTime ldt_fechahora
//
//CHOOSE CASE wf_detectar_cambios (dw_maestro)
//	CASE -1
//		is_cambios = "error"
//		is_accion = "nada"
//		RETURN
//	CASE 0
//		is_cambios = "no"
//		is_accion = "nada"
//		//No ejecuta ninguna accion
//	CASE 1
//		is_cambios = "si"	
//		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios en el maestro",Question!,YesNoCancel!)
//			CASE 1
//				is_accion = "grabo"
//				This.TriggerEvent("ue_grabar")
//			CASE 2
//				dw_maestro.Reset()
//				is_accion = "no grabo"
//				// NO GRABA Y SIGUE LA INSERCION
//			CASE 3
//				is_accion = "cancelo"
//				RETURN
//		END CHOOSE
//END CHOOSE
//
//dw_maestro.Reset()
//ll_fila = dw_maestro.InsertRow(0)
//IF ll_fila = -1 THEN
//	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
//ELSE
//	dw_maestro.SetRow(ll_fila)
//	dw_maestro.ScrollToRow(ll_fila)
//	dw_maestro.SetColumn(1)
//	dw_maestro.SelectRow(0,False)
//	il_fila_actual_maestro = ll_fila
//	ldt_fechahora=DateTime(today(), Now())
//END IF
//
//////////////////////////////////////////////////////////////////////////
//// Se omite el script del papa.
//// Se adicionan las lineas necesarias para insertar un registro 
//// en el maestro.
/////////////////////////////////////////////////////////////////////////
//
//Long ll_resultado
//
///////////////////////////////////////////////////////////////////////////
//// En el siguiente CHOOSE CASE se esta verificando si hubo cambios en el 
//// Detalle.
///////////////////////////////////////////////////////////////////////////
//
//CHOOSE CASE wf_detectar_cambios (dw_detalle)
//	CASE -1
//		is_cambios = "error"
//		is_accion = "nada"
//		message.returnvalue = 1
//		RETURN
//	CASE 0
//		is_cambios = "no"
//		is_accion = "nada"
//		// No ejecuta ninguna accion
//	CASE 1
//		is_cambios = "si"
//		CHOOSE CASE MessageBox("Cambios detectados en el detalle...",&
// 	               "Desea grabar los cambios del maestro y el detalle",&
//               	 Question!,YesNoCancel!)
//			CASE 1
//				is_accion = "grabo"
//				This.TriggerEvent("ue_grabar")
//			CASE 2
//				is_accion = "no grabo"
//				// no graba y se sale
//			CASE 3
//				is_accion = "cancelo"
//				message.returnvalue = 1
//				RETURN
//		END CHOOSE
//END CHOOSE
//
//IF (is_cambios = "no" AND is_accion = "nada") OR &
//	(is_cambios = "si" AND is_accion <> "cancelo") THEN
//	
//	Return ll_resultado
//END IF
//
end event

event open;TRANSACTION			itr_tela
STRING	ls_instruccion

This.X = 1
This.Y = 1
This.width = 3639
This.height = 2008

itr_tela 				= 	Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

sw_estado = 0

//------------------------ recupera modulo con fabrica 91, planta 1
f_rcpra_dtos_dddw_param1(dw_detalle, "co_modulo", itr_tela, 91, 1)

//------------------------ retrieve del detalle

dw_detalle.SetTransObject(itr_tela)
dw_maestro.SetTransObject(itr_tela)

dw_detalle.Retrieve(91,1,1)
il_fila_actual_maestro = 1

//------------------------ retrieve del maestro
dw_maestro.Retrieve()

//-------------inhabilita y coloca invisible la particion
m_mantenimiento_asignacion_modulos.m_edicion.m_partirescala.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_partirescala.toolbaritemvisible = False
//-------------coloca visible y disponible fecha requisito
m_mantenimiento_asignacion_modulos.m_edicion.m_fecharequisito.visible = True
m_mantenimiento_asignacion_modulos.m_edicion.m_fecharequisito.toolbaritemvisible = True
//-------------coloca visible y disponible agrupar
m_mantenimiento_asignacion_modulos.m_edicion.m_agrupar.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_agrupar.toolbaritemvisible = False
//-------------coloca invisible el parametro de fecha
m_mantenimiento_asignacion_modulos.m_edicion.m_parmetrosasignaci$$HEX1$$f300$$ENDHEX$$n.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_parmetrosasignaci$$HEX1$$f300$$ENDHEX$$n.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_buscar.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_buscar.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_insertardetalle.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_insertardetalle.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_borrardetalle.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_borrardetalle.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_recalcular.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_recalcular.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_reporte102.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_reporte102.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_observaciones.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_observaciones.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_liquidadas.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_liquidadas.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_repriorizar.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_repriorizar.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_archivo.m_grabar.visible = False
m_mantenimiento_asignacion_modulos.m_archivo.m_grabar.toolbaritemvisible = False

m_mantenimiento_asignacion_modulos.m_edicion.m_escalasdeasignaci$$HEX1$$f300$$ENDHEX$$n.visible = False
m_mantenimiento_asignacion_modulos.m_edicion.m_escalasdeasignaci$$HEX1$$f300$$ENDHEX$$n.toolbaritemvisible = False

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_detalle.SetTransObject(sqlca)
dw_maestro.SetTransObject(sqlca)
This.WindowState = Maximized!


end event

event ue_borrar_detalle;Long 					ll_fila,ll_i
DateTime 			ldt_fechahora
Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
s_base_parametros lstr_parametros
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_sqlerr

LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,ll_asignaciones
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog, ldt_fe_desp_prog, ldt_fe_entrada_pdn
DECIMAL				ld_ca_minutos_std, ld_minutos_jornada

Long 				li_cs_prioridad,li_cs_prioridad_ciclo
LONG					ll_unidades_empate, ll_ca_unid_base_dia


//------------------------ abre relojito -------------------------//
SetPointer(HourGlass!)

//------------------------ obtiene fila a borrar
ll_fila = dw_detalle.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			li_simulacion 				= dw_detalle.GetitemNumber(il_fila_actual_detalle,"simulacion")
			li_co_fabrica_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
			li_co_planta_modu 		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_planta")
			li_co_modulo 				= dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_modulo")
				
			li_co_fabrica_exp  	   =dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica_exp")  
			ll_pedido               =dw_detalle.GetitemNumber(il_fila_actual_detalle,"pedido")   
			ll_cs_liberacion        =dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_liberacion")   
			ls_nu_orden			      =dw_detalle.GetitemString(il_fila_actual_detalle,"po")   
			li_co_fabrica_ref       =dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica_pt")   
			li_co_linea_ref       	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_linea")   
			ll_co_referencia       	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_referencia")   
			ll_color_pt       		=dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_color_pt")   
			ls_tono       				=dw_detalle.GetitemString(il_fila_actual_detalle,"tono")   
			li_cs_estilocolton   	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_estilocolortono")   
			li_cs_particion       	=dw_detalle.GetitemNumber(il_fila_actual_detalle,"cs_particion")     
			//borrar de dt_talla_pdnmodulo
			DELETE FROM dt_talla_pdnmodulo  
			WHERE ( dt_talla_pdnmodulo.simulacion 				= :li_simulacion ) 			AND  
					( dt_talla_pdnmodulo.co_fabrica 				= :li_co_fabrica_modu ) 	AND  
					( dt_talla_pdnmodulo.co_planta 				= :li_co_planta_modu ) 		AND  
					( dt_talla_pdnmodulo.co_modulo 				= :li_co_modulo ) 			AND  
					( dt_talla_pdnmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) 		AND  
					( dt_talla_pdnmodulo.pedido 					= :ll_pedido ) 				AND  
					( dt_talla_pdnmodulo.cs_liberacion 			= :ll_cs_liberacion ) 		AND  
					( dt_talla_pdnmodulo.po 						= :ls_nu_orden ) 				AND  
					( dt_talla_pdnmodulo.co_fabrica_pt 			= :li_co_fabrica_ref ) 		AND  
					( dt_talla_pdnmodulo.co_linea 				= :li_co_linea_ref ) 		AND  
					( dt_talla_pdnmodulo.co_referencia 			= :ll_co_referencia ) 		AND  
					( dt_talla_pdnmodulo.co_color_pt 			= :ll_color_pt ) 				AND  
					( dt_talla_pdnmodulo.tono 						= :ls_tono ) 					AND  
					( dt_talla_pdnmodulo.cs_estilocolortono 	= :li_cs_estilocolton ) 	AND  
					( dt_talla_pdnmodulo.cs_particion 			= :li_cs_particion )		  ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo borrar las escalas asociadas a esta asignaci$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
				RETURN
			ELSE
			END IF

			
			//borrar de dt_programa_diario
			DELETE FROM dt_programa_diario  
			WHERE ( dt_programa_diario.simulacion 				= :li_simulacion ) AND  
					( dt_programa_diario.co_fabrica 				= :li_co_fabrica_modu ) AND  
					( dt_programa_diario.co_planta 				= :li_co_planta_modu ) AND  
					( dt_programa_diario.co_modulo 				= :li_co_modulo ) AND
					( dt_programa_diario.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
					( dt_programa_diario.pedido 					= :ll_pedido ) AND  
					( dt_programa_diario.cs_liberacion 			= :ll_cs_liberacion ) AND  
					( dt_programa_diario.po 						= :ls_nu_orden ) AND  
					( dt_programa_diario.co_fabrica_pt 			= :li_co_fabrica_ref ) AND  
					( dt_programa_diario.co_linea 				= :li_co_linea_ref ) AND  
					( dt_programa_diario.co_referencia 			= :ll_co_referencia ) AND  
					( dt_programa_diario.co_color_pt 			= :ll_color_pt ) AND  
					( dt_programa_diario.tono 						= :ls_tono ) AND  
					( dt_programa_diario.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
					( dt_programa_diario.cs_particion 			= :li_cs_particion )   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo borrar los par$$HEX1$$e100$$ENDHEX$$metros de esta asignaci$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
				RETURN
			ELSE
			END IF
			
			
			//borrar de dt_procesos_plan
			DELETE FROM dt_procesos_plan  
			WHERE ( simulacion 				= :li_simulacion ) AND  
					( co_fabrica 				= :li_co_fabrica_modu ) AND  
					( co_planta 				= :li_co_planta_modu ) AND  
					( co_modulo 				= :li_co_modulo ) AND
					( co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
					( pedido 					= :ll_pedido ) AND  
					( cs_liberacion 			= :ll_cs_liberacion ) AND  
					( po 						= :ls_nu_orden ) AND  
					( co_fabrica_pt 			= :li_co_fabrica_ref ) AND  
					( co_linea 				= :li_co_linea_ref ) AND  
					( co_referencia 			= :ll_co_referencia ) AND  
					( co_color_pt 			= :ll_color_pt ) AND  
					( tono 						= :ls_tono ) AND  
					( cs_estilocolortono 	= :li_cs_estilocolton ) AND  
					( cs_particion 			= :li_cs_particion )   ;
					
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				MessageBox("Error Base datos","No pudo borrar los procesos.~n~n~nNota: " + ls_sqlerr)
				Return
			End If
			
			//borrar de requisitos
			DELETE FROM dt_requisitosxpdn  
			WHERE ( simulacion 				= :li_simulacion ) AND  
					( co_fabrica 				= :li_co_fabrica_modu ) AND  
					( co_planta 				= :li_co_planta_modu ) AND  
					( co_modulo 				= :li_co_modulo ) AND
					( co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
					( pedido 					= :ll_pedido ) AND  
					( cs_liberacion 			= :ll_cs_liberacion ) AND  
					( po 						= :ls_nu_orden ) AND  
					( co_fabrica_pt 			= :li_co_fabrica_ref ) AND  
					( co_linea 				= :li_co_linea_ref ) AND  
					( co_referencia 			= :ll_co_referencia ) AND  
					( co_color_pt 			= :ll_color_pt ) AND  
					( tono 						= :ls_tono ) AND  
					( cs_estilocolortono 	= :li_cs_estilocolton ) AND  
					( cs_particion 			= :li_cs_particion )   ;
					
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				MessageBox("Error Base datos","No pudo borrar los requisitos.~n~n~nNota: " + ls_sqlerr)
				Return
			End If
			
			
			DELETE FROM mv_pdnxmodulo
			WHERE ( simulacion 				= :li_simulacion ) AND  
					( co_fabrica 				= :li_co_fabrica_modu ) AND  
					( co_planta 				= :li_co_planta_modu ) AND  
					( co_modulo 				= :li_co_modulo ) AND
					( co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
					( pedido 					= :ll_pedido ) AND  
					( cs_liberacion 			= :ll_cs_liberacion ) AND  
					( po 						= :ls_nu_orden ) AND  
					( co_fabrica_pt 			= :li_co_fabrica_ref ) AND  
					( co_linea 				= :li_co_linea_ref ) AND  
					( co_referencia 			= :ll_co_referencia ) AND  
					( co_color_pt 			= :ll_color_pt ) AND  
					( tono 						= :ls_tono ) AND  
					( cs_estilocolortono 	= :li_cs_estilocolton ) AND  
					( cs_particion 			= :li_cs_particion )   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo borrar los par$$HEX1$$e100$$ENDHEX$$metros de esta asignaci$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
				RETURN
			ELSE
			END IF
			
			DELETE FROM dt_observaxmodulo
			WHERE ( simulacion 				= :li_simulacion ) AND  
					( co_fabrica 				= :li_co_fabrica_modu ) AND  
					( co_planta 				= :li_co_planta_modu ) AND  
					( co_modulo 				= :li_co_modulo ) AND
					( co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
					( pedido 					= :ll_pedido ) AND  
					( cs_liberacion 			= :ll_cs_liberacion ) AND  
					( po 						= :ls_nu_orden ) AND  
					( co_fabrica_pt 			= :li_co_fabrica_ref ) AND  
					( co_linea 				= :li_co_linea_ref ) AND  
					( co_referencia 			= :ll_co_referencia ) AND  
					( co_color_pt 			= :ll_color_pt ) AND  
					( tono 						= :ls_tono ) AND  
					( cs_estilocolortono 	= :li_cs_estilocolton ) AND  
					( cs_particion 			= :li_cs_particion )   ;
			IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base datos","No pudo borrar las observaciones de esta asignaci$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
				RETURN
			ELSE
			END IF

			IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
				rollback  ;
				Return
			ELSE
				il_fila_actual_detalle = ll_fila
				
				For ll_i = il_fila_actual_detalle To dw_detalle.RowCount()
					dw_detalle.SetItem(ll_i,"cs_prioridad",ll_i)     
				Next
			
				If dw_detalle.Update() = -1 Then
					MessageBox("Error Base datos","No pudo borrar los par$$HEX1$$e100$$ENDHEX$$metros de esta asignaci$$HEX1$$f300$$ENDHEX$$n")
					ROLLBACK;
					RETURN
				End IF
				
//				This.Triggerevent("ue_recalcular")
				ii_borrando_detalle=1
				f_actualizar_prioridades(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo)
				
				This.TriggerEvent("ue_grabar")
				ii_borrando_detalle=0
			END IF
		ELSE
		END IF
	
	
END CHOOSE




end event

event closequery;//Long Net,li_return
//
//IF ii_repriorizar = 1 THEN
//	Net = MessageBox('Error','Realmente desea salir de la aplicaci$$HEX1$$f300$$ENDHEX$$n sin haber recalculado fechas' , Exclamation!, YesNoCancel!, 2)
//	IF Net = 1 THEN
//	ELSE
//		Message.returnvalue = 1
//		Return
//	
//	END IF
//END IF
//
//CHOOSE CASE wf_detectar_cambios (dw_maestro)
//	CASE -1
//		is_cambios = "error"
//		is_accion = "nada"
//		message.returnvalue = 1
//		RETURN
//	CASE 0
//		is_cambios = "no"
//		is_accion = "nada"
//		// No ejecuta ninguna accion
//	CASE 1
//		is_cambios = "si"
//		CHOOSE CASE MessageBox("Cambios detectados ", "Desea grabar los cambios del maestro",Question!,YesNoCancel!)
//			CASE 1
//				is_accion = "grabo"
//				This.TriggerEvent("ue_grabar")
//			CASE 2
//				is_accion = "no grabo"
//				// no graba y se sale
//			CASE 3
//				is_accion = "cancelo"
//				message.returnvalue = 1
//				RETURN
//		END CHOOSE
//END CHOOSE
//
//
//IF (is_cambios = "no") OR (is_cambios = "si" AND is_accion = "no grabo") THEN
//	CHOOSE CASE wf_detectar_cambios (dw_detalle)
//		CASE -1
//			is_cambios = "error"
//			is_accion = "nada"
//			message.returnvalue = 1
//			RETURN
//		CASE 0
//			is_cambios = "no"
//			is_accion = "nada"
//			// No ejecuta ninguna accion
//		CASE 1
//			is_cambios = "si"
//			CHOOSE CASE MessageBox("Cambios detectados en el detalle...",&
//					                 "Desea grabar los cambios del maestro y el detalle",Question!,yesnocancel!,1)
//				CASE 1
//					is_accion = "grabo"
//					This.TriggerEvent("ue_grabar")
//				CASE 2
//					is_accion = "no grabo"
//					// no graba y se sale
//				CASE 3
//					is_accion = "cancelo"
//					message.returnvalue = 1
//					RETURN
//			END CHOOSE
//	END CHOOSE
//ELSE
//END IF
//
////carga los datos en dt_telasxoc, para posibilitar la mercada de telas
//
//IF wf_insert_dt_telasxoc() = -1 THEN
//	ROLLBACK;
//	MessageBox("Error","No se pudo hacer los cambios en dt_telasxoc",Exclamation!,Ok!)
//	Return
//ELSE
//	COMMIT;
//	Return
//END IF
//
//
end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_fechas_requisito_independiente
integer x = 50
integer y = 52
integer width = 2729
integer height = 204
boolean titlebar = false
string title = "Maestro de m$$HEX1$$f300$$ENDHEX$$dulos"
string dataobject = "d_modulos_asignacion_corte"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_maestro::itemchanged;DateTime ldt_fechahora

end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_fechas_requisito_independiente
integer x = 5
integer y = 324
integer width = 3707
integer height = 1404
boolean titlebar = false
string title = "Detalle de Asignaciones "
string dataobject = "dtb_fechas_independientes"
boolean border = false
boolean hsplitscroll = false
end type

event dw_detalle::itemchanged;//Long	 			li_co_fabrica_modu,li_co_planta_modu,li_simulacion
//Long				li_co_fabrica_ref,li_co_linea_ref
//Long				li_cs_estilocolton
//Long				li_prior_mayores,li_cs_max_prioridad,li_rpta,li_cs_prioridad_ciclo,li_co_tipo_asignacion_inicial
//Long				li_cs_prioridad_actual, li_cs_prioridad_leida
//Long				li_inicio, li_fin, li_indice,ll_num_reg,li_origen_uni_base_dia
//LONG 					li_secuencia,ll_cs_propiedad,ll_co_est_prog_talla,ll_fuente_dato,ll_dia_curva,&
//						ll_ca_pendiente,ll_ca_base_dia_prod,ll_ca_base_dia_prog,ll_ca_a_programar
//Long				ll_ca_unidadesxtalla,li_ca_producida,ll_ca_numerada,ldc_cnt,ldc_pendiente,ll_co_est_prog_dia
//Long     ll_i,ll_j,ll_pedido,ll_ref,ll_result,ll_flfnd,ll_programado,ll_duracion,ll_undpsb
//Long  li_fabexp,li_cslib,li_fabpt,li_lin,li_col,li_csest,li_cspar,li_estilo,li_ca_proyectada,li_ca_actual,li_ca_numerada,&
//         li_tpprod,li_centro,li_subcentro,li_proceso,li_secuenc,ll_ca_proyectada,ll_ca_actual
//String   ls_sqlerr
//
//LONG					ll_fila,ll_hallados,ll_rpta,ll_incremento,ll_nuenqueesta,ll_cs_agrupacion,ll_numero_agrupa,ll_modulo_viejo
//LONG					ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po,ll_planta,ll_fabrica,ll_simulacion
//LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia,ll_co_modulo_fila
//LONG					li_unidades_empate,ll_ca_unid_base_dia,ll_co_fabrica_exp,ll_co_fabrica_pt,ll_find,ll_estado_asigna
//LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin,ll_co_linea,ll_co_modulo
//LONG					ll_personasxmodulo,ll_ca_unid_posibles,ll_unidades_empate,ll_co_color_pt,ll_cs_estilocolortono,&
//						ll_co_metodo_programa,ll_co_consumo_proceso,ll_unidad_consum_est,ll_unidade_consum_std,ll_agrupa
//DateTime 			ldt_fe_desp_prog,ldt_fe_entrada_pdn,ldt_fecha_final,ldt_fecha_inicial
//DATETIME				ldt_inicio,ldt_fin
//						
//DATE					ldt_fe_despacho_allocation
//
//STRING				ls_gpa,ls_nu_orden,ls_tipo_pedido,ls_aprueba,ls_expresion,ls_de_referencia,ls_de_color,ls_usuario,ls_instancia
//STRING				ls_co_estado_merc
//DECIMAL				ld_ca_min_dispon_ini,ld_porc_eficiencia,&
//						ldc_mindspini,ldc_mindspfn,ldc_min
//Long		li_co_fabrica,li_co_planta,li_co_modulo,li_co_fabrica_exp,li_co_fabrica_pt,li_co_linea
//Long		li_cs_estilocolortono,li_cs_particion,li_cs_prioridad,li_co_estado_asigna,li_co_curva
//Long		li_co_tipo_asignacion,li_ca_personasxmod,li_cod_tur,li_ind_cambio_estilo
//Long		li_tipo_empate,li_metodo_programa,li_tipo_fe_prog,li_indicativo_base,li_fuente_dato
//Long		li_co_talla,li_cs_orden_talla,li_talla_cs_prioridad
//Long		li_co_est_prog_talla,li_cs_fechas,li_co_est_prog_dia, li_registros
//
//DECIMAL		ldc_ca_minutos_std,ldc_minutos_jornada,ldc_ca_min_dispon_ini,ldc_ca_min_dispon_fin,ldc_porc_eficiencia
//
//DATETIME		ldt_fe_inicio_prog,ldt_fe_fin_prog, ldt_fe_requerida_desp,ldt_fe_entra_pdn,ldt_fe_lim_prog
//DATETIME		ldt_fe_desp_programada,ldt_fe_creacion,ldt_fe_actualizacion,ldt_fechahora,ldt_fe_inicio
//DATETIME		ldt_fe_fin 
//
//STRING		ls_po,ls_tono
//// Parametros de Proceso
//Long		li_simulacion_origen,li_simulacion_destino, li_fabrica, li_planta, li_modulo, li_empleados
//DECIMAL		ld_minutos_jornada
//
//s_base_parametros lstr_parametro
//
//Long li_prdact,li_prdnue,ll_filas,ll_modulo1,ll_modulo2,ll_count,ll_estado_asigna2,ll_estado_asigna3,ll_modulo
//
//
//Long li_fabricaexp,li_fabricapt,li_linea,li_estado,li_tipo
//Long ll_referencia,ll_colorpt,ll_cs_estilo,ll_cs_requisito,ll_co_requisito,ll_co_proveedor,ll_co_proceso,ll_cs_particion,&
//		ll_estado,ll_area,ll_cs_observacion,ll_asignacion,ll_agrupacion,ll_agrupa_des
//Datetime ldt_fe_entrega_prog,ldt_fe_entrega_real
//String ls_observacion
//
//SetPointer(Hourglass!)
//
////PARA EL CAMBIO DEL M$$HEX1$$d300$$ENDHEX$$DULO
//IF dwo.Name = 'co_modulo' Then
//	
//	//Al presentarse un cambio de m$$HEX1$$f300$$ENDHEX$$dulo se deben eliminar los registros del modulo viejo y insertar estos 
//	//registros con el nuevo m$$HEX1$$f300$$ENDHEX$$dulo en las siguientes tablas,
//	//dt_requisitosxpdn, mv_pdnxmodulo, dt_programa_diario, dt_procesos_plan, dt_talla_pdnmodulo,
//	//dt_observaxmodulo y dt_pdnxmodulo, luego se debe colocar la prioridad en la que debe quedar
//	//el nuevo registro y reordenar los m$$HEX1$$f300$$ENDHEX$$dulos afectados
//	
//	li_estado = This.GetItemNumber(row,'co_estado_asigna')
//
//	IF li_estado < 11 THEN
//	ELSE
//		MessageBox('Advertencia','El estado en el que se encuentra la O.C. no permite el cambio de area')
//		RETURN -1
//	END IF
//	ll_co_modulo = long(data)
//	
//	ll_agrupacion = dw_detalle.getItemNumber(row,'dt_agrupa_pdn_cs_agrupacion')
//	dw_detalle.SelectRow(0, FALSE)
//	dw_detalle.SelectRow(row,True)
//	
//	For ll_i = 1 To dw_detalle.rowCount()
//		If ll_i = row Then
//		Else 
//			If ll_agrupacion = dw_detalle.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion') Then
//				dw_detalle.SelectRow(ll_i,True)
//			End if
//		End if
//	Next
//	
//	This.SelectRow(row, TRUE)
//		
//	For ll_i = 1 To dw_detalle.RowCount()
//		If Isselected (ll_i) = True Then
////			ll_i = row
//			ll_planta 			= dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_planta")
//			ll_fabrica 			= dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_fabrica")
//			ll_simulacion 		= dw_detalle.GetitemNumber(ll_i,"simulacion")
//			ll_modulo_viejo 	= dw_detalle.GetitemNumber(ll_i,"co_modulo")
//			li_fabexp 			= dw_detalle.GetitemNumber(ll_i,"co_fabrica_exp")  
//			ll_pedido 			= dw_detalle.GetitemNumber(ll_i,"pedido")   
//			li_cslib  			= dw_detalle.GetitemNumber(ll_i,"cs_liberacion")   
//			ls_po     			= dw_detalle.GetitemString(ll_i,"po")   
//			li_fabpt  			= dw_detalle.GetitemNumber(ll_i,"co_fabrica_pt")   
//			li_lin    			= dw_detalle.GetitemNumber(ll_i,"co_linea")   
//			ll_ref    			= dw_detalle.GetitemNumber(ll_i,"co_referencia")   
//			li_col    			= dw_detalle.GetitemNumber(ll_i,"co_color_pt")   
//			ls_tono   			= dw_detalle.GetitemString(ll_i,"tono")   
//			li_csest  			= dw_detalle.GetitemNumber(ll_i,"cs_estilocolortono")   
//			li_cspar	 			= dw_detalle.GetitemNumber(ll_i,"cs_particion")
//			
//			
//			ls_expresion = "co_fabrica_exp = " + String(li_fabexp) + " and pedido = " + String(ll_pedido) + " and cs_liberacion = " &
//								+ String(li_cslib) +  " and po = '" + ls_po + "'" + " and co_fabrica_pt = " + String(li_fabpt) +&
//								" and co_linea = " + String(li_lin) + " and co_referencia = " + String(ll_ref) + &
//								" and co_color_pt = " + String(li_col) + " and tono = '" + ls_tono + "'" + &
//								" and cs_estilocolortono = " +String(li_csest)+ " and simulacion = " + String(ll_simulacion) + &
//								" and co_fabrica = " + String(ll_fabrica) + " and co_planta = " + String(ll_planta) + &
//								" and co_modulo = " + String(ll_co_modulo) + " and cs_particion = " + String(li_cspar)
//								
//			SELECT pedido_po,cs_prioridad,ca_programada,ca_producida,ca_pendiente,co_estado_asigna,   
//					co_curva,fe_inicio_prog,fe_fin_prog,fe_requerida_desp,ca_minutos_std,co_tipo_asignacion,   
//					ca_personasxmod,cod_tur,minutos_jornada,ind_cambio_estilo,ca_unid_base_dia,   
//					orige_uni_base_dia,tipo_empate,unidades_empate,metodo_programa,fe_entra_pdn,   
//					tipo_fe_prog,fe_lim_prog,fe_desp_programada,indicativo_base,ca_base_dia_prod,   
//					ca_base_dia_prog,ca_a_programar,cs_asignacion  
//			INTO :ll_pedido_po,:li_cs_prioridad,:ll_ca_programada,:ll_ca_producida,:ll_ca_pendiente,   
//					:li_co_estado_asigna,:li_co_curva,:ldt_fe_inicio_prog,:ldt_fe_fin_prog,   
//					:ldt_fe_requerida_desp,:ldc_ca_minutos_std,:li_co_tipo_asignacion,:li_ca_personasxmod,   
//					:li_cod_tur,:ldc_minutos_jornada,:li_ind_cambio_estilo,:ll_ca_unid_base_dia,   
//					:li_origen_uni_base_dia,:li_tipo_empate,:ll_unidades_empate,:li_metodo_programa,   
//					:ldt_fe_entra_pdn,:li_tipo_fe_prog,:ldt_fe_lim_prog,:ldt_fe_desp_programada,   
//					:li_indicativo_base,:ll_ca_base_dia_prod,:ll_ca_base_dia_prog,:ll_ca_a_programar,:ll_asignacion 
//			FROM dt_pdnxmodulo  
//			WHERE simulacion 				= :ll_simulacion AND
//					 co_fabrica 			= :ll_fabrica AND
//					 co_planta 				= :ll_planta AND
//					 co_modulo 				= :ll_modulo_viejo AND  
//					 co_fabrica_exp 		= :li_fabexp AND
//					 pedido 					= :ll_pedido AND  
//					 cs_liberacion 		= :li_cslib AND 
//					 po 						= :ls_po AND 
//					 co_fabrica_pt 		= :li_fabpt AND
//					 co_linea 				= :li_lin AND 
//					 co_referencia 		= :ll_ref AND 
//					 co_color_pt 			= :li_col AND 
//					 tono 					= :ls_tono AND
//					 cs_estilocolortono 	= :li_csest AND
//					 cs_particion 			= :li_cspar   ;
//		
//		 INSERT INTO dt_pdnxmodulo 
//					( simulacion,co_fabrica,co_planta,co_modulo,co_fabrica_exp,pedido,cs_liberacion,   
//					  po,co_fabrica_pt,co_linea,co_referencia,co_color_pt,tono,cs_estilocolortono,   
//					  cs_particion,pedido_po,cs_prioridad,ca_programada,ca_producida,ca_pendiente,   
//					  co_estado_asigna,co_curva,fe_inicio_prog,fe_fin_prog,fe_requerida_desp,   
//					  ca_minutos_std,co_tipo_asignacion,ca_personasxmod,cod_tur,minutos_jornada,   
//					  ind_cambio_estilo,ca_unid_base_dia,orige_uni_base_dia,tipo_empate,unidades_empate,   
//					  metodo_programa,fuente_dato,fe_creacion,fe_actualizacion,usuario,instancia,   
//					  fe_entra_pdn,tipo_fe_prog,fe_lim_prog,fe_desp_programada,indicativo_base,   
//					  ca_base_dia_prod,ca_base_dia_prog,ca_a_programar,cs_asignacion )  
//		  VALUES ( :ll_simulacion,:ll_fabrica,:ll_planta,:ll_co_modulo,:li_fabexp,   
//					  :ll_pedido,:li_cslib,:ls_po,:li_fabpt,:li_lin,:ll_ref,   
//					  :li_col,:ls_tono,:li_csest,:li_cspar,:ll_pedido_po,   
//					  999,:ll_ca_programada,:ll_ca_producida,:ll_ca_pendiente,:li_co_estado_asigna,   
//					  :li_co_curva,:ldt_fe_inicio_prog,:ldt_fe_fin_prog,:ldt_fe_requerida_desp,   
//					  :ldc_ca_minutos_std,:li_co_tipo_asignacion,:li_ca_personasxmod,:li_cod_tur,   
//					  :ldc_minutos_jornada,:li_ind_cambio_estilo,:ll_ca_unid_base_dia,:li_origen_uni_base_dia,   
//					  :li_tipo_empate,:ll_unidades_empate,:li_metodo_programa,:li_fuente_dato,   
//					  :ldt_fe_creacion,:ldt_fe_actualizacion,:gstr_info_usuario.codigo_usuario,   
//					  :gstr_info_usuario.instancia,:ldt_fe_entra_pdn,:li_tipo_fe_prog,:ldt_fe_lim_prog,   
//					  :ldt_fe_desp_programada,:li_indicativo_base,:ll_ca_base_dia_prod,:ll_ca_base_dia_prog,   
//					  :ll_ca_a_programar,:ll_asignacion )  ;
//			IF SQLCA.SQLCODE=-1 THEN
//				Close(w_retroalimentacion)
//				MessageBox("Error Base Datos","No pudo insertar en dt_pdnxmodulo")
//				RETURN
//			ELSE
//			END IF
//			
////			DECLARE cur_requisitos CURSOR FOR
////			SELECT simulacion,co_fabrica,co_planta,co_fabrica_exp,pedido,cs_liberacion,po,   
////					co_fabrica_pt,co_linea,co_referencia,co_color_pt,tono,cs_estilocolortono,cs_particion,   
////					cs_requisito,co_requisito,co_proveedor_req,co_proceso,co_estado,fe_entrega_prog,   
////					fe_entrega_real,fe_creacion,fe_actualizacion,usuario,instancia  
////			 FROM dt_requisitosxpdn
////			 WHERE simulacion 				= :ll_simulacion AND
////						 co_fabrica 			= :ll_fabrica AND
////						 co_planta 				= :ll_planta AND
////						 co_modulo 				= :ll_modulo_viejo AND  
////						 co_fabrica_exp 		= :li_fabexp AND
////						 pedido 					= :ll_pedido AND  
////						 cs_liberacion 		= :li_cslib AND 
////						 po 						= :ls_po AND 
////						 co_fabrica_pt 		= :li_fabpt AND
////						 co_linea 				= :li_lin AND 
////						 co_referencia 		= :ll_ref AND 
////						 co_color_pt 			= :li_col AND 
////						 tono 					= :ls_tono AND
////						 cs_estilocolortono 	= :li_csest AND
////						 cs_particion 			= :li_cspar;
////			OPEN cur_requisitos;
////			
////			IF sqlca.SQLCode = -1 THEN
////				ROLLBACK;
////				MessageBox("Error Base Datos","Error al abrir el cursor")
////				Return(0)
////			END IF
////			FETCH cur_requisitos
////			INTO :li_simulacion,:li_fabrica,:li_planta,:li_fabricaexp,:ll_pedido,:ll_cs_liberacion,:ls_po,:li_fabricapt,
////				  :li_linea,:ll_referencia,:ll_colorpt,:ls_tono,:ll_cs_estilo,:ll_cs_particion,:ll_cs_requisito,:ll_co_requisito
////				  ,:ll_co_proveedor,:ll_co_proceso,:ll_estado,:ldt_fe_entrega_prog,:ldt_fe_entrega_real,:ldt_fe_creacion,
////				  :ldt_fe_actualizacion,:ls_usuario,:ls_instancia;
////					 
////			DO WHILE SQLCA.SQLCode = 0
//				
////				INSERT INTO dt_requisitosxpdn  
////					( simulacion,co_fabrica,co_planta,co_modulo,co_fabrica_exp,pedido,cs_liberacion,po,co_fabrica_pt,   
////					  co_linea,co_referencia,co_color_pt,tono,cs_estilocolortono,cs_particion,cs_requisito,   
////					  co_requisito,co_proveedor_req,co_proceso,co_estado,fe_entrega_prog,fe_entrega_real,   
////					  fe_creacion,fe_actualizacion,usuario,instancia )  
////				VALUES ( :li_simulacion,:li_fabrica,:li_planta,:ll_co_modulo,:li_fabricaexp,:ll_pedido,:ll_cs_liberacion,:ls_po,
////						:li_fabricapt,:li_linea,:ll_referencia,:ll_color_pt,:ls_tono,:ll_cs_estilo,:ll_cs_particion,:ll_cs_requisito,
////						:ll_co_requisito,:ll_co_proveedor,:ll_co_proceso,:ll_estado,:ldt_fe_entrega_prog,:ldt_fe_entrega_real,
////						:ldt_fe_creacion,:ldt_fe_actualizacion,:ls_usuario,:ls_instancia )  ;
////						
////				IF Sqlca.SqlCode = -1 THEN
////					ls_sqlerr = Sqlca.SqlErrText
////					ROLLBACK ;
////					MessageBox("Advertencia!","Hubo un error al insertar los requisitos.~n~n~nNota: " + ls_sqlerr )
////					RETURN -1
////				END IF
//				
////				FETCH cur_requisitos
////				INTO :li_simulacion,:li_fabrica,:li_planta,:li_fabricaexp,:ll_pedido,:ll_cs_liberacion,:ls_po,:li_fabricapt,
////					  :li_linea,:ll_referencia,:ll_colorpt,:ls_tono,:ll_cs_estilo,:ll_cs_particion,:ll_cs_requisito,:ll_co_requisito
////					  ,:ll_co_proveedor,:ll_co_proceso,:ll_estado,:ldt_fe_entrega_prog,:ldt_fe_entrega_real,:ldt_fe_creacion,
////					  :ldt_fe_actualizacion,:ls_usuario,:ls_instancia;
////			LOOP
////		
////			CLOSE cur_requisitos;
//			
//				
//			DELETE FROM  dt_requisitosxpdn 
//			WHERE simulacion 					= :ll_simulacion AND
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND  
//						 co_fabrica_exp 		= :li_fabexp AND
//						 pedido 					= :ll_pedido AND  
//						 cs_liberacion 		= :li_cslib AND 
//						 po 						= :ls_po AND 
//						 co_fabrica_pt 		= :li_fabpt AND
//						 co_linea 				= :li_lin AND 
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND 
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar   ;
//		
//				IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al borrar los requisitos.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//				END IF
//			
//			DELETE FROM  mv_pdnxmodulo 
//			WHERE simulacion 					= :ll_simulacion AND
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND  
//						 co_fabrica_exp 		= :li_fabexp AND
//						 pedido 					= :ll_pedido AND  
//						 cs_liberacion 		= :li_cslib AND 
//						 po 						= :ls_po AND 
//						 co_fabrica_pt 		= :li_fabpt AND
//						 co_linea 				= :li_lin AND 
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND 
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar   ;
//		
//				If Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al borrar los movimientos.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//				END IF
//				
//			
//				
//			
//			DECLARE cur_dt_talla CURSOR FOR
//			SELECT co_talla,cs_orden_talla,cs_prioridad,ca_programada,ca_producida,ca_pendiente,co_est_prog_talla,   
//					 fuente_dato,fe_creacion,fe_actualizacion,usuario,instancia,co_estado_merc,ca_proyectada,
//					 ca_actual,ca_numerada
//			FROM  dt_talla_pdnmodulo
//			WHERE  simulacion 			= :ll_simulacion AND
//					 co_fabrica 			= :ll_fabrica AND
//					 co_planta 				= :ll_planta AND
//					 co_modulo 				= :ll_modulo_viejo AND  
//					 co_fabrica_exp 		= :li_fabexp AND
//					 pedido 					= :ll_pedido AND  
//					 cs_liberacion 		= :li_cslib AND 
//					 po 						= :ls_po AND 
//					 co_fabrica_pt 		= :li_fabpt AND
//					 co_linea 				= :li_lin AND 
//					 co_referencia 		= :ll_ref AND 
//					 co_color_pt 			= :li_col AND 
//					 tono 					= :ls_tono AND
//					 cs_estilocolortono 	= :li_csest AND
//					 cs_particion 			= :li_cspar  
//			USING sqlca;
//			OPEN cur_dt_talla;	
//			IF sqlca.SQLCode = -1 THEN
//				ROLLBACK;
//				MessageBox("Error Base Datos","Error al abrir el cursor")
//				Return(0)
//			END IF
//			FETCH cur_dt_talla 
//			INTO :li_co_talla,:li_secuencia,:ll_cs_propiedad,:ll_ca_unidadesxtalla,   
//					:li_ca_producida,:ll_ca_unidadesxtalla,:ll_co_est_prog_talla,:ll_fuente_dato,:ldt_fe_creacion,:ldt_fe_actualizacion,   
//					:ls_usuario,:ls_instancia,:ls_co_estado_merc,:ll_ca_proyectada,:ll_ca_actual,:ll_ca_numerada;
//					 
//			DO WHILE SQLCA.SQLCode = 0
//				INSERT INTO dt_talla_pdnmodulo  
//						( simulacion,co_fabrica,co_planta,co_modulo,co_fabrica_exp,pedido,cs_liberacion,   
//						  po,co_fabrica_pt,co_linea,co_referencia,co_color_pt,tono,cs_estilocolortono,cs_particion,   
//						  co_talla,cs_orden_talla,cs_prioridad,ca_programada,ca_producida,ca_pendiente,co_est_prog_talla,   
//						  fuente_dato,fe_creacion,fe_actualizacion,usuario,instancia,co_estado_merc,ca_proyectada,
//						  ca_actual,ca_numerada)  
//				 VALUES ( :ll_simulacion,:ll_fabrica,:ll_planta,:ll_co_modulo,   
//						  :li_fabexp,:ll_pedido,:li_cslib,:ls_po,:li_fabpt,:li_lin,:ll_ref,:li_col,:ls_tono,:li_csest,   
//						  :li_cspar,:li_co_talla,:li_secuencia,:ll_cs_propiedad,:ll_ca_unidadesxtalla,   
//						  :li_ca_producida,:ll_ca_unidadesxtalla,:ll_co_est_prog_talla,:ll_fuente_dato,:ldt_fe_creacion,:ldt_fe_actualizacion,   
//						  :ls_usuario,:ls_instancia,:ls_co_estado_merc,:ll_ca_proyectada,:ll_ca_actual,:ll_ca_numerada)  ;					
//				IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al insertar el proceso.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//				END IF
//				FETCH cur_dt_talla 
//				INTO :li_co_talla,:li_secuencia,:ll_cs_propiedad,:ll_ca_unidadesxtalla,   
//					:li_ca_producida,:ll_ca_unidadesxtalla,:ll_co_est_prog_talla,:ll_fuente_dato,:ldt_fe_creacion,:ldt_fe_actualizacion,   
//					:ls_usuario,:ls_instancia,:ls_co_estado_merc,:ll_ca_proyectada,:ll_ca_actual,:ll_ca_numerada;
//			LOOP
//		
//			CLOSE cur_dt_talla;	
//		
//				
//			DECLARE cur_dt_programa CURSOR FOR
//			SELECT cs_fechas,fe_inicio,ca_unid_dispon_ini,   
//					 ca_min_dispon_ini,ca_unid_dispon_fin,ca_min_dispon_fin,personasxmodulo,   
//					 dia_curva,porc_eficiencia,ca_unid_posibles,duracion,fe_fin,ca_programada,   
//					 ca_producida,ca_pendiente,co_est_prog_dia,fuente_dato,fe_creacion,   
//					 fe_actualizacion,usuario,instancia,ca_proyectada,ca_actual,ca_numerada
//			FROM  dt_programa_diario
//			WHERE simulacion 				= :ll_simulacion AND
//					co_fabrica 				= :ll_fabrica AND
//					co_planta 				= :ll_planta AND
//					co_modulo 				= :ll_modulo_viejo AND  
//					co_fabrica_exp 		= :li_fabexp AND
//					pedido 					= :ll_pedido AND  
//					cs_liberacion 			= :li_cslib AND 
//					po 						= :ls_po AND 
//					co_fabrica_pt 			= :li_fabpt AND
//					co_linea 				= :li_lin AND 
//					co_referencia 			= :ll_ref AND 
//					co_color_pt 			= :li_col AND 
//					tono 						= :ls_tono AND
//					cs_estilocolortono 	= :li_csest AND
//					cs_particion 			= :li_cspar	
//			USING sqlca;
//			OPEN cur_dt_programa;	
//			IF sqlca.SQLCode = -1 THEN
//				ROLLBACK;
//				MessageBox("Error Base Datos","Error al abrir el cursor")
//				Return(0)
//			END IF
//			FETCH cur_dt_programa 
//			INTO :li_secuenc,:ldt_inicio,:ldc_cnt,:ldc_mindspini,:ldc_pendiente,   
//				  :ldc_mindspfn,:ll_personasxmodulo,:ll_dia_curva,:ld_porc_eficiencia,:ll_undpsb,:ll_duracion,   
//				  :ldt_fin,:ll_programado,:li_ca_producida,:ll_programado,:ll_co_est_prog_dia,:ll_fuente_dato,:ldt_fe_creacion,:ldt_fe_actualizacion,   
//				  :ls_usuario,:ls_instancia,:li_ca_proyectada,:li_ca_actual,:li_ca_numerada;
//				
//			DO WHILE SQLCA.SQLCode = 0
//				INSERT INTO dt_programa_diario  
//					  ( simulacion,co_fabrica,co_planta,co_modulo,co_fabrica_exp,pedido,   
//						 cs_liberacion,po,co_fabrica_pt,co_linea,co_referencia,co_color_pt,   
//						 tono,cs_estilocolortono,cs_particion,cs_fechas,fe_inicio,ca_unid_dispon_ini,   
//						 ca_min_dispon_ini,ca_unid_dispon_fin,ca_min_dispon_fin,personasxmodulo,   
//						 dia_curva,porc_eficiencia,ca_unid_posibles,duracion,fe_fin,ca_programada,   
//						 ca_producida,ca_pendiente,co_est_prog_dia,fuente_dato,fe_creacion,   
//						 fe_actualizacion,usuario,instancia,ca_proyectada,ca_actual,ca_numerada )  
//				 VALUES ( :ll_simulacion,:ll_fabrica,:ll_planta,:ll_co_modulo,:li_fabexp,:ll_pedido,   
//						 :li_cslib,:ls_po,:li_fabpt,:li_lin,:ll_ref,:li_col,:ls_tono,:li_csest,   
//						 :li_cspar,:li_secuenc,:ldt_inicio,:ldc_cnt,:ldc_mindspini,:ldc_pendiente,   
//						 :ldc_mindspfn,0,0,0,:ll_undpsb,:ll_duracion,   
//						 :ldt_fin,:ll_programado,0,:ll_programado,1,1,current,current,   
//						 user,sitename,0,0,0 )  ;
//								 
//				IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al insertar los tiempos.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//				END IF
//				
//				FETCH cur_dt_programa 
//				INTO :li_secuenc,:ldt_inicio,:ldc_cnt,:ldc_mindspini,:ldc_pendiente,   
//				  :ldc_mindspfn,:ll_personasxmodulo,:ll_dia_curva,:ld_porc_eficiencia,:ll_undpsb,:ll_duracion,   
//				  :ldt_fin,:ll_programado,:li_ca_producida,:ll_programado,:ll_co_est_prog_dia,:ll_fuente_dato,:ldt_fe_creacion,:ldt_fe_actualizacion,   
//				  :ls_usuario,:ls_instancia,:li_ca_proyectada,:li_ca_actual,:li_ca_numerada;
//			LOOP
//			CLOSE cur_dt_programa;
//					
//			DELETE FROM  dt_programa_diario  
//			WHERE simulacion 					= :ll_simulacion AND
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND  
//						 co_fabrica_exp 		= :li_fabexp AND
//						 pedido 					= :ll_pedido AND  
//						 cs_liberacion 		= :li_cslib AND 
//						 po 						= :ls_po AND 
//						 co_fabrica_pt 		= :li_fabpt AND
//						 co_linea 				= :li_lin AND 
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND 
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar   ;
//		
//			If Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al borrar los tiempos.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//			END IF
//				
//			DECLARE cur_dt_proceso CURSOR FOR
//			SELECT co_proces,cs_proceso,co_metodo_programa,co_consumo_proceso,ca_consumo_estimad,   
//					 unidad_consum_est,estandar_consumo,unidade_consum_std,fe_creacion,   
//					 fe_actualizacion,usuario,instancia
//			FROM dt_procesos_plan
//			WHERE simulacion 					= :ll_simulacion AND 
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND 
//						 co_fabrica_exp 		= :li_fabexp AND 
//						 pedido 					= :ll_pedido AND
//						 cs_liberacion 		= :li_cslib AND  
//						 po 						= :ls_po AND
//						 co_fabrica_pt 		= :li_fabpt AND 
//						 co_linea 				= :li_lin AND
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar  
//			USING sqlca;
//			OPEN cur_dt_proceso;	
//			IF sqlca.SQLCode = -1 THEN
//				ROLLBACK;
//				MessageBox("Error Base Datos","Error al abrir el cursor")
//				Return(0)
//			END IF
//			FETCH cur_dt_proceso
//			INTO :li_proceso,:li_secuenc,:ll_co_metodo_programa,:ll_co_consumo_proceso,:ldc_cnt,   
//				  :ll_unidad_consum_est,:ldc_min,:ll_unidade_consum_std,:ldt_fe_creacion,:ldt_fe_actualizacion,:ls_usuario,:ls_instancia ;
//		
//			
//			DO WHILE SQLCA.SQLCode = 0
//				INSERT INTO dt_procesos_plan  
//					( simulacion,co_fabrica,co_planta,co_modulo,co_fabrica_exp,   
//					  pedido,cs_liberacion,po,co_fabrica_pt,co_linea,   
//					  co_referencia,co_color_pt,tono,cs_estilocolortono,cs_particion,   
//					  co_proces,cs_proceso,co_metodo_programa,co_consumo_proceso,ca_consumo_estimad,   
//					  unidad_consum_est,estandar_consumo,unidade_consum_std,fe_creacion,   
//					  fe_actualizacion,usuario,instancia )  
//				VALUES ( :ll_simulacion,:ll_fabrica,:ll_planta,:ll_co_modulo,:li_fabexp,   
//					  :ll_pedido,:li_cslib,:ls_po,:li_fabpt,:li_lin,:ll_ref,:li_col,   
//					  :ls_tono,:li_csest,:li_cspar,:li_proceso,:li_secuenc,:ll_co_metodo_programa,:ll_co_consumo_proceso,:ldc_cnt,   
//					  :ll_unidad_consum_est,:ldc_min,:ll_unidade_consum_std,:ldt_fe_creacion,:ldt_fe_actualizacion,:ls_usuario,:ls_instancia )  ;
//					
//				IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al insertar el proceso.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//				END IF
//				
//				FETCH cur_dt_proceso
//				INTO :li_proceso,:li_secuenc,:ll_co_metodo_programa,:ll_co_consumo_proceso,:ldc_cnt,   
//				  :ll_unidad_consum_est,:ldc_min,:ll_unidade_consum_std,:ldt_fe_creacion,:ldt_fe_actualizacion,:ls_usuario,:ls_instancia ;
//			LOOP
//			CLOSE cur_dt_proceso;
//			
//			DELETE FROM dt_procesos_plan  
//			WHERE simulacion 					= :ll_simulacion AND 
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND 
//						 co_fabrica_exp 		= :li_fabexp AND 
//						 pedido 					= :ll_pedido AND
//						 cs_liberacion 		= :li_cslib AND  
//						 po 						= :ls_po AND
//						 co_fabrica_pt 		= :li_fabpt AND 
//						 co_linea 				= :li_lin AND
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar;
//			
//			IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al borrar los procesos.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//			END IF
//			
//			DELETE FROM dt_talla_pdnmodulo
//			WHERE  simulacion 				= :ll_simulacion AND
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND  
//						 co_fabrica_exp 		= :li_fabexp AND
//						 pedido 					= :ll_pedido AND  
//						 cs_liberacion 		= :li_cslib AND 
//						 po 						= :ls_po AND 
//						 co_fabrica_pt 		= :li_fabpt AND
//						 co_linea 				= :li_lin AND 
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND 
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar   ;
//						 
//			IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK;
//					MessageBox("Advertencia!","Hubo un error al borrar las tallas.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//			END IF
//			
//			DECLARE cur_obser CURSOR FOR
//			SELECT simulacion,co_fabrica,co_planta,co_fabrica_exp,pedido,cs_liberacion,po,   
//					co_fabrica_pt,co_linea,co_referencia,co_color_pt,tono,cs_estilocolortono,cs_particion,   
//					observacion,area,cs_observacion,fe_actualizacion,fe_creacion,usuario,instancia  
//			 FROM dt_observaxmodulo 
//			 WHERE simulacion 				= :ll_simulacion AND
//						 co_fabrica 			= :ll_fabrica AND
//						 co_planta 				= :ll_planta AND
//						 co_modulo 				= :ll_modulo_viejo AND  
//						 co_fabrica_exp 		= :li_fabexp AND
//						 pedido 					= :ll_pedido AND  
//						 cs_liberacion 		= :li_cslib AND 
//						 po 						= :ls_po AND 
//						 co_fabrica_pt 		= :li_fabpt AND
//						 co_linea 				= :li_lin AND 
//						 co_referencia 		= :ll_ref AND 
//						 co_color_pt 			= :li_col AND 
//						 tono 					= :ls_tono AND
//						 cs_estilocolortono 	= :li_csest AND
//						 cs_particion 			= :li_cspar;
//			OPEN cur_obser;
//			IF sqlca.SQLCode = -1 THEN
//				ROLLBACK;
//				MessageBox("Error Base Datos","Error al abrir el cursor")
//				Return(0)
//			END IF
//			FETCH cur_obser
//			INTO :li_simulacion,:li_fabrica,:li_planta,:li_fabricaexp,:ll_pedido,:ll_cs_liberacion,:ls_po,:li_fabricapt,
//				  :li_linea,:ll_referencia,:ll_colorpt,:ls_tono,:ll_cs_estilo,:ll_cs_particion,:ls_observacion,:ll_area
//				  ,:ll_cs_observacion,:ldt_fe_actualizacion,:ldt_fe_creacion,:ls_usuario,:ls_instancia;
//					 
//			DO WHILE SQLCA.SQLCode = 0
//				
//				INSERT INTO dt_observaxmodulo  
//					( simulacion,co_fabrica,co_planta,co_modulo,co_fabrica_exp,pedido,cs_liberacion,po,   
//					  co_fabrica_pt,co_linea,co_referencia,co_color_pt,tono,cs_estilocolortono,cs_particion,   
//					  observacion,area,cs_observacion,fe_actualizacion,fe_creacion,usuario,instancia )  
//				VALUES ( :li_simulacion,:li_fabrica,:li_planta,:ll_co_modulo,:li_fabricaexp,:ll_pedido,:ll_cs_liberacion,
//						:ls_po,:li_fabricapt,:li_linea,:ll_referencia,:ll_colorpt,:ls_tono,:ll_cs_estilo,:ll_cs_particion,
//						:ls_observacion,:ll_area,:ll_cs_observacion,:ldt_fe_actualizacion,:ldt_fe_creacion,:ls_usuario,
//						:ls_instancia)  ;
//		
//				IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK ;
//					MessageBox("Advertencia!","Hubo un error al insertar los requisitos.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//				END IF
//		
//				FETCH cur_obser
//				INTO :li_simulacion,:li_fabrica,:li_planta,:li_fabricaexp,:ll_pedido,:ll_cs_liberacion,:ls_po,:li_fabricapt,
//					  :li_linea,:ll_referencia,:ll_colorpt,:ls_tono,:ll_cs_estilo,:ll_cs_particion,:ls_observacion,:ll_area
//					  ,:ll_cs_observacion,:ldt_fe_actualizacion,:ldt_fe_creacion,:ls_usuario,:ls_instancia;
//			LOOP
//		
//			CLOSE cur_obser;
//			
//			DELETE FROM dt_observaxmodulo
//			WHERE simulacion 				= :ll_simulacion AND
//					 co_fabrica 			= :ll_fabrica AND
//					 co_planta 				= :ll_planta AND
//					 co_modulo 				= :ll_modulo_viejo AND  
//					 co_fabrica_exp 		= :li_fabexp AND
//					 pedido 					= :ll_pedido AND  
//					 cs_liberacion 		= :li_cslib AND 
//					 po 						= :ls_po AND 
//					 co_fabrica_pt 		= :li_fabpt AND
//					 co_linea 				= :li_lin AND 
//					 co_referencia 		= :ll_ref AND 
//					 co_color_pt 			= :li_col AND 
//					 tono 					= :ls_tono AND
//					 cs_estilocolortono 	= :li_csest AND
//					 cs_particion 			= :li_cspar;
//			
//			IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK;
//					MessageBox("Advertencia!","Hubo un error al borrar las observaciones.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//			END IF	
//					
//			DELETE FROM dt_pdnxmodulo
//			WHERE simulacion 				= :ll_simulacion AND
//					 co_fabrica 			= :ll_fabrica AND
//					 co_planta 				= :ll_planta AND
//					 co_modulo 				= :ll_modulo_viejo AND  
//					 co_fabrica_exp 		= :li_fabexp AND
//					 pedido 					= :ll_pedido AND  
//					 cs_liberacion 		= :li_cslib AND 
//					 po 						= :ls_po AND 
//					 co_fabrica_pt 		= :li_fabpt AND
//					 co_linea 				= :li_lin AND 
//					 co_referencia 		= :ll_ref AND 
//					 co_color_pt 			= :li_col AND 
//					 tono 					= :ls_tono AND
//					 cs_estilocolortono 	= :li_csest AND
//					 cs_particion 			= :li_cspar   ;
//				
//			IF Sqlca.SqlCode = -1 THEN
//					ls_sqlerr = Sqlca.SqlErrText
//					ROLLBACK;
//					MessageBox("Advertencia!","Hubo un error al borrar en dt_pdnxmodulo.~n~n~nNota: " + ls_sqlerr )
//					RETURN -1
//			END IF	
//			
//			commit ;
//		
//			//	Invovar funcion para conocer prioridad en la quedara dentro del modulo a asignar 
//			f_prioridad(ll_simulacion,ll_fabrica,ll_planta,ll_co_modulo,ls_expresion,ll_modulo_viejo)
//			//termina el ciclo para poder garantizar que se cambio de m$$HEX1$$f300$$ENDHEX$$dulo todas las O.C. con el 
//			//mismo n$$HEX1$$fa00$$ENDHEX$$mero de agrupaci$$HEX1$$f300$$ENDHEX$$n
//		End if
//	Next
//		
//	dw_detalle.Retrieve(91,1,1)
//		
//	//ii_repriorizar = 1
//	this.Accepttext()
//	
//END IF
//
//
////PARA EL CAMBIO DE LA FECHA FINAL
//IF dwo.name = "fe_fin_prog" THEN
//	ldt_fecha_final = THIS.GetitemDateTime(row,"fe_fin_prog")
//	ldt_fecha_inicial = THIS.GetitemDateTime(row,"fe_inicio_prog")
//	IF ldt_fecha_inicial > ldt_fecha_final THEN
//		MessageBox(THIS.Title,"La Fecha inicial debe ser menor que la final")
//		Return (0)
//	END IF
////	Parent.TriggerEvent("ue_grabar")
////	Parent.Triggerevent("ue_recalcular")
//	commit ;
//END IF
//
////PARA EL CAMBIO DEL CONSECUTIVO DE PRIORIDAD
//IF dwo.Name = 'cs_prioridad' THEN
//	li_prdnue = Long(Data)
//	//---------------------------------------------------------------------------------------------------
//	//invocar funcion que determine el n$$HEX1$$fa00$$ENDHEX$$mero de la nueva prioridad, para evitar partir agrupaciones
//	//---------------------------------------------------------------------------------------------------
//	
//	ll_agrupacion = dw_detalle.getItemNumber(row,'dt_agrupa_pdn_cs_agrupacion')
//	ll_modulo = This.GetItemNumber(row,'co_modulo')
//	dw_detalle.SelectRow(0, FALSE)
//	dw_detalle.SelectRow(row,True)
//	
//	For ll_i = 1 To dw_detalle.rowCount()
//			If ll_agrupacion = dw_detalle.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion') Then
//				dw_detalle.SelectRow(ll_i,True)
//			End if
//	Next
//
//	li_prdact = This.GetItemNumber(row,'cs_prioridad')
//	
//	ll_i = dw_detalle.Find("co_modulo = "+String(ll_modulo)+  " and cs_prioridad = "+String(li_prdnue), 1, dw_detalle.RowCount())
//
//	If ll_i = 0 Then
//		MessageBox('Error','No es posible desplazar el registro a la nueva prioridad, por favor verifique')
//		Return
//	Else
//		ll_agrupa_des = dw_detalle.GetitemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion')
//	End if
//	
//	If ll_agrupacion = dw_detalle.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion') Then
//		MessageBox('Advertencia','La prioridad a la cual desea mover el registro pertenece a la misma agrupacion')
//		dw_detalle.SetItem(row,'cs_prioridad',li_prdact)
//		This.AcceptText()
//		Return 2
//	End if
//	
//	li_prdact = This.GetItemNumber(row,'cs_prioridad')
//	IF li_prdact > li_prdnue THEN		
//		ll_modulo = This.GetItemNumber(row,'co_modulo')
//		li_tipo = 0
//		//----------------------------------------------------------------------------------------------------------
//		//funcion para determinar prioridad candidata, cuando esta disminuye
//		dw_detalle.SetItem(row,'cs_prioridad',li_prdact)
//		
//		li_prdnue = wf_numero_prioridad(li_prdact,li_prdnue,ll_agrupa_des,ll_modulo,li_tipo)
//		
//		ll_i = dw_detalle.Find("co_modulo = "+String(ll_modulo)+ " and cs_prioridad = "+String(li_prdnue), 1, dw_detalle.RowCount())
//		IF ll_i = 0 THEN
//			MessageBox('Error','No es posible desplazar el registro a la nueva prioridad, por favor verifique')
//			Return
//		ELSE
//			ll_agrupa_des = dw_detalle.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion')
//			IF ll_agrupacion = ll_agrupa_des THEN
//				MessageBox('Error','No es posible desplazar el registro a la nueva prioridad, por favor verifique')
//				Return
//			END IF
//		END IF
//		//----------------------------------------------------------------------------------------------------------
//			
//		FOR ll_filas = 1 TO  dw_detalle.RowCount()
//			IF	IsSelected (ll_filas ) = TRUE THEN
//				ii_incremento = ll_filas	
//				ll_co_modulo_fila = this.getitemnumber(ll_filas, 'co_modulo')
//				li_prdact = This.GetItemNumber(ll_filas,'cs_prioridad')
//				selectrow(ll_filas,False)
//				dw_detalle.SetItem(ll_filas,'cs_prioridad',li_prdnue)
//				wf_reordenar(ll_co_modulo_fila,li_prdact,li_prdnue)
//				li_prdnue += 1
//			END IF
//		NEXT
//		
//	ELSE//li_prdact > li_prdnue
//		ll_modulo = This.GetItemNumber(row,'co_modulo')
//		li_tipo = 1
//		//---------------------------------------------------------------------------------------------------------
//		//funcion para dererminar prioridad candidata, cuando esta aumenta
//		dw_detalle.SetItem(row,'cs_prioridad',li_prdact)
//		
//		li_prdnue = wf_numero_prioridad(li_prdact,li_prdnue,ll_agrupa_des,ll_modulo,li_tipo)
//		
//		ll_i = dw_detalle.Find("cs_prioridad = "+String(li_prdnue), 1, dw_detalle.RowCount())
//		IF ll_i = 0 THEN
//			MessageBox('Error','No es posible desplazar el registro a la nueva prioridad, por favor verifique')
//			Return
//		ELSE
//			ll_agrupa_des = dw_detalle.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion')
//			IF ll_agrupacion = ll_agrupa_des THEN
//				MessageBox('Error','No es posible desplazar el registro a la nueva prioridad, por favor verifique')
//				Return
//			END IF
//		END IF
//		//----------------------------------------------------------------------------------------------------------
//		FOR ll_filas =  dw_detalle.RowCount() TO 1 STEP -1
//			IF	IsSelected (ll_filas ) = TRUE THEN
//				ii_incremento = ll_filas	
//				ll_co_modulo_fila = this.getitemnumber(ll_filas, 'co_modulo')
//				li_prdact = This.GetItemNumber(ll_filas,'cs_prioridad')
//				selectrow(ll_filas,False)
//				dw_detalle.SetItem(ll_filas,'cs_prioridad',li_prdnue)
//				wf_reordenar_descendente(ll_co_modulo_fila,li_prdact,li_prdnue)
//				li_prdnue -= 1
//			END IF
//		NEXT
//	END IF//li_prdact > li_prdnue
//	commit ;
//	This.SetRow(row)
//END IF
//
////PARA EL CAMBIO DEL ESTADO DE ASIGNACI$$HEX1$$d300$$ENDHEX$$N
//IF dwo.Name = 'co_estado_asigna' THEN
//	//------------------------------------------------------------------
//	//primero determino si se desea devolver la o.c. 
////	Long ll_orden
////
////	ll_orden 			= This.GetItemNumber(row,'cs_asignacion')
////	ll_planta 			= dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_planta")
////	ll_fabrica 			= dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_fabrica")
////	ll_simulacion 		= dw_detalle.GetitemNumber(row,"simulacion")
////	ll_modulo_viejo 	= dw_detalle.GetitemNumber(row,"co_modulo")
////	li_fabexp 			= dw_detalle.GetitemNumber(row,"co_fabrica_exp")  
////	ll_pedido 			= dw_detalle.GetitemNumber(row,"pedido")   
////	li_cslib  			= dw_detalle.GetitemNumber(row,"cs_liberacion")   
////	ls_po     			= dw_detalle.GetitemString(row,"po")   
////	li_fabpt  			= dw_detalle.GetitemNumber(row,"co_fabrica_pt")   
////	li_lin    			= dw_detalle.GetitemNumber(row,"co_linea")   
////	ll_ref    			= dw_detalle.GetitemNumber(row,"co_referencia")   
////	li_col    			= dw_detalle.GetitemNumber(row,"co_color_pt")   
////	ls_tono   			= dw_detalle.GetitemString(row,"tono")   
////	li_csest  			= dw_detalle.GetitemNumber(row,"cs_estilocolortono")   
////	li_cspar	 			= dw_detalle.GetitemNumber(row,"cs_particion")
////
////	select count(*)
////	into :ll_count
////	from dt_telasxoc
////	where cs_orden_corte = :ll_orden and
////			co_fabrica = :ll_fabrica and
////			ca_requerida > 0 ;
////	
////	If ll_count >= 1 Then
////		MessageBox('Error','No es posible devolver el estado de la O.C., debido a que ya se realizaron procesos de tela')
////	Else
////		//elimino los datos de las tablas dt_telasxoc y dt_requisitos_pdn
////		delete from dt_telasxoc
////		where cs_orden_corte = :ll_orden and
////				co_fabrica 		= :ll_fabrica;
////
////		If sqlca.sqlcode = -1 Then
////			Rollback;
////			MessageBox('Error','Ocurrio un error de base de datos, por favor revise sus datos')
////			Return
////		End if
////
////		delete from dt_requisitosxpdn
////		where simulacion 				= :ll_simulacion and
////				co_fabrica 				= :ll_fabrica and
////				co_planta  				= :ll_planta and
////				co_modulo  				= :ll_modulo_viejo and
////				co_fabrica_exp 		= :li_fabexp and
////				pedido 					= :ll_pedido and
////				cs_liberacion 			= :li_cslib and
////				po 						= :ls_po and
////				co_fabrica_pt 			= :li_fabpt and
////				co_linea 				= :li_lin and
////				co_referencia 			= :ll_ref and
////				co_color_pt 			= :li_col and
////				tono 						= :ls_tono and
////				cs_estilocolortono 	= :li_csest and
////				cs_particion 			= :li_cspar  ;
////
////		If sqlca.sqlcode = -1 Then
////			Rollback;
////			MessageBox('Error','Ocurrio un error de base de datos, por favor revise sus datos')
////			Return
////		End if
////	End if
//	
//	
//	//------------------------------------------------------------------
//	
//	ll_modulo = This.GetItemNumber(row,'co_modulo')
//	
//	ll_estado_asigna = Long(Data)
//	ll_estado_asigna3 = This.GetItemNumber(row,'co_estado_asigna')
//	ll_agrupa = This.GetItemnumber(row,'dt_agrupa_pdn_cs_agrupacion')
//	IF ll_modulo <> 0  THEN
//		FOR ll_i = 1 TO This.RowCount()
//			This.AcceptText()
//			ll_estado_asigna2 = This.GetItemNumber(ll_i,'co_estado_asigna')
//			
//			IF ll_agrupa = This.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion') THEN
//				This.SetItem(ll_i,'co_estado_asigna',ll_estado_asigna)
//			END IF//ll_agrupa
//			IF ll_estado_asigna2 = 6 THEN
//				ldt_fecha_final = THIS.GetitemDateTime(ll_i,"fe_fin_prog")
//				ldt_fecha_inicial = THIS.GetitemDateTime(ll_i,"fe_inicio_prog")
//				IF IsNull(ldt_fecha_inicial) or Isnull(ldt_fecha_final) THEN
//					li_cs_prioridad = This.GetItemNumber(ll_i,'cs_prioridad')
//					MessageBox(THIS.Title,"Para aprobar la prioridad "+String(li_cs_prioridad)+" se deben generar las fechas de inicio y fin de corte.")
//					This.SetItem(ll_i,'co_estado_asigna',ll_estado_asigna3)
//					This.AcceptText()
//					Return 2
//				END IF
//				
//			END IF//ll_estado_asigna2 = 6
//		NEXT
//	ElSE
//		MessageBox('Advertencia','Debe asignar un m$$HEX1$$f300$$ENDHEX$$dulo antes de intentar realizar cambios')
//		This.SetItem(ll_i,'co_estado_asigna',ll_estado_asigna3)
//		This.AcceptText()
//		return 2
//	END IF
//	
//END IF
//		
//
//
//
//
//
end event

event dw_detalle::updatestart;//Long ll_fila,ll_num_reg,ll_cs_liberacion,ll_cs_prioridad,ll_cs_asignacion,ll_co_estado_asigna,ll_co_est_asig_old,&
//	  ll_i,ll_incremento,ll_nuenqueesta,ll_co_fabrica_exp,ll_pedido,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,&
//	  ll_co_color_pt,ll_cs_estilocolortono,ll_numero_agrupa,ll_estado_asigna,ll_i2,&
//	  ll_cs_agrupacion,ll_fil,ll_agrupa,ll_agrupa2,ll_ca_pendiente
//String ls_po,ls_referencia,ls_gpa,ls_color,ls_body,ls_tono
//DateTime ldt_fe_ini_prog,ldt_fe_fin_prog
//
//
//
//dw_detalle.AcceptText()
//
//sw_estado = 0
////Recorro la dw para determinar que registros cambiaron de estado de asignacion 3 al 6, a los que cumplan se les asigna
////la orden de corte
//FOR ll_i = 1 TO dw_detalle.RowCount()
//	ll_co_estado_asigna = dw_detalle.getitemnumber(ll_i,'co_estado_asigna')
//	ll_co_est_asig_old = dw_detalle.GetItemNumber(ll_i,'espejo_asignacion')
//	ll_agrupa = dw_detalle.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion')
//	
//	IF ll_co_estado_asigna = 6 AND (ll_co_est_asig_old = 3 OR ll_co_est_asig_old = 2)  THEN
//		//VERIFICO QUE ESTEN APROBADAS TODOS LOS REGISTROS DE LA AGRUPACION
//	
//		FOR ll_fil = 1 TO dw_detalle.RowCount()
//			IF ll_fil <> ll_i THEN
//				ll_agrupa2 = dw_detalle.GetItemNumber(ll_fil,'dt_agrupa_pdn_cs_agrupacion')
//				IF ll_agrupa = ll_agrupa2 THEN
//					IF dw_detalle.GetItemNumber(ll_fil,'co_estado_asigna') <> 6 THEN
//						MessageBox('Advertencia','La agrupaci$$HEX1$$f300$$ENDHEX$$n: '+String(ll_agrupa2)+' no se encuentra aprobada por completo')
//						sw_estado = 1
//						Return
//					END IF
//				END IF
//			END IF
//		NEXT
//		
//		
//		select cf_consc_ordenes.incremento, cf_consc_ordenes.nu_enque_esta  
//		into :ll_incremento, :ll_nuenqueesta  
//		from cf_consc_ordenes  
//		where ( cf_consc_ordenes.tipo_orden = 3 ) and  
//				( cf_consc_ordenes.co_fabrica = 2 );
//		IF SQLCA.SQLCode <> 0 OR ISNULL(ll_incremento) OR ISNULL(ll_nuenqueesta) THEN
//			MessageBox("Error","No se pudo encontrar el consecutivo de ordenes de corte, comuniquese con sistemas por favor", StopSign!)
//			sw_estado = 1
//			Return
//		ELSE
//			ll_nuenqueesta = ll_nuenqueesta + ll_incremento
//			update cf_consc_ordenes
//			set nu_enque_esta = :ll_nuenqueesta
//			where ( cf_consc_ordenes.tipo_orden = 3 ) and
//					( cf_consc_ordenes.co_fabrica = 2 );
//		END IF
//		ll_co_fabrica_exp 		= this.getitemnumber(ll_i, 'co_fabrica_exp')
//		ll_pedido 					= this.getitemnumber(ll_i, 'pedido')
//		ll_cs_liberacion 			= this.getitemnumber(ll_i, 'cs_liberacion')
//		ls_po 						= this.getitemstring(ll_i, 'po')
//		ll_co_fabrica_pt 			= this.getitemnumber(ll_i, 'co_fabrica_pt')
//		ll_co_linea 				= this.getitemnumber(ll_i, 'co_linea')
//		ll_co_referencia 			= this.getitemnumber(ll_i, 'co_referencia')
//		ll_co_color_pt 			= this.getitemnumber(ll_i, 'co_color_pt')
//		ls_tono 						= this.getitemstring(ll_i, 'tono')
//		ll_cs_estilocolortono	= this.getitemnumber(ll_i, 'cs_estilocolortono')
//		ll_cs_agrupacion 			= This.GetItemNumber(ll_i,'dt_agrupa_pdn_cs_agrupacion')
//		
//
//	//generar la orden de corte para todas las agrupaciones
//	FOR ll_i2 = 1 TO dw_detalle.RowCount()
//		IF dw_detalle.GetItemNumber(ll_i2,'dt_agrupa_pdn_cs_agrupacion') = ll_cs_agrupacion THEN
//			IF dw_detalle.GetItemNumber(ll_i2,'cs_asignacion') = 1 THEN
//				IF ll_co_estado_asigna = 6 AND (ll_co_est_asig_old = 3 OR ll_co_est_asig_old = 2) THEN
//					this.Setitem(ll_i2,'cs_asignacion',ll_nuenqueesta)
//				END IF
//			END IF
//		END IF
//		
//	NEXT
//	
//	COMMIT;
//	ELSE
//		IF ll_co_estado_asigna < 6 THEN 
//			this.Setitem(ll_i,'cs_asignacion',1)
//		END IF
//	END IF
//NEXT
////
////determino que filas cambiaron de estado de asignacion 3 al 6 para enviar el correo indicando dicho cambio
//ll_fila = 1
//ll_num_reg = dw_detalle.RowCount()
//
//DO WHILE ll_fila <= ll_num_reg
//	ll_co_estado_asigna = dw_detalle.getitemnumber(ll_fila,'co_estado_asigna')
//	ll_co_est_asig_old = dw_detalle.GetItemNumber(ll_fila,'espejo_asignacion')
//	IF ll_co_estado_asigna = 6  AND ll_co_est_asig_old = 3 THEN
//		ls_po = dw_detalle.getitemstring(ll_fila, 'po')
//		IF IsNull(ls_po) THEN
//			ls_po = " "
//		END IF
//		ll_cs_liberacion = dw_detalle.getitemnumber(ll_fila, 'cs_liberacion')
//		IF IsNull(ll_cs_liberacion) THEN
//			ll_cs_liberacion = 0
//		END IF
//		ll_cs_prioridad = dw_detalle.getitemnumber(ll_fila, 'cs_prioridad')
//		IF IsNull(ll_cs_prioridad) THEN
//			ll_cs_prioridad = 0
//		END IF
//		ll_cs_asignacion = dw_detalle.getitemnumber(ll_fila, 'cs_asignacion')
//		IF IsNull(ll_cs_asignacion) THEN
//			ll_cs_asignacion = 0
//		END IF
//		ls_referencia = dw_detalle.getitemString(ll_fila, 'de_referencia')
//		IF IsNull(ls_referencia) THEN
//			ls_referencia = " "
//		END IF
//		ls_gpa = dw_detalle.getitemstring(ll_fila, 'gpa')
//		IF IsNull(ls_gpa) THEN
//			ls_gpa = " "
//		END IF
//		ls_color = dw_detalle.getitemstring(ll_fila, 'de_color')
//		IF IsNull(ls_color) THEN
//			ls_color = " "
//		END IF
//		ls_referencia = dw_detalle.getitemstring(ll_fila, 'de_referencia')
//		IF IsNull(ls_referencia) THEN
//			ls_referencia = " "
//		END IF
//		ldt_fe_ini_prog = dw_detalle.getitemDatetime(ll_fila, 'fe_inicio_prog')
//		IF IsNull(ldt_fe_ini_prog) THEN
//			ldt_fe_ini_prog = Datetime("01/01/1900")
//		END IF
//		ldt_fe_fin_prog = dw_detalle.getitemDatetime(ll_fila, 'fe_fin_prog')
//		IF IsNull(ldt_fe_fin_prog) THEN
//			ldt_fe_fin_prog = Datetime("01/01/1900")
//		END IF
//		ll_ca_pendiente = dw_detalle.GetItemNumber(ll_fila,'ca_pendiente')
//		IF isnull(ll_ca_pendiente) THEN
//			ll_ca_pendiente = 0
//		END IF
//		IF IsNull(ls_body) THEN
//			ls_body = " "
//		END IF
//		ls_body = ls_body + "Prioridad: " +String(ll_cs_prioridad) + " Grupo: " + trim(ls_gpa) + &
//		" PO: " + trim(ls_po) + " Orden de Corte: " + String(ll_cs_asignacion) + " Referencia: " + trim(ls_referencia) + " Cantidad: " + String(ll_ca_pendiente) + " Color: " + trim(ls_color) + " Liberacion: "&
//		+ String(ll_cs_liberacion) + " Fecha Inicio: " + String(ldt_fe_ini_prog) + " Fecha Final: "&
//		+ String(ldt_fe_fin_prog) + '~n~n'
//	END IF
//	ll_fila = ll_fila	+ 1
//LOOP
//is_body = ls_body
//
//
end event

event dw_detalle::doubleclicked;call super::doubleclicked;//n_cts_param luo_param
//
//
//If Row <= 0 Then Return
//
//luo_param.il_vector[2] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_fabrica")
//luo_param.il_vector[3] = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_planta")
////luo_param.il_vector[4] = dw_detalle.GetItemNumber(il_fila_actual_maestro,"co_modulo")
//luo_param.il_vector[4] = dw_detalle.GetItemNumber(Row,"co_modulo")
//
//luo_param.il_vector[1] = dw_detalle.GetItemNumber(Row,"simulacion")
//luo_param.il_vector[5] = dw_detalle.GetItemNumber(Row,"co_fabrica_exp")
//luo_param.il_vector[6] = dw_detalle.GetItemNumber(Row,"pedido")
//luo_param.il_vector[7] = dw_detalle.GetItemNumber(Row,"cs_liberacion")
//luo_param.il_vector[8] = dw_detalle.GetItemNumber(Row,"co_fabrica_pt")
//luo_param.il_vector[9] = dw_detalle.GetItemNumber(Row,"co_linea")
//luo_param.il_vector[10] = dw_detalle.GetItemNumber(Row,"co_referencia")
//luo_param.il_vector[11] = dw_detalle.GetItemNumber(Row,"co_color_pt")
//luo_param.il_vector[12] = dw_detalle.GetItemNumber(Row,"cs_estilocolortono")
//luo_param.il_vector[13] = dw_detalle.GetItemNumber(Row,"cs_particion")
//
//luo_param.is_vector[1] = dw_detalle.GetItemString(Row,"po")
//luo_param.is_vector[2] = dw_detalle.GetItemString(Row,"tono")
//
//OpenWithParm(w_programacion_produccion,luo_param)
//
//
//
end event

event dw_detalle::clicked;//Long ll_modulo,ll_subcentro
//This.SetTabOrder('fe_inicio_prog',0)
//This.SetTabOrder('fe_fin_prog',0)

If Row <= 0 Then Return

il_fila_actual_detalle = Row
This.SetRow(Row)

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If

//ll_modulo = This.getItemNumber(Row,'co_modulo')
//
//Select distinct co_centro_cc
//into :ll_subcentro
//from m_modulos
//where co_fabrica = 91 and
//		co_planta = 1 and
//		co_modulo = :ll_modulo;
//		
//If ll_subcentro = 0 Then
//	This.SetTabOrder('fe_inicio_prog',22)
//	This.SetTabOrder('fe_fin_prog',23)
//End if
//

end event

event dw_detalle::rowfocuschanged;Long ll_dias,ll_co_estado

il_fila_actual_detalle = CurrentRow

//ll_co_estado = This.Getitemnumber(il_fila_actual_detalle,'co_estado_asigna')
//ll_dias = This.Getitemnumber(il_fila_actual_detalle,'dias')
//
//IF ll_co_estado <> 3 THEN
//	IF ll_dias > 0 THEN
//	//	This.setItem(il_fila_actual_detalle,'aprueba','N')
//		This.setItem(il_fila_actual_detalle,'co_estado_asigna',5)
//	ELSE
//	//	This.setItem(il_fila_actual_detalle,'aprueba','S')
//		This.setItem(il_fila_actual_detalle,'co_estado_asigna',6)
//	END IF
//END IF


end event

event dw_detalle::rbuttondown;call super::rbuttondown;Long ll_find
String ls_expresion
s_base_parametros lst_parametros

Open(w_buscar_agrupaciones_parametros)

lst_parametros = Message.PowerObjectParm

IF lst_parametros.cadena[1] <> 'NO' THEN
	ls_expresion = "cs_prioridad = " + String(lst_parametros.entero[1]) + " and co_modulo = " +String(lst_parametros.entero[2]) 
	
	ll_find = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())
	
	dw_detalle.ScrollToRow(ll_find)
	dw_detalle.SelectRow(ll_find,True)
END IF
end event

event dw_detalle::updateend;call super::updateend;//Long li_return
//
//OLEObject lole_outlook,lole_item,lole_attach
//
////solo se envia correo cuando existe informacion en el mensaje, es decir ls_body no se enecuentra vacio.
//IF isnull(is_body) OR is_body = '' THEN
//ELSE
//	lole_outlook = Create OLEObject
//	
//	li_return = lole_outlook.ConnectToNewObject("outlook.application")
//	
//	If li_return <> 0 Then
//		Messagebox("Advertencia!","No se pudo establecer conexi$$HEX1$$f300$$ENDHEX$$n con Outlook.~n~nError : " &
//					 + String(li_return) )
//		Destroy lole_outlook
//		Return li_return
//	End If
//	
//	lole_item = lole_outlook.CreateItem(0)
//	
//	lole_item.To      = "mahernan@gef.com.co;almacen_telas@saraintl.com;jorge_delgado@saraintl.com;Jose Fernando Yazo Vargas"
//	lole_item.Subject = "Aprobados"
//	lole_item.Body    = is_body
//	
//	lole_item.Send
//	
//	Destroy lole_item
//END IF
//
//is_body = ''
end event

type cb_1 from commandbutton within w_fechas_requisito_independiente
boolean visible = false
integer x = 2816
integer y = 28
integer width = 677
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Aprobar Todo"
end type

event clicked;Long ll_fila,ll_num_reg,ll_co_est_asigna

dw_detalle.AcceptText()

ll_fila = 1
ll_num_reg = dw_detalle.Rowcount()


DO WHILE ll_fila < ll_num_reg
	ll_co_est_asigna = dw_detalle.GetItemNumber(ll_fila,'co_estado_asigna')
	IF ll_co_est_asigna = 3 THEN
		dw_detalle.setItem(ll_fila,'aprueba','S')
		dw_detalle.setItem(ll_fila,'co_estado_asigna',6)
		
	END IF
	ll_fila = ll_fila + 1
LOOP



end event

type cb_2 from commandbutton within w_fechas_requisito_independiente
boolean visible = false
integer x = 2816
integer y = 112
integer width = 681
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Programar Fechas sin Agrupar"
end type

event clicked;Long ll_fila,ll_num_reg
String ls_aprueba

ll_fila = 1
ll_num_reg = dw_detalle.Rowcount()

DO WHILE ll_fila < ll_num_reg
	ls_aprueba = dw_detalle.GetItemString(ll_fila,'aprueba')
	IF ls_aprueba = 'S' THEN
		dw_detalle.setItem(ll_fila,'co_estado_asigna',2)
	END IF
	ll_fila = ll_fila + 1
LOOP

//IF of_particion(dw_detalle) = 0 THEN
	COMMIT;
//ELSE
//	ROLLBACK;
//END IF

end event

type cb_3 from commandbutton within w_fechas_requisito_independiente
integer x = 2821
integer y = 32
integer width = 626
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Fechas Finales por M$$HEX1$$f300$$ENDHEX$$dulo"
end type

event clicked;Open(w_fechas_modulos)
end event

type gb_1 from groupbox within w_fechas_requisito_independiente
integer x = 119
integer y = 272
integer width = 3621
integer height = 1488
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type gb_2 from groupbox within w_fechas_requisito_independiente
integer y = 4
integer width = 2798
integer height = 268
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "M$$HEX1$$f300$$ENDHEX$$dulo"
end type

