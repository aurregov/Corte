HA$PBExportHeader$w_preview_inventario_etapas_estilo.srw
forward
global type w_preview_inventario_etapas_estilo from w_preview_de_impresion
end type
type dw_1 from datawindow within w_preview_inventario_etapas_estilo
end type
type cb_1 from commandbutton within w_preview_inventario_etapas_estilo
end type
end forward

global type w_preview_inventario_etapas_estilo from w_preview_de_impresion
integer width = 3424
dw_1 dw_1
cb_1 cb_1
end type
global w_preview_inventario_etapas_estilo w_preview_inventario_etapas_estilo

on w_preview_inventario_etapas_estilo.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
end on

on w_preview_inventario_etapas_estilo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;//w_1.settransobject(sqlca)
//dw_1.InsertRow(0)
//
this.width=3566
this.height=1928
This.WindowState = Maximized!

TRANSACTION			itr_tela
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
dw_1.SetTransObject(itr_tela)

dw_1.InsertRow(0)
dw_1.SetItem(1,'etapa',0)
dw_1.SetItem(1,'orden_corte',0)
dw_1.SetItem(1,'area',0)
dw_1.SetItem(1,'fecha',Today())
dw_1.SetFocus()

lstr_parametros=message.powerObjectparm
//
//If lstr_parametros.cadena[1] = 'SI' Then
//	dw_reporte.Retrieve(lstr_parametros.cadena[2],lstr_parametros.entero[1],0,0)
//	dw_reporte.SetItem(1,'area',lstr_parametros.entero[1])
//End if
//
//ii_ancho= dw_reporte.width 
//ii_alto = dw_reporte.height
//ii_posx = dw_reporte.x   
//ii_posy = dw_reporte.y 
//

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
	MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
	Return
END IF

end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_inventario_etapas_estilo
integer y = 144
integer width = 3360
integer height = 1564
string dataobject = "dtb_inventarioxetapas_estilo"
end type

type dw_1 from datawindow within w_preview_inventario_etapas_estilo
integer x = 14
integer y = 24
integer width = 2510
integer height = 100
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_criterio_etapas_datos_resumidos"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

type cb_1 from commandbutton within w_preview_inventario_etapas_estilo
integer x = 2565
integer y = 20
integer width = 402
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ver Reporte"
boolean default = true
end type

event clicked;String ls_fecha
Long li_area,li_etapa
Long ll_ordencorte
Date ld_fecha
DateTime ldt_fecha
TRANSACTION		itr_tela


dw_1.AcceptText()

ld_fecha = dw_1.GetItemDate(1,'fecha')
li_area = dw_1.GetItemNumber(1,'area')
li_etapa = dw_1.GetItemNumber(1,'etapa')
ll_ordencorte = dw_1.GetItemNumber(1,'orden_corte')

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
dw_1.SetTransObject(itr_tela)

dw_reporte.Retrieve(ldt_fecha,li_area,li_etapa,ll_ordencorte)


DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

