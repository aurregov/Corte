HA$PBExportHeader$n_cst_dt_pedidos.sru
forward
global type n_cst_dt_pedidos from nonvisualobject
end type
end forward

global type n_cst_dt_pedidos from nonvisualobject autoinstantiate
end type

type variables
Public: 
	Long il_cliente,& 
		 il_sucursal,&
		 il_division,&
		 il_co_fabrica_exp ,&
		 il_co_linea_exp,&
		 il_co_calidad, &
		 il_co_fabrica_vta /* Fabrica de vta del pedido*/ 
			
	Long	 il_co_fabrica,&
		 il_co_linea,&
		 il_co_referencia,&
		 il_co_talla,&
		 il_co_calidad_eq,&
		 il_co_color, &
		 item, &
		 il_cantidad, &
		 il_co_cliente_ref
	
	 
	String is_co_ref_exp,&
			is_co_talla_exp,&
			is_co_color_exp, &
			is_upc_barcode, &
			is_co_referencia, &
			is_po, is_nombre_po = 'nu_orden', &
			is_nu_cut, &
			is_tipo_pedido, is_tipo_cliente, &
			is_de_referencia, &
			is_co_prepack // Campo motivo en la tabla de equivalencias
			
	Long ii_sw_carga_ean
	// Bandera que carga de h_preref, indentifica si la referencia es de sourcing
	Boolean ib_sourcing = False, ib_validar_sourcing = False
	// Bandera para que no obtenga la equivalencia, si no que solo la valida
	Boolean ib_valida_equivalencia = False
	// Bandera para que valide el ean
	Boolean ib_valida_ean = True, ib_valida_ean_generico = False
	// Bandera para mostrar mensajes de error: -en validaciones de ean de venta
	Boolean ib_msn_validacion = True
	// Bandera para mirar en ambas equivalencias
	Boolean ib_doble_equivalencia = False
	// Bandera para obtener la equivalencia de la referencia de produccion
	Boolean ib_eq_produccion = True
	
	
	uo_dsbase ids_dt_pedido, ids_m_colores_exp, ids_referencia, ids_equivalencias, ids_dt_ref_x_col_pv
	
	Date id_fe_inicial, id_fe_final
	
	Long ii_uni_empaque, ii_cubicaje	
	String is_co_muestrario, is_de_talla
Private:
	String is_co_prepack_temporada
	Decimal idc_ca_temporada
end variables

forward prototypes
public function long of_mensaje (string as_titulo, string as_msn, s_base_parametros asp_parametros, string as_fin)
public function long of_obtener_ref_cliente ()
public function long of_set_detalle (uo_dsbase ads_dt_pedido)
public function long of_limpiar_sku ()
public function long of_reiniciar_propiedades ()
public function long of_validar_sku_nal ()
public function long of_validar_ref_nal ()
public function long of_validar_ean ()
public function long of_validar_cc_cliente ()
public function long of_validar_po (string as_po)
public function long of_validar_ean_vta ()
public function long of_validar_sku_nal_vta ()
public function long of_obtener_equivalencia ()
public function long of_llenar_sku3 (long al_row, any aa_ds_detalle)
public function long of_llenar_sku (long al_row, uo_dsbase ads_detalle)
public function long of_llenar_sku (long al_row, uo_dtwndow adw_detalle)
public function long of_validar_temporada (datawindow adw_detalle)
public function long of_crear_temporada (long al_row, datawindow adw_detalle)
public function long of_crear_temporada (long al_row, datastore ads_detalle)
public function long of_llenar_sku (long al_row, any aa_dt_detalle, string as_tipo)
public function long of_crear_temporada (long al_row, any aa_dt_detalle, string as_tipo)
public function long of_detectar_existe (long al_item, any aa_dt_detalle, string as_tipo)
public function long of_validar_temporada (any aa_dt_detalle, string as_tipo)
public function long of_validar_ean_vta_pv (boolean ab_validar_cubicaje)
end prototypes

public function long of_mensaje (string as_titulo, string as_msn, s_base_parametros asp_parametros, string as_fin);/*
Funci$$HEX1$$f300$$ENDHEX$$n para dar formato a los mensajes que se muestran al usuario.

Parametros:

as_titulo:		Titulo del mensaje
as_msn:			Primer texto del mensaje que se muestra
asp_parametros: Campos que se desean mostrar en el mensaje, en cadena[] estan los encabezados y en Any[] los valores.
as_fin:			Mensaje Final que se muestra despues de los campos

Ej:
as_titulo = 'Error'
as_msn = 'Ocurrio un error:'
asp_parametros.Cadena[1] = 'Param1'
asp_parametros.Cadena[2] = 'Param2'
asp_parametros.Any[1] = 1
asp_parametros.Any[2] = 2
as_fin = 'Verifique el error'
-------------------------
| Error						|
|-----------------------|
| Ocurrio un error:		|
| Param1	Param2			|
| 1		2					|
| Verifique el error		|
-------------------------
*/

String ls_mensaje, ls_formato, ls_valores[], ls_campos[]
Long li_i, li_tamano, li_max_linea = 500


If Len(as_msn) > 0 Then
	ls_mensaje = as_msn + '~r~n'
End If

// Se da formato a los nombres
For li_i = 1 To UpperBound(asp_parametros.Cadena)
	// si es nulo se pon una cadena vacia
	If IsNull (asp_parametros.Cadena[li_i]) Then
		ls_campos[li_i] = ''
	Else
		ls_campos[li_i] = asp_parametros.Cadena[li_i]
	End If
Next

// Se da formato de string a los valores
For li_i = 1 To UpperBound(asp_parametros.Any)
	// si es nulo se pone el texto NULL
	If IsNull (asp_parametros.Any[li_i]) Then
		ls_valores[li_i] = 'NULL'
	Else
		ls_valores[li_i] = Trim (String (asp_parametros.Any[li_i]) )
	End If
Next

// nombre de los campos
For li_i = 1 To UpperBound(asp_parametros.Cadena)
	If li_i > 1 Then	ls_mensaje += '~t'	
	ls_mensaje += ls_campos[li_i]
Next
ls_mensaje += '~r~n'
// los valores de los campos
For li_i = 1 To UpperBound(asp_parametros.Any)
	If li_i > 1 Then	ls_mensaje += '~t'
	ls_mensaje += ls_valores[li_i]
Next

If Len(as_fin) > 0 Then
	ls_mensaje += '~r~n~n' + as_fin
End If

MessageBox(as_titulo, ls_mensaje )

Return 1


end function

public function long of_obtener_ref_cliente ();/*
Funci$$HEX1$$f300$$ENDHEX$$n para obtener la marca en ref_cliente y en sw_carga_ean
*/

Long li_retorno
Long ll_filas
uo_dsbase lds_m_clientes_exp
s_base_parametros lsp_parametros

w_principal.SetMicroHelp('Validando cliente ..')
// Se busca el cliente
lds_m_clientes_exp = Create uo_dsbase
lds_m_clientes_exp.Dataobject = 'd_gr_m_clientes_exp_asn_vesconfec' //asn_cliente.pbl
lds_m_clientes_exp.SetTransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )
ll_filas = lds_m_clientes_exp.Of_Retrieve( il_cliente, il_sucursal)

lsp_parametros.Cadena[1] = 'Cliente'
lsp_parametros.Cadena[2] = 'Sucursal'			
lsp_parametros.Any[1] = il_cliente
lsp_parametros.Any[2] = il_sucursal		
ii_sw_carga_ean = 0
Choose Case ll_filas
	Case IS > 0
		// si existe se toman la marca en ref_cliente y en sw_carga_ean
		li_retorno = 1
		is_tipo_cliente = Upper ( Trim( lds_m_clientes_exp.GetItemString( 1, 'ref_cliente') ) )					
		ii_sw_carga_ean = lds_m_clientes_exp.GetItemNumber(1,'sw_carga_ean')
		If IsNull(ii_sw_carga_ean) Then ii_sw_carga_ean = 0
	Case 0
		// Si no existe muestra error
		li_retorno = -1
		This.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro informaci$$HEX1$$f300$$ENDHEX$$n de la referencia del cliente (ref_cliente)', lsp_parametros, '')
	Case Else
		// si ocurrio un error en la BD
		li_retorno = -1
		This.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error en la Base de Datos al intentar cargar ' + &
						'informaci$$HEX1$$f300$$ENDHEX$$n de la referencia del cliente (ref_cliente)', lsp_parametros, '')					
End Choose

Destroy(lds_m_clientes_exp)
Return li_retorno
end function

public function long of_set_detalle (uo_dsbase ads_dt_pedido);
ids_dt_pedido = ads_dt_pedido
Return 1
end function

public function long of_limpiar_sku ();/*
Funci$$HEX1$$f300$$ENDHEX$$n para limpiar el sku
*/

SetNull(il_co_fabrica_exp)
SetNull(il_co_linea_exp)
SetNull(il_co_calidad)
SetNull(is_co_ref_exp)
SetNull(is_co_talla_exp)
SetNull(is_co_color_exp)

il_co_fabrica		= 0
il_co_linea			= 0
il_co_referencia	= 0
il_co_talla			= 0
il_co_calidad_eq	= 0
il_co_color 		= 0
is_upc_barcode = '0'

ib_sourcing			= False

SetNull(is_po)
SetNull(is_nu_cut)
SetNull(is_co_prepack)

ii_uni_empaque = 0
ii_cubicaje = 0

Return 1
end function

public function long of_reiniciar_propiedades ();SetNull(il_cliente) 
SetNull(il_sucursal)
SetNull(il_division)
SetNull(il_co_fabrica_vta)
is_tipo_pedido = 'EX'
SetNull(is_tipo_cliente)
SetNull(ii_sw_carga_ean)

This.Of_Limpiar_SKU()

Destroy(ids_referencia)

Return 1
end function

public function long of_validar_sku_nal ();Long ll_retorno


// Se valida la referencia en h_preref
ll_retorno = This.of_validar_ref_nal()
If ll_retorno = 1 Then
	// Se valida en el maestro de eans
	ll_retorno = This.of_validar_ean()		
	If ll_retorno = 1 And This.is_tipo_pedido = 'NA' Then
		ll_retorno = This.Of_Obtener_Equivalencia()
		If ll_retorno = 1 Then
			If il_cliente = 5160 Then
				ll_retorno = This.Of_Validar_Ean_vta_PV( False)			
			Else
				ll_retorno = This.Of_Validar_Ean_vta()			
			End If
		End If
	End If
End If

Return ll_retorno
end function

public function long of_validar_ref_nal ();/*
Funci$$HEX1$$f300$$ENDHEX$$n para verificar que la referencia de produccion

Precondiciones:
 Deben de haber ingresado los parametros de la referencia
  il_co_fabrica, il_co_linea, il_co_referencia

Retorno:
1   - Exito
< 0 - Error
*/
Long ll_filas, ll_reg, ll_retorno
String ls_expresion
s_base_parametros lsp_parametros
uo_dsbase lds_referencia


ls_expresion = 'co_fabrica = ' + String(il_co_fabrica) + ' AND co_linea = ' + String(il_co_linea) + &
					' AND co_referencia = '  + String(il_co_referencia)

If Not IsValid(ids_referencia) Then
	ids_referencia = Create uo_dsbase
	ids_referencia.DataObject = 'd_gr_evalua_h_preref'
	ids_referencia.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia() )
	
	ll_reg = 0
Else
	ll_reg = ids_referencia.Find( ls_expresion, 1, ids_referencia.RowCount() )
						
End If
	
lsp_parametros.Cadena[1] = 'Fab.'
lsp_parametros.Cadena[2] = 'Linea'
lsp_parametros.Cadena[3] = 'Referencia'

lsp_parametros.Any[1] = il_co_fabrica
lsp_parametros.Any[2] = il_co_linea
lsp_parametros.Any[3] = il_co_referencia

is_de_referencia = '-0-'

If ll_reg <= 0 Then
	
	lds_referencia = Create uo_dsbase
	lds_referencia.DataObject = 'd_gr_evalua_h_preref'
	lds_referencia.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia() )	
	
	ll_filas = lds_referencia.Of_Retrieve(il_co_fabrica, il_co_linea, is_co_referencia)	
	
	Choose Case ll_filas
		Case 0		
			This.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro la referencia de producci$$HEX1$$f300$$ENDHEX$$n', lsp_parametros, '')				
			ll_retorno = -1
		Case Is > 0
			lds_referencia.RowsCopy(1, ll_filas, Primary!, ids_referencia, 1, Primary!)			
			ll_reg = ids_referencia.Find( ls_expresion, 1, ids_referencia.RowCount() )
			If ll_reg <= 0 Then
				This.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro la referencia de producci$$HEX1$$f300$$ENDHEX$$n ('+String(ll_reg) +')', lsp_parametros, '')				
				ll_retorno = -1
			Else
				ll_retorno = 1	
			End If			
			
		Case Else
			ROLLBACK Using gnv_recursos.Of_Get_Transaccion_Sucia();
			Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un Error al tratar de consultar la referencia de producci$$HEX1$$f300$$ENDHEX$$n', lsp_parametros, '')
			ll_retorno = -2
	End Choose
	Destroy(lds_referencia)
Else
	ll_retorno = 1
End If
If ll_retorno > 0 And ll_reg > 0 Then
	is_de_referencia	= Trim (ids_referencia.GetItemString( ll_reg, 'de_referencia_crta') )			
	ib_sourcing		= (Trim (ids_referencia.GetItemString( ll_reg, 'sw_soursing') ) = '1')			
	il_co_cliente_ref = ids_referencia.GetItemNumber( ll_reg, 'co_cliente') 
	If ib_validar_sourcing Then
		// Validacion para SOURCING y las referencias deben estar marcadas como surcing
		If il_co_fabrica_vta = 99 And Not ib_sourcing Then
			This.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'La Referencia no tiene la marca para SOURCING!', lsp_parametros, '')			
			ll_retorno = -3
		End If
	End If
End If


Return ll_retorno

end function

public function long of_validar_ean ();/*
Funci$$HEX1$$f300$$ENDHEX$$n para verificar que el SKU nacional exista

Precondiciones:
 Deben de haber ingresado los parametros del SKu
  il_co_fabrica, il_co_linea, il_co_referencia, il_co_talla, il_co_calidad, il_co_color

Retorno:
1   - Exito
< 0 - Error
*/
Long ll_filas, ll_reg, ll_retorno
String ls_referencia
s_base_parametros lsp_parametros
uo_dsbase lds_sku


lds_sku = Create uo_dsbase
lds_sku.DataObject = 'd_gr_dt_ref_x_col'
lds_sku.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ))

//ll_reg = lds_sku.of_retrieve(il_co_fabrica, il_co_linea, il_co_referencia, &
//								il_co_talla, il_co_calidad, il_co_color )

ll_reg = lds_sku.of_retrieve(il_co_fabrica, il_co_linea, is_co_ref_exp, &
								is_co_talla_exp, il_co_calidad, is_co_color_exp )

lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$b.'
lsp_parametros.Cadena[2] = 'L$$HEX1$$ed00$$ENDHEX$$nea'
lsp_parametros.Cadena[3] = 'Referen.'
lsp_parametros.Cadena[4] = 'Talla'
lsp_parametros.Cadena[5] = 'Calidad'
lsp_parametros.Cadena[6] = 'Color'

lsp_parametros.Any[1] = il_co_fabrica
lsp_parametros.Any[2] = il_co_linea
lsp_parametros.Any[3] = is_co_ref_exp
lsp_parametros.Any[4] = is_co_talla_exp
lsp_parametros.Any[5] = il_co_calidad
lsp_parametros.Any[6] = is_co_color_exp

Choose Case ll_reg
	Case Is > 0 
		// se asigna el ean al upc
		is_upc_barcode = Trim(lds_sku.GetItemString(ll_reg,'ean') )
		
		ll_retorno = 1
	Case 0
		Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No esta creado en el maestro de Eans.', lsp_parametros, 'Por favor verificar este sku en el maestro de Ean.')
		ll_retorno = -3					
	Case Else											
		Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un Error en la Base de Datos al intentar cargar datos del SKU.', lsp_parametros, '')
		ll_retorno = -1
End Choose
If ll_retorno < 0 Then
	il_co_fabrica	= 0
	il_co_linea		= 0
	il_co_referencia= 0
	il_co_talla		= 0
	il_co_calidad_eq = 0
	il_co_color		= 0
End If
Destroy(lds_sku)
Return ll_retorno
end function

public function long of_validar_cc_cliente ();// Se valida que el cliente sucursal exista en los maestros de cc_cliente
uo_dsbase lds_clientes, lds_sucursales
Long ll_rowc, ll_rows
s_base_parametros lsp_parametros
String ls_info

lds_clientes = CREATE uo_dsbase
lds_clientes.DataObject = 'd_gr_cc_cliente'
lds_clientes.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia() )

ll_rowc = lds_clientes.Of_Retrieve(il_cliente)

If ll_rowc < 0 Then
	MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar cc_clientes.')
	Return -1
End If

lds_sucursales = CREATE uo_dsbase
lds_sucursales.DataObject = 'd_gr_cc_sucursal'
lds_sucursales.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia() )

ll_rows = lds_sucursales.Of_Retrieve(il_cliente, il_sucursal)

If ll_rows < 0 Then
	MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar cc_sucursal.')
	Return -1
End If


ls_info = 'Por favor informar a Clara Yaneth Garc$$HEX1$$ed00$$ENDHEX$$a. Puede continuar con el ingreso del pedido.'

If ll_rowc > 0 And ll_rows > 0 Then

ElseIf ll_rowc = 0 And ll_rows = 0 Then
	lsp_parametros.Cadena[1] = 'co_cliente'
	lsp_parametros.Cadena[2] = 'co_sucursal'	
	lsp_parametros.Any[1] = il_cliente
	lsp_parametros.Any[2] = ''
	lsp_parametros.Any[3] = il_sucursal
	
	Of_Mensaje('Informaci$$HEX1$$f300$$ENDHEX$$n', 'No existe en cliente y la sucursal en cc_cliente y cc_sucursal.', lsp_parametros, ls_info)	
	
ElseIf ll_rowc = 0 Then
	lsp_parametros.Cadena[1] = 'co_cliente'
	lsp_parametros.Any[1] = il_cliente
	Of_Mensaje('Informaci$$HEX1$$f300$$ENDHEX$$n', 'No existe el cliente en cc_cliente.', lsp_parametros, ls_info)
ElseIf ll_rows = 0 Then	
	lsp_parametros.Cadena[1] = 'co_cliente'
	lsp_parametros.Cadena[2] = 'co_sucursal'	
	lsp_parametros.Any[1] = il_cliente
	lsp_parametros.Any[2] = ''
	lsp_parametros.Any[3] = il_sucursal
	Of_Mensaje('Informaci$$HEX1$$f300$$ENDHEX$$n', 'No existe la sucursal en cc_sucursal.', lsp_parametros, ls_info)
End If

Destroy(lds_clientes)
Destroy(lds_sucursales)
	
Return 1
end function

public function long of_validar_po (string as_po);/*
Funci$$HEX1$$f300$$ENDHEX$$n para validar si la PO as_po existe,

Si existe muestra una advertencia de que ya si existe, 
Retorno:
1:		Si no existe.
		Si existe y el usuario confirma que desea crear el pedido
	 
-1:	Si existe y el usuario no desea crear el pedido
		Ocurrio un error en la Consulta

*/

uo_dsbase lds_validar_po
Long ll_filas, ll_retorno

// se valida que no exista
lds_validar_po = Create uo_dsbase
lds_validar_po.DataObject = 'd_gr_hallar_pedido_fabrica'
lds_validar_po.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
ll_filas = lds_validar_po.Of_Retrieve(as_po)			
Choose Case ll_filas
	Case 0 // no existe PO
		ll_retorno = 1
	Case Is > 0 // ya existe un pedido con esa PO					
		ll_retorno = MessageBox("Advertencia","N$$HEX1$$fa00$$ENDHEX$$mero de PO '" + String(as_po) + "' ya existe,~r~nEsta seguro que desea crear otro pedido interno con la misma PO?",Question!,YesNo!)
		If ll_retorno <> 1 Then
			ll_retorno = -1
		End If
	Case Else										
		ROLLBACK Using gnv_recursos.Of_Get_Transaccion_Sucia();
		MessageBox("Advertencia","Ocurrio un error al consultar si existe la PO '" + String(as_po) + "'",Exclamation!,Ok!)
		ll_retorno = -1
End Choose
Destroy(lds_validar_po)
Return ll_retorno
end function

public function long of_validar_ean_vta ();/*
Funci$$HEX1$$f300$$ENDHEX$$n para verificar que el SKU de venta exista

Precondiciones:
 Deben de haber ingresado los parametros del SKu
  il_co_fabrica_exp, il_co_linea_exp, is_co_ref_exp, is_co_talla_exp, il_co_calidad, is_co_color_exp

Retorno:
1   - Exito
< 0 - Error
*/
Long ll_filas, ll_reg, ll_retorno
String ls_referencia
s_base_parametros lsp_parametros
uo_dsbase lds_sku


lds_sku = Create uo_dsbase
lds_sku.DataObject = 'd_gr_dt_ref_x_col'
lds_sku.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ))

ll_reg = lds_sku.of_retrieve(il_co_fabrica_exp, il_co_linea_exp, is_co_ref_exp, &
								is_co_talla_exp, il_co_calidad, is_co_color_exp )
	
lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$b. Vta'
lsp_parametros.Cadena[2] = 'Linea Vta'
lsp_parametros.Cadena[3] = 'Ref. Vta'
lsp_parametros.Cadena[4] = 'Talla Vta'
lsp_parametros.Cadena[5] = 'Calidad'
lsp_parametros.Cadena[6] = 'Color '
				
lsp_parametros.Any[1] = il_co_fabrica_exp
lsp_parametros.Any[2] = il_co_linea_exp
lsp_parametros.Any[3] = is_co_ref_exp
lsp_parametros.Any[4] = is_co_talla_exp
lsp_parametros.Any[5] = il_co_calidad
lsp_parametros.Any[6] = is_co_color_exp
					
Choose Case ll_reg
	Case Is > 0 
		// se asigna el ean al upc
		is_upc_barcode = Trim(lds_sku.GetItemString(ll_reg,'ean') )
		
		If is_tipo_pedido = 'NA' And (ib_valida_ean Or ib_valida_ean_generico) And &
			(is_upc_barcode = '' Or is_upc_barcode = '0' Or IsNull(is_upc_barcode) Or &
				(ib_valida_ean_generico And ( is_upc_barcode = 'GENERICO'  Or Len(is_upc_barcode) < 7) ) &
			) Then			
				
			If ib_msn_validacion Then
				Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'La referencia de vta tiene el ean en cero (0) en el maestro de Eans ', lsp_parametros, 'Por favor verificar este ean para el sku en el maestro de Ean.')
			End If
			ll_retorno = -4
		Else
			ll_retorno = 1
		End If		
		
	Case 0
		If is_tipo_pedido = 'NA' Then
			If ib_msn_validacion Then
				Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'El pedido de esta OP esta creado como Stock(S) y No como Order (O), y No esta creado en el maestro de Eans la referencia de vta.', lsp_parametros, 'Por favor verificar este sku en el maestro de Ean. o informe al Planeador para que verifique si el pedido esta bien creado')
			End If
		End If
		ll_retorno = -3					
	Case Else		
		Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un Error en la Base de Datos al intentar cargar datos del SKU de Vta.', lsp_parametros, '')
		ll_retorno = -1
End Choose
Destroy(lds_sku)

Return ll_retorno
end function

public function long of_validar_sku_nal_vta ();Long ll_retorno, ll_ret
String ls_ean_vta
	
	
// Se valida en el maestro de eans
ll_retorno = This.of_validar_Ean_Vta()		
If ll_retorno = 1 Then
	ls_ean_vta = This.is_upc_barcode
	ll_retorno = This.Of_Obtener_Equivalencia()	
	If ll_retorno = 2 Then
		ll_ret = 2
	End If
	If ll_retorno >= 1 Then
		// Se valida la referencia en h_preref
		ll_retorno = This.Of_Validar_Ref_Nal()
		If ll_retorno = 1 Then
			ll_retorno = This.Of_Validar_Ean()
			If ll_retorno > 0 Then
				This.is_upc_barcode = ls_ean_vta
				If ll_ret = 2 Then
					ll_retorno = 2
				End If
			End If
		End If
	End If
End If

Return ll_retorno
end function

public function long of_obtener_equivalencia ();/*******************************************************************************************************
Se cargan las equivalencias nacional para los pedidos de Vtaortancion, o
la referencia de venta para los pedidos nacionales
********************************************************************************************************/
Long ll_reg, ll_row_find
Long li_retorno, li_tipo
String ls_expresion
Boolean lb_pedir_cantidad, lb_mostrar_equivalencia
uo_dsbase lds_eq_x_sku_exp, lds_equivalencia
s_base_parametros lsp_parametros, lstr_parametros
Date ld_fe_inicial, ld_fe_final

/*
Se modifico w_administracion_pedidos, w_seleccionar_equivalencia_prod, 
d_gr_equivalencias_x_sku_exp, d_gr_equivalencias_x_sku_exp_nuevo,
d_tb_pedpend_exp, w_cargar_datos_clientes_exp
*/
If This.il_cliente = 5160 Then
	This.is_tipo_pedido = 'EX'
End If
If  This.is_tipo_pedido <> 'NA' Or (Not This.ib_eq_produccion And Not This.ib_valida_equivalencia) Then
//If Not This.ib_valida_equivalencia And Not This.ib_eq_produccion Then
	// si tiene todo los parametros del sku bien
	// 
	If Not IsNull(This.il_co_fabrica_exp) And Not IsNull(This.il_co_linea_exp) &
		And Not IsNull(This.il_co_calidad)     And Not IsNull(This.is_co_ref_exp) &
		And Not IsNull(This.is_co_talla_exp)   And Not IsNull(This.is_co_color_exp) Then
		
		If IsNull(This.il_co_color) Then This.il_co_color = 0

		lb_pedir_cantidad = False
		lb_mostrar_equivalencia = True
		is_co_prepack_temporada = ''
		
		lds_eq_x_sku_exp = Create uo_dsbase
		
		If This.is_tipo_pedido = 'NA' Then			
			li_tipo = 1
		Else
			li_tipo = 2
		End If
		
			lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
			lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
		
			ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
					This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
					This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, This.il_co_color, li_tipo)
					
			If ll_reg = 0 Then
				If ib_doble_equivalencia Then
					lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta" 
					lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
				
					ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
							This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
							This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, This.il_co_color, li_tipo)
				End If
			Else
				lb_pedir_cantidad = True				
				ll_row_find = lds_eq_x_sku_exp.Find('co_prepack = "' + String(This.is_co_prepack) + '"', 1 , lds_eq_x_sku_exp.RowCount())
				If ll_row_find > 0 Then
					lds_eq_x_sku_exp.SetFilter('co_prepack = "' + String(This.is_co_prepack) + '"')
					lds_eq_x_sku_exp.Filter()
					lb_mostrar_equivalencia = False
					ll_reg = 1
				End If
			End If
			
					
					
			
//		Else
//			li_tipo = 2
//			
//			
//			/*********/
//			lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
//			lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
//		
//			ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
//					This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
//					This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, This.il_co_color, li_tipo)
//					
//			If ll_reg = 0 Then
//				lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta" 
//				lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
//			
//				ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
//						This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
//						This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, This.il_co_color, li_tipo)
//			Else
////				lb_pedir_cantidad = True				
////				ll_row_find = lds_eq_x_sku_exp.Find('co_prepack = "' + String(This.is_co_prepack) + '"', 1 , lds_eq_x_sku_exp.RowCount())
////				If ll_row_find > 0 Then
////					lds_eq_x_sku_exp.SetFilter('co_prepack = "' + String(This.is_co_prepack) + '"')
////					lds_eq_x_sku_exp.Filter()
////					lb_mostrar_equivalencia = False
////					ll_reg = 1
////				End If
//			End If
			
			/************/
			
			
//			lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta" 
//			lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
//		
//			ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
//					This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
//					This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, This.il_co_color, li_tipo)				
//		End If
		
		
		
		// Se carga la equivalencia
		
//		lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
//	
//		ll_reg = lds_eq_x_sku_exp.of_retrieve(This.il_cliente, This.il_sucursal, &
//				This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
//				This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, This.il_co_color, li_tipo)		
		
		If ib_valida_equivalencia And ll_reg >= 0 Then
			ls_expresion = 'co_fabrica = ' + String(This.il_co_fabrica) + ' AND ' + &
				'co_linea	= ' + String(This.il_co_linea) + ' AND ' + &
				'co_referencia	= ' + String(This.il_co_referencia) + ' AND ' + &
				'co_talla	= ' + String(This.il_co_talla) + ' AND ' + &
				'co_color	= ' + String(This.il_co_color) +''
				
			ll_row_find = lds_eq_x_sku_exp.Find( ls_expresion, 1, lds_eq_x_sku_exp.RowCount() + 1)
		
			If ll_row_find <= 0 Then
				lsp_parametros.Cadena = {'F$$HEX1$$e100$$ENDHEX$$brica', 'Linea', 'Ref', 'Talla', 'Cal.', 'Col', &
							'Fab. Vta', 'Lin. Vta', 'Ref Vta', 'Talla Vta', 'Col Vta'}

				lsp_parametros.Any[1] = This.il_co_fabrica
				lsp_parametros.Any[2] = This.il_co_linea
				lsp_parametros.Any[3] = This.il_co_referencia
				lsp_parametros.Any[4] = This.il_co_talla
				lsp_parametros.Any[5] = This.il_co_calidad
				lsp_parametros.Any[6] = This.il_co_color
				lsp_parametros.Any[7] = This.il_co_fabrica_exp
				lsp_parametros.Any[8] = This.il_co_linea_exp
				lsp_parametros.Any[9] = This.is_co_ref_exp
				lsp_parametros.Any[10] = This.is_co_talla_exp
				lsp_parametros.Any[11] = This.is_co_color_exp
				
				Of_Mensaje ("Advertencia","Se ha detectado referencia sin equivalencias para:", lsp_parametros, "Verifique que esta equivalencia se encuentre almacenada.")	
				li_retorno = -1
			ElseIf ll_row_find > 0 Then
				This.is_co_prepack = lds_eq_x_sku_exp.GetItemString(ll_row_find,'co_prepack')
				li_retorno = 1
			End If
		Else


			Choose Case ll_reg		
				Case 1 // Tiene solo una equivalencia				
					This.il_co_fabrica = lds_eq_x_sku_exp.GetItemNumber(1,'co_fabrica')
					This.il_co_linea = lds_eq_x_sku_exp.GetItemNumber(1,'co_linea')
					This.il_co_referencia = lds_eq_x_sku_exp.GetItemNumber(1,'co_referencia')
					This.il_co_talla = lds_eq_x_sku_exp.GetItemNumber(1,'co_talla')
					This.il_co_calidad_eq = lds_eq_x_sku_exp.GetItemNumber(1,'co_calidad')
					This.il_co_color = lds_eq_x_sku_exp.GetItemNumber(1,'co_color')			
					This.is_co_prepack = Trim(lds_eq_x_sku_exp.GetItemString(1,'co_prepack'))
					
					ld_fe_inicial = lds_eq_x_sku_exp.GetItemDate(1,'fe_inicio')
					ld_fe_final = lds_eq_x_sku_exp.GetItemDate(1,'fe_final') 
					
					If lb_mostrar_equivalencia Then
						// retorna 1 para indicar que la ref_exp tiene solo una equivalencia
						li_retorno = 1
					Else
						idc_ca_temporada = il_cantidad
						This.is_co_prepack_temporada = This.is_co_prepack
						li_retorno = 2
					End If
				Case Is > 1 // Tiene mas de una equivalencia, se abre ventana para seleccionar
					
					lsp_parametros.ds_datos[1] = lds_eq_x_sku_exp
					lsp_parametros.cadena[1] = This.is_co_ref_exp
					lsp_parametros.cadena[2] = This.is_co_talla_exp
					lsp_parametros.cadena[3] = This.is_co_color_exp
					lsp_parametros.Boolean[1] = lb_pedir_cantidad
					lsp_parametros.Decimal[1] = il_cantidad
					
					lsp_parametros.hay_parametros = True
					OpenWithParm( w_seleccionar_equivalencia_prod, lsp_parametros)
					lsp_parametros = Message.PowerObjectParm
					If lsp_parametros.hay_parametros = False Then
						MessageBox("Advertencia ","No selecciono ninguna equivalencia...",StopSign!)
						li_retorno = -1
					Else
						
						This.il_co_fabrica	= lsp_parametros.entero[1]
						This.il_co_linea		= lsp_parametros.entero[2]
						This.il_co_referencia= lsp_parametros.entero[3]
						This.il_co_talla		= lsp_parametros.entero[4]
						This.il_co_calidad_eq= lsp_parametros.entero[5]
						This.il_co_color		= lsp_parametros.entero[6]
						This.is_co_prepack	= Trim(lsp_parametros.Cadena[1])
						ld_fe_inicial = lsp_parametros.fecha[1]
						ld_fe_final = lsp_parametros.fecha[2] 
						
						is_co_referencia = String(il_co_referencia)
						
						If This.is_co_prepack <> '' And lb_pedir_cantidad Then
							lds_eq_x_sku_exp.SetFilter('co_prepack = "' + This.is_co_prepack + '"')
							lds_eq_x_sku_exp.Filter()
							If lds_eq_x_sku_exp.RowCount() > 0 Then
								If IsValid(ids_equivalencias) Then
									ids_equivalencias.Reset()
								Else									
									ids_equivalencias = Create uo_dsbase
									ids_equivalencias.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
									ids_equivalencias.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )								
								End If
								lds_eq_x_sku_exp.RowsCopy( 1, lds_eq_x_sku_exp.RowCount(), Primary!, ids_equivalencias, 1, Primary!)
								This.is_co_prepack_temporada = This.is_co_prepack
								idc_ca_temporada = lsp_parametros.Decimal[1]
							End If
						End If
						
						//lds_eq_x_sku_exp.Filter()				
						//ids_equivalencias.GetItemNumber()		
	
						If lb_pedir_cantidad Then
							il_cantidad = lsp_parametros.Decimal[1]
						Else
							il_cantidad = 0
						End If
						li_retorno = 2
					End If
				Case 0 // Ocurrio un error
					// ya todo necesita equivalencia
					If This.is_tipo_pedido = 'NA' Then
						/*
						// no tiene equivalencia nal
						This.il_co_fabrica	= This.il_co_fabrica_exp
						This.il_co_linea		= This.il_co_linea_exp
						This.il_co_referencia= Long(This.is_co_ref_exp)
						This.il_co_talla		= Long(This.is_co_talla_exp)
						This.il_co_color		= Long(This.is_co_color_exp)
						// para indicar que no tiene equivalencia
						This.il_co_calidad_eq = 0
						This.is_co_prepack = ''
						li_retorno = 1
						*/
						lsp_parametros.Cadena = {'F$$HEX1$$e100$$ENDHEX$$brica', 'Linea', 'Ref Vta', 'Talla Vta', 'Cal.','Col Vta'}
		
						lsp_parametros.Any[1] = This.il_co_fabrica_exp
						lsp_parametros.Any[2] = This.il_co_linea_exp
						lsp_parametros.Any[3] = This.is_co_ref_exp
						lsp_parametros.Any[4] = This.is_co_talla_exp
						lsp_parametros.Any[5] = This.il_co_calidad
						lsp_parametros.Any[6] = This.is_co_color_exp
						
						If This.il_co_color > 0 Then
							lsp_parametros.Cadena[9] = 'Color'
							lsp_parametros.Any[9] = This.il_co_color
						End If
						Of_Mensaje ("Advertencia","Se ha detectado referencia sin equivalencias para:", lsp_parametros, "Verifique que esta informaci$$HEX1$$f300$$ENDHEX$$n en la equivalencia")				
						li_retorno = -1
						
						
					Else
						
						lsp_parametros.Cadena = {'Cliente', 'Suc.', 'F$$HEX1$$e100$$ENDHEX$$brica', 'Linea', 'Ref Vta', 'Talla Vta', 'Cal.','Col Vta'}
		
						lsp_parametros.Any[1] = This.il_cliente
						lsp_parametros.Any[2] = This.il_sucursal
						lsp_parametros.Any[3] = This.il_co_fabrica_exp
						lsp_parametros.Any[4] = This.il_co_linea_exp
						lsp_parametros.Any[5] = This.is_co_ref_exp
						lsp_parametros.Any[6] = This.is_co_talla_exp
						lsp_parametros.Any[7] = This.il_co_calidad
						lsp_parametros.Any[8] = This.is_co_color_exp
						
						If This.il_co_color > 0 Then
							lsp_parametros.Cadena[9] = 'Color'
							lsp_parametros.Any[9] = This.il_co_color
						End If
						Of_Mensaje ("Advertencia","Se ha detectado referencia sin equivalencias para:", lsp_parametros, "Verifique que esta informaci$$HEX1$$f300$$ENDHEX$$n se encuentre almacenada para el cliente")				
						li_retorno = -1
					End If
					
				Case Else
					MessageBox("Advertencia - Error de Base de Datos","Hubo problemas recuperando datos de m_referencias_eq~n~n"+lds_eq_x_sku_exp.is_sqlerrtext,StopSign!)
					li_retorno = -1
			End Choose
		End If
		
	Else
		li_retorno = 0 // alguna parametro es nulo
	End If
	
	If li_retorno > 0 Then
		If isnull(ld_fe_inicial) or isnull(ld_fe_final) Then
			MessageBox("Advertencia ","La fecha es nula en la equivalencia, por favor asignar una fecha valida.",StopSign!)
			li_retorno = -1
		End if
	End if
	id_fe_inicial = ld_fe_inicial
	id_fe_final = ld_fe_final

Else // tipo_pedido = NA y tiene todos los campos llenos
	If     Not IsNull(This.il_co_fabrica) And Not IsNull(This.il_co_linea) &
		And Not IsNull(This.il_co_calidad) And Not IsNull(This.il_co_referencia) &
		And Not IsNull(This.il_co_talla)   And Not IsNull(This.il_co_color) Then
		// carga la equivalencia Nal
		lds_equivalencia = Create uo_dsbase
		lds_equivalencia.Dataobject  = "d_gr_equivalencia_nuevo_referencia_nal" //"d_gr_equivalencia_referencia_nal" 
		lds_equivalencia.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
		
		ll_reg = lds_equivalencia.Of_Retrieve(This.il_co_fabrica, This.il_co_linea, This.il_co_referencia,This.il_co_talla, This.il_co_calidad, This.il_co_color)
		
		// Si no encontro equivalencias en el sistema nuevo verifica en el viejo
		If ll_reg <= 0 /*And ib_doble_equivalencia*/ Then
			lds_equivalencia.Dataobject  = "d_gr_equivalencia_referencia_nal" 
			lds_equivalencia.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )
			ll_reg = lds_equivalencia.Of_Retrieve(This.il_co_fabrica, This.il_co_linea, This.il_co_referencia,This.il_co_talla, This.il_co_calidad, This.il_co_color)
		End If			
		
		If ib_valida_equivalencia And ll_reg >= 0 Then
			
			If This.il_co_fabrica_exp = This.il_co_fabrica And &
				This.il_co_linea_exp = This.il_co_linea And &
				String(This.il_co_referencia) = Trim(This.is_co_ref_exp) And &
				String(This.il_co_talla) = Trim(This.is_co_talla_exp) And &
				String(This.il_co_color) = Trim(This.is_co_color_exp) Then
				
				li_retorno = 1
			Else
				ls_expresion = 'co_fabrica_exp = ' + String(This.il_co_fabrica_exp) + ' AND ' + &
					'co_linea_exp	= ' + String(This.il_co_linea_exp) + ' AND ' + &
					'co_ref_exp		= "' + Trim(This.is_co_ref_exp) + '" AND ' + &
					'co_talla_exp	= "' + Trim(This.is_co_talla_exp) + '" AND ' + &
					'co_color_exp	= "' + Trim(This.is_co_color_exp) +'"'
					
				ll_row_find = lds_equivalencia.Find( ls_expresion, 1, lds_equivalencia.RowCount() + 1)
			
				If ll_row_find <= 0 Then
					lsp_parametros.Cadena = {'F$$HEX1$$e100$$ENDHEX$$brica', 'Linea', 'Ref', 'Talla', 'Cal.', 'Col', &
								'Fab. Vta', 'Lin. Vta', 'Ref Vta', 'Talla Vta', 'Col Vta'}
	
					lsp_parametros.Any[1] = This.il_co_fabrica
					lsp_parametros.Any[2] = This.il_co_linea
					lsp_parametros.Any[3] = This.il_co_referencia
					lsp_parametros.Any[4] = This.il_co_talla
					lsp_parametros.Any[5] = This.il_co_calidad
					lsp_parametros.Any[6] = This.il_co_color
					lsp_parametros.Any[7] = This.il_co_fabrica_exp
					lsp_parametros.Any[8] = This.il_co_linea_exp
					lsp_parametros.Any[9] = This.is_co_ref_exp
					lsp_parametros.Any[10] = This.is_co_talla_exp
					lsp_parametros.Any[11] = This.is_co_color_exp
					
					Of_Mensaje ("Advertencia","Se ha detectado referencia sin equivalencias para:", lsp_parametros, "Verifique que esta equivalencia se encuentre almacenada.")				
					li_retorno = -1
				ElseIf ll_row_find > 0 Then
					This.is_co_prepack = lds_equivalencia.GetItemString(ll_row_find,'co_prepack')
					li_retorno = 1
				End If
			End If
		Else
			Choose Case ll_reg
				Case 1 // Tiene una sola equivalencia
					This.il_co_fabrica_exp	= lds_equivalencia.GetItemNumber(1,'co_fabrica_exp')
					This.il_co_linea_exp 	= lds_equivalencia.GetItemNumber(1,'co_linea_exp')
					This.is_co_ref_exp		= lds_equivalencia.GetItemString(1,'co_ref_exp')
					This.is_co_talla_exp		= lds_equivalencia.GetItemString(1,'co_talla_exp')
					This.il_co_calidad_eq	= lds_equivalencia.GetItemNumber(1,'co_calidad')
					This.is_co_color_exp		= lds_equivalencia.GetItemString(1,'co_color_exp')
					This.is_co_prepack		= lds_equivalencia.GetItemString(1,'co_prepack')
					
					ld_fe_inicial = lds_equivalencia.GetItemDate(1,'fe_inicio')
					ld_fe_final = lds_equivalencia.GetItemDate(1,'fe_final') 
					
					// retorna 1 para indicar que solo una equivalencia
					li_retorno = 1
				Case Is > 1 // Tiene mas de una equivalencia se abre ventana para seleccionar
					lstr_parametros.Cadena[1] = String(This.il_co_fabrica)
					lstr_parametros.Cadena[2] = String(This.il_co_linea)
					lstr_parametros.Cadena[3] = String(This.il_co_referencia)
					lstr_parametros.Cadena[4] = String(This.il_co_talla)
					lstr_parametros.Cadena[5] = String(This.il_co_color)
					lstr_parametros.ds_datos[1] = lds_equivalencia
					OpenWithParm( w_seleccionar_equivalencia_vta, lstr_parametros)
					lsp_parametros = Message.PowerObjectParm
					If lsp_parametros.hay_parametros = False Then
						MessageBox("Advertencia ","No selecciono ninguna equivalencia...",StopSign!)
						li_retorno = -1
					Else
						This.il_co_fabrica_exp	= lsp_parametros.entero[1]
						This.il_co_linea_exp 	= lsp_parametros.entero[2]
						This.is_co_ref_exp		= lsp_parametros.Cadena[1]
						This.is_co_talla_exp		= lsp_parametros.Cadena[2]
						This.il_co_calidad_eq	= This.il_co_calidad
						This.is_co_color_exp		= lsp_parametros.Cadena[3]
						This.is_co_prepack		= lsp_parametros.Cadena[4]
						ld_fe_inicial = lsp_parametros.fecha[1]
						ld_fe_final = lsp_parametros.fecha[2] 
						
						li_retorno = 1
					End If
				Case 0 // no tiene equivalencia nal
					This.il_co_fabrica_exp	= This.il_co_fabrica
					This.il_co_linea_exp 	= This.il_co_linea
					This.is_co_ref_exp		= String(This.il_co_referencia)
					This.is_co_talla_exp		= String(This.il_co_talla)
					This.is_co_color_exp		= String(This.il_co_color)
					// para indicar que no tiene equivalencia
					This.il_co_calidad_eq = 0
					This.is_co_prepack = ''
					li_retorno = 1
				Case Else // Ocurrio un error 
					MessageBox("Advertencia - Error de Base de Datos","Hubo problemas recuperando datos de m_referencias_eq~n~n"+lds_equivalencia.is_sqlerrtext,StopSign!)
					li_retorno = -1
			End Choose				
		End If
	Else
		li_retorno = 0 // alguna parametro es nulo
	End If
End If


Destroy (lds_eq_x_sku_exp)
Destroy (lds_equivalencia)
Return li_retorno
end function

public function long of_llenar_sku3 (long al_row, any aa_ds_detalle);/* 
Funci$$HEX1$$f300$$ENDHEX$$n para cargar el sku desde lds_detalle fila al_row
*/

uo_dsbase lds_detalle
string ls_cadena


//Choose Case ClassName (aa_ds_detalle)
//	Case 'Datastore'
//	
//End Choose
//
//ls_cadena = ClassName (aa_ds_detalle)
//
//aa_ds_detalle.TypeOf()
//TypeOf( aa_ds_detalle)


//
//lds_detalle = Create uo_dsbase
//lds_detalle.DataObject = adw_detalle.DataObject
//
//adw_detalle.RowsCopy( al_row, al_row, Primary!, lds_detalle, 1, Primary!)


If lds_detalle.Describe( is_nombre_po + '.key') <> '!' Then
	This.is_po	= Trim (lds_detalle.GetItemString(al_row, is_nombre_po))	
End If



This.is_nu_cut 		= Trim (lds_detalle.GetItemString(al_row,"nu_cut"))

This.il_co_fabrica_exp = lds_detalle.GetItemNumber(al_row,"co_fabrica_exp")
This.il_co_linea_exp	= lds_detalle.GetItemNumber(al_row,"co_linea_exp")
This.is_co_ref_exp	= Trim (lds_detalle.GetItemString(al_row,"co_ref_exp"))
This.is_co_talla_exp	= Trim (lds_detalle.GetItemString(al_row,"co_talla_exp"))
This.il_co_calidad	= lds_detalle.GetItemNumber(al_row,"co_calidad")
This.is_co_color_exp	= Trim (lds_detalle.GetItemString(al_row,"co_color_exp"))

This.il_co_fabrica	= lds_detalle.GetItemNumber(al_row,"co_fabrica")
This.il_co_linea		= lds_detalle.GetItemNumber(al_row,"co_linea")
This.il_co_referencia= lds_detalle.GetItemNumber(al_row,"co_referencia")
This.il_co_talla		= lds_detalle.GetItemNumber(al_row,"co_talla")
This.il_co_calidad	= lds_detalle.GetItemNumber(al_row,"co_calidad")
This.il_co_color		= lds_detalle.GetItemNumber(al_row,"co_color")

This.is_upc_barcode	= Trim(lds_detalle.GetItemString(al_row,"upc_barcode"))
This.is_co_prepack	= Trim(lds_detalle.GetItemString(al_row,"co_prepack"))

Return 1
end function

public function long of_llenar_sku (long al_row, uo_dsbase ads_detalle);/* 
Funci$$HEX1$$f300$$ENDHEX$$n para cargar el sku desde ads_detalle fila al_row
*/
/*
If ads_detalle.RowCount() = 0 Then
	This.Of_Limpiar_Sku()
	Return -1	
End If
If ads_detalle.Describe( is_nombre_po + '.key') <> '!' Then
	This.is_po	= Trim (ads_detalle.GetItemString(al_row, is_nombre_po))	
End If


This.is_nu_cut 		= Trim (ads_detalle.GetItemString(al_row,"nu_cut"))

This.il_co_fabrica_exp = ads_detalle.GetItemNumber(al_row,"co_fabrica_exp")
This.il_co_linea_exp	= ads_detalle.GetItemNumber(al_row,"co_linea_exp")
This.is_co_ref_exp	= Trim (ads_detalle.GetItemString(al_row,"co_ref_exp"))
This.is_co_talla_exp	= Trim (ads_detalle.GetItemString(al_row,"co_talla_exp"))
This.il_co_calidad	= ads_detalle.GetItemNumber(al_row,"co_calidad")
This.is_co_color_exp	= Trim (ads_detalle.GetItemString(al_row,"co_color_exp"))

This.il_co_fabrica	= ads_detalle.GetItemNumber(al_row,"co_fabrica")
This.il_co_linea		= ads_detalle.GetItemNumber(al_row,"co_linea")
This.il_co_referencia= ads_detalle.GetItemNumber(al_row,"co_referencia")
This.il_co_talla		= ads_detalle.GetItemNumber(al_row,"co_talla")
This.il_co_calidad	= ads_detalle.GetItemNumber(al_row,"co_calidad")
This.il_co_color		= ads_detalle.GetItemNumber(al_row,"co_color")

This.is_upc_barcode	= Trim(ads_detalle.GetItemString(al_row,"upc_barcode"))
This.is_co_prepack	= Trim(ads_detalle.GetItemString(al_row,"co_prepack"))
*/

Return This.Of_Llenar_Sku( al_row, ads_detalle, 'ds')
end function

public function long of_llenar_sku (long al_row, uo_dtwndow adw_detalle);/* 
Funci$$HEX1$$f300$$ENDHEX$$n para cargar el sku desde adw_detalle fila al_row
*/
/*
This.is_nu_cut 		= Trim (adw_detalle.GetItemString(al_row,"nu_cut"))

This.il_co_fabrica_exp = adw_detalle.GetItemNumber(al_row,"co_fabrica_exp")
This.il_co_linea_exp	= adw_detalle.GetItemNumber(al_row,"co_linea_exp")
This.is_co_ref_exp	= Trim (adw_detalle.GetItemString(al_row,"co_ref_exp"))
This.is_co_talla_exp	= Trim (adw_detalle.GetItemString(al_row,"co_talla_exp"))
This.il_co_calidad	= adw_detalle.GetItemNumber(al_row,"co_calidad")
This.is_co_color_exp	= Trim (adw_detalle.GetItemString(al_row,"co_color_exp"))

This.il_co_fabrica	= adw_detalle.GetItemNumber(al_row,"co_fabrica")
This.il_co_linea		= adw_detalle.GetItemNumber(al_row,"co_linea")
This.il_co_referencia= adw_detalle.GetItemNumber(al_row,"co_referencia")
This.il_co_talla		= adw_detalle.GetItemNumber(al_row,"co_talla")
This.il_co_calidad	= adw_detalle.GetItemNumber(al_row,"co_calidad")
This.il_co_color		= adw_detalle.GetItemNumber(al_row,"co_color")

This.is_upc_barcode	= Trim(adw_detalle.GetItemString(al_row,"upc_barcode"))
This.is_co_prepack	= Trim(adw_detalle.GetItemString(al_row,"co_prepack"))
*/
/*
Long li_retorno
uo_dsbase lds_detalle


lds_detalle = Create uo_dsbase
lds_detalle.DataObject = adw_detalle.DataObject

adw_detalle.RowsCopy( al_row, al_row, Primary!, lds_detalle, 1, Primary!)

li_retorno = This.Of_Llenar_Sku( 1, lds_detalle)

Destroy(lds_detalle)
*/



Return This.Of_Llenar_Sku( al_row, adw_detalle, 'dw')
end function

public function long of_validar_temporada (datawindow adw_detalle);/*
Funcion para validar la referencia de venta en las temporadas definidas.


*/

Long li_retorno
uo_dsbase lds_detalle

lds_detalle = Create uo_dsbase
lds_detalle.DataObject = adw_detalle.DataObject
lds_detalle.SetTransObject(SQLCA)

adw_detalle.RowsCopy( 1, adw_detalle.RowCount(), Primary!, lds_detalle, 1, Primary!)

li_retorno = This.Of_Validar_Temporada(lds_detalle, 'ds')

Destroy lds_detalle

Return li_retorno
end function

public function long of_crear_temporada (long al_row, datawindow adw_detalle);/*
Funcion para validar la referencia de venta en las temporadas definidas.


*/

Long li_tipo, li_retorno
Long ll_row, ll_fila, ll_row_find, ll_find, ll_uni_empaque, ll_filas, ll_reg, ll_cantidad, ll_cantidad_esp, ll_cantidad_empq, ll_row2, ll_item
String ls_expresion, ls_sku_vta
Decimal ldc_ca_surtida, ldc_escala_esp, ldc_porcentaje
uo_dsbase lds_eq_x_sku_exp, lds_cubicaje//, lds_detalle
s_base_parametros lsp_parametros
n_cst_mensaje lnvo_msn

//lds_detalle = Create uo_dsbase
//lds_detalle.DataObject = adw_detalle.DataObject
//lds_detalle.SetTransObject(SQLCA)
//
//adw_detalle.RowsCopy( 1, adw_detalle.RowCount(), Primary!, lds_detalle, 1, Primary!)

//// Se descartan los items que no tienen temporada o que estan en calidad 2
//lds_detalle.SetFilter("Trim(co_prepack) <> '' And co_calidad = 1")
//lds_detalle.Filter()
//lds_detalle.RowsDiscard( 1, lds_detalle.FilteredCount(), Filter!)


lds_eq_x_sku_exp = Create uo_dsbase
lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )

lds_cubicaje = Create uo_dsbase
lds_cubicaje.DataObject= 'd_gr_hallar_cubicaje'
lds_cubicaje.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())


lnvo_msn = Create n_cst_mensaje

/*
ca_surtido = Cantidad/Unidad de Empaque
--> Unidad Empaque*ca_surtido = cantidad
*/
li_retorno = 1
	
This.Of_Llenar_Sku( al_row, adw_detalle)
li_tipo = 1
ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
		This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
		This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, 0, li_tipo)

		
//// Se hace ordenamiento por referencia de venta y temporada
//lds_detalle.SetSort('co_fabrica_exp, co_linea_exp, co_ref_exp, co_talla_exp, co_color_exp, co_prepack, co_referencia, co_color')
//lds_detalle.Sort()
		
If ll_reg <= 0 Then
	lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
	lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
	lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
	lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
	lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
	lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
	lnvo_msn.icono = StopSign!
	
	If ll_reg = 0 Then
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro la equivalencia asociada a:', '')	
		This.item = adw_detalle.GetItemNumber( 1, 'item')
	Else
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar equivalencia asociada a:', lds_eq_x_sku_exp.is_sqlerrtext)
		This.item = adw_detalle.GetItemNumber( 1, 'item')
	End If
	li_retorno = -1
End If

// Se obtiene el cubicaje
ll_filas = lds_cubicaje.Of_Retrieve(This.il_co_fabrica_exp, This.il_co_linea_exp, Long(This.is_co_ref_exp), &
			Long(This.is_co_talla_exp), This.il_co_calidad, Long(This.is_co_color_exp) )
			
If ll_filas > 0 Then
	ll_uni_empaque	= lds_cubicaje.GetItemNumber(1,'ca_x_uempq_pd')
ElseIf ll_filas < 0 Then
	lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
	lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
	lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
	lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
	lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
	lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
	lnvo_msn.icono = StopSign!
	
	lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar el cubicaje de:', lds_cubicaje.is_sqlerrtext)
	This.item = adw_detalle.GetItemNumber( 1, 'item')

	li_retorno = -1
Else
	ll_uni_empaque = 1
End If	
ll_cantidad_esp = -1
ldc_escala_esp = -1

lds_eq_x_sku_exp.SetFilter('co_prepack		= "' + is_co_prepack_temporada + '"' )
lds_eq_x_sku_exp.Filter()

ll_item = 1
ll_fila = al_row + 1
If lds_eq_x_sku_exp.RowCount() > 0 Then
	// se toma la cantidad pedida
	//ll_cantidad = lds_detalle.GetItemNumber( al_row, 'ca_pedida')
	// se busca la definicion de la equivalencia
	
	If idc_ca_temporada = 0 Then
		// se toma la cantidad pedida
		ll_cantidad = adw_detalle.GetItemNumber( al_row, 'ca_pedida')		
		
		// se busca la definicion de la equivalencia
		ls_expresion = 'co_fabrica	= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
					'co_linea	 		= ' +	String(This.il_co_linea)	+ ' AND ' + &
					'co_referencia		= ' + String(This.il_co_referencia)	+ ' AND ' + &
					'co_talla			= ' + String(This.il_co_talla)+ ' AND ' + &
					'co_color			= ' + String(This.il_co_color) + ' AND ' + &	 
					'co_prepack		= "' + is_co_prepack + '"' 
		
		ll_row_find = lds_eq_x_sku_exp.Find( ls_expresion, 1, lds_eq_x_sku_exp.RowCount())			
		If ll_row_find > 0 Then
			ldc_ca_surtida = lds_eq_x_sku_exp.GetItemNumber( ll_row_find, 'ca_surtido')

			// se calcula la cantidad de empaque
			ll_cantidad_empq = ldc_ca_surtida * ll_uni_empaque
			
			ldc_porcentaje = ll_cantidad_empq / ll_uni_empaque
			
			idc_ca_temporada = ll_cantidad / ldc_porcentaje
			
			
		End If
		
	End If
	
				
	For ll_row = 1 To lds_eq_x_sku_exp.RowCount()
		// se toma la composicion de produccion
		ldc_ca_surtida = lds_eq_x_sku_exp.GetItemNumber( ll_row, 'ca_surtido')
		
		ll_cantidad_empq = ldc_ca_surtida*ll_uni_empaque
		
		ldc_porcentaje = ll_cantidad_empq / ll_uni_empaque
		
		// se calcula la cantidad de empaque
		ll_cantidad_esp = ldc_porcentaje * idc_ca_temporada			
		
		This.il_co_fabrica	= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_fabrica")
		This.il_co_linea		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_linea")
		This.il_co_referencia= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_referencia")
		This.il_co_talla		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_talla")
		This.il_co_calidad	= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_calidad")
		This.il_co_color		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_color")
		
		ls_expresion = 'co_fabrica	= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
			'co_linea	 		= ' +	String(This.il_co_linea)	+ ' AND ' + &
			'co_referencia		= ' + String(This.il_co_referencia)	+ ' AND ' + &
			'co_talla			= ' + String(This.il_co_talla)+ ' AND ' + &
			'co_calidad			= ' + String(This.il_co_calidad)+ ' AND ' + &
			'co_color			= ' + String(This.il_co_color) + ' AND ' + &	 
			'co_prepack		= "' + is_co_prepack + '"' 
			
		ll_row_find = adw_detalle.Find( ls_expresion, 1, adw_detalle.RowCount())			
		
		If ll_row_find > 0 Then
			ll_row2 = ll_row_find
		Else
			ll_find = adw_detalle.Find('item > ' + String(ll_item), 1, adw_detalle.RowCount())
			Do While ll_find > 0
				ll_item = adw_detalle.GetItemNumber( ll_find, 'item')
				ll_find = adw_detalle.Find('item > ' + String(ll_item), 1, adw_detalle.RowCount() + 1)
			Loop
			ll_item ++
			
			
			// se copia la informacion de la referencia
			adw_detalle.RowsCopy( al_row, al_row, Primary!, adw_detalle, ll_fila, Primary!)			
			ll_row2 = ll_fila
			ll_fila ++
			
			
			adw_detalle.SetItem( ll_row2, 'item', ll_item)

			// se modifican los campos de la equivalencia
			adw_detalle.SetItem( ll_row2, 'co_fabrica',	lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_fabrica'))
			adw_detalle.SetItem( ll_row2, 'co_linea',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_linea'))
			adw_detalle.SetItem( ll_row2, 'co_referencia',lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_referencia'))
			adw_detalle.SetItem( ll_row2, 'co_talla',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_talla'))
			adw_detalle.SetItem( ll_row2, 'co_color',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_color'))
		End If		
		
		If adw_detalle.GetItemNumber( ll_row2, 'ca_pedida') <> ll_cantidad_esp Then
			adw_detalle.SetItem( ll_row2, 'ca_pedida', ll_cantidad_esp)
		End If
	Next
End If


Destroy lds_eq_x_sku_exp
//Destroy lds_detalle
Destroy lds_cubicaje

Destroy lnvo_msn

Return li_retorno


end function

public function long of_crear_temporada (long al_row, datastore ads_detalle);/*
Funcion para validar la referencia de venta en las temporadas definidas.
*/

Long li_tipo, li_retorno, li_creados
Long ll_row, ll_fila, ll_row_find, ll_find, ll_uni_empaque, ll_filas, ll_reg, ll_cantidad, ll_cantidad_esp, ll_cantidad_empq, ll_row2, ll_item
String ls_expresion, ls_sku_vta
Decimal ldc_ca_surtida, ldc_escala_esp, ldc_porcentaje
uo_dsbase lds_eq_x_sku_exp, lds_cubicaje//, lds_detalle
s_base_parametros lsp_parametros
n_cst_mensaje lnvo_msn

lds_eq_x_sku_exp = Create uo_dsbase
lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )

lds_cubicaje = Create uo_dsbase
lds_cubicaje.DataObject= 'd_gr_hallar_cubicaje'
lds_cubicaje.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())


lnvo_msn = Create n_cst_mensaje

/*
ca_surtido = Cantidad/Unidad de Empaque
--> Unidad Empaque*ca_surtido = cantidad
*/
li_retorno = 1
	
This.Of_Llenar_Sku( al_row, ads_detalle)
li_tipo = 1
ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
		This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
		This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, 0, li_tipo)

If ll_reg <= 0 Then
	lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
	lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
	lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
	lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
	lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
	lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
	lnvo_msn.icono = StopSign!
	
	If ll_reg = 0 Then
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro la equivalencia asociada a:', '')	
		This.item = ads_detalle.GetItemNumber( 1, 'item')
	Else
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar equivalencia asociada a:', lds_eq_x_sku_exp.is_sqlerrtext)
		This.item = ads_detalle.GetItemNumber( 1, 'item')
	End If
	li_retorno = -1
End If

// Se obtiene el cubicaje
ll_filas = lds_cubicaje.Of_Retrieve(This.il_co_fabrica_exp, This.il_co_linea_exp, Long(This.is_co_ref_exp), &
			Long(This.is_co_talla_exp), This.il_co_calidad, Long(This.is_co_color_exp) )
			
If ll_filas > 0 Then
	ll_uni_empaque	= lds_cubicaje.GetItemNumber(1,'ca_x_uempq_pd')
ElseIf ll_filas < 0 Then
	lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
	lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
	lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
	lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
	lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
	lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
	lnvo_msn.icono = StopSign!
	
	lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar el cubicaje de:', lds_cubicaje.is_sqlerrtext)
	This.item = ads_detalle.GetItemNumber( 1, 'item')

	li_retorno = -1
Else
	ll_uni_empaque = 1
End If

ll_cantidad_esp = -1
ldc_escala_esp = -1

lds_eq_x_sku_exp.SetFilter('co_prepack		= "' + is_co_prepack_temporada + '"' )
lds_eq_x_sku_exp.Filter()

ll_item = 1
ll_fila = al_row + 1
If lds_eq_x_sku_exp.RowCount() > 0 Then
	li_creados = 0
	// se busca la definicion de la equivalencia
	
	If idc_ca_temporada = 0 Then
		// se toma la cantidad pedida
		ll_cantidad = ads_detalle.GetItemNumber( al_row, 'ca_pedida')		
		
		// se busca la definicion de la equivalencia
		ls_expresion = 'co_fabrica	= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
					'co_linea	 		= ' +	String(This.il_co_linea)	+ ' AND ' + &
					'co_referencia		= ' + String(This.il_co_referencia)	+ ' AND ' + &
					'co_talla			= ' + String(This.il_co_talla)+ ' AND ' + &
					'co_color			= ' + String(This.il_co_color) + ' AND ' + &	 
					'co_prepack		= "' + is_co_prepack + '"' 
		
		ll_row_find = lds_eq_x_sku_exp.Find( ls_expresion, 1, lds_eq_x_sku_exp.RowCount())			
		If ll_row_find > 0 Then
			ldc_ca_surtida = lds_eq_x_sku_exp.GetItemNumber( ll_row_find, 'ca_surtido')

			// se calcula la cantidad de empaque
			ll_cantidad_empq = ldc_ca_surtida * ll_uni_empaque
			
			ldc_porcentaje = ll_cantidad_empq / ll_uni_empaque
			
			idc_ca_temporada = ll_cantidad / ldc_porcentaje
			
			
		End If
		
	End If
	
				
	For ll_row = 1 To lds_eq_x_sku_exp.RowCount()
		// se toma la composicion de produccion
		ldc_ca_surtida = lds_eq_x_sku_exp.GetItemNumber( ll_row, 'ca_surtido')
		
		ll_cantidad_empq = ldc_ca_surtida*ll_uni_empaque
		
		ldc_porcentaje = ll_cantidad_empq / ll_uni_empaque
		
		// se calcula la cantidad de empaque
		ll_cantidad_esp = ldc_porcentaje * idc_ca_temporada			
		
		This.il_co_fabrica	= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_fabrica")
		This.il_co_linea		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_linea")
		This.il_co_referencia= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_referencia")
		This.il_co_talla		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_talla")
		This.il_co_calidad	= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_calidad")
		This.il_co_color		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_color")
		
		ls_expresion = is_nombre_po + ' = "' + This.is_po + '" AND ' + &
			'nu_cut			= "' + This.is_nu_cut + '" AND ' + &
			'co_fabrica		= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
			'co_linea	 	= ' +	String(This.il_co_linea)	+ ' AND ' + &
			'co_referencia	= ' + String(This.il_co_referencia)	+ ' AND ' + &
			'co_talla		= ' + String(This.il_co_talla)+ ' AND ' + &
			'co_calidad		= ' + String(This.il_co_calidad)+ ' AND ' + &
			'co_color		= ' + String(This.il_co_color) + ' AND ' + &	 
			'co_prepack		= "' + is_co_prepack + '"' 
			
		ll_row_find = ads_detalle.Find( ls_expresion, 1, ads_detalle.RowCount())			
		
		If ll_row_find > 0 Then
			ll_row2 = ll_row_find
		Else
			li_creados ++
			ll_find = ads_detalle.Find('item > ' + String(ll_item), 1, ads_detalle.RowCount())
			Do While ll_find > 0
				ll_item = ads_detalle.GetItemNumber( ll_find, 'item')
				ll_find = ads_detalle.Find('item > ' + String(ll_item), 1, ads_detalle.RowCount() + 1)
			Loop
			ll_item ++
			
			
			// se copia la informacion de la referencia
			ads_detalle.RowsCopy( al_row, al_row, Primary!, ads_detalle, ll_fila, Primary!)			
			ll_row2 = ll_fila
			ll_fila ++
			
			
			ads_detalle.SetItem( ll_row2, 'item', ll_item)

			// se modifican los campos de la equivalencia
			ads_detalle.SetItem( ll_row2, 'co_fabrica',	lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_fabrica'))
			ads_detalle.SetItem( ll_row2, 'co_linea',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_linea'))
			ads_detalle.SetItem( ll_row2, 'co_referencia',lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_referencia'))
			ads_detalle.SetItem( ll_row2, 'co_talla',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_talla'))
			ads_detalle.SetItem( ll_row2, 'co_color',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_color'))
		End If		
		
		If ads_detalle.GetItemNumber( ll_row2, 'ca_pedida') <> ll_cantidad_esp Then
			ads_detalle.SetItem( ll_row2, 'ca_pedida', ll_cantidad_esp)
		End If
	Next
End If


Destroy lds_eq_x_sku_exp
Destroy lds_cubicaje
Destroy lnvo_msn

If li_retorno > 0 Then
	li_retorno = li_creados 
End If

Return li_retorno


end function

public function long of_llenar_sku (long al_row, any aa_dt_detalle, string as_tipo);/* 
Funci$$HEX1$$f300$$ENDHEX$$n para cargar el sku desde lds_detalle fila al_row
Parametros:
al_row: fila a tomar
aa_dt_detalle: dw o ds del detalle
as_tipo: dw - Datawindow, ds datastore
*/

Long li_retorno
uo_dsbase lds_detalle
DataWindow ldw_detalle

If Trim(as_tipo) = 'dw' Then
	ldw_detalle = aa_dt_detalle
	
	lds_detalle = Create uo_dsbase
	lds_detalle.DataObject = ldw_detalle.DataObject
	ldw_detalle.ShareData (lds_detalle)	
	
	SetNull(ldw_detalle)
Else
	lds_detalle = aa_dt_detalle
End If

If lds_detalle.RowCount() = 0 Then
	This.Of_Limpiar_Sku()
	Return -1	
End If
If lds_detalle.Describe( is_nombre_po + '.key') <> '!' Then
	This.is_po	= Trim (lds_detalle.GetItemString(al_row, is_nombre_po))	
End If


This.is_nu_cut 		= Trim (lds_detalle.GetItemString(al_row,"nu_cut"))

This.il_co_fabrica_exp = lds_detalle.GetItemNumber(al_row,"co_fabrica_exp")
This.il_co_linea_exp	= lds_detalle.GetItemNumber(al_row,"co_linea_exp")
This.is_co_ref_exp	= Trim (lds_detalle.GetItemString(al_row,"co_ref_exp"))
This.is_co_talla_exp	= Trim (lds_detalle.GetItemString(al_row,"co_talla_exp"))
This.il_co_calidad	= lds_detalle.GetItemNumber(al_row,"co_calidad")
This.is_co_color_exp	= Trim (lds_detalle.GetItemString(al_row,"co_color_exp"))

This.il_co_fabrica	= lds_detalle.GetItemNumber(al_row,"co_fabrica")
This.il_co_linea		= lds_detalle.GetItemNumber(al_row,"co_linea")
This.il_co_referencia= lds_detalle.GetItemNumber(al_row,"co_referencia")
This.il_co_talla		= lds_detalle.GetItemNumber(al_row,"co_talla")
This.il_co_calidad	= lds_detalle.GetItemNumber(al_row,"co_calidad")
This.il_co_color		= lds_detalle.GetItemNumber(al_row,"co_color")

This.is_upc_barcode	= Trim(lds_detalle.GetItemString(al_row,"upc_barcode"))
This.is_co_prepack	= Trim(lds_detalle.GetItemString(al_row,"co_prepack"))

If Trim(as_tipo) = 'dw' Then
	lds_detalle.ShareDataOff()
Else
	SetNull(lds_detalle)
End If
Destroy lds_detalle
	

Return 1
end function

public function long of_crear_temporada (long al_row, any aa_dt_detalle, string as_tipo);
/*
Funcion para validar la referencia de venta en las temporadas definidas.
*/

Long li_tipo, li_retorno, li_creados, li_sw_conjunto
Long ll_row, ll_fila, ll_row_find, ll_find, ll_find2, ll_uni_empaque, ll_filas, ll_reg 
Long ll_cantidad, ll_cantidad_esp, ll_cantidad_empq, ll_row2, ll_item, ll_cant_total, ll_unidades
String ls_expresion, ls_sku_vta
Decimal ldc_ca_surtido, ldc_escala_esp, ldc_porcentaje, ldc_cantidad
uo_dsbase lds_eq_x_sku_exp, lds_cubicaje//, lds_detalle
s_base_parametros lsp_parametros
n_cst_mensaje lnvo_msn

uo_dsbase lds_detalle
DataWindow ldw_detalle


If Trim(is_co_prepack_temporada) = '' Or IsNull(is_co_prepack_temporada) Then
	Return 0
End If

If Trim(as_tipo) = 'dw' Then
	ldw_detalle = aa_dt_detalle
	
	lds_detalle = Create uo_dsbase
	lds_detalle.DataObject = ldw_detalle.DataObject
	ldw_detalle.ShareData (lds_detalle)	
	
	SetNull(ldw_detalle)
Else
	lds_detalle = aa_dt_detalle
End If


lds_eq_x_sku_exp = Create uo_dsbase
lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )

lds_cubicaje = Create uo_dsbase
lds_cubicaje.DataObject= 'd_gr_hallar_cubicaje'
lds_cubicaje.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())


lnvo_msn = Create n_cst_mensaje
/*
ca_surtido = Cantidad/Unidad de Empaque
--> Unidad Empaque*ca_surtido = cantidad
*/
li_retorno = 1
	
This.Of_Llenar_Sku( al_row, lds_detalle, 'ds')

// se obtiene la definicion de la equivalencia
If is_tipo_pedido = 'NA' Then
	li_tipo = 1
Else
	li_tipo = 2
End If

ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
		This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
		This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, 0, li_tipo)
// se valida si hubo error
If ll_reg <= 0 Then
	lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
	lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
	lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
	lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
	lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
	lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
	lnvo_msn.icono = StopSign!
	
	If ll_reg = 0 Then
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro la equivalencia asociada a:', '')	
		This.item = lds_detalle.GetItemNumber( 1, 'item')
	Else
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar equivalencia asociada a:', lds_eq_x_sku_exp.is_sqlerrtext)
		This.item = lds_detalle.GetItemNumber( 1, 'item')
	End If
	li_retorno = -1
	Return li_retorno
End If

lds_eq_x_sku_exp.SetFilter('co_prepack		= "' + is_co_prepack_temporada + '"' )
lds_eq_x_sku_exp.Filter()
//NACIONAL
If li_tipo = 1 Then
	// Se obtiene el cubicaje
	ll_filas = lds_cubicaje.Of_Retrieve(This.il_co_fabrica_exp, This.il_co_linea_exp, Long(This.is_co_ref_exp), &
				Long(This.is_co_talla_exp), This.il_co_calidad, Long(This.is_co_color_exp) )
				
	If ll_filas > 0 Then
		ll_uni_empaque	= lds_cubicaje.GetItemNumber(1,'ca_x_uempq_pd')
		If ll_uni_empaque = 0 Then
			lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
			lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
			lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
			lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
			lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
			lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
			lnvo_msn.Of_Set_Campo('U. Empq.', ll_uni_empaque)
			
			lnvo_msn.icono = StopSign!
			
			lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Cubicaje No Permitido, La U. Empq. debe ser > 0:', lds_cubicaje.is_sqlerrtext)
			This.item = lds_detalle.GetItemNumber( 1, 'item')
			
			li_retorno = -1
			Return li_retorno
		End If
	ElseIf ll_filas < 0 Then
		lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
		lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
		lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
		lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
		lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
		lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
		lnvo_msn.icono = StopSign!
		
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar el cubicaje de:', lds_cubicaje.is_sqlerrtext)
		This.item = lds_detalle.GetItemNumber( 1, 'item')
		
		li_retorno = -1
		Return li_retorno
	Else
		ll_uni_empaque = 1
	End If
Else
	If lds_eq_x_sku_exp.RowCount() > 1 Then
		li_sw_conjunto = lds_eq_x_sku_exp.GetItemNumber(1, "sw_conjunto")	
		
		ll_cant_total = 0
		For ll_row = 1 To lds_eq_x_sku_exp.RowCount()
			ll_cant_total += lds_eq_x_sku_exp.GetItemNumber(ll_row, 'ca_surtido')			
		Next
		
		If ll_cant_total = 0 Then
			ll_cant_total = 1
		End If
		
		If li_sw_conjunto = 1 Then
			ll_uni_empaque = 1	
		Else			
			For ll_row = 1 To lds_eq_x_sku_exp.RowCount()
				ldc_ca_surtido = lds_eq_x_sku_exp.GetItemNumber(ll_row, 'ca_surtido')
				ldc_ca_surtido = ldc_ca_surtido / ll_cant_total
				lds_eq_x_sku_exp.SetItem(ll_row, 'ca_surtido', ldc_ca_surtido)
			Next
			ll_uni_empaque = ll_cant_total
		End If
	ElseIf lds_eq_x_sku_exp.RowCount() = 1 Then
		Destroy lds_eq_x_sku_exp
		Destroy lds_cubicaje
		Destroy lnvo_msn
		Return 0
	End If
End If



ll_cantidad_esp = -1
ldc_escala_esp = -1

ll_item = 1
ll_fila = al_row + 1
If lds_eq_x_sku_exp.RowCount() > 0 Then
	
	li_creados = 0
	// se busca la definicion de la equivalencia
	
	If idc_ca_temporada = 0 Then
		// se toma la cantidad pedida
		ll_cantidad = lds_detalle.GetItemNumber( al_row, 'ca_pedida')		
		
		// se busca la definicion de la equivalencia
		ls_expresion = 'co_fabrica	= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
					'co_linea	 		= ' +	String(This.il_co_linea)	+ ' AND ' + &
					'co_referencia		= ' + String(This.il_co_referencia)	+ ' AND ' + &
					'co_talla			= ' + String(This.il_co_talla)+ ' AND ' + &
					'co_color			= ' + String(This.il_co_color) + ' AND ' + &	 
					'co_prepack		= "' + is_co_prepack_temporada + '"' 
		
		ll_row_find = lds_eq_x_sku_exp.Find( ls_expresion, 1, lds_eq_x_sku_exp.RowCount())			
		If ll_row_find > 0 Then
			ldc_ca_surtido = lds_eq_x_sku_exp.GetItemNumber( ll_row_find, 'ca_surtido')

			// se calcula la cantidad de empaque
			ll_cantidad_empq = ldc_ca_surtido * ll_uni_empaque
			// se calcula el porcetaje real
			ldc_porcentaje = ll_cantidad_empq / ll_uni_empaque			
			// se obtiene la cantidad de la temporada
			idc_ca_temporada = ll_cantidad / ldc_porcentaje			
			
		End If
	Else
		
//		If  Mod( idc_ca_temporada, ll_uni_empaque) <> 0 Then			
//			
//		End If
		
	End If
	
	
	
				
	For ll_row = 1 To lds_eq_x_sku_exp.RowCount()
		// se toma la composicion de produccion
		ldc_ca_surtido = lds_eq_x_sku_exp.GetItemNumber( ll_row, 'ca_surtido')
		// se calcula la cantidad de empaque
		ll_cantidad_empq = ldc_ca_surtido*ll_uni_empaque
		// se calcula el porcetaje real
		ldc_porcentaje = ll_cantidad_empq / ll_uni_empaque
		
		// se calcula la cantidad de empaque
		ll_cantidad_esp = ldc_porcentaje * idc_ca_temporada			
		// Se toma el sku de produccion
		This.il_co_fabrica	= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_fabrica")
		This.il_co_linea		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_linea")
		This.il_co_referencia= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_referencia")
		This.il_co_talla		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_talla")
		This.il_co_calidad	= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_calidad")
		This.il_co_color		= lds_eq_x_sku_exp.GetItemNumber(ll_row,"co_color")
		
		
		// Se busca si existe el sku de producion para el sku de venta en dicha temporada
		ls_expresion = is_nombre_po + ' = "' + This.is_po + '" AND ' + &
			'nu_cut			= "' + This.is_nu_cut + '" AND ' + &
			'co_fabrica		= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
			'co_linea	 	= ' +	String(This.il_co_linea)	+ ' AND ' + &
			'co_referencia	= ' + String(This.il_co_referencia)	+ ' AND ' + &
			'co_talla		= ' + String(This.il_co_talla)+ ' AND ' + &
			'co_calidad		= ' + String(This.il_co_calidad)+ ' AND ' + &
			'co_color		= ' + String(This.il_co_color) + ' AND ' + &	 
			'co_prepack		= "' + is_co_prepack_temporada + '" AND ' + &
			'co_fabrica_exp= ' +	String(This.il_co_fabrica_exp)	+ ' AND ' + &
			'co_linea_exp 	= ' +	String(This.il_co_linea_exp)	+ ' AND ' + &
			'co_ref_exp 	= "' + String(This.is_co_ref_exp)	+ '" AND ' + &
			'co_talla_exp	= "' + String(This.is_co_talla_exp)+ '" AND ' + &
			'co_calidad		= ' + String(This.il_co_calidad)	+ ' AND ' + &
			'co_color_exp	= "' + String(This.is_co_color_exp)+ '"'
			
		ll_row_find = lds_detalle.Find( ls_expresion, 1, lds_detalle.RowCount())			
		
		// Si la encontra verifica que no este repetido el sku de produccion
		If ll_row_find > 0 Then
			ll_row2 = ll_row_find
			ll_find2 = This.Of_Detectar_Existe( lds_detalle.GetItemNumber(ll_row2, 'item'), lds_detalle, 'ds')
		Else
			ls_expresion = is_nombre_po + ' = "' + This.is_po + '" AND ' + &
				'nu_cut			= "' + This.is_nu_cut + '" AND ' + &
				'co_fabrica		= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
				'co_linea	 	= ' +	String(This.il_co_linea)	+ ' AND ' + &
				'co_referencia	= ' + String(This.il_co_referencia)	+ ' AND ' + &
				'co_talla		= ' + String(This.il_co_talla)+ ' AND ' + &
				'co_calidad		= ' + String(This.il_co_calidad)+ ' AND ' + &
				'co_color		= ' + String(This.il_co_color) + ' AND ' + &	 
				'( IsNull(co_prepack) Or Trim(co_prepack) = "0") AND ' + &
				'co_fabrica_exp= ' +	String(This.il_co_fabrica_exp)	+ ' AND ' + &
				'co_linea_exp 	= ' +	String(This.il_co_linea_exp)	+ ' AND ' + &
				'co_ref_exp 	= "' + String(This.is_co_ref_exp)	+ '" AND ' + &
				'co_talla_exp	= "' + String(This.is_co_talla_exp)+ '" AND ' + &
				'co_calidad		= ' + String(This.il_co_calidad)	+ ' AND ' + &
				'co_color_exp	= "' + String(This.is_co_color_exp)+ '"'					
			ll_row_find = lds_detalle.Find( ls_expresion, 1, lds_detalle.RowCount())
			
			If ll_row_find > 0 Then				
				ll_find2 = This.Of_Detectar_Existe( lds_detalle.GetItemNumber( ll_row_find, 'item'), lds_detalle, 'ds')
				If ll_find2 = 0 Then
					lds_detalle.SetItem( ll_row_find, 'co_prepack', is_co_prepack_temporada)
				End If
			Else
				ll_find2 = This.Of_Detectar_Existe( 0, lds_detalle, 'ds')
			End If

		End If
		If ll_find2 > 0 Then
			lnvo_msn.Of_Set_Campo('Fab.', This.il_co_fabrica)
			lnvo_msn.Of_Set_Campo('Lin.', This.il_co_linea)
			lnvo_msn.Of_Set_Campo('Referen.', This.il_co_referencia)
			lnvo_msn.Of_Set_Campo('Talla', This.il_co_talla)
			lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
			lnvo_msn.Of_Set_Campo('Color', This.il_co_color)
			lnvo_msn.Of_Set_Campo('P.O.', This.is_po)
			lnvo_msn.Of_Set_Campo('Cut', This.is_nu_cut)
			
			lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ya Existe la referencia de produccion', '')
			
			li_retorno = -1
			
			Exit
			
		ElseIf ll_row_find = 0 Then
			li_creados ++
			ll_find = lds_detalle.Find('item > ' + String(ll_item), 1, lds_detalle.RowCount())
			Do While ll_find > 0
				ll_item = lds_detalle.GetItemNumber( ll_find, 'item')
				ll_find = lds_detalle.Find('item > ' + String(ll_item), 1, lds_detalle.RowCount() + 1)
			Loop
			ll_item ++
			
			
			// se copia la informacion de la referencia
			lds_detalle.RowsCopy( al_row, al_row, Primary!, lds_detalle, ll_fila, Primary!)			
			ll_row2 = ll_fila
			ll_fila ++
			
			
			lds_detalle.SetItem( ll_row2, 'item', ll_item)

			// se modifican los campos de la equivalencia
			lds_detalle.SetItem( ll_row2, 'co_fabrica',	lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_fabrica'))
			lds_detalle.SetItem( ll_row2, 'co_linea',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_linea'))
			lds_detalle.SetItem( ll_row2, 'co_referencia',lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_referencia'))
			lds_detalle.SetItem( ll_row2, 'co_talla',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_talla'))
			lds_detalle.SetItem( ll_row2, 'co_color',		lds_eq_x_sku_exp.GetItemNumber( ll_row, 'co_color'))
			
			// Se valida la referencia en h_preref
			li_retorno = This.of_validar_ref_nal()
			If li_retorno = 1 Then
				// Se valida en el maestro de eans
				li_retorno = This.of_validar_ean()
			End If
			
			If li_retorno < 0 Then
				Exit
			End If
			
			If lds_detalle.Describe( 'de_referencia.key') <> '!' Then
				This.Of_Validar_Ref_Nal()
				lds_detalle.SetItem( ll_row2, 'de_referencia', This.is_de_referencia)
			End If
		Else
			If ll_row = 1 Then
				
			End If
		End If		
		
		If lds_detalle.GetItemNumber( ll_row2, 'ca_pedida') <> ll_cantidad_esp Then
			lds_detalle.SetItem( ll_row2, 'ca_pedida', ll_cantidad_esp)
		End If
	Next
End If

If li_retorno < 0 Then
	For ll_row2 = ll_row + 1 To ll_row + li_creados
		lds_detalle.DeleteRow(ll_row + 1)			
	Next
End If

Destroy lds_eq_x_sku_exp
Destroy lds_cubicaje
Destroy lnvo_msn

If li_retorno > 0 Then
	li_retorno = li_creados 
End If

If Trim(as_tipo) = 'dw' Then
	lds_detalle.ShareDataOff()
Else
	SetNull(lds_detalle)
End If

Destroy lds_detalle

Return li_retorno
end function

public function long of_detectar_existe (long al_item, any aa_dt_detalle, string as_tipo);Long ll_row
String ls_expresion				 
uo_dsbase lds_detalle
DataWindow ldw_detalle

If Trim(as_tipo) = 'dw' Then
	ldw_detalle = aa_dt_detalle
	
	lds_detalle = Create uo_dsbase
	lds_detalle.DataObject = ldw_detalle.DataObject
	ldw_detalle.ShareData (lds_detalle)	
	
	SetNull(ldw_detalle)
Else
	lds_detalle = aa_dt_detalle
End If

If lds_detalle.RowCount() = 0 Then
	This.Of_Limpiar_Sku()
	Return -1	
End If


If lds_detalle.Describe( is_nombre_po + '.key') <> '!' Then
	If Len(Trim(This.is_po) ) > 0 Then
		ls_expresion = is_nombre_po + ' = "' + This.is_po	+ '" AND '
	End If
End If

// Se hace una busqueda verificando que la referencia no este duplicada

ls_expresion = ls_expresion + 'co_fabrica			= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
					'co_linea	 		= ' +	String(This.il_co_linea)	+ ' AND ' + &
					'co_referencia		= ' + String(This.il_co_referencia)	+ ' AND ' + &
					'co_talla			= ' + String(This.il_co_talla)+ ' AND ' + &
					'co_calidad			= ' + String(This.il_co_calidad)	+ ' AND ' + &
					'co_color			= ' + String(This.il_co_color)	+ ' AND ' + &
					'nu_cut				= "' + is_nu_cut + '"'
					
If al_item > 0 Then
	ls_expresion += ' AND item	<> '+ String(al_item) 
End If

ll_row = lds_detalle.Find(ls_expresion, 1, lds_detalle.RowCount() + 1)


If Trim(as_tipo) = 'dw' Then
	lds_detalle.ShareDataOff()
Else
	SetNull(lds_detalle)
End If

Destroy lds_detalle

Return ll_row

end function

public function long of_validar_temporada (any aa_dt_detalle, string as_tipo);/*
Funcion para validar la referencia de venta en las temporadas definidas.


*/

Long li_tipo, li_retorno
Long ll_row, ll_find, ll_row_find, ll_uni_empaque, ll_filas, ll_reg, ll_cantidad, ll_cantidad_esp, ll_cantidad_empq, ll_cant_eq
String ls_expresion, ls_sku_vta
Decimal ldc_ca_surtida, ldc_escala_esp
Date ld_fe_entrega
uo_dsbase lds_eq_x_sku_exp, lds_cubicaje
s_base_parametros lsp_parametros
n_cst_mensaje lnvo_msn


uo_dsbase lds_detalle, lds_detalle_original
DataWindow ldw_detalle


lds_detalle = Create uo_dsbase

If Trim(as_tipo) = 'dw' Then
	
	
	ldw_detalle = aa_dt_detalle
	
	
	lds_detalle.DataObject = ldw_detalle.DataObject
	ldw_detalle.RowsCopy( 1, ldw_detalle.RowCount(), Primary!, lds_detalle, 1, Primary!)	
	
Else
	lds_detalle_original = aa_dt_detalle
	lds_detalle.DataObject = lds_detalle_original.DataObject
	
	lds_detalle_original.RowsCopy( 1, lds_detalle_original.RowCount(), Primary!, lds_detalle, 1, Primary!)
End If


// Se descartan los items que no tienen temporada o que estan en calidad 2
lds_detalle.SetFilter("Trim(co_prepack) <> '' And co_calidad = 1")
lds_detalle.Filter()


If lds_detalle.RowCount() = 0 Then Return 0

lds_detalle.RowsDiscard( 1, lds_detalle.FilteredCount(), Filter!)
// Se hace ordenamiento por referencia de venta y temporada
lds_detalle.SetSort('co_fabrica_exp, co_linea_exp, co_ref_exp, co_talla_exp, co_color_exp, co_prepack, co_referencia, co_color')
lds_detalle.Sort()


lds_eq_x_sku_exp = Create uo_dsbase
lds_eq_x_sku_exp.Dataobject  = "d_gr_equivalencias_x_sku_vta_nuevo" 
lds_eq_x_sku_exp.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ) )

lds_cubicaje = Create uo_dsbase
lds_cubicaje.DataObject= 'd_gr_hallar_cubicaje'
lds_cubicaje.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())


lnvo_msn = Create n_cst_mensaje

If IsNull(This.il_cliente) Then
	This.il_cliente = 0
End If 

If IsNull(This.il_sucursal) Then
	This.il_sucursal = 0
End If 

// se obtiene la definicion de la equivalencia
If is_tipo_pedido = 'NA' Then
	li_tipo = 1
Else
	li_tipo = 2
End If

/*
ca_surtido = Cantidad/Unidad de Empaque
--> Unidad Empaque*ca_surtido = cantidad
*/
li_retorno = 1
// Se recorre el ds con los detalle para validar la temporada
Do While lds_detalle.RowCount() > 0
	
	lds_eq_x_sku_exp.SetFilter( '')
	lds_eq_x_sku_exp.Filter( )
	
	This.Of_Llenar_Sku( 1, lds_detalle)
	// se filtran las referencias que componen la refenrencia de vta.
	ls_sku_vta=	'co_fabrica_exp	= ' +	String(This.il_co_fabrica_exp)	+ ' AND ' + &
					'co_linea_exp	= ' +	String(This.il_co_linea_exp)	+ ' AND ' + &
					'co_ref_exp 	= "' + String(This.is_co_ref_exp)	+ '" AND ' + &
					'co_talla_exp	= "' + String(This.is_co_talla_exp)+ '" AND ' + &
					'co_calidad		= ' + String(This.il_co_calidad)	+ ' AND ' + &
					'co_color_exp	= "' + String(This.is_co_color_exp) + '"'
	
	ls_expresion = ls_sku_vta + ' AND ' + &
					is_nombre_po +'= "' + is_po + '" AND ' + &
					'nu_cut			= "' + is_nu_cut + '" AND ' + &
					'co_prepack		= "' + is_co_prepack + '"' 
	
	lds_detalle.SetFilter(ls_expresion)
	lds_detalle.Filter()	
	// Se Carga la definicion de la equivalencia
	ll_reg = lds_eq_x_sku_exp.Of_Retrieve(This.il_cliente, This.il_sucursal, &
			This.il_co_fabrica_exp, This.il_co_linea_exp,This.is_co_ref_exp, &
			This.is_co_talla_exp, This.is_co_color_exp, This.il_co_calidad, 0, 0, li_tipo)
	If ll_reg <= 0 Then
		lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
		lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
		lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
		lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
		lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
		lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
		lnvo_msn.icono = StopSign!
		
		If ll_reg = 0 Then
			lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se encontro la equivalencia asociada a:', '')	
			This.item = lds_detalle.GetItemNumber( 1, 'item')
		Else
			lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al consultar equivalencia asociada a:', lds_eq_x_sku_exp.is_sqlerrtext)
			This.item = lds_detalle.GetItemNumber( 1, 'item')
		End If
		li_retorno = -1
		Exit
	End If
	
	lds_eq_x_sku_exp.SetFilter( 'co_prepack = "' + This.is_co_prepack + '"')
	lds_eq_x_sku_exp.Filter( )
	

	// Se obtiene el cubicaje
	ll_filas = lds_cubicaje.Of_Retrieve(This.il_co_fabrica_exp, This.il_co_linea_exp, Long(This.is_co_ref_exp), &
				Long(This.is_co_talla_exp), This.il_co_calidad, Long(This.is_co_color_exp) )
				
	If ll_filas > 0 Then
		ll_uni_empaque	= lds_cubicaje.GetItemNumber(1,'ca_x_uempq_pd')
	Else
		ll_uni_empaque = 1
	End If	
	ll_cantidad_esp = -1
	ldc_escala_esp = -1
	ll_cant_eq = 0
	
	// Se hace la validacion de las unidades que debe tener las referencias de produccion para la referencia de vta
	For ll_row = 1 To lds_detalle.RowCount()
		If ll_row = 1 Then
			ld_fe_entrega = lds_detalle.GetItemDate( ll_row, 'fe_entrega')
		Else
			If ld_fe_entrega = lds_detalle.GetItemDate( ll_row, 'fe_entrega') Then
			Else
				lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
				lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
				lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
				lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
				lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
				lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
				lnvo_msn.Of_Set_Campo('Fecha 1', ld_fe_entrega)
				lnvo_msn.Of_Set_Campo('~tFecha 2', lds_detalle.GetItemDate( ll_row, 'fe_entrega'))				
				lnvo_msn.icono = StopSign!
				
				lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Las fechas de entrega de la referencia son diferentes', '')
				
				This.item = lds_detalle.GetItemNumber( 1, 'item')
				
				li_retorno = -1
				Exit
			End If
		End If
		
		// se llena el sku
		This.Of_Llenar_Sku( ll_row, lds_detalle)
		// se toma la cantidad pedida
		ll_cantidad = lds_detalle.GetItemNumber( ll_row, 'ca_pedida')
		// se busca la definicion de la equivalencia
		ls_expresion = 'co_fabrica	= ' +	String(This.il_co_fabrica)	+ ' AND ' + &
					'co_linea	 		= ' +	String(This.il_co_linea)	+ ' AND ' + &
					'co_referencia		= ' + String(This.il_co_referencia)	+ ' AND ' + &
					'co_talla			= ' + String(This.il_co_talla)+ ' AND ' + &
					'co_color			= ' + String(This.il_co_color) + ' AND ' + &	 
					'co_prepack		= "' + is_co_prepack + '"' 
		
		ll_row_find = lds_eq_x_sku_exp.Find( ls_expresion, 1, lds_eq_x_sku_exp.RowCount())			
		If ll_row_find > 0 Then
			ll_cant_eq ++
			
			// se toma la composicion de produccion
			ldc_ca_surtida = lds_eq_x_sku_exp.GetItemNumber( ll_row_find, 'ca_surtido')
			If ldc_ca_surtida <= 0 Then
				lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
				lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
				lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
				lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
				lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
				lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
				lnvo_msn.Of_Set_Campo('Cantidad', ldc_ca_surtida)
				lnvo_msn.icono = StopSign!
				
				lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Error en las cantidades de la equivalencia para la equivalencia de:', '')	
				This.item = lds_detalle.GetItemNumber( 1, 'item')
				
				li_retorno = -1
				Exit
			End If
			
			// se calcula la cantidad de empaque
			ll_cantidad_empq = ldc_ca_surtida*ll_uni_empaque
			// si es la primera referencia
			If ldc_escala_esp = -1 Then
				// se calcula la escala entre la ca_pedida y la cantidad  de empaque
				ldc_escala_esp = ll_cantidad / ll_cantidad_empq
			Else
				// se calcula la cantidad esperada de esta prenda
				ll_cantidad_esp = ll_cantidad_empq * ldc_escala_esp
				// si es diferente se muestra un mensaje de error
				If ll_cantidad_esp <> ll_cantidad Then
					This.item = lds_detalle.GetItemNumber( ll_row, 'item')
					
					lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
					lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
					lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
					lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
					lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
					lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
					lnvo_msn.Of_Set_Campo('Item', This.item)
					lnvo_msn.Of_Set_Campo('Temp.', This.is_co_prepack)
					lnvo_msn.Of_Set_Campo('Cant', ll_cantidad)
					lnvo_msn.Of_Set_Campo('Cant EQ', ll_cantidad_esp)
					lnvo_msn.icono = StopSign!
					
					lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Las unidades para la referencia de venta de la temporada no concuerdan:', &
					'Las unidades para ese item no concuerdan con la cantidad esperada de esa referencia por favor revise las cantidades')

					li_retorno = -1
					Exit
				End If				
			End If
		Else
			
		End If		
	Next
	If li_retorno < 0 Then
		Exit
	End If
	
	If ll_cant_eq < lds_eq_x_sku_exp.RowCount() Then
		This.item = lds_detalle.GetItemNumber( 1, 'item')
					
		lnvo_msn.Of_Set_Campo('Fab Vta', This.il_co_fabrica_exp)
		lnvo_msn.Of_Set_Campo('Lin Vta', This.il_co_linea_exp)
		lnvo_msn.Of_Set_Campo('Ref Vta', This.is_co_ref_exp)
		lnvo_msn.Of_Set_Campo('Talla Vta', This.is_co_talla_exp)
		lnvo_msn.Of_Set_Campo('Cal.', This.il_co_calidad)
		lnvo_msn.Of_Set_Campo('Col Vta', This.is_co_color_exp)
		lnvo_msn.Of_Set_Campo('Item', This.item)
		lnvo_msn.Of_Set_Campo('Temp.', This.is_co_prepack)
		lnvo_msn.icono = StopSign!
		
		lnvo_msn.Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'La referencia de venta de la temporada, no contiene  todas las referencias de produccion:', &
				'')
				
		li_retorno = -1
		Exit
	End If

	lds_detalle.RowsDiscard( 1, lds_detalle.Rowcount(), Primary!)
	lds_detalle.SetFilter('')
	lds_detalle.Filter()	
Loop

Destroy lds_eq_x_sku_exp
Destroy lds_detalle
Destroy lds_cubicaje

Destroy lnvo_msn

Return li_retorno


end function

public function long of_validar_ean_vta_pv (boolean ab_validar_cubicaje);/*
Funci$$HEX1$$f300$$ENDHEX$$n para verificar que el SKU de venta exista

Precondiciones:
 Deben de haber ingresado los parametros del SKu
  il_co_fabrica_exp, il_co_linea_exp, is_co_ref_exp, is_co_talla_exp, il_co_calidad, is_co_color_exp

Retorno:
1   - Exito
< 0 - Error
*/
Long ll_filas, ll_reg, ll_retorno
String ls_referencia, ls_expresion, ls_error
s_base_parametros lsp_parametros
uo_dsbase lds_sku_pv


ls_expresion = 'co_fabrica = ' + String(il_co_fabrica_exp) +' AND ' &
			+ 'co_linea = '  + String(il_co_linea_exp) +' AND ' &
			+ 'co_referencia = "'  + String(is_co_ref_exp) +'" AND ' &
			+ 'co_calidad = 1 AND co_talla = "' + is_co_talla_exp + '" AND ' &
			+ 'co_color = "' + is_co_color_exp + '"'

If Not IsValid(ids_dt_ref_x_col_pv) Then
	ids_dt_ref_x_col_pv = Create uo_dsbase
	ids_dt_ref_x_col_pv.DataObject = 'd_gr_info_dt_ref_x_col_pv'
	ids_dt_ref_x_col_pv.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia( ))
	
	ll_reg = 0
Else
	ll_reg = ids_dt_ref_x_col_pv.Find( ls_expresion, 1, ids_dt_ref_x_col_pv.RowCount() )
End If

If ll_reg <= 0 Then
	lds_sku_pv = Create uo_dsbase
	lds_sku_pv.DataObject = 'd_gr_info_dt_ref_x_col_pv'
	lds_sku_pv.SetTransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )
	
	ll_reg = lds_sku_pv.of_retrieve(il_cliente, il_sucursal, 'V', il_co_fabrica_exp, il_co_linea_exp, is_co_ref_exp )
	
	If ll_reg > 0 Then
		lds_sku_pv.RowsCopy( 1, lds_sku_pv.RowCount(), Primary!, ids_dt_ref_x_col_pv, ids_dt_ref_x_col_pv.RowCount()+ 1, Primary!)
	Else
		ls_error = lds_sku_pv.is_sqlerrtext
	End If
	
End If				
				

	
lsp_parametros.Cadena[1] = 'Cliente'
lsp_parametros.Cadena[2] = 'Suc.'
lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$b. Vta'
lsp_parametros.Cadena[2] = 'Linea Vta'
lsp_parametros.Cadena[3] = 'Ref. Vta'
lsp_parametros.Cadena[4] = 'Talla Vta'
lsp_parametros.Cadena[5] = 'Calidad'
lsp_parametros.Cadena[6] = 'Color '
				
lsp_parametros.Any[1] = il_co_fabrica_exp
lsp_parametros.Any[2] = il_co_linea_exp
lsp_parametros.Any[3] = is_co_ref_exp
lsp_parametros.Any[4] = is_co_talla_exp
lsp_parametros.Any[5] = il_co_calidad
lsp_parametros.Any[6] = is_co_color_exp

					

If ll_reg > 0 Then	
	ll_reg = ids_dt_ref_x_col_pv.Find( ls_expresion,&
				1, ids_dt_ref_x_col_pv.RowCount())
End If
Choose Case ll_reg
	Case Is > 0 
		// se asigna el ean al upc
		is_upc_barcode = Trim(ids_dt_ref_x_col_pv.GetItemString(ll_reg,'barcode') )
		
		If (is_tipo_pedido = 'NA' Or il_cliente = 5160) And (ib_valida_ean Or ib_valida_ean_generico) And &
			(is_upc_barcode = '' Or is_upc_barcode = '0' Or IsNull(is_upc_barcode) Or &
				(ib_valida_ean_generico And ( is_upc_barcode = 'GENERICO'  Or Len(is_upc_barcode) < 7) ) &
			) Then			
				
			If ib_msn_validacion Then
				Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'La referencia de vta tiene el ean en cero (0) en el maestro de Eans ', lsp_parametros, 'Por favor verificar este ean para el sku en el maestro de Ean.')
			End If
			ll_retorno = -4
		Else
			ll_retorno = 1
		End If	
		
		ii_uni_empaque = ids_dt_ref_x_col_pv.GetItemNumber(ll_reg, 'ca_x_uempq_pd')
		ii_cubicaje = ids_dt_ref_x_col_pv.GetItemNumber(ll_reg, 'ca_uempq_pd_x_cjds')
		
		is_co_muestrario = ids_dt_ref_x_col_pv.GetItemString(ll_reg, 'co_muestrario')
		is_de_talla = ids_dt_ref_x_col_pv.GetItemString(ll_reg, 'de_talla')
		
		If ab_validar_cubicaje And ll_retorno = 1 Then
			
			If ii_uni_empaque = 0 Or ii_cubicaje <= ii_uni_empaque Then
				lsp_parametros.Cadena[6] = 'U. Empq.'
				lsp_parametros.Cadena[7] = 'Cubicaje'
				lsp_parametros.Any[6] = ii_uni_empaque
				lsp_parametros.Any[7] = ii_cubicaje			
				Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Cubicaje No permitido (U. Empq.>0 y Cubicaje>=U. Empq.)', lsp_parametros, '')
				Return -1
			End If 
			
			If Mod(il_cantidad, ii_uni_empaque) <> 0 Then
				lsp_parametros.Cadena[6] = 'U. Empq.'
				lsp_parametros.Cadena[7] = 'Cubicaje'
				lsp_parametros.Any[6] = ii_uni_empaque
				lsp_parametros.Any[7] = ii_cubicaje			
				Of_Mensaje('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Cantidad (' + String(il_cantidad) + ' unds) no es multiplo de unidad de venta ', lsp_parametros, '')
				Return -1
			End If			
		End If
		
	Case 0
		If is_tipo_pedido = 'NA' Then
			If ib_msn_validacion Then
				Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No esta creado en el maestro de Eans la referencia de vta.', lsp_parametros, 'Por favor verificar este sku en el maestro de Ean.')
			End If
		End If
		ll_retorno = -3					
	Case Else		
		Of_Mensaje ('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un Error en la Base de Datos al intentar cargar datos del SKU de Vta.', lsp_parametros, ls_error)
		ll_retorno = -1
End Choose
Destroy(lds_sku_pv)

Return ll_retorno
end function

on n_cst_dt_pedidos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_dt_pedidos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;This.Of_Reiniciar_Propiedades()
end event

event destructor;Destroy(ids_dt_pedido)
Destroy(ids_m_colores_exp)
Destroy(ids_referencia)
Destroy(ids_dt_ref_x_col_pv)
end event

