HA$PBExportHeader$w_actualizar_rayas_en_agrupaciones.srw
forward
global type w_actualizar_rayas_en_agrupaciones from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_rayas_en_agrupaciones from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer height = 637
end type
global w_actualizar_rayas_en_agrupaciones w_actualizar_rayas_en_agrupaciones

on w_actualizar_rayas_en_agrupaciones.create
call super::create
end on

on w_actualizar_rayas_en_agrupaciones.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_rayas_en_agrupaciones
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_rayas_en_agrupaciones
end type

event pb_buscar::clicked;Long		li_cs_pdn,li_raya, li_co_caract,li_diametro,li_raya_en_agrupacion
Long		li_rayas_en_bases,li_base_trazos,li_max_cs_base_trazos
LONG			ll_cs_agrupacion,ll_co_modelo,ll_ca_unidades,ll_co_reftel,ll_co_color_te
STRING		ls_usuario,ls_instancia
//DATE		
DATETIME		ldt_fe_creacion,ldt_fe_actualizacion
  
ls_usuario="admtelas"
ls_instancia="nicoledb"
			



//buscar rayas faltantes por agrupacion
DECLARE cur_rayasxagrupa CURSOR FOR
SELECT DISTINCT dt_agrupa_pdn.cs_agrupacion,   
//         dt_agrupa_pdn.cs_pdn,   
         dt_modelos.co_modelo,   
         dt_modelos.raya,   
         dt_agrupa_pdn.ca_unidades,   
         dt_color_modelo.co_reftel,   
         dt_color_modelo.co_caract,   
         dt_color_modelo.diametro,   
         dt_color_modelo.co_color_te  
    FROM dt_agrupa_pdn,   
         dt_agrupaescalapdn,   
         dt_modelos,   
         dt_color_modelo  
   WHERE ( dt_agrupaescalapdn.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion ) and  
         ( dt_agrupaescalapdn.cs_pdn = dt_agrupa_pdn.cs_pdn ) and  
         ( dt_agrupa_pdn.co_fabrica_pt = dt_modelos.co_fabrica ) and  
         ( dt_agrupa_pdn.co_linea = dt_modelos.co_linea ) and  
         ( dt_agrupa_pdn.co_referencia = dt_modelos.co_referencia ) and  
         ( dt_agrupa_pdn.co_color_pt = dt_modelos.co_color_pt ) and  
         ( dt_agrupaescalapdn.co_talla = dt_modelos.co_talla ) and  
         ( dt_color_modelo.co_fabrica = dt_modelos.co_fabrica ) and  
         ( dt_color_modelo.co_linea = dt_modelos.co_linea ) and  
         ( dt_color_modelo.co_referencia = dt_modelos.co_referencia ) and  
         ( dt_color_modelo.co_talla = dt_modelos.co_talla ) and  
         ( dt_color_modelo.co_calidad = dt_modelos.co_calidad ) and  
         ( dt_color_modelo.co_color_pt = dt_modelos.co_color_pt ) and  
         ( dt_color_modelo.co_modelo = dt_modelos.co_modelo ) and  
         ( ( dt_agrupa_pdn.cs_agrupacion > 0 ) )   ;
			
			
OPEN cur_rayasxagrupa;
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo abrir cursor rayasxagrupa")
	RETURN
ELSE
END IF

FETCH cur_rayasxagrupa
	INTO	:ll_cs_agrupacion,   
//			:li_cs_pdn,   
			:ll_co_modelo,   
			:li_raya,   
			:ll_ca_unidades,   
			:ll_co_reftel,   
			:li_co_caract,   
			:li_diametro,   
			:ll_co_color_te 	;
			
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo recuperar datos en cursor rayasxagrupa")
	RETURN
ELSE  

END IF

DO WHILE SQLCA.SQLCODE=0
	
	//dt_agrupa_pdn_raya
	SELECT count(*)  
    INTO :li_raya_en_agrupacion  
    FROM dt_agrupa_pdn_raya  
   WHERE ( dt_agrupa_pdn_raya.cs_agrupacion = :ll_cs_agrupacion ) AND  
         ( dt_agrupa_pdn_raya.cs_pdn = :li_cs_pdn ) AND  
         ( dt_agrupa_pdn_raya.co_modelo = :ll_co_modelo ) AND  
         ( dt_agrupa_pdn_raya.raya = :li_raya )   ;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("Error bd","No pudo recuperar datos en cursor rayasxagrupa")
		RETURN
	ELSE
	END IF
	
	IF li_raya_en_agrupacion = 0 OR ISNULL(li_raya_en_agrupacion) THEN

		ldt_fe_creacion=f_fecha_servidor()
		ldt_fe_actualizacion=f_fecha_servidor()
		
		//insertar en dt_agrupa_pdn_raya
		INSERT INTO dt_agrupa_pdn_raya  
         ( cs_agrupacion,   
           cs_pdn,   
           co_modelo,   
           raya,   
           ca_unidades,   
           co_tipo,   
           co_estado,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
  VALUES ( :ll_cs_agrupacion,   
           :li_cs_pdn,   
           :ll_co_modelo,   
           :li_raya,   
           :ll_ca_unidades,   
           1,   
           1,   
           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   
           :ls_usuario,   
           :ls_instancia )  ;
		IF SQLCA.SQLCODE=-1 THEN
			MESSAGEBOX("Error bd","No pudo insertar en dt_agrupa_pdn_raya")
			RETURN
		ELSE
		END IF
	ELSE
	END IF
	//h_base_trazos
	SELECT count(*)  
    INTO :li_rayas_en_bases  
    FROM h_base_trazos  
   WHERE ( h_base_trazos.cs_agrupacion = :ll_cs_agrupacion ) AND  
         ( h_base_trazos.raya = :li_raya )   ;
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("Error bd","No pudo recuperar datos en h_base_trazos")
		RETURN
	ELSE
	END IF
	
	IF li_rayas_en_bases = 0 OR ISNULL(li_rayas_en_bases) THEN

		ldt_fe_creacion=f_fecha_servidor()
		ldt_fe_actualizacion=f_fecha_servidor()
		
		li_max_cs_base_trazos=0
		
		//max cs_base_trazos
		SELECT max(h_base_trazos.cs_base_trazos )  
		 INTO :li_max_cs_base_trazos  
		 FROM h_base_trazos  
		WHERE h_base_trazos.cs_agrupacion = :ll_cs_agrupacion   ;
		IF SQLCA.SQLCODE=-1 THEN
			MESSAGEBOX("Error bd","No pudo recuperar el max cs_base_trazos")
			RETURN
		ELSE
		END IF
		
		IF ISNULL(li_max_cs_base_trazos) THEN
			li_max_cs_base_trazos=0
		ELSE
		END IF
		
		li_max_cs_base_trazos=li_max_cs_base_trazos + 1

		
		li_base_trazos=li_max_cs_base_trazos
		
		//insert into h_base_trazos
		INSERT INTO h_base_trazos  
         ( cs_agrupacion,   
           cs_base_trazos,   
           raya,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia,   
           co_estado )  
  VALUES ( :ll_cs_agrupacion,   
           :li_base_trazos,   
           :li_raya,   
           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   
           :ls_usuario,   
           :ls_instancia,   
           1 )  ;
		IF SQLCA.SQLCODE=-1 THEN
			MESSAGEBOX("Error bd","No pudo INSERT en h_base_trazos")
			RETURN
		ELSE
			//dt_pdnxbase
	

			//dt_escalaxpdnbase
	
			//dt_rayas_telaxbase		
			
		END IF
	ELSE
		li_base_trazos=0
	END IF
	
	
	
	
	
	FETCH cur_rayasxagrupa
	INTO	:ll_cs_agrupacion,   
			//:li_cs_pdn,   
			:ll_co_modelo,   
			:li_raya,   
			:ll_ca_unidades,   
			:ll_co_reftel,   
			:li_co_caract,   
			:li_diametro,   
			:ll_co_color_te 	;
			
	IF SQLCA.SQLCODE=-1 THEN
		MESSAGEBOX("Error bd","No pudo recuperar datos en cursor rayasxagrupa")
		RETURN
	ELSE
	END IF
	
LOOP

CLOSE cur_rayasxagrupa;
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo cerrar cursor rayasxagrupa")
	RETURN
ELSE
END IF

COMMIT;
IF SQLCA.SQLCODE=-1 THEN
	MESSAGEBOX("Error bd","No pudo Asentar datos del proceso")
	RETURN
ELSE
END IF

end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_rayas_en_agrupaciones
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_rayas_en_agrupaciones
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_rayas_en_agrupaciones
end type

