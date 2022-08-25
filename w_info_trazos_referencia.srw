HA$PBExportHeader$w_info_trazos_referencia.srw
forward
global type w_info_trazos_referencia from w_tallas_liberacion
end type
type dw_1 from uo_dtwndow within w_info_trazos_referencia
end type
end forward

global type w_info_trazos_referencia from w_tallas_liberacion
integer width = 3735
integer height = 1540
dw_1 dw_1
end type
global w_info_trazos_referencia w_info_trazos_referencia

type variables

Long il_fabrica, il_linea, il_referencia
end variables

on w_info_trazos_referencia.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_info_trazos_referencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;
// Override ancestor script

n_cts_param luo_param

luo_param = Message.PowerObjectParm
IF IsValid(luo_param) THEN
	dw_1.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
	dw_maestro.SetTransObject(SQLCA)
	dw_maestro.Retrieve(luo_param.il_vector[1], luo_param.il_vector[2], luo_param.il_vector[3])
	il_fabrica = luo_param.il_vector[1]
	il_linea = luo_param.il_vector[2]
	il_referencia = luo_param.il_vector[3]
END IF

end event

type dw_maestro from w_tallas_liberacion`dw_maestro within w_info_trazos_referencia
integer width = 3095
integer height = 1320
string dataobject = "dtb_info_trazos_referencia"
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long  ll_trazo, ll_fabrica, ll_linea, ll_referencia

IF currentrow > 0 THEN
	ll_trazo = dw_maestro.GetitemNumber(currentrow, "h_trazos_co_trazo")
	ll_fabrica = dw_maestro.GetitemNumber(currentrow, "co_fabrica")
	ll_linea = dw_maestro.GetitemNumber(currentrow, "co_linea")
	ll_referencia = dw_maestro.GetitemNumber(currentrow, "co_referencia")
	IF Not IsNull(ll_trazo) THEN
		dw_1.Retrieve(ll_trazo, ll_fabrica, ll_linea, ll_referencia)
	END IF
ELSE
	dw_1.Reset()
END IF

end event

type dw_1 from uo_dtwndow within w_info_trazos_referencia
integer x = 3145
integer y = 32
integer width = 549
integer height = 1312
integer taborder = 11
boolean bringtotop = true
string dataobject = "dtb_detalle_tallasxtrazo"
end type

event itemchanged;//
return 2
end event

event getfocus;//
end event

