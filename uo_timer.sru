HA$PBExportHeader$uo_timer.sru
forward
global type uo_timer from n_timer
end type
end forward

global type uo_timer from n_timer
end type
global uo_timer uo_timer

type variables
Time it_timer_ini, it_timer_fin

end variables

forward prototypes
public function long of_set_intervalo_tiempo (time at_timer_ini, time at_timer_fin)
end prototypes

public function long of_set_intervalo_tiempo (time at_timer_ini, time at_timer_fin);/*	-------------------------------------------------------------------
	Fija el valor de la hora de inicio y final del timer para utilizarla
	al mostrar el mensaje con el tiempo que hace falta para cerrar la
	aplicacion.
	-------------------------------------------------------------------*/
it_timer_ini = at_timer_ini
it_timer_fin = at_timer_fin

Return 1
end function

event timer;call super::timer;/*	----------------------------------------------------------------
	Evento que despliega el mensaje al usuario, informando dentro de
	cuanto tiempo sera cerrada la aplicacion.
	---------------------------------------------------------------*/
String ls_mensaje, ls_minutos, ls_segundos

ls_minutos = String(Int(SecondsAfter(now(),it_timer_fin)/60))
ls_segundos = String(mod((SecondsAfter(now(),it_timer_fin)),60))
ls_mensaje =  ls_minutos + " minutos"
If ls_segundos <> "0" Then ls_mensaje += " y " + ls_segundos + " segundos"
MessageBox("Mensaje de Sistemas", "Esta aplicaci$$HEX1$$f300$$ENDHEX$$n se cerrara en " + ls_mensaje, Information!)

end event

on uo_timer.create
call super::create
end on

on uo_timer.destroy
call super::destroy
end on

