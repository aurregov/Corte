HA$PBExportHeader$w_buscar_rollos_x_espacio_x_raya.srw
forward
global type w_buscar_rollos_x_espacio_x_raya from w_base_buscar_lista
end type
end forward

global type w_buscar_rollos_x_espacio_x_raya from w_base_buscar_lista
integer width = 2944
integer height = 1400
string title = "Seleccionar rollo a Sacar"
end type
global w_buscar_rollos_x_espacio_x_raya w_buscar_rollos_x_espacio_x_raya

on w_buscar_rollos_x_espacio_x_raya.create
call super::create
end on

on w_buscar_rollos_x_espacio_x_raya.destroy
call super::destroy
end on

event open;Long  ll_mercada

Long 	ll_numero_registros, li_raya
s_base_parametros_seleccionar lstr_parametros

lstr_parametros 	= 	Message.PowerObjectParm
ll_mercada 	= 	lstr_parametros.entero1[1]
li_raya		= 	lstr_parametros.entero1[2]

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	ll_numero_registros = dw_lista.retrieve(ll_mercada, li_raya)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
			Return
		CASE 0
			il_fila_actual = 0
		CASE ELSE
			il_fila_actual = 1
	END CHOOSE
	st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
END IF

dw_lista.modify("dw_lista.readonly=yes")

dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_buscar_rollos_x_espacio_x_raya
integer x = 731
integer y = 972
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_buscar_rollos_x_espacio_x_raya
integer x = 1330
integer y = 1084
end type

event pb_cancelar::clicked;s_base_parametros_seleccionar lstr_parametros


lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)




end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_buscar_rollos_x_espacio_x_raya
integer x = 773
integer y = 1084
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados
s_base_parametros_seleccionar lstr_parametros

dw_lista.Accepttext()
ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	ll_insertados = ll_insertados + 1		
	lstr_parametros.entero1[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "dt_rollosmercada_cs_mercada")
	lstr_parametros.entero2[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "dt_rollosmercada_cs_rollo")
	lstr_parametros.entero3[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "rollo_completo")
	lstr_parametros.decimal1[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "dt_rollosmercada_ca_metros_mercar")				
	lstr_parametros.decimal2[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "mts_extendidos")
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros.entero1[1] = ll_insertados
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False	
END IF

CloseWithReturn(Parent, lstr_parametros)



end event

type dw_lista from w_base_buscar_lista`dw_lista within w_buscar_rollos_x_espacio_x_raya
integer width = 2857
integer height = 928
string dataobject = "dtb_rollos_x_mercada_x_raya"
end type

event dw_lista::itemchanged;call super::itemchanged;DECIMAL	ld_mts_extendidos, ld_mts_rollo

IF DWO.NAME = "mts_extendidos" THEN
	ld_mts_extendidos = DEC(DATA)
	
	ld_mts_rollo = Getitemnumber(Row, "dt_rollosmercada_ca_metros_mercar")
	IF ld_mts_extendidos > ld_mts_rollo THEN
		MessageBox('Advertencia','Los metros deben ser inferiores a los metros del rollo')
		dw_lista.SetItem(Row, "mts_extendidos", ld_mts_rollo)
	ELSE
		IF ld_mts_extendidos = ld_mts_rollo THEN
			MessageBox('Advertencia','Debe chulear Rollo Completo')
			SetItem(Row, "mts_extendidos", ld_mts_rollo)
			dw_lista.SetItem(Row, "mts_extendidos", ld_mts_rollo)
		END IF
	END IF
END IF

dw_lista.Accepttext()
end event

event dw_lista::doubleclicked;//nada
end event

