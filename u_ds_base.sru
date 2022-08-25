HA$PBExportHeader$u_ds_base.sru
$PBExportComments$Control Datawindow Inteligente
forward
global type u_ds_base from datastore
end type
end forward

global type u_ds_base from datastore
end type
global u_ds_base u_ds_base

type variables

String is_sqlerr
end variables

event dberror;MessageBox("Error BAse Datos", sqlerrtext)
Return 0
end event

on u_ds_base.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_ds_base.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event error;MessageBox("Error",errortext)
end event

