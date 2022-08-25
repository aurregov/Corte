HA$PBExportHeader$w_preview_unidades_cortadas.srw
forward
global type w_preview_unidades_cortadas from w_preview_de_impresion
end type
end forward

global type w_preview_unidades_cortadas from w_preview_de_impresion
event guardar_como pbm_custom20
end type
global w_preview_unidades_cortadas w_preview_unidades_cortadas

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF
end event

on w_preview_unidades_cortadas.create
call super::create
end on

on w_preview_unidades_cortadas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;TRANSACTION			itr_tela
s_base_parametros s_parametros
String ls_nombredw, ls_wparametros

s_parametros = Message.PowerObjectParm
ls_nombredw 	= s_parametros.Cadena[1]
ls_wparametros	= Trim(s_parametros.Cadena[2])

dw_reporte.DataObject = ls_nombredw
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
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

IF ls_wparametros = 'no parametros' THEN
	dw_reporte.Retrieve()
ELSE
	Window lw_ventana
	Open(lw_ventana, ls_wparametros)
	// LA VENTANA ABIERTA DEBE SELECCIONAR LOS PARAMETROS Y OBLIGAR A HACER 
	// EL RETRIEVE DESDE ELLA ASI :
	//		w_preview_de_impresion.dw_reporte.Retrieve(Arg1, Arg2, ....)
END IF

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_unidades_cortadas
end type

