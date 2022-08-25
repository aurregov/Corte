HA$PBExportHeader$w_actualizar_oc_liquidadas.srw
forward
global type w_actualizar_oc_liquidadas from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_oc_liquidadas from w_base_buscar_interactivo
end type
global w_actualizar_oc_liquidadas w_actualizar_oc_liquidadas

on w_actualizar_oc_liquidadas.create
call super::create
end on

on w_actualizar_oc_liquidadas.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_oc_liquidadas
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_oc_liquidadas
end type

event pb_buscar::clicked;call super::clicked;LONG		ll_cs_oc,ll_rayas,ll_rayas_liquidadas


//ciclo para recorrer oc
 DECLARE cur_oc CURSOR FOR  
  SELECT h_ordenes_corte.cs_orden_corte  
    FROM h_ordenes_corte  
   WHERE h_ordenes_corte.cs_orden_corte > 0   and
	      h_ordenes_corte.co_estado=5;
	
 open cur_oc;
 
 fetch cur_oc into : ll_cs_oc;
 
 do while sqlca.sqlcode=0
	ll_rayas_liquidadas=0
	ll_rayas=0
	//suma de rayas
	  SELECT count(*)  
    INTO :ll_rayas  
    FROM dt_unidadesxtrazo  
   WHERE dt_unidadesxtrazo.cs_orden_corte = :ll_cs_oc   ;

	
	//suma de rayas liquidadas
	  SELECT count(*)  
    INTO :ll_rayas_liquidadas  
    FROM dt_unidadesxtrazo  
   WHERE dt_unidadesxtrazo.cs_orden_corte = :ll_cs_oc   
	and   dt_unidadesxtrazo.co_estado=6;
	
	//comparacion
	IF ll_rayas_liquidadas = ll_rayas AND ll_rayas_liquidadas> 0 AND ll_rayas>0 THEN
		//update
		UPDATE h_ordenes_corte  
			  SET co_estado = 6  
			WHERE h_ordenes_corte.cs_orden_corte = :ll_cs_oc;
		IF SQLCA.SQLCODE=-1 THEN
			MESSAGEBOX("ERROR BD","NO UPD")
			RETURN
		ELSE 
			
		END IF
	

	ELSE
	END IF
	
	
	
	fetch cur_oc into : ll_cs_oc;
	
loop

close cur_oc;

commit;

end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_oc_liquidadas
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_oc_liquidadas
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_oc_liquidadas
end type

