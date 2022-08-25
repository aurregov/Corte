HA$PBExportHeader$w_observaciones.srw
$PBExportComments$(JCR)
forward
global type w_observaciones from window
end type
type dw_2 from datawindow within w_observaciones
end type
type dw_1 from datawindow within w_observaciones
end type
end forward

global type w_observaciones from window
integer width = 2894
integer height = 656
boolean titlebar = true
string title = "Observaciones"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
dw_2 dw_2
dw_1 dw_1
end type
global w_observaciones w_observaciones

type variables
datawindowchild idw_area
end variables

on w_observaciones.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.dw_2,&
this.dw_1}
end on

on w_observaciones.destroy
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;n_cts_param luo_param
THIS.width = 2894
THIS.height = 656

luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_1.getchild('co_area',idw_area)

idw_area.settransobject(sqlca)
dw_1.insertrow(0)
//dw_2.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
//    			 luo_param.il_vector[4],luo_param.il_vector[5],luo_param.il_vector[6],&
//				 luo_param.il_vector[7],luo_param.is_vector[1],luo_param.il_vector[8],&
//				 luo_param.il_vector[9],luo_param.il_vector[10],luo_param.il_vector[11],&
//				 luo_param.is_vector[2],luo_param.il_vector[12],luo_param.il_vector[13])
								 
end event

event closequery;dw_2.AcceptText()

If dw_2.Update() = -1 Then
	rollback ;
Else
	commit ;
End If
end event

type dw_2 from datawindow within w_observaciones
integer x = 50
integer y = 176
integer width = 2702
integer height = 344
integer taborder = 20
string title = "none"
string dataobject = "dff_observacion_modulo"
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_observaciones
integer x = 69
integer y = 52
integer width = 1010
integer height = 108
integer taborder = 10
string title = "none"
string dataobject = "dff_seleccion_area"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long ll_fila
Long ll_area

dw_1.AcceptText()

ll_fila = dw_1.GetRow()

CHOOSE CASE dwo.name
	CASE 'co_area'
			ll_area = dw_1.getitemnumber(ll_fila,'co_area')	
			dw_1.setitem(ll_fila,'area',string(ll_area))	
END CHOOSE
end event

event losefocus;n_cts_param luo_param
LONG ll_area

luo_param = Message.PowerObjectParm
ll_area = dw_1.getitemnumber(dw_1.getrow(),'co_area')

If Not IsValid(luo_param) Then
	Return
End If

dw_2.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
    			 luo_param.il_vector[4],luo_param.il_vector[5],luo_param.il_vector[6],&
				 luo_param.il_vector[7],luo_param.is_vector[1],luo_param.il_vector[8],&
				 luo_param.il_vector[9],luo_param.il_vector[10],luo_param.il_vector[11],&
				 luo_param.is_vector[2],luo_param.il_vector[12],luo_param.il_vector[13],ll_area)
								 
end event

