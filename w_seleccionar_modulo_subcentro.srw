HA$PBExportHeader$w_seleccionar_modulo_subcentro.srw
forward
global type w_seleccionar_modulo_subcentro from w_base_buscar_lista
end type
end forward

global type w_seleccionar_modulo_subcentro from w_base_buscar_lista
integer width = 1390
integer height = 920
end type
global w_seleccionar_modulo_subcentro w_seleccionar_modulo_subcentro

on w_seleccionar_modulo_subcentro.create
call super::create
end on

on w_seleccionar_modulo_subcentro.destroy
call super::destroy
end on

event open;long ll_numero_registros
s_base_parametros lstr_parametros 

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	ll_numero_registros = dw_lista.Retrieve(lstr_parametros.entero[1], lstr_parametros.entero[2], &
								lstr_parametros.entero[3], lstr_parametros.entero[4], lstr_parametros.entero[5])
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			dw_lista.setrow(1)
			dw_lista.selectrow(1,true)
			il_fila_actual = 1
	END CHOOSE
END IF
dw_lista.SetRowFocusIndicator (Off!)
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_modulo_subcentro
integer x = 32
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_modulo_subcentro
integer x = 969
integer y = 712
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_modulo_subcentro
integer x = 558
integer y = 712
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1] = dw_lista.getitemnumber(il_fila_actual,"co_modulo")
	lstr_parametros.cadena[1] = dw_lista.getitemString(il_fila_actual,"de_modulo")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_modulo_subcentro
integer width = 1307
string dataobject = "d_lista_m_modulos"
end type

