HA$PBExportHeader$w_tallas_particion.srw
forward
global type w_tallas_particion from window
end type
type cb_cancelar from commandbutton within w_tallas_particion
end type
type cb_continuar from commandbutton within w_tallas_particion
end type
type dw_talla from datawindow within w_tallas_particion
end type
type gb_1 from groupbox within w_tallas_particion
end type
end forward

global type w_tallas_particion from window
integer width = 910
integer height = 1616
boolean titlebar = true
string title = "Tallas Partici$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_continuar cb_continuar
dw_talla dw_talla
gb_1 gb_1
end type
global w_tallas_particion w_tallas_particion

on w_tallas_particion.create
this.cb_cancelar=create cb_cancelar
this.cb_continuar=create cb_continuar
this.dw_talla=create dw_talla
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_continuar,&
this.dw_talla,&
this.gb_1}
end on

on w_tallas_particion.destroy
destroy(this.cb_cancelar)
destroy(this.cb_continuar)
destroy(this.dw_talla)
destroy(this.gb_1)
end on

event open;This.center = True
s_base_parametros lstr_parametros

dw_talla.SetTransObject(sqlca)


lstr_parametros = Message.PowerObjectParm	

dw_talla.Retrieve(lstr_parametros.entero[1],&
						lstr_parametros.entero[2],&
						lstr_parametros.entero[3],&
						lstr_parametros.entero[4],&
						lstr_parametros.entero[5],&
						lstr_parametros.entero[6],&
						lstr_parametros.cadena[1],&
						lstr_parametros.cadena[2],&
						lstr_parametros.entero[7],&
						lstr_parametros.entero[8],&
						lstr_parametros.entero[9],&
						lstr_parametros.entero[10],&
						lstr_parametros.cadena[3],&
						lstr_parametros.entero[12],&
						lstr_parametros.entero[13],&
						lstr_parametros.entero[14])
						
dw_talla.SetFocus()						





						




end event

type cb_cancelar from commandbutton within w_tallas_particion
integer x = 489
integer y = 1368
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn(Parent,lstr_parametros)
end event

type cb_continuar from commandbutton within w_tallas_particion
integer x = 87
integer y = 1368
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Continuar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = True

CloseWithReturn(Parent,lstr_parametros)
end event

type dw_talla from datawindow within w_tallas_particion
integer x = 69
integer y = 60
integer width = 736
integer height = 1168
integer taborder = 10
string title = "none"
string dataobject = "dtb_tallas_particion"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_tallas_particion
integer x = 41
integer y = 8
integer width = 809
integer height = 1300
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

