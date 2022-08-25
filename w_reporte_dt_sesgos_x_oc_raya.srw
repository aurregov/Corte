HA$PBExportHeader$w_reporte_dt_sesgos_x_oc_raya.srw
forward
global type w_reporte_dt_sesgos_x_oc_raya from w_preview_de_impresion
end type
end forward

global type w_reporte_dt_sesgos_x_oc_raya from w_preview_de_impresion
end type
global w_reporte_dt_sesgos_x_oc_raya w_reporte_dt_sesgos_x_oc_raya

on w_reporte_dt_sesgos_x_oc_raya.create
call super::create
end on

on w_reporte_dt_sesgos_x_oc_raya.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;s_base_parametros s_parametros
long ll_oc

s_parametros = Message.PowerObjectParm
ll_oc 	= s_parametros.entero[1]

dw_reporte.settransobject(gnv_recursos.of_get_transaccion_sucia())
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(ll_oc)


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")



end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_dt_sesgos_x_oc_raya
string dataobject = "d_gr_reporte_dt_sesgos_x_oc_raya"
end type

