HA$PBExportHeader$w_reporte_nivel1_crudo_new.srw
forward
global type w_reporte_nivel1_crudo_new from window
end type
type st_2 from statictext within w_reporte_nivel1_crudo_new
end type
type st_1 from statictext within w_reporte_nivel1_crudo_new
end type
type dw_lista from datawindow within w_reporte_nivel1_crudo_new
end type
type gb_1 from groupbox within w_reporte_nivel1_crudo_new
end type
end forward

global type w_reporte_nivel1_crudo_new from window
integer width = 3918
integer height = 2412
boolean titlebar = true
string title = "Detalle por proceso"
string menuname = "m_vista_previa"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_imprimir ( )
event ue_preliminar pbm_custom12
event ue_regleta pbm_custom03
event ue_paganterior pbm_custom05
event ue_pagsiguiente pbm_custom06
event ue_zoom pbm_custom04
st_2 st_2
st_1 st_1
dw_lista dw_lista
gb_1 gb_1
end type
global w_reporte_nivel1_crudo_new w_reporte_nivel1_crudo_new

type variables
Long   ii_centro,ii_concentropdn,ii_subcentropdn,ii_tipoprod,ii_planta,ii_tipo
string 	 is_de_centro,is_zoom, is_filtrar
boolean 	 ib_filtro, ib_ordenar_ascendente
datastore ids_telterminada,ids_tinto_acabtela,ids_cargcorte,ids_terceros, ids_gbi
long il_i = 0
string is_columna[]
end variables

forward prototypes
public subroutine wf_cargar_7_10 ()
public subroutine wf_cargar_15_6 ()
public subroutine wf_cargar_centropdn ()
public subroutine wf_cargar_corte ()
public subroutine wf_cargar_terceros ()
public subroutine wf_cargar_gbi ()
end prototypes

event ue_imprimir();dw_lista.setFocus()
dw_lista.Object.num_pagina.Visible = 1
OpenWithParm(w_opciones_impresion, dw_lista)

end event

event ue_preliminar;SetPointer(HourGlass!)
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

event ue_zoom;SetPointer(Arrow!)

string dato

dato = "0"
openwithparm(w_zoom, dato)
dato = message.StringParm
dw_lista.Modify("DataWindow.Print.Preview.Zoom="+dato)
SetPointer(Arrow!)
end event

public subroutine wf_cargar_7_10 ();LONG ll_fila,ll_cent_orig

IF ii_centro = 2 THEN 
	ll_cent_orig = 7
ELSEIF ii_centro = 3 THEN
	ll_cent_orig = 10
END IF
	
ids_tinto_acabtela = create datastore
ids_tinto_acabtela.DataObject = 'ds_kamban_tinto_nivel1'
ids_tinto_acabtela.SetTransObject(sqlca)
ids_tinto_acabtela.Retrieve(ii_centro,ll_cent_orig)

FOR ll_fila = 1 to ids_tinto_acabtela.RowCount()
	dw_lista.InsertRow(ll_fila)
	dw_lista.setitem(ll_fila,'co_centro',ii_centro)
	dw_lista.setitem(ll_fila,'de_centro',is_de_centro)
	dw_lista.setitem(ll_fila,'co_concepto',ids_tinto_acabtela.getitemnumber(ll_fila,'co_subcentro_pdn'))
	dw_lista.setitem(ll_fila,'de_concepto',ids_tinto_acabtela.getitemstring(ll_fila,'de_subcentro_pdn'))
	dw_lista.setitem(ll_fila,'co_tipo',1)
	dw_lista.setitem(ll_fila,'kg_hoy',ids_tinto_acabtela.getitemnumber(ll_fila,'kilos'))
//	dw_lista.setitem(ll_fila,'unid_hoy',ids_tinto_acabtela.getitemnumber(ll_fila,'unidades'))
	dw_lista.setitem(ll_fila,'unid_ayer',ids_tinto_acabtela.getitemnumber(ll_fila,'dia'))
	dw_lista.setitem(ll_fila,'unid_1sem_ant',ids_tinto_acabtela.getitemnumber(ll_fila,'semana'))
	dw_lista.setitem(ll_fila,'unid_2sem_ant',ids_tinto_acabtela.getitemnumber(ll_fila,'semana_ant'))
	dw_lista.setitem(ll_fila,'unid_1mes_ant',ids_tinto_acabtela.getitemnumber(ll_fila,'mes'))
	dw_lista.setitem(ll_fila,'unid_2mes_ant',ids_tinto_acabtela.getitemnumber(ll_fila,'mes_ant'))
NEXT

//////////////////////////////////////////////////////////////
LONG	ll_unidades, tot_unidades
Long	li_subcentro, li_fab, li_lin, li_fila, li_tot_fila
DECIMAL	ld_kg,ld_unid_x_kg, ld_kilos_tot

li_tot_fila =  dw_lista.RowCount()

FOR li_fila = 1 TO li_tot_fila

	li_subcentro = dw_lista.getitemnumber(li_fila,'co_concepto')
	ld_kilos_tot = dw_lista.GetItemNumber(li_fila, "kg_hoy")
	
	tot_unidades = 0
	ll_unidades = 0
	IF ld_kilos_tot > 0 THEN
		
		DECLARE fichos CURSOR FOR
		SELECT t.co_fabrica, t.co_linea, sum(t.kilos)
		FROM temp_kamban_tinto t,
			  m_subcentros_pdn m
		WHERE t.co_centro_pdn = m.co_centro_pdn and
				t.co_subcentro_pdn = m.co_subcentro_pdn and
				t.co_centro_pdn = :ii_centro
		  and t.co_subcentro_pdn = :li_subcentro
		  and m.co_tipoprod = 2
		GROUP BY 1,2;
		OPEN fichos;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al abrir el cursor de fichos")
//			Return(1)
		END IF
		FETCH fichos INTO :li_fab, :li_lin, :ld_kg ;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer el primer registro de fichos")
//			Return(1)
		END IF
		DO WHILE SQLCA.SQLCode = 0
		 SELECT MAX(unid_kg)
		  INTO :ld_unid_x_kg
		  FROM m_lineas_agrup
		 WHERE co_fabrica = :li_fab
			AND co_linea_agrup = :li_lin;
		IF IsNull(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
			ld_unid_x_kg = 4   //se coloca que en las lineas que no tiene definidas las unidades se graben en promedio 4 por kilos
		END IF
		ll_unidades = ld_kg * ld_unid_x_kg;
		tot_unidades = tot_unidades + ll_unidades;

	
		FETCH fichos INTO :li_fab, :li_lin, :ld_kg ;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al leer registro de fichos")
	//			Return(1)
			END IF		
		LOOP
		CLOSE fichos;
		dw_lista.SetItem(li_fila, "unid_hoy", tot_unidades)
		
	END IF

NEXT	
//	////////////////////////////////////////////////////////////
	
string newsort

newsort = "co_tipo as, co_concepto as"
dw_lista.SetSort(newsort)
dw_lista.Sort( )
dw_lista.GroupCalc()
dw_lista.SetRedraw(TRUE)
end subroutine

public subroutine wf_cargar_15_6 ();LONG ll_fila,ll_filas
DATASTORE lds_cent15_1,lds_cent15_24,lds_carga_datos

IF ii_centro = 15 and ii_tipo = 1 THEN
	lds_cent15_1 = create datastore
	lds_cent15_1.DataObject = 'ds_report_nivel1_cent15_1'
	lds_cent15_1.SetTransObject(sqlca)
	ll_filas = lds_cent15_1.Retrieve(ii_centro)
	lds_carga_datos = lds_cent15_1
ELSEIF ii_centro = 15 and ii_tipo = 2 THEN
	lds_cent15_24 = create datastore
	lds_cent15_24.DataObject = 'ds_report_nivel1_cent15_24'
	lds_cent15_24.SetTransObject(sqlca)
	ll_filas = lds_cent15_24.Retrieve(ii_centro)
	lds_carga_datos = lds_cent15_24
ELSEIF ii_centro <> 15 THEN	
	ids_telterminada = create datastore
	ids_telterminada.DataObject = 'ds_report_nivel1_tterminada'
	ids_telterminada.SetTransObject(sqlca)
	ll_filas = ids_telterminada.Retrieve(ii_centro)
	lds_carga_datos = ids_telterminada
END IF

FOR ll_fila = 1 to ll_filas
	dw_lista.InsertRow(ll_fila)
	dw_lista.setitem(ll_fila,'co_centro',ii_centro)
	dw_lista.setitem(ll_fila,'de_centro',lds_carga_datos.getitemstring(ll_fila,'de_centro'))
	dw_lista.setitem(ll_fila,'co_concepto',lds_carga_datos.getitemnumber(ll_fila,'co_cpto_bodega'))
	dw_lista.setitem(ll_fila,'de_concepto',lds_carga_datos.getitemstring(ll_fila,'de_cpto_bodega'))
	dw_lista.setitem(ll_fila,'co_tipo',lds_carga_datos.getitemnumber(ll_fila,'tipo'))
	dw_lista.setitem(ll_fila,'kg_hoy',lds_carga_datos.getitemnumber(ll_fila,'ca_kg'))
	dw_lista.setitem(ll_fila,'unid_hoy',lds_carga_datos.getitemnumber(ll_fila,'unidades'))
	dw_lista.setitem(ll_fila,'unid_ayer',lds_carga_datos.getitemnumber(ll_fila,'dia'))
	dw_lista.setitem(ll_fila,'unid_1sem_ant',lds_carga_datos.getitemnumber(ll_fila,'semana'))
	dw_lista.setitem(ll_fila,'unid_2sem_ant',lds_carga_datos.getitemnumber(ll_fila,'semana_ant'))
	dw_lista.setitem(ll_fila,'unid_1mes_ant',lds_carga_datos.getitemnumber(ll_fila,'mes'))
	dw_lista.setitem(ll_fila,'unid_2mes_ant',lds_carga_datos.getitemnumber(ll_fila,'mes_ant'))
	dw_lista.setitem(ll_fila,'responsable',lds_carga_datos.getitemstring(ll_fila,'responsable'))
NEXT
	
//================== Carga Unidades de cada (co_cpto_bodega) ======================

LONG 	  tot_unidades,ll_unidades
Long li_tot_fila,li_fila,li_centro,li_fab, li_lin, li_tipo_cto
DECIMAL ld_kilos_tot,ld_kg,ld_unid_x_kg 

li_tot_fila =  dw_lista.RowCount()

FOR li_fila = 1 TO li_tot_fila
  	 li_centro = dw_lista.GetItemNumber(li_fila,"co_concepto")
	 ld_kilos_tot = dw_lista.GetItemNumber(li_fila,"kg_hoy")
	
	 tot_unidades = 0
	 ll_unidades  = 0
	IF ld_kilos_tot > 0 THEN
		
		DECLARE fichos CURSOR FOR
		 SELECT h.co_fabrica, h.co_linea, c.tipo, sum(m.ca_kg)
		  FROM m_rollo m, h_ordenpd_pt h, m_cpto_bodega c
		 WHERE m.cs_orden_pr_act = h.cs_ordenpd_pt
		   AND m.co_planeador    = c.co_cpto_bodega
			AND m.co_centro 	    = :ii_centro
			AND c.co_cpto_bodega  = :li_centro
			AND ca_kg > 0
		 GROUP BY 1,2,3
		 ORDER BY 1,2,3;
		OPEN fichos;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al abrir el cursor de fichos")
		END IF
		FETCH fichos INTO :li_fab, :li_lin, :li_tipo_cto, :ld_kg ;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer el primer registro de fichos")
		END IF
		DO WHILE SQLCA.SQLCode = 0
			
		IF li_tipo_cto = 3 THEN 
		ELSE
			SELECT MAX(unid_kg)
			  INTO :ld_unid_x_kg
			  FROM m_lineas_agrup
			 WHERE co_fabrica = :li_fab
				AND co_linea_agrup = :li_lin;
			IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg = 0) THEN
				ld_unid_x_kg = 4  //por defecto se graban 4 unidades por kilo en lineas que no se han creado en tabla
			END IF
				ll_unidades = ld_kg * ld_unid_x_kg;
				tot_unidades = tot_unidades + ll_unidades;
		END IF
	
		FETCH fichos INTO :li_fab, :li_lin, :li_tipo_cto, :ld_kg ;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al leer registro de fichos")
	//			Return(1)
			END IF		
		LOOP
		CLOSE fichos;
		dw_lista.SetItem(li_fila, "unid_hoy", tot_unidades)

	END IF
NEXT

//=================================================================================	
	
string newsort

newsort = "co_tipo D, unid_hoy D"
dw_lista.SetSort(newsort)
dw_lista.Sort( )
dw_lista.GroupCalc()
dw_lista.SetRedraw(TRUE)


end subroutine

public subroutine wf_cargar_centropdn ();LONG ll_fila, li_tipo,ll_semana,ll_semana_ant,ll_mes,ll_mes_ant
DECIMAL lde_dia

IF ii_planta = 2 THEN
	li_tipo = 1
ELSE
	li_tipo = 2
END IF
datastore lds_cargcentpdn
lds_cargcentpdn = create datastore
lds_cargcentpdn.DataObject = 'ds_report_nivel1_centropdn'
lds_cargcentpdn.SetTransObject(sqlca)
lds_cargcentpdn.Retrieve(ii_centro,ii_subcentropdn,ii_planta)

long filas

filas = lds_cargcentpdn.RowCount()

FOR ll_fila = 1 to filas
	dw_lista.InsertRow(ll_fila)
	dw_lista.setitem(ll_fila,'co_centro',ii_centro)
	dw_lista.setitem(ll_fila,'de_centro',is_de_centro)
	dw_lista.setitem(ll_fila,'co_subcentro',lds_cargcentpdn.getitemnumber(ll_fila,'co_subcentro_act'))
	dw_lista.setitem(ll_fila,'co_tipo_atributo',lds_cargcentpdn.getitemstring(ll_fila,'co_tipo_atributo'))
	dw_lista.setitem(ll_fila,'co_concepto',lds_cargcentpdn.getitemnumber(ll_fila,'cs_tipo_atributo'))
	dw_lista.setitem(ll_fila,'de_concepto',lds_cargcentpdn.getitemstring(ll_fila,'de_atributo'))
	dw_lista.setitem(ll_fila,'co_tipo',lds_cargcentpdn.getitemnumber(ll_fila,'sw_tipo'))
	//dw_lista.setitem(ll_fila,'kg_hoy',ids_cargcentpdn.getitemnumber(ll_fila,'ca_kg'))
		
		lde_dia 		  = lds_cargcentpdn.getitemnumber(ll_fila,'dia')
		ll_semana 	  = lds_cargcentpdn.getitemnumber(ll_fila,'semana')
		ll_semana_ant = lds_cargcentpdn.getitemnumber(ll_fila,'semana_ant')
		ll_mes        = lds_cargcentpdn.getitemnumber(ll_fila,'mes')
		ll_mes_ant    = lds_cargcentpdn.getitemnumber(ll_fila,'mes_ant')
	
		IF ISNULL(lde_dia) THEN lde_dia = 0
		IF ISNULL(ll_semana) THEN ll_semana = 0
		IF ISNULL(ll_semana_ant) THEN ll_semana_ant = 0
		IF ISNULL(ll_mes) THEN ll_mes = 0
		IF ISNULL(ll_mes_ant) THEN ll_mes_ant = 0
	
	dw_lista.setitem(ll_fila,'unid_hoy',lds_cargcentpdn.getitemnumber(ll_fila,'unidades'))
	dw_lista.setitem(ll_fila,'unid_ayer',lde_dia)
	dw_lista.setitem(ll_fila,'unid_1sem_ant',ll_semana)
	dw_lista.setitem(ll_fila,'unid_2sem_ant',ll_semana_ant)
	dw_lista.setitem(ll_fila,'unid_1mes_ant',ll_mes)
	dw_lista.setitem(ll_fila,'unid_2mes_ant',ll_mes_ant)
NEXT
	
IF lds_cargcentpdn.rowcount() > 0 THEN
	lde_dia 		  = lds_cargcentpdn.getitemnumber(1,'dia')
	ll_semana 	  = lds_cargcentpdn.getitemnumber(1,'semana')
	ll_semana_ant = lds_cargcentpdn.getitemnumber(1,'semana_ant')
	ll_mes        = lds_cargcentpdn.getitemnumber(1,'mes')
	ll_mes_ant    = lds_cargcentpdn.getitemnumber(1,'mes_ant')
END IF
	
IF ISNULL(lde_dia) THEN lde_dia = 0
IF ISNULL(ll_semana) THEN ll_semana = 0
IF ISNULL(ll_semana_ant) THEN ll_semana_ant = 0
IF ISNULL(ll_mes) THEN ll_mes = 0
IF ISNULL(ll_mes_ant) THEN ll_mes_ant = 0

string newsort

newsort = "co_tipo as, co_concepto as"
dw_lista.SetSort(newsort)
dw_lista.Sort( )
dw_lista.GroupCalc()
dw_lista.SetRedraw(TRUE)

end subroutine

public subroutine wf_cargar_corte ();LONG ll_fila

ids_cargcorte = create datastore
ids_cargcorte.DataObject = 'ds_report_nivel1_corte'
ids_cargcorte.SetTransObject(sqlca)
ids_cargcorte.Retrieve(ii_centro)

FOR ll_fila = 1 to ids_cargcorte.RowCount()
	dw_lista.InsertRow(ll_fila)
	dw_lista.setitem(ll_fila,'co_centro',ii_centro)
	dw_lista.setitem(ll_fila,'de_centro',is_de_centro)
	dw_lista.setitem(ll_fila,'co_concepto',ids_cargcorte.getitemnumber(ll_fila,'co_subcentro_pdn'))
 	dw_lista.setitem(ll_fila,'de_concepto',ids_cargcorte.getitemstring(ll_fila,'de_subcentro_pdn'))
// dw_lista.setitem(ll_fila,'co_tipo',ids_cargcorte.getitemnumber(ll_fila,'sw_tipo'))
// dw_lista.setitem(ll_fila,'kg_hoy',ids_cargcorte.getitemnumber(ll_fila,'ca_kg'))
	dw_lista.setitem(ll_fila,'unid_hoy',ids_cargcorte.getitemnumber(ll_fila,'unidades'))
	dw_lista.setitem(ll_fila,'unid_ayer',ids_cargcorte.getitemnumber(ll_fila,'dia'))
	dw_lista.setitem(ll_fila,'unid_1sem_ant',ids_cargcorte.getitemnumber(ll_fila,'semana'))
	dw_lista.setitem(ll_fila,'unid_2sem_ant',ids_cargcorte.getitemnumber(ll_fila,'semana_ant'))
	dw_lista.setitem(ll_fila,'unid_1mes_ant',ids_cargcorte.getitemnumber(ll_fila,'mes'))
	dw_lista.setitem(ll_fila,'unid_2mes_ant',ids_cargcorte.getitemnumber(ll_fila,'mes_ant'))
	
   IF IsNull(dw_lista.GetItemNumber(ll_fila,'kg_hoy')) THEN// CUANDO LOS KILOS SON NULOS LES DA COMO VALOR CERO.
		dw_lista.setitem(ll_fila,'kg_hoy', 0)
	END IF
	
NEXT
	
string newsort

newsort = "co_concepto as"
dw_lista.SetSort(newsort)
dw_lista.Sort()
dw_lista.GroupCalc()
dw_lista.SetRedraw(TRUE)
end subroutine

public subroutine wf_cargar_terceros ();LONG ll_fila,ll_subcentro

ids_terceros = create datastore// Datastore para cargar las unidades, y cada uno de los conceptos de terceros.
ids_terceros.DataObject = 'dtb_reporte_nivel1_kpo'
ids_terceros.SetTransObject(sqlca)
ids_terceros.Retrieve()

datastore lds_unids_terc
lds_unids_terc = create datastore// Datastore para realizar el calculo
lds_unids_terc.DataObject = 'ds_report_nivel1_calc_terceros'
lds_unids_terc.SetTransObject(sqlca)

FOR ll_fila = 1 to ids_terceros.RowCount()
	dw_lista.InsertRow(ll_fila)
	dw_lista.setitem(ll_fila,'co_centro',ii_centro)
	dw_lista.setitem(ll_fila,'de_centro',is_de_centro)
	dw_lista.setitem(ll_fila,'co_subcentro_pdn',ids_terceros.getitemnumber(ll_fila,'co_subcentro_pdn'))
	ll_subcentro = ids_terceros.getitemnumber(ll_fila,'co_subcentro_pdn') 
	dw_lista.setitem(ll_fila,'co_concepto',ll_subcentro)
   dw_lista.setitem(ll_fila,'de_concepto',ids_terceros.getitemstring(ll_fila,'de_subcentro_pdn'))
// dw_lista.setitem(ll_fila,'co_tipo',ids_terceros.getitemnumber(ll_fila,'sw_tipo'))
// dw_lista.setitem(ll_fila,'kg_hoy',ids_terceros.getitemnumber(ll_fila,'ca_kg'))
	dw_lista.setitem(ll_fila,'unid_hoy',ids_terceros.getitemnumber(ll_fila,'unidades'))
		
	lds_unids_terc.Retrieve(1,ll_subcentro,1,today())
	dw_lista.setitem(ll_fila,'unid_ayer',lds_unids_terc.getitemnumber(1,'tot_dia'))
	dw_lista.setitem(ll_fila,'unid_1sem_ant',lds_unids_terc.getitemnumber(1,'tot_semana'))
	dw_lista.setitem(ll_fila,'unid_2sem_ant',lds_unids_terc.getitemnumber(1,'tot_semana_ant'))
	dw_lista.setitem(ll_fila,'unid_1mes_ant',lds_unids_terc.getitemnumber(1,'tot_mes'))
	dw_lista.setitem(ll_fila,'unid_2mes_ant',lds_unids_terc.getitemnumber(1,'tot_mes_ant'))
NEXT
	
string newsort

newsort = "co_concepto as"
dw_lista.SetSort(newsort)
dw_lista.Sort()
dw_lista.GroupCalc()
dw_lista.SetRedraw(TRUE)
end subroutine

public subroutine wf_cargar_gbi ();LONG ll_fila

ids_gbi = create datastore
ids_gbi.DataObject = 'd_tb_unidades_x_atributos'
ids_gbi.SetTransObject(sqlca)
ids_gbi.Retrieve(ii_concentropdn,ii_subcentropdn)

FOR ll_fila = 1 to ids_gbi.RowCount()
	dw_lista.InsertRow(ll_fila)
	dw_lista.setitem(ll_fila,'co_tipo',0)
	dw_lista.setitem(ll_fila,'co_centro',ii_centro)
	dw_lista.setitem(ll_fila,'co_centro_pdn',ii_concentropdn)
	dw_lista.setitem(ll_fila,'co_subcentro_pdn',ii_subcentropdn)
	dw_lista.setitem(ll_fila,'de_centro',is_de_centro)
	dw_lista.setitem(ll_fila,'co_concepto',ids_gbi.getitemnumber(ll_fila,'cs_tipo_atributo'))
   dw_lista.setitem(ll_fila,'de_concepto',ids_gbi.getitemstring(ll_fila,'de_atributo'))
	dw_lista.setitem(ll_fila,'unid_hoy',ids_gbi.getitemnumber(ll_fila,'cantidad'))
	
	dw_lista.setitem(ll_fila,'unid_ayer',ids_gbi.getitemnumber(ll_fila,'dia_ant'))
	dw_lista.setitem(ll_fila,'unid_1sem_ant',ids_gbi.getitemnumber(ll_fila,'semana'))
	dw_lista.setitem(ll_fila,'unid_2sem_ant',ids_gbi.getitemnumber(ll_fila,'semana_ant'))
	dw_lista.setitem(ll_fila,'unid_1mes_ant',ids_gbi.getitemnumber(ll_fila,'mes'))
	dw_lista.setitem(ll_fila,'unid_2mes_ant',ids_gbi.getitemnumber(ll_fila,'mes_ant'))
	
NEXT
	
string newsort

newsort = "co_tipo as,co_concepto as"
dw_lista.SetSort(newsort)
dw_lista.Sort( )
dw_lista.GroupCalc()
dw_lista.SetRedraw(TRUE)
end subroutine

on w_reporte_nivel1_crudo_new.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.st_2=create st_2
this.st_1=create st_1
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.st_2,&
this.st_1,&
this.dw_lista,&
this.gb_1}
end on

on w_reporte_nivel1_crudo_new.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;dw_lista.Retrieve(6)

dw_lista.Modify("DataWindow.Print.Preview=Yes")
dw_lista.Object.num_pagina.Visible = 1// MUESTRA EL N$$HEX1$$da00$$ENDHEX$$MERO DE PAGINAS CUANDO SE ACTIVA LA VISTA PRELIMINAR
end event

event closequery;DISCONNECT;
SQLCA.Lock = "CURSOR STABILITY"
CONNECT USING SQLCA;


end event

type st_2 from statictext within w_reporte_nivel1_crudo_new
integer x = 32
integer y = 2068
integer width = 1431
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Clic derecho en el concepto, para ver el nombre del responsable"
boolean focusrectangle = false
end type

type st_1 from statictext within w_reporte_nivel1_crudo_new
integer x = 32
integer y = 2016
integer width = 2222
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = " Dobleclic en el concepto deseado, para ver el detalle de las telas que no permiten liberar a corte."
boolean focusrectangle = false
end type

type dw_lista from datawindow within w_reporte_nivel1_crudo_new
integer x = 50
integer y = 60
integer width = 3611
integer height = 1924
integer taborder = 10
string title = "none"
string dataobject = "ds_report_nivel1_tterminada"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;String ls_concepto,ls_responsable,ls_co_tipatributo
Long li_result, li_concepto, li_centro, li_co_centro_pdn, li_co_subcentro_pdn,li_tipo,li_co_subcentro
s_base_parametros lstr_parametros
n_cst_reporte_centro_15 luo_reporte

//MUESTRA VENTANA DE ESPERA 
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"

ls_responsable    = dw_lista.GetItemString(Row,'responsable')
ls_concepto       = dw_lista.GetItemString(Row,'de_concepto')
li_tipo 			   = dw_lista.GetItemNumber(Row,'co_tipo')
li_co_subcentro   = dw_lista.GetItemNumber(Row,'co_subcentro')
ls_co_tipatributo = dw_lista.GetItemString(Row,'co_tipo_atributo')

li_result = MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...','Desea consultar el detalle para el concepto: '+ls_concepto, Information!, OKCancel!, 2)

IF li_result = 1 THEN
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro) 
	li_concepto = dw_lista.GetItemNumber(Row,'co_concepto')
	//SE INVOCA EL USER OBJECT PARA CARGAR TABLA TEMPORAL Y MOSTRAR EL REPORTE.
	IF li_concepto = 67 THEN
		IF luo_reporte.of_conceptos_nivel_tintoreria(li_concepto) = 0 THEN
			//ABRIMOS VENTANA MOSTRANDO LOS DATOS DE LA TABLA mv_centro15_nivel2
			lstr_parametros.entero[1] = li_concepto
			lstr_parametros.entero[2] = 1
			lstr_parametros.entero[3] = li_centro
			lstr_parametros.entero[4] = li_co_centro_pdn
			lstr_parametros.entero[5] = li_co_subcentro_pdn
			lstr_parametros.entero[6] = li_tipo
			lstr_parametros.entero[7] = li_co_subcentro
			lstr_parametros.cadena[1] = ls_concepto
			lstr_parametros.cadena[2] = ls_co_tipatributo
			
			OpenSheetWithParm(w_concepto_centro15_nivel2,lstr_parametros, parent)
		END IF
	ELSE
		IF li_concepto = 73 THEN
			IF luo_reporte.f_complemento_compras(li_concepto) = 0 THEN
				//ABRIMOS VENTANA MOSTRANDO LOS DATOS DE LA TABLA mv_centro15_nivel2
				lstr_parametros.entero[1] = li_concepto
				lstr_parametros.entero[2] = 1
				lstr_parametros.cadena[1] = ls_concepto
				lstr_parametros.entero[3] = li_centro
				lstr_parametros.entero[4] = li_co_centro_pdn
				lstr_parametros.entero[5] = li_co_subcentro_pdn
				lstr_parametros.entero[6] = li_tipo
				lstr_parametros.entero[7] = li_co_subcentro
				lstr_parametros.cadena[2] = ls_co_tipatributo
				OpenSheetWithParm(w_concepto_centro15_nivel2, lstr_parametros, parent)
			END IF
		ELSE
			//CARGA PARAMETROS PARA ABRIR EL TERCER NIVEL(Nivel 2) DE CADA CONCEPTO
			li_centro = dw_lista.GetItemNumber(Row,'co_centro')
			li_co_centro_pdn = dw_lista.GetItemNumber(Row,'co_centro_pdn')
			li_co_subcentro_pdn = dw_lista.GetItemNumber(Row,'co_subcentro_pdn')

			lstr_parametros.entero[1] = li_concepto
			lstr_parametros.entero[2] = 2
			lstr_parametros.entero[3] = li_centro
			lstr_parametros.entero[4] = li_co_centro_pdn
			lstr_parametros.entero[5] = li_co_subcentro_pdn
			lstr_parametros.entero[6] = li_tipo
			lstr_parametros.entero[7] = li_co_subcentro
			lstr_parametros.cadena[1] = ls_concepto
			lstr_parametros.cadena[2] = ls_co_tipatributo
			
			OpenSheetWithParm(w_concepto_centro15_nivel2, lstr_parametros, parent)
		END IF
	END IF
END IF

CLOSE(w_retroalimentacion)
end event

event retrieveend;LONG	ll_unidades, tot_unidades
Long	li_cpto, li_fab, li_lin, li_fila, li_tot_fila
DECIMAL	ld_kg,ld_unid_x_kg

li_tot_fila =  dw_lista.RowCount()

FOR li_fila = 1 TO li_tot_fila

	li_cpto = dw_lista.GetItemNumber(li_fila, "m_cpto_bodega_co_cpto_bodega")
	
	tot_unidades = 0
	ll_unidades = 0
	
	DECLARE fichos CURSOR FOR
	 SELECT h.co_fabrica, h.co_linea, sum(m.ca_kg)
     FROM m_rollo m, h_ordenpd_pt h
    WHERE m.cs_orden_pr_act = h.cs_ordenpd_pt
      AND m.co_centro = 15
      AND m.co_planeador = :li_cpto
		AND ca_kg > 0
    GROUP BY 1,2;
	OPEN fichos;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al empezar proceso de c$$HEX1$$e100$$ENDHEX$$lculo de unidades segun kilos, intente de nuevo en unos segundos")
		Return(1)
	END IF
	FETCH fichos INTO :li_fab, :li_lin, :ld_kg ;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer el primer registro en proceso de c$$HEX1$$e100$$ENDHEX$$lculo de unidades segun kilos, intente de nuevo en unos segundos")
		Return(1)
	END IF
	DO WHILE SQLCA.SQLCode = 0
		
	 SELECT MAX(unid_kg)
     INTO :ld_unid_x_kg
     FROM m_lineas_agrup
    WHERE co_fabrica = :li_fab
      AND co_linea_agrup = :li_lin;
   IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
		messagebox('error','linea sin unidades x kilo: ' + string(li_lin) + ' Fabrica: ' + string(li_fab))
   ELSE
      ll_unidades = ld_kg * ld_unid_x_kg;
      tot_unidades = tot_unidades + ll_unidades;
   END IF

	FETCH fichos INTO :li_fab, :li_lin, :ld_kg ;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer registro en proceso de c$$HEX1$$e100$$ENDHEX$$lculo de unidades segun kilos, intente de nuevo en unos segundos")
			Return(1)
		END IF		
	LOOP
	CLOSE fichos;
	dw_lista.SetItem(li_fila, "Unidades", tot_unidades)

NEXT
end event

event rbuttondown;//evento para mostrar el reponsable del concepto en el cual se dio clic derecho
String ls_concepto, ls_responsable, ls_usuario

ls_concepto = This.GetItemString(Row,'de_concepto')
ls_responsable = This.GetItemString(Row,'responsable')

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
	MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n...',Trim(ls_usuario)+' es responsable del concepto: '+Trim(ls_concepto),information!)
End if




end event

event buttonclicked;long ll_bufer, ll_filas, ll_j, li_resultado
string ls_columna, ls_filtro, ls_condicion, ls_tipo_campo,ls_color
s_base_parametros lstr_parametros

ls_columna = mid(dwo.name,4)

IF ib_filtro = FALSE THEN
	IF not isnull(ls_columna) THEN
		if ib_ordenar_ascendente = FALSE THEN
			ls_columna = ls_columna + ' A'
			ib_ordenar_ascendente = TRUE
		ELSE
			ls_columna = ls_columna + ' D'
			ib_ordenar_ascendente = FALSE
		END IF
		li_resultado = dw_lista.setsort(ls_columna)
		li_resultado = dw_lista.sort()
	END IF
ELSE
   OPEN (w_parametros_filtro)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ls_filtro = lstr_parametros.cadena[1]
		ls_condicion = lstr_parametros.cadena[2]
		
		IF isnull(ls_filtro) THEN
			ls_filtro = 'Todos'
		END IF
		
		IF ls_filtro <> 'Todos' THEN
			il_i = il_i + 1
			is_columna[il_i] = ls_columna
		
			ls_tipo_campo = TRIM(dw_lista.getformat(ls_columna))
	
			CHOOSE CASE ls_tipo_campo
				CASE '[General]','[general]','[GENERAL]'	//Caracteres
					   
						ls_condicion = ' '+ls_condicion + ' '
						IF isnull(is_filtrar) or is_filtrar = '' then
							is_filtrar = ls_columna + ls_condicion +'"'+ ls_filtro+'"'
						else
							is_filtrar = is_filtrar +' AND ' +ls_columna + ls_condicion +'"'+ ls_filtro+'"'
						end if					
				CASE	'dd/mm/yyyy hh:mm','dd/mm/yyyy'		// filtro para fechas
					   IF isnull(is_filtrar) or is_filtrar = '' then						
							if ls_tipo_campo= 'dd/mm/yyyy' then
								is_filtrar = 'date ('+ls_columna +')' + ls_condicion +'date("'+ ls_filtro+'")'										
						   else
								is_filtrar = ls_columna + ls_condicion +'date("'+ ls_filtro+'")'																		
						   end if						
					   ELSE
							is_filtrar = is_filtrar +' AND '+ ls_columna + ls_condicion +'date("'+ ls_filtro+'")'																	
						END IF						
				CASE 	'','#,##0.00','0','#,##0','###,###','###','#######', '###,###,##0', '###,###,##0.00', &
					   '###,###,###,##0', '###,###,###,##0.00', '##0.00'	//N$$HEX1$$fa00$$ENDHEX$$mericos
						IF isnull(is_filtrar) or is_filtrar = '' then
							is_filtrar = ls_columna + ls_condicion + ls_filtro			
						ELSE
							is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion + ls_filtro			
						END IF
				END CHOOSE
				dw_lista.SetFilter(is_filtrar)
   			dw_lista.Setredraw(FALSE)
				dw_lista.Filter( )			
				dw_lista.Setredraw(TRUE)	
				ll_filas = dw_lista.rowCount()			
				
				IF dw_lista.rowCount() <= 0 THEN
					messagebox(parent.title,'No existe informaci$$HEX1$$f300$$ENDHEX$$n por el criterio seleccionado')							
					is_filtrar = ''
					dw_lista.SetFilter(is_filtrar)
					dw_lista.Setredraw(FALSE)
					dw_lista.Filter( )			
					dw_lista.Setredraw(TRUE)
					ll_j = 1
					DO WHILE ll_j <= il_i 
						ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
						dw_lista.Modify(ls_columna)				
						ll_j = ll_j + 1
					LOOP
					il_i = 0
					ls_columna = 'cb_'+ls_columna+'.Color = 0'
					dw_lista.Modify( ls_columna)
				else
					ls_columna = 'cb_'+ls_columna+'.Color = 255'
					dw_lista.Modify( ls_columna)
		   	END IF
		ELSE
			ll_j = 1
			DO WHILE ll_j <= il_i 
				ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
				dw_lista.Modify( ls_columna)				
				ll_j = ll_j + 1
			LOOP
			il_i = 0
			is_filtrar = ''
			dw_lista.SetFilter(is_filtrar)
			dw_lista.Setredraw(FALSE)
			dw_lista.Filter( )		
			dw_lista.Setredraw(TRUE)
		END IF
		dw_lista.Sort()
		dw_lista.GroupCalc()		
	END IF
END IF
dw_lista.GroupCalc()		
end event

event clicked;If row > 0 then 
	selectrow(0,false)
	SelectRow(row,true)
END IF
end event

type gb_1 from groupbox within w_reporte_nivel1_crudo_new
integer x = 27
integer y = 8
integer width = 3662
integer height = 2000
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

