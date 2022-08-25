HA$PBExportHeader$w_retroalimentacion.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para dar feedback al usuario, es decir mantenerlo informado de que accion se esta ejecutando. Debe ser llamada al principio de procesos que duren mas de 3 segundos en ejecutarse y se le deben mandar parametros.
forward
global type w_retroalimentacion from Window
end type
type mle_mensaje from multilineedit within w_retroalimentacion
end type
end forward

global type w_retroalimentacion from Window
int X=609
int Y=553
int Width=1559
int Height=445
boolean TitleBar=true
long BackColor=79741120
WindowType WindowType=popup!
mle_mensaje mle_mensaje
end type
global w_retroalimentacion w_retroalimentacion

on w_retroalimentacion.create
this.mle_mensaje=create mle_mensaje
this.Control[]={ this.mle_mensaje}
end on

on w_retroalimentacion.destroy
destroy(this.mle_mensaje)
end on

event open;//////////////////////////////////////////////////////////////////////////
// En este script se decalara la variable ls_parametro de tipo estructura,
// para que reciba mensajes.
/////////////////////////////////////////////////////////////////////////

s_base_parametros ls_parametro

////////////////////////////////////////////////////////////////////////
// Las cuatro lineas siguientes, son para posiocionar la ventana al
// momento de ejecucion.
///////////////////////////////////////////////////////////////////////

this.x=612
this.y=554
this.width=1559
this.height=445

ls_parametro = message.powerobjectparm
This.title = ls_parametro.cadena[1]
mle_mensaje.text = ls_parametro.cadena[2]
CHOOSE CASE Lower(ls_parametro.cadena[3])
	CASE "reloj"
		SetPointer(Hourglass!)
	CASE "flecha"
		SetPointer(Arrow!)
END CHOOSE

end event

event close;SetPointer(Arrow!)
end event

type mle_mensaje from multilineedit within w_retroalimentacion
int X=33
int Y=37
int Width=1482
int Height=277
int TabOrder=1
boolean Enabled=false
Alignment Alignment=Center!
boolean Border=false
boolean AutoVScroll=true
boolean DisplayOnly=true
long BackColor=12632256
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

