HA$PBExportHeader$w_parametros_corte.srw
forward
global type w_parametros_corte from window
end type
type st_1 from statictext within w_parametros_corte
end type
type em_1 from editmask within w_parametros_corte
end type
type cb_2 from commandbutton within w_parametros_corte
end type
type cb_1 from commandbutton within w_parametros_corte
end type
type gb_1 from groupbox within w_parametros_corte
end type
end forward

global type w_parametros_corte from window
integer width = 1161
integer height = 640
boolean titlebar = true
string title = "Par$$HEX1$$e100$$ENDHEX$$metros"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_1 st_1
em_1 em_1
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_parametros_corte w_parametros_corte

type variables

Long il_fabrica,&
	  il_planta,&
	  il_modulo,&
	  il_prioridad
	  
	  
Date id_fechainicio	  


end variables

event open;n_cts_param luo_param
DateTime ldt_fechainicio
Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If

il_fabrica   = luo_param.il_vector[2]
il_planta    = luo_param.il_vector[3]
il_modulo    = luo_param.il_vector[4]
il_prioridad = luo_param.il_vector[5]

If il_prioridad > 1 Then
	select max(Date(dt_programa_diario.fe_inicio)) 
	  into :id_fechainicio
	from dt_pdnxmodulo,   
		  dt_programa_diario  
  where ( dt_programa_diario.simulacion = dt_pdnxmodulo.simulacion ) and  
		  ( dt_programa_diario.co_fabrica = dt_pdnxmodulo.co_fabrica ) and  
		  ( dt_programa_diario.co_planta = dt_pdnxmodulo.co_planta ) and  
		  ( dt_programa_diario.co_modulo = dt_pdnxmodulo.co_modulo ) and  
		  ( dt_programa_diario.co_fabrica_exp = dt_pdnxmodulo.co_fabrica_exp ) and  
		  ( dt_programa_diario.pedido = dt_pdnxmodulo.pedido ) and  
		  ( dt_programa_diario.cs_liberacion = dt_pdnxmodulo.cs_liberacion ) and  
		  ( dt_programa_diario.po = dt_pdnxmodulo.po ) and  
		  ( dt_programa_diario.co_fabrica_pt = dt_pdnxmodulo.co_fabrica_pt ) and  
		  ( dt_programa_diario.co_linea = dt_pdnxmodulo.co_linea ) and  
		  ( dt_programa_diario.co_referencia = dt_pdnxmodulo.co_referencia ) and  
		  ( dt_programa_diario.co_color_pt = dt_pdnxmodulo.co_color_pt ) and  
		  ( dt_programa_diario.tono = dt_pdnxmodulo.tono ) and  
		  ( dt_programa_diario.cs_estilocolortono = dt_pdnxmodulo.cs_estilocolortono ) and  
		  ( dt_programa_diario.cs_particion = dt_pdnxmodulo.cs_particion ) and  
		  ( dt_pdnxmodulo.simulacion = 1 ) AND  
		  ( dt_pdnxmodulo.co_fabrica = :il_fabrica ) AND  
		  ( dt_pdnxmodulo.co_planta = :il_planta ) AND  
		  ( dt_pdnxmodulo.co_modulo = :il_modulo ) AND  
		  ( dt_pdnxmodulo.cs_prioridad = :il_prioridad -1 ) ;
		  
		  
	If Sqlca.SqlCode = -1 Then
		MessageBox("Advertencia!","Hubo un error al buscar la fecha de inicio.~n~n~nNota: " + Sqlca.SqlErrText )
		Close(This)
		Return
	End If
	
	If Date(id_fechainicio) = Date("01/01/1900") Or IsNUll(id_fechainicio) Then
		id_fechainicio = Date(f_fecha_servidor())
	End IF
Else
	id_fechainicio = Date(f_fecha_servidor())
End If

em_1.Text = String(id_fechainicio)

end event

on w_parametros_corte.create
this.st_1=create st_1
this.em_1=create em_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.em_1,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_parametros_corte.destroy
destroy(this.st_1)
destroy(this.em_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type st_1 from statictext within w_parametros_corte
integer x = 110
integer y = 152
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Inicio"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_1 from editmask within w_parametros_corte
integer x = 480
integer y = 136
integer width = 389
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean spin = true
end type

event modified;
If Date(This.Text) < id_fechainicio And il_prioridad > 1 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","No puede ingresar una fecha menor a " + String(id_fechainicio,"dd/mm/yyyy") + ".")
	This.Text = String(id_fechainicio)
End If
end event

type cb_2 from commandbutton within w_parametros_corte
integer x = 558
integer y = 372
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
end type

event clicked;
Close(Parent)
end event

type cb_1 from commandbutton within w_parametros_corte
integer x = 183
integer y = 372
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

event clicked;n_cts_corte luo_corte
Date ld_fecha


SetPointer(HourGlass!)

luo_corte = Create n_cts_corte

ld_fecha = Date(em_1.Text)

If luo_corte.Of_MetodoMinutos(1,il_fabrica,il_planta,il_modulo,il_prioridad,ld_fecha) = -1 Then Return

Destroy n_cts_corte

Close(Parent)
end event

type gb_1 from groupbox within w_parametros_corte
integer x = 27
integer y = 8
integer width = 1061
integer height = 336
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Par$$HEX1$$e100$$ENDHEX$$metros"
end type

