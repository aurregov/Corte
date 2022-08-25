HA$PBExportHeader$w_leer_rollos_a_liquidar.srw
forward
global type w_leer_rollos_a_liquidar from w_base_buscar_lista
end type
end forward

global type w_leer_rollos_a_liquidar from w_base_buscar_lista
integer width = 814
end type
global w_leer_rollos_a_liquidar w_leer_rollos_a_liquidar

type variables
Long			il_cs_orden_corte
Long			il_cs_agrupacion,il_cs_base_trazos,il_cs_trazo
end variables

on w_leer_rollos_a_liquidar.create
call super::create
end on

on w_leer_rollos_a_liquidar.destroy
call super::destroy
end on

event open;long ll_numero_registros

///////////////////////////////////////////////////////////////////////
//  En este evento se esta contando el numero de registros que son 
//  consultados para poder desplegarlos en la pantalla en el 
//  control "st_numero_registros".
//
// Ademas se le da el focus al datawindows y se pone en modo de que
// no permita modificacion.
////////////////////////////////////////////////////////////////////////

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	//ll_numero_registros = dw_lista.retrieve()
	ll_numero_registros = 0
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



s_base_parametros lstr_parametros


This.width = 814
This.height =984


lstr_parametros = Message.PowerObjectParm

if lstr_parametros.hay_parametros then
	il_cs_orden_corte 	=	lstr_parametros.entero[1]
	il_cs_agrupacion		=	lstr_parametros.entero[2]	
	il_cs_base_trazos		=	lstr_parametros.entero[3]		
else
end if

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
//	SetNull(sle_tono.Text)
//	sle_tono.SetFocus()
//	em_total_kgs.Text = String(idc_cakgs)
END IF

dw_lista.insertrow(0)

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_leer_rollos_a_liquidar
integer x = 23
integer y = 640
integer width = 270
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_leer_rollos_a_liquidar
integer x = 407
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_leer_rollos_a_liquidar
integer x = 18
boolean default = false
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados
s_base_parametros lstr_parametros

ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	//IF dw_lista.IsSelected(ll_filaactual) THEN
	IF not isnull(dw_lista.getitemnumber(ll_filaactual,"cs_rollo")) THEN
		ll_insertados = ll_insertados + 1		
		lstr_parametros.entero[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "cs_rollo")
//		lstr_parametros.entero2[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "cs_rollo")
//		lstr_parametros.entero3[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_kg")				
	END If
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros.entero[1] = ll_insertados
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False	
END IF

CloseWithReturn(Parent, lstr_parametros)
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_leer_rollos_a_liquidar
event ue_enter pbm_dwnprocessenter
integer width = 727
string dataobject = "dtb_leer_rollos_a_liquidar"
end type

event dw_lista::ue_enter;this.insertrow(0)
end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;//dw_lista.insertrow(0)
end event

event dw_lista::rowfocuschanging;call super::rowfocuschanging;//dw_lista.insertrow(0)
end event

