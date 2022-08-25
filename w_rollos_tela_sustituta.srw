HA$PBExportHeader$w_rollos_tela_sustituta.srw
forward
global type w_rollos_tela_sustituta from window
end type
type cb_salir from commandbutton within w_rollos_tela_sustituta
end type
type cb_limpiar from commandbutton within w_rollos_tela_sustituta
end type
type cb_seleccion from commandbutton within w_rollos_tela_sustituta
end type
type cb_modificar from commandbutton within w_rollos_tela_sustituta
end type
type dw_lista from datawindow within w_rollos_tela_sustituta
end type
type gb_1 from groupbox within w_rollos_tela_sustituta
end type
end forward

global type w_rollos_tela_sustituta from window
integer width = 3081
integer height = 1928
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_salir cb_salir
cb_limpiar cb_limpiar
cb_seleccion cb_seleccion
cb_modificar cb_modificar
dw_lista dw_lista
gb_1 gb_1
end type
global w_rollos_tela_sustituta w_rollos_tela_sustituta

type variables
Long il_op_nuevo
end variables

on w_rollos_tela_sustituta.create
this.cb_salir=create cb_salir
this.cb_limpiar=create cb_limpiar
this.cb_seleccion=create cb_seleccion
this.cb_modificar=create cb_modificar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_salir,&
this.cb_limpiar,&
this.cb_seleccion,&
this.cb_modificar,&
this.dw_lista,&
this.gb_1}
end on

on w_rollos_tela_sustituta.destroy
destroy(this.cb_salir)
destroy(this.cb_limpiar)
destroy(this.cb_seleccion)
destroy(this.cb_modificar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

dw_lista.SetTransObject(sqlca)


lstr_parametros = Message.PowerObjectParm	

dw_lista.Retrieve(lstr_parametros.entero[1], lstr_parametros.entero[2], lstr_parametros.entero[3])

il_op_nuevo = lstr_parametros.entero[1]

If dw_lista.RowCount() <= 0 Then
	MessageBox('Advertencia','No existen rollos disponible para el color y tela sustituta',Exclamation!)
	Return
End if


end event

type cb_salir from commandbutton within w_rollos_tela_sustituta
integer x = 1925
integer y = 1376
integer width = 471
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_limpiar from commandbutton within w_rollos_tela_sustituta
integer x = 910
integer y = 1376
integer width = 471
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar"
end type

event clicked;Long ll_fila


FOR ll_fila = 1 TO dw_lista.RowCount()
	dw_lista.SetItem(ll_fila,'marca',0)
NEXT
end event

type cb_seleccion from commandbutton within w_rollos_tela_sustituta
integer x = 402
integer y = 1376
integer width = 471
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar Todos"
end type

event clicked;Long ll_fila


FOR ll_fila = 1 TO dw_lista.RowCount()
	dw_lista.SetItem(ll_fila,'marca',1)
NEXT
end event

type cb_modificar from commandbutton within w_rollos_tela_sustituta
integer x = 1417
integer y = 1376
integer width = 471
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Modificar"
end type

event clicked;Long li_result, li_marca
Long ll_fila, ll_reftel_nueva, ll_rollo, ll_color_nuevo
n_cts_tela_sustituta luo_sustituta

li_result = MessageBox("Advertencia",'Esta seguro(a) de modificar el color y la referencia a los rollos seleccionados',  Exclamation!, OKCancel!, 2)

IF li_result = 1 THEN
	FOR ll_fila = 1 TO dw_lista.RowCount()
		li_marca = dw_lista.GetItemNumber(ll_fila,'marca')
		IF li_marca = 1 THEN
			//se ejecuta el procedimiento de cambio de el color y tela de los rollos seleccionados
			ll_rollo = dw_lista.GetItemNumber(ll_fila,'cs_rollo')
			ll_color_nuevo = dw_lista.GetItemNumber(ll_fila,'co_color')
			ll_reftel_nueva = dw_lista.GetItemNumber(ll_fila,'co_reftel')
			IF luo_sustituta.of_cambio_kardex_rollo(ll_rollo,ll_color_nuevo,ll_reftel_nueva,il_op_nuevo) = -1 THEN
				Rollback;
				Return
			END IF
		END IF
	NEXT
ELSE
	Return
END IF

Commit;
MessageBox('Exito','Los rollos selecionados fueron modificados, por favor verifique dicha informaci$$HEX1$$f300$$ENDHEX$$n.',Exclamation!)

end event

type dw_lista from datawindow within w_rollos_tela_sustituta
integer x = 32
integer y = 40
integer width = 2994
integer height = 1200
integer taborder = 10
string title = "none"
string dataobject = "dgr_rollos_tela_sustituta"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_rollos_tela_sustituta
integer x = 14
integer width = 3035
integer height = 1264
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

