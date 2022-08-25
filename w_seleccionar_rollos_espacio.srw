HA$PBExportHeader$w_seleccionar_rollos_espacio.srw
forward
global type w_seleccionar_rollos_espacio from w_base_buscar_lista
end type
type st_1 from statictext within w_seleccionar_rollos_espacio
end type
type em_total_kgs from editmask within w_seleccionar_rollos_espacio
end type
end forward

global type w_seleccionar_rollos_espacio from w_base_buscar_lista
integer width = 2400
integer height = 976
st_1 st_1
em_total_kgs em_total_kgs
end type
global w_seleccionar_rollos_espacio w_seleccionar_rollos_espacio

on w_seleccionar_rollos_espacio.create
int iCurrent
call super::create
this.st_1=create st_1
this.em_total_kgs=create em_total_kgs
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_total_kgs
end on

on w_seleccionar_rollos_espacio.destroy
call super::destroy
destroy(this.st_1)
destroy(this.em_total_kgs)
end on

event open;long ll_numero_registros, ll_ordencorte, ll_agrupacion, ll_basetrazo
Long li_liquidacion
s_base_parametros lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	ll_ordencorte = lstr_parametros.entero[1]
	ll_agrupacion = lstr_parametros.entero[2]
	ll_basetrazo = lstr_parametros.entero[3]
	li_liquidacion = lstr_parametros.entero[4]
	ll_numero_registros = dw_lista.retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, li_liquidacion)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			il_fila_actual = 1
	END CHOOSE
END IF
dw_lista.SetRowFocusIndicator (Off!)
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_rollos_espacio
boolean visible = false
integer x = 27
integer y = 768
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_rollos_espacio
integer x = 1851
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_rollos_espacio
integer x = 1467
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados
s_base_parametros lstr_parametros

ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_filaactual) THEN
		ll_insertados = ll_insertados + 1		
		lstr_parametros.entero[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "cs_rollo")
		lstr_parametros.decimal[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_disponible")
	END If
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros.entero[1] = ll_insertados
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False	
END IF

CloseWithReturn(Parent, lstr_parametros)

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_rollos_espacio
integer width = 2327
integer height = 684
string dataobject = "dtb_seleccionar_rollos_espacio"
end type

event dw_lista::clicked;Decimal{2} ld_disponible, ld_total

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	ld_total = Dec(em_total_kgs.Text)
	IF this.IsSelected(Row) THEN
		This.SelectRow(Row, False)
		ld_disponible = This.GetItemNumber(Row, "ca_disponible")
		ld_total = ld_total - ld_disponible
	ELSE
		This.SelectRow(Row, True)
		ld_disponible = This.GetItemNumber(Row, "ca_disponible")
		ld_total = ld_total + ld_disponible
	END IF
	em_total_kgs.Text = String(ld_total, "###,###.00")
END IF
end event

event dw_lista::doubleclicked;//Se omite el script
end event

event dw_lista::rowfocuschanged;//Se omite el script
end event

type st_1 from statictext within w_seleccionar_rollos_espacio
integer x = 37
integer y = 784
integer width = 654
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 12632256
string text = "Total Rollos Seleccionados:"
boolean focusrectangle = false
end type

type em_total_kgs from editmask within w_seleccionar_rollos_espacio
integer x = 681
integer y = 772
integer width = 357
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 65535
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "###,###.00"
end type

