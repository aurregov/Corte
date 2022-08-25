HA$PBExportHeader$w_inventario_fisico_bongos.srw
forward
global type w_inventario_fisico_bongos from w_preview_de_impresion
end type
type cb_1 from commandbutton within w_inventario_fisico_bongos
end type
type sle_1 from singlelineedit within w_inventario_fisico_bongos
end type
type st_1 from statictext within w_inventario_fisico_bongos
end type
type st_2 from statictext within w_inventario_fisico_bongos
end type
type sle_fabrica from singlelineedit within w_inventario_fisico_bongos
end type
end forward

global type w_inventario_fisico_bongos from w_preview_de_impresion
integer width = 2981
cb_1 cb_1
sle_1 sle_1
st_1 st_1
st_2 st_2
sle_fabrica sle_fabrica
end type
global w_inventario_fisico_bongos w_inventario_fisico_bongos

on w_inventario_fisico_bongos.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_1=create sle_1
this.st_1=create st_1
this.st_2=create st_2
this.sle_fabrica=create sle_fabrica
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_fabrica
end on

on w_inventario_fisico_bongos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_fabrica)
end on

event open;//nada
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_inventario_fisico_bongos
integer height = 1600
integer taborder = 0
string dataobject = "dtc_inventario_fisico_bongos"
end type

type cb_1 from commandbutton within w_inventario_fisico_bongos
integer x = 2418
integer y = 20
integer width = 343
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ver Reporte"
end type

event clicked;
LONG  ll_hallados,ll_fabrica
STRING ls_bongo
//s_base_parametros 	lstr_parametros

//
dw_reporte.settransobject(sqlca)
//ii_ancho= dw_reporte.width 
//ii_alto = dw_reporte.height
//ii_posx = dw_reporte.x   
//ii_posy = dw_reporte.y 
//
ls_bongo			=string(sle_1.TEXT)
ll_fabrica		=Long(sle_fabrica.TEXT)
ll_hallados = dw_reporte.Retrieve(ll_fabrica,ls_bongo)
	
	
	IF isnull(ll_hallados) THEN
		MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
	ELSE
	CHOOSE CASE ll_hallados
			CASE -1
				MessageBox("Error buscando","Error de la base",StopSign!,Ok!)
			CASE 0
				MessageBox("Sin Datos","No hay datos para su criterio",Exclamation!,Ok!)
			CASE ELSE
		END CHOOSE
	END IF
dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")





end event

type sle_1 from singlelineedit within w_inventario_fisico_bongos
string tag = "Digite el n$$HEX1$$fa00$$ENDHEX$$mero del bongo o 0 para todos"
integer x = 1074
integer y = 20
integer width = 343
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
string text = "0"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_inventario_fisico_bongos
integer x = 837
integer y = 44
integer width = 192
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bongo:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_inventario_fisico_bongos
integer x = 105
integer y = 44
integer width = 229
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fabrica:"
boolean focusrectangle = false
end type

type sle_fabrica from singlelineedit within w_inventario_fisico_bongos
integer x = 347
integer y = 12
integer width = 343
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "91"
borderstyle borderstyle = stylelowered!
end type

