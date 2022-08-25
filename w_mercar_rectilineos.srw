HA$PBExportHeader$w_mercar_rectilineos.srw
forward
global type w_mercar_rectilineos from w_base_maestrotb_detalletb
end type
end forward

global type w_mercar_rectilineos from w_base_maestrotb_detalletb
integer width = 3643
integer height = 2072
string title = "Mercadas Pendientes"
string menuname = "m_mercada_tela"
event ue_imprimir ( )
end type
global w_mercar_rectilineos w_mercar_rectilineos

type variables
Long ii_pormercar
end variables

event ue_imprimir();OpenWithParm(w_opciones_impresion, dw_detalle)
end event

on w_mercar_rectilineos.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mercada_tela" then this.MenuID = create m_mercada_tela
end on

on w_mercar_rectilineos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;Long li_porcortar
n_cts_constantes luo_constantes

This.x = 1
This.y = 1
This.width = 3694
This.height = 2000

dw_maestro.SetTransObject(SQLCA)
dw_detalle.SetTransObject(SQLCA)

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

luo_constantes = Create n_cts_constantes

li_porcortar = luo_constantes.of_consultar_numerico("ESTADO X CORTAR")

IF li_porcortar = -1 THEN
	Close(This)
	Return
END IF

ii_pormercar = luo_constantes.of_consultar_numerico("ESTADO X MERCAR")

IF ii_pormercar = -1 THEN
	Close(This)
	Return
END IF

dw_maestro.Retrieve(li_porcortar, ii_pormercar, gstr_info_usuario.co_planta_pro)
dw_maestro.TriggerEvent("RowFocusChanged")
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_mercar_rectilineos
integer y = 24
integer width = 3547
integer height = 692
boolean titlebar = false
string dataobject = "dtb_mercadas_pendientes"
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;//Long ll_mercada, ll_prioridad
//Long li_estado
//DateTime ldt_corte
//String ls_mesa
//
//IF il_fila_actual_maestro > 0 THEN
//	ll_mercada = This.GetItemNumber(il_fila_actual_maestro, "cs_mercada")
//	li_estado = This.GetItemNumber(il_fila_actual_maestro, "co_estado_mercada")
//	ldt_corte = This.GetItemDateTime(il_fila_actual_maestro, "corte")
////	IF li_estado = ii_pormercar THEN
//		ls_mesa = This.GetItemString(il_fila_actual_maestro, "mesa")	
////	ELSE
////		ls_mesa = ""
////	END IF
//	dw_detalle.Retrieve(ll_mercada, li_estado, ldt_corte, ls_mesa)
//END IF
end event

event dw_maestro::clicked;call super::clicked;Long ll_mercada, ll_prioridad
Long li_estado
DateTime ldt_corte
String ls_mesa

IF il_fila_actual_maestro > 0 THEN
	ll_mercada = This.GetItemNumber(Row, "cs_mercada")
	li_estado = This.GetItemNumber(Row, "co_estado_mercada")
	ldt_corte = This.GetItemDateTime(Row, "corte")
//	IF li_estado = ii_pormercar THEN
		ls_mesa = This.GetItemString(Row, "mesa")	
//	ELSE
//		ls_mesa = ""
//	END IF
	dw_detalle.Retrieve(ll_mercada, li_estado, ldt_corte, ls_mesa)
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_mercar_rectilineos
boolean visible = false
boolean enabled = false
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_mercar_rectilineos
boolean visible = false
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_mercar_rectilineos
integer y = 736
integer width = 3547
integer height = 1152
boolean titlebar = false
string dataobject = "dtb_rollos_mercada_rectilineos"
boolean hscrollbar = true
end type

