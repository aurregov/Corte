HA$PBExportHeader$w_base_buscar_lista.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para digitar una clave a retornar al cerrarla y usarla para buscar un dato en la invocadora. La ventana que la invoque
forward
global type w_base_buscar_lista from window
end type
type st_numero_registros from statictext within w_base_buscar_lista
end type
type pb_cancelar from picturebutton within w_base_buscar_lista
end type
type pb_aceptar from picturebutton within w_base_buscar_lista
end type
type dw_lista from datawindow within w_base_buscar_lista
end type
end forward

global type w_base_buscar_lista from window
integer x = 645
integer y = 268
integer width = 1550
integer height = 984
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 79741120
st_numero_registros st_numero_registros
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
dw_lista dw_lista
end type
global w_base_buscar_lista w_base_buscar_lista

type variables
long il_fila_actual = 0
end variables

event open;long ll_numero_registros

///////////////////////////////////////////////////////////////////////
//  En este evento se esta contando el numero de registros que son 
//  consultados para poder desplegarlos en la pantalla en el 
//  control "st_numero_registros".
//
// Ademas se le da el focus al datawindows y se pone en modo de que
// no permita modificacion.
////////////////////////////////////////////////////////////////////////

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	ll_numero_registros = dw_lista.Retrieve()
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			dw_lista.setrow(1)
			dw_lista.selectrow(1,true)
			il_fila_actual = 1
	END CHOOSE
END IF
dw_lista.SetRowFocusIndicator (Off!)
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

on w_base_buscar_lista.create
this.st_numero_registros=create st_numero_registros
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.dw_lista=create dw_lista
this.Control[]={this.st_numero_registros,&
this.pb_cancelar,&
this.pb_aceptar,&
this.dw_lista}
end on

on w_base_buscar_lista.destroy
destroy(this.st_numero_registros)
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.dw_lista)
end on

type st_numero_registros from statictext within w_base_buscar_lista
integer x = 270
integer y = 620
integer width = 1038
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_cancelar from picturebutton within w_base_buscar_lista
integer x = 869
integer y = 732
integer width = 393
integer height = 124
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
string picturename = "c:\graficos\cancelar.bmp"
alignment htextalign = right!
end type

event clicked;
s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from picturebutton within w_base_buscar_lista
integer x = 311
integer y = 732
integer width = 393
integer height = 124
integer taborder = 10
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

event clicked;///////////////////////////////////////////////////////////////////
// En este evento se le asigna al campo entero de la estructura 
// s_base_parametros el contenido del campo clave de la fila actual.
///////////////////////////////////////////////////////////////////
//
//s_base_parametros lstr_parametros
//
//IF il_fila_actual > 0 THEN
//	lstr_parametros.hay_parametros = TRUE
//	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"")
//	closewithreturn(parent,lstr_parametros)
//ELSE
//	lstr_parametros.hay_parametros = FALSE
//	CloseWithReturn(parent,lstr_parametros)
//END IF

end event

type dw_lista from datawindow within w_base_buscar_lista
integer x = 32
integer y = 24
integer width = 1477
integer height = 560
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//// Se evalua si se hizo click sobre una fila valida

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	this.selectrow(il_fila_actual,false)
	il_fila_actual = row
ELSE
END IF





end event

event doubleclicked;//// Se evalua si se hizo click sobre una fila valida

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	this.selectrow(il_fila_actual,false)
	il_fila_actual = row
	pb_aceptar.triggerevent(clicked!)
ELSE
END IF

	







end event

event rowfocuschanged;this.selectrow(il_fila_actual,false)
il_fila_actual=this.getrow()
this.setrow(il_fila_actual)
this.selectrow(il_fila_actual,true)


end event

