HA$PBExportHeader$n_cst_cambios_po.sru
forward
global type n_cst_cambios_po from nonvisualobject
end type
end forward

global type n_cst_cambios_po from nonvisualobject autoinstantiate
end type

type variables

//variable para saber si ya escogieron realizar algun cambio
//0 no hay ningun cambio, 1 cambio PO, 2 cambio Ref, 3 cambio parcial 
Long ii_cambio = 0, ii_fabrica_exp, ii_linea_exp, ii_tipo_concepto, ii_sw_crea_caja
Long il_ano, il_mes, il_turno,il_fabrica_loteo, il_semana,il_cliente, il_sucursal
String is_recipiente_actual, is_recipiente_nuevo, is_ref_exp, is_talla_exp, &
			is_color_exp, is_upc, is_programa, is_gpa=''
DateTime idt_fecha
s_base_parametros istr_estilo_nuevo

uo_dsbase ids_hcanasta_origen,ids_dtcanasta_origen,ids_hcanasta_destino,ids_dtcanasta_destino, &
				ids_cambios_referencia, ids_cambios, ids_dtsku_cambio,ids_dtsku_sincambio, ids_dtsku_cambio_orig
				
n_cst_canasta invo_lotes_canasta
end variables

forward prototypes
public function long of_valida_cambio_po_pedido (s_base_parametros astr_parametros)
public function long of_registra_cambio_ref_po (s_base_parametros astr_parametros)
public function long of_preparar_datos_cambio_po (string as_recipiente)
public function long of_seleccionar_pedido_po_cut (s_base_parametros astr_autoriza_po)
public function long of_seleccionar_ref_pedido_po_cut (s_base_parametros astr_autoriza_po)
public function long of_realiza_mov_detalles_canasta ()
public function long of_registra_dt_cambios_referen (s_base_parametros astr_parametros)
public function long of_realiza_mov_parcial_canasta (uo_dsbase ads_recipiente_destino)
public function long of_cambio_ref_po (string as_recipiente, long ai_tipo_concepto, long ai_crea_caja)
public function long of_cambio_ref_parcial (string as_recipiente, uo_dsbase ads_recipiente_destino, long ai_tipo_concepto, long ai_crea_caja)
public function long of_set_programa (string as_programa)
public function long of_busca_sku_venta (long an_pedido, string as_po, string as_nu_cut, long an_fabrica, long an_linea, long an_referencia, long an_talla, long an_calidad, long an_color)
public function long of_valida_sku_en_pedido (long an_pedido, string as_po, string as_nu_cut, long an_fabrica, long an_linea, long an_referencia, long an_talla, long an_calidad, long an_color)
end prototypes

public function long of_valida_cambio_po_pedido (s_base_parametros astr_parametros);
/*
Funcion para validar de que este definido el cambio de PO
En la estructura se envia el subcentro en donde se va a realizar el cambio de PO,
el pedido, PO, cut origen y destino
astr_parametros.entero[5] pedido origen 
astr_parametros.cadena[1] PO origen
astr_parametros.cadena[2] cut origen
astr_parametros.entero[6] pedido destino 
astr_parametros.cadena[3] PO destino
astr_parametros.cadena[4] cut destino
*/
Long li_ret
s_base_parametros lstr_parametros, lstr_vacio
uo_dsbase lds_po_autorizadas


//se valida de que los pedidos, POs y cut no sean los mismos
If Trim(astr_parametros.cadena[1]) <> Trim(astr_parametros.cadena[3]) Or &
	Trim(astr_parametros.cadena[2]) <> Trim(astr_parametros.cadena[4]) Or &
	astr_parametros.entero[5] <> astr_parametros.entero[6] Then
	
	lds_po_autorizadas = Create uo_dsbase
	lds_po_autorizadas.DataObject = 'd_tb_mnmto_validar_po_pedido_com'
	lds_po_autorizadas.SetTransObject(SQLCA)
	
	If lds_po_autorizadas.Retrieve(astr_parametros.entero[1], astr_parametros.entero[2], &
											  astr_parametros.entero[3], astr_parametros.entero[4], &
											  astr_parametros.cadena[3], astr_parametros.cadena[4], &
											  astr_parametros.entero[6]) <= 0 Then
		Beep(1)
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se han definido cambios para el PO/Cut seleccionado (PO Nueva '" &
							+ Trim(astr_parametros.cadena[3]) + "' Cut Nueva '" + Trim(astr_parametros.cadena[4]) & 
							+ "' Pedido nuevo " + String(astr_parametros.entero[6]) +")~n para la Fabrica " &
							+ String(astr_parametros.entero[1]) + " Planta " + String(astr_parametros.entero[2]) &
							+ " Centro " + String(astr_parametros.entero[3]) + " Subcentro " + String(astr_parametros.entero[4]) &
							+ "~r~nNo es posible realizar cambios de PO.~r~nPor favor ingrese el cambio de PO por el menu Administraci$$HEX1$$f300$$ENDHEX$$n-" &
							+ "Informaci$$HEX1$$f300$$ENDHEX$$n Basica-Mantenimiento Cambios de PO.")
		Return -1
	End If
			
	//	Si no encuentra registrada la po original y la nueva en dt_validacion_po; informa al usuario y falla
	If lds_po_autorizadas.Find("po_original = '" + Trim(astr_parametros.cadena[1]) + "' And " &
											+  "nu_cut_original  = '" + Trim(astr_parametros.cadena[2]) + "' And " &
											+  "pedido_original = " + String(astr_parametros.entero[5]) + " and " &
											+  "po_nueva = '" + Trim(astr_parametros.cadena[3]) + "' And " &
											+  "nu_cut_nueva = '" + Trim(astr_parametros.cadena[4]) + "' and " &
											+  "pedido_nuevo = " + String(astr_parametros.entero[6]) &
											,1,lds_po_autorizadas.RowCount()) <= 0 Then
		Beep(1)
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se ha autorizado cambiar la PO/Cut " + Trim(astr_parametros.cadena[1]) &
					+ " / " + Trim(astr_parametros.cadena[2]) + " pedido " + String(astr_parametros.entero[5])  &
					+ " a la PO/Cut " + Trim(astr_parametros.cadena[3]) + " / " &
					+ Trim(astr_parametros.cadena[4]) + " pedido " + String(astr_parametros.entero[6]) &
					+ "~n para la Fabrica " + String(astr_parametros.entero[1]) + " Planta " + String(astr_parametros.entero[2]) &
					+ " Centro " + String(astr_parametros.entero[3]) + " Subcentro " + String(astr_parametros.entero[4]) &
					+ "~r~nPor favor ingrese el cambio de PO por el menu Administraci$$HEX1$$f300$$ENDHEX$$n-" &
							+ "Informaci$$HEX1$$f300$$ENDHEX$$n Basica-Mantenimiento Cambios de PO.")
		Return -1
	End If
End If


Return 1
end function

public function long of_registra_cambio_ref_po (s_base_parametros astr_parametros);/*Funci$$HEX1$$f300$$ENDHEX$$n en donde se registra el cambio de ref po en la tabla mv_cambios_referencia
*/

String ls_sqlerrtext, ls_tipo_lect, ls_po_origen, ls_cut_origen, &
			ls_po_des, ls_cut_des, ls_conjunto, ls_tipo_movimiento
Long ll_lote, ll_referencia_origen,  ll_referencia_des, ll_reg, ll_pedido_origen,ll_pedido_destino, ll_color_origen, ll_color_des
Decimal{2} ldc_ca_producida_origen, ldc_ca_producida_des
Long li_fab_origen, li_planta_origen, li_centro_origen, &
		  li_subcentro_origen, li_fab_des, li_planta_des,  li_centro_des, &
		  li_subcentro_des, li_tipoprod, li_fab_ref_origen, li_linea_origen, &
		  li_talla_origen, li_calidad_origen, li_fabrica_pro_origen, &
		  li_modulo_fis, li_modulo, li_fab_ref_des, li_linea_des, li_talla_des, &
		  li_calidad_des, li_fabrica_pro_des
		  
ls_conjunto = '0'
ls_tipo_movimiento = 'N'

ll_lote = astr_parametros.entero[1]
li_fab_origen = astr_parametros.entero[2]
li_planta_origen = astr_parametros.entero[3]
li_centro_origen = astr_parametros.entero[4]
li_subcentro_origen = astr_parametros.entero[5]
li_fab_des = astr_parametros.entero[6]
li_planta_des = astr_parametros.entero[7]
li_centro_des = astr_parametros.entero[8]
li_subcentro_des = astr_parametros.entero[9]
ls_tipo_lect = astr_parametros.cadena[1]
li_tipoprod = astr_parametros.entero[10]
ls_po_origen = astr_parametros.cadena[2]
ls_cut_origen = astr_parametros.cadena[3]
li_fab_ref_origen = astr_parametros.entero[11]
li_linea_origen = astr_parametros.entero[12]
ll_referencia_origen = astr_parametros.entero[13]
li_talla_origen = astr_parametros.entero[14]
li_calidad_origen = astr_parametros.entero[15]
ll_color_origen = astr_parametros.entero[16]
li_fabrica_pro_origen = astr_parametros.entero[17]
ldc_ca_producida_origen = astr_parametros.decimal[1]
li_modulo_fis = astr_parametros.entero[18]
li_modulo = astr_parametros.entero[19]
ls_po_des = astr_parametros.cadena[4]
ls_cut_des = astr_parametros.cadena[5]
li_fab_ref_des = astr_parametros.entero[20]
li_linea_des = astr_parametros.entero[21]
ll_referencia_des = astr_parametros.entero[22]
li_talla_des = astr_parametros.entero[23]
li_calidad_des = astr_parametros.entero[24]
ll_color_des = astr_parametros.entero[25]
li_fabrica_pro_des = astr_parametros.entero[26]
ldc_ca_producida_des = astr_parametros.decimal[2]
ll_pedido_origen = astr_parametros.entero[27]
ll_pedido_destino = astr_parametros.entero[28]

	
ll_reg = ids_cambios_referencia.InsertRow(0)
If ll_reg > 0 Then
	ids_cambios_referencia.SetItem(ll_reg,'de_conjunto', ls_conjunto)
	ids_cambios_referencia.SetItem(ll_reg,'lote', ll_lote)
	ids_cambios_referencia.SetItem(ll_reg,'co_fabrica_origen', li_fab_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_planta_origen', li_planta_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_bodega_origen', 1)
	ids_cambios_referencia.SetItem(ll_reg,'co_centro_origen', li_centro_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_subcentro_origen', li_subcentro_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_fabrica_destino', li_fab_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_planta_destino', li_planta_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_bodega_destino', 1)
	ids_cambios_referencia.SetItem(ll_reg,'co_centro_destino', li_centro_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_subcentro_destino', li_subcentro_des)
	ids_cambios_referencia.SetItem(ll_reg,'ano', il_ano)
	ids_cambios_referencia.SetItem(ll_reg,'mes', il_mes)
	ids_cambios_referencia.SetItem(ll_reg,'signo', 1)
	ids_cambios_referencia.SetItem(ll_reg,'co_tipo_act', 'I')
	ids_cambios_referencia.SetItem(ll_reg,'co_tipo_lect', ls_tipo_lect)
	ids_cambios_referencia.SetItem(ll_reg,'co_turno', il_turno)
	ids_cambios_referencia.SetItem(ll_reg,'co_tipoprod', li_tipoprod)
	ids_cambios_referencia.SetItem(ll_reg,'pedido_origen', ll_pedido_origen)
	ids_cambios_referencia.SetItem(ll_reg,'po_origen', ls_po_origen)
	ids_cambios_referencia.SetItem(ll_reg,'nu_cut_origen', ls_cut_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_fabrica_ref_origen', li_fab_ref_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_linea_origen', li_linea_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_referencia_origen', ll_referencia_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_talla_origen', li_talla_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_calidad_origen', li_calidad_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_color_origen', ll_color_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_fabrica_pro_origen', li_fabrica_pro_origen)
	ids_cambios_referencia.SetItem(ll_reg,'ca_producida_origen', ldc_ca_producida_origen)
	ids_cambios_referencia.SetItem(ll_reg,'co_modulo_fis', li_modulo_fis)
	ids_cambios_referencia.SetItem(ll_reg,'co_modulo', li_modulo)
	
	ids_cambios_referencia.SetItem(ll_reg,'pedido_destino', ll_pedido_destino)
	ids_cambios_referencia.SetItem(ll_reg,'po_destino', ls_po_des)
	ids_cambios_referencia.SetItem(ll_reg,'nu_cut_destino', ls_cut_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_fabrica_ref_destino', li_fab_ref_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_linea_destino', li_linea_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_referencia_destino', ll_referencia_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_talla_destino', li_talla_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_calidad_destino', li_calidad_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_color_destino', ll_color_des)
	ids_cambios_referencia.SetItem(ll_reg,'co_fabrica_pro_destino', li_fabrica_pro_des)
	ids_cambios_referencia.SetItem(ll_reg,'ca_producida_destino', ldc_ca_producida_des)
	ids_cambios_referencia.SetItem(ll_reg,'tipo_movimiento', ls_tipo_movimiento)
	
End if


Return 1
end function

public function long of_preparar_datos_cambio_po (string as_recipiente);
/*
Funcion en donde se crea ds para el cambio de ref PO 
*/

Long ll_turno, ll_pedido, ll_n
Long li_ano, li_mes, li_turno
String ls_error
n_cst_funciones_comunes lnvo_funcion
n_cst_mover_kardex lnvo_kardex
uo_dsbase lds_semana, lds_cliente

//	Destruye los Datastore si existian previamente.
If IsValid(ids_hcanasta_origen) Then Destroy ids_hcanasta_origen
If IsValid(ids_dtcanasta_origen) Then Destroy ids_dtcanasta_origen
If IsValid(ids_hcanasta_destino) Then Destroy ids_hcanasta_destino
If IsValid(ids_dtcanasta_destino) Then Destroy ids_dtcanasta_destino
If IsValid(ids_dtsku_cambio) Then Destroy ids_dtsku_cambio
If IsValid(ids_dtsku_sincambio) Then Destroy ids_dtsku_sincambio
If IsValid(ids_dtsku_cambio_orig) Then Destroy ids_dtsku_cambio_orig
	

ids_hcanasta_origen = Create uo_dsbase
ids_hcanasta_origen.DataObject = 'd_gr_h_bongo_corte_com'
ids_hcanasta_origen.SetTransObject(SQLCA)

ids_dtcanasta_origen = Create uo_dsbase
ids_dtcanasta_origen.DataObject = 'd_gr_dt_bongo_corte_com'
ids_dtcanasta_origen.SetTransObject(SQLCA)

ids_hcanasta_destino = Create uo_dsbase
ids_hcanasta_destino.DataObject = 'd_gr_h_bongo_corte_com'
ids_hcanasta_destino.SetTransObject(SQLCA)

ids_dtcanasta_destino = Create uo_dsbase
ids_dtcanasta_destino.DataObject = 'd_gr_dt_bongo_corte_com'
ids_dtcanasta_destino.SetTransObject(SQLCA)

ids_cambios_referencia = Create uo_dsbase
ids_cambios_referencia.Dataobject = 'd_gr_hallar_cambio_ref_lote_pedid_com'
ids_cambios_referencia.SetTransObject(SQLCA)

//si es un cambio parcial de la cannasta se crean los dw para mirar que ref tienen 
//o no algun cambio
If ii_cambio = 3 Then
	ids_dtsku_cambio = Create uo_dsbase
	ids_dtsku_cambio.DataObject = 'd_gr_dt_bongo_corte_com'
	ids_dtsku_cambio.SetTransObject(SQLCA)
	
	ids_dtsku_sincambio = Create uo_dsbase
	ids_dtsku_sincambio.DataObject = 'd_gr_dt_bongo_corte_com'
	ids_dtsku_sincambio.SetTransObject(SQLCA)

	
	ids_dtsku_cambio_orig = Create uo_dsbase
	ids_dtsku_cambio_orig.DataObject = 'd_gr_dt_bongo_corte_com'
	ids_dtsku_cambio_orig.SetTransObject(SQLCA)
End if

is_recipiente_actual = Trim(as_recipiente)

//carga datos del encabezado de la canasta del cambio
If ids_hcanasta_origen.of_Retrieve(is_recipiente_actual) <= 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se recupero la canasta origen. ' + &
			  'Por favor avise al administrador del sistema', StopSign!)
	Return -1
End If

//carga detalle de la canasta del cambio
If ids_dtcanasta_origen.of_Retrieve(is_recipiente_actual) <= 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se recuperaron registros detallados para la canasta origen. ' + &
			  'Por favor avise al administrador del sistema')
	Return -2
Else	//	Sino fallo la carga de los detalle
	//	Se 'eliminan los registros que no tienen cantidad'
	ids_dtcanasta_origen.SetFilter("ca_actual > 0")
	ids_dtcanasta_origen.Filter()
End If


//si el valor es 1 se crea caja nueva 
If ii_sw_crea_caja = 1 Then
	//si el cambio es parcial el pedido esta en el dw de la canasta
	If ii_cambio = 3 Then
		ll_pedido = ids_dtcanasta_origen.GetItemNumber(1,'pedido')
		If invo_lotes_canasta.of_nuevo_bongo( ids_dtcanasta_origen.GetItemString(1,'po'),ll_pedido,is_recipiente_nuevo) < 0 Then Return -1
	Else
		ll_pedido = istr_estilo_nuevo.Entero[7]
		If invo_lotes_canasta.of_nuevo_bongo( istr_estilo_nuevo.cadena[1],ll_pedido,is_recipiente_nuevo) < 0 Then Return -1
	End if
	
	il_cliente = invo_lotes_canasta.il_cliente
	il_sucursal = invo_lotes_canasta.il_sucursal
	
	
Else
	//como se crea caja nuevo, el recipiente nuevo es el mismo que el actual
	is_recipiente_nuevo = is_recipiente_actual
	
	//si el cambio es parcial el pedido esta en el dw de la canasta
	If ii_cambio = 3 Then
		ll_pedido = ids_dtcanasta_origen.GetItemNumber(1,'pedido')
	Else
		ll_pedido = istr_estilo_nuevo.Entero[7]
	End if
	//Crea el datastore con el que se captura el codigo del cliente
	lds_cliente = Create uo_dsbase
	lds_cliente.DataObject = 'd_gr_hallar_cliente_x_pedido_com'
	lds_cliente.SetTransObject(SQLCA)
	
	IF lds_cliente.Of_Retrieve(ll_pedido) <= 0 THEN
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Imposible saber cual es el cliente para el pedido ' + string(ll_pedido) &
					+ "~r~nPor favor comunicarse con Coordinaci$$HEX1$$f300$$ENDHEX$$n de Programas.", StopSign!)
		Return -1
	END IF
	il_cliente = lds_cliente.GetItemNumber(1,'co_cliente')
	il_sucursal = lds_cliente.GetItemNumber(1,'co_sucursal')
	
	Destroy lds_cliente
End if



//Captura la f$$HEX1$$e100$$ENDHEX$$brica que lotea
il_fabrica_loteo = lnvo_funcion.of_fabrica_loteo(ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act'))


//	Si falla al hallar el ano mes falla
If lnvo_funcion.of_hallar_ano_mes(ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act'), li_ano, li_mes) <= 0 Then Return -4
il_ano = li_ano
il_mes = li_mes

idt_fecha = lnvo_funcion.of_fecha_servidor()

//	Si falla al hallar el turno falla
If lnvo_funcion.of_hallar_turno(li_turno) <= 0 Then Return -3
il_turno = li_turno

//Crea el datastore con el que se recupera el n$$HEX1$$fa00$$ENDHEX$$mero de semana de la fecha actual 
lds_semana = Create uo_dsbase
lds_semana.DataObject = 'd_gr_semana_com'
lds_semana.SetTransObject(SQLCA)
ll_n = lds_semana.of_Retrieve(Date(idt_fecha))
If ll_n <= 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informaci$$HEX1$$f300$$ENDHEX$$n el calendario contable para la fecha ' + &
					String(Date(idt_fecha)))
	Return -1
End if
il_semana = lds_semana.GetItemNumber(1,'semana')

//si el valor es 1 se crea caja nueva 
If ii_sw_crea_caja = 1 Then
	ids_hcanasta_origen.RowsCopy(1,1,Primary!, ids_hcanasta_destino,ids_hcanasta_destino.RowCount() + 1,Primary!)
	
	//Se actualizan los campos necesarios para la nueva canasta
	ids_hcanasta_destino.SetItem(1,'cs_canasta', is_recipiente_nuevo)
	ids_hcanasta_destino.SetItem(1,'pallet_id', is_recipiente_nuevo)
	ids_hcanasta_destino.SetItem(1,'fe_creacion',idt_fecha)
	ids_hcanasta_destino.SetItem(1,'fe_actualizacion',idt_fecha)
	ids_hcanasta_destino.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
	ids_hcanasta_destino.SetItem(1,'instancia',gstr_info_usuario.instancia)	
	
	ids_hcanasta_origen.SetItem(1,'fe_actualizacion',idt_fecha)
	ids_hcanasta_origen.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
	ids_hcanasta_origen.SetItem(1,'instancia',gstr_info_usuario.instancia)
	ids_hcanasta_destino.SetItem(1,'co_tipo_lectura','N')
Else
	ids_hcanasta_origen.SetItem(1,'fe_actualizacion',idt_fecha)
	ids_hcanasta_origen.SetItem(1,'usuario',gstr_info_usuario.codigo_usuario)
	ids_hcanasta_origen.SetItem(1,'instancia',gstr_info_usuario.instancia)
End if

Destroy lds_semana
Return 1
end function

public function long of_seleccionar_pedido_po_cut (s_base_parametros astr_autoriza_po);
/*
Funcion para seleccionar el pedido, PO y cut para el cambio de PO, tambien se valida si
ya se realizo la autorizacion para el cambio de PO con los datos de la estructura

astr_autoriza_po.entero[1] = co_fabrica_act
astr_autoriza_po.entero[2] = co_planta_act
astr_autoriza_po.entero[3] = co_centro_act
astr_autoriza_po.entero[4] = co_subcentro_act
astr_autoriza_po.entero[5] = pedido
astr_autoriza_po.cadena[1] = po
astr_autoriza_po.cadena[2] = nu_cut
*/
Long ll_n
String ls_ventana
s_base_parametros lstr_cambio_po
Window lw_ventana

ls_ventana = 'w_seleccionar_pedido_x_po'
//	Abre la ventana que permite seleccionar el nuevo estilo
Open(lw_ventana, ls_ventana)
istr_estilo_nuevo = Message.PowerObjectParm
If Not istr_estilo_nuevo.hay_parametros Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No seleccion$$HEX2$$f3002000$$ENDHEX$$la PO nueva...Por favor seleccionelo")
	ii_cambio = 0
	Return -1
Else
		lstr_cambio_po.hay_parametros = TRUE
		lstr_cambio_po.entero[1]=astr_autoriza_po.entero[1]
		lstr_cambio_po.entero[2]=astr_autoriza_po.entero[2]
		lstr_cambio_po.entero[3]=astr_autoriza_po.entero[3]
		lstr_cambio_po.entero[4]=astr_autoriza_po.entero[4]
		lstr_cambio_po.entero[5]=astr_autoriza_po.entero[5]
		lstr_cambio_po.entero[6]=istr_estilo_nuevo.entero[1]
		lstr_cambio_po.cadena[1]=astr_autoriza_po.cadena[1]
		lstr_cambio_po.cadena[2]=astr_autoriza_po.cadena[2]
		lstr_cambio_po.cadena[3]=istr_estilo_nuevo.cadena[1]
		lstr_cambio_po.cadena[4]=istr_estilo_nuevo.cadena[2]
	
		If of_valida_cambio_po_pedido(lstr_cambio_po) < 0 Then 
			ii_cambio = 0
			Return -1
		Else
			ii_cambio = 1
		End if
End If


Return 1
end function

public function long of_seleccionar_ref_pedido_po_cut (s_base_parametros astr_autoriza_po);
/*
Funcion para seleccionar el sku prod, pedido, PO y cut para el cambio de PO, tambien se valida si
ya se realizo la autorizacion para el cambio de PO con los datos de la estructura

astr_autoriza_po.entero[1] = co_fabrica_act
astr_autoriza_po.entero[2] = co_planta_act
astr_autoriza_po.entero[3] = co_centro_act
astr_autoriza_po.entero[4] = co_subcentro_act
astr_autoriza_po.entero[5] = pedido
astr_autoriza_po.cadena[1] = po
astr_autoriza_po.cadena[2] = nu_cut
*/
String ls_ventana
s_base_parametros lstr_cambio_po
Window lw_ventana


ls_ventana = 'w_seleccionar_po_ref_x_po'
lstr_cambio_po.hay_parametros = False
//	Abre la ventana que permite seleccionar el nuevo estilo
OpenWithParm(lw_ventana, lstr_cambio_po, ls_ventana)
istr_estilo_nuevo = Message.PowerObjectParm
If Not istr_estilo_nuevo.hay_parametros Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No seleccion$$HEX2$$f3002000$$ENDHEX$$el estilo nuevo...Por favor seleccionelo")
	ii_cambio = 0
	Return -1
Else
		lstr_cambio_po.hay_parametros = TRUE
		lstr_cambio_po.entero[1]=astr_autoriza_po.entero[1]
		lstr_cambio_po.entero[2]=astr_autoriza_po.entero[2]
		lstr_cambio_po.entero[3]=astr_autoriza_po.entero[3]
		lstr_cambio_po.entero[4]=astr_autoriza_po.entero[4]
		lstr_cambio_po.entero[5]=astr_autoriza_po.entero[5]
		lstr_cambio_po.entero[6]=istr_estilo_nuevo.entero[7]
		lstr_cambio_po.cadena[1]=astr_autoriza_po.cadena[1]
		lstr_cambio_po.cadena[2]=astr_autoriza_po.cadena[2]
		lstr_cambio_po.cadena[3]=istr_estilo_nuevo.cadena[1]
		lstr_cambio_po.cadena[4]=istr_estilo_nuevo.cadena[2]
	
		If of_valida_cambio_po_pedido(lstr_cambio_po) < 0 Then 
			ii_cambio = 0
			Return -1
		Else
			ii_cambio = 2
		End if
End If


Return 1
end function

public function long of_realiza_mov_detalles_canasta ();Long ll_contador, ll_lote_new, ll_row, ll_reg_destino, ll_cantidad, &
		ll_fabrica_exp, ll_linea_exp, ll_n
String ls_upc, ls_ref_exp, ls_talla_exp, ls_color_exp
s_base_parametros lstr_parametros_cambios, lstr_parametros, lstr_parametros_cambios_ref, &
						lstr_parametros_lote


//Si se esta haciendo un cambio de ref se busca la ref de venta
If ii_cambio = 2 Then
//	If of_busca_sku_venta(istr_estilo_nuevo.entero[7], &
//				istr_estilo_nuevo.cadena[1], istr_estilo_nuevo.cadena[2], &
//				istr_estilo_nuevo.entero[1],&
//				istr_estilo_nuevo.entero[2],&
//				istr_estilo_nuevo.entero[3],&
//				istr_estilo_nuevo.entero[4],&
//				istr_estilo_nuevo.entero[5],&
//				istr_estilo_nuevo.entero[6]) < 0 Then
//				rollback;
//				Return -1
//		End if
		
	ii_fabrica_exp = istr_estilo_nuevo.entero[8]
	ii_linea_exp = istr_estilo_nuevo.entero[9]
	is_ref_exp = istr_estilo_nuevo.cadena[5]
	is_talla_exp = istr_estilo_nuevo.cadena[6]
	is_color_exp = istr_estilo_nuevo.cadena[7]
	is_upc = istr_estilo_nuevo.cadena[4]
End if

For ll_contador = 1 To ids_dtcanasta_origen.RowCount()
	
	
		//Se capturan los datos de dt_canasta_corte del bongo digitado en 
		//sle_bongo para realizar la verificaci$$HEX1$$f300$$ENDHEX$$n en m_lotes_conf
		lstr_parametros.entero[1] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_fabrica_ref')
		lstr_parametros.entero[2] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_linea')
		lstr_parametros.entero[3] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_referencia')
		lstr_parametros.entero[4] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_talla')
		lstr_parametros.entero[5] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_calidad')
		lstr_parametros.entero[6] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_color')
		lstr_parametros.cadena[1] = ids_dtcanasta_origen.GetItemString(ll_contador,'po')
		lstr_parametros.cadena[2] = ids_dtcanasta_origen.GetItemString(ll_contador,'nu_cut')
		lstr_parametros.entero[7] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'cs_orden_corte')
		lstr_parametros.entero[8] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'lote')
		lstr_parametros.entero[9] = il_fabrica_loteo
		lstr_parametros.entero[10] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'pedido')
		
		//si es un cambio de ref se toma la ref destino
		If ii_cambio = 2 Then
			
			//como se cambia de ref, se asigna en la estructura para buscar el lote,
			//la misma estructura del cambio porque este contiene la ref nueva
			lstr_parametros_lote = istr_estilo_nuevo
			
			//sku destino
			lstr_parametros.entero[11] = istr_estilo_nuevo.entero[1]
			lstr_parametros.entero[12] = istr_estilo_nuevo.entero[2]
			lstr_parametros.entero[13] = istr_estilo_nuevo.entero[3]
			lstr_parametros.entero[14] = istr_estilo_nuevo.entero[4]
			lstr_parametros.entero[15] = istr_estilo_nuevo.entero[5]
			lstr_parametros.entero[16] = istr_estilo_nuevo.entero[6]
			
			//po cut pedido
			lstr_parametros.cadena[3] = istr_estilo_nuevo.cadena[1]
			lstr_parametros.cadena[4] = istr_estilo_nuevo.cadena[2]
			lstr_parametros.entero[17] = istr_estilo_nuevo.entero[7]
		Else
			//si es solo cambio de PO
			//If of_busca_sku_venta(istr_estilo_nuevo.entero[1], &
			If of_busca_sku_venta(istr_estilo_nuevo.entero[7], &
				istr_estilo_nuevo.cadena[1], istr_estilo_nuevo.cadena[2], &
				ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_fabrica_ref'),&
				ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_linea'),&
				ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_referencia'),&
				ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_talla'),&
				ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_calidad'),&
				ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_color')) < 0 Then
				rollback;
				Return -1
			End if
		
			//sku destino es la misma de la canasta original
			lstr_parametros.entero[11] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_fabrica_ref')
			lstr_parametros.entero[12] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_linea')
			lstr_parametros.entero[13] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_referencia')
			lstr_parametros.entero[14] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_talla')
			lstr_parametros.entero[15] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_calidad')
			lstr_parametros.entero[16] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_color')
			//po cut pedido
			lstr_parametros.cadena[3] = istr_estilo_nuevo.cadena[1]
			lstr_parametros.cadena[4] = istr_estilo_nuevo.cadena[2]
			//lstr_parametros.entero[17] = istr_estilo_nuevo.entero[1]
			lstr_parametros.entero[17] = istr_estilo_nuevo.entero[7]
			
			//sku destino para la busqueda de lote
			lstr_parametros_lote.entero[1] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_fabrica_ref')
			lstr_parametros_lote.entero[2] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_linea')
			lstr_parametros_lote.entero[3] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_referencia')
			lstr_parametros_lote.entero[4] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_talla')
			lstr_parametros_lote.entero[5] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_calidad')
			lstr_parametros_lote.entero[6] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_color')
			//po cut pedidopara la busqueda de lote
			lstr_parametros_lote.cadena[1] = istr_estilo_nuevo.cadena[1]
			lstr_parametros_lote.cadena[2] = istr_estilo_nuevo.cadena[2]
			//lstr_parametros_lote.entero[7] = istr_estilo_nuevo.entero[1]
			lstr_parametros_lote.entero[7] = istr_estilo_nuevo.entero[7]
			
		End if
	
		//busca si ya hay un lote para el sku pro pedido po cut en el ds de los lotes
		ll_lote_new = invo_lotes_canasta.of_buscar_lote(lstr_parametros_lote)
	
		If ll_lote_new < 0 Then
			lstr_parametros.cadena[5]= is_color_exp
			ll_lote_new = invo_lotes_canasta.of_verificar_lote(lstr_parametros)
			If ll_lote_new < 0 Then
				RollBack;
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error verificando el lote')
				Return -6
			End If
		End if

		
		//Verifica si el nuevo lote ya ha sido insertado en el detalle de la canasta
		ll_row = ids_dtcanasta_destino.Find("lote = " + String(ll_lote_new), &
									1,ids_dtcanasta_destino.RowCount() + 1)
		//	Si no ha insertado un registro con el lote ll_lote_new
		//	Debe insertar el registro en el detalle de la canasta nueva
		If ll_row = 0 Then
			ids_dtcanasta_origen.RowsCopy(ll_contador, ll_contador, Primary!, ids_dtcanasta_destino, &
													ids_dtcanasta_destino.RowCount() + 1, Primary!)
			
			//	Captura la posicion del registro nuevo
			ll_reg_destino = ids_dtcanasta_destino.RowCount()
			
			//en el cambio de ref, se asigna la ref nueva
			If ii_cambio = 2 Then
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_fabrica_ref',istr_estilo_nuevo.entero[1])
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_linea',istr_estilo_nuevo.entero[2])
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_referencia',istr_estilo_nuevo.entero[3])
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_talla',istr_estilo_nuevo.entero[4])
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_calidad',istr_estilo_nuevo.entero[5])
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_color',istr_estilo_nuevo.entero[6])
				
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'pedido',istr_estilo_nuevo.entero[7])
			
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'lote_prenda',istr_estilo_nuevo.cadena[8])
			
			Else

				//ids_dtcanasta_destino.SetItem(ll_reg_destino,'pedido',istr_estilo_nuevo.entero[1])
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'pedido',istr_estilo_nuevo.entero[7])
			
			End if
			
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'upccode',is_upc)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_fabrica_exp', ii_fabrica_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_linea_exp', ii_linea_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_ref_exp', is_ref_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_talla_exp', is_talla_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_color_exp', is_color_exp)
         	
			//como no se crea caja nueva, no se modifica cs_canasta en el detalle
			If ii_sw_crea_caja = 1 Then
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'cs_canasta',is_recipiente_nuevo)
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'pallet_id',is_recipiente_nuevo)
			End if
			
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'po',istr_estilo_nuevo.cadena[1])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'nu_cut',istr_estilo_nuevo.cadena[2])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'lote',ll_lote_new)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'fe_creacion',idt_fecha)												  
         ids_dtcanasta_destino.SetItem(ll_reg_destino,'fe_actualizacion',idt_fecha)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'usuario',gstr_info_usuario.codigo_usuario)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'instancia',gstr_info_usuario.instancia)												  
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_grupo_cte',istr_estilo_nuevo.cadena[3])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'ca_inicial', &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'ca_actual', &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'pares', &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'paquetes', &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
												  
		ElseIf ll_row > 0 Then
			ids_dtcanasta_destino.SetItem(ll_row,'ca_inicial', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'ca_inicial') + &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_row,'ca_actual', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'ca_actual') + &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual')) 
			ids_dtcanasta_destino.SetItem(ll_row,'pares', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'pares') + &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_row,'paquetes', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'paquetes') + &
												  ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual'))
			ll_reg_destino = ll_row

			
		Else
			RollBack;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Se ha producido un error al tratar de buscar el lote ' + String(ll_lote_new) + & 
						  ' en el detalle nuevos de la canasta.',StopSign!)
         Return -7						
		End If
		
		//se toma la cantidad actual para el registro de cambio de ref
		ll_cantidad = ids_dtcanasta_origen.GetItemNumber(ll_contador,'ca_actual')
		//se tome en cero la cantidad en la caja original
		ids_dtcanasta_origen.SetItem(ll_contador,'ca_actual',0)		
		
		//datos utilizados para insertar en m_cambios_referencia
		lstr_parametros_cambios_ref.entero[1] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'lote')
		lstr_parametros_cambios_ref.entero[2] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act')
		lstr_parametros_cambios_ref.entero[3] = ids_hcanasta_origen.GetItemNumber(1,'co_planta_act')
		lstr_parametros_cambios_ref.entero[4] = ids_hcanasta_origen.GetItemNumber(1,'co_centro_act')
		lstr_parametros_cambios_ref.entero[5] = ids_hcanasta_origen.GetItemNumber(1,'co_subcentro_act')
		lstr_parametros_cambios_ref.entero[6] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act')
		lstr_parametros_cambios_ref.entero[7] = ids_hcanasta_origen.GetItemNumber(1,'co_planta_act')
		lstr_parametros_cambios_ref.entero[8] = ids_hcanasta_origen.GetItemNumber(1,'co_centro_act')
		lstr_parametros_cambios_ref.entero[9] = ids_hcanasta_origen.GetItemNumber(1,'co_subcentro_act')
		lstr_parametros_cambios_ref.cadena[1] = ids_hcanasta_origen.GetItemString(1,'co_tipo_lectura')
		lstr_parametros_cambios_ref.entero[10] = ids_hcanasta_origen.GetItemNumber(1,'co_tipoprod')
		lstr_parametros_cambios_ref.cadena[2] = ids_dtcanasta_origen.GetItemString(ll_contador,'po')
		lstr_parametros_cambios_ref.cadena[3] = ids_dtcanasta_origen.GetItemString(ll_contador,'nu_cut')
		lstr_parametros_cambios_ref.entero[11] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_fabrica_ref')
		lstr_parametros_cambios_ref.entero[12] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_linea')
		lstr_parametros_cambios_ref.entero[13] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_referencia')
		lstr_parametros_cambios_ref.entero[14] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_talla')
		lstr_parametros_cambios_ref.entero[15] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_calidad')
		lstr_parametros_cambios_ref.entero[16] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'co_color')
		lstr_parametros_cambios_ref.entero[17] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_pro') 
		lstr_parametros_cambios_ref.decimal[1] = ll_cantidad
		lstr_parametros_cambios_ref.entero[18] = ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis')
		lstr_parametros_cambios_ref.entero[19] = ids_hcanasta_origen.GetItemNumber(1,'co_modulo')
		lstr_parametros_cambios_ref.cadena[4] = ids_dtcanasta_destino.GetItemString(ll_reg_destino,'po')
		lstr_parametros_cambios_ref.cadena[5] = ids_dtcanasta_destino.GetItemString(ll_reg_destino,'nu_cut')
		lstr_parametros_cambios_ref.entero[20] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_fabrica_ref')
		lstr_parametros_cambios_ref.entero[21] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_linea')
		lstr_parametros_cambios_ref.entero[22] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_referencia')
		lstr_parametros_cambios_ref.entero[23] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_talla')
		lstr_parametros_cambios_ref.entero[24] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_calidad')
		lstr_parametros_cambios_ref.entero[25] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_color')
		lstr_parametros_cambios_ref.entero[26] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_pro')
		lstr_parametros_cambios_ref.entero[27] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'pedido')
		lstr_parametros_cambios_ref.entero[28] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'pedido')
		
		lstr_parametros_cambios_ref.decimal[2] = ll_cantidad
		
		If of_registra_cambio_ref_po(lstr_parametros_cambios_ref) < 0 Then
			RollBack;
			Return -1
		End If
		
		//Prepara los datos para hacer el llamado a la funci$$HEX1$$f300$$ENDHEX$$n wf_cambios
		lstr_parametros_cambios.cadena[1] = ids_dtcanasta_origen.GetItemString(ll_contador,'co_grupo_cte')
		lstr_parametros_cambios.entero[1] = ids_dtcanasta_origen.GetItemNumber(ll_contador,'lote')
		lstr_parametros_cambios.entero[2] = ll_cantidad
		//concepto, tipo,parte
		lstr_parametros_cambios.entero[3] = ii_tipo_concepto
		lstr_parametros_cambios.entero[4] = 2
		lstr_parametros_cambios.entero[5] = 0
		
		If of_registra_dt_cambios_referen(lstr_parametros_cambios) < 0 Then
			RollBack;
			Return -1
		End If


Next


//como no se crea caja nueva, se borran los registros con cantidad en cero
If ii_sw_crea_caja <> 1 Then
	
	//Se eliminan todos los registros que tienen cantidad actual en cero (0)
	ids_dtcanasta_origen.SetFilter("ca_actual = 0")
	ids_dtcanasta_origen.Filter()
	ids_dtcanasta_origen.RowsMove(1,ids_dtcanasta_origen.RowCount(),Primary!, &
											ids_dtcanasta_origen,1,Delete!)
	ids_dtcanasta_origen.SetFilter("")										
	ids_dtcanasta_origen.Filter()

End if

Return 1
end function

public function long of_registra_dt_cambios_referen (s_base_parametros astr_parametros);//Funci$$HEX1$$f300$$ENDHEX$$n usada para realizar el movimiento en la tabla dt_cambios_referen

Long ll_reg

//Crea el datastore con el que se actualiza dt_cambios_referencia
If Not IsValid(ids_cambios) Then
	ids_cambios = Create uo_dsbase
	ids_cambios.DataObject = 'd_gr_cambios_referencias_com'
	ids_cambios.SetTransObject(SQLCA)
End If


//Se registra el cambio de unidades a segundas o cambio de
//estilo en dt_cambios_referencias
ll_reg = ids_cambios.InsertRow(0)  
If ll_reg = -1 Then 
	MessageBox('Error de Base de Datos',  &
				  'No se puede insertar el registro. ' + &
				  'Avise al administrador del sistema!',StopSign!)
	Return -1
End If	
							
ids_cambios.SetItem(ll_reg,'co_grupo_cte',astr_parametros.cadena[1])
ids_cambios.SetItem(ll_reg,'lote',astr_parametros.entero[1])
ids_cambios.SetItem(ll_reg,'cantidad',astr_parametros.entero[2])
ids_cambios.SetItem(ll_reg,'co_concepto',astr_parametros.entero[3])
ids_cambios.SetItem(ll_reg,'co_tipo',astr_parametros.entero[4])
ids_cambios.SetItem(ll_reg,'co_parte',astr_parametros.entero[5])

ids_cambios.SetItem(ll_reg,'co_fabrica',ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act'))
ids_cambios.SetItem(ll_reg,'co_planta',ids_hcanasta_origen.GetItemNumber(1,'co_planta_act'))
ids_cambios.SetItem(ll_reg,'co_centro',ids_hcanasta_origen.GetItemNumber(1,'co_centro_act'))
ids_cambios.SetItem(ll_reg,'co_subcentro',ids_hcanasta_origen.GetItemNumber(1,'co_subcentro_act'))
ids_cambios.SetItem(ll_reg,'co_modulo',ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis'))
ids_cambios.SetItem(ll_reg,'co_modulo_fis',ids_hcanasta_origen.GetItemNumber(1,'co_modulo'))
ids_cambios.SetItem(ll_reg,'co_cliente',il_cliente)
ids_cambios.SetItem(ll_reg,'co_sucursal',il_sucursal)
ids_cambios.SetItem(ll_reg,'ano',il_ano)
ids_cambios.SetItem(ll_reg,'mes',il_mes)
ids_cambios.SetItem(ll_reg,'semana',il_semana)	
ids_cambios.SetItem(ll_reg,'fecha',idt_fecha)
ids_cambios.SetItem(ll_reg,'fe_creacion',idt_fecha)
ids_cambios.SetItem(ll_reg,'usuario',gstr_info_usuario.codigo_usuario)
ids_cambios.SetItem(ll_reg,'instancia',gstr_info_usuario.instancia)


Return 1
end function

public function long of_realiza_mov_parcial_canasta (uo_dsbase ads_recipiente_destino);Long ll_contador, ll_lote_new, ll_row, ll_reg_destino, ll_cantidad, &
		ll_fabrica_exp, ll_linea_exp, ll_n, ll_m, ll_lote, ll_ca_diferencia
String ls_upc, ls_ref_exp, ls_talla_exp, ls_color_exp, ls_caja
s_base_parametros lstr_parametros_cambios, lstr_parametros, lstr_parametros_cambios_ref, &
						lstr_parametros_lote


ids_dtsku_cambio_orig.Reset()
ids_dtsku_cambio.Reset()
ids_dtsku_sincambio.Reset()

//	Se eliminan los registros que no tienen cantidad
ads_recipiente_destino.SetFilter("ca_actual > 0")
ads_recipiente_destino.Filter()

//se ordenan los dw
ads_recipiente_destino.SetSort("cs_canasta, lote, cs_orden_corte")
ads_recipiente_destino.Sort()
ids_dtcanasta_origen.SetSort("cs_canasta, lote, cs_orden_corte")
ids_dtcanasta_origen.Sort()

//se recorre los detalles de la canasta origen para separar los registro que cambian de los que no
For ll_contador = 1 to ids_dtcanasta_origen.RowCount() 
	If ads_recipiente_destino.GetItemNumber(ll_contador,'c_talla') = 1 or &
		 ads_recipiente_destino.GetItemNumber(ll_contador,'c_color') = 1 or &
		 ads_recipiente_destino.GetItemNumber(ll_contador,'c_referencia') = 1 	Then
		 
		 //copia el registro original que se tenia
		 ids_dtcanasta_origen.RowsCopy(ll_contador, ll_contador, Primary!, ids_dtsku_cambio_orig, &
													ids_dtsku_cambio_orig.RowCount() + 1, Primary!)
		
		//copia en el dw que contiene el cambio
		ids_dtcanasta_origen.RowsCopy(ll_contador, ll_contador, Primary!, ids_dtsku_cambio, &
													ids_dtsku_cambio.RowCount() + 1, Primary!)
		 
		//si cambia de talla 
		If ads_recipiente_destino.GetItemNumber(ll_contador,'c_talla') = 1 Then
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'co_talla', &
						ads_recipiente_destino.GetItemNumber(ll_contador,'co_talla'))
		End if
		
		//si cambia de color
		If ads_recipiente_destino.GetItemNumber(ll_contador,'c_color') = 1 Then
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'co_color', & 
						ads_recipiente_destino.GetItemNumber(ll_contador,'co_color'))
		End if
	
		//si cambia de referencia
		If ads_recipiente_destino.GetItemNumber(ll_contador,'c_referencia') = 1 Then
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'co_referencia', & 
						ads_recipiente_destino.GetItemNumber(ll_contador,'co_referencia'))
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'co_linea', & 
						ads_recipiente_destino.GetItemNumber(ll_contador,'co_linea'))
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'co_fabrica_ref', & 
						ads_recipiente_destino.GetItemNumber(ll_contador,'co_fabrica_ref'))
		End if
		
					
		ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'nu_cut', & 
					ads_recipiente_destino.GetItemString(ll_contador,'nu_cut'))
		ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'po', & 
					ads_recipiente_destino.GetItemString(ll_contador,'po'))
		ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'pedido', & 
					ads_recipiente_destino.GetItemNumber(ll_contador,'pedido'))
		
		
		//como no se crea caja nueva, no se modifica cs_canasta en el detalle
		If ii_sw_crea_caja = 1 Then
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'cs_canasta',is_recipiente_nuevo)
			ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'pallet_id',is_recipiente_nuevo)
		End if
		
		//mira si el cambio se hace solo a una cantidad de la referencia
		If ads_recipiente_destino.GetItemNumber(ll_contador,'c_cantidad') = 1 Then
			//si la cantidad es menor o igual a cero se modifican todas las unidades
			If ads_recipiente_destino.GetItemNumber(ll_contador,'ca_nueva') > 0 Then
				ll_ca_diferencia = ads_recipiente_destino.GetItemNumber(ll_contador,'ca_actual') - & 
							ads_recipiente_destino.GetItemNumber(ll_contador,'ca_nueva')
				
				//si la diferencia entre las dos cantidades es menor o igual a cero se cambian todas las unidades
				If ll_ca_diferencia > 0 Then
					//asigna la cantidad nueva
					ids_dtsku_cambio.SetItem(ids_dtsku_cambio.RowCount(),'ca_actual', & 
								ads_recipiente_destino.GetItemNumber(ll_contador,'ca_nueva'))
					
					//asigna la cantidad nueva
					ids_dtsku_cambio_orig.SetItem(ids_dtsku_cambio_orig.RowCount(),'ca_actual', & 
								ads_recipiente_destino.GetItemNumber(ll_contador,'ca_nueva'))

					
					//registra las unidades que no cambian
					ids_dtcanasta_origen.RowsCopy(ll_contador, ll_contador, Primary!, ids_dtsku_sincambio, &
													ids_dtsku_sincambio.RowCount() + 1, Primary!)
					//asigna la canasta nueva y las unidades de diferencia	
					//como no se crea caja nueva, no se modifica cs_canasta en el detalle
					If ii_sw_crea_caja = 1 Then
						ids_dtsku_sincambio.SetItem(ids_dtsku_sincambio.RowCount(),'cs_canasta',is_recipiente_nuevo)
						ids_dtsku_sincambio.SetItem(ids_dtsku_sincambio.RowCount(),'pallet_id',is_recipiente_nuevo)
					End if
					ids_dtsku_sincambio.SetItem(ids_dtsku_sincambio.RowCount(),'ca_actual',ll_ca_diferencia)

				End if
			End if
		End if
		
	Else
		ids_dtcanasta_origen.RowsCopy(ll_contador, ll_contador, Primary!, ids_dtsku_sincambio, &
													ids_dtsku_sincambio.RowCount() + 1, Primary!)
					
		//como no se crea caja nueva, no se modifica cs_canasta en el detalle
		If ii_sw_crea_caja = 1 Then
			ids_dtsku_sincambio.SetItem(ids_dtsku_sincambio.RowCount(),'cs_canasta',is_recipiente_nuevo)
			ids_dtsku_sincambio.SetItem(ids_dtsku_sincambio.RowCount(),'pallet_id',is_recipiente_nuevo)
		End if
			
	End if
	
	ids_dtcanasta_origen.SetItem(ll_contador,'ca_actual',0)		
	
Next

If ids_dtsku_sincambio.RowCount() > 0 then
	//se copia en la canasta destino los registro que no cambian
	ids_dtsku_sincambio.RowsCopy(1, ids_dtsku_sincambio.RowCount() + 1, Primary!, ids_dtcanasta_destino, &
													ids_dtcanasta_destino.RowCount() + 1, Primary!)
End if

For ll_contador = 1 To ids_dtsku_cambio_orig.RowCount()
	
	
		//Se capturan los datos de dt_canasta_corte del bongo digitado en 
		//sle_bongo para realizar la verificaci$$HEX1$$f300$$ENDHEX$$n en m_lotes_conf
		lstr_parametros.entero[1] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_fabrica_ref')
		lstr_parametros.entero[2] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_linea')
		lstr_parametros.entero[3] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_referencia')
		lstr_parametros.entero[4] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_talla')
		lstr_parametros.entero[5] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_calidad')
		lstr_parametros.entero[6] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_color')
		lstr_parametros.cadena[1] = ids_dtsku_cambio_orig.GetItemString(ll_contador,'po')
		lstr_parametros.cadena[2] = ids_dtsku_cambio_orig.GetItemString(ll_contador,'nu_cut')
		lstr_parametros.entero[7] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'cs_orden_corte')
		lstr_parametros.entero[8] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'lote')
		lstr_parametros.entero[9] = il_fabrica_loteo
		lstr_parametros.entero[10] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'pedido')
		
		//sku destino para la busqueda de lote
		lstr_parametros_lote.entero[1] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_fabrica_ref')
		lstr_parametros_lote.entero[2] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_linea')
		lstr_parametros_lote.entero[3] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_referencia')
		lstr_parametros_lote.entero[4] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_talla')
		lstr_parametros_lote.entero[5] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_calidad')
		lstr_parametros_lote.entero[6] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_color')
		//po cut pedidopara la busqueda de lote
		lstr_parametros_lote.cadena[1] = ids_dtsku_cambio.GetItemString(ll_contador,'po')
		lstr_parametros_lote.cadena[2] = ids_dtsku_cambio.GetItemString(ll_contador,'nu_cut')
		lstr_parametros_lote.entero[7] = ids_dtsku_cambio.GetItemNumber(ll_contador,'pedido')
		
		
		
		//sku destino
		lstr_parametros.entero[11] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_fabrica_ref')
		lstr_parametros.entero[12] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_linea')
		lstr_parametros.entero[13] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_referencia')
		lstr_parametros.entero[14] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_talla')
		lstr_parametros.entero[15] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_calidad')
		lstr_parametros.entero[16] = ids_dtsku_cambio.GetItemNumber(ll_contador,'co_color')
		
		//po cut pedido
		lstr_parametros.cadena[3] = ids_dtsku_cambio.GetItemString(ll_contador,'po')
		lstr_parametros.cadena[4] = ids_dtsku_cambio.GetItemString(ll_contador,'nu_cut')
		lstr_parametros.entero[17] = ids_dtsku_cambio.GetItemNumber(ll_contador,'pedido')
	
		If of_busca_sku_venta(ids_dtsku_cambio.GetItemNumber(ll_contador,'pedido'), &
			ids_dtsku_cambio.GetItemString(ll_contador,'po'), &
			ids_dtsku_cambio.GetItemString(ll_contador,'nu_cut'), &
			ids_dtsku_cambio.GetItemNumber(ll_contador,'co_fabrica_ref'),&
			ids_dtsku_cambio.GetItemNumber(ll_contador,'co_linea'),&
			ids_dtsku_cambio.GetItemNumber(ll_contador,'co_referencia'),&
			ids_dtsku_cambio.GetItemNumber(ll_contador,'co_talla'),&
			ids_dtsku_cambio.GetItemNumber(ll_contador,'co_calidad'),&
			ids_dtsku_cambio.GetItemNumber(ll_contador,'co_color')) < 0 Then
			rollback;
			Return -1
		Else
									
			ids_dtsku_cambio.SetItem(ll_contador,'upccode',is_upc)
			ids_dtsku_cambio.SetItem(ll_contador,'co_fabrica_exp', ii_fabrica_exp)
			ids_dtsku_cambio.SetItem(ll_contador,'co_linea_exp', ii_linea_exp)
			ids_dtsku_cambio.SetItem(ll_contador,'co_ref_exp', is_ref_exp)
			ids_dtsku_cambio.SetItem(ll_contador,'co_talla_exp', is_talla_exp)
			ids_dtsku_cambio.SetItem(ll_contador,'co_color_exp', is_color_exp)
		End if
	
		//busca si ya hay un lote para el sku pro pedido po cut en el ds de los lotes
		ll_lote_new = invo_lotes_canasta.of_buscar_lote(lstr_parametros_lote)
	
		If ll_lote_new < 0 Then
			lstr_parametros.cadena[5]= is_color_exp
			ll_lote_new = invo_lotes_canasta.of_verificar_lote(lstr_parametros)
			If ll_lote_new < 0 Then
				RollBack;
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error verificando el lote')
				Return -6
			End If
		End if

		
		//Verifica si el nuevo lote ya ha sido insertado en el detalle de la canasta
		ll_row = ids_dtcanasta_destino.Find("lote = " + String(ll_lote_new), &
									1,ids_dtcanasta_destino.RowCount() + 1)
		//	Si no ha insertado un registro con el lote ll_lote_new
		//	Debe insertar el registro en el detalle de la canasta nueva
		If ll_row = 0 Then
			ids_dtsku_cambio_orig.RowsCopy(ll_contador, ll_contador, Primary!, ids_dtcanasta_destino, &
													ids_dtcanasta_destino.RowCount() + 1, Primary!)
			
			//	Captura la posicion del registro nuevo
			ll_reg_destino = ids_dtcanasta_destino.RowCount()
			

			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_fabrica_ref',lstr_parametros_lote.entero[1])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_linea',lstr_parametros_lote.entero[2])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_referencia',lstr_parametros_lote.entero[3])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_talla',lstr_parametros_lote.entero[4])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_calidad',lstr_parametros_lote.entero[5])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_color',lstr_parametros_lote.entero[6])
			
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'pedido',lstr_parametros_lote.entero[7])
			
			
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'upccode',is_upc)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_fabrica_exp', ii_fabrica_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_linea_exp', ii_linea_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_ref_exp', is_ref_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_talla_exp', is_talla_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_color_exp', is_color_exp)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'co_grupo_cte',is_gpa)
			
			         	
			//como no se crea caja nueva, no se modifica cs_canasta en el detalle
			If ii_sw_crea_caja = 1 Then
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'cs_canasta',is_recipiente_nuevo)
				ids_dtcanasta_destino.SetItem(ll_reg_destino,'pallet_id',is_recipiente_nuevo)
			End if
			
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'po',lstr_parametros_lote.cadena[1])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'nu_cut',lstr_parametros_lote.cadena[2])
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'lote',ll_lote_new)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'fe_creacion',idt_fecha)												  
         ids_dtcanasta_destino.SetItem(ll_reg_destino,'fe_actualizacion',idt_fecha)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'usuario',gstr_info_usuario.codigo_usuario)
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'instancia',gstr_info_usuario.instancia)												  

			ids_dtcanasta_destino.SetItem(ll_reg_destino,'ca_inicial', &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'ca_actual', &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'pares', &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_reg_destino,'paquetes', &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
												  
		ElseIf ll_row > 0 Then
			ids_dtcanasta_destino.SetItem(ll_row,'ca_inicial', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'ca_inicial') + &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_row,'ca_actual', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'ca_actual') + &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual')) 
			ids_dtcanasta_destino.SetItem(ll_row,'pares', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'pares') + &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
			ids_dtcanasta_destino.SetItem(ll_row,'paquetes', &
												  ids_dtcanasta_destino.GetItemNumber(ll_row,'paquetes') + &
												  ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual'))
			ll_reg_destino = ll_row

			
		Else
			RollBack;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Se ha producido un error al tratar de buscar el lote ' + String(ll_lote_new) + & 
						  ' en el detalle nuevos de la canasta.',StopSign!)
         Return -7						
		End If
		
		ids_dtsku_cambio.SetItem(ll_contador,'lote',ll_lote_new)
		
		
		ll_cantidad = ids_dtsku_cambio.GetItemNumber(ll_contador,'ca_actual')
		
		
		//datos utilizados para insertar en m_cambios_referencia
		lstr_parametros_cambios_ref.entero[1] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'lote')
		lstr_parametros_cambios_ref.entero[2] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act')
		lstr_parametros_cambios_ref.entero[3] = ids_hcanasta_origen.GetItemNumber(1,'co_planta_act')
		lstr_parametros_cambios_ref.entero[4] = ids_hcanasta_origen.GetItemNumber(1,'co_centro_act')
		lstr_parametros_cambios_ref.entero[5] = ids_hcanasta_origen.GetItemNumber(1,'co_subcentro_act')
		lstr_parametros_cambios_ref.entero[6] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_act')
		lstr_parametros_cambios_ref.entero[7] = ids_hcanasta_origen.GetItemNumber(1,'co_planta_act')
		lstr_parametros_cambios_ref.entero[8] = ids_hcanasta_origen.GetItemNumber(1,'co_centro_act')
		lstr_parametros_cambios_ref.entero[9] = ids_hcanasta_origen.GetItemNumber(1,'co_subcentro_act')
		lstr_parametros_cambios_ref.cadena[1] = ids_hcanasta_origen.GetItemString(1,'co_tipo_lectura')
		lstr_parametros_cambios_ref.entero[10] = ids_hcanasta_origen.GetItemNumber(1,'co_tipoprod')
		lstr_parametros_cambios_ref.cadena[2] = ids_dtsku_cambio_orig.GetItemString(ll_contador,'po')
		lstr_parametros_cambios_ref.cadena[3] = ids_dtsku_cambio_orig.GetItemString(ll_contador,'nu_cut')
		lstr_parametros_cambios_ref.entero[11] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_fabrica_ref')
		lstr_parametros_cambios_ref.entero[12] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_linea')
		lstr_parametros_cambios_ref.entero[13] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_referencia')
		lstr_parametros_cambios_ref.entero[14] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_talla')
		lstr_parametros_cambios_ref.entero[15] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_calidad')
		lstr_parametros_cambios_ref.entero[16] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'co_color')
		lstr_parametros_cambios_ref.entero[17] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_pro') 
		lstr_parametros_cambios_ref.decimal[1] = ll_cantidad
		lstr_parametros_cambios_ref.entero[18] = ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis')
		lstr_parametros_cambios_ref.entero[19] = ids_hcanasta_origen.GetItemNumber(1,'co_modulo')
		lstr_parametros_cambios_ref.cadena[4] = ids_dtcanasta_destino.GetItemString(ll_reg_destino,'po')
		lstr_parametros_cambios_ref.cadena[5] = ids_dtcanasta_destino.GetItemString(ll_reg_destino,'nu_cut')
		lstr_parametros_cambios_ref.entero[20] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_fabrica_ref')
		lstr_parametros_cambios_ref.entero[21] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_linea')
		lstr_parametros_cambios_ref.entero[22] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_referencia')
		lstr_parametros_cambios_ref.entero[23] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_talla')
		lstr_parametros_cambios_ref.entero[24] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_calidad')
		lstr_parametros_cambios_ref.entero[25] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'co_color')
		lstr_parametros_cambios_ref.entero[26] = ids_hcanasta_origen.GetItemNumber(1,'co_fabrica_pro')
		lstr_parametros_cambios_ref.entero[27] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'pedido')
		lstr_parametros_cambios_ref.entero[28] = ids_dtcanasta_destino.GetItemNumber(ll_reg_destino,'pedido')
		
		lstr_parametros_cambios_ref.decimal[2] = ll_cantidad
		
		If of_registra_cambio_ref_po(lstr_parametros_cambios_ref) < 0 Then
			RollBack;
			Return -1
		End If
		
		//Prepara los datos para hacer el llamado a la funci$$HEX1$$f300$$ENDHEX$$n wf_cambios
		lstr_parametros_cambios.cadena[1] = ids_dtsku_cambio_orig.GetItemString(ll_contador,'co_grupo_cte')
		lstr_parametros_cambios.entero[1] = ids_dtsku_cambio_orig.GetItemNumber(ll_contador,'lote')
		lstr_parametros_cambios.entero[2] = ll_cantidad
		//concepto, tipo,parte
		lstr_parametros_cambios.entero[3] = ii_tipo_concepto
		lstr_parametros_cambios.entero[4] = 2
		lstr_parametros_cambios.entero[5] = 0
		
		If of_registra_dt_cambios_referen(lstr_parametros_cambios) < 0 Then
			RollBack;
			Return -1
		End If


Next

//ciclo utilizado para acumular los lotes que este duplicados
ll_contador = 1
ll_n = 1
Do While ll_contador > 0 
	ll_lote = ids_dtcanasta_destino.GetItemNumber(ll_n,'lote')
	ls_caja = trim(ids_dtcanasta_destino.GetItemString(ll_n,'cs_canasta'))
	ll_m = ll_n + 1
	//busca el lote en otra posicion en la canasta
	ll_contador = ids_dtcanasta_destino.Find("lote = " + String(ll_lote) + &
						" and cs_canasta = '" + ls_caja + "'", &
							ll_m, ids_dtcanasta_destino.rowCount() + 1)
	//si no encuentra el lote
	If ll_contador = 0 Then
		//mira si es el ultimo registro de la canasta nueva
		If ( ll_m ) >= ids_dtcanasta_destino.RowCount() Then
		Else
			ll_contador = 1
			ll_n ++
		End if		
	//si lotes duplicados
	ElseIf ll_contador > 0 Then
		//acumula la cantidad
		ids_dtcanasta_destino.SetItem(ll_n,'ca_actual',ids_dtcanasta_destino.GetItemDecimal(ll_n,'ca_actual') &
								+ ids_dtcanasta_destino.GetItemDecimal(ll_contador,'ca_actual') )
		ids_dtcanasta_destino.SetItem(ll_n,'ca_inicial',ids_dtcanasta_destino.GetItemDecimal(ll_n,'ca_inicial') &
								+ ids_dtcanasta_destino.GetItemDecimal(ll_contador,'ca_inicial') )
		//descarta el lote repetido
		ids_dtcanasta_destino.RowsDiscard(ll_contador,ll_contador,Primary!)
		ll_n = 1
	Elseif ll_contador < 0 Then
		Rollback;
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la busqueda de lotes duplicados",StopSign! )
		Return -2
	End if
	
Loop


//como no se crea caja nueva, se borran los registros con cantidad en cero
If ii_sw_crea_caja <> 1 Then
	
	//Se eliminan todos los registros que tienen cantidad actual en cero (0)
	ids_dtcanasta_origen.SetFilter("ca_actual = 0")
	ids_dtcanasta_origen.Filter()
	ids_dtcanasta_origen.RowsMove(1,ids_dtcanasta_origen.RowCount(),Primary!, &
											ids_dtcanasta_origen,1,Delete!)
	ids_dtcanasta_origen.SetFilter("")										
	ids_dtcanasta_origen.Filter()

//ids_hcanasta_origen.RowsMove(1,ids_hcanasta_origen.RowCount(),Primary!, &
//                              ids_hcanasta_origen,1,Delete!)
End if

Return 1
end function

public function long of_cambio_ref_po (string as_recipiente, long ai_tipo_concepto, long ai_crea_caja);
/*
Funcion que realiza el cambio de ref PO
La variable ii_cambio es para saber si ya escogieron realizar algun cambio
0 no hay ningun cambio, 1 cambio PO, 2 cambio Ref
En esta funcion, los cambio nuevos estan en la estructura istr_estilo_nuevo en los 
siguientes campos
istr_estilo_nuevo.entero[1]=co_fabrica
istr_estilo_nuevo.entero[2]=co_linea
istr_estilo_nuevo.entero[3]=co_referencia
istr_estilo_nuevo.entero[4]=co_talla
istr_estilo_nuevo.entero[5]=co_calidad
istr_estilo_nuevo.entero[6]=co_color
istr_estilo_nuevo.entero[7]=pedido
istr_estilo_nuevo.cadena[1]=nu_orden
istr_estilo_nuevo.cadena[2]=nu_cut

istr_estilo_nuevo.entero[8]=co_fabrica_exp
istr_estilo_nuevo.entero[9]=co_linea_exp

istr_estilo_nuevo.cadena[1]=nu_orden
istr_estilo_nuevo.cadena[2]=nu_cut
istr_estilo_nuevo.cadena[3]=gpa
istr_estilo_nuevo.cadena[4]=upc_barcode
istr_estilo_nuevo.cadena[5]=co_ref_exp
istr_estilo_nuevo.cadena[6]=co_talla_exp
istr_estilo_nuevo.cadena[7]=co_color_exp
istr_estilo_nuevo.cadena[8]=lote_prenda
si ai_crea_caja es 1 crea caja nueva, de lo contrario deja el mismo consecutivo
*/
Long ll_n
n_cst_mover_kardex lnvo_kardex

//mira si escogieron algun cambio
If ii_cambio = 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ha escogido ningun cambio.')
	Return -1
End if

//se valida de que se haya escogido el programa que esta haciendo el cambio de PO
//esto para el registro en modulon
If trim(is_programa) = '' or Isnull(is_programa) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ha escogido el programa para el registro en modulon.')
	Return -1
End if


//toma el concepto por el cual se hace el cambio de PO y si se va a crea caja nueva
ii_tipo_concepto = ai_tipo_concepto
ii_sw_crea_caja = ai_crea_caja

//se preparan los datos para el cambio de ref po del recipiente enviado
If of_preparar_datos_cambio_po(as_recipiente) < 0 Then Return -1

//Si se esta haciendo un cambio de PO solamente, se valida que exista el 
//sku prod para la PO nueva
If ii_cambio = 1 Then
	For ll_n =1 To ids_dtcanasta_origen.RowCount()
//		If of_valida_sku_en_pedido(istr_estilo_nuevo.entero[1], &
		If of_valida_sku_en_pedido(istr_estilo_nuevo.entero[7], &
				istr_estilo_nuevo.cadena[1], istr_estilo_nuevo.cadena[2], &
				ids_dtcanasta_origen.GetItemNumber(ll_n,'co_fabrica_ref'),&
				ids_dtcanasta_origen.GetItemNumber(ll_n,'co_linea'),&
				ids_dtcanasta_origen.GetItemNumber(ll_n,'co_referencia'),&
				ids_dtcanasta_origen.GetItemNumber(ll_n,'co_talla'),&
				ids_dtcanasta_origen.GetItemNumber(ll_n,'co_calidad'),&
				ids_dtcanasta_origen.GetItemNumber(ll_n,'co_color')) < 0 Then
				rollback;
				Return -1
		End if
	Next
End if

//se realiza la salida del kardex
If lnvo_kardex.of_mover_kardex(ids_hcanasta_origen, ids_dtcanasta_origen,&
				is_programa,2,1,'I','C2',ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis'), &
				0,False,'',True,is_recipiente_nuevo) < 0 Then Return -1

//se realiza el movimiento en los detalle de canasta y registro del cambio de ref po				
If of_realiza_mov_detalles_canasta() < 0 Then 
	rollback;
	Return -1
End if

//actualiza los dw
If ids_hcanasta_origen.of_Update() > 0 Then
	If ids_dtcanasta_origen.of_Update() > 0 Then
		If ids_hcanasta_destino.of_Update() > 0 Then
			If ids_dtcanasta_destino.of_Update() > 0 Then
				If invo_lotes_canasta.ids_lote.of_Update() > 0 Then
					If ids_cambios_referencia.of_Update() > 0 Then
						If ids_cambios.of_Update() <= 0 Then
							RollBack;
							Beep(1)
							MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se logro actualizar los cambios en dt_cambios_refen.")
							Return -1
						End if
						
						//si el valor es 1 se crea caja nueva 
						If ii_sw_crea_caja = 1 Then
							//se realiza la entrada del kardex
							If lnvo_kardex.of_mover_kardex(ids_hcanasta_destino, ids_dtcanasta_destino,&
										is_programa,3,1,'I','C1',ids_hcanasta_destino.GetItemNumber(1,'co_modulo_fis'), &
										0,False,'',False,'') < 0 Then Return -1
						Else
							//se realiza la entrada del kardex
							If lnvo_kardex.of_mover_kardex(ids_hcanasta_origen, ids_dtcanasta_destino,&
										is_programa,3,1,'I','C1',ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis'), &
										0,False,'',False,'') < 0 Then Return -1
						End if
						
//						If 1 = 1 Then
//						MessageBox("Atencion","Se procedera a deshacer la transaccion . " + is_recipiente_nuevo)
//						RollBack;
//						Return 0
						
						/*
						If ids_dtcanasta_origen.of_commit() > 0 Then
							MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se actualizaron los datos del cambio de PO. Recipiente Nuevo: '+ is_recipiente_nuevo)
						Else
							RollBack;
							Beep(1)
							MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Se deshicieron los cambios hechos en la ventana, debe hacerlos nuevamente.", StopSign!)
							Return -11
						End If
						*/
					Else
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los registros del cambio de Ref PO')
						Return -10
					End If
				Else
					Rollback;
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los lotes nuevos que se generaron')
					Return -9
				End If
			Else
				Rollback;
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los detalles de la canasta destino')
				Return -8
			End If
		Else
			Rollback;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar la canasta destino')
			Return -7
		End If
	Else
		Rollback;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los detalles de la canasta original')
		Return -6
	End If
Else
	Rollback;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar la canasta original')
	Return -5
End If

Return 1
end function

public function long of_cambio_ref_parcial (string as_recipiente, uo_dsbase ads_recipiente_destino, long ai_tipo_concepto, long ai_crea_caja);
/*
Funcion que realiza el cambio de ref PO
en el dw ads_recipiente_destino se tienen los cambios que se le realizan al bongo
si ai_crea_caja es 1 crea caja nueva, de lo contrario deja el mismo consecutivo
*/
Long ll_n
n_cst_mover_kardex lnvo_kardex

//mira si escogieron algun cambio
If ii_cambio = 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ha escogido ningun cambio.')
	Return -1
End if

//se valida de que se haya escogido el programa que esta haciendo el cambio de PO
//esto para el registro en modulon
If trim(is_programa) = '' or Isnull(is_programa) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ha escogido el programa para el registro en modulon.')
	Return -1
End if

//toma el concepto por el cual se hace el cambio de PO y si se va a crea caja nueva
ii_tipo_concepto = ai_tipo_concepto
ii_sw_crea_caja = ai_crea_caja

//se preparan los datos para el cambio de ref po del recipiente enviado
If of_preparar_datos_cambio_po(as_recipiente) < 0 Then Return -1


//se realiza el movimiento en los detalle de canasta y registro del cambio de ref po				
If of_realiza_mov_parcial_canasta(ads_recipiente_destino) < 0 Then 
	rollback;
	Return -1
End if

//se realiza la salida del kardex
If lnvo_kardex.of_mover_kardex(ids_hcanasta_origen, ids_dtsku_cambio_orig,&
				is_programa,2,1,'I','C2',ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis'), &
				0,False,'',True,is_recipiente_nuevo) < 0 Then Return -1

				
If ids_dtsku_sincambio.RowCount() > 0 then
	//si el valor es 1 se crea caja nueva 
	If ii_sw_crea_caja = 1 Then
		//se realiza movimiento de referencias que no cambian
		If lnvo_kardex.of_mover_kardex(ids_hcanasta_destino, ids_dtsku_sincambio,&
				is_programa,1,1,'C','N',ids_hcanasta_destino.GetItemNumber(1,'co_modulo_fis'), &
				0,True,ids_hcanasta_origen.GetItemString(1,'pallet_id'),False,'') < 0 Then Return -1
	Else
		//se realiza movimiento de referencias que no cambian
		If lnvo_kardex.of_mover_kardex(ids_hcanasta_origen, ids_dtsku_sincambio,&
				is_programa,1,1,'C','N',ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis'), &
				0,True,ids_hcanasta_origen.GetItemString(1,'pallet_id'),False,'') < 0 Then Return -1
	End if	
End if


If ids_hcanasta_origen.of_Update() > 0 Then
	If ids_dtcanasta_origen.of_Update() > 0 Then
		If ids_hcanasta_destino.of_Update() > 0 Then
			If ids_dtcanasta_destino.of_Update() > 0 Then
				If invo_lotes_canasta.ids_lote.of_Update() > 0 Then
					If ids_cambios_referencia.of_Update() > 0 Then
						If ids_cambios.of_Update() <= 0 Then
							RollBack;
							Beep(1)
							MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se logro actualizar los cambios en dt_cambios_refen.")
							Return -1
						End if
						
						//si el valor es 1 se crea caja nueva 
						If ii_sw_crea_caja = 1 Then
							//se realiza la entrada del kardex
							If lnvo_kardex.of_mover_kardex(ids_hcanasta_destino, ids_dtsku_cambio,&
										is_programa,3,1,'I','C1',ids_hcanasta_destino.GetItemNumber(1,'co_modulo_fis'), &
										0,False,'',False,'') < 0 Then Return -1
						Else
							//se realiza la entrada del kardex
							If lnvo_kardex.of_mover_kardex(ids_hcanasta_origen, ids_dtsku_cambio,&
										is_programa,3,1,'I','C1',ids_hcanasta_origen.GetItemNumber(1,'co_modulo_fis'), &
										0,False,'',False,'') < 0 Then Return -1
						End if
						
						
//						If 1 = 1 Then
//						MessageBox("Atencion","Se procedera a deshacer la transaccion . " + is_recipiente_nuevo)
//						RollBack;
//						Return 0
						/*
						If ids_dtcanasta_origen.of_commit() > 0 Then
							MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n','Se actualizaron los datos del cambio de PO. Recipiente Nuevo: '+ is_recipiente_nuevo)
						Else
							RollBack;
							Beep(1)
							MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Se deshicieron los cambios hechos en la ventana, debe hacerlos nuevamente.", StopSign!)
							Return -11
						End If
						*/
					Else
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los registros del cambio de Ref PO')
						Return -10
					End If
				Else
					Rollback;
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los lotes nuevos que se generaron')
					Return -9
				End If
			Else
				Rollback;
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los detalles de la canasta destino')
				Return -8
			End If
		Else
			Rollback;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar la canasta destino')
			Return -7
		End If
	Else
		Rollback;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar los detalles de la canasta original')
		Return -6
	End If
Else
	Rollback;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se logro actualizar la canasta original')
	Return -5
End If

Return 1
end function

public function long of_set_programa (string as_programa);//registra el programa para modulon

is_programa = as_programa

Return 1
end function

public function long of_busca_sku_venta (long an_pedido, string as_po, string as_nu_cut, long an_fabrica, long an_linea, long an_referencia, long an_talla, long an_calidad, long an_color);
/*
Funcion que busca el sku de venta y el upc para la PO y sku de produccion.
*/

Long ll_n
String ls_ventana
s_base_parametros lstr_parametros, lstr_parametros_rec
uo_dsbase lds_sku_en_pedido
Window lw_ventana

lds_sku_en_pedido = Create uo_dsbase
lds_sku_en_pedido.DataObject = 'd_gr_pedido_po_cut_sku_en_pedido_com'
lds_sku_en_pedido.SetTransObject(SQLCA)

ll_n = lds_sku_en_pedido.of_retrieve(an_pedido, as_po, as_nu_cut, an_fabrica, an_linea, &
			an_referencia, an_talla, an_calidad, an_color)
			
If ll_n < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al consultar el sku en el pedido nuevo.")
	Return -1
Elseif ll_n = 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El siguiente SKU de Produccion no se encuentra en el pedido " + string(an_pedido) &
			+ " PO " + trim(as_po) + " Cut " + trim(as_nu_cut) + "~r~nTienen que crear el SKU de Produccion en el " &
			+ " pedido nuevo.~r~nFabrica~t~Linea~tReferencia Talla~tcalidad~tcolor~r~n" &
			+ String(an_fabrica) + '~t'+ String(an_linea) + '~t'+ String(an_referencia) &
			+ '~t'+ String(an_talla) + '~t'+ String(an_calidad) + '~t' + String(an_color))
	Return -1
Elseif ll_n = 1 Then
	ii_fabrica_exp = lds_sku_en_pedido.GetItemNumber(1,'co_fabrica_exp')
	ii_linea_exp = lds_sku_en_pedido.GetItemNumber(1,'co_linea_exp')
	is_ref_exp = lds_sku_en_pedido.GetItemString(1,'co_ref_exp')
	is_talla_exp = lds_sku_en_pedido.GetItemString(1,'co_talla_exp')
	is_color_exp = lds_sku_en_pedido.GetItemString(1,'co_color_exp')
	is_upc = lds_sku_en_pedido.GetItemString(1,'upc_barcode')
	is_gpa = lds_sku_en_pedido.GetItemString(1,'gpa') 
	
//si se tiene mas de un registro para el sku de prod en el pedido
Else
	lstr_parametros.Cadena[1] = String(an_fabrica)
	lstr_parametros.Cadena[2] = String(an_linea)
	lstr_parametros.Cadena[3] = String(an_referencia)
	lstr_parametros.Cadena[4] = String(an_talla)
	lstr_parametros.Cadena[5] = String(an_color)
	lstr_parametros.ds_datos[1] = lds_sku_en_pedido
	
	ls_ventana = 'w_seleccionar_sku_vta'
	OpenWithParm(lw_ventana , lstr_parametros, ls_ventana)
	lstr_parametros_rec = Message.PowerObjectParm
	If lstr_parametros_rec.hay_parametros = False Then
		MessageBox("Advertencia ","No selecciono ninguna referencia de venta...",StopSign!)
		Return  -1
	Else
		ii_fabrica_exp = lstr_parametros_rec.entero[1]
		ii_linea_exp = lstr_parametros_rec.entero[2]
		is_ref_exp = lstr_parametros_rec.Cadena[1]
		is_talla_exp = lstr_parametros_rec.Cadena[2]
		is_color_exp = lstr_parametros_rec.Cadena[3]
		is_upc = lstr_parametros_rec.Cadena[4]
	End If
End if

If isnull(ii_fabrica_exp) or ii_fabrica_exp = 0  or  &
					isnull(ii_linea_exp) or ii_linea_exp = 0  or &
					isnull(is_ref_exp) or is_ref_exp = '' or &
					isnull(is_talla_exp) or is_talla_exp = '' or &
					isnull(is_color_exp) or is_color_exp = '' Then
	
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Los campos de referencia de venta del pedido estan en blanco.' + &
						"~r~nTiene que organizar los campos de la referencia de venta en el pedido para poder generar la caja.")
	Return -1
End if

Return 1

end function

public function long of_valida_sku_en_pedido (long an_pedido, string as_po, string as_nu_cut, long an_fabrica, long an_linea, long an_referencia, long an_talla, long an_calidad, long an_color);
/*
Funcion que valida de que el sku producion exista en el pedido, PO, cut nuevo
esto solo en la opcion de cambiar PO
*/

Long ll_n
uo_dsbase lds_sku_en_pedido

lds_sku_en_pedido = Create uo_dsbase
lds_sku_en_pedido.DataObject = 'd_gr_pedido_po_cut_sku_en_pedido_com'
lds_sku_en_pedido.SetTransObject(SQLCA)

ll_n = lds_sku_en_pedido.of_retrieve(an_pedido, as_po, as_nu_cut, an_fabrica, an_linea, &
			an_referencia, an_talla, an_calidad, an_color)
			
If ll_n < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un inconveniente al consultar el sku en el pedido nuevo.")
	Return -1
Elseif ll_n = 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El siguiente SKU de Produccion no se encuentra en el pedido " + string(an_pedido) &
			+ " PO " + trim(as_po) + " Cut " + trim(as_nu_cut) + "~r~nTienen que crear el SKU de Produccion en el " &
			+ " pedido nuevo.~r~nFabrica~t~Linea~tReferencia Talla~tcalidad~tcolor~r~n" &
			+ String(an_fabrica) + '~t'+ String(an_linea) + '~t'+ String(an_referencia) &
			+ '~t'+ String(an_talla) + '~t'+ String(an_calidad) + '~t' + String(an_color))
	Return -1
End if

Destroy lds_sku_en_pedido
Return 1

end function

on n_cst_cambios_po.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_cambios_po.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

