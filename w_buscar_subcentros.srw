HA$PBExportHeader$w_buscar_subcentros.srw
forward
global type w_buscar_subcentros from window
end type
type cb_cancelar from commandbutton within w_buscar_subcentros
end type
type cb_aceptar from commandbutton within w_buscar_subcentros
end type
type dw_1 from datawindow within w_buscar_subcentros
end type
type gb_1 from groupbox within w_buscar_subcentros
end type
end forward

global type w_buscar_subcentros from window
integer width = 1298
integer height = 1652
boolean titlebar = true
string title = "Buscar Subcentros"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_1 dw_1
gb_1 gb_1
end type
global w_buscar_subcentros w_buscar_subcentros

on w_buscar_subcentros.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_1,&
this.gb_1}
end on

on w_buscar_subcentros.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;This.Center = True
Long li_tipo, li_centro
n_cts_constantes luo_constantes
dw_1.SetTransObject(sqlca)

luo_constantes = Create n_cts_constantes

li_tipo = luo_constantes.of_consultar_numerico("TIPO PRENDAS")

IF li_tipo = -1 THEN
	Return 
END IF

li_centro = luo_constantes.of_consultar_numerico("CENTRO CORTE")

IF li_centro = -1 THEN
	Return 
END IF

dw_1.Retrieve(li_tipo, li_centro)
end event

type cb_cancelar from commandbutton within w_buscar_subcentros
integer x = 718
integer y = 1348
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

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_buscar_subcentros
integer x = 197
integer y = 1348
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

event clicked;s_base_parametros lstr_parametros
Long ll_fila

lstr_parametros.hay_parametros = True

ll_fila = dw_1.GetRow()

If ll_fila > 0 Then
	lstr_parametros.entero[1] = dw_1.GetItemNumber(ll_fila,'co_subcentro_pdn')
	lstr_parametros.cadena[1] = dw_1.GetItemString(ll_fila,'de_subcentro_pdn')
Else
	MessageBox('Advertencia','No ha seleccionado ningun subcentro.')
	Return
End if

CloseWithReturn ( Parent, lstr_parametros )
end event

type dw_1 from datawindow within w_buscar_subcentros
integer x = 73
integer y = 100
integer width = 1152
integer height = 1068
integer taborder = 10
string title = "none"
string dataobject = "dddw_m_subcentros_pdn"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_buscar_subcentros
integer x = 46
integer y = 20
integer width = 1216
integer height = 1216
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Subcentro "
end type

