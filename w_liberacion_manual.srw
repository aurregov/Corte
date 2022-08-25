HA$PBExportHeader$w_liberacion_manual.srw
forward
global type w_liberacion_manual from window
end type
type dw_telas_ficha from datawindow within w_liberacion_manual
end type
type dw_parametros from datawindow within w_liberacion_manual
end type
type dw_rollos from datawindow within w_liberacion_manual
end type
type dw_tallas from datawindow within w_liberacion_manual
end type
type dw_colores from datawindow within w_liberacion_manual
end type
type gb_1 from groupbox within w_liberacion_manual
end type
type gb_2 from groupbox within w_liberacion_manual
end type
type gb_3 from groupbox within w_liberacion_manual
end type
type gb_4 from groupbox within w_liberacion_manual
end type
type gb_5 from groupbox within w_liberacion_manual
end type
end forward

global type w_liberacion_manual from window
integer width = 3913
integer height = 2048
boolean titlebar = true
string title = "Liberaci$$HEX1$$f300$$ENDHEX$$n Manual"
string menuname = "m_liberacion_manual"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_consultar_rollos ( )
event ue_liberar ( )
dw_telas_ficha dw_telas_ficha
dw_parametros dw_parametros
dw_rollos dw_rollos
dw_tallas dw_tallas
dw_colores dw_colores
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_liberacion_manual w_liberacion_manual

type variables
Long il_op, il_ordenrollo
Long ii_tipoop, ii_estadodisp, ii_centroterm, ii_blanco, ii_rectilineo1
Long ii_rectilineo2
end variables

forward prototypes
public function long of_gettipo_op (long al_ordenpdn)
public function long of_validar_tanda ()
public function long of_cargar_rollos ()
public function long of_liberar ()
public function long of_get_agrupada (long al_ordenpdn)
public function long of_cargar_referencias ()
public function long of_concepto_rollo (long al_liberacion)
public function long of_validar_fabrica (long al_op)
end prototypes

event ue_consultar_rollos();long ll_fila,ll_ref,ll_count, ll_orden_agrupada, ll_color
Long li_fab,li_lin, li_fila, li_talla_1, li_talla[20]
String ls_sintaxis, ls_where
Boolean Result

li_fila = dw_colores.GetRow()
//se averigua por las tallas seleccionadas
For ll_fila =  1 To dw_tallas.RowCount()
	result = dw_tallas.IsSelected(ll_fila)
	IF result THEN
		ll_count += 1
		li_talla[ll_count] = dw_tallas.getItemNumber(ll_fila,'co_talla')
	ELSE
		
	END IF
Next

ll_color = dw_colores.GetItemNUmber(li_fila,'co_color')
li_fab 	= dw_colores.GetItemNUmber(li_fila,'co_fabrica')
li_lin 	= dw_colores.GetItemNUmber(li_fila,'co_linea')
ll_ref 	= dw_colores.GetItemNUmber(li_fila,'co_referencia')

// Cuando la orden hace parte de una orden agrupada la busqueda de los rollos
// se debe hacer con la orden agrupada.

ll_orden_agrupada = of_get_agrupada(il_op)

If ll_orden_agrupada <> 0 THEN
	il_ordenrollo = ll_orden_agrupada
Else
	il_ordenrollo = il_op
End If

If dw_rollos.Retrieve(il_ordenrollo, ll_color, li_fab, li_lin, ll_ref, li_talla, ii_estadodisp, ii_centroterm) > 0 Then
	dw_rollos.SetFocus()
Else
	MessageBox('Advertencia','No existen rollos que cumplan con las condiciones se$$HEX1$$f100$$ENDHEX$$aladas, por favor verifique.')
	dw_rollos.reset()
	Return
End if
end event

event ue_liberar();Long ll_liberar
Long li_result

ll_liberar = of_liberar()
IF ll_liberar = -1 THEN
	ROLLBACK;
ELSE
	IF ll_liberar <> 0 THEN
		li_result = of_concepto_rollo(ll_liberar) 
		IF li_result = 0 Then
			Commit;
			MessageBox("Liberaci$$HEX1$$f300$$ENDHEX$$n Exitosa","Se ha generado la liberaci$$HEX1$$f300$$ENDHEX$$n: " + String(ll_liberar))
			dw_tallas.Reset()
			dw_rollos.Reset()
		END IF
	END IF
END IF
	
end event

public function long of_gettipo_op (long al_ordenpdn);Long li_registros

SELECT Count(*)
INTO :li_registros
FROM dt_caxpedidos
WHERE cs_ordenpd_pt = :al_ordenpdn;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar el tipo de orden de producci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
END IF

IF li_registros = 0 THEN
	Return 2
ELSE
	Return 1
END IF
end function

public function long of_validar_tanda ();Long li_filas, li_fila_actual, li_tono
Long ll_color[], ll_color_ant, ll_color_act, ll_colores
Long ll_tanda, ll_tanda_act

// Ordenamos los rollos por color de tela, para seleccionar los diferentes colores y validar la tanda
dw_rollos.SetSort("co_color_te A")

dw_rollos.Sort()

ll_color_ant = -1
ll_colores = 0
FOR li_filas = 1 TO dw_rollos.RowCount()
	IF dw_rollos.IsSelected(li_filas) THEN
		ll_color_act = dw_rollos.GetItemNumber(li_filas, "co_color_te")
		IF ll_color_act <> ll_color_ant THEN
			ll_colores = ll_colores + 1
			ll_color[ll_colores] = ll_color_act
			ll_color_ant = ll_color_act
		END IF
	END IF
NEXT

// Vamos a recorrer los diferentes colores y validar la tanda
IF ll_colores > 0 THEN
	FOR li_filas = 1 TO ll_colores
		ll_tanda = -1		
		ll_color_act = ll_color[li_filas]
		dw_rollos.SetFilter("(mt >0 OR  ca_unidades > 0) and IsSelected() AND co_color_te = " + String(ll_color_act))
		dw_rollos.Filter()
		FOR li_fila_actual = 1 TO dw_rollos.RowCount()
			ll_tanda_act = dw_rollos.GetItemNumber(li_fila_actual, "cs_tanda")
			li_tono = dw_rollos.GetItemNumber(li_fila_actual, "co_tono")
			
			IF ll_tanda <> -1 THEN
				IF (ll_tanda <> ll_tanda_act) and li_tono <> 1 THEN
					MessageBox("Advertencia...","Ha seleccionado tandas diferentes para el color de tela " + String(ll_color[li_filas]))
					dw_rollos.SetFilter("")
					dw_rollos.Filter()
					dw_rollos.SetSort("cs_tanda A, co_reftel A, co_caract A, co_color_te A, mt A, unidades A")
					dw_rollos.Sort()
					
					Return -1
				END IF
			ELSE
				ll_tanda = ll_tanda_act
			END IF
		NEXT
	NEXT
ELSE
	MessageBox("Advertencia...","No ha seleccionado rollos a utilizar en la liberaci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
END IF

dw_rollos.SetFilter("")
dw_rollos.Filter()
dw_rollos.SetSort("cs_tanda A, co_reftel A, co_caract A, diametro A, co_color_te A, mt A, unidades A")
dw_rollos.Sort()

Return 1
end function

public function long of_cargar_rollos ();Long li_filas, li_talla, li_caract, li_diametro, li_marca, li_caractfinal
Long li_bodysize, li_tipo_tela
Long ll_rollo, ll_reftel, ll_tanda, ll_unidades, ll_unidadeslib, ll_color
Decimal{2} ld_ancho, ld_metros, ld_metroslib

FOR li_filas = 1 TO dw_rollos.RowCount()
	IF dw_rollos.IsSelected(li_filas) THEN
		ll_rollo = dw_rollos.GetItemNumber(li_filas, "cs_rollo")
		li_talla = dw_rollos.GetItemNumber(li_filas, "co_talla")
		ll_reftel = dw_rollos.GetItemNumber(li_filas, "co_reftel")
		li_caract = dw_rollos.GetItemNumber(li_filas, "co_caract")
		li_diametro = dw_rollos.GetItemNumber(li_filas, "diametro")
		ll_color = dw_rollos.GetItemNumber(li_filas, "co_color_te")
		ld_ancho = dw_rollos.GetItemNumber(li_filas, "ancho_tub_term")
		ld_metros = dw_rollos.GetItemNumber(li_filas, "ca_mt")
		ll_unidades = dw_rollos.GetItemNumber(li_filas, "ca_unidades")
		ld_metroslib = dw_rollos.GetItemNumber(li_filas, "ca_mts_lib")
		ll_unidadeslib = dw_rollos.GetItemNumber(li_filas, "ca_und_lib")
		ll_tanda = dw_rollos.GetItemNumber(li_filas, "cs_tanda")
		li_bodysize = dw_rollos.GetItemNumber(li_filas, "sw_bodysize")
		li_caractfinal = dw_rollos.GetItemNumber(li_filas, "co_caract_final")
		li_tipo_tela= dw_rollos.GetItemNumber(li_filas, "co_tiptel")
		
		IF (li_tipo_tela <> ii_rectilineo1) AND (li_tipo_tela <> ii_rectilineo2) THEN
			li_talla = 9999
		END IF
		INSERT INTO temp_tela(cs_rollo, co_talla, co_reftel, co_caract,
			diametro, co_color, ancho, metros, unidades, metros_cons,
			unidades_cons, cs_tanda, sw_marca, co_caract_final)
		VALUES(:ll_rollo, :li_talla, :ll_reftel, :li_caract, :li_diametro,
			:ll_color, :ld_ancho, :ld_metros, :ll_unidades, :ld_metroslib,
			:ll_unidadeslib, :ll_tanda, :li_bodysize, :li_caractfinal);
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al insertar registro de rollos en temporal " + SQLCA.SQLErrText)
			Return -1
		END IF
	END IF
NEXT

//Se debe validar con las telas que hay en la ficha contra lo que hay temp_Tela
//para verificar que esten todas las telas que se necesitan, en los rectilineos
//se debe hacer a nivel de talla, en las telas con la talla 9999



Return 1
end function

public function long of_liberar ();Long ll_unidades, ll_referencia, ll_liberacion, ll_color
Long li_rectilineo1, li_rectilineo2, li_fabrica, li_linea, li_filacol
Long li_fabricalib
String ls_orden, ls_cut, ls_usuario
Date ldt_entrega
n_cts_constantes luo_constantes
n_cst_liberacion luo_liberacion
s_base_parametros lstr_parametros

// Para el proceso de liberaci$$HEX1$$f300$$ENDHEX$$n vamos a utilizar todos los SP definidos para la liberaci$$HEX1$$f300$$ENDHEX$$n autom$$HEX1$$e100$$ENDHEX$$tica

DECLARE sp_crea_temp PROCEDURE FOR
	pr_crear_temporales();
	
EXECUTE sp_crea_temp;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al crear las temporales para el proceso de liberaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
	Return -1
END IF

IF of_validar_tanda() = -1 THEN
	Return -1
ELSE
	IF of_cargar_rollos() = -1 THEN
		Return -1
	ELSE
		ll_unidades = of_cargar_referencias()
		IF ll_unidades = -1 THEN
			Return -1
		ELSE
			luo_constantes = Create n_cts_constantes
			
			li_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")
			IF li_rectilineo1 = -1 THEN
				Return -1
			END IF
			li_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 2")
			IF li_rectilineo2 = -1 THEN
				Return -1
			END IF
			li_filacol = dw_colores.GetRow()
			IF li_filacol = -1 THEN
				MessageBox("Error Base Datos","Error al tomar la fila de colores")
				Return -1
			END IF
			li_fabrica = dw_colores.GetItemNumber(li_filacol, "co_fabrica")
			li_linea = dw_colores.GetItemNumber(li_filacol, "co_linea")
			ll_referencia = dw_colores.GetItemNumber(li_filacol, "co_referencia")
			ll_color = dw_colores.GetItemNumber(li_filacol, "co_color")
			DECLARE sp_consumos PROCEDURE FOR
				pr_cargar_consumos(:li_fabrica, :li_linea, :ll_referencia, :ll_color,
					:il_op, :li_rectilineo1, :li_rectilineo2);

			EXECUTE sp_consumos;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al ejecutar el SP que calcula las unidades por modelo " + SQLCA.SQLErrText)
				Return -1
			END IF
			
			DECLARE sp_unidadesmod PROCEDURE FOR
				pr_unidades_modelo(:li_fabrica, :li_linea, :ll_referencia, :ll_color,
					:li_rectilineo1, :li_rectilineo2, :ll_unidades, :il_op, 1, 0);
			
			EXECUTE sp_unidadesmod;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al ejecutar el SP que calcula las unidades por modelo " + SQLCA.SQLErrText)
				Return -1
			END IF
			DECLARE sp_unidadeslib PROCEDURE FOR
				pr_unidades_lib(:li_fabrica, :li_linea, :ll_referencia, :ll_color, :li_rectilineo1, 
					:li_rectilineo2, :il_op);
			
			EXECUTE sp_unidadeslib;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al ejecutar el SP que calcula las unidades de la liberaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
				Return -1
			END IF
			FETCH sp_unidadeslib INTO :ll_unidades;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al consultar las unidades liberadas " + SQLCA.SQLErrText)
				Return -1
			END IF
			CLOSE sp_unidadeslib;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al cerrar el SP que calcula las unidades liberadas " + SQLCA.SQLErrText)
				Return -1
			END IF
			IF ll_unidades > 0 THEN
				lstr_parametros.entero[1] = li_fabrica
				lstr_parametros.entero[2] = li_linea
				lstr_parametros.entero[3] = ll_referencia
				lstr_parametros.entero[4] = ll_color
				lstr_parametros.entero[5] = il_op
				OpenWithParm(w_consulta_unidades_liberadas, lstr_parametros)
				lstr_parametros = Message.PowerObjectParm
				IF lstr_parametros.boolean[1] THEN
					li_fabricalib = luo_constantes.of_consultar_numerico("FABRICA LIBERACIONES")
					IF li_fabricalib = -1 THEN
						Return -1
					END IF
					IF Not luo_liberacion.of_consecutivo(li_fabricalib, ll_liberacion) THEN
						MessageBox("Advertencia...","Error al consultar el consecutivo de liberaci$$HEX1$$f300$$ENDHEX$$n " + luo_liberacion.of_getvalidacion())
						Return -1
					END IF
					ls_orden = dw_colores.GetItemString(li_filacol, "nu_orden")
					ls_cut = dw_colores.GetItemString(li_filacol, "nu_cut")
					ldt_entrega = dw_colores.GetItemDate(li_filacol, "fe_entrega")
					
					SELECT DISTINCT usuario
					  INTO :ls_usuario
					  FROM h_ordenpd_pt
					 WHERE cs_ordenpd_pt = :il_op;
					 
					IF SQLCA.SQLCode = -1 THEN
						MessageBox('Error Base Datos','Error verificando el usuario due$$HEX1$$f100$$ENDHEX$$o de la O.P., Error: ' + SQLCA.SQLErrText)
						Return -1
					END IF	
					
					INSERT INTO h_liberar_escalas(co_fabrica_exp, cs_liberacion, co_est_liberacion, 
						co_tip_liberacion, fe_creacion, fe_actualizacion, usuario, instancia)
					VALUES(:li_fabricalib, :ll_liberacion, 1, 1, Current, Current, :ls_usuario, SiteName);
					
					IF SQLCA.SQLCode = -1 THEN
						MessageBox('Error Base Datos','Error insertando encabezado liberaci$$HEX1$$f300$$ENDHEX$$n. ' + SQLCA.SQLErrText)
						Return -1
					END IF		
					
					DECLARE sp_cargar_liberacion PROCEDURE FOR
						pr_cargar_liberacion(:li_fabricalib, :ll_liberacion, :ls_orden, :ls_cut, :li_fabrica, :li_linea, 
							:ll_referencia, :ll_color, :il_op, :ldt_entrega, :ll_unidades, :il_ordenrollo, :ii_estadodisp,
							:ii_centroterm, :li_rectilineo1, :li_rectilineo2, :ii_tipoop, 1, :ii_blanco, 1, :ls_usuario);
	
					EXECUTE sp_cargar_liberacion;
					IF SQLCA.SQLCode = -1 THEN
						MessageBox("Error Base Datos","Error al cargar las tablas de la liberaci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
						Return -1
					ELSE
						Return ll_liberacion
					END IF
				ELSE
					Return -1
				END IF
			ELSE
				MessageBox("Advertencia...","Con la informaci$$HEX1$$f300$$ENDHEX$$n seleccionada no se puede hacer una liberaci$$HEX1$$f300$$ENDHEX$$n")
				Return 0
			END IF
		END IF
	END IF
END IF
Return 1
end function

public function long of_get_agrupada (long al_ordenpdn);Long ll_ordenpdn

SELECT cs_ordenpd_pt
INTO :ll_ordenpdn
FROM dt_ordenes_agrupad
WHERE cs_ordenpd_pt_agru = :al_ordenpdn;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al validar si la orden de producci$$HEX1$$f300$$ENDHEX$$n es agrupada " + SQLCA.SQLErrText)
	Return -1
ELSE
	IF SQLCA.SQLCode = 100 THEN
		Return 0
	ELSE
		Return ll_ordenpdn
	END IF
END IF
end function

public function long of_cargar_referencias ();Long li_fabrica, li_linea, li_talla, li_filacol, li_tallas
Long ll_referencia, ll_unidades, ll_totunidades, ll_color
Decimal{5} ld_porcentaje

li_filacol = dw_colores.GetRow()
IF li_filacol = -1 THEN
	MessageBox("Error Base Datos","Error al obtener la fila del color")
	Return -1
ELSE
	li_fabrica = dw_colores.GetItemNumber(li_filacol, "co_fabrica")
	li_linea = dw_colores.GetItemNumber(li_filacol, "co_linea")
	ll_referencia = dw_colores.GetItemNumber(li_filacol, "co_referencia")
	ll_color = dw_colores.GetItemNumber(li_filacol, "co_color")
	ll_totunidades = 0
	
// Totalizamos las unidades para calcular el porcentaje por talla	
	FOR li_tallas = 1 TO dw_tallas.RowCount()
		IF dw_tallas.IsSelected(li_tallas) THEN
			ll_unidades =  dw_tallas.GetItemNumber(li_tallas, "ca_programar")
			ll_totunidades = ll_totunidades + ll_unidades
		END IF
	NEXT
	
	FOR li_tallas = 1 TO dw_tallas.RowCount()
		IF dw_tallas.IsSelected(li_tallas) THEN		
			li_talla = dw_tallas.GetItemNumber(li_tallas, "co_talla")
			ll_unidades =  dw_tallas.GetItemNumber(li_tallas, "ca_programar")
			ld_porcentaje = ll_unidades / ll_totunidades
			INSERT INTO temp_referencias(co_fabrica, co_linea, co_referencia, co_talla,
				co_color, ca_unidades, porc_participacion, cs_ordenpd_pt)
			VALUES(:li_fabrica, :li_linea, :ll_referencia, :li_talla, :ll_color,
				:ll_unidades, :ld_porcentaje, :il_op);
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al insertar registro de referencia " + SQLCA.SQLErrText)
				Return -1
			END IF
		END IF
	NEXT
END IF

Return ll_totunidades
end function

public function long of_concepto_rollo (long al_liberacion);//metodo para poder colocar el concepto al rollo cuando se genere la liberacion
//por la forma manual.
//elaborado por jcrm
//fecha agosto 24 de 2006
Long ll_fila, ll_cs_rollo
String ls_error
DataStore lds_rollos_libera

lds_rollos_libera = Create DataStore
lds_rollos_libera.DataObject = 'dgr_rollos_conceptos_texografo_15'
lds_rollos_libera.Retrieve(al_liberacion)

For ll_fila = 1 To lds_rollos_libera.RowCount()
	ll_cs_rollo = lds_rollos_libera.GetItemNumber(ll_fila,'cs_rollo')
	
	UPDATE m_rollo
	   SET co_planeador = 75
	 WHERE cs_rollo = :ll_cs_rollo AND
	 		 co_centro = 15 AND
			 co_planeador <> 75;
			 
	IF sqlca.sqlcode = -1 Then
		ls_error = sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el concepto del rollo, ERROR: '+ls_error)
		Return -1
	End if
	
Next

Return 0




end function

public function long of_validar_fabrica (long al_op);//metodo para establecer si la orden de produccion pertenece a la fabrica activa.
//jcrm
//junio 5 de 2007
Long ll_count
Long li_centroterm
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

//se modifica el centro de tela terminado a 15 si la fabrica es MARINILLA o 21 si es PEREIRA
//jcrm
//mayo 27 de 2007
IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
	IF li_centroterm = -1 THEN
		MessageBox('Error','No fue posible establecer el centro de los rollos para Marinilla.')
		Return -1
	END IF
END IF

IF gstr_info_usuario.co_planta_pro = 99 THEN
	li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA PEREIRA")
	IF li_centroterm = -1 THEN
		MessageBox('Error','No fue posible establecer el centro de los rollos para Pereira.')
		Return -1
	END IF
END IF

SELECT count(*)
  INTO :ll_count
  FROM m_rollo
 WHERE cs_orden_pr_act = :al_op AND
       co_centro = :li_centroterm;

		  
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la orden de producci$$HEX1$$f300$$ENDHEX$$n, ERROR: '+ sqlca.SqlErrText,StopSign!)
	Return -1
END IF

IF ll_count > 0 THEN
	Return 0
ELSE
	MessageBox('Advertencia','La orden de producci$$HEX1$$f300$$ENDHEX$$n no pertenece a la planta: '+gstr_info_usuario.fabrica+ ' o no tiene rollos en el centro de tela terminada. ',Exclamation!)
	//Return -1
		Return 0
END IF
end function

on w_liberacion_manual.create
if this.MenuName = "m_liberacion_manual" then this.MenuID = create m_liberacion_manual
this.dw_telas_ficha=create dw_telas_ficha
this.dw_parametros=create dw_parametros
this.dw_rollos=create dw_rollos
this.dw_tallas=create dw_tallas
this.dw_colores=create dw_colores
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.Control[]={this.dw_telas_ficha,&
this.dw_parametros,&
this.dw_rollos,&
this.dw_tallas,&
this.dw_colores,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5}
end on

on w_liberacion_manual.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_telas_ficha)
destroy(this.dw_parametros)
destroy(this.dw_rollos)
destroy(this.dw_tallas)
destroy(this.dw_colores)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
end on

event open;This.x = 1
This.y = 1
s_base_parametros lstr_parametros
n_cts_constantes luo_constantes

messagebox('advertencia','esta liberacion se deshabilito, utilize la liberacion semiautomatica')
close(this)

dw_rollos.SetTransObject(SQLCA)
dw_parametros.SetTransObject(SQLCA)
dw_telas_ficha.SetTransObject(SQLCA)

dw_parametros.InsertRow(0)

luo_constantes = Create n_cts_constantes

ii_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF ii_estadodisp = -1 THEN
	Return -1
END IF
ii_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
IF ii_centroterm = -1 THEN
	Return -1
END IF

ii_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")
IF ii_rectilineo1 = -1 THEN
	Return -1
END IF 

ii_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 2")
IF ii_rectilineo2 = -1 THEN
	Return -1
END IF 



//dw_parametros.Modify("DataWindow.QueryMode=yes")

//primero se busca la oden de produccion
//Open(w_buscar_op)
//
//lstr_parametros = message.PowerObjectParm	
//
//il_op = lstr_parametros.entero[1]
//
//If lstr_parametros.hay_parametros Then
//	
//// Verificamos	si la orden es de exportaciones para decidir que datawindows colocamos para seleccionar los colores y tallas
//	ii_tipoop = of_gettipo_op(il_op)
//	IF ii_tipoop = 1 THEN
//		// Exportaciones
//		dw_colores.DataObject = 'dgr_colores_liberacion_exportaciones'
//		dw_tallas.DataObject = 'dgr_tallas_liberacion_exportaciones'
//	END IF
//	dw_colores.SetTransObject(SQLCA)
//	dw_tallas.SetTransObject(SQLCA)
//	If dw_colores.Retrieve(il_op) < 1 Then
//		MessageBox('Error','la Orden de Producci$$HEX1$$f300$$ENDHEX$$n: '+String(il_op)+' no tiene asociados colores, por favor verifique.')
//		Return
//	End if
//	dw_colores.SetFocus()
//Else
//	dw_colores.Reset()
//	dw_tallas.reset()
//	MessageBox('Error','Para poder desplegar informaci$$HEX1$$f300$$ENDHEX$$n en pantalla, es necesario seleccionar una orden de producci$$HEX1$$f300$$ENDHEX$$n.')
//	Return
//End if
//
//
end event

type dw_telas_ficha from datawindow within w_liberacion_manual
integer x = 1344
integer y = 240
integer width = 2331
integer height = 356
integer taborder = 40
string title = "none"
string dataobject = "dgr_telas_ficha"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type dw_parametros from datawindow within w_liberacion_manual
integer x = 32
integer y = 52
integer width = 3246
integer height = 96
integer taborder = 10
string title = "none"
string dataobject = "dff_parametros_orden_produccion"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long ll_ordenpdn

IF Dwo.Name = 'cs_ordenpd_pt' THEN
	ll_ordenpdn = Long(Data)
	IF ll_ordenpdn <> 0 THEN
		IF of_validar_fabrica(ll_ordenpdn) = -1 THEN
			Return
		END IF
		IF dw_parametros.Retrieve(ll_ordenpdn) > 0 THEN
			il_op = ll_ordenpdn
	
		// Verificamos	si la orden es de exportaciones para decidir que datawindows colocamos para seleccionar los colores y tallas
			ii_tipoop = of_gettipo_op(il_op)
			IF ii_tipoop = 1 THEN
				// Exportaciones
				dw_colores.DataObject = 'dgr_colores_liberacion_exportaciones'
				dw_tallas.DataObject = 'dgr_tallas_liberacion_exportaciones'
			ELSE
				dw_colores.DataObject = 'dgr_colores_liberacion_manual'
				dw_tallas.DataObject = 'dgr_tallas_liberacion_manual'				
			END IF
			dw_colores.SetTransObject(SQLCA)
			dw_tallas.SetTransObject(SQLCA)
			If dw_colores.Retrieve(il_op) < 1 Then
				MessageBox('Error','la Orden de Producci$$HEX1$$f300$$ENDHEX$$n: '+String(il_op)+' no tiene asociados colores, por favor verifique.')
				Return
			End if
			dw_colores.SetFocus()
			dw_rollos.Reset()
		ELSE
			dw_parametros.Reset()
			dw_parametros.InsertRow(0)
			dw_colores.Reset()
			dw_tallas.reset()
			dw_rollos.Reset()			
		END IF
	END IF
END IF
end event

type dw_rollos from datawindow within w_liberacion_manual
integer x = 1344
integer y = 688
integer width = 2501
integer height = 1080
integer taborder = 50
string title = "none"
string dataobject = "dgr_rollos_liberacion_manual"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Boolean Result

result = This.IsSelected(Row)

IF result THEN
   This.SelectRow(Row, FALSE)
ELSE
   This.SelectRow(Row, TRUE)
END IF
end event

event retrieveend;Long li_tonoblanco, li_fabrica, li_linea, li_filas, li_tono
n_cts_constantes luo_constantes

li_filas = dw_parametros.GetRow()

li_fabrica = dw_parametros.GetItemNumber(li_filas, "co_fabrica")
li_linea = dw_parametros.GetItemNumber(li_filas, "co_linea")
IF li_fabrica = 2 AND (li_linea = 6 OR li_linea = 23) THEN
	ii_blanco = 1
ELSE
	ii_blanco = 0
END IF

IF ii_blanco = 1 THEN
	luo_constantes = Create n_cts_constantes
	li_tonoblanco = luo_constantes.of_consultar_numerico("TONO BLANCO")
	FOR li_filas = 1 TO dw_rollos.RowCount()
		li_tono = dw_rollos.GetItemNumber(li_filas, "co_tono")
		IF li_tono = li_tonoblanco THEN
			dw_rollos.SetItem(li_filas, "cs_tanda", 0)
		END IF
	NEXT
END IF
This.Sort()
end event

type dw_tallas from datawindow within w_liberacion_manual
integer x = 14
integer y = 1224
integer width = 1289
integer height = 540
integer taborder = 40
string title = "none"
string dataobject = "dgr_tallas_liberacion_manual"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Boolean Result

result = This.IsSelected(Row)

IF result THEN
   This.SelectRow(Row, FALSE)
ELSE
   This.SelectRow(Row, TRUE)
END IF
end event

type dw_colores from datawindow within w_liberacion_manual
integer x = 27
integer y = 236
integer width = 1280
integer height = 900
integer taborder = 30
string title = "none"
string dataobject = "dgr_colores_liberacion_manual"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Long li_tallas, li_fabrica, li_linea
String ls_orden, ls_cut
Long ll_referencia, ll_color

If row < 0 Then Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

//ya seleccionaron un color, ahora se deben desplegar las tallas de op y el color
li_fabrica = dw_parametros.GetItemNumber(1, 'co_fabrica')
li_linea = dw_parametros.GetItemNumber(1, 'co_linea')
ll_referencia = dw_parametros.GetItemNumber(1, 'co_referencia')
If ii_tipoop = 1 THEN
	ls_orden = This.GetItemString(Row, 'nu_orden')
	ls_cut = This.GetItemString(Row, 'nu_cut')
	ll_color = This.GetItemNumber(row,'co_color')
	li_tallas = dw_tallas.Retrieve(il_op, ls_orden, ls_cut, ll_color)
Else
	ll_color = This.GetItemNumber(row,'co_color')		
	li_tallas = dw_tallas.Retrieve(il_op,ll_color)
End If

If li_tallas > 0 Then
	dw_telas_ficha.Retrieve(li_fabrica, li_linea, ll_referencia, ll_color)	
	dw_tallas.SetFocus()
Else
	Messagebox('Error','No existen datos de tallas para la orden de producci$$HEX1$$f300$$ENDHEX$$n: '+String(il_op)+', en el color: '+String(ll_color))
	Return
End if

end event

type gb_1 from groupbox within w_liberacion_manual
integer x = 5
integer y = 176
integer width = 1312
integer height = 980
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Colores "
end type

type gb_2 from groupbox within w_liberacion_manual
integer x = 5
integer y = 1172
integer width = 1312
integer height = 608
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Tallas "
end type

type gb_3 from groupbox within w_liberacion_manual
integer x = 1326
integer y = 628
integer width = 2528
integer height = 1152
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Rollos "
end type

type gb_4 from groupbox within w_liberacion_manual
integer x = 5
integer width = 3291
integer height = 164
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Orden Producci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_5 from groupbox within w_liberacion_manual
integer x = 1335
integer y = 176
integer width = 2345
integer height = 440
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Telas Ficha"
end type

