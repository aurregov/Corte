HA$PBExportHeader$w_adhesivo_sesgos_recipiente_perfecto.srw
forward
global type w_adhesivo_sesgos_recipiente_perfecto from window
end type
type dw_1 from datawindow within w_adhesivo_sesgos_recipiente_perfecto
end type
type cb_cancelar from commandbutton within w_adhesivo_sesgos_recipiente_perfecto
end type
type cb_aceptar from commandbutton within w_adhesivo_sesgos_recipiente_perfecto
end type
type sle_ordencorte from singlelineedit within w_adhesivo_sesgos_recipiente_perfecto
end type
type gb_1 from groupbox within w_adhesivo_sesgos_recipiente_perfecto
end type
end forward

global type w_adhesivo_sesgos_recipiente_perfecto from window
integer width = 887
integer height = 576
boolean titlebar = true
string title = "Adhesivos Sesgos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_1 dw_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_ordencorte sle_ordencorte
gb_1 gb_1
end type
global w_adhesivo_sesgos_recipiente_perfecto w_adhesivo_sesgos_recipiente_perfecto

on w_adhesivo_sesgos_recipiente_perfecto.create
this.dw_1=create dw_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_ordencorte=create sle_ordencorte
this.gb_1=create gb_1
this.Control[]={this.dw_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.sle_ordencorte,&
this.gb_1}
end on

on w_adhesivo_sesgos_recipiente_perfecto.destroy
destroy(this.dw_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_ordencorte)
destroy(this.gb_1)
end on

event open;dw_1.SetTransObject(sqlca)
end event

type dw_1 from datawindow within w_adhesivo_sesgos_recipiente_perfecto
boolean visible = false
integer x = 713
integer y = 32
integer width = 123
integer height = 100
integer taborder = 40
string title = "none"
string dataobject = "dff_adhesivo_sesgo_perfecto"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_adhesivo_sesgos_recipiente_perfecto
integer x = 471
integer y = 280
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_adhesivo_sesgos_recipiente_perfecto
integer x = 55
integer y = 280
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Long ll_ordencorte, ll_agrupacion, ll_referencia
Long li_fabrica, li_linea, li_registros
String ls_error
String	ls_password,ls_password_ingresado
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte



//validar para que no puedan imprimir sin autorizacion
	MessageBox('Advertencia','Solo personal Autorizado puede reimprimir adhesivos.')
	ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD REIMPRIMIR ADHESIVO'))
	//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
	Open(w_password_trazos)
	lstr_parametros = message.PowerObjectParm
	
	If lstr_parametros.hay_parametros = true Then
		ls_password_ingresado = Trim(lstr_parametros.cadena[1])
					
		If ls_password_ingresado = ls_password Then
			//clave correcta, continua el proceso
		Else
			MessageBox('Error','Password, no valido.')
			Return 2
		End if
	Else
		Return 2
	End if




ll_ordencorte = Long(sle_ordencorte.Text)

If IsNull(ll_ordencorte) Then
	MessageBox('Advertencia','Debe Ingresar una orden de corte.',StopSign!)
	Return
End if

SELECT DISTINCT cs_agrupacion
  INTO :ll_agrupacion
  FROM dt_trazosxoc
 WHERE cs_orden_corte = :ll_ordencorte;
 
IF sqlca.sqlcode = -1 Then
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de identificar la agrupaci$$HEX1$$f300$$ENDHEX$$n, ERROR: ' +ls_error)
	Return
End if

IF sqlca.sqlcode = 100 Then
	MessageBox('Error','La orden de corte no es valida, por favor verifique sus datos.')
	Return
End if

SELECT DISTINCT co_fabrica,
		 co_linea,
		 co_referencia
  INTO :li_fabrica,
  		 :li_linea,
		 :ll_referencia
  FROM dt_kamban_corte
 WHERE cs_orden_corte = :ll_ordencorte;
 
IF sqlca.sqlcode = -1 Then
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de identificar los datos de la orden de corte, ERROR: ' +ls_error)
	Return
End if

li_registros = dw_1.Retrieve(li_fabrica, li_linea, ll_referencia, ll_agrupacion, ll_ordencorte )
If li_registros > 0 Then
	PrintSetup()
	dw_1.Print()
Else
	MessageBox('Advertencia','No se generaron adhesivos de sesgos. ', Exclamation!)
End if

end event

type sle_ordencorte from singlelineedit within w_adhesivo_sesgos_recipiente_perfecto
integer x = 229
integer y = 96
integer width = 425
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_adhesivo_sesgos_recipiente_perfecto
integer x = 197
integer y = 40
integer width = 494
integer height = 184
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte "
end type

