HA$PBExportHeader$w_buscar_espaciosxoc.srw
forward
global type w_buscar_espaciosxoc from w_base_buscar_lista_parametro
end type
end forward

global type w_buscar_espaciosxoc from w_base_buscar_lista_parametro
integer width = 1509
integer height = 1492
end type
global w_buscar_espaciosxoc w_buscar_espaciosxoc

on w_buscar_espaciosxoc.create
call super::create
end on

on w_buscar_espaciosxoc.destroy
call super::destroy
end on

event open;call super::open;width=1509
height=1492
end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_espaciosxoc
integer width = 352
string text = "Orden de Corte:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_espaciosxoc
integer x = 389
integer width = 315
maskdatatype maskdatatype = numericmask!
string mask = "######"
end type

event em_dato::modified;Long ll_numero_registros, ll_ordencorte
n_cts_ocfabrica luo_oc

ll_ordencorte = Long(em_dato.Text)
IF Not IsNull(ll_ordencorte) THEN
	//antes de recuperar los datos se verifica que la orden de corte si sea de la fabrica que estan trabajando
	//jcrm
	//junio 5 de 2007
//	IF luo_oc.of_validarocfabrica(ll_ordencorte) = -1 THEN
//		Return
//	END IF
	
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

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_espaciosxoc
integer x = 146
integer y = 1120
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_espaciosxoc
integer x = 736
integer y = 1232
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_espaciosxoc
integer x = 178
integer y = 1232
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1] = dw_lista.getitemnumber(il_fila_actual, "cs_orden_corte")
	lstr_parametros.entero[2] = dw_lista.getitemnumber(il_fila_actual, "cs_agrupacion")
	lstr_parametros.entero[3] = dw_lista.getitemnumber(il_fila_actual, "cs_base_trazos")
	lstr_parametros.entero[4] = dw_lista.getitemnumber(il_fila_actual, "cs_trazo")
	lstr_parametros.entero[5] = dw_lista.getitemnumber(il_fila_actual, "cs_liquidacion")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_espaciosxoc
integer x = 14
integer height = 920
string dataobject = "dtb_buscar_espacios_xoc"
end type

