HA$PBExportHeader$w_parametros_kamban_corte.srw
forward
global type w_parametros_kamban_corte from window
end type
type cb_cancelar from commandbutton within w_parametros_kamban_corte
end type
type cb_aceptar from commandbutton within w_parametros_kamban_corte
end type
type dw_1 from datawindow within w_parametros_kamban_corte
end type
type gb_1 from groupbox within w_parametros_kamban_corte
end type
end forward

global type w_parametros_kamban_corte from window
integer width = 928
integer height = 756
boolean titlebar = true
string title = "Parametros"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_1 dw_1
gb_1 gb_1
end type
global w_parametros_kamban_corte w_parametros_kamban_corte

on w_parametros_kamban_corte.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_1,&
this.gb_1}
end on

on w_parametros_kamban_corte.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;This.Center = True

dw_1.SetTransObject(sqlca)
dw_1.InserTrow(0)
dw_1.SetFocus()
end event

type cb_cancelar from commandbutton within w_parametros_kamban_corte
integer x = 507
integer y = 480
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn (parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_parametros_kamban_corte
integer x = 82
integer y = 480
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
boolean default = true
end type

event clicked;Long ll_tipo, ll_centro, ll_subcentro
s_base_parametros lstr_parametros

dw_1.AcceptText()

ll_tipo 	    = dw_1.GetItemNumber(1,'tipoprod')
ll_centro 	 = dw_1.GetItemNumber(1,'centro')
ll_subcentro = dw_1.GetItemNumber(1,'subcentro')

If isnull(ll_tipo) Then ll_tipo = 0
If isnull(ll_centro) Then ll_centro = 0
If isnull(ll_subcentro) Then ll_subcentro = 0

lstr_parametros.hay_parametros = True
lstr_parametros.entero[1] = ll_tipo
lstr_parametros.entero[2] = ll_centro
lstr_parametros.entero[3] = ll_subcentro

CloseWithReturn (parent, lstr_parametros )
end event

type dw_1 from datawindow within w_parametros_kamban_corte
integer x = 110
integer y = 96
integer width = 713
integer height = 264
integer taborder = 10
string title = "none"
string dataobject = "dff_parametros_kamban_corte"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_parametros_kamban_corte
integer x = 78
integer y = 44
integer width = 777
integer height = 348
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

