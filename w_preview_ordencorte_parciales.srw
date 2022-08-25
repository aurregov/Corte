HA$PBExportHeader$w_preview_ordencorte_parciales.srw
forward
global type w_preview_ordencorte_parciales from w_preview_de_impresion
end type
type em_raya from editmask within w_preview_ordencorte_parciales
end type
type st_4 from statictext within w_preview_ordencorte_parciales
end type
type em_ordencorte from editmask within w_preview_ordencorte_parciales
end type
type st_1 from statictext within w_preview_ordencorte_parciales
end type
type aceptar from picturebutton within w_preview_ordencorte_parciales
end type
type st_2 from statictext within w_preview_ordencorte_parciales
end type
end forward

global type w_preview_ordencorte_parciales from w_preview_de_impresion
integer width = 3561
windowstate windowstate = maximized!
em_raya em_raya
st_4 st_4
em_ordencorte em_ordencorte
st_1 st_1
aceptar aceptar
st_2 st_2
end type
global w_preview_ordencorte_parciales w_preview_ordencorte_parciales

on w_preview_ordencorte_parciales.create
int iCurrent
call super::create
this.em_raya=create em_raya
this.st_4=create st_4
this.em_ordencorte=create em_ordencorte
this.st_1=create st_1
this.aceptar=create aceptar
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_raya
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.em_ordencorte
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.aceptar
this.Control[iCurrent+6]=this.st_2
end on

on w_preview_ordencorte_parciales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_raya)
destroy(this.st_4)
destroy(this.em_ordencorte)
destroy(this.st_1)
destroy(this.aceptar)
destroy(this.st_2)
end on

event open;call super::open;
This.WindowState = Maximized!
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_ordencorte_parciales
integer width = 3479
integer height = 1584
integer taborder = 0
string dataobject = "dtb_variaciones1"
end type

type em_raya from editmask within w_preview_ordencorte_parciales
integer x = 2569
integer y = 32
integer width = 297
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "10"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

event modified;em_raya.SelectText(1, Len(em_raya.Text))
end event

type st_4 from statictext within w_preview_ordencorte_parciales
integer x = 2350
integer y = 44
integer width = 201
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Raya:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ordencorte from editmask within w_preview_ordencorte_parciales
integer x = 1938
integer y = 32
integer width = 297
integer height = 76
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
string mask = "#######"
end type

event modified;em_raya.SelectText(1, Len(em_raya.Text))
end event

type st_1 from statictext within w_preview_ordencorte_parciales
integer x = 1573
integer y = 44
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de corte:"
boolean focusrectangle = false
end type

type aceptar from picturebutton within w_preview_ordencorte_parciales
integer x = 3086
integer y = 24
integer width = 379
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
boolean default = true
string picturename = "k:\desarrollo\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;STRING ls_grupo
LONG  ll_hallados,ll_raya,ll_ordencorte

s_base_parametros 	lstr_parametros


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

ll_ordencorte				=long(em_ordencorte.TEXT)
ll_raya						=long(em_raya.TEXT)


ll_hallados = dw_reporte.Retrieve(ll_ordencorte,ll_raya)
	
	
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

type st_2 from statictext within w_preview_ordencorte_parciales
integer x = 32
integer y = 72
integer width = 603
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
string text = "Imprimir en papel extraoficio"
alignment alignment = right!
boolean focusrectangle = false
end type

