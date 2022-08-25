HA$PBExportHeader$w_base_acerca_de.srw
$PBExportComments$OBJETO BASE - Ventana invocada por el m_base_principal para mostrar los datos de autores, colaboradores y sistema leidos desde el archivo INI de configuracion. Para utilizar esta ventana solo hay que poner los datos adecuados en el INI.
forward
global type w_base_acerca_de from window
end type
type pb_aceptar from picturebutton within w_base_acerca_de
end type
type tab_1 from tab within w_base_acerca_de
end type
type tabpage_autores from userobject within tab_1
end type
type mle_autores from multilineedit within tabpage_autores
end type
type tabpage_autores from userobject within tab_1
mle_autores mle_autores
end type
type tabpage_colaboradores from userobject within tab_1
end type
type mle_colaboradores from multilineedit within tabpage_colaboradores
end type
type tabpage_colaboradores from userobject within tab_1
mle_colaboradores mle_colaboradores
end type
type tabpage_sistema from userobject within tab_1
end type
type mle_sistema from multilineedit within tabpage_sistema
end type
type tabpage_sistema from userobject within tab_1
mle_sistema mle_sistema
end type
type tab_1 from tab within w_base_acerca_de
tabpage_autores tabpage_autores
tabpage_colaboradores tabpage_colaboradores
tabpage_sistema tabpage_sistema
end type
end forward

global type w_base_acerca_de from window
integer x = 859
integer y = 496
integer width = 1211
integer height = 920
boolean titlebar = true
string title = "Acerca de..."
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
pb_aceptar pb_aceptar
tab_1 tab_1
end type
global w_base_acerca_de w_base_acerca_de

on w_base_acerca_de.create
this.pb_aceptar=create pb_aceptar
this.tab_1=create tab_1
this.Control[]={this.pb_aceptar,&
this.tab_1}
end on

on w_base_acerca_de.destroy
destroy(this.pb_aceptar)
destroy(this.tab_1)
end on

type pb_aceptar from picturebutton within w_base_acerca_de
integer x = 411
integer y = 676
integer width = 393
integer height = 124
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
string picturename = "c:\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;Close(Parent)
end event

type tab_1 from tab within w_base_acerca_de
integer x = 37
integer y = 44
integer width = 1143
integer height = 604
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean raggedright = true
integer selectedtab = 1
tabpage_autores tabpage_autores
tabpage_colaboradores tabpage_colaboradores
tabpage_sistema tabpage_sistema
end type

on tab_1.create
this.tabpage_autores=create tabpage_autores
this.tabpage_colaboradores=create tabpage_colaboradores
this.tabpage_sistema=create tabpage_sistema
this.Control[]={this.tabpage_autores,&
this.tabpage_colaboradores,&
this.tabpage_sistema}
end on

on tab_1.destroy
destroy(this.tabpage_autores)
destroy(this.tabpage_colaboradores)
destroy(this.tabpage_sistema)
end on

type tabpage_autores from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1106
integer height = 476
long backcolor = 79741120
string text = "Autores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom076!"
long picturemaskcolor = 553648127
string powertiptext = "Autores de la Aplicaci$$HEX1$$f300$$ENDHEX$$n"
mle_autores mle_autores
end type

on tabpage_autores.create
this.mle_autores=create mle_autores
this.Control[]={this.mle_autores}
end on

on tabpage_autores.destroy
destroy(this.mle_autores)
end on

type mle_autores from multilineedit within tabpage_autores
integer x = 37
integer y = 44
integer width = 1047
integer height = 452
integer taborder = 11
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean italic = true
long backcolor = 12632256
boolean enabled = false
boolean border = false
boolean autovscroll = true
alignment alignment = center!
end type

event constructor;////////////////////////////////////////////////////////////////////////
// Con la siguiente linea, se esta asignado al
// MultiLineEdit Autores lo que tiene el archivo .ini
// en autores, que esta en la seccion [acerca de].
//////////////////////////////////////////////////////////////////////

THIS.text=ProfileString(gstr_info_usuario.ruta_ini,"acerca de","autores","")
end event

type tabpage_colaboradores from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1106
integer height = 476
long backcolor = 79741120
string text = "Colaboradores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Picture!"
long picturemaskcolor = 553648127
string powertiptext = "Colaboladores del desarrollo"
mle_colaboradores mle_colaboradores
end type

on tabpage_colaboradores.create
this.mle_colaboradores=create mle_colaboradores
this.Control[]={this.mle_colaboradores}
end on

on tabpage_colaboradores.destroy
destroy(this.mle_colaboradores)
end on

type mle_colaboradores from multilineedit within tabpage_colaboradores
integer x = 32
integer y = 32
integer width = 1051
integer height = 412
integer taborder = 12
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean italic = true
long backcolor = 79741120
boolean enabled = false
boolean border = false
boolean autovscroll = true
alignment alignment = center!
end type

event constructor;////////////////////////////////////////////////////////////////////////
// Con la siguiente linea, se esta asignado al
// MultiLineEdit colaboradores lo que tiene el archivo .ini
// en colaboradores, que esta en la seccion [acerca de].
////////////////////////////////////////////////////////////////////////

THIS.text=ProfileString(gstr_info_usuario.ruta_ini,"acerca de","colaboradores","")
end event

type tabpage_sistema from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1106
integer height = 476
long backcolor = 79741120
string text = "Sistema"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ApplicationIcon!"
long picturemaskcolor = 553648127
string powertiptext = "Informaci$$HEX1$$f300$$ENDHEX$$n del Sistema"
mle_sistema mle_sistema
end type

on tabpage_sistema.create
this.mle_sistema=create mle_sistema
this.Control[]={this.mle_sistema}
end on

on tabpage_sistema.destroy
destroy(this.mle_sistema)
end on

type mle_sistema from multilineedit within tabpage_sistema
integer x = 32
integer y = 132
integer width = 1056
integer height = 320
integer taborder = 13
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean italic = true
long backcolor = 79741120
boolean enabled = false
boolean border = false
boolean autovscroll = true
alignment alignment = center!
end type

event constructor;////////////////////////////////////////////////////////////////////////
// Con la siguiente linea, se esta asignado al
// MultiLineEdit sistema lo que tiene el archivo .ini
// en sistema, que esta en la seccion [acerca de].
////////////////////////////////////////////////////////////////////////

This.text = ProfileString(gstr_info_usuario.ruta_ini,"acerca de","sistema","")
end event

