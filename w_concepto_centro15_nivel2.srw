HA$PBExportHeader$w_concepto_centro15_nivel2.srw
forward
global type w_concepto_centro15_nivel2 from window
end type
type dw_lista from datawindow within w_concepto_centro15_nivel2
end type
end forward

global type w_concepto_centro15_nivel2 from window
integer width = 3593
integer height = 2452
boolean titlebar = true
string title = "Subdetalle por Concepto"
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
global w_concepto_centro15_nivel2 w_concepto_centro15_nivel2

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

on w_concepto_centro15_nivel2.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.dw_lista=create dw_lista
this.Control[]={this.dw_lista}
end on

on w_concepto_centro15_nivel2.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
end on

event open;Long li_concepto, li_reporte, li_ctro, li_centro_pdn, li_subcentro_pdn,li_tipo,li_co_subcentro, li_fabrica_act, li_planta
String  ls_concepto,ls_co_tipatributo
Long    ll_co_procedencia
s_base_parametros lstr_parametros

SetNull(ll_co_procedencia)

//MUESTRA VENTANA DE ESPERA 
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"

This.Width =  3918
This.Height = 2272

ib_filtro = false
ii_act = 1

lstr_parametros  = Message.PowerObjectParm
li_concepto 	  = lstr_parametros.entero[1]
li_reporte 		  = lstr_parametros.entero[2]
li_ctro 			  = lstr_parametros.entero[3]
li_centro_pdn 	  = lstr_parametros.entero[4]
li_subcentro_pdn = lstr_parametros.entero[5]
li_tipo          = lstr_parametros.entero[6]
li_co_subcentro  = lstr_parametros.entero[7]
li_fabrica_act   = lstr_parametros.entero[8]
li_planta        = lstr_parametros.entero[9]
ls_concepto		  = lstr_parametros.cadena[1]
ls_co_tipatributo= lstr_parametros.cadena[2]

IF li_reporte = 1 THEN
	dw_lista.DataObject = 'dtb_mv_centro15_nivel2'
	dw_lista.SetTransObject(sqlca)
	dw_lista.Object.num_pagina.Visible = 0
	dw_lista.Retrieve(li_concepto)
ELSEIF (li_centro_pdn = 1 OR li_centro_pdn = 2) AND li_subcentro_pdn = 50 THEN
		dw_lista.DataObject = 'd_tb_unidades_x_atributos_referencia'
		ii_act = 0
		dw_lista.SetTransObject(sqlca)
		dw_lista.Object.num_pagina.Visible = 0
		dw_lista.Retrieve(li_centro_pdn,li_subcentro_pdn,li_concepto,li_planta)
ELSEIF li_ctro = 90 THEN
		li_ctro = 1
		ii_act = 0
		dw_lista.DataObject = 'ds_report_nivel2_corte'// Carga nivel 2 Corte
		dw_lista.SetTransObject(sqlca)
		dw_lista.Object.num_pagina.Visible = 0
		dw_lista.Retrieve(1,li_ctro,li_concepto)
ELSEIF li_ctro = 1 AND  IsNull(li_tipo) AND IsNull(ls_co_tipatributo) THEN
		ii_act = 0
		//SA-53817
		dw_lista.DataObject = 'ds_reporte_nivel2_terceros_piezas'// Carga nivel 2 Terceros
		dw_lista.SetTransObject(sqlca)
		dw_lista.Object.num_pagina.Visible = 0
		dw_lista.Retrieve(li_subcentro_pdn,ls_concepto)
ELSEIF li_ctro = 1 AND Not IsNull(ls_co_tipatributo) AND Not IsNull(li_co_subcentro) THEN
		ii_act = 0
		dw_lista.DataObject = 'ds_reporte_nivel2_centrospdn'// Carga nivel 2 Centros pdn
		dw_lista.SetTransObject(sqlca)
		dw_lista.Object.num_pagina.Visible = 0
		dw_lista.Retrieve(li_ctro,li_co_subcentro,ls_co_tipatributo,ls_concepto)
ELSEIF  li_ctro = 1 AND  li_tipo = 1 AND  Not IsNull(li_concepto) THEN
	//
		dw_lista.DataObject = 'ds_reporte_nivel2_matprima'// Carga nivel 2 Matprima
		dw_lista.SetTransObject(sqlca)
		dw_lista.Retrieve(li_concepto,ls_concepto)
ELSEIF	li_ctro = 7 OR li_ctro = 10 THEN
//	
		dw_lista.DataObject = 'ds_kamban_tinto_nivel2'// Carga nivel 3 tintoreria y acabados
		dw_lista.SetTransObject(sqlca)
		dw_lista.Retrieve(li_ctro,li_concepto)

//SA-53817
ELSEIF li_tipo = 8  THEN
		dw_lista.DataObject = 'ds_report_nivel2_kpo'// Carga nivel 2 de KPO
		dw_lista.SetTransObject(sqlca)
		dw_lista.SetFilter("IsNull(co_procedencia)")
		dw_lista.Filter()
		dw_lista.Retrieve(li_concepto,ls_concepto, li_fabrica_act)
	
ELSE
		ii_act = 0
		dw_lista.DataObject = 'ds_total15_nivel3_x_prenda'
		dw_lista.SetTransObject(sqlca)
		dw_lista.Object.num_pagina.Visible = 0
		dw_lista.Retrieve(15,li_concepto,ls_concepto)
END IF

	CLOSE(w_retroalimentacion)
end event

type dw_lista from datawindow within w_concepto_centro15_nivel2
integer x = 27
integer y = 32
integer width = 3433
integer height = 2172
integer taborder = 10
string title = "none"
string dataobject = "dtb_mv_centro15_nivel2"
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

event retrieveend;long ll_fila,ll_fabrica,ll_linea,ll_referencia,ll_filas
datastore lds_report_crit


IF ii_act = 1 THEN
	// DataStore utilizado para verificar si esta en estado critico una referencia
	lds_report_crit  	= Create DataStore
	lds_report_crit.DataObject 	= 'ds_report_crit'
	lds_report_crit.SetTransObject(sqlca)
	
	FOR ll_fila = 1 TO dw_lista.rowcount()
		ll_fabrica    = dw_lista.getitemnumber(ll_fila,'co_fabrica')
		ll_linea   	  = dw_lista.getitemnumber(ll_fila,'co_linea')
		ll_referencia = dw_lista.getitemnumber(ll_fila,'co_referencia')
		
		lds_report_crit.retrieve(ll_fabrica,ll_linea,ll_referencia)
		ll_filas = lds_report_crit.rowcount()
		
		IF ll_filas > 0 THEN
			IF lds_report_crit.GetItemNumber(1,'rep_critica') > 0 THEN
				dw_lista.SetItem(ll_fila,'estado','Critica')
				dw_lista.Modify("estado.Color='255'")
			END IF
		END IF
	NEXT	
END IF
end event

event doubleclicked;String ls_atributo,ls_tipo_atributo
Long li_result, li_centro, li_co_subcentro,li_planta
s_base_parametros lstr_parametros
n_cst_reporte_centro_15 luo_reporte

//********  CARGA PARAMETROS PARA ABRIR EL NIVEL 3. (SOLO PARA EL CENTRO TERCEROS) ********//

li_centro = dw_lista.GetItemNumber(Row,'co_centro_act')
li_planta = dw_lista.GetItemNumber(Row,'co_planta_act')
IF li_centro = 1 AND li_planta <> 2 THEN

//MUESTRA VENTANA DE ESPERA
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"
 
	ls_atributo = dw_lista.GetItemString(Row,'de_atributo')
	li_result   = MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...','Desea consultar el detalle para el Atributo: '+ls_atributo, Information!, OKCancel!, 2)
	
	IF li_result = 1 THEN
		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
		li_co_subcentro = dw_lista.GetItemNumber(Row,'co_subcentro_act')
		ls_tipo_atributo = dw_lista.GetItemString(Row,'co_tipo_atributo') 
		lstr_parametros.entero[1] = li_centro
		lstr_parametros.entero[2] = li_co_subcentro
		lstr_parametros.cadena[1] = ls_tipo_atributo
		lstr_parametros.cadena[2] = ls_atributo
		OpenSheetWithParm(w_reporte_nivel3_terceros, lstr_parametros, parent)
   END IF
ELSE
	MessageBox('Advertencia...','Este concepto no posee otro nivel.',Exclamation!)
END IF
CLOSE(w_retroalimentacion)
end event

event clicked;If row > 0 then 
	selectrow(0,false)
	SelectRow(row,true)
END IF
end event

