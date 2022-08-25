HA$PBExportHeader$w_validar_loteo.srw
forward
global type w_validar_loteo from window
end type
type st_1 from statictext within w_validar_loteo
end type
type cb_cancelar from commandbutton within w_validar_loteo
end type
type cb_aceptar from commandbutton within w_validar_loteo
end type
type dw_lista from datawindow within w_validar_loteo
end type
end forward

global type w_validar_loteo from window
integer width = 2286
integer height = 2632
boolean titlebar = true
string title = "Bongos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_lista dw_lista
end type
global w_validar_loteo w_validar_loteo

forward prototypes
public function long wf_leerconstantes (readonly string as_constante, readonly string as_error)
public function long wf_leerconstantescorte (readonly string as_constante, readonly string as_error)
end prototypes

public function long wf_leerconstantes (readonly string as_constante, readonly string as_error);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : wf_leerConstantes
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes 	luo_constantes

luo_constantes = Create n_cts_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

public function long wf_leerconstantescorte (readonly string as_constante, readonly string as_error);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : wf_leerConstantesCorte
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes_corte 	luo_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

on w_validar_loteo.create
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_lista=create dw_lista
this.Control[]={this.st_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.dw_lista}
end on

on w_validar_loteo.destroy
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_lista)
end on

event open;String ls_bongo,ls_po, ls_loteo_max
Long ll_inicio, ll_fin, ll_ordencorte, ll_referencia, ll_duo,ll_tipoPdto,ll_centro_pdn
Long li_tiempo, li_fabrica, li_linea, li_loteoConf
s_base_parametros lstr_parametros
n_cst_orden_corte luo_corte

This.Center = True

dw_lista.SetTransObject(sqlca)

lstr_parametros = message.PowerObjectParm	

ls_bongo 		= lstr_parametros.cadena[1] 
ll_inicio 		= lstr_parametros.entero[1] 
ll_fin 			= lstr_parametros.entero[2] 
ll_ordencorte 	= lstr_parametros.entero[3] 
ls_po 			= lstr_parametros.cadena[2] 
li_tiempo		= lstr_parametros.entero[4]
li_fabrica		= lstr_parametros.entero[5]
li_linea			= lstr_parametros.entero[6]
ll_referencia	= lstr_parametros.entero[7]
ls_loteo_max   = lstr_parametros.cadena[3]

//timer(10)
Timer( 180 ) // FACL - 2021/08/13 - ID530 - Se vuelve a activar Timer a 180 segundos

//se establece si la OC hace parte de un duo o conjunto
ll_duo = luo_corte.of_duo_conjunto(ll_ordencorte)
//SA53802 - Ceiba/JJ - 29-10-2015 Valores por defecto para buscar en los est$$HEX1$$e100$$ENDHEX$$ndares de la referencia y procesos
ll_tipoPdto		= wf_leerConstantes('TIPO PRENDAS','el tipo de producto.') //SA53802 - Ceiba/JJ - 29-10-2015
ll_centro_pdn	= wf_leerConstantes('CONFECCION','el centro de confecci$$HEX1$$f300$$ENDHEX$$n') //SA53802 - Ceiba/JJ - 29-10-2015
li_loteoConf 	= wf_leerConstantescorte('MENS_LOTEO_CONF','la configuraci$$HEX1$$f300$$ENDHEX$$n del loteo.') //SA53802 - Ceiba/JJ - 29-10-2015
	
IF ll_duo <= 0 THEN
	//no es un duo
	dw_lista.Retrieve(ls_bongo,ll_inicio,ll_fin,ll_ordencorte,ls_po,li_tiempo, li_fabrica, li_linea, ll_referencia,ls_loteo_max,ll_tipoPdto,ll_centro_pdn,li_loteoConf)
ELSE
	//se trata de un duo se deben traer todos los bongos que lo componen
	dw_lista.DataObject = 'dtb_adhesivos_bongo_new_duo'
	dw_lista.SetTransObject(sqlca)
	dw_lista.Retrieve(ls_bongo,ll_inicio,ll_fin,ll_duo,ls_po,li_tiempo, li_fabrica, li_linea, ll_referencia,ls_loteo_max,ll_ordencorte,ll_tipoPdto,ll_centro_pdn,li_loteoConf)
END IF
end event

event timer;//s_base_parametros lstr_parametros
//
////OpenWithParm(w_opciones_impresion, dw_lista)
//dw_lista.Print()
//
//lstr_parametros.hay_parametros = True
//CloseWithReturn(This,lstr_parametros)
//


// FACL - 2021/08/13 - ID530 - Se invoca el clic de aceptar
cb_cancelar.Event Clicked()
// cb_aceptar.Event Clicked()

end event

type st_1 from statictext within w_validar_loteo
integer x = 37
integer y = 2464
integer width = 1490
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Esta Ventana se cierrra automaticamente a los 180 seg. de abierta."
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_validar_loteo
integer x = 1184
integer y = 2288
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type cb_aceptar from commandbutton within w_validar_loteo
integer x = 626
integer y = 2288
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;s_base_parametros lstr_parametros

//OpenWithParm(w_opciones_impresion, dw_lista)
PrintSetup()
dw_lista.Print()

lstr_parametros.hay_parametros = True
CloseWithReturn(parent,lstr_parametros)
end event

type dw_lista from datawindow within w_validar_loteo
integer x = 27
integer y = 20
integer width = 2190
integer height = 2164
integer taborder = 10
string title = "none"
string dataobject = "dtb_adhesivos_bongo_new_colores"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event sqlpreview;string ls
ls = SQLSyntax
end event

