HA$PBExportHeader$w_mantenimiento_cptos_liq_corte.srw
forward
global type w_mantenimiento_cptos_liq_corte from w_base_tabular
end type
type cb_1 from commandbutton within w_mantenimiento_cptos_liq_corte
end type
type cb_2 from commandbutton within w_mantenimiento_cptos_liq_corte
end type
type cb_3 from commandbutton within w_mantenimiento_cptos_liq_corte
end type
end forward

global type w_mantenimiento_cptos_liq_corte from w_base_tabular
integer width = 1673
integer height = 1288
string title = "Parciales Corte"
long backcolor = 81324524
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type
global w_mantenimiento_cptos_liq_corte w_mantenimiento_cptos_liq_corte

on w_mantenimiento_cptos_liq_corte.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
end on

on w_mantenimiento_cptos_liq_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event open;call super::open;Long	li_resultado

This.width = 1637
This.height = 1288

//IF gstr_info_usuario.codigo_usuario = 'ljgarcia' THEN
//ELSE
//	MessageBox("Error","No est$$HEX2$$e1002000$$ENDHEX$$autorizado")
//	Close(This)
//	RETURN 1
//END IF
//
//OpenWithParm(w_conexion_devolver_liquidacion, 6)
//li_resultado = Message.DoubleParm
//IF li_resultado = 0 THEN
//	MessageBox("Error","No est$$HEX2$$e1002000$$ENDHEX$$autorizado")
//	Close(This)
//END IF
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_cptos_liq_corte
integer y = 92
integer width = 1207
integer height = 944
string dataobject = "dtb_mantenimiento_cptos_liq_corte"
end type

event dw_maestro::itemchanged;IF Row > 0 THEN
	SetItem(Row, "fe_actualizacion", DateTime(Today(), Now()))
	SetItem(Row, "fe_creacion", DateTime(Today(), Now()))
	SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
	SetItem(Row, "instancia", gstr_info_usuario.instancia)	
END IF
end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_cptos_liq_corte
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_cptos_liq_corte
end type

type cb_1 from commandbutton within w_mantenimiento_cptos_liq_corte
integer x = 1271
integer y = 228
integer width = 343
integer height = 100
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar"
end type

event clicked;parent.triggerevent('ue_insertar_maestro')
end event

type cb_2 from commandbutton within w_mantenimiento_cptos_liq_corte
integer x = 1271
integer y = 384
integer width = 343
integer height = 100
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Borrar"
end type

event clicked;parent.triggerevent('ue_borrar_maestro')
end event

type cb_3 from commandbutton within w_mantenimiento_cptos_liq_corte
integer x = 1271
integer y = 544
integer width = 343
integer height = 100
integer taborder = 31
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar"
end type

event clicked;Parent.TriggerEvent("ue_grabar")
end event

