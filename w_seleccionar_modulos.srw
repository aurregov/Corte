HA$PBExportHeader$w_seleccionar_modulos.srw
forward
global type w_seleccionar_modulos from w_base_buscar_lista_parametro
end type
type st_3 from statictext within w_seleccionar_modulos
end type
type sle_unidades_a_partir from singlelineedit within w_seleccionar_modulos
end type
type cbx_cambiar_modulo from checkbox within w_seleccionar_modulos
end type
end forward

global type w_seleccionar_modulos from w_base_buscar_lista_parametro
int Width=2455
int Height=1468
st_3 st_3
sle_unidades_a_partir sle_unidades_a_partir
cbx_cambiar_modulo cbx_cambiar_modulo
end type
global w_seleccionar_modulos w_seleccionar_modulos

type variables
Long ii_co_fabrica_modu,ii_co_planta_modu
Long ii_co_modulo
LONG       il_ca_unidades
end variables

on w_seleccionar_modulos.create
int iCurrent
call super::create
this.st_3=create st_3
this.sle_unidades_a_partir=create sle_unidades_a_partir
this.cbx_cambiar_modulo=create cbx_cambiar_modulo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.sle_unidades_a_partir
this.Control[iCurrent+3]=this.cbx_cambiar_modulo
end on

on w_seleccionar_modulos.destroy
call super::destroy
destroy(this.st_3)
destroy(this.sle_unidades_a_partir)
destroy(this.cbx_cambiar_modulo)
end on

event open;Long				li_co_fabrica_modu,li_co_planta_modu,li_co_modulo
LONG 					ll_numero_registros
s_base_parametros	lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
END IF
dw_lista.modify("dw_lista.readonly=yes")




IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	IF lstr_parametros.hay_parametros THEN
		ii_co_fabrica_modu		=lstr_parametros.entero[1]			
		ii_co_planta_modu			=lstr_parametros.entero[2]						
		ii_co_modulo				=lstr_parametros.entero[3]		
		il_ca_unidades				=lstr_parametros.entero[4]		
		sle_unidades_a_partir.TEXT=String(il_ca_unidades)
	ELSE
		MessageBox("Error","No trajo par$$HEX1$$e100$$ENDHEX$$metros para partir")
	END IF
END IF


end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_seleccionar_modulos
int X=1280
int Y=44
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_seleccionar_modulos
int X=1477
int Y=44
string Mask=""
end type

event em_dato::modified;String ls_datocon
Long ll_numero_registros


ls_datocon = em_dato.Text
IF cbx_cambiar_modulo.checked THEN
	IF ISNULL(ls_datocon) THEN
		MessageBox("Advertencia","Se indic$$HEX2$$f3002000$$ENDHEX$$cambio de M$$HEX1$$f300$$ENDHEX$$dulo, pero no se especific$$HEX1$$f300$$ENDHEX$$")
	ELSE
	END IF
ELSE
END IF

IF Not IsNull(ls_datocon) THEN
	ls_datocon = ls_datocon + '%'
	ll_numero_registros = dw_lista.Retrieve(ls_datocon)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			dw_lista.setrow(1)
			dw_lista.selectrow(1,true)
			il_fila_actual = 1
	END CHOOSE
END IF
end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_seleccionar_modulos
int X=613
int Y=1092
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_seleccionar_modulos
int X=1211
int Y=1212
int TabOrder=40
end type

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_seleccionar_modulos
int X=654
int Y=1212
int TabOrder=30
end type

event pb_aceptar::clicked;call super::clicked;LONG					ll_ca_a_sacar,ll_ca_a_partir
s_base_parametros lstr_parametros

ll_ca_a_partir		=	LONG(sle_unidades_a_partir.text)

//ll_ca_a_sacar		=	LONG(sle_unidades_a_sacar.text)

//IF ISNULL(ll_ca_a_sacar) THEN
//	ll_ca_a_sacar=0
//ELSE
//END IF
//
//IF ll_ca_a_sacar > ll_ca_a_partir THEN
//	MessageBox("Error datos","Las unidades a sacar no pueden ser mayores que las unidades a partir")
//	lstr_parametros.hay_parametros = FALSE
//	CloseWithReturn(parent,lstr_parametros)
//ELSE
//END IF

IF cbx_cambiar_modulo.checked THEN
	IF il_fila_actual > 0 THEN
		lstr_parametros.hay_parametros = TRUE
		lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
		lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"co_planta")
		lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_modulo")
//		lstr_parametros.entero[4]=ll_ca_a_sacar
		lstr_parametros.entero[5]=1
		closewithreturn(parent,lstr_parametros)
	ELSE
		MessageBox("Advertencia","Est$$HEX2$$e1002000$$ENDHEX$$indicando cambiar m$$HEX1$$f300$$ENDHEX$$dulo pero no ha especificado el destino")
		lstr_parametros.hay_parametros = FALSE
		CloseWithReturn(parent,lstr_parametros)
	END IF
ELSE
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=0
	lstr_parametros.entero[2]=0
	lstr_parametros.entero[3]=0
//	lstr_parametros.entero[4]=ll_ca_a_sacar	
	lstr_parametros.entero[5]=0
	closewithreturn(parent,lstr_parametros)
END IF






end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_seleccionar_modulos
int Width=2395
int Height=908
string DataObject="dtb_modulos"
end type

type st_3 from statictext within w_seleccionar_modulos
int X=69
int Y=1104
int Width=375
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Unidades a partir"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_unidades_a_partir from singlelineedit within w_seleccionar_modulos
int X=91
int Y=1176
int Width=343
int Height=92
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cbx_cambiar_modulo from checkbox within w_seleccionar_modulos
int X=800
int Y=40
int Width=430
int Height=76
boolean BringToTop=true
string Text="Cambiar M$$HEX1$$f300$$ENDHEX$$dulo "
BorderStyle BorderStyle=StyleLowered!
boolean LeftText=true
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

