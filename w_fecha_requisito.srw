HA$PBExportHeader$w_fecha_requisito.srw
forward
global type w_fecha_requisito from window
end type
type dw_1 from u_dw_base within w_fecha_requisito
end type
type cb_1 from commandbutton within w_fecha_requisito
end type
end forward

global type w_fecha_requisito from window
integer width = 2825
integer height = 1288
boolean titlebar = true
string title = "Requisitos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
cb_1 cb_1
end type
global w_fecha_requisito w_fecha_requisito

on w_fecha_requisito.create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.dw_1,&
this.cb_1}
end on

on w_fecha_requisito.destroy
destroy(this.dw_1)
destroy(this.cb_1)
end on

event open;n_cts_param luo_param
Long li_tpprod,li_centro,li_subcentro  



Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If


luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If
	

dw_1.SetTransObject(Sqlca)

//select co_tipoprod,   
//       co_centro_pdn,   
//       co_subcentro_pdn  
//  into :li_tpprod,   
//       :li_centro,   
//       :li_subcentro  
//  from m_modulos  
// where co_fabrica = :luo_param.il_vector[2] and
//       co_planta = :luo_param.il_vector[3] and
//       co_modulo = :luo_param.il_vector[4]    ;
//
//If Sqlca.SqlCode <> 0 Then
//	MessageBox("Advertencia!","Hubo un error al buscar el tipo de producto.~n~n~nNota: " + Sqlca.SqlErrText )
//	Return -1
//End If

dw_1.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
    			 luo_param.il_vector[4],luo_param.il_vector[5],luo_param.il_vector[6],&
				 luo_param.is_vector[1],luo_param.is_vector[3],luo_param.il_vector[7],&
				 luo_param.il_vector[8],luo_param.il_vector[9],luo_param.il_vector[10],&
				 luo_param.is_vector[2],luo_param.il_vector[11])
								 

end event

event closequery;

dw_1.AcceptText()

If dw_1.Update() = -1 Then
	rollback ;
Else
	commit ;
End If
end event

type dw_1 from u_dw_base within w_fecha_requisito
integer x = 23
integer y = 20
integer width = 2752
integer height = 976
integer taborder = 10
string dataobject = "d_fecha_requisito"
end type

type cb_1 from commandbutton within w_fecha_requisito
integer x = 1198
integer y = 1048
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cerrar"
end type

event clicked;Close(Parent)
end event

