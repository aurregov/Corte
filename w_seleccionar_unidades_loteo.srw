HA$PBExportHeader$w_seleccionar_unidades_loteo.srw
forward
global type w_seleccionar_unidades_loteo from w_base_buscar_lista
end type
end forward

global type w_seleccionar_unidades_loteo from w_base_buscar_lista
integer width = 2834
integer height = 1076
end type
global w_seleccionar_unidades_loteo w_seleccionar_unidades_loteo

type variables
Long il_orden_corte
Long ii_lote
Boolean ib_seleccion
end variables

on w_seleccionar_unidades_loteo.create
call super::create
end on

on w_seleccionar_unidades_loteo.destroy
call super::destroy
end on

event open;long ll_numero_registros
s_base_parametros lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	il_orden_corte = lstr_parametros.entero[1]
	ii_lote = lstr_parametros.entero[2]
	ll_numero_registros = dw_lista.retrieve(il_orden_corte, ii_lote)
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

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_unidades_loteo
integer x = 32
integer y = 864
integer width = 814
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_unidades_loteo
integer x = 2432
integer y = 828
end type

event pb_cancelar::clicked;Close(Parent)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_unidades_loteo
integer x = 2030
integer y = 828
end type

event pb_aceptar::clicked;call super::clicked;Long li_filas, li_fila_actual
Long ll_agrupacion, ll_produccion, ll_unidades
Long li_talla

li_filas = dw_lista.RowCount()
FOR li_fila_actual = 1 TO li_filas 
	IF dw_lista.IsSelected(li_fila_actual) THEN
		ll_agrupacion = dw_lista.GetItemNumber(li_fila_actual, "cs_agrupacion")
		ll_produccion = dw_lista.GetItemNumber(li_fila_actual, "cs_pdn")
		li_talla = dw_lista.GetItemNumber(li_fila_actual, "co_talla")
		ll_unidades = dw_lista.GetItemNumber(li_fila_actual, "unidades")

		INSERT INTO dt_escalas_reales(cs_orden_corte, cs_parcial, cs_agrupacion, cs_pdn, co_talla, co_calidad,
			ca_loteada, ca_remisionada, fe_creacion, fe_actualizacion, usuario, instancia)
		VALUES(:il_orden_corte, :ii_lote, :ll_agrupacion, :ll_produccion, :li_talla, 1, 
			:ll_unidades, 0, Current, Current, User, SiteName);
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al insertar registro de detalle loteo " + SQLCA.SQLErrText)
			ROLLBACK;
			Return
		END IF
	END IF
NEXT
COMMIT;
Close(Parent)
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_unidades_loteo
integer width = 2770
integer height = 776
string dataobject = "dtb_seleccionar_unidades_loteo"
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

event dw_lista::retrieveend;call super::retrieveend;Long ll_agrupacion, ll_produccion
Long li_rayas, li_liquidadas, li_filas, li_fila_actual

li_filas = RowCount
FOR li_fila_actual = 1 TO li_filas
	ll_agrupacion = This.GetItemNumber(li_fila_actual, "cs_agrupacion")
	ll_produccion = This.GetItemNumber(li_fila_actual, "cs_pdn")
	
	SELECT Count(*)
	INTO :li_rayas
	FROM dt_rayas_telaxoc
	WHERE cs_orden_corte = :il_orden_corte AND
			cs_agrupacion = :ll_agrupacion AND
			cs_pdn = :ll_produccion;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al consultar las rayas de la producci$$HEX1$$f300$$ENDHEX$$n")
		Return(1)
	END IF
	SELECT Count(*)
	INTO :li_liquidadas
	FROM dt_rayas_telaxoc
	WHERE cs_orden_corte = :il_orden_corte AND
			cs_agrupacion = :ll_agrupacion AND
			cs_pdn = :ll_produccion AND
			co_estado in (5, 6);
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al consultar las rayas liquidadas de la producci$$HEX1$$f300$$ENDHEX$$n")
		Return(1)
	END IF
	IF li_rayas > li_liquidadas THEN
		This.DeleteRow(li_fila_actual)
	END IF
NEXT
end event

event dw_lista::rbuttondown;call super::rbuttondown;IF ib_seleccion THEN
	ib_seleccion = False
	This.SelectRow(0, False)
ELSE
	ib_seleccion = True
	This.SelectRow(0, True)
END IF
end event

