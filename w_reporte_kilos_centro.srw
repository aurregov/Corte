HA$PBExportHeader$w_reporte_kilos_centro.srw
forward
global type w_reporte_kilos_centro from w_preview_de_impresion
end type
end forward

global type w_reporte_kilos_centro from w_preview_de_impresion
integer width = 2994
integer height = 1964
end type
global w_reporte_kilos_centro w_reporte_kilos_centro

type variables
cst_adm_conexion icst_lectura

s_base_parametros  istr_param
end variables

event open;n_cts_reportes_varios luo_reportes

dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

//se invoca el procedimineto para cargar los datos de la temporal

luo_reportes.of_cargar_tela_bodega(15)


//se carga el reporte en pantalla
dw_reporte.Retrieve(gstr_info_usuario.codigo_usuario)


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_reporte_kilos_centro.create
call super::create
end on

on w_reporte_kilos_centro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event closequery;call super::closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_kilos_centro
string dataobject = "dtb_reporte_kilos_centro"
end type

