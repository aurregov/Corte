HA$PBExportHeader$w_base_buscar_lista_parametro.srw
forward
global type w_base_buscar_lista_parametro from Window
end type
type st_1 from statictext within w_base_buscar_lista_parametro
end type
type em_dato from editmask within w_base_buscar_lista_parametro
end type
type st_numero_registros from statictext within w_base_buscar_lista_parametro
end type
type pb_cancelar from picturebutton within w_base_buscar_lista_parametro
end type
type pb_aceptar from picturebutton within w_base_buscar_lista_parametro
end type
type dw_lista from datawindow within w_base_buscar_lista_parametro
end type
end forward

global type w_base_buscar_lista_parametro from Window
int X=645
int Y=268
int Width=1600
int Height=1128
boolean TitleBar=true
long BackColor=79741120
WindowType WindowType=response!
st_1 st_1
em_dato em_dato
st_numero_registros st_numero_registros
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
dw_lista dw_lista
end type
global w_base_buscar_lista_parametro w_base_buscar_lista_parametro

type variables
long il_fila_actual = 0
end variables

event open;long ll_numero_registros


IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
END IF
dw_lista.modify("dw_lista.readonly=yes")


end event

on w_base_buscar_lista_parametro.create
this.st_1=create st_1
this.em_dato=create em_dato
this.st_numero_registros=create st_numero_registros
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.dw_lista=create dw_lista
this.Control[]={this.st_1,&
this.em_dato,&
this.st_numero_registros,&
this.pb_cancelar,&
this.pb_aceptar,&
this.dw_lista}
end on

on w_base_buscar_lista_parametro.destroy
destroy(this.st_1)
destroy(this.em_dato)
destroy(this.st_numero_registros)
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.dw_lista)
end on

type st_1 from statictext within w_base_buscar_lista_parametro
int X=37
int Y=40
int Width=187
int Height=76
boolean Enabled=false
string Text="Buscar:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_dato from editmask within w_base_buscar_lista_parametro
int X=233
int Y=40
int Width=910
int Height=76
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
string Mask="#"
MaskDataType MaskDataType=StringMask!
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;String ls_datocon
Long ll_numero_registros


ls_datocon = em_dato.Text
IF Not IsNull(ls_datocon) THEN
	ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(ls_datocon)
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
end event

type st_numero_registros from statictext within w_base_buscar_lista_parametro
int X=288
int Y=744
int Width=1001
int Height=72
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean FocusRectangle=false
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_cancelar from picturebutton within w_base_buscar_lista_parametro
int X=864
int Y=864
int Width=393
int Height=124
int TabOrder=30
string Text="&Cancelar"
string PictureName="c:\graficos\cancelar.bmp"
Alignment HTextAlign=Right!
boolean Cancel=true
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from picturebutton within w_base_buscar_lista_parametro
int X=306
int Y=864
int Width=393
int Height=124
int TabOrder=10
string Text="&Aceptar"
string PictureName="c:\graficos\ok.bmp"
Alignment HTextAlign=Right!
boolean Default=true
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
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

type dw_lista from datawindow within w_base_buscar_lista_parametro
int X=27
int Y=156
int Width=1467
int Height=560
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
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

