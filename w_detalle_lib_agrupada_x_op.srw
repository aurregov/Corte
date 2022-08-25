HA$PBExportHeader$w_detalle_lib_agrupada_x_op.srw
forward
global type w_detalle_lib_agrupada_x_op from w_base_tabular
end type
end forward

global type w_detalle_lib_agrupada_x_op from w_base_tabular
integer width = 4018
integer height = 2128
string menuname = ""
end type
global w_detalle_lib_agrupada_x_op w_detalle_lib_agrupada_x_op

type variables
s_base_parametros istr_parametros


end variables

on w_detalle_lib_agrupada_x_op.create
call super::create
end on

on w_detalle_lib_agrupada_x_op.destroy
call super::destroy
end on

event open;This.Center = True


dw_maestro.SetTransObject(sqlca)

istr_parametros = Message.PowerObjectParm	

dw_maestro.Retrieve(	istr_parametros.entero[1])
						
dw_maestro.Setfocus()						
end event

type dw_maestro from w_base_tabular`dw_maestro within w_detalle_lib_agrupada_x_op
integer y = 112
integer width = 3854
integer height = 1868
string dataobject = "dtb_detalle_lib_agrupada_x_op"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_detalle_lib_agrupada_x_op
integer x = 338
integer y = 12
end type

event sle_argumento::modified;LONG	ll_liberacion


ll_liberacion = LONG(sle_argumento.text)
dw_maestro.Retrieve(ll_liberacion)
						
dw_maestro.Setfocus()						
end event

type st_1 from w_base_tabular`st_1 within w_detalle_lib_agrupada_x_op
integer width = 261
string text = "Libereacion"
end type

