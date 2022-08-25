HA$PBExportHeader$w_pendientes_x_programar.srw
forward
global type w_pendientes_x_programar from window
end type
type cb_cancelar from commandbutton within w_pendientes_x_programar
end type
type cb_aceptar from commandbutton within w_pendientes_x_programar
end type
type dw_reporte from datawindow within w_pendientes_x_programar
end type
end forward

global type w_pendientes_x_programar from window
integer width = 3154
integer height = 1552
boolean titlebar = true
string title = "Untitled"
windowtype windowtype = response!
long backcolor = 67108864
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_reporte dw_reporte
end type
global w_pendientes_x_programar w_pendientes_x_programar

type variables
Long sw_marca, ii_fabrica, ii_planta, ii_simulacion
end variables

on w_pendientes_x_programar.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_reporte=create dw_reporte
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_reporte}
end on

on w_pendientes_x_programar.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_reporte)
end on

event open;TRANSACTION			itr_tela
Environment le_even
n_cts_constantes luo_constantes
Long li_fabrica, li_planta, li_simulacion

IF GetEnvironment ( le_even ) <> 1 THEN 
ELSE
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
END IF

itr_tela 				= Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_reporte.SetTransObject(itr_tela)

luo_constantes = Create n_cts_constantes

li_fabrica = luo_constantes.of_consultar_numerico("FABRICA PLANTA")
IF li_fabrica = -1 THEN
	Return
END IF

li_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACION")
IF li_planta = -1 THEN
	Return
END IF

li_simulacion = luo_constantes.of_consultar_numerico("SIMULACION")
IF li_simulacion = -1 THEN
	Return
END IF

dw_reporte.Retrieve(li_fabrica, li_planta, li_simulacion)

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF






end event

type cb_cancelar from commandbutton within w_pendientes_x_programar
integer x = 1627
integer y = 1284
integer width = 293
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = 'N'
CloseWithReturn(Parent, lstr_parametros)
end event

type cb_aceptar from commandbutton within w_pendientes_x_programar
integer x = 1115
integer y = 1284
integer width = 293
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_reporte.GetRow()

lstr_parametros.entero[1] = dw_reporte.GetItemNumber(ll_fila,'cs_asignacion')
lstr_parametros.cadena[1] = 'S'
sw_marca = 1
CloseWithReturn(Parent, lstr_parametros)
end event

type dw_reporte from datawindow within w_pendientes_x_programar
integer x = 37
integer y = 32
integer width = 3063
integer height = 1180
integer taborder = 10
string title = "none"
string dataobject = "dtb_pendientes_x_programar"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_reporte.selectRow(0,False)
dw_reporte.SelectRow(row,True)
end event

event doubleclicked;If Row <= 0 Then Return

cb_aceptar.TriggerEvent(Clicked!)
end event

