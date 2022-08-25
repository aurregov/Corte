HA$PBExportHeader$w_tipo_liberacion.srw
forward
global type w_tipo_liberacion from window
end type
type cb_1 from commandbutton within w_tipo_liberacion
end type
type rb_igualar from radiobutton within w_tipo_liberacion
end type
type rb_equilibrar from radiobutton within w_tipo_liberacion
end type
type cb_aceptar from commandbutton within w_tipo_liberacion
end type
type gb_1 from groupbox within w_tipo_liberacion
end type
end forward

global type w_tipo_liberacion from window
integer width = 1001
integer height = 856
boolean titlebar = true
string title = "Tipo Liberaci$$HEX1$$f300$$ENDHEX$$n"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
rb_igualar rb_igualar
rb_equilibrar rb_equilibrar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_tipo_liberacion w_tipo_liberacion

on w_tipo_liberacion.create
this.cb_1=create cb_1
this.rb_igualar=create rb_igualar
this.rb_equilibrar=create rb_equilibrar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.cb_1,&
this.rb_igualar,&
this.rb_equilibrar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_tipo_liberacion.destroy
destroy(this.cb_1)
destroy(this.rb_igualar)
destroy(this.rb_equilibrar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

type cb_1 from commandbutton within w_tipo_liberacion
integer x = 594
integer y = 536
integer width = 329
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;//se retorna 0 para salir sin entrar a la ventana de liberacion
s_base_parametros lstr_parametros
//inicialmente se coloca en comentario hasta terner todo ok para poder ser trabajado por el usuario
lstr_parametros.entero[1] = 0
rb_equilibrar.Checked = FALSE
rb_igualar.Checked = TRUE

CloseWithReturn ( Parent, lstr_parametros )
end event

type rb_igualar from radiobutton within w_tipo_liberacion
integer x = 169
integer y = 332
integer width = 654
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cantidades Iguales"
boolean checked = true
boolean lefttext = true
end type

type rb_equilibrar from radiobutton within w_tipo_liberacion
integer x = 169
integer y = 152
integer width = 654
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Balancear Unidades"
boolean lefttext = true
end type

event clicked;String ls_password, ls_password_ingresado
n_cts_constantes_corte lpo_const_corte
s_base_parametros lstr_parametros

ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZA EQUILIBRA DUO'))
Open(w_password_trazos)
lstr_parametros = message.PowerObjectParm

If lstr_parametros.hay_parametros = true Then
	ls_password_ingresado = Trim(lstr_parametros.cadena[1])
			
	If ls_password_ingresado = ls_password Then
		// clave correcta				
	Else
		MessageBox('Error','Password, no valido.')
		rb_equilibrar.Checked = FALSE
		Return 2
	End if
Else
	rb_equilibrar.Checked = FALSE
	Return 2
End if


end event

type cb_aceptar from commandbutton within w_tipo_liberacion
integer x = 155
integer y = 536
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;//evento para determinar el tipo de liberacion que se va a trabajar por parte del usuario,
//cuando se pretende liberar un duo o conjunto de linea
//opcion 1 = rb_equilibrar
//opcion 2 = rb_igualar
//jcrm
//agosto 21 de 2008
s_base_parametros lstr_parametros
//inicialmente se coloca en comentario hasta terner todo ok para poder ser trabajado por el usuario
IF rb_equilibrar.Checked = TRUE THEN
	//el usuario selecciono una opcion que debe validarse que si este autorizado a usar.
	lstr_parametros.entero[1] = 1
ELSEIF rb_igualar.Checked = TRUE THEN
	//retornar para generar la opcion 2 de igualar liberaciones
	lstr_parametros.entero[1] = 2
ELSE
	//no existe ninguna opcion seleccionada debe informarsele esto al usuario
	MessageBox('Advertencia','Debe seleccionar que tipo de liberaci$$HEX1$$f300$$ENDHEX$$n desea realizar.',StopSign!)
	Return
END IF

CloseWithReturn ( Parent, lstr_parametros )
end event

type gb_1 from groupbox within w_tipo_liberacion
integer x = 96
integer y = 52
integer width = 823
integer height = 408
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

