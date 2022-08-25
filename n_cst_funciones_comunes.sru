HA$PBExportHeader$n_cst_funciones_comunes.sru
forward
global type n_cst_funciones_comunes from nonvisualobject
end type
end forward

global type n_cst_funciones_comunes from nonvisualobject autoinstantiate
end type

type prototypes
Function ulong FindWindowA (ulong classname, string windowname) Library "USER32.DLL" alias for "FindWindowA;Ansi"
Function Boolean sndPlaySoundA(String szsound, uLong Flags) Library "WINMM.DLL" alias for "sndPlaySoundA;Ansi"
Function Boolean PlaySoundA(String szsound, uLong hmode, uLong Flags) Library "WINMM.DLL" alias for "PlaySoundA;Ansi"
end prototypes

forward prototypes
public function long of_consecutivo_movimiento ()
public function long of_consecutivo_ordenes (long ai_fabrica, long al_tipo)
public function string of_constaint_descripcion (string as_constraint)
public function boolean of_playsound (string as_sonido, decimal adc_flags)
public function boolean of_playsound (string as_sonido)
public function long of_copiar_prop_sqlca (ref transaction atr_transaccion)
public function long of_terminar_transaccion (ref transaction atr_transaccion)
public function string of_consecutivo_bongo (long ai_fabrica, string as_tipo, long al_cliente)
public function long of_crear_dirty_read (ref transaction atr_transaccion)
public function long of_consecutivo_lote (long an_fabrica, long an_documento)
public function long of_consecutivo_documento (long al_fabrica)
public function long of_fabrica_loteo (long al_fabrica_act)
public function string of_consecutivo_asn (long ai_fabrica, string as_tipo)
public function long of_consecutivos (long an_fabrica, string as_tipo)
public function long of_escribir_archivo (string as_nombre_archivo, string as_ruta, string as_mensaje, string as_mensaje_error)
public function long of_consecutivo_ean (long an_fabrica, string as_tipo)
public function long of_hallar_ano_mes (long ai_fabrica, ref long ai_ano, ref long ai_mes)
public function long of_hallar_origen_destino (string as_tipo_mvto, ref long ai_cpto_salida, ref long ai_cpto_entrada)
public function datetime of_fecha_servidor ()
public function long of_hallar_turno (ref long ai_turno)
public function long of_consecutivo_reporte_asignacion (long an_co_fabrica, long an_co_planta, datetime ldtm_fecha_generacion, boolean ab_generar_consecutivo)
public function uo_dsbase of_loadds (ref uo_dsbase ads_arg, readonly string as_dataobject)
public function string of_cargarestandaresoperacion (readonly long al_fabrica, readonly long al_linea, readonly long al_ref, readonly long ai_tipo, readonly long ai_centro, readonly long ai_constante)
public function string of_validarloteprocesodobladillo (readonly long al_orden_corte, readonly long al_bolsa, readonly long ai_tipoprod, readonly long ai_centro, readonly long ai_constante)
end prototypes

public function long of_consecutivo_movimiento ();/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo para la generaci$$HEX1$$f300$$ENDHEX$$n de 
	consecutivos de movimiento el la base de datos 'proceso'.   
	Retorna el nuevo consecutivo.
	-----------------------------------------------------------------*/
Long ll_consecutivo, ll_fabrica, ll_error
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	RollBack Using SQLCA;
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo de movimiento." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return -4
Else
	Select cs_documento, co_fabrica
		Into :ll_consecutivo, :ll_fabrica
			From cf_consecutivos, m_constantes
				Where id_documento = 61 And
						co_fabrica = numerico And
						var_nombre = "FABRICA_CS_MVTO" Using ltr_transaccion;
	If ltr_transaccion.sqlcode = -1 Then
		RollBack Using SQLCA;
		ll_error = ltr_transaccion.sqldbcode
		RollBack Using ltr_transaccion;
		If ll_error = -244 Then
			Post MessageBox("Error de Base de Datos","Tabla de Consecutivos Bloqueada Temporalmente." &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			
		Else
			Post MessageBox("Error de Base de Datos","Imposible saber el consecutivo actual." &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
		End if
		This.of_terminar_transaccion(ltr_transaccion)
		Return -1
	Else
		ll_consecutivo++
		Update cf_consecutivos
			Set cs_documento = :ll_consecutivo 
				Where id_documento = 61 And
						co_fabrica = :ll_fabrica Using ltr_transaccion;
		If ltr_transaccion.SQLCode = -1 Then
			RollBack Using SQLCA;
			RollBack Using ltr_transaccion;
			Post MessageBox("Error de Base de Datos","Imposible actualizar el consecutivo de movimiento"&
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			This.of_terminar_transaccion(ltr_transaccion)
			Return -2
		Else
			Commit Using ltr_transaccion;
			If ltr_transaccion.SQLCode = -1 Then
				RollBack Using SQLCA;
				RollBack Using ltr_transaccion;
				Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
							+ 'El numero del consecutivo no han sido almacenado en la Base de Datos.' &
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

public function long of_consecutivo_ordenes (long ai_fabrica, long al_tipo);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo para la generaci$$HEX1$$f300$$ENDHEX$$n de 
	consecutivos de ordenes.   Retorna el nuevo consecutivo.
	-----------------------------------------------------------------*/
Long ll_consecutivo, ll_incremento
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo de movimiento." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return -4
Else
	Select nu_enque_esta, incremento
		Into :ll_consecutivo, :ll_incremento
			From cf_consc_ordenes 
				Where co_fabrica = :ai_fabrica And
						tipo_orden = :al_tipo Using ltr_transaccion;
	If ltr_transaccion.sqlcode = -1 Then
		If ltr_transaccion.sqldbcode = -244 Then
			Post MessageBox("Error de Base de Datos","Tabla de Consecutivos Bloqueada Temporalmente." &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
		Else
			Post MessageBox("Error de Base de Datos","Imposible saber el consecutivo actual." &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
		End if
		This.of_terminar_transaccion(ltr_transaccion)
		Return -1
	Else
		ll_consecutivo += ll_incremento
		Update cf_consc_ordenes 
			Set nu_enque_esta = :ll_consecutivo 
				Where co_fabrica = :ai_fabrica And 
						tipo_orden = :al_tipo Using ltr_transaccion;
		If ltr_transaccion.SQLCode = -1 Then
			Post MessageBox("Error de Base de Datos","Imposible actualizar el consecutivo de movimiento"&
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			This.of_terminar_transaccion(ltr_transaccion)
			Return -2
		Else
			Commit Using ltr_transaccion;
			If ltr_transaccion.SQLCode = -1 Then
				RollBack Using ltr_transaccion;
				Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
							+ 'El numero del consecutivo no han sido almacenado en la Base de Datos.' &
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

public function string of_constaint_descripcion (string as_constraint);/*	---------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y retorna la definici$$HEX1$$f300$$ENDHEX$$n del constaint as_constraint
	El datawindow utilizado debe estar ordenado por columna 'segno'.
	---------------------------------------------------------------------*/
String ls_descripcion
Long ll_reg, ll_contador
uo_dsbase lds_constraint

//	Crea el datastore y lee la definici$$HEX1$$f300$$ENDHEX$$n del constraint
lds_constraint  = Create uo_dsbase
lds_constraint.DataObject = 'd_gr_constraint_com'
lds_constraint.SetTransObject(SQLCA)
ll_reg = lds_constraint.Retrieve('T', as_constraint)

//	Arma la definici$$HEX1$$f300$$ENDHEX$$n del constraint
For ll_contador = 1 To ll_reg
	ls_descripcion += Trim(lds_constraint.GetItemString(ll_contador, 'checktext'))
Next

//	Destruye el datastore utilizado durante el proceso
Destroy lds_constraint

Return ls_descripcion
end function

public function boolean of_playsound (string as_sonido, decimal adc_flags);Boolean lbl_retorno

lbl_retorno = sndPlaySoundA(as_sonido,adc_flags)
Return lbl_retorno
end function

public function boolean of_playsound (string as_sonido);Boolean lbl_retorno

lbl_retorno = sndPlaySoundA(as_sonido, 1)
Return lbl_retorno
end function

public function long of_copiar_prop_sqlca (ref transaction atr_transaccion);/*	---------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n utilizada para copiar las propiedades del objeto de transaccion
	SQLCA para el objeto enviado por referencia atr_transacci$$HEX1$$f300$$ENDHEX$$n.
	---------------------------------------------------------------------*/

atr_transaccion.Dbms 		= SQLCA.DBMS
atr_transaccion.Database	= SQLCA.DATABASE
atr_transaccion.Userid		= SQLCA.USERID
atr_transaccion.Dbpass		= SQLCA.DBPASS
atr_transaccion.Dbparm		= SQLCA.DBPARM
atr_transaccion.Servername	= SQLCA.ServerName
atr_transaccion.Lock			= SQLCA.Lock

Return 1
end function

public function long of_terminar_transaccion (ref transaction atr_transaccion);/*	---------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que se desconecta del objeto de transacci$$HEX1$$f300$$ENDHEX$$n enviado como	argumento 
	por referencia atr_transaccion y luego destruye la instancia de memoria.
	---------------------------------------------------------------------------*/
Disconnect Using atr_transaccion;
Destroy atr_transaccion

Return 1
end function

public function string of_consecutivo_bongo (long ai_fabrica, string as_tipo, long al_cliente);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo para la generaci$$HEX1$$f300$$ENDHEX$$n de 
	bongos por fabrica.  Recibe como argumento ai_fabrica, as_tipo
	-----------------------------------------------------------------*/
Long ll_incremento
LongLong ll_consecutivo
Decimal{0} ldc_nu_aviso
String ls_consecutivo, ls_cadena_19, ls_cadena_20, ls_prefijo, ls_de_tipo
Transaction ltr_transaccion


If IsNull(as_tipo) Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El tipo de consecutivo es nulo para el cliente." &
				+ "~r~nPor favor comunicarse con la persona encargada de la administraci$$HEX1$$f300$$ENDHEX$$n de los clientes.", StopSign!)
	Return '-1'
End If

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return '-4'
Else
	Select nu_enque_esta, incremento, nu_aviso, prefijo, de_tipo
		Into :ll_consecutivo, :ll_incremento, :ldc_nu_aviso, :ls_prefijo, :ls_de_tipo
			From cf_consecutivos_ean 
				Where tipo = :as_tipo Using ltr_transaccion;
	If ltr_transaccion.sqlcode = -1 Then
		If ltr_transaccion.sqldbcode = -244 Then
			Post MessageBox("Error de Base de Datos","Tabla de Consecutivos Bloqueada Temporalmente" &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			
		Else
			Post MessageBox("Error de Base de Datos (" + String(ltr_transaccion.sqldbcode)+")","Imposible saber el consecutivo actual de bongos" &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
		End if
		This.of_terminar_transaccion(ltr_transaccion)
		Return '-1'
	ElseIf ltr_transaccion.sqlcode = 100 Then
		Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo hallar el numero del adhesivo porque no " &
							+ "se ha parametrizado el consecutivo (Tipo " + as_tipo + ") en cf_consecutivos_ean.   " &
							+ "~r~nPor favor comunicarse con informatica.")
		This.of_terminar_transaccion(ltr_transaccion)
		Return '-5'
	Else
		ll_consecutivo += ll_incremento
		If IsNull(ls_de_tipo) OR Trim(ls_de_tipo) = '' Then ls_de_tipo = ''
		
		//Se valida que el consecutivo incrementado no sobrepase el valor del numero de Aviso
		If IsNull(ldc_nu_aviso) OR ldc_nu_aviso <= 0 Then
			Post MessageBox('Advertencia','El valor del "n$$HEX1$$fa00$$ENDHEX$$mero de aviso" para el l$$HEX1$$ed00$$ENDHEX$$mite del consecutivo asignado al c$$HEX1$$f300$$ENDHEX$$digo de tipo: "'+&
					as_tipo+'" ('+ls_de_tipo+') no existe o no es v$$HEX1$$e100$$ENDHEX$$lido.'+&
					"~n~nConsulte con el Administrador del Sistema o con el Depto. de Inform$$HEX1$$e100$$ENDHEX$$tica",Exclamation!)			
		ElseIf ll_consecutivo >= ldc_nu_aviso Then
			Post MessageBox('Advertencia','El consecutivo generado para el c$$HEX1$$f300$$ENDHEX$$digo de tipo: "'+as_tipo+'" ('+ls_de_tipo+') --> "'+&
					String(ll_consecutivo)+'" , es igual o ha sobrepasado el valor de aviso: "'+String(ldc_nu_aviso)+'"'+&
					"~n~nComunique este evento al personal del Depto. de Inform$$HEX1$$e100$$ENDHEX$$tica",Exclamation!)
		End If		
		
		ls_prefijo = Trim(ls_prefijo)
		ls_de_tipo = Trim(ls_de_tipo)
		
		Choose Case Trim(as_tipo)
			Case 'BC'	//	Bongo Corte
				//Completa a 7 digitos el consecutivo interno anteponiendo 0000..
				ls_consecutivo = Right('0000000' + String(ll_consecutivo),7)
				
				ls_consecutivo = Right(ls_consecutivo, 7)
				ls_cadena_19 = ls_prefijo + ls_consecutivo
				ls_cadena_20 = ls_cadena_19 + Trim(f_digito_de_control_ucc128(ls_cadena_19))
			Case 'N','C'	//	Cliente Vestimundo
				//Completa a 9 digitos el consecutivo interno anteponiendo 0000..
				ls_consecutivo = Right('000000000' + String(ll_consecutivo),9)
				
				ls_cadena_19 = Trim(ls_prefijo) + ls_consecutivo
				ls_cadena_20 = ls_cadena_19
			Case 'CT'	//	Cliente Caltexa
				//Completa a 8 digitos el consecutivo interno anteponiendo 0000..
				ls_consecutivo = Right('00000000' + String(ll_consecutivo),8)
				
				ls_consecutivo = Right(String(ls_consecutivo),8)
				ls_cadena_19 = ls_consecutivo + Trim(f_digito_de_control_ucc128(ls_consecutivo)) 
				ls_cadena_20 = 'G' + ls_cadena_19 
			Case 'JO'	//	Cliente Jockey
				//Completa a 7 digitos el consecutivo interno anteponiendo 0000..
				ls_consecutivo = Right('0000000' + String(ll_consecutivo),7)
				
				ls_cadena_19 = Right(ls_consecutivo,7)
				ls_cadena_20 = ls_prefijo + ls_cadena_19
			Case 'AN'
				//Completa a 11 digitos el consecutivo interno anteponiendo 0000..
				ls_consecutivo = Right('00000000000' + String(ll_consecutivo),11)
				
				ls_cadena_19 = Right(ls_consecutivo,11)
				ls_cadena_20 = ls_prefijo + ls_cadena_19
			Case Else
				//Completa a 9 digitos el consecutivo interno anteponiendo 0000..
				ls_consecutivo = Right('000000000' + String(ll_consecutivo),9)
				
				If IsNull(ls_prefijo) OR Trim(ls_prefijo) = '' Then
					Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n - Error de Informaci$$HEX1$$f300$$ENDHEX$$n','El valor del prefijo para el c$$HEX1$$f300$$ENDHEX$$digo de tipo: "'+as_tipo+'" ('+ls_de_tipo+') no existe o no es v$$HEX1$$e100$$ENDHEX$$lido.'+&
							"~n~nConsulte con el Administrador del Sistema o con el Depto. de Inform$$HEX1$$e100$$ENDHEX$$tica",StopSign!)
					This.of_terminar_transaccion(ltr_transaccion)
					Return '-6'
				End If
				
				ls_cadena_19 = ls_prefijo + ls_consecutivo
				ls_cadena_20 = ls_cadena_19 + Trim(f_digito_de_control_ucc128(ls_cadena_19))
		End Choose
		
		Update cf_consecutivos_ean 
			Set nu_enque_esta = :ll_consecutivo 
				Where tipo = :as_tipo Using ltr_transaccion;
		If ltr_transaccion.SQLCode = -1 Then
			Post MessageBox("Error de Base de Datos ("+ String(ltr_transaccion.SQLCode)+")","Imposible actualizar el consecutivo de bongos"&
						+ "~r~nConsulte con el administrador este problema." , StopSign!)
			This.of_terminar_transaccion(ltr_transaccion)
			Return '-2'
		Else
			Commit Using ltr_transaccion;
			If ltr_transaccion.SQLCode = -1 Then
				RollBack Using ltr_transaccion;
				Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
							+ 'El numero del Bongo no han sido almacenado en la Base de Datos.' &
							+ '~nPor favor avise al Administrador del Sistema.')
				This.of_terminar_transaccion(ltr_transaccion)
				Return '-3'
			End If
		End If
	End If
	Disconnect Using ltr_transaccion;
End If

Destroy ltr_transaccion
Return ls_cadena_20
end function

public function long of_crear_dirty_read (ref transaction atr_transaccion);/*	---------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n utilizada para copiar las propiedades del objeto de transaccion
	SQLCA para el objeto enviado por referencia atr_transacci$$HEX1$$f300$$ENDHEX$$n.
	---------------------------------------------------------------------*/

atr_transaccion.Dbms 		= SQLCA.DBMS
atr_transaccion.Database	= SQLCA.DATABASE
atr_transaccion.Userid		= SQLCA.USERID
atr_transaccion.Dbpass		= SQLCA.DBPASS
atr_transaccion.Dbparm		= SQLCA.DBPARM
atr_transaccion.Servername	= SQLCA.ServerName
atr_transaccion.Lock			= "Dirty Read"

Return 1
end function

public function long of_consecutivo_lote (long an_fabrica, long an_documento);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo para el lote.  
	Recibe como argumento an_fabrica, an_documento
	-----------------------------------------------------------------*/
Long ll_consecutivo, ll_incremento
String ls_consecutivo, ls_cadena_19, ls_cadena_20, ls_digito_de_control, ls_instruccion
Transaction ltr_transaccion

ls_instruccion = "SET LOCK MODE TO WAIT 20"
Execute Immediate :ls_instruccion ;
If SQLCA.SQLCODE = -1 Then
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la instrucci$$HEX1$$f300$$ENDHEX$$n SET LOCK MODE TO WAIT 20 ~n~n" &
				+ "Otro usuario esta creando un lote espere unos segundos antes de reintentar.~n~n" + sqlca.sqlerrtext, StopSign!)
   Return -1
End If

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)

	This.of_terminar_transaccion(ltr_transaccion)
	Return -4
Else
	Select cs_documento
		Into :ll_consecutivo
			From cf_consecutivos_conf 
				Where co_fabrica = :an_fabrica And
						id_documento = :an_documento Using ltr_transaccion;
	If ltr_transaccion.sqlcode = -1 Then
		If ltr_transaccion.sqldbcode = -244 Then
			Post MessageBox("Error de Base de Datos","Tabla de Consecutivos Bloqueada Temporalmente" &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
			
		Else
			Post MessageBox("Error de Base de Datos (" + String(ltr_transaccion.sqldbcode) + ")","Imposible saber el consecutivo actual" &
						+ "~r~nConsulte con el administrador este problema.", StopSign!)
		End if

		This.of_terminar_transaccion(ltr_transaccion)
		Return -1
	Else
		ll_consecutivo += 1
		
		Update cf_consecutivos_conf
			Set cs_documento = :ll_consecutivo 
				Where co_fabrica = :an_fabrica And 
						id_documento = :an_documento Using ltr_transaccion;
		If ltr_transaccion.SQLCode = -1 Then
			Post MessageBox("Error de Base de Datos(" + String(ltr_transaccion.sqldbcode) + ")","Imposible actualizar el consecutivo"&
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

public function long of_consecutivo_documento (long al_fabrica);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo para el documento,
	usado para ingresar un registro en h_kardex
	Recibe como argumento al_fabrica
	-----------------------------------------------------------------*/
Long ll_cs_documento
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return -4
Else
	SELECT cs_documento INTO :ll_cs_documento           
	FROM cf_consecutivos_matemp                               
	WHERE id_documento = 99                              
	AND co_fabrica = :al_fabrica Using ltr_transaccion;
	
	
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
	Else
		ll_cs_documento += 1
		
		UPDATE cf_consecutivos_matemp                            
	   SET cs_documento = :ll_cs_documento     
	   WHERE id_documento = 99 
		AND co_fabrica = :al_fabrica Using ltr_transaccion;
		
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
Return ll_cs_documento
end function

public function long of_fabrica_loteo (long al_fabrica_act);Long li_fabrica_loteo
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para consultar la fabrica que lotea." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return -1
Else
	Select co_fabrica_loteo
	Into :li_fabrica_loteo
	From m_fabrica_loteo
	Where co_fabrica_act = :al_fabrica_act Using ltr_transaccion;
	
	If ltr_transaccion.sqlcode = -1 Then
		Post MessageBox("Error de Base de Datos","Imposible saber la fabrica que lotea" &
					+ "~r~nConsulte con el administrador este problema.", StopSign!)
   	This.of_terminar_transaccion(ltr_transaccion)
		Return -2	
	ElseIf ltr_transaccion.sqlcode = 100 Then
		Post MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","No existe registro de la fabrica que lotea" &
					+ "~r~nConsulte con el administrador este problema.", StopSign!)
   	This.of_terminar_transaccion(ltr_transaccion)
		Return -3	
	End if
		
End If

Disconnect using ltr_transaccion;
Destroy ltr_transaccion

Return li_fabrica_loteo
end function

public function string of_consecutivo_asn (long ai_fabrica, string as_tipo);/*******************************************************************************************************
* PROC./FUNC.: of_consecutivo_asn
* ARG.		 : Long (By Value): 	ai_fabrica 	- C$$HEX1$$f300$$ENDHEX$$digo de la f$$HEX1$$e100$$ENDHEX$$brica
					String  (By Value): 	as_tipo		- C$$HEX1$$f300$$ENDHEX$$digo del tipo
* RETURN		 : String - C$$HEX1$$f300$$ENDHEX$$digo para el ASN generado del consecutivo
* SCOPE		 : Public
* PURPOSE	 :	Funci$$HEX1$$f300$$ENDHEX$$n que genera el c$$HEX1$$f300$$ENDHEX$$digo para el asn que se asignar$$HEX2$$e1002000$$ENDHEX$$a los registros.
* PRECOND.	 : * C$$HEX1$$f300$$ENDHEX$$digo de la f$$HEX1$$e100$$ENDHEX$$brica y el tipo deben estar creados en la tabla
					* Valor del consecutivo este dentro del l$$HEX1$$ed00$$ENDHEX$$mite de su valor.
* POSTCOND.	 : * Se incrementa y actualiza el consecutivo para el concepto de la f$$HEX1$$e100$$ENDHEX$$brica y tipo
					* Se obtiene el c$$HEX1$$f300$$ENDHEX$$digo para el ASN compuesto de la cadena est$$HEX1$$e100$$ENDHEX$$tica inicial + consecutivo
* BUGS/LIMITS:	None Known
* INVOKED BY : w_administracion_master_bill_corte.of_asignar_consecutivo
* DEVELOPER	 : Carlos Andr$$HEX1$$e900$$ENDHEX$$s Rico
* DATE		 :	Lunes 03 de Marzo de 2005. Hora: 17:16:02
********************************************************************************************************/
//VARIABLE DECLARATION
Long 				ll_consecutivo, ll_incremento, ll_nu_inicio, ll_nu_final
String 			ls_consecutivo, ls_cadena_19,ls_cadena_20, ls_cadena_asn, ls_digito_de_control
Transaction 	ltr_transaccion
//BEGIN SCRIPT------------------------------------------------------------------------------------------------------
ltr_transaccion = CREATE Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
//****************************************
CONNECT USING ltr_transaccion;
//****************************************
If ltr_transaccion.sqlcode = -1 Then
		Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo." &
					+ "~r~nConsulte con el administrador este problema.", StopSign!)
		This.of_terminar_transaccion(ltr_transaccion)
		Return '-4'
Else
		//***SQL STATEMENT***************************************
		SELECT 	 nu_enque_esta, incremento, nu_inicio, nu_final
		  INTO 	:ll_consecutivo, :ll_incremento, :ll_nu_inicio, :ll_nu_final
		  FROM 	cf_consecutivos_ean 
		 WHERE 	co_fabrica = :ai_fabrica AND
					tipo = :as_tipo 
		 USING	ltr_transaccion;
		//***SQL STATEMENT***************************************
		If ltr_transaccion.sqlcode = -1 Then
				If ltr_transaccion.sqldbcode = -244 Then
					Post MessageBox("Error de Base de Datos","Tabla de Consecutivos Bloqueada Temporalmente" &
								+ "~r~nConsulte con el administrador este problema.", StopSign!)
					
				Else
					Post MessageBox("Error de Base de Datos","Imposible saber el consecutivo actual de ASN" &
								+ "~r~nConsulte con el administrador este problema.", StopSign!)
				End if
				This.of_terminar_transaccion(ltr_transaccion)
				Return '-1'
		Else						
				If IsNull(ll_consecutivo*ll_incremento*ll_nu_inicio*ll_nu_final) Then
						Post MessageBox("Error de Base de Datos","Los datos consultados no son v$$HEX1$$e100$$ENDHEX$$lidos. Puede existir una incosistencia de valores." &
									+ "~r~nConsulte con el administrador este problema.", StopSign!)
						This.of_terminar_transaccion(ltr_transaccion)
						Return '-1'
				End If
				//Se asigna de nuevo el valor de inicio para el consecutivo actual si esta llegando a su l$$HEX1$$ed00$$ENDHEX$$mite
				If (ll_consecutivo+ll_incremento >= ll_nu_final) Then
						ll_consecutivo = ll_nu_inicio
				Else
						ll_consecutivo += ll_incremento					
				End If			
				//***SQL STATEMENT***************************************			
				UPDATE	cf_consecutivos_ean 
					SET 	nu_enque_esta = :ll_consecutivo 
				 WHERE 	co_fabrica = :ai_fabrica AND
							tipo = :as_tipo 
				 USING   ltr_transaccion;
				//***SQL STATEMENT***************************************			
				If ltr_transaccion.SQLCode = -1 Then
						Post MessageBox("Error de Base de Datos","Imposible actualizar el consecutivo de bongos"&
									+ "~r~nConsulte con el administrador este problema.", StopSign!)
						This.of_terminar_transaccion(ltr_transaccion)
						Return '-2'
				Else
						//***SQL STATEMENT***************************************
						COMMIT USING ltr_transaccion;
						//***SQL STATEMENT***************************************
						If ltr_transaccion.SQLCode = -1 Then
								//***SQL STATEMENT***************************************
								ROLLBACK Using ltr_transaccion;
								//***SQL STATEMENT***************************************
								Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'COMMIT' ha fallado; " &
											+ 'El n$$HEX1$$fa00$$ENDHEX$$mero del ASN no han sido almacenado en la Base de Datos.' &
											+ '~nPor favor avise al Administrador del Sistema.')
								This.of_terminar_transaccion(ltr_transaccion)
								Return '-3'
						End If
				End If
		End If
		//****************************************
		DISCONNECT USING ltr_transaccion;
		//****************************************
End If
DESTROY ltr_transaccion
//Completa a 5 digitos el consecutivo interno anteponiendo 00000..
ls_consecutivo = Right('00000' + String(ll_consecutivo),5)
ls_cadena_asn = "00Z57" + ls_consecutivo	

Choose Case as_tipo
		Case "XJ"/*Consec.ASN*/,"AJ"/*Numero control intercambio*/ //XML JONES
				ls_cadena_asn = String(ll_consecutivo)
End Choose
//------------------------------------------------------------------------------------------------------
Return ls_cadena_asn
//END SCRIPT------------------------------------------------------------------------------------------------------

end function

public function long of_consecutivos (long an_fabrica, string as_tipo);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo en la tabla de 
	cf_consecutivos_ean.   Recibe como argumento ai_fabrica, as_tipo
	-----------------------------------------------------------------*/
Long ll_consecutivo, ll_incremento
String ls_cadena_19, ls_cadena_20, ls_digito_de_control
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
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
				Where co_fabrica = :an_fabrica And tipo = :as_tipo Using ltr_transaccion;
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
							+ "se ha parametrizado el consecutivo (Fab: " + String(an_fabrica) &
							+ " Tipo "+ as_tipo + ") en cf_consecutivos_ean.   " &
							+ "~r~nPor favor comunicarse con informatica.")
		Return -5		
	Else
		ll_consecutivo += ll_incremento
		Update cf_consecutivos_ean 
			Set nu_enque_esta = :ll_consecutivo 
				Where co_fabrica = :an_fabrica And tipo = :as_tipo Using ltr_transaccion;
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

public function long of_escribir_archivo (string as_nombre_archivo, string as_ruta, string as_mensaje, string as_mensaje_error);Long ll_filenum


ll_filenum = FileOpen(as_ruta + "\"+as_nombre_archivo, linemode!, Write!)
If ll_filenum > 0 Then
	If FileWrite(ll_filenum, as_mensaje) <> -1 Then	//	Escribio al archivo de errores
		FileClose(ll_filenum)
	Else
		MessageBox("Aviso Importante", "No se logro escribir al archivo de " + as_mensaje_error &
					+ "~nPor favor avise al Administrador de este problema", StopSign!)
		FileClose(ll_filenum)
	End If
Else
	MessageBox("Aviso Importante", "No se logro abrir el archivo de " + as_mensaje_error &
				+ "~nPor favor avise al Administrador de este problema", StopSign!)
End If

Return ll_filenum
end function

public function long of_consecutivo_ean (long an_fabrica, string as_tipo);/*	-----------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n que encuentra y fija un consecutivo en la tabla de 
	cf_consecutivos_ean.   Recibe como argumento ai_fabrica, as_tipo,
	verifica que no se este agotando y se muestra el aviso
	-----------------------------------------------------------------*/
Long ll_consecutivo, ll_incremento, ll_nu_final, ll_nu_aviso
Transaction ltr_transaccion

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;
If ltr_transaccion.sqlcode = -1 Then
	Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible conectarse a la Base de datos para crear el consecutivo." &
				+ "~r~nConsulte con el administrador este problema.", StopSign!)
	This.of_terminar_transaccion(ltr_transaccion)
	Return -4
Else
	SELECT  
		nu_enque_esta, incremento, nu_final, nu_aviso
	INTO :ll_consecutivo, :ll_incremento, :ll_nu_final, :ll_nu_aviso
			From cf_consecutivos_ean 
				Where co_fabrica = :an_fabrica And tipo = :as_tipo Using ltr_transaccion;
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
							+ "se ha parametrizado el consecutivo (Fab: " + String(an_fabrica) &
							+ " Tipo "+ as_tipo + ") en cf_consecutivos_ean.   " &
							+ "~r~nPor favor comunicarse con informatica.")
		Return -5		
	Else
		If ll_consecutivo >= ll_nu_final Then
			Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Consecutivo de Ean se Agot$$HEX1$$f300$$ENDHEX$$.~r~n" &
					+ "Por favor tramite un nuevo rango de Eanes", StopSign!)
			This.of_terminar_transaccion(ltr_transaccion)
			Return -6
			
		End If
		
		ll_consecutivo += ll_incremento
		Update cf_consecutivos_ean 
			Set nu_enque_esta = :ll_consecutivo 
				Where co_fabrica = :an_fabrica And tipo = :as_tipo Using ltr_transaccion;
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
		
		If ll_consecutivo >= ll_nu_aviso Then
			Post MessageBox("Aviso...","Consecutivo de Ean se esta Agotando!~r~n" &
					+ "Quedan " + String( (ll_nu_final - ll_consecutivo) /ll_incremento) + " consecutivos.~r~n" &
					+ "Por favor tramite con tiempo un nuevo rango de Eanes" &
					,Information!,Ok!)					
		End If
		
	End If
	Disconnect Using ltr_transaccion;
End If

Destroy ltr_transaccion
Return ll_consecutivo
end function

public function long of_hallar_ano_mes (long ai_fabrica, ref long ai_ano, ref long ai_mes);//	Ejecuta y valida procedimiento almacenado para traer el a$$HEX1$$f100$$ENDHEX$$o mes del usuario y si
//	es satisfactorio, retorna el ano y el mes en las variables por referencia enviadas
Long li_nulo
String ls_error
Date ld_ano_mes

Declare pr_ano_mes Procedure For pr_ano_mes(:ai_fabrica);
Execute pr_ano_mes;
If SQLCA.SQLCODE = -1 Then
	ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
	RollBack;
	MessageBox("Atencion", "Error hallando el ano - mes para la fabrica " + String(ai_fabrica) + ls_error, StopSign!)
	Close pr_ano_mes;
	Return -1
End If

Fetch pr_ano_mes Into :ld_ano_mes;
If SQLCA.SQLCODE = -1 Or SQLCA.SQLCODE = 100 Then
	ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
	Close pr_ano_mes;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo al cargar el ano - mes retornado por procedimiento pr_ano_mes" + ls_error)
	Return -2
End If

// Cierra el procedimiento almacenado declarado
Close pr_ano_mes;

If ld_ano_mes > 1900-01-01 Then
	ai_ano = Year(ld_ano_mes)
	ai_mes = Month(ld_ano_mes)
Else
	Beep(1)
	SetNull(li_nulo)
	ai_ano = li_nulo
	ai_mes = li_nulo
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible encontrar el a$$HEX1$$f100$$ENDHEX$$o y mes del usuario actual para la fabrica " &
				+ String(ai_fabrica), StopSign!)
	Return -3
End If

Return 1
end function

public function long of_hallar_origen_destino (string as_tipo_mvto, ref long ai_cpto_salida, ref long ai_cpto_entrada);/*	---------------------------------------------------------------------
	Funcion utilizada paca hallar el origen y el destino de la canasta
	para hacer los llamados al procedimeinto pr_graba_pdn.
	---------------------------------------------------------------------*/
String ls_origen_destino, ls_error

//	Ejecuta y valida procedimiento almacenado para traer conceptos de origen y destino
//	y si es satisfactorio, inicializa variables para llamar pr_graba_pdn de ajuste

Declare pr_origen_destino Procedure For pr_origen_destino(:as_tipo_mvto);
Execute pr_origen_destino;
If SQLCA.SQLCODE = -1 Then
	ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
	RollBack;
	MessageBox("Atencion", "Error hallando el origen - destino para el tipo mvto " + as_tipo_mvto + ls_error, StopSign!)
	Close pr_origen_destino;
	Return -1
End If

Fetch pr_origen_destino Into :ls_origen_destino;
If SQLCA.SQLCODE = -1 Or SQLCA.SQLCODE = 100 Then
	ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
	Close pr_origen_destino;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo al cargar el origen - destino retornado por procedimiento pr_origen_destino" + ls_error)
	Return -2
End If

// Cierra el procedimiento almacenado declarado
Close pr_origen_destino;

If ls_origen_destino <> '0*0' Then
	ai_cpto_salida = Long(Left(ls_origen_destino,Pos(ls_origen_destino,'*') - 1))
	ai_cpto_entrada = Long(Mid(ls_origen_destino,Pos(ls_origen_destino,'*') + 1))
Else
	Beep(1)
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible encontrar los conceptos de origen y destino (" + as_tipo_mvto + ")", StopSign!)
	Return -3
End If

Return 1
end function

public function datetime of_fecha_servidor ();DateTime ldt_fecha

SELECT Current
INTO	:ldt_fecha
FROM	systables
WHERE tabid = 1;

IF SQLCA.SQLCode = -1 Or SQLCA.SQLCode = 100 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","Error al consultar la fecha del servidor; Consulte con informatica por favor.", StopSign!)
	SetNull(ldt_fecha)
END IF

Return(ldt_fecha)

end function

public function long of_hallar_turno (ref long ai_turno);Long li_hora_turno
String ls_error

//Se obtiene la hora del servidor
li_hora_turno = hour(time(f_fecha_servidor()))

//	Declara y Ejecuta procedimiento almacenado pr_turno utilizando la hora
Declare pr_turno Procedure For pr_turno(:li_hora_turno);
Execute pr_turno;
If SQLCA.SQLCODE = -1 Then
	ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
	RollBack;
	MessageBox("Atencion", "Error hallando turno para la hora " + String(li_hora_turno) + ls_error, StopSign!)
	Close pr_turno;
	Return -1
End If

// Carga el turno devuelto por el sp pr_turno
Fetch pr_turno Into :ai_turno;
If SQLCA.SQLCODE = -1 Or SQLCA.SQLCODE = 100 Then
	ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
	Close pr_turno;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo al cargar el turno retornado por procedimiento pr_turno" + ls_error)
	Return -2
End If

// Cierra el procedimiento almacenado declarado
Close pr_turno;

Return 1

end function

public function long of_consecutivo_reporte_asignacion (long an_co_fabrica, long an_co_planta, datetime ldtm_fecha_generacion, boolean ab_generar_consecutivo);/* Funci$$HEX1$$f300$$ENDHEX$$n para generar los consecutivos para el reporte de
	asignaci$$HEX1$$f300$$ENDHEX$$n de bongos*/
long ll_ret, ll_consecutivo
uo_dsbase lds_consecutivo
Transaction ltr_transaccion
Datetime ldtm_fecha_servidor, ldtm_fecha_ultima, ldtm_fecha_penultima, ldtm_fecha_antepenultima	 

ltr_transaccion = Create Transaction
This.of_copiar_prop_sqlca(ltr_transaccion)
Connect Using ltr_transaccion;

lds_consecutivo = Create uo_dsbase
lds_consecutivo.DataObject = 'd_gr_consecutivo_asignacion_bongos_pdp'
lds_consecutivo.SetTransObject(ltr_transaccion)

ldtm_fecha_servidor = f_fecha_servidor()


ll_ret = lds_consecutivo.of_retrieve(an_co_fabrica, an_co_planta)


IF ll_ret < 0 Then
	This.of_terminar_transaccion(ltr_transaccion)
	MessageBox("Error","Error al obtener el consecutivo para el reporte de asignaci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
Elseif ll_ret = 0 Then
	
	//Ponemos como la ultima fecha
	ldtm_fecha_ultima = ldtm_fecha_generacion//DateTime(RelativeDate(Date(ldtm_fecha_generacion),-7),Time("00:00:00"))
	//Ponemos como la ultima fecha, la fecha actual menos una semana
	ldtm_fecha_penultima = DateTime(RelativeDate(Date(ldtm_fecha_generacion),-7),Time("00:00:00"))
	//Ponemos como la ultima fecha, la fecha actual menos dos semanas
	ldtm_fecha_antepenultima= DateTime(RelativeDate(Date(ldtm_fecha_generacion),-14),Time("00:00:00"))
	
	lds_consecutivo.InsertRow(0)
	lds_consecutivo.SetITem(1,'co_fabrica',an_co_fabrica)
	lds_consecutivo.SetITem(1,'co_planta',an_co_planta)
	lds_consecutivo.SetITem(1,'cs_asignacion',1)
	lds_consecutivo.SetITem(1,'fe_ultima',ldtm_fecha_ultima )
	lds_consecutivo.SetITem(1,'fe_penultima',ldtm_fecha_penultima )
	lds_consecutivo.SetITem(1,'fe_antepenultima',ldtm_fecha_antepenultima )
	lds_consecutivo.SetITem(1,'fe_actualizacion',ldtm_fecha_servidor )
	lds_consecutivo.SetITem(1,'fe_creacion',ldtm_fecha_servidor )
	lds_consecutivo.SetITem(1,'usuario',gstr_info_usuario.codigo_usuario)
	lds_consecutivo.SetITem(1,'instancia',gstr_info_usuario.instancia)
	ll_consecutivo = 1
Else
	
	//Modificamos las fechas, la de generaci$$HEX1$$f300$$ENDHEX$$n es la $$HEX1$$fa00$$ENDHEX$$ltima, la que era la $$HEX1$$fa00$$ENDHEX$$ltima ahora es la pen$$HEX1$$fa00$$ENDHEX$$ltima y la penultima es la antepenultima
	ldtm_fecha_ultima = ldtm_fecha_generacion
	ldtm_fecha_penultima = lds_consecutivo.GetItemDateTime(1,'fe_ultima')
	ldtm_fecha_antepenultima = lds_consecutivo.GetItemDateTime(1,'fe_penultima')
	
	IF ab_generar_consecutivo THen
		ll_consecutivo = 	lds_consecutivo.GetItemNumber(1,'cs_asignacion') + 1
		lds_consecutivo.SetITem(1,'cs_asignacion',ll_consecutivo)
	ELse
		ll_consecutivo = 0
	ENd IF	
	lds_consecutivo.SetITem(1,'fe_ultima',ldtm_fecha_ultima )
	lds_consecutivo.SetITem(1,'fe_penultima',ldtm_fecha_penultima )
	lds_consecutivo.SetITem(1,'fe_antepenultima',ldtm_fecha_antepenultima )
	lds_consecutivo.SetITem(1,'fe_actualizacion',ldtm_fecha_servidor )
	lds_consecutivo.SetITem(1,'usuario',gstr_info_usuario.codigo_usuario)
	lds_consecutivo.SetITem(1,'instancia',gstr_info_usuario.instancia)
		
End IF	

If lds_consecutivo.update() < 0 Then
	RollBack Using ltr_transaccion;
	This.of_terminar_transaccion(ltr_transaccion)
	MessageBox("Error","Error al obtener el consecutivo para el reporte de asignaci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
Else
	Commit Using ltr_transaccion;
	If ltr_transaccion.SQLCode = -1 Then
		RollBack Using ltr_transaccion;
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
					+ 'El consecutivo no ha sido almacenado en la Base de Datos.' &
					+ '~nPor favor avise al Administrador del Sistema.')
		This.of_terminar_transaccion(ltr_transaccion)
		Return -3
	End IF	
End If

This.of_terminar_transaccion(ltr_transaccion)
Return ll_consecutivo	

	





end function

public function uo_dsbase of_loadds (ref uo_dsbase ads_arg, readonly string as_dataobject);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : of_LoadDs
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
ads_arg 					= CREATE uo_dsbase
ads_arg.dataobject	= as_DataObject
ads_arg.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
return ads_arg 
end function

public function string of_cargarestandaresoperacion (readonly long al_fabrica, readonly long al_linea, readonly long al_ref, readonly long ai_tipo, readonly long ai_centro, readonly long ai_constante);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : of_cargarEstandaresOperacion 
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_filas, ll_fila
String				ls_retorno, ls_operaciones
uo_dsbase 			lds_estandar_x_operacion

lds_estandar_x_operacion = THIS.of_loadDS(lds_estandar_x_operacion,'d_sq_gr_estandares_operaciones')
ll_filas = lds_estandar_x_operacion.of_retrieve(al_fabrica,al_linea,al_ref,ai_tipo,ai_centro,ai_constante)
IF ll_filas > 0 THEN 
	FOR ll_fila = 1 TO lds_estandar_x_operacion.rowCount()
		ls_operaciones = ls_operaciones + lds_estandar_x_operacion.getItemString(ll_fila,'de_operacion')+ '~n'
	NEXT 
END IF 

IF IsNull(ls_operaciones) OR Len(Trim(ls_operaciones)) = 0 THEN 
	SetNull(ls_operaciones)
ELSE 
	ls_retorno	= ' lleva las siguientes operaciones en confecci$$HEX1$$f300$$ENDHEX$$n:~n' 
	ls_retorno 	= ls_retorno+  ls_operaciones 
END IF 
RETURN ls_retorno 
end function

public function string of_validarloteprocesodobladillo (readonly long al_orden_corte, readonly long al_bolsa, readonly long ai_tipoprod, readonly long ai_centro, readonly long ai_constante);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : of_validarLoteProcesoDobladillo
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno, ll_filas, ll_fabrica, ll_linea, ll_ref ,ll_fila 
String				ls_de_ref, ls_mensaje, ls_operaciones, ls_null
uo_dsbase 			lds_dt_pdnxmodulo_x_ref, lds_estandar_x_operacion

SetNull(ls_null)
lds_dt_pdnxmodulo_x_ref = THIS.of_loadDS(lds_dt_pdnxmodulo_x_ref,'d_sq_gr_dt_pdnxmodulo_x_h_prererf_pv')
//ll_filas = lds_dt_pdnxmodulo_x_ref.of_retrieve(al_orden_corte,al_bolsa)  se modifica d_sq_gr_dt_pdnxmodulo_x_h_prererf_pv eliminandole la bolsa no se requiere

ll_filas = lds_dt_pdnxmodulo_x_ref.of_retrieve(al_orden_corte)
IF ll_filas > 0 THEN 
	FOR ll_fila = 1 TO lds_dt_pdnxmodulo_x_ref.ROWCOUNT()
		ll_fabrica	= lds_dt_pdnxmodulo_x_ref.getItemNumber(ll_fila,'co_fabrica')  
		ll_linea		= lds_dt_pdnxmodulo_x_ref.getItemNumber(ll_fila,'co_linea')  
		ll_ref		= lds_dt_pdnxmodulo_x_ref.getItemNumber(ll_fila,'co_referencia')  
		ls_de_ref 	= lds_dt_pdnxmodulo_x_ref.getItemString(ll_fila,'de_referencia') 
	
		ls_operaciones = THIS.of_cargarEstandaresOperacion(ll_fabrica,ll_linea,ll_ref,ai_tipoprod, ai_centro,ai_constante)
		IF LEN(TRIM(ls_operaciones)) = 0 THEN ls_operaciones = ls_null
		IF NOT(IsNull(ls_operaciones)) THEN 
			IF LEN(TRIM(ls_mensaje)) = 0 THEN 
				ls_mensaje = 'La referencia: '+TRIM(ls_de_ref)+' '+ ls_operaciones
			ELSE 
				ls_mensaje = ls_mensaje +'~nLa referencia: '+ TRIM(ls_de_ref)+' '+ ls_operaciones 
			END IF 
		END IF

	NEXT
END IF 

IF LEN(TRIM(ls_mensaje)) = 0 THEN ls_mensaje = ls_null
IF NOT(IsNull(ls_mensaje)) THEN 
	RETURN ls_mensaje 
ELSE 
	RETURN ls_null 
END IF 


end function

on n_cst_funciones_comunes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_funciones_comunes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

