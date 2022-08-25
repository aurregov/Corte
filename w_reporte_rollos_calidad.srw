HA$PBExportHeader$w_reporte_rollos_calidad.srw
forward
global type w_reporte_rollos_calidad from w_preview_de_impresion
end type
type cb_1 from commandbutton within w_reporte_rollos_calidad
end type
end forward

global type w_reporte_rollos_calidad from w_preview_de_impresion
integer width = 3835
integer height = 2144
event ue_buscar ( )
cb_1 cb_1
end type
global w_reporte_rollos_calidad w_reporte_rollos_calidad

type variables
s_base_parametros  istr_param
cst_adm_conexion icst_lectura
end variables

event ue_buscar();dw_reporte.Retrieve()
end event

event open;This.x = 1
This.y = 1
icst_lectura = create  cst_adm_conexion

dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

TriggerEvent('ue_buscar')
end event

on w_reporte_rollos_calidad.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_reporte_rollos_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event closequery;call super::closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_rollos_calidad
integer width = 3735
string dataobject = "dtb_reporte_rollos_calidad"
end type

type cb_1 from commandbutton within w_reporte_rollos_calidad
integer x = 27
integer y = 12
integer width = 434
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualizar Estado"
end type

event clicked;//metodo para modificar el estado de los rollos pendientes de aprobacion de tono por parte de calidad
//jcrm
//abril 4 de 2008
Long li_fila
Long ll_solicitud, ll_rollo
String ls_estado
n_cts_liberacion_x_proyeccion luo_proyeccion

li_fila = dw_reporte.GetRow()

IF li_fila > 0 THEN
	ll_solicitud = dw_reporte.GetItemNumber(li_fila,'cs_solicitud')
	ls_estado = dw_reporte.GetItemString(li_fila,'sw_estado')
	ll_rollo = dw_reporte.GetItemNumber(li_fila,'cs_rollo')
	
	IF ls_estado = 'P' THEN
		ls_estado = 'E'
	ELSEIF ls_estado = 'E' THEN
		ls_estado = 'P'
	END IF
	
	IF luo_proyeccion.of_estadoRollosCalidad(ls_estado,ll_solicitud,ll_rollo) = -1 THEN
		Return
	END IF
	
ELSE
	MessageBox('Advertencia','Debe seleccionar una solicitud.',Exclamation!)
	Return
END IF

end event

