HA$PBExportHeader$w_reporte_devolucion_tela.srw
forward
global type w_reporte_devolucion_tela from w_preview_de_impresion
end type
end forward

global type w_reporte_devolucion_tela from w_preview_de_impresion
end type
global w_reporte_devolucion_tela w_reporte_devolucion_tela

on w_reporte_devolucion_tela.create
call super::create
end on

on w_reporte_devolucion_tela.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;s_base_parametros s_parametros
DateTime ldt_annomes

s_parametros = Message.PowerObjectParm
ldt_annomes = s_parametros.fechahora[1]

dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(ldt_annomes)
dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_devolucion_tela
string DataObject="r_devolucion_tela"
end type

