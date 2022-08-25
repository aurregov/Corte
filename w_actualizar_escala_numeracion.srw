HA$PBExportHeader$w_actualizar_escala_numeracion.srw
forward
global type w_actualizar_escala_numeracion from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_escala_numeracion from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer height = 637
end type
global w_actualizar_escala_numeracion w_actualizar_escala_numeracion

on w_actualizar_escala_numeracion.create
call super::create
end on

on w_actualizar_escala_numeracion.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_escala_numeracion
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_escala_numeracion
end type

event pb_buscar::clicked;call super::clicked;LONG		ll_cs_orden_corte, ll_pedido,ll_co_referencia,ll_co_color_pt,ll_pedido_po,ll_ca_loteada,ll_m_lotes_conf  
Long  li_co_fabrica_exp,li_cs_liberacion,li_co_fabrica_pt,li_co_linea,li_cs_estilocolortono,li_co_talla 
STRING	ls_po, ls_tono       

//recorrer dt_escalas_reales

// DECLARE cur_loteo CURSOR FOR  
//  SELECT h_unidades_reales.cs_orden_corte,         dt_agrupa_pdn.co_fabrica_exp,   
//         dt_agrupa_pdn.pedido,            			dt_agrupa_pdn.cs_liberacion,   
//         dt_agrupa_pdn.po,            					dt_agrupa_pdn.co_fabrica_pt,   
//         dt_agrupa_pdn.co_linea,            			dt_agrupa_pdn.co_referencia,   
//         dt_agrupa_pdn.co_color_pt,         			dt_agrupa_pdn.tono,   
//         dt_agrupa_pdn.cs_estilocolortono,         dt_libera_estilos.pedido_po,            
//			dt_escalas_reales.co_talla,            	sum( dt_escalas_reales.ca_loteada)  
//    FROM h_unidades_reales,   
//         dt_escalas_reales,   
//         dt_agrupa_pdn,   
//         dt_libera_estilos  
//   WHERE ( dt_escalas_reales.cs_orden_corte 			= h_unidades_reales.cs_orden_corte ) and  
//         ( dt_escalas_reales.cs_parcial 				= h_unidades_reales.cs_parcial ) and  
//         ( dt_escalas_reales.cs_agrupacion 			= dt_agrupa_pdn.cs_agrupacion ) and  
//         ( dt_escalas_reales.cs_pdn 					= dt_agrupa_pdn.cs_pdn ) and  
//         ( dt_agrupa_pdn.co_fabrica_exp 				= dt_libera_estilos.co_fabrica_exp ) and  
//         ( dt_agrupa_pdn.pedido 							= dt_libera_estilos.pedido ) and  
//         ( dt_agrupa_pdn.cs_liberacion 				= dt_libera_estilos.cs_liberacion ) and  
//         ( dt_agrupa_pdn.po 								= dt_libera_estilos.nu_orden ) and  
//         ( dt_agrupa_pdn.co_fabrica_pt 				= dt_libera_estilos.co_fabrica ) and  
//         ( dt_agrupa_pdn.co_linea 						= dt_libera_estilos.co_linea ) and  
//         ( dt_agrupa_pdn.co_referencia 				= dt_libera_estilos.co_referencia ) and  
//         ( dt_agrupa_pdn.co_color_pt 					= dt_libera_estilos.co_color_pt ) and  
//         ( dt_agrupa_pdn.tono 							= dt_libera_estilos.tono ) and  
//         ( dt_agrupa_pdn.cs_estilocolortono 			= dt_libera_estilos.cs_estilocolortono ) and  
//         ( ( h_unidades_reales.cs_orden_corte 		> 0 ) AND  
//         ( h_unidades_reales.co_estado_lote_con 	= 8 ) )   
//group by 1,2,3,4,5,6,7,8,9,10,11,12,13
//order by 1,2,3,4,5,6,7,8,9,10,11,12,13; 
//

DECLARE cur_loteo CURSOR FOR  
  SELECT h_unidades_reales.cs_orden_corte,         dt_agrupa_pdn.co_fabrica_exp,   
         dt_agrupa_pdn.pedido,            			dt_agrupa_pdn.cs_liberacion,   
         dt_agrupa_pdn.po,            					dt_agrupa_pdn.co_fabrica_pt,   
         dt_agrupa_pdn.co_linea,            			dt_agrupa_pdn.co_referencia,   
         dt_agrupa_pdn.co_color_pt,         			dt_agrupa_pdn.tono,   
         dt_agrupa_pdn.cs_estilocolortono,         dt_libera_estilos.pedido_po,            
			dt_escalas_reales.co_talla,            	sum( dt_escalas_reales.ca_loteada)  
    FROM h_unidades_reales,   
         dt_escalas_reales,   
         dt_agrupa_pdn,   
         dt_libera_estilos  
   WHERE ( dt_escalas_reales.cs_orden_corte 			= h_unidades_reales.cs_orden_corte ) and  
         ( dt_escalas_reales.cs_parcial 				= h_unidades_reales.cs_parcial ) and  
         ( dt_escalas_reales.cs_agrupacion 			= dt_agrupa_pdn.cs_agrupacion ) and  
         ( dt_escalas_reales.cs_pdn 					= dt_agrupa_pdn.cs_pdn ) and  
         ( dt_agrupa_pdn.co_fabrica_exp 				= dt_libera_estilos.co_fabrica_exp ) and  
         ( dt_agrupa_pdn.pedido 							= dt_libera_estilos.pedido ) and  
         ( dt_agrupa_pdn.cs_liberacion 				= dt_libera_estilos.cs_liberacion ) and  
         ( dt_agrupa_pdn.po 								= 'W117909' ) and  
         ( dt_agrupa_pdn.co_fabrica_pt 				= dt_libera_estilos.co_fabrica ) and  
         ( dt_agrupa_pdn.co_linea 						= dt_libera_estilos.co_linea ) and  
         ( dt_agrupa_pdn.co_referencia 				= 90152 ) and  
         ( dt_agrupa_pdn.co_color_pt 					= 452 ) and  
         ( dt_agrupa_pdn.tono 							= 'B' ) and  
         ( dt_agrupa_pdn.cs_estilocolortono 			= dt_libera_estilos.cs_estilocolortono ) and  
         ( ( h_unidades_reales.cs_orden_corte 		> 0 ) AND  
         ( h_unidades_reales.co_estado_lote_con 	= 8 ) )   
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
order by 1,2,3,4,5,6,7,8,9,10,11,12,13; 


open cur_loteo;

fetch cur_loteo into :ll_cs_orden_corte,         	:li_co_fabrica_exp,   
							:ll_pedido,            			:li_cs_liberacion,   
							:ls_po,            				:li_co_fabrica_pt,   
							:li_co_linea,            		:ll_co_referencia,   
							:ll_co_color_pt,         		:ls_tono,   
							:li_cs_estilocolortono,       :ll_pedido_po,            
							:li_co_talla,            		:ll_ca_loteada;
							
do while sqlca.sqlcode=0
	
	//select a m_lotes_conf_para hallar un solo registro
	  SELECT count(*)  
    INTO :ll_m_lotes_conf  
    FROM m_lotes_conf  
   WHERE m_lotes_conf.co_fabrica 		> 0  and 
	      ( m_lotes_conf.co_linea 		=  :li_co_linea ) AND  
         ( m_lotes_conf.co_referencia 	=  :ll_co_referencia) AND  
         ( m_lotes_conf.co_talla 		=  :li_co_talla) AND  
         ( m_lotes_conf.co_calidad 		=  1) AND  
         ( m_lotes_conf.co_color 		=  :ll_co_color_pt) AND  
         ( m_lotes_conf.cs_ordencorte 	=  :ll_cs_orden_corte) AND  
         ( m_lotes_conf.po 				=  :ls_po) ;
	if sqlca.sqlcode=-1 then
		messagebox("error bd","no pudo consultar m_lotes_conf")
		return
	else
	end if
	
	if ll_m_lotes_conf=1 then
		//update m_lotes_conf
		UPDATE m_lotes_conf  
		  SET ca_numerada = :ll_ca_loteada  
		WHERE ( m_lotes_conf.co_fabrica 		> 0 ) AND  
				( m_lotes_conf.co_linea 		=  :li_co_linea ) AND  
				( m_lotes_conf.co_referencia 	=  :ll_co_referencia) AND  
				( m_lotes_conf.co_talla 		=  :li_co_talla) AND  
				( m_lotes_conf.co_calidad 		=  1) AND  
				( m_lotes_conf.co_color 		=  :ll_co_color_pt) AND  
				( m_lotes_conf.cs_ordencorte 	=  :ll_cs_orden_corte) AND  
				( m_lotes_conf.po 				=  :ls_po);
		if sqlca.sqlcode=-1 then
			messagebox("error bd","no pudo upd m_lotes_conf")
			return
		else
		end if
	else
		messagebox("error datos","no pudo upd, existe mas de un registro en m_lotes_conf")
		return
	end if
	
//	//actualiza liberacion
//	UPDATE dt_libera_estilos  
//     SET ca_numerada = ca_numerada + :ll_ca_loteada  
//   WHERE ( dt_libera_estilos.co_fabrica_exp 			= :li_co_fabrica_exp ) AND  
//         ( dt_libera_estilos.pedido 					= :ll_pedido ) AND  
//         ( dt_libera_estilos.cs_liberacion 			= :li_cs_liberacion ) AND  
//         ( dt_libera_estilos.nu_orden 					= :ls_po ) AND  
//         ( dt_libera_estilos.co_fabrica 				= :li_co_fabrica_pt ) AND  
//         ( dt_libera_estilos.co_linea 					= :li_co_linea ) AND  
//         ( dt_libera_estilos.co_referencia 			= :ll_co_referencia ) AND  
//         ( dt_libera_estilos.co_color_pt 				= :ll_co_color_pt ) AND  
//         ( dt_libera_estilos.tono 						= :ls_tono ) AND  
//         ( dt_libera_estilos.cs_estilocolortono 	= :li_cs_estilocolortono );
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no pudo upd dt_libera_estilos")
//		return
//	else
//	end if
//	
//	//actualiza dt_escalasxtela
//	UPDATE dt_escalasxtela  
//     SET ca_numerada = ca_numerada + :ll_ca_loteada  
//   WHERE ( dt_escalasxtela.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//         ( dt_escalasxtela.pedido 					= :ll_pedido ) AND  
//         ( dt_escalasxtela.cs_liberacion 			= :li_cs_liberacion ) AND  
//         ( dt_escalasxtela.nu_orden 				= :ls_po ) AND  
//         ( dt_escalasxtela.co_fabrica_pt 			= :li_co_fabrica_pt ) AND  
//         ( dt_escalasxtela.co_linea 				= :li_co_linea ) AND  
//         ( dt_escalasxtela.co_referencia 			= :ll_co_referencia ) AND  
//         ( dt_escalasxtela.co_color_pt 			= :ll_co_color_pt ) AND  
//         ( dt_escalasxtela.tono 						= :ls_tono ) AND  
//         ( dt_escalasxtela.cs_estilocolortono 	= :li_cs_estilocolortono ) AND  
//         ( dt_escalasxtela.co_talla 				= :li_co_talla )           ;
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no pudo upd dt_escalasxtela")
//		return
//	else
//	end if
	
	//actualiza pedpend_exp
//	UPDATE pedpend_exp  
//     SET ca_confecc =  :ll_ca_loteada  
//   WHERE ( pedpend_exp.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//         ( pedpend_exp.pedido 				= :ll_pedido_po ) AND  
//         ( pedpend_exp.nu_orden 				= :ls_po ) AND  
//         ( pedpend_exp.co_fabrica 			= :li_co_fabrica_pt ) AND  
//         ( pedpend_exp.co_linea 				= :li_co_linea ) AND  
//         ( pedpend_exp.co_referencia 		= :ll_co_referencia ) AND  
//         ( pedpend_exp.co_color 				= :ll_co_color_pt ) AND  
//         ( pedpend_exp.co_talla 				= :li_co_talla )  ;
//			//( pedpend_exp.nu_cut 				in ('0','1'));
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no pudo upd pedpend_exp")
//		return
//	else
//	end if
	
	
//	update dt_pdnxmodulo
//	UPDATE dt_pdnxmodulo  
//     SET ca_numerada = ca_numerada + :ll_ca_loteada  
//   WHERE ( dt_pdnxmodulo.simulacion 			= 1 ) AND  
//         ( dt_pdnxmodulo.co_fabrica 			= 91 ) AND  
//         ( dt_pdnxmodulo.co_planta 				= 2 ) AND  
//         ( dt_pdnxmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//         ( dt_pdnxmodulo.pedido 					= :ll_pedido ) AND  
//         ( dt_pdnxmodulo.cs_liberacion 		= :li_cs_liberacion ) AND  
//         ( dt_pdnxmodulo.po 						= :ls_po ) AND  
//         ( dt_pdnxmodulo.co_fabrica_pt 		= :li_co_fabrica_pt ) AND  
//         ( dt_pdnxmodulo.co_linea 				= :li_co_linea ) AND  
//         ( dt_pdnxmodulo.co_referencia 		= :ll_co_referencia ) AND  
//         ( dt_pdnxmodulo.co_color_pt 			= :ll_co_color_pt ) AND  
//         ( dt_pdnxmodulo.tono 					= :ls_tono ) AND  
//         ( dt_pdnxmodulo.cs_estilocolortono 	= :li_cs_estilocolortono )            ;
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no pudo upd dt_pdnxmodulo")
//		return
//	else
//	end if
//	
//	//actualiza dt_talla_pdnxmodulo
//	UPDATE dt_talla_pdnmodulo  
//     SET ca_numerada = ca_numerada + :ll_ca_loteada  
//   WHERE ( dt_talla_pdnmodulo.simulacion 				= 1 ) AND  
//         ( dt_talla_pdnmodulo.co_fabrica 				= 91 ) AND  
//         ( dt_talla_pdnmodulo.co_planta 				= 2 ) AND  
//         ( dt_talla_pdnmodulo.co_fabrica_exp 		= :li_co_fabrica_exp ) AND  
//         ( dt_talla_pdnmodulo.pedido 					= :ll_pedido ) AND  
//         ( dt_talla_pdnmodulo.cs_liberacion 			= :li_cs_liberacion ) AND  
//         ( dt_talla_pdnmodulo.po 						= :ls_po ) AND  
//         ( dt_talla_pdnmodulo.co_fabrica_pt 			= :li_co_fabrica_pt ) AND  
//         ( dt_talla_pdnmodulo.co_linea 				= :li_co_linea ) AND  
//         ( dt_talla_pdnmodulo.co_referencia 			= :ll_co_referencia ) AND  
//         ( dt_talla_pdnmodulo.co_referencia 			= :ll_co_color_pt ) AND  
//         ( dt_talla_pdnmodulo.tono 						= :ls_tono ) AND  
//         ( dt_talla_pdnmodulo.cs_estilocolortono 	= :li_cs_estilocolortono )  ;
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no pudo upd dt_talla_pdnmodulo")
//		return
//	else
//	end if
//	

	
	fetch cur_loteo into :ll_cs_orden_corte,        :li_co_fabrica_exp,   
							:ll_pedido,            			:li_cs_liberacion,   
							:ls_po,            				:li_co_fabrica_pt,   
							:li_co_linea,            		:ll_co_referencia,   
							:ll_co_color_pt,         		:ls_tono,   
							:li_cs_estilocolortono,       :ll_pedido_po,            
							:li_co_talla,            		:ll_ca_loteada;
	

loop
		
close cur_loteo;

commit;
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_escala_numeracion
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_escala_numeracion
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_escala_numeracion
end type

