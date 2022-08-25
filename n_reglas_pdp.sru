HA$PBExportHeader$n_reglas_pdp.sru
forward
global type n_reglas_pdp from nonvisualobject
end type
end forward

global type n_reglas_pdp from nonvisualobject
end type
global n_reglas_pdp n_reglas_pdp

type variables
Boolean ib_validar_pasado, ib_mover_vertical, ib_mover_horizontal, ib_crear_capa_producido, ib_ver_todos
end variables

forward prototypes
public function boolean of_validar_pasado (datetime adtm_fecha)
public function boolean of_crear_capa_producido ()
public function long of_dias_a_programar (string as_tipo_pedido, long ai_dias)
public function boolean of_validar_pasado ()
public function boolean of_validar_mover_vertical ()
public function boolean of_validar_mover_horizontal ()
public function long of_validar_mover_barra (long al_pedido, string as_co_referencia)
public function string of_color_barras_item (long al_color_po, long al_color_allocation)
public function long of_opcion_barra (ref decimal adc_cantidad_pedida, decimal adc_cantidad_disponible)
public function boolean of_ver_todos ()
public function boolean of_validar_capacidad_minutos (long al_minutos_maquina, long al_minutos_pedido)
public function long of_set_reglas (long ai_tipo_negocio, string as_ventana)
public function long of_set_reglas (long ai_tipo_negocio)
public function datetime of_fecha_minima ()
public function boolean of_dias_de_atraso (ref long ai_dias_atraso, datetime adtm_fe_inicio_programada, datetime adtm_fe_fin_programada, datetime adtm_fe_inicio_pedido, datetime adtm_fe_fin_pedido, datetime adtm_fe_inicio_extrema, datetime adtm_fe_fin_extrema, datetime adtm_fe_inicio_detalle_pedido, datetime adtm_fe_fin_detalle_pedido)
public function boolean of_cambiar_curva (ref long al_co_curva, long al_co_maquina, long al_co_recurso)
public function boolean of_validar_unidad_tiempo ()
public function long of_estilo_barra_semaforo (string as_tipo_pedido, long ai_dias_atraso)
public function boolean of_validar_devolver_barra (string as_tipo_pedido, string as_bandera)
public function boolean of_validar_reservar (decimal adc_cantidad, decimal adc_capacidad_min, decimal adc_capacidad_max, string as_tipo_pedido, decimal adc_capacidad_min_ant, decimal adc_capacidad_max_ant, long al_maquina, long al_maquina_ant)
public function boolean of_validar_recursos (string as_tipo_pedido, long al_recurso_actual, long al_recurso_nuevo)
public function long of_color_maquinas (long ai_ordenar, long ai_encabezado, long al_color_experto, long al_color_opcion2, long al_color_opcion3, long al_color_todos, long al_color_recurso, long al_color_nas)
public function long of_fechas_limite_planeador (datetime adtm_fecha_servidor, ref datetime adtm_fecha_inicial, ref datetime adtm_fecha_final)
public function boolean of_validar_mover_vertical (decimal adc_ca_asignada)
public function long of_mover_fecha (ref datetime adtm_inicio, datetime adtm_inicio_original, datetime adtm_inicio_costura, datetime adtm_fin_anterior, long ai_mover)
public function boolean of_validar_renombrar (string as_tipo_pedido_allocation, string as_agrupacion_allocation, string as_agrupacion_po, string as_cliente_allocation, string as_cliente_po, long ai_co_recurso_allocation, long ai_co_recurso_po, string as_referencia_po, string as_referencia_allocation, boolean ab_validar)
public function boolean of_validar_desplazar ()
public function boolean of_validar_espacio_ocupado ()
public function boolean of_crear_nodo ()
public function boolean of_validar_pedido (long al_pedido, string as_tipo_pedido, string al_referencia)
public function boolean of_cambiar_estandar (ref decimal adc_estandar, decimal adc_capacidad_maquina, decimal adc_cantidad, long al_maquina, string as_referencia, string as_accion)
public function long of_sumar_tiempo_muerto (ref datetime adtm_fecha, s_parametros_barra astr_datos_barra_anterior, s_parametros_barra astr_datos_barra_actual)
public function boolean of_validar_barras_siguientes (s_parametros_barra astr_barra_actual, datastore ads_barras_siguientes, string as_accion)
public function long of_estilo_barra (s_parametros_barra astr_barra, long ai_dias_atraso)
public function string of_texto_barra (s_parametros_barra astr_barra, long ai_dias_atraso)
public function long of_color_barras_item (long al_color_po, long al_color_allocation, long al_color_prioridad_negra, long al_color_prioridad_roja, long al_color_prioridad_amarilla, long al_color_prioridad_verde, long al_color_prioridad_cian, ref datawindow adw_item)
public function boolean of_validar_partir_barra (s_parametros_barra astr_barra, decimal adc_cantidad)
end prototypes

public function boolean of_validar_pasado (datetime adtm_fecha);/*	-----------------------------------------------------------------------------------------
	La funci$$HEX1$$f300$$ENDHEX$$n v$$HEX1$$e100$$ENDHEX$$lida una regla de negocio. La regla es que no se pueden definir objetos en
	fechas pasadas a la actual
	----------------------------------------------------------------------------------------- */
	
DateTime ldtm_fecha_servidor

//Obtiene la fecha del servidor
ldtm_fecha_servidor = f_fecha_servidor()

//evalua si la fecha es menor que la del servidor y si esta activado el validar que no
//definan objetos en el pasado
IF Date(adtm_fecha) < Date(ldtm_fecha_servidor) And ib_validar_pasado Then
	Return False	
Else
	Return True
End IF

end function

public function boolean of_crear_capa_producido ();/*	-------------------------------------------------------------------------------
	La funci$$HEX1$$f300$$ENDHEX$$n retorna verdadero si en la configuraci$$HEX1$$f300$$ENDHEX$$n del tipo de negocio se 
	activo la funcionalidad de ver en una capa la cantidad producida de la barra.
	-------------------------------------------------------------------------------	*/
Return ib_crear_capa_producido
end function

public function long of_dias_a_programar (string as_tipo_pedido, long ai_dias);/*	------------------------------------------------------------------------------
	El scrip de esta funci$$HEX1$$f300$$ENDHEX$$n depende del negocio, se debe retorna el n$$HEX1$$fa00$$ENDHEX$$mero de 
	dias que se vayan a definir en la curva manual
	------------------------------------------------------------------------------ */


Return 1
end function

public function boolean of_validar_pasado ();/*	----------------------------------------------------------------------------
	Retorna verdadero si en la configuraci$$HEX1$$f300$$ENDHEX$$n del negocio se activo validar el
	pasado
	---------------------------------------------------------------------------- */
Return ib_validar_pasado
end function

public function boolean of_validar_mover_vertical ();/*	----------------------------------------------------------------------------
	Retorna verdadero si en la configuraci$$HEX1$$f300$$ENDHEX$$n del negocio se activo el mover 
	vertical
	---------------------------------------------------------------------------- */

Return ib_mover_vertical
end function

public function boolean of_validar_mover_horizontal ();/*	----------------------------------------------------------------------------
	Retorna verdadero si en la configuraci$$HEX1$$f300$$ENDHEX$$n del negocio se activo el mover 
	horizontal
	---------------------------------------------------------------------------- */

Return ib_mover_horizontal
end function

public function long of_validar_mover_barra (long al_pedido, string as_co_referencia);/*	----------------------------------------------------------------------------
	El scrip de esta funci$$HEX1$$f300$$ENDHEX$$n depende del negocio, aqui se debe validar si deja
	o no mover la barra, Retorna 1 si se va a dejar mover
	---------------------------------------------------------------------------*/
Return 1
end function

public function string of_color_barras_item (long al_color_po, long al_color_allocation);Return "33554432	"+String(al_color_allocation)


end function

public function long of_opcion_barra (ref decimal adc_cantidad_pedida, decimal adc_cantidad_disponible);/*	----------------------------------------------------------------------------------
	En esta funci$$HEX1$$f300$$ENDHEX$$n se deber$$HEX2$$e1002000$$ENDHEX$$codificar para que el usuario tome una decision cuando
	vaya a soltar una barra en el gantt y la cantidad pedida sea menor a la cantidad
	disponible en el lugar donde la va a soltar.
	
	Los valores que deber$$HEX2$$e1002000$$ENDHEX$$devolver la funci$$HEX1$$f300$$ENDHEX$$n son:
	
	-1 Error
	0	Si el usuario desea cancelar el soltar barra
	1	cuando se desee empujar las dem$$HEX1$$e100$$ENDHEX$$s barras
	2	Cuando desee partir la barra, en las unidades que caben en el espacio disponible
	3 	Cuando desee partir la barra en un n$$HEX1$$fa00$$ENDHEX$$mero de unidades elejido por el usuario, ese
		n$$HEX1$$fa00$$ENDHEX$$mero nunca debe superar la cantidad disponible. para modificar el n$$HEX1$$fa00$$ENDHEX$$mero de
		unidades que se quiere asignar a un espacio se debe de modificar la variable
		adc_cantidad_pedida que es una variable por referencia. Ese valor solo se debe
		modificar cuando la funci$$HEX1$$f300$$ENDHEX$$n retorne 3 y nunca debe de ser mayor a adc_cantidad_disponible
	---------------------------------------------------------------------------------- */
Return 1
end function

public function boolean of_ver_todos ();Return ib_ver_todos
end function

public function boolean of_validar_capacidad_minutos (long al_minutos_maquina, long al_minutos_pedido);Return True
end function

public function long of_set_reglas (long ai_tipo_negocio, string as_ventana);/*	------------------------------------------------------------------------------------------
	En esta funci$$HEX1$$f300$$ENDHEX$$n se cargan las reglas del negocio de la tabla de configuraci$$HEX1$$f300$$ENDHEX$$n de pdp, las
	reglas dependen del tipo de negocio. El tipo de negocio se recibe como argumento y con el
	se hace el retrieve para cargar las reglas del negocio de la base de datos, luego se asignan
	los valores a variables boleanas para luego ser retornados cuando se valide una de estas
	reglas
	------------------------------------------------------------------------------------------ */



Long li_regla, li_retorno
uo_dsbase lds_cargar_configuracion
lds_cargar_configuracion = Create uo_dsbase
lds_cargar_configuracion.DataObject = 'd_ff_configuracion_pdp'
lds_cargar_configuracion.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

//se hace trae la informaci$$HEX1$$f300$$ENDHEX$$n de la base de datos
If lds_cargar_configuracion.Of_retrieve(ai_tipo_negocio, as_ventana) < 1 Then
	ROLLBACK;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo configurar el PDP para el tipo de negocio " + String(ai_tipo_negocio))
	li_retorno = -1
Else	
	//se asignan los valores de configuraci$$HEX1$$f300$$ENDHEX$$n del tipo de negocio a variables de instancia
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'validar_pasado')
	if li_regla = 1 Then
		ib_validar_pasado = True
	Else
		ib_validar_pasado = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'mover_vertical')
	if li_regla = 1 Then
		ib_mover_vertical = True
	Else
		ib_mover_vertical = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'mover_horizontal')
	if li_regla = 1 Then
		ib_mover_horizontal = True
	Else
		ib_mover_horizontal = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'crear_capa_producido')
	if li_regla = 1 Then
		ib_crear_capa_producido = True
	Else
		ib_crear_capa_producido = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'ver_todos')
	if li_regla = 1 Then
		ib_ver_todos = True
	Else
		ib_ver_todos = False
	End IF
	li_retorno = 1
End IF	
Destroy(lds_cargar_configuracion)
Return li_retorno
end function

public function long of_set_reglas (long ai_tipo_negocio);/*	------------------------------------------------------------------------------------------
	En esta funci$$HEX1$$f300$$ENDHEX$$n se cargan las reglas del negocio de la tabla de configuraci$$HEX1$$f300$$ENDHEX$$n de pdp, las
	reglas dependen del tipo de negocio. El tipo de negocio se recibe como argumento y con el
	se hace el retrieve para cargar las reglas del negocio de la base de datos, luego se asignan
	los valores a variables boleanas para luego ser retornados cuando se valide una de estas
	reglas
	------------------------------------------------------------------------------------------ */



Long li_regla, li_retorno
uo_dsbase lds_cargar_configuracion
lds_cargar_configuracion = Create uo_dsbase
lds_cargar_configuracion.DataObject = 'd_ff_config_pdp'
lds_cargar_configuracion.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

//se hace trae la informaci$$HEX1$$f300$$ENDHEX$$n de la base de datos
If lds_cargar_configuracion.Of_retrieve(ai_tipo_negocio) < 1 Then
	ROLLBACK;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo configurar el PDP para el tipo de negocio " + String(ai_tipo_negocio))
	li_retorno = -1
Else	
	//se asignan los valores de configuraci$$HEX1$$f300$$ENDHEX$$n del tipo de negocio a variables de instancia
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'validar_pasado')
	if li_regla = 1 Then
		ib_validar_pasado = True
	Else
		ib_validar_pasado = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'mover_vertical')
	if li_regla = 1 Then
		ib_mover_vertical = True
	Else
		ib_mover_vertical = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'mover_horizontal')
	if li_regla = 1 Then
		ib_mover_horizontal = True
	Else
		ib_mover_horizontal = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'crear_capa_producido')
	if li_regla = 1 Then
		ib_crear_capa_producido = True
	Else
		ib_crear_capa_producido = False
	End IF
	
	li_regla = lds_cargar_configuracion.GetItemNumber(1,'ver_todos')
	if li_regla = 1 Then
		ib_ver_todos = True
	Else
		ib_ver_todos = False
	End IF
	li_retorno = 1
End IF	
Destroy(lds_cargar_configuracion)
Return li_retorno
end function

public function datetime of_fecha_minima ();/*	-------------------------------------------------------------------------------
	La funci$$HEX1$$f300$$ENDHEX$$n retorna la fecha minima en que se va a soltar la barra si esta
	activada la regla de validar pasado. para c$$HEX1$$f300$$ENDHEX$$dificar este scrip hay que tener
	en cuenta las funciones 'validar_pasado' y verificar que sean coherentes con
	est$$HEX2$$e1002000$$ENDHEX$$funci$$HEX1$$f300$$ENDHEX$$n. Esta funci$$HEX1$$f300$$ENDHEX$$n por defecto retorna la fecha del servidor sin tener
	en cuenta la hora
	-------------------------------------------------------------------------------*/
	
	datetime  ldtm_fecha

	
	ldtm_fecha = DateTime(Date(f_fecha_servidor()),Time('00:00:00'))
	
	If IsNull(ldtm_fecha) Or Date(ldtm_fecha) < Date('2007-01-01') Then
		ldtm_fecha = DateTime(Date(Today()),00:00:00)
	End If

	Return ldtm_fecha
	
	
	
	
	
	
end function

public function boolean of_dias_de_atraso (ref long ai_dias_atraso, datetime adtm_fe_inicio_programada, datetime adtm_fe_fin_programada, datetime adtm_fe_inicio_pedido, datetime adtm_fe_fin_pedido, datetime adtm_fe_inicio_extrema, datetime adtm_fe_fin_extrema, datetime adtm_fe_inicio_detalle_pedido, datetime adtm_fe_fin_detalle_pedido);ai_dias_atraso = DaysAfter(Date(adtm_fe_fin_extrema),Date(adtm_fe_fin_programada))
Return True
end function

public function boolean of_cambiar_curva (ref long al_co_curva, long al_co_maquina, long al_co_recurso);Return True
end function

public function boolean of_validar_unidad_tiempo ();/*
Funcion que decide si se trabaja como unidad de reserva y renombrar es el tiempo (True), 
o si se reserva conservando las unidades
*/
Return True
end function

public function long of_estilo_barra_semaforo (string as_tipo_pedido, long ai_dias_atraso);/*	-------------------------------------------------------------------------------
	El scrip de esta funci$$HEX1$$f300$$ENDHEX$$n depende del negocio. En el se debe determinar el estilo
	que va a llevar la barra cuando se activan los semaforos, 
	los estilos ya est$$HEX1$$e100$$ENDHEX$$n definidos en pdp g$$HEX1$$e900$$ENDHEX$$nerico
	------------------------------------------------------------------------------- */
	
Long li_estilo

Choose Case ai_dias_atraso
	Case Is > 0 
		// atrasado - rojo
		li_estilo = 13
	Case is < -2 
		// bien -  verde
		li_estilo = 11
	Case Else
		// esta a punto de atrasarse -  amarillo
		li_estilo = 12
End Choose				
Return  li_estilo
end function

public function boolean of_validar_devolver_barra (string as_tipo_pedido, string as_bandera);/*	----------------------------------------------------------------------------
	Retorna verdadero si en la regla del negocio se permite devolver la barra.
	---------------------------------------------------------------------------- */
Return True
end function

public function boolean of_validar_reservar (decimal adc_cantidad, decimal adc_capacidad_min, decimal adc_capacidad_max, string as_tipo_pedido, decimal adc_capacidad_min_ant, decimal adc_capacidad_max_ant, long al_maquina, long al_maquina_ant);If adc_cantidad <= 0 Then
	Return False
Else
	Return True
End IF
end function

public function boolean of_validar_recursos (string as_tipo_pedido, long al_recurso_actual, long al_recurso_nuevo);/*	----------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que retornar verdadero si se va a controlar el movimiento de las barras
	entre maquinas de diferente recurso
	---------------------------------------------------------------------------- */
Return True
end function

public function long of_color_maquinas (long ai_ordenar, long ai_encabezado, long al_color_experto, long al_color_opcion2, long al_color_opcion3, long al_color_todos, long al_color_recurso, long al_color_nas);Long ll_color_item

If ai_encabezado = 1 Then
	ll_color_item = al_color_recurso
Else
	Choose Case ai_ordenar
		Case 1
			ll_color_item = al_color_experto	
		Case 2
			ll_color_item = al_color_opcion2
		Case 3
			ll_color_item = al_color_opcion3
		Case 9
			ll_color_item = al_color_nas
		Case else
			ll_color_item = al_color_todos		
	End Choose	
End IF
Return ll_color_item
end function

public function long of_fechas_limite_planeador (datetime adtm_fecha_servidor, ref datetime adtm_fecha_inicial, ref datetime adtm_fecha_final);/*	-------------------------------------------------------------------------
	En esta regla se define la fecha inicial y la fecha final del planeador
	------------------------------------------------------------------------- */

Return 1	
end function

public function boolean of_validar_mover_vertical (decimal adc_ca_asignada);/*	----------------------------------------------------------------------------
	Retorna verdadero si en la configuraci$$HEX1$$f300$$ENDHEX$$n del negocio se activo el mover 
	vertical
	---------------------------------------------------------------------------- */

Return This.Of_Validar_Mover_Vertical()
end function

public function long of_mover_fecha (ref datetime adtm_inicio, datetime adtm_inicio_original, datetime adtm_inicio_costura, datetime adtm_fin_anterior, long ai_mover);// Funcion para recalcular la fecha de inicio de la barra
// ai_mover: 0 mover, 1 no mover, 2 dejar la fecha fija

Boolean lb_conflicto

If adtm_inicio_original <= adtm_fin_anterior Then
	//la barra actual cambia su fecha de inicio por la fecha fin de la que tiene conflicto, es decir, la barra anterior
	adtm_inicio = adtm_fin_anterior
	lb_conflicto = True
Else		
	lb_conflicto = False
	If ai_mover > 0 Then
		adtm_inicio = adtm_inicio_original
	//Si la barra se puede mover para atras en el tiempo, lo hara solo hasta el inicio de costura							
	ElseIf adtm_fin_anterior >= adtm_inicio_costura Then
		adtm_inicio = adtm_fin_anterior
	//si la fecha de inicio de costura es menor que la fecha fin programada
	ElseIf adtm_inicio_costura < adtm_inicio_original Then
		// toma la fecha de inicio de costura
		adtm_inicio = adtm_inicio_costura
	Else
		//toma la fecha inicio de la barra actual
		adtm_inicio = adtm_inicio_original
	End If
End IF

// Si la barra no se puede mover se deja en el mismo sitio
If ai_mover = 0 Then
	Return 1
ElseIf ai_mover > 1 Then
	If lb_conflicto Then
		Return -1		
	Else
		Return 1
	End If		
End If

Return 1

end function

public function boolean of_validar_renombrar (string as_tipo_pedido_allocation, string as_agrupacion_allocation, string as_agrupacion_po, string as_cliente_allocation, string as_cliente_po, long ai_co_recurso_allocation, long ai_co_recurso_po, string as_referencia_po, string as_referencia_allocation, boolean ab_validar);/*	----------------------------------------------------------------------------------------------
	El scrip depende del tipo de negocio, aqui se debe validar si se permite o 
	no renombrar el pedido, esta funci$$HEX1$$f300$$ENDHEX$$n tambien sirva para saber cuales barras
	se pueden renombrar y resaltarlas, la variable ab_validar indica si la
	funci$$HEX1$$f300$$ENDHEX$$n se llama desde el servicio reservar(true) o desde la funci$$HEX1$$f300$$ENDHEX$$n que
	resalta las barras(false). 
	----------------------------------------------------------------------------------------------	*/

Return True
end function

public function boolean of_validar_desplazar ();/*	----------------------------------------------------------------------------
	Regla para validar si se pueden desplazar las barras contiguas
	---------------------------------------------------------------------------- */
	
If MessageBox("Espacio ocupado","Desea desplazar las barras contiguas",exclamation!,YesNo!) = 1 Then
	Return true
Else
	Return false
End IF
end function

public function boolean of_validar_espacio_ocupado ();Return true
end function

public function boolean of_crear_nodo ();Return false
end function

public function boolean of_validar_pedido (long al_pedido, string as_tipo_pedido, string al_referencia);/*	-----------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para validar si el pedido se puede programar. 
	----------------------------------------------------------------------------------- */

Return True
end function

public function boolean of_cambiar_estandar (ref decimal adc_estandar, decimal adc_capacidad_maquina, decimal adc_cantidad, long al_maquina, string as_referencia, string as_accion);/*
El parametro accion puede tomar los siguientes valores

Renombrar
Programar
Partir
Mover Vertical
Unir
*/


Return True
end function

public function long of_sumar_tiempo_muerto (ref datetime adtm_fecha, s_parametros_barra astr_datos_barra_anterior, s_parametros_barra astr_datos_barra_actual);/*	------------------------------------------------------------------------------
	La funci$$HEX1$$f300$$ENDHEX$$n Modifica la Fecha que se le pasa como referencia, sumandole el tiempo
	que se quiera definir como tiempo muerto
	------------------------------------------------------------------------------ */
Return 1
end function

public function boolean of_validar_barras_siguientes (s_parametros_barra astr_barra_actual, datastore ads_barras_siguientes, string as_accion);/* FACL - 2011-11-29: Funcion para validar las barras siguientes
 Se puede usar para validar los tipos de pedidos(cadena_3), estados de pedido(cadena_9)
 	o la prioridad de TOC (entero_17). para mas informacion consultar w_pdp_generico.of_pintar_barras
*/

////Ej: no permitir barras con el color de prioridad
//Long ll_find
//ll_find = ads_barras_siguientes.Find( 'cadena_3 < "' + String(astr_barra_actual.cadena[3])+'"', 1, ads_barras_siguientes.RowCount())
//If ll_find > 0 Then 
//	MessageBox('Atencion', 'Barra 1 ' + String(astr_barra_actual.barraid) + ' Tipo_pedido ' + astr_barra_actual.cadena[3] &
//		+ ' Barra 2 ' + String(ads_barras_siguientes.GetItemNumber( ll_find, 'barraid')) + ' Tipo_pedido ' + ads_barras_siguientes.GetItemString( ll_find, 'cadena_3'))
//	Return False
//Else
//	Return True
//End If


Return True
end function

public function long of_estilo_barra (s_parametros_barra astr_barra, long ai_dias_atraso);/*	-------------------------------------------------------------------------------
	El scrip de esta funci$$HEX1$$f300$$ENDHEX$$n depende del negocio. En el se debe determinar el estilo
	que va a llevar la barra, los estilos ya est$$HEX1$$e100$$ENDHEX$$n definidos en pdp g$$HEX1$$e900$$ENDHEX$$nerico
	------------------------------------------------------------------------------- */
/*
Choose Case astr_barra.cadena[3] // Se evalua el tipo pedido
	Case 'AC', 'AP'
		If ai_dias_atraso > 0 Then
			ll_estilo_barra = 9 //pinta la barra del color con el que se pintan las ordenes atrasadas
		Else
			ll_estilo_barra = 2
		End If
	Case 'NA','EX','SM'
		If ai_dias_atraso > 0 Then
			ll_estilo_barra = 8 //pinta la barra del color con el que se pintan las ordenes atrasadas
		Else
			ll_estilo_barra = 1 
		End If
	Case Else
		ll_estilo_barra = 21
End Choose

Return  ll_estilo_barra
*/

Return  1
end function

public function string of_texto_barra (s_parametros_barra astr_barra, long ai_dias_atraso);// Funcion para fijar el texto de la barra
// cadena[7] descripcion de la referencia

Return String(ai_dias_atraso) +','+Trim(astr_barra.Cadena[7])
end function

public function long of_color_barras_item (long al_color_po, long al_color_allocation, long al_color_prioridad_negra, long al_color_prioridad_roja, long al_color_prioridad_amarilla, long al_color_prioridad_verde, long al_color_prioridad_cian, ref datawindow adw_item);
String ls_color, ls_expresion

ls_expresion = String(al_color_allocation)
ls_color =  "33554432	"+ ls_expresion

adw_item.Object.barra.Background.Color = ls_color


Return 1


end function

public function boolean of_validar_partir_barra (s_parametros_barra astr_barra, decimal adc_cantidad);/*	----------------------------------------------------------------------------
	Retorna verdadero si en la regla del negocio se permite partir la barra.
	---------------------------------------------------------------------------- */
Return True
end function

on n_reglas_pdp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_reglas_pdp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

