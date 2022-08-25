HA$PBExportHeader$w_totalordcr.srw
forward
global type w_totalordcr from window
end type
type pb_cancelar from picturebutton within w_totalordcr
end type
type pb_aceptar from picturebutton within w_totalordcr
end type
type em_ordencr from editmask within w_totalordcr
end type
type st_1 from statictext within w_totalordcr
end type
type gb_1 from groupbox within w_totalordcr
end type
end forward

global type w_totalordcr from window
integer x = 1134
integer y = 940
integer width = 754
integer height = 516
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
em_ordencr em_ordencr
st_1 st_1
gb_1 gb_1
end type
global w_totalordcr w_totalordcr

on w_totalordcr.create
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.em_ordencr=create em_ordencr
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.pb_cancelar,&
this.pb_aceptar,&
this.em_ordencr,&
this.st_1,&
this.gb_1}
end on

on w_totalordcr.destroy
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.em_ordencr)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;This.Center = True
end event

type pb_cancelar from picturebutton within w_totalordcr
integer x = 366
integer y = 244
integer width = 306
integer height = 144
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
string picturename = "p:\ordencorte\ssmarinilla\ordencorte\cancelar.bmp"
alignment htextalign = right!
end type

event clicked;Close(Parent)
end event

type pb_aceptar from picturebutton within w_totalordcr
integer x = 37
integer y = 244
integer width = 306
integer height = 144
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
string picturename = "p:\ordencorte\ssmarinilla\ordencorte\ok.bmp"
alignment htextalign = right!
end type

event clicked;Long ll_ordencorte
s_base_parametros lstr_parametros_retro

ll_ordencorte = Long(em_ordencr.Text)

DECLARE totalordcr PROCEDURE FOR
	pr_rep_totalcorte(:ll_ordencorte);

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros_retro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

EXECUTE totalordcr;
Close(w_retroalimentacion)
Close(Parent)
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
	ROLLBACK;
ELSE
	COMMIT;
	OpenSheet(w_total_ordencorte, w_principal, 0, Original!)
END IF
end event

type em_ordencr from editmask within w_totalordcr
integer x = 357
integer y = 88
integer width = 270
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type st_1 from statictext within w_totalordcr
integer x = 73
integer y = 88
integer width = 283
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Orden Corte:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_totalordcr
integer x = 37
integer y = 12
integer width = 640
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

