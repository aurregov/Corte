HA$PBExportHeader$w_buscar_lista_referencias.srw
forward
global type w_buscar_lista_referencias from w_base_buscar_lista
end type
type sle_buscar from singlelineedit within w_buscar_lista_referencias
end type
type st_1 from statictext within w_buscar_lista_referencias
end type
type sle_buscar_ref from singlelineedit within w_buscar_lista_referencias
end type
type st_2 from statictext within w_buscar_lista_referencias
end type
end forward

global type w_buscar_lista_referencias from w_base_buscar_lista
integer width = 2103
integer height = 1136
string title = "Buscar Referencias"
event ue_buscar pbm_custom01
sle_buscar sle_buscar
st_1 st_1
sle_buscar_ref sle_buscar_ref
st_2 st_2
end type
global w_buscar_lista_referencias w_buscar_lista_referencias

type variables
s_base_parametros istr_parametros_error
end variables

event ue_buscar;s_base_parametros lstr_parametros_retro

///////////////////////////////////////////////////////////////////
// Las siguientes tres lineas, estan llenando la estructura 
// s_base_parametrospara poder asi desplegar en la ventana 
// de retroalimentacion el mensaje correspondiente a la 
// accion que se esta ejecutando.
//
///////////////////////////////////////////////////////////////////
	
lstr_parametros_retro.cadena[1]="Cargando datos ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros_retro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

CHOOSE CASE dw_lista.Retrieve(sle_buscar.text+"%",0)
	CASE -1
			Close(w_retroalimentacion)
			MessageBox("Error datawindow","No se pudo cargar datos", &
			            Exclamation!,Ok!)
			 
			////////////////////////////////////////////////////////////////
       	// Las siguientes cinco lineas, estan llenando la estructura 
      	// s_base_parametros 
      	// para poder asi desplegar en la ventana de errores el mensaje
      	// correspondiente al error reportado por el motor de base de 
			// datos.
       	////////////////////////////////////////////////////////////////
			 
			istr_parametros_error.cadena[1]=sqlca.dbms
			istr_parametros_error.entero[1]=sqlca.sqlcode
			istr_parametros_error.cadena[2]=this.classname()
			istr_parametros_error.cadena[3]="modified"
			istr_parametros_error.cadena[4]=""
			OpenWithParm(w_reporte_errores,istr_parametros_error)
			Close(This)
	CASE 0
			Close(w_retroalimentacion)
			MessageBox("Error datawindows","No se hallaron datos", &
			            Exclamation!,Ok!)
	CASE ELSE
			Close(w_retroalimentacion)
			il_fila_actual = 1
			dw_lista.SetRow(il_fila_actual)
			dw_lista.SelectRow(il_fila_actual,TRUE)
			dw_lista.ScrollToRow(il_fila_actual)
			dw_lista.SetColumn(1)
			dw_lista.SetFocus()
END CHOOSE

end event

on w_buscar_lista_referencias.create
int iCurrent
call super::create
this.sle_buscar=create sle_buscar
this.st_1=create st_1
this.sle_buscar_ref=create sle_buscar_ref
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_buscar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_buscar_ref
this.Control[iCurrent+4]=this.st_2
end on

on w_buscar_lista_referencias.destroy
call super::destroy
destroy(this.sle_buscar)
destroy(this.st_1)
destroy(this.sle_buscar_ref)
destroy(this.st_2)
end on

event open;IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	//This.TriggerEvent("ue_buscar")
	sle_buscar.SetFocus()
END IF	
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_lista_referencias
boolean visible = false
integer x = 73
integer y = 804
integer width = 105
boolean enabled = true
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_lista_referencias
integer x = 1152
integer y = 864
integer taborder = 40
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_lista_referencias
integer x = 594
integer y = 864
integer taborder = 20
boolean default = false
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	
  lstr_parametros.hay_parametros = TRUE
  lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
  lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_linea")
  lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
  lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"co_talla")  
  lstr_parametros.entero[5]=dw_lista.getitemnumber(il_fila_actual,"co_calidad")
  lstr_parametros.entero[6]=dw_lista.getitemnumber(il_fila_actual,"co_color")
  
  lstr_parametros.cadena[1]=dw_lista.getitemstring(il_fila_actual,"de_referencia")
  lstr_parametros.cadena[2]=dw_lista.getitemstring(il_fila_actual,"gpa")
  closewithreturn(parent,lstr_parametros)						
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_lista_referencias
integer x = 59
integer y = 180
integer width = 1975
integer height = 576
integer taborder = 30
string dataobject = "dtb_buscar_referencias_x_tallas"
end type

type sle_buscar from singlelineedit within w_buscar_lista_referencias
integer x = 434
integer y = 60
integer width = 576
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;Parent.TriggerEvent("ue_buscar")

end event

type st_1 from statictext within w_buscar_lista_referencias
integer x = 27
integer y = 68
integer width = 384
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
string text = "Buscar por Estilo:"
boolean focusrectangle = false
end type

type sle_buscar_ref from singlelineedit within w_buscar_lista_referencias
boolean visible = false
integer x = 1499
integer y = 60
integer width = 247
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;dw_lista.Retrieve("0",Long(sle_buscar_ref.text))
end event

type st_2 from statictext within w_buscar_lista_referencias
boolean visible = false
integer x = 1170
integer y = 68
integer width = 315
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean enabled = false
string text = "o  Referencia:"
boolean focusrectangle = false
end type

