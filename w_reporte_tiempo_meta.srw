HA$PBExportHeader$w_reporte_tiempo_meta.srw
forward
global type w_reporte_tiempo_meta from window
end type
type st_1 from statictext within w_reporte_tiempo_meta
end type
type dw_reporte from datawindow within w_reporte_tiempo_meta
end type
end forward

global type w_reporte_tiempo_meta from window
integer width = 3136
integer height = 2316
boolean titlebar = true
string title = "Reporte Calificaci$$HEX1$$f300$$ENDHEX$$n Indicadores"
string menuname = "m_vista_previa"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_imprimir ( )
event ue_preliminar pbm_custom12
event ue_paganterior pbm_custom05
event ue_pagsiguiente pbm_custom06
event ue_regleta pbm_custom03
event ue_zoom pbm_custom04
st_1 st_1
dw_reporte dw_reporte
end type
global w_reporte_tiempo_meta w_reporte_tiempo_meta

type variables
string is_zoom
end variables

forward prototypes
public subroutine wf_calculo ()
public function long wf_calcula ()
end prototypes

event ue_imprimir();dw_reporte.setFocus()
dw_reporte.Object.num_pagina.Visible = 1
OpenWithParm(w_opciones_impresion, dw_reporte)

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

event ue_paganterior;dw_reporte.scrollPriorpage()
end event

event ue_pagsiguiente;dw_Reporte.scrollNextpage()
end event

event ue_regleta;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_reporte.Describe("DataWindow.Print.Preview")
IF ls_resultado <> 'yes' THEN
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

public subroutine wf_calculo ();LONG ll_fila,ll_tiempo
decimal lde_tiempmeta,lde_difertiempo

FOR ll_fila=1 To dw_reporte.RowCount()
	ll_tiempo = dw_reporte.GetItemDecimal(ll_fila,'horas')
	lde_tiempmeta = dw_reporte.GetItemNumber(ll_fila,'tiempo_meta')
	lde_difertiempo = ll_tiempo - lde_tiempmeta

	IF ll_tiempo > lde_tiempmeta THEN
		dw_reporte.setitem(ll_fila,'estado','MALO')
	ELSE
		dw_reporte.setitem(ll_fila,'estado','BUENO')
	END IF
NEXT

end subroutine

public function long wf_calcula ();return 1
end function

event open;Long 		li_filas, li_pos, li_concepto, li_filas2,li_fila, li_pos2, li_calificacion,li_centro
Long		li_tot_procesado, li_tot_buenos, li_tot_malos, li_meta,li_tipo
LONG			ll_lote, ll_tiempo_entre_meta
STRING		ls_de_concepto, ls_responsable,ls_de_centro
DECIMAL{2}	ld_porc_buenos, ld_porc_malos
DATE 			ld_finicial,ld_ffin
s_base_parametros lstr_parametros
Datastore lds_conceptos_movidos_ctro, lds_lotes_segun_cpto_calificacion, lds_tiempo_entre_conceptos_lotes,lds_conceptos_movidos_ctro_15_1,lds_conceptos_movidos_ctro_15_2

This.Width  = 3136
This.Height = 2316

DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;
dw_reporte.Object.num_pagina.Visible = 0

lstr_parametros = Message.PowerObjectParm	
li_centro 		 = lstr_parametros.entero[1]
li_tipo 			 = lstr_parametros.entero[2]
ls_de_centro    = lstr_parametros.cadena[1]
ld_finicial 	 = lstr_parametros.fecha[1]	
ld_ffin         = lstr_parametros.fecha[2]

IF li_centro = 15 and li_tipo = 1 THEN
	lds_conceptos_movidos_ctro_15_1  	= Create DataStore
	lds_conceptos_movidos_ctro_15_1.DataObject = 'ds_conceptos_movidos_ctro_15_1'
	lds_conceptos_movidos_ctro_15_1.SetTransObject(sqlca)
	li_filas = lds_conceptos_movidos_ctro_15_1.retrieve(li_centro,ld_finicial,ld_ffin)
ELSEIF li_centro = 15 and li_tipo = 2 THEN
	lds_conceptos_movidos_ctro_15_2  	= Create DataStore
	lds_conceptos_movidos_ctro_15_2.DataObject = 'ds_conceptos_movidos_ctro_15_24'
	lds_conceptos_movidos_ctro_15_2.SetTransObject(sqlca)
	li_filas = lds_conceptos_movidos_ctro_15_2.retrieve(li_centro,ld_finicial,ld_ffin)
ELSEIF li_centro <> 15 THEN	
	lds_conceptos_movidos_ctro  	= Create DataStore
	lds_conceptos_movidos_ctro.DataObject = 'ds_conceptos_movidos_ctro'
	lds_conceptos_movidos_ctro.SetTransObject(sqlca)
	li_filas = lds_conceptos_movidos_ctro.retrieve(li_centro,ld_finicial,ld_ffin)
END IF

lds_lotes_segun_cpto_calificacion  	= Create DataStore
lds_lotes_segun_cpto_calificacion.DataObject	= 'ds_lotes_segun_cpto_calificacion'
lds_lotes_segun_cpto_calificacion.SetTransObject(sqlca)

lds_tiempo_entre_conceptos_lotes  	= Create DataStore
lds_tiempo_entre_conceptos_lotes.DataObject = 'ds_tiempo_entre_conceptos_lotes'
lds_tiempo_entre_conceptos_lotes.SetTransObject(sqlca)


FOR li_pos = 1  TO li_filas
	IF li_centro = 15 and li_tipo = 1 THEN
		li_concepto = lds_conceptos_movidos_ctro_15_1.Getitemnumber(li_pos,'co_cpto_ant')
		ls_de_concepto = lds_conceptos_movidos_ctro_15_1.GetitemString(li_pos,'de_cpto_bodega')
		li_meta = lds_conceptos_movidos_ctro_15_1.Getitemnumber(li_pos,'tiempo')
		ls_responsable = lds_conceptos_movidos_ctro_15_1.GetitemString(li_pos,'responsable')
	ELSEIF li_centro = 15 and li_tipo = 2 THEN
		li_concepto = lds_conceptos_movidos_ctro_15_2.Getitemnumber(li_pos,'co_cpto_ant')
		ls_de_concepto = lds_conceptos_movidos_ctro_15_2.GetitemString(li_pos,'de_cpto_bodega')
		li_meta = lds_conceptos_movidos_ctro_15_2.Getitemnumber(li_pos,'tiempo')
		ls_responsable = lds_conceptos_movidos_ctro_15_2.GetitemString(li_pos,'responsable')
	ELSEIF li_centro <> 15 THEN
		li_concepto = lds_conceptos_movidos_ctro.Getitemnumber(li_pos,'co_cpto_ant')
		ls_de_concepto = lds_conceptos_movidos_ctro.GetitemString(li_pos,'de_cpto_bodega')
		li_meta = lds_conceptos_movidos_ctro.Getitemnumber(li_pos,'tiempo')
		ls_responsable = lds_conceptos_movidos_ctro.GetitemString(li_pos,'responsable')
	END IF
	
	li_fila = dw_reporte.InsertRow(0)
	dw_reporte.SetItem(li_fila,'co_concepto',li_concepto)
	dw_reporte.SetItem(li_fila,'de_concepto',ls_de_concepto)
	dw_reporte.SetItem(li_fila,'meta',li_meta)
	dw_reporte.SetItem(li_fila,'responsable',ls_responsable)
	dw_reporte.SetItem(li_fila,'fec_inicio',ld_finicial)
	dw_reporte.SetItem(li_fila,'fec_fin',ld_ffin)
	dw_reporte.SetItem(li_fila,'co_centro',li_centro)
	dw_reporte.SetItem(li_fila,'de_centro',ls_de_centro)
	
	
	li_tot_buenos 	  = 0
	li_tot_malos     = 0
	li_tot_procesado = 0
	
	li_filas2 = lds_lotes_segun_cpto_calificacion.Retrieve(li_centro, li_concepto,ld_finicial,ld_ffin)
	
	FOR li_pos2 =  1 TO li_filas2
		ll_lote = lds_lotes_segun_cpto_calificacion.Getitemnumber(li_pos2,'lote')	

		lds_tiempo_entre_conceptos_lotes.Retrieve(li_centro, li_concepto,ll_lote,ld_finicial,ld_ffin)
		
		ll_tiempo_entre_meta = lds_tiempo_entre_conceptos_lotes.Getitemnumber(1,'horas')	
		
		li_tot_procesado = li_tot_procesado + 1
		dw_reporte.SetItem(li_fila,'tot_procesado',li_tot_procesado)
		
		IF (ll_tiempo_entre_meta <= li_meta) THEN //Es bueno
			li_tot_buenos = li_tot_buenos + 1
			dw_reporte.SetItem(li_fila,'ontime',li_tot_buenos)
		ELSE
			li_tot_malos = li_tot_malos + 1
			dw_reporte.SetItem(li_fila,'fuera_rango',li_tot_malos)
		END IF
	NEXT
	
	ld_porc_buenos = (li_tot_buenos / li_tot_procesado) * 100
	ld_porc_malos  = (li_tot_malos / li_tot_procesado) * 100
	dw_reporte.SetItem(li_fila,'porc_ontime',ld_porc_buenos)
	dw_reporte.SetItem(li_fila,'porc_fuera_rango',ld_porc_malos)
NEXT


string 	newsort
newsort = " co_concepto as"
dw_reporte.SetSort(newsort)
dw_reporte.Sort( )




end event

on w_reporte_tiempo_meta.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.st_1=create st_1
this.dw_reporte=create dw_reporte
this.Control[]={this.st_1,&
this.dw_reporte}
end on

on w_reporte_tiempo_meta.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_reporte)
end on

type st_1 from statictext within w_reporte_tiempo_meta
integer x = 37
integer y = 2016
integer width = 1394
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Dobleclic en el Concepto al cual le desea consultar los rollos."
boolean focusrectangle = false
end type

type dw_reporte from datawindow within w_reporte_tiempo_meta
integer x = 37
integer y = 32
integer width = 2967
integer height = 1956
integer taborder = 10
string title = "none"
string dataobject = "dtb_meta_indicadores_cptos"
boolean controlmenu = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;//evento para mostrar el reponsable del concepto en el cual se dio clic derecho
String ls_concepto, ls_responsable, ls_usuario

ls_concepto 	= dw_reporte.GetItemString(Row,'de_concepto')
ls_responsable = dw_reporte.GetItemString(Row,'responsable')

SELECT de_usuario
  INTO :ls_usuario
  FROM m_usuario
 WHERE co_usuario = :ls_responsable; 
 

If sqlca.sqlcode = -1 Then
	MessageBox('Error...','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el responsable, ERROR: '+sqlca.SqlErrText,stopsign!)
	Return
End if

If IsNull(ls_usuario) Or ls_usuario = '' Then
	MessageBox('Advertencia...','El concepto: '+Trim(ls_concepto)+' no tiene asignado responsable.',exclamation!)
	Return
Else
	MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...',Trim(ls_usuario)+' es el responsable del concepto: '+Trim(ls_concepto),information!)
End if


end event

event clicked;If row > 0 then 
	selectrow(0,false)
	SelectRow(row,true)
END IF
end event

event doubleclicked;Long li_centro,li_concepto,li_result
date ld_fecini,ld_fecfin
String ls_de_concepto

s_base_parametros lstr_parametros

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"


li_centro  	   = dw_reporte.GetItemNumber(Row,'co_centro')
li_concepto    = dw_reporte.GetItemNumber(Row,'co_concepto')
ld_fecini      = dw_reporte.GetItemDate(Row,'fec_inicio')
ld_fecfin      = dw_reporte.GetItemDate(Row,'fec_fin')
ls_de_concepto = dw_reporte.GetItemString(Row,'de_concepto')

li_result = MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...','Desea consultar el detalle para el concepto: '+ls_de_concepto, Information!, OKCancel!, 2)

IF li_result = 1 THEN
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro) 
	lstr_parametros.entero[1] = li_centro // parametros para mostrar el detalle de 
	lstr_parametros.entero[2] = li_concepto// cada concepto.
	lstr_parametros.fecha[1]  = ld_fecini
	lstr_parametros.fecha[2]  = ld_fecfin
	lstr_parametros.cadena[1] = ls_de_concepto
	
	OpenSheetWithParm (w_reporte_dtll_indicadores, lstr_parametros, parent)
End if
CLOSE(w_retroalimentacion)
end event

