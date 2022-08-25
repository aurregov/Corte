HA$PBExportHeader$w_rep_programacion_corte.srw
forward
global type w_rep_programacion_corte from w_preview_de_impresion
end type
type dw_datos from datawindow within w_rep_programacion_corte
end type
type dw_grupo from datawindow within w_rep_programacion_corte
end type
type dw_composicion from datawindow within w_rep_programacion_corte
end type
type dw_estilo from datawindow within w_rep_programacion_corte
end type
type dw_po from datawindow within w_rep_programacion_corte
end type
type dw_detalle from datawindow within w_rep_programacion_corte
end type
end forward

global type w_rep_programacion_corte from w_preview_de_impresion
integer width = 3456
string title = "Programaci$$HEX1$$f300$$ENDHEX$$n General Corte"
event guardar_como pbm_custom08
event ue_menu ( )
event ue_report ( long an_repot )
dw_datos dw_datos
dw_grupo dw_grupo
dw_composicion dw_composicion
dw_estilo dw_estilo
dw_po dw_po
dw_detalle dw_detalle
end type
global w_rep_programacion_corte w_rep_programacion_corte

type variables

m_opc_programacion il_popmenu

Long il_fabrica,il_planta,il_modulo,il_cliente
Date id_fecha
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

event ue_menu;il_popmenu.m_programacion.PopMenu(w_principal.PointerX(),w_principal.PointerY())
end event

event ue_report;Long    ll_fila,ll_cliente



ll_fila = dw_reporte.GetRow()

If ll_fila <= 0 Then Return

ll_cliente = dw_reporte.GetItemNumber(ll_fila,"co_cliente")

//If an_repot > 1 And an_repot < 7 Then
//	
//	//If ll_cliente <> il_cliente Then
//		dw_datos.Retrieve(il_fabrica,il_planta,il_modulo,id_fecha,ll_cliente)
//		il_cliente = ll_cliente 
//	//End If
//	dw_datos.ShareData(dw_estilo)
//	dw_datos.ShareData(dw_composicion)
//	dw_datos.ShareData(dw_grupo)
//	dw_datos.ShareData(dw_po)
//End If
	

Choose Case an_repot
	Case 1
		dw_reporte.Visible = True
		dw_estilo.Visible  = False
		dw_composicion.Visible = False
		dw_grupo.Visible = False
		dw_po.Visible = False
		dw_detalle.Visible = False
	Case 2
		dw_reporte.Visible = False
		dw_estilo.Visible  = True
		dw_composicion.Visible = False
		dw_grupo.Visible = False
		dw_po.Visible = False
		dw_detalle.Visible = False
		dw_estilo.Retrieve(il_fabrica,il_planta,il_modulo,id_fecha,ll_cliente)
	Case 3
		dw_reporte.Visible = False
		dw_estilo.Visible  = False
		dw_composicion.Visible = True
		dw_grupo.Visible = False
		dw_po.Visible = False
		dw_detalle.Visible = False
		dw_composicion.Retrieve(il_fabrica,il_planta,il_modulo,id_fecha,ll_cliente)
	Case 4
		dw_reporte.Visible = False
		dw_estilo.Visible  = False
		dw_composicion.Visible = False
		dw_grupo.Visible = True
		dw_po.Visible = False
		dw_detalle.Visible = False
		dw_grupo.Retrieve(il_fabrica,il_planta,il_modulo,id_fecha,ll_cliente)
	Case 5
		dw_reporte.Visible = False
		dw_estilo.Visible  = False
		dw_composicion.Visible = False
		dw_grupo.Visible = False
		dw_po.Visible = True
		dw_detalle.Visible = False
		dw_po.Retrieve(il_fabrica,il_planta,il_modulo,id_fecha,ll_cliente)
	Case 7
		dw_reporte.Visible = False
		dw_estilo.Visible  = False
		dw_composicion.Visible = False
		dw_grupo.Visible = False
		dw_po.Visible = False
		dw_detalle.Visible = True
		dw_detalle.Retrieve(il_fabrica,il_planta,il_modulo,&
	              id_fecha,0,ll_cliente,0,'',0,0,'',0,0,0)
End Choose

end event

on w_rep_programacion_corte.create
int iCurrent
call super::create
this.dw_datos=create dw_datos
this.dw_grupo=create dw_grupo
this.dw_composicion=create dw_composicion
this.dw_estilo=create dw_estilo
this.dw_po=create dw_po
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_datos
this.Control[iCurrent+2]=this.dw_grupo
this.Control[iCurrent+3]=this.dw_composicion
this.Control[iCurrent+4]=this.dw_estilo
this.Control[iCurrent+5]=this.dw_po
this.Control[iCurrent+6]=this.dw_detalle
end on

on w_rep_programacion_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_datos)
destroy(this.dw_grupo)
destroy(this.dw_composicion)
destroy(this.dw_estilo)
destroy(this.dw_po)
destroy(this.dw_detalle)
end on

event open;n_cts_param lou_param


il_popmenu = Create m_opc_programacion

ii_ancho = dw_reporte.width 
ii_alto  = dw_reporte.height
ii_posx  = dw_reporte.x   
ii_posy  = dw_reporte.y 

dw_reporte.SetTransObject(Sqlca)
dw_datos.SetTransObject(Sqlca)
dw_detalle.SetTransObject(Sqlca)
dw_grupo.SetTransObject(Sqlca)
dw_composicion.SetTransObject(Sqlca)
dw_po.SetTransObject(Sqlca)
dw_estilo.SetTransObject(Sqlca)


Open(w_parametros_programacion_corte)

lou_param = Message.PowerObjectParm


If IsValid(lou_param) Then
	dw_reporte.Retrieve(lou_param.il_vector[1],lou_param.il_vector[2],lou_param.il_vector[3],&
	           lou_param.id_vector[1])
				  
	il_fabrica = lou_param.il_vector[1]
	il_planta  = lou_param.il_vector[2]
	il_modulo  = lou_param.il_vector[3]
	id_fecha   = lou_param.id_vector[1]
	
End If


end event

event resize;call super::resize;dw_estilo.Resize(This.Width - 100, This.Height - 250)
dw_composicion.Resize(This.Width - 100, This.Height - 250)
dw_grupo.Resize(This.Width - 100, This.Height - 250)
dw_po.Resize(This.Width - 100, This.Height - 250)
dw_detalle.Resize(This.Width - 100, This.Height - 250)
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_rep_programacion_corte
integer x = 14
integer y = 12
integer width = 3397
string dataobject = "d_rep_tiempo_x_cliente"
end type

event dw_reporte::clicked;call super::clicked;

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

end event

event dw_reporte::rbuttondown;call super::rbuttondown;
Parent.TriggerEvent("ue_menu")
end event

type dw_datos from datawindow within w_rep_programacion_corte
boolean visible = false
integer x = 14
integer y = 12
integer width = 1765
integer height = 672
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_rep_programacion_tiempo_datos"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_grupo from datawindow within w_rep_programacion_corte
boolean visible = false
integer x = 14
integer y = 12
integer width = 571
integer height = 600
integer taborder = 50
string title = "none"
string dataobject = "d_rep_tiempo_x_grupo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Parent.TriggerEvent("ue_menu")
end event

type dw_composicion from datawindow within w_rep_programacion_corte
boolean visible = false
integer x = 14
integer y = 12
integer width = 571
integer height = 600
integer taborder = 50
string title = "none"
string dataobject = "d_rep_tiempo_x_composicion"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Parent.TriggerEvent("ue_menu")
end event

type dw_estilo from datawindow within w_rep_programacion_corte
boolean visible = false
integer x = 14
integer y = 12
integer width = 571
integer height = 600
integer taborder = 40
string title = "none"
string dataobject = "d_rep_tiempo_x_estilo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Parent.TriggerEvent("ue_menu")
end event

type dw_po from datawindow within w_rep_programacion_corte
boolean visible = false
integer x = 14
integer y = 12
integer width = 571
integer height = 600
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_rep_tiempo_x_po"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Parent.TriggerEvent("ue_menu")
end event

type dw_detalle from datawindow within w_rep_programacion_corte
boolean visible = false
integer x = 14
integer y = 12
integer width = 571
integer height = 600
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_tiempo_programdo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;Parent.TriggerEvent("ue_menu")
end event

