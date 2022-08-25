HA$PBExportHeader$n_utilidades_simulacion.sru
forward
global type n_utilidades_simulacion from nonvisualobject
end type
end forward

global type n_utilidades_simulacion from nonvisualobject autoinstantiate
end type

type variables
Long ii_capa = 1
Datastore ids_barras
uo_dsbase ids_datos_pedido
Datawindow idw_item
String is_separador = ', '
n_utilidades_calendario_new1 invo_fechas
Transaction itr_transaccion

String is_campo_fe_inicio_prog, is_campo_fe_fin_prog

NonVIsualObject invo_objeto_reglas
Boolean ib_hacer_commit = True
Boolean ib_mensaje_no_mover = True
end variables

forward prototypes
public function long of_set_barras (datastore ads_barras)
public function long of_set_pedidos (datawindow adw_item, uo_dsbase ads_datos_pedido)
public function long of_validar_mover (long al_pedido, string as_referencia)
public function long of_recalcular (s_parametros_calendario astr_parametros, long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, long ai_tipo_negocio, long ai_simulacion, date ad_fecha_inicio)
public function long of_cargar_reglas (long ai_tipo_negocio)
public function long of_calcular_continuidad (uo_dsbase ads_simulacion, long al_row, datetime adtm_inicio)
public function long of_recalcular_produccion (long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, long ai_tipo_negocio, long ai_simulacion)
public function long of_set_transaccion (ref transaction atr_transaccion)
public function s_parametros_barra of_datos_barra_anterior (datetime adtm_fecha, long al_maquina, uo_dsbase ads_ref_barras, long al_row)
public function s_parametros_barra of_datos_barra (datastore ads_ref_barras, long al_rowbarra)
public subroutine of_crear_barra_ordencorte (long al_orden_corte) throws exception
public function decimal of_calcular_estandar (long al_orden_corte, long al_referencia, long al_modulo) throws exception
public function long of_actualizar_barras_simulacion (long al_orden_corte) throws exception
public function decimal of_calcular_estandar (long al_orden_corte, long al_referencia, long al_modulo, long ai_raya) throws exception
public function boolean of_cambiar_estandar (ref decimal adc_estandar, long al_maquina, string as_referencia)
end prototypes

public function long of_set_barras (datastore ads_barras);// Se asigna el datastore
ids_barras = ads_barras
Return 1
end function

public function long of_set_pedidos (datawindow adw_item, uo_dsbase ads_datos_pedido);// Se asigna el datastore de los datos del pedido

idw_item = adw_item
ids_datos_pedido = ads_datos_pedido 
Return 1
end function

public function long of_validar_mover (long al_pedido, string as_referencia);Long ll_row
String ls_expresion
String ls_mensaje
Long li_retorno
ls_mensaje = 'El pedido N$$HEX1$$ba00$$ENDHEX$$' + String (al_pedido) 

ls_expresion = 'pedido = ' + String (al_pedido) + " AND co_referencia = '" + as_referencia + "'"
If IsValid (idw_item) Then
	ll_row = idw_item.Find( ls_expresion, 1 , idw_item.RowCount() + 1 )
	If ll_row > 0 Then
		ls_mensaje = 'La PO ' + Trim(idw_item.GetItemString(ll_row, 'nu_orden')) + ' con la ' &
			+ 'referencia ' + Trim(idw_item.GetItemString(ll_row, 'de_referencia'))
	End If
End If
If ll_row <= 0 And IsValid (ids_datos_pedido) Then
	ll_row = idw_item.Find( ls_expresion, 1 , idw_item.RowCount() + 1 )
	If ll_row > 0 Then
		ls_mensaje = 'La PO ' + Trim(ids_datos_pedido.GetItemString(ll_row, 'nu_orden')) + ' con la ' &
			+ 'referencia ' + Trim(ids_datos_pedido.GetItemString(ll_row, 'de_referencia'))
	End If
End If
ls_mensaje += '~r tiene marca de no mover, Desea Mover?'
li_retorno = MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', ls_mensaje, Question! , YesNo!)
If li_retorno = 1 Then
	return 1
Else
	Return -1
End If
end function

public function long of_recalcular (s_parametros_calendario astr_parametros, long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, long ai_tipo_negocio, long ai_simulacion, date ad_fecha_inicio);/* -------------------------------------------------------------------------------
	cuando se hace alguna modificaci$$HEX1$$f300$$ENDHEX$$n al calendario, la funci$$HEX1$$f300$$ENDHEX$$n recalcula toda el PDP,
	Carga los datos de dt_simulacion y tomando todas las fechas de inicio recalcula
	la fecha final, si la fecha final se sobrepone a otra fecha inicial, se corre la
	fecha inicial hasta la fecha final de la barra anterior y se recalcula. Si se
	------------------------------------------------------------------------------- */
	

Long ll_co_curva, ll_sw_curva, ll_maquina
Decimal ldc_estandar,ldc_cantidad
Boolean lb_recalculada_exitosa = True, lb_recalculada_modulo_exitosa = true, lb_conflicto, lb_mover
Long ll_row = 1, ll_filas
Long li_familia_anterior, li_continuidad_anterior, li_tipo_empate, li_dias_laborales, li_familia, li_dias_inicio_lab, &
			li_i = 1, li_continuidad
DateTime ldtm_inicio, ldtm_fin, ldtm_fin_nueva
Datetime ldtm_inicio_anterior, ldtm_fin_anterior, ldtm_inicio_costura, ldtm_inicio_original, ldtm_fin_original
String ls_referencia
Long ll_pedido
uo_dsbase lds_recalcular 
s_parametros_barra lstr_datos_barra_anterior,lstr_datos_barra_actual

If This.of_Cargar_Reglas( ai_tipo_negocio )	<= 0 Then Return -1
	

//Se declara el datastore para traer los datos de la simulaci$$HEX1$$f300$$ENDHEX$$n
lds_recalcular = create uo_dsbase
lds_recalcular.DataObject = 'd_gr_recalcular_simulacion'
lds_recalcular.SetTransObject(SQLCA)

//si existen parametros en la estructura
If astr_parametros.hay_parametros Then
	// se deja en blanco toda la informacion de las fechas
	invo_fechas.of_reiniciar_propiedades( )	
	// se llenan las propiedades
	invo_fechas.co_fabrica = ai_fabrica
	invo_fechas.co_planta = ai_planta
	invo_fechas.co_centro = ai_centro
	invo_fechas.co_subcentro = ai_subcentro
	invo_fechas.co_tipo_negocio = ai_tipo_negocio
	invo_fechas.simulacion = ai_simulacion	
	

	//recorre todos los m$$HEX1$$f300$$ENDHEX$$dulos a los que se les hizo un cambio en el calendario
	Do While li_i <= UpperBound(astr_parametros.Entero) And lb_recalculada_exitosa = True 
		
		//se obtiene el m$$HEX1$$f300$$ENDHEX$$dulo
		ll_maquina = astr_parametros.entero[li_i]
		
		
		// para que busque el tipo de modulo la primera vez
		SetNull(invo_fechas.co_tipo_maquina)
		invo_fechas.co_maquina = ll_maquina
		
		
		ldtm_fin_anterior = DateTime(RelativeDate(ad_fecha_inicio, -30 ) )
	
		//Se obtienen los datos del m$$HEX1$$f300$$ENDHEX$$dulo de la base de datos
		ll_filas = lds_recalcular.Retrieve(ai_fabrica, ai_planta, ai_centro, ai_subcentro, ai_tipo_negocio, ll_maquina, ai_simulacion, &
										ldtm_fin_anterior) 	
		if ll_filas < 0 Then
			ROLLBACK;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se pudieron cargar los datos para recalcular PDP')
			Destroy(lds_recalcular)
			Return -1	
		End IF
		// se organizan la barras por la fecha de programacion
		lds_recalcular.SetSort('fe_inicio_progs A')
		lds_recalcular.Sort()
		
		//inicializa los dias habiles entre la fecha de fin anterior real y la que se calcula
		li_dias_inicio_lab = 0
		
		ll_row = lds_recalcular.Find('fe_final_progs >= ' + String(ad_fecha_inicio, 'yyyy-mm-dd'), 1, lds_recalcular.RowCount() + 1)
		If ll_row = 0 Then	// no hay que realizar cambios
			ll_row = lds_recalcular.RowCount() + 1
		ElseIf ll_row = 1 Then	// es el primer registro que se trajo
			// se toma la fecha de inicio de la barra
			ldtm_fin = lds_recalcular.GetItemDateTime(ll_row,'fe_inicio_progs')
			// si es mayor que la fecha del dia de hoy se recalcula la fecha de inicio anterior
			If Date(ldtm_fin) > Today() Then
				// se lleva dos dias adelante de lo que se trajo de la BD
				ldtm_fin_anterior = DateTime(RelativeDate( Date(ldtm_fin_anterior), 2) )
				// si la fecha es menor que el dia de hoy se  pone la fecha de fin anterio el dia de hoy
				If Date(ldtm_fin_anterior) < Today()  Then
					ldtm_fin = DateTime(Today())	
				Else					
					ldtm_fin = ldtm_fin_anterior				
				End IF
			End If
			//inicializa las variables para el m$$HEX1$$f300$$ENDHEX$$dulo
			ldtm_fin_anterior = ldtm_fin
			li_familia_anterior = -1
			li_continuidad_anterior = 0			
		Else // No es el primer registro que se trajo
			ldtm_inicio = lds_recalcular.GetItemDateTime(ll_row,'fe_inicio_progs')	
			// se toman los datos de la barra anterior
			ldtm_inicio_anterior = lds_recalcular.GetItemDateTime(ll_row - 1,'fe_inicio_progs')
			ldtm_fin_anterior = lds_recalcular.GetItemDateTime(ll_row - 1,'fe_final_progs')
			li_familia_anterior = lds_recalcular.GetItemNumber(ll_row - 1, 'co_recurso')
			li_continuidad_anterior = lds_recalcular.GetItemNUmber(ll_row - 1,'dias_continuidad')	
			// si la fecha de fin anterior es menor que la actual se pone
			// como la fecha de la barra y se recalcula la continuidad
			If ldtm_fin_anterior < DateTime(Today()) Then
				// se calcula la continuidad en que termina la barra
				li_continuidad_anterior += invo_fechas.of_nodiaslaborales_x_modulo( Date(ldtm_inicio_anterior), Date(ldtm_fin_anterior)) - 1							

				// se calcula los dias laborales entre la fecha de fin anterior y la calculada
				li_dias_inicio_lab = invo_fechas.of_nodiaslaborales_x_modulo( Date(ldtm_fin_anterior), Date(ldtm_inicio))				
				If li_dias_inicio_lab > 2 Then li_continuidad_anterior = 0
				If li_dias_inicio_lab = 2 Then li_continuidad_anterior ++	
				
				If	li_dias_inicio_lab > 0 Then li_dias_inicio_lab --
				
				ldtm_fin_anterior = ldtm_inicio
			End IF
		End If 

		//recorre todas las barras del m$$HEX1$$f300$$ENDHEX$$dulo
		lb_recalculada_modulo_exitosa = True
		Do While ll_row <= lds_recalcular.RowCount() ANd lb_recalculada_modulo_exitosa = True
			
			//se toman los valores originales de las fechas
			ldtm_inicio_original = lds_recalcular.GetItemDateTime(ll_row,'fe_inicio_progs')
			ldtm_fin_original =  lds_recalcular.GetItemDateTime(ll_row,'fe_final_progs')
			// se valida si la barra se puede mover
			If lds_recalcular.GetItemNumber(ll_row,'sw_mover') = 1 Then
				lb_mover = False
			Else
				lb_mover = True
			End IF
			/*---------------SECCION PARA RECALCULAR LA NUEVA FECHA DE INICIO ---------------*/

			//si la barra actual esta en conflicto con la anterior			
			If ldtm_inicio_original <= ldtm_fin_anterior Then
				lb_conflicto = True
				//la barra actual cambia su fecha de inicio por la fecha fin de la que tiene conflicto, es decir, la barra anterior
				ldtm_inicio = ldtm_fin_anterior
			Else			
				lb_conflicto = False
				//Obtiene la fecha de inicio de costura, si la barra se puede mover para atras en el tiempo, lo hara solo hasta el inicio de costura					
				ldtm_inicio_costura = lds_recalcular.GetItemDateTime(ll_row,'fe_inicio_crono')				
				// Si no se puede mover se deja en el mismo sitio
				If Not lb_mover Then
					ldtm_inicio = ldtm_inicio_original
				ElseIf ldtm_fin_anterior >= ldtm_inicio_costura Then
					ldtm_inicio = ldtm_fin_anterior
				//si la fecha de inicio de costura es menor que la fecha fin programada
				ElseIf ldtm_inicio_costura < ldtm_inicio_original Then
					// toma la fecha de inicio de costura
					ldtm_inicio = ldtm_inicio_costura
				Else
					//toma la fecha inicio de la barra actual
					ldtm_inicio = ldtm_inicio_original
				End If
			End IF

			//se Obtiene el tipo de empate
			li_tipo_empate = lds_recalcular.GetItemNumber(ll_row, 'co_tipo_empate')			
			//se obtiene la familia
			li_familia = lds_recalcular.GetItemNumber(ll_row, 'co_recurso')		
			
			lstr_datos_barra_anterior = This.of_Datos_Barra_Anterior( ldtm_inicio, ll_maquina, lds_recalcular, ll_row )
		
			lstr_datos_barra_actual = This.Of_Datos_Barra( lds_recalcular, ll_row)
			
			lstr_datos_barra_actual.entero[1] = li_continuidad // continuidad
			
			// se toma la fecha de inicio y fin de la barra
			lstr_datos_barra_actual.fecha_inicio = ldtm_inicio
			lstr_datos_barra_actual.fecha_fin = ldtm_inicio	
			
			This.invo_objeto_reglas.Dynamic Of_Sumar_Tiempo_Muerto(ldtm_inicio,lstr_datos_barra_anterior,lstr_datos_barra_actual)

			/*-----------------------------------------------------------------------------------*/
			/*------------------------SECCION PARA CALCULAR EMPATE ----------------------- */
			Choose Case li_tipo_empate
					
				//si el tipo de empate es cero, es porque es un empate autom$$HEX1$$e100$$ENDHEX$$tico	
				Case 0					
					//Se calcula el n$$HEX1$$fa00$$ENDHEX$$mero de d$$HEX1$$ed00$$ENDHEX$$as h$$HEX1$$e100$$ENDHEX$$biles entre la barra anterior y la barra actual
					li_dias_laborales = invo_fechas.of_nodiaslaborales_x_modulo( Date(ldtm_fin_anterior), Date(ldtm_inicio))
					
					//si hay m$$HEX1$$e100$$ENDHEX$$s de un d$$HEX1$$ed00$$ENDHEX$$a laboral, se considera que no hay empate, li_dias_laborales = 2 quiere decir que hay un dia h$$HEX1$$e100$$ENDHEX$$bil entre los dos, 
					//li_dias_laborales = 1 quire decir que se encuetran en el mismo d$$HEX1$$ed00$$ENDHEX$$a
					If li_dias_laborales + li_dias_inicio_lab > 2 Then
						li_continuidad = 0
					Else						
						//si las barras son contiguas
						If li_dias_laborales + li_dias_inicio_lab = 2 And li_dias_inicio_lab <> 1 Then li_continuidad_anterior++
						
						//si pertenecen a la misma familia
						If li_familia_anterior = li_familia Then
							
							//la barra actual toma la continuidad con la que termin$$HEX2$$f3002000$$ENDHEX$$la barra anterior
							li_continuidad = li_continuidad_anterior							
						Else
							li_continuidad = 0
						ENd IF
					End IF
				Case -1
					//no hay continuidad
					li_continuidad = 0
				Case is > 0
					//en este caso la continuidad es la que el usuario le haya puesto  a la reserva
					li_continuidad = lds_recalcular.GetItemNUmber(ll_row,'dias_continuidad')		
			End Choose
			/*-----------------------------------------------------------------------------------*/
			li_dias_inicio_lab = 0
			li_familia_anterior = li_familia
			
			//se obtienen los datos para poder recalcular la barra
			ldc_estandar = lds_recalcular.GetItemDecimal(ll_row,'tiempo_estandar')
			ldc_cantidad = lds_recalcular.GetItemDecimal(ll_row,'ca_programada')
			ll_co_curva = lds_recalcular.GetItemNumber(ll_row, 'co_curva')
			ll_sw_curva = lds_recalcular.GetItemNumber(ll_row, 'sw_curva')
			
			// parametros de la curva
			invo_fechas.sw_curva = ll_sw_curva
			invo_fechas.co_curva = ll_co_curva
			
			invo_fechas.is_referencia = lds_recalcular.GetItemString(ll_row,'co_referencia')
			//se recalcula la barra
			invo_fechas.of_calcular_fecha( ldtm_inicio, ldtm_fin, 'I', ldc_estandar, ldc_cantidad, li_continuidad)				
			ldtm_fin_anterior = ldtm_fin

			// se toma la continuida con que termina
			li_continuidad_anterior = invo_fechas.dias_de_continuidad
			
			//se le coloca a la barra sus nuevos valores si son diferentes
			If ldtm_inicio_original <> ldtm_inicio Or ldtm_fin_original <> ldtm_fin Then
				lds_recalcular.SetItem(ll_row,'fe_inicio_progs',ldtm_inicio)
				lds_recalcular.SetItem(ll_row,'fe_final_progs',ldtm_fin)
				lds_recalcular.SetItem(ll_row,'dias_continuidad',li_continuidad)
				lds_recalcular.SetItem(ll_row,'min_trabajados',invo_fechas.minutos_totales )
				lds_recalcular.SetItem(ll_row,'minuto_laboral_ini',invo_fechas.minuto_laboral_ini )
				lds_recalcular.SetItem(ll_row,'minuto_laboral_fin',invo_fechas.minuto_laboral_fin )			
				//si la barra tiene el indicativo de no mover
				If lb_mover = False Then
					ls_referencia = lds_recalcular.GetItemString(ll_row,'de_referencia')
					ll_pedido = lds_recalcular.GetItemNumber(ll_row,'pedido')
					If ib_mensaje_no_mover Then
						//pregunta si desea moverla
						If messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","la reserva para la referencia "+Trim(ls_referencia)+"  del pedido n$$HEX1$$fa00$$ENDHEX$$mero "+String(ll_pedido)+" tiene el indicativo de no mover, $$HEX2$$bf002000$$ENDHEX$$desea moverla ?",Exclamation!,YesNo!) = 2 Then
												
							//si no desea mover, la recalculada del modulo no fue exitosa
							lb_recalculada_modulo_exitosa = false	
						End IF
					End if
				End IF

			End If			
			ll_row++
		Loop
		li_i++	
		If lb_recalculada_modulo_exitosa Then
			if lds_recalcular.of_update() <> 1 Then
				lb_recalculada_exitosa = False
			End IF
		End IF
		lb_recalculada_modulo_exitosa = True
	Loop
	
End IF
w_principal.SetMicrohelp('Ready')

If lb_recalculada_exitosa then
	If Not ib_hacer_commit Then
		Destroy(lds_recalcular)
		Return 1
	ElseIf lds_recalcular.of_commit() = 1 then
//		ROLLBACK;
		messagebox("Guardado", "El Plan detallado de producci$$HEX1$$f300$$ENDHEX$$n fue modificado con $$HEX1$$e900$$ENDHEX$$xito")
		Destroy(lds_recalcular)
		RETURN 1
	Else
		ROLLBACK;
		messagebox("error","No se pudieron guardar los datos")
		Destroy(lds_recalcular)
		RETURN -1
	End If
Else
	ROLLBACK;
	messagebox("error","No se pudieron guardar los datos")
	Destroy(lds_recalcular)
	RETURN -1
End If	

Destroy(lds_recalcular)
Return 1
	
	
end function

public function long of_cargar_reglas (long ai_tipo_negocio);Long li_retorno

//se declara el datastore
uo_dsbase lds_cargar_configuracion
lds_cargar_configuracion = Create uo_dsbase
lds_cargar_configuracion.DataObject = 'd_ff_config_pdp'
lds_cargar_configuracion.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

li_retorno = 1
//se hace trae la informaci$$HEX1$$f300$$ENDHEX$$n de la base de datos
If lds_cargar_configuracion.Of_retrieve(ai_tipo_negocio) < 1 Then
	ROLLBACK;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo configurar las reglas del negocio de PDP")
	li_retorno = -1	
Else	
	//se valida si el objeto de reglas es v$$HEX1$$e100$$ENDHEX$$lido  
	invo_objeto_reglas = Create Using lds_cargar_configuracion.GetItemString(1,'objeto_reglas')
	If IsValid(invo_objeto_reglas)	Then 
		If invo_objeto_reglas.Dynamic of_Set_Reglas(ai_tipo_negocio) < 0 Then
			li_retorno = -1
		End IF
	Else
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Objeto de reglas del negocio inv$$HEX1$$e100$$ENDHEX$$lido "+Trim(lds_cargar_configuracion.GetItemString(1,'objeto_reglas')))
		li_retorno = -1
	End If
End If

If li_retorno <=0  Then
	Destroy(invo_objeto_reglas)
	Destroy lds_cargar_configuracion
End If

Destroy lds_cargar_configuracion
Return li_retorno

end function

public function long of_calcular_continuidad (uo_dsbase ads_simulacion, long al_row, datetime adtm_inicio);Long li_empate, li_dias_continuidad, li_dias_laborales
DateTime ldtm_inicio_anterior, ldtm_fin_anterior
Long ll_maquina, ll_maquina_anterior, ll_recurso, ll_recurso_anterior, ll_row_anterior
String ls_msn_barra

If al_row <= 0 Then Return 0

li_empate = ads_simulacion.GetItemNumber(al_row, 'co_tipo_empate')
li_dias_continuidad = 0

ll_row_anterior = al_row - 1
Choose Case li_empate
	Case -1
		li_dias_continuidad = 0
	Case Is > 0
		li_dias_continuidad = ads_simulacion.GetItemNumber(al_row, 'co_tipo_empate')
	Case 0
		If al_row > 1 Then
			ll_maquina = ads_simulacion.GetItemNumber(al_row, 'co_maquina')
			ll_maquina_anterior = ads_simulacion.GetItemNumber(ll_row_anterior, 'co_maquina')
			ldtm_inicio_anterior = ads_simulacion.GetItemDateTime(ll_row_anterior, 'fe_inicio_progs')
			ldtm_fin_anterior = ads_simulacion.GetItemDateTime(ll_row_anterior, 'fe_final_progs')
			
			ll_recurso = ads_simulacion.GetItemNumber(al_row, 'co_recurso')
			ll_recurso_anterior = ads_simulacion.GetItemNumber(ll_row_anterior, 'co_recurso')			
			
			If ll_maquina = ll_maquina_anterior And ll_recurso = ll_recurso_anterior Then				
				invo_fechas.co_maquina = ll_maquina
				SetNull(invo_fechas.co_tipo_maquina)	
				
				ls_msn_barra = "la barra con el Pedido " + String(ads_simulacion.GetItemNumber(al_row,'pedido')) &
						+ ", PO " + Trim(ads_simulacion.GetItemString(al_row,'orden_compra')) + &
						+ ", Referencia " + Trim (ads_simulacion.GetItemString(al_row, 'de_referencia')) &
						+ ", Co Modulo " + String (ll_maquina)

				li_dias_laborales = invo_fechas.of_nodiaslaborales_x_modulo( Date(ldtm_fin_anterior), Date(adtm_inicio ))				
				// ocurrio un erro al calcular la continuidad
				If li_dias_laborales < 0 Then
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al calcular la continuidad (' + String(li_dias_laborales) +') para ' + ls_msn_barra )					
					Return -1
				End If
				
				
				If li_dias_laborales > 2 Then
					li_dias_continuidad = 0
				ElseIf li_dias_laborales >= 0 And li_dias_laborales <= 2 Then
					li_dias_continuidad = invo_fechas.of_nodiaslaborales_x_modulo( Date(ldtm_inicio_anterior),Date( ldtm_fin_anterior)) 
					
					// ocurrio un error al calcular la continuidad
					If li_dias_continuidad < 0 Then
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'Ocurrio un error al calcular la continuidad (' + String(li_dias_continuidad) +'). En ' + ls_msn_barra)					
						Return -1
					End If
					If li_dias_continuidad > 0 Then
						li_dias_continuidad --
					End If
					li_dias_continuidad += ads_simulacion.GetItemNumber(ll_row_anterior, 'dias_continuidad')	
					
					If li_dias_laborales = 2 Then
						li_dias_continuidad ++
					End IF
				End IF
			End If
		End IF
End Choose

Return li_dias_continuidad
end function

public function long of_recalcular_produccion (long ai_fabrica, long ai_planta, long ai_centro, long ai_subcentro, long ai_tipo_negocio, long ai_simulacion);
/* ------------------------------------------------------------------------------------------------------------------
Descripci$$HEX1$$f300$$ENDHEX$$n:  Funcion para recalcular las barras del PDP acorde a la produccion registrada
Se cargan las barras, luego se parte las barras con cantidad producida,
luego se recalcula el tama$$HEX1$$f100$$ENDHEX$$o de las barras sin producir
Argumentos							Tipo				Descripci$$HEX1$$f300$$ENDHEX$$n
  ai_fabrica						E					Fabrica del subcentro a recalcular
  ai_planta							E					Planta del subcentro a recalcular
  ai_centro							E					Centro del subcentro a recalcular
  ai_subcentro						E					Subcentro del subcentro a recalcular
  ai_simulacion					E					Simulacion a la cual se le va a actualizar las barras, 0 - Version Real
Retorno: Valor retornado por el Evento y/o Funci$$HEX1$$f300$$ENDHEX$$n
Llamado por : Librer$$HEX1$$ed00$$ENDHEX$$a -> Objeto -> Funci$$HEX1$$f300$$ENDHEX$$n y/o Evento
--------------------------------------------------------------------------------------------------------------------
Autor    : Frank Alexis Cano Largo			Fecha   : ??-??-2006
---------------------------------------------------------------------------------------------------------------------
Fecha                                  Usuario                                                                              
-------------------------------------------------------------------------------------------------------------------- */
Long ll_filas, ll_row, ll_row_mod, ll_cambios, ll_maquinas_cont, ll_familia, ll_familia_nueva, ll_curva_nueva
Long ll_pedido, ll_referencia, ll_maquina, ll_row_move, ll_row_pasado
Decimal ldc_ca_programada, ldc_ca_producida, ldc_ca_asignada, ldc_estandar, ldc_estandar_nuevo
DateTime ldtm_inicio, ldtm_fin, ldtm_inicio_real, ldtm_fin_real, ldtm_fin_anterior, &
			ldtm_inicio_original, ldtm_fin_original, ldtm_inicio_costura, ldtm_servidor, &
			ldtm_inicio_simulacion, ldtm_inicio_recalcular
Date ld_hoy
Time ltm_correr, ltm_hora
String ls_expresion, ls_expresion_mod ,ls_sentido, ls_msn_error, ls_msn_barra
Long li_secuencia, li_fabrica,li_linea, li_retorno, li_dias_de_continuidad, &
			ll_familia_anterior, li_dias_de_continuidad_anterior, li_tipo_empate, &
			li_dias_laborales
Boolean lb_conflicto, lb_mover
uo_dsbase lds_simulacion
s_parametros_barra lstr_datos_barra_anterior,lstr_datos_barra_actual

w_principal.SetMicroHelp('Cargando la informaci$$HEX1$$f300$$ENDHEX$$n del PDP')

SetPointer(HourGlass!)

ldtm_servidor = f_fecha_servidor()
If SQLCA.SqlCode <> 0 Then
	Return -1
End If
ld_hoy = Date(ldtm_servidor)
ldtm_inicio_simulacion = DateTime(RelativeDate(ld_hoy,-43))
ldtm_inicio_recalcular = DateTime(RelativeDate(ld_hoy,-13))
// se cargan los registros de la simulacion
lds_simulacion = Create uo_dsbase
lds_simulacion.DataObject = 'd_gr_simulacion_produccion'
lds_simulacion.SetTransObject(SQLCA)

ll_filas = lds_simulacion.Of_Retrieve(ai_fabrica, ai_planta, ai_centro, ai_subcentro, ai_tipo_negocio, ai_simulacion, ldtm_inicio_simulacion)

// se validan errores
Choose Case ll_filas 
	Case Is < 0
		ROLLBACK;
		MessageBox('Atencion', 'Ocurrio un error en la base de datos al traer los datos de la simulacion')	
		li_retorno = -1
	Case 0
		li_retorno = 0
	Case Else
		li_retorno = This.of_Cargar_Reglas( ai_tipo_negocio )	
End Choose

If li_retorno <=0  Then
	Destroy(lds_simulacion)
	Return li_retorno
End If

w_principal.SetMicroHelp('Partiendo Barras ...')

// Parametros generales del objeto de las fechas
invo_fechas.co_fabrica = ai_fabrica
invo_fechas.co_planta = ai_planta
invo_fechas.co_centro = ai_centro
invo_fechas.co_subcentro = ai_subcentro
invo_fechas.co_tipo_negocio = ai_tipo_negocio
invo_fechas.simulacion = ai_simulacion


/*------------------------------------------ SE PARTEN LAS BARRAS CON PRODUCCION PARCIAL ------------------------------*/
lds_simulacion.SetFilter('ca_producida > 0 and ca_producida < ca_programada')
lds_simulacion.Filter()
lds_simulacion.SetSort('co_maquina ASC, fe_inicio_progs')
lds_simulacion.Sort()
ll_maquina = -1

// se busca la primera barra con cantidad producida parcial

For ll_row = 1 To lds_simulacion.RowCount()
	If ll_maquina <> lds_simulacion.GetItemNumber (ll_row, 'co_maquina') Then
		ll_maquina = lds_simulacion.GetItemNumber (ll_row, 'co_maquina')
		invo_fechas.co_maquina = ll_maquina
		SetNull(invo_fechas.co_tipo_maquina)
	End If
	
	ldc_ca_programada = lds_simulacion.GetItemNumber (ll_row, 'ca_programada')
	ldc_ca_producida = lds_simulacion.GetItemNumber (ll_row, 'ca_producida')
	ldc_ca_asignada = lds_simulacion.GetItemNumber (ll_row, 'ca_asignada')
	ldc_estandar = lds_simulacion.GetItemNumber (ll_row, 'tiempo_estandar')
	//se Obtiene el tipo de empate
	li_tipo_empate = lds_simulacion.GetItemNumber(ll_row, 'co_tipo_empate')
	
	// se toman las fechas de programacion
	ldtm_inicio_original = lds_simulacion.GetItemDateTime(ll_row, 'fe_inicio_progs')
	ldtm_fin_original = lds_simulacion.GetItemDateTime(ll_row, 'fe_final_progs')	
	
	// se toman las fechas reales
	ldtm_inicio_real = lds_simulacion.GetItemDateTime(ll_row, 'fe_inicio_real')
	ldtm_fin_real = lds_simulacion.GetItemDateTime(ll_row, 'fe_final_real')
	
	ldtm_inicio = ldtm_inicio_original
	ldtm_fin = ldtm_fin_original
	
	invo_fechas.co_curva = lds_simulacion.GetItemNumber (ll_row, 'co_curva')
	invo_fechas.sw_curva = lds_simulacion.GetItemNumber (ll_row, 'sw_curva')
	
	li_dias_de_continuidad = lds_simulacion.GetItemNumber(ll_row, 'dias_continuidad')
	
	invo_fechas.is_referencia = lds_simulacion.GetItemString(ll_row, 'co_referencia')
	invo_fechas.of_calcular_unidades( ldtm_inicio, ldtm_fin, ldc_estandar, li_dias_de_continuidad)
	
	/*------------- SE CREA NUEVA BARRA DEL PASADO ----------------*/
	ll_row_pasado = ll_row
	ll_row ++

	// se copia el registro
	lds_simulacion.RowsCopy( ll_row_pasado, ll_row_pasado, Primary!, lds_simulacion,  ll_row, Primary!)		
	// se modifican las fechas de programacion
	lds_simulacion.SetItem(ll_row_pasado, 'fe_inicio_progs', ldtm_inicio)
	lds_simulacion.SetItem(ll_row_pasado, 'fe_final_progs', ldtm_fin)
	// se pone la cantidad programada la misma producida
	lds_simulacion.SetItem(ll_row_pasado, 'ca_programada', ldc_ca_producida)
	// se evalua que la cantidad asiganada sea mayor que la cantidad producida
	If ldc_ca_asignada >= ldc_ca_producida Then
		lds_simulacion.SetItem(ll_row_pasado, 'ca_asignada', ldc_ca_producida )
		ldc_ca_asignada -= ldc_ca_producida
	Else
		lds_simulacion.SetItem(ll_row_pasado, 'ca_asignada', ldc_ca_asignada )
		ldc_ca_asignada = 0
	End IF	
	lds_simulacion.SetItem( ll_row_pasado, 'minuto_laboral_ini', invo_fechas.minuto_laboral_ini )
	lds_simulacion.SetItem( ll_row_pasado, 'minuto_laboral_fin', invo_fechas.minuto_laboral_fin )
	lds_simulacion.SetItem( ll_row_pasado, 'min_trabajados', invo_fechas.minutos_totales )
	
	// se actualizan los campos en la barra desplazada
	lds_simulacion.SetItem( ll_row, 'ca_producida', 0)
	lds_simulacion.SetItem( ll_row, 'ca_programada', ldc_ca_programada - ldc_ca_producida)
	lds_simulacion.SetItem( ll_row, 'ca_asignada', ldc_ca_asignada )
	lds_simulacion.SetItem( ll_row, 'fe_creacion', ldtm_servidor )
	lds_simulacion.SetItem( ll_row, 'fe_actualizacion', ldtm_servidor )
	lds_simulacion.SetItem( ll_row, 'usuario', gstr_info_usuario.codigo_usuario )

	SetNull( ldtm_inicio_real)
	// se limpia las fechas reales
	lds_simulacion.SetItem(ll_row, 'fe_inicio_real', ldtm_inicio_real)
	lds_simulacion.SetItem(ll_row, 'fe_final_real', ldtm_inicio_real)
	
	// si es de tipo empate se acumula los dias de continuidad
	If li_tipo_empate = -1 Then
		// se cambia el tipo de empate para las referencias con la curva de eficiencia como automatica
		If lds_simulacion.GetItemNumber (ll_row, 'sw_curva') = 0 Then
			lds_simulacion.SetItem(ll_row, 'co_tipo_empate', 0)
		Else
			// se pone como empate manual para acumular los dias de continuidad
			lds_simulacion.SetItem(ll_row, 'co_tipo_empate', invo_fechas.dias_de_continuidad + 1)
		End If		
	End If
	lds_simulacion.SetItem( ll_row, 'dias_continuidad', invo_fechas.dias_de_continuidad )
	
	// se cambian las fechas de actualizacion
	lds_simulacion.SetItem( ll_row_pasado, 'fe_actualizacion', ldtm_servidor )
	lds_simulacion.SetItem( ll_row_pasado, 'usuario', gstr_info_usuario.codigo_usuario )
	/*-----------------------------------------------------------------------------------*/	
Next
/*---------------------------------------------------------------------------------------------*/

w_principal.SetMicroHelp('Desplazando las barras sin producci$$HEX1$$f300$$ENDHEX$$n hasta el dia de hoy ...')
/*------------- MOVER HACIA ADELANTE LAS BARRAS DE LO QUE NO SE HA PRODUCIDO -------------------*/
lds_simulacion.SetFilter('ca_programada > 0 And ca_producida = 0')
lds_simulacion.Filter()
lds_simulacion.SetSort('co_maquina ASC, fe_inicio_progs')
lds_simulacion.Sort()

ld_hoy = Date(ldtm_servidor)
ldtm_inicio = DateTime( ld_hoy )

ll_maquina = -1
// se inicia la variable para correr
ls_expresion = 'fe_inicio_progs <= ' + String( ldtm_inicio, 'yyyy-mm-dd hh:mm:ss')
ll_row_move = lds_simulacion.Find(ls_expresion, 1, lds_simulacion.RowCount() + 1)
Do While	ll_row_move > 0
	If ll_maquina <> lds_simulacion.GetItemNumber (ll_row_move, 'co_maquina') Then
		ll_maquina = lds_simulacion.GetItemNumber (ll_row_move, 'co_maquina') 
		ltm_correr  = 00:00:00
	End If
	ltm_correr = RelativeTime( ltm_correr, 1 )
	ldtm_inicio = DateTime( ld_hoy, ltm_correr )
	lds_simulacion.SetItem (ll_row_move, 'fe_inicio_progs', ldtm_inicio)			
	ll_row_move = lds_simulacion.Find(ls_expresion, ll_row_move + 1, lds_simulacion.RowCount() + 1)
Loop
/*-----------------------------------------------------------------------------------------*/

w_principal.SetMicroHelp('Organizando las barras con produccion ...')
/*------ SE INTERCAMBIAN LAS FECHAS REALES EN CASO DE TENER EL INICIO POSTERIOR AL FIN REAL ---------*/
lds_simulacion.SetFilter('fe_inicio_real > fe_final_real')
lds_simulacion.Filter()
For ll_row = 1 To lds_simulacion.Rowcount()
	ldtm_inicio_real = lds_simulacion.GetItemDateTime(ll_row, 'fe_inicio_real')
	ldtm_fin_real = lds_simulacion.GetItemDateTime(ll_row, 'fe_final_real')	
	lds_simulacion.SetItem(ll_row, 'fe_inicio_real', ldtm_fin_real)
	lds_simulacion.SetItem(ll_row, 'fe_final_real', ldtm_inicio_real)
Next
/*--------------------------------------------------------------------------------*/


ldtm_servidor = f_fecha_servidor()
/*------------- SE ORGANIZAN LAS BARRAS DE LAS MAQUINA CON PRODUCCION IGUAL A LA BARRA --------------------*/
lds_simulacion.SetFilter('ca_producida > 0 OR ca_programada = 0')
lds_simulacion.Filter()
lds_simulacion.SetSort('co_maquina ASC, IsNull(fe_inicio_real), fe_inicio_real')
lds_simulacion.Sort()
ll_maquina = -1
For ll_row = 1 To lds_simulacion.Rowcount()
	// se toman las fechas de programacion
	ldtm_inicio_original = lds_simulacion.GetItemDateTime(ll_row, 'fe_inicio_progs')
	ldtm_fin_original = lds_simulacion.GetItemDateTime(ll_row, 'fe_final_progs')	
	// se verifica que la barra empiece desde la fecha que se van a recalcular las barras
	If ldtm_inicio_original < ldtm_inicio_recalcular Then
		Continue
	End If

	If ll_maquina <> lds_simulacion.GetItemNumber(ll_row, 'co_maquina') Then
		ll_maquina = lds_simulacion.GetItemNumber (ll_row, 'co_maquina')		
		ldtm_fin = DateTime(0)
		// se toma la primera fecha de inicio real, y se parte desde la primera hora del dia
		ldtm_fin_anterior = lds_simulacion.GetItemDateTime(ll_row, 'fe_inicio_real')
		ldtm_fin_anterior = DateTime( Date(ldtm_fin_anterior ) )
		
		// para que busque el tipo de maquina
		SetNull(invo_fechas.co_tipo_maquina)	
		invo_fechas.co_maquina = ll_maquina		
	End If
	// se toman las fechas reales
	ldtm_inicio_real = lds_simulacion.GetItemDateTime(ll_row, 'fe_inicio_real')
	ldtm_fin_real = lds_simulacion.GetItemDateTime(ll_row, 'fe_final_real')
	
	// se toma la nueva fecha de inicio
	If Date(ldtm_fin_anterior) >= Date(ldtm_inicio_real) Or IsNull(ldtm_inicio_real) Then
		ldtm_inicio = ldtm_fin_anterior
	Else
		ldtm_inicio = DateTime( Date(ldtm_inicio_real ) )
	End If		
	// si la fecha fin real es mayor que la de inicio se deja la fin real
	If ldtm_inicio < ldtm_fin_real Then
		ldtm_fin = ldtm_fin_real
	Else
		ltm_hora = Time(ldtm_inicio)
		If ltm_hora < 21:00:00 Then
		// se desplaza la fecha fin 3 horas y media hacia adelante de la fecha de inicio
			ltm_hora = RelativeTime(ltm_hora, 3.5*60*60 )
		Else
		// se desplaza la fecha fin 2 horas hacia adelante de la fecha de inicio
			ltm_hora = RelativeTime(ltm_hora, 2*60*60 )
		End If		
		ldtm_fin = DateTime(Date(ldtm_inicio),ltm_hora)
	End If
	
	// se calcula los dias de continuidad
	li_dias_de_continuidad = of_calcular_continuidad(lds_simulacion, ll_row, ldtm_inicio)
	
	If li_dias_de_continuidad < 0 Then
		li_retorno = -2
		Exit
	End IF
		
		
	// se toma la cantidad producida
	ldc_ca_producida = lds_simulacion.GetItemNumber (ll_row, 'ca_producida')
				
	invo_fechas.co_curva = lds_simulacion.GetItemNumber (ll_row, 'co_curva')
	invo_fechas.sw_curva = lds_simulacion.GetItemNumber (ll_row, 'sw_curva')
							
	li_dias_de_continuidad_anterior = lds_simulacion.GetItemNumber(ll_row, 'dias_continuidad')
	// se asignan las nuevas fechas y la nueva continuidad
	If ldtm_inicio_original <> ldtm_inicio Or ldtm_fin_original <> ldtm_fin Or li_dias_de_continuidad <> li_dias_de_continuidad_anterior Then
		lds_simulacion.SetItem(ll_row, 'fe_inicio_progs', ldtm_inicio)
		lds_simulacion.SetItem(ll_row, 'fe_final_progs', ldtm_fin)
		lds_simulacion.SetItem(ll_row, 'dias_continuidad', li_dias_de_continuidad)
		lds_simulacion.SetItem( ll_row, 'fe_actualizacion', ldtm_servidor )
		lds_simulacion.SetItem( ll_row, 'usuario', gstr_info_usuario.codigo_usuario )		
	End If
	ldtm_fin_anterior = ldtm_fin
Next
/*------------------------------------------------------------------------------------------------*/

If li_retorno <=0  Then
	Destroy(lds_simulacion)	
	Return li_retorno
End If

/*--------------------ACTUALICACION DE FAMILIAS Y CURVAS --------------------------------*/
w_principal.SetMicroHelp('Actualizando Familias, Curvas ...')
lds_simulacion.SetFilter('(co_familia <> co_recurso) AND (co_familia > 0)')
lds_simulacion.Filter()
For ll_row = 1 To lds_simulacion.Rowcount()
	ll_familia_nueva = lds_simulacion.GetItemNumber(ll_row, 'co_familia')
	lds_simulacion.SetItem(ll_row, 'co_recurso', ll_familia_nueva)
Next

lds_simulacion.SetFilter('(co_curva <> co_curva_nueva)')
lds_simulacion.Filter()
For ll_row = 1 To lds_simulacion.Rowcount()
	ll_curva_nueva = lds_simulacion.GetItemNumber(ll_row, 'co_curva_nueva')
	ll_familia_nueva = lds_simulacion.GetItemNumber(ll_row, 'co_familia')
	If ll_curva_nueva = 0 Or IsNull(ll_curva_nueva) Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No existe la curva para:' + &
									'Fabrica~tPlanta~tFamilia' + &
									String(ai_fabrica) + '~t' + String(ai_planta) + '~t' + String(ll_familia_nueva) &
									)
	Else
		lds_simulacion.SetItem(ll_row, 'co_curva', ll_curva_nueva)	
	End If	
Next
/*-------------------------------------------------------------------------------------------*/

/*------------- ORGANIZAR LAS BARRAS PROGRAMADAS SIN PRODUCCION ----------------*/
w_principal.SetMicroHelp('Recalculando las barras programadas del PDP ...')
ll_maquinas_cont = 1
ldtm_servidor = f_fecha_servidor()
// se reorganiza las barras
lds_simulacion.SetFilter('')
lds_simulacion.Filter()
lds_simulacion.SetSort('co_maquina D, fe_inicio_progs')
lds_simulacion.Sort()

// se busca la primera barra sin cantidad producida
ls_expresion = 'ca_producida = 0 AND ca_programada > 0 And fe_inicio_progs >' + String( ld_hoy, 'yyyy-mm-dd hh:mm:ss')
ll_row = lds_simulacion.Find(ls_expresion, 1, lds_simulacion.Rowcount() + 1)	

Do While	ll_row > 0	
	
	// incializacion de variables para correr las barras
	lb_conflicto = False
	ldtm_fin_anterior = DateTime(ld_hoy)
	ll_maquina = lds_simulacion.GetItemNumber (ll_row, 'co_maquina')	
	
	
	ls_msn_barra = "la barra con el Pedido " + String(lds_simulacion.GetItemNumber(ll_row,'pedido')) &
			+ ", PO " + Trim(lds_simulacion.GetItemString(ll_row,'orden_compra')) + &
			+ ", Referencia " + Trim (lds_simulacion.GetItemString(ll_row, 'de_referencia')) &
			+ ", Co Modulo " + String (ll_maquina)
	
	If ll_row > 1 Then		
		li_dias_de_continuidad_anterior = This.of_Calcular_Continuidad(lds_simulacion, ll_row, ldtm_fin_anterior)
		If li_dias_de_continuidad_anterior < 0 Then
			li_retorno = -2
			ls_msn_error = 'Error calculando continuidad en ' + ls_msn_barra
			Exit
		End If
		ll_familia_anterior = lds_simulacion.GetItemNumber(ll_row, 'co_recurso')
	Else
		ll_familia_anterior = -1
		li_dias_de_continuidad_anterior = 0
	End If	
	
	// para que busque el tipo de maquina
	SetNull(invo_fechas.co_tipo_maquina)	
	invo_fechas.co_maquina = ll_maquina
	If lds_simulacion.GetItemDateTime(ll_row,'fe_inicio_progs') = DateTime(ld_hoy) Then
		ll_row_mod = 0
	Else	
		ls_expresion_mod = 'co_maquina = ' + String(ll_maquina)
		ll_row_mod = lds_simulacion.Find( ls_expresion_mod, ll_row, lds_simulacion.Rowcount() + 1)
	End If
	
	Do While ll_row_mod > 0 And li_retorno >= 0		
		ls_msn_barra = "la barra con el Pedido " + String(lds_simulacion.GetItemNumber(ll_row_mod,'pedido')) &
			+ ", PO " + Trim(lds_simulacion.GetItemString(ll_row_mod,'orden_compra')) + &
			+ ", Referencia " + Trim (lds_simulacion.GetItemString(ll_row_mod, 'de_referencia')) &
			+ ", Co Modulo " + String (ll_maquina)
		
		//se toman los valores originales de las fechas
		ldtm_inicio_original = lds_simulacion.GetItemDateTime(ll_row_mod,'fe_inicio_progs')
		ldtm_fin_original =  lds_simulacion.GetItemDateTime(ll_row_mod,'fe_final_progs')
		If lds_simulacion.GetItemNumber(ll_row_mod,'sw_mover') = 1 Then
			lb_mover = False
		Else
			lb_mover = True	
		End IF
		//se obtiene la familia
		ll_familia = lds_simulacion.GetItemNumber(ll_row_mod, 'co_recurso')		
		
		//se Obtiene el tipo de empate
		li_tipo_empate = lds_simulacion.GetItemNumber(ll_row_mod, 'co_tipo_empate')

		/*---------------SECCION PARA RECALCULAR LA NUEVA FECHA DE INICIO ---------------*/
		//si la barra actual esta en conflicto con la anterior
		If ldtm_inicio_original <= ldtm_fin_anterior Then
			lb_conflicto = True
			//la barra actual cambia su fecha de inicio por la fecha fin de la que tiene conflicto, es decir, la barra anterior
			ldtm_inicio = ldtm_fin_anterior
		Else			
			lb_conflicto = False
			//Obtiene la fecha de inicio de costura, si la barra se puede mover para atras en el tiempo, lo hara solo hasta el inicio de costura					
			ldtm_inicio_costura = lds_simulacion.GetItemDateTime(ll_row_mod,'fe_inicio_crono')
			// Si no se puede mover se deja en el mismo sitio
			If Not lb_mover Then
				ldtm_inicio = ldtm_inicio_original
			ElseIf ldtm_fin_anterior >= ldtm_inicio_costura Then
				ldtm_inicio = ldtm_fin_anterior
			//si la fecha de inicio de costura es menor que la fecha fin programada
			ElseIf ldtm_inicio_costura < ldtm_inicio_original Then
				// toma la fecha de inicio de costura
				ldtm_inicio = ldtm_inicio_costura
			Else
				//toma la fecha inicio de la barra actual
				ldtm_inicio = ldtm_inicio_original
			End If
		End IF
		
		lstr_datos_barra_anterior = This.of_Datos_Barra_Anterior( ldtm_inicio, ll_maquina, lds_simulacion, ll_row_mod )
		
		lstr_datos_barra_actual = This.Of_Datos_Barra( lds_simulacion, ll_row_mod)
		
		lstr_datos_barra_actual.entero[1] = li_dias_de_continuidad // continuidad
		
		// se toma la fecha de inicio y fin de la barra
		lstr_datos_barra_actual.fecha_inicio = ldtm_inicio
		lstr_datos_barra_actual.fecha_fin = ldtm_fin_anterior	
		
		This.invo_objeto_reglas.Dynamic Of_Sumar_Tiempo_Muerto(ldtm_inicio ,lstr_datos_barra_anterior,lstr_datos_barra_actual)
		
		/*-----------------------------------------------------------------------------------*/
		/*------------------------SECCION PARA CALCULAR EMPATE ----------------------- */
		Choose Case li_tipo_empate
			//si el tipo de empate es cero, es porque es un empate autom$$HEX1$$e100$$ENDHEX$$tico	
			Case 0
				//Se calcula el n$$HEX1$$fa00$$ENDHEX$$mero de d$$HEX1$$ed00$$ENDHEX$$as h$$HEX1$$e100$$ENDHEX$$biles entre la barra anterior y la barra actual
				li_dias_laborales = invo_fechas.of_NodiasLaborales_x_modulo( Date(ldtm_fin_anterior), Date(ldtm_inicio))
				//si hay m$$HEX1$$e100$$ENDHEX$$s de un d$$HEX1$$ed00$$ENDHEX$$a laboral, se considera que no hay empate, li_dias_laborales = 2 quiere decir que hay un dia h$$HEX1$$e100$$ENDHEX$$bil entre los dos, 
				//li_dias_laborales = 1 quire decir que se encuetran en el mismo d$$HEX1$$ed00$$ENDHEX$$a
				If li_dias_laborales > 2 Then
					li_dias_de_continuidad = 0
				Else
					//si las barras son contiguas
					If li_dias_laborales = 2 Then li_dias_de_continuidad_anterior++
					//si pertenecen a la misma familia
					If ll_familia_anterior = ll_familia Then
						//la barra actual toma la continuidad con la que termin$$HEX2$$f3002000$$ENDHEX$$la barra anterior
						li_dias_de_continuidad = li_dias_de_continuidad_anterior							
					Else
						li_dias_de_continuidad = 0
					ENd IF
				End IF
			Case -1
				//no hay continuidad
				li_dias_de_continuidad = 0
			Case is > 0
				//en este caso la continuidad es la que el usuario le haya puesto  a la reserva
				li_dias_de_continuidad = lds_simulacion.GetItemNUmber(ll_row_mod,'dias_continuidad')		
		End Choose
		/*-----------------------------------------------------------------------------------*/
		
		ll_familia_anterior = ll_familia
		
		//se obtienen los datos para poder recalcular la barra
		ldc_estandar = lds_simulacion.GetItemDecimal(ll_row_mod,'tiempo_estandar')
		
		ldc_estandar_nuevo = lds_simulacion.GetItemDecimal(ll_row_mod,'tiempo_st')
		// se actualiza el nuevo estandar de las referencias no genericas
		If ldc_estandar_nuevo <> ldc_estandar And ldc_estandar_nuevo> 0 Then
			ldc_estandar = ldc_estandar_nuevo
			lds_simulacion.SetItem(ll_row_mod,'tiempo_estandar', ldc_estandar)			
		End If
		
		ldc_ca_programada = lds_simulacion.GetItemDecimal(ll_row_mod,'ca_programada')
	
		// parametros de la curva
		invo_fechas.sw_curva = lds_simulacion.GetItemNumber(ll_row_mod, 'sw_curva')
		invo_fechas.co_curva = lds_simulacion.GetItemNumber(ll_row_mod, 'co_curva')
		
		invo_fechas.is_referencia = lds_simulacion.GetItemString(ll_row_mod,'co_referencia')
			
		//se recalcula la barra
		If invo_fechas.of_Calcular_Fecha( ldtm_inicio, ldtm_fin, 'I', ldc_estandar, ldc_ca_programada, li_dias_de_continuidad) >= 0 Then			
			ldtm_fin_anterior = ldtm_fin	
			// se toma la continuida con que termina
			li_dias_de_continuidad_anterior = invo_fechas.dias_de_continuidad
		
			//se le coloca a la barra su nuevo valor
			If ldtm_inicio_original <> ldtm_inicio Or ldtm_fin_original <> ldtm_fin  Then
				lds_simulacion.SetItem( ll_row_mod,'fe_inicio_progs',ldtm_inicio)
				lds_simulacion.SetItem( ll_row_mod,'fe_final_progs',ldtm_fin)		
				lds_simulacion.SetItem( ll_row_mod, 'minuto_laboral_ini', invo_fechas.minuto_laboral_ini )
				lds_simulacion.SetItem( ll_row_mod, 'minuto_laboral_fin', invo_fechas.minuto_laboral_fin )
				lds_simulacion.SetItem( ll_row_mod, 'min_trabajados', invo_fechas.minutos_totales )			
				lds_simulacion.SetItem( ll_row_mod, 'dias_continuidad', li_dias_de_continuidad)
				lds_simulacion.SetItem( ll_row_mod, 'fe_actualizacion', ldtm_servidor )
				lds_simulacion.SetItem( ll_row_mod, 'usuario', gstr_info_usuario.codigo_usuario )				
			End If
			//si la barra tiene el indicativo de no mover
			If lb_mover = False Then			
				//evalua si la barra se movio
				IF ldtm_fin <> ldtm_fin_original Or ldtm_inicio <> ldtm_inicio_original Then									
					//se avisa que la barra fue movida					
					Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", ls_msn_barra + '. Tiene el indicativo de no mover y se ha movido',Exclamation!)										
				End IF
			End IF
		Else
			li_retorno = -3
			ls_msn_error = "Ocurrio un error al recalcular " + ls_msn_barra
			ll_row_mod = lds_simulacion.Rowcount() + 1			
		End If
		// Se busca la siguiente barra que esta en ese modulo
		ls_expresion_mod = 'co_maquina = ' + String(ll_maquina)
		ll_row_mod = lds_simulacion.Find( ls_expresion_mod, ll_row_mod + 1, lds_simulacion.Rowcount() + 1)
	Loop
	
	If li_retorno < 0 Then Exit
	
	// se busca la siquiente maquina con barras sin produccion
	ls_expresion = 'ca_producida = 0 AND co_maquina <> ' + String(ll_maquina) + &
						' AND fe_inicio_progs >' + String( ld_hoy, 'yyyy-mm-dd hh:mm:ss')
	ll_row = lds_simulacion.Find(ls_expresion, ll_row + 1, lds_simulacion.Rowcount() + 1)
	
	w_principal.SetMicroHelp('Recalculando las barras programadas del PDP - ' + String(ll_maquinas_cont) + ' M$$HEX1$$f300$$ENDHEX$$dulos recalculados  ...')
	ll_maquinas_cont ++
Loop

w_principal.SetMicroHelp('Guardando ...')

If li_retorno >= 0 Then
	If lds_simulacion.Of_Update() = 1 Then
		
		///////prueba///////
//		MessageBOx("Mire pues","Ome")
//		Rollback;
//		return -1
		///////////////
		
		If lds_simulacion.Of_Commit() = 1 Then
			w_principal.SetMicroHelp('Exito!')
			MessageBox('Exito', 'La actualizaci$$HEX1$$f300$$ENDHEX$$n de produccion fue exitosa')			
			li_retorno = 1
		Else
			ROLLBACK;
			w_principal.SetMicroHelp('Error, Fallo el Commit')
			MessageBox('Error', 'Ocurrio un error al actualizar la produccion, Fallo el Commit')			
			li_retorno = -3
		End If
	Else
		ROLLBACK;
		w_principal.SetMicroHelp('Error, Fallo el Update')
		MessageBox('Error', 'Ocurrio un error al actualizar la produccion, Fallo el Update')
		li_retorno = -4
	End If
Else
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'No se pudieron guardar los datos. ' + ls_msn_error)
End If

Destroy(lds_simulacion)

w_principal.SetMicroHelp('')
Return li_retorno
end function

public function long of_set_transaccion (ref transaction atr_transaccion);// Se asigna el objeto de transaccion para trabajar
itr_transaccion = atr_transaccion
// se asigna la lectura al objeto de fechas
invo_fechas.of_set_transaccion( itr_transaccion )
Return 1
end function

public function s_parametros_barra of_datos_barra_anterior (datetime adtm_fecha, long al_maquina, uo_dsbase ads_ref_barras, long al_row);String ls_expresion
Long ll_row
s_parametros_barra lstr_parametros

datastore lds_barras
lds_barras = Create uo_dsbase
lds_barras.DataObject = ads_ref_barras.DataObject

ads_ref_barras.RowsCopy(1,ads_ref_barras.RowCount(),Primary!,lds_barras,1,Primary!)
If al_row = 0 Then
	lds_barras.SetSort('co_maquina, fe_inicio_progs')
	lds_barras.Sort()
	ls_expresion = "co_maquina = "+String(al_maquina)+" and fe_inicio_progs < "+string(adtm_fecha,"yyyy-mm-dd hh:mm:ss")
	ll_row = lds_barras.Find(ls_expresion,1,lds_barras.RowCount() + 1 )
	string cadena,cadena2
	If ll_row > 0 Then 
		cadena =lds_barras.GetItemString(ll_row,'de_referencia')
		cadena2 =lds_barras.GetItemString(ll_row - 1,'de_referencia')
	else
		cadena = 'no hay anterior'
	End IF
Else
	ll_row = al_row - 1
	If ll_row > 0 Then
		If lds_barras.GetItemNumber(ll_row,'co_maquina') <> al_maquina Then
			ll_row = 0
		End If
	End If
End IF
If ll_row > 0 Then
	lstr_parametros = Of_Datos_Barra( lds_barras, ll_row)
	/*
	lstr_parametros.hay_parametros = True
	
	//se obtienen los datos de la barra actual para la regla del negocio qu valida el tiempo muerto
	lstr_parametros.entero[1] = lds_barras.GetItemNumber(ll_row,'dias_continuidad') // continuidad
	lstr_parametros.entero[2] = lds_barras.GetItemNumber(ll_row,'sw_mover')//sw_mover
	lstr_parametros.entero[3] = lds_barras.GetItemNumber(ll_row,'co_curva') //co_curva
	lstr_parametros.entero[4] = lds_barras.GetItemNumber(ll_row,'sw_curva') //sw_curva	
	lstr_parametros.entero[5] = lds_barras.GetItemNumber(ll_row,'secuencia') //secuencia	
	lstr_parametros.entero[6] = lds_barras.GetItemNumber(ll_row,'co_tipo_empate')//empate		
	lstr_parametros.entero[7] = lds_barras.GetItemNumber(ll_row,'co_recurso')//co_recurso
	lstr_parametros.entero[10] = ll_row//fila en ds	
	lstr_parametros.entero[11] = lds_barras.GetItemNumber(ll_row,'co_maquina')
	lstr_parametros.Cadena[1] = '' 
	lstr_parametros.Cadena[3] = ''
	lstr_parametros.Cadena[4] = lds_barras.GetItemString(ll_row,'sentido_prog')
	// bandera para saber el origen del pedido
	lstr_parametros.Cadena[5] = ''
	lstr_parametros.Cadena[6] = lds_barras.GetItemString(ll_row,'co_referencia') // codigo de la referencia ( SKU en confeccion)
	lstr_parametros.Cadena[7] = lds_barras.GetItemString(ll_row,'de_referencia')
	// se toma la fecha de inicio y fin de la barra
	lstr_parametros.fechahora[1] = lds_barras.GetItemDateTime(ll_row,'fe_inicio_progs')
	lstr_parametros.fechahora[2] = lds_barras.GetItemDateTime(ll_row,'fe_final_progs')	
	// se toma la fecha de inicio y fin de programacion	
	lstr_parametros.fechahora[3] = lds_barras.GetItemDateTime(ll_row,'fe_inicio_crono')
	lstr_parametros.fechahora[4] = lds_barras.GetItemDateTime(ll_row,'fe_final_crono')
	*/
Else
	lstr_parametros.hay_parametros = False
End IF
Destroy(lds_barras)
Return lstr_parametros
end function

public function s_parametros_barra of_datos_barra (datastore ads_ref_barras, long al_rowbarra);s_parametros_barra lstr_parametros_barra



If al_rowbarra > ads_ref_barras.RowCount() Then
	lstr_parametros_barra.hay_parametros = False
Else
	lstr_parametros_barra.hay_parametros = True
	//se obtienen los datos de la barra actual para la regla del negocio qu valida el tiempo muerto
	lstr_parametros_barra.entero[1] = ads_ref_barras.GetItemNumber(al_rowbarra,'dias_continuidad')
	lstr_parametros_barra.entero[2] = ads_ref_barras.GetItemNumber(al_rowbarra,'sw_mover')
	lstr_parametros_barra.entero[3] = ads_ref_barras.GetItemNumber(al_rowbarra,'co_curva')
	lstr_parametros_barra.entero[4] = ads_ref_barras.GetItemNumber(al_rowbarra,'sw_curva')
	lstr_parametros_barra.entero[5] = ads_ref_barras.GetItemNumber(al_rowbarra,'secuencia')
	lstr_parametros_barra.entero[6] = ads_ref_barras.GetItemNumber(al_rowbarra,'co_tipo_empate')
	lstr_parametros_barra.entero[7] = ads_ref_barras.GetItemNumber(al_rowbarra,'co_recurso')
	lstr_parametros_barra.entero[8] = ads_ref_barras.GetItemNumber(al_rowbarra,'minuto_laboral_ini')
	lstr_parametros_barra.entero[9] = ads_ref_barras.GetItemNumber(al_rowbarra,'minuto_laboral_fin')
	lstr_parametros_barra.entero[10] = al_rowbarra
	
	lstr_parametros_barra.entero[16] = ads_ref_barras.GetItemNumber(al_rowbarra,'prioridad')

	
	lstr_parametros_barra.Cadena[1] = '' 
	lstr_parametros_barra.Cadena[3] = ''
	
	lstr_parametros_barra.cadena[4] = ads_ref_barras.GetItemString(al_rowbarra,'sentido_prog')
	lstr_parametros_barra.cadena[5] = '' //'ds_planeador' bandera para saber el origen del pedido
	lstr_parametros_barra.cadena[6] = ads_ref_barras.GetItemString(al_rowbarra,'co_referencia')
	lstr_parametros_barra.cadena[7] = ads_ref_barras.GetItemString(al_rowbarra,'de_referencia')		
	lstr_parametros_barra.Decimal[1] = ads_ref_barras.GetItemDecimal(al_rowbarra,'ca_programada')
	lstr_parametros_barra.Decimal[2] = ads_ref_barras.GetItemNumber(al_rowbarra,'tiempo_estandar')
	lstr_parametros_barra.Decimal[3] = ads_ref_barras.GetItemNumber(al_rowbarra,'min_trabajados')
	// cantidad asignada
	lstr_parametros_barra.Decimal[5] = ads_ref_barras.GetItemNumber(al_rowbarra,'ca_asignada')
	lstr_parametros_barra.Decimal[7] = ads_ref_barras.GetItemNumber(al_rowbarra,'ca_programada_2')
	lstr_parametros_barra.Decimal[8] = ads_ref_barras.GetItemNumber(al_rowbarra,'ca_producida_2')
	// se toma la fecha de inicio y fin de programacion	
	lstr_parametros_barra.fechahora[1] = ads_ref_barras.GetItemDateTime(al_rowbarra,'fe_inicio_crono')
	lstr_parametros_barra.fechahora[2] = ads_ref_barras.GetItemDateTime(al_rowbarra,'fe_final_crono')

	// se toma la fecha de inicio y fin de la barra
	lstr_parametros_barra.fecha_inicio = ads_ref_barras.GetItemDateTime(al_rowbarra,'fe_inicio_progs')
	lstr_parametros_barra.fecha_fin = ads_ref_barras.GetItemDateTime(al_rowbarra,'fe_final_progs')
	
	lstr_parametros_barra.rgb = ads_ref_barras.GetItemNumber(al_rowbarra,'rgb')
	lstr_parametros_barra.co_maquina = ads_ref_barras.GetItemNumber(al_rowbarra,'co_maquina')
End If

Return lstr_parametros_barra
end function

public subroutine of_crear_barra_ordencorte (long al_orden_corte) throws exception;/********************************************************************
  SA48797 - E00387
  of_crear_barra_ordencorte
        
   <DESC>   Funcion para crear en dt_simulacion la barra correspondiente a la OC raya real creada </DESC>
        
   <RETURN> None</RETURN>

   <ACCESS> Public

   <ARGS>   al_orden_corte: Codigo de la orden de corte 
				al_raya: Raya de la OC
				al_pedido: Pedido de la OC
				adc_cantidad: Cantidad que debe llevar la barra
	
	</ARGS>

   <USAGE>  Esta funcion se llama cuando se debe crear una barra en la simulacion para una orden de corte real. </USAGE>

********************************************************************/

Long li_resultado, li_fila_ordenpd
Long ll_raya, ll_maquina, ll_secuencia, ll_sw_crea_barra, ll_reg, ll_row, ll_r, ll_reg_barra_cerca
Decimal ldc_cantidad, ldc_tiempo_estandar
String ls_mensaje, ls_referencia, ls_modulos, ls_modulo
Date ld_fecha_anterior
Datetime ldt_fe_inicio, ldt_fe_final, ldt_fecha_actual, ldt_fecha_inicial
uo_dsbase lds_ordenpd_raya, lds_buscar_barra_proyectada, lds_barra_oc_real, lds_buscar_fecha_final, lsd_dt_simulacion, lds_indicativo
n_utilidades_calendario_new luo_utilidades_calendario
Exception le_error
s_parametros_calendario lstr_parametros
//luispie
Long 	ll_ordenpd_pt
le_error = Create exception

lds_indicativo = Create uo_dsbase
lds_indicativo.DataObject = "d_gr_dt_pdnxmodulo_ind_base"
lds_indicativo.setTransObject(SQLCA)

//objeto para buscar las rayas y ordenes de produccion de una OC
lds_ordenpd_raya = Create uo_dsbase
lds_ordenpd_raya.DataObject = "d_sq_gr_buscr_ordenpd_raya_agrupado"
lds_ordenpd_raya.setTransObject(gnv_recursos.of_get_transaccion_sucia() )

//objeto para buscar la barra proyectada de la OC a generar mas cercana a la fecha actual
lds_buscar_barra_proyectada = Create uo_dsbase
lds_buscar_barra_proyectada.DataObject = "d_sq_gr_buscar_barra_proyectada_cercana"
lds_buscar_barra_proyectada.setTransObject(gnv_recursos.of_get_transaccion_sucia()  )

//objeto para  guardar la nueva barra
lds_barra_oc_real = Create uo_dsbase
lds_barra_oc_real.DataObject = "d_sq_gr_buscar_barra_proyectada_cercana"
lds_barra_oc_real.setTransObject(SQLCA  )

//objeto para buscar la fecha donde debe programarse la nueva barra
lds_buscar_fecha_final = Create uo_dsbase
lds_buscar_fecha_final.DataObject = "d_sq_gr_buscar_fecha_final_oc_real"
lds_buscar_fecha_final.setTransObject(gnv_recursos.of_get_transaccion_sucia() )

ll_sw_crea_barra = 0
ldt_fecha_actual = f_fecha_servidor()
ld_fecha_anterior = Date(ldt_fecha_actual)
//buscar ordenes de produccion, rayas y cantidades
li_resultado = lds_ordenpd_raya.of_retrieve(al_orden_corte)
If (li_resultado <= 0) Then
	le_error.setmessage("Error al buscar las ordenes de produccion de la OC " + String(al_orden_corte))
	Throw(le_error)
End if

//para que no salga el mensaje de no mover y dejarlo hacer
ib_mensaje_no_mover = False
//recorrr rayas de orden
For li_fila_ordenpd = 1 to lds_ordenpd_raya.Rowcount()
	
	ll_raya = lds_ordenpd_raya.Getitemnumber(li_fila_ordenpd, "dt_agrupa_pdn_raya_raya")
	ldc_cantidad = lds_ordenpd_raya.Getitemnumber(li_fila_ordenpd, "agrp_pendiente")
	
	//armar referencia
	ls_referencia = String(al_orden_corte) + Fill(" ", 8 - Len(String(al_orden_corte) ))
	ls_referencia += String(ll_raya) + Fill(" ", 3 - Len(String(ll_raya)))
	
	//buscar barra proyectada mas cercada
	li_resultado = lds_buscar_barra_proyectada.of_retrieve(al_orden_corte,  ll_raya)
	//se continua si no encuentra barra proyectada 
	If (li_resultado = 0) Then
		Continue;
	ElseIf (li_resultado < 0) Then
		ls_mensaje = "Error al buscar la barra proyectada de la OC raya " + ls_referencia
		le_error.setmessage(ls_mensaje)
		Throw(le_error)
	End if
	
	//toma inicialmente el primer registro
	ll_reg_barra_cerca = 1
	//si encuentra mas de una barra
	If (li_resultado > 1) Then
		lds_buscar_barra_proyectada.SetSort('fe_inicio_progs Asc')
		lds_buscar_barra_proyectada.Sort()
		
		//recorre las barras para saber cual es la mas cercana a la fecha actual
		For ll_r = 1 to lds_buscar_barra_proyectada.RowCount()
			//toma la fecha inicial
			ldt_fecha_inicial = lds_buscar_barra_proyectada.GetItemDateTime(ll_r,"fe_inicio_progs")
			//mira si la fecha es menor a la fecha actual
			If ldt_fecha_inicial < ldt_fecha_actual  Then
				//toma el registro como el mas cercano
				ll_reg_barra_cerca = ll_r
			Else
				//si la fecha es mayor es la fecha mas cercana a la fecha actual
				ll_reg_barra_cerca = ll_r
				Exit;
			End if
		Next
		
	END IF
	
	//obtener maquina de la barra proyectada
	ll_maquina = lds_buscar_barra_proyectada.getitemnumber(ll_reg_barra_cerca,"co_maquina")
	
	//buscar fecha final maxima de las oc reales
	li_resultado = lds_buscar_fecha_final.of_retrieve(ll_maquina)
	If (li_resultado <= 0) Then
		le_error.setmessage("Error al buscar la maxima fecha de fin de la maquina " + String(ll_maquina))
		Throw(le_error)
	End if
	//obtener fecha final
	ldt_fe_inicio = lds_buscar_fecha_final.getitemdatetime(1,"fe_final")
	//si la fecha es nula se coloca la fecha actual
	If Isnull(ldt_fe_inicio) Then 
		ldt_fe_inicio = f_fecha_servidor()
	End if
	//mira si la fecha anterior es mayor a la fecha incial, esto para el recalculo para que se haga desde la fecha mas anterior
	If ld_fecha_anterior > Date(ldt_fe_inicio) Then
		ld_fecha_anterior = Date(ldt_fe_inicio)
	End if
	
	//llenar objeto para crear barra de oc real con base en los datos de la barra proyectada
	li_resultado = lds_buscar_barra_proyectada.rowsCopy(ll_reg_barra_cerca,ll_reg_barra_cerca, Primary!, lds_barra_oc_real, lds_barra_oc_real.RowCount() + 1, Primary!)
	If (li_resultado <= 0) Then
		le_error.setmessage("Error al crear la nueva barra de la OC raya " + ls_referencia)
		Throw(le_error)
	End if
	
	ll_reg = lds_barra_oc_real.RowCount()
	//calcular el estandar para la orden-maquina
	If of_cambiar_estandar(ldc_tiempo_estandar,ll_maquina, ls_referencia) = False Then
		Rollback;
		le_error.setmessage("Error al calcular el estandar de la nueva barra de la OC raya " + ls_referencia)
		Throw(le_error)
	End if
	//ldc_tiempo_estandar = this.of_calcular_estandar(al_orden_corte,0,ll_maquina)
	
	//llamar a objeto que calcula la fecha de fin
	luo_utilidades_calendario.co_fabrica = lds_barra_oc_real.getitemnumber(ll_reg,'co_fabrica_sim')
	luo_utilidades_calendario.co_planta = lds_barra_oc_real.getitemnumber(ll_reg,'co_planta')
	luo_utilidades_calendario.co_centro = lds_barra_oc_real.getitemnumber(ll_reg,'co_centro_pdn')
	luo_utilidades_calendario.co_subcentro = lds_barra_oc_real.getitemnumber(ll_reg,'co_subcentro_pdn')
	luo_utilidades_calendario.co_tipo_negocio = 7
	luo_utilidades_calendario.co_maquina = lds_barra_oc_real.getitemnumber(ll_reg,'co_maquina') 
	luo_utilidades_calendario.simulacion = 0
	luo_utilidades_calendario.co_curva = lds_barra_oc_real.getitemnumber(ll_reg,'co_curva') 
	li_resultado = luo_utilidades_calendario.of_calcular_fecha(ldt_fe_inicio, ldt_fe_final, "I", ldc_tiempo_estandar, ldc_cantidad, 0)

	If (li_resultado < 0) Then
		le_error.setmessage("Error al calcular las fechas de la nueva barra de la OC raya " + ls_referencia)
		Throw(le_error)
	End if

	//modificar datos de la barra
	setnull(ll_secuencia)
	lds_barra_oc_real.setitem(ll_reg,"secuencia", ll_secuencia)
	lds_barra_oc_real.setitem(ll_reg,"pedido", al_orden_corte)
	lds_barra_oc_real.setitem(ll_reg,"co_referencia", ls_referencia)
	lds_barra_oc_real.setitem(ll_reg,"de_referencia", ls_referencia)	
	lds_barra_oc_real.setitem(ll_reg,"ca_programada", ldc_cantidad)
	lds_barra_oc_real.setitem(ll_reg,"co_maquina", ll_maquina)
	lds_barra_oc_real.setitem(ll_reg,"fe_inicio_progs", ldt_fe_inicio)
	lds_barra_oc_real.setitem(ll_reg,"fe_final_progs", ldt_fe_final)
	lds_barra_oc_real.setitem(ll_reg,"tiempo_estandar", ldc_tiempo_estandar)
	
	lds_barra_oc_real.setitem(ll_reg,"sw_mover", 0)
	
	//datos de auditoria
	lds_barra_oc_real.setitem(ll_reg,"fe_creacion", ldt_fecha_actual)
	lds_barra_oc_real.setitem(ll_reg,"fe_actualizacion", ldt_fecha_actual)
	lds_barra_oc_real.setitem(ll_reg,"usuario", gstr_info_usuario.codigo_usuario)
	
	//reiniciar status para que inserte la nueva fila
	lds_barra_oc_real.SetitemStatus(ll_reg,0,Primary!, New!)	
	
	
	//indica que la oc-raya se le crea barra en el pdp
	lds_ordenpd_raya.SetItem(li_fila_ordenpd, "sw_pdp",1)

Next

//si hay barras para crear
If lds_barra_oc_real.RowCount() > 0 Then
	//busca si esta todas las rayas par el pdp
	ll_reg = lds_ordenpd_raya.Find('sw_pdp = 0',1, lds_ordenpd_raya.RowCount() +1)
	//si estan todas las rayas
	If ll_reg = 0 Then
		If (lds_barra_oc_real.of_update() <= 0 ) Then
			le_error.setmessage("Error al guardar la nueva barra de la OC raya " + ls_referencia)
			Throw(le_error)
		End if
		
		lstr_parametros.hay_parametros = False
		ls_modulos = ''
		//recorre las barras para recalcular el pdp
		For ll_reg = 1 to lds_barra_oc_real.RowCount()
			ll_maquina = lds_barra_oc_real.getitemnumber(ll_reg,'co_maquina')
			ls_modulo = '*' + String(lds_barra_oc_real.getitemnumber(ll_reg,'co_fabrica_sim')) + &
							String(lds_barra_oc_real.getitemnumber(ll_reg,'co_planta')) + &
							String(lds_barra_oc_real.getitemnumber(ll_reg,'co_centro_pdn')) + &
							String(lds_barra_oc_real.getitemnumber(ll_reg,'co_subcentro_pdn')) + &
							String(lds_barra_oc_real.getitemnumber(ll_reg,'co_maquina')) + '*'
						
						
			//mira si ya recalculo el modulo
			If Pos(ls_modulos, ls_modulo) = 0 Then
				//luispie
				//lo tengo considerado para recalcular y que corra las barras no proyectadas
				lstr_parametros.hay_parametros = True
				lstr_parametros.entero[UpperBound(lstr_parametros.entero) +1] = ll_maquina //modulo
				/*
				this.of_recalcular( lstr_parametros, lds_barra_oc_real.getitemnumber(ll_reg,'co_fabrica_sim'),&
								 lds_barra_oc_real.getitemnumber(ll_reg,'co_planta'), lds_barra_oc_real.getitemnumber(ll_reg,'co_centro_pdn'),&
								 lds_barra_oc_real.getitemnumber(ll_reg,'co_subcentro_pdn'), 7, 0, date(ld_fecha_anterior))
				//finluispie	
				*/
				ls_modulos = ls_modulos + ls_modulo
			End if
		Next 
		
		//si hay datos para recalcular
		If lstr_parametros.hay_parametros Then
			this.of_recalcular( lstr_parametros, lds_barra_oc_real.getitemnumber(1,'co_fabrica_sim'),&
								 lds_barra_oc_real.getitemnumber(1,'co_planta'), lds_barra_oc_real.getitemnumber(1,'co_centro_pdn'),&
								 lds_barra_oc_real.getitemnumber(1,'co_subcentro_pdn'), 7, 0, date(ld_fecha_anterior))
								 
		End if
	
		//si creo la barra se actualiza el campo indicativo_base
		// se inserta un registro que se va a actualizar
		ll_row = lds_indicativo.InsertRow(0)
		lds_indicativo.SetItem(ll_row, 'simulacion', 1)
		lds_indicativo.SetItem(ll_row, 'cs_asignacion', al_orden_corte)
		lds_indicativo.SetItem(ll_row, 'indicativo_base', 0)
		lds_indicativo.SetItem(ll_row, 'fe_actualizacion', f_fecha_servidor())
		lds_indicativo.SetItem(ll_row, 'usuario', trim(gstr_info_usuario.nombre_usuario))
		lds_indicativo.SetItem(ll_row, 'instancia', trim(gstr_info_usuario.instancia))
		
	// se ponen los registros como modificado para que se lance un update
		lds_indicativo.ResetUpdate()
		lds_indicativo.SetItemStatus(ll_row, "indicativo_base", Primary!, DataModified!)
		lds_indicativo.SetItemStatus(ll_row, "fe_actualizacion", Primary!, DataModified!)
		lds_indicativo.SetItemStatus(ll_row, "usuario", Primary!, DataModified!)
		lds_indicativo.SetItemStatus(ll_row, "instancia", Primary!, DataModified!)
		
		lds_indicativo.SetItem(ll_row, 'indicativo_base', 1)
		
		If (lds_indicativo.of_update() <= 0 ) Then
			le_error.setmessage("Ocurrio un error al momento de actualizar el indicativo base de la oc " + String(al_orden_corte))
			Throw(le_error)
		End if
		
		/*
		update dt_pdnxmodulo set indicativo_base = 1
			where simulacion=1
			and   cs_asignacion=:al_orden_corte;
		IF sqlca.sqlcode = -1 THEN
			Rollback;
			le_error.setmessage("Ocurrio un error al momento de actualizar el indicativo base de la oc " + String(al_orden_corte))
			Throw(le_error)
		END IF
		*/
	End if
End if


ib_mensaje_no_mover = True
end subroutine

public function decimal of_calcular_estandar (long al_orden_corte, long al_referencia, long al_modulo) throws exception;/********************************************************************
  SA48603 - E00603 
  of_calcular_estandar
        
   <DESC>   Funcion que calcula el estandar de una orden </DESC>
        
   <RETURN> Decimal:Valor del estandar de la OC </RETURN>

   <ACCESS> Public

   <ARGS>   al_orden_corte: Codigo de la roden de corte. 0 Si es para referencia especifica
				al_referencia: Referencia para la que se debe calcular el estadar. 0 para todas las referencias de la OC
            al_modulo: Codigo del modulo. 0 Para todos los modulos</ARGS>

   <USAGE>  Esta funcion es llamada cada vez qye se requiere calcular el valor
	del estandar de una roden .</USAGE>

********************************************************************/

Long li_fila, li_filas_totales, li_indice_referencia
Long ll_referencia_actual, ll_referencia, ll_referencias[]
Decimal  ldc_estandar, ldc_total_unidades[], ldc_estandar_acumulado[], ldc_unidades, ldc_tiempo_st, ldc_porc_eficiencia
uo_dsbase lds_estandar_x_referencia
Exception le_error
n_utilidades_calendario_new luo_utilidades_calendario

le_error = Create Exception
lds_estandar_x_referencia = Create uo_dsbase

//si viene modulo escoger el datawindow adecuada y recuperar las filas
If (al_modulo <> 0) Then
	//crea datastore para leer estandar 
	lds_estandar_x_referencia.DataObject = 'd_sq_gr_estandar_referencia_modulo'
	lds_estandar_x_referencia.SettransObject(gnv_recursos.of_get_transaccion_sucia( ) )
	li_filas_totales = lds_estandar_x_referencia.of_retrieve(al_orden_corte, al_referencia,al_modulo)
	
	//si no hay estandar definido
	If (li_filas_totales = 0 ) Then
		Return 0
	//si hubo error	
	Elseif (li_filas_totales < 0) Then
		le_error.SetMessage("Error recuperando los datos de referencias de la orden " + String(al_orden_corte) + " para el modulo " +String(al_modulo))
		Throw(le_error)
	End if	
Else	
	//crea datasotre para leer estandar por modulo
	lds_estandar_x_referencia.DataObject = 'd_sq_gr_estandar_referencia'
	lds_estandar_x_referencia.SettransObject(gnv_recursos.of_get_transaccion_sucia( ) )
	li_filas_totales = lds_estandar_x_referencia.of_retrieve(al_orden_corte, al_referencia)
	
	//si no hay estandar definido
	If (li_filas_totales = 0 ) Then
		Return 0
	//si hubo error	
	Elseif (li_filas_totales < 0) Then
		le_error.SetMessage("Error recuperando los datos de referencias de la orden " + String(al_orden_corte))
		Throw(le_error)
	End if	
End if	

//ldc_total_unidades = 0

li_indice_referencia = 0

//Calcular promedio ponderado de los estandares de las referencias
For li_fila = 1 to li_filas_totales
	ll_referencia = lds_estandar_x_referencia.getitemnumber(li_fila,'co_referencia')
	If (ll_referencia_actual <> ll_referencia) Then
		ll_referencia_actual = ll_referencia
		li_indice_referencia++
		ldc_unidades = lds_estandar_x_referencia.getitemnumber(li_fila,'ca_unidades')
		ldc_total_unidades[li_indice_referencia] = ldc_unidades
		ll_referencias[li_indice_referencia] = ll_referencia
	End if	
	
	ldc_tiempo_st = lds_estandar_x_referencia.getitemnumber(li_fila,'tiempo_st')
	
	ldc_porc_eficiencia = lds_estandar_x_referencia.getitemnumber(li_fila,'porc_eficiencia')
	If( (ldc_porc_eficiencia = 0 OR isnull(ldc_porc_eficiencia))) Then
		If (al_modulo <> 0 ) then
			le_error.SetMessage("No se encontr$$HEX2$$f3002000$$ENDHEX$$porcentaje de eficiencia asociado a la mesa "+String(al_modulo))
		else
			le_error.SetMessage("No se encontr$$HEX2$$f3002000$$ENDHEX$$porcentaje de eficiencia asociado a la referencia "+String(ll_referencia_actual))
		End if	
		Throw(le_error)
	End If
	
	ldc_estandar = ldc_tiempo_st
	ldc_estandar *= ldc_porc_eficiencia
	ldc_estandar_acumulado[li_indice_referencia] += ldc_estandar
Next	

ldc_unidades = 0
ldc_estandar = 0

//calcular estandar ponderado por cantidad de unidades por referencia
For li_indice_referencia = 1 To Upperbound(ldc_estandar_acumulado)
	If( ldc_estandar_acumulado[li_indice_referencia] = 0 or isnull(ldc_estandar_acumulado[li_indice_referencia])) Then
		le_error.SetMessage("No se encontr$$HEX2$$f3002000$$ENDHEX$$tiempo estandar de la referencia "+String(ll_referencias[li_indice_referencia]))
		Throw(le_error)
	End If
	 ldc_unidades += ldc_total_unidades[li_indice_referencia]
	 ldc_estandar += (ldc_total_unidades[li_indice_referencia] * ldc_estandar_acumulado[li_indice_referencia])
Next	

//estandar promedio
ldc_estandar = ldc_estandar / ldc_unidades


Return ldc_estandar
end function

public function long of_actualizar_barras_simulacion (long al_orden_corte) throws exception;/********************************************************************
  SA48797 - E00387
  of_actualizar_barras_simulacion
        
   <DESC>   Funcion que se encargara de actulizar las barras proyectadas de la OC </DESC>
        
   <RETURN> None</RETURN>

   <ACCESS> Public

   <ARGS>   al_orden_corte: Codigo de la orden de corte </ARGS>

   <USAGE>  Esta funcion se llama cuando se crea una orden de corte real. </USAGE>

********************************************************************/

Long li_resultado, li_fila_ordenpd
Long ll_ordenpd_pt, ll_raya, ll_ordencorte_proyectada
Decimal ldc_cantidad, lds_cantidad_actualizada
String ls_referencia, ls_mensaje
uo_dsbase lds_ordenpd_raya, lds_ordencorte_proyectada, lds_barras_ordencorte_raya
Exception le_error

le_error = Create exception

//objeto para buscar las rayas y ordenes de produccion de una OC
lds_ordenpd_raya = Create uo_dsbase
lds_ordenpd_raya.DataObject = "d_sq_gr_buscr_ordenpd_raya"
lds_ordenpd_raya.setTransObject(gnv_recursos.of_get_transaccion_sucia() )

//objeto para buscar las ordenes de corte proyectada de una orden de produccion
lds_ordencorte_proyectada = Create uo_dsbase
lds_ordencorte_proyectada.DataObject = "d_sq_gr_buscar_ordencorte_proyectada"
lds_ordencorte_proyectada.setTransObject(gnv_recursos.of_get_transaccion_sucia() )

//objeto para actualizar las barras de una orden de corte
lds_barras_ordencorte_raya = Create uo_dsbase
lds_barras_ordencorte_raya.DataObject = "d_sq_gr_barras_ordencorte_raya"
lds_barras_ordencorte_raya.setTransObject(SQLCA )

//buscar ordenes de produccion, rayas y cantidades
li_resultado = lds_ordenpd_raya.of_retrieve(al_orden_corte)
If (li_resultado <= 0) Then
	le_error.setmessage("Error al buscar las ordenes de produccion de la OC " + String(al_orden_corte))
	Throw(le_error)
End if	

//recorrer ordenes de produccion
For li_fila_ordenpd = 1 to lds_ordenpd_raya.Rowcount()
	ll_ordenpd_pt = lds_ordenpd_raya.Getitemnumber(li_fila_ordenpd, "dt_pdnxmodulo_cs_ordenpd_pt")
	ll_raya = lds_ordenpd_raya.Getitemnumber(li_fila_ordenpd, "dt_agrupa_pdn_raya_raya")
	ldc_cantidad = lds_ordenpd_raya.Getitemnumber(li_fila_ordenpd, "dt_pdnxmodulo_ca_pendiente")
	
	//buscar oc proyectadas
	li_resultado = lds_ordencorte_proyectada.of_retrieve(ll_ordenpd_pt)
	If (li_resultado = 0) Then
		//se continua si no encuentra barra proyectada 
		continue;
	ElseIf (li_resultado < 0) Then
		ls_mensaje = "Ocurrio un inconveniente al consultar la orden de corte proyectada para la orden de corte que se est$$HEX2$$e1002000$$ENDHEX$$generando en la raya "+String(ll_raya)+", se cancela el proceso"
		le_error.setmessage(ls_mensaje)
		Throw(le_error)
	End if
	
	ll_ordencorte_proyectada = lds_ordencorte_proyectada.getitemnumber(1,"cs_asignacion")
	
	//armar referencia
	ls_referencia = String(ll_ordencorte_proyectada) + Fill(" ", 8 - Len(String(ll_ordencorte_proyectada) ))
	ls_referencia += String(ll_raya) + Fill(" ", 3 - Len(String(ll_raya)))
	
	//consultar barras del PDP
	li_resultado = lds_barras_ordencorte_raya.of_retrieve(ll_ordencorte_proyectada, ls_referencia)
	If (li_resultado = 0) Then
		//se continua si no encuentra barra proyectada 
		continue;
	ElseIf (li_resultado < 0) Then
		ls_mensaje= "Error al buscar las barras del PDP de la OC Raya " + ls_referencia
		le_error.setmessage(ls_mensaje)
		Throw(le_error)
	End if
	
	//actualziar cantidad programada
	lds_cantidad_actualizada = lds_barras_ordencorte_raya.getitemnumber(1, "ca_programada")
	lds_cantidad_actualizada -= ldc_cantidad
	
	//si es menor a cero, dejar en cero
	If (lds_cantidad_actualizada < 0) then
		lds_cantidad_actualizada = 0
	End if	
	
	//guardar cambios en barras
	lds_barras_ordencorte_raya.Setitem(1, "ca_programada", lds_cantidad_actualizada)
	li_resultado = lds_barras_ordencorte_raya.of_update()
	If (li_resultado <= 0) Then
		le_error.setmessage("Error al actualizar las barras de la OC Raya " + ls_referencia)
		Throw(le_error)
	End if
	
Next

Return 1


end function

public function decimal of_calcular_estandar (long al_orden_corte, long al_referencia, long al_modulo, long ai_raya) throws exception;/********************************************************************
  SA48603 - E00603 
  of_calcular_estandar
        
   <DESC>   Funcion que calcula el estandar de una orden </DESC>
        
   <RETURN> Decimal:Valor del estandar de la OC </RETURN>

   <ACCESS> Public

   <ARGS>   al_orden_corte: Codigo de la orden de corte. 0 Si es para referencia especifica
				al_referencia: Referencia para la que se debe calcular el estadar. 0 para todas las referencias de la OC
            al_modulo: Codigo del modulo. 0 Para todos los modulos</ARGS>

   <USAGE>  Esta funcion es llamada cada vez qye se requiere calcular el valor
	del estandar de una roden .</USAGE>

********************************************************************/

Long li_fila, li_filas_totales, li_indice_referencia
Long ll_referencia_actual, ll_referencia, ll_referencias[], ll_retorno, ll_find
Decimal  ldc_estandar, ldc_total_unidades[], ldc_estandar_acumulado[], ldc_unidades, ldc_tiempo_st, ldc_porc_eficiencia
uo_dsbase lds_estandar_x_referencia
Exception le_error
n_utilidades_calendario_new luo_utilidades_calendario

le_error = Create Exception
lds_estandar_x_referencia = Create uo_dsbase

ll_retorno = 1
//si viene modulo escoger el datawindow adecuada y recuperar las filas
If (al_modulo <> 0) Then
	//crea datastore para leer estandar 
	lds_estandar_x_referencia.DataObject = 'd_sq_gr_estandar_referencia_modulo_raya'
	lds_estandar_x_referencia.SettransObject(gnv_recursos.of_get_transaccion_sucia( ) )
	li_filas_totales = lds_estandar_x_referencia.of_retrieve(al_orden_corte, al_referencia,al_modulo, ai_raya)
	
	//si no hay estandar definido
	If (li_filas_totales = 0 ) Then
		ll_retorno = 0
		//Return 0
	//si hubo error	
	Elseif (li_filas_totales < 0) Then
		le_error.SetMessage("Error recuperando los datos de referencias de la orden " + String(al_orden_corte) + " para el modulo " +String(al_modulo))
		Throw(le_error)
	End if	
Else	
	//crea datasotre para leer estandar por modulo
	lds_estandar_x_referencia.DataObject = 'd_sq_gr_estandar_referencia_raya'
	lds_estandar_x_referencia.SettransObject(gnv_recursos.of_get_transaccion_sucia( ) )
	li_filas_totales = lds_estandar_x_referencia.of_retrieve(al_orden_corte, al_referencia, ai_raya)
	
	//si no hay estandar definido
	If (li_filas_totales = 0 ) Then
		ll_retorno= 0
		//Return 0
	//si hubo error	
	Elseif (li_filas_totales < 0) Then
		le_error.SetMessage("Error recuperando los datos de referencias de la orden " + String(al_orden_corte))
		Throw(le_error)
	End if	
End if	

//mira si trae datos y no es raya 0
If ll_retorno = 0 and ai_raya > 0 and ( al_referencia > 0 or al_modulo <> 0) Then
//	MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$tiempo est$$HEX1$$e100$$ENDHEX$$ndar de la referencia ' + String(al_orden_corte) +' -Raya ' + string(ai_raya) +&
//						', se continua buscando tiempo por referencia, tenga esta referencia en cuenta')
	
	If (al_modulo <> 0) Then
		li_filas_totales = lds_estandar_x_referencia.of_retrieve(al_orden_corte, al_referencia,al_modulo, 0)
	Else
		li_filas_totales = lds_estandar_x_referencia.of_retrieve(al_orden_corte, al_referencia, 0)
	End if
	
	//si no hay estandar definido
	If (li_filas_totales = 0 ) Then
		Return 0
	//si hubo error	
	Elseif (li_filas_totales < 0) Then
		If (al_modulo <> 0) Then
			le_error.SetMessage("Error recuperando los datos de referencias de la orden " + String(al_orden_corte) + " para el modulo " +String(al_modulo))
			Throw(le_error)
		Else
			le_error.SetMessage("Error recuperando los datos de referencias de la orden " + String(al_orden_corte))
			Throw(le_error)
		End if
	End if	
End if


//ldc_total_unidades = 0

li_indice_referencia = 0

//Calcular promedio ponderado de los estandares de las referencias
For li_fila = 1 to li_filas_totales
	ll_referencia = lds_estandar_x_referencia.getitemnumber(li_fila,'co_referencia')
	If (ll_referencia_actual <> ll_referencia) Then
		ll_referencia_actual = ll_referencia
		li_indice_referencia++
		ldc_unidades = lds_estandar_x_referencia.getitemnumber(li_fila,'ca_unidades')
		ldc_total_unidades[li_indice_referencia] = ldc_unidades
		ll_referencias[li_indice_referencia] = ll_referencia
	End if	
	
	ldc_tiempo_st = lds_estandar_x_referencia.getitemnumber(li_fila,'tiempo_st')
	
	ldc_porc_eficiencia = lds_estandar_x_referencia.getitemnumber(li_fila,'porc_eficiencia')
	If( (ldc_porc_eficiencia = 0 OR isnull(ldc_porc_eficiencia))) Then
		If (al_modulo <> 0 ) then
			le_error.SetMessage("No se encontr$$HEX2$$f3002000$$ENDHEX$$porcentaje de eficiencia asociado a la mesa "+String(al_modulo))
		else
			le_error.SetMessage("No se encontr$$HEX2$$f3002000$$ENDHEX$$porcentaje de eficiencia asociado a la referencia "+String(ll_referencia_actual))
		End if	
		Throw(le_error)
	End If
	
	ldc_estandar = ldc_tiempo_st
	ldc_estandar *= ldc_porc_eficiencia
	ldc_estandar_acumulado[li_indice_referencia] += ldc_estandar
Next	

ldc_unidades = 0
ldc_estandar = 0

//calcular estandar ponderado por cantidad de unidades por referencia
For li_indice_referencia = 1 To Upperbound(ldc_estandar_acumulado)
	If( ldc_estandar_acumulado[li_indice_referencia] = 0 or isnull(ldc_estandar_acumulado[li_indice_referencia])) Then
		le_error.SetMessage("No se encontr$$HEX2$$f3002000$$ENDHEX$$tiempo estandar de la referencia "+String(ll_referencias[li_indice_referencia]))
		Throw(le_error)
	End If
	 ldc_unidades += ldc_total_unidades[li_indice_referencia]
	 ldc_estandar += (ldc_total_unidades[li_indice_referencia] * ldc_estandar_acumulado[li_indice_referencia])
Next	

If ldc_unidades > 0 Then
	//estandar promedio
	ldc_estandar = ldc_estandar / ldc_unidades
Else
	//ldc_estandar = 0
End if


Return ldc_estandar
end function

public function boolean of_cambiar_estandar (ref decimal adc_estandar, long al_maquina, string as_referencia);/********************************************************************
  SA48603 - E00368
  of_cambiar_estandar
        
   <DESC>   Funcion que se encarga de calcular el estandar de una barra</DESC>
        
   <RETURN> Boolean:
            <LI> true, X ok
            <LI> false, X failed</RETURN>

   <ACCESS> Public

   <ARGS>   adc_estandar: Estandar de la barra
            adc_capacidad_maquina: Capacidad maxima de la maquina
				adc_cantidad: Cantidad de la barra
				al_maquina: Maquina donde esta la barra
				as_referencia: Referencia de la barra
				as_accion: Accion que se esta ejecutando
	</ARGS>

   <USAGE>  Esta funcion es llamada cada vez que se debe dibujar una barra en el pdp.</USAGE>

********************************************************************/

long ll_minutos
Decimal ldc_cuota
uo_dsbase lds_maquinas_x_comaquina
//n_utilidades_simulacion_protela luo_utilidades_simulacion

lds_maquinas_x_comaquina = Create uo_dsbase
lds_maquinas_x_comaquina.DataObject = 'd_gr_m_maquinas_x_comaquina'
lds_maquinas_x_comaquina.SettransObject(gnv_recursos.of_get_transaccion_sucia( ) )

if (lds_maquinas_x_comaquina.of_retrieve(al_maquina) > 0 ) Then
	ldc_cuota = lds_maquinas_x_comaquina.getItemNumber(1,'cuota_diaria')

	If (ldc_cuota > 0) Then
		//calcule el estandar con base en los datos de la maquina
		ll_minutos = lds_maquinas_x_comaquina.getItemNumber(1,'minutos_turno')
		adc_estandar = ll_minutos / ldc_cuota
	Else
		Try
			//llamado a funcion de calculo de estandar para referencia
			adc_estandar = This.of_calcular_estandar(Long(mid(as_referencia,1,8)) , 0,al_maquina, Long(mid(as_referencia,9)))
		Catch(Exception le_error)
			MessageBox("Error", le_error.getMessage(), StopSign!)
			Return False
		End try
	End if	
End if	

//validacion de calculo de estandar
If IsNull(adc_estandar) OR adc_estandar = 0 Then
	adc_estandar=0
		Messagebox("Advertencia","Estandar esta en cero")
	Return False
End If

RETURN TRUE
end function

on n_utilidades_simulacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_utilidades_simulacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;itr_transaccion = SQLCA
end event

event destructor;Destroy(invo_objeto_reglas)
end event

