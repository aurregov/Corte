HA$PBExportHeader$w_preview_reporte_orden_planeacion.srw
forward
global type w_preview_reporte_orden_planeacion from w_preview_de_impresion
end type
end forward

global type w_preview_reporte_orden_planeacion from w_preview_de_impresion
string title = "Orden de Planeaci$$HEX1$$f300$$ENDHEX$$n"
event guardar_como pbm_custom20
end type
global w_preview_reporte_orden_planeacion w_preview_reporte_orden_planeacion

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF

end event

on w_preview_reporte_orden_planeacion.create
call super::create
end on

on w_preview_reporte_orden_planeacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;This.X = 1
This.Y = 1
This.Width = 4100
This.Height = 1850

TRANSACTION			itr_tela
STRING	ls_instruccion

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

dw_reporte.SetTransObject(itr_tela)
dw_reporte.Retrieve()

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

//dw_reporte.SetTransObject(sqlca)



end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_reporte_orden_planeacion
string dataobject = "dtb_reporte_orden_planea"
end type

