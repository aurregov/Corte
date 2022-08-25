HA$PBExportHeader$w_actualizar_mv_inventa_etapa.srw
forward
global type w_actualizar_mv_inventa_etapa from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_mv_inventa_etapa from w_base_buscar_interactivo
end type
global w_actualizar_mv_inventa_etapa w_actualizar_mv_inventa_etapa

on w_actualizar_mv_inventa_etapa.create
call super::create
end on

on w_actualizar_mv_inventa_etapa.destroy
call super::destroy
end on

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_mv_inventa_etapa
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_mv_inventa_etapa
end type

event pb_buscar::clicked;call super::clicked;// DECLARE talla CURSOR FOR  
//  SELECT dt_agrupaescalapdn.cs_agrupacion,   
//         dt_agrupaescalapdn.cs_pdn,   
//         dt_agrupaescalapdn.co_talla,   
//         dt_agrupaescalapdn.cs_talla,   
//         dt_agrupaescalapdn.co_estado,   
//         dt_agrupaescalapdn.ca_unidades,   
//         dt_agrupaescalapdn.fe_creacion,   
//         dt_agrupaescalapdn.fe_actualizacion,   
//         dt_agrupaescalapdn.usuario,   
//         dt_agrupaescalapdn.instancia  
//    FROM dt_agrupaescalapdn,   
//         dt_agrupa_pdn  
//   WHERE ( dt_agrupa_pdn.cs_agrupacion = dt_agrupaescalapdn.cs_agrupacion ) and  
//         ( dt_agrupa_pdn.cs_pdn = dt_agrupaescalapdn.cs_pdn ) and  
//         ( ( dt_agrupaescalapdn.cs_agrupacion =  ) AND  
//         ( dt_agrupaescalapdn.cs_pdn =  ) )   ;
//
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_mv_inventa_etapa
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_mv_inventa_etapa
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_mv_inventa_etapa
end type

