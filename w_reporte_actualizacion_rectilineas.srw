HA$PBExportHeader$w_reporte_actualizacion_rectilineas.srw
forward
global type w_reporte_actualizacion_rectilineas from w_preview_de_impresion
end type
type em_fabrica from editmask within w_reporte_actualizacion_rectilineas
end type
type em_linea from editmask within w_reporte_actualizacion_rectilineas
end type
type em_referencia from editmask within w_reporte_actualizacion_rectilineas
end type
type em_op from editmask within w_reporte_actualizacion_rectilineas
end type
type em_rollo from editmask within w_reporte_actualizacion_rectilineas
end type
type st_1 from statictext within w_reporte_actualizacion_rectilineas
end type
type st_2 from statictext within w_reporte_actualizacion_rectilineas
end type
type st_3 from statictext within w_reporte_actualizacion_rectilineas
end type
type st_4 from statictext within w_reporte_actualizacion_rectilineas
end type
type st_5 from statictext within w_reporte_actualizacion_rectilineas
end type
type cb_buscar from commandbutton within w_reporte_actualizacion_rectilineas
end type
end forward

global type w_reporte_actualizacion_rectilineas from w_preview_de_impresion
integer width = 3387
em_fabrica em_fabrica
em_linea em_linea
em_referencia em_referencia
em_op em_op
em_rollo em_rollo
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
cb_buscar cb_buscar
end type
global w_reporte_actualizacion_rectilineas w_reporte_actualizacion_rectilineas

on w_reporte_actualizacion_rectilineas.create
int iCurrent
call super::create
this.em_fabrica=create em_fabrica
this.em_linea=create em_linea
this.em_referencia=create em_referencia
this.em_op=create em_op
this.em_rollo=create em_rollo
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.cb_buscar=create cb_buscar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_fabrica
this.Control[iCurrent+2]=this.em_linea
this.Control[iCurrent+3]=this.em_referencia
this.Control[iCurrent+4]=this.em_op
this.Control[iCurrent+5]=this.em_rollo
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.cb_buscar
end on

on w_reporte_actualizacion_rectilineas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_fabrica)
destroy(this.em_linea)
destroy(this.em_referencia)
destroy(this.em_op)
destroy(this.em_rollo)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.cb_buscar)
end on

event open;THIS.width = 3387
THIS.height = 1928
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_actualizacion_rectilineas
integer y = 116
integer width = 3264
integer height = 1580
string dataobject = "dtb_reporte_rectilineos_act_unidades"
end type

type em_fabrica from editmask within w_reporte_actualizacion_rectilineas
integer x = 160
integer y = 28
integer width = 133
integer height = 68
integer taborder = 10
boolean bringtotop = true
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

type em_linea from editmask within w_reporte_actualizacion_rectilineas
integer x = 526
integer y = 28
integer width = 151
integer height = 68
integer taborder = 20
boolean bringtotop = true
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

type em_referencia from editmask within w_reporte_actualizacion_rectilineas
integer x = 1006
integer y = 32
integer width = 297
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#######"
end type

type em_op from editmask within w_reporte_actualizacion_rectilineas
integer x = 1518
integer y = 32
integer width = 302
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#######"
end type

type em_rollo from editmask within w_reporte_actualizacion_rectilineas
integer x = 2149
integer y = 28
integer width = 343
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type st_1 from statictext within w_reporte_actualizacion_rectilineas
integer x = 14
integer y = 32
integer width = 142
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "FAB:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_reporte_actualizacion_rectilineas
integer x = 320
integer y = 36
integer width = 206
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "LINEA:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_reporte_actualizacion_rectilineas
integer x = 699
integer y = 36
integer width = 311
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "REFEREN:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_reporte_actualizacion_rectilineas
integer x = 1394
integer y = 32
integer width = 119
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.P"
boolean focusrectangle = false
end type

type st_5 from statictext within w_reporte_actualizacion_rectilineas
integer x = 1925
integer y = 32
integer width = 215
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "ROLLO:"
boolean focusrectangle = false
end type

type cb_buscar from commandbutton within w_reporte_actualizacion_rectilineas
integer x = 2629
integer y = 8
integer width = 270
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
end type

event clicked;
Long	ll_co_fabrica, ll_co_linea
long		ll_cs_orden, ll_referencia, ll_cs_rollo
String ls_nombredw
		

IF len(trim(em_fabrica.text)) = 0 THEN
	ll_co_fabrica = 0
ELSE
	ll_co_fabrica = Long(em_fabrica.text)
END IF

IF len(trim(em_linea.text)) = 0 THEN
	ll_co_linea = 0
ELSE
	ll_co_linea = Long(em_linea.text)
END IF

IF len(trim(em_referencia.text)) = 0 THEN
	ll_referencia = 0
ELSE
	ll_referencia = Long(em_referencia.text)
END IF

IF len(trim(em_op.text)) = 0 THEN
	ll_cs_orden = 0
ELSE
	ll_cs_orden = Long(em_op.text)
END IF

IF len(trim(em_rollo.text)) = 0 THEN
	ll_cs_rollo = 0
ELSE
	ll_cs_rollo = Long(em_rollo.text)
END IF


//SetPointer(HourGlass!)
DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;
dw_reporte.SetTransObject(SQLCA)
//
dw_reporte.visible = true
dw_reporte.Retrieve(ll_co_fabrica,ll_co_linea,ll_referencia,ll_cs_orden,ll_cs_rollo)
SetPointer(Arrow!)

end event

