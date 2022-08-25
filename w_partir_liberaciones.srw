HA$PBExportHeader$w_partir_liberaciones.srw
forward
global type w_partir_liberaciones from w_base_maestroff_detalletb
end type
end forward

global type w_partir_liberaciones from w_base_maestroff_detalletb
integer width = 3465
integer height = 1084
string title = "Partir Escalas"
string menuname = "m_partir_liberaciones"
event ue_partir pbm_custom07
event ue_trasladar_tallas pbm_custom08
event ue_recalcular ( long ai_co_fabrica,  long ai_co_planta,  long ai_co_modulo,  long ai_co_simulacion )
end type
global w_partir_liberaciones w_partir_liberaciones

type variables
LONG			il_cs_liberacion,il_cs_lib_preliminar,il_pedido,il_co_referencia
LONG			il_co_color_pt
STRING		is_gpa,is_po,is_tono	
Long		ii_co_fabrica_exp,ii_co_fabrica_pt,ii_co_linea,ii_cs_estilocolortono
Long		ii_co_fabrica_tela,ii_co_caract,ii_diametro
LONG			il_co_reftel,il_co_color_te
DOUBLE		idb_ca_tela,idb_ancho_cortable
end variables

forward prototypes
public function long wf_trae_tela (long ai_co_fabrica_exp, long al_pedido, long ai_cs_liberacion, string as_po, long ai_co_fabrica_pt, long ai_co_linea, long al_co_referencia, long al_co_color_pt, string as_tono, long ai_cs_estilocolortono)
public function long wf_recalcular_programacion_produccion (long ai_simulacion, long ai_co_fabrica, long ai_co_planta, long ai_co_modulo)
end prototypes

event ue_partir;LONG 					ll_fila,ll_hallados
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia,ll_ca_a_comparar
LONG					ll_asignaciones,ll_ca_pendiente,ll_ca_faltan,ll_ca_a_asignar,ll_ca_a_sacar
LONG					ll_ca_base_dia_prog,ll_ca_base_dia_prod,ll_inserto_tallas
LONG					ll_ca_liberadas,ll_ca_numeradas,ll_caxestilo,ll_cs_ordenpd_pt
LONG					ll_ca_numerada_origen,ll_ca_unidades1,ll_ca_numerada1,ll_ca_numerada2,ll_ca_unidades2
LONG					ll_co_modelo,ll_ca_unidadesxtela,ll_ca_numerada,ll_ca_numeradaxtela
LONG					ll_ca_unidades_tela1,ll_ca_unidades_tela2,ll_ca_numerada_tela1,ll_ca_numerada_tela2
LONG					ll_co_modelo_esc_original,ll_ca_unidades_esc_orig
LONG					ll_ca_unidadesxtalla_esc1,ll_ca_unidadesxtalla_esc2
LONG					ll_ca_numerada_esc1,ll_ca_numerada_esc2,ll_ca_a_dejar, ll_color_id

Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
Long	 			li_co_fabrica_modu_des,li_co_planta_modu_des,li_co_modulo_des
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolton,li_cs_particion
Long				li_fuente_dato,li_cs_prioridad,li_rpta,li_cambia_modulo
Long				li_co_fabrica_modu_ant,li_co_planta_modu_ant,li_co_modulo_ant,li_max_particion,li_cs_particion_anterior
Long				li_ca_proporcion,li_sw_partida1,li_sw_partida2
Long				li_co_estado_material,li_sw_partida_origen
Long				li_cs_estilocolortono_new1,li_cs_estilocolortono_new2
Long				li_co_caract,li_raya,li_co_caract_escalas_original,li_co_estado_material_orig
Long				li_raya_esc_orig,li_ca_numerada_esc_orig,	li_cs_estilocolortono_esc1,li_cs_estilocolortono_esc2
Long				li_co_estado_material_talla,li_raya_talla,li_cs_max_particion,li_sw_talla_partida
Long				li_cs_orden_talla, li_co_est_prog_talla, li_cs_max_prioridad 

DOUBLE				ldb_yield,ldb_porc_unid_libera_origen,ldb_yieldxtela,ldb_ca_tela_original
DOUBLE				ldb_ca_tela1,ldb_ca_tela2,ldb_ancho_cortable_esc_orig,ldb_ca_proporcion_esc_orig
DOUBLE				ldb_ca_proporcionxtalla

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido,ls_de_modulo,ls_nu_cut,ls_comentarios, ls_tipo_corte
STRING				ls_tono_tela,ls_nu_cut_talla_original,ls_nu_cut_escalas

DATETIME  			ldt_fechahora
// Campos PDNXMODULO
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog,ldt_fe_requerida_desp,ldt_fe_entra_pdn
DATETIME 			ldt_fe_lim_prog, ldt_fe_desp_programada
DATE					ldt_fe_fogueo, ldt_fe_trabajo

DECIMAL				ld_minutos_jornada,ld_ca_personasxmod, ld_ca_minutos_std
Long				li_co_estado_asigna,li_co_curva,li_co_tipo_asignacion,li_cod_tur,li_ind_cambio_estilo
Long				li_ca_unid_base_dia,li_orige_uni_base_dia,li_tipo_empate,li_unidades_empate
Long				li_metodo_programa,li_tipo_fe_prog,li_indicativo_base,li_ca_base_dia_prod
Long				li_ca_base_dia_prog,li_ca_a_programar,li_cs_asignacion
STRING				ls_co_estado_merc
LONG					ll_pedido_po

s_base_parametros lstr_parametros
s_base_parametros_seleccionar 	lstr_parametros_sel

IF (MessageBox("Partir o Trasladar unidades ...","Esta seguro de Partir?",Question!,YesNo!) = 1) THEN
	
	
//----------------------- inicio de verificar maestro ----------------------------------------------------//	
	IF il_fila_actual_maestro > 0 THEN
		IF dw_maestro.AcceptText() = -1 THEN
			MessageBox("Error datawindow","No se puede partir la escala porque habian ingresos previos con problemas" &
						,StopSign!)	
//----------------------- fin de verificar maestro ----------------------------------------------------//							


		ELSE

//----------------------- inicio de traer y verificar datos del detalle  ---------------------------------//							
			li_co_fabrica_exp			= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica_exp")
			ll_pedido		   		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"pedido")
			ll_cs_liberacion		   = dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_liberacion")
			ls_nu_orden		   		= dw_maestro.GetitemString(il_fila_actual_maestro,"nu_orden")
			li_co_fabrica_ref		   = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
			li_co_linea_ref		   = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_linea")
			ll_co_referencia		   = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_referencia")
			ll_color_pt		   		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_color_pt")
			ls_tono		   			= dw_maestro.GetitemString(il_fila_actual_maestro,"tono")
			li_cs_estilocolton		= dw_maestro.GetitemNumber(il_fila_actual_maestro,"cs_estilocolortono")
			ll_ca_unidades		   	= dw_maestro.GetitemNumber(il_fila_actual_maestro,"ca_unidades")
			
			IF IsNull(li_co_fabrica_exp) 	OR IsNull(ll_pedido) 			OR IsNull(ll_cs_liberacion) 	OR &
				IsNull(ls_nu_orden) 			OR IsNull(li_co_fabrica_ref) 	OR IsNull(li_co_linea_ref) 	OR &
				IsNull(ll_co_referencia) 	OR IsNull(ll_color_pt) 			OR IsNull(ls_tono) 				OR &
				IsNull(li_cs_estilocolton) OR IsNull(ll_ca_unidades) 		THEN
				
				MessageBox("Advertencia","Error:Tiene datos nulos en la liberaci$$HEX1$$f300$$ENDHEX$$n a partir")
				
			ELSE
				IF il_fila_actual_detalle > 0 THEN
				ELSE
					MessageBox("Advertencia","No hay registros en el detalle para partir")
					RETURN
				END IF
//----------------------- fin de traer y verificar datos del detalle  ---------------------------------//





//----------------------- inicio de manejo de ventana por tallas  ---------------------------------//
				lstr_parametros.entero[1]=li_co_fabrica_exp
				lstr_parametros.entero[2]=ll_pedido
				lstr_parametros.entero[3]=ll_cs_liberacion
				lstr_parametros.cadena[1]=ls_nu_orden
				lstr_parametros.entero[4]=li_co_fabrica_ref
				lstr_parametros.entero[5]=li_co_linea_ref
				lstr_parametros.entero[6]=ll_co_referencia
				lstr_parametros.entero[7]=ll_color_pt
				lstr_parametros.cadena[2]=ls_tono
				lstr_parametros.entero[8]=li_cs_estilocolton
				lstr_parametros.entero[9]=ll_ca_unidades
				lstr_parametros.entero[10]=ii_co_fabrica_tela
				lstr_parametros.entero[11]=il_co_reftel
				lstr_parametros.entero[12]=ii_diametro
				lstr_parametros.entero[13]=il_co_color_te
				lstr_parametros.decimal[1]=idb_ancho_cortable
					
				lstr_parametros.hay_parametros=TRUE
					
				OpenWithParm(w_partir_escala_de_liberaciones,lstr_parametros)
					
				lstr_parametros_sel = Message.PowerObjectParm
					
				IF lstr_parametros_sel.hay_parametros THEN

					ll_caxestilo = lstr_parametros_sel.entero7[1] 
					
					IF ll_caxestilo > 0 THEN
//----------------------- fin  de manejo de ventana por tallas  ---------------------------------//											




						
//------------------  inicio de traer el resto de datos de la liberaci$$HEX1$$f300$$ENDHEX$$n para crear particiones -------//
						SELECT dt_libera_estilos.nu_cut,   				dt_libera_estilos.yield,   
								dt_libera_estilos.porc_unid_libera,   	dt_libera_estilos.color_id,   
								dt_libera_estilos.pedido_po,   			dt_libera_estilos.co_estado_material,   
								dt_libera_estilos.cs_ordenpd_pt,   		dt_libera_estilos.comentarios,   
								dt_libera_estilos.tipo_corte,   			dt_libera_estilos.ca_numerada,   
								dt_libera_estilos.sw_partida  
						 INTO :ls_nu_cut,   									:ldb_yield,   
								:ldb_porc_unid_libera_origen,   			:ll_color_id,   
								:ll_pedido_po,   								:li_co_estado_material,   
								:ll_cs_ordenpd_pt,   						:ls_comentarios,   
								:ls_tipo_corte,   							:ll_ca_numerada_origen,   
								:li_sw_partida_origen  
						 FROM dt_libera_estilos  
						WHERE ( dt_libera_estilos.co_fabrica_exp			=:li_co_fabrica_exp  ) AND  
								( dt_libera_estilos.pedido 					=:ll_pedido  ) AND  
								( dt_libera_estilos.cs_liberacion 			=:ll_cs_liberacion  ) AND  
								( dt_libera_estilos.nu_orden 					=:ls_nu_orden  ) AND  
								( dt_libera_estilos.co_fabrica 				=:li_co_fabrica_ref  ) AND  
								( dt_libera_estilos.co_linea 					=:li_co_linea_ref  ) AND  
								( dt_libera_estilos.co_referencia 			=:ll_co_referencia  ) AND  
								( dt_libera_estilos.co_color_pt 				=:ll_color_pt  ) AND  
								( dt_libera_estilos.tono 						=:ls_tono  ) AND  
								( dt_libera_estilos.cs_estilocolortono 	=:li_cs_estilocolton  )  ;
								
						IF SQLCA.SQLCODE=-1 THEN
							MessageBox("Error Base Datos","No pudo buscar datos de estilo de escala original")
							Return
						ELSE
						END IF
						
						//busca dt_telaxmodelo_lib original
						SELECT dt_telaxmodelo_lib.co_modelo,   dt_telaxmodelo_lib.co_caract,   
								dt_telaxmodelo_lib.tono_tela,   	dt_telaxmodelo_lib.raya,   
								dt_telaxmodelo_lib.ca_unidades, 	dt_telaxmodelo_lib.yield,   
								dt_telaxmodelo_lib.ca_tela,   	dt_telaxmodelo_lib.ca_numerada  
						 INTO :ll_co_modelo,   						:li_co_caract,   
								:ls_tono_tela,   						:li_raya,   
								:ll_ca_unidadesxtela,				:ldb_yieldxtela,   
								:ldb_ca_tela_original,   			:ll_ca_numeradaxtela  
						 FROM dt_telaxmodelo_lib  
						WHERE ( dt_telaxmodelo_lib.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
								( dt_telaxmodelo_lib.pedido 					=:ll_pedido  ) AND  
								( dt_telaxmodelo_lib.cs_liberacion 			=:ll_cs_liberacion  ) AND  
								( dt_telaxmodelo_lib.nu_orden 				=:ls_nu_orden  ) AND  
								( dt_telaxmodelo_lib.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
								( dt_telaxmodelo_lib.co_linea 				=:li_co_linea_ref  ) AND  
								( dt_telaxmodelo_lib.co_referencia 			=:ll_co_referencia  ) AND  
								( dt_telaxmodelo_lib.co_color_pt 			=:ll_color_pt  ) AND  
								( dt_telaxmodelo_lib.tono 						=:ls_tono  ) AND  
								( dt_telaxmodelo_lib.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
								( dt_telaxmodelo_lib.co_fabrica_tela 		=:ii_co_fabrica_tela ) AND  
								( dt_telaxmodelo_lib.co_reftel 				=:il_co_reftel  ) AND  
								( dt_telaxmodelo_lib.diametro 				=:ii_diametro  ) AND  
								( dt_telaxmodelo_lib.co_color_tela 			=:il_co_color_te  ) AND  
								( dt_telaxmodelo_lib.ancho_cortable 		=:idb_ancho_cortable  )   ;

						IF SQLCA.SQLCODE=-1 THEN
							MessageBox("Error Base Datos","No pudo buscar datos de tela de secuencia original de partici$$HEX1$$f300$$ENDHEX$$n de escala")
							ROLLBACK;
							Return
						ELSE
						END IF
//------------------  fin de traer el resto de datos de la liberaci$$HEX1$$f300$$ENDHEX$$n para crear particiones -------//	





//------------------  inicio de crear partici$$HEX1$$f300$$ENDHEX$$n para secuencia 1  ----------------------------------------//

						IF li_cs_estilocolton=1 THEN  //es la liberaci original
							//primera particion debe hacer 2 insert 
							
							//Primer insert
							li_cs_estilocolortono_new1=li_cs_estilocolton + 1
							ll_ca_unidades1=ll_ca_unidades - ll_caxestilo
							ll_ca_numerada1=ll_ca_numerada_origen
							li_sw_partida1=0
							ldt_fechahora = f_fecha_servidor()
							
							INSERT INTO dt_libera_estilos  
								( co_fabrica_exp,  	pedido,			  		cs_liberacion,   		nu_orden,   
								  nu_cut,   		  	co_fabrica,   		  	co_linea,   		  	co_referencia,   
								  co_color_pt,   		tono,   					cs_estilocolortono,  yield,   
								  ca_unidades,   		porc_unid_libera,   	color_id,   			pedido_po,   
								  co_estado_material,cs_ordenpd_pt,   		comentarios,   	  	tipo_corte,   
								  fe_creacion,   		fe_actualizacion,   	
								  usuario,   			instancia,   
								  ca_numerada,   		sw_partida, cs_origen )  
						 	VALUES ( :li_co_fabrica_exp,:ll_pedido,   			:ll_cs_liberacion,   :ls_nu_orden,   
								  :ls_nu_cut,   		:li_co_fabrica_ref,  :li_co_linea_ref,   	:ll_co_referencia,   
								  :ll_color_pt,   	:ls_tono,   		  	:li_cs_estilocolortono_new1,:ldb_yield,   
								  :ll_ca_unidades1,  :ldb_porc_unid_libera_origen,:ll_color_id,   	  	:ll_pedido_po,   
								  :li_co_estado_material,:ll_cs_ordenpd_pt,:ls_comentarios,    :ls_tipo_corte,   
								  :ldt_fechahora,  :ldt_fechahora,
								  :gstr_info_usuario.codigo_usuario,   
								  :gstr_info_usuario.instancia,:ll_ca_numerada1,:li_sw_partida1, 1 )  ;
								  
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo insertar primera secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala original")
								ROLLBACK;
								Return
								
							ELSE
							END IF
							
							//Segundo insert
							li_cs_estilocolortono_new2=li_cs_estilocolton + 2
							ll_ca_unidades2=ll_caxestilo
							ll_ca_numerada2=ll_ca_numerada_origen
							li_sw_partida2=0
							ldt_fechahora = f_fecha_servidor()
							
							INSERT INTO dt_libera_estilos  
								( co_fabrica_exp,  	pedido,			  		cs_liberacion,   		nu_orden,   
								  nu_cut,   		  	co_fabrica,   		  	co_linea,   		  	co_referencia,   
								  co_color_pt,   		tono,   					cs_estilocolortono,  yield,   
								  ca_unidades,   		porc_unid_libera,   	color_id,   			pedido_po,   
								  co_estado_material,cs_ordenpd_pt,   		comentarios,   	  	tipo_corte,   
								  fe_creacion,   		fe_actualizacion,   	
								  usuario,   			instancia,   
								  ca_numerada,   		sw_partida, cs_origen )  
							VALUES ( :li_co_fabrica_exp,:ll_pedido,   			:ll_cs_liberacion,   :ls_nu_orden,   
								  :ls_nu_cut,   		:li_co_fabrica_ref,  :li_co_linea_ref,   	:ll_co_referencia,   
								  :ll_color_pt,   	:ls_tono,   		  	:li_cs_estilocolortono_new2,:ldb_yield,   
								  :ll_ca_unidades2,  :ldb_porc_unid_libera_origen,:ll_color_id,   	  	:ll_pedido_po,   
								  :li_co_estado_material,:ll_cs_ordenpd_pt,:ls_comentarios,    :ls_tipo_corte,   
								  :ldt_fechahora,  :ldt_fechahora,
								  :gstr_info_usuario.codigo_usuario,   
								  :gstr_info_usuario.instancia,:ll_ca_numerada2,:li_sw_partida2,1 )  ;
								  
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo insertar segunda secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala original")
								ROLLBACK;
								Return
								
							ELSE
							END IF
							
							//actualiza dt_telaxmodelo_lib
													
							
							//insertaci$$HEX1$$f300$$ENDHEX$$n # 1 en telas
							
							ll_ca_unidades_tela1	=ll_ca_unidades1
							ldb_ca_tela1			=ldb_ca_tela_original
							ll_ca_numerada_tela1	=ll_ca_numeradaxtela
							
							INSERT INTO dt_telaxmodelo_lib  
								( co_fabrica_exp,   							  	pedido,   						  	cs_liberacion,   
								  nu_orden,   							  			nu_cut,   						  	co_fabrica_pt,   
								  co_linea,   							  			co_referencia,  				  	co_color_pt,   
								  tono,   							  				cs_estilocolortono,   		  	co_modelo,   
								  co_fabrica_tela,   						  	co_reftel,   						co_caract,   
								  diametro,   							  			co_color_tela,   				  	ancho_cortable,   
								  tono_tela,   							  		raya,   						  		ca_unidades,   
								  yield,   						  					ca_tela,   						  	fe_creacion,   
								  fe_actualizacion,   						  	usuario,   						  	instancia,   
								  ca_numerada,cs_origen )  
							VALUES ( :li_co_fabrica_exp,   					  	:ll_pedido,   						:ll_cs_liberacion,   
								  :ls_nu_orden,   							  	:ls_nu_cut,   						:li_co_fabrica_ref,   
								  :li_co_linea_ref,   						  	:ll_co_referencia,   		   :ll_color_pt,   
								  :ls_tono,   							  			:li_cs_estilocolortono_new1,  :ll_co_modelo,   
								  :ii_co_fabrica_tela,   					   :il_co_reftel,   				  	:li_co_caract,   
								  :ii_diametro,   						  		:il_co_color_te,   		   	:idb_ancho_cortable,   
								  :ls_tono_tela,   							   :li_raya,   						:ll_ca_unidades_tela1,   
								  :ldb_yieldxtela,   							  		:ldb_ca_tela1,   				   :ldt_fechahora,   
								  :ldt_fechahora,   						 	:gstr_info_usuario.codigo_usuario,   
								  :gstr_info_usuario.instancia,   
								  :ll_ca_numerada_tela1,1 )  ;
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo insertar datos de tela de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
								ROLLBACK;
								Return
							ELSE
							END IF
											
							//insertaci$$HEX1$$f300$$ENDHEX$$n # 2 en telas
													
							ll_ca_unidades_tela2	=ll_ca_unidades2
							ldb_ca_tela2			=ldb_ca_tela_original
							ll_ca_numerada_tela2	=ll_ca_numeradaxtela
							
							INSERT INTO dt_telaxmodelo_lib  
								( co_fabrica_exp,   							  	pedido,   						  	cs_liberacion,   
								  nu_orden,   							  			nu_cut,   						  	co_fabrica_pt,   
								  co_linea,   							  			co_referencia,  				  	co_color_pt,   
								  tono,   							  				cs_estilocolortono,   		  	co_modelo,   
								  co_fabrica_tela,   						  	co_reftel,   						co_caract,   
								  diametro,   							  			co_color_tela,   				  	ancho_cortable,   
								  tono_tela,   							  		raya,   						  		ca_unidades,   
								  yield,   						  					ca_tela,   						  	fe_creacion,   
								  fe_actualizacion,   						  	usuario,   						  	instancia,   
								  ca_numerada ,cs_origen)  
							VALUES ( :li_co_fabrica_exp,   					  	:ll_pedido,   						:ll_cs_liberacion,   
								  :ls_nu_orden,   							  	:ls_nu_cut,   						:li_co_fabrica_ref,   
								  :li_co_linea_ref,   						  	:ll_co_referencia,   		   :ll_color_pt,   
								  :ls_tono,   							  			:li_cs_estilocolortono_new2,  :ll_co_modelo,   
								  :ii_co_fabrica_tela,   					   :il_co_reftel,   				  	:li_co_caract,   
								  :ii_diametro,   						  		:il_co_color_te,   		   	:idb_ancho_cortable,   
								  :ls_tono_tela,   							   :li_raya,   						:ll_ca_unidades_tela2,   
								  :ldb_yieldxtela,   							:ldb_ca_tela2,   				   :ldt_fechahora,   
								  :ldt_fechahora,   						 		:gstr_info_usuario.codigo_usuario,
								  :gstr_info_usuario.instancia,   
								  :ll_ca_numerada_tela2 ,1)  ;
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo insertar datos de tela de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
								ROLLBACK;
								Return
							ELSE
							END IF
							
							//actualizar el sw_partir de la tabla dt_libera_estilos
							UPDATE dt_libera_estilos  
							  SET sw_partida = 1  
							WHERE ( dt_libera_estilos.co_fabrica_exp 			= :li_co_fabrica_exp ) 	AND  
									( dt_libera_estilos.pedido 					= :ll_pedido ) 			AND  
									( dt_libera_estilos.cs_liberacion 			= :ll_cs_liberacion ) 	AND  
									( dt_libera_estilos.nu_orden 					= :ls_nu_orden ) AND  
									( dt_libera_estilos.co_fabrica 				= :li_co_fabrica_ref ) AND  
									( dt_libera_estilos.co_linea 					= :li_co_linea_ref ) AND  
									( dt_libera_estilos.co_referencia 			= :ll_co_referencia ) AND  
									( dt_libera_estilos.co_color_pt 				= :ll_color_pt ) AND  
									( dt_libera_estilos.tono 						= :ls_tono ) AND  
									( dt_libera_estilos.cs_estilocolortono 	= :li_cs_estilocolton );
									
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo actualizar la partici$$HEX1$$f300$$ENDHEX$$n en la escala original")
								ROLLBACK;
								Return
							ELSE
							END IF
											
							//debe hacer cursor de tabla temporal con datos de escala a partir por usuario
							DECLARE cur_tallas CURSOR FOR
							SELECT t_dt_escalasxtela.co_talla,   
									 t_dt_escalasxtela.ca_proporcion,   
									 t_dt_escalasxtela.ca_unidades,    
									 t_dt_escalasxtela.ca_numerada,   
									 t_dt_escalasxtela.ca_a_sacar,
									 t_dt_escalasxtela.ca_a_dejar
							 FROM t_dt_escalasxtela  
							WHERE t_dt_escalasxtela.usuario =:gstr_info_usuario.codigo_usuario;
							
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo declarar busqueda de  datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
								ROLLBACK;
								Return
							ELSE
							END IF
		
							OPEN cur_tallas;
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo abrir la busqueda de  datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
								ROLLBACK;
								Return
							ELSE
							END IF
							
							FETCH cur_tallas INTO :li_co_talla,:li_ca_proporcion,:ll_ca_liberadas,:ll_ca_numeradas,:ll_ca_a_sacar,:ll_ca_a_dejar;
							IF SQLCA.SQLCODE=-1 THEN
								MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
								ROLLBACK;
								Return
							ELSE
							END IF
							
							DO WHILE SQLCA.SQLCODE=0 
								
								//actualiza dt_escalasxtela
								
								//trae datos de dt_escalasxtela original
								SELECT dt_escalasxtela.nu_cut,   			dt_escalasxtela.co_modelo,   
										dt_escalasxtela.co_caract, 			dt_escalasxtela.ancho_cortable,   
										dt_escalasxtela.ca_proporcion,		dt_escalasxtela.ca_unidades,   
										dt_escalasxtela.co_estado_material, dt_escalasxtela.raya,   
										dt_escalasxtela.ca_numerada  
								 INTO :ls_nu_cut_talla_original,   			:ll_co_modelo_esc_original,   
										:li_co_caract_escalas_original,   	:ldb_ancho_cortable_esc_orig,   
										:ldb_ca_proporcion_esc_orig,   		:ll_ca_unidades_esc_orig,   
										:li_co_estado_material_orig,   		:li_raya_esc_orig,   
										:li_ca_numerada_esc_orig  
								 FROM dt_escalasxtela  
								WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
										( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
										( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
										( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
										( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
										( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
										( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
										( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
										( dt_escalasxtela.tono 						= :ls_tono ) AND  
										( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
										( dt_escalasxtela.co_fabrica_tela 		= :ii_co_fabrica_tela ) AND  
										( dt_escalasxtela.co_reftel 				= :il_co_reftel ) AND  
										( dt_escalasxtela.diametro 				= :ii_diametro ) AND  
										( dt_escalasxtela.co_color_tela 			= :il_co_color_te ) AND  
										( dt_escalasxtela.co_talla 				= :li_co_talla )   ;
		
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo traer datos de tallas originales de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF
								
								IF ll_ca_a_sacar > 0 THEN
									//coloca sw_partida=1 a dt_escalasxtela de escala original
									UPDATE dt_escalasxtela SET sw_partida=1
									WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
											( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
											( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
											( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
											( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
											( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
											( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
											( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
											( dt_escalasxtela.tono 						= :ls_tono ) AND  
											( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
											( dt_escalasxtela.co_fabrica_tela 		= :ii_co_fabrica_tela ) AND  
											( dt_escalasxtela.co_reftel 				= :il_co_reftel ) AND  
											( dt_escalasxtela.diametro 				= :ii_diametro ) AND  
											( dt_escalasxtela.co_color_tela 			= :il_co_color_te ) AND  
											( dt_escalasxtela.co_talla 				= :li_co_talla )   ;
			
									IF SQLCA.SQLCODE=-1 THEN
										MessageBox("Error Base Datos","No pudo traer datos de tallas originales de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala")
										ROLLBACK;
										Return
									ELSE
									END IF	
								ELSE
								END IF
								
								
								//inserta en dt_escalasxtela
								
								//insert escalas 1
								li_cs_estilocolortono_esc1		=li_cs_estilocolortono_new1
								ldb_ca_proporcionxtalla			=ldb_ca_proporcion_esc_orig
								ll_ca_unidadesxtalla_esc1		=ll_ca_a_dejar
								li_co_estado_material_talla	=li_co_estado_material_orig
								li_raya_talla						=li_raya_esc_orig
								ll_ca_numerada_esc1				=li_ca_numerada_esc_orig
								li_sw_talla_partida				=0
								
								IF ll_ca_a_dejar > 0 THEN
									
									INSERT INTO dt_escalasxtela  
											( co_fabrica_exp, 						pedido,   							cs_liberacion,   
											  nu_orden,   								nu_cut,   							co_fabrica_pt,   
											  co_linea,   								co_referencia,   					co_color_pt,   
											  tono,   								  	cs_estilocolortono,   			co_modelo,   
											  co_fabrica_tela,   					co_reftel,   						co_caract,   
											  diametro,   								co_color_tela,   					co_talla,   
											  ancho_cortable,   						ca_proporcion,   					ca_unidades,   
											  co_estado_material,   				raya,   								fe_creacion,   
											  fe_actualizacion,   					usuario,   							instancia,   
											  ca_numerada,sw_partida,cs_origen )  
								  VALUES ( :li_co_fabrica_exp,   			  :ll_pedido,   					  :ll_cs_liberacion,   
											  :ls_nu_orden,   					  :ls_nu_cut_escalas,   		  :li_co_fabrica_ref,   
											  :li_co_linea_ref,   				  :ll_co_referencia,   			  :ll_color_pt,   
											  :ls_tono,   						  	  :li_cs_estilocolortono_esc1,  :ll_co_modelo,   
											  :ii_co_fabrica_tela,   			  :il_co_reftel,   				  :li_co_caract,   
											  :ii_diametro,   					  :il_co_color_te,   			  :li_co_talla,   
											  :idb_ancho_cortable,   			  :ldb_ca_proporcionxtalla,     :ll_ca_unidadesxtalla_esc1,   
											  :li_co_estado_material_talla,	  :li_raya_talla,					  :ldt_fechahora,   
											  :ldt_fechahora,   				  	  :gstr_info_usuario.codigo_usuario,   
											  :gstr_info_usuario.instancia,   
											  :ll_ca_numerada_esc1,:li_sw_talla_partida,1 )  ;
									
									IF SQLCA.SQLCODE=-1 THEN
										MessageBox("Error Base Datos","No pudo insertar datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
										ROLLBACK;
										Return
									ELSE
									END IF	
									
								ELSE
								END IF
								
								
								IF ll_ca_a_sacar > 0 THEN
									
									//insert escalas 2
									li_cs_estilocolortono_esc2		=li_cs_estilocolortono_new2
									ll_ca_unidadesxtalla_esc2		=ll_ca_a_sacar
									ll_ca_numerada_esc2				=li_ca_numerada_esc_orig
									
									INSERT INTO dt_escalasxtela  
											( co_fabrica_exp, 						pedido,   							cs_liberacion,   
											  nu_orden,   								nu_cut,   							co_fabrica_pt,   
											  co_linea,   								co_referencia,   					co_color_pt,   
											  tono,   								  	cs_estilocolortono,   			co_modelo,   
											  co_fabrica_tela,   					co_reftel,   						co_caract,   
											  diametro,   								co_color_tela,   					co_talla,   
											  ancho_cortable,   						ca_proporcion,   					ca_unidades,   
											  co_estado_material,   				raya,   								fe_creacion,   
											  fe_actualizacion,   					usuario,   							instancia,   
											  ca_numerada,sw_partida,cs_origen )  
								  VALUES ( :li_co_fabrica_exp,   			  :ll_pedido,   					  :ll_cs_liberacion,   
											  :ls_nu_orden,   					  :ls_nu_cut_escalas,   		  :li_co_fabrica_ref,   
											  :li_co_linea_ref,   				  :ll_co_referencia,   			  :ll_color_pt,   
											  :ls_tono,   						  	  :li_cs_estilocolortono_esc2,  :ll_co_modelo,   
											  :ii_co_fabrica_tela,   			  :il_co_reftel,   				  :li_co_caract,   
											  :ii_diametro,   					  :il_co_color_te,   			  :li_co_talla,   
											  :idb_ancho_cortable,   			  :ldb_ca_proporcionxtalla,     :ll_ca_unidadesxtalla_esc2,   
											  :li_co_estado_material_talla,	  :li_raya_talla,					  :ldt_fechahora,   
											  :ldt_fechahora,   				  	  :gstr_info_usuario.codigo_usuario,   
											  :gstr_info_usuario.instancia,   
											  :ll_ca_numerada_esc2,:li_sw_talla_partida,1 )  ;
											  
									IF SQLCA.SQLCODE=-1 THEN
										MessageBox("Error Base Datos","No pudo insertar datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
										ROLLBACK;
										Return
									ELSE
									END IF	
									
								ELSE
								END IF
								
								
								FETCH cur_tallas INTO :li_co_talla,:li_ca_proporcion,:ll_ca_liberadas,:ll_ca_numeradas,:ll_ca_a_sacar,:ll_ca_a_dejar;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF
								
							LOOP
//------------------  fin de crear partici$$HEX1$$f300$$ENDHEX$$n para secuencia 1  -----------------------------------------------//


//---------  inicio de asentar transacci$$HEX1$$f300$$ENDHEX$$n y hacer retrieve con la $$HEX1$$fa00$$ENDHEX$$ltima partici$$HEX1$$f300$$ENDHEX$$n secuencia particion 1------//
							COMMIT;
														
							//hacer retrieve con $$HEX1$$fa00$$ENDHEX$$ltima secuencia
							ll_hallados = dw_maestro.Retrieve(li_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
									 ls_nu_orden,&
									 li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
									 ll_color_pt,&
									 ls_tono,&
									 li_cs_estilocolortono_esc2)
																	 
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
				
										
										IF wf_trae_tela( li_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
																 ls_nu_orden,&
																 li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																 ll_color_pt,&
																 ls_tono,&
																 li_cs_estilocolortono_esc2) =1 THEN
																		 
										ELSE
											MessageBox("Error Datos","No pudo traer enlace de tela para la escala")
											Return
										END IF
										
				
										ll_hallados = dw_detalle.Retrieve(li_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
																		 ls_nu_orden,&
																		 li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																		 ll_color_pt,&
																		 ls_tono,&
																		 li_cs_estilocolortono_esc2,&
																		 ii_co_fabrica_tela,il_co_reftel,ii_diametro,il_co_color_te,&
																		 idb_ancho_cortable)
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
												MessageBox("Sin Datos","No hay datos para su criterio",&
															 Exclamation!,Ok!)
											CASE ELSE
												il_fila_actual_detalle = 1
				
											END CHOOSE
										END IF
				
								END CHOOSE
							END IF							
//---------  fin de asentar transacci$$HEX1$$f300$$ENDHEX$$n y hacer retrieve con la $$HEX1$$fa00$$ENDHEX$$ltima partici$$HEX1$$f300$$ENDHEX$$n secuencia particion 1------//



ELSE //la secuencia es > 1, es una partici$$HEX1$$f300$$ENDHEX$$n de escala no original ///////////////////////// 
							
							
							
//------------------  inicio de crear partici$$HEX1$$f300$$ENDHEX$$n para secuencia mayor que 1  ----------------------------------//
							
								// actualiza dt_libera_estilos
								ll_ca_unidades1=ll_ca_unidades - ll_caxestilo
								// actualiza el anterior restando
								UPDATE dt_libera_estilos  
								  SET ca_unidades = :ll_ca_unidades1  
								WHERE ( dt_libera_estilos.co_fabrica_exp 			= :li_co_fabrica_exp ) AND  
										( dt_libera_estilos.pedido 					= :ll_pedido ) AND  
										( dt_libera_estilos.cs_liberacion 			= :ll_cs_liberacion ) AND  
										( dt_libera_estilos.nu_orden 					= :ls_nu_orden ) AND  
										( dt_libera_estilos.co_fabrica 				= :li_co_fabrica_ref ) AND  
										( dt_libera_estilos.co_linea 					= :li_co_linea_ref ) AND  
										( dt_libera_estilos.co_referencia 			= :ll_co_referencia ) AND  
										( dt_libera_estilos.co_color_pt 				= :ll_color_pt ) AND  
										( dt_libera_estilos.tono 						= :ls_tono ) AND  
										( dt_libera_estilos.cs_estilocolortono 	= :li_cs_estilocolton );
										
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo actualizar la escala original")
									ROLLBACK;
									Return
									
								ELSE
								END IF		

								//inserta el nuevo con sec max + 1
								SELECT MAX(cs_estilocolortono)
								INTO	 :li_cs_max_particion
								FROM   dt_libera_estilos
								WHERE ( dt_libera_estilos.co_fabrica_exp 			= :li_co_fabrica_exp ) AND  
										( dt_libera_estilos.pedido 					= :ll_pedido ) AND  
										( dt_libera_estilos.cs_liberacion 			= :ll_cs_liberacion ) AND  
										( dt_libera_estilos.nu_orden 					= :ls_nu_orden ) AND  
										( dt_libera_estilos.co_fabrica 				= :li_co_fabrica_ref ) AND  
										( dt_libera_estilos.co_linea 					= :li_co_linea_ref ) AND  
										( dt_libera_estilos.co_referencia 			= :ll_co_referencia ) AND  
										( dt_libera_estilos.co_color_pt 				= :ll_color_pt ) AND  
										( dt_libera_estilos.tono 						= :ls_tono ) ;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo buscar la secuencia siguiente para la partici$$HEX1$$f300$$ENDHEX$$n")
									ROLLBACK;
									Return
								ELSE
								END IF	
								
								IF ISNULL(li_cs_max_particion) THEN
									MessageBox("Error Datos","La secuencia siguiente para la partici$$HEX1$$f300$$ENDHEX$$n es nula")
									ROLLBACK;
									Return
								ELSE
									li_cs_max_particion=li_cs_max_particion + 1
								END IF
								
								//insert
																
								ll_ca_numerada1=ll_ca_numerada_origen
								li_sw_partida1=0
								ldt_fechahora = f_fecha_servidor()
								
								INSERT INTO dt_libera_estilos  
									( co_fabrica_exp,  	pedido,			  		cs_liberacion,   		nu_orden,   
									  nu_cut,   		  	co_fabrica,   		  	co_linea,   		  	co_referencia,   
									  co_color_pt,   		tono,   					cs_estilocolortono,  yield,   
									  ca_unidades,   		porc_unid_libera,   	color_id,   			pedido_po,   
									  co_estado_material,cs_ordenpd_pt,   		comentarios,   	  	tipo_corte,   
									  fe_creacion,   		fe_actualizacion,   	
									  usuario,   				instancia,   
									  ca_numerada,   		sw_partida,cs_origen )  
								VALUES ( :li_co_fabrica_exp,:ll_pedido,   			:ll_cs_liberacion,   :ls_nu_orden,   
									  :ls_nu_cut,   		:li_co_fabrica_ref,  :li_co_linea_ref,   	:ll_co_referencia,   
									  :ll_color_pt,   	:ls_tono,   		  	:li_cs_max_particion,:ldb_yield,   
									  :ll_caxestilo,  	:ldb_porc_unid_libera_origen,:ll_color_id,   	  	:ll_pedido_po,   
									  :li_co_estado_material,:ll_cs_ordenpd_pt,:ls_comentarios,    :ls_tipo_corte,   
									  :ldt_fechahora,  :ldt_fechahora,
									  :gstr_info_usuario.codigo_usuario,   
									  :gstr_info_usuario.instancia,:ll_ca_numerada1,:li_sw_partida1,:li_cs_estilocolton )  ;
									  
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo insertar primera secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala original")
									ROLLBACK;
									Return
									
								ELSE
								END IF
							//actualiza dt_telaxmodelo_lib
							
								//actualiza el anterior restando
								UPDATE dt_telaxmodelo_lib  
								  SET ca_unidades = :ll_ca_unidades1  
								WHERE ( dt_telaxmodelo_lib.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
										( dt_telaxmodelo_lib.pedido 					=:ll_pedido  ) AND  
										( dt_telaxmodelo_lib.cs_liberacion 			=:ll_cs_liberacion  ) AND  
										( dt_telaxmodelo_lib.nu_orden 				=:ls_nu_orden  ) AND  
										( dt_telaxmodelo_lib.co_fabrica_pt 			=:li_co_fabrica_ref  ) AND  
										( dt_telaxmodelo_lib.co_linea 				=:li_co_linea_ref  ) AND  
										( dt_telaxmodelo_lib.co_referencia 			=:ll_co_referencia  ) AND  
										( dt_telaxmodelo_lib.co_color_pt 			=:ll_color_pt  ) AND  
										( dt_telaxmodelo_lib.tono 						=:ls_tono  ) AND  
										( dt_telaxmodelo_lib.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
										( dt_telaxmodelo_lib.co_fabrica_tela 		=:ii_co_fabrica_tela ) AND  
										( dt_telaxmodelo_lib.co_reftel 				=:il_co_reftel  ) AND  
										( dt_telaxmodelo_lib.diametro 				=:ii_diametro  ) AND  
										( dt_telaxmodelo_lib.co_color_tela 			=:il_co_color_te  ) AND  
										( dt_telaxmodelo_lib.ancho_cortable 		=:idb_ancho_cortable  )   ;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo actualizar los datos de tela de la partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF

								//inserta el nuevo con sec + 1
								ll_ca_unidades_tela1	=ll_ca_unidades1
								ldb_ca_tela1			=ldb_ca_tela_original
								ll_ca_numerada_tela1	=ll_ca_numeradaxtela
								
								INSERT INTO dt_telaxmodelo_lib  
									( co_fabrica_exp,   							  	pedido,   						  	cs_liberacion,   
									  nu_orden,   							  			nu_cut,   						  	co_fabrica_pt,   
									  co_linea,   							  			co_referencia,  				  	co_color_pt,   
									  tono,   							  				cs_estilocolortono,   		  	co_modelo,   
									  co_fabrica_tela,   						  	co_reftel,   						co_caract,   
									  diametro,   							  			co_color_tela,   				  	ancho_cortable,   
									  tono_tela,   							  		raya,   						  		ca_unidades,   
									  yield,   						  					ca_tela,   						  	fe_creacion,   
									  fe_actualizacion,   						  	usuario,   						  	instancia,   
									  ca_numerada ,cs_origen)  
								VALUES ( :li_co_fabrica_exp,   					  	:ll_pedido,   						:ll_cs_liberacion,   
									  :ls_nu_orden,   							  	:ls_nu_cut,   						:li_co_fabrica_ref,   
									  :li_co_linea_ref,   						  	:ll_co_referencia,   		   :ll_color_pt,   
									  :ls_tono,   							  			:li_cs_max_particion,  			:ll_co_modelo,   
									  :ii_co_fabrica_tela,   					   :il_co_reftel,   				  	:li_co_caract,   
									  :ii_diametro,   						  		:il_co_color_te,   		   	:idb_ancho_cortable,   
									  :ls_tono_tela,   							   :li_raya,   						:ll_caxestilo,   
									  :ldb_yieldxtela,   							:ldb_ca_tela1,   				   :ldt_fechahora,   
									  :ldt_fechahora,   						 		:gstr_info_usuario.codigo_usuario,   
									  :gstr_info_usuario.instancia,   
									  :ll_ca_numerada_tela1 ,:li_cs_estilocolton)  ;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo insertar datos de tela de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF
								
								
								//actualiza dt_escalasxtela
								
								//debe hacer cursor de tabla temporal con datos de escala a partir por usuario
								DECLARE cur_tallas_hijas CURSOR FOR
								SELECT t_dt_escalasxtela.co_talla,   
										 t_dt_escalasxtela.ca_proporcion,   
										 t_dt_escalasxtela.ca_unidades,    
										 t_dt_escalasxtela.ca_numerada,   
										 t_dt_escalasxtela.ca_a_sacar,
										 t_dt_escalasxtela.ca_a_dejar
								 FROM t_dt_escalasxtela  
								WHERE t_dt_escalasxtela.usuario =:gstr_info_usuario.codigo_usuario;
								
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo declarar busqueda de  datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF
			
								OPEN cur_tallas_hijas;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo abrir la busqueda de  datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF
								
								FETCH cur_tallas_hijas INTO :li_co_talla,:li_ca_proporcion,:ll_ca_liberadas,:ll_ca_numeradas,:ll_ca_a_sacar,:ll_ca_a_dejar;
								IF SQLCA.SQLCODE=-1 THEN
									MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
									ROLLBACK;
									Return
								ELSE
								END IF
								
								DO WHILE SQLCA.SQLCODE=0 
									
									//actualiza dt_escalasxtela
									
									//trae datos de dt_escalasxtela original
									SELECT dt_escalasxtela.nu_cut,   								dt_escalasxtela.co_modelo,   
											dt_escalasxtela.co_caract, 								dt_escalasxtela.ancho_cortable,   
											dt_escalasxtela.ca_proporcion,							dt_escalasxtela.ca_unidades,   
											dt_escalasxtela.co_estado_material,   					dt_escalasxtela.raya,   
											dt_escalasxtela.ca_numerada  
									 INTO :ls_nu_cut_talla_original,   								:ll_co_modelo_esc_original,   
											:li_co_caract_escalas_original,   						:ldb_ancho_cortable_esc_orig,   
											:ldb_ca_proporcion_esc_orig,   							:ll_ca_unidades_esc_orig,   
											:li_co_estado_material_orig,   							:li_raya_esc_orig,   
											:li_ca_numerada_esc_orig  
									 FROM dt_escalasxtela  
									WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
											( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
											( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
											( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
											( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
											( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
											( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
											( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
											( dt_escalasxtela.tono 						= :ls_tono ) AND  
											( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
											( dt_escalasxtela.co_fabrica_tela 		= :ii_co_fabrica_tela ) AND  
											( dt_escalasxtela.co_reftel 				= :il_co_reftel ) AND  
											( dt_escalasxtela.diametro 				= :ii_diametro ) AND  
											( dt_escalasxtela.co_color_tela 			= :il_co_color_te ) AND  
											( dt_escalasxtela.co_talla 				= :li_co_talla )   ;
			
									IF SQLCA.SQLCODE=-1 THEN
										MessageBox("Error Base Datos","No pudo traer datos de tallas originales de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala")
										ROLLBACK;
										Return
									ELSE
									END IF
									//actualiza restando de la original y si la cant. resultante es cero, entonces borra del orig.
									IF ll_ca_a_dejar > 0 THEN
										UPDATE dt_escalasxtela  
										  SET ca_unidades = :ll_ca_a_dejar, 
										      sw_partida	= 1,
												cs_origen =:li_cs_estilocolton
										WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
												( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
												( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
												( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
												( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
												( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
												( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
												( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
												( dt_escalasxtela.tono 						= :ls_tono ) AND  
												( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
												( dt_escalasxtela.co_fabrica_tela 		= :ii_co_fabrica_tela ) AND  
												( dt_escalasxtela.co_reftel 				= :il_co_reftel ) AND  
												( dt_escalasxtela.diametro 				= :ii_diametro ) AND  
												( dt_escalasxtela.co_color_tela 			= :il_co_color_te ) AND  
												( dt_escalasxtela.co_talla 				= :li_co_talla )   ;  
										IF SQLCA.SQLCODE=-1 THEN
											MessageBox("Error Base Datos","No pudo actualizar unidades de partici$$HEX1$$f300$$ENDHEX$$n de escala")
											ROLLBACK;
											Return
										ELSE
										END IF
									ELSE
										DELETE FROM dt_escalasxtela  
										WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
												( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
												( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
												( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
												( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
												( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
												( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
												( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
												( dt_escalasxtela.tono 						= :ls_tono ) AND  
												( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolton ) AND  
												( dt_escalasxtela.co_fabrica_tela 		= :ii_co_fabrica_tela ) AND  
												( dt_escalasxtela.co_reftel 				= :il_co_reftel ) AND  
												( dt_escalasxtela.diametro 				= :ii_diametro ) AND  
												( dt_escalasxtela.co_color_tela 			= :il_co_color_te ) AND  
												( dt_escalasxtela.co_talla 				= :li_co_talla )   ;  
										IF SQLCA.SQLCODE=-1 THEN
											MessageBox("Error Base Datos","No borrar actualizar unidades de partici$$HEX1$$f300$$ENDHEX$$n de escala")
											ROLLBACK;
											Return
										ELSE
										END IF
									END IF
									
									//inserta en dt_escalasxtela
									
									//insert escalas 1
									li_cs_estilocolortono_esc1		=li_cs_estilocolortono_new1
									ldb_ca_proporcionxtalla			=ldb_ca_proporcion_esc_orig
									ll_ca_unidadesxtalla_esc1		=ll_ca_a_sacar
									li_co_estado_material_talla	=li_co_estado_material_orig
									li_raya_talla						=li_raya_esc_orig
									ll_ca_numerada_esc1				=li_ca_numerada_esc_orig
									
									IF ll_ca_a_sacar > 0 THEN
										
										INSERT INTO dt_escalasxtela  
												( co_fabrica_exp, 						pedido,   							cs_liberacion,   
												  nu_orden,   								nu_cut,   							co_fabrica_pt,   
												  co_linea,   								co_referencia,   					co_color_pt,   
												  tono,   								  	cs_estilocolortono,   			co_modelo,   
												  co_fabrica_tela,   					co_reftel,   						co_caract,   
												  diametro,   								co_color_tela,   					co_talla,   
												  ancho_cortable,   						ca_proporcion,   					ca_unidades,   
												  co_estado_material,   				raya,   								fe_creacion,   
												  fe_actualizacion,   					usuario,   							instancia,   
												  ca_numerada ,sw_partida,cs_origen)  
									  VALUES ( :li_co_fabrica_exp,   			  :ll_pedido,   					  :ll_cs_liberacion,   
												  :ls_nu_orden,   					  :ls_nu_cut_escalas,   		  :li_co_fabrica_ref,   
												  :li_co_linea_ref,   				  :ll_co_referencia,   			  :ll_color_pt,   
												  :ls_tono,   						  	  :li_cs_max_particion,  		  :ll_co_modelo,   
												  :ii_co_fabrica_tela,   			  :il_co_reftel,   				  :li_co_caract,   
												  :ii_diametro,   					  :il_co_color_te,   			  :li_co_talla,   
												  :idb_ancho_cortable,   			  :ldb_ca_proporcionxtalla,     :ll_ca_unidadesxtalla_esc1,   
												  :li_co_estado_material_talla,	  :li_raya_talla,					  :ldt_fechahora,   
												  :ldt_fechahora,   				  	  :gstr_info_usuario.codigo_usuario,   
												  :gstr_info_usuario.instancia,   
												  :ll_ca_numerada_esc1,0 ,1)  ;
										
										IF SQLCA.SQLCODE=-1 THEN
											MessageBox("Error Base Datos","No pudo insertar datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
											ROLLBACK;
											Return
										ELSE
										END IF	
										
									ELSE
									END IF
																
									// Lee siguiente registro de t_dt_escalasxtela
									FETCH cur_tallas_hijas INTO :li_co_talla,:li_ca_proporcion,:ll_ca_liberadas,:ll_ca_numeradas,:ll_ca_a_sacar,:ll_ca_a_dejar;
									IF SQLCA.SQLCODE=-1 THEN
										MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia  de partici$$HEX1$$f300$$ENDHEX$$n de escala")
										ROLLBACK;
										Return
									ELSE
									END IF	
//------------------  FIN de crear partici$$HEX1$$f300$$ENDHEX$$n para secuencia mayor que 1  ----------------------------------//
									
								LOOP
								
								
								
//--------------  INICIO de asentar transacci$$HEX1$$f300$$ENDHEX$$n y hacer retrieve con la $$HEX1$$fa00$$ENDHEX$$ltima partici$$HEX1$$f300$$ENDHEX$$n secuencia  ----------//
								COMMIT;	
							
							//hacer retrieve con $$HEX1$$fa00$$ENDHEX$$ltima secuencia
							ll_hallados = dw_maestro.Retrieve(li_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
																	 ls_nu_orden,&
																	 li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																	 ll_color_pt,&
																	 ls_tono,&
																	 li_cs_max_particion)
																	 
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
					
											
											IF wf_trae_tela( li_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
																	 ls_nu_orden,&
																	 li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																	 ll_color_pt,&
																	 ls_tono,&
																	 li_cs_max_particion) =1 THEN
																			 
											ELSE
												MessageBox("Error Datos","No pudo traer enlace de tela para la escala")
												Return
											END IF
											
					
											ll_hallados = dw_detalle.Retrieve(li_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
																			 ls_nu_orden,&
																			 li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
																			 ll_color_pt,&
																			 ls_tono,&
																			 li_cs_max_particion,&
																			 ii_co_fabrica_tela,il_co_reftel,ii_diametro,il_co_color_te,&
																			 idb_ancho_cortable)
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
													MessageBox("Sin Datos","No hay datos para su criterio",&
																 Exclamation!,Ok!)
												CASE ELSE
													il_fila_actual_detalle = 1
					
												END CHOOSE
											END IF
					
									END CHOOSE
								END IF
	//--------------  fin de asentar transacci$$HEX1$$f300$$ENDHEX$$n y hacer retrieve con la $$HEX1$$fa00$$ENDHEX$$ltima partici$$HEX1$$f300$$ENDHEX$$n secuencia  ----------//
							END IF

// ************************************************************************************** // 
							// ---------- Inicio Actualizacion Datos Programacion Produccion 102
							//
							// Organiza Datos Programacion de Producciom (102) si existe
							// 1. Borra programacion diaria de liberacion original
							// 2. Borra escalas de programacion de produccion de liberacion original
							// 3. Actualiza cantidades en parametros de programacion de la 
							//    liberacion original y si esta es 1 forza el valor 2 en la liberacion
							// 4. Crea las escalas de programacion de produccion con base en la nueva
							//    escala de liberacion
							// 5. Llama pantalla para pedir Simulacion /Fabrica/Modulo destino de la 
							//    nueva liberacion 
							// 6. Crea Parametros de Programacion con base Parametros de liberacion
							//    original
							// 7. Crea las escalas de programacion de produccion con base en la nueva
							//    Escala de liberacion
							// ------------------------
							// NOTA : Queda el interrogante de como se manejaran las unidades producidas
							// ------------------------

								
				// Busca Fabrica / Planta / Modulo en Parametros de Programacion
				SELECT 
				co_fabrica, 
				co_planta, 
				co_modulo, 
				cs_prioridad, 
				cs_particion, 
				fuente_dato, 
				co_estado_merc, 
				simulacion,
				co_estado_asigna,
				co_curva,
				fe_inicio_prog,
				fe_fin_prog,
				fe_requerida_desp,
				ca_minutos_std,
				co_tipo_asignacion,
				ca_personasxmod,
				cod_tur,
				minutos_jornada,
				ind_cambio_estilo,
				ca_unid_base_dia,
				orige_uni_base_dia,
				tipo_empate,
				unidades_empate,
				metodo_programa,
				fe_entra_pdn,
				tipo_fe_prog,
				fe_lim_prog,
				fe_desp_programada,
				indicativo_base,
				ca_base_dia_prod,
				ca_base_dia_prog,
				ca_a_programar,
				fe_fogueo,
				fe_trabajo,
				cs_asignacion,
				pedido_po
				
				INTO	:li_co_fabrica_modu, 
				:li_co_planta_modu, 
				:li_co_modulo, 
				:li_cs_prioridad,
				:li_cs_particion, 
				:li_fuente_dato, 
				:ls_co_estado_merc, 
				:li_simulacion,
				:li_co_estado_asigna,
				:li_co_curva,
				:ldt_fe_inicio_prog,
				:ldt_fe_fin_prog,
				:ldt_fe_requerida_desp,
				:ld_ca_minutos_std,
				:li_co_tipo_asignacion,
				:ld_ca_personasxmod,
				:li_cod_tur,
				:ld_minutos_jornada,
				:li_ind_cambio_estilo,
				:li_ca_unid_base_dia,
				:li_orige_uni_base_dia,
				:li_tipo_empate,
				:li_unidades_empate,
				:li_metodo_programa,
				:ldt_fe_entra_pdn,
				:li_tipo_fe_prog,
				:ldt_fe_lim_prog,
				:ldt_fe_desp_programada,
				:li_indicativo_base,
				:li_ca_base_dia_prod,
				:li_ca_base_dia_prog,
				:li_ca_a_programar,
				:ldt_fe_fogueo,
				:ldt_fe_trabajo,
				:li_cs_asignacion,
				:ll_pedido_po

				FROM  dt_pdnxmodulo
				WHERE ( dt_pdnxmodulo.simulacion 			= 1) AND  
						( dt_pdnxmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
						( dt_pdnxmodulo.pedido 					=:ll_pedido  ) AND  
						( dt_pdnxmodulo.cs_liberacion 		=:ll_cs_liberacion  ) AND  
						( dt_pdnxmodulo.po 						=:ls_nu_orden ) AND  
						( dt_pdnxmodulo.co_fabrica_pt 		=:li_co_fabrica_ref ) AND  
						( dt_pdnxmodulo.co_linea 				=:li_co_linea_ref  ) AND  
						( dt_pdnxmodulo.co_referencia 		=:ll_co_referencia  ) AND  
						( dt_pdnxmodulo.co_color_pt 			=:ll_color_pt  ) AND  
						( dt_pdnxmodulo.tono 					=:ls_tono  ) AND  
						( dt_pdnxmodulo.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
						( dt_pdnxmodulo.cs_particion 			= 1 );  // Definir ...?
				IF SQLCA.SQLCODE= -1 THEN
							Close(w_retroalimentacion)
							MessageBox("Error Base Datos","No pudo Leer Parametros de Programacion Originales")
							RETURN	0
				ELSE

				// Borra Programacion Diaria en Simulacion 1 (Definir si ser$$HEX2$$e1002000$$ENDHEX$$sobre todas)
				DELETE FROM dt_programa_diario  
				WHERE ( dt_programa_diario.simulacion 			= 	:li_simulacion ) AND  
					( dt_programa_diario.co_fabrica 				= 	:li_co_fabrica_modu ) AND  
					( dt_programa_diario.co_planta 				= 	:li_co_planta_modu ) AND  
					( dt_programa_diario.co_modulo 				= 	:li_co_modulo ) AND
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
					( dt_programa_diario.cs_particion 			= :li_cs_particion );
				IF SQLCA.SQLCODE=-1 THEN
					MessageBox("Error Base datos","No pudo borrar Programa Diario en Programacion de Produccion")
					ROLLBACK;
					RETURN
				ELSE
				END IF

				//borrar de dt_talla_pdnmodulo en Simulacion 1 (Definir si ser$$HEX2$$e1002000$$ENDHEX$$sobre todas)
				DELETE FROM dt_talla_pdnmodulo  
				WHERE ( dt_talla_pdnmodulo.simulacion 			= :li_simulacion) 		AND  
					( dt_talla_pdnmodulo.co_fabrica 				= :li_co_fabrica_modu ) AND  
					( dt_talla_pdnmodulo.co_planta 				= :li_co_planta_modu ) AND  
					( dt_talla_pdnmodulo.co_modulo 				= :li_co_modulo ) AND
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
					( dt_talla_pdnmodulo.cs_particion 			= :li_cs_particion );
				IF SQLCA.SQLCODE=-1 THEN
					MessageBox("Error Base datos","No pudo borrar Escalas de Programacion de Produccion")
					ROLLBACK;
					RETURN
				ELSE
				END IF
					
				// Organiza Particion (cs_estilocolortono) en especial si la original es 1
				IF li_cs_estilocolton > 1 THEN
						li_cs_estilocolortono_new1=li_cs_estilocolton
						ll_ca_unidades1 = ll_ca_unidades - ll_caxestilo
						ll_ca_numerada1 = ll_ca_numerada_origen
						
						li_cs_estilocolortono_new2=li_cs_max_particion
						ll_ca_unidades2 = ll_caxestilo
						ll_ca_numerada2 = ll_ca_numerada_origen
				END IF

				// Actualiza Parametros de Programacion de la Particion Original
				// en Simulacion 1 (Definir si ser$$HEX2$$e1002000$$ENDHEX$$sobre todas)
				UPDATE dt_pdnxmodulo 
				SET	cs_estilocolortono	=:li_cs_estilocolortono_new1,
						ca_programada 			=:ll_ca_unidades1,
						ca_pendiente			=:ll_ca_unidades1,
						ca_actual	 			=:ll_ca_unidades1,
						ca_numerada 			=:ll_ca_numerada1
				WHERE ( dt_pdnxmodulo.simulacion 			=:li_simulacion) AND  
						( dt_pdnxmodulo.co_fabrica 			=:li_co_fabrica_modu ) AND  
						( dt_pdnxmodulo.co_planta 				=:li_co_planta_modu ) AND  
						( dt_pdnxmodulo.co_modulo 				=:li_co_modulo ) AND
						( dt_pdnxmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
						( dt_pdnxmodulo.pedido 					=:ll_pedido  ) AND  
						( dt_pdnxmodulo.cs_liberacion 		=:ll_cs_liberacion  ) AND  
						( dt_pdnxmodulo.po 						=:ls_nu_orden ) AND  
						( dt_pdnxmodulo.co_fabrica_pt 		=:li_co_fabrica_ref ) AND  
						( dt_pdnxmodulo.co_linea 				=:li_co_linea_ref  ) AND  
						( dt_pdnxmodulo.co_referencia 		=:ll_co_referencia  ) AND  
						( dt_pdnxmodulo.co_color_pt 			=:ll_color_pt  ) AND  
						( dt_pdnxmodulo.tono 					=:ls_tono ) AND  
						( dt_pdnxmodulo.cs_estilocolortono 	=:li_cs_estilocolton ) AND  
						( dt_pdnxmodulo.cs_particion 			=:li_cs_particion );
				IF SQLCA.SQLCODE= -1 THEN
					ROLLBACK;
					Close(w_retroalimentacion)
					MessageBox("Error Base Datos","No pudo Actualizar Parametros de Programacion Originales")
					RETURN	0
				ELSE
				END IF
				// ---------
				// Actualiza Datos de Programacion de Produccion
				// ---------
				COMMIT;
				
				// Reconstruye Escala de Programacion de Produccion con Escala de Liberacion 
				DECLARE cur_dt_escalasxtela CURSOR FOR
				SELECT 	dt_escalasxtela.co_talla,   
							dt_escalasxtela.ca_unidades,    
							dt_escalasxtela.ca_numerada   
				FROM 		dt_escalasxtela  
				WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
						( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
						( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
						( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
						( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
						( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
						( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
						( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
						( dt_escalasxtela.tono 						= :ls_tono ) AND  
						( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolortono_new1 );
				IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base Datos","No pudo declarar lectura de Escala de Liberacion")
						ROLLBACK;
						RETURN 0
				ELSE
				END IF
			
				OPEN cur_dt_escalasxtela;
				IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base Datos","No pudo abrir lectura de Escalas de Liberacion")
						ROLLBACK;
						RETURN 0
				ELSE
				END IF
								
				FETCH cur_dt_escalasxtela INTO :li_co_talla,:ll_ca_liberadas,:ll_ca_numeradas;
				IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala")
					ROLLBACK;
					RETURN 0
				ELSE
				END IF

				li_cs_orden_talla = 1
				li_co_est_prog_talla = 1
				
				DO WHILE SQLCA.SQLCODE=0 
					
					//inserta en dt_talla_pdnmodulo
					INSERT INTO dt_talla_pdnmodulo  
	         		(simulacion,            
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
						co_talla,   
         		  	cs_orden_talla,         
						cs_prioridad,           
						ca_programada,       
						ca_producida,				// Definir si seran reconstruidas
						ca_pendiente,
	           		co_est_prog_talla,      
						fuente_dato,         	
						fe_creacion,   
	   	        	fe_actualizacion,       
						usuario,              	
						instancia,				
						co_estado_merc,			
						ca_proyectada,					
						ca_actual,					
						ca_numerada)  
				  	VALUES (:li_simulacion,		
					   :li_co_fabrica_modu,  	
					   :li_co_planta_modu,  	
					   :li_co_modulo,  
  				  		:li_co_fabrica_exp,     
						:ll_pedido,             
						:ll_cs_liberacion,   	
						:ls_nu_orden,   
         	  		:li_co_fabrica_ref,     
						:li_co_linea_ref,      	
						:ll_co_referencia,  		
						:ll_color_pt,   
	      		   :ls_tono,              	
						:li_cs_estilocolortono_new1, 
						:li_cs_particion,  
						:li_co_talla,   
						:li_cs_orden_talla,     
						:li_cs_prioridad,       
						:ll_ca_liberadas,  	
						0,
						:ll_ca_liberadas,  	
						:li_co_est_prog_talla,	
						:li_fuente_dato,    		
						:ldt_fechahora,  
						:ldt_fechahora,			
						:gstr_info_usuario.codigo_usuario, 
						:gstr_info_usuario.instancia,
						:ls_co_estado_merc,
						0,
						:ll_ca_liberadas,			
						:ll_ca_numeradas);
						
					IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base datos","No pudo guardar tallas de Programacion Produccion")
						ROLLBACK;
						RETURN
					ELSE
					END IF
	
					// Siguiente orden de talla
					li_cs_orden_talla = li_cs_orden_talla + 1

					// Siguiente Talla
					FETCH cur_dt_escalasxtela INTO :li_co_talla,:ll_ca_liberadas,:ll_ca_numeradas;
					IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala")
						ROLLBACK;
						RETURN 0
					ELSE
					END IF
					
				LOOP
				
				// -----------
				// Actualiza Escala de Programacion de Produccion
				// -----------
				COMMIT;
				
				// -----------
				// Llama Funcion Para Recalculo de Programacion Produccion
				// -----------
				li_rpta = wf_recalcular_programacion_produccion(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo)
				IF li_rpta=1 THEN
					// Actualiza la Base de Datos con los datos Recalculados
					COMMIT;
				ELSE
					ROLLBACK;
					Close(w_retroalimentacion)
					MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No pudo Recalcular Programacion Produccion")
					RETURN 0
				END IF


				// ---------------- PROCESO DE SEGUNDA DIVISON ----------------------
				// Procesa la Nueva Particion Creada, bien sea que se asigne o simplemente se deje pendiente.
				// -----------------
				// Lleva Fabrica, Planta, Modulo, unidades originales a Parametros
				// -----------------
				lstr_parametros.entero[1]=li_co_fabrica_modu
				lstr_parametros.entero[2]=li_co_planta_modu
				lstr_parametros.entero[3]=li_co_modulo
				lstr_parametros.entero[4]=0
				
				lstr_parametros.hay_parametros=TRUE
				
				// --------------
				// Llama Ventana para seleccion de Modulo Destino
				// --------------
				OpenWithParm(w_seleccionar_modulos,lstr_parametros)
				lstr_parametros = Message.PowerObjectParm
				// --------------
				// Si hubo seleccion de Fab/Planta/modulo actualiza Programacion de Produccion 
				// --------------
				IF lstr_parametros.hay_parametros THEN
					// -----------------
					// Lleva Fabrica, Planta, Modulo Seleccionados a Campos de Trabajo o
					// Toma Fabrica, Planta, Modulo originales
					// -----------------
					li_cambia_modulo=lstr_parametros.entero[5]
					IF li_cambia_modulo=1 THEN
						li_co_fabrica_modu_des=lstr_parametros.entero[1]
						li_co_planta_modu_des =lstr_parametros.entero[2]
						li_co_modulo_des		 =lstr_parametros.entero[3]
					ELSE
						li_co_fabrica_modu_des=li_co_fabrica_modu
						li_co_planta_modu_des =li_co_planta_modu
						li_co_modulo_des		 =li_co_modulo
					END IF 
					// ---------
					// Busca Maxima Prioridad de Asignacion
					// ---------
					SELECT MAX(dt_pdnxmodulo.cs_prioridad)  
					INTO :li_cs_max_prioridad 
					FROM dt_pdnxmodulo  
					WHERE ( dt_pdnxmodulo.simulacion 	= :li_simulacion ) AND  
					( dt_pdnxmodulo.co_fabrica 	= :li_co_fabrica_modu_des ) AND  
					( dt_pdnxmodulo.co_planta 		= :li_co_planta_modu_des ) AND  
					( dt_pdnxmodulo.co_modulo 		= :li_co_modulo_des ) ;
					IF SQLCA.SQLCODE = -1 THEN
						MessageBox("Error Base datos","No pudo buscar M$$HEX1$$e100$$ENDHEX$$xima prioridades (2)")
					ELSE
					END IF
					// Incrementa Prioridad
					IF ISNULL(li_cs_max_prioridad) THEN
						MessageBox("Error Base datos","No pudo incrementar M$$HEX1$$e100$$ENDHEX$$xima prioridad (2)")
						RETURN 0
					ELSE
						li_cs_max_prioridad = li_cs_max_prioridad + 1
					END IF
					// Crea Parametros Programacio con Base en Originales
					INSERT INTO dt_pdnxmodulo  
					(co_fabrica, 
					co_planta, 
					co_modulo, 
					cs_prioridad, 
					cs_particion, 
					fuente_dato, 
					co_estado_merc, 
					simulacion,
					co_estado_asigna,
					co_curva,
					fe_inicio_prog,
					fe_fin_prog,
					fe_requerida_desp,
					ca_minutos_std,
					co_tipo_asignacion,
					ca_personasxmod,
					cod_tur,
					minutos_jornada,
					ind_cambio_estilo,
					ca_unid_base_dia,
					orige_uni_base_dia,
					tipo_empate,
					unidades_empate,
					metodo_programa,
					fe_entra_pdn,
					tipo_fe_prog,
					fe_lim_prog,
					fe_desp_programada,
					indicativo_base,
					ca_base_dia_prod,
					ca_base_dia_prog,
					ca_a_programar,
					fe_fogueo,
					fe_trabajo,
					cs_asignacion,
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
					pedido_po,
					ca_programada,
					ca_producida, 
					ca_pendiente,
					ca_proyectada,
					ca_actual,
					ca_numerada,
					fe_creacion,
					fe_actualizacion,
					usuario,
					instancia)
				VALUES (:li_co_fabrica_modu_des, 
				:li_co_planta_modu_des, 
				:li_co_modulo_des, 
				:li_cs_max_prioridad,
				:li_cs_particion, 
				:li_fuente_dato, 
				:ls_co_estado_merc, 
				:li_simulacion,
				:li_co_estado_asigna,
				:li_co_curva,
				:ldt_fe_inicio_prog,
				:ldt_fe_fin_prog,
				:ldt_fe_requerida_desp,
				:ld_ca_minutos_std,
				:li_co_tipo_asignacion,
				:ld_ca_personasxmod,
				:li_cod_tur,
				:ld_minutos_jornada,
				:li_ind_cambio_estilo,
				:li_ca_unid_base_dia,
				:li_orige_uni_base_dia,
				:li_tipo_empate,
				:li_unidades_empate,
				:li_metodo_programa,
				:ldt_fe_entra_pdn,
				:li_tipo_fe_prog,
				:ldt_fe_lim_prog,
				:ldt_fe_desp_programada,
				:li_indicativo_base,
				:li_ca_base_dia_prod,
				:li_ca_base_dia_prog,
				:li_ca_a_programar,
				:ldt_fe_fogueo,
				:ldt_fe_trabajo,
				:li_cs_asignacion,
				:li_co_fabrica_exp,
				:ll_pedido,
				:ll_cs_liberacion,
				:ls_nu_orden,
				:li_co_fabrica_ref,
				:li_co_linea_ref,
				:ll_co_referencia,
				:ll_color_pt,
				:ls_tono,
				:li_cs_estilocolortono_new2,
				:ll_pedido_po,
				:ll_ca_unidades2,
				0,
				:ll_ca_unidades2,
				0,
				:ll_ca_unidades2,
				:ll_ca_numerada2,
				:ldt_fechahora,  
				:ldt_fechahora,			
				:gstr_info_usuario.codigo_usuario, 
				:gstr_info_usuario.instancia);

				IF SQLCA.SQLCODE=-1 THEN
					MessageBox("Error Base datos","No pudo crear Parametros Programacion (2) ")
					ROLLBACK;
					RETURN
				ELSE
				END IF
				
				// Reconstruye Escala de Programacion de Produccion con Escala de Liberacion 
				DECLARE	cur_dt_escalasxtela_2 CURSOR FOR
				SELECT 	dt_escalasxtela.co_talla,   
							dt_escalasxtela.ca_unidades,    
							dt_escalasxtela.ca_numerada   
				FROM 		dt_escalasxtela  
				WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
						( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
						( dt_escalasxtela.cs_liberacion 			= :ll_cs_liberacion ) AND  
						( dt_escalasxtela.nu_orden 				= :ls_nu_orden ) AND  
						( dt_escalasxtela.co_fabrica_pt 			= :li_co_Fabrica_ref ) AND  
						( dt_escalasxtela.co_linea 				= :li_co_linea_ref ) AND  
						( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
						( dt_escalasxtela.co_color_pt 			= :ll_color_pt ) AND  
						( dt_escalasxtela.tono 						= :ls_tono ) AND  
						( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolortono_new2);
				IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base Datos","No pudo declarar lectura de Escala de Liberacion (2)")
						ROLLBACK;
						RETURN 0
				ELSE
				END IF
			
				OPEN cur_dt_escalasxtela_2;
				IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base Datos","No pudo abrir lectura de Escalas de Liberacion (2)")
						ROLLBACK;
						RETURN 0
				ELSE
				END IF
								
				FETCH cur_dt_escalasxtela_2 INTO :li_co_talla,:ll_ca_liberadas,:ll_ca_numeradas;
				IF SQLCA.SQLCODE=-1 THEN
				MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala (2)")
					ROLLBACK;
					RETURN 0
				ELSE
				END IF

				li_cs_orden_talla = 1
				li_co_est_prog_talla = 1
				
				DO WHILE SQLCA.SQLCODE=0 
					
					//inserta en dt_talla_pdnmodulo
					INSERT INTO dt_talla_pdnmodulo  
	         		(simulacion, 
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
						co_talla,   
         		  	cs_orden_talla,         
						cs_prioridad,           
						ca_programada,       
						ca_producida,
						ca_pendiente,       
	           		co_est_prog_talla,      
						fuente_dato,         	
						fe_creacion,   
	   	        	fe_actualizacion,       
						usuario,              	
						instancia,				
						co_estado_merc,			
						ca_proyectada,
						ca_actual,					
						ca_numerada)  
				  	VALUES (:li_simulacion,		
					   :li_co_fabrica_modu_des,
					   :li_co_planta_modu_des, 
					   :li_co_modulo_des,  
  				  		:li_co_fabrica_exp,     
						:ll_pedido,             
						:ll_cs_liberacion,   	
						:ls_nu_orden,   
         	  		:li_co_fabrica_ref,     
						:li_co_linea_ref,      	
						:ll_co_referencia,  		
						:ll_color_pt,   
	      		   :ls_tono,              	
						:li_cs_estilocolortono_new2, 
						:li_cs_particion,  
						:li_co_talla,   
   		      	:li_cs_orden_talla,     
						:li_cs_max_prioridad,   
						:ll_ca_liberadas,  	
						0,
						:ll_ca_liberadas,  	
			         :li_co_est_prog_talla,	
						:li_fuente_dato,    		
						:ldt_fechahora,  
						:ldt_fechahora,			
						:gstr_info_usuario.codigo_usuario, 
						:gstr_info_usuario.instancia,
						:ls_co_estado_merc,		
						0,
						:ll_ca_liberadas,			
						:ll_ca_numeradas);
						
					IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base datos","No pudo guardar tallas de Programacion Produccion (2)")
						ROLLBACK;
						RETURN
					ELSE
					END IF
	
					// Siguiente orden de talla
					li_cs_orden_talla = li_cs_orden_talla + 1

					// Siguiente Talla
					FETCH cur_dt_escalasxtela_2 INTO :li_co_talla,:ll_ca_liberadas,:ll_ca_numeradas;
					IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base Datos","No pudo traer datos de tallas de secuencia de partici$$HEX1$$f300$$ENDHEX$$n de escala (2)")
						ROLLBACK;
						RETURN 0
					ELSE
					END IF
					
				LOOP
				
				// -----------
				// Actualiza Escala de Programacion de Produccion y Parametros de Programacion
				// -----------
				COMMIT;

				// -----------
				// Llama Funcion Para Recalculo de Programacion Produccion
				// -----------
				li_rpta = wf_recalcular_programacion_produccion(li_simulacion,li_co_fabrica_modu_des,li_co_planta_modu_des,li_co_modulo_des)
				IF li_rpta=1 THEN
					// Actualiza la Base de Datos con los datos Recalculados
					COMMIT;
				ELSE
					ROLLBACK;
					Close(w_retroalimentacion)
					MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No pudo Recalcular Programacion Produccion")
					RETURN 0
				END IF

				ELSE
				END IF
		END IF // De SELECT * dt_pdnxmodulo 

				 // ----------- Fin Actualizacion Datos Programacion Produccion 102 -------
// ************************************************************************************** // 				
				ELSE
					RETURN
				END IF

				ELSE
					RETURN
				END IF

			END IF

		END IF
	ELSE
		MessageBox("Advertencia","No puede partir escalas sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
	END IF
ELSE
END IF


// NOTA : Aparentemente el campo de actualizacion de unidades numeradas estan mal, 
// por que al partir las dos divisiones no deben tener la misma cantidad numerada

end event

event ue_trasladar_tallas;//abre ventana con tallas de dt_libera_estilo actual 

//
end event

public function long wf_trae_tela (long ai_co_fabrica_exp, long al_pedido, long ai_cs_liberacion, string as_po, long ai_co_fabrica_pt, long ai_co_linea, long al_co_referencia, long al_co_color_pt, string as_tono, long ai_cs_estilocolortono);Long  li_correcto

li_correcto=1

//ciclo para traer de dt_telaxmodelo_lib las raya 10, order by yardas
DECLARE cur_telas CURSOR FOR
  SELECT dt_telaxmodelo_lib.co_fabrica_tela,   
         dt_telaxmodelo_lib.co_reftel,   
         dt_telaxmodelo_lib.co_caract,   
         dt_telaxmodelo_lib.diametro,   
         dt_telaxmodelo_lib.co_color_tela,   
         dt_telaxmodelo_lib.ancho_cortable,
			dt_telaxmodelo_lib.ca_tela
    FROM dt_telaxmodelo_lib  
   WHERE ( dt_telaxmodelo_lib.co_fabrica_exp 		= :ai_co_fabrica_exp ) AND  
         ( dt_telaxmodelo_lib.pedido 					= :al_pedido ) AND  
         ( dt_telaxmodelo_lib.cs_liberacion 			= :ai_cs_liberacion ) AND  
         ( dt_telaxmodelo_lib.nu_orden 				= :as_po ) AND  
         ( dt_telaxmodelo_lib.co_fabrica_pt 			= :ai_co_fabrica_pt ) AND  
         ( dt_telaxmodelo_lib.co_linea 				= :ai_co_linea ) AND  
         ( dt_telaxmodelo_lib.co_referencia 			= :al_co_referencia ) AND  
         ( dt_telaxmodelo_lib.co_color_pt 			= :al_co_color_pt ) AND  
         ( dt_telaxmodelo_lib.tono 						= :as_tono ) AND  
         ( dt_telaxmodelo_lib.cs_estilocolortono 	= :ai_cs_estilocolortono ) AND  
         ( dt_telaxmodelo_lib.raya 						= 10 )   
ORDER BY dt_telaxmodelo_lib.ca_tela DESC;
			
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo declarar la b$$HEX1$$fa00$$ENDHEX$$squeda de telas para la escala")
	RETURN 0
ELSE
END IF
			
OPEN cur_telas;
			
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo declarar la b$$HEX1$$fa00$$ENDHEX$$squeda de telas para la escala")
	RETURN 0
ELSE
END IF

FETCH cur_telas INTO :ii_co_fabrica_tela,:il_co_reftel,:ii_co_caract,:ii_diametro,&
							:il_co_color_te,:idb_ancho_cortable,:idb_ca_tela;
			
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo declarar la b$$HEX1$$fa00$$ENDHEX$$squeda de telas para la escala")
	RETURN 0
ELSE
END IF

DO WHILE SQLCA.SQLCODE=0
	
	SQLCA.SQLCODE=-1
	
	
//	FETCH cur_telas INTO :ii_co_fabrica_tela,:il_co_reftel,:ii_co_caract,:ii_diametro,:il_co_color_te;
//			
//	IF SQLCA.SQLCODE=-1 THEN
//		MessageBox("Error base datos","No pudo declarar la b$$HEX1$$fa00$$ENDHEX$$squeda de telas para la escala")
//		RETURN 0
//	ELSE
//	END IF
	
LOOP

CLOSE cur_telas;

RETURN li_correcto


end function

public function long wf_recalcular_programacion_produccion (long ai_simulacion, long ai_co_fabrica, long ai_co_planta, long ai_co_modulo);// ----------------------
// Adaptado del ue_recalcular de la pantalla w_asignacion_modulos
// ----------------------
Long	 			li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,li_simulacion
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
Long				li_cs_estilocolton,li_co_tipo_asignacion,li_cs_particion
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato,li_co_est_prog_dia,li_cs_prioridad
Long				li_prior_mayores,li_cs_max_prioridad,li_rpta,li_cs_prioridad_ciclo,li_co_tipo_asignacion_inicial
Long 				li_dias_manual, li_ca_pendiente_manual

LONG					ll_fila,ll_hallados,ll_rpta
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate,ll_ca_unid_base_dia
LONG					ll_ca_unid_dispon_ini,ll_ca_unid_dispon_fin,ll_ca_min_dispon_fin
LONG					ll_personasxmodulo,ll_ca_unid_posibles,ll_unidades_empate

DateTime 			ldt_fechahora,ldt_fe_prog_desp,ldt_fe_entra_pdn
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DATE					ldt_fe_despacho_allocation

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia

s_base_parametros lstr_parametro

// ---------------- inicio de carga parametros para programar -------------------------- //

li_simulacion				= ai_simulacion
li_co_fabrica_modu 		= ai_co_fabrica
li_co_planta_modu 		= ai_co_planta
li_co_modulo 				= ai_co_modulo
			
// -------------------- Ciclo para recorrer las prioridades ------------------ //				
// --------------------        Recalculando cada una        ------------------ //
				
DECLARE cur_asignaciones CURSOR FOR  
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
							dt_pdnxmodulo.cs_particion,   
							dt_pdnxmodulo.cs_prioridad,   
							dt_pdnxmodulo.ca_pendiente,   
							dt_pdnxmodulo.co_curva,   
							dt_pdnxmodulo.fe_inicio_prog,   
							dt_pdnxmodulo.fe_fin_prog,   
							dt_pdnxmodulo.ca_minutos_std,   
							dt_pdnxmodulo.ca_personasxmod,   
							dt_pdnxmodulo.minutos_jornada,   
							dt_pdnxmodulo.tipo_empate,   
							dt_pdnxmodulo.unidades_empate,
							dt_pdnxmodulo.metodo_programa,
							dt_pdnxmodulo.ca_unid_base_dia,
							dt_pdnxmodulo.fe_desp_programada,
							dt_pdnxmodulo.fe_entra_pdn,
							dt_pdnxmodulo.ind_cambio_estilo,
							dt_pdnxmodulo.co_tipo_asignacion
FROM dt_pdnxmodulo  
WHERE ( dt_pdnxmodulo.simulacion 		= 	:li_simulacion ) AND  
		( dt_pdnxmodulo.co_fabrica 		= 	:li_co_fabrica_modu ) AND  
		( dt_pdnxmodulo.co_planta 			= 	:li_co_planta_modu ) AND  
		( dt_pdnxmodulo.co_modulo 			= 	:li_co_modulo )
ORDER BY dt_pdnxmodulo.cs_prioridad;			
							
OPEN cur_asignaciones;
IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo abrir la busqueda de Asignaciones para Recalcular Programacion")
		RETURN 1
ELSE
END IF
				
// ------- Lectura de primera prioridad a Recalcular ------------ //
FETCH cur_asignaciones INTO 	:li_co_fabrica_exp,
															:ll_pedido,
															:ll_cs_liberacion,
															:ls_nu_orden,
															:li_co_fabrica_ref,
 															:li_co_linea_ref,
															:ll_co_referencia,
															:ll_color_pt ,
															:ls_tono,
															:li_cs_estilocolton,
															:li_cs_particion,
															:li_cs_prioridad,
															:ll_ca_unidades,
															:li_co_curva,
															:ldt_fe_inicio_prog,
															:ldt_fe_fin_prog,
															:ld_ca_minutos_std,
															:ll_ca_personasxmod,
															:ld_minutos_jornada,
															:li_tipo_empate,
															:ll_unidades_empate,
															:li_metodo_programa,
															:ll_ca_unid_base_dia,
															:ldt_fe_prog_desp,
															:ldt_fe_entra_pdn,
															:li_ind_cambio_estilo,
															:li_co_tipo_asignacion;
IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo Leer Asignaciones para Recalcular Programacion")
		RETURN 1
ELSE
END IF
					
DO WHILE SQLCA.SQLCODE=0 
					
				// -- Presenta Pantalla de Recalculo -- //
				lstr_parametro.cadena[1]="Recalculando Asignacion....."+string(li_cs_prioridad)
				lstr_parametro.cadena[2]="El sistema esta recalculando distribuci$$HEX1$$f300$$ENDHEX$$n de unidades y fechas, esta operacion puede demorar unos segundos, espere un momento por favor..."
				lstr_parametro.cadena[3]="reloj"
				
				OpenWithParm(w_retroalimentacion,lstr_parametro)

					// Programa Segun Metodo de Programacion
					// Base dia manual. Eficienica Diaria
					IF li_metodo_programa=0 THEN 
					ELSE
						DELETE FROM dt_programa_diario  
						WHERE ( dt_programa_diario.simulacion 				=:li_simulacion ) AND  
										( dt_programa_diario.co_fabrica 				=:li_co_fabrica_modu  ) AND  
										( dt_programa_diario.co_planta 				=:li_co_planta_modu  ) AND  
										( dt_programa_diario.co_modulo 				=:li_co_modulo ) AND  
										( dt_programa_diario.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
										( dt_programa_diario.pedido 					=:ll_pedido  ) AND  
										( dt_programa_diario.cs_liberacion 			=:ll_cs_liberacion  ) AND  
										( dt_programa_diario.po 						=:ls_nu_orden ) AND  
										( dt_programa_diario.co_fabrica_pt 			=:li_co_fabrica_ref ) AND  
										( dt_programa_diario.co_linea 				=:li_co_linea_ref  ) AND  
										( dt_programa_diario.co_referencia 			=:ll_co_referencia  ) AND  
										( dt_programa_diario.co_color_pt 			=:ll_color_pt) AND  
										( dt_programa_diario.tono 						=:ls_tono  ) AND  
										( dt_programa_diario.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
										( dt_programa_diario.cs_particion 			=:li_cs_particion  )   ;
						IF SQLCA.SQLCODE=-1 THEN
								Close(w_retroalimentacion)
								MessageBox("Error Base datos","No pudo borrar distribuci$$HEX1$$f300$$ENDHEX$$n diaria previa de unidades para reasignar")
								RETURN 1
						ELSE
						END IF
					END IF
 					// ---------------------------------------------------------------------------
					// Programacion por Base dia manual
					// ---------------------------------------------------------------------------
					IF li_metodo_programa=0 THEN 
						// -----
						// Verifica si la prioridad tiene programacion manual
						// -----
						li_dias_manual = 0
						li_ca_pendiente_manual = 0
						
						SELECT MAX(dt_programa_diario.cs_fechas), SUM(dt_programa_diario.ca_pendiente)
						INTO :li_dias_manual, :li_ca_pendiente_manual
			 			FROM dt_programa_diario  
						WHERE ( dt_programa_diario.simulacion 				=:li_simulacion ) AND  
								( dt_programa_diario.co_fabrica 				=:li_co_fabrica_modu  ) AND  
								( dt_programa_diario.co_planta 				=:li_co_planta_modu  ) AND  
								( dt_programa_diario.co_modulo 				=:li_co_modulo ) AND  
								( dt_programa_diario.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
								( dt_programa_diario.pedido 					=:ll_pedido  ) AND  
								( dt_programa_diario.cs_liberacion 			=:ll_cs_liberacion  ) AND  
								( dt_programa_diario.po 						=:ls_nu_orden ) AND  
								( dt_programa_diario.co_fabrica_pt 			=:li_co_fabrica_ref ) AND  
								( dt_programa_diario.co_linea 				=:li_co_linea_ref  ) AND  
								( dt_programa_diario.co_referencia 			=:ll_co_referencia  ) AND  
								( dt_programa_diario.co_color_pt 			=:ll_color_pt) AND  
								( dt_programa_diario.tono 						=:ls_tono  ) AND  
								( dt_programa_diario.cs_estilocolortono 	=:li_cs_estilocolton  ) AND  
								( dt_programa_diario.cs_particion 			=:li_cs_particion  );
								
						IF SQLCA.SQLCODE=-1 THEN
							MessageBox("Error Base datos","No pudo encontrar informacion programacion manual")
						ELSE
						END IF

						// Organiza Campos segun busqueda programacion manual
						IF ISNULL(li_dias_manual) THEN
								li_dias_manual = 0
								li_ca_pendiente_manual = 0
						ELSE
								ll_ca_unidades = ll_ca_unidades - li_ca_pendiente_manual
						END IF

					// Verifica que existan unidades por programar 
					IF ll_ca_unidades > 0 THEN
						
						// Verifica si hay fecha programada de despacho 
						// Para programar de Atras hacia adeltante
						IF NOT ISNULL(ldt_fe_prog_desp) THEN
							li_rpta = f_distribuir_unidades_base(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,&
												li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
												ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
												li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
												ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
												ll_color_pt,ls_tono,&
												li_cs_estilocolton,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,ld_minutos_jornada,&
												li_dias_manual,ll_ca_unidades,ldt_fe_fin_prog,ll_ca_unid_base_dia, ldt_fe_prog_desp,ldt_fe_entra_pdn, &
												li_cod_tur)
										
							IF li_rpta=1 THEN
							ELSE
								ROLLBACK;
								Close(w_retroalimentacion)
								MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No se pudo distribuir unidadades por Base Diaria")
								RETURN 1
							END IF
						END IF
						// ---------------------------------------------------------------------------						
						// ----- Organiza Variable para Asegurar que programa Normal
						// ---------------------------------------------------------------------------						
						SETNULL(ldt_fe_prog_desp)
						//llamar a la funcion de distribuir unidades en los dias					
						li_rpta = f_distribuir_unidades_base(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,&
												li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
												ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
												li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
												ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
												ll_color_pt,ls_tono,&
												li_cs_estilocolton,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,ld_minutos_jornada,&
												li_dias_manual,ll_ca_unidades,ldt_fe_fin_prog,ll_ca_unid_base_dia, ldt_fe_prog_desp,ldt_fe_entra_pdn, &
												li_cod_tur)
										
						IF li_rpta=1 THEN
						ELSE
							ROLLBACK;
							Close(w_retroalimentacion)
							MessageBox("Error procesando informaci$$HEX1$$f300$$ENDHEX$$n","No se pudo distribuir unidadades por Base Diaria")
							RETURN 1
						END IF
					END IF // ll_ca_unidades > 0 
 					ELSE
					// ---------------------------------------------------------------------------
					// ----- Programacion Por Eficiencias 
					// ---------------------------------------------------------------------------						
					// ----- Valida Programacion de atras Hacia Adelante
					// ---------------------------------------------------------------------------						
					IF NOT ISNULL(ldt_fe_prog_desp) THEN
							//llamar a la funcion de distribuir unidades en los dias					
							li_rpta = f_distribuir_unidades(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,&
													li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
													ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
													li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
													ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
													ll_color_pt,ls_tono,&
													li_cs_estilocolton,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,&
													ld_minutos_jornada,li_ind_cambio_estilo,li_cod_tur,ldt_fe_prog_desp,ldt_fe_entra_pdn,&
													li_co_tipo_asignacion)	

							IF li_rpta =1 THEN
							ELSE
								ROLLBACK;
								Close(w_retroalimentacion)
								MessageBox("Error Procesando Informacion","No pudo Distribuir Unidades por Eficiencia Diaria")
								RETURN 1
							END IF
						END IF
						// ---------------------------------------------------------------------------						
						// ----- Organiza Variable para Asegurar que programa Normal
						// ---------------------------------------------------------------------------						
						SETNULL(ldt_fe_prog_desp)
						// llamar a la funcion de distribuir unidades en los dias					
						li_rpta = f_distribuir_unidades(li_simulacion,li_co_fabrica_modu,li_co_planta_modu,li_co_modulo,&
													li_cs_prioridad,li_tipo_empate,ll_unidades_empate,ll_ca_unidades,&
													ld_ca_minutos_std,ll_ca_personasxmod,li_co_curva,&
													li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
													ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
													ll_color_pt,ls_tono,&
													li_cs_estilocolton,li_cs_particion,ldt_fe_inicio_prog,ldt_fe_fin_prog,&
													ld_minutos_jornada,li_ind_cambio_estilo,li_cod_tur,ldt_fe_prog_desp,ldt_fe_entra_pdn,&
													li_co_tipo_asignacion)	

						IF li_rpta =1 THEN
						ELSE
							ROLLBACK;
							Close(w_retroalimentacion)
							MessageBox("Error Procesando Informacion","No pudo Distribuir Unidades por Eficiencia Diaria")
							RETURN 1
						END IF
					END IF
	
					// Lee siguiente Programacion
					FETCH cur_asignaciones INTO 	:li_co_fabrica_exp,
															:ll_pedido,
															:ll_cs_liberacion,
															:ls_nu_orden,
															:li_co_fabrica_ref,
 															:li_co_linea_ref,
															:ll_co_referencia,
															:ll_color_pt ,
															:ls_tono,
															:li_cs_estilocolton,
															:li_cs_particion,
															:li_cs_prioridad,
															:ll_ca_unidades,
															:li_co_curva,
															:ldt_fe_inicio_prog,
															:ldt_fe_fin_prog,
															:ld_ca_minutos_std,
															:ll_ca_personasxmod,
															:ld_minutos_jornada,
															:li_tipo_empate,
															:ll_unidades_empate,
															:li_metodo_programa,
															:ll_ca_unid_base_dia,
															:ldt_fe_prog_desp,
															:ldt_fe_entra_pdn,
															:li_ind_cambio_estilo,
															:li_co_tipo_asignacion;
					IF SQLCA.SQLCODE=-1 THEN
							Close(w_retroalimentacion)
							MessageBox("Error Base Datos","No pudo Lee siguiente Asignacion para Recalcular")
					ELSE
					END IF
					
				Close(w_retroalimentacion)
					
LOOP // DO WHILE SQLCA.SQLCODE=0 

// Actualiza la Base de Datos con los datos Recalculados
COMMIT;

Close(w_retroalimentacion)				
MessageBox("Proceso Exitoso","Recalculo Programacion Asignaciones Terminado")
//--------
RETURN 1
end function

on w_partir_liberaciones.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_partir_liberaciones" then this.MenuID = create m_partir_liberaciones
end on

on w_partir_liberaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;//////////////////////////////////////////////////////////////////////
//Las siguientes lineas se deben acondicionar seg$$HEX1$$fa00$$ENDHEX$$n la ventana.
///////////////////////////////////////////////////////////////////

LONG   ll_co_fabrica_exp,ll_pedido,ll_cs_lib_preliminar,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia
LONG   ll_co_color_pt,ll_ca_pedidas,ll_tipo_lib_prelim,ll_cs_liberacion,ll_cs_estilocolortono
LONG   ll_co_fabrica_tela,ll_co_reftel,ll_co_caract,ll_diametro,ll_color_tela
DECIMAL	ld_ancho_cortable
String ls_nu_orden,ls_nu_cut,ls_tono,ls_gpa,ls_tono_tela
s_base_parametros	lstr_parametros

LONG	 ll_hallados

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	Open(w_buscar_h_liberar_escalas)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
	
		ll_co_fabrica_exp			=lstr_parametros.entero[1]
		ll_pedido					=lstr_parametros.entero[2]
		il_cs_liberacion			=lstr_parametros.entero[3]
		il_cs_lib_preliminar		=lstr_parametros.entero[4]
		is_gpa						=lstr_parametros.cadena[1]
		

				
		ls_nu_orden					=lstr_parametros.cadena[2]
		ll_co_fabrica_pt			=lstr_parametros.entero[5]
		ll_co_linea					=lstr_parametros.entero[6]
		ll_co_referencia			=lstr_parametros.entero[7]
		ll_co_color_pt				=lstr_parametros.entero[8]
		ls_tono						=lstr_parametros.cadena[3]
		ll_cs_estilocolortono	=lstr_parametros.entero[9]
		

		IF ISNULL(ls_nu_orden) OR ls_nu_orden="" THEN
		ELSE

			ll_hallados = dw_maestro.Retrieve(ll_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
													 ls_nu_orden,&
													 ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,&
													 ll_co_color_pt,&
													 ls_tono,&
													 ll_cs_estilocolortono)
													 
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

						
						IF wf_trae_tela( ll_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
														 ls_nu_orden,&
														 ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,&
														 ll_co_color_pt,&
														 ls_tono,&
														 ll_cs_estilocolortono) =1 THEN
														 
						ELSE
							MessageBox("Error Datos","No pudo traer enlace de tela para la escala")
							Return
						END IF
						

						ll_hallados = dw_detalle.Retrieve(ll_co_fabrica_exp,ll_pedido,il_cs_liberacion,&
														 ls_nu_orden,&
														 ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,&
														 ll_co_color_pt,&
														 ls_tono,&
														 ll_cs_estilocolortono,&
														 ii_co_fabrica_tela,il_co_reftel,ii_diametro,il_co_color_te,&
														 idb_ancho_cortable)
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
								MessageBox("Sin Datos","No hay datos para su criterio",&
											 Exclamation!,Ok!)
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

event open;call super::open;This.width =3465 
This.height = 1084
end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_partir_liberaciones
integer x = 9
integer y = 8
integer width = 3410
integer height = 488
string dataobject = "dtb_libera_estilos_para_partir_liberacio"
boolean maxbox = true
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_maestro::itemfocuschanged;call super::itemfocuschanged;//Long				li_co_fabrica,li_co_linea,li_talla,li_calidad,li_co_muestrario
//LONG					ll_co_referencia,ll_co_color
//STRING				ls_de_linea,ls_de_referencia,ls_de_color,ls_de_muestrario
//s_base_parametros	lstr_parametros
//
//dw_maestro.AcceptText()
//IF dwo.Name = "co_fabrica_exp" THEN
////	li_tipoprod = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_tipoprod")
////	lstr_parametros.entero[1] = li_tipoprod
//	Open(w_buscar_h_liberar_escalas)
//	lstr_parametros = Message.PowerObjectParm
//	IF lstr_parametros.hay_parametros THEN
//		li_co_fabrica 		= lstr_parametros.entero[1]
//		li_co_linea 		= lstr_parametros.entero[2]
//		ll_co_referencia 	= lstr_parametros.entero[3]
//		li_talla 			= lstr_parametros.entero[4]
//		ll_co_color 		= lstr_parametros.entero[5]
//		
//		dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_co_fabrica)
//		dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_co_linea)
//		dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_co_referencia)
//		dw_maestro.SetItem(il_fila_actual_maestro, "co_talla", li_talla)
//		dw_maestro.SetItem(il_fila_actual_maestro, "co_color_pt", ll_co_color)
//
//		
//		SELECT m_lineas_pro.de_linea
//		INTO   :ls_de_linea
//		FROM   m_lineas_pro
//		WHERE  m_lineas_pro.co_fabrica	=:li_co_fabrica
//		AND    m_lineas_pro.co_linea		=:li_co_linea;
//		
//		IF SQLCA.SQLCODE=-1 THEN
//			MessageBox("Error Base Datos","No pudo buscar la descripci$$HEX1$$f300$$ENDHEX$$n de la linea")
//			Return 0
//		ELSE
//			dw_maestro.SetItem(il_fila_actual_maestro, "de_linea", ls_de_linea)
//		END IF
//		

//		SELECT m_colores.de_color
//		INTO   :ls_de_color
//		FROM   m_colores
//		WHERE  m_colores.co_fabrica	=:li_co_fabrica
//		AND    m_colores.co_linea		=:li_co_linea
//		AND    m_colores.co_color		=:ll_co_color		;
//		
//		IF SQLCA.SQLCODE=-1 THEN
//			MessageBox("Error Base Datos","No pudo buscar la descripci$$HEX1$$f300$$ENDHEX$$n de la linea")
//			Return 0
//		ELSE
//			dw_maestro.SetItem(il_fila_actual_maestro, "de_color", ls_de_color)
//		END IF
//		
//		
//		
//	END IF
//	dw_maestro.SetColumn("co_coleccion")	
//END IF
//
//IF dwo.Name = "co_coleccion" THEN
//	li_co_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
//	li_co_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
//	lstr_parametros.entero[1] = li_co_fabrica
//	lstr_parametros.entero[2] = li_co_linea
//	lstr_parametros.hay_parametros=TRUE
//	OpenWithParm(w_buscar_muestrarios, lstr_parametros)
//	lstr_parametros = Message.PowerObjectParm
//	IF lstr_parametros.hay_parametros THEN
//		li_co_muestrario	= lstr_parametros.entero[1]
//		ls_de_muestrario 	= lstr_parametros.cadena[1]
//		
//		dw_maestro.SetItem(il_fila_actual_maestro, "co_coleccion", li_co_muestrario)
//		dw_maestro.SetItem(il_fila_actual_maestro, "de_muestrario", ls_de_muestrario)
//		
//	END IF
//	dw_maestro.SetColumn("encogimiento")
//END IF
end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_partir_liberaciones
integer x = 9
integer y = 504
integer width = 3410
string dataobject = "dct_dt_escalasxtela_partir_liberaciones"
end type

