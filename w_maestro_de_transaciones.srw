HA$PBExportHeader$w_maestro_de_transaciones.srw
forward
global type w_maestro_de_transaciones from w_base_maestrotb_detalletb
end type
type gb_1 from groupbox within w_maestro_de_transaciones
end type
type gb_2 from groupbox within w_maestro_de_transaciones
end type
end forward

global type w_maestro_de_transaciones from w_base_maestrotb_detalletb
integer width = 2331
integer height = 1744
string title = "Maestro de Transaciones"
gb_1 gb_1
gb_2 gb_2
end type
global w_maestro_de_transaciones w_maestro_de_transaciones

on w_maestro_de_transaciones.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.gb_2
end on

on w_maestro_de_transaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_insertar_detalle;call super::ue_insertar_detalle;Long li_transaccion

IF il_fila_actual_detalle > 0 THEN
	li_transaccion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_transaccion")
	IF IsNull(li_transaccion) THEN
		dw_detalle.DeleteRow(il_fila_actual_detalle)
	ELSE
		dw_detalle.SetItem(il_fila_actual_detalle, "co_transaccion", li_transaccion)
	END IF
END IF
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_maestro_de_transaciones
integer x = 512
integer y = 52
integer width = 1175
integer height = 452
boolean titlebar = false
string dataobject = "dtb_maestro_transaciones"
boolean border = false
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long li_codigo

li_codigo = dw_maestro.GetItemNumber(currentrow,'co_transaccion')

dw_detalle.Retrieve(li_codigo)


end event

event dw_maestro::getfocus;call super::getfocus;Long li_codigo

li_codigo = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'co_transaccion')

dw_detalle.Retrieve(li_codigo)
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_maestro_de_transaciones
boolean visible = false
integer width = 59
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_maestro_de_transaciones
boolean visible = false
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_maestro_de_transaciones
integer x = 133
integer y = 608
integer width = 1888
integer height = 716
boolean titlebar = false
string dataobject = "dtb_detalle_transaciones"
boolean hscrollbar = true
boolean border = false
end type

event dw_detalle::itemchanged;call super::itemchanged;Long ll_codigo

ll_codigo = dw_maestro.GetItemNumber(dw_maestro.GetRow(),'co_transaccion')

choose case GetColumnName()
	case 'co_flujo'
		dw_detalle.SetItem(row,'co_transaccion',ll_codigo)
end choose

end event

type gb_1 from groupbox within w_maestro_de_transaciones
integer x = 462
integer y = 24
integer width = 1271
integer height = 512
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

type gb_2 from groupbox within w_maestro_de_transaciones
integer x = 96
integer y = 568
integer width = 1984
integer height = 784
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

