HA$PBExportHeader$n_cts_param_talla.sru
forward
global type n_cts_param_talla from nonvisualobject
end type
end forward

global type n_cts_param_talla from nonvisualobject autoinstantiate
end type

type variables

Long il_orden[],il_talla[],il_cant[]
end variables

on n_cts_param_talla.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_param_talla.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

