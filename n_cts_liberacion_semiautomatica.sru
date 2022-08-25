HA$PBExportHeader$n_cts_liberacion_semiautomatica.sru
forward
global type n_cts_liberacion_semiautomatica from nonvisualobject
end type
end forward

global type n_cts_liberacion_semiautomatica from nonvisualobject autoinstantiate
end type

type variables
Long ii_fabexp, ii_prioridad, ii_sucursal, ii_coleccion, ii_zona, ii_inserto, il_linea_exp 
Long il_liberacion, il_pedido_pdp, il_cliente, il_pedido_anterior, ii_porc_mas, il_pedido_op, il_op_agrupada
Date	idt_fe_despacho
String	is_instresp_empq, is_tipo_orden, is_ref_exp, is_color_exp
Boolean ib_carga_reposo



 
end variables

forward prototypes
public function long of_establecercsliberacion ()
public function long of_validarliberacion (long al_ordenpd_pt)
public function string of_usuarioop (long al_op)
public function long of_act_concepto_rollo (long al_rollo)
public function long of_anocriticas ()
public function long of_semanacritica (long ai_ano)
public function long of_cargarhliberarescalas (string as_usuario, long ai_tipo)
public function long of_acttandarollo (long al_rollo, string as_tono, ref string as_mensaje)
public function long of_insertar_maestro_pdp (long al_cantidad, date adt_fe_despacho, long li_fabrica_vta, long ai_fabrica_ref, long ai_linea_ref, long al_referencia, long al_liberacion, long al_op_estilo, string as_po)
public function long of_cargar_datos_pedido_inicial (ref long ai_fabrica_vta, ref string as_tipo_pedido, ref long al_cliente, ref long ai_sucursal, ref string as_orden_compra, ref long ai_coleccion, ref string as_grupo, ref long ai_empaque, ref long ai_caja, long al_pedido, long al_op_estilo, string as_po, ref long as_marca_edi, ref string as_pr_especial, ref string as_marca_adicional)
public function long of_actualizar_liberacion (long ai_fabexp, long al_liberacion, long al_ordenpd, long al_color)
public function long of_cargarordenproduccion (long al_ordenpd_pt, long ai_talla, long al_color, long al_unidades, string as_po)
protected function long of_cargardtliberaestilos (long ai_fab, long ai_lin, long al_color, long al_unidades, long al_ref, string as_tono, string as_po, string as_cut, long al_ordenpd_pt, decimal adc_consumo, string as_usuario)
public function long of_cargardttelaxmodelolib (long ai_fab, long ai_lin, long al_ref, long al_color, long al_cant_prog, long ai_tal, long ai_cal, string as_po, string as_cut, long ai_raya, decimal adc_ancho, long al_mod, long al_reftel, long ai_caract, long ai_dia, long al_colorte, string as_tono, decimal adc_consumo, long al_ordenpd_pt, string as_usuario)
public function long of_cargardtescalasxtela (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, string as_tono, long al_mod, long ai_fabte, long al_reftel, long ai_caract, long ai_dia, long al_colorte, long ai_talla, long al_unidades, long ai_cal, string as_po, string as_cut, decimal adc_yield, long al_ordenpd_pt, decimal ad_ancho, string as_usuario)
public function long of_criticas (long ai_fabrica, long ai_linea, long al_referencia, long ai_talla, long al_color, long al_unidades)
public function long of_cargardtrolloslibera (string as_usuario, long al_ordenpd_pt, string as_po, long al_color, decimal adc_ancho, long al_tanda, string as_usuario_op, long ai_tipo)
public function long of_insertar_talla_pedido_pdn (long al_pedido, string as_po, string as_cut, long ai_fab, long ai_linea, long al_ref, long ai_item, long ai_talla, long al_color, long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, string as_talla_exp, long al_cantidad, date adt_fe_despacho, long ai_cliente, long ai_sucursal, long ai_coleccion)
public subroutine of_buscar_fabrica_exp (long ai_fab, long ai_linea, long al_referencia, long al_color, long ai_talla, ref long ai_fabrica_exp)
public function long of_anular_unidades_po (long ai_fabrica, long ai_linea, long al_referencia, long al_color_pt, long ai_talla, long ai_linea_exp, string as_ref_exp, string as_color_exp, string as_talla_exp, long ai_unidades)
public function long of_verificar_pedido_en_op (long al_ordenpd_pt, long al_color_pt, long ai_talla, string as_po, string as_color_exp, string as_talla_exp)
public function long of_cargardttallapdnmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, long ai_talla, long al_unidades, string as_po, string as_cut, string as_tono, long ai_proporcion, string as_usuario, long al_op_estilo, long ai_tipo_lib, long ai_consc_talla, long al_cons_lib_duo, string as_color_exp, long ai_linea_exp, string as_ref_exp, string as_talla_exp, long ai_fab_exp, long al_unid_prog)
public function long of_cargar_temporal_lib_duo (long al_cons_lib_duo, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long ai_talla, long al_unidades, long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, string as_talla_exp, long al_unid_prog_op)
private function long of_cargardtpdnxmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_color, long al_unidades, string as_po, string as_cut, string as_tono, long al_ordenpd_pt, string as_usuario, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, long ai_tipo_lib, decimal adc_ancho)
public function integer of_cargar_ops_agrupadas (string as_usuario, long al_liberacion)
public function long of_generar_liberacion (string as_usuario, long al_ordenpd_pt, string as_po, long al_color, decimal adc_ancho, long al_tanda, long ai_tipo, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, long ai_fab_exp, long al_op_agrupada)
end prototypes

public function long of_establecercsliberacion ();String ls_error
Long ll_count

SELECT nvl(Max(cs_liberacion),0) + 1
INTO :il_liberacion
FROM h_liberar_escalas
WHERE co_fabrica_exp = :ii_fabexp;
IF SQLCA.SQLCode = -1 THEN
	ls_error = SQLCA.SQLErrText
	Rollback;
	MessageBox('Error','Error al consultar el consecutivo. ' + ls_error)
	Return -1
END IF

//se esta presentando que el consecutivo que sacamos de aca ya existe en dt_pdnxmodulo, se va hacer que si el consecutivo 
//se halla en dicha tabla lo traemos de esta.
//noviembre 28 de 2008
//jcrm

SELECT count(*)
  INTO :ll_count
  FROM dt_pdnxmodulo
 WHERE cs_liberacion = :il_liberacion;
 
IF ll_count > 0 THEN
	//es porque el consecutivo esta errado
	SELECT nvl(Max(cs_liberacion),0) + 1
		INTO :il_liberacion
		FROM dt_pdnxmodulo;
	
	IF SQLCA.SQLCode = -1 THEN
		ls_error = SQLCA.SQLErrText
		Rollback;
		MessageBox('Error','Error al consultar el consecutivo. ' + ls_error)
		Return -1
	END IF
END IF

Return 0
end function

public function long of_validarliberacion (long al_ordenpd_pt);//solo se perite liberar por la semiautomatica si la O.P. no tiene asociadas
//m$$HEX1$$e100$$ENDHEX$$s de una tela.
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM h_ordenpd_te
 WHERE cs_ordenpd_pt = :al_ordenpd_pt; 

IF Sqlca.SqlCode = -1 THEN
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar las telas de la O.P. '+Sqlca.SqlErrText)
	Return -1
END IF

IF ll_count > 1 THEN
	MessageBox('Error','La O.P. tiene asociadas m$$HEX1$$e100$$ENDHEX$$s de dos telas, loque no permite que se libere por esta opci$$HEX1$$f300$$ENDHEX$$n.')
	Return -1
END IF


Return 0
end function

public function string of_usuarioop (long al_op);//metodo para conocer cual es el usuario due$$HEX1$$f100$$ENDHEX$$o de una O.P., para que todas las liberaciones
//queden grabadas con este usuario y no con el que tiene el sistema.
//cambio pedido por Hector Osorno
//elaborado po jcrm
//fecha junio 21 de 2006
String ls_usuario

SELECT Distinct usuario
  INTO :ls_usuario
  FROM h_ordenpd_pt
 WHERE cs_ordenpd_pt = :al_op;
 
 If sqlca.sqlcode = -1 Then
	MessageBox('Error Base Datos','Ocurr$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer el usuario de la O.P., ERROR: '+sqlca.SqlErrText)
   Return ''
End if


Return ls_usuario
end function

public function long of_act_concepto_rollo (long al_rollo);//metodo para modificar el concepto del rollo, y saber que se puede programar a texografo.
String ls_error
DateTime		ldt_fecha

ldt_fecha = f_fecha_servidor()

UPDATE m_rollo
	SET (co_planeador, fe_act_cpto) = (75, :ldt_fecha)
 WHERE cs_rollo = :al_rollo;
 
If sqlca.sqlcode = -1 Then
	ls_error = sqlca.SqlErrText
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el concepto del rollo, ERROR: '+ls_error)
	Return -1
End if


Return 0
 
end function

public function long of_anocriticas ();//trae el maximo a$$HEX1$$f100$$ENDHEX$$o que exista en la tabla que genera el reporte de referencias de lineas
//criticas en el cedi.
//jcrm
//diciembre 11 de 2007

Long li_ano

SELECT max(ano)
  INTO :li_ano
  FROM t_criticas_cedi;
  
Return li_ano  
end function

public function long of_semanacritica (long ai_ano);//trae la maxima semana que exista en la tabla que genera el reporte de referencias de lineas
//criticas del cedi, para un a$$HEX1$$f100$$ENDHEX$$o especifico.
//jcrm
//diciembre 11 de 2007

Long li_semana

SELECT max(semana)
  INTO :li_semana
  FROM t_criticas_cedi
 WHERE ano = :ai_ano ;
 
 
Return li_semana 
end function

public function long of_cargarhliberarescalas (string as_usuario, long ai_tipo);DateTime ldt_fecha
Long li_est_lib, li_tip_lib
String ls_error

//---------------------------------------se determina el estado de la liberacion
IF ai_tipo = 1 THEN //liberacion por la semiautomatica
	SELECT numerico
	  INTO :li_est_lib
	  FROM m_constantes
	 WHERE var_nombre = 'ESTADO SEMI' ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_error = SQLCA.SQLErrText
		Rollback;
		MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el estado de la liberaci$$HEX1$$f300$$ENDHEX$$n '+ ls_error)
		Return -1
	END IF
ELSE //el tipo es 2 se esta liberando por las criticas.
	SELECT numerico
	  INTO :li_est_lib
	  FROM m_constantes
	 WHERE var_nombre = 'ESTADO CRITICA' ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_error = SQLCA.SQLErrText
		Rollback;
		MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el estado de la liberaci$$HEX1$$f300$$ENDHEX$$n '+ ls_error)
		Return -1
	END IF
END IF

//se determina el tipo de la liberacion
SELECT numerico
  INTO :li_tip_lib
  FROM m_constantes
 WHERE var_nombre = 'TIPO ASIGNA' ;

IF sqlca.sqlcode = -1 THEN
	ls_error = SQLCA.SQLErrText
	Rollback;
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el tipo de asignaci$$HEX1$$f300$$ENDHEX$$n '+ ls_error)
   Return -1
END IF

//---------------------------------------------determinamos la fecha del servidor
ldt_fecha = f_fecha_servidor()

//-------------------------------------insertamos el registro en h_liberar_escalas
INSERT INTO h_liberar_escalas  
         ( co_fabrica_exp,   
           cs_liberacion,   
           co_est_liberacion,   
           co_tip_liberacion,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
  VALUES ( :ii_fabexp,   
           :il_liberacion,   
           :li_est_lib,   
           1,   
           :ldt_fecha,   
           :ldt_fecha,   
           :as_usuario,   
           :gstr_info_usuario.instancia )  ;
			  
IF sqlca.sqlcode <> 0 Then
	ls_error = SQLCA.SQLErrText
	Rollback;
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar los datos' + ls_error)
	Return -1
END IF

Return 0
end function

public function long of_acttandarollo (long al_rollo, string as_tono, ref string as_mensaje);//funcion para modificar el dato de tanda del rollo y este colocarlo el campo lote
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

UPDATE m_rollo
   SET lote = cs_tanda
 WHERE cs_rollo = :al_rollo AND
 		 cs_tanda not in (1, 10, 20, 30)	;   //no actualizar el lote cuando la tanda es 1.
 
If sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.sqlerrtext
	Return -1
End if
 
UPDATE m_rollo
   SET cs_tanda = :li_tanda
 WHERE cs_rollo = :al_rollo;

If sqlca.sqlcode = -1 Then
	as_mensaje = sqlca.sqlerrtext
	Return -1
End if

Return 0 
end function

public function long of_insertar_maestro_pdp (long al_cantidad, date adt_fe_despacho, long li_fabrica_vta, long ai_fabrica_ref, long ai_linea_ref, long al_referencia, long al_liberacion, long al_op_estilo, string as_po);Long	li_sucursal, li_coleccion, li_empaque, li_caja, li_result, li_marca_edi
Long		ll_cliente
String	ls_orden_compra, ls_tipo_pedido, ls_grupo, ls_pr_especial, ls_marca_adicional

n_cst_cronograma lnvo_crono		
n_cst_peddig lnvo_peddig
n_cst_pedpend_exp lnvo_pedpend_exp

DateTime ldtm_fecha_hoy, ldtm_ini_confecion


li_result = of_cargar_datos_pedido_inicial(li_fabrica_vta, ls_tipo_pedido, ll_cliente, li_sucursal, ls_orden_compra,&
                              li_coleccion, ls_grupo, li_empaque, li_caja, 0, al_op_estilo, as_po, li_marca_edi,&
                              ls_pr_especial, ls_marca_adicional)
IF li_result = -1 THEN
	Return -1
END IF
//

ii_inserto = 0
ldtm_fecha_hoy = f_fecha_servidor()

//Se reinician las propiedades del encabezado del pedido
lnvo_peddig.Of_Reiniciar_Propiedades()
// Fabrica del pedido
lnvo_peddig.co_fabrica_vta = li_fabrica_vta
// Tipo de Pedido
lnvo_peddig.tipo_pedido = ls_tipo_pedido
// se llena el cliente, sucursal, po y agrupacion
lnvo_peddig.co_cliente = ll_cliente
lnvo_peddig.co_sucursal = li_sucursal
lnvo_peddig.orden_compra = ls_orden_compra
lnvo_peddig.gpa = ls_grupo
lnvo_peddig.marca_edi = li_marca_edi
// cantidad total pedida
lnvo_peddig.ca_pedida = al_cantidad
// coleccion generica para el cliente 2449 fabrica 2
lnvo_peddig.co_coleccion = li_coleccion
// MAKE TO STOCK
lnvo_peddig.co_tipo_orden = 'S' 
lnvo_peddig.zona = ii_zona

// Marca para indicar que fue creado desde la liberacion
lnvo_peddig.co_proposito_po = 'LI'

lnvo_peddig.pr_especial = ls_pr_especial
lnvo_peddig.marca_adicional = ls_marca_adicional

// Se toma el empaque del pedido
lnvo_peddig.co_empaque = li_empaque
// se pone la caja de despacho
lnvo_peddig.co_caja = li_caja

//fecha de ingreso del pedido 
lnvo_peddig.fe_pedido = Date(ldtm_fecha_hoy)

//fecha de despacho
lnvo_peddig.fe_despacho = adt_fe_despacho
lnvo_peddig.fe_primer_dpacho = lnvo_peddig.fe_despacho
lnvo_peddig.fe_ultimo_dpacho = lnvo_peddig.fe_despacho


// se llenan los campos de auditoria
lnvo_peddig.fe_creacion = ldtm_fecha_hoy
lnvo_peddig.fe_actualizacion = ldtm_fecha_hoy
lnvo_peddig.instancia = gstr_info_usuario.instancia
lnvo_peddig.usuario = gstr_info_usuario.codigo_usuario

lnvo_peddig.opc_ped1 = String(al_liberacion)

If lnvo_peddig.Of_Crear( ) >=  0 Then

Else
	ROLLBACK;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error al generar el pedido!', StopSign!)
	Return -1
End If

il_pedido_pdp   = lnvo_peddig.pedido
il_cliente      = ll_cliente
ii_sucursal     = li_sucursal
idt_fe_despacho = adt_fe_despacho
ii_coleccion    = li_coleccion
ii_inserto = 1
IF il_pedido_pdp = -1 THEN
	ROLLBACK;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error al generar el pedido!', StopSign!)
	Return -1
END IF

w_principal.SetMicroHelp('Se genero el pedido ...')

lnvo_crono = Create n_cst_cronograma		

lnvo_crono.il_pedido = lnvo_peddig.pedido

lnvo_crono.ii_fabrica = 2
lnvo_crono.ii_planta = 1
// Se llenan la referencia
lnvo_crono.il_co_fabrica = ai_fabrica_ref
lnvo_crono.il_co_linea = ai_linea_ref
lnvo_crono.il_co_referencia = al_referencia
// se toma la fecha de inicio de confeccion
ldtm_ini_confecion = DateTime(Date(adt_fe_despacho))
li_result = lnvo_crono.Of_Generar_Cronograma_Auto( Date(ldtm_ini_confecion), lnvo_peddig.ca_pedida ) 
IF li_result = 1 THEN
ELSE
	ROLLBACK;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error al generar el cronograma!', StopSign!)
	Return -1
END IF

lnvo_crono.ids_cronograma.SaveAs("c:\cronograma.xls", Excel8!, True)

//If lnvo_crono.ids_cronograma.Of_Commit() = 1 Then
//	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Se genero el pedido y el cronograma!')
//	
//Else	
//	ROLLBACK;
//	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un erro al guardar los datos!~r~n~n' + lnvo_crono.ids_cronograma.is_sqlerrtext )
//	Return -1
//End If
//
Destroy(lnvo_crono)
Return lnvo_peddig.pedido
end function

public function long of_cargar_datos_pedido_inicial (ref long ai_fabrica_vta, ref string as_tipo_pedido, ref long al_cliente, ref long ai_sucursal, ref string as_orden_compra, ref long ai_coleccion, ref string as_grupo, ref long ai_empaque, ref long ai_caja, long al_pedido, long al_op_estilo, string as_po, ref long as_marca_edi, ref string as_pr_especial, ref string as_marca_adicional);Long	li_item
Long		ll_pedida, ll_pedida_comprar

Select Max(pedido)
  Into :al_pedido
  From dt_pedidosxorden
 Where cs_ordenpd_pt =  :al_op_estilo
   And nu_orden = :as_po;
IF sqlca.Sqlcode = 0 Then
	If al_pedido > 0 Then
	Else
		Rollback;
		MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$el numero del pedido de la op para luego buscar la informacion del pdp')
		Return -1
	End if
Else
	Rollback;
	MessageBox('Error','Se presento un error cargando el numero del pedido de la op para luego buscar la informacion del pdp')
	Return -1
End if

Select co_fabrica_vta, tipo_pedido, co_cliente, co_sucursal, orden_compra, zona,
       co_coleccion, gpa, co_empaque, co_caja, marca_edi, pr_especial, marca_adicional
  Into :ai_fabrica_vta, :as_tipo_pedido, :al_cliente, :ai_sucursal, :as_orden_compra, :ii_zona,
  		 :ai_coleccion, :as_grupo, :ai_empaque, :ai_caja, :as_marca_edi, :as_pr_especial,
		 :as_marca_adicional	
  From peddig
 Where pedido = :al_pedido;
  
Select MAX(instresp_empq)
  Into :is_instresp_empq
  From pedpend_exp
 Where pedido = :al_pedido
   and co_calidad = 1;
	
Select Min(item)
  Into :li_item
  From pedpend_exp
 Where pedido = :al_pedido
   and co_calidad = 1;
  
IF li_item > 0 THEN 
	Select ca_pedida, ca_pedida_comprar
     Into :ll_pedida, :ll_pedida_comprar
	  From pedpend_exp
	 Where pedido = :al_pedido
	   and co_calidad = 1
		and item = :li_item;
	IF ll_pedida_comprar > 0 THEN	
		ii_porc_mas = (1 - (ll_pedida / ll_pedida_comprar))  * 100
	ELSE
		ii_porc_mas = 0
	END IF
		
END IF
 
il_pedido_anterior = al_pedido
If sqlca.Sqlcode = 0 THEN
	Return 1
Else
	Return -1
End if
  
end function

public function long of_actualizar_liberacion (long ai_fabexp, long al_liberacion, long al_ordenpd, long al_color);//metodo para actualizar todas las tablas involucradas en la liberaci$$HEX1$$f300$$ENDHEX$$n
Long ll_unidades, ll_result, ll_fila, ll_modelo, ll_programada
String ls_usuario, ls_error
Long li_talla
DataStore lds_telaxmodelo, lds_escalasxtela, lds_tallapdnmodulo, lds_caxpedidos, lds_ordentalla

lds_telaxmodelo 		= Create DataStore
lds_escalasxtela 		= Create DataStore
lds_tallapdnmodulo 	= Create DataStore
lds_caxpedidos 		= Create DataStore
lds_ordentalla			= Create DataStore

lds_telaxmodelo.DataObject 	= 'ds_telaxmodelo_lib'
lds_escalasxtela.DataObject 	= 'ds_dt_escalasxtela_recalculo_unid'
lds_tallapdnmodulo.DataObject = 'ds_talla_pdnxmodulo_recalculo'
lds_caxpedidos.DataObject 		= 'ds_dt_caxpedidos_recalculo'
lds_ordentalla.DataObject 		= 'ds_dt_orden_tllaclor_recalculo'

lds_telaxmodelo.SetTransObject(sqlca)
lds_escalasxtela.SetTransObject(sqlca)
lds_tallapdnmodulo.SetTransObject(sqlca)
lds_caxpedidos.SetTransObject(sqlca)
lds_ordentalla.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

//************************ actualizo dt_caxpedidos ****************************
ll_result = lds_caxpedidos.Retrieve(ai_fabexp,al_color,al_ordenpd)

FOR ll_fila = 1 TO ll_result
	li_talla  = lds_tallapdnmodulo.GetItemNumber(ll_fila,'co_talla')
	//tengo las unidades que se recalculan 
	SELECT SUM(unidades)
	  INTO :ll_unidades
	  FROM temporal_trazo
	 WHERE usuario  = :ls_usuario AND
	 		 co_talla = :li_talla AND
			 raya		 = 10; 
	 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF
	
	//ahora necesito las unidades que se liberaron para esta talla en esta liberacion y la diferencia
	//es lo que actualizo en dt_caxpedidos
	SELECT ca_programada
	  INTO :ll_programada
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :ai_fabexp AND
			 cs_liberacion  = :al_liberacion AND
			 co_color_pt	 = :al_color AND
			 co_talla		 = :li_talla; 	
			 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
	
	ll_programada = ll_programada - ll_unidades
	
	UPDATE dt_caxpedidos
	   SET ca_liberadas = ca_liberadas - :ll_programada
	 WHERE co_fabrica_exp = :ai_fabexp AND
			 co_color	 	 = :al_color AND
			 co_talla		 = :li_talla AND
			 cs_ordenpd_pt  = :al_ordenpd;  	
	
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
NEXT

//**************************** actualizo dt_orden_tllaclor ********************
ll_result = lds_ordentalla.Retrieve(al_ordenpd,al_color)

FOR ll_fila = 1 TO ll_result
	li_talla  = lds_ordentalla.GetItemNumber(ll_fila,'co_talla')
  //tengo las unidades que se recalculan 
	SELECT SUM(unidades)
	  INTO :ll_unidades
	  FROM temporal_trazo
	 WHERE usuario  = :ls_usuario AND
	 		 co_talla = :li_talla AND
			 raya		 = 10; 
	 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF
	
	//ahora necesito las unidades que se liberaron para esta talla en esta liberacion y la diferencia
	//es lo que actualizo en dt_caxpedidos
	SELECT ca_programada
	  INTO :ll_programada
	  FROM dt_talla_pdnmodulo
	 WHERE co_fabrica_exp = :ai_fabexp AND
			 cs_liberacion  = :al_liberacion AND
			 co_color_pt	 = :al_color AND
			 co_talla		 = :li_talla; 	
			 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
	
	ll_programada = ll_programada - ll_unidades
	
	UPDATE dt_orden_tllaclor
	   SET ca_liberada = ca_liberada - :ll_programada
	 WHERE co_color	 	 = :al_color AND
			 co_talla		 = :li_talla AND
			 cs_ordenpd_pt  = :al_ordenpd;  	
	
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
NEXT

//***************************** actualizo dt_libera_estilos *******************
SELECT SUM(unidades)
  INTO :ll_unidades
  FROM temporal_trazo
 WHERE usuario = :ls_usuario AND
		 raya		 = 10; 
 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
	Return -1
END IF

UPDATE dt_libera_estilos
   SET ca_unidades = :ll_unidades
 WHERE co_fabrica_exp = :ai_fabexp AND
       cs_liberacion  = :al_liberacion AND
		 cs_ordenpd_pt  = :al_ordenpd AND
		 co_color_pt	 = :al_color; 	
		 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
	Return -1
END IF		 

//************************** actualizo dt_telaxmodelo_lib *********************
ll_result = lds_telaxmodelo.Retrieve(ai_fabexp,al_liberacion)

FOR ll_fila = 1 TO ll_result
	ll_modelo = lds_telaxmodelo.GetItemNumber(ll_fila,'co_modelo')
	
	SELECT SUM(unidades)
	  INTO :ll_unidades
	  FROM temporal_trazo
	 WHERE usuario = :ls_usuario AND
	 		 modelo  = :ll_modelo; 
	 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF
	
	UPDATE dt_telaxmodelo_lib
		SET ca_unidades = :ll_unidades
	 WHERE co_fabrica_exp = :ai_fabexp AND
			 cs_liberacion  = :al_liberacion AND
			 co_color_pt	 = :al_color AND
			 co_modelo		 = :ll_modelo; 	
			 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
NEXT

//************************** actualizo dt_escalasxtela ************************
ll_result = lds_escalasxtela.Retrieve(ai_fabexp,al_liberacion)

FOR ll_fila = 1 TO ll_result
	ll_modelo = lds_escalasxtela.GetItemNumber(ll_fila,'co_modelo')
	li_talla  = lds_escalasxtela.GetItemNumber(ll_fila,'co_talla')
	
	SELECT SUM(unidades)
	  INTO :ll_unidades
	  FROM temporal_trazo
	 WHERE usuario  = :ls_usuario AND
	 		 modelo   = :ll_modelo AND
			 co_talla = :li_talla; 
	 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF
	
	UPDATE dt_escalasxtela
		SET ca_unidades = :ll_unidades
	 WHERE co_fabrica_exp = :ai_fabexp AND
			 cs_liberacion  = :al_liberacion AND
			 co_color_pt	 = :al_color AND
			 co_modelo		 = :ll_modelo AND
			 co_talla		 = :li_talla; 	
			 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
NEXT

//********************************** actualizo dt_talla_pdnmodulo *************
ll_result = lds_tallapdnmodulo.Retrieve(ai_fabexp,al_liberacion)

FOR ll_fila = 1 TO ll_result
	li_talla  = lds_tallapdnmodulo.GetItemNumber(ll_fila,'co_talla')
	
	SELECT SUM(unidades)
	  INTO :ll_unidades
	  FROM temporal_trazo
	 WHERE usuario  = :ls_usuario AND
	 		 co_talla = :li_talla AND
			 raya		 = 10; 
	 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF
	
	UPDATE dt_talla_pdnmodulo
		SET ca_programada = :ll_unidades
	 WHERE co_fabrica_exp = :ai_fabexp AND
			 cs_liberacion  = :al_liberacion AND
			 co_color_pt	 = :al_color AND
			 co_talla		 = :li_talla; 	
			 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
		Return -1
	END IF		 
NEXT

//****************************** actualizo dt_pdnxmodulo **********************
SELECT SUM(unidades)
  INTO :ll_unidades
  FROM temporal_trazo
 WHERE usuario = :ls_usuario AND
		 raya		 = 10; 
 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
	Return -1
END IF

UPDATE dt_pdnxmodulo
	SET ca_programada = :ll_unidades
 WHERE co_fabrica_exp = :ai_fabexp AND
		 cs_liberacion  = :al_liberacion AND
		 co_color_pt	 = :al_color ; 	
			 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades. '+ls_error)
	Return -1
END IF		 


Return 0
end function

public function long of_cargarordenproduccion (long al_ordenpd_pt, long ai_talla, long al_color, long al_unidades, string as_po);//funcion para actualizar la unidades liberadas en las tablas de la orden de producci$$HEX1$$f300$$ENDHEX$$n
String ls_error,ls_color_exp
LONG	ll_liberadas_ant, ll_ca_prog_ops, ll_ca_liberadas_op

//se determina el color de ventas
//SELECT DISTINCT color_exp
//  INTO :ls_color_exp
//  FROM dt_caxpedidos
// WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
//		 nu_orden 		= :as_po AND
//		 co_color 		= :al_color AND
//		 co_talla      = :ai_talla;
//
//

IF il_op_agrupada > 0 THEN
	
	SELECT nvl(ca_liberadas,0)
	INTO :ll_liberadas_ant
	FROM dt_caxpedidos
	WHERE dt_caxpedidos.cs_ordenpd_pt = :il_op_agrupada  AND  
			  dt_caxpedidos.co_talla 		= :ai_talla  AND  
			  dt_caxpedidos.co_color 		= :al_color AND
			  dt_caxpedidos.nu_orden 		= :as_po AND
			  dt_caxpedidos.color_exp		= :is_color_exp;
	 IF Sqlca.Sqlcode = -1 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las unidades liberadas para la agrupada, '+ ls_error)
		Return -1
	END IF
	DECLARE procedure_act_unid_lib_agru PROCEDURE FOR 
			pr_act_unid_lib_agru(:il_op_agrupada, :ai_talla, :al_color,0, :ll_liberadas_ant, (:ll_liberadas_ant + :al_unidades ),:il_liberacion, :as_po); 			//20 son  los correos de los usuarios que tejen hiladillas		   
								  
			//Ejecutar procedimiento 
	EXECUTE procedure_act_unid_lib_agru;
	IF SQLCA.SQLCode = -1 THEN
		Rollback;
		MessageBox('Error','Ejecutando el procedimiento SP que actualiza las liberadas en las individuales ')
		CLOSE procedure_act_unid_lib_agru;
		Return -1
	END IF
	
	SELECT SUM(a.ca_programada), sum(a.ca_liberadas)
	   INTO :ll_ca_prog_ops, :ll_ca_liberadas_op
	  FROM dt_caxpedidos a, 	dt_op_agrupa_lib b
	 WHERE a.cs_ordenpd_pt = b.cs_ordenpd_pt
	     AND b.cs_liberacion = :il_liberacion
		 AND a.co_color =  :al_color
		 AND a.co_Talla =  :ai_talla;
	IF 	 ll_ca_liberadas_op > ll_ca_prog_ops THEN
		If MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Esta liberando mas de lo programado en la talla: "+string(ai_talla)+" Prog: "+ string(ll_ca_prog_ops) +" Libero: "+string(ll_ca_liberadas_op)+" $$HEX1$$bf00$$ENDHEX$$Desea continuar ?",Question!,YesNo!,2) = 2 Then
			Rollback;
			Return -1
		End IF
	END IF
						
	//Validar las unidade liberadas en la agrupada

	CLOSE procedure_act_unid_lib_agru;
	
	UPDATE dt_caxpedidos  
    SET ca_liberadas = ca_liberadas + :al_unidades  
  	WHERE dt_caxpedidos.cs_ordenpd_pt = :il_op_agrupada  AND  
        dt_caxpedidos.co_talla 		= :ai_talla  AND  
        dt_caxpedidos.co_color 		= :al_color AND
	  dt_caxpedidos.color_exp		= :is_color_exp AND
	  dt_caxpedidos.co_ref_exp		= :is_ref_exp;

	IF Sqlca.Sqlcode = -1 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades liberadas exp, '+ ls_error)
		Return -1
	END IF

	
ELSE

//validacion para evitar problemas con los colores de ventas
	IF IsNull(is_color_exp) THEN
		Rollback;
		MessageBox('Error','El color de ventas no esta correcto, revise con sistemas ')
		Return -1
	END IF
	
	 UPDATE dt_caxpedidos  
		 SET ca_liberadas = ca_liberadas + :al_unidades  
	  WHERE dt_caxpedidos.cs_ordenpd_pt = :al_ordenpd_pt  AND  
			  dt_caxpedidos.co_talla 		= :ai_talla  AND  
			  dt_caxpedidos.co_color 		= :al_color AND
			  dt_caxpedidos.nu_orden 		= :as_po AND
			  dt_caxpedidos.color_exp		= :is_color_exp;
	
	IF Sqlca.Sqlcode = -1 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar las unidades liberadas exp, '+ ls_error)
		Return -1
	END IF
END IF

Return 0
end function

protected function long of_cargardtliberaestilos (long ai_fab, long ai_lin, long al_color, long al_unidades, long al_ref, string as_tono, string as_po, string as_cut, long al_ordenpd_pt, decimal adc_consumo, string as_usuario);DateTime ldt_fecha
Long ll_unidades, ll_count
String ls_error

//---------------------------traigo la fecha del servidor
ldt_fecha = f_fecha_servidor()

//se verifica que el registro no se encuentre, ya que para una misma talla pueden haber varios colores
SELECT count(*)
  INTO :ll_count
  FROM dt_libera_estilos
 WHERE co_fabrica_exp	= :ii_fabexp AND   
       cs_liberacion    = :il_liberacion AND
       nu_orden 			= :as_po AND  
       nu_cut  			= :as_cut AND
       co_fabrica   		= :ai_fab AND
       co_linea   		= :ai_lin AND	
       co_referencia    = :al_ref AND
       co_color_pt  		= :al_color AND
       co_tono 			= :as_tono;

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar dt_libera_estilos. '+ ls_error)
	Return -1
END IF

IF ll_count > 0 THEN //--------------se realiza update de las ca_unidades
	UPDATE dt_libera_estilos
   SET ca_unidades = ca_unidades + :al_unidades
   WHERE co_fabrica_exp = :ii_fabexp AND
         cs_liberacion 	= :il_liberacion AND
         nu_orden 		= :as_po AND
         nu_cut 			= :as_cut AND
         co_fabrica 		= :ai_fab AND
         co_linea 		= :ai_lin AND
         co_referencia 	= :al_ref AND
         co_color_pt 	= :al_color AND
         co_tono 			= :as_tono;
			
   IF sqlca.sqlcode <> 0 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_libera_estilos. '+ ls_error)
		Return -1
	END IF
	
ELSE//------------------------------------inserto el registro
	INSERT INTO dt_libera_estilos  
				( co_fabrica_exp,   
				  cs_liberacion,   
				  nu_orden,   
				  nu_cut,   
				  co_fabrica,   
				  co_linea,   
				  co_referencia,   
				  co_color_pt,   
				  co_tono,   
				  cs_ordenpd_pt,   
				  yield,   
				  ca_unidades,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia )  
	  VALUES ( :ii_fabexp,   
				  :il_liberacion,   
				  :as_po,   
				  :as_cut,   
				  :ai_fab,   
				  :ai_lin,   
				  :al_ref,   
				  :al_color,   
				  :as_tono,   
				  :al_ordenpd_pt,   
				  :adc_consumo,   
				  :al_unidades,   
				  :ldt_fecha,   
				  :ldt_fecha,   
				  :as_usuario,   
				  :gstr_info_usuario.instancia )  ;
				  
	IF sqlca.sqlcode <> 0 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_libera_estilos. '+ ls_error)
		Return -1
	END IF
END IF

RETURN 0
end function

public function long of_cargardttelaxmodelolib (long ai_fab, long ai_lin, long al_ref, long al_color, long al_cant_prog, long ai_tal, long ai_cal, string as_po, string as_cut, long ai_raya, decimal adc_ancho, long al_mod, long al_reftel, long ai_caract, long ai_dia, long al_colorte, string as_tono, decimal adc_consumo, long al_ordenpd_pt, string as_usuario);Long ll_fila, ll_count, ll_result, ll_unidades, ll_ref, ll_ordenpd, ll_mod, ll_reftel, ll_tanda
Long ll_color, ll_colorte
DateTime ldt_fecha
String ls_error, ls_usuario, ls_tono, ls_cut, ls_po, ls_referencia, ls_de_referencia
Long li_fab, li_lin,  li_talla, li_caract, li_raya, li_diametro, li_fabtela
Decimal{5} ldc_ancho, ldc_consumo
Long ll_fab_sim,ll_planta_sim,ll_centro_sim,ll_subcentro_sim,ll_maquina,ll_tipo_negocio
Long ll_simulacion, ll_talla_sim,ll_color_sim, ll_tiempo_reposo, ll_find
DateTime ldtm_servidor
DataStore lds_modelos
uo_dsbase lds_simulacion
n_cts_constantes luo_constantes 
luo_constantes = Create n_cts_constantes

ldtm_servidor = f_fecha_servidor()
li_fabtela = luo_constantes.of_consultar_numerico("FABRICA TELA")
IF li_fabtela = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer la fabrica de la tela.',StopSign!)
	Return -1
END IF

ll_talla_sim = luo_constantes.of_consultar_numerico("REPOSO_TALLA_SIM")
IF ll_talla_sim = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer la talla para la simulacion.',StopSign!)
	Return -1
END IF

ll_color_sim = luo_constantes.of_consultar_numerico("REPOSO_COLOR_SIM")
IF ll_color_sim = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer el color para la simulacion.',StopSign!)
	Return -1
END IF

ll_maquina = luo_constantes.of_consultar_numerico("REPOSO_MAQUINA_SIM")
IF ll_maquina = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer la maquina para la simulacion.',StopSign!)
	Return -1
END IF

ll_tipo_negocio = luo_constantes.of_consultar_numerico("REPOSO_TIPONEGOCIO")
IF ll_tipo_negocio = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer el tipo negocio para la simulacion.',StopSign!)
	Return -1
END IF

ll_simulacion = luo_constantes.of_consultar_numerico("REPOSO_SIMULACION")
IF ll_simulacion = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer la simulacion.',StopSign!)
	Return -1
END IF

ll_fab_sim = luo_constantes.of_consultar_numerico("REPOSO_FAB_SIM")
IF ll_fab_sim = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer la fabrica para la simulacion.',StopSign!)
	Return -1
END IF

ll_planta_sim = luo_constantes.of_consultar_numerico("REPOSO_PLANTA_SIM")
IF ll_planta_sim = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer la planta para la simulacion.',StopSign!)
	Return -1
END IF

ll_centro_sim = luo_constantes.of_consultar_numerico("REPOSO_CENTRO_SIM")
IF ll_centro_sim = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer el centro para la simulacion.',StopSign!)
	Return -1
END IF

ll_subcentro_sim = luo_constantes.of_consultar_numerico("REPOSO_SUBCENTRO_SIM")
IF ll_subcentro_sim = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer el subcentro para la simulacion.',StopSign!)
	Return -1
END IF

lds_simulacion = Create uo_dsbase
lds_simulacion.DataObject = 'd_gr_dt_simulacion_reposo'
lds_simulacion.SetTransObject(sqlca)


lds_modelos = Create DataStore
lds_modelos.DataObject = 'ds_temp_modelos_ref_telas'
lds_modelos.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

//--------------------------------------traigo la fecha del servidor
ldt_fecha = f_fecha_servidor()

//consulta los registros de simulacion para la liberacion
If lds_simulacion.Retrieve(il_liberacion, ll_tipo_negocio) < 0 Then
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error alconsultar simulacion para la liberacion')
	Return -1
End if

ll_result = lds_modelos.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_color,ai_tal,as_tono,al_mod,adc_ancho)

For ll_fila = 1 To ll_result
	li_fab 		= lds_modelos.GetItemNumber(ll_fila,'co_fabrica')
	li_lin 		= lds_modelos.GetItemNumber(ll_fila,'co_linea')
	ll_color 	= lds_modelos.GetITemNumber(ll_fila,'co_color')
	ll_unidades = lds_modelos.GetItemNumber(ll_fila,'unid_real_liberar')
	ll_ref 		= lds_modelos.GetItemNumber(ll_fila,'co_referencia')
	ls_tono 		= lds_modelos.GetItemString(ll_fila,'tono')
	ls_po 		= lds_modelos.GetItemString(ll_fila,'po')
	ls_cut 		= lds_modelos.GetItemString(ll_fila,'nu_cut')
	ll_ordenpd  = lds_modelos.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ldc_consumo = lds_modelos.GetItemNumber(ll_fila,'consumo')
	li_talla		= lds_modelos.GetItemNumber(ll_fila,'co_talla')
	li_raya		= lds_modelos.GetItemNumber(ll_fila,'raya')
	ldc_ancho   = lds_modelos.GetItemNumber(ll_fila,'ancho')
	ll_mod		= lds_modelos.GetItemNumber(ll_fila,'co_modelo')
	ll_reftel 	= lds_modelos.GetItemNumber(ll_fila,'co_reftel')
	li_caract	= lds_modelos.GetItemNumber(ll_fila,'co_caract')
	li_diametro = lds_modelos.GetItemNumber(ll_fila,'diametro')
	ll_colorte	= lds_modelos.GetItemNumber(ll_fila,'co_color_te')
//	ls_tono = 'A'
	ll_tanda    = lds_modelos.GetItemNumber(ll_fila,'cs_tanda')
	ll_tiempo_reposo = lds_modelos.GetItemNumber(ll_fila,'tiempo_reposo')
	ls_de_referencia 		= lds_modelos.GetItemString(ll_fila,'de_reftel')
	
	//ls_referencia = String(il_liberacion) + ' ' + String(ll_reftel) 
	ls_referencia = String(ll_reftel) 
	
	//si tiene tiempo reposos se mira registro en dt_simulacion
	If ll_tiempo_reposo > 0 Then
		//busca registro en simulacion
		ll_find = lds_simulacion.Find('pedido = ' + String(il_liberacion) + &
							' and co_referencia = "' + trim(ls_referencia) + '"',1,lds_simulacion.RowCount() +1)
							
		//si encuentra actualiza cantidad programada2
		If ll_find > 0 Then
			//actualiza cantidad
			lds_simulacion.SetItem(ll_find,'ca_programada', lds_simulacion.GetItemDecimal(ll_find,'ca_programada') + ll_unidades )
			lds_simulacion.SetItem(ll_find,'ca_programada_2', lds_simulacion.GetItemDecimal(ll_find,'ca_programada_2') + ll_unidades * ldc_consumo )
			
		//sino encuentra ingresa registro
		ElseIf ll_find = 0 Then
			//indica que se introduce reposo
			ib_carga_reposo = True
			ll_find = lds_simulacion.InsertRow(0)
 
			//propiedades que pertenecen a la llave		
			lds_simulacion.SetItem(ll_find,'co_fabrica_sim', ll_fab_sim)
			lds_simulacion.SetItem(ll_find,'co_planta', ll_planta_sim)
			lds_simulacion.SetItem(ll_find,'co_centro_pdn', ll_centro_sim)
			lds_simulacion.SetItem(ll_find,'co_subcentro_pdn', ll_subcentro_sim)
			lds_simulacion.SetItem(ll_find,'co_tipo_negocio', ll_tipo_negocio)
			lds_simulacion.SetItem(ll_find,'co_maquina', ll_maquina)
			lds_simulacion.SetItem(ll_find,'fe_inicio_progs', ldtm_servidor)
			lds_simulacion.SetItem(ll_find,'fe_final_progs', ldtm_servidor)
		
			lds_simulacion.SetItem(ll_find,'simulacion', ll_simulacion)
			lds_simulacion.SetItem(ll_find,'fe_actualizacion', ldtm_servidor)
			lds_simulacion.SetItem(ll_find,'usuario', gstr_info_usuario.codigo_usuario)
			lds_simulacion.SetItem(ll_find,'instancia', gstr_info_usuario.instancia)
	
			//propiedades que no pueden ser nulas, se cargan del administrador de barras
			
			lds_simulacion.SetItem(ll_find,'minuto_laboral_ini', 0 )
			lds_simulacion.SetItem(ll_find,'minuto_laboral_fin', 0 )
	
			lds_simulacion.SetItem(ll_find,'sw_estado', 0)
			lds_simulacion.SetItem(ll_find,'co_estado', 'A')
			//propiedades de programaci$$HEX1$$f300$$ENDHEX$$n, se cargan del administrador de barras
			lds_simulacion.SetItem(ll_find,'sentido_prog', 0)
			lds_simulacion.SetItem(ll_find,'sw_mover', 0)
			lds_simulacion.SetItem(ll_find,'dias_continuidad', 0)
			
			lds_simulacion.SetItem(ll_find,'co_curva', 0)
			lds_simulacion.SetItem(ll_find,'sw_curva', 0)
			lds_simulacion.SetItem(ll_find,'co_tipo_empate', 0)
			lds_simulacion.SetItem(ll_find,'ca_programada', ll_unidades )
			lds_simulacion.SetItem(ll_find,'ca_programada_2', ll_unidades * ldc_consumo)
			lds_simulacion.SetItem(ll_find,'prioridad', 1)
			
			lds_simulacion.SetItem(ll_find,'min_trabajados', 0)
			
			lds_simulacion.SetItem(ll_find,'fe_inicio_crono', ldtm_servidor)
			lds_simulacion.SetItem(ll_find,'fe_final_crono', ldtm_servidor)
	
			lds_simulacion.SetItem(ll_find,'co_talla', ll_talla_sim)
			lds_simulacion.SetItem(ll_find,'co_color', ll_color_sim)
			lds_simulacion.SetItem(ll_find,'rgb', -1 )
			
			//Se asigna los valores de la referencia al objeto que va a guardar la barra en dt_simulacion
			lds_simulacion.SetItem(ll_find,'co_referencia', ls_referencia )
			lds_simulacion.SetItem(ll_find,'de_referencia', ls_de_referencia )
			lds_simulacion.SetItem(ll_find,'tiempo_estandar', ll_tiempo_reposo )
			lds_simulacion.SetItem(ll_find,'co_recurso', 0 )	
			lds_simulacion.SetItem(ll_find,'ca_asignada',0)
			
			//si la barra es nueva la cantidad producida es cero
			lds_simulacion.SetItem(ll_find,'ca_producida',0)
			lds_simulacion.SetItem(ll_find,'ca_producida_2',0)
			lds_simulacion.SetItem(ll_find,'pedido',il_liberacion)
			lds_simulacion.SetItem(ll_find,'fe_creacion', ldtm_servidor)
		End if
	End if
	
	//como pueden existir varias tallas para una mismo modelo, reftel, diametro y color
	//se pregunta primero por el registro a insertar si existe se ignora sino se inserta.
		
	//-------------------------------verificamos la existencia del registro
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_telaxmodelo_lib  
	 WHERE dt_telaxmodelo_lib.co_fabrica_exp 	= :ii_fabexp  AND  
			 dt_telaxmodelo_lib.cs_liberacion 	= :il_liberacion AND  
			 dt_telaxmodelo_lib.nu_orden 			= :ls_po  AND  
			 dt_telaxmodelo_lib.nu_cut 			= :ls_cut  AND  
			 dt_telaxmodelo_lib.co_fabrica_pt 	= :li_fab  AND  
			 dt_telaxmodelo_lib.co_linea 			= :li_lin  AND  
			 dt_telaxmodelo_lib.co_referencia 	= :ll_ref  AND  
			 dt_telaxmodelo_lib.co_color_pt 		= :ll_color AND  
			 dt_telaxmodelo_lib.co_tono 			= :ls_tono  AND  
			 dt_telaxmodelo_lib.co_modelo 		= :ll_mod  AND  
			 dt_telaxmodelo_lib.co_fabrica_tela = :li_fabtela  AND  
			 dt_telaxmodelo_lib.co_reftel 		= :ll_reftel  AND  
			 dt_telaxmodelo_lib.co_caract 		= :li_caract  AND  
			 dt_telaxmodelo_lib.diametro 			= :li_diametro  AND  
			 dt_telaxmodelo_lib.co_color_tela 	= :ll_colorte ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurrio un error al momento de verificar dt_telaxmodelo_lib. '+ ls_error)
		Return -1
	END IF
	
	IF ll_count > 0 THEN//---------------------realizamos update de cantidades
		UPDATE dt_telaxmodelo_lib
			SET ca_unidades = ca_unidades + :ll_unidades,
					ca_tela = (ca_tela + (:ll_unidades * yield))
		 WHERE dt_telaxmodelo_lib.co_fabrica_exp 	= :ii_fabexp  AND  
				 dt_telaxmodelo_lib.cs_liberacion 	= :il_liberacion AND  
				 dt_telaxmodelo_lib.nu_orden 			= :ls_po  AND  
				 dt_telaxmodelo_lib.nu_cut 			= :ls_cut  AND  
				 dt_telaxmodelo_lib.co_fabrica_pt 	= :li_fab  AND  
				 dt_telaxmodelo_lib.co_linea 			= :li_lin  AND  
				 dt_telaxmodelo_lib.co_referencia 	= :ll_ref  AND  
				 dt_telaxmodelo_lib.co_color_pt 		= :ll_color AND  
				 dt_telaxmodelo_lib.co_tono 			= :ls_tono  AND  
				 dt_telaxmodelo_lib.co_modelo 		= :ll_mod  AND  
				 dt_telaxmodelo_lib.co_fabrica_tela = :li_fabtela  AND  
				 dt_telaxmodelo_lib.co_reftel 		= :ll_reftel  AND  
				 dt_telaxmodelo_lib.co_caract 		= :li_caract  AND  
				 dt_telaxmodelo_lib.diametro 			= :li_diametro  AND  
				 dt_telaxmodelo_lib.co_color_tela 	= :ll_colorte ;
				  
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_telaxmodelo_lib. '+ ls_error)
			Return -1
		END IF		  
				  
	ELSE
		//--------------------------------no existe lo insertamos
		 INSERT INTO dt_telaxmodelo_lib  
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
			  ancho_cortable,   
			  tono_tela,   
			  raya,   
			  ca_unidades,   
			  yield,   
			  ca_tela,   
			  fe_creacion,   
			  fe_actualizacion,   
			  usuario,   
			  instancia,
			  cs_tanda)  
		 VALUES 
			 (:ii_fabexp,   
			  :il_liberacion,   
			  :ls_po,   
			  :ls_cut,   
			  :li_fab,   
			  :li_lin,   
			  :ll_ref,   
			  :ll_color,   
			  :ls_tono,   
			  :ll_mod,   
			  :li_fabtela,   
			  :ll_reftel,   
			  :li_caract,   
			  :li_diametro,   
			  :ll_colorte,   
			  :ldc_ancho,   
			  :ls_tono,   
			  :li_raya,   
			  :ll_unidades,   
			  :ldc_consumo,   
			  (:ll_unidades * :ldc_consumo ),   
			  :ldt_fecha,   
			  :ldt_fecha,   
			  :as_usuario,   
			  :gstr_info_usuario.instancia,
			  :ll_tanda)  ;
	
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_telaxmodelo_lib. '+ ls_error)
			Return -1
		END IF
			
	END IF
Next

//actualiza simulacion
If lds_simulacion.Of_update() < 0 Then
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la tabla simulacion.')
	Return -1
End if	


Destroy lds_modelos

Return 0
end function

public function long of_cargardtescalasxtela (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, string as_tono, long al_mod, long ai_fabte, long al_reftel, long ai_caract, long ai_dia, long al_colorte, long ai_talla, long al_unidades, long ai_cal, string as_po, string as_cut, decimal adc_yield, long al_ordenpd_pt, decimal ad_ancho, string as_usuario);Long ll_count, ll_result, ll_fila, ll_unidades, ll_ref, ll_ordenpd, ll_mod, ll_reftel, ll_color, ll_colorte
Long li_fab, li_lin, li_caract, li_talla, li_raya, li_diametro, &
        li_coorpt, li_fabtela
DateTime ldt_fecha
String ls_error, ls_usuario, ls_po, ls_cut, ls_tono
Decimal{5} ldc_consumo, ldc_ancho
DataStore lds_modelos
n_cts_constantes luo_constantes 
luo_constantes = Create n_cts_constantes

li_fabtela = luo_constantes.of_consultar_numerico("FABRICA TELA")
IF li_fabtela = -1 THEN
	Return -1
END IF

lds_modelos = Create DataStore
lds_modelos.DataObject = 'ds_temp_modelos_ref_telas'
lds_modelos.SetTransObject(sqlca)

ls_usuario = gstr_info_usuario.codigo_usuario

ll_result = lds_modelos.Retrieve(ls_usuario,al_ordenpd_pt,as_po,al_colorpt,ai_talla,as_tono,al_mod,ad_ancho)

For ll_fila = 1 To ll_result
	li_fab 		= lds_modelos.GetItemNumber(ll_fila,'co_fabrica')
	li_lin 		= lds_modelos.GetItemNumber(ll_fila,'co_linea')
	ll_color 	= lds_modelos.GetITemNumber(ll_fila,'co_color')
	ll_unidades = lds_modelos.GetItemNumber(ll_fila,'unid_real_liberar')
	ll_ref 		= lds_modelos.GetItemNumber(ll_fila,'co_referencia')
	ls_tono 		= lds_modelos.GetItemString(ll_fila,'tono')
	ls_po 		= lds_modelos.GetItemString(ll_fila,'po')
	ls_cut 		= lds_modelos.GetItemString(ll_fila,'nu_cut')
	ll_ordenpd  = lds_modelos.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ldc_consumo = lds_modelos.GetItemNumber(ll_fila,'consumo')
	li_talla		= lds_modelos.GetItemNumber(ll_fila,'co_talla')
	li_raya		= lds_modelos.GetItemNumber(ll_fila,'raya')
	ldc_ancho   = lds_modelos.GetItemNumber(ll_fila,'ancho')
	ll_mod		= lds_modelos.GetItemNumber(ll_fila,'co_modelo')
	ll_reftel 	= lds_modelos.GetItemNumber(ll_fila,'co_reftel')
	li_caract	= lds_modelos.GetItemNumber(ll_fila,'co_caract')
	li_diametro = lds_modelos.GetItemNumber(ll_fila,'diametro')
	ll_colorte	= lds_modelos.GetItemNumber(ll_fila,'co_color_te')
//	ls_tono = 'A'
	//primero se verifica que el registro no exista, ya que desde donde se esta invocando se hace para todos los posibles
	//registros de una talla, por lo tanto nosotros solo debemos insertar una vez por talla.
	
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_escalasxtela
	 WHERE co_fabrica_exp 	= :ii_fabexp  AND  
			 cs_liberacion 	= :il_liberacion  AND  
			 nu_orden 			= :ls_po  AND  
			 nu_cut 				= :ls_cut  AND  
			 co_fabrica_pt 	= :li_fab  AND  
			 co_linea 			= :li_lin  AND  
			 co_referencia 	= :ll_ref  AND  
			 co_color_pt 		= :ll_color  AND  
			 co_tono 			= :ls_tono  AND  
			 co_modelo 			= :ll_mod  AND  
			 co_fabrica_tela 	= :li_fabtela  AND  
			 co_reftel 			= :ll_reftel  AND  
			 co_caract 			= :li_caract  AND  
			 diametro 			= :li_diametro  AND  
			 co_color_tela 	= :ll_colorte  AND  
			 co_talla 			= :li_talla ;   
			 
	IF sqlca.sqlcode = -1 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en dt_escalasxtela. '+ ls_error )
		Return -1
	END IF
	 
	IF ll_count > 0 THEN//-----------------------update de las unidades
		UPDATE dt_escalasxtela
			SET ca_unidades = ca_unidades + :ll_unidades
		 WHERE co_fabrica_exp 	= :ii_fabexp  AND  
				 cs_liberacion 	= :il_liberacion  AND  
				 nu_orden 			= :ls_po  AND  
				 nu_cut 				= :ls_cut  AND  
				 co_fabrica_pt 	= :li_fab  AND  
				 co_linea 			= :li_lin  AND  
				 co_referencia 	= :ll_ref  AND  
				 co_color_pt 		= :ll_color  AND  
				 co_tono 			= :ls_tono  AND  
				 co_modelo 			= :ll_mod  AND  
				 co_fabrica_tela 	= :li_fabtela  AND  
				 co_reftel 			= :ll_reftel  AND  
				 co_caract 			= :li_caract  AND  
				 diametro 			= :li_diametro  AND  
				 co_color_tela 	= :ll_colorte  AND  
				 co_talla 			= :li_talla ;	
				  
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_escalasxtela. '+ ls_error)
			Return -1
		END IF		  
		
	ELSE
		
		//------------------------------traigo la fecha del servidor
			ldt_fecha = f_fecha_servidor()
		
		//-------------------------el registro no existe se debe ingresar el registro en dt_escalasxtela
		INSERT INTO dt_escalasxtela  
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
				  co_talla,   
				  ca_unidades,   
				  yield,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia )  
	  VALUES ( :ii_fabexp,   
				  :il_liberacion,   
				  :ls_po,   
				  :ls_cut,   
				  :li_fab,   
				  :li_lin,   
				  :ll_ref,   
				  :ll_color,   
				  :ls_tono,   
				  :ll_mod,   
				  :li_fabtela,   
				  :ll_reftel,   
				  :li_caract,   
				  :li_diametro,   
				  :ll_colorte,   
				  :li_talla,   
				  :ll_unidades,   
				  :ldc_consumo,   
				  :ldt_fecha,   
				  :ldt_fecha,   
				  :as_usuario,   
				  :gstr_info_usuario.instancia )  ;
				  
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de guardar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_escalasxtela. '+ ls_error)
			Return -1
		END IF
	END IF
Next

Destroy lds_modelos
Return 0
end function

public function long of_criticas (long ai_fabrica, long ai_linea, long al_referencia, long ai_talla, long al_color, long al_unidades);//metodo para actualizar las criticas en el campo cant_liberado
//jcrm
//diciembre 6 de 2007
Long li_ano, li_semana
Long ll_count
n_cts_constantes_tela luo_tela

//se determina el a$$HEX1$$f100$$ENDHEX$$o y semana a la que pertenece la fecha de hoy
li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
  
//con el a$$HEX1$$f100$$ENDHEX$$o se busca la maxima semana
li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')
 
 //se debe verificar que exista registro en la tabla de las criticas
 SELECT count(*)
   INTO :ll_count
	FROM t_criticas_cedi
  WHERE co_fabrica 		= :ai_fabrica AND
  		  co_linea			= :ai_linea AND
		  co_referencia	= :al_referencia AND
 	 	  co_talla			= :ai_talla AND
		  co_color			= :al_color AND
		  ano					= :li_ano AND
		  semana				= :li_semana;
		  
IF ll_count > 0 THEN
	//existe registro se debe actualizar la cantidad de unidades liberadas
	UPDATE t_criticas_cedi
	   SET cant_liberado = cant_liberado + :al_unidades
	 WHERE co_fabrica 		= :ai_fabrica AND
  		    co_linea			= :ai_linea AND
		    co_referencia	   = :al_referencia AND
 	 	    co_talla			= :ai_talla AND
		    co_color			= :al_color AND
		    ano					= :li_ano AND
		    semana				= :li_semana;	
END IF

Return 0
end function

public function long of_cargardtrolloslibera (string as_usuario, long al_ordenpd_pt, string as_po, long al_color, decimal adc_ancho, long al_tanda, string as_usuario_op, long ai_tipo);//funcion para cargar dt_rollos_libera y dt_consumo_rollos
Long ll_result, ll_fila, ll_unidades, ll_reftel, ll_result2, ll_fila2, ll_unid_nec,&
	  ll_unid_rollo, ll_modelo, ll_unid_consu, ll_cs_rollo, ll_unid_disp, ll_ref, ll_count,&
	  ll_tanda, ll_unid_ini_rollo,ll_unid_utilizar, ll_color_te, ll_color
Long li_caract, li_diametro, li_talla, li_fab, li_lin,&
        li_result, li_fabtela, li_partir_rollo, li_ttejido
String ls_tono, ls_cut, ls_error, ls_instancia, ls_mensaje, lds_disenno
Decimal{2} ldc_ancho, ldc_metros, ldc_met_nec, ldc_met_rollo,ldc_metros_consu, ldc_met_disp, ldc_mts_ini_rollo, ld_mt_utilizar,ld_kg_validar_liberados
Decimal{3}	ldc_kg_consu, ldc_kg_ini_rollo, ld_kg_utilizar, ld_verif_mt, ld_verif_kg,  ldc_kilos, ldc_kg_rollo
DateTime ldt_fecha
Decimal{2} ld_valor_rollo, ldc_kg_nec
Integer	li_sw_rollo_completo
DataStore lds_recti, lds_no_recti, lds_rollos, lds_tela_otro_mod
n_cts_constantes luo_constantes 
luo_constantes = Create n_cts_constantes

//ai_tipo = 1 se esta liberando por la parte vieja
//ai_tipo = 2 se libera por la ventana de criticas
//jcrm
//febrero 26 de 2008

li_fabtela = luo_constantes.of_consultar_numerico("FABRICA TELA")
IF li_fabtela = -1 THEN
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de determinar la fabrica de la tela.',StopSign!)
	Return -1
END IF

ls_instancia = gstr_info_usuario.instancia

//creo los data store
lds_recti    = Create DataStore
lds_no_recti = Create DataStore
lds_rollos   = Create DataStore
lds_tela_otro_mod   = Create DataStore

//defino el data object
lds_recti.DataObject    		= 'ds_modelos_recti'
lds_no_recti.DataObject 		= 'ds_modelos_no_recti'
lds_rollos.DataObject   		= 'ds_rollos_libera' 
lds_tela_otro_mod.DataObject 	= 'ds_contar_tela_otro_modelo'

//se realiza el objeto transacional
lds_recti.SetTransObject(sqlca)
lds_no_recti.SetTransObject(sqlca)
lds_rollos.SetTransObject(sqlca)
lds_tela_otro_mod.SetTransObject(sqlca)

//----------------------------- traigo la fecha del servidor ---------------------------------------
ldt_fecha = f_fecha_servidor()



/////////////////temporalmente condicion para ensayar la opcion de no cortar con usuario de jmhenaoo
/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////


//se va a colocar la opcion para todos los liberadores el 28 de mayo por solicitud de jmhenaoo
//IF as_usuario = 'jmhenaoo' OR as_usuario = 'jorodrig' THEN
	

	//recorremos los datos que si son rectilineos
	ll_result = lds_recti.Retrieve(as_usuario,al_ordenpd_pt,as_po,al_color,adc_ancho,al_tanda)
	For ll_fila = 1 To ll_result
		ll_reftel 	= lds_recti.GetItemNumber(ll_fila,'co_reftel')
		li_caract 	= lds_recti.GetItemNumber(ll_fila,'co_caract')
		li_diametro = lds_recti.GetItemNumber(ll_fila,'diametro')
		ldc_ancho 	= lds_recti.GetItemNumber(ll_fila,'ancho')
		ll_color_te = lds_recti.GetItemNumber(ll_fila,'co_color_te')
		ls_tono 		= lds_recti.GetItemString(ll_fila,'tono')
		ll_unidades = lds_recti.GetITemNumber(ll_fila,'unid_real_liberar')
		ldc_metros 	= lds_recti.GetItemNumber(ll_fila,'metros')
		li_talla 	= lds_recti.GetItemNumber(ll_fila,'co_talla')
		ll_modelo   = lds_recti.GetItemNumber(ll_fila,'co_modelo')
		ll_tanda    = lds_recti.GetItemNumber(ll_fila,'cs_tanda')
	//	ls_tono		= 'A'
		li_fab 		= lds_recti.GetItemNumber(ll_fila,'co_fabrica')
		li_lin 		= lds_recti.GetItemNumber(ll_fila,'co_linea')
		ll_color 	= lds_recti.GetITemNumber(ll_fila,'co_color')
		ll_ref 		= lds_recti.GetItemNumber(ll_fila,'co_referencia')
		ls_cut 		= lds_recti.GetItemString(ll_fila,'nu_cut')
		lds_disenno = lds_recti.GetItemString(ll_fila,'co_estampado')
	
		
		
		//en este dw se verifica si la tela-caract-diametro-colorte esta en otro modelo para saber si hay que partir el rollo o llevarlo completo
		IF lds_tela_otro_mod.Retrieve(al_ordenpd_pt,al_color,ll_reftel,li_caract,ll_modelo,li_diametro,ll_color_te) > 0 THEN
			li_partir_rollo = 1
		ELSE
			li_partir_rollo = 0
		END IF
		
		ll_unid_nec = ll_unidades
		ldc_ancho = 0  //se pone cero porque son rectilineos y no tienen ancho
		//traigo los rollos ordenados de menor a mayor
		ll_result2 = lds_rollos.Retrieve(as_usuario,ll_reftel,li_caract,li_diametro,ldc_ancho,ll_color_te,ll_tanda,li_talla,lds_disenno)
		
		For ll_fila2 = 1 To ll_result2
			ll_unid_rollo = lds_rollos.GetItemNumber(ll_fila2,'ca_unidades')
			ll_cs_rollo = lds_rollos.GetItemNumber(ll_fila2,'cs_rollo')
			ld_mt_utilizar = lds_rollos.GetItemNumber(ll_fila2,'ca_mt')
			ldc_kg_rollo = lds_rollos.GetItemNumber(ll_fila2,'ca_kg')
			
			If ll_color_te <> 601 THEN   //este es el color definido como APT (sin color) en este caso no se cambia la tanda
				IF of_acttandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 THEN
					Rollback;
					MessageBox('Error 1','Al cambiar tanda por tono, Rollo: '+String(ll_cs_rollo)+' ERROR: ' + ls_mensaje, StopSign!)
					Return -1
				END IF
			END IF
			
			ldc_metros_consu = 0
			ll_unid_consu = 0
			//averiguo el total a cargar del rollo
			SELECT nvl(ca_metros,0), nvl(ca_unidades,0)
			  INTO :ldc_metros_consu, :ll_unid_consu
			  FROM dt_consumo_rollos
			 WHERE cs_rollo = :ll_cs_rollo;
		   If sqlca.sqlcode <> 0 Then
				IF sqlca.sqlcode = 100 THEN
					ldc_metros_consu = 0
					ll_unid_consu = 0
				ELSE
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar datos del rollo unidades' + ls_error)
					Return -1
				END IF
			END IF

			 
			SELECT ca_unidades
			  INTO :ll_unid_ini_rollo
			  FROM m_rollo
			 WHERE cs_rollo = :ll_cs_rollo;
			 If sqlca.sqlcode <> 0 Then
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar datos del rollo unidades' + ls_error)
				Return -1
			END IF
			 
			IF ll_unid_rollo <> (ll_unid_ini_rollo -  ll_unid_consu) THEN
				 ll_unid_disp = ll_unid_ini_rollo - ll_unid_consu
			ELSE
				ll_unid_disp = ll_unid_rollo
			END IF

			//si el rollo no se comparte se va a llevar completo en la liberacion esto se decidio
			//el 14 de mayo en reunion con Ubeimar, Edwin Serna, chucho, Pelaez, planeacion
			
			ll_unid_utilizar = ll_unid_disp
				  
			 SELECT DISTINCT
						nu_cut,
						co_fabrica_pt,
						co_linea,
						co_referencia,
						co_color_pt
				INTO  :ls_cut,
						:li_fab,
						:li_lin,
						:ll_ref,
						:ll_color
				FROM  dt_telaxmodelo_lib
			  WHERE  co_fabrica_exp = :ii_fabexp AND
						cs_liberacion  = :il_liberacion AND
						nu_orden			= :as_po AND  
						//co_tono			= :ls_tono AND
						co_modelo		= :ll_modelo AND
						co_reftel		= :ll_reftel AND
						co_caract		= :li_caract AND
						diametro			= :li_diametro AND
						co_color_tela	= :ll_color_te;
			If sqlca.sqlcode <> 0 Then
				ls_error = Sqlca.SqlErrText
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar datos de la tela y la liberaci$$HEX1$$f300$$ENDHEX$$n' + ls_error)
				Return -1
			END IF
					
			IF ll_unid_nec > ll_unid_disp THEN
				//inserto con las unidades del rollo, es decir ll_unid_disp
				
				//************* validacion de ceros
				//jcrm
				//octubre 9 de 2007
				IF ll_unid_disp <= 0 THEN
				ELSE
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
					  fe_actualizacion, ca_kg 	)  
				  VALUES ( :ii_fabexp,
					  :il_liberacion,
					  :as_po,
					  :ls_cut,
					  :li_fab,
					  :li_lin,
					  :ll_ref,
					  :ll_color,
					  :ls_tono,
					  :ll_modelo,
					  :li_fabtela,
					  :ll_reftel,
					  :li_caract,
					  :li_diametro,
					  :ll_color_te,
					  :ll_cs_rollo,
					  :ld_mt_utilizar,
					  :ll_unid_utilizar,
					  :as_usuario_op,
					  :gstr_info_usuario.instancia,
					  :ldt_fecha,
					  :ldt_fecha, :ldc_kg_rollo)  ;
					
					If sqlca.sqlcode <> 0 Then
						ls_error = Sqlca.SqlErrText
						Rollback;
						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n' + ls_error)
						Return -1
					Else
						SElECT count(*)
						  INTO :ll_count
						  FROM dt_rollos_libera
						 WHERE cs_liberacion = :il_liberacion AND
								 cs_rollo = :ll_cs_rollo AND
								 ca_unidades = 0;
								 
						IF ll_count = 1 THEN
							Rollback;
							MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
							Return -1
						END IF
					End if
					
					//se actualizan las tandas que se esta liberando por el sistema nuevo de criticas.
					If ai_tipo = 2 and ll_color_te <> 601 Then
						If of_acttandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 Then
							Rollback;
							MessageBox('Error 1','Al cambiar tanda por tono, Rollo: '+String(ll_cs_rollo)+' ERROR: ' + ls_mensaje, StopSign!)
							Return -1
						End if
					End if
					
					
					//actualizo el concepto del rollo para poder mostrar en el reporte de centro 15
					If of_act_concepto_rollo(ll_cs_rollo) = -1 Then
						Return -1
					End if
					
							
					//actualizo el consumo del rollo
					SELECT count(*)
					  INTO :ll_count
					  FROM dt_consumo_rollos
					 WHERE cs_rollo = :ll_cs_rollo; 
					 
					If ll_count > 0 THEN
						//actualizo
						UPDATE dt_consumo_rollos
							SET ca_unidades = ca_unidades + :ll_unid_utilizar,
								 fe_actualizacion = :ldt_fecha,
								 usuario = :as_usuario_op,
								 instancia = :gstr_info_usuario.instancia
						 WHERE cs_rollo = :ll_cs_rollo; 
						 
						 If sqlca.sqlcode <> 0 Then
							 ls_error = Sqlca.SqlErrText
							 Rollback;
							 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos' + ls_error)
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
						( :ll_cs_rollo,   
						  0,   
						  :ll_unid_utilizar,   
						  :ldt_fecha,   
						  :ldt_fecha,   
						  :as_usuario_op,   
						  :ls_instancia )  ;
			
						If sqlca.sqlcode <> 0 Then
							 ls_error = Sqlca.SqlErrText
							 Rollback;
							 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos ' + ls_error)
							 Return -1
						 End if
		
					End if
					
					ll_unid_nec -= ll_unid_disp
				END IF
			Else
				//lo que falta por liberar es menor a lo que se tiene en el rollo
				
				//se inserta con las unidades necesarias, es decir ll_unid_disp - ll_unid_nec
			//el 14 de mayo en reunion con ubeimar, edwin serna, chucho, pelaez, planeacion
			IF li_partir_rollo = 0     THEN   //no se comparte con otros rayas la misma tela color diametro no se parte
				ll_unid_utilizar = ll_unid_ini_rollo - ll_unid_consu
			ELSE
				ll_unid_utilizar = ll_unid_nec
			END IF
			IF il_op_agrupada = 1 AND li_sw_rollo_completo <> 1 THEN
					ldc_kg_rollo = (ll_unid_nec * ldc_kg_rollo) / ll_unid_utilizar
					ll_unid_utilizar = ll_unid_nec
			END IF
			
				IF ll_unid_nec <= 0 THEN
				ELSE
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
					  fe_actualizacion, ca_kg  )  
				VALUES ( :ii_fabexp,
					  :il_liberacion,
					  :as_po,
					  :ls_cut,
					  :li_fab,
					  :li_lin,
					  :ll_ref,
					  :ll_color,
					  :ls_tono,
					  :ll_modelo,
					  :li_fabtela,
					  :ll_reftel,
					  :li_caract,
					  :li_diametro,
					  :ll_color_te,
					  :ll_cs_rollo,
					  :ld_mt_utilizar,
					  :ll_unid_utilizar,
					  :as_usuario_op,
					  :gstr_info_usuario.instancia,
					  :ldt_fecha,
					  :ldt_fecha, :ldc_kg_rollo)  ;
					
					If sqlca.sqlcode <> 0 Then
						ls_error = Sqlca.SqlErrText
						Rollback;
						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n ' + ls_error)
						Return -1
					Else
						SElECT count(*)
						  INTO :ll_count
						  FROM dt_rollos_libera
						 WHERE cs_liberacion = :il_liberacion AND
								 cs_rollo = :ll_cs_rollo AND
								 ca_metros = 0 AND
								 ca_unidades = 0;
								 
						IF ll_count = 1 THEN
							Rollback;
							MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
							Return -1
						END IF
					End if
					
					//se actulaizan las tandas se se esta liberando por el sistema nuevo de criticas.
					If ai_tipo = 2 and ll_color_te <> 601 Then
						If of_acttandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 Then
							Rollback;
							MessageBox('Error 1','Al cambiar tanda por tono, Rollo: '+String(ll_cs_rollo)+' ERROR: ' + ls_mensaje, StopSign!)
							Return -1
						End if
					End if
					
					//actualizo el concepto del rollo para poder mostrar en el reporte de centro 15
					If of_act_concepto_rollo(ll_cs_rollo) = -1 Then
						Return -1
					End if
					
				
					//actualizo el consumo del rollo
					SELECT count(*)
					  INTO :ll_count
					  FROM dt_consumo_rollos
					 WHERE cs_rollo = :ll_cs_rollo; 
					 If sqlca.sqlcode <> 0 Then
						 ls_error = Sqlca.SqlErrText
						 Rollback;
						 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el consumo de  los rollos' + ls_error)
						 Return -1
					 End if
					 
				  If ll_count > 0 THEN
						//actualizo
						UPDATE dt_consumo_rollos
							SET ca_unidades = ca_unidades + :ll_unid_utilizar,
								 fe_actualizacion = :ldt_fecha,
								 usuario = :as_usuario_op,
								 instancia = :gstr_info_usuario.instancia
						 WHERE cs_rollo = :ll_cs_rollo; 
						 
						 If sqlca.sqlcode <> 0 Then
							 ls_error = Sqlca.SqlErrText
							 Rollback;
							 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos' + ls_error)
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
						( :ll_cs_rollo,   
						  0,   
						  :ll_unid_utilizar,   
						  :ldt_fecha,   
						  :ldt_fecha,   
						  :as_usuario_op,   
						  :ls_instancia )  ;
			
						If sqlca.sqlcode <> 0 Then
							 ls_error = Sqlca.SqlErrText
							 Rollback;
							 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos ' + ls_error)
							 Return -1
						 End if
		
					End if
					//no es necesario seguir en el ciclo
					ll_fila2 = ll_result2 + 1
					ll_unid_nec = 0
					
				END IF
				
			End if
		Next
		
		IF ll_unid_nec > 0 THEN    //si los metros necesarios son mayores a cero es porque no inserto todo lo que necesitaba para el modelo, se sale con error
			 Rollback;
			 MessageBox('Error','Se presento problema con las unidades de los rollos, no cargo toda la tela necesaria para cada modelo')
			 Return -1
		END IF
	
	Next
	
	//recorremos los datos que no son rectilineos
	ll_result = lds_no_recti.Retrieve(as_usuario,al_ordenpd_pt,as_po,al_color,adc_ancho,al_tanda)
	For ll_fila = 1 To ll_result
		ll_reftel 	= lds_no_recti.GetItemNumber(ll_fila,'co_reftel')
		li_caract 	= lds_no_recti.GetItemNumber(ll_fila,'co_caract')
		li_diametro = lds_no_recti.GetItemNumber(ll_fila,'diametro')
		ldc_ancho 	= lds_no_recti.GetItemNumber(ll_fila,'ancho')
		ll_color_te = lds_no_recti.GetItemNumber(ll_fila,'co_color_te')
		ls_tono 		= lds_no_recti.GetItemString(ll_fila,'tono')
		ll_unidades = lds_no_recti.GetITemNumber(ll_fila,'unid_real_liberar')
	//	ldc_metros 	= lds_no_recti.GetItemNumber(ll_fila,'metros')
		ldc_kilos 	= lds_no_recti.GetItemDecimal(ll_fila,'kilos')
		ll_modelo   = lds_no_recti.GetItemNumber(ll_fila,'co_modelo')
		ll_tanda    = lds_no_recti.GetItemNumber(ll_fila,'cs_tanda')
		//ls_tono		= 'A'
		li_fab 		= lds_no_recti.GetItemNumber(ll_fila,'co_fabrica')
		li_lin 		= lds_no_recti.GetItemNumber(ll_fila,'co_linea')
		ll_color 	= lds_no_recti.GetITemNumber(ll_fila,'co_color')
		ll_ref 		= lds_no_recti.GetItemNumber(ll_fila,'co_referencia')
		ls_cut 		= lds_no_recti.GetItemString(ll_fila,'nu_cut')
		li_ttejido	= lds_no_recti.GetItemNumber(ll_fila,'co_ttejido')
		lds_disenno = lds_no_recti.GetItemString(ll_fila,'co_estampado')
		ldc_met_nec = ldc_metros
		ldc_kg_nec  = ldc_kilos
		IF ldc_kg_nec < 0.01 THEN
			ldc_kg_nec = 0.01
		END IF
	
		//en este dw se verifica si la tela-caract-diametro-colorte esta en otro modelo para saber si hay que partir el rollo o llevarlo completo
		IF lds_tela_otro_mod.Retrieve(al_ordenpd_pt,al_color,ll_reftel,li_caract,ll_modelo,li_diametro,ll_color_te) > 0 THEN
			li_partir_rollo = 1
		ELSE
			li_partir_rollo = 0
		END IF
		
		
		//traigo los rollos ordenados de menor a mayor
		ll_result2 = lds_rollos.Retrieve(as_usuario,ll_reftel,li_caract,li_diametro,ldc_ancho,ll_color_te,ll_tanda,9999,lds_disenno)
		For ll_fila2 = 1 To ll_result2
			ldc_met_rollo = lds_rollos.GetItemNumber(ll_fila2,'ca_mt')
			ldc_kg_rollo = lds_rollos.GetItemNumber(ll_fila2,'ca_kg')
			ll_cs_rollo = lds_rollos.GetItemNumber(ll_fila2,'cs_rollo')
			li_sw_rollo_completo = lds_rollos.GetItemNumber(ll_fila2,'sw_completo')
			IF ll_color_te <> 601 THEN  //en el color APT no se va a cambiar la tanda, esto por si se anula se pueda volver a liberar sin problemas.
				IF of_acttandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 THEN
					Rollback;
					MessageBox('Error 1','Al cambiar tanda por tono, Rollo: '+String(ll_cs_rollo)+' ERROR: ' + ls_mensaje, StopSign!)
					Return -1
				END IF
			END IF
			
			ldc_metros_consu = 0
			ll_unid_consu = 0
			//averiguo el total a cargar del rollo
			SELECT nvl(ca_metros,0), nvl(ca_unidades,0), nvl(kg_liberados,0)
			  INTO :ldc_metros_consu, :ll_unid_consu, :ldc_kg_consu
			  FROM dt_consumo_rollos
			 WHERE cs_rollo = :ll_cs_rollo;
 			If sqlca.sqlcode <> 0 Then
				IF sqlca.sqlcode = 100 THEN
					ldc_metros_consu = 0
					ll_unid_consu = 0
					ldc_kg_consu = 0
				ELSE
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el consumo de  los rollos, Error: '+ ls_error)
					Return -1
				END IF
			End if

		
//Este query lo pongo en comentario para que no me descuadre las cantidades de los rollos  que fueron afectados por el porcentaje en la agrupacion,  //inicio proyecto  de agrupacion de pedido
//se podria poner a que solo sea comentariado para las OP agrupadas, en las demas se puede dejar activo. jorodrig 30/06/2020
		
//			SELECT ca_mt, ca_kg
//			  INTO :ldc_mts_ini_rollo, :ldc_kg_ini_rollo
//			  FROM m_rollo
//			 WHERE cs_rollo = :ll_cs_rollo;
//			If sqlca.sqlcode <> 0 Then
//				ls_error = Sqlca.SqlErrText
//				Rollback;
//				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el los kilos del rollo, Error: '+ ls_error)
//				Return -1
//			END IF
//fin
/////en vez de las lineas anteriores se crea esta sig dos lineas para tener las variables kg_ini y mt_ini con datos porque se utilizan adelante, proyecto agrupacion de pedidos 
			ldc_mts_ini_rollo = ldc_met_rollo
			ldc_kg_ini_rollo = ldc_kg_rollo
			
			IF ldc_kg_rollo <> (ldc_kg_ini_rollo - ldc_kg_consu) THEN
				ldc_kg_rollo = ldc_kg_ini_rollo - ldc_kg_consu
				ldc_met_disp = ldc_mts_ini_rollo - ldc_metros_consu
			ELSE
				ldc_met_disp = ldc_met_rollo
			END IF




			
	//pryueba para caso de rollos en hiladillas que libera por metros y se carga por kilos
			IF li_ttejido = 131 OR li_ttejido = 212 OR li_ttejido = 211 THEN  //en hiladillas 
				ld_valor_rollo = ldc_met_disp
			ELSE
				ld_valor_rollo = ldc_kg_rollo
			END IF
			
			
			IF ldc_kg_nec > ld_valor_rollo THEN
//			IF ldc_kg_nec > ldc_kg_rollo THEN
				//las unidades del rollo que traemos no son suficientes para cumplir la liberaci$$HEX1$$f300$$ENDHEX$$n, debemos cargar este rollo
				//y continuar con el siguiente hasta agotar las unidades necesarias.
				IF ldc_met_disp < 0 THEN
					Rollback;
					MessageBox('Error','Esta quedando los metros liberados negativos en el rollo:  '+ String(ll_cs_rollo))
					Return -1
				END IF
				
				//inserto con las unidades del rollo, es decir ldc_met_disp
				IF ldc_kg_rollo <= 0 THEN
				ELSE
					
					IF ldc_kg_rollo < 0.006 THEN
						Rollback;
						MessageBox('Error','Esta quedando los metros liberados negativos en el rollo:  '+ String(ll_cs_rollo))
						Return -1
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
					  fe_actualizacion,
					  ca_kg)  
				 VALUES ( :ii_fabexp,
					  :il_liberacion,
					  :as_po,
					  :ls_cut,
					  :li_fab,
					  :li_lin,
					  :ll_ref,
					  :ll_color,
					  :ls_tono,
					  :ll_modelo,
					  :li_fabtela,
					  :ll_reftel,
					  :li_caract,
					  :li_diametro,
					  :ll_color_te,
					  :ll_cs_rollo,
					  :ldc_met_disp,
					  0,
					  :as_usuario_op,
					  :gstr_info_usuario.instancia,
					  :ldt_fecha,
					  :ldt_fecha,
					  :ldc_kg_rollo)  ;
					
					If sqlca.sqlcode <> 0 Then
						ls_error = Sqlca.SqlErrText
						Rollback;
						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n, Error: '+ ls_error)
						Return -1
					Else
						SElECT count(*)
						  INTO :ll_count
						  FROM dt_rollos_libera
						 WHERE cs_liberacion = :il_liberacion AND
								 cs_rollo = :ll_cs_rollo AND
								 ca_kg = 0 ;
								 
						IF ll_count = 1 THEN
							Rollback;
							MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
							Return -1
						END IF
					End if
					
					//se actulaizan las tandas se se esta liberando por el sistema nuevo de criticas.
					If ai_tipo = 2 AND ll_color_te <> 601 Then
						If of_acttandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 Then
							Rollback;
							MessageBox('Error 1','Al cambiar tanda por tono, Rollo: '+String(ll_cs_rollo)+' ERROR: ' + ls_mensaje, StopSign!)
							Return -1
						End if
					End if
					
					//actualizo el concepto del rollo para poder mostrar en el reporte de centro 15
					If of_act_concepto_rollo(ll_cs_rollo) = -1 Then
						Return -1
					End if
					
					//actualizo el consumo del rollo
					SELECT count(*)
					  INTO :ll_count
					  FROM dt_consumo_rollos
					 WHERE cs_rollo = :ll_cs_rollo; 
					 
					 If ll_count > 0 THEN
						//actualizo
						UPDATE dt_consumo_rollos
							SET ca_metros = ca_metros + :ldc_met_disp,
							    kg_liberados = nvl(kg_liberados,0) + :ldc_kg_rollo,
								 fe_actualizacion = :ldt_fecha,
								 usuario = :as_usuario_op,
								 instancia = :gstr_info_usuario.instancia
						 WHERE cs_rollo = :ll_cs_rollo; 
						 
						 If sqlca.sqlcode <> 0 Then
							 ls_error = Sqlca.SqlErrText
							 Rollback;
							 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos, Error: ' + ls_error)
							 Return -1
						 End if
						 
 						SELECT ca_metros, kg_liberados
					     INTO :ld_verif_mt, :ld_verif_kg
						  FROM dt_consumo_rollos
						 WHERE cs_rollo =  :ll_cs_rollo;
						IF ld_verif_mt > ldc_mts_ini_rollo OR  ld_verif_kg > ldc_kg_ini_rollo THEN
							Rollback;
							MessageBox('Advertencia', 'el rollo esta quedando con mas metros o kilos a liberar de los que tiene, informe a sistemas para que verifque')
							Return -1
						END IF

					 Else
							//inserto
							INSERT INTO dt_consumo_rollos  
						( cs_rollo,   
						  ca_metros,   
						  ca_unidades,   
						  fe_creacion,   
						  fe_actualizacion,   
						  usuario,   
						  instancia,
						  kg_liberados)  
							VALUES 
						( :ll_cs_rollo,   
						  :ldc_met_disp,   
						  0,   
						  :ldt_fecha,   
						  :ldt_fecha,   
						  :as_usuario_op,   
						  :ls_instancia,
						  :ldc_kg_rollo)  ;
			
						If sqlca.sqlcode <> 0 Then
							 ls_error = Sqlca.SqlErrText
							 Rollback;
							 MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos, Error: '+ ls_error)
							 Return -1
						 End if
		
					 End if
				

				//	ldc_kg_nec -= ldc_kg_rollo
					ldc_kg_nec -= ld_valor_rollo
				END IF
			Else
				//lo que falta por liberar es menor a lo que se tiene en el rollo
				
				IF ldc_met_nec < 0 THEN
					Rollback;
					MessageBox('Error','Esta quedando los metros liberados negativos en el rollo:  '+ String(ll_cs_rollo))
					Return -1
				END IF
				
				IF (li_partir_rollo = 0) OR  (ll_fila = ll_result)  THEN   //no se comparte con otros rayas la misma tela color diametro no se parte,  o es la ultima fila entonces se lleva el rollo completo
					ld_mt_utilizar = ldc_mts_ini_rollo - ldc_metros_consu
					ldc_kg_rollo = ldc_kg_ini_rollo - ldc_kg_consu
					ld_kg_utilizar = ldc_kg_rollo
					IF il_op_agrupada = 1 AND li_sw_rollo_completo <> 1 then
						ld_kg_utilizar = ldc_kg_nec
				  		ld_mt_utilizar = (ldc_kg_nec * ld_mt_utilizar)/ ldc_kg_rollo
				    END IF
					
				ELSE
				//	ld_mt_utilizar = (ldc_kg_nec * ldc_met_disp) / ldc_kg_rollo
					ld_mt_utilizar = (ldc_kg_nec * ldc_met_disp) / ld_valor_rollo
					IF li_ttejido = 131 Or li_ttejido = 212 Or li_ttejido = 211 THEN  //en hiladillas 
						ld_kg_utilizar  = (ld_mt_utilizar * ldc_kg_ini_rollo) / ldc_mts_ini_rollo
					ELSE
						ld_kg_utilizar = ldc_kg_nec
					END IF
				END IF
					
				
				IF ld_kg_utilizar < 0.006 THEN
					Rollback;
					MessageBox('Error','Esta quedando los metros liberados negativos en el rollo:  '+ String(ll_cs_rollo))
					Return -1
				END IF
				
				//se inserta con las unidades necesarias, es decir ldc_met_nec
				IF ldc_kg_rollo = 0 THEN
				ELSE
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
					  fe_actualizacion,
					  ca_kg)  
		  VALUES ( :ii_fabexp,
					  :il_liberacion,
					  :as_po,
					  :ls_cut,
					  :li_fab,
					  :li_lin,
					  :ll_ref,
					  :ll_color,
					  :ls_tono,
					  :ll_modelo,
					  :li_fabtela,
					  :ll_reftel,
					  :li_caract,
					  :li_diametro,
					  :ll_color_te,
					  :ll_cs_rollo,
					  :ld_mt_utilizar,
					  0,
					  :as_usuario_op,
					  :gstr_info_usuario.instancia,
					  :ldt_fecha,
					  :ldt_fecha,
					  :ld_kg_utilizar)  ;
					
					If sqlca.sqlcode <> 0 Then
						ls_error = Sqlca.SqlErrText
						Rollback;
						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n, Error: '+ ls_error)
						Return -1
					Else
						SElECT count(*)
						  INTO :ll_count
						  FROM dt_rollos_libera
						 WHERE cs_liberacion = :il_liberacion AND
								 cs_rollo = :ll_cs_rollo AND
								 ca_kg = 0;
								 
						IF ll_count = 1 THEN
							Rollback;
							MessageBox('Error','Se estan insertando rollos con cero metros y unidades, comuniquese con Informatica.',StopSign!)
							Return -1
						END IF
				
					End if
					
					//se actulaizan las tandas se se esta liberando por el sistema nuevo de criticas.
					If ai_tipo = 2 AND ll_color_te <> 601 Then
						If of_acttandarollo(ll_cs_rollo,ls_tono,ls_mensaje) = -1 Then
							Rollback;
							MessageBox('Error 1','Al cambiar tanda por tono, Rollo: '+String(ll_cs_rollo)+' ERROR: ' + ls_mensaje, StopSign!)
							Return -1
						End if
					End if
					
					//actualizo el concepto del rollo para poder mostrar en el reporte de centro 15
					If of_act_concepto_rollo(ll_cs_rollo) = -1 Then
						Return -1
					End if
					
					//actualizo el consumo del rollo

					SELECT count(*)
					  INTO :ll_count
					  FROM dt_consumo_rollos
					 WHERE cs_rollo = :ll_cs_rollo; 
					If sqlca.sqlcode <> 0 Then
						ls_error = Sqlca.SqlErrText
						Rollback;
						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el consumo de  los rollos, Error: '+ ls_error)
						Return -1
					End if

				 
					 If ll_count > 0 THEN
						//actualizo si no se parte el rollo se carga con los metros totales del rollo, pero si se
						//comparte con otra raya se debe partir y cargar solo el consumo que lleva la raya
					
						UPDATE dt_consumo_rollos
							SET ca_metros = ca_metros + :ld_mt_utilizar,
								 kg_liberados = nvl(kg_liberados,0) + :ld_kg_utilizar,
								 fe_actualizacion = :ldt_fecha,
								 usuario = :as_usuario_op,
								 instancia = :gstr_info_usuario.instancia
						 WHERE cs_rollo = :ll_cs_rollo; 
					
						 
						If sqlca.sqlcode <> 0 Then
						   ls_error = Sqlca.SqlErrText
							Rollback;
						   MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos, Error: '+ ls_error)
							Return -1
						End if
						
						SELECT ca_metros, kg_liberados
					     INTO :ld_verif_mt, :ld_verif_kg
						  FROM dt_consumo_rollos
						 WHERE cs_rollo =  :ll_cs_rollo;
						 
						//	IF ld_verif_mt > ldc_mts_ini_rollo OR  ld_verif_kg > ldc_kg_ini_rollo THEN se coloca en comentario este linea y se cambia or la sig linea proyecto agrupacion de pedidos
						IF ld_verif_mt > ldc_mts_ini_rollo OR  ld_verif_kg > ldc_kg_ini_rollo THEN
							Rollback;
							MessageBox('Advertencia', 'el rollo esta quedando con mas metros o kilos a liberar de los que tiene, informe a sistemas para que verifque')
							Return -1
						END IF
						 
						 
					 Else
						
						//inserto
						INSERT INTO dt_consumo_rollos  
							( cs_rollo,   
							  ca_metros,   
							  ca_unidades,   
							  fe_creacion,   
							  fe_actualizacion,   
							  usuario,   
							  instancia,
							  kg_liberados)  
								VALUES 
							( :ll_cs_rollo,   
							  :ld_mt_utilizar,   
							  0,   
							  :ldt_fecha,   
							  :ldt_fecha,   
							  :as_usuario_op,   
							  :ls_instancia,
							  :ld_kg_utilizar)  ;

				
						If sqlca.sqlcode <> 0 Then
							ls_error = Sqlca.SqlErrText
							Rollback;
							MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar el consumo de  los rollos, Error: '+ ls_error)
							Return -1
						End if
		
					End if
					//no es necesario seguir en el ciclo
					ll_fila2 = ll_result2 + 1
					ldc_met_nec = 0
					ldc_kg_nec = 0
				END IF
			End if
			
			
			//validacion para evitar que los decimales del rollo sumen mas de lo que tiene el rollo, este error se esta generando desde que se aument$$HEX2$$f3002000$$ENDHEX$$el tama$$HEX1$$f100$$ENDHEX$$o a la variable

			SELECT SUM(ca_kg)
			  INTO :ld_kg_validar_liberados
			  FROM dt_rollos_libera
			 WHERE co_fabrica_exp= :ii_fabexp
			   AND cs_liberacion = :il_liberacion
				AND nu_orden		= :as_po
				AND nu_cut			= :ls_cut
				AND co_fabrica_pt = :li_fab
				AND co_linea		= :li_lin
				AND co_referencia	= :ll_ref
				AND co_color_pt   = :ll_color
				AND cs_rollo		= :ll_cs_rollo;
				
				IF (ld_kg_validar_liberados >  ldc_kg_rollo) AND (ld_kg_validar_liberados > ldc_kg_ini_rollo)  THEN
	//			IF ld_kg_validar_liberados > ldc_kg_ini_rollo THEN     se cambia esta condicion por la anterior para el proyecto de agrupacion de pedidos
					Rollback;
					MessageBox('Advertencia', 'Control para evitar el problema que esta presentando al partir los rollos en la mercada, se cancela el proceso, informe a sistemas para que verifque')
					Return -1
				END IF
			
		Next
		
	
	Next

IF ldc_kg_nec > 0.5 THEN
	Rollback;
	MessageBox('Error','Se va a cargar menos kilos de los que se necesitan para las unidades liberadas,  control para corregir un error en el sistema, pase todos los datos a informatica para corregir el error')
	Return -1
END IF

Destroy lds_recti    
Destroy lds_no_recti 
Destroy lds_rollos   
Destroy lds_tela_otro_mod

Return 0
end function

public function long of_insertar_talla_pedido_pdn (long al_pedido, string as_po, string as_cut, long ai_fab, long ai_linea, long al_ref, long ai_item, long ai_talla, long al_color, long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, string as_talla_exp, long al_cantidad, date adt_fe_despacho, long ai_cliente, long ai_sucursal, long ai_coleccion);

n_cst_cronograma lnvo_crono		
n_cst_peddig lnvo_peddig
n_cst_pedpend_exp lnvo_pedpend_exp

DateTime ldtm_fecha_hoy, ldtm_ini_confecion
Long	li_result

ldtm_fecha_hoy = f_fecha_servidor()


lnvo_pedpend_exp.Of_Reiniciar_Propiedades()

// ciclo para llenar el detalle
lnvo_pedpend_exp.pedido = al_pedido
// Para que tome por defecto el 1
lnvo_pedpend_exp.item = ai_item
// Se toma el cliente, sucursal, coleccion del encabezado 
lnvo_pedpend_exp.co_cliente_exp = ai_cliente
lnvo_pedpend_exp.co_sucursal_exp = ai_sucursal
lnvo_pedpend_exp.co_coleccion = ai_coleccion
//PO CUT
lnvo_pedpend_exp.nu_orden = as_po
lnvo_pedpend_exp.nu_cut = as_cut

// Fecha de entrega del detalle
lnvo_pedpend_exp.fe_entrega = adt_fe_despacho
// REF PRODUCCION 
lnvo_pedpend_exp.co_fabrica	= ai_fab
lnvo_pedpend_exp.co_linea		= ai_linea
lnvo_pedpend_exp.co_referencia= al_ref
lnvo_pedpend_exp.co_talla	= ai_talla
lnvo_pedpend_exp.co_calidad	= 1
lnvo_pedpend_exp.co_color		= al_color
// REF DE VENTA
lnvo_pedpend_exp.co_fabrica_exp = ai_fab_exp
lnvo_pedpend_exp.co_linea_exp = ai_linea_exp
lnvo_pedpend_exp.co_talla_exp = as_talla_exp
lnvo_pedpend_exp.co_ref_exp =   as_ref_exp
lnvo_pedpend_exp.co_color_exp = as_color_exp
lnvo_pedpend_exp.po_master    = string(il_pedido_anterior)
lnvo_pedpend_exp.instresp_empq = is_instresp_empq
lnvo_pedpend_exp.co_division = ii_zona

// CANTIDAD DEL DETALLE
lnvo_pedpend_exp.ca_pedida = al_cantidad
//lnvo_pedpend_exp.ca_pedida_comprar = al_cantidad  + (al_cantidad * (ii_porc_mas / 100))
lnvo_pedpend_exp.ca_pedida_comprar = 0
lnvo_pedpend_exp.ca_liberada = al_cantidad

lnvo_pedpend_exp.fe_creacion = ldtm_fecha_hoy
lnvo_pedpend_exp.fe_actualizacion = ldtm_fecha_hoy
lnvo_pedpend_exp.instancia = gstr_info_usuario.instancia
lnvo_pedpend_exp.usuario = gstr_info_usuario.codigo_usuario

If lnvo_pedpend_exp.Of_Crear() < 0 Then
	ROLLBACK;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error al generar el detalle del pedido!', StopSign!)
	Return -1
End If

//crear el pedido para calidad 2
lnvo_pedpend_exp.ca_pedida = 0
lnvo_pedpend_exp.ca_liberada = 0
lnvo_pedpend_exp.co_calidad	= 2
lnvo_pedpend_exp.item = ai_item + 100
lnvo_pedpend_exp.ca_pedida_comprar = 0
If lnvo_pedpend_exp.Of_Crear() < 0 Then
	ROLLBACK;
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un error al generar el detalle del pedido en calidad 2!', StopSign!)
	Return -1
End If


//actualizar el pedido inicial con las unidades en cantidad anulada
li_result = of_anular_unidades_po(ai_fab,ai_linea,al_ref,al_color,ai_talla,ai_linea_exp,as_ref_exp,as_color_exp,as_talla_exp,al_cantidad)
IF li_result = -1 THEN
	Return -1
END IF

w_principal.SetMicroHelp('Se genero el pedido ...')
Return 1


end function

public subroutine of_buscar_fabrica_exp (long ai_fab, long ai_linea, long al_referencia, long al_color, long ai_talla, ref long ai_fabrica_exp);Select Max(co_fabrica_exp)
  Into :ai_fabrica_exp
  From pedpend_exp
 Where pedido = :il_pedido_anterior                                                      
   And co_fabrica = :ai_fab
   And co_linea = :ai_linea
   And co_referencia = :al_referencia
   And co_color = :al_color
	And co_talla = :ai_talla ;
end subroutine

public function long of_anular_unidades_po (long ai_fabrica, long ai_linea, long al_referencia, long al_color_pt, long ai_talla, long ai_linea_exp, string as_ref_exp, string as_color_exp, string as_talla_exp, long ai_unidades);Long	ll_unid_comprar, ll_ca_anulada, ll_pedida_comprar, ll_ca_pedida
String	ls_usuario
//Esta funcion realiza la actualizacion de unidades en la tabla pedpend_exp en el  campo ca_anulada
//cuando se genera un nuevo pedido en la liberacion, esto se decidio asi para que no se da$$HEX1$$f100$$ENDHEX$$aran
//los reportes
//jorodrig   septiembre 18 - 2008
ls_usuario = gstr_info_usuario.codigo_usuario
ll_unid_comprar = ai_unidades + (ai_unidades * (ii_porc_mas / 100))

IF ai_unidades < 0 THEN
	Rollback;
	MessageBox('Error','Las unidades que va a actualizar en el pedido son negativas')
	Return -1
END IF

IF il_pedido_anterior > 0 THEN

	SELECT sum(ca_anulada), sum(ca_pedida_comprar), sum(ca_pedida)
	  INTO :ll_ca_anulada, :ll_pedida_comprar, :ll_ca_pedida
	  FROM pedpend_exp
 	 WHERE pedido        = :il_pedido_anterior
		AND co_fabrica    = :ai_fabrica
		AND co_linea      = :ai_linea
		AND co_referencia = :al_referencia
		AND co_color      = :al_color_pt
		AND co_talla      = :ai_talla
		AND co_linea_exp  = :ai_linea_exp
		AND co_ref_exp    = :as_ref_exp
		AND co_color_exp  = :as_color_exp
		ANd co_talla_exp  = :as_talla_exp
		AND co_calidad    = 1;
	//maximo las unidades anuladas deben ser iguales a la cantidad pedida, se hace este cambio el 16 de feb del 2009
	//por problemas que nos cuenta john Fredy Osorio con POs que quedan con mayor unidades anuladas que las pedidas
	//esto se puede presentar porque es posible liberar mas unidades de las pedidas   jorodrig
	ll_ca_anulada	= ll_ca_anulada + ai_unidades
	IF ll_ca_anulada > ll_ca_pedida THEN ll_ca_anulada = ll_ca_pedida
	
	ll_pedida_comprar = ll_pedida_comprar -  ll_unid_comprar
	IF ll_pedida_comprar < 0 THEN ll_pedida_comprar = 0


	UPDATE pedpend_exp
		SET (ca_anulada,  porc_eficiencia, fe_actualizacion, usuario )
		  = (:ll_ca_anulada,  99, Current, :ls_usuario )
	 WHERE pedido        = :il_pedido_anterior
		AND co_fabrica    = :ai_fabrica
		AND co_linea      = :ai_linea
		AND co_referencia = :al_referencia
		AND co_color      = :al_color_pt
		AND co_talla      = :ai_talla
		AND co_linea_exp  = :ai_linea_exp
		AND co_ref_exp    = :as_ref_exp
		AND co_color_exp  = :as_color_exp
		ANd co_talla_exp  = :as_talla_exp
		AND co_calidad    = 1;
	
	IF sqlca.sqlcode <> 0 THEN
		Rollback;
		MessageBox('Error','Se presento un error cargando en el pedido anterior las unidades liberadas')
		Return -1
	END IF
END IF

Return 1
end function

public function long of_verificar_pedido_en_op (long al_ordenpd_pt, long al_color_pt, long ai_talla, string as_po, string as_color_exp, string as_talla_exp);//Verificar que los datos que esta insertando en la liberacion si esten 
//creados en la orden de produccion.
//jorodrig   julio 10 - 09
Long li_existe
STRING	ls_error


SELECT COUNT(*)
  INTO :li_existe
  FROM dt_caxpedidos
 WHERE cs_ordenpd_pt = :al_ordenpd_pt
   AND co_color      = :al_color_pt
	AND co_talla      = :ai_talla
	AND pedido        = :il_pedido_op
	AND nu_orden      = :as_po
	AND color_exp     = :as_color_exp
	AND co_talla_exp  = :as_talla_exp;

IF li_existe = 0 THEN	
SELECT COUNT(*)
  INTO :li_existe
  FROM dt_caxpedidos
 WHERE cs_ordenpd_pt = :al_ordenpd_pt
   AND co_color      = :al_color_pt
	AND co_talla      = :ai_talla
	AND pedido        = :il_pedido_anterior
	AND nu_orden      = :as_po
	AND color_exp     = :as_color_exp
	AND co_talla_exp  = :as_talla_exp;
END IF
IF Sqlca.SqlCode = -1 THEN
	ls_error = Sqlca.SqlErrText
	rollback;
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el pedido con los colores y tallas en la op. '+ls_error)
	Return -1
END IF	
	
IF li_existe > 0 THEN
	Return 1
ELSE
	Return 0
END IF
end function

public function long of_cargardttallapdnmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_colorpt, long ai_talla, long al_unidades, string as_po, string as_cut, string as_tono, long ai_proporcion, string as_usuario, long al_op_estilo, long ai_tipo_lib, long ai_consc_talla, long al_cons_lib_duo, string as_color_exp, long ai_linea_exp, string as_ref_exp, string as_talla_exp, long ai_fab_exp, long al_unid_prog);Long li_simulacion, li_planta, li_fabplanta, li_modulo, li_ordentalla, li_estado_asigna,&
		  li_fuente_dato,  li_result, li_ano, li_semana
DateTime ldt_fecha
String ls_error
n_cts_constantes_tela luo_tela
n_cts_liberacion_x_proyeccion luo_liberacion_x_proyeccion

//
//---------------------------cargo las constantes necesarias para cargar dt_tallapdnmodulo
SELECT numerico
  INTO :li_simulacion
  FROM m_constantes
 WHERE var_nombre = "SIMULACION";

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para la simulaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_fabplanta
  FROM m_constantes
 WHERE var_nombre = "FABRICA PLANTA";

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para la fabrica. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_planta
  FROM m_constantes
 WHERE var_nombre = "PLANTA LIBERACIONES";

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para la planta. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_modulo
  FROM m_constantes
 WHERE var_nombre = "MODULO";

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para el m$$HEX1$$f300$$ENDHEX$$dulo. '+ ls_error)
	Return -1
END IF
  
SELECT numerico
  INTO :li_estado_asigna
  FROM m_constantes
 WHERE var_nombre = "ESTADO ASIGNA";

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para el estado. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_fuente_dato
  FROM m_constantes
 WHERE var_nombre = "SEMIAUTOMATICA";

IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para el tipo de liberaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
	Return -1
END IF

ldt_fecha = f_fecha_servidor()

//buscamos los datos de criticas
//IF al_cons_lib_duo > 0 THEN
//	//se determina el a$$HEX1$$f100$$ENDHEX$$o y semana a la que pertenece la fecha de hoy
//	li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
//	//  
//	////con el a$$HEX1$$f100$$ENDHEX$$o se busca la maxima semana
//	li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')
//	
//	SELECT max(co_talla_exp)
//		  INTO :as_talla_exp
//		  FROM t_criticas_cedi
//		 WHERE ano = :li_ano
//		 	AND semana = :li_semana
//			AND co_fabrica = :ai_fabpt
//			AND co_linea = :ai_lin
//			AND co_referencia = :al_ref
//			AND co_talla = :ai_talla
//			AND co_color = :al_colorpt
//			AND co_fabrica_exp = :ai_fab_exp
//			AND co_linea_exp = :ai_linea_exp
//			AND co_ref_exp = :as_ref_exp
//			AND co_color_exp = :as_color_exp;
//			
//		IF sqlca.sqlcode <> 0 THEN
//			ls_error = Sqlca.SqlErrText
//			Rollback;
//			MessageBox('Error1','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de buscar la talla de exportaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
//			Return -1
//		END IF
//	
//ELSE
	IF IsNull(as_ref_exp) OR IsNull(ai_fab_exp) OR  IsNull(as_color_exp) OR as_ref_exp = '0'  THEN
		SELECT co_fabrica_exp, co_linea_exp, co_ref_exp, color_exp, co_talla_exp
		  INTO :ai_fab_exp, :ai_linea_exp, :as_ref_exp, :as_color_exp, :as_talla_exp
		  FROM dt_caxpedidos
		 WHERE cs_ordenpd_pt = :al_op_estilo AND
				 nu_orden 		= :as_po AND
				 co_color 		= :al_colorpt AND
				 co_talla      = :ai_talla;
	END IF
	IF IsNull(as_talla_exp) OR as_talla_exp = '' THEN
		SELECT MAX(co_talla_exp)
		  INTO :as_talla_exp
		  FROM dt_caxpedidos
		 WHERE cs_ordenpd_pt = :al_op_estilo AND
				 nu_orden 		= :as_po AND
				 co_color 		= :al_colorpt AND
				 co_talla      = :ai_talla;
	END IF
	
	IF il_op_agrupada > 0 AND (IsNull(as_talla_exp) OR as_talla_exp = '' ) THEN
		SELECT MAX(co_talla_exp)
		  INTO :as_talla_exp
		  FROM dt_caxpedidos a, dt_op_agrupa_lib b
		 WHERE a.cs_ordenpd_pt = b.cs_ordenpd_pt
		      AND b.cs_liberacion = :il_liberacion
		      AND b.cs_ordenpd_pt_agru = :al_op_estilo 
//			  AND a.nu_orden 		= :as_po 
			  AND a.co_color 		= :al_colorpt 
			  AND	a.co_talla      	= :ai_talla;
	END IF
//END IF
 SELECT nvl(Max(cs_orden_talla),0)
   INTO :li_ordentalla
   FROM dt_talla_pdnmodulo
   WHERE simulacion 			= :li_simulacion AND
         co_fabrica 			= :li_fabplanta AND
         co_planta 			= :li_planta AND
         co_modulo 			= :li_modulo AND
         co_fabrica_exp 	= :ii_fabexp AND
         cs_liberacion 		= :il_liberacion AND
         po 					= :as_po AND
         nu_cut 				= :as_cut AND
         co_fabrica_pt 		= :ai_fabpt AND
         co_linea 			= :ai_lin AND
         co_referencia 		= :al_ref AND
         co_color_pt 		= :al_colorpt AND
         tono 					= :as_tono AND
         cs_particion 		= 1 AND
         co_talla 			= :ai_talla;
			
IF sqlca.sqlcode = -1 THEN
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar en dt_talla_pdnmodulo. '+ ls_error)
	Return -1
END IF


	//en este punto tenemos todos los datos a liberar, debemos verificar si en el pedido estan los datos como se usaran en la liberacion
	//esto porque se a presentado casos donde se libera y el pedido habia cambiado, solicitado por Saul Martinez
	//jcrm
	//febrero 11 de 2009
	IF luo_liberacion_x_proyeccion.of_pedido_vs_liberacion(ai_fabpt, ai_lin, al_ref, al_colorpt,ai_talla, ai_fab_exp, ai_linea_exp, as_ref_exp, as_color_exp, as_po, as_talla_exp) = -1 THEN
		IF il_op_agrupada > 0 THEN
			//en la agrupada no vamos a validar el pedido para ver como se comporta el proceso, esot porque se juntan varios pedidos en una referencia
		ELSE
			Rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Advertencia','El pedido fue modificado o ya no existe, verifique sus datos.')
			Return -1
		END IF
	END IF

	//verificar que el pedido que inserto en dt_pdnxmodulo si este en las tallas que esta insertando
	//esto porque se puede presentar en una misma op 2 pedidos con el mismo f-l-r-c en produccion y ventas y diferentes tallas
	//jorodrig  julio 10  09
	IF of_verificar_pedido_en_op(al_op_estilo,al_colorpt,ai_talla,as_po,as_color_exp,as_talla_exp) = 1 THEN  //correcto continua
	ELSE
		Rollback;	
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','La talla: '+string(ai_talla) + ' en el color: '+string(al_colorpt)+ ' Talla exp: '+as_talla_exp + ' No existe en el pedido: '+string(il_pedido_op))
		Return -1
	END If

IF li_ordentalla = 0 THEN
      INSERT INTO dt_talla_pdnmodulo(
			simulacion, 
			co_fabrica,
         co_planta, 
			co_modulo, 
			co_fabrica_exp, 
			cs_liberacion,
         po, 
			nu_cut, 
			co_fabrica_pt, 
			co_linea, 
			co_referencia,
         co_color_pt, 
			tono, 
			cs_particion, 
			co_talla,
         cs_orden_talla, 
			cs_prioridad, 
			ca_programada,
         ca_producida, 
			ca_pendiente, 
			co_est_prog_talla,
         fuente_dato, 
			fe_creacion, 
			fe_actualizacion, 
			usuario,
         instancia, 
			co_estado_merc, 
			ca_proyectada, 
			ca_actual,
         ca_numerada,
			proporcion)
      VALUES(:li_simulacion, 
			:li_fabplanta, 
			:li_planta,
         :li_modulo, 
			:ii_fabexp, 
			:il_liberacion, 
			:as_po,
         :as_cut, 
			:ai_fabpt, 
			:ai_lin,  
			:al_ref,
         :al_colorpt, 
			:as_tono, 
			1, 
			:ai_talla, 
			1,
         :ii_prioridad, 
			:al_unidades, 
			0, 
			:al_unidades,
         :li_estado_asigna, 
			:li_fuente_dato, 
			:ldt_fecha, 
			:ldt_fecha, 
			:as_usuario,
         :gstr_info_usuario.instancia, 
			Null, 
			0, 
			0, 
			0,
			:ai_proporcion);
			
	IF sqlca.sqlcode <> 0 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de insertar en dt_talla_pdnmodulo. '+ ls_error)
		Return -1
	END IF
			
//	IF al_cons_lib_duo > 0 THEN
		//buscar los datos de exportacion de t_criticas_cedi
		of_cargar_temporal_lib_duo(al_cons_lib_duo,ai_fabpt,ai_lin,al_ref,al_colorpt,ai_talla,al_unidades,ai_fab_exp, ai_linea_exp, as_ref_exp, as_color_exp, as_talla_exp, al_unid_prog )
//	END IF
			
ELSEIF li_ordentalla > 0 THEN
	 UPDATE dt_talla_pdnmodulo
      SET ca_programada = ca_programada + :al_unidades,
          ca_pendiente = ca_pendiente + :al_unidades
      WHERE simulacion 			= :li_simulacion AND
            co_fabrica 			= :li_fabplanta AND
            co_planta 			= :li_planta AND
            co_modulo 			= :li_modulo AND
            co_fabrica_exp 	= :ii_fabexp AND
            cs_liberacion 		= :il_liberacion AND
            po 					= :as_po AND
            nu_cut 				= :as_cut AND
            co_fabrica_pt 		= :ai_fabpt AND
            co_linea 			= :ai_lin AND
            co_referencia 		= :al_ref AND
            co_color_pt 		= :al_colorpt AND
            tono 					= :as_tono AND
            cs_particion 		= 1 AND
            co_talla 			= :ai_talla;
				
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_talla_pdnmodulo. '+ ls_error)
			Return -1
		END IF
		
//		IF al_cons_lib_duo > 0 THEN
		//buscar los datos de exportacion de t_criticas_cedi	
			of_cargar_temporal_lib_duo(al_cons_lib_duo,ai_fabpt,ai_lin,al_ref,al_colorpt,ai_talla,al_unidades,ai_fab_exp, ai_linea_exp, as_ref_exp, as_color_exp, as_talla_exp, al_unid_prog )
//		END IF
END IF

//IF is_tipo_orden = 'S' AND ii_inserto = 1 Then  //solo en liberacion make to stock se crea el pedido del pdp de confeccion  jorodrig   julio 9 - 08
//	of_buscar_fabrica_exp(ai_fabpt,ai_lin,al_ref,al_colorpt,ai_talla,ai_fab_exp)
//	If IsNull(ai_fab_exp) Then
//		ai_fab_exp = 2
//	End if
//	//insertamos las tallas en el pedido, en la tabla pedpend_exp, esto para el pdp de confeccion
//	li_result = of_insertar_talla_pedido_pdn(il_pedido_pdp, as_po, as_cut, ai_fabpt, ai_lin, al_ref, ai_consc_talla, ai_talla, &
//   	                          al_colorpt, ai_fab_exp, ai_linea_exp, as_ref_exp, as_color_exp, as_talla_exp, &
//      	                       al_unidades, idt_fe_despacho, il_cliente, ii_sucursal, ii_coleccion)           
//	If li_result = 1 Then
//	Else
//		Rollback;
//		Return -1
//	End If
//End if
//
Return 0
end function

public function long of_cargar_temporal_lib_duo (long al_cons_lib_duo, long ai_fab, long ai_linea, long al_ref, long al_color_pt, long ai_talla, long al_unidades, long ai_fab_exp, long ai_linea_exp, string as_ref_exp, string as_color_exp, string as_talla_exp, long al_unid_prog_op);Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM temp_unid_liberar_duo
 WHERE cs_lib_duo		= :al_cons_lib_duo   AND
       co_fabrica_exp= :ai_fab_exp			AND
		 co_linea_exp	= :ai_linea_exp		AND
		 co_ref_exp		= :as_ref_exp			AND
		 co_color_exp	= :as_color_exp		AND
		 co_talla_exp	= :as_talla_exp		AND
		 co_fabrica_pt	= :ai_fab  				AND
		 co_linea		= :ai_linea				AND
		 co_referencia	= :al_ref 				AND  
		 co_color_pt	= :al_color_pt			AND	   
       co_talla		= :ai_talla; 
		 
IF ll_count =  0 THEN		 
   INSERT INTO temp_unid_liberar_duo  
		( cs_lib_duo,
		  co_fabrica_exp,
		  co_linea_exp,
		  co_ref_exp,
		  co_color_exp,
		  co_talla_exp,
		  co_fabrica_pt,   
		  co_linea,   
		  co_referencia,   
		  co_color_pt,   
		  co_talla,   
		  ca_programada,   
		  usuario,
		  ca_pedida)  
    VALUES(:al_cons_lib_duo,
	 		:ai_fab_exp,
			:ai_linea_exp,
			:as_ref_exp,
			:as_color_exp,
			:as_talla_exp,
			:ai_fab,
			:ai_linea,	
			:al_ref,
			:al_color_pt,
			:ai_talla,
			:al_unidades,
			:gstr_info_usuario.codigo_usuario,
			:al_unid_prog_op);
ELSE
	UPDATE temp_unid_liberar_duo 
	   SET ca_programada = ca_programada + :al_unidades
	 WHERE cs_lib_duo		= :al_cons_lib_duo   AND
			 co_fabrica_exp= :ai_fab_exp			AND
			 co_linea_exp	= :ai_linea_exp		AND
			 co_ref_exp		= :as_ref_exp			AND
			 co_color_exp	= :as_color_exp		AND
			 co_talla_exp	= :as_talla_exp		AND
			 co_fabrica_pt	= :ai_fab  				AND
			 co_linea		= :ai_linea				AND
			 co_referencia	= :al_ref 				AND  
			 co_color_pt	= :al_color_pt			AND	   
			 co_talla		= :ai_talla; 
END IF
		 
Return 0

end function

private function long of_cargardtpdnxmodulo (long ai_fabpt, long ai_lin, long al_ref, long al_color, long al_unidades, string as_po, string as_cut, string as_tono, long al_ordenpd_pt, string as_usuario, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, long ai_tipo_lib, decimal adc_ancho);Long li_fabplanta, li_planta, li_modulo, li_estado_asigna, li_tipo_asigna, li_tipo_empate, li_simulacion,&
        li_tipoprog, li_asignacion, li_fab_prop, li_ano, li_semana, li_existe, li_ancho
Long ll_prioridad, ll_count, ll_pedido_pdp, ll_pedido_op
String ls_error
DateTime ldt_entrega, ldt_fecha
Date		ldt_fe_despacho

n_cts_constantes_tela luo_tela

li_ancho = Long(adc_ancho)



//si la linea es igual a cero voy buscar en dt_caxpedidos los datos de la referencia de ventas.
IF (ai_linea_exp = 0) OR IsNull(ai_linea_exp) THEN
	SELECT MAX(co_linea_exp)
	  INTO :ai_linea_exp
	  FROM dt_caxpedidos
	 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
	       co_color 		= :al_color AND
			 nu_orden 		= :as_po;
END IF		 
IF (as_ref_exp = '') OR IsNull(as_ref_exp) THEN	 
 	SELECT MAX(co_ref_exp)
	  INTO :as_ref_exp
	  FROM dt_caxpedidos
	 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
	       co_color 		= :al_color AND
			 nu_orden 		= :as_po;
END IF
IF (as_color_exp = '') OR IsNull(as_color_exp) THEN	 			 
  	SELECT MAX(color_exp)
	  INTO :as_color_exp
	  FROM dt_caxpedidos
	 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
	       co_color 		= :al_color AND
			 nu_orden 		= :as_po;
END IF
IF (ll_pedido_op = 0) OR IsNull(ll_pedido_op) THEN	  			 
  	SELECT MAX(pedido)
	  INTO :ll_pedido_op
	  FROM dt_caxpedidos
	 WHERE cs_ordenpd_pt = :al_ordenpd_pt AND
	       co_color 		= :al_color AND
			 nu_orden 		= :as_po AND
			 color_exp     = :as_color_exp;
END IF

IF ll_pedido_op= 0 OR IsNull(ll_pedido_op) THEN
	Rollback;
	MessageBox('Error','No se carg$$HEX2$$f3002000$$ENDHEX$$el numero del pedido, se cancela el proceso. '+ ls_error)
	Return -1
END IF

//----------------------------------carga constantes iniciales

//para cargar la orden de corte como de Pereira (99) o de Medellin (2), esto con el 
//fin de solo mostrar en la ventana de agrupaci$$HEX1$$f300$$ENDHEX$$n y programaci$$HEX1$$f300$$ENDHEX$$n las ordenes de corte
//de cada planta, y evitar da$$HEX1$$f100$$ENDHEX$$os y que los usuarios vean ordenes de corte que no son de ellos
//mayo 31 de 2007
//jcrm
IF gstr_info_usuario.co_planta_pro = 2 THEN
	li_fab_prop = 2
ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
	li_fab_prop = 99
END IF
//************************************** fin modificacion ***********************************

//se debe conocer la semana con la quedara registrada la orden de corte
//esto para permitir el seguimiento de las criticas
//jcrm
//diciembre 10 de 2007
//se determina el a$$HEX1$$f100$$ENDHEX$$o y semana a la que pertenece la fecha de hoy
li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
  
//con el a$$HEX1$$f100$$ENDHEX$$o se busca la maxima semana
li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')


SELECT numerico
  INTO :li_simulacion
  FROM m_constantes
 WHERE var_nombre = "SIMULACION";

IF sqlca.sqlcode <> 0 THEN 
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para la simulaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_fabplanta 
  FROM m_constantes
 WHERE var_nombre = "FABRICA PLANTA";

IF sqlca.sqlcode <> 0 THEN 
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para la fabrica-planta. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_planta
  FROM m_constantes
 WHERE var_nombre = "PLANTA LIBERACIONES";

IF sqlca.sqlcode <> 0 THEN 
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para la planta de la liberaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
	Return -1
END IF

SELECT numerico
  INTO :li_modulo
  FROM m_constantes
 WHERE var_nombre = "MODULO";
	
IF sqlca.sqlcode <> 0 THEN 
	ls_error = Sqlca.SqlErrText
	Rollback;
	MessageBox('Error','No fue posible localizar el valor para el m$$HEX1$$f300$$ENDHEX$$dulo. '+ ls_error)
	Return -1
END IF

SELECT MAX(fe_entrega)
  INTO :ldt_fe_despacho
  FROM pedpend_exp
 WHERE pedido 		= :ll_pedido_op
   AND nu_orden 	= :as_po
	AND co_fabrica	= :ai_fabpt
	AND co_linea	= :ai_lin
	AND co_referencia 	= :al_ref
	AND co_color	= :al_color;	
	
SELECT co_tipo_orden
  INTO :is_tipo_orden
  FROM peddig
 WHERE pedido = :ll_pedido_op; 
 
	
SELECT count(*)
  INTO :ll_count
  FROM dt_pdnxmodulo
 WHERE simulacion 		=:li_simulacion	AND
		 co_fabrica 		=:li_fabplanta	AND
		 co_planta			=:li_planta	AND
       co_modulo 			=:li_modulo	AND
		 co_fabrica_exp	=:ii_fabexp 	AND
		 cs_liberacion 	=:il_liberacion	AND
		 po					=:as_po	AND
		 nu_cut				=:as_cut	AND
       co_fabrica_pt 	=:ai_fabpt	AND
		 co_linea			=:ai_lin	AND
		 co_referencia		=:al_ref	AND
		 co_color_pt 		=:al_color	AND
		 tono 				=:as_tono	;
	
	IF sqlca.sqlcode <> 0 THEN 
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar en dt_pdnxmodulo. '+ ls_error)
		Return -1
	END IF


IF ll_count > 0 THEN //--------------------------actualizo las cantidades
   UPDATE dt_pdnxmodulo
	   SET ca_programada = ca_programada + :al_unidades,
		    ca_pendiente  = ca_pendiente + :al_unidades
	 WHERE simulacion 		=:li_simulacion	AND
		 	 co_fabrica 		=:li_fabplanta	AND
		 	 co_planta			=:li_planta	AND
       	 co_modulo 			=:li_modulo	AND
		 	 co_fabrica_exp	=:ii_fabexp 	AND
		 	 cs_liberacion 	=:il_liberacion	AND
		 	 po					=:as_po	AND
		 	 nu_cut				=:as_cut	AND
       	 co_fabrica_pt 	=:ai_fabpt	AND
		 	 co_linea			=:ai_lin	AND
		 	 co_referencia		=:al_ref	AND
		 	 co_color_pt 		=:al_color	AND
		 	 tono 				=:as_tono	;
	
	IF sqlca.sqlcode <> 0 THEN 
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar en dt_pdnxmodulo. '+ ls_error)
		Return -1
	END IF

ELSE//-----------------------------------------inserto en dt_pdnxmodulo

	//------------------------cargo las constantes necesarias para cargar dt_pdnxmodulo
	
	//si al_cons_lib_duo > 0 es porque es duo o conjunto de make to stock, para liberar
	//cantidades iguales, se coloca en estado cero para evitar que texografo trabaje la liberacion
	//sin haber liberado la totalidad de las referencias que componen el duo o conjunto
	//jcrm - jorodrig
	//agosto 25 de 2008
	IF al_cons_lib_duo > 0 THEN
		li_estado_asigna = 0
	ELSE
		SELECT numerico
		  INTO :li_estado_asigna
		  FROM m_constantes
		 WHERE var_nombre = "ESTADO ASIGNA";
		
		IF sqlca.sqlcode <> 0 THEN 
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','No fue posible localizar el valor para el estado de asignaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
			Return -1
		END IF
	END IF
	
	SELECT numerico
	  INTO :li_tipo_asigna
	  FROM m_constantes
	 WHERE var_nombre = "TIPO ASIGNA";
	
	IF sqlca.sqlcode <> 0 THEN 
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','No fue posible localizar el valor el tipo de asignaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
		Return -1
	END IF
	
	SELECT numerico
	  INTO :li_tipo_empate
	  FROM m_constantes
	 WHERE var_nombre = "TIPO EMPATE";
	 
	 IF sqlca.sqlcode <> 0 THEN 
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','No fue posible localizar el valor el tipo de empate. '+ ls_error)
		Return -1
	END IF
		 
	SELECT numerico
	  INTO :li_tipoprog
	  FROM m_constantes
	 WHERE var_nombre = "TIPO PROG";
	
	IF sqlca.sqlcode <> 0 THEN 
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','No fue posible localizar el valor el tipo de programaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
		Return -1
	END IF
	
	SELECT numerico
	  INTO :li_asignacion
	  FROM m_constantes
	 WHERE var_nombre = "ASIGNACION";
	
	IF sqlca.sqlcode <> 0 THEN 
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','No fue posible localizar el valor para la asignaci$$HEX1$$f300$$ENDHEX$$n. '+ ls_error)
		Return -1
	END IF

	
//	If is_tipo_orden = 'S' Then   //solo en pedidos make to stock se va a crear el pedido para el pdp de confeccion  jorodrig julio 9 - 08
		//cargar el pedido en peddig,  esto para las referencias de linea (make to stockt) 
		//y se crea por el pdp de confeccion, solicita Saul Martinez julio 8 - 08  jorodrig
//		ll_pedido_pdp = of_insertar_maestro_pdp(al_unidades, ldt_fe_despacho, 2, ai_fabpt, ai_lin, al_ref, il_liberacion, &
//										al_ordenpd_pt, as_po) 
//		IF ll_pedido_pdp = -1 OR IsNull(ll_pedido_pdp) THEN		
//			Rollback;
//			MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error cargando los datos del pedido inicial')
//			Return -1
//		END IF
//										
//	Else
		ll_pedido_pdp = ll_pedido_op				
		
		IF il_op_agrupada > 1 then
			li_tipo_empate = 5
	
		END IF
										

//	End if

	//se va a guardar en esta variable el pedido que se insert$$HEX2$$f3002000$$ENDHEX$$en dt_pdnxmodulo para
	//luego poder verificar que este pedido si tenga en pedpend_exp las tallas que esta insertando
	//esto porque el numero del pedido se busco en la op sin la talla
	//jorodrig   julio 10 - 09
	il_pedido_op = ll_pedido_pdp
	
	SELECT Nvl(Max(cs_prioridad), 0) + 1
	  INTO :ii_prioridad
	  FROM dt_pdnxmodulo
	 WHERE simulacion = :li_simulacion AND
			 co_fabrica = :li_fabplanta AND
			 co_planta 	= :li_planta AND
			 co_modulo 	= :li_modulo;
	
	ldt_fecha = f_fecha_servidor()  
	  
	 IF ISNull(il_op_agrupada) THEN
		il_op_agrupada = 0
	 END IF
	  
	INSERT INTO dt_pdnxmodulo(
			simulacion, 
			co_fabrica, 
			co_planta,
			co_modulo, 
			co_fabrica_exp, 
			cs_liberacion, 
			po, 
			nu_cut,
			co_fabrica_pt, 
			co_linea, 
			co_referencia, 
			co_color_pt, 
			tono,
			cs_prioridad, 
			ca_programada, 
			ca_producida, 
			ca_pendiente,
			co_estado_asigna, 
			co_curva, 
			fe_inicio_prog, 
			fe_fin_prog,
			fe_requerida_desp, 
			ca_minutos_std, 
			co_tipo_asignacion,
			ca_personasxmod, 
			cod_tur, 
			minutos_jornada,
			ind_cambio_estilo, 
			ca_unid_base_dia, 
			orige_uni_base_dia,
			tipo_empate, 
			unidades_empate, 
			metodo_programa,
			fuente_dato, 
			fe_creacion, 
			fe_actualizacion, 
			usuario,
			instancia, 
			fe_entra_pdn, 
			tipo_fe_prog, 
			fe_lim_prog,
			fe_desp_programada, 
			indicativo_base, 
			ca_base_dia_prod,
			ca_base_dia_prog, 
			ca_a_programar, 
			co_estado_merc,
			ca_proyectada, 
			ca_actual, 
			ca_numerada, 
			fe_fogueo,
			fe_trabajo, 
			cs_asignacion, 
			cs_particion, 
			cs_ordenpd_pt,
			co_fabrica_prop,
			co_fabrica_corte,
			semana,
			co_linea_exp,
			co_ref_exp,
			co_color_exp,
			cs_unir_oc,
			pedido)
		VALUES(:li_simulacion, 
			:li_fabplanta, 
			:li_planta, 
			:li_modulo,
			:ii_fabexp, 
			:il_liberacion, 
			:as_po, 
			'0',//:as_cut, 
			:ai_fabpt,
			:ai_lin, 
			:al_ref, 
			:al_color, 
			:as_tono, 
			:ii_prioridad,
			:al_unidades, 
			0, 
			:al_unidades, 
			:li_estado_asigna, 
			:li_ancho, 
			:ldt_fecha,
			:ldt_fecha, 
			:ldt_fe_despacho, 
			0, 
			:li_tipo_asigna, 
			0, 
			0, 
			0, 
			0, 
			:il_op_agrupada, 
			0,
			:li_tipo_empate, 
			0, 
			0, 
			0, 
			:ldt_fecha, 
			:ldt_fecha, 
			:as_usuario, 
			:gstr_info_usuario.instancia,
			Null, 
			:li_tipoprog, 
			Null, 
			:ldt_fecha, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0,
			Null,
			Null, 
			:li_asignacion, 
			1, 
			:al_ordenpd_pt,
			:gstr_info_usuario.co_planta_pro,
			:gstr_info_usuario.co_planta_pro,
			:li_semana,
			:ai_linea_exp,
			:as_ref_exp,
			:as_color_exp,
			:al_cons_lib_duo,
			:ll_pedido_pdp);
	
	IF sqlca.sqlcode <> 0 THEN
		ls_error = Sqlca.SqlErrText
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de guardar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_pdnxmodulo. '+ ls_error)
		Return -1
	END IF
	
END IF

il_linea_exp = ai_linea_exp
is_ref_exp = as_ref_exp
is_color_exp = as_color_exp

//verificar que la po si exista
SELECT COUNT(*)
  INTO :li_existe
  FROM dt_pedidosxorden
 WHERE cs_ordenpd_pt = :al_ordenpd_pt
   AND nu_orden = :as_po;
IF li_existe = 0 THEN
	Rollback;
	MessageBox('Advertencia','La P.O. no existe en la orden de produccion, Orden de Pdccion: '+ string(al_ordenpd_pt) + ' P.O. : ' + as_po)
	Return -1
END IF

Return 0
end function

public function integer of_cargar_ops_agrupadas (string as_usuario, long al_liberacion);Datetime	ldt_fecha
Integer	ll_result, ll_fila, li_prioridad
Long		ll_ordenpd_pt_agru, ll_ordenpd_pt, ld_ca_programar
String		ls_error

DataStore lds_tb_temp_op_agrupar

ldt_fecha = f_fecha_servidor()

//
lds_tb_temp_op_agrupar = Create DataStore
lds_tb_temp_op_agrupar.DataObject = 'd_tb_temp_op_agrupar'
lds_tb_temp_op_agrupar.SetTransObject(sqlca)



ll_result = lds_tb_temp_op_agrupar.Retrieve(as_usuario)
//
For ll_fila = 1 To ll_result
	ll_ordenpd_pt_agru 	= lds_tb_temp_op_agrupar.GetItemNumber(ll_fila,'cs_ordenpd_pt_agru')
	ll_ordenpd_pt 			= lds_tb_temp_op_agrupar.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ld_ca_programar 		= lds_tb_temp_op_agrupar.GetITemNumber(ll_fila,'ca_programar')
	li_prioridad 				= lds_tb_temp_op_agrupar.GetItemNumber(ll_fila,'prioridad')
	IF ld_ca_programar > 0 THEN
//		
//		//-------------------------el registro no existe se debe ingresar el registro en dt_escalasxtela
		INSERT INTO dt_op_agrupa_lib  
				( cs_liberacion,   
				  cs_ordenpd_pt_agru,   
				  cs_ordenpd_pt,   
				  ca_programada,   
				  prioridad,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia )  
	  VALUES (:al_liberacion,   
				  :ll_ordenpd_pt_agru,   
				  :ll_ordenpd_pt,   
				  :ld_ca_programar,   
				  :li_prioridad,   
				  :ldt_fecha,   
				  :ldt_fecha,   
				  :as_usuario,   
				  :gstr_info_usuario.instancia )  ;
				  
		IF sqlca.sqlcode <> 0 THEN
			ls_error = Sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de guardar la informaci$$HEX1$$f300$$ENDHEX$$n en dt_op_agrupa_lib. '+ ls_error)
			Return -1
		END IF
	END IF

Next
//
Destroy lds_tb_temp_op_agrupar
Return 0
end function

public function long of_generar_liberacion (string as_usuario, long al_ordenpd_pt, string as_po, long al_color, decimal adc_ancho, long al_tanda, long ai_tipo, long ai_linea_exp, string as_ref_exp, string as_color_exp, long al_cons_lib_duo, long ai_fab_exp, long al_op_agrupada);String ls_usuario, ls_tono, ls_po, ls_cut, ls_error, as_talla_exp
Long ll_result, ll_fila, ll_unidades, ll_ref, ll_ordenpd, ll_mod, ll_reftel,ll_modant,&
     ll_unidades_real, ll_valor,ll_unid_prog, ll_color, ll_colorte, ll_lib_anulada, ll_tipo_negocio, ll_reg
Long li_fab, li_lin, li_talla, li_raya, li_caract,  li_diametro, li_propor,&
        li_cons_tallas,li_modelos_ficha, li_modelos_liberar
Decimal{5} ldc_consumo, ldc_ancho
DataStore lds_ref, lds_total_modelos_ficha
uo_dsbase lds_reposo_lib_anulada, lds_rollos_reposados, lds_simulacion
n_cts_constantes luo_constantes 
luo_constantes = Create n_cts_constantes
DateTime ldtm_servidor
Integer	li_existe
//ai_tipo = 1 se esta liberando por pedido (make to order)
//ai_tipo = 2 se libera criticas  (make to stock)
//jcrm
//febrero 26 de 2008


////Solo   vamos a dejar generar la liberacion a los usuarios de texografo
////marzo 7 - 08
//IF (gstr_info_usuario.codigo_perfil = 16) OR (gstr_info_usuario.codigo_perfil = 13) OR (gstr_info_usuario.codigo_perfil = 6) THEN
//	//Esta autorizado para liberar
//ELSE
//	MessageBox('Advertencia','No Esta autorizado para Generar liberaciones')
//	Return -1
//END IF
//
ldtm_servidor = f_fecha_servidor()

ll_tipo_negocio = luo_constantes.of_consultar_numerico("REPOSO_TIPONEGOCIO")
IF ll_tipo_negocio = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer el tipo negocio para la simulacion.',StopSign!)
	Return -1
END IF

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando Datos Liberacion..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro) 


lds_ref = Create DataStore
lds_ref.DataObject = 'ds_temp_modelos_ref'
lds_ref.SetTransObject(sqlca)

//------------------------ se debe establecer el usuario due$$HEX1$$f100$$ENDHEX$$o de la O.P. ---------------------------------------
//ls_usuario = of_usuarioOp(al_ordenpd_pt) 
ls_usuario = gstr_info_usuario.codigo_usuario
If ls_usuario = '' Then
	CLOSE(w_retroalimentacion)
	RETURN -1
END IF


//---------------------------- se debe establecer el consecutivo de la liberacion -----------------------------------
//--------------------------------- primero determinamos la fabrica_exp ---------------------------------------------
SELECT numerico
  INTO :ii_fabexp
  FROM m_constantes
 WHERE var_nombre = 'FABRICA LIBERACIONES' ;

IF ii_fabexp = -1 THEN
	ls_error = SQLCA.SQLErrText
	Rollback;
	CLOSE(w_retroalimentacion)
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la fabrica de la liberaci$$HEX1$$f300$$ENDHEX$$n '+ ls_error)
   Return -1
END IF

//------------------------------------ con la fabrica_exp ya puedo conocer el consecutivo de liberacion -------------
IF of_establecerCsLiberacion() <> 0 THEN
	CLOSE(w_retroalimentacion)
	RETURN -1
END IF

//-------------------------- se carga la tabla h_liberar_escalas ----------------------------------------------------
IF of_cargarHLiberarEscalas(ls_usuario,ai_tipo) = -1 THEN
	CLOSE(w_retroalimentacion)
	RETURN -1
END IF

IF al_op_agrupada > 0 THEN
	//cargar las ordenes agrupadas, esto para el proyecto de agrupacion de pedidos
	IF of_cargar_ops_agrupadas(as_usuario,il_liberacion) = -1 Then
		CLOSE(w_retroalimentacion)
		RETURN -1
	END IF
END IF
//a partir de este momento se deben generar los datos para la liberaci$$HEX1$$f300$$ENDHEX$$n, para esto es necesario
//cargar un datastore que contenga todos los referencias a liberar con sus unidades

ll_result = lds_ref.Retrieve(as_usuario,al_ordenpd_pt,as_po,al_color,adc_ancho,al_tanda)
ll_modant = lds_ref.GetItemNumber(1,'co_modelo')
li_cons_tallas = 1
ii_inserto = 0
ib_carga_reposo = False
il_op_agrupada = al_op_agrupada
FOR ll_fila = 1 TO ll_result
	//traigo los datos necesarios para cargar las demas tablas de la liberaci$$HEX1$$f300$$ENDHEX$$n
	li_fab 		= lds_ref.GetItemNumber(ll_fila,'co_fabrica')
	li_lin 		= lds_ref.GetItemNumber(ll_fila,'co_linea')
	ll_color 	= lds_ref.GetITemNumber(ll_fila,'co_color')
	ll_unidades = lds_ref.GetItemNumber(ll_fila,'unid_real_liberar')
	ll_ref 		= lds_ref.GetItemNumber(ll_fila,'co_referencia')
	ls_tono 		= lds_ref.GetItemString(ll_fila,'tono')
	ls_po 		= lds_ref.GetItemString(ll_fila,'po')
	ls_cut 		= '0'//lds_ref.GetItemString(ll_fila,'nu_cut')
	ll_ordenpd  = lds_ref.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ldc_consumo = lds_ref.GetItemDecimal(ll_fila,'consumo')
	li_talla		= lds_ref.GetItemNumber(ll_fila,'co_talla')
	li_raya		= lds_ref.GetItemNumber(ll_fila,'raya')
	ldc_ancho   = lds_ref.GetItemNumber(ll_fila,'ancho')
	ll_mod		= lds_ref.GetItemNumber(ll_fila,'co_modelo')
	ll_reftel 	= lds_ref.GetItemNumber(ll_fila,'co_reftel')
	li_caract	= lds_ref.GetItemNumber(ll_fila,'co_caract')
	li_diametro = lds_ref.GetItemNumber(ll_fila,'diametro')
	ll_colorte	= lds_ref.GetItemNumber(ll_fila,'co_color_te')
	ll_unid_prog = lds_ref.GetItemNumber(ll_fila,'unid_prog')
	
//	IF ai_tipo = 2 THEN    //cuando la liberacion es de criticas se toma la proporcion
//		li_propor =  lds_ref.GetItemNumber(ll_fila,'proporcion')
//	ELSE
//		li_propor = 1
//	END IF
// se coloca en comentario lo anterior y se pone que siempre cargue la proporcion
	li_propor =  lds_ref.GetItemNumber(ll_fila,'proporcion')
	
	//-------------------------- se carga la tabla dt_libera_estilos ----------------------------------------------------
	IF ll_modant = ll_mod THEN
		IF of_cargarDtLiberaEstilos(li_fab,li_lin,ll_color,ll_unidades,ll_ref,ls_tono,ls_po,ls_cut,ll_ordenpd,ldc_consumo,ls_usuario) = -1 THEN
			CLOSE(w_retroalimentacion)
			RETURN -1
		END IF
	END IF
	//-------------------------- se carga la tabla dt_pdnxmodulo --------------------------------------------------------
	IF ll_modant = ll_mod THEN
		IF of_cargarDtPdnxmodulo(li_fab,li_lin,ll_ref,ll_color,ll_unidades,ls_po,ls_cut,ls_tono,ll_ordenpd,ls_usuario,ai_linea_exp,as_ref_exp,as_color_exp,al_cons_lib_duo,ai_tipo, adc_ancho) = -1 THEN
			CLOSE(w_retroalimentacion)
			RETURN -1
		END IF
	END IF
	//-------------------------- se carga la tabla dt_talla_pdnmodulon --------------------------------------------------
	IF ll_modant = ll_mod THEN
		IF of_cargarDtTallaPdnmodulo(li_fab,li_lin,ll_ref,ll_color,li_talla,ll_unidades,ls_po,ls_cut,ls_tono,li_propor,ls_usuario,al_ordenpd_pt,ai_tipo,li_cons_tallas,al_cons_lib_duo,as_color_exp,ai_linea_exp,as_ref_exp,as_talla_exp,ai_fab_exp,ll_unid_prog) = -1 THEN
			CLOSE(w_retroalimentacion)
			RETURN -1
		END IF
		li_cons_tallas = li_cons_tallas + 1
	END IF
	//-------------------------- se carga la tabla dt_telaxmodelo_lib ---------------------------------------------------
	IF of_cargardttelaxmodelolib(li_fab,li_lin,ll_ref,ll_color,ll_unidades,li_talla,1,ls_po,ls_cut,li_raya,&
										  ldc_ancho,ll_mod,ll_reftel,li_caract,li_diametro,ll_colorte,ls_tono,ldc_consumo,ll_ordenpd,ls_usuario) = -1 THEN
	  	CLOSE(w_retroalimentacion)
		RETURN -1
	END IF
	//-------------------------- se carga la tabla dt_escalasxtela ------------------------------------------------------
   IF of_cargarDtEscalasxTela(li_fab,li_lin,ll_ref,ll_color,ls_tono,ll_mod,li_fab,ll_reftel,li_caract,li_diametro,&
										ll_colorte,li_talla,ll_unidades,1,ls_po,ls_cut,ldc_consumo,ll_ordenpd,ldc_ancho,ls_usuario) = -1 THEN
		CLOSE(w_retroalimentacion)
		RETURN -1
	END IF
	//-------------------------- se cargan las tablas de la orden de producci$$HEX1$$f300$$ENDHEX$$n -----------------------------------------
	IF ll_modant = ll_mod THEN
		IF of_cargarOrdenProduccion(ll_ordenpd,li_talla,ll_color,ll_unidades,ls_po) = -1 THEN
			CLOSE(w_retroalimentacion)
			RETURN -1
		END IF
	END IF
NEXT

//ya solo falta generar la informaci$$HEX1$$f300$$ENDHEX$$n relacionada con los rollos
//-------------------------- se carga la tabla dt_rollos_libera -----------------------------------------------------
IF of_cargarDtRollosLibera(as_usuario,al_ordenpd_pt,as_po,al_color,adc_ancho,al_tanda,ls_usuario,ai_tipo) = -1 Then
	CLOSE(w_retroalimentacion)
	RETURN -1
END IF

//esta sucediendo que cuando se genera la liberacion no estan quedando todos los modelos en dt_rollos_libera
//por eso se debe controlar que los modelos de la ficha sean iguales a los modelos liberados
//jcrm
//noviembre 11 de 2008
lds_total_modelos_ficha = Create DataStore
lds_total_modelos_ficha.DataObject = 'ds_total_modelos_ficha'
lds_total_modelos_ficha.SetTransObject(sqlca)

li_modelos_ficha = lds_total_modelos_ficha.Retrieve(li_fab,li_lin,ll_ref,ll_color)

SELECT count(distinct co_modelo)
  INTO :li_modelos_liberar
  FROM dt_rollos_libera
 WHERE cs_liberacion = :il_liberacion;


IF li_modelos_ficha <> li_modelos_liberar THEN
	CLOSE(w_retroalimentacion)
	Rollback;
	MessageBox('Error','El total de modelos a liberar es diferente al total de modelos de la ficha, Verifique en el boton Unid x Modelo.')
	RETURN -1
END IF




//colocar en cero las unidades reales a liberar en temp_modelos_ref, para que 
//cuando refresquemos la datawindows, no muestre otra vez las mismas unidades
//a liberar.
FOR ll_fila = 1 TO ll_result	
	ll_unidades_real= lds_ref.GetItemNumber(ll_fila,'unid_real_liberar')
	ll_unidades = lds_ref.GetItemNumber(ll_fila,'unid_liberar')
	
	ll_valor = ll_unidades - ll_unidades_real
	IF ll_valor < 0 Then ll_valor = 0
	
	lds_ref.SetItem(ll_fila,'unid_liberar',ll_valor)
	lds_ref.SetItem(ll_fila,'unid_real_liberar',0)
	lds_ref.SetItem(ll_fila,'sw_carga',0)
Next
lds_ref.Update()

//ya se actualizaron los datos de la liberaci$$HEX1$$f300$$ENDHEX$$n se debe acceptar la transacci$$HEX1$$f300$$ENDHEX$$n
COMMIT;


//Verificar si le creo reposo a esta liberaci$$HEX1$$f300$$ENDHEX$$n 
If ib_carga_reposo Then
	//Si la liberaci$$HEX1$$f300$$ENDHEX$$n actual se carg$$HEX2$$f3002000$$ENDHEX$$a reposo hace lo siguiente, Tomar CS_ORDENPD_PT, CO_COLOR_PT de la liberaci$$HEX1$$f300$$ENDHEX$$n actual 
	//y buscar si existe una liberaci$$HEX1$$f300$$ENDHEX$$n anulada de la misma OP y con fechas de reposo realizadas as$$HEX1$$ed00$$ENDHEX$$:
	lds_reposo_lib_anulada = Create uo_dsbase
	lds_reposo_lib_anulada.DataObject = 'd_gr_reposo_liberacion_anulada'
	lds_reposo_lib_anulada.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	lds_rollos_reposados = Create uo_dsbase
	lds_rollos_reposados.DataObject = 'd_gr_rollos_reposados'
	lds_rollos_reposados.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	lds_simulacion = Create uo_dsbase
	lds_simulacion.DataObject = 'd_gr_dt_simulacion_reposo'
	lds_simulacion.SetTransObject(sqlca)
	
	If lds_reposo_lib_anulada.Retrieve(al_ordenpd_pt,al_color,il_liberacion) > 0 Then //Se adiciona el numero de la liberacion para traer exactamente el numero de la liberacion anterior 
		// Si retorna mayor que 0 entonces vamos a buscar los rollos de la tela que tiene el reposo 
		//y mirar si alguno esta en la liberaci$$HEX1$$f300$$ENDHEX$$n actual
		ll_lib_anulada = lds_reposo_lib_anulada.GetItemNumber(1,'al_liberacion_anulada')
		If Isnull(ll_lib_anulada) Then ll_lib_anulada = 0
		If ll_lib_anulada > 0 Then
			
			If lds_rollos_reposados.Retrieve(il_liberacion,ll_lib_anulada) > 0 Then
				If lds_rollos_reposados.GetItemNumber(1,'rollos_reposados') > 0 Then
					//Preguntar al usuario si ya la liberaci$$HEX1$$f300$$ENDHEX$$n termino el tiempo de reposo
					IF MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "$$HEX1$$bf00$$ENDHEX$$ya se realiz$$HEX2$$f3002000$$ENDHEX$$el proceso de reposo a los rollos?", Question!, YesNo!, 2) = 1 THEN
						//Actualiza en la la liberaci$$HEX1$$f300$$ENDHEX$$n actual, en dt_simulacion el tiempo de reposo 
						//(fecha inicial y fecha final) con la fecha actual y el tiempo_reposo (tiempo est$$HEX1$$e100$$ENDHEX$$ndar) en cero
						//consulta los registros de simulacion para la liberacion
						If lds_simulacion.Retrieve(il_liberacion, ll_tipo_negocio) < 0 Then
							Rollback;
							MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar simulacion para la liberacion')
						End if
						
						For ll_reg = 1 to lds_simulacion.RowCount()
							lds_simulacion.SetItem(ll_reg,'fecha_inicio_bck', ldtm_servidor )
							lds_simulacion.SetItem(ll_reg,'fecha_fin_bck', ldtm_servidor )
							lds_simulacion.SetItem(ll_reg,'tiempo_estandar', 0 )
						Next
						
						//actualiza simulacion
						If lds_simulacion.Of_update() < 0 Then
							Rollback;
							MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar la tabla simulacion.')
						End if
						
						COMMIT;
						IF SQLCA.SQLCode = -1 THEN
							MessageBox("Error","No se pudo hacer los cambios para el tiempo de reposo(commit)" )	

						END IF
					END IF
				End if
			End if
			
		End if
	End if 
	
End if


CLOSE(w_retroalimentacion)
MessageBox('Exito','Se genero la liberaci$$HEX1$$f300$$ENDHEX$$n No. '+String(il_liberacion))

IF il_op_agrupada > 0 THEN
	SELECT COUNT(*)
	   INTO :li_existe
	   FROM dt_op_agrupa_lib_talla
	WHERE cs_liberacion  = 	:il_liberacion;
	
	IF li_existe = 0 THEN
	MessageBox('Advertencia','La liberacion aparece como agrupada pero no calculo las cantidades por OP,verificar esta OP: '+String(il_op_agrupada))
	END IF
	
END IF

Destroy lds_ref

RETURN 0
end function

on n_cts_liberacion_semiautomatica.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_liberacion_semiautomatica.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

