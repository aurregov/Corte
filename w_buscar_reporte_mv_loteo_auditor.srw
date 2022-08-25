HA$PBExportHeader$w_buscar_reporte_mv_loteo_auditor.srw
forward
global type w_buscar_reporte_mv_loteo_auditor from window
end type
type cb_cancelar from commandbutton within w_buscar_reporte_mv_loteo_auditor
end type
type cb_aceptar from commandbutton within w_buscar_reporte_mv_loteo_auditor
end type
type dw_criterio from datawindow within w_buscar_reporte_mv_loteo_auditor
end type
type gb_1 from groupbox within w_buscar_reporte_mv_loteo_auditor
end type
end forward

global type w_buscar_reporte_mv_loteo_auditor from window
integer width = 1125
integer height = 1212
boolean titlebar = true
string title = "Criterios"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_criterio dw_criterio
gb_1 gb_1
end type
global w_buscar_reporte_mv_loteo_auditor w_buscar_reporte_mv_loteo_auditor

on w_buscar_reporte_mv_loteo_auditor.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.dw_criterio,&
this.gb_1}
end on

on w_buscar_reporte_mv_loteo_auditor.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_criterio)
destroy(this.gb_1)
end on

event open;dw_criterio.SetTransObject(sqlca)
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

end event

type cb_cancelar from commandbutton within w_buscar_reporte_mv_loteo_auditor
integer x = 603
integer y = 936
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn (Parent, lstr_parametros)
end event

type cb_aceptar from commandbutton within w_buscar_reporte_mv_loteo_auditor
integer x = 160
integer y = 936
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Long ll_ordencorte, ll_referencia, li_auditor, ll_color
Long li_fabrica, li_linea, li_concepto
String ls_lider
DateTime ldt_fecha_ini, ldt_fecha_fin
s_base_parametros lstr_parametros

dw_criterio.AcceptText()

ll_ordencorte 	= dw_criterio.GetItemNumber(1,'cs_orden_corte')
ll_referencia 	= dw_criterio.GetItemNumber(1,'co_referencia')
li_fabrica		= dw_criterio.GetItemNumber(1,'co_fabrica')
li_linea			= dw_criterio.GetItemNumber(1,'co_linea')
li_auditor		= dw_criterio.GetItemNumber(1,'co_auditor')
ls_lider			= dw_criterio.GetItemString(1,'lider')
ldt_fecha_ini	= dw_criterio.GetItemDateTime(1,'fecha_ini')
ldt_fecha_fin	= dw_criterio.GetItemDateTime(1,'fecha_fin')
li_concepto		= dw_criterio.GetItemNumber(1,'co_concepto')

If IsNull(ll_ordencorte) 	Then ll_ordencorte = 0
If IsNull(ll_referencia)	Then ll_referencia = 0
If IsNull(li_fabrica) 		Then li_fabrica = 0
If IsNull(li_linea) 			Then li_linea = 0
If IsNull(li_auditor) 		Then li_auditor = 0
If IsNull(ls_lider) 			Then ls_lider = ' '
If IsNull(ldt_fecha_ini) 	Then ldt_fecha_ini = DateTime(Date("01-01-1900"),Time("00:00.000"))
If IsNull(ldt_fecha_fin) 	Then ldt_fecha_fin = DateTime(Date("01-01-1900"),Time("00:00.000"))
If IsNull(li_concepto) 		Then li_concepto = 0

lstr_parametros.entero[1] 		= ll_ordencorte
lstr_parametros.entero[5] 		= ll_referencia
lstr_parametros.entero[3] 		= li_fabrica
lstr_parametros.entero[4] 		= li_linea
lstr_parametros.entero[2] 		= li_auditor
lstr_parametros.cadena[1] 		= ls_lider
lstr_parametros.fechahora[1] 	= ldt_fecha_ini
lstr_parametros.fechahora[2] 	= ldt_fecha_fin
lstr_parametros.entero[6]     = li_concepto

lstr_parametros.hay_parametros = True
CloseWithReturn (Parent, lstr_parametros)
end event

type dw_criterio from datawindow within w_buscar_reporte_mv_loteo_auditor
integer x = 73
integer y = 84
integer width = 951
integer height = 776
integer taborder = 10
string title = "none"
string dataobject = "dff_criterio_reporte_mv_loteo_auditor"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_buscar_reporte_mv_loteo_auditor
integer x = 37
integer y = 20
integer width = 1024
integer height = 868
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

