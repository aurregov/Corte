HA$PBExportHeader$w_reporte_kamban_corte_new.srw
forward
global type w_reporte_kamban_corte_new from w_base_simple
end type
type cb_buscar from commandbutton within w_reporte_kamban_corte_new
end type
type em_fabrica from editmask within w_reporte_kamban_corte_new
end type
type em_linea from editmask within w_reporte_kamban_corte_new
end type
type em_referencia from editmask within w_reporte_kamban_corte_new
end type
type em_op from editmask within w_reporte_kamban_corte_new
end type
type em_oc from editmask within w_reporte_kamban_corte_new
end type
type st_1 from statictext within w_reporte_kamban_corte_new
end type
type st_2 from statictext within w_reporte_kamban_corte_new
end type
type st_3 from statictext within w_reporte_kamban_corte_new
end type
type st_4 from statictext within w_reporte_kamban_corte_new
end type
type st_5 from statictext within w_reporte_kamban_corte_new
end type
type st_6 from statictext within w_reporte_kamban_corte_new
end type
type cb_grupo from commandbutton within w_reporte_kamban_corte_new
end type
type st_7 from statictext within w_reporte_kamban_corte_new
end type
type em_cliente from editmask within w_reporte_kamban_corte_new
end type
end forward

global type w_reporte_kamban_corte_new from w_base_simple
integer width = 3749
integer height = 2544
string title = "Reporte Kamban de Corte"
string menuname = "m_vista_previa_filtro"
event ue_imprimir ( )
event ue_preliminar ( )
event ue_guardar_como ( )
cb_buscar cb_buscar
em_fabrica em_fabrica
em_linea em_linea
em_referencia em_referencia
em_op em_op
em_oc em_oc
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
cb_grupo cb_grupo
st_7 st_7
em_cliente em_cliente
end type
global w_reporte_kamban_corte_new w_reporte_kamban_corte_new

type variables
string	is_zoom

Long il_year,il_week
end variables

event ue_imprimir();dw_maestro.setFocus()
OpenWithParm(w_opciones_impresion, dw_maestro)

end event

event ue_preliminar();SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_maestro.Describe("DataWindow.Print.Preview")
if ls_resultado <> 'yes' then
	dw_maestro.Modify("DataWindow.Print.Preview=Yes")
	dw_maestro.Modify("DataWindow.Print.Preview.Rulers=Yes")
else
	dw_maestro.Modify("DataWindow.Print.Preview.Rulers=No")
	dw_maestro.Modify("DataWindow.Print.Preview.Zoom="+is_zoom)	
	dw_maestro.Modify("DataWindow.Print.Preview=No")
end if

SetPointer(Arrow!)
end event

event ue_guardar_como();long ll_filas

ll_filas = dw_maestro.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_maestro.SaveAs("",PSReport! ,false)
END IF
end event

on w_reporte_kamban_corte_new.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_previa_filtro" then this.MenuID = create m_vista_previa_filtro
this.cb_buscar=create cb_buscar
this.em_fabrica=create em_fabrica
this.em_linea=create em_linea
this.em_referencia=create em_referencia
this.em_op=create em_op
this.em_oc=create em_oc
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.cb_grupo=create cb_grupo
this.st_7=create st_7
this.em_cliente=create em_cliente
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.em_fabrica
this.Control[iCurrent+3]=this.em_linea
this.Control[iCurrent+4]=this.em_referencia
this.Control[iCurrent+5]=this.em_op
this.Control[iCurrent+6]=this.em_oc
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.cb_grupo
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.em_cliente
end on

on w_reporte_kamban_corte_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.em_fabrica)
destroy(this.em_linea)
destroy(this.em_referencia)
destroy(this.em_op)
destroy(this.em_oc)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.cb_grupo)
destroy(this.st_7)
destroy(this.em_cliente)
end on

event ue_grabar;//no
end event

event closequery;//
end event

type dw_maestro from w_base_simple`dw_maestro within w_reporte_kamban_corte_new
integer x = 0
integer y = 84
integer width = 3689
integer height = 2176
integer taborder = 90
string dataobject = "dw_reporte_kamban_po_new"
boolean resizable = true
end type

event dw_maestro::retrieveend;call super::retrieveend;Long		li_result, pos, li_fabrica, li_linea, ll_co_centro, ll_fila, li_subcentro, li_borda, li_estampa, li_result2
Long		li_fabrica_old, li_linea_old
LONG			ll_referencia, ll_referencia_old
DECIMAL{3}	ld_totmin, ld_tiempo, ld_acumula, ld_cantidad
STRING		ls_proceso	
DataStore	lds_dgr_buscar_proceso_estam_borda_x_ref
s_base_parametros lstr_parametros_retro

//  

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando tiempos"
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)        
	
lds_dgr_buscar_proceso_estam_borda_x_ref	= Create DataStore
lds_dgr_buscar_proceso_estam_borda_x_ref.DataObject = 'dgr_buscar_proceso_estam_borda_x_ref'
lds_dgr_buscar_proceso_estam_borda_x_ref.SetTransObject(sqlca)
	
	
li_result = dw_maestro.RowCount()

li_fabrica_old = 0
li_linea_old = 0
ll_referencia_old = 0

FOR pos = 1 TO li_result

	li_fabrica   = dw_maestro.GetItemNumber(pos, "co_fabrica")
	li_linea = dw_maestro.GetItemNumber(pos, "co_linea")
	ll_referencia = dw_maestro.GetItemNumber(pos, "co_referencia")
	ld_cantidad = dw_maestro.GetItemNumber(pos, "ca_prog_oc")
	
	IF li_fabrica = li_fabrica_old AND li_linea = li_linea_old AND ll_referencia = ll_referencia_old THEN
		//ya se busco el tiempo,  se continua con la siguiente referencia
	ELSE
		DECLARE cur_tiempos CURSOR FOR  
			SELECT DISTINCT co_centro_pdn,
					 ti_total  
			  FROM dt_fichatiempos_cs  
			 WHERE ( dt_fichatiempos_cs.co_fabrica 	= :li_fabrica ) AND  
					 ( dt_fichatiempos_cs.co_linea 		= :li_linea ) AND  
					 ( dt_fichatiempos_cs.co_referencia = :ll_referencia ) AND  
					 ( dt_fichatiempos_cs.co_calidad = 1 ) AND  
					 ( dt_fichatiempos_cs.co_centro_pdn = 1 ) AND
					 ( dt_fichatiempos_cs.ti_total > 0 ) and
					 ( dt_fichatiempos_cs.co_subcentro_pdn not in (8,14));		
				
			OPEN 	cur_tiempos;	
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al abrir proceso de cargar los tiempos")
				Close(w_retroalimentacion)
				Return
			END IF
	
											
		  ld_acumula = 0													
		  FETCH cur_tiempos INTO  :ll_co_centro, :ld_tiempo ; 
		  IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al cargar primer registro para cargar los tiempos")
				Close(w_retroalimentacion)
				Return
		  END IF
	
		  DO WHILE SQLCA.SQLCODE = 0
				ld_acumula = ld_acumula + ld_tiempo	
					
				FETCH cur_tiempos INTO  :ll_co_centro, :ld_tiempo ; 
			  IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al cargar ultimo registro para cargar los tiempos")
				Close(w_retroalimentacion)
				Return
			  END IF
	
		  LOOP
		CLOSE cur_tiempos;
		
		dw_maestro.SetItem(pos, "tiempo", ld_acumula)	
	//	li_borda = 0
	//	li_estampa = 0
	//	 
	//	li_result2 = lds_dgr_buscar_proceso_estam_borda_x_ref.Retrieve(li_fabrica,li_linea,ll_referencia)
	//	FOR ll_fila = 1 To li_result2	
	//		li_subcentro = lds_dgr_buscar_proceso_estam_borda_x_ref.GetItemNumber(ll_fila, "co_subcentro_pdn")
	//		IF li_subcentro = 8 THEN
	//			li_estampa = 1
	//		END IF
	//		IF li_subcentro = 14 THEN
	//			li_borda = 1
	//		END IF
	//
	//	NEXT
	//	
	//	IF li_borda = 1 AND li_estampa = 1 THEN
	//		ls_proceso = 'BORDA-ESTAMPA'
	//	ELSE
	//		IF li_borda = 1 THEN
	//			ls_proceso = 'BORDA'
	//		ELSE
	//			IF li_estampa = 1  THEN
	//				ls_proceso = 'ESTAMPA'
	//			ELSE	
	//				ls_proceso = ''
	//			END IF
	//		END IF
	//	END IF
	//		
	//	dw_maestro.SetItem(pos, "proceso", ls_proceso)		
	//			 
	//		
	li_fabrica_old = li_fabrica
	li_linea_old = li_linea
	ll_referencia_old = ll_referencia
	
	END IF
NEXT

Close(w_retroalimentacion)

end event

type cb_buscar from commandbutton within w_reporte_kamban_corte_new
integer x = 2912
integer y = 4
integer width = 343
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;Long  li_co_fabrica, li_co_linea, li_result, li_fab
Long	ll_ordenpd_pt, ll_co_referencia, ll_orden_corte, ll_cliente 
n_cst_kamban_corte luo_generar_reportes
//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
n_cts_constantes_tela luo_constantes



lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando datos para reporte"
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                

IF len(trim(em_fabrica.text)) = 0 THEN 
	li_co_fabrica = 0
ELSE
	li_co_fabrica = Long(em_fabrica.text)
END IF

IF len(trim(em_linea.text)) = 0 THEN
	li_co_linea = 0
ELSE
	li_co_linea = Long(em_linea.text)
END IF

IF len(trim(em_referencia.text)) = 0 THEN
	ll_co_referencia = 0
ELSE
	ll_co_referencia = Long(em_referencia.text)
END IF

IF len(trim(em_op.text)) = 0 THEN
	ll_ordenpd_pt = 0
ELSE
	ll_ordenpd_pt = Long(em_op.text)
END IF

IF len(trim(em_oc.text)) = 0 THEN
	ll_orden_corte = 0
ELSE
	ll_orden_corte = Long(em_oc.text)
END IF
IF len(trim(em_cliente.text)) = 0 THEN
	ll_cliente = 0
ELSE
	ll_cliente = Long(em_cliente.text)
END IF

select co_fabrica
  into :li_fab
  from tmp_kamban_cte_po;
 if (sqlca.sqldbcode = -244) or (sqlca.sqldbcode = -243) or (sqlca.sqldbcode = -242)  then
	messagebox('Advertencia','El reporte aun esta cargando datos, se va a mostrar lo que hay hasta este momento, pueden faltar otras ordenes de corte, intente mas tarde')
 end if
  
il_year=luo_constantes.of_consultar_numerico("ANO_CRITICA")
il_week=luo_constantes.of_consultar_numerico("SEMANA_CRITICA")

DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;

dw_maestro.SetTransObject(SQLCA)
Close(w_retroalimentacion)
dw_maestro.Retrieve(li_co_fabrica, li_co_linea, ll_co_referencia, ll_ordenpd_pt, ll_orden_corte, gstr_info_usuario.co_planta_pro, il_year,il_week, ll_cliente)

	
DISCONNECT;
SQLCA.Lock = "Cursor Stability"
CONNECT USING SQLCA;

dw_maestro.SetTransObject(SQLCA)






end event

type em_fabrica from editmask within w_reporte_kamban_corte_new
integer x = 137
integer y = 4
integer width = 119
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type em_linea from editmask within w_reporte_kamban_corte_new
integer x = 439
integer y = 4
integer width = 146
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_referencia from editmask within w_reporte_kamban_corte_new
integer x = 910
integer y = 4
integer width = 279
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type em_op from editmask within w_reporte_kamban_corte_new
integer x = 1422
integer y = 4
integer width = 338
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type em_oc from editmask within w_reporte_kamban_corte_new
integer x = 1938
integer y = 4
integer width = 338
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

type st_1 from statictext within w_reporte_kamban_corte_new
integer x = 23
integer y = 20
integer width = 119
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fab:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_reporte_kamban_corte_new
integer x = 265
integer y = 24
integer width = 151
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Linea:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_reporte_kamban_corte_new
integer x = 613
integer y = 24
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencia:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_reporte_kamban_corte_new
integer x = 1230
integer y = 24
integer width = 197
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.Pdn.:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_reporte_kamban_corte_new
integer x = 1769
integer y = 24
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.Cte.:"
boolean focusrectangle = false
end type

type st_6 from statictext within w_reporte_kamban_corte_new
integer x = 37
integer y = 2304
integer width = 1993
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "El Kamban se ejecuta a las 2, 3, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 18, 19, 21, 22 y 23 Horas"
boolean focusrectangle = false
end type

type cb_grupo from commandbutton within w_reporte_kamban_corte_new
integer x = 3209
integer y = 4
integer width = 343
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grupo"
end type

event clicked;Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_maestro.GetRow()

If ll_fila > 0 Then
	lstr_parametros.entero[1] = 2
	lstr_parametros.cadena[1] = dw_maestro.GetItemString(ll_fila,'po')
	
	OpenWithParm (w_grupos, lstr_parametros)
End if

end event

type st_7 from statictext within w_reporte_kamban_corte_new
integer x = 2281
integer y = 24
integer width = 219
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente:"
boolean focusrectangle = false
end type

type em_cliente from editmask within w_reporte_kamban_corte_new
integer x = 2487
integer y = 8
integer width = 343
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

