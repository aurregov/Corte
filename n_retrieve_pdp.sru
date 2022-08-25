HA$PBExportHeader$n_retrieve_pdp.sru
$PBExportComments$Objeto utilizado para realizar el retrieve del datawindow con los datos que tiene el filtro para del pdp
forward
global type n_retrieve_pdp from nonvisualobject
end type
end forward

global type n_retrieve_pdp from nonvisualobject autoinstantiate
end type

type variables


datawindow idw_datos_pedido

end variables

forward prototypes
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
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13)
public function long of_retrieve_dw (ref datawindow adw_datawindow, any aa_valores[])
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13, any aa_arg_14)
public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13, any aa_arg_14, any aa_arg_15)
end prototypes

public function long of_retrieve ();/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	-------------------------------------------------------------------*/
Long ll_valor

ll_valor = idw_datos_pedido.Retrieve()
Return ll_valor
end function

public function long of_retrieve (any aa_arg_1);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con un argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con dos argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 3 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 4 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3,aa_arg_4)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 5 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 6 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 7 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 8 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 9 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 10 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 11 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 12 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 13 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12,&
								 aa_arg_13)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve_dw (ref datawindow adw_datawindow, any aa_valores[]);/*---------------------------------------------------------------------

	se realiza retrieve al dw ingresado por parametro dependiendo de el
	arreglo introducido por parametro. aqui se mira el tama$$HEX1$$f100$$ENDHEX$$o del arreglo
	para realizar el retrieve correspondiente
-----------------------------------------------------------------------*/
Long li_nro_columnas
Long ll_valor_retrieve

idw_datos_pedido = adw_datawindow
// mira el nro de columnas para realizar el retrieve
li_nro_columnas = UpperBound(aa_valores )

Choose Case li_nro_columnas
	Case 0
		ll_valor_retrieve = of_retrieve()
	Case 1
		ll_valor_retrieve = of_retrieve(aa_valores[1])
	Case 2
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2])
	Case 3
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3])
	Case 4
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4] )
	Case 5
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5])
	Case 6
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6])
	Case 7
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7] )
	Case 8
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8] )
	Case 9
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9])
	Case 10
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9], aa_valores[10])
	Case 11
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9], aa_valores[10], &
									aa_valores[11])
	Case 12
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9], aa_valores[10], &
									aa_valores[11], aa_valores[12])
	Case 13
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9], aa_valores[10], &
									aa_valores[11], aa_valores[12], &
									aa_valores[13])
	Case 14
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9], aa_valores[10], &
									aa_valores[11], aa_valores[12], &
									aa_valores[13],aa_valores[14])
	Case 15
		ll_valor_retrieve = of_retrieve(aa_valores[1], aa_valores[2], &
									aa_valores[3], aa_valores[4], &
									aa_valores[5], aa_valores[6], &
									aa_valores[7], aa_valores[8], &
									aa_valores[9], aa_valores[10], &
									aa_valores[11], aa_valores[12], &
									aa_valores[13],aa_valores[14],aa_valores[15])
End choose


Return ll_valor_retrieve
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13, any aa_arg_14);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 13 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12,&
								 aa_arg_13,aa_arg_14)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

public function long of_retrieve (any aa_arg_1, any aa_arg_2, any aa_arg_3, any aa_arg_4, any aa_arg_5, any aa_arg_6, any aa_arg_7, any aa_arg_8, any aa_arg_9, any aa_arg_10, any aa_arg_11, any aa_arg_12, any aa_arg_13, any aa_arg_14, any aa_arg_15);/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	con 13 argumento
	-------------------------------------------------------------------*/
Long ll_valor

//	Recupera datos de la B.D.
ll_valor = idw_datos_pedido.Retrieve(aa_arg_1, aa_arg_2, aa_arg_3, aa_arg_4, aa_arg_5, aa_arg_6, &
								 aa_arg_7, aa_arg_8, aa_arg_9, aa_arg_10, aa_arg_11, aa_arg_12,&
								 aa_arg_13,aa_arg_14,aa_arg_15)

//	Si se produjo un error de B.D.
//If This.ib_dberror Then Return -1

Return ll_valor
end function

on n_retrieve_pdp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_retrieve_pdp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

