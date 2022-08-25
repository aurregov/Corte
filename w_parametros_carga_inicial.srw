HA$PBExportHeader$w_parametros_carga_inicial.srw
forward
global type w_parametros_carga_inicial from window
end type
type dw_1 from datawindow within w_parametros_carga_inicial
end type
type cb_2 from commandbutton within w_parametros_carga_inicial
end type
type cb_1 from commandbutton within w_parametros_carga_inicial
end type
type gb_1 from groupbox within w_parametros_carga_inicial
end type
end forward

global type w_parametros_carga_inicial from window
integer width = 1458
integer height = 752
boolean titlebar = true
string title = "Buscar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_parametros_carga_inicial w_parametros_carga_inicial

type variables

DataWindowChild idwc_fabrica,idwc_planta,idwc_modulo
end variables

on w_parametros_carga_inicial.create
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.dw_1,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_parametros_carga_inicial.destroy
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;

Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If


dw_1.GetChild('co_fabrica',idwc_fabrica)
dw_1.GetChild('co_planta',idwc_planta)


idwc_fabrica.SetTrans(Sqlca)
idwc_planta.SetTransObject(Sqlca)


idwc_fabrica.Retrieve()
idwc_planta.Retrieve(91)
idwc_modulo.Retrieve(91)


dw_1.InsertRow(0)
end event

type dw_1 from datawindow within w_parametros_carga_inicial
event ue_enter pbm_dwnprocessenter
integer x = 114
integer y = 92
integer width = 1170
integer height = 288
integer taborder = 10
string title = "none"
string dataobject = "d_parametros_carga_inicial"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,Long(0,0))
Return 0
end event

event itemchanged;

If dwo.Name = "co_fabrica" Then
	If idwc_planta.Retrieve(Long(Data)) <=0 Then idwc_planta.InsertRow(0)
End If
end event

type cb_2 from commandbutton within w_parametros_carga_inicial
integer x = 727
integer y = 504
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_1 from commandbutton within w_parametros_carga_inicial
integer x = 357
integer y = 504
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
end type

event clicked;n_cts_param luo_param



dw_1.AcceptText()

luo_param.il_vector[1] = dw_1.GetItemNumber(1,'simulacion')
luo_param.il_vector[2] = dw_1.GetItemNumber(1,'co_fabrica')
luo_param.il_vector[3] = dw_1.GetItemNumber(1,'co_planta')




If IsNull(luo_param.il_vector[2]) Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar la planta que desea consultar.")
	Return
End If

If IsNull(luo_param.il_vector[3]) Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar el modulo que desea consultar.")
	Return
End If


CloseWithReturn(Parent,luo_param)
end event

type gb_1 from groupbox within w_parametros_carga_inicial
integer x = 32
integer y = 8
integer width = 1344
integer height = 452
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

