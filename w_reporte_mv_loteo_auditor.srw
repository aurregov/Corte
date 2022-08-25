HA$PBExportHeader$w_reporte_mv_loteo_auditor.srw
forward
global type w_reporte_mv_loteo_auditor from w_preview_de_impresion
end type
end forward

global type w_reporte_mv_loteo_auditor from w_preview_de_impresion
integer width = 4462
integer height = 2072
event ue_buscar ( )
end type
global w_reporte_mv_loteo_auditor w_reporte_mv_loteo_auditor

event ue_buscar();//evento que permite establecer criterios de busquedad de las ordenes
//de corte loteadas con el visto bueno de calidad.
//jcrm
//abril 26 de 2007
DateTime ldt_fecha
s_base_parametros lstr_parametros

Open(w_buscar_reporte_mv_loteo_auditor)

lstr_parametros = Message.PowerObjectParm	

ldt_fecha = DateTime(Date("01-01-1900"),Time("00:00.000"))

IF IsNUll(lstr_parametros.fechahora[1]) OR lstr_parametros.fechahora[1] = ldt_fecha  THEN
	dw_reporte.DataObject = 'dtb_reporte_mv_loteo_auditor_sin_fecha'
	dw_reporte.SetTransObject(sqlca)
END IF

If dw_reporte.Retrieve(lstr_parametros.entero[1],&
						  lstr_parametros.entero[2],&
						  lstr_parametros.entero[3],&
						  lstr_parametros.entero[4],&
						  lstr_parametros.entero[5],&
						  lstr_parametros.cadena[1],&
						  lstr_parametros.fechahora[1],&
						  lstr_parametros.fechahora[2],&
						  gstr_info_usuario.co_planta_pro,&
						  lstr_parametros.entero[6])> 0 Then
						  
Else
	MessageBox('Advertencia','No existen datos que satisfagan el criterio de busqueda.',Exclamation!)
End if
end event

event open;dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

m_vista_previa_filtro.m_vistaprevia.m_buscar.Enabled = True
m_vista_previa_filtro.m_vistaprevia.m_buscar.Visible = True
m_vista_previa_filtro.m_vistaprevia.m_buscar.ToolbarItemVisible = True

This.TriggerEvent ('ue_buscar')

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_reporte_mv_loteo_auditor.create
call super::create
end on

on w_reporte_mv_loteo_auditor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_mv_loteo_auditor
integer width = 4393
string dataobject = "dtb_reporte_mv_loteo_auditor"
end type

