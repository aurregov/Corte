HA$PBExportHeader$w_ventana_emergente.srw
forward
global type w_ventana_emergente from window
end type
type st_2 from statictext within w_ventana_emergente
end type
type em_usuario from editmask within w_ventana_emergente
end type
type mle_mensaje from multilineedit within w_ventana_emergente
end type
type st_1 from statictext within w_ventana_emergente
end type
type cb_1 from commandbutton within w_ventana_emergente
end type
end forward

global type w_ventana_emergente from window
integer x = 1056
integer y = 456
integer width = 1659
integer height = 960
boolean titlebar = true
string title = "Enviar Mensaje Emergente"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
st_2 st_2
em_usuario em_usuario
mle_mensaje mle_mensaje
st_1 st_1
cb_1 cb_1
end type
global w_ventana_emergente w_ventana_emergente

on w_ventana_emergente.create
this.st_2=create st_2
this.em_usuario=create em_usuario
this.mle_mensaje=create mle_mensaje
this.st_1=create st_1
this.cb_1=create cb_1
this.Control[]={this.st_2,&
this.em_usuario,&
this.mle_mensaje,&
this.st_1,&
this.cb_1}
end on

on w_ventana_emergente.destroy
destroy(this.st_2)
destroy(this.em_usuario)
destroy(this.mle_mensaje)
destroy(this.st_1)
destroy(this.cb_1)
end on

type st_2 from statictext within w_ventana_emergente
integer x = 91
integer y = 172
integer width = 242
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Mensaje"
boolean focusrectangle = false
end type

type em_usuario from editmask within w_ventana_emergente
integer x = 581
integer y = 52
integer width = 969
integer height = 108
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type mle_mensaje from multilineedit within w_ventana_emergente
integer x = 82
integer y = 240
integer width = 1467
integer height = 392
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 134217729
long backcolor = 134217732
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ventana_emergente
integer x = 201
integer y = 64
integer width = 347
integer height = 80
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Usuarios"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ventana_emergente
integer x = 626
integer y = 680
integer width = 343
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Enviar"
end type

event clicked;String as_usuario, as_mensaje
String as_comando


as_usuario= string(em_usuario.Text)
as_mensaje=String(mle_mensaje.Text)
as_comando="Net Send " + as_usuario + " ' " + as_mensaje + " ' "

Run(as_comando)

end event

