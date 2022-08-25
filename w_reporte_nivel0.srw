HA$PBExportHeader$w_reporte_nivel0.srw
forward
global type w_reporte_nivel0 from window
end type
type st_3 from statictext within w_reporte_nivel0
end type
type st_2 from statictext within w_reporte_nivel0
end type
type st_1 from statictext within w_reporte_nivel0
end type
type dw_reporte from datawindow within w_reporte_nivel0
end type
type gb_1 from groupbox within w_reporte_nivel0
end type
end forward

global type w_reporte_nivel0 from window
integer width = 4375
integer height = 2600
boolean titlebar = true
string title = "Indicadores Producci$$HEX1$$f300$$ENDHEX$$n"
string menuname = "m_vista_previa"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_imprimir ( )
event ue_closequery pbm_closequery
event ue_preliminar ( )
event ue_paganterior pbm_custom05
event ue_pagsiguiente pbm_custom06
event ue_zoom pbm_custom04
event ue_regleta pbm_custom03
st_3 st_3
st_2 st_2
st_1 st_1
dw_reporte dw_reporte
gb_1 gb_1
end type
global w_reporte_nivel0 w_reporte_nivel0

type variables
long il_co_centro,il_unidades,il_semana,&
il_semana_ant,il_mes,il_mes_ant,il_co_centropdn,il_subcentropdn,il_tipoprod
decimal id_dia
date id_fe_proceso
datastore ids_totcentro, ids_totcentro_unid
string is_zoom
end variables

forward prototypes
public subroutine wf_cargar_datos ()
public subroutine wf_calculo ()
public subroutine wf_calculo_centro15_1 ()
public subroutine wf_calculo_centro15_24 ()
public subroutine wf_calcular_tercero ()
public subroutine wf_cargar_datos_seamless ()
public subroutine wf_calcular_tercero_seamless ()
end prototypes

event ue_imprimir();dw_reporte.setFocus()
dw_reporte.Object.num_pagina.Visible = 1
OpenWithParm(w_opciones_impresion, dw_reporte)
end event

event ue_closequery;DISCONNECT;
SQLCA.Lock = "CURSOR STABILITY"
CONNECT USING SQLCA;
end event

event ue_preliminar();SetPointer(HourGlass!)
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

event ue_zoom;SetPointer(Arrow!)

string dato

dato = "0"
openwithparm(w_zoom, dato)
dato = message.StringParm
dw_reporte.Modify("DataWindow.Print.Preview.Zoom="+dato)
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

public subroutine wf_cargar_datos ();LONG      ll_fila,ll_fila2,ll_fila3,ll_fila4, ll_fila5, ll_fila6,ll_fila7,ll_fila8,ll_filads,ll_filasds, ll_filcalc, ll_filcalcs
DECIMAL	 ld_kg_matprima
LONG	    ll_unidades, tot_unidades, ll_caminima, ll_camaxima, ll_unidades_tot,ll_tipo, ll_dia_ant
Long	 li_centro, li_fab, li_lin, li_fila, li_tot_fila, li_tipo_cto, ll_ctro_pdn
DECIMAL	 ld_kg,ld_unid_x_kg, ld_kilos_tot
STRING 	 ls_unidad
DATASTORE lds_centros,lds_centropdn,lds_terceros,lds_corte, lds_mat_prima,lds_metas,lds_centro15_tip24,lds_centro15_tip1,lds_centro_10, lds_kpo

//*** FUNCI$$HEX1$$d300$$ENDHEX$$N PARA CARGAR LOS DATOS DE CADA CENTRO EN EL NIVEL CERO ***//

lds_centros  	= Create DataStore
lds_centros.DataObject 	= 'ds_report_nivel0_centros'// CARGA CENTROS (6,7,10)
lds_centros.SetTransObject(sqlca)
lds_centros.retrieve()

lds_centro_10  	= Create DataStore
lds_centro_10.DataObject 	= 'ds_kamban_tinto_nivel1'// CARGA LOS KILOS Y UNIDADES CALCULADAS PARA EL CENTRO 10 DESDE LA TABLA temp_kamban_tinto.
lds_centro_10.SetTransObject(sqlca)

lds_centropdn	= Create DataStore
lds_centropdn.DataObject = 'ds_report_nivel0_centropdn'// CARGA CENTROS PDN (3,5,8,14,18,50)
lds_centropdn.SetTransObject(sqlca)
lds_centropdn.retrieve()

//SA-53817
lds_terceros	= Create DataStore
lds_terceros.DataObject = 'ds_report_nivel0_terceros_piezas'// CARGA TERCEROS (999) 
lds_terceros.SetTransObject(sqlca)
lds_terceros.retrieve()

lds_corte 	= Create DataStore
lds_corte.DataObject 	= 'ds_report_nivel0_corte'// CARGA CORTE (90)
lds_corte.SetTransObject(sqlca)
lds_corte.retrieve()

lds_mat_prima 	= Create DataStore
lds_mat_prima.DataObject = 'ds_report_nivel0_matprima'// CARGA MATERIA PRIMA
lds_mat_prima.SetTransObject(sqlca)
lds_mat_prima.retrieve()

lds_centro15_tip1	= Create DataStore  // Todo Terminado
lds_centro15_tip1.DataObject = 'ds_report_nivel0_centro15_tip1'  
lds_centro15_tip1.SetTransObject(sqlca)
lds_centro15_tip1.retrieve()


ids_totcentro 	= Create DataStore // DATASTORE UTILIZADO PARA EL CALCULO DE DIAS, SEMANAS Y MESES.
ids_totcentro.DataObject = 'ds_report_nivel0_totcentro'
ids_totcentro.SetTransObject(sqlca)

ids_totcentro_unid 	= Create DataStore // DATASTORE UTILIZADO PARA EL CALCULO DE DIAS, SEMANAS Y MESES.
ids_totcentro_unid.DataObject = 'ds_report_nivel0_totcentro_unid'
ids_totcentro_unid.SetTransObject(sqlca)

//SA-53817
lds_kpo =  Create DataStore // PRODUCCI$$HEX1$$d300$$ENDHEX$$N EN KPO
lds_kpo.DataObject = 'd_gr_report_nivel0_kpo' 
lds_kpo.SetTransObject(sqlca)
lds_kpo.retrieve()




lds_metas 	= Create DataStore
lds_metas.DataObject 	= 'ds_report_nivel0_metas'// datastore utilizado para 
lds_metas.SetTransObject(sqlca) // la obtenci$$HEX1$$f300$$ENDHEX$$n de las metas que han sido configuradas para cada centro. 

id_fe_proceso = today()

ll_fila = 1

//=============== Ciclo para cargar total de materia prima =================//

FOR ll_fila5 = 1 to lds_mat_prima.rowcount()
	dw_reporte.insertrow(ll_fila)
	ld_kg_matprima = lds_mat_prima.getitemnumber(ll_fila5,'kg_matprima')
	dw_reporte.setitem(ll_fila,'co_centro',1)
	dw_reporte.setitem(ll_fila,'de_centro','MATERIA PRIMA')
	dw_reporte.setitem(ll_fila,'kg_hoy',ld_kg_matprima)
	dw_reporte.setitem(ll_fila,'unid_hoy',0)
	dw_reporte.setitem(ll_fila,'co_tipo',1)
	dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
	il_co_centro = 1
   
	wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.

	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(1,0,0)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',1)
	ll_fila ++
NEXT


//===================== Ciclo para cargar centros (6,7,10) ======================

FOR ll_fila6 = 1 to lds_centros.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centro = lds_centros.getitemnumber(ll_fila6,'m_centros_co_centro')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centro)
	dw_reporte.setitem(ll_fila,'de_centro',lds_centros.getitemstring(ll_fila6,'m_centros_de_centro'))
	
	IF il_co_centro = 10 OR il_co_centro = 7  THEN
	//ADICIONA LOS KILOS Y UNIDADES CALCULADAS DE LA TABLA temp_kamban_tinto PARA EL CENTRO 10.
	//SE UTILIZA EL DATASTORE lds_centro_10 Y SE LE ENVIA COMO PARAMETROS EL co_centro_pdn QUE SERIA 3 Y EL CODIGO DEL CENTRO 10.
		IF il_co_centro = 10 THEN
			ll_ctro_pdn = 3
		ELSE
			ll_ctro_pdn = 2
		END IF
		lds_centro_10.retrieve(ll_ctro_pdn,il_co_centro)
		dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
		dw_reporte.setitem(ll_fila,'kg_hoy',lds_centros.getitemnumber(ll_fila6,'ca_kg'))
//		dw_reporte.setitem(ll_fila,'kg_hoy',lds_centro_10.getitemnumber(1,'tot_kilos'))
		dw_reporte.SetItem(ll_fila,'unid_ayer',lds_centro_10.getitemnumber(1,'tot_dia'))
		dw_reporte.SetItem(ll_fila,'unid_1sem_ant',lds_centro_10.getitemnumber(1,'tot_semana'))
		dw_reporte.SetItem(ll_fila,'unid_2sem_ant',lds_centro_10.getitemnumber(1,'tot_semana_ant'))
		dw_reporte.SetItem(ll_fila,'unid_1mes_ant',lds_centro_10.getitemnumber(1,'tot_mes'))
		dw_reporte.SetItem(ll_fila,'unid_2mes_ant',lds_centro_10.getitemnumber(1,'tot_mes_ant'))
	ELSE
		wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
		dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
		dw_reporte.setitem(ll_fila,'kg_hoy',lds_centros.getitemnumber(ll_fila6,'ca_kg'))
		dw_reporte.SetItem(ll_fila,'unid_ayer',id_dia)
		dw_reporte.SetItem(ll_fila,'unid_1sem_ant',il_semana)
		dw_reporte.SetItem(ll_fila,'unid_2sem_ant',il_semana_ant)
		dw_reporte.SetItem(ll_fila,'unid_1mes_ant',il_mes)
		dw_reporte.SetItem(ll_fila,'unid_2mes_ant',il_mes_ant)
	END IF
		
	il_unidades = lds_centros.getitemnumber(ll_fila6,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'co_tipo',2)
		
	dw_reporte.SetItem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(il_co_centro,0,0)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	
	IF il_co_centro = 6 THEN
		dw_reporte.setitem(ll_fila,'orden',2)
	ELSEIF il_co_centro = 7 THEN
		dw_reporte.setitem(ll_fila,'orden',3)
	ELSEIF il_co_centro = 10 THEN
		dw_reporte.setitem(ll_fila,'orden',4)
	END IF
	
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT



//===================== Ciclo para cargar centro 15 tipo 1 (Tela Terminada) ======================

FOR ll_fila7 = 1 to lds_centro15_tip1.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centro = lds_centro15_tip1.getitemnumber(ll_fila7,'m_centros_co_centro')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centro)
	dw_reporte.setitem(ll_fila,'de_centro','TERMINADO TELA')
	dw_reporte.setitem(ll_fila,'kg_hoy',lds_centro15_tip1.getitemnumber(ll_fila7,'ca_kg'))
	dw_reporte.setitem(ll_fila,'co_tipo',1)
	dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
	
	wf_calculo_centro15_1()/* Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y 
									  meses, para el centro 15 tipo 1.*/
	
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(il_co_centro,0,999)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',6)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT

////====================== Ciclo para cargar corte =======================////

il_co_centro	 = 0
il_co_centropdn = 0
il_subcentropdn = 0
il_tipoprod		 = 0

FOR ll_fila4 = 1 to lds_corte.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centro = lds_corte.getitemnumber(ll_fila4,'co_centro')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centro)
	dw_reporte.setitem(ll_fila,'de_centro',lds_corte.getitemstring(ll_fila4,'de_centro'))
	dw_reporte.setitem(ll_fila,'kg_hoy',lds_corte.getitemnumber(ll_fila4,'ca_kg'))
	il_unidades = lds_corte.getitemnumber(ll_fila4,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'co_tipo',5)
	dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
	
	wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
	
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(il_co_centro,il_subcentropdn,0)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',7)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT



////====================== Ciclo para cargar centros pdn =======================////

il_co_centro	 = 0
il_co_centropdn = 0 // variables inicializadas en cero para cuando el ds consultado  
il_subcentropdn = 0 // no tiene co_centro $$HEX2$$f3002000$$ENDHEX$$co_centropdn,co_subcentro_pdn y tipoprod,
il_tipoprod 	 = 0 // y asi realizar el retrieve del datastore lds_totcentro.

FOR ll_fila2 = 1 to lds_centropdn.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centropdn = lds_centropdn.getitemnumber(ll_fila2,'co_centro_pdn')
	il_subcentropdn = lds_centropdn.getitemnumber(ll_fila2,'co_subcentro_pdn')
	dw_reporte.setitem(ll_fila,'co_subcentro_pdn',il_subcentropdn)
	il_tipoprod 	 =	lds_centropdn.getitemnumber(ll_fila2,'co_tipoprod')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centropdn)
	dw_reporte.setitem(ll_fila,'co_centro_pdn',il_co_centropdn)
	dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
	
  	dw_reporte.setitem(ll_fila,'de_centro',lds_centropdn.getitemstring(ll_fila2,'de_subcentro_pdn'))
	il_unidades = lds_centropdn.getitemnumber(ll_fila2,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)	
	dw_reporte.setitem(ll_fila,'co_tipo',6)
	
	wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
	
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',2)
	
	lds_metas.retrieve(il_co_centro,il_subcentropdn,2)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	
	IF il_subcentropdn = 3 THEN
		dw_reporte.setitem(ll_fila,'orden',8)//Condicionales para organizar de acuerdo
	ELSEIF il_subcentropdn = 5 THEN			 //al orden especificado por el usuario
		dw_reporte.setitem(ll_fila,'orden',13)
	ELSEIF il_subcentropdn = 14 THEN
		dw_reporte.setitem(ll_fila,'orden',10)
	ELSEIF il_subcentropdn = 18 THEN
		dw_reporte.setitem(ll_fila,'orden',11)
	ELSEIF il_subcentropdn = 50 THEN
		dw_reporte.setitem(ll_fila,'orden',12)
	END IF
	
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT



////===================== Ciclo para cargar terceros =======================////

il_co_centro	 = 0
il_co_centropdn = 0
il_subcentropdn = 0
il_tipoprod		 = 0

FOR ll_fila3 = 1 TO lds_terceros.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centropdn = lds_terceros.getitemnumber(ll_fila3,'co_centro_pdn')
	il_subcentropdn = lds_terceros.getitemnumber(ll_fila3,'co_subcentro_pdn')
	dw_reporte.setitem(ll_fila,'co_subcentro_pdn',il_subcentropdn)
	il_tipoprod 	 = lds_terceros.getitemnumber(ll_fila3,'co_tipoprod')
	dw_reporte.setitem(ll_fila,'co_centro',lds_terceros.getitemnumber(ll_fila3,'co_subcentro_pdn'))
	dw_reporte.setitem(ll_fila,'de_centro',lds_terceros.getitemstring(ll_fila3,'de_subcentro_pdn'))
	il_unidades = lds_terceros.getitemnumber(ll_fila3,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'co_tipo',7)
	dw_reporte.setitem(ll_fila,'origen','VESTUARIO')
	
	wf_calcular_tercero()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
	
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',999)
	
	lds_metas.retrieve(il_co_centro,il_subcentropdn,999)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',9)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT


//ciclo para insertar las unidades de KPO
il_co_centro	 = 0
il_co_centropdn = 0
il_subcentropdn = 0
il_tipoprod		 = 0
dw_reporte.insertrow(1)
il_co_centropdn = lds_kpo.getitemnumber(1,'co_centro_pdn')
il_tipoprod 	 =	lds_kpo.getitemnumber(1,'co_tipoprod')
dw_reporte.setitem(1,'co_centro',il_co_centropdn)
dw_reporte.setitem(1,'co_centro_pdn',il_co_centropdn)
dw_reporte.setitem(1,'co_subcentro_pdn',il_subcentropdn)
dw_reporte.setitem(1,'co_tipoprod',il_tipoprod)
dw_reporte.setitem(1,'unid_hoy',il_unidades)
dw_reporte.setitem(1,'de_centro','KPO')
dw_reporte.setitem(1,'origen','VESTUARIO')
il_unidades 	= lds_kpo.getitemnumber(1,'unidades')
ll_dia_ant 		= lds_kpo.getitemnumber(1,'dia_ant')
il_semana 		= lds_kpo.getitemnumber(1,'semana')
il_semana_ant 	= lds_kpo.getitemnumber(1,'semana_ant')
il_mes 			= lds_kpo.getitemnumber(1,'mes')
il_mes_ant 		= lds_kpo.getitemnumber(1,'mes_ant')
dw_reporte.setitem(1,'unid_hoy',il_unidades)
dw_reporte.setitem(1,'unid_ayer',ll_dia_ant)
dw_reporte.setitem(1,'unid_1sem_ant',il_semana)
dw_reporte.setitem(1,'unid_2sem_ant',il_semana_ant)
dw_reporte.setitem(1,'unid_1mes_ant',il_mes)
dw_reporte.setitem(1,'unid_2mes_ant',il_mes_ant)
dw_reporte.setitem(1,'co_tipo',8)
dw_reporte.setitem(1,'co_planta',999)
dw_reporte.setitem(1,'orden',10)

//metas de kpo
lds_metas.retrieve(0,1,1)
ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
ls_unidad = lds_metas.getitemstring(1,'unidad')
dw_reporte.setitem(1,'ca_minima',ll_caminima)
dw_reporte.setitem(1,'ca_maxima',ll_camaxima)
dw_reporte.setitem(1,'unidad',ls_unidad)

//=== Codigo para calcular las unidades de los centros que tienen (kg_hoy > 0) ===//

li_tot_fila = dw_reporte.RowCount()

/*---- DataStore$$HEX1$$b400$$ENDHEX$$s para calcular las unidades de los centros 6,7,10,15 ----*/

DATASTORE ds_unids_15_tip1,ds_unids_15_tip24,ds_unids_diferente_15,ds_calc_unids_x_kilo

ds_unids_15_tip1 = Create DataStore
ds_unids_15_tip1.DataObject 	= 'ds_unids_15_tip1'
ds_unids_15_tip1.SetTransObject(sqlca)

ds_unids_15_tip24 = Create DataStore
ds_unids_15_tip24.DataObject 	= 'ds_unids_15_tip24'
ds_unids_15_tip24.SetTransObject(sqlca)

ds_unids_diferente_15 = Create DataStore
ds_unids_diferente_15.DataObject 	= 'ds_unids_diferente_15'
ds_unids_diferente_15.SetTransObject(sqlca)

ds_calc_unids_x_kilo = Create DataStore
ds_calc_unids_x_kilo.DataObject 	= 'ds_calc_unids_x_kilo'
ds_calc_unids_x_kilo.SetTransObject(sqlca)

/*-----------------------------------------------------------------------*/

//////FOR li_fila = 1 TO li_tot_fila
//////
//////	li_centro       = dw_reporte.GetItemNumber(li_fila,"co_centro")
//////	ld_kilos_tot    = dw_reporte.GetItemNumber(li_fila,"kg_hoy")
//////	ll_unidades_tot = dw_reporte.GetItemNumber(li_fila,"unid_hoy")
//////	ll_tipo         = dw_reporte.GetItemNumber(li_fila,"co_tipo")
//////	tot_unidades 	 = 0
//////	ll_unidades 	 = 0
//////	
//////	IF (ld_kilos_tot > 0) AND (ll_unidades_tot = 0 OR IsNull(ll_unidades_tot)) THEN
//////		
//////		/*---- UNIDADES CENTRO 15 TIPO 1 ----*/
//////		IF li_centro = 15 AND ll_tipo = 1 THEN
//////			
//////			ds_unids_15_tip1.Retrieve(li_centro)
//////			
//////			ll_filasds = ds_unids_15_tip1.RowCount()
//////			
//////			FOR ll_filads = 1 TO ll_filasds
//////			 	li_fab 		= ds_unids_15_tip1.GetItemNumber(ll_filads,'co_fabrica')
//////				li_lin 		= ds_unids_15_tip1.GetItemNumber(ll_filads,'co_linea')
//////				li_tipo_cto = ds_unids_15_tip1.GetItemNumber(ll_filads,'tipo')
//////				ld_kg 		= ds_unids_15_tip1.GetItemNumber(ll_filads,'kg')
//////				
//////					IF li_tipo_cto = 3 THEN 
//////					ELSE
//////						ll_filcalcs = ds_calc_unids_x_kilo.Retrieve(li_fab,li_lin)
////////						ll_filcalcs = ds_calc_unids_x_kilo.RowCount()
//////						FOR ll_filcalc = 1 TO ll_filcalcs 
//////							ld_unid_x_kg = ds_calc_unids_x_kilo.GetItemNumber(ll_filcalc,'unid_x_kg')
//////							IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
//////								MessageBox('Error...','Esta en cero las unidades x kilo en fab: ' +string(li_fab) + ' linea: ' +string(li_lin) + 'por defecto se toma 4 unid x kilo',StopSign!)
//////								ld_unid_x_kg = 4
//////								ll_unidades = ld_kg * ld_unid_x_kg;
//////								tot_unidades = tot_unidades + ll_unidades;
//////							END IF
//////						NEXT	
//////					END IF
//////				NEXT
//////				
//////		/*---- UNIDADES CENTRO 15 TIPO 2 Y 4 ----*/	
//////		ELSEIF li_centro = 15 AND ll_tipo = 2 THEN
//////			
//////			ds_unids_15_tip24.Retrieve(li_centro)
//////			
//////			ll_filasds= ds_unids_15_tip24.RowCount()
//////			
//////			FOR ll_filads = 1 TO ll_filasds
//////			 	li_fab 		= ds_unids_15_tip24.GetItemNumber(ll_filads,'co_fabrica')
//////				li_lin 		= ds_unids_15_tip24.GetItemNumber(ll_filads,'co_linea')
//////				li_tipo_cto = ds_unids_15_tip24.GetItemNumber(ll_filads,'tipo')
//////				ld_kg 		= ds_unids_15_tip24.GetItemNumber(ll_filads,'kg')
//////				
//////					IF li_tipo_cto = 3 THEN 
//////					ELSE
//////						ll_filcalcs = ds_calc_unids_x_kilo.Retrieve(li_fab,li_lin)
////////						ll_filcalcs = ds_calc_unids_x_kilo.RowCount()
//////						FOR ll_filcalc = 1 TO ll_filcalcs 
//////							ld_unid_x_kg = ds_calc_unids_x_kilo.GetItemNumber(ll_filcalc,'unid_x_kg')
//////							IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
//////								MessageBox('Error...','Esta en cero las unidades x kilo en fab: ' +string(li_fab) + ' linea: ' +string(li_lin),StopSign!)
//////							ELSE
//////								ll_unidades = ld_kg * ld_unid_x_kg;
//////								tot_unidades = tot_unidades + ll_unidades;
//////							END IF
//////						NEXT	
//////					END IF
//////				NEXT
//////				
//////		/*---- UNIDADES CENTROS DIFERENTES DE 15 y DE 10 ----*/	
//////		ELSEIF li_centro <> 15 AND li_centro <> 10 THEN
//////			
//////			ds_unids_diferente_15.Retrieve(li_centro)
//////			
//////			ll_filasds= ds_unids_diferente_15.RowCount()
//////			
//////			FOR ll_filads = 1 TO ll_filasds
//////			 	li_fab 		= ds_unids_diferente_15.GetItemNumber(ll_filads,'co_fabrica')
//////				li_lin 		= ds_unids_diferente_15.GetItemNumber(ll_filads,'co_linea')
//////				li_tipo_cto = ds_unids_diferente_15.GetItemNumber(ll_filads,'tipo')
//////				ld_kg 		= ds_unids_diferente_15.GetItemNumber(ll_filads,'kg')
//////				
//////					IF li_tipo_cto = 3 THEN 
//////					//
//////					ELSE
//////						ll_filcalcs = ds_calc_unids_x_kilo.Retrieve(li_fab,li_lin)
////////						ll_filcalcs = ds_calc_unids_x_kilo.RowCount()
//////						FOR ll_filcalc = 1 TO ll_filcalcs 
//////							ld_unid_x_kg = ds_calc_unids_x_kilo.GetItemNumber(ll_filcalc,'unid_x_kg')
//////							IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
//////								MessageBox('Error...','Esta en cero las unidades x kilo en fab: ' +string(li_fab) + ' linea: ' +string(li_lin),StopSign!)
//////							ELSE
//////								ll_unidades = ld_kg * ld_unid_x_kg;
//////								tot_unidades = tot_unidades + ll_unidades;
//////							END IF
//////						NEXT	
//////					END IF
//////				NEXT
//////				
//////	/*---- UNIDADES CENTRO 10 ----*/			
//////	ELSEIF li_centro = 10 THEN
//////			
//////		datastore ds_unids_centro_10// DataStore para calcular las unidades del centro 10
//////		ds_unids_centro_10 = Create DataStore
//////		ds_unids_centro_10.DataObject = 'ds_unids_centro_10'
//////		ds_unids_centro_10.SetTransObject(sqlca)
//////					
//////		ds_unids_centro_10.Retrieve(10)
//////		
//////		ll_filasds= ds_unids_centro_10.RowCount()
//////		
//////		FOR ll_filads = 1 TO ll_filasds
//////		 	li_fab 		= ds_unids_centro_10.GetItemNumber(ll_filads,'co_fabrica')
//////			li_lin 		= ds_unids_centro_10.GetItemNumber(ll_filads,'co_linea')
//////			li_tipo_cto = ds_unids_centro_10.GetItemNumber(ll_filads,'tipo')
//////			ld_kg 		= ds_unids_centro_10.GetItemNumber(ll_filads,'kg')
//////				
//////			IF li_tipo_cto = 3 THEN 
//////				//
//////			ELSE
//////				ll_filcalcs = ds_calc_unids_x_kilo.Retrieve(li_fab,li_lin)
////////				ll_filcalcs = ds_calc_unids_x_kilo.RowCount()
//////				FOR ll_filcalc = 1 TO ll_filcalcs 
//////					ld_unid_x_kg = ds_calc_unids_x_kilo.GetItemNumber(ll_filcalc,'unid_x_kg')
//////					IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
//////						MessageBox('Error...','Esta en cero las unidades x kilo en fab: ' +string(li_fab) + ' linea: ' +string(li_lin),StopSign!)
//////					ELSE
//////						ll_unidades = ld_kg * ld_unid_x_kg;
//////						tot_unidades = tot_unidades + ll_unidades;
//////					END IF
//////				NEXT	
//////			END IF
//////		NEXT
//////	END IF
//////	dw_reporte.SetItem(li_fila,"unid_hoy",tot_unidades)
//////	END IF
//////NEXT

string 	ls_ordenar
ls_ordenar = "orden a,co_tipo a,co_centro a,co_centro_pdn a,co_subcentro_pdn a"
dw_reporte.SetSort(ls_ordenar)
dw_reporte.Sort()
dw_reporte.SetFocus()



end subroutine

public subroutine wf_calculo ();


IF (il_co_centro = 0 AND il_co_centropdn = 1) OR (il_co_centro = 90 AND il_co_centropdn=0)  THEN   //kpo busca por unidades
	ids_totcentro_unid.retrieve(il_co_centro,il_co_centropdn,il_subcentropdn,il_tipoprod,id_fe_proceso)	
		//** FUNCIONA PARA CALCULAR LOS DIAS, SEMANAS Y MESES DE TODOS LOS CENTROS EXCEPTO EL CENTRO 15 **//
	
	IF ids_totcentro_unid.rowcount() > 0 THEN
		id_dia = ids_totcentro_unid.getitemnumber(1,'dia')
		il_semana = ids_totcentro_unid.getitemnumber(1,'semana')
		il_semana_ant = ids_totcentro_unid.getitemnumber(1,'semana_ant')
		il_mes = ids_totcentro_unid.getitemnumber(1,'mes')
		il_mes_ant =ids_totcentro_unid.getitemnumber(1,'mes_ant')
	END IF

	
ELSE
	ids_totcentro.retrieve(il_co_centro,il_co_centropdn,il_subcentropdn,il_tipoprod,id_fe_proceso)
	
	//** FUNCIONA PARA CALCULAR LOS DIAS, SEMANAS Y MESES DE TODOS LOS CENTROS EXCEPTO EL CENTRO 15 **//
	
	IF ids_totcentro.rowcount() > 0 THEN
		id_dia = ids_totcentro.getitemnumber(1,'dia')
		il_semana = ids_totcentro.getitemnumber(1,'semana')
		il_semana_ant = ids_totcentro.getitemnumber(1,'semana_ant')
		il_mes = ids_totcentro.getitemnumber(1,'mes')
		il_mes_ant =ids_totcentro.getitemnumber(1,'mes_ant')
	END IF
END IF
	
IF ISNULL(id_dia) THEN id_dia = 0
IF ISNULL(il_semana) THEN il_semana = 0
IF ISNULL(il_semana_ant) THEN il_semana_ant = 0
IF ISNULL(il_mes) THEN il_mes = 0
IF ISNULL(il_mes_ant) THEN il_mes_ant = 0

end subroutine

public subroutine wf_calculo_centro15_1 ();DATASTORE ds_centro15_1

//*** FUNCION PARA CALCULAR LOS DIAS, SEMANAS Y MESES DEL CENTRO 15 TIPO 1. ***//

ds_centro15_1 	= Create DataStore
ds_centro15_1.DataObject = 'ds_report_nivel0_cent15_1_calculo'
ds_centro15_1.SetTransObject(sqlca)

ds_centro15_1.retrieve(il_co_centro)
	
IF ids_totcentro.rowcount() > 0 THEN
	il_unidades =0
	id_dia = ds_centro15_1.getitemnumber(1,'dia_ant')
	il_semana = ds_centro15_1.getitemnumber(1,'semana')
	il_semana_ant = ds_centro15_1.getitemnumber(1,'semana_ant')
	il_mes = ds_centro15_1.getitemnumber(1,'mes')
	il_mes_ant =ds_centro15_1.getitemnumber(1,'mes_ant')
END IF
	
IF ISNULL(id_dia) THEN id_dia = 0
IF ISNULL(il_semana) THEN il_semana = 0
IF ISNULL(il_semana_ant) THEN il_semana_ant = 0
IF ISNULL(il_mes) THEN il_mes = 0
IF ISNULL(il_mes_ant) THEN il_mes_ant = 0

end subroutine

public subroutine wf_calculo_centro15_24 ();DATASTORE ds_centro15_24

//*** FUNCI$$HEX1$$d300$$ENDHEX$$N PARA CALCULAR DIAS, SEMANAS Y MESES DEL CENTRO 15 TIPO 2 Y 4 ***//

ds_centro15_24 	= Create DataStore
ds_centro15_24.DataObject = 'ds_report_nivel0_cent15_24_calculo'
ds_centro15_24.SetTransObject(sqlca)

ds_centro15_24.retrieve(il_co_centro)
	
IF ids_totcentro.rowcount() > 0 THEN
	il_unidades = ds_centro15_24.getitemnumber(1,'compute_1')
	id_dia = ds_centro15_24.getitemnumber(1,'compute_2')
	il_semana = ds_centro15_24.getitemnumber(1,'compute_3')
	il_semana_ant = ds_centro15_24.getitemnumber(1,'compute_4')
	il_mes = ds_centro15_24.getitemnumber(1,'compute_5')
	il_mes_ant =ds_centro15_24.getitemnumber(1,'compute_6')
END IF
	
IF ISNULL(id_dia) THEN id_dia = 0
IF ISNULL(il_semana) THEN il_semana = 0
IF ISNULL(il_semana_ant) THEN il_semana_ant = 0
IF ISNULL(il_mes) THEN il_mes = 0
IF ISNULL(il_mes_ant) THEN il_mes_ant = 0
end subroutine

public subroutine wf_calcular_tercero ();
datastore lds_totcentro_terceros
lds_totcentro_terceros 	= Create DataStore // DATASTORE UTILIZADO PARA EL CALCULO DE DIAS, SEMANAS Y MESES DEL CENTRO TERCEROS.

//SA-53817
lds_totcentro_terceros.DataObject = 'ds_report_nivel0_totcentro_terceros' //ds_report_nivel0_totcentro_terc_pieza
lds_totcentro_terceros.SetTransObject(sqlca)
lds_totcentro_terceros.retrieve(il_co_centropdn,il_tipoprod,id_fe_proceso)


IF lds_totcentro_terceros.rowcount() > 0 THEN
	id_dia = lds_totcentro_terceros.getitemnumber(1,'dia')
	il_semana = lds_totcentro_terceros.getitemnumber(1,'semana')
	il_semana_ant = lds_totcentro_terceros.getitemnumber(1,'semana_ant')
	il_mes = lds_totcentro_terceros.getitemnumber(1,'mes')
	il_mes_ant =lds_totcentro_terceros.getitemnumber(1,'mes_ant')
END IF
	
IF ISNULL(id_dia) THEN id_dia = 0
IF ISNULL(il_semana) THEN il_semana = 0
IF ISNULL(il_semana_ant) THEN il_semana_ant = 0
IF ISNULL(il_mes) THEN il_mes = 0
IF ISNULL(il_mes_ant) THEN il_mes_ant = 0



end subroutine

public subroutine wf_cargar_datos_seamless ();LONG      ll_fila,ll_fila2,ll_fila3,ll_fila4, ll_fila5, ll_fila6,ll_fila7,ll_fila8,ll_filads,ll_filasds, ll_filcalc, ll_filcalcs
DECIMAL	 ld_kg_matprima
LONG	    ll_unidades, tot_unidades, ll_caminima, ll_camaxima, ll_unidades_tot,ll_tipo, ll_dia_ant
Long	 li_centro, li_fab, li_lin, li_fila, li_tot_fila, li_tipo_cto, ll_ctro_pdn
DECIMAL	 ld_kg,ld_unid_x_kg, ld_kilos_tot
STRING 	 ls_unidad
DATASTORE lds_centros,lds_centropdn,lds_terceros,lds_corte, lds_mat_prima,lds_metas,lds_centro15_tip24,lds_centro15_tip1,lds_centro_10, lds_kpo

//*** FUNCI$$HEX1$$d300$$ENDHEX$$N PARA CARGAR LOS DATOS DE CADA CENTRO EN EL NIVEL CERO ***//

lds_centros  	= Create DataStore
lds_centros.DataObject 	= 'ds_report_nivel0_centros_seamless'// CARGA CENTROS (6,7,10)
lds_centros.SetTransObject(sqlca)
lds_centros.retrieve()

//COMO SACAR UNIDADES
lds_centro_10  	= Create DataStore
lds_centro_10.DataObject 	= 'ds_kamban_tinto_nivel1'// CARGA LOS KILOS Y UNIDADES CALCULADAS PARA EL CENTRO 10 DESDE LA TABLA temp_kamban_tinto.
lds_centro_10.SetTransObject(sqlca)

//DUDA
lds_centropdn	= Create DataStore
lds_centropdn.DataObject = 'ds_report_nivel0_centropdn_seamless' // CARGA CENTROS PDN (3,5,8,14,18,50) 
lds_centropdn.SetTransObject(sqlca)
lds_centropdn.retrieve()

lds_terceros	= Create DataStore
lds_terceros.DataObject = 'ds_report_nivel0_tercero_rollos_seamless' // CARGA TERCEROS (999)
lds_terceros.SetTransObject(sqlca)
lds_terceros.retrieve()

//DUDA
lds_corte 	= Create DataStore
lds_corte.DataObject 	= 'ds_report_nivel0_corte_seamless' // CARGA CORTE (94)
lds_corte.SetTransObject(sqlca)
lds_corte.retrieve()

lds_mat_prima 	= Create DataStore
lds_mat_prima.DataObject = 'ds_report_nivel0_matprima_seamless'// CARGA MATERIA PRIMA
lds_mat_prima.SetTransObject(sqlca)
lds_mat_prima.retrieve()

lds_centro15_tip1	= Create DataStore  // Todo Terminado
lds_centro15_tip1.DataObject = 'ds_report_nivel0_centro15_tip1_seamless'  
lds_centro15_tip1.SetTransObject(sqlca)
lds_centro15_tip1.retrieve()


ids_totcentro 	= Create DataStore // DATASTORE UTILIZADO PARA EL CALCULO DE DIAS, SEMANAS Y MESES.
ids_totcentro.DataObject = 'ds_report_nivel0_totcentro_seamless' 
ids_totcentro.SetTransObject(sqlca)

ids_totcentro_unid 	= Create DataStore // DATASTORE UTILIZADO PARA EL CALCULO DE DIAS, SEMANAS Y MESES.
ids_totcentro_unid.DataObject = 'ds_report_nivel0_totcentro_unid_seamless' 
ids_totcentro_unid.SetTransObject(sqlca)

lds_kpo =  Create DataStore // PRODUCCI$$HEX1$$d300$$ENDHEX$$N EN KPO
lds_kpo.DataObject = 'd_gr_report_nivel0_kpo_seamless' 
lds_kpo.SetTransObject(sqlca)
lds_kpo.retrieve()
 
lds_metas 	= Create DataStore
lds_metas.DataObject 	= 'ds_report_nivel0_metas'// datastore utilizado para 
lds_metas.SetTransObject(sqlca) // la obtenci$$HEX1$$f300$$ENDHEX$$n de las metas que han sido configuradas para cada centro. 

ll_fila = 1
id_dia = 0
il_semana = 0
il_semana_ant = 0
il_mes = 0
il_mes_ant = 0

//=============== Ciclo para cargar total de materia prima =================//

FOR ll_fila5 = 1 to lds_mat_prima.rowcount()
	dw_reporte.insertrow(ll_fila)
	ld_kg_matprima = lds_mat_prima.getitemnumber(ll_fila5,'kg_matprima')
	dw_reporte.setitem(ll_fila,'co_centro',4)
	dw_reporte.setitem(ll_fila,'de_centro','MATERIA PRIMA')
	dw_reporte.setitem(ll_fila,'kg_hoy',ld_kg_matprima)
	dw_reporte.setitem(ll_fila,'unid_hoy',0)
	dw_reporte.setitem(ll_fila,'co_tipo',1)
	dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
	il_co_centro = 4
   
	wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.

	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(1,0,0)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',21)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT


//===================== Ciclo para cargar centros (6,7,10) ======================

FOR ll_fila6 = 1 to lds_centros.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centro = lds_centros.getitemnumber(ll_fila6,'m_centros_co_centro')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centro)
	dw_reporte.setitem(ll_fila,'de_centro',lds_centros.getitemstring(ll_fila6,'m_centros_de_centro'))
	
	//SA-53817
	IF il_co_centro = 73 OR il_co_centro = 72  THEN
	//ADICIONA LOS KILOS Y UNIDADES CALCULADAS DE LA TABLA temp_kamban_tinto PARA EL CENTRO 10.
	//SE UTILIZA EL DATASTORE lds_centro_10 Y SE LE ENVIA COMO PARAMETROS EL co_centro_pdn QUE SERIA 3 Y EL CODIGO DEL CENTRO 10.
		IF il_co_centro = 73 THEN
			ll_ctro_pdn = 3
		ELSE
			ll_ctro_pdn = 2
		END IF
		IF lds_centro_10.retrieve(ll_ctro_pdn,il_co_centro) > 0 THEN
			dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
			dw_reporte.setitem(ll_fila,'kg_hoy',lds_centros.getitemnumber(ll_fila6,'ca_kg'))
	//		dw_reporte.setitem(ll_fila,'kg_hoy',lds_centro_10.getitemnumber(1,'tot_kilos'))
			dw_reporte.SetItem(ll_fila,'unid_ayer',lds_centro_10.getitemnumber(1,'tot_dia'))
			dw_reporte.SetItem(ll_fila,'unid_1sem_ant',lds_centro_10.getitemnumber(1,'tot_semana'))
			dw_reporte.SetItem(ll_fila,'unid_2sem_ant',lds_centro_10.getitemnumber(1,'tot_semana_ant'))
			dw_reporte.SetItem(ll_fila,'unid_1mes_ant',lds_centro_10.getitemnumber(1,'tot_mes'))
			dw_reporte.SetItem(ll_fila,'unid_2mes_ant',lds_centro_10.getitemnumber(1,'tot_mes_ant'))
		ELSE
			dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
			dw_reporte.setitem(ll_fila,'kg_hoy',0)
			dw_reporte.SetItem(ll_fila,'unid_ayer',0)
			dw_reporte.SetItem(ll_fila,'unid_1sem_ant',0)
			dw_reporte.SetItem(ll_fila,'unid_2sem_ant',0)
			dw_reporte.SetItem(ll_fila,'unid_1mes_ant',0)
			dw_reporte.SetItem(ll_fila,'unid_2mes_ant',0)
		END IF
	ELSE
		wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
		dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
		dw_reporte.setitem(ll_fila,'kg_hoy',lds_centros.getitemnumber(ll_fila6,'ca_kg'))
		dw_reporte.SetItem(ll_fila,'unid_ayer',id_dia)
		dw_reporte.SetItem(ll_fila,'unid_1sem_ant',il_semana)
		dw_reporte.SetItem(ll_fila,'unid_2sem_ant',il_semana_ant)
		dw_reporte.SetItem(ll_fila,'unid_1mes_ant',il_mes)
		dw_reporte.SetItem(ll_fila,'unid_2mes_ant',il_mes_ant)
	END IF
		
	il_unidades = lds_centros.getitemnumber(ll_fila6,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'co_tipo',2)
		
	dw_reporte.SetItem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(il_co_centro,0,0)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	
	IF il_co_centro = 71 THEN
		dw_reporte.setitem(ll_fila,'orden',22)
	ELSEIF il_co_centro = 72 THEN
		dw_reporte.setitem(ll_fila,'orden',23)
	ELSEIF il_co_centro = 73 THEN
		dw_reporte.setitem(ll_fila,'orden',24)
	END IF
	
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT



//===================== Ciclo para cargar centro 15 tipo 1 (Tela Terminada) ======================

FOR ll_fila7 = 1 to lds_centro15_tip1.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centro = lds_centro15_tip1.getitemnumber(ll_fila7,'m_centros_co_centro')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centro)
	dw_reporte.setitem(ll_fila,'de_centro','BODEGA SILUETA TERMINADA')
	dw_reporte.setitem(ll_fila,'kg_hoy',lds_centro15_tip1.getitemnumber(ll_fila7,'ca_kg'))
	dw_reporte.setitem(ll_fila,'co_tipo',1)
	dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
	
	wf_calculo_centro15_1()/* Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y 
									  meses, para el centro 15 tipo 1.*/
	
	dw_reporte.setitem(ll_fila,'unid_hoy',lds_centro15_tip1.getitemnumber(ll_fila7,'unidades'))
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(il_co_centro,0,999)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',26)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT

////====================== Ciclo para cargar corte =======================////

il_co_centro	 = 0
il_co_centropdn = 0
il_subcentropdn = 0
il_tipoprod		 = 0

FOR ll_fila4 = 1 to lds_corte.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centro = lds_corte.getitemnumber(ll_fila4,'co_centro')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centro)
	dw_reporte.setitem(ll_fila,'de_centro',lds_corte.getitemstring(ll_fila4,'de_centro'))
	dw_reporte.setitem(ll_fila,'kg_hoy',lds_corte.getitemnumber(ll_fila4,'ca_kg'))
	il_unidades = lds_corte.getitemnumber(ll_fila4,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'co_tipo',5)
	dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
	
	wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
	
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',1)
	
	lds_metas.retrieve(il_co_centro,il_subcentropdn,0)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',27)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT



////====================== Ciclo para cargar centros pdn =======================////

il_co_centro	 = 0
il_co_centropdn = 0 // variables inicializadas en cero para cuando el ds consultado  
il_subcentropdn = 0 // no tiene co_centro $$HEX2$$f3002000$$ENDHEX$$co_centropdn,co_subcentro_pdn y tipoprod,
il_tipoprod 	 = 0 // y asi realizar el retrieve del datastore lds_totcentro.

FOR ll_fila2 = 1 to lds_centropdn.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centropdn = lds_centropdn.getitemnumber(ll_fila2,'co_centro_pdn')
	il_subcentropdn = lds_centropdn.getitemnumber(ll_fila2,'co_subcentro_pdn')
	dw_reporte.setitem(ll_fila,'co_subcentro_pdn',il_subcentropdn)
	il_tipoprod 	 =	lds_centropdn.getitemnumber(ll_fila2,'co_tipoprod')
	dw_reporte.setitem(ll_fila,'co_centro',il_co_centropdn)
	dw_reporte.setitem(ll_fila,'co_centro_pdn',il_co_centropdn)
	
  	dw_reporte.setitem(ll_fila,'de_centro',lds_centropdn.getitemstring(ll_fila2,'de_subcentro_pdn'))
	il_unidades = lds_centropdn.getitemnumber(ll_fila2,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)	
	dw_reporte.setitem(ll_fila,'co_tipo',6)
	dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
	
	wf_calculo()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
	
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',18)
	
	lds_metas.retrieve(il_co_centro,il_subcentropdn,2)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	
	IF il_subcentropdn = 3 THEN
		dw_reporte.setitem(ll_fila,'orden',28)//Condicionales para organizar de acuerdo
	ELSEIF il_subcentropdn = 5 THEN			 //al orden especificado por el usuario
		dw_reporte.setitem(ll_fila,'orden',33)
	ELSEIF il_subcentropdn = 14 THEN
		dw_reporte.setitem(ll_fila,'orden',30)
	ELSEIF il_subcentropdn = 18 THEN
		dw_reporte.setitem(ll_fila,'orden',31)
	ELSEIF il_subcentropdn = 50 THEN
		dw_reporte.setitem(ll_fila,'orden',32)
	END IF
	
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT



////===================== Ciclo para cargar terceros =======================////

il_co_centro	 = 0
il_co_centropdn = 0
il_subcentropdn = 0
il_tipoprod		 = 0

FOR ll_fila3 = 1 TO lds_terceros.rowcount()
	dw_reporte.insertrow(ll_fila)
	il_co_centropdn = lds_terceros.getitemnumber(ll_fila3,'co_centro_pdn')
	il_subcentropdn = lds_terceros.getitemnumber(ll_fila3,'co_subcentro_pdn')
	dw_reporte.setitem(ll_fila,'co_subcentro_pdn',il_subcentropdn)
	il_tipoprod 	 = lds_terceros.getitemnumber(ll_fila3,'co_tipoprod')
	dw_reporte.setitem(ll_fila,'co_centro',lds_terceros.getitemnumber(ll_fila3,'co_subcentro_pdn'))
	dw_reporte.setitem(ll_fila,'de_centro',lds_terceros.getitemstring(ll_fila3,'de_subcentro_pdn'))
	il_unidades = lds_terceros.getitemnumber(ll_fila3,'unidades')
	dw_reporte.setitem(ll_fila,'unid_hoy',il_unidades)
	dw_reporte.setitem(ll_fila,'co_tipo',7)
	dw_reporte.setitem(ll_fila,'origen','SEAMLESS')
	
	wf_calcular_tercero_seamless()// Funci$$HEX1$$f300$$ENDHEX$$n para realizar calculos de dia anterior, semanas y meses.
	
	dw_reporte.setitem(ll_fila,'unid_ayer',id_dia)
	dw_reporte.setitem(ll_fila,'unid_1sem_ant',il_semana)
	dw_reporte.setitem(ll_fila,'unid_2sem_ant',il_semana_ant)
	dw_reporte.setitem(ll_fila,'unid_1mes_ant',il_mes)
	dw_reporte.setitem(ll_fila,'unid_2mes_ant',il_mes_ant)
	dw_reporte.setitem(ll_fila,'co_planta',999)
	
	lds_metas.retrieve(il_co_centro,il_subcentropdn,999)
	ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
	ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
	ls_unidad = lds_metas.getitemstring(1,'unidad')
	dw_reporte.setitem(ll_fila,'ca_minima',ll_caminima)
	dw_reporte.setitem(ll_fila,'ca_maxima',ll_camaxima)
	dw_reporte.setitem(ll_fila,'unidad',ls_unidad)
	dw_reporte.setitem(ll_fila,'orden',28)
	ll_fila ++
	
	id_dia = 0
	il_semana = 0
	il_semana_ant = 0
	il_mes = 0
	il_mes_ant = 0
	
NEXT


//ciclo para insertar las unidades de KPO
il_co_centro	 = 0
il_co_centropdn = 0
il_subcentropdn = 0
il_tipoprod		 = 0
dw_reporte.insertrow(1)
il_co_centropdn = lds_kpo.getitemnumber(1,'co_centro_pdn')
il_tipoprod 	 =	lds_kpo.getitemnumber(1,'co_tipoprod')
dw_reporte.setitem(1,'co_centro',il_co_centropdn)
dw_reporte.setitem(1,'co_centro_pdn',il_co_centropdn)
dw_reporte.setitem(1,'co_subcentro_pdn',il_subcentropdn)
dw_reporte.setitem(1,'co_tipoprod',il_tipoprod)
dw_reporte.setitem(1,'unid_hoy',il_unidades)
dw_reporte.setitem(1,'de_centro','KPO')
dw_reporte.setitem(1,'origen','SEAMLESS')
il_unidades 	= lds_kpo.getitemnumber(1,'unidades')
ll_dia_ant 		= lds_kpo.getitemnumber(1,'dia_ant')
il_semana 		= lds_kpo.getitemnumber(1,'semana')
il_semana_ant 	= lds_kpo.getitemnumber(1,'semana_ant')
il_mes 			= lds_kpo.getitemnumber(1,'mes')
il_mes_ant 		= lds_kpo.getitemnumber(1,'mes_ant')
dw_reporte.setitem(1,'unid_hoy',il_unidades)
dw_reporte.setitem(1,'unid_ayer',ll_dia_ant)
dw_reporte.setitem(1,'unid_1sem_ant',il_semana)
dw_reporte.setitem(1,'unid_2sem_ant',il_semana_ant)
dw_reporte.setitem(1,'unid_1mes_ant',il_mes)
dw_reporte.setitem(1,'unid_2mes_ant',il_mes_ant)
dw_reporte.setitem(1,'co_tipo',8)
dw_reporte.setitem(1,'co_planta',999)
dw_reporte.setitem(1,'orden',29)

//metas de kpo
lds_metas.retrieve(0,1,1)
ll_caminima = lds_metas.getitemnumber(1,'ca_minima')
ll_camaxima = lds_metas.getitemnumber(1,'ca_maxima')
ls_unidad = lds_metas.getitemstring(1,'unidad')
dw_reporte.setitem(1,'ca_minima',ll_caminima)
dw_reporte.setitem(1,'ca_maxima',ll_camaxima)
dw_reporte.setitem(1,'unidad',ls_unidad)

//=== Codigo para calcular las unidades de los centros que tienen (kg_hoy > 0) ===//

li_tot_fila = dw_reporte.RowCount()

/*---- DataStore$$HEX1$$b400$$ENDHEX$$s para calcular las unidades de los centros 6,7,10,15 ----*/

DATASTORE ds_unids_15_tip1,ds_unids_15_tip24,ds_unids_diferente_15,ds_calc_unids_x_kilo

ds_unids_15_tip1 = Create DataStore
ds_unids_15_tip1.DataObject 	= 'ds_unids_15_tip1'
ds_unids_15_tip1.SetTransObject(sqlca)

ds_unids_15_tip24 = Create DataStore
ds_unids_15_tip24.DataObject 	= 'ds_unids_15_tip24'
ds_unids_15_tip24.SetTransObject(sqlca)

ds_unids_diferente_15 = Create DataStore
ds_unids_diferente_15.DataObject 	= 'ds_unids_diferente_15'
ds_unids_diferente_15.SetTransObject(sqlca)

ds_calc_unids_x_kilo = Create DataStore
ds_calc_unids_x_kilo.DataObject 	= 'ds_calc_unids_x_kilo'
ds_calc_unids_x_kilo.SetTransObject(sqlca)


string 	ls_ordenar
ls_ordenar = "orden a,co_tipo a,co_centro a,co_centro_pdn a,co_subcentro_pdn a"
dw_reporte.SetSort(ls_ordenar)
dw_reporte.Sort()
dw_reporte.SetFocus()



end subroutine

public subroutine wf_calcular_tercero_seamless ();
datastore lds_totcentro_terceros
lds_totcentro_terceros 	= Create DataStore // DATASTORE UTILIZADO PARA EL CALCULO DE DIAS, SEMANAS Y MESES DEL CENTRO TERCEROS.

//SA-53817
lds_totcentro_terceros.DataObject = 'ds_report_nivel0_totcentro_tercero_seam'
lds_totcentro_terceros.SetTransObject(sqlca)
lds_totcentro_terceros.retrieve(il_co_centropdn,il_tipoprod,id_fe_proceso)


IF lds_totcentro_terceros.rowcount() > 0 THEN
	id_dia = lds_totcentro_terceros.getitemnumber(1,'dia')
	il_semana = lds_totcentro_terceros.getitemnumber(1,'semana')
	il_semana_ant = lds_totcentro_terceros.getitemnumber(1,'semana_ant')
	il_mes = lds_totcentro_terceros.getitemnumber(1,'mes')
	il_mes_ant =lds_totcentro_terceros.getitemnumber(1,'mes_ant')
END IF
	
IF ISNULL(id_dia) THEN id_dia = 0
IF ISNULL(il_semana) THEN il_semana = 0
IF ISNULL(il_semana_ant) THEN il_semana_ant = 0
IF ISNULL(il_mes) THEN il_mes = 0
IF ISNULL(il_mes_ant) THEN il_mes_ant = 0



end subroutine

on w_reporte_nivel0.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_reporte=create dw_reporte
this.gb_1=create gb_1
this.Control[]={this.st_3,&
this.st_2,&
this.st_1,&
this.dw_reporte,&
this.gb_1}
end on

on w_reporte_nivel0.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_reporte)
destroy(this.gb_1)
end on

event open;//MUETRA VENTANA DE ESPERA 
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro) 

This.x = 1
This.y = 1

DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;

SetPointer(HourGlass!)
//ESCONDE EL CONTADOR DE LAS PAGINAS HASTA ACTIVAR EL PREVIEW
dw_reporte.Object.num_pagina.Visible = 0

//FUNCI$$HEX1$$d300$$ENDHEX$$N PARA CARGAR LOS DATOS DEL PRIMER NIVEL(Nivel 0) DE CADA CENTRO.
wf_cargar_datos()

//53817
wf_cargar_datos_seamless()

dw_reporte.SetFocus()

CLOSE(w_retroalimentacion)



end event

type st_3 from statictext within w_reporte_nivel0
integer x = 27
integer y = 2348
integer width = 946
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Unidades de metas expresadas en miles."
boolean focusrectangle = false
end type

type st_2 from statictext within w_reporte_nivel0
integer x = 27
integer y = 2292
integer width = 1609
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Clic derecho en el centro, para ver el reporte de calificaci$$HEX1$$f300$$ENDHEX$$n indicadores."
boolean focusrectangle = false
end type

type st_1 from statictext within w_reporte_nivel0
integer x = 27
integer y = 2240
integer width = 1632
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Dobleclic en el Centro al cual le desea consultar el detalle de conceptos."
boolean focusrectangle = false
end type

type dw_reporte from datawindow within w_reporte_nivel0
integer x = 50
integer y = 44
integer width = 4238
integer height = 2160
integer taborder = 10
string title = "none"
string dataobject = "dtbe_reporte_nivel0"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;String ls_de_centro
Long li_result, li_centro,li_concentropdn,li_subcentropdn,li_tipoprod,li_planta,li_tipo
s_base_parametros lstr_parametros
n_cst_reporte_centro_15 luo_reporte

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"
// 

li_centro 	    = dw_reporte.GetItemNumber(Row,'co_centro')
li_concentropdn = dw_reporte.GetItemNumber(Row,'co_centro_pdn')
li_subcentropdn = dw_reporte.GetItemNumber(Row,'co_subcentro_pdn')
li_tipoprod     = dw_reporte.GetItemNumber(Row,'co_tipoprod')
li_planta       = dw_reporte.GetItemNumber(Row,'co_planta')
ls_de_centro    = dw_reporte.GetItemString(Row,'de_centro')
li_tipo 		    = dw_reporte.GetItemNumber(Row,'co_tipo')		

//li_result = MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...','Desea consultar el detalle para el centro: '+ls_de_centro, Information!, OKCancel!, 2)

li_result = 1
//PARAMETROS PARA MOSTRAR EL DETALLE DEL CENTRO EN UN SEGUNDO NIVEL(Nivel 1)
IF li_result = 1 THEN
	
	IF li_centro = 6 THEN	
		OpenSheetWithParm(w_tela_cruda,This,Parent, 1,Layered!)
	ELSE
		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
		lstr_parametros.entero[1] = li_centro
		lstr_parametros.entero[2] = li_concentropdn
		lstr_parametros.entero[3] = li_subcentropdn
		lstr_parametros.entero[4] = li_tipoprod
		lstr_parametros.entero[5] = li_planta
		lstr_parametros.entero[6] = li_tipo
		lstr_parametros.cadena[1] = ls_de_centro
		OpenSheetWithParm (w_reporte_nivel1, lstr_parametros, parent)
	END IF
End if
CLOSE(w_retroalimentacion)
end event

event clicked;If row > 0 then 
	selectrow(0,false)
	SelectRow(row,true)
END IF
end event

event rbuttondown;Long li_centro,li_result,li_tipo
string ls_de_centro
date ld_finicial,ld_ffin
s_base_parametros lstr_parametros, lstr_fechas, lstr_parametros_retro

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"
 
li_centro 	 = dw_reporte.GetItemNumber(Row,'co_centro')
ls_de_centro = dw_reporte.GetItemString(Row,'de_centro')
li_tipo 		 = dw_reporte.GetItemNumber(Row,'co_tipo')

//
li_result = MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...','Desea consultar el Informe de Calificaci$$HEX1$$f300$$ENDHEX$$n Indicadores del centro '+ls_de_centro, Information!, OKCancel!, 2)

IF li_result = 1 THEN
		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
	
	open(w_prm_fechas)

	lstr_fechas = Message.PowerObjectParm
	ld_finicial = lstr_fechas.fecha[1]//las fechas se reciben en la estructura (lstr_fechas)	y son enviadas desde la ventana
	ld_ffin     = lstr_fechas.fecha[2]//(w_prm_fechas) y se guardan en variables para enviarla a la estructura(lstr_parametros)
	
	lstr_parametros.entero[1] = li_centro// parametros para abrir el reporte tiempo meta.
	lstr_parametros.entero[2] = li_tipo
	lstr_parametros.cadena[1] = ls_de_centro
	lstr_parametros.fecha[1]  = ld_finicial	
	lstr_parametros.fecha[2]  = ld_ffin
	OpenSheetWithParm (w_reporte_tiempo_meta, lstr_parametros, parent)
End if
CLOSE(w_retroalimentacion)

//	OpenSheetWithParm (w_reporte_nivel0, lstr_parametros, parent)






end event

type gb_1 from groupbox within w_reporte_nivel0
integer x = 23
integer width = 4297
integer height = 2228
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

