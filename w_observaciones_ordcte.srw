HA$PBExportHeader$w_observaciones_ordcte.srw
forward
global type w_observaciones_ordcte from w_base_simple
end type
type st_1 from statictext within w_observaciones_ordcte
end type
end forward

global type w_observaciones_ordcte from w_base_simple
integer width = 1728
integer height = 492
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
st_1 st_1
end type
global w_observaciones_ordcte w_observaciones_ordcte

on w_observaciones_ordcte.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_observaciones_ordcte.destroy
call super::destroy
destroy(this.st_1)
end on

event open;Long	ll_ordencorte
s_base_parametros lstr_parametros
This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)


lstr_parametros = Message.PowerObjectParm
ll_ordencorte = lstr_parametros.entero[1]

dw_maestro.Retrieve(ll_ordencorte)
end event

type dw_maestro from w_base_simple`dw_maestro within w_observaciones_ordcte
integer y = 56
integer width = 1573
integer height = 256
string dataobject = "dtb_observaciones_oc"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::itemchanged;//no
end event

type st_1 from statictext within w_observaciones_ordcte
integer x = 101
integer y = 340
integer width = 1385
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese la nota del porque de la variaci$$HEX1$$f300$$ENDHEX$$n en la Orden de Corte"
boolean focusrectangle = false
end type

