HA$PBExportHeader$w_seleccionar_titulo_grafica.srw
forward
global type w_seleccionar_titulo_grafica from Window
end type
type cb_cancelar from commandbutton within w_seleccionar_titulo_grafica
end type
type cb_aceptar from commandbutton within w_seleccionar_titulo_grafica
end type
type sle_titulo from singlelineedit within w_seleccionar_titulo_grafica
end type
end forward

global type w_seleccionar_titulo_grafica from Window
int X=672
int Y=740
int Width=1600
int Height=476
boolean TitleBar=true
string Title="Entre el t$$HEX1$$ed00$$ENDHEX$$tulo de la Gr$$HEX1$$e100$$ENDHEX$$fica"
long BackColor=79741120
boolean ControlMenu=true
boolean Resizable=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_titulo sle_titulo
end type
global w_seleccionar_titulo_grafica w_seleccionar_titulo_grafica

type variables
object io_pasado
graph igr_parm
datawindow idw_parm
string is_titulo_original
end variables

event open;// La ventana que llamo paso el objeto graph. Inicializa
// el SingleLineEdit para que el usuario pueda modificarlo.
// El objeto graph 'igr_parm' es declarado como una variable de instancia.

graphicobject lgro_viejo

lgro_viejo = message.powerobjectparm
If lgro_viejo.TypeOf() = Graph! Then
	io_pasado = Graph!
	igr_parm = message.powerobjectparm
	sle_titulo.text = igr_parm.title
	sle_titulo.SelectText (1,999)
	
	// Recuerda el titulo original, en caso de que cancele
	is_titulo_original = igr_parm.title
Elseif lgro_viejo.TypeOf() = Datawindow! Then
	io_pasado = Datawindow!
	idw_parm = message.powerobjectparm
	sle_titulo.text = idw_parm.Object.gr_1.title
	sle_titulo.SelectText (1,999)

	// Recuerda el titulo original, en caso de que cancele
	is_titulo_original = sle_titulo.text
End If

end event

on w_seleccionar_titulo_grafica.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_titulo=create sle_titulo
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.sle_titulo}
end on

on w_seleccionar_titulo_grafica.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_titulo)
end on

type cb_cancelar from commandbutton within w_seleccionar_titulo_grafica
int X=768
int Y=204
int Width=265
int Height=92
int TabOrder=20
string Text="&Cancelar"
boolean Cancel=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;If io_pasado = Graph! Then
	igr_parm.title = is_titulo_original
Elseif io_pasado = Datawindow! Then
	idw_parm.Object.gr_1.title = is_titulo_original
End If

Close (parent)
end event

type cb_aceptar from commandbutton within w_seleccionar_titulo_grafica
int X=457
int Y=204
int Width=265
int Height=92
int TabOrder=30
string Text="&Aceptar"
boolean Default=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Close (parent) 
end on

type sle_titulo from singlelineedit within w_seleccionar_titulo_grafica
int X=105
int Y=60
int Width=1248
int Height=84
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
long TextColor=41943040
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;If io_pasado = Graph! Then
	igr_parm.title = this.text
Elseif io_pasado = Datawindow! Then
	idw_parm.Object.gr_1.title = this.text
	idw_parm.Modify("gr_1.title="+this.text)
End If
end event

