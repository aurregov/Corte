HA$PBExportHeader$w_buscar_motivo_anulacion.srw
forward
global type w_buscar_motivo_anulacion from w_base_buscar_interactivo
end type
type dw_lista from datawindow within w_buscar_motivo_anulacion
end type
end forward

global type w_buscar_motivo_anulacion from w_base_buscar_interactivo
string title = "Motivo de Anulaci$$HEX1$$f300$$ENDHEX$$n"
dw_lista dw_lista
end type
global w_buscar_motivo_anulacion w_buscar_motivo_anulacion

on w_buscar_motivo_anulacion.create
int iCurrent
call super::create
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_buscar_motivo_anulacion.destroy
call super::destroy
destroy(this.dw_lista)
end on

event open;call super::open;This.Center = True

dw_lista.SetTransObject(sqlca)
dw_lista.InsertRow(0)
dw_lista.SetFocus()
end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_buscar_motivo_anulacion
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_buscar_motivo_anulacion
end type

event pb_buscar::clicked;call super::clicked;Long li_anulacion
s_base_parametros lstr_parametros

li_anulacion = dw_lista.GetItemNumber(1,'anulacion')

If isnull(li_anulacion ) Then
	MessageBox('Advertencia','Debe seleccionar un motivo de anulaci$$HEX1$$f300$$ENDHEX$$n.')
	Return
Else
	lstr_parametros.entero[1]=li_anulacion 
	lstr_parametros.hay_parametros = True
End if


CloseWithReturn(parent,lstr_parametros)
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_buscar_motivo_anulacion
boolean visible = false
integer x = 46
integer y = 356
integer width = 91
integer height = 60
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_buscar_motivo_anulacion
boolean visible = false
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_buscar_motivo_anulacion
end type

type dw_lista from datawindow within w_buscar_motivo_anulacion
integer x = 133
integer y = 92
integer width = 978
integer height = 160
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dff_motivo_anulacion"
boolean border = false
boolean livescroll = true
end type

