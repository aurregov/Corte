HA$PBExportHeader$w_seleccionar_equivalencia_vta.srw
forward
global type w_seleccionar_equivalencia_vta from w_base_buscar_lista
end type
type st_1 from statictext within w_seleccionar_equivalencia_vta
end type
type st_4 from statictext within w_seleccionar_equivalencia_vta
end type
type st_2 from statictext within w_seleccionar_equivalencia_vta
end type
type st_3 from statictext within w_seleccionar_equivalencia_vta
end type
type st_5 from statictext within w_seleccionar_equivalencia_vta
end type
type st_6 from statictext within w_seleccionar_equivalencia_vta
end type
type st_7 from statictext within w_seleccionar_equivalencia_vta
end type
type st_8 from statictext within w_seleccionar_equivalencia_vta
end type
type st_9 from statictext within w_seleccionar_equivalencia_vta
end type
type st_10 from statictext within w_seleccionar_equivalencia_vta
end type
end forward

global type w_seleccionar_equivalencia_vta from w_base_buscar_lista
integer width = 2651
integer height = 1112
string title = "Seleccionar Equivalencia Referencia de Venta"
st_1 st_1
st_4 st_4
st_2 st_2
st_3 st_3
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
end type
global w_seleccionar_equivalencia_vta w_seleccionar_equivalencia_vta

event open;//	Carga la seguridad para esta ventana
//This.wf_validar_seguridad()

dw_lista.settransobject(SQLCA)

s_base_parametros lstr_parametros_env

lstr_parametros_env = Message.PowerObjectParm


If IsValid(lstr_parametros_env) Then
	lstr_parametros_env.ds_datos[1].RowsCopy(1, &
       lstr_parametros_env.ds_datos[1].RowCount(), Primary!, dw_lista, 1, Primary!)
		 
	st_6.text = lstr_parametros_env.cadena[1]	
	st_7.text = lstr_parametros_env.cadena[2]
	st_8.text = lstr_parametros_env.cadena[3]	
	st_9.text = lstr_parametros_env.cadena[4]
	st_10.text = lstr_parametros_env.cadena[5]
	
	dw_lista.modify("dw_lista.readonly=yes")	
End if
end event

on w_seleccionar_equivalencia_vta.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_4=create st_4
this.st_2=create st_2
this.st_3=create st_3
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.st_8
this.Control[iCurrent+9]=this.st_9
this.Control[iCurrent+10]=this.st_10
end on

on w_seleccionar_equivalencia_vta.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
end on

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_equivalencia_vta
integer x = 800
integer y = 772
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_equivalencia_vta
integer x = 1399
integer y = 884
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_equivalencia_vta
integer x = 841
integer y = 884
end type

event pb_aceptar::clicked;call super::clicked;
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(il_fila_actual,'co_fabrica_exp')
	lstr_parametros.entero[2] = dw_lista.GetItemNumber(il_fila_actual,'co_linea_exp')
	lstr_parametros.cadena[1] = dw_lista.GetItemString(il_fila_actual,'co_ref_exp')
	lstr_parametros.cadena[2] = dw_lista.GetItemString(il_fila_actual,'co_talla_exp')
	lstr_parametros.cadena[3] = dw_lista.GetItemString(il_fila_actual,'co_color_exp')
	
	CloseWithReturn(Parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(Parent,lstr_parametros)
END IF
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_equivalencia_vta
integer y = 152
integer width = 2546
integer height = 564
string dataobject = "d_gr_equivalencia_referencia_nal"
end type

type st_1 from statictext within w_seleccionar_equivalencia_vta
integer x = 59
integer y = 36
integer width = 146
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fab: "
boolean focusrectangle = false
end type

type st_4 from statictext within w_seleccionar_equivalencia_vta
integer x = 1367
integer y = 36
integer width = 151
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Talla:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_seleccionar_equivalencia_vta
integer x = 416
integer y = 36
integer width = 151
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "linea: "
boolean focusrectangle = false
end type

type st_3 from statictext within w_seleccionar_equivalencia_vta
integer x = 736
integer y = 36
integer width = 320
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencia: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_seleccionar_equivalencia_vta
integer x = 1760
integer y = 36
integer width = 146
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Color:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_seleccionar_equivalencia_vta
integer x = 219
integer y = 36
integer width = 119
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
boolean focusrectangle = false
end type

type st_7 from statictext within w_seleccionar_equivalencia_vta
integer x = 567
integer y = 36
integer width = 119
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
boolean focusrectangle = false
end type

type st_8 from statictext within w_seleccionar_equivalencia_vta
integer x = 1070
integer y = 36
integer width = 251
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
boolean focusrectangle = false
end type

type st_9 from statictext within w_seleccionar_equivalencia_vta
integer x = 1559
integer y = 36
integer width = 119
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
boolean focusrectangle = false
end type

type st_10 from statictext within w_seleccionar_equivalencia_vta
integer x = 1938
integer y = 36
integer width = 133
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
boolean focusrectangle = false
end type

