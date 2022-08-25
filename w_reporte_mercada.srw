HA$PBExportHeader$w_reporte_mercada.srw
forward
global type w_reporte_mercada from w_base_maestroff_detalletb
end type
type gb_1 from groupbox within w_reporte_mercada
end type
type gb_2 from groupbox within w_reporte_mercada
end type
end forward

global type w_reporte_mercada from w_base_maestroff_detalletb
integer width = 1865
integer height = 1276
string title = "Mercada"
gb_1 gb_1
gb_2 gb_2
end type
global w_reporte_mercada w_reporte_mercada

on w_reporte_mercada.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.gb_2
end on

on w_reporte_mercada.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_borrar_detalle;//
end event

event ue_borrar_maestro;//
end event

event ue_grabar;//
end event

event ue_insertar_detalle;//
end event

event ue_insertar_maestro;//
end event

event open;IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

This.x = 1
This.y = 1


dw_maestro.SetTransObject(SQLCA)
dw_detalle.SetTransObject(SQLCA)

dw_maestro.InsertRow(0)
dw_maestro.SetFocus()
end event

event ue_buscar;Long ll_mercada
s_base_parametros lstr_parametros
long arg1

Open(w_buscar_mercada)
lstr_parametros=message.powerObjectparm

IF lstr_parametros.hay_parametros THEN
	arg1=lstr_parametros.entero[1]

   IF dw_maestro.Retrieve(arg1) > 0 THEN
		ll_mercada = dw_maestro.GetItemNumber(1, "cs_mercada")
		dw_detalle.Retrieve(ll_mercada)
	ELSE
		dw_detalle.Reset()
	END IF
//	dw_detalle.Retrieve(arg1)
END IF


end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_reporte_mercada
integer x = 37
integer y = 80
integer width = 1737
integer height = 300
boolean titlebar = false
string dataobject = "dff_reporte_mercada"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::itemchanged;//
end event

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long ll_mercada

IF CurrentRow > 0 THEN
	ll_mercada = This.GetItemNumber(CurrentRow, "cs_mercada")
	dw_detalle.Retrieve(ll_mercada)
ELSE
	dw_detalle.Reset()
END IF
end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_reporte_mercada
integer x = 37
integer width = 1737
boolean titlebar = false
string dataobject = "dgr_reporte_mercada"
boolean border = false
end type

type gb_1 from groupbox within w_reporte_mercada
integer x = 23
integer y = 424
integer width = 1778
integer height = 620
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Detalle "
end type

type gb_2 from groupbox within w_reporte_mercada
integer x = 23
integer y = 16
integer width = 1778
integer height = 396
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Maestro "
end type

