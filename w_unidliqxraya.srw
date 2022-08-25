HA$PBExportHeader$w_unidliqxraya.srw
forward
global type w_unidliqxraya from window
end type
type cb_cancelar from commandbutton within w_unidliqxraya
end type
type cb_continuar from commandbutton within w_unidliqxraya
end type
type dw_1 from datawindow within w_unidliqxraya
end type
type gb_1 from groupbox within w_unidliqxraya
end type
end forward

global type w_unidliqxraya from window
integer width = 869
integer height = 1384
boolean titlebar = true
string title = "Unidades Liquidadas por Raya"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_continuar cb_continuar
dw_1 dw_1
gb_1 gb_1
end type
global w_unidliqxraya w_unidliqxraya

on w_unidliqxraya.create
this.cb_cancelar=create cb_cancelar
this.cb_continuar=create cb_continuar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_continuar,&
this.dw_1,&
this.gb_1}
end on

on w_unidliqxraya.destroy
destroy(this.cb_cancelar)
destroy(this.cb_continuar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;This.Center = True
s_base_parametros lstr_parametros

dw_1.SetTransObject(sqlca)

lstr_parametros = Message.PowerObjectParm	

dw_1.Retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2])


end event

type cb_cancelar from commandbutton within w_unidliqxraya
boolean visible = false
integer x = 430
integer y = 1092
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_continuar from commandbutton within w_unidliqxraya
integer x = 210
integer y = 1092
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Continuar"
end type

event clicked;Close(Parent)
end event

type dw_1 from datawindow within w_unidliqxraya
integer x = 142
integer y = 88
integer width = 562
integer height = 836
integer taborder = 10
string title = "none"
string dataobject = "ds_unidliq_comp"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_unidliqxraya
integer x = 119
integer y = 44
integer width = 617
integer height = 968
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

