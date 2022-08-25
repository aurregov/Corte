HA$PBExportHeader$w_rollos_liberacion_critica.srw
forward
global type w_rollos_liberacion_critica from window
end type
type st_5 from statictext within w_rollos_liberacion_critica
end type
type st_4 from statictext within w_rollos_liberacion_critica
end type
type cb_2 from commandbutton within w_rollos_liberacion_critica
end type
type st_3 from statictext within w_rollos_liberacion_critica
end type
type st_2 from statictext within w_rollos_liberacion_critica
end type
type st_1 from statictext within w_rollos_liberacion_critica
end type
type cb_1 from commandbutton within w_rollos_liberacion_critica
end type
type cb_cancelar from commandbutton within w_rollos_liberacion_critica
end type
type cb_aceptar from commandbutton within w_rollos_liberacion_critica
end type
type dw_lista from datawindow within w_rollos_liberacion_critica
end type
type gb_1 from groupbox within w_rollos_liberacion_critica
end type
end forward

global type w_rollos_liberacion_critica from window
integer width = 4805
integer height = 1740
boolean titlebar = true
string title = "Rollos"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_5 st_5
st_4 st_4
cb_2 cb_2
st_3 st_3
st_2 st_2
st_1 st_1
cb_1 cb_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
gb_1 gb_1
end type
global w_rollos_liberacion_critica w_rollos_liberacion_critica

type variables
s_base_parametros istr_parametros


Long	il_fila_actual_maestro
end variables

on w_rollos_liberacion_critica.create
this.st_5=create st_5
this.st_4=create st_4
this.cb_2=create cb_2
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.st_5,&
this.st_4,&
this.cb_2,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista,&
this.gb_1}
end on

on w_rollos_liberacion_critica.destroy
destroy(this.st_5)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.Center = True


dw_lista.SetTransObject(sqlca)

istr_parametros = Message.PowerObjectParm	

dw_lista.Retrieve(istr_parametros.cadena[1],&
						istr_parametros.entero[1],&
						istr_parametros.entero[2],&
						istr_parametros.entero[3],&
						istr_parametros.entero[4],&
						istr_parametros.entero[5],&
						istr_parametros.entero[6],&
						istr_parametros.entero[7],&
						istr_parametros.cadena[2],&
						istr_parametros.cadena[3])
						
dw_lista.Setfocus()						
end event

type st_5 from statictext within w_rollos_liberacion_critica
integer x = 73
integer y = 1504
integer width = 3365
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "El campo Completo se utiliza para las liberaciones agrupadas, para que el sistema se consumo todo el rollo y no deje nada disponible para otra liberacion"
boolean focusrectangle = false
end type

type st_4 from statictext within w_rollos_liberacion_critica
integer x = 73
integer y = 1448
integer width = 3319
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En las telas con procesos calle (bordado y estampado)  los rollos con el estilo en color azul son los que tienen el dise$$HEX1$$f100$$ENDHEX$$o correcto para la pinta liberada"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rollos_liberacion_critica
integer x = 2373
integer y = 1212
integer width = 421
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Info. Calidad"
end type

event clicked;LONG	ll_tanda, ll_tela


ll_tanda = dw_lista.GetitemNumber(il_fila_actual_maestro,'cs_tanda')
ll_tela  = dw_lista.GetitemNumber(il_fila_actual_maestro,'co_reftel')



end event

type st_3 from statictext within w_rollos_liberacion_critica
integer x = 73
integer y = 1452
integer width = 3319
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En las telas con procesos calle (bordado y estampado)  los rollos con el estilo en color azul son los que tienen el dise$$HEX1$$f100$$ENDHEX$$o correcto para la pinta liberada"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rollos_liberacion_critica
integer x = 78
integer y = 1396
integer width = 2597
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Los Rollos que muestran el numero de rollo con fondo ROJO son los que ya estan siendo utilizados en otra liberaci$$HEX1$$f300$$ENDHEX$$n."
boolean focusrectangle = false
end type

type st_1 from statictext within w_rollos_liberacion_critica
integer x = 78
integer y = 1340
integer width = 2400
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Los Rollos que muestran la tanda con fondo VERDE son los que tienen tela de la misma tanda en otro modelo"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rollos_liberacion_critica
integer x = 1838
integer y = 1212
integer width = 443
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Incluir Rollos"
end type

event clicked;Long li_fila, li_marca
Long ll_rollo
String ls_usuario, ls_mensaje
n_cts_liberacion_x_proyeccion luo_proyeccion

SetPointer(HourGlass!)

ls_usuario = Trim(gstr_info_usuario.codigo_usuario)
FOR li_fila = 1 TO dw_lista.RowCount()
	li_marca = dw_lista.GetItemNumber(li_fila,'marca')
	IF li_marca = 0 THEN
		ll_rollo = dw_lista.GetItemNumber(li_fila,'rollo')
		//se elimina el rollo de la temporal
		IF luo_proyeccion.of_borrarrollos(ll_rollo,ls_usuario,ls_mensaje) =-1 THEN
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de descartar los rollos selecionados, ERROR: '+ls_mensaje,StopSign!)
		ELSE
			Commit;
		END IF
	END IF
NEXT

dw_lista.Retrieve(istr_parametros.cadena[1],&
						istr_parametros.entero[1],&
						istr_parametros.entero[2],&
						istr_parametros.entero[3],&
						istr_parametros.entero[4],&
						istr_parametros.entero[5],&
						istr_parametros.entero[6],&
						istr_parametros.entero[7],&
						istr_parametros.cadena[2],&
						istr_parametros.cadena[3])
						
dw_lista.Setfocus()			
end event

type cb_cancelar from commandbutton within w_rollos_liberacion_critica
integer x = 2903
integer y = 1212
integer width = 727
integer height = 168
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cerrar"
boolean cancel = true
end type

event clicked;IF dw_lista.AcceptText() = -1 THEN
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN -1
ELSE
	IF dw_lista.Update() = -1 THEN
		ROLLBACK;
	   RETURN -2
	ELSE
			COMMIT;
		IF SQLCA.SQLCode = -1 THEN
				Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)
			RETURN -3
		ELSE
		END IF
	END IF
END IF


Close(Parent)
end event

type cb_aceptar from commandbutton within w_rollos_liberacion_critica
integer x = 1303
integer y = 1212
integer width = 443
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Descartar Rollos"
end type

event clicked;Long li_fila, li_marca
Long ll_rollo
String ls_usuario, ls_mensaje
n_cts_liberacion_x_proyeccion luo_proyeccion

SetPointer(HourGlass!)
ls_usuario = Trim(gstr_info_usuario.codigo_usuario)
FOR li_fila = 1 TO dw_lista.RowCount()
	li_marca = dw_lista.GetItemNumber(li_fila,'marca')
	IF li_marca = 1 THEN
		ll_rollo = dw_lista.GetItemNumber(li_fila,'rollo')
		//se elimina el rollo de la temporal
		IF luo_proyeccion.of_borrarrollos(ll_rollo,ls_usuario,ls_mensaje) =-1 THEN
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de descartar los rollos selecionados, ERROR: '+ls_mensaje,StopSign!)
		ELSE
			Commit;
		END IF
	END IF
NEXT

dw_lista.Retrieve(istr_parametros.cadena[1],&
						istr_parametros.entero[1],&
						istr_parametros.entero[2],&
						istr_parametros.entero[3],&
						istr_parametros.entero[4],&
						istr_parametros.entero[5],&
						istr_parametros.entero[6],&
						istr_parametros.entero[7],&
						istr_parametros.cadena[2],&
						istr_parametros.cadena[3])
						
dw_lista.Setfocus()						
end event

type dw_lista from datawindow within w_rollos_liberacion_critica
integer x = 50
integer y = 56
integer width = 4667
integer height = 1080
integer taborder = 10
string title = "none"
string dataobject = "dtb_rollos_liberacion_critica"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;il_fila_actual_maestro = row
end event

type gb_1 from groupbox within w_rollos_liberacion_critica
integer x = 32
integer y = 16
integer width = 4718
integer height = 1148
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

