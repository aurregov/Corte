HA$PBExportHeader$w_parametros_filtro.srw
forward
global type w_parametros_filtro from Window
end type
type sle_superior from singlelineedit within w_parametros_filtro
end type
type rb_entre from radiobutton within w_parametros_filtro
end type
type pb_1 from picturebutton within w_parametros_filtro
end type
type rb_mayor_igual from radiobutton within w_parametros_filtro
end type
type rb_menor_igual from radiobutton within w_parametros_filtro
end type
type rb_diferente from radiobutton within w_parametros_filtro
end type
type rb_mayor from radiobutton within w_parametros_filtro
end type
type rb_menor from radiobutton within w_parametros_filtro
end type
type rb_igual from radiobutton within w_parametros_filtro
end type
type pb_cancelar from picturebutton within w_parametros_filtro
end type
type pb_aceptar from picturebutton within w_parametros_filtro
end type
type sle_filtro from singlelineedit within w_parametros_filtro
end type
type gb_2 from groupbox within w_parametros_filtro
end type
type gb_1 from groupbox within w_parametros_filtro
end type
end forward

global type w_parametros_filtro from Window
int X=823
int Y=360
int Width=1472
int Height=792
boolean TitleBar=true
string Title="Par$$HEX1$$e100$$ENDHEX$$metros de Filtro"
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=response!
sle_superior sle_superior
rb_entre rb_entre
pb_1 pb_1
rb_mayor_igual rb_mayor_igual
rb_menor_igual rb_menor_igual
rb_diferente rb_diferente
rb_mayor rb_mayor
rb_menor rb_menor
rb_igual rb_igual
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
sle_filtro sle_filtro
gb_2 gb_2
gb_1 gb_1
end type
global w_parametros_filtro w_parametros_filtro

type variables

end variables

on w_parametros_filtro.create
this.sle_superior=create sle_superior
this.rb_entre=create rb_entre
this.pb_1=create pb_1
this.rb_mayor_igual=create rb_mayor_igual
this.rb_menor_igual=create rb_menor_igual
this.rb_diferente=create rb_diferente
this.rb_mayor=create rb_mayor
this.rb_menor=create rb_menor
this.rb_igual=create rb_igual
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.sle_filtro=create sle_filtro
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.sle_superior,&
this.rb_entre,&
this.pb_1,&
this.rb_mayor_igual,&
this.rb_menor_igual,&
this.rb_diferente,&
this.rb_mayor,&
this.rb_menor,&
this.rb_igual,&
this.pb_cancelar,&
this.pb_aceptar,&
this.sle_filtro,&
this.gb_2,&
this.gb_1}
end on

on w_parametros_filtro.destroy
destroy(this.sle_superior)
destroy(this.rb_entre)
destroy(this.pb_1)
destroy(this.rb_mayor_igual)
destroy(this.rb_menor_igual)
destroy(this.rb_diferente)
destroy(this.rb_mayor)
destroy(this.rb_menor)
destroy(this.rb_igual)
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.sle_filtro)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;rb_igual.checked = TRUE
end event

event close;//s_base_parametros lstr_parametros
//
//lstr_parametros.hay_parametros = false
//CloseWithReturn(this, lstr_parametros)

end event

type sle_superior from singlelineedit within w_parametros_filtro
int X=667
int Y=72
int Width=603
int Height=92
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rb_entre from radiobutton within w_parametros_filtro
int X=101
int Y=436
int Width=306
int Height=76
int TabOrder=90
string Text="Entre "
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
boolean RightToLeft=true
long TextColor=33554432
long BackColor=79741120
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = FALSE
rb_diferente.checked = FALSE
rb_menor.checked = FALSE
rb_menor_igual.checked = FALSE
rb_mayor.checked = FALSE
rb_mayor_igual.checked = FALSE
rb_entre.checked = TRUE
end event

type pb_1 from picturebutton within w_parametros_filtro
int X=1330
int Y=28
int Width=101
int Height=88
int TabOrder=120
string PictureName="c:\graficos\bigquest.bmp"
Alignment HTextAlign=Right!
boolean OriginalSize=true
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;open (w_ayuda_filtro)
end event

type rb_mayor_igual from radiobutton within w_parametros_filtro
int X=910
int Y=356
int Width=347
int Height=76
int TabOrder=80
string Text="Mayor Igual  "
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = FALSE
rb_diferente.checked = FALSE
rb_menor.checked = FALSE
rb_menor_igual.checked = FALSE
rb_mayor.checked = FALSE
rb_mayor_igual.checked = TRUE
rb_entre.checked = FALSE
end event

type rb_menor_igual from radiobutton within w_parametros_filtro
int X=466
int Y=356
int Width=352
int Height=76
int TabOrder=70
string Text="Menor Igual  "
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = FALSE
rb_diferente.checked = FALSE
rb_menor.checked = FALSE
rb_menor_igual.checked = TRUE
rb_mayor.checked = FALSE
rb_mayor_igual.checked = FALSE
rb_entre.checked = FALSE
end event

type rb_diferente from radiobutton within w_parametros_filtro
int X=101
int Y=356
int Width=306
int Height=76
int TabOrder=60
string Text="Direfente"
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=79741120
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = FALSE
rb_diferente.checked = TRUE
rb_menor.checked = FALSE
rb_menor_igual.checked = FALSE
rb_mayor.checked = FALSE
rb_mayor_igual.checked = FALSE
rb_entre.checked = FALSE
end event

type rb_mayor from radiobutton within w_parametros_filtro
int X=1029
int Y=276
int Width=224
int Height=76
int TabOrder=50
string Text="Mayor"
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = FALSE
rb_diferente.checked = FALSE
rb_menor.checked = FALSE
rb_menor_igual.checked = FALSE
rb_mayor.checked = TRUE
rb_mayor_igual.checked = FALSE
rb_entre.checked = FALSE
end event

type rb_menor from radiobutton within w_parametros_filtro
int X=590
int Y=276
int Width=224
int Height=76
int TabOrder=40
string Text="Menor"
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = FALSE
rb_diferente.checked = FALSE
rb_menor.checked = TRUE
rb_menor_igual.checked = FALSE
rb_mayor.checked = FALSE
rb_mayor_igual.checked = FALSE
rb_entre.checked = FALSE
end event

type rb_igual from radiobutton within w_parametros_filtro
int X=192
int Y=276
int Width=215
int Height=76
int TabOrder=30
string Text="Igual"
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;rb_igual.checked = TRUE
rb_diferente.checked = FALSE
rb_menor.checked = FALSE
rb_menor_igual.checked = FALSE
rb_mayor.checked = FALSE
rb_mayor_igual.checked = FALSE
rb_entre.checked = FALSE
end event

type pb_cancelar from picturebutton within w_parametros_filtro
int X=773
int Y=564
int Width=370
int Height=124
int TabOrder=110
string Text="&Cancelar"
string PictureName="c:\graficos\cancelar.bmp"
Alignment HTextAlign=Right!
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = false
CloseWithReturn(Parent, lstr_parametros)
end event

type pb_aceptar from picturebutton within w_parametros_filtro
int X=160
int Y=564
int Width=370
int Height=124
int TabOrder=100
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

event clicked;string ls_filtro

ls_filtro = trim(sle_filtro.text)

s_base_parametros lstr_parametros

IF rb_igual.checked = TRUE THEN
	lstr_parametros.cadena[2] = '='	
	lstr_parametros.cadena[3] = ' '	
END IF

IF rb_diferente.checked = TRUE THEN
	lstr_parametros.cadena[2] = '<>'	
	lstr_parametros.cadena[3] = ' '		
END IF

IF rb_menor.checked = TRUE THEN
	lstr_parametros.cadena[2] = '<'	
	lstr_parametros.cadena[3] = ' '		
END IF

IF rb_menor_igual.checked = TRUE THEN
	lstr_parametros.cadena[2] = '<='	
	lstr_parametros.cadena[3] = ' '		
END IF

IF rb_mayor.checked = TRUE THEN
	lstr_parametros.cadena[2] = '>'	
	lstr_parametros.cadena[3] = ' '		
END IF

IF rb_mayor_igual.checked = TRUE THEN
	lstr_parametros.cadena[2] = '>='	
	lstr_parametros.cadena[3] = ' '		
END IF

IF rb_entre.Checked = TRUE THEN
	lstr_parametros.cadena[2] = ' Between '	
	lstr_parametros.cadena[3] = sle_superior.Text
END IF

if not isnull(ls_filtro) then
	lstr_parametros.hay_parametros = True
	lstr_parametros.cadena[1] = ls_filtro
ELSE
	lstr_parametros.hay_parametros = False
END IF
CloseWithReturn(Parent, lstr_parametros)
end event

type sle_filtro from singlelineedit within w_parametros_filtro
int X=46
int Y=72
int Width=622
int Height=92
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
string Text="Todos"
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_2 from groupbox within w_parametros_filtro
int X=23
int Y=216
int Width=1275
int Height=316
string Text="Condiciones:"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_parametros_filtro
int X=23
int Y=4
int Width=1275
int Height=196
string Text="Buscar Por:"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

