HA$PBExportHeader$w_trazos_existentes_iguales.srw
forward
global type w_trazos_existentes_iguales from w_preview_de_impresion_ordencorte
end type
end forward

global type w_trazos_existentes_iguales from w_preview_de_impresion_ordencorte
integer width = 3054
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_trazos_existentes_iguales w_trazos_existentes_iguales

event open;Long 		li_co_fabrica, li_co_linea
Long			ll_co_referencia
Decimal{2}	ld_ancho
String		ls_nombredw	
s_base_parametros_seleccionar lstr_parametros

dw_reporte.width = 2976
dw_reporte.height = 2096

lstr_parametros = Message.PowerObjectParm
li_co_fabrica = lstr_parametros.entero1[1]
li_co_linea = lstr_parametros.entero1[2]
ll_co_referencia = lstr_parametros.entero1[3]
ld_ancho = lstr_parametros.decimal1[1]


ls_nombredw 	= 'dtb_trazos_existentes_iguales'
dw_reporte.DataObject = ls_nombredw

dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(li_co_fabrica,li_co_linea,ll_co_referencia,ld_ancho)
dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")


end event

on w_trazos_existentes_iguales.create
call super::create
end on

on w_trazos_existentes_iguales.destroy
call super::destroy
end on

event close;//no
end event

type dw_reporte from w_preview_de_impresion_ordencorte`dw_reporte within w_trazos_existentes_iguales
integer y = 96
integer height = 1604
string dataobject = "dtb_trazos_existentes_iguales"
end type

