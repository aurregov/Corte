HA$PBExportHeader$n_reglas_pdp_confeccion.sru
forward
global type n_reglas_pdp_confeccion from n_reglas_pdp
end type
end forward

global type n_reglas_pdp_confeccion from n_reglas_pdp
end type
global n_reglas_pdp_confeccion n_reglas_pdp_confeccion

type variables
n_utilidades_calendario_new1 invo_utilidad
end variables

forward prototypes
public function long of_estilo_barra (string as_tipo_pedido, long ai_dias_atraso)
public function long of_dias_a_programar (string as_tipo_pedido, long ai_dias)
public function long of_validar_mover_barra (long al_pedido, string as_co_referencia)
public function string of_color_barras_item (long al_color_po, long al_color_allocation)
public function long of_opcion_barra (ref decimal adc_cantidad_pedida, decimal adc_cantidad_disponible)
public function string of_texto_barra (long ai_dias_de_atraso, string as_de_referencia)
public function long of_fechas_limite_planeador (datetime adtm_fecha_servidor, ref datetime adtm_fecha_inicial, ref datetime adtm_fecha_final)
public function long of_mover_fecha (ref datetime adtm_inicio, datetime adtm_inicio_original, datetime adtm_inicio_costura, datetime adtm_fin_anterior, long ai_mover)
public function boolean of_validar_renombrar (string as_tipo_pedido_allocation, string as_agrupacion_allocation, string as_agrupacion_po, string as_cliente_allocation, string as_cliente_po, long ai_co_recurso_allocation, long ai_co_recurso_po, string as_referencia_po, string as_referencia_allocation, boolean ab_validar)
public function boolean of_crear_nodo ()
public function boolean of_validar_pedido (long al_pedido, string as_tipo_pedido, string al_referencia)
public function long of_sumar_tiempo_muerto (ref datetime adtm_fecha, s_parametros_barra astr_datos_barra_anterior, s_parametros_barra astr_datos_barra_actual)
public function string of_texto_barra (s_parametros_barra astr_barra, long ai_dias_atraso)
public function long of_estilo_barra (s_parametros_barra astr_barra, long ai_dias_atraso)
public function long of_color_barras_item (long al_color_po, long al_color_allocation, long al_color_prioridad_negra, long al_color_prioridad_roja, long al_color_prioridad_amarilla, long al_color_prioridad_verde, long al_color_prioridad_cian, ref datawindow adw_item)
end prototypes

public function long of_estilo_barra (string as_tipo_pedido, long ai_dias_atraso);/*	------------------------------------------------------------------------------
	En esta funci$$HEX1$$f300$$ENDHEX$$n se determina que estilo debe de llevar la barra que se va a
	dibujar, el estilo que se escoja depende del tipo de pedido y de los dias de
	atraso que tenga.
	------------------------------------------------------------------------------ */

Long ll_estilo_barra


//		Choose Case as_tipo_pedido
//			Case 'AC', 'AP'
//				If ai_dias_atraso > 0 Then
//					ll_estilo_barra = 9 //pinta la barra del color con el que se pintan las ordenes atrasadas
//				Else
//					ll_estilo_barra = 2
//				End If
//			Case 'NA','EX','SM'
//				If ai_dias_atraso > 0 Then
//					ll_estilo_barra = 8 //pinta la barra del color con el que se pintan las ordenes atrasadas
//				Else
//					ll_estilo_barra = 1 
//				End If
//		End Choose

Choose Case as_tipo_pedido
	Case '1'
		ll_estilo_barra = 16
	Case '2'
		ll_estilo_barra = 17
	Case '3'
		ll_estilo_barra = 18
	Case '4'
		ll_estilo_barra = 19
	Case '5'
		ll_estilo_barra = 20
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
end function

public function long of_dias_a_programar (string as_tipo_pedido, long ai_dias);/*	----------------------------------------------------------------------------
	Si el pedido es de tipo AC o AP es porque es una allocation, y por lo  tanto
	tiene ya los dias en los que se va a hacer el pedido
	----------------------------------------------------------------------------	*/

Long li_dias

IF as_tipo_pedido = 'AC' Or as_tipo_pedido = 'AP' Then
	li_dias =  ai_dias
Else
	li_dias = 1
End IF

Return li_dias
end function

public function long of_validar_mover_barra (long al_pedido, string as_co_referencia);/*	-----------------------------------------------------------------------------
	La funci$$HEX1$$f300$$ENDHEX$$n muestra un mesaje indicando que no se puede mover esa barra,
	y retorna 1 si el usuario decide moverla, y 2 si decide no moverla
	----------------------------------------------------------------------------- */

Return MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","La barra asociada a la referencia "+trim(as_co_referencia)+"~ esta marcada con el indicativo de no mover ~ desea moverla de todas formas ?",Question!,YesNo!) 
end function

public function string of_color_barras_item (long al_color_po, long al_color_allocation);/*
String ls_color, ls_color_negra, ls_color_roja, ls_color_amarilla, ls_color_verde

If is_campo_color_prioridad <> '' Then
	ls_color_negra = RGB(0,0,0)
	
	
	
	ls_color = "If (" &
			+ "Case( is_campo_color_prioridad "
				+	"When '1' Then " + ls_color_negra
End If

adw_item.Modify("barra.Background.Color = '" + String(al_color_allocation) + "'")

Return 1

*/
Return "33554432	If(tipo_pedido='AC' OR tipo_pedido='AP'," &
	+ String(al_color_allocation) + ',' + String(al_color_po) + ')' 
	
	
	
end function

public function long of_opcion_barra (ref decimal adc_cantidad_pedida, decimal adc_cantidad_disponible);s_base_parametros lsp_opbarra
lsp_opbarra.hay_parametros = True
lsp_opbarra.Entero[1] = adc_cantidad_disponible
lsp_opbarra.Entero[2] = adc_cantidad_pedida
//OpenWithParm(w_opcion_barra, lsp_opbarra)
lsp_opbarra = Message.PowerObjectparm
If lsp_opbarra.hay_parametros = False Then Return -1
Choose Case lsp_opbarra.Cadena[1]
	//Empujar	
	Case 'EM'
		Return 1
	//Partir Autom$$HEX1$$e100$$ENDHEX$$tico
	Case 'PA'
		Return 2
	Case 'PM'
		//partir cantidad elejidad por el usuario
		adc_cantidad_pedida = lsp_opbarra.Entero[1]
		Return 3
End Choose 
Return 0		

	
end function

public function string of_texto_barra (long ai_dias_de_atraso, string as_de_referencia);String ls_texto
If Not IsNull(ai_dias_de_atraso) Then
	ls_texto = String(ai_dias_de_atraso)
End If
ls_texto += ','
If Not IsNull(as_de_referencia) Then
	ls_texto += Trim(as_de_referencia)
End If

Return ls_texto
end function

public function long of_fechas_limite_planeador (datetime adtm_fecha_servidor, ref datetime adtm_fecha_inicial, ref datetime adtm_fecha_final);adtm_fecha_inicial = DateTime(RelativeDate(Date(adtm_fecha_servidor),-7),Time('00:00:00'))
Return 1
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
	//Si la barra se puede mover para atras en el tiempo, lo hara solo hasta el inicio de costura							
	If adtm_fin_anterior >= adtm_inicio_costura Then
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
ElseIf ai_mover = 1 Then
	If adtm_inicio = adtm_inicio_original Then
		Return 1
	Else
		adtm_inicio = adtm_inicio_original
		Return -1
	End If
ElseIf ai_mover = 2 Then
	If lb_conflicto Then
		Return -1		
	Else
		adtm_inicio = adtm_inicio_original
		Return 1
	End If		
End If
Return 1


end function

public function boolean of_validar_renombrar (string as_tipo_pedido_allocation, string as_agrupacion_allocation, string as_agrupacion_po, string as_cliente_allocation, string as_cliente_po, long ai_co_recurso_allocation, long ai_co_recurso_po, string as_referencia_po, string as_referencia_allocation, boolean ab_validar);/*	----------------------------------------------------------------------------
	La funci$$HEX1$$f300$$ENDHEX$$n v$$HEX1$$e100$$ENDHEX$$lida si el pedido se puede renombrar. El pedido se puede renombrar
	siempre y cuando cumpla con las siguientes condiciones:
	
	- El tipo_pedido del allocation sea igual a 'AP'
	- El cliente del allocation sea el mismo de la Po
	- El grupo del allocation sea el mismo de la po
	- La familia del allocation sea igual a la de la po
	----------------------------------------------------------------------------	*/

String ls_mensaje_validacion

If as_tipo_pedido_allocation = 'AP' Then
	IF as_agrupacion_po = as_agrupacion_allocation Then
		If as_cliente_po = as_cliente_allocation Then
			If ai_co_recurso_po = ai_co_recurso_allocation Then
				Return True
			Else
				ls_mensaje_validacion = "El Allocation debe de ser de la misma familia que la PO"
//				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El Allocation debe de ser de la misma familia que la PO")
			End IF
		Else
			ls_mensaje_validacion = "El cliente del Allocation es diferente al de la PO"
//			MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El cliente del Allocation es diferente al de la PO")
		End IF
	Else
		ls_mensaje_validacion = "La Agrupaci$$HEX1$$f300$$ENDHEX$$n del Allocation es diferente a la de la PO"
		//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La Agrupaci$$HEX1$$f300$$ENDHEX$$n del Allocation es diferente a la de la PO")
	End IF
Else
	If as_tipo_pedido_allocation = 'AC' Then
		ls_mensaje_validacion = "El allocation debe de estar en estado PROYECTADO"
//		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El allocation debe de estar en estado PROYECTADO")
	Else
		ls_mensaje_validacion = "En la fecha ya existe una PO"
//		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","En la fecha ya existe una PO")
	End IF
End IF

IF ab_validar Then MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n",ls_mensaje_validacion)

Return False
end function

public function boolean of_crear_nodo ();Return true
end function

public function boolean of_validar_pedido (long al_pedido, string as_tipo_pedido, string al_referencia);/*	-----------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para validar si el pedido se puede programar. Un pedido no se puede programar
	cuando es un pedido real y el nodo no existe, cuando esto pasa se debe de hacer por
	la ventana de renombrar 
	----------------------------------------------------------------------------------- */


Long ll_fabrica, ll_linea, ll_referencia
uo_dsbase lds_nodo


//Si el pedido es Real
If as_tipo_pedido = 'NA' or as_tipo_pedido = 'EX' or as_tipo_pedido = 'SM' Then
	
	
	lds_nodo = Create uo_dsbase
	lds_nodo.DataObject = "d_gr_arbol_raiz"
	lds_nodo.SetTransObject(SQLCA)
	
	//Descomponemos la referencia en fabrica-linea-referencia
	ll_fabrica 		= Long(Left(al_referencia, 5))
	ll_linea 		= Long(Mid(al_referencia,6, 5))
	ll_referencia 	= Long(Right(al_referencia,20))
	
	//Consultamos si existe un nodo para el pedido - referencia
	If lds_nodo.Retrieve(al_pedido, ll_fabrica, ll_linea, ll_referencia) <= 0 Then
		
		//Si el nodo no existe este pedido se debe de programar por la ventana de referencias.
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Al pedido que se quiere programar se le ha borrado el nodo. Para programarlo de nuevo se debe de hacer por la ventana de renombrar allocation")
		Destroy lds_nodo
		Return False
	End IF
	
	Destroy lds_nodo
End IF

Return True

end function

public function long of_sumar_tiempo_muerto (ref datetime adtm_fecha, s_parametros_barra astr_datos_barra_anterior, s_parametros_barra astr_datos_barra_actual);DateTime ldtm_fecha_fin_anterior, ldtm_fecha_inicio_actual, ldtm_fecha_fin_mas_minutos

If astr_datos_barra_actual.hay_parametros and astr_datos_barra_anterior.hay_parametros Then
	ldtm_fecha_inicio_actual = astr_datos_barra_actual.fecha_inicio
	ldtm_fecha_fin_anterior = astr_datos_barra_anterior.fecha_fin
	invo_utilidad.of_Sumar_Minutos( ldtm_fecha_fin_anterior, 1, ldtm_fecha_fin_mas_minutos)
	If ldtm_fecha_fin_mas_minutos > ldtm_fecha_inicio_actual Then
		adtm_fecha =  ldtm_fecha_fin_mas_minutos
	End If
End If

Return 1

end function

public function string of_texto_barra (s_parametros_barra astr_barra, long ai_dias_atraso);String ls_texto
If Not IsNull(ai_dias_atraso) Then
	ls_texto = String(ai_dias_atraso)
End If
ls_texto += ','
If Not IsNull(astr_barra.cadena[7]) Then
	ls_texto += Trim(astr_barra.cadena[7])
End If

Return ls_texto
end function

public function long of_estilo_barra (s_parametros_barra astr_barra, long ai_dias_atraso);/*	------------------------------------------------------------------------------
	En esta funci$$HEX1$$f300$$ENDHEX$$n se determina que estilo debe de llevar la barra que se va a
	dibujar, el estilo que se escoja depende del tipo de pedido y de los dias de
	atraso que tenga.
	
	Entero[17] - Color Prioridad TOC
	Cadena[3] - Tipo de Pedido
	------------------------------------------------------------------------------ */

Long ll_estilo_barra, li_color_prioridad

If UpperBound(astr_barra.entero) >= 17 Then
	li_color_prioridad = astr_barra.entero[17]
Else
	li_color_prioridad = -1
End If
// Se evalua la prioridad TOC
Choose Case li_color_prioridad
	Case 1
		ll_estilo_barra = 16
	Case 2
		ll_estilo_barra = 17
	Case 3
		ll_estilo_barra = 18
	Case 4
		ll_estilo_barra = 19
	Case 5
		ll_estilo_barra = 20
	Case Else
		ll_estilo_barra = 21
//		Choose Case astr_barra.cadena[3] // Se evalua el tipo pedido
//			Case 'AC', 'AP'
//				If ai_dias_atraso > 0 Then
//					ll_estilo_barra = 9 //pinta la barra del color con el que se pintan las ordenes atrasadas
//				Else
//					ll_estilo_barra = 2
//				End If
//			Case 'NA','EX','SM'
//				If ai_dias_atraso > 0 Then
//					ll_estilo_barra = 8 //pinta la barra del color con el que se pintan las ordenes atrasadas
//				Else
//					ll_estilo_barra = 1 
//				End If
//			Case Else
//				ll_estilo_barra = 21
//		End Choose
End Choose

Return  ll_estilo_barra
end function

public function long of_color_barras_item (long al_color_po, long al_color_allocation, long al_color_prioridad_negra, long al_color_prioridad_roja, long al_color_prioridad_amarilla, long al_color_prioridad_verde, long al_color_prioridad_cian, ref datawindow adw_item);String ls_color, ls_modify, ls_error, ls_describe, ls_expresion

ls_color = "Case( color_prioridad " &
			+	" When 1 Then " + String(al_color_prioridad_negra) &
			+	" When 2 Then " + String(al_color_prioridad_roja) &
			+	" When 3 Then " + String(al_color_prioridad_amarilla) &
			+	" When 4 Then " + String(al_color_prioridad_verde) &
			+	" When 5 Then " + String(al_color_prioridad_cian) &
			+	" Else " + String(RGB(255,255,255)) + ")" 


//ls_describe = adw_item.Describe('barra.Background.Color')

//ls_expresion = "If( color_prioridad_estado = '1', " + String(al_color_prioridad_negra) &
//			+	" , " + String(al_color_prioridad_roja) + ")"
//
ls_color = "33554432	" + ls_color
//
//ls_color = "33554432	If(tipo_pedido='AC' OR tipo_pedido='AP'," &
//	+ String(al_color_allocation) + ',' + String(al_color_po) + ')' 
//
//If ls_describe <> '!' Then
//	adw_item.Object.barra.Background.Color = ls_color
//End If


//ls_modify = 'barra.Background.Color ="0~t' + ls_color + '"'
//
//ls_error = adw_item.Modify( ls_modify )
//

//ls_color = "33554432	" + ls_expresion

ls_modify = 'barra.Background.Color ="' + ls_color + '"'

ls_error = adw_item.Modify( ls_modify )

Return 1

end function

on n_reglas_pdp_confeccion.create
call super::create
end on

on n_reglas_pdp_confeccion.destroy
call super::destroy
end on

event constructor;call super::constructor;ib_validar_pasado = True
end event

