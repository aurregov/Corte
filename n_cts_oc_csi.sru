HA$PBExportHeader$n_cts_oc_csi.sru
forward
global type n_cts_oc_csi from nonvisualobject
end type
end forward

global type n_cts_oc_csi from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_validar_oc (long al_oc, ref string as_mensaje)
public function long of_cargar_observacion (long al_oc, string as_observacion, ref string as_mensaje)
public function long of_cargar_estado_csi (long al_oc, long ai_estado, ref string as_mensaje)
public function long of_traer_estado_actual (long al_oc, ref string as_mensaje)
end prototypes

public function long of_validar_oc (long al_oc, ref string as_mensaje);//metodo para determinar si una O.C. existe en dt_pdnxmodulo
Long ll_count

SELECT count(*)
  INTO :ll_count
  FROM dt_pdnxmodulo
 WHERE cs_asignacion = :al_oc AND
 		 co_estado_asigna <> 28;
		 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = 'No fue posible validar la O.C. ERROR: '+sqlca.sqlerrtext
	Return -1
END IF

IF ll_count > 0 THEN
	Return 0
ELSE
	as_mensaje = 'O.C. invalida, o en estado anulada.'
	REturn -1
END IF


end function

public function long of_cargar_observacion (long al_oc, string as_observacion, ref string as_mensaje);//metodo para grabar la observacion del csi en h_ordenes_corte
//jcrm
//abril 15 de 2009

UPDATE h_ordenes_corte
   SET observacion = :as_observacion
 WHERE cs_orden_corte = :al_oc;	

IF sqlca.sqlcode = -1 THEN
	as_mensaje = 'Error al ingresar la observacion, ERROR: '+sqlca.sqlerrtext
	Return -1
END IF

Return 0
end function

public function long of_cargar_estado_csi (long al_oc, long ai_estado, ref string as_mensaje);//metodo para actualizar el estado de la O.C. en estado csi
//jcrm
//abril 15 de 2009
DateTime ldt_fecha

ldt_fecha = f_fecha_servidor()


UPDATE dt_pdnxmodulo
   SET co_estado_asigna = :ai_estado,
		 fe_actualizacion = :ldt_fecha,
		 usuario				= :gstr_info_usuario.codigo_usuario
 WHERE cs_asignacion = :al_oc;
 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = 'No fue posible actualizar el estado de la O.C. ERROR: '+sqlca.sqlerrtext
	Return -1
END IF


Return 0
end function

public function long of_traer_estado_actual (long al_oc, ref string as_mensaje);//metodo para traer el estado actuol de una O.C. de h_ordenes_corte
//jcrm
//abril 15 de 2009
Long li_estado

SELECT co_estado
  INTO :li_estado
  FROM h_ordenes_corte
 WHERE cs_orden_corte = :al_oc;


IF li_estado = 0 OR IsNull(li_estado) THEN
	Return 9
END IF
 
Return li_estado
end function

on n_cts_oc_csi.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_oc_csi.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

