HA$PBExportHeader$n_cts_param_raya.sru
forward
global type n_cts_param_raya from nonvisualobject
end type
end forward

global type n_cts_param_raya from nonvisualobject
end type
global n_cts_param_raya n_cts_param_raya

type variables
Long il_modelo[], il_reftel[], il_caract[], il_diametro[], il_color[], il_raya[], il_fila[]
end variables

on n_cts_param_raya.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_param_raya.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

