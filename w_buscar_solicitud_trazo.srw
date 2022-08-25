HA$PBExportHeader$w_buscar_solicitud_trazo.srw
forward
global type w_buscar_solicitud_trazo from w_base_buscar_lista_parametro
end type
type st_2 from statictext within w_buscar_solicitud_trazo
end type
type em_tanda from editmask within w_buscar_solicitud_trazo
end type
type cb_buscar from commandbutton within w_buscar_solicitud_trazo
end type
type ddlb_tipo from dropdownlistbox within w_buscar_solicitud_trazo
end type
type st_3 from statictext within w_buscar_solicitud_trazo
end type
type em_linea from editmask within w_buscar_solicitud_trazo
end type
type st_4 from statictext within w_buscar_solicitud_trazo
end type
type em_puesto from editmask within w_buscar_solicitud_trazo
end type
type em_referencia from editmask within w_buscar_solicitud_trazo
end type
type st_5 from statictext within w_buscar_solicitud_trazo
end type
type em_molderia from editmask within w_buscar_solicitud_trazo
end type
type st_6 from statictext within w_buscar_solicitud_trazo
end type
type cb_imprimir from commandbutton within w_buscar_solicitud_trazo
end type
end forward

global type w_buscar_solicitud_trazo from w_base_buscar_lista_parametro
integer width = 3374
integer height = 1292
string title = "Buscar Trazos Pendientes"
st_2 st_2
em_tanda em_tanda
cb_buscar cb_buscar
ddlb_tipo ddlb_tipo
st_3 st_3
em_linea em_linea
st_4 st_4
em_puesto em_puesto
em_referencia em_referencia
st_5 st_5
em_molderia em_molderia
st_6 st_6
cb_imprimir cb_imprimir
end type
global w_buscar_solicitud_trazo w_buscar_solicitud_trazo

type variables
String is_filtrar
string is_columna[]
long il_i = 0
boolean ib_ordenar_ascendente, ib_filtro


end variables

on w_buscar_solicitud_trazo.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_tanda=create em_tanda
this.cb_buscar=create cb_buscar
this.ddlb_tipo=create ddlb_tipo
this.st_3=create st_3
this.em_linea=create em_linea
this.st_4=create st_4
this.em_puesto=create em_puesto
this.em_referencia=create em_referencia
this.st_5=create st_5
this.em_molderia=create em_molderia
this.st_6=create st_6
this.cb_imprimir=create cb_imprimir
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_tanda
this.Control[iCurrent+3]=this.cb_buscar
this.Control[iCurrent+4]=this.ddlb_tipo
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_linea
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.em_puesto
this.Control[iCurrent+9]=this.em_referencia
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.em_molderia
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.cb_imprimir
end on

on w_buscar_solicitud_trazo.destroy
call super::destroy
destroy(this.st_2)
destroy(this.em_tanda)
destroy(this.cb_buscar)
destroy(this.ddlb_tipo)
destroy(this.st_3)
destroy(this.em_linea)
destroy(this.st_4)
destroy(this.em_puesto)
destroy(this.em_referencia)
destroy(this.st_5)
destroy(this.em_molderia)
destroy(this.st_6)
destroy(this.cb_imprimir)
end on

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_solicitud_trazo
integer x = 9
integer width = 261
string text = "Cons Trazo:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_solicitud_trazo
integer x = 270
integer y = 36
integer width = 274
maskdatatype maskdatatype = numericmask!
string mask = "########"
end type

event em_dato::modified;cb_buscar.TriggerEvent(Clicked!)
end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_solicitud_trazo
integer x = 910
integer y = 912
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_solicitud_trazo
integer x = 1541
integer y = 1020
integer taborder = 110
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_solicitud_trazo
integer x = 919
integer y = 1020
integer taborder = 40
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"h_trazos_pend_cs_trazo")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_solicitud_trazo
integer x = 23
integer width = 3282
integer height = 724
integer taborder = 100
string dataobject = "dtb_buscar_trazos_solicitados"
end type

event dw_lista::buttonclicked;Long ll_bufer, ll_filas, ll_j
string ls_columna, ls_filtro, ls_condicion, ls_tipo_campo,ls_color, ls_valsuperior
s_base_parametros lstr_parametros

ls_columna = mid(dwo.name,4)

IF ib_filtro = FALSE THEN
	ls_columna = mid(dwo.name,4)
	
	IF not isnull(ls_columna) THEN
		dw_lista.setsort(ls_columna)
		dw_lista.sort()
		dw_lista.Setredraw(TRUE)	
	END IF
ELSE
   OPEN (w_parametros_filtro)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ls_filtro = lstr_parametros.cadena[1]
		ls_condicion = TRIM(lstr_parametros.cadena[2])		
		ls_valsuperior = lstr_parametros.cadena[3]
		
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
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = ls_columna + ls_condicion + '"' + ls_filtro + '"' + " AND " + ls_valsuperior
							ELSE
								IF ls_condicion = ' Like ' THEN
									is_filtrar = ls_columna + ls_condicion +'"'+ ls_filtro + '%'+'"'
								ELSE
									is_filtrar = ls_columna + ls_condicion +'"'+ ls_filtro+'"'
								END IF
							END IF
						ELSE
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion + '"' + ls_filtro + '"' + ' AND ' + '"' + ls_valsuperior + '"'
							ELSE							
								IF ls_condicion = ' Like ' THEN
									is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion +'"'+ ls_filtro+'%'+'"'
								ELSE									
									is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion +'"'+ ls_filtro+'"'
								END IF
							END IF							
						end if							
				CASE	'dd/mm/yyyy hh:mm'	// filtro para fechas
					   IF isnull(is_filtrar) or is_filtrar = '' then						
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = ls_columna + ' ' + ls_condicion + '"' + ls_filtro + '" AND "' + ls_valsuperior + '"'
							ELSE
								is_filtrar = ls_columna + ' ' + ls_condicion + '"' + ls_filtro+ '"'
							END IF
						else
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = is_filtrar + ' AND ' + ls_columna + ' ' + ls_condicion + '"' + ls_filtro + '" AND "' + ls_valsuperior + '"'
							ELSE
								is_filtrar = is_filtrar + ' AND ' + ls_columna + ' ' + ls_condicion + '"' + ls_filtro+ '"'
							END IF
						end if						
				CASE	'dd/mm/yyyy'		// filtro para fechas
					   IF isnull(is_filtrar) or is_filtrar = '' then						
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = 'date (' + ls_columna + ') ' + ls_condicion + ' date("' + ls_filtro + '") AND ' + 'date("' + ls_valsuperior + '")'
							ELSE
								is_filtrar = 'date ('+ls_columna +')' + ls_condicion +'date("'+ ls_filtro+'")'										
							END IF
						else
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = is_filtrar + ' AND date (' + ls_columna + ') ' + ls_condicion + ' date("' + ls_filtro + '") AND ' + 'date("' + ls_valsuperior + '")'
							ELSE
								is_filtrar = is_filtrar + ' AND ' + ls_columna + ls_condicion +'date("'+ ls_filtro+'")'																		
							END IF
						end if												
				CASE 	'','#,##0','#,##0.00','0','#,##0','###,###','###','#######','#####','#########','###,###,###'  //N$$HEX1$$fa00$$ENDHEX$$mericos
						IF isnull(is_filtrar) or is_filtrar = '' then
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = ls_columna + ls_condicion + ls_filtro + ' AND ' + ls_valsuperior
							ELSE
								is_filtrar = ls_columna + ls_condicion + ls_filtro			
							END IF
						ELSE
							IF Trim(ls_condicion) = 'Between' THEN
								is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion + ls_filtro + ' AND ' + ls_valsuperior
							ELSE
								is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion + ls_filtro			
							END IF
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
						ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 8388608'
						dw_lista.Modify( ls_columna)				
						ll_j = ll_j + 1
					LOOP
					il_i = 0
					ls_columna = 'cb_'+ls_columna+'.Color = 8388608'
					dw_lista.Modify( ls_columna)
				else
					ls_columna = 'cb_'+ls_columna+'.Color = 255'
					dw_lista.Modify( ls_columna)
		   	END IF
		ELSE
			ll_j = 1
			DO WHILE ll_j <= il_i 
				ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 8388608'
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
	END IF
END IF
end event

type st_2 from statictext within w_buscar_solicitud_trazo
integer x = 562
integer y = 40
integer width = 137
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Tand:"
boolean focusrectangle = false
end type

type em_tanda from editmask within w_buscar_solicitud_trazo
integer x = 686
integer y = 36
integer width = 507
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###############"
end type

event modified;cb_buscar.TriggerEvent(Clicked!)
end event

type cb_buscar from commandbutton within w_buscar_solicitud_trazo
integer x = 3113
integer y = 28
integer width = 247
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;long		ll_consec_trazo, ll_referencia
String 	ls_cod_bar, ls_prueba, ls_molderia
Long	li_estado, li_linea, li_puesto

IF len(trim(em_dato.text)) = 0 THEN
	ll_consec_trazo = 0
ELSE
	ll_consec_trazo = long(em_dato.text)
END IF

IF len(trim(em_tanda.text)) = 0 THEN
	ls_cod_bar = ''
ELSE
	ls_cod_bar = String(em_tanda.text)
END IF

ls_prueba = ddlb_tipo.Text
IF ls_prueba = 'Creado' THEN
	li_estado = 1
ELSE
	li_estado = 0
END IF

IF ls_prueba = 'En proceso' THEN
	li_estado = 3
END IF

IF ls_prueba = 'Dibujando' THEN
	li_estado = 4
END IF


IF len(trim(em_linea.text)) = 0 THEN
	li_linea = 0
ELSE
	li_linea = long(em_linea.text)
END IF

IF len(trim(em_puesto.text)) = 0 THEN
	li_puesto = 0
ELSE
	li_puesto = Long(em_puesto.text)
END IF

IF len(trim(em_referencia.text)) = 0 THEN
	ll_referencia = 0
ELSE
	ll_referencia = Long(em_referencia.text)
END IF

IF len(trim(em_molderia.text)) = 0 THEN
	ls_molderia = ''
ELSE
	ls_molderia = String(em_molderia.text)
END IF



//SetPointer(HourGlass!)
DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;
dw_lista.SetTransObject(SQLCA)
//
dw_lista.visible = true
dw_lista.Retrieve(ll_consec_trazo,ls_cod_bar,li_linea, li_puesto,ll_referencia,ls_molderia,li_estado)
SetPointer(Arrow!)

end event

type ddlb_tipo from dropdownlistbox within w_buscar_solicitud_trazo
integer x = 1897
integer y = 36
integer width = 393
integer height = 252
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
string item[] = {"Sin Crear","Creado","En proceso","Dibujando"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_buscar_solicitud_trazo
integer x = 1211
integer y = 40
integer width = 146
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Line:"
boolean focusrectangle = false
end type

type em_linea from editmask within w_buscar_solicitud_trazo
integer x = 1312
integer y = 36
integer width = 142
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type st_4 from statictext within w_buscar_solicitud_trazo
integer x = 2821
integer y = 40
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Puesto"
boolean focusrectangle = false
end type

type em_puesto from editmask within w_buscar_solicitud_trazo
integer x = 2985
integer y = 36
integer width = 119
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_referencia from editmask within w_buscar_solicitud_trazo
integer x = 1550
integer y = 36
integer width = 325
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type st_5 from statictext within w_buscar_solicitud_trazo
integer x = 1472
integer y = 40
integer width = 78
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Ref:"
boolean focusrectangle = false
end type

type em_molderia from editmask within w_buscar_solicitud_trazo
integer x = 2446
integer y = 36
integer width = 343
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "aaaaaaaaaaaa"
end type

type st_6 from statictext within w_buscar_solicitud_trazo
integer x = 2304
integer y = 40
integer width = 142
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Molde:"
boolean focusrectangle = false
end type

type cb_imprimir from commandbutton within w_buscar_solicitud_trazo
integer x = 2921
integer y = 1020
integer width = 306
integer height = 144
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Imprimir"
end type

event clicked;

dw_lista.setFocus()
OpenWithParm(w_opciones_impresion, dw_lista)
end event

