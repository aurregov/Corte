HA$PBExportHeader$w_reporte_liquidacion_ordencorte_nueva.srw
forward
global type w_reporte_liquidacion_ordencorte_nueva from w_preview_de_impresion
end type
end forward

global type w_reporte_liquidacion_ordencorte_nueva from w_preview_de_impresion
integer width = 3817
integer height = 2620
string title = "Vista Preliminar de Reportes..pr"
end type
global w_reporte_liquidacion_ordencorte_nueva w_reporte_liquidacion_ordencorte_nueva

on w_reporte_liquidacion_ordencorte_nueva.create
call super::create
end on

on w_reporte_liquidacion_ordencorte_nueva.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;
Long ll_orden, ll_agrupacion, ll_basetrazo, ll_liquidacion
n_cts_param lstr_parametros


dw_reporte.settransobject(sqlca)

//Open(w_parametro_corte)

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

lstr_parametros = Message.PowerObjectParm

/* Verifica que hayan parametros */
IF lstr_parametros.is_vector[1] = 'S' THEN
	ll_orden = lstr_parametros.il_vector[1]
	ll_agrupacion = lstr_parametros.il_vector[2]
	ll_basetrazo = lstr_parametros.il_vector[3]	
	ll_liquidacion = lstr_parametros.il_vector[4]
	dw_reporte.Retrieve(ll_orden, ll_agrupacion, ll_basetrazo, ll_liquidacion)
	dw_reporte.GroupCalc()
ELSE
	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
	return -1
END IF




end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_liquidacion_ordencorte_nueva
integer x = 14
integer width = 3753
integer height = 2244
string dataobject = "r_liquidacion_orden_corte_nueva"
end type

