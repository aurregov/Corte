HA$PBExportHeader$w_preview_reporte_asignacion_grupos.srw
forward
global type w_preview_reporte_asignacion_grupos from w_preview_de_impresion
end type
end forward

global type w_preview_reporte_asignacion_grupos from w_preview_de_impresion
integer width = 3456
event guardar_como pbm_custom08
end type
global w_preview_reporte_asignacion_grupos w_preview_reporte_asignacion_grupos

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF

end event

on w_preview_reporte_asignacion_grupos.create
call super::create
end on

on w_preview_reporte_asignacion_grupos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;s_base_parametros lstr_parametros

String ls_nombredw, ls_wparametros, ls_grupos[4]

/* Declara Variables de Instancia */
dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

/* Llama la pantalla para pedir parametros de ejecucion del reporte */
//Open(w_parametros_reporte_de_asignacion)
Open(w_parametros_reporte_asignacion_grupos)
lstr_parametros = Message.PowerObjectParm

/* Verifica que hayan parametros */
IF lstr_parametros.hay_parametros = TRUE THEN
	ls_grupos[1] = lstr_parametros.cadena[1]
	ls_grupos[2] = lstr_parametros.cadena[2]
	ls_grupos[3] = lstr_parametros.cadena[3]
	ls_grupos[4] = lstr_parametros.cadena[4]
	
	dw_reporte.Retrieve(ls_grupos[])
ELSE
	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
	return -1
END IF

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_reporte_asignacion_grupos
integer x = 0
integer width = 3397
string dataobject = "dtb_r_asignacion_grupos"
end type

