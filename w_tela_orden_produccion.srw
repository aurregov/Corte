HA$PBExportHeader$w_tela_orden_produccion.srw
forward
global type w_tela_orden_produccion from w_preview_de_impresion
end type
type dw_parametros from datawindow within w_tela_orden_produccion
end type
type cb_buscar from commandbutton within w_tela_orden_produccion
end type
type cb_reset from commandbutton within w_tela_orden_produccion
end type
end forward

global type w_tela_orden_produccion from w_preview_de_impresion
integer width = 3616
dw_parametros dw_parametros
cb_buscar cb_buscar
cb_reset cb_reset
end type
global w_tela_orden_produccion w_tela_orden_produccion

on w_tela_orden_produccion.create
int iCurrent
call super::create
this.dw_parametros=create dw_parametros
this.cb_buscar=create cb_buscar
this.cb_reset=create cb_reset
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parametros
this.Control[iCurrent+2]=this.cb_buscar
this.Control[iCurrent+3]=this.cb_reset
end on

on w_tela_orden_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_parametros)
destroy(this.cb_buscar)
destroy(this.cb_reset)
end on

event open;DISCONNECT ;
SQLCA.Lock = "Dirty Read"					
CONNECT ;

dw_reporte.settransobject(sqlca)
dw_parametros.settransobject(sqlca)
dw_parametros.InsertRow(0)

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

event closequery;call super::closequery;DISCONNECT ;
SQLCA.Lock = "cursor stability"					
CONNECT ;
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_tela_orden_produccion
integer width = 3552
string dataobject = "dtb_tela_orden_produccion"
end type

type dw_parametros from datawindow within w_tela_orden_produccion
integer x = 18
integer y = 16
integer width = 2958
integer height = 116
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_parametros_tela_orden_produccion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;DataWindowChild ldw_parametros
Long li_fabrica, li_linea

This.AcceptText()
CHOOSE CASE dwo.Name
	CASE 'co_fabrica'
		li_fabrica = This.GetItemNumber(Row, 'co_fabrica')
		This.GetChild('co_linea',  ldw_parametros)
		ldw_parametros.SetTransObject(SQLCA)
		ldw_parametros.Retrieve(li_fabrica)
		li_linea = This.GetItemNumber(Row, 'co_linea')
		IF Not IsNull(li_linea) THEN
			This.GetChild('co_referencia',  ldw_parametros)
			ldw_parametros.SetTransObject(SQLCA)
			ldw_parametros.Retrieve(li_fabrica, li_linea)			
		END IF
	CASE 'co_linea'
		li_fabrica = This.GetItemNumber(Row, 'co_fabrica')
		li_linea = This.GetItemNumber(Row, 'co_linea')
		This.GetChild('co_referencia',  ldw_parametros)
		ldw_parametros.SetTransObject(SQLCA)
		ldw_parametros.Retrieve(li_fabrica, li_linea)			
END CHOOSE
end event

type cb_buscar from commandbutton within w_tela_orden_produccion
integer x = 3291
integer y = 36
integer width = 283
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;Long li_fabrica, li_linea
Long ll_referencia, ll_ordenpdn

dw_parametros.AcceptText()

ll_ordenpdn = dw_parametros.GetItemNumber(1, 'cs_ordenpd_pt')
li_fabrica = dw_parametros.GetItemNumber(1, 'co_fabrica')
li_linea = dw_parametros.GetItemNumber(1, 'co_linea')
ll_referencia = dw_parametros.GetItemNumber(1, 'co_referencia')
IF IsNull(ll_ordenpdn) THEN
	ll_ordenpdn = 0
END IF
IF IsNull(li_fabrica) THEN
	li_fabrica = 0
END IF
IF IsNull(li_linea) THEN
	li_linea = 0
END IF
IF IsNull(ll_referencia) THEN
	ll_referencia = 0
END IF

dw_reporte.Retrieve(ll_ordenpdn, li_fabrica, li_linea, ll_referencia)
end event

type cb_reset from commandbutton within w_tela_orden_produccion
integer x = 2985
integer y = 36
integer width = 283
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Limpiar"
end type

event clicked;dw_parametros.Reset()
dw_parametros.InsertRow(0)
end event

