HA$PBExportHeader$w_reporte_dtll_indicadores.srw
forward
global type w_reporte_dtll_indicadores from w_preview_de_impresion
end type
end forward

global type w_reporte_dtll_indicadores from w_preview_de_impresion
integer width = 3616
integer height = 2380
string title = "Detalle Indicadores"
string menuname = "m_vista_previa"
end type
global w_reporte_dtll_indicadores w_reporte_dtll_indicadores

type variables

end variables

on w_reporte_dtll_indicadores.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
end on

on w_reporte_dtll_indicadores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;Long li_centro,li_concepto,li_result
date ld_fecini,ld_fecfin
String ls_de_concepto

s_base_parametros lstr_parametros

This.Width  = 3616
This.Height = 2378

lstr_parametros = Message.PowerObjectParm
li_centro       = lstr_parametros.entero[1]
li_concepto     = lstr_parametros.entero[2] 
ld_fecini	    = lstr_parametros.fecha[1]
ld_fecfin	    = lstr_parametros.fecha[2]
ls_de_concepto  = lstr_parametros.cadena[1]

dw_reporte.Object.num_pagina.Visible = 0
dw_reporte.SetTransObject(SQLCA)
dw_reporte.Retrieve(li_centro,li_concepto,ld_fecini,ld_fecfin,ls_de_concepto)

string 	newsort
newsort = " co_concepto as"
dw_reporte.SetSort(newsort)
dw_reporte.Sort( )
end event

event resize;//
end event

event ue_preliminar;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_reporte.Describe("DataWindow.Print.Preview")
if ls_resultado <> 'yes' then
	dw_reporte.Modify("DataWindow.Print.Preview=Yes")
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=Yes")
	dw_reporte.Object.num_pagina.Visible = 1
else
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
	dw_reporte.Modify("DataWindow.Print.Preview.Zoom="+is_zoom)	
	dw_reporte.Modify("DataWindow.Print.Preview=No")
	dw_reporte.Object.num_pagina.Visible = 0
end if

SetPointer(Arrow!)
end event

event ue_imprimir;dw_reporte.Object.num_pagina.Visible = 1
call super :: ue_imprimir
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_dtll_indicadores
integer x = 37
integer y = 32
integer width = 3497
integer height = 2120
string dataobject = "dtb_reporte_dtll_indicadores"
end type

