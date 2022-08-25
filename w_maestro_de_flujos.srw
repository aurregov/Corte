HA$PBExportHeader$w_maestro_de_flujos.srw
forward
global type w_maestro_de_flujos from w_base_maestrotb_detalletb
end type
type gb_1 from groupbox within w_maestro_de_flujos
end type
type gb_2 from groupbox within w_maestro_de_flujos
end type
end forward

global type w_maestro_de_flujos from w_base_maestrotb_detalletb
integer width = 2807
integer height = 1616
string title = "Maestro de Flujos"
string menuname = "m_mantenimiento_maestro_detalle"
gb_1 gb_1
gb_2 gb_2
end type
global w_maestro_de_flujos w_maestro_de_flujos

on w_maestro_de_flujos.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_maestro_detalle" then this.MenuID = create m_mantenimiento_maestro_detalle
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.gb_2
end on

on w_maestro_de_flujos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_insertar_detalle;call super::ue_insertar_detalle;Long ll_fila

ll_fila = dw_detalle.InsertRow(0)


IF ll_fila > 0 THEN
	dw_detalle.SetItem(ll_fila, "fe_actualizacion", f_fecha_servidor())
	dw_detalle.SetItem(ll_fila, "usuario", gstr_info_usuario.codigo_usuario)
	dw_detalle.SetItem(ll_fila, "instancia", gstr_info_usuario.instancia)
	
END IF

dw_detalle.deleteRow(ll_fila)
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_maestro_de_flujos
integer x = 841
integer y = 52
integer width = 1070
boolean titlebar = false
string dataobject = "dtb_maestro_m_flujos"
boolean border = false
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long li_flujo

li_flujo = dw_maestro.GetItemNumber(currentrow,'co_flujo')

dw_detalle.retrieve(li_flujo)
end event

event dw_maestro::getfocus;call super::getfocus;Long li_flujo

li_flujo = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'co_flujo')

dw_detalle.retrieve(li_flujo)
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_maestro_de_flujos
boolean visible = false
integer width = 55
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_maestro_de_flujos
boolean visible = false
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_maestro_de_flujos
integer x = 46
integer y = 512
integer width = 2629
integer height = 800
boolean titlebar = false
string dataobject = "dtb_maestro_flujos"
boolean border = false
end type

event dw_detalle::itemchanged;string ls
end event

event dw_detalle::itemfocuschanged;call super::itemfocuschanged;Long ll_fila,ll_flujo

ll_fila = dw_maestro.GetRow()
ll_flujo = dw_maestro.getItemNumber(ll_fila,'co_flujo')

choose case GetColumnName()
	case 'tipo_dato'
		dw_detalle.SetItem(row,'co_flujo',ll_flujo)
end choose

end event

type gb_1 from groupbox within w_maestro_de_flujos
integer x = 805
integer y = 4
integer width = 1120
integer height = 440
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_maestro_de_flujos
integer x = 14
integer y = 452
integer width = 2720
integer height = 888
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

