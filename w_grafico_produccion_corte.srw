HA$PBExportHeader$w_grafico_produccion_corte.srw
forward
global type w_grafico_produccion_corte from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_grafico_produccion_corte
end type
type cb_recuperar from commandbutton within w_grafico_produccion_corte
end type
end forward

global type w_grafico_produccion_corte from w_preview_de_impresion
integer width = 2976
integer height = 1968
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_grafico_produccion_corte w_grafico_produccion_corte

on w_grafico_produccion_corte.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_grafico_produccion_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

event open;//TRANSACTION			itr_tela
//
//itr_tela 				= 	Create Transaction
//itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
//itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
//itr_tela.USERID		=	SQLCA.USERID
//itr_tela.DBPASS		=	SQLCA.DBPASS
//itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
//itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
//itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")
//
//CONNECT USING itr_tela;
//IF itr_tela.SQLCODE = -1 THEN
//   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
//   Return
//END IF

dw_reporte.settransobject(sqlca)
dw_criterio.SetTransObject(sqlca)
dw_criterio.InsertRow(0)
dw_criterio.SetItem(1,'fechaini',Today())
dw_criterio.SetItem(1,'fechafin',Today())
dw_criterio.SetFocus()

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")




end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_grafico_produccion_corte
integer x = 37
integer y = 156
string dataobject = "dtb_inventario_etapa_grafico"
end type

event dw_reporte::doubleclicked;call super::doubleclicked;Date ld_fecha
s_base_parametros lstr_parametros

This.AcceptText()

ld_fecha = This.GetItemDate(row,'fecha')

lstr_parametros.fecha[1] = ld_fecha
lstr_parametros.cadena[1] = 'SI'

OpenSheetWithParm(w_reporte_movimiento_resumido,lstr_parametros,w_reporte_movimiento_etapa,0,Original!)
end event

type dw_criterio from datawindow within w_grafico_produccion_corte
integer x = 37
integer y = 28
integer width = 2025
integer height = 72
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_parametro_produccion_corte"
boolean border = false
boolean livescroll = true
end type

type cb_recuperar from commandbutton within w_grafico_produccion_corte
integer x = 2235
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

event clicked;Datetime ld_fechaini,ld_fechafin
Long ll_ordencorte
//TRANSACTION		itr_tela


dw_criterio.AcceptText()

ld_fechaini = dw_criterio.GetItemDatetime(1,'fechaini')
ld_fechafin = dw_criterio.GetItemDatetime(1,'fechafin')


dw_reporte.Retrieve(ld_fechaini,ld_fechafin)

//DISCONNECT USING itr_tela ;
//IF itr_tela.SQLCODE = -1 THEN
//   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
//   Return
//END IF
end event

