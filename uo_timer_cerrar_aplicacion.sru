HA$PBExportHeader$uo_timer_cerrar_aplicacion.sru
forward
global type uo_timer_cerrar_aplicacion from n_timer
end type
end forward

global type uo_timer_cerrar_aplicacion from n_timer
end type
global uo_timer_cerrar_aplicacion uo_timer_cerrar_aplicacion

on uo_timer_cerrar_aplicacion.create
call super::create
end on

on uo_timer_cerrar_aplicacion.destroy
call super::destroy
end on

event timer;call super::timer;/*	-------------------------------------------------------------------
	Termina la aplicacion ejecutando el evento Close del objeto	aplicacion
	-------------------------------------------------------------------*/

//f_desregistrar_usuario_aplicacion()
Halt Close
end event

