HA$PBExportHeader$w_buscar_inventario.srw
forward
global type w_buscar_inventario from w_base_buscar_lista_parametro
end type
type st_2 from statictext within w_buscar_inventario
end type
type st_3 from statictext within w_buscar_inventario
end type
type st_4 from statictext within w_buscar_inventario
end type
type sle_transaccion from singlelineedit within w_buscar_inventario
end type
type sle_ruta from singlelineedit within w_buscar_inventario
end type
type sle_movimiento from singlelineedit within w_buscar_inventario
end type
type cb_1 from commandbutton within w_buscar_inventario
end type
end forward

global type w_buscar_inventario from w_base_buscar_lista_parametro
integer width = 2601
integer height = 2032
st_2 st_2
st_3 st_3
st_4 st_4
sle_transaccion sle_transaccion
sle_ruta sle_ruta
sle_movimiento sle_movimiento
cb_1 cb_1
end type
global w_buscar_inventario w_buscar_inventario

on w_buscar_inventario.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.sle_transaccion=create sle_transaccion
this.sle_ruta=create sle_ruta
this.sle_movimiento=create sle_movimiento
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_transaccion
this.Control[iCurrent+5]=this.sle_ruta
this.Control[iCurrent+6]=this.sle_movimiento
this.Control[iCurrent+7]=this.cb_1
end on

on w_buscar_inventario.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_transaccion)
destroy(this.sle_ruta)
destroy(this.sle_movimiento)
destroy(this.cb_1)
end on

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_inventario
integer width = 210
string text = "A$$HEX1$$f100$$ENDHEX$$o-mes:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_inventario
integer x = 238
integer width = 329
integer height = 80
string mask = ""
end type

event em_dato::modified;//override
end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_inventario
integer x = 553
integer y = 1596
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_inventario
integer x = 1079
integer y = 1716
integer taborder = 70
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_inventario
integer x = 521
integer y = 1716
integer taborder = 60
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.fechahora[1]=dw_lista.getitemdatetime(il_fila_actual,"ano_mes")
	lstr_parametros.fechahora[2]=dw_lista.getitemdatetime(il_fila_actual,"fe_movimiento")
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_transaccion")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_ruta_etapa")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"cs_dato")
	lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"cs_movimiento")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_inventario
integer x = 0
integer y = 288
integer width = 2533
integer height = 1284
integer taborder = 50
string dataobject = "dtb_buscar_movimientos"
end type

type st_2 from statictext within w_buscar_inventario
integer x = 640
integer y = 60
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
string text = "Transacci$$HEX1$$f300$$ENDHEX$$n:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_buscar_inventario
integer x = 50
integer y = 200
integer width = 146
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
string text = "Ruta:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_buscar_inventario
integer x = 640
integer y = 204
integer width = 329
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
string text = "Movimiento #:"
boolean focusrectangle = false
end type

type sle_transaccion from singlelineedit within w_buscar_inventario
integer x = 1010
integer y = 52
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
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type sle_ruta from singlelineedit within w_buscar_inventario
integer x = 242
integer y = 176
integer width = 343
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type sle_movimiento from singlelineedit within w_buscar_inventario
integer x = 1006
integer y = 176
integer width = 343
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_buscar_inventario
integer x = 1810
integer y = 84
integer width = 343
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
end type

event clicked;String ls_datocon,ldt_ano_mes
Long ll_numero_registros
//datetime	ldt_ano_mes
Long  li_co_transaccion,li_co_ruta_etapa,li_cs_movimiento

ldt_ano_mes= (em_dato.Text)
li_co_transaccion=Long(sle_transaccion.text)
li_co_ruta_etapa=Long(sle_ruta.text)
li_cs_movimiento=Long(sle_movimiento.text)
IF Not IsNull(ldt_ano_mes) THEN
	//ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(ldt_ano_mes,li_co_transaccion,li_co_ruta_etapa,li_cs_movimiento)
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

