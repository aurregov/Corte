HA$PBExportHeader$w_preview_reporte_de_asignacion.srw
forward
global type w_preview_reporte_de_asignacion from w_preview_de_impresion
end type
end forward

global type w_preview_reporte_de_asignacion from w_preview_de_impresion
integer width = 3456
event guardar_como pbm_custom08
end type
global w_preview_reporte_de_asignacion w_preview_reporte_de_asignacion

type variables
Transaction itr_dt
end variables

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF

end event

on w_preview_reporte_de_asignacion.create
call super::create
end on

on w_preview_reporte_de_asignacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;s_base_parametros lstr_parametros

String ls_nombredw, ls_wparametros
Long li_simulacion, li_nro_asignacion

// -------------
itr_dt = Create Transaction
itr_dt.DBMS=ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_dt.DATABASE=ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_dt.USERID=gstr_info_usuario.codigo_usuario
itr_dt.DBPASS=gstr_info_usuario.password
itr_dt.DBPARM="connectstring='DSN="+SQLCA.DATABASE+";UID="+gstr_info_usuario.codigo_usuario+";PWD="+gstr_info_usuario.password+"DisableBind=1"
itr_dt.ServerName = ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_dt.Lock = "Dirty Read"

CONNECT USING itr_dt;
IF itr_dt.SQLCODE=-1 THEN
	messagebox ("Error Conecci$$HEX1$$f300$$ENDHEX$$n","No se pudo conectar la Base de datos",Stopsign!,ok!)
	RETURN
ELSE
END IF
// -------------

/* Declara Variables de Instancia */
dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 
// --------------------
IF dw_reporte.settransobject(itr_dt)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
END IF
dw_reporte.modify("dw_reporte.readonly=yes")
// --------------------

/* Llama la pantalla para pedir parametros de ejecucion del reporte */
//Open(w_parametros_reporte_de_asignacion)
Open(w_parametros_reporte_asignacion)
lstr_parametros = Message.PowerObjectParm

/* Verifica que hayan parametros */
IF lstr_parametros.hay_parametros = TRUE THEN
	li_simulacion = lstr_parametros.entero[1]
	li_nro_asignacion = lstr_parametros.entero[2]
	
	dw_reporte.Retrieve(li_simulacion, li_nro_asignacion)
ELSE
	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
	return -1
END IF

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")




end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_reporte_de_asignacion
integer x = 0
integer width = 3397
string dataobject = "dtb_r_liberacion_asignacion"
end type

