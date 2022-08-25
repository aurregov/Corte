HA$PBExportHeader$w_seleccionar_espacio.srw
forward
global type w_seleccionar_espacio from w_base_buscar_lista
end type
end forward

global type w_seleccionar_espacio from w_base_buscar_lista
integer x = 1111
integer y = 452
integer width = 1915
integer height = 968
string title = "Seleccionar Unidades"
end type
global w_seleccionar_espacio w_seleccionar_espacio

type variables
Long il_orden_corte, il_agrupacion
Long ii_liquidacion, ii_base
Boolean ib_seleccion
end variables

on w_seleccionar_espacio.create
call super::create
end on

on w_seleccionar_espacio.destroy
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
	ii_base = lstr_parametros.entero[3]	
	ii_liquidacion = lstr_parametros.entero[4]	
	ll_numero_registros = dw_lista.retrieve(il_orden_corte, il_agrupacion, ii_base, ii_liquidacion)
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

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_espacio
integer x = 32
integer y = 752
integer width = 1047
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_espacio
integer x = 1513
integer y = 712
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_espacio
integer x = 1120
integer y = 712
end type

event pb_aceptar::clicked;Long ll_filas, ll_fila_actual
Long li_trazo, li_selecciones
s_base_parametros lstr_parametros

ll_filas = dw_lista.RowCount()
li_selecciones = 0
FOR ll_fila_actual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_fila_actual) THEN
		li_trazo = dw_lista.GetItemNumber(ll_fila_actual, "cs_trazo")
		li_selecciones = li_selecciones + 1
		lstr_parametros.entero[li_selecciones + 1] = li_trazo
	END IF
NEXT
IF li_selecciones > 0 THEN
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False
END IF
lstr_parametros.entero[1] = li_selecciones
CloseWithReturn(Parent, lstr_parametros)
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_espacio
integer width = 1851
integer height = 660
string dataobject = "dtb_seleccionar_espacio"
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

