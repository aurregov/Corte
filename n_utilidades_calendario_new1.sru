HA$PBExportHeader$n_utilidades_calendario_new1.sru
forward
global type n_utilidades_calendario_new1 from nonvisualobject
end type
end forward

global type n_utilidades_calendario_new1 from nonvisualobject autoinstantiate
end type

type variables
Long co_fabrica, co_planta, co_centro, co_subcentro, co_tipo_negocio, &
		 simulacion, co_tipo_maquina, dias_de_continuidad
Long co_curva, minutos_totales, minuto_laboral_ini, minuto_laboral_fin, sw_curva, & 
		co_maquina
String is_referencia
Decimal eficiencia, idc_cuota_diaria_maquina, idc_cuota_diaria_maq_ref
// bandera para redondear el resultado, 
Boolean ib_redondear = False, ib_escalar_manual = True

Transaction itr_transaccion

Private Decimal idc_a, idc_b
Private Long dia_estabilidad, no_personas, min_turno, turnos
Private Long co_calendario, co_fabrica_cal
Private n_curva invo_curva
Private Long co_maquina_cal


Private uo_dsbase ids_calendario_fabrica, ids_calendario_novedad, &
			ids_calendario_maquina, ids_curvas, ids_turnos
uo_dsbase ids_curvas_manuales, ids_maquinas, ids_cuota_maq_ref

end variables

forward prototypes
public function long of_nodiaslaborables (long ai_calendario, date ad_fecha_inicio, date ad_fecha_fin)
public function date of_diasdespues (long ai_calendario, date ad_fecha, long ai_dias)
public function date of_diasantes (long ai_calendario, date ad_fecha, long ai_dias)
public function long of_calendario_fabrica (long ai_fabrica)
public function date of_fechamaxima (long ai_calendario)
public function date of_fechaminima (long ai_calendario)
public function long of_cargar_datos ()
public function long of_set_calendario_fabrica ()
public function long of_set_calendario_maquina ()
public function boolean of_festivo (long ai_calendario, date ad_fecha)
public function date of_diasantes_x_modulo (date ad_fecha_inicio, long ai_dias)
public function date of_diasdespues_x_modulo (date ad_fecha_inicio, long ai_dias)
public function long of_nodiaslaborales_x_modulo (date ad_fecha_inicio, date ad_fecha_fin)
public function decimal of_calcularminuto (datetime adtm_fecha)
public function long of_fechaexiste (long ai_calendario, date ad_fecha)
public function long of_calcular_fecha (ref datetime adtm_fecha_ini, ref datetime adtm_fecha_fin, character ac_sentido, decimal adc_estandar, decimal adc_cantidad, long ai_dias_de_continuidad)
public function decimal of_calcular_unidades (datetime adtm_fecha_ini, datetime adtm_fecha_fin, decimal adc_estandar, long ai_dias_de_continuidad)
public function long of_dias_de_atraso (date ad_fecha_prog, date ad_fecha_real)
public function long of_reiniciar_propiedades ()
public function long of_sumar_minutos (datetime adtm_fecha, long al_minutos, ref datetime adtm_fecha_sumada)
public function long of_sumar_minutos_laborales (datetime adtm_fecha, long al_minutos, ref datetime adtm_fecha_sumada)
public function long of_mensaje (string as_titulo, string as_msn, s_base_parametros asp_parametros, string as_fin)
public function long of_set_transaccion (transaction atr_transaccion)
public function long of_configuracion_dia (date ad_fecha, ref string as_tipo_novedad, ref long al_turnos, ref long al_min_turno, ref long al_no_personas)
public function string of_tipo_novedad (date ad_fecha)
public function long of_set_dw_cuota_x_mod_ref (string as_dataobject)
public function long of_semanas_x_fecha (long ai_calendario, date ad_fecha_inicio, date ad_fecha_fin, ref s_base_parametros astr_semana[])
end prototypes

public function long of_nodiaslaborables (long ai_calendario, date ad_fecha_inicio, date ad_fecha_fin);/* -----------------------------------------------------------------------------------------
Esta Funci$$HEX1$$f300$$ENDHEX$$n Retorna el n$$HEX1$$fa00$$ENDHEX$$mero de d$$HEX1$$ed00$$ENDHEX$$as laborales entre un
rango de fechas
----------------------------------------------------------------------------------------- */

Long ll_row
Long li_dias

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_set_calendario_fabrica( ) < 0 Then 
	Return -1 //error al consultar la base de datos
End If
// se busca se existe la fecha de inicio
If of_fechaexiste( ai_calendario, ad_fecha_inicio) > 0 And of_fechaexiste( ai_calendario, ad_fecha_fin)>0 Then
	// se ordena el calendario
	ids_calendario_fabrica.SetSort('fe_calendario ASC ')
	ids_calendario_fabrica.Sort()
	// se filtran los dias habiles entre las fechas
	ids_calendario_fabrica.SetFilter('co_calendario = ' + String(co_calendario) + ' AND fe_calendario BETWEEN ' &
			+ String(ad_fecha_inicio, 'yyyy-mm-dd') + ' AND ' + String(ad_fecha_fin, 'yyyy-mm-dd') + " AND sw_festivo <> 'I'" )
	ids_calendario_fabrica.Filter( )
	// se retorn el numero de dias
	Return ids_calendario_fabrica.RowCount() 
Else
	// Las fechas no estan definidas en el calendario
	Return -3
End If


end function

public function date of_diasdespues (long ai_calendario, date ad_fecha, long ai_dias);Long ll_row
Date ld_retorno
Long li_dias

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_set_calendario_fabrica( ) < 0 Then 
	Return date('1000-01-01')//error al consultar la base de datos
End If
// se ordena el calendario
ids_calendario_fabrica.SetSort('fe_calendario ASC ')
ids_calendario_fabrica.Sort()
// se busca la fecha
ll_row = ids_calendario_fabrica.Find( 'fe_calendario = ' + String(ad_fecha, 'yyyy-mm-dd'), 1, ids_calendario_fabrica.RowCount() + 1)
// si encuentra la fecha
If ll_row > 0 Then
	If ai_dias = 0 Then
		Return ids_calendario_fabrica.GetItemDate(ll_row,"fe_calendario")
	End IF
	li_dias = 0
	Do While li_dias < ai_dias And ids_calendario_fabrica.RowCount() >= ll_row
		// si no es festivo se incrementan los dias
		If ids_calendario_fabrica.GetItemString(ll_row,"sw_festivo") <> 'I' Then
			li_dias ++
		End If
		ll_row ++
	Loop
	ll_row --
	// se obtiene la fecha del calendario
	ld_retorno = ids_calendario_fabrica.GetItemDate(ll_row,"fe_calendario")
Else
	// si no la encuentra 
	Return date('1000-01-02') // la fecha no existe en el calendario
End If
Return ld_retorno

end function

public function date of_diasantes (long ai_calendario, date ad_fecha, long ai_dias);/* -----------------------------------------------------------------------------------------
	Calcula los dias antes de una fecha, teniendo en cuenta
	los dias no laborables de la fabrica
----------------------------------------------------------------------------------------- */

Long ll_row
Date ld_retorno
Long li_dias

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_set_calendario_fabrica( ) < 0 Then 
	Return date('1000-01-01')//error al consultar la base de datos
End If
// se ordena el calendario
ids_calendario_fabrica.SetSort('fe_calendario DESC ')
ids_calendario_fabrica.Sort()
// se busca la fecha
ll_row = ids_calendario_fabrica.Find( 'fe_calendario = ' + String(ad_fecha, 'yyyy-mm-dd'), 1, ids_calendario_fabrica.RowCount() + 1)
// si encuentra la fecha
If ll_row > 0 Then
	If ai_dias = 0 Then
		Return ids_calendario_fabrica.GetItemDate(ll_row,"fe_calendario")
	End IF
	li_dias = 0
	Do While li_dias < ai_dias And ids_calendario_fabrica.RowCount() >= ll_row
		// si no es festivo se incrementan los dias
		If ids_calendario_fabrica.GetItemString(ll_row,"sw_festivo") <> 'I' Then
			li_dias ++
		End If
		ll_row ++
	Loop
	ll_row --
	// se obtiene la fecha del calendario
	ld_retorno = ids_calendario_fabrica.GetItemDate(ll_row,"fe_calendario")
Else
	// si no la encuentra 
	Return date('1000-01-02') // la fecha no existe en el calendario
End If
Return ld_retorno


end function

public function long of_calendario_fabrica (long ai_fabrica);/* -----------------------------------------------------------------------------------------
	Se obtiene el calendario de la fabrica	al_fabrica
-----------------------------------------------------------------------------------------  */
long li_row, ld_retorno
uo_dsbase lds_fabrica
lds_fabrica = CREATE uo_dsbase
lds_fabrica.DataObject = "d_calendario_fab_parametro"
lds_fabrica.SetTransObject(itr_transaccion)
// Se Trae el codigo de fabrica
li_row = lds_fabrica.Retrieve(ai_fabrica)
// Se valida errores
if li_row <= -1 Then
	ld_retorno = -1
Elseif li_row > 0 Then	
	// Se obtiene el codigo de calendario
	ld_retorno = lds_fabrica.GetItemNumber(1,'Co_Calendario')
End if
Destroy(lds_fabrica)
Return ld_retorno


end function

public function date of_fechamaxima (long ai_calendario);/* -----------------------------------------------------------------------------------------
Retorna la fecha m$$HEX1$$e100$$ENDHEX$$xima definida en el calendario
----------------------------------------------------------------------------------------- */
Long ll_row
Date ld_retorno

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_set_calendario_fabrica( ) < 0 Then 
	Return date('1000-01-01')//error al consultar la base de datos
End If
// Se ordena las fechas
ids_calendario_fabrica.SetSort('fe_calendario Asc')
ids_calendario_fabrica.Sort()
ll_row = ids_calendario_fabrica.RowCount()
If ll_row > 0 Then
	// Se trae el m$$HEX1$$e100$$ENDHEX$$ximo valor del calendario
	ld_retorno = ids_calendario_fabrica.GetItemDate(ll_row, 'fe_calendario')
Else
	ld_retorno = date('1900-01-02') // no existe el calendario
End If
Return ld_retorno



end function

public function date of_fechaminima (long ai_calendario);/* -----------------------------------------------------------------------------------------
Retorna la fecha m$$HEX1$$e100$$ENDHEX$$xima definida en el calendario
----------------------------------------------------------------------------------------- */
Long ll_row
Date ld_retorno

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_set_calendario_fabrica( ) < 0 Then 
	Return date('1000-01-01')//error al consultar la base de datos
End If
// Se ordena las fechas
ids_calendario_fabrica.SetSort('fe_calendario Asc')
ids_calendario_fabrica.Sort()
ll_row = ids_calendario_fabrica.RowCount()
If ll_row > 0 Then
	// Se trae el m$$HEX1$$e100$$ENDHEX$$ximo valor del calendario
	ld_retorno = ids_calendario_fabrica.GetItemDate(1, 'fe_calendario')
Else
	ld_retorno = date('1900-01-02') // no existe el calendario
End If
Return ld_retorno
end function

public function long of_cargar_datos ();/* -----------------------------------------------------------------------------------------
Se obtienen los datos  necesario para las funciones calcular fecha, calcular minuto y
calcular unidades.
Se Trae el tipo de maquina, luego se traen los datos estandar de turno para este tipo de maquina
la curva de programacion manual si la tiene y por ultimo se obtienen las constantes de 
la curva.
----------------------------------------------------------------------------------------- */

uo_dsbase lds_tipomaquina, lds_turnos, lds_curva, lds_curva_manual, lds_maquinas, lds_cuota_mod_ref
Long ll_filas
s_base_parametros lsp_parametros

If IsNull(co_tipo_maquina) Then
	// Se Trae el tipo de maquina
	lds_tipomaquina = create uo_dsbase
	lds_tipomaquina.DataObject = "d_gr_maquinas_parametro"
	lds_tipomaquina.SetTransObject(itr_transaccion)
	ll_filas = lds_tipomaquina.Retrieve (co_fabrica, co_planta, co_centro, co_subcentro, co_tipo_negocio, co_maquina)
	// se valida errores
	Choose Case ll_filas
		Case IS < 0
			lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
			lsp_parametros.Cadena[2] = 'Planta'
			lsp_parametros.Cadena[3] = 'Centro'
			lsp_parametros.Cadena[4] = 'Subcen.'
			lsp_parametros.Cadena[5] = 'Tipo Neg'
			lsp_parametros.Cadena[6] = 'Mod/Maq'
			
			lsp_parametros.Any[1] = co_fabrica
			lsp_parametros.Any[2] = co_planta
			lsp_parametros.Any[3] = co_centro
			lsp_parametros.Any[4] = co_subcentro
			lsp_parametros.Any[5] = co_tipo_negocio
			lsp_parametros.Any[6] = co_maquina
			
			of_mensaje("Error","Error al leer la base de datos", lsp_parametros, '')
			
			Destroy (lds_tipomaquina)
			Return -1
		Case 0
			lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
			lsp_parametros.Cadena[2] = 'Planta'
			lsp_parametros.Cadena[3] = 'Centro'
			lsp_parametros.Cadena[4] = 'Subcen.'
			lsp_parametros.Cadena[5] = 'Tipo Neg'
			lsp_parametros.Cadena[6] = 'Mod/Maq'
			
			lsp_parametros.Any[1] = co_fabrica
			lsp_parametros.Any[2] = co_planta
			lsp_parametros.Any[3] = co_centro
			lsp_parametros.Any[4] = co_subcentro
			lsp_parametros.Any[5] = co_tipo_negocio
			lsp_parametros.Any[6] = co_maquina
			
			of_mensaje("No hay datos","No hay datos relacionados con el tipo de modulo/maquina", lsp_parametros, '')
			
			Destroy (lds_tipomaquina)
			Return -2
		Case else
			// se cargan el tipo de maquina
			co_tipo_maquina = lds_tipomaquina.GetItemNumber(1,'co_tipo_maquina')
			Destroy (lds_tipomaquina)
	End Choose
End If	
ids_turnos.SetFilter ('co_fabrica = ' + String(co_fabrica) + ' AND co_planta = ' + String(co_planta) &
					+ ' AND co_tipo_negocio = ' + String(co_tipo_negocio) + ' AND co_centro_pdn =' + String(co_centro) &
					+ ' AND co_subcentro_pdn = ' + String(co_subcentro) + ' AND co_tipo_maquina = ' + String (co_tipo_maquina) )
ids_turnos.Filter()

If ids_turnos.RowCount() = 0 Then
	lds_turnos = create uo_dsbase
	lds_turnos.DataObject = "d_gr_turnos"
	lds_turnos.SetTransObject(itr_transaccion)
	// se trae la informacion de los turnos										 
	ll_filas = lds_turnos.Retrieve(co_fabrica, co_planta, co_centro, co_subcentro, co_tipo_negocio, co_tipo_maquina)
	// se valida errores
	Choose Case ll_filas
		Case IS < 0
			lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
			lsp_parametros.Cadena[2] = 'Planta'
			lsp_parametros.Cadena[3] = 'Centro'
			lsp_parametros.Cadena[4] = 'Subcen.'
			lsp_parametros.Cadena[5] = 'Tipo Neg'
			lsp_parametros.Cadena[6] = 'Tipo Mod/Maq'
			
			lsp_parametros.Any[1] = co_fabrica
			lsp_parametros.Any[2] = co_planta
			lsp_parametros.Any[3] = co_centro
			lsp_parametros.Any[4] = co_subcentro
			lsp_parametros.Any[5] = co_tipo_negocio
			lsp_parametros.Any[6] = co_tipo_maquina
			
			Of_mensaje ("Error","Error al leer la base de datos", lsp_parametros, "")
			Destroy(lds_turnos)
			Return -3
		Case 0
			lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
			lsp_parametros.Cadena[2] = 'Planta'
			lsp_parametros.Cadena[3] = 'Centro'
			lsp_parametros.Cadena[4] = 'Subcen.'
			lsp_parametros.Cadena[5] = 'Tipo Neg'
			lsp_parametros.Cadena[6] = 'Tipo Mod/Maq'
			
			lsp_parametros.Any[1] = co_fabrica
			lsp_parametros.Any[2] = co_planta
			lsp_parametros.Any[3] = co_centro
			lsp_parametros.Any[4] = co_subcentro
			lsp_parametros.Any[5] = co_tipo_negocio
			lsp_parametros.Any[6] = co_tipo_maquina
			
			Of_mensaje ("No hay datos","No hay datos del turno", lsp_parametros, "")
			Destroy(lds_turnos)
			Return -4
		Case else
			lds_turnos.RowsCopy( 1, 1, Primary!, ids_turnos, ids_turnos.RowCount() + 1, Primary! )
			Destroy(lds_turnos)
	End Choose	
End If

// se cargan los datos del turno del tipo de maquina
no_personas = ids_turnos.GetItemNumber(1,"nu_pers_maquina")
min_turno= ids_turnos.GetItemNumber(1,"minutos_turno")
turnos	= ids_turnos.GetItemNumber(1,"turnos")	

// Se verifica la configuracion de turnos de la maquina
ids_maquinas.SetFilter('co_fabrica = ' + String(co_fabrica) + ' AND co_planta = ' + String(co_planta) &
					+ ' AND co_tipo_negocio = ' + String(co_tipo_negocio) + ' AND co_centro_pdn =' + String(co_centro) &
					+ ' AND co_subcentro_pdn = ' + String(co_subcentro) + ' AND co_maquina = ' + String (co_maquina) )
ids_maquinas.Filter()
If ids_maquinas.RowCount() = 0 Then
	lds_maquinas = Create uo_dsbase
	lds_maquinas.DataObject = ids_maquinas.DataObject
	lds_maquinas.SetTransObject(itr_transaccion)		
	ll_filas = lds_maquinas.Of_Retrieve( co_fabrica, co_planta, co_centro, co_subcentro, co_tipo_negocio)
	
	If ll_filas > 0 Then
		lds_maquinas.RowsCopy( 1, lds_maquinas.RowCount(), Primary!, ids_maquinas, 1, Primary!)
		ids_maquinas.Filter()
	ElseIf ll_filas < 0 Then
		lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
		lsp_parametros.Cadena[2] = 'Planta'
		lsp_parametros.Cadena[3] = 'Centro'
		lsp_parametros.Cadena[4] = 'Subcentro'
		lsp_parametros.Cadena[5] = 'Tipo Neg'
		
		lsp_parametros.Any[1] = co_fabrica
		lsp_parametros.Any[2] = co_planta
		lsp_parametros.Any[3] = co_centro
		lsp_parametros.Any[4] = co_subcentro
		lsp_parametros.Any[5] = co_tipo_negocio
		of_mensaje("Error","Error al leer los recursos de la base de datos.", lsp_parametros, "" )
		Destroy(lds_maquinas)
		Return -1
		
	End If
	Destroy lds_maquinas
End If

If ids_maquinas.RowCount() > 0 Then
	// Si tiene ingresado el numero de personas se toman los parametros de la maquina
	If ids_maquinas.GetItemNumber(1,"nu_pers_maquina") > 0 Then
		no_personas = ids_maquinas.GetItemNumber(1,"nu_pers_maquina")
		min_turno= ids_maquinas.GetItemNumber(1,"minutos_turno")
		turnos	= ids_maquinas.GetItemNumber(1,"turnos")	
	End If	
	
	//se carga la cuota diaria del modulo
	idc_cuota_diaria_maquina = ids_maquinas.GetItemDecimal(1,'cuota_diaria')
	If Isnull(idc_cuota_diaria_maquina) Then idc_cuota_diaria_maquina = 0
End If

/**********/
// Se verifica la cuota por modulo referencia
ids_cuota_maq_ref.SetFilter('co_maquina = ' + String(co_maquina))
ids_cuota_maq_ref.Filter()
If ids_cuota_maq_ref.RowCount() = 0 Then
	lds_cuota_mod_ref = Create uo_dsbase
	lds_cuota_mod_ref.DataObject = ids_cuota_maq_ref.DataObject
	lds_cuota_mod_ref.SetTransObject(itr_transaccion)		
	ll_filas = lds_cuota_mod_ref.Of_Retrieve( co_maquina)
	
	If ll_filas > 0 Then
		lds_cuota_mod_ref.RowsCopy( 1, lds_cuota_mod_ref.RowCount(), Primary!, ids_cuota_maq_ref, 1, Primary!)
		ids_cuota_maq_ref.Filter()
	ElseIf ll_filas = 0 Then
		ll_filas = ids_cuota_maq_ref.InsertRow(0)
		ids_cuota_maq_ref.SetItem(ll_filas,'co_maquina',co_maquina)
		ids_cuota_maq_ref.SetItem(ll_filas,'co_referencia','')
		ids_cuota_maq_ref.SetItem(ll_filas,'cuota_diaria',0)
		ids_cuota_maq_ref.Filter()
	ElseIf ll_filas < 0 Then
		lsp_parametros.Cadena[1] = 'Recurso'
		lsp_parametros.Any[1] = co_maquina
		of_mensaje("Error","Error al leer los recursos de la base de datos.", lsp_parametros, "" )
		Destroy(lds_cuota_mod_ref)
		Return -1
		
	End If
	Destroy lds_cuota_mod_ref
End If

If ids_cuota_maq_ref.RowCount() > 0 Then
	ll_filas = ids_cuota_maq_ref.Find("co_referencia = '" + trim(is_referencia) +"'" , &
	        		1, ids_cuota_maq_ref.RowCount() + 1)
	If ll_filas > 0 Then
		//se carga la cuota diaria del modulo ref
		idc_cuota_diaria_maq_ref = ids_cuota_maq_ref.GetItemDecimal(ll_filas,'cuota_diaria')
		If Isnull(idc_cuota_diaria_maq_ref) Then idc_cuota_diaria_maq_ref = 0
	ElseIf ll_filas = 0 Then
		//como no encuentra la referencia, la cuota es cero
		idc_cuota_diaria_maq_ref = 0
	ElseIf ll_filas < 0 Then
		lsp_parametros.Cadena[1] = 'Recurso'
		lsp_parametros.Cadena[2] = 'Referencia'
		lsp_parametros.Any[1] = co_maquina
		lsp_parametros.Any[2] = is_referencia
		of_mensaje("Error","Error al buscar la referencia en los recursos para la cuota diaria.", lsp_parametros, "" )
		Return -1
	End If
End If
/*********/


If sw_curva > 0 Then
	ids_curvas_manuales.SetFilter('co_curva_manual = ' + String( sw_curva) )		
	ids_curvas_manuales.Filter()
	ids_curvas_manuales.SetSort('dia')
	ids_curvas_manuales.Sort()
	
	If ids_curvas_manuales.RowCount() = 0 Then
		lds_curva_manual = Create uo_dsbase
		lds_curva_manual.DataObject = 'd_gr_curvas_manuales_pdp'
		lds_curva_manual.SetTransObject(itr_transaccion)		
		ll_filas = lds_curva_manual.Retrieve (co_fabrica, co_planta, co_centro, co_subcentro, co_tipo_negocio)				
		Choose Case ll_filas 
			Case Is < 0 
				lsp_parametros.Cadena[1] = 'sw_curva'
				lsp_parametros.Any[1] = sw_curva
				of_mensaje("Error","Error al leer la base de datos.", lsp_parametros, "" )
				Destroy(lds_curva_manual)
				Return -5
			Case 0
				lsp_parametros.Cadena[1] = 'sw_curva'
				lsp_parametros.Any[1] = sw_curva
				Of_mensaje("No hay datos","No hay datos relacionados con la programacion manual", lsp_parametros, "" )
				Destroy(lds_curva_manual)
				Return -6
			Case Else
				lds_curva_manual.RowsCopy( 1, ll_filas, Primary!, ids_curvas_manuales, ids_curvas_manuales.RowCount() + 1, Primary!)
				ids_curvas_manuales.SetFilter('co_curva_manual = ' + String( sw_curva) )		
				ids_curvas_manuales.Filter()
				If ids_curvas_manuales.RowCount() = 0 Then
					lsp_parametros.Cadena[1] = 'sw_curva'
					lsp_parametros.Any[1] = sw_curva
					Of_mensaje("No hay datos","No hay datos relacionados con la programacion manual", lsp_parametros, "" )
				End If
				Destroy (lds_curva_manual)
		End Choose
	End If
Else
	ids_curvas_manuales.SetFilter( 'co_curva_manual < 0' )		
	ids_curvas_manuales.Filter()
End IF

SetNull(idc_a)
// si la curva es nula no se carga
If IsNull (co_curva) Then Return 1

// se cargan los datos de la curva
ids_curvas.SetTransObject(itr_transaccion)
ids_curvas.SetFilter ('co_curva = ' + String(co_curva))
ids_curvas.Filter ()

If ids_curvas.RowCount() = 0 Then	
	lds_curva = Create uo_dsbase
	lds_curva.DataObject = "d_gr_curva"
	lds_curva.SetTransObject(itr_transaccion)
	// se valida errores
	Choose Case lds_curva.Retrieve(co_curva, co_fabrica, co_planta)
		Case IS < 0
			lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
			lsp_parametros.Cadena[2] = 'Planta'
			lsp_parametros.Cadena[3] = 'co_curva'

			lsp_parametros.Any[1] = co_fabrica
			lsp_parametros.Any[2] = co_planta			
			lsp_parametros.Any[3] = co_curva
			
			Of_mensaje("Error","Error al leer la base de datos.", lsp_parametros, "")
			Destroy(lds_curva)
			Return -5
		Case 0
			lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
			lsp_parametros.Cadena[2] = 'Planta'
			lsp_parametros.Cadena[3] = 'co_curva'

			lsp_parametros.Any[1] = co_fabrica
			lsp_parametros.Any[2] = co_planta			
			lsp_parametros.Any[3] = co_curva
			Of_mensaje("No hay datos","No hay datos relacionados con la curva.", lsp_parametros, "" )
			Destroy(lds_curva)
			Return -6
		Case else
			lds_curva.RowsCopy( 1, lds_curva.RowCount(), Primary!, ids_curvas, ids_curvas.RowCount() + 1, Primary!)
			Destroy(lds_curva)
			
			ids_curvas.Filter ()
			If ids_curvas.RowCount() = 0  Then
				lsp_parametros.Cadena[1] = 'F$$HEX1$$e100$$ENDHEX$$brica'
				lsp_parametros.Cadena[2] = 'Planta'
				lsp_parametros.Cadena[3] = 'co_curva'
	
				lsp_parametros.Any[1] = co_fabrica
				lsp_parametros.Any[2] = co_planta			
				lsp_parametros.Any[3] = co_curva
				Of_mensaje("No hay datos","No hay datos relacionados con la curva.", lsp_parametros, "" )
				Destroy(lds_curva)
				Return -7
			End If

	End Choose
End If
// se cargan los parametros de la curva
idc_a = ids_curvas.GetItemNumber(1,'a')
idc_b = ids_curvas.GetItemNumber(1,'b')
dia_estabilidad = ids_curvas.GetItemNumber(1,'dia_estabilidad')

Return 1
end function

public function long of_set_calendario_fabrica ();/* -----------------------------------------------------------------------------------------
Funci$$HEX1$$f300$$ENDHEX$$n para cargar el Calendario con el c$$HEX1$$f300$$ENDHEX$$digo co_calendario
----------------------------------------------------------------------------------------- */
uo_dsbase lds_calendario
Long ll_row
ids_calendario_fabrica.SetTransObject(itr_transaccion)

ids_calendario_fabrica.SetFilter('co_calendario = ' + String (co_calendario))
ids_calendario_fabrica.Filter()
If ids_calendario_fabrica.RowCount() = 0 Then
	lds_calendario = Create uo_dsbase
	lds_calendario.DataObject = ids_calendario_fabrica.DataObject
	lds_calendario.SetTransObject(itr_transaccion)
	ll_row = lds_calendario.Of_Retrieve(co_calendario)
	Choose Case ll_row
		Case Is > 0
			lds_calendario.RowsCopy( 1, lds_calendario.Rowcount(), Primary!, ids_calendario_fabrica, &
											ids_calendario_fabrica.RowCount() + 1, Primary! )
			Destroy (lds_calendario)
		Case 0
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No Existe el calendario de Fabrica con codigo ' + String (co_calendario))
			co_calendario = -1
			Destroy (lds_calendario)
			Return -1
		Case Is < 0
			ROLLBACK;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error en la base de datos al cargar el calendario')
			Destroy (lds_calendario)
			co_calendario = -1
			Return -2
	End Choose				
End IF

ids_calendario_fabrica.SetSort('fe_calendario ASC')
ids_calendario_fabrica.Sort( )
Return 1

	


end function

public function long of_set_calendario_maquina ();/* -----------------------------------------------------------------------------------------
Funci$$HEX1$$f300$$ENDHEX$$n para cargar el Calendario de Novedades por Maquina cruzado con el 
calendario de F$$HEX1$$e100$$ENDHEX$$brica
----------------------------------------------------------------------------------------- */
uo_dsbase lds_calendario
Long ll_row, ll_fila, ll_new
Boolean lb_bandera

If co_maquina_cal = co_maquina Then
	ids_calendario_maquina.SetSort('fe_calendario ASC')
	ids_calendario_maquina.Sort( )
	Return 1	
Else
	co_maquina_cal = co_maquina
End If

// Se busca si el calendario ya esta cargado en el datastore del cruce de las tablas
ids_calendario_maquina.SetFilter('co_fabrica = ' + String(co_fabrica) + ' AND co_planta = ' + String(co_planta) &
					+ ' AND co_tipo_negocio = ' + String(co_tipo_negocio) + ' AND co_centro_pdn =' + String(co_centro) &
					+ ' AND co_subcentro_pdn = ' + String(co_subcentro) + ' AND co_simulacion = ' + String (simulacion) &
					+ ' AND co_maquina = ' + String (co_maquina))
ids_calendario_maquina.Filter()

// si encuentra registros sale de la funcion
If ids_calendario_maquina.RowCount() > 0 Then	
	ids_calendario_maquina.SetSort('fe_calendario ASC')
	ids_calendario_maquina.Sort( )
	Return 1
End If

ids_calendario_novedad.SetTransObject(itr_transaccion)

// se busca si ya se trajo el calendario de maquina
ids_calendario_novedad.SetFilter('co_fabrica = ' + String(co_fabrica) + ' AND co_planta = ' + String(co_planta) &
					+ ' AND co_tipo_negocio = ' + String(co_tipo_negocio) + ' AND co_centro_pdn =' + String(co_centro) &
					+ ' AND co_subcentro_pdn = ' + String(co_subcentro) + ' AND co_simulacion = ' + String (simulacion) &
					+ ' AND co_maquina = ' + String (co_maquina))
ids_calendario_novedad.Filter()
// si no se ha cargado se va a la BD
If ids_calendario_novedad.RowCount() = 0 Then
	
	If IsNull(co_calendario) Or IsNull(co_fabrica_cal) Or co_fabrica_cal <> co_fabrica Then
		// se obtiene el codigo del calendario de fabrica
		co_calendario = This.of_calendario_fabrica( co_fabrica )
		If co_calendario < 0 Then
			Return -1
		End If
		co_fabrica_cal = co_fabrica
				// se carga el calendario de fabrica
		If This.of_set_calendario_fabrica( ) < 0 Then
			Return -1
		End If
	End If
	
	// se carga el calendario de novedades de maquina
	lds_calendario = Create uo_dsbase
	lds_calendario.DataObject = ids_calendario_novedad.DataObject
	lds_calendario.SetTransObject(itr_transaccion)
	ll_row = lds_calendario.Of_Retrieve( co_fabrica, co_planta, co_tipo_negocio, co_centro, co_subcentro, co_maquina, simulacion )
	Choose Case ll_row
		Case Is > 0
			// se copia al datastore de todos las novedades de maquina
			lds_calendario.RowsCopy( 1, lds_calendario.Rowcount(), Primary!, ids_calendario_novedad, &
											ids_calendario_novedad.RowCount() + 1, Primary! )
			Destroy (lds_calendario)
		Case 0
			// si no tiene registros se ingresa uno con los mismos datos del calendario de fabrica
			// para no volver a cargar
			ids_calendario_novedad.InsertRow(0)
			ids_calendario_novedad.SetItem(1, 'fe_calendario', ids_calendario_fabrica.GetItemDate(1, 'fe_calendario'))
			ids_calendario_novedad.SetItem(1, 'tipo_novedad', ids_calendario_fabrica.GetItemString(1, 'sw_festivo'))
			ids_calendario_novedad.SetItem(1, 'co_fabrica', co_fabrica)	
			ids_calendario_novedad.SetItem(1, 'co_planta', co_planta)
			ids_calendario_novedad.SetItem(1, 'co_tipo_negocio', co_tipo_negocio)
			ids_calendario_novedad.SetItem(1, 'co_centro_pdn', co_centro)
			ids_calendario_novedad.SetItem(1, 'co_subcentro_pdn', co_subcentro)
			ids_calendario_novedad.SetItem(1, 'co_simulacion', simulacion)
			ids_calendario_novedad.SetItem(1, 'co_maquina', co_maquina)
			Destroy (lds_calendario)			
		Case Is < 0
			// error en la base de datos
			ROLLBACK;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error en la base de datos al cargar el calendario')
			Destroy (lds_calendario)
			Return -2
	End Choose				
End IF
// se ordenan las fechas
ids_calendario_novedad.SetSort('fe_calendario ASC')
ids_calendario_novedad.Sort( )
ids_calendario_fabrica.SetSort('fe_calendario ASC')
ids_calendario_fabrica.Sort( )

// se limpia el datastore con el join
ids_calendario_maquina.Reset( )


ll_fila = 1
// se realiza el join del calendario de fabrica y las novedades del maquina
For ll_row = 1 To ids_calendario_fabrica.RowCount()
	lb_bandera = True
	If ids_calendario_novedad.RowCount() >= ll_fila Then
		// si en esa fecha hay una novedad se pone la novedad
		If ids_calendario_fabrica.GetItemDate(ll_row, 'fe_calendario') = ids_calendario_novedad.GetItemDate(ll_fila, 'fe_calendario') Then
			ids_calendario_novedad.RowsCopy( ll_fila, ll_fila, Primary!, ids_calendario_maquina, ids_calendario_maquina.RowCount() + 1, Primary!)
			lb_bandera = False
			ll_fila ++
		End IF		
	End IF
	// se pone el calendario de fabrica
	If lb_bandera Then
		ll_new = ids_calendario_maquina.InsertRow(0)
		ids_calendario_maquina.SetItem( ll_new, 'fe_calendario', ids_calendario_fabrica.GetItemDate(ll_row, 'fe_calendario'))
		ids_calendario_maquina.SetItem( ll_new, 'tipo_novedad', ids_calendario_fabrica.GetItemString(ll_row, 'sw_festivo'))
		ids_calendario_maquina.SetItem( ll_new, 'co_fabrica', co_fabrica)	
		ids_calendario_maquina.SetItem( ll_new, 'co_planta', co_planta)
		ids_calendario_maquina.SetItem( ll_new, 'co_tipo_negocio', co_tipo_negocio)
		ids_calendario_maquina.SetItem( ll_new, 'co_centro_pdn', co_centro)
		ids_calendario_maquina.SetItem( ll_new, 'co_subcentro_pdn', co_subcentro)
		ids_calendario_maquina.SetItem( ll_new, 'co_simulacion', simulacion)
		ids_calendario_maquina.SetItem( ll_new, 'co_maquina', co_maquina)
	End If
Next
Return 1

end function

public function boolean of_festivo (long ai_calendario, date ad_fecha);/* -----------------------------------------------------------------------------------------
Evalua si la fecha es festivo.
Se consulta en el calendario de fabrica y si es festivo retorna verdadero
----------------------------------------------------------------------------------------- */
Boolean lb_festivo
Long ll_row

SetNull(lb_festivo)

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_set_calendario_fabrica( ) < 0 Then Return lb_festivo
	
// Se consulta si el dia es festivo
ll_row = ids_calendario_fabrica.Find( 'fe_calendario = ' + String(ad_fecha, 'yyyy-mm-dd'), 1, ids_calendario_fabrica.RowCount() + 1)


lb_festivo = False
// si la fecha existe
If ll_row > 0 Then
	// Se pregunta si es festivo (I)
	If ids_calendario_fabrica.GetItemString(ll_row,"sw_festivo") = 'I' Then
		lb_festivo = True
	End If
End If

Return lb_festivo

end function

public function date of_diasantes_x_modulo (date ad_fecha_inicio, long ai_dias);/* -----------------------------------------------------------------------------------------
Esta funci$$HEX1$$f300$$ENDHEX$$n obtiene la fecha anterior restandole ai_dias h$$HEX1$$e100$$ENDHEX$$biles a dicha fecha, este valor 
cuenta desde el propio dia de fecha de inicio.
----------------------------------------------------------------------------------------- */

Long ll_row
Long li_dias
String ls_expresion
Date ld_retorno
// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return date('1000-01-01') //error al consultar la base de datos
End If
// se filtran las fechas anteriores a la que ingresan
ids_calendario_maquina.SetFilter('fe_calendario <= ' + String(ad_fecha_inicio, 'yyyy-mm-dd'))
ids_calendario_maquina.Filter()

ll_row = ids_calendario_maquina.Find( 'fe_calendario = ' + String(ad_fecha_inicio, 'yyyy-mm-dd'), 1, ids_calendario_maquina.RowCount() + 1)
// si encuentra la fecha
If ll_row > 0 Then
	If ai_dias = 0 Then
		Return ids_calendario_fabrica.GetItemDate(ll_row,"fe_calendario")
	End IF
	li_dias = 0
	Do While li_dias < ai_dias And ll_row > 0
		// si es dia normal, jornada especial  y festivo laboral
		// se incrementan los dias
		Choose Case ids_calendario_maquina.GetItemString(ll_row,"tipo_novedad")
			Case 'A', 'L', 'J'
				li_dias ++
		End Choose
		ll_row --
	Loop
	ll_row ++
	// Se Retorna la fecha del calendario
	Return ids_calendario_maquina.GetItemDate(ll_row,"fe_calendario")
Else
	// si no la encuentra 
	Return date('1000-01-02') // la fecha no existe en el calendario
End If

end function

public function date of_diasdespues_x_modulo (date ad_fecha_inicio, long ai_dias);/* -----------------------------------------------------------------------------------------
Esta funci$$HEX1$$f300$$ENDHEX$$n obtiene la fecha posterior sumandole ai_dias h$$HEX1$$e100$$ENDHEX$$biles a dicha fecha, este valor 
cuenta desde el propio dia de fecha de inicio.
----------------------------------------------------------------------------------------- */

Long ll_row
Long li_dias
String ls_expresion
Date ld_retorno
// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return date('1000-01-01') //error al consultar la base de datos
End If
// se filtran las fechas posteriores a la fecha actual
ids_calendario_maquina.SetFilter('fe_calendario >= ' + String(ad_fecha_inicio, 'yyyy-mm-dd'))
ids_calendario_maquina.Filter()

ll_row = ids_calendario_maquina.Find( 'fe_calendario = ' + String(ad_fecha_inicio, 'yyyy-mm-dd'), 1, ids_calendario_maquina.RowCount() + 1)
// si encuentra la fecha
If ll_row > 0 Then
	If ai_dias = 0 Then
		Return ids_calendario_fabrica.GetItemDate(ll_row,"fe_calendario")
	End IF
	li_dias = 0
	Do While li_dias < ai_dias And ids_calendario_maquina.RowCount() >= ll_row
		// si es dia normal, jornada especial  y festivo laboral
		// se incrementan los dias
		Choose Case ids_calendario_maquina.GetItemString(ll_row,"tipo_novedad")
			Case 'A', 'L', 'J'
				li_dias ++
		End Choose
		ll_row ++
	Loop
	ll_row --
	// Se Retorna la fecha del calendario
	Return ids_calendario_maquina.GetItemDate(ll_row,"fe_calendario")
Else
	// si no la encuentra 
	Return date('1000-01-02') // la fecha no existe en el calendario
End If

end function

public function long of_nodiaslaborales_x_modulo (date ad_fecha_inicio, date ad_fecha_fin);/* -----------------------------------------------------------------------------------------
Esta Funci$$HEX1$$f300$$ENDHEX$$n Retorna el n$$HEX1$$fa00$$ENDHEX$$mero de d$$HEX1$$ed00$$ENDHEX$$as laborales entre un
rango de fechas contando el dia que termina.
----------------------------------------------------------------------------------------- */

Long ll_row
Long li_dias
String ls_expresion
Date ld_retorno

If ad_fecha_inicio > ad_fecha_fin Then Return 0

// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return -1 //error al consultar la base de datos
End If

If of_fechaexiste( co_calendario, ad_fecha_inicio) < 0 Or of_fechaexiste( co_calendario, ad_fecha_fin)<0 Then
	// alguna o ambas de las fechas  no existe en el calendario
	Return -2
End If
// se filtran las fechas entre las fechas recibidas como parametro
ids_calendario_maquina.SetFilter('fe_calendario BETWEEN ' + String(ad_fecha_inicio, 'yyyy-mm-dd') + &
											' AND ' + String(ad_fecha_fin, 'yyyy-mm-dd') )
ids_calendario_maquina.Filter()

For ll_row = 1 to ids_calendario_maquina.RowCount()
	// si es dia normal, jornada especial  y festivo laboral
	// se incrementan los dias
	Choose Case ids_calendario_maquina.GetItemString(ll_row,"tipo_novedad")
		Case 'A', 'L', 'J'
			li_dias ++
	End Choose
Next
// Se retorna el numero de dias
Return li_dias
end function

public function decimal of_calcularminuto (datetime adtm_fecha);/* -----------------------------------------------------------------------------------------
Obtiene los minutos escalados en la hora.

Se trae la informacion del dia, luego se calcula los minutos del dia dependiendo 
de los turnos y minutos del calendario del maquina, por ultimo se escalan los
minutos para la hora en adtm_fecha.

Ejemplos de escala de minutos: 
- Si son 400 minutos laborable en el dia y se trabajan 200 minutos la hora se escala
	 y quedaria a las 12:00.
- Si son 400 minutos laborable en el dia y se trabajan 100 minutos la hora se escala
	 y quedaria a las 6:00.
----------------------------------------------------------------------------------------- */

Long ll_turnos_j, ll_min_turno_j, ll_no_personas_j
Long ll_row
Decimal ldc_min_disp
Date ld_fecha
Time ltm_hora
String ls_tipo_novedad

// Se cargan la informacion de los turnos y la curva
If This.of_cargar_datos( ) < 0 Then Return -1

// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return -2 //error al consultar la base de datos
End If

// Se toman la fecha
ld_fecha = Date(adtm_fecha)
// se valida que la fecha este definida en el calendario
If of_fechaexiste( co_calendario, ld_fecha) < 0 Then
	// alguna o ambas de las fechas  no existe en el calendario
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ld_fecha) + "' no esta definida dentro del calendario")
	Return -3
End If

// se filtran las fechas entre las fechas recibidas como parametro
ids_calendario_maquina.SetFilter('')
ids_calendario_maquina.Filter()

ll_row = ids_calendario_maquina.Find('fe_calendario = ' + String(ld_fecha, 'yyyy-mm-dd'), 1, ids_calendario_maquina.RowCount() + 1)
ldc_min_disp = 0
// se toma el tipo de novedad
ls_tipo_novedad = ids_calendario_maquina.GetItemString(ll_row,'tipo_novedad')
Choose Case ls_tipo_novedad
	Case 'J'				
		// Jornada Especial
		// se toman los datos de la jornada especial
		ll_turnos_j = ids_calendario_maquina.GetItemNumber(ll_row,'turnos')
		ll_min_turno_j = ids_calendario_maquina.GetItemNumber(ll_row,'min_turnos')					
		ldc_min_disp = ll_turnos_j * ll_min_turno_j 		
	Case 'A', 'L'
		// Dia  Sin Modificaciones o Festivo Laboral
		ldc_min_disp = turnos * min_turno 
	Case Else // 'I','V','C' Festivos, Vacaciones y Compensatorios
		ldc_min_disp = 0	
End Choose	
// Si es el primer dia se escalan los minutos disponibles en base a la hora
ltm_hora = Time(adtm_fecha)
// se escala el minuto
ldc_min_disp = Round(ldc_min_disp * (SecondsAfter(Time(0), ltm_hora) / ( 24 * 60 * 60)), 0)
// se retorna el minuto disponible
Return ldc_min_disp






end function

public function long of_fechaexiste (long ai_calendario, date ad_fecha);/* -----------------------------------------------------------------------------------------
Esta Funcion mira si la fecha existe en el calendario
----------------------------------------------------------------------------------------- */
Long ll_row

// Si el calentario no se ha cargado
If co_calendario = ai_calendario Then
Else
	// Se toma el codigo del calendario
	co_calendario = ai_calendario
	// se carga el calendario de fabrica
	If This.of_Set_Calendario_Fabrica( ) < 0 Then Return -1
End If

ids_calendario_fabrica.SetFilter('')
ids_calendario_fabrica.Filter()
// Se consulta una fecha en el calendario
ll_row = ids_calendario_fabrica.Find( 'fe_calendario = ' + String(ad_fecha, 'yyyy-mm-dd'), 1, ids_calendario_fabrica.RowCount() + 1)
// si la encontro retorna 1 en caso contrario 0
If ll_row > 0 Then
	Return ll_row
Else
	Return -1
End If

end function

public function long of_calcular_fecha (ref datetime adtm_fecha_ini, ref datetime adtm_fecha_fin, character ac_sentido, decimal adc_estandar, decimal adc_cantidad, long ai_dias_de_continuidad);/* -------------------------------------------------------------------------------------
	Convierte las unidades en fechas(minutos), recibe por referencia la fecha de incio y fin,
	si el sentido(ac_sentido) es igual a I (desde el inicio) se modifica la fecha de fin,
	si el sentido(ac_sentido) es igual a F (desde el fin) se modifican las dos fechas, dado que
	la funcion para calcular la fecha de inicio exacta para la fecha y hora harian una funcion demasiado
	lenta, se valida que la dia de la fecha de fin no sea mayor, y se ajusta la fecha de inicio hasta que
	se cumpla dicha condicion.
	
	Parametros del maquina: co_fabrica, co_planta, co_centro, co_subcentro, co_tipo_negocio, co_maquina
	Parametro para determinar la simulacion: co_simulacion
	Parametro del estandar de la referencia: adc_estandar, adc_cantidad
	Dias que lleva acumulado en la curva: ai_dias_continuidad
	Curva a la cual pertence: co_curva	
	
	Ejemplos de escala de minutos: 
	- Si son 400 minutos laborable en el dia y se trabajan 200 minutos la hora se escala
		 y quedaria a las 12:00.
	- Si son 400 minutos laborable en el dia y se trabajan 100 minutos la hora se escala
		 y quedaria a las 6:00.
	--------------------------------------------------------------------------------------------- */

Long li_dias, li_filas, li_i
Long ll_turnos_j, ll_min_turno_j, ll_no_personas_j
Long ll_dia, ll_segundos_dia
Decimal ldc_unidades_prod, ldc_min_disp, ldc_min_totales, ldc_min_totales_normales, ldc_unidades
String ls_tipo_novedad
Date ld_fecha1, ld_fecha2
DateTime ldtm_fecha_ini, ldtm_fecha_fin
Time ltm_hora1, ltm_hora2

// Se inicializa los minutos consumidos en 0
minutos_totales = 0
eficiencia = 0
// Se valida el valor del estandar
If adc_estandar <= 0 Or isNull(adc_estandar) Then	Return -1

If IsNull(ai_dias_de_continuidad) Then 
	MessageBox('Faltan Parametros', 'Falta los dias de continuidad')
	Return -3
End If

//si la curva es manual no debe tener en cuenta los d$$HEX1$$ed00$$ENDHEX$$as de continuidad
dias_de_continuidad = ai_dias_de_continuidad

If adc_cantidad < 0 Then
	RETURN -8	
ElseIf adc_cantidad = 0 Then
	adtm_fecha_fin = adtm_fecha_ini
	minutos_totales = 0
	minuto_laboral_ini = 0
	minuto_laboral_fin = 0
	RETURN 0
End IF

// Se cargan la informacion de los turnos y la curva
If This.Of_Cargar_Datos( ) < 0 Then Return -2

// se inicializa las constantes de la curva, los dias de continuidad y las unidades
invo_curva.Of_SetConstantes( idc_a, idc_b)


// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return -4 //error al consultar la base de datos
End If

// Se toman las fechas y se inicializan las unidades_prod en 0
ld_fecha1 = Date(adtm_fecha_ini)
ltm_hora1 = Time(adtm_fecha_ini)
ld_fecha2 = Date(adtm_fecha_fin)
ltm_hora2 = Time(adtm_fecha_fin)
ldc_unidades_prod = 0
ldc_unidades = 0

// se calcula el numero total de minutos de la jornada normal
ldc_min_totales_normales = turnos * min_turno * no_personas
// Segundos por d$$HEX1$$ed00$$ENDHEX$$a
ll_segundos_dia = 24 * 60 * 60

// se inicializa las unidades a producir
ldc_unidades = adc_cantidad

// Si se calcula desde la fecha de inicio
If ac_sentido = 'I' Then
	// se valida que la fecha este definida en el calendario
	If of_fechaexiste( co_calendario, ld_fecha1) < 0 Then
		// alguna o ambas de las fechas  no existe en el calendario
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ld_fecha1) + "' no esta definida dentro del calendario")
		Return -5
	End If
	
	// se filtran las fechas entre las fechas recibidas como parametro
	ids_calendario_maquina.SetFilter('fe_calendario >= ' + String(ld_fecha1, 'yyyy-mm-dd'))
	ids_calendario_maquina.Filter()	
	
	// se organiza ascendentemente
	ids_calendario_maquina.SetSort('fe_calendario ASC')
	ids_calendario_maquina.Sort( )
	
	li_filas = ids_calendario_maquina.RowCount()	
	// se traen los datos de las fechas desde la fecha ld_fecha1

	// se inicializan lo minutos en cero
	minutos_totales = 0
	minuto_laboral_ini = 0
	minuto_laboral_fin = 0
	// Se hace el ciclo mientras no se hayan producidos las unidades o se acaben los 
	For li_i = 1 To li_filas	
		ldc_min_disp = 0	
		ldc_unidades_prod = 0
		// se toma el tipo de novedad
		ls_tipo_novedad = ids_calendario_maquina.GetItemString(li_i,'tipo_novedad')		
		Choose Case ls_tipo_novedad
			Case 'J'				
				// Jornada Especial
				// se toman los datos de la jornada especial
				ll_turnos_j = ids_calendario_maquina.GetItemNumber(li_i,'turnos')
				ll_min_turno_j = ids_calendario_maquina.GetItemNumber(li_i,'min_turnos')			
				ll_no_personas_j = ids_calendario_maquina.GetItemNumber(li_i,'no_personas')				
				ldc_min_totales = ll_turnos_j * ll_min_turno_j * ll_no_personas_j				
				// se incrementa los dias de continuidad
				If dia_estabilidad > dias_de_continuidad Then dias_de_continuidad++					
			Case 'A', 'L'
				// Dia  Normal o Festivo Laboral
				// se toman los minutos totales de jornada normal
				ldc_min_totales = ldc_min_totales_normales
				// se incrementa los dias de continuidad
				If dia_estabilidad > dias_de_continuidad Then dias_de_continuidad++
			Case Else // 'I', 'V','C' Festivos, Vacaciones y Compensatorios
				ldc_min_totales = 0	
		End Choose		
		ldc_min_disp = ldc_min_totales
		// Si es el primer dia se escalan los minutos disponibles en base a la hora
		If li_i = 1 And ld_fecha1 = ids_calendario_maquina.GetItemDate(li_i,'fe_calendario') Then				
			// se obtien el minuto en que inicia
			If ls_tipo_novedad = 'J' Then
				minuto_laboral_ini = ldc_min_disp / ll_no_personas_j
			Else
				minuto_laboral_ini = ldc_min_disp / no_personas
			End If
			// se escalan los minutos disponibles
			ldc_min_disp = Round(ldc_min_disp * (SecondsAfter(ltm_hora1, 23:59:59) / ( ll_segundos_dia)), 0)
			// se escalan a minutos laborales de inicio
			minuto_laboral_ini = Round(minuto_laboral_ini * (SecondsAfter(Time(0), ltm_hora1) / ( ll_segundos_dia)), 0)
		End If
		// si es un dia laboral se calculan las unidades
		If ldc_min_disp > 0 and dias_de_continuidad > 0 Then
			// se evalua si se toma la curva manual
			If sw_curva > 0 Then
				// se buscan las unidades para el dia h$$HEX1$$e100$$ENDHEX$$bil
				ll_dia = ids_curvas_manuales.Find('dia = ' + String(dias_de_continuidad), 1, ids_curvas_manuales.RowCount() + 1)
				If ll_dia < 0 Then
					MessageBox('Atencion','No se definio produccion para el dia ' + String(dias_de_continuidad))
					Return -7
				ElseIf ll_dia = 0 Then // si no se encontro se busca el ultimo dia definido en la curva
					ll_dia = ids_curvas_manuales.RowCount()
					If ll_dia > 0 Then
						ldc_unidades_prod = ids_curvas_manuales.GetItemNumber(ll_dia, 'cantidad')
					End If
					If ldc_unidades_prod <= 0 Then
						MessageBox('Atencion','No se definio produccion para el dia ' + String(dias_de_continuidad))
						Return -7
					End If
				Else
					// unidades en base a la curva manual					
					ldc_unidades_prod = ids_curvas_manuales.GetItemNumber(ll_dia, 'cantidad')
				End If
				// si no esta activada la bandera para escalar las unidades diarias al porcentaje de los minutos laborales trabajados
				If ib_escalar_manual Then
					If ldc_min_totales > 0 And ldc_min_disp <> ldc_min_totales Then
						ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
					End If
				End If				
			Else
				
				// mira si tiene cuota diaria por mod ref tiene que ser mayor a cero
				If idc_cuota_diaria_maq_ref > 0 Then
					ldc_unidades_prod = idc_cuota_diaria_maq_ref
					
					If ldc_min_totales > 0 And ldc_min_disp <> ldc_min_totales Then
						ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
					End If
				// mira si tiene cuota diaria por mod tiene que ser mayor a cero
				ElseIf idc_cuota_diaria_maquina > 0 Then
					ldc_unidades_prod = idc_cuota_diaria_maquina
					
					If ldc_min_totales > 0 And ldc_min_disp <> ldc_min_totales Then
						ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
					End If
					
				// unidades en base a la curva de eficiencia
				Else
					// unidades en base a la curva de eficiencia
					eficiencia = invo_curva.of_eficiencialogaritmica( dias_de_continuidad )
					ldc_unidades_prod = ldc_min_disp * eficiencia / adc_estandar
				End if
				
//				// unidades en base a la curva de eficiencia
//				eficiencia = invo_curva.of_eficiencialogaritmica( dias_de_continuidad )
//				ldc_unidades_prod = ldc_min_disp * eficiencia / adc_estandar
			End If
		End If
		// Si las unidades producidas < unidades pendientes se restan de lo contrario se termina el ciclo
		If ldc_unidades_prod >= ldc_unidades Then		
			li_filas = li_i 				
		Else
			ldc_unidades -= ldc_unidades_prod
			// se incrementan los minutos totales trabajados
			minutos_totales += ldc_min_disp			
		End If
	Next
	// se resta el dia en que termino
	dias_de_continuidad --
	//Se valida que hay terminado
	If ldc_unidades_prod >= ldc_unidades Then		
		// Se obtiene la fecha en que termino
		ld_fecha2 = ids_calendario_maquina.GetItemDate(li_filas,'fe_calendario')
		// Si el dia de inicio es igual al del fin se inicia los minutos en los de inicio
		// Se escalan en minutos
		If ld_fecha1 = ld_fecha2 Then
			// se calcula hora de fin
			ltm_hora2 = RelativeTime( ltm_hora1, SecondsAfter( ltm_hora1, 23:59:59) * (ldc_unidades / ldc_unidades_prod))
			// se obtiene el minuto de inicio 
			If ls_tipo_novedad = 'J' and ldc_min_disp > 0 Then
				minuto_laboral_ini = ll_turnos_j * ll_min_turno_j 
				// se asigna los minutos totales trabajados
				minutos_totales = ll_turnos_j * ll_min_turno_j * ll_no_personas_j 
			ElseIf ldc_min_disp > 0 Then
				minuto_laboral_ini = turnos * min_turno 
				// se asigna los minutos totales trabajados
				minutos_totales = turnos * min_turno * no_personas 		
			Else
				minuto_laboral_ini = 0
				minutos_totales = 0
			End If
			// se obtiene los minutos totales trabajados
			minutos_totales = Round(minutos_totales * (SecondsAfter(ltm_hora1, ltm_hora2) / ( ll_segundos_dia)), 0)
			
			// se escalan a minutos laborales de inicio y fin
			minuto_laboral_fin = minuto_laboral_ini
			minuto_laboral_ini = Round(minuto_laboral_ini * (SecondsAfter(Time(0), ltm_hora1) / ( ll_segundos_dia)), 0)
			minuto_laboral_fin = Round(minuto_laboral_fin * (SecondsAfter(Time(0), ltm_hora2) / ( ll_segundos_dia)), 0)
			
		Else
			// se calcula hora de fin
			ltm_hora2 = RelativeTime ( Time(0), ldc_unidades / ldc_unidades_prod * ll_segundos_dia)		
			// se obtiene el minuto de fin	
			If ls_tipo_novedad = 'J' and ldc_min_disp > 0 Then
				minuto_laboral_fin = ll_turnos_j * ll_min_turno_j 
				// se incrementa los minutos totales trabajados
				minutos_totales += Round(ll_turnos_j * ll_min_turno_j * ll_no_personas_j * (SecondsAfter(Time(0), ltm_hora2) / ( ll_segundos_dia)), 0)				
			ElseIf ldc_min_disp > 0 Then
				minuto_laboral_fin = turnos * min_turno 
				// se incrementa los minutos totales trabajados
				minutos_totales += turnos * min_turno * no_personas * (SecondsAfter(Time(0),ltm_hora2) / ( ll_segundos_dia))		
			Else
				minuto_laboral_fin = 0
			End If
			// se escalan a minutos laborales de fin
			minuto_laboral_fin =  Round(minuto_laboral_fin * (SecondsAfter(ltm_hora2, 23:59:59) / ( ll_segundos_dia)), 0)
		End IF		
		If ltm_hora2 <> 23:59:59 Then
			// se aproxima y se quitan los segundos
			ltm_hora2 = RelativeTime(ltm_hora2, 30)
			ltm_hora2 = Time(Hour(ltm_hora2), Minute(ltm_hora2),0)
		End If
		adtm_fecha_fin = DateTime(ld_fecha2, ltm_hora2 )	
		Return minutos_totales
	Else
		// Error
		ld_fecha2 = RelativeDate(ld_fecha1,  li_filas + 1)
		MessageBox("Error","No se ha definido calendario para el a$$HEX1$$f100$$ENDHEX$$o " + String(Year(ld_fecha2) ) )
		ldtm_fecha_fin = DateTime(Date(0))	
		Return -1
	End IF
ELSE
	/* Si se calcula desde la fecha de fin retrocediendo los dias como si fuera hacia adelante 
		luego se ajusta la fecha de inicio con la eficiencia real		
	*/
	
	// se valida que la fecha este definida en el calendario
	If of_fechaexiste( co_calendario, ld_fecha2) < 0 Then
		// alguna o ambas de las fechas  no existe en el calendario
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ld_fecha2) + "' no esta definida dentro del calendario")
		Return -5
	End If
	
	// se filtran las fechas entre las fechas recibidas como parametro
	ids_calendario_maquina.SetFilter('fe_calendario <= ' + String(ld_fecha2, 'yyyy-mm-dd'))
	ids_calendario_maquina.Filter()
	
	ids_calendario_maquina.SetSort('fe_calendario Desc')
	ids_calendario_maquina.Sort()
		
	li_filas = ids_calendario_maquina.Rowcount()
	For li_i = 1 To li_filas
		
		ldc_min_disp = 0	
		ldc_unidades_prod = 0
		// se toma el tipo de novedad
		ls_tipo_novedad = ids_calendario_maquina.GetItemString(li_i,'tipo_novedad')		
		Choose Case ls_tipo_novedad
			Case 'J'				
				// Jornada Especial
				// se toman los datos de la jornada especial
				ll_turnos_j = ids_calendario_maquina.GetItemNumber(li_i,'turnos')
				ll_min_turno_j = ids_calendario_maquina.GetItemNumber(li_i,'min_turnos')			
				ll_no_personas_j = ids_calendario_maquina.GetItemNumber(li_i,'no_personas')				
				ldc_min_totales = ll_turnos_j * ll_min_turno_j * ll_no_personas_j				
				// se incrementa los dias de continuidad
				If dia_estabilidad > dias_de_continuidad Then dias_de_continuidad++										
			Case 'A', 'L'
				// Dia  Normal o Festivo Laboral
				// se calcula el numero total de minutos
				ldc_min_totales = turnos * min_turno * no_personas
				// se incrementa los dias de continuidad
				If dia_estabilidad > dias_de_continuidad Then dias_de_continuidad++
			Case Else // 'I', 'V','C' Festivos, Vacaciones y Compensatorios
				ldc_min_totales = 0	
		End Choose			
		
		ldc_min_disp = ldc_min_totales
		
		// Si es el ultimo dia (fecha2) se escalan los minutos disponibles
		If li_i = 1 And ld_fecha2 = ids_calendario_maquina.GetItemDate(li_i,'fe_calendario')  Then				
			ldc_min_disp = Round(ldc_min_disp * (SecondsAfter(Time(0), ltm_hora2) / ( ll_segundos_dia)), 0)
		End If
		// si es un dia laboral se calculan las unidades
		If ldc_min_disp > 0 and dias_de_continuidad > 0 Then
			// se evalua si se toma la curva manual
			If sw_curva > 0 Then
				// se buscan las unidades para el dia h$$HEX1$$e100$$ENDHEX$$bil
				ll_dia = ids_curvas_manuales.Find('dia = ' + String(dias_de_continuidad), 1, ids_curvas_manuales.RowCount() + 1)
				If ll_dia < 0 Then
					MessageBox('Atencion','No se definio produccion para el dia .' + String(dias_de_continuidad))
					Return -7
				ElseIf ll_dia = 0 Then // si no se encontro se busca el ultimo dia definido en la curva
					ll_dia = ids_curvas_manuales.RowCount()
					If ll_dia > 0 Then
						ldc_unidades_prod = ids_curvas_manuales.GetItemNumber(ll_dia, 'cantidad')
					End If
					If ldc_unidades_prod <= 0 Then
						MessageBox('Atencion','No se definio produccion para el dia ' + String(dias_de_continuidad))
						Return -7
					End If
				Else
					// unidades en base a la curva manual
					ldc_unidades_prod = ids_curvas_manuales.GetItemNumber(ll_dia, 'unidades')
				End If
			Else
				// mira si tiene cuota diaria por mod ref tiene que ser mayor a cero
				If idc_cuota_diaria_maq_ref > 0 Then
					ldc_unidades_prod = idc_cuota_diaria_maq_ref
				// mira si tiene cuota diaria por mod tiene que ser mayor a cero
				ElseIf idc_cuota_diaria_maquina > 0 Then
					ldc_unidades_prod = idc_cuota_diaria_maquina
				// unidades en base a la curva de eficiencia
				Else
					// unidades en base a la curva de eficiencia
					ldc_unidades_prod = ldc_min_disp * invo_curva.of_eficiencialogaritmica( dias_de_continuidad ) / adc_estandar
				End if
				
//				// unidades en base a la curva de eficiencia
//				ldc_unidades_prod = ldc_min_disp * invo_curva.of_eficiencialogaritmica( dias_de_continuidad ) / adc_estandar
			End If
			// si no esta activada la bandera para escalar las unidades diarias al porcentaje de los minutos laborales trabajados
			If ib_escalar_manual Then
				If ldc_min_totales > 0 And ldc_unidades_prod <> ldc_min_totales Then
					ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
				End If
			End If				
		End If
		// Si las unidades producidas < unidades pendientes se restan de lo contrario se termina el ciclo		
		If ldc_unidades_prod >= ldc_unidades Then		
			li_filas = li_i 				
		Else
			ldc_unidades -= ldc_unidades_prod
			minutos_totales += ldc_min_disp
			ldc_unidades_prod = 0
		End If		
	Next		
	If ldc_unidades_prod >= ldc_unidades Then	
		// Se toma la fecha en que deberia iniciar		
		ld_fecha1 = ids_calendario_maquina.GetItemDate(li_filas,'fe_calendario')
		// Si el dia de inicio es igual al del fin se inicia los minutos en los de inicio
		If ld_fecha1 = ld_fecha2 Then
			ltm_hora1 = Time (ltm_hora2)
			ltm_hora1 = RelativeTime ( ltm_hora1, - ldc_unidades / ldc_unidades_prod *ll_segundos_dia)
		Else
			ltm_hora1 = Time ('23:59:59')
			ltm_hora1 = RelativeTime ( ltm_hora1, - ldc_unidades / ldc_unidades_prod *ll_segundos_dia)				
		End IF
		ldtm_fecha_ini = DateTime(ld_fecha1, ltm_hora1)		
		// se recalcula la fecha final
		This.of_Calcular_Fecha( ldtm_fecha_ini, ldtm_fecha_fin, 'I', adc_estandar, adc_cantidad, ai_dias_de_continuidad)
		// ciclo para ajustar la fecha
		// se valida que el dia de fin no sea mayor que la fecha fin pedida
		Do While Date( adtm_fecha_fin ) > Date(ldtm_fecha_fin )/* Or  &
			( Date( adtm_fecha_fin ) = Date(ldtm_fecha_fin ) And &
			Time( adtm_fecha_fin ) > Time(ldtm_fecha_fin ) )*/
			// se disminuye un dia a la fecha de inicio
			If Time(0) = Time(ldtm_fecha_ini) Then
				ldtm_fecha_ini = DateTime(RelativeDate(Date(ldtm_fecha_ini), -1) )
			Else
				ldtm_fecha_ini = DateTime(Date(ldtm_fecha_ini))
			End IF			
			This.dias_de_continuidad = 0
			// se recalcula la fecha final en base a la nueva fecha de inicio
			If This.of_calcular_fecha( ldtm_fecha_ini, ldtm_fecha_fin, 'I', adc_estandar, adc_cantidad, ai_dias_de_continuidad) < 0 Then
				Return -1
			End IF
		Loop
		// se le asigna los respectivos valores a las fechas
		adtm_fecha_ini = ldtm_fecha_ini
		adtm_fecha_fin = ldtm_fecha_fin
		Return minutos_totales
	Else
		// Error La fecha no esta definida en el calendario

		// se obtiene la fecha del a$$HEX1$$f100$$ENDHEX$$o que no esta definido
		ld_fecha1 = RelativeDate(ld_fecha2, - li_filas - 10)
		//mensaje de error
		MessageBox("Error","No se ha definido calendario para el a$$HEX1$$f100$$ENDHEX$$o " + String(Year(ld_fecha1) ) )
		ldtm_fecha_ini = DateTime(Date(0))
		Return -8
	End If		
End If
ldtm_fecha_ini = DateTime(Date(0))
Return -9


end function

public function decimal of_calcular_unidades (datetime adtm_fecha_ini, datetime adtm_fecha_fin, decimal adc_estandar, long ai_dias_de_continuidad);/* -----------------------------------------------------------------------------------------
Obtiene las unidades producidas desde una fecha de inicio y una fecha fin, la hora 
de estas fechas son escaladas para conocer los minutos disponibles para producir.

Ejemplos de escala de minutos: 
- Si son 400 minutos laborable en el dia y se trabajan 200 minutos la hora se escala
	 y quedaria a las 12:00.
- Si son 400 minutos laborable en el dia y se trabajan 100 minutos la hora se escala
	 y quedaria a las 6:00.
----------------------------------------------------------------------------------------- */

Long li_dias, li_filas, li_i
Long ll_turnos_j, ll_min_turno_j, ll_no_personas_j
Decimal ldc_unidades_prod, ldc_min_disp, ldc_min_totales, ldc_min_totales_normales, ldc_unidades
Date ld_fecha1, ld_fecha2
Long ll_dia, ll_segundos_dia
Time ltm_hora1, ltm_hora2
String ls_tipo_novedad
DateTime ldtm_fecha_ini, ldtm_fecha_fin

// se inicializa los minutos en 0
minutos_totales = 0
eficiencia = 0
// se valida el estandar
If adc_estandar <= 0 Or IsNull(adc_estandar) Then	Return -1

// se valida las fechas de inicio y fin
If adtm_fecha_ini > adtm_fecha_fin Then Return -2

// Se cargan la informacion de los turnos y la curva
If This.Of_Cargar_Datos( ) < 0 Then Return -3

// se inicializa las constantes de la curva, los dias de continuidad y las unidades
invo_curva.of_setconstantes( idc_a, idc_b)

If IsNull(ai_dias_de_continuidad) Then 
	MessageBox('Faltan Parametros', 'Falta los dias de continuidad')
	Return -3
End If

dias_de_continuidad = ai_dias_de_continuidad

// se carga el calendario del maquina
If This.Of_Set_Calendario_Maquina( ) < 0 Then 
	Return -4 //error al consultar la base de datos
End If

// Se toman las fechas y se inicializan las unidades_prod en 0
ld_fecha1 = Date(adtm_fecha_ini)
ltm_hora1 = Time(adtm_fecha_ini)
ld_fecha2 = Date(adtm_fecha_fin)
ltm_hora2 = Time(adtm_fecha_fin)
ldc_unidades_prod = 0
ldc_unidades = 0


// se valida que la fecha este definida en el calendario
If Of_FechaExiste( co_calendario, ld_fecha1) < 0 Then
	// alguna o ambas de las fechas  no existe en el calendario
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ld_fecha1) + "' no esta definida dentro del calendario")
	Return -5
End If

// se valida que la fecha este definida en el calendario
If Of_FechaExiste( co_calendario, ld_fecha2) < 0 Then
	// alguna o ambas de las fechas  no existe en el calendario
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ld_fecha2) + "' no esta definida dentro del calendario")
	Return -6
End If

// se filtran las fechas entre las fechas recibidas como parametro
ids_calendario_maquina.SetFilter('fe_calendario BETWEEN ' + String(ld_fecha1, 'yyyy-mm-dd') + &
											' AND ' + String(ld_fecha2, 'yyyy-mm-dd') )
ids_calendario_maquina.Filter()
// se organiza ascendentemente
ids_calendario_maquina.SetSort('fe_calendario ASC')
ids_calendario_maquina.Sort( )

li_filas = ids_calendario_maquina.RowCount()

// se calcula el numero total de minutos de la jornada normal
ldc_min_totales_normales = turnos * min_turno * no_personas
// Segundos por d$$HEX1$$ed00$$ENDHEX$$a
ll_segundos_dia = 24 * 60 * 60

// Se hace el ciclo mientras no se hayan producidos las unidades o se acaben los 
For li_i = 1 To li_filas	
	ldc_min_disp = 0
	ldc_unidades_prod = 0
	// se toma el tipo de novedad
	ls_tipo_novedad = ids_calendario_maquina.GetItemString(li_i,'tipo_novedad')
	Choose Case ls_tipo_novedad
		Case 'J'				
			// Jornada Especial
			// se toman los datos de la jornada especial
			ll_turnos_j = ids_calendario_maquina.GetItemNumber(li_i,'turnos')
			ll_min_turno_j = ids_calendario_maquina.GetItemNumber(li_i,'min_turnos')			
			ll_no_personas_j = ids_calendario_maquina.GetItemNumber(li_i,'no_personas')				
			ldc_min_totales = ll_turnos_j * ll_min_turno_j * ll_no_personas_j				
			// se incrementa los dias de continuidad
			If dia_estabilidad > dias_de_continuidad Or dia_estabilidad = 0 Then dias_de_continuidad++										
		Case 'A', 'L'
			// Dia  Normal o Festivo Laboral
			// se calcula el numero total de minutos
			//ldc_min_totales = turnos * min_turno * no_personas
			// se toman los minutos totales de jornada normal
			ldc_min_totales = ldc_min_totales_normales

			// se incrementa los dias de continuidad
			If dia_estabilidad > dias_de_continuidad Or dia_estabilidad = 0 Then dias_de_continuidad++
		Case Else // 'I', 'V','C' Festivos, Vacaciones y Compensatorios
			ldc_min_totales = 0	
	End Choose	
	ldc_min_disp = ldc_min_totales
	If li_i = 1 And li_i = li_filas Then
		// Si es el primer dia y se termino en el mismo dia
		// se escalan los minutos disponibles en base a los minutos utilizados
		// se obtienen los minutos laborales
		If ls_tipo_novedad = 'J' Then
			minuto_laboral_ini = ldc_min_disp / ll_no_personas_j
		Else
			minuto_laboral_ini = ldc_min_disp / no_personas
		End If						
		
		// Se calcula el minuto laboral de inicio y fin
		minuto_laboral_fin = minuto_laboral_ini
		minuto_laboral_ini = Round(minuto_laboral_ini * (SecondsAfter(Time(0), ltm_hora1) / ( ll_segundos_dia)), 0)
		minuto_laboral_fin = Round(minuto_laboral_fin * (SecondsAfter(Time(0), ltm_hora2) / ( ll_segundos_dia)), 0)
	
		// se escalan los minutos
		ldc_min_disp = Round(ldc_min_disp * (SecondsAfter(ltm_hora1, ltm_hora2) / ( ll_segundos_dia)), 0 )
		
	ElseIf li_i = 1 And ld_fecha1 = ids_calendario_maquina.GetItemDate(li_i,'fe_calendario') Then				
		// Si es el primer dia se escalan los minutos disponibles en base a la hora				
		ldc_min_disp = Round(ldc_min_disp * (SecondsAfter( ltm_hora1, Time('23:59:59')) / ( ll_segundos_dia)), 0 )

		// se obtienen los minutos laborales
		If ls_tipo_novedad = 'J' Then
			minuto_laboral_ini = ldc_min_disp / ll_no_personas_j
		Else
			minuto_laboral_ini = ldc_min_disp / no_personas
		End If						
		// Se calcula el minuto laboral de inicio 
		minuto_laboral_ini = Round(minuto_laboral_ini * (SecondsAfter(Time(0), ltm_hora1) / ( ll_segundos_dia)), 0)
	ElseIf li_i = li_filas Then // si es el ultimo dia se escalan lo minutos
		// se escalan los minutos		
		ldc_min_disp = Round(ldc_min_disp * (SecondsAfter( Time(0), ltm_hora2) / ( ll_segundos_dia)), 0 )
		// se obtienen los minutos laborales		
		If ls_tipo_novedad = 'J' Then
			minuto_laboral_fin = ldc_min_disp / ll_no_personas_j
		Else
			minuto_laboral_fin = ldc_min_disp / no_personas
		End If						
		// Se calcula el minuto laboral de fin
		minuto_laboral_fin = Round(minuto_laboral_fin * (SecondsAfter(Time(0), ltm_hora2) / ( ll_segundos_dia)), 0)		
	End If
	// si es un dia laboral se calculan las unidades
	If ldc_min_disp > 0 And dias_de_continuidad > 0 Then
		// se evalua si se toma la curva manual
		If sw_curva > 0 Then
			// se buscan las unidades para el dia h$$HEX1$$e100$$ENDHEX$$bil
			ll_dia = ids_curvas_manuales.Find('dia = ' + String(dias_de_continuidad), 1, ids_curvas_manuales.RowCount() + 1)
			If ll_dia < 0 Then
				MessageBox('Atencion','No se defini$$HEX2$$f3002000$$ENDHEX$$produccion para el dia ' + String(dias_de_continuidad))
				Return -7
			ElseIf ll_dia = 0 Then // si no se encontro se busca el ultimo dia definido en la curva
				ll_dia = ids_curvas_manuales.RowCount()
				If ll_dia > 0 Then
					ldc_unidades_prod = ids_curvas_manuales.GetItemNumber(ll_dia, 'cantidad')
				End If
				If ldc_unidades_prod <= 0 Then
					MessageBox('Atencion','No se defini$$HEX2$$f3002000$$ENDHEX$$produccion para el dia ' + String(dias_de_continuidad))
					Return -7
				End If			
			Else
				// unidades en base a la curva manual
				ldc_unidades_prod = ids_curvas_manuales.GetItemNumber(ll_dia, 'cantidad')
				
			End If
			// si no esta activada la bandera para escalar las unidades diarias al porcentaje de los minutos laborales trabajados
			If ib_escalar_manual Then
				If ldc_min_totales > 0 And ldc_min_disp <> ldc_min_totales Then
					ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
				End If
			End If
		Else
			// mira si tiene cuota diaria por mod ref tiene que ser mayor a cero
			If idc_cuota_diaria_maq_ref > 0 Then
				ldc_unidades_prod = idc_cuota_diaria_maq_ref
				
				If ldc_min_totales > 0 And ldc_min_disp <> ldc_min_totales Then
					ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
				End If
			// mira si tiene cuota diaria por mod tiene que ser mayor a cero
			ElseIf idc_cuota_diaria_maquina > 0 Then
				ldc_unidades_prod = idc_cuota_diaria_maquina
				
				If ldc_min_totales > 0 And ldc_min_disp <> ldc_min_totales Then
					ldc_unidades_prod = ldc_unidades_prod * (ldc_min_disp / ldc_min_totales)
				End If
			// unidades en base a la curva de eficiencia
			Else
				// unidades en base a la curva de eficiencia
				eficiencia = invo_curva.Of_EficienciaLogaritmica( dias_de_continuidad )
				ldc_unidades_prod = ldc_min_disp * eficiencia / adc_estandar
			End if
//			// unidades en base a la curva de eficiencia
//			eficiencia = invo_curva.Of_EficienciaLogaritmica( dias_de_continuidad )
//			ldc_unidades_prod = ldc_min_disp * eficiencia / adc_estandar
		End If
	End If
	
	// se acumulan las unidades producidas
	ldc_unidades += ldc_unidades_prod
	ldc_unidades_prod = 0	
	minutos_totales += ldc_min_disp
Next
// se resta el dia en que termino
dias_de_continuidad --

If ib_redondear Then
	ldc_unidades = Truncate(ldc_unidades + 0.5, 0)
End If
// Se retorna el numero de unidades producidas
Return ldc_unidades
end function

public function long of_dias_de_atraso (date ad_fecha_prog, date ad_fecha_real);/* -----------------------------------------------------------------------------------------
Esta Funci$$HEX1$$f300$$ENDHEX$$n Retorna el n$$HEX1$$fa00$$ENDHEX$$mero de d$$HEX1$$ed00$$ENDHEX$$as h$$HEX1$$e100$$ENDHEX$$biles de atraso entre una fecha real y 
una fecha programadad basados en el calendario del maquina.
Se Toma la fecha de inicio y fin para la consulta del calendario, 
retorna positivo cuando esta atrasado y negativo cuando esta adelantado
----------------------------------------------------------------------------------------- */

//String ls_expresion
//Date ld_fecha1, ld_fecha2
//uo_dsbase lds_fechas
//Long ll_row, ll_signo
//
//// Se evalua el valor de las fechas para evaluar si esta adelantado o atrasado
//If ad_fecha_real < ad_fecha_prog Then
//	ld_fecha1 = ad_fecha_real
//	ld_fecha2 = ad_fecha_prog
//	// Signo positivo cuando esta atrasado
//	ll_signo = -1
//ElseIf ad_fecha_real > ad_fecha_prog Then
//	ld_fecha1 = ad_fecha_prog
//	ld_fecha2 = ad_fecha_real
//	// Signo positivo cuando esta adelantado
//	ll_signo = 1
//Else
//	// Si es el mismo dia retorna 0
//	Return 0
//End IF
//// Se resta un dia a la fecha final para no incluir el dia en que termina
//ld_fecha2 = RelativeDate(ld_fecha2, -1)
//lds_fechas = CREATE uo_dsbase
//lds_fechas.DataObject = "d_dias_laborables_x_modulo"
//lds_fechas.SetTransObject(itr_transaccion)
//// Se traen los dias habiles dentro el rango de fechas
//ll_row = lds_fechas.Retrieve(co_fabrica,co_planta,co_centro,co_subcentro,co_tipoprod,co_maquina_agrupado,ld_fecha1,ld_fecha2,simulacion)
//Destroy(lds_fechas)
//// Se valida error en la BD
//If ll_row < 0 Then
//	messageBox("Error","Error al leer en la base de datos")
//	Return -10000
//End If
//// Se retorna el numero de dias con el respectivo signo
//Return ll_row * ll_signo
Return DaysAfter( ad_fecha_real, ad_fecha_prog)

end function

public function long of_reiniciar_propiedades ();// se limpian todos los datastore
If IsValid( ids_calendario_fabrica ) Then
	ids_calendario_fabrica.Reset( )
End If
IF IsValid( ids_calendario_novedad ) Then
	ids_calendario_novedad.Reset( )
End If
If IsValid( ids_calendario_maquina ) Then
	ids_calendario_maquina.Reset( )
End If
If IsValid( ids_calendario_maquina ) Then
	ids_calendario_maquina.Reset( )
End If
If IsValid( ids_curvas ) Then
	ids_curvas.Reset()
End If
If IsValid( ids_curvas_manuales ) Then
	ids_curvas_manuales.Reset()
End If
If IsValid( ids_turnos ) Then
	ids_turnos.Reset()
End IF
If IsValid( ids_maquinas ) Then
	ids_maquinas.Reset()
End IF

// se limpian los principales datos
SetNull(co_calendario)
SetNull(co_fabrica)
SetNull(co_fabrica_cal)
SetNull(co_tipo_maquina)
SetNull(co_maquina)
SetNull(co_curva)
SetNull(sw_curva)
SetNull(minuto_laboral_ini)
SetNull(minuto_laboral_fin)
SetNull(minutos_totales)

SetNull(co_maquina_cal)

Return 1
end function

public function long of_sumar_minutos (datetime adtm_fecha, long al_minutos, ref datetime adtm_fecha_sumada);/*----------------------------------- FUNCION PARA SUMAR MINUTOS A UNA FECHA --------------------------------------
Esta funcion le suma a un datetime los minutos enviados y se guarda en la variable por referencia adtm_fecha_sumada
-----------------------------------------------------------------------------------------------------------------*/
Date ld_fecha
Time ltm_hora
Long ll_seconds, ll_factor
Long li_dias

ll_factor = 24*60*60 // cantidad de segundos en un dia 24 h * 60 min * 60 seg
// se obtiene la fechahora
ld_fecha = Date(adtm_fecha)
ltm_hora = Time(adtm_fecha)
// se suman los segundos que lleva y los segundos a sumar
ll_seconds = SecondsAfter( Time(0), ltm_hora ) + al_minutos * 60

li_dias = Truncate( ll_seconds / ll_factor, 0 ) // se calcula el numero de dias 
If ll_seconds < 0 Then
	li_dias -- // si los segundos son negativo se resta un dia
End If

ll_seconds -= li_dias * ll_factor // se restan los dias a los segundos
// si no es en el mismo dia se calcula la nueva fecha 
If li_dias <> 0 Then
	ld_fecha = RelativeDate( ld_fecha, li_dias)
End If
// se calcula la hora
ltm_hora = RelativeTime( Time(0), ll_seconds )
// se asigna la fecha sumada
adtm_fecha_sumada = DateTime(ld_fecha, ltm_hora)

Return 1

end function

public function long of_sumar_minutos_laborales (datetime adtm_fecha, long al_minutos, ref datetime adtm_fecha_sumada);/*----------------------------------- FUNCION PARA SUMAR MINUTOS A UNA FECHA --------------------------------------
Esta funcion le suma a un datetime los minutos enviados y se guarda en la variable por referencia adtm_fecha_sumada
-----------------------------------------------------------------------------------------------------------------*/
Date ld_fecha
Time ltm_hora
Long li_turnos_j, li_min_turno_j, li_no_personas_j
Long ll_row, ll_minutos, ll_factor
Decimal ldc_min_disp
String ls_tipo_novedad
// si los minutos son menores que 0 error
If al_minutos < 0 Then Return -1
// si los minutos son 0 se asigna la misma fecha
If al_minutos = 0 Then
	adtm_fecha_sumada = adtm_fecha
	Return 1
End If

// se calcula el minuto laboral en que inicia
ll_minutos = This.of_calcularminuto( adtm_fecha )
If ll_minutos < 0 Then Return -1
// se suma los minutos
ll_minutos += al_minutos

ll_factor = 24*60*60 // cantidad de segundos en un dia 24 h * 60 min * 60 seg

// se filtran las fechas entre las fechas recibidas como parametro
ids_calendario_maquina.SetFilter('')
ids_calendario_maquina.Filter()
ids_calendario_maquina.SetSort('fe_calendario')
ll_row = ids_calendario_maquina.Find('fe_calendario = ' + String(ld_fecha, 'yyyy-mm-dd'), 1, ids_calendario_maquina.RowCount() + 1)
Do while ll_minutos > 0 And ll_row <= ids_calendario_maquina.RowCount( )
	ldc_min_disp = 0
	// se toma el tipo de novedad
	ls_tipo_novedad = ids_calendario_maquina.GetItemString(ll_row,'tipo_novedad')
	Choose Case ls_tipo_novedad
		Case 'J'				
			// Jornada Especial
			// se toman los datos de la jornada especial
			li_turnos_j = ids_calendario_maquina.GetItemNumber(ll_row,'turnos')
			li_min_turno_j = ids_calendario_maquina.GetItemNumber(ll_row,'min_turnos')					
			ldc_min_disp = li_turnos_j * li_min_turno_j 		
		Case 'A', 'L'
			// Dia Sin Modificaciones o Festivo Laboral
			ldc_min_disp = turnos * min_turno 
		Case Else // 'I','V','C' Festivos, Vacaciones y Compensatorios
			ldc_min_disp = 0	
	End Choose
	If ldc_min_disp >= ll_minutos Then
		ll_minutos -= ldc_min_disp
		ll_row++
	End If
Loop
// es un dia completo
If ll_minutos = 0 Then
	ltm_hora = 23:59:59
	adtm_fecha_sumada = DateTime(ids_calendario_maquina.GetItemDate(ll_row - 1,'fe_calendario'), ltm_hora)
Else
	// se escala la hora en base a los minutos
	ltm_hora = RelativeTime( Time(0), ll_factor * ldc_min_disp/ ll_minutos )
	adtm_fecha_sumada = DateTime(ids_calendario_maquina.GetItemDate(ll_row - 1,'fe_calendario'), ltm_hora)
End IF
Return ldc_min_disp
end function

public function long of_mensaje (string as_titulo, string as_msn, s_base_parametros asp_parametros, string as_fin);String ls_mensaje
Long li_i

If Len(as_msn) > 0 Then
	ls_mensaje = as_msn + '~r~n'
End If

// nombre de los campos
For li_i = 1 To UpperBound(asp_parametros.Cadena)
	If li_i > 1 Then	ls_mensaje += '~t'
	ls_mensaje += asp_parametros.Cadena[li_i]
Next

ls_mensaje += '~r~n'
// los valores de los campos
For li_i = 1 To UpperBound(asp_parametros.Any)
	If li_i > 1 Then	ls_mensaje += '~t'
	ls_mensaje += Trim (String (asp_parametros.Any[li_i]) )
Next

If Len(as_fin) > 0 Then
	ls_mensaje += '~r~n' + as_fin
End If

MessageBox(as_titulo, ls_mensaje )

Return 1


end function

public function long of_set_transaccion (transaction atr_transaccion);// Se asigna el objeto de transaccion para trabajar
itr_transaccion = atr_transaccion
Return 1
end function

public function long of_configuracion_dia (date ad_fecha, ref string as_tipo_novedad, ref long al_turnos, ref long al_min_turno, ref long al_no_personas);/* -----------------------------------------------------------------------------------------
Obtiene la configuracion del calendario (turnos, minutos_turno, no_personas) para una fecha determinada
y retorna el numero de minutos laborales disponibles para ese dia.
----------------------------------------------------------------------------------------- */
Long ll_row
Decimal ldc_min_disp

// Se cargan la informacion de los turnos y la curva
If This.of_cargar_datos( ) < 0 Then Return -1

// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return -2 //error al consultar la base de datos
End If

// se valida que la fecha este definida en el calendario
If This.of_fechaexiste( co_calendario, ad_fecha) < 0 Then
	// alguna o ambas de las fechas  no existe en el calendario
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ad_fecha) + "' no esta definida dentro del calendario")
	Return -3
End If

// se filtran las fechas entre las fechas recibidas como parametro
ids_calendario_maquina.SetFilter('')
ids_calendario_maquina.Filter()

ll_row = ids_calendario_maquina.Find('fe_calendario = ' + String(ad_fecha, 'yyyy-mm-dd'), 1, ids_calendario_maquina.RowCount() + 1)
ldc_min_disp = 0
// se toma el tipo de novedad
as_tipo_novedad = ids_calendario_maquina.GetItemString(ll_row,'tipo_novedad')
Choose Case as_tipo_novedad
	Case 'J'				
		// Jornada Especial
		// se toman los datos de la jornada especial
		al_turnos		= ids_calendario_maquina.GetItemNumber(ll_row,'turnos')
		al_min_turno	= ids_calendario_maquina.GetItemNumber(ll_row,'min_turnos')					
		al_no_personas = ids_calendario_maquina.GetItemNumber(ll_row,'no_personas')
				
	Case 'A', 'L'
		// Dia  Sin Modificaciones o Festivo Laboral
		al_turnos		= turnos
		al_min_turno	= min_turno
		al_no_personas = no_personas		
	Case Else // 'I','V','C' Festivos, Vacaciones y Compensatorios
		al_turnos		= 0
		al_min_turno	= 0
		al_no_personas = 0
End Choose	

ldc_min_disp = al_turnos * al_min_turno * al_no_personas
// se retorna el minuto disponible
Return ldc_min_disp
end function

public function string of_tipo_novedad (date ad_fecha);/* -----------------------------------------------------------------------------------------
Evalua si la fecha es festivo.
Se consulta en el calendario de fabrica y si es festivo retorna verdadero
----------------------------------------------------------------------------------------- */
Long ll_row
String ls_tipo_novedad

SetNull(ls_tipo_novedad)

// se carga el calendario del maquina
If This.of_set_calendario_maquina( ) < 0 Then 
	Return ls_tipo_novedad //error al consultar la base de datos
End If

// se valida que la fecha este definida en el calendario
If of_fechaexiste( co_calendario, ad_fecha) < 0 Then
	// alguna o ambas de las fechas  no existe en el calendario
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"La fecha '" + String(ad_fecha) + "' no esta definida dentro del calendario")
	Return ls_tipo_novedad
End If

// se filtran las fechas entre las fechas recibidas como parametro
ids_calendario_maquina.SetFilter('')
ids_calendario_maquina.Filter()

ll_row = ids_calendario_maquina.Find('fe_calendario = ' + String(ad_fecha, 'yyyy-mm-dd'), 1, ids_calendario_maquina.RowCount() + 1)
// se toma el tipo de novedad
ls_tipo_novedad = ids_calendario_maquina.GetItemString(ll_row,'tipo_novedad')
	
Return ls_tipo_novedad

end function

public function long of_set_dw_cuota_x_mod_ref (string as_dataobject);


If Not Isvalid(ids_cuota_maq_ref) Then
	ids_cuota_maq_ref = Create uo_dsbase
End if

ids_cuota_maq_ref.DataObject = as_dataobject
ids_cuota_maq_ref.SetTransObject(itr_transaccion)

Return 1

	


end function

public function long of_semanas_x_fecha (long ai_calendario, date ad_fecha_inicio, date ad_fecha_fin, ref s_base_parametros astr_semana[]);/* -----------------------------------------------------------------------------------------
Esta Funci$$HEX1$$f300$$ENDHEX$$n Retorna las semanas con el n$$HEX1$$fa00$$ENDHEX$$mero de d$$HEX1$$ed00$$ENDHEX$$as laborales entre un
rango de fechas
----------------------------------------------------------------------------------------- */

Boolean lb_cambia_semana
Long ll_row, ll_rsemana
Long li_dias, li_a$$HEX1$$f100$$ENDHEX$$o, li_mes, li_semana
String ls_expresion
s_base_parametros lstr_semana_blanco[]

astr_semana = lstr_semana_blanco

co_calendario = ai_calendario
// se carga el calendario de fabrica
If This.of_Set_Calendario_Fabrica( ) < 0 Then 
	Return -1 //error al consultar la base de datos
End If
// se busca se existe la fecha de inicio y fin
If of_FechaExiste( ai_calendario, ad_fecha_inicio) > 0 And of_FechaExiste( ai_calendario, ad_fecha_fin)>0 Then
	// se ordena el calendario
	ids_calendario_fabrica.SetSort('fe_calendario ASC ')
	ids_calendario_fabrica.Sort()
	
	ls_expresion = 'co_calendario = ' + String(co_calendario) + ' AND fe_calendario BETWEEN ' &
			+ String(ad_fecha_inicio, 'yyyy-mm-dd') + ' AND ' + String(ad_fecha_fin, 'yyyy-mm-dd')
	
	ll_row = ids_calendario_fabrica.Find( ls_expresion, 1, ids_calendario_fabrica.RowCount() + 1)

	ll_rsemana = 0
	Do While ll_row > 0
		li_a$$HEX1$$f100$$ENDHEX$$o = ids_calendario_fabrica.GetItemNumber( ll_row, 'ano')
		li_mes = ids_calendario_fabrica.GetItemNumber( ll_row, 'mes')
		li_semana = ids_calendario_fabrica.GetItemNumber( ll_row, 'semana')
		If ll_rsemana = 0 Then
			lb_cambia_semana = True
		ElseIf(astr_semana[ll_rsemana].Entero[1] <> li_a$$HEX1$$f100$$ENDHEX$$o Or astr_semana[ll_rsemana].Entero[2] <> li_mes &
				Or astr_semana[ll_rsemana].Entero[3] <> li_semana) Then
			lb_cambia_semana = True
		Else
			lb_cambia_semana = False
		End If
		If lb_cambia_semana Then
			ll_rsemana ++ 
			astr_semana[ll_rsemana].Entero[1] = li_a$$HEX1$$f100$$ENDHEX$$o
			astr_semana[ll_rsemana].Entero[2] = li_mes
			astr_semana[ll_rsemana].Entero[3] = li_semana
			astr_semana[ll_rsemana].Entero[4] = 0
		End If
		// dias habiles
		If Trim(ids_calendario_fabrica.GetItemString( ll_row, 'sw_festivo')) <> 'I' Then
			astr_semana[ll_rsemana].Entero[4] ++
		End If


		
		ll_row = ids_calendario_fabrica.Find( ls_expresion, ll_row + 1, ids_calendario_fabrica.RowCount() + 1)
	Loop
	
	
	// se retorn el numero de dias
	Return 1
Else
	// Las fechas no estan definidas en el calendario
	Return -3
End If


end function

on n_utilidades_calendario_new1.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_utilidades_calendario_new1.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// Por defecto se inicializa el objecto de transaccion al SQLCA
itr_transaccion = SQLCA
ids_calendario_fabrica = Create uo_dsbase
ids_calendario_fabrica.DataObject = 'd_dt_calendario'
ids_calendario_fabrica.SetTransObject(itr_transaccion)

ids_calendario_maquina = Create uo_dsbase
ids_calendario_maquina.DataObject = 'd_dt_fechas_novedad'
ids_calendario_maquina.SetTransObject(itr_transaccion)


ids_calendario_novedad = Create uo_dsbase
ids_calendario_novedad.DataObject = 'd_dt_fechas_novedad'
ids_calendario_novedad.SetTransObject(itr_transaccion)

ids_curvas = Create uo_dsbase
ids_curvas.DataObject = 'd_gr_curva'
ids_curvas.SetTransObject(itr_transaccion)

ids_curvas_manuales = Create uo_dsbase
ids_curvas_manuales.DataObject = 'd_gr_curvas_manuales_pdp'
ids_curvas_manuales.SetTransObject(itr_transaccion)

ids_turnos = Create uo_dsbase
ids_turnos.DataObject = 'd_gr_turnos'
ids_turnos.SetTransObject(itr_transaccion)

ids_maquinas = Create uo_dsbase
ids_maquinas.DataObject = 'd_gr_maquinas_x_subcentro'
ids_maquinas.SetTransObject(itr_transaccion)

ids_cuota_maq_ref = Create uo_dsbase
ids_cuota_maq_ref.DataObject = 'd_gr_dt_referencia_x_maquina_pdp'
ids_cuota_maq_ref.SetTransObject(itr_transaccion)


SetNull(idc_a)
SetNull(idc_b)
SetNull(co_tipo_maquina)
SetNull(dias_de_continuidad)
SetNull(co_curva)
SetNull(co_fabrica_cal)
SetNull(co_maquina_cal)

co_tipo_negocio = 1

end event

event destructor;Destroy (ids_calendario_fabrica)
Destroy (ids_calendario_maquina)
Destroy (ids_calendario_novedad)
Destroy (ids_curvas)
Destroy (ids_curvas_manuales)
Destroy (ids_turnos)
Destroy (ids_maquinas)
Destroy (ids_cuota_maq_ref)




end event

