HA$PBExportHeader$w_tallas_liberacion_respaldo.srw
forward
global type w_tallas_liberacion_respaldo from window
end type
type dw_reporte from uo_dtwndow within w_tallas_liberacion_respaldo
end type
end forward

global type w_tallas_liberacion_respaldo from window
integer width = 1435
integer height = 1188
boolean titlebar = true
string title = "Tallas Liberaci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_reporte dw_reporte
end type
global w_tallas_liberacion_respaldo w_tallas_liberacion_respaldo

on w_tallas_liberacion_respaldo.create
this.dw_reporte=create dw_reporte
this.Control[]={this.dw_reporte}
end on

on w_tallas_liberacion_respaldo.destroy
destroy(this.dw_reporte)
end on

event open;n_cts_param luo_param

luo_param = Message.PowerObjectParm
IF IsValid(luo_param) THEN
	dw_reporte.SetTransObject(SQLCA)
	dw_reporte.Retrieve(luo_param.il_vector[1], luo_param.il_vector[2])
END IF
end event

type dw_reporte from uo_dtwndow within w_tallas_liberacion_respaldo
integer x = 37
integer y = 32
integer width = 1335
integer height = 996
integer taborder = 10
string dataobject = "dtb_tallas_liberacion"
end type

