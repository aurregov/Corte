HA$PBExportHeader$n_cst_peddig.sru
forward
global type n_cst_peddig from nonvisualobject
end type
end forward

global type n_cst_peddig from nonvisualobject autoinstantiate
end type

type variables
long		co_fabrica_vta
/*	--------------------------------------------
	Campos que son llave en peddig
	--------------------------------------------	*/
long		pedido
/*	-------------------------------------------	*/
string	tipo_pedido
long		co_cliente
long		co_sucursal
long		zona
long		co_vendedor
string	marca
decimal 	{2}	ca_pedida
decimal 	{2}	ca_despachada
decimal 	{2}	ca_transito
decimal 	{2}	ca_cancelada
long		ano_contable
long		mes_contable
string	orden_compra
date		fe_pedido
long		marca_edi
date		fe_transmision
long		guia_transporte
date		fe_guia_tcc
date		fe_despacho
date		fe_recepcion
date		fe_primer_dpacho
date		fe_ultimo_dpacho
date		fe_cancela_dpacho
date		fe_entrega_pltfrma
string	pr_especial
decimal	{2}	porc_permitido
string	prioridad
long	especial_packing
long		nu_desp_perm
string	pr_sugerido
long		total_cajas
long		nu_despacho
string	co_adhesivo
string	co_factura
long		co_lista
string	co_listaemp
string	estado
string	marca_adicional
date		fe_inventario
string	cambio_mes
datetime	fe_creacion
datetime	fe_actualizacion
string	usuario
string	instancia
decimal 	{2}	ca_anulada
long		co_coleccion
decimal 	{2}	ca_transito_seg
decimal 	{2}	ca_despachada_seg
string	nro_planta
string	gpa
string	isd
date		fe_cumpl_guia
string	dir_cliente_ped
string	ciudad
string	vetado
string	cunam
string	cuad1
string	cuad2
string	cucty
string	custt
string	cuzip
long		co_caja
decimal 	{2}	dcto
string	co_tipo_pedcli
string	sw_prepack
decimal 	{2}	ca_consolidador
long		co_empaque
long		co_tipo_envio
long		cs_id_persona
string	opc_ped1
string	opc_ped2
string	opc_ped3
string	opc_ped4
string	opc_ped5
string	opc_ped6
string	opc_ped7
string	opc_ped8
string	opc_ped9
string	opc_ped10
string	co_proposito_po
string	co_tipo_orden
string	nro_contrato
string	punto_transferencia
long		co_proceso
string	usuarioc
long		co_planta
long		co_tipoprod
long		sw_prioridad

end variables

forward prototypes
public function long of_reiniciar_propiedades ()
public function long of_validar_campos_auditoria (long ai_operacion)
public function long of_actualizar_estado (ref uo_dsbase ads_tabla, dwitemstatus al_status)
public function long of_registro (ref uo_dsbase ads_tabla)
public function long of_registro (ref uo_dsbase ads_tabla, n_cst_peddig anvo_tabla)
public function long of_actualizar ()
public function long of_actualizar (n_cst_peddig anvo_tabla)
public function long of_crear ()
public function long of_validar_campos_requeridos ()
public function long of_consecutivo_pedido (long ai_fabrica)
public function long of_terminar_transaccion (ref transaction atr_transaccion)
public function long of_validar_llave (long ai_operacion)
public function long of_hallar_ano_mes ()
public function long of_registrar_seguridad (ref uo_dsbase ads_registrado)
public function long of_actualizar_campos (long al_row, ref uo_dsbase ads_tabla, n_cst_peddig anvo_tabla)
end prototypes

public function long of_reiniciar_propiedades ();
/*	---------------------------------------------------------------------------------
	Funcion utilizada para inicializar las propiedades del objeto en nulo
	--------------------------------------------------------------------------------- */

//	Columnas que hacen parte de la llave se ponen en nulo
SetNull(pedido)

//	El resto de columnas tambien se ponen en nulo
SetNull(co_fabrica_vta)
SetNull(tipo_pedido)
SetNull(co_cliente)
SetNull(co_sucursal)
SetNull(zona)
SetNull(co_vendedor)
SetNull(marca)
SetNull(ca_pedida)
SetNull(ca_despachada)
SetNull(ca_transito)
SetNull(ca_cancelada)
SetNull(ano_contable)
SetNull(mes_contable)
SetNull(orden_compra)
SetNull(fe_pedido)
SetNull(marca_edi)
SetNull(fe_transmision)
SetNull(guia_transporte)
SetNull(fe_guia_tcc)
SetNull(fe_despacho)
SetNull(fe_recepcion)
SetNull(fe_primer_dpacho)
SetNull(fe_ultimo_dpacho)
SetNull(fe_cancela_dpacho)
SetNull(fe_entrega_pltfrma)
SetNull(pr_especial)
SetNull(porc_permitido)
SetNull(prioridad)
SetNull(especial_packing)
SetNull(nu_desp_perm)
SetNull(pr_sugerido)
SetNull(total_cajas)
SetNull(nu_despacho)
SetNull(co_adhesivo)
SetNull(co_factura)
SetNull(co_lista)
SetNull(co_listaemp)
SetNull(estado)
SetNull(marca_adicional)
SetNull(fe_inventario)
SetNull(cambio_mes)
SetNull(fe_creacion)
SetNull(fe_actualizacion)
SetNull(usuario)
SetNull(instancia)
SetNull(ca_anulada)
SetNull(co_coleccion)
SetNull(ca_transito_seg)
SetNull(ca_despachada_seg)
SetNull(nro_planta)
SetNull(gpa)
SetNull(isd)
SetNull(fe_cumpl_guia)
SetNull(dir_cliente_ped)
SetNull(ciudad)
SetNull(vetado)
SetNull(cunam)
SetNull(cuad1)
SetNull(cuad2)
SetNull(cucty)
SetNull(custt)
SetNull(cuzip)
SetNull(co_caja)
SetNull(dcto)
SetNull(co_tipo_pedcli)
SetNull(sw_prepack)
SetNull(ca_consolidador)
SetNull(co_empaque)
SetNull(co_tipo_envio)
SetNull(cs_id_persona)
SetNull(opc_ped1)
SetNull(opc_ped2)
SetNull(opc_ped3)
SetNull(opc_ped4)
SetNull(opc_ped5)
SetNull(opc_ped6)
SetNull(opc_ped7)
SetNull(opc_ped8)
SetNull(opc_ped9)
SetNull(opc_ped10)
SetNull(co_proposito_po)
SetNull(co_tipo_orden)
SetNull(nro_contrato)
SetNull(punto_transferencia)
SetNull(co_proceso)
SetNull(usuarioc)
SetNull(co_planta)
SetNull(co_tipoprod)
SetNull(sw_prioridad)
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
//	Se crea el datastore utilizado para 'escribir' la tabla peddig
ads_tabla = Create uo_dsbase
ads_tabla.DataObject = 'd_gr_tabla_peddig'
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

public function long of_registro (ref uo_dsbase ads_tabla, n_cst_peddig anvo_tabla);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para crear el registro de la tabla en un datastore
	a partir de la llave primaria enviada como parametro en anvo_pedido.
	Primero crea la instancia del datastore en la variable por referencia recibida y
	despues carga el registro de la B.D. con la llave enviada en anvo_pedido, al final
	se actualizan las columnas enviadas por el usuario en el registro previamente
	leido de la B.D.
	--------------------------------------------------------------------------------- */
	
//	Se crea el datastore utilizado para 'escribir' la tabla.
ads_tabla = Create uo_dsbase
ads_tabla.DataObject = 'd_gr_tabla_peddig'
ads_tabla.SetTransObject(SQLCA)

//	Registra el datastore con el manejo de seguridad de la ventana actual
This.of_registrar_seguridad(ads_tabla)

//	Si el registro no existe en el datastore, se informa al usuario y se aborta la actualizacion
If ads_tabla.Of_Retrieve(anvo_tabla.pedido) <= 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se creo el registro en memoria para ser Actualizado.")
	Return -1
End If

// Se actualizan los campos del registro
If This.Of_Actualizar_Campos(1, ads_tabla, This) < 0 Then
	Return -2
End If

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

public function long of_actualizar (n_cst_peddig anvo_tabla);
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
	se informa al usuario que no es posible un valor de estos.  Si el a$$HEX1$$f100$$ENDHEX$$o y el mes
	no son facilitados por el usuario o son negativos, se hallan usando la fabrica 
	del pedido.	  Algunos campos que son obligatorios en la B.D. en caso de que el 
	usuario no proporcione sus valores son inicializados por defecto.
	--------------------------------------------------------------------------------- */

If IsNull(This.tipo_pedido) Or Trim(This.tipo_pedido) = '' Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'tipo_pedido' no puede ser nulo o vacio.", StopSign!)
	Return -1	
End If

If Trim(This.tipo_pedido) <> 'AC' And Trim(This.tipo_pedido) <> 'AP' Then
	If IsNull(This.co_cliente) Or This.co_cliente < 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'co_cliente' no puede ser nulo o menor a cero(0).", StopSign!)
		Return -2	
	End If	
	
	If IsNull(This.co_sucursal) Or This.co_sucursal < 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'co_sucursal' no puede ser nulo o menor a cero(0).", StopSign!)
		Return -3	
	End If

	If IsNull(This.co_coleccion) Or This.co_coleccion <= 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'co_coleccion' no puede ser nulo o menor o igual a cero(0).", StopSign!)
	End If
	
	If IsNull(This.usuarioc) Or Len(Trim(This.usuarioc)) = 0 Then
		This.usuarioc = This.usuario
	End If
	
End If


//	Si el a$$HEX1$$f100$$ENDHEX$$o y mes no son suministrados o alguno de estos valores es negativo
//	se llama la funcion que halla el a$$HEX1$$f100$$ENDHEX$$o y mes del usuario actual
If IsNull(This.ano_contable) Or This.ano_contable < 0 Or IsNull(This.mes_contable) Or This.mes_contable < 0 Then
	//	Si la funcion de hallar el a$$HEX1$$f100$$ENDHEX$$o mes falla, falla la validacion
	If of_hallar_ano_mes() < 0 Then Return -4
End If

//	Si el usuario no proporciona estos campos obligatorios, son inicializados por defecto
// en valores estandar para la mayoria de pedidos creados
If IsNull(This.zona) Then This.zona = 0

If IsNull(This.co_vendedor) Then This.co_vendedor = 0

If IsNull(This.marca) Then This.marca = '0'

If IsNull(This.ca_pedida) Then This.ca_pedida = 0

If IsNull(This.ca_despachada) Then This.ca_despachada = 0

If IsNull(This.ca_transito) Then This.ca_transito = 0

If IsNull(This.ca_cancelada) Then This.ca_cancelada = 0

If IsNull(This.fe_pedido) Then This.fe_pedido = Today()

If IsNull(This.marca_edi) Then This.marca_edi = 0

If IsNull(This.fe_recepcion) Then This.fe_recepcion = Today()

If IsNull(This.pr_especial) Then This.pr_especial = 'SI'

If IsNull(This.porc_permitido) Then This.porc_permitido = 100

If IsNull(This.especial_packing) Then This.especial_packing = 0

If IsNull(This.nu_desp_perm) Then This.nu_desp_perm = 100

If IsNull(This.total_cajas) Then This.total_cajas = 0

If IsNull(This.co_lista) Then This.co_lista = 0

If IsNull(This.gpa) Then This.gpa = '0'

//	Algunos campos adicionales no obligatorios, tambien son inicializados
If IsNull(This.co_adhesivo) Then This.co_adhesivo = '2'

If IsNull(This.estado) Then This.estado = 'D'

If IsNull(This.co_tipoprod) Then This.co_tipoprod = 1

If IsNull(This.usuarioc) Then This.usuarioc = This.usuario

Return 1
end function

public function long of_consecutivo_pedido (long ai_fabrica);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo en la tabla de 
	cf_consecutivos_ean.   Recibe como argumento ai_fabrica.
	-----------------------------------------------------------------*/
Long ll_consecutivo, ll_incremento
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
ltr_transaccion.Dbms 		= SQLCA.DBMS
ltr_transaccion.Database	= SQLCA.DATABASE
ltr_transaccion.Userid		= SQLCA.USERID
ltr_transaccion.Dbpass		= SQLCA.DBPASS
ltr_transaccion.Dbparm		= SQLCA.DBPARM
ltr_transaccion.Servername	= SQLCA.ServerName
ltr_transaccion.Lock			= SQLCA.Lock

Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return -4
Else
	Select nu_enque_esta, incremento
		Into :ll_consecutivo, :ll_incremento
			From cf_consecutivos_ean 
				Where co_fabrica = 2 And tipo = 'EX' Using ltr_transaccion;
	If ltr_transaccion.sqlcode = -1 Then
		If ltr_transaccion.sqldbcode = -244 Then
			Post MessageBox("Error de Base de Datos","Tabla de Consecutivos Bloqueada Temporalmente" &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			
		Else
			Post MessageBox("Error de Base de Datos","Imposible saber el consecutivo actual" &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
		End if
		This.of_terminar_transaccion(ltr_transaccion)
		Return -1
	ElseIf ltr_transaccion.sqlcode = 100 Then
		Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo hallar el numero del consecutivo porque no " &
							+ "se ha parametrizado el consecutivo (Fab: " + String(ai_fabrica) &
							+ " Tipo EX) en cf_consecutivos_ean.   " &
							+ "~r~nPor favor comunicarse con informatica.")
		Return -5		
	Else
		ll_consecutivo += ll_incremento
		Update cf_consecutivos_ean 
			Set nu_enque_esta = :ll_consecutivo 
				Where co_fabrica = 2 And tipo = 'EX' Using ltr_transaccion;
		If ltr_transaccion.SQLCode = -1 Then
			Post MessageBox("Error de Base de Datos","Imposible actualizar el consecutivo"&
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			This.of_terminar_transaccion(ltr_transaccion)
			Return -2
		Else
			Commit Using ltr_transaccion;
			If ltr_transaccion.SQLCode = -1 Then
				RollBack Using ltr_transaccion;
				Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
							+ 'El consecutivo no ha sido almacenado en la Base de Datos.' &
							+ '~nPor favor avise al Administrador del Sistema.')
				This.of_terminar_transaccion(ltr_transaccion)
				Return -3
			End If
		End If
	End If
	Disconnect Using ltr_transaccion;
End If

Destroy ltr_transaccion
Return ll_consecutivo
end function

public function long of_terminar_transaccion (ref transaction atr_transaccion);/*	---------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que se desconecta del objeto de transacci$$HEX1$$f300$$ENDHEX$$n enviado como
	argumento atr_transaccion y luego destruye la isntancia de memoria.
	---------------------------------------------------------------------*/
Disconnect Using atr_transaccion;
Destroy atr_transaccion

Return 1
end function

public function long of_validar_llave (long ai_operacion);
/*	---------------------------------------------------------------------------------
	Funcion utilizada para verificar la existencia de una llave primaria valida.
	Si algun campo de la llave primaria es nulo o negativo se informa al usuario que 
	no es posible un valor de estos por cuanto el campo es un campo que hace parte 
	de la llave primaria.  El parametro ai_operacion indica si el 
	llamado a la funcion es desde la creacion (0) o la actualizacion(1) del registro.
	--------------------------------------------------------------------------------- */

If IsNull(This.co_fabrica_vta) Or This.co_fabrica_vta <= 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'co_fabrica_vta' no puede ser nulo, vacio o negativo.", StopSign!)
	Return -1	
End If

If ai_operacion = 1 Then
	If IsNull(This.pedido) Or This.pedido <= 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'pedido' no puede ser nulo o negativo porque hace parte de la llave primaria.", StopSign!)
		Return -1	
	End If	
Else
	This.pedido = This.of_consecutivo_pedido(This.co_fabrica_vta)
	If This.pedido <= 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fall$$HEX2$$f3002000$$ENDHEX$$la creaci$$HEX1$$f300$$ENDHEX$$n del pedido.",StopSign!)
		Return -1
	End If
	
	//	Si el usuario no suministra ninguna PO 
	If IsNull(This.orden_compra) Or Len(Trim(This.orden_compra)) = 0 Then 
		//se pone en su lugar el pedido recien creado si el pedido es un allocation
		If tipo_pedido = 'AC' Or tipo_pedido = 'AP' Then
			This.orden_compra = String(This.pedido)
		Else
		// Si no es un allocation se muestra un mensaje de error
			MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor del campo 'orden_compra' no puede ser nulo o vacio.", StopSign!)
			Return -1
		End If
	End If
End If

Return 1
end function

public function long of_hallar_ano_mes ();
/*	---------------------------------------------------------------------------------
	Funcion utilizada para hallar el a$$HEX1$$f100$$ENDHEX$$o y mes del usuario actual.
	--------------------------------------------------------------------------------- */
uo_dsbase lds_ano_mes

//	Se crea un datastore para consultar la tabla cf_user y traer el a$$HEX1$$f100$$ENDHEX$$o y mes del usuario
lds_ano_mes = Create uo_dsbase
lds_ano_mes.DataObject = 'd_gr_hallar_ano_mes'
lds_ano_mes.SetTransObject(SQLCA)

//	Si no se logro traer el a$$HEX1$$f100$$ENDHEX$$o mes del usuario informa al usuario y falla
If lds_ano_mes.Of_Retrieve(This.co_fabrica_vta) <= 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible hallar el a$$HEX1$$f100$$ENDHEX$$o y mes del usuario actual.")
	Return -1
End If

//	Pone el a$$HEX1$$f100$$ENDHEX$$o y mes hallados a las propiedades del objeto
This.ano_contable = lds_ano_mes.GetItemNumber(1,'ano')
This.mes_contable = lds_ano_mes.GetItemNumber(1,'mes')

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

public function long of_actualizar_campos (long al_row, ref uo_dsbase ads_tabla, n_cst_peddig anvo_tabla);/*	---------------------------------------------------------------------------------
	Funcion utilizada para actualizar los campos de un registro de la tabla en un datastore.
	se actualizan las columnas enviadas por el usuario en el registro al_row del datastore.
	--------------------------------------------------------------------------------- */
	
// Se valida que sea vaido el datastore y el objeto
If Not IsValid(ads_tabla) Or Not IsValid(anvo_tabla) Then Return -1

// Se valida que al_row no sea mayor que el tama$$HEX1$$f100$$ENDHEX$$o del datastore
If ads_tabla.RowCount() < al_row Then Return -2

If Not IsNull(co_fabrica_vta) Then ads_tabla.SetItem(al_row,'co_fabrica_vta',anvo_tabla.co_fabrica_vta)
If Not IsNull(pedido) Then ads_tabla.SetItem(al_row,'pedido',anvo_tabla.pedido)
If Not IsNull(tipo_pedido) Then ads_tabla.SetItem(al_row,'tipo_pedido',anvo_tabla.tipo_pedido)
If Not IsNull(co_cliente) Then ads_tabla.SetItem(al_row,'co_cliente',anvo_tabla.co_cliente)
If Not IsNull(co_sucursal) Then ads_tabla.SetItem(al_row,'co_sucursal',anvo_tabla.co_sucursal)
If Not IsNull(zona) Then ads_tabla.SetItem(al_row,'zona',anvo_tabla.zona)
If Not IsNull(co_vendedor) Then ads_tabla.SetItem(al_row,'co_vendedor',anvo_tabla.co_vendedor)
If Not IsNull(marca) Then ads_tabla.SetItem(al_row,'marca',anvo_tabla.marca)
If Not IsNull(ca_pedida) Then ads_tabla.SetItem(al_row,'ca_pedida',anvo_tabla.ca_pedida)
If Not IsNull(ca_despachada) Then ads_tabla.SetItem(al_row,'ca_despachada',anvo_tabla.ca_despachada)
If Not IsNull(ca_transito) Then ads_tabla.SetItem(al_row,'ca_transito',anvo_tabla.ca_transito)
If Not IsNull(ca_cancelada) Then ads_tabla.SetItem(al_row,'ca_cancelada',anvo_tabla.ca_cancelada)
If Not IsNull(ano_contable) Then ads_tabla.SetItem(al_row,'ano_contable',anvo_tabla.ano_contable)
If Not IsNull(mes_contable) Then ads_tabla.SetItem(al_row,'mes_contable',anvo_tabla.mes_contable)
If Not IsNull(orden_compra) Then ads_tabla.SetItem(al_row,'orden_compra',anvo_tabla.orden_compra)
If Not IsNull(fe_pedido) Then ads_tabla.SetItem(al_row,'fe_pedido',anvo_tabla.fe_pedido)
If Not IsNull(marca_edi) Then ads_tabla.SetItem(al_row,'marca_edi',anvo_tabla.marca_edi)
If Not IsNull(fe_transmision) Then ads_tabla.SetItem(al_row,'fe_transmision',anvo_tabla.fe_transmision)
If Not IsNull(guia_transporte) Then ads_tabla.SetItem(al_row,'guia_transporte',anvo_tabla.guia_transporte)
If Not IsNull(fe_guia_tcc) Then ads_tabla.SetItem(al_row,'fe_guia_tcc',anvo_tabla.fe_guia_tcc)
If Not IsNull(fe_despacho) Then ads_tabla.SetItem(al_row,'fe_despacho',anvo_tabla.fe_despacho)
If Not IsNull(fe_recepcion) Then ads_tabla.SetItem(al_row,'fe_recepcion',anvo_tabla.fe_recepcion)
If Not IsNull(fe_primer_dpacho) Then ads_tabla.SetItem(al_row,'fe_primer_dpacho',anvo_tabla.fe_primer_dpacho)
If Not IsNull(fe_ultimo_dpacho) Then ads_tabla.SetItem(al_row,'fe_ultimo_dpacho',anvo_tabla.fe_ultimo_dpacho)
If Not IsNull(fe_cancela_dpacho) Then ads_tabla.SetItem(al_row,'fe_cancela_dpacho',anvo_tabla.fe_cancela_dpacho)
If Not IsNull(fe_entrega_pltfrma) Then ads_tabla.SetItem(al_row,'fe_entrega_pltfrma',anvo_tabla.fe_entrega_pltfrma)
If Not IsNull(pr_especial) Then ads_tabla.SetItem(al_row,'pr_especial',anvo_tabla.pr_especial)
If Not IsNull(porc_permitido) Then ads_tabla.SetItem(al_row,'porc_permitido',anvo_tabla.porc_permitido)
If Not IsNull(prioridad) Then ads_tabla.SetItem(al_row,'prioridad',anvo_tabla.prioridad)
If Not IsNull(especial_packing) Then ads_tabla.SetItem(al_row,'especial_packing',anvo_tabla.especial_packing)
If Not IsNull(nu_desp_perm) Then ads_tabla.SetItem(al_row,'nu_desp_perm',anvo_tabla.nu_desp_perm)
If Not IsNull(pr_sugerido) Then ads_tabla.SetItem(al_row,'pr_sugerido',anvo_tabla.pr_sugerido)
If Not IsNull(total_cajas) Then ads_tabla.SetItem(al_row,'total_cajas',anvo_tabla.total_cajas)
If Not IsNull(nu_despacho) Then ads_tabla.SetItem(al_row,'nu_despacho',anvo_tabla.nu_despacho)
If Not IsNull(co_adhesivo) Then ads_tabla.SetItem(al_row,'co_adhesivo',anvo_tabla.co_adhesivo)
If Not IsNull(co_factura) Then ads_tabla.SetItem(al_row,'co_factura',anvo_tabla.co_factura)
If Not IsNull(co_lista) Then ads_tabla.SetItem(al_row,'co_lista',anvo_tabla.co_lista)
If Not IsNull(co_listaemp) Then ads_tabla.SetItem(al_row,'co_listaemp',anvo_tabla.co_listaemp)
If Not IsNull(estado) Then ads_tabla.SetItem(al_row,'estado',anvo_tabla.estado)
If Not IsNull(marca_adicional) Then ads_tabla.SetItem(al_row,'marca_adicional',anvo_tabla.marca_adicional)
If Not IsNull(fe_inventario) Then ads_tabla.SetItem(al_row,'fe_inventario',anvo_tabla.fe_inventario)
If Not IsNull(cambio_mes) Then ads_tabla.SetItem(al_row,'cambio_mes',anvo_tabla.cambio_mes)
If Not IsNull(fe_creacion) Then ads_tabla.SetItem(al_row,'fe_creacion',anvo_tabla.fe_creacion)
If Not IsNull(fe_actualizacion) Then ads_tabla.SetItem(al_row,'fe_actualizacion',anvo_tabla.fe_actualizacion)
If Not IsNull(usuario) Then ads_tabla.SetItem(al_row,'usuario',anvo_tabla.usuario)
If Not IsNull(instancia) Then ads_tabla.SetItem(al_row,'instancia',anvo_tabla.instancia)
If Not IsNull(ca_anulada) Then ads_tabla.SetItem(al_row,'ca_anulada',anvo_tabla.ca_anulada)
If Not IsNull(co_coleccion) Then ads_tabla.SetItem(al_row,'co_coleccion',anvo_tabla.co_coleccion)
If Not IsNull(ca_transito_seg) Then ads_tabla.SetItem(al_row,'ca_transito_seg',anvo_tabla.ca_transito_seg)
If Not IsNull(ca_despachada_seg) Then ads_tabla.SetItem(al_row,'ca_despachada_seg',anvo_tabla.ca_despachada_seg)
If Not IsNull(nro_planta) Then ads_tabla.SetItem(al_row,'nro_planta',anvo_tabla.nro_planta)
If Not IsNull(gpa) Then ads_tabla.SetItem(al_row,'gpa',anvo_tabla.gpa)
If Not IsNull(isd) Then ads_tabla.SetItem(al_row,'isd',anvo_tabla.isd)
If Not IsNull(fe_cumpl_guia) Then ads_tabla.SetItem(al_row,'fe_cumpl_guia',anvo_tabla.fe_cumpl_guia)
If Not IsNull(dir_cliente_ped) Then ads_tabla.SetItem(al_row,'dir_cliente_ped',anvo_tabla.dir_cliente_ped)
If Not IsNull(ciudad) Then ads_tabla.SetItem(al_row,'ciudad',anvo_tabla.ciudad)
If Not IsNull(vetado) Then ads_tabla.SetItem(al_row,'vetado',anvo_tabla.vetado)
If Not IsNull(cunam) Then ads_tabla.SetItem(al_row,'cunam',anvo_tabla.cunam)
If Not IsNull(cuad1) Then ads_tabla.SetItem(al_row,'cuad1',anvo_tabla.cuad1)
If Not IsNull(cuad2) Then ads_tabla.SetItem(al_row,'cuad2',anvo_tabla.cuad2)
If Not IsNull(cucty) Then ads_tabla.SetItem(al_row,'cucty',anvo_tabla.cucty)
If Not IsNull(custt) Then ads_tabla.SetItem(al_row,'custt',anvo_tabla.custt)
If Not IsNull(cuzip) Then ads_tabla.SetItem(al_row,'cuzip',anvo_tabla.cuzip)
If Not IsNull(co_caja) Then ads_tabla.SetItem(al_row,'co_caja',anvo_tabla.co_caja)
If Not IsNull(dcto) Then ads_tabla.SetItem(al_row,'dcto',anvo_tabla.dcto)
If Not IsNull(co_tipo_pedcli) Then ads_tabla.SetItem(al_row,'co_tipo_pedcli',anvo_tabla.co_tipo_pedcli)
If Not IsNull(sw_prepack) Then ads_tabla.SetItem(al_row,'sw_prepack',anvo_tabla.sw_prepack)
If Not IsNull(ca_consolidador) Then ads_tabla.SetItem(al_row,'ca_consolidador',anvo_tabla.ca_consolidador)
If Not IsNull(co_empaque) Then ads_tabla.SetItem(al_row,'co_empaque',anvo_tabla.co_empaque)
If Not IsNull(co_tipo_envio) Then ads_tabla.SetItem(al_row,'co_tipo_envio',anvo_tabla.co_tipo_envio)
If Not IsNull(cs_id_persona) Then ads_tabla.SetItem(al_row,'cs_id_persona',anvo_tabla.cs_id_persona)
If Not IsNull(opc_ped1) Then ads_tabla.SetItem(al_row,'opc_ped1',anvo_tabla.opc_ped1)
If Not IsNull(opc_ped2) Then ads_tabla.SetItem(al_row,'opc_ped2',anvo_tabla.opc_ped2)
If Not IsNull(opc_ped3) Then ads_tabla.SetItem(al_row,'opc_ped3',anvo_tabla.opc_ped3)
If Not IsNull(opc_ped4) Then ads_tabla.SetItem(al_row,'opc_ped4',anvo_tabla.opc_ped4)
If Not IsNull(opc_ped5) Then ads_tabla.SetItem(al_row,'opc_ped5',anvo_tabla.opc_ped5)
If Not IsNull(opc_ped6) Then ads_tabla.SetItem(al_row,'opc_ped6',anvo_tabla.opc_ped6)
If Not IsNull(opc_ped7) Then ads_tabla.SetItem(al_row,'opc_ped7',anvo_tabla.opc_ped7)
If Not IsNull(opc_ped8) Then ads_tabla.SetItem(al_row,'opc_ped8',anvo_tabla.opc_ped8)
If Not IsNull(opc_ped9) Then ads_tabla.SetItem(al_row,'opc_ped9',anvo_tabla.opc_ped9)
If Not IsNull(opc_ped10) Then ads_tabla.SetItem(al_row,'opc_ped10',anvo_tabla.opc_ped10)
If Not IsNull(co_proposito_po) Then ads_tabla.SetItem(al_row,'co_proposito_po',anvo_tabla.co_proposito_po)
If Not IsNull(co_tipo_orden) Then ads_tabla.SetItem(al_row,'co_tipo_orden',anvo_tabla.co_tipo_orden)
If Not IsNull(nro_contrato) Then ads_tabla.SetItem(al_row,'nro_contrato',anvo_tabla.nro_contrato)
If Not IsNull(punto_transferencia) Then ads_tabla.SetItem(al_row,'punto_transferencia',anvo_tabla.punto_transferencia)
If Not IsNull(co_proceso) Then ads_tabla.SetItem(al_row,'co_proceso',anvo_tabla.co_proceso)
If Not IsNull(usuarioc) Then ads_tabla.SetItem(al_row,'usuarioc',anvo_tabla.usuarioc)
If Not IsNull(co_planta) Then ads_tabla.SetItem(al_row,'co_planta',anvo_tabla.co_planta)
If Not IsNull(co_tipoprod) Then ads_tabla.SetItem(al_row,'co_tipoprod',anvo_tabla.co_tipoprod)
If Not IsNull(sw_prioridad) Then ads_tabla.SetItem(al_row,'sw_prioridad',anvo_tabla.sw_prioridad)


Return 1
end function

on n_cst_peddig.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_peddig.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*	---------------------------------------------------------------------------------
	Evento utilizado para llamar la funcion que inicializa las propiedades del objeto.
	--------------------------------------------------------------------------------- */

//	Inicializa todas las propiedades del objeto en nulo
This.of_reiniciar_propiedades()

end event

