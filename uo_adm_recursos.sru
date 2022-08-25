HA$PBExportHeader$uo_adm_recursos.sru
forward
global type uo_adm_recursos from nonvisualobject
end type
end forward

global type uo_adm_recursos from nonvisualobject
end type
global uo_adm_recursos uo_adm_recursos

type prototypes
FUNCTION ulong CreateMutexA(ulong lpMutexAttributes, boolean bInitialOwner, REF string lpszName) LIBRARY "kernel32.dll" alias for "CreateMutexA;Ansi"
FUNCTION boolean ReleaseMutex (ulong hMutex) LIBRARY "kernel32.dll"
FUNCTION ulong WaitForSingleObject (ulong hHandle, ulong dwMilliseconds) LIBRARY "kernel32.dll"
FUNCTION boolean CloseHandle (long hObject) LIBRARY "kernel32.dll"
FUNCTION long GetLastError () LIBRARY "kernel32.dll"

end prototypes

type variables
uLong	sl_mutex_handle
Transaction itr_sucia
end variables

forward prototypes
public function boolean of_crear_instancia_aplicacion (readonly application a_aplicacion)
public subroutine of_destruir_instancia_aplicacion ()
public function long of_crear_dirty_read ()
public function long of_reconectar_dirty_read ()
public function long of_destruir_dirty_read ()
public function transaction of_get_transaccion_sucia ()
public function long of_get_transaccion_sucia (ref transaction atr_transaccion)
public function long of_registrar_paso (string as_mensaje)
public function long of_ver_inconsistencias ()
public function long of_registrar_log (string as_mensaje)
end prototypes

public function boolean of_crear_instancia_aplicacion (readonly application a_aplicacion);
constant ulong ERROR_ALREADY_EXISTS = 183
constant ulong SUCCESSFUL_EXECUTION = 0
constant ulong WAIT_OBJECT_0 = 0
constant ulong WAIT_TIMEOUT = 258
//constant ulong WAIT_ABANDONED = ??

uLong		l_dummy, &
			lul_last_error, &
			lul_mutex_state
String	ls_mutex_name
Boolean	lb_aplicacion_corriendo

ls_mutex_name = a_aplicacion.ClassName()

sl_mutex_handle = CreateMutexA (l_dummy, FALSE, ls_mutex_name)
lul_last_error = GetLastError()

CHOOSE CASE lul_last_error
	CASE SUCCESSFUL_EXECUTION
		lul_mutex_state = WaitForSingleObject (sl_mutex_handle, 0)
		lb_aplicacion_corriendo = FALSE

	CASE ERROR_ALREADY_EXISTS
		lul_mutex_state = WaitForSingleObject (sl_mutex_handle, 0)
		CHOOSE CASE lul_mutex_state
			CASE WAIT_OBJECT_0
				lb_aplicacion_corriendo = FALSE
			CASE WAIT_TIMEOUT
				lb_aplicacion_corriendo = TRUE
			CASE ELSE
				lul_last_error = GetLastError()
				MessageBox ('Error!', 'Un error inesperado resulto cuando se estaba tratando de ' + &
											 'registrar la aplicacion con MS Windows.' + &
											 '~r~nEl mutex existe y WaitForSingleObject ' + &
											 'fue retornado ' + String (lul_last_error) + '.~r~n' + &
											 'Por favor contacte al Administrador del Sistema.', &
											 Exclamation!)
				lb_aplicacion_corriendo = TRUE
		END CHOOSE
	CASE ELSE
		MessageBox ('Error!', 'Un error inesperado resulto cuando se estaba tratando de ' + &
									 'registrar la aplicacion con MS Windows.' + &
									 '~r~nLa funcion CreateMutex retorno ' + &
									 String (lul_last_error) + '.~r~n' + &
									 'Por favor contacte al Administrador del Sistema.', &
									 Exclamation!)
		lb_aplicacion_corriendo = TRUE
END CHOOSE

IF lb_aplicacion_corriendo THEN
	CloseHandle (sl_mutex_handle)
END IF

RETURN lb_aplicacion_corriendo

end function

public subroutine of_destruir_instancia_aplicacion ();ReleaseMutex (sl_mutex_handle)
end subroutine

public function long of_crear_dirty_read ();/*	---------------------------------------------------------------------

	---------------------------------------------------------------------*/
uo_dsbase lds_sesion

If Not IsValid(itr_sucia) Then
	itr_sucia = Create Transaction
	
	itr_sucia.Dbms 		= SQLCA.DBMS
	itr_sucia.Database	= SQLCA.DATABASE
	itr_sucia.Userid		= SQLCA.USERID
	itr_sucia.Dbpass		= SQLCA.DBPASS
	itr_sucia.Dbparm		= SQLCA.DBPARM
	itr_sucia.Servername	= SQLCA.ServerName
	itr_sucia.Lock			= "Dirty Read"
	
	Connect Using itr_sucia;
	If itr_sucia.SqlCode = -1 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la conexi$$HEX1$$f300$$ENDHEX$$n en modo Dirty Read." &
					+ "~r~nPor favor consulte con informatica.")
		Return -1
	End If

	//	Se crea ds para hallar la sesion de usuario
	lds_sesion = Create uo_dsbase
	lds_sesion.DataObject = 'd_gr_sesion'
	lds_sesion.SetTransObject(itr_sucia)
	If lds_sesion.Of_Retrieve() > 0 Then
		gstr_info_usuario.sesion_dirty = lds_sesion.GetItemNumber(1,'sesion')
	End If
	Destroy lds_sesion
	
End If

Return 1

end function

public function long of_reconectar_dirty_read ();/*	---------------------------------------------------------------------

	---------------------------------------------------------------------*/

If IsValid(itr_sucia) Then
	Connect Using itr_sucia;
	If itr_sucia.SqlCode = -1 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la reconexi$$HEX1$$f300$$ENDHEX$$n en modo Dirty Read." &
					+ "~r~nPor favor consulte con informatica.")
		Return -1
	End If
Else
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se puede reconectar en modo Dirty Read por que el objeto de conexi$$HEX1$$f300$$ENDHEX$$n no existe." &
				+ "~r~nPor favor consulte con informatica.")
	Return -2
End If


Return 1

end function

public function long of_destruir_dirty_read ();

If IsValid(itr_sucia) Then
	Disconnect Using itr_sucia;
	If itr_sucia.SqlCode = -1 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la Desconexi$$HEX1$$f300$$ENDHEX$$n en modo Dirty Read." &
					+ "~r~nPor favor consulte con informatica.")
		Return -1
	End If
End If

Return 1
end function

public function transaction of_get_transaccion_sucia ();
If IsValid(itr_sucia) Then
	Return itr_sucia
Else
	If of_crear_dirty_read() < 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Toda consulta de datos fallara; hasta reconectarse a la Base de Datos" &
					+ "~r~nPor favor consulte con informatica.")
	End If 
End If

Return itr_sucia
end function

public function long of_get_transaccion_sucia (ref transaction atr_transaccion);
If Not IsValid(itr_sucia) Then
	If of_crear_dirty_read() < 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Toda consulta de datos fallara; hasta reconectarse a la Base de Datos" &
					+ "~r~nPor favor consulte con informatica.")
		Return -1
	End If 
End If

atr_transaccion = itr_sucia

Return 1
end function

public function long of_registrar_paso (string as_mensaje);String ls_cadena

If Len(as_mensaje) > 0 Then
	ls_cadena = Clipboard()
	Clipboard( ls_cadena + '~n' + as_mensaje)
Else
	Clipboard('')
End If

Return 1
end function

public function long of_ver_inconsistencias ();
Return 1
end function

public function long of_registrar_log (string as_mensaje);Long ll_filenum
String ls_logline

ll_filenum = FileOpen(gstr_info_usuario.ruta_log + "\informatica_error.log", linemode!, Write!)
If ll_filenum > 0 Then
	ls_logline = "Informatica   " + String(today()) + "   " + String(Now()) + "   " + &
					+ String(gstr_info_usuario.codigo_usuario) + "   ~n" + as_mensaje + "~n~n"
 	If FileWrite(ll_filenum, ls_logline) <> -1 Then	//	Escribio al archivo de errores
		FileClose(ll_filenum)
	Else
		MessageBox("Aviso Importante", "No se logro escribir al archivo de errores del sistema" &
					+ "~nPor favor avise al Administrador de este problema", StopSign!)
		FileClose(ll_filenum)
		Return -1
	End If
Else
	MessageBox("Aviso Importante", "No se logro abrir el archivo de errores del sistema" &
				+ "~nPor favor avise al Administrador de este problema", StopSign!)
	Return -2
End If

Return 1
end function

on uo_adm_recursos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_adm_recursos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

