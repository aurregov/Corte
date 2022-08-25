HA$PBExportHeader$w_modificar_produccion.srw
forward
global type w_modificar_produccion from w_base_simple
end type
type dw_1 from datawindow within w_modificar_produccion
end type
type cb_1 from commandbutton within w_modificar_produccion
end type
type gb_1 from groupbox within w_modificar_produccion
end type
end forward

global type w_modificar_produccion from w_base_simple
integer width = 3067
integer height = 1608
dw_1 dw_1
cb_1 cb_1
gb_1 gb_1
end type
global w_modificar_produccion w_modificar_produccion

type variables
long il_fila_Actual
end variables

on w_modificar_produccion.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_modificar_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;dw_maestro.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_1.InsertRow(0)
This.WindowState = Maximized!



end event

event ue_insertar_maestro;//nada
end event

event ue_buscar;//nada
end event

event ue_borrar_maestro;Long li_registro, li_Del, rtn
li_registro=dw_maestro.GetSelectedRow(0)  // Tomo registro actual
li_Del = dw_maestro.DeleteRow(li_registro)  //borro registro en el datawindows

//IF li_Del <> 0 THEN   // si fue exitoso grabo
//
//   rtn = dw_maestro.update()
//	IF rtn = 1 AND SQLCA.SQLNRows > 0 THEN
//	   COMMIT USING SQLCA;
//	END IF
//END IF
//
end event

type dw_maestro from w_base_simple`dw_maestro within w_modificar_produccion
integer x = 37
integer y = 224
integer width = 2958
integer height = 1136
integer taborder = 30
string dataobject = "dtb_modificar_produccion"
boolean hscrollbar = false
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::clicked;selectrow(0, False)	
This.SelectRow(Row, NOT This.IsSelected(Row))
end event

type dw_1 from datawindow within w_modificar_produccion
integer x = 73
integer y = 44
integer width = 667
integer height = 152
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_parametros_modificacion_produccion"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_modificar_produccion
integer x = 1038
integer y = 44
integer width = 489
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar datos"
boolean default = true
end type

event clicked;Long li_modulo
date ld_fecha



dw_maestro.AcceptText()
ld_fecha = dw_1.GetItemDate(1,'fecha')
li_modulo = dw_1.GetItemNumber(1,'modulo')
dw_maestro.Retrieve(ld_fecha,li_modulo)


end event

type gb_1 from groupbox within w_modificar_produccion
integer x = 37
integer y = 8
integer width = 727
integer height = 212
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

