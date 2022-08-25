HA$PBExportHeader$uo_animacion_mundo.sru
forward
global type uo_animacion_mundo from UserObject
end type
type p_dibujo from picture within uo_animacion_mundo
end type
end forward

global type uo_animacion_mundo from UserObject
int Width=265
int Height=220
boolean Border=true
long BackColor=67108864
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
event ue_iteracion pbm_timer
p_dibujo p_dibujo
end type
global uo_animacion_mundo uo_animacion_mundo

type variables
String is_vector_dibujos[]
Long il_posicion = 1
end variables

forward prototypes
public subroutine uof_activar_animacion (decimal adc_segundos)
public subroutine uof_cambiar_dibujito ()
end prototypes

event ue_iteracion;IF il_posicion > 16 THEN
	il_posicion = 1
END IF
p_dibujo.PictureName = is_vector_dibujos[il_posicion]
il_posicion++
end event

public subroutine uof_activar_animacion (decimal adc_segundos);Timer(adc_segundos)
end subroutine

public subroutine uof_cambiar_dibujito ();IF il_posicion > 16 THEN
	il_posicion = 1
END IF
p_dibujo.PictureName = is_vector_dibujos[il_posicion]
il_posicion++
end subroutine

on uo_animacion_mundo.create
this.p_dibujo=create p_dibujo
this.Control[]={this.p_dibujo}
end on

on uo_animacion_mundo.destroy
destroy(this.p_dibujo)
end on

event constructor;is_vector_dibujos[1]		= "c:\graficos\mundo1.bmp"
is_vector_dibujos[2]		= "c:\graficos\mundo2.bmp"
is_vector_dibujos[3]		= "c:\graficos\mundo3.bmp"
is_vector_dibujos[4]		= "c:\graficos\mundo4.bmp"
is_vector_dibujos[5]		= "c:\graficos\mundo5.bmp"
is_vector_dibujos[6]		= "c:\graficos\mundo6.bmp"
is_vector_dibujos[7]		= "c:\graficos\mundo7.bmp"
is_vector_dibujos[8]		= "c:\graficos\mundo8.bmp"
is_vector_dibujos[9]		= "c:\graficos\mundo9.bmp"
is_vector_dibujos[10]	= "c:\graficos\mundo10.bmp"
is_vector_dibujos[11]	= "c:\graficos\mundo11.bmp"
is_vector_dibujos[12]	= "c:\graficos\mundo12.bmp"
is_vector_dibujos[13]	= "c:\graficos\mundo13.bmp"
is_vector_dibujos[14]	= "c:\graficos\mundo14.bmp"
is_vector_dibujos[15]	= "c:\graficos\mundo15.bmp"
is_vector_dibujos[16]	= "c:\graficos\mundo16.bmp"


end event

type p_dibujo from picture within uo_animacion_mundo
int X=50
int Y=36
int Width=151
int Height=132
string PictureName="c:\graficos\mundo1.bmp"
boolean FocusRectangle=false
boolean OriginalSize=true
end type

