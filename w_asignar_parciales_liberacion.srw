HA$PBExportHeader$w_asignar_parciales_liberacion.srw
forward
global type w_asignar_parciales_liberacion from w_base_buscar_lista
end type
end forward

global type w_asignar_parciales_liberacion from w_base_buscar_lista
integer height = 1760
end type
global w_asignar_parciales_liberacion w_asignar_parciales_liberacion

type variables
Long ii_co_fabrica_exp,ii_co_fabrica_ref
Long ii_co_linea,ii_simulacion,ii_co_fabrica_modu
Long ii_co_planta_modu,ii_co_modulo
Long ii_cs_estilocolton,ii_cs_particion
Long ii_co_fabrica_modu_new,ii_co_planta_modu_new
Long ii_co_modulo_new,ii_tipo_llamado
Long ii_cs_particion_anterior
LONG il_pedido,il_co_referencia,il_co_color_pt
LONG il_cs_liberacion,ii_ca_a_asignar
STRING is_nu_orden,is_tono
end variables

on w_asignar_parciales_liberacion.create
call super::create
end on

on w_asignar_parciales_liberacion.destroy
call super::destroy
end on

event open;LONG 			ll_numero_registros,ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion
Long		li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_simulacion,li_co_fabrica_modu,li_co_planta_modu
Long		li_co_modulo,li_cs_estilocolton,li_cs_particion
STRING		ls_nu_orden,ls_tono
s_base_parametros	lstr_parametros
//dtb_unidades_pendxasignar_de_escalas

lstr_parametros = Message.PowerObjectParm
IF lstr_parametros.hay_parametros THEN
	ii_co_fabrica_exp			=lstr_parametros.entero[1]
	il_pedido					=lstr_parametros.entero[2]
	is_nu_orden					=lstr_parametros.cadena[1]
	ii_co_fabrica_ref			=lstr_parametros.entero[3]
	ii_co_linea					=lstr_parametros.entero[4]
	il_co_referencia			=lstr_parametros.entero[5]
	il_co_color_pt				=lstr_parametros.entero[6]
	ii_simulacion				=lstr_parametros.entero[7]
	ii_co_fabrica_modu		=lstr_parametros.entero[8]			
	ii_co_planta_modu			=lstr_parametros.entero[9]						
	ii_co_modulo				=lstr_parametros.entero[10]						
	il_cs_liberacion			=lstr_parametros.entero[11]			
	is_tono						=lstr_parametros.cadena[2]							
	ii_cs_estilocolton		=lstr_parametros.entero[12]			
	ii_cs_particion			=lstr_parametros.entero[13]
	ii_ca_a_asignar			=lstr_parametros.entero[14]
	ii_co_fabrica_modu_new	=lstr_parametros.entero[15]			
	ii_co_planta_modu_new	=lstr_parametros.entero[16]						
	ii_co_modulo_new			=lstr_parametros.entero[17]
	ii_tipo_llamado			=lstr_parametros.entero[18]
	ii_cs_particion_anterior=lstr_parametros.entero[19]
		
	IF ii_tipo_llamado=0 THEN//INSERTAR PARCIALES
		dw_lista.DataObject = 'dtb_unidades_pendxasignar_de_escalas'
	ELSE//PARTIR ESCALA
		dw_lista.DataObject = 'dtb_unidades_pendxasignar_de_escalas_par'	
	END IF
ELSE
	MessageBox("Advertencia","No trajo par$$HEX1$$e100$$ENDHEX$$metros para insertar escala parcial")
END IF

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	
		IF ii_tipo_llamado=0 THEN//INSERTAR PARCIALES
			ll_numero_registros = dw_lista.retrieve(  ii_simulacion,ii_co_fabrica_modu,ii_co_planta_modu,ii_co_modulo,&
																ii_co_fabrica_exp,il_pedido,il_cs_liberacion,&
																is_nu_orden,ii_co_fabrica_ref,ii_co_linea,&
																il_co_referencia,il_co_color_pt,is_tono,ii_cs_estilocolton)
		ELSE//PARTIR ESCALA
			ll_numero_registros = dw_lista.retrieve(  ii_simulacion,ii_co_fabrica_modu,ii_co_planta_modu,ii_co_modulo,&
																ii_co_fabrica_exp,il_pedido,il_cs_liberacion,&
																is_nu_orden,ii_co_fabrica_ref,ii_co_linea,&
																il_co_referencia,il_co_color_pt,is_tono,ii_cs_estilocolton,&
																ii_cs_particion_anterior)
		END IF
		
		
		CHOOSE CASE ll_numero_registros 
			CASE -1
				MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
			CASE 0
				il_fila_actual = 0
				st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
			CASE ELSE
				st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
				dw_lista.setrow(1)
				dw_lista.selectrow(1,true)
				il_fila_actual = 1
		END CHOOSE
	
END IF
dw_lista.SetRowFocusIndicator (Off!)
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

			

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_asignar_parciales_liberacion
integer x = 210
integer y = 1392
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_asignar_parciales_liberacion
integer x = 805
integer y = 1504
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_asignar_parciales_liberacion
integer x = 247
integer y = 1504
end type

event pb_aceptar::clicked;LONG		ll_filas,ll_insertados,ll_filaactual,ll_pedido,ll_cs_liberacion, ll_co_referencia,ll_co_color_pt
LONG		ll_ca_programada,ll_ca_producida,ll_ca_pendiente,ll_ca_acumulado,ll_unid_quedan_asigna,ll_ca_pendiente_dw
LONG		ll_ca_unidades_acumuladas

Long	li_simulacion,li_co_fabrica_modulo, li_co_planta,li_co_modulo, li_co_fabrica_exp,  li_cs_estilocolortono
Long	li_co_fabrica_pt, li_co_linea, li_cs_particion,li_co_talla,li_cs_orden_talla,li_cs_prioridad 
Long	li_co_est_prog_talla,li_fuente_dato

STRING	ls_po, ls_tono,ls_usuario, ls_instancia,ls_mensaje

DATETIME	ldt_fe_creacion,ldt_fe_actualizacion,ldt_fechahora

BOOLEAN	li_hizo_una

s_base_parametros lstr_parametros
li_hizo_una=FALSE
IF il_fila_actual > 0 THEN
	dw_lista.AcceptText()
	ll_filas = dw_lista.RowCount()
	ll_insertados = 1
	ll_ca_acumulado=0
	ll_ca_unidades_acumuladas=0
	FOR ll_filaactual = 1 TO ll_filas
		lstr_parametros.hay_parametros = TRUE
		
		lstr_parametros.entero[1]=dw_lista.getitemnumber(ll_filaactual,"co_talla")
		lstr_parametros.entero[2]=dw_lista.getitemnumber(ll_filaactual,"ca_unidades")
		lstr_parametros.entero[3]=dw_lista.getitemnumber(ll_filaactual,"ca_asignada")
		lstr_parametros.entero[4]=dw_lista.getitemnumber(ll_filaactual,"ca_faltan")
		lstr_parametros.entero[5]=dw_lista.getitemnumber(ll_filaactual,"ca_a_asignar")
		lstr_parametros.entero[6]=1
		
		//acumula unidades a asignar para controlar contra el total
		ll_ca_unidades_acumuladas=ll_ca_unidades_acumuladas + lstr_parametros.entero[5]
		
		
		IF ii_tipo_llamado=1 THEN //PARTICION O TRASLADO DE CANTIDADES POR TALLA
			ll_ca_pendiente_dw=lstr_parametros.entero[3] 
			IF ISNULL(ll_ca_pendiente_dw) THEN
				ll_ca_pendiente_dw=lstr_parametros.entero[2] 
			ELSE
			END IF
		ELSE//INSERCI$$HEX1$$d300$$ENDHEX$$N PARCIAL DE CANTIDADES POR TALLA
			ll_ca_pendiente_dw=lstr_parametros.entero[4] 
			IF ISNULL(ll_ca_pendiente_dw) THEN
				ll_ca_pendiente_dw=lstr_parametros.entero[3] 
				IF ISNULL(ll_ca_pendiente_dw) THEN
					ll_ca_pendiente_dw=lstr_parametros.entero[2] 
				ELSE
				END IF
			ELSE
			END IF
		END IF
		
		IF lstr_parametros.entero[5] > ll_ca_pendiente_dw THEN
			ls_mensaje="Existen unidades a asignar mayores que la permitida en la talla:"+STRING(lstr_parametros.entero[1])
			MessageBox("Error Base datos",ls_mensaje)
			ROLLBACK;
			lstr_parametros.hay_parametros = FALSE
			CloseWithReturn(parent,lstr_parametros)
			RETURN
		ELSE
		END IF 
		
		IF ((ISNULL(lstr_parametros.entero[5])) OR (lstr_parametros.entero[5]<=0))  THEN
		ELSE
			li_hizo_una					=TRUE
			li_simulacion				=ii_simulacion
			li_co_fabrica_modulo		=ii_co_fabrica_modu_new
			li_co_planta				=ii_co_planta_modu_new
			li_co_modulo				=ii_co_modulo_new
  			li_co_fabrica_exp			=ii_co_fabrica_exp
			ll_pedido					=il_pedido
			ll_cs_liberacion			=il_cs_liberacion
			ls_po  						=is_nu_orden
         li_co_fabrica_pt			=ii_co_fabrica_ref
			li_co_linea					=ii_co_linea
			ll_co_referencia			=il_co_referencia
			ll_co_color_pt  			=il_co_color_pt
         ls_tono						=is_tono
			li_cs_estilocolortono	=ii_cs_estilocolton
			li_cs_particion			=ii_cs_particion
			li_co_talla 				=lstr_parametros.entero[1]
         li_cs_orden_talla			=ll_filaactual
			li_cs_prioridad			=1
			ll_ca_programada			=lstr_parametros.entero[5]
			ll_ca_producida			=0
         ll_ca_pendiente			=lstr_parametros.entero[5]
			li_co_est_prog_talla		=1
			li_fuente_dato				=1
			ldt_fechahora = f_fecha_servidor()
			ldt_fe_creacion			=ldt_fechahora
         ldt_fe_actualizacion		=ldt_fechahora
			ls_usuario					=gstr_info_usuario.codigo_usuario
			ls_instancia				=gstr_info_usuario.instancia
			
			//inserta en dt_talla_pdnmodulo
			  INSERT INTO dt_talla_pdnmodulo  
         ( simulacion,             	co_fabrica,             co_planta,              	co_modulo,   
           co_fabrica_exp,         	pedido,              	cs_liberacion,             po,   
           co_fabrica_pt,          	co_linea,              	co_referencia,             co_color_pt,   
           tono,              		cs_estilocolortono,     cs_particion,              co_talla,   
           cs_orden_talla,          cs_prioridad,           ca_programada,             ca_producida,   
           ca_pendiente,            co_est_prog_talla,      fuente_dato,              	fe_creacion,   
           fe_actualizacion,        usuario,              	instancia )  
  VALUES ( :li_simulacion,          :li_co_fabrica_modulo,  :li_co_planta,             :li_co_modulo,  
  			  :li_co_fabrica_exp,      :ll_pedido,             :ll_cs_liberacion,         :ls_po,   
           :li_co_fabrica_pt,       :li_co_linea,           :ll_co_referencia,         :ll_co_color_pt,   
           :ls_tono,              	:li_cs_estilocolortono, :li_cs_particion,          :li_co_talla,   
           :li_cs_orden_talla,      :li_cs_prioridad,       :ll_ca_programada,         :ll_ca_producida,   
           :ll_ca_pendiente,        :li_co_est_prog_talla,  :li_fuente_dato,           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   :ls_usuario,            :ls_instancia )  ;
			  
			IF SQLCA.SQLCODE=-1 THEN
				lstr_parametros.entero[6]=0
				MessageBox("Error Base datos","No pudo guardar tallas de allocation parcial")
				ROLLBACK;
				lstr_parametros.hay_parametros = FALSE
				CloseWithReturn(parent,lstr_parametros)
				RETURN
			ELSE
				ll_insertados = ll_insertados + 1
				ll_ca_acumulado=ll_ca_acumulado + ll_ca_programada
			END IF
			//debe hacer update a unidades de anterior restando y si es cero debe borrar la talla
			IF ii_tipo_llamado=1 THEN
				IF lstr_parametros.entero[3]=ll_ca_programada THEN //borra la talla de el anterior
					DELETE FROM dt_talla_pdnmodulo  
					WHERE ( dt_talla_pdnmodulo.simulacion 				=:ii_simulacion  ) AND  
							( dt_talla_pdnmodulo.co_fabrica 				=:ii_co_fabrica_modu  ) AND  
							( dt_talla_pdnmodulo.co_planta 				=:ii_co_planta_modu  ) AND  
							( dt_talla_pdnmodulo.co_modulo 				=:ii_co_modulo  ) AND  
							( dt_talla_pdnmodulo.co_fabrica_exp 		=:ii_co_fabrica_exp  ) AND  
							( dt_talla_pdnmodulo.pedido 					=:il_pedido  ) AND  
							( dt_talla_pdnmodulo.cs_liberacion 			=:il_cs_liberacion  ) AND  
							( dt_talla_pdnmodulo.po 						=:is_nu_orden  ) AND  
							( dt_talla_pdnmodulo.co_fabrica_pt 			=:ii_co_fabrica_ref  ) AND  
							( dt_talla_pdnmodulo.co_linea 				=:ii_co_linea  ) AND  
							( dt_talla_pdnmodulo.co_referencia 			=:il_co_referencia  ) AND  
							( dt_talla_pdnmodulo.co_color_pt 			=:il_co_color_pt  ) AND  
							( dt_talla_pdnmodulo.tono 						=:is_tono  ) AND  
							( dt_talla_pdnmodulo.cs_estilocolortono 	=:ii_cs_estilocolton  ) AND  
							( dt_talla_pdnmodulo.cs_particion 			=:ii_cs_particion_anterior  ) AND  
							( dt_talla_pdnmodulo.co_talla 				=:lstr_parametros.entero[1]  )   ;
					IF SQLCA.SQLCODE = -1 THEN
						MessageBox("Error Base datos","No pudo borrar talla que qued$$HEX2$$f3002000$$ENDHEX$$sin unidades en asignaci$$HEX1$$f300$$ENDHEX$$n anterior")
						ROLLBACK;
						ll_filaactual=ll_filas + 1
						ll_ca_acumulado=-1
						lstr_parametros.hay_parametros = FALSE
						CloseWithReturn(parent,lstr_parametros)
						RETURN
					ELSE
					END IF

				ELSE
					IF lstr_parametros.entero[3]>ll_ca_programada THEN //update restando la ll_ca_programada
						UPDATE dt_talla_pdnmodulo  
							SET dt_talla_pdnmodulo.ca_programada=dt_talla_pdnmodulo.ca_programada - :ll_ca_programada,
							    dt_talla_pdnmodulo.ca_pendiente=dt_talla_pdnmodulo.ca_pendiente - :ll_ca_programada
						WHERE ( dt_talla_pdnmodulo.simulacion 				=:ii_simulacion  ) AND  
								( dt_talla_pdnmodulo.co_fabrica 				=:ii_co_fabrica_modu  ) AND  
								( dt_talla_pdnmodulo.co_planta 				=:ii_co_planta_modu  ) AND  
								( dt_talla_pdnmodulo.co_modulo 				=:ii_co_modulo  ) AND  
								( dt_talla_pdnmodulo.co_fabrica_exp 		=:ii_co_fabrica_exp  ) AND  
								( dt_talla_pdnmodulo.pedido 					=:il_pedido  ) AND  
								( dt_talla_pdnmodulo.cs_liberacion 			=:il_cs_liberacion  ) AND  
								( dt_talla_pdnmodulo.po 						=:is_nu_orden  ) AND  
								( dt_talla_pdnmodulo.co_fabrica_pt 			=:ii_co_fabrica_ref  ) AND  
								( dt_talla_pdnmodulo.co_linea 				=:ii_co_linea  ) AND  
								( dt_talla_pdnmodulo.co_referencia 			=:il_co_referencia  ) AND  
								( dt_talla_pdnmodulo.co_color_pt 			=:il_co_color_pt  ) AND  
								( dt_talla_pdnmodulo.tono 						=:is_tono  ) AND  
								( dt_talla_pdnmodulo.cs_estilocolortono 	=:ii_cs_estilocolton  ) AND  
								( dt_talla_pdnmodulo.cs_particion 			=:ii_cs_particion_anterior  ) AND  
								( dt_talla_pdnmodulo.co_talla 				=:lstr_parametros.entero[1]  )   ;
						IF SQLCA.SQLCODE = -1 THEN
							MessageBox("Error Base datos","No pudo actualizar unidades en asignaci$$HEX1$$f300$$ENDHEX$$n anterior")
							ROLLBACK;
							ll_filaactual=ll_filas + 1
							ll_ca_acumulado=-1
							lstr_parametros.hay_parametros = FALSE
							CloseWithReturn(parent,lstr_parametros)
							RETURN
						ELSE
						END IF
					ELSE
						IF lstr_parametros.entero[3]<ll_ca_programada THEN
						ELSE
							MessageBox("Error datos","No puede asignar m$$HEX1$$e100$$ENDHEX$$s de lo disponible por talla")
							ROLLBACK;
							ll_filaactual=ll_filas + 1
							ll_ca_acumulado=-1
							lstr_parametros.hay_parametros = FALSE
							CloseWithReturn(parent,lstr_parametros)
							RETURN
						END IF
					END IF
				END IF
			ELSE //TIPO DE LLAMADO =0 SOLO INSERTA Y NO DESCUENTA NI BORRA
			END IF
			
		END IF
			
	NEXT
	
	
	IF ii_tipo_llamado=0 THEN
		IF ll_ca_unidades_acumuladas <> ii_ca_a_asignar THEN
			MessageBox("Error Base datos","Las unidades en las tallas son diferentes a las unidades a partir")
			ROLLBACK;
			lstr_parametros.hay_parametros = FALSE
			CloseWithReturn(parent,lstr_parametros)
			RETURN
		ELSE
		END IF	
	ELSE
	END IF
	
	
	IF li_hizo_una THEN
	ELSE
		MESSAGEBOX("Advertencia","No seleccion$$HEX2$$f3002000$$ENDHEX$$unidades a partir")
		lstr_parametros.hay_parametros = FALSE
		CloseWithReturn(parent,lstr_parametros)
		RETURN
	END IF

		IF ii_tipo_llamado=1 THEN
			UPDATE dt_pdnxmodulo  
				  SET ca_programada 	= ca_programada - :ll_ca_acumulado,   
						ca_pendiente 	= ca_pendiente - :ll_ca_acumulado  
				WHERE ( dt_pdnxmodulo.simulacion 			= :ii_simulacion ) AND  
						( dt_pdnxmodulo.co_fabrica 			= :ii_co_fabrica_modu ) AND  
						( dt_pdnxmodulo.co_planta 				= :ii_co_planta_modu ) AND  
						( dt_pdnxmodulo.co_modulo 				= :ii_co_modulo ) AND  
						( dt_pdnxmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
						( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
						( dt_pdnxmodulo.cs_liberacion 		= :il_cs_liberacion ) AND  
						( dt_pdnxmodulo.po 						= :is_nu_orden ) AND  
						( dt_pdnxmodulo.co_fabrica_pt 		= :ii_co_fabrica_ref ) AND  
						( dt_pdnxmodulo.co_linea 				= :ii_co_linea ) AND  
						( dt_pdnxmodulo.co_referencia 		= :il_co_referencia ) AND  
						( dt_pdnxmodulo.co_color_pt 			= :il_co_color_pt ) AND  
						( dt_pdnxmodulo.tono 					= :is_tono ) AND  
						( dt_pdnxmodulo.cs_estilocolortono 	= :ii_cs_estilocolton ) AND  
						( dt_pdnxmodulo.cs_particion 			= :ii_cs_particion_anterior )   ;
			IF SQLCA.SQLCODE=-1 THEN
				MESSAGEBOX("Error Base Datos","No pudo actualizar el total de la asignaci$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
				lstr_parametros.hay_parametros = FALSE
				CloseWithReturn(parent,lstr_parametros)
				RETURN
			ELSE
				UPDATE dt_pdnxmodulo  
					  SET ca_programada 	= :ll_ca_acumulado,   
							ca_pendiente 	= :ll_ca_acumulado  
					WHERE ( dt_pdnxmodulo.simulacion 			= :ii_simulacion ) AND  
							( dt_pdnxmodulo.co_fabrica 			= :ii_co_fabrica_modu_new ) AND  
							( dt_pdnxmodulo.co_planta 				= :ii_co_planta_modu_new ) AND  
							( dt_pdnxmodulo.co_modulo 				= :ii_co_modulo_new ) AND  
							( dt_pdnxmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
							( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
							( dt_pdnxmodulo.cs_liberacion 		= :il_cs_liberacion ) AND  
							( dt_pdnxmodulo.po 						= :is_nu_orden ) AND  
							( dt_pdnxmodulo.co_fabrica_pt 		= :ii_co_fabrica_ref ) AND  
							( dt_pdnxmodulo.co_linea 				= :ii_co_linea ) AND  
							( dt_pdnxmodulo.co_referencia 		= :il_co_referencia ) AND  
							( dt_pdnxmodulo.co_color_pt 			= :il_co_color_pt ) AND  
							( dt_pdnxmodulo.tono 					= :is_tono ) AND  
							( dt_pdnxmodulo.cs_estilocolortono 	= :ii_cs_estilocolton ) AND  
							( dt_pdnxmodulo.cs_particion 			= :li_cs_particion )   ;
				IF SQLCA.SQLCODE=-1 THEN
					MESSAGEBOX("Error Base Datos","No pudo actualizar el total de la asignaci$$HEX1$$f300$$ENDHEX$$n")
					ROLLBACK;
					lstr_parametros.hay_parametros = FALSE
					CloseWithReturn(parent,lstr_parametros)
					RETURN
				ELSE
					SELECT  	SUM(dt_pdnxmodulo.ca_programada)
					 INTO 	:ll_unid_quedan_asigna
					 FROM    dt_pdnxmodulo
					WHERE ( dt_pdnxmodulo.simulacion 			= :ii_simulacion ) AND  
							( dt_pdnxmodulo.co_fabrica 			= :ii_co_fabrica_modu ) AND  
							( dt_pdnxmodulo.co_planta 				= :ii_co_planta_modu ) AND  
							( dt_pdnxmodulo.co_modulo 				= :ii_co_modulo ) AND  
							( dt_pdnxmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
							( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
							( dt_pdnxmodulo.cs_liberacion 		= :il_cs_liberacion ) AND  
							( dt_pdnxmodulo.po 						= :is_nu_orden ) AND  
							( dt_pdnxmodulo.co_fabrica_pt 		= :ii_co_fabrica_ref ) AND  
							( dt_pdnxmodulo.co_linea 				= :ii_co_linea ) AND  
							( dt_pdnxmodulo.co_referencia 		= :il_co_referencia ) AND  
							( dt_pdnxmodulo.co_color_pt 			= :il_co_color_pt ) AND  
							( dt_pdnxmodulo.tono 					= :is_tono ) AND  
							( dt_pdnxmodulo.cs_estilocolortono 	= :ii_cs_estilocolton ) AND  
							( dt_pdnxmodulo.cs_particion 			= :ii_cs_particion_anterior )   ;
					IF SQLCA.SQLCODE=-1 THEN
						MESSAGEBOX("Error Base Datos","No pudo buscar el total de unidades la asignaci$$HEX1$$f300$$ENDHEX$$n")
						ROLLBACK;
						lstr_parametros.hay_parametros = FALSE
						CloseWithReturn(parent,lstr_parametros)
						RETURN
					ELSE
						//buscar en dt_pdnxmodulo si ca_programada =0 borrar
							//borra primero de dt_programa_diario
							//borra luego de dt_talla_pdnmodulo
						IF ll_unid_quedan_asigna=0 OR ISNULL(ll_unid_quedan_asigna) THEN
							//BORRA TALLAS
							DELETE FROM dt_talla_pdnmodulo
									WHERE ( dt_talla_pdnmodulo.simulacion 			= :ii_simulacion ) AND  
									( dt_talla_pdnmodulo.co_fabrica 			= :ii_co_fabrica_modu ) AND  
									( dt_talla_pdnmodulo.co_planta 				= :ii_co_planta_modu ) AND  
									( dt_talla_pdnmodulo.co_modulo 				= :ii_co_modulo ) AND  
									( dt_talla_pdnmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
									( dt_talla_pdnmodulo.pedido 					= :il_pedido ) AND  
									( dt_talla_pdnmodulo.cs_liberacion 		= :il_cs_liberacion ) AND  
									( dt_talla_pdnmodulo.po 						= :is_nu_orden ) AND  
									( dt_talla_pdnmodulo.co_fabrica_pt 		= :ii_co_fabrica_ref ) AND  
									( dt_talla_pdnmodulo.co_linea 				= :ii_co_linea ) AND  
									( dt_talla_pdnmodulo.co_referencia 		= :il_co_referencia ) AND  
									( dt_talla_pdnmodulo.co_color_pt 			= :il_co_color_pt ) AND  
									( dt_talla_pdnmodulo.tono 					= :is_tono ) AND  
									( dt_talla_pdnmodulo.cs_estilocolortono 	= :ii_cs_estilocolton ) AND  
									( dt_talla_pdnmodulo.cs_particion 			= :ii_cs_particion_anterior )   ;
							IF SQLCA.SQLCODE=-1 THEN
								MESSAGEBOX("Error Base Datos","No pudo borrar las tallas de la asignaci$$HEX1$$f300$$ENDHEX$$n")
								ROLLBACK;
								lstr_parametros.hay_parametros = FALSE
								CloseWithReturn(parent,lstr_parametros)
								RETURN
							ELSE
							END IF
							//BORRA PROGRAMA DIARIO
							DELETE FROM dt_programa_diario
									WHERE ( dt_programa_diario.simulacion 			= :ii_simulacion ) AND  
									( dt_programa_diario.co_fabrica 			= :ii_co_fabrica_modu ) AND  
									( dt_programa_diario.co_planta 				= :ii_co_planta_modu ) AND  
									( dt_programa_diario.co_modulo 				= :ii_co_modulo ) AND  
									( dt_programa_diario.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
									( dt_programa_diario.pedido 					= :il_pedido ) AND  
									( dt_programa_diario.cs_liberacion 		= :il_cs_liberacion ) AND  
									( dt_programa_diario.po 						= :is_nu_orden ) AND  
									( dt_programa_diario.co_fabrica_pt 		= :ii_co_fabrica_ref ) AND  
									( dt_programa_diario.co_linea 				= :ii_co_linea ) AND  
									( dt_programa_diario.co_referencia 		= :il_co_referencia ) AND  
									( dt_programa_diario.co_color_pt 			= :il_co_color_pt ) AND  
									( dt_programa_diario.tono 					= :is_tono ) AND  
									( dt_programa_diario.cs_estilocolortono 	= :ii_cs_estilocolton ) AND  
									( dt_programa_diario.cs_particion 			= :ii_cs_particion_anterior )   ;
							IF SQLCA.SQLCODE=-1 THEN
								MESSAGEBOX("Error Base Datos","No pudo borrar la programaci$$HEX1$$f300$$ENDHEX$$n de la asignaci$$HEX1$$f300$$ENDHEX$$n")
								ROLLBACK;
								lstr_parametros.hay_parametros = FALSE
								CloseWithReturn(parent,lstr_parametros)
								RETURN
							ELSE
							END IF
							//BORRA ASIGNACION
							DELETE FROM dt_pdnxmodulo
									WHERE ( dt_pdnxmodulo.simulacion 			= :ii_simulacion ) AND  
									( dt_pdnxmodulo.co_fabrica 			= :ii_co_fabrica_modu ) AND  
									( dt_pdnxmodulo.co_planta 				= :ii_co_planta_modu ) AND  
									( dt_pdnxmodulo.co_modulo 				= :ii_co_modulo ) AND  
									( dt_pdnxmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
									( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
									( dt_pdnxmodulo.cs_liberacion 		= :il_cs_liberacion ) AND  
									( dt_pdnxmodulo.po 						= :is_nu_orden ) AND  
									( dt_pdnxmodulo.co_fabrica_pt 		= :ii_co_fabrica_ref ) AND  
									( dt_pdnxmodulo.co_linea 				= :ii_co_linea ) AND  
									( dt_pdnxmodulo.co_referencia 		= :il_co_referencia ) AND  
									( dt_pdnxmodulo.co_color_pt 			= :il_co_color_pt ) AND  
									( dt_pdnxmodulo.tono 					= :is_tono ) AND  
									( dt_pdnxmodulo.cs_estilocolortono 	= :ii_cs_estilocolton ) AND  
									( dt_pdnxmodulo.cs_particion 			= :ii_cs_particion_anterior )   ;
							IF SQLCA.SQLCODE=-1 THEN
								MESSAGEBOX("Error Base Datos","No pudo borrar la asignaci$$HEX1$$f300$$ENDHEX$$n que qued$$HEX2$$f3002000$$ENDHEX$$en cero")
								ROLLBACK;
								lstr_parametros.hay_parametros = FALSE
								CloseWithReturn(parent,lstr_parametros)
								RETURN
							ELSE
							END IF
						ELSE
						END IF					
					END IF
					lstr_parametros.hay_parametros = TRUE	
					COMMIT;
					closewithreturn(parent,lstr_parametros)	
					RETURN
				END IF
			END IF
		ELSE
			COMMIT;
			lstr_parametros.hay_parametros = TRUE
			closewithreturn(parent,lstr_parametros)	
			RETURN
		END IF
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_asignar_parciales_liberacion
integer height = 1328
end type

event dw_lista::itemchanged;DateTime 			ldt_fechahora
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DATE					ldt_fe_despacho_allocation

STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido

DECIMAL				ld_ca_minutos_std,ld_minutos_jornada,ld_ca_min_dispon_ini,ld_porc_eficiencia

s_base_parametros lstr_parametro

LONG					ll_ca_asignada,ll_ca_a_asignar


IF il_fila_actual > 0 THEN

	dw_lista.AcceptText()
	
	IF ii_tipo_llamado=1 THEN //PARTICION O TRASLADO DE CANTIDADES POR TALLA
		ll_ca_asignada 		= dw_lista.GetItemNumber(il_fila_actual, "ca_asignada")
		IF ISNULL(ll_ca_asignada) THEN
			ll_ca_asignada 		= dw_lista.GetItemNumber(il_fila_actual, "ca_unidades")
		ELSE
		END IF	
	ELSE//INSERCI$$HEX1$$d300$$ENDHEX$$N PARCIAL DE CANTIDADES POR TALLA
		ll_ca_asignada 		= dw_lista.GetItemNumber(il_fila_actual, "ca_faltan")
		IF ISNULL(ll_ca_asignada) THEN
			ll_ca_asignada 		= dw_lista.GetItemNumber(il_fila_actual, "ca_asignada")
			IF ISNULL(ll_ca_asignada) THEN
				ll_ca_asignada 		= dw_lista.GetItemNumber(il_fila_actual, "ca_unidades")
			ELSE
			END IF
		ELSE
		END IF	
//		ll_ca_total 		= dw_lista.GetItemNumber(il_fila_actual, "ca_asignada")
//		total_a_asignar
	END IF
	
	ll_ca_a_asignar 		= dw_lista.GetItemNumber(il_fila_actual, "ca_a_asignar")
	
	IF ISNULL(ll_ca_asignada) THEN
	ELSE
		IF ISNULL(ll_ca_a_asignar) THEN
		ELSE
			IF ll_ca_a_asignar=0 THEN
			ELSE
				IF ll_ca_a_asignar > ll_ca_asignada THEN
					MessageBox("Advertencia","Las unidades a asignar no deben ser mayores que las disponibles")
					RETURN 1
				ELSE
				END IF
			END IF
		END IF
	END IF
ELSE
END IF
end event

