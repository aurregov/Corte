HA$PBExportHeader$w_total_ordencorte.srw
forward
global type w_total_ordencorte from w_preview_de_impresion
end type
end forward

global type w_total_ordencorte from w_preview_de_impresion
integer x = 1
integer y = 1
integer width = 2537
integer height = 1876
end type
global w_total_ordencorte w_total_ordencorte

event open;dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(gstr_info_usuario.codigo_usuario)
dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_total_ordencorte.create
call super::create
end on

on w_total_ordencorte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_total_ordencorte
integer y = 32
integer width = 2200
integer height = 1000
string dataobject = "r_total_ordencorte"
end type

