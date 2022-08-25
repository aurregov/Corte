HA$PBExportHeader$w_reporte_material_cortado.srw
forward
global type w_reporte_material_cortado from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_material_cortado
end type
type cb_recuperar from commandbutton within w_reporte_material_cortado
end type
end forward

global type w_reporte_material_cortado from w_preview_de_impresion
integer width = 2976
integer height = 1972
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_reporte_material_cortado w_reporte_material_cortado

on w_reporte_material_cortado.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_reporte_material_cortado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

event open;dw_criterio.SetTransObject(sqlca)
dw_reporte.SetTransObject(sqlca)

dw_criterio.InsertRow(0)


end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_material_cortado
integer y = 136
integer height = 1544
string dataobject = "dtb_rep_bodega_material_cortado"
end type

type dw_criterio from datawindow within w_reporte_material_cortado
integer x = 32
integer y = 28
integer width = 1440
integer height = 84
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_rep_material_cortado_parametro"
boolean border = false
boolean livescroll = true
end type

type cb_recuperar from commandbutton within w_reporte_material_cortado
integer x = 1627
integer y = 28
integer width = 343
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
boolean default = true
end type

event clicked;Date ld_fechaini,ld_fechafin

dw_criterio.AcceptText()

ld_fechaini = dw_criterio.GetItemDate(1,'fechaini')
ld_fechafin = dw_criterio.GetItemDate(1,'fechafin')

If isnull(ld_fechaini) or isnull(ld_fechafin) Then
	MessageBox('Advertencia','No sean definido las fechas de inicio o fin')
	Return
End if

dw_reporte.Retrieve(ld_fechaini,ld_fechafin)
end event

