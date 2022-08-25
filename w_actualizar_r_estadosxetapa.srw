HA$PBExportHeader$w_actualizar_r_estadosxetapa.srw
forward
global type w_actualizar_r_estadosxetapa from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_r_estadosxetapa from w_base_buscar_interactivo
end type
global w_actualizar_r_estadosxetapa w_actualizar_r_estadosxetapa

on w_actualizar_r_estadosxetapa.create
call super::create
end on

on w_actualizar_r_estadosxetapa.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_r_estadosxetapa
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_r_estadosxetapa
end type

event pb_buscar::clicked;call super::clicked;  
 date ld_ano_mes
 datetime ldt_fe_movimiento
 long ll_etapa,ll_cs_dato,ll_cs_orden_corte,ll_cs_agrupacion,ll_cs_pdn,ll_ca_inicial   
 long ll_co_centro,ll_co_subcentro,ll_bongo,ll_co_etapa
  
    DECLARE mv_fisico CURSOR FOR  
	 SELECT mv_fisico.ano_mes,   
         mv_fisico.fe_movimiento,   
         mv_fisico.cs_dato,   
         mv_fisico.cs_orden_corte,   
         mv_fisico.cs_agrupacion,   
         mv_fisico.cs_pdn,   
         mv_fisico.bongo,   
         mv_fisico.ca_unidades,   
         mv_fisico.co_centro,   
         mv_fisico.co_subcentro,   
         m_etapas.co_etapa  
    FROM m_etapas,   
         m_rutas_etapa,   
         mv_fisico  
   WHERE ( mv_fisico.co_transaccion = m_rutas_etapa.co_transaccion ) and  
         ( mv_fisico.co_ruta_etapa = m_rutas_etapa.co_ruta_etapa ) and  
         ( m_rutas_etapa.co_etapa_destino = m_etapas.co_etapa )   
ORDER BY m_etapas.co_etapa ASC  ;

OPEN mv_fisico;
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo abrir cursor" )
	RETURN
ELSE
END IF

FETCH mv_fisico
	INTO :ld_ano_mes,:ldt_fe_movimiento,:ll_cs_dato,:ll_cs_orden_corte,:ll_cs_agrupacion,:ll_cs_pdn,:ll_bongo,:ll_ca_inicial,:ll_co_centro,:ll_co_subcentro,:ll_co_etapa;
  
  IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo recuperar datos en cursor ")
	RETURN
ELSE  
END IF

DO WHILE SQLCA.SQLCODE=0
  INSERT INTO r_estadosxetapa  
         ( ano_mes,   
           etapa,   
           cs_dato,   
           cs_orden_corte,   
           cs_agrupacion,   
           cs_pdn,   
           ca_inicial,   
           ca_entradas,   
           ca_salidas,   
           ca_saldo,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia,   
           co_centro,   
           co_subcentro )  
  VALUES ( :ld_ano_mes,   
           :ll_co_etapa,   
           :ll_cs_dato,   
           :ll_cs_orden_corte,   
           :ll_cs_agrupacion,   
           :ll_cs_pdn,   
           :ll_ca_inicial,   
           0,   
           0,   
           0,   
           :ldt_fe_movimiento,   
           :ldt_fe_movimiento,   
           'marias',   
           'nicoledb',   
           :ll_co_centro,   
           :ll_co_subcentro )  ;
			  FETCH mv_fisico
	INTO :ld_ano_mes,:ldt_fe_movimiento,:ll_cs_dato,:ll_cs_orden_corte,:ll_cs_agrupacion,:ll_cs_pdn,:ll_bongo,:ll_ca_inicial,:ll_co_centro,:ll_co_subcentro,:ll_co_etapa;

 LOOP

CLOSE mv_fisico;
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo cerrar cursor ")
	RETURN
ELSE
END IF

COMMIT;

end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_r_estadosxetapa
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_r_estadosxetapa
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_r_estadosxetapa
end type

