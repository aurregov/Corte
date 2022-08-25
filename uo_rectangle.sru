HA$PBExportHeader$uo_rectangle.sru
forward
global type uo_rectangle from userobject
end type
type r_1 from rectangle within uo_rectangle
end type
end forward

global type uo_rectangle from userobject
integer width = 114
integer height = 100
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
r_1 r_1
end type
global uo_rectangle uo_rectangle

forward prototypes
public function long of_fillcolor (long ai_color)
end prototypes

public function long of_fillcolor (long ai_color);r_1.FillColor = ai_color
Return 1
end function

on uo_rectangle.create
this.r_1=create r_1
this.Control[]={this.r_1}
end on

on uo_rectangle.destroy
destroy(this.r_1)
end on

type r_1 from rectangle within uo_rectangle
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 1073741824
integer width = 110
integer height = 48
end type

