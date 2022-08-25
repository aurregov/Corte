HA$PBExportHeader$w_conceptos_impresion.srw
forward
global type w_conceptos_impresion from w_base_tabular
end type
end forward

global type w_conceptos_impresion from w_base_tabular
integer width = 1253
integer height = 1244
string title = "Conceptos Reimpresi$$HEX1$$f300$$ENDHEX$$n"
end type
global w_conceptos_impresion w_conceptos_impresion

on w_conceptos_impresion.create
call super::create
end on

on w_conceptos_impresion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;//
end event

event open;call super::open;dw_maestro.Retrieve()
end event

type dw_maestro from w_base_tabular`dw_maestro within w_conceptos_impresion
integer x = 50
integer y = 24
integer width = 1115
integer height = 988
string dataobject = "dgr_conceptos_impresion"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_conceptos_impresion
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_conceptos_impresion
boolean visible = false
end type

