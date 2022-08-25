HA$PBExportHeader$w_parametro_orden_corte_reporte.srw
forward
global type w_parametro_orden_corte_reporte from window
end type
type cb_2 from commandbutton within w_parametro_orden_corte_reporte
end type
type cb_1 from commandbutton within w_parametro_orden_corte_reporte
end type
type st_2 from statictext within w_parametro_orden_corte_reporte
end type
type em_1 from editmask within w_parametro_orden_corte_reporte
end type
type st_1 from statictext within w_parametro_orden_corte_reporte
end type
type gb_1 from groupbox within w_parametro_orden_corte_reporte
end type
end forward

global type w_parametro_orden_corte_reporte from window
integer width = 919
integer height = 584
boolean titlebar = true
string title = "Parametros Orden Corte"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
st_2 st_2
em_1 em_1
st_1 st_1
gb_1 gb_1
end type
global w_parametro_orden_corte_reporte w_parametro_orden_corte_reporte

on w_parametro_orden_corte_reporte.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_2=create st_2
this.em_1=create em_1
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.st_2,&
this.em_1,&
this.st_1,&
this.gb_1}
end on

on w_parametro_orden_corte_reporte.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If
end event

type cb_2 from commandbutton within w_parametro_orden_corte_reporte
integer x = 91
integer y = 356
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Long ll_ordencorte

ll_ordencorte = Long(em_1.Text)
w_preview_de_impresion.dw_reporte.Retrieve(ll_ordencorte)
Close(Parent)
end event

type cb_1 from commandbutton within w_parametro_orden_corte_reporte
integer x = 462
integer y = 356
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type st_2 from statictext within w_parametro_orden_corte_reporte
integer x = 32
integer y = 24
integer width = 841
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese el n$$HEX1$$fa00$$ENDHEX$$mero de la orden de corte"
boolean focusrectangle = false
end type

type em_1 from editmask within w_parametro_orden_corte_reporte
integer x = 361
integer y = 168
integer width = 443
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type st_1 from statictext within w_parametro_orden_corte_reporte
integer x = 105
integer y = 180
integer width = 210
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Corte"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_parametro_orden_corte_reporte
integer x = 32
integer y = 80
integer width = 841
integer height = 248
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

