HA$PBExportHeader$w_duo_conjunto.srw
forward
global type w_duo_conjunto from window
end type
type st_1 from statictext within w_duo_conjunto
end type
type cb_aceptar from commandbutton within w_duo_conjunto
end type
type dw_lista from datawindow within w_duo_conjunto
end type
type gb_1 from groupbox within w_duo_conjunto
end type
end forward

global type w_duo_conjunto from window
integer width = 955
integer height = 1204
boolean titlebar = true
string title = "Duo / Conjunto"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_duo_conjunto w_duo_conjunto

event open;s_base_parametros lstr_parametros
//
//DISCONNECT;
//SQLCA.Lock = "DIRTY READ"
//CONNECT USING SQLCA;
//
dw_lista.SetTransObject(sqlca)

lstr_parametros = message.PowerObjectParm	


dw_lista.retrieve(lstr_parametros.entero[1], lstr_parametros.entero[2])

//DISCONNECT;
//SQLCA.Lock = "Cursor Stability"
//CONNECT USING SQLCA;
end event

on w_duo_conjunto.create
this.st_1=create st_1
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_duo_conjunto.destroy
destroy(this.st_1)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

type st_1 from statictext within w_duo_conjunto
integer x = 37
integer y = 20
integer width = 882
integer height = 376
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "La O.C. que est$$HEX2$$e1002000$$ENDHEX$$trabajando hace parte de un d$$HEX1$$fa00$$ENDHEX$$o o conjunto, conformado por estas otras O.C. estas deber$$HEX1$$ed00$$ENDHEX$$an viajar juntas por el proceso, inicialmente esto ser$$HEX2$$e1002000$$ENDHEX$$informativo, en el futuro ser$$HEX2$$e1002000$$ENDHEX$$restrictivo."
boolean border = true
boolean focusrectangle = false
end type

type cb_aceptar from commandbutton within w_duo_conjunto
integer x = 567
integer y = 616
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Close(Parent)
end event

type dw_lista from datawindow within w_duo_conjunto
integer x = 73
integer y = 464
integer width = 421
integer height = 504
integer taborder = 10
string title = "none"
string dataobject = "dgr_duo_conjunto"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_duo_conjunto
integer x = 46
integer y = 416
integer width = 475
integer height = 600
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

