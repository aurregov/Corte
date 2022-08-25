HA$PBExportHeader$w_buscar_ordencorte_sesgo.srw
forward
global type w_buscar_ordencorte_sesgo from window
end type
type cb_imprimir from commandbutton within w_buscar_ordencorte_sesgo
end type
type dw_1 from datawindow within w_buscar_ordencorte_sesgo
end type
type cb_cancelar from commandbutton within w_buscar_ordencorte_sesgo
end type
type cb_aceptar from commandbutton within w_buscar_ordencorte_sesgo
end type
type sle_ordencorte from singlelineedit within w_buscar_ordencorte_sesgo
end type
type gb_1 from groupbox within w_buscar_ordencorte_sesgo
end type
type gb_2 from groupbox within w_buscar_ordencorte_sesgo
end type
end forward

global type w_buscar_ordencorte_sesgo from window
integer width = 2176
integer height = 2028
boolean titlebar = true
string title = "Orden Corte"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_imprimir cb_imprimir
dw_1 dw_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_ordencorte sle_ordencorte
gb_1 gb_1
gb_2 gb_2
end type
global w_buscar_ordencorte_sesgo w_buscar_ordencorte_sesgo

on w_buscar_ordencorte_sesgo.create
this.cb_imprimir=create cb_imprimir
this.dw_1=create dw_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_ordencorte=create sle_ordencorte
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_imprimir,&
this.dw_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.sle_ordencorte,&
this.gb_1,&
this.gb_2}
end on

on w_buscar_ordencorte_sesgo.destroy
destroy(this.cb_imprimir)
destroy(this.dw_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_ordencorte)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;dw_1.SetTransObject(sqlca)
end event

type cb_imprimir from commandbutton within w_buscar_ordencorte_sesgo
integer x = 1166
integer y = 84
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir"
end type

event clicked;
PrintSetup()
dw_1.Print()
end event

type dw_1 from datawindow within w_buscar_ordencorte_sesgo
integer x = 91
integer y = 292
integer width = 2011
integer height = 1432
integer taborder = 20
string title = "none"
string dataobject = "dff_adhesivo_sesgo_perfecto"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_buscar_ordencorte_sesgo
integer x = 1591
integer y = 84
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
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_buscar_ordencorte_sesgo
integer x = 741
integer y = 84
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
end type

event clicked;Long ll_ordencorte, ll_agrupacion, ll_referencia
Long li_fabrica, li_linea
String ls_error

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
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :ll_ordencorte;
 
IF sqlca.sqlcode = -1 Then
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de identificar los datos de la orden de corte, ERROR: ' +ls_error)
	Return
End if


dw_1.Retrieve(li_fabrica, li_linea, ll_referencia, ll_agrupacion, ll_ordencorte )


end event

type sle_ordencorte from singlelineedit within w_buscar_ordencorte_sesgo
integer x = 123
integer y = 108
integer width = 443
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

type gb_1 from groupbox within w_buscar_ordencorte_sesgo
integer x = 64
integer y = 36
integer width = 581
integer height = 212
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

type gb_2 from groupbox within w_buscar_ordencorte_sesgo
integer x = 64
integer y = 236
integer width = 2066
integer height = 1528
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

