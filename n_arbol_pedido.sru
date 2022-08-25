HA$PBExportHeader$n_arbol_pedido.sru
$PBExportComments$Objeto que maneja el arbol del pedido
forward
global type n_arbol_pedido from nonvisualobject
end type
end forward

global type n_arbol_pedido from nonvisualobject autoinstantiate
end type

type variables
Long co_fabrica_padre
Long pedido_padre

Long co_fabrica_hijo
Long pedido_hijo

Long co_fabrica_raiz
Long pedido_raiz

Long nivel
String tipo_pedido
Decimal ca_pedida, cantidad_102, cantidad_dpo, porc_eficiencia

Long co_fabrica
Long co_linea
Long co_referencia



end variables

forward prototypes
public function long of_mostrar_arbol (long al_pedido, ref treeview atv_arbol)
private function long of_cambiar_padre (long pedido_old, long pedido_new)
public function long of_crear_nodo ()
public function long of_reiniciar_propiedades ()
public function long of_get_raiz ()
private function long of_set_raiz ()
public function long of_reconstruir_allocation ()
public function long of_obtener_raiz_activa ()
public function long of_actualizar_nodo (ref n_arbol_pedido anvo_arbol)
public function long of_insertar_items (ref uo_dsbase ads_arbol, long al_padre, ref treeview atv_arbol, long al_pedido_padre)
public function long of_registrar_seguridad (ref uo_dsbase ads_registrado)
public function long of_borrar_nodo (n_arbol_pedido anvo_arbol)
end prototypes

public function long of_mostrar_arbol (long al_pedido, ref treeview atv_arbol);/* ----------------------------------------------------------------------------------
	Funcion para mostrar los datos en un treeview
	Se Trae los datos del arbol y se llena el treeview con dicha informacion
---------------------------------------------------------------------------------- */

uo_dsbase lds_arbol
Long ll_rows

lds_arbol = Create uo_dsbase
lds_arbol.DataObject = "d_gr_arbol_pedido"
lds_arbol.SettransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )
This.of_registrar_seguridad( lds_arbol )
ll_rows = lds_arbol.Of_Retrieve(al_pedido)
If ll_rows < 0 Then 
	ROLLBACK;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n!','Error en la base de datos la traer la informacion del arbol del pedido ~r~n~n' + lds_arbol.is_SqlErrText )	
ElseIf ll_rows > 0 Then
	nivel = -1
	ll_rows =  This.Of_Insertar_Items ( lds_arbol, 0, atv_arbol, 0)	
End If
Destroy (lds_arbol)
Return ll_rows
end function

private function long of_cambiar_padre (long pedido_old, long pedido_new);/*
	Funcion Utilizada para cambiar el padre de un nodo del arbol.
	Se utiliza para bajar de nivel a las po considerando que estas
	deben estar en ultimo nivel.
*/
uo_dsbase lds_arbol
Long li_retorno, li_i
lds_arbol = Create uo_dsbase
lds_arbol.DataObject = "d_gr_arbol_nivel"
lds_arbol.SettransObject( SQLCA)
li_retorno = lds_arbol.Retrieve(pedido_old)
// Si trae datos se cambia el padre y se incrementa el nivel
If li_retorno > 0 Then
	For li_i = 1 to li_retorno		
		lds_arbol.SetItem(li_i, 'pedido_padre', pedido_new)
		lds_arbol.SetItem(li_i, 'nivel', lds_arbol.GetItemNumber(li_i,'nivel') + 1)
	Next
	li_retorno = lds_arbol.Of_Update()
	If li_retorno <> 1 Then
		Messagebox ('Error', 'Error en la base de datos al crear el arbol')
	End IF	
End If
Destroy(lds_arbol)
Return li_retorno
end function

public function long of_crear_nodo ();/* -------------------------------------------------------------------------------------
Funcion utilizada para crear un nuevo nodo en el arbol.
Se obtiene la raiz del arbol (allocation ancestro), y se inserta el nuevo
nodo dentro del arbol.
------------------------------------------------------------------------------------- */

uo_dsbase lds_arbol, lds_arbol_registro_existe
Long li_retorno
Long ll_i

lds_arbol_registro_existe = Create uo_dsbase
lds_arbol_registro_existe.DataObject = "d_gr_arbol_pedido_existe"
lds_arbol_registro_existe.SettransObject( SQLCA)
If lds_arbol_registro_existe.Of_Retrieve( pedido_hijo, co_fabrica, co_linea, co_referencia) < 0  Then
	ROLLBACK;
	MessageBox('Atencion!','Error al consultar el arbol del pedido en la base de datos')
	li_retorno = -1
ElseIf lds_arbol_registro_existe.GetItemNumber(1,'existe') = 1 Then 
	li_retorno = 0
Else
	// Se instancia el datastore y se trae la raiz del arbol
	lds_arbol = Create uo_dsbase
	lds_arbol.DataObject = "d_gr_arbol_pedido"
	lds_arbol.SettransObject( SQLCA)
	This.Of_Registrar_Seguridad( lds_arbol )
	li_retorno = This.Of_Set_Raiz( )
	// si no hay error
	If li_retorno >= 0 Then	
		// se inserta un nuevo registro para agregar un nuevo nodo
		ll_i = lds_arbol.InsertRow(0)
		If IsNull(co_fabrica_padre) Then
			lds_arbol.SetItem(ll_i,'co_fabrica_padre', co_fabrica_raiz)
		Else
			lds_arbol.SetItem(ll_i,'co_fabrica_padre', co_fabrica_padre)
		End If
		lds_arbol.SetItem(ll_i,'pedido_padre', pedido_padre)
		lds_arbol.SetItem(ll_i,'tipo_pedido', tipo_pedido)
		lds_arbol.SetItem(ll_i,'ca_pedida', ca_pedida)
		lds_arbol.SetItem(ll_i,'cantidad_102', cantidad_102)
		lds_arbol.SetItem(ll_i,'cantidad_dpo', cantidad_dpo)
		lds_arbol.SetItem(ll_i,'porc_eficiencia', porc_eficiencia )		
		lds_arbol.SetItem(ll_i,'co_fabrica', co_fabrica)
		lds_arbol.SetItem(ll_i,'co_linea', co_linea)
		lds_arbol.SetItem(ll_i,'co_referencia', co_referencia)	
		lds_arbol.SetItem(ll_i,'fe_creacion', f_fecha_servidor() )
		
		
		// si existe el arbol
		If li_retorno = 1 Then
			lds_arbol.SetItem(ll_i,'co_fabrica_hijo', co_fabrica_hijo)
			lds_arbol.SetItem(ll_i,'pedido_hijo', pedido_hijo)
			lds_arbol.SetItem(ll_i,'co_fabrica_raiz', co_fabrica_raiz)
			lds_arbol.SetItem(ll_i,'pedido_raiz', pedido_raiz)
			lds_arbol.SetItem(ll_i,'nivel', nivel + 1)
	//		If tipo_pedido = 'AP' Then
	//			 li_retorno = of_cambiar_padre( pedido_padre, pedido_hijo)	
	//		End IF				
		Else // sino se crea el nuevo arbol
			lds_arbol.SetItem(ll_i,'co_fabrica_raiz', co_fabrica_hijo)
			lds_arbol.SetItem(ll_i,'pedido_raiz', pedido_padre)
			lds_arbol.SetItem(ll_i,'co_fabrica_hijo', co_fabrica_padre)
			lds_arbol.SetItem(ll_i,'pedido_hijo', pedido_padre)
			lds_arbol.SetItem(ll_i,'nivel', 0 )
		End If	
		// se valida la actualizacion no tenga errores
		If lds_arbol.Of_Update() = 1 And li_retorno >= 0 Then		
			li_retorno = 1
		Else
			ROLLBACK;
			li_retorno = -1
		End If
		
	End If
End If
Destroy(lds_arbol)
Destroy (lds_arbol_registro_existe)

Return li_retorno
end function

public function long of_reiniciar_propiedades ();SetNull(co_fabrica)
SetNull(co_linea)
SetNull(co_referencia)

SetNull(co_fabrica_padre)
SetNull(pedido_padre)

SetNull(co_fabrica_hijo)
SetNull(pedido_hijo)

SetNull(co_fabrica_raiz)
SetNull(pedido_raiz)


SetNull(nivel)
SetNull(tipo_pedido)
SetNull(ca_pedida)
SetNull(cantidad_102)
SetNull(cantidad_dpo)
SetNull(porc_eficiencia)
Return 1
end function

public function long of_get_raiz ();/* ----------------------------------------------------------------------------------
Funcion para obtiener la raiz de un pedido.
Se consulta a la BD y se retorna el pedido raiz, 
en caso de no estar en la BD se devuelve el mismo pedido como raiz

---------------------------------------------------------------------------------- */
pedido_padre = pedido_hijo
Return This.Of_Set_Raiz( )


end function

private function long of_set_raiz ();/* ----------------------------------------------------------------------------------
obtiene la raiz de un pedido e inicializa las variables de instancia.
Consulta el pedido en la Bd y si existe inicializa las variables de 
instancia.
---------------------------------------------------------------------------------- */
Long ll_rows
uo_dsbase lds_arbol
lds_arbol = Create uo_dsbase
lds_arbol.DataObject = "d_gr_arbol_raiz"
lds_arbol.SettransObject( gnv_recursos.of_get_transaccion_sucia( ) )
ll_rows = lds_arbol.Of_Retrieve( pedido_padre, co_fabrica, co_linea, co_referencia)
if ll_rows < 0 Then
	ROLLBACK;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo cargar la informaci$$HEX1$$f300$$ENDHEX$$n de la base de datos")
Elseif ll_rows = 1 Then
	co_fabrica_raiz = lds_arbol.GetItemNumber(1,'co_fabrica_raiz')	
	pedido_raiz = lds_arbol.GetItemNumber(1,'pedido_raiz')	
	nivel = lds_arbol.GetItemNumber(1,'nivel')
	If tipo_pedido <> 'AC' and tipo_pedido <> 'AP' Then
		porc_eficiencia = lds_arbol.GetItemNumber(1,'porc_eficiencia')
	End If
Else
	co_fabrica_raiz = co_fabrica_hijo	
	pedido_raiz = pedido_hijo
	co_fabrica_padre = co_fabrica_hijo
	pedido_padre = pedido_hijo
	nivel = 0
End If
Destroy(lds_arbol)
Return ll_rows
end function

public function long of_reconstruir_allocation ();/* ----------------------------------------------------------------------------------
Funci$$HEX1$$f300$$ENDHEX$$n utilizada para recalcular la cantidad que esta porgramada de un allocation
---------------------------------------------------------------------------------- */

uo_dsbase lds_arbol, lds_raiz, lds_simulacion, lds_pedido, lds_pedidos_reales
Long li_filas, li_retorno
Long ll_pedido_allocation, ll_row, ll_filas
Decimal ldc_ca_programada, ldc_ca_programada_po, ldc_tiempo_po, ldc_estandar, &
		ldc_programada, ldc_ca_pedida, ldc_tiempo_pedido

ldc_ca_programada = 0
lds_raiz = Create uo_dsbase
lds_raiz.DataObject = "d_gr_arbol_raiz"
lds_raiz.SettransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )

lds_simulacion = Create uo_dsbase
lds_simulacion.DataObject = "d_gr_total_po_pdp"
lds_simulacion.SettransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )


lds_pedido = Create uo_dsbase
lds_pedido.DataObject = "d_gr_consistencia_pedidos"
lds_pedido.SettransObject( SQLCA )


lds_pedidos_reales = Create uo_dsbase
lds_pedidos_reales.DataObject = "d_gr_consistencia_pedidos"
lds_pedidos_reales.SettransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )

// Se cargan los datos del pedido
ll_filas = lds_pedido.Of_Retrieve( pedido_hijo ) 
Choose Case ll_filas
	Case Is > 0 
		co_fabrica = 0
		co_linea = 0
		co_referencia = 0
		// se busca la raiz del arbol
		ll_filas = lds_raiz.Of_Retrieve( pedido_hijo, co_fabrica, co_linea, co_referencia)		
		
		Choose Case ll_filas
			Case Is > 0	// lo encontro		
				ll_pedido_allocation = pedido_hijo		
				
				co_fabrica_raiz = lds_raiz.GetItemNumber(1,'co_fabrica_raiz')	
				pedido_raiz = lds_raiz.GetItemNumber(1,'pedido_raiz')	
				nivel = lds_raiz.GetItemNumber(1,'nivel')
		 
				lds_arbol = Create uo_dsbase
				lds_arbol.DataObject = "d_gr_arbol_pedido"
				lds_arbol.SetTransObject( SQLCA ) 
				// se carga el arbol del pedido
				// se carga el arbol del pedido
				li_retorno = lds_arbol.Of_Retrieve(pedido_raiz) 
				iF li_retorno < 0 Then
					ROLLBACK;
				ElseIf li_retorno = 0 Then					
					li_retorno = -1
				Else
					lds_arbol.SetFilter("pedido_hijo = " + String(ll_pedido_allocation))
					lds_arbol.Filter()
					
					porc_eficiencia = lds_arbol.GetItemNumber(1,'porc_eficiencia')
					// se filtran los pedidos allocation y se dejan solo los reales
					lds_arbol.SetFilter("tipo_pedido NOT IN ('AC','AP')")
					lds_arbol.Filter()
					ldc_tiempo_po = 0
				End If				
				
				// se recorre los pedidos
				For ll_row = 1 To lds_arbol.Rowcount( )
					// se cargan los datos del pedido real en el pdp
					pedido_hijo = lds_arbol.GetItemNumber( ll_row, 'pedido_hijo')	
					co_fabrica = lds_arbol.GetItemNumber( ll_row, 'co_fabrica')	
					co_linea = lds_arbol.GetItemNumber( ll_row, 'co_linea')				
					co_referencia = lds_arbol.GetItemNumber( ll_row, 'co_referencia')			
					
					If porc_eficiencia <> lds_arbol.GetItemNumber(ll_row,'porc_eficiencia') Or IsNull(lds_arbol.GetItemNumber(ll_row,'porc_eficiencia')) Then
						lds_arbol.SetItem(ll_row,'porc_eficiencia', porc_eficiencia)
					End If
					
					If lds_simulacion.Of_retrieve( pedido_hijo, co_fabrica, co_linea, co_referencia, 0) < 0 Then
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error en la Base de Datos al consultar la PDP')
						Exit
						li_retorno = -1
					End If
					// se obtiene la cantidad y el estandar del pedido
					ldc_ca_programada_po = lds_simulacion.GetItemNumber(1, 'ca_programada')
					ldc_estandar = lds_simulacion.GetItemNumber(1, 'tiempo_estandar')
					// si no son nulos o negativos se acumula en la cantidad reservada
					// y el tiempo reservado
					If ldc_ca_programada_po > 0 And ldc_estandar > 0 Then
						ldc_ca_programada += ldc_ca_programada_po
						ldc_tiempo_po += ldc_ca_programada_po * ldc_estandar
					End If
					// Si la cantidad es cero se verifica *****
					// Se desactiva por la implementacion de la Justificacion.
					If ldc_ca_programada_po = 0 Or IsNull(ldc_ca_programada_po) And 1=0 Then						
						If lds_pedidos_reales.Of_Retrieve( pedido_hijo ) < 0 Then
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error en la Base de Datos al consultar la PDP')
							li_retorno = -1
							Exit							
						End If
						lds_pedidos_reales.SetFilter('co_fabrica = ' + String(co_fabrica) + ' AND co_linea = ' + String(co_linea) + &
												' AND co_referencia = ' + String(co_referencia)	)
						lds_pedidos_reales.Filter()						
						If lds_pedidos_reales.RowCount() > 0 Then
							If lds_pedidos_reales.GetItemNumber(1, 'cantidad_102') <= 0 Then
								lds_arbol.DeleteRow(ll_row)
								ll_row --
							End If					
						End If
						// si la cantidad_102 es diferente a la calculada se actualiza cantidad_102 y cantidad_dpo
					ElseIf lds_arbol.GetItemNumber( ll_row, 'cantidad_102') <> ldc_ca_programada_po Or &
								IsNull(lds_arbol.GetItemNumber( ll_row, 'cantidad_102')) Then
						lds_arbol.SetItem( ll_row, 'cantidad_102', ldc_ca_programada_po)						
						lds_arbol.SetItem( ll_row, 'cantidad_dpo', ldc_ca_programada_po)						
					End If
				Next
				If li_retorno >= 0 Then
					lds_arbol.SetFilter("pedido_hijo = " + String(ll_pedido_allocation))
					lds_arbol.Filter()
					
					pedido_hijo = lds_arbol.GetItemNumber(1,'pedido_hijo')	
					co_fabrica = lds_arbol.GetItemNumber(1,'co_fabrica')	
					co_linea = lds_arbol.GetItemNumber(1,'co_linea')				
					co_referencia = lds_arbol.GetItemNumber(1,'co_referencia')			
					
					If IsNull(lds_arbol.GetItemNumber(1,'cantidad_dpo')) Or ldc_ca_programada <> lds_arbol.GetItemNumber(1,'cantidad_dpo') Then
						lds_arbol.SetItem(1,'cantidad_dpo', ldc_ca_programada)
					End If 
					
					If lds_simulacion.Of_retrieve( pedido_hijo, co_fabrica, co_linea, co_referencia, 0) <= 0 Then
						li_retorno = -1
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error en la Base de datos. ~r~n~n' + gnv_recursos.Of_Get_Transaccion_Sucia( ).sqlerrtext)
					Else								
						// se obtiene la cantidad y el estandar del pedido			
						ldc_ca_programada_po = lds_simulacion.GetItemNumber(1, 'ca_programada')
						ldc_estandar = lds_simulacion.GetItemNumber(1, 'tiempo_estandar')
						// si no son nulos o negativos se acumula en la cantidad reservada
						// y el tiempo reservado
						If ldc_ca_programada_po > 0 And ldc_estandar > 0 Then
							ldc_ca_programada += ldc_ca_programada_po
							ldc_tiempo_po += ldc_ca_programada_po * ldc_estandar
						End If
						
						// si la cantidad_102 es diferente a la calculada se actualiza cantidad_102 y cantidad_dpo
						If lds_arbol.GetItemNumber( 1, 'cantidad_102') <> ldc_ca_programada_po Or &
									IsNull(lds_arbol.GetItemNumber( 1, 'cantidad_102')) Then						
							lds_arbol.SetItem( 1, 'cantidad_dpo', ldc_ca_programada_po)						
						End If
						
						ldc_estandar = lds_pedido.GetItemNumber( 1, 'tiempo_estandar')
						
						ldc_programada = Round (ldc_tiempo_po / ldc_estandar, 0)
						
						ldc_ca_pedida = lds_pedido.GetItemNumber(1, 'ca_pedida') 
						// se actualiza la cantidad reservada del allocation
						Choose Case ldc_programada 
							Case Is < ldc_ca_pedida
								lds_pedido.SetItem(1, 'cantidad_102', ldc_ca_programada)
							Case Is >= ldc_ca_pedida
								lds_pedido.SetItem(1, 'cantidad_102', ldc_ca_pedida)
						End Choose
						
						li_retorno = -1
					
						If lds_pedido.Of_Update( ) = -1 Then
							MessageBox('Error', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al guardar la nueva cantidad 102. (Update)')
						ElseIf lds_arbol.Of_Update( ) = -1 Then
							MessageBox('Error', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al actualizar el arbol del pedido. (Update)')
						ElseIf lds_pedido.Of_Commit( ) = -1 Then
							MessageBox('Error', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al guardar la nueva cantidad 102. (Commit)')
						Else
							MessageBox('Exito', 'Se Actualizo con exito la cantidad reservada en PDP')
							li_retorno = 1
						End IF
					End If
				End If
			Case Else
				li_retorno = -1		
		End Choose
	Case 0 // No encontro la raiz del arbol
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontraron datos del allocation')
		li_retorno = -1
	Case Else // Ocurrio un error en la base de datos
		ROLLBACK;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error en la Base de Datos al consultar el allocation')
		li_retorno = -1
End Choose
	


Destroy(lds_raiz)
Destroy(lds_simulacion)
Destroy(lds_pedido)
Destroy(lds_pedidos_reales)
Destroy(lds_arbol)


Return li_retorno
end function

public function long of_obtener_raiz_activa ();Long ll_pedido, ll_filas
Long li_retorno
uo_dsbase lds_arbol

ll_pedido = pedido_hijo

pedido_padre = pedido_hijo

li_retorno = This.of_set_raiz( )

If li_retorno > 0 Then
	lds_arbol = Create uo_dsbase
	lds_arbol.DataObject = "d_gr_arbol_pedido"
	lds_arbol.SettransObject( gnv_recursos.Of_Get_Transaccion_Sucia( ) )	
	This.of_registrar_seguridad( lds_arbol )
	
	ll_filas = lds_arbol.Of_Retrieve(pedido_raiz)
	If ll_filas < 0 Then
		ROLLBACK;
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n!','Error en la base de datos la traer la informacion del arbol del pedido')	
		li_retorno = -1
	Else				
		lds_arbol.SetFilter("tipo_pedido IN ('AC','AP')")
		lds_arbol.Filter()
		lds_arbol.SetSort('nivel DESC')
		lds_arbol.Sort()
		
		If lds_arbol.RowCount() = 0 Then
			li_retorno = 0
			pedido_hijo = ll_pedido
		Else
			li_retorno = 1
			pedido_hijo = lds_arbol.GetItemNumber(1, 'pedido_hijo')			
			co_fabrica = lds_arbol.GetItemNumber(1, 'co_fabrica')
			co_linea = lds_arbol.GetItemNumber(1, 'co_linea')
			co_referencia = lds_arbol.GetItemNumber(1, 'co_referencia')
		End If
	End If
	Destroy (lds_arbol)
End If
Return li_retorno	
	
	
	
end function

public function long of_actualizar_nodo (ref n_arbol_pedido anvo_arbol);/* ----------------------------------------------------------------------------------
Funcion para actualizar los datos del nodo
Se Traen los datos relaciones con el pedido y si existe se actualizan los campos
---------------------------------------------------------------------------------- */

Long li_retorno
Long ll_rows
uo_dsbase lds_arbol, lds_arbol_hijos
Boolean lb_actualizar_raiz

lds_arbol = Create uo_dsbase
lds_arbol.DataObject = "d_gr_arbol_raiz"
lds_arbol.SettransObject( SQLCA)

This.of_registrar_seguridad( lds_arbol )
ll_rows = lds_arbol.Of_Retrieve(anvo_arbol.pedido_hijo, anvo_arbol.co_fabrica, anvo_arbol.co_linea, anvo_arbol.co_referencia)
// Si el pedido existe
If ll_rows >= 1 Then
	// se actualiza los campos	
	If Not IsNull (co_fabrica) Then	lds_arbol.SetItem( 1, 'co_fabrica', co_fabrica)
	If Not IsNull (co_linea) Then	lds_arbol.SetItem( 1, 'co_linea', co_linea)
	If Not IsNull (co_referencia) Then	lds_arbol.SetItem( 1, 'co_referencia', co_referencia)
	If Not IsNull (tipo_pedido) Then	lds_arbol.SetItem( 1, 'tipo_pedido', tipo_pedido)	
	If Not IsNull (ca_pedida) Then lds_arbol.SetItem( 1, 'ca_pedida', ca_pedida)
	If Not IsNull (cantidad_102) Then lds_arbol.SetItem( 1, 'cantidad_102', cantidad_102)
	If Not IsNull (cantidad_dpo) Then lds_arbol.SetItem( 1, 'cantidad_dpo', cantidad_dpo)
	If Not IsNull (porc_eficiencia) Then lds_arbol.SetItem( 1, 'porc_eficiencia', porc_eficiencia)
	
	
	If Not IsNull (co_fabrica_hijo) Then	
		lds_arbol.SetItem( 1, 'co_fabrica_hijo', co_fabrica_hijo)
		lb_actualizar_raiz = True
	Else
		lb_actualizar_raiz = False
	End If
	
	li_retorno = lds_arbol.Of_Update()		
	
	If li_retorno = 1 And lds_arbol.GetItemNumber( 1, 'nivel') = 0 And lb_actualizar_raiz then
		lds_arbol_hijos = Create uo_dsbase
		lds_arbol_hijos.DataObject = "d_gr_arbol_pedido_fabrica"
		lds_arbol_hijos.SettransObject( SQLCA)			
		If lds_arbol_hijos.Of_Retrieve(anvo_arbol.pedido_hijo) > 0 Then
			lds_arbol_hijos.SetItem( 1, 'co_fabrica_raiz', co_fabrica_hijo)			
			li_retorno = lds_arbol_hijos.Of_Update()
			If li_retorno < 0 Then
				ROLLBACK;
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio en error al actualizar el nodo en el arbol~r~n~n' + lds_arbol_hijos.is_sqlerrtext )
			End If				
		End If		
		Destroy(lds_arbol_hijos)
	End If
ElseIf ll_rows < 0 Then
	ROLLBACK;
	li_retorno = 0
Else
	li_retorno = -1
End If	
Destroy (lds_arbol)
Return li_retorno 

	
end function

public function long of_insertar_items (ref uo_dsbase ads_arbol, long al_padre, ref treeview atv_arbol, long al_pedido_padre);/* ----------------------------------------------------------------------------------
	Funcion para insertar los items del treeview conlos datos del arbol
	La primera vez que entra ii_nivel debe tener el valor de -1 para 	indicar 
	que esta vacio, se insertan los datos del encabezado, se vuelve  llamar esta 
	funcion para insertar los items hijos con su respectiva informaci$$HEX1$$f300$$ENDHEX$$n.
	
---------------------------------------------------------------------------------- */

Long ll_row, ll_item, ll_pedido
TreeViewItem ltvi_Item
String ls_tipo_pedido, ls_buscar
s_base_parametros lsp_hoja

// es el primer item a crear
ls_buscar = 'nivel = 0'
ll_row = ads_arbol.Find( ls_buscar , 1, ads_arbol.RowCount() + 1)
If nivel = -1 And ll_row > 0 Then
	// Se borra los datos que tenga el treeview
	atv_arbol.DeleteItem(0)
	// Se toma el pedido
	ll_pedido = ads_arbol.GetItemNumber(1,'pedido_raiz')
	ltvi_Item.Label = "Arbol del pedido " + String(ll_pedido)
	
	ls_tipo_pedido = ads_arbol.GetItemString(ll_row,'tipo_pedido')

	lsp_hoja.Entero[1] = ll_pedido
	lsp_hoja.Entero[2] = ads_arbol.GetItemNumber(ll_row,'co_fabrica')
	lsp_hoja.Entero[3] = ads_arbol.GetItemNumber(ll_row,'co_linea')
	lsp_hoja.Entero[4] = ads_arbol.GetItemNumber(ll_row,'co_referencia')
	lsp_hoja.Entero[5] = ads_arbol.GetItemNumber(ll_row,'pedido_raiz')
	lsp_hoja.Cadena[1] = ls_tipo_pedido
	
	ltvi_Item.Data = lsp_hoja

	ltvi_Item.PictureIndex = 1
	ltvi_Item.SelectedPictureIndex = 2
	ltvi_Item.Children = True	
	ll_item = atv_arbol.InsertItemLast ( 0, ltvi_Item)
	nivel ++
	This.Of_Insertar_Items ( ads_arbol, ll_item, atv_arbol, ll_pedido )
	atv_arbol.ExpandItem ( ll_item ) 
	Return 1
End IF
ll_row = 0
// Busca los items del nivel ii_nivel
ls_buscar = 'nivel = ' + String(nivel) + ' and pedido_padre=' + String(al_pedido_padre)
ll_row = ads_arbol.Find( ls_buscar , ll_row + 1, ads_arbol.RowCount() + 1)
Do While ll_row > 0 
	// Se toma el pedido
	ll_pedido = ads_arbol.GetItemNumber(ll_row,'pedido_hijo')
	ls_tipo_pedido = ads_arbol.GetItemString(ll_row,'tipo_pedido')
	// se dan los datos a mostrar
	ltvi_Item.Label = String(ll_pedido) + ' ' + ls_tipo_pedido
	ltvi_Item.PictureIndex = 1
	ltvi_Item.SelectedPictureIndex = 2
	// Se asigna el numero del pedido
	lsp_hoja.Entero[1] = ll_pedido
	lsp_hoja.Entero[2] = ads_arbol.GetItemNumber(ll_row,'co_fabrica')
	lsp_hoja.Entero[3] = ads_arbol.GetItemNumber(ll_row,'co_linea')
	lsp_hoja.Entero[4] = ads_arbol.GetItemNumber(ll_row,'co_referencia')
	lsp_hoja.Entero[5] = ads_arbol.GetItemNumber(ll_row,'pedido_raiz')
	lsp_hoja.Cadena[1] = ls_tipo_pedido
	
	ltvi_Item.Data = lsp_hoja
	
	ll_item = atv_arbol.insertitemLast ( al_padre, ltvi_Item)
	
	If This.pedido_hijo = ll_pedido And This.co_fabrica = ads_arbol.GetItemNumber(ll_row,'co_fabrica') AND &
		This.co_linea = ads_arbol.GetItemNumber(ll_row,'co_linea') AND This.co_referencia = ads_arbol.GetItemNumber(ll_row,'co_referencia') Then
		
		atv_arbol.SelectItem ( ll_item )
	End If
		
	nivel ++	
	// Se insertan los hijos de este item
	This.Of_Insertar_Items ( ads_arbol,  ll_item, atv_arbol, ll_pedido)
	nivel --
	// Busca los items del nivel ii_nivel
	ll_row = ads_arbol.Find(ls_buscar , ll_row + 1, ads_arbol.RowCount() + 1)
Loop

Return 0
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

//	Halla la ventana activa
lw_window = w_principal.GetActiveSheet()

//	Si existe una ventana activa
If IsValid(lw_window) Then
	//	Si la ventana activa es descendiente de w_base_simple
	If lw_window.TriggerEvent('ue_es_base_simple') = 1 Then
		lw_ventana = lw_window
		//	Registra el datastore enviado por referencia con la seguridad de la ventana
	//	lw_ventana.wf_seguridad_ds(ads_registrado)
	//	Si la ventana activa tiene manejo de seguridad
	ElseIf lw_window.TriggerEvent('ue_validar_seguridad') = 1 Then
		//	Registra el datastore enviado por referencia con la seguridad de la ventana
		//lw_window.Dynamic wf_seguridad_ds(ads_registrado)
	End If
End If

Return 1
end function

public function long of_borrar_nodo (n_arbol_pedido anvo_arbol);/* ----------------------------------------------------------------------------------
Funcion para actualizar los datos del nodo
Se Traen los datos relaciones con el pedido y si existe se actualizan los campos
---------------------------------------------------------------------------------- */

Long li_retorno
Long ll_rows
uo_dsbase lds_arbol
Boolean lb_actualizar_raiz

lds_arbol = Create uo_dsbase
lds_arbol.DataObject = "d_gr_arbol_raiz"
lds_arbol.SettransObject( SQLCA)

This.of_registrar_seguridad( lds_arbol )
ll_rows = lds_arbol.Of_Retrieve(anvo_arbol.pedido_hijo, anvo_arbol.co_fabrica, anvo_arbol.co_linea, anvo_arbol.co_referencia)
// Si el pedido existe
If ll_rows >= 1 Then
	// se actualiza los campos	
	anvo_arbol.pedido_raiz = lds_arbol.GetItemNumber(ll_rows, 'pedido_raiz')
	anvo_arbol.tipo_pedido = lds_arbol.GetItemString(ll_rows, 'tipo_pedido')
	If anvo_arbol.tipo_pedido = 'AC' OR anvo_arbol.tipo_pedido = 'AP' Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No puede eliminar allocation del Arbol')
		li_retorno = -1
	Else
		lds_arbol.DeleteRow(ll_rows)		
		li_retorno = lds_arbol.Of_Update()				
		If li_retorno = -1 Then
			ROLLBACK;
			MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurri$$HEX2$$f3002000$$ENDHEX$$un error en la BD al intentar borrar un nodo del arbol. ~r~n~n' + lds_arbol.is_sqlerrtext)
		End If
	End If	
ElseIf ll_rows < 0 Then
	ROLLBACK;
	li_retorno = -1
Else
	li_retorno = -1
End If	
Destroy (lds_arbol)
Return li_retorno 
end function

on n_arbol_pedido.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_arbol_pedido.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;This.of_reiniciar_propiedades( )
end event

