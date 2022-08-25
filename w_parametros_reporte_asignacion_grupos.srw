HA$PBExportHeader$w_parametros_reporte_asignacion_grupos.srw
forward
global type w_parametros_reporte_asignacion_grupos from w_base_buscar_interactivo
end type
type sle_parametro2 from sle_parametro1 within w_parametros_reporte_asignacion_grupos
end type
type sle_parametro3 from sle_parametro1 within w_parametros_reporte_asignacion_grupos
end type
type sle_parametro4 from sle_parametro1 within w_parametros_reporte_asignacion_grupos
end type
end forward

global type w_parametros_reporte_asignacion_grupos from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer width = 1673
integer height = 820
sle_parametro2 sle_parametro2
sle_parametro3 sle_parametro3
sle_parametro4 sle_parametro4
end type
global w_parametros_reporte_asignacion_grupos w_parametros_reporte_asignacion_grupos

on w_parametros_reporte_asignacion_grupos.create
int iCurrent
call super::create
this.sle_parametro2=create sle_parametro2
this.sle_parametro3=create sle_parametro3
this.sle_parametro4=create sle_parametro4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_parametro2
this.Control[iCurrent+2]=this.sle_parametro3
this.Control[iCurrent+3]=this.sle_parametro4
end on

on w_parametros_reporte_asignacion_grupos.destroy
call super::destroy
destroy(this.sle_parametro2)
destroy(this.sle_parametro3)
destroy(this.sle_parametro4)
end on

event open;this.width = 1673
this.height = 820
/* Se inician parametros con la fecha actual y simulacion 1 por defecto */ 
sle_parametro1.text = ' '
sle_parametro2.text = ' '
sle_parametro3.text = ' '
sle_parametro4.text = ' '
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_parametros_reporte_asignacion_grupos
integer x = 882
integer y = 532
integer taborder = 60
end type

event pb_cancelar::clicked;s_base_parametros lstr_parametros

/* Organiza variables para cancelar el proceso */
lstr_parametros.cadena[1] = ' ' 
lstr_parametros.cadena[2] = ' ' 
lstr_parametros.cadena[3] = ' ' 
lstr_parametros.cadena[4] = ' ' 
lstr_parametros.hay_parametros = FALSE

CloseWithReturn(Parent, lstr_parametros)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_parametros_reporte_asignacion_grupos
integer x = 370
integer y = 532
integer taborder = 50
string text = "&Aceptar"
end type

event pb_buscar::clicked;s_base_parametros lstr_parametros

/* Llena estructura de parametros con los valores digitados */
lstr_parametros.cadena[1] = string(sle_parametro1.Text)
lstr_parametros.cadena[2] = string(sle_parametro2.Text)
lstr_parametros.cadena[3] = string(sle_parametro3.Text)
lstr_parametros.cadena[4] = string(sle_parametro4.Text)
/* Verifica que hayan datos para continuar el proceso */
IF NOT isnull(lstr_parametros.cadena[1]) OR NOT isnull(lstr_parametros.cadena[2]) OR &
	NOT isnull(lstr_parametros.cadena[3]) OR NOT isnull(lstr_parametros.cadena[4]) THEN
	lstr_parametros.hay_parametros = TRUE
ELSE
	lstr_parametros.hay_parametros = FALSE
END IF

CloseWithReturn(Parent, lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_parametros_reporte_asignacion_grupos
integer x = 91
integer y = 96
integer width = 233
string text = "Grupos "
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_parametros_reporte_asignacion_grupos
integer x = 398
integer y = 192
integer width = 1147
integer height = 89
integer taborder = 20
textcase textcase = upper!
end type

event sle_parametro1::modified;// Valida que hallan dado grupos

IF ISNULL(sle_parametro1.Text) THEN
	messagebox('Error en Gupos ','Los Grupos no Puede estar en Blanco',exclamation!)
	RETURN -1
END IF
end event

type gb_1 from w_base_buscar_interactivo`gb_1 within w_parametros_reporte_asignacion_grupos
integer x = 59
integer y = 12
integer width = 1559
integer height = 476
integer taborder = 70
end type

type sle_parametro2 from sle_parametro1 within w_parametros_reporte_asignacion_grupos
integer y = 96
integer height = 88
integer taborder = 10
boolean bringtotop = true
end type

type sle_parametro3 from sle_parametro1 within w_parametros_reporte_asignacion_grupos
integer y = 288
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

type sle_parametro4 from sle_parametro1 within w_parametros_reporte_asignacion_grupos
integer y = 384
integer height = 88
integer taborder = 40
boolean bringtotop = true
end type

