HA$PBExportHeader$w_diagrama_repite.srw
forward
global type w_diagrama_repite from window
end type
type st_2 from statictext within w_diagrama_repite
end type
type sle_ordencorte from singlelineedit within w_diagrama_repite
end type
type st_1 from statictext within w_diagrama_repite
end type
type sle_escala from singlelineedit within w_diagrama_repite
end type
type dw_repite from datawindow within w_diagrama_repite
end type
type gb_1 from groupbox within w_diagrama_repite
end type
end forward

global type w_diagrama_repite from window
integer width = 4128
integer height = 2528
boolean titlebar = true
string title = "Diagrama Repite"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_imprimir ( )
st_2 st_2
sle_ordencorte sle_ordencorte
st_1 st_1
sle_escala sle_escala
dw_repite dw_repite
gb_1 gb_1
end type
global w_diagrama_repite w_diagrama_repite

type variables
s_base_parametros istr_parametros
end variables

event ue_imprimir();dw_repite.setFocus()
OpenWithParm(w_opciones_impresion, dw_repite)
end event

on w_diagrama_repite.create
this.st_2=create st_2
this.sle_ordencorte=create sle_ordencorte
this.st_1=create st_1
this.sle_escala=create sle_escala
this.dw_repite=create dw_repite
this.gb_1=create gb_1
this.Control[]={this.st_2,&
this.sle_ordencorte,&
this.st_1,&
this.sle_escala,&
this.dw_repite,&
this.gb_1}
end on

on w_diagrama_repite.destroy
destroy(this.st_2)
destroy(this.sle_ordencorte)
destroy(this.st_1)
destroy(this.sle_escala)
destroy(this.dw_repite)
destroy(this.gb_1)
end on

event open;
dw_repite.SetTransObject(sqlca)

sle_escala.Text = '20'

sle_ordencorte.SetFocus()

dw_repite.Modify("DataWindow.Print.Preview=Yes")
end event

type st_2 from statictext within w_diagrama_repite
integer x = 55
integer y = 20
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
boolean focusrectangle = false
end type

type sle_ordencorte from singlelineedit within w_diagrama_repite
integer x = 366
integer y = 20
integer width = 343
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long li_escala

//con la op de estilo se debe verificar cual tela es la que se desea ver.
istr_parametros.entero[1] = Long(sle_ordencorte.Text)

OpenWithParm (w_telas_op_estilo, istr_parametros )

istr_parametros = Message.PowerObjectParm

If istr_parametros.hay_parametros Then
	li_escala = Long(sle_escala.Text)
	
	IF IsNull(li_escala) Then li_escala = 20
	
	IF istr_parametros.hay_parametros Then
		dw_repite.Retrieve(istr_parametros.entero[1],li_escala)
	End if
End if
end event

type st_1 from statictext within w_diagrama_repite
integer x = 901
integer y = 20
integer width = 192
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Escala: "
boolean focusrectangle = false
end type

type sle_escala from singlelineedit within w_diagrama_repite
integer x = 1111
integer y = 20
integer width = 343
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long li_escala

li_escala = Long(sle_escala.Text)

dw_repite.Retrieve(istr_parametros.entero[1],li_escala)
end event

type dw_repite from datawindow within w_diagrama_repite
integer x = 87
integer y = 152
integer width = 3941
integer height = 2260
integer taborder = 30
string title = "none"
string dataobject = "dtb_diagrama_repite_tela"
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_diagrama_repite
integer x = 50
integer y = 96
integer width = 4032
integer height = 2340
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

