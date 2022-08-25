HA$PBExportHeader$w_reporte_resumen_inventario_corte.srw
forward
global type w_reporte_resumen_inventario_corte from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_resumen_inventario_corte
end type
type cb_recuperar from commandbutton within w_reporte_resumen_inventario_corte
end type
end forward

global type w_reporte_resumen_inventario_corte from w_preview_de_impresion
integer width = 2985
integer height = 2008
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_reporte_resumen_inventario_corte w_reporte_resumen_inventario_corte

type variables
String is_fecha
end variables

on w_reporte_resumen_inventario_corte.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_reporte_resumen_inventario_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

event open;TRANSACTION			itr_tela
s_base_parametros s_parametros
String ls_nombredw, ls_wparametros



//dw_reporte.DataObject = ls_nombredw
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
dw_criterio.SetFocus()
dw_criterio.SetItem(1,'fecha',Today())

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")



end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_resumen_inventario_corte
integer y = 120
string dataobject = "dtb_inventariosxetapas_generales"
end type

event dw_reporte::doubleclicked;call super::doubleclicked;Long li_area
s_base_parametros lstr_parametros

li_area = This.GetItemNumber(row,'m_tipos_etapa_co_tipo_etapa')

lstr_parametros.cadena[1] = 'SI'
lstr_parametros.cadena[2] = is_fecha

lstr_parametros.entero[1] = li_area


OpenSheetWithParm(w_reporte_etapas_datos_resumidos,lstr_parametros,w_reporte_resumen_inventario_corte,0,Original!)




end event

type dw_criterio from datawindow within w_reporte_resumen_inventario_corte
integer x = 55
integer y = 24
integer width = 553
integer height = 80
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_criterio_inventario_general"
boolean border = false
boolean livescroll = true
end type

type cb_recuperar from commandbutton within w_reporte_resumen_inventario_corte
integer x = 896
integer y = 24
integer width = 343
integer height = 80
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

event clicked;TRANSACTION			itr_tela
Date ld_fecha
String ls_fecha

dw_criterio.AcceptText()

ld_fecha = dw_criterio.GetItemDate(1,'fecha')

ls_fecha = String(Year(ld_fecha))+'-'+String(Month(ld_fecha))
is_fecha = ls_fecha
dw_reporte.Retrieve(ls_fecha)

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

