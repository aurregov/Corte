HA$PBExportHeader$w_liquidados.srw
forward
global type w_liquidados from window
end type
type cb_salir from commandbutton within w_liquidados
end type
type dw_detalle from datawindow within w_liquidados
end type
end forward

global type w_liquidados from window
integer width = 3355
integer height = 1408
boolean titlebar = true
string title = "Ordenes de Corte Liquidades"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_salir cb_salir
dw_detalle dw_detalle
end type
global w_liquidados w_liquidados

on w_liquidados.create
this.cb_salir=create cb_salir
this.dw_detalle=create dw_detalle
this.Control[]={this.cb_salir,&
this.dw_detalle}
end on

on w_liquidados.destroy
destroy(this.cb_salir)
destroy(this.dw_detalle)
end on

event open;Long li_fabrica, li_planta, li_tipoproducto, li_centro, li_tipo, li_estado
n_cts_constantes luo_constantes

This.x = 1
This.y = 1

TRANSACTION		itr_tela

itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_detalle.SetTransObject(itr_tela)

li_fabrica = luo_constantes.of_consultar_numerico("FABRICA")
IF li_fabrica = -1 THEN
	Return
END IF
li_planta = luo_constantes.of_consultar_numerico("PLANTA")
IF li_planta = -1 THEN
	Return
END IF
li_tipoproducto = luo_constantes.of_consultar_numerico("TIPO PRODUCTO")
IF li_tipoproducto = -1 THEN
	Return
END IF
li_centro = luo_constantes.of_consultar_numerico("CENTRO CORTE")
IF li_centro = -1 THEN
	Return
END IF
li_tipo = luo_constantes.of_consultar_numerico("TIPO ASIGNACION")
IF li_tipo = -1 THEN
	Return
END IF
li_estado = luo_constantes.of_consultar_numerico("ESTADO ASIGNACION")
IF li_estado = -1 THEN
	Return
END IF

dw_detalle.Retrieve(li_fabrica, li_planta, li_tipoproducto, li_centro, li_tipo, li_estado)

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF
end event

type cb_salir from commandbutton within w_liquidados
integer x = 1426
integer y = 1148
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cerrar"
end type

event clicked;Close(Parent) 
end event

type dw_detalle from datawindow within w_liquidados
integer x = 14
integer y = 24
integer width = 3291
integer height = 1056
integer taborder = 10
string title = "none"
string dataobject = "dtb_liquidados"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Long ll_find
String ls_expresion
s_base_parametros lst_parametros

Open(w_buscar_agrupaciones_parametros_liquida)

lst_parametros = Message.PowerObjectParm

IF lst_parametros.cadena[1] <> 'NO' THEN
	ls_expresion = "cs_prioridad = " + String(lst_parametros.entero[1]) + " and co_modulo = " +String(lst_parametros.entero[2]) 
	
	ll_find = dw_detalle.Find(ls_expresion,1,dw_detalle.RowCount())
	
	dw_detalle.ScrollToRow(ll_find)
	dw_detalle.SelectRow(ll_find,True)
END IF
end event

