HA$PBExportHeader$n_cts_tela_sustituta.sru
forward
global type n_cts_tela_sustituta from nonvisualobject
end type
end forward

global type n_cts_tela_sustituta from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_trae_documento_kardex (long ai_concepto)
public function long of_traer_caract_ruta (long ai_concepto, long ai_origen, long ai_destino, long ai_caract_act)
public function long of_grabar_h_kardex (long ai_concepto, long al_documento, long ai_origen, long ai_destino)
public function long of_cambio_kardex_rollo (long al_rollo, long al_color_nuevo, long al_reftel_nuevo, long al_op_nuevo)
public function long of_grabar_dt_kardex (long ai_fabrica, long ai_concepto, long al_documento, long ll_pos, long ll_rollo, decimal ad_kg, decimal ad_mts, long ai_origen, long ai_destino, long ai_maq_tej, long ai_proveedor, string as_lote_hilaza, long al_unidades, long ai_responsable, long al_op_cambia, long ai_tipo)
end prototypes

public function long of_trae_documento_kardex (long ai_concepto);LONG	ll_documento

SELECT cs_concepto
  INTO :ll_documento
  FROM m_consecutivos
 WHERE co_fabrica  = 2
	AND co_concepto = :ai_concepto;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al buscar el numero del documento')
	RETURN 0
END IF

ll_documento = ll_documento + 1 
UPDATE m_consecutivos
SET cs_concepto = :ll_documento
WHERE co_fabrica  = 2
  AND co_concepto = :ai_concepto;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al actualizar el numero del documento')
	RETURN 0
END IF

RETURN ll_documento
end function

public function long of_traer_caract_ruta (long ai_concepto, long ai_origen, long ai_destino, long ai_caract_act);Long	li_co_caract_nue
STRING	ls_error

SELECT unique a.co_caract_nue
  INTO :li_co_caract_nue
  FROM m_rutas a
 WHERE a.co_concepto  = :ai_concepto
   AND a.origen 		 = :ai_origen
   AND a.destino 		 = :ai_destino
   AND a.co_caract    = :ai_caract_act;
IF sqlca.sqlcode = -1 THEN
	Return -1
END IF

return li_co_caract_nue
end function

public function long of_grabar_h_kardex (long ai_concepto, long al_documento, long ai_origen, long ai_destino);STRING	ls_usuario, ls_instancia, ls_error
DATE		ldt_fecha
TIME		lt_hora_act	
DATETIME	ldt_ano_mes
Long	li_existe

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
ldt_fecha = DATE(f_fecha_servidor())
lt_hora_act = TIME(f_fecha_servidor())

SELECT ano_mes
  INTO :ldt_ano_mes
  FROM cf_user_prod
 WHERE usuario = :ls_usuario
   and co_fabrica = 2;
 IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al buscar el a$$HEX1$$f100$$ENDHEX$$o_mes')
	RETURN 0
END IF

//vefiricar en h_kardex  que no este insertado el documento en el concepto
SELECT COUNT(*)
  INTO :li_existe
  FROM h_kardex
 WHERE co_fabrica = 2
   AND co_concepto = :ai_concepto
	AND documento = :al_documento;
IF li_existe >  0 THEN
	Rollback;
	MessageBox('Error','El documento ya existe')
	Return -1
END IF

INSERT INTO h_kardex ( co_fabrica,
                       co_concepto,
                       documento,
                       documento_ext,
                       origen,
                       destino,
                       fe_kardex,
                       hora,
                       ano_mes,
							  usuario, instancia,
                       co_fab_propietario )
               VALUES (2,
					        :ai_concepto,
                       :al_documento,
                       :al_documento,
                       :ai_origen,
                       :ai_destino,
                       :ldt_fecha,
                       :lt_hora_act,
                       :ldt_ano_mes,
                       :ls_usuario,
                       :ls_instancia,
                       2);
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de Grabar los datos en encabezado kardex. '+ls_error)
	Return -1
END IF	

Return 1
end function

public function long of_cambio_kardex_rollo (long al_rollo, long al_color_nuevo, long al_reftel_nuevo, long al_op_nuevo);//esta funcion trae el rollo, el nuevo color y la nueva referencia de tela que va tener el rollo
//para poder ser utilizado en la liberaci$$HEX1$$f300$$ENDHEX$$n esto segun la tela sustituta creada en la ficha
//jcrm
//octubre 8 de 2007

LONG		ll_documento, ll_co_reftel, ll_ordenpd_pt, ll_lote, ll_co_color_rollo
Long	li_concepto, li_destino, li_co_caract,  li_diametro, li_centro, li_pos, li_fabrica, li_origen
Long	li_graba
STRING	ls_mensaje, ls_ordenbp
DECIMAL	ld_kg, ld_mts

li_concepto = 52
li_destino  = 99
li_fabrica  = 2

SELECT ca_kg,  co_reftel_act, co_caract_act, co_color_act, ca_mt,
       diametro_act, cs_orden_pr_act,  lote, co_Centro
  INTO :ld_kg, :ll_co_reftel, :li_co_caract, :ll_co_color_rollo, :ld_mts, 
       :li_diametro, :ll_ordenpd_pt,   :ll_lote, :li_centro
  FROM m_rollo
 WHERE cs_rollo = :al_rollo;
 IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
	Rollback;
	Messagebox('Error','Error buscar los datos del rollo, Error: ' + ls_mensaje)
	RETURN -1
END IF
//
IF ll_co_color_rollo = al_color_nuevo AND ll_co_reftel = al_reftel_nuevo THEN   //el rollo ya tiene el color y la referencia de tela al que se va a armar se sale sin hacer cambios, continua el proceso
	MessageBox('Error','Colores y telas iguales, no hay cambio posible a realizar.')
	Return -1
END IF

//Graba la salida del color viejo en  h_kardex
ll_documento = of_trae_documento_kardex(li_concepto)
IF ll_documento > 0 THEN
ELSE
	Rollback;
	MessageBox('Error','Error bucando el documento consecutivo de salida')
	Return -1
END IF

li_graba= of_grabar_h_kardex(li_concepto, ll_documento, li_centro, li_destino)
IF li_graba = 1 THEN
ELSE
	Rollback;
	MessageBox('Error','Error Cargando  el encabezado de salida en el kardex (h_kardex)')
	Return -1
END IF

li_graba = of_grabar_dt_kardex(li_fabrica, li_concepto, ll_documento, li_pos, al_rollo, ld_kg, ld_mts, li_centro, li_destino, 0, 0, '', 0, 0, 0,2)
IF li_graba = 1 THEN
ELSE
	Rollback;
	MessageBox('Error','Error Cargando  el detalle de salida en el kardex (dt_kardex)')
	Return -1
END IF
 
 ls_ordenbp = 'Sst_te' + trim(string(ll_co_reftel)) + 'Col'+trim(string(ll_co_color_rollo))
 
UPDATE m_rollo  SET (co_centro,co_color_act,co_reftel_act,cs_orden_pr_act, cs_ordenbp, co_planeador) 
                 =  (:li_destino,:al_color_nuevo,:al_reftel_nuevo,:al_op_nuevo, :ls_ordenbp, 66)
WHERE cs_rollo = :al_rollo;
IF sqlca.sqlcode = -1 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
	Rollback;
   Messagebox('Error','Error Actualizando el nuevo color en el rollo, Error: ' + ls_mensaje)
	Return -1
END IF
 
//Graba la entrada del nuevo color
li_concepto = 19
li_origen  	= 99
ll_documento = of_trae_documento_kardex(li_concepto)
IF ll_documento > 0 THEN
ELSE
	Rollback;
	MessageBox('Error','Error bucando el documento consecutivo de salida')
	Return -1
END IF

li_graba= of_grabar_h_kardex(li_concepto, ll_documento, li_origen, li_centro )
IF li_graba = 1 THEN
ELSE
	Rollback;
	MessageBox('Error','Error Cargando  el encabezado de entrada en el kardex (h_kardex)')
	Return -1
END IF

li_graba = of_grabar_dt_kardex(li_fabrica, li_concepto, ll_documento, li_pos, al_rollo, ld_kg, ld_mts, li_origen, li_centro, 0, 0, '', 0, 0, 0, 3)
IF li_graba = 1 THEN
ELSE
	Rollback;
	MessageBox('Error','Error Cargando  el detalle de entrada en el kardex (dt_kardex)')
	Return -1
END IF


Return 1
end function

public function long of_grabar_dt_kardex (long ai_fabrica, long ai_concepto, long al_documento, long ll_pos, long ll_rollo, decimal ad_kg, decimal ad_mts, long ai_origen, long ai_destino, long ai_maq_tej, long ai_proveedor, string as_lote_hilaza, long al_unidades, long ai_responsable, long al_op_cambia, long ai_tipo);//se pasa el tipo para saber como se actualiza el rollo  cuando es 4 se esta haciendo un ajuste al rollo porque gano peso
//no se validan los centros origen y destino
DATETIME	ldt_fe_act
DATE		ld_fe_ingreso
STRING	ls_usuario, ls_error, ls_ubicacion, ls_instancia
LONG		ll_reftel, ll_lote, ll_op
LONG	ll_caract, ll_diametro, ll_color_te, ll_co_caract_nue, ll_planta, ll_centro, 	ll_estado_rollo

ls_usuario     = gstr_info_usuario.codigo_usuario
ls_instancia   = gstr_info_usuario.instancia
ld_fe_ingreso  = DATE(f_fecha_servidor())
ldt_fe_act 		= DATETIME(f_fecha_servidor())

SELECT co_reftel_act, co_caract_act, diametro_act, co_color_act, ubicacion, lote, cs_orden_pr_act, co_planta, co_centro, co_estado_rollo
  INTO :ll_reftel, :ll_caract, :ll_diametro, :ll_color_te, :ls_ubicacion, :ll_lote, :ll_op, :ll_planta, :ll_centro, :ll_estado_rollo
  FROM m_rollo
 WHERE cs_rollo = :ll_rollo; 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error buscando los datos del rollo. '+ls_error)
	Return -1
END IF

IF (ll_centro = ai_destino) AND (ai_tipo <> 4)  THEN
	Rollback;
	MessageBox('Error','Esta Digitando Rollos que ya entraron al centro: ' + string(ai_destino) + ' Rollo Numero: ' + string(ll_rollo) )
	Return -1
END IF

IF  (ll_centro = ai_origen) OR (ai_tipo = 4) THEN
ELSE
	IF (ll_centro = 0) AND (ai_destino = 6) THEN
	ELSE
		Rollback;
		MessageBox('Error','Esta  Moviendo desde un centro en el que no esta el rollo: ' + string(ai_destino) + ' Rollo Numero: ' + string(ll_rollo) )
		Return -1
	END IF
END IF

ll_co_caract_nue = of_traer_caract_ruta(ai_concepto, ai_origen, ai_destino, ll_caract)
IF ll_co_caract_nue = -1 THEN
	Rollback;
	MessageBox('Error','Se produjo un error buscando la caracteristica final de la tela')
	Return -1
END IF

IF al_op_cambia <> ll_op AND al_op_cambia <> 0  THEN
	ll_op = al_op_cambia
	ll_estado_rollo = 2
ELSE
	ll_estado_rollo = 1
END IF

IF ai_tipo = 1 THEN
	UPDATE m_rollo
		SET ( co_caract_act, co_centro, ca_kg, ca_mt, co_maquina_tej, fe_actualizacion, usuario,
				co_proveedor, lote_hilaza, co_maquina_tej, ca_unidades, co_estado_rollo, cs_orden_pr_act)
		  = ( :ll_co_caract_nue, :ai_destino, :ad_kg, :ad_mts, :ai_maq_tej, :ldt_fe_act, :ls_usuario,
				:ai_proveedor, :as_lote_hilaza, :ai_maq_tej, :al_unidades, :ll_estado_rollo, :ll_op)
	WHERE m_rollo.cs_rollo = :ll_rollo; 
	IF sqlca.sqlcode = -1 THEN
		ls_error = sqlca.sqlerrtext
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de Grabar los datos del rollo. '+ls_error)
		Return -1
	END IF
ELSE
	IF (ai_tipo = 3) OR (ai_tipo = 2) THEN
		UPDATE m_rollo
			SET ( co_caract_act, co_centro, ca_kg, ca_mt,  fe_actualizacion, usuario, co_estado_rollo)
			  = ( :ll_co_caract_nue, :ai_destino, :ad_kg, :ad_mts, :ldt_fe_act, :ls_usuario, 2)
		WHERE m_rollo.cs_rollo = :ll_rollo; 
		IF sqlca.sqlcode = -1 THEN
			ls_error = sqlca.sqlerrtext
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de Grabar los datos del rollo. '+ls_error)
			Return -1
		END IF
	ELSE
	   IF (ai_tipo = 4) THEN
			UPDATE m_rollo
			SET ( co_caract_act, co_centro, ca_kg, ca_mt,  fe_actualizacion, usuario, co_estado_rollo)
			  = ( :ll_co_caract_nue, :ai_destino, (ca_kg + :ad_kg), (ca_mt + :ad_mts), :ldt_fe_act, :ls_usuario, 2)
			WHERE m_rollo.cs_rollo = :ll_rollo; 
			IF sqlca.sqlcode = -1 THEN
				ls_error = sqlca.sqlerrtext
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de Grabar los datos del rollo. '+ls_error)
				Return -1
			END IF
		ELSE
			IF ai_tipo = 5 THEN
				UPDATE m_rollo
				SET ( co_caract_act, co_centro, co_planeador,  fe_actualizacion, usuario)
				  = ( :ll_co_caract_nue, :ai_destino, 66,  :ldt_fe_act, :ls_usuario)
				WHERE m_rollo.cs_rollo = :ll_rollo; 
				IF sqlca.sqlcode = -1 THEN
					ls_error = sqlca.sqlerrtext
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de Grabar los datos del rollo. '+ls_error)
					Return -1
				END IF
			END IF
		END IF
	END IF
END IF

INSERT INTO dt_kardex  (
               co_fabrica ,
               co_concepto ,
               documento ,
               item ,
               cs_rollo ,
               cs_ordenpd ,
               co_reftel ,
               co_caract ,
               co_color ,
               diametro ,
               ubicacion ,
               ca_kardex_kg ,
               ca_kardex_mt ,
               pr_kardex ,
               co_recurso ,
               co_caractn ,
               lote ,
               fe_ingreso ,
               usuario_upd ,
               fe_actualizacion ,
               usuario ,
               instancia,
		 	      co_fab_propietario )
       VALUES (:ai_fabrica,
					:ai_concepto,
					:al_documento,
					:ll_pos,
					:ll_rollo,
					:ll_op,
					:ll_reftel,
					:ll_caract,
					:ll_color_te,
					:ll_diametro,
					0,	
					:ad_kg,
				   :ad_mts,
               0,
					:ai_maq_tej,
					:ll_co_caract_nue,
               :ll_lote,
					:ld_fe_ingreso,
					:ai_responsable,
					:ldt_fe_act, 
               :ls_usuario,
               :ls_instancia,
               2 );
	

IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.sqlerrtext
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de Grabar los datos del detalle en el kardex. '+ls_error)
	Return -1
END IF

Return 1


end function

on n_cts_tela_sustituta.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_tela_sustituta.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

