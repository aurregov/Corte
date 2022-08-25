HA$PBExportHeader$w_generar_pedido_lote.srw
forward
global type w_generar_pedido_lote from window
end type
type pb_cancelar from picturebutton within w_generar_pedido_lote
end type
type pb_aceptar from picturebutton within w_generar_pedido_lote
end type
type em_lote from editmask within w_generar_pedido_lote
end type
type st_1 from statictext within w_generar_pedido_lote
end type
type gb_1 from groupbox within w_generar_pedido_lote
end type
end forward

global type w_generar_pedido_lote from window
integer x = 1134
integer y = 940
integer width = 960
integer height = 524
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
em_lote em_lote
st_1 st_1
gb_1 gb_1
end type
global w_generar_pedido_lote w_generar_pedido_lote

on w_generar_pedido_lote.create
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.em_lote=create em_lote
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.pb_cancelar,&
this.pb_aceptar,&
this.em_lote,&
this.st_1,&
this.gb_1}
end on

on w_generar_pedido_lote.destroy
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.em_lote)
destroy(this.st_1)
destroy(this.gb_1)
end on

type pb_cancelar from picturebutton within w_generar_pedido_lote
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

type pb_aceptar from picturebutton within w_generar_pedido_lote
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

event clicked;Long ll_lote, ll_ordenpd
s_base_parametros lstr_parametros_retro

ll_lote= Long(em_lote.Text)

SELECT distinct cs_ordenpd INTO :ll_ordenpd
FROM m_lotes_conf
WHERE lote = :ll_lote;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al buscar lote")
	ROLLBACK;
ELSE
	IF SQLCA.SQLCode = 100 THEN
	  MessageBox("Error Base Datos","Lote no existe")
	  ROLLBACK;
   END IF
END IF


DECLARE pr_pedpend_2 PROCEDURE FOR
	pr_pedpend_2(:ll_ordenpd);

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros_retro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

EXECUTE pr_pedpend_2;
Close(w_retroalimentacion)
Close(Parent)
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
	ROLLBACK;
ELSE
	COMMIT;
	MessageBox("O.K.","GRABO BIEN")
	CLOSE (w_generar_pedido_lote)
	
	//OpenSheet(w_total_ordencorte, w_principal)
END IF
end event

type em_lote from editmask within w_generar_pedido_lote
integer x = 357
integer y = 88
integer width = 480
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

type st_1 from statictext within w_generar_pedido_lote
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
string text = "Lote :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_generar_pedido_lote
integer x = 41
integer y = 24
integer width = 827
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

