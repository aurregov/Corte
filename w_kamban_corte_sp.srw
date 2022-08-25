HA$PBExportHeader$w_kamban_corte_sp.srw
forward
global type w_kamban_corte_sp from w_preview_de_impresion
end type
type cb_1 from commandbutton within w_kamban_corte_sp
end type
type em_fabrica from editmask within w_kamban_corte_sp
end type
type em_linea from editmask within w_kamban_corte_sp
end type
type em_referencia from editmask within w_kamban_corte_sp
end type
type em_orden_corte from editmask within w_kamban_corte_sp
end type
type em_estado from editmask within w_kamban_corte_sp
end type
type st_1 from statictext within w_kamban_corte_sp
end type
type st_2 from statictext within w_kamban_corte_sp
end type
type st_3 from statictext within w_kamban_corte_sp
end type
type st_4 from statictext within w_kamban_corte_sp
end type
type st_5 from statictext within w_kamban_corte_sp
end type
type cb_2 from commandbutton within w_kamban_corte_sp
end type
type cb_3 from commandbutton within w_kamban_corte_sp
end type
end forward

global type w_kamban_corte_sp from w_preview_de_impresion
integer width = 3118
cb_1 cb_1
em_fabrica em_fabrica
em_linea em_linea
em_referencia em_referencia
em_orden_corte em_orden_corte
em_estado em_estado
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
cb_2 cb_2
cb_3 cb_3
end type
global w_kamban_corte_sp w_kamban_corte_sp

on w_kamban_corte_sp.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.em_fabrica=create em_fabrica
this.em_linea=create em_linea
this.em_referencia=create em_referencia
this.em_orden_corte=create em_orden_corte
this.em_estado=create em_estado
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_fabrica
this.Control[iCurrent+3]=this.em_linea
this.Control[iCurrent+4]=this.em_referencia
this.Control[iCurrent+5]=this.em_orden_corte
this.Control[iCurrent+6]=this.em_estado
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.cb_2
this.Control[iCurrent+13]=this.cb_3
end on

on w_kamban_corte_sp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_fabrica)
destroy(this.em_linea)
destroy(this.em_referencia)
destroy(this.em_orden_corte)
destroy(this.em_estado)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event open;//no
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_kamban_corte_sp
integer y = 92
integer taborder = 70
string dataobject = "r_orden_gral2"
end type

type cb_1 from commandbutton within w_kamban_corte_sp
integer x = 2158
integer width = 274
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Generar"
end type

event clicked;Long	li_co_fabrica, li_co_linea, li_co_estado
LONG		ll_co_referencia, ll_orden_corte
s_base_parametros lstr_parametros, lstr_parametros_retro


IF len(trim(em_fabrica.text)) = 0 THEN
	li_co_fabrica = 0
ELSE
	li_co_fabrica = Long(em_fabrica.text)
END IF

IF len(trim(em_linea.text)) = 0 THEN
	li_co_linea = 0
ELSE
	li_co_linea = Long(em_linea.text)
END IF

IF len(trim(em_referencia.text)) = 0 THEN
	ll_co_referencia = 0
ELSE
	ll_co_referencia = Long(em_referencia.text)
END IF

IF len(trim(em_orden_corte.text)) = 0 THEN
	ll_orden_corte = 0
ELSE
	ll_orden_corte = Long(em_orden_corte.text)
END IF

IF len(trim(em_estado.text)) = 0 THEN
	li_co_estado = 0
ELSE
	li_co_estado = Long(em_estado.text)
END IF

lstr_parametros_retro.cadena[1]="Generando Reporte ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion puede durar unos segundos..."
lstr_parametros_retro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
SQLCA.LOCK = "Dirty Read"
DISCONNECT;
CONNECT;
dw_reporte.SetTransObject(SQLCA)

DECLARE generar PROCEDURE FOR
	pr_kamban_corte(:li_co_fabrica,:li_co_linea,:ll_co_referencia,:ll_orden_corte,:li_co_estado );
EXECUTE generar;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al generar la tabla temporal")
	ROLLBACK;
ELSE
	COMMIT;
	dw_reporte.Retrieve(gstr_info_usuario.codigo_usuario)
END IF
Close(w_retroalimentacion)
SQLCA.LOCK = "Cursor Stability"
DISCONNECT;
CONNECT;	

end event

type em_fabrica from editmask within w_kamban_corte_sp
integer x = 123
integer width = 128
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_linea from editmask within w_kamban_corte_sp
integer x = 421
integer width = 137
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type em_referencia from editmask within w_kamban_corte_sp
integer x = 795
integer width = 306
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "########"
end type

type em_orden_corte from editmask within w_kamban_corte_sp
integer x = 1403
integer width = 338
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

type em_estado from editmask within w_kamban_corte_sp
integer x = 1984
integer width = 151
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_1 from statictext within w_kamban_corte_sp
integer x = 5
integer y = 4
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fab:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_kamban_corte_sp
integer x = 283
integer y = 4
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Line:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_kamban_corte_sp
integer x = 576
integer y = 4
integer width = 233
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referen:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_kamban_corte_sp
integer x = 1147
integer y = 4
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ord. Cte:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_kamban_corte_sp
integer x = 1769
integer y = 4
integer width = 210
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estado:"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_kamban_corte_sp
integer x = 2711
integer width = 325
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Guardar..."
end type

event clicked;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","No hay datos para enviar a Excel",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",Excel5!,false)
END IF
end event

type cb_3 from commandbutton within w_kamban_corte_sp
integer x = 2432
integer width = 283
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Consultar"
end type

event clicked;STRING ls_usuario

ls_usuario  = string(gstr_info_usuario.codigo_usuario)

dw_reporte.SetTransObject(SQLCA)
	dw_reporte.Retrieve(gstr_info_usuario.codigo_usuario)


end event

