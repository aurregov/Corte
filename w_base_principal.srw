HA$PBExportHeader$w_base_principal.srw
$PBExportComments$Ventana MDI para que de ella se herede la ventana principal para cada aplicacion que debe lamarse w_principal de acuerdo a las bases ya creadas
forward
global type w_base_principal from window
end type
type mdi_1 from mdiclient within w_base_principal
end type
end forward

global type w_base_principal from window
integer width = 1979
integer height = 1100
boolean titlebar = true
string title = "Aplicaci$$HEX1$$f300$$ENDHEX$$n Principal"
string menuname = "m_base_principal"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
mdi_1 mdi_1
end type
global w_base_principal w_base_principal

type variables
Protected:
Long ii_minutos
String is_msg_sistemas

end variables

forward prototypes
public function long of_servicio_cerrar_aplicacion (boolean ab_opcion)
public function long of_registrar_usuario_aplicacion ()
end prototypes

public function long of_servicio_cerrar_aplicacion (boolean ab_opcion);/* ------------------------------------------------------------------------	
	Crea o destruye el servicio que administra el cierre de la aplicacion.  
	Solo crea el servicio en el caso de no estar creado, si ya se encuentra 
	creado el objeto retorna 0
   ------------------------------------------------------------------------*/

If IsNull(ab_opcion) Then Return -1

If ab_opcion Then
	If IsNull(gnv_cerrar_aplicacion) Or Not IsValid (gnv_cerrar_aplicacion) Then
		gnv_cerrar_aplicacion = Create n_cerrar_aplicacion
		gnv_cerrar_aplicacion.of_set_tiempo_mensaje(ii_minutos * 60, is_msg_sistemas)
		Return 1
	End If
Else 
	If IsValid (gnv_cerrar_aplicacion) Then
		Destroy gnv_cerrar_aplicacion
		Return 1
	End If	
End If

Return 0
end function

public function long of_registrar_usuario_aplicacion ();/*	-------------------------------------------------------------------------
	Funcion utilizada para registrar cada usuario que utiliza esta aplicacion
	con el proposito de administrar la desconexion de usuarios.
	-------------------------------------------------------------------------*/
Long  li_rc
Long ll_resultado
Datetime ldt_hora_inicio
DataStore lds_usuxapli
OleObject lole_wsh

lole_wsh = CREATE OleObject
li_rc = lole_wsh.ConnectToNewObject( "WScript.Network" )
If li_rc < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible Utilizar WSH" &
				+ "~n~nPor favor avise al Administrador de Sistemas", StopSign!)
	Return -1
End If

lds_usuxapli = Create DataStore
lds_usuxapli.DataObject = 'd_usuarios_x_aplicacion'
lds_usuxapli.SetTransObject(sqlca)

ldt_hora_inicio = Datetime(Today(),Now())
ll_resultado = lds_usuxapli.insertrow (0)
lds_usuxapli.SetItem(ll_resultado, "co_aplicacion", gstr_info_usuario.codigo_aplicacion)
lds_usuxapli.SetItem(ll_resultado, "de_aplicacion", gstr_info_usuario.nombre_aplicacion)
lds_usuxapli.SetItem(ll_resultado, "usuario", gstr_info_usuario.codigo_usuario)
lds_usuxapli.SetItem(ll_resultado, "hora_inicio", ldt_hora_inicio)
li_rc = lds_usuxapli.SetItem(ll_resultado, "computador", lole_wsh.ComputerName )

If lds_usuxapli.UPDATE() > 0 Then
	Commit Using SQLCA;
	lul_id_inicio_usuario = lds_usuxapli.GetItemNumber(ll_resultado, "id")
Else
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible Cometer el registro de usuarios" &
				+ "~n~nPor favor avise al Administrador de Sistemas", StopSign!)
	Destroy lds_usuxapli				
	Return -2
End If

If IsValid(lds_usuxapli) Then Destroy lds_usuxapli

Return 1
end function

on w_base_principal.create
if this.MenuName = "m_base_principal" then this.MenuID = create m_base_principal
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_base_principal.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	HALT Close
END IF

Timer (3)
//If of_registrar_usuario_aplicacion() < 0 Then
//	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible registrar el usuario x aplicacion" &
//					+ "~n~nPor favor avise al Administrador de Sistemas", StopSign!)	
//End If
end event

event timer;/*	----------------------------------------------------------------------
	Evento utilizado para manejar el cierre de la aplicacion desde la
	oficina de sistemas.   Lee un archivo .INI en el servidor administrado
	por los Ingenieros y dependiendo de su configuracion activa un 
	servicio que se encarga de cerrar la aplicacion.
	----------------------------------------------------------------------*/
//String ls_aplicacion
//Boolean lb_detener_aplicacion
//application lapp
//
//lapp = GetApplication()
//ls_aplicacion = lapp.AppName
//If Upper(ProfileString ("\\Vesmant00\Aplicaciones\corte\administrar.ini", ls_aplicacion, "Detener", "No")) = "SI" Then 
//	lb_detener_aplicacion = True
//Else
//	lb_detener_aplicacion = False
//End If
//ii_minutos = ProfileInt ( "\\Vesmant00\Aplicaciones\corte\administrar.ini", ls_aplicacion, "Minutos", 10)
//is_msg_sistemas = ProfileString ( "\\Vesmant00\Aplicaciones\corte\administrar.ini", ls_aplicacion, "Mensaje", "Por favor salirse de la aplicacion " + lapp.DisplayName)
//
//If lb_detener_aplicacion Then
//	of_servicio_cerrar_aplicacion(True)
//Else
//	of_servicio_cerrar_aplicacion(False)
//End If
end event

type mdi_1 from mdiclient within w_base_principal
long BackColor=268435456
end type

