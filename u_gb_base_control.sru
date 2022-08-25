HA$PBExportHeader$u_gb_base_control.sru
$PBExportComments$GroupBox base
forward
global type u_gb_base_control from groupbox
end type
end forward

global type u_gb_base_control from groupbox
integer width = 494
integer height = 360
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type
global u_gb_base_control u_gb_base_control

forward prototypes
public subroutine of_color (readonly boolean ab_valor)
end prototypes

public subroutine of_color (readonly boolean ab_valor);
If ab_valor Then
	This.TextColor = RGB(0,0,255)
Else
	This.TextColor = RGB(0,0,0)
End If	
end subroutine

event constructor;
This.TabOrder = 0
end event

on u_gb_base_control.create
end on

on u_gb_base_control.destroy
end on

