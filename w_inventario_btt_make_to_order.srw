HA$PBExportHeader$w_inventario_btt_make_to_order.srw
forward
global type w_inventario_btt_make_to_order from window
end type
type cb_cerrar from commandbutton within w_inventario_btt_make_to_order
end type
type dw_lista from datawindow within w_inventario_btt_make_to_order
end type
type gb_1 from groupbox within w_inventario_btt_make_to_order
end type
end forward

global type w_inventario_btt_make_to_order from window
integer width = 3035
integer height = 1480
boolean titlebar = true
string title = "Inventario en Bodega de Tela Terminada"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cerrar cb_cerrar
dw_lista dw_lista
gb_1 gb_1
end type
global w_inventario_btt_make_to_order w_inventario_btt_make_to_order

type variables
s_base_parametros  istr_param
cst_adm_conexion icst_lectura
end variables

on w_inventario_btt_make_to_order.create
this.cb_cerrar=create cb_cerrar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cerrar,&
this.dw_lista,&
this.gb_1}
end on

on w_inventario_btt_make_to_order.destroy
destroy(this.cb_cerrar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros
icst_lectura = create  cst_adm_conexion

dw_lista.settransobject(icst_lectura.of_get_transaccion_sucia())

lstr_parametros = Message.PowerObjectParm	

dw_lista.Retrieve(lstr_parametros.entero[1],&
						lstr_parametros.entero[2],&
						lstr_parametros.entero[3],&
						lstr_parametros.entero[4],&
						lstr_parametros.entero[5])
						
gb_1.Text = 'Tela: ' +String(lstr_parametros.entero[1]) + ' - ' &
				+'Caract:  '+String(lstr_parametros.entero[2]) + ' - ' &
				+'Diametro: '+String(lstr_parametros.entero[3]) + ' - ' &
				+'Color Tela: '+String(lstr_parametros.entero[4]) + ' '
						


end event

event closequery;icst_lectura.of_destruir_dirty_read( )
end event

type cb_cerrar from commandbutton within w_inventario_btt_make_to_order
integer x = 1394
integer y = 1140
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

event clicked;Close(Parent)
end event

type dw_lista from datawindow within w_inventario_btt_make_to_order
integer x = 59
integer y = 88
integer width = 2912
integer height = 960
integer taborder = 10
string title = "none"
string dataobject = "dgr_rollos_tela_color_make_to_order"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_inventario_btt_make_to_order
integer x = 37
integer y = 20
integer width = 2953
integer height = 1048
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

