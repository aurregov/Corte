HA$PBExportHeader$w_reporte_oc_referencia.srw
forward
global type w_reporte_oc_referencia from w_preview_de_impresion
end type
type dw_1 from uo_dtwndow within w_reporte_oc_referencia
end type
type cb_1 from commandbutton within w_reporte_oc_referencia
end type
end forward

global type w_reporte_oc_referencia from w_preview_de_impresion
integer width = 3141
integer height = 2156
windowstate windowstate = maximized!
event ue_buscar ( )
dw_1 dw_1
cb_1 cb_1
end type
global w_reporte_oc_referencia w_reporte_oc_referencia

type variables

cst_adm_conexion icst_conexion
end variables

event ue_buscar();Long		ll_oc, ll_raya
String	ls_oc

If dw_1.AcceptText() <= 0 Then Return 

//toma la oc-raya
ls_oc = trim(dw_1.GetItemString(1,'ordencorte'))

//mira que no este en blanco
If Isnull(ls_oc) or ls_oc = '' Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No ha digitado la OC-Raya.')
	Return 
End if

//separa la oc-raya
ll_oc=Long(Trim(Mid(ls_oc,1,6)))
ll_raya=Long(Trim(Mid(ls_oc,7,3)))


If dw_reporte.Retrieve(ll_oc, ll_raya) <= 0 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se ha encontrado datos para la OC ' + String(ll_oc) + ' Raya ' + String(ll_raya))
	Return 
End if
	
	

end event

on w_reporte_oc_referencia.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
end on

on w_reporte_oc_referencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;
icst_conexion = create  cst_adm_conexion

dw_reporte.settransobject(icst_conexion.of_get_transaccion_sucia())

dw_1.InsertRow(0)
dw_1.SetFocus()

end event

event closequery;call super::closequery;
icst_conexion.of_destruir_dirty_read( )
Destroy icst_conexion
end event

event resize;call super::resize;
dw_reporte.Resize(This.Width - 100, This.Height - 300)
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_oc_referencia
integer x = 37
integer y = 128
integer width = 3035
integer height = 1760
string dataobject = "d_tb_reporte_oc_referencia_x_oc"
end type

type dw_1 from uo_dtwndow within w_reporte_oc_referencia
integer x = 73
integer y = 32
integer width = 914
integer height = 96
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_ff_parametro_orden_corte"
boolean vscrollbar = false
boolean border = false
end type

type cb_1 from commandbutton within w_reporte_oc_referencia
integer x = 987
integer y = 32
integer width = 293
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;
Parent.Triggerevent('ue_buscar')
end event

