HA$PBExportHeader$w_parametros_devolver_trazos.srw
forward
global type w_parametros_devolver_trazos from window
end type
type cb_cancelar from commandbutton within w_parametros_devolver_trazos
end type
type cb_aceptar from commandbutton within w_parametros_devolver_trazos
end type
type dw_criterio from datawindow within w_parametros_devolver_trazos
end type
type gb_1 from groupbox within w_parametros_devolver_trazos
end type
end forward

global type w_parametros_devolver_trazos from window
integer width = 919
integer height = 696
boolean titlebar = true
string title = "Devoluci$$HEX1$$f300$$ENDHEX$$n Trazos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_criterio dw_criterio
gb_1 gb_1
end type
global w_parametros_devolver_trazos w_parametros_devolver_trazos

on w_parametros_devolver_trazos.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_criterio,&
this.gb_1}
end on

on w_parametros_devolver_trazos.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_criterio)
destroy(this.gb_1)
end on

event open;This.Center = True

dw_criterio.SetTransObject(sqlca)
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
end event

type cb_cancelar from commandbutton within w_parametros_devolver_trazos
integer x = 489
integer y = 392
integer width = 343
integer height = 100
integer taborder = 20
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

type cb_aceptar from commandbutton within w_parametros_devolver_trazos
integer x = 82
integer y = 392
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

event clicked;n_cts_devolver_trazos lpo_trazo
Long ll_agrupacion

dw_criterio.AcceptText()

ll_agrupacion = dw_criterio.GetItemNUmber(1,'cs_agrupacion')

IF isnull(ll_agrupacion) THEN
	MessageBox('Advertencia','Debe ingresarse la agrupaci$$HEX1$$f300$$ENDHEX$$n a la cual desea devolverle el estado.')
	Return
ELSE
	IF lpo_trazo.of_DevolverTrazo(ll_agrupacion) = -1 THEN
		Rollback;
	ELSE
		Commit;
		MessageBox('Exito','Fue actualizado con exito el estado de la agrupaci$$HEX1$$f300$$ENDHEX$$n. '+String(ll_agrupacion))
	END IF
END IF

end event

type dw_criterio from datawindow within w_parametros_devolver_trazos
integer x = 101
integer y = 136
integer width = 667
integer height = 80
integer taborder = 10
string title = "none"
string dataobject = "dff_parametros_devolver_trazos"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_parametros_devolver_trazos
integer x = 91
integer y = 64
integer width = 699
integer height = 204
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

