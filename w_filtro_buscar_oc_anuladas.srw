HA$PBExportHeader$w_filtro_buscar_oc_anuladas.srw
forward
global type w_filtro_buscar_oc_anuladas from w_base_buscar_lista
end type
end forward

global type w_filtro_buscar_oc_anuladas from w_base_buscar_lista
integer width = 1504
integer height = 1224
end type
global w_filtro_buscar_oc_anuladas w_filtro_buscar_oc_anuladas

type variables
uo_calendario ipo_calendario
date id_fecha_ini, id_fecha_fin
n_cst_ole_calendario ipo_calendario_ole


end variables

forward prototypes
public function long of_buscar_linea ()
end prototypes

public function long of_buscar_linea ();s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = 'dgr_buscar_lineas'
OpenWithParm ( w_buscar_dato, lstr_parametros )
lstr_parametros = Message.PowerObjectParm
		
If lstr_parametros.hay_parametros Then
			dw_lista.SetItem(1,'co_linea',lstr_parametros.entero[1])
			dw_lista.SetItem(1,'de_linea',lstr_parametros.cadena[1])
	Return 1
End If
		
Return 0
end function

on w_filtro_buscar_oc_anuladas.create
call super::create
end on

on w_filtro_buscar_oc_anuladas.destroy
call super::destroy
end on

event open;This.Center = True

dw_lista.SetTransObject(sqlca)
dw_lista.InsertRow(0)
//dw_lista.Setitem(1,'fe_inicial',date(today()))
//dw_lista.Setitem(1,'fe_final',date(today()))

OpenUserObject(ipo_calendario)



end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_filtro_buscar_oc_anuladas
boolean visible = false
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_filtro_buscar_oc_anuladas
integer x = 791
integer y = 912
end type

event pb_cancelar::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = false

CloseWithReturn ( Parent, lstr_parametros )
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_filtro_buscar_oc_anuladas
integer x = 233
integer y = 912
end type

event pb_aceptar::clicked;s_base_parametros lstr_parametros
Long ll_ref
Long li_fab, li_lin,li_fila, li_motivo
Date ld_inicial, ld_final, ld_fecha
String	ls_usu_anula

dw_lista.Accepttext()
lstr_parametros.hay_parametros = true

ld_inicial  = dw_lista.GetItemDate(1,'fe_inicial')
ld_final 	  = dw_lista.GetItemDate(1,'fe_final')
li_motivo   = dw_lista.GetItemNumber(1,'co_motivo_anula')
li_fab 	  = dw_lista.GetItemNumber(1,'co_fabrica')
li_lin 	  = dw_lista.GetItemNumber(1,'co_linea')
ll_ref      = dw_lista.GetItemNumber(1,'co_referencia')
ls_usu_anula = dw_lista.GetItemString(1,'usuario_anula')




ld_fecha =Date("01-01-1900")
//
If isnull(ld_inicial)    Then ld_inicial = ld_fecha
If isnull(ld_final)      Then ld_final = ld_fecha
If isnull(li_motivo)     Then li_motivo = 0
If isnull(li_fab) 	    Then li_fab = 0
If isnull(li_lin) 	    Then li_lin = 0
If isnull(ll_ref)        Then ll_ref = 0
If isnull(ls_usu_anula) Then ls_usu_anula = ''


lstr_parametros.fecha[1]  = ld_inicial
lstr_parametros.fecha[2]  = ld_final
lstr_parametros.entero[1] =  li_motivo
lstr_parametros.entero[2] = li_fab
lstr_parametros.entero[3] = li_lin
lstr_parametros.entero[4] = ll_ref
lstr_parametros.cadena[1] = ls_usu_anula

CloseWithReturn (Parent, lstr_parametros )

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_filtro_buscar_oc_anuladas
integer width = 1413
integer height = 864
string dataobject = "dff_filtro_buscar_oc_anuladas"
boolean vscrollbar = false
end type

event dw_lista::doubleclicked;///*llama las funciones que llaman una ventana para buscar cada item


This.AcceptText()
Choose case dwo.name
	Case "fe_inicial","fe_final"
			//ipo_calendario_ole.of_Show_Calendario(This)
			ipo_calendario.of_show_calendar(This)
	Case "co_linea"
		  Of_buscar_linea()
    
End Choose

//
end event

