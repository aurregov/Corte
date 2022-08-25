HA$PBExportHeader$a_asignacion_modulos.sra
forward
global type a_asignacion_modulos from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
s_base_info_usuario gstr_info_usuario
s_base_opciones gstr_opciones
uLong lul_id_inicio_usuario
n_cerrar_aplicacion gnv_cerrar_aplicacion
uo_adm_recursos gnv_recursos
Long	gl_orden_corte
Boolean gi_cerrar

end variables

global type a_asignacion_modulos from application
string appname = "a_asignacion_modulos"
end type
global a_asignacion_modulos a_asignacion_modulos

type prototypes
Function ulong GetDC(ulong hwnd) library "user32.dll" 
FUNCTION ulong GetPixel(ulong hwnd, long xpos, long ypos) LIBRARY "Gdi32.dll" 

FUNCTION ulong SetPixel(ulong hwnd, long xpos, long ypos, ulong pcol) LIBRARY "Gdi32.dll" 

FUNCTION ulong CreateMutexA (ulong lpMutexAttributes, boolean bInitialOwner, REF string lpszName) LIBRARY "kernel32.dll" alias for "CreateMutexA;Ansi"

FUNCTION long GetLastError() LIBRARY "kernel32.dll"

FUNCTION int GetModuleFileNameA(ulong hinstModule, REF string lpszPath, ulong cchPath) LIBRARY "kernel32.dll" alias for "GetModuleFileNameA;Ansi"
end prototypes

forward prototypes
public function boolean of_esta_corriendo ()
end prototypes

public function boolean of_esta_corriendo ();constant ulong ERROR_ALREADY_EXISTS = 40
constant ulong SUCCESSFUL_EXECUTION = 0
String ls_aplicacion
ulong lul_mutex
ulong lpsa
ulong lul_last_error
boolean lb_ret = FALSE

ls_aplicacion = This.AppName
IF NOT (Handle(GetApplication()) = 0) THEN
    lul_mutex = CreateMutexA(lpsa, FALSE, ls_aplicacion)
    lul_last_error = GetLastError()
    lb_ret = NOT (lul_last_error = SUCCESSFUL_EXECUTION)
END IF

Return lb_ret
end function

on a_asignacion_modulos.create
appname="a_asignacion_modulos"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on a_asignacion_modulos.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;
//	Remueve de la B.D. el registro de esta sesion de usuario.
//f_desregistrar_usuario_aplicacion()

//	Si esta activo el servicio de cerrar aplicacion lo remueve
If IsValid(gnv_cerrar_aplicacion) Then Destroy gnv_cerrar_aplicacion

Disconnect;
IF SQLCA.SQLCODE=-1 THEN
//	messagebox ("Error Desconecci$$HEX1$$f300$$ENDHEX$$n","No se pudo desconectar de la Base de datos",Stopsign!,ok!)
ELSE
//	messagebox ("Desconeccion Exitosa","Se pudo desconectar de la Base de datos")
END IF	
end event

event open;
//	Si la aplicacion ya esta corriendo, detiene una nueva sesion
//If of_esta_corriendo() Then 
//	MessageBox("Atencion"," La aplicacion ya esta funcionando.")
//	Halt
//End If

open(w_conexion_asignacion_modulos)
end event

event systemerror;rollback;
end event

