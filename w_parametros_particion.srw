HA$PBExportHeader$w_parametros_particion.srw
forward
global type w_parametros_particion from window
end type
type st_1 from statictext within w_parametros_particion
end type
type sle_1 from singlelineedit within w_parametros_particion
end type
type cb_cancelar from commandbutton within w_parametros_particion
end type
type cb_aceptar from commandbutton within w_parametros_particion
end type
end forward

global type w_parametros_particion from window
integer width = 1051
integer height = 704
boolean titlebar = true
string title = "Cantidades"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
sle_1 sle_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_parametros_particion w_parametros_particion

type variables
s_base_parametros istr_parametros 
end variables

on w_parametros_particion.create
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.Control[]={this.st_1,&
this.sle_1,&
this.cb_cancelar,&
this.cb_aceptar}
end on

on w_parametros_particion.destroy
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

event open;This.Center = True
istr_parametros = Message.PowerObjectParm	
end event

type st_1 from statictext within w_parametros_particion
integer x = 59
integer y = 76
integer width = 928
integer height = 124
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese la cantidad con la cual quiere  que quede la nueva partici$$HEX1$$f300$$ENDHEX$$n."
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_parametros_particion
integer x = 343
integer y = 228
integer width = 343
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_parametros_particion
integer x = 571
integer y = 404
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;Close(Parent)
	
end event

type cb_aceptar from commandbutton within w_parametros_particion
integer x = 137
integer y = 404
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
end type

event clicked;//se realiza la partici$$HEX1$$f300$$ENDHEX$$n
Long ll_cantidad, ll_liberacion
n_cts_particion lpo_particion
s_base_parametros lstr_parametros

//primero se determina la cantidad
ll_cantidad = Long(sle_1.Text)

IF isnull(ll_cantidad) OR ll_cantidad = 0 THEN
	MessageBox('Advertencia','Debe ingresarse la cantidad de la nueva partici$$HEX1$$f300$$ENDHEX$$n.')
	Return
Else
	//existe cantidad y debemos generar la particion.
	//se invoca user object para generar esta
		
	IF lpo_particion.of_generar_particion( istr_parametros.entero[1] ,&
							istr_parametros.entero[2] ,&
							istr_parametros.entero[3] ,& 
							istr_parametros.entero[4] ,&
							istr_parametros.entero[5] ,&
							istr_parametros.entero[6] ,&
							istr_parametros.cadena[1] ,&
							istr_parametros.cadena[2] ,& 
							istr_parametros.entero[7] ,& 
							istr_parametros.entero[8] ,& 
							istr_parametros.entero[9] ,&
							istr_parametros.entero[10] ,&
							istr_parametros.cadena[3],&
							istr_parametros.entero[12],&
							ll_cantidad,&
							istr_parametros.entero[11]) = -1 THEN
		Rollback;										
	ELSE
		//genero ventana de autorizacion del usuario para realizar el cambio, siempre que este
		//de acuerdo con los valores generados para las tallas
		
		lpo_particion.of_determinarcsliberacion(istr_parametros.entero[2],ll_liberacion)
				
		istr_parametros.entero[13] = istr_parametros.entero[12] + 1	
		istr_parametros.entero[14] = ll_liberacion - 1		
				
      OpenWithParm(w_tallas_particion,istr_parametros)
		
		lstr_parametros = message.PowerObjectParm	

		If lstr_parametros.hay_parametros = True THEN
			Commit;
		ELSE
			Rollback;
		END IF
	END IF
END IF

Close(Parent)

end event

