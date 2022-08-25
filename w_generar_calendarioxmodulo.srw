HA$PBExportHeader$w_generar_calendarioxmodulo.srw
forward
global type w_generar_calendarioxmodulo from w_base_buscar_interactivo
end type
type st_2 from statictext within w_generar_calendarioxmodulo
end type
type st_3 from statictext within w_generar_calendarioxmodulo
end type
type st_4 from statictext within w_generar_calendarioxmodulo
end type
type st_5 from statictext within w_generar_calendarioxmodulo
end type
type st_6 from statictext within w_generar_calendarioxmodulo
end type
type st_7 from statictext within w_generar_calendarioxmodulo
end type
type em_planta from editmask within w_generar_calendarioxmodulo
end type
type em_modulo from editmask within w_generar_calendarioxmodulo
end type
type em_fe_inicio from editmask within w_generar_calendarioxmodulo
end type
type em_fe_fin from editmask within w_generar_calendarioxmodulo
end type
type em_turno from editmask within w_generar_calendarioxmodulo
end type
type em_minutos from editmask within w_generar_calendarioxmodulo
end type
end forward

global type w_generar_calendarioxmodulo from w_base_buscar_interactivo
integer width = 1243
integer height = 1488
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
em_planta em_planta
em_modulo em_modulo
em_fe_inicio em_fe_inicio
em_fe_fin em_fe_fin
em_turno em_turno
em_minutos em_minutos
end type
global w_generar_calendarioxmodulo w_generar_calendarioxmodulo

on w_generar_calendarioxmodulo.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.em_planta=create em_planta
this.em_modulo=create em_modulo
this.em_fe_inicio=create em_fe_inicio
this.em_fe_fin=create em_fe_fin
this.em_turno=create em_turno
this.em_minutos=create em_minutos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.st_7
this.Control[iCurrent+7]=this.em_planta
this.Control[iCurrent+8]=this.em_modulo
this.Control[iCurrent+9]=this.em_fe_inicio
this.Control[iCurrent+10]=this.em_fe_fin
this.Control[iCurrent+11]=this.em_turno
this.Control[iCurrent+12]=this.em_minutos
end on

on w_generar_calendarioxmodulo.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.em_planta)
destroy(this.em_modulo)
destroy(this.em_fe_inicio)
destroy(this.em_fe_fin)
destroy(this.em_turno)
destroy(this.em_minutos)
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_generar_calendarioxmodulo
integer x = 631
integer y = 1220
integer width = 411
integer taborder = 90
string text = "&Salir"
end type

event pb_cancelar::clicked;//
//s_base_parametros lstr_parametros
//
//lstr_parametros.hay_parametros = FALSE
//CloseWithReturn(parent,lstr_parametros)

CLOSE(Parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_generar_calendarioxmodulo
integer x = 155
integer y = 1220
integer width = 375
integer taborder = 80
string text = "&Generar"
end type

event pb_buscar::clicked;Long					li_co_fabrica,li_co_planta,li_co_modulo
Long					li_a$$HEX1$$f100$$ENDHEX$$o,li_mes,li_semana,li_dia,li_co_dia,li_co_turno,li_co_tipo_dia
Long					ll_trae_modulos,ll_cuantas_fechas
Long					li_a$$HEX1$$f100$$ENDHEX$$o_ciclo,li_semana_ciclo,li_mes_ciclo,li_co_dia_ciclo,li_dia_ciclo

DECIMAL					ldc_minutos

STRING					ls_nom_turno,ls_co_tipo_dia

DATETIME					ldt_fechahora,ldt_fe_actualizacion

DATE						ldt_fe_inicio,ldt_fe_fin,ldt_fe_avance,ld_fe_calendario_ciclo

BOOLEAN					lb_entro_a_ciclo

Time						lt_inicio_turno

s_base_parametros		lstr_parametro


//traer par$$HEX1$$e100$$ENDHEX$$metros
li_co_fabrica		=	Long(sle_parametro1.TEXT)
li_co_planta		=	Long(em_planta.TEXT)
li_co_modulo		=	Long(em_modulo.TEXT)
ldt_fe_inicio		=	DATE(em_fe_inicio.TEXT)
ldt_fe_fin			=	DATE(em_fe_fin.TEXT)
li_co_turno			=	Long(em_turno.TEXT)
ldc_minutos			=	DEC(em_minutos.TEXT)

//validaciones
	//QUE EXISTA EL MODULO
	SELECT COUNT(*)  
    INTO :ll_trae_modulos  
    FROM m_modulos  
   WHERE ( m_modulos.co_fabrica 	=:li_co_fabrica  ) 	AND  
         ( m_modulos.co_planta 	=:li_co_planta ) 		AND  
         ( m_modulos.co_modulo 	=:li_co_modulo  )   ;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo buscar M$$HEX1$$f300$$ENDHEX$$dulo, por favor verifique")
		RETURN
	ELSE
	END IF
	IF ll_trae_modulos<=0 THEN
		MessageBox("Error Datos","No pudo hallar el M$$HEX1$$f300$$ENDHEX$$dulo en la f$$HEX1$$e100$$ENDHEX$$brica y planta, por favor verifique")
		RETURN
	ELSE
	END IF
	//QUE LA FECHA DE INICIO SEA MENOR A LA DE FIN
	IF ldt_fe_inicio > ldt_fe_fin THEN
		MessageBox("Error de datos","La fecha de inicio es mayor que la fecha de fin, por favor verifique")
		RETURN
	ELSE
	END IF
	//QUE NO EXISTAN FECHAS ENTRE ELLAS
//	SELECT COUNT(*) 
//	  INTO :ll_cuantas_fechas
//    FROM dt_mod_calendario  
//   WHERE ( dt_mod_calendario.co_fabrica 			=:li_co_fabrica ) AND  
//         ( dt_mod_calendario.co_planta 			=:li_co_planta ) AND  
//         ( dt_mod_calendario.co_modulo 			=:li_co_modulo ) AND  
//         ( dt_mod_calendario.fe_mod_calendario 	between :ldt_fe_inicio AND :ldt_fe_fin )   ;
//	IF SQLCA.SQLCODE=-1 THEN
//		MessageBox("Error Base Datos","No pudo buscar fechas entre M$$HEX1$$f300$$ENDHEX$$dulo, por favor verifique")
//		RETURN
//	ELSE
//	END IF
//	IF ll_cuantas_fechas>0 THEN
//		MessageBox("Error Datos","Existen fechas entre las dadas para el M$$HEX1$$f300$$ENDHEX$$dulo, por favor verifique")
//		RETURN
//	ELSE
//	END IF
	//QUE EXISTA EL TURNO
	SELECT hora_inicial
    INTO :lt_inicio_turno  
    FROM turnos  
   WHERE turnos.co_turno = :li_co_turno   ;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo buscar TURNO en el maestro de turnos, por favor verifique")
		RETURN
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			MessageBox("Error Datos","No se hall$$HEX2$$f3002000$$ENDHEX$$TURNO en el maestro de turnos, por favor verifique")
			RETURN
		END IF
	END IF

	//QUE NO EXISTAN FECHAS ENTRA INICIO Y FIN CON EL TURNO
	SELECT COUNT(*) 
	  INTO :ll_cuantas_fechas
    FROM dt_mod_calendario  
   WHERE ( dt_mod_calendario.co_fabrica 			=:li_co_fabrica ) AND  
         ( dt_mod_calendario.co_planta 			=:li_co_planta ) AND  
         ( dt_mod_calendario.co_modulo 			=:li_co_modulo ) AND  
         ( dt_mod_calendario.fe_mod_calendario 	between :ldt_fe_inicio AND :ldt_fe_fin )   AND
			( dt_mod_calendario.turno					=:li_co_turno)			;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo buscar fechas entre M$$HEX1$$f300$$ENDHEX$$dulo para el turno, por favor verifique")
		RETURN
	ELSE
	END IF
	IF ll_cuantas_fechas>0 THEN
		MessageBox("Error Datos","Existen fechas entre las dadas para el M$$HEX1$$f300$$ENDHEX$$dulo y turno, por favor verifique")
		RETURN
	ELSE
	END IF
	//QUE TENGA MINUTOS > 0 
	IF ldc_minutos>0 THEN
	ELSE
		MessageBox("Error Datos","Los minutos deben ser mayores a cero, por favor verifique")
		RETURN
	END IF
	
	lstr_parametro.cadena[1]="Generando Calendario por M$$HEX1$$f300$$ENDHEX$$dulo..."
	lstr_parametro.cadena[2]="El sistema esta generando el calendario, esta operacion puede demorar unos segundos, espere un momento por favor..."
	lstr_parametro.cadena[3]="reloj"
	
	OpenWithParm(w_retroalimentacion,lstr_parametro)
	
	lb_entro_a_ciclo	=FALSE
	
//recorrer el calendario general con rango de fechas
	DECLARE cur_ciclo CURSOR FOR
	SELECT 	m_calendario_cont.ano,m_calendario_cont.mes,m_calendario_cont.semana,
				m_calendario_cont.co_dia,m_calendario_cont.dia,m_calendario_cont.fe_calendario
	 FROM 	m_calendario_cont  
   WHERE  	m_calendario_cont.fe_calendario 	between :ldt_fe_inicio AND :ldt_fe_fin    ;
	
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo declarar la busqueda de fechas en el calendario general")
		Close(w_retroalimentacion)
		RETURN
	ELSE
	END IF	
	
	OPEN cur_ciclo;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo abrir la busqueda de fechas en el calendario general")
		Close(w_retroalimentacion)
		RETURN
	ELSE
	END IF	
		
	FETCH cur_ciclo 
		INTO :li_a$$HEX1$$f100$$ENDHEX$$o_ciclo,:li_mes_ciclo,:li_semana_ciclo,
	  		 :li_co_dia_ciclo,:li_dia_ciclo,:ld_fe_calendario_ciclo;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo hacer la busqueda de fechas en el calendario general")
		Close(w_retroalimentacion)
		RETURN
	ELSE
	END IF
				
	DO WHILE SQLCA.SQLCODE=0
		
		lb_entro_a_ciclo	=TRUE
		
		ldt_fechahora 			= f_fecha_servidor()
		
   	ldt_fe_actualizacion	=ldt_fechahora
		
		IF li_co_dia_ciclo=7 THEN
			ls_co_tipo_dia="F"
		ELSE
			ls_co_tipo_dia="T"
		END IF
		
		
		//generar registro
		INSERT INTO dt_mod_calendario  
         ( co_fabrica,      	co_planta,         	co_modulo,         	ano,   
           mes,              	semana,              co_dia,              turno,   
           dia,              	fe_mod_calendario,   minutos,             fe_actualizacion,   
           usuario,           instancia,           co_tipo_dia )  
  		VALUES ( :li_co_fabrica,              			:li_co_planta,              	:li_co_modulo,   
           		:li_a$$HEX1$$f100$$ENDHEX$$o_ciclo,              			:li_mes_ciclo,              	:li_semana_ciclo,   
           		:li_co_dia_ciclo,              		:li_co_turno,              	:li_dia_ciclo,   
           		:ld_fe_calendario_ciclo,          	:ldc_minutos,              	:ldt_fe_actualizacion,   
           		:gstr_info_usuario.codigo_usuario,	:gstr_info_usuario.instancia,	:ls_co_tipo_dia )  ;
		
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo insertar en el calendario por m$$HEX1$$f300$$ENDHEX$$dulo")
			Close(w_retroalimentacion)
			RETURN
		ELSE
		END IF	
			  

		
		FETCH cur_ciclo 
		INTO :li_a$$HEX1$$f100$$ENDHEX$$o_ciclo,:li_mes_ciclo,:li_semana_ciclo,
	  		 :li_co_dia_ciclo,:li_dia_ciclo,:ld_fe_calendario_ciclo;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo hacer la busqueda de fechas en el calendario general")
			Close(w_retroalimentacion)
			RETURN
		ELSE
		END IF		
				
	LOOP
	
	CLOSE cur_ciclo;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo cerrar la busqueda de fechas en el calendario general")
		Close(w_retroalimentacion)
		RETURN
	ELSE
	END IF
	
	IF lb_entro_a_ciclo THEN
		COMMIT;
	ELSE
		ROLLBACK;
		MessageBox("Advertencia","No hall$$HEX2$$f3002000$$ENDHEX$$fechas en calendario General para generar calendario por M$$HEX1$$f300$$ENDHEX$$dulo")
	END IF
	
	

Close(w_retroalimentacion)

MessageBox("Proceso Exitoso","Termin$$HEX2$$f3002000$$ENDHEX$$la generaci$$HEX1$$f300$$ENDHEX$$n de el calendario, por favor verifique.")



end event

type st_1 from w_base_buscar_interactivo`st_1 within w_generar_calendarioxmodulo
integer x = 128
integer y = 140
string text = "F$$HEX1$$e100$$ENDHEX$$brica:"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_generar_calendarioxmodulo
integer x = 462
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_generar_calendarioxmodulo
integer x = 23
integer height = 1164
integer taborder = 0
end type

type st_2 from statictext within w_generar_calendarioxmodulo
integer x = 128
integer y = 292
integer width = 247
integer height = 76
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
string text = "Planta:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_generar_calendarioxmodulo
integer x = 128
integer y = 440
integer width = 247
integer height = 76
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
string text = "M$$HEX1$$f300$$ENDHEX$$dulo:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_generar_calendarioxmodulo
integer x = 128
integer y = 588
integer width = 288
integer height = 76
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
string text = "Fecha Inicio:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_generar_calendarioxmodulo
integer x = 128
integer y = 736
integer width = 247
integer height = 76
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
string text = "Fecha Fin:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_generar_calendarioxmodulo
integer x = 128
integer y = 884
integer width = 247
integer height = 76
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
string text = "Turno:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_generar_calendarioxmodulo
integer x = 128
integer y = 1032
integer width = 247
integer height = 76
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
string text = "Minutos:"
boolean focusrectangle = false
end type

type em_planta from editmask within w_generar_calendarioxmodulo
integer x = 462
integer y = 264
integer width = 635
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_modulo from editmask within w_generar_calendarioxmodulo
integer x = 462
integer y = 408
integer width = 635
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_fe_inicio from editmask within w_generar_calendarioxmodulo
integer x = 462
integer y = 552
integer width = 635
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd-mm-yyyy"
end type

type em_fe_fin from editmask within w_generar_calendarioxmodulo
integer x = 462
integer y = 696
integer width = 635
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd-mm-yyyy"
end type

type em_turno from editmask within w_generar_calendarioxmodulo
integer x = 462
integer y = 840
integer width = 635
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type em_minutos from editmask within w_generar_calendarioxmodulo
integer x = 462
integer y = 984
integer width = 635
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

