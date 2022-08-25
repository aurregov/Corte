HA$PBExportHeader$w_act_fechas_reposo_x_lib.srw
forward
global type w_act_fechas_reposo_x_lib from window
end type
type cb_grabar from commandbutton within w_act_fechas_reposo_x_lib
end type
type dw_reporte from datawindow within w_act_fechas_reposo_x_lib
end type
end forward

global type w_act_fechas_reposo_x_lib from window
integer x = 5
integer y = 4
integer width = 2185
integer height = 876
boolean titlebar = true
string title = "Fechas De Reposo O.C"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 79741120
event ue_imprimir pbm_custom01
event ue_preliminar pbm_custom02
event ue_regleta pbm_custom03
event ue_zoom pbm_custom04
event ue_paganterior pbm_custom05
event ue_pagsiguiente pbm_custom06
event ue_filtro pbm_custom07
event type long ue_salvar ( )
cb_grabar cb_grabar
dw_reporte dw_reporte
end type
global w_act_fechas_reposo_x_lib w_act_fechas_reposo_x_lib

type variables
Long ii_ancho, ii_alto, ii_posx, ii_posy
String is_zoom, is_filtrar
boolean ib_filtro, ib_ordenar_ascendente
long il_i = 0
string is_columna[]
end variables

event ue_imprimir;dw_reporte.setFocus()
OpenWithParm(w_opciones_impresion, dw_reporte)

end event

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

event ue_filtro;IF ib_filtro = FALSE THEN
	ib_filtro = TRUE
ELSE 
	ib_filtro = FALSE
END IF
end event

event type long ue_salvar();dw_reporte.saveas()
Return 1
end event

event open;s_base_parametros s_parametros
String ls_nombredw, ls_wparametros
Long ll_liberacion



s_parametros   = Message.PowerObjectParm
ll_liberacion  = s_parametros.entero[1]

dw_reporte.settransobject(sqlca)


IF dw_reporte.retrieve(ll_liberacion) <= 0 THEN
	Messagebox("Aviso","No se encontro informaci$$HEX1$$f300$$ENDHEX$$n para la liberaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_liberacion))
	RETURN
END IF


end event

on w_act_fechas_reposo_x_lib.create
this.cb_grabar=create cb_grabar
this.dw_reporte=create dw_reporte
this.Control[]={this.cb_grabar,&
this.dw_reporte}
end on

on w_act_fechas_reposo_x_lib.destroy
destroy(this.cb_grabar)
destroy(this.dw_reporte)
end on

event resize;dw_reporte.Resize(This.Width - 100, This.Height - 250)
end event

type cb_grabar from commandbutton within w_act_fechas_reposo_x_lib
integer x = 41
integer y = 12
integer width = 279
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar"
end type

event clicked;IF dw_reporte.AcceptText() = -1 THEN
		Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_reporte.Update() = -1 THEN
		ROLLBACK;
		Messagebox("Aviso","Ocurrio un incnveniente al actualizar la informaci$$HEX1$$f300$$ENDHEX$$n")
	   RETURN
	ELSE
		COMMIT;
		Messagebox("Aviso","Se guardo con exito la informaci$$HEX1$$f300$$ENDHEX$$n")
	END IF
END IF
end event

type dw_reporte from datawindow within w_act_fechas_reposo_x_lib
integer x = 41
integer y = 112
integer width = 2089
integer height = 628
integer taborder = 30
boolean titlebar = true
string title = "Fechas de reposo"
string dataobject = "dtb_modificar_fecha_fin_reposo_lib"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;Long ll_bufer, ll_filas, ll_j, li_resultado
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
		li_resultado = dw_reporte.setsort(ls_columna)
		li_resultado = dw_reporte.sort()
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
		
			ls_tipo_campo = TRIM(dw_reporte.getformat(ls_columna))
	
			CHOOSE CASE ls_tipo_campo
				CASE '[General]'//Caracteres
					   
						ls_condicion = ' '+ls_condicion + ' '
						IF isnull(is_filtrar) or is_filtrar = '' then
							is_filtrar = ls_condicion + '(' + ls_columna + ',' + '"' +ls_filtro+ '" )' 
						else
							is_filtrar = is_filtrar + ' AND ' + ls_condicion + '(' + ls_columna + ',' + '"' +ls_filtro+ '" )' 
						end if			
				CASE '[general]','[GENERAL]'	//Caracteres
					   
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
   			dw_reporte.Setredraw(FALSE)
				dw_reporte.Filter( )			
				dw_reporte.Setredraw(TRUE)	
				ll_filas = dw_reporte.rowCount()			
				
				IF dw_reporte.rowCount() <= 0 THEN
					messagebox(parent.title,'No existe informaci$$HEX1$$f300$$ENDHEX$$n por el criterio seleccionado')							
					is_filtrar = ''
					dw_reporte.SetFilter(is_filtrar)
					dw_reporte.Setredraw(FALSE)
					dw_reporte.Filter( )			
					dw_reporte.Setredraw(TRUE)
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
			dw_reporte.Setredraw(FALSE)
			dw_reporte.Filter( )		
			dw_reporte.Setredraw(TRUE)
		END IF
		dw_reporte.Sort()
		dw_reporte.GroupCalc()		
	END IF
END IF
end event

