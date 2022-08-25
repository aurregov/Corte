HA$PBExportHeader$w_buscar_tipocentro.srw
forward
global type w_buscar_tipocentro from w_base_buscar_interactivo
end type
type dw_parametros from datawindow within w_buscar_tipocentro
end type
end forward

global type w_buscar_tipocentro from w_base_buscar_interactivo
dw_parametros dw_parametros
end type
global w_buscar_tipocentro w_buscar_tipocentro

on w_buscar_tipocentro.create
int iCurrent
call super::create
this.dw_parametros=create dw_parametros
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parametros
end on

on w_buscar_tipocentro.destroy
call super::destroy
destroy(this.dw_parametros)
end on

event open;call super::open;This.Center = True

dw_parametros.SetTransObject(sqlca)
dw_parametros.InsertRow(0)
dw_parametros.SetItem(1,'co_tipo_centro_pdn',2)
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_tipocentro
integer taborder = 30
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_tipocentro
integer taborder = 20
string text = "&Aceptar"
end type

event pb_buscar::clicked;s_base_parametros lstr_parametros
lstr_parametros.hay_parametros = TRUE

lstr_parametros.entero[1]=dw_parametros.GetItemNumber(dw_parametros.GetRow(),'co_tipo_centro_pdn')

If isnull(lstr_parametros.entero[1]) Then
	MessageBox('Advertencia','Debe ingresar el tipo de centro.')
	Return 
End if

CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_tipocentro
integer width = 274
string text = "Tipo Centro:"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_tipocentro
boolean visible = false
integer taborder = 10
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_tipocentro
end type

type dw_parametros from datawindow within w_buscar_tipocentro
integer x = 421
integer y = 128
integer width = 562
integer height = 92
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dff_parametros_tipocentropdn"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

