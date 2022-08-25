HA$PBExportHeader$w_actualizar_rollos.srw
forward
global type w_actualizar_rollos from w_base_simple
end type
type st_1 from statictext within w_actualizar_rollos
end type
type em_rollo from editmask within w_actualizar_rollos
end type
type st_2 from statictext within w_actualizar_rollos
end type
type em_orden from editmask within w_actualizar_rollos
end type
type st_3 from statictext within w_actualizar_rollos
end type
type em_lote from editmask within w_actualizar_rollos
end type
type st_4 from statictext within w_actualizar_rollos
end type
type em_tela from editmask within w_actualizar_rollos
end type
type st_5 from statictext within w_actualizar_rollos
end type
type em_color from editmask within w_actualizar_rollos
end type
type cb_1 from commandbutton within w_actualizar_rollos
end type
type st_6 from statictext within w_actualizar_rollos
end type
type em_liberacion from editmask within w_actualizar_rollos
end type
end forward

global type w_actualizar_rollos from w_base_simple
integer width = 3351
integer height = 1284
string title = "Actualizar Rollos"
st_1 st_1
em_rollo em_rollo
st_2 st_2
em_orden em_orden
st_3 st_3
em_lote em_lote
st_4 st_4
em_tela em_tela
st_5 st_5
em_color em_color
cb_1 cb_1
st_6 st_6
em_liberacion em_liberacion
end type
global w_actualizar_rollos w_actualizar_rollos

on w_actualizar_rollos.create
int iCurrent
call super::create
this.st_1=create st_1
this.em_rollo=create em_rollo
this.st_2=create st_2
this.em_orden=create em_orden
this.st_3=create st_3
this.em_lote=create em_lote
this.st_4=create st_4
this.em_tela=create em_tela
this.st_5=create st_5
this.em_color=create em_color
this.cb_1=create cb_1
this.st_6=create st_6
this.em_liberacion=create em_liberacion
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_rollo
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_orden
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_lote
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.em_tela
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.em_color
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.em_liberacion
end on

on w_actualizar_rollos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_rollo)
destroy(this.st_2)
destroy(this.em_orden)
destroy(this.st_3)
destroy(this.em_lote)
destroy(this.st_4)
destroy(this.em_tela)
destroy(this.st_5)
destroy(this.em_color)
destroy(this.cb_1)
destroy(this.st_6)
destroy(this.em_liberacion)
end on

type dw_maestro from w_base_simple`dw_maestro within w_actualizar_rollos
integer x = 37
integer y = 232
integer width = 3218
integer height = 828
integer taborder = 20
string dataobject = "dff_actualizacion_rollos"
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_actualizar_rollos
integer x = 37
integer y = 32
integer width = 146
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rollo:"
boolean focusrectangle = false
end type

type em_rollo from editmask within w_actualizar_rollos
integer x = 178
integer y = 24
integer width = 343
integer height = 76
integer taborder = 10
boolean bringtotop = true
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
string mask = "#########"
end type

type st_2 from statictext within w_actualizar_rollos
integer x = 558
integer y = 32
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Pr:"
boolean focusrectangle = false
end type

type em_orden from editmask within w_actualizar_rollos
integer x = 773
integer y = 24
integer width = 343
integer height = 76
integer taborder = 10
boolean bringtotop = true
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
string mask = "#########"
end type

type st_3 from statictext within w_actualizar_rollos
integer x = 1179
integer y = 32
integer width = 146
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lote:"
boolean focusrectangle = false
end type

type em_lote from editmask within w_actualizar_rollos
integer x = 1321
integer y = 24
integer width = 343
integer height = 76
integer taborder = 10
boolean bringtotop = true
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
string mask = "#########"
end type

type st_4 from statictext within w_actualizar_rollos
integer x = 1733
integer y = 32
integer width = 146
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tela:"
boolean focusrectangle = false
end type

type em_tela from editmask within w_actualizar_rollos
integer x = 1874
integer y = 24
integer width = 343
integer height = 76
integer taborder = 20
boolean bringtotop = true
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
string mask = "#########"
end type

type st_5 from statictext within w_actualizar_rollos
integer x = 2309
integer y = 32
integer width = 146
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Color:"
boolean focusrectangle = false
end type

type em_color from editmask within w_actualizar_rollos
integer x = 2450
integer y = 24
integer width = 343
integer height = 76
integer taborder = 20
boolean bringtotop = true
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
string mask = "#########"
end type

type cb_1 from commandbutton within w_actualizar_rollos
integer x = 2871
integer y = 20
integer width = 343
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Consultar"
end type

event clicked;Long ll_rollo, ll_orden, ll_lote, ll_tela, ll_color, ll_liberacion

ll_rollo = Long(em_rollo.Text)
If Isnull(ll_rollo) Then ll_rollo = 0

ll_orden = Long(em_orden.Text)
If Isnull(ll_orden) Then ll_orden = 0

ll_lote = Long(em_lote.Text)
If Isnull(ll_lote) Then ll_lote = 0

ll_tela = Long(em_tela.Text)
If Isnull(ll_tela) Then ll_tela = 0

ll_color = Long(em_color.Text)
If Isnull(ll_color) Then ll_color = 0

ll_liberacion = Long(em_liberacion.Text)
If Isnull(ll_liberacion) Then ll_liberacion = 0

dw_maestro.Retrieve(ll_rollo, ll_orden, ll_lote, ll_tela, ll_color, ll_liberacion)
end event

type st_6 from statictext within w_actualizar_rollos
integer x = 37
integer y = 136
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Liberaci$$HEX1$$f300$$ENDHEX$$n:"
boolean focusrectangle = false
end type

type em_liberacion from editmask within w_actualizar_rollos
integer x = 279
integer y = 128
integer width = 343
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

