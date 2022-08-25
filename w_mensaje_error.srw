HA$PBExportHeader$w_mensaje_error.srw
forward
global type w_mensaje_error from w_mensaje
end type
end forward

global type w_mensaje_error from w_mensaje
integer width = 2414
integer height = 680
string icon = "StopSign!"
end type
global w_mensaje_error w_mensaje_error

type variables

end variables

on w_mensaje_error.create
call super::create
end on

on w_mensaje_error.destroy
call super::destroy
end on

event closequery;call super::closequery;
If Not ib_tecla Then Return 1
end event

event open;call super::open;
If mle_mensaje.LineCount() > 8 Then 
	mle_mensaje.VscrollBar = True
Else
	mle_mensaje.VscrollBar = False
End If
end event

event ue_presionar_tecla;call super::ue_presionar_tecla;If KeyDown( ii_tecla ) Then ib_tecla = True
end event

type plb_icono from w_mensaje`plb_icono within w_mensaje_error
end type

type cb_cancelar from w_mensaje`cb_cancelar within w_mensaje_error
integer x = 1527
integer y = 476
end type

type cb_aceptar from w_mensaje`cb_aceptar within w_mensaje_error
integer x = 1033
integer y = 488
end type

type mle_mensaje from w_mensaje`mle_mensaje within w_mensaje_error
integer x = 165
integer y = 36
integer width = 2240
integer height = 424
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

type cb_no from w_mensaje`cb_no within w_mensaje_error
integer x = 1143
integer y = 476
end type

type cb_si from w_mensaje`cb_si within w_mensaje_error
integer x = 759
integer y = 476
end type

