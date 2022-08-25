HA$PBExportHeader$w_rollos_tanda_calidad.srw
forward
global type w_rollos_tanda_calidad from window
end type
type dw_lista from datawindow within w_rollos_tanda_calidad
end type
type gb_1 from groupbox within w_rollos_tanda_calidad
end type
end forward

global type w_rollos_tanda_calidad from window
integer width = 2496
integer height = 1064
boolean titlebar = true
string title = "Rollos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
gb_1 gb_1
end type
global w_rollos_tanda_calidad w_rollos_tanda_calidad

on w_rollos_tanda_calidad.create
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.gb_1}
end on

on w_rollos_tanda_calidad.destroy
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.Center = True
s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(lstr_parametros.entero[1],&
						lstr_parametros.entero[2],&
						lstr_parametros.entero[3],&
						lstr_parametros.entero[4])


end event

type dw_lista from datawindow within w_rollos_tanda_calidad
integer x = 55
integer y = 60
integer width = 2373
integer height = 856
integer taborder = 10
string title = "none"
string dataobject = "dgr_rollos_calidad_tono"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_rollos_tanda_calidad
integer x = 37
integer y = 16
integer width = 2414
integer height = 916
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

