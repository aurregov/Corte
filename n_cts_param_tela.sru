HA$PBExportHeader$n_cts_param_tela.sru
forward
global type n_cts_param_tela from nonvisualobject
end type
end forward

global type n_cts_param_tela from nonvisualobject autoinstantiate
end type

type variables

Long il_modelo[],il_fabrica[],il_reftel[],il_caract[],il_diametro[],&
     il_color[],il_raya[]
end variables

on n_cts_param_tela.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_param_tela.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

