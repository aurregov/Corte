HA$PBExportHeader$w_identificar_faltantes_rayas_en_liberac.srw
forward
global type w_identificar_faltantes_rayas_en_liberac from w_base_buscar_interactivo
end type
end forward

global type w_identificar_faltantes_rayas_en_liberac from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer height = 637
end type
global w_identificar_faltantes_rayas_en_liberac w_identificar_faltantes_rayas_en_liberac

on w_identificar_faltantes_rayas_en_liberac.create
call super::create
end on

on w_identificar_faltantes_rayas_en_liberac.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_identificar_faltantes_rayas_en_liberac
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_identificar_faltantes_rayas_en_liberac
end type

event pb_buscar::clicked;Long		li_co_fabrica_exp, li_cs_liberacion, li_co_fabrica, li_co_linea
Long		li_cs_estilocolortono,li_co_talla,li_raya,li_co_caract,li_diametro
LONG			ll_pedido,ll_co_referencia,ll_co_color_pt,ll_cs_ordenpd_pt,li_raya_liberada
LONG			ll_co_modelo, ll_co_reftel,ll_co_color_te,li_co_fabrica_tela,ll_ca_unidades
STRING		ls_gpa,ls_nu_orden,ls_tono,ls_de_modelo
DECIMAL 		ld_yield,ld_ca_tela,ld_ancho_cortable
DATETIME		ldt_fe_creacion
TRANSACTION			itr_tela

itr_tela = Create Transaction

itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF



//
//DELETE FROM t_falta_raya_lib  ;
//IF SQLCA.SQLCODE=-1 THEN
//	MessageBox("Error Base Datos","Error al borrar tabla de resultado")
//	return
//ELSE
//END IF
//
//buscar en liberaciones grupo, liberacion, op
DECLARE cur_liberaciones CURSOR FOR  
   SELECT dt_libera_estilos.co_fabrica_exp,   
         dt_libera_estilos.pedido,   
         peddig.gpa,   
         dt_libera_estilos.cs_liberacion,   
         dt_libera_estilos.nu_orden,   
         dt_libera_estilos.co_fabrica,   
         dt_libera_estilos.co_linea,   
         dt_libera_estilos.co_referencia,   
         dt_libera_estilos.co_color_pt,   
         dt_libera_estilos.tono,   
         dt_libera_estilos.cs_estilocolortono,   
         dt_libera_estilos.cs_ordenpd_pt,   
           
         dt_libera_estilos.fe_creacion  
    FROM dt_libera_estilos,   
         peddig   
         
   WHERE ( dt_libera_estilos.pedido = peddig.pedido ) and  

  
         ( ( dt_libera_estilos.co_fabrica_exp > 0 ) AND  
         ( dt_libera_estilos.cs_ordenpd_pt is not null ) AND  
         ( date(dt_libera_estilos.fe_creacion) >= "01-11-2002" )  )   
ORDER BY dt_libera_estilos.co_fabrica_exp ASC,   
         dt_libera_estilos.pedido ASC,   
         dt_libera_estilos.cs_liberacion ASC,   
         dt_libera_estilos.cs_ordenpd_pt ASC   
         ;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","Error al declarar cursor liberaciones")
	return
ELSE
END IF

OPEN cur_liberaciones;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","Error al abrir cursor liberacione")
	return
ELSE
END IF

FETCH cur_liberaciones
	INTO 	:li_co_fabrica_exp,   
         :ll_pedido, 
			:ls_gpa,  
         :li_cs_liberacion,   
         :ls_nu_orden,   
         :li_co_fabrica,   
         :li_co_linea,   
         :ll_co_referencia,   
         :ll_co_color_pt,   
         :ls_tono,   
         :li_cs_estilocolortono,   
         :ll_cs_ordenpd_pt,   
			
         :ldt_fe_creacion;

IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","Error al traer cursor liberacione")
	return
ELSE
END IF

DO WHILE SQLCA.SQLCODE=0
	
	//buscar en ficha
	DECLARE cur_rayas CURSOR FOR  
  SELECT DISTINCT dt_modelos.co_modelo,   
         dt_modelos.de_modelo,   
         dt_modelos.raya,   
         dt_color_modelo.co_reftel,   
         dt_color_modelo.co_caract,   
         dt_color_modelo.diametro,   
         dt_color_modelo.co_color_te  
    FROM dt_modelos,   
         dt_color_modelo  
   WHERE ( dt_color_modelo.co_fabrica = dt_modelos.co_fabrica ) and  
         ( dt_color_modelo.co_linea = dt_modelos.co_linea ) and  
         ( dt_color_modelo.co_referencia = dt_modelos.co_referencia ) and  
         ( dt_color_modelo.co_talla = dt_modelos.co_talla ) and  
         ( dt_color_modelo.co_calidad = dt_modelos.co_calidad ) and  
         ( dt_color_modelo.co_color_pt = dt_modelos.co_color_pt ) and  
         ( dt_color_modelo.co_modelo = dt_modelos.co_modelo ) and  
         ( ( dt_modelos.co_fabrica = :li_co_fabrica ) AND  
         ( dt_modelos.co_linea = :li_co_linea ) AND  
         ( dt_modelos.co_referencia = :ll_co_referencia ) AND  
           
         ( dt_modelos.co_calidad = 1 ) AND  
         ( dt_modelos.co_color_pt = :ll_co_color_pt )   
         )   
	ORDER BY dt_modelos.raya ASC  ;
	
	OPEN cur_rayas;	
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","Error al abrir cursor rayas")
		return
	ELSE
	END IF
	
	FETCH cur_rayas
		INTO	:ll_co_modelo,   
				:ls_de_modelo,   
				:li_raya,   
				:ll_co_reftel,   
				:li_co_caract,   
				:li_diametro,   
				:ll_co_color_te;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","Error al traer cursor rayas")
		return
	ELSE
	END IF
		
	DO WHILE SQLCA.SQLCODE=0
		
		//buscar en dt_telaxmodelo_lib
		SELECT UNIQUE dt_telaxmodelo_lib.raya  
		 INTO :li_raya_liberada  
		 FROM dt_telaxmodelo_lib  
		WHERE ( dt_telaxmodelo_lib.co_fabrica_exp = :li_co_fabrica_exp ) AND  
				( dt_telaxmodelo_lib.pedido = :ll_pedido ) AND  
				( dt_telaxmodelo_lib.cs_liberacion = :li_cs_liberacion ) AND  
				( dt_telaxmodelo_lib.nu_orden = :ls_nu_orden ) AND  
				( dt_telaxmodelo_lib.co_fabrica_pt = :li_co_fabrica ) AND  
				( dt_telaxmodelo_lib.co_linea = :li_co_linea ) AND  
				( dt_telaxmodelo_lib.co_referencia = :ll_co_referencia ) AND  
				( dt_telaxmodelo_lib.co_color_pt = :ll_co_color_pt ) AND  
				( dt_telaxmodelo_lib.tono = :ls_tono ) AND  
				( dt_telaxmodelo_lib.cs_estilocolortono = :li_cs_estilocolortono ) AND  
				( dt_telaxmodelo_lib.co_modelo = :ll_co_modelo ) AND  
				( dt_telaxmodelo_lib.co_reftel = :ll_co_reftel ) AND  
				( dt_telaxmodelo_lib.co_caract = :li_co_caract ) AND  
				( dt_telaxmodelo_lib.diametro = :li_diametro ) AND  
				( dt_telaxmodelo_lib.co_color_tela = :ll_co_color_te ) AND  
				( dt_telaxmodelo_lib.raya = :li_raya )   ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","Error al traer cursor rayas")
			return			
		ELSE
			IF SQLCA.SQLCODE=100 THEN
				
				
//				SELECT DISTINCT h_descuentos_telas.ancho_cortable,   
//						dt_lib_prel_estilo.co_fabrica,
//						dt_lib_prel_estilo.yield,  
//						dt_lib_prel_estilo.ca_resulta,
//						(dt_lib_prel_estilo.yield*dt_lib_prel_estilo.ca_resulta) ca_tela  
//				 INTO :ld_ancho_cortable,   
//						:li_co_fabrica_tela,
//						:ld_yield,
//						:ll_ca_unidades,
//						:ld_ca_tela
//				 FROM h_liberar_escalas,   
//						h_descuentos_telas,   
//						dt_lib_prel_estilo  
//				WHERE ( h_descuentos_telas.co_fabrica_exp = h_liberar_escalas.co_fabrica_exp ) and  
//						( h_descuentos_telas.pedido = h_liberar_escalas.pedido ) and  
//						( h_descuentos_telas.cs_liberacion = h_liberar_escalas.cs_liberacion ) and  
//						( h_descuentos_telas.co_fabrica_exp = dt_lib_prel_estilo.co_fabrica_exp ) and  
//						( h_descuentos_telas.pedido = dt_lib_prel_estilo.pedido ) and  
//						( h_liberar_escalas.cs_lib_preliminar = dt_lib_prel_estilo.cs_lib_preliminar ) and  
//						( h_descuentos_telas.co_fabrica_tela = dt_lib_prel_estilo.co_fabrica ) and  
//						( h_descuentos_telas.co_reftel = dt_lib_prel_estilo.co_reftel ) and  
//						( dt_lib_prel_estilo.co_caract = h_descuentos_telas.co_caract ) and  
//						( h_descuentos_telas.diametro = dt_lib_prel_estilo.diametro ) and  
//						( dt_lib_prel_estilo.co_color = h_descuentos_telas.co_color_tela ) and  
//						( ( h_liberar_escalas.co_fabrica_exp = :li_co_fabrica_exp ) AND  
//						( h_liberar_escalas.pedido = :ll_pedido ) AND  
//						( h_liberar_escalas.cs_liberacion = :li_cs_liberacion ) AND  
//						( h_descuentos_telas.co_reftel = :ll_co_reftel ) AND  
//						( h_descuentos_telas.co_caract = :li_co_caract ) AND  
//						( h_descuentos_telas.diametro = :li_diametro ) AND  
//						( h_descuentos_telas.co_color_tela = :ll_co_color_te ) AND  
//						( dt_lib_prel_estilo.co_fabrica_pt = :li_co_fabrica ) AND  
//						( dt_lib_prel_estilo.co_linea = :li_co_linea ) AND  
//						( dt_lib_prel_estilo.co_referencia = :ll_co_referencia ) AND  
//						( dt_lib_prel_estilo.nu_orden = :ls_nu_orden ) AND  
//						( dt_lib_prel_estilo.co_color_pt = :ll_co_color_pt ) )   ;
//				IF SQLCA.SQLCODE=-1 THEN
//					IF SQLCA.SQLERRTEXT="Select returned more than one row" THEN
//					ELSE
//						MessageBox("Error Base Datos","Error al buscar datos de telas")
//						return
//					END IF
//				ELSE
//					IF SQLCA.SQLCODE=100 THEN
//					ELSE
//						INSERT INTO dt_telaxmodelo_lib  
//						( co_fabrica_exp,   
//						  pedido,   
//						  cs_liberacion,   
//						  nu_orden,   
//						  nu_cut,   
//						  co_fabrica_pt,   
//						  co_linea,   
//						  co_referencia,   
//						  co_color_pt,   
//						  tono,   
//						  cs_estilocolortono,   
//						  co_modelo,   
//						  co_fabrica_tela,   
//						  co_reftel,   
//						  co_caract,   
//						  diametro,   
//						  co_color_tela,   
//						  ancho_cortable,   
//						  tono_tela,   
//						  raya,   
//						  ca_unidades,   
//						  yield,   
//						  ca_tela,   
//						  fe_creacion,   
//						  fe_actualizacion,   
//						  usuario,   
//						  instancia,   
//						  ca_numerada,   
//						  cs_origen,   
//						  tela_dev )  
//			  VALUES ( :li_co_fabrica_exp,   
//						  :ll_pedido,   
//						  :li_cs_liberacion,   
//						  :ls_nu_orden,   
//						  13,   
//						  :li_co_fabrica,   
//						  :li_co_linea,   
//						  :ll_co_referencia,   
//						  :ll_co_color_pt,   
//						  :ls_tono,   
//						  :li_cs_estilocolortono,   
//						  :ll_co_modelo,   
//						  :li_co_fabrica_tela,   
//						  :ll_co_reftel,   
//						  :li_co_caract,   
//						  :li_diametro,   
//						  :ll_co_color_te,   
//						  :ld_ancho_cortable,   
//						  'I',   
//						  :li_raya,   
//						  :ll_ca_unidades,   
//						  :ld_yield,   
//						  :ld_ca_tela,   
//						  current,   
//						  current,   
//						  user,   
//						  sitename,   
//						  0,   
//						  null,   
//						  null)   ;
//		
//						IF SQLCA.SQLCODE=-1 THEN
//							IF SQLCA.SQLDBCODE=-268 THEN
//							ELSE
//								IF SQLCA.SQLDBCODE=-691 THEN
//								ELSE
//									MessageBox("Error Base Datos","Error al INSERT proceso")
//									return
//								END IF
//							END IF
//						ELSE
//						END IF
//						
//					END IF
//				END IF
				//INSERTAR EN TABLA TEMPORAL
				 INSERT INTO t_falta_raya_lib  
				( co_fabrica_exp,   
				  pedido,   
				  grupo,   
				  cs_liberacion,   
				  cs_ordenpd_pt,   
				     
				  raya,   
				  co_modelo,   
				  co_reftel,   
				  co_caract,   
				  diametro,   
				  co_color_te )  
	  VALUES ( :li_co_fabrica_exp,   
				  :ll_pedido,   
				  :ls_gpa,   
				  :li_cs_liberacion,   
				  :ll_cs_ordenpd_pt,   
				    
				  :li_raya,   
				  :ll_co_modelo,   
				  :ll_co_reftel,   
				  :li_co_caract,   
				  :li_diametro,   
				  :ll_co_color_te )  ;
				IF SQLCA.SQLCODE=-1 THEN
					IF SQLCA.SQLDBCODE=-268 THEN
						
					ELSE
						MessageBox("Error Base Datos","Error al insertar")
						return
					END IF
				ELSE
				END IF
			ELSE
				//no fu$$HEX2$$e9002000$$ENDHEX$$error, continue
			END IF
		END IF
		
		
		FETCH cur_rayas
		INTO	:ll_co_modelo,   
				:ls_de_modelo,   
				:li_raya,   
				:ll_co_reftel,   
				:li_co_caract,   
				:li_diametro,   
				:ll_co_color_te;

		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","Error al traer cursor rayas")
			return
		ELSE
		END IF
		
	LOOP
	
	CLOSE cur_rayas;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","Error al cerrar cursor rayas")
		return
	ELSE
	END IF

	FETCH cur_liberaciones
		INTO 	:li_co_fabrica_exp,   
				:ll_pedido, 
				:ls_gpa,  
				:li_cs_liberacion,   
				:ls_nu_orden,   
				:li_co_fabrica,   
				:li_co_linea,   
				:ll_co_referencia,   
				:ll_co_color_pt,   
				:ls_tono,   
				:li_cs_estilocolortono,   
				:ll_cs_ordenpd_pt,   
				
				:ldt_fe_creacion;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","Error al traer cursor rayas")
					return
	ELSE
	END IF
	
LOOP




CLOSE cur_liberaciones;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","Error al CERRAR cursor liberacione")
	return
ELSE
END IF

COMMIT;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","Error al asentar proceso")
	return
ELSE
END IF
DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

type st_1 from w_base_buscar_interactivo`st_1 within w_identificar_faltantes_rayas_en_liberac
string text = "Grupo"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_identificar_faltantes_rayas_en_liberac
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_identificar_faltantes_rayas_en_liberac
end type

