HA$PBExportHeader$w_reporte_liberacion_escala.srw
forward
global type w_reporte_liberacion_escala from w_preview_de_impresion
end type
end forward

global type w_reporte_liberacion_escala from w_preview_de_impresion
end type
global w_reporte_liberacion_escala w_reporte_liberacion_escala

on w_reporte_liberacion_escala.create
call super::create
end on

on w_reporte_liberacion_escala.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;s_base_parametros s_parametros
String ls_nombredw, ls_wparametros
Long ll_wparametros

s_parametros = Message.PowerObjectParm
ls_nombredw 	= s_parametros.Cadena[1]
ll_wparametros	= s_parametros.Entero[1]

dw_reporte.DataObject = ls_nombredw

dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

IF ls_wparametros = 'no parametros' THEN
	dw_reporte.Retrieve()
ELSE
	dw_reporte.Retrieve(ll_wparametros)
END IF

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_liberacion_escala
end type

