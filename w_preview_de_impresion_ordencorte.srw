HA$PBExportHeader$w_preview_de_impresion_ordencorte.srw
forward
global type w_preview_de_impresion_ordencorte from window
end type
type dw_reporte from datawindow within w_preview_de_impresion_ordencorte
end type
end forward

global type w_preview_de_impresion_ordencorte from window
integer x = 5
integer y = 4
integer width = 3232
integer height = 1928
boolean titlebar = true
string menuname = "m_vista_previa"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_imprimir pbm_custom01
event ue_preliminar pbm_custom02
event ue_regleta pbm_custom03
event ue_zoom pbm_custom04
event ue_paganterior pbm_custom05
event ue_pagsiguiente pbm_custom06
dw_reporte dw_reporte
end type
global w_preview_de_impresion_ordencorte w_preview_de_impresion_ordencorte

type variables
Long ii_ancho, ii_alto, ii_posx, ii_posy
String is_zoom
long li_orden_corte, li_modelo
end variables

event ue_preliminar;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_reporte.Describe("DataWindow.Print.Preview")
if ls_resultado <> 'yes' then
	dw_reporte.Modify("DataWindow.Print.Preview=Yes")
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=Yes")
else
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
	dw_reporte.Modify("DataWindow.Print.Preview.Zoom="+is_zoom)	
	dw_reporte.Modify("DataWindow.Print.Preview=No")
end if

SetPointer(Arrow!)
end event

event ue_regleta;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_reporte.Describe("DataWindow.Print.Preview")
IF ls_resultado <> 'yes' then
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
ELSE
	ls_resultado = dw_reporte.Describe("DataWindow.Print.Preview.Rulers")
	IF ls_resultado <> 'yes' THEN
		dw_reporte.Modify("DataWindow.Print.Preview.Rulers=Yes")
	ELSE
		dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
	END IF
END IF

SetPointer(Arrow!)

end event

event ue_zoom;SetPointer(Arrow!)

string dato

dato = "0"
openwithparm(w_zoom, dato)
dato = message.StringParm
dw_reporte.Modify("DataWindow.Print.Preview.Zoom="+dato)
SetPointer(Arrow!)

end event

event ue_paganterior;dw_reporte.scrollPriorpage()
end event

event ue_pagsiguiente;dw_Reporte.scrollNextpage()

end event

on w_preview_de_impresion_ordencorte.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.dw_reporte=create dw_reporte
this.Control[]={this.dw_reporte}
end on

on w_preview_de_impresion_ordencorte.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_reporte)
end on

event resize;dw_reporte.Resize(This.Width - 120, This.Height - 300)
end event

type dw_reporte from datawindow within w_preview_de_impresion_ordencorte
integer x = 27
integer y = 20
integer width = 2889
integer height = 1496
integer taborder = 30
string dataobject = "r_ordencortetrazo_padre"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event retrieveend;//Long ll_code
//
//ll_code	=	GetItemNumber(1, "cs_orden_corte")
//ole_barras.object.caption	=	String(ll_code)


//dw_reporte.Object.Datawindow.OLE.codigo_barras.object.caption=String(ll_code)
//dw_reporte.Object.Datawindow.OLE.Client.codigo_barras.object.caption=String(ll_code)
//dw_reporte.Object.Datawindow.OLE.Client.caption=String(ll_code)
//dw_reporte.Object.Datawindow.codigobarras.Client.object.caption=String(ll_code)
//dw_reporte.Object.codigobarras.object.caption	=	String(ll_code)

//This.Object.caption	=	String(ll_code)
end event

