HA$PBExportHeader$w_reporte_unid_corte_talla_rectili.srw
$PBExportComments$Reporte para control de rectilineos en corte
forward
global type w_reporte_unid_corte_talla_rectili from w_preview_de_impresion
end type
type em_orden_corte from editmask within w_reporte_unid_corte_talla_rectili
end type
type st_1 from statictext within w_reporte_unid_corte_talla_rectili
end type
end forward

global type w_reporte_unid_corte_talla_rectili from w_preview_de_impresion
integer width = 4489
string title = "UNIDADES RECTILINEAS"
em_orden_corte em_orden_corte
st_1 st_1
end type
global w_reporte_unid_corte_talla_rectili w_reporte_unid_corte_talla_rectili

on w_reporte_unid_corte_talla_rectili.create
int iCurrent
call super::create
this.em_orden_corte=create em_orden_corte
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_orden_corte
this.Control[iCurrent+2]=this.st_1
end on

on w_reporte_unid_corte_talla_rectili.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_orden_corte)
destroy(this.st_1)
end on

event open;
dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

This.x = 1
This.y = 1

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_unid_corte_talla_rectili
integer width = 4425
string dataobject = "dff_reporte_unid_corte_talla_rectili"
end type

type em_orden_corte from editmask within w_reporte_unid_corte_talla_rectili
integer x = 421
integer y = 20
integer width = 489
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

event modified;LONG	ll_orden_corte
ll_orden_corte = LONG(em_orden_corte.text)

dw_reporte.settransobject(sqlca)
dw_reporte.Retrieve(ll_orden_corte)


end event

type st_1 from statictext within w_reporte_unid_corte_talla_rectili
integer x = 50
integer y = 44
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
boolean focusrectangle = false
end type

