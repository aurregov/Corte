HA$PBExportHeader$w_adhesivos_telas.srw
forward
global type w_adhesivos_telas from window
end type
type st_8 from statictext within w_adhesivos_telas
end type
type st_7 from statictext within w_adhesivos_telas
end type
type sle_carrito2 from singlelineedit within w_adhesivos_telas
end type
type sle_parqueo2 from singlelineedit within w_adhesivos_telas
end type
type cb_2 from commandbutton within w_adhesivos_telas
end type
type st_6 from statictext within w_adhesivos_telas
end type
type sle_parqueo from singlelineedit within w_adhesivos_telas
end type
type cb_1 from commandbutton within w_adhesivos_telas
end type
type cb_usuario from commandbutton within w_adhesivos_telas
end type
type st_5 from statictext within w_adhesivos_telas
end type
type st_4 from statictext within w_adhesivos_telas
end type
type sle_clave from singlelineedit within w_adhesivos_telas
end type
type sle_usuario from singlelineedit within w_adhesivos_telas
end type
type cb_placa from commandbutton within w_adhesivos_telas
end type
type sle_carrito from singlelineedit within w_adhesivos_telas
end type
type st_3 from statictext within w_adhesivos_telas
end type
type st_2 from statictext within w_adhesivos_telas
end type
type sle_placa from singlelineedit within w_adhesivos_telas
end type
type st_1 from statictext within w_adhesivos_telas
end type
end forward

global type w_adhesivos_telas from window
integer width = 2226
integer height = 988
boolean titlebar = true
string title = "Adhesivos de Corte"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
st_8 st_8
st_7 st_7
sle_carrito2 sle_carrito2
sle_parqueo2 sle_parqueo2
cb_2 cb_2
st_6 st_6
sle_parqueo sle_parqueo
cb_1 cb_1
cb_usuario cb_usuario
st_5 st_5
st_4 st_4
sle_clave sle_clave
sle_usuario sle_usuario
cb_placa cb_placa
sle_carrito sle_carrito
st_3 st_3
st_2 st_2
sle_placa sle_placa
st_1 st_1
end type
global w_adhesivos_telas w_adhesivos_telas

on w_adhesivos_telas.create
this.st_8=create st_8
this.st_7=create st_7
this.sle_carrito2=create sle_carrito2
this.sle_parqueo2=create sle_parqueo2
this.cb_2=create cb_2
this.st_6=create st_6
this.sle_parqueo=create sle_parqueo
this.cb_1=create cb_1
this.cb_usuario=create cb_usuario
this.st_5=create st_5
this.st_4=create st_4
this.sle_clave=create sle_clave
this.sle_usuario=create sle_usuario
this.cb_placa=create cb_placa
this.sle_carrito=create sle_carrito
this.st_3=create st_3
this.st_2=create st_2
this.sle_placa=create sle_placa
this.st_1=create st_1
this.Control[]={this.st_8,&
this.st_7,&
this.sle_carrito2,&
this.sle_parqueo2,&
this.cb_2,&
this.st_6,&
this.sle_parqueo,&
this.cb_1,&
this.cb_usuario,&
this.st_5,&
this.st_4,&
this.sle_clave,&
this.sle_usuario,&
this.cb_placa,&
this.sle_carrito,&
this.st_3,&
this.st_2,&
this.sle_placa,&
this.st_1}
end on

on w_adhesivos_telas.destroy
destroy(this.st_8)
destroy(this.st_7)
destroy(this.sle_carrito2)
destroy(this.sle_parqueo2)
destroy(this.cb_2)
destroy(this.st_6)
destroy(this.sle_parqueo)
destroy(this.cb_1)
destroy(this.cb_usuario)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_clave)
destroy(this.sle_usuario)
destroy(this.cb_placa)
destroy(this.sle_carrito)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_placa)
destroy(this.st_1)
end on

type st_8 from statictext within w_adhesivos_telas
integer x = 933
integer y = 468
integer width = 64
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "a"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_adhesivos_telas
integer x = 933
integer y = 344
integer width = 64
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "a"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_carrito2 from singlelineedit within w_adhesivos_telas
integer x = 1047
integer y = 328
integer width = 261
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_parqueo2 from singlelineedit within w_adhesivos_telas
integer x = 1047
integer y = 460
integer width = 261
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_adhesivos_telas
integer x = 1417
integer y = 456
integer width = 635
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Parqueadero"
end type

event clicked;//String ls_parqueo
//Long li_llamar
//ls_parqueo =  String(sle_parqueo.Text)
//li_llamar = f_adhesivo_parqueadero(ls_parqueo)
//
Long ll_contador, ll_inicio,ll_final, ll_registro
Datastore lds_sticker

ll_inicio = Long(sle_parqueo.Text)
ll_final = Long(sle_parqueo2.Text)
If ll_inicio <= ll_final Then
	lds_sticker = create Datastore
	lds_sticker.DataObject = "d_stiker"
	lds_sticker.Object.valor_t.text = "PARQUEADERO"
	For ll_contador = ll_inicio To ll_final
		ll_registro = lds_sticker.InsertRow(0)
		lds_sticker.SetItem(ll_registro,"valor",ll_contador)
	Next
	
	lds_sticker.Print()
////	lds_sticker.Retrieve()
////	lds_sticker.setFocus()
//	OpenWithParm(w_opciones_impresion, lds_sticker)

	Destroy lds_sticker
Else
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor inicial debe ser menor o igual al valor final",StopSign!)
End If
end event

type st_6 from statictext within w_adhesivos_telas
integer x = 41
integer y = 468
integer width = 562
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "No. Parqueadero"
boolean focusrectangle = false
end type

type sle_parqueo from singlelineedit within w_adhesivos_telas
integer x = 608
integer y = 460
integer width = 261
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_adhesivos_telas
integer x = 1417
integer y = 336
integer width = 635
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Recipiente"
end type

event clicked;////String ls_carrito
//Long li_llamar
//ls_carrito =  String(sle_carrito.Text)
//li_llamar = f_adhesivo_bongo(ls_carrito)
////
Long ll_contador, ll_inicio,ll_final, ll_registro
Datastore lds_sticker

ll_inicio = Long(sle_carrito.Text)
ll_final = Long(sle_carrito2.Text)
If ll_inicio <= ll_final Then
	lds_sticker = create Datastore
	lds_sticker.DataObject = "d_stiker"
	lds_sticker.Object.valor_t.text = "BONGO"
	For ll_contador = ll_inicio To ll_final
		ll_registro = lds_sticker.InsertRow(0)
		lds_sticker.SetItem(ll_registro,"valor",ll_contador)
	Next
	
	lds_sticker.Print()
	Destroy lds_sticker
Else
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El valor inicial debe ser menor o igual al valor final",StopSign!)
End If	
end event

type cb_usuario from commandbutton within w_adhesivos_telas
integer x = 1417
integer y = 660
integer width = 635
integer height = 92
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Usuario"
end type

event clicked;Long  ll_registro
Datastore lds_sticker
string ls_usuario, ls_clave

ls_usuario = trim(sle_usuario.Text)
ls_clave = trim(sle_clave.Text)
ll_registro = 1
	lds_sticker = create Datastore
	lds_sticker.DataObject = "d_stiker_usuario"
	lds_sticker.Object.valor_t.text = "Login"
	ll_registro = lds_sticker.InsertRow(0)
	lds_sticker.SetItem(ll_registro,"usuario",ls_usuario)
	lds_sticker.SetItem(ll_registro,"clave",ls_clave)
	
	lds_sticker.Print()
	Destroy lds_sticker

end event

type st_5 from statictext within w_adhesivos_telas
integer x = 41
integer y = 744
integer width = 402
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contrase$$HEX1$$f100$$ENDHEX$$a"
boolean focusrectangle = false
end type

type st_4 from statictext within w_adhesivos_telas
integer x = 41
integer y = 620
integer width = 402
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuario"
boolean focusrectangle = false
end type

type sle_clave from singlelineedit within w_adhesivos_telas
integer x = 608
integer y = 732
integer width = 306
integer height = 92
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "Contrase$$HEX1$$f100$$ENDHEX$$a"
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type sle_usuario from singlelineedit within w_adhesivos_telas
integer x = 608
integer y = 608
integer width = 306
integer height = 92
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "Usuario"
borderstyle borderstyle = stylelowered!
end type

type cb_placa from commandbutton within w_adhesivos_telas
integer x = 1417
integer y = 188
integer width = 635
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Placa"
end type

event clicked;String ls_placa_camion
Long li_llamar
ls_placa_camion =  String(sle_placa.Text)
li_llamar = f_adhesivo_placas(ls_placa_camion)
end event

type sle_carrito from singlelineedit within w_adhesivos_telas
integer x = 608
integer y = 328
integer width = 261
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_adhesivos_telas
integer x = 41
integer y = 344
integer width = 402
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "N$$HEX1$$fa00$$ENDHEX$$mero Bongo"
boolean focusrectangle = false
end type

type st_2 from statictext within w_adhesivos_telas
integer x = 41
integer y = 208
integer width = 402
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Placa Camion:"
boolean focusrectangle = false
end type

type sle_placa from singlelineedit within w_adhesivos_telas
integer x = 608
integer y = 192
integer width = 402
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_adhesivos_telas
integer x = 421
integer y = 44
integer width = 919
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "ADHESIVOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

