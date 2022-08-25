HA$PBExportHeader$w_tmp_trazos_sirve.srw
forward
global type w_tmp_trazos_sirve from w_base_simple
end type
type cb_1 from commandbutton within w_tmp_trazos_sirve
end type
type cb_2 from commandbutton within w_tmp_trazos_sirve
end type
type dw_talla_prog from datawindow within w_tmp_trazos_sirve
end type
type st_1 from statictext within w_tmp_trazos_sirve
end type
end forward

global type w_tmp_trazos_sirve from w_base_simple
integer width = 2816
integer height = 2672
boolean titlebar = false
string menuname = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
cb_2 cb_2
dw_talla_prog dw_talla_prog
st_1 st_1
end type
global w_tmp_trazos_sirve w_tmp_trazos_sirve

on w_tmp_trazos_sirve.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.dw_talla_prog=create dw_talla_prog
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_talla_prog
this.Control[iCurrent+4]=this.st_1
end on

on w_tmp_trazos_sirve.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.dw_talla_prog)
destroy(this.st_1)
end on

event open;n_cts_param luo_param


dw_talla_prog.SetTransObject(SQLCA)


luo_param = Message.PowerObjectParm
IF IsValid(luo_param) THEN
	dw_maestro.SetTransObject(SQLCA)
	dw_maestro.Retrieve(luo_param.is_vector[1])
	dw_talla_prog.Retrieve(luo_param.il_vector[1])
END IF

//SetPointer(HourGlass!)
//String ls_resultado
//
//ls_resultado = dw_maestro.Describe("DataWindow.Print.Preview")
//if ls_resultado <> 'yes' then
//	dw_maestro.Modify("DataWindow.Print.Preview=Yes")
//	dw_maestro.Modify("DataWindow.Print.Preview.Rulers=Yes")
//else
//	dw_maestro.Modify("DataWindow.Print.Preview.Rulers=No")
//	dw_maestro.Modify("DataWindow.Print.Preview=No")
//end if
//
//SetPointer(Arrow!)
end event

event closequery;//se omite 
end event

type dw_maestro from w_base_simple`dw_maestro within w_tmp_trazos_sirve
integer x = 9
integer y = 144
integer width = 2322
integer height = 2456
string dataobject = "ds_tmp_trazos_sirve"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::clicked;call super::clicked;IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
		this.selectrow(row, Not(dw_maestro.IsSelected(row)))
END IF
end event

event dw_maestro::rowfocuschanged;//se omite
end event

event dw_maestro::itemchanged;Long	ll_capas, ll_trazo, ll_trazo_act
Long	posi

choose case GetColumnName()
	case 'capas'
		ll_capas = LONG(DATA)
		ll_trazo = This.getItemNumber(Row,'co_trazo')
		FOR posi = 1 TO dw_maestro.RowCount()
			ll_trazo_act = This.getItemNumber(posi,'co_trazo')
			IF ll_trazo = ll_trazo_act THEN
				This.SetItem(posi,'capas',ll_capas)
			END IF
		NEXT
		dw_maestro.Accepttext()
end choose
end event

type cb_1 from commandbutton within w_tmp_trazos_sirve
integer x = 827
integer y = 24
integer width = 338
integer height = 116
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;String 	ls_password
Long		ll_trazo, ll_trazo_ant
s_base_parametros_seleccionar lstr_parametros

Long ll_filas, ll_filaactual, ll_insertados
//
//
ll_filas = dw_maestro.RowCount()
//
ll_insertados = 1
ll_trazo_ant = 0
dw_maestro.Accepttext()

FOR ll_filaactual = 1 TO ll_filas
	IF dw_maestro.IsSelected(ll_filaactual) THEN
		ll_trazo = dw_maestro.GetItemNumber(ll_filaactual, "co_trazo")		
		IF ll_trazo <> ll_trazo_ant THEN
			ll_insertados = ll_insertados + 1	
			lstr_parametros.entero1[ll_insertados] = dw_maestro.GetItemNumber(ll_filaactual, "cs_agrupacion")		
			lstr_parametros.entero2[ll_insertados] = dw_maestro.GetItemNumber(ll_filaactual, "cs_pdn")		
			lstr_parametros.entero3[ll_insertados] = dw_maestro.GetItemNumber(ll_filaactual, "raya")		
			lstr_parametros.entero4[ll_insertados] = dw_maestro.GetItemNumber(ll_filaactual, "co_trazo")		
			lstr_parametros.entero5[ll_insertados] = dw_maestro.GetItemNumber(ll_filaactual, "capas")		
		END IF
	END If
	ll_trazo_ant = ll_trazo
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros.entero1[1] = ll_insertados
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False	
END IF

CloseWithReturn(Parent, lstr_parametros)
end event

type cb_2 from commandbutton within w_tmp_trazos_sirve
integer x = 1225
integer y = 24
integer width = 334
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Rechazar"
end type

event clicked;s_base_parametros_seleccionar lstr_parametros

lstr_parametros.hay_parametros = False	

CloseWithReturn(Parent, lstr_parametros)
end event

type dw_talla_prog from datawindow within w_tmp_trazos_sirve
integer x = 2345
integer y = 552
integer width = 443
integer height = 1048
integer taborder = 11
boolean bringtotop = true
string title = "none"
string dataobject = "dt_talla_unid_agrupacion"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_tmp_trazos_sirve
integer x = 2336
integer y = 488
integer width = 416
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Talla Programadas"
boolean focusrectangle = false
end type

