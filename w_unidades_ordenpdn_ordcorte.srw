HA$PBExportHeader$w_unidades_ordenpdn_ordcorte.srw
forward
global type w_unidades_ordenpdn_ordcorte from w_preview_de_impresion
end type
end forward

global type w_unidades_ordenpdn_ordcorte from w_preview_de_impresion
string menuname = "m_reporte_unidades"
event ue_buscar pbm_custom07
end type
global w_unidades_ordenpdn_ordcorte w_unidades_ordenpdn_ordcorte

event ue_buscar;Long ll_ordenpdn
s_base_parametros lstr_parametros, lstr_parametros_retro

Open(w_buscar_ordenpd)
lstr_parametros = Message.PowerObjectParm	
IF lstr_parametros.hay_parametros THEN
	lstr_parametros_retro.cadena[1]="Generando Reporte ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"
	
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
	SQLCA.LOCK = "Dirty Read"
	DISCONNECT;
	CONNECT;
	dw_reporte.SetTransObject(SQLCA)
	ll_ordenpdn = lstr_parametros.entero[1]
	DECLARE generar PROCEDURE FOR
		pr_unidades_ordpdn(:ll_ordenpdn);
	EXECUTE generar;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al generar la tabla temporal")
		ROLLBACK;
	ELSE
		COMMIT;
		dw_reporte.Retrieve(gstr_info_usuario.codigo_usuario,ll_ordenpdn)
	END IF
	Close(w_retroalimentacion)
	SQLCA.LOCK = "Cursor Stability"
	DISCONNECT;
	CONNECT;	
END IF
end event

event open;This.x = 1
This.y = 1
Long ll_ordenpdn
s_base_parametros lstr_parametros

dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
	
end event

on w_unidades_ordenpdn_ordcorte.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_reporte_unidades" then this.MenuID = create m_reporte_unidades
end on

on w_unidades_ordenpdn_ordcorte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_unidades_ordenpdn_ordcorte
string dataobject = "dtb_unidades_ordpdn_ordcorte"
end type

