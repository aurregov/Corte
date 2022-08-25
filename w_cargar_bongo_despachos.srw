HA$PBExportHeader$w_cargar_bongo_despachos.srw
forward
global type w_cargar_bongo_despachos from window
end type
type cb_cancelar from commandbutton within w_cargar_bongo_despachos
end type
type cb_cargar from commandbutton within w_cargar_bongo_despachos
end type
type em_bongo from editmask within w_cargar_bongo_despachos
end type
type st_1 from statictext within w_cargar_bongo_despachos
end type
type gb_1 from groupbox within w_cargar_bongo_despachos
end type
end forward

global type w_cargar_bongo_despachos from window
integer width = 731
integer height = 416
boolean titlebar = true
string title = "Cargar Despachos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_cargar cb_cargar
em_bongo em_bongo
st_1 st_1
gb_1 gb_1
end type
global w_cargar_bongo_despachos w_cargar_bongo_despachos

type variables

end variables

on w_cargar_bongo_despachos.create
this.cb_cancelar=create cb_cancelar
this.cb_cargar=create cb_cargar
this.em_bongo=create em_bongo
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_cargar,&
this.em_bongo,&
this.st_1,&
this.gb_1}
end on

on w_cargar_bongo_despachos.destroy
destroy(this.cb_cancelar)
destroy(this.cb_cargar)
destroy(this.em_bongo)
destroy(this.st_1)
destroy(this.gb_1)
end on

type cb_cancelar from commandbutton within w_cargar_bongo_despachos
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

type cb_cargar from commandbutton within w_cargar_bongo_despachos
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
string text = "&Cargar"
end type

event clicked;Long li_estadocanasta
String ls_bongo
n_cst_loteo_bongo luo_loteo
s_base_parametros lstr_parametros

ls_bongo = em_bongo.Text

SELECT	unique co_estado
INTO :li_estadocanasta
FROM h_canasta_corte
WHERE co_estado <> 10 AND
		pallet_id = :ls_bongo;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar el estado de las canastas " + SQLCA.SQLErrText)
	Return -1
ELSE
	IF SQLCA.SQLCode = 100 THEN
		MessageBox("Advertencia...","El recipiente no se encuentra loteado")
		Return -1
	END IF
END IF

IF luo_loteo.of_cargar_despachos(ls_bongo) = -1 THEN
	ROLLBACK;
ELSE
	COMMIT;
	MessageBox("Carga exitosa","El recipiente fue cargado a despachos.")		
END IF

end event

type em_bongo from editmask within w_cargar_bongo_despachos
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_cargar_bongo_despachos
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

type gb_1 from groupbox within w_cargar_bongo_despachos
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

