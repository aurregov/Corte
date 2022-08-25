HA$PBExportHeader$w_cargar_telas_nicole.srw
forward
global type w_cargar_telas_nicole from window
end type
type cb_2 from commandbutton within w_cargar_telas_nicole
end type
type cb_1 from commandbutton within w_cargar_telas_nicole
end type
type st_2 from statictext within w_cargar_telas_nicole
end type
type st_1 from statictext within w_cargar_telas_nicole
end type
type sle_centro from singlelineedit within w_cargar_telas_nicole
end type
type sle_fabrica from singlelineedit within w_cargar_telas_nicole
end type
type gb_1 from groupbox within w_cargar_telas_nicole
end type
end forward

global type w_cargar_telas_nicole from window
integer width = 1019
integer height = 980
boolean titlebar = true
string title = "Cargar Telas Nicole a Marinilla"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
st_2 st_2
st_1 st_1
sle_centro sle_centro
sle_fabrica sle_fabrica
gb_1 gb_1
end type
global w_cargar_telas_nicole w_cargar_telas_nicole

on w_cargar_telas_nicole.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_2=create st_2
this.st_1=create st_1
this.sle_centro=create sle_centro
this.sle_fabrica=create sle_fabrica
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.st_2,&
this.st_1,&
this.sle_centro,&
this.sle_fabrica,&
this.gb_1}
end on

on w_cargar_telas_nicole.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_centro)
destroy(this.sle_fabrica)
destroy(this.gb_1)
end on

event open;sle_fabrica.Text = '2'
sle_centro.SetFocus()
end event

type cb_2 from commandbutton within w_cargar_telas_nicole
integer x = 549
integer y = 672
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_1 from commandbutton within w_cargar_telas_nicole
integer x = 59
integer y = 672
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Long li_fabrica, li_centro, li_pos_cortar, li_pos_inicial

li_fabrica = Long(sle_fabrica.Text)
li_centro = Long(sle_centro.Text)

IF IsNull(li_fabrica) THEN
	MessageBox('Advertencia','Debe especificarse la fabrica',Exclamation!)
	Return
END IF

//se debe especificar con Luis Evelio si en esto se deb realizar algun control
//como por ejemplo no permitir cargar los rollos de la fabrica 91


IF IsNull(li_centro) THEN
	MessageBox('Advertencia','Debe especificarse el centro',Exclamation!)
	Return
END IF

//se ejecuta procedimiento almacenado que carga las telas de Nicole a Marinilla y afecta el Kardex.
//jcrm
//junio 12 de 2007
DECLARE telas_nicole PROCEDURE FOR
	pr_cargar_tela_nicole(:li_fabrica,:li_centro);
EXECUTE telas_nicole;
IF SQLCA.SQLCode = -1 THEN			
	IF SQLCA.SQLDBCode = -746 THEN
		li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
		li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
		ROLLBACK;
		MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
	ELSE
		ROLLBACK;
		MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
	END IF
ELSE
	COMMIT;
	MessageBox('Exito','Se efectuo con exito la carga de  la tela, por favor verifique los datos. ')
END IF
end event

type st_2 from statictext within w_cargar_telas_nicole
integer x = 96
integer y = 368
integer width = 256
integer height = 56
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cargar_telas_nicole
integer x = 96
integer y = 192
integer width = 256
integer height = 56
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fabrica:"
boolean focusrectangle = false
end type

type sle_centro from singlelineedit within w_cargar_telas_nicole
integer x = 485
integer y = 368
integer width = 343
integer height = 100
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

type sle_fabrica from singlelineedit within w_cargar_telas_nicole
integer x = 485
integer y = 192
integer width = 343
integer height = 100
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

type gb_1 from groupbox within w_cargar_telas_nicole
integer x = 27
integer y = 68
integer width = 942
integer height = 520
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

