HA$PBExportHeader$w_nivel1_centro6.srw
forward
global type w_nivel1_centro6 from w_base_tabular
end type
end forward

global type w_nivel1_centro6 from w_base_tabular
integer width = 2034
integer height = 1952
end type
global w_nivel1_centro6 w_nivel1_centro6

on w_nivel1_centro6.create
call super::create
end on

on w_nivel1_centro6.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

dw_maestro.Retrieve(6)
end event

type dw_maestro from w_base_tabular`dw_maestro within w_nivel1_centro6
integer width = 1879
integer height = 1392
string dataobject = "dtb_total_kg_tela_cruda"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_nivel1_centro6
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_nivel1_centro6
boolean visible = false
end type

