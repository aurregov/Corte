HA$PBExportHeader$w_seleccionar_unidades_liquidacion.srw
forward
global type w_seleccionar_unidades_liquidacion from w_base_buscar_lista
end type
end forward

global type w_seleccionar_unidades_liquidacion from w_base_buscar_lista
integer x = 1111
integer y = 452
integer width = 2071
integer height = 968
string title = "Seleccionar Unidades"
end type
global w_seleccionar_unidades_liquidacion w_seleccionar_unidades_liquidacion

type variables
Long il_orden_corte, il_modelo, il_trazo, il_reftel, il_agrupacion, il_colorte
Long ii_seccion, ii_fabrica, ii_caract, ii_diametro, ii_liquidacion
Long ii_produccion, ii_base
Boolean ib_seleccion
end variables

on w_seleccionar_unidades_liquidacion.create
call super::create
end on

on w_seleccionar_unidades_liquidacion.destroy
call super::destroy
end on

event open;Long ll_numero_registros
s_base_parametros lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	il_orden_corte = lstr_parametros.entero[1]
	il_agrupacion = lstr_parametros.entero[2]
	ii_produccion = lstr_parametros.entero[3]
	il_modelo = lstr_parametros.entero[4]
	ii_fabrica = lstr_parametros.entero[5]
	il_reftel = lstr_parametros.entero[6]
	ii_caract = lstr_parametros.entero[7]
	ii_diametro = lstr_parametros.entero[8]
	il_colorte = lstr_parametros.entero[9]
	il_trazo = lstr_parametros.entero[10]
	ii_seccion = lstr_parametros.entero[11]	
	ii_base = lstr_parametros.entero[12]	
	ii_liquidacion = lstr_parametros.entero[13]	
	ll_numero_registros = dw_lista.retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
			ii_fabrica, il_reftel, ii_caract, ii_diametro, il_colorte, il_trazo, ii_seccion, ii_base, ii_liquidacion)
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
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_unidades_liquidacion
integer x = 32
integer y = 752
integer width = 887
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_unidades_liquidacion
integer x = 1673
integer y = 712
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_unidades_liquidacion
integer x = 1280
integer y = 712
end type

event pb_aceptar::clicked;Long ll_filas, ll_fila_actual
Long li_talla, li_paquetes, li_unidades, li_tipo, li_sectalla
Decimal{3} ld_capas

ll_filas = dw_lista.RowCount()
FOR ll_fila_actual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_fila_actual) THEN
		li_talla = dw_lista.GetItemNumber(ll_fila_actual, "co_talla")
		li_sectalla = dw_lista.GetItemNumber(ll_fila_actual, "cs_talla")
		li_paquetes = dw_lista.GetItemNumber(ll_fila_actual, "paquetes")
		ld_capas = dw_lista.GetItemNumber(ll_fila_actual, "capas")
		li_unidades = dw_lista.GetItemNumber(ll_fila_actual, "pendiente")
		INSERT INTO dt_escalas_liq(cs_orden_corte, cs_agrupacion, cs_pdn, co_modelo, co_fabrica_tela, 
			co_reftel, co_caract, diametro, co_color_te, cs_trazo, cs_seccion, cs_liquidacion, 
			co_talla, cs_base_trazos, cs_talla, capas, paquetes, ca_liquidadas, ca_loteadas, fe_creacion, fe_actualizacion, 
			usuario, instancia)
		VALUES(:il_orden_corte, :il_agrupacion, :ii_produccion, :il_modelo, :ii_fabrica, :il_reftel, 
			:ii_caract, :ii_diametro, :il_colorte, :il_trazo, :ii_seccion, :ii_liquidacion, 
			:li_talla, :ii_base, :li_sectalla, :ld_capas, :li_paquetes, :li_unidades, 0, Current, Current, 
				:gstr_info_usuario.codigo_usuario, :gstr_info_usuario.instancia);
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al insertar registro en liquidaci$$HEX1$$f300$$ENDHEX$$n rollos " + SQLCA.SQLErrText)
			ROLLBACK;
			Return
		END IF
	END IF
NEXT
COMMIT;
Close(Parent)
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_unidades_liquidacion
integer width = 2007
integer height = 660
string dataobject = "dtb_seleccionar_unidades_trazo"
boolean hscrollbar = false
borderstyle borderstyle = stylebox!
end type

event dw_lista::clicked;// Se omite el script
end event

event dw_lista::doubleclicked;// Se omite el script
end event

event dw_lista::rowfocuschanged;il_fila_actual=this.getrow()
IF This.IsSelected(il_fila_actual) THEN
	this.selectrow(il_fila_actual,false)
ELSE
	this.selectrow(il_fila_actual,true)
END IF
end event

event dw_lista::rbuttondown;call super::rbuttondown;IF ib_seleccion THEN
	ib_seleccion = False
	This.SelectRow(0, False)
ELSE
	ib_seleccion = True
	This.SelectRow(0, True)
END IF
end event

