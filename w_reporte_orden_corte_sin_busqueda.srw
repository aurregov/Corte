HA$PBExportHeader$w_reporte_orden_corte_sin_busqueda.srw
$PBExportComments$Ventana utilizada para imprimir la OC
forward
global type w_reporte_orden_corte_sin_busqueda from w_reporte_orden_corte
end type
end forward

global type w_reporte_orden_corte_sin_busqueda from w_reporte_orden_corte
boolean ib_permiso_imprimir = true
boolean ib_sin_busqueda = true
end type
global w_reporte_orden_corte_sin_busqueda w_reporte_orden_corte_sin_busqueda

on w_reporte_orden_corte_sin_busqueda.create
call super::create
end on

on w_reporte_orden_corte_sin_busqueda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_reporte_orden_corte`dw_reporte within w_reporte_orden_corte_sin_busqueda
end type

type st_1 from w_reporte_orden_corte`st_1 within w_reporte_orden_corte_sin_busqueda
end type

type pb_test from w_reporte_orden_corte`pb_test within w_reporte_orden_corte_sin_busqueda
end type

type dw_raya_sesgo from w_reporte_orden_corte`dw_raya_sesgo within w_reporte_orden_corte_sin_busqueda
end type

