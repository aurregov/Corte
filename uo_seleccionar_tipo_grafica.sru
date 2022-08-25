HA$PBExportHeader$uo_seleccionar_tipo_grafica.sru
forward
global type uo_seleccionar_tipo_grafica from UserObject
end type
type st_1 from statictext within uo_seleccionar_tipo_grafica
end type
type cb_aceptar from commandbutton within uo_seleccionar_tipo_grafica
end type
type cb_cancelar from commandbutton within uo_seleccionar_tipo_grafica
end type
type p_tiposgraficas from picture within uo_seleccionar_tipo_grafica
end type
type mle_1 from multilineedit within uo_seleccionar_tipo_grafica
end type
end forward

global type uo_seleccionar_tipo_grafica from UserObject
int Width=2218
int Height=1101
boolean Border=true
long BackColor=78682240
long PictureMaskColor=25166016
long TabTextColor=33554432
long TabBackColor=67108864
event tipografica_aceptar pbm_custom01
event tipografica_cancelar pbm_custom02
st_1 st_1
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
p_tiposgraficas p_tiposgraficas
mle_1 mle_1
end type
global uo_seleccionar_tipo_grafica uo_seleccionar_tipo_grafica

type variables
Long	ii_fila = 0, ii_Col = 0
String	is_tipografica

end variables

forward prototypes
public function long uof_consultar_tipografica (ref long ai_fila, ref long ai_col, ref string as_tipo)
end prototypes

public function long uof_consultar_tipografica (ref long ai_fila, ref long ai_col, ref string as_tipo);// Funcion UOF_CONSULTAR_TIPOGRAFICA (int a_fila, int a_col)

//	Retorna los valores actuales de ui_fila y ui_col 
// en ai_fila y ai_Col, respectivamente

// Retorna +1 si fila y columna actual son validas, 0 si no son validas

ai_fila = ii_fila
ai_Col = ii_Col

If ii_fila = 2 And ii_Col = 6 Then
	Return 0		
ElseIf ii_fila < 1 Or ii_Col < 1 Then
	Return 0
Else
	as_Tipo = is_tipografica
	Return 1
End If

end function

event constructor;p_tiposgraficas.width = mle_1.width - 20
p_tiposgraficas.height = mle_1.height - 20

end event

on uo_seleccionar_tipo_grafica.create
this.st_1=create st_1
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
this.p_tiposgraficas=create p_tiposgraficas
this.mle_1=create mle_1
this.Control[]={ this.st_1,&
this.cb_aceptar,&
this.cb_cancelar,&
this.p_tiposgraficas,&
this.mle_1}
end on

on uo_seleccionar_tipo_grafica.destroy
destroy(this.st_1)
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
destroy(this.p_tiposgraficas)
destroy(this.mle_1)
end on

type st_1 from statictext within uo_seleccionar_tipo_grafica
int X=1911
int Y=449
int Width=202
int Height=69
boolean Visible=false
boolean Enabled=false
string Text="none"
Alignment Alignment=Center!
long TextColor=16777215
long BackColor=8388608
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_aceptar from commandbutton within uo_seleccionar_tipo_grafica
int X=1911
int Y=81
int Width=257
int Height=113
int TabOrder=20
string Text="&Aceptar"
boolean Default=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.TriggerEvent ("tipografica_aceptar")
end event

type cb_cancelar from commandbutton within uo_seleccionar_tipo_grafica
int X=1911
int Y=213
int Width=266
int Height=109
int TabOrder=10
string Text="&Cancelar"
boolean Cancel=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Parent.TriggerEvent ("tipografica_cancelar")
end event

type p_tiposgraficas from picture within uo_seleccionar_tipo_grafica
int X=23
int Y=45
int Width=1793
int Height=1001
string PictureName="c:\graficos\tiposgra.bmp"
end type

event clicked;Constant Long		iANCHOCOL = 287, iALTOFILA = 308
Long	li_X, li_Y, li_TextX, li_TextY
String	ls_titulo, &
			ls_titulos1[6] = {"Area", "Barras", "Columnas", "Lineas", "Torta", "Nube de Puntos"}, &
			ls_titulos3[6] = {"Barras", "Columnas", "Barras", "Columnas", "Barras", "Columnas"}, &
			ls_tipografica[6,3] = { &
				"areagraph","bargraph","colgraph","linegraph","piegraph","scattergraph",&
				"area3d","bar3dgraph","col3dgraph","line3d","pie3d","error",&
				"barstackgraph","colstackgraph","bar3dobjgraph","col3dobjgraph",&
				"barstack3dobjgraph","colstack3dobjgraph"}						

li_X = This.PointerX()
li_Y = This.PointerY()
If li_X < 25 or li_X > 1747 or li_Y < 30 or li_Y > 954 Then
	st_1.Hide()
	Beep(1)
	Return
End If

ii_Col = ((li_X - 25) / iANCHOCOL) + 1
ii_fila = ((li_Y - 30) / iALTOFILA) + 1

If ii_fila = 3 Then
	ls_titulo = ls_titulos3[ii_Col]
Else
	ls_titulo = ls_titulos1[ii_Col]
End If

li_TextY = (ii_fila * iALTOFILA) + ((ii_fila - 1) * 10)

st_1.Text = ls_titulo
li_TextX = This.x + ((ii_Col - 1) * iANCHOCOL) + 75
li_TextY = li_TextY - This.y

st_1.Hide ()
If ii_fila = 2 And ii_Col = 6 Then
	Beep (1)			// SOLO 5 ENTRADAS EN FILA 2 (NO NUBE DE PUNTOS 3D )
Else
	st_1.Move (li_TextX, li_TextY)
	st_1.Show ()
End If

is_tipografica = ls_tipografica[ii_Col, ii_fila]

end event

event doubleclicked;TriggerEvent (cb_aceptar, clicked!)
end event

type mle_1 from multilineedit within uo_seleccionar_tipo_grafica
int X=10
int Y=33
int Width=1811
int Height=1009
int TabOrder=30
boolean Border=false
long BackColor=79741120
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

