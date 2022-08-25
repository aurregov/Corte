HA$PBExportHeader$w_consulta_trazos.srw
forward
global type w_consulta_trazos from w_preview_de_impresion
end type
type st_1 from statictext within w_consulta_trazos
end type
type st_2 from statictext within w_consulta_trazos
end type
type st_3 from statictext within w_consulta_trazos
end type
type em_fabrica from editmask within w_consulta_trazos
end type
type em_linea from editmask within w_consulta_trazos
end type
type em_referencia from editmask within w_consulta_trazos
end type
type sle_desreferencia from singlelineedit within w_consulta_trazos
end type
type cb_buscar from commandbutton within w_consulta_trazos
end type
type sle_molderia from singlelineedit within w_consulta_trazos
end type
type st_molderia from statictext within w_consulta_trazos
end type
end forward

global type w_consulta_trazos from w_preview_de_impresion
integer width = 2555
integer height = 2176
string title = "Vista Preliminar de Reportes..pr"
string menuname = "m_vista_previa"
st_1 st_1
st_2 st_2
st_3 st_3
em_fabrica em_fabrica
em_linea em_linea
em_referencia em_referencia
sle_desreferencia sle_desreferencia
cb_buscar cb_buscar
sle_molderia sle_molderia
st_molderia st_molderia
end type
global w_consulta_trazos w_consulta_trazos

event open;This.x = 1
This.y = 1
dw_reporte.DataObject = 'dtb_consulta_trazos_respaldo'

dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_consulta_trazos.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.em_fabrica=create em_fabrica
this.em_linea=create em_linea
this.em_referencia=create em_referencia
this.sle_desreferencia=create sle_desreferencia
this.cb_buscar=create cb_buscar
this.sle_molderia=create sle_molderia
this.st_molderia=create st_molderia
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_fabrica
this.Control[iCurrent+5]=this.em_linea
this.Control[iCurrent+6]=this.em_referencia
this.Control[iCurrent+7]=this.sle_desreferencia
this.Control[iCurrent+8]=this.cb_buscar
this.Control[iCurrent+9]=this.sle_molderia
this.Control[iCurrent+10]=this.st_molderia
end on

on w_consulta_trazos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_fabrica)
destroy(this.em_linea)
destroy(this.em_referencia)
destroy(this.sle_desreferencia)
destroy(this.cb_buscar)
destroy(this.sle_molderia)
destroy(this.st_molderia)
end on

event resize;dw_reporte.Resize(This.Width - 100, This.Height - 350)
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_consulta_trazos
integer x = 0
integer y = 248
integer width = 2350
integer height = 1488
integer taborder = 40
string dataobject = "dtb_consulta_trazos_respaldo"
end type

type st_1 from statictext within w_consulta_trazos
integer x = 41
integer y = 32
integer width = 192
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "F$$HEX1$$e100$$ENDHEX$$brica:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_consulta_trazos
integer x = 229
integer y = 32
integer width = 160
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "L$$HEX1$$ed00$$ENDHEX$$nea:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_consulta_trazos
integer x = 480
integer y = 32
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Referencia:"
boolean focusrectangle = false
end type

type em_fabrica from editmask within w_consulta_trazos
integer x = 23
integer y = 104
integer width = 133
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type em_linea from editmask within w_consulta_trazos
integer x = 229
integer y = 104
integer width = 133
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type em_referencia from editmask within w_consulta_trazos
integer x = 402
integer y = 104
integer width = 238
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#######"
end type

type sle_desreferencia from singlelineedit within w_consulta_trazos
integer x = 649
integer y = 104
integer width = 891
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_consulta_trazos
integer x = 2254
integer y = 48
integer width = 224
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;Long li_fabrica, li_linea
Long ll_referencia
String ls_referencia,ls_molderia

li_fabrica = Long(em_fabrica.Text)
li_linea = Long(em_linea.Text)
ll_referencia = Long(em_referencia.Text)
ls_referencia = sle_desreferencia.Text
ls_molderia = sle_molderia.Text
IF len(ls_referencia) > 0 THEN
	ls_referencia = ls_referencia + '%'
ELSE
	ls_referencia = ' '
END IF
IF len(ls_molderia) > 0 THEN
	ls_molderia = ls_molderia + '%'
ELSE
	ls_molderia = ' '
END IF
dw_reporte.Retrieve(li_fabrica, li_linea, ll_referencia, ls_referencia,ls_molderia)
end event

type sle_molderia from singlelineedit within w_consulta_trazos
integer x = 1568
integer y = 104
integer width = 480
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_molderia from statictext within w_consulta_trazos
integer x = 1586
integer y = 32
integer width = 261
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Molder$$HEX1$$ed00$$ENDHEX$$a:"
boolean focusrectangle = false
end type

