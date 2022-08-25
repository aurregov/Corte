HA$PBExportHeader$w_parametro_corte.srw
forward
global type w_parametro_corte from window
end type
type cb_2 from commandbutton within w_parametro_corte
end type
type cb_1 from commandbutton within w_parametro_corte
end type
type st_2 from statictext within w_parametro_corte
end type
type em_1 from editmask within w_parametro_corte
end type
type st_1 from statictext within w_parametro_corte
end type
type gb_1 from groupbox within w_parametro_corte
end type
end forward

global type w_parametro_corte from window
integer width = 919
integer height = 584
boolean titlebar = true
string title = "Buscar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
st_2 st_2
em_1 em_1
st_1 st_1
gb_1 gb_1
end type
global w_parametro_corte w_parametro_corte

on w_parametro_corte.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_2=create st_2
this.em_1=create em_1
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.st_2,&
this.em_1,&
this.st_1,&
this.gb_1}
end on

on w_parametro_corte.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.em_1)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

IF gl_orden_corte > 0 THEN
	em_1.text = string(gl_orden_corte)
END IF
end event

type cb_2 from commandbutton within w_parametro_corte
integer x = 91
integer y = 356
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
boolean default = true
end type

event clicked;Long li_estado, li_estado_aprobado, li_fabrica_prop
Long ll_ordencorte
n_cts_param luo_param
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_estado_aprobado = luo_constantes.of_consultar_numerico("ASIGNACION APROBADA")

IF li_estado_aprobado = -1 THEN
	Return
END IF

ll_ordencorte = Long(em_1.Text)

SELECT DISTINCT co_estado_asigna,
		co_fabrica_prop
INTO :li_estado,
	  :li_fabrica_prop	
FROM dt_pdnxmodulo
WHERE cs_asignacion = :ll_ordencorte;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar el estado de la asignaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText,StopSign!)
	Return
END IF

//validar que la orden si pertenezca a la fabrica seleccionada
//jcrm
//junio 5 de 2007
//IF gstr_info_usuario.co_planta_pro <> li_fabrica_prop AND li_fabrica_prop > 0 Then
//	MessageBox('Error','La orden de corte no corresponde a la planta: '+ gstr_info_usuario.fabrica,StopSign!)
//	Return
//END IF
//	


//IF li_estado >= li_estado_aprobado THEN

	luo_param.il_vector[1] = Long(em_1.Text)
	luo_param.is_vector[1] = 'S'
	
	If IsNull(luo_param.il_vector[1]) Then
		Messagebox("Informaci$$HEX1$$f300$$ENDHEX$$n","Debe indicar la orden que desea consultar.")
		Return
	End If
	
	CloseWithReturn(Parent,luo_param)
//ELSE
//	MessageBox("Estado inconsistente","El estado de la asignaci$$HEX1$$f300$$ENDHEX$$n no permite programar los trazos")
//END IF
end event

type cb_1 from commandbutton within w_parametro_corte
integer x = 462
integer y = 356
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

event clicked;n_cts_param luo_param

luo_param.is_vector[1] = 'N'

CloseWithReturn(Parent,luo_param)
//Close(Parent)
end event

type st_2 from statictext within w_parametro_corte
integer x = 32
integer y = 24
integer width = 841
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese el n$$HEX1$$fa00$$ENDHEX$$mero de la orden de corte"
boolean focusrectangle = false
end type

type em_1 from editmask within w_parametro_corte
integer x = 379
integer y = 168
integer width = 343
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

type st_1 from statictext within w_parametro_corte
integer x = 165
integer y = 180
integer width = 155
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Corte"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_parametro_corte
integer x = 32
integer y = 80
integer width = 841
integer height = 248
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

