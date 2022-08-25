HA$PBExportHeader$n_cst_orden_corte.sru
forward
global type n_cst_orden_corte from nonvisualobject
end type
end forward

global type n_cst_orden_corte from nonvisualobject autoinstantiate
end type

type variables
String is_validacion, is_PASSWORD_REP_PARTE
end variables

forward prototypes
public function string of_get_validacion ()
public function long of_validar_agrupada (long al_ordencorte)
public function long of_validar_oc (long al_orden_corte, ref string as_mensaje)
public function long of_permiso_mas_loteo (long al_orden_corte)
public function long of_valida_unid_duo_liquidacion (long al_cs_unir_oc)
public function long of_valida_unid_duo_loteo (long al_cs_unir_oc)
public function long of_valida_unid_duo_prog (long al_cs_unir_oc)
public function long of_prog_automatico_sin_trazo (long al_orden_corte, long al_agrupacion, long ai_paquetes)
public function long of_duo_conjunto (long al_orden_corte)
public function long of_oc_a_preliquidar (long al_oc, long ai_raya)
public function long of_prog_auto_con_trazo (long al_agrupacion, long al_orden_corte)
private subroutine of_set_password_rep_parte ()
private function string of_get_password_rep_parte ()
public function boolean of_validar_seguridad_oc (string as_pass)
end prototypes

public function string of_get_validacion ();Return is_validacion
end function

public function long of_validar_agrupada (long al_ordencorte);Long li_filas
datastore lds_referencias


lds_referencias   = Create Datastore 
lds_referencias.DataObject = 'dgr_referencias_ordencorte'
lds_referencias.SetTransObject(sqlca)


IF lds_referencias.SetTransObject(SQLCA) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n de referencias'
	Return -1
END IF

li_filas = lds_referencias.Retrieve(al_ordencorte)

DESTROY lds_referencias;

IF li_filas > 1 THEN
	Return 1
ELSE
	Return 0
END IF
end function

public function long of_validar_oc (long al_orden_corte, ref string as_mensaje);//metodo para validar la existencia de una orden de corte y su estado valido
//jcrm
//julio 31 de 2008
Long li_result


SELECT count(*)
  INTO :li_result
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_orden_corte
   AND co_estado_asigna <> 28;
	
IF sqlca.sqlcode = 100 THEN
	Return 0
END IF

IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF

Return li_result




end function

public function long of_permiso_mas_loteo (long al_orden_corte);//metodo para saber si una orden de corte puede ser loteada por mas unidades de las liquidadas, esto
//aplica para las OC cortadas por la bierrebi, ya que el sobrante de unidades esta siendo usado
//como desperdicio
//jcrm
//julio 31 de 2008
Long ll_count

SELECT count(cs_orden_corte)
  INTO :ll_count
  FROM h_unid_mas_corte
 WHERE cs_orden_corte = :al_orden_corte;
 
 
IF ll_count > 0 THEN
	Return ll_count
ELSE
	Return 0
END IF
end function

public function long of_valida_unid_duo_liquidacion (long al_cs_unir_oc);//Esta funcion verifica que las unidades liquidadas de un Duo o Conjunto sean las
//mismas en todas las tallas o con una diferencia de un % permitido
//se retorna 1 si esta bien y puede continuar, 0 si no esta correcto  o -1 si hay otro error
//jorodrig   julio 23-09

Long 		li_filas, posi,posi2
Long		li_linea_exp
String		ls_ref_exp, ls_color_exp, ls_talla_exp, ls_filtro
Long			ll_unid_min, ll_unid_liq, ll_oc, ll_oc_min, ll_color_pt
Decimal{2}	ldc_porc
datastore lds_oc_liquidadas

n_cts_constantes_corte lpo_const_corte


lds_oc_liquidadas   = Create Datastore 
lds_oc_liquidadas.DataObject = 'dtb_tallas_validar_duo_conjunto_liquida'

IF lds_oc_liquidadas.SetTransObject(SQLCA) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n de referencias'
	DESTROY lds_oc_liquidadas;
	Return -1
END IF

//	consulto el porcentaje permito en m_constantes_corte inicialmente queda e 5%
ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_ENTRE_DUOS')
If ldc_porc = -1 Then
   MessageBox('Error','No fue posible establecer el porcentaje de diferencia permitido entre duos y conjuntos.')		
	DESTROY lds_oc_liquidadas;
	Return -1
End if



li_filas = lds_oc_liquidadas.Retrieve(al_cs_unir_oc)
FOR posi = 1 TO li_filas
	li_linea_exp = lds_oc_liquidadas.GetItemNumber(posi,'co_linea_exp')
	ls_ref_exp   = lds_oc_liquidadas.GetItemString(posi,'co_ref_exp')
	ls_color_exp = lds_oc_liquidadas.GetItemString(posi,'co_color_exp')
	ls_talla_exp = lds_oc_liquidadas.GetItemString(posi,'talla_exp')
	ls_filtro = ' co_linea_exp='+string(li_linea_exp) + ' and co_ref_exp= '+"'"+ls_ref_exp+"'" + ' and co_color_exp='+"'"+ ls_color_exp +"'"+ 'and talla_exp='+"'"+ls_talla_exp+"'"
	lds_oc_liquidadas.SetFilter(ls_filtro) 
	lds_oc_liquidadas.Filter()
	//como el dw esta ordenado de menr a mayor tomo el primer valor y lo comparo con los demas
	ll_unid_min = lds_oc_liquidadas.GetItemNumber(1,'unid_liquida')
	ll_oc_min   = lds_oc_liquidadas.GetItemNumber(1,'cs_asignacion')
	FOR posi2 = 1 TO lds_oc_liquidadas.RowCount()
		ll_unid_liq = lds_oc_liquidadas.GetItemNumber(posi2,'unid_liquida')
		IF ll_unid_liq > (ll_unid_min + (ll_unid_min * (ldc_porc/100) )) THEN
			ll_oc = lds_oc_liquidadas.GetItemNumber(posi2,'cs_asignacion')
			ll_color_pt = lds_oc_liquidadas.GetItemNumber(posi2,'co_color_pt')
			
			//se va a poner el mensaje inicialmente solo informativo  julio 24 - 07
			MessageBox('Advertencia','El duo esta preliquidado con diferencia de unidades, La orden: '+string(ll_oc) + ' En la talla vtas: '+ ls_talla_exp + ' Color pt: '+string(ll_color_pt)+ &
			' Tiene mas unidades, Orden Cte con unid minimas: '+string(ll_oc_min)+' Unidades m$$HEX1$$ed00$$ENDHEX$$nimas: '+string(ll_unid_min) +' Unidades que estan por encima: '+string(ll_unid_liq))
			//Return 0
		END IF
		
	NEXT
	ls_filtro = ''
	lds_oc_liquidadas.SetFilter(ls_filtro) 
	lds_oc_liquidadas.Filter()
	
	
NEXT

DESTROY lds_oc_liquidadas;
Return 1

end function

public function long of_valida_unid_duo_loteo (long al_cs_unir_oc);//Esta funcion verifica que las unidades liquidadas de un Duo o Conjunto sean las
//mismas en todas las tallas o con una diferencia de un % permitido
//se retorna 1 si esta bien y puede continuar, 0 si no esta correcto  o -1 si hay otro error
//jorodrig   julio 23-09

Long 		li_filas, posi,posi2
Long		li_linea_exp
String		ls_ref_exp, ls_color_exp, ls_talla_exp, ls_filtro
Long			ll_unid_min, ll_unid_liq, ll_oc, ll_oc_min, ll_color_pt
Decimal{2}	ldc_porc
datastore lds_oc_loteo
n_cts_constantes_corte lpo_const_corte




lds_oc_loteo   = Create Datastore 
lds_oc_loteo.DataObject = 'dtb_tallas_validar_duo_conjunto_loteo'

IF lds_oc_loteo.SetTransObject(SQLCA) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n de carga unidades loteo'
	DESTROY lds_oc_loteo;
	Return -1
END IF

//	consulto el porcentaje permito en m_constantes_corte inicialmente queda e 5%
ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_ENTRE_DUOS')
If ldc_porc = -1 Then
   MessageBox('Error','No fue posible establecer el porcentaje de diferencia permitido entre duos y conjuntos.')		
	DESTROY lds_oc_loteo;
	Return -1
End if



li_filas = lds_oc_loteo.Retrieve(al_cs_unir_oc)
FOR posi = 1 TO li_filas
	li_linea_exp = lds_oc_loteo.GetItemNumber(posi,'co_linea_exp')
	ls_ref_exp   = lds_oc_loteo.GetItemString(posi,'co_ref_exp')
	ls_color_exp = lds_oc_loteo.GetItemString(posi,'co_color_exp')
	ls_talla_exp = lds_oc_loteo.GetItemString(posi,'talla_exp')
	ls_filtro = ' co_linea_exp='+string(li_linea_exp) + ' and co_ref_exp= '+"'"+ls_ref_exp+"'" + ' and co_color_exp='+"'"+ ls_color_exp +"'"+ 'and talla_exp='+"'"+ls_talla_exp+"'"
	lds_oc_loteo.SetFilter(ls_filtro) 
	lds_oc_loteo.Filter()
	//como el dw esta ordenado de menr a mayor tomo el primer valor y lo comparo con los demas
	ll_unid_min = lds_oc_loteo.GetItemNumber(1,'unid_loteo')
	ll_oc_min   = lds_oc_loteo.GetItemNumber(1,'cs_asignacion')
	FOR posi2 = 1 TO lds_oc_loteo.RowCount()
		ll_unid_liq = lds_oc_loteo.GetItemNumber(posi2,'unid_loteo')
		IF ll_unid_liq > (ll_unid_min + (ll_unid_min * (ldc_porc/100) )) THEN
		
			IF ll_unid_liq > ((ll_unid_min * 2) + (ll_unid_min * (ldc_porc/100) )) THEN
			
				ll_oc = lds_oc_loteo.GetItemNumber(posi2,'cs_asignacion')
				ll_color_pt = lds_oc_loteo.GetItemNumber(posi2,'co_color_pt')
				
				//se va a poner el mensaje inicialmente solo informativo  julio 24 - 07
				MessageBox('Advertencia','El duo esta lotedo con diferencia de unidades, La orden: '+string(ll_oc) + ' En la talla vtas: '+ ls_talla_exp + ' Color pt: '+string(ll_color_pt)+ &
				' Tiene mas unidades, Orden Cte con unid minimas: '+string(ll_oc_min)+' Unidades m$$HEX1$$ed00$$ENDHEX$$nimas: '+string(ll_unid_min) +' Unidades que estan por encima: '+string(ll_unid_liq))
				
				//pedir contrase$$HEX1$$f100$$ENDHEX$$a para continuar			
				//se activa el 15 de marzo 2011 por solicitud de Javier Garcia
				DESTROY lds_oc_loteo;
				//Return 0
			END IF
		END IF
		
	NEXT
	
	ls_filtro = ''
	lds_oc_loteo.SetFilter(ls_filtro) 
	lds_oc_loteo.Filter()

	
	
	
NEXT

DESTROY lds_oc_loteo;
Return 1

end function

public function long of_valida_unid_duo_prog (long al_cs_unir_oc);//Esta funcion verifica que las unidades liquidadas de un Duo o Conjunto sean las
//mismas en todas las tallas o con una diferencia de un % permitido
//se retorna 1 si esta bien y puede continuar, 0 si no esta correcto  o -1 si hay otro error
//jorodrig   julio 23-09

Long 		li_filas, posi,posi2
Long		li_linea_exp
String		ls_ref_exp, ls_color_exp, ls_talla_exp, ls_filtro
Long			ll_unid_min, ll_unid_prog, ll_oc, ll_oc_min, ll_color_pt
Decimal{2}	ldc_porc
datastore lds_oc_prog
n_cts_constantes_corte lpo_const_corte



lds_oc_prog   = Create Datastore 
lds_oc_prog.DataObject = 'dtb_tallas_validar_duo_conjunto_programa'

IF lds_oc_prog.SetTransObject(SQLCA) = -1 THEN
	MessageBox('Advertencia','Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n de referencias')
	Destroy lds_oc_prog;
	Return -1
END IF

//	consulto el porcentaje permito en m_constantes_corte inicialmente queda e 5%
ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_ENTRE_DUOS')
If ldc_porc = -1 Then
   MessageBox('Error','No fue posible establecer el porcentaje de diferencia permitido entre duos y conjuntos.')		
	Destroy lds_oc_prog;
	Return -1
End if



li_filas = lds_oc_prog.Retrieve(al_cs_unir_oc)
FOR posi = 1 TO li_filas
	li_linea_exp = lds_oc_prog.GetItemNumber(posi,'co_linea_exp')
	ls_ref_exp   = lds_oc_prog.GetItemString(posi,'co_ref_exp')
	ls_color_exp = lds_oc_prog.GetItemString(posi,'co_color_exp')
	ls_talla_exp = lds_oc_prog.GetItemString(posi,'talla_exp')
	ls_filtro = 'co_linea_exp='+string(li_linea_exp) + ' and co_ref_exp= '+"'"+ls_ref_exp+"'" + ' and co_color_exp='+"'"+ ls_color_exp +"'"+ 'and talla_exp='+"'"+ls_talla_exp+"'"
	lds_oc_prog.SetFilter(ls_filtro) 
	lds_oc_prog.Filter()
	//como el dw esta ordenado de menr a mayor tomo el primer valor y lo comparo con los demas
	ll_unid_min = lds_oc_prog.GetItemNumber(1,'unid_calculadas')
	ll_oc_min   = lds_oc_prog.GetItemNumber(1,'cs_asignacion')
	FOR posi2 = 1 TO lds_oc_prog.RowCount()
		ll_unid_prog = lds_oc_prog.GetItemNumber(posi2,'unid_calculadas')
		IF ll_unid_prog > (ll_unid_min + (ll_unid_min * (ldc_porc/100) )) THEN
			ll_oc = lds_oc_prog.GetItemNumber(posi2,'cs_asignacion')
			ll_color_pt = lds_oc_prog.GetItemNumber(posi2,'co_color_pt')
			
			//se va a poner el mensaje inicialmente solo informativo  julio 24 - 07
			MessageBox('Advertencia','El duo esta programando con diferencia de unidades, La orden: '+string(ll_oc) + ' En la talla vtas: '+ ls_talla_exp + ' Color pt: '+string(ll_color_pt)+ &
			' Tiene mas unidades, Orden Cte con unid minimas: '+string(ll_oc_min)+' Unidades m$$HEX1$$ed00$$ENDHEX$$nimas: '+string(ll_unid_min) +' Unidades que estan por encima: '+string(ll_unid_prog))
			//Return 0
		END IF
		
	NEXT
	ls_filtro = ''
	lds_oc_prog.SetFilter(ls_filtro) 
	lds_oc_prog.Filter()
	
	
	
NEXT

Destroy lds_oc_prog;
Return 1

end function

public function long of_prog_automatico_sin_trazo (long al_orden_corte, long al_agrupacion, long ai_paquetes);//funcion para programar una orden de corte sin trazos, asignando
//el trazo 0, y e paquetes se carga con lo que este definido
//en el momento para la bierrebi (inicialmente 2 paquetes)
//jorodrig   sep 16 - 09
Long	ll_filas, posi, li_row
Long	li_cs_base_trazos, li_cs_pdn, li_talla, li_co_fab_te, li_caract,li_diametro
Long	li_raya, li_paquetes, li_capas, li_cs_trazo, li_raya_ant, li_talla_ant
LONG		ll_modelo, ll_reftel, ll_unidades, ll_color_te
DATETIME	ldt_fe_hoy
STRING	ls_usuario, ls_instancia,ls_sqlerr
datastore lds_mod_sin_trazo, lds_dt_trazosxbase




lds_mod_sin_trazo = Create Datastore
lds_mod_sin_trazo.DataObject = 'ds_cargar_modelos_prog_auto_sin_trazo'
IF lds_mod_sin_trazo.SetTransObject(SQLCA) = -1 THEN
	MessageBox('Error','Error al definir el registro para traer los modelos a cargar')
	DESTROY lds_mod_sin_trazo;
	DESTROY lds_dt_trazosxbase;
	Return -1
END IF

lds_dt_trazosxbase = Create Datastore
lds_dt_trazosxbase.DataObject = 'ds_dt_trazosxbase'
IF lds_dt_trazosxbase.SetTransObject(SQLCA) = -1 THEN
	MessageBox('Error','Error al definir el registro para cargar los modelos4')
	DESTROY lds_mod_sin_trazo;
	DESTROY lds_dt_trazosxbase;
	Return -1
END IF

ldt_fe_hoy =  Datetime(f_fecha_servidor())
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia

li_cs_trazo = 0
li_raya_ant = 0
li_talla_ant = -1
//traer los modelos que forman la orden de corte para colocar el trazo 0
//y en la raya 10 colocar los paq definidos en el argumento
ll_filas = lds_mod_sin_trazo.Retrieve(al_agrupacion)
IF ll_filas > 0 THEN
	FOR posi = 1 TO ll_filas
		
		
		//traer los datos
		li_cs_base_trazos = lds_mod_sin_trazo.GetItemNumber(posi,'cs_base_trazos')
		li_cs_pdn 			= lds_mod_sin_trazo.GetItemNumber(posi,'cs_pdn')
		li_talla				= lds_mod_sin_trazo.GetItemNumber(posi,'co_talla')
		ll_modelo			= lds_mod_sin_trazo.GetItemNumber(posi,'co_modelo')
		li_co_fab_te		= lds_mod_sin_trazo.GetItemNumber(posi,'co_fabrica_te')
		ll_reftel			= lds_mod_sin_trazo.GetItemNumber(posi,'co_reftel')
		li_caract			= lds_mod_sin_trazo.GetItemNumber(posi,'co_caract')
		li_diametro 		= lds_mod_sin_trazo.GetItemNumber(posi,'diametro')
		ll_color_te			= lds_mod_sin_trazo.GetItemNumber(posi,'co_color_te')
		ll_unidades			= lds_mod_sin_trazo.GetItemNumber(posi,'ca_unidades')
		li_raya				= lds_mod_sin_trazo.GetItemNumber(posi,'raya')

		IF li_raya = 10 THEN
			li_paquetes = ai_paquetes
		ELSE
			li_paquetes = ll_unidades
		END IF
		li_capas = ll_unidades / li_paquetes
		
		//se realiza este calculo para cuando en una raya se tiene mas de una talla,
		//en ese caso cada talla debe quedar con un espacio diferente (cs_trazo)
		IF li_raya <> li_raya_ant THEN
			li_cs_trazo = 1
		ELSE
			IF li_talla <> li_talla_ant THEN
				li_cs_trazo = li_cs_trazo + 1 
			END IF
		END IF
		
		
		li_row = lds_dt_trazosxbase.InsertRow(0)
		lds_dt_trazosxbase.SetItem(li_row,'cs_orden_corte',al_orden_corte)
		lds_dt_trazosxbase.SetItem(li_row,'cs_agrupacion',al_agrupacion)
		lds_dt_trazosxbase.SetItem(li_row,'cs_base_trazos',li_cs_base_trazos)
		lds_dt_trazosxbase.SetItem(li_row,'cs_trazo',li_cs_trazo)
		lds_dt_trazosxbase.SetItem(li_row,'cs_seccion',1)
		lds_dt_trazosxbase.SetItem(li_row,'cs_pdn',li_cs_pdn)		
		lds_dt_trazosxbase.SetItem(li_row,'co_talla',li_talla)
		lds_dt_trazosxbase.SetItem(li_row,'co_modelo',ll_modelo)
		lds_dt_trazosxbase.SetItem(li_row,'co_fabrica_te',li_co_fab_te)
		lds_dt_trazosxbase.SetItem(li_row,'co_reftel',ll_reftel)
		lds_dt_trazosxbase.SetItem(li_row,'co_caract',li_caract)
		lds_dt_trazosxbase.SetItem(li_row,'diametro',li_diametro)		
		lds_dt_trazosxbase.SetItem(li_row,'co_color_te',ll_color_te)
		lds_dt_trazosxbase.SetItem(li_row,'ca_paquetes',li_paquetes)
		lds_dt_trazosxbase.SetItem(li_row,'capas',li_capas)
		lds_dt_trazosxbase.SetItem(li_row,'ca_programadas',ll_unidades)
		lds_dt_trazosxbase.SetItem(li_row,'ca_resulta',0)
		lds_dt_trazosxbase.SetItem(li_row,'co_trazo',0)		
		lds_dt_trazosxbase.SetItem(li_row,'ca_disponibles',ll_unidades)		
		lds_dt_trazosxbase.SetItem(li_row,'co_estado',1)		
		lds_dt_trazosxbase.SetItem(li_row,'co_tipo',2)		
		lds_dt_trazosxbase.SetItem(li_row,'sw_retazos',2)		
		lds_dt_trazosxbase.SetItem(li_row,'fe_creacion',ldt_fe_hoy)		
		lds_dt_trazosxbase.SetItem(li_row,'fe_actualizacion',ldt_fe_hoy)		
		lds_dt_trazosxbase.SetItem(li_row,'usuario',ls_usuario)		
		lds_dt_trazosxbase.SetItem(li_row,'instancia',ls_instancia)		
		lds_dt_trazosxbase.SetItem(li_row,'cs_ordenpdn',1)		

	   li_talla_ant = li_talla
		li_raya_ant = li_raya
	NEXT
	
ELSE
	MessageBox('Advertencia','No se encontraron registros para cargar la programacion')
	DESTROY lds_mod_sin_trazo;
	DESTROY lds_dt_trazosxbase;
	Return -1
END IF

lds_dt_trazosxbase.AcceptText()

//----------------------------------- graba dw_pdnagrupa
If lds_dt_trazosxbase.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo grabar los modelos sin trazo  " + ls_sqlerr )
	DESTROY lds_mod_sin_trazo;
	DESTROY lds_dt_trazosxbase;
	Return -1
End If

return 1




end function

public function long of_duo_conjunto (long al_orden_corte);//metodo para establecer si una orden de corte fue liberada como duo o conjunto, esto con el fin de informar
//al usuario de las demas ordenes de corte que componen dicho duo o conjunto
//jcrm - jorodrig
//octubre  6 de 2008
Long ll_unir_oc

//
//DISCONNECT;
//SQLCA.Lock = "DIRTY READ"
//CONNECT USING SQLCA;

SELECT MAX(cs_unir_oc)
  INTO :ll_unir_oc
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_orden_corte
   AND co_estado_asigna <> 28
   AND cs_unir_oc > 1;
	
//DISCONNECT;
//SQLCA.Lock = "Cursor Stability"
//CONNECT USING SQLCA;
//	
	
If IsNull(ll_unir_oc)  THEN
	ll_unir_oc = 0
END IF
	
Return ll_unir_oc	

end function

public function long of_oc_a_preliquidar (long al_oc, long ai_raya);//funcion que dada la oc-raya valida si es la que debe preliquidar segun el orden del pdp de las 
//oc en extendido

//si se manda raya en cero solo consulta la maquina por o.c
//RETORNA -1 si hay algun error o si la oc mandada no coincide con la oc a preliquidar segun orden del pdp
//RETORNA 1 si esta preliquidando la oc que es la correcta segun el orden del pdp

Long ll_maquina, ll_estado, ll_oc_a_preliquidar, ll_registros
INteger	li_estado_oc

datastore lds_consulta_maquina_oc_raya, lds_consulta_oc_a_preliquidar, lds_consulta_estado_oc, lds_consulta_oc_preliquidada

//consulta la maquina O.C-Raya
lds_consulta_maquina_oc_raya = Create datastore
lds_consulta_maquina_oc_raya.DataObject = 'dtb_consulta_maquina_por_oc_raya'
lds_consulta_maquina_oc_raya.settransobject(gnv_recursos.of_get_transaccion_sucia())

//consulta la O.C a preliquidar segun orden del pdp
lds_consulta_oc_a_preliquidar = Create datastore
lds_consulta_oc_a_preliquidar.DataObject = 'dtb_oc_a_preliquidar'
lds_consulta_oc_a_preliquidar.settransobject(gnv_recursos.of_get_transaccion_sucia())

//consulta el estado de la O.C
lds_consulta_estado_oc = Create datastore
lds_consulta_estado_oc.DataObject = 'dtb_estado_oc'
lds_consulta_estado_oc.settransobject(gnv_recursos.of_get_transaccion_sucia())

//consulta si la O.C ya fue preliquidada
lds_consulta_oc_preliquidada = Create datastore
lds_consulta_oc_preliquidada.DataObject = 'dtb_consulta_preliquidacion'
lds_consulta_oc_preliquidada.settransobject(gnv_recursos.of_get_transaccion_sucia())

SELECT MAX(co_estado_asigna)
  INTO :li_estado_oc
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_oc;
IF li_estado_oc = 28 THEN
	MessageBox('Error',"La Orden de Corte se encuentra Anulada",StopSign!)
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	Return -1
END IF
 

//valida que traiga la maquina referenciada en la oc
IF lds_consulta_maquina_oc_raya.retrieve(al_oc,ai_raya) <= 0 THEN
	ai_raya = 0
	IF lds_consulta_maquina_oc_raya.retrieve(al_oc,ai_raya) <= 0 THEN
		MessageBox('Error',"Al traer la maquina de la oc",StopSign!)
		DESTROY lds_consulta_maquina_oc_raya;
		DESTROY lds_consulta_oc_a_preliquidar;
		DESTROY lds_consulta_estado_oc;
		DESTROY lds_consulta_oc_preliquidada;
		Return -1
	END IF
END IF

//valida que si la O.C esta en estado 14 lo deje continuar
IF lds_consulta_estado_oc.retrieve(al_oc, ai_raya) <= 0 THEN
	MessageBox('Error',"Al traer estado de la oc",StopSign!)
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	Return -1
END IF

ll_estado = lds_consulta_estado_oc.getitemnumber(1,"estado")

//si el estado es 14 lo deja continuar
IF ll_estado = 14 THEN
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	RETURN 1
END IF

ll_maquina = lds_consulta_maquina_oc_raya.getitemnumber(1,"co_maquina")
ll_estado  = 13 //extendido 

//valida que traiga la oc a preliquidar segun el orden del pdp para la maquina dada
//con el estado 13
IF lds_consulta_oc_a_preliquidar.retrieve(ll_maquina,ll_estado) < 0 THEN
	MessageBox('Error',"Al traer la oc a preliquidar",StopSign!)
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	Return -1
END IF

IF lds_consulta_oc_a_preliquidar.retrieve(ll_maquina,ll_estado) = 0 THEN
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	RETURN 1
END IF 

IF lds_consulta_oc_preliquidada.retrieve(al_oc) < 0 THEN
	MessageBox('Error',"Al traer al consultar preliquidacion",StopSign!)
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	Return -1
END IF

//si fue preliquidada algun espacio lo deja pasar
ll_registros = lds_consulta_oc_preliquidada.getitemnumber(1,"registros")
IF ll_registros > 0 THEN
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
	RETURN 1
END IF

ll_oc_a_preliquidar = lds_consulta_oc_a_preliquidar.getitemnumber(1,"pedido")

IF ll_oc_a_preliquidar <> al_oc THEN
	DESTROY lds_consulta_maquina_oc_raya;
	DESTROY lds_consulta_oc_a_preliquidar;
	DESTROY lds_consulta_estado_oc;
	DESTROY lds_consulta_oc_preliquidada;
  	Return -1
END IF

DESTROY lds_consulta_maquina_oc_raya;
DESTROY lds_consulta_oc_a_preliquidar;
DESTROY lds_consulta_estado_oc;
DESTROY lds_consulta_oc_preliquidada;

RETURN 1
end function

public function long of_prog_auto_con_trazo (long al_agrupacion, long al_orden_corte);
//Esta funcion realiza el proceso automatico de cargar los trazos a la orden
//de corte y repartir las capas en los espacios segun la cantidad maxima permitida
//por tela
//realizado por jorodrig   nov 17 - 09

//se coloca una marca en dt_pdnxmodulo, en el campo metodo_programa se maneja con 3 para identificar
//las ordenes de corte que se programan automaticamente
//jorodrig enero 13 - 10

Long		ll_filas, posi, li_filas2, posi2, posi3, ll_i
Long		li_raya, li_max_capas, li_paquetes, li_espacios,  li_capas, li_base_trazo, li_seccion
Long		li_fab, li_carac, li_diamt, li_talla, li_capas_prog, li_fabrica, li_linea
Long		li_kte_pqte,li_sobrante, li_seccion_ini_trzo, li_existe, li_proceso_corte
LONG			ll_trazo, ll_ref, ll_modelo, ll_unidprog, ll_estilo, ll_trazo_ant, ll_co_color_te, ll_pdn
DATETIME		ldt_fe_hoy
STRING		ls_usuario, ls_instancia, ls_sqlerr
datastore ld_lista_base_rayasxbase_v2, ld_lista_trazos_tallasxtrazo_v3



ld_lista_base_rayasxbase_v2 = Create Datastore 
ld_lista_base_rayasxbase_v2.DataObject = 'd_lista_base_rayasxbase_v2_1'
IF ld_lista_base_rayasxbase_v2.SetTransObject(SQLCA) = -1 THEN
	MessageBox('Error','Error al definir el registro para traer los modelos a cargar')
	Return -1
END IF

ld_lista_trazos_tallasxtrazo_v3 = Create Datastore
ld_lista_trazos_tallasxtrazo_v3.DataObject = 'd_lista_trazos_tallasxtrazo_v3'
IF ld_lista_trazos_tallasxtrazo_v3.SetTransObject(SQLCA) = -1 THEN
	MessageBox('Error','Error al definir el registro para traer las tallas para los modelos a cargar')
	Return -1
END IF


ldt_fe_hoy =  Datetime(f_fecha_servidor())
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia


//Antes de realizar el proceso se verifica si  no se ha insertado nada en la tabla
//que se carga en este proceso, si ya tiene registros no se puede realizar el proceso
//automatico   dic 22-09  jorodrig
SELECT COUNT(*)
  INTO :li_existe
  FROM dt_trazosxbase
 WHERE cs_orden_corte = :al_orden_corte;
IF SQLCA.SQLCODE = -1 THEN
	MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error verificando si ya esta programada la Or1den de Corte')
	DESTROY ld_lista_base_rayasxbase_v2;
	DESTROY ld_lista_trazos_tallasxtrazo_v3;
	Return 0
END IF
IF li_existe > 0 THEN
	MessageBox('Advertencia','No se puede realizar la programacion automatica, pues ya existen programacion de trazos x talla, programe manualmente')
	DESTROY ld_lista_base_rayasxbase_v2;
	DESTROY ld_lista_trazos_tallasxtrazo_v3;
	Return 0
END IF


ll_filas = ld_lista_base_rayasxbase_v2.Retrieve(al_agrupacion,al_orden_corte)
IF ll_filas > 0 THEN
	FOR posi = 1 TO ll_filas
		
		//traer los datos
		li_raya		   = ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'raya')
		li_max_capas   = ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'capas')
		li_base_trazo 	= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'cs_base_trazos')
		li_fab   		= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'co_fabrica_te')
		ll_ref    		= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'co_reftel')
		li_carac  		= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'co_caract')
		li_diamt  		= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'diametro')
		li_base_trazo	= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'cs_base_trazos')
		ll_co_color_te	= ld_lista_base_rayasxbase_v2.GetItemNumber(posi,'co_color_te')
		ll_modelo		= ld_lista_base_rayasxbase_v2.GetItemNumber(posi, 'co_modelo')
		li_fabrica		= ld_lista_base_rayasxbase_v2.GetItemNumber(posi, 'co_fabrica')
		li_linea       = ld_lista_base_rayasxbase_v2.GetItemNumber(posi, 'co_linea')
		ll_estilo      = ld_lista_base_rayasxbase_v2.GetItemNumber(posi, 'co_referencia')
		li_proceso_corte      = ld_lista_base_rayasxbase_v2.GetItemNumber(posi, 'sw_proceso_corte')
		
		
		//en la raya 10 los paquetes como kte son 2 en las demas es 1
		IF li_raya = 10 THEN 
			li_kte_pqte = 1
		ELSE
			li_kte_pqte = 1
		END IF 
		
		li_filas2 =	ld_lista_trazos_tallasxtrazo_v3.Retrieve(al_agrupacion, li_raya,li_fabrica,li_linea,ll_estilo)
		li_seccion = 0
		li_seccion_ini_trzo = 1
		ll_trazo_ant = -1
		
		IF li_filas2 > 0 THEN
			//se carga cada uno de los trazos que se asignaron a la orden de corte
			FOR posi2 = 1 TO li_filas2
				li_paquetes = ld_lista_trazos_tallasxtrazo_v3.GetItemNumber(posi2,'ca_paquetes')
				ll_trazo = ld_lista_trazos_tallasxtrazo_v3.GetItemNumber(posi2,'co_trazo')
				li_talla = ld_lista_trazos_tallasxtrazo_v3.GetItemNumber(posi2,'co_talla')
				li_capas_prog = ld_lista_trazos_tallasxtrazo_v3.GetItemNumber(posi2,'ca_capas')
				ll_pdn  			= ld_lista_trazos_tallasxtrazo_v3.GetItemNumber(posi2,'cs_pdn')
				IF ll_trazo <> ll_trazo_ant THEN
					li_seccion = posi2
					li_seccion_ini_trzo = li_seccion
				ELSE
					li_seccion = li_seccion_ini_trzo
				END IF
							
				IF li_capas_prog > li_max_capas THEN
					li_espacios = ceiling(li_capas_prog / li_max_capas)
					IF li_espacios > 3 THEN
						IF MessageBox("Verificacion", "La Orden de corte en la raya: "+string(li_raya)+" va a quedar con: "+Trim(string(li_espacios))+ " espacios, esta seguro de continuar?", Question!, YesNo!, 2) = 2 THEN
							DESTROY ld_lista_base_rayasxbase_v2;
							DESTROY ld_lista_trazos_tallasxtrazo_v3;
							Return -1
						END IF
					END IF
					
					li_capas = li_capas_prog / li_espacios
					//se va a utilizar la variable sobrante para cuando  las capas programdas no son pares
					//para que el ultimo espacio lleve la capa de mas que queda faltando  
					//ej  77  capas prog, al divir queda con 38 por espacio al ultimo espacio le ponemos 39
					li_sobrante = mod(li_capas_prog,li_espacios)
				ELSE
					li_espacios = 1
					li_capas = li_capas_prog
				END IF
				FOR posi3 = 1 TO li_espacios
					
					//si es el ultimo espacio le sumamos la capa que faltaba por no se par lo prog.
					IF posi3 = li_espacios THEN li_capas = li_capas + li_sobrante
					ll_unidprog = li_capas * li_paquetes
						
					//inserta en la tabla dt_trazosxbase
					
					INSERT INTO dt_trazosxbase  
							 ( cs_orden_corte,cs_agrupacion,cs_base_trazos,cs_trazo,cs_seccion,   
								cs_pdn, co_talla,co_modelo,co_fabrica_te,co_reftel,co_caract,   
								diametro,co_color_te,ca_paquetes,capas,ca_programadas,ca_resulta,   
								co_trazo,ca_disponibles,co_estado,co_tipo,sw_retazos,fe_creacion,
								fe_actualizacion,usuario,instancia, cs_ordenpdn)  
					   VALUES ( :al_orden_corte,:al_agrupacion,:li_base_trazo,:li_seccion,:li_seccion,:ll_pdn,   
								:li_talla,:ll_modelo,:li_fab,:ll_ref,:li_carac,:li_diamt,:ll_co_color_te,   
								:li_paquetes,:li_capas,:ll_unidprog,0,:ll_trazo,0,1,3,2,   
								current,current,user,sitename, :posi )  ;
		
					IF Sqlca.SqlCode = -1 Then
						ls_sqlerr = Sqlca.SqlErrText
						ROLLBACK ; 
						MessageBox("Advertencia!","No se pudo recuperar el consecutivo de la seccion.~n~n~nNota: " + ls_sqlerr)
						DESTROY ld_lista_base_rayasxbase_v2;
						DESTROY ld_lista_trazos_tallasxtrazo_v3;
						RETURN -1
					END IF
					li_seccion = li_seccion + 1
				NEXT	
				ll_trazo_ant = ll_trazo
				
			NEXT
		ELSE
			//no se programaron trazos, se programa manual
			
			IF li_raya = 10 AND li_proceso_corte <> 0 THEN //se define que para lo diferente a raya 10 los paquetes pueden ser el total de unidades para que las capas sean las mismas   enero 13 / 2010 jorodrig   define con fasernap
				INSERT INTO dt_trazosxbase  
					 ( cs_orden_corte,cs_agrupacion,cs_base_trazos,cs_trazo,cs_seccion,   
						cs_pdn, co_talla,co_modelo,co_fabrica_te,co_reftel,co_caract,   
						diametro,co_color_te,ca_paquetes,capas,ca_programadas,ca_resulta,   
						co_trazo,ca_disponibles,co_estado,co_tipo,sw_retazos,fe_creacion,
						fe_actualizacion,usuario,instancia, cs_ordenpdn)  
				SELECT :al_orden_corte, :al_agrupacion, :li_base_trazo, 1, 1, cs_pdn, co_talla,  
						:ll_modelo, :li_fab, :ll_ref, :li_carac, :li_diamt, :ll_co_color_te,  
						:li_kte_pqte, (ca_unidades/:li_kte_pqte) , ca_unidades, 0, 0, 0, 1,3,2,
						current,current,user,sitename, :posi
				  FROM dt_escalaxpdnbase
				 WHERE cs_agrupacion = :al_agrupacion
					AND cs_base_trazos = :li_base_trazo;
			ELSE
				INSERT INTO dt_trazosxbase  
				 ( cs_orden_corte,cs_agrupacion,cs_base_trazos,cs_trazo,cs_seccion,   
					cs_pdn, co_talla,co_modelo,co_fabrica_te,co_reftel,co_caract,   
					diametro,co_color_te,ca_paquetes,capas,ca_programadas,ca_resulta,   
					co_trazo,ca_disponibles,co_estado,co_tipo,sw_retazos,fe_creacion,
					fe_actualizacion,usuario,instancia, cs_ordenpdn)  
				SELECT :al_orden_corte, :al_agrupacion, :li_base_trazo, 1, 1, cs_pdn, co_talla,  
						 :ll_modelo, :li_fab, :ll_ref, :li_carac, :li_diamt, :ll_co_color_te,  
						 ca_unidades, 1 , ca_unidades, 0, 0, 0, 1,3,2,
						 current,current,user,sitename, :posi
				  FROM dt_escalaxpdnbase
				 WHERE cs_agrupacion = :al_agrupacion
					AND cs_base_trazos = :li_base_trazo;
			END IF
			
			IF Sqlca.SqlCode = -1 THEN
				ls_sqlerr = Sqlca.SqlErrText
				ROLLBACK ; 
				MessageBox("Advertencia!","No se pudo recuperar el consecutivo de la seccion.~n~n~nNota: " + ls_sqlerr)
				DESTROY ld_lista_base_rayasxbase_v2;
				DESTROY ld_lista_trazos_tallasxtrazo_v3;
				RETURN -1
			END IF
			
		END IF
		
	NEXT
ELSE
	MessageBox('Advertencia','No se carg$$HEX2$$f3002000$$ENDHEX$$toda la informacion de las rayas, probablemente no estan creadas las capas por tela')
	DESTROY ld_lista_base_rayasxbase_v2;
	DESTROY ld_lista_trazos_tallasxtrazo_v3;
	Return 0
END IF

UPDATE dt_pdnxmodulo  
   SET (co_estado_asigna, metodo_programa) = (7, 3)
 WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
		 ( dt_pdnxmodulo.co_fabrica = 2 ) AND  
		 ( dt_pdnxmodulo.co_planta = 2 ) AND  
		 ( dt_pdnxmodulo.cs_asignacion = :al_orden_corte ) AND
		 ( dt_pdnxmodulo.co_estado_asigna <> 9 );
		
IF Sqlca.SqlCode = -1 THEN
	ls_sqlerr = Sqlca.SqlErrText
	ROLLBACK ; 
	MessageBox("Advertencia!","No se pudo actualizar el programa de corte.~n~n~nNota: " + ls_sqlerr)
	DESTROY ld_lista_base_rayasxbase_v2;
	DESTROY ld_lista_trazos_tallasxtrazo_v3;
	RETURN -1
END IF

DESTROY ld_lista_base_rayasxbase_v2;
DESTROY ld_lista_trazos_tallasxtrazo_v3;

RETURN 1
end function

private subroutine of_set_password_rep_parte ();/********************************************************************
SA53209 - of_set_PASSWORD_REP_PARTE - Ceiba/JJ - 22-07-2015
Description: Permite cargar el valor de la constante PASSWORD_REP_PARTE
<RETURN> No aplica, para acceder al valor usar of_get_PASSWORD_REP_PARTE </RETURN> 
<ACCESS> Private 
<ARGS> None	</ARGS> 
********************************************************************/
n_cts_constantes_tela luo_constantes
is_PASSWORD_REP_PARTE = luo_constantes.of_consultar_texto("PASSWORD_REP_PARTE")
end subroutine

private function string of_get_password_rep_parte ();/********************************************************************
SA53209 - of_set_PASSWORD_REP_PARTE - Ceiba/JJ - 22-07-2015
Description: devuelve el valor de la constante PASSWORD_REP_PARTE
<RETURN> No aplica, para setear el valor usar of_set_PASSWORD_REP_PARTE </RETURN> 
<ACCESS> Private 
<ARGS> None	</ARGS> 
********************************************************************/

RETURN trim(is_PASSWORD_REP_PARTE)
end function

public function boolean of_validar_seguridad_oc (string as_pass);/********************************************************************
SA53209 - of_validar_seguridad_oc - Ceiba/JJ - 22-07-2015
Description: Se valida validar que el usuario haya ingresado la contrase$$HEX1$$f100$$ENDHEX$$a correcta 
<RETURN> No aplica, para acceder al valor usar of_get_PASSWORD_REP_PARTE </RETURN> 
<ACCESS> Private 
<ARGS> None	</ARGS> 
********************************************************************/
of_set_password_rep_parte()
//comparar las claves
IF TRIM(as_pass) <> TRIM(is_PASSWORD_REP_PARTE) THEN RETURN FALSE
RETURN TRUE
end function

on n_cst_orden_corte.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_orden_corte.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

