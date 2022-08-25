HA$PBExportHeader$w_ancho_cortable.srw
forward
global type w_ancho_cortable from window
end type
type cb_1 from commandbutton within w_ancho_cortable
end type
type dw_1 from datawindow within w_ancho_cortable
end type
end forward

global type w_ancho_cortable from window
integer width = 1115
integer height = 880
boolean titlebar = true
string title = "Ancho Cortable"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_1 cb_1
dw_1 dw_1
end type
global w_ancho_cortable w_ancho_cortable

on w_ancho_cortable.create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_1,&
this.dw_1}
end on

on w_ancho_cortable.destroy
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;Environment le_even

IF GetEnvironment ( le_even ) <> 1 THEN 
ELSE
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
END IF

dw_1.SetTransObject(sqlca)
end event

type cb_1 from commandbutton within w_ancho_cortable
integer x = 402
integer y = 660
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
boolean default = true
end type

type dw_1 from datawindow within w_ancho_cortable
integer x = 192
integer y = 56
integer width = 768
integer height = 432
integer taborder = 10
string title = "none"
boolean border = false
boolean livescroll = true
end type

