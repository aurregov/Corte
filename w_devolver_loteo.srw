HA$PBExportHeader$w_devolver_loteo.srw
forward
global type w_devolver_loteo from window
end type
type cb_cancelar from commandbutton within w_devolver_loteo
end type
type cb_devolver from commandbutton within w_devolver_loteo
end type
type em_bongo from editmask within w_devolver_loteo
end type
type st_1 from statictext within w_devolver_loteo
end type
type gb_1 from groupbox within w_devolver_loteo
end type
end forward

global type w_devolver_loteo from window
integer width = 731
integer height = 416
boolean titlebar = true
string title = "Devolver Loteo"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_devolver cb_devolver
em_bongo em_bongo
st_1 st_1
gb_1 gb_1
end type
global w_devolver_loteo w_devolver_loteo

on w_devolver_loteo.create
this.cb_cancelar=create cb_cancelar
this.cb_devolver=create cb_devolver
this.em_bongo=create em_bongo
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_devolver,&
this.em_bongo,&
this.st_1,&
this.gb_1}
end on

on w_devolver_loteo.destroy
destroy(this.cb_cancelar)
destroy(this.cb_devolver)
destroy(this.em_bongo)
destroy(this.st_1)
destroy(this.gb_1)
end on

type cb_cancelar from commandbutton within w_devolver_loteo
integer x = 357
integer y = 192
integer width = 306
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_devolver from commandbutton within w_devolver_loteo
integer x = 37
integer y = 192
integer width = 293
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Devolver"
end type

event clicked;String ls_bongo
n_cst_loteo_bongo luo_loteo

ls_bongo = em_bongo.Text

IF luo_loteo.of_devolver_loteo(ls_bongo) = -1 THEN
	ROLLBACK;
ELSE
	COMMIT;
	MessageBox("Devoluci$$HEX1$$f300$$ENDHEX$$n exitosa","El loteo fue devuelto")
END IF
end event

type em_bongo from editmask within w_devolver_loteo
integer x = 261
integer y = 56
integer width = 343
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###############"
end type

type st_1 from statictext within w_devolver_loteo
integer x = 73
integer y = 68
integer width = 178
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bongo:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_devolver_loteo
integer x = 32
integer width = 631
integer height = 180
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

