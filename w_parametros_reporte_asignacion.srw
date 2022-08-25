HA$PBExportHeader$w_parametros_reporte_asignacion.srw
forward
global type w_parametros_reporte_asignacion from w_base_buscar_interactivo
end type
type st_2 from st_1 within w_parametros_reporte_asignacion
end type
type em_nro_asignacion from editmask within w_parametros_reporte_asignacion
end type
end forward

global type w_parametros_reporte_asignacion from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer width = 1294
integer height = 820
st_2 st_2
em_nro_asignacion em_nro_asignacion
end type
global w_parametros_reporte_asignacion w_parametros_reporte_asignacion

on w_parametros_reporte_asignacion.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_nro_asignacion=create em_nro_asignacion
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_nro_asignacion
end on

on w_parametros_reporte_asignacion.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_nro_asignacion)
end on

event open;this.width = 1294
this.height = 820
/* Se inician parametros con la fecha actual y simulacion 1 por defecto */ 
sle_parametro1.text = '1'
em_nro_asignacion.text = '0'
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_parametros_reporte_asignacion
integer x = 677
integer y = 532
integer taborder = 40
end type

event pb_cancelar::clicked;s_base_parametros lstr_parametros

/* Organiza variables para cancelar el proceso */
lstr_parametros.entero[1] = 0 
lstr_parametros.entero[2] = 0 
lstr_parametros.hay_parametros = FALSE

CloseWithReturn(Parent, lstr_parametros)
end event

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_parametros_reporte_asignacion
integer x = 165
integer y = 532
integer taborder = 30
string text = "&Aceptar"
end type

event pb_buscar::clicked;s_base_parametros lstr_parametros

/* Llena estructura de parametros con los valores digitados */
lstr_parametros.entero[1] = Long(sle_parametro1.Text)
lstr_parametros.entero[2] = Long(em_nro_asignacion.Text)

/* Verifica que hayan datos para continuar el proceso */
IF NOT isnull(lstr_parametros.entero[1]) AND NOT ISNULL(lstr_parametros.entero[2]) THEN
	lstr_parametros.hay_parametros = TRUE
ELSE
	lstr_parametros.hay_parametros = FALSE
END IF

CloseWithReturn(Parent, lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_parametros_reporte_asignacion
integer x = 160
integer y = 116
integer width = 347
integer height = 81
string text = "Nro. Simulacion"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_parametros_reporte_asignacion
integer x = 626
integer y = 96
integer width = 219
integer taborder = 10
end type

event sle_parametro1::modified;call super::modified;Long ll_simulacion

ll_simulacion = Long(sle_parametro1.text)

if ll_simulacion <= 0 then
	messagebox('Error en Simulacion','La simulacion no Puede ser Cero',exclamation!)
	return -1
end if

end event

type gb_1 from w_base_buscar_interactivo`gb_1 within w_parametros_reporte_asignacion
integer x = 59
integer y = 12
integer height = 472
integer taborder = 50
end type

type st_2 from st_1 within w_parametros_reporte_asignacion
integer x = 165
integer y = 244
integer width = 430
integer height = 80
boolean bringtotop = true
string text = "Numero Asignacion"
end type

type em_nro_asignacion from editmask within w_parametros_reporte_asignacion
integer x = 626
integer y = 224
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

event modified;Long ll_nro_asignacion

ll_nro_asignacion = Long(em_nro_asignacion.text)

if ll_nro_asignacion <= 0 then
	messagebox('Error en Numero Asignacion','El numero de Asignacion no Puede ser Cero',exclamation!)
	return -1
end if

end event

