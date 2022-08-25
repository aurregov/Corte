HA$PBExportHeader$w_telas_op_estilo.srw
forward
global type w_telas_op_estilo from window
end type
type cb_cancelar from commandbutton within w_telas_op_estilo
end type
type st_1 from statictext within w_telas_op_estilo
end type
type dw_lista from datawindow within w_telas_op_estilo
end type
type gb_1 from groupbox within w_telas_op_estilo
end type
end forward

global type w_telas_op_estilo from window
integer width = 1454
integer height = 1120
boolean titlebar = true
string title = "Telas "
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_salir ( )
cb_cancelar cb_cancelar
st_1 st_1
dw_lista dw_lista
gb_1 gb_1
end type
global w_telas_op_estilo w_telas_op_estilo

on w_telas_op_estilo.create
this.cb_cancelar=create cb_cancelar
this.st_1=create st_1
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.st_1,&
this.dw_lista,&
this.gb_1}
end on

on w_telas_op_estilo.destroy
destroy(this.cb_cancelar)
destroy(this.st_1)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

dw_lista.SetTransObject(sqlca)


lstr_parametros = Message.PowerObjectParm	

IF dw_lista.retrieve(lstr_parametros.entero[1]) <= 0 Then
	MessageBox('Advertencia','No existen telas asociadas a la O.P. '+String(lstr_parametros.entero[1]))
	lstr_parametros.hay_parametros = False
	CloseWithReturn ( This, lstr_parametros )
End if

end event

type cb_cancelar from commandbutton within w_telas_op_estilo
integer x = 507
integer y = 840
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;s_base_parametros lstr_parametros
	
lstr_parametros.hay_parametros = False
CloseWithReturn ( parent, lstr_parametros )
end event

type st_1 from statictext within w_telas_op_estilo
integer x = 55
integer y = 744
integer width = 1211
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dobleclic sobre la tela para mirar el diagrama de repite."
boolean focusrectangle = false
end type

type dw_lista from datawindow within w_telas_op_estilo
integer x = 37
integer y = 36
integer width = 1362
integer height = 660
integer taborder = 10
string title = "none"
string dataobject = "dgr_telas_op_estilo"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;s_base_parametros lstr_parametros

This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)

If row > 0 Then
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(row,'co_reftel')
	lstr_parametros.hay_parametros = True
	CloseWithReturn ( parent, lstr_parametros )
	
End if
end event

type gb_1 from groupbox within w_telas_op_estilo
integer x = 18
integer width = 1394
integer height = 720
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

