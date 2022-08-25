HA$PBExportHeader$w_copiar_calendarioxmodulo.srw
forward
global type w_copiar_calendarioxmodulo from w_base_buscar_interactivo
end type
type st_2 from statictext within w_copiar_calendarioxmodulo
end type
type st_3 from statictext within w_copiar_calendarioxmodulo
end type
type em_planta_origen from editmask within w_copiar_calendarioxmodulo
end type
type em_modulo_origen from editmask within w_copiar_calendarioxmodulo
end type
type em_turno_origen from editmask within w_copiar_calendarioxmodulo
end type
type st_4 from statictext within w_copiar_calendarioxmodulo
end type
type st_5 from statictext within w_copiar_calendarioxmodulo
end type
type st_6 from statictext within w_copiar_calendarioxmodulo
end type
type st_7 from statictext within w_copiar_calendarioxmodulo
end type
type st_8 from statictext within w_copiar_calendarioxmodulo
end type
type em_fe_inicio_origen from editmask within w_copiar_calendarioxmodulo
end type
type em_fe_fin_origen from editmask within w_copiar_calendarioxmodulo
end type
type st_9 from statictext within w_copiar_calendarioxmodulo
end type
type st_10 from statictext within w_copiar_calendarioxmodulo
end type
type st_11 from statictext within w_copiar_calendarioxmodulo
end type
type st_12 from statictext within w_copiar_calendarioxmodulo
end type
type st_13 from statictext within w_copiar_calendarioxmodulo
end type
type em_fabrica_destino from editmask within w_copiar_calendarioxmodulo
end type
type em_planta_destino from editmask within w_copiar_calendarioxmodulo
end type
type em_modulo_destino from editmask within w_copiar_calendarioxmodulo
end type
type em_turno_destino from editmask within w_copiar_calendarioxmodulo
end type
end forward

global type w_copiar_calendarioxmodulo from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer width = 2021
integer height = 1588
string title = "Copiador de Calendario por M$$HEX1$$f300$$ENDHEX$$dulo"
st_2 st_2
st_3 st_3
em_planta_origen em_planta_origen
em_modulo_origen em_modulo_origen
em_turno_origen em_turno_origen
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
em_fe_inicio_origen em_fe_inicio_origen
em_fe_fin_origen em_fe_fin_origen
st_9 st_9
st_10 st_10
st_11 st_11
st_12 st_12
st_13 st_13
em_fabrica_destino em_fabrica_destino
em_planta_destino em_planta_destino
em_modulo_destino em_modulo_destino
em_turno_destino em_turno_destino
end type
global w_copiar_calendarioxmodulo w_copiar_calendarioxmodulo

on w_copiar_calendarioxmodulo.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.em_planta_origen=create em_planta_origen
this.em_modulo_origen=create em_modulo_origen
this.em_turno_origen=create em_turno_origen
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.em_fe_inicio_origen=create em_fe_inicio_origen
this.em_fe_fin_origen=create em_fe_fin_origen
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_13=create st_13
this.em_fabrica_destino=create em_fabrica_destino
this.em_planta_destino=create em_planta_destino
this.em_modulo_destino=create em_modulo_destino
this.em_turno_destino=create em_turno_destino
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.em_planta_origen
this.Control[iCurrent+4]=this.em_modulo_origen
this.Control[iCurrent+5]=this.em_turno_origen
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.st_8
this.Control[iCurrent+11]=this.em_fe_inicio_origen
this.Control[iCurrent+12]=this.em_fe_fin_origen
this.Control[iCurrent+13]=this.st_9
this.Control[iCurrent+14]=this.st_10
this.Control[iCurrent+15]=this.st_11
this.Control[iCurrent+16]=this.st_12
this.Control[iCurrent+17]=this.st_13
this.Control[iCurrent+18]=this.em_fabrica_destino
this.Control[iCurrent+19]=this.em_planta_destino
this.Control[iCurrent+20]=this.em_modulo_destino
this.Control[iCurrent+21]=this.em_turno_destino
end on

on w_copiar_calendarioxmodulo.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_planta_origen)
destroy(this.em_modulo_origen)
destroy(this.em_turno_origen)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.em_fe_inicio_origen)
destroy(this.em_fe_fin_origen)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.em_fabrica_destino)
destroy(this.em_planta_destino)
destroy(this.em_modulo_destino)
destroy(this.em_turno_destino)
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_copiar_calendarioxmodulo
integer x = 933
integer y = 1308
integer taborder = 120
string text = "&Salir"
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_copiar_calendarioxmodulo
integer x = 466
integer y = 1308
integer taborder = 110
string text = "&Copiar"
end type

event pb_buscar::clicked;Long			li_co_fabrica_origen,li_co_planta_origen,li_co_modulo_origen,li_co_turno_origen
Long			li_co_fabrica_destino,li_co_planta_destino,li_co_modulo_destino,li_co_turno_destino
Long			li_anno,li_mes,li_semana,li_co_dia,li_turno,li_dia,li_co_tipo_dia
LONG 				ll_count
DECIMAL			ldc_minutos

STRING			ls_co_tipo_dia

DATE				ld_fe_inicio_origen,ld_fe_fin_origen,ld_fe_mod_calendario

DATETIME			ldt_fe_actualizacion

BOOLEAN			lb_entra_a_ciclo

s_base_parametros lstr_parametro


//traer parametros
li_co_fabrica_origen		=Long(sle_parametro1.TEXT)
li_co_planta_origen		=Long(em_planta_origen.TEXT)
li_co_modulo_origen		=Long(em_modulo_origen.TEXT)
li_co_turno_origen		=Long(em_turno_origen.TEXT)
li_co_fabrica_destino	=Long(em_fabrica_destino.TEXT)
li_co_planta_destino		=Long(em_planta_destino.TEXT)
li_co_modulo_destino		=Long(em_modulo_destino.TEXT)
li_co_turno_destino		=Long(em_turno_destino.TEXT)
ld_fe_inicio_origen		=DATE(em_fe_inicio_origen.TEXT)
ld_fe_fin_origen			=DATE(em_fe_fin_origen.TEXT)


//validaciones

//hacer ciclo de busqueda en origen
DECLARE cur_ciclo CURSOR FOR
  SELECT dt_mod_calendario.ano,   
         dt_mod_calendario.mes,   
         dt_mod_calendario.semana,   
         dt_mod_calendario.co_dia,   
         dt_mod_calendario.turno,   
         dt_mod_calendario.dia,   
         dt_mod_calendario.fe_mod_calendario,   
         dt_mod_calendario.minutos,   
         dt_mod_calendario.co_tipo_dia  
    FROM dt_mod_calendario  
   WHERE ( dt_mod_calendario.co_fabrica 	=:li_co_fabrica_origen ) AND  
         ( dt_mod_calendario.co_planta 	=:li_co_planta_origen ) AND  
         ( dt_mod_calendario.co_modulo 	=:li_co_modulo_origen ) AND  
         ( dt_mod_calendario.turno 			=:li_co_turno_origen ) AND  
         ( dt_mod_calendario.fe_mod_calendario between :ld_fe_inicio_origen AND :ld_fe_fin_origen )   ;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base dato","No pudo hacer busqueda de datos de origen")
	RETURN
ELSE
END IF

lstr_parametro.cadena[1]="Copiando Calendario por M$$HEX1$$f300$$ENDHEX$$dulo..."
Lstr_parametro.cadena[2]="El sistema esta generando el calendario, esta operacion puede demorar unos segundos, espere un momento por favor..."
lstr_parametro.cadena[3]="reloj"
	
OpenWithParm(w_retroalimentacion,lstr_parametro)
			
			
OPEN cur_ciclo;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base dato","No pudo abrir busqueda de datos de origen")
	RETURN
	Close(w_retroalimentacion)
ELSE
END IF
lb_entra_a_ciclo=FALSE
FETCH cur_ciclo INTO :li_anno,:li_mes,:li_semana,:li_co_dia,:li_turno,:li_dia,
							:ld_fe_mod_calendario,:ldc_minutos,:ls_co_tipo_dia;
IF SQLCA.SQLCODE=-1 THEN
	MessageBox("Error base dato","No pudo traer datos en la busqueda de datos de origen")
	RETURN
	Close(w_retroalimentacion)
ELSE
END IF							
							
DO WHILE SQLCA.SQLCODE=0
	
	lb_entra_a_ciclo=TRUE
	
	ldt_fe_actualizacion	=f_fecha_servidor()
	
	//primero determino si elregistro existe o no en dt_mod_calendario
	
	select count(*)
	into :ll_count
	from dt_mod_calendario
	where co_fabrica = :li_co_fabrica_destino and
			co_planta = :li_co_planta_destino and
			co_modulo = :li_co_modulo_destino and
			ano = :li_anno and
			mes = :li_mes and
			turno = :li_co_turno_destino and
			dia = :li_dia;
	
	If ll_count >= 1 Then		
		//modifico en destino
		update dt_mod_calendario  
		  set  semana = :li_semana,   
				 co_dia = :li_co_dia,   
				 fe_mod_calendario = :ld_fe_mod_calendario,   
				 minutos = :ldc_minutos,   
				 fe_actualizacion = :ldt_fe_actualizacion,   
				 usuario = :gstr_info_usuario.codigo_usuario,   
				 instancia = :gstr_info_usuario.instancia,   
				 co_tipo_dia = :ls_co_tipo_dia  
		 where co_fabrica = :li_co_fabrica_destino and
			 	 co_planta = :li_co_planta_destino and
				 co_modulo = :li_co_modulo_destino and
				 ano = :li_anno and
				 mes = :li_mes and
				 turno = :li_co_turno_destino and
				 dia = :li_dia;
		
	Else//ll_count >= 1
		//insertar en destino
		  insert into dt_mod_calendario  
				( co_fabrica,					co_planta,					co_modulo,					ano,				mes,   
				  semana,   					co_dia,						turno,  						dia, 				fe_mod_calendario,   
				  minutos,   					fe_actualizacion, 		usuario,						instancia,		co_tipo_dia )  
	  values ( :li_co_fabrica_destino,  :li_co_planta_destino,  :li_co_modulo_destino,  :li_anno,   	:li_mes,   
				  :li_semana,   				:li_co_dia,   				:li_co_turno_destino,   :li_dia,   		:ld_fe_mod_calendario,   
				  :ldc_minutos,   			:ldt_fe_actualizacion,  :gstr_info_usuario.codigo_usuario,   
				  :gstr_info_usuario.instancia,   :ls_co_tipo_dia )  ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error base dato","No pudo insertar datos en la copia de datos de origen")
			RETURN
			Close(w_retroalimentacion)
		ELSE
		END IF
		
	End if//ll_count >= 1	
	
	FETCH cur_ciclo INTO :li_anno,:li_mes,:li_semana,:li_co_dia,:li_turno,:li_dia,
							:ld_fe_mod_calendario,:ldc_minutos,:ls_co_tipo_dia;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error base dato","No pudo traer datos en la busqueda de datos de origen")
		RETURN
		Close(w_retroalimentacion)
	ELSE
	END IF
	
LOOP

CLOSE cur_ciclo;

IF lb_entra_a_ciclo THEN
	COMMIT;
	Close(w_retroalimentacion)

	MessageBox("Proceso Exitoso","Termin$$HEX2$$f3002000$$ENDHEX$$la copia de el calendario, por favor verifique.")
ELSE
	ROLLBACK;
	Close(w_retroalimentacion)

	MessageBox("Fall$$HEX2$$f3002000$$ENDHEX$$Proceso","Termin$$HEX2$$f3002000$$ENDHEX$$la copia de el calendario, por favor verifique.")
END IF





end event

type st_1 from w_base_buscar_interactivo`st_1 within w_copiar_calendarioxmodulo
integer x = 69
integer y = 284
integer width = 229
string text = "ORIGEN:"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_copiar_calendarioxmodulo
integer x = 311
integer y = 276
integer width = 201
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_copiar_calendarioxmodulo
integer x = 14
integer y = 8
integer width = 1984
integer height = 1244
integer taborder = 0
end type

type st_2 from statictext within w_copiar_calendarioxmodulo
integer x = 320
integer y = 196
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
string text = "F$$HEX1$$e100$$ENDHEX$$brica:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_copiar_calendarioxmodulo
integer x = 741
integer y = 196
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

type em_planta_origen from editmask within w_copiar_calendarioxmodulo
integer x = 741
integer y = 280
integer width = 201
integer height = 88
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

type em_modulo_origen from editmask within w_copiar_calendarioxmodulo
integer x = 1170
integer y = 280
integer width = 201
integer height = 88
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

type em_turno_origen from editmask within w_copiar_calendarioxmodulo
integer x = 1600
integer y = 280
integer width = 201
integer height = 88
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
string mask = "#####"
end type

type st_4 from statictext within w_copiar_calendarioxmodulo
integer x = 1161
integer y = 196
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

type st_5 from statictext within w_copiar_calendarioxmodulo
integer x = 1605
integer y = 196
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

type st_6 from statictext within w_copiar_calendarioxmodulo
integer x = 50
integer y = 556
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
string text = "FECHAS:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_copiar_calendarioxmodulo
integer x = 325
integer y = 480
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
string text = "Inicio:"
boolean focusrectangle = false
end type

type st_8 from statictext within w_copiar_calendarioxmodulo
integer x = 1221
integer y = 480
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
string text = "Fin"
boolean focusrectangle = false
end type

type em_fe_inicio_origen from editmask within w_copiar_calendarioxmodulo
integer x = 306
integer y = 536
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
string mask = "dd/mm/yyyy"
end type

type em_fe_fin_origen from editmask within w_copiar_calendarioxmodulo
integer x = 1166
integer y = 536
integer width = 640
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
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_9 from statictext within w_copiar_calendarioxmodulo
integer x = 46
integer y = 872
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
string text = "DESTINO:"
boolean focusrectangle = false
end type

type st_10 from statictext within w_copiar_calendarioxmodulo
integer x = 320
integer y = 756
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
string text = "F$$HEX1$$e100$$ENDHEX$$brica:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_copiar_calendarioxmodulo
integer x = 745
integer y = 756
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

type st_12 from statictext within w_copiar_calendarioxmodulo
integer x = 1170
integer y = 756
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

type st_13 from statictext within w_copiar_calendarioxmodulo
integer x = 1595
integer y = 756
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

type em_fabrica_destino from editmask within w_copiar_calendarioxmodulo
integer x = 311
integer y = 836
integer width = 201
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

type em_planta_destino from editmask within w_copiar_calendarioxmodulo
integer x = 741
integer y = 836
integer width = 201
integer height = 100
integer taborder = 80
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

type em_modulo_destino from editmask within w_copiar_calendarioxmodulo
integer x = 1170
integer y = 836
integer width = 201
integer height = 100
integer taborder = 90
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

type em_turno_destino from editmask within w_copiar_calendarioxmodulo
integer x = 1600
integer y = 836
integer width = 201
integer height = 100
integer taborder = 100
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

