HA$PBExportHeader$w_muestra_obs_texografo_op.srw
forward
global type w_muestra_obs_texografo_op from w_base_buscar_lista
end type
end forward

global type w_muestra_obs_texografo_op from w_base_buscar_lista
integer width = 3218
integer height = 2104
string title = "Observaciones para texografo"
end type
global w_muestra_obs_texografo_op w_muestra_obs_texografo_op

on w_muestra_obs_texografo_op.create
call super::create
end on

on w_muestra_obs_texografo_op.destroy
call super::destroy
end on

event open;Long ll_ordenpdn, ll_ordenpdn2
long ll_numero_registros
s_base_parametros lstr_parametros

dw_lista.settransobject(SQLCA)
lstr_parametros = Message.PowerObjectParm
ll_ordenpdn = lstr_parametros.entero[1]
ll_ordenpdn2 = lstr_parametros.entero[2]


dw_lista.Retrieve(ll_ordenpdn,ll_ordenpdn2)
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_muestra_obs_texografo_op
integer x = 864
integer y = 1592
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_muestra_obs_texografo_op
integer x = 1088
integer y = 1700
integer width = 562
integer height = 200
integer taborder = 10
integer textsize = -14
string text = "&Cerrar"
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_muestra_obs_texografo_op
boolean visible = false
integer x = 421
integer taborder = 20
end type

type dw_lista from w_base_buscar_lista`dw_lista within w_muestra_obs_texografo_op
integer x = 37
integer y = 4
integer width = 3131
integer height = 1504
integer taborder = 30
string dataobject = "dtb_muestra_obs_texografo_op"
end type

