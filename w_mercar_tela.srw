HA$PBExportHeader$w_mercar_tela.srw
forward
global type w_mercar_tela from w_base_maestrotb_detalletb
end type
end forward

global type w_mercar_tela from w_base_maestrotb_detalletb
integer width = 3643
integer height = 2572
string title = "Mercadas Pendientes"
string menuname = "m_mercada_tela"
event ue_imprimir ( )
end type
global w_mercar_tela w_mercar_tela

type variables
Long ii_pormercar
end variables

event ue_imprimir();OpenWithParm(w_opciones_impresion, dw_detalle)
end event

on w_mercar_tela.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mercada_tela" then this.MenuID = create m_mercada_tela
end on

on w_mercar_tela.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;Long li_porcortar,li_co_planta_pro
n_cts_constantes luo_constantes

This.x = 1
This.y = 1
This.width = 3694
This.height = 2000

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

dw_maestro.SetTransObject(SQLCA)
dw_detalle.SetTransObject(SQLCA)

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

IF gstr_info_usuario.co_planta_pro = 91 THEN
	li_co_planta_pro = 99
END IF

dw_maestro.Retrieve(li_porcortar, ii_pormercar, li_co_planta_pro,0)
dw_maestro.TriggerEvent("RowFocusChanged")


end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_mercar_tela
integer y = 136
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

event dw_maestro::clicked;call super::clicked;Long ll_mercada, ll_prioridad, ll_unir_oc
Long li_estado, ll_datos[], ll_cambio, ll_n, ll_find
DateTime ldt_corte
String ls_mesa, ls_datos
n_cts_constantes_tela luo_constantes
n_cst_string lnv_string

IF il_fila_actual_maestro > 0 THEN
	ll_mercada = This.GetItemNumber(Row, "cs_mercada")
	li_estado = This.GetItemNumber(Row, "co_estado_mercada")
	ldt_corte = This.GetItemDateTime(Row, "corte")
//	IF li_estado = ii_pormercar THEN
		ls_mesa = This.GetItemString(Row, "mesa")	
//	ELSE
//		ls_mesa = ""
//	END IF
	ll_unir_oc = This.GetItemNumber(Row, "cs_unir_oc")
	dw_detalle.Retrieve(ll_mercada, li_estado, ldt_corte, ls_mesa, ll_unir_oc )
	
	If dw_detalle.RowCount() > 0 Then
		//busca datos para saber si se le coloca marca de agua
		ls_datos = luo_constantes.of_consultar_texto("PROC_ACAB_MARCA_AGUA")
		lnv_string = CREATE n_cst_string
		lnv_string.of_convertirstring_array(ls_datos,ll_datos)
		Destroy lnv_string
	
		ll_cambio = 0
		//mira si coloca marca de agua
		FOR ll_n=1 to upperbound(ll_datos[]) //Limite
			ll_find = dw_detalle.Find('proc_esp_acabado = ' + String(ll_datos[ll_n]) ,1, dw_detalle.RowCount()  + 1)
			IF ll_find >  0 THEN
				dw_detalle.Modify("DataWindow.BrushMode=6")
				ll_cambio = 1
			END IF
		NEXT
		//sino cambio nada quita la marca de agua
		If ll_cambio = 0 Then
			dw_detalle.Modify("DataWindow.BrushMode=0")
		End if
		
	End if
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_mercar_tela
integer x = 315
integer width = 754
integer height = 100
end type

event sle_argumento::modified;Long li_porcortar,li_co_planta_pro
Long	ll_oc
String	ls_filtro
n_cts_constantes luo_constantes


luo_constantes = Create n_cts_constantes

li_porcortar = luo_constantes.of_consultar_numerico("ESTADO X CORTAR")

IF li_porcortar = -1 THEN
	Close(parent)
	Return
END IF

ii_pormercar = luo_constantes.of_consultar_numerico("ESTADO X MERCAR")

IF ii_pormercar = -1 THEN
	Close(parent)
	Return
END IF

IF gstr_info_usuario.co_planta_pro = 91 THEN
	li_co_planta_pro = 99
END IF

ll_oc = LONG(sle_argumento.text)

dw_maestro.Retrieve(li_porcortar, ii_pormercar, li_co_planta_pro,ll_oc)
ls_filtro = 'cs_orden_corte = ' + string(ll_oc)


dw_maestro.SetFilter(ls_filtro)  
dw_maestro.Filter()

end event

type st_1 from w_base_maestrotb_detalletb`st_1 within w_mercar_tela
integer x = 73
integer y = 40
integer width = 224
boolean enabled = true
string text = "Ord. Cte"
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_mercar_tela
integer y = 840
integer width = 3547
integer height = 1508
boolean titlebar = false
string dataobject = "dtb_rollos_mercada"
boolean hscrollbar = true
end type

