HA$PBExportHeader$w_base_filtro.srw
forward
global type w_base_filtro from window
end type
type dw_filtro from datawindow within w_base_filtro
end type
end forward

global type w_base_filtro from window
integer width = 2533
integer height = 1408
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_filtro dw_filtro
end type
global w_base_filtro w_base_filtro

type variables
cst_adm_conexion icst_lectura
end variables

on w_base_filtro.create
this.dw_filtro=create dw_filtro
this.Control[]={this.dw_filtro}
end on

on w_base_filtro.destroy
destroy(this.dw_filtro)
end on

event closequery;icst_lectura.of_destruir_dirty_read( )
end event

event activate;SetPointer(Arrow!)
end event

type dw_filtro from datawindow within w_base_filtro
integer x = 165
integer y = 100
integer width = 2144
integer height = 1048
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

