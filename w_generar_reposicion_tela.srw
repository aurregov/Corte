HA$PBExportHeader$w_generar_reposicion_tela.srw
forward
global type w_generar_reposicion_tela from w_base_maestroff_detalletb
end type
type em_ordencorte from editmask within w_generar_reposicion_tela
end type
type st_1 from statictext within w_generar_reposicion_tela
end type
end forward

global type w_generar_reposicion_tela from w_base_maestroff_detalletb
integer width = 3287
integer height = 1544
string title = "Reposicion Tela"
em_ordencorte em_ordencorte
st_1 st_1
end type
global w_generar_reposicion_tela w_generar_reposicion_tela

type variables
Long ii_rectilineo1, ii_rectilineo2, ii_estado
end variables

on w_generar_reposicion_tela.create
int iCurrent
call super::create
this.em_ordencorte=create em_ordencorte
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ordencorte
this.Control[iCurrent+2]=this.st_1
end on

on w_generar_reposicion_tela.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ordencorte)
destroy(this.st_1)
end on

event ue_borrar_maestro;Long li_estado_mercada, li_pormercar, li_porcortar, li_estado_reposicion
Long li_poratender, li_anulada, li_mercada_anulada, li_rollos
Long ll_reposicion, ll_mercada, ll_unidades, ll_rollo, ll_ordencorte
String ls_error
Decimal{2} ld_metros
n_cts_constantes luo_constantes
u_ds_base lds_rollosmercada


ll_ordencorte = Long(em_ordencorte.Text)



luo_constantes = Create n_cts_constantes
li_poratender = luo_constantes.of_consultar_numerico("REPOSICION POR ATEND")

IF li_poratender = -1 THEN
   Return
END IF

li_anulada = luo_constantes.of_consultar_numerico("REPOSICION RECHAZADA")

IF li_anulada = -1 THEN
   Return
END IF

li_mercada_anulada = luo_constantes.of_consultar_numerico("MERCADA ANULADA")

IF li_mercada_anulada = -1 THEN
   Return
END IF

ll_reposicion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_reposicion")
li_estado_reposicion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estadoreposicio")

IF li_estado_reposicion <> li_poratender THEN
   li_pormercar = luo_constantes.of_consultar_numerico("ESTADO X MERCAR")
   IF li_pormercar = -1 THEN
       Return
   END IF
	
   li_porcortar = luo_constantes.of_consultar_numerico("ESTADO X CORTAR")
   IF li_porcortar = -1 THEN
      Return
   END IF
	
   SELECT co_estado_mercada, cs_mercada
   INTO :li_estado_mercada, :ll_mercada
   FROM h_mercada
   WHERE cs_reposicion = :ll_reposicion;
	
   IF SQLCA.SQLCode = -1 THEN
      MessageBox("Error Base Datos","Error al consultar el estado de la reposici$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
      Return
   END IF
	
   IF li_estado_mercada <> li_porcortar AND li_estado_mercada <> li_pormercar THEN
      MessageBox("Advertencia","No se puede anular la reposici$$HEX1$$f300$$ENDHEX$$n, la mercada ya fue atendida")
      Return
   END IF
END IF

dw_maestro.SetItem(il_fila_actual_maestro, "co_estadoreposicio", li_anulada)

IF dw_maestro.AcceptText() = 1 THEN
   IF dw_maestro.Update() = 1 THEN
		IF Not IsNull(ll_mercada) THEN
			UPDATE dt_rollosmercada
			SET	co_estado_mercada = :li_mercada_anulada,
					fe_actualizacion = Current,
					usuario = User,
					instancia = SiteName
			WHERE cs_mercada = :ll_mercada;
			
			IF SQLCA.SQLCode = -1 THEN
				ls_error = SQLCA.SQLErrText
				ROLLBACK;				
				MessageBox("Error Base Datos","Error al anular la mercada " + ls_error)
				Return
			END IF
			
			UPDATE h_mercada
			SET	co_estado_mercada = :li_mercada_anulada,
					fe_actualizacion = Current,
					usuario = User,
					instancia = SiteName
			WHERE cs_mercada = :ll_mercada;
			
			IF SQLCA.SQLCode = -1 THEN
				ls_error = SQLCA.SQLErrText
				ROLLBACK;				
				MessageBox("Error Base Datos","Error al anular la mercada " + ls_error)
				Return
			END IF
			
			lds_rollosmercada = Create u_ds_base
			
			lds_rollosmercada.DataObject = 'dtb_consulta_rollos_mercada'
			
			IF lds_rollosmercada.SetTransObject(SQLCA) = -1 THEN
				MessageBox("Error DataStore","Error al asignar el objeto transacci$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
				Return
			END IF
			
			lds_rollosmercada.Retrieve(ll_mercada, 0, 0, li_mercada_anulada)
			
			FOR li_rollos = 1 TO lds_rollosmercada.RowCount()
				ld_metros = lds_rollosmercada.GetItemNumber(li_rollos, "ca_metros_mercar")
				ll_rollo = lds_rollosmercada.GetItemNumber(li_rollos, "cs_rollo")
				IF IsNull(ld_metros) THEN
					ld_metros = 0
				END IF
				ll_unidades = lds_rollosmercada.GetItemNumber(li_rollos, "ca_unidades_mercar")
				IF IsNull(ll_unidades) THEN
					ll_unidades = 0
				END IF
				UPDATE dt_consumo_rollos
				SET	ca_metros = ca_metros - :ld_metros,
						ca_unidades = ca_unidades - :ll_unidades,
						fe_actualizacion = Current,
						usuario = User,
						instancia = SiteName
				WHERE cs_rollo = :ll_rollo;
				IF SQLCA.SQLCode = -1 THEN
					ls_error = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox("Error Base Datos","Error al descontar el consumo de rollos " + ls_error)
					Return
				END IF
			NEXT
			
		END IF
      COMMIT;
      dw_maestro.Retrieve(ll_ordencorte)
   ELSE
      ROLLBACK;
      MessageBox("Advertencia","No se pudo actualizar la informaci$$HEX1$$f300$$ENDHEX$$n en la base de datos")
   END IF
ELSE
   MessageBox("Advertencia","No se pudo actualizar la informaci$$HEX1$$f300$$ENDHEX$$n en la datawindow")
END IF

end event

event ue_buscar;// Se omite el script
end event

event ue_insertar_maestro;Long ll_ordencorte, ll_reposicion, ll_fila
Long li_raya, li_estado, li_fabrica, li_documento
s_base_parametros lstr_parametros
n_cts_constantes luo_constantes
n_cst_generar_consecutivo luo_consecutivos


CHOOSE CASE wf_detectar_cambios (dw_detalle)
	CASE -1
		RETURN
	CASE 0
	CASE 1
		CHOOSE CASE MessageBox("Cambios detectados en el detalle...",&
 	               "Desea grabar los cambios del maestro y el detalle",&
               	 Question!,YesNoCancel!)
			CASE 1
				This.TriggerEvent("ue_grabar")
			CASE 2
			CASE 3
				RETURN
		END CHOOSE
END CHOOSE

ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
END IF

Open(w_consultar_rayas_ordencorte)
lstr_parametros = Message.PowerObjectParm
IF lstr_parametros.hay_parametros THEN
	luo_constantes = Create n_cts_constantes
	
	li_estado = luo_constantes.of_consultar_numerico("ESTADO REPOSICION")
	
	IF li_estado = -1 THEN
		Close(This)
		Return
	END IF
	
	li_fabrica = luo_constantes.of_consultar_numerico("FABRICA TELA")
	IF li_fabrica = -1 THEN
		Return
	END IF
	li_documento = luo_constantes.of_consultar_numerico("DOCUMENTO REPOSICION")
	IF li_documento = -1 THEN
		Return
	END IF
	luo_consecutivos = Create n_cst_generar_consecutivo
	
	ll_reposicion = luo_consecutivos.of_calcula_consecutivo(li_fabrica, li_documento)
	
	IF ll_reposicion = - 1 THEN
		Return
	END IF
	dw_maestro.SetItem(il_fila_actual_maestro, "cs_reposicion", ll_reposicion)	
	dw_maestro.SetItem(il_fila_actual_maestro, "cs_orden_corte", lstr_parametros.entero[1])
	dw_maestro.SetItem(il_fila_actual_maestro, "raya", lstr_parametros.entero[4])
	dw_maestro.SetItem(il_fila_actual_maestro, "co_estadoreposicio", li_estado)	
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", f_fecha_servidor())
	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)			
	IF dw_maestro.AcceptText() = -1 THEN
		MessageBox("Error","Error al actualizar los datos")
		dw_maestro.DeleteRow(il_fila_actual_maestro)
		il_fila_actual_maestro = il_fila_actual_maestro - 1		
	ELSE
		IF dw_maestro.Update() = -1 THEN
			ROLLBACK;
		ELSE
			COMMIT;
		END IF
	END IF
ELSE
	dw_maestro.DeleteRow(il_fila_actual_maestro)
	il_fila_actual_maestro = il_fila_actual_maestro - 1
END IF
	
end event

event open;call super::open;//Long li_filas, li_fila_actual, li_fila, li_estado
//Long li_rectilineo1, li_rectilineo2, li_tipotela
//s_base_parametros lstr_parametros
//DataStore lds_tela_liquidacion
n_cts_constantes luo_constantes

This.width = 3136
This.height = 1500

luo_constantes = Create n_cts_constantes

ii_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")

IF ii_rectilineo1 = -1 THEN
	Close(This)
	Return
END IF

ii_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 2")

IF ii_rectilineo1 = -1 THEN
	Close(This)
	Return
END IF	

ii_estado = luo_constantes.of_consultar_numerico("ESTADO REPOSICION")

IF ii_estado = -1 THEN
	Close(This)
	Return
END IF
//lstr_parametros = Message.PowerObjectParm
//
//IF lstr_parametros.hay_parametros THEN
//	luo_constantes = Create n_cts_constantes
//	
//	li_estado = luo_constantes.of_consultar_numerico("ESTADO REPOSICION")
//	
//	IF li_estado = -1 THEN
//		Close(This)
//		Return
//	END IF
//
//	li_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")
//	
//	IF li_rectilineo1 = -1 THEN
//		Close(This)
//		Return
//	END IF
//	
//	li_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 2")
//	
//	IF li_rectilineo1 = -1 THEN
//		Close(This)
//		Return
//	END IF
//	
//	lds_tela_liquidacion = Create DataStore
//	lds_tela_liquidacion.DataObject = 'dtb_tela_liquidacion_imperfectos'
//	IF lds_tela_liquidacion.SetTransObject(SQLCA) = 1 THEN
//		li_fila = dw_maestro.InsertRow(0)
//		IF li_fila = -1 THEN
//			MessageBox("Error","Error al crear el registro de reposici$$HEX1$$f300$$ENDHEX$$n")
//			Close(This)
//			Return
//		END IF
//		dw_maestro.SetItem(li_fila, "cs_orden_corte", lstr_parametros.entero[1])
//		dw_maestro.SetItem(li_fila, "cs_agrupacion", lstr_parametros.entero[2])
//		dw_maestro.SetItem(li_fila, "cs_base_trazos", lstr_parametros.entero[3])
//		dw_maestro.SetItem(li_fila, "cs_trazo", lstr_parametros.entero[4])		
//		dw_maestro.SetItem(li_fila, "co_estadoreposicio", li_estado)
//		dw_maestro.SetItem(li_fila, "fe_creacion", f_fecha_servidor())
//		dw_maestro.SetItem(li_fila, "fe_actualizacion", f_fecha_servidor())
//		dw_maestro.SetItem(li_fila, "usuario", gstr_info_usuario.codigo_usuario)
//		dw_maestro.SetItem(li_fila, "instancia", gstr_info_usuario.instancia)		
//		li_filas = lds_tela_liquidacion.Retrieve(lstr_parametros.entero[1], &
//			lstr_parametros.entero[2], lstr_parametros.entero[3], &
//			lstr_parametros.entero[4], lstr_parametros.entero[5])
//		FOR li_fila_actual = 1 TO li_filas
//			li_fila = dw_detalle.InsertRow(0)
//			IF li_fila = -1 THEN
//				MessageBox("Error","Error al insertar registro de tela")
//				Close(This)
//				Return
//			END IF
//			dw_detalle.SetItem(li_fila, "co_reftel", lds_tela_liquidacion.GetItemNumber(li_fila_actual, "co_reftel_act"))
//			dw_detalle.SetItem(li_fila, "co_caract", lds_tela_liquidacion.GetItemNumber(li_fila_actual, "co_caract_act"))
//			dw_detalle.SetItem(li_fila, "co_color", lds_tela_liquidacion.GetItemNumber(li_fila_actual, "co_color_act"))
//			li_tipotela = lds_tela_liquidacion.GetItemNumber(li_fila_actual, "co_tiptel")
//			IF li_tipotela = li_rectilineo1 OR li_tipotela = li_rectilineo2 THEN
//				dw_detalle.SetItem(li_fila, "ca_unidades_reposi", lds_tela_liquidacion.GetItemNumber(li_fila_actual, "metros"))
//				dw_detalle.SetItem(li_fila, "ca_metros_reposi", 0)
//			ELSE
//				dw_detalle.SetItem(li_fila, "ca_metros_reposi", lds_tela_liquidacion.GetItemNumber(li_fila_actual, "metros"))
//				dw_detalle.SetItem(li_fila, "ca_unidades_reposi", 0)				
//			END IF
//			dw_detalle.SetItem(li_fila, "de_reftel", lds_tela_liquidacion.GetItemString(li_fila_actual, "de_reftel"))
//			dw_detalle.SetItem(li_fila, "de_color", lds_tela_liquidacion.GetItemString(li_fila_actual, "de_color"))			
//			dw_detalle.SetItem(li_fila, "fe_creacion", f_fecha_servidor())
//			dw_detalle.SetItem(li_fila, "fe_actualizacion", f_fecha_servidor())
//			dw_detalle.SetItem(li_fila, "usuario", gstr_info_usuario.codigo_usuario)
//			dw_detalle.SetItem(li_fila, "instancia", gstr_info_usuario.instancia)					
//		NEXT
//	ELSE
//		MessageBox("Error","Error al definir la conexi$$HEX1$$f300$$ENDHEX$$n con la base de datos")
//		Close(This)
//		Return
//	END IF
//ELSE
//	Close(This)
//	Return
//END IF
end event

event ue_grabar;IF dw_detalle.AcceptText() = 1 THEN
	IF dw_detalle.Update() = 1 THEN
		COMMIT;
	ELSE
		MessageBox("Error","Error al actualizar la tela de la reposicion")
		ROLLBACK;
	END IF
ELSE
	MessageBox("Error","Error al actualizar la tela de la reposicion en la datawindow")
	ROLLBACK;				
END IF
end event

event ue_insertar_detalle;Long li_fabricatela, li_caract, li_diametro, li_telas, li_raya, li_comprada, li_raya_ficha
Long li_fila, li_talla, li_tiptel, li_caract_ficha, li_diametro_ficha
Long ll_reftel, ll_ordencorte, ll_reposicion, ll_tanda, ll_reftel_ficha, ll_color, ll_color_ficha
String ls_tela, ls_color, ls_color_ficha, ls_tela_ficha
DataStore lds_tela
n_cts_constantes luo_constantes

IF il_fila_actual_maestro > 0 THEN
	lds_tela = Create DataStore
	
	lds_tela.DataObject = 'dtb_telas_ordencorte_raya_ficha'
	
	IF lds_tela.SetTransObject(SQLCA) = -1 THEN
		MessageBox("Error","Error al asignar el objeto transacci$$HEX1$$f300$$ENDHEX$$n")
		Return
	END IF
	
	ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
	li_raya = dw_maestro.GetItemNumber(il_fila_actual_maestro, "raya")
	ll_reposicion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_reposicion")
	
	lds_tela.Retrieve(ll_ordencorte, li_raya)
	
	FOR li_telas = 1 TO lds_tela.RowCount()
		li_fila = dw_detalle.InsertRow(0)
		IF li_fila <> -1 THEN
			//----------------------capturo los datos contenidos en el datastore
			//----------------------primero los de la orden de corte
			li_fabricatela = lds_tela.GetItemNumber(li_telas, "co_fabrica_tela")
			ll_reftel 		= lds_tela.GetItemNumber(li_telas, "co_reftel")
			li_caract 		= lds_tela.GetItemNumber(li_telas, "co_caract")
			li_diametro 	= lds_tela.GetItemNumber(li_telas, "diametro")
			ll_color 		= lds_tela.GetItemNumber(li_telas, "co_color_te")
			li_talla 		= lds_tela.GetItemNumber(li_telas, "co_talla")
			ll_tanda 		= lds_tela.GetItemNumber(li_telas, "cs_tanda")
			li_tiptel 		= lds_tela.GetItemNumber(li_telas, "co_tiptel")
			ls_tela 			= lds_tela.GetItemString(li_telas, "de_reftel")
			ls_color 		= lds_tela.GetItemString(li_telas, "de_color")
			ls_color_ficha = lds_tela.GetItemString(li_telas, "de_color_ficha")
			ls_tela_ficha	= lds_tela.GetItemString(li_telas, "de_reftel_ficha")
			
			//-------------------------luego los de la ficha
			ll_reftel_ficha 	= lds_tela.GetItemNumber(li_telas, "dt_color_modelo_co_reftel")
			li_caract_ficha 	= lds_tela.GetItemNumber(li_telas, "dt_color_modelo_co_caract")
			li_diametro_ficha = lds_tela.GetItemNumber(li_telas, "dt_color_modelo_diametro")
			ll_color_ficha 	= lds_tela.GetItemNumber(li_telas, "dt_color_modelo_co_color_te")
			
			//------------------se comparan los valores de la ficha y la O.C.
			IF ll_reftel <> ll_reftel_ficha OR li_caract <> li_caract_ficha OR &
			   li_diametro <> li_diametro_ficha OR ll_color <> ll_color_ficha THEN
				//existen diferencias debo averiguar si el color de la ficha esta en otra raya
				//si es as$$HEX2$$ed002000$$ENDHEX$$se debe averiguar si la tela es comprada
				//si color existe en otra raya y tela no comprada se coloca la tanda de la raya que se encontro con el
				//color
				
				//-----------------------determino si la tela es comprada o no
				SELECT sw_comprada
				  INTO :li_comprada
				  FROM h_telas
				 WHERE co_reftel = :ll_reftel_ficha AND
				 		 co_caract = :li_caract_ficha;
						  
				IF sqlca.sqlcode <> 0 THEN
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la tela. '+ Sqlca.SqlErrText)
					Return
				END IF
				 
				   //----trabajaremos con los datos de la ficha lo unico que falta establecer en este caso es la tanda
				   dw_detalle.SetItem(li_fila, "co_reftel", ll_reftel_ficha)
					dw_detalle.SetItem(li_fila, "de_reftel", ls_tela_ficha)
					dw_detalle.SetItem(li_fila, "co_caract", li_caract_ficha)
					dw_detalle.SetItem(li_fila, "diametro", li_diametro_ficha)
					dw_detalle.SetItem(li_fila, "co_color", ll_color_ficha)
					dw_detalle.SetItem(li_fila, "de_color", ls_color_ficha)
				
				IF li_comprada = 1 THEN
					//-----------------------la tela es comprada se debe colocar la tanda en cero
					dw_detalle.SetItem(li_fila, "cs_tanda", 0)
				ELSE
					//---------------la tela no es comprada se debe averiguar, si existe otra raya con el mismo color.
					SELECT max(b.raya)
					  INTO :li_raya_ficha
					  FROM dt_telaxmodelo_lib b,
							 dt_pdnxmodulo c
					 WHERE b.raya 				<> :li_raya AND
							 c.cs_asignacion 	= :ll_ordencorte AND
							 c.co_fabrica_exp = b.co_fabrica_exp AND
							 c.cs_liberacion 	= b.cs_liberacion AND
							 c.po 				= b.nu_orden AND
							 c.nu_cut 			= b.nu_cut AND
							 b.co_color_tela 	= :ll_color_ficha;
							 
				   IF sqlca.sqlcode = -1 THEN
						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un erro al momento de validar el color de la raya. '+Sqlca.SqlErrText)
						Return
					END IF
					
					IF isnull(li_raya_ficha) OR li_raya_ficha = 0 THEN
						//------------------no se encontro otra raya debemos continuar con la ficha y tanda cero
						dw_detalle.SetItem(li_fila, "cs_tanda", 0)
					ELSE
						//----------------se encontro otra raya debemos establecer la tanda para esa raya y colocar esta tanda
						SELECT MAX(m_rollo.cs_tanda)
						 INTO :ll_tanda
						 FROM dt_rayas_telaxoc,   
								h_base_trazos,   
								dt_rollosmercada,   
								m_rollo,   
								h_mercada
						WHERE ( dt_rayas_telaxoc.cs_agrupacion 	= h_base_trazos.cs_agrupacion ) and  
								( dt_rayas_telaxoc.cs_base_trazos 	= h_base_trazos.cs_base_trazos ) and  
								( dt_rayas_telaxoc.cs_orden_corte 	= h_mercada.cs_orden_corte ) and  
								( h_mercada.cs_mercada 					= dt_rollosmercada.cs_mercada ) and  
								( h_base_trazos.raya 					= dt_rollosmercada.raya ) and  
								( dt_rollosmercada.cs_rollo 			= m_rollo.cs_rollo ) and  
								( dt_rayas_telaxoc.co_fabrica_tela 	= m_rollo.co_fabrica_act ) and  
								( dt_rayas_telaxoc.co_reftel 			= m_rollo.co_reftel_act ) and  
								( dt_rayas_telaxoc.co_caract 			= m_rollo.co_caract_act ) and  
								( dt_rayas_telaxoc.co_color_te 		= m_rollo.co_color_act ) and 
								( dt_rayas_telaxoc.cs_orden_corte 	= :ll_ordencorte ) AND  
								( h_base_trazos.raya 					= :li_raya_ficha )   ; 
						
						IF sqlca.sqlcode <> 0 THEN
							MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer la tanda. '+ Sqlca.SqlErrText)
							Return 
						END IF
											
						dw_detalle.SetItem(li_fila, "cs_tanda", ll_tanda)
				   END IF
				END IF
		   ELSE
				//----------------es por que la ficha no ha cambiado y debemos cargar los registros de la O.C.
				dw_detalle.SetItem(li_fila, "co_reftel", ll_reftel)
				dw_detalle.SetItem(li_fila, "de_reftel", ls_tela)
				dw_detalle.SetItem(li_fila, "co_caract", li_caract)
				dw_detalle.SetItem(li_fila, "diametro", li_diametro)
				dw_detalle.SetItem(li_fila, "co_color", ll_color)
				dw_detalle.SetItem(li_fila, "de_color", ls_color)
				dw_detalle.SetItem(li_fila, "cs_tanda", ll_tanda)
			END IF
					
			dw_detalle.SetItem(li_fila, "cs_reposicion", ll_reposicion)
			dw_detalle.SetItem(li_fila, "co_fabrica", li_fabricatela)
			dw_detalle.SetItem(li_fila, "co_talla", li_talla)
			dw_detalle.SetItem(li_fila, "fe_creacion", f_fecha_servidor())
			dw_detalle.SetItem(li_fila, "fe_actualizacion", f_fecha_servidor())
			dw_detalle.SetItem(li_fila, "usuario", gstr_info_usuario.codigo_usuario)
			dw_detalle.SetItem(li_fila, "instancia", gstr_info_usuario.instancia)						
			IF li_tiptel = ii_rectilineo1 OR li_tiptel = ii_rectilineo2 THEN
				dw_detalle.Modify("ca_metros_reposi.protect='1'")
			ELSE
				dw_detalle.Modify("ca_unidades_reposi.protect='1'")				
			END IF			
		ELSE
			MessageBox("Error","Error al insertar fila")
			dw_detalle.Reset()
		END IF
	NEXT
END IF
end event

event ue_borrar_detalle;long ll_fila

ll_fila = dw_detalle.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
			ELSE
				il_fila_actual_detalle = ll_fila - 1
			END IF
		ELSE
		END IF
END CHOOSE



end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_generar_reposicion_tela
integer x = 37
integer y = 128
integer width = 2715
integer height = 424
integer taborder = 20
boolean titlebar = false
string dataobject = "dff_reposicion_tela"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long ll_reposicion, li_estado

This.SelectRow(0,FALSE)
This.SelectRow(CurrentRow,TRUE)
il_fila_actual_maestro = CurrentRow

IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SelectRow(0, False)
	dw_maestro.SelectRow(il_fila_actual_maestro, True)
	ll_reposicion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_reposicion")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estadoreposicio")
	dw_detalle.Retrieve(ll_reposicion, ii_rectilineo1, ii_rectilineo2)
// Cuando la reposici$$HEX1$$f300$$ENDHEX$$n no esta en esta programada no se puede permitir
// modificar
	IF li_estado = ii_estado THEN
		dw_detalle.Modify("Enabled=True")
	ELSE
		dw_detalle.Modify("Enabled=False")
	END IF
END IF
end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_generar_reposicion_tela
integer x = 37
integer y = 564
integer width = 3182
integer height = 784
integer taborder = 30
boolean titlebar = false
string dataobject = "dtb_telas_reposicion"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type em_ordencorte from editmask within w_generar_reposicion_tela
integer x = 338
integer y = 24
integer width = 343
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#######"
end type

event modified;n_cts_ocfabrica luo_oc
Long ll_ordencorte
Long	li_total

ll_ordencorte = Long(em_ordencorte.Text)

IF luo_oc.of_validarocfabrica(ll_ordencorte) = -1 THEN
	Return
END IF

//No se puede hacer reposicion a ordenes de corte del color crudo APT 601, 
//definen en reuion el viernes 1 de abril del 2001 jorodrig 
SELECT COUNT(*)
  INTO :li_total
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :ll_ordencorte
   AND co_color_pt   = 601; 
IF li_total > 0 THEN
	MessageBox('Error','No puede hacer reposicion al color crudo APT')
	Return -1
END IF


dw_maestro.Retrieve(ll_ordencorte)
end event

type st_1 from statictext within w_generar_reposicion_tela
integer x = 32
integer y = 36
integer width = 306
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
boolean focusrectangle = false
end type

