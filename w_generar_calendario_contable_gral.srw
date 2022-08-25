HA$PBExportHeader$w_generar_calendario_contable_gral.srw
forward
global type w_generar_calendario_contable_gral from w_base_buscar_interactivo
end type
type st_2 from statictext within w_generar_calendario_contable_gral
end type
type em_fe_final from editmask within w_generar_calendario_contable_gral
end type
type em_fe_inicial from editmask within w_generar_calendario_contable_gral
end type
type em_semana from editmask within w_generar_calendario_contable_gral
end type
type st_semana from statictext within w_generar_calendario_contable_gral
end type
type st_3 from statictext within w_generar_calendario_contable_gral
end type
type em_generando from editmask within w_generar_calendario_contable_gral
end type
end forward

global type w_generar_calendario_contable_gral from w_base_buscar_interactivo
int Height=1160
st_2 st_2
em_fe_final em_fe_final
em_fe_inicial em_fe_inicial
em_semana em_semana
st_semana st_semana
st_3 st_3
em_generando em_generando
end type
global w_generar_calendario_contable_gral w_generar_calendario_contable_gral

on w_generar_calendario_contable_gral.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_fe_final=create em_fe_final
this.em_fe_inicial=create em_fe_inicial
this.em_semana=create em_semana
this.st_semana=create st_semana
this.st_3=create st_3
this.em_generando=create em_generando
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_fe_final
this.Control[iCurrent+3]=this.em_fe_inicial
this.Control[iCurrent+4]=this.em_semana
this.Control[iCurrent+5]=this.st_semana
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_generando
end on

on w_generar_calendario_contable_gral.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_fe_final)
destroy(this.em_fe_inicial)
destroy(this.em_semana)
destroy(this.st_semana)
destroy(this.st_3)
destroy(this.em_generando)
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_generar_calendario_contable_gral
int X=677
int Y=868
int TabOrder=50
end type

event pb_cancelar::clicked;
Close(Parent)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_generar_calendario_contable_gral
int X=210
int Y=868
int TabOrder=40
string Text="&Generar"
end type

event pb_buscar::clicked;Long			li_anno,li_mes,li_dia,li_semana,li_co_dia,li_cuantos

STRING			ls_estado,ls_co_dia,ls_nombre_dia

DATE 				ldt_fe_inicio,ldt_fe_fin,ld_fe_avance,ldt_fe_calendario

BOOLEAN 			lb_control

s_base_parametros 	lstr_parametro


ldt_fe_inicio=DATE(em_fe_inicial.text)
ldt_fe_fin=DATE(em_fe_final.text)
li_semana=Long(em_semana.TEXT)

//validar fechas

IF ldt_fe_fin	<= ldt_fe_inicio THEN
	MessageBox("Error","La fecha de inicio debe ser mayor que la fecha de fin")
ELSE
END IF

lb_control=TRUE

lstr_parametro.cadena[1]="Generando Calendario General..."
lstr_parametro.cadena[2]="El sistema esta generando el calendario, esta operacion puede demorar unos segundos, espere un momento por favor..."
lstr_parametro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametro)

ld_fe_avance=ldt_fe_inicio

//calendario por a$$HEX1$$f100$$ENDHEX$$o

DO WHILE lb_control

	
	
	li_anno		=year(ld_fe_avance)
	li_mes		=month(ld_fe_avance)
	li_dia		=day(ld_fe_avance)
	
	ls_nombre_dia = UPPER(string(ld_fe_avance, "ddd"))
	
	CHOOSE CASE ls_nombre_dia
		CASE 'MON'
			li_co_dia=1
		CASE 'TUE'				
			li_co_dia=2
		CASE 'WED'				
			li_co_dia=3
		CASE 'THU'
			li_co_dia=4
		CASE 'FRI'
			li_co_dia=5
		CASE 'SAT'
			li_co_dia=6
		CASE 'SUN'
			li_co_dia=7
	END CHOOSE
	
	IF li_mes=1 AND li_dia=1 THEN
		li_semana=1
	ELSE
		IF li_co_dia=1 THEN
			li_semana=li_semana + 1
		ELSE
		END IF
	END IF
	
//	ls_co_dia=DAYNAME(ld_fe_avance)
//		
//	CHOOSE CASE   ls_co_dia
//		CASE "MONDAY" 		li_co_dia=1
//		CASE "TUESDAY" 	li_co_dia=2
//		CASE "WEDNESDAY" 	li_co_dia=3
//		CASE "THURSDAY" 	li_co_dia=4
//		CASE "FRIDAY" 		li_co_dia=5
//		CASE "SUNDAY" 		li_co_dia=6
//		CASE "SATURDAY" 	li_co_dia=7
//	END CHOOSE
	
	IF li_co_dia=7 THEN
		ls_estado="I"
	ELSE
		ls_estado	="A"
	END IF
	
	
	//genere registro
	//BUSCA SI EXISTE UPDATE fe_calendario, else insert
	SELECT COUNT(*)
    INTO :li_cuantos
    FROM m_calendario_cont  
   WHERE ( m_calendario_cont.ano 		=:li_anno  ) AND  
         ( m_calendario_cont.mes 		=:li_mes  ) AND  
         ( m_calendario_cont.semana 	=:li_semana  ) AND  
         ( m_calendario_cont.co_dia 	=:li_co_dia  )   ;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo buscar la fecha calendario")
		RETURN
	ELSE
	END IF

	IF ISNULL(li_cuantos) OR li_cuantos=0 THEN
		//INSERT
		INSERT INTO mardila.m_calendario_cont  
				( ano,   
				  mes,   
				  semana,   
				  co_dia,   
				  dia,   
				  estado,
				  fe_calendario)  
		VALUES (:li_anno,   
				  :li_mes,   
				  :li_semana,   
				  :li_co_dia,   
				  :li_dia,   
				  :ls_estado,
				  :ld_fe_avance)  ;
				  
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo Insertar registro en generaci$$HEX1$$f300$$ENDHEX$$n de calendario")
			RETURN
		ELSE
		END IF
	ELSE
		//UPDATE
		UPDATE m_calendario_cont  
		  SET fe_calendario = :ld_fe_avance  
		WHERE ( m_calendario_cont.ano 		= :li_anno ) AND  
				( m_calendario_cont.mes 		= :li_mes ) AND  
				( m_calendario_cont.semana 	= :li_semana ) AND  
				( m_calendario_cont.co_dia 	= :li_co_dia )   ;
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo actualizar registro en generaci$$HEX1$$f300$$ENDHEX$$n de calendario")
			RETURN
		ELSE
		END IF
	END IF

	//avance en fecha
	ld_fe_avance=RelativeDate(ld_fe_avance,1)
	
	IF ld_fe_avance > ldt_fe_fin THEN
		lb_control=FALSE
	ELSE
	END IF
	Close(w_retroalimentacion)
	
	em_generando.TEXT=STRING(ld_fe_avance) 

LOOP

COMMIT;


MessageBox("Proceso Exitoso","Termin$$HEX2$$f3002000$$ENDHEX$$la generaci$$HEX1$$f300$$ENDHEX$$n de el calendario, por favor verifique.")

end event

type st_1 from w_base_buscar_interactivo`st_1 within w_generar_calendario_contable_gral
int Width=302
string Text="Fecha Inicio: "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_generar_calendario_contable_gral
int X=466
int Y=124
int TabOrder=60
boolean Visible=false
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_generar_calendario_contable_gral
int Y=0
int Height=788
int TabOrder=0
end type

type st_2 from statictext within w_generar_calendario_contable_gral
int X=165
int Y=348
int Width=247
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Fecha Fin:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_fe_final from editmask within w_generar_calendario_contable_gral
int X=494
int Y=340
int Width=288
int Height=100
int TabOrder=30
boolean BringToTop=true
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
string Mask="dd-mm-yyyy"
MaskDataType MaskDataType=DateMask!
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_fe_inicial from editmask within w_generar_calendario_contable_gral
int X=503
int Y=124
int Width=288
int Height=100
int TabOrder=10
boolean BringToTop=true
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
string Mask="dd-mm-yyyy"
MaskDataType MaskDataType=DateMask!
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_semana from editmask within w_generar_calendario_contable_gral
int X=869
int Y=128
int Width=247
int Height=100
int TabOrder=20
boolean BringToTop=true
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
string Mask="#####"
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_semana from statictext within w_generar_calendario_contable_gral
int X=864
int Y=60
int Width=247
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="SEMANA:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_generar_calendario_contable_gral
int X=206
int Y=584
int Width=265
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Generando:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_generando from editmask within w_generar_calendario_contable_gral
int X=494
int Y=536
int Width=288
int Height=100
boolean BringToTop=true
Alignment Alignment=Right!
BorderStyle BorderStyle=StyleLowered!
string Mask="dd-mm-yyyy"
MaskDataType MaskDataType=DateMask!
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

