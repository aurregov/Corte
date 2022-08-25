HA$PBExportHeader$n_cst_rollo.sru
forward
global type n_cst_rollo from nonvisualobject
end type
end forward

global type n_cst_rollo from nonvisualobject
end type
global n_cst_rollo n_cst_rollo

forward prototypes
public function boolean of_actualizar_disponible (long al_rollo)
public function long of_generar_mercada_asignacion (long al_ordenpdn, long al_rollo, decimal ad_metros, long ai_unidades)
public function long of_cambiar_op (long al_rollo, long al_ordenpdn)
public function boolean of_asignar_rollos_reposicion (long al_ordencorte, long al_reposicion, long al_rollos[], decimal ad_metros[], long al_unidades[], long ai_rollos, decimal ad_metroslib[], long al_unidadeslib[])
public function boolean of_actualizar_mercada (long al_mercada, long al_rollo, long ai_cortado, long ai_porcortar, long ai_mercada, long ai_raya)
public function long of_cortar_rollo (long al_mercada, long ai_pormercar, long al_rollo_padre, decimal ad_metros, decimal ad_kilos, long al_unidades, long ai_raya, long ai_cortado, decimal ad_ancho_std)
end prototypes

public function boolean of_actualizar_disponible (long al_rollo);Long li_asigna, li_fabrica, li_fila_actual, li_anulada, li_disponible
Long li_simulacion, li_fabricaplanta, li_planta, li_fabricapt, li_modulo
Long li_linea
String ls_po, ls_cut, ls_tono
Long ll_liberacion, ll_referencia, ll_color
n_cts_constantes luo_constantes
DataStore lds_liberaciones

luo_constantes = Create n_cts_constantes

li_asigna = luo_constantes.of_consultar_numerico("ESTADO ASIGNA")

IF li_asigna = -1 THEN
	Return False
END IF

li_anulada = luo_constantes.of_consultar_numerico("LIBERACION ANULADA")

IF li_anulada = -1 THEN
	Return False
END IF

li_disponible = luo_constantes.of_consultar_numerico("DISPONIBLE STOCK")

IF li_disponible = -1 THEN
	Return False
END IF

li_simulacion = luo_constantes.of_consultar_numerico("SIMULACION")

IF li_simulacion = -1 THEN
	Return False
END IF

li_fabricaplanta = luo_constantes.of_consultar_numerico("FABRICA PLANTA")

IF li_fabricaplanta = -1 THEN
	Return False
END IF

li_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACION")

IF li_planta = -1 THEN
	Return False
END IF

lds_liberaciones = Create DataStore

lds_liberaciones.DataObject = "dtb_liberaciones_rollo"

IF lds_liberaciones.SetTransObject(SQLCA) = -1 THEN
	MessageBox("Error","Error al definir la transacci$$HEX1$$f300$$ENDHEX$$n de las liberaciones del rollo")
	Return False	
END IF

UPDATE m_rollo
SET	co_estado_rollo = :li_disponible,
		fe_actualizacion = Current,
		usuario = user,
		instancia = SiteName
WHERE cs_rollo = :al_rollo;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar el estado del rollo " + SQLCA.SQLErrText)
	Return False
END IF
IF lds_liberaciones.Retrieve(li_simulacion, li_fabricaplanta, li_planta, al_rollo, li_asigna) > 0 THEN
	FOR li_fila_actual = 1 TO lds_liberaciones.RowCount()
		li_modulo = lds_liberaciones.GetItemNumber(li_fila_actual, "co_modulo")
		li_fabrica = lds_liberaciones.GetItemNumber(li_fila_actual, "co_fabrica_exp")
		ll_liberacion = lds_liberaciones.GetItemNumber(li_fila_actual, "cs_liberacion")
		ls_po = lds_liberaciones.GetItemString(li_fila_actual, "po")
		ls_cut = lds_liberaciones.GetItemString(li_fila_actual, "nu_cut")
		li_fabricapt = lds_liberaciones.GetItemNumber(li_fila_actual, "co_fabrica_pt")
		li_linea = lds_liberaciones.GetItemNumber(li_fila_actual, "co_linea")
		ll_referencia = lds_liberaciones.GetItemNumber(li_fila_actual, "co_referencia")
		ll_color = lds_liberaciones.GetItemNumber(li_fila_actual, "co_color_pt")
		ls_tono = lds_liberaciones.GetItemString(li_fila_actual, "tono")
		UPDATE dt_pdnxmodulo
		SET	co_estado_asigna = :li_anulada,
				fe_actualizacion = Current,
				usuario = User,
				instancia = SiteName
		WHERE simulacion = :li_simulacion AND
				co_fabrica = :li_fabricaplanta AND
				co_planta = :li_planta AND
				co_modulo = :li_modulo AND
				co_fabrica_exp = :li_fabrica AND
				cs_liberacion = :ll_liberacion AND
				po = :ls_po AND
				nu_cut = :ls_cut AND
				co_fabrica_pt = :li_fabricapt AND
				co_linea = :li_linea AND
				co_referencia = :ll_referencia AND
				co_color_pt = :ll_color AND
				tono = :ls_tono;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al anular la liberaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
			Return False
		END IF
	NEXT
END IF

Return True
end function

public function long of_generar_mercada_asignacion (long al_ordenpdn, long al_rollo, decimal ad_metros, long ai_unidades);Long ll_mercada
Long li_registros, li_estado_porcortar, li_estado_lib, li_tipo, li_tipo_orden
Long li_fabrica
n_cts_constantes luo_constantes
n_cst_generar_consecutivo luo_consecutivos

luo_constantes = Create n_cts_constantes

li_estado_porcortar = luo_constantes.of_consultar_numerico("ESTADO X CORTAR")
IF li_estado_porcortar = -1 THEN
	Return -1
END IF

li_estado_lib = luo_constantes.of_consultar_numerico("ESTADO LIB PROG")
IF li_estado_lib = -1 THEN
	Return -1
END IF

li_tipo = luo_constantes.of_consultar_numerico("TIPO ASIGNACION")
IF li_tipo = -1 THEN
	Return -1
END IF

li_tipo_orden = luo_constantes.of_consultar_numerico("TIPO MERCADA")
IF li_tipo_orden = -1 THEN
	Return -1
END IF

li_fabrica = luo_constantes.of_consultar_numerico("FABRICA TELA")
IF li_fabrica = -1 THEN
	Return -1
END IF

SELECT cs_mercada
INTO :ll_mercada
FROM h_mercada
WHERE cs_ordenpd_pt = :al_ordenpdn AND
		co_estado_mercada = :li_estado_porcortar;
		
IF SQLCA.SQLCode = -1 THEN		
	MessageBox("Error Base Datos","Error al verificar existencia de mercada " + SQLCA.SQLErrText)
	Return -1
ELSE
	IF SQLCA.SQLCode = 100 THEN
		luo_consecutivos = Create n_cst_generar_consecutivo
		ll_mercada = luo_consecutivos.of_consulta_consecutivo_orden(li_fabrica, li_tipo_orden)
		IF ll_mercada = -1 THEN
			Return -1
		ELSE
			INSERT INTO h_mercada(cs_mercada, co_estado_mercada, cs_orden_corte, cs_reposicion,
				cs_ordenpd_pt, co_tipo_mercada, fe_creacion, fe_actualizacion, usuario, instancia)
			VALUES(:ll_mercada, :li_estado_porcortar, 0, 0, :al_ordenpdn, :li_tipo, Current,
				Current, User, SiteName);
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al insertar registro de la mercada " + SQLCA.SQLErrText)
				Return -1
			END IF			
		END IF
	END IF
END IF
INSERT INTO dt_rollosmercada(cs_mercada, cs_rollo, raya, co_estado_mercada, 
	ca_metros_mercar, ca_unidades_mercar, fe_creacion, fe_actualizacion, 
	usuario, instancia)
VALUES(:ll_mercada, :al_rollo, 0, :li_estado_porcortar, :ad_metros, 
	:ai_unidades, Current, Current, User, SiteName);
	
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al insertar registro de rollo en la mercada " + SQLCA.SQLErrText)
	Return -1
END IF				
Return 1
end function

public function long of_cambiar_op (long al_rollo, long al_ordenpdn);UPDATE m_rollo
SET	cs_orden_pr_act = :al_ordenpdn,
		fe_actualizacion = Current,
		usuario = user
WHERE cs_rollo = :al_rollo;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar orden de producci$$HEX1$$f300$$ENDHEX$$n del rollo")
	Return -1
END IF
Return 0
end function

public function boolean of_asignar_rollos_reposicion (long al_ordencorte, long al_reposicion, long al_rollos[], decimal ad_metros[], long al_unidades[], long ai_rollos, decimal ad_metroslib[], long al_unidadeslib[]);Long li_rollo_actual, li_registros, li_fallo_grabar 
Long ll_unidades
Decimal{2} ld_metros

li_fallo_grabar = 0
FOR li_rollo_actual = 1 TO ai_rollos
// Vamos a validar que los metros y unidades liberadas con las cuales se trajo la informaci$$HEX1$$f300$$ENDHEX$$n 
// a la pantalla sean las mismas. Si hay diferencia vamos a cancelar la operaci$$HEX1$$f300$$ENDHEX$$n y el usuario
// debe consultar de nuevo la reposici$$HEX1$$f300$$ENDHEX$$n.

	DECLARE sp_val_liberado PROCEDURE FOR
		pr_cons_liberado(:al_rollos[li_rollo_actual], 28);
		
	EXECUTE sp_val_liberado;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar los metros liberados del rollo " + SQLCA.SQLErrText)
		Return False
	END IF
	
	FETCH sp_val_liberado INTO :ld_metros, :ll_unidades;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar los metros liberados del rollo " + SQLCA.SQLErrText)
		Return False
	END IF
	
	CLOSE sp_val_liberado;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar los metros liberados del rollo " + SQLCA.SQLErrText)
		Return False
	END IF
	
	IF (ad_metroslib[li_rollo_actual] <> ld_metros OR al_unidadeslib[li_rollo_actual] <> ll_unidades) THEN
		MessageBox("Advertencia...","Hubo un cambio en la informaci$$HEX1$$f300$$ENDHEX$$n de los metros o unidades disponibles del rollo: " + String(al_rollos[li_rollo_actual]))
		Return False
	END IF
	
	INSERT INTO dt_rollosreposicio(cs_reposicion, cs_rollo, ca_metros_repos, ca_unidades_repos, fe_creacion,
		fe_actualizacion, usuario, instancia)
	VALUES(:al_reposicion, :al_rollos[li_rollo_actual], :ad_metros[li_rollo_actual], :al_unidades[li_rollo_actual], 
		Current, Current, User, SiteName);
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al insertar rollo de reposici$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
		Return False
	END IF
	
	SELECT Count(*)
	INTO :li_registros
	FROM dt_consumo_rollos
	WHERE cs_rollo = :al_rollos[li_rollo_actual];
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar existencia en consumo de rollos " + SQLCA.SQLErrText)
		Return False
	END IF
	
	IF li_registros = 0 THEN
		INSERT INTO dt_consumo_rollos(cs_rollo, ca_metros, ca_unidades, usuario, instancia, fe_creacion, fe_actualizacion)
		VALUES(:al_rollos[li_rollo_actual], :ad_metros[li_rollo_actual], :al_unidades[li_rollo_actual], 
			User, SiteName, Current, Current);
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al insertar en consumo de rollos " + SQLCA.SQLErrText)
			Return False
		END IF
		IF SQLCA.SQLCODE = 0 THEN
		ELSE
			li_fallo_grabar = 1
		END IF
	ELSE
		UPDATE dt_consumo_rollos
		SET ca_metros = ca_metros + :ad_metros[li_rollo_actual],
				  ca_unidades = ca_unidades + :al_unidades[li_rollo_actual],
				  usuario = User,
					instancia = SiteName
		WHERE cs_rollo = :al_rollos[li_rollo_actual];
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al actualizar el consumo de rollos " + SQLCA.SQLErrText)
			Return False
		END IF
		IF SQLCA.SQLCODE = 0 THEN
		ELSE
			li_fallo_grabar = 1
		END IF
	END IF
	
	IF li_fallo_grabar = 1 THEN
		MessageBox("Error Base Datos","Error al actualizar el consumo de rollos, Favor comunicarse con Informatica, El rollo se va a descuadrar " + SQLCA.SQLErrText)
		Return False
	ELSE
		li_fallo_grabar = 0
	END IF
	
NEXT

DECLARE mercada PROCEDURE FOR
	pr_generar_mercada(:al_ordencorte, :al_reposicion);
	
EXECUTE mercada;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al crear la mercada " + SQLCA.SQLErrText)
	Return False
END IF

Return True
end function

public function boolean of_actualizar_mercada (long al_mercada, long al_rollo, long ai_cortado, long ai_porcortar, long ai_mercada, long ai_raya);Long li_registros, li_raya, li_tipo, li_tipoorden, li_rollosmercada, li_rolloslibera
Long li_indice, li_resultado
Long ll_ordencorte, ll_mercada, ll_unidades, ll_rollo
String ls_consulta
Decimal{2} ld_metros
u_ds_base lds_rolloslibera, lds_rollosmercada
n_cts_constantes luo_constantes

UPDATE dt_rollosmercada
SET	co_estado_mercada = :ai_cortado,
		fe_actualizacion = Current,
		usuario = User,
		instancia = SiteName
WHERE cs_mercada = :al_mercada AND
		cs_rollo = :al_rollo AND
		raya = :ai_raya;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar el rollo en la mercada " + SQLCA.SQLErrText)
	Return False
END IF

SELECT Count(*)
INTO :li_registros
FROM dt_rollosmercada
WHERE cs_mercada = :al_mercada AND
		co_estado_mercada = :ai_porcortar;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar rollos pendientes por cortar " + SQLCA.SQLErrText)
	Return False
END IF

IF li_registros = 0 THEN
	UPDATE h_mercada
	SET	co_estado_mercada = :ai_mercada,
			fe_actualizacion = Current,
			usuario = User,
			instancia = SiteName
	WHERE cs_mercada = :al_mercada;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al actualizar el estado de la mercada " + SQLCA.SQLErrText)
		Return False
	END IF
	
//	SELECT cs_orden_corte, co_tipo_mercada
//	INTO :ll_ordencorte, :li_tipo
//	FROM h_mercada 
//	WHERE cs_mercada = :al_mercada;
//	IF SQLCA.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","Error al actualzar el estado de la mercada " + SQLCA.SQLErrText)
//		Return False
//	END IF
//	
//	luo_constantes = Create n_cts_constantes
//	
//	li_tipoorden = luo_constantes.of_consultar_numerico("TIPO CORTE")
//	
//	IF li_tipoorden = -1 THEN
//		Return False
//	END IF
//	
//	IF li_tipo = li_tipoorden THEN
//		lds_rollosmercada = Create u_ds_base
//		lds_rollosmercada.DataObject = 'dtb_consulta_rollos_mercada'
//		IF lds_rollosmercada.SetTransObject(SQLCA) <> -1 THEN
//			lds_rolloslibera = Create u_ds_base
//			lds_rolloslibera.DataObject = 'dtb_consulta_rollo_oc_raya'
//			IF lds_rolloslibera.SetTransObject(SQLCA) <> -1 THEN
//				li_rollosmercada = lds_rollosmercada.Retrieve(al_mercada, 0, 0, ai_mercada)
//				li_rolloslibera = lds_rolloslibera.Retrieve(ll_ordencorte, 0, 0)
//				FOR li_indice = 1 TO li_rollosmercada
//					li_raya = lds_rollosmercada.GetItemNumber(li_indice, "raya")
//					ll_rollo = lds_rollosmercada.GetItemNumber(li_indice, "cs_rollo")
//					ls_consulta = "raya = " + String(li_raya) + " and cs_rollo = " + String(ll_rollo)
//					li_resultado = lds_rolloslibera.Find(ls_consulta, 1, lds_rolloslibera.RowCount())
//					IF li_resultado = 0 THEN
//						ls_consulta = "raya = " + String(li_raya)
//						li_resultado = lds_rolloslibera.Find(ls_consulta, 1, lds_rolloslibera.RowCount())
//						IF li_resultado > 0 THEN
//							IF lds_rolloslibera.RowsCopy(li_resultado, li_resultado, Primary!, lds_rolloslibera, li_resultado, Primary!) = -1 THEN
//								MessageBox("Error","Error al insertar registro en liberaci$$HEX1$$f300$$ENDHEX$$n")
//								Return False
//							ELSE
//								ld_metros = lds_rollosmercada.GetItemNumber(li_indice, "ca_metros_mercar")
//								ll_unidades = lds_rollosmercada.GetItemNumber(li_indice, "ca_unidades_mercar")
//								lds_rolloslibera.SetItem(li_resultado + 1, "ca_metros", ld_metros)
//								lds_rolloslibera.SetItem(li_resultado + 1, "ca_unidades", ll_unidades)
//								lds_rolloslibera.SetItem(li_resultado + 1, "cs_rollo", ll_rollo)
//							END IF
//						ELSE
//							MessageBox("Error","Mercada inconsistente")
//							Return False
//						END IF
//					ELSE
//						ld_metros = lds_rollosmercada.GetItemNumber(li_indice, "ca_metros_mercar")
//						ll_unidades = lds_rollosmercada.GetItemNumber(li_indice, "ca_unidades_mercar")
//						lds_rolloslibera.SetItem(li_resultado, "ca_metros", ld_metros)
//						lds_rolloslibera.SetItem(li_resultado, "ca_unidades", ll_unidades)						
//					END IF
//				NEXT
//				li_rolloslibera = lds_rolloslibera.RowCount()
//				FOR li_indice = 1 TO li_rolloslibera
//					li_raya = lds_rolloslibera.GetItemNumber(li_indice, "raya")
//					ll_rollo = lds_rolloslibera.GetItemNumber(li_indice, "cs_rollo")
//					ls_consulta = "raya = " + String(li_raya) + " and cs_rollo = " + String(ll_rollo)
//					li_resultado = lds_rollosmercada.Find(ls_consulta, 1, lds_rollosmercada.RowCount())
//					IF li_resultado = 0 THEN
//						lds_rolloslibera.DeleteRow(li_indice)
//						li_indice = li_indice - 1
//						li_rolloslibera = li_rolloslibera - 1
//					END IF
//				NEXT		
//				IF lds_rolloslibera.Update() = -1 THEN
//					MessageBox("Error","Error al actualizar los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n")
//					Return False
//				END IF
//			ELSE
//				MessageBox("Error","Error al asignar el objeto transacci$$HEX1$$f300$$ENDHEX$$n de rollos de liberaci$$HEX1$$f300$$ENDHEX$$n")
//				Return False				
//			END IF
//		ELSE
//			MessageBox("Error","Error al asignar el objeto transacci$$HEX1$$f300$$ENDHEX$$n de rollos de mercada")
//			Return False
//		END IF
//	END IF
END IF

//Return False
Return True
end function

public function long of_cortar_rollo (long al_mercada, long ai_pormercar, long al_rollo_padre, decimal ad_metros, decimal ad_kilos, long al_unidades, long ai_raya, long ai_cortado, decimal ad_ancho_std);n_cst_generar_consecutivo luo_consecutivos
n_cts_constantes luo_constantes
Long li_fabrica, li_documento, li_tipo, li_tipomercada, li_cortado, li_estado_mercado
Long	li_estado_cortando, li_estado_mercada, li_rollos_pend_cortar, li_registros
Long ll_rollo, ll_ordencorte, ll_ordennueva
String ls_padre, ls_hijo, ls_instruccion
Decimal{3}	ld_kg_rollo
DataStore lds_rolloliberacion

luo_constantes = Create n_cts_constantes

If IsNull(ad_ancho_std) Then
	ad_ancho_std = 0
End If

li_fabrica = luo_constantes.of_consultar_numerico("FABRICA TELA")
li_estado_cortando = luo_constantes.of_consultar_numerico("ESTADO CORTANDO")
li_estado_mercada = luo_constantes.of_consultar_numerico("ESTADO MERCADA")

IF li_fabrica = -1 THEN
	Return -1
END IF
li_documento = luo_constantes.of_consultar_numerico("DOCUMENTO ROLLO")

IF li_documento = - 1 THEN
	Return -1
END IF

li_tipo = luo_constantes.of_consultar_numerico("TIPO ASIGNACION")

IF li_tipo = - 1 THEN
	Return -1
END IF

SELECT co_tipo_mercada
INTO :li_tipomercada
FROM h_mercada
WHERE cs_mercada = :al_mercada;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar el tipo de mercada " + SQLCA.SQLErrText)
	Return -1
END IF

// Consultamos la orden de corte

SELECT cs_orden_corte
INTO :ll_ordencorte
FROM h_mercada 
WHERE cs_mercada = :al_mercada;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar la orden de corte de la mercada " + SQLCA.SQLErrText)
	Return -1
END IF

luo_consecutivos = Create n_cst_generar_consecutivo

ll_rollo = luo_consecutivos.of_calcula_consecutivo(li_fabrica, li_documento)

IF ll_rollo = 0 THEN
	Return -1
END IF

IF li_tipo = li_tipomercada THEN
	INSERT INTO dt_rollocort_asig(cs_mercada, cs_rollo, fe_creacion, fe_actualizacion, 
		usuario, instancia)	
	VALUES(:al_mercada, :ll_rollo, Current, Current, User, SiteName);
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al insertar registro de rollo de asignaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
		Return -1
	END IF
END IF

//IF ad_kilos = 0 THEN
//	MessageBox("Error Datos","Esta quedando el nuevo rollo en con Cero Kilos " + SQLCA.SQLErrText)
//	Return -1
//END IF


ls_padre = 'Padre de ' + String(ll_rollo)

ls_hijo = 'Hijo de ' + String(al_rollo_padre)

INSERT INTO m_rollo(cs_rollo, cs_ordenpd_te_pg, cs_ordenpd_te_real, cs_ordenpr, co_fabrica_pg, co_reftel_pg, 
	co_caract_pg, diametro_pg, co_color_pg, co_planeador, co_planta, cs_orden_pr_act, co_fabrica_act, co_reftel_act,
	co_caract_act, diametro_act, co_color_act, co_talla, co_color_pt, ca_unidades, co_maquina_tej, lote, cs_tanda,
	cs_secundario, co_maquina_tint, bodega, ubicacion, cs_ordenbp, cs_ordencr, ca_prog, ca_mt, ca_kg, ca_kg_tenido,
	pedexpor, procfis, co_centro, co_estado_rollo, prioridad, marca, corte, paso, co_calidad, atributo1, atributo2,
	ancho_abierto_crud, ancho_abierto_term, ancho_tub_crudo, ancho_tub_term, gr_mt2_terminado, localizacion_ant,
	cs_secuencia_prog, sw_impresion, fe_creacion, fe_actualizacion, usuario, instancia, co_proveedor, lote_hilaza,
	co_tip_hilaza, lote_tejido, co_caract_final, co_fab_propietario, co_tono, cs_solicitud_mercada, co_disenno)
SELECT :ll_rollo, cs_ordenpd_te_pg, cs_ordenpd_te_real, cs_ordenpr, co_fabrica_pg, co_reftel_pg, 
	co_caract_pg, diametro_pg, co_color_pg, co_planeador, co_planta, cs_orden_pr_act, co_fabrica_act, co_reftel_act,
	co_caract_act, diametro_act, co_color_act, co_talla, co_color_pt, :al_unidades, co_maquina_tej, lote, cs_tanda,
	cs_secundario, co_maquina_tint, bodega, ubicacion, cs_ordenbp, :ll_ordencorte, ca_prog, :ad_metros, :ad_kilos, 
	ca_kg_tenido, pedexpor, procfis, co_centro, co_estado_rollo, prioridad, marca, corte, paso, co_calidad, :ls_hijo, 
	atributo2, ancho_abierto_crud, ancho_abierto_term, ancho_tub_crudo, ancho_tub_term, gr_mt2_terminado, 
	localizacion_ant, cs_secuencia_prog, sw_impresion, fe_creacion, fe_actualizacion, usuario, instancia, co_proveedor, 
	lote_hilaza, co_tip_hilaza, lote_tejido, co_caract_final, co_fab_propietario, co_tono,cs_solicitud_mercada, co_disenno
FROM m_rollo
WHERE cs_rollo = :al_rollo_padre;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al insertar registro de rollo hijo " + SQLCA.SQLErrText)
	Return -1
END IF

UPDATE dt_consumo_rollos
SET ca_metros = ca_metros - :ad_metros,
    ca_unidades = ca_unidades - :al_unidades,
    fe_actualizacion = Current,
    usuario = User,
    instancia = SiteName
WHERE cs_rollo = :al_rollo_padre;

IF SQLCA.SQLCode = -1 THEN
   MessageBox("Error Base Datos","Error al actualizar el consumo del rollo padre " + SQLCA.SQLErrText)
   Return -1
END IF

SELECT Count(*)
INTO :li_registros
FROM dt_rollosmercada
WHERE cs_mercada = :al_mercada AND
		cs_rollo = :al_rollo_padre AND
		co_estado_mercada < :ai_cortado AND
		raya <> :ai_raya;
		
IF SQLCA.SQLCode = -1 THEN
   MessageBox("Error Base Datos","Error al validar si el rollo est$$HEX2$$e1002000$$ENDHEX$$asignado a otra raya de la misma mercada " + SQLCA.SQLErrText)
   Return -1
END IF

IF li_registros = 0 THEN
   SELECT Min(cs_orden_corte)
   INTO :ll_ordennueva
   FROM dt_rollosmercada, h_mercada
   WHERE dt_rollosmercada.cs_mercada <> :al_mercada AND
			dt_rollosmercada.cs_rollo = :al_rollo_padre AND
			dt_rollosmercada.co_estado_mercada < :ai_cortado AND
			dt_rollosmercada.cs_mercada = h_mercada.cs_mercada;
					  
   IF SQLCA.SQLCode = -1 THEN
      MessageBox("Error Base Datos","Error al validar si el rollo est$$HEX2$$e1002000$$ENDHEX$$asignado a otra mercada " + SQLCA.SQLErrText)
      Return -1
   END IF
   IF IsNull(ll_ordennueva) THEN
      ll_ordennueva = 0
   END IF
ELSE
   ll_ordennueva = ll_ordencorte
END IF


UPDATE m_rollo
SET	atributo1 = :ls_padre,
		ca_mt = ca_mt - :ad_metros,
		ca_kg = ca_kg - :ad_kilos,
		ca_unidades = ca_unidades - :al_unidades,
		cs_ordencr = :ll_ordennueva
WHERE cs_rollo = :al_rollo_padre;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al actualizar el rollo padre " + SQLCA.SQLErrText)
	Return -1
END IF

//SELECT ca_kg
//  INTO :ld_kg_rollo
//  FROM m_rollo
// WHERE cs_rollo = :al_rollo_padre; 
//IF ld_kg_rollo = 0 THEN
//	MessageBox("Error Datos","Esta quedando con Cero Kilos el rollo actualizado " + SQLCA.SQLErrText)
//	Return -1
//END IF

INSERT INTO dt_rollosmercada(cs_mercada, cs_rollo, raya, co_estado_mercada, 
	ca_metros_mercar, ca_unidades_mercar, fe_creacion, fe_actualizacion, usuario, 
	instancia, ancho_std)
VALUES(:al_mercada, :ll_rollo, :ai_raya, :li_estado_mercada, :ad_metros, :al_unidades, 
	Current, Current, User, SiteName, :ad_ancho_std);
	
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al insertar el nuevo rollo en la mercada " + SQLCA.SQLErrText)
	Return -1
END IF

INSERT INTO dt_consumo_rollos(cs_rollo, ca_metros, ca_unidades, fe_creacion, fe_actualizacion, usuario, instancia)
VALUES(:ll_rollo, :ad_metros, :al_unidades, Current, Current, User, SiteName);

IF SQLCA.SQLCode = -1 THEN
   MessageBox("Error Base Datos","Error al insertar registro de consumo para rollo Nuevo " + SQLCA.SQLErrText)
   Return -1
END IF

//Se verifica si es el ultimo rollo pendiente de la mercada por cortar para 
//saber si se deja la mercada en estado cortando o se para al estado ya mercada
//
//SELECT COUNT(*)
//  INTO :li_rollos_pend_cortar
//  FROM dt_rollosmercada
// WHERE cs_mercada = :al_mercada
//   AND co_estado_mercada = :li_estado_cortando
//	AND cs_rollo <> :al_rollo_padre;
//IF li_rollos_pend_cortar = 0 THEN  //es el ultimo rollo, se actualiza la mercada a estado ya mercada
//  UPDATE h_mercada
//     SET h_mercada.co_estado_mercada = :li_estado_mercada
//   WHERE h_mercada.cs_mercada = :al_mercada;
//	IF SQLCA.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","Error al actualizar el estado de la mercada " + SQLCA.SQLErrText)
//		Return -1
//	END IF
//
//END IF
//
//
//
// Una vez que se corta el rollo se debe desasignar de la liberaci$$HEX1$$f300$$ENDHEX$$n para evitar que estos
// metros sigan contando para liberaciones

//lds_rolloliberacion = Create DataStore
//
//lds_rolloliberacion.DataObject = 'dtb_consulta_rollo_oc_raya'
//
//IF lds_rolloliberacion.SetTransObject(SQLCA) = -1 THEN
//	MessageBox("Error","Error al asignar transacci$$HEX1$$f300$$ENDHEX$$n")
//	Return -1
//END IF
//
//IF lds_rolloliberacion.Retrieve(ll_ordencorte, ai_raya, al_rollo_padre) = 0 THEN
//	IF lds_rolloliberacion.Retrieve(ll_ordencorte, 0, al_rollo_padre) = 0 THEN
//		IF lds_rolloliberacion.Retrieve(ll_ordencorte, ai_raya) 
//ELSE
//	lds_rolloliberacion.SetItem(1, "cs_rollo", ll_rollo)
//	lds_rolloliberacion.SetItem(1, "ca_metros", ad_metros)
//	IF lds_rolloliberacion.AcceptText() = -1 THEN
//		MessageBox("Error","Error al llevar los cambios del rollo")
//		Return -1
//	ELSE
//		IF lds_rolloliberacion.Update() = -1 THEN
//			MessageBox("Error","Error al actualizar el rollo en la liberaci$$HEX1$$f300$$ENDHEX$$n")
//			Return -1
//		END IF
//	END IF
//END IF

Return ll_rollo
end function

on n_cst_rollo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_rollo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

