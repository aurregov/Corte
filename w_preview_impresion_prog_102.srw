HA$PBExportHeader$w_preview_impresion_prog_102.srw
forward
global type w_preview_impresion_prog_102 from w_preview_de_impresion
end type
end forward

global type w_preview_impresion_prog_102 from w_preview_de_impresion
end type
global w_preview_impresion_prog_102 w_preview_impresion_prog_102

event open;Long 				li_simulacion,li_co_fabrica_modulo, li_co_planta_modulo, li_modulo

s_base_parametros s_parametros

s_parametros = Message.PowerObjectParm

li_simulacion 			= s_parametros.entero[1]
li_co_fabrica_modulo = s_parametros.entero[2]
li_co_planta_modulo 	= s_parametros.entero[3]
li_modulo 				= s_parametros.entero[4]


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(li_simulacion, li_co_fabrica_modulo, li_co_planta_modulo, li_modulo)

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_preview_impresion_prog_102.create
call super::create
end on

on w_preview_impresion_prog_102.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_impresion_prog_102
string DataObject="dct_reporte_formato_102"
end type

