HA$PBExportHeader$w_zoom.srw
forward
global type w_zoom from window
end type
type pb_1 from picturebutton within w_zoom
end type
type pb_aceptar from picturebutton within w_zoom
end type
type st_1 from statictext within w_zoom
end type
type sle_custom from singlelineedit within w_zoom
end type
type rb_custom from radiobutton within w_zoom
end type
type rb_30 from radiobutton within w_zoom
end type
type rb_65 from radiobutton within w_zoom
end type
type rb_100 from radiobutton within w_zoom
end type
type rb_200 from radiobutton within w_zoom
end type
type gb_1 from groupbox within w_zoom
end type
end forward

global type w_zoom from window
integer x = 832
integer y = 384
integer width = 1221
integer height = 732
boolean titlebar = true
string title = "Zoom"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
toolbaralignment toolbaralignment = alignatleft!
pb_1 pb_1
pb_aceptar pb_aceptar
st_1 st_1
sle_custom sle_custom
rb_custom rb_custom
rb_30 rb_30
rb_65 rb_65
rb_100 rb_100
rb_200 rb_200
gb_1 gb_1
end type
global w_zoom w_zoom

type variables
Long ii_zoom

end variables

on w_zoom.create
this.pb_1=create pb_1
this.pb_aceptar=create pb_aceptar
this.st_1=create st_1
this.sle_custom=create sle_custom
this.rb_custom=create rb_custom
this.rb_30=create rb_30
this.rb_65=create rb_65
this.rb_100=create rb_100
this.rb_200=create rb_200
this.gb_1=create gb_1
this.Control[]={this.pb_1,&
this.pb_aceptar,&
this.st_1,&
this.sle_custom,&
this.rb_custom,&
this.rb_30,&
this.rb_65,&
this.rb_100,&
this.rb_200,&
this.gb_1}
end on

on w_zoom.destroy
destroy(this.pb_1)
destroy(this.pb_aceptar)
destroy(this.st_1)
destroy(this.sle_custom)
destroy(this.rb_custom)
destroy(this.rb_30)
destroy(this.rb_65)
destroy(this.rb_100)
destroy(this.rb_200)
destroy(this.gb_1)
end on

event open;environment env

ii_zoom = Long(Message.StringParm)
if GetEnvironment(env) = 1 then
	this.y=(PixelsToUnits(env.ScreenHeight, YPixelsToUnits!) - this.height)/2
	this.x=(PixelsToUnits(env.ScreenWidth, XPixelsToUnits!) - this.Width)/2
end if
IF ii_zoom = 0 THEN
	ii_zoom = 100
END IF
CHOOSE CASE ii_zoom
	CASE 200
		rb_200.Checked = true
	CASE 100
		rb_100.Checked = true
	CASE 65
		rb_65.Checked = true
	CASE 30
		rb_30.Checked = true
	CASE ELSE
		rb_custom.Checked = true
		sle_custom.text = String(ii_zoom, "###")
		sle_custom.SetFocus()
END CHOOSE


end event

type pb_1 from picturebutton within w_zoom
integer x = 805
integer y = 236
integer width = 393
integer height = 124
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
string picturename = "c:\graficos\cancelar.bmp"
alignment htextalign = right!
end type

event clicked;CloseWithReturn(Parent, "-1")

end event

type pb_aceptar from picturebutton within w_zoom
integer x = 805
integer y = 64
integer width = 393
integer height = 124
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
string picturename = "c:\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;CloseWithReturn(Parent,string(ii_zoom))
end event

type st_1 from statictext within w_zoom
integer x = 640
integer y = 488
integer width = 46
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
long backcolor = 74481808
boolean enabled = false
string text = "%"
alignment alignment = right!
long bordercolor = 8388608
boolean focusrectangle = false
end type

type sle_custom from singlelineedit within w_zoom
integer x = 517
integer y = 484
integer width = 119
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
string text = "100"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type rb_custom from radiobutton within w_zoom
integer x = 73
integer y = 480
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
long backcolor = 74481808
string text = "Personalizada"
end type

event clicked;sle_custom.SetFocus()
end event

type rb_30 from radiobutton within w_zoom
integer x = 87
integer y = 388
integer width = 192
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
long backcolor = 74481808
string text = "30%"
end type

event clicked;ii_zoom = 30
sle_custom.text = ""
end event

type rb_65 from radiobutton within w_zoom
integer x = 87
integer y = 292
integer width = 192
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
long backcolor = 74481808
string text = "65%"
end type

event clicked;ii_zoom = 65
sle_custom.text = ""
end event

type rb_100 from radiobutton within w_zoom
integer x = 73
integer y = 192
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
long backcolor = 74481808
string text = "100%"
end type

event clicked;ii_zoom = 100
sle_custom.text = ""
end event

type rb_200 from radiobutton within w_zoom
integer x = 73
integer y = 96
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
long backcolor = 74481808
string text = "200%"
end type

event clicked;ii_zoom = 200
sle_custom.text = ""
end event

type gb_1 from groupbox within w_zoom
integer x = 41
integer y = 36
integer width = 736
integer height = 572
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 74481808
string text = "Escala"
end type

