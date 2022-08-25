HA$PBExportHeader$w_seleccionar_tallasordencorte_mardila.srw
forward
global type w_seleccionar_tallasordencorte_mardila from w_base_buscar_lista
end type
end forward

global type w_seleccionar_tallasordencorte_mardila from w_base_buscar_lista
integer x = 1184
integer y = 388
integer width = 1225
integer height = 1408
string title = "Seleccione TALLAS...-"
end type
global w_seleccionar_tallasordencorte_mardila w_seleccionar_tallasordencorte_mardila

on w_seleccionar_tallasordencorte_mardila.create
call super::create
end on

on w_seleccionar_tallasordencorte_mardila.destroy
call super::destroy
end on

event open;Long ll_fabrica, ll_linea, ll_referencia
Long ll_numero_registros
s_base_parametros_seleccionar lstr_parametros

lstr_parametros = Message.PowerObjectParm

ll_fabrica		=	lstr_parametros.entero1[2]
ll_linea			=	lstr_parametros.entero1[3]
ll_referencia	=	lstr_parametros.entero1[4]

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE

	ll_numero_registros = dw_lista.retrieve(ll_fabrica, ll_linea, ll_referencia)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
//			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			il_fila_actual = 1
	END CHOOSE
END IF
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_tallasordencorte_mardila
integer x = 27
integer y = 1216
integer width = 731
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_tallasordencorte_mardila
integer x = 859
integer y = 208
integer width = 347
string picturename = "cancelar.bmp"
end type

event pb_cancelar::clicked;
s_base_parametros_seleccionar lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_tallasordencorte_mardila
integer x = 859
integer y = 32
integer width = 347
string picturename = "ok.bmp"
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados
s_base_parametros_seleccionar lstr_parametros

ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_filaactual) THEN
		ll_insertados = ll_insertados + 1		
		lstr_parametros.entero1[ll_insertados] = Long(dw_lista.GetItemString(ll_filaactual, "co_talla"))
	END IF
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros.entero1[1] = ll_insertados
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False
END IF

CloseWithReturn(Parent, lstr_parametros)

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_tallasordencorte_mardila
integer x = 37
integer y = 36
integer width = 832
integer height = 1164
string dataobject = "dtb_seleccionar_talla_mardila"
boolean hscrollbar = false
end type

event dw_lista::clicked;IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	IF dw_lista.IsSelected(row) THEN
		this.selectrow(row, False)
	ELSE
		this.selectrow(row, True)		
	END IF
END IF
end event

event dw_lista::rowfocuschanged;// Se omite el script
end event

