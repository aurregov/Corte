HA$PBExportHeader$w_reporte_etapas_datos_resumidos.srw
forward
global type w_reporte_etapas_datos_resumidos from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_etapas_datos_resumidos
end type
type cb_recuperar from commandbutton within w_reporte_etapas_datos_resumidos
end type
end forward

global type w_reporte_etapas_datos_resumidos from w_preview_de_impresion
integer width = 2976
integer height = 1984
dw_criterio dw_criterio
cb_recuperar cb_recuperar
end type
global w_reporte_etapas_datos_resumidos w_reporte_etapas_datos_resumidos

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
dw_criterio.SetItem(1,'etapa',0)
dw_criterio.SetItem(1,'orden_corte',0)
dw_criterio.SetItem(1,'area',0)
dw_criterio.SetItem(1,'fecha',Today())
dw_criterio.SetFocus()

lstr_parametros=message.powerObjectparm

//If lstr_parametros.cadena[1] = 'SI' Then
//	dw_reporte.Retrieve(lstr_parametros.cadena[2],lstr_parametros.entero[1],0,0)
//	dw_reporte.SetItem(1,'area',lstr_parametros.entero[1])
//End if
//
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

on w_reporte_etapas_datos_resumidos.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_recuperar=create cb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_recuperar
end on

on w_reporte_etapas_datos_resumidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_recuperar)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_etapas_datos_resumidos
integer y = 128
string dataobject = "dtb_inventarioxetapas_revisado_sin_etapa"
end type

type dw_criterio from datawindow within w_reporte_etapas_datos_resumidos
integer x = 14
integer y = 16
integer width = 2363
integer height = 72
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_criterio_etapas_datos_resumidos"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_area,li_etapa
String ls_area,ls_etapa

This.AcceptText()

choose case GetColumnName()
	case 'area'
		li_area = This.GetItemNumber(1,'area')
		If isnull(li_area) Then
		Else
			select de_tipo_etapa
			into :ls_area
			from m_tipos_etapa
			where co_tipo_etapa = :li_area;
			
			If sqlca.sqlcode = -1 Then
				MessageBox('Error de Base de Datos','Ocurrio un problema al momento de consultar el area')
				Return
			End if
			
			This.SetItem(1,'de_area',ls_area)
		End if

	case 'etapa'
		li_etapa = This.GetItemNumber(1,'etapa')
		If isnull(li_etapa) Then
		Else
			select de_etapa
			into :ls_etapa
			from m_etapas
			where co_etapa = :li_etapa;
			
			If sqlca.sqlcode = -1 Then
				MessageBox('Error de Base de Datos','Ocurrio un problema al momento de consultar la etapa')
				Return
			End if
			
			This.SetItem(1,'de_etapa',ls_etapa)
		End if
		
end choose

end event

type cb_recuperar from commandbutton within w_reporte_etapas_datos_resumidos
integer x = 2505
integer y = 16
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

event clicked;String ls_fecha
Long li_area,li_etapa
Long ll_ordencorte
date ld_fecha
DateTime ldt_fecha
TRANSACTION		itr_tela


dw_criterio.AcceptText()

ld_fecha = dw_criterio.GetItemDate(1,'fecha')
li_area = dw_criterio.GetItemNumber(1,'area')
li_etapa = dw_criterio.GetItemNumber(1,'etapa')
ll_ordencorte = dw_criterio.GetItemNumber(1,'orden_corte')

ls_fecha = String(Year(ld_fecha))+'-'+String(Month(ld_fecha)) + '-' + '01'

ldt_fecha = DateTime(Date(ls_fecha), Time("00:00:00"))

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

dw_reporte.Retrieve(ldt_fecha,li_area,li_etapa,ll_ordencorte)


DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

