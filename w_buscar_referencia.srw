HA$PBExportHeader$w_buscar_referencia.srw
forward
global type w_buscar_referencia from w_base_buscar_maestros
end type
end forward

global type w_buscar_referencia from w_base_buscar_maestros
end type
global w_buscar_referencia w_buscar_referencia

event open;//la datawindows que se envie como parametro debe tener los campos
//codigo (codigo numero en el maestro) y de_codigo (descricripcion del campo maestro)
//Angela Nore$$HEX1$$f100$$ENDHEX$$a sep/2006
gnv_recursos = Create uo_adm_recursos
String ls_datawindows
s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

ls_datawindows = lstr_parametros.cadena[1]

dw_lista.DataObject = ls_datawindows

dw_lista.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

dw_lista.Retrieve(lstr_parametros.entero[1],lstr_parametros.entero[2])
end event

on w_buscar_referencia.create
call super::create
end on

on w_buscar_referencia.destroy
call super::destroy
end on

type cb_cancelar from w_base_buscar_maestros`cb_cancelar within w_buscar_referencia
end type

type cb_aceptar from w_base_buscar_maestros`cb_aceptar within w_buscar_referencia
end type

type dw_lista from w_base_buscar_maestros`dw_lista within w_buscar_referencia
end type

type gb_1 from w_base_buscar_maestros`gb_1 within w_buscar_referencia
end type

