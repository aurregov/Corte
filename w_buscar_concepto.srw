HA$PBExportHeader$w_buscar_concepto.srw
forward
global type w_buscar_concepto from w_base_buscar_interactivo
end type
type dw_lista from datawindow within w_buscar_concepto
end type
end forward

global type w_buscar_concepto from w_base_buscar_interactivo
dw_lista dw_lista
end type
global w_buscar_concepto w_buscar_concepto

on w_buscar_concepto.create
int iCurrent
call super::create
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_buscar_concepto.destroy
call super::destroy
destroy(this.dw_lista)
end on

event open;call super::open;dw_lista.SetTransObject(sqlca)
dw_lista.InsertRow(0)
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_concepto
integer taborder = 30
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_concepto
integer taborder = 20
end type

event pb_buscar::clicked;call super::clicked;Long li_concepto
s_base_parametros lstr_parametros

li_concepto = dw_lista.GetItemNumber(1,'concepto')

IF isnull(li_concepto) OR li_concepto = 0 THEN
	MessageBox('Advertencia','Debe seleccionar un concepto.')
	Return
ELSE
	lstr_parametros.entero[1] = li_concepto
END IF

lstr_parametros.hay_parametros = TRUE
CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_concepto
integer x = 59
string text = "Concepto:"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_concepto
boolean visible = false
integer taborder = 0
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_concepto
end type

type dw_lista from datawindow within w_buscar_concepto
integer x = 306
integer y = 132
integer width = 859
integer height = 88
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_concepto_reimpresion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

