HA$PBExportHeader$w_copiar_simulaciones.srw
forward
global type w_copiar_simulaciones from w_base_buscar_interactivo
end type
type st_2 from statictext within w_copiar_simulaciones
end type
type em_simulacion_destino from editmask within w_copiar_simulaciones
end type
type em_empleados_modulo from editmask within w_copiar_simulaciones
end type
type st_3 from statictext within w_copiar_simulaciones
end type
type em_minutos_jornada from editmask within w_copiar_simulaciones
end type
type st_4 from statictext within w_copiar_simulaciones
end type
type em_fabrica from editmask within w_copiar_simulaciones
end type
type st_5 from statictext within w_copiar_simulaciones
end type
type em_planta from editmask within w_copiar_simulaciones
end type
type st_6 from statictext within w_copiar_simulaciones
end type
type em_modulo from editmask within w_copiar_simulaciones
end type
type st_7 from statictext within w_copiar_simulaciones
end type
type cbx_1 from checkbox within w_copiar_simulaciones
end type
type gb_2 from groupbox within w_copiar_simulaciones
end type
end forward

global type w_copiar_simulaciones from w_base_buscar_interactivo
integer width = 1454
integer height = 1088
string title = "Copiar Simulaciones"
st_2 st_2
em_simulacion_destino em_simulacion_destino
em_empleados_modulo em_empleados_modulo
st_3 st_3
em_minutos_jornada em_minutos_jornada
st_4 st_4
em_fabrica em_fabrica
st_5 st_5
em_planta em_planta
st_6 st_6
em_modulo em_modulo
st_7 st_7
cbx_1 cbx_1
gb_2 gb_2
end type
global w_copiar_simulaciones w_copiar_simulaciones

on w_copiar_simulaciones.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_simulacion_destino=create em_simulacion_destino
this.em_empleados_modulo=create em_empleados_modulo
this.st_3=create st_3
this.em_minutos_jornada=create em_minutos_jornada
this.st_4=create st_4
this.em_fabrica=create em_fabrica
this.st_5=create st_5
this.em_planta=create em_planta
this.st_6=create st_6
this.em_modulo=create em_modulo
this.st_7=create st_7
this.cbx_1=create cbx_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_simulacion_destino
this.Control[iCurrent+3]=this.em_empleados_modulo
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.em_minutos_jornada
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.em_fabrica
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.em_planta
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.em_modulo
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.cbx_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_copiar_simulaciones.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_simulacion_destino)
destroy(this.em_empleados_modulo)
destroy(this.st_3)
destroy(this.em_minutos_jornada)
destroy(this.st_4)
destroy(this.em_fabrica)
destroy(this.st_5)
destroy(this.em_planta)
destroy(this.st_6)
destroy(this.em_modulo)
destroy(this.st_7)
destroy(this.cbx_1)
destroy(this.gb_2)
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_copiar_simulaciones
integer x = 768
integer y = 820
integer taborder = 100
string text = "&Salir"
end type

event pb_cancelar::clicked;
Close(Parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_copiar_simulaciones
integer x = 302
integer y = 820
integer taborder = 80
string text = "&Copiar"
end type

event pb_buscar::clicked;LONG			ll_pedido,ll_cs_liberacion,ll_co_referencia,ll_co_color_pt,ll_ca_programada,ll_ca_producida
LONG			ll_ca_pendiente,ll_ca_unid_base_dia,ll_unidades_empate,ll_ca_base_dia_prod,ll_ca_base_dia_prog
LONG			ll_ca_a_programar,ll_pedido_po
LONG			ll_talla_ca_programada,ll_talla_ca_producida,ll_talla_ca_pendiente,ll_ca_unid_dispon_ini
LONG			ll_ca_unid_dispon_fin,ll_personasxmodulo,ll_ca_unid_posibles,ll_duracion,ll_programa_ca_programada
LONG			ll_programa_ca_producida,ll_programa_ca_pendiente

Long		li_co_fabrica,li_co_planta,li_co_modulo,li_co_fabrica_exp,li_co_fabrica_pt,li_co_linea
Long		li_cs_estilocolortono,li_cs_particion,li_cs_prioridad,li_co_estado_asigna,li_co_curva
Long		li_co_tipo_asignacion,li_ca_personasxmod,li_cod_tur,li_ind_cambio_estilo,li_origen_uni_base_dia
Long		li_tipo_empate,li_metodo_programa,li_tipo_fe_prog,li_indicativo_base,li_fuente_dato
Long		li_co_talla,li_cs_orden_talla,li_talla_cs_prioridad
Long		li_co_est_prog_talla,li_cs_fechas,li_co_est_prog_dia, li_registros

DECIMAL		ldc_ca_minutos_std,ldc_minutos_jornada,ldc_ca_min_dispon_ini,ldc_ca_min_dispon_fin,ldc_porc_eficiencia

DATETIME		ldt_fe_inicio_prog,ldt_fe_fin_prog, ldt_fe_requerida_desp,ldt_fe_entra_pdn,ldt_fe_lim_prog
DATETIME		ldt_fe_desp_programada,ldt_fe_creacion,ldt_fe_actualizacion,ldt_fechahora,ldt_fe_inicio
DATETIME		ldt_fe_fin 

STRING		ls_po,ls_tono
// Parametros de Proceso
Long		li_simulacion_origen,li_simulacion_destino, li_fabrica, li_planta, li_modulo, li_empleados
DECIMAL		ld_minutos_jornada

s_base_parametros lstr_parametro
// ----
// Traer par$$HEX1$$e100$$ENDHEX$$metros
// ----
li_simulacion_origen		=Long(sle_parametro1.TEXT)
li_fabrica 					=Long(em_fabrica.TEXT)
li_planta					=Long(em_planta.TEXT)
li_modulo 					=Long(em_modulo.TEXT)
li_simulacion_destino	=Long(em_simulacion_destino.TEXT)
li_empleados				=Long(em_empleados_modulo.TEXT)
ld_minutos_jornada	 	=REAL(em_minutos_jornada.TEXT)

// ----
// valida consistencia de Parametros
// ----
IF li_simulacion_origen = li_simulacion_destino  THEN
	MessageBox("Error Parametros","Las simulaciones son las mismas")
	RETURN
END IF

IF (li_modulo > 0 AND (li_fabrica = 0 OR li_planta = 0)) OR &
	(li_modulo = 0 AND li_planta > 0 AND li_fabrica = 0 ) THEN
	MessageBox("Error Parametros","Hay inconsistencia en los Parametros Fabrica/Planta/Modulo ")
	RETURN
END IF

// ---- Valida Fabrica / Planta / Modulo
IF li_fabrica > 0 THEN
	SELECT count(*) 
	INTO :li_registros
	FROM m_modulos 
	WHERE (m_modulos.co_fabrica = :li_fabrica);
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Parametros","No Hay Datos para Fabrica Dada")
		RETURN
	END IF
END IF

IF li_planta > 0 THEN
	SELECT count(*) 
	INTO :li_registros
	FROM m_modulos 
	WHERE (m_modulos.co_fabrica = :li_fabrica) AND
			(m_modulos.co_planta 	= :li_planta);
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Parametros","No Hay Datos para Fabrica/Planta Dados")
		RETURN
	END IF
END IF

IF li_modulo > 0 THEN
	SELECT count(*) 
	INTO :li_registros
	FROM m_modulos 
	WHERE (m_modulos.co_fabrica = :li_fabrica) AND
			(m_modulos.co_planta	 = :li_planta) AND
			(m_modulos.co_modulo	 = :li_modulo);
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Parametros","No Hay Datos para Fabrica/Planta/Modulo Dados")
		RETURN
	END IF
END IF

// ---- Pantalla informativa
lstr_parametro.cadena[1]="Copiando Simulaci$$HEX1$$f300$$ENDHEX$$n..."
Lstr_parametro.cadena[2]="El sistema esta copiando la simulaci$$HEX1$$f300$$ENDHEX$$n, esta operacion puede demorar unos segundos, espere un momento por favor..."
lstr_parametro.cadena[3]="reloj"
	
OpenWithParm(w_retroalimentacion,lstr_parametro)

// Borra los posibles registros de la Simulacion Destino
// ----
// Borra Programacion Diaria
// ----
DELETE FROM dt_programa_diario  
		// Un Modulo Especifico
WHERE (( dt_programa_diario.simulacion 			=:li_simulacion_destino ) AND  
		( dt_programa_diario.co_fabrica 				=:li_fabrica  ) AND  
		( dt_programa_diario.co_planta 				=:li_planta  ) AND  
		( dt_programa_diario.co_modulo 				=:li_modulo ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	> 0 )) OR  
		// Una Planta Especifica
		(( dt_programa_diario.simulacion 			=:li_simulacion_destino ) AND  
		( dt_programa_diario.co_fabrica 				=:li_fabrica  ) AND  
		( dt_programa_diario.co_planta 				=:li_planta  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Fabrica Especifica
		(( dt_programa_diario.simulacion 			=:li_simulacion_destino ) AND  
		( dt_programa_diario.co_fabrica 				=:li_fabrica  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Simulacion Especifica
		(( dt_programa_diario.simulacion 			=:li_simulacion_destino ) AND  
		( :li_fabrica 	= 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 ));
	IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base datos","No pudo borrar programacion diaria Destino")
			RETURN(1)
	ELSE
	END IF
// ----
// Borra Escalas
// ----
DELETE FROM dt_talla_pdnmodulo  
		// Un Modulo Especifico
WHERE (( dt_talla_pdnmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( dt_talla_pdnmodulo.co_fabrica 				=:li_fabrica  ) AND  
		( dt_talla_pdnmodulo.co_planta 				=:li_planta  ) AND  
		( dt_talla_pdnmodulo.co_modulo 				=:li_modulo ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	> 0 )) OR  
		// Una Planta Especifica
		(( dt_talla_pdnmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( dt_talla_pdnmodulo.co_fabrica 				=:li_fabrica  ) AND  
		( dt_talla_pdnmodulo.co_planta 				=:li_planta  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Fabrica Especifica
		(( dt_talla_pdnmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( dt_talla_pdnmodulo.co_fabrica 				=:li_fabrica  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Simulacion Especifica
		(( dt_talla_pdnmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( :li_fabrica 	= 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 ));
	IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base datos","No pudo borrar Escalas Programacion Destino")
			RETURN(1)
	ELSE
	END IF
// ----
// Borra Parametros
// ----
DELETE FROM dt_pdnxmodulo  
		// Un Modulo Especifico
WHERE (( dt_pdnxmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( dt_pdnxmodulo.co_fabrica 			=:li_fabrica  ) AND  
		( dt_pdnxmodulo.co_planta 				=:li_planta  ) AND  
		( dt_pdnxmodulo.co_modulo 				=:li_modulo ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	> 0 )) OR  
		// Una Planta Especifica
		(( dt_pdnxmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( dt_pdnxmodulo.co_fabrica 			=:li_fabrica  ) AND  
		( dt_pdnxmodulo.co_planta 				=:li_planta  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Fabrica Especifica
		(( dt_pdnxmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( dt_pdnxmodulo.co_fabrica 			=:li_fabrica  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Simulacion Especifica
		(( dt_pdnxmodulo.simulacion 			=:li_simulacion_destino ) AND  
		( :li_fabrica 	= 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 ));
	IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base datos","No pudo borrar Parametros Programacion Destino")
			RETURN(1)
	ELSE
	END IF
		
// ----
// copiar dt_pdnxmodulo
// ----
DECLARE cur_pdnxmod CURSOR FOR
  SELECT    
         dt_pdnxmodulo.co_fabrica,   
         dt_pdnxmodulo.co_planta,   
         dt_pdnxmodulo.co_modulo,   
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
         dt_pdnxmodulo.cs_particion,   
         dt_pdnxmodulo.pedido_po,   
         dt_pdnxmodulo.cs_prioridad,   
         dt_pdnxmodulo.ca_programada,   
         dt_pdnxmodulo.ca_producida,   
         dt_pdnxmodulo.ca_pendiente,   
         dt_pdnxmodulo.co_estado_asigna,   
         dt_pdnxmodulo.co_curva,   
         dt_pdnxmodulo.fe_inicio_prog,   
         dt_pdnxmodulo.fe_fin_prog,   
         dt_pdnxmodulo.fe_requerida_desp,   
         dt_pdnxmodulo.ca_minutos_std,   
         dt_pdnxmodulo.co_tipo_asignacion,   
         dt_pdnxmodulo.ca_personasxmod,   
         dt_pdnxmodulo.cod_tur,   
         dt_pdnxmodulo.minutos_jornada,   
         dt_pdnxmodulo.ind_cambio_estilo,   
         dt_pdnxmodulo.ca_unid_base_dia,   
         dt_pdnxmodulo.orige_uni_base_dia,   
         dt_pdnxmodulo.tipo_empate,   
         dt_pdnxmodulo.unidades_empate,   
         dt_pdnxmodulo.metodo_programa,   
         dt_pdnxmodulo.fe_entra_pdn,   
         dt_pdnxmodulo.tipo_fe_prog,   
         dt_pdnxmodulo.fe_lim_prog,   
         dt_pdnxmodulo.fe_desp_programada,   
         dt_pdnxmodulo.indicativo_base,   
         dt_pdnxmodulo.ca_base_dia_prod,   
         dt_pdnxmodulo.ca_base_dia_prog,   
         dt_pdnxmodulo.ca_a_programar  
    FROM dt_pdnxmodulo  
		// Un Modulo Especifico
WHERE (( dt_pdnxmodulo.simulacion 			=:li_simulacion_origen ) AND  
		( dt_pdnxmodulo.co_fabrica 			=:li_fabrica  ) AND  
		( dt_pdnxmodulo.co_planta 				=:li_planta  ) AND  
		( dt_pdnxmodulo.co_modulo 				=:li_modulo ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	> 0 )) OR  
		// Una Planta Especifica
		(( dt_pdnxmodulo.simulacion 			=:li_simulacion_origen ) AND  
		( dt_pdnxmodulo.co_fabrica 			=:li_fabrica  ) AND  
		( dt_pdnxmodulo.co_planta 				=:li_planta  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	> 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Fabrica Especifica
		(( dt_pdnxmodulo.simulacion 			=:li_simulacion_origen ) AND  
		( dt_pdnxmodulo.co_fabrica 			=:li_fabrica  ) AND  
		( :li_fabrica 	> 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 )) OR  
		// Una Simulacion Especifica
		(( dt_pdnxmodulo.simulacion 			=:li_simulacion_origen ) AND  
		( :li_fabrica 	= 0 ) AND  
		( :li_planta 	= 0 ) AND  
		( :li_modulo 	= 0 ));
IF SQLCA.SQLCODE=-1 THEN
	Close(w_retroalimentacion)
	MessageBox("Error Base Datos","No pudo declarar el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos generales de 102")
	RETURN
ELSE
END IF
	
OPEN cur_pdnxmod;
IF SQLCA.SQLCODE=-1 THEN
	Close(w_retroalimentacion)
	MessageBox("Error Base Datos","No pudo abrir el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos generales de 102")
	RETURN
ELSE
END IF

FETCH cur_pdnxmod 
	INTO
			:li_co_fabrica,   
         :li_co_planta,   
         :li_co_modulo,   
         :li_co_fabrica_exp,   
         :ll_pedido,   
         :ll_cs_liberacion,   
         :ls_po,   
         :li_co_fabrica_pt,   
         :li_co_linea,   
         :ll_co_referencia,   
         :ll_co_color_pt,   
         :ls_tono,   
         :li_cs_estilocolortono,   
         :li_cs_particion,   
         :ll_pedido_po,   
         :li_cs_prioridad,   
         :ll_ca_programada,   
         :ll_ca_producida,   
         :ll_ca_pendiente,   
         :li_co_estado_asigna,   
         :li_co_curva,   
         :ldt_fe_inicio_prog,   
         :ldt_fe_fin_prog,   
         :ldt_fe_requerida_desp,   
         :ldc_ca_minutos_std,   
         :li_co_tipo_asignacion,   
         :li_ca_personasxmod,   
         :li_cod_tur,   
         :ldc_minutos_jornada,   
         :li_ind_cambio_estilo,   
         :ll_ca_unid_base_dia,   
         :li_origen_uni_base_dia,   
         :li_tipo_empate,   
         :ll_unidades_empate,   
         :li_metodo_programa,   
         :ldt_fe_entra_pdn,   
         :li_tipo_fe_prog,   
         :ldt_fe_lim_prog,   
         :ldt_fe_desp_programada,   
         :li_indicativo_base,   
         :ll_ca_base_dia_prod,   
         :ll_ca_base_dia_prog,   
         :ll_ca_a_programar ; 
IF SQLCA.SQLCODE=-1 THEN
	Close(w_retroalimentacion)
	MessageBox("Error Base Datos","No pudo traer datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos generales de 102")
	RETURN
ELSE
END IF

// ---- Ciclo Parametros ---- //
DO WHILE SQLCA.SQLCODE=0
	
	li_fuente_dato=3 		//copia de simulaci$$HEX1$$f300$$ENDHEX$$n
	ldt_fechahora 			= f_fecha_servidor()
		
   
	ldt_fe_creacion		=  ldt_fechahora 
	ldt_fe_actualizacion	=  ldt_fechahora
	
	// Verifica si se desea cambiar los minutos de la jorada o los empleados por modulo
	IF ld_minutos_jornada > 0 THEN
         ldc_minutos_jornada=ld_minutos_jornada   
	END IF

	IF li_empleados > 0 THEN
         li_ca_personasxmod=li_empleados   
	END IF
	
	IF li_co_planta = 2 THEN
		// Calcula Base Diaria
		ll_ca_base_dia_prod = (ldc_minutos_jornada / ldc_ca_minutos_std) * li_ca_personasxmod
	END IF
		
	//insert into dt_pdnxmodulo
	INSERT INTO dt_pdnxmodulo 
	  		  
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
           pedido_po,   
           cs_prioridad,   
           ca_programada,   
           ca_producida,   
           ca_pendiente,   
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
           fuente_dato,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia,   
           fe_entra_pdn,   
           tipo_fe_prog,   
           fe_lim_prog,   
           fe_desp_programada,   
           indicativo_base,   
           ca_base_dia_prod,   
           ca_base_dia_prog,   
           ca_a_programar )  
  VALUES ( :li_simulacion_destino,   
           :li_co_fabrica,   
           :li_co_planta,   
           :li_co_modulo,   
           :li_co_fabrica_exp,   
           :ll_pedido,   
           :ll_cs_liberacion,   
           :ls_po,   
           :li_co_fabrica_pt,   
           :li_co_linea,   
           :ll_co_referencia,   
           :ll_co_color_pt,   
           :ls_tono,   
           :li_cs_estilocolortono,   
           :li_cs_particion,   
           :ll_pedido_po,   
           :li_cs_prioridad,   
           :ll_ca_programada,   
           :ll_ca_producida,   
           :ll_ca_pendiente,   
           :li_co_estado_asigna,   
           :li_co_curva,   
           :ldt_fe_inicio_prog,   
           :ldt_fe_fin_prog,   
           :ldt_fe_requerida_desp,   
           :ldc_ca_minutos_std,   
           :li_co_tipo_asignacion,   
           :li_ca_personasxmod,   
           :li_cod_tur,   
           :ldc_minutos_jornada,   
           :li_ind_cambio_estilo,   
           :ll_ca_unid_base_dia,   
           :li_origen_uni_base_dia,   
           :li_tipo_empate,   
           :ll_unidades_empate,   
           :li_metodo_programa,   
           :li_fuente_dato,   
           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia,   
           :ldt_fe_entra_pdn,   
           :li_tipo_fe_prog,   
           :ldt_fe_lim_prog,   
           :ldt_fe_desp_programada,   
           :li_indicativo_base,   
           :ll_ca_base_dia_prod,   
           :ll_ca_base_dia_prog,   
           :ll_ca_a_programar )  ;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo insertar en dt_pdnxmodulo")
		RETURN
	ELSE
	END IF
			  
   //copiar dt_talla_pdnmodulo
	DECLARE cur_tallas CURSOR FOR  
  SELECT dt_talla_pdnmodulo.co_talla,   
         dt_talla_pdnmodulo.cs_orden_talla,   
         dt_talla_pdnmodulo.cs_prioridad,   
         dt_talla_pdnmodulo.ca_programada,   
         dt_talla_pdnmodulo.ca_producida,   
         dt_talla_pdnmodulo.ca_pendiente,   
         dt_talla_pdnmodulo.co_est_prog_talla   
    FROM dt_talla_pdnmodulo  
   WHERE ( dt_talla_pdnmodulo.simulacion 				=:li_simulacion_origen  ) AND  
         ( dt_talla_pdnmodulo.co_fabrica 				=:li_co_fabrica  ) AND  
         ( dt_talla_pdnmodulo.co_planta 				=:li_co_planta  ) AND  
         ( dt_talla_pdnmodulo.co_modulo 				=:li_co_modulo  ) AND  
         ( dt_talla_pdnmodulo.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
         ( dt_talla_pdnmodulo.pedido 					=:ll_pedido  ) AND  
         ( dt_talla_pdnmodulo.cs_liberacion 			=:ll_cs_liberacion  ) AND  
         ( dt_talla_pdnmodulo.po 						=:ls_po  ) AND  
         ( dt_talla_pdnmodulo.co_fabrica_pt 			=:li_co_fabrica_pt  ) AND  
         ( dt_talla_pdnmodulo.co_linea 				=:li_co_linea  ) AND  
         ( dt_talla_pdnmodulo.co_referencia 			=:ll_co_referencia  ) AND  
         ( dt_talla_pdnmodulo.co_color_pt 			=:ll_co_color_pt  ) AND  
         ( dt_talla_pdnmodulo.tono 						=:ls_tono  ) AND  
         ( dt_talla_pdnmodulo.cs_estilocolortono 	=:li_cs_estilocolortono  ) AND  
         ( dt_talla_pdnmodulo.cs_particion 			=:li_cs_particion  );
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo declarar el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos por talla de 102")
		RETURN
	ELSE
	END IF
			
	OPEN cur_tallas;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo abrir el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos por talla de 102")
		RETURN
	ELSE
	END IF
	
	FETCH cur_tallas
		INTO  :li_co_talla,   
         	:li_cs_orden_talla,   
				:li_talla_cs_prioridad,   
				:ll_talla_ca_programada,   
				:ll_talla_ca_producida,   
				:ll_talla_ca_pendiente,   
				:li_co_est_prog_talla;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo traer datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos por talla de 102")
		RETURN
	ELSE
	END IF
				
	// ---- Ciclo Tallas ---- //
	DO WHILE SQLCA.SQLCODE=0
		
		li_fuente_dato=3   
		ldt_fechahora 			= f_fecha_servidor()
		
		ldt_fe_creacion		=  ldt_fechahora 
		ldt_fe_actualizacion	=  ldt_fechahora
      
		INSERT INTO dt_talla_pdnmodulo  
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
           instancia )  
  VALUES ( :li_simulacion_destino,   
           :li_co_fabrica,   
           :li_co_planta,   
           :li_co_modulo,   
           :li_co_fabrica_exp,   
           :ll_pedido,   
           :ll_cs_liberacion,   
           :ls_po,   
           :li_co_fabrica_pt,   
           :li_co_linea,   
           :ll_co_referencia,   
           :ll_co_color_pt,   
           :ls_tono,   
           :li_cs_estilocolortono,   
           :li_cs_particion,   
           :li_co_talla,   
           :li_cs_orden_talla,   
           :li_cs_prioridad,   
           :ll_talla_ca_programada,   
           :ll_talla_ca_producida,   
           :ll_talla_ca_pendiente,   
           :li_co_est_prog_talla,   
           :li_fuente_dato,   
           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia )  ;
		IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base Datos","No pudo insertar datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de tallas de 102")
			RETURN
		ELSE
		END IF

		
		FETCH cur_tallas
		INTO  :li_co_talla,   
         	:li_cs_orden_talla,   
				:li_talla_cs_prioridad,   
				:ll_talla_ca_programada,   
				:ll_talla_ca_producida,   
				:ll_talla_ca_pendiente,   
				:li_co_est_prog_talla;
		IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base Datos","No pudo traer datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos por talla de 102")
			RETURN
		ELSE
		END IF
				
	LOOP 	// ---- Ciclo Tallas ---- // 
	CLOSE cur_tallas;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo cerrar el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos por talla de 102")
		RETURN
	ELSE
	END IF

	//copiar dt_programa_diario
	DECLARE cur_programa CURSOR FOR  
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
         dt_programa_diario.co_est_prog_dia
    FROM dt_programa_diario  
   WHERE ( dt_programa_diario.simulacion 				=:li_simulacion_origen  ) AND  
         ( dt_programa_diario.co_fabrica 				=:li_co_fabrica  ) AND  
         ( dt_programa_diario.co_planta 				=:li_co_planta  ) AND  
         ( dt_programa_diario.co_modulo 				=:li_co_modulo  ) AND  
         ( dt_programa_diario.co_fabrica_exp 		=:li_co_fabrica_exp  ) AND  
         ( dt_programa_diario.pedido 					=:ll_pedido  ) AND  
         ( dt_programa_diario.cs_liberacion 			=:ll_cs_liberacion  ) AND  
         ( dt_programa_diario.po 						=:ls_po  ) AND  
         ( dt_programa_diario.co_fabrica_pt 			=:li_co_fabrica_pt  ) AND  
         ( dt_programa_diario.co_linea 				=:li_co_linea  ) AND  
         ( dt_programa_diario.co_referencia 			=:ll_co_referencia  ) AND  
         ( dt_programa_diario.co_color_pt 			=:ll_co_color_pt  ) AND  
         ( dt_programa_diario.tono 						=:ls_tono  ) AND  
         ( dt_programa_diario.cs_estilocolortono 	=:li_cs_estilocolortono  ) AND  
         ( dt_programa_diario.cs_particion 			=:li_cs_particion  )   ;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo declarar el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de par$$HEX1$$e100$$ENDHEX$$metros de 102")
		RETURN
	ELSE
	END IF
			
	OPEN cur_programa;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo abrir el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de par$$HEX1$$e100$$ENDHEX$$metros de 102")
		RETURN
	ELSE
	END IF
	
	FETCH cur_programa 
		INTO 	:li_cs_fechas,   
				:ldt_fe_inicio,   
				:ll_ca_unid_dispon_ini,   
				:ldc_ca_min_dispon_ini,   
				:ll_ca_unid_dispon_fin,   
				:ldc_ca_min_dispon_fin,   
				:ll_personasxmodulo,   
				:ldc_porc_eficiencia,   
				:ll_ca_unid_posibles,   
				:ll_duracion,   
				:ldt_fe_fin,   
				:ll_programa_ca_programada,   
				:ll_programa_ca_producida,   
				:ll_programa_ca_pendiente,   
				:li_co_est_prog_dia;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo traer datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de par$$HEX1$$e100$$ENDHEX$$metros de 102")
		RETURN
	ELSE
	END IF
				
	// ---- Ciclo Programa Diario ---- //
	DO WHILE SQLCA.SQLCODE=0
		
		li_fuente_dato=3   
		ldt_fechahora 			= f_fecha_servidor()
		
		ldt_fe_creacion		=  ldt_fechahora 
		ldt_fe_actualizacion	=  ldt_fechahora
		
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
  VALUES ( :li_simulacion_destino,   
           :li_co_fabrica,   
           :li_co_planta,   
           :li_co_modulo,   
           :li_co_fabrica_exp,   
           :ll_pedido,   
           :ll_cs_liberacion,   
           :ls_po,   
           :li_co_fabrica_pt,   
           :li_co_linea,   
           :ll_co_referencia,   
           :ll_co_color_pt,   
           :ls_tono,   
           :li_cs_estilocolortono,   
           :li_cs_particion,   
           :li_cs_fechas,   
           :ldt_fe_inicio,   
           :ll_ca_unid_dispon_ini,   
           :ldc_ca_min_dispon_ini,   
           :ll_ca_unid_dispon_fin,   
           :ldc_ca_min_dispon_fin,   
           :ll_personasxmodulo,   
           :ldc_porc_eficiencia,   
           :ll_ca_unid_posibles,   
           :ll_duracion,   
           :ldt_fe_fin,   
           :ll_programa_ca_programada,   
           :ll_programa_ca_producida,   
           :ll_programa_ca_pendiente,   
           :li_co_est_prog_dia,   
           :li_fuente_dato,   
           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia )  ;
		IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base Datos","No pudo insertar datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de par$$HEX1$$e100$$ENDHEX$$metros de 102")
			RETURN
		ELSE
		END IF

		FETCH cur_programa 
		INTO 	:li_cs_fechas,   
				:ldt_fe_inicio,   
				:ll_ca_unid_dispon_ini,   
				:ldc_ca_min_dispon_ini,   
				:ll_ca_unid_dispon_fin,   
				:ldc_ca_min_dispon_fin,   
				:ll_personasxmodulo,   
				:ldc_porc_eficiencia,   
				:ll_ca_unid_posibles,   
				:ll_duracion,   
				:ldt_fe_fin,   
				:ll_programa_ca_programada,   
				:ll_programa_ca_producida,   
				:ll_programa_ca_pendiente,   
				:li_co_est_prog_dia;
		IF SQLCA.SQLCODE=-1 THEN
			Close(w_retroalimentacion)
			MessageBox("Error Base Datos","No pudo traer datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de par$$HEX1$$e100$$ENDHEX$$metros de 102")
			RETURN
		ELSE
		END IF
	LOOP // ---- Ciclo Programa Diario ---- //
	
	CLOSE cur_programa;
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo cerrar el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos de par$$HEX1$$e100$$ENDHEX$$metros de 102")
		RETURN
	ELSE
	END IF

	
	FETCH cur_pdnxmod 
	INTO
			:li_co_fabrica,   
         :li_co_planta,   
         :li_co_modulo,   
         :li_co_fabrica_exp,   
         :ll_pedido,   
         :ll_cs_liberacion,   
         :ls_po,   
         :li_co_fabrica_pt,   
         :li_co_linea,   
         :ll_co_referencia,   
         :ll_co_color_pt,   
         :ls_tono,   
         :li_cs_estilocolortono,   
         :li_cs_particion,   
         :ll_pedido_po,   
         :li_cs_prioridad,   
         :ll_ca_programada,   
         :ll_ca_producida,   
         :ll_ca_pendiente,   
         :li_co_estado_asigna,   
         :li_co_curva,   
         :ldt_fe_inicio_prog,   
         :ldt_fe_fin_prog,   
         :ldt_fe_requerida_desp,   
         :ldc_ca_minutos_std,   
         :li_co_tipo_asignacion,   
         :li_ca_personasxmod,   
         :li_cod_tur,   
         :ldc_minutos_jornada,   
         :li_ind_cambio_estilo,   
         :ll_ca_unid_base_dia,   
         :li_origen_uni_base_dia,   
         :li_tipo_empate,   
         :ll_unidades_empate,   
         :li_metodo_programa,   
         :ldt_fe_entra_pdn,   
         :li_tipo_fe_prog,   
         :ldt_fe_lim_prog,   
         :ldt_fe_desp_programada,   
         :li_indicativo_base,   
         :ll_ca_base_dia_prod,   
         :ll_ca_base_dia_prog,   
         :ll_ca_a_programar ; 
	IF SQLCA.SQLCODE=-1 THEN
		Close(w_retroalimentacion)
		MessageBox("Error Base Datos","No pudo traer datos en el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos generales de 102")
		RETURN
	ELSE
	END IF
	
LOOP // Ciclo Parametros Programacion ---- //

CLOSE cur_pdnxmod; 
IF SQLCA.SQLCODE=-1 THEN
	Close(w_retroalimentacion)
	MessageBox("Error Base Datos","No pudo cerrar el ciclo de b$$HEX1$$fa00$$ENDHEX$$squeda de los datos generales de 102")
	RETURN
ELSE
END IF

// ---- Actualiza ---- //
COMMIT;
IF SQLCA.SQLCODE=-1 THEN
	Close(w_retroalimentacion)
	MessageBox("Error Base Datos","No pudo Asentar la grabaci$$HEX1$$f300$$ENDHEX$$n de datos")
	RETURN
ELSE
END IF

Close(w_retroalimentacion)

MessageBox("Fin del proceso de copiar simulaci$$HEX1$$f300$$ENDHEX$$n","Termin$$HEX2$$f3002000$$ENDHEX$$el proceso")


end event

type st_1 from w_base_buscar_interactivo`st_1 within w_copiar_simulaciones
integer y = 64
integer width = 425
integer height = 72
string text = "Simulaci$$HEX1$$f300$$ENDHEX$$n Origen: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_copiar_simulaciones
integer x = 654
integer y = 56
integer width = 270
integer height = 72
integer taborder = 10
string text = "1"
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_copiar_simulaciones
integer x = 18
integer y = 12
integer width = 1381
integer height = 392
integer taborder = 0
end type

type st_2 from statictext within w_copiar_simulaciones
integer x = 133
integer y = 476
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Simulaci$$HEX1$$f300$$ENDHEX$$n Destino:"
boolean focusrectangle = false
end type

type em_simulacion_destino from editmask within w_copiar_simulaciones
integer x = 654
integer y = 468
integer width = 270
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_empleados_modulo from editmask within w_copiar_simulaciones
integer x = 654
integer y = 552
integer width = 270
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_3 from statictext within w_copiar_simulaciones
integer x = 133
integer y = 552
integer width = 448
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Empleados Modulo :"
boolean focusrectangle = false
end type

type em_minutos_jornada from editmask within w_copiar_simulaciones
integer x = 654
integer y = 632
integer width = 270
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_4 from statictext within w_copiar_simulaciones
integer x = 133
integer y = 632
integer width = 448
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Minutos Jornada :"
boolean focusrectangle = false
end type

type em_fabrica from editmask within w_copiar_simulaciones
integer x = 654
integer y = 140
integer width = 270
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_5 from statictext within w_copiar_simulaciones
integer x = 133
integer y = 144
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Fabrica Origen :"
boolean focusrectangle = false
end type

type em_planta from editmask within w_copiar_simulaciones
integer x = 654
integer y = 224
integer width = 270
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_6 from statictext within w_copiar_simulaciones
integer x = 133
integer y = 232
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Planta Origen :"
boolean focusrectangle = false
end type

type em_modulo from editmask within w_copiar_simulaciones
integer x = 654
integer y = 308
integer width = 270
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_7 from statictext within w_copiar_simulaciones
integer x = 133
integer y = 316
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Modulo Origen :"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_copiar_simulaciones
integer x = 960
integer y = 144
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar"
borderstyle borderstyle = stylelowered!
end type

event clicked;s_base_parametros lstr_parametros

// -----------------
// Lleva Fabrica, Planta, Modulo, unidades con valores iniciales 
// -----------------
lstr_parametros.entero[1]=91 
lstr_parametros.entero[2]=1
lstr_parametros.entero[3]=1
lstr_parametros.entero[4]=0
				
lstr_parametros.hay_parametros=TRUE
// --------------
// Llama Ventana para seleccion de Modulo Destino
// --------------
OpenWithParm(w_seleccionar_modulos,lstr_parametros)
lstr_parametros = Message.PowerObjectParm

IF lstr_parametros.hay_parametros THEN
	lstr_parametros.hay_parametros = TRUE
	// -----------------
	// Lleva Fabrica, Planta, Modulo Seleccionados a Campos de Trabajo
	// -----------------
	IF lstr_parametros.entero[5]=1 THEN
				em_fabrica.text =string(lstr_parametros.entero[1])
				em_planta.text	=string(lstr_parametros.entero[2])
				em_modulo.text	=string(lstr_parametros.entero[3])
	END IF
END IF
RETURN 1

end event

type gb_2 from groupbox within w_copiar_simulaciones
integer x = 18
integer y = 416
integer width = 1381
integer height = 344
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

