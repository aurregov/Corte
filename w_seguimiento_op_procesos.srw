HA$PBExportHeader$w_seguimiento_op_procesos.srw
forward
global type w_seguimiento_op_procesos from w_preview_de_impresion
end type
type gb_1 from groupbox within w_seguimiento_op_procesos
end type
end forward

global type w_seguimiento_op_procesos from w_preview_de_impresion
integer width = 3671
integer height = 1904
string title = "Seguimiento O.P Procesos"
gb_1 gb_1
end type
global w_seguimiento_op_procesos w_seguimiento_op_procesos

on w_seguimiento_op_procesos.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_seguimiento_op_procesos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event open;n_cts_param luo_param

luo_param = Message.PowerObjectParm
IF IsValid(luo_param) THEN
	dw_reporte.SetTransObject(SQLCA)
	dw_reporte.Retrieve(luo_param.il_vector[1])
END IF
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_seguimiento_op_procesos
integer x = 46
integer y = 44
integer width = 3511
string dataobject = "dtb_seguimiento_op_procesos"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_reporte::retrieveend;call super::retrieveend;Long	li_sec, ll_fila
LONG		ll_tanda, ll_ordenpd_pt, ll_lote, ll_tela
STRING	ls_de_subcentro_pdn


For ll_fila = 1 To This.RowCount()
	ll_tanda = This.GetItemNumber(ll_fila,'h_tandas_cs_tanda')
	li_sec = This.GetItemNumber(ll_fila,'dt_lotesxtandas_cs_secundario')
	ll_ordenpd_pt = This.GetItemNumber(ll_fila,'dt_lotesxtandas_cs_ordenpd_pt')
	ll_lote = This.GetItemNumber(ll_fila,'m_rollo_lote')
	ll_tela = This.GetItemNumber(ll_fila,'m_rollo_co_reftel_act')

	SELECT de_subcentro_pdn
	  INTO :ls_de_subcentro_pdn
	  FROM dt_procesosxlote, m_subcentros_pdn
	 WHERE dt_procesosxlote.co_tipoprod = m_subcentros_pdn.co_tipoprod
		AND dt_procesosxlote.co_centro_pdn = m_subcentros_pdn.co_centro_pdn
		AND dt_procesosxlote.co_subcentro_pdn = m_subcentros_pdn.co_subcentro_pdn
		AND dt_procesosxlote.cs_tanda = :ll_tanda
		AND dt_procesosxlote.cs_secundario = :li_sec
		AND dt_procesosxlote.cs_ordenpd_pt = :ll_ordenpd_pt
		AND dt_procesosxlote.cs_lote = :ll_lote
		AND dt_procesosxlote.co_reftel = :ll_tela
		AND dt_procesosxlote.fe_ingreso IS NOT NULL
		AND dt_procesosxlote.fe_fin IS NULL;

	This.SetItem(ll_fila,'proceso',ls_de_subcentro_pdn)
	 
Next

This.AcceptText()
TriggerEvent('RowFocusChanging')

     
end event

type gb_1 from groupbox within w_seguimiento_op_procesos
integer x = 14
integer width = 3584
integer height = 1664
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

