HA$PBExportHeader$n_cst_modulo.sru
forward
global type n_cst_modulo from nonvisualobject
end type
end forward

global type n_cst_modulo from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_validarmodulocontrakamban (long al_ordencorte, string as_modulo)
public function long of_descripcion_modulo (string as_modulo, long ai_tipoprod, long ai_centro, long ai_subcentro, ref string as_de_modulo, ref long ai_centro_fisico)
end prototypes

public function long of_validarmodulocontrakamban (long al_ordencorte, string as_modulo);Long li_preparacion, li_tipo, li_centro, li_fabrica, li_planta, li_fabact, li_planact, li_despachos
Long ll_count, ll_modulo, ll_modact
n_cst_modulo lpo_modulo
n_cts_constantes lpo_constantes

lpo_constantes = Create n_cts_constantes

li_fabact = Long(Mid(as_modulo,1,2))
li_planact = Long(Mid(as_modulo,3,2))
ll_modact = Long(Mid(as_modulo,5))

//se identifica el subcentro, centro y tipo producto
li_preparacion = lpo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
li_despachos   = lpo_constantes.of_consultar_numerico('SUBCENTRO FIN CORTE') 

IF li_preparacion = -1 THEN
	MessageBox('Error 1','No fue posible establecer el subcentro.')
	Return -1  
END IF

li_tipo = lpo_constantes.of_consultar_numerico('PRENDAS')
IF li_tipo = -1 THEN
	Return -1
END IF

li_centro = lpo_constantes.of_consultar_numerico('CENTRO CORTE')
IF li_centro = -1 THEN
	Return -1
END IF


//se verifica si existe fecha final en el subcentro de preparacion
SELECT distinct co_fabrica_planta, co_planta, co_modulo
  INTO :li_fabrica, :li_planta, :ll_modulo
  FROM dt_kamban_corte
 WHERE cs_orden_corte 	= :al_ordencorte AND
 		 co_tipoprod 		= :li_tipo AND
		 co_centro_pdn 	= :li_centro AND 
		 co_subcentro_pdn = :li_preparacion AND
		 fe_final 			is  null AND
		 fe_inicial       is not null;
  
IF sqlca.sqlcode = -1 THEN
	MessageBox('Error de base de datos','No fue posible establecer el subcentro ' + sqlca.sqlerrtext)
	Return -1
ELSE
	IF SQLCA.SQLCode = 100 THEN
		//se debe conocer si se trata de segundo loteo
		SELECT distinct co_fabrica_planta, co_planta, co_modulo
		  INTO :li_fabrica, :li_planta, :ll_modulo
		  FROM dt_kamban_corte
		 WHERE cs_orden_corte 	= :al_ordencorte AND
				 co_tipoprod 		= :li_tipo AND
				 co_centro_pdn 	= :li_centro AND 
				 co_subcentro_pdn = :li_despachos AND
				 fe_final 			is  null AND
				 fe_inicial       is not null;
		
		IF SQLCA.SQLCode = 0 THEN
		ELSE
			MessageBox('Advertencia','La orden de corte no se encuentra en preparacion')
			Return -1
		END IF
	ELSE
		//IF ll_modulo = ll_modact AND li_fabrica = li_fabact AND li_planta = li_planact THEN
		IF li_fabrica = li_fabact AND li_planta = li_planact THEN
			Return 0
		ELSE
			MessageBox('Error','La O.C. fue cargada en el m$$HEX1$$f300$$ENDHEX$$dulo: '+String(ll_modulo)+' y lo estan leyendo en el m$$HEX1$$f300$$ENDHEX$$dulo: '+String(ll_modact))
			Return -1
		END IF
	END IF
END IF

//IF ll_count > 0 THEN
//	Return 0
//ELSE
//	//se exije que el modulo de loteo sea al mismo que se le cargo
//	SELECT Max(co_modulo), Max(co_fabrica_planta), Max(co_planta)
//  	  INTO :ll_modulo, :li_fabrica, :li_planta
//     FROM dt_kamban_corte
//    WHERE cs_orden_corte 	= :al_ordencorte;
//
// 	IF sqlca.sqlcode = -1 THEN
//		MessageBox('Error 3','No fue posible establecer el subcentro')
//		Return -1
//	END IF
//
// 
//	IF ll_modulo = ll_modact AND li_fabrica = li_fabact AND li_planta = li_planact THEN
//		Return 0
//	ELSE
//		MessageBox('Error','La O.C. fue cargada en el m$$HEX1$$f300$$ENDHEX$$dulo: '+String(ll_modulo)+' y lo estan leyendo en el m$$HEX1$$f300$$ENDHEX$$dulo: '+String(ll_modact))
//		Return -1
//	END IF
//END IF
//


end function

public function long of_descripcion_modulo (string as_modulo, long ai_tipoprod, long ai_centro, long ai_subcentro, ref string as_de_modulo, ref long ai_centro_fisico);Long li_fab, li_planta
Long ll_modulo


li_fab 	 =	Long(Mid(as_modulo,1,2))
li_planta = Long(Mid(as_modulo,3,2))
ll_modulo = Long(Mid(as_modulo,5))

//se busca la descripcion del modulo
SELECT de_modulo, co_centro_cc
  INTO :as_de_modulo, :ai_centro_fisico
  FROM m_modulos
 WHERE co_fabrica 			= :li_fab AND
 		 co_planta  			= :li_planta AND
		 co_modulo  			= :ll_modulo AND
		 co_tipoprod 			= :ai_tipoprod AND
		 co_centro_pdn 		= :ai_centro AND
		 co_subcentro_pdn 	= :ai_subcentro;
		 
IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la descricpi$$HEX1$$f300$$ENDHEX$$n del modulo. '+ Sqlca.SqlErrText)
	Return -1
End if

Return 0
end function

on n_cst_modulo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_modulo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

