HA$PBExportHeader$w_consultar_trazos2.srw
forward
global type w_consultar_trazos2 from w_base_buscar_lista_parametro
end type
end forward

global type w_consultar_trazos2 from w_base_buscar_lista_parametro
integer x = 407
integer y = 612
integer width = 3255
integer height = 1204
string title = "Seleccionar Trazos por Orden Corte"
end type
global w_consultar_trazos2 w_consultar_trazos2

type variables

end variables

on w_consultar_trazos2.create
call super::create
end on

on w_consultar_trazos2.destroy
call super::destroy
end on

type st_1 from w_base_buscar_lista_parametro`st_1 within w_consultar_trazos2
integer x = 23
integer y = 20
integer width = 279
boolean enabled = true
string text = "Orden corte:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_consultar_trazos2
integer x = 302
integer y = 20
integer width = 357
maskdatatype maskdatatype = numericmask!
string mask = "###########"
end type

event em_dato::modified;Long ll_numero_registros, ll_ordencorte


ll_ordencorte = Long(em_dato.Text)
IF Not IsNull(ll_ordencorte) THEN
	ll_numero_registros = dw_lista.Retrieve(ll_ordencorte)
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

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_consultar_trazos2
integer x = 27
integer y = 956
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_consultar_trazos2
integer x = 2505
integer y = 924
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_consultar_trazos2
integer x = 2112
integer y = 924
boolean default = false
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1] = dw_lista.getitemnumber(il_fila_actual,"cs_orden_corte")
	lstr_parametros.entero[2] = dw_lista.getitemnumber(il_fila_actual,"cs_agrupacion")
	lstr_parametros.entero[3] = dw_lista.getitemnumber(il_fila_actual,"cs_pdn")
	lstr_parametros.entero[4] = dw_lista.getitemnumber(il_fila_actual,"co_modelo")
	lstr_parametros.entero[5] = dw_lista.getitemnumber(il_fila_actual,"co_fabrica_tela")
	lstr_parametros.entero[6] = dw_lista.getitemnumber(il_fila_actual,"co_reftel")
	lstr_parametros.entero[7] = dw_lista.getitemnumber(il_fila_actual,"co_caract")
	lstr_parametros.entero[8] = dw_lista.getitemnumber(il_fila_actual,"diametro")
	lstr_parametros.entero[9] = dw_lista.getitemnumber(il_fila_actual,"co_color_te")
	lstr_parametros.entero[10] = dw_lista.getitemnumber(il_fila_actual,"cs_trazo")
	lstr_parametros.entero[11] = dw_lista.getitemnumber(il_fila_actual,"cs_seccion")
	lstr_parametros.entero[12] = dw_lista.getitemnumber(il_fila_actual,"cs_base_trazos")	
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF
end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_consultar_trazos2
integer x = 23
integer y = 116
integer width = 3205
integer height = 788
string dataobject = "dtb_unidades_liquidacion_trazos_xespacio"
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

