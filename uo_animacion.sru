HA$PBExportHeader$uo_animacion.sru
forward
global type uo_animacion from UserObject
end type
type p_dibujo from picture within uo_animacion
end type
end forward

global type uo_animacion from UserObject
int Width=946
int Height=176
boolean Border=true
long BackColor=79741120
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
event ue_iteracion pbm_timer
p_dibujo p_dibujo
end type
global uo_animacion uo_animacion

type variables
Long il_posicion = 50
end variables

forward prototypes
public subroutine uof_cambiar_dibujito ()
end prototypes

public subroutine uof_cambiar_dibujito ();IF p_dibujo.x + p_dibujo.Width = This.Width - 50 THEN
	p_dibujo.PictureName = "C:\GRAFICOS\GRUA2.BMP"
END IF

IF p_dibujo.x = 50 THEN
	p_dibujo.PictureName = "C:\GRAFICOS\GRUA.BMP"
END IF

IF p_dibujo.PictureName = "C:\GRAFICOS\GRUA2.BMP" THEN
	il_posicion = il_posicion - 10
ELSE	
	il_posicion = il_posicion + 10
END IF

P_dibujo.x = il_posicion

end subroutine

on uo_animacion.create
this.p_dibujo=create p_dibujo
this.Control[]={this.p_dibujo}
end on

on uo_animacion.destroy
destroy(this.p_dibujo)
end on

type p_dibujo from picture within uo_animacion
int X=50
int Y=16
int Width=151
int Height=136
string PictureName="c:\graficos\grua2.bmp"
boolean FocusRectangle=false
end type

