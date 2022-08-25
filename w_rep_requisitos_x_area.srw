HA$PBExportHeader$w_rep_requisitos_x_area.srw
forward
global type w_rep_requisitos_x_area from w_preview_de_impresion
end type
end forward

global type w_rep_requisitos_x_area from w_preview_de_impresion
integer width = 3456
string title = "Requisitos por Area"
event guardar_como pbm_custom08
end type
global w_rep_requisitos_x_area w_rep_requisitos_x_area

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF

end event

on w_rep_requisitos_x_area.create
call super::create
end on

on w_rep_requisitos_x_area.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;n_cts_param lou_param



ii_ancho = dw_reporte.width 
ii_alto  = dw_reporte.height
ii_posx  = dw_reporte.x   
ii_posy  = dw_reporte.y 

dw_reporte.settransobject(Sqlca)


Open(w_parametros_rep_requisitos)

lou_param = Message.PowerObjectParm


If IsValid(lou_param) Then
	dw_reporte.Retrieve(lou_param.il_vector[1],lou_param.il_vector[2],lou_param.il_vector[3],&
	           lou_param.id_vector[1],lou_param.il_vector[4])
End If


end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_rep_requisitos_x_area
integer x = 0
integer y = 8
integer width = 3397
string dataobject = "d_rep_requisitos_x_area"
end type

event dw_reporte::clicked;call super::clicked;

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

end event

