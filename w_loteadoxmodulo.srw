HA$PBExportHeader$w_loteadoxmodulo.srw
forward
global type w_loteadoxmodulo from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_loteadoxmodulo
end type
type cb_recuperar from commandbutton within w_loteadoxmodulo
end type
end forward

global type w_loteadoxmodulo from w_preview_de_impresion
integer width = 3657
integer height = 1988
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_loteadoxmodulo w_loteadoxmodulo

on w_loteadoxmodulo.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_loteadoxmodulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

event open;This.x = 1
This.y = 1

DISCONNECT ;
SQLCA.Lock = "Dirty Read"					
CONNECT ;
dw_reporte.visible =False

dw_reporte.settransobject(sqlca)
dw_criterio.settransobject(sqlca)

dw_criterio.InsertRow(0)

dw_criterio.SetItem(1,'fe_inicial',Date(Today()))
dw_criterio.SetItem(1,'fe_final',Date(Today()))
dw_criterio.SetItem(1,'co_modulo',0)

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

end event

event closequery;call super::closequery;DISCONNECT ;
SQLCA.Lock = "cursor stability"					
CONNECT ;

end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_loteadoxmodulo
integer y = 180
integer width = 3561
integer height = 1560
string dataobject = "dtb_loteado_por_modulo"
end type

event dw_reporte::retrieveend;call super::retrieveend;Long li_co_fab, li_co_linea, li_personas, li_modulos
Long ll_co_referencia, ll_co_centro, ll_fila, ll_resta, ll_segundos, ll_ordencorte
Decimal{2} ld_acumula, ld_tiempo, ldc_cantidad
DateTime ldt_fe_inicial, ldt_fe_final, ldt_fe_actual
Time lt_fe_resta, lt_inicial, lt_final
Date ld_inicial, ld_final
String	ls_po




dw_criterio.AcceptText()

ldt_fe_inicial = dw_criterio.GetItemDateTime(1,'fe_inicial')
ldt_fe_final   = dw_criterio.GetItemDateTime(1,'fe_final')
li_personas    = dw_criterio.GetItemNumber(1,'personas')

//determina si la fecha final es superior a la actual
ldt_fe_actual = f_fecha_servidor()

If ldt_fe_final > ldt_fe_actual Then
	ldt_fe_final = ldt_fe_actual
End if

ld_inicial = Date(ldt_fe_inicial)
ld_final = Date(ldt_fe_final)

//saco los segundos de los dias
If ld_inicial = ld_final Then
	ll_segundos = 0
Else
	ll_segundos = DaysAfter(ld_inicial, ld_final)
	If ll_segundos > 1 Then
		ll_segundos -= ll_segundos
		ll_segundos = ll_segundos * 24 //obtenga las horas
		ll_segundos = ll_segundos * 60 //obtengo los minutos
		ll_segundos = ll_segundos * 60 //obtengo los segundos
	Else
		
	End if
End if


lt_final = Time(ldt_fe_final)
lt_inicial = Time(ldt_fe_inicial)

If ll_segundos = 0 Then
	If lt_final > lt_inicial Then
		ll_resta = SecondsAfter(lt_inicial ,lt_final)
	Else
		ll_resta = SecondsAfter(lt_final, lt_inicial)	
	End if
Else
	ll_resta = SecondsAfter(lt_inicial,23:59:00)
	ll_resta += SecondsAfter(00:00:00,lt_final)
End if

ll_resta = (ll_resta + ll_segundos) / 60

//por pedido de Sandra Giraldo y javier Garcia se controla que el turno no tenga mas
//de 450 minutos
//jcrm
//agosto 29 de 2008
IF ll_resta > 450 THEN ll_resta = 450

ll_resta = ll_resta * li_personas

For ll_fila = 1 To This.RowCount()

   li_co_fab = This.GetItemNumber(ll_fila,'co_fabrica')
	li_co_linea = This.GetItemNumber(ll_fila,'co_linea')
	ll_co_referencia = This.getItemNumber(ll_fila,'co_referencia')
   ll_ordencorte = This.getItemNumber(ll_fila,'cs_ordencorte')
	ls_po			=  This.getItemString(ll_fila,'po')
	
	DECLARE cur_tiempos CURSOR FOR  
//		  SELECT DISTINCT dt_ficha_tiempos.cod_cc,   
//					dt_ficha_tiempos.tioperacion  
//			 FROM dt_ficha_tiempos  
//			WHERE ( dt_ficha_tiempos.co_fabrica 	= :li_co_fab ) AND  
//					( dt_ficha_tiempos.co_linea 		= :li_co_linea ) AND  
//					( dt_ficha_tiempos.co_referencia = :ll_co_referencia ) AND  
//					( dt_ficha_tiempos.co_calidad = 1 ) AND  
//					( dt_ficha_tiempos.cod_cc in(027801,047801));


				SELECT DISTINCT co_centro_pdn,
						 ti_total  
			  	  FROM dt_fichatiempos_cs  
			    WHERE ( dt_fichatiempos_cs.co_fabrica 	= :li_co_fab ) AND  
					    ( dt_fichatiempos_cs.co_linea 		= :li_co_linea ) AND  
					    ( dt_fichatiempos_cs.co_referencia = :ll_co_referencia ) AND  
					    ( dt_fichatiempos_cs.co_calidad = 1 ) AND  
					    ( dt_fichatiempos_cs.co_centro_pdn = 1 ) and
					    ( dt_fichatiempos_cs.co_subcentro_pdn = 3);	
				  OPEN cur_tiempos;		
											
		  ld_acumula = 0													
		  FETCH cur_tiempos INTO  :ll_co_centro, :ld_tiempo ; 
		  DO WHILE SQLCA.SQLCODE = 0
				ld_acumula = ld_acumula + ld_tiempo	
					
				FETCH cur_tiempos INTO  :ll_co_centro, :ld_tiempo ; 
		  LOOP
		CLOSE cur_tiempos;
		
		This.SetItem(ll_fila,'volumen',ld_acumula)
		This.SetItem(ll_fila,'minutos_disponibles',ll_resta)
		
		
		
	//buscamos las unidades loteadas	
	SELECT sum(ca_loteada)
	  INTO :ldc_cantidad
	  FROM m_lotes_conf
	 WHERE cs_ordencorte = :ll_ordencorte AND
	 		 co_fabrica = :li_co_fab AND
	       fe_loteo > :ldt_fe_inicial AND
			 fe_loteo < :ldt_fe_final AND
			 co_linea = :li_co_linea AND
			 co_referencia = :ll_co_referencia AND
			 po = :ls_po;
		

	This.SetItem(ll_fila,'ca_actual',ldc_cantidad)		 
Next		
		
This.Visible = True	
	
end event

type dw_criterio from datawindow within w_loteadoxmodulo
integer x = 9
integer y = 20
integer width = 2629
integer height = 140
integer taborder = 10
boolean bringtotop = true
string dataobject = "dff_criterio_loteopormodulo"
boolean border = false
end type

type cb_recuperar from commandbutton within w_loteadoxmodulo
integer x = 2926
integer y = 40
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
boolean default = true
end type

event clicked;Long li_tipoprod,li_centro,li_subcentro, li_modulo
Datetime   ldt_fe_inicial, ldt_fe_final
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

dw_criterio.AcceptText()

li_tipoprod = luo_constantes.of_consultar_numerico("PRENDAS")

IF li_tipoprod = -1 THEN
	Return 0
END IF

li_centro = luo_constantes.of_consultar_numerico("CENTRO CORTE")

IF li_centro = -1 THEN
	Return 0
END IF

li_subcentro = luo_constantes.of_consultar_numerico("SUBCENTRO PREPARACIO")

IF li_subcentro = -1 THEN
	Return 0
END IF

ldt_fe_inicial = dw_criterio.GetItemDateTime(1, "fe_inicial")
ldt_fe_final = dw_criterio.GetItemDateTime(1, "fe_final")
li_modulo = dw_criterio.GetItemNumber(1, "co_modulo")

dw_reporte.Retrieve( ldt_fe_inicial, ldt_fe_final, li_modulo,li_tipoprod,li_centro,li_subcentro)

end event

