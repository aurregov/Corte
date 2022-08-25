HA$PBExportHeader$w_lotear_bongo.srw
forward
global type w_lotear_bongo from window
end type
type cb_cancelar from commandbutton within w_lotear_bongo
end type
type cb_lotear from commandbutton within w_lotear_bongo
end type
type em_bongo from editmask within w_lotear_bongo
end type
type st_1 from statictext within w_lotear_bongo
end type
type gb_1 from groupbox within w_lotear_bongo
end type
end forward

global type w_lotear_bongo from window
integer width = 731
integer height = 416
boolean titlebar = true
string title = "Lotear Bongo"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_lotear cb_lotear
em_bongo em_bongo
st_1 st_1
gb_1 gb_1
end type
global w_lotear_bongo w_lotear_bongo

on w_lotear_bongo.create
this.cb_cancelar=create cb_cancelar
this.cb_lotear=create cb_lotear
this.em_bongo=create em_bongo
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_lotear,&
this.em_bongo,&
this.st_1,&
this.gb_1}
end on

on w_lotear_bongo.destroy
destroy(this.cb_cancelar)
destroy(this.cb_lotear)
destroy(this.em_bongo)
destroy(this.st_1)
destroy(this.gb_1)
end on

type cb_cancelar from commandbutton within w_lotear_bongo
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

type cb_lotear from commandbutton within w_lotear_bongo
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
string text = "&Lotear"
end type

event clicked;Long li_estadocanasta, li_fabrica, li_linea
Long ll_ordencorte, ll_referencia
String ls_bongo, ls_po
n_cst_loteo_bongo luo_loteo
n_cst_bolsa lpo_bolsa
s_base_parametros lstr_parametros

ls_bongo = em_bongo.Text

//se valida el estado de la canasta
SELECT	unique co_estado
INTO :li_estadocanasta
FROM h_canasta_corte
WHERE cs_canasta > 0 AND
		co_estado = 10 AND
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

//primero debo conocer la orden de corte y la po
SELECT DISTINCT dt_canasta_corte.cs_orden_corte, dt_canasta_corte.po, 
		dt_canasta_corte.co_fabrica_ref, dt_canasta_corte.co_linea, 
		dt_canasta_corte.co_referencia
 INTO :ll_ordencorte, :ls_po, :li_fabrica, :li_linea, :ll_referencia
 FROM dt_canasta_corte, h_canasta_corte
WHERE h_canasta_corte.pallet_id 		= :ls_bongo and
		dt_canasta_corte.cs_canasta 	= h_canasta_corte.cs_canasta;
		
IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error','No fue posible establecer si hay bolsas pendientes por leer. '+Sqlca.SqlErrText)
	Return -1
END IF	
	
////ahorra debe saber si no hay bolsas pendientes por leer
//IF lpo_bolsa.of_ultima_bolsa(ll_ordencorte,ls_po, li_fabrica, li_linea, ll_referencia,'',0) = -1 THEN
//	MessageBox('Advertencia','El recipiente no puede ser loteado existen, bolsas pendiente de lectura, por favor verifique sus datos.')
//	Return -1
//ELSE	
//	//no existen bolsas pendientes se puede proceder con el loteo.
//	Open(w_buscar_tipocentro)
//	lstr_parametros = Message.PowerObjectParm
//	IF lstr_parametros.hay_parametros THEN
//		IF luo_loteo.of_loteo_bongo(ls_bongo, lstr_parametros.entero[1],ll_ordencorte, '') = -1 THEN
//			ROLLBACK;
//		ELSE
//			COMMIT;
//			MessageBox("Loteo exitoso","El recipiente fue loteado")		
//		END IF
//	END IF
//END IF
end event

type em_bongo from editmask within w_lotear_bongo
integer x = 302
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###############"
end type

type st_1 from statictext within w_lotear_bongo
integer x = 50
integer y = 68
integer width = 251
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Recipiente:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_lotear_bongo
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

