HA$PBExportHeader$w_calculo_consumo_sesgo.srw
forward
global type w_calculo_consumo_sesgo from w_base_simple
end type
type dw_1 from uo_dtwndow within w_calculo_consumo_sesgo
end type
type em_1 from editmask within w_calculo_consumo_sesgo
end type
type st_1 from statictext within w_calculo_consumo_sesgo
end type
type st_2 from statictext within w_calculo_consumo_sesgo
end type
type em_2 from editmask within w_calculo_consumo_sesgo
end type
type cb_1 from commandbutton within w_calculo_consumo_sesgo
end type
type cb_2 from commandbutton within w_calculo_consumo_sesgo
end type
type cb_3 from commandbutton within w_calculo_consumo_sesgo
end type
type cbx_1 from checkbox within w_calculo_consumo_sesgo
end type
type cbx_2 from checkbox within w_calculo_consumo_sesgo
end type
end forward

global type w_calculo_consumo_sesgo from w_base_simple
integer width = 3319
integer height = 2016
string title = "Calculo Consumo del Sesgos por Empates"
string menuname = ""
dw_1 dw_1
em_1 em_1
st_1 st_1
st_2 st_2
em_2 em_2
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cbx_1 cbx_1
cbx_2 cbx_2
end type
global w_calculo_consumo_sesgo w_calculo_consumo_sesgo

type variables

uo_dsbase ids_sesgos
end variables

on w_calculo_consumo_sesgo.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.em_1=create em_1
this.st_1=create st_1
this.st_2=create st_2
this.em_2=create em_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.em_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.cbx_2
end on

on w_calculo_consumo_sesgo.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cbx_1)
destroy(this.cbx_2)
end on

event open;

dw_maestro.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
dw_1.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ids_sesgos = Create uo_dsbase
ids_sesgos.DataObject = 'd_gr_dt_sesgos_x_oc_raya'
ids_sesgos.SetTransObject(SQLCA)

end event

event closequery;//
end event

type dw_maestro from w_base_simple`dw_maestro within w_calculo_consumo_sesgo
integer x = 37
integer y = 192
integer width = 2999
integer height = 512
integer taborder = 40
string dataobject = "d_gr_ref_preliquidadas_x_oc"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::itemchanged;
Long ll_reg 
Dec ldc_dato, ldc_unidades

//actualiza el detalle con el campo 
For ll_reg = 1 to dw_1.RowCount()
	ldc_dato = Dec(data)
	If dwo.name = 'medida_empate' Then
		dw_1.SetItem(ll_reg,'medida_empate',ldc_dato)
	End if
	If dwo.name = 'peso_empate' Then
		dw_1.SetItem(ll_reg,'peso_empate',ldc_dato)
	End if
Next

If dwo.name = 'medida_empate' Then
	//actualiza el detalle las unidades por empate 
	For ll_reg = 1 to dw_1.RowCount()
		If dw_1.GetItemDecimal(ll_reg,'consumo_unidad') > 0 Then
			//si no utiliza decimales
			If dw_1.GetItemNumber(ll_reg,'sw_unidades_empate') = 1 Then
				ldc_unidades = truncate(dw_1.GetItemDecimal(ll_reg,'medida_empate')/dw_1.GetItemDecimal(ll_reg,'consumo_unidad'),0)
			Else
				ldc_unidades = truncate(dw_1.GetItemDecimal(ll_reg,'medida_empate')/dw_1.GetItemDecimal(ll_reg,'consumo_unidad'),2)
			End if
			dw_1.SetItem(ll_reg,'unidades_empate',ldc_unidades)
		End if
	Next
End if
end event

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;
Long ll_fab, ll_linea, ll_ref, ll_reftel

//toma la informacion de referencia y tela
ll_fab = dw_maestro.GetItemNumber(currentrow,'co_fabrica_pt')
ll_linea = dw_maestro.GetItemNumber(currentrow,'co_linea')
ll_ref = dw_maestro.GetItemNumber(currentrow,'co_referencia')
ll_reftel = dw_maestro.GetItemNumber(currentrow,'co_reftel')

//filtra detalle 
dw_1.SetFilter('co_fabrica_pt = ' + String(ll_fab) &
					+ ' and co_linea = ' + String(ll_linea) & 
					+ ' and co_referencia = ' + String(ll_ref) & 
					+ ' and co_reftel = ' + String(ll_reftel) )
dw_1.Filter()


end event

type dw_1 from uo_dtwndow within w_calculo_consumo_sesgo
integer x = 37
integer y = 736
integer width = 2999
integer height = 1152
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_gr_unidades_preliq_x_oc"
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
Dec ldc_unidades

If dwo.name = 'consumo_unidad' Then
	//actualiza el detalle las unidades por empate 
	//si no utiliza decimales
	If dw_1.GetItemNumber(row,'sw_unidades_empate') = 1 Then
		ldc_unidades = truncate(dw_1.GetItemDecimal(row,'medida_empate')/Dec(data),0)
	Else
		ldc_unidades = truncate(dw_1.GetItemDecimal(row,'medida_empate')/Dec(data),2)
	End if
	dw_1.Post SetItem(row,'unidades_empate',ldc_unidades)
End if
end event

type em_1 from editmask within w_calculo_consumo_sesgo
integer x = 366
integer y = 32
integer width = 453
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type st_1 from statictext within w_calculo_consumo_sesgo
integer x = 73
integer y = 32
integer width = 270
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte"
boolean focusrectangle = false
end type

type st_2 from statictext within w_calculo_consumo_sesgo
integer x = 878
integer y = 32
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Raya"
boolean focusrectangle = false
end type

type em_2 from editmask within w_calculo_consumo_sesgo
integer x = 1024
integer y = 32
integer width = 233
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type cb_1 from commandbutton within w_calculo_consumo_sesgo
integer x = 1902
integer y = 32
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;
Long ll_oc, ll_raya, ll_reg, ll_find
Long ll_fab, ll_linea, ll_ref, ll_reftel, ll_co_parte, ll_co_talla

//toma la oc y raya digitada
ll_oc = Long(em_1.Text)
ll_raya = Long(em_2.Text)

//mira que no esten nulos
IF Isnull(ll_oc) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No ha digitado una OC valida')
	Return 1
End if

IF Isnull(ll_raya) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No ha digitado una raya valida')
	Return 1
End if

dw_1.SetFilter('')
dw_1.Filter()
dw_1.Reset()

//consulta los datos
ll_reg = dw_maestro.Retrieve(ll_oc, ll_raya) 
If ll_reg = 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro datos para la OC ' + String(ll_oc) + ' raya ' + String(ll_raya))
	Return 1
ElseIf ll_reg < 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar los datos para la OC ' + String(ll_oc) + ' raya ' + String(ll_raya))
	Return 1
End if

//consulta los datos
ll_reg = dw_1.Retrieve(ll_oc, ll_raya) 
If ll_reg = 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro datos para la OC ' + String(ll_oc) + ' raya ' + String(ll_raya))
	Return 1
ElseIf ll_reg < 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar los datos para la OC ' + String(ll_oc) + ' raya ' + String(ll_raya))
	Return 1
End if


//consulta si hay datos creados para borrarlos cuando guarda
ll_reg = ids_sesgos.Retrieve(ll_oc, ll_raya) 

//si ya hay datos creados
If ll_reg > 0 Then
	//indica que ya se crearon datos para la oc
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','ya hay informaci$$HEX1$$f300$$ENDHEX$$n creada para la OC ' + String(ll_oc) + ' raya ' + String(ll_raya))
	
	//recorre los datos para pasar la informacion existente
	For ll_reg = 1 to dw_maestro.RowCount()
		//toma la informacion de referencia y tela
		ll_fab = dw_maestro.GetItemNumber(ll_reg,'co_fabrica_pt')
		ll_linea = dw_maestro.GetItemNumber(ll_reg,'co_linea')
		ll_ref = dw_maestro.GetItemNumber(ll_reg,'co_referencia')
		ll_reftel = dw_maestro.GetItemNumber(ll_reg,'co_reftel')

		//busca la ref en los datos creados
		ll_find = ids_sesgos.Find('co_fabrica_pt = ' + String(ll_fab) &
					+ ' and co_linea = ' + String(ll_linea) & 
					+ ' and co_referencia = ' + String(ll_ref) & 
					+ ' and co_reftel = ' + String(ll_reftel) ,1 , ids_sesgos.RowCount() +1)
		If ll_find > 0 Then
			//actualiza los datos
			dw_maestro.SetItem(ll_reg,'medida_empate',ids_sesgos.GetItemDecimal(ll_find,'medida_empate'))
			dw_maestro.SetItem(ll_reg,'peso_empate',ids_sesgos.GetItemDecimal(ll_find,'peso_empate'))
		End if
	Next
	
	For ll_reg = 1 to dw_1.RowCount()
		//toma la informacion de referencia y tela
		ll_fab = dw_1.GetItemNumber(ll_reg,'co_fabrica_pt')
		ll_linea = dw_1.GetItemNumber(ll_reg,'co_linea')
		ll_ref = dw_1.GetItemNumber(ll_reg,'co_referencia')
		ll_reftel = dw_1.GetItemNumber(ll_reg,'co_reftel')
		ll_co_parte = dw_1.GetItemNumber(ll_reg,'co_parte')
		ll_co_talla = dw_1.GetItemNumber(ll_reg,'co_talla')
	
		//busca la ref en los datos creados
		ll_find = ids_sesgos.Find('co_fabrica_pt = ' + String(ll_fab) &
					+ ' and co_linea = ' + String(ll_linea) & 
					+ ' and co_referencia = ' + String(ll_ref) & 
					+ ' and co_reftel = ' + String(ll_reftel) & 
					+ ' and co_parte = ' + String(ll_co_parte) & 
					+ ' and co_talla = ' + String(ll_co_talla) ,1 , ids_sesgos.RowCount())
		If ll_find > 0 Then
			//actualiza los datos
			dw_1.SetItem(ll_reg,'medida_empate',ids_sesgos.GetItemDecimal(ll_find,'medida_empate'))
			dw_1.SetItem(ll_reg,'peso_empate',ids_sesgos.GetItemDecimal(ll_find,'peso_empate'))
			dw_1.SetItem(ll_reg,'consumo_unidad',ids_sesgos.GetItemDecimal(ll_find,'consumo_unidad'))
			dw_1.SetItem(ll_reg,'unidades_empate',ids_sesgos.GetItemDecimal(ll_find,'unidades_empate'))
			
		End if
		
		//si esta seleccionado no utiliza decimales
		If cbx_1.Checked = True Then
			dw_1.SetItem(ll_reg,'sw_unidades_empate',1)
		Else
			dw_1.SetItem(ll_reg,'sw_unidades_empate',0)
		End if
		
	Next
ElseIf ll_reg = 0 Then
	For ll_reg = 1 to dw_1.RowCount()
		//si esta seleccionado no utiliza decimales
		If cbx_1.Checked = True Then
			dw_1.SetItem(ll_reg,'sw_unidades_empate',1)
		Else
			dw_1.SetItem(ll_reg,'sw_unidades_empate',0)
		End if
	Next
ElseIf ll_reg < 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar los datos creados para la OC ' + String(ll_oc) + ' raya ' + String(ll_raya))
	Return 1
End if

dw_maestro.SelectRow(1,TRUE)

//toma la informacion de referencia y tela
ll_fab = dw_maestro.GetItemNumber(1,'co_fabrica_pt')
ll_linea = dw_maestro.GetItemNumber(1,'co_linea')
ll_ref = dw_maestro.GetItemNumber(1,'co_referencia')
ll_reftel = dw_maestro.GetItemNumber(1,'co_reftel')

//filtra detalle 
dw_1.SetFilter('co_fabrica_pt = ' + String(ll_fab) &
					+ ' and co_linea = ' + String(ll_linea) & 
					+ ' and co_referencia = ' + String(ll_ref) & 
					+ ' and co_reftel = ' + String(ll_reftel) )
dw_1.Filter()


end event

type cb_2 from commandbutton within w_calculo_consumo_sesgo
integer x = 2341
integer y = 32
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Guardar"
end type

event clicked;
Long ll_reg, ll_find, ll_row, ll_cs_orden_corte, ll_raya, ll_co_fabrica_pt, ll_co_linea
Long ll_co_referencia, ll_co_reftel, ll_co_parte, ll_co_talla
Dec ldc_ca_liquidadas, ldc_medida_empate, ldc_peso_empate, ldc_consumo_unidad, ldc_unidades_empate
String ls_filtro

dw_maestro.AcceptText()
dw_1.AcceptText()

ls_filtro = dw_1.Describe("DataWindow.Table.Filter")
IF IsNull(ls_filtro) OR ls_filtro = '?' THEN
	ls_filtro = ''
END IF

dw_1.SetReDraw(False)
dw_1.SetFilter('')
dw_1.Filter()

//recorre los datos para grabarlos
For ll_reg = 1 to dw_1.RowCount()
	//toma los datos
	ll_cs_orden_corte = dw_1.GetItemNumber(ll_reg,'cs_orden_corte')
	ll_raya = dw_1.GetItemNumber(ll_reg,'raya')
	ll_co_fabrica_pt = dw_1.GetItemNumber(ll_reg,'co_fabrica_pt')
	ll_co_linea = dw_1.GetItemNumber(ll_reg,'co_linea')
	ll_co_referencia = dw_1.GetItemNumber(ll_reg,'co_referencia')
	ll_co_reftel = dw_1.GetItemNumber(ll_reg,'co_reftel')
	ll_co_parte = dw_1.GetItemNumber(ll_reg,'co_parte')
	ll_co_talla = dw_1.GetItemNumber(ll_reg,'co_talla')
	ldc_unidades_empate = dw_1.GetItemDecimal(ll_reg,'unidades_empate')
	ldc_ca_liquidadas = dw_1.GetItemDecimal(ll_reg,'ca_liquidadas')
	ldc_medida_empate = dw_1.GetItemDecimal(ll_reg,'medida_empate')
	ldc_peso_empate = dw_1.GetItemDecimal(ll_reg,'peso_empate')
	ldc_consumo_unidad = dw_1.GetItemDecimal(ll_reg,'consumo_unidad')
	
	//busca si el registro existe
	ll_find = ids_sesgos.Find('cs_orden_corte = ' + String(ll_cs_orden_corte) &
					+ ' and raya = ' + String(ll_raya) & 
					+ ' and co_fabrica_pt = ' + String(ll_co_fabrica_pt) &
					+ ' and co_linea = ' + String(ll_co_linea) & 
					+ ' and co_referencia = ' + String(ll_co_referencia) & 
					+ ' and co_reftel = ' + String(ll_co_reftel) & 
					+ ' and co_parte = ' + String(ll_co_parte) & 
					+ ' and co_talla = ' + String(ll_co_talla) ,1 , ids_sesgos.RowCount())
					
	//si encuentra registro
	If ll_find > 0 Then
		//actualiza cantidades
		ids_sesgos.SetItem(ll_find,'ca_liquidadas',ldc_ca_liquidadas)
		ids_sesgos.SetItem(ll_find,'medida_empate',ldc_medida_empate)
		ids_sesgos.SetItem(ll_find,'peso_empate',ldc_peso_empate)
		ids_sesgos.SetItem(ll_find,'consumo_unidad',ldc_consumo_unidad)
		ids_sesgos.SetItem(ll_find,'unidades_empate',ldc_unidades_empate)
		ids_sesgos.SetItem(ll_find, "fe_actualizacion", f_fecha_servidor())
		ids_sesgos.SetItem(ll_find, "usuario_act", gstr_info_usuario.codigo_usuario)
		ids_sesgos.SetItem(ll_find, "instancia", gstr_info_usuario.instancia)
		
	ElseIf ll_find = 0 Then
		//adiciona registro nuevo
		ll_row = ids_sesgos.InsertRow(0)
		ids_sesgos.SetItem(ll_row,'cs_orden_corte',ll_cs_orden_corte)
		ids_sesgos.SetItem(ll_row,'raya',ll_raya)
		ids_sesgos.SetItem(ll_row,'co_fabrica_pt',ll_co_fabrica_pt)
		ids_sesgos.SetItem(ll_row,'co_linea',ll_co_linea)
		ids_sesgos.SetItem(ll_row,'co_referencia',ll_co_referencia)
		ids_sesgos.SetItem(ll_row,'co_reftel',ll_co_reftel)
		ids_sesgos.SetItem(ll_row,'co_parte',ll_co_parte)
		ids_sesgos.SetItem(ll_row,'co_talla',ll_co_talla)
		ids_sesgos.SetItem(ll_row,'ca_liquidadas',ldc_ca_liquidadas)
		ids_sesgos.SetItem(ll_row,'medida_empate',ldc_medida_empate)
		ids_sesgos.SetItem(ll_row,'peso_empate',ldc_peso_empate)
		ids_sesgos.SetItem(ll_row,'consumo_unidad',ldc_consumo_unidad)
		ids_sesgos.SetItem(ll_row,'unidades_empate',ldc_unidades_empate)
		
	Else
		Rollback;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al buscar registro de sesgo.')
		Return -1
	End if

Next

IF ids_sesgos.Update() = -1 THEN
	ROLLBACK;
	Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al actualizar los datos.")
	dw_1.SetFilter(ls_filtro)
	dw_1.Filter()
	dw_1.SetReDraw(True)
	RETURN -2
ELSE
	COMMIT;
	IF SQLCA.SQLCode = -1 THEN
		Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al actualizar los datos(Commit).")
		dw_1.SetFilter(ls_filtro)
		dw_1.Filter()
		dw_1.SetReDraw(True)
		RETURN -3
	ELSE
		Messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","Se guardan los datos correctamente.")
		dw_1.sort()
		dw_1.groupcalc()
		
		dw_1.SetFilter(ls_filtro)
		dw_1.Filter()
		dw_1.SetReDraw(True)

	END IF
END IF

Return 1
end event

type cb_3 from commandbutton within w_calculo_consumo_sesgo
integer x = 2853
integer y = 32
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;
Long ll_oc
s_base_parametros lstr_parametros

//toma la oc y raya digitada
ll_oc = Long(em_1.Text)

//mira que no esten nulos
IF Isnull(ll_oc) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No ha digitado una OC valida')
	Return 1
End if

lstr_parametros.entero[1]	=	ll_oc
OpenSheetWithParm(w_reporte_dt_sesgos_x_oc_raya, lstr_parametros, parent, 0, Layered!)		

Return 1


end event

type cbx_1 from checkbox within w_calculo_consumo_sesgo
integer x = 1280
integer y = 32
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Empate a Empate"
boolean checked = true
end type

event clicked;
Dec ldc_unidades
Long ll_reg

If cbx_1.Checked = True Then
	cbx_2.Checked = False
Else
	cbx_2.Checked = True
End if


For ll_reg = 1 to dw_1.RowCount()
	//si esta seleccionado no utiliza decimales
	If cbx_1.Checked = True Then
		dw_1.SetItem(ll_reg,'sw_unidades_empate',1)
	Else
		dw_1.SetItem(ll_reg,'sw_unidades_empate',0)
	End if
	
	If dw_1.GetItemDecimal(ll_reg,'consumo_unidad') > 0 Then
		//si no utiliza decimales
		If dw_1.GetItemNumber(ll_reg,'sw_unidades_empate') = 1 Then
			ldc_unidades = truncate(dw_1.GetItemDecimal(ll_reg,'medida_empate')/dw_1.GetItemDecimal(ll_reg,'consumo_unidad'),0)
		Else
			ldc_unidades = truncate(dw_1.GetItemDecimal(ll_reg,'medida_empate')/dw_1.GetItemDecimal(ll_reg,'consumo_unidad'),2)
		End if
		dw_1.SetItem(ll_reg,'unidades_empate',ldc_unidades)
	End if
Next

end event

type cbx_2 from checkbox within w_calculo_consumo_sesgo
integer x = 1280
integer y = 96
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Medida a la trama"
end type

event clicked;
Dec ldc_unidades
Long ll_reg

If cbx_2.Checked = True Then
	cbx_1.Checked = False
Else
	cbx_1.Checked = True
End if

For ll_reg = 1 to dw_1.RowCount()
	//si esta seleccionado no utiliza decimales
	If cbx_1.Checked = True Then
		dw_1.SetItem(ll_reg,'sw_unidades_empate',1)
	Else
		dw_1.SetItem(ll_reg,'sw_unidades_empate',0)
	End if
	
	If dw_1.GetItemDecimal(ll_reg,'consumo_unidad') > 0 Then
		//si no utiliza decimales
		If dw_1.GetItemNumber(ll_reg,'sw_unidades_empate') = 1 Then
			ldc_unidades = truncate(dw_1.GetItemDecimal(ll_reg,'medida_empate')/dw_1.GetItemDecimal(ll_reg,'consumo_unidad'),0)
		Else
			ldc_unidades = truncate(dw_1.GetItemDecimal(ll_reg,'medida_empate')/dw_1.GetItemDecimal(ll_reg,'consumo_unidad'),2)
		End if
		dw_1.SetItem(ll_reg,'unidades_empate',ldc_unidades)
	End if
Next
end event

