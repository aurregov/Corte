HA$PBExportHeader$n_reglas_pdp_corte.sru
forward
global type n_reglas_pdp_corte from n_reglas_pdp
end type
end forward

global type n_reglas_pdp_corte from n_reglas_pdp
end type
global n_reglas_pdp_corte n_reglas_pdp_corte

type variables
n_utilidades_calendario_new invo_utilidad

end variables

forward prototypes
public function long of_estilo_barra (string as_tipo_pedido, long ai_dias_atraso)
public function boolean of_validar_estados_siguientes (string as_estado_pedido, string as_estados_pedidos_siguientes[])
public function boolean of_dias_de_atraso (ref long ai_dias_atraso, datetime adtm_fe_inicio_programada, datetime adtm_fe_fin_programada, datetime adtm_fe_inicio_pedido, datetime adtm_fe_fin_pedido, datetime adtm_fe_inicio_extrema, datetime adtm_fe_fin_extrema, datetime adtm_fe_inicio_detalle_pedido, datetime adtm_fe_fin_detalle_pedido)
public function decimal of_calcular_estandar (long an_oc, long an_raya)
public function long of_calcular_tiempo_por_capa (long an_oc, decimal adc_largo, long an_num_capas, ref decimal adc_tiempo_x_capa, ref decimal adc_tiempo_ext, long an_tipo_tela)
public function boolean of_cambiar_estandar (ref decimal adc_estandar, decimal adc_capacidad_maquina, decimal adc_cantidad, long al_maquina, string as_referencia, string as_accion)
public function boolean of_validar_reservar (decimal adc_cantidad, decimal adc_capacidad_min, decimal adc_capacidad_max, string as_tipo_pedido, decimal adc_capacidad_min_ant, decimal adc_capacidad_max_ant, long al_maquina, long al_maquina_ant)
public function long of_sumar_tiempo_muerto (ref datetime adtm_fecha, s_parametros_barra astr_datos_barra_anterior, s_parametros_barra astr_datos_barra_actual)
public function long of_estilo_barra (s_parametros_barra astr_barra, long ai_dias_atraso)
end prototypes

public function long of_estilo_barra (string as_tipo_pedido, long ai_dias_atraso);Long ll_estilo_barra


		Choose Case Trim(as_tipo_pedido)
			Case '11' //mercadas
				
					ll_estilo_barra = 14
				
			Case '2','1','3','4' //PROGRAMADAS
			   //If ai_dias_atraso > 0 Then
				//	ll_estilo_barra = 8 //pinta la barra del color con el que se pintan las ordenes atrasadas
				//Else
					ll_estilo_barra = 1 
				//End If
			case '12' //en riel
				ll_estilo_barra = 9
			case '13' //en extendido
			//	ll_estilo_barra = 3
					ll_estilo_barra = 10
			//ll_estilo_barra = 13
				
			case '14','6','5'
				ll_estilo_barra=2
				
			//APROBACI$$HEX1$$d300$$ENDHEX$$N CALIDAD
		   case '15'
				ll_estilo_barra = 22 //16
				
			Case else
				//ll_estilo_barra=2
				ll_estilo_barra = 10
		End Choose

Return  ll_estilo_barra


end function

public function boolean of_validar_estados_siguientes (string as_estado_pedido, string as_estados_pedidos_siguientes[]);long ll_i,ll_estado,ll_estado_ped




/*For ll_i = 1 to UpperBound(as_estados_pedidos_siguientes)
	
	ll_estado=long(as_estados_pedidos_siguientes[ll_i])
	ll_estado_ped=long(as_estado_pedido)
	//programado versus riel,ext,mercado
	If ll_estado>=4 and  ll_estado_ped<4 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Existe ordenes de corte mercadas,riel o extendidas adelante de esta fecha")
		Return False
	End If
	
	
	If (ll_estado>11 )and  ll_estado_ped=11 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Existe ordenes de corte riel o extendidas adelante de esta fecha")
		Return False
	End If
	
	
	If (ll_estado>12 )and  ll_estado_ped=12 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Existe ordenes de corte  extendidas adelante de esta fecha")
		Return False
	End If
	
	If  (ll_estado_ped>ll_estado)  Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Existe ordenes de corte mercadas,riel o extendidas adelante de esta fecha")
		Return False
	End If
	

	
	
	
	//If ll_estado_ped
	
	
Next*/


return true
end function

public function boolean of_dias_de_atraso (ref long ai_dias_atraso, datetime adtm_fe_inicio_programada, datetime adtm_fe_fin_programada, datetime adtm_fe_inicio_pedido, datetime adtm_fe_fin_pedido, datetime adtm_fe_inicio_extrema, datetime adtm_fe_fin_extrema, datetime adtm_fe_inicio_detalle_pedido, datetime adtm_fe_fin_detalle_pedido);ai_dias_atraso = DaysAfter(Date(adtm_fe_fin_pedido),Date(adtm_fe_fin_programada))
Return True
end function

public function decimal of_calcular_estandar (long an_oc, long an_raya);//funcion que dada la O.C y la raya calcula el estandar
//1.halla el tiempo por capa
//2.halla el tiempo extendido 
//3.suma los tiempos de extendido

Long    ll_filas_info, ll_n, ll_num_capas, ll_calculo_estandar, ll_tipo_tela
Decimal ldc_largo, ldc_tiempo_capas, ldc_tiempo_ext, ldc_tiempo_ext_tot


uo_dsbase lds_info_cal_est

//datasotre para consultar por O.C,raya. el trazo,largo,espacio y numero de capas
lds_info_cal_est = Create uo_dsbase				
lds_info_cal_est.dataobject = "dtb_info_calc_estandar_oc"
lds_info_cal_est.settransobject(gnv_recursos.of_get_transaccion_sucia())

ll_filas_info = lds_info_cal_est.Retrieve(an_oc,an_raya)

//valida que no haya error en caso de que haber error devuelve -1
IF ll_filas_info < 0 THEN
	messagebox("Error","Al consultar informacion de la O.C: "+string(an_oc))
	RETURN -1
END IF

//si no tiene datos informa que no tiene tipo de extendido matriculado
IF ll_filas_info = 0 THEN
	messagebox("Aviso","No se encontro informacion para la O.C: "+string(an_oc))
	RETURN -1
END IF

//cilco para traer informacion para calcular el tiempo estandar
FOR ll_n = 1 TO ll_filas_info
	ldc_largo    = lds_info_cal_est.getitemdecimal(ll_n,"largo")
	ll_num_capas = lds_info_cal_est.getitemnumber(ll_n,'capas') 
	ll_tipo_tela = lds_info_cal_est.getitemnumber(ll_n,'co_ttejido') 
	
	//valdia que no se vaya enviar un nulo a la funcion
	IF isnull(ldc_largo) THEN
		ldc_largo = 0
	END IF	
	
	//valdia que no se vaya enviar un nulo a la funcion
	IF isnull(ll_num_capas) THEN
		ll_num_capas = 0
	END IF
	
	//valdia que no se vaya enviar un nulo a la funcion
	IF isnull(ll_tipo_tela) THEN
		ll_tipo_tela = 0
	END IF
	
	//llama a funcion que calcula el tiempo de extendido
	ll_calculo_estandar = of_calcular_tiempo_por_capa(an_oc,ldc_largo,ll_num_capas,ldc_tiempo_capas,ldc_tiempo_ext,ll_tipo_tela)
	
	IF ll_calculo_estandar  = -1 THEN
		messagebox("Erro","Al calcular tiempo estandar")
	   RETURN -1
	END IF
	
	ldc_tiempo_ext_tot = ldc_tiempo_ext_tot + ldc_tiempo_ext
	
NEXT

//ldc_tiempo_ext_tot = 2

RETURN ldc_tiempo_ext_tot
end function

public function long of_calcular_tiempo_por_capa (long an_oc, decimal adc_largo, long an_num_capas, ref decimal adc_tiempo_x_capa, ref decimal adc_tiempo_ext, long an_tipo_tela);//funcion que haya el tiempo por capa y el tiempo de extendido
//1.verifica si el extendido es cara o un solo sentido(cara arriba)
//2.segun el tipo de extendido trae el estandar
//3.multiplica el estandar por el largo(tiempo por capa)
//4.multiplica el tiempo por capa por el numero de capas(tiempo extendido)

Long      ll_instruccion_ext[], ll_filas_tipo_ext, ll_tipo_extendido, ll_tipo_estandar, ll_filas_estandar
Decimal{1} ldc_largo
Decimal{3} ldc_estandar

uo_dsbase lds_tipo_extendido, lds_estandar_x_tipo

//datastore que trae el tipo de extendido
lds_tipo_extendido = Create uo_dsbase				
lds_tipo_extendido.dataobject = "dtb_verificar_extendido_x_oc"
lds_tipo_extendido.settransobject(gnv_recursos.of_get_transaccion_sucia())

//datastore que trae el estandar segun el tipo de estendido y el largo
lds_estandar_x_tipo = Create uo_dsbase				
lds_estandar_x_tipo.dataobject = "dtb_consulta_estandar_x_capa"
lds_estandar_x_tipo.settransobject(gnv_recursos.of_get_transaccion_sucia())


ll_instruccion_ext[1] = 6  //instruccion cara a cara
ll_instruccion_ext[2] = 7  //instruccion cara arriba(un solo sentido)
//ll_instruccion_ext[3] = 12 //manual

ll_filas_tipo_ext = lds_tipo_extendido.Retrieve(ll_instruccion_ext,an_oc)

//valida que no haya error en caso de que haber error devuelve -1
IF ll_filas_tipo_ext < 0 THEN
	messagebox("Error","Al consultar tipo de extendido")
	RETURN -1
END IF

//si no tiene datos informa que no tiene tipo de extendido matriculado
IF ll_filas_tipo_ext = 0 THEN
	messagebox("Aviso","No se encontro extendido para la O.C: "+string(an_oc))
	RETURN -1
END IF

ll_tipo_extendido = lds_tipo_extendido.getitemnumber(1,'co_instruccion')

//si el extendido es cara a cara
IF ll_tipo_extendido = 6 THEN
	ll_tipo_estandar = 1
END IF

//si el extendido es cara arriba(un solo sentido)
IF ll_tipo_extendido = 7 THEN
	ll_tipo_estandar = 2
END IF

//si el tipo de la tela es entretelas se va por otro estandar
IF an_tipo_tela = 132 THEN
	ll_tipo_estandar = 3
	ldc_largo = 0
ELSE
	ldc_largo = adc_largo
END IF

ll_filas_estandar = lds_estandar_x_tipo.retrieve(ll_tipo_estandar,ldc_largo)

//valida que no haya error en caso de que haber error devuelve -1
IF ll_filas_estandar < 0 THEN
	messagebox("Error","Al consultar tipo de extendido")
	RETURN -1
END IF

//si no tiene datos informa que no tiene tipo de extendido matriculado
IF ll_filas_estandar = 0 THEN
	messagebox("Aviso","No se encontro estandar para la O.C: "+string(an_oc))
	RETURN -1
END IF

ldc_estandar = lds_estandar_x_tipo.getitemdecimal(1,'estandar')

//tiempo por capa
adc_tiempo_x_capa = ldc_largo * ldc_estandar

//tiempo extendido
adc_tiempo_ext = adc_tiempo_x_capa * an_num_capas

RETURN 1
end function

public function boolean of_cambiar_estandar (ref decimal adc_estandar, decimal adc_capacidad_maquina, decimal adc_cantidad, long al_maquina, string as_referencia, string as_accion);/////////////////////////////////////////////////////////////////////////////////////////////////
////cambia el estandar por el nuevo estandar que se da el tiempo total por extendido de la O.C
/////////////////////////////////////////////////////////////////////////////////////////////////
//
//IF isnull(adc_estandar) THEN
//	RETURN TRUE
//END IF
//	
////si esta programando
////divide el estandar que ya esta calculado como tiempo total entre la cantidad total de la barra
////para asi determinar el estandar por unidad
//IF as_accion = 'Programar' THEN
//	
//	//controla que no vaya a ver division por cero
//	IF adc_cantidad > 0 THEN
//    adc_estandar = adc_estandar/adc_cantidad
//   ELSE
//	  RETURN TRUE
//   END IF
//	
//END IF	
////


long ll_minutos
ll_minutos = 720 
adc_estandar = ll_minutos/ adc_cantidad

If IsNull(adc_estandar) Then
	adc_estandar=0
		Messagebox("Advertencia","Estandar esta en cero")
	Return False
End If

RETURN TRUE
end function

public function boolean of_validar_reservar (decimal adc_cantidad, decimal adc_capacidad_min, decimal adc_capacidad_max, string as_tipo_pedido, decimal adc_capacidad_min_ant, decimal adc_capacidad_max_ant, long al_maquina, long al_maquina_ant);//valida que si no tiene unidades o el tipo pedido es P(significa que son O.C cero no se deben planear)
If adc_cantidad <= 0 OR trim(as_tipo_pedido) = 'P' Then
	Return false
Else
	Return True
End IF
end function

public function long of_sumar_tiempo_muerto (ref datetime adtm_fecha, s_parametros_barra astr_datos_barra_anterior, s_parametros_barra astr_datos_barra_actual);DateTime ldtm_fecha_fin_anterior, ldtm_fecha_inicio_actual, ldtm_fecha_fin_mas_minutos
String ls_co_referencia_anterior, ls_co_referencia_actual, ls_co_material_actual, ls_co_materia_anterior
String ls_co_talla_actual, ls_co_talla_anterior


If astr_datos_barra_actual.hay_parametros and astr_datos_barra_anterior.hay_parametros Then
	ldtm_fecha_inicio_actual = astr_datos_barra_actual.fecha_inicio
	ldtm_fecha_fin_anterior = astr_datos_barra_anterior.fecha_fin
	invo_utilidad.of_sumar_minutos( ldtm_fecha_fin_anterior, 3, ldtm_fecha_fin_mas_minutos)
	If ldtm_fecha_fin_mas_minutos > ldtm_fecha_inicio_actual Then
		adtm_fecha =  ldtm_fecha_fin_mas_minutos
	End If
End If

Return 1
end function

public function long of_estilo_barra (s_parametros_barra astr_barra, long ai_dias_atraso);Long ll_estilo_barra


//Choose Case Trim(as_tipo_pedido)
Choose Case Trim(astr_barra.cadena[3]) //Se evalua el tipo pedido
	Case '11' //mercadas		
			ll_estilo_barra = 14
		
	Case '2','1','3','4' //PROGRAMADAS
		//If ai_dias_atraso > 0 Then
		//	ll_estilo_barra = 8 //pinta la barra del color con el que se pintan las ordenes atrasadas
		//Else
			ll_estilo_barra = 1 
		//End If
	case '12' //en riel
		ll_estilo_barra = 9
	case '13' //en extendido
	//	ll_estilo_barra = 3
			ll_estilo_barra = 10
	//ll_estilo_barra = 13
		
	case '14','6','5'
		ll_estilo_barra=2
		
	//APROBACI$$HEX1$$d300$$ENDHEX$$N CALIDAD
	case '15'
		ll_estilo_barra = 23 //16
		
//	//E00368
//	//orden proyectada
	case '16'
		ll_estilo_barra = 22 	
		
	Case else
		//ll_estilo_barra=2
		ll_estilo_barra = 10
End Choose

Return  ll_estilo_barra


end function

on n_reglas_pdp_corte.create
call super::create
end on

on n_reglas_pdp_corte.destroy
call super::destroy
end on

