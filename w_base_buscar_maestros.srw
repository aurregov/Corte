HA$PBExportHeader$w_base_buscar_maestros.srw
forward
global type w_base_buscar_maestros from window
end type
type cb_cancelar from commandbutton within w_base_buscar_maestros
end type
type cb_aceptar from commandbutton within w_base_buscar_maestros
end type
type dw_lista from datawindow within w_base_buscar_maestros
end type
type gb_1 from groupbox within w_base_buscar_maestros
end type
end forward

global type w_base_buscar_maestros from window
integer width = 1317
integer height = 1384
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_base_buscar_maestros w_base_buscar_maestros

forward prototypes
public function long of_retornar_valor ()
end prototypes

public function long of_retornar_valor ();Long ll_fila

s_base_parametros lstr_parametros

ll_fila = dw_lista.GetRow()

If ll_fila > 0 Then

	lstr_parametros.hay_parametros = True
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(ll_fila,'codigo')
	lstr_parametros.cadena[1] = dw_lista.GetItemString(ll_fila,'de_codigo')
	CloseWithReturn ( This, lstr_parametros )
Else
	MessageBox('Error','La fila seleccinada no es validad.')
	Return -1
	
End if
Return 0
end function

on w_base_buscar_maestros.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_base_buscar_maestros.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;//la datawindows que se envie como parametro debe tener los campos
//codigo (codigo numero en el maestro) y de_codigo (descricripcion del campo maestro)

String ls_datawindows
s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

ls_datawindows = lstr_parametros.cadena[1]

dw_lista.DataObject = ls_datawindows

dw_lista.SetTransObject(sqlca)

dw_lista.Retrieve()
end event

type cb_cancelar from commandbutton within w_base_buscar_maestros
integer x = 727
integer y = 1128
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
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )

end event

type cb_aceptar from commandbutton within w_base_buscar_maestros
integer x = 229
integer y = 1128
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

event clicked;of_retornar_valor()
end event

type dw_lista from datawindow within w_base_buscar_maestros
integer x = 82
integer y = 96
integer width = 1102
integer height = 972
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

type gb_1 from groupbox within w_base_buscar_maestros
integer x = 55
integer y = 36
integer width = 1161
integer height = 1060
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lista "
end type

