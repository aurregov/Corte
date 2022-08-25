HA$PBExportHeader$w_seleccionar_color_grafica.srw
forward
global type w_seleccionar_color_grafica from Window
end type
type uo_selecciona_color from uo_seleccionar_color within w_seleccionar_color_grafica
end type
type em_bloques from editmask within w_seleccionar_color_grafica
end type
type cb_cancelar from commandbutton within w_seleccionar_color_grafica
end type
type rb_fondobloques from radiobutton within w_seleccionar_color_grafica
end type
type rb_frentebloques from radiobutton within w_seleccionar_color_grafica
end type
type cb_aceptar from commandbutton within w_seleccionar_color_grafica
end type
type gb_2 from groupbox within w_seleccionar_color_grafica
end type
type gb_1 from groupbox within w_seleccionar_color_grafica
end type
end forward

global type w_seleccionar_color_grafica from Window
int X=375
int Y=252
int Width=933
int Height=1136
boolean TitleBar=true
string Title="Seleccione los Colores para la Grafica"
long BackColor=79741120
boolean Resizable=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
event ue_redibujar ( )
uo_selecciona_color uo_selecciona_color
em_bloques em_bloques
cb_cancelar cb_cancelar
rb_fondobloques rb_fondobloques
rb_frentebloques rb_frentebloques
cb_aceptar cb_aceptar
gb_2 gb_2
gb_1 gb_1
end type
global w_seleccionar_color_grafica w_seleccionar_color_grafica

type variables
graph igr_parm
datawindow idw_parm

long il_contserie
string is_nombreserie
long il_colorfondo, il_colortexto, il_sercolorfondo []
long il_sercolorfrente []

long il_colorfondo2, il_colortexto2
long il_sercolorfrente2[], il_sercolorfondo2[]

end variables

event ue_redibujar;idw_parm.setredraw(true)
end event

event open;//	Esto cambia el color de la grafica que fue pasada en el message.powerobjectparm

int 		li_indice
long		ll_color_grafica
string	ls_nombre_serie 

//	el objeto se almacena en io_pasado

Datawindow lgro_viejo
lgro_viejo =  message.powerobjectparm

idw_parm = message.powerobjectparm
il_contserie = idw_parm.SeriesCount("gr_1")

//	MANTIENE UNA COPIA PARA EL BOTON DE CANCELAR
string ls_colorfondo, ls_colortexto

ls_colorfondo = idw_parm.Object.gr_1.backcolor
ls_colortexto = idw_parm.Object.gr_1.color
il_colorfondo = Long(ls_colorfondo)
il_colortexto = Long(ls_colortexto)

For li_indice = 1 to il_contserie
	is_nombreserie = idw_parm.SeriesName ("gr_1", li_indice)		
	idw_parm.getSeriesStyle ( "gr_1",is_nombreserie, background!, il_sercolorfondo[li_indice])
	idw_parm.getSeriesStyle ( "gr_1",is_nombreserie, foreground!, il_sercolorfrente[li_indice])
Next


is_nombreserie = idw_parm.SeriesName ("gr_1",1)
idw_parm.getseriesstyle ("gr_1", is_nombreserie, foreground!, ll_color_grafica)

If il_contserie > 1 Then
	em_bloques.minmax = "1~~" + String(il_contserie)
	em_bloques.enabled = true
End If

uo_selecciona_color.uof_cuadre_rgb(ll_color_grafica) 





end event

on w_seleccionar_color_grafica.create
this.uo_selecciona_color=create uo_selecciona_color
this.em_bloques=create em_bloques
this.cb_cancelar=create cb_cancelar
this.rb_fondobloques=create rb_fondobloques
this.rb_frentebloques=create rb_frentebloques
this.cb_aceptar=create cb_aceptar
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.uo_selecciona_color,&
this.em_bloques,&
this.cb_cancelar,&
this.rb_fondobloques,&
this.rb_frentebloques,&
this.cb_aceptar,&
this.gb_2,&
this.gb_1}
end on

on w_seleccionar_color_grafica.destroy
destroy(this.uo_selecciona_color)
destroy(this.em_bloques)
destroy(this.cb_cancelar)
destroy(this.rb_fondobloques)
destroy(this.rb_frentebloques)
destroy(this.cb_aceptar)
destroy(this.gb_2)
destroy(this.gb_1)
end on

type uo_selecciona_color from uo_seleccionar_color within w_seleccionar_color_grafica
event destroy ( )
int X=32
int Y=356
int Width=809
int Height=452
int TabOrder=40
BorderStyle BorderStyle=StyleRaised!
long BackColor=79741120
end type

on uo_selecciona_color.destroy
call uo_seleccionar_color::destroy
end on

event color_cambiado;string ls_color_nuevo
long ll_color_viejo

// Cuando el color es cambiado, cambia el color apropiado en la
// grafica, dependiendo del radiobutton chequeado

//Obtenga color nuevo
ls_color_nuevo = string (uo_selecciona_color.uof_obtenga_rgb ( ))

//encuentra cual atributo cambiar

IF rb_fondobloques.checked THEN
	idw_parm.SetSeriesStyle ( "gr_1", is_nombreserie, background!,& 
									uo_selecciona_color.uof_obtenga_rgb ( ))
END IF

IF rb_frentebloques.checked THEN
	idw_parm.SetSeriesStyle ( "gr_1", is_nombreserie, foreground!,& 
									uo_selecciona_color.uof_obtenga_rgb ( ))
END IF


Parent.TriggerEvent("ue_redibujar")


end event

type em_bloques from editmask within w_seleccionar_color_grafica
event ue_emchanged pbm_enchange
int X=617
int Y=128
int Width=183
int Height=100
int TabOrder=60
boolean Enabled=false
BorderStyle BorderStyle=StyleLowered!
string Mask="###,###."
boolean Spin=true
double Increment=1
string MinMax="1~~1"
boolean DisplayOnly=true
string Text="1"
long TextColor=33554432
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_emchanged;//Obtiene la serie a cambiar

is_nombreserie = idw_parm.SeriesName ("gr_1", Long(em_bloques.text))

If rb_fondobloques.checked Then rb_fondobloques.TriggerEvent("clicked")
If rb_frentebloques.checked Then rb_frentebloques.TriggerEvent("clicked")

end event

type cb_cancelar from commandbutton within w_seleccionar_color_grafica
int X=443
int Y=860
int Width=297
int Height=100
int TabOrder=20
string Text="&Cancelar"
boolean Cancel=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// RESTAURA A LOS COLORES ORIGINALES

int li_indice

idw_parm.Setredraw (false)
idw_parm.Object.gr_1.backcolor = string(il_colorfondo)
idw_parm.Object.gr_1.color = string(il_colortexto)
	
For li_indice = 1 to il_contserie
	is_nombreserie = idw_parm.SeriesName("gr_1",li_indice)
	idw_parm.SetSeriesStyle ( "gr_1", is_nombreserie, background!,il_sercolorfondo[li_indice])
	idw_parm.SetSeriesStyle ( "gr_1", is_nombreserie, foreground!,il_sercolorfrente[li_indice])
Next
idw_parm.Setredraw (true)

Close (parent)


end event

type rb_fondobloques from radiobutton within w_seleccionar_color_grafica
int X=64
int Y=204
int Width=448
int Height=68
int TabOrder=30
string Text="Borde Bloques"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=74481808
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;long ll_grcolor

idw_parm.getseriesstyle ("gr_1", is_nombreserie, background!, ll_grcolor)

uo_selecciona_color.uof_cuadre_rgb(ll_grcolor)
end event

type rb_frentebloques from radiobutton within w_seleccionar_color_grafica
int X=64
int Y=104
int Width=448
int Height=68
int TabOrder=10
string Text="Relleno Bloques"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long TextColor=33554432
long BackColor=74481808
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;long ll_grcolor

idw_parm.getseriesstyle ("gr_1", is_nombreserie, foreground!, ll_grcolor)

uo_selecciona_color.uof_cuadre_rgb(ll_grcolor)

end event

type cb_aceptar from commandbutton within w_seleccionar_color_grafica
int X=64
int Y=860
int Width=297
int Height=100
int TabOrder=70
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

type gb_2 from groupbox within w_seleccionar_color_grafica
int X=562
int Y=24
int Width=288
int Height=280
int TabOrder=50
string Text="Bloque #"
BorderStyle BorderStyle=StyleLowered!
long BackColor=74481808
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_seleccionar_color_grafica
int X=32
int Y=24
int Width=503
int Height=280
string Text="Items a Cambiar"
BorderStyle BorderStyle=StyleLowered!
long BackColor=74481808
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

