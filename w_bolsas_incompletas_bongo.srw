HA$PBExportHeader$w_bolsas_incompletas_bongo.srw
forward
global type w_bolsas_incompletas_bongo from w_preview_de_impresion
end type
type cb_1 from commandbutton within w_bolsas_incompletas_bongo
end type
type sle_1 from singlelineedit within w_bolsas_incompletas_bongo
end type
type st_1 from statictext within w_bolsas_incompletas_bongo
end type
end forward

global type w_bolsas_incompletas_bongo from w_preview_de_impresion
integer width = 3406
cb_1 cb_1
sle_1 sle_1
st_1 st_1
end type
global w_bolsas_incompletas_bongo w_bolsas_incompletas_bongo

on w_bolsas_incompletas_bongo.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_1=create sle_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.st_1
end on

on w_bolsas_incompletas_bongo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.st_1)
end on

event open;this.width= 3406
this.height=1928
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_bolsas_incompletas_bongo
integer width = 3310
integer height = 1520
integer taborder = 0
string dataobject = "dtc_faltantes_bolsa_bongo"
end type

type cb_1 from commandbutton within w_bolsas_incompletas_bongo
integer x = 2418
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
string text = "Ver Reporte"
end type

event clicked;
LONG  ll_hallados
string ls_bongo
//s_base_parametros 	lstr_parametros

//
dw_reporte.settransobject(sqlca)
//ii_ancho= dw_reporte.width 
//ii_alto = dw_reporte.height
//ii_posx = dw_reporte.x   
//ii_posy = dw_reporte.y 
//
ls_bongo			=String(sle_1.TEXT)

ll_hallados = dw_reporte.Retrieve(ls_bongo)
	
	
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

type sle_1 from singlelineedit within w_bolsas_incompletas_bongo
integer x = 265
integer y = 16
integer width = 343
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_bolsas_incompletas_bongo
integer x = 73
integer y = 44
integer width = 187
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

