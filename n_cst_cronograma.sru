HA$PBExportHeader$n_cst_cronograma.sru
forward
global type n_cst_cronograma from nonvisualobject
end type
end forward

global type n_cst_cronograma from nonvisualobject
end type
global n_cst_cronograma n_cst_cronograma

type variables
// C$$HEX1$$f300$$ENDHEX$$digos de los subcentros
Constant Long CORTE = 110
Constant Long BMC = 119
Constant Long GBI = 120
Constant Long CONFECCION = 113
Constant Long PLANCHA = 115
Constant Long LAVANDERIA = 114
Constant Long CONSOLIDACION = 117
Constant Long ESTAMPADO = 112
Constant Long TERCEROS = 112   // Se carga al mismo subcentro de Estampado


// centro generico
Constant Long CENTRO = 99
// tipo prod generico
Constant Long TIPOPROD = 99

Constant Long fe_inicio = 1
Constant Long fe_fin = 2

Long il_pedido
Long ii_fabrica, ii_planta, ii_calendario
Long il_co_fabrica, il_co_linea, il_co_referencia
Boolean ib_crear_nodo = True

uo_dsbase ids_cronograma
n_utilidades_calendario_new invo_fechas
// transaccion para el objeto de las fechas
Transaction itr_transaccion
end variables

forward prototypes
public function long of_agregar_fecha (long ai_subcentro, date ad_fecha[2])
public function long of_agregar_fecha (long ai_subcentro, date ad_fecha[2], long ai_dias_habiles)
public function long of_ajustar_calendario (date ad_fecha)
private function long of_agregar_registro (long ai_subcentro, date ad_fecha[2], long ai_dias_habiles)
public function long of_reiniciar_propiedades ()
public function long of_generar_cronograma_auto (date ad_fecha, long al_ca_pedida)
public function long of_set_transaccion (transaction atr_transaccion)
public function long of_generar_observaciones (ref uo_dsbase ads_observaciones)
end prototypes

public function long of_agregar_fecha (long ai_subcentro, date ad_fecha[2]);/*
Funcion para agregar o actualizar las fechas de un subcentro.
Calcula los dias laborales
*/

Long ll_fila
Long li_dias_habiles

//Se calculan los dias laborales
li_dias_habiles = invo_fechas.of_NoDiasLaborables(ii_calendario,ad_fecha [fe_inicio],ad_fecha [fe_fin])
If li_dias_habiles < 0 Then
	MessageBox("Atenc$$HEX1$$ed00$$ENDHEX$$on", "Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al calcular los dias laborables.")
	Return -1
End If
// Se actualiza el ds
Return This.Of_Agregar_Registro(ai_subcentro, ad_fecha, li_dias_habiles)
end function

public function long of_agregar_fecha (long ai_subcentro, date ad_fecha[2], long ai_dias_habiles);/*
Funcion para agregar o actualizar las fechas de un subcentro.
Calcula la fecha de fin con los dias laborales
*/

Long ll_fila

// Se validan que los dias habiles sean mayor a 0
If ai_dias_habiles <= 0 Then
	MessageBox("Atenc$$HEX1$$ed00$$ENDHEX$$on", "Los dias laborables (" + String(ai_dias_habiles) + ") deben ser mayor que cero.")
	Return -1
End If
// se obtiene la fecha de fin
ad_fecha [fe_fin] = invo_fechas.Of_DiasDespues( ii_calendario, ad_fecha [fe_inicio], ai_dias_habiles)

// se valida la fecha de fin
If ad_fecha [fe_fin] < ad_fecha [fe_inicio] Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al calcular la fecha de fin")
	Return -2
End If
	
// Se actualiza el ds
Return This.Of_Agregar_Registro(ai_subcentro, ad_fecha, ai_dias_habiles)
end function

public function long of_ajustar_calendario (date ad_fecha);/*
Funci$$HEX1$$f300$$ENDHEX$$n para definir un cronograma por defecto para los pedidos generados desde la liberaci$$HEX1$$f300$$ENDHEX$$n
*/

Date ld_fecha[2], ld_confeccion_ini, ld_confeccion_fin, ld_hoy
Long ll_fila, ll_ini_es_laboral, ll_fin_es_laboral, ll_filas, ll_dias_terceros, ll_dias_estampado

uo_dsbase lds_estampado

If Not IsValid(ids_cronograma) Then
	ids_cronograma = Create uo_dsbase
	ids_cronograma.DataObject = 'd_gr_dt_cronograma'
	ids_cronograma.SetTransObject(SQLCA)
End If

ii_calendario = invo_fechas.of_calendario_fabrica(ii_fabrica )

If ii_calendario <= 0 Then
	Return -1
End If

// Se verifica con la ruta de la referencia si tiene ESTAMPADO
lds_estampado = Create uo_dsbase
lds_estampado.DataObject = 'd_gr_verifica_estampado'
lds_estampado.SetTransObject(itr_transaccion)
// se validan la carga
ll_filas = lds_estampado.Of_Retrieve(il_co_fabrica, il_co_linea, il_co_referencia)
If ll_filas <= 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurrio un error verificando si la refencia tiene estampado~r~n~n" + lds_estampado.is_sqlerrtext)	
	Return -1
End If

// Si la referencia tiene ESTAMPADO EN PRENDA se toman 5 dias habiles 
If lds_estampado.GetItemNumber( 1, 'sw_estampado') > 0 Then
	ll_dias_estampado = 5
Else
	ll_dias_estampado = 0
End If
// Si la referencia tiene TERCEROS (ESTAMPADO ANTES DE CONFECCION) se toman 4 dias habiles
If lds_estampado.GetItemNumber( 1, 'sw_terceros') > 0 Then
	ll_dias_terceros = 4
	// si tiene ESTAMPADO EN PRENDA se suma los dias al estampado inicial
	If ll_dias_estampado > 0 Then
		ll_dias_terceros += ll_dias_estampado
		ll_dias_estampado = 0
	End If
Else
	ll_dias_terceros = 0
End If

ld_hoy = Date(f_fecha_servidor() )

If Not (ld_hoy > Date('2000-1-1') ) Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error al obtener la fecha del servidor')
	Return -1
End If


// Se asigna el objeto de transaccion con lectura sucia al objeto de las fechas
invo_fechas.Of_Set_Transaccion(gnv_recursos.Of_Get_Transaccion_Sucia() )

/*

// CONFECCION
// Se toma la fecha de entrega y se le resta el tiempo de CONFECCION+LAVADO+ESTAMPACION+TERMINACION+CEDI
ld_confeccion_ini = invo_fechas.Of_DiasAntes( ii_calendario, ad_fecha, 4 + 1 + ll_dias_estampado + 1 + 1)

*/

// CONFECCION
// Se toma la fecha actual y se le suma el tiempo de CORTE+GBI+BMC+TERCEROS
ld_confeccion_ini = invo_fechas.Of_DiasDespues( ii_calendario, ld_hoy, 2+1+1+ll_dias_terceros + 1)


// se detecta si la fecha de inicio de confeccion es laboral
ll_ini_es_laboral = invo_fechas.Of_NoDiasLaborables( ii_calendario, ld_confeccion_ini, ld_confeccion_ini)


ld_confeccion_fin = invo_fechas.Of_DiasDespues( ii_calendario, ld_confeccion_ini, 4)

// se detecta si la fecha de fin de confeccion es laboral
ll_fin_es_laboral = invo_fechas.Of_NoDiasLaborables( ii_calendario, ld_confeccion_fin, ld_confeccion_fin)

ld_fecha [fe_inicio]	= ld_confeccion_ini
ld_fecha [fe_fin]		= ld_confeccion_fin
If This.Of_Agregar_Fecha(CONFECCION, ld_fecha) < 0 Then
	Return -1
End If

// CORTE
// se toma 5 dias habiles antes de confeccion
// con un tama$$HEX1$$f100$$ENDHEX$$o de 2 dias h$$HEX1$$e100$$ENDHEX$$biles
ld_fecha [fe_inicio]	= invo_fechas.Of_DiasAntes( ii_calendario, ld_confeccion_ini, 4 + ll_ini_es_laboral + ll_dias_terceros )
If This.Of_Agregar_Fecha(CORTE, ld_fecha, 2) < 0 Then
	Return -1
End If

// GBI
// se toma 2 dias habiles antes de confeccion
// con un tama$$HEX1$$f100$$ENDHEX$$o de 1 dias h$$HEX1$$e100$$ENDHEX$$biles
ld_fecha [fe_inicio]	= invo_fechas.Of_DiasAntes( ii_calendario, ld_confeccion_ini, 2 + ll_ini_es_laboral + ll_dias_terceros)

If This.Of_Agregar_Fecha(GBI, ld_fecha, 1) < 0 Then
	Return -1
End If

// BMC
// se toma 1 dias habiles antes de confeccion
// con un tama$$HEX1$$f100$$ENDHEX$$o de 1 dias h$$HEX1$$e100$$ENDHEX$$biles
ld_fecha [fe_inicio]	= invo_fechas.Of_DiasAntes( ii_calendario, ld_confeccion_ini, 1 + ll_ini_es_laboral + ll_dias_terceros)

If This.Of_Agregar_Fecha(BMC, ld_fecha, 1) < 0 Then
	Return -1
End If

//TERCEROS
// se toma 4 dias habiles antes de confeccion
// con un tama$$HEX1$$f100$$ENDHEX$$o de 4 dias h$$HEX1$$e100$$ENDHEX$$biles
If ll_dias_terceros > 0 Then
	ld_fecha [fe_inicio]	= invo_fechas.Of_DiasAntes( ii_calendario, ld_confeccion_ini, ll_ini_es_laboral + ll_dias_terceros)
	
	If This.Of_Agregar_Fecha(TERCEROS, ld_fecha, ll_dias_terceros) < 0 Then
		Return -1
	End If
End If

//// PLANCHA
//// se toma 4 dias habiles antes de fin de confeccion
//// con un tama$$HEX1$$f100$$ENDHEX$$o de 6 dias h$$HEX1$$e100$$ENDHEX$$biles
//ld_fecha [fe_inicio]	= invo_fechas.Of_DiasAntes( ii_calendario, ld_confeccion_fin, 4 )
//
//If This.Of_Agregar_Fecha(PLANCHA, ld_fecha, 6) < 0 Then
//	Return -1
//End If

// LAVANDERIA
// se toma 4 dias habiles antes de fin de confeccion
// con un tama$$HEX1$$f100$$ENDHEX$$o de 6 dias h$$HEX1$$e100$$ENDHEX$$biles
ld_fecha [fe_inicio]	= invo_fechas.Of_DiasDespues( ii_calendario, ld_confeccion_fin, 1 + ll_fin_es_laboral)
If This.Of_Agregar_Fecha(LAVANDERIA, ld_fecha, 1) < 0 Then
	Return -1
End If


// ESTAMPADO
// se toma 5 dias habiles antes de confeccion
// con un tama$$HEX1$$f100$$ENDHEX$$o de 6 dias h$$HEX1$$e100$$ENDHEX$$biles
If ll_dias_estampado > 0 Then
	ld_fecha [fe_inicio]	= invo_fechas.Of_DiasDespues( ii_calendario, ld_confeccion_fin, 2 + ll_fin_es_laboral)
	If This.Of_Agregar_Fecha(ESTAMPADO, ld_fecha, ll_dias_estampado) < 0 Then
		Return -1
	End If
End If

// CONSOLIDACION
// se toma desde 7 Dias despues de confeccion hasta 7 dias despues de confeccion
ld_fecha [fe_inicio]	= invo_fechas.Of_DiasDespues( ii_calendario, ld_confeccion_fin, 2 + ll_dias_estampado + ll_fin_es_laboral)
ld_fecha [fe_fin] = ld_fecha [fe_inicio]
If This.Of_Agregar_Fecha(CONSOLIDACION, ld_fecha) < 0 Then
	Return -1
End If

Return 1
end function

private function long of_agregar_registro (long ai_subcentro, date ad_fecha[2], long ai_dias_habiles);/*
Funci$$HEX1$$f300$$ENDHEX$$n privada para insertar o modificar registros del cronograma
*/

Long ll_fila
// se busca el subcentr
ll_fila = ids_cronograma.Find('co_subcentro_pdn = ' + String(ai_subcentro), 1, ids_cronograma.RowCount() + 1)
// Si no existe se crea
If ll_fila <= 0 Then	
	ll_fila = ids_cronograma.InsertRow(0)
	
	ids_cronograma.SetItem(ll_fila, 'pedido', il_pedido)
	ids_cronograma.SetItem(ll_fila, 'co_fabrica', ii_fabrica)
	ids_cronograma.SetItem(ll_fila, 'co_planta', ii_planta)
	
	ids_cronograma.SetItem(ll_fila, 'co_tipoprod', TIPOPROD)
	ids_cronograma.SetItem(ll_fila, 'co_centro_pdn', CENTRO)
	ids_cronograma.SetItem(ll_fila, 'co_subcentro_pdn', ai_subcentro)
	ids_cronograma.SetItem(ll_fila, 'fe_creacion', f_fecha_servidor() )
End If
// se asignan las fechas de cronograma del subcentro y los d$$HEX1$$ed00$$ENDHEX$$as h$$HEX1$$e100$$ENDHEX$$biles
ids_cronograma.SetItem(ll_fila, 'fe_inicio_progs', ad_fecha [fe_inicio])
ids_cronograma.SetItem(ll_fila, 'fe_final_progs', ad_fecha [fe_fin])
ids_cronograma.SetItem(ll_fila, 'dias_habiles', ai_dias_habiles)
// Se actualizan los campos de auditoria
ids_cronograma.SetItem(ll_fila, 'fe_actualizacion', f_fecha_servidor() )
ids_cronograma.SetItem(ll_fila, 'usuario', gstr_info_usuario.codigo_usuario )
ids_cronograma.SetItem(ll_fila, 'instancia', gstr_info_usuario.instancia )



Return ll_fila
end function

public function long of_reiniciar_propiedades ();// Funcion para reiniciar las propiedades del objeto de cronograma

SetNull(il_pedido)
SetNull(ii_fabrica)
SetNull(ii_planta)
SetNull(ii_calendario)
SetNull(il_co_fabrica)
SetNull(il_co_linea)
SetNull(il_co_referencia)
Destroy ids_cronograma

invo_fechas.Of_Reiniciar_Propiedades()

Return 1
end function

public function long of_generar_cronograma_auto (date ad_fecha, long al_ca_pedida);/*
Funci$$HEX1$$f300$$ENDHEX$$n para crear un cronograma en base a la fecha de inicio de confeccion.

Precondiciones: Deben haber ingresado los parametros	
	il_pedido: Numero de Pedido del cronograma
	il_fabrica: Fabrica del cronograma
	il_planta: Planta del cronograma
	il_co_fabrica, il_co_linea, il_co_referencia: C$$HEX1$$f300$$ENDHEX$$digo de la referencia
	
Se genera el cronograma por defecto y se actualiza la Base de datos, pero no hace el COMMIT.
*/

n_arbol_pedido lnvo_arbol

// Se valida el pedido 
If il_pedido = 0 Or IsNull(il_pedido) Then
	MessageBox('Atencion', 'El campo pedido es requerido"')
	Return -1
End If
// Se valida la fabrica del pedido
If ii_fabrica = 0 Or IsNull(ii_fabrica) Then
	MessageBox('Atencion', 'El campo fabrica es requerido"')
	Return -2	
End If
// Se valida la plnata del pedido
If ii_planta = 0 Or IsNull(ii_planta) Then
	MessageBox('Atencion', 'El campo planta es requerido"')
	Return -3
End If

// Se valida la referencia
If il_co_fabrica = 0 Or IsNull(il_co_fabrica) Then
	MessageBox('Atencion', 'El campo fabrica de la referencia es requerido"')
	Return -4
End If
If il_co_linea = 0 Or IsNull(il_co_linea) Then
	MessageBox('Atencion', 'El campo co_linea es requerido"')
	Return -5
End If
If il_co_referencia = 0 Or IsNull(il_co_referencia) Then
	MessageBox('Atencion', 'El campo co_referencia es requerido"')
	Return -6
End If

// Se limpia el ds de los cronogramas
If IsValid(ids_cronograma) Then Destroy ids_cronograma
	
// Se llenan el cronograma por defecto
If This.Of_Ajustar_Calendario(ad_fecha) < 0 Then
	Return -7
End If
// si esta activada la bandera para crear el nodo
If ib_crear_nodo Then	
	// se llenan las propiedades del objeto del arbol
	lnvo_arbol.co_fabrica_hijo = ii_fabrica
	lnvo_arbol.co_fabrica = il_co_fabrica
	lnvo_arbol.co_linea = il_co_linea
	lnvo_arbol.co_referencia = il_co_referencia
	lnvo_arbol.ca_pedida = al_ca_pedida
	lnvo_arbol.porc_eficiencia = 0
	lnvo_arbol.tipo_pedido = 'NA'

	lnvo_arbol.pedido_padre = This.il_pedido
	lnvo_arbol.pedido_hijo = This.il_pedido
	lnvo_arbol.cantidad_102 = 0
	lnvo_arbol.cantidad_dpo = 0
	// se guarda el nuevo nodo en dt_arbol_pedido
	If lnvo_arbol.Of_Crear_Nodo( ) < 0 Then
		ROLLBACK;
		MessageBox("Error", "Ocurrio un error al guardar el nodo del arbol del cronograma!")
		Return -8		
	End If	
End If

// Se actualiza los datos
If IsValid(ids_cronograma) Then
	If ids_cronograma.Of_Update(True, False) = 1 Then
		ids_cronograma.ResetUpdate()
		Return 1
	Else
		ROLLBACK;
		MessageBox("Error", "Ocurrio un error al guardar el cronograma!~r~n~n" + ids_cronograma.is_sqlerrtext )
		Return -9
	End If
Else
	MessageBox("Error", "No se creo el cronograma!"  )
	Return -10
End If

Return 1
end function

public function long of_set_transaccion (transaction atr_transaccion);// Se asigna el objeto de transaccion para trabajar con el objeto de las fechas
itr_transaccion = atr_transaccion
Return 1
end function

public function long of_generar_observaciones (ref uo_dsbase ads_observaciones);Long li_subcentro
Long ll_row, ll_fila
Boolean lb_nuevo
dwItemStatus l_status
String ls_observaciones, ls_log_cambios, ls_log[2]
String ls_inicio_act, ls_final_act, ls_inicio_ant, ls_final_ant
DateTime ldtm_hoy, ldtm_fecha

If Not IsValid(ads_observaciones) Then
	ads_observaciones = Create uo_dsbase
	ads_observaciones.DataObject = 'd_dt_cronograma_obs'
	ads_observaciones.SetTransObject(SQLCA)
End If

If Not IsValid(ids_cronograma) Then Return -1

lb_nuevo = True
For ll_row = 1 To ids_cronograma.RowCount()
	l_status = ids_cronograma.GetItemStatus(ll_row, 0, Primary!)
	Choose Case l_status
		Case New!, NewModified!
			
		Case NotModified!
			
		Case Else
			lb_nuevo = False
			Exit
	End Choose
Next

If lb_nuevo Then Return 1

ldtm_hoy = f_fecha_servidor()

For ll_row = 1 To ids_cronograma.RowCount()
	ls_log_cambios = ''
	lb_nuevo = False
	ls_observaciones = Trim(ids_cronograma.GetItemString(ll_row,"observaciones"))
	li_subcentro = ids_cronograma.object.co_subcentro_pdn.Original[ll_row]
	
	l_status = ids_cronograma.GetItemStatus(ll_row, 0, Primary!)
	
	ls_inicio_act	= String( ids_cronograma.GetItemDate(ll_row, "fe_inicio_progs", Primary!, False) )
	ls_final_act	= String( ids_cronograma.GetItemDate(ll_row, "fe_final_progs", Primary!, False) )
	ls_inicio_ant	= String( ids_cronograma.GetItemDate(ll_row, "fe_inicio_progs", Primary!, True) )
	ls_final_ant	= String( ids_cronograma.GetItemDate(ll_row, "fe_final_progs", Primary!, True) )
	Choose Case l_status
		Case NewModified!
			ls_log[fe_inicio] = ' ' + ls_inicio_act
			ls_log[fe_fin] 	= ' ' + ls_final_act
			lb_nuevo = True
		Case DataModified!
			ls_log = {'',''}
			If ls_inicio_act <> ls_inicio_ant Or IsNull(ls_inicio_ant) Then
				If Not IsNull(ls_inicio_ant) Then
					ls_log[fe_inicio] = ' Anterior: ' + ls_inicio_ant
				End If
				If Not IsNull(ls_inicio_act) Then
					ls_log[fe_inicio] += ' Nuevo: ' + ls_inicio_act
				End If
			ElseIf IsNull(ls_inicio_act) Then
				ls_log_cambios = 'Se borraron las fechas.'
			End If
			
			If ls_final_act <> ls_final_ant Or IsNull(ls_final_ant) Then
				If Not IsNull(ls_final_ant) Then
					ls_log[fe_fin] = ' Anterior: ' + ls_final_ant
				End If
				If Not IsNull(ls_final_act) Then
					ls_log[fe_fin] += ' Nuevo: ' + ls_final_act
				End If
			End If
	End Choose	
	
	If ls_log_cambios = '' Then
		If ls_log[fe_inicio] <> '' Then
			ls_log_cambios = 'F. Inicio Prog' + ls_log[fe_inicio] + '~n'
		End If
		If ls_log[fe_fin] <> '' Then
			//If ls_log_cambios <> '' Then ls_log_cambios += '~t'
			ls_log_cambios += 'F. Fin Prog' + ls_log[fe_fin] 
		End If
		
		If ls_log_cambios <> '' Then
			If lb_nuevo Then
				ls_log_cambios = 'Se crearon las fechas:~n' + ls_log_cambios
			Else
				ls_log_cambios = 'Cambiaron las fechas:~n' + ls_log_cambios
			End If
		End If
	End If	
	
	If ls_log_cambios <> '' Then
		ldtm_fecha = ldtm_hoy

		ll_fila = ads_observaciones.InsertRow(0)		
		ads_observaciones.SetItem(ll_fila,"co_fabrica", ii_fabrica)
		ads_observaciones.SetItem(ll_fila,"pedido", il_pedido)
		ads_observaciones.SetItem(ll_fila,"co_planta", ii_planta)
		ads_observaciones.SetItem(ll_fila,"co_tipoprod", TIPOPROD)
		ads_observaciones.SetItem(ll_fila,"co_centro_pdn", CENTRO)	
		ads_observaciones.SetItem(ll_fila,"co_subcentro_pdn",li_subcentro)
		ads_observaciones.SetItem(ll_fila,"fe_creacion", ldtm_fecha)
		ads_observaciones.SetItem(ll_fila,"usuario", gstr_info_usuario.codigo_usuario )		
		ads_observaciones.SetItem(ll_fila,"observaciones", ls_log_cambios)
	End If
	
	If ls_observaciones <> '' Then
		// si se inserto el log de cambios se suma un segundo para evitar problemas de llave
		If ls_log_cambios <> '' Then
			ldtm_fecha = DateTime(Date(ldtm_hoy), RelativeTime(Time(ldtm_hoy),1))
		Else
			ldtm_fecha = ldtm_hoy
		End If
		
		ll_fila = ads_observaciones.InsertRow(0)
		ads_observaciones.SetItem(ll_fila,"co_fabrica", ii_fabrica)
		ads_observaciones.SetItem(ll_fila,"pedido", il_pedido)
		ads_observaciones.SetItem(ll_fila,"co_planta", ii_planta)
		ads_observaciones.SetItem(ll_fila,"co_tipoprod", TIPOPROD)
		ads_observaciones.SetItem(ll_fila,"co_centro_pdn", CENTRO)	
		ads_observaciones.SetItem(ll_fila,"co_subcentro_pdn",li_subcentro)
		ads_observaciones.SetItem(ll_fila,"fe_creacion", ldtm_fecha)
		ads_observaciones.SetItem(ll_fila,"usuario", gstr_info_usuario.codigo_usuario )		
		ads_observaciones.SetItem(ll_fila,"observaciones", ls_observaciones)
	End If	
Next
	
Return 1	
end function

on n_cst_cronograma.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_cronograma.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Destroy(ids_cronograma)
end event

event constructor;This.Of_Reiniciar_Propiedades()
itr_transaccion = SQLCA
end event

