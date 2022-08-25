HA$PBExportHeader$w_reporte_oc_anuladas.srw
forward
global type w_reporte_oc_anuladas from w_preview_de_impresion
end type
end forward

global type w_reporte_oc_anuladas from w_preview_de_impresion
integer width = 3401
integer height = 2856
event ue_buscar ( )
end type
global w_reporte_oc_anuladas w_reporte_oc_anuladas

event ue_buscar();s_base_parametros lstr_parametros
Date	ld_feinicial,ld_fefinal
Long li_motivo,li_fab,li_lin
Long		ll_ref
String	ls_usuarioan


open(w_filtro_buscar_oc_anuladas)

lstr_parametros = message.PowerObjectParm	

IF lstr_parametros.hay_parametros THEN

	SetPointer(HourGlass!)

	ld_feinicial = lstr_parametros.fecha[1]
	ld_fefinal   = lstr_parametros.fecha[2]
	li_motivo    = lstr_parametros.entero[1]
	li_fab		 =	lstr_parametros.entero[2]
	li_lin		 = lstr_parametros.entero[3]
	ll_ref       = lstr_parametros.entero[4]
	ls_usuarioan = lstr_parametros.cadena[1]
	
	dw_reporte.Retrieve(ld_feinicial,ld_fefinal,li_fab,li_lin,ll_ref, li_motivo,ls_usuarioan)
	
	
END IF
end event

on w_reporte_oc_anuladas.create
call super::create
end on

on w_reporte_oc_anuladas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;//s_base_parametros s_parametros
//String ls_nombredw, ls_wparametros
//
//s_parametros = Message.PowerObjectParm
//ls_nombredw 	= s_parametros.Cadena[1]
//ls_wparametros	= Trim(s_parametros.Cadena[2])
//
//dw_reporte.DataObject = ls_nombredw
//
dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

//IF ls_wparametros = 'no parametros' THEN
//	dw_reporte.Retrieve()
//ELSE
//	Window lw_ventana
//	Open(lw_ventana, ls_wparametros)
//	// LA VENTANA ABIERTA DEBE SELECCIONAR LOS PARAMETROS Y OBLIGAR A HACER 
//	// EL RETRIEVE DESDE ELLA ASI :
//	//		w_preview_de_impresion.dw_reporte.Retrieve(Arg1, Arg2, ....)
//	//dw_reporte.Retrieve(0)
//END IF
//
dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
Triggerevent('ue_buscar')
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_oc_anuladas
integer y = 24
integer width = 3314
integer height = 2600
string dataobject = "dtb_reporte_oc_anuladas"
end type

