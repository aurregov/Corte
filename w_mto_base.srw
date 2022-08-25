HA$PBExportHeader$w_mto_base.srw
forward
global type w_mto_base from window
end type
type dw_1 from u_dw_base within w_mto_base
end type
end forward

global type w_mto_base from window
integer width = 1303
integer height = 676
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_borrar_maestro ( )
event ue_insertar_maestro ( )
event ue_grabar ( )
dw_1 dw_1
end type
global w_mto_base w_mto_base

on w_mto_base.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_mto_base.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_base within w_mto_base
integer x = 46
integer y = 32
integer width = 1198
integer taborder = 10
end type

