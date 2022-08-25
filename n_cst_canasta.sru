HA$PBExportHeader$n_cst_canasta.sru
forward
global type n_cst_canasta from nonvisualobject
end type
end forward

global type n_cst_canasta from nonvisualobject autoinstantiate
end type

type variables
//variables origen
Long co_fabrica_act, co_planta_act, co_centro_act, co_subcentro_act
Long il_sw_tercero_act

//variables destino
Long co_fabrica, co_planta, co_centro_pdn, co_subcentro_pdn
Long il_sw_tercero_pdn

Long co_tipoprod, co_fabrica_pro, co_fabrica_pro_des
String co_tipo_lectura, co_tipo_atributo

//placa del cami$$HEX1$$f300$$ENDHEX$$n caracter de 6.
String is_placa

// variables para marcar si tienen ca_reproceso
Boolean ib_sin_reproceso, ib_reproceso

Long il_cliente, il_sucursal

uo_dsbase ids_lote
end variables

forward prototypes
public function long of_cargar_detalle (ref uo_dsbase ads_h_canasta, ref uo_dsbase ads_dt_canasta)
public function long of_cargar_pallet (string as_pallet, ref uo_dsbase ads_h_pallet, ref uo_dsbase ads_dt_pallet)
public function long of_hallar_hijos (string as_pallet)
public function long of_cargar_remision (long al_remision, long ai_estado, ref uo_dsbase ads_h_canasta, ref uo_dsbase ads_dt_canasta)
public function long of_verificar_estado (long ai_estados[], uo_dsbase ads_h_canasta)
public function long of_verificar_ca_reprocesos (uo_dsbase ads_dt_canasta)
public function long of_buscar_lote (s_base_parametros astr_parametros)
public function long of_consecutivo_nuevo_bongo (string as_tipo_consec, ref string as_bongo)
public function long of_nuevo_bongo (string as_po, long an_pedido, ref string as_bongo)
public function long of_verificar_lote (s_base_parametros astr_parametros)
public function long of_cargar_camion (long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, string as_camion, ref uo_dsbase ads_h_pallet, ref uo_dsbase ads_dt_pallet)
public function long of_numero_estibas (uo_dsbase ads_h_canasta)
public function long of_numero_cajas (uo_dsbase ads_h_canasta)
public function long of_bongo_facturado (long ai_fabrica, long ai_planta, string as_pallet)
public function long of_cargar_estiba (long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, string as_estiba, ref uo_dsbase ads_h_pallet, ref uo_dsbase ads_dt_pallet)
public function long of_determinar_tipo_pedido (string al_pallet_id, ref string al_tipo_pedido)
public function long of_validacion_caja_cambio_po (ref uo_dsbase ads_h_canasta, long al_registro)
public function long of_validar_propietario_sourcing (ref uo_dsbase ads_dt_canasta, long ai_propietario)
end prototypes

public function long of_cargar_detalle (ref uo_dsbase ads_h_canasta, ref uo_dsbase ads_dt_canasta);/*
Funci$$HEX1$$f300$$ENDHEX$$n para cargar los detalles de las canastas que contiene el datastor ads_h_canasta
*/
Long ll_filas, ll_i, ll_row
String ls_canastas[], ls_pallet
Boolean lb_borrar

// Si no es valido se crea el ds
If Not IsValid(ads_dt_canasta) Then
	ads_dt_canasta = Create uo_dsbase
	ads_dt_canasta.DataObject = 'd_gr_canastas_x_marcas_com'
	ads_dt_canasta.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
End If

If ads_h_canasta.RowCount() > 0 Then
	// si la cantidad es menor a 2500 canastas se copia normal
	If ads_h_canasta.RowCount() < 2500 Then
		ls_canastas = ads_h_canasta.Object.cs_canasta.Primary
	// si esta entre 2500 y 5000 se quitan los espacios en blanco
	ElseIf ads_h_canasta.RowCount() >= 2500 And ads_h_canasta.RowCount() < 5000 Then
		For ll_row = 1 To ads_h_canasta.RowCount()
			ls_canastas[ll_row] = Trim(ads_h_canasta.GetItemString( ll_row, 'cs_canasta') )
		Next
	Else // mayor de 5000 excede el tama$$HEX1$$f100$$ENDHEX$$o permitido por la base de datos
		Rollback;
		ads_dt_canasta.is_sqlerrtext = 'No se puede consultar el detalle de la canasta por' &
					+ ' que excede el maximo permitido. (' + String(ads_h_canasta.RowCount()) + ' detalles)'
		Return -1
	End If				
	
	// Se carga los detalles de las canastas de la remision
	ll_filas = ads_dt_canasta.Of_Retrieve(ls_canastas)
	// error al cargar los detalles
	If ll_filas < 0 Then 
		// error
	
	// si no hubo error
	ElseIf ll_filas > 0 Then
		lb_borrar = False
		// Se marcan los encabezados con ca_actual = 0
		For ll_i = 1 To UpperBound(ls_canastas)
			If ads_dt_canasta.Find("cs_canasta = '" + ls_canastas[ll_i] + "'", 1, ads_dt_canasta.RowCount() + 1) = 0 Then
				ll_row = ads_h_canasta.Find("cs_canasta = '" + ls_canastas[ll_i] + "'", 1, ads_h_canasta.RowCount() + 1)
				If ll_row > 0 Then
					ads_h_canasta.SetItem(ll_row, 'leida', 2)
					lb_borrar = True
					//ads_h_canasta.RowsDiscard(ll_row, ll_row, Primary!)
				End If
			End If
		Next
		// Se quitan los bongos con ca_actual = 0
		For ll_i = 1 To ads_h_canasta.RowCount()			
			ls_pallet = ads_h_canasta.GetItemString(ll_i, 'pallet_id')
			// si no ha sido marcada
			ll_row = ads_h_canasta.Find("IsNull(leida) And pallet_id = '" + ls_pallet + "'", 1, ads_h_canasta.RowCount())
			If ll_row > 0 Then
				ads_h_canasta.RowsDiscard(ll_row, ll_row, Primary!)
			End If
		Next
		// Para verificar si contiene canastas con ca_reproceso > 0
		This.Of_Verificar_Ca_Reprocesos(ads_dt_canasta)
	Else
		ads_h_canasta.Reset()
	End If
Else
	ll_filas = 0
End If

Return ll_filas
end function

public function long of_cargar_pallet (string as_pallet, ref uo_dsbase ads_h_pallet, ref uo_dsbase ads_dt_pallet);/*
Funci$$HEX1$$f300$$ENDHEX$$n para cargar las canastas que contiene un bongo (pallet)
*/
Long ll_filas, ll_rows
Long li_retorno

// Si no es valido se crea el ds
If Not IsValid(ads_h_pallet) Then
	ads_h_pallet = Create uo_dsbase
	ads_h_pallet.DataObject = 'd_gr_hcanasta_com'
	ads_h_pallet.SetTransObject(SQLCA)
End If

as_pallet = Trim(as_pallet)
If as_pallet = '' Or IsNull(as_pallet) Then
	Rollback;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El bongo No existe!',Information!)		
	Return -1
End If

// Se carga las canastas del bongo
ll_filas = ads_h_pallet.Of_Retrieve(as_pallet)
// Se valida la carga
Choose Case ll_filas 
	Case 0 
		li_retorno = 0
		Rollback;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El bongo ' + as_pallet + ' No existe!',Information!)		
	Case Is > 0
		li_retorno = 1
	Case Else
		li_retorno = -1
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el bongo ' + as_pallet + ' ' + ads_h_pallet.is_sqlerrtext ,StopSign!)
End Choose

If ll_filas > 0 Then	
	// Se carga los detalles de las canastas del bongo
	ll_rows = This.Of_Cargar_Detalle(ads_h_pallet, ads_dt_pallet)
	// Se valida la carga
	Choose Case ll_rows 
		Case 0 
			li_retorno = 0
			Rollback;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El bongo ' + as_pallet + ' No existe!',Information!)		
		Case Is > 0
			li_retorno = 1
			
			ads_h_pallet.SetFilter('leida <> 2')
			ads_h_pallet.Filter()
			
			// se toman los datos del origen y el destino
			co_fabrica_act		= ads_h_pallet.GetItemNumber(1, 'co_fabrica_act')
			co_planta_act		= ads_h_pallet.GetItemNumber(1, 'co_planta_act')
			co_centro_act		= ads_h_pallet.GetItemNumber(1, 'co_centro_act')
			co_subcentro_act	= ads_h_pallet.GetItemNumber(1, 'co_subcentro_act')
			
			co_fabrica			= ads_h_pallet.GetItemNumber(1, 'co_fabrica')
			co_planta			= ads_h_pallet.GetItemNumber(1, 'co_planta')
			co_centro_pdn		= ads_h_pallet.GetItemNumber(1, 'co_centro_pdn')
			co_subcentro_pdn	= ads_h_pallet.GetItemNumber(1, 'co_subcentro_pdn')
			
			co_fabrica_pro		= ads_h_pallet.GetItemNumber(1, 'co_fabrica_pro')
			co_fabrica_pro_des= ads_h_pallet.GetItemNumber(1, 'co_fabric_pro_des')
			
			co_tipoprod			= ads_h_pallet.GetItemNumber(1, 'co_tipoprod')
			co_tipo_lectura	= Trim(ads_h_pallet.GetItemString(1, 'co_tipo_lectura'))
			co_tipo_atributo	= Trim(ads_h_pallet.GetItemString(1, 'co_tipo_atributo'))			
			
		Case Else
			li_retorno = -2
			ROLLBACK;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el bongo ' + as_pallet + '~r~n' + ads_dt_pallet.is_sqlerrtext ,StopSign!)
	End Choose	
Else
	li_retorno = ll_filas
End If

Return li_retorno
end function

public function long of_hallar_hijos (string as_pallet);/*
Retorna el numero de hijos que tiene un bongo
*/
Long li_retorno
Long ll_filas
uo_dsbase lds_num_hijos


lds_num_hijos = Create uo_dsbase
lds_num_hijos.DataObject = 'd_gr_hallar_nro_hijos_com'
lds_num_hijos.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ll_filas = lds_num_hijos.Of_Retrieve(as_pallet)
// Se valida el error
If ll_filas < 0 Then
	MessageBox('Error', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar los hijos del bongo')
	li_retorno = -1
ElseIf ll_filas > 0 Then
	li_retorno = lds_num_hijos.GetItemNumber(1, 'nro_hijos')
End If
Destroy(lds_num_hijos)

Return li_retorno
end function

public function long of_cargar_remision (long al_remision, long ai_estado, ref uo_dsbase ads_h_canasta, ref uo_dsbase ads_dt_canasta);/*
Funci$$HEX1$$f300$$ENDHEX$$n para cargar las canastas que contiene una remision
*/

Long ll_filas, ll_i, ll_row
Long li_retorno
String ls_error
uo_dsbase lds_planta_ori_dest

lds_planta_ori_dest = Create uo_dsbase
lds_planta_ori_dest.DataObject = 'd_mae_plantas_com'
lds_planta_ori_dest.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

// Si no es valido se crea el ds
If Not IsValid(ads_h_canasta) Then
	ads_h_canasta = Create uo_dsbase
	ads_h_canasta.DataObject = 'd_gr_h_canastas_x_remision_com'
	ads_h_canasta.SetTransObject(SQLCA)
End If

If al_remision <= 0 Or IsNull(al_remision) Then
	Return -1
End If
If ai_estado <> 51 Then
	ls_error = 'La remision ' + String(al_remision) + ' No existe!'
ElseIf ai_estado = 51 Then
	ls_error = 'La remision ' + String(al_remision) + ' con estado 51 No existe!'
End If
	
// Se carga las canastas de la remision
ll_filas = ads_h_canasta.Of_Retrieve(al_remision, ai_estado)
// Se valida la carga
Choose Case ll_filas 
	Case 0 
		li_retorno = 0
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',ls_error,Information!)		
	Case Is > 0
		li_retorno = 1
	Case Else
		li_retorno = -1
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la remision ' + String(al_remision) + ' ' + ads_h_canasta.is_sqlerrtext ,StopSign!)
End Choose

If ll_filas > 0 Then	
	// Se carga los detalles de las canastas de la remision
	ll_filas = This.Of_Cargar_Detalle( ads_h_canasta, ads_dt_canasta)
	// Se valida la carga
	Choose Case ll_filas 
		Case 0 
			li_retorno = 0
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', ls_error,Information!)
		Case Is > 0
			li_retorno = 1
			// se toman los datos del origen y el destino
			co_fabrica_act		= ads_h_canasta.GetItemNumber(1, 'co_fabrica_act')
			co_planta_act		= ads_h_canasta.GetItemNumber(1, 'co_planta_act')
			co_centro_act		= ads_h_canasta.GetItemNumber(1, 'co_centro_act')
			co_subcentro_act	= ads_h_canasta.GetItemNumber(1, 'co_subcentro_act')
			
			co_fabrica			= ads_h_canasta.GetItemNumber(1, 'co_fabrica')
			co_planta			= ads_h_canasta.GetItemNumber(1, 'co_planta')
			co_centro_pdn		= ads_h_canasta.GetItemNumber(1, 'co_centro_pdn')
			co_subcentro_pdn	= ads_h_canasta.GetItemNumber(1, 'co_subcentro_pdn')
			
			co_tipoprod			= ads_h_canasta.GetItemNumber(1, 'co_tipoprod')
			
			co_fabrica_pro = ads_h_canasta.GetItemNumber(1, 'co_fabrica_pro')
			co_fabrica_pro_des = ads_h_canasta.GetItemNumber(1, 'co_fabric_pro_des')
			co_tipo_lectura = Trim(ads_h_canasta.GetItemString(1, 'co_tipo_lectura'))
			
			is_placa = RightTrim( ads_h_canasta.GetItemString(1, 'camion'))

			// Si falla al cargar la planta origen para validar si es tercero
			If lds_planta_ori_dest.Of_Retrieve(co_fabrica_act, co_planta_act) <= 0 Then
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible cargar la fabrica origen para validar si es un tercero o no", StopSign!)
				Return -1
			Else
				il_sw_tercero_act = lds_planta_ori_dest.GetItemNumber(1,'sw_tercero')
			End If
			
			// Si falla al cargar la planta destino para validar si es tercero
			If lds_planta_ori_dest.Of_Retrieve(co_fabrica, co_planta) <= 0 Then
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible cargar la fabrica destino para validar si es un tercero o no", StopSign!)
				Return -1
			Else
				il_sw_tercero_pdn = lds_planta_ori_dest.GetItemNumber(1,'sw_tercero')
			End If
		Case Else
			ROLLBACK;
			li_retorno = -2
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la remision ' + String(al_remision) + '~r~n' + ads_dt_canasta.is_sqlerrtext,StopSign!)
	End Choose	
Else
	li_retorno = ll_filas
End If

Return li_retorno
end function

public function long of_verificar_estado (long ai_estados[], uo_dsbase ads_h_canasta);Long ll_i, ll_row
String ls_expresion, ls_estados

If UpperBound(ai_estados) = 0 Then
	Return 0
Else
	ls_estados = String(ai_estados[1])
End If	

For ll_i = 2 To UpperBound(ai_estados)
	ls_estados += ',' + String(ai_estados[ll_i])
Next

ls_expresion = 'co_estado IN (' + ls_estados + ')'

ll_row = ads_h_canasta.Find(ls_expresion, 1, ads_h_canasta.RowCount())
If ll_row > 0 Then
	Return 1
Else
	Return 0
End If
end function

public function long of_verificar_ca_reprocesos (uo_dsbase ads_dt_canasta);Long ll_row_find
If IsValid(ads_dt_canasta) Then
	ll_row_find = ads_dt_canasta.Find('ca_reproceso = 0', 1, ads_dt_canasta.RowCount() + 1)
	If ll_row_find > 0 Then
		ib_sin_reproceso = True
	End If	
	ll_row_find = ads_dt_canasta.Find('ca_reproceso > 0', 1, ads_dt_canasta.RowCount() + 1)
	If ll_row_find > 0 Then
		ib_reproceso = True		
	End If	
End If
Return ll_row_find
end function

public function long of_buscar_lote (s_base_parametros astr_parametros);/*
Funci$$HEX1$$f300$$ENDHEX$$n que busca un lote en el datastore, 
En la estructura, estos son para los datos  
entero[1] = co_fabrica_ref
entero[2] = co_linea
entero[3] = co_referencia
entero[4] = co_talla
entero[5] = co_calidad
entero[6] = co_color
entero[7] = pedido
cadena[1] = po
cadena[2] = nu_cut		

*/

Long ll_lote,ll_reg
String ls_busqueda

If Isvalid(ids_lote) Then
	
	ls_busqueda = 'co_fabrica = '+String(astr_parametros.entero[1]) + ' and ' + &
				  'co_linea = '+String(astr_parametros.entero[2]) + ' and ' + &
				  'co_referencia = '+String(astr_parametros.entero[3]) + ' and ' + &
				  'co_talla = '+String(astr_parametros.entero[4]) + ' and ' + &
				  'co_calidad = '+String(astr_parametros.entero[5]) + ' and ' + &
				  'co_color = '+String(astr_parametros.entero[6]) + ' and ' + &
				  'cs_pedido = '+String(astr_parametros.entero[7]) + ' and ' + &
				  "po = '" + trim(astr_parametros.cadena[1]) + "' and " + &
				  "cs_cut = '" + trim(astr_parametros.cadena[2]) + "'" 

	ll_reg = ids_lote.Find(ls_busqueda, 1, ids_lote.RowCount() )	
	
	If ll_reg > 0 Then
		ll_lote = ids_lote.GetItemNumber(ll_reg,'lote')
		Return ll_lote
	Else
		Return -1
	End if
Else
	Return -1
End if
		
Return -1
end function

public function long of_consecutivo_nuevo_bongo (string as_tipo_consec, ref string as_bongo);
n_cst_funciones_comunes lnvo_fun

//Se captura el n$$HEX1$$fa00$$ENDHEX$$mero del nuevo bongo
as_bongo = lnvo_fun.of_consecutivo_bongo(0,as_tipo_consec,0)
Choose Case as_bongo
	Case '-1','-2','-3','-4','-5'
		Return Long(as_bongo)
	Case Else
		Return 1
End Choose

Return 1
end function

public function long of_nuevo_bongo (string as_po, long an_pedido, ref string as_bongo);uo_dsbase lds_cliente

//Crea el datastore con el que se captura el codigo del cliente
lds_cliente = Create uo_dsbase
lds_cliente.DataObject = 'd_gr_hallar_cliente_com'
lds_cliente.SetTransObject(SQLCA)

IF lds_cliente.Of_Retrieve(as_po) <= 0 THEN
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Imposible saber cual es el cliente para la PO ' + as_po &
				+ "~r~nPor favor comunicarse con Coordinaci$$HEX1$$f300$$ENDHEX$$n de Programas.", StopSign!)
	Return -1
END IF

//	Si existe mas de un cliente para la PO
If lds_cliente.RowCount() > 1 Then
	lds_cliente.Reset()
	lds_cliente.DataObject = 'd_gr_hallar_cliente_x_pedido_com'
	lds_cliente.SetTransObject(SQLCA)	
	If lds_cliente.Of_Retrieve(an_pedido) <= 0 Then Return -1
End If

il_cliente = lds_cliente.GetItemNumber(1,'co_cliente')
il_sucursal = lds_cliente.GetItemNumber(1,'co_sucursal')

//Llamado a la funci$$HEX1$$f300$$ENDHEX$$n que genera el consecutivo para el nuevo recipiente
If of_consecutivo_nuevo_bongo(lds_cliente.GetItemString(1,'co_tipo_consec'), as_bongo) < 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se pudo generar el consecutivo del bongo')
	Return -3
End If

Return 1
end function

public function long of_verificar_lote (s_base_parametros astr_parametros);/*
Funci$$HEX1$$f300$$ENDHEX$$n que verifica o crea un lote, se envia el sku, pedido, po, cut y lote anterior y
el sku, pedido, po, cut para el nuevo lote.
En la estructura, estos son para los datos anteriores 
entero[1] = co_fabrica_ref
entero[2] = co_linea
entero[3] = co_referencia
entero[4] = co_talla
entero[5] = co_calidad
entero[6] = co_color
entero[7] = cs_orden_corte
entero[8] = lote
entero[9] = fabrica_loteo
entero[10] = pedido
cadena[1] = po
cadena[2] = nu_cut		

y estos para los datos del nuevo lote
entero[11] = co_fabrica_ref
entero[12] = co_linea
entero[13] = co_referencia
entero[14] = co_talla
entero[15] = co_calidad
entero[16] = co_color
entero[17] = pedido
cadena[3] = po
cadena[4] = nu_cut
*/

Long ll_lote,ll_reg,ll_row,ll_lotemax
uo_dsbase lds_lote,lds_maxlote
n_cst_funciones_comunes lnvo_fun

//Crea el datastore con el cual se recuperan los registros de m_lotes_conf
lds_lote = Create uo_dsbase
lds_lote.DataObject = 'd_tb_mlotesconf_cut_com'
lds_lote.SetTransObject(SQLCA)
//Crea el datastore con el que se actualiza en m_lotes_conf al final del proceso

If Not IsValid(ids_lote) Then
	ids_lote = Create uo_dsbase
	ids_lote.DataObject = 'd_tb_mlotesconf_cut_com'
	ids_lote.SetTransObject(SQLCA)
End If

lds_lote.Of_Retrieve(astr_parametros.entero[11],astr_parametros.entero[12],astr_parametros.entero[13], &
							astr_parametros.entero[14],astr_parametros.entero[15],astr_parametros.entero[16], &
							astr_parametros.cadena[3],astr_parametros.cadena[4],0,0,astr_parametros.entero[17])	

//Si no encuentra un lote para las condiciones anteriores, se busca el lote 
//anterior con el fin de crear a partir de $$HEX1$$e900$$ENDHEX$$l, un nuevo registro en la tabla m_lotes_conf.
If lds_lote.RowCount() = 0 Then
	ll_reg = lds_lote.Of_Retrieve(astr_parametros.entero[1],astr_parametros.entero[2],astr_parametros.entero[3], &
	                  astr_parametros.entero[4],astr_parametros.entero[5],astr_parametros.entero[6], &
							astr_parametros.cadena[1],astr_parametros.cadena[2],0,astr_parametros.entero[8],astr_parametros.entero[10])
	If ll_reg < 0 Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Error buscando en m_lotes_conf')
		Return -1
	ElseIf ll_reg > 0 Then
		lds_lote.RowsCopy(ll_reg,ll_reg,Primary!,ids_lote,ids_lote.RowCount() + 1,Primary!)
		
		
		//Recupera el consecutivo del lote enviando como parametros el codigo de la
      //de la fabrica y el documento = 1
		ll_lotemax = lnvo_fun.of_consecutivo_lote(astr_parametros.entero[9],1)
		
		If ll_lotemax <= 0 Then
			Return -1
		End If
		
		ids_lote.SetItem(ids_lote.RowCount(),'lote',ll_lotemax)
		ids_lote.SetItem(ids_lote.RowCount(),'ca_numerada',0)
		
		ids_lote.SetItem(ids_lote.RowCount(),'co_fabrica',astr_parametros.entero[11])
		ids_lote.SetItem(ids_lote.RowCount(),'co_linea',astr_parametros.entero[12])
		ids_lote.SetItem(ids_lote.RowCount(),'co_referencia',astr_parametros.entero[13])
		ids_lote.SetItem(ids_lote.RowCount(),'co_talla',astr_parametros.entero[14])
		ids_lote.SetItem(ids_lote.RowCount(),'co_calidad',astr_parametros.entero[15])
		ids_lote.SetItem(ids_lote.RowCount(),'co_color',astr_parametros.entero[16])
		ids_lote.SetItem(ids_lote.RowCount(),'cs_pedido',astr_parametros.entero[17]) 
		ids_lote.SetItem(ids_lote.RowCount(),'po',astr_parametros.cadena[3])
		ids_lote.SetItem(ids_lote.RowCount(),'cs_cut',astr_parametros.cadena[4]) 
		ids_lote.SetItem(ids_lote.RowCount(),'atributo2',astr_parametros.cadena[5]) 
		
		
		ids_lote.SetItem(ids_lote.RowCount(),'fe_actualizacion',today() ) 
		ids_lote.SetItem(ids_lote.RowCount(),'usuario',gstr_info_usuario.codigo_usuario )
		ids_lote.SetItem(ids_lote.RowCount(),'instancia',gstr_info_usuario.instancia ) 
		
		Destroy lds_lote
		
		Return ll_lotemax
		
	ElseIf ll_reg = 0 Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','no se hallaron registros en m_lotes_conf para los siguientes datos: ' + &
		           '~rF$$HEX1$$e100$$ENDHEX$$brica = ' + String(astr_parametros.entero[1]) + &
					  '~rLinea = ' + String(astr_parametros.entero[2]) + &
					  '~rReferencia = ' + String(astr_parametros.entero[3]) + &
					  '~rTalla = ' + String(astr_parametros.entero[4]) + &
					  '~rCalidad = ' + String(astr_parametros.entero[5]) + &
					  '~rColor = ' + String(astr_parametros.entero[6]) + &
					  '~rPedido = ' + String(astr_parametros.entero[10]) + &
					  '~rPO = ' + astr_parametros.cadena[1] + &
					  '~rCut = ' + astr_parametros.cadena[2] + &
					  '~rLote = ' + String(astr_parametros.entero[8]))		
		Return -1
	End If
	
ElseIf lds_lote.RowCount() > 0 Then
	
	ll_lote = lds_lote.GetItemNumber(1,'lote')
	
	Destroy lds_lote
		
	Return ll_lote
End If
		
		
		
Return -1
end function

public function long of_cargar_camion (long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, string as_camion, ref uo_dsbase ads_h_pallet, ref uo_dsbase ads_dt_pallet);/*
Funci$$HEX1$$f300$$ENDHEX$$n para cargar las canastas que contiene un camion en la fabrica/planta/centro/subcentro
*/
Long ll_filas, ll_rows
Long li_retorno

// Si no es valido se crea el ds
If Not IsValid(ads_h_pallet) Then
	ads_h_pallet = Create uo_dsbase
	ads_h_pallet.DataObject = 'd_gr_h_canastas_x_camion_com'
	ads_h_pallet.SetTransObject(SQLCA)
End If

as_camion = RightTrim(as_camion)
If as_camion = '' Or IsNull(as_camion) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El bongo No existe!',Information!)		
	Return -1
End If

// Se carga las canastas del bongo
ll_filas = ads_h_pallet.Of_Retrieve(ai_fabrica, ai_planta, ai_centro, ai_subcentro, as_camion)
// Se valida la carga
Choose Case ll_filas 
	Case 0 
		li_retorno = 0
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No hay estibas para el camion "' + as_camion + '"!',Information!)		
	Case Is > 0
		li_retorno = 1
	Case Else
		li_retorno = -1
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar estibas para el camion ' + as_camion + ' ' + ads_h_pallet.is_sqlerrtext ,StopSign!)
End Choose

If ll_filas > 0 Then	
	// Se carga los detalles de las canastas del bongo
	ll_rows = This.Of_Cargar_Detalle(ads_h_pallet, ads_dt_pallet)
	// Se valida la carga
	Choose Case ll_rows 
		Case 0 
			li_retorno = 0
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El bongo ' + as_camion + ' No existe!',Information!)		
		Case Is > 0
			li_retorno = 1
			
			// se toman los datos del origen y el destino
			co_fabrica_act		= ads_h_pallet.GetItemNumber(1, 'co_fabrica_act')
			co_planta_act		= ads_h_pallet.GetItemNumber(1, 'co_planta_act')
			co_centro_act		= ads_h_pallet.GetItemNumber(1, 'co_centro_act')
			co_subcentro_act	= ads_h_pallet.GetItemNumber(1, 'co_subcentro_act')
			
			co_fabrica			= ads_h_pallet.GetItemNumber(1, 'co_fabrica')
			co_planta			= ads_h_pallet.GetItemNumber(1, 'co_planta')
			co_centro_pdn		= ads_h_pallet.GetItemNumber(1, 'co_centro_pdn')
			co_subcentro_pdn	= ads_h_pallet.GetItemNumber(1, 'co_subcentro_pdn')
			
			co_fabrica_pro		= ads_h_pallet.GetItemNumber(1, 'co_fabrica_pro')
			co_fabrica_pro_des= ads_h_pallet.GetItemNumber(1, 'co_fabric_pro_des')
			
			co_tipoprod			= ads_h_pallet.GetItemNumber(1, 'co_tipoprod')
			co_tipo_lectura	= Trim(ads_h_pallet.GetItemString(1, 'co_tipo_lectura'))
			co_tipo_atributo	= Trim(ads_h_pallet.GetItemString(1, 'co_tipo_atributo'))
		Case Else
			li_retorno = -2
			ROLLBACK;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el bongo ' + as_camion + '~r~n' + ads_dt_pallet.is_sqlerrtext ,StopSign!)
	End Choose	
Else
	li_retorno = ll_filas
End If

Return li_retorno
end function

public function long of_numero_estibas (uo_dsbase ads_h_canasta);String ls_estiba
Long ll_cantidad, ll_i
uo_dsbase lds_h_canasta

ll_cantidad = 0

If IsValid(ads_h_canasta) Then	
	If ads_h_canasta.RowCount() > 0 Then
		lds_h_canasta = Create uo_dsbase
		lds_h_canasta.DataObject = lds_h_canasta.DataObject 
		ads_h_canasta.RowsCopy(1, ads_h_canasta.RowCount(), Primary!, lds_h_canasta, 1, Primary!)
		
		ads_h_canasta.SetSort('estiba_id')
		ads_h_canasta.Sort()
				
		ls_estiba = ''
		
		For ll_i = 1 To ads_h_canasta.RowCount()
			If ls_estiba <> ads_h_canasta.GetItemString( ll_i, 'estiba_id') Then
				ll_cantidad ++
				ls_estiba = ads_h_canasta.GetItemString( ll_i, 'estiba_id') 
			End If		
		Next
		Destroy lds_h_canasta
	End If	
	
End If

Return ll_cantidad

end function

public function long of_numero_cajas (uo_dsbase ads_h_canasta);Long ll_fila, ll_cantidad
String ls_pallet_id

ll_cantidad = 0
If Not IsValid(ads_h_canasta) Then
	// no tiene registros cargados
ElseIf ads_h_canasta.RowCount() > 0 Then	
	ads_h_canasta.SetSort("pallet_id")
	ads_h_canasta.Sort()
	ls_pallet_id = ads_h_canasta.GetItemString(1,"pallet_id")	
	ll_fila = 1
	Do While ll_fila > 0 
		ll_cantidad ++
		ls_pallet_id = ads_h_canasta.GetItemString(ll_fila,"pallet_id")	
		ll_fila = ads_h_canasta.Find("pallet_id <> '" + String(ls_pallet_id) + "'", ll_fila + 1, ads_h_canasta.RowCount() + 1)
	Loop
End If
Return ll_cantidad
end function

public function long of_bongo_facturado (long ai_fabrica, long ai_planta, string as_pallet);/*
Consulta si el bongo no ha sido facturado
*/
Long li_retorno
Long ll_filas
uo_dsbase lds_bongo_facturado


lds_bongo_facturado = Create uo_dsbase
lds_bongo_facturado.DataObject = 'd_gr_bongo_facturado_com'
lds_bongo_facturado.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ll_filas = lds_bongo_facturado.Of_Retrieve( ai_fabrica, ai_planta, as_pallet)
// Se valida el error
If ll_filas < 0 Then
	MessageBox('Error', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el bongo')
	li_retorno = -1
ElseIf ll_filas > 0 Then
	li_retorno = lds_bongo_facturado.GetItemNumber(1, 'cantidad')
End If
Destroy(lds_bongo_facturado)

Return li_retorno
end function

public function long of_cargar_estiba (long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, string as_estiba, ref uo_dsbase ads_h_pallet, ref uo_dsbase ads_dt_pallet);/*
Funci$$HEX1$$f300$$ENDHEX$$n para cargar las canastas que contiene un camion en la fabrica/planta/centro/subcentro
*/
Long ll_filas, ll_rows
Long li_retorno

// Si no es valido se crea el ds
If Not IsValid(ads_h_pallet) Then
	ads_h_pallet = Create uo_dsbase
	ads_h_pallet.DataObject = 'd_gr_h_canastas_x_estiba_com'
	ads_h_pallet.SetTransObject(SQLCA)
End If

as_estiba = RightTrim(as_estiba)
If as_estiba = '' Or IsNull(as_estiba) Then
	If IsNull(as_estiba ) Then as_estiba = ''
	
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La estiba ' + as_estiba + ' No existe!',Information!)		
	Return -1
End If

// Se carga las canastas del bongo
ll_filas = ads_h_pallet.Of_Retrieve(ai_fabrica, ai_planta, ai_centro, ai_subcentro, as_estiba)
// Se valida la carga
Choose Case ll_filas 
	Case 0 
		li_retorno = 0
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No hay canastas para la estiba "' + as_estiba + '" o no han sido enviada~n'&
					+ 'Por favor verifique que ya se envio la estiba para poder recibirla en el CEDI',Information!)
	Case Is > 0
		li_retorno = 1
	Case Else
		li_retorno = -1
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar las canastas de la estiba ' + as_estiba + ' ' + ads_h_pallet.is_sqlerrtext ,StopSign!)
End Choose 

If ll_filas > 0 Then	
	// Se carga los detalles de las canastas del bongo
	ll_rows = This.Of_Cargar_Detalle(ads_h_pallet, ads_dt_pallet)
	// Se valida la carga
	Choose Case ll_rows 
		Case 0 
			li_retorno = 0
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La estiba ' + as_estiba + ' No existe!',Information!)		
		Case Is > 0
			li_retorno = 1
			
			// se toman los datos del origen y el destino
			co_fabrica_act		= ads_h_pallet.GetItemNumber(1, 'co_fabrica_act')
			co_planta_act		= ads_h_pallet.GetItemNumber(1, 'co_planta_act')
			co_centro_act		= ads_h_pallet.GetItemNumber(1, 'co_centro_act')
			co_subcentro_act	= ads_h_pallet.GetItemNumber(1, 'co_subcentro_act')
			
			co_fabrica			= ads_h_pallet.GetItemNumber(1, 'co_fabrica')
			co_planta			= ads_h_pallet.GetItemNumber(1, 'co_planta')
			co_centro_pdn		= ads_h_pallet.GetItemNumber(1, 'co_centro_pdn')
			co_subcentro_pdn	= ads_h_pallet.GetItemNumber(1, 'co_subcentro_pdn')
			
			co_fabrica_pro		= ads_h_pallet.GetItemNumber(1, 'co_fabrica_pro')
			co_fabrica_pro_des= ads_h_pallet.GetItemNumber(1, 'co_fabric_pro_des')
			
			co_tipoprod			= ads_h_pallet.GetItemNumber(1, 'co_tipoprod')
			co_tipo_lectura	= Trim(ads_h_pallet.GetItemString(1, 'co_tipo_lectura'))
			co_tipo_atributo	= Trim(ads_h_pallet.GetItemString(1, 'co_tipo_atributo'))
			
			is_placa = RightTrim( ads_h_pallet.GetItemString(1, 'camion') )
			
		Case Else
			li_retorno = -2
			ROLLBACK;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la estiba ' + as_estiba + '~r~n' + ads_dt_pallet.is_sqlerrtext ,StopSign!)
	End Choose	
Else
	li_retorno = ll_filas
End If

Return li_retorno
end function

public function long of_determinar_tipo_pedido (string al_pallet_id, ref string al_tipo_pedido);/*
	Funci$$HEX1$$f300$$ENDHEX$$n para determinar el tipo de pedido del pedido que tiene la canasta.
	
*/


uo_dsbase lds_determinar_tipo_pedido
long ll_ret 

lds_determinar_tipo_pedido = Create uo_dsbase
lds_determinar_tipo_pedido.DataObject = 'd_gr_determinar_tipo_pedido_x_pallet_com'
lds_determinar_tipo_pedido.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ll_ret = lds_determinar_tipo_pedido.Retrieve(al_pallet_id)

//Mira si hay alg$$HEX1$$fa00$$ENDHEX$$n error
If ll_ret < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al buscar el tipo de pedido del recipiente "+trim(al_pallet_id),StopSign!)
	Return -1
ElseIf ll_ret = 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se encontr$$HEX2$$f3002000$$ENDHEX$$el pedido para el recipiente "+Trim(al_pallet_id))	
	Return 0	
ElseIF ll_ret > 1 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Los pedidos asociados a la canasta "+trim(al_pallet_id)+" tienene varios tipos de pedidos. Por favor comuniquese con la persona encargada del maestro de pedidos")
	Return 0
End IF


al_tipo_pedido = lds_determinar_tipo_pedido.GetItemString(1,'tipo_pedido')

Return 1
end function

public function long of_validacion_caja_cambio_po (ref uo_dsbase ads_h_canasta, long al_registro);/*
Funcion que tiene las validaciones que se reaizan a las canastas para el cambio de referencia PO
*/


Long ll_consolida
uo_dsbase lds_consulta_subcentro


//mira que el recipiente este en el estado correcto para el cambio de ref po
If ads_h_canasta.GetItemNumber(al_registro,'co_estado') <> 60 and ads_h_canasta.GetItemNumber(al_registro,'co_estado') <> 65 &
	and ads_h_canasta.GetItemNumber(al_registro,'co_estado') <> 63 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No puede realizar el proceso a este recipiente porque no esta' + &
		              ' en un estado valido. Estado: ' + string(ads_h_canasta.GetItemNumber(al_registro,'co_estado')))
	Return -1
End If
	
//	Si el recipiente evaluado es de tipo lectura Reproceso Full Costo (RF)
If ads_h_canasta.GetItemString(al_registro,'co_tipo_lectura') = 'RF' Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No puede cambiar de referencia a un recipiente con tipo lectura Reproceso Full Costo (RF)")
	Return -1
End If

//	Halla el subcentro del recipiente
ll_consolida = 0

lds_consulta_subcentro = Create uo_dsbase
lds_consulta_subcentro.DataObject = 'd_gr_consolida_bongo_consulta_com'
lds_consulta_subcentro.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
If lds_consulta_subcentro.of_Retrieve(ads_h_canasta.GetItemNumber(al_registro,'co_fabrica_act'), &
												  ads_h_canasta.GetItemNumber(al_registro,'co_planta_act'), &
												  ads_h_canasta.GetItemNumber(al_registro,'co_centro_act'), &
												  ads_h_canasta.GetItemNumber(al_registro,'co_subcentro_act')) > 0 Then
	ll_consolida = lds_consulta_subcentro.GetItemNumber(1,'sw_consolida')
	//Si el recipiente o bongo esta en el centro Despachado , no se le puede realizar el proceso
	If ll_consolida = 10 Or ll_consolida = 11 Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No puede realizar ningun proceso a este recipiente,'&
					+ ' porque ya est$$HEX2$$e1002000$$ENDHEX$$facturado.',Information!)
		Return -1
	End If
Else
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No puede encontrar el subcentro del recipiente.')
	Return -1
End If

//el subcentro origen tiene que ser igual al subcentro destino
If ads_h_canasta.GetItemNumber(al_registro,'co_fabrica_act') <> ads_h_canasta.GetItemNumber(al_registro,'co_fabrica') &
	or ads_h_canasta.GetItemNumber(al_registro,'co_planta_act') <> ads_h_canasta.GetItemNumber(al_registro,'co_planta') &
	or ads_h_canasta.GetItemNumber(al_registro,'co_centro_act') <> ads_h_canasta.GetItemNumber(al_registro,'co_centro_pdn')&
	or ads_h_canasta.GetItemNumber(al_registro,'co_subcentro_act') <> ads_h_canasta.GetItemNumber(al_registro,'co_subcentro_pdn') Then

	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El Subcentro Destino es diferente al Subcentro Origen de la canasta. " &
					+ "~r~nNo se puede realizar el cambio a la canasta.")
	Return -1
End if


Return 1
end function

public function long of_validar_propietario_sourcing (ref uo_dsbase ads_dt_canasta, long ai_propietario);/*	------------------------------------------------------------------------
	Funcion utilizada para validar que una canasta con propietario sourcing
	(co_fabrica_pro = 99) corresponda a un pedido de sourcing 
	(fabrica_vta = 99).   Recibe como argumento el detalle de la canasta y
	consulta los pedidos para todas las PO de la canasta
	------------------------------------------------------------------------ */
String ls_pos[]
uo_dsbase lds_pedido

//	Se crea el ds utilizado para consultar pedidos con propietario errado
lds_pedido = Create uo_dsbase
lds_pedido.DataObject = 'd_gr_hallar_propietario_sourcing_errado'
lds_pedido.SetTransObject(SQLCA)

//	Se capturan todas las PO contenidas en el detalle de la canasta
ls_pos = ads_dt_canasta.Object.po.Primary

//	Si se encuentran PO's con propietario diferente de 99 (co_fabrica_vta <> ai_propietario)
If lds_pedido.Of_Retrieve(ls_pos, ai_propietario) > 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La PO " + Trim(lds_pedido.GetItemString(1,'orden_compra')) &
				+ " contenida en el recipiente; no es una PO de sourcing", StopSign!)
	Return -1
ElseIf lds_pedido.RowCount() < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se logro validar si las PO del recipiente son de propietario Sourcing (" &
				+ String(ai_propietario)+ ")", StopSign!)
	Return -2
End If

//	Se destruye el ds utilizado durante la validacion
Destroy lds_pedido

Return 1
end function

on n_cst_canasta.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_canasta.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

