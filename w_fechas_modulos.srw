HA$PBExportHeader$w_fechas_modulos.srw
forward
global type w_fechas_modulos from window
end type
type cb_salir from commandbutton within w_fechas_modulos
end type
type dw_lista from datawindow within w_fechas_modulos
end type
type gb_1 from groupbox within w_fechas_modulos
end type
end forward

global type w_fechas_modulos from window
integer width = 1810
integer height = 1256
boolean titlebar = true
string title = "Fechas Fin de Corte Por M$$HEX1$$f300$$ENDHEX$$dulo"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_salir cb_salir
dw_lista dw_lista
gb_1 gb_1
end type
global w_fechas_modulos w_fechas_modulos

on w_fechas_modulos.create
this.cb_salir=create cb_salir
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_salir,&
this.dw_lista,&
this.gb_1}
end on

on w_fechas_modulos.destroy
destroy(this.cb_salir)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;Environment le_even

IF GetEnvironment ( le_even ) <> 1 THEN 
ELSE
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
END IF

dw_lista.SetTransObject(sqlca)

dw_lista.Retrieve()
end event

type cb_salir from commandbutton within w_fechas_modulos
integer x = 745
integer y = 984
integer width = 343
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cerrar"
end type

event clicked;Close(Parent)
end event

type dw_lista from datawindow within w_fechas_modulos
integer x = 59
integer y = 68
integer width = 1682
integer height = 824
integer taborder = 10
string title = "none"
string dataobject = "dgr_fechas_modulos"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_fechas_modulos
integer x = 32
integer y = 24
integer width = 1728
integer height = 888
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

