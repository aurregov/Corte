HA$PBExportHeader$w_m_metas_indicadores.srw
forward
global type w_m_metas_indicadores from w_base_simple
end type
type gb_1 from groupbox within w_m_metas_indicadores
end type
end forward

global type w_m_metas_indicadores from w_base_simple
integer width = 3182
integer height = 1804
string title = "Maestro Metas Indicadores"
gb_1 gb_1
end type
global w_m_metas_indicadores w_m_metas_indicadores

on w_m_metas_indicadores.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_m_metas_indicadores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event open;call super::open;dw_maestro.retrieve()
end event

event ue_insertar_maestro;long ll_fila

ll_fila = dw_maestro.InsertRow(0)

IF ll_fila = -1 THEN
   MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF

end event

type dw_maestro from w_base_simple`dw_maestro within w_m_metas_indicadores
integer x = 110
integer y = 120
integer width = 2912
integer height = 1388
string dataobject = "dgr_m_metas_idicadores"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_m_metas_indicadores
integer x = 50
integer y = 28
integer width = 3040
integer height = 1528
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Metas Indicadores"
end type

