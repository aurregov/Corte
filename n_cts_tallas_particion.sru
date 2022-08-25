HA$PBExportHeader$n_cts_tallas_particion.sru
forward
global type n_cts_tallas_particion from userobject
end type
type cb_cancelar from commandbutton within n_cts_tallas_particion
end type
type cb_continuar from commandbutton within n_cts_tallas_particion
end type
type dw_1 from datawindow within n_cts_tallas_particion
end type
type gb_1 from groupbox within n_cts_tallas_particion
end type
end forward

global type n_cts_tallas_particion from userobject
integer width = 928
integer height = 1696
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_cancelar cb_cancelar
cb_continuar cb_continuar
dw_1 dw_1
gb_1 gb_1
end type
global n_cts_tallas_particion n_cts_tallas_particion

forward prototypes
public function long of_inicio (s_base_parametros lstr_parametros)
end prototypes

public function long of_inicio (s_base_parametros lstr_parametros);//s_base_parametros lstr_parametros
Long li_sim
dw_1.SetTransObject(sqlca)

//lstr_parametros = Message.PowerObjectParm	


dw_1.Retrieve(lstr_parametros.entero[1],&
						lstr_parametros.entero[2],&
						lstr_parametros.entero[3],&
						lstr_parametros.entero[4],&
						lstr_parametros.entero[5],&
						lstr_parametros.entero[6],&
						lstr_parametros.cadena[1],&
						lstr_parametros.cadena[2],&
						lstr_parametros.entero[7],&
						lstr_parametros.entero[8],&
						lstr_parametros.entero[9],&
						lstr_parametros.entero[10],&
						lstr_parametros.cadena[3],&
						lstr_parametros.entero[11],&
						lstr_parametros.entero[12],&
						lstr_parametros.entero[13])
						
Return 0
end function

on n_cts_tallas_particion.create
this.cb_cancelar=create cb_cancelar
this.cb_continuar=create cb_continuar
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_continuar,&
this.dw_1,&
this.gb_1}
end on

on n_cts_tallas_particion.destroy
destroy(this.cb_cancelar)
destroy(this.cb_continuar)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event constructor;
//s_base_parametros lstr_parametros
//
//dw_1.SetTransObject(sqlca)
//
//
//lstr_parametros = Message.PowerObjectParm	
//
//
//dw_1.Retrieve(lstr_parametros.entero[1],&
//						lstr_parametros.entero[2],&
//						lstr_parametros.entero[3],&
//						lstr_parametros.entero[4],&
//						lstr_parametros.entero[5],&
//						lstr_parametros.entero[6],&
//						lstr_parametros.cadena[1],&
//						lstr_parametros.cadena[2],&
//						lstr_parametros.entero[7],&
//						lstr_parametros.entero[8],&
//						lstr_parametros.entero[9],&
//						lstr_parametros.entero[10],&
//						lstr_parametros.cadena[3],&
//						lstr_parametros.entero[11],&
//						lstr_parametros.entero[12],&
//						lstr_parametros.entero[13])
end event

type cb_cancelar from commandbutton within n_cts_tallas_particion
integer x = 494
integer y = 1492
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
end type

event clicked;return -1
end event

type cb_continuar from commandbutton within n_cts_tallas_particion
integer x = 105
integer y = 1492
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Continuar"
end type

event clicked;return 0
end event

type dw_1 from datawindow within n_cts_tallas_particion
integer x = 110
integer y = 40
integer width = 731
integer height = 1384
integer taborder = 10
string title = "none"
string dataobject = "dgr_tallas_particion"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within n_cts_tallas_particion
integer x = 78
integer width = 786
integer height = 1432
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

