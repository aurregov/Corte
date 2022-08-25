HA$PBExportHeader$n_cst_liberacion.sru
forward
global type n_cst_liberacion from nonvisualobject
end type
end forward

global type n_cst_liberacion from nonvisualobject autoinstantiate
end type

type variables
String is_validacion
Long ii_tipo_lib
end variables

forward prototypes
public function boolean of_consecutivo (long ai_fabricaexp, ref long al_liberacion)
public function long of_validar_consolidacion (transaction atr_transaccion)
public function string of_getvalidacion ()
public function long of_anular_liberaciones (transaction atr_transaccion)
public function long of_consolidar_liberaciones (transaction atr_transaccion, string as_usuario)
public function long of_generar_estilos (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario)
public function long of_generar_telas (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario)
public function long of_generar_escalas (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario)
public function long of_generar_rectilineas (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario)
public function long of_validartipoliberacion (long ai_fab_exp, long al_liberacion, ref string as_mensaje)
public function long of_obtenerliberacion (long al_ordencorte, ref string as_mensaje)
end prototypes

public function boolean of_consecutivo (long ai_fabricaexp, ref long al_liberacion);SELECT Max(cs_liberacion) + 1
INTO :al_liberacion
FROM h_liberar_escalas
WHERE co_fabrica_exp = :ai_fabricaexp;

IF SQLCA.SQLCode = -1 THEN
	is_validacion = 'Error al consultar el consecutivo. ' + SQLCA.SQLErrText
	Return False
END IF

Return True
end function

public function long of_validar_consolidacion (transaction atr_transaccion);Long li_liberaciones, li_registros, li_fabrica, li_linea, li_fabricate
Long li_caract, li_diametro, li_referencias, li_telas, li_liberacion
Long li_fabricaexp, li_fabricalib, li_raya
Long ll_referencia, ll_reftel, ll_liberacion, ll_tanda, ll_color, ll_colorte
String ls_tono, ls_orden, ls_cut
Decimal{2} ld_ancho
DataStore lds_referencias, lds_refvalidacion, lds_telas, lds_telasvalidacion
DataStore lds_liberaciones

//lds_referencias = Create DataStore
//lds_refvalidacion = Create DataStore
lds_telas = Create DataStore
lds_telasvalidacion = Create DataStore
lds_liberaciones = Create DataStore

//lds_referencias.DataObject = 'dtb_referencias_liberacion'
//lds_refvalidacion.DataObject = 'dtb_referencias_liberacion'
lds_telas.DataObject = 'dtb_telas_liberacion'
lds_telasvalidacion.DataObject = 'dtb_telas_liberacion'
lds_liberaciones.DataObject = 'dtb_liberaciones_consolida'

IF lds_liberaciones.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para las_liberaciones a consolidar'
END IF

IF lds_liberaciones.Retrieve(gstr_info_usuario.codigo_usuario) = 0 THEN
	is_validacion = 'No se encontraron liberaciones para consolidar'
	Return -1
END IF

li_liberaciones = lds_liberaciones.RowCount()

IF li_liberaciones > 1 THEN
ELSE
	is_validacion = 'No puede agrupar, solo seleccion$$HEX2$$f3002000$$ENDHEX$$una liberaci$$HEX1$$f300$$ENDHEX$$n'
END IF

//IF lds_referencias.SetTransObject(atr_transaccion) = -1 THEN
//	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para validar referencias'
//END IF
//
//IF lds_refvalidacion.SetTransObject(atr_transaccion) = -1 THEN
//	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para validar referencias, contra'
//END IF

IF lds_telas.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para validar telas'
END IF

IF lds_telasvalidacion.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para validar telas, contra'
END IF

//li_fabricalib = lds_liberaciones.GetItemNumber(1, "co_fabrica_exp")
//ll_liberacion = lds_liberaciones.GetItemNumber(1, "cs_liberacion")

// Vamos a partir de la primera liberaci$$HEX1$$f300$$ENDHEX$$n en el objeto y con base en estas vamos a validar
// que todas las otras liberaciones tengan las mismas referencias y telas.

// Esto ya no se necesita, vamos a validar que las producciones seleccionadas correspondan
// a la misma referencia, color. Se har$$HEX1$$ed00$$ENDHEX$$a simplemente un ciclo para recorrer los registros
// y compararlo con el primero.

//lds_referencias.Retrieve(li_fabricalib, ll_liberacion, 0, 0, 0, 0, ' ')

//IF lds_referencias.RowCount() > 0 THEN
//	FOR li_referencias = 1 TO lds_referencias.RowCount()
//		li_fabrica = lds_referencias.GetItemNumber(li_referencias, "co_fabrica")
//		li_linea = lds_referencias.GetItemNumber(li_referencias, "co_linea")
//		ll_referencia = lds_referencias.GetItemNumber(li_referencias, "co_referencia")

//		ll_color = lds_referencias.GetItemNumber(li_referencias, "co_color_pt")
//		ls_tono = lds_referencias.GetItemString(li_referencias, "co_tono")
//		FOR li_liberacion = 2 TO li_liberaciones
//			li_fabricalib = lds_liberaciones.GetItemNumber(li_liberacion, "co_fabrica_exp")
//			ll_liberacion = lds_liberaciones.GetItemNumber(li_liberacion, "cs_liberacion")			
//			IF lds_refvalidacion.Retrieve(li_fabricalib, ll_liberacion, li_fabrica, li_linea, &
//				ll_referencia, ll_color, ls_tono) <> 1 THEN
//				is_validacion = 'La referencia: ' + String(li_fabrica) + '-' + String(li_linea) + '-' + String(ll_referencia) + '-' + &
//									String(ll_color) + '-' + ls_tono + '. No existe en la liberacion ' + String(li_fabricalib) + "-" + &
//									String(ll_liberacion)
//				Return -1
//			END IF
//		NEXt
//	NEXT
//ELSE
//	is_validacion = 'No se encontraron referencias para la primer liberaci$$HEX1$$f300$$ENDHEX$$n'
//END IF

li_fabricalib = lds_liberaciones.GetItemNumber(1, "co_fabrica_exp")
ll_liberacion = lds_liberaciones.GetItemNumber(1, "cs_liberacion")
ls_orden = lds_liberaciones.GetItemString(1, "nu_orden")
ls_cut = lds_liberaciones.GetItemString(1, "nu_cut")
li_fabrica = lds_liberaciones.GetItemNumber(1, "co_fabrica_pt")
li_linea = lds_liberaciones.GetItemNumber(1, "co_linea")
ll_referencia = lds_liberaciones.GetItemNumber(1, "co_referencia")
ll_color = lds_liberaciones.GetItemNumber(1, "co_color_pt")

// Esta validaci$$HEX1$$f300$$ENDHEX$$n se debe hacer con la clave hasta color.

lds_telas.Retrieve(li_fabricalib, ll_liberacion, ls_orden, ls_cut, li_fabrica, li_linea, &
ll_referencia, ll_color, 0, 0, 0, 0, 0, 0, 0, 0)

IF lds_telas.RowCount() > 0 THEN
	FOR li_telas = 1 TO lds_telas.RowCount()
		li_fabricate = lds_telas.GetItemNumber(li_telas, "co_fabrica_tela")
		ll_reftel = lds_telas.GetItemNumber(li_telas, "co_reftel")
		li_caract = lds_telas.GetItemNumber(li_telas, "co_caract")
		li_diametro = lds_telas.GetItemNumber(li_telas, "diametro")
		ll_colorte = lds_telas.GetItemNumber(li_telas, "co_color_tela")
		ld_ancho = lds_telas.GetItemNumber(li_telas, "ancho_cortable")
		li_raya = lds_telas.GetItemNumber(li_telas, "raya")
		ll_tanda = lds_telas.GetItemNumber(li_telas, "cs_tanda")
		FOR li_liberacion = 2 TO li_liberaciones
			li_fabricalib = lds_liberaciones.GetItemNumber(li_liberacion, "co_fabrica_exp")
			ll_liberacion = lds_liberaciones.GetItemNumber(li_liberacion, "cs_liberacion")			
			ls_orden = lds_liberaciones.GetItemString(li_liberacion, "nu_orden")
			ls_cut = lds_liberaciones.GetItemString(li_liberacion, "nu_cut")
			li_fabrica = lds_liberaciones.GetItemNumber(li_liberacion, "co_fabrica_pt")
			li_linea = lds_liberaciones.GetItemNumber(li_liberacion, "co_linea")
			ll_referencia = lds_liberaciones.GetItemNumber(li_liberacion, "co_referencia")
			ll_color = lds_liberaciones.GetItemNumber(li_liberacion, "co_color_pt")			
			IF lds_telasvalidacion.Retrieve(li_fabricalib, ll_liberacion, ls_orden, ls_cut, &
				li_fabrica, li_linea, ll_referencia, ll_color, li_fabricate, ll_reftel, &
				li_caract, li_diametro, ll_colorte, ld_ancho, li_raya, ll_tanda) <> 1 THEN
				is_validacion = 'La tela: ' + String(li_fabricate) + '-' + String(ll_reftel) + '-' + String(li_caract) + '-' + String(li_diametro) + '-' + &
									String(ll_colorte) + '-' + String(ld_ancho) + ' de la raya: ' + String(li_raya) + ' tanda: ' + String(ll_tanda) + '. No existe en la liberaci$$HEX1$$f300$$ENDHEX$$n ' + String(li_fabricalib) + '-' + &
									String(ll_liberacion)
				Return -1
			END IF
		NEXT
	NEXT
ELSE
	is_validacion = 'No se encontraron telas para la primer liberaci$$HEX1$$f300$$ENDHEX$$n'
END IF
Return 1
end function

public function string of_getvalidacion ();Return is_validacion
end function

public function long of_anular_liberaciones (transaction atr_transaccion);Long li_producciones, li_cancela, li_tipo_old, li_tipo_new
DataStore lds_producciones
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_cancela = luo_constantes.of_consultar_numerico("ESTADO ANULADA")

IF li_cancela = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante ESTADO ANULADA'
	Return -1
END IF

lds_producciones = Create DataStore

lds_producciones.DataObject = 'dtb_producciones_consolida'

IF lds_producciones.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al asignar el objeto transacci$$HEX1$$f300$$ENDHEX$$n de las producciones'
	Return -1
END IF

li_producciones = lds_producciones.Retrieve(gstr_info_usuario.codigo_usuario)

IF li_producciones = 0 THEN
	is_validacion = 'Error. No se encontraron producciones para anular'
	Return -1
END IF

FOR li_producciones = 1 TO lds_producciones.RowCount()
	lds_producciones.SetItem(li_producciones, "co_estado_asigna", li_cancela)
NEXT

IF lds_producciones.Update() = -1 THEN
	is_validacion = 'Error al actualizar el estado de las producciones'
	Return -1
END IF

Return 1
end function

public function long of_consolidar_liberaciones (transaction atr_transaccion, string as_usuario);Long li_fabrica, li_liberacion
Long ll_liberacion
String ls_instruccion
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_fabrica = luo_constantes.of_consultar_numerico("FABRICA LIBERACIONES")

IF li_fabrica = -1 THEN
	Return -1
END IF

// Vamos a anular primero las producciones de las liberaciones.

IF This.of_anular_liberaciones(SQLCA) = -1 THEN
	Return -1
END IF

IF Not This.of_consecutivo(li_fabrica, ll_liberacion) THEN
	Return -1
END IF

IF IsNull(ii_tipo_lib) THEN ii_tipo_lib = 4 

INSERT INTO h_liberar_escalas(co_fabrica_exp, cs_liberacion, co_est_liberacion, 
	co_tip_liberacion, fe_creacion, fe_actualizacion, usuario, instancia)
VALUES(:li_fabrica, :ll_liberacion, :ii_tipo_lib, 1, Current, Current, :as_usuario, SiteName)
USING atr_transaccion;

IF atr_transaccion.SQLCode = -1 THEN
	is_validacion = 'Error insertando encabezado liberaci$$HEX1$$f300$$ENDHEX$$n. ' + atr_transaccion.SQLErrText
	Return -1
END IF

// Cargamos la informaci$$HEX1$$f300$$ENDHEX$$n de los estilos.

IF This.of_generar_estilos(SQLCA, li_fabrica, ll_liberacion, as_usuario) = -1 THEN
	Return -1
END IF

// Cargamos la informaci$$HEX1$$f300$$ENDHEX$$n de las telas. No rectilineas

IF This.of_generar_telas(SQLCA, li_fabrica, ll_liberacion, as_usuario) = -1 THEN
	Return -1
END IF

// Cargamos la informaci$$HEX1$$f300$$ENDHEX$$n de las escalas

IF This.of_generar_escalas(SQLCA, li_fabrica, ll_liberacion, as_usuario) = -1 THEN
	Return -1
END IF

// Cargamos la informaci$$HEX1$$f300$$ENDHEX$$n de las rectilineas

IF This.of_generar_rectilineas(SQLCA, li_fabrica, ll_liberacion,as_usuario) = -1 THEN
	Return -1
END IF

DELETE FROM t_libera_consolida
WHERE usuario = :gstr_info_usuario.codigo_usuario;
IF SQLCA.SQLCode = -1 THEN
	is_validacion = 'Error al insertar registro en tabla temporal. ' + atr_transaccion.SQLErrText
	Return -1
END IF		

Return 1
end function

public function long of_generar_estilos (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario);Long li_fabrica, li_linea, li_estilos, li_simulacion, li_fabplanta, li_planta
Long li_modulo, li_prioridad, li_particion, li_estado, li_tipo_asigna
Long li_tipo_empate, li_tipoprog, li_asignacion, li_talla, li_tallas
Long li_tipoliberacion, li_registros, li_linea_exp
Long ll_referencia, ll_color, ll_ordenpdn, ll_unidades, ll_prioridad, ll_unidtalla,li_unir_oc,ll_pedido
String ls_orden, ls_cut, ls_tono, ls_ref_exp, ls_color_exp
Decimal{5} ld_yield
DateTime ldt_entrega
DataStore lds_estilos, lds_tallas
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_simulacion = luo_constantes.of_consultar_numerico("SIMULACION")

IF li_simulacion = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante SIMULACION'
	Return -1
END IF

li_fabplanta = luo_constantes.of_consultar_numerico("FABRICA PLANTA")

IF li_fabplanta = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante FABRICA PLANTA'
	Return -1
END IF

li_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACIONES")

IF li_planta = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante PLANTA LIBERACIONES'
	Return -1
END IF

li_modulo = luo_constantes.of_consultar_numerico("MODULO")

IF li_modulo = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante MODULO'
	Return -1
END IF

li_tipo_asigna = luo_constantes.of_consultar_numerico("TIPO ASIGNA")

IF li_tipo_asigna = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante TIPO ASIGNA'
	Return -1
END IF

li_tipo_empate = luo_constantes.of_consultar_numerico("TIPO EMPATE")

IF li_tipo_empate = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante TIPO EMPATE'
	Return -1
END IF

li_tipoprog = luo_constantes.of_consultar_numerico("TIPO PROG")

IF li_tipoprog = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante TIPO PROG'
	Return -1
END IF

li_asignacion = luo_constantes.of_consultar_numerico("ASIGNACION")

IF li_asignacion = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante ASIGNACION'
	Return -1
END IF

li_estado = luo_constantes.of_consultar_numerico("ESTADO ASIGNA")

IF li_estado = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante ESTADO ASIGNA'
	Return -1
END IF

// Mirar selects.

lds_estilos = Create DataStore

lds_estilos.DataObject = 'dtb_estilos_consolida'

IF lds_estilos.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para los estilos a consolidar'
	Return -1
END IF

// Mirar selects.

lds_tallas = Create DataStore

lds_tallas.DataObject = 'dtb_tallas_consolida'

IF lds_tallas.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para las tallas a consolidar'
	Return -1
END IF

li_estilos = lds_estilos.Retrieve(gstr_info_usuario.codigo_usuario)

IF li_estilos = 0 THEN
	is_validacion = 'Error, no se encontraron estilos para consolidar'
	Return -1
END IF

FOR li_estilos = 1 TO lds_estilos.RowCount()
	ls_orden = lds_estilos.GetItemString(li_estilos, "nu_orden")
	ls_cut = lds_estilos.GetItemString(li_estilos, "nu_cut")
	li_fabrica = lds_estilos.GetItemNumber(li_estilos, "co_fabrica")
	li_linea = lds_estilos.GetItemNumber(li_estilos, "co_linea")
	ll_referencia = lds_estilos.GetItemNumber(li_estilos, "co_referencia")
	ll_color = lds_estilos.GetItemNumber(li_estilos, "co_color_pt")
	ls_tono = lds_estilos.GetItemString(li_estilos, "co_tono")
	ll_ordenpdn = lds_estilos.GetItemNumber(li_estilos, "cs_ordenpd_pt")
	ld_yield = lds_estilos.GetItemNumber(li_estilos, "yield")
	ll_unidades = lds_estilos.GetItemNumber(li_estilos, "ca_unidades")	
	ldt_entrega = lds_estilos.GetItemDateTime(li_estilos, "fe_requerida_desp")
	li_unir_oc = lds_estilos.GetItemNumber(li_estilos,'cs_unir_oc')
	ll_pedido = lds_estilos.GetItemNumber(li_estilos,'pedido')
	
	INSERT INTO dt_libera_estilos(co_fabrica_exp, cs_liberacion, nu_orden, nu_cut,
	   co_fabrica, co_linea, co_referencia, co_color_pt, co_tono, cs_ordenpd_pt,
		yield, ca_unidades, fe_creacion, fe_actualizacion,	usuario, instancia)
	VALUES(:ai_fabricaexp, :al_liberacion, :ls_orden, :ls_cut, :li_fabrica, :li_linea,
		:ll_referencia, :ll_color, :ls_tono, :ll_ordenpdn, :ld_yield, :ll_unidades,
		Current, Current, :as_usuario, SiteName) USING atr_transaccion;
		
	IF atr_transaccion.SQLCode = -1 THEN
		is_validacion = 'Error al insertar registro de estilos. ' + atr_transaccion.SQLErrText
		Return -1
	END IF
	
	SELECT Nvl(Max(cs_prioridad), 0) + 1
	INTO :ll_prioridad
	FROM dt_pdnxmodulo
	WHERE simulacion = :li_simulacion AND
			co_fabrica = :li_fabplanta AND
			co_planta = :li_planta AND
			co_modulo = :li_modulo
	USING atr_transaccion;
	
	IF atr_transaccion.SQLCode = -1 THEN
		is_validacion = 'Error al consultar la prioridad'
		Return -1
	END IF
	
	li_tallas = lds_tallas.Retrieve(gstr_info_usuario.codigo_usuario, ls_orden, ls_cut, &
		li_fabrica, li_linea, ll_referencia, ll_color, ls_tono)
		
	IF li_tallas = 0 THEN
		is_validacion = 'Error. No se encontraron tallas para un estilo.'
		Return -1
	END IF
	
	//se coloca la linea, referencia y color de ventas
	//jcrm
	//junio 4 de 2008
	SELECT DISTINCT co_linea_exp, co_ref_exp, color_exp
	  INTO :li_linea_exp, :ls_ref_exp, :ls_color_exp
	  FROM dt_caxpedidos 
	 WHERE cs_ordenpd_pt = :ll_ordenpdn AND
	       co_color = :ll_color AND
			 pedido = :ll_pedido;
	IF IsNull(li_linea_exp) OR IsNull(ls_ref_exp) OR IsNull(ls_color_exp) OR &
	   ls_ref_exp = '' OR ls_color_exp = '' THEN
		is_validacion = 'Error. No se encontraron los datos de ventas para el pedido en la op.'
		Return -1
	END IF
	
	INSERT INTO dt_pdnxmodulo(simulacion, co_fabrica, co_planta, co_modulo, co_fabrica_exp, 
		cs_liberacion, po, nu_cut,	co_fabrica_pt, co_linea, co_referencia, co_color_pt, tono,
		cs_prioridad, ca_programada, ca_producida, ca_pendiente,	co_estado_asigna, 
		fe_requerida_desp, ca_minutos_std, co_tipo_asignacion, ca_personasxmod, cod_tur, 
		minutos_jornada, ind_cambio_estilo, ca_unid_base_dia, orige_uni_base_dia, 
		tipo_empate, unidades_empate, metodo_programa, fuente_dato, fe_creacion, 
		fe_actualizacion, usuario, instancia, tipo_fe_prog, indicativo_base, ca_base_dia_prod, 
		ca_base_dia_prog, ca_a_programar, co_estado_merc, ca_proyectada, ca_actual, 
		ca_numerada, cs_asignacion, cs_particion, cs_ordenpd_pt, co_fabrica_prop, co_fabrica_corte,
		co_linea_exp, co_ref_exp, co_color_exp, cs_unir_oc, pedido)
	VALUES(:li_simulacion, :li_fabplanta, :li_planta, :li_modulo, :ai_fabricaexp, 
		:al_liberacion, :ls_orden, :ls_cut, :li_fabrica, :li_linea, :ll_referencia, 
		:ll_color, :ls_tono, :ll_prioridad,	:ll_unidades, 0, :ll_unidades, :li_estado, 
		:ldt_entrega, 0, :li_tipo_asigna, 0, 0, 0, 0, 0, 0, :li_tipo_empate, 0, 0, 0, 
		Current, Current, :as_usuario, SiteName, :li_tipoprog, 0, 0, 0, 0, 0, 0, 0, 0, 
		:li_asignacion, 1, :ll_ordenpdn, :gstr_info_usuario.co_planta_pro, 2, :li_linea_exp,
		:ls_ref_exp, :ls_color_exp, :li_unir_oc, :ll_pedido) USING atr_transaccion;	
		
	IF atr_transaccion.SQLCode = -1 THEN
		is_validacion = 'Error al insertar registro de producci$$HEX1$$f300$$ENDHEX$$n. ' + atr_transaccion.SQLErrText
		Return -1
	END IF
	
	SELECT Count(*)
	INTO :li_registros
	FROM dt_caxpedidos
	WHERE cs_ordenpd_pt = :ll_ordenpdn
	USING atr_transaccion;
	
	IF atr_transaccion.SQLCode = -1 THEN
		is_validacion = 'Error al verificar el tipo de liberaci$$HEX1$$f300$$ENDHEX$$n. ' + atr_transaccion.SQLErrText
		Return -1
	END IF
	
	IF li_registros = 0 THEN
		li_tipoliberacion = 2
	ELSE
		li_tipoliberacion = 1
	END IF
	
	FOR li_tallas = 1 TO lds_tallas.RowCount()
		
		li_talla = lds_tallas.GetItemNumber(li_tallas, "co_talla")
		ll_unidtalla = lds_tallas.GetItemNumber(li_tallas, "ca_programada")	
	
		INSERT INTO dt_talla_pdnmodulo(simulacion, co_fabrica, co_planta, co_modulo, co_fabrica_exp, 
			cs_liberacion, po, nu_cut, co_fabrica_pt, co_linea, co_referencia, co_color_pt, 
			tono, cs_particion, co_talla, cs_orden_talla, cs_prioridad, ca_programada, ca_producida, 
			ca_pendiente, co_est_prog_talla, fuente_dato, fe_creacion, fe_actualizacion, usuario, 
			instancia, ca_proyectada, ca_actual, ca_numerada)
		VALUES(:li_simulacion, :li_fabplanta, :li_planta, :li_modulo, :ai_fabricaexp, :al_liberacion, 
			:ls_orden, :ls_cut, :li_fabrica, :li_linea, :ll_referencia, :ll_color, :ls_tono, 1, 
			:li_talla, :li_tallas, :ll_prioridad, :ll_unidtalla, 0, :ll_unidtalla, :li_estado, 
			0, Current, Current, :as_usuario, SiteName, 0, 0, 0) USING atr_transaccion;	
			
		IF atr_transaccion.SQLCode = -1 THEN
			is_validacion = 'Error al insertar registro de producci$$HEX1$$f300$$ENDHEX$$n de tallas'
			Return -1
		END IF	
		
		DECLARE sp_actpedidos PROCEDURE FOR
			pr_act_pedidosorden(:ll_ordenpdn, :li_fabrica, :li_linea, :ll_referencia, 
				:li_talla, :ll_color, :ls_orden, :ls_cut, :ll_unidtalla, :li_tipoliberacion, 1) 
				USING atr_transaccion;
				
		EXECUTE sp_actpedidos;
		
		IF atr_transaccion.SQLCode = -1 THEN
			is_validacion = 'Error al actualizar los pedidos. ' + atr_transaccion.SQLErrText
			Return -1
		END IF
		
	NEXT
NEXT

Return 1
end function

public function long of_generar_telas (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario);Long li_fabrica, li_linea, li_fabricate, li_caract, li_diametro, li_raya
Long li_telas, li_rollos, li_rectilineo1, li_rectilineo2, li_tipotela, li_registros
Long ll_referencia, ll_color, ll_modelo, ll_reftel, ll_unidades, ll_rollos, ll_count
Long ll_unidrollo, ll_unidrollo_usados, ll_rollo, ll_unidinsercion, ll_tanda, ll_colorte
String ls_orden, ls_cut, ls_tono, ls_tonote
Decimal{5} ld_yield, ld_tela
Decimal{2} ld_ancho, ld_metros, ld_metros_usados, ld_metrosinsercion
DataStore lds_telas, lds_rollos
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")

IF li_rectilineo1 = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante RECTILINEO 1'
	Return -1
END IF

li_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 1")

IF li_rectilineo2 = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante RECTILINEO 1'
	Return -1
END IF

lds_telas = Create DataStore

lds_telas.DataObject = 'dtb_telas_consolida'

IF lds_telas.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para las telas a consolidar'
	Return -1
END IF

lds_rollos = Create DataStore

lds_rollos.DataObject = 'dtb_rollos_consolida'

IF lds_rollos.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para los rollos a consolidar'
	Return -1
END IF

li_telas = lds_telas.Retrieve(gstr_info_usuario.codigo_usuario)

IF li_telas = 0 THEN
	is_validacion = 'Error, no se encontraron telas para consolidar'
	Return -1
END IF

FOR li_telas = 1 TO lds_telas.RowCount()
	ls_orden = lds_telas.GetItemString(li_telas, "nu_orden")
	ls_cut = lds_telas.GetItemString(li_telas, "nu_cut")
	li_fabrica = lds_telas.GetItemNumber(li_telas, "co_fabrica_pt")
	li_linea = lds_telas.GetItemNumber(li_telas, "co_linea")
	ll_referencia = lds_telas.GetItemNumber(li_telas, "co_referencia")
	ll_color = lds_telas.GetItemNumber(li_telas, "co_color_pt")
	ls_tono = lds_telas.GetItemString(li_telas, "co_tono")
	ll_modelo = lds_telas.GetItemNumber(li_telas, "co_modelo")
	li_fabricate = lds_telas.GetItemNumber(li_telas, "co_fabrica_tela")
	ll_reftel = lds_telas.GetItemNumber(li_telas, "co_reftel")
	li_caract = lds_telas.GetItemNumber(li_telas, "co_caract")
	li_diametro = lds_telas.GetItemNumber(li_telas, "diametro")
	ll_colorte = lds_telas.GetItemNumber(li_telas, "co_color_tela")
	ld_ancho = lds_telas.GetItemNumber(li_telas, "ancho_cortable")
	ls_tonote = lds_telas.GetItemString(li_telas, "tono_tela")
	li_raya = lds_telas.GetItemNumber(li_telas, "raya")
	ll_unidades = lds_telas.GetItemNumber(li_telas, "ca_unidades")
	ld_yield = lds_telas.GetItemNumber(li_telas, "yield")
	ld_tela = lds_telas.GetItemNumber(li_telas, "ca_tela")
	li_tipotela = lds_telas.GetItemNumber(li_telas, "co_tiptel")
	ll_tanda = lds_telas.GetItemNumber(li_telas, "cs_tanda")
	
	INSERT INTO dt_telaxmodelo_lib(co_fabrica_exp, cs_liberacion, nu_orden, nu_cut, 
	   co_fabrica_pt, co_linea, co_referencia, co_color_pt, co_tono, co_modelo, co_fabrica_tela,
		co_reftel, co_caract, diametro, co_color_tela, ancho_cortable, tono_tela, raya,
		ca_unidades, yield, ca_tela, fe_creacion, fe_actualizacion, usuario, instancia, 
		cs_tanda)
	VALUES(:ai_fabricaexp, :al_liberacion, :ls_orden, :ls_cut, :li_fabrica, :li_linea,
		:ll_referencia, :ll_color, :ls_tono, :ll_modelo, :li_fabricate, :ll_reftel, :li_caract,
		:li_diametro, :ll_colorte, :ld_ancho, :ls_tonote, :li_raya, :ll_unidades, :ld_yield,
		:ld_tela, Current, Current, :as_usuario, SiteName, :ll_tanda) USING atr_transaccion;
		
	IF atr_transaccion.SQLCode = -1 THEN
		is_validacion = 'Error al insertar registro de tela. ' + atr_transaccion.SQLErrText
		Return -1
	END IF
	
// Los rollos de las telas rectilineas las vamos a cargar a parte. Estas deben ser por talla
	
	IF li_tipotela <> li_rectilineo1 AND li_tipotela <> li_rectilineo2 THEN
		li_rollos = lds_rollos.Retrieve(ls_orden, ls_cut, li_fabrica, li_linea, ll_referencia, &
			ll_color, ls_tono, ll_modelo, li_fabricate, ll_reftel, li_caract, li_diametro, ll_colorte, &
			ai_fabricaexp, al_liberacion, gstr_info_usuario.codigo_usuario)
		
		IF li_rollos = 0 THEN
			is_validacion = 'Error, no se encontraron rollos para un estilo.'
			Return -1
		END IF
		
		FOR li_rollos = 1 TO lds_rollos.RowCount()
			ll_rollo = lds_rollos.GetItemNumber(li_rollos, "cs_rollo")
			ld_metros = lds_rollos.GetItemNumber(li_rollos, "ca_metros")
			ld_metros_usados = lds_rollos.GetItemNumber(li_rollos, "ca_metros_usado")
			ll_unidrollo = lds_rollos.GetItemNumber(li_rollos, "ca_unidades")
			ll_unidrollo_usados = lds_rollos.GetItemNumber(li_rollos, "ca_unidades_usado")
			ld_metros = ld_metros - ld_metros_usados
			ll_unidrollo = ll_unidrollo - ll_unidrollo_usados
//			IF li_tipotela = li_rectilineo1 OR li_tipotela = li_rectilineo2 THEN
//				IF ll_unidrollo >= ll_unidades THEN
//					ll_unidinsercion = ll_unidades
//					ll_unidades = 0
//				ELSE
//					ll_unidinsercion = ll_unidrollo
//					ll_unidades = ll_unidades - ll_unidrollo
//				END IF
//				INSERT INTO dt_rollos_libera(co_fabrica_exp, cs_liberacion, nu_orden, 
//					nu_cut, co_fabrica_pt, co_linea, co_referencia, co_color_pt, co_tono, 
//					co_modelo, co_fabrica_tela, co_reftel, co_caract, diametro, co_color_tela, 
//					cs_rollo, ca_metros, ca_unidades, fe_creacion, fe_actualizacion, usuario, 
//					instancia)
//				VALUES(:ai_fabricaexp, :al_liberacion, :ls_orden, :ls_cut, :li_fabrica, 
//					:li_linea, :ll_referencia, :ll_color, :ls_tono, :ll_modelo, :li_fabricate, 
//					:ll_reftel, :li_caract, :li_diametro, :ll_colorte, :ll_rollo, 0, 
//					:ll_unidinsercion, Current, Current, User, SiteName) USING atr_transaccion;
//					
//				IF atr_transaccion.SQLCode = -1 THEN
//					is_validacion = 'Error al insertar registro de rollo. ' + atr_transaccion.SQLErrText
//					Return -1
//				END IF
//				IF ll_unidades = 0 THEN
//					EXIT
//				END IF
//			ELSE
				IF ld_metros >= ld_tela THEN
					ld_metrosinsercion = ld_tela
					ld_tela = 0
				ELSE
					ld_metrosinsercion = ld_metros
					ld_tela = ld_tela - ld_metros
				END IF
				
				//para que no inserte tela sin metros cuando consoliden liberaciones
				//jcrm
				//marzo 26 de 2008
				IF ld_metrosinsercion = 0 OR IsNull(ld_metrosinsercion) THEN
					MessageBox('Advertencia','Se ha detectado un rollo con cero metros a liberar, el sistema ignorara dicho rollo, por favor verifique que todos los modelos tengan rollos para la liberaci$$HEX1$$f300$$ENDHEX$$n.',Exclamation!)
					CONTINUE
				END IF
				
				INSERT INTO dt_rollos_libera(co_fabrica_exp, cs_liberacion, nu_orden, 
					nu_cut, co_fabrica_pt, co_linea, co_referencia, co_color_pt, co_tono, 
					co_modelo, co_fabrica_tela, co_reftel, co_caract, diametro, co_color_tela, 
					cs_rollo, ca_metros, ca_unidades, fe_creacion, fe_actualizacion, usuario, 
					instancia)
				VALUES(:ai_fabricaexp, :al_liberacion, :ls_orden, :ls_cut, :li_fabrica, 
					:li_linea, :ll_referencia, :ll_color, :ls_tono, :ll_modelo, :li_fabricate, 
					:ll_reftel, :li_caract, :li_diametro, :ll_colorte, :ll_rollo, :ld_metrosinsercion,
					0, Current, Current, :as_usuario, SiteName) USING atr_transaccion;
					
				IF atr_transaccion.SQLCode = -1 THEN
					is_validacion = 'Error al insertar registro de rollo. ' + atr_transaccion.SQLErrText
					Return -1
				ELSE
					SElECT count(*)
					  INTO :ll_count
					  FROM dt_rollos_libera
					 WHERE cs_liberacion = :al_liberacion AND
					 		 cs_rollo = :ll_rollo AND
					 		 ca_metros = 0 AND
							 ca_unidades = 0;
							 
					IF ll_count = 1 THEN
						Rollback;
						MessageBox('Advertencia','Se ha detectado un rollo con cero metros a liberar, el sistema ignorara dicho rollo, por favor verifique que todos los modelos tengan rolos para la liberaci$$HEX1$$f300$$ENDHEX$$n.',Exclamation!)
						Return -1
					END IF
				END IF
				SELECT Count(*)
				INTO :li_registros
				FROM dt_consumo_rollos
				WHERE cs_rollo = :ll_rollo
				USING atr_transaccion;
				
				IF SQLCA.SQLCode = -1 THEN
					is_validacion = "Error al validar existencia consumo rollos " + SQLCA.SQLErrText
					Return -1
				END IF
				IF li_registros = 0 THEN
					INSERT INTO dt_consumo_rollos(cs_rollo, ca_metros, ca_unidades, fe_creacion,
						fe_actualizacion, usuario, instancia)
					VALUES(:ll_rollo, :ld_metrosinsercion, 0, Current, Current, :as_usuario, SiteName)
					USING atr_transaccion;
					
					IF SQLCA.SQLCode = -1 THEN
						is_validacion = "Error al insertar consumo de rollos " + SQLCA.SQLErrText
						Return -1
					END IF
				ELSE
					UPDATE dt_consumo_rollos
					SET	ca_metros = ca_metros + :ld_metrosinsercion,
							fe_actualizacion = Current,
							usuario = User,
							instancia = SiteName
					WHERE cs_rollo = :ll_rollo
					USING atr_transaccion;
					
					IF SQLCA.SQLCode = -1 THEN
						is_validacion = "Error al actualizar consumo de rollos " + SQLCA.SQLErrText
						Return -1
					END IF
				END IF
				IF ld_tela = 0 THEN
					EXIT				
				END IF
//			END IF
		NEXT
	END IF
NEXT
Return 1
end function

public function long of_generar_escalas (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario);Long li_fabrica, li_linea, li_fabricate, li_caract, li_diametro
Long li_talla, li_escalas, li_simulacion, li_fabplanta, li_planta, li_modulo
Long li_estado
Long ll_referencia, ll_color, ll_modelo, ll_reftel, ll_unidades, ll_prioridad, ll_colorte
String ls_orden, ls_cut, ls_tono
Decimal{5} ld_yield
DataStore lds_escalas
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_simulacion = luo_constantes.of_consultar_numerico("SIMULACION")

IF li_simulacion = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante SIMULACION'
	Return -1
END IF

li_fabplanta = luo_constantes.of_consultar_numerico("FABRICA PLANTA")

IF li_fabplanta = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante FABRICA PLANTA'
	Return -1
END IF

li_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACIONES")

IF li_planta = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante PLANTA LIBERACIONES'
	Return -1
END IF

li_modulo = luo_constantes.of_consultar_numerico("MODULO")

IF li_modulo = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante MODULO'
	Return -1
END IF

li_estado = luo_constantes.of_consultar_numerico("ESTADO ASIGNA")

IF li_estado = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante ESTADO ASIGNA'
	Return -1
END IF

// Mirar selects.

lds_escalas = Create DataStore

lds_escalas.DataObject = 'dtb_escalas_consolida'

IF lds_escalas.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para las telas a consolidar'
	Return -1
END IF

li_escalas = lds_escalas.Retrieve(gstr_info_usuario.codigo_usuario)

IF li_escalas = 0 THEN
	is_validacion = 'Error, no se encontraron telas para consolidar'
	Return -1
END IF

FOR li_escalas = 1 TO lds_escalas.RowCount()
	ls_orden = lds_escalas.GetItemString(li_escalas, "nu_orden")
	ls_cut = lds_escalas.GetItemString(li_escalas, "nu_cut")
	li_fabrica = lds_escalas.GetItemNumber(li_escalas, "co_fabrica_pt")
	li_linea = lds_escalas.GetItemNumber(li_escalas, "co_linea")
	ll_referencia = lds_escalas.GetItemNumber(li_escalas, "co_referencia")
	ll_color = lds_escalas.GetItemNumber(li_escalas, "co_color_pt")
	ls_tono = lds_escalas.GetItemString(li_escalas, "co_tono")
	ll_modelo = lds_escalas.GetItemNumber(li_escalas, "co_modelo")
	li_fabricate = lds_escalas.GetItemNumber(li_escalas, "co_fabrica_tela")
	ll_reftel = lds_escalas.GetItemNumber(li_escalas, "co_reftel")
	li_caract = lds_escalas.GetItemNumber(li_escalas, "co_caract")
	li_diametro = lds_escalas.GetItemNumber(li_escalas, "diametro")
	ll_colorte = lds_escalas.GetItemNumber(li_escalas, "co_color_tela")
	li_talla = lds_escalas.GetItemNumber(li_escalas, "co_talla")
	ll_unidades = lds_escalas.GetItemNumber(li_escalas, "ca_unidades")
	ld_yield = lds_escalas.GetItemNumber(li_escalas, "yield")
	
	INSERT INTO dt_escalasxtela(co_fabrica_exp, cs_liberacion, nu_orden, nu_cut, 
	   co_fabrica_pt, co_linea, co_referencia, co_color_pt, co_tono, co_modelo, co_fabrica_tela,
		co_reftel, co_caract, diametro, co_color_tela, co_talla, ca_unidades, yield, 
		fe_creacion, fe_actualizacion, usuario, instancia)
	VALUES(:ai_fabricaexp, :al_liberacion, :ls_orden, :ls_cut, :li_fabrica, :li_linea,
		:ll_referencia, :ll_color, :ls_tono, :ll_modelo, :li_fabricate, :ll_reftel, :li_caract,
		:li_diametro, :ll_colorte, :li_talla, :ll_unidades, :ld_yield, Current, Current, 
		:as_usuario, SiteName) USING atr_transaccion;
		
	IF atr_transaccion.SQLCode = -1 THEN
		is_validacion = 'Error al insertar registro de tallas. ' + atr_transaccion.SQLErrText
		Return -1
	END IF
NEXT

Return 1
end function

public function long of_generar_rectilineas (transaction atr_transaccion, long ai_fabricaexp, long al_liberacion, string as_usuario);Long li_fabrica, li_linea, li_fabricate, li_caract, li_diametro, li_raya
Long li_telas, li_rollos, li_rectilineo1, li_rectilineo2, li_tipotela, li_talla, li_registros
Long ll_referencia, ll_color, ll_modelo, ll_reftel, ll_unidades, ll_rollos, ll_colorte
Long ll_unidrollo, ll_unidrollo_usados, ll_rollo, ll_unidinsercion, ll_count
String ls_orden, ls_cut, ls_tono, ls_tonote
Decimal{5} ld_yield, ld_tela
Decimal{2} ld_ancho, ld_metros, ld_metros_usados, ld_metrosinsercion
DataStore lds_telas, lds_rollos
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")

IF li_rectilineo1 = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante RECTILINEO 1'
	Return -1
END IF

li_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 1")

IF li_rectilineo2 = -1 THEN
	is_validacion = 'Error. No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante RECTILINEO 1'
	Return -1
END IF

lds_telas = Create DataStore

lds_telas.DataObject = 'dtb_telas_consolida_rectilinea'

IF lds_telas.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para las telas a consolidar'
	Return -1
END IF

lds_rollos = Create DataStore

lds_rollos.DataObject = 'dtb_rollos_consolida_rectilinea'

IF lds_rollos.SetTransObject(atr_transaccion) = -1 THEN
	is_validacion = 'Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n para los rollos a consolidar'
	Return -1
END IF

li_telas = lds_telas.Retrieve(ai_fabricaexp, al_liberacion, li_rectilineo1, li_rectilineo2)

FOR li_telas = 1 TO lds_telas.RowCount()
	ls_orden = lds_telas.GetItemString(li_telas, "nu_orden")
	ls_cut = lds_telas.GetItemString(li_telas, "nu_cut")
	li_fabrica = lds_telas.GetItemNumber(li_telas, "co_fabrica_pt")
	li_linea = lds_telas.GetItemNumber(li_telas, "co_linea")
	ll_referencia = lds_telas.GetItemNumber(li_telas, "co_referencia")
	ll_color = lds_telas.GetItemNumber(li_telas, "co_color_pt")
	ls_tono = lds_telas.GetItemString(li_telas, "co_tono")
	ll_modelo = lds_telas.GetItemNumber(li_telas, "co_modelo")
	li_fabricate = lds_telas.GetItemNumber(li_telas, "co_fabrica_tela")
	ll_reftel = lds_telas.GetItemNumber(li_telas, "co_reftel")
	li_caract = lds_telas.GetItemNumber(li_telas, "co_caract")
	li_diametro = lds_telas.GetItemNumber(li_telas, "diametro")
	ll_colorte = lds_telas.GetItemNumber(li_telas, "co_color_tela")
	ld_ancho = lds_telas.GetItemNumber(li_telas, "ancho_cortable")
	ls_tonote = lds_telas.GetItemString(li_telas, "tono_tela")
	li_raya = lds_telas.GetItemNumber(li_telas, "raya")
	ll_unidades = lds_telas.GetItemNumber(li_telas, "ca_unidades")
	ld_yield = lds_telas.GetItemNumber(li_telas, "yield")
	ld_tela = lds_telas.GetItemNumber(li_telas, "ca_tela")
	li_talla = lds_telas.GetItemNumber(li_telas, "co_talla")
	

	li_rollos = lds_rollos.Retrieve(ls_orden, ls_cut, li_fabrica, li_linea, ll_referencia, &
		ll_color, ls_tono, ll_modelo, li_fabricate, ll_reftel, li_caract, li_diametro, ll_colorte, &
		ai_fabricaexp, al_liberacion, gstr_info_usuario.codigo_usuario, li_talla)
	
	IF li_rollos = 0 THEN
		is_validacion = 'Error, no se encontraron rollos para un estilo.'
		Return -1
	END IF
	
	FOR li_rollos = 1 TO lds_rollos.RowCount()
		ll_rollo = lds_rollos.GetItemNumber(li_rollos, "cs_rollo")
		ld_metros = lds_rollos.GetItemNumber(li_rollos, "ca_metros")
		ld_metros_usados = lds_rollos.GetItemNumber(li_rollos, "ca_metros_usado")
		ll_unidrollo = lds_rollos.GetItemNumber(li_rollos, "ca_unidades")
		ll_unidrollo_usados = lds_rollos.GetItemNumber(li_rollos, "ca_unidades_usado")
		ld_metros = ld_metros - ld_metros_usados
		ll_unidrollo = ll_unidrollo - ll_unidrollo_usados
		IF ll_unidrollo >= ll_unidades THEN
			ll_unidinsercion = ll_unidades
			ll_unidades = 0
		ELSE
			ll_unidinsercion = ll_unidrollo
			ll_unidades = ll_unidades - ll_unidrollo
		END IF
		
		//para que no inserte rectilineas sin unidades cuando consoliden liberaciones
		//jcrm
		//marzo 26 de 2008
		IF ll_unidinsercion = 0 OR IsNull(ll_unidinsercion) THEN
			MessageBox('Advertencia','Se ha detectado un rollo con cero unidades a liberar, el sistema ignorara dicho rollo, por favor verifique que todos los modelos tengan rollos para la liberaci$$HEX1$$f300$$ENDHEX$$n.',Exclamation!)
			CONTINUE
		END IF
		
		INSERT INTO dt_rollos_libera(co_fabrica_exp, cs_liberacion, nu_orden, 
			nu_cut, co_fabrica_pt, co_linea, co_referencia, co_color_pt, co_tono, 
			co_modelo, co_fabrica_tela, co_reftel, co_caract, diametro, co_color_tela, 
			cs_rollo, ca_metros, ca_unidades, fe_creacion, fe_actualizacion, usuario, 
			instancia)
		VALUES(:ai_fabricaexp, :al_liberacion, :ls_orden, :ls_cut, :li_fabrica, 
			:li_linea, :ll_referencia, :ll_color, :ls_tono, :ll_modelo, :li_fabricate, 
			:ll_reftel, :li_caract, :li_diametro, :ll_colorte, :ll_rollo, 0, 
			:ll_unidinsercion, Current, Current, :as_usuario, SiteName) USING atr_transaccion;
			
		IF atr_transaccion.SQLCode = -1 THEN
			is_validacion = 'Error al insertar registro de rollo. ' + atr_transaccion.SQLErrText
			Return -1
		ELSE
			SElECT count(*)
			  INTO :ll_count
			  FROM dt_rollos_libera
			 WHERE cs_liberacion = :al_liberacion AND
					 cs_rollo = :ll_rollo AND
					 ca_metros = 0 AND
					 ca_unidades = 0;
					 
			IF ll_count = 1 THEN
				Rollback;
				MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
				Return -1
			END IF
		END IF
		SELECT Count(*)
		INTO :li_registros
		FROM dt_consumo_rollos
		WHERE cs_rollo = :ll_rollo
		USING atr_transaccion;
		
		IF SQLCA.SQLCode = -1 THEN
			is_validacion = "Error al validar existencia consumo rollos " + SQLCA.SQLErrText
			Return -1
		END IF
		IF li_registros = 0 THEN
			INSERT INTO dt_consumo_rollos(cs_rollo, ca_metros, ca_unidades, fe_creacion,
				fe_actualizacion, usuario, instancia)
			VALUES(:ll_rollo, 0, :ll_unidinsercion, Current, Current, :as_usuario, SiteName)
			USING atr_transaccion;
			
			IF SQLCA.SQLCode = -1 THEN
				is_validacion = "Error al insertar consumo de rollos " + SQLCA.SQLErrText
				Return -1
			END IF
		ELSE
			UPDATE dt_consumo_rollos
			SET	ca_unidades = ca_unidades + :ll_unidinsercion,
					fe_actualizacion = Current,
					usuario = User,
					instancia = SiteName
			WHERE cs_rollo = :ll_rollo
			USING atr_transaccion;
			
			IF SQLCA.SQLCode = -1 THEN
				is_validacion = "Error al actualizar consumo de rollos " + SQLCA.SQLErrText
				Return -1
			END IF
		END IF		
		IF ll_unidades = 0 THEN
			EXIT
		END IF
	NEXT
NEXT
Return 1
end function

public function long of_validartipoliberacion (long ai_fab_exp, long al_liberacion, ref string as_mensaje);Long li_tipo

SELECT co_est_liberacion
  INTO :li_tipo
  FROM h_liberar_escalas
 WHERE co_fabrica_exp = :ai_fab_exp AND
 		 cs_liberacion  = :al_liberacion;
		  
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF
		  
ii_tipo_lib = li_tipo

Return li_tipo
end function

public function long of_obtenerliberacion (long al_ordencorte, ref string as_mensaje);//metodo para obtener la fabrica exp y la liberacion, y con estas determinar 
//si la liberacion es de criticas
//jcrm
//marzo 10 de 2008
Long li_fab_exp, li_result
Long ll_liberacion

SELECT DISTINCT co_fabrica_exp, cs_liberacion
  INTO :li_fab_exp,
  		 :ll_liberacion
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_ordencorte;
 
 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = sqlca.SqlErrText
	Return -1
END IF

li_result = of_validarTipoLiberacion(li_fab_exp,ll_liberacion,as_mensaje)

IF li_result = -1 THEN
	Return -1
ELSE
	Return li_result
END IF


end function

on n_cst_liberacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_liberacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

