HA$PBExportHeader$w_mercar_reposiciones.srw
forward
global type w_mercar_reposiciones from w_base_simple
end type
type dw_rollos from uo_dtwndow within w_mercar_reposiciones
end type
type cb_1 from commandbutton within w_mercar_reposiciones
end type
type cb_2 from commandbutton within w_mercar_reposiciones
end type
end forward

global type w_mercar_reposiciones from w_base_simple
integer width = 1376
integer height = 1384
string title = "Mercar Reposiciones"
dw_rollos dw_rollos
cb_1 cb_1
cb_2 cb_2
end type
global w_mercar_reposiciones w_mercar_reposiciones

type variables

Long il_estado_mercada, il_estado_x_mercar, il_estado_x_cortar, il_estado_cortando, il_estado_asignada
uo_dsbase ids_rollos_x_mercada, ids_mercada
end variables

on w_mercar_reposiciones.create
int iCurrent
call super::create
this.dw_rollos=create dw_rollos
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rollos
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
end on

on w_mercar_reposiciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rollos)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event open;call super::open;

n_cts_constantes luo_constantes

ids_rollos_x_mercada = Create uo_dsbase
ids_rollos_x_mercada.DataObject = 'd_gr_rollos_x_mercada'
ids_rollos_x_mercada.SetTransObject(SQLCA)

ids_mercada = Create uo_dsbase
ids_mercada.DataObject = 'd_gr_validar_mercada_reposiciones'
ids_mercada.SetTransObject(SQLCA )

luo_constantes = Create n_cts_constantes

il_estado_mercada =  luo_constantes.of_consultar_numerico("ESTADO MERCADA")	
il_estado_x_mercar =  luo_constantes.of_consultar_numerico("ESTADO X MERCAR")	
il_estado_x_cortar =  luo_constantes.of_consultar_numerico("ESTADO X CORTAR")	
il_estado_cortando =  luo_constantes.of_consultar_numerico("ESTADO CORTANDO")	
il_estado_asignada =  luo_constantes.of_consultar_numerico("MERCADA ASIGNADA")	

dw_maestro.InsertRow(0)
dw_rollos.Reset()
ids_rollos_x_mercada.Reset()


Destroy luo_constantes
end event

event closequery;//
end event

event ue_borrar_maestro;//
end event

event ue_buscar;//
end event

event ue_insertar_maestro;//
end event

event ue_grabar;//
end event

type dw_maestro from w_base_simple`dw_maestro within w_mercar_reposiciones
integer x = 41
integer y = 40
integer width = 1266
integer height = 368
integer taborder = 20
string dataobject = "d_ff_mercar_reposiciones"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::itemchanged;
long ll_reg, ll_mercada, ll_n, ll_nulo
string ls_ordenes
uo_dsbase lds_ordenes

Setnull(ll_nulo)

If dwo.name = 'mercada' Then
	
	//si no ingresaron un dato correcto
	If long(data) <= 0 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ingreso un valor valido.')
		Return 2
	End if
	
	//toma mercada ingresada
	ll_mercada = long(data)
	//consulta datos
	ll_reg = ids_mercada.Retrieve(ll_mercada)
	If ll_reg > 0 Then
		//Validar que la mercada tenga tipo mercada 2 (reposicion) en h_mercada		
		If ids_mercada.GetItemNumber(1,'co_tipo_mercada') <> 2 Then
			Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El tipo de mercada no es reposicion.')
			ids_mercada.reset()
			ids_rollos_x_mercada.Reset()
			dw_rollos.Reset()
			This.SetItem(row,'mercada',0)
			Return 2
		End if
		
		//Traer el estado de la mercada de h_mercada, debe ser por mercar o por cortar		
		If ids_mercada.GetItemNumber(1,'co_estado_mercada') <> il_estado_x_mercar and &
			ids_mercada.GetItemNumber(1,'co_estado_mercada') <> il_estado_x_cortar 	Then
			Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El estado de la mercada no es por mercar o por cortar.')
			ids_mercada.reset()
			ids_rollos_x_mercada.Reset()
			dw_rollos.Reset()
			This.SetItem(row,'mercada',0)
			Return 2
		End if
		
		If ids_mercada.GetItemNumber(1,'total_rollos')  = 0 Then
			Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La mercada no tiene rollos asignados.')
			ids_mercada.reset()
			ids_rollos_x_mercada.Reset()
			dw_rollos.Reset()
			This.SetItem(row,'mercada',0)
			Return 2
		End if
		
		//asigna total de rollos
		This.SetItem(1,'total_rollos',ids_mercada.GetItemNumber(1,'total_rollos'))
		dw_rollos.Reset()
		
		//consulta los rollos
		If ids_rollos_x_mercada.Retrieve(ll_mercada) < 0 Then
			Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar los rollos  de la mercada.')
			ids_mercada.reset()
			ids_rollos_x_mercada.Reset()
			dw_rollos.Reset()
			This.SetItem(row,'mercada',0)
			Return 2
		End if
		
		//mira si es estado x mercar para buscar las ordenes
		If ids_mercada.GetItemNumber(1,'co_estado_mercada') = il_estado_x_mercar Then
		
			lds_ordenes = Create uo_dsbase				
			lds_ordenes.dataobject = "d_gr_ordenes_x_mercada"
			lds_ordenes.settransobject(gnv_recursos.of_get_transaccion_sucia())
			
			//busca ordenes
			If lds_ordenes.retrieve(ll_mercada) > 0 Then
				ls_ordenes = ''
				For ll_n = 1 to lds_ordenes.RowCount()
					If lds_ordenes.GetItemNumber(ll_n,'cs_asignacion') <> ids_mercada.GetItemNumber(ll_n,'cs_orden_corte') Then
						ls_ordenes = Trim(ls_ordenes) + ' ' + String(lds_ordenes.GetItemNumber(ll_n,'cs_asignacion')) + ','
					End if
				Next
				
				This.SetItem(row,'observacion','Ordenes Hermanas: '+ trim(ls_ordenes))
			End if
			
		End if
	Else
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontraron datos para la mercada: ' + string(ll_mercada))
		ids_mercada.reset()
		ids_rollos_x_mercada.Reset()
		dw_rollos.Reset()
		This.Post SetItem(row,'mercada',0)
		This.SetItem(row,'rollo',0)
		Return 2
	End if
		
ElseIf dwo.name = 'rollo' Then	 
	//si no ingresaron un dato correcto
	If long(data) <= 0 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ingreso un valor valido.')
		Return 0
	End if
	
	//mira si ya leyeron el rollo
	ll_reg = dw_rollos.Find('cs_rollo = ' + trim(data), 1 , dw_rollos.RowCount()  + 1)
	If ll_reg > 0 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El rollo ya fue leido.')
		Return 1
	End if
	
	//para indicar si encuentra un estado no valido
	ll_n = 0
	//verifica que los rollos tengan estado por mercar o por cortar 
	ll_reg = ids_rollos_x_mercada.Find('cs_rollo = ' + trim(data), 1 , ids_rollos_x_mercada.RowCount()  + 1)
	If ll_reg <= 0 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No existe un rollo con ese n$$HEX1$$fa00$$ENDHEX$$mero para la mercada.')
		Return 1
	End if
	
	Do while ll_reg > 0
		//verifica estado
		If ids_rollos_x_mercada.GetItemNumber(ll_reg,'co_estado_mercada') <> il_estado_x_mercar and &
			ids_rollos_x_mercada.GetItemNumber(ll_reg,'co_estado_mercada') <> il_estado_x_cortar 	Then
			ll_n = 1
		End if
		
		//busca siguiente
		ll_reg = ids_rollos_x_mercada.Find('cs_rollo = ' + trim(data), ll_reg + 1 , ids_rollos_x_mercada.RowCount()  + 1)
	Loop

	//si no encuentra estado invalido
	If ll_n = 0 Then
		//registro rollo leido
		ll_reg = dw_rollos.InsertRow(0)
		dw_rollos.Setitem(ll_reg,'cs_rollo',long(data))
		This.Post SetItem(row,'rollo',ll_nulo)
		This.Post SetColumn('rollo')
	Else
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El rollo tiene un estado invalido para la mercada.')
		Return 2
	End if
End if

end event

type dw_rollos from uo_dtwndow within w_mercar_reposiciones
integer x = 41
integer y = 432
integer width = 855
integer height = 524
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_gr_rollos_leidos"
boolean hscrollbar = true
end type

type cb_1 from commandbutton within w_mercar_reposiciones
integer x = 41
integer y = 1008
integer width = 343
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;
//guarda cambios en mercada
Long ll_rollo, ll_n, ll_rollos[], ll_reg,ll_centro
Datetime ldt_fecha
uo_dsbase lds_rollo

If dw_maestro.AcceptText() < 0 Then Return 1

//mira si hay datos para mercar
If dw_rollos.RowCount() > 0 Then
	
	IF  (dw_maestro.getItemnumber(1,'total_rollos')) <> dw_rollos.RowCount() THEN
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Debe Leer todos los rollos.')
		Return -1
	END IF
	If ids_mercada.GetItemNumber(1,'co_estado_mercada') = il_estado_x_mercar Then
		//mira que seleccione centro
		ll_centro = dw_maestro.getItemnumber(1,'centro')
		If Isnull(ll_centro) or ll_centro = 0 Then 
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Debe seleccionar centro.')
			Return -1
		End if
		
	End if
	
	ldt_fecha = f_fecha_servidor()
	
	lds_rollo = Create uo_dsbase
	lds_rollo.DataObject = 'd_gr_m_rollo_x_rollos'
	lds_rollo.SetTransObject(SQLCA)

	ll_rollos = dw_rollos.Object.cs_rollo.Primary
	//consulta m_rollo
	If lds_rollo.Retrieve(ll_rollos) < 0 Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontraron datos para los rollos leidos.')
		Return -1
	End if
	
	//cambia estado rollos
	For ll_n = 1 to  dw_rollos.RowCount() 
		//toma rollo
		ll_rollo = dw_rollos.GetItemNumber(ll_n,'cs_rollo')
		
		//busca rollo para cambiar estado
		ll_reg = ids_rollos_x_mercada.Find('cs_rollo = ' + String(ll_rollo), 1 , ids_rollos_x_mercada.RowCount()  + 1)
		Do while ll_reg > 0
			//verifica estado
			If ids_rollos_x_mercada.GetItemNumber(ll_reg,'co_estado_mercada') = il_estado_x_mercar Then
				ids_rollos_x_mercada.SetItem(ll_reg,'co_estado_mercada',il_estado_mercada)
			End if
		
			If ids_rollos_x_mercada.GetItemNumber(ll_reg,'co_estado_mercada') = il_estado_x_cortar 	Then
				ids_rollos_x_mercada.SetItem(ll_reg,'co_estado_mercada',il_estado_cortando)
			End if
			
			ids_rollos_x_mercada.SetItem(ll_reg,'fe_actualizacion',ldt_fecha)
			ids_rollos_x_mercada.SetItem(ll_reg,'usuario',gstr_info_usuario.codigo_usuario)
			
			//busca siguiente
			ll_reg = ids_rollos_x_mercada.Find('cs_rollo = ' + String(ll_rollo), ll_reg + 1 , ids_rollos_x_mercada.RowCount()  + 1)
		Loop
		
		//busca en m_rollo
		ll_reg = lds_rollo.Find('cs_rollo = ' + String(ll_rollo), 1 , lds_rollo.RowCount()  + 1)
		If ll_reg > 0 Then
			lds_rollo.SetItem(ll_reg,'fe_actualizacion',ldt_fecha)
			lds_rollo.SetItem(ll_reg,'usuario',gstr_info_usuario.codigo_usuario)
		End if
		
	Next
	
	//cambia estado en mercada
	If ids_mercada.GetItemNumber(1,'co_estado_mercada') = il_estado_x_mercar Then
		ids_mercada.SetItem(1,'co_estado_mercada',il_estado_mercada)
		
		ids_mercada.SetItem(1,'co_estado_mercada',il_estado_asignada)
		ids_mercada.SetItem(1,'co_centro_corte',ll_centro)
	End if

	If ids_mercada.GetItemNumber(1,'co_estado_mercada') = il_estado_x_cortar 	Then
		ids_mercada.SetItem(1,'co_estado_mercada',il_estado_cortando)
	End if
	ids_mercada.SetItem(1,'fe_actualizacion',ldt_fecha)
	ids_mercada.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
	
	IF ids_rollos_x_mercada.Update() = -1 THEN
		ROLLBACK;
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n",'Ocurrio un inconveniente al actualizar estado de rollos')	
		RETURN -1
	End if
	
	IF ids_mercada.Update() = -1 THEN
		ROLLBACK;
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n",'Ocurrio un inconveniente al actualizar estado de mercada')	
		RETURN -1
	End if
	
	IF lds_rollo.Update() = -1 THEN
		ROLLBACK;
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n",'Ocurrio un inconveniente al actualizar fecha y usuario en rollos')	
		RETURN -1
	End if
	
	COMMIT;
	IF sqlca.sqlcode = -1 THEN
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n",'Ocurrio un inconveniente al actualizar datos en la base de datos.')	
		RETURN -1	
	ELSE
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n",'Se actualiza mercada.')
		ids_mercada.reset()
		ids_rollos_x_mercada.Reset()
		dw_rollos.Reset()
		dw_maestro.SetItem(1,'mercada',0)
		dw_maestro.SetItem(1,'observacion','')
		
	END IF

End if

Return 1
end event

type cb_2 from commandbutton within w_mercar_reposiciones
integer x = 535
integer y = 1008
integer width = 343
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;
Close(parent)
end event

