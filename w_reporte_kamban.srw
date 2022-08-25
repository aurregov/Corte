HA$PBExportHeader$w_reporte_kamban.srw
forward
global type w_reporte_kamban from w_preview_de_impresion
end type
end forward

global type w_reporte_kamban from w_preview_de_impresion
integer width = 3694
integer height = 2208
end type
global w_reporte_kamban w_reporte_kamban

on w_reporte_kamban.create
call super::create
end on

on w_reporte_kamban.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;DISCONNECT ;
SQLCA.Lock = "Dirty Read"					
CONNECT ;

dw_reporte.settransobject(SQLCA)
dw_reporte.Retrieve()


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

event closequery;call super::closequery;DISCONNECT ;
SQLCA.Lock = "cursor stability"					
CONNECT ;
end event

event resize;dw_reporte.Resize(This.Width - 100, This.Height - 150)
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_kamban
integer y = 32
integer width = 3616
integer height = 1944
string dataobject = "dtb_reporte_kamban_po"
end type

event dw_reporte::buttonclicked;long ll_bufer, ll_filas, ll_j, li_resultado
string ls_columna, ls_filtro, ls_condicion, ls_tipo_campo,ls_color
s_base_parametros lstr_parametros

ls_columna = mid(dwo.name,4)

IF ib_filtro = FALSE THEN
//	IF not isnull(ls_columna) THEN
//		if ib_ordenar_ascendente = FALSE THEN
//			ls_columna = 'co_fabrica A co_linea A co_referencia A cs_secuencia A ' + ls_columna + ' A'
//			ib_ordenar_ascendente = TRUE
//		ELSE
//			ls_columna = 'co_fabrica A co_linea A co_referencia A cs_secuencia A ' + ls_columna + ' D'
//			ib_ordenar_ascendente = FALSE
//		END IF
//		li_resultado = dw_reporte.setsort(ls_columna)
//		li_resultado = dw_reporte.sort()
//	END IF
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
		
			ls_tipo_campo = TRIM(dw_reporte.getformat(ls_columna))
	
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
				dw_reporte.SetFilter(is_filtrar)
//   			dw_reporte.Setredraw(FALSE)
				dw_reporte.Filter( )			
//				dw_reporte.Setredraw(TRUE)	
				ll_filas = dw_reporte.rowCount()			
				
				IF dw_reporte.rowCount() <= 0 THEN
					messagebox(parent.title,'No existe informaci$$HEX1$$f300$$ENDHEX$$n por el criterio seleccionado')							
					is_filtrar = ''
					dw_reporte.SetFilter(is_filtrar)
//					dw_reporte.Setredraw(FALSE)
					dw_reporte.Filter( )			
//					dw_reporte.Setredraw(TRUE)
					ll_j = 1
					DO WHILE ll_j <= il_i 
						ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
						dw_reporte.Modify(ls_columna)				
						ll_j = ll_j + 1
					LOOP
					il_i = 0
					ls_columna = 'cb_'+ls_columna+'.Color = 0'
					dw_reporte.Modify( ls_columna)
				else
					ls_columna = 'cb_'+ls_columna+'.Color = 255'
					dw_reporte.Modify( ls_columna)
		   	END IF
		ELSE
			ll_j = 1
			DO WHILE ll_j <= il_i 
				ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
				dw_reporte.Modify( ls_columna)				
				ll_j = ll_j + 1
			LOOP
			il_i = 0
			is_filtrar = ''
			dw_reporte.SetFilter(is_filtrar)
//			dw_reporte.Setredraw(FALSE)
			dw_reporte.Filter( )		
//			dw_reporte.Setredraw(TRUE)
		END IF
		dw_reporte.Sort()
		dw_reporte.GroupCalc()		
	END IF
END IF
dw_reporte.GroupCalc()		
end event

event dw_reporte::retrieveend;call super::retrieveend;////se genera reporte para los totales
//Long ll_fila, ll_programada, ll_liquidada, ll_loteada, ll_count
//Long li_subcentro,li_secuencia
//String ls_subcentro, ls_usuario
//DataStore lds_totales
//
//lds_totales = Create DataStore
//lds_totales.DataObject = 'dtb_totales_reporte_kamban'
//lds_totales.SetTransObject(sqlca)
//
//
////ls_usuario = gstr_info_usuario.codigo_usuario
//
//This.AcceptText()
//
//FOR ll_fila = 1 TO This.RowCount()
//	//capturo los valores de cada fila
//	li_subcentro  = This.GetItemNumber(ll_fila,'co_subcentro_pdn')
//	ls_subcentro  = This.GetItemString(ll_fila,'de_subcentro_pdn')
//	ll_programada = This.GetItemNumber(ll_fila,'ca_programada')
//	ll_liquidada  = This.GetItemNumber(ll_fila,'ca_liquidada')
//	ll_loteada    = This.GetItemNumber(ll_fila,'ca_loteada')
//	li_secuencia  = This.getItemNumber(ll_fila,'cs_secuencia')
//	
//	IF IsNull(ll_programada) THEN ll_programada = 0
//	IF IsNull(ll_liquidada) THEN ll_liquidada = 0
//	IF IsNull(ll_loteada) THEN ll_loteada = 0
//	
//		
//	lds_totales.InsertRow(0)
//	lds_totales.SetItem(ll_fila,'cs_secuencia',li_secuencia)
//	lds_totales.SetItem(ll_fila,'co_subcentro',li_subcentro)
//	lds_totales.SetItem(ll_fila,'de_subcentro',ls_subcentro)
//	lds_totales.SetItem(ll_fila,'programado',ll_programada)
//	lds_totales.SetItem(ll_fila,'liquidado',ll_liquidada)
//	lds_totales.SetItem(ll_fila,'loteado',ll_loteada)
//	
//	lds_totales.AcceptText()
//			  
//	
//NEXT
//
//
end event

