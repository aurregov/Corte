HA$PBExportHeader$w_log_errores_liberacion.srw
forward
global type w_log_errores_liberacion from window
end type
type dw_log from datawindow within w_log_errores_liberacion
end type
type gb_1 from groupbox within w_log_errores_liberacion
end type
end forward

global type w_log_errores_liberacion from window
integer width = 3250
integer height = 1880
boolean titlebar = true
string title = "Log Errores"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_log dw_log
gb_1 gb_1
end type
global w_log_errores_liberacion w_log_errores_liberacion

type variables
Long ii_ancho, ii_alto, ii_posx, ii_posy
String is_zoom, is_filtrar
boolean ib_filtro, ib_ordenar_ascendente
Long il_i = 0
string is_columna[]

end variables

on w_log_errores_liberacion.create
this.dw_log=create dw_log
this.gb_1=create gb_1
this.Control[]={this.dw_log,&
this.gb_1}
end on

on w_log_errores_liberacion.destroy
destroy(this.dw_log)
destroy(this.gb_1)
end on

event open;This.Center = True

dw_log.SetTransObject(sqlca)
dw_log.Retrieve(gstr_info_usuario.codigo_usuario)
end event

type dw_log from datawindow within w_log_errores_liberacion
integer x = 64
integer y = 64
integer width = 3077
integer height = 1688
integer taborder = 10
string title = "none"
string dataobject = "dtb_log_errores_liberacion"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

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
		li_resultado = dw_log.setsort(ls_columna)
		li_resultado = dw_log.sort()
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
		
			ls_tipo_campo = TRIM(dw_log.getformat(ls_columna))
	
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
				dw_log.SetFilter(is_filtrar)
   			dw_log.Setredraw(FALSE)
				dw_log.Filter( )			
				dw_log.Setredraw(TRUE)	
				ll_filas = dw_log.rowCount()			
				
				IF dw_log.rowCount() <= 0 THEN
					messagebox(parent.title,'No existe informaci$$HEX1$$f300$$ENDHEX$$n por el criterio seleccionado')							
					is_filtrar = ''
					dw_log.SetFilter(is_filtrar)
					dw_log.Setredraw(FALSE)
					dw_log.Filter( )			
					dw_log.Setredraw(TRUE)
					ll_j = 1
					DO WHILE ll_j <= il_i 
						ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
						dw_log.Modify(ls_columna)				
						ll_j = ll_j + 1
					LOOP
					il_i = 0
					ls_columna = 'cb_'+ls_columna+'.Color = 0'
					dw_log.Modify( ls_columna)
				else
					ls_columna = 'cb_'+ls_columna+'.Color = 255'
					dw_log.Modify( ls_columna)
		   	END IF
		ELSE
			ll_j = 1
			DO WHILE ll_j <= il_i 
				ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
				dw_log.Modify( ls_columna)				
				ll_j = ll_j + 1
			LOOP
			il_i = 0
			is_filtrar = ''
			dw_log.SetFilter(is_filtrar)
			dw_log.Setredraw(FALSE)
			dw_log.Filter( )		
			dw_log.Setredraw(TRUE)
		END IF
		dw_log.Sort()
		dw_log.GroupCalc()		
	END IF
END IF
dw_log.GroupCalc()		
end event

type gb_1 from groupbox within w_log_errores_liberacion
integer x = 37
integer width = 3163
integer height = 1760
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

