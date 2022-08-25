HA$PBExportHeader$w_base_pda.srw
forward
global type w_base_pda from w_base_simple
end type
end forward

global type w_base_pda from w_base_simple
integer width = 1486
integer height = 980
string menuname = "m_pda"
event type long ue_reset ( )
end type
global w_base_pda w_base_pda

event type long ue_reset();Return 1
end event

on w_base_pda.create
call super::create
if this.MenuName = "m_pda" then this.MenuID = create m_pda
end on

on w_base_pda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_borrar_maestro;// Anular ancestro
end event

event ue_grabar;// Anular ancestro
end event

event ue_insertar_maestro;// Anular ancestro
end event

event open;call super::open;// Clase que contiene los metodos para las pda
n_pda lnvo_pda
// Escondemos la toolbar de la mdi para trabajar con la de la sheet
//
 //Si el dispositivo desde el que visualizamos es una pda
IF lnvo_pda.of_detecta_pda() Then
	this.windowstate=maximized!
	lnvo_pda.of_menu_pda(m_principal_asignacion_modulos)
End If
lnvo_pda.of_modificar_toolbar(m_principal_asignacion_modulos)

end event

event close;call super::close;//w_principal.toolbarvisible = true
end event

type dw_maestro from w_base_simple`dw_maestro within w_base_pda
integer x = 41
integer width = 1353
integer height = 732
end type

event dw_maestro::itemchanged;//Se anula el ancestro
end event

