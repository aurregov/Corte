HA$PBExportHeader$w_base_hoja_dwgrafica.srw
forward
global type w_base_hoja_dwgrafica from Window
end type
type dw_1 from datawindow within w_base_hoja_dwgrafica
end type
end forward

global type w_base_hoja_dwgrafica from Window
int X=23
int Y=52
int Width=2871
int Height=1892
boolean TitleBar=true
string Title=" "
string MenuName="m_base_graficas"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_tipografica pbm_custom01
event ue_colorgrafica pbm_custom02
event ue_titulografica pbm_custom03
event ue_espaciamientografica pbm_custom04
event ue_imprimir pbm_custom05
event ue_paganterior pbm_custom06
event ue_pagsiguiente pbm_custom07
event ue_preliminar pbm_custom08
event ue_regleta pbm_custom09
event ue_zoom pbm_custom10
dw_1 dw_1
end type
global w_base_hoja_dwgrafica w_base_hoja_dwgrafica

type variables
Long ii_ancho, ii_alto, ii_posx, ii_posy
String is_zoom
end variables

event ue_tipografica;OpenWithParm (w_seleccionar_tipo_grafica, dw_1)

end event

event ue_colorgrafica;OpenWithParm (w_seleccionar_color_grafica, dw_1)
end event

event ue_titulografica;OpenWithParm (w_seleccionar_titulo_grafica, dw_1)



end event

event ue_espaciamientografica;OpenWithParm (w_seleccionar_espaciamiento_grafica, dw_1)


end event

event ue_imprimir;dw_1.setFocus()
OpenWithParm(w_opciones_impresion, dw_1)
end event

event ue_paganterior;dw_1.scrollPriorpage()
end event

event ue_pagsiguiente;dw_1.scrollNextpage()

end event

event ue_preliminar;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_1.Describe("DataWindow.Print.Preview")
if ls_resultado <> 'yes' then
	dw_1.Modify("DataWindow.Print.Preview=Yes")
	dw_1.Modify("DataWindow.Print.Preview.Rulers=Yes")
else
	dw_1.Modify("DataWindow.Print.Preview.Rulers=No")
	dw_1.Modify("DataWindow.Print.Preview.Zoom="+is_zoom)	
	dw_1.Modify("DataWindow.Print.Preview=No")
end if

SetPointer(Arrow!)
end event

event ue_regleta;SetPointer(HourGlass!)
String ls_resultado

ls_resultado = dw_1.Describe("DataWindow.Print.Preview")
IF ls_resultado <> 'yes' then
	dw_1.Modify("DataWindow.Print.Preview.Rulers=No")
ELSE
	ls_resultado = dw_1.Describe("DataWindow.Print.Preview.Rulers")
	IF ls_resultado <> 'yes' THEN
		dw_1.Modify("DataWindow.Print.Preview.Rulers=Yes")
	ELSE
		dw_1.Modify("DataWindow.Print.Preview.Rulers=No")
	END IF
END IF

SetPointer(Arrow!)

end event

event ue_zoom;SetPointer(Arrow!)

string dato

dato = "0"
openwithparm(w_zoom, dato)
dato = message.StringParm
dw_1.Modify("DataWindow.Print.Preview.Zoom="+dato)
SetPointer(Arrow!)


end event

event open;SetTransObject (dw_1, sqlca)
Retrieve (dw_1)


end event

on w_base_hoja_dwgrafica.create
if this.MenuName = "m_base_graficas" then this.MenuID = create m_base_graficas
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_base_hoja_dwgrafica.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event resize;dw_1.Resize(This.Width - 100, This.Height - 200)
end event

type dw_1 from datawindow within w_base_hoja_dwgrafica
int X=37
int Y=32
int Width=2656
int Height=1412
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
end type

