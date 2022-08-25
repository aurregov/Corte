HA$PBExportHeader$w_par_sort_guias_numeracion.srw
forward
global type w_par_sort_guias_numeracion from window
end type
type cb_cancelar from commandbutton within w_par_sort_guias_numeracion
end type
type cb_aceptar from commandbutton within w_par_sort_guias_numeracion
end type
type dw_sort from datawindow within w_par_sort_guias_numeracion
end type
type gb_1 from groupbox within w_par_sort_guias_numeracion
end type
end forward

global type w_par_sort_guias_numeracion from window
integer width = 658
integer height = 1164
boolean titlebar = true
string title = "Ordenamiento"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_sort dw_sort
gb_1 gb_1
end type
global w_par_sort_guias_numeracion w_par_sort_guias_numeracion

type variables
Long il_raya,il_orden
end variables

on w_par_sort_guias_numeracion.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_sort=create dw_sort
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_sort,&
this.gb_1}
end on

on w_par_sort_guias_numeracion.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_sort)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

lstr_parametros=message.powerObjectparm

il_raya = lstr_parametros.entero[2]
il_orden = lstr_parametros.entero[1]

dw_sort.SetTransObject(sqlca)

dw_sort.Retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2])
end event

type cb_cancelar from commandbutton within w_par_sort_guias_numeracion
integer x = 370
integer y = 872
integer width = 247
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_par_sort_guias_numeracion
integer x = 32
integer y = 872
integer width = 247
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

event clicked;Long ll_filas,ll_orden,ll_espacio

dw_sort.AcceptText()

If dw_sort.RowCount() > 0 Then

	For ll_filas = 1 To dw_sort.RowCount()
		ll_espacio = dw_sort.GetItemNumber(ll_filas,'cs_espacio')
		ll_orden = dw_sort.GetItemNumber(ll_filas,'cs_orden')
		
		UPDATE t_guias_num_prog  
	     SET cs_orden = :ll_orden
		WHERE cs_orden_corte = :il_orden and   
	         cs_base_trazos = :il_raya and
				cs_espacio = :ll_espacio;
	Next
End if

Close(Parent)
end event

type dw_sort from datawindow within w_par_sort_guias_numeracion
integer x = 46
integer y = 52
integer width = 558
integer height = 712
integer taborder = 10
string title = "none"
string dataobject = "dgr_par_orden_guias_numeracion"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_par_sort_guias_numeracion
integer x = 32
integer y = 12
integer width = 585
integer height = 780
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

