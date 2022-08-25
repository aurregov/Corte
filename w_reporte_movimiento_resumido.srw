HA$PBExportHeader$w_reporte_movimiento_resumido.srw
forward
global type w_reporte_movimiento_resumido from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_movimiento_resumido
end type
type cb_recuperar from commandbutton within w_reporte_movimiento_resumido
end type
end forward

global type w_reporte_movimiento_resumido from w_preview_de_impresion
integer width = 2967
integer height = 1976
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_reporte_movimiento_resumido w_reporte_movimiento_resumido

on w_reporte_movimiento_resumido.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_reporte_movimiento_resumido.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

event open;TRANSACTION			itr_tela
s_base_parametros lstr_parametros

itr_tela 				= 	Create Transaction
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

dw_reporte.settransobject(itr_tela)
dw_criterio.SetTransObject(itr_tela)
dw_criterio.InsertRow(0)
dw_criterio.SetItem(1,'fechaini',Today())
dw_criterio.SetItem(1,'fechafin',Today())
dw_criterio.SetItem(1,'ordencorte',0)


lstr_parametros=message.powerObjectparm

If lstr_parametros.cadena[1] = 'SI' Then
	dw_reporte.Retrieve(lstr_parametros.fecha[1],lstr_parametros.fecha[1],0)
	dw_criterio.SetItem(1,'fechaini',lstr_parametros.fecha[1])
	dw_criterio.SetItem(1,'fechafin',lstr_parametros.fecha[1])
End if

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF


end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_movimiento_resumido
integer x = 14
integer y = 172
string dataobject = "dtb_movimientos_etapas_resumido"
end type

type dw_criterio from datawindow within w_reporte_movimiento_resumido
integer x = 32
integer y = 20
integer width = 1989
integer height = 72
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_parametro_movimiento_etapa"
boolean border = false
boolean livescroll = true
end type

type cb_recuperar from commandbutton within w_reporte_movimiento_resumido
integer x = 2350
integer y = 20
integer width = 343
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
end type

event clicked;Date ld_fechaini,ld_fechafin
Long ll_ordencorte
TRANSACTION			itr_tela

itr_tela 				= 	Create Transaction
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
dw_criterio.SetTransObject(itr_tela)

dw_criterio.AcceptText()

ld_fechaini = dw_criterio.GetItemDate(1,'fechaini')
ld_fechafin = dw_criterio.GetItemDate(1,'fechafin')
ll_ordencorte = dw_criterio.GetItemNUmber(1,'ordencorte')

dw_reporte.Retrieve(ld_fechaini,ld_fechafin,ll_ordencorte)


DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

