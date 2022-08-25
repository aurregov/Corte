HA$PBExportHeader$w_resumen_liberacion_po.srw
forward
global type w_resumen_liberacion_po from window
end type
type dw_lista from datawindow within w_resumen_liberacion_po
end type
type gb_1 from groupbox within w_resumen_liberacion_po
end type
end forward

global type w_resumen_liberacion_po from window
integer width = 1152
integer height = 1316
boolean titlebar = true
string title = "Resumen liberacion por P.O."
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
gb_1 gb_1
end type
global w_resumen_liberacion_po w_resumen_liberacion_po

on w_resumen_liberacion_po.create
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.gb_1}
end on

on w_resumen_liberacion_po.destroy
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;Long ll_ordenpd_pt

This.Center = True

dw_lista.SetTransObject(sqlca)

s_base_parametros lstr_parametros

lstr_parametros = message.PowerObjectParm

ll_ordenpd_pt = lstr_parametros.entero[1]

dw_lista.retrieve(ll_ordenpd_pt)
end event

type dw_lista from datawindow within w_resumen_liberacion_po
integer x = 82
integer y = 48
integer width = 983
integer height = 1100
integer taborder = 10
string title = "none"
string dataobject = "dgr_resumen_liberacion_po"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_resumen_liberacion_po
integer x = 37
integer width = 1065
integer height = 1204
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

