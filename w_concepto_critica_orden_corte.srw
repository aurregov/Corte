HA$PBExportHeader$w_concepto_critica_orden_corte.srw
forward
global type w_concepto_critica_orden_corte from w_base_tabular
end type
type dw_parametros from datawindow within w_concepto_critica_orden_corte
end type
type cb_recuperar from commandbutton within w_concepto_critica_orden_corte
end type
type cb_limpiar from commandbutton within w_concepto_critica_orden_corte
end type
end forward

global type w_concepto_critica_orden_corte from w_base_tabular
integer width = 3803
integer height = 2044
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_parametros dw_parametros
cb_recuperar cb_recuperar
cb_limpiar cb_limpiar
end type
global w_concepto_critica_orden_corte w_concepto_critica_orden_corte

on w_concepto_critica_orden_corte.create
int iCurrent
call super::create
this.dw_parametros=create dw_parametros
this.cb_recuperar=create cb_recuperar
this.cb_limpiar=create cb_limpiar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parametros
this.Control[iCurrent+2]=this.cb_recuperar
this.Control[iCurrent+3]=this.cb_limpiar
end on

on w_concepto_critica_orden_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_parametros)
destroy(this.cb_recuperar)
destroy(this.cb_limpiar)
end on

event open;This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
dw_parametros.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
dw_parametros.InsertRow(0)

end event

type dw_maestro from w_base_tabular`dw_maestro within w_concepto_critica_orden_corte
integer x = 18
integer y = 128
integer width = 3739
integer height = 1720
string dataobject = "dgr_actualizacion_concepto_critica"
boolean border = true
end type

event dw_maestro::retrieveend;call super::retrieveend;Long	li_filas,posi
STRING	ls_proceso

li_filas =  dw_maestro.RowCount()
FOR posi = 1 TO li_filas
	ls_proceso = TRIM(dw_maestro.GetitemString(posi,'compute_0013'))
	IF ls_proceso = 'EXTENDIDO' THEN
		dw_maestro.Setitem(posi,'compute_0013','DESPACHO')
	ELSE
		IF ls_proceso = 'BMC (MATERIAL CORTADO)' THEN
			dw_maestro.Setitem(posi,'compute_0013','EXTENDIDO')
		END IF
	END IF
NEXT

end event

type sle_argumento from w_base_tabular`sle_argumento within w_concepto_critica_orden_corte
boolean visible = false
boolean enabled = false
end type

type st_1 from w_base_tabular`st_1 within w_concepto_critica_orden_corte
boolean visible = false
end type

type dw_parametros from datawindow within w_concepto_critica_orden_corte
integer x = 27
integer y = 24
integer width = 2254
integer height = 88
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dff_criterio_agrupa_pdn"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_fabrica

IF Dwo.Name = 'co_fabrica' THEN
	f_rcpra_dtos_dddw_param(This, 'co_linea', SQLCA, Long(Data))
END IF
end event

type cb_recuperar from commandbutton within w_concepto_critica_orden_corte
integer x = 2304
integer y = 20
integer width = 302
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Long li_fabrica, li_linea
Long ll_ordenpdn

IF dw_parametros.RowCount() = 1 THEN
	dw_parametros.AcceptText()
	li_fabrica = dw_parametros.GetItemNumber(1, 'co_fabrica')
	IF IsNull(li_fabrica) THEN
		li_fabrica = 0
	END IF
	li_linea = dw_parametros.GetItemNumber(1, 'co_linea')
	IF IsNull(li_linea) THEN
		li_linea = 0
	END IF
	ll_ordenpdn = dw_parametros.GetItemNumber(1, 'cs_ordenpd_pt')
	IF IsNull(ll_ordenpdn) THEN
		ll_ordenpdn = 0
	END IF
	/* FACL - 2020/09/09 - Se quita desconexion que genera fallos en otras ventanas
	DISCONNECT;
	SQLCA.Lock = "DIRTY READ"
	CONNECT USING SQLCA;
	dw_maestro.SetTransObject(SQLCA)
	*/
	// FACL - 2020/09/09 - Se modifica para usar la transaccion global dirty read
	dw_maestro.SetTransObject( gnv_recursos.of_Get_Transaccion_Sucia( ) )
	
	dw_maestro.Retrieve(li_fabrica, li_linea, ll_ordenpdn)
END IF
end event

type cb_limpiar from commandbutton within w_concepto_critica_orden_corte
integer x = 2638
integer y = 20
integer width = 265
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar"
end type

event clicked;dw_parametros.Reset()
dw_parametros.InsertRow(0)
end event

