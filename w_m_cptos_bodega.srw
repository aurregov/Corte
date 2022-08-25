HA$PBExportHeader$w_m_cptos_bodega.srw
forward
global type w_m_cptos_bodega from w_base_simple
end type
type gb_1 from groupbox within w_m_cptos_bodega
end type
end forward

global type w_m_cptos_bodega from w_base_simple
integer width = 3717
integer height = 2112
string title = "Maestro Conceptos Bodega"
gb_1 gb_1
end type
global w_m_cptos_bodega w_m_cptos_bodega

on w_m_cptos_bodega.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_m_cptos_bodega.destroy
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

type dw_maestro from w_base_simple`dw_maestro within w_m_cptos_bodega
integer x = 110
integer y = 120
integer width = 3424
integer height = 1672
string dataobject = "dgr_m_cptos_bodega"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_m_cptos_bodega
integer x = 50
integer y = 28
integer width = 3552
integer height = 1812
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Conceptos Bodega"
end type

