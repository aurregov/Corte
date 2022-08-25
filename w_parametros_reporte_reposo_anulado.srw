HA$PBExportHeader$w_parametros_reporte_reposo_anulado.srw
forward
global type w_parametros_reporte_reposo_anulado from window
end type
type dw_1 from uo_dtwndow within w_parametros_reporte_reposo_anulado
end type
type cb_2 from commandbutton within w_parametros_reporte_reposo_anulado
end type
type cb_1 from commandbutton within w_parametros_reporte_reposo_anulado
end type
end forward

global type w_parametros_reporte_reposo_anulado from window
integer width = 992
integer height = 944
boolean titlebar = true
string title = "Parametros Reposo Anulado"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
cb_2 cb_2
cb_1 cb_1
end type
global w_parametros_reporte_reposo_anulado w_parametros_reporte_reposo_anulado

on w_parametros_reporte_reposo_anulado.create
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.dw_1,&
this.cb_2,&
this.cb_1}
end on

on w_parametros_reporte_reposo_anulado.destroy
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;
dw_1.InsertRow(0)
end event

type dw_1 from uo_dtwndow within w_parametros_reporte_reposo_anulado
integer x = 50
integer y = 32
integer width = 882
integer height = 628
integer taborder = 10
string dataobject = "d_ff_parametros_reporte_reposo_anulado"
boolean vscrollbar = false
boolean border = false
end type

type cb_2 from commandbutton within w_parametros_reporte_reposo_anulado
integer x = 178
integer y = 724
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Long ll_reftel, ll_op, ll_referencia
Date ld_fe_ini, ld_fe_fin

If dw_1.AcceptText() < 0 Then Return -1

ll_reftel = dw_1.GetItemNumber(1,'co_reftel')
If Isnull(ll_reftel) then ll_reftel = 0
ll_op = dw_1.GetItemNumber(1,'op')
If Isnull(ll_op) then ll_op = 0
ll_referencia = dw_1.GetItemNumber(1,'co_referencia')
If Isnull(ll_referencia) then ll_referencia = 0
ld_fe_ini = dw_1.GetItemDate(1,'fecha_ini')
ld_fe_fin = dw_1.GetItemDate(1,'fecha_fin')
w_preview_de_impresion.dw_reporte.Retrieve(ll_reftel, ll_op, ll_referencia, ld_fe_ini, ld_fe_fin)
Close(Parent)
end event

type cb_1 from commandbutton within w_parametros_reporte_reposo_anulado
integer x = 549
integer y = 724
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

