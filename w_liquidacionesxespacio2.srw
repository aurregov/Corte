HA$PBExportHeader$w_liquidacionesxespacio2.srw
forward
global type w_liquidacionesxespacio2 from w_base_maestrotb_detalletb_para_tabs
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_encabezado from datawindow within w_liquidacionesxespacio2
end type
type dw_unidades from uo_dtwndow within w_liquidacionesxespacio2
end type
type cb_1 from commandbutton within w_liquidacionesxespacio2
end type
end forward

global type w_liquidacionesxespacio2 from w_base_maestrotb_detalletb_para_tabs
integer width = 3150
integer height = 2228
string title = "Liquidaci$$HEX1$$f300$$ENDHEX$$n Espacio"
string menuname = "m_liquidacion"
event ue_liquidar pbm_custom01
event ue_devolver pbm_custom02
event ue_paquetes ( )
dw_encabezado dw_encabezado
dw_unidades dw_unidades
cb_1 cb_1
end type
global w_liquidacionesxespacio2 w_liquidacionesxespacio2

type variables
Long ii_paquetes, ii_espacio


end variables

forward prototypes
public function boolean of_validar_retal (long al_fila)
public function long of_validar_preliquidacion (long al_ordencorte, long al_agrupacion, long al_basetrazo, long al_trazo)
public function long of_validar_leida_corte (long al_orden_corte, long al_agrupacion, long ai_estado_validar)
end prototypes

event ue_liquidar;Long li_liquidacion, li_estado, li_pos_cortar, li_pos_inicial, ll_hallados
Long li_tipodetalle, ll_continua, li_correo, li_return, li_raya,li_capas, li_fila
Long li_estado_orden, li_registros,  li_regliq
s_base_parametros lstr_parametros_retro
Long ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo, ll_espacio, ll_reg
Long li_sw_cambio_capas
Decimal{2} ld_consumo, ld_imperfectos, ld_retal, ld_puntas, ld_sobrantes
String ls_body, ls_expresion, ls_error, ls_mensajes, ls_usuario
OLEObject lole_outlook,lole_item,lole_attach
		
ls_usuario = gstr_info_usuario.codigo_usuario 

IF il_fila_actual_maestro > 0 THEN
	
	//Cuando se realice un cambio en las capas o en los paquetes y posteriormente se ejecute 
	//la opci$$HEX1$$f300$$ENDHEX$$n liquidar se debe mandar un correo 
	//verifica si se realiza algun cambio
	li_sw_cambio_capas = 0 
	ls_mensajes = ''
	For ll_reg = 1 to dw_unidades.RowCount()
		//si hay cambio en las capas
		If (dw_unidades.GetItemNumber(ll_reg,'capas',Primary!, True) <> dw_unidades.GetItemNumber(ll_reg,'capas')) Then
			
			//se llena mensaje para el correo
			ls_mensajes = '~r~nLa orden de corte ' + String(dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")) + &
								' cambio las capas preliquidados, tenia ' + String(dw_unidades.GetItemNumber(ll_reg,'capas',Primary!, True)) + &
								' y los movieron a ' + String(dw_unidades.GetItemNumber(ll_reg,'capas')) + &
								', cambio realizado por ' + Trim(ls_usuario)

			li_sw_cambio_capas = 1
		End if
		
		//si hay cambio en los paquetes
		If (dw_unidades.GetItemNumber(ll_reg,'paquetes',Primary!, True) <> dw_unidades.GetItemNumber(ll_reg,'paquetes')) Then
			
			//se llena mensaje para el correo
			ls_mensajes = '~r~nLa orden de corte ' + String(dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")) + &
								' cambio los paquetes preliquidados, tenia ' + String(dw_unidades.GetItemNumber(ll_reg,'paquetes',Primary!, True)) + &
								' y los movieron a ' + String(dw_unidades.GetItemNumber(ll_reg,'paquetes')) + &
								', cambio realizado por ' + Trim(ls_usuario)

			li_sw_cambio_capas = 1
		End if
	Next
	
	This.TriggerEvent("ue_grabar")
	
	ll_ordencorte 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	ll_agrupacion 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_agrupacion")
	ll_basetrazo 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_base_trazos")
	ll_cs_trazo 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_trazo")
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	li_estado 		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
	li_tipodetalle = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo_detalle")
	ld_retal			= dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_retal")
	ld_puntas		= dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_puntas")
	ld_sobrantes	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_sobrantes")
	
	IF IsNull(li_liquidacion) THEN
		MessageBox("Advertencia","No ha grabado la liquidacion")
		Return
	END IF
	
	li_estado_orden = dw_encabezado.GetItemNumber(1, "co_estado")
	
	IF Not (li_estado_orden = 2 OR li_estado_orden = 5 OR li_estado = 6) THEN
		MessageBox("Advertencia...","El estado de la orden no permite que sea liquidada")
		Return
	END IF
	//------------------inicio modificaci$$HEX1$$f300$$ENDHEX$$n realizada por Juan Carlos Restrepo Medina febrero 21 de 2005
	//--se validaba la informaci$$HEX1$$f300$$ENDHEX$$n del retal, puntas y sobrantes sin importar la raya y el espacio
	//--se  debe modificar para que solo se pregunte cuando sea la raya 10 del $$HEX1$$fa00$$ENDHEX$$ltimo espacio.
	//---------------------------------------consultamos la raya
	SELECT raya
	INTO :li_raya
	FROM h_base_trazos
	WHERE cs_agrupacion  = :ll_agrupacion AND
			cs_base_trazos = :ll_basetrazo;
	IF SQLCA.SQLCode = - 1 THEN
		MessageBox("Error Base Datos","Error al consultar la raya")
		Close(w_retroalimentacion)
	END IF
	
	IF li_raya = 10 THEN
		//-----------------------------------consultamos los espacios 
		SELECT Count(*)
		INTO :li_registros
		FROM dt_trazosxoc
		WHERE  cs_orden_corte = :ll_ordencorte AND
				 cs_agrupacion  = :ll_agrupacion AND
				 cs_base_trazos = :ll_basetrazo;
		
		IF SQLCA.SQLCode = - 1 THEN
			MessageBox("Error Base Datos","Error al consultar el espacio")
			Close(w_retroalimentacion)
		END IF 	
		
		//---------------------------------consultamos los espacios liquidados
		SELECT Count(*)
		INTO :li_regliq
		FROM dt_trazosxoc
		WHERE  cs_orden_corte = :ll_ordencorte AND
				 cs_agrupacion  = :ll_agrupacion AND
				 cs_base_trazos = :ll_basetrazo AND
				 co_estado      in (5,6);

		IF SQLCA.SQLCode = - 1 THEN
			MessageBox("Error Base Datos","Error al consultar el espacio")
			Close(w_retroalimentacion)
		END IF 		  
		//-------------------------------verificar que sea el $$HEX1$$fa00$$ENDHEX$$ltimo espacio		
		IF li_registros - li_regliq = 1 THEN		
			IF ld_retal = 0 OR ld_puntas = 0 OR ld_sobrantes = 0 THEN
				MessageBox("Advertencia...","Debe ingresar informaci$$HEX1$$f300$$ENDHEX$$n de retal, puntas y sobrantes")
				Return
			END IF
		END IF
	END IF
	//------------------final modificaci$$HEX1$$f300$$ENDHEX$$n realizada por Juan Carlos Restrepo Medina febrero 21 de 2005
	
	IF li_estado = 3 OR li_estado = 4 THEN
		lstr_parametros_retro.cadena[1]="Procesando ..."
		lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
		lstr_parametros_retro.cadena[3]="reloj"
			
		OpenWithParm(w_retroalimentacion,lstr_parametros_retro)		
		
		// Vamos a verificar primero que los rollos de la liquidaci$$HEX1$$f300$$ENDHEX$$n tengan informaci$$HEX1$$f300$$ENDHEX$$n de las yardas consumidas.
		
		//verifica si el espacio tiene marca capas cero
		SELECT sum( dt_trazosxoc.capas)  
		 INTO :li_capas  
		 FROM dt_trazosxoc  
		WHERE ( dt_trazosxoc.cs_orden_corte = :ll_ordencorte ) AND  
				( dt_trazosxoc.cs_agrupacion = :ll_agrupacion ) AND  
				( dt_trazosxoc.cs_base_trazos = :ll_basetrazo ) AND
				( dt_trazosxoc.cs_trazo = :ll_cs_trazo )    ;

		if sqlca.sqlcode=-1 then
			MessageBox("Error Base Datos","Error al buscar capas del espacio")
			Return
		else
		end if
		
		if isnull(li_capas) then
			li_capas=0
		else
		end if
	ELSE
		MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n esta debe estar preparada")
	END IF
			
	DECLARE liquidar PROCEDURE FOR
		pr_liqxespacio(:ll_ordencorte, :ll_agrupacion, :ll_basetrazo, :ll_cs_trazo,:li_liquidacion, :li_tipodetalle);
	EXECUTE liquidar;
	FETCH liquidar INTO :li_correo;
	IF SQLCA.SQLCode = -1 THEN			
		IF SQLCA.SQLDBCode = -746 THEN
			li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
			ls_error = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox("Error Base Datos", Mid(ls_error, li_pos_inicial + 1, Len(ls_error) - (li_pos_inicial + 1)))
			
		ELSE
			ls_error = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox("Error Base Datos","Error al ejecutar el stored procedure." +ls_error)
			
		END IF
	ELSE
		COMMIT;
	END IF


	//si envia correo por cambio en las capas
	If li_sw_cambio_capas = 1 Then
		//ls_body = 'Cambio de unidades en liquidaci$$HEX1$$f300$$ENDHEX$$n OC ' + String(ll_ordencorte)
		//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 46 es el que pertenece a este proceso en la tabla m_usu_correo
		/*
		Declare pr_envia_correo Procedure For pr_envia_correo( :ls_body, &
					:ls_mensajes,46,:ls_usuario); 
		Execute pr_envia_correo;
		If SQLCA.SQLCODE = -1 Then
			ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
			RollBack;
			MessageBox("Atencion", "Error enviando correo por Cambio de unidades en liquidaci$$HEX1$$f300$$ENDHEX$$n OC "  + String(ll_ordencorte) + ' . '+ls_error, StopSign!)
			Close pr_envia_correo;
		End If
		// Cierra el procedimiento almacenado declarado
		Close pr_envia_correo;
		*/
		uo_correo	lnv_correo
		lnv_correo = CREATE uo_correo
		
		TRY
			lnv_correo.of_enviar_correo('Cambio de unidades en liquidaci$$HEX1$$f300$$ENDHEX$$n OC ' + String(ll_ordencorte), ls_mensajes,'cambiocapasliquid',ls_usuario)
		CATCH(Exception ex)
			Messagebox("Error", ex.getmessage())
		END TRY
		
		DESTROY lnv_correo 
		
	End if
	
			IF li_correo = 1 THEN
				SELECT raya
				INTO :li_raya
				FROM h_base_trazos
				WHERE cs_agrupacion = :ll_agrupacion AND
						cs_base_trazos = :ll_basetrazo;
				IF SQLCA.SQLCode = - 1 THEN
					MessageBox("Error Base Datos","Error al consultar la raya")
					Close(w_retroalimentacion)
				END IF
				
				lole_outlook = Create OLEObject
				
				li_return = lole_outlook.ConnectToNewObject("outlook.application")
				
				If li_return <> 0 Then
					Messagebox("Advertencia!","No se pudo establecer conexi$$HEX1$$f300$$ENDHEX$$n con Outlook.~n~nError : " &
								 + String(li_return) )
					Destroy lole_outlook
					Close(w_retroalimentacion)
					Return li_return
				End If
				
				ls_body = 'Se present$$HEX2$$f3002000$$ENDHEX$$una variaci$$HEX1$$f300$$ENDHEX$$n negativa al liquidar el siguiente trazo: ~n~n'
				ls_body = ls_body + 'Orden Corte: ' + String(ll_ordencorte) + '~n~n'
				ls_body = ls_body + 'Raya: ' + String(li_raya) + '~n~n'
				ls_body = ls_body + 'Espacio: ' + String(ll_cs_trazo)
				lole_item = lole_outlook.CreateItem(0)
				
				lole_item.To      = "Luis Javier Garcia"
				lole_item.Subject = "Variaci$$HEX1$$f300$$ENDHEX$$n Orden Corte"
				lole_item.Body    = ls_body
				
				lole_item.Send
				
				Destroy lole_item

			END IF


	dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
	ll_hallados = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
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
//	ls_expresion = "cs_liquidacion = " + String(li_liquidacion)
	li_fila = dw_maestro.Find("cs_liquidacion = " + String(li_liquidacion), 1, dw_maestro.RowCount())
	IF li_fila > 0 THEN
		ld_imperfectos = dw_maestro.GetItemNumber(li_fila, "ca_imperfectos")
		IF ld_imperfectos > 0 THEN
			IF MessageBox("Reposici$$HEX1$$f300$$ENDHEX$$n Tela","Se han detectado imperfectos en los rollos. Desea generar una reposici$$HEX1$$f300$$ENDHEX$$n de tela", Question!, YesNo!) = 1 THEN
				lstr_parametros_retro.entero[1] = ll_ordencorte
				lstr_parametros_retro.entero[2] = ll_agrupacion
				lstr_parametros_retro.entero[3] = ll_basetrazo
				lstr_parametros_retro.entero[4] = ll_cs_trazo
				lstr_parametros_retro.entero[5] = li_liquidacion
				lstr_parametros_retro.hay_parametros = True
				OpenSheetWithParm(w_generar_reposicion_tela, lstr_parametros_retro, This)
			END IF
		END IF
	END IF
	Close(w_retroalimentacion)

	
ELSE
	MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n tiene que seleccionar primero un registro de liquidaci$$HEX1$$f300$$ENDHEX$$n")
END IF
end event

event ue_devolver;Long li_liquidacion,li_estado,li_pos_cortar,li_pos_inicial,ll_hallados
Long li_estado_oc,li_tipodetalle
Long ll_ordencorte,ll_agrupacion,ll_basetrazo,ll_cs_trazo
s_base_parametros lstr_parametros_retro
		
IF il_fila_actual_maestro > 0 THEN		
	ll_ordencorte 	= dw_maestro.GetItemNumber(il_fila_actual_maestro,"cs_orden_corte")
	ll_agrupacion 	= dw_maestro.GetItemNumber(il_fila_actual_maestro,"cs_agrupacion")
	ll_basetrazo 	= dw_maestro.GetItemNumber(il_fila_actual_maestro,"cs_base_trazos")
	ll_cs_trazo 	= dw_maestro.GetItemNumber(il_fila_actual_maestro,"cs_trazo")
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro,"cs_liquidacion")
	li_estado 		= dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_estado")
	li_estado_oc 	= dw_encabezado.GetItemNumber(1,"co_estado")
	li_tipodetalle = dw_maestro.GetItemNumber(il_fila_actual_maestro,"tipo_detalle")	
	IF IsNull(li_liquidacion) THEN
		MessageBox("Advertencia","No ha grabado la liquidacion")
	ELSE
		IF li_estado = 6 AND (li_estado_oc = 5 OR li_estado_oc = 6) THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
		
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)		
			
//			//antes de devolver la liquidaci$$HEX1$$f300$$ENDHEX$$n se debe verificar que la orden de corte no se encuentre loteada.
//			SELECT NVL(max(h.co_estado),0)
//			  INTO :li_estado
//			  FROM h_canasta_corte h, dt_canasta_corte d
//			 WHERE h.cs_canasta = d.cs_canasta AND
//			 	    d.cs_orden_corte = :ll_ordencorte;
//					  
//			IF sqlca.sqlcode = 1 THEN
//			   MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la orden de corte. '+Sqlca.sqlErrText)
//				Return
//			END IF
//			
//			IF li_estado > 10 THEN
//				MessageBox('Error','No es posible devolver la liquidaci$$HEX1$$f300$$ENDHEX$$n, ya que la O.C. se encuentra loteada.')
//				Return 
//			END IF
			
			
			DECLARE devolver PROCEDURE FOR
				pr_devliqxespacio(:ll_ordencorte, :ll_agrupacion, :ll_basetrazo, :ll_cs_trazo,:li_liquidacion, :li_tipodetalle);
			EXECUTE devolver;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
					li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
				ELSE
				ROLLBACK;
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
				END IF
				ROLLBACK;
			ELSE
				COMMIT;
			END IF
			Close(w_retroalimentacion)
			dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
			ll_hallados = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
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

event ue_paquetes();//se coloca en comentario para no permitir cambiar paquetes
//javier garcia
//marzo 17 de 2009

dw_unidades.SetTabOrder('paquetes', 20)
ii_paquetes = 1

dw_unidades.Object.paquetes.Background.Color = RGB(255,255,255)






//dw_unidades.Modify("paquetes.Background.Mode='0'")
//
//dw_unidades.Modify("paquetes.Background.Color=rgb(255,255,255)")
//
end event

public function boolean of_validar_retal (long al_fila);Return True
end function

public function long of_validar_preliquidacion (long al_ordencorte, long al_agrupacion, long al_basetrazo, long al_trazo);Long li_registros

SELECT Count(*)
INTO :li_registros
FROM dt_liquidaxespacio
WHERE cs_orden_corte = :al_ordencorte AND
		cs_agrupacion = :al_agrupacion AND
		cs_base_trazos = :al_basetrazo AND
		cs_trazo = :al_trazo;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar existencia de la preliquidaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
	Return -1
END IF

IF li_registros > 0 THEN
	//MessageBox("Advertencia...","Este espacio ya tiene preliquidaci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
END IF

Return 1
end function

public function long of_validar_leida_corte (long al_orden_corte, long al_agrupacion, long ai_estado_validar);//validar que la orden de corte se leyo en la maq cortadora, cuando se
//lee se actualiza el estado en dt_rayas_telaxoc a 14.
//jorodrig   agosto 4 - 09
Long	li_estado, li_pendientes


SELECT MAX(co_estado)
  INTO :li_estado
  FROM dt_rayas_telaxoc
 WHERE cs_orden_corte = :al_orden_corte
   AND cs_agrupacion = :al_agrupacion;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar Si la orden esta leida en cortado " + SQLCA.SQLErrText)
	Return -1
END IF
	
	
IF li_estado <> ai_estado_validar THEN
	MessageBox('Advertencia','La orden de corte no esta leida en la maquina cortadora')
	Return -1
END IF

Select count(*)
Into :li_pendientes
From dt_rayas_telaxoc
Where cs_orden_corte = :al_orden_corte
      And cs_agrupacion = :al_agrupacion
      And co_estado <> :ai_estado_validar;
 
If li_pendientes > 0 THEN
   MessageBox('Advertencia','La orden de corte tiene modelos pendientes por leer en cortado')
	Return -1
End if


Return 1

end function

on w_liquidacionesxespacio2.create
int iCurrent
call super::create
if this.MenuName = "m_liquidacion" then this.MenuID = create m_liquidacion
this.dw_encabezado=create dw_encabezado
this.dw_unidades=create dw_unidades
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_encabezado
this.Control[iCurrent+2]=this.dw_unidades
this.Control[iCurrent+3]=this.cb_1
end on

on w_liquidacionesxespacio2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_encabezado)
destroy(this.dw_unidades)
destroy(this.cb_1)
end on

event ue_buscar;call super::ue_buscar;//se adiciona la validacion para que la orden tenga que ser leida primero en la
//maquina cortadora antes de liquidarla, al leer en maquina se actualiza el estado
//en la tabla dt_rayas_telaxoc a 14 (CORTANDO)
//jorodrig   agosto 4 - 09
Long li_dw_inicializar, li_liquidacion
Long ll_hallados, ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo,ll_cs_liquidacion
s_base_parametros lstr_parametros

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_buscar_espaciosxoc)
	lstr_parametros = Message.PowerObjectParm
	IF lstr_parametros.hay_parametros THEN
		ll_ordencorte 			= lstr_parametros.entero[1]
		ll_agrupacion 			= lstr_parametros.entero[2]
		ll_basetrazo 			= lstr_parametros.entero[3]
		ll_cs_trazo				= lstr_parametros.entero[4]
		ll_cs_liquidacion 	= lstr_parametros.entero[5]
		
		ii_espacio 				= lstr_parametros.entero[4] 			
		
		//********************habilito datawindows
		dw_maestro.Object.DataWindow.ReadOnly = 'No'
		FOR li_dw_inicializar = 1 TO ii_num_dw
			idw_arreglo_dw[li_dw_inicializar].Object.DataWindow.ReadOnly = 'No'
		NEXT
		//*****************************************

		ll_hallados = dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
		IF ll_hallados > 0 THEN
			//se verifica que el registro este preliquidado de lo contrario no se deja continuar
			//esto se hace por peticion de Javier Garcia
			//jcrm
			//agosto 22 de 2007
			IF of_validar_preliquidacion(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo) = 1 THEN
				MessageBox('Error','Para utilizar esta opci$$HEX1$$f300$$ENDHEX$$n primero debe estar preliquidado el espacio.')
				Close(This)
			END IF
			//El 14 es el estado que es cortando en este caso
			//retorna -1 si no cumple la validacion
			IF of_validar_leida_corte(ll_ordencorte, ll_agrupacion, 14) = -1 THEN
				Close(This)							
			END IF
			
			ll_hallados = dw_maestro.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
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
							ll_hallados = idw_arreglo_dw[li_dw_inicializar].Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo ,li_liquidacion)
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

event ue_insertar_maestro;//Long li_hallados
//Long ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo
//s_base_parametros lstr_parametros
//
////IF il_fila_actual_maestro > 0 THEN
//	Open(w_buscar_espacioxcb)
//	lstr_parametros = Message.PowerObjectParm
//	dw_encabezado.Reset()
//	dw_maestro.Reset()
//	CALL w_base_maestrotb_detalletb_para_tabs::ue_insertar_maestro
//	IF lstr_parametros.hay_parametros THEN		
//		
//				
//		ll_ordencorte 	= lstr_parametros.entero[1]
//		ll_agrupacion 	= lstr_parametros.entero[2]
//		ll_basetrazo 	= lstr_parametros.entero[3]
//		ll_cs_trazo		= lstr_parametros.entero[4]
//		
//		li_hallados = dw_encabezado.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo)
//		IF li_hallados = 0 THEN
//			MessageBox("Advertencia...","El espacio no existe en la base datos")
//			dw_maestro.DeleteRow(il_fila_actual_maestro)
//			il_fila_actual_maestro = il_fila_actual_maestro - 1				
//			Return
//		END IF
//		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_orden_corte', ll_ordencorte)
//		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_agrupacion', ll_agrupacion)
//		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_base_trazos', ll_basetrazo)
//		dw_maestro.SetItem(il_fila_actual_maestro, 'cs_trazo', ll_cs_trazo)
//	ELSE
//		dw_maestro.DeleteRow(il_fila_actual_maestro)
//		il_fila_actual_maestro = il_fila_actual_maestro - 1
//	END IF
////END IF
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

event open;TRANSACTION			itr_tela

This.Width = 3141
This.Height = 2000

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

IF gstr_info_usuario.co_planta_pro = 99 THEN
	cb_1.Visible = True
END IF


ii_num_dw = 2
 
idw_arreglo_dw[1] = dw_detalle
idw_arreglo_dw[2] = dw_unidades

itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
//itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

CALL w_base_maestroff_detalletb_para_tabs::open


dw_encabezado.SetTransObject(itr_tela)

This.triggerevent("ue_buscar")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_encabezado.SetTransObject(SQLCA)

end event

event ue_borrar_detalle;//Long li_estado
//long ll_fila
//
//li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, 'co_estado')
//IF li_estado = 3 OR li_estado = 4 THEN
//	ll_fila = idw_arreglo_dw[ii_dw_actual].GetRow()
//	CHOOSE CASE ll_fila
//		CASE -1
//			MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
//		CASE 0
//			MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
//		CASE ELSE
//			IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
//				IF (idw_arreglo_dw[ii_dw_actual].DeleteRow(ll_fila) = -1) THEN
//					MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
//				ELSE
//					il_fila_actual_detalle[ii_dw_actual] = ll_fila - 1
//					This.TriggerEvent("ue_grabar")
//				END IF
//			ELSE
//			END IF
//	END CHOOSE	
//ELSE
//	MessageBox("Advertencia...","No puede borrar registros de una liquidaci$$HEX1$$f300$$ENDHEX$$n que se encuentra liquidada")
//END IF
end event

event ue_grabar;call super::ue_grabar;dw_unidades.SetTabOrder(16, 0)
ii_paquetes = 0

dw_unidades.Object.paquetes.Background.Color = RGB(218, 218, 218)

end event

type dw_maestro from w_base_maestrotb_detalletb_para_tabs`dw_maestro within w_liquidacionesxespacio2
integer y = 132
integer width = 3040
integer height = 804
string dataobject = "dtb_maestro_liqxespacio"
boolean hscrollbar = true
boolean border = true
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long li_dw_inicializar, li_liquidacion, li_tipodetalle, li_hallados
Long li_estado
Long ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo

This.AcceptText()

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = This.GetItemNumber(il_fila_actual_maestro, 'cs_orden_corte')
	ll_agrupacion = This.GetItemNumber(il_fila_actual_maestro, 'cs_agrupacion')
	ll_basetrazo = This.GetItemNumber(il_fila_actual_maestro, 'cs_base_trazos')
	ll_cs_trazo = This.GetItemNumber(il_fila_actual_maestro, 'cs_trazo')
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
			if isnull(ll_ordencorte) or isnull(ll_agrupacion) or isnull(ll_basetrazo) or &
				isnull(ll_cs_trazo) or isnull(li_liquidacion) then
				li_hallados=0
			else
				li_hallados = idw_arreglo_dw[li_dw_inicializar].Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_cs_trazo,li_liquidacion)
			end if
			
			
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
//				dw_detalle.Object.ca_otros.Protect = 1
//				dw_detalle.Object.ca_otros.Background.color = RGB(192, 192, 192)
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
//				dw_detalle.Object.ca_otros.Protect = 0
//				dw_detalle.Object.ca_otros.Background.color = RGB(255, 255, 255)		
			END IF
		END IF
	END IF
END IF
end event

event dw_maestro::updatestart;Long li_filas, li_fila_actual, li_liquidacion
Long ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_cs_trazo

IF This.ModifiedCount() > 0 THEN
	ll_ordencorte = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_orden_corte')
	ll_agrupacion = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_agrupacion')
	ll_basetrazo = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_base_trazos')
	ll_cs_trazo = dw_encabezado.GetItemNumber(dw_encabezado.GetRow(), 'cs_trazo')
	SELECT Max(cs_liquidacion)
	INTO :li_liquidacion
	FROM dt_liquidaxespacio
	WHERE cs_orden_corte = :ll_ordencorte AND
			cs_agrupacion = :ll_agrupacion AND
			cs_base_trazos = :ll_basetrazo AND
			cs_trazo = :ll_cs_trazo			;
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
		This.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
		This.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
		This.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
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
//			dw_detalle.Object.ca_otros.Protect = 1
//			dw_detalle.Object.ca_otros.Background.color = RGB(192, 192, 192)
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
//			dw_detalle.Object.ca_otros.Protect = 0
//			dw_detalle.Object.ca_otros.Background.color = RGB(255, 255, 255)		
		END IF
	END IF
END IF
end event

event dw_maestro::doubleclicked;call super::doubleclicked;//Long li_estado
//n_cts_param lstr_parametros
//
//IF Row > 0 THEN
//	li_estado = This.GetItemNumber(Row, 'co_estado')
//	IF li_estado = 5 OR li_estado = 6 THEN
//		lstr_parametros.is_vector[1] = 'S'
//		lstr_parametros.il_vector[1] = This.GetItemNumber(Row, 'cs_orden_corte')
//		lstr_parametros.il_vector[2] = This.GetItemNumber(Row, 'cs_agrupacion')
//		lstr_parametros.il_vector[3] = This.GetItemNumber(Row, 'cs_base_trazos')
//		lstr_parametros.il_vector[4] = This.GetItemNumber(Row, 'cs_base_trazos')
//		lstr_parametros.il_vector[5] = This.GetItemNumber(Row, 'cs_liquidacion')
//		OpenSheetWithParm(w_reporte_liquidacion_ordencorte_nueva, lstr_parametros, w_principal)
//	END IF
//END IF
end event

type tab_1 from w_base_maestrotb_detalletb_para_tabs`tab_1 within w_liquidacionesxespacio2
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

type dw_detalle from w_base_maestrotb_detalletb_para_tabs`dw_detalle within w_liquidacionesxespacio2
event ue_adicionar_fila pbm_custom01
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 1112
integer width = 3045
integer height = 676
boolean enabled = false
string dataobject = "dtb_liq_rollosxespacio"
boolean maxbox = true
borderstyle borderstyle = stylebox!
boolean ib_insercion_automatica = true
end type

event dw_detalle::ue_adicionar_fila;//Long 				li_cs_liquidacion,li_cs_agrupacion,	li_cs_basetrazo,li_cs_trazo
//Long				li_fabrica,li_caract, li_diametro, li_registros, li_mercada
//LONG 					ll_cs_orden_corte,	ll_registros,ll_cs_rollo,ll_reftel, ll_color
//LONG					ll_regactual,ll_fila,ll_rollo
//decimal				ld_kilos, ld_consumidos, ld_disponible
//datetime 			ldt_current
//n_cts_constantes	luo_constantes
//
//s_base_parametros lstr_parametros
//
//
//IF il_fila_actual_maestro > 0 THEN
//	ll_cs_orden_corte 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_orden_corte')
//	li_cs_agrupacion 		= dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_agrupacion')
//	li_cs_basetrazo 		= dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_base_trazos')
//	li_cs_trazo 			= dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_trazo')
//	li_cs_liquidacion 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, 'cs_liquidacion')
//
//	lstr_parametros.entero[1]=ll_cs_orden_corte
//	lstr_parametros.entero[2]=li_cs_agrupacion
//	lstr_parametros.entero[3]=li_cs_basetrazo
//	lstr_parametros.entero[4]=li_cs_trazo
//	
//	lstr_parametros.hay_parametros=TRUE
//	
//	OpenWithParm(w_leer_rollos_a_liquidar, lstr_parametros)
//	lstr_parametros = Message.PowerObjectParm
//	
//	IF lstr_parametros.hay_parametros THEN
//		
//		luo_constantes = Create n_cts_constantes
//		
//		li_mercada = luo_constantes.of_consultar_numerico("MERCADA ASIGNADA")
//		
//		IF li_mercada = -1 THEN
//			Return 1
//		END IF
//			
//		ll_registros = lstr_parametros.entero[1]
//		
//		FOR ll_regactual = 2 TO ll_registros
//			
//			ll_fila = InsertRow(0)
//			IF ll_fila <> -1 THEN
//				
//				ll_cs_rollo			=	lstr_parametros.entero[ll_regactual]
//				
//         	SetItem(ll_fila, "cs_rollo", 	ll_cs_rollo)
//				SetItem(ll_fila, "cs_pdn", 	0)
//				
//				SELECT co_fabrica_act, co_reftel_act, co_caract_act, diametro_act,
//							co_color_act, ca_kg, 0, ca_mt
//				INTO :li_fabrica, :ll_reftel, :li_caract, :li_diametro, :ll_color, 
//						:ld_kilos, :ld_consumidos, :ld_disponible
//				FROM m_rollo
//				WHERE cs_rollo = :ll_cs_rollo AND
//						m_rollo.co_centro in (90, 91) AND  
//						m_rollo.co_estado_rollo = 7;
//				IF SQLCA.SQLCode = -1 THEN
//					MessageBox("Error Base Datos","No pudo traer datos para validar el rollo")
//					Return 1
//				ELSE
//					IF SQLCA.SQLCode = 100 THEN
//						MessageBox("Advertencia...","El rollo no existe o no est$$HEX2$$e1002000$$ENDHEX$$disponible para asignar a una liquidaci$$HEX1$$f300$$ENDHEX$$n")
//						Return 1
//					END IF
//				END IF
//				
//				SELECT Count(*)
//				INTO :li_registros
//				FROM h_mercada, dt_rollosmercada
//				WHERE h_mercada.cs_orden_corte = :ll_cs_orden_corte AND
//						h_mercada.cs_mercada = dt_rollosmercada.cs_mercada AND
//						dt_rollosmercada.cs_rollo = :ll_cs_rollo AND
//						dt_rollosmercada.co_estado_mercada = :li_mercada;
//						
//				IF SQLCA.SQLCode = -1 THEN
//					MessageBox("Error Base Datos","No se pudo validar el rollo en la mercada " + SQLCA.SQLErrText)
//					Return 1
//				END IF
//				
//				IF li_registros = 0 THEN
//					MessageBox("Advertencia...","El rollo no est$$HEX2$$e1002000$$ENDHEX$$asignado a la orden de corte")
//					Return 1
//				END IF
//
//				This.SetItem(ll_fila, 'ca_consumido', 0)	
//				This.SetItem(ll_fila, 'ca_kilos', ld_kilos)		
//				This.SetItem(ll_fila, 'ca_mt', ld_disponible)		
//				This.SetItem(ll_fila, 'ca_kg_tenido', ld_consumidos)		
//				This.SetItem(ll_fila, "dt_liq_rolxespacio_cs_orden_corte", ll_cs_orden_corte)
//				This.SetItem(ll_fila, "dt_liq_rolxespacio_cs_agrupacion", li_cs_agrupacion)
//				This.SetItem(ll_fila, "dt_liq_rolxespacio_cs_base_trazos", li_cs_basetrazo)
//				This.SetItem(ll_fila, "dt_liq_rolxespacio_cs_trazo", li_cs_trazo)
//				This.SetItem(ll_fila, "dt_liq_rolxespacio_cs_liquidacion", li_cs_liquidacion)
//				ldt_current=f_fecha_servidor()
//				This.SetItem(ll_fila, "dt_liq_rolxespacio_fe_creacion", ldt_current)	
//				This.SetItem(ll_fila, "cs_sec_rollo", ll_fila)	
//				This.SetItem(ll_fila, "ca_otros", 0)	
//			ELSE
//				MessageBox("Error DataWindow","Error al insertar fila")
//				Return(-1)
//			END IF
//		NEXT
//		AcceptText()
//	else
//	end if	
//	
//else 
//		MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
//end if		
end event

event dw_detalle::ue_enter;//If This.AcceptText() = 1 Then
//   Send(Handle(this),256,9,Long(0,0))
//   Return 0
//Else
//   Return -1
//End If
//
//
end event

event dw_detalle::itemchanged;//Long ll_rollo, ll_reftel, ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo, ll_color
//Long li_caract, li_diametro, li_fabrica, li_registros,li_cs_pdn
//Decimal{2} ld_disponible, ld_cortados, ld_devueltos, ld_consumidos, ld_kilos
//Decimal{2} ld_consumo, 	ld_empates, ld_imperfectos, ld_remanente, ld_diferencia
//string ls_lote
//
//IF Dwo.Name = 'cs_pdn' THEN
//	li_cs_pdn = Long(Data)
//	ll_ordencorte = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_orden_corte')
//	ll_agrupacion = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_agrupacion')
//	ll_basetrazo = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_base_trazos')
//	ll_cs_trazo = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_trazo')
//	//busca los lotes por producci$$HEX1$$f300$$ENDHEX$$n
//	SELECT dt_agrupa_pdn.co_color_pt || dt_agrupa_pdn.tono || dt_agrupa_pdn.cs_liberacion  
//    INTO :ls_lote  
//    FROM dt_agrupa_pdn  
//   WHERE ( dt_agrupa_pdn.cs_agrupacion = :ll_agrupacion ) AND  
//         ( dt_agrupa_pdn.cs_pdn = :li_cs_pdn )   ;
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no pudo buscar el lote para la producci$$HEX1$$f300$$ENDHEX$$n")
//		return 1
//	else
//	end if
//	
//	if isnull(ls_lote) then
//		messagebox("error datos","no pudo hallar el lote para la producci$$HEX1$$f300$$ENDHEX$$n, por favor verifique")
//		return 1
//	else
//		This.SetItem(Row, 'lote', ls_lote)		
//		This.AcceptText()
//	end if
//
//else
//end if
//
//IF Dwo.Name = 'cs_rollo' THEN
//	ll_rollo = Long(Data)
//	SELECT co_fabrica_act, co_reftel_act, co_caract_act, diametro_act,
//				co_color_act, ca_mt, ca_kg_tenido, ca_kg - ca_kg_tenido
//	INTO :li_fabrica, :ll_reftel, :li_caract, :li_diametro, :ll_color, 
//			:ld_kilos, :ld_consumidos, :ld_disponible
//	FROM m_rollo
//	WHERE cs_rollo = :ll_rollo AND
//         m_rollo.co_centro in (90, 91) AND  
//         m_rollo.co_estado_rollo = 7 AND  
//         m_rollo.cs_ordencr = 0 AND
//			ca_kg > 0;
//	IF SQLCA.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","No pudo traer datos para validar el rollo")
//		Return 1
//	ELSE
//		IF SQLCA.SQLCode = 100 THEN
//			MessageBox("Advertencia...","El rollo no existe o no est$$HEX2$$e1002000$$ENDHEX$$disponible para asignar a una liquidaci$$HEX1$$f300$$ENDHEX$$n")
//			Return 1
//		END IF
//	END IF
//	ll_ordencorte = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_orden_corte')
//	ll_agrupacion = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_agrupacion')
//	ll_basetrazo = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_base_trazos')
//	ll_cs_trazo = This.GetItemNumber(Row, 'dt_liq_rolxespacio_cs_trazo')
//	SELECT Count(*)
//	INTO :li_registros
//	FROM dt_rayas_telaxoc
//	WHERE cs_orden_corte = :ll_ordencorte AND
//			cs_agrupacion = :ll_agrupacion AND
//			cs_base_trazos = :ll_basetrazo AND
////			co_fabrica_tela = :li_fabrica AND
//			co_reftel = :ll_reftel AND
//			co_caract = :li_caract AND
//			diametro = :li_diametro AND
//			co_color_te = :ll_color;
//	IF SQLCA.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","Error al validar tela del rollo contra la OC")
//		Return 1
//	END IF
//	IF li_registros = 0 THEN
//		MessageBox("Advertencia...","La tela del rollo no corresponde con las telas de la OC")
//		Return 1
//	END IF
////	This.SetItem(Row, 'ca_cortados', ld_disponible)
//	This.SetItem(Row, 'ca_consumido', 0)	
//	This.SetItem(Row, 'ca_kg', ld_kilos)		
////	This.SetItem(Row, 'ca_kg_tenido', ld_consumidos)		
//END IF
//This.AcceptText()
//
//
////IF Dwo.Name = 'ca_devueltos' THEN
////	ld_consumo = This.GetItemNumber(Row, 'ca_consumido')
////	
////	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
////	ld_empates = This.GetItemNumber(Row, 'ca_empates')
////	ld_imperfectos = This.GetItemNumber(Row, 'ca_imperfectos')
////	ld_remanente = This.GetItemNumber(Row, 'ca_remanente')
////	
////	ld_kilos = This.GetItemNumber(Row, 'ca_kg')
////	ld_consumidos = This.GetItemNumber(Row, 'ca_kg_tenido')
////	ld_devueltos = This.GetItemNumber(Row, 'ca_devueltos')
////	
////	ld_diferencia= ld_kilos - ld_consumo - ld_devueltos
////	
////	if ld_diferencia < 0 then
////		messagebox("Error datos","No puede tener faltante negativo")
////		return
////	else
////	end if
////	
////	This.SetItem(Row, 'ca_faltantes', ld_diferencia )
////	This.SetItem(Row, 'ca_consumido', ld_consumo + ld_diferencia )
////	
////	
////	
////		
////	
//////	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
//////	ld_kilos = This.GetItemNumber(Row, 'ca_kg')
//////	ld_consumidos = This.GetItemNumber(Row, 'ca_kg_tenido')
//////	ld_devueltos = This.GetItemNumber(Row, 'ca_devueltos')
//////	IF IsNull(ld_kilos) THEN
//////		ld_kilos = 0
//////	END IF
//////	IF IsNull(ld_consumidos) THEN
//////		ld_consumidos = 0
//////	END IF	
//////	IF IsNull(ld_devueltos) THEN
//////		ld_devueltos = 0
//////	END IF
//////	ld_consumo = ld_kilos - ld_consumidos - ld_devueltos
//////	This.SetItem(Row, 'ca_consumido', ld_consumo)	
//////
//////	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
//////	ld_empates = This.GetItemNumber(Row, 'ca_empates')
//////	ld_imperfectos = This.GetItemNumber(Row, 'ca_imperfectos')
//////	ld_remanente = This.GetItemNumber(Row, 'ca_remanente')
//////	ld_diferencia = (ld_cortados + ld_empates + ld_imperfectos + ld_remanente) - (ld_consumo)
//////	IF ld_diferencia > 0 THEN
//////		This.SetItem(Row, 'ca_excedentes', ld_diferencia)
//////		This.SetItem(Row, 'ca_faltantes', 0)
//////	ELSE
//////		This.SetItem(Row, 'ca_faltantes', ld_diferencia * (-1))
//////		This.SetItem(Row, 'ca_excedentes', 0)		
//////	END IF	
////END IF
//
//This.AcceptText()
//
//IF Dwo.Name = 'ca_cortados' OR Dwo.Name = 'ca_empates' OR Dwo.Name = 'ca_imperfectos' OR &
//	Dwo.Name = 'ca_remanente' THEN
//	
//	ld_consumo = This.GetItemNumber(Row, 'ca_consumido')
//	
//	ld_cortados = This.GetItemNumber(Row, 'ca_cortados')
//	ld_empates = This.GetItemNumber(Row, 'ca_empates')
//	ld_imperfectos = This.GetItemNumber(Row, 'ca_imperfectos')
//	ld_remanente = This.GetItemNumber(Row, 'ca_remanente')
//	
//	ld_kilos = This.GetItemNumber(Row, 'ca_mt')
//	ld_consumidos = This.GetItemNumber(Row, 'ca_kg_tenido')
//	ld_devueltos = This.GetItemNumber(Row, 'ca_devueltos')
//	
//	ld_consumo=ld_cortados+ld_empates+ld_imperfectos+ld_remanente
//		
//	
//	ld_diferencia = ld_kilos - ld_consumo
//	
//	choose case ld_diferencia
//		case  IS > 0
//			This.SetItem(Row, 'ca_excedentes',0)
//			This.SetItem(Row, 'ca_faltantes', 0)
//			This.SetItem(Row, 'ca_devueltos', ld_diferencia)
//			This.SetItem(Row, 'ca_consumido', ld_consumo)
//		case 0
//			This.SetItem(Row, 'ca_excedentes',0)
//			This.SetItem(Row, 'ca_faltantes', 0)
//			This.SetItem(Row, 'ca_devueltos', 0)
//			This.SetItem(Row, 'ca_consumido', ld_consumo)
//		case IS < 0
//			This.SetItem(Row, 'ca_excedentes',ld_diferencia * (-1))
//			This.SetItem(Row, 'ca_faltantes', 0)
//			This.SetItem(Row, 'ca_devueltos', 0)
//			This.SetItem(Row, 'ca_consumido', ld_consumo)
//	end choose
//
//	
//END IF
//This.AcceptText()
//
//
//
//
//
end event

event dw_detalle::updatestart;call super::updatestart;//Long li_filas, li_fila_actual, li_liquidacion
//Long ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_cs_trazo
//datetime ldt_current
//
//li_filas = This.RowCount()
//FOR li_fila_actual = 1 TO li_filas
//	IF This.GetItemStatus(li_fila_actual, 0, Primary!) = NewModified! THEN
//		//ldt_current=f_fecha_servidor()
//		This.SetItem(il_fila_actual_maestro, "dt_liq_rolxespacio_fe_actualizacion", f_fecha_servidor())
//		This.SetItem(il_fila_actual_maestro, "dt_liq_rolxespacio_usuario", gstr_info_usuario.codigo_usuario)
//		This.SetItem(il_fila_actual_maestro, "dt_liq_rolxespacio_instancia", gstr_info_usuario.instancia)
//	END IF
//NEXT
//
//
//
end event

event dw_detalle::doubleclicked;call super::doubleclicked;//Long ll_orden
//s_base_parametros lstr_parametros
//
//ll_orden = dw_encabezado.GetItemNumber(1,'cs_orden_corte')
//
//lstr_parametros.entero[1] = ll_orden
//
//OpenWithParm(w_buscar_producciones,lstr_parametros)
//
//lstr_parametros=message.powerObjectparm
//
//If lstr_parametros.cadena[1] = 'SI' Then
//	dw_detalle.Setitem(row,'cs_pdn',lstr_parametros.entero[1])
//	dw_detalle.AcceptText()
//End if
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

type dw_encabezado from datawindow within w_liquidacionesxespacio2
integer x = 37
integer y = 12
integer width = 2907
integer height = 116
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_maestro_trazo_programado"
boolean livescroll = true
end type

type dw_unidades from uo_dtwndow within w_liquidacionesxespacio2
event ue_adicionar_fila ( )
integer x = 37
integer y = 1112
integer width = 3045
integer height = 672
integer taborder = 20
boolean bringtotop = true
string dataobject = "dtb_liq_unidadesxespacio"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_adicionar_fila();Long ll_ordencorte, ll_agrupacion, ll_basetrazo,ll_cs_trazo
Long li_liquidacion, li_trazo, li_selecciones, li_tallas, li_seccion, li_fila_actual
Long li_produccion, li_talla, li_sectalla, li_unidades, li_paquetes, li_capas,li_orden_espacio
String  ls_tipo
Datetime ldt_current
s_base_parametros lstr_parametros
DataStore lds_tallas

IF il_fila_actual_maestro > 0 THEN
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	ll_agrupacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_agrupacion")
	ll_cs_trazo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_trazo")
	ll_basetrazo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_base_trazos")
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
//	lstr_parametros.entero[1] = ll_ordencorte
//	lstr_parametros.entero[2] = ll_agrupacion
//	lstr_parametros.entero[3] = ll_basetrazo
//	lstr_parametros.entero[4] = li_liquidacion
//	OpenWithParm(w_seleccionar_espacio, lstr_parametros)
//	lstr_parametros = Message.PowerObjectParm
//	IF lstr_parametros.hay_parametros THEN
		lds_tallas = Create DataStore
		lds_tallas.DataObject = 'dtb_seleccionar_unidades_espacio'
		lds_tallas.SetTransObject(SQLCA)
		//FOR li_selecciones = 2 TO lstr_parametros.entero[1] + 1
			//li_trazo = lstr_parametros.entero[li_selecciones]
			li_tallas = lds_tallas.Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_cs_trazo, li_liquidacion)
			FOR li_fila_actual = 1 TO li_tallas
				//li_trazo 		= lds_tallas.GetItemNumber(li_fila_actual, "cs_trazo")
				li_seccion 		= lds_tallas.GetItemNumber(li_fila_actual, "cs_seccion")
				li_produccion 	= lds_tallas.GetItemNumber(li_fila_actual, "cs_pdn")
				li_talla 		= lds_tallas.GetItemNumber(li_fila_actual, "co_talla")
				li_sectalla 	= lds_tallas.GetItemNumber(li_fila_actual, "cs_talla")
				li_paquetes 	= lds_tallas.GetItemNumber(li_fila_actual, "paquetes")
				li_unidades 	= lds_tallas.GetItemNumber(li_fila_actual, "pendiente")
				li_capas 		= li_unidades / li_paquetes
				li_orden_espacio = lds_tallas.getItemNumber(li_fila_actual,'cs_orden_espacio')
				
				IF IsNull(li_orden_espacio) OR li_orden_espacio = 0 THEN
					li_orden_espacio = li_produccion
				END IF
				ldt_current=f_fecha_servidor()
				INSERT INTO dt_liq_unixespacio(cs_orden_corte, cs_agrupacion, cs_base_trazos, cs_trazo,cs_liquidacion,
					cs_seccion, cs_pdn, co_talla, cs_talla, ca_prog_liq, capas, paquetes, ca_liquidadas,
					ca_loteadas, fe_creacion, fe_actualizacion, usuario, instancia,cs_orden_espacio)
				VALUES(:ll_ordencorte, :ll_agrupacion, :ll_basetrazo, :ll_cs_trazo,:li_liquidacion, :li_seccion,
					:li_produccion, :li_talla, :li_sectalla, :li_unidades, :li_capas, :li_paquetes, 0, 0, :ldt_current, :ldt_current,
					User, SiteName, :li_orden_espacio);
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al insertar registro de tallas")
					ROLLBACK;
					Return
				END IF
			NEXT
		//NEXT
		Destroy lds_tallas
		COMMIT;
		idw_arreglo_dw[ii_dw_actual].Retrieve(ll_ordencorte, ll_agrupacion, ll_basetrazo, ll_cs_trazo,li_liquidacion)
	//END IF
END IF
end event

event itemchanged;call super::itemchanged;Long li_capas, li_paquetes, li_unidades,i, li_capas_prog, li_talla, li_fab, li_lin,&
		  li_basetrazo, li_trazo, li_raya
Long ll_result, ll_ordencorte, ll_agrupacion, ll_ref, ll_cliente,ll_unir_oc
decimal ldc_porc
String ls_po, ls_password, ls_password_ingresado
n_cts_constantes_corte lpo_const_corte
n_cts_capas_prog_x_liq luo_capas
s_base_parametros lstr_parametros

This.AcceptText()
IF Dwo.Name = 'capas' OR Dwo.Name = 'paquetes' THEN
	//primero se verifica que la variacion entre las capas programadas y liquidadas
	//no sea superior al porcentaje establecido
	li_capas 	= This.GetItemNumber(Row, 'capas')
	li_capas_prog = This.GetItemNumber(Row,'capas_programadas')
	ll_cliente = This.GetItemNumber(Row,'co_cliente')
	ll_unir_oc = This.GetItemNumber(Row,'cs_unir_oc')
	
	
	//si las capas son mayores a las liquidadas no debe permitirse esto
	//esto se hace debido a que Sandra Cristina Giraldo nos informo de esto
	//jcrm
	//agosto 6 de 2007
	
	//solicta MAria Fernanda que en cliente jocket y oc suritdos no se deje liquidar por encima de lo programado
	//jorodrig sep 29-09
	IF ll_cliente = 9991 AND ll_unir_oc > 1 THEN
		If li_capas > li_capas_prog Then
			MessageBox('Error','Las capas no pueden ser mayores a las programadas en cliente 9991 y oc surtidas')
			This.SetItem(Row,'capas',li_capas_prog)
			Return 2
		End if
	END IF
	
	li_paquetes = This.GetItemNumber(Row, 'paquetes')
	li_unidades = li_paquetes * li_capas
	This.SetItem(Row, 'ca_prog_liq', li_unidades)
	This.SetItem(Row, 'ca_liquidadas', li_unidades)
	
//********************************************************************************************
//A peticion de Javier Garcia, se quita la opcion de que los jefes de salon autorizen
//un numero de capas liquidadas diferentes en mas o menos un 5% a las capas programadas.
//jcrm febrero 5 de 2007
//*********************************************************************************************		
//
//	ll_result = (li_capas * 100) / li_capas_prog
//	
//	if ll_result >= 100 Then
//		ll_result = ll_result - 100
//	else
//		ll_result = 100 - ll_result
//	end if
//	//consulto el porcentaje permito en m_constantes_corte
//	ldc_porc = lpo_const_corte.of_consultar_numerico('DIFERENCIA_PROG_LIQ')
//		
//	If ldc_porc = -1 Then
//      MessageBox('Error','No fue posible establecer el porcentaje permitido entre lo programado y lo liquidado.')		
//		Return 
//	End if
//	
//	if ll_result > ldc_porc Then
//		ll_ordencorte = This.GetItemNumber(Row,'dt_liq_unixespacio_cs_orden_corte')
//		ls_po			  = This.GetItemString(Row,'po')
//		li_talla		  = This.GetItemNumber(Row,'co_talla')
//		ll_agrupacion = This.GetItemNumber(Row,'dt_liq_unixespacio_cs_agrupacion')
//		
//		SELECT DISTINCT co_fabrica_pt, co_linea, co_referencia
//		  INTO :li_fab, :li_lin, :ll_ref
//		  FROM dt_agrupa_pdn
//		 WHERE cs_agrupacion = :ll_agrupacion AND
//		       cs_pdn = 1;
//		
//		if luo_capas.of_validarCapas(ll_ordencorte,li_fab,li_lin,ll_ref,li_talla, li_capas_prog,li_capas,ii_espacio) = -1 Then
//			This.SetItem(Row,'capas',li_capas_prog)
//			This.AcceptText()
//			Return 2
//		end if
//	end if

	//************************************ inicio modificaci$$HEX1$$f300$$ENDHEX$$n **************************************
	//modificacion solicitada en el sue$$HEX1$$f100$$ENDHEX$$o de recipiente perfecto, se necesita
	//validar que el numero de capas liquidadas no sea menor a las programadas
	//en un porcentaje mayor del 5%, de ser as$$HEX2$$ed002000$$ENDHEX$$el sistema exigira una clave para continuar
	//inicialmente la clave la tendra Javier Garcia, hasta que se tenga la forma de que sea
	//el encargado de calidad que validara el espacio antes de ser cortado, y no se dejaria 
	//preliquidar antes de tener la aceptaci$$HEX1$$f300$$ENDHEX$$n de calidad.
	//abril 9 de 2007
	//jcrm
	
	//ahora se validad que las capas liquidadas no esten por debajo de las capas programadas
	//en porcentaje mayor al autorizado.
	
	ll_ordencorte = This.GetItemNumber(Row,'dt_liq_unixespacio_cs_orden_corte')
	ll_agrupacion = This.GetItemNumber(Row,'dt_liq_unixespacio_cs_agrupacion')
	li_basetrazo  = This.GetItemNumber(Row,'dt_liq_unixespacio_cs_base_trazos')
	li_trazo		  = This.GetItemNumber(Row,'dt_liq_unixespacio_cs_trazo')
	
	ll_result = luo_capas.of_preliquidacionCapas(ll_ordencorte,ll_agrupacion,li_basetrazo,li_trazo,li_capas)
	
	If ll_result = 2 Then
		//mensage de utilizacion del trazo, no debe ser usado sin autorizaci$$HEX1$$f300$$ENDHEX$$n superior.
		MessageBox('Advertencia','Capas por debajo de lo permitido, se necesita autorizaci$$HEX1$$f300$$ENDHEX$$n para programarlas.')
		IF gstr_info_usuario.co_planta_pro = 2 THEN
			ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO'))
		ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
			ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO NICOLE'))
		END IF
		
		li_raya = luo_capas.of_traer_raya_oc(ll_ordencorte, ll_agrupacion, li_basetrazo, li_trazo)
		IF li_raya  <> 10 AND li_raya <> -1 THEN
			ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD_MODIF_CAPAS_COMPLE'))
		END IF
		
		//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
		Open(w_password_trazos)
		lstr_parametros = message.PowerObjectParm
		ls_password_ingresado = ''
		If lstr_parametros.hay_parametros = true Then
			ls_password_ingresado = Trim(lstr_parametros.cadena[1])
						
			If ls_password_ingresado = ls_password Then
			Else
				This.SetItem(Row,'capas',li_capas_prog)
				MessageBox('Error','Password, no valido.')
				Return 2
			End if
		Else
			This.SetItem(Row,'capas',li_capas_prog)
			MessageBox('Error','Password, no valido.')
			Return 2
		End if
	End if
	
	If ll_result = -1 Then
		Return 2
	End if
	//********************************* fin modificaci$$HEX1$$f300$$ENDHEX$$n *********************************************
	

//	if dwo.name='capas' and ii_paquetes <> 1 then
//		for i=1 to dw_unidades.rowcount()
//			li_capas 	= This.GetItemNumber(i, 'capas')
//			//This.SetItem(i, 'capas', li_capas)
//			li_paquetes = This.GetItemNumber(i, 'paquetes')
//			li_unidades = li_paquetes * li_capas
//			This.SetItem(i, 'ca_prog_liq', li_unidades)			
//		next
//		This.AcceptText()
//	else
//	end if
END IF
end event

type cb_1 from commandbutton within w_liquidacionesxespacio2
boolean visible = false
integer x = 2395
integer y = 972
integer width = 512
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Liquidar Rollos Nicole"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.entero[1] = dw_encabezado.GetItemNumber(1,'cs_orden_corte')

IF gstr_info_usuario.co_planta_pro = 99 THEN
	OpenWithParm ( w_rollo_liquida, lstr_parametros  )
END IF
end event

