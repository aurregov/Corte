HA$PBExportHeader$n_cst_mercada_tela.sru
forward
global type n_cst_mercada_tela from nonvisualobject
end type
end forward

global type n_cst_mercada_tela from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_determinar_maquina (long ai_num_maquina, ref string as_mensaje)
public function long of_determinar_oc (ref long al_pedido, ref string as_mensaje, long al_maquina)
public function long of_estado_mercada (long al_oc, long ai_estado, ref string as_mensaje)
public function long of_act_ubicacion_rollo (long al_rollo, string as_ubicacion, ref string as_mensaje)
end prototypes

public function long of_determinar_maquina (long ai_num_maquina, ref string as_mensaje);//metodo para sacar el codigo de la maquina partiendo del num_maquina
//jcrm - jorodrig
//febrero 26 de 2009
Long ll_maquina

SELECT DISTINCT co_maquina
  INTO :ll_maquina
  FROM m_maquinas
 WHERE num_maquina 		= :ai_num_maquina AND
 		 co_tipo_maquina 	= 7 AND
		 co_centro_pdn 	= 1 AND
		 co_subcentro_pdn = 7	;	
 
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF

Return ll_maquina
end function

public function long of_determinar_oc (ref long al_pedido, ref string as_mensaje, long al_maquina);//metodo para establecer la orden de corte con menor fecha en el pdp y con estado por mercar
//jcrm - jorodrig
//febrero 26 de 2009
DateTime ldt_fecha

//se establece la siguiente orden de corte que este programada en el pdp y con estado de mercada
//"POR MERCAR" (h_mercada.co_estado_mercada = 1)

SELECT min(a.fe_inicio_progs), a.pedido
  INTO :ldt_fecha, :al_pedido
  FROM dt_simulacion a, h_mercada h
 WHERE a.co_maquina 			= :al_maquina AND
  		 a.co_tipo_negocio 	= 7 AND
		 a.co_estado 			= 'A'	AND
		 h.cs_orden_corte		= a.pedido AND
		 h.co_estado_mercada	= 1
GROUP BY 2;
 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje =  'No O.C. en PDP y rollos partidos, ERROR: '+String(sqlca.sqlcode)+sqlca.sqlerrtext
	Return -1
END IF

Return al_pedido
end function

public function long of_estado_mercada (long al_oc, long ai_estado, ref string as_mensaje);//metodo para modificar el estado de la mercada
/* 1 POR MERCAR
   10 MERCANDO
	4 MERCADA*/
//jcrm - jorodrig
//febrero 27 de 2009

UPDATE h_mercada
   SET co_estado_mercada = :ai_estado
 WHERE cs_orden_corte = :al_oc;
  
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = String(sqlca.sqlcode)+sqlca.sqlerrtext
	Return -1
END IF

Return 0	
end function

public function long of_act_ubicacion_rollo (long al_rollo, string as_ubicacion, ref string as_mensaje);//metodo para actualizar la ubicacion de los rollos que estan siendo mercados
//jcrm - jorodrig
//marzo 2 de 2009

UPDATE m_rollo
   SET ubicacion = :as_ubicacion
 WHERE cs_rollo = :al_rollo;
 
IF sqlca.sqlcode <> 0 THEN
	as_mensaje = String(sqlca.sqlcode)+sqlca.sqlerrtext
	Return -1
END IF

Return 0
end function

on n_cst_mercada_tela.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_mercada_tela.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

