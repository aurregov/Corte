HA$PBExportHeader$w_liquidaciones_espacio.srw
forward
global type w_liquidaciones_espacio from w_base_maestrotb_detalletb_para_tabs
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_encabezado from datawindow within w_liquidaciones_espacio
end type
type dw_unidades from uo_dtwndow within w_liquidaciones_espacio
end type
end forward

global type w_liquidaciones_espacio from w_base_maestrotb_detalletb_para_tabs
integer width = 3141
integer height = 2000
string title = "Liquidaci$$HEX1$$f300$$ENDHEX$$n Espacio"
string menuname = "m_liquidacion"
event ue_liquidar pbm_custom01
event ue_devolver pbm_custom02
dw_encabezado dw_encabezado
dw_unidades dw_unidades
end type
global w_liquidaciones_espacio w_liquidaciones_espacio

event ue_liquidar;Long li_liquidacion, li_estado, li_pos_cortar, li_pos_inicial, ll_hallados
Long li_tipodetalle, ll_continua, li_correo, li_return, li_raya
s_base_parametros lstr_parametros_retro
Long ll_ordencorte, ll_agrupacion, ll_basetrazo
Decimal{2} ld_consumo
String ls_body
OLEObject lole_outlook,lole_item,lole_attach
		
IF il_fila_actual_maestro > 0 THEN		
	IF dw_detalle.RowCount() > 0 THEN
		ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
		ll_agrupacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_agrupacion")
		ll_basetrazo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_base_trazos")
		li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
		li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
		li_tipodetalle = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_detalle")
		IF IsNull(li_liquidacion) THEN
			MessageBox("Advertencia","No ha grabado la liquidacion")
			Return
		END IF
		IF li_estado = 3 OR li_estado = 4 THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
				
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)		
			
// Vamos a verificar primero que los rollos de la liquidaci$$HEX1$$f300$$ENDHEX$$n tengan informaci$$HEX1$$f300$$ENDHEX$$n de las yardas consumidas.

			SELECT Sum(ca_consumido)
			INTO :ld_consumo
			FROM dt_liq_rollos
			WHERE cs_orden_corte = :ll_ordencorte AND
					cs_agrupacion = :ll_agrupacion AND
					cs_base_trazos = :ll_basetrazo AND
					cs_liquidacion = :li_liquidacion;
					
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al verificar consumo de rollos")
				Return
			END IF
			IF ld_consumo = 0 THEN
				MessageBox("Advertencia...","No puede realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n, debe ingresar informaci$$HEX1$$f300$$ENDHEX$$n de consumos")
				Return
			END IF
			DECLARE liquidar PROCEDURE FOR
				pr_liq_espacio(:ll_ordencorte, :ll_agrupacion, :ll_basetrazo, :li_liquidacion, :li_tipodetalle);
			EXECUTE liquidar;
			FETCH liquidar INTO :li_correo;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
					ROLLBACK;
				ELSE
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
					ROLLBACK;
				END IF
			ELSE
				COMMIT;
			END IF
//			IF li_correo = 1 THEN
//				SELECT raya
//				INTO :li_raya
//				FROM h_base_trazos
//				WHERE cs_agrupacion = :ll_agrupacion AND
//						cs_base_trazos = :ll_basetrazo;
//				IF SQLCA.SQLCode = - 1 THEN
//					MessageBox("Error Base Datos","Error al consultar la raya")
//				END IF
//				
//				lole_outlook = Create OLEObject
//				
//				li_return = lole_outlook.ConnectToNewObject("outlook.application")
//				
//				If li_return <> 0 Then
//					Messagebox("Advertencia!","No se pudo establecer conexi$$HEX1$$f300$$ENDHEX$$n con Outlook.~n~nError : " &
//								 + String(li_return) )
//					Destroy lole_outlook
//					Return li_return
//				End If
//				
//				ls_body = 'Se present$$HEX2$$f3002000$$ENDHEX$$una variaci$$HEX1$$f300$$ENDHEX$$n negativa superior al 5% al liquidar el siguiente trazo: ~n~n'
//				ls_body = ls_body + 'Orden Corte: ' + String(ll_ordencorte) + '~n~n'
//				ls_body = ls_body + 'Raya: ' + String(li_raya) + '~n~n'
//				ls_body = ls_body + 'Espacio: ' + String(ll_basetrazo)
//				lole_item = lole_outlook.CreateItem(0)
//				
//				lole_item.To      = "jaime_venegas@saraintl.com;jorge_delgado@saraintl.com;jose_gomez@saraintl.com"
//				lole_item.Subject = "Variaci$$HEX1$$f300$$ENDHEX$$n Orden Corte"
//				lole_item.Body    = ls_body
//				
//				lole_item.Send
//				
//				Destroy lole_item
//
//			END IF
			dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
			ll_hallados = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
			IF isnull(ll_hallados) THEN
				MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
			ELSE
				CHOOSE CASE ll_hallados
					CASE -1
						il_fila_actual_maestro = -1
						MessageBox("Error buscando","Error de la base",StopSign!,&
									 Ok!)
					CASE 0
						il_fila_actual_maestro = 0
						MessageBox("Sin Datos","No hay datos para su criterio",&
									 Exclamation!,Ok!)
					CASE ELSE
						il_fila_actual_maestro = 1
				END CHOOSE
			END IF
			dw_maestro.TriggerEvent("RowFocusChanged")			
			Close(w_retroalimentacion)
		ELSE
			MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n esta debe estar preparada")
		END IF
	ELSE
		MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n debe asignar primero rollos")
	END IF
ELSE
	MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n tiene que seleccionar primero un registro de liquidaci$$HEX1$$f300$$ENDHEX$$n")
END IF
end event

event ue_devolver;Long li_liquidacion, li_estado, li_pos_cortar, li_pos_inicial, ll_hallados
Long li_estado_oc, li_tipodetalle
Long ll_ordencorte, ll_agrupacion, ll_basetrazo
s_base_parametros lstr_parametros_retro
		
IF il_fila_actual_maestro > 0 THEN		
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	ll_agrupacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_agrupacion")
	ll_basetrazo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_base_trazos")
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
	li_estado_oc = dw_encabezado.GetItemNumber(1, "co_estado")
	li_tipodetalle = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_detalle")	
	IF IsNull(li_liquidacion) THEN
		MessageBox("Advertencia","No ha grabado la liquidacion")
	ELSE
		IF li_estado = 6 AND (li_estado_oc = 5 OR li_estado_oc = 6) THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
		
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)						
			DECLARE devolver PROCEDURE FOR
				pr_devliq_espacio(:ll_ordencorte, :ll_agrupacion, :ll_basetrazo, :li_liquidacion, :li_tipodetalle);
			EXECUTE devolver;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
					li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
				ELSE
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
				END IF
				ROLLBACK;
			ELSE
				COMMIT;
			END IF
			Close(w_retroalimentacion)
			dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
			ll_hallados = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
			IF isnull(ll_hallados) THEN
				MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
			ELSE
				CHOOSE CASE ll_hallados
					CASE -1
						il_fila_actual_maestro = -1
						MessageBox("Error buscando","Error de la base",StopSign!,&
									 Ok!)
					CASE 0
						il_fila_actual_maestro = 0
						MessageBox("Sin Datos","No hay datos para su criterio",&
									 Exclamation!,Ok!)
					CASE ELSE
						il_fila_actual_maestro = 1
				END CHOOSE
			END IF			
			dw_maestro.TriggerEvent("RowFocusChanged")						
		ELSE
			MessageBox("Advertencia","Para poder devolver una liquidacion esta debe estar liquidada")
		END IF
	END IF
ELSE
	MessageBox("Advertencia","Para devolver la liquidaci$$HEX1$$f300$$ENDHEX$$n tiene que seleccionar primero un registro de liquidaci$$HEX1$$f300$$ENDHEX$$n")
END IF
end event

on w_liquidaciones_espacio.create
int iCurrent
call super::create
if this.MenuName = "m_liquidacion" then this.MenuID = create m_liquidacion
this.dw_encabezado=create dw_encabezado
this.dw_unidades=create dw_unidades
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_encabezado
this.Control[iCurrent+2]=this.dw_unidades
end on

on w_liquidaciones_espacio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_encabezado)
destroy(this.dw_unidades)
end on

event ue_buscar;call super::ue_buscar;Long li_dw_inicializar, li_liquidacion
Long ll_hallados, ll_ordencorte, ll_agrupacion, ll_basetrazo
s_base_parametros lstr_parametros

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_consultar_rayas_ordencorte)
	lstr_parametros = Message.PowerObjectParm
	IF lstr_parametros.hay_parametros THEN
		ll_ordencorte = lstr_parametros.entero[1]
		ll_agrupacion = lstr_parametros.entero[2]
		ll_basetrazo = lstr_parametros.entero[3]
		ll_hallados = dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
		IF ll_hallados > 0 THEN
			ll_hallados = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
			IF isnull(ll_hallados) THEN
				MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
			ELSE
				CHOOSE CASE ll_hallados
					CASE -1
						il_fila_actual_maestro = -1
						MessageBox("Error buscando","Error de la base",StopSign!,&
									 Ok!)
					CASE 0
						il_fila_actual_maestro = 0
						MessageBox("Sin Datos","No hay datos para su criterio",&
									 Exclamation!,Ok!)
					CASE ELSE
						il_fila_actual_maestro = 1
						li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_liquidacion')
						FOR li_dw_inicializar = 1 TO ii_num_dw
							ll_hallados = idw_arreglo_dw[li_dw_inicializar].Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, li_liquidacion)
							IF ll_hallados > 0 THEN
								il_fila_actual_detalle[li_dw_inicializar] = 1
							ELSE
								il_fila_actual_detalle[li_dw_inicializar] = 0
							END IF
						NEXT						
				END CHOOSE
			END IF
		ELSE
			dw_maestro.Reset()
			FOR li_dw_inicializar = 1 TO ii_num_dw
				idw_arreglo_dw[li_dw_inicializar].Reset()
			NEXT			
		END IF
	ELSE
		dw_maestro.Reset()
		FOR li_dw_inicializar = 1 TO ii_num_dw
			idw_arreglo_dw[li_dw_inicializar].Reset()
		NEXT
	END IF
ELSE
END IF
end event

event ue_insertar_maestro;Long li_hallados
Long ll_ordencorte, ll_agrupacion, ll_basetrazo
s_base_parametros lstr_parametros

//IF il_fila_actual_maestro > 0 THEN
	Open(w_buscar_cb_oc_raya_espacio)
	lstr_parametros = Message.PowerObjectParm
	dw_encabezado.Reset()
	dw_maestro.Reset()
	CALL w_base_maestrotb_detalletb_para_tabs::ue_insertar_maestro
	IF lstr_parametros.hay_parametros THEN		
		ll_ordencorte = lstr_parametros.entero[1]
		ll_agrupacion = lstr_parametros.entero[2]
		ll_basetrazo = lstr_parametros.entero[3]
		li_hallados = dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo)
		IF li_hallados = 0 THEN
			MessageBox("Advertencia...","La orden de corte-agrupacion-base no existe en la base datos")
			dw_maestro.DeleteRow(il_fila_actual_maestro)
			il_fila_actual_maestro = il_fila_actual_maestro - 1				
			Return
		END IF
		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_orden_corte', ll_ordencorte)
		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_agrupacion', ll_agrupacion)
		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_base_trazos', ll_basetrazo)
	ELSE
		dw_maestro.DeleteRow(il_fila_actual_maestro)
		il_fila_actual_maestro = il_fila_actual_maestro - 1
	END IF
//END IF
end event

event ue_insertar_detalle;Long li_liquidacion, li_estado

IF il_fila_actual_maestro > 0 THEN
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
	IF li_estado = 3 OR li_estado = 4 THEN
		idw_arreglo_dw[ii_dw_actual].TriggerEvent("ue_adicionar_fila")
	END IF
END IF
end event

event open;This.Width = 3141
This.Height = 2000

ii_num_dw = 2
 
idw_arreglo_dw[1] = dw_detalle
idw_arreglo_dw[2] = dw_unidades

CALL w_base_maestroff_detalletb_para_tabs::open
dw_encabezado.SetTransObject(SQLCA)

This.triggerevent("ue_buscar")
end event

event ue_borrar_detalle;Long li_estado
long ll_fila

li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'co_estado')
IF li_estado = 3 OR li_estado = 4 THEN
	ll_fila = idw_arreglo_dw[ii_dw_actual].GetRow()
	CHOOSE CASE ll_fila
		CASE -1
			MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
		CASE 0
			MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
		CASE ELSE
			IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
				IF (idw_arreglo_dw[ii_dw_actual].DeleteRow(ll_fila) = -1) THEN
					MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
				ELSE
					il_fila_actual_detalle[ii_dw_actual] = ll_fila - 1
					This.TriggerEvent("ue_grabar")
				END IF
			ELSE
			END IF
	END CHOOSE	
ELSE
	MessageBox("Advertencia...","No puede borrar registros de una liquidaci$$HEX1$$f300$$ENDHEX$$n que se encuentra liquidada")
END IF
end event

type dw_maestro from w_base_maestrotb_detalletb_para_tabs`dw_maestro within w_liquidaciones_espacio
integer y = 132
integer width = 2903
integer height = 804
string dataobject = "dtb_liquidaciones_ordencorte"
boolean border = true
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long li_dw_inicializar, li_liquidacion, li_tipodetalle, li_hallados
Long li_estado
Long ll_ordencorte, ll_agrupacion, ll_basetrazo

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = This.GetItemNumber(il_fila_actual_maestro, 'cs_orden_corte')
	ll_agrupacion = This.GetItemNumber(il_fila_actual_maestro, 'cs_agrupacion')
	ll_basetrazo = This.GetItemNumber(il_fila_actual_maestro, 'cs_base_trazos')
	li_liquidacion = This.GetItemNumber(il_fila_actual_maestro, 'cs_liquidacion')
	li_tipodetalle = This.GetItemNumber(il_fila_actual_maestro, 'tipo_detalle')
	li_estado = This.GetItemNumber(il_fila_actual_maestro, 'co_estado')
	IF li_estado = 6 THEN
		This.Object.DataWindow.ReadOnly = 'Yes'
		FOR li_dw_inicializar = 1 TO ii_num_dw
			idw_arreglo_dw[li_dw_inicializar].Object.DataWindow.ReadOnly = 'Yes'
		NEXT
	ELSE
		This.Object.DataWindow.ReadOnly = 'No'
		FOR li_dw_inicializar = 1 TO ii_num_dw
			idw_arreglo_dw[li_dw_inicializar].Object.DataWindow.ReadOnly = 'No'
			li_hallados = idw_arreglo_dw[li_dw_inicializar].Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, li_liquidacion)
			IF li_hallados > 0 THEN
				il_fila_actual_detalle[li_dw_inicializar] = 1
			ELSE
				il_fila_actual_detalle[li_dw_inicializar] = 0
			END IF
		NEXT
		IF il_fila_actual_detalle[1] > 0 THEN
			IF li_tipodetalle = 2 THEN
				dw_detalle.Object.ca_remanente.Protect = 1
				dw_detalle.Object.ca_remanente.Background.color = RGB(192, 192, 192)
				dw_detalle.Object.ca_imperfectos.Protect = 1
				dw_detalle.Object.ca_imperfectos.Background.color = RGB(192, 192, 192)
//				dw_detalle.Object.ca_faltantes.Protect = 1
//				dw_detalle.Object.ca_faltantes.Background.color = RGB(192, 192, 192)
//				dw_detalle.Object.ca_excedentes.Protect = 1
//				dw_detalle.Object.ca_excedentes.Background.color = RGB(192, 192, 192)
				dw_detalle.Object.ca_empates.Protect = 1
				dw_detalle.Object.ca_empates.Background.color = RGB(192, 192, 192)		
				dw_detalle.Object.ca_otros.Protect = 1
				dw_detalle.Object.ca_otros.Background.color = RGB(192, 192, 192)
			ELSE
				dw_detalle.Object.ca_remanente.Protect = 0
				dw_detalle.Object.ca_remanente.Background.color = RGB(255, 255, 255)
				dw_detalle.Object.ca_imperfectos.Protect = 0
				dw_detalle.Object.ca_imperfectos.Background.color = RGB(255, 255, 255)
//				dw_detalle.Object.ca_faltantes.Protect = 0
//				dw_detalle.Object.ca_faltantes.Background.color = RGB(255, 255, 255)
//				dw_detalle.Object.ca_excedentes.Protect = 0
//				dw_detalle.Object.ca_excedentes.Background.color = RGB(255, 255, 255)
				dw_detalle.Object.ca_empates.Protect = 0
				dw_detalle.Object.ca_empates.Background.color = RGB(255, 255, 255)		
				dw_detalle.Object.ca_otros.Protect = 0
				dw_detalle.Object.ca_otros.Background.color = RGB(255, 255, 255)		
			END IF
		END IF
	END IF
END IF
end event

event dw_maestro::updatestart;Long li_filas, li_fila_actual, li_liquidacion
Long ll_ordencorte, ll_agrupacion, ll_basetrazo

IF This.ModifiedCount() > 0 THEN
	ll_ordencorte = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_orden_corte')
	ll_agrupacion = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_agrupacion')
	ll_basetrazo = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_base_trazos')
	SELECT Max(cs_liquidacion)
	INTO :li_liquidacion
	FROM dt_liquida_espacio
	WHERE cs_orden_corte = :ll_ordencorte AND
			cs_agrupacion = :ll_agrupacion AND
			cs_base_trazos = :ll_basetrazo;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al consultar el consecutivo de liquidaci$$HEX1$$f300$$ENDHEX$$n")
		Return(1)
	END IF
	IF IsNull(li_liquidacion) THEN
		li_liquidacion = 1
	ELSE
		li_liquidacion = li_liquidacion + 1
	END IF
END IF
li_filas = This.RowCount()
FOR li_fila_actual = 1 TO li_filas
	IF This.GetItemStatus(li_fila_actual, 0, Primary!) = NewModified! THEN
		This.SetItem(li_fila_actual, 'cs_liquidacion', li_liquidacion)
		li_liquidacion = li_liquidacion + 1
	END IF
NEXT
end event

event dw_maestro::itemchanged;call super::itemchanged;Long li_tipodetalle

IF Dwo.Name = 'tipo_detalle' THEN
	li_tipodetalle = Long(Data)
	IF il_fila_actual_detalle[1] > 0 THEN
		IF li_tipodetalle = 2 THEN
			dw_detalle.Object.ca_remanente.Protect = 1
			dw_detalle.Object.ca_remanente.Background.color = RGB(192, 192, 192)
			dw_detalle.Object.ca_imperfectos.Protect = 1
			dw_detalle.Object.ca_imperfectos.Background.color = RGB(192, 192, 192)
//			dw_detalle.Object.ca_faltantes.Protect = 1
//			dw_detalle.Object.ca_faltantes.Background.color = RGB(192, 192, 192)
//			dw_detalle.Object.ca_excedentes.Protect = 1
//			dw_detalle.Object.ca_excedentes.Background.color = RGB(192, 192, 192)
			dw_detalle.Object.ca_empates.Protect = 1
			dw_detalle.Object.ca_empates.Background.color = RGB(192, 192, 192)		
			dw_detalle.Object.ca_otros.Protect = 1
			dw_detalle.Object.ca_otros.Background.color = RGB(192, 192, 192)
		ELSE
			dw_detalle.Object.ca_remanente.Protect = 0
			dw_detalle.Object.ca_remanente.Background.color = RGB(255, 255, 255)
			dw_detalle.Object.ca_imperfectos.Protect = 0
			dw_detalle.Object.ca_imperfectos.Background.color = RGB(255, 255, 255)
//			dw_detalle.Object.ca_faltantes.Protect = 0
//			dw_detalle.Object.ca_faltantes.Background.color = RGB(255, 255, 255)
//			dw_detalle.Object.ca_excedentes.Protect = 0
//			dw_detalle.Object.ca_excedentes.Background.color = RGB(255, 255, 255)
			dw_detalle.Object.ca_empates.Protect = 0
			dw_detalle.Object.ca_empates.Background.color = RGB(255, 255, 255)		
			dw_detalle.Object.ca_otros.Protect = 0
			dw_detalle.Object.ca_otros.Background.color = RGB(255, 255, 255)		
		END IF
	END IF
END IF
end event

event dw_maestro::doubleclicked;call super::doubleclicked;Long li_estado
n_cts_param lstr_parametros

IF Row > 0 THEN
	li_estado = This.GetItemNumber(Row, 'co_estado')
	IF li_estado = 5 OR li_estado = 6 THEN
		lstr_parametros.is_vector[1] = 'S'
		lstr_parametros.il_vector[1] = This.GetItemNumber(Row, 'cs_orden_corte')
		lstr_parametros.il_vector[2] = This.GetItemNumber(Row, 'cs_agrupacion')
		lstr_parametros.il_vector[3] = This.GetItemNumber(Row, 'cs_base_trazos')
		lstr_parametros.il_vector[4] = This.GetItemNumber(Row, 'cs_liquidacion')
		OpenSheetWithParm(w_reporte_liquidacion_ordencorte, lstr_parametros, w_principal)
	END IF
END IF
end event

type tab_1 from w_base_maestrotb_detalletb_para_tabs`tab_1 within w_liquidaciones_espacio
integer x = 37
integer y = 960
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_2=create tabpage_2
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_2
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
end on

type tabpage_1 from w_base_maestrotb_detalletb_para_tabs`tabpage_1 within tab_1
string text = "Rollos"
string picturename = "K:\desarrollo\Graficos\rollotela.bmp"
end type

type dw_detalle from w_base_maestrotb_detalletb_para_tabs`dw_detalle within w_liquidaciones_espacio
event ue_adicionar_fila pbm_custom01
integer x = 37
integer y = 1116
integer width = 3045
integer height = 676
string dataobject = "dtb_liquidacion_rollos"
borderstyle borderstyle = stylebox!
boolean ib_insercion_automatica = true
end type

event dw_detalle::ue_adicionar_fila;Long li_liquidacion, li_rollo
Long ll_fila, ll_ordencorte, ll_agrupacion, ll_basetrazo
s_base_parametros lstr_parametros

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_orden_corte')
	ll_agrupacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_agrupacion')
	ll_basetrazo = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_base_trazos')
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_liquidacion')
//	lstr_parametros.entero[1] = ll_ordencorte
//	lstr_parametros.entero[2] = ll_agrupacion
//	lstr_parametros.entero[3] = ll_basetrazo
//	lstr_parametros.entero[4] = li_liquidacion
//	OpenWithParm(w_seleccionar_rollos_espacio, lstr_parametros)
//	lstr_parametros = Message.PowerObjectParm
//	IF lstr_parametros.hay_parametros THEN
//		FOR li_rollo = 2 TO lstr_parametros.entero[1]
			ll_fila = idw_arreglo_dw[ii_dw_actual].InsertRow(0)			
			IF ( ll_fila > 0) THEN
				il_fila_actual_detalle[1] = ll_fila
				idw_arreglo_dw[ii_dw_actual].SetRow(ll_fila)
				idw_arreglo_dw[ii_dw_actual].ScrollToRow(ll_fila)
				idw_arreglo_dw[ii_dw_actual].SetColumn(1)
				il_fila_actual_detalle[ii_dw_actual] = ll_fila 				
				This.SetItem(ll_fila, "cs_orden_corte", ll_ordencorte)
				This.SetItem(ll_fila, "cs_agrupacion", ll_agrupacion)
				This.SetItem(ll_fila, "cs_base_trazos", ll_basetrazo)
				This.SetItem(ll_fila, "cs_liquidacion", li_liquidacion)
//				This.SetItem(ll_fila, "cs_rollo", lstr_parametros.entero[li_rollo])
//				This.SetItem(ll_fila, "ca_cortados", lstr_parametros.decimal[li_rollo])
				This.SetItem(ll_fila, "fe_creacion", DateTime(Today(), Now()))				
			ELSE
				MessageBox("Error DataWindows","Error al insertar una nueva fila")
				Return
			END IF			
//		NEXT
//	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
END IF
end event

event dw_detalle::itemchanged;Long ll_rollo, ll_reftel, ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_color
Long li_caract, li_diametro, li_fabrica, li_registros
Decimal{2} ld_disponible, ld_cortados, ld_devueltos, ld_consumidos, ld_kilos
Decimal{2} ld_consumo, 	ld_empates, ld_imperfectos, ld_remanente, ld_diferencia

IF Dwo.Name = 'cs_rollo' THEN
	ll_rollo = Long(Data)
	SELECT co_fabrica_act, co_reftel_act, co_caract_act, diametro_act,
				co_color_act, ca_kg, ca_kg_tenido, ca_kg - ca_kg_tenido
	INTO :li_fabrica, :ll_reftel, :li_caract, :li_diametro, :ll_color, 
			:ld_kilos, :ld_consumidos, :ld_disponible
	FROM m_rollo
	WHERE cs_rollo = :ll_rollo AND
         m_rollo.co_centro in (90,101) AND  
         m_rollo.co_estado_rollo in (1,2, 7) AND  
         //m_rollo.cs_ordencr = 0 AND
			ca_kg > ca_kg_tenido;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar el rollo")
		Return 1
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			MessageBox("Advertencia...","El rollo no existe o no est$$HEX2$$e1002000$$ENDHEX$$disponible para asignar a una liquidaci$$HEX1$$f300$$ENDHEX$$n")
			Return 1
		END IF
	END IF
	ll_ordencorte = This.GetItemNumber(Row, 'cs_orden_corte')
	ll_agrupacion = This.GetItemNumber(Row, 'cs_agrupacion')
	ll_basetrazo = This.GetItemNumber(Row, 'cs_base_trazos')
	SELECT Count(*)
	INTO :li_registros
	FROM dt_rayas_telaxoc
	WHERE cs_orden_corte = :ll_ordencorte AND
			cs_agrupacion = :ll_agrupacion AND
			cs_base_trazos = :ll_basetrazo AND
//			co_fabrica_tela = :li_fabrica AND
			co_reftel = :ll_reftel AND
			co_caract = :li_caract AND
			diametro = :li_diametro AND
			co_color_te = :ll_color;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar tela del rollo contra la OC")
		Return 1
	END IF
	IF li_registros = 0 THEN
		MessageBox("Advertencia...","La tela del rollo no corresponde con las telas de la OC")
		Return 1
	END IF
//	This.SetItem(Row, 'ca_cortados', ld_disponible)
	This.SetItem(Row, 'ca_consumido', ld_disponible)	
	This.SetItem(Row, 'ca_kg', ld_kilos)		
	This.SetItem(Row, 'ca_kg_tenido', ld_consumidos)		
END IF

This.AcceptText()


IF Dwo.Name = 'ca_devueltos' THEN
//	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
	ld_kilos = This.GetItemNumber(Row, 'ca_kg')
	ld_consumidos = This.GetItemNumber(Row, 'ca_kg_tenido')
	ld_devueltos = This.GetItemNumber(Row, 'ca_devueltos')
	IF IsNull(ld_kilos) THEN
		ld_kilos = 0
	END IF
	IF IsNull(ld_consumidos) THEN
		ld_consumidos = 0
	END IF	
	IF IsNull(ld_devueltos) THEN
		ld_devueltos = 0
	END IF
	ld_consumo = ld_kilos - ld_consumidos - ld_devueltos
	This.SetItem(Row, 'ca_consumido', ld_consumo)	

	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
	ld_empates = This.GetItemNumber(Row, 'ca_empates')
	ld_imperfectos = This.GetItemNumber(Row, 'ca_imperfectos')
	ld_remanente = This.GetItemNumber(Row, 'ca_remanente')
	ld_diferencia = (ld_cortados + ld_empates + ld_imperfectos + ld_remanente) - (ld_consumo)
	IF ld_diferencia > 0 THEN
		This.SetItem(Row, 'ca_excedentes', ld_diferencia)
		This.SetItem(Row, 'ca_faltantes', 0)
	ELSE
		This.SetItem(Row, 'ca_faltantes', ld_diferencia * (-1))
		This.SetItem(Row, 'ca_excedentes', 0)		
	END IF	
END IF
This.AcceptText()


IF Dwo.Name = 'ca_cortados' OR Dwo.Name = 'ca_empates' OR Dwo.Name = 'ca_imperfectos' OR &
	Dwo.Name = 'ca_remanente' THEN
	ld_consumo = This.GetItemNumber(Row, 'ca_consumido')
	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
	ld_empates = This.GetItemNumber(Row, 'ca_empates')
	ld_imperfectos = This.GetItemNumber(Row, 'ca_imperfectos')
	ld_remanente = This.GetItemNumber(Row, 'ca_remanente')
	ld_diferencia = (ld_cortados + ld_empates + ld_imperfectos + ld_remanente) - (ld_consumo)
	IF ld_diferencia > 0 THEN
		This.SetItem(Row, 'ca_excedentes', ld_diferencia)
		This.SetItem(Row, 'ca_faltantes', 0)
	ELSE
		This.SetItem(Row, 'ca_faltantes', ld_diferencia * (-1))
		This.SetItem(Row, 'ca_excedentes', 0)		
	END IF
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1129
integer height = 112
long backcolor = 79741120
string text = "Unidades"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "K:\desarrollo\Graficos\camisa.bmp"
long picturemaskcolor = 536870912
end type

type dw_encabezado from datawindow within w_liquidaciones_espacio
integer x = 37
integer y = 12
integer width = 2907
integer height = 116
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_encabezado_liquidacion_espacio"
boolean livescroll = true
end type

type dw_unidades from uo_dtwndow within w_liquidaciones_espacio
event ue_adicionar_fila ( )
integer x = 37
integer y = 1116
integer width = 3045
integer height = 672
integer taborder = 20
string dataobject = "dtb_liquidacion_unidades"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_adicionar_fila();Long ll_ordencorte, ll_agrupacion, ll_basetrazo
Long li_liquidacion, li_trazo, li_selecciones, li_tallas, li_seccion, li_fila_actual
Long li_produccion, li_talla, li_sectalla, li_unidades, li_paquetes, li_capas
String  ls_tipo
s_base_parametros lstr_parametros
DataStore lds_tallas

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	ll_agrupacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_agrupacion")
	ll_basetrazo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_base_trazos")
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	lstr_parametros.entero[1] = ll_ordencorte
	lstr_parametros.entero[2] = ll_agrupacion
	lstr_parametros.entero[3] = ll_basetrazo
	lstr_parametros.entero[4] = li_liquidacion
	OpenWithParm(w_seleccionar_espacio, lstr_parametros)
	lstr_parametros = Message.PowerObjectParm
	IF lstr_parametros.hay_parametros THEN
		lds_tallas = Create DataStore
		lds_tallas.DataObject = 'dtb_seleccionar_unidades_espacio'
		lds_tallas.SetTransObject(SQLCA)
		FOR li_selecciones = 2 TO lstr_parametros.entero[1] + 1
			li_trazo = lstr_parametros.entero[li_selecciones]
			li_tallas = lds_tallas.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, li_trazo, li_liquidacion)
			FOR li_fila_actual = 1 TO li_tallas
				li_trazo = lds_tallas.GetItemNumber(li_fila_actual, "cs_trazo")
				li_seccion = lds_tallas.GetItemNumber(li_fila_actual, "cs_seccion")
				li_produccion = lds_tallas.GetItemNumber(li_fila_actual, "cs_pdn")
				li_talla = lds_tallas.GetItemNumber(li_fila_actual, "co_talla")
				li_sectalla = lds_tallas.GetItemNumber(li_fila_actual, "cs_talla")
				li_paquetes = lds_tallas.GetItemNumber(li_fila_actual, "paquetes")
				li_unidades = lds_tallas.GetItemNumber(li_fila_actual, "pendiente")
				li_capas = li_unidades / li_paquetes
				INSERT INTO dt_liq_unidades(cs_orden_corte, cs_agrupacion, cs_base_trazos, cs_liquidacion,
					cs_trazo, cs_seccion, cs_pdn, co_talla, cs_talla, ca_prog_liq, capas, paquetes, ca_liquidadas,
					ca_loteadas, fe_creacion, fe_actualizacion, usuario, instancia)
				VALUES(:ll_ordencorte, :ll_agrupacion, :ll_basetrazo, :li_liquidacion, :li_trazo, :li_seccion,
					:li_produccion, :li_talla, :li_sectalla, :li_unidades, :li_capas, :li_paquetes, 0, 0, Current, Current,
					User, SiteName);
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al insertar registro de tallas")
					ROLLBACK;
					Return
				END IF
			NEXT
		NEXT
		Destroy lds_tallas
		COMMIT;
		idw_arreglo_dw[ii_dw_actual].Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, li_liquidacion)
	END IF
END IF
end event

event itemchanged;call super::itemchanged;Long li_capas, li_paquetes, li_unidades

This.AcceptText()
IF Dwo.Name = 'capas' OR Dwo.Name = 'paquetes' THEN
	li_capas = This.GetItemNumber(Row, 'capas')
	li_paquetes = This.GetItemNumber(Row, 'paquetes')
	li_unidades = li_paquetes * li_capas
	This.SetItem(Row, 'ca_prog_liq', li_unidades)
END IF
end event

