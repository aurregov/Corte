HA$PBExportHeader$w_opciones_impresion.srw
forward
global type w_opciones_impresion from Window
end type
type pb_cancelar from picturebutton within w_opciones_impresion
end type
type pb_aceptar from picturebutton within w_opciones_impresion
end type
type ddlb_1 from dropdownlistbox within w_opciones_impresion
end type
type st_1 from statictext within w_opciones_impresion
end type
type st_donde from statictext within w_opciones_impresion
end type
type st_comentarios from statictext within w_opciones_impresion
end type
type st_t_comentarios from statictext within w_opciones_impresion
end type
type st_t_donde from statictext within w_opciones_impresion
end type
type st_tipo from statictext within w_opciones_impresion
end type
type st_t_tipo from statictext within w_opciones_impresion
end type
type st_estado from statictext within w_opciones_impresion
end type
type st_t_estado from statictext within w_opciones_impresion
end type
type p_si_inter from picture within w_opciones_impresion
end type
type st_impresora from statictext within w_opciones_impresion
end type
type cbx_intercalar from checkbox within w_opciones_impresion
end type
type ddlb_imp_solo from dropdownlistbox within w_opciones_impresion
end type
type st_imp_solo from statictext within w_opciones_impresion
end type
type st_explicacion from statictext within w_opciones_impresion
end type
type sle_paginas from singlelineedit within w_opciones_impresion
end type
type rb_paginas from radiobutton within w_opciones_impresion
end type
type rb_currentpage from radiobutton within w_opciones_impresion
end type
type st_copias from statictext within w_opciones_impresion
end type
type st_t_impresora from statictext within w_opciones_impresion
end type
type rb_seleccion from radiobutton within w_opciones_impresion
end type
type rb_todo from radiobutton within w_opciones_impresion
end type
type em_copias from editmask within w_opciones_impresion
end type
type cbx_archivo from checkbox within w_opciones_impresion
end type
type p_no_inter from picture within w_opciones_impresion
end type
type cb_impresora from commandbutton within w_opciones_impresion
end type
type gb_impresora from groupbox within w_opciones_impresion
end type
type gb_intervalo from groupbox within w_opciones_impresion
end type
type gb_copias from groupbox within w_opciones_impresion
end type
end forward

global type w_opciones_impresion from Window
int X=352
int Y=392
int Width=2350
int Height=1468
boolean TitleBar=true
string Title="Imprimir..."
long BackColor=81576884
WindowType WindowType=popup!
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
ddlb_1 ddlb_1
st_1 st_1
st_donde st_donde
st_comentarios st_comentarios
st_t_comentarios st_t_comentarios
st_t_donde st_t_donde
st_tipo st_tipo
st_t_tipo st_t_tipo
st_estado st_estado
st_t_estado st_t_estado
p_si_inter p_si_inter
st_impresora st_impresora
cbx_intercalar cbx_intercalar
ddlb_imp_solo ddlb_imp_solo
st_imp_solo st_imp_solo
st_explicacion st_explicacion
sle_paginas sle_paginas
rb_paginas rb_paginas
rb_currentpage rb_currentpage
st_copias st_copias
st_t_impresora st_t_impresora
rb_seleccion rb_seleccion
rb_todo rb_todo
em_copias em_copias
cbx_archivo cbx_archivo
p_no_inter p_no_inter
cb_impresora cb_impresora
gb_impresora gb_impresora
gb_intervalo gb_intervalo
gb_copias gb_copias
end type
global w_opciones_impresion w_opciones_impresion

type variables
datawindow dwc_toprint

end variables

event open;string s
int i  
environment env

if GetEnvironment(env) = 1 then
	this.x=(PixelsToUnits(env.ScreenWidth, XPixelsToUnits!) - this.Width)/2
	this.y=(PixelsToUnits(env.ScreenHeight, YPixelsToUnits!) - this.height)/2
end if

dwc_toprint = message.PowerObjectParm
rb_currentpage.enabled = Upper(dwc_toprint.describe("DataWindow.Print.Preview")) = Upper("Yes")

//s=ProfileString("win.ini","Windows","device", "Impresora por defecto,,")
//st_impresora.text = Left(s,Pos(s,",")-1)+" en "+ right(s,Len(s)-Pos(s,",",Pos(s,",")+1))

st_impresora.text = dwc_toprint.describe('datawindow.printer')

if Long(dwc_toprint.describe("DataWindow.Print.Copies"))=0 then
	dwc_toprint.Modify("DataWindow.Print.Copies=1")
end if
cbx_archivo.Checked = dwc_toprint.describe("DataWindow.Print.FileName") <> ""
cbx_intercalar.Checked = (dwc_toprint.describe("DataWindow.Print.Collate") = "yes")
cbx_intercalar.TriggerEvent(Clicked!)
s = dwc_toprint.describe("DataWindow.Print.Page.Range") 
if s = "" then
	rb_paginas.Checked=False
	rb_todo.Checked=True
else
	rb_todo.Checked=False
	rb_paginas.Checked=True
end if
sle_paginas.text=dwc_toprint.describe("DataWindow.Print.Page.Range")
i=Long(dwc_toprint.describe("DataWindow.Print.Page.RangeInclude"))
CHOOSE CASE i
	CASE 0
		ddlb_imp_solo.text = "El intervalo"
	CASE 1
		ddlb_imp_solo.text = "P$$HEX1$$e100$$ENDHEX$$ginas pares"
	CASE 2
		ddlb_imp_solo.text = "P$$HEX1$$e100$$ENDHEX$$ginas impares"
END CHOOSE
em_copias.text = dwc_toprint.describe("DataWindow.Print.Copies")

end event

on w_opciones_impresion.create
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.st_donde=create st_donde
this.st_comentarios=create st_comentarios
this.st_t_comentarios=create st_t_comentarios
this.st_t_donde=create st_t_donde
this.st_tipo=create st_tipo
this.st_t_tipo=create st_t_tipo
this.st_estado=create st_estado
this.st_t_estado=create st_t_estado
this.p_si_inter=create p_si_inter
this.st_impresora=create st_impresora
this.cbx_intercalar=create cbx_intercalar
this.ddlb_imp_solo=create ddlb_imp_solo
this.st_imp_solo=create st_imp_solo
this.st_explicacion=create st_explicacion
this.sle_paginas=create sle_paginas
this.rb_paginas=create rb_paginas
this.rb_currentpage=create rb_currentpage
this.st_copias=create st_copias
this.st_t_impresora=create st_t_impresora
this.rb_seleccion=create rb_seleccion
this.rb_todo=create rb_todo
this.em_copias=create em_copias
this.cbx_archivo=create cbx_archivo
this.p_no_inter=create p_no_inter
this.cb_impresora=create cb_impresora
this.gb_impresora=create gb_impresora
this.gb_intervalo=create gb_intervalo
this.gb_copias=create gb_copias
this.Control[]={this.pb_cancelar,&
this.pb_aceptar,&
this.ddlb_1,&
this.st_1,&
this.st_donde,&
this.st_comentarios,&
this.st_t_comentarios,&
this.st_t_donde,&
this.st_tipo,&
this.st_t_tipo,&
this.st_estado,&
this.st_t_estado,&
this.p_si_inter,&
this.st_impresora,&
this.cbx_intercalar,&
this.ddlb_imp_solo,&
this.st_imp_solo,&
this.st_explicacion,&
this.sle_paginas,&
this.rb_paginas,&
this.rb_currentpage,&
this.st_copias,&
this.st_t_impresora,&
this.rb_seleccion,&
this.rb_todo,&
this.em_copias,&
this.cbx_archivo,&
this.p_no_inter,&
this.cb_impresora,&
this.gb_impresora,&
this.gb_intervalo,&
this.gb_copias}
end on

on w_opciones_impresion.destroy
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.st_donde)
destroy(this.st_comentarios)
destroy(this.st_t_comentarios)
destroy(this.st_t_donde)
destroy(this.st_tipo)
destroy(this.st_t_tipo)
destroy(this.st_estado)
destroy(this.st_t_estado)
destroy(this.p_si_inter)
destroy(this.st_impresora)
destroy(this.cbx_intercalar)
destroy(this.ddlb_imp_solo)
destroy(this.st_imp_solo)
destroy(this.st_explicacion)
destroy(this.sle_paginas)
destroy(this.rb_paginas)
destroy(this.rb_currentpage)
destroy(this.st_copias)
destroy(this.st_t_impresora)
destroy(this.rb_seleccion)
destroy(this.rb_todo)
destroy(this.em_copias)
destroy(this.cbx_archivo)
destroy(this.p_no_inter)
destroy(this.cb_impresora)
destroy(this.gb_impresora)
destroy(this.gb_intervalo)
destroy(this.gb_copias)
end on

type pb_cancelar from picturebutton within w_opciones_impresion
int X=1915
int Y=1188
int Width=393
int Height=124
int TabOrder=10
string Text="&Cancelar"
string PictureName="c:\graficos\cancelar.bmp"
Alignment HTextAlign=Right!
boolean Cancel=true
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dwc_toprint.Modify("DataWindow.Print.Page.Range=''")		
CloseWithReturn(Parent, -1)
Close(Parent)
end event

type pb_aceptar from picturebutton within w_opciones_impresion
int X=1472
int Y=1188
int Width=393
int Height=124
int TabOrder=20
string Text="&Aceptar"
string PictureName="c:\graficos\ok.bmp"
Alignment HTextAlign=Right!
boolean Default=true
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;int li_valor
string ls_fullfilename, ls_filename

if cbx_archivo.checked then
	if dwc_toprint.describe("DataWindow.Print.Filename") = "" then
		li_Valor= GetFileSaveName("Imprimir a un archivo", ls_fullfilename, ls_filename ,"PRN", "Archivos de impresi$$HEX1$$f300$$ENDHEX$$n, *.PRN, Todos los archivos, *.*")
		IF li_Valor = 1 THEN
			dwc_toprint.Modify("DataWindow.Print.Filename='"+ls_filename+"'")
		END IF
	end if
	if dwc_toprint.describe("DataWindow.Print.Filename") <> "" then
		Hide(Parent)
		dwc_toprint.Print()
		dwc_toprint.Modify("DataWindow.Print.Page.Range=''")		
		Close(Parent)
	end if
else
	dwc_toprint.Modify("DataWindow.Print.Filename=''")
	Hide(Parent)
	dwc_toprint.Print()
	dwc_toprint.Modify("DataWindow.Print.Page.Range=''")
	Close(Parent)
end if



end event

type ddlb_1 from dropdownlistbox within w_opciones_impresion
int X=306
int Y=1048
int Width=832
int Height=232
int TabOrder=120
boolean Visible=false
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long TextColor=33554432
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_opciones_impresion
int X=55
int Y=1056
int Width=210
int Height=68
boolean Visible=false
boolean Enabled=false
string Text="&Imprimir:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_donde from statictext within w_opciones_impresion
int X=434
int Y=352
int Width=928
int Height=56
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_comentarios from statictext within w_opciones_impresion
int X=434
int Y=416
int Width=928
int Height=56
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_t_comentarios from statictext within w_opciones_impresion
int X=91
int Y=416
int Width=288
int Height=56
boolean Enabled=false
string Text="Comentarios:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_t_donde from statictext within w_opciones_impresion
int X=91
int Y=352
int Width=169
int Height=56
boolean Enabled=false
string Text="D$$HEX1$$f300$$ENDHEX$$nde:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_tipo from statictext within w_opciones_impresion
int X=434
int Y=288
int Width=928
int Height=56
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_t_tipo from statictext within w_opciones_impresion
int X=91
int Y=288
int Width=119
int Height=56
boolean Enabled=false
string Text="Tipo:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_estado from statictext within w_opciones_impresion
int X=434
int Y=224
int Width=928
int Height=60
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_t_estado from statictext within w_opciones_impresion
int X=91
int Y=224
int Width=160
int Height=56
boolean Enabled=false
string Text="Estado"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_si_inter from picture within w_opciones_impresion
int X=1211
int Y=712
int Width=530
int Height=232
string PictureName="c:\graficos\si_inter.bmp"
boolean FocusRectangle=false
boolean OriginalSize=true
end type

type st_impresora from statictext within w_opciones_impresion
int X=430
int Y=120
int Width=1303
int Height=88
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
boolean FocusRectangle=false
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cbx_intercalar from checkbox within w_opciones_impresion
int X=1787
int Y=756
int Width=297
int Height=80
int TabOrder=110
string Text="Int&ercalar"
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;if checked then
	dwc_toprint.Modify("DataWindow.Print.Collate=yes")
	p_si_inter.BringToTop = TRUE
else
	dwc_toprint.Modify("DataWindow.Print.Collate=no")
	p_no_inter.BringToTop = TRUE
end if
end event

type ddlb_imp_solo from dropdownlistbox within w_opciones_impresion
int X=1522
int Y=1048
int Width=782
int Height=308
int TabOrder=130
string Text=" "
BorderStyle BorderStyle=StyleLowered!
boolean Sorted=false
boolean VScrollBar=true
int Accelerator=114
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
string Item[]={"El intervalo",&
"P$$HEX1$$e100$$ENDHEX$$ginas pares",&
"P$$HEX1$$e100$$ENDHEX$$ginas impares"}
end type

on selectionchanged;int i

CHOOSE CASE ddlb_imp_solo.text
	CASE "El intervalo"
		i= 0
	CASE "P$$HEX1$$e100$$ENDHEX$$ginas pares"
		i= 1
	CASE "P$$HEX1$$e100$$ENDHEX$$ginas impares"
		i= 2
END CHOOSE
dwc_toprint.Modify("DataWindow.Print.Page.RangeInclude="+String(i))

end on

type st_imp_solo from statictext within w_opciones_impresion
int X=1175
int Y=1060
int Width=311
int Height=60
boolean Enabled=false
string Text="Imp&rimir s$$HEX1$$f300$$ENDHEX$$lo:"
boolean FocusRectangle=false
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_explicacion from statictext within w_opciones_impresion
int X=82
int Y=864
int Width=992
int Height=116
boolean Enabled=false
string Text="Escriba n$$HEX1$$fa00$$ENDHEX$$mros de p$$HEX1$$e100$$ENDHEX$$gina e/o intervalos separados por comas. Ejemplo: 1,3,5-12,14"
boolean FocusRectangle=false
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_paginas from singlelineedit within w_opciones_impresion
int X=416
int Y=756
int Width=686
int Height=80
int TabOrder=90
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
int Accelerator=110
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on modified;dwc_toprint.Modify("DataWindow.Print.Page.Range='"+sle_paginas.text+"'")
if trim(sle_paginas.text) <> "" then
	rb_paginas.Checked = true
end if
end on

type rb_paginas from radiobutton within w_opciones_impresion
int X=82
int Y=764
int Width=283
int Height=72
int TabOrder=80
string Text="P$$HEX1$$e100$$ENDHEX$$gin&as:"
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;dwc_toprint.Modify("DataWindow.Print.Page.Range='"+sle_paginas.text+"'")
sle_paginas.SetFocus()

end on

type rb_currentpage from radiobutton within w_opciones_impresion
int X=87
int Y=684
int Width=393
int Height=68
int TabOrder=60
string Text="P$$HEX1$$e100$$ENDHEX$$gina actua&l"
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;int li_x1,li_x2

li_x1 = Long(dwc_toprint.Describe("DataWindow.FirstRowOnPage"))
li_x2 = Long(dwc_toprint.Describe("DataWindow.LastRowOnPage"))

li_x1 = li_x2/(li_x2 - li_x1 + 1)
dwc_toprint.Modify("DataWindow.Print.Page.Range='"+Trim(string(li_x1))+"'")


end event

type st_copias from statictext within w_opciones_impresion
int X=1216
int Y=620
int Width=443
int Height=60
boolean Enabled=false
string Text="N$$HEX1$$fa00$$ENDHEX$$mero de c&opias:"
boolean FocusRectangle=false
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_t_impresora from statictext within w_opciones_impresion
int X=91
int Y=144
int Width=192
int Height=68
boolean Enabled=false
string Text="Nombre:"
boolean FocusRectangle=false
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rb_seleccion from radiobutton within w_opciones_impresion
int X=631
int Y=680
int Width=283
int Height=72
int TabOrder=70
boolean Enabled=false
string Text="Selecci$$HEX1$$f300$$ENDHEX$$n"
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rb_todo from radiobutton within w_opciones_impresion
int X=82
int Y=604
int Width=219
int Height=64
int TabOrder=50
string Text="&Todo"
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;dwc_toprint.Modify("DataWindow.Print.Page.Range=''")
end on

type em_copias from editmask within w_opciones_impresion
int X=1787
int Y=604
int Width=370
int Height=80
int TabOrder=100
BorderStyle BorderStyle=StyleLowered!
string Mask="###"
boolean AutoSkip=true
boolean Spin=true
double Increment=1
string MinMax="1~~"
int Accelerator=99
string Text="1"
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on modified;dwc_toprint.Modify("DataWindow.Print.Copies="+em_copias.text)
if Long(em_copias.text) > 1 then
	cbx_intercalar.enabled = true
end if
end on

type cbx_archivo from checkbox within w_opciones_impresion
int X=1669
int Y=324
int Width=553
int Height=84
int TabOrder=40
string Text=" I&mprimir a un archivo"
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_no_inter from picture within w_opciones_impresion
int X=1211
int Y=712
int Width=530
int Height=232
boolean BringToTop=true
string PictureName="c:\graficos\no_inter.bmp"
boolean FocusRectangle=false
end type

type cb_impresora from commandbutton within w_opciones_impresion
int X=1815
int Y=120
int Width=398
int Height=88
int TabOrder=30
boolean BringToTop=true
string Text="&Propiedades"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string s

PrintSetUp()
s=ProfileString("win.ini","Windows","device", "Impresora por defecto,,")
st_impresora.text = Left(s,Pos(s,",")-1)+" en "+ right(s,Len(s)-Pos(s,",",Pos(s,",")+1))
//st_impresora.text = dwc_toprint.describe("datawindow.printer")



end event

type gb_impresora from groupbox within w_opciones_impresion
int X=32
int Y=52
int Width=2267
int Height=448
string Text="Impresora"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_intervalo from groupbox within w_opciones_impresion
int X=41
int Y=532
int Width=1093
int Height=468
string Text="Intervalo de p$$HEX1$$e100$$ENDHEX$$ginas"
BorderStyle BorderStyle=StyleLowered!
long BackColor=81576884
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_copias from groupbox within w_opciones_impresion
int X=1175
int Y=532
int Width=1129
int Height=468
string Text="Copias"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

