HA$PBExportHeader$w_base_buscar_interactivo.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para mostrar una lista de registros y seleccionar uno solo, del cual se toman los campos claves se guardan en una estructura y se cierra la ventana con retorno hacia la ventana que la invoco la cual debe recibir el dato$$HEX1$$4441$$ENDHEX$$
forward
global type w_base_buscar_interactivo from Window
end type
type pb_cancelar from picturebutton within w_base_buscar_interactivo
end type
type pb_buscar from picturebutton within w_base_buscar_interactivo
end type
type st_1 from statictext within w_base_buscar_interactivo
end type
type sle_parametro1 from singlelineedit within w_base_buscar_interactivo
end type
type gb_1 from groupbox within w_base_buscar_interactivo
end type
end forward

global type w_base_buscar_interactivo from Window
int X=841
int Y=644
int Width=1271
int Height=636
boolean TitleBar=true
long BackColor=79741120
boolean ControlMenu=true
WindowType WindowType=response!
pb_cancelar pb_cancelar
pb_buscar pb_buscar
st_1 st_1
sle_parametro1 sle_parametro1
gb_1 gb_1
end type
global w_base_buscar_interactivo w_base_buscar_interactivo

on w_base_buscar_interactivo.create
this.pb_cancelar=create pb_cancelar
this.pb_buscar=create pb_buscar
this.st_1=create st_1
this.sle_parametro1=create sle_parametro1
this.gb_1=create gb_1
this.Control[]={this.pb_cancelar,&
this.pb_buscar,&
this.st_1,&
this.sle_parametro1,&
this.gb_1}
end on

on w_base_buscar_interactivo.destroy
destroy(this.pb_cancelar)
destroy(this.pb_buscar)
destroy(this.st_1)
destroy(this.sle_parametro1)
destroy(this.gb_1)
end on

type pb_cancelar from picturebutton within w_base_buscar_interactivo
int X=663
int Y=364
int Width=393
int Height=124
int TabOrder=20
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

type pb_buscar from picturebutton within w_base_buscar_interactivo
int X=197
int Y=364
int Width=393
int Height=124
int TabOrder=10
string Text="&Buscar"
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

event clicked;///////////////////////////////////////////////////////////////////////
// Estas lineas se deben acondionar seg$$HEX1$$fa00$$ENDHEX$$n la busqueda
//
///////////////////////////////////////////////////////////////////////

//s_parametros lstr_parametros
//lstr_parametros.hay_parametros = TRUE
//lstr_parametros.cadena[1]=sle_parametro1.text
//
//CloseWithReturn(parent,ls_parametro)
end event

type st_1 from statictext within w_base_buscar_interactivo
int X=133
int Y=136
int Width=256
int Height=80
boolean Enabled=false
string Text="Parametro: "
boolean FocusRectangle=false
long BackColor=81576884
long BorderColor=79741120
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_parametro1 from singlelineedit within w_base_buscar_interactivo
int X=471
int Y=132
int Width=635
int Height=88
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_base_buscar_interactivo
int X=32
int Y=4
int Width=1170
int Height=328
int TabOrder=40
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

