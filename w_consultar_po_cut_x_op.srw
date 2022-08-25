HA$PBExportHeader$w_consultar_po_cut_x_op.srw
forward
global type w_consultar_po_cut_x_op from w_preview_de_impresion
end type
end forward

global type w_consultar_po_cut_x_op from w_preview_de_impresion
end type
global w_consultar_po_cut_x_op w_consultar_po_cut_x_op

event open;s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm
dw_reporte.settransobject(sqlca)
dw_reporte.Retrieve(lstr_parametros.entero[1])

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_consultar_po_cut_x_op.create
call super::create
end on

on w_consultar_po_cut_x_op.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_consultar_po_cut_x_op
integer y = 24
integer height = 1668
string dataobject = "dtb_referencias_po_ordenpdn"
end type

