HA$PBExportHeader$w_reporte_nivel3_terceros.srw
forward
global type w_reporte_nivel3_terceros from window
end type
type dw_lista from datawindow within w_reporte_nivel3_terceros
end type
end forward

global type w_reporte_nivel3_terceros from window
integer width = 3918
integer height = 2332
boolean titlebar = true
string title = "Detalle por Concepto"
string menuname = "m_vista_previa"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_imprimir ( )
event ue_preliminar ( )
event ue_zoom ( )
event ue_regleta pbm_custom03
event ue_paganterior pbm_custom05
event ue_pagsiguiente pbm_custom06
dw_lista dw_lista
end type
global w_reporte_nivel3_terceros w_reporte_nivel3_terceros

type variables
Long ii_ancho, ii_alto, ii_posx, ii_posy, ii_act
String is_zoom, is_filtrar
boolean ib_filtro, ib_ordenar_ascendente
long il_i = 0
string is_columna[]


end variables

event ue_imprimir();dw_lista.setFocus()
dw_lista.Object.num_pagina.Visible = 1
OpenWithParm(w_opciones_impresion, dw_lista)

end event

event ue_preliminar();SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_lista.Describe("DataWindow.Print.Preview")
if ls_resultado <> 'yes' then
	dw_lista.Modify("DataWindow.Print.Preview=Yes")
	dw_lista.Modify("DataWindow.Print.Preview.Rulers=Yes")
	dw_lista.Object.num_pagina.Visible = 1
else
	dw_lista.Modify("DataWindow.Print.Preview.Rulers=No")
	dw_lista.Modify("DataWindow.Print.Preview.Zoom="+is_zoom)	
	dw_lista.Modify("DataWindow.Print.Preview=No")
	dw_lista.Object.num_pagina.Visible = 0
end if

SetPointer(Arrow!)
end event

event ue_zoom();SetPointer(Arrow!)

string dato

dato = "0"
openwithparm(w_zoom, dato)
dato = message.StringParm
dw_lista.Modify("DataWindow.Print.Preview.Zoom="+dato)
SetPointer(Arrow!)

end event

event ue_regleta;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_lista.Describe("DataWindow.Print.Preview")
IF ls_resultado <> 'yes' then
	dw_lista.Modify("DataWindow.Print.Preview.Rulers=No")
ELSE
	ls_resultado = dw_lista.Describe("DataWindow.Print.Preview.Rulers")
	IF ls_resultado <> 'yes' THEN
		dw_lista.Modify("DataWindow.Print.Preview.Rulers=Yes")
	ELSE
		dw_lista.Modify("DataWindow.Print.Preview.Rulers=No")
	END IF
END IF

SetPointer(Arrow!)

end event

event ue_paganterior;dw_lista.scrollPriorpage()
end event

event ue_pagsiguiente;dw_lista.scrollNextpage()
end event

on w_reporte_nivel3_terceros.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.dw_lista=create dw_lista
this.Control[]={this.dw_lista}
end on

on w_reporte_nivel3_terceros.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
end on

event open;Long  li_centro, li_co_subcentro
String	ls_atributo,ls_tipo_atributo
s_base_parametros lstr_parametros

This.Width =  3918
This.Height = 2332

ib_filtro = false
ii_act = 1

lstr_parametros     = Message.PowerObjectParm
li_centro		     = lstr_parametros.entero[1] 
li_co_subcentro 	  = lstr_parametros.entero[2]
ls_tipo_atributo	  = lstr_parametros.cadena[1]
ls_atributo 		  = lstr_parametros.cadena[2]

dw_lista.SetTransObject(sqlca)
dw_lista.Object.num_pagina.Visible = 0
dw_lista.Retrieve(li_centro,li_co_subcentro,ls_tipo_atributo,ls_atributo)
end event

type dw_lista from datawindow within w_reporte_nivel3_terceros
integer x = 27
integer y = 32
integer width = 3781
integer height = 2064
integer taborder = 10
string title = "none"
string dataobject = "ds_reporte_nivel3_terceros"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;STRING	ls_filtrar
s_base_parametros lstr_parametros

If dwo.Name = "b_actualizar" Then
	lstr_parametros.entero[1] = This.GetItemNumber(row, "co_centro")
	lstr_parametros.entero[2] = This.GetItemNumber(row, "co_planeador")
	lstr_parametros.entero[3] = This.GetItemNumber(row, "cs_ordenpd_pt")
	lstr_parametros.entero[4] = This.GetItemNumber(row, "co_reftel_act")
	lstr_parametros.entero[5] = This.GetItemNumber(row, "co_color_act")
	lstr_parametros.entero[6] = This.GetItemNumber(row, "cs_tanda")
	OpenWithParm(w_concepto_bodega, lstr_parametros)
End If

IF ib_filtro = true THEN   //el reporte esta filtrado, se quita el filtro
	ls_filtrar = 'filtra_tiempo > 0'
	This.SetFilter(ls_filtrar)
	This.Setredraw(FALSE)
	This.Filter( )		
	This.Setredraw(TRUE)
	This.GroupCalc()	
	ib_filtro = false
ELSE
	If dwo.Name = "b_filtra_rojo" Then
		ls_filtrar = 'filtra_tiempo = 3'
		This.SetFilter(ls_filtrar)
		This.Setredraw(FALSE)
		This.Filter( )		
		This.Setredraw(TRUE)
		This.GroupCalc()	
		ib_filtro = true
	END IF
	
	If dwo.Name = "b_filtra_amarillo" Then
		ls_filtrar = 'filtra_tiempo = 2'
		This.SetFilter(ls_filtrar)
		This.Setredraw(FALSE)
		This.Filter( )		
		This.Setredraw(TRUE)
		This.GroupCalc()	
		ib_filtro = true
	END IF
	
	If dwo.Name = "b_filtra_verde" Then
		ls_filtrar = 'filtra_tiempo = 1'
		This.SetFilter(ls_filtrar)
		This.Setredraw(FALSE)
		This.Filter( )		
		This.Setredraw(TRUE)
		This.GroupCalc()	
		ib_filtro = true
	END IF
END IF
end event

