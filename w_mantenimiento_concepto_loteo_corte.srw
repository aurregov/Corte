HA$PBExportHeader$w_mantenimiento_concepto_loteo_corte.srw
forward
global type w_mantenimiento_concepto_loteo_corte from w_base_tabular
end type
type gb_1 from groupbox within w_mantenimiento_concepto_loteo_corte
end type
end forward

global type w_mantenimiento_concepto_loteo_corte from w_base_tabular
integer width = 1431
integer height = 1476
string title = "Conceptos Loteo Corte"
gb_1 gb_1
end type
global w_mantenimiento_concepto_loteo_corte w_mantenimiento_concepto_loteo_corte

on w_mantenimiento_concepto_loteo_corte.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_mantenimiento_concepto_loteo_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_concepto_loteo_corte
integer x = 87
integer y = 80
integer width = 1262
integer height = 1120
string dataobject = "dgr_conceptos_loteo_corte"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_concepto_loteo_corte
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_concepto_loteo_corte
boolean visible = false
end type

type gb_1 from groupbox within w_mantenimiento_concepto_loteo_corte
integer x = 41
integer y = 28
integer width = 1335
integer height = 1204
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
end type

