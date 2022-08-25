HA$PBExportHeader$w_asignar_tela_op.srw
forward
global type w_asignar_tela_op from w_base_maestrotb_detalletb
end type
end forward

global type w_asignar_tela_op from w_base_maestrotb_detalletb
integer width = 3483
integer height = 2000
string title = "Asignar Tela Ordenes Incompletas"
end type
global w_asignar_tela_op w_asignar_tela_op

forward prototypes
public function boolean of_asignar_rollos ()
end prototypes

public function boolean of_asignar_rollos ();Return True
end function

on w_asignar_tela_op.create
call super::create
end on

on w_asignar_tela_op.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_borrar_detalle;// Se omite el script
end event

event ue_borrar_maestro;// Se omite el script
end event

event ue_insertar_detalle;// Se omite el script
end event

event ue_insertar_maestro;// Se omite el script
end event

event open;call super::open;This.x = 1
This.y = 1
This.width = 3483
This.height = 2000

dw_maestro.SetTransObject(SQLCA)

dw_detalle.SetTransObject(SQLCA)
end event

event ue_grabar;call super::ue_grabar;Long li_filas, li_fila_actual, li_unidades_rollo, li_unidades, li_liberaciones
Long ll_rollo, ll_ordenpdn
Decimal{2} ld_metros, ld_metros_rollo, ld_porcentaje
n_cst_rollo luo_rollo

//FOR li_fila_actual = 1 TO dw_detalle.RowCount()
//	IF dw_detalle.IsSelected(li_fila_actual) THEN
//		ld_metros_rollo = dw_detalle.GetItemNumber(li_fila_actual, "ca_mt")
//		ld_metros = dw_detalle.GetItemNumber(li_fila_actual, "metros_asignar")
//		li_unidades_rollo = dw_detalle.GetItemNumber(li_fila_actual, "ca_unidades")
//		li_unidades = dw_detalle.GetItemNumber(li_fila_actual, "unidades_asignar")
//		li_liberaciones = dw_detalle.GetItemNumber(li_fila_actual, "liberaciones")
//		ll_rollo = dw_detalle.GetItemNumber(li_fila_actual, "cs_rollo")
//		IF ld_metros > ld_metros_rollo OR li_unidades > li_unidades_rollo THEN
//			MessageBox("Advertencia...","Se encontr$$HEX2$$f3002000$$ENDHEX$$inconsistencias en el rollo " + String(ll_rollo))
//			Return
//		END IF
//	END IF
//NEXT
FOR li_fila_actual = 1 TO dw_detalle.RowCount()
	IF dw_detalle.IsSelected(li_fila_actual) THEN
		IF Not IsValid(luo_rollo) THEN 
			luo_rollo = Create n_cst_rollo
		END IF
//		ld_metros_rollo = dw_detalle.GetItemNumber(li_fila_actual, "ca_mt")
//		ld_metros = dw_detalle.GetItemNumber(li_fila_actual, "metros_asignar")
//		li_unidades_rollo = dw_detalle.GetItemNumber(li_fila_actual, "ca_unidades")
//		li_unidades = dw_detalle.GetItemNumber(li_fila_actual, "unidades_asignar")
//		li_liberaciones = dw_detalle.GetItemNumber(li_fila_actual, "liberaciones")
		ll_rollo = dw_detalle.GetItemNumber(li_fila_actual, "cs_rollo")		
		ll_ordenpdn = dw_maestro.GetItemNumber(1, "cs_ordenpd_pt")
		IF luo_rollo.of_cambiar_op(ll_rollo, ll_ordenpdn) = -1 THEN
			ROLLBACK;
			Return
		END IF
//		IF ld_metros > 0 THEN
//			IF (ld_metros_rollo > (ld_metros * ld_porcentaje)) OR (li_unidades_rollo > (li_unidades * ld_porcentaje)) OR li_liberaciones = 1 THEN
//				IF luo_rollo.of_generar_mercada_asignacion(ll_ordenpdn, ll_rollo, ld_metros, li_unidades) = -1 THEN
//					ROLLBACK;
//					Return
//				END IF
//			ELSE
//			END IF
//		END IF
	END IF
NEXT
end event

event ue_buscar;// Se omite el script
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_asignar_tela_op
integer x = 23
integer y = 112
integer width = 3291
integer height = 216
boolean titlebar = false
string dataobject = "dff_consultar_orden_produccion"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_maestro::doubleclicked;call super::doubleclicked;Long ll_ordenpdn
s_base_parametros lstr_parametros

IF Row > 0 THEN
	ll_ordenpdn = dw_maestro.GetItemNumber(Row, "cs_ordenpd_pt")
	lstr_parametros.entero[1] = ll_ordenpdn
	OpenSheetWithParm(w_consultar_po_cut_x_op, lstr_parametros, Parent)
END IF
end event

event dw_maestro::rowfocuschanged;Long ll_ordenpdn

IF CurrentRow > 0 THEN
	ll_ordenpdn = dw_maestro.GetItemNumber(CurrentRow, "cs_ordenpd_pt")
	dw_detalle.Retrieve(ll_ordenpdn)
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_asignar_tela_op
end type

event sle_argumento::modified;call super::modified;Long ll_ordenpdn

ll_ordenpdn = Long(sle_argumento.Text)

IF dw_maestro.Retrieve(ll_ordenpdn) > 0 THEN
	dw_detalle.Retrieve(ll_ordenpdn)
END IF
end event

type st_1 from w_base_maestrotb_detalletb`st_1 within w_asignar_tela_op
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_asignar_tela_op
integer x = 23
integer y = 348
integer width = 3291
integer height = 1416
boolean titlebar = false
string dataobject = "dtb_tela_requerida_op"
end type

event dw_detalle::clicked;IF This.IsSelected(Row) THEN
	This.SelectRow(Row, False)
ELSE
	This.SelectRow(Row, True)
END IF
end event

event dw_detalle::doubleclicked;Long ll_ordenpdn
s_base_parametros lstr_parametros

IF Row > 0 THEN
	ll_ordenpdn = dw_maestro.GetItemNumber(Row, "cs_ordenpd_pt")
	lstr_parametros.entero[1] = ll_ordenpdn
	OpenSheetWithParm(w_consultar_po_cut_x_op, lstr_parametros, Parent)
END IF
end event

event dw_detalle::rowfocuschanged;// Se omite el script
end event

