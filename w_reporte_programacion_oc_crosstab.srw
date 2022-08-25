HA$PBExportHeader$w_reporte_programacion_oc_crosstab.srw
forward
global type w_reporte_programacion_oc_crosstab from w_preview_de_impresion
end type
end forward

global type w_reporte_programacion_oc_crosstab from w_preview_de_impresion
end type
global w_reporte_programacion_oc_crosstab w_reporte_programacion_oc_crosstab

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
end event

on w_reporte_programacion_oc_crosstab.create
call super::create
end on

on w_reporte_programacion_oc_crosstab.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_programacion_oc_crosstab
string dataobject = "dct_reporte_oc_crosstab"
end type

