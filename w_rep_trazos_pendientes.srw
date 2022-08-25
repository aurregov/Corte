HA$PBExportHeader$w_rep_trazos_pendientes.srw
forward
global type w_rep_trazos_pendientes from w_base_tabular
end type
type cb_actualiza from commandbutton within w_rep_trazos_pendientes
end type
type cb_imprimir from commandbutton within w_rep_trazos_pendientes
end type
type st_2 from statictext within w_rep_trazos_pendientes
end type
type em_linea from editmask within w_rep_trazos_pendientes
end type
type cb_buscar from commandbutton within w_rep_trazos_pendientes
end type
type em_puesto from editmask within w_rep_trazos_pendientes
end type
type st_3 from statictext within w_rep_trazos_pendientes
end type
end forward

global type w_rep_trazos_pendientes from w_base_tabular
integer width = 4366
integer height = 2248
string title = "Actualizacion Trazos Pendientes"
cb_actualiza cb_actualiza
cb_imprimir cb_imprimir
st_2 st_2
em_linea em_linea
cb_buscar cb_buscar
em_puesto em_puesto
st_3 st_3
end type
global w_rep_trazos_pendientes w_rep_trazos_pendientes

type variables
Long li_fabrica, li_linea
boolean is_graba
end variables

on w_rep_trazos_pendientes.create
int iCurrent
call super::create
this.cb_actualiza=create cb_actualiza
this.cb_imprimir=create cb_imprimir
this.st_2=create st_2
this.em_linea=create em_linea
this.cb_buscar=create cb_buscar
this.em_puesto=create em_puesto
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_actualiza
this.Control[iCurrent+2]=this.cb_imprimir
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_linea
this.Control[iCurrent+5]=this.cb_buscar
this.Control[iCurrent+6]=this.em_puesto
this.Control[iCurrent+7]=this.st_3
end on

on w_rep_trazos_pendientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_actualiza)
destroy(this.cb_imprimir)
destroy(this.st_2)
destroy(this.em_linea)
destroy(this.cb_buscar)
destroy(this.em_puesto)
destroy(this.st_3)
end on

event ue_buscar;dw_maestro.Retrieve(0,0,0)
end event

event ue_grabar;//no
end event

event open;call super::open;is_graba = true
end event

event resize;call super::resize;dw_maestro.Resize(This.Width - 120, This.Height - 300)
end event

type dw_maestro from w_base_tabular`dw_maestro within w_rep_trazos_pendientes
integer x = 55
integer y = 116
integer width = 4247
integer height = 1916
integer taborder = 10
string dataobject = "dtb_rep_trazos_pendientes"
end type

event dw_maestro::clicked;IF Row <> 0 AND Row <> -1 AND NOT ISNULL(Row) THEN
	This.SelectRow(il_fila_actual_maestro,FALSE)
	il_fila_actual_maestro = Row
ELSE
END IF



end event

event dw_maestro::doubleclicked;call super::doubleclicked;IF Row <> 0 AND Row <> -1 AND NOT ISNULL(Row) THEN
	This.SelectRow(il_fila_actual_maestro,FALSE)
	il_fila_actual_maestro = Row
ELSE
END IF



end event

event dw_maestro::rowfocuschanged;This.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = This.GetRow()
This.SetRow(il_fila_actual_maestro)
This.SelectRow(il_fila_actual_maestro,TRUE)
end event

event dw_maestro::itemchanged;LONG		ll_orden, ll_fila_actual, ll_tot_filas, pos, li_pos_ant, ll_nuevo_orden, li_primer_cs, li_cs_cambiar
Long	li_estado_nuevo, li_estado_act, li_puesto
STRING	ls_filtro

IF DWO.NAME = "h_trazos_pend_order_crea" THEN
	ll_orden = Long(DATA)
	ll_fila_actual = ROW
	ll_tot_filas = dw_maestro.RowCount()
	is_graba = true
	ll_nuevo_orden = ll_orden
	
	FOR pos=1 TO ll_tot_filas
		
		IF pos = ll_fila_actual THEN
		ELSE
			li_pos_ant = dw_maestro.GetItemNumber(pos, "h_trazos_pend_order_crea")
			IF li_pos_ant < ll_orden THEN
			ELSE
				li_estado_act = dw_maestro.GetItemNumber(pos, "co_estado_crea")
//				IF li_estado_act = 4 THEN  //el trazo ya se esta dibujando, no se puede cambiar de prioridad
//					MessageBox('Advertencia','No puede cambiar prioridad a un trazo que se esta dibujando')
//					is_graba = false
//					Return 1
//				END IF
				
				ll_nuevo_orden = ll_nuevo_orden + 1
				dw_maestro.SetItem(pos, "h_trazos_pend_order_crea", ll_nuevo_orden)
				
			END IF
		END IF
	
	NEXT

//ll_co_tipo = GetItemNumber(Row, "co_tipo")
END IF

IF DWO.NAME = "co_estado_crea" THEN
	li_estado_nuevo = Long(DATA)
	
	li_estado_act = This.GetitemNumber(row,'co_estado_crea')
	
//	li_cs_cambiar = This.GetitemNumber(row,'cs_trazo')
//	IF li_estado_act = 4 AND li_estado_nuevo = 0 THEN
//		MessageBox('Advertencia','No puede  devolver el estado del trazo')
//		is_graba = FALSE
//		Return 1
//	END If
//
	
//	IF li_estado_nuevo = 4  AND li_estado_act = 0 THEN  //verificar que sea el primero
//		li_puesto =  This.GetitemNumber(row,'h_trazos_pend_co_puesto')
//		ls_filtro = 'h_trazos_pend_co_puesto =' + trim(string(li_puesto)) + ' and co_estado_crea = 0'
//		This.SetFilter(ls_filtro)
//		This.Filter()
//		
//		This.SetSort("cs_trazo A")
//		This.Sort()
//		li_primer_cs = This.GetitemNumber(1,'cs_trazo')
//		This.SetFilter('')
//		This.Filter()
//		IF li_cs_cambiar > li_primer_cs THEN
//			MessageBox('Advertencia','No puede pasar a estado dibujando un trazo que no es la prioridad')
//			is_graba	= false	
//			return 1
//		END If
//
//		
//	END If
END IF
end event

event dw_maestro::retrieveend;call super::retrieveend;DECIMAL{2}	ld_porc_util_std
Long		li_tot_fila, li_fila,   li_raya
LONG			ll_referencia, ll_color


li_tot_fila =  dw_maestro.RowCount()

FOR li_fila = 1 TO li_tot_fila
	li_fabrica = dw_maestro.GetItemNumber(li_fila, "co_fabrica")
	li_linea = dw_maestro.GetItemNumber(li_fila, "co_linea")
	ll_referencia = dw_maestro.GetItemNumber(li_fila, "co_referencia")
	li_raya = dw_maestro.GetItemNumber(li_fila, "h_trazos_pend_co_raya")
	ll_color = dw_maestro.GetItemNumber(li_fila, "co_color")

SELECT MIN(porc_utilizacion)
  INTO :ld_porc_util_std
  FROM dt_modelos
 WHERE co_fabrica = :li_fabrica
   AND co_linea = :li_linea
	AND co_referencia = :ll_referencia
	AND co_color_pt = :ll_color
	AND raya = :li_raya;

	dw_maestro.SetItem(li_fila, "porc_util_mod", ld_porc_util_std)

	
	
NEXT
end event

type sle_argumento from w_base_tabular`sle_argumento within w_rep_trazos_pendientes
integer x = 229
integer y = 4
integer width = 146
integer height = 76
integer taborder = 20
end type

type st_1 from w_base_tabular`st_1 within w_rep_trazos_pendientes
integer x = 50
integer width = 178
string text = "Fabrica:"
end type

type cb_actualiza from commandbutton within w_rep_trazos_pendientes
integer x = 2171
integer y = 4
integer width = 256
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Actualizar"
end type

event clicked;/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////

IF is_graba = false THEN
	return
END IF
IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF
	
dw_maestro.Retrieve(li_fabrica,li_linea,0)
end event

type cb_imprimir from commandbutton within w_rep_trazos_pendientes
integer x = 2985
integer y = 4
integer width = 247
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Imprimir"
end type

event clicked;dw_maestro.setFocus()
OpenWithParm(w_opciones_impresion, dw_maestro)

end event

type st_2 from statictext within w_rep_trazos_pendientes
integer x = 425
integer y = 12
integer width = 151
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "Linea:"
boolean focusrectangle = false
end type

type em_linea from editmask within w_rep_trazos_pendientes
integer x = 562
integer y = 4
integer width = 155
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type cb_buscar from commandbutton within w_rep_trazos_pendientes
integer x = 1499
integer y = 4
integer width = 215
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;Long li_puesto



IF len(trim(sle_argumento.text)) = 0 THEN
	li_fabrica = 0
ELSE
	li_fabrica = long(sle_argumento.text)
END IF

IF len(trim(em_linea.text)) = 0 THEN
	li_linea = 0
ELSE
	li_linea = long(em_linea.text)
END IF

IF len(trim(em_puesto.text)) = 0 THEN
	li_puesto = 0
ELSE
	li_puesto = long(em_puesto.text)
END IF
//SetPointer(HourGlass!)
//DISCONNECT;
//SQLCA.Lock = "DIRTY READ"
//CONNECT USING SQLCA;
dw_maestro.SetTransObject(SQLCA)
//
dw_maestro.visible = true
dw_maestro.Retrieve(li_fabrica,li_linea,li_puesto)
SetPointer(Arrow!)

end event

type em_puesto from editmask within w_rep_trazos_pendientes
integer x = 933
integer y = 4
integer width = 155
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_3 from statictext within w_rep_trazos_pendientes
integer x = 759
integer y = 12
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "Puesto:"
boolean focusrectangle = false
end type

