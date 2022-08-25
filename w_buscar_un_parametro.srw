HA$PBExportHeader$w_buscar_un_parametro.srw
forward
global type w_buscar_un_parametro from w_base_buscar_lista
end type
type em_parametro from editmask within w_buscar_un_parametro
end type
type st_1 from statictext within w_buscar_un_parametro
end type
end forward

global type w_buscar_un_parametro from w_base_buscar_lista
integer width = 1257
integer height = 524
string title = "Buscar Dato"
boolean controlmenu = true
em_parametro em_parametro
st_1 st_1
end type
global w_buscar_un_parametro w_buscar_un_parametro

on w_buscar_un_parametro.create
int iCurrent
call super::create
this.em_parametro=create em_parametro
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_parametro
this.Control[iCurrent+2]=this.st_1
end on

on w_buscar_un_parametro.destroy
call super::destroy
destroy(this.em_parametro)
destroy(this.st_1)
end on

event open;//no
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_un_parametro
boolean visible = false
integer x = 197
integer y = 496
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_un_parametro
integer x = 709
integer y = 260
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_un_parametro
integer x = 151
integer y = 260
integer taborder = 20
end type

event pb_aceptar::clicked;call super::clicked;//valida si se ingreso algun criterio de busqueda, en caso contrario, le 
//asigna valores a cada variable para traer toda la informacion.
//Angela Nore$$HEX1$$f100$$ENDHEX$$a oct/2006

Long ll_numerio

s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = True


ll_numerio	= LONG(em_parametro.Text)

lstr_parametros.entero[1] = ll_numerio

CloseWithReturn ( Parent, lstr_parametros )
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_un_parametro
boolean visible = false
integer y = 396
integer height = 188
integer taborder = 40
end type

type em_parametro from editmask within w_buscar_un_parametro
integer x = 686
integer y = 72
integer width = 425
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type st_1 from statictext within w_buscar_un_parametro
integer x = 82
integer y = 92
integer width = 599
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese El N$$HEX1$$fa00$$ENDHEX$$mero:"
boolean focusrectangle = false
end type

