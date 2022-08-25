HA$PBExportHeader$w_buscar_moduloxsimulacion.srw
forward
global type w_buscar_moduloxsimulacion from w_base_buscar_lista_parametro
end type
type st_2 from statictext within w_buscar_moduloxsimulacion
end type
type st_3 from statictext within w_buscar_moduloxsimulacion
end type
type em_planta from editmask within w_buscar_moduloxsimulacion
end type
type em_modulo from editmask within w_buscar_moduloxsimulacion
end type
type st_4 from statictext within w_buscar_moduloxsimulacion
end type
type st_5 from statictext within w_buscar_moduloxsimulacion
end type
type st_6 from statictext within w_buscar_moduloxsimulacion
end type
type sle_simulacion from singlelineedit within w_buscar_moduloxsimulacion
end type
type cbx_1 from checkbox within w_buscar_moduloxsimulacion
end type
end forward

global type w_buscar_moduloxsimulacion from w_base_buscar_lista_parametro
integer x = 91
integer y = 288
integer width = 3383
integer height = 1992
st_2 st_2
st_3 st_3
em_planta em_planta
em_modulo em_modulo
st_4 st_4
st_5 st_5
st_6 st_6
sle_simulacion sle_simulacion
cbx_1 cbx_1
end type
global w_buscar_moduloxsimulacion w_buscar_moduloxsimulacion

on w_buscar_moduloxsimulacion.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.em_planta=create em_planta
this.em_modulo=create em_modulo
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.sle_simulacion=create sle_simulacion
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.em_planta
this.Control[iCurrent+4]=this.em_modulo
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.sle_simulacion
this.Control[iCurrent+9]=this.cbx_1
end on

on w_buscar_moduloxsimulacion.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_planta)
destroy(this.em_modulo)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.sle_simulacion)
destroy(this.cbx_1)
end on

event open;call super::open;em_dato.setfocus()
end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_moduloxsimulacion
integer x = 562
integer y = 88
integer width = 178
string text = "F$$HEX1$$e100$$ENDHEX$$brica:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_moduloxsimulacion
integer x = 759
integer y = 80
integer width = 119
integer taborder = 20
textcase textcase = upper!
string mask = ""
end type

event em_dato::modified;//String ls_datocon
//Long ll_numero_registros
//
//
//ls_datocon = em_dato.Text
//IF Not IsNull(ls_datocon) THEN
//	ls_datocon = ls_datocon + '%'
//	ll_numero_registros = dw_lista.Retrieve(ls_datocon)
//	CHOOSE CASE ll_numero_registros 
//		CASE -1
//			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
//		CASE 0
//			il_fila_actual = 0
//			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
//		CASE ELSE
//			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
//			dw_lista.setrow(1)
//			dw_lista.selectrow(1,true)
//			il_fila_actual = 1
//	END CHOOSE
//END IF
end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_moduloxsimulacion
integer x = 974
integer y = 1632
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_moduloxsimulacion
integer x = 1568
integer y = 1740
integer taborder = 70
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_moduloxsimulacion
integer x = 1010
integer y = 1740
integer taborder = 60
end type

event pb_aceptar::clicked;call super::clicked;///////////////////////////////////////////////////////////////////
// En este evento se le asigna al campo entero de la estructura 
// s_base_parametros el contenido del campo clave de la fila actual.
///////////////////////////////////////////////////////////////////
Long				li_simulacion
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	
	li_simulacion=Long(sle_simulacion.TEXT)
	
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_planta")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_modulo")
	lstr_parametros.entero[4]=li_simulacion
	lstr_parametros.cadena[1]=dw_lista.getitemString(il_fila_actual,"de_modulo")

	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_moduloxsimulacion
integer x = 18
integer y = 280
integer width = 3342
integer height = 1320
integer taborder = 50
string dataobject = "dtb_buscar_modulosxsimulacion"
end type

type st_2 from statictext within w_buscar_moduloxsimulacion
integer x = 910
integer y = 88
integer width = 155
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

type st_3 from statictext within w_buscar_moduloxsimulacion
integer x = 1349
integer y = 88
integer width = 197
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

type em_planta from editmask within w_buscar_moduloxsimulacion
integer x = 1061
integer y = 80
integer width = 247
integer height = 76
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
string mask = "###"
end type

type em_modulo from editmask within w_buscar_moduloxsimulacion
integer x = 1531
integer y = 80
integer width = 247
integer height = 76
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
string mask = "#######"
end type

event modified;String 			ls_datocon
Long 				ll_numero_registros
Long	      li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion

li_co_fabrica_modulo	= Long(em_dato.Text)
li_co_planta_modulo	= Long(em_planta.Text)
li_co_modulo 			= Long(em_modulo.Text)
li_simulacion			= Long(sle_simulacion.Text)
IF (Not IsNull(li_co_fabrica_modulo) ) AND (NOT ISNULL(li_co_planta_modulo) ) AND (NOT ISNULL(li_co_modulo) ) THEN
//	ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			dw_lista.setrow(1)
			dw_lista.selectrow(1,true)
			il_fila_actual = 1
	END CHOOSE
END IF
end event

type st_4 from statictext within w_buscar_moduloxsimulacion
integer x = 2510
integer y = 56
integer width = 649
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
string text = "Nicole: F$$HEX1$$e100$$ENDHEX$$brica [91], Planta[2]"
boolean focusrectangle = false
end type

type st_5 from statictext within w_buscar_moduloxsimulacion
integer x = 2510
integer y = 176
integer width = 658
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
string text = "Incotex:F$$HEX1$$e100$$ENDHEX$$brica[92] , Planta[2]"
boolean focusrectangle = false
end type

type st_6 from statictext within w_buscar_moduloxsimulacion
integer x = 37
integer y = 88
integer width = 256
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
string text = "Simulaci$$HEX1$$f300$$ENDHEX$$n:"
boolean focusrectangle = false
end type

type sle_simulacion from singlelineedit within w_buscar_moduloxsimulacion
integer x = 288
integer y = 80
integer width = 247
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type cbx_1 from checkbox within w_buscar_moduloxsimulacion
integer x = 1966
integer y = 88
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

event clicked;Long	li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo, li_simulacion
LONG		ll_numero_registros

s_base_parametros lstr_parametros

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
				em_dato.text 	=string(lstr_parametros.entero[1])
				em_planta.text	=string(lstr_parametros.entero[2])
				em_modulo.text	=string(lstr_parametros.entero[3])
				
				li_co_fabrica_modulo	= Long(em_dato.Text)
				li_co_planta_modulo	= Long(em_planta.Text)
				li_co_modulo 			= Long(em_modulo.Text)
				li_simulacion			= Long(sle_simulacion.Text)
				IF (Not IsNull(li_co_fabrica_modulo) ) AND (NOT ISNULL(li_co_planta_modulo) ) AND (NOT ISNULL(li_co_modulo) ) THEN
				// Busca Registros
				ll_numero_registros = dw_lista.Retrieve(li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion)
				CHOOSE CASE ll_numero_registros 
					CASE -1
						MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
					CASE 0
						il_fila_actual = 0
						st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
					CASE ELSE
						st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
						dw_lista.setrow(1)
						dw_lista.selectrow(1,true)
						il_fila_actual = 1
				END CHOOSE
				END IF				
	END IF
END IF
RETURN 1

end event

