HA$PBExportHeader$w_rep_mesa_bordado_preparacion.srw
forward
global type w_rep_mesa_bordado_preparacion from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_rep_mesa_bordado_preparacion
end type
type cb_recuperar from commandbutton within w_rep_mesa_bordado_preparacion
end type
end forward

global type w_rep_mesa_bordado_preparacion from w_preview_de_impresion
integer width = 3429
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_rep_mesa_bordado_preparacion w_rep_mesa_bordado_preparacion

event open;dw_reporte.settransobject(sqlca)
dw_criterio.settransobject(sqlca)

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

dw_criterio.SetItem(1,'fe_inicial',Today())
dw_criterio.SetItem(1,'fe_final',Today())
end event

on w_rep_mesa_bordado_preparacion.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_rep_mesa_bordado_preparacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_rep_mesa_bordado_preparacion
integer y = 188
integer width = 3346
integer height = 1552
string dataobject = "dtb_rep_mesa_bordado_preparacion"
end type

type dw_criterio from datawindow within w_rep_mesa_bordado_preparacion
integer x = 14
integer y = 24
integer width = 1582
integer height = 68
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_criterio_rep_mesa_cortado_bordado"
boolean border = false
boolean livescroll = true
end type

type cb_recuperar from commandbutton within w_rep_mesa_bordado_preparacion
integer x = 1696
integer y = 16
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;DateTime ldt_fe_inicial, ldt_fe_final

dw_criterio.AcceptText()

ldt_fe_inicial = dw_criterio.GetItemDateTime(1,'fe_inicial')
ldt_fe_final = dw_criterio.GetItemDateTime(1,'fe_final')

dw_reporte.Retrieve(ldt_fe_inicial,ldt_fe_final)


end event

