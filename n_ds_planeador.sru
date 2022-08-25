HA$PBExportHeader$n_ds_planeador.sru
forward
global type n_ds_planeador from datastore
end type
end forward

global type n_ds_planeador from datastore
end type
global n_ds_planeador n_ds_planeador

on n_ds_planeador.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ds_planeador.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

