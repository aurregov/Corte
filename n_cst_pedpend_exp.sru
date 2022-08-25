HA$PBExportHeader$n_cst_pedpend_exp.sru
forward
global type n_cst_pedpend_exp from nonvisualobject
end type
end forward

global type n_cst_pedpend_exp from nonvisualobject autoinstantiate
end type

type variables
/*	--------------------------------------------
	Campos que son llave en penpend_exp
	--------------------------------------------	*/
long		pedido
Long		item
/*	-------------------------------------------	*/
long		co_cliente_exp
long		co_sucursal_exp
long		co_fabrica_exp
long		co_linea_exp
string	co_ref_exp
string	co_talla_exp
string	co_color_exp
string	instresp_empq
long		co_calidad
long		co_empq_cnsm
string	upc_barcode
string	po_master
string	nu_orden
string	nu_cut
string	marca
decimal 	{2}	ca_pedida
decimal 	{2}	ca_despachada
decimal 	{2}	ca_transito
decimal 	{2}	ca_cancelada
decimal 	{3}	pr_maestro
decimal 	{3}	pr_pedido
string	estado
decimal 	{3}	pr_neto
date		fe_exit_po
date		fe_act_exit
long		nro_invoice
decimal 	{2}	ca_corte
decimal 	{2}	ca_confecc
date		fe_recep_esp
date		fe_envio_muestra
date		fe_pp_comment_rec
long		co_fabrica
long		co_linea
long		co_referencia
long		co_talla
long		co_color
string	grupo_empaque
string	single_item
long		ca_bolsa_x_caja
date		fe_entrega
decimal 	{4}	peso
decimal 	{4}	volumen
decimal 	{2}	tejido
decimal 	{2}	segundas
string	area
string	zona
string	aisle
string	bahia
string	nivel
string	posicion
long		co_lista
long		co_vendedor
decimal 	{2}	ca_anulada
decimal 	{2}	ca_cortada
decimal 	{2}	ca_transito_seg
decimal 	{2}	ca_despachada_seg
decimal 	{2}	ca_vesa
decimal 	{2}	ca_tintoreria
date		fe_tejido
date		fe_tintoreria
string	omdiv
string	cusol
string	cuship
string	ompro
string	comment
long		ca_tejido
string	comment_cut
long		co_testreport
decimal 	{4}	pr_gancho
decimal 	{2}	ca_costura
decimal 	{2}	ca_liberada
decimal 	{2}	ca_comprada
string	id_mercado
string	co_prepack
long		co_proces
string	co_disenno
decimal 	{2}	ca_consolidador
string	dim
decimal 	{2}	ca_aud_militar
decimal 	{2}	ca_pedida_comprar
decimal 	{2}	ca_inicial
long		sw_auditado
long		cs_precio
string	opc_ped11
string	opc_ped12
string	opc_ped13
string	opc_ped14
string	opc_ped15
long		co_coleccion
long		co_centro_distrib
long		co_division
decimal 	{2}	cantidad_dpo
decimal 	{2}	cantidad_102
long		minutos_turno
decimal 	{4}	tiempo_estandar
long		tipo_modulo
long		co_curva
long		nu_personas_modulo
long		turnos
decimal 	{2}	porc_eficiencia
long		modulos
long		dias
date		fe_prorroga1
date		fe_prorroga2
date		fe_prorroga3
datetime	fe_creacion
datetime	fe_actualizacion
string	usuario
string	instancia
end variables

forward prototypes
public function long of_reiniciar_propiedades ()
public function long of_validar_campos_auditoria (long ai_operacion)
public function long of_actualizar_estado (ref uo_dsbase ads_tabla, dwitemstatus al_status)
public function long of_registro (ref uo_dsbase ads_tabla)
public function long of_actualizar ()
public function long of_crear ()
public function long of_validar_campos_requeridos ()
public function long of_registro (ref uo_dsbase ads_tabla, n_cst_pedpend_exp anvo_tabla)
public function long of_actualizar (n_cst_pedpend_exp anvo_tabla)
public function long of_validar_llave (long ai_operacion)
public function long of_registrar_seguridad (ref uo_dsbase ads_registrado)
public function long of_actualizar_campos (long al_row, ref uo_dsbase ads_tabla, n_cst_pedpend_exp anvo_tabla)
end prototypes

public function long of_reiniciar_propiedades ();/*	---------------------------------------------------------------------------------
	Funcion utilizada para inicializar las propiedades del objeto en nulo
	--------------------------------------------------------------------------------- */

//	Columnas que hacen parte de la llave se ponen en nulo
SetNull(pedido)
SetNull(item)

//	El resto de columnas tambien se ponen en nulo
SetNull(co_cliente_exp)
SetNull(co_sucursal_exp)
SetNull(co_fabrica_exp)
SetNull(co_linea_exp)
SetNull(co_ref_exp)
SetNull(co_talla_exp)
SetNull(co_color_exp)
SetNull(instresp_empq)
SetNull(co_calidad)
SetNull(co_empq_cnsm)
SetNull(upc_barcode)
SetNull(po_master)
SetNull(nu_orden)
SetNull(nu_cut)
SetNull(marca)
SetNull(ca_pedida)
SetNull(ca_despachada)
SetNull(ca_transito)
SetNull(ca_cancelada)
SetNull(pr_maestro)
SetNull(pr_pedido)
SetNull(estado)
SetNull(pr_neto)
SetNull(fe_creacion)
SetNull(fe_actualizacion)
SetNull(usuario)
SetNull(instancia)
SetNull(fe_exit_po)
SetNull(fe_act_exit)
SetNull(nro_invoice)
SetNull(ca_corte)
SetNull(ca_confecc)
SetNull(fe_recep_esp)
SetNull(fe_envio_muestra)
SetNull(fe_pp_comment_rec)
SetNull(co_fabrica)
SetNull(co_linea)
SetNull(co_referencia)
SetNull(co_talla)
SetNull(co_color)
SetNull(grupo_empaque)
SetNull(single_item)
SetNull(ca_bolsa_x_caja)
SetNull(fe_entrega)
SetNull(peso)
SetNull(volumen)
SetNull(tejido)
SetNull(segundas)
SetNull(area)
SetNull(zona)
SetNull(aisle)
SetNull(bahia)
SetNull(nivel)
SetNull(posicion)
SetNull(co_lista)
SetNull(co_vendedor)
SetNull(ca_anulada)
SetNull(ca_cortada)
SetNull(ca_transito_seg)
SetNull(ca_despachada_seg)
SetNull(ca_vesa)
SetNull(ca_tintoreria)
SetNull(fe_tejido)
SetNull(fe_tintoreria)
SetNull(omdiv)
SetNull(cusol)
SetNull(cuship)
SetNull(ompro)
SetNull(comment)
SetNull(ca_tejido)
SetNull(comment_cut)
SetNull(co_testreport)
SetNull(pr_gancho)
SetNull(ca_costura)
SetNull(ca_liberada)
SetNull(ca_comprada)
SetNull(id_mercado)
SetNull(co_prepack)
SetNull(co_proces)
SetNull(co_disenno)
SetNull(ca_consolidador)
SetNull(dim)
SetNull(ca_aud_militar)
SetNull(ca_pedida_comprar)
SetNull(ca_inicial)
SetNull(sw_auditado)
SetNull(cs_precio)
SetNull(opc_ped11)
SetNull(opc_ped12)
SetNull(opc_ped13)
SetNull(opc_ped14)
SetNull(opc_ped15)
SetNull(co_coleccion)
SetNull(co_centro_distrib)
SetNull(co_division)
SetNull(cantidad_dpo)
SetNull(cantidad_102)
SetNull(minutos_turno)
SetNull(tiempo_estandar)
SetNull(tipo_modulo)
SetNull(co_curva)
SetNull(nu_personas_modulo)
SetNull(turnos)
SetNull(porc_eficiencia)
SetNull(modulos)
SetNull(dias)
SetNull(fe_prorroga1)
SetNull(fe_prorroga2)
SetNull(fe_prorroga3)

Return 1
end function

public function long of_validar_campos_auditoria (long ai_operacion);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para verificar que los campos de auditoria si tengan un valor 
	valido. Si algun campo es nulo o tiene un valor inapropiado se informa al usuario 
	que no es posible un valor de estos.  El parametro ai_operacion indica si el 
	llamado a la funcion es desde la creacion (0) o la actualizacion(1) del registro.
	--------------------------------------------------------------------------------- */

//	Si se esta creando un registro nuevo 
//	se valida la existencia de la fecha de creacion del registro
If ai_operacion = 0 Then
	If IsNull(This.fe_creacion) Or This.fe_creacion <= Datetime(1999-12-31) Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'fe_creacion' no puede ser nulo o menor al a$$HEX1$$f100$$ENDHEX$$o 2000.", StopSign!)
		Return -1	
	End If
End If

If IsNull(This.fe_actualizacion) Or This.fe_actualizacion <= Datetime(1999-12-31) Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'fe_actualizacion' no puede ser nulo o o menor al a$$HEX1$$f100$$ENDHEX$$o 2000.", StopSign!)
	Return -1	
End If	

If IsNull(This.usuario) Or Len(Trim(This.usuario)) = 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'usuario' no puede ser nulo o vacio.", StopSign!)
	Return -1	
End If

If IsNull(This.instancia) Or Len(Trim(This.instancia)) = 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'instancia' no puede ser nulo o vacio.", StopSign!)
	Return -1	
End If	

Return 1
end function

public function long of_actualizar_estado (ref uo_dsbase ads_tabla, dwitemstatus al_status);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para modificar el estado de cada columna del dw segun los campos
	que hayan sido enviados por el usuario.
	Primero halla la cantidad de columnas del datawindow y modifica el estado del 
	registro segun el estado enviado en al_status, luego para cada columna halla el 
	tipo de dato y despues segun sea el caso llama la correspondiente funcion GetItemX 
	para detectar si fue una columna enviada por el usuario; si la	columna fue enviada 
	por el usuario le pone a la columna el estado DataModified!.
	--------------------------------------------------------------------------------- */
Long ll_contador, ll_columnas
String ls_columna, ls_coltype
Boolean lb_columna_modificada

//	Halla la cantidad de columnas del datawindow
ll_columnas = Long(ads_tabla.Describe("DataWindow.Column.Count"))

//	Se modifica el estado del registro para que sea lanzado el SQL necesario
ads_tabla.SetItemStatus(1, 0, Primary!, al_status)

//	Para cada columna del datawindow
For ll_contador = 1 To ll_columnas
	//	Fija la columna evaluada como la columna actual
	ads_tabla.SetColumn(ll_contador)
	
	//	Captura el nombre de la columna evaluada
	ls_columna = ads_tabla.GetColumnName()

	//	Halla el tipo de la columna evaluada
	ls_coltype = ads_tabla.Describe(ls_columna + ".ColType")
	
	//	Si el tipo de la columna evaluada es char(n) o decimal(n)
	//	remueve 'n' siendo: n = numero de caracteres o n = numero de cifras decimales
	If Pos(ls_coltype,"char") = 1 Then ls_coltype = "char"
	If Pos(ls_coltype,"decimal") = 1 Then ls_coltype = "decimal"
	
	lb_columna_modificada = True
	//	Escoge segun el caso la funcion GetItemX y evalua si el valor en el dw es nulo
	//	en cuyo caso, se 'identifica' la columna evaluada como una columna no modificada
	Choose Case ls_coltype
		Case "int","number","real","ulong","long"
			If IsNull(ads_tabla.GetItemNumber(1, ll_contador)) Then lb_columna_modificada = False
		Case "decimal"
			If IsNull(ads_tabla.GetItemDecimal(1, ll_contador)) Then lb_columna_modificada = False
		Case "char"
			If IsNull(ads_tabla.GetItemString(1, ll_contador)) Then lb_columna_modificada = False
		Case "date"
			If IsNull(ads_tabla.GetItemDate(1, ll_contador)) Then lb_columna_modificada = False
		Case "time"
			If IsNull(ads_tabla.GetItemTime(1, ll_contador)) Then lb_columna_modificada = False
		Case "datetime","timestamp"
			If IsNull(ads_tabla.GetItemDateTime(1, ll_contador)) Then lb_columna_modificada = False
		Case Else 	
			MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El tipo de dato de la columna" + ls_columna + " no ha sido identificado.")
			Return -1
	End Choose	

	//	Si la columna fue enviada por el usuario al objeto (propiedad modificada)
	If lb_columna_modificada Then
		//	Se modifica el estado de la columna para que sea incluida en el SQL
		ads_tabla.SetItemStatus(1, ll_contador, Primary!, DataModified!)
	End If

Next

Return 1
end function

public function long of_registro (ref uo_dsbase ads_tabla);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para crear el registro de la tabla en un datastore.
	Primero crea la instancia del datastore en la variable por referencia recibida y
	despues crea el registro con todas las propiedades del objeto y valida la existencia
	del nuevo registro; al final deja el registro como si se hubiera leido (NotModified!)
	de la B.D.
	--------------------------------------------------------------------------------- */
	
Long ll_row
//	Se crea el datastore utilizado para 'escribir' la tabla
ads_tabla = Create uo_dsbase
ads_tabla.DataObject = 'd_gr_tabla_pedpend_exp'
ads_tabla.SetTransObject(SQLCA)

//	Registra el datastore con el manejo de seguridad de la ventana actual
This.of_registrar_seguridad(ads_tabla)


/* Se anulo por que reemplaza los valores por defecto que tiene el dw

//	Se crea el registro en el datastore para ser actualizado en la B.D.
ads_tabla.Object.Data = This
*/

//	Se crea el registro en el datastore para ser actualizado en la B.D.
ll_row = ads_tabla.InsertRow(0)
If This.Of_Actualizar_Campos(ll_row, ads_tabla, This) < 0 Then
	Return -1
End If


//	Si el registro no existe en el datastore, se informa al usuario y se aborta la actualizacion
If ads_tabla.RowCount() = 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se creo el registro en memoria para ser Creado y/o Actualizado.")
	Return -2
End If

//	Limpia el estado de los flags y deja el registro como NotModified!
ads_tabla.ResetUpdate()

Return 1
end function

public function long of_actualizar ();
/*	---------------------------------------------------------------------------------
	Funcion utilizada para actualizar un registro de la tabla.
	Primero se valida que los campos que son obligatorios en la BD esten bien creados,
	luego se crea el registro a insertar en la B.D. y se modifica su estado para que
	el motor del datawindows lanze el correspondiente SQL Update a la B.D.; al final
	se pone al dw en modo de actualizacion Where con validacion solo de llave primaria
	y se lanza el Update del datastore.
	--------------------------------------------------------------------------------- */
uo_dsbase lds_tabla

//	Se valida la consistencia de los campos que son obligatorios en B.D.
If This.of_validar_llave(1) <= 0 Then Return -1
If This.of_validar_campos_auditoria(1) <= 0 Then Return -2

//	Se crea el registro en memoria para ser actualizado en la B.D.
If of_registro(lds_tabla) <= 0 Then Return -3

//	Se modifica el estado del registro para que sea lanzado un SQL Update a la B.D.
If This.of_actualizar_estado(lds_tabla, DataModified!) <= 0 Then Return -4

//	Pone el datawindows a actualizar teniendo solo en cuenta las columnas llave
lds_tabla.Modify("DataWindow.Table.UpdateWhere ='0'")

//	Se lanza la actualizacion del registro a la B.D.
If lds_tabla.Of_Update() <= 0 Then Return -5

Return 1
end function

public function long of_crear ();
/*	---------------------------------------------------------------------------------
	Funcion utilizada para crear un registro en la tabla.
	Primero se valida que los campos que son obligatorios en la BD esten bien creados,
	luego se crea el registro a insertar en la B.D. y se modifica su estado para que
	el motor del datawindows lanze el correspondiente SQL Insert a la B.D. y termina 
	lanzando el Update del datastore.
	--------------------------------------------------------------------------------- */
uo_dsbase lds_tabla

//	Se valida la consistencia de los campos que son obligatorios en B.D.
If This.of_validar_llave(0) <= 0 Then Return -1
If This.of_validar_campos_requeridos() <= 0 Then Return -2
If This.of_validar_campos_auditoria(0) <= 0 Then Return -3

//	Se crea el registro en memoria para ser creado en la B.D.
If of_registro(lds_tabla) <= 0 Then Return -4

//	Se modifica el estado del registro para que sea lanzado un SQL Insert a la B.D.
If This.of_actualizar_estado(lds_tabla, NewModified!) <= 0 Then Return -5

//	Se lanza la creacion del registro a la B.D.
If lds_tabla.Of_Update() <= 0 Then Return -6

Return 1
end function

public function long of_validar_campos_requeridos ();
/*	---------------------------------------------------------------------------------
	Funcion utilizada para verificar los campos que no se aceptan nulos en la BD
   si tengan un valor valido.   Si algun campo es nulo o tiene un valor inapropiado
	se informa al usuario que no es posible un valor de estos.   Algunos campos que
	son obligatorios en la B.D. en caso de que el usuario no proporcione sus valores 
	son inicializados por defecto.
	--------------------------------------------------------------------------------- */

n_cst_dt_pedidos luo_detalle

If IsNull(This.co_cliente_exp) Or This.co_cliente_exp < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'co_cliente_exp' no puede ser nulo o menor a cero(0).", StopSign!)
	Return -1	
End If

If IsNull(This.co_sucursal_exp) Or This.co_sucursal_exp < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'co_sucursal_exp' no puede ser nulo o menor a cero(0).", StopSign!)
	Return -1	
End If	

// Si no es un Allocation, tipo_modulo es un campo que solo lo llenan los pedidos allocation
If (IsNull(This.tipo_modulo) Or This.tipo_modulo = 0) AND (This.co_calidad = 1) Then
	luo_detalle.is_tipo_pedido = 'NA'
	
   luo_detalle.il_cliente                  = This.co_cliente_exp
   luo_detalle.il_sucursal               = This.co_sucursal_exp

	luo_detalle.il_co_fabrica		= This.co_fabrica
	luo_detalle.il_co_linea			= This.co_linea
	luo_detalle.il_co_referencia	= This.co_referencia
	luo_detalle.il_co_talla			= This.co_talla
	luo_detalle.il_co_calidad		= This.co_calidad
	luo_detalle.il_co_color			= This.co_color

	luo_detalle.il_co_fabrica_exp	= This.co_fabrica_exp
	luo_detalle.il_co_linea_exp	= This.co_linea_exp
	luo_detalle.is_co_ref_exp		= This.co_ref_exp
	luo_detalle.is_co_talla_exp	= This.co_talla_exp
	luo_detalle.is_co_color_exp	= This.co_color_exp
	
	// Solo valida la equivalencia actual
	luo_detalle.ib_valida_equivalencia = True
	// Se verifica el sku nacional
	If luo_detalle.Of_Validar_SKU_Nal() <= 0 Then		
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Ocurrio un error validando el sku")
		Return -1
	Else
		// Se toma el ean de la referencia de venta
		This.upc_barcode	= luo_detalle.is_upc_barcode
		//This.co_prepack	= luo_detalle.is_co_prepack
	End IF
	
End If

//	Si el usuario no proporciona estos campos obligatorios, son inicializados por defecto
// en valores estandar para la mayoria de pedidos creados
If IsNull(This.co_fabrica_exp) Then This.co_fabrica_exp = This.co_fabrica

If IsNull(This.co_linea_exp) Then This.co_linea_exp = This.co_linea

If IsNull(This.co_ref_exp) Then This.co_ref_exp = String(This.co_referencia)

If IsNull(This.co_talla_exp) Then This.co_talla_exp = ''

If IsNull(This.co_color_exp) Then This.co_color_exp = '' 

If IsNull(This.co_calidad) Then This.co_calidad = 1

If IsNull(This.co_empq_cnsm) Then This.co_empq_cnsm = 2 

If IsNull(This.nu_cut) Then This.nu_cut = '0' 

If IsNull(This.marca) Then This.marca = 'A' 

If IsNull(This.estado) Then This.estado = 'D' 

//	Algunos campos adicionales no obligatorios, tambien son inicializados
If IsNull(This.ca_pedida) Then This.ca_pedida = 0

If IsNull(This.upc_barcode) Then This.upc_barcode = ''

Return 1
end function

public function long of_registro (ref uo_dsbase ads_tabla, n_cst_pedpend_exp anvo_tabla);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para crear el registro de la tabla en un datastore	a partir de 
	la llave primaria enviada como parametro en anvo_pedido.
	Primero crea la instancia del datastore en la variable por referencia recibida y
	despues carga el registro de la B.D. con la llave enviada en anvo_tabla, al final
	se actualizan las columnas enviadas por el usuario en el registro previamente
	leido de la B.D.
	--------------------------------------------------------------------------------- */
	 
//	Se crea el datastore utilizado para 'escribir' la tabla
ads_tabla = Create uo_dsbase
ads_tabla.DataObject = 'd_gr_tabla_pedpend_exp'
ads_tabla.SetTransObject(SQLCA) 

//	Registra el datastore con el manejo de seguridad de la ventana actual
This.of_registrar_seguridad(ads_tabla)

//	Si el registro no existe en el datastore, se informa al usuario y se aborta la actualizacion
If ads_tabla.Of_Retrieve(anvo_tabla.pedido, anvo_tabla.item)  <= 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se creo el registro en memoria para ser Actualizado.") 
	Return -1
End If
// Se actualizan los campos del registro
If This.Of_Actualizar_Campos(1, ads_tabla, This) < 0 Then
	Return -2
End If

Return 1
end function

public function long of_actualizar (n_cst_pedpend_exp anvo_tabla);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para actualizar un registro de la tabla incluyendo la	llave 
	primaria si se quiere.
	Primero se valida que los campos que son obligatorios en la BD esten bien creados,
	luego se crea el registro a insertar en la B.D. teniendo en cuenta la llave original
	enviada como parametro en anvo_tabla y termina lanzando el Update del datastore.
	--------------------------------------------------------------------------------- */
uo_dsbase lds_tabla

//	Se valida la consistencia de los campos que son obligatorios en B.D.
If This.of_validar_llave(1) <= 0 Then Return -1
If This.of_validar_campos_auditoria(1) <= 0 Then Return -2

//	Se crea el registro en memoria utilizando la llave primaria actual del registro a
//	ser modificadopara ser actualizado en la B.D.
If of_registro(lds_tabla, anvo_tabla) <= 0 Then Return -3

//	Se lanza la actualizacion del registro a la B.D.
If lds_tabla.Of_Update() <= 0 Then Return -4

Return 1
end function

public function long of_validar_llave (long ai_operacion);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para verificar la existencia de una llave primaria valida.
	Si algun campo de la llave primaria es nulo o negativo se informa al usuario que 
	no es posible un valor de estos por cuanto el campo es un campo que hace parte 
	de la llave primaria.   El parametro ai_operacion indica si el 
	llamado a la funcion es desde la creacion (0) o la actualizacion(1) del registro.
	--------------------------------------------------------------------------------- */
uo_dsbase lds_item

If IsNull(This.pedido) Or This.pedido <= 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'pedido' no puede ser nulo o negativo porque hace parte de la llave primaria.", StopSign!)
	Return -2
End If	

//	Si se esta actualizando un detalle de pedido
If ai_operacion = 1 Then
	If IsNull(This.item) Or This.item <= 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'item' no puede ser nulo o negativo porque hace parte de la llave primaria.", StopSign!)
		Return -3
	End If	
Else	//	Sino se esta actualizando se esta creando un detalle nuevo de pedido
	//	Si no es suministrado el item, se busca con base en el pedido del objeto
	If IsNull(This.item) Then
		//	Se crea el datastore utilizado para buscar un item
		lds_item = Create uo_dsbase
		lds_item.DataObject = 'd_gr_hallar_item_pedido'
		lds_item.SetTransObject(SQLCA)
		
		//	Si se encuentra un item en la B.D.
		If lds_item.Of_Retrieve(This.pedido) > 0 Then
			//	Se calcula el nuevo item 
			This.item = lds_item.GetItemNumber(1,'item') + 1
		Else	//	Sino se encuentra un item se comienza uno nuevo
			This.item = 1
		End If

		//	Se destruye el datastore utilizado dutrante el proceso
		Destroy lds_item
	Else
		This.item++
	End If
	
	//	Si el usuario no suministra ninguna PO se pone en su lugar el pedido
	If IsNull(This.nu_orden) Or Len(Trim(This.nu_orden)) = 0 Then This.nu_orden = String(This.pedido)

End If

Return 1
end function

public function long of_registrar_seguridad (ref uo_dsbase ads_registrado);/*	------------------------------------------------------------------------
	Funcion utilizada para registrar el datastore enviado por referencia con
	el mismo manejo de seguridad de la ventana actual donde se utiliza este
	objeto.   Primero captura la ventana actual en el sistema y luego evalua
	si es una ventana de las base que ya tiene seguridad o si no es de las 
	base pero maneja tambien seguridad, en cualquier caso se pone al datastore
	a utilizar los permisos de seguridad que tiene la ventana activa.
	------------------------------------------------------------------------ */
window lw_window
w_base_simple lw_ventana

/* ESTA FUNCION HAY QUE COMENTARLA PARA ENVIAR A MARINILLA

//	Halla la ventana activa
lw_window = w_principal.GetActiveSheet()

//	Si existe una ventana activa
If IsValid(lw_window) Then
	//	Si la ventana activa es descendiente de w_base_simple
	If lw_window.TriggerEvent('ue_es_base_simple') = 1 Then
		lw_ventana = lw_window
		//	Registra el datastore enviado por referencia con la seguridad de la ventana
		lw_ventana.wf_seguridad_ds(ads_registrado)
	//	Si la ventana activa tiene manejo de seguridad
	ElseIf lw_window.TriggerEvent('ue_validar_seguridad') = 1 Then
		//	Registra el datastore enviado por referencia con la seguridad de la ventana
		lw_window.Dynamic wf_seguridad_ds(ads_registrado)
	End If
End If
*/
Return 1
end function

public function long of_actualizar_campos (long al_row, ref uo_dsbase ads_tabla, n_cst_pedpend_exp anvo_tabla);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para actualizar los campos de un registro de la tabla en un datastore.
	se actualizan las columnas enviadas por el usuario en el registro al_row del datastore.
	--------------------------------------------------------------------------------- */
	 
// Se valida que sea vaido el datastore y el objeto
If Not IsValid(ads_tabla) Or Not IsValid(anvo_tabla) Then Return -1

// Se valida que al_row no sea mayor que el tama$$HEX1$$f100$$ENDHEX$$o del datastore
If ads_tabla.RowCount() < al_row Then Return -2

// se actualizan las columnas
If Not IsNull(pedido) Then ads_tabla.SetItem(al_row,'pedido',anvo_tabla.pedido) 
If Not IsNull(item) Then ads_tabla.SetItem(al_row,'item',anvo_tabla.item) 
If Not IsNull(co_cliente_exp) Then ads_tabla.SetItem(al_row,'co_cliente_exp',anvo_tabla.co_cliente_exp)
If Not IsNull(co_sucursal_exp) Then ads_tabla.SetItem(al_row,'co_sucursal_exp',anvo_tabla.co_sucursal_exp)


If Not IsNull(co_fabrica_exp)  Then ads_tabla.SetItem(al_row,'co_fabrica_exp',anvo_tabla.co_fabrica_exp) 
If Not IsNull(co_linea_exp) Then ads_tabla.SetItem(al_row,'co_linea_exp',anvo_tabla.co_linea_exp)
If Not IsNull(co_ref_exp) Then ads_tabla.SetItem(al_row,'co_ref_exp',anvo_tabla.co_ref_exp)
If Not IsNull(co_talla_exp) Then ads_tabla.SetItem(al_row,'co_talla_exp',anvo_tabla.co_talla_exp)
If Not IsNull(co_color_exp) Then ads_tabla.SetItem(al_row,'co_color_exp',anvo_tabla.co_color_exp)
If Not IsNull(instresp_empq) Then ads_tabla.SetItem(al_row,'instresp_empq',anvo_tabla.instresp_empq)
If Not IsNull(co_calidad) Then ads_tabla.SetItem(al_row,'co_calidad',anvo_tabla.co_calidad)
If Not IsNull(co_empq_cnsm) Then ads_tabla.SetItem(al_row,'co_empq_cnsm',anvo_tabla.co_empq_cnsm)
If Not IsNull(upc_barcode) Then ads_tabla.SetItem(al_row,'upc_barcode',anvo_tabla.upc_barcode)
If Not IsNull(po_master) Then ads_tabla.SetItem(al_row,'po_master',anvo_tabla.po_master)
If Not IsNull(nu_orden) Then ads_tabla.SetItem(al_row,'nu_orden',anvo_tabla.nu_orden)
If Not IsNull(nu_cut) Then ads_tabla.SetItem(al_row,'nu_cut',anvo_tabla.nu_cut)
If Not IsNull(marca) Then ads_tabla.SetItem(al_row,'marca',anvo_tabla.marca)
If Not IsNull(ca_pedida) Then ads_tabla.SetItem(al_row,'ca_pedida',anvo_tabla.ca_pedida)
If Not IsNull(ca_despachada) Then ads_tabla.SetItem(al_row,'ca_despachada',anvo_tabla.ca_despachada)
If Not IsNull(ca_transito) Then ads_tabla.SetItem(al_row,'ca_transito',anvo_tabla.ca_transito)
If Not IsNull(ca_cancelada) Then ads_tabla.SetItem(al_row,'ca_cancelada',anvo_tabla.ca_cancelada)
If Not IsNull(pr_maestro) Then ads_tabla.SetItem(al_row,'pr_maestro',anvo_tabla.pr_maestro)
If Not IsNull(pr_pedido) Then ads_tabla.SetItem(al_row,'pr_pedido',anvo_tabla.pr_pedido)
If Not IsNull(estado) Then ads_tabla.SetItem(al_row,'estado',anvo_tabla.estado)
If Not IsNull(pr_neto) Then ads_tabla.SetItem(al_row,'pr_neto',anvo_tabla.pr_neto)
If Not IsNull(fe_creacion) Then ads_tabla.SetItem(al_row,'fe_creacion',anvo_tabla.fe_creacion)
If Not IsNull(fe_actualizacion) Then ads_tabla.SetItem(al_row,'fe_actualizacion',anvo_tabla.fe_actualizacion)
If Not IsNull(usuario) Then ads_tabla.SetItem(al_row,'usuario',anvo_tabla.usuario)
If Not IsNull(instancia) Then ads_tabla.SetItem(al_row,'instancia',anvo_tabla.instancia)
If Not IsNull(fe_exit_po) Then ads_tabla.SetItem(al_row,'fe_exit_po',anvo_tabla.fe_exit_po)
If Not IsNull(fe_act_exit) Then ads_tabla.SetItem(al_row,'fe_act_exit',anvo_tabla.fe_act_exit)
If Not IsNull(nro_invoice) Then ads_tabla.SetItem(al_row,'nro_invoice',anvo_tabla.nro_invoice)
If Not IsNull(ca_corte) Then ads_tabla.SetItem(al_row,'ca_corte',anvo_tabla.ca_corte)
If Not IsNull(ca_confecc) Then ads_tabla.SetItem(al_row,'ca_confecc',anvo_tabla.ca_confecc)
If Not IsNull(fe_recep_esp) Then ads_tabla.SetItem(al_row,'fe_recep_esp',anvo_tabla.fe_recep_esp)
If Not IsNull(fe_envio_muestra) Then ads_tabla.SetItem(al_row,'fe_envio_muestra',anvo_tabla.fe_envio_muestra)
If Not IsNull(fe_pp_comment_rec) Then ads_tabla.SetItem(al_row,'fe_pp_comment_rec',anvo_tabla.fe_pp_comment_rec)
If Not IsNull(co_fabrica) Then ads_tabla.SetItem(al_row,'co_fabrica',anvo_tabla.co_fabrica)
If Not IsNull(co_linea) Then ads_tabla.SetItem(al_row,'co_linea',anvo_tabla.co_linea)
If Not IsNull(co_referencia) Then ads_tabla.SetItem(al_row,'co_referencia',anvo_tabla.co_referencia)
If Not IsNull(co_talla) Then ads_tabla.SetItem(al_row,'co_talla',anvo_tabla.co_talla)
If Not IsNull(co_color) Then ads_tabla.SetItem(al_row,'co_color',anvo_tabla.co_color)
If Not IsNull(grupo_empaque) Then ads_tabla.SetItem(al_row,'grupo_empaque',anvo_tabla.grupo_empaque)
If Not IsNull(single_item) Then ads_tabla.SetItem(al_row,'single_item',anvo_tabla.single_item)
If Not IsNull(ca_bolsa_x_caja) Then ads_tabla.SetItem(al_row,'ca_bolsa_x_caja',anvo_tabla.ca_bolsa_x_caja)
If Not IsNull(fe_entrega) Then ads_tabla.SetItem(al_row,'fe_entrega',anvo_tabla.fe_entrega)
If Not IsNull(peso) Then ads_tabla.SetItem(al_row,'peso',anvo_tabla.peso)
If Not IsNull(volumen) Then ads_tabla.SetItem(al_row,'volumen',anvo_tabla.volumen)
If Not IsNull(tejido) Then ads_tabla.SetItem(al_row,'tejido',anvo_tabla.tejido)
If Not IsNull(segundas) Then ads_tabla.SetItem(al_row,'segundas',anvo_tabla.segundas)
If Not IsNull(area) Then ads_tabla.SetItem(al_row,'area',anvo_tabla.area)
If Not IsNull(zona) Then ads_tabla.SetItem(al_row,'zona',anvo_tabla.zona)
If Not IsNull(aisle) Then ads_tabla.SetItem(al_row,'aisle',anvo_tabla.aisle)
If Not IsNull(bahia) Then ads_tabla.SetItem(al_row,'bahia',anvo_tabla.bahia)
If Not IsNull(nivel) Then ads_tabla.SetItem(al_row,'nivel',anvo_tabla.nivel)
If Not IsNull(posicion) Then ads_tabla.SetItem(al_row,'posicion',anvo_tabla.posicion)
If Not IsNull(co_lista) Then ads_tabla.SetItem(al_row,'co_lista',anvo_tabla.co_lista)
If Not IsNull(co_vendedor) Then ads_tabla.SetItem(al_row,'co_vendedor',anvo_tabla.co_vendedor)
If Not IsNull(ca_anulada) Then ads_tabla.SetItem(al_row,'ca_anulada',anvo_tabla.ca_anulada)
If Not IsNull(ca_cortada) Then ads_tabla.SetItem(al_row,'ca_cortada',anvo_tabla.ca_cortada)
If Not IsNull(ca_transito_seg) Then ads_tabla.SetItem(al_row,'ca_transito_seg',anvo_tabla.ca_transito_seg)
If Not IsNull(ca_despachada_seg) Then ads_tabla.SetItem(al_row,'ca_despachada_seg',anvo_tabla.ca_despachada_seg)
If Not IsNull(ca_vesa) Then ads_tabla.SetItem(al_row,'ca_vesa',anvo_tabla.ca_vesa)
If Not IsNull(ca_tintoreria) Then ads_tabla.SetItem(al_row,'ca_tintoreria',anvo_tabla.ca_tintoreria)
If Not IsNull(fe_tejido) Then ads_tabla.SetItem(al_row,'fe_tejido',anvo_tabla.fe_tejido)
If Not IsNull(fe_tintoreria) Then ads_tabla.SetItem(al_row,'fe_tintoreria',anvo_tabla.fe_tintoreria)
If Not IsNull(omdiv) Then ads_tabla.SetItem(al_row,'omdiv',anvo_tabla.omdiv)
If Not IsNull(cusol) Then ads_tabla.SetItem(al_row,'cusol',anvo_tabla.cusol)
If Not IsNull(cuship) Then ads_tabla.SetItem(al_row,'cuship',anvo_tabla.cuship)
If Not IsNull(ompro) Then ads_tabla.SetItem(al_row,'ompro',anvo_tabla.ompro)
If Not IsNull(comment) Then ads_tabla.SetItem(al_row,'comment',anvo_tabla.comment)
If Not IsNull(ca_tejido) Then ads_tabla.SetItem(al_row,'ca_tejido',anvo_tabla.ca_tejido)
If Not IsNull(comment_cut) Then ads_tabla.SetItem(al_row,'comment_cut',anvo_tabla.comment_cut)
If Not IsNull(co_testreport) Then ads_tabla.SetItem(al_row,'co_testreport',anvo_tabla.co_testreport)
If Not IsNull(pr_gancho) Then ads_tabla.SetItem(al_row,'pr_gancho',anvo_tabla.pr_gancho)
If Not IsNull(ca_costura) Then ads_tabla.SetItem(al_row,'ca_costura',anvo_tabla.ca_costura)
If Not IsNull(ca_liberada) Then ads_tabla.SetItem(al_row,'ca_liberada',anvo_tabla.ca_liberada)
If Not IsNull(ca_comprada) Then ads_tabla.SetItem(al_row,'ca_comprada',anvo_tabla.ca_comprada)
If Not IsNull(id_mercado) Then ads_tabla.SetItem(al_row,'id_mercado',anvo_tabla.id_mercado)
If Not IsNull(co_prepack) Then ads_tabla.SetItem(al_row,'co_prepack',anvo_tabla.co_prepack)
If Not IsNull(co_proces) Then ads_tabla.SetItem(al_row,'co_proces',anvo_tabla.co_proces)
If Not IsNull(co_disenno) Then ads_tabla.SetItem(al_row,'co_disenno',anvo_tabla.co_disenno)
If Not IsNull(ca_consolidador) Then ads_tabla.SetItem(al_row,'ca_consolidador',anvo_tabla.ca_consolidador)
If Not IsNull(dim) Then ads_tabla.SetItem(al_row,'dim',anvo_tabla.dim)
If Not IsNull(ca_aud_militar) Then ads_tabla.SetItem(al_row,'ca_aud_militar',anvo_tabla.ca_aud_militar)
//If Not IsNull(ca_pedida_comprar) Then ads_tabla.SetItem(al_row,'ca_pedida_comprar',anvo_tabla.ca_pedida_comprar)
If Not IsNull(ca_inicial) Then ads_tabla.SetItem(al_row,'ca_inicial',anvo_tabla.ca_inicial)
If Not IsNull(sw_auditado) Then ads_tabla.SetItem(al_row,'sw_auditado',anvo_tabla.sw_auditado)
If Not IsNull(cs_precio) Then ads_tabla.SetItem(al_row,'cs_precio',anvo_tabla.cs_precio)
If Not IsNull(opc_ped11) Then ads_tabla.SetItem(al_row,'opc_ped11',anvo_tabla.opc_ped11)
If Not IsNull(opc_ped12) Then ads_tabla.SetItem(al_row,'opc_ped12',anvo_tabla.opc_ped12)
If Not IsNull(opc_ped13) Then ads_tabla.SetItem(al_row,'opc_ped13',anvo_tabla.opc_ped13)
If Not IsNull(opc_ped14) Then ads_tabla.SetItem(al_row,'opc_ped14',anvo_tabla.opc_ped14)
If Not IsNull(opc_ped15) Then ads_tabla.SetItem(al_row,'opc_ped15',anvo_tabla.opc_ped15)
If Not IsNull(co_coleccion) Then ads_tabla.SetItem(al_row,'co_coleccion',anvo_tabla.co_coleccion)
If Not IsNull(co_centro_distrib) Then ads_tabla.SetItem(al_row,'co_centro_distrib',anvo_tabla.co_centro_distrib)
If Not IsNull(co_division) Then ads_tabla.SetItem(al_row,'co_division',anvo_tabla.co_division)
If Not IsNull(cantidad_dpo) Then ads_tabla.SetItem(al_row,'cantidad_dpo',anvo_tabla.cantidad_dpo)
If Not IsNull(cantidad_102) Then ads_tabla.SetItem(al_row,'cantidad_102',anvo_tabla.cantidad_102)
If Not IsNull(minutos_turno) Then ads_tabla.SetItem(al_row,'minutos_turno',anvo_tabla.minutos_turno)
If Not IsNull(tiempo_estandar) Then ads_tabla.SetItem(al_row,'tiempo_estandar',anvo_tabla.tiempo_estandar)
If Not IsNull(tipo_modulo) Then ads_tabla.SetItem(al_row,'tipo_modulo',anvo_tabla.tipo_modulo)
If Not IsNull(co_curva) Then ads_tabla.SetItem(al_row,'co_curva',anvo_tabla.co_curva)
If Not IsNull(nu_personas_modulo) Then ads_tabla.SetItem(al_row,'nu_personas_modulo',anvo_tabla.nu_personas_modulo)
If Not IsNull(turnos) Then ads_tabla.SetItem(al_row,'turnos',anvo_tabla.turnos)
If Not IsNull(porc_eficiencia) Then ads_tabla.SetItem(al_row,'porc_eficiencia',anvo_tabla.porc_eficiencia)
If Not IsNull(modulos) Then ads_tabla.SetItem(al_row,'modulos',anvo_tabla.modulos)
If Not IsNull(dias) Then ads_tabla.SetItem(al_row,'dias',anvo_tabla.dias)
If Not IsNull(fe_prorroga1) Then ads_tabla.SetItem(al_row,'fe_prorroga1',anvo_tabla.fe_prorroga1)
If Not IsNull(fe_prorroga2) Then ads_tabla.SetItem(al_row,'fe_prorroga2',anvo_tabla.fe_prorroga2)
If Not IsNull(fe_prorroga3) Then ads_tabla.SetItem(al_row,'fe_prorroga3',anvo_tabla.fe_prorroga3)

Return 1
end function

on n_cst_pedpend_exp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pedpend_exp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*	---------------------------------------------------------------------------------
	Evento utilizado para llamar la funcion que inicializa las propiedades del objeto.
	--------------------------------------------------------------------------------- */

//	Inicializa todas las propiedades del objeto en nulo
This.of_reiniciar_propiedades()

end event

