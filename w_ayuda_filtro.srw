HA$PBExportHeader$w_ayuda_filtro.srw
forward
global type w_ayuda_filtro from Window
end type
type st_27 from statictext within w_ayuda_filtro
end type
type st_18 from statictext within w_ayuda_filtro
end type
type st_19 from statictext within w_ayuda_filtro
end type
type st_17 from statictext within w_ayuda_filtro
end type
type cb_1 from commandbutton within w_ayuda_filtro
end type
type st_20 from statictext within w_ayuda_filtro
end type
type st_16 from statictext within w_ayuda_filtro
end type
type st_15 from statictext within w_ayuda_filtro
end type
type st_14 from statictext within w_ayuda_filtro
end type
type st_12 from statictext within w_ayuda_filtro
end type
type st_13 from statictext within w_ayuda_filtro
end type
type st_11 from statictext within w_ayuda_filtro
end type
type st_10 from statictext within w_ayuda_filtro
end type
type st_9 from statictext within w_ayuda_filtro
end type
type st_8 from statictext within w_ayuda_filtro
end type
type st_7 from statictext within w_ayuda_filtro
end type
type st_6 from statictext within w_ayuda_filtro
end type
type st_5 from statictext within w_ayuda_filtro
end type
type st_4 from statictext within w_ayuda_filtro
end type
type st_3 from statictext within w_ayuda_filtro
end type
type st_2 from statictext within w_ayuda_filtro
end type
type st_1 from statictext within w_ayuda_filtro
end type
end forward

global type w_ayuda_filtro from Window
int X=357
int Y=348
int Width=1550
int Height=1036
long BackColor=15793151
WindowType WindowType=response!
st_27 st_27
st_18 st_18
st_19 st_19
st_17 st_17
cb_1 cb_1
st_20 st_20
st_16 st_16
st_15 st_15
st_14 st_14
st_12 st_12
st_13 st_13
st_11 st_11
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_ayuda_filtro w_ayuda_filtro

on w_ayuda_filtro.create
this.st_27=create st_27
this.st_18=create st_18
this.st_19=create st_19
this.st_17=create st_17
this.cb_1=create cb_1
this.st_20=create st_20
this.st_16=create st_16
this.st_15=create st_15
this.st_14=create st_14
this.st_12=create st_12
this.st_13=create st_13
this.st_11=create st_11
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.st_27,&
this.st_18,&
this.st_19,&
this.st_17,&
this.cb_1,&
this.st_20,&
this.st_16,&
this.st_15,&
this.st_14,&
this.st_12,&
this.st_13,&
this.st_11,&
this.st_10,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_ayuda_filtro.destroy
destroy(this.st_27)
destroy(this.st_18)
destroy(this.st_19)
destroy(this.st_17)
destroy(this.cb_1)
destroy(this.st_20)
destroy(this.st_16)
destroy(this.st_15)
destroy(this.st_14)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

type st_27 from statictext within w_ayuda_filtro
int X=1001
int Y=772
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Todas"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_18 from statictext within w_ayuda_filtro
int X=503
int Y=772
int Width=562
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Sin separadores de mil"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_19 from statictext within w_ayuda_filtro
int X=46
int Y=772
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Decimal"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_17 from statictext within w_ayuda_filtro
int X=46
int Y=12
int Width=1358
int Height=76
boolean Enabled=false
string Text="Ayuda para Filtrar Informaci$$HEX1$$f300$$ENDHEX$$n en Pantalla"
boolean FocusRectangle=false
long TextColor=128
long BackColor=15793151
int TextSize=-10
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_ayuda_filtro
int X=1115
int Y=900
int Width=297
int Height=108
int TabOrder=10
string Text="Regresar ..."
boolean Default=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;close (w_ayuda_filtro)
end event

type st_20 from statictext within w_ayuda_filtro
int X=46
int Y=400
int Width=462
int Height=76
boolean Enabled=false
string Text="Consideraciones:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_16 from statictext within w_ayuda_filtro
int X=110
int Y=336
int Width=1312
int Height=76
boolean Enabled=false
string Text="aparece la condici$$HEX1$$f300$$ENDHEX$$n de que sea igual."
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_15 from statictext within w_ayuda_filtro
int X=46
int Y=268
int Width=1431
int Height=76
boolean Enabled=false
string Text="2. Escoger la condici$$HEX1$$f300$$ENDHEX$$n para el filtrado. Por defecto"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_14 from statictext within w_ayuda_filtro
int X=46
int Y=176
int Width=1431
int Height=76
boolean Enabled=false
string Text="1. Digitar el valor por el cual se desea realizar el filtro."
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_12 from statictext within w_ayuda_filtro
int X=46
int Y=108
int Width=247
int Height=76
boolean Enabled=false
string Text="Pasos:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_13 from statictext within w_ayuda_filtro
int X=1001
int Y=556
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Todas"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_11 from statictext within w_ayuda_filtro
int X=1001
int Y=700
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Todas"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_10 from statictext within w_ayuda_filtro
int X=1001
int Y=628
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Todas"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_9 from statictext within w_ayuda_filtro
int X=1001
int Y=484
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Condiciones"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_8 from statictext within w_ayuda_filtro
int X=503
int Y=700
int Width=562
int Height=76
boolean Enabled=false
boolean Border=true
string Text="No Tiene"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_7 from statictext within w_ayuda_filtro
int X=503
int Y=628
int Width=562
int Height=76
boolean Enabled=false
boolean Border=true
string Text="No Tiene"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_6 from statictext within w_ayuda_filtro
int X=503
int Y=556
int Width=562
int Height=76
boolean Enabled=false
boolean Border=true
string Text="dd/mm/yyyy"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_ayuda_filtro
int X=503
int Y=484
int Width=562
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Formato"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_ayuda_filtro
int X=46
int Y=484
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Tipo de Campo"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_ayuda_filtro
int X=46
int Y=700
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Car$$HEX1$$e100$$ENDHEX$$cter"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_ayuda_filtro
int X=46
int Y=628
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="N$$HEX1$$fa00$$ENDHEX$$merico"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_ayuda_filtro
int X=46
int Y=556
int Width=462
int Height=76
boolean Enabled=false
boolean Border=true
string Text="Fecha"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=15793151
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

