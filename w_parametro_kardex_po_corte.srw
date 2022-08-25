HA$PBExportHeader$w_parametro_kardex_po_corte.srw
forward
global type w_parametro_kardex_po_corte from window
end type
type st_7 from statictext within w_parametro_kardex_po_corte
end type
type st_6 from statictext within w_parametro_kardex_po_corte
end type
type st_5 from statictext within w_parametro_kardex_po_corte
end type
type em_po from editmask within w_parametro_kardex_po_corte
end type
type st_4 from statictext within w_parametro_kardex_po_corte
end type
type em_fe_fin from editmask within w_parametro_kardex_po_corte
end type
type em_fe_ini from editmask within w_parametro_kardex_po_corte
end type
type st_fe_fin from statictext within w_parametro_kardex_po_corte
end type
type st_fe_ini from statictext within w_parametro_kardex_po_corte
end type
type em_linea from editmask within w_parametro_kardex_po_corte
end type
type st_3 from statictext within w_parametro_kardex_po_corte
end type
type cb_2 from commandbutton within w_parametro_kardex_po_corte
end type
type cb_1 from commandbutton within w_parametro_kardex_po_corte
end type
type st_2 from statictext within w_parametro_kardex_po_corte
end type
type em_fabrica from editmask within w_parametro_kardex_po_corte
end type
type st_1 from statictext within w_parametro_kardex_po_corte
end type
type gb_1 from groupbox within w_parametro_kardex_po_corte
end type
end forward

global type w_parametro_kardex_po_corte from window
integer width = 1125
integer height = 936
boolean titlebar = true
string title = "Parametros Orden Corte"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_7 st_7
st_6 st_6
st_5 st_5
em_po em_po
st_4 st_4
em_fe_fin em_fe_fin
em_fe_ini em_fe_ini
st_fe_fin st_fe_fin
st_fe_ini st_fe_ini
em_linea em_linea
st_3 st_3
cb_2 cb_2
cb_1 cb_1
st_2 st_2
em_fabrica em_fabrica
st_1 st_1
gb_1 gb_1
end type
global w_parametro_kardex_po_corte w_parametro_kardex_po_corte

on w_parametro_kardex_po_corte.create
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.em_po=create em_po
this.st_4=create st_4
this.em_fe_fin=create em_fe_fin
this.em_fe_ini=create em_fe_ini
this.st_fe_fin=create st_fe_fin
this.st_fe_ini=create st_fe_ini
this.em_linea=create em_linea
this.st_3=create st_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_2=create st_2
this.em_fabrica=create em_fabrica
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_7,&
this.st_6,&
this.st_5,&
this.em_po,&
this.st_4,&
this.em_fe_fin,&
this.em_fe_ini,&
this.st_fe_fin,&
this.st_fe_ini,&
this.em_linea,&
this.st_3,&
this.cb_2,&
this.cb_1,&
this.st_2,&
this.em_fabrica,&
this.st_1,&
this.gb_1}
end on

on w_parametro_kardex_po_corte.destroy
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.em_po)
destroy(this.st_4)
destroy(this.em_fe_fin)
destroy(this.em_fe_ini)
destroy(this.st_fe_fin)
destroy(this.st_fe_ini)
destroy(this.em_linea)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.em_fabrica)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

em_fe_ini.Text =STRING(TODAY())
em_fe_fin.Text =STRING(TODAY())
end event

type st_7 from statictext within w_parametro_kardex_po_corte
integer x = 69
integer y = 496
integer width = 498
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "La fecha de despacho"
boolean focusrectangle = false
end type

type st_6 from statictext within w_parametro_kardex_po_corte
integer x = 59
integer y = 448
integer width = 1111
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Si Ingresa la P.O no es necesario ingresar"
boolean focusrectangle = false
end type

type st_5 from statictext within w_parametro_kardex_po_corte
integer x = 41
integer y = 572
integer width = 224
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = " # P.O.:"
boolean focusrectangle = false
end type

type em_po from editmask within w_parametro_kardex_po_corte
integer x = 288
integer y = 548
integer width = 343
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "aaaaaaaaaaaa"
end type

type st_4 from statictext within w_parametro_kardex_po_corte
integer x = 658
integer y = 100
integer width = 274
integer height = 52
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 67108864
string text = "dd/mm/yyyy"
boolean focusrectangle = false
end type

type em_fe_fin from editmask within w_parametro_kardex_po_corte
integer x = 590
integer y = 244
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fe_ini from editmask within w_parametro_kardex_po_corte
integer x = 590
integer y = 148
integer width = 343
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_fe_fin from statictext within w_parametro_kardex_po_corte
integer x = 32
integer y = 252
integer width = 571
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Despacho Fin:"
boolean focusrectangle = false
end type

type st_fe_ini from statictext within w_parametro_kardex_po_corte
integer x = 37
integer y = 160
integer width = 649
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Despacho Ini:"
boolean focusrectangle = false
end type

type em_linea from editmask within w_parametro_kardex_po_corte
integer x = 699
integer y = 360
integer width = 219
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type st_3 from statictext within w_parametro_kardex_po_corte
integer x = 535
integer y = 368
integer width = 210
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Linea:"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_parametro_kardex_po_corte
integer x = 329
integer y = 676
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Long 	li_fabrica, li_linea, li_x_fecha
Date		ldt_fe_ini, ldt_fe_fin
String	ls_usuario, ls_po
s_base_parametros lstr_parametros

IF len(trim(em_fabrica.text)) = 0 THEN 
	li_fabrica = 0
ELSE
	li_fabrica = Long(em_fabrica.text)
END IF

IF len(trim(em_linea.text)) = 0 THEN 
	li_linea = 0
ELSE
	li_linea = Long(em_linea.text)
END IF

IF len(trim(em_po.text)) = 0 THEN 
	ls_po = ''
	li_x_fecha = 1
ELSE
	ls_po = string(em_po.text)
	li_x_fecha = 0
END IF


ldt_fe_ini = date(em_fe_ini.text)
ldt_fe_fin = date(em_fe_fin.text)
ls_usuario = gstr_info_usuario.codigo_usuario


	
DECLARE pr_rep_po_corte PROCEDURE FOR
	pr_rep_kardex_po_corte(:ldt_fe_ini, :ldt_fe_fin, :li_fabrica, :li_linea, :ls_po, :li_x_fecha);
	
lstr_parametros.cadena[1]="Ejecutando proceso ..."
lstr_parametros.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros)
	
EXECUTE pr_rep_po_corte;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al generar la tabla temporal")
	ROLLBACK;
	Return;
ELSE
	COMMIT;
END IF
Close(w_retroalimentacion)

w_preview_de_impresion.dw_reporte.Retrieve(ls_usuario)
Close(Parent)
end event

type cb_1 from commandbutton within w_parametro_kardex_po_corte
integer x = 699
integer y = 676
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type st_2 from statictext within w_parametro_kardex_po_corte
integer x = 32
integer y = 24
integer width = 841
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese los datos para el proceso "
boolean focusrectangle = false
end type

type em_fabrica from editmask within w_parametro_kardex_po_corte
integer x = 293
integer y = 360
integer width = 178
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "2"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type st_1 from statictext within w_parametro_kardex_po_corte
integer x = 87
integer y = 372
integer width = 210
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fabrica"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_parametro_kardex_po_corte
integer y = 20
integer width = 1097
integer height = 624
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

