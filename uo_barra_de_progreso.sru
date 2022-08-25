HA$PBExportHeader$uo_barra_de_progreso.sru
forward
global type uo_barra_de_progreso from UserObject
end type
type st_1 from statictext within uo_barra_de_progreso
end type
type rc_2 from rectangle within uo_barra_de_progreso
end type
end forward

global type uo_barra_de_progreso from UserObject
int Width=1102
int Height=80
boolean Border=true
long BackColor=16777215
long PictureMaskColor=25166016
long TabTextColor=33554432
long TabBackColor=67108864
st_1 st_1
rc_2 rc_2
end type
global uo_barra_de_progreso uo_barra_de_progreso

type variables
// Determines if the progress bar has touched the 
// percentage text
boolean    ib_invert
end variables

forward prototypes
public subroutine uof_coloque_posicion (decimal ac_porcentaje)
end prototypes

public subroutine uof_coloque_posicion (decimal ac_porcentaje);//////////////////////////////////////////////////////////////////////
//
// Function: 	uof_coloque_posicion
//
// Proposito: 	expande el metro de progreso y actualiza el porcentaje
//					hasta el porcentaje pasado x parametro
//
//	Scope: public
//
//	Argumentos: ac_porcentaje		el % que debe mostrar la barra 
//	
//	Returns: none
//
//////////////////////////////////////////////////////////////////////

long	ll_color


//////////////////////////////////////////////////////////////////////
// Resetea variable de instancia y colores si la barra ha sido rearrancada
//////////////////////////////////////////////////////////////////////
if Int (ac_porcentaje) = 0 then
	ib_invert = false
	st_1.TextColor = RGB (0, 0, 255)
	st_1.BackColor = RGB (255, 255, 255)	
end if


//////////////////////////////////////////////////////////////////////
// expande la barra de progreso
//////////////////////////////////////////////////////////////////////
rc_2.width = ac_porcentaje / 100.0 * this.width
rc_2.visible = true

//////////////////////////////////////////////////////////////////////
// actualiza el texto con el %
//////////////////////////////////////////////////////////////////////
st_1.text = String (ac_porcentaje / 100.0, "##0%")


//////////////////////////////////////////////////////////////////////
// Chequea si la barra de progreso toca el st_1
// Si lo hace invierte los colores de dicho control
//////////////////////////////////////////////////////////////////////
if not ib_invert then
	if rc_2.width >= st_1.x then
		ib_invert = true
		ll_color = st_1.textcolor
		st_1.TextColor = st_1.BackColor
		st_1.BackColor = ll_color
	end if
end if
end subroutine

on uo_barra_de_progreso.create
this.st_1=create st_1
this.rc_2=create rc_2
this.Control[]={this.st_1,&
this.rc_2}
end on

on uo_barra_de_progreso.destroy
destroy(this.st_1)
destroy(this.rc_2)
end on

type st_1 from statictext within uo_barra_de_progreso
int X=517
int Y=4
int Width=137
int Height=64
string Text="0%"
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=16777215
long BorderColor=16711680
int TextSize=-9
int Weight=700
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rc_2 from rectangle within uo_barra_de_progreso
int Width=32
int Height=144
boolean Visible=false
boolean Enabled=false
int LineThickness=4
long LineColor=16711680
long FillColor=16711680
end type

