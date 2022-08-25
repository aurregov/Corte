HA$PBExportHeader$n_cts_cargar_temporales_liberacion.sru
forward
global type n_cts_cargar_temporales_liberacion from nonvisualobject
end type
end forward

global type n_cts_cargar_temporales_liberacion from nonvisualobject autoinstantiate
end type

type variables
STRING	is_donde_tela

						
					
			
				
				
				
						
					
							
							 
							
							
									
						
						
end variables

forward prototypes
public function long of_validarficha ()
public function long of_cargar_modelos_unid ()
public function long of_unidadesliberar ()
public function long of_rectilineo (long al_reftel, long ai_caract)
public subroutine of_unidadesrealesliberar ()
public function long of_borrartemporales (string as_usuario)
public function long of_buscar_cons_error (string as_usuario)
protected function long of_calcular_kilos ()
public function long of_menorunds ()
public function long of_rectilineos (long ai_fabr, long al_lib, long ai_col, long al_model, long al_undstotal, long al_undslibera)
public function long of_unidades_devueltas (long ai_fabr, long al_lib, long ai_col, long al_model, long al_unds)
protected function long of_actualizar_dtliberaestilos (long ai_fabexp, long al_liber)
public function long of_actualizar_dtpdnxmodulo (long ai_fabexp, long al_liber)
protected function long of_actualizarportalla (long ai_fabexp, long al_liber, long al_modelo)
public function long of_validartandamodelo ()
public function long of_verificacionlinea (long ai_fab, long ai_lin, long al_ref)
public function long of_cambiartandarollo (long al_rollo, string as_tono, ref string as_mensaje)
public function long of_cargartemprollos (long ai_fab, long ai_lin, long al_ref, long al_op, string as_po, long al_color)
protected function long of_cargar_log_problemas (string as_descripcion, long al_orden_prod, string as_po, long al_referencia, long al_color, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, long ai_cod_verif)
public function decimal of_recalcular_porcutil (long ai_pdn, long ai_raya, long al_agrupacion, long al_color, long al_liberacion, long ai_fabexp, long al_modelo)
public function long of_comparar_undsmts (long ai_fabexp, long al_lib, long al_modelo, long al_color)
public function long of_buscar_tipo_tela_tono_col (long al_color_te, long al_ordenpdn, long al_reftel)
public function long of_buscar_tela_faltante (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long ai_caract, long al_color_te, long ai_diametro, string as_usuario)
public function long of_buscar_si_complemento_tintoreria (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario)
public function long of_buscar_si_complemento_estampar (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario)
public function long of_buscar_si_complemento_compras (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario)
public function long of_buscar_si_complemento_crudo (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario)
public function long of_buscar_si_complemento_tejer (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario)
public function long of_act_rollos_en_tintoreria (long al_op, long al_reftel, long al_color_te)
public function long of_cargartemreferencias (long al_color, long ai_talla)
public function long of_referenciacritica (long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color)
public function long of_validar_modelos_completos (long li_fabrica, long li_linea, long ll_referencia, long ll_color, long ll_ordenpd_pt, string ls_usuario)
public function long of_no_rectilineos (long ai_fabri, long al_liber, long al_color, long al_mode, decimal ad_mtstotal, decimal ad_mtslibera, long al_unds_trazo)
public function long of_metros_devueltos (long ai_fabr, long al_lib, long al_color, long al_model, decimal ad_mts, long al_totunds_trazo)
public function long of_recalcularunidadesmin (long al_ordenpd_pt, long al_color, string as_po, decimal adc_ancho, long al_tanda, long al_reftel, long ai_tipo_lib, string as_color_exp, long al_op_agrupada)
end prototypes

public function long of_validarficha ();//esta funcion permite establecer que referencias son viables de liberar
//debido a que se encuentran todas las telas disponibles.

String ls_usuario,ls_po, ls_descripcion, ls_id_ficha, ls_disenno_ficha
Long ll_result, ll_fila, ll_ordenpd_old, ll_ref_old, ll_ordenpd, ll_ref, ll_fila2,&
     ll_modelo, ll_reftel, ll_count, ll_color, ll_color_te, ll_color_old
Long li_fab, li_lin, li_talla, li_marca, li_caract, li_diametro, &
		  li_contador, li_tipo_tela, li_especial, li_ficha_prototipo, li_raya, &
		  li_raya10_en15, li_talla_old
Boolean sw_seguir
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Validando Telas en la Ficha (3/6)..."
lstr_parametros_retro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                                 

DataStore lds_temp_ref, lds_ficha

lds_temp_ref = Create DataStore
lds_ficha    = Create DataStore

lds_temp_ref.DataObject = 'ds_temp_referencias'
lds_ficha.DataObject    = 'ds_ficha'

lds_temp_ref.SetTransObject(sqlca)
lds_ficha.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

//se hace un ciclo de la temporal temp_refere_n
ll_result = lds_temp_ref.Retrieve(ls_usuario)

IF ll_result <= 0 THEN
	MessageBox('Error','No existe ninguna referencia para validar la ficha')
	Return -1
END IF
sw_seguir 		= false
ll_ordenpd_old = 0
ll_ref_old 		= 0
ll_color_old   = 0
li_talla_old   = -1

FOR ll_fila = 1 To ll_result
	ll_ordenpd 	= lds_temp_ref.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ll_ref 		= lds_temp_ref.GetItemNumber(ll_fila,'co_referencia')
	li_marca 	= lds_temp_ref.GetItemNumber(ll_fila,'sw_marca')
	li_fab 		= lds_temp_ref.GetItemNumber(ll_fila,'co_fabrica')
	li_lin 		= lds_temp_ref.GetItemNumber(ll_fila,'co_linea')
	ll_color 	= lds_temp_ref.GetItemNumber(ll_fila,'co_color')
	li_talla 	= lds_temp_ref.GetItemNumber(ll_fila,'co_talla')
	ls_po			= lds_temp_ref.GetItemString(ll_fila,'po')
	

	//verificamos que no recorramos innecesariamente varias veces la misma referencia
	If ll_ref_old = ll_ref Then
		//no deriamos seguir  con esta referencias a menos que sea un bodysize o sea diferente orden de produccion
		IF (li_especial = 1) OR (li_especial = 2) Then
		   //se trata de un bodysize o rectilineo por lo tanto debemos continuar con la referencia	
			sw_seguir = True
		Else
			//no es bodysize y es la misma referencia, debe ser diferente orden de produccion
			If ll_ordenpd_old = ll_ordenpd Then
				//es la misma referencia no es bodysize y es la misma orden de producci$$HEX1$$f300$$ENDHEX$$n
				//debnemos saber si es el mismo color
				If ll_color_old = ll_color Then
				ElseIF li_talla = li_talla_old then
					 sw_seguir = False
 	   	   ELSE
					sw_seguir = True
				End if
			Else
				sw_seguir = True
			End if
		End if
	Else
		//se trabaja normalmente	
		sw_seguir = True
	End if
	
	li_raya10_en15 = 0
	If sw_seguir Then
		//verificamos los datos con respecto a la ficha
		lds_ficha.Retrieve(li_fab,li_lin,ll_ref,li_talla,ll_color)
		FOR ll_fila2 = 1 To lds_ficha.RowCount()
			//se cargan los datos de la ficha
			ll_modelo 	= lds_ficha.GetItemNumber(ll_fila2,'co_modelo')
			ll_reftel 	= lds_ficha.GetItemNumber(ll_fila2,'co_reftel')
			li_caract 	= lds_ficha.GetItemNumber(ll_fila2,'co_caract')
			li_diametro = lds_ficha.GetItemNumber(ll_fila2,'diametro')
			ll_color_te = lds_ficha.GetItemNumber(ll_fila2,'co_color_te')
			li_raya 		= lds_ficha.GetItemNumber(ll_fila2,'raya')
			ls_id_ficha	= lds_ficha.GetItemString(ll_fila2,'id_ficha')
			ls_disenno_ficha	= TRIM(lds_ficha.GetItemString(ll_fila2,'co_disenno'))
			
			//por probar para caso de dise$$HEX1$$f100$$ENDHEX$$os que pasan de caract 7 a 8 y queda mal el dato mal creados en el dise$$HEX1$$f100$$ENDHEX$$o   marzo 18 - 2014 jorodrig
//			IF ls_disenno_ficha = '' THEN
//				ls_disenno_ficha = '0'
//			END IF
			
			
			//buscar si es bodysize en la o.p. para saber si controlo en la ficha por diametro o no
			
			li_contador = luo_liberacion_x_proyeccion.of_revisar_si_bodysize(li_fab,li_lin,ll_ref,ll_color)
			IF li_contador > 0 THEN
				li_especial = 1  //es un bodysize
			ELSE
				li_especial = 0   //no es bodysize, se verifica si es rectilineo
			END IF
			
			IF ls_id_ficha <> '1' THEN
				Rollback;
				MessageBox('Error Datos Ficha','La Ficha de la talla: '+string(li_talla) + ' Color: '+string(ll_color) + ' No es Activa en todas las telas, Informe a la persona encargada de Ficha de Prenda')
				return -1
			END IF
			
			//tambien se debe buscar si son rectilineos para verificar la tela por talla		
			li_tipo_tela = of_rectilineo(ll_reftel,li_caract)
			//son rectilineos, devuelve 3 entonces debemos verificar si existe la tela con la talla
			IF li_tipo_tela = 3 THEN  
				li_especial = 2  //es un rectilineo
			END IF
			
			IF li_especial = 1 THEN
				//ahora se debe verificar si existen todos las referencias para la liberacion
				//Solo se debe verificar la talla cuando son rectilineos  OJO... 
				SELECT count(*)
				  INTO :ll_count
				  FROM temp_tela_n
				 WHERE cs_ordenpd_pt = :ll_ordenpd AND
						 co_reftel 		= :ll_reftel AND
						 co_caract 		= :li_caract AND
						 co_color 		= :ll_color_te AND
						 diametro 		= :li_diametro AND
						 usuario			= :ls_usuario AND
						 ((co_disenno	= :ls_disenno_ficha and :ls_disenno_ficha <> '0') or
						  (:ls_disenno_ficha = :ls_disenno_ficha and :ls_disenno_ficha = '0'));
				IF SQLCA.SQLCODE = -1 THEN
					rollback;
					MessageBox('Error Base de Datos','Se present$$HEX2$$f3002000$$ENDHEX$$un error validando la tela por modelo, intente de nuevo')
					return -1
				END IF
		  
			ELSE
				IF li_especial = 2 THEN
					//ahora se debe verificar si existen todos las referencias para la liberacion
					//Solo se debe verificar la talla cuando son rectilineos que es este caso
					SELECT count(*)
					  INTO :ll_count
					  FROM temp_tela_n
					 WHERE cs_ordenpd_pt = :ll_ordenpd AND
							 co_reftel 		= :ll_reftel AND
							 co_caract 		= :li_caract AND
							 co_color 		= :ll_color_te AND
							 co_talla 		= :li_talla AND
						 	 usuario			= :ls_usuario AND
							 ((co_disenno	= :ls_disenno_ficha and :ls_disenno_ficha <> '0') or
							  (:ls_disenno_ficha = :ls_disenno_ficha and :ls_disenno_ficha = '0'));

	  				IF SQLCA.SQLCODE = -1 THEN
						rollback;
						MessageBox('Error Base de Datos','Se present$$HEX2$$f3002000$$ENDHEX$$un error validando la tela por modelo, intente de nuevo')
						return -1
					END IF

					//Actualizar los rollos		  
							  
				ELSE
					//ahora se debe verificar si existen todos las referencias para la liberacion
					//Solo se debe verificar la talla cuando son rectilineos, en este caso es tela
					SELECT count(*)
					  INTO :ll_count
					  FROM temp_tela_n
					 WHERE cs_ordenpd_pt = :ll_ordenpd AND
							 co_reftel 		= :ll_reftel AND
							 co_caract 		= :li_caract AND
							 co_color 		= :ll_color_te AND
						 	 usuario			= :ls_usuario AND
							 ((co_disenno	= :ls_disenno_ficha and :ls_disenno_ficha <> '0') or
							  (:ls_disenno_ficha = :ls_disenno_ficha and :ls_disenno_ficha = '0'));

					IF SQLCA.SQLCODE = -1 THEN
						rollback;
						MessageBox('Error Base de Datos','Se present$$HEX2$$f3002000$$ENDHEX$$un error validando la tela por modelo, intente de nuevo')
						return -1
					END IF

				END IF
						 
			END IF
					 
			IF ll_count > 0 Then
				//la tela se encuentra se debe seguir buscando con los dem$$HEX1$$e100$$ENDHEX$$s modelos
				IF li_raya = 10 THEN   //en bodega esta la tela principal, se marca si faltan los complementos
					li_raya10_en15 = 1
				END IF
			Else
				//no se encuentra la tela de este modelo, es decir que no se puede liberar esta referencia, por lo
				//tanto se deben eliminar todos los registros para dicha orden de produccion en las tablas
				//temp_tela_n y temp_refere_n
             //env$$HEX1$$ed00$$ENDHEX$$o la OP a la tabla de errores
				 //cargar de la ficha, los datos de la tela que falta   
	
				IF li_especial = 2 THEN
					ls_descripcion = 'No existe uno de los rectilineos en bodega, talla: ' + string(li_talla)
				ELSE
					ls_descripcion = 'No Existe la tela en bodega, tela: ' + string(ll_reftel) + ' Color: ' + string(ll_color_te)
				END IF
				
				
				//Actualizar los rollos	 de esta op con el respectivo concepto			 
				//Esto sol si la raya es la principal  Raya 10
				IF li_raya10_en15 = 1 THEN
				//	of_buscar_tela_faltante(ll_ordenpd,li_fab,li_lin,ll_ref,li_talla,ll_color,ll_reftel,li_caract,ll_color_te,li_diametro,ls_usuario)
				//	IF (is_donde_tela <> '') THEN
				//		ls_descripcion = is_donde_tela +  ' Tela: ' + string(ll_reftel) +  ' Color: ' + string(ll_color_te)
				//	END IF
				END IF
				of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,7)
			
				 //verifico si es bodysize
				If li_especial = 1 Then
					//es bodysize solo se deben borrar los datos de esta talla color
					DELETE FROM temp_referen_n
					WHERE cs_ordenpd_pt 	= :ll_ordenpd AND
					 		usuario 			= :ls_usuario AND
							co_talla       = :li_talla AND
							co_color       = :ll_color AND
							co_fabrica		= :li_fab AND
							co_linea 		= :li_lin AND
							co_referencia 	= :ll_ref;
				Else
					IF li_especial = 2 THEN
						//son rectilineos debo borrar la talla del color
						DELETE FROM temp_referen_n
						WHERE cs_ordenpd_pt 	= :ll_ordenpd AND
								usuario 			= :ls_usuario AND
								co_color       = :ll_color AND
								co_fabrica		= :li_fab AND
								co_linea 		= :li_lin AND
								co_referencia 	= :ll_ref AND
								co_talla			= :li_talla;

					ELSE
						//no es bodysize ni rectilineos debo borrar todas las tallas del color
						DELETE FROM temp_referen_n
						WHERE cs_ordenpd_pt 	= :ll_ordenpd AND
								usuario 			= :ls_usuario AND
								co_color       = :ll_color AND
								co_fabrica		= :li_fab AND
								co_linea 		= :li_lin AND
								co_referencia 	= :ll_ref;
					END IF
				End if
			ll_fila2 = lds_ficha.RowCount() + 1
			End if
      NEXT
	End if
	ll_ordenpd_old = lds_temp_ref.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ll_ref_old     = lds_temp_ref.GetItemNumber(ll_fila,'co_referencia')
	ll_color_old 	= lds_temp_ref.GetItemNumber(ll_fila,'co_color')
	li_talla_old   = li_talla
NEXT

Commit;
Destroy lds_temp_ref
Destroy lds_ficha   

CLOSE(w_retroalimentacion)

Return 0




end function

public function long of_cargar_modelos_unid ();String ls_usuario, ls_po, ls_tono, ls_tono_1, ls_cut, ls_descripcion, ls_error, ls_disenno
Long 	ll_result, ll_fila,   ll_ordenpd, ll_ref, ll_fila2, ll_modelo, ll_reftel, ll_count
Long	ll_unid_prog, ll_unid_liberadas, ll_unid_bode, ll_cm_bodega, ll_unid_liberar
Long	ll_unid_bode_1, ll_tanda, ll_tanda_1, ll_color, ll_color_te, ll_fila5, ll_bodysize
Long 	li_fab, li_lin, li_talla, li_marca, li_caract, li_diametro
Long	li_co_parte, li_cs_partes, li_raya, li_ya_inserto, ll_fila3, li_difer_ancho_tub
Long	li_difer_ancho_abi, ll_fila4, ll_fila_interna, li_suma_ancho, li_estado_tela
Long	li_estado_tela_1, li_factor_ancho, li_tipo_tela, li_talla_tela, li_contar2
Long	li_contador, li_tela_comprada, li_tipo_tejido
Decimal{3}	ld_porc_util, ld_porc_perd_orillo_cte
Decimal{2}	ld_ancho_1, ld_mt_bode_1, ld_kg_bode_1, ld_resta, ld_perdida_orillo
Decimal{2}	ld_mt_bode, ld_kg_bode
Decimal{4} 	ldc_porc_partic 
Decimal{2}  ld_area, ld_ancho, ld_grs_unid
Decimal{3}  ld_peso_tela, ld_gr_mt2
Decimal{5}	ld_consumo
DataStore lds_temp_ref, lds_ficha, lds_temp_tela_mod, lds_gr_mt2_term, lds_porc_orillo
n_cts_constantes_corte luo_constantes
n_cts_liberacion_x_proyeccion luo_liberacion_x_proyeccion
//SA56555 - Ceiba/reariase - 23-03-2017
n_cts_constantes_tela luo_constantes_tela
ld_porc_perd_orillo_cte = luo_constantes_tela.of_consultar_numerico("PORC_PERD_ORILLO_CTE")/100
//

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando Modelos Y Unidades a Liberar (4/6)..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                                 

lds_temp_ref 		= Create DataStore
lds_ficha    		= Create DataStore
lds_temp_tela_mod = Create DataStore
lds_gr_mt2_term   = Create DataStore
lds_porc_orillo   = Create DataStore


lds_temp_ref.DataObject    = 'ds_temp_refer_n_comp'
lds_ficha.DataObject       = 'ds_ficha_completa'
lds_gr_mt2_term.DataObject = 'ds_gr_mt2_term'
lds_porc_orillo.DataObject = 'ds_porcentaje_orillo'

lds_temp_ref.SetTransObject(sqlca)
lds_ficha.SetTransObject(sqlca)
lds_gr_mt2_term.SetTransObject(sqlca)
lds_porc_orillo.SetTransObject(sqlca)

IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_difer_ancho_tub = luo_constantes.of_consultar_numerico("DIFERENCIA_ANCHOS_TUB")
ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
	li_difer_ancho_tub = luo_constantes.of_consultar_numerico("DIFERENCIA_ANCHOS_TUB NICOLE")
END IF

IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_difer_ancho_abi = luo_constantes.of_consultar_numerico("DIFERENCIA_ANCHOS_ABI")
ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
	li_difer_ancho_abi = luo_constantes.of_consultar_numerico("DIFERENCIA_ANCHOS_ABI NICOLE")
END IF

IF li_difer_ancho_tub = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el valor de diferencia entre anchos tubular.')
	Return -1
END IF
IF li_difer_ancho_abi = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el valor de diferencia entre anchos Abiertos.')
	Return -1
END IF

ls_usuario = gstr_info_usuario.codigo_usuario
li_tela_comprada = 0

//se hace un ciclo de la temporal temp_refere_n
ll_result = lds_temp_ref.Retrieve(ls_usuario)

IF ll_result <= 0 THEN
	MessageBox('Error','No se encontraron datos de referencias para cargar a liberar')
	Return -1
END If

FOR ll_fila = 1 To lds_temp_ref.RowCount()
	ll_ordenpd 	 		= lds_temp_ref.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ls_po		 	 		= lds_temp_ref.GetItemString(ll_fila,'po')
	li_fab 		 		= lds_temp_ref.GetItemNumber(ll_fila,'co_fabrica')
	li_lin 		 		= lds_temp_ref.GetItemNumber(ll_fila,'co_linea')
	ll_ref 		 		= lds_temp_ref.GetItemNumber(ll_fila,'co_referencia')
	ll_color 	 		= lds_temp_ref.GetItemNumber(ll_fila,'co_color')
	li_talla 	 		= lds_temp_ref.GetItemNumber(ll_fila,'co_talla')
	li_marca 	 		= lds_temp_ref.GetItemNumber(ll_fila,'sw_marca')
	ll_unid_prog 		= lds_temp_ref.GetItemNumber(ll_fila,'unid_prog')
	ll_unid_liberadas = lds_temp_ref.GetItemNumber(ll_fila,'unid_liberadas')
	ldc_porc_partic   = lds_temp_ref.GetItemNumber(ll_fila,'porc_particip')
	ls_cut				= lds_temp_ref.GetItemString(ll_fila,'nu_cut')
	
	//verificamos los datos con respecto a la ficha
	ll_result = lds_ficha.Retrieve(li_fab,li_lin,ll_ref,li_talla,ll_color)
	
	IF ll_result = 0 THEN
		//No se encontr$$HEX3$$f30020002000$$ENDHEX$$datos en la ficha
		ls_descripcion = 'No encontro Ficha de Prenda. ' 
		of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,0,0,0,0,5)
	END IF
   
	FOR ll_fila2 = 1 To lds_ficha.RowCount()
		//se cargan los datos de la ficha
		ll_modelo 		= lds_ficha.GetItemNumber(ll_fila2,'co_modelo')
		ll_reftel 		= lds_ficha.GetItemNumber(ll_fila2,'co_reftel')
		li_caract 		= lds_ficha.GetItemNumber(ll_fila2,'co_caract')
		li_diametro 	= lds_ficha.GetItemNumber(ll_fila2,'diametro')
		ll_color_te 	= lds_ficha.GetItemNumber(ll_fila2,'co_color_te')
		ld_grs_unid 	= lds_ficha.GetItemNumber(ll_fila2,'ca_grs')
		ld_peso_tela 	= lds_ficha.GetItemNumber(ll_fila2,'peso_tela')
		li_tipo_tejido = lds_ficha.GetItemNumber(ll_fila2,'co_ttejido')
		ls_disenno		= trim(lds_ficha.GetItemString(ll_fila2,'co_disenno'))
		
					//por probar para caso de dise$$HEX1$$f100$$ENDHEX$$os que pasan de caract 7 a 8 y queda mal el dato mal creados en el dise$$HEX1$$f100$$ENDHEX$$o   marzo 18 - 2014 jorodrig
//			IF ls_disenno_ficha = '' THEN
//				ls_disenno_ficha = '0'
//			END IF
		
		
		ld_porc_util 	= (lds_ficha.GetItemNumber(ll_fila2,'porc_utilizacion')) / 100 
		ld_area 			= lds_ficha.GetItemNumber(ll_fila2,'area')  //el area ya esta multiplicada por el # de piezas
		li_raya 			= lds_ficha.GetItemNumber(ll_fila2,'raya')
		
		li_tipo_tela = of_rectilineo(ll_reftel,li_caract)	
		
		IF (li_tipo_tejido = 131) OR (li_tipo_tejido = 212) OR (li_tipo_tejido = 211) THEN	//son hiladillas y encajes
			li_tipo_tela = 4
		END IF
		
		IF (ld_porc_util < 0.001  OR  ISNULL(ld_porc_util)) AND (li_tipo_tela <> 3) THEN   //si no son rectilineos se valida el % util
			MessageBox('Advertencia','El porcentaje de utilizacion en la ficha del modelo: ' + string(ll_modelo) + 'Puede estar malo, pues tiene este valor: ' + string(ld_porc_util) + ' pida que lo revisen')
		END IF

	
		//aca se verifica si la tela es comprada o si es un blanco para no validar la tanda en la agrupacion de ancho de rollos
		li_tela_comprada = of_buscar_tipo_tela_tono_col(ll_color_te,ll_ordenpd,ll_reftel) 
			
		IF ISNULL(li_raya) THEN
			ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
			                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' En la ficha el c$$HEX1$$f300$$ENDHEX$$digo de la raya esta nulo '			 
		   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,7)
			Messagebox('advertencia',ls_descripcion)
		END IF	
		
		IF ld_grs_unid = 0 OR ISNULL(ld_grs_unid) THEN
			ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
			                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' No hay gramos en la ficha '			 
		   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,8)
			Messagebox('advertencia',ls_descripcion)
			return -1
		END IF	
		
		IF ld_peso_tela = 0 OR ISNULL(ld_peso_tela) THEN
			ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
			                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' No hay gramos en la ficha '			 
		   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,8)
			Messagebox('advertencia',ls_descripcion)
			return -1
		END IF	

		
		IF  ld_porc_util = 0 OR ISNULL(ld_porc_util)  THEN
			ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
			                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' No hay porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n en la ficha o esta en cero '			 
		   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,9)
			ld_porc_util = 0.01  //se asigna  1 al % de utilizacion
			Messagebox('advertencia',ls_descripcion)
			return -1
		END IF	
		
		IF   ld_area = 0 OR ISNULL(ld_area)THEN
			ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
			                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' No se encontr$$HEX2$$f3002000$$ENDHEX$$el $$HEX1$$e100$$ENDHEX$$rea en la ficha '			 
		   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,10)
			Messagebox('advertencia',ls_descripcion)
			return -1
		END IF	
		
		IF li_tipo_tela = 3 THEN  //son rectilineos
			li_marca = 3   //marca 3 son rectilineos
			li_talla_tela = li_talla
		ELSE
			//validamos que el porcentaje de utilizacion en telas sea mayor que 0.1, en rectilineos si puede ser 0.1 por eso hay no valido
			IF  ld_porc_util <= 0.01  THEN
				ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
				                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' No hay porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n en la ficha o esta en cero '			 
			   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,9)
				ld_porc_util = 0.01  //se asigna  1 al % de utilizacion
				Messagebox('advertencia',ls_descripcion)
			END IF	
			
			//buscar si es bodysize en la o.p. para saber si controlo en la ficha por diametro o no
			li_contador = luo_liberacion_x_proyeccion.of_revisar_si_bodysize(li_fab,li_lin,ll_ref,ll_color)
			IF li_contador > 0 THEN
				li_marca = 1
			ELSE
				li_marca = 0
			END IF
			li_talla_tela = 9999    //es tela se crea talla generica
		END IF
		
		IF li_marca = 1 THEN
			lds_temp_tela_mod.DataObject  = 'ds_temp_tela_tot_x_ancho_bd'
		ELSE
			//en el where se quito el diametro
			lds_temp_tela_mod.DataObject  = 'ds_temp_tela_tot_x_ancho_nm'
		END IF
		lds_temp_tela_mod.SetTransObject(sqlca)
			
		ll_result = lds_temp_tela_mod.Retrieve(ls_usuario,ll_ordenpd,ll_reftel,li_caract,ll_color_te,li_diametro,li_talla_tela,ls_disenno)
		
		IF ll_result = 0 THEN
			//No se encontr$$HEX2$$f3002000$$ENDHEX$$telas segun la ficha
			ls_descripcion = 'La tela que necesita segun la ficha no esta para esta raya: ' + string(li_raya) + ' Talla: ' + string(li_talla)
			of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,6)
			Messagebox('advertencia',ls_descripcion)
		END IF
				
		FOR ll_fila3 = 1 To ll_result
				ls_tono 			= lds_temp_tela_mod.GetItemString(ll_fila3,'co_tono')
				li_estado_tela = lds_temp_tela_mod.GetItemNumber(ll_fila3,'estado_final')
				ld_ancho 		= lds_temp_tela_mod.GetItemNumber(ll_fila3,'ancho')
				IF ld_ancho > 500 THEN
					Rollback;
					CLOSE(w_retroalimentacion)
					MessageBox('Error', 'El ancho de uno de los rollos esta incorrecto tiene un valor superior a 500 cm')
					Return -1;
				END IF

				ld_mt_bode 		= lds_temp_tela_mod.GetItemNumber(ll_fila3,'ld_mts_bod')
				ld_kg_bode 		= lds_temp_tela_mod.GetItemNumber(ll_fila3,'ld_kg_bod')
				ll_unid_bode 	= lds_temp_tela_mod.GetItemNumber(ll_fila3,'ll_unid_bod')
				ll_tanda 		= lds_temp_tela_mod.GetItemNumber(ll_fila3,'cs_tanda')
				
				//Recuperar gr/m2 terminado de m_rollo
				If lds_gr_mt2_term.Retrieve(ls_usuario,ll_tanda,ll_reftel,ld_ancho) <= 0 Then
					MessageBox("Error","Al buscar los gr/mt2 de los rollos")
					Return -1
				End If
				
				ld_gr_mt2 = lds_gr_mt2_term.GetItemDecimal(1,"gr_mt2_terminado")
				
				IF isnull(ld_gr_mt2) THEN
					ld_gr_mt2 = 0
				END IF
								
				IF li_estado_tela > 4 THEN  // Esta variable me dice si la tela es tubular (4) o abierta (8)
					li_suma_ancho = li_difer_ancho_abi
					li_factor_ancho = 1
				ELSE
					li_suma_ancho = li_difer_ancho_tub
					li_factor_ancho = 2
				END IF
				
				IF (li_tipo_tela = 3) OR (li_marca = 1 )   THEN  //Constante de telas rectilineas o tela bodysize
				ELSE
					ll_fila_interna = ll_fila3 + 1
					FOR ll_fila4 = ll_fila_interna TO lds_temp_tela_mod.RowCount()
							//ls_tono_1			= lds_temp_tela_mod.GetItemString(ll_fila4,'co_tono')
							ll_tanda_1  = lds_temp_tela_mod.GetItemNumber(ll_fila4,'cs_tanda')
							li_estado_tela_1	= lds_temp_tela_mod.GetItemNumber(ll_fila4,'estado_final')
//							IF ((ll_tanda = ll_tanda_1) AND (li_estado_tela = li_estado_tela_1)) OR (li_tela_comprada = 1) THEN
							IF ((ll_tanda = ll_tanda_1) AND (li_estado_tela = li_estado_tela_1)) THEN
								ld_ancho_1 			= lds_temp_tela_mod.GetItemNumber(ll_fila4,'ancho')
								ld_mt_bode_1 		= lds_temp_tela_mod.GetItemNumber(ll_fila4,'ld_mts_bod')
								ld_kg_bode_1 		= lds_temp_tela_mod.GetItemNumber(ll_fila4,'ld_kg_bod')
								ll_unid_bode_1 	= lds_temp_tela_mod.GetItemNumber(ll_fila4,'ll_unid_bod')
								ld_resta				= ld_ancho_1 - ld_ancho
								IF ld_resta <= li_suma_ancho THEN
									//Estos anchos se pueden agrupar
									ld_mt_bode += ld_mt_bode_1
									ld_kg_bode += ld_kg_bode_1
									ll_unid_bode += ll_unid_bode_1
									ll_fila3 = ll_fila4 
									
									IF li_marca = 1 THEN
										UPDATE temp_tela_n
										SET ancho_agrupa = :ld_ancho
										WHERE temp_tela_n.usuario = :ls_usuario    
										  AND temp_tela_n.cs_ordenpd_pt = :ll_ordenpd
										  AND temp_tela_n.co_reftel  = :ll_reftel
										  AND temp_tela_n.co_caract = :li_caract
										  AND temp_tela_n.co_color = :ll_color_te
										  AND temp_tela_n.diametro = :li_diametro
										  AND temp_tela_n.co_talla = :li_talla_tela
										  AND temp_tela_n.ancho = :ld_ancho_1
										  AND temp_tela_n.cs_tanda = :ll_tanda
										  AND ((temp_tela_n.co_disenno = :ls_disenno and :ls_disenno <> '0' and temp_tela_n.co_caract = 7)
										   or  (:ls_disenno = :ls_disenno and :ls_disenno = '0'));
									ELSE
										UPDATE temp_tela_n
										SET ancho_agrupa = :ld_ancho
										WHERE temp_tela_n.usuario = :ls_usuario    
										  AND temp_tela_n.cs_ordenpd_pt = :ll_ordenpd
										  AND temp_tela_n.co_reftel  = :ll_reftel
										  AND temp_tela_n.co_caract = :li_caract
										  AND temp_tela_n.co_color = :ll_color_te
										  AND temp_tela_n.co_talla = :li_talla_tela
										  AND temp_tela_n.ancho = :ld_ancho_1
										  AND temp_tela_n.cs_tanda = :ll_tanda
										  AND ((temp_tela_n.co_disenno = :ls_disenno and :ls_disenno <> '0' and temp_tela_n.co_caract = 7)
										   or  (:ls_disenno = :ls_disenno and :ls_disenno = '0'));

									END IF
								END IF
							END IF
						NEXT
				END IF
								
				IF ld_area = 0 THEN ld_area = 1
				IF ld_porc_util = 0 THEN ld_porc_util = 1
				
				IF li_marca = 3 THEN
				   ld_consumo =0 //cuando la tela es rectilinea
				   ll_unid_liberar = ll_unid_bode
				ELSE

					IF li_tipo_tela = 4 THEN  //solo en hiladilla utiliza formula anterior
						//Formula anterior consumo
						IF ld_ancho = 0 THEN 
							ld_consumo = ((ld_area / ld_porc_util) / ( li_factor_ancho)) / 100
						ELSE
							ld_consumo = ((ld_area / ld_porc_util) / (ld_ancho )) / 100
						END IF
					ELSE
						ld_consumo = (ld_gr_mt2/10000 * ld_area) / ld_porc_util			
						ld_consumo = ld_consumo / 1000 //convertir a kilos
					END IF

					//SA56373 - Ceiba/reariase - 20-02-2017
					ll_result = lds_porc_orillo.Retrieve(ll_reftel)
					IF ll_result <= 0 THEN
						MessageBox('Error','No se encontr$$HEX2$$f3002000$$ENDHEX$$porcentaje del Orillo de acuerdo a la tela')
						Return -1
					END If					
					FOR ll_fila5 = 1 To lds_porc_orillo.RowCount()
						ld_perdida_orillo = lds_porc_orillo.GetItemNumber(ll_fila5,'porc_perd_orillo')
						//miar si es bodysize para no sumarle la perdida en el orillo 
						ll_bodysize = lds_porc_orillo.GetItemNumber(ll_fila5,'bodysize')
						If ll_bodysize = 1 Then
							ld_consumo = ld_consumo 
						Else
							ld_consumo = ld_consumo * (1 + ld_perdida_orillo)
						End if
						
						//SA56555 - Ceiba/reariase - 23-03-2017
						//Es necesario sumar tambien la perdida del orillo en corte,  el anterior son las cabeceras, este
                  //que vamos a sumar es el de los lados, solo si lleva el % de  cabeceras lleva el orillo solicita Ubeimar Alvarez. SA56555
						If ld_perdida_orillo > 0 And ld_porc_perd_orillo_cte > 0 Then
							ld_consumo = ld_consumo * (1 + ld_porc_perd_orillo_cte)
						End If
						//Fin SA56555
					NEXT
					//Fin SA56373
					
					//temporalmente se coloca esto para el caso en que el consumo es demasiado bajito
					IF ld_consumo = 0 AND li_raya <> 10 THEN
						ld_consumo = 0.0001
					END IF
					IF ld_gr_mt2 = 0 THEN
						MessageBox('Error','Los grm_mt2 del rollo estan en cero.',StopSign!)
					END IF
					
					IF ld_consumo = 0 THEN
						Rollback;
						CLOSE(w_retroalimentacion)
						MessageBox('Error','Consumo en cero por favor verifique la informaci$$HEX1$$f300$$ENDHEX$$n de la ficha.',StopSign!)
						Return -1
					END IF
					
					IF li_tipo_tela = 4 THEN
						ll_unid_liberar = (ld_mt_bode * ldc_porc_partic)/ ld_consumo
					ELSE
						ll_unid_liberar = (ld_kg_bode * ldc_porc_partic)/ ld_consumo
					END IF
				

				END IF
						
				IF ll_unid_liberar <= 0 THEN
					//				//se carga al log de errores
					ls_descripcion = ' En la prenda: ' + string(ll_ref) + ' Color: ' + string(ll_color) + ' En la Tela: ' + string(ll_reftel) +' color tela: ' +&
			                         string(ll_color_te) + ' Diametro: ' + string(li_diametro) + ' Caract: ' + string(li_caract)  + ' Modelo: ' + string(ll_modelo) + ' Talla: ' + string(li_talla) + ' Las unidades estan en 0 '			 
//			   of_cargar_log_problemas(ls_descripcion,ll_ordenpd,ls_po,ll_ref,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,7)
					Messagebox('Advertencia',ls_descripcion)
				END IF
				
				SELECT COUNT(*)
				  INTO :li_ya_inserto
				  FROM temp_modelos_ref
				WHERE usuario = :ls_usuario
				   AND cs_ordenpd_pt = :ll_ordenpd
					AND po 				= :ls_po
					AND co_fabrica 	= :li_fab
					AND co_linea 		= :li_lin
					AND co_referencia = :ll_ref
					AND co_color 		= :ll_color
					AND co_talla 		= :li_talla
					AND co_modelo 		= :ll_modelo
					AND co_reftel 		= :ll_reftel
					AND co_caract 		= :li_caract
					AND diametro 		= :li_diametro
					AND co_color_te 	= :ll_color_te
					AND ancho 			= :ld_ancho
					AND cs_tanda 		= :ll_tanda
					AND co_estampado		= :ls_disenno;
					
				ld_mt_bode = ld_mt_bode * ldc_porc_partic 
				ld_kg_bode = ld_kg_bode * ldc_porc_partic 
				
				IF li_ya_inserto = 0 THEN
					//verificar que la tela no exista en otra raya
					SELECT COUNT(*)
					  INTO :li_contar2
					  FROM temp_modelos_ref
					WHERE usuario = :ls_usuario
						AND cs_ordenpd_pt = :ll_ordenpd
						AND po 				= :ls_po
						AND co_fabrica 	= :li_fab
						AND co_linea 		= :li_lin
						AND co_referencia = :ll_ref
						AND co_color 		= :ll_color
						AND co_talla 		= :li_talla
						AND co_reftel 		= :ll_reftel
						AND co_caract 		= :li_caract
						AND diametro 		= :li_diametro
						AND co_color_te 	= :ll_color_te
						AND ancho 			= :ld_ancho
						AND cs_tanda 		= :ll_tanda
						AND co_estampado		= :ls_disenno;
					IF li_contar2 > 0 AND ll_unid_liberar > 0 THEN
						//los metros y los kilos se insertan en 0
										
						INSERT INTO temp_modelos_ref 
							 (usuario, 
							  cs_ordenpd_pt, 
							  po, 
							  co_fabrica, 
							  co_linea, 
							  co_referencia,                                                              
							  co_color, 
							  co_talla, 
							  co_modelo, 
							  co_reftel, 
							  co_caract, 
							  co_color_te,                                                               
							  diametro, 
							  ancho, 
							  tono, 
							  area, 
							  grm_ficha, 
							  mt_bodega,	
							  kg_bodega,
							  unid_bodega, 
							  unid_liberar, 
							  sw_marca, 
							  consumo, 
							  raya, 
							  unid_prog,
							  nu_cut,
							  co_estampado,
							  cs_tanda)
					VALUES (:ls_usuario, 
							  :ll_ordenpd, 
							  :ls_po, 
							  :li_fab, 
							  :li_lin, 
							  :ll_ref, 
							  :ll_color,
						     :li_talla, 
						     :ll_modelo, 
						     :ll_reftel, 
						  	  :li_caract, 
						     :ll_color_te, 
						     :li_diametro,
						     :ld_ancho, 
						     :ls_tono, 
						     :ld_area, 
						     :ld_grs_unid, 
						     0, 
						     0,
						     0, 
							  :ll_unid_liberar, 
							  :li_marca, 
							  :ld_consumo, 
							  :li_raya, 
							  :ll_unid_prog, 
							  :ls_cut,
							  :ls_disenno,
							  :ll_tanda	);
						IF SQLCA.SQLCODE <> 0 THEN
							ls_error = sqlca.sqlerrtext
							Rollback;
							CLOSE(w_retroalimentacion)
							MessageBox('Error', 'Se produjo error actualizando modelos por referencia: ' + ls_error)
							Return -1;
						END IF
					ELSE
						IF ll_unid_liberar > 0 THEN
						
							INSERT INTO temp_modelos_ref 
								( usuario, 
								  cs_ordenpd_pt, 
								  po, 
								  co_fabrica, 
								  co_linea, 
								  co_referencia,                                                              
								  co_color, 
								  co_talla, 
								  co_modelo, 
								  co_reftel, 
								  co_caract, 
								  co_color_te,                                                               
								  diametro, 
								  ancho, 
								  tono, 
								  area, 
								  grm_ficha, 
								  mt_bodega,	
								  kg_bodega,
								  unid_bodega, 
								  unid_liberar, 
								  sw_marca, 
								  consumo, 
								  raya, 
								  unid_prog, 
								  nu_cut,
								  co_estampado,
								  cs_tanda	)
							VALUES 
								 (:ls_usuario, 
								  :ll_ordenpd, 
								  :ls_po, 
								  :li_fab, 
								  :li_lin, 
								  :ll_ref, 
								  :ll_color,
								  :li_talla, 
								  :ll_modelo, 
								  :ll_reftel, 
								  :li_caract, 
								  :ll_color_te, 
								  :li_diametro,
								  :ld_ancho, 
								  :ls_tono, 
								  :ld_area, 
								  :ld_grs_unid, 
								  :ld_mt_bode, 
								  :ld_kg_bode,
								  :ll_unid_bode, 
								  :ll_unid_liberar, 
								  :li_marca, 
								  :ld_consumo, 
								  :li_raya, 
								  :ll_unid_prog, 
								  :ls_cut,
								  :ls_disenno,
								  :ll_tanda);
							
							IF SQLCA.SQLCODE <> 0 THEN
								ls_error = sqlca.sqlerrtext
								Rollback;
								CLOSE(w_retroalimentacion)
								MessageBox('Error', 'Se produjo error actualizando modelos por referencia: ' + ls_error)
								Return -1;
							END IF
						END IF
					END IF
				ELSE
					IF ld_ancho = 0 THEN ld_ancho = 1
					
					UPDATE temp_modelos_ref
					SET (area, consumo) = ( (area + :ld_area), ((area + :ld_area)/:ld_porc_util)/:ld_ancho )
				   WHERE usuario = :ls_usuario
				   AND cs_ordenpd_pt = :ll_ordenpd
					AND po 				= :ls_po
					AND co_fabrica 	= :li_fab
					AND co_linea 		= :li_lin
					AND co_referencia = :ll_ref
					AND co_color 		= :ll_color
					AND co_talla 		= :li_talla
					AND co_modelo 		= :ll_modelo
					AND co_reftel 		= :ll_reftel
					AND co_caract 		= :li_caract
					AND diametro 		= :li_diametro
					AND co_color_te 	= :ll_color_te
					AND ancho 			= :ld_ancho
					AND cs_tanda		= :ll_tanda
					AND co_estampado		= :ls_disenno;
					IF SQLCA.SQLCODE <> 0 THEN
						ls_error = sqlca.sqlerrtext
						Rollback;
						CLOSE(w_retroalimentacion)
						MessageBox('Error', 'Se produjo error actualizando modelos por referencia: ' + ls_error)
						Return -1;
					END IF
				END IF
		NEXT
	NEXT
NEXT
COMMIT;

destroy lds_temp_ref 		
destroy lds_ficha    		
destroy lds_temp_tela_mod 

CLOSE(w_retroalimentacion)

//validar tandas para los modelos - color
of_validarTandaModelo()

//validar que si este completa la liberacion
IF of_validar_modelos_completos(li_fab, li_lin, ll_ref, ll_color, ll_ordenpd, ls_usuario) = -1 THEN
	Rollback;
	CLOSE(w_retroalimentacion)
	MessageBox('Error', 'No se tiene tela para todos los modelos que componen la prenda')
	Return -1;

END IF

//distribuye las unidades teniendo en cuenta la proporcionalidad y el modelo con menores unidades
of_unidadesliberar()	
//of_calcular_kilos()  Esta funcion se encarga de calcular con los metros, el ancho y los gr/mt2 cuantos kilos son, esto por formula
//of_unidadesrealesliberar()

Return 0
end function

public function long of_unidadesliberar ();Long ll_unidades, ll_result, ll_fila, ll_pedido, ll_ordenpd_pt, ll_result1, ll_fila1, ll_unid_prog,&
     ll_ref, ll_modelo, ll_reftel, ll_tanda, ll_color, ll_color_te
Decimal{5} ldc_consumo
Decimal{5} ldc_factor1, ldc_factor2, ldc_kg, ld_ancho
Decimal{3}	ldc_mt
String ls_usuario, ls_po, ls_tono, ls_error
Long li_fab, li_lin, li_talla, li_caract, li_diametro, li_raya
Long	li_marca,  li_tipo_tejido, li_tipo_tela
DataStore lds_unidlib, lds_temp_ref

//SA60755 Corregir error de calculo de unidades en la liberacion que no daba el total exacto, cuando es solo una talla
//se realiza el calculo diferente.

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Calculando Proporciones por Color (6/6)..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                                 

lds_unidlib = Create DataStore
lds_temp_ref = Create DataStore
lds_unidlib.DataObject  = 'dgr_unidades_liberar_prueba'
lds_temp_ref.DataObject = 'ds_temp_modelos_ref_prueba'
lds_unidlib.SetTransObject(sqlca)
lds_temp_ref.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

//recorro las referencias de temp_referen_n
ll_result1 = lds_temp_ref.Retrieve(ls_usuario)

IF ll_result1 <= 0 THEN
	CLOSE(w_retroalimentacion)
	Rollback;
	MessageBox('Error','No es posible liberar por tanda, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	Return -1;
END IF



For ll_fila1 = 1 To ll_result1
   //traemos los datos necesarios para recalcular las unidades
	ls_po 			= lds_temp_ref.GetItemString(ll_fila1,'po')
	ll_ordenpd_pt 	= lds_temp_ref.GetItemNumber(ll_fila1,'cs_ordenpd_pt')
	ll_color 		= lds_temp_ref.GetItemNumber(ll_fila1,'co_color')
	li_fab			= lds_temp_ref.GetItemNumber(ll_fila1,'co_fabrica')
	li_lin			= lds_temp_ref.GetItemNumber(ll_fila1,'co_linea')
	ll_ref			= lds_temp_ref.GetItemNumber(ll_fila1,'co_referencia')
	li_talla			= lds_temp_ref.GetItemNumber(ll_fila1,'co_talla')
	ll_reftel		= lds_temp_ref.GetItemNumber(ll_fila1,'co_reftel')
	li_caract		= lds_temp_ref.GetItemNumber(ll_fila1,'co_caract')
	li_diametro		= lds_temp_ref.GetItemNumber(ll_fila1,'diametro')
	ll_color_te		= lds_temp_ref.GetItemNumber(ll_fila1,'co_color_te')
	ld_ancho			= lds_temp_ref.GetItemNumber(ll_fila1,'ancho')
	ls_tono			= lds_temp_ref.GetItemString(ll_fila1,'tono')
	ll_unid_prog	= lds_temp_ref.GetItemNumber(ll_fila1,'unid_prog')
	li_marca			= lds_temp_ref.GetItemNumber(ll_fila1,'sw_marca')
	ll_tanda			= lds_temp_ref.GetItemNumber(ll_fila1,'cs_tanda')
	li_tipo_tejido	= lds_temp_ref.GetItemNumber(ll_fila1,'co_ttejido')
	
	
		
	IF li_tipo_tejido = 131 OR li_tipo_tejido = 212 OR li_tipo_tejido = 211 THEN	//son hiladillas
		li_tipo_tela = 4
	ELSE
		li_tipo_tela = 1
	END IF
	
	IF of_rectilineo(ll_reftel,li_caract) = 3 THEN  //son rectilineas, no se recalculan unidades
	ELSE
		ldc_factor1 = 0
		ldc_factor2 = 0
		ll_result = lds_unidlib.Retrieve(ls_usuario,ll_ordenpd_pt,ls_po,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,ll_tanda,ld_ancho)
		For ll_fila = 1 To ll_result
			ll_pedido = lds_unidlib.GetItemNumber(ll_fila,'unid_prog')
			ldc_consumo = lds_unidlib.GetItemNumber(ll_fila,'consumo')
			
			IF ll_result1 = 1 THEN
				ldc_factor1 += ldc_consumo
			ELSE
				ldc_factor1 += ll_pedido * ldc_consumo
			END IF
			
		Next
		
		IF li_marca = 1 THEN
		SELECT sum(ca_mt),sum(ca_kg)
			  INTO :ldc_mt,:ldc_kg
			  FROM temp_tela_n
			 WHERE usuario 		= :ls_usuario AND
					 cs_ordenpd_pt = :ll_ordenpd_pt AND
					 co_reftel 		= :ll_reftel AND
					 co_caract 		= :li_caract AND
					 diametro 		= :li_diametro AND
					 co_color		= :ll_color_te	AND
					 ancho_agrupa	= :ld_ancho AND
					 cs_tanda		= :ll_tanda;
			ELSE
				SELECT sum(ca_mt),sum(ca_kg)
				  INTO :ldc_mt,:ldc_kg
				  FROM temp_tela_n
				 WHERE usuario 		= :ls_usuario AND
						 cs_ordenpd_pt = :ll_ordenpd_pt AND
						 co_reftel 		= :ll_reftel AND
						 co_caract 		= :li_caract AND
						 co_color		= :ll_color_te	AND
						 ancho_agrupa	= :ld_ancho AND
						 cs_tanda		= :ll_tanda;
			END IF
				 
		IF ll_result1 = 1 THEN		 
			IF li_tipo_tela = 4 THEN	
				ldc_factor2 = ldc_mt 
			ELSE
				ldc_factor2 = ldc_kg 
			END IF
			ll_unidades = ldc_factor2 / ldc_factor1
		ELSE
			IF li_tipo_tela = 4 THEN	
				ldc_factor2 = ldc_mt / ldc_factor1
			ELSE
				ldc_factor2 = ldc_kg / ldc_factor1
			END IF
			ll_unidades = ldc_factor2 * ll_unid_prog
		END IF
		
		If isnull(ll_unidades) Then ll_unidades = 0
				
		UPDATE temp_modelos_ref
		SET (unid_liberar, kg_bodega, mt_bodega, unid_real_liberar) = ( :ll_unidades, (:ll_unidades * consumo),  (:ll_unidades * consumo),:ll_unidades)
		WHERE usuario = :ls_usuario
		AND cs_ordenpd_pt = :ll_ordenpd_pt
		AND po 				= :ls_po
		AND co_fabrica 	= :li_fab
		AND co_linea 		= :li_lin
		AND co_referencia = :ll_ref
		AND co_color 		= :ll_color
		AND co_talla 		= :li_talla
		AND co_reftel 		= :ll_reftel
		AND co_caract 		= :li_caract
		AND diametro 		= :li_diametro
		AND co_color_te 	= :ll_color_te
		AND ancho 			= :ld_ancho
		AND cs_tanda		= :ll_tanda;
		IF SQLCA.SQLCODE <> 0 THEN
			CLOSE(w_retroalimentacion)
			ls_error = sqlca.sqlerrtext
			Rollback;
			MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar: ' + ls_error)
			Return -1;
		END IF
	END IF   //final de rectilineas
Next

commit;
CLOSE(w_retroalimentacion)
Destroy lds_unidlib
Destroy lds_temp_ref
Return 0
end function

public function long of_rectilineo (long al_reftel, long ai_caract);Long li_kte_tela_recti, li_tela_recti, li_tiptejido

n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes


li_kte_tela_recti = luo_constantes.of_consultar_numerico("I_TELA_RECTI")
IF li_kte_tela_recti = -1 THEN
	Return -1
END IF



//se debe conocer el tipo de tela
SELECT m_tiptel.i_tela_recti, h_telas.co_ttejido
  INTO :li_tela_recti, :li_tiptejido
  FROM h_telas, m_tiptel
 WHERE h_telas.co_tiptel = m_tiptel.co_tiptel AND
       h_telas.co_reftel = :al_reftel AND
       h_telas.co_caract = :ai_caract;

IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el tipo de tela. '+ sqlca.SqlErrText)
	Return -1
END IF
		 
		 //se adiciona que al tipo de tejido aplicaciones lo tome como rectilineo
IF li_tela_recti = li_kte_tela_recti OR li_tiptejido = 181  THEN
	Return 3
ELSE
	Return 0
END IF
			
			

end function

public subroutine of_unidadesrealesliberar ();//funciono para colocar el numero maximo de unidades a liberar, de acuerdo
//a la minima cantidad de alguna de las rayas.
String ls_usuario, ls_po, ls_error
Long ll_result, ll_fila, ll_ordenpd_pt, ll_liberar, ll_liberadas, ll_programado, ll_valor,&
     ll_vlr_constante, ll_ref,ll_unid_mas_liberar,ll_tope_liberar, ll_fila1, ll_count,&
	  ll_modelo, ll_reftel, ll_uni_min, ll_unid, ll_mod_min, ll_color
Long li_talla, li_fab, li_lin, li_result
Decimal{4} ldc_porc_liberar, ldc_ancho, ldc_porcentaje
DataStore lds_ref, lds_ancho
n_cts_constantes_corte luo_constantes

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Buscando la menor cantidad por Raya ..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)             

ls_usuario = gstr_info_usuario.codigo_usuario

lds_ref = Create DataStore
lds_ancho = Create DataStore
lds_ref.DataObject = 'ds_temp_referencias_min_unidades'
lds_ancho.DataObject = 'ds_ancho'
lds_ref.SetTransObject(sqlca)
lds_ancho.SetTransObject(sqlca)

//primero se debe recorrer las tallas de la liberacion
ll_result = lds_ref.Retrieve(ls_usuario)
For ll_fila = 1 To ll_result
	ll_ordenpd_pt 	= lds_ref.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	li_talla 		= lds_ref.GetItemNumber(ll_fila,'co_talla')
	ll_color			= lds_ref.GetItemNumber(ll_fila,'co_color')
	ls_po				= lds_ref.GetItemString(ll_fila,'po')
	li_fab			= lds_ref.GetItemNumber(ll_fila,'co_fabrica')
	li_lin			= lds_ref.GetItemNumber(ll_fila,'co_linea')
	ll_ref			= lds_ref.GetItemNumber(ll_fila,'co_referencia')
	
	//colocar data store con ancho
	lds_ancho.Retrieve(ll_ordenpd_pt,li_talla,ll_color,ls_po,ls_usuario)
	ll_uni_min =  lds_ancho.GetItemNumber(1,'unid_liberar')
	
	FOR ll_fila1 = 1 To lds_ancho.RowCount()
		ll_modelo  = lds_ancho.GetItemNumber(ll_fila1,'co_modelo')
		ll_reftel  = lds_ancho.GetItemNumber(ll_fila1,'co_reftel')
		ll_liberar = lds_ancho.GetItemNumber(ll_fila1,'unid_liberar')
	   IF ll_liberar < ll_uni_min THEN
			ll_uni_min = ll_liberar
			ll_mod_min = ll_modelo
		END IF
	NEXT
		
		//ya tenemos el minimo, ahora se debe saber si este minimo mas lo liberado no supera lo pedido
		SELECT unid_prog
		  INTO :ll_programado
		  FROM temp_referen_n
		 WHERE cs_ordenpd_pt = :ll_ordenpd_pt AND
				 co_talla 		= :li_talla AND
				 co_color		= :ll_color AND 
				 po				= :ls_po AND
				 usuario 		= :ls_usuario ;
		//ya se tiene la cantidad programada, ahora debo saber si le tengo que sumar un porcentaje o un valor
		//a esta cantidad para saber el tope hasta donde puedo liberar
		//********************************se establece el valor a adicionar al pedido original **************
		//traigo el valor de la tabla
		SELECT nvl(tope_min_unid,0)
			  INTO :ll_vlr_constante
			  FROM m_porc_permitido
			 WHERE co_fabrica 	= :li_fab AND
					 co_linea 		= :li_lin AND
					 co_referencia = :ll_ref AND
					 co_color 		= :ll_color;
	
		IF ll_programado < ll_vlr_constante THEN 
			//se debe incrementar al valor del pedido la unidades de m$$HEX1$$e100$$ENDHEX$$s que se tienen en m_porc_permitido para esta
			//referencia-color
			SELECT nvl(unid_adicionar,0)
			  INTO :ll_unid_mas_liberar
			  FROM m_porc_permitido
			 WHERE co_fabrica 	= :li_fab AND
					 co_linea 		= :li_lin AND
					 co_referencia = :ll_ref AND
					 co_color 		= :ll_color;
				 
			ll_programado = ll_programado + ll_unid_mas_liberar		 
		ELSE
			SELECT porc_liberar
			  INTO :ldc_porc_liberar
			  FROM m_porc_permitido
			 WHERE co_fabrica 	= :li_fab AND
					 co_linea 		= :li_lin AND
					 co_referencia = :ll_ref AND
					 co_color 		= :ll_color;
		
			IF isnull(ldc_porc_liberar) OR ldc_porc_liberar = 0 THEN 
				ldc_porcentaje = luo_constantes.of_consultar_numerico("PORCENTAJE_LIBERAR")
				IF ldc_porcentaje = -1 THEN
					ldc_porcentaje = 5
				END IF
				ldc_porc_liberar = ldc_porcentaje
			END IF
			ll_unid_mas_liberar = (ll_programado * ldc_porc_liberar) /100
			ll_programado = ll_programado + ll_unid_mas_liberar
		END IF
	
		//buscamos las cantidades liberadas primero en exportaciones
			SELECT count(*)
			 INTO :ll_count
			 FROM dt_caxpedidos
			WHERE cs_ordenpd_pt = :ll_ordenpd_pt AND
					co_talla      = :li_talla AND
					co_color      = :ll_color;
		
		IF ll_count > 0 THEN
		  SELECT nvl(sum(ca_liberadas),0)
			 INTO :ll_liberadas
			 FROM dt_caxpedidos
			WHERE cs_ordenpd_pt = :ll_ordenpd_pt AND
					co_talla      = :li_talla AND
					co_color      = :ll_color; 
		ELSE
			//no es de exportacion, se busca en nacionales
			  SELECT nvl(sum(ca_liberada),0)
				 INTO :ll_liberadas
				 FROM dt_orden_tllaclor
				WHERE cs_ordenpd_pt = :ll_ordenpd_pt AND
						co_talla		  = :li_talla AND
						co_color      = :ll_color	;
		END IF
			
		//asigno el valor a liberar
		IF (ll_liberadas + ll_uni_min) > ll_programado THEN
			ll_valor = ll_liberadas + ll_uni_min - ll_programado
			ll_valor = ll_uni_min - ll_valor
			IF ll_valor < 0 THEN ll_valor = 0
		ELSE
			ll_valor = ll_uni_min
		END IF
		
		//hacemos ciclo para modificar las unidades a todos los modelos
		FOR ll_fila1 = 1 To lds_ancho.RowCount()
			ll_modelo  = lds_ancho.GetItemNumber(ll_fila1,'co_modelo')
			ll_reftel  = lds_ancho.GetItemNumber(ll_fila1,'co_reftel')
			
			IF ll_modelo <> ll_mod_min THEN
			
				SELECT count(*)
				  INTO :ll_count
				  FROM temp_modelos_ref
				 WHERE co_modelo 		= :ll_modelo AND
						 co_reftel 		= :ll_reftel AND
						 cs_ordenpd_pt = :ll_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :ll_color AND
						 po				= :ls_po AND
						 usuario 		= :ls_usuario;
				
				IF SQLCA.SQLCODE <> 0 THEN
					CLOSE(w_retroalimentacion)
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error', 'Se produjo un error al establecer la cantidad de modelos: ' + ls_error)
					Return ;
				END IF
				
				IF ll_count = 1 THEN					
					ll_unid = ll_valor/ll_count
				
					//ahorra debo actualizar esta cantidad para los demas registros de la misma talla-color-po
					UPDATE temp_modelos_ref
						SET unid_real_liberar = :ll_unid
					 WHERE cs_ordenpd_pt = :ll_ordenpd_pt AND
							 co_talla 		= :li_talla AND
							 co_color		= :ll_color AND
							 po				= :ls_po AND
							 usuario 		= :ls_usuario AND
							 co_modelo 		= :ll_modelo;  
					
					IF SQLCA.SQLCODE <> 0 THEN
						CLOSE(w_retroalimentacion)
						ls_error = Sqlca.SqlErrText
						Rollback;
						MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
						Return ;
					END IF
				ELSE
					//calcular unidades teniendo en cuenta ancho y tanda que tiene el modelo
					
				END IF
			END IF
		NEXT
NEXT

CLOSE(w_retroalimentacion)
destroy lds_ref 
destroy lds_ancho 


end subroutine

public function long of_borrartemporales (string as_usuario);String ls_error
Long ll_count

//****************************************** rollos *********************************************
ll_count = 0
SELECT count(*)
  INTO :ll_count
  FROM temp_tela_n
 WHERE usuario = :as_usuario;
 
IF ll_count > 0 THEN 
	DELETE FROM temp_tela_n
	WHERE usuario = :as_usuario;
	
	If sqlca.sqlcode = -1 Then
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar la temporal temp_tela_n, '+ ls_error)
		Return -1
	Else
		Commit;
	End if
END IF

//***************************************** telas ***********************************************
ll_count = 0
SELECT count(*)
  INTO :ll_count
  FROM temp_referen_n
 WHERE usuario = :as_usuario;
 
IF ll_count > 0 THEN 
	DELETE FROM temp_referen_n
	WHERE usuario = :as_usuario;
	
	If sqlca.sqlcode = -1 Then
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar la temporal temp_referen_n, '+ ls_error)
		Return -1
	Else
		Commit;
	End if
END If

//**************************************** modelos **********************************************
ll_count = 0
SELECT count(*)
  INTO :ll_count
  FROM temp_modelos_ref
 WHERE usuario = :as_usuario;
 
IF ll_count > 0 THEN 
	DELETE FROM temp_modelos_ref
	WHERE usuario = :as_usuario;
	
	If sqlca.sqlcode = -1 Then
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar la temporal temp_modelos_ref, '+ ls_error)
		Return -1
	Else
		Commit;	
	End if
END IF


ll_count = 0
SELECT count(*)
  INTO :ll_count
  FROM temp_op_agrupar
 WHERE usuario = :as_usuario;
 
IF ll_count > 0 THEN 
	DELETE FROM temp_op_agrupar
	WHERE usuario = :as_usuario;
	
	If sqlca.sqlcode = -1 Then
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar la temporal temp_op_agrupar, '+ ls_error)
		Return -1
	Else
		Commit;	
	End if
END If

Return 0


end function

public function long of_buscar_cons_error (string as_usuario);LONG	ll_cs_errores

SELECT MAX(cs_error) 
  INTO :ll_cs_errores
  FROM temp_log_errores
 WHERE usuario = :as_usuario ;
  
IF ll_cs_errores > 0 THEN
	ll_cs_errores = ll_cs_errores + 1
ELSE
	ll_cs_errores = 1
END IF
  
RETURN ll_cs_errores;
end function

protected function long of_calcular_kilos ();Long ll_reftel,ll_result
Long li_fila,li_caract,li_caractf
decimal{4} ld_grmt,ld_ancho,ld_kilos,ld_mt_bode
string ls_usuario	
datastore lds_modelos_ref

s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Calculando kilos..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)       

lds_modelos_ref= Create datastore
lds_modelos_ref.dataobject = 'ds_modelos_ref'
lds_modelos_ref.settransobject(sqlca)
ls_usuario = gstr_info_usuario.codigo_usuario

ll_result = lds_modelos_ref.retrieve(ls_usuario)
	
FOR li_fila=1 TO lds_modelos_ref.rowcount()  
	ll_reftel = lds_modelos_ref.getitemnumber(li_fila,"co_reftel")
	li_caract = lds_modelos_ref.getitemnumber(li_fila,"co_caract")
	ld_mt_bode = lds_modelos_ref.getitemnumber(li_fila,"mt_bodega")
	ld_ancho = lds_modelos_ref.getitemnumber(li_fila,"ancho")
	
	SELECT h_telas.gr_mt2_terminado,h_telas.co_caract_final  
	INTO :ld_grmt,:li_caractf  
	FROM h_telas  
	WHERE ( h_telas.co_reftel = :ll_reftel ) AND  
			( h_telas.co_caract = :li_caract ) ;
	
	IF li_caractf <=4 THEN
		ld_ancho = ld_ancho * 2
	END IF	
		 
	ld_kilos = (ld_mt_bode*(ld_ancho/100)*ld_grmt)/100
	
	lds_modelos_ref.setitem(li_fila,"kg_bodega",ld_kilos)
NEXT

IF lds_modelos_ref.update()=1 THEN
	commit;
ELSE
	MessageBox('Error', 'Se produjo error actualizando los Kgs de la Bodega')
	rollback;
END IF	
	
destroy lds_modelos_ref
CLOSE(w_retroalimentacion)
return 0
end function

public function long of_menorunds ();//esta funci$$HEX1$$f300$$ENDHEX$$n se va a utilizar para calcular el menor numero de unidades por modelo
//y luego actualizar los otros modelos con ese nro de unidades.

string ls_usuario,ls_error
Long ll_fila,ll_result,ll_unds_total,ll_fila2,ll_menor,ll_undstotal,ll_unidstalla,ll_filas,li_modelo,li_model
Long li_talla
decimal {4} ld_partic

datastore lds_temporal_trazo,lds_temporaltrazo_modelo

lds_temporaltrazo_modelo = CREATE datastore
lds_temporal_trazo       = CREATE datastore

lds_temporaltrazo_modelo.dataobject = 'ds_temporaltrazo_modelo'
lds_temporal_trazo.dataobject			= 'ds_temp_trazo'

lds_temporaltrazo_modelo.SetTransObject(sqlca)
lds_temporal_trazo.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

ll_result = lds_temporaltrazo_modelo.retrieve(ls_usuario)

FOR ll_fila = 1 TO ll_result 
	
   li_modelo     = lds_temporaltrazo_modelo.getitemnumber(ll_fila,'modelo')
	ll_unds_total = lds_temporaltrazo_modelo.getitemnumber(ll_fila,'total_unids') 	
	
	IF ll_result > 1 THEN
		FOR ll_fila2 = 2 TO ll_result
			
			ll_undstotal = lds_temporaltrazo_modelo.getitemnumber(ll_fila2,'total_unids') 
			
			IF ll_unds_total < ll_undstotal THEN
				ll_menor  = ll_unds_total
			ELSE
				ll_menor  = ll_undstotal
				li_modelo = lds_temporaltrazo_modelo.getitemnumber(ll_fila2,'modelo')
			END IF	
		NEXT	
		ll_fila = lds_temporaltrazo_modelo.rowcount() +1 
	END IF
NEXT

//ya tengo el menor nro de unidades de la temporal por modelo ahora
//recorro la temporal para actualizar las unidades con el menor numero de unidades
ll_filas = lds_temporal_trazo.retrieve()

FOR ll_fila = 1 TO ll_filas
	
	li_model  = lds_temporal_trazo.getitemnumber(ll_fila,'modelo')
	li_talla  = lds_temporal_trazo.getitemnumber(ll_fila,'co_talla')
	ld_partic = lds_temporal_trazo.getitemnumber(ll_fila,'participacion') 
	
	IF li_model <> li_modelo THEN
		
		ll_unidstalla = (ll_menor*ld_partic)
		
		IF ll_unidstalla = 0 THEN
			SELECT unidades
			  INTO :ll_unidstalla
			  FROM temporal_trazo
			 WHERE temporal_trazo.co_talla = :li_talla AND
					 temporal_trazo.modelo   = :li_modelo;
		END IF
		
		UPDATE 	temporal_trazo  
			SET   unidades = :ll_unidstalla
			WHERE temporal_trazo.co_talla = :li_talla AND
					temporal_trazo.modelo   = :li_model;
					
		IF SQLCA.SQLCODE <> 0 THEN
			ls_error=sqlca.sqlErrtext
			ROLLBACK;
			MessageBox('Error of_menorunds', 'Se produjo un error actualizando las unidades: ' + ls_error)
			RETURN -1;
		END IF		
	END IF	
	
NEXT

DESTROY lds_temporal_trazo
DESTROY lds_temporaltrazo_modelo

return 0
end function

public function long of_rectilineos (long ai_fabr, long al_lib, long ai_col, long al_model, long al_undstotal, long al_undslibera);Long ll_fila1,ll_result,ll_fila2,ll_fila,ll_unid_libera,ll_orden,ll_reftel,ll_rollo,&
     ll_refer,ll_cut,ll_count,ll_result1, ll_fin, ll_unidades, ll_unidades_libera, ll_color, ll_color_pt, ll_color_tela
decimal ld_unidades_total,ld_unds_pend,ld_unds_rollo,ldc_unds,ld_unidades_pend,ld_unid_insertar
int li_fab,li_caract,li_diametro,li_estadodisp,li_centroterm, li_marca,&
    li_fab_pt,li_linea,li_tono,li_fab_tela,li_talla
string ls_tono,ls_orden,ls_cut,ls_usuario,ls_instancia,ls_error
datastore lds_rollos_libera,lds_m_rollo, lds_temporal
datetime ldt_fecha
Decimal{5} ldc_participacion, ldc_consumo

n_cts_constantes luo_constantes

lds_rollos_libera = CREATE Datastore
lds_m_rollo 		= CREATE datastore
lds_temporal      = CREATE datastore

luo_constantes = CREATE n_cts_constantes

lds_rollos_libera.Dataobject  = 'ds_dt_rollos_libera_semiauto'
lds_m_rollo.dataobject 			= 'ds_m_rollo'
lds_temporal.dataobject			= 'ds_temporal_trazo_unidades'

lds_rollos_libera.settransobject(sqlca)
lds_m_rollo.settransobject(sqlca)
lds_temporal.settransobject(sqlca)

ls_usuario 		= gstr_info_usuario.codigo_usuario
ls_instancia 	= gstr_info_usuario.instancia
ldt_fecha 		= f_fecha_servidor()

li_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF li_estadodisp = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el estado de los rollos.')
	RETURN -1
END IF

li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
IF li_centroterm = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el centro de los rollos.')
	Return -1
END IF

//se trabaja con las unidades
IF  al_undstotal < al_undslibera THEN//buscar en bodega si hay tela
	ld_unds_pend = al_undslibera - al_undstotal 
	ll_result = lds_rollos_libera.retrieve(ai_fabr,al_lib,ai_col,al_model)
	
	//no hay rollos, se debe recalcular las unidades hacia abajo
	IF ll_result = 0 THEN
		//recorro la temporal por usuario, modelo
		ll_fin = lds_temporal.Retrieve(ls_usuario,al_model)
		
		FOR ll_fila1 = 1 TO ll_fin
			ldc_participacion = lds_temporal.GetItemNumber(ll_fila1,'participacion')
			ldc_consumo   = lds_temporal.GetItemNumber(ll_fila1,'consumo')
			li_talla      = lds_temporal.GetItemNumber(ll_fila1,'co_talla')
			ll_unidades = al_undslibera * ldc_participacion
			
			UPDATE temporal_trazo
			   SET unidades = :ll_unidades
			 WHERE usuario = :ls_usuario AND
			       modelo    = :al_model AND
					 co_talla  = :li_talla;
					 
			IF sqlca.sqlcode = -1 THEN
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error','No fue posible recalcular las unidades. '+ls_error)
				RETURN -1
			END IF
		NEXT
	END IF
	
	//se recorren las filas de dt_rollos_libera
	FOR ll_fila1 = 1 TO ll_result
		ls_orden 		= lds_rollos_libera.getitemstring(ll_fila1,'nu_orden')
		ls_cut 			= lds_rollos_libera.getitemstring(ll_fila1,'nu_cut')
		li_fab_pt		= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_pt')
		li_linea  		= lds_rollos_libera.getitemnumber(ll_fila1,'co_linea')
		ll_refer 		= lds_rollos_libera.getitemnumber(ll_fila1,'co_referencia')
		ll_color_pt 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_pt')
		ls_tono			= lds_rollos_libera.getitemstring(ll_fila1,'co_tono')
		li_fab_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_tela')
		ll_reftel		= lds_rollos_libera.getitemnumber(ll_fila1,'co_reftel')	
		li_caract		= lds_rollos_libera.getitemnumber(ll_fila1,'co_caract')
		li_diametro		= lds_rollos_libera.getitemnumber(ll_fila1,'diametro')
		ll_color_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_tela')
		
		ll_result1 = lds_m_rollo.retrieve(ls_orden,ai_fabr,ll_reftel,li_caract,li_diametro,ll_color_tela ,li_estadodisp,li_centroterm )
		
		IF ll_result1>0 THEN//hay rollos por liberar
			//se recorre m_rollo  
			FOR ll_fila2 =1 TO ll_result1
				ld_unds_rollo = lds_m_rollo.getitemnumber(ll_fila2,'ca_unidades')
				ll_rollo = lds_m_rollo.getitemnumber(ll_fila2,'cs_rollo')
				
				SELECT nvl(dt_consumo_rollos.ca_unidades,0)  
				INTO :ldc_unds 
				FROM dt_consumo_rollos  
				WHERE dt_consumo_rollos.cs_rollo = :ll_rollo;
						
				ld_unds_rollo -= ldc_unds
					
				//si el rollo tienen tela disponible se usa
				IF ld_unds_rollo > 0 THEN
					//cargamos dt_rollos_libera y dt_consumo_rollos, pero antes debemos averiguar cuantos metros
					//son los que necesitamos liberar para cumplir las unidades.
					IF ld_unidades_pend > ld_unds_rollo THEN
						//inserto el rollo en el campo metros con la variable ld_mts, actualizo los metros pendientes
						ld_unidades_pend =- ld_unds_rollo
						ld_unid_insertar = ld_unds_rollo
					ELSE
						//inserto el rollo en el campo metros con la variable ld_metros_pend, actualizo los metros pendientes
						ld_unid_insertar = ld_unidades_pend
						ld_unidades_pend = 0
						ll_fila2 = ll_result1 +1
						ll_fila = lds_rollos_libera.rowcount() +1
					END IF
					
					INSERT INTO dt_rollos_libera  
								( co_fabrica_exp,   
								  cs_liberacion,   
								  nu_orden,   
								  nu_cut,   
								  co_fabrica_pt,   
								  co_linea,   
								  co_referencia,   
								  co_color_pt,   
								  co_tono,   
								  co_modelo,   
								  co_fabrica_tela,   
								  co_reftel,   
								  co_caract,   
								  diametro,   
								  co_color_tela,   
								  cs_rollo,   
								  ca_metros,   
								  ca_unidades,   
								  usuario,   
								  instancia,   
								  fe_creacion,   
								  fe_actualizacion )  
					  VALUES (:ai_fabr,
								:al_lib,
								:ls_orden,   
								:ls_cut,   
								:li_fab_pt,   
								:li_linea,   
								:ll_refer,   
								:ll_color_pt,   
								:ls_tono,   			  
								:al_model,
								:li_fab_tela,  
								:ll_reftel,
								:li_caract,
								:li_diametro,
								:ll_color_tela,   
								:ll_rollo,
								0,   
								:ld_unid_insertar,   
								:ls_usuario, 
								:ls_instancia,
								:ldt_fecha,   
								:ldt_fecha)  ;
								
					IF sqlca.sqlcode <> 0 THEN
						ls_error = Sqlca.SqlErrText
						ROLLBACK;
						MessageBox('Error of_rect','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_rollos_libera' + ls_error)
						RETURN -1
					ELSE
						SElECT count(*)
						  INTO :ll_count
						  FROM dt_rollos_libera
						 WHERE cs_liberacion = :al_lib AND
								 cs_rollo = :ll_rollo AND
								 ca_metros = 0 AND
								 ca_unidades = 0;
								 
						IF ll_count = 1 THEN
							Rollback;
							MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
							Return -1
						END IF
					END IF	
						
					//actualizo el consumo del rollo
					SELECT count(*)
					  INTO :ll_count
					  FROM dt_consumo_rollos
					WHERE cs_rollo = :ll_rollo; 
					
					IF ll_count > 0 THEN
							//actualizo dt_consumo_rollos
							UPDATE dt_consumo_rollos
								SET ca_unidades = ca_unidades + :ld_unid_insertar,
									 fe_actualizacion = :ldt_fecha,
									 usuario = :ls_usuario,
									 instancia = :gstr_info_usuario.instancia
							 WHERE cs_rollo = :ll_rollo; 
							 
							 IF sqlca.sqlcode <> 0 THEN
								 ls_error = Sqlca.SqlErrText
								 ROLLBACK;
								 MessageBox('Error of_rect','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_consumo_rollos' + ls_error)
								 RETURN -1
							END IF
					ELSE
						//inserto en dt_consumo_rollos
							INSERT INTO dt_consumo_rollos  
						( cs_rollo,   
						  ca_metros,   
						  ca_unidades,   
						  fe_creacion,   
						  fe_actualizacion,   
						  usuario,   
						  instancia )  
							VALUES 
						( :ll_rollo,   
						  0,   
						  :ld_unid_insertar,   
						  :ldt_fecha,   
						  :ldt_fecha,   
						  :ls_usuario,   
						  :ls_instancia )  ;
			
						IF sqlca.sqlcode <> 0 THEN
							 ls_error = Sqlca.SqlErrText
							 ROLLBACK;
							 MessageBox('Error of_rect','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar las unidades de  los rollos'+ ls_error)
							 RETURN -1
						End if
					END IF//ll_count > 0
				END IF//ld_unds_rollo>0
			NEXT//FOR ll_fila2 =1 TO ll_result
		ELSE//NO HAY ROLLOS POR LIBERAR
		END IF
	NEXT//FIN DT_ROLLOS_LIBERA	
	//en este punto se debe preguntar por las unidades pendientes si estos son mayores a cero
	//es porque no se pudo traer de la bodega todos los metros necesarios, por lo tanto
	//es necesario recalcular las unidades que se pueden realizar con los metros que se colocaron
	//en la liberacion
	IF ld_unidades_pend > 0 THEN
		//traigo las unidades que pude cargar en la liberacion
		SELECT sum(dt_rollos_libera.ca_unidades ) 
		 INTO :ll_unidades_libera 
		 FROM dt_rollos_libera  
		WHERE dt_rollos_libera.co_fabrica_exp = :ai_fabr  AND  
				dt_rollos_libera.cs_liberacion = :al_lib  AND  
				dt_rollos_libera.co_color_pt = :ai_col  AND  
				dt_rollos_libera.co_modelo = :al_model  ;
				
		IF sqlca.sqlcode = -1 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','No fue posible establecer las unidades. '+ls_error)
			RETURN -1
		END IF	
		
		FOR ll_fila1 = 1 TO ll_fin
			ldc_participacion = lds_temporal.GetItemNumber(ll_fila1,'participacion')
			//ldc_consumo   = lds_temporal.GetItemNumber(ll_fila1,'consumo')
			li_talla      = lds_temporal.GetItemNumber(ll_fila1,'co_talla')
			ll_unidades = (ll_unidades_libera - ld_unidades_pend ) * ldc_participacion
			
			UPDATE temporal_trazo
			   SET unidades = :ll_unidades
			 WHERE usuario = :ls_usuario AND
			       modelo    = :al_model AND
					 co_talla  = :li_talla;
					 
			IF sqlca.sqlcode = -1 THEN
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error','No fue posible recalcular las unidades. '+ls_error)
				RETURN -1
			END IF
		NEXT
		
	END IF
ELSE//unds del trazo son menores a las unidades liberadas
	ld_unds_pend = al_undstotal  - al_undslibera
   of_unidades_devueltas(ai_fabr,al_lib,ai_col,al_model,ld_unds_pend)	
END IF
		
DESTROY lds_rollos_libera
DESTROY lds_m_rollo 

RETURN 0
end function

public function long of_unidades_devueltas (long ai_fabr, long al_lib, long ai_col, long al_model, long al_unds);LONG ll_fila1,ll_result,ll_orden,ll_unidades,ll_rollo, ll_count, ll_color_pt, ll_color_tela
INT li_fab_pt,li_linea,li_caract,li_diametro,li_fab,li_estadodisp,&
    li_centroterm,li_fab_tela,li_reftel,li_refer
STRING ls_orden,ls_cut,ls_tono,ls_error 
DECIMAL {4} ld_metros,ld_ca_unidades
datastore lds_rollos_libera

n_cts_constantes luo_constantes

lds_rollos_libera = CREATE Datastore
lds_rollos_libera.Dataobject = 'ds_dt_rollos_libera_semiauto'
lds_rollos_libera.settransobject(sqlca)

ll_result = lds_rollos_libera.retrieve(ai_fabr,al_lib,al_model)
	
//se recorren las filas de dt_rollos_libera
FOR ll_fila1 = 1 TO ll_result

	ls_orden 		= lds_rollos_libera.getitemstring(ll_fila1,'nu_orden')
	ls_cut 			= lds_rollos_libera.getitemstring(ll_fila1,'nu_cut')
	li_fab_pt		= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_pt')
	li_linea  		= lds_rollos_libera.getitemnumber(ll_fila1,'co_linea')
	li_refer 		= lds_rollos_libera.getitemnumber(ll_fila1,'co_referencia')
	ll_color_pt 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_pt')
	ls_tono			= lds_rollos_libera.getitemstring(ll_fila1,'co_tono')
	li_fab_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_tela')
	li_reftel		= lds_rollos_libera.getitemnumber(ll_fila1,'co_reftel')	
	li_caract		= lds_rollos_libera.getitemnumber(ll_fila1,'co_caract')
	li_diametro		= lds_rollos_libera.getitemnumber(ll_fila1,'diametro')
	ll_color_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_tela')
	ll_rollo			= lds_rollos_libera.getitemnumber(ll_fila1,'cs_rollo')
	ld_metros		= lds_rollos_libera.getitemnumber(ll_fila1,'ca_metros')
	ll_unidades		= lds_rollos_libera.getitemnumber(ll_fila1,'ca_unidades')

	if al_unds > ll_unidades then
		
		//eliminar el rollo de dt_rollos_libera
		DELETE FROM dt_rollos_libera  
		WHERE ( dt_rollos_libera.co_fabrica_exp 	= :ai_fabr ) AND  
				( dt_rollos_libera.cs_liberacion 	= :al_lib ) AND  
				( dt_rollos_libera.nu_orden 			= :ls_orden  ) AND  
				( dt_rollos_libera.nu_cut 				= :ls_cut ) AND  
				( dt_rollos_libera.co_fabrica_pt 	= :li_fab_pt) AND  
				( dt_rollos_libera.co_linea 			= :li_linea) AND  
				( dt_rollos_libera.co_referencia 	= :li_refer ) AND  
				( dt_rollos_libera.co_color_pt 		= :ll_color_pt ) AND  
				( dt_rollos_libera.co_tono 			= :ls_tono ) AND  
				( dt_rollos_libera.co_modelo 			= :al_model ) AND  
				( dt_rollos_libera.co_fabrica_tela 	= :li_fab_tela) AND  
				( dt_rollos_libera.co_reftel 			= :li_reftel) AND  
				( dt_rollos_libera.co_caract 			= :li_caract ) AND  
				( dt_rollos_libera.diametro 			= :li_diametro ) AND  
				( dt_rollos_libera.co_color_tela 	= :ll_color_tela ) AND  
				( dt_rollos_libera.cs_rollo 			= :ll_rollo );
			
			IF sqlca.sqlcode <> 0 THEN
				 ls_error = Sqlca.SqlErrText
				 ROLLBACK;
				 MessageBox('Error of_undsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar registro en dt_rollos_libera' + ls_error)
				 RETURN -1
			END IF
			
			//disminuir ll_unds en dt_consumo_rollo
			UPDATE dt_consumo_rollos  
		 	   SET ca_unidades = ca_unidades - :ll_unidades
			 WHERE dt_consumo_rollos.cs_rollo = :ll_rollo ;
				
			IF sqlca.sqlcode <> 0 THEN
				 ls_error = Sqlca.SqlErrText
				 ROLLBACK;
				 MessageBox('Error of_undsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_consumo_rollos' + ls_error)
				 RETURN -1
			END IF
			
			SELECT ca_unidades
			INTO :ld_ca_unidades
			FROM  dt_consumo_rollos 
			WHERE dt_consumo_rollos.cs_rollo = :ll_rollo;
			
			IF ld_ca_unidades<0 THEN
				UPDATE dt_consumo_rollos  
				SET    ca_unidades = 0
				WHERE dt_consumo_rollos.cs_rollo = :ll_rollo ;
				IF sqlca.sqlcode <> 0 THEN
					ls_error = Sqlca.SqlErrText
					ROLLBACK;
					MessageBox('Error of_mtsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los metros en dt_consumo_rollos' + ls_error)
					RETURN -1
				END IF
			END IF
		
			//se actualiza m_rollo. 
			  UPDATE m_rollo  
		        SET cs_ordencr = 0,
				  	   co_estado_rollo = 2  
			   WHERE m_rollo.cs_rollo = :ll_rollo;
	
			IF sqlca.sqlcode <> 0 THEN
				 ls_error = Sqlca.SqlErrText
				 ROLLBACK;
				 MessageBox('Error of_undsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado del rollo' + ls_error)
				 RETURN -1
			END IF
			
			al_unds -= ll_unidades
	ELSE	
		//actualizar unds de dt_rollos_libera
		UPDATE dt_rollos_libera  
		SET ca_unidades = ca_unidades - :al_unds
		WHERE ( dt_rollos_libera.co_fabrica_exp 	= :ai_fabr ) AND  
				( dt_rollos_libera.cs_liberacion 	= :al_lib ) AND  
				( dt_rollos_libera.nu_orden 			= :ls_orden  ) AND  
				( dt_rollos_libera.nu_cut 				= :ls_cut ) AND  
				( dt_rollos_libera.co_fabrica_pt 	= :li_fab_pt) AND  
				( dt_rollos_libera.co_linea 			= :li_linea) AND  
				( dt_rollos_libera.co_referencia 	= :li_refer ) AND  
				( dt_rollos_libera.co_color_pt 		= :ll_color_pt ) AND  
				( dt_rollos_libera.co_tono 			= :ls_tono ) AND  
				( dt_rollos_libera.co_modelo 			= :al_model ) AND  
				( dt_rollos_libera.co_fabrica_tela 	= :li_fab_tela) AND  
				( dt_rollos_libera.co_reftel 			= :li_reftel) AND  
				( dt_rollos_libera.co_caract 			= :li_caract ) AND  
				( dt_rollos_libera.diametro 			= :li_diametro ) AND  
				( dt_rollos_libera.co_color_tela 	= :ll_color_tela ) AND  
				( dt_rollos_libera.cs_rollo 			= :ll_rollo )  AND
				( dt_rollos_libera.ca_unidades      > :al_unds ) ;   //se adiciona esta linea para evitar que quede 0 unidades  jorodrig feb12
		
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			ROLLBACK;
			MessageBox('Error of_undsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_rollos_libera' + ls_error)
			RETURN -1
		ELSE
			SElECT count(*)
			  INTO :ll_count
			  FROM dt_rollos_libera
			 WHERE cs_liberacion = :al_lib AND
					 cs_rollo = :ll_rollo AND
					 ca_metros = 0 AND
					 ca_unidades = 0;
					 
			IF ll_count = 1 THEN
				Rollback;
				MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
				Return -1
			END IF
		END IF
		
		//disminuir las unds en dt_consumo_rollo
		 UPDATE  dt_consumo_rollos  
		 	 SET  ca_unidades = ca_unidades  - :al_unds
			WHERE dt_consumo_rollos.cs_rollo = :ll_rollo ;
			
		IF sqlca.sqlcode <> 0 THEN
			 ls_error = Sqlca.SqlErrText
			 ROLLBACK;
			 MessageBox('Error of_undsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_consumo_rollos' + ls_error)
			 RETURN -1
		END IF	
		
		ll_fila1 = lds_rollos_libera.rowcount()+1
	END IF
NEXT

DESTROY lds_rollos_libera
RETURN 0
end function

protected function long of_actualizar_dtliberaestilos (long ai_fabexp, long al_liber);////******actualizar unidades en dt_libera_estilos**************
//se actualiza un solo registro
string ls_error,ls_usuario
Long ll_totalunds_trazo 

ls_usuario = gstr_info_usuario.codigo_usuario

SELECT sum(unidades)
INTO  :ll_totalunds_trazo 
FROM  temporal_trazo
WHERE usuario = :ls_usuario; 

UPDATE dt_libera_estilos  
   SET ca_unidades =:ll_totalunds_trazo 
WHERE ( dt_libera_estilos.co_fabrica_exp   = :ai_fabexp ) AND  
		( dt_libera_estilos.cs_liberacion 	 = :al_liber ) ; 
		
IF sqlca.sqlcode <> 0 THEN
	ls_error = Sqlca.SqlErrText
	ROLLBACK;
	MessageBox('Error of_actunds','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_libera_estilos' + ls_error)
	RETURN -1
END IF

return 0
end function

public function long of_actualizar_dtpdnxmodulo (long ai_fabexp, long al_liber);////**********actulizar unidades en dt_pdnxmodulo*****************
////actualiza un solo registro
string ls_error,ls_usuario
Long ll_totalunds_trazo

ls_usuario = gstr_info_usuario.codigo_usuario

SELECT sum(unidades)
INTO :ll_totalunds_trazo
FROM temporal_trazo
where usuario = :ls_usuario;

UPDATE dt_pdnxmodulo  
	SET ca_programada =:ll_totalunds_trazo,
	  	 ca_pendiente  =:ll_totalunds_trazo
WHERE ( dt_pdnxmodulo.co_fabrica_exp = :ai_fabexp ) AND 
		( dt_pdnxmodulo.cs_liberacion  = :al_liber) ; 

IF sqlca.sqlcode <> 0 THEN
	ls_error = Sqlca.SqlErrText
	ROLLBACK;
	MessageBox('Error of_act_dtpdnxmodulo','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_pdnxmodulo' + ls_error)
	RETURN -1
END IF

return 0
end function

protected function long of_actualizarportalla (long ai_fabexp, long al_liber, long al_modelo);//////***actualizar unidades en dt_talla_pdnmodulo y en dt_escalasxtela****************
////se actualiza por talla-modelo	
string ls_error,ls_usuario
Long ll_unds,ll_filas,ll_fila
Long li_talla
datastore lds_temptrazo_tallamod

lds_temptrazo_tallamod = CREATE Datastore
lds_temptrazo_tallamod.Dataobject = 'ds_temptrazo_tallamod'
lds_temptrazo_tallamod.settransobject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario
ll_filas = lds_temptrazo_tallamod.retrieve(al_modelo,ls_usuario)

FOR ll_fila = 1 to ll_filas
	li_talla = lds_temptrazo_tallamod.getitemnumber(ll_fila,'co_talla')
	ll_unds  = lds_temptrazo_tallamod.getitemnumber(ll_fila,'unidades')
	
//*********************actualizar unidades en dt_talla_pdnmodulo*********************
//	UPDATE dt_talla_pdnmodulo  
//		SET ca_programada =:ll_unds,
//			 ca_pendiente  =:ll_unds
//	WHERE  (dt_talla_pdnmodulo.co_fabrica_exp  = :ai_fabexp ) AND 
//			( dt_talla_pdnmodulo.cs_liberacion   = :al_liber) AND  
//			( dt_talla_pdnmodulo.co_talla    	 = :li_talla ); 
	
//	IF sqlca.sqlcode <> 0 THEN
//		ls_error = Sqlca.SqlErrText
//		ROLLBACK;
//		MessageBox('Error of_actxtalla','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_talla_pdnmodulo' + ls_error)
//		RETURN -1
//	END IF

//	*********************actualizar unidades en dt_escalasxtela************************
	UPDATE dt_escalasxtela  
			SET  ca_unidades =:ll_unds
		WHERE ( dt_escalasxtela.co_fabrica_exp  = :ai_fabexp ) AND  
				( dt_escalasxtela.cs_liberacion 	 = :al_liber ) AND  
				( dt_escalasxtela.co_modelo       = :al_modelo )AND
				( dt_escalasxtela.co_talla   		 = :li_talla );
					
	IF sqlca.sqlcode <> 0 THEN
		ls_error = Sqlca.SqlErrText
		ROLLBACK;
		MessageBox('Error of_actxtalla','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades en dt_escalasxtela' + ls_error)
		RETURN -1
	END IF
NEXT

DESTROY lds_temptrazo_tallamod
return 0
end function

public function long of_validartandamodelo ();//metodo para validar la tanda en los modelos para el mismo color de tela
String ls_usuario, ls_descripcion, ls_error
Long ll_result, ll_fila, ll_ordenpd_pt_old, ll_ref_old, ll_modelo_old, ll_tanda_old, ll_fila2,&
	  ll_ordenpd_pt_new, ll_ref_new, ll_modelo_new, ll_tanda_new, ll_reftel_old, ll_found,&
	  ll_count1, ll_count2
Long ll_color_te_old, ll_color_te_new, ll_contador, ll_marca, ll_talla_old, ll_colorpt_old,&
        ll_colorpt_new, ll_borro, ll_tot_modelos_tanda, ll_tot_modelos_ficha, ll_fabrica, ll_linea,&
		  ll_bodysize, ll_result2, ll_result3, ll_fila3, ll_result4, ll_fila4
DataStore lds_tanda, lds_validar_tanda_x_talla, lds_contar_modelos_libera, lds_contar_telas_en_ficha,&
			 lds_contar_telas_en_ficha_no_compra

lds_tanda = Create DataStore
lds_tanda.DataObject = 'ds_validar_tanda'
lds_tanda.SetTransObject(sqlca)

lds_validar_tanda_x_talla = Create DataStore
lds_validar_tanda_x_talla.DataObject = 'ds_validar_tanda_x_talla'
lds_validar_tanda_x_talla.SetTransObject(sqlca)

lds_contar_modelos_libera = Create DataStore
lds_contar_modelos_libera.DataObject = 'ds_verificar_total_modelos'
lds_contar_modelos_libera.SetTransObject(sqlca)

lds_contar_telas_en_ficha = Create DataStore
lds_contar_telas_en_ficha.DataObject = 'ds_contar_telas_en_ficha'
lds_contar_telas_en_ficha.SetTransObject(sqlca)

lds_contar_telas_en_ficha_no_compra = Create DataStore
lds_contar_telas_en_ficha_no_compra.DataObject = 'ds_contar_telas_en_ficha_no_compra'
lds_contar_telas_en_ficha_no_compra.SetTransObject(sqlca)


//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, validando Tandas (5/6)..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

ls_usuario = gstr_info_usuario.codigo_usuario
//se hace el retrieve de temp_modelos_ref
ll_result = lds_tanda.Retrieve(ls_usuario)

If ll_result > 0 Then
	For ll_fila = 1 To ll_result
		ll_ordenpd_pt_old 	= lds_tanda.GetItemNumber(ll_fila,'cs_ordenpd_pt')
		ll_ref_old 				= lds_tanda.GetItemNumber(ll_fila,'co_referencia')
		ll_modelo_old 			= lds_tanda.GetItemNumber(ll_fila,'co_modelo')
		ll_tanda_old 			= lds_tanda.GetItemNumber(ll_fila,'cs_tanda')
		ll_color_te_old 		= lds_tanda.GetItemNumber(ll_fila,'co_color_te')
		ll_reftel_old			= lds_tanda.GetItemNumber(ll_fila,'co_reftel')
		ll_talla_old			= lds_tanda.GetItemNumber(ll_fila,'co_talla')
		ll_colorpt_old			= lds_tanda.GetItemNumber(ll_fila,'co_color')
		
		SELECT COUNT(*)
		  INTO :ll_bodysize
		  FROM h_ordenpd_te
		 WHERE cs_ordenpd_pt = :ll_ordenpd_pt_old
		   AND sw_bodysize = 1;
		IF ll_bodysize > 0 THEN
			ll_bodysize = 1
		ELSE
			ll_bodysize = 0
		END IF
		
			//verificar si el color es blanco o la tela es comprada, si es blanco  o comprada retorna 1 y no se valida tanda		
			//se comenta por peticion del usuario 5-10-17
//			IF of_buscar_tipo_tela_tono_col(ll_color_te_old,ll_ordenpd_pt_old,ll_reftel_old) = 1 THEN
//			ELSE
				ll_result2 = lds_validar_tanda_x_talla.Retrieve(ls_usuario,ll_ordenpd_pt_old,ll_talla_old)
				ll_borro = 0
				For ll_fila2 = 1 To ll_result2
					ll_ordenpd_pt_new = lds_validar_tanda_x_talla.GetItemNumber(ll_fila2,'cs_ordenpd_pt')
					ll_ref_new 			= lds_validar_tanda_x_talla.GetItemNUmber(ll_fila2,'co_referencia')
					ll_colorpt_new		= lds_validar_tanda_x_talla.GetItemNumber(ll_fila2,'co_color')
							
					IF ll_ordenpd_pt_new = ll_ordenpd_pt_old And ll_ref_new = ll_ref_old And ll_colorpt_new = ll_colorpt_old Then
						//si la op, referencia y color son los mismos continuo verificando la tanda,
						//si no es porque puede tener otra tanda y no debo validar con la tanda_old
						ll_modelo_new = lds_validar_tanda_x_talla.GetItemNumber(ll_fila2,'co_modelo')
							ll_color_te_new = lds_validar_tanda_x_talla.GetItemNumber(ll_fila2,'co_color_te')
							If ll_color_te_new = ll_color_te_old Then
								//debe ser la misma tanda
								ll_tanda_new = lds_validar_tanda_x_talla.GetItemNumber(ll_fila2,'cs_tanda')
								
						//		IF (ll_tanda_new <> ll_tanda_old) OR (ll_modelo_new <> ll_modelo_old) Then
									//validar que tenga tela para todos los modelos en  la tanda
								
									//Miramos si es bodysize para contar cuantas telas tiene creadas por talla
									//se cambia la tabla porque en temp_tela_n no esta la talla
									IF ll_bodysize = 1 THEN
										SELECT COUNT(Distinct co_reftel)
										  INTO :ll_tot_modelos_tanda
										  FROM temp_modelos_ref
										 WHERE usuario = :ls_usuario
											AND cs_ordenpd_pt = :ll_ordenpd_pt_new
											AND cs_tanda = :ll_tanda_old
											AND co_talla = :ll_talla_old
											AND co_color_te = :ll_color_te_new;
											
									ELSE

										SELECT COUNT(Distinct t.co_reftel)
										  INTO :ll_tot_modelos_tanda
										  FROM temp_tela_n t, h_telas h, m_tiptel
										 WHERE t.usuario 			= :ls_usuario
											AND t.cs_ordenpd_pt 	= :ll_ordenpd_pt_new
											AND t.cs_tanda      	= :ll_tanda_old
											AND t.co_color      	= :ll_color_te_new
											and t.co_reftel 		= h.co_reftel
											AND t.co_caract 		= h.co_caract
											AND h.co_tiptel 		= m_tiptel.co_tiptel
											AND m_tiptel.co_clase <> 10;
																		
									END IF
									//se compara el resultado del count anterior contra el count de la ficha
									//si son iguales hay tela para todos los modelos, sino se borra la tanda
									
									SELECT DISTINCT co_fabrica, co_linea
										  INTO :ll_fabrica, :ll_linea
										  FROM temp_modelos_ref
										 WHERE co_referencia = :ll_ref_old
											AND co_color 		= :ll_colorpt_old
											AND co_talla 		= :ll_talla_old	 
											AND cs_tanda 		= :ll_tanda_old;
									
									ll_tot_modelos_ficha = lds_contar_telas_en_ficha.Retrieve(ll_fabrica,ll_linea,ll_ref_old,ll_colorpt_old,ll_color_te_old,ll_talla_old)

									IF ll_tot_modelos_tanda <> ll_tot_modelos_ficha THEN  //se hace una nueva verificacion pero ya con la tabla temp_modelos, por caso de ref con varios modelos en la misma tela mismo color
										ll_tot_modelos_tanda = lds_contar_modelos_libera.Retrieve(ls_usuario,ll_ordenpd_pt_new,ll_tanda_old,ll_color_te_new)

								      IF ll_tot_modelos_tanda < ll_tot_modelos_ficha THEN 
											
										//Tambien vamos a mirar si uno de los modelos es una entretela o hiladilla, en la cual no es
										//necesario que este en la misma tanda asi sea el mismo color de tela,  validacion cambiada el 6/6/06 solicta bmedina en reunion grupo primario
											ll_tot_modelos_ficha = lds_contar_telas_en_ficha_no_compra.Retrieve(ll_fabrica,ll_linea,ll_ref_old,ll_colorpt_old,ll_color_te_old,ll_talla_old)
									      IF ll_tot_modelos_tanda < ll_tot_modelos_ficha THEN 
												If ll_bodysize = 1 Then
													//es body size se debe borrar la talla y color
													DELETE FROM temp_modelos_ref
													WHERE cs_ordenpd_pt = :ll_ordenpd_pt_old AND
															co_referencia = :ll_ref_old AND
															co_color_te   = :ll_color_te_old AND
															co_talla		  = :ll_talla_old AND
															usuario		  = :ls_usuario AND
															cs_tanda 	  = :ll_tanda_old;
												Else
													DELETE FROM temp_modelos_ref
													WHERE cs_ordenpd_pt = :ll_ordenpd_pt_old AND
															co_referencia = :ll_ref_old AND
															co_color_te   = :ll_color_te_old AND
															usuario		  = :ls_usuario AND
															cs_tanda		  = :ll_tanda_old;
												End if
												IF SQLCA.SQLCODE = -1 THEN
													ls_error = SQLCA.SQLERRTEXT
													ROLLBACK;
													MessageBox('Error','Se produjo un error borrando las tandas incompletas ' + ls_error)
													return -1
												END IF
												ll_borro = 1
												ll_fila2 = ll_result2 + 1
											END If
										End if
										
									END IF
								
							Else
								//no se debe validar la tanda ya que son diferentes colores
							End if
					 //End if
					Else
						//ll_fila2 = ll_result +1    //jorodrig quita por ops que tiene varios colores
					End if
				Next
			//END IF //IF of_buscar_tipo_tela_tono_col
			IF ll_borro = 1 THEN   //se borro algo por problemas, se inserta en el log
				//se carga al log de errores
				ls_descripcion = ' En la prenda: ' + string(ll_ref_old) + ' Color: ' + string(ll_colorpt_old) + ' En la Tela: ' + string(ll_reftel_old) +' color tela: ' +&
									  string(ll_color_te_old) +  ' Modelo: ' + string(ll_modelo_old) + ' Las telas del mismo color no tienen la misma tanda, tanda1: '	+ string(ll_tanda_new) +&
									  ' tanda2: '+string(ll_tanda_old)
				of_cargar_log_problemas(ls_descripcion,ll_ordenpd_pt_old,'',ll_ref_old,ll_colorpt_old,ll_reftel_old,0,0,ll_color_te_old,11)
			END IF
		//END IF

	Next
End if
Commit;
Close(w_retroalimentacion)     
destroy lds_tanda 	
Return 0
end function

public function long of_verificacionlinea (long ai_fab, long ai_lin, long al_ref);//metodo para determinar si una referencia  es de linea
//jcrm
//enero 30 de 2008
String ls_linea

SELECT id_linea
  INTO :ls_linea
  FROM h_preref_pv
 WHERE co_fabrica 	= :ai_fab AND
 		 co_linea		= :ai_lin AND
	    (Cast(:al_ref as char(15) ) = h_preref_pv.co_referencia ) and
		 co_tipo_ref = 'P'
		 ;
		 
IF sqlca.SqlCode = -1 THEN
	Return -1
END IF
		 
IF ls_linea = 'L' THEN
	Return 0 //referencia de linea
ELSE
	Return 100 //referencia diferente de linea
END IF
		 
end function

public function long of_cambiartandarollo (long al_rollo, string as_tono, ref string as_mensaje);//funcion para modificar el dato de tanda del rollo y este colocarlo el campo lote
//tanda A = cs_tanda = 10
//tanda B = cs_tanda = 20
//tanda C = cs_tanda = 30
//jcrm
//febrero 25 de 2008
Long li_tanda

If Trim(as_tono) = 'A' Then
	li_tanda = 10
ElseIf Trim(as_tono) = 'B' Then
	li_tanda = 20
ElseIf Trim(as_tono) = 'C' Then
	li_tanda = 30
End if

IF Trim(as_tono) <> 'A' AND Trim(as_tono) <> 'B' AND Trim(as_tono) <> 'C' THEN 
	
ELSE
	UPDATE temp_tela_n
		SET cs_tanda = :li_tanda
	 WHERE cs_rollo = :al_rollo and
			 usuario  = :gstr_info_usuario.codigo_usuario;
	
	If sqlca.sqlcode = -1 Then
		as_mensaje = sqlca.sqlerrtext
		Return -1
	End if
END IF
Return 0 
end function

public function long of_cargartemprollos (long ai_fab, long ai_lin, long al_ref, long al_op, string as_po, long al_color);Long li_estadodisp, li_centroterm, li_estadopd, li_caract, li_diametro, li_talla,&
		  li_estado_final, li_marca, li_tipo_tela, li_existe, li_inserto, li_result
Long ll_fila, ll_result, ll_cs_rollo, ll_cs_ordenpd, ll_reftel, ll_unidades,&
     ll_unid_consu, ll_tanda, ll_lote, ll_color
String ls_tono, ls_usuario, ls_descripcion, ls_error, ls_mensaje
Decimal{3} ldc_ancho,  ldc_kg
DECIMAL{2}	ldc_mt, ldc_metros_consu
DataStore lds_telaexp, lds_telanal
n_cts_constantes luo_constantes
n_cts_liberacion_x_proyeccion luo_proyeccion

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando la Tela Disponible (1/6)..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                                 

luo_constantes = Create n_cts_constantes

li_inserto = 0
ls_usuario = gstr_info_usuario.codigo_usuario
//el criterio de seleccion puede ser tanto para exportacion como para nacional
//por lo tanto se crean dos datastore para manejar cada uno de las posibilidades

lds_telaexp = Create DataStore
lds_telanal = Create DataStore

lds_telaexp.DataObject = 'ds_telaexp'
lds_telanal.DataObject = 'ds_telanal'

lds_telaexp.SetTransObject(sqlca)
lds_telanal.SetTransObject(sqlca)

li_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF li_estadodisp = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el estado de los rollos.')
	Return -1
END IF

//se modifica el centro de tela terminado a 15 si la fabrica es MARINILLA o 21 si es PEREIRA
//jcrm
//mayo 27 de 2007
IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
	IF li_centroterm = -1 THEN
		CLOSE(w_retroalimentacion)
		MessageBox('Error','No fue posible establecer el centro de los rollos para Marinilla.')
		Return -1
	END IF
END IF

IF gstr_info_usuario.co_planta_pro = 99 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA PEREIRA")
	IF li_centroterm = -1 THEN
		CLOSE(w_retroalimentacion)
		MessageBox('Error','No fue posible establecer el centro de los rollos para Pereira.')
		Return -1
	END IF
END IF

li_estadopd = luo_constantes.of_consultar_numerico("ESTADO ORDENPD")
IF li_estadopd = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el estado de la orden de producci$$HEX1$$f300$$ENDHEX$$n.')
	Return -1
END IF

//primero debemos recuperar los datos de exportacion
ll_result = lds_telaexp.Retrieve(ai_fab,ai_lin,al_ref,al_op,as_po,al_color,li_estadodisp,li_centroterm,li_estadopd)
//se recorre el datastore para extraer los datos que llenaran la temporal de las telas
IF ll_result > 0 THEN
   //hay datos en exportacion
	FOR ll_fila = 1 To ll_result
		ll_cs_rollo 		= lds_telaexp.GetItemNumber(ll_fila,'cs_rollo')
		ll_cs_ordenpd 		= lds_telaexp.GetItemNumber(ll_fila,'cs_ordenpd_pt')
		ll_reftel 			= lds_telaexp.GetItemNumber(ll_fila,'co_reftel')
      li_caract 			= lds_telaexp.GetItemNumber(ll_fila,'co_caract')
		li_diametro 		= lds_telaexp.GetItemNumber(ll_fila,'diametro')
		ll_color 			= lds_telaexp.GetItemNumber(ll_fila,'co_color')
		li_talla 			= lds_telaexp.GetItemNumber(ll_fila,'co_talla')
		ls_tono 				= lds_telaexp.GetItemString(ll_fila,'co_tono')
		ldc_ancho 			= lds_telaexp.GetItemNumber(ll_fila,'ancho_tub_term')
		ldc_mt 				= lds_telaexp.GetItemNumber(ll_fila,'ca_mt')
		ldc_kg 				= lds_telaexp.GetItemNumber(ll_fila,'ca_kg')
		ll_unidades 		= lds_telaexp.GetItemNumber(ll_fila,'ca_unidades')
		li_estado_final 	= lds_telaexp.GetItemNumber(ll_fila,'co_caract_final')
		li_marca 			= lds_telaexp.GetItemNumber(ll_fila,'sw_bodysize')
		ll_tanda				= lds_telaexp.GetItemNumber(ll_fila,'cs_tanda')
		ll_lote				= lds_telaexp.GetItemNumber(ll_fila,'lote')
		//ls_tono 				= 'A'
				
		//**********************************************************************
		//metodo para determinar si un rollo tiene metros o unidades reservadas
		//en dt_consumo_rollo, retorna
		//-1 si sucede un error
		//0 si el rollo no esta siendo utilizado en ninguna liberacion
		//2 el rollo esta siendo utilizado en una liberacion
		//jcrm
		//abril 2 de 2008
		li_result = luo_proyeccion.of_verificarconsumo(ll_cs_rollo, ls_mensaje,al_op)	
		
		IF li_result = -1 THEN
			Rollback;
			MessageBox('Error','Al momento de veririficar si el rollo esta disponible, ERROR: '+ls_mensaje, StopSign!)
			Return -1
		END IF
		
		IF li_result = 2 THEN
			CONTINUE
		END IF
		//**********************************************************************
				
		If isnull(ll_tanda) or ll_tanda <= 1 Then
			ls_descripcion = 'La tanda del rollo: '+String(ll_cs_rollo)+' no es correcta o es nula. '
			of_cargar_log_problemas(ls_descripcion,al_op,as_po,al_ref,al_color,0,0,0,0,1)
		End if
				
		If isnull(ldc_ancho) Then ldc_ancho = 0
		
		li_tipo_tela = of_rectilineo(ll_reftel,li_caract)
		IF li_tipo_tela = 3 THEN  //son rectilineos
			li_marca = 3   //marca 3 son rectilineos
		ELSE
			li_talla = 9999    //es tela se crea talla generica
			If isnull(ldc_ancho) or ldc_ancho = 0 Then
				ls_descripcion = 'El rollo: '+String(ll_cs_rollo)+' no tiene ancho o esta en nulo. '
				of_cargar_log_problemas(ls_descripcion,al_op,as_po,al_ref,al_color,0,0,0,0,1)
			End if
			
		END IF
		
		ldc_metros_consu = 0
		ll_unid_consu = 0
		//averiguo el total a cargar del rollo
		SELECT nvl(ca_metros,0), nvl(ca_unidades,0)
		  INTO :ldc_metros_consu, :ll_unid_consu
		  FROM dt_consumo_rollos
		 WHERE cs_rollo = :ll_cs_rollo;
		 
		 IF ISNULL(ldc_metros_consu) THEN ldc_metros_consu = 0
		 IF ISNULL(ll_unid_consu) THEN ll_unid_consu = 0
		 ldc_mt -= ldc_metros_consu
		 ll_unidades -= ll_unid_consu
		 
		 IF ldc_mt > 0.1 Or ll_unidades > 0 THEN
		 		li_inserto = 1
				//inserto en la temporal de telas
				 INSERT INTO temp_tela_n  
					( usuario,   
					  cs_rollo,   
					  cs_ordenpd_pt,   
					  co_reftel,   
					  co_caract,   
					  co_color,   
					  co_talla,   
					  co_tono,   
					  ancho,   
					  diametro,   
					  ca_mt,   
					  ca_kg,   
					  sw_marca,   
					  estado_final,   
					  ca_unidades,
					  ancho_agrupa,
					  cs_tanda,
					  lote)  
		  VALUES ( :ls_usuario,   
					  :ll_cs_rollo,   
					  :ll_cs_ordenpd,   
					  :ll_reftel,   
					  :li_caract,   
					  :ll_color,   
					  :li_talla,   
					  :ls_tono,   
					  :ldc_ancho,   
					  :li_diametro,   
					  :ldc_mt,   
					  :ldc_kg,   
					  :li_marca,   
					  :li_estado_final,   
					  :ll_unidades,
				     :ldc_ancho,
					  :ll_tanda,
					  :ll_lote)  ;
  			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.SqlErrText
				Rollback;
				CLOSE(w_retroalimentacion)
				MessageBox('Error', 'Se produjo error insertando datos de tela en bodega: '+ls_error )
				Return -1;
			ELSE
				//se modifica la tanda para colocar el valor del tono esto se pidio en el sue$$HEX1$$f100$$ENDHEX$$o de tela
				//jcrm
				//mayo 19 de 2008
				IF of_cambiartandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 THEN
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de modificar de tanda a tono para liberar, ERROR: '+ls_mensaje,StopSign!)
					Return -1
				END IF
			END IF
		END IF
				
	NEXt
ELSE
	//primero se valida que no sean invalidos todos los criterios
	if ai_fab = 0 and ai_lin = 0 and al_ref = 0 and	al_op = 0 and al_color = 0 Then
		CLOSE(w_retroalimentacion)
		MessageBox('Error','El criterio no es valido, intente nuevamente.')
		Return -1
	End if
	
	//se trata de datos de nacional, por lo tanto recuperamos los datos de nacional
	ll_result = lds_telanal.Retrieve(ai_fab,ai_lin,al_ref,al_op,al_color,li_estadodisp,li_centroterm,li_estadopd)
	IF ll_result > 0 THEN
		FOR ll_fila = 1 To ll_result
			ll_cs_rollo 		= lds_telanal.GetItemNumber(ll_fila,'cs_rollo')
			ll_cs_ordenpd 		= lds_telanal.GetItemNumber(ll_fila,'cs_ordenpd_pt')
			ll_reftel 			= lds_telanal.GetItemNumber(ll_fila,'co_reftel')
			li_caract 			= lds_telanal.GetItemNumber(ll_fila,'caract')
			li_diametro 		= lds_telanal.GetItemNumber(ll_fila,'diametro')
			ll_color 			= lds_telanal.GetItemNumber(ll_fila,'co_color')
			li_talla 			= lds_telanal.GetItemNumber(ll_fila,'co_talla')
			ls_tono 				= lds_telanal.GetItemString(ll_fila,'co_tono')
			ldc_ancho 			= lds_telanal.GetItemNumber(ll_fila,'ancho_tub_term')
			ldc_mt 				= lds_telanal.GetItemNumber(ll_fila,'ca_mt')
			ldc_kg 				= lds_telanal.GetItemNumber(ll_fila,'ca_kg')
			ll_unidades 		= lds_telanal.GetItemNumber(ll_fila,'ca_unidades')
			li_estado_final 	= lds_telanal.GetItemNumber(ll_fila,'co_caract_final')
			li_marca 			= lds_telanal.GetItemNumber(ll_fila,'sw_bodysize')
			ll_tanda				= lds_telanal.GetItemNumber(ll_fila,'cs_tanda')
				
			//**********************************************************************
			//metodo para determinar si un rollo tiene metros o unidades reservadas
			//en dt_consumo_rollo, retorna
			//-1 si sucede un error
			//0 si el rollo no esta siendo utilizado en ninguna liberacion
			//2 el rollo esta siendo utilizado en una liberacion
			//jcrm
			//abril 2 de 2008
			li_result = luo_proyeccion.of_verificarconsumo(ll_cs_rollo, ls_mensaje,al_op)	
			
			IF li_result = -1 THEN
				Rollback;
				MessageBox('Error','Al momento de veririficar si el rollo esta disponible, ERROR: '+ls_mensaje, StopSign!)
				Return -1
			END IF
			
			IF li_result = 2 THEN
				CONTINUE
			END IF
			//**********************************************************************	
			If isnull(ll_tanda) or ll_tanda <= 1 Then
				ls_descripcion = 'La tanda del rollo: '+String(ll_cs_rollo)+' no es correcta o es nula. '
				of_cargar_log_problemas(ls_descripcion,al_op,as_po,al_ref,al_color,0,0,0,0,1)
			End if	
				
			If isnull(ldc_ancho) Then ldc_ancho = 0
			
			IF ll_unidades > 0 THEN
				//son rectilineos, se debe cargar la talla que tiene el rollo
			ELSE
				li_talla = 9999   //tala generica para cuando es tela y no rectilienos
				If isnull(ldc_ancho) or ldc_ancho = 0 Then
					ls_descripcion = 'El rollo: '+String(ll_cs_rollo)+' no tiene ancho o esta en nulo. '
					of_cargar_log_problemas(ls_descripcion,al_op,as_po,al_ref,al_color,0,0,0,0,1)
				End if
    		END IF

			ldc_metros_consu = 0
			ll_unid_consu = 0

			//averiguo el total a cargar del rollo
			SELECT nvl(ca_metros,0), nvl(ca_unidades,0)
			  INTO :ldc_metros_consu, :ll_unid_consu
			  FROM dt_consumo_rollos
			 WHERE cs_rollo = :ll_cs_rollo;
		 IF ISNULL(ldc_metros_consu) THEN ldc_metros_consu = 0
		 IF ISNULL(ll_unid_consu) THEN ll_unid_consu = 0
			 
			 ldc_mt -= ldc_metros_consu
			 ll_unidades -= ll_unid_consu
		IF ldc_mt > 0.1 Or ll_unidades > 0 THEN	 
			li_inserto = 1
			//inserto en la temporal de telas
		 INSERT INTO temp_tela_n  
         ( usuario,   
           cs_rollo,   
           cs_ordenpd_pt,   
           co_reftel,   
           co_caract,   
           co_color,   
           co_talla,   
           co_tono,   
           ancho,   
           diametro,   
           ca_mt,   
           ca_kg,   
           sw_marca,   
           estado_final,   
           ca_unidades,
			  ancho_agrupa,
			  cs_tanda	)  
  VALUES ( :ls_usuario,   
           :ll_cs_rollo,   
           :ll_cs_ordenpd,   
           :ll_reftel,   
           :li_caract,   
           :ll_color,   
           :li_talla,   
           :ls_tono,   
           :ldc_ancho,   
           :li_diametro,   
           :ldc_mt,   
           :ldc_kg,   
           :li_marca,   
           :li_estado_final,   
           :ll_unidades,
			  :ldc_ancho,
			  :ll_tanda	);
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.SqlErrText
				Rollback;
				CLOSE(w_retroalimentacion)
				MessageBox('Error', 'Se produjo error insertando datos de tela en bodega: ' + +ls_error)
				Return -1;
			ELSE
				//se modifica la tanda para colocar el valor del tono esto se pidio en el sue$$HEX1$$f100$$ENDHEX$$o de tela
				//jcrm
				//mayo 19 de 2008
				IF of_cambiartandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 THEN
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de modificar de tanda a tono para liberar, ERROR: '+ls_mensaje,StopSign!)
					Return -1
				END IF
			END IF
		END IF
		NEXT
	END IF
END IF

IF (ll_result = 0) OR (li_inserto = 0) THEN
	//No se encontr$$HEX2$$f3002000$$ENDHEX$$tela, se verifican unos datos para cargarlos al log de problemas
	ls_descripcion = 'No encontro tela en bodega. '
	of_cargar_log_problemas(ls_descripcion,al_op,as_po,al_ref,al_color,0,0,0,0,1)
END IF

COMMIT;

Destroy lds_telaexp 
Destroy lds_telanal
CLOSE(w_retroalimentacion)

IF ll_result = 0 THEN
	//MessageBox('Advertencia','No se encontro Tela, se aborta el proceso, revise el log de problemas')
	open(w_log_errores_liberacion)
	Return -1
ELSE
	Return 0
END IF
end function

protected function long of_cargar_log_problemas (string as_descripcion, long al_orden_prod, string as_po, long al_referencia, long al_color, long al_reftel, long ai_caract, long ai_diametro, long al_color_te, long ai_cod_verif);Long	li_existe, li_centroterm, li_estadodisp, li_estadopd
Long	li_existe1, li_existe2, li_existe3,	li_inserto 
LONG		ll_consecutivo
STRING	as_descripcion_detalle, ls_usuario
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes


return 1

li_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF li_estadodisp = -1 THEN
	MessageBox('Error','No fue posible establecer el estado de los rollos.')
	Return -1
END IF
//se modifica el centro de tela terminado a 15 si la fabrica es MARINILLA o 21 si es PEREIRA
//jcrm
//mayo 16 de 2007
IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
	IF li_centroterm = -1 THEN
		CLOSE(w_retroalimentacion)
		MessageBox('Error','No fue posible establecer el centro de los rollos para Marinilla.')
		Return -1
	END IF
END IF

IF gstr_info_usuario.co_planta_pro = 99 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA PEREIRA")
	IF li_centroterm = -1 THEN
		CLOSE(w_retroalimentacion)
		MessageBox('Error','No fue posible establecer el centro de los rollos para Pereira.')
		Return -1
	END IF
END IF

li_estadopd = luo_constantes.of_consultar_numerico("ESTADO ORDENPD")
IF li_estadopd = -1 THEN
	MessageBox('Error','No fue posible establecer el estado de la orden de producci$$HEX1$$f300$$ENDHEX$$n.')
	Return -1
END IF

ls_usuario = gstr_info_usuario.codigo_usuario
li_inserto = 0

CHOOSE CASE ai_cod_verif
	CASE 1,3  //problemas con la busqueda de telas que tiene la op
		//Verifico si las telas tienen creado la tanda
		as_descripcion_detalle = ''
		as_descripcion = ''

		SELECT COUNT(*)
		  INTO :li_existe
		  FROM m_rollo
		 WHERE cs_orden_pr_act = :al_orden_prod
			AND co_centro = :li_centroterm
			AND co_estado_rollo = :li_estadodisp
			AND cs_tanda is null
			AND cs_orden_pr_act > 0;
		IF li_existe > 0 THEN
			as_descripcion_detalle = 'Las tandas estan en Nulo'
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF
		
		as_descripcion_detalle = ''
		as_descripcion = ''
		//Verificar que las telas en la op esten activas
		SELECT COUNT(*)
		  INTO :li_existe
		  FROM h_ordenpd_te
		 WHERE  cs_ordenpd_pt = :al_orden_prod
		   AND co_estado_orden in (2,5,10)
			AND cs_ordenpd_pt > 0;
		IF li_existe > 0 THEN
			as_descripcion_detalle = 'En la Ord.Pdn hay tela con estado diferente a anulado completa o inactiva'
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF
		
		as_descripcion_detalle = ''
		as_descripcion = ''
		//Verificar que la op este activa
		SELECT COUNT(*)
		  INTO :li_existe
		  FROM h_ordenpd_pt
		 WHERE  cs_ordenpd_pt = :al_orden_prod
		   AND co_estado_orden <> :li_estadopd
			AND cs_ordenpd_pt > 0;
		IF li_existe > 0 THEN
			as_descripcion_detalle = 'La Ord.Pdn tiene el estado diferente a activo'
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF
		
		as_descripcion_detalle = ''
		as_descripcion = ''
		//Verificar que hay tela en bodega
		SELECT COUNT(*)
		  INTO :li_existe
		  FROM m_rollo
		 WHERE cs_orden_pr_act = :al_orden_prod
			AND co_centro = :li_centroterm
			AND co_estado_rollo = :li_estadodisp
			AND cs_orden_pr_act > 0;
		IF li_existe = 0 THEN
			as_descripcion_detalle = ' No hay tela en bodega con este numero de OP, en centro terminado, disponible'
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF
		
		as_descripcion_detalle = ''
		as_descripcion = ''
		//Verificar que no sea una op agrupada
		SELECT COUNT(*)
		  INTO :li_existe
		  FROM h_ordenpd_pt
		 WHERE cs_ordenpd_pt = :al_orden_prod
			AND co_tipo_orden = 2
			AND cs_ordenpd_pt > 0;   //es una op agrupada
		IF li_existe > 0 THEN
			as_descripcion_detalle = ' La O.P. que esta tratando de liberar es una Agrupada'
			as_descripcion = as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF

		as_descripcion_detalle = ''
		as_descripcion = ''
		//verificar si hay rollos marcados como sobrantes
		SELECT count(*)
		  INTO :li_existe
		  FROM m_rollo, m_cpto_bodega
		 WHERE m_rollo.co_planeador = m_cpto_bodega.co_cpto_bodega
		   AND m_cpto_bodega.tipo = 1  //este tipo es sobrantes
			AND cs_orden_pr_act = :al_orden_prod
			AND co_centro = :li_centroterm
			AND co_estado_rollo = :li_estadodisp
			AND cs_orden_pr_act > 0;
		IF li_existe > 0 THEN
			as_descripcion_detalle = ' La OP tiene tela en bodega marcada como sobrante'
			as_descripcion = as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF
		
	
		IF li_inserto =  0 THEN
			as_descripcion_detalle = ' La OP No tiene tela en bodega '
			as_descripcion = as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
			li_inserto = 1
		END IF
	CASE 2 //problemas con la busqueda de Prendas, colores y tallas
		   as_descripcion_detalle = ''
			as_descripcion = ''
			as_descripcion_detalle = ' No  se encontro colores y tallas para liberar, revise la Ord. Pdn que tenga los datos de colores'
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE	3
		as_descripcion_detalle = ''
		as_descripcion = ''
		//Una de las telas que tiene la ficha no esta en temp_Tela, revisamos como esta en temp_tela para decirle al usuario
		SELECT count(*)
		  INTO :li_existe1
		  FROM temp_tela_n
		 WHERE cs_ordenpd_pt = :al_orden_prod AND
		       co_reftel 		= :al_reftel AND
				 co_caract 		= :ai_caract AND
				 co_color 		= :al_color_te AND
				 diametro 		<> :ai_diametro AND
				 usuario			= :ls_usuario;
		IF li_existe1 > 0 THEN
			as_descripcion_detalle = 'La prenda: ' + string(al_referencia) + ' Color: ' + string(al_color) + ' En la Tela: ' + string(al_reftel) +' color tela: ' +&
			                         string(al_color_te) + ' Caract: ' + string(ai_caract) + ' tiene un diametro en rollos diferente al que pide la ficha: ' + string(ai_diametro)				
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
		END IF
		
		as_descripcion_detalle = ''
		as_descripcion = ''
		SELECT count(*)
		  INTO :li_existe2
		  FROM temp_tela_n
		 WHERE cs_ordenpd_pt = :al_orden_prod AND
		       co_reftel 		= :al_reftel AND
				 co_caract 		<> :ai_caract AND
				 co_color 		= :al_color_te AND
				 diametro 		= :ai_diametro AND
				 usuario			= :ls_usuario;
		IF li_existe2 > 0 THEN
			as_descripcion_detalle = 'La prenda: ' + string(al_referencia) + ' Color: ' + string(al_color) + ' En la Tela: ' + string(al_reftel) +' color tela: ' +&
			                       string(al_color_te) + ' Diametro: ' + string(ai_diametro) + ' tiene un caracteristica en rollos diferente al que pide la ficha: ' + string(ai_caract)				
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
		END IF

		//aca se verifica que en la op si este el colorpt y el color de tela en la tela
		as_descripcion_detalle = ''
		as_descripcion = ''
		SELECT COUNT(*)
		  INTO :li_existe3
		  FROM dt_telas_ordxcol
		 WHERE cs_ordenpd_pt = :al_orden_prod AND
		       co_reftel = :al_reftel AND
				 co_color_pt = :al_color AND
				 co_color_te = :al_color_te AND 
				 cs_ordenpd_pt > 0;
 		IF li_existe3 = 0  THEN
			as_descripcion_detalle = 'La prenda: ' + string(al_referencia) + ' Color: ' + string(al_color) + ' En la Tela: ' + string(al_reftel) +' color tela: ' +&
			                         string(al_color_te) + ' Diametro: ' + string(ai_diametro) + ' Caract: ' + string(ai_caract) + ' No Esta creada en los colores por tela de la OP'				
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
		END IF
		
		IF li_existe1 = 0 AND li_existe2 = 0 AND li_existe3 > 0 THEN
			as_descripcion_detalle = 'La prenda: ' + string(al_referencia) + ' Color: ' + string(al_color) + ' En la Tela: ' + string(al_reftel) +' color tela: ' +&
			                         string(al_color_te) + ' Diametro: ' + string(ai_diametro) + ' Caract: ' + string(ai_caract) + ' No se encontr$$HEX2$$f3002000$$ENDHEX$$en la bodega'				
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
		END IF
	CASE 4    //PO BORRADA EN PEDPEND_EXP
		   as_descripcion_detalle = ''
			as_descripcion = ''
 			as_descripcion_detalle = ' REVISE CON PERSONA QUE CREA LOS PO EN SISTEMA DE VENTAS '
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE 5
		as_descripcion_detalle = ''
		as_descripcion = ''
		//No se encontr$$HEX3$$f30020002000$$ENDHEX$$datos en la ficha
			as_descripcion_detalle = ' La prenda: ' + string(al_referencia) + ' Color: ' + string(al_color) + ' No se encontr$$HEX2$$f3002000$$ENDHEX$$en la ficha de Prenda'				
			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE 6
		as_descripcion_detalle = ''
		as_descripcion = ''
		//No se encontr$$HEX2$$f3002000$$ENDHEX$$telas segun la ficha
			as_descripcion_detalle = ' La prenda: ' + string(al_referencia) + ' Color: ' + string(al_color) + ' En la Tela: ' + string(al_reftel) +' color tela: ' +&
			                         string(al_color_te) + ' Diametro: ' + string(ai_diametro) + ' Caract: ' + string(ai_caract) + ' Se trae de la ficha pero no se encontro en bodega'				

			as_descripcion = as_descripcion + as_descripcion_detalle
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE 7
		
			//No se encontr$$HEX2$$f3002000$$ENDHEX$$raya en la ficha ni tela de la ficha
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE 8
		
			//No se encontr$$HEX2$$f3002000$$ENDHEX$$gramos en la ficha
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
   CASE 9
		
			//No se encontr$$HEX2$$f3002000$$ENDHEX$$porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n en la ficha
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE 10
		
			//No se encontr$$HEX2$$f3002000$$ENDHEX$$area en la ficha
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);
	CASE 11
		
			//validacion de tandas iguales para el mismo color
			ll_consecutivo = of_buscar_cons_error(ls_usuario)
			Insert into temp_log_errores(cs_error,usuario,cs_ordenpd_pt,po,descripcion)
			Values(:ll_consecutivo,:ls_usuario,:al_orden_prod,:as_po,:as_descripcion);			
		
END CHOOSE

COMMIT;

return 1


	

end function

public function decimal of_recalcular_porcutil (long ai_pdn, long ai_raya, long al_agrupacion, long al_color, long al_liberacion, long ai_fabexp, long al_modelo);int ll_fila, ll_filas,li_raya,li_pdn,li_talla,li_estadodisp,li_centroterm,&
    li_fab_exp,li_caract,li_tipo_tela,li_totalpaq,li_paquete,li_modelo,li_model
Long ll_trazo,ll_unidades_libera,ll_fila1,ll_result,ll_fila2,ll_unds,ll_modelo,&
     ll_reftel,ll_unid_libera,ll_unds_total,ll_unds_libera,ll_unidades,ll_result1,ll_unids,ll_liberacion,&
	  ll_menor,ll_undstotal,ll_unidstalla,ll_agrupacion, ll_colorte
decimal {4} ld_area,ld_porcentaje,ldc_porc_partic,ld_porc_util,&
            ld_utilizacion,ld_ancho,ld_largo,ld_consumo,ld_unids_pend,&
            ld_unidades_total, ld_particip, ld_utili,ld_yield,ld_porcutil,ld_mts_lib,&
				ldc_participacion,ld_partic
Decimal{2}	ld_metros, 	ld_mts_trazo, ld_total_mts, ld_metros_libera		
string 	ls_error,ls_usuario
n_cts_constantes luo_constantes
Datastore lds_area_trazos,lds_agrupa_pdn_raya,lds_rollos_liberacion,lds_area,lds_contrazos,&
			 lds_cotrazo,lds_escalasxtela

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Recalculando Unidades..."
lstr_parametros_retro.cadena[3]="reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

luo_constantes = CREATE n_cts_constantes

ls_usuario = gstr_info_usuario.codigo_usuario

li_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF li_estadodisp = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el estado de los rollos.')
	RETURN -1
END IF

li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
IF li_centroterm = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el centro de los rollos.')
	Return -1
END IF

lds_area_trazos 			= CREATE Datastore
lds_agrupa_pdn_raya 		= CREATE Datastore
lds_rollos_liberacion 	= CREATE datastore
lds_area						= CREATE datastore
lds_cotrazo					= CREATE datastore	
lds_escalasxtela			= CREATE datastore

lds_area_trazos.DataObject 		 = 'ds_area_trazos'
lds_agrupa_pdn_raya.dataobject 	 = 'ds_agrupapdn_raya'
lds_rollos_liberacion.dataobject	 = 'ds_rollos_liberacion'
lds_area.dataobject					 = 'ds_area'
lds_cotrazo.dataobject            = 'ds_cotrazo'
lds_escalasxtela.dataobject		 = 'ds_escalasxtela'

lds_area_trazos.settransobject(sqlca)
lds_agrupa_pdn_raya.settransobject(sqlca)
lds_rollos_liberacion.settransobject(sqlca)
lds_area.settransobject(sqlca)
lds_cotrazo.settransobject(sqlca)
lds_escalasxtela.settransobject(sqlca)

ll_result = lds_area_trazos.retrieve(ai_pdn,ai_raya,al_agrupacion)

//si no tiene trazo tenemos la ficha como referencia 
IF ll_result = 0 THEN 
	ll_result = lds_escalasxtela.retrieve(ai_fabexp,al_liberacion,al_modelo) 
	
	FOR ll_fila=1 TO ll_result
		ll_unids   = lds_escalasxtela.getitemnumber(ll_fila,'ca_unidades')
		ld_consumo = lds_escalasxtela.getitemnumber(ll_fila,'yield')
		li_talla   = lds_escalasxtela.getitemnumber(ll_fila,'co_talla')
		
		INSERT INTO temporal_trazo  
				( co_trazo,   
				  area,
				  porc_util,
				  participacion,
				  unidades,
				  consumo,
				  raya,
				  agrupacion,
				  cs_pdn,
				  co_talla,
				  largo,
				  ancho,
				  usuario, 
				  modelo)  
		VALUES (0,   
				  0,   
				  0, 
				  0, 
				  :ll_unids,
				  :ld_consumo,
				  :ai_raya,
				  :al_agrupacion,
				  :ai_pdn,
				  :li_talla,
				  0,
				  0,
				  :ls_usuario,
				  :al_modelo)  ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			CLOSE(w_retroalimentacion)
			ls_error = sqlca.SqlErrText
			Rollback;
			MessageBox('Error of_recporc', 'Se produjo un error insertando en la tabla temporal_trazo: ' + ls_error)
			Return -1;
		END IF
	NEXT	
ELSE//hay trazos definidos
	//insertar filas en la temporal de trazos
	FOR ll_fila=1 TO ll_result
		ll_trazo				= lds_area_trazos.getitemnumber(ll_fila,'dt_trazosrecalculo_co_trazo')
		ld_area 				= lds_area_trazos.getitemnumber(ll_fila,'area')
		ld_porc_util 		= lds_area_trazos.getitemnumber(ll_fila,'h_trazos_porc_util')
		ldc_porc_partic  	= lds_area_trazos.getitemnumber(ll_fila,'participacion')
		ld_ancho 			= lds_area_trazos.getitemnumber(ll_fila,'h_trazos_ancho')
		ld_metros 			= lds_area_trazos.getitemnumber(ll_fila,'metros')
		li_raya 				= lds_area_trazos.getitemnumber(ll_fila,'dt_trazosrecalculo_raya')
		ll_agrupacion 		= lds_area_trazos.getitemnumber(ll_fila,'dt_trazosrecalculo_cs_agrupacion')
		li_pdn 				= lds_area_trazos.getitemnumber(ll_fila,'dt_trazosrecalculo_cs_pdn')
		li_talla 			= lds_area_trazos.getitemnumber(ll_fila,'dt_talla_pdnmodulo_co_talla')
		ld_largo 			= lds_area_trazos.getitemnumber(ll_fila,'h_trazos_largo')
		
		INSERT INTO temporal_trazo  
				( co_trazo,   
				  area,
				  porc_util,
				  participacion,
				  unidades,//pendiente de calcular
				  consumo,//pendiente de calcular
				  raya,
				  agrupacion,
				  cs_pdn,
				  co_talla,
				  largo,
				  ancho,
				  usuario, 
				  modelo)  
		VALUES (:ll_trazo,   
				  :ld_area,   
				  :ld_porc_util, 
				  :ldc_porc_partic, 
				  0,
				  0,
				  :li_raya,
				  :ll_agrupacion,
				  :li_pdn,
				  :li_talla,
				  :ld_largo,
				  :ld_ancho,
				  :ls_usuario,
				  :al_modelo)  ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			CLOSE(w_retroalimentacion)
			ls_error = sqlca.SqlErrText
			Rollback;
			MessageBox('Error of_recporc', 'Se produjo un error insertando en la tabla temporal_trazo: ' + ls_error)
			Return -1;
		END IF
	NEXT
	
	ll_filas = lds_cotrazo.retrieve(ls_usuario)
	
	FOR ll_fila=1 TO ll_filas
		ll_result1 = lds_area.retrieve(ll_trazo)
		//calcular el porcentaje de participacion del paquete del trazo en el total de paquetes
		FOR ll_fila = 1 TO ll_result1
			ll_trazo = lds_area.getitemnumber(ll_fila,'co_trazo')
			li_talla = lds_area.getitemnumber(ll_fila,'co_talla')
					
			SELECT sum(temp_constrazos.ca_paquetes) 
			INTO  :li_totalpaq
			FROM	 temp_constrazos  
			WHERE ( temp_constrazos.usuario  = :ls_usuario ) AND  
					( temp_constrazos.co_trazo = :ll_trazo ) AND
					( temp_constrazos.co_raya  = :ai_raya ) ;
			
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error= sqlca.sqlErrText
				ROLLBACK;
				MessageBox('Error of_recporc', 'Error al momento de calcular los paquetes del trazo ' + ls_error)
				RETURN -1;
			END IF
			
			SELECT temp_constrazos.ca_paquetes  
			INTO  :li_paquete		
			FROM	 temp_constrazos  
			WHERE ( temp_constrazos.usuario  = :ls_usuario ) AND  
					( temp_constrazos.co_trazo = :ll_trazo ) AND  
					( temp_constrazos.co_talla = :li_talla ) AND  
					( temp_constrazos.co_raya  = :ai_raya ) ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error= sqlca.sqlErrText
				ROLLBACK;
				MessageBox('Error of_recporc', 'Error al momento de calcular los paquetes de la talla ' + ls_error)
				RETURN -1;
			END IF	
				
			ld_porcentaje = (li_paquete/li_totalpaq)
			
			UPDATE temporal_trazo   
			SET participacion = :ld_porcentaje
			WHERE co_trazo = :ll_trazo AND
					co_talla = :li_talla AND
					modelo   = :al_modelo and
					usuario  = :ls_usuario;
			
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error= sqlca.sqlErrText
				ROLLBACK;
				MessageBox('Error of_recporc', 'Se produjo un error actualizando la tabla "temporal_trazo": ' + ls_error)
				RETURN -1;
			END IF
		NEXT
				 
		FOR ll_fila=1 TO ll_result1
			//actualizar unidades
			ll_trazo 	= lds_area.getitemnumber(ll_fila,'co_trazo')
			li_talla 	= lds_area.getitemnumber(ll_fila,'co_talla')
			
			//calculo las unidades por talla
			SELECT NVL(d.ca_paquetes * dt.ca_capas,0) 
			  INTO :ll_unids
			  FROM dt_tallasxtrazo d, dt_trazosrecalculo dt
			 WHERE dt.co_trazo 		= :ll_trazo and
					 d.co_trazo  		= dt.co_trazo and
					 d.co_talla  		= :li_talla and
					 dt.cs_agrupacion = :al_agrupacion and
					 dt.cs_pdn 			= :ai_pdn and
					 dt.raya 			= :ai_raya	;
			
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error=sqlca.sqlErrtext
				ROLLBACK;
				MessageBox('Error', 'Se produjo un error calculando las unidades. ": ' + ls_error)
				RETURN -1;
			END IF		
			
			UPDATE temporal_trazo  
			SET   unidades = :ll_unids
			WHERE temporal_trazo.co_trazo = :ll_trazo and
					temporal_trazo.co_talla = :li_talla and
					temporal_trazo.modelo   = :al_modelo and
					temporal_trazo.usuario  = :ls_usuario ;
					
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error=sqlca.sqlErrtext
				ROLLBACK;
				MessageBox('Error of_recporc', 'Se produjo un error actualizando la tabla "temporal de trazos": ' + ls_error)
				RETURN -1;
			END IF		
			
			//calculo los metros del trazo
			SELECT NVL(h.largo * dt.ca_capas,0) 
			  INTO :ld_mts_trazo
			  FROM h_trazos h, dt_trazosrecalculo dt
			 WHERE dt.co_trazo 		= :ll_trazo and
					 h.co_trazo  		= dt.co_trazo and
					 dt.cs_agrupacion = :al_agrupacion and
					 dt.cs_pdn 			= :ai_pdn and
					 dt.raya 			= :ai_raya	;
			
			//******** tengo los metros totales del trazo****************
			//ahorra necesito los metros para la talla en especial
			SELECT participacion * 100
			  INTO :ldc_participacion
			  FROM temporal_trazo
			WHERE temporal_trazo.co_trazo = :ll_trazo AND
					temporal_trazo.co_talla = :li_talla AND
					temporal_trazo.modelo   = :al_modelo and
					temporal_trazo.usuario  = :ls_usuario;
			
			//con esto puedo verificar el consumo para cada talla dentro del trazo
			ld_mts_trazo = (ld_mts_trazo * ldc_participacion ) / 100	
		   ld_consumo = ld_mts_trazo/ll_unids
				
			UPDATE temporal_trazo
			SET    consumo = :ld_consumo
			WHERE  temporal_trazo.co_trazo = :ll_trazo and
					 temporal_trazo.co_talla = :li_talla and
					 temporal_trazo.modelo   = :al_modelo and
					 temporal_trazo.usuario  = :ls_usuario;
					 
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error= sqlca.sqlErrText
				ROLLBACK;
				MessageBox('Error of_recporc', 'Se produjo un error actualizando la tabla "temporal_trazo": ' + ls_error)
				RETURN -1;
			END IF		 
		NEXT
	NEXT	
END IF	

//se actualiza h_agrupa_pdn//comentado
UPDATE h_agrupa_pdn
SET co_estado = 2
WHERE cs_agrupacion = :al_agrupacion ;

IF SQLCA.SQLCODE <> 0 THEN
	CLOSE(w_retroalimentacion)
	ls_error= sqlca.sqlErrText
	ROLLBACK;
	MessageBox('Error of_recporc', 'Actualizando estado en la tabla h_grupa_pdn :'  + ls_error)
	RETURN -1;
END IF	

DESTROY lds_area_trazos
DESTROY lds_agrupa_pdn_raya 		
DESTROY lds_rollos_liberacion 	
DESTROY lds_area						
DESTROY lds_cotrazo	

CLOSE(w_retroalimentacion)

RETURN 0
end function

public function long of_comparar_undsmts (long ai_fabexp, long al_lib, long al_modelo, long al_color);long ll_result1,ll_fila1,ll_reftel,ll_unid_libera,ll_totalunds_trazo,ll_result,ll_fila,ll_modelo,&
	  ll_liberacion	
Long li_caract,li_tipo_tela,li_fab_exp
decimal ld_metros_libera,ld_totalmts_trazo
string  ls_usuario

datastore lds_rollos_liberacion

lds_rollos_liberacion = CREATE datastore
lds_rollos_liberacion.dataobject = 'ds_rollos_liberacion'
lds_rollos_liberacion.settransobject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario
ll_result1 = lds_rollos_liberacion.retrieve(ai_fabexp,al_lib,al_modelo,al_color)
//se recorren las filas de dt_rollos_libera
FOR ll_fila1 = 1 TO  ll_result1
	
	ll_reftel 			= lds_rollos_liberacion.getitemnumber(ll_fila1,'co_reftel')
	li_caract 			= lds_rollos_liberacion.getitemnumber(ll_fila1,'co_caract')
	ld_metros_libera 	= lds_rollos_liberacion.getitemnumber(ll_fila1,'totalmtslibera')
	ll_unid_libera    = lds_rollos_liberacion.getitemnumber(ll_fila1,'totalunidlibera')
	
	li_tipo_tela = of_rectilineo(ll_reftel,li_caract)
	
	//se xtrae total de unidades del trazo por modelo
	select sum(unidades)
	into  :ll_totalunds_trazo
	from  temporal_trazo
	where temporal_trazo.usuario = :ls_usuario and
			temporal_trazo.modelo  = :al_modelo;
			
	//se xtrae total de metros del trazo por modelo
	select sum(unidades * consumo)
	into  :ld_totalmts_trazo
	from  temporal_trazo
	where temporal_trazo.usuario = :ls_usuario and
			temporal_trazo.modelo  = :al_modelo;
	
	IF li_tipo_tela = 3 THEN  //son rectilineos
		of_rectilineos(ai_fabexp,al_lib,al_color,al_modelo,ll_totalunds_trazo,ll_unid_libera)//cuando son rectilineos(unidades)
	ELSE //no es rectilineo
		of_no_rectilineos(ai_fabexp,al_lib,al_color,al_modelo,ld_totalmts_trazo,ld_metros_libera,ll_totalunds_trazo)//cuando no son rectilineos(metros)
	End if
NEXT

return 0
end function

public function long of_buscar_tipo_tela_tono_col (long al_color_te, long al_ordenpdn, long al_reftel);//Esta funcion verifica con un color de tela si es blanco o si es color
//cuando es blanco retorna 1, de lo contrario retorna 0
//Tambien verifica si la tela es comprada y retorna 1, sino retorna 0

Long	li_tono_blanco, li_tonocolor, li_registros, li_comprada
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_tono_blanco = luo_constantes.of_consultar_numerico("TONO BLANCO")

SELECT sw_comprada
  INTO :li_comprada
  FROM h_telas
 WHERE co_reftel =  :al_reftel
   AND co_caract = 0;
IF li_comprada = 1 THEN  //la tela es comprada
	Return 1;
ELSE
	Return 0;
END IF

//SELECT co_tono
//INTO :li_tonocolor
//FROM m_color
//WHERE co_color = :al_color_te;

//IF li_tonocolor = li_tono_blanco THEN
//	// es tono blanco, pero se debe verificar si la linea es 6 $$HEX2$$f3002000$$ENDHEX$$23
//	SELECT Count(*)
//     INTO :li_registros
//     FROM h_ordenpd_pt
//     WHERE cs_ordenpd_pt = :al_ordenpdn AND
//           co_fabrica = 2 AND
//           co_linea in (6, 23);
//	IF li_registros = 0 THEN	
//		RETURN 0
//	ELSE
//		RETURN 1
//	END IF
//ELSE
//	RETURN 0
//END IF
end function

public function long of_buscar_tela_faltante (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long ai_caract, long al_color_te, long ai_diametro, string as_usuario);//Esta funcion se encarga de buscar cual es el problema por el que
//no encuentra la tela, busca el concepto para marcar los rollos
Long	li_result

li_result = of_buscar_si_complemento_tintoreria(al_op,ai_fab,ai_lin,al_ref,ai_talla,al_color_pt,al_reftel,al_color_te,ai_diametro,as_usuario)
IF li_result = 1 THEN
	is_donde_tela = 'Tela faltante en proceso de tintoreria'
	Return 1
END IF
IF li_result = -1 THEN
	Return -1
END IF

li_result = of_buscar_si_complemento_estampar(al_op,ai_fab,ai_lin,al_ref,ai_talla,al_color_pt,al_reftel,al_color_te,ai_diametro,as_usuario)
IF li_result = 1 THEN
	is_donde_tela = 'Tela faltante en proceso de Estampar'
	Return 1
END IF
IF li_result = -1 THEN
	Return -1
END IF

li_result = of_buscar_si_complemento_crudo(al_op,ai_fab,ai_lin,al_ref,ai_talla,al_color_pt,al_reftel,al_color_te,ai_diametro,as_usuario)
IF li_result = 1 THEN
	is_donde_tela = 'Tela faltante en centro de crudo'
	Return 1
END IF
IF li_result = -1 THEN
	Return -1
END IF

li_result = of_buscar_si_complemento_compras(al_op,ai_fab,ai_lin,al_ref,ai_talla,al_color_pt,al_reftel,al_color_te,ai_diametro,as_usuario)
IF li_result = 1 THEN
		is_donde_tela = 'Tela faltante en proceso de compras o por cambiar la tanda en terminado'
	Return 1
END IF
IF li_result = -1 THEN
	Return -1
END IF

li_result = of_buscar_si_complemento_tejer(al_op,ai_fab,ai_lin,al_ref,ai_talla,al_color_pt,al_reftel,al_color_te,ai_diametro,as_usuario)
IF li_result = 1 THEN
	is_donde_tela = 'Tela faltante en proceso de tejer'
	Return 1
END IF
IF li_result = -1 THEN
	Return -1
END IF
is_donde_tela = ''
return 0
end function

public function long of_buscar_si_complemento_tintoreria (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario);Long	li_tot_rollos, ll_fila1, ll_fila2, li_caract, li_diametro, li_tot_filas
LONG		ll_reftel, ll_rollo, ll_color_te
STRING	ls_error
DATETIME	ldt_fecha
DataStore  lds_ficha, lds_rollos_temp_tela_n

lds_ficha    = Create DataStore
lds_ficha.DataObject    = 'ds_ficha'

lds_rollos_temp_tela_n    = Create DataStore
lds_rollos_temp_tela_n.DataObject    = 'ds_rollos_temp_tela_n'

lds_ficha.SetTransObject(sqlca)
lds_rollos_temp_tela_n.SetTransObject(sqlca)

ldt_fecha = f_fecha_servidor()

//miramos si tiene la tela faltante en centro 7 o centro 10,50,60
SELECT COUNT(*)
  INTO :li_tot_rollos
  FROM m_rollo
 WHERE cs_orden_pr_act =  :al_op
   AND co_reftel_act = :al_reftel
	AND co_color_act = :al_color_te
	AND diametro_act = :ai_diametro
	AND co_centro IN (7,10,50,60);
	
IF li_tot_rollos > 0 THEN
	lds_ficha.Retrieve(ai_fab,ai_lin,al_ref,ai_talla,al_color_pt)
	FOR ll_fila1 = 1 To lds_ficha.RowCount()
		ll_reftel 	= lds_ficha.GetItemNumber(ll_fila1,'co_reftel')
		li_caract 	= lds_ficha.GetItemNumber(ll_fila1,'co_caract')
		li_diametro = lds_ficha.GetItemNumber(ll_fila1,'diametro')
		ll_color_te = lds_ficha.GetItemNumber(ll_fila1,'co_color_te')
		li_tot_filas = lds_rollos_temp_tela_n.Retrieve(al_op,ll_reftel,ll_color_te,li_diametro,as_usuario)
		FOR ll_fila2 = 1 To li_tot_filas
			ll_rollo	= lds_rollos_temp_tela_n.GetItemNumber(ll_fila2,'cs_rollo')
			UPDATE m_rollo
			SET (co_planeador,fe_act_cpto ) = (67, :ldt_fecha)
			WHERE cs_rollo = :ll_rollo
			  AND co_planeador <> 67
			  AND co_centro = 15;
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando el concepto del rollo en terminado: ' + ls_error)
				Return -1;
			ELSE
				COMMIT;
			END IF
		NEXT
	NEXT		
	//actualiza la tela que hay en tintoreria al concepto por liberar
	of_act_rollos_en_tintoreria(al_op,al_reftel,al_color_te)
	Return 1
ELSE
	//No se encontro la tela en tintura, se debe buscar en los demas centros
	Return 0
END IF
end function

public function long of_buscar_si_complemento_estampar (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario);Long	li_tot_rollos, ll_fila1, ll_fila2, li_caract, li_diametro
LONG		ll_reftel, ll_rollo, ll_color_te
STRING	ls_error
DATETIME	ldt_fecha
DataStore  lds_ficha, lds_rollos_temp_tela_n

lds_ficha    = Create DataStore
lds_ficha.DataObject    = 'ds_ficha'

lds_rollos_temp_tela_n    = Create DataStore    
lds_rollos_temp_tela_n.DataObject    = 'ds_rollos_temp_tela_n'

lds_ficha.SetTransObject(sqlca)
lds_rollos_temp_tela_n.SetTransObject(sqlca)

ldt_fecha = f_fecha_servidor()

//miramos si tiene la tela faltante en centros de Estampado
SELECT COUNT(*)
  INTO :li_tot_rollos
  FROM m_rollo
 WHERE cs_orden_pr_act =  :al_op
   AND co_reftel_act = :al_reftel
	AND co_color_act = :al_color_te
	AND diametro_act = :ai_diametro
	AND co_centro IN (41,42,43,44,45,46,47);
	
IF li_tot_rollos > 0 THEN
	lds_ficha.Retrieve(ai_fab,ai_lin,al_ref,ai_talla,al_color_pt)
	FOR ll_fila1 = 1 To lds_ficha.RowCount()
		ll_reftel 	= lds_ficha.GetItemNumber(ll_fila1,'co_reftel')
		li_caract 	= lds_ficha.GetItemNumber(ll_fila1,'co_caract')
		li_diametro = lds_ficha.GetItemNumber(ll_fila1,'diametro')
		ll_color_te = lds_ficha.GetItemNumber(ll_fila1,'co_color_te')
		lds_rollos_temp_tela_n.Retrieve(al_op,ll_reftel,ll_color_te,li_diametro,as_usuario)
		FOR ll_fila2 = 1 To lds_rollos_temp_tela_n.RowCount()
			ll_rollo	= lds_rollos_temp_tela_n.GetItemNumber(ll_fila2,'cs_rollo')
			UPDATE m_rollo
			SET (co_planeador, fe_act_cpto) = (69, :ldt_fecha)
			WHERE cs_rollo = :ll_rollo
			  AND co_planeador <> 69
			  AND co_centro = 15;
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando el concepto del rollo en terminado: ' + ls_error)
				Return -1;
			ELSE
				COMMIT;
			END IF
		NEXT
	NEXT		
	
	Return 1
ELSE
	//No se encontro la tela en tintura, se debe buscar en los demas centros
	Return 0
END IF
end function

public function long of_buscar_si_complemento_compras (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario);
Long	li_tot_rollos, ll_fila1, ll_fila2, li_caract, li_diametro, li_co_cpto_marcar, li_tela_comprada
LONG		ll_reftel, ll_rollo, ll_color_te
STRING	ls_error
DATETIME	ldt_fecha
DataStore  lds_ficha, lds_rollos_temp_tela_n

ldt_fecha = f_fecha_servidor()

lds_ficha    = Create DataStore
lds_ficha.DataObject    = 'ds_ficha'

lds_rollos_temp_tela_n    = Create DataStore    
lds_rollos_temp_tela_n.DataObject    = 'ds_rollos_temp_tela_n'

lds_ficha.SetTransObject(sqlca)
lds_rollos_temp_tela_n.SetTransObject(sqlca)

//miramos si tiene la tela faltante en la calle
SELECT COUNT(*)
  INTO :li_tela_comprada
  FROM h_telas
 WHERE co_reftel = :al_reftel
   AND co_caract = 4
	AND sw_comprada = 1;
IF	li_tela_comprada > 0 THEN
	li_co_cpto_marcar = 73
END IF

IF	li_tela_comprada > 0 THEN
	lds_ficha.Retrieve(ai_fab,ai_lin,al_ref,ai_talla,al_color_pt)
	FOR ll_fila1 = 1 To lds_ficha.RowCount()
		ll_reftel 	= lds_ficha.GetItemNumber(ll_fila1,'co_reftel')
		li_caract 	= lds_ficha.GetItemNumber(ll_fila1,'co_caract')
		li_diametro = lds_ficha.GetItemNumber(ll_fila1,'diametro')
		ll_color_te = lds_ficha.GetItemNumber(ll_fila1,'co_color_te')
		lds_rollos_temp_tela_n.Retrieve(al_op,ll_reftel,ll_color_te,li_diametro,as_usuario)
		FOR ll_fila2 = 1 To lds_rollos_temp_tela_n.RowCount()
			ll_rollo	= lds_rollos_temp_tela_n.GetItemNumber(ll_fila2,'cs_rollo')
			UPDATE m_rollo
			SET (co_planeador,fe_act_cpto)  = (:li_co_cpto_marcar, :ldt_fecha )
			WHERE cs_rollo = :ll_rollo
			  AND co_planeador <> :li_co_cpto_marcar 
			  AND co_centro = 15;
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando el concepto del rollo en terminado: ' + ls_error)
				Return -1;
			Else
				Commit;
			END IF
		NEXT
	NEXT		
	
	Return 1
ELSE
	//No se encontro la tela comprada, se debe buscar en los demas centros
	Return 0
END IF
end function

public function long of_buscar_si_complemento_crudo (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario);Long	li_tot_rollos, ll_fila1, ll_fila2, li_caract, li_diametro
LONG		ll_reftel, ll_rollo, ll_color_te
STRING	ls_error
DATETIME	ldt_fecha
DataStore  lds_ficha, lds_rollos_temp_tela_n

lds_ficha    = Create DataStore
lds_ficha.DataObject    = 'ds_ficha'

lds_rollos_temp_tela_n    = Create DataStore    
lds_rollos_temp_tela_n.DataObject    = 'ds_rollos_temp_tela_n'

lds_ficha.SetTransObject(sqlca)
lds_rollos_temp_tela_n.SetTransObject(sqlca)

ldt_fecha = f_fecha_servidor()

//miramos si tiene la tela faltante en centros crudo
SELECT COUNT(*)
  INTO :li_tot_rollos
  FROM m_rollo
 WHERE cs_orden_pr_act =  :al_op
   AND co_reftel_act = :al_reftel
	AND co_color_act = :al_color_te
	AND diametro_act = :ai_diametro
	AND co_centro = 6;
	
IF li_tot_rollos > 0 THEN
	lds_ficha.Retrieve(ai_fab,ai_lin,al_ref,ai_talla,al_color_pt)
	FOR ll_fila1 = 1 To lds_ficha.RowCount()
		ll_reftel 	= lds_ficha.GetItemNumber(ll_fila1,'co_reftel')
		li_caract 	= lds_ficha.GetItemNumber(ll_fila1,'co_caract')
		li_diametro = lds_ficha.GetItemNumber(ll_fila1,'diametro')
		ll_color_te = lds_ficha.GetItemNumber(ll_fila1,'co_color_te')
		lds_rollos_temp_tela_n.Retrieve(al_op,ll_reftel,ll_color_te,li_diametro,as_usuario)
		FOR ll_fila2 = 1 To lds_rollos_temp_tela_n.RowCount()
			ll_rollo	= lds_rollos_temp_tela_n.GetItemNumber(ll_fila2,'cs_rollo')
			UPDATE m_rollo
			SET (co_planeador,fe_act_cpto)  = (76, :ldt_fecha)
			WHERE cs_rollo = :ll_rollo
			  AND co_planeador <> 76
			  AND co_centro = 15;
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando el concepto del rollo en terminado: ' + ls_error)
				Return -1;
			ELSE
				COMMIT;
			END IF
			
		NEXT
	NEXT		
	
	Return 1
ELSE
	//No se encontro la tela en tintura, se debe buscar en los demas centros
	Return 0
END IF
end function

public function long of_buscar_si_complemento_tejer (long al_op, long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color_pt, long al_reftel, long al_color_te, long ai_diametro, string as_usuario);Long	li_tot_rollos, ll_fila1, ll_fila2, li_caract, li_diametro
LONG		ll_reftel, ll_rollo, ll_color_te
STRING	ls_error
DATETIME	ldt_fecha
DataStore  lds_ficha, lds_rollos_temp_tela_n

ldt_fecha = f_fecha_servidor()

lds_ficha    = Create DataStore
lds_ficha.DataObject    = 'ds_ficha'

lds_rollos_temp_tela_n    = Create DataStore    
lds_rollos_temp_tela_n.DataObject    = 'ds_rollos_temp_tela_n'

lds_ficha.SetTransObject(sqlca)
lds_rollos_temp_tela_n.SetTransObject(sqlca)

////miramos si tiene la tela faltante en centros crudo
//SELECT COUNT(*)
//  INTO :li_tot_rollos
//  FROM m_rollo
// WHERE cs_orden_pr_act =  :al_op
//   AND co_reftel_act = :al_reftel
//	AND co_color_act = :al_color_te
//	AND diametro_act = :ai_diametro
//	AND co_centro = 0;
li_tot_rollos = 1
	
IF li_tot_rollos > 0 THEN
	lds_ficha.Retrieve(ai_fab,ai_lin,al_ref,ai_talla,al_color_pt)
	FOR ll_fila1 = 1 To lds_ficha.RowCount()
		ll_reftel 	= lds_ficha.GetItemNumber(ll_fila1,'co_reftel')
		li_caract 	= lds_ficha.GetItemNumber(ll_fila1,'co_caract')
		li_diametro = lds_ficha.GetItemNumber(ll_fila1,'diametro')
		ll_color_te = lds_ficha.GetItemNumber(ll_fila1,'co_color_te')
		lds_rollos_temp_tela_n.Retrieve(al_op,ll_reftel,ll_color_te,li_diametro,as_usuario)
		FOR ll_fila2 = 1 To lds_rollos_temp_tela_n.RowCount()
			ll_rollo	= lds_rollos_temp_tela_n.GetItemNumber(ll_fila2,'cs_rollo')
			UPDATE m_rollo
			SET (co_planeador, fe_act_cpto) = (72, :ldt_fecha)
			WHERE cs_rollo = :ll_rollo
			  AND co_planeador <> 72
			  AND co_centro = 15;
			IF SQLCA.SQLCODE <> 0 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando el concepto del rollo en terminado: ' + ls_error)
				Return -1;
			ELSE
				COMMIT;
			END IF
		NEXT
	NEXT		
	
	Return 1
ELSE
	//No se encontro la tela en tintura, se debe buscar en los demas centros
	Return 0
END IF
end function

public function long of_act_rollos_en_tintoreria (long al_op, long al_reftel, long al_color_te);Long ll_unidades, ll_result, ll_fila, ll_pedido, ll_ordenpd_pt, ll_result1, ll_fila1, ll_unid_prog,&
     ll_ref, ll_modelo, ll_reftel, ll_tanda, ll_color, ll_color_te
Decimal{5} ldc_consumo
Decimal{5} ldc_factor1, ldc_factor2, ldc_kg, ld_ancho
Decimal{3}	ldc_mt
String ls_usuario, ls_po, ls_tono, ls_error
Long li_fab, li_lin, li_talla, li_caract, li_diametro, li_raya
Long	li_marca,  li_tipo_tejido, li_tipo_tela
DataStore lds_unidlib, lds_temp_ref

//SA60755.  Debido a que en los tapabocas se estaban presentando problemas con las unidades al calcularlas en la liberacion
//se realiza un ajuste al proceso, para que cuando sea una sola talla se distribuya mejor la tela que hay disponible
//realizar jorodrig mayo 6 - 2020

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Calculando Proporciones por Color (6/6)..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                                 

lds_unidlib = Create DataStore
lds_temp_ref = Create DataStore
lds_unidlib.DataObject  = 'dgr_unidades_liberar_prueba'
lds_temp_ref.DataObject = 'ds_temp_modelos_ref_prueba'
lds_unidlib.SetTransObject(sqlca)
lds_temp_ref.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

//recorro las referencias de temp_referen_n
ll_result1 = lds_temp_ref.Retrieve(ls_usuario)

IF ll_result1 <= 0 THEN
	CLOSE(w_retroalimentacion)
	Rollback;
	MessageBox('Error','No es posible liberar por tanda, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	Return -1;
END IF



For ll_fila1 = 1 To ll_result1
   //traemos los datos necesarios para recalcular las unidades
	ls_po 			= lds_temp_ref.GetItemString(ll_fila1,'po')
	ll_ordenpd_pt 	= lds_temp_ref.GetItemNumber(ll_fila1,'cs_ordenpd_pt')
	ll_color 		= lds_temp_ref.GetItemNumber(ll_fila1,'co_color')
	li_fab			= lds_temp_ref.GetItemNumber(ll_fila1,'co_fabrica')
	li_lin			= lds_temp_ref.GetItemNumber(ll_fila1,'co_linea')
	ll_ref			= lds_temp_ref.GetItemNumber(ll_fila1,'co_referencia')
	li_talla			= lds_temp_ref.GetItemNumber(ll_fila1,'co_talla')
	ll_reftel		= lds_temp_ref.GetItemNumber(ll_fila1,'co_reftel')
	li_caract		= lds_temp_ref.GetItemNumber(ll_fila1,'co_caract')
	li_diametro		= lds_temp_ref.GetItemNumber(ll_fila1,'diametro')
	ll_color_te		= lds_temp_ref.GetItemNumber(ll_fila1,'co_color_te')
	ld_ancho			= lds_temp_ref.GetItemNumber(ll_fila1,'ancho')
	ls_tono			= lds_temp_ref.GetItemString(ll_fila1,'tono')
	ll_unid_prog	= lds_temp_ref.GetItemNumber(ll_fila1,'unid_prog')
	li_marca			= lds_temp_ref.GetItemNumber(ll_fila1,'sw_marca')
	ll_tanda			= lds_temp_ref.GetItemNumber(ll_fila1,'cs_tanda')
	li_tipo_tejido	= lds_temp_ref.GetItemNumber(ll_fila1,'co_ttejido')
	
	
		
	IF li_tipo_tejido = 131 OR li_tipo_tejido = 212 OR li_tipo_tejido = 211 THEN	//son hiladillas
		li_tipo_tela = 4
	ELSE
		li_tipo_tela = 1
	END IF
	
	IF of_rectilineo(ll_reftel,li_caract) = 3 THEN  //son rectilineas, no se recalculan unidades
	ELSE
		ldc_factor1 = 0
		ldc_factor2 = 0
		ll_result = lds_unidlib.Retrieve(ls_usuario,ll_ordenpd_pt,ls_po,ll_color,ll_reftel,li_caract,li_diametro,ll_color_te,ll_tanda,ld_ancho)
		For ll_fila = 1 To ll_result
			ll_pedido = lds_unidlib.GetItemNumber(ll_fila,'unid_prog')
			ldc_consumo = lds_unidlib.GetItemNumber(ll_fila,'consumo')
			
			IF ll_result1 = 1 THEN
				ldc_factor1 += ldc_consumo
			ELSE
				ldc_factor1 += ll_pedido * ldc_consumo
			END IF
			
		Next
		
		IF li_marca = 1 THEN
		SELECT sum(ca_mt),sum(ca_kg)
			  INTO :ldc_mt,:ldc_kg
			  FROM temp_tela_n
			 WHERE usuario 		= :ls_usuario AND
					 cs_ordenpd_pt = :ll_ordenpd_pt AND
					 co_reftel 		= :ll_reftel AND
					 co_caract 		= :li_caract AND
					 diametro 		= :li_diametro AND
					 co_color		= :ll_color_te	AND
					 ancho_agrupa	= :ld_ancho AND
					 cs_tanda		= :ll_tanda;
			ELSE
				SELECT sum(ca_mt),sum(ca_kg)
				  INTO :ldc_mt,:ldc_kg
				  FROM temp_tela_n
				 WHERE usuario 		= :ls_usuario AND
						 cs_ordenpd_pt = :ll_ordenpd_pt AND
						 co_reftel 		= :ll_reftel AND
						 co_caract 		= :li_caract AND
						 co_color		= :ll_color_te	AND
						 ancho_agrupa	= :ld_ancho AND
						 cs_tanda		= :ll_tanda;
			END IF
				 
		IF ll_result1 = 1 THEN		 
			IF li_tipo_tela = 4 THEN	
				ldc_factor2 = ldc_mt 
			ELSE
				ldc_factor2 = ldc_kg 
			END IF
			ll_unidades = ldc_factor2 / ldc_factor1
		ELSE
			IF li_tipo_tela = 4 THEN	
				ldc_factor2 = ldc_mt / ldc_factor1
			ELSE
				ldc_factor2 = ldc_kg / ldc_factor1
			END IF
			ll_unidades = ldc_factor2 * ll_unid_prog
		END IF
		
		If isnull(ll_unidades) Then ll_unidades = 0
				
		UPDATE temp_modelos_ref
		SET (unid_liberar, kg_bodega, mt_bodega, unid_real_liberar) = ( :ll_unidades, (:ll_unidades * consumo),  (:ll_unidades * consumo),:ll_unidades)
		WHERE usuario = :ls_usuario
		AND cs_ordenpd_pt = :ll_ordenpd_pt
		AND po 				= :ls_po
		AND co_fabrica 	= :li_fab
		AND co_linea 		= :li_lin
		AND co_referencia = :ll_ref
		AND co_color 		= :ll_color
		AND co_talla 		= :li_talla
		AND co_reftel 		= :ll_reftel
		AND co_caract 		= :li_caract
		AND diametro 		= :li_diametro
		AND co_color_te 	= :ll_color_te
		AND ancho 			= :ld_ancho
		AND cs_tanda		= :ll_tanda;
		IF SQLCA.SQLCODE <> 0 THEN
			CLOSE(w_retroalimentacion)
			ls_error = sqlca.sqlerrtext
			Rollback;
			MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar: ' + ls_error)
			Return -1;
		END IF
	END IF   //final de rectilineas
Next

commit;
CLOSE(w_retroalimentacion)
Destroy lds_unidlib
Destroy lds_temp_ref
Return 0
end function

public function long of_cargartemreferencias (long al_color, long ai_talla);
//carga la tabla temporal de Referencias en base a la temporal de rollos para la liberaci$$HEX1$$f300$$ENDHEX$$n
Long li_co_fabrica, li_co_linea, li_talla, li_marca, li_existe
Long	li_contador, li_respuesta, li_critica
Long ll_fila, ll_result, ll_co_referencia, ll_ordenpd_pt, ll_ca_programada, ll_ca_real
Long	ll_ca_liberadas, ll_total_color, ll_total_color_bdsize, ll_porc_increm, ll_cant_incr, ll_color
Decimal{4} ldc_porc_partic
String ls_po, ls_usuario, ls_cut, ls_descripcion,ls_error
Boolean lb_linea

DataStore lds_refer_exp, lds_refer_nal
n_cts_constantes luo_constantes

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando las Referencias, Colores y Tallas (2/6)..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)                                 
//

luo_constantes = Create n_cts_constantes
//el criterio de seleccion puede ser tanto para exportacion como para nacional
//por lo tanto se crean dos datastore para manejar cada uno de las posibilidades

ls_usuario = gstr_info_usuario.codigo_usuario
lds_refer_exp = Create DataStore
lds_refer_nal = Create DataStore

lds_refer_exp.DataObject = 'ds_refer_exp_prueba'
lds_refer_nal.DataObject = 'ds_refer_nal_prueba'

lds_refer_exp.SetTransObject(sqlca)
lds_refer_nal.SetTransObject(sqlca)

lb_linea = True
//primero debemos recuperar los datos de exportacion
ll_result = lds_refer_exp.Retrieve(ls_usuario,al_color, '')
//se recorre el datastore para extraer los datos que llenaran la temporal de las telas
IF ll_result > 0 THEN
   //hay datos en exportacion
	FOR ll_fila = 1 To ll_result
		li_co_fabrica 		= lds_refer_exp.GetItemNumber(ll_fila,'co_fabrica')
		li_co_linea 		= lds_refer_exp.GetItemNumber(ll_fila,'h_ordenpd_pt_co_linea')
		ll_co_referencia 	= lds_refer_exp.GetItemNumber(ll_fila,'h_ordenpd_pt_co_referencia')
  	   ll_ordenpd_pt 		= lds_refer_exp.GetItemNumber(ll_fila,'h_ordenpd_pt_cs_ordenpd_pt')
		ls_po 				= lds_refer_exp.GetItemString(ll_fila,'dt_caxpedidos_nu_orden')
		ll_color 			= lds_refer_exp.GetItemNumber(ll_fila,'dt_caxpedidos_co_color')
		li_talla 			= lds_refer_exp.GetItemNumber(ll_fila,'dt_caxpedidos_co_talla')
		ll_ca_programada	= lds_refer_exp.GetItemNumber(ll_fila,'dt_caxpedidos_ca_programada')
		ll_ca_real			= lds_refer_exp.GetItemnumber(ll_fila,'dt_caxpedidos_ca_real')
		ll_ca_liberadas 	= lds_refer_exp.GetItemNumber(ll_fila,'dt_caxpedidos_ca_liberadas')
		//li_marca			 	= lds_refer_exp.GetItemNumber(ll_fila,'sw_marca')
		ll_total_color    = lds_refer_exp.GetItemNumber(ll_fila,'total_color')
		ll_total_color_bdsize = lds_refer_exp.GetItemNumber(ll_fila,'total_color_bdsize')
		ls_cut				= lds_refer_exp.GetItemString(ll_fila,'nu_cut')
				
		//si las unidades de lo op son iguales o menores a las unidades de la po se incrementa
		//en un 5% las unidades a programar
		//esto fue solicitado en el sue$$HEX1$$f100$$ENDHEX$$o de tela de mayo 23 de 2008 por Jesus Maria Henao (texografo)
		//jcrm
		//mayo 27 de 2008
		ll_porc_increm = luo_constantes.of_consultar_numerico("PORC_INCREMENTAR_OP")
		
		IF ll_ca_programada <= ll_ca_real THEN
			//se incrementa la cantidad un 5%
			ll_cant_incr = (ll_ca_programada * ll_porc_increm) / 100
			ll_ca_programada = ll_ca_programada + ll_cant_incr
		END IF
		
		
		//Verificar que exista la po en pedpend_exp, si no esta no se puede liberar
	 	SELECT COUNT(*)
		  INTO :li_existe
		  FROM pedpend_exp
		 WHERE nu_orden =  :ls_po
		   AND co_fabrica = :li_co_fabrica
			AND co_linea = :li_co_linea
			AND co_referencia = :ll_co_referencia
			AND co_color = :ll_color
			AND co_talla = :li_talla;
			
		IF sqlca.sqlcode = -1 THEN
			ls_error = sqlca.sqlerrtext
			MessageBox('Error','Ocurrri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la PO, ERROR: '+ls_error)
		END IF
			
		IF li_existe = 0 THEN  //El pedido ya no existe en archivo de pos
			ls_descripcion = 'La P.O ya no tiene la referencia-color-talla en archivo de pedidos, P.O: ' + ls_po + &
					           ' Referencia: ' + string(ll_co_referencia) + ' Color: ' + string(ll_color) + ' Talla: ' + string(li_talla)
			of_cargar_log_problemas(ls_descripcion,ll_ordenpd_pt,ls_po,ll_co_referencia,ll_color,0,0,0,0,4)
		END IF
		
		//Buscar si la prenda tiene alguna tela que sea bodysize, en caso de que
		//alguna de las telas sea bodysize se marca la prenda como 1=bodysize
		SELECT COUNT(*)
		  INTO :li_contador
		  FROM temp_tela_n
		 WHERE usuario = :ls_usuario	
		   AND cs_ordenpd_pt = :ll_ordenpd_pt
			AND sw_marca = 1;
			
		IF sqlca.sqlcode = -1 THEN
			ls_error = sqlca.sqlerrtext
			MessageBox('Error','Ocurrri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar si la tela es Bodysize, ERROR: '+ls_error)
		END IF	
			
		IF li_contador > 0 THEN
			li_marca = 1
		ELSE
			li_marca = 0
		END IF
		
		//calculamos el porcentaje de participacion de la talla
		IF li_marca = 1 THEN
			ldc_porc_partic = ll_ca_programada / ll_total_color_bdsize
		ELSE
			ldc_porc_partic = ll_ca_programada / ll_total_color
		END IF
		
		//se verifica el tipo de referencia
		//-1 ocurrio un error
		//100 no es referencia de linea
		//0 se trata de una referencia de linea
		IF of_verificacionlinea(li_co_fabrica,li_co_linea,ll_co_referencia) = 0 THEN
			//se verifica si dicha referencia aparece en el reporte de criticas.
			li_critica =  of_referenciacritica(li_co_fabrica,li_co_linea,ll_co_referencia,li_talla,ll_color) 
			IF li_critica = 100 THEN
				li_respuesta = MessageBox('Error','La referencia que esta liberando es de l$$HEX1$$ed00$$ENDHEX$$nea y no se encuentra critica, esta seguro de continuar.',Exclamation!, OKCancel!, 1)
				IF lb_linea = True THEN
					IF li_respuesta = 2 THEN
						Rollback;
						Return -1
					ELSE
						lb_linea = False
					END IF
				END IF
			END IF
			
		ELSE
			lb_linea = False
		END IF
		
		//si en los parametros ingresaron talla para un bodysize solo se carga esa talla
			IF ai_talla > 0 THEN
				IF ai_talla = li_talla THEN
				
					INSERT INTO temp_referen_n
						(usuario, 
						 cs_ordenpd_pt, 
						 po, 
						 co_fabrica, 
						 co_linea, 
						 co_referencia, 
						 co_color,
						 co_talla, 
						 unid_prog, 
						 unid_liberadas, 
						 porc_particip, 
						 sw_marca, 
						 nu_cut)
					VALUES (
						:ls_usuario, 
						:ll_ordenpd_pt, 
						:ls_po, 
						:li_co_fabrica, 
						:li_co_linea,
						:ll_co_referencia, 
						:ll_color, 
						:li_talla, 
						:ll_total_color_bdsize,
						//:ll_ca_programada, 
						:ll_ca_liberadas,
						:ldc_porc_partic, 
						:li_marca, 
						:ls_cut);
					IF SQLCA.SQLCODE <> 0 THEN
						IF SQLCA.SQLDBCODE = -268 THEN
							ls_error = SQLCA.SQLErrText
							Rollback;
							CLOSE(w_retroalimentacion)
							MessageBox('Error', 'Probablemente el pedido: ' + ls_po + ' En el color: ' + string(ll_color) + ' Talla: ' + string(li_talla) + ' Este creado mas de una vez en la OP, REVISE!')
							Return -1;
						ELSE
							ls_error = SQLCA.SQLErrText
							Rollback;
							CLOSE(w_retroalimentacion)
							MessageBox('Error', 'Se produjo error insertando referencias segun tela bodega: ' + string(ls_error))
							Return -1;
						END IF
					END IF
				END IF
			ELSE
				INSERT INTO temp_referen_n
					(usuario, 
					 cs_ordenpd_pt, 
					 po, 
					 co_fabrica, 
					 co_linea, 
					 co_referencia, 
					 co_color,
					 co_talla, 
					 unid_prog, 
					 unid_liberadas, 
					 porc_particip, 
					 sw_marca, 
					 nu_cut)
				VALUES (
					:ls_usuario, 
					:ll_ordenpd_pt, 
					:ls_po, 
					:li_co_fabrica, 
					:li_co_linea,
					:ll_co_referencia, 
					:ll_color, 
					:li_talla, 
					:ll_total_color_bdsize,
					//:ll_ca_programada, 
					:ll_ca_liberadas,
					:ldc_porc_partic, 
					:li_marca, 
					:ls_cut);
				IF SQLCA.SQLCODE <> 0 THEN
					IF SQLCA.SQLDBCODE = -268 THEN
						ls_error = SQLCA.SQLErrText
						Rollback;
						CLOSE(w_retroalimentacion)
						MessageBox('Error', 'Probablemente el pedido: ' + ls_po + ' En el color: ' + string(ll_color) + ' Talla: ' + string(li_talla) + ' Este creado mas de una vez en la OP, REVISE!')
						Return -1;
					ELSE
						ls_error = SQLCA.SQLErrText
						Rollback;
						CLOSE(w_retroalimentacion)
						MessageBox('Error', 'Se produjo error insertando referencias segun tela bodega: ' + string(ls_error))
						Return -1;
					END IF
				END IF
		END IF

	NEXT
ELSE
	
	//se trata de datos de nacional, por lo tanto recuperamos los datos de nacional
	ll_result = lds_refer_nal.Retrieve(ls_usuario,al_color)
	IF ll_result > 0 THEN
		FOR ll_fila = 1 To ll_result
			li_co_fabrica 		= lds_refer_nal.GetItemNumber(ll_fila,'co_fabrica')
			li_co_linea 		= lds_refer_nal.GetItemNumber(ll_fila,'h_ordenpd_pt_co_linea')
			ll_co_referencia 	= lds_refer_nal.GetItemNumber(ll_fila,'h_ordenpd_pt_co_referencia')
			ll_ordenpd_pt 		= lds_refer_nal.GetItemNumber(ll_fila,'h_ordenpd_pt_cs_ordenpd_pt')
			ls_po 				= STRING(lds_refer_nal.GetItemNumber(ll_fila,'dt_orden_tllaclor_cs_ordenpd_pt'))
			ll_color 			= lds_refer_nal.GetItemNumber(ll_fila,'dt_orden_tllaclor_co_color')
			li_talla 			= lds_refer_nal.GetItemNumber(ll_fila,'dt_orden_tllaclor_co_talla')
			ll_ca_programada	= lds_refer_nal.GetItemNumber(ll_fila,'dt_orden_tllaclor_ca_programada')
			ll_ca_liberadas 	= lds_refer_nal.GetItemNumber(ll_fila,'dt_orden_tllaclor_ca_liberada')
	//		li_marca			 	= lds_refer_nal.GetItemNumber(ll_fila,'sw_marca')
			ll_total_color    = lds_refer_nal.GetItemNumber(ll_fila,'total_color')
			ll_total_color_bdsize = lds_refer_nal.GetItemNumber(ll_fila,'total_color_bdsize')
			ls_cut 				= STRING(lds_refer_nal.GetItemNumber(ll_fila,'dt_orden_tllaclor_cs_ordenpd_pt')) 	
			
			//Buscar si la prenda tiene alguna tela que sea bodysize, en caso de que
			//alguna de las telas sea bodysize se marca la prenda como 1=bodysize
			SELECT COUNT(*)
			  INTO :li_contador
			  FROM temp_tela_n
			 WHERE usuario = :ls_usuario	
				AND cs_ordenpd_pt = :ll_ordenpd_pt
				AND sw_marca = 1;
			IF li_contador > 0 THEN
				li_marca = 1
			ELSE
				li_marca = 0
			END IF
			
			//calculamos el porcentaje de participacion de la talla
			IF li_marca = 1 THEN
				ldc_porc_partic = ll_ca_programada / ll_total_color_bdsize
			ELSE
				ldc_porc_partic = ll_ca_programada / ll_total_color
			END IF
			
			//si en los parametros ingresaron talla para un bodysize solo se carga esa talla
			IF ai_talla > 0 THEN
				IF ai_talla = li_talla THEN
			
					INSERT INTO temp_referen_n
						(usuario, 
						 cs_ordenpd_pt, 
						 po, 
						 co_fabrica, 
						 co_linea, 
						 co_referencia, 
						 co_color,
						 co_talla, 
						 unid_prog, 
						 unid_liberadas, 
						 porc_particip, 
						 sw_marca,
						 nu_cut)
					VALUES (
						:ls_usuario, 
						:ll_ordenpd_pt, 
						:ls_po, 
						:li_co_fabrica, 
						:li_co_linea,
						:ll_co_referencia, 
						:ll_color, 
						:li_talla, 
						//:ll_ca_programada, 
						:ll_total_color_bdsize,
						:ll_ca_liberadas, 
						:ldc_porc_partic, 
						:li_marca,
						:ls_cut);
					IF SQLCA.SQLCODE <> 0 THEN
						ls_error = SQLCA.SQLErrText
						Rollback;
						CLOSE(w_retroalimentacion)
						MessageBox('Error', 'Se produjo error insertando referencias segun tela bodega: ' + string(ls_error))
						Return -1;
					END IF
				END IF
				
			ELSE
				INSERT INTO temp_referen_n
						(usuario, 
						 cs_ordenpd_pt, 
						 po, 
						 co_fabrica, 
						 co_linea, 
						 co_referencia, 
						 co_color,
						 co_talla, 
						 unid_prog, 
						 unid_liberadas, 
						 porc_particip, 
						 sw_marca,
						 nu_cut)
					VALUES (
						:ls_usuario, 
						:ll_ordenpd_pt, 
						:ls_po, 
						:li_co_fabrica, 
						:li_co_linea,
						:ll_co_referencia, 
						:ll_color, 
						:li_talla, 
						:ll_total_color_bdsize,
						//:ll_ca_programada, 
						:ll_ca_liberadas, 
						:ldc_porc_partic, 
						:li_marca,
						:ls_cut);
					IF SQLCA.SQLCODE <> 0 THEN
						ls_error = SQLCA.SQLErrText
						Rollback;
						CLOSE(w_retroalimentacion)
						MessageBox('Error', 'Se produjo error insertando referencias segun tela bodega: ' + string(ls_error))
						Return -1;
					END IF
			END IF
		NEXT
	END IF
END IF

IF ll_result = 0 THEN
	//No se encontr$$HEX2$$f3002000$$ENDHEX$$tela, se verifican unos datos para cargarlos al log de problemas
	ls_descripcion = 'No encontro Referencias, colores y tallas. '
	of_cargar_log_problemas(ls_descripcion,ll_ordenpd_pt,ls_po,ll_co_referencia,ll_color,0,0,0,0,2)
END IF

COMMIT;

Destroy lds_refer_exp
Destroy lds_refer_nal
CLOSE(w_retroalimentacion)

IF ll_result = 0 THEN
	MessageBox('Advertencia','No se encontro Referencias, se aborta el proceso, revise el log de problemas')
	Return -1
ELSE
	Return 0
END IF
end function

public function long of_referenciacritica (long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color);//metodo para determinar si una referencia de linea esta dentro de las criticas.
//jcrm
//enero 30 de 2008
Long li_count, li_ano, li_semana
n_cts_constantes_tela luo_tela

//se determina el a$$HEX1$$f100$$ENDHEX$$o y semana a la que pertenece la fecha de hoy
li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')

SELECT count(*)
  INTO :li_count
  FROM t_criticas_cedi
 WHERE co_fabrica    = :ai_fab AND
 		 co_linea		= :ai_lin AND
		 co_referencia	= :al_ref AND
		 //co_talla		= :ai_talla AND
		 co_color		= :al_color AND
		 ano				= :li_ano AND
		 semana			= :li_semana;

IF sqlca.sqlcode = -1 Then
	Return -1
END IF

IF li_count > 0 THEN
	Return 0 //referencia esta creada en las criticas
ELSE
	Return 100
END IF


end function

public function long of_validar_modelos_completos (long li_fabrica, long li_linea, long ll_referencia, long ll_color, long ll_ordenpd_pt, string ls_usuario);// validar que los modelos que se van a liberar si sean los mismos modelos de la ficha
Long	li_modelos_ficha, li_modelos_liberar
DataStore  lds_total_modelos_ficha


lds_total_modelos_ficha = Create DataStore
lds_total_modelos_ficha.DataObject = 'ds_total_modelos_ficha'
lds_total_modelos_ficha.SetTransObject(sqlca)


//Se crea para verificar los modelos antes de cargar a las tablas de la liberacion, se verifica
//que el total de modelos de la ficha sea igual al total de modelos a cargar mayo 26-2006


li_modelos_ficha = lds_total_modelos_ficha.Retrieve(li_fabrica,li_linea,ll_referencia,ll_color)
	SELECT COUNT(Distinct co_modelo)
	INTO :li_modelos_liberar
	FROM temp_modelos_ref
	WHERE usuario = :ls_usuario
	AND cs_ordenpd_pt = :ll_ordenpd_pt
	AND co_color = :ll_color;

IF li_modelos_ficha <> li_modelos_liberar THEN
//	MessageBox('Error','El total de modelos a liberar es diferente al total de modelos de la ficha, Verifique en el boton Unid x Modelo.')
	Return -1 
END IF
Return 1
end function

public function long of_no_rectilineos (long ai_fabri, long al_liber, long al_color, long al_mode, decimal ad_mtstotal, decimal ad_mtslibera, long al_unds_trazo);Long ll_fila1,ll_result,ll_fila2,ll_fila,ll_unid_libera,ll_orden,ll_reftel,ll_rollo,&
     ll_refer,ll_model,ll_count,ll_result1, ll_fin,ll_unidades,  ll_unid_model, ll_color, ll_color_pt, ll_color_tela
decimal ld_total_mts,ld_metros_libera,ld_metros_pend,ld_mts,ldc_mts,ld_unidades_pend,&
        ld_mts_insertar 
int li_fab,li_caract,li_diametro,li_estadodisp,li_centroterm,&
    li_fab_p,li_linea,li_fab_tela,li_fabr,li_lib,li_fab_pt,&
	 li_talla,li_sw
string ls_usuario,ls_instancia,ls_orden,ls_cut,ls_tono,ls_error
datetime ldt_fecha
Decimal{5} ldc_consumo, ldc_participacion, ldc_metros_libera
datastore lds_rollos_libera,lds_m_rollo, lds_temporal
n_cts_constantes luo_constantes

luo_constantes = CREATE n_cts_constantes

lds_rollos_libera = CREATE Datastore
lds_m_rollo 		= CREATE datastore
lds_temporal		= CREATE datastore

lds_rollos_libera.Dataobject  = 'ds_dt_rollos_libera_semiauto'
lds_m_rollo.dataobject			= 'ds_m_rollo'
lds_temporal.DataObject       = 'ds_temporal_trazo_unidades'

lds_rollos_libera.settransobject(sqlca)
lds_m_rollo.settransobject(sqlca)
lds_temporal.settransobject(sqlca)
	
ls_usuario   = gstr_info_usuario.codigo_usuario	
ls_instancia = gstr_info_usuario.instancia
ldt_fecha    = f_fecha_servidor()
			
li_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF li_estadodisp = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el estado de los rollos.')
	RETURN -1
END IF

li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
IF li_centroterm = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el centro de los rollos.')
	Return -1
END IF
			
//se comparan los metros totales del trazo con
//los metros totales de la liberacion
IF ad_mtstotal > ad_mtslibera THEN//los metros del trazo son mayores a los de las unds liberadas
	                               //hay que buscar en bodega si hay tela
	ld_metros_pend = ad_mtstotal - ad_mtslibera   	
	ll_result = lds_rollos_libera.retrieve(ai_fabri,al_liber,al_color,al_mode)
	
	//no hay rollos, se debe recalcular las unidades hacia abajo
	IF ll_result = 0 THEN
		//recorro la temporal por usuario, modelo
		ll_fin = lds_temporal.Retrieve(ls_usuario,al_mode)
		FOR ll_fila1 = 1 TO ll_fin
			ldc_participacion = lds_temporal.GetItemNumber(ll_fila1,'participacion')
			ldc_consumo   = lds_temporal.GetItemNumber(ll_fila1,'consumo')
			li_talla      = lds_temporal.GetItemNumber(ll_fila1,'co_talla')
			ll_unidades = (ad_mtslibera/ldc_consumo) * ldc_participacion
    			
			UPDATE temporal_trazo
			   SET unidades = :ll_unidades
			 WHERE usuario = :ls_usuario AND
			       modelo    = :al_mode AND
					 co_talla  = :li_talla;
					 
			IF sqlca.sqlcode = -1 THEN
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error','No fue posible recalcular las unidades. '+ls_error)
				RETURN -1
			END IF
		NEXT
	END IF
	//se recorren las filas de dt_rollos_libera
	FOR ll_fila1 = 1 TO ll_result
		ls_orden 		= lds_rollos_libera.getitemstring(ll_fila1,'nu_orden')
		ls_cut 			= lds_rollos_libera.getitemstring(ll_fila1,'nu_cut')
		li_fab_pt		= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_pt')
		li_linea  		= lds_rollos_libera.getitemnumber(ll_fila1,'co_linea')
		ll_refer 		= lds_rollos_libera.getitemnumber(ll_fila1,'co_referencia')
		ll_color_pt 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_pt')
		ls_tono			= lds_rollos_libera.getitemstring(ll_fila1,'co_tono')
		li_fab_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_tela')
		ll_reftel		= lds_rollos_libera.getitemnumber(ll_fila1,'co_reftel')	
		li_caract		= lds_rollos_libera.getitemnumber(ll_fila1,'co_caract')
		li_diametro		= lds_rollos_libera.getitemnumber(ll_fila1,'diametro')
		ll_color_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_tela')
					
		ll_result1 = lds_m_rollo.retrieve(ls_orden,ai_fabri,ll_reftel,li_caract,li_diametro,ll_color_tela,li_estadodisp,li_centroterm )
		
		IF ll_result1>0 THEN//hay rollos por liberar
			//se recorre m_rollo  
			FOR ll_fila2 =1 TO ll_result1
				ld_mts = lds_m_rollo.getitemnumber(ll_fila2,'ca_mts')
				ll_rollo = lds_m_rollo.getitemnumber(ll_fila2,'cs_rollo')
				
				SELECT nvl(dt_consumo_rollos.ca_metros,0)  
				INTO :ldc_mts 
				FROM dt_consumo_rollos  
				WHERE dt_consumo_rollos.cs_rollo = :ll_rollo;
						
				ld_mts -= ldc_mts
					
				//si el rollo tiene tela disponible se usa
				IF ld_mts > 0 THEN
					//cargamos dt_rollos_libera y dt_consumo_rollos, pero antes debemos averiguar cuantos metros
					//son los que necesitamos liberar para cumplir las unidades.
					
					IF ld_metros_pend > ld_mts THEN
						//inserto el rollo en el campo metros con la variable ld_mts, actualizo los metros pendientes
						ld_metros_pend =- ld_mts
						ld_mts_insertar = ld_mts
					ELSE
						//inserto el rollo en el campo metros con la variable ld_metros_pend, actualizo los metros pendientes
						 ld_mts_insertar = ld_metros_pend
						 ld_metros_pend = 0
						 ll_fila2 = ll_result1 +1
						 ll_fila1 = lds_rollos_libera.rowcount() +1
					END IF
					
					INSERT INTO dt_rollos_libera  
								( co_fabrica_exp,   
								  cs_liberacion,   
								  nu_orden,   
								  nu_cut,   
								  co_fabrica_pt,   
								  co_linea,   
								  co_referencia,   
								  co_color_pt,   
								  co_tono,   
								  co_modelo,   
								  co_fabrica_tela,   
								  co_reftel,   
								  co_caract,   
								  diametro,   
								  co_color_tela,   
								  cs_rollo,   
								  ca_metros,   
								  ca_unidades,   
								  usuario,   
								  instancia,   
								  fe_creacion,   
								  fe_actualizacion )  
					  VALUES (:ai_fabri,
								:al_liber,
								:ls_orden,   
								:ls_cut,   
								:li_fab_pt,   
								:li_linea,   
								:ll_refer,   
								:ll_color_pt,   
								:ls_tono,   			  
								:al_mode,
								:li_fab_tela,  
								:ll_reftel,
								:li_caract,
								:li_diametro,
								:ll_color_tela,   
								:ll_rollo,
								:ld_mts_insertar,   
								0,   
								:ls_usuario, 
								:ls_instancia,
								:ldt_fecha,   
								:ldt_fecha)  ;
								
						IF sqlca.sqlcode <> 0 THEN
							ls_error = Sqlca.SqlErrText
							ROLLBACK;
							MessageBox('Error of_norect','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_rollos_libera' + ls_error)
							RETURN -1
						ELSE
							SElECT count(*)
							  INTO :ll_count
							  FROM dt_rollos_libera
							 WHERE cs_liberacion = :al_liber AND
									 cs_rollo = :ll_rollo AND
									 ca_metros = 0 AND
									 ca_unidades = 0;
									 
							IF ll_count = 1 THEN
								Rollback;
								MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
								Return -1
							END IF
						END IF	
						
						//actualizo el consumo del rollo
						SELECT count(*)
						  INTO :ll_count
						  FROM dt_consumo_rollos
						 WHERE cs_rollo = :ll_rollo; 
							 
						If ll_count > 0 THEN
							//actualizo
							UPDATE dt_consumo_rollos
								SET ca_metros= ca_metros + :ld_mts_insertar ,
									 fe_actualizacion = :ldt_fecha,
									 usuario = :ls_usuario,
									 instancia = :gstr_info_usuario.instancia
							 WHERE cs_rollo = :ll_rollo; 
							 
							 If sqlca.sqlcode <> 0 Then
								 ls_error = Sqlca.SqlErrText
								 Rollback;
								 MessageBox('Error of_norect','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los metros en dt_consumo_rollos' + ls_error)
								 Return -1
							 End if
						Else
							//inserto
							INSERT INTO dt_consumo_rollos  
							( cs_rollo,   
							  ca_metros,   
							  ca_unidades,   
							  fe_creacion,   
							  fe_actualizacion,   
							  usuario,   
							  instancia )  
								VALUES 
							( :ll_rollo,   
							  :ld_mts_insertar ,   
							  0,   
							  :ldt_fecha,   
							  :ldt_fecha,   
							  :ls_usuario,   
							  :ls_instancia )  ;
				
							If sqlca.sqlcode <> 0 Then
								 ls_error = Sqlca.SqlErrText
								 Rollback;
								 MessageBox('Error of_norect','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar las unidades en dt_consumo_rollos'+ ls_error)
								 Return -1
							End if
					End if
				END IF
			NEXT
		END IF
	NEXT
	//en este punto se debe preguntar por los metros pendientes si estos son mayores a cero
	//es porque no se pudo traer de la bodega todos los metros necesarios, por lo tanto
	//es necesario recalcular las unidades que se pueden realizar con los metros que se colocaron
	//en la liberacion
	IF ld_metros_pend > 0 THEN
		ll_fin = lds_temporal.Retrieve(ls_usuario,al_mode)
		
		//traigo los metros que pude cargar en la liberacion
		SELECT sum(dt_rollos_libera.ca_metros ) 
		 INTO :ldc_metros_libera 
		 FROM dt_rollos_libera  
		WHERE dt_rollos_libera.co_fabrica_exp = :ai_fabri  AND  
				dt_rollos_libera.cs_liberacion = :al_liber  AND  
				dt_rollos_libera.co_color_pt = :al_color  AND  
				dt_rollos_libera.co_modelo = :al_mode  ;
				
		IF sqlca.sqlcode = -1 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','No fue posible establecer los metros. '+ls_error)
			RETURN -1
		END IF		
	
		FOR ll_fila1 = 1 TO ll_fin
			ldc_participacion = lds_temporal.GetItemNumber(ll_fila1,'participacion')
			ldc_consumo   = lds_temporal.GetItemNumber(ll_fila1,'consumo')
			li_talla      = lds_temporal.GetItemNumber(ll_fila1,'co_talla')
			ll_unidades = (ldc_metros_libera/ldc_consumo) * ldc_participacion
			
			UPDATE temporal_trazo
			   SET unidades = :ll_unidades
			 WHERE usuario = :ls_usuario AND
			       modelo    = :al_mode AND
					 co_talla  = :li_talla;
					 
			IF sqlca.sqlcode = -1 THEN
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error','No fue posible recalcular las unidades. '+ls_error)
				RETURN -1
			END IF
		NEXT
	END IF
ELSE//los metros del trazo son menores a los de las unds liberadas
	ld_metros_pend =  ad_mtslibera - ad_mtstotal
	of_metros_devueltos(ai_fabri,al_liber,al_color,al_mode,ld_metros_pend,al_unds_trazo)
END IF

destroy lds_rollos_libera 
destroy lds_m_rollo

return 0
end function

public function long of_metros_devueltos (long ai_fabr, long al_lib, long al_color, long al_model, decimal ad_mts, long al_totunds_trazo);LONG ll_fila1,ll_refer,ll_reftel,ll_result,ll_orden,ll_unidades,ll_rollo, ll_count, li_color_pt, li_color_tela
INT li_fab_pt,li_linea,li_caract,li_diametro,li_fab,li_estadodisp,&
    li_centroterm,li_fab_tela,li_sw
STRING ls_orden,ls_cut,ls_tono,ls_error
DECIMAL {4} ld_metros,ld_ca_mts
datastore lds_rollos_libera
n_cts_constantes luo_constantes

lds_rollos_libera = CREATE Datastore
lds_rollos_libera.Dataobject = 'ds_dt_rollos_libera_semiauto'
lds_rollos_libera.settransobject(sqlca)

ll_result = lds_rollos_libera.retrieve(ai_fabr,al_lib,al_model)
	
//se recorren las filas de dt_rollos_libera
FOR ll_fila1 = 1 TO ll_result
	ls_orden 		= lds_rollos_libera.getitemstring(ll_fila1,'nu_orden')
	ls_cut 			= lds_rollos_libera.getitemstring(ll_fila1,'nu_cut')
	li_fab_pt		= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_pt')
	li_linea  		= lds_rollos_libera.getitemnumber(ll_fila1,'co_linea')
	ll_refer 		= lds_rollos_libera.getitemnumber(ll_fila1,'co_referencia')
	li_color_pt 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_pt')
	ls_tono			= lds_rollos_libera.getitemstring(ll_fila1,'co_tono')
	li_fab_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_fabrica_tela')
	ll_reftel		= lds_rollos_libera.getitemnumber(ll_fila1,'co_reftel')	
	li_caract		= lds_rollos_libera.getitemnumber(ll_fila1,'co_caract')
	li_diametro		= lds_rollos_libera.getitemnumber(ll_fila1,'diametro')
	li_color_tela 	= lds_rollos_libera.getitemnumber(ll_fila1,'co_color_tela')
	ld_metros		= lds_rollos_libera.getitemnumber(ll_fila1,'ca_metros')
	ll_unidades		= lds_rollos_libera.getitemnumber(ll_fila1,'ca_unidades')
	ll_rollo       = lds_rollos_libera.getitemnumber(ll_fila1,'cs_rollo')
	
	IF ad_mts > ld_metros THEN//los metros liberados pendientes son mayores a los metros liberados 
		//eliminar el rollo de dt_rollos_libera
		DELETE FROM dt_rollos_libera  
		WHERE ( dt_rollos_libera.co_fabrica_exp 	= :ai_fabr ) AND  
				( dt_rollos_libera.cs_liberacion 	= :al_lib ) AND  
				( dt_rollos_libera.nu_orden 			= :ls_orden  ) AND  
				( dt_rollos_libera.nu_cut 				= :ls_cut ) AND  
				( dt_rollos_libera.co_fabrica_pt 	= :li_fab_pt) AND  
				( dt_rollos_libera.co_linea 			= :li_linea) AND  
				( dt_rollos_libera.co_referencia 	= :ll_refer ) AND  
				( dt_rollos_libera.co_color_pt 		= :li_color_pt ) AND  
				( dt_rollos_libera.co_tono 			= :ls_tono ) AND  
				( dt_rollos_libera.co_modelo 			= :al_model ) AND  
				( dt_rollos_libera.co_fabrica_tela 	= :li_fab_tela) AND  
				( dt_rollos_libera.co_reftel 			= :ll_reftel) AND  
				( dt_rollos_libera.co_caract 			= :li_caract ) AND  
				( dt_rollos_libera.diametro 			= :li_diametro ) AND  
				( dt_rollos_libera.co_color_tela 	= :li_color_tela ) AND  
				( dt_rollos_libera.cs_rollo 			= :ll_rollo ) ;
			
		IF sqlca.sqlcode <> 0 THEN
			 ls_error = Sqlca.SqlErrText
			 ROLLBACK;
			 MessageBox('Error of_mtsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar registro en dt_rollos_libera' + ls_error)
			 RETURN -1
		END IF
			
		//disminuir ld_mts en dt_consumo_rollo
	   UPDATE dt_consumo_rollos  
		  SET ca_metros = ca_metros - :ld_metros
		WHERE dt_consumo_rollos.cs_rollo = :ll_rollo ;
      
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			ROLLBACK;
			MessageBox('Error of_mtsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los metros en dt_consumo_rollos' + ls_error)
			RETURN -1
		END IF
		
		SELECT ca_metros
		INTO :ld_ca_mts
		FROM  dt_consumo_rollos 
		WHERE dt_consumo_rollos.cs_rollo = :ll_rollo;
		
		IF ld_ca_mts<0 THEN
			UPDATE dt_consumo_rollos  
		   SET    ca_metros = 0
		   WHERE dt_consumo_rollos.cs_rollo = :ll_rollo ;
			
			IF sqlca.sqlcode <> 0 THEN
				ls_error = Sqlca.SqlErrText
				ROLLBACK;
				MessageBox('Error of_mtsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los metros en dt_consumo_rollos' + ls_error)
				RETURN -1
		   END IF
		END IF
		
		//se actualiza m_rollo. 
	  	UPDATE m_rollo  
		  SET cs_ordencr = 0, co_estado_rollo = 2  
		WHERE m_rollo.cs_rollo = :ll_rollo;
			
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			ROLLBACK;
			MessageBox('Error of_mtsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado en m_rollo' + ls_error)
			RETURN -1
		END IF
			
	ELSE//los metros liberados pendientes son menores a los metros liberados 
		//actualizar mts de dt_rollos_libera
		UPDATE dt_rollos_libera  
		SET ca_metros = ca_metros - :ad_mts
		WHERE ( dt_rollos_libera.co_fabrica_exp 	= :ai_fabr ) AND  
				( dt_rollos_libera.cs_liberacion 	= :al_lib ) AND  
				( dt_rollos_libera.nu_orden 			= :ls_orden  ) AND  
				( dt_rollos_libera.nu_cut 				= :ls_cut ) AND  
				( dt_rollos_libera.co_fabrica_pt 	= :li_fab_pt) AND  
				( dt_rollos_libera.co_linea 			= :li_linea) AND  
				( dt_rollos_libera.co_referencia 	= :ll_refer ) AND  
				( dt_rollos_libera.co_color_pt 		= :li_color_pt ) AND  
				( dt_rollos_libera.co_tono 			= :ls_tono ) AND  
				( dt_rollos_libera.co_modelo 			= :al_model ) AND  
				( dt_rollos_libera.co_fabrica_tela 	= :li_fab_tela) AND  
				( dt_rollos_libera.co_reftel 			= :ll_reftel) AND  
				( dt_rollos_libera.co_caract 			= :li_caract ) AND  
				( dt_rollos_libera.diametro 			= :li_diametro ) AND  
				( dt_rollos_libera.co_color_tela 	= :li_color_tela ) AND  
				( dt_rollos_libera.cs_rollo 			= :ll_rollo ) ;
		
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			ROLLBACK;
			MessageBox('Error of_mtsdev','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar los metros en dt_rollos_libera' + ls_error)
			RETURN -1
		ELSE
			SElECT count(*)
			  INTO :ll_count
			  FROM dt_rollos_libera
			 WHERE cs_liberacion = :al_lib AND
					 cs_rollo = :ll_rollo AND
					 ca_metros = 0 AND
					 ca_unidades = 0;
					 
			IF ll_count = 1 THEN
				Rollback;
				MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
				Return -1
			END IF
		END IF
		
		//actualizar los mts en dt_consumo_rollo
		UPDATE dt_consumo_rollos  
		  SET ca_metros = ca_metros - :ad_mts
		WHERE dt_consumo_rollos.cs_rollo = :ll_rollo ;
			
		ll_fila1 = lds_rollos_libera.rowcount()+1
	END IF	
NEXT
//COMMIT;
DESTROY lds_rollos_libera
RETURN 0
end function

public function long of_recalcularunidadesmin (long al_ordenpd_pt, long al_color, string as_po, decimal adc_ancho, long al_tanda, long al_reftel, long ai_tipo_lib, string as_color_exp, long al_op_agrupada);//funciono para colocar el numero maximo de unidades a liberar, de acuerdo
//a la minima cantidad de alguna de las rayas.
String ls_usuario, ls_po, ls_error, ls_descripcion
Long ll_result, ll_fila, ll_liberar, ll_liberadas, ll_programado, ll_valor,ll_unid_modelo_unica,&
     ll_vlr_constante, ll_ref,ll_unid_mas_liberar,ll_tope_liberar, ll_fila1, ll_count,&
	  ll_modelo, ll_reftel, ll_uni_min, ll_unid, ll_mod_min, ll_result1, ll_fila2, ll_result2, ll_fila3,&
	  ll_modelo_old, ll_modelo_new,ll_result3, ll_result4, ll_tanda_new, ll_tanda_varios_mod, ll_tanda_varios_mod_dif_color
Long ll_color, ll_color_te
Long li_talla, li_fab, li_lin, li_result, li_marca, li_return, li_actualizo, li_tot_modelos, li_existe, li_marca_new,li_result5
Decimal{4} ldc_porc_liberar, ldc_porcentaje, ld_ancho_varios_mod_dif_col, ld_ancho_temporal
Boolean lb_usar_tanda
DataStore lds_modelo_10, lds_modelo_no10_tela_nocolor,lds_modelo_no10_notela_color, lds_modelo_no10_notela_nocolor,&
          lds_modelo_no10_tela_color_noancho, lds_modelo_no10_tela_color_ancho
n_cts_constantes luo_constantes
n_cts_cargar_temporales_liberacion luo_liberacion

luo_constantes = Create n_cts_constantes
//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Buscando la menor cantidad por Raya ..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)             

ls_usuario = gstr_info_usuario.codigo_usuario

lds_modelo_10 			  					= Create DataStore
lds_modelo_no10_tela_nocolor 		  	= Create DataStore
lds_modelo_no10_notela_color 			= Create DataStore
lds_modelo_no10_notela_nocolor 		= Create DataStore
lds_modelo_no10_tela_color_noancho 	= Create DataStore
lds_modelo_no10_tela_color_ancho 	= Create DataStore

lds_modelo_10.DataObject 			 				 = 'ds_temp_modelos_recalculo_10' //raya10
lds_modelo_no10_tela_nocolor.DataObject 		 = 'ds_temp_rec_no10_tela_nocolor' //raya <> 10 e igual tela
lds_modelo_no10_notela_color.DataObject 		 = 'ds_temp_modelos_rec_no10_notela_color' //raya <> 10 y <> tela y mismo color
lds_modelo_no10_notela_nocolor.DataObject 	 = 'ds_temp_modelos_rec_no10_notela_nocolor' //raya <> 10, diferente tela y diferente color
lds_modelo_no10_tela_color_noancho.DataObject = 'ds_temp_rec_no10_tela_color_noancho'
lds_modelo_no10_tela_color_ancho.DataObject 	 = 'ds_temp_rec_no10_tela_color_ancho'

lds_modelo_10.SetTransObject(sqlca)
lds_modelo_no10_tela_nocolor.SetTransObject(sqlca)
lds_modelo_no10_notela_color.SetTransObject(sqlca)
lds_modelo_no10_notela_nocolor.SetTransObject(sqlca)
lds_modelo_no10_tela_color_noancho.SetTransObject(sqlca)
lds_modelo_no10_tela_color_ancho.SetTransObject(sqlca)

//se marca la bandera para cargar datos de la liberaci$$HEX1$$f300$$ENDHEX$$n en cero, es decir que solo se pueden coger
//los registros con marca igual a 1
UPDATE temp_modelos_ref
	SET sw_carga = 0
 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
		 usuario 		= :ls_usuario  ;  
COMMIT;		 
		 
IF SQLCA.SQLCODE <> 0 THEN
	CLOSE(w_retroalimentacion)
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error', 'Se produjo un error al momento de inicializar la marca de liberaci$$HEX1$$f300$$ENDHEX$$n ' + ls_error)
	Return -1;
END IF

//se debe validar si es tela comprada o blancos de la lineas 6 $$HEX2$$f3002000$$ENDHEX$$23, si es asi
//no se debe validar la tanda, de lo contrario es necesaria validar la tanda
li_return = luo_liberacion.of_buscar_tipo_tela_tono_col(al_color,al_ordenpd_pt,al_reftel)

If li_return = 1 Then
	//no se debe validar tanda
	ll_tanda_new = 0
	lb_usar_tanda = False 
Else
	//es necesario validar la tanda
	ll_tanda_new = al_tanda
	lb_usar_tanda = True
End if

ll_tanda_varios_mod_dif_color = 0
ll_tanda_varios_mod = 0
//primero se debe recorrer las tallas de la liberacion
//Se modifica para que siempre valide la tanda en la raya 10, por caso de op de blanco y con varias tandas en el mismo ancho en raya 10,  abril28
ll_result = lds_modelo_10.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,adc_ancho,al_tanda)
For ll_fila = 1 To ll_result
	li_talla 		= lds_modelo_10.GetItemNumber(ll_fila,'co_talla')
	li_fab			= lds_modelo_10.GetItemNumber(ll_fila,'co_fabrica')
	li_lin			= lds_modelo_10.GetItemNumber(ll_fila,'co_linea')
	ll_ref			= lds_modelo_10.GetItemNumber(ll_fila,'co_referencia')
	ll_color_te    = lds_modelo_10.GetItemNumber(ll_fila,'co_color_te')
	ll_reftel		= lds_modelo_10.GetItemNumber(ll_fila,'co_reftel')
	ll_uni_min 		= lds_modelo_10.GetItemNumber(ll_fila,'unid_liberar')

	
	//modelos diferente al principal en la misma tela y diferente color
	ll_result4 = lds_modelo_no10_tela_nocolor.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ll_color_te,ll_reftel,li_talla)
	For ll_fila2 = 1 To ll_result4
		ll_liberar = lds_modelo_no10_tela_nocolor.GetItemNumber(ll_fila2,'unid_liberar')		
		If ll_liberar < ll_uni_min Then
			ll_uni_min = ll_liberar
		End if
	Next
	//modelos diferentes del principal en la misma tela mismo color y mismo ancho
   ll_result1 = lds_modelo_no10_tela_color_ancho.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ll_tanda_new,ll_color_te,ll_reftel,li_talla,adc_ancho)
	For ll_fila2 = 1 To ll_result1
		ll_liberar = lds_modelo_no10_tela_color_ancho.GetItemNumber(ll_fila2,'unid_liberar')		
		If ll_liberar < ll_uni_min Then
			ll_uni_min = ll_liberar
		End if
	Next

   If ll_result1 > 0 Then
		li_marca = 1//se actualizan los del mismo color mismo ancho
	//////////////////////////////Else     --probar si funciona para ref con varios modelos con la misma tela-color igual y dif ancho (estampados)jorodrig 15052013
	END IF  //jorodrig 15052013
		//modelos diferentes al principal en la misma tela mismo color y diferente ancho
	   ////ll_result1 = lds_modelo_no10_tela_color_noancho.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ll_tanda_new,ll_color_te,ll_reftel,li_talla,adc_ancho) //jorodrig 15052013
		li_result5 = lds_modelo_no10_tela_color_noancho.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ll_tanda_new,ll_color_te,ll_reftel,li_talla,adc_ancho)
	//	For ll_fila2 = 1 To ll_result1   ////jorodrig 15052013
		For ll_fila2 = 1 To li_result5
			ll_liberar = lds_modelo_no10_tela_color_noancho.GetItemNumber(ll_fila2,'unid_liberar')		
			If ll_liberar < ll_uni_min Then
				ll_uni_min = ll_liberar
			End if
			li_marca_new = 2//se actualizan los del mismo color diferente ancho
		Next
		
	/////////////////////////////End if  jorodrig 15052013
   //modelos diferentes al principal diferente tela y mismo color y telas compradas diferentes a la 10 en el mismo color y diferente tanda
	ll_result2 = lds_modelo_no10_notela_color.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ll_reftel,li_talla,ll_color_te,ll_tanda_new)
	ll_modelo_old = 0 
	For ll_fila3 = 1 To ll_result2
		ll_liberar = lds_modelo_no10_notela_color.GetItemNumber(ll_fila3,'unid_liberar')	
		ll_modelo_new = lds_modelo_no10_notela_color.GetItemNumber(ll_fila3,'co_modelo')
		If ll_modelo_new = ll_modelo_old Then
		//	ll_fila3 += 1   se coloca en comentario porque estaba causando problemas cuando se tenian varios anchos en un mismo modelo con diferentes unidades, colocaba el de menos unidades   jorodrig jcrestme marzo6-08
		Else
			ll_modelo_old = lds_modelo_no10_notela_color.GetItemNumber(ll_fila3,'co_modelo')
			If ll_liberar < ll_uni_min Then
				ll_uni_min = ll_liberar
			End if
		End if
	Next
   //modelos diferentres del principal diferente tela diferente color
   ll_result3 = lds_modelo_no10_notela_nocolor.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ll_reftel,li_talla,ll_color_te)
   ll_modelo_old = 0 
	For ll_fila3 = 1 To ll_result3
		ll_liberar = lds_modelo_no10_notela_nocolor.GetItemNumber(ll_fila3,'unid_liberar')	
		ll_modelo_new = lds_modelo_no10_notela_nocolor.GetItemNumber(ll_fila3,'co_modelo')
		If ll_modelo_new = ll_modelo_old Then
			ll_fila3 += 1
		Else
			ll_modelo_old = lds_modelo_no10_notela_nocolor.GetItemNumber(ll_fila3,'co_modelo')
			If ll_liberar < ll_uni_min Then
				ll_uni_min = ll_liberar
			End if
		End if
	Next

	//ya tenemos el minimo, ahora se debe saber si este minimo mas lo liberado no supera lo pedido
	SELECT unid_prog
	  INTO :ll_programado
	  FROM temp_referen_n
	 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
			 co_talla 		= :li_talla AND
			 co_color		= :al_color AND 
			 po				= :as_po AND
			 usuario 		= :ls_usuario ;
	
	//ya se tiene la cantidad programada, ahora debo saber si le tengo que sumar un porcentaje o un valor
	//a esta cantidad para saber el tope hasta donde puedo liberar
	//********************************se establece el valor a adicionar al pedido original **************
	//traigo el valor de la tabla
	SELECT nvl(tope_min_unid,0)
		  INTO :ll_vlr_constante
		  FROM m_porc_permitido
		 WHERE co_fabrica 	= :li_fab AND
				 co_linea 		= :li_lin AND
				 co_referencia = :ll_ref AND
				 co_color 		= :al_color;

	IF ll_programado < ll_vlr_constante THEN 
		//se debe incrementar al valor del pedido la unidades de m$$HEX1$$e100$$ENDHEX$$s que se tienen en m_porc_permitido para esta
		//referencia-color
		SELECT nvl(unid_adicionar,0)
		  INTO :ll_unid_mas_liberar
		  FROM m_porc_permitido
		 WHERE co_fabrica 	= :li_fab AND
				 co_linea 		= :li_lin AND
				 co_referencia = :ll_ref AND
				 co_color 		= :al_color;
			 
		ll_programado = ll_programado + ll_unid_mas_liberar		 
	ELSE
		SELECT porc_liberar
		  INTO :ldc_porc_liberar
		  FROM m_porc_permitido
		 WHERE co_fabrica 	= :li_fab AND
				 co_linea 		= :li_lin AND
				 co_referencia = :ll_ref AND
				 co_color 		= :al_color;
	
	   IF sqlca.sqlcode = 100 THEN
			ldc_porcentaje = luo_constantes.of_consultar_numerico("PORCENTAJE_LIBERAR")
			IF ldc_porcentaje = -1 THEN
				ldc_porcentaje = 5
			END IF
			ldc_porc_liberar = ldc_porcentaje
		END IF
	
//		IF isnull(ldc_porc_liberar) OR ldc_porc_liberar = 0 THEN 
//			ldc_porcentaje = luo_constantes.of_consultar_numerico("PORCENTAJE_LIBERAR")
//			IF ldc_porcentaje = -1 THEN
//				ldc_porcentaje = 5
//			END IF
//			ldc_porc_liberar = ldc_porcentaje
//		END IF
		ll_unid_mas_liberar = (ll_programado * ldc_porc_liberar) /100
		ll_programado = ll_programado + ll_unid_mas_liberar
	END IF
	
	IF ai_tipo_lib = 1 THEN

		//asigno el valor a liberar
		IF (ll_liberadas + ll_uni_min) > ll_programado THEN
			ll_valor = ll_liberadas + ll_uni_min - ll_programado
			ll_valor = ll_uni_min - ll_valor
			IF ll_valor <= 0 THEN 
				ll_valor = 0
				
				//se carga al log de errores
				ls_descripcion = 'Las unidades estan en 0 En la prenda: ' + string(ll_ref) + ' Color: ' + string(al_color) + ' Talla: ' + string(li_talla) 
				of_cargar_log_problemas(ls_descripcion,al_ordenpd_pt,'',ll_ref,al_color,0,0,0,0,11)
				
			END IF
		ELSE
			ll_valor = ll_uni_min
		END IF		
	ELSE
		IF ll_programado < ll_uni_min THEN
			ll_valor = ll_programado
		ELSE
			ll_valor = ll_uni_min
		END IF
	END IF
	
	//actualizamos la raya 10, en el mismo ancho y tanda.
//	If lb_usar_tanda = True Then//la tanda debe tenerse en cuenta
		UPDATE temp_modelos_ref
			SET unid_real_liberar = :ll_valor,
				 sw_carga = 1
		 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
				 co_talla 		= :li_talla AND
				 co_color		= :al_color AND
				 po				= :as_po AND
				 usuario 		= :ls_usuario AND
				 raya		 		= 10 AND
				 ancho			= :adc_ancho AND
				 cs_tanda      = :al_tanda;  
//	Else//la tanda no debe tenerse en cuenta
//		UPDATE temp_modelos_ref
//			SET unid_real_liberar = :ll_valor,
//				 sw_carga = 1
//		 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
//				 co_talla 		= :li_talla AND
//				 co_color		= :al_color AND
//				 po				= :as_po AND
//				 usuario 		= :ls_usuario AND
//				 raya		 		= 10 AND
//				 ancho			= :adc_ancho;  
//		
//	End if
	
	IF SQLCA.SQLCODE <> 0 THEN
		CLOSE(w_retroalimentacion)
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
		Return -1;
	END IF
	
	If li_marca = 1 Then//se actualizan los del mismo color mismo ancho
	
		//actualizamos las rayas diferentes de 10 y misma tela
		For ll_fila2 = 1 To ll_result1
			If lb_usar_tanda = True Then//la tanda debe tenerse en cuenta	
				UPDATE temp_modelos_ref
					SET unid_real_liberar = :ll_valor,
						 sw_carga = 1
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya 			<> 10 AND
						 cs_tanda      = :al_tanda AND
						 co_color_te   = :ll_color_te AND
						 co_reftel     = :ll_reftel AND
						 ancho         = :adc_ancho;  
			Else//no se debe tener en cuenta la tanda
				UPDATE temp_modelos_ref
					SET unid_real_liberar = :ll_valor,
						 sw_carga = 1
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya 			<> 10 AND
						 co_color_te   = :ll_color_te AND
						 co_reftel     = :ll_reftel AND
						 ancho         = :adc_ancho; 
			End if
			
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
				Return -1;
			END IF
		Next
	END IF    //nuevo para probar la misma tela color anhco y igual y dif anchos jorodrig 15052013
 	If li_marca_new = 2 Then//se actualizan los del mismo color diferente ancho
	//	For ll_fila2 = 1 To ll_result1  //jorodrig 15052013
		For ll_fila2 = 1 To li_result5
			If lb_usar_tanda = True Then//la tanda debe tenerse en cuenta		
				UPDATE temp_modelos_ref
					SET unid_real_liberar = :ll_valor,
						 sw_carga = 1
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya 			<> 10 AND
						 cs_tanda      = :al_tanda AND
						 co_color_te   = :ll_color_te AND
						 co_reftel     = :ll_reftel AND
						 ancho         <> :adc_ancho;  
			Else//no se debe tener en cuenta la tanda
				UPDATE temp_modelos_ref
					SET unid_real_liberar = :ll_valor,
						 sw_carga = 1
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya 			<> 10 AND
						 co_color_te   = :ll_color_te AND
						 co_reftel     = :ll_reftel AND
						 ancho         <> :adc_ancho;  
			End if
			
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
				Return -1;
			END IF
		Next
	End if
	
	//actualizamos las rayas diferentes de 10 en la misma tela y diferente color
	For ll_fila2 = 1 To ll_result4
		If lb_usar_tanda = True Then//la tanda debe tenerse en cuenta			
			UPDATE temp_modelos_ref
				SET unid_real_liberar = :ll_valor,
					 sw_carga = 1
			 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
					 co_talla 		= :li_talla AND
					 co_color		= :al_color AND
					 po				= :as_po AND
					 usuario 		= :ls_usuario AND
					 raya 			<> 10 AND
					// cs_tanda      = :al_tanda AND  coloco comentario por op 56274 que no marca una tela igual a la 10 y diferente color, la tanda no puede ser igual
					 co_color_te   <> :ll_color_te AND
					 co_reftel     = :ll_reftel ;  
		Else//no se debe tener en cuenta la tanda
			UPDATE temp_modelos_ref
				SET unid_real_liberar = :ll_valor,
					 sw_carga = 1
			 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
					 co_talla 		= :li_talla AND
					 co_color		= :al_color AND
					 po				= :as_po AND
					 usuario 		= :ls_usuario AND
					 raya 			<> 10 AND
					 co_color_te   <> :ll_color_te AND
					 co_reftel     = :ll_reftel ;
		End if
		
		IF SQLCA.SQLCODE <> 0 THEN
			CLOSE(w_retroalimentacion)
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
			Return -1;
		END IF
	Next
	
  //modelos diferentes al principal diferente tela y mismo color y telas compradas diferentes a la 10 en el mismo color y diferente tanda
	ll_modelo_old = 0 
	For ll_fila3 = 1 To ll_result2
		li_actualizo = 0
		ll_modelo_new = lds_modelo_no10_notela_color.GetItemNumber(ll_fila3,'co_modelo')
		If ll_modelo_new = ll_modelo_old Then
	//		ll_fila3 += 1
		Else
			ll_modelo_old = lds_modelo_no10_notela_color.GetItemNumber(ll_fila3,'co_modelo')
			If lb_usar_tanda = True Then//la tanda debe tenerse en cuenta
				SELECT MAX(unid_liberar)   //este select se adiciono para que no actualizara varios registros en un mismo modelo y talla   oct 16 -07  jorodrig
				  INTO :ll_unid_modelo_unica
				  FROM temp_modelos_ref
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya		 		<> 10 AND
						 co_modelo     = :ll_modelo_old AND
						 (cs_tanda      = :al_tanda OR cs_tanda = 1) AND
						 co_color_te	= :ll_color_te AND
						 unid_liberar >= :ll_uni_min;
				IF IsNull(ll_unid_modelo_unica) THEN
					SELECT MAX(unid_liberar)   //este select se adiciono para que no actualizara varios registros en un mismo modelo y talla   oct 16 -07  jorodrig
					  INTO :ll_unid_modelo_unica
					  FROM temp_modelos_ref
					 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
							 co_talla 		= :li_talla AND
							 co_color		= :al_color AND
							 po				= :as_po AND
							 usuario 		= :ls_usuario AND
							 raya		 		<> 10 AND
							 co_modelo     = :ll_modelo_old AND
							 co_color_te	= :ll_color_te AND
						 	unid_liberar >= :ll_uni_min;
				END IF
				
				IF IsNull(ll_unid_modelo_unica) THEN ll_unid_modelo_unica = 0
				
				UPDATE temp_modelos_ref
					SET unid_real_liberar = :ll_valor,
						 sw_carga = 1
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya		 		<> 10 AND
						 co_modelo     = :ll_modelo_old AND
						 cs_tanda      = :al_tanda AND
						 co_color_te	= :ll_color_te AND
						 unid_liberar  = :ll_unid_modelo_unica		;
				IF SQLCA.SQLnrows > 0 THEN		 
					li_actualizo = 1		 
				END IF
			Else//no se debe tener en cuenta la tanda
			   SELECT COUNT(*)
				  INTO :li_tot_modelos
				  FROM temp_modelos_ref
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya		 		<> 10 AND
						 co_modelo     = :ll_modelo_old AND
						 co_color_te	= :ll_color_te;
				IF li_tot_modelos > 1 THEN  //no debe actualizar mas de un modelo	
				  //se busca la tanda que libera mas unidades
				   IF ll_tanda_varios_mod = 0 THEN
				  		SELECT cs_tanda
						  INTO :ll_tanda_varios_mod
						  FROM temp_modelos_ref
						 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
								 co_talla 		= :li_talla AND
								 co_color		= :al_color AND
								 po				= :as_po AND
								 usuario 		= :ls_usuario AND
								 raya		 		<> 10 AND
								 co_modelo     = :ll_modelo_old AND
								 co_color_te	= :ll_color_te AND 
								 unid_liberar  = (select max(unid_liberar) from temp_modelos_ref
														where cs_ordenpd_pt = :al_ordenpd_pt and
																co_talla 	  = :li_talla and
																co_color		= :al_color and
																po				= :as_po and
																usuario 		= :ls_usuario and
																raya		 	<> 10 and
																co_modelo   = :ll_modelo_old and
																co_color_te	= :ll_color_te ); 
					END IF
					UPDATE temp_modelos_ref
						SET unid_real_liberar = :ll_valor,
							 sw_carga = 1
					 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
							 co_talla 		= :li_talla AND
							 co_color		= :al_color AND
							 po				= :as_po AND
							 usuario 		= :ls_usuario AND
							 raya		 		<> 10 AND
							 co_modelo     = :ll_modelo_old AND
							 co_color_te	= :ll_color_te AND 
							 cs_tanda      = :ll_tanda_varios_mod;
							 
					 IF SQLCA.SQLnrows > 0 THEN		 
						li_actualizo = 1		 
					END IF	 
				
				ELSE
					UPDATE temp_modelos_ref
						SET unid_real_liberar = :ll_valor,
							 sw_carga = 1
					 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
							 co_talla 		= :li_talla AND
							 co_color		= :al_color AND
							 po				= :as_po AND
							 usuario 		= :ls_usuario AND
							 raya		 		<> 10 AND
							 co_modelo     = :ll_modelo_old AND
							 co_color_te	= :ll_color_te;
					IF SQLCA.SQLnrows > 0 THEN		 
						li_actualizo = 1		 
					END IF	 
				END IF
			End if
			IF SQLCA.SQLCODE <> 0 THEN
				CLOSE(w_retroalimentacion)
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
				Return -1  ;
			END IF
			
			//Tambien hay que actualizar la tela comprada, si no actualizo en los anteriores update el modelo es de tela comprada
			IF li_actualizo  = 0 THEN
				UPDATE temp_modelos_ref
					SET unid_real_liberar = :ll_valor,
						 sw_carga = 1
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya		 		<> 10 AND
						 co_modelo     = :ll_modelo_old AND
						 co_color_te	= :ll_color_te AND
						 (select count(*) from h_telas where co_reftel = temp_modelos_ref.co_reftel
						  and co_caract = temp_modelos_ref.co_caract and sw_comprada = 1) > 0;
				
			END IF
			
		End if
	Next
	
	//actulizamos las rayas diferentes de 10 en diferente tela y diferente color
	ll_modelo_old = 0 
	li_actualizo = 0
	For ll_fila3 = 1 To ll_result3
		ll_modelo_new = lds_modelo_no10_notela_nocolor.GetItemNumber(ll_fila3,'co_modelo')
		li_actualizo = 0 
		If ll_modelo_new = ll_modelo_old Then
		//	ll_fila3 += 1
		Else
			ll_modelo_old = lds_modelo_no10_notela_nocolor.GetItemNumber(ll_fila3,'co_modelo')
			
			   SELECT COUNT(*)
				  INTO :li_tot_modelos
				  FROM temp_modelos_ref
				 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
						 co_talla 		= :li_talla AND
						 co_color		= :al_color AND
						 po				= :as_po AND
						 usuario 		= :ls_usuario AND
						 raya		 		<> 10 AND
						 co_modelo     = :ll_modelo_old AND  
						 co_color_te	<> :ll_color_te;
				IF li_tot_modelos > 1 THEN  //no debe actualizar mas de un modelo	
				  //se busca la tanda que libera mas unidades
				  IF ll_tanda_varios_mod_dif_color = 0 THEN
						SELECT cs_tanda
						  INTO :ll_tanda_varios_mod_dif_color
						  FROM temp_modelos_ref
						 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
								 co_talla 		= :li_talla AND
								 co_color		= :al_color AND
								 po				= :as_po AND
								 usuario 		= :ls_usuario AND
								 raya		 		<> 10 AND
								 co_modelo     = :ll_modelo_old AND
								 co_color_te	<> :ll_color_te AND 
								 unid_liberar  = (select max(unid_liberar) from temp_modelos_ref
							                     where cs_ordenpd_pt = :al_ordenpd_pt and
							                        co_talla 	  = :li_talla and
							                        co_color		= :al_color and
							                        po				= :as_po and
							                        usuario 		= :ls_usuario and
							                        raya		 	<> 10 and
							                        co_modelo   = :ll_modelo_old and
							                        co_color_te	<> :ll_color_te ); 
			//Vamos a mirar si aca solo encontro un registro con la tanda que trae, pues puede pasar
			//que sea una misma tanda pero con diferentes anchos (tela comprada con tanda 1)
						SELECT COUNT(*)
						  INTO :li_existe
						  FROM temp_modelos_ref
						 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
								 co_talla 		= :li_talla AND
								 co_color		= :al_color AND
								 po				= :as_po AND
								 usuario 		= :ls_usuario AND
								 raya		 		<> 10 AND
								 co_modelo     = :ll_modelo_old AND
								 co_color_te	<> :ll_color_te AND  
								 cs_tanda      = :ll_tanda_varios_mod_dif_color;
						IF li_existe > 1 THEN  //hay varios anchos para la misma tanda, se toma solo uno
							SELECT MAX(ancho)
						     INTO :ld_ancho_varios_mod_dif_col
						     FROM temp_modelos_ref
						    WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
								    co_talla 		= :li_talla AND
									 co_color		= :al_color AND
									 po				= :as_po AND
									 usuario 		= :ls_usuario AND
									 raya		 		<> 10 AND
									 co_modelo     = :ll_modelo_old AND
									 co_color_te	<> :ll_color_te AND 
									 cs_tanda      = :ll_tanda_varios_mod_dif_color ; 
							UPDATE temp_modelos_ref
								SET unid_real_liberar = :ll_valor,
									 sw_carga = 1
							 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
									 co_talla 		= :li_talla AND
									 co_color		= :al_color AND
									 po				= :as_po AND
									 usuario 		= :ls_usuario AND
									 raya		 		<> 10 AND
									 co_modelo     = :ll_modelo_old AND
									 co_color_te	<> :ll_color_te AND 
									 cs_tanda      = :ll_tanda_varios_mod_dif_color AND
									 ancho         = :ld_ancho_varios_mod_dif_col;
							 IF SQLCA.SQLnrows > 0 THEN		 
								li_actualizo = 1		 
							 END IF
						END IF
						
					END IF
					IF li_actualizo = 0 THEN
						IF ld_ancho_varios_mod_dif_col >  0 THEN
							UPDATE temp_modelos_ref
		 					   SET unid_real_liberar = :ll_valor,
									 sw_carga = 1
							 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
									 co_talla 		= :li_talla AND
									 co_color		= :al_color AND
									 po				= :as_po AND
									 usuario 		= :ls_usuario AND
									 raya		 		<> 10 AND
									 co_modelo     = :ll_modelo_old AND
									 co_color_te	<> :ll_color_te AND 
									 cs_tanda      = :ll_tanda_varios_mod_dif_color AND
									 ancho         = :ld_ancho_varios_mod_dif_col;
							IF sqlca.sqlnrows = 0 THEN  //se adiciona esta condicion para modelos que tienen la misma tanda pero en diferente ancho
								SELECT MAX(ancho)
								  INTO :ld_ancho_temporal
								  FROM temp_modelos_ref
							    WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
									    co_talla 		= :li_talla AND
									    co_color		= :al_color AND
									    po				= :as_po AND
									    usuario 		= :ls_usuario AND
									    raya		 		<> 10 AND
									    co_modelo     = :ll_modelo_old AND
									    co_color_te	<> :ll_color_te AND 
									    cs_tanda      = :ll_tanda_varios_mod_dif_color;
										 
								UPDATE temp_modelos_ref
		 					  		SET unid_real_liberar = :ll_valor,
									 	 sw_carga = 1
							    WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
									    co_talla 		= :li_talla AND
									    co_color		= :al_color AND
									    po				= :as_po AND
									    usuario 		= :ls_usuario AND
									    raya		 		<> 10 AND
									    co_modelo     = :ll_modelo_old AND
									    co_color_te	<> :ll_color_te AND 
									    cs_tanda      = :ll_tanda_varios_mod_dif_color AND
										 ancho			= :ld_ancho_temporal;
							END IF

						ELSE
							UPDATE temp_modelos_ref
								SET unid_real_liberar = :ll_valor,
									 sw_carga = 1
							 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
									 co_talla 		= :li_talla AND
									 co_color		= :al_color AND
									 po				= :as_po AND
									 usuario 		= :ls_usuario AND
									 raya		 		<> 10 AND
									 co_modelo     = :ll_modelo_old AND
									 co_color_te	<> :ll_color_te AND 
									 cs_tanda      = :ll_tanda_varios_mod_dif_color;
						END IF
								 
						 IF SQLCA.SQLnrows > 0 THEN		 
							li_actualizo = 1		 
						END IF	 
					END IF
				
				ELSE
					UPDATE temp_modelos_ref
						SET unid_real_liberar = :ll_valor,
							 sw_carga = 1
					 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
							 co_talla 		= :li_talla AND
							 co_color		= :al_color AND
							 po				= :as_po AND
							 usuario 		= :ls_usuario AND
							 raya		 		<> 10 AND
							 co_modelo     = :ll_modelo_old AND
							 co_color_te	<> :ll_color_te;
					IF SQLCA.SQLnrows > 0 THEN		 
						li_actualizo = 1		 
					END IF	 
				END IF
				IF SQLCA.SQLCODE <> 0 THEN
					CLOSE(w_retroalimentacion)
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error', 'Se produjo error actualizando las unidades reales a liberar segun minima raya: ' + ls_error)
					Return -1  ;
				END IF
		End if
	Next
Next

Commit;
CLOSE(w_retroalimentacion)
Destroy lds_modelo_10
Destroy lds_modelo_no10_notela_color
Destroy lds_modelo_no10_notela_nocolor 
Destroy lds_modelo_no10_tela_color_noancho
Destroy lds_modelo_no10_tela_color_ancho
Destroy lds_modelo_no10_tela_nocolor
Return 0


end function

on n_cts_cargar_temporales_liberacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_cargar_temporales_liberacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

