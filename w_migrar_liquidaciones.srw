HA$PBExportHeader$w_migrar_liquidaciones.srw
forward
global type w_migrar_liquidaciones from w_base_buscar_interactivo
end type
end forward

global type w_migrar_liquidaciones from w_base_buscar_interactivo
end type
global w_migrar_liquidaciones w_migrar_liquidaciones

on w_migrar_liquidaciones.create
call super::create
end on

on w_migrar_liquidaciones.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_migrar_liquidaciones
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_migrar_liquidaciones
end type

event pb_buscar::clicked;call super::clicked;LONG			ll_cs_orden_corte,ll_ca_prog_liq, ll_ca_liquidadas,ll_ca_loteadas,ll_oc_esp,ll_cs_rollo
LONG			li_primero,ll_cs_orden_corte_ant
Long		li_cs_agrupacion,li_cs_base_trazos,li_cs_liquidacion_ant,li_cs_trazo,li_cs_seccion,li_cs_pdn
Long		li_co_talla, li_cs_talla, li_capas,  li_paquetes,li_agrup_esp,li_base_esp,li_esp
Long		li_co_estado,li_tipo_parcial, li_tipo_detalle , li_cs_sec_rollo
Long		li_cs_agrupacion_ant,li_cs_base_trazos_ant,li_cs_espacio_ant,li_cs_liquidacion
STRING		ls_usuario,  ls_instancia 
DATETIME		ldt_fe_creacion,   ldt_fe_actualizacion  
DECIMAL		ld_ca_cortados,ld_ca_devueltos,ld_ca_remanentes,ld_ca_imperfectos,ld_ca_faltantes
DECIMAL		ld_ca_excedentes,ld_ca_empates,ld_ca_consumido,ld_ca_otros
datetime		ldt_fe_liquidacion



//barre dt_liq_unidades,creando dt_liquida_eapcio y crea en dt_liq_rollos para espacio 1
//  -----  colocar ca_otros = -0.1 para saber que fue de la migraci$$HEX1$$f300$$ENDHEX$$n.

//primero busca en dt_liq_unixespacio los encabezados para cargar dt_liquidaxespacio

declare cur_esp cursor for
select unique cs_orden_corte,cs_agrupacion,cs_base_trazos,cs_trazo,cs_liquidacion
from   dt_liq_unidades
where  cs_orden_corte > 0;

open cur_esp;

li_primero=1
ll_cs_orden_corte_ant=0
li_cs_agrupacion_ant=0
li_cs_base_trazos_ant=0
li_cs_liquidacion_ant=0

fetch cur_esp into :ll_cs_orden_corte,:li_cs_agrupacion,:li_cs_base_trazos,:li_cs_trazo,:li_cs_liquidacion;


do while sqlca.sqlcode=0 
	
	ld_ca_cortados		=0
   ld_ca_devueltos	=0   	           
	ld_ca_remanentes  =0 		           
	ld_ca_imperfectos	=0
   ld_ca_faltantes	=0  	           
	ld_ca_excedentes  =0 		           
	ld_ca_empates		=0
   ld_ca_consumido	=0  	           
	ld_ca_otros			=0
	
	//busca en dt_liquida_espacio
	SELECT dt_liquida_espacio.co_estado,      dt_liquida_espacio.tipo_parcial,   dt_liquida_espacio.tipo_detalle,   
         dt_liquida_espacio.ca_cortados,     dt_liquida_espacio.ca_devueltos,   dt_liquida_espacio.ca_remanentes,   
         dt_liquida_espacio.ca_imperfectos,  dt_liquida_espacio.ca_faltantes,   dt_liquida_espacio.ca_excedentes,   
         dt_liquida_espacio.ca_empates,      dt_liquida_espacio.ca_consumido,   dt_liquida_espacio.ca_otros,   
         dt_liquida_espacio.fe_liquidacion,  dt_liquida_espacio.fe_creacion,    dt_liquida_espacio.fe_actualizacion,   
         dt_liquida_espacio.usuario,         dt_liquida_espacio.instancia  
    INTO :li_co_estado,   				         :li_tipo_parcial,				        :li_tipo_detalle,
         :ld_ca_cortados,				         :ld_ca_devueltos,			           :ld_ca_remanentes,
         :ld_ca_imperfectos,  		         :ld_ca_faltantes,			           :ld_ca_excedentes,
         :ld_ca_empates,				         :ld_ca_consumido,			           :ld_ca_otros,
			:ldt_fe_liquidacion,			         :ldt_fe_creacion,				        :ldt_fe_actualizacion,
         :ls_usuario,					         :ls_instancia
    FROM dt_liquida_espacio  
   WHERE ( dt_liquida_espacio.cs_orden_corte =:ll_cs_orden_corte  ) 	AND  
         ( dt_liquida_espacio.cs_agrupacion 	=:li_cs_agrupacion ) 	AND  
         ( dt_liquida_espacio.cs_base_trazos =:li_cs_base_trazos ) 	AND 
			( dt_liquida_espacio.cs_liquidacion =:li_cs_liquidacion )   ;
			
	if sqlca.sqlcode=-1 then
		messagebox("Error bd","no pudo buscar en dt_liquida_espacio")
		return
	else
	end if
	
	if ll_cs_orden_corte=ll_cs_orden_corte_ant and &
	   li_cs_agrupacion =li_cs_agrupacion_ant  and &
		li_cs_base_trazos=li_cs_base_trazos_ant and &
		li_cs_liquidacion=li_cs_liquidacion_ant then
		
		li_primero=0
		
	else
		
		li_primero=1
		
		ll_cs_orden_corte_ant 	=ll_cs_orden_corte
	   li_cs_agrupacion_ant 	=li_cs_agrupacion
		li_cs_base_trazos_ant 	=li_cs_base_trazos
		li_cs_liquidacion_ant 	=li_cs_liquidacion
		
		
		
	end if
	
	if li_primero=0 then
		ld_ca_cortados		=0
      ld_ca_devueltos	=0   	           
		ld_ca_remanentes  =0 		           
		ld_ca_imperfectos	=0
      ld_ca_faltantes	=0  	           
		ld_ca_excedentes  =0 		           
		ld_ca_empates		=0
      ld_ca_consumido	=0  	           
		ld_ca_otros			=0
	else
	end if
	
	//insertar en dt_liquidaxespacio
	INSERT INTO dt_liquidaxespacio  
         ( cs_orden_corte,cs_agrupacion, 		cs_base_trazos,   						cs_trazo,   
           cs_liquidacion,   			         co_estado,   				            tipo_parcial,   
           tipo_detalle,                     ca_cortados,              				ca_devueltos,   
           ca_remanentes,             			ca_imperfectos,              			ca_faltantes,   
           ca_excedentes,   			         ca_empates,   				            ca_consumido,   
           ca_otros,   				            fe_liquidacion,   		            fe_creacion,   
           fe_actualizacion,   		         usuario,   				               instancia )  
  VALUES ( :ll_cs_orden_corte,              :li_cs_agrupacion,   		           	:li_cs_base_trazos,   
           :li_cs_trazo,   				     :li_cs_liquidacion,     					:li_co_estado,   
           :li_tipo_parcial,   	           :li_tipo_detalle,   		           :ld_ca_cortados,   
           :ld_ca_devueltos,   	           :ld_ca_remanentes,   		           :ld_ca_imperfectos,   
           :ld_ca_faltantes,   	           :ld_ca_excedentes,   		           :ld_ca_empates,   
           :ld_ca_consumido,   	           :ld_ca_otros,   			           :ldt_fe_liquidacion,   
           :ldt_fe_creacion,   	           :ldt_fe_actualizacion,              :ls_usuario,   
           :ls_instancia )  ;
	if sqlca.sqlcode=-1 then
		messagebox("Error bd","no pudo ins en dt_liquidaxespacio")
		return
	else
	end if
	//busca en dt_liq_unidades ciclo por espacio
	DECLARE cur_tallas CURSOR FOR  
  SELECT dt_liq_unidades.cs_seccion,   
         dt_liq_unidades.cs_pdn,   
         dt_liq_unidades.co_talla,   
         dt_liq_unidades.cs_talla,   
         dt_liq_unidades.ca_prog_liq,   
         dt_liq_unidades.capas,   
         dt_liq_unidades.paquetes,   
         dt_liq_unidades.ca_liquidadas,   
         dt_liq_unidades.ca_loteadas,   
         dt_liq_unidades.fe_creacion,   
         dt_liq_unidades.fe_actualizacion,   
         dt_liq_unidades.usuario,   
         dt_liq_unidades.instancia  
    FROM dt_liq_unidades  
   WHERE ( dt_liq_unidades.cs_orden_corte = :ll_cs_orden_corte ) AND  
         ( dt_liq_unidades.cs_agrupacion = :li_cs_agrupacion ) AND  
         ( dt_liq_unidades.cs_base_trazos = :li_cs_base_trazos ) AND  
         ( dt_liq_unidades.cs_liquidacion = :li_cs_liquidacion ) AND  
         ( dt_liq_unidades.cs_trazo = :li_cs_trazo )              ;
	open cur_tallas;
	
	fetch cur_tallas into 	:li_cs_seccion, 			:li_cs_pdn,   				:li_co_talla,   
         						:li_cs_talla,        	:ll_ca_prog_liq,  		:li_capas,   
									:li_paquetes,   			:ll_ca_liquidadas,   	:ll_ca_loteadas,   
									:ldt_fe_creacion,   		:ldt_fe_actualizacion,  :ls_usuario,   
									:ls_instancia ;
									
									
			
	do while sqlca.sqlcode=0
		
		
		//inserta en dt_liq_unidades	
		INSERT INTO dt_liq_unixespacio  
         ( cs_orden_corte,   
           cs_agrupacion,   
           cs_base_trazos,   
           cs_trazo,   
           cs_liquidacion,   
           cs_seccion,   
           cs_pdn,   
           co_talla,   
           cs_talla,   
           ca_prog_liq,   
           capas,   
           paquetes,   
           ca_liquidadas,   
           ca_loteadas,   
           fe_creacion,   
           fe_actualizacion,   
           usuario,   
           instancia )  
  VALUES ( :ll_cs_orden_corte,   
           :li_cs_agrupacion,   
           :li_cs_base_trazos,   
           :li_cs_trazo,   
           :li_cs_liquidacion,   
           :li_cs_seccion,   
           :li_cs_pdn,   
           :li_co_talla,   
           :li_cs_talla,   
           :ll_ca_prog_liq,   
           :li_capas,   
           :li_paquetes,   
           :ll_ca_liquidadas,   
           :ll_ca_loteadas,   
           :ldt_fe_creacion,   
           :ldt_fe_actualizacion,   
           :ls_usuario,   
           :ls_instancia )  ;
			  
		if sqlca.sqlcode=-1 then
			messagebox("error bd","no ins tallas")
			return
		else
		end if
		
		fetch cur_tallas into 	:li_cs_seccion, 			:li_cs_pdn,   				:li_co_talla,   
         						:li_cs_talla,        	:ll_ca_prog_liq,  		:li_capas,   
									:li_paquetes,   			:ll_ca_liquidadas,   	:ll_ca_loteadas,   
									:ldt_fe_creacion,   		:ldt_fe_actualizacion,  :ls_usuario,   
									:ls_instancia ;
		
	loop
	
	close cur_tallas;

	
	
	if li_primero=1 then
	
		//busca en dt_liq_rollos ciclo
		DECLARE cur_rollos cursor for
		  SELECT dt_liq_rollos.cs_rollo,   
				dt_liq_rollos.ca_cortados,   
				dt_liq_rollos.ca_devueltos,   
				dt_liq_rollos.ca_remanente,   
				dt_liq_rollos.ca_imperfectos,   
				dt_liq_rollos.ca_faltantes,   
				dt_liq_rollos.ca_excedentes,   
				dt_liq_rollos.ca_empates,   
				dt_liq_rollos.ca_consumido,   
				dt_liq_rollos.ca_otros,   
				dt_liq_rollos.fe_creacion,   
				dt_liq_rollos.fe_actualizacion,   
				dt_liq_rollos.usuario,   
				dt_liq_rollos.instancia  
	
		 FROM dt_liq_rollos  
		WHERE ( dt_liq_rollos.cs_orden_corte = :ll_cs_orden_corte ) AND  
				( dt_liq_rollos.cs_agrupacion = :li_cs_agrupacion ) AND  
				( dt_liq_rollos.cs_base_trazos = :li_cs_base_trazos ) AND  
			  
				( dt_liq_rollos.cs_liquidacion = :li_cs_liquidacion )   ;
				
		open cur_rollos;
		
		fetch cur_rollos     INTO :ll_cs_rollo,   
				
				:ld_ca_cortados,   
				:ld_ca_devueltos,   
				:ld_ca_remanentes,   
				:ld_ca_imperfectos,   
				:ld_ca_faltantes,   
				:ld_ca_excedentes,   
				:ld_ca_empates,   
				:ld_ca_consumido,   
				:ld_ca_otros,   
				:ldt_fe_creacion,   
				:ldt_fe_actualizacion,   
				:ls_usuario,   
				:ls_instancia  ;
				
		li_cs_sec_rollo=0
				
		do while sqlca.sqlcode=0
			
			li_cs_sec_rollo=li_cs_sec_rollo +1
			
			//inserta en dt_liq_rollos
			  INSERT INTO dt_liq_rolxespacio  
				( cs_orden_corte,   
				  cs_agrupacion,   
				  cs_base_trazos,   
				  cs_trazo,   
				  cs_liquidacion,   
				  cs_rollo,   
				  cs_sec_rollo,   
				  ca_cortados,   
				  ca_devueltos,   
				  ca_remanente,   
				  ca_imperfectos,   
				  ca_faltantes,   
				  ca_excedentes,   
				  ca_empates,   
				  ca_consumido,   
				  ca_otros,   
				  fe_creacion,   
				  fe_actualizacion,   
				  usuario,   
				  instancia )  
	  VALUES ( :ll_cs_orden_corte,   
				  :li_cs_agrupacion,   
				  :li_cs_base_trazos,   
				  :li_cs_trazo,   
				  :li_cs_liquidacion,   
				  :ll_cs_rollo,   
				  :li_cs_sec_rollo,   
				  :ld_ca_cortados,   
				  :ld_ca_devueltos,   
				  :ld_ca_remanentes,   
				  :ld_ca_imperfectos,   
				  :ld_ca_faltantes,   
				  :ld_ca_excedentes,   
				  :ld_ca_empates,   
				  :ld_ca_consumido,   
				  :ld_ca_otros,   
				  :ldt_fe_creacion,   
				  :ldt_fe_actualizacion,   
				  :ls_usuario,   
				  :ls_instancia )  ;
	
			
			fetch cur_rollos     INTO :ll_cs_rollo,   
				
				:ld_ca_cortados,   
				:ld_ca_devueltos,   
				:ld_ca_remanentes,   
				:ld_ca_imperfectos,   
				:ld_ca_faltantes,   
				:ld_ca_excedentes,   
				:ld_ca_empates,   
				:ld_ca_consumido,   
				:ld_ca_otros,   
				:ldt_fe_creacion,   
				:ldt_fe_actualizacion,   
				:ls_usuario,   
				:ls_instancia  ;
			if sqlca.sqlcode=-1 then
				messagebox("Error bd","no pudo ins en dt_liq_rolxespacio")
				return
			else
			end if
				
		loop
		li_cs_sec_rollo=0
		close cur_rollos;
	else
	end if
	
	
	
	fetch cur_esp into :ll_cs_orden_corte,:li_cs_agrupacion,:li_cs_base_trazos,:li_cs_trazo,:li_cs_liquidacion;
	
loop

close cur_esp;



//declare cur_uniliq cursor for
//select *
//from   dt_liq_unidades
//where  cs_orden_corte > 0;
//
//open cur_uniliq;
//
//fetch  cur_uniliq INTO :ll_cs_orden_corte,
//         :li_cs_agrupacion,   
//         :li_cs_base_trazos,   
//         :li_cs_liquidacion,   
//         :li_cs_trazo,   
//         :li_cs_seccion,   
//         :li_cs_pdn,   
//         :li_co_talla,   
//         :li_cs_talla,   
//         :ll_ca_prog_liq,   
//         :li_capas,   
//         :li_paquetes,   
//         :ll_ca_liquidadas,   
//         :ll_ca_loteadas,   
//         :ldt_fe_creacion,   
//         :ldt_fe_actualizacion,   
//         :ls_usuario,   
//         :ls_instancia  ;
//
//do while sqlca.sqlcode=0
//	
//	
//	fetch  cur_uniliq INTO :ll_cs_orden_corte,
//         :li_cs_agrupacion,   
//         :li_cs_base_trazos,   
//         :li_cs_liquidacion,   
//         :li_cs_trazo,   
//         :li_cs_seccion,   
//         :li_cs_pdn,   
//         :li_co_talla,   
//         :li_cs_talla,   
//         :ll_ca_prog_liq,   
//         :li_capas,   
//         :li_paquetes,   
//         :ll_ca_liquidadas,   
//         :ll_ca_loteadas,   
//         :ldt_fe_creacion,   
//         :ldt_fe_actualizacion,   
//         :ls_usuario,   
//         :ls_instancia  ;
//			
//			
//			
//loop
//
//close cur_uniliq;

commit;
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_migrar_liquidaciones
string text = "Migrar liq"
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_migrar_liquidaciones
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_migrar_liquidaciones
end type

