HA$PBExportHeader$w_principal.srw
$PBExportComments$OBJETO BASE - Ventana utilizada como MDI o ventana principal en todas las aplicaciones. No se debe renombrar, ni heredar ni cambiar de libreria. Se debe editar y cambiar m_base_principal por el menu principal del sistema y cambiar el titulo a la venta$$HEX3$$4441542a005c$$ENDHEX$$
forward
global type w_principal from w_base_principal
end type
end forward

global type w_principal from w_base_principal
string title = "Sistema de Planeaci$$HEX1$$f300$$ENDHEX$$n Vestimundo"
string menuname = "m_principal_asignacion_modulos"
end type
global w_principal w_principal

on w_principal.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_principal_asignacion_modulos" then this.MenuID = create m_principal_asignacion_modulos
end on

on w_principal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;String ls_planta, ls_usuario

ls_usuario = Trim(gstr_info_usuario.nombre_usuario)
gnv_recursos = Create uo_adm_recursos
IF gstr_info_usuario.co_planta_pro = 2 THEN
	ls_planta = 'Marinilla'
ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
	ls_planta = 'NIcole'
END IF

This.Title = 'Sistema Orden de Corte - Usuario:  '+ls_usuario+' ('+ls_planta+')'
end event

