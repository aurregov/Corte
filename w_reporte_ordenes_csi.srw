HA$PBExportHeader$w_reporte_ordenes_csi.srw
forward
global type w_reporte_ordenes_csi from w_preview_de_impresion
end type
end forward

global type w_reporte_ordenes_csi from w_preview_de_impresion
end type
global w_reporte_ordenes_csi w_reporte_ordenes_csi

event open;This.x = 1
This.y = 1

dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve()


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_reporte_ordenes_csi.create
call super::create
end on

on w_reporte_ordenes_csi.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_ordenes_csi
string dataobject = "dtb_reporte_orden_csi"
end type

