HA$PBExportHeader$n_pda.sru
forward
global type n_pda from nonvisualobject
end type
end forward

global type n_pda from nonvisualobject
end type
global n_pda n_pda

forward prototypes
public function boolean of_detecta_pda ()
public function long of_modificar_toolbar (m_principal_asignacion_modulos am_menu)
public function long of_menu_pda (m_principal_asignacion_modulos am_menu)
end prototypes

public function boolean of_detecta_pda ();Environment env
GetEnvironment(env)

// Resolucion de la RF 324 x 324
// Si la resolucion es 324 * 324 retorna True
If env.ScreenWidth <= 324 Or env.ScreenHeight <= 324 Then
	Return True
Else
	Return false
End IF	

end function

public function long of_modificar_toolbar (m_principal_asignacion_modulos am_menu);return 1
end function

public function long of_menu_pda (m_principal_asignacion_modulos am_menu);// Oculta las opciones del men$$HEX2$$fa002000$$ENDHEX$$que no se necesitan ver desde la pda
w_principal.toolbarvisible = false

m_principal_asignacion_modulos.m_archivo.Hide()
m_principal_asignacion_modulos.m_administracin.Hide()
m_principal_asignacion_modulos.m_opcin2.Hide()
m_principal_asignacion_modulos.m_opcin3.Hide()
m_principal_asignacion_modulos.m_opcin4.Hide()
m_principal_asignacion_modulos.m_opcin5.Hide()
m_principal_asignacion_modulos.m_vistaprevia.Hide()
m_principal_asignacion_modulos.m_ayuda.Hide()

Return 1
end function

on n_pda.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_pda.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

