HA$PBExportHeader$w_preview_variaciones_resumen.srw
forward
global type w_preview_variaciones_resumen from w_preview_de_impresion
end type
type em_fecha_inicial from editmask within w_preview_variaciones_resumen
end type
type st_2 from statictext within w_preview_variaciones_resumen
end type
type em_fecha_final from editmask within w_preview_variaciones_resumen
end type
type st_3 from statictext within w_preview_variaciones_resumen
end type
type aceptar from picturebutton within w_preview_variaciones_resumen
end type
type st_4 from statictext within w_preview_variaciones_resumen
end type
type em_raya from editmask within w_preview_variaciones_resumen
end type
end forward

global type w_preview_variaciones_resumen from w_preview_de_impresion
integer width = 3630
integer height = 1864
em_fecha_inicial em_fecha_inicial
st_2 st_2
em_fecha_final em_fecha_final
st_3 st_3
aceptar aceptar
st_4 st_4
em_raya em_raya
end type
global w_preview_variaciones_resumen w_preview_variaciones_resumen

on w_preview_variaciones_resumen.create
int iCurrent
call super::create
this.em_fecha_inicial=create em_fecha_inicial
this.st_2=create st_2
this.em_fecha_final=create em_fecha_final
this.st_3=create st_3
this.aceptar=create aceptar
this.st_4=create st_4
this.em_raya=create em_raya
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_fecha_inicial
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_fecha_final
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.aceptar
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.em_raya
end on

on w_preview_variaciones_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_fecha_inicial)
destroy(this.st_2)
destroy(this.em_fecha_final)
destroy(this.st_3)
destroy(this.aceptar)
destroy(this.st_4)
destroy(this.em_raya)
end on

event open;this.width=3566
this.height=1928
This.WindowState = Maximized!

em_fecha_final.Text=string(today())
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_variaciones_resumen
integer x = 14
integer width = 3497
integer height = 1440
integer taborder = 0
string dataobject = "dtb_variaciones_resumen_espacio"
boolean hsplitscroll = false
end type

type em_fecha_inicial from editmask within w_preview_variaciones_resumen
integer x = 1015
integer y = 28
integer width = 297
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy-mm-dd"
end type

event modified;em_fecha_inicial.SelectText(1, Len(em_fecha_inicial.Text))

end event

type st_2 from statictext within w_preview_variaciones_resumen
integer x = 722
integer y = 28
integer width = 297
integer height = 76
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
string text = "Fecha Inicial:"
boolean focusrectangle = false
end type

type em_fecha_final from editmask within w_preview_variaciones_resumen
integer x = 1723
integer y = 28
integer width = 297
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy-mm-dd"
end type

event modified;em_fecha_final.SelectText(1, Len(em_fecha_final.Text))

end event

type st_3 from statictext within w_preview_variaciones_resumen
integer x = 1445
integer y = 28
integer width = 274
integer height = 76
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
string text = "Fecha Final:"
boolean focusrectangle = false
end type

type aceptar from picturebutton within w_preview_variaciones_resumen
integer x = 2871
integer y = 36
integer width = 379
integer height = 84
integer taborder = 50
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

event clicked;LONG  ll_hallados,ll_raya
DATE ld_fecha_inicial, ld_fecha_final
s_base_parametros 	lstr_parametros


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

ll_raya						=long(em_raya.TEXT)
ld_fecha_inicial			=date(em_fecha_inicial.TEXT)
ld_fecha_final				=date(em_fecha_final.TEXT)


ll_hallados = dw_reporte.Retrieve(ll_raya,ld_fecha_inicial,ld_fecha_final)
	
	
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

type st_4 from statictext within w_preview_variaciones_resumen
integer x = 32
integer y = 28
integer width = 201
integer height = 76
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

type em_raya from editmask within w_preview_variaciones_resumen
integer x = 233
integer y = 28
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

