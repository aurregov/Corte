HA$PBExportHeader$w_parametros_orden_corte.srw
forward
global type w_parametros_orden_corte from w_base_tabular
end type
type gb_1 from groupbox within w_parametros_orden_corte
end type
end forward

global type w_parametros_orden_corte from w_base_tabular
integer width = 2757
integer height = 1716
string title = "Parametros Orden Corte"
gb_1 gb_1
end type
global w_parametros_orden_corte w_parametros_orden_corte

on w_parametros_orden_corte.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_parametros_orden_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event ue_buscar;//
end event

event open;call super::open;dw_maestro.Retrieve(gstr_info_usuario.co_planta_pro)
end event

type dw_maestro from w_base_tabular`dw_maestro within w_parametros_orden_corte
integer x = 59
integer y = 60
integer width = 2597
integer height = 1364
string dataobject = "dgr_parametros_orden_corte"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_parametros_orden_corte
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_parametros_orden_corte
boolean visible = false
end type

type gb_1 from groupbox within w_parametros_orden_corte
integer x = 41
integer width = 2642
integer height = 1484
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

