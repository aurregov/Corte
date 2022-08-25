HA$PBExportHeader$w_seleccionar_equivalencia_prod.srw
forward
global type w_seleccionar_equivalencia_prod from w_base_buscar_lista
end type
type st_1 from statictext within w_seleccionar_equivalencia_prod
end type
type st_2 from statictext within w_seleccionar_equivalencia_prod
end type
type st_3 from statictext within w_seleccionar_equivalencia_prod
end type
type st_4 from statictext within w_seleccionar_equivalencia_prod
end type
type st_5 from statictext within w_seleccionar_equivalencia_prod
end type
type st_6 from statictext within w_seleccionar_equivalencia_prod
end type
end forward

global type w_seleccionar_equivalencia_prod from w_base_buscar_lista
integer width = 2729
integer height = 1084
string title = "Selccionar Equivalencia Referencia de Produccion"
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
end type
global w_seleccionar_equivalencia_prod w_seleccionar_equivalencia_prod

event open;//	Carga la seguridad para esta ventana
//This.wf_validar_seguridad()

dw_lista.settransobject(SQLCA)

s_base_parametros lstr_parametros_env

lstr_parametros_env = Message.PowerObjectParm


If IsValid(lstr_parametros_env) Then
	lstr_parametros_env.ds_datos[1].RowsCopy(1, &
       lstr_parametros_env.ds_datos[1].RowCount(), Primary!, dw_lista, 1, Primary!)
	st_2.text = lstr_parametros_env.cadena[1]	
	st_4.text = lstr_parametros_env.cadena[2]
	st_6.text = lstr_parametros_env.cadena[3]
End if
end event

on w_seleccionar_equivalencia_prod.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_6
end on

on w_seleccionar_equivalencia_prod.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
end on

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_equivalencia_prod
integer y = 728
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_equivalencia_prod
integer y = 840
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_equivalencia_prod
integer y = 840
end type

event pb_aceptar::clicked;call super::clicked;
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_linea")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
	lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"co_talla")
	lstr_parametros.entero[5]=dw_lista.getitemnumber(il_fila_actual,"co_calidad")
	lstr_parametros.entero[6]=dw_lista.getitemnumber(il_fila_actual,"co_color")
	
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_equivalencia_prod
integer y = 108
integer width = 2638
integer height = 564
string dataobject = "d_gr_equivalencias_x_sku_exp"
end type

type st_1 from statictext within w_seleccionar_equivalencia_prod
integer x = 55
integer y = 36
integer width = 265
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ref Exp: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_seleccionar_equivalencia_prod
integer x = 352
integer y = 36
integer width = 457
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
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_seleccionar_equivalencia_prod
integer x = 869
integer y = 36
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Talla Exp:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_seleccionar_equivalencia_prod
integer x = 1120
integer y = 36
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_seleccionar_equivalencia_prod
integer x = 1481
integer y = 36
integer width = 247
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Color Exp:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_seleccionar_equivalencia_prod
integer x = 1728
integer y = 36
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

