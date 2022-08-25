HA$PBExportHeader$w_buscar_ficha_pt.srw
forward
global type w_buscar_ficha_pt from w_base_buscar_lista
end type
type em_dato from editmask within w_buscar_ficha_pt
end type
type st_1 from statictext within w_buscar_ficha_pt
end type
end forward

global type w_buscar_ficha_pt from w_base_buscar_lista
integer x = 197
integer y = 452
integer width = 2450
integer height = 1024
string title = "Buscar Ficha Producto Terminado"
em_dato em_dato
st_1 st_1
end type
global w_buscar_ficha_pt w_buscar_ficha_pt

on w_buscar_ficha_pt.create
int iCurrent
call super::create
this.em_dato=create em_dato
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_dato
this.Control[iCurrent+2]=this.st_1
end on

on w_buscar_ficha_pt.destroy
call super::destroy
destroy(this.em_dato)
destroy(this.st_1)
end on

event open;long ll_numero_registros


IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
END IF
dw_lista.SetRowFocusIndicator (hand!)
dw_lista.modify("dw_lista.readonly=yes")


end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_ficha_pt
integer y = 800
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_ficha_pt
integer x = 1870
integer y = 764
integer taborder = 40
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_ficha_pt
integer x = 1312
integer y = 764
integer taborder = 30
end type

event pb_aceptar::clicked;call super::clicked;///////////////////////////////////////////////////////////////////
// En este evento se le asigna al campo entero de la estructura 
// s_base_parametros el contenido del campo clave de la fila actual.
///////////////////////////////////////////////////////////////////
//
s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_linea")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
	lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"co_talla")
	lstr_parametros.entero[5]=dw_lista.getitemnumber(il_fila_actual,"co_calidad")
	lstr_parametros.entero[6]=dw_lista.getitemnumber(il_fila_actual,"co_color_pt")

	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_ficha_pt
integer y = 148
integer width = 2373
string dataobject = "dtb_h_ficha_pt"
end type

type em_dato from editmask within w_buscar_ficha_pt
integer x = 242
integer y = 44
integer width = 896
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
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
end type

event modified;String ls_datocon
Long ll_numero_registros


ls_datocon = em_dato.Text
IF Not IsNull(ls_datocon) THEN
	ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(ls_datocon)
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

type st_1 from statictext within w_buscar_ficha_pt
integer x = 32
integer y = 44
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
string text = "Buscar:"
boolean focusrectangle = false
end type

