HA$PBExportHeader$w_buscar_pdn.srw
forward
global type w_buscar_pdn from window
end type
type cb_2 from commandbutton within w_buscar_pdn
end type
type cb_1 from commandbutton within w_buscar_pdn
end type
type dw_1 from datawindow within w_buscar_pdn
end type
type gb_1 from groupbox within w_buscar_pdn
end type
end forward

global type w_buscar_pdn from window
integer width = 1632
integer height = 1088
boolean titlebar = true
string title = "Pdn"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_buscar_pdn w_buscar_pdn

on w_buscar_pdn.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1,&
this.gb_1}
end on

on w_buscar_pdn.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

dw_1.SetTransObject(sqlca)

lstr_parametros=message.powerObjectparm

dw_1.retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2],lstr_parametros.entero[3],lstr_parametros.entero[4],lstr_parametros.entero[5])
end event

type cb_2 from commandbutton within w_buscar_pdn
integer x = 846
integer y = 796
integer width = 293
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;s_base_parametros lst_parametros

lst_parametros.cadena[1] = 'NO'

CloseWithReturn(Parent, lst_parametros)
end event

type cb_1 from commandbutton within w_buscar_pdn
integer x = 357
integer y = 796
integer width = 293
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_filas
s_base_parametros lst_parametros

ll_filas = dw_1.GetRow()

IF ll_filas >= 1 THEN

	lst_parametros.entero[1] = dw_1.GetItemNumber(ll_filas,'cs_pdn')
	lst_parametros.cadena[1] = 'SI'
	CloseWithReturn(Parent, lst_parametros)

END IF
end event

type dw_1 from datawindow within w_buscar_pdn
integer x = 146
integer y = 64
integer width = 1394
integer height = 604
integer taborder = 10
string title = "none"
string dataobject = "dtb_buscar_pdn"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;If Row <= 0 Then Return

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If
end event

event doubleclicked;If Row <= 0 Then Return
cb_1.TriggerEvent(Clicked!)
end event

type gb_1 from groupbox within w_buscar_pdn
integer x = 119
integer y = 8
integer width = 1454
integer height = 688
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

