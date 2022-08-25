HA$PBExportHeader$w_buscar.srw
forward
global type w_buscar from w_base_buscar_maestros
end type
end forward

global type w_buscar from w_base_buscar_maestros
string title = "Descripciones"
end type
global w_buscar w_buscar

on w_buscar.create
call super::create
end on

on w_buscar.destroy
call super::destroy
end on

type cb_cancelar from w_base_buscar_maestros`cb_cancelar within w_buscar
end type

type cb_aceptar from w_base_buscar_maestros`cb_aceptar within w_buscar
end type

type dw_lista from w_base_buscar_maestros`dw_lista within w_buscar
end type

event dw_lista::doubleclicked;call super::doubleclicked;If Row > 0 Then
	cb_aceptar.event clicked( )
End If
end event

type gb_1 from w_base_buscar_maestros`gb_1 within w_buscar
end type

