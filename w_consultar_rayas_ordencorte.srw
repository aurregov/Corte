HA$PBExportHeader$w_consultar_rayas_ordencorte.srw
forward
global type w_consultar_rayas_ordencorte from w_base_buscar_lista_parametro
end type
end forward

global type w_consultar_rayas_ordencorte from w_base_buscar_lista_parametro
integer width = 2267
string title = "Consulta Rayas Orden Corte"
end type
global w_consultar_rayas_ordencorte w_consultar_rayas_ordencorte

on w_consultar_rayas_ordencorte.create
call super::create
end on

on w_consultar_rayas_ordencorte.destroy
call super::destroy
end on

type st_1 from w_base_buscar_lista_parametro`st_1 within w_consultar_rayas_ordencorte
integer y = 24
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_consultar_rayas_ordencorte
integer y = 24
string mask = "######"
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

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_consultar_rayas_ordencorte
integer x = 27
integer y = 900
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_consultar_rayas_ordencorte
integer x = 1856
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_consultar_rayas_ordencorte
integer x = 1440
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1] = dw_lista.getitemnumber(il_fila_actual, "cs_orden_corte")
	lstr_parametros.entero[2] = dw_lista.getitemnumber(il_fila_actual, "cs_agrupacion")
	lstr_parametros.entero[3] = dw_lista.getitemnumber(il_fila_actual, "cs_base_trazos")
	lstr_parametros.entero[4] = dw_lista.getitemnumber(il_fila_actual, "raya")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_consultar_rayas_ordencorte
integer y = 124
integer width = 2194
integer height = 712
string dataobject = "dtb_consulta_rayas_ordecorte"
end type

