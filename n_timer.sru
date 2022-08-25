HA$PBExportHeader$n_timer.sru
forward
global type n_timer from timing
end type
end forward

global type n_timer from timing
end type
global n_timer n_timer

on n_timer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_timer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

