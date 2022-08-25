HA$PBExportHeader$n_cts_particion.sru
forward
global type n_cts_particion from nonvisualobject
end type
end forward

global type n_cts_particion from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_determinarcsliberacion (long ai_fabexp, ref long ll_liberacion)
public function long of_cargarhliberarescalas (long ai_fabexp, long al_liberacion, long al_liberacion_old)
public function long of_tallas (long ai_simulacion, long ai_fab, long ai_planta, long ai_modulo, long ai_fabexp, long al_liberacion, string as_po, string as_cut, long ai_fabpt, long ai_linea, long al_ref, long al_color_pt, string as_tono, long ai_particion, long al_liberacion_new)
public function long of_generar_particion (long ai_simulacion, long ai_fab, long ai_planta, long ai_modulo, long ai_fabexp, long al_liberacion, string as_po, string as_cut, long ai_fabpt, long ai_linea, long al_ref, long al_color_pt, string as_tono, long ai_particion, long al_cantidad, long al_cant_prog)
public function long of_cargardtliberaestilos (long ai_fabexp, long al_liberacion, long al_liberacion_old, long ai_particion, string as_po, string as_cut)
public function long of_cargardttelaxmodelo_lib (long ai_fabexp, long al_liberacion, long al_liberacion_old, long ai_particion, string as_po, string as_cut)
public function long of_cargartdtescalasxtela (long ai_fabexp, long al_liberacion, long al_liberacion_old, long ai_particion, string as_po, string as_cut)
public function long of_actualizar_dtescalasxtela (long ai_fabexp, long al_liberacion, string as_po, string as_cut)
public function long of_actualizar_dtliberaestilos (long ai_fabexp, long al_liberacion, string as_po, string as_cut)
public function long of_actualizar_dttelaxmodelolib (long ai_fabexp, long al_liberacion, string as_po, string as_cut)
public function long of_actualizar_dtrolloslibera (long ai_fabexp, long al_liberacion_old, long al_liberacion_new, string as_po, string as_cut)
public function long of_actualizar_dtrolloslibera_rectilineas (long ai_fabexp, long al_liberacion_old, long al_liberacion_new, string as_po, string as_cut)
end prototypes

public function long of_determinarcsliberacion (long ai_fabexp, ref long ll_liberacion);SELECT nvl(Max(cs_liberacion),0) + 1
INTO :ll_liberacion
FROM h_liberar_escalas
WHERE co_fabrica_exp = :ai_fabexp;

IF SQLCA.SQLCode = -1 THEN
	MessageBox('Error','Error al consultar el consecutivo. ' + SQLCA.SQLErrText)
	Return -1
END IF

Return 0
end function

public function long of_cargarhliberarescalas (long ai_fabexp, long al_liberacion, long al_liberacion_old);u_ds_base lds_escalas
DateTime ldt_fecha

lds_escalas 		= Create u_ds_base
lds_escalas.DataObject 		= 'ds_h_liberar_escalas'  
lds_escalas.SetTransObject(SQLCA)

//-----------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_escalas.Retrieve(ai_fabexp,al_liberacion_old)

lds_escalas.RowsCopy(1,1, Primary!, lds_escalas, lds_escalas.RowCount() + 1, Primary!)

//--------------------modifico los campos para generar la nueva particion
lds_escalas.AcceptText()

lds_escalas.SetItem(lds_escalas.RowCount(), "fe_creacion", ldt_fecha)
lds_escalas.SetItem(lds_escalas.RowCount(), "fe_actualizacion", ldt_fecha)
lds_escalas.SetItem(lds_escalas.RowCount(), "usuario", gstr_info_usuario.codigo_usuario)
lds_escalas.SetItem(lds_escalas.RowCount(), "instancia", gstr_info_usuario.instancia)
lds_escalas.SetItem(lds_escalas.RowCount(), "cs_liberacion", al_liberacion)

IF lds_escalas.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar h_liberacion_escalas. '+ Sqlca.SqlErrText)
	Return -1
END IF


Return 0
end function

public function long of_tallas (long ai_simulacion, long ai_fab, long ai_planta, long ai_modulo, long ai_fabexp, long al_liberacion, string as_po, string as_cut, long ai_fabpt, long ai_linea, long al_ref, long al_color_pt, string as_tono, long ai_particion, long al_liberacion_new);Long li_result
s_base_parametros lstr_parametros
n_cts_tallas_particion lpo_tallas

lpo_tallas = Create n_cts_tallas_particion

lstr_parametros.entero[1] = ai_simulacion
lstr_parametros.entero[2] = ai_fab
lstr_parametros.entero[3] = ai_planta
lstr_parametros.entero[4] = ai_modulo
lstr_parametros.entero[5] = ai_fabexp
lstr_parametros.entero[6] = al_liberacion
lstr_parametros.cadena[1] = as_po
lstr_parametros.cadena[2] = as_cut
lstr_parametros.entero[7] = ai_fabpt
lstr_parametros.entero[8] = ai_linea
lstr_parametros.entero[9] = al_ref
lstr_parametros.entero[10] = al_color_pt
lstr_parametros.cadena[3] = as_tono
lstr_parametros.entero[11] = ai_particion
lstr_parametros.entero[12] = ai_particion + 1
lstr_parametros.entero[13] = al_liberacion_new


If lpo_tallas.of_inicio(lstr_parametros) = -1 THEN
	Return -1
ELSE
	Return 0
END IF

//OpenWithParm(w_tallas_particion, lstr_parametros)

//lstr_parametros = message.PowerObjectParm	

//IF lstr_parametros.hay_parametros = true THEN
//	Return 0
//ELSE
//	Return -1
//END IF
//


end function

public function long of_generar_particion (long ai_simulacion, long ai_fab, long ai_planta, long ai_modulo, long ai_fabexp, long al_liberacion, string as_po, string as_cut, long ai_fabpt, long ai_linea, long al_ref, long al_color_pt, string as_tono, long ai_particion, long al_cantidad, long al_cant_prog);u_ds_base lds_talla, lds_pro, lds_talla_cant
Decimal{2} ldc_vlr_talla
Long ll_fila, ll_cantalla, ll_liberacion, ll_talla_old, ll_i, ll_cant_talla, ll_cant_sum, ll_talla_new, ll_ii,&
	  ll_resta, ll_cantottalla, ll_fin	
Long li_talla, li_particion, li_priori
s_base_parametros lst_talla, lst_porcentaje, lstr_parametros, lst_talla_cant

lds_talla 		= Create u_ds_base
lds_pro 	 		= Create u_ds_base
lds_talla_cant = Create u_ds_base

//-----------------asigno los objectos a las dw de dt_pdnxmodulo y dt_talla_pdnmodulo
lds_talla.DataObject 		= 'd_lista_talla_produccion'  //---- dt_talla_pdnmodulo con where datos de pdn
lds_pro.DataObject   		= 'd_lista_produccion_vesa'    //dt_pdnxmodulo con where datos de pdn
lds_talla_cant.DataObject  = 'd_talla_cant'

lds_pro.SetTransObject(SQLCA)
lds_talla.SetTransObject(SQLCA)
lds_talla_cant.SetTransObject(SQLCA)

//se tiene la cantidad inicial y la cantidad de la particion, la diferencia de estas nos da la cantidad con la que
//debe quedar la partici$$HEX1$$f300$$ENDHEX$$n original

//---------------se actualiza la cantidad programada y pendiente en dt_pdnxmodulo
UPDATE dt_pdnxmodulo  
     SET ca_programada = ca_programada - :al_cantidad,
	      co_tipo_asignacion = 3,
         ca_pendiente  = ca_pendiente - :al_cantidad  
   WHERE ( dt_pdnxmodulo.simulacion 		= :ai_simulacion ) AND  
         ( dt_pdnxmodulo.co_fabrica 		= :ai_fab ) AND  
         ( dt_pdnxmodulo.co_planta 			= :ai_planta ) AND  
         ( dt_pdnxmodulo.co_modulo 			= :ai_modulo ) AND  
         ( dt_pdnxmodulo.co_fabrica_exp 	= :ai_fabexp ) AND  
         ( dt_pdnxmodulo.cs_liberacion 	= :al_liberacion ) AND  
         ( dt_pdnxmodulo.po 					= :as_po ) AND  
         ( dt_pdnxmodulo.nu_cut 				= :as_cut ) AND  
         ( dt_pdnxmodulo.co_fabrica_pt 	= :ai_fabpt ) AND  
         ( dt_pdnxmodulo.co_linea 			= :ai_linea ) AND  
         ( dt_pdnxmodulo.co_referencia 	= :al_ref ) AND  
         ( dt_pdnxmodulo.co_color_pt 		= :al_color_pt ) AND  
         ( dt_pdnxmodulo.tono 				= :as_tono ) ;
			
IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar dt_pdnxmodulo. '+ Sqlca.SqlErrText)
	Return -1
END IF

//---------------------------debo determinar el nuevo valor para cada talla
lds_talla.Retrieve(ai_simulacion,ai_fab,ai_planta,ai_modulo,ai_fabexp,al_liberacion,as_po,as_cut,&
						 ai_fabpt,ai_linea,al_ref,al_color_pt,as_tono,ai_particion)


//------------------------------obtengo el porcentaje para cada talla
For ll_fila = 1 To lds_talla.RowCount()
	ll_cantalla = lds_talla.GetItemNumber(ll_fila,'ca_programada')
	lst_talla.entero[ll_fila] = lds_talla.GetItemNumber(ll_fila,'co_talla')
	lst_porcentaje.decimal[ll_fila] = (ll_cantalla * 100) / (al_cant_prog)
Next

//-------------------------------Cambio los datos para el registro original
For ll_fila = 1 To lds_talla.RowCount()
									
	lds_talla.SetItem(ll_fila, "fe_actualizacion", f_fecha_servidor())
	lds_talla.SetItem(ll_fila, "usuario", gstr_info_usuario.codigo_usuario)
	lds_talla.SetItem(ll_fila, "instancia", gstr_info_usuario.instancia)
																	
	li_talla = lds_talla.GetItemNumber(ll_fila,'co_talla')
		If isnull(lst_talla.entero[ll_fila]) Then
		Else 
			If li_talla = lst_talla.entero[ll_fila] Then
				lds_talla.SetItem(ll_fila,'ca_programada',((al_cant_prog - al_cantidad) * lst_porcentaje.decimal[ll_fila]) / 100)
				lds_talla.SetItem(ll_fila,'ca_pendiente',((al_cant_prog - al_cantidad) * lst_porcentaje.decimal[ll_fila]) / 100)
			End if
		End if
Next

If lds_talla.Update() = -1 Then
	MessageBox('Error','No fue posible actualizar dt_talla_pdnmodulo')
	Return -1
End if

//-------------------------obtengo la cantidad total por todas las tallas	
lds_talla.AcceptText()
For ll_fila = 1 To lds_talla.RowCount()
	ll_cantalla = lds_talla.GetItemNumber(ll_fila,'ca_programada')
	lst_talla_cant.entero[ll_fila] = lds_talla.GetItemNumber(ll_fila,'ca_programada')
	ll_cantottalla += ll_cantalla
Next

//********************************************* valido que los valores de la talla corespondan con el total *********
lds_talla_cant.Retrieve(ai_simulacion,ai_fab,ai_planta,ai_modulo,ai_fabexp,al_liberacion,as_po,as_cut,&
						 ai_fabpt,ai_linea,al_ref,al_color_pt,as_tono)

ll_talla_old = lds_talla_cant.GetItemNumber(1,'co_talla')
					
For ll_i = 1 to lds_talla_cant.RowCount()
	ll_cant_talla += lds_talla_cant.GetItemNumber(ll_i,'ca_programada')
	ll_talla_new = lds_talla_cant.GetItemNumber(ll_i,'co_talla')
	If ll_talla_new <> ll_talla_old Or ll_i = lds_talla_cant.RowCount() Then
		//-----------------busco la cantidad original, para la talla 
		If ll_i <= lds_talla_cant.RowCount() Then
			ll_cant_talla -= lds_talla_cant.GetItemNumber(ll_i,'ca_programada')
			ll_cant_sum = lds_talla_cant.GetItemNumber(ll_i,'ca_programada')
		End if
			For ll_ii = 1 To lds_talla_cant.RowCount()
				If lst_talla.entero[ll_ii] = ll_talla_old Then
					IF ll_cant_talla = 0 THEN
					ELSE	
						ll_resta = lst_talla_cant.entero[ll_ii] - ll_cant_talla
					END IF
					If ll_i = lds_talla_cant.RowCount() Then ll_i += 1
					ll_resta += lds_talla_cant.GetItemNumber(ll_i - 1,'ca_programada')
					lds_talla_cant.SetItem(ll_i -1 ,'ca_programada',ll_resta)
					lds_talla_cant.SetItem(ll_i -1 ,'ca_pendiente',ll_resta)
					ll_cant_talla = ll_cant_sum
					ll_ii = lds_talla_cant.RowCount() + 1
				End if	
			Next
			ll_talla_old = ll_talla_new
	End if
	
Next
	
If lds_talla_cant.Update() = -1 Then
	MessageBox('Error','No fue posible actualizar dt_talla_pdnmodulo')
	Return -1
End if	

//---en este punto tengo ya modificado los valores de la particion original, debo ahorra generar la nueva particion.
IF of_DeterminarCsLiberacion(ai_fabexp,ll_liberacion) = -1 THEN
	Return -1
ELSE
//---------------------------------inserto en h_liberar_escalas
of_CargarHLiberarEscalas(ai_fabexp,ll_liberacion,al_liberacion)
END IF

//------------------------------traigo los datos de dt_pdnxmodulo							
lds_pro.Retrieve(ai_simulacion,ai_fab,ai_planta,ai_modulo,ai_fabexp,al_liberacion,as_po,as_cut,&
					ai_fabpt,ai_linea,al_ref,al_color_pt,as_tono)

li_particion = lds_pro.GetItemNumber(1,'cs_particion')
li_priori    = lds_pro.GetItemNumber(1,'cs_prioridad')

//-----------------------------copio el registro existente
lds_pro.RowsCopy(1,1, Primary!, lds_pro, lds_pro.RowCount() + 1, Primary!)

//------------------------modifico los campos para creaqr la nueva liberaci$$HEX1$$f300$$ENDHEX$$n
lds_pro.AcceptText()
lds_pro.SetItem(lds_pro.RowCount(),'fe_actualizacion', f_fecha_servidor())
lds_pro.SetItem(lds_pro.RowCount(),'usuario', gstr_info_usuario.codigo_usuario)
lds_pro.SetItem(lds_pro.RowCount(),'instancia', gstr_info_usuario.instancia)
lds_pro.SetItem(lds_pro.RowCount(),'cs_particion',li_particion + 1)
lds_pro.SetItem(lds_pro.RowCount(),'cs_prioridad',li_priori + 1)
lds_pro.SetItem(lds_pro.RowCount(),'ca_programada',al_cantidad )
lds_pro.SetItem(lds_pro.RowCount(),'co_tipo_asignacion',3 )   //para identificar las liberaciones que se partieron
lds_pro.SetItem(lds_pro.RowCount(),'ca_pendiente',al_cantidad )
lds_pro.SetItem(lds_pro.RowCount(),'cs_liberacion',ll_liberacion)

If lds_pro.Update() = -1 Then
	MessageBox('Error','No fue posible actualizar dt_pdnxmodulo')
	Return -1
End if

//------------------------copios los registros nuevos en dt_talla_pdnmodulo

ll_fin = lds_talla.RowCount()
FOR ll_fila = 1 TO ll_fin
	lds_talla.RowsCopy(ll_fila,ll_fila, Primary!, lds_talla, lds_talla.RowCount() + ll_fila, Primary!)
	
	li_particion = lds_talla.GetItemNumber(ll_fila,'cs_particion')

	//-----------------------modifico los datos de la nueva liberaci$$HEX1$$f300$$ENDHEX$$n
	lds_talla.AcceptText()
	lds_talla.SetItem(lds_talla.RowCount(), 'cs_particion', li_particion + 1)
	lds_talla.SetItem(lds_talla.RowCount(), 'fe_actualizacion', f_fecha_servidor())
	lds_talla.SetItem(lds_talla.RowCount(), 'usuario', gstr_info_usuario.codigo_usuario)
	lds_talla.SetItem(lds_talla.RowCount(), 'instancia', gstr_info_usuario.instancia)
	lds_talla.SetItem(lds_talla.RowCount(), 'cs_liberacion',ll_liberacion)
																	
	li_talla = lds_talla.GetItemNumber(lds_talla.RowCount(),'co_talla')
		If isnull(lst_talla.entero[ll_fila]) Then
		Else 
			If li_talla = lst_talla.entero[ll_fila] Then
				lds_talla.SetItem(lds_talla.RowCount(),'ca_programada',((al_cantidad) * lst_porcentaje.decimal[ll_fila]) / 100)
				lds_talla.SetItem(lds_talla.RowCount(),'ca_pendiente',((al_cantidad) * lst_porcentaje.decimal[ll_fila]) / 100)
			End if
		End if
	
NEXT

If lds_talla.Update() = -1 Then
	MessageBox('Error','No fue posible actualizar dt_talla_pdnmodulo')
	Return -1
End if

//***********************************************************************
lds_talla.Retrieve(ai_simulacion,ai_fab,ai_planta,ai_modulo,ai_fabexp,ll_liberacion,as_po,as_cut,&
						 ai_fabpt,ai_linea,al_ref,al_color_pt,as_tono,ai_particion+1)

//-----------------------------obtengo la cantidad total por todas las tallas	
lds_talla.AcceptText()
For ll_fila = 1 To lds_talla.RowCount()
	ll_cantalla = lds_talla.GetItemNumber(ll_fila,'ca_programada')
	lst_talla_cant.entero[ll_fila] = lds_talla.GetItemNumber(ll_fila,'ca_programada')
	ll_cantottalla += ll_cantalla
Next

//********************************************* valido que los valores de la talla corespondan con el total *********
ll_cant_talla = 0

lds_talla_cant.Retrieve(ai_simulacion,ai_fab,ai_planta,ai_modulo,ai_fabexp,ll_liberacion,as_po,as_cut,&
						 ai_fabpt,ai_linea,al_ref,al_color_pt,as_tono)

ll_talla_old = lds_talla_cant.GetItemNumber(1,'co_talla')
ll_resta = 0
					
For ll_i = 1 to lds_talla_cant.RowCount()
	ll_cant_talla += lds_talla_cant.GetItemNumber(ll_i,'ca_programada')
	ll_talla_new = lds_talla_cant.GetItemNumber(ll_i,'co_talla')
	If ll_talla_new <> ll_talla_old Or ll_i = lds_talla_cant.RowCount() Then
		//--------------------------------busco la cantidad original, para la talla 
		If ll_i <= lds_talla_cant.RowCount() Then
			ll_cant_talla -= lds_talla_cant.GetItemNumber(ll_i,'ca_programada')
			ll_cant_sum = lds_talla_cant.GetItemNumber(ll_i,'ca_programada')
		End if
			For ll_ii = 1 To lds_talla_cant.RowCount()
				If lst_talla.entero[ll_ii] = ll_talla_old Then
					IF ll_cant_talla = 0 THEN
					ELSE	
						ll_resta = lst_talla_cant.entero[ll_ii] - ll_cant_talla
					END IF
					
					If ll_i = lds_talla_cant.RowCount() Then ll_i += 1
					ll_resta += lds_talla_cant.GetItemNumber(ll_i - 1,'ca_programada')
					lds_talla_cant.SetItem(ll_i -1 ,'ca_programada',ll_resta)
					lds_talla_cant.SetItem(ll_i -1 ,'ca_pendiente',ll_resta)
					ll_cant_talla = ll_cant_sum
					ll_ii = lds_talla_cant.RowCount() + 1
				End if	
			Next
			ll_talla_old = ll_talla_new
	End if
Next
	
If lds_talla_cant.Update() = -1 Then
	MessageBox('Error','No fue posible actualizar dt_talla_pdnmodulo')
	Return -1
End if	

//-------------------------------cargar dt_libera_estilos
IF of_CargarDtLiberaEstilos(ai_fabexp,ll_liberacion,al_liberacion,li_particion + 1,as_po, as_cut) = -1 THEN
	Return -1
END IF
//--------------------------------cargar dt_telaxmodelo_lib
IF of_CargarDtTelaxmodelo_lib(ai_fabexp,ll_liberacion,al_liberacion,li_particion + 1,as_po, as_cut) = -1 THEN
	Return -1
END IF
//------------------------------------cargar dt_escalasxtela
IF of_CargartdtEscalasxtela(ai_fabexp,ll_liberacion,al_liberacion,li_particion + 1,as_po, as_cut) = -1 THEN
	Return -1
END IF

//ya se tiene toda la particion nueva generada, y se tienen actualizadas las cantidades de la actual
//en dt_pdnxmodulo y dt_talla_pdnmodulo, ahorra se debe actualizar el campo ca_unidades en las tablas de la liberaci$$HEX1$$f300$$ENDHEX$$n.

//------------------------------actualizar dt_libera_estilos
IF of_actualizar_DtLiberaEstilos(ai_fabexp, al_liberacion,as_po,as_cut) = -1 THEN
	Return -1
END IF
//-----------------------------actualizar dt_telasxmodelo_lib
IF of_actualizar_DtTelaxmodeloLib(ai_fabexp, al_liberacion,as_po,as_cut) = -1 THEN
	Return -1
END IF
//------------------------------actualizar dt_escalasxtela
IF of_actualizar_DtEscalasxtela(ai_fabexp, al_liberacion,as_po,as_cut) = -1 THEN
	Return -1
END IF

//------------------------------actualizar dt_rollos_libera_no_rectilineas
IF of_Actualizar_DtRollosLibera(ai_fabexp, al_liberacion, ll_liberacion,as_po,as_cut) = -1 THEN
	Return -1
END IF

//------------------------------actualizar dt_rollos_libera_rectilineas
IF of_Actualizar_DtRollosLibera_rectilineas(ai_fabexp, al_liberacion, ll_liberacion,as_po,as_cut) = -1 THEN
	Return -1
END IF

Destroy lds_pro
Destroy lds_talla
Destroy lds_talla_cant

Return 0
end function

public function long of_cargardtliberaestilos (long ai_fabexp, long al_liberacion, long al_liberacion_old, long ai_particion, string as_po, string as_cut);u_ds_base lds_estilos
DateTime ldt_fecha
Long li_fila, li_fabexp, li_fab, li_linea
String ls_po, ls_cut, ls_tono
Long ll_ref, ll_color_pt, ll_unidades, ll_fin

lds_estilos 		= Create u_ds_base
lds_estilos.DataObject 		= 'ds_dt_libera_estilos'  
lds_estilos.SetTransObject(SQLCA)

//--------------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_estilos.Retrieve(ai_fabexp,al_liberacion_old,as_po,as_cut)

ll_fin = lds_estilos.RowCount()

FOR li_fila = 1 TO ll_fin
	lds_estilos.RowsCopy(li_fila,li_fila, Primary!, lds_estilos, lds_estilos.RowCount() + 1, Primary!)
	
	//------------------modifico los campos para generar la nueva particion
	lds_estilos.AcceptText()
	
	lds_estilos.SetItem(lds_estilos.RowCount(), "fe_creacion", ldt_fecha)
	lds_estilos.SetItem(lds_estilos.RowCount(), "fe_actualizacion", ldt_fecha)
	lds_estilos.SetItem(lds_estilos.RowCount(), "usuario", gstr_info_usuario.codigo_usuario)
	lds_estilos.SetItem(lds_estilos.RowCount(), "instancia", gstr_info_usuario.instancia)
	lds_estilos.SetItem(lds_estilos.RowCount(), "cs_liberacion", al_liberacion)
	
	//-------------necesito los datos para realizar el select con dt_talla_pdnmodulo
	li_fabexp 	= lds_estilos.GetItemNumber(li_fila,'co_fabrica_exp')
	ls_po 		= lds_estilos.GetItemString(li_fila,'nu_orden')
	ls_cut 		= lds_estilos.GetItemString(li_fila,'nu_cut')
	li_fab 		= lds_estilos.GetItemNumber(li_fila,'co_fabrica')
	li_linea 	= lds_estilos.GetItemNumber(li_fila,'co_linea')
	ll_ref 		= lds_estilos.GetItemNumber(li_fila,'co_referencia')
	ll_color_pt = lds_estilos.GetItemNumber(li_fila,'co_color_pt')
	ls_tono 		= lds_estilos.GetItemString(li_fila,'co_tono')
	
	
	//-----------------------------modifico el valor de ca_unidades
	SELECT nvl(sum(ca_programada),0)
	  INTO :ll_unidades
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :li_fabexp AND
	 		 cs_liberacion  = :al_liberacion AND
			 po				 = :ls_po AND
			 nu_cut			 = :ls_cut AND
			 co_fabrica_pt  = :li_fab AND
			 co_linea		 = :li_linea AND
			 co_referencia	 = :ll_ref AND
			 co_color_pt	 = :ll_color_pt AND
			 tono				 = :ls_tono AND
			 cs_particion   = :ai_particion;

   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las cantidades. '+Sqlca.SqlErrText)
		Return -1
	END IF
	lds_estilos.SetItem(lds_estilos.RowCount(), "ca_unidades", ll_unidades)
NEXT

lds_estilos.AcceptText()

IF lds_estilos.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar dt_liberar_estilos. '+ Sqlca.SqlErrText)
	Return -1
END IF

Destroy lds_estilos
Return 0
end function

public function long of_cargardttelaxmodelo_lib (long ai_fabexp, long al_liberacion, long al_liberacion_old, long ai_particion, string as_po, string as_cut);u_ds_base lds_modelo
DateTime ldt_fecha
Long li_fila, li_fabexp, li_fab, li_linea
String ls_po, ls_cut, ls_tono
Long ll_ref, ll_color_pt, ll_unidades, ll_fin

lds_modelo 		= Create u_ds_base
lds_modelo.DataObject 		= 'ds_dt_telaxmodelo_lib'  
lds_modelo.SetTransObject(SQLCA)

//----------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_modelo.Retrieve(ai_fabexp,al_liberacion_old,as_po,as_cut)

ll_fin = lds_modelo.RowCount()

FOR li_fila = 1 TO ll_fin
	lds_modelo.RowsCopy(li_fila,li_fila, Primary!, lds_modelo, lds_modelo.RowCount() + 1, Primary!)
	
	//-------------------------modifico los campos para generar la nueva particion
	lds_modelo.AcceptText()
	
	lds_modelo.SetItem(lds_modelo.RowCount(), "fe_creacion", ldt_fecha)
	lds_modelo.SetItem(lds_modelo.RowCount(), "fe_actualizacion", ldt_fecha)
	lds_modelo.SetItem(lds_modelo.RowCount(), "usuario", gstr_info_usuario.codigo_usuario)
	lds_modelo.SetItem(lds_modelo.RowCount(), "instancia", gstr_info_usuario.instancia)
	lds_modelo.SetItem(lds_modelo.RowCount(), "cs_liberacion", al_liberacion)
	
	//-------------------necesito los datos para realizar el select con dt_talla_pdnmodulo
	li_fabexp 	= lds_modelo.GetItemNumber(li_fila,'co_fabrica_exp')
	ls_po 		= lds_modelo.GetItemString(li_fila,'nu_orden')
	ls_cut 		= lds_modelo.GetItemString(li_fila,'nu_cut')
	li_fab 		= lds_modelo.GetItemNumber(li_fila,'co_fabrica_pt')
	li_linea 	= lds_modelo.GetItemNumber(li_fila,'co_linea')
	ll_ref 		= lds_modelo.GetItemNumber(li_fila,'co_referencia')
	ll_color_pt = lds_modelo.GetItemNumber(li_fila,'co_color_pt')
	ls_tono 		= lds_modelo.GetItemString(li_fila,'co_tono')
	
	
	//----------------------------modifico el valor de ca_unidades
	SELECT nvl(sum(ca_programada),0)
	  INTO :ll_unidades
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :li_fabexp AND
	 		 cs_liberacion  = :al_liberacion AND
			 po				 = :ls_po AND
			 nu_cut			 = :ls_cut AND
			 co_fabrica_pt  = :li_fab AND
			 co_linea		 = :li_linea AND
			 co_referencia	 = :ll_ref AND
			 co_color_pt	 = :ll_color_pt AND
			 tono				 = :ls_tono AND
			 cs_particion   = :ai_particion;

   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las cantidades. '+Sqlca.SqlErrText)
		Return -1
	END IF
	lds_modelo.SetItem(lds_modelo.RowCount(), "ca_unidades", ll_unidades)
NEXT

IF lds_modelo.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar h_liberacion_escalas. '+ Sqlca.SqlErrText)
	Return -1
END IF

Destroy lds_modelo
Return 0
end function

public function long of_cargartdtescalasxtela (long ai_fabexp, long al_liberacion, long al_liberacion_old, long ai_particion, string as_po, string as_cut);
u_ds_base lds_escalas
DateTime ldt_fecha
Long li_fila, li_fabexp, li_fab, li_linea, li_talla
String ls_po, ls_cut, ls_tono
Long ll_ref, ll_color_pt, ll_unidades, ll_fin

lds_escalas 		= Create u_ds_base
lds_escalas.DataObject 		= 'ds_dt_escalasxtela'  
lds_escalas.SetTransObject(SQLCA)

//----------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_escalas.Retrieve(ai_fabexp,al_liberacion_old,as_po,as_cut)

ll_fin = lds_escalas.RowCount()

FOR li_fila = 1 TO ll_fin
	lds_escalas.RowsCopy(li_fila,li_fila, Primary!, lds_escalas, lds_escalas.RowCount() + 1, Primary!)
	
	//-----------------------modifico los campos para generar la nueva particion
	lds_escalas.AcceptText()
	
	lds_escalas.SetItem(lds_escalas.RowCount(), "fe_creacion", ldt_fecha)
	lds_escalas.SetItem(lds_escalas.RowCount(), "fe_actualizacion", ldt_fecha)
	lds_escalas.SetItem(lds_escalas.RowCount(), "usuario", gstr_info_usuario.codigo_usuario)
	lds_escalas.SetItem(lds_escalas.RowCount(), "instancia", gstr_info_usuario.instancia)
	lds_escalas.SetItem(lds_escalas.RowCount(), "cs_liberacion", al_liberacion)
	
	//-------------------necesito los datos para realizar el select con dt_talla_pdnmodulo
	li_fabexp 	= lds_escalas.GetItemNumber(li_fila,'co_fabrica_exp')
	ls_po 		= lds_escalas.GetItemString(li_fila,'nu_orden')
	ls_cut 		= lds_escalas.GetItemString(li_fila,'nu_cut')
	li_fab 		= lds_escalas.GetItemNumber(li_fila,'co_fabrica_pt')
	li_linea 	= lds_escalas.GetItemNumber(li_fila,'co_linea')
	ll_ref 		= lds_escalas.GetItemNumber(li_fila,'co_referencia')
	ll_color_pt = lds_escalas.GetItemNumber(li_fila,'co_color_pt')
	ls_tono 		= lds_escalas.GetItemString(li_fila,'co_tono')
	li_talla    = lds_escalas.GetItemNumber(li_fila,'co_talla')
	
	//--------------------------modifico el valor de ca_unidades
	SELECT nvl(sum(ca_programada),0)
	  INTO :ll_unidades
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :li_fabexp AND
	 		 cs_liberacion  = :al_liberacion AND
			 po				 = :ls_po AND
			 nu_cut			 = :ls_cut AND
			 co_fabrica_pt  = :li_fab AND
			 co_linea		 = :li_linea AND
			 co_referencia	 = :ll_ref AND
			 co_color_pt	 = :ll_color_pt AND
			 tono				 = :ls_tono AND
			 co_talla		 = :li_talla AND	
			 cs_particion   = :ai_particion;

   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las cantidades. '+Sqlca.SqlErrText)
		Return -1
	END IF

	lds_escalas.SetItem(lds_escalas.RowCount(), "ca_unidades", ll_unidades)
	
NEXT



IF lds_escalas.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar h_liberacion_escalas. '+ Sqlca.SqlErrText)
	Return -1
END IF

Destroy lds_escalas
Return 0
end function

public function long of_actualizar_dtescalasxtela (long ai_fabexp, long al_liberacion, string as_po, string as_cut);u_ds_base lds_escalas
DateTime ldt_fecha
Long li_fila, li_fabexp, li_fab, li_linea, li_talla
String ls_po, ls_cut, ls_tono
Long ll_ref, ll_color_pt, ll_unidades

lds_escalas 		= Create u_ds_base
lds_escalas.DataObject 		= 'ds_dt_escalasxtela'  
lds_escalas.SetTransObject(SQLCA)

//------------------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_escalas.Retrieve(ai_fabexp,al_liberacion,as_po,as_cut)

FOR li_fila = 1 TO lds_escalas.RowCount()
	//-----------------------necesito los datos para realizar el select con dt_talla_pdnmodulo
	li_fabexp 	= lds_escalas.GetItemNumber(li_fila,'co_fabrica_exp')
	ls_po 		= lds_escalas.GetItemString(li_fila,'nu_orden')
	ls_cut 		= lds_escalas.GetItemString(li_fila,'nu_cut')
	li_fab 		= lds_escalas.GetItemNumber(li_fila,'co_fabrica_pt')
	li_linea 	= lds_escalas.GetItemNumber(li_fila,'co_linea')
	ll_ref 		= lds_escalas.GetItemNumber(li_fila,'co_referencia')
	ll_color_pt = lds_escalas.GetItemNumber(li_fila,'co_color_pt')
	ls_tono 		= lds_escalas.GetItemString(li_fila,'co_tono')
	li_talla    = lds_escalas.GetItemNumber(li_fila,'co_talla')
	
	//----------------------------------modifico el valor de ca_unidades
	SELECT nvl(sum(ca_programada),0)
	  INTO :ll_unidades
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :li_fabexp AND
	 		 cs_liberacion  = :al_liberacion AND
			 po				 = :ls_po AND
			 nu_cut			 = :ls_cut AND
			 co_fabrica_pt  = :li_fab AND
			 co_linea		 = :li_linea AND
			 co_referencia	 = :ll_ref AND
			 co_color_pt	 = :ll_color_pt AND
			 tono				 = :ls_tono AND
			 co_talla		 = :li_talla ;

   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las cantidades. '+Sqlca.SqlErrText)
		Return -1
	END IF
	lds_escalas.SetItem(li_fila, "ca_unidades", ll_unidades)
NEXT

IF lds_escalas.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar dt_escalasxtela. '+ Sqlca.SqlErrText)
	Return -1
END IF

Destroy lds_escalas
Return 0
end function

public function long of_actualizar_dtliberaestilos (long ai_fabexp, long al_liberacion, string as_po, string as_cut);u_ds_base lds_estilos
DateTime ldt_fecha
Long li_fila, li_fabexp, li_fab, li_linea
String ls_po, ls_cut, ls_tono
Long ll_ref, ll_color_pt, ll_unidades

lds_estilos 		= Create u_ds_base
lds_estilos.DataObject 		= 'ds_dt_libera_estilos'  
lds_estilos.SetTransObject(SQLCA)

//---------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_estilos.Retrieve(ai_fabexp,al_liberacion,as_po,as_cut)

FOR li_fila = 1 TO lds_estilos.RowCount()
	//----------------------necesito los datos para realizar el select con dt_talla_pdnmodulo
	li_fabexp 	= lds_estilos.GetItemNumber(li_fila,'co_fabrica_exp')
	ls_po 		= lds_estilos.GetItemString(li_fila,'nu_orden')
	ls_cut 		= lds_estilos.GetItemString(li_fila,'nu_cut')
	li_fab 		= lds_estilos.GetItemNumber(li_fila,'co_fabrica')
	li_linea 	= lds_estilos.GetItemNumber(li_fila,'co_linea')
	ll_ref 		= lds_estilos.GetItemNumber(li_fila,'co_referencia')
	ll_color_pt = lds_estilos.GetItemNumber(li_fila,'co_color_pt')
	ls_tono 		= lds_estilos.GetItemString(li_fila,'co_tono')
		
	//---------------------------modifico el valor de ca_unidades
	SELECT nvl(sum(ca_programada),0)
	  INTO :ll_unidades
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :li_fabexp AND
	 		 cs_liberacion  = :al_liberacion AND
			 po				 = :ls_po AND
			 nu_cut			 = :ls_cut AND
			 co_fabrica_pt  = :li_fab AND
			 co_linea		 = :li_linea AND
			 co_referencia	 = :ll_ref AND
			 co_color_pt	 = :ll_color_pt AND
			 tono				 = :ls_tono ;

   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las cantidades. '+Sqlca.SqlErrText)
		Return -1
	END IF

	lds_estilos.SetItem(li_fila, "ca_unidades", ll_unidades)
NEXT

IF lds_estilos.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar dt_liberar_estilo. '+ Sqlca.SqlErrText)
	Return -1
END IF

Destroy lds_estilos
Return 0
end function

public function long of_actualizar_dttelaxmodelolib (long ai_fabexp, long al_liberacion, string as_po, string as_cut);u_ds_base lds_modelo
DateTime ldt_fecha
Long li_fila, li_fabexp, li_fab, li_linea
String ls_po, ls_cut, ls_tono
Long ll_ref, ll_color_pt, ll_unidades

lds_modelo 		= Create u_ds_base
lds_modelo.DataObject 		= 'ds_dt_telaxmodelo_lib'  
lds_modelo.SetTransObject(SQLCA)

//--------------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

lds_modelo.Retrieve(ai_fabexp,al_liberacion,as_po,as_cut)

FOR li_fila = 1 TO lds_modelo.RowCount()
	//----------------------necesito los datos para realizar el select con dt_talla_pdnmodulo
	li_fabexp 	= lds_modelo.GetItemNumber(li_fila,'co_fabrica_exp')
	ls_po 		= lds_modelo.GetItemString(li_fila,'nu_orden')
	ls_cut 		= lds_modelo.GetItemString(li_fila,'nu_cut')
	li_fab 		= lds_modelo.GetItemNumber(li_fila,'co_fabrica_pt')
	li_linea 	= lds_modelo.GetItemNumber(li_fila,'co_linea')
	ll_ref 		= lds_modelo.GetItemNumber(li_fila,'co_referencia')
	ll_color_pt = lds_modelo.GetItemNumber(li_fila,'co_color_pt')
	ls_tono 		= lds_modelo.GetItemString(li_fila,'co_tono')
		
	//-----------------------------modifico el valor de ca_unidades
	SELECT nvl(sum(ca_programada),0)
	  INTO :ll_unidades
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :li_fabexp AND
	 		 cs_liberacion  = :al_liberacion AND
			 po				 = :ls_po AND
			 nu_cut			 = :ls_cut AND
			 co_fabrica_pt  = :li_fab AND
			 co_linea		 = :li_linea AND
			 co_referencia	 = :ll_ref AND
			 co_color_pt	 = :ll_color_pt AND
			 tono				 = :ls_tono ;

   IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las cantidades. '+Sqlca.SqlErrText)
		Return -1
	END IF
	lds_modelo.SetItem(li_fila, "ca_unidades", ll_unidades)
NEXT

IF lds_modelo.Update() = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar dt_telasxmodelo_lib. '+ Sqlca.SqlErrText)
	Return -1
END IF

Destroy lds_modelo
Return 0
end function

public function long of_actualizar_dtrolloslibera (long ai_fabexp, long al_liberacion_old, long al_liberacion_new, string as_po, string as_cut);Long ll_fila, ll_fin, ll_ref, ll_color_pt, ll_modelo, ll_coreftel, ll_unidades, ll_fin2, ll_fila2,&
	  ll_unid_rollo, ll_total_rollo, ll_resta, ll_unid_old, ll_unid_new, ll_count, ll_color_tela
String ls_cut, ls_po, ls_tono
Long li_fabpt, li_linea, li_fabtel, li_caract, li_diam, li_tiptel,&
		  li_rectilineo1, li_rectilineo2, li_marca, li_paso, li_en_kilos
Decimal{2}  ldc_metros, ldc_met_rollo, ldc_total_rollo, ldc_resta, ldc_met_old, ldc_met_new 
Decimal{2}	ldc_kg_rollo, ldc_met_ini_rollo
Decimal{4}	ldc_yield
u_ds_base lds_telas, lds_rollos
n_cts_constantes lpo_constantes

lpo_constantes = Create n_cts_constantes

lds_telas = Create u_ds_base
lds_rollos = Create u_ds_base

lds_telas.DataObject = 'ds_dt_escalasxtela_rollos_norectilineas'  
lds_rollos.DataObject = 'ds_dt_rollos_libera'

lds_telas.SetTransObject(SQLCA)
lds_rollos.SetTransObject(SQLCA)

//traigo todas las telas con sus repectivas unidades y metros de la liberacion existente
li_rectilineo1 = lpo_constantes.of_consultar_numerico('RECTILINEO 1')
 
IF li_rectilineo1 = -1 THEN
	Return -1
END IF

li_rectilineo2 = lpo_constantes.of_consultar_numerico('RECTILINEO 2')
 
IF li_rectilineo2 = -1 THEN
	Return -1
END IF
lds_telas.Retrieve(ai_fabexp,al_liberacion_old,as_po,as_cut, li_rectilineo1, li_rectilineo2)

ll_fin = lds_telas.RowCount()

FOR ll_fila = 1 TO ll_fin
	//traigo los datos necesarios para poder realizar el retrieve en dt_rollos_libera
	ls_po 			= lds_telas.GetItemString(ll_fila,'nu_orden')
	ls_cut 			= lds_telas.GetItemString(ll_fila,'nu_cut')
	li_fabpt 		= lds_telas.GetItemNumber(ll_fila,'co_fabrica_pt')
	li_linea 		= lds_telas.GetItemNumber(ll_fila,'co_linea')
	ll_ref 			= lds_telas.GetItemNumber(ll_fila,'co_referencia')
	ll_color_pt 	= lds_telas.GetItemNumber(ll_fila,'co_color_pt')
	ls_tono 			= lds_telas.GetItemString(ll_fila,'co_tono')
	ll_modelo 		= lds_telas.GetItemNumber(ll_fila,'co_modelo')
	li_fabtel 		= lds_telas.GetItemNumber(ll_fila,'co_fabrica_tela')
	ll_coreftel 	= lds_telas.GetItemNumber(ll_fila,'co_reftel')
	li_caract 		= lds_telas.GetItemNumber(ll_fila,'co_caract')
	li_diam 			= lds_telas.GetItemNumber(ll_fila,'diametro')
	ll_color_tela 	= lds_telas.GetItemNumber(ll_fila,'co_color_tela')
	ll_unidades 	= lds_telas.GetItemNumber(ll_fila,'ca_unidades')
	ldc_yield 		= lds_telas.GetItemNumber(ll_fila,'yield')
	ldc_metros 		= ll_unidades * ldc_yield
	
   //se recorren todos los rollos de la liberacion, para poder modificar las cantidades y en 
	//casos que sea necesario generar el nuevo registro para la liberaci$$HEX1$$f300$$ENDHEX$$n nueva.
	
	li_paso = 0
	ll_total_rollo = 0
	ldc_total_rollo = 0
	
	lds_rollos.Retrieve(ai_fabexp,al_liberacion_old,ls_po,ls_cut,li_fabpt,li_linea,ll_ref,ll_color_pt,&
							  ls_tono,ll_modelo,li_fabtel,ll_coreftel,li_caract,li_diam,ll_color_tela	)
							  
	ll_fin2 = lds_rollos.RowCount()
	
	FOR ll_fila2 = 1 TO ll_fin2
		//-------------------------------trabajamos con metros
		ldc_met_rollo = lds_rollos.GetItemNUmber(ll_fila2,'ca_metros')
		ldc_kg_rollo  = lds_rollos.GetItemNUmber(ll_fila2,'ca_kg')
		
		ldc_met_ini_rollo = lds_rollos.GetItemNUmber(ll_fila2,'ca_metros')
		
		IF IsNull(ldc_kg_rollo) OR ldc_kg_rollo = 0 THEN
			li_en_kilos = 0
		ELSE
			li_en_kilos = 1
		END IF
		IF li_en_kilos = 1 THEN
			//se debe trabajar con kilos, para facilidad de cambia los  metros por los kilos
			//pues en el yield tambien se esta trabajando con kilos en caso de que ca_kg sea > 0
			ldc_met_rollo = ldc_kg_rollo
		END IF
		
		ldc_total_rollo += ldc_met_rollo
		
		IF ldc_total_rollo < ldc_metros THEN
			//no se hace nada ya que hasta este punto los rollos pueden seguir perteniendo a la liberacion actual
		ELSE
			//en este caso ya debemos generar los registros para la liberacion nueva y de ser el caso modificar la
			//cantidad del rollo para la liberaci$$HEX1$$f300$$ENDHEX$$n vieja.
			IF li_paso = 0 THEN
				ldc_resta = ldc_total_rollo - ldc_met_rollo
				ldc_met_old = ldc_metros - ldc_resta
				ldc_met_new = ldc_met_rollo - ldc_met_old
				
				IF ldc_met_new < 0 THEN ldc_met_new = ldc_met_new * (-1)
				
				IF li_en_kilos = 1 THEN
					IF ldc_met_old = 0 THEN
						Rollback;
						MessageBox('Error','Uno de los rollos a mercar va a quedar con cero kilos, se cancela el proceso, comunique este a Informatica.',StopSign!)
						Return -1
					END IF
					//se coloca en comentario abril 9 2012 jorodrig, porque no se ve que sea necesario, esta sacando error partiendo una liberacion
//					IF ldc_met_new < 0.006 THEN
//						Rollback;
//						MessageBox('Error','Los kilos de un rollo van a quedar menores a 0.006 kilos, avise a Informatica.',StopSign!)
//						Return -1
//					END IF

					lds_rollos.SetItem(ll_fila2,'ca_kg',ldc_met_old)
					lds_rollos.SetItem(ll_fila2,'ca_metros',((ldc_met_old * ldc_met_ini_rollo ) / ldc_kg_rollo))
					
				ELSE
					lds_rollos.SetItem(ll_fila2,'ca_metros',ldc_met_old)
				END IF
				
				//generamos el nuevo registro para la liberacion nueva
				lds_rollos.RowsCopy(ll_fila2, ll_fila2, Primary!, lds_rollos, lds_rollos.RowCount() + 1, Primary!)
				
				lds_rollos.AcceptText()
				lds_rollos.SetItem(lds_rollos.RowCount(),'cs_liberacion',al_liberacion_new)
				IF li_en_kilos = 1 THEN
					IF ldc_met_old = 0 THEN
						Rollback;
						MessageBox('Error','Uno de los rollos a mercar va a quedar con cero kilos, se cancela el proceso, comunique este a Informatica.',StopSign!)
						Return -1
					END IF
					IF ldc_met_new < 0.006 THEN
						Rollback;
						MessageBox('Error','Los kilos de un rollo van a quedar menores a 0.006 kilos, avise a Informatica.',StopSign!)
						Return -1
					END IF
					lds_rollos.SetItem(lds_rollos.RowCount(),'ca_kg',ldc_met_new)
					lds_rollos.SetItem(lds_rollos.RowCount(),'ca_metros',(ldc_met_ini_rollo - ((ldc_met_old * ldc_met_ini_rollo ) / ldc_kg_rollo)))
					
					
				ELSE
					lds_rollos.SetItem(lds_rollos.RowCount(),'ca_metros',ldc_met_new)
				END IF
				li_paso = 1
			ELSE
				//es porque ya no se tiene que partir el rollo unicamente se debe modificar a la liberacion nueva
				lds_rollos.SetItem(ll_fila2,'cs_liberacion',al_liberacion_new)
			END IF
		END IF
	NEXT
	
	IF lds_rollos.Update() = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los rollos liberados. ')
		Return -1
	ELSE
		SELECT count(*)
		  INTO :ll_count
		  FROM dt_rollos_libera
		 WHERE cs_liberacion = :al_liberacion_new AND
		       ca_metros = 0 AND
				 ca_unidades = 0;
				 
		IF ll_count > 1 THEN
			Rollback;
			MessageBox('Error','Se estan adicionando a la liberaci$$HEX1$$f300$$ENDHEX$$n rollos sin metros y unidades, comunique este a Informatica.',StopSign!)
			Return -1
		END IF
				 
	END IF
NEXT

Destroy lds_telas 
Destroy lds_rollos

Return 0
end function

public function long of_actualizar_dtrolloslibera_rectilineas (long ai_fabexp, long al_liberacion_old, long al_liberacion_new, string as_po, string as_cut);Long ll_fila, ll_fin, ll_ref, ll_color_pt, ll_modelo, ll_coreftel, ll_unidades, ll_fin2, ll_fila2,&
	  ll_unid_rollo, ll_total_rollo, ll_resta, ll_unid_old, ll_unid_new, ll_count, ll_color_tela
String ls_cut, ls_po, ls_tono
Long li_fabpt, li_linea, li_fabtel, li_caract, li_diam, li_tiptel,&
		  li_rectilineo1, li_rectilineo2, li_marca, li_paso, li_talla
Decimal{5} ldc_yield, ldc_metros, ldc_met_rollo, ldc_total_rollo, ldc_resta, ldc_met_old, ldc_met_new 
u_ds_base lds_telas, lds_rollos
n_cts_constantes lpo_constantes

lpo_constantes = Create n_cts_constantes

lds_telas = Create u_ds_base
lds_rollos = Create u_ds_base

lds_telas.DataObject = 'ds_dt_escalasxtela_rollos_rectilineas'  
lds_rollos.DataObject = 'ds_dt_rollos_libera_rectilineas'

lds_telas.SetTransObject(SQLCA)
lds_rollos.SetTransObject(SQLCA)

li_rectilineo1 = lpo_constantes.of_consultar_numerico('RECTILINEO 1')
 
IF li_rectilineo1 = -1 THEN
	Return -1
END IF

li_rectilineo2 = lpo_constantes.of_consultar_numerico('RECTILINEO 2')
 
IF li_rectilineo2 = -1 THEN
	Return -1
END IF

//traigo todas las telas con sus repectivas unidades y metros de la liberacion existente
lds_telas.Retrieve(ai_fabexp,al_liberacion_old,as_po,as_cut, li_rectilineo1, li_rectilineo2)

ll_fin = lds_telas.RowCount()

FOR ll_fila = 1 TO ll_fin
	//traigo los datos necesarios para poder realizar el retrieve en dt_rollos_libera
	ls_po 			= lds_telas.GetItemString(ll_fila,'nu_orden')
	ls_cut 			= lds_telas.GetItemString(ll_fila,'nu_cut')
	li_fabpt 		= lds_telas.GetItemNumber(ll_fila,'co_fabrica_pt')
	li_linea 		= lds_telas.GetItemNumber(ll_fila,'co_linea')
	ll_ref 			= lds_telas.GetItemNumber(ll_fila,'co_referencia')
	ll_color_pt 	= lds_telas.GetItemNumber(ll_fila,'co_color_pt')
	ls_tono 			= lds_telas.GetItemString(ll_fila,'co_tono')
	ll_modelo 		= lds_telas.GetItemNumber(ll_fila,'co_modelo')
	li_fabtel 		= lds_telas.GetItemNumber(ll_fila,'co_fabrica_tela')
	ll_coreftel 	= lds_telas.GetItemNumber(ll_fila,'co_reftel')
	li_caract 		= lds_telas.GetItemNumber(ll_fila,'co_caract')
	li_diam 			= lds_telas.GetItemNumber(ll_fila,'diametro')
	ll_color_tela 	= lds_telas.GetItemNumber(ll_fila,'co_color_tela')
	ll_unidades 	= lds_telas.GetItemNumber(ll_fila,'ca_unidades')
	ldc_yield 		= lds_telas.GetItemNumber(ll_fila,'yield')
	li_talla			= lds_telas.GetItemNumber(ll_fila,'co_talla')
	ldc_metros 		= ll_unidades * ldc_yield
	
   //se recorren todos los rollos de la liberacion, para poder modificar las cantidades y en 
	//casos que sea necesario generar el nuevo registro para la liberaci$$HEX1$$f300$$ENDHEX$$n nueva.
	
	li_paso = 0
	ll_total_rollo = 0
	ldc_total_rollo = 0
	
	lds_rollos.Retrieve(ai_fabexp,al_liberacion_old,ls_po,ls_cut,li_fabpt,li_linea,ll_ref,ll_color_pt,&
							  ls_tono,ll_modelo,li_fabtel,ll_coreftel,li_caract,li_diam,ll_color_tela, li_talla)
							  
	ll_fin2 = lds_rollos.RowCount()
	
	FOR ll_fila2 = 1 TO ll_fin2
		//-------------------------------trabajamos con unidades
		ll_unid_rollo = lds_rollos.GetItemNUmber(ll_fila2,'ca_unidades')
		
		ll_total_rollo += ll_unid_rollo
		
		IF ll_total_rollo <= ll_unidades THEN
			//no se hace nada ya que hasta este punto los rollos pueden seguir perteniendo a la liberacion actual
		ELSE
			//en este caso ya debemos generar los registros para la liberacion nueva y de ser el caso modificar la
			//cantidad del rollo para la liberaci$$HEX1$$f300$$ENDHEX$$n vieja.
			IF li_paso = 0 THEN
				ll_resta = ll_total_rollo -ll_unid_rollo
				ll_unid_old = ll_unidades - ll_resta
				ll_unid_new = ll_unid_rollo - ll_unid_old
				
				IF ll_unid_new < 0 THEN ll_unid_new = ll_unid_new * (-1)
				
				lds_rollos.SetItem(ll_fila2,'ca_unidades',ll_unid_old)
				
				//generamos el nuevo registro para la liberacion nueva
				lds_rollos.RowsCopy(ll_fila2, ll_fila2, Primary!, lds_rollos, lds_rollos.RowCount() + 1, Primary!)
				
				lds_rollos.AcceptText()
				lds_rollos.SetItem(lds_rollos.RowCount(),'cs_liberacion',al_liberacion_new)
				lds_rollos.SetItem(lds_rollos.RowCount(),'ca_unidades',ll_unid_new)
				li_paso = 1
			ELSE
				//es porque ya no se tiene que partir el rollo unicamente se debe modificar a la liberacion nueva
				lds_rollos.SetItem(ll_fila2,'cs_liberacion',al_liberacion_new)
			END IF
		END IF
	NEXT
	
	IF lds_rollos.Update() = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los rollos liberados. ')
		Return -1
	ELSE	
		SELECT count(*)
		  INTO :ll_count
		  FROM dt_rollos_libera
		 WHERE cs_liberacion = :al_liberacion_new AND
		       ca_metros = 0 AND
				 ca_unidades = 0;
				 
		IF ll_count > 1 THEN
			Rollback;
			MessageBox('Error','Se estan adicionando a la liberaci$$HEX1$$f300$$ENDHEX$$n rollos sin metros y unidades, comunique este a Informatica.',StopSign!)
			Return -1
		END IF
		
	END IF
NEXT

Destroy lds_telas 
Destroy lds_rollos

Return 0
end function

on n_cts_particion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_particion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

