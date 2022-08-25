HA$PBExportHeader$w_reporte_liberaciones_anuladas.srw
forward
global type w_reporte_liberaciones_anuladas from w_preview_de_impresion
end type
type dw_1 from uo_dtwndow within w_reporte_liberaciones_anuladas
end type
end forward

global type w_reporte_liberaciones_anuladas from w_preview_de_impresion
integer width = 3712
integer height = 2544
event ue_postopen ( )
dw_1 dw_1
end type
global w_reporte_liberaciones_anuladas w_reporte_liberaciones_anuladas

event ue_postopen();
DateTime ldt_inicio, ldt_fin
dw_1.InsertRow(0)

//asigna las horas para la consulta
ldt_inicio = DateTime(today(),Time('00:00:00'))
ldt_fin = DateTime(today(),Time('23:59:59'))

dw_1.SetItem(1,'fe_inicial',ldt_inicio)
dw_1.SetItem(1,'fe_final',ldt_fin)

end event

on w_reporte_liberaciones_anuladas.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_reporte_liberaciones_anuladas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;
IF dw_reporte.settransobject(gnv_recursos.of_get_transaccion_sucia( ))= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
END IF

dw_reporte.modify("dw_lista.readonly=yes")
dw_reporte.setfocus()

This.PostEvent("ue_postopen")	




end event

event resize;dw_reporte.Resize(This.Width - 100, This.Height - dw_1.Height - 250)
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_liberaciones_anuladas
integer x = 37
integer y = 192
integer width = 3621
integer height = 2112
string dataobject = "d_gr_reporte_liberaciones_anuladas"
end type

type dw_1 from uo_dtwndow within w_reporte_liberaciones_anuladas
integer x = 37
integer y = 32
integer width = 2816
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_ff_parametros_fechas"
boolean vscrollbar = false
boolean border = false
end type

event buttonclicked;call super::buttonclicked;
String ls_usuario
DateTime ldt_inicio, ldt_fin

If This.AcceptText() <> 1 Then Return -1
//toma las fechas
ldt_inicio = dw_1.GetItemDateTime( 1, 'fe_inicial')
ldt_fin = dw_1.GetItemDateTime( 1, 'fe_final')

//mira que las fechas sean validas
If IsNull(ldt_inicio) or  IsNull(ldt_fin) or date(ldt_inicio) = Date('1900-1-1') or date(ldt_fin) = Date('1900-1-1') Then 
	MessageBox('Aviso','La fechas ingresadas no son validas')	
	Return -1
End If

//mira que la fecha final no sea menor a la inicial
If ldt_inicio > ldt_fin Then 
	MessageBox('Aviso','La fecha inicial es mayor a la fecha final')	
	Return -1
End If

//toma usuario
ls_usuario = trim(dw_1.GetItemString( 1, 'usuario'))
If IsNull(ls_usuario) Then
	ls_usuario = ''
End If
//consulta los datos
dw_reporte.Retrieve(ldt_inicio, ldt_fin,ls_usuario)
end event

event itemchanged;//
end event

event rowfocuschanged;//
end event

