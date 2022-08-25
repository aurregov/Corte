HA$PBExportHeader$w_unid_sobrantes_loteo.srw
forward
global type w_unid_sobrantes_loteo from w_base_buscar_lista
end type
end forward

global type w_unid_sobrantes_loteo from w_base_buscar_lista
integer width = 3113
integer height = 1312
string title = "Unidades Sobrantes de una O.C,"
end type
global w_unid_sobrantes_loteo w_unid_sobrantes_loteo

forward prototypes
public function long f_actualiza_sobra_canasta (string as_bongo, long ai_fabrica, long ai_linea, long al_estilo, long al_color, long ai_talla, long al_orden_corte, long al_unid_ltndo, long al_unid_sobran)
end prototypes

public function long f_actualiza_sobra_canasta (string as_bongo, long ai_fabrica, long ai_linea, long al_estilo, long al_color, long ai_talla, long al_orden_corte, long al_unid_ltndo, long al_unid_sobran);Long	posi, ll_filas
datastore	ldtb_act_sobra_canasta_cte


ldtb_act_sobra_canasta_cte = Create DataStore  //para traer la informacion de la canasta y actualizar
ldtb_act_sobra_canasta_cte.DataObject = 'dtb_act_sobra_canasta_cte'
ldtb_act_sobra_canasta_cte.SetTransObject(sqlca)

ldtb_act_sobra_canasta_cte.Retrieve(as_bongo, ai_fabrica, ai_linea, al_estilo, al_color, ai_talla, al_orden_corte)  

ll_filas = ldtb_act_sobra_canasta_cte.RowCount()
FOR posi = 1  TO ll_filas
	ldtb_act_sobra_canasta_cte.SetItem(posi, 'ca_cortexencima', al_unid_sobran)
	posi = ll_filas + 1
NEXT

ldtb_act_sobra_canasta_cte.Accepttext()
If ldtb_act_sobra_canasta_cte.Update() < 0 Then
	Rollback;
	MessageBox("Advertencia!","No se pudieron actualizar las unidades sorbrantes en la canasta.")
	Return -3
ELSE
	Commit;
End If

return 1
end function

event open;//	Carga la seguridad para esta ventana
//This.wf_validar_seguridad()

dw_lista.settransobject(SQLCA)

s_base_parametros lstr_parametros_env

lstr_parametros_env = Message.PowerObjectParm


If IsValid(lstr_parametros_env) Then
	lstr_parametros_env.ds_datos[1].RowsCopy(1, &
       lstr_parametros_env.ds_datos[1].RowCount(), Primary!, dw_lista, 1, Primary!)
		 
		dw_lista.modify("dw_lista.readonly=yes")	
End if
end event

on w_unid_sobrantes_loteo.create
call super::create
end on

on w_unid_sobrantes_loteo.destroy
call super::destroy
end on

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_unid_sobrantes_loteo
integer x = 837
integer y = 964
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_unid_sobrantes_loteo
integer x = 1435
integer y = 1076
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_unid_sobrantes_loteo
integer x = 878
integer y = 1076
end type

event pb_aceptar::clicked;call super::clicked;// En este evento se le asigna al campo entero de la estructura 
//s_base_parametros el contenido del campo clave de la fila actual.
/////////////////////////////////////////////////////////////////



//aca se debe realizar el proceso de cargar estas unidades sobrantes en los bongos
//julio 2- 2010   esto para control en la mercada,  solicita Saul Martinez.
Long posi, li_fabrica, li_linea, li_talla, li_result
LONG	  ll_estilo, ll_orden_cte, ll_unid_ltndo, ll_sobran, ll_color
STRING	ls_bongo

FOR posi = 1 TO dw_lista.RowCount()
	ls_bongo 	 = dw_lista.GetItemString(posi,'bongo')
	ll_orden_cte = dw_lista.GetItemNumber(posi,'orden_corte')
	li_fabrica   = dw_lista.GetItemNumber(posi,'fabrica')
	li_linea     = dw_lista.GetItemNumber(posi,'linea')
	ll_estilo    = dw_lista.GetItemNumber(posi,'estilo')
	ll_color     = dw_lista.GetItemNumber(posi,'color')
	li_talla     = dw_lista.GetItemNumber(posi,'talla')
	ll_unid_ltndo= dw_lista.GetItemNumber(posi,'unid_loteando') 
	ll_sobran    = dw_lista.GetItemNumber(posi,'unid_sobrantes') 
	
	li_result = f_actualiza_sobra_canasta(ls_bongo,li_fabrica,li_linea,ll_estilo,ll_color,li_talla,ll_orden_cte,ll_unid_ltndo,ll_sobran )
NEXT




s_base_parametros lstr_parametros

IF il_fila_actual > 0 THEN
	lstr_parametros.hay_parametros = TRUE
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"unid_sobrantes")
	closewithreturn(parent,lstr_parametros)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_unid_sobrantes_loteo
integer x = 18
integer width = 3054
integer height = 900
string dataobject = "ds_unid_sobrantes_loteo"
end type

