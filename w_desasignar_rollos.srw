HA$PBExportHeader$w_desasignar_rollos.srw
forward
global type w_desasignar_rollos from w_base_maestrotb_detalletb
end type
type rb_ordenpdn from radiobutton within w_desasignar_rollos
end type
type rb_ordenes_completas from radiobutton within w_desasignar_rollos
end type
type em_orden from editmask within w_desasignar_rollos
end type
type gb_1 from groupbox within w_desasignar_rollos
end type
end forward

global type w_desasignar_rollos from w_base_maestrotb_detalletb
integer width = 3374
integer height = 2000
string title = "Desasignar Tela"
rb_ordenpdn rb_ordenpdn
rb_ordenes_completas rb_ordenes_completas
em_orden em_orden
gb_1 gb_1
end type
global w_desasignar_rollos w_desasignar_rollos

type variables
Long ii_centro, ii_estado
end variables

on w_desasignar_rollos.create
int iCurrent
call super::create
this.rb_ordenpdn=create rb_ordenpdn
this.rb_ordenes_completas=create rb_ordenes_completas
this.em_orden=create em_orden
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ordenpdn
this.Control[iCurrent+2]=this.rb_ordenes_completas
this.Control[iCurrent+3]=this.em_orden
this.Control[iCurrent+4]=this.gb_1
end on

on w_desasignar_rollos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_ordenpdn)
destroy(this.rb_ordenes_completas)
destroy(this.em_orden)
destroy(this.gb_1)
end on

event open;n_cts_constantes luo_constantes

This.x = 1
This.y = 1
This.width = 3374
This.height = 2000

dw_maestro.SetTransObject(SQLCA)
dw_detalle.SetTransObject(SQLCA)

luo_constantes = Create n_cts_constantes

ii_estado = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")

IF ii_estado = -1 THEN
	Close(This)
	Return
END IF

ii_centro = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")

IF ii_centro = -1 THEN
	Close(This)
	Return
END IF
end event

event ue_borrar_detalle;// Se omite el script
end event

event ue_borrar_maestro;// Se omite el script
end event

event ue_insertar_detalle;// Se omite el script
end event

event ue_insertar_maestro;// Se omite el script
end event

event ue_grabar;call super::ue_grabar;Long li_fila_actual
Long ll_rollo
n_cst_rollo luo_rollo

luo_rollo = Create n_cst_rollo
FOR li_fila_actual = 1 TO dw_detalle.RowCount()
	IF dw_detalle.IsSelected(li_fila_actual) THEN
		ll_rollo = dw_detalle.GetItemNumber(li_fila_actual, "cs_rollo")
		IF Not luo_rollo.of_actualizar_disponible(ll_rollo) THEN
			ROLLBACK;
			Return
		END IF
	END IF
NEXT
COMMIT;
Destroy luo_rollo;
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_desasignar_rollos
integer x = 27
integer y = 144
integer width = 3278
integer height = 632
boolean titlebar = false
string dataobject = "dtb_ordenes_produccion"
boolean hscrollbar = false
boolean livescroll = false
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long ll_ordenpdn

IF il_fila_actual_maestro > 0 THEN
	ll_ordenpdn = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_ordenpd_pt")
	dw_detalle.Retrieve(ll_ordenpdn, ii_estado, ii_centro)
END IF	
end event

event dw_maestro::doubleclicked;call super::doubleclicked;Long ll_ordenpdn
s_base_parametros lstr_parametros

IF Row > 0 THEN
	ll_ordenpdn = dw_maestro.GetItemNumber(Row, "cs_ordenpd_pt")
	lstr_parametros.entero[1] = ll_ordenpdn
	OpenSheetWithParm(w_consultar_po_cut_x_op, lstr_parametros, Parent)
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_desasignar_rollos
boolean visible = false
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_desasignar_rollos
boolean visible = false
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_desasignar_rollos
integer x = 27
integer y = 800
integer width = 3278
integer height = 968
boolean titlebar = false
string dataobject = "dtb_rollos_op"
end type

event dw_detalle::rowfocuschanged;// Se omite el script
end event

event dw_detalle::clicked;call super::clicked;IF This.IsSelected(Row) THEN
	This.SelectRow(Row, False)
ELSE
	This.SelectRow(Row, True)
END IF
end event

event dw_detalle::doubleclicked;// Se omite el script
end event

type rb_ordenpdn from radiobutton within w_desasignar_rollos
integer x = 613
integer y = 44
integer width = 512
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
string text = "Orden Producci$$HEX1$$f300$$ENDHEX$$n"
boolean checked = true
boolean lefttext = true
end type

event clicked;IF rb_ordenpdn.Checked THEN
	dw_maestro.DataObject = 'dtb_ordenes_produccion'
	dw_maestro.SetTransObject(SQLCA)
	em_orden.Enabled = True
	em_orden.Text = ""
END IF
end event

type rb_ordenes_completas from radiobutton within w_desasignar_rollos
integer x = 55
integer y = 44
integer width = 539
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
string text = "Ordenes Completas"
boolean lefttext = true
end type

event clicked;IF rb_ordenes_completas.Checked THEN
	dw_maestro.DataObject = 'dtb_ordenes_produccion_completas'
	dw_maestro.SetTransObject(SQLCA)	
	em_orden.Enabled = False
	em_orden.Text = ""
END IF
end event

type em_orden from editmask within w_desasignar_rollos
integer x = 1170
integer y = 40
integer width = 398
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

event modified;Long ll_ordenpdn

IF IsNumber(em_orden.Text) THEN
	ll_ordenpdn = Long(em_orden.Text)
	IF dw_maestro.Retrieve(ll_ordenpdn) > 0 THEN
		dw_detalle.Retrieve(ll_ordenpdn, ii_estado, ii_centro)
	END IF
END IF
end event

type gb_1 from groupbox within w_desasignar_rollos
integer x = 27
integer y = 4
integer width = 1568
integer height = 124
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
end type

