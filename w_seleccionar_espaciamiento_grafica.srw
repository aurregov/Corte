HA$PBExportHeader$w_seleccionar_espaciamiento_grafica.srw
forward
global type w_seleccionar_espaciamiento_grafica from Window
end type
type em_espaciamiento from editmask within w_seleccionar_espaciamiento_grafica
end type
type cb_cancelar from commandbutton within w_seleccionar_espaciamiento_grafica
end type
type cb_aceptar from commandbutton within w_seleccionar_espaciamiento_grafica
end type
end forward

global type w_seleccionar_espaciamiento_grafica from Window
int X=1075
int Y=369
int Width=1057
int Height=537
boolean TitleBar=true
string Title="Seleccione el % de Espaciamiento"
long BackColor=79741120
boolean ControlMenu=true
boolean Resizable=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
em_espaciamiento em_espaciamiento
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_seleccionar_espaciamiento_grafica w_seleccionar_espaciamiento_grafica

type variables
object io_pasado
graph igr_parm
datawindow idw_parm
int ii_espaciamiento_original
end variables

event open;graphicobject lgro_viejo

lgro_viejo = Message.PowerObjectParm

If lgro_viejo.TypeOf() = Graph! Then
	io_pasado = Graph!
	igr_parm = Message.PowerObjectParm
	em_espaciamiento.text = string(igr_parm.spacing)
	ii_espaciamiento_original = igr_parm.spacing
Elseif lgro_viejo.TypeOf() = Datawindow! Then
	io_pasado = Datawindow!
	idw_parm = Message.PowerObjectParm
	em_espaciamiento.text = idw_parm.Object.gr_1.spacing
	ii_espaciamiento_original = Long(em_espaciamiento.text)
End If
end event

on w_seleccionar_espaciamiento_grafica.create
this.em_espaciamiento=create em_espaciamiento
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.Control[]={ this.em_espaciamiento,&
this.cb_cancelar,&
this.cb_aceptar}
end on

on w_seleccionar_espaciamiento_grafica.destroy
destroy(this.em_espaciamiento)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

type em_espaciamiento from editmask within w_seleccionar_espaciamiento_grafica
event ue_enchange pbm_enchange
int X=257
int Y=77
int Width=458
int Height=101
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
string Mask="#####"
boolean Spin=true
double Increment=10
string MinMax="0	100"
long TextColor=41943040
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event ue_enchange;If io_pasado = Graph! Then
	igr_parm.spacing = Long (em_espaciamiento.text)
Elseif io_pasado = Datawindow! Then
	idw_parm.Object.gr_1.spacing = em_espaciamiento.text
End If

end event

type cb_cancelar from commandbutton within w_seleccionar_espaciamiento_grafica
int X=513
int Y=245
int Width=266
int Height=97
int TabOrder=20
string Text="&Cancelar"
boolean Cancel=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;// Resetea el espaciamiento seleccionado
If io_pasado = Graph! Then
	igr_parm.spacing = ii_espaciamiento_original
Elseif io_pasado = Datawindow! Then
	idw_parm.Object.gr_1.spacing= string(ii_espaciamiento_original)
End If

Close (parent)
end event

type cb_aceptar from commandbutton within w_seleccionar_espaciamiento_grafica
int X=211
int Y=245
int Width=266
int Height=97
int TabOrder=30
string Text="&Aceptar"
boolean Default=true
int TextSize=-9
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close (parent) 
end event

