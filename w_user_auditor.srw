HA$PBExportHeader$w_user_auditor.srw
forward
global type w_user_auditor from w_base_tabular
end type
type gb_1 from groupbox within w_user_auditor
end type
end forward

global type w_user_auditor from w_base_tabular
integer width = 2080
integer height = 1432
string title = "Auditores de Calidad "
gb_1 gb_1
end type
global w_user_auditor w_user_auditor

on w_user_auditor.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_user_auditor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event open;long ll_codigo
string ls_nombre


This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
dw_maestro.RETRIEVE()
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF


end event

type dw_maestro from w_base_tabular`dw_maestro within w_user_auditor
integer x = 46
integer y = 64
integer width = 1938
integer height = 1120
string dataobject = "dtb_user_auditor"
end type

event dw_maestro::itemchanged;call super::itemchanged;This.SetItem(Row, "fe_creacion", f_fecha_servidor())
end event

type sle_argumento from w_base_tabular`sle_argumento within w_user_auditor
boolean visible = false
integer x = 91
integer width = 55
integer height = 48
end type

type st_1 from w_base_tabular`st_1 within w_user_auditor
boolean visible = false
integer x = 9
integer y = 0
integer width = 64
integer height = 64
end type

type gb_1 from groupbox within w_user_auditor
integer x = 18
integer y = 12
integer width = 2002
integer height = 1212
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
end type

