HA$PBExportHeader$uo_dsbase.sru
forward
global type uo_dsbase from datastore
end type
end forward

global type uo_dsbase from datastore
event type long ue_retrieve ( )
end type
global uo_dsbase uo_dsbase

type variables
Boolean ib_sqlpreview
Boolean ib_permiso_seleccionar	//	Indica si el usuario de la ventana tiene permiso para seleccionar
Boolean ib_permiso_imprimir  		//	Indica si el usuario de la ventana tiene permiso para imprimir
Boolean ib_permiso_insertar  		//	Indica si el usuario de la ventana tiene permiso para insertar
Boolean ib_permiso_borrar			//	Indica si el usuario de la ventana tiene permiso para borrar
Boolean ib_permiso_actualizar		//	Indica si el usuario de la ventana tiene permiso para actualizar
Boolean ib_seguridad					//	Indica si ya se cargo la seguridad por defecto (permisos) para el datawindow
Boolean ib_dberror					//	Indica si hubo un fallo que dispara el dberror
Boolean ib_error_permiso			//	Indica si hubo un error de actualizacion por falta de permisos
String is_ventana_padre				//	almacena la ventana donde se instancia el datastore
Long il_retrievestart				//	Almacena el codigo de retorno para el evento retrievestart
Long il_no_insertado, il_no_borrado, il_no_actualizado
Boolean ib_registrar_sql			//	Indica si debe registrar todo el movimiento de sql
n_registrar_sql invo_logsql		//	Almacena una referencia al objeto para registrar en el log de sql
String is_SQLSyntax					//	Almacena la sintaxis del ultimo SQL que produjo un error
String is_SQLErrText					//	Almacena el texto del ultimo error que se genero
Long il_SQLDBCode						//	Almacena el ultimo codigo de error reportado por la B.D.
Boolean gb_usar_seguridad

end variables

forward prototypes
public function long of_commit (ref transaction atr_transaccion)
public function long of_commit ()
public function long of_retrieve ()
public function long of_retrieve (any aa_arg_1)
public function long of_retrieve (any aa_arg_1, any aa_arg_2)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12)
public function long of_update ()
public function long of_update (boolean ab_accept, boolean ab_resetflag)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13, any aa_arg_14)
end prototypes

event type long ue_retrieve();/*	-------------------------------------------------------------------
	Evento que hace el retrieve del datawindow y sin enviar argumentos.
	Retorna la cantidad de registros recuperados de la Base de Datos.
	-------------------------------------------------------------------*/
Long ll_registros

ll_registros = This.Retrieve()
If ib_dberror Then Return -1

Return  ll_registros
end event

public function long of_commit (ref transaction atr_transaccion);/*	---------------------------------------------------------------------
	Funcion que hace Commit y valida la operaci$$HEX1$$f300$$ENDHEX$$n.
	---------------------------------------------------------------------*/
If ib_registrar_sql Then
	invo_logsql.of_registrar_sql(5, 'COMMIT')
	If invo_logsql.ids_logsql.Of_Update() < 0 Then
		RollBack Using atr_transaccion;
		Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo el registro en el log de SQL.~r~n" &
					+ "Por favor comunicarse con informatica.",StopSign!)
		Return -1
	End If
End If

Commit Using atr_transaccion;

If atr_transaccion.SQLCode = -1 Then
	RollBack Using atr_transaccion;
	If atr_transaccion.SQLCode = -1 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'RollBack' ha fallado; " &
					+ 'la transaccion no ha sido devuelta completamente en la Base de Datos.' &
					+ '~nPor favor avise al Administrador del Sistema.')
	End If
	
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
				+ 'los datos no han sido almacenados en la Base de Datos.' &
				+ '~nPor favor avise al Administrador del Sistema.')
	Return -1
End If

Return 1

end function

public function long of_commit ();/*	---------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que hace Commit y valida la operaci$$HEX1$$f300$$ENDHEX$$n.
	---------------------------------------------------------------------*/
If ib_registrar_sql Then
	invo_logsql.of_registrar_sql(5, 'COMMIT')
	If invo_logsql.ids_logsql.Of_Update() < 0 Then
		Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo el registro en el log de SQL.~r~n" &
					+ "Por favor comunicarse con informatica.",StopSign!)
		Return -1
	End If
End If

Commit Using SQLCA;

If SQLCA.SQLCode = -1 Then
	RollBack Using SQLCA;
	If SQLCA.SQLCode = -1 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'RollBack' ha fallado; " &
					+ 'la transaccion no ha sido devuelta completamente en la Base de Datos.' &
					+ '~nPor favor avise al Administrador del Sistema.')
	End If

	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
				+ 'los datos no han sido almacenados en la Base de Datos.' &
				+ '~nPor favor avise al Administrador del Sistema.')
	Return -1
End If

Return 1

end function

public function long of_retrieve ();/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	-------------------------------------------------------------------*/
Long ll_valor

ll_valor = This.Event ue_retrieve()
Return ll_valor
end function

public function long of_retrieve (any aa_arg_1);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3,aa_arg_4)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_update ();Long li_ret

//	Actualiza la B.D. con los cambios hechos en el datastore
li_ret = This.Update()

////	Si se produjo un error de B.D. o por falta de permisos
//If This.ib_dberror Or This.ib_error_permiso Then Return -1

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

//	Si no tiene los permisos adecuados
If This.ib_error_permiso Then Return -2

//	Retorna el valor original de la operacion
Return li_ret
end function

public function long of_update (boolean ab_accept, boolean ab_resetflag);Long li_ret

//	Actualiza la B.D. con los cambios hechos en el datastore
li_ret = This.Update(ab_accept, ab_resetflag)

////	Si se produjo un error de B.D. o por falta de permisos
//If This.ib_dberror Or This.ib_error_permiso Then Return -1

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

//	Si no tiene los permisos adecuados
If This.ib_error_permiso Then Return -2

//	Retorna el valor original de la operacion
Return li_ret
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12,&
								 aa_arg_13)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13, any aa_arg_14);Long ll_valor

//	Recupera datos de la B.D.
ll_valor = This.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12,&
								 aa_arg_13, aa_arg_14)

//	Si se produjo un error de B.D.
If This.ib_dberror Then Return -1

Return ll_valor
end function

event dberror;/*	---------------------------------------------------------------------
	Evento utilizado para desplegar un mensaje identificando el error 
	relacionado con la base de datos pero antes se hace el correspondiente 
	Rollback.
	---------------------------------------------------------------------*/
String ls_error

ib_dberror = True

is_SQLSyntax	= SQLSyntax
is_SQLErrText	= SQLErrText
il_SQLDBCode	= SQLDBCode

RollBack;

If SQLCA.SQLCode = - 1 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fall$$HEX2$$f3002000$$ENDHEX$$la operaci$$HEX1$$f300$$ENDHEX$$n de RollBack (" + String(SQLCA.SQLDBCode) + ")" &
				+ "~r~n~r~nPor favor comunicarse con informatica.")
End If

Choose Case il_SQLDBCode
	Case -211
		ls_error = "~n~nHa ocurrido un error en la base de datos de '" + trim(SQLCA.DBMS) &
					+ "' en el servidor '" + Trim(SQLCA.ServerName) + "'.~n~n" &
					+ "Informe a Infraestructura que esta ocurriendo un error de SysProcPlan.~n~n" &
					+ is_SQLErrText
	Case -25582
		ls_error = "~n~nLa conexi$$HEX1$$f300$$ENDHEX$$n de este PC con la Red inhalambrica o cableada se perdio." &
					+ "~nReinicie su equipo y si el problema persiste informe a Infraestructura." &
					+ is_SQLErrText
	Case Else
   	ls_error = "~n~nError SQL: ~n" + is_SQLErrText
End Choose

MessageBox( "Error de Base de Datos ("+This.DataObject+")", "Codigo: "+ String(il_SQLDBCode)+"." + ls_error)

Return 1	//	Suprime el mensaje de error por defecto del sistema

end event

on uo_dsbase.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_dsbase.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event error;messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n, error "+string(errornumber)+" en linea: " + String(errorline), errortext)
end event

event sqlpreview;/*	---------------------------------------------------------------------
	Despliega un mensaje con el SQL que sera enviado a la B.D. siempre y
	cuando la propiedad de ib_sqlpreview este en verdadero.   Esta propiedad
	puede ser fijada en dise$$HEX1$$f100$$ENDHEX$$o de datawindow o desde script.
	---------------------------------------------------------------------*/
Long li_tipo_sql
ib_dberror = False
ib_error_permiso = False

If This.ib_sqlpreview Then messagebox("SQL enviado a la base de datos ("+This.DataObject+")",sqlsyntax)

//	Si se debe usar la seguridad global para la aplicaci$$HEX1$$f300$$ENDHEX$$n
If gb_usar_seguridad Then
	//	Si la seguridad del datawindow ya fue definida
	If This.ib_seguridad Then
		//	Para el caso de cada tipo de SQL enviado al motor
		Choose Case sqltype
			Case PreviewSelect!	
				If Not This.ib_permiso_seleccionar Then
					MessageBox("Mensaje de Seguridad ("+This.DataObject+")","No tiene permiso para consultar informaci$$HEX1$$f300$$ENDHEX$$n.")
					Return 1	//	Detiene el procesamiento
				End If
			Case PreviewInsert!	//	Se esta enviando un Insert a la B.D.
				If Not This.ib_permiso_insertar Then
					This.il_no_insertado++
					Return 2	//	Salta este requerimiento y ejecuta el siguiente
				End If
			Case PreviewDelete!	//	Se esta enviando un Delete a la B.D.
				If Not This.ib_permiso_borrar Then
					This.il_no_borrado++ 
					Return 2	//	Salta este requerimiento y ejecuta el siguiente
				End If
			Case PreviewUpdate!	//	Se este enviando un Update a la B.D.
				If Not This.ib_permiso_actualizar Then
					This.il_no_actualizado++
					Return 2	//	Salta este requerimiento y ejecuta el siguiente
				End If
		End Choose
	End If
End If

//	Si se debe registrar el sql en el log
If ib_registrar_sql Then
	Choose Case sqltype
		Case PreviewInsert! 
			li_tipo_sql = 2
		Case PreviewUpdate! 
			li_tipo_sql = 4
		Case PreviewDelete! 
			li_tipo_sql = 3
	End Choose

	//	Si el sql es para Insertar, actualizar o borrar lo registra en el log
	If li_tipo_sql > 1 Then
		//	Registra el sql enviado a la BD
		invo_logsql.Of_Registrar_Sql(This.DataObject, li_tipo_sql, sqlsyntax)	
	End If
End If

end event

event printstart;
If gb_usar_seguridad Then
	If This.ib_seguridad Then
		If Not This.ib_permiso_imprimir Then
			MessageBox("Mensaje de Seguridad ("+This.DataObject+")","No tiene permiso para imprimir informaci$$HEX1$$f300$$ENDHEX$$n.")
			This.PrintCancel()
		End If
	End If
End If
end event

event updateend;/*	---------------------------------------------------------------------
	Evento utilizado para desplegar al usuario la informaci$$HEX1$$f300$$ENDHEX$$n de los
	registros que no logro escribir o actualizar a la base de datos en
	caso de que el usuario no haya tenido permisos para hacerlo.
	---------------------------------------------------------------------*/

If This.il_no_insertado + This.il_no_borrado + This.il_no_actualizado > 0 Then
	ib_error_permiso = True
	RollBack;
	If il_no_insertado > 0 Then
		MessageBox("Mensaje de Seguridad ("+This.DataObject+")","No se inserto " + String(This.il_no_insertado)  &
					+ " registro(s) nuevo(s) que se habia(n) creado.~n~n" &
					+ "No tiene permiso para hacerlo." ,Exclamation!)
	End If

	If This.il_no_borrado > 0 Then
		MessageBox("Mensaje de Seguridad ("+This.DataObject+")","No se borro " + String(This.il_no_borrado)  &
					+ " registro(s) que se habia(n) borrado.~n~n" &
					+ "No tiene permiso para hacerlo." ,Exclamation!)
	End If
	
	If This.il_no_actualizado > 0 Then
		MessageBox("Mensaje de Seguridad ("+This.DataObject+")","No se actualizo " + String(This.il_no_actualizado)  &
					+ " registro(s) que se habia(n) modificado.~n~n" &
					+ "No tiene permiso para hacerlo." ,Exclamation!)
	End If
	This.il_no_insertado = 0
	This.il_no_borrado = 0
	This.il_no_actualizado = 0
End If
end event

event retrievestart;
Return il_retrievestart
end event

event constructor;//window lw_window
//w_base_simple lw_ventana

//lw_window = w_principal.GetActiveSheet()
//If IsValid(lw_window) Then
//	//	Si la ventana es un ancestro de w_base_simple
//	If lw_window.TriggerEvent('ue_es_base_simple') = 1 Then
//		lw_ventana = lw_window
//		If lw_ventana.ib_logsql Then
//			ib_registrar_sql = True
//			invo_logsql = lw_ventana.invo_sql
//		End If
//	End If
//End If
end event

