HA$PBExportHeader$n_cts_param.sru
forward
global type n_cts_param from nonvisualobject
end type
end forward

global type n_cts_param from nonvisualobject autoinstantiate
end type

type variables


Long   il_vector[],il_vector2[]
Date   id_vector[]
String is_vector[]
end variables

on n_cts_param.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_param.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

