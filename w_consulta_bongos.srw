HA$PBExportHeader$w_consulta_bongos.srw
forward
global type w_consulta_bongos from w_preview_de_impresion
end type
type cb_1 from commandbutton within w_consulta_bongos
end type
type sle_grupo from singlelineedit within w_consulta_bongos
end type
type sle_estilo from singlelineedit within w_consulta_bongos
end type
type sle_po from singlelineedit within w_consulta_bongos
end type
type sle_bongo from singlelineedit within w_consulta_bongos
end type
type st_1 from statictext within w_consulta_bongos
end type
type st_2 from statictext within w_consulta_bongos
end type
type st_4 from statictext within w_consulta_bongos
end type
type sle_ubicacion from singlelineedit within w_consulta_bongos
end type
type sle_estado from singlelineedit within w_consulta_bongos
end type
type st_5 from statictext within w_consulta_bongos
end type
type st_6 from statictext within w_consulta_bongos
end type
end forward

global type w_consulta_bongos from w_preview_de_impresion
integer width = 3506
cb_1 cb_1
sle_grupo sle_grupo
sle_estilo sle_estilo
sle_po sle_po
sle_bongo sle_bongo
st_1 st_1
st_2 st_2
st_4 st_4
sle_ubicacion sle_ubicacion
sle_estado sle_estado
st_5 st_5
st_6 st_6
end type
global w_consulta_bongos w_consulta_bongos

on w_consulta_bongos.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_grupo=create sle_grupo
this.sle_estilo=create sle_estilo
this.sle_po=create sle_po
this.sle_bongo=create sle_bongo
this.st_1=create st_1
this.st_2=create st_2
this.st_4=create st_4
this.sle_ubicacion=create sle_ubicacion
this.sle_estado=create sle_estado
this.st_5=create st_5
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_grupo
this.Control[iCurrent+3]=this.sle_estilo
this.Control[iCurrent+4]=this.sle_po
this.Control[iCurrent+5]=this.sle_bongo
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_ubicacion
this.Control[iCurrent+10]=this.sle_estado
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_6
end on

on w_consulta_bongos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_grupo)
destroy(this.sle_estilo)
destroy(this.sle_po)
destroy(this.sle_bongo)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.sle_ubicacion)
destroy(this.sle_estado)
destroy(this.st_5)
destroy(this.st_6)
end on

event open;//nada
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_consulta_bongos
integer width = 3438
integer taborder = 0
string dataobject = "dtc_consulta_de_bongos"
end type

type cb_1 from commandbutton within w_consulta_bongos
integer x = 3127
integer y = 20
integer width = 315
integer height = 84
integer taborder = 70
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
LONG  ll_hallados,ll_estado
STRING as_grupo,as_estilo,as_po,ls_bongo,ll_ubicacion
//s_base_parametros 	lstr_parametros

//
dw_reporte.settransobject(sqlca)
//ii_ancho= dw_reporte.width 
//ii_alto = dw_reporte.height
//ii_posx = dw_reporte.x   
//ii_posy = dw_reporte.y 
//
ls_bongo			=string(sle_bongo.TEXT)
as_grupo			=string(sle_grupo.TEXT)
as_estilo		=trim(string(sle_estilo.TEXT))
as_po				=string(sle_po.TEXT)
ll_ubicacion	=string(sle_ubicacion.TEXT)
ll_estado		=Long(sle_estado.TEXT)

ll_hallados = dw_reporte.Retrieve(ls_bongo,as_estilo,as_po,ll_ubicacion)
	
	
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

type sle_grupo from singlelineedit within w_consulta_bongos
boolean visible = false
integer x = 549
integer y = 20
integer width = 91
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
borderstyle borderstyle = stylelowered!
end type

type sle_estilo from singlelineedit within w_consulta_bongos
integer x = 814
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
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type sle_po from singlelineedit within w_consulta_bongos
integer x = 1298
integer y = 20
integer width = 329
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type sle_bongo from singlelineedit within w_consulta_bongos
integer x = 283
integer y = 20
integer width = 229
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
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_consulta_bongos
integer x = 1207
integer y = 56
integer width = 96
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
string text = "P.o:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_consulta_bongos
integer x = 681
integer y = 56
integer width = 137
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
string text = "Estilo:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_consulta_bongos
integer x = 18
integer y = 56
integer width = 242
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
string text = "Recipiente"
boolean focusrectangle = false
end type

type sle_ubicacion from singlelineedit within w_consulta_bongos
integer x = 1925
integer y = 20
integer width = 279
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type sle_estado from singlelineedit within w_consulta_bongos
boolean visible = false
integer x = 2729
integer y = 24
integer width = 343
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "0"
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_consulta_bongos
integer x = 1678
integer y = 56
integer width = 251
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
string text = "Ubicaci$$HEX1$$f300$$ENDHEX$$n:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_consulta_bongos
boolean visible = false
integer x = 2542
integer y = 56
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
string text = "Estado:"
alignment alignment = right!
boolean focusrectangle = false
end type

