HA$PBExportHeader$w_actualizar_unidades_numeradasxescala.srw
forward
global type w_actualizar_unidades_numeradasxescala from w_base_buscar_interactivo
end type
type st_2 from statictext within w_actualizar_unidades_numeradasxescala
end type
type em_secuencia from editmask within w_actualizar_unidades_numeradasxescala
end type
end forward

global type w_actualizar_unidades_numeradasxescala from w_base_buscar_interactivo
integer height = 972
string title = "Liquidar Escala de Numeracion"
st_2 st_2
em_secuencia em_secuencia
end type
global w_actualizar_unidades_numeradasxescala w_actualizar_unidades_numeradasxescala

type variables
Long	ii_sec,ii_co_fabrica_exp,ii_cs_liberacion,ii_co_fabrica_pt,ii_co_linea
Long	ii_co_fabrica_modulo,ii_co_planta_modulo,ii_co_modulo,ii_cs_particion,ii_cs_prioridad
Long	ii_co_estado_asigna,ii_co_curva,ii_co_tipo_asignacion,ii_ca_personasxmod,ii_cod_tur
Long	ii_ind_cambio_estilo,ii_origen_uni_base_dia,ii_tipo_empate, ii_metodo_programa,ii_fuente_dato
Long	ii_tipo_fe_progq,ii_indicativo_empate

LONG		il_op,il_pedido,il_co_referencia,il_co_color_pt
LONG		il_ca_programada,il_ca_producida,il_ca_pendiente,il_ca_unid_base_dia,il_unidades_empate
LONG		il_ca_base_dia_prod,il_ca_base_dia_prog,il_ca_a_programar,il_ca_proyectada, il_ca_actual,il_ca_numerada  


DOUBLE	idec_ca_minutos_std, idec_minutos_jornada

STRING	is_nu_orden,is_tono,is_co_estado_merc

DATETIME	idt_fe_inicio_prog,idt_fe_fin_prog,idt_fe_requerida_desp,idt_fe_entra_pdn,idt_fe_lim_prog
DATETIME	idt_fe_desp_programada


end variables

forward prototypes
public function long wf_buscar_dt_pdnxmodulo ()
public function long wf_update_dt_pdnxmodulo ()
public function long wf_buscar_dt_libera_estilos ()
public function long wf_update_dt_talla_pdnmodulo ()
end prototypes

public function long wf_buscar_dt_pdnxmodulo ();Long li_correcto

li_correcto=1

SELECT dt_pdnxmodulo.co_fabrica,       	dt_pdnxmodulo.co_planta,         dt_pdnxmodulo.co_modulo,   
       dt_pdnxmodulo.cs_particion,        dt_pdnxmodulo.cs_prioridad,      dt_pdnxmodulo.ca_programada,   
       dt_pdnxmodulo.ca_producida,        dt_pdnxmodulo.ca_pendiente,      dt_pdnxmodulo.co_estado_asigna,   
       dt_pdnxmodulo.co_curva,         	dt_pdnxmodulo.fe_inicio_prog,    dt_pdnxmodulo.fe_fin_prog,   
       dt_pdnxmodulo.fe_requerida_desp,   dt_pdnxmodulo.ca_minutos_std,    dt_pdnxmodulo.co_tipo_asignacion,   
       dt_pdnxmodulo.ca_personasxmod,     dt_pdnxmodulo.cod_tur,          	dt_pdnxmodulo.minutos_jornada,   
       dt_pdnxmodulo.ind_cambio_estilo,   dt_pdnxmodulo.ca_unid_base_dia,  dt_pdnxmodulo.orige_uni_base_dia,   
       dt_pdnxmodulo.tipo_empate,         dt_pdnxmodulo.unidades_empate,   dt_pdnxmodulo.metodo_programa,   
       dt_pdnxmodulo.fuente_dato,         dt_pdnxmodulo.fe_entra_pdn,      dt_pdnxmodulo.tipo_fe_prog,   
       dt_pdnxmodulo.fe_lim_prog,         dt_pdnxmodulo.fe_desp_programada,dt_pdnxmodulo.indicativo_base,   
       dt_pdnxmodulo.ca_base_dia_prod,    dt_pdnxmodulo.ca_base_dia_prog,  dt_pdnxmodulo.ca_a_programar,   
       dt_pdnxmodulo.co_estado_merc,    	dt_pdnxmodulo.ca_proyectada,     dt_pdnxmodulo.ca_actual,   
       dt_pdnxmodulo.ca_numerada  
    INTO :ii_co_fabrica_modulo,           :ii_co_planta_modulo,            :ii_co_modulo,   
         :ii_cs_particion,            		:ii_cs_prioridad,            		:il_ca_programada,   
         :il_ca_producida,            		:il_ca_pendiente,            		:ii_co_estado_asigna,   
         :ii_co_curva,            			:idt_fe_inicio_prog,            	:idt_fe_fin_prog,   
         :idt_fe_requerida_desp,          :idec_ca_minutos_std,            :ii_co_tipo_asignacion,   
         :ii_ca_personasxmod,            	:ii_cod_tur,            			:idec_minutos_jornada,   
         :ii_ind_cambio_estilo,           :il_ca_unid_base_dia,            :ii_origen_uni_base_dia,   
         :ii_tipo_empate,            		:il_unidades_empate,            	:ii_metodo_programa,   
         :ii_fuente_dato,            		:idt_fe_entra_pdn,            	:ii_tipo_fe_progq,   
         :idt_fe_lim_prog,            		:idt_fe_desp_programada,         :ii_indicativo_empate,   
         :il_ca_base_dia_prod,            :il_ca_base_dia_prog,            :il_ca_a_programar,   
         :is_co_estado_merc,            	:il_ca_proyectada,            	:il_ca_actual,   
         :il_ca_numerada  
    FROM dt_pdnxmodulo  
   WHERE ( dt_pdnxmodulo.simulacion 			= 1 ) AND  
         ( dt_pdnxmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
         ( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
         ( dt_pdnxmodulo.cs_liberacion 		= :ii_cs_liberacion ) AND  
         ( dt_pdnxmodulo.po 						= :is_nu_orden ) AND  
         ( dt_pdnxmodulo.co_fabrica_pt 		= :ii_co_fabrica_pt ) AND  
         ( dt_pdnxmodulo.co_linea 				= :ii_co_linea ) AND  
         ( dt_pdnxmodulo.co_referencia 		= :il_co_referencia ) AND  
         ( dt_pdnxmodulo.co_color_pt 			= :il_co_color_pt ) AND  
         ( dt_pdnxmodulo.tono 					= :is_tono ) AND  
         ( dt_pdnxmodulo.cs_estilocolortono 	= :ii_sec )   ;
			
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base Datos","No pudo buscar datos de dt_pdnxmodulo")
	li_correcto=0
ELSE
END IF

RETURN li_correcto

end function

public function long wf_update_dt_pdnxmodulo ();Long	li_correcto

li_correcto=1

UPDATE dt_pdnxmodulo  
  SET ca_programada 	= ca_numerada,   
		ca_pendiente 	= ca_numerada - ca_producida  
WHERE ( dt_pdnxmodulo.simulacion 			= 1 ) AND  
		( dt_pdnxmodulo.co_fabrica 			= :ii_co_fabrica_modulo ) AND  
		( dt_pdnxmodulo.co_planta 				= :ii_co_planta_modulo ) AND  
		( dt_pdnxmodulo.co_modulo 				= :ii_co_modulo ) AND  
		( dt_pdnxmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
		( dt_pdnxmodulo.pedido 					= :il_pedido ) AND  
		( dt_pdnxmodulo.cs_liberacion 		= :ii_cs_liberacion ) AND  
		( dt_pdnxmodulo.po 						= :is_nu_orden ) AND  
		( dt_pdnxmodulo.co_fabrica_pt 		= :ii_co_fabrica_pt ) AND  
		( dt_pdnxmodulo.co_linea 				= :ii_co_linea ) AND  
		( dt_pdnxmodulo.co_referencia 		= :il_co_referencia ) AND  
		( dt_pdnxmodulo.co_color_pt 			= :il_co_color_pt ) AND  
		( dt_pdnxmodulo.tono 					= :is_tono ) AND  
		( dt_pdnxmodulo.cs_estilocolortono 	= :ii_sec ) ;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base datos","No pudo actualizar la cantidad numerada en dt_pdnxmodulo")
	li_correcto=0
ELSE
END IF

RETURN li_correcto
end function

public function long wf_buscar_dt_libera_estilos ();Long li_correcto


li_correcto=1

SELECT dt_libera_estilos.co_fabrica_exp,   
         dt_libera_estilos.pedido,   
         dt_libera_estilos.cs_liberacion,   
         dt_libera_estilos.nu_orden,   
         dt_libera_estilos.co_fabrica,   
         dt_libera_estilos.co_linea,   
         dt_libera_estilos.co_referencia,   
         dt_libera_estilos.co_color_pt,   
         dt_libera_estilos.tono  
    INTO :ii_co_fabrica_exp,   
         :il_pedido,   
         :ii_cs_liberacion,   
         :is_nu_orden,   
         :ii_co_fabrica_pt,   
         :ii_co_linea,   
         :il_co_referencia,   
         :il_co_color_pt,   
         :is_tono  
    FROM dt_libera_estilos  
   WHERE ( dt_libera_estilos.co_fabrica_exp > 0 ) AND  
         ( dt_libera_estilos.cs_estilocolortono 	= :ii_sec ) AND  
         ( dt_libera_estilos.cs_ordenpd_pt 			= :il_op )   ;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base de datos","No pudo buscar datos del estilo en la liberaci$$HEX1$$f300$$ENDHEX$$n")
	li_correcto=0
ELSE
END IF

RETURN li_correcto

end function

public function long wf_update_dt_talla_pdnmodulo ();Long	li_correcto,li_cs_orden_talla,li_co_talla
LONG		ll_cs_ordenpd_pt,ll_ca_numerada
TRANSACTION	itr_tela

itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd tela","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd tela","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd tela","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd tela","LOCK","")
CONNECT USING itr_tela;

li_correcto=1

ll_cs_ordenpd_pt=LONG(sle_parametro1.text)

DECLARE cur_tallas CURSOR FOR
SELECT dt_talla_pdnmodulo.cs_orden_talla,dt_talla_pdnmodulo.co_talla,dt_talla_pdnmodulo.ca_numerada
FROM   dt_talla_pdnmodulo
WHERE ( dt_talla_pdnmodulo.simulacion 				= 1 ) AND  
		( dt_talla_pdnmodulo.co_fabrica 				= :ii_co_fabrica_modulo ) AND  
		( dt_talla_pdnmodulo.co_planta 				= :ii_co_planta_modulo ) AND  
		( dt_talla_pdnmodulo.co_modulo 				= :ii_co_modulo ) AND  
		( dt_talla_pdnmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
		( dt_talla_pdnmodulo.pedido 					= :il_pedido ) AND  
		( dt_talla_pdnmodulo.cs_liberacion 			= :ii_cs_liberacion ) AND  
		( dt_talla_pdnmodulo.po 						= :is_nu_orden ) AND  
		( dt_talla_pdnmodulo.co_fabrica_pt 			= :ii_co_fabrica_pt ) AND  
		( dt_talla_pdnmodulo.co_linea 				= :ii_co_linea ) AND  
		( dt_talla_pdnmodulo.co_referencia 			= :il_co_referencia ) AND  
		( dt_talla_pdnmodulo.co_color_pt 			= :il_co_color_pt ) AND  
		( dt_talla_pdnmodulo.tono 						= :is_tono ) AND  
		( dt_talla_pdnmodulo.cs_estilocolortono 	= :ii_sec )		  
ORDER BY 1;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base datos","No pudo declarar la b$$HEX1$$fa00$$ENDHEX$$squeda de tallas para actualizar cantidad numerada")
	li_correcto=0
	RETURN li_correcto
ELSE
END IF		
		
OPEN cur_tallas;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base datos","No pudo abrir la b$$HEX1$$fa00$$ENDHEX$$squeda de tallas para actualizar cantidad numerada")
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

FETCH cur_tallas INTO :li_cs_orden_talla,:li_co_talla,:ll_ca_numerada;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base datos","No pudo ejecutar la b$$HEX1$$fa00$$ENDHEX$$squeda de tallas para actualizar cantidad numerada")
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

DO WHILE SQLCA.SQLCODE=0
	
	  UPDATE dt_talla_pdnmodulo  
     SET ca_programada = ca_numerada,   
         ca_pendiente = ca_numerada - ca_producida  
		WHERE dt_talla_pdnmodulo.simulacion = 1 and
			( dt_talla_pdnmodulo.co_fabrica 				= :ii_co_fabrica_modulo ) AND  
			( dt_talla_pdnmodulo.co_planta 				= :ii_co_planta_modulo ) AND  
			( dt_talla_pdnmodulo.co_modulo 				= :ii_co_modulo ) AND  
			( dt_talla_pdnmodulo.co_fabrica_exp 		= :ii_co_fabrica_exp ) AND  
			( dt_talla_pdnmodulo.pedido 					= :il_pedido ) AND  
			( dt_talla_pdnmodulo.cs_liberacion 			= :ii_cs_liberacion ) AND  
			( dt_talla_pdnmodulo.po 						= :is_nu_orden ) AND  
			( dt_talla_pdnmodulo.co_fabrica_pt 			= :ii_co_fabrica_pt ) AND  
			( dt_talla_pdnmodulo.co_linea 				= :ii_co_linea ) AND  
			( dt_talla_pdnmodulo.co_referencia 			= :il_co_referencia ) AND  
			( dt_talla_pdnmodulo.co_color_pt 			= :il_co_color_pt ) AND  
			( dt_talla_pdnmodulo.tono 						= :is_tono ) AND  
			( dt_talla_pdnmodulo.cs_estilocolortono 	= :ii_sec )	           ;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base datos","No pudo actualizar cantidad numerada en tallas")
		li_correcto=0
		RETURN li_correcto
	ELSE
	END IF
	
	UPDATE m_lotes_conf SET ca_programada=:ll_ca_numerada
	   WHERE co_fabrica > 0
		AND   cs_ordenpd=:ll_cs_ordenpd_pt
		AND   co_talla=:li_co_talla
		AND   co_color=:il_co_color_pt
	USING itr_tela;
	
	FETCH cur_tallas INTO :li_cs_orden_talla,:li_co_talla,:ll_ca_numerada;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base datos","No pudo ejecutar la b$$HEX1$$fa00$$ENDHEX$$squeda de tallas para actualizar cantidad numerada")
		li_correcto=0
		RETURN li_correcto
	ELSE
	END IF
	
LOOP

CLOSE cur_tallas;		
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error Base datos","No pudo cerrar la b$$HEX1$$fa00$$ENDHEX$$squeda de tallas para actualizar cantidad numerada")
	li_correcto=0
	RETURN li_correcto
ELSE
END IF

DISCONNECT USING itr_tela;

RETURN li_correcto

end function

on w_actualizar_unidades_numeradasxescala.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_secuencia=create em_secuencia
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_secuencia
end on

on w_actualizar_unidades_numeradasxescala.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_secuencia)
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_unidades_numeradasxescala
integer x = 663
integer y = 712
integer taborder = 40
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_unidades_numeradasxescala
integer x = 197
integer y = 712
integer taborder = 30
string text = "&Procesar"
end type

event pb_buscar::clicked;Long		li_correcto
s_base_parametros 	lstr_parametros
lstr_parametros.hay_parametros = TRUE
lstr_parametros.cadena[1]=sle_parametro1.text

li_correcto=1

il_op=LONG(sle_parametro1.text)
ii_sec=Long(em_secuencia.TEXT)

IF wf_buscar_dt_libera_estilos()=1 THEN
ELSE
	ROLLBACK;
	RETURN
END IF

//actualizar dt_libera_estilos

//actualizar dt_escalasxtela

//actualizar m_lotes_conf

IF wf_buscar_dt_pdnxmodulo()=1 THEN
ELSE
	ROLLBACK;
	RETURN
END IF


//update a dt_pdnxmodulo ca_prog,ca_pte
IF wf_update_dt_pdnxmodulo()=1 THEN
ELSE
	ROLLBACK;
	RETURN
END IF

//ciclo para buscar dt_talla_pdnmodulo
IF wf_update_dt_talla_pdnmodulo()=1 THEN
ELSE
	ROLLBACK;
	RETURN
END IF

COMMIT;

Close(parent)


end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_unidades_numeradasxescala
integer x = 224
integer y = 168
integer width = 338
string text = "Orden de Pdn: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_unidades_numeradasxescala
integer x = 562
integer y = 164
integer width = 343
integer height = 92
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_unidades_numeradasxescala
integer height = 660
integer taborder = 0
end type

type st_2 from statictext within w_actualizar_unidades_numeradasxescala
integer x = 247
integer y = 444
integer width = 302
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "Secuencia:"
boolean focusrectangle = false
end type

type em_secuencia from editmask within w_actualizar_unidades_numeradasxescala
integer x = 562
integer y = 420
integer width = 343
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

