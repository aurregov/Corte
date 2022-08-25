HA$PBExportHeader$w_actualizar_dt_confeccion.srw
forward
global type w_actualizar_dt_confeccion from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_dt_confeccion from w_base_buscar_interactivo
end type
global w_actualizar_dt_confeccion w_actualizar_dt_confeccion

on w_actualizar_dt_confeccion.create
call super::create
end on

on w_actualizar_dt_confeccion.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_dt_confeccion
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_dt_confeccion
end type

event pb_buscar::clicked;call super::clicked; long ll_centro,ll_subcentro,ll_fabrica_pt,ll_linea,ll_referencia,ll_color,ll_talla,ll_unidades
 long ll_contador
 
 DECLARE mv_fisico CURSOR FOR  
     SELECT DISTINCT mv_fisico.co_centro,   
         mv_fisico.co_subcentro,   
         dt_canasta_corte.co_fabrica_ref,   
         dt_canasta_corte.co_linea,   
         dt_canasta_corte.co_referencia,   
         dt_canasta_corte.co_color,   
         dt_canasta_corte.co_talla,   
         sum(dt_canasta_corte.ca_actual)  
    FROM mv_fisico,   
         h_canasta_corte,   
         dt_canasta_corte  
   WHERE ( mv_fisico.bongo = h_canasta_corte.pallet_id ) and  
         ( h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta ) and  
         ( ( mv_fisico.co_subcentro = 5 ) AND  
         ( dt_canasta_corte.cs_secuencia = 1 ) )   
GROUP BY mv_fisico.co_centro,   
         mv_fisico.co_subcentro,   
         dt_canasta_corte.co_fabrica_ref,   
         dt_canasta_corte.co_linea,   
         dt_canasta_corte.co_referencia,   
         dt_canasta_corte.co_color,   
         dt_canasta_corte.co_talla  ;
			
			OPEN mv_fisico;
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo abrir cursor" )
	RETURN
ELSE
END IF

FETCH mv_fisico
	INTO :ll_centro,:ll_subcentro,:ll_fabrica_pt,:ll_linea,:ll_referencia,:ll_color,:ll_talla,:ll_unidades;
  
  IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo recuperar datos en cursor ")
	RETURN
ELSE  
END IF

DO WHILE SQLCA.SQLCODE=0
    SELECT count(*)  
    INTO :ll_contador  
    FROM dt_confeccion  
   WHERE ( dt_confeccion.co_fabrica_exp = 91 ) AND  
         ( dt_confeccion.co_planta = 1 ) AND  
         ( dt_confeccion.co_centro = :ll_centro ) AND  
         ( dt_confeccion.co_subcentro = :ll_subcentro ) AND  
         ( dt_confeccion.co_fabrica = :ll_fabrica_pt ) AND  
         ( dt_confeccion.co_linea = :ll_linea ) AND  
         ( dt_confeccion.co_referencia = :ll_referencia ) AND  
         ( dt_confeccion.co_color = :ll_color ) AND  
         ( dt_confeccion.co_talla = :ll_talla ) AND  
         ( dt_confeccion.ano = 2003 ) AND  
         ( dt_confeccion.mes = 10 )   
           ;

		IF ll_contador > 0 THEN
			     UPDATE dt_confeccion  
				  SET ca_inicial = :ll_unidades  
				WHERE ( dt_confeccion.co_fabrica_exp = 91 ) AND  
						( dt_confeccion.co_planta = 1 ) AND  
						( dt_confeccion.co_centro = :ll_centro ) AND  
						( dt_confeccion.co_subcentro = :ll_subcentro ) AND  
						( dt_confeccion.co_fabrica = :ll_fabrica_pt ) AND  
						( dt_confeccion.co_linea = :ll_linea ) AND  
						( dt_confeccion.co_referencia = :ll_referencia ) AND  
						( dt_confeccion.co_talla = :ll_talla ) AND  
						( dt_confeccion.co_color = :ll_color ) AND  
						( dt_confeccion.ano = 2003 ) AND  
						( dt_confeccion.mes = 10 )   ;
							

		ELSE
			  INSERT INTO dt_confeccion  
         ( co_fabrica_exp,   
           co_planta,   
           co_bodega,   
           co_centro,   
           co_subcentro,   
           co_fabrica,   
           co_linea,   
           co_referencia,   
           co_talla,   
           co_calidad,   
           co_color,   
           ano,   
           mes,   
           ca_inicial,   
           ca_entradas,   
           ca_salidas,   
           ca_transito,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
  VALUES ( 91,   
           1,   
           1,   
           :ll_centro,   
           :ll_subcentro,   
           :ll_fabrica_pt,   
           :ll_linea,   
           :ll_referencia,   
           :ll_talla,   
           1,   
           :ll_color,   
           2003,   
           10,   
           :ll_unidades,   
           0,   
           0,   
           0,   
           current,   
           current,   
           'marias',   
           'nicoledb' )  ;
		END IF
		
	 FETCH mv_fisico
	INTO :ll_centro,:ll_subcentro,:ll_fabrica_pt,:ll_linea,:ll_referencia,:ll_color,:ll_talla,:ll_unidades;

LOOP
 
	CLOSE mv_fisico;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("Error bd","No pudo cerrar cursor ")
		RETURN
	ELSE
	END IF

COMMIT;

	

end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_dt_confeccion
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_dt_confeccion
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_dt_confeccion
end type

