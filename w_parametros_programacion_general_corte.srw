HA$PBExportHeader$w_parametros_programacion_general_corte.srw
forward
global type w_parametros_programacion_general_corte from window
end type
type cb_2 from commandbutton within w_parametros_programacion_general_corte
end type
type cb_1 from commandbutton within w_parametros_programacion_general_corte
end type
type dw_1 from datawindow within w_parametros_programacion_general_corte
end type
type gb_1 from groupbox within w_parametros_programacion_general_corte
end type
end forward

global type w_parametros_programacion_general_corte from window
integer width = 1458
integer height = 1512
boolean titlebar = true
string title = "Buscar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_parametros_programacion_general_corte w_parametros_programacion_general_corte

type variables

DataWindowChild idwc_fabrica,idwc_planta,idwc_modulo
end variables

on w_parametros_programacion_general_corte.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1,&
this.gb_1}
end on

on w_parametros_programacion_general_corte.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
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
dw_1.GetChild('co_modulo',idwc_modulo)

idwc_fabrica.SetTrans(Sqlca)
idwc_planta.SetTransObject(Sqlca)
idwc_modulo.SetTransObject(Sqlca)

idwc_fabrica.Retrieve()
idwc_planta.Retrieve(91)
idwc_modulo.Retrieve(91)


dw_1.InsertRow(0)
end event

type cb_2 from commandbutton within w_parametros_programacion_general_corte
integer x = 727
integer y = 1280
integer width = 343
integer height = 92
integer taborder = 20
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

type cb_1 from commandbutton within w_parametros_programacion_general_corte
integer x = 357
integer y = 1280
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
end type

event clicked;n_cts_param luo_param
Int li_sw


dw_1.AcceptText()

luo_param.il_vector[1] = dw_1.GetItemNumber(1,'co_fabrica')
luo_param.il_vector[2] = dw_1.GetItemNumber(1,'co_planta')
luo_param.il_vector[3] = dw_1.GetItemNumber(1,'co_modulo')

li_sw = dw_1.GetItemNumber(1,'swfecha')

If li_sw = 0 Then
	luo_param.id_vector[1] = dw_1.GetItemDate(1,'fecha')
Else
	luo_param.id_vector[1] = Date('1900-01-01')
End If

//opcionales

luo_param.il_vector[4] = dw_1.GetItemNumber(1,'prioridad')
luo_param.il_vector[5] = dw_1.GetItemNumber(1,'cliente')
luo_param.il_vector[6] = dw_1.GetItemNumber(1,'sucursal')
luo_param.il_vector[7] = dw_1.GetItemNumber(1,'linea')
luo_param.il_vector[8] = dw_1.GetItemNumber(1,'style')
luo_param.il_vector[9] = dw_1.GetItemNumber(1,'color')
luo_param.il_vector[10] = dw_1.GetItemNumber(1,'estilo')
luo_param.il_vector[11] = dw_1.GetItemNumber(1,'composicion')

luo_param.is_vector[1] = dw_1.GetItemString(1,'grupo')
luo_param.is_vector[2] = dw_1.GetItemString(1,'po')

If IsNull(luo_param.il_vector[2]) Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar la planta que desea consultar.")
	Return
End If

If IsNull(luo_param.il_vector[3]) Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar el modulo que desea consultar.")
	Return
End If

If IsNull(luo_param.il_vector[4]) Then  luo_param.il_vector[4] =  0 //Prioridad
If IsNull(luo_param.il_vector[5]) Then  luo_param.il_vector[5] =  0 //Cliente
If IsNull(luo_param.il_vector[6]) Then  luo_param.il_vector[6] =  0 //Sucursal
If IsNull(luo_param.il_vector[7]) Then  luo_param.il_vector[7] =  0 //Linea
If IsNull(luo_param.il_vector[8]) Then  luo_param.il_vector[8] =  0 //Style
If IsNull(luo_param.il_vector[9]) Then  luo_param.il_vector[9] =  0 //Color
If IsNull(luo_param.il_vector[10]) Then  luo_param.il_vector[10] =  0 //Estilo
If IsNull(luo_param.il_vector[11]) Then  luo_param.il_vector[11] =  0 //Composicion

If IsNull(luo_param.is_vector[1]) Then  luo_param.is_vector[1] =  '' //Estilo
If IsNull(luo_param.is_vector[2]) Then  luo_param.is_vector[2] =  '' //Composicion


CloseWithReturn(Parent,luo_param)
end event

type dw_1 from datawindow within w_parametros_programacion_general_corte
event ue_enter pbm_dwnprocessenter
integer x = 114
integer y = 92
integer width = 1248
integer height = 1116
integer taborder = 10
string title = "none"
string dataobject = "d_parametros_programacion_general_corte"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,Long(0,0))
Return 0
end event

event itemchanged;

If dwo.Name = "co_fabrica" Then
	If idwc_planta.Retrieve(Long(Data)) <=0 Then idwc_planta.InsertRow(0)
	If idwc_modulo.Retrieve(Long(Data)) <=0 Then idwc_modulo.InsertRow(0)
End If
end event

type gb_1 from groupbox within w_parametros_programacion_general_corte
integer x = 32
integer y = 8
integer width = 1344
integer height = 1240
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

