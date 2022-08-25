HA$PBExportHeader$uo_seleccionar_color.sru
forward
global type uo_seleccionar_color from UserObject
end type
type st_3 from statictext within uo_seleccionar_color
end type
type st_2 from statictext within uo_seleccionar_color
end type
type st_1 from statictext within uo_seleccionar_color
end type
type hsb_verde from hscrollbar within uo_seleccionar_color
end type
type hsb_rojo from hscrollbar within uo_seleccionar_color
end type
type sle_azul from singlelineedit within uo_seleccionar_color
end type
type sle_verde from singlelineedit within uo_seleccionar_color
end type
type sle_rojo from singlelineedit within uo_seleccionar_color
end type
type hsb_azul from hscrollbar within uo_seleccionar_color
end type
type rr_1 from roundrectangle within uo_seleccionar_color
end type
end forward

global type uo_seleccionar_color from UserObject
int Width=750
int Height=457
boolean Border=true
long BackColor=78682240
long PictureMaskColor=25166016
long TabTextColor=33554432
long TabBackColor=67108864
event color_cambiado pbm_custom01
st_3 st_3
st_2 st_2
st_1 st_1
hsb_verde hsb_verde
hsb_rojo hsb_rojo
sle_azul sle_azul
sle_verde sle_verde
sle_rojo sle_rojo
hsb_azul hsb_azul
rr_1 rr_1
end type
global uo_seleccionar_color uo_seleccionar_color

type variables
int   ii_r, ii_g, ii_b
end variables

forward prototypes
public function long uof_obtenga_rgb ()
public subroutine uof_cuadre_rgb (long al_rgb)
end prototypes

public function long uof_obtenga_rgb ();//////////////////////////////////////////////////////////////////////
//
// Funcion: uof_obtenga_rgb
//
// Proposito: retorna el valor actual RGB para este user object
//
//	Scope: public
//
//	Argumentos: none	
//
//	Retorna: long		El valor actual RGB para este user object
//
//////////////////////////////////////////////////////////////////////

return RGB (ii_r, ii_g, ii_b)
end function

public subroutine uof_cuadre_rgb (long al_rgb);//////////////////////////////////////////////////////////////////////
//
// Funcion: uof_cuadre_rgb
//
// Proposito: inicializa los valores RGB en este user object a el
//				valor long que es pasado para esta funcion
//
//	Scope: public
//
//	Argumentos: al_rgb	el valor RGB que quiere cuadrar
//								el valor RGB en este user object
//
//	Retorna: none
//
//////////////////////////////////////////////////////////////////////

ii_r = Mod (al_rgb, 256)
al_rgb = al_rgb / 256

ii_g = Mod (al_rgb, 256)
al_rgb = al_rgb / 256

ii_b = Mod (al_rgb, 256)

rr_1.fillcolor = rgb (ii_r, ii_g, ii_b)

hsb_rojo.position = ii_r
hsb_verde.position = ii_g
hsb_azul.position = ii_b

sle_rojo.text = String (ii_r)
sle_verde.text = String (ii_g)
sle_azul.text = String (ii_b)


end subroutine

on uo_seleccionar_color.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.hsb_verde=create hsb_verde
this.hsb_rojo=create hsb_rojo
this.sle_azul=create sle_azul
this.sle_verde=create sle_verde
this.sle_rojo=create sle_rojo
this.hsb_azul=create hsb_azul
this.rr_1=create rr_1
this.Control[]={ this.st_3,&
this.st_2,&
this.st_1,&
this.hsb_verde,&
this.hsb_rojo,&
this.sle_azul,&
this.sle_verde,&
this.sle_rojo,&
this.hsb_azul,&
this.rr_1}
end on

on uo_seleccionar_color.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.hsb_verde)
destroy(this.hsb_rojo)
destroy(this.sle_azul)
destroy(this.sle_verde)
destroy(this.sle_rojo)
destroy(this.hsb_azul)
destroy(this.rr_1)
end on

type st_3 from statictext within uo_seleccionar_color
int X=42
int Y=325
int Width=151
int Height=69
boolean Enabled=false
string Text="Azul:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=78682240
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within uo_seleccionar_color
int X=5
int Y=229
int Width=193
int Height=69
boolean Enabled=false
string Text="Verde:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=65280
long BackColor=78682240
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within uo_seleccionar_color
int X=65
int Y=133
int Width=129
int Height=69
boolean Enabled=false
string Text="Rojo:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=255
long BackColor=78682240
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type hsb_verde from hscrollbar within uo_seleccionar_color
int X=389
int Y=229
int Width=307
int Height=69
int TabOrder=30
boolean Enabled=false
int MaxPosition=255
end type

event pageright;//////////////////////////////////////////////////////////////////////
// incrementa el color verde por 50
//////////////////////////////////////////////////////////////////////

if ii_g > 205 then
	ii_g = 255
else
	ii_g = ii_g + 50
end if
sle_verde.text = String (ii_g)
this.position = ii_g

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_cambiado")
end event

event lineleft;/////////////////////////////////////////////////////////////////////
// Decrementa el color verde por 10
/////////////////////////////////////////////////////////////////////

if ii_g < 10 then
	ii_g = 0
else
	ii_g = ii_g - 10
end if
sle_verde.text = String (ii_g)
this.position = ii_g
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)

parent.TriggerEvent ('color_cambiado')
end event

event lineright;//////////////////////////////////////////////////////////////////////
// incrementa el color verde por 10
//////////////////////////////////////////////////////////////////////

if ii_g > 245 then
	ii_g = 255
else
	ii_g = ii_g + 10
end if
sle_verde.text = String (ii_g)
this.position = ii_g

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_cambiado")
end event

event moved;/////////////////////////////////////////////////////////////////////
// Cambia el color verde basado en la posicion actual del scrollbar
/////////////////////////////////////////////////////////////////////

ii_g = this.position
sle_verde.text = String (ii_g)
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_cambiado')
end event

event pageleft;/////////////////////////////////////////////////////////////////////
// Decrementa el color verde por 50
/////////////////////////////////////////////////////////////////////

if ii_g < 50 then
	ii_g = 0
else
	ii_g = ii_g - 50
end if
sle_verde.text = String (ii_g)
this.position = ii_g
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)

parent.TriggerEvent ('color_cambiado')
end event

type hsb_rojo from hscrollbar within uo_seleccionar_color
int X=389
int Y=141
int Width=307
int Height=69
int TabOrder=10
boolean Enabled=false
int MaxPosition=255
end type

event lineright;//////////////////////////////////////////////////////////////////////
// incrementa el color rojo por 10
//////////////////////////////////////////////////////////////////////

if ii_r > 245 then
	ii_r = 255
else
	ii_r = ii_r + 10
end if
sle_rojo.text = String (ii_r)
this.position = ii_r

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_cambiado")
end event

event pageleft;/////////////////////////////////////////////////////////////////////
// Decrementa el color rojo por 50
/////////////////////////////////////////////////////////////////////

if ii_r < 50 then
	ii_r = 0
else
	ii_r = ii_r - 50
end if
sle_rojo.text = String (ii_r)
this.position = ii_r
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)

parent.TriggerEvent ('color_cambiado')
end event

event lineleft;/////////////////////////////////////////////////////////////////////
// Decrementa el color rojo por 10
/////////////////////////////////////////////////////////////////////

if ii_r < 10 then
	ii_r = 0
else
	ii_r = ii_r - 10
end if
sle_rojo.text = String (ii_r)
this.position = ii_r
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)

parent.TriggerEvent ('color_cambiado')
end event

event moved;/////////////////////////////////////////////////////////////////////
// Cambia el color rojo basado en la posicion actual del scrollbar
/////////////////////////////////////////////////////////////////////

ii_r = this.position
sle_rojo.text = String (ii_r)
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_cambiado')
end event

event pageright;//////////////////////////////////////////////////////////////////////
// incrementa el color rojo por 10
//////////////////////////////////////////////////////////////////////

if ii_r > 205 then
	ii_r = 255
else
	ii_r = ii_r + 50
end if
sle_rojo.text = String (ii_r)
this.position = ii_r

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_cambiado")
end event

type sle_azul from singlelineedit within uo_seleccionar_color
int X=225
int Y=325
int Width=147
int Height=69
int TabOrder=60
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
string Text="0"
string Pointer="arrow!"
long TextColor=16777215
long BackColor=16711680
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;this.SelectText (1, Len (this.text))
end event

event modified;//////////////////////////////////////////////////////////////////////
// Cambia el color azul basado en el dato entrado
//////////////////////////////////////////////////////////////////////

int	li_valor_nuevo


if IsNumber (this.text) then
	li_valor_nuevo = Long (this.text)
	if li_valor_nuevo < 0 or li_valor_nuevo > 255 then
		Beep (1)
		this.text = String (ii_b)
	else
		ii_b = li_valor_nuevo
		rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
		hsb_azul.position = ii_b
		parent.TriggerEvent ("color_cambiado")
	end if
else
	Beep (1)
	this.text = String (ii_b)
end if


end event

type sle_verde from singlelineedit within uo_seleccionar_color
int X=225
int Y=229
int Width=147
int Height=77
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
string Text="0"
string Pointer="arrow!"
long TextColor=16777215
long BackColor=65280
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;this.SelectText (1, Len (this.text))
end event

event modified;//////////////////////////////////////////////////////////////////////
// Cambia el color verde basado en el dato entrado
//////////////////////////////////////////////////////////////////////

int	li_valor_nuevo


if IsNumber (this.text) then
	li_valor_nuevo = Long (this.text)
	if li_valor_nuevo < 0 or li_valor_nuevo > 255 then
		Beep (1)
		this.text = String (ii_g)
	else
		ii_g = li_valor_nuevo
		rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
		hsb_verde.position = ii_g
		parent.TriggerEvent ("color_cambiado")
	end if
else
	Beep (1)
	this.text = String (ii_g)
end if


end event

type sle_rojo from singlelineedit within uo_seleccionar_color
int X=225
int Y=129
int Width=147
int Height=77
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
string Text="0"
string Pointer="arrow!"
long TextColor=16777215
long BackColor=255
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;this.SelectText (1, Len (this.text))
end event

event modified;//////////////////////////////////////////////////////////////////////
// Cambia el color rojo basado en el dato entrado
//////////////////////////////////////////////////////////////////////

int	li_valor_nuevo


if IsNumber (this.text) then
	li_valor_nuevo = Long (this.text)
	if li_valor_nuevo < 0 or li_valor_nuevo > 255 then
		Beep (1)
		this.text = String (ii_r)
	else
		ii_r = li_valor_nuevo
		rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
		hsb_rojo.position = ii_r
		parent.TriggerEvent ("color_cambiado")
	end if
else
	Beep (1)
	this.text = String (ii_r)
end if


end event

type hsb_azul from hscrollbar within uo_seleccionar_color
int X=389
int Y=325
int Width=307
int Height=69
int TabOrder=50
boolean Enabled=false
int MaxPosition=255
end type

event pageright;//////////////////////////////////////////////////////////////////////
// incrementa el color azul por 50
//////////////////////////////////////////////////////////////////////

if ii_b > 205 then
	ii_b = 255
else
	ii_b = ii_b + 50
end if
sle_azul.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_cambiado")
end event

event lineleft;/////////////////////////////////////////////////////////////////////
// Decrementa el color azul por 10
/////////////////////////////////////////////////////////////////////

if ii_b < 10 then
	ii_b = 0
else
	ii_b = ii_b - 10
end if
sle_azul.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_cambiado')
end event

event lineright;//////////////////////////////////////////////////////////////////////
// incrementa el color azul por 10
//////////////////////////////////////////////////////////////////////

if ii_b > 245 then
	ii_b = 255
else
	ii_b = ii_b + 10
end if
sle_azul.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ("color_cambiado")
end event

event moved;/////////////////////////////////////////////////////////////////////
// Cambia el color azul basado en la posicion actual del scrollbar
/////////////////////////////////////////////////////////////////////


ii_b = this.position
sle_azul.text = String (ii_b)

// Change the test palette color
rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_cambiado')
end event

event pageleft;/////////////////////////////////////////////////////////////////////
// Decrementa el color azul por 50
/////////////////////////////////////////////////////////////////////

if ii_b < 50 then
	ii_b = 0
else
	ii_b = ii_b - 50
end if
sle_azul.text = String (ii_b)
this.position = ii_b

rr_1.fillcolor = RGB (ii_r, ii_g, ii_b)
parent.TriggerEvent ('color_cambiado')
end event

type rr_1 from roundrectangle within uo_seleccionar_color
int X=225
int Y=21
int Width=270
int Height=77
boolean Enabled=false
int LineThickness=5
int CornerHeight=445
int CornerWidth=37
long LineColor=1090519039
long FillColor=16777215
end type

