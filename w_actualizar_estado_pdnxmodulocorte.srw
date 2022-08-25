HA$PBExportHeader$w_actualizar_estado_pdnxmodulocorte.srw
forward
global type w_actualizar_estado_pdnxmodulocorte from w_base_buscar_interactivo
end type
end forward

global type w_actualizar_estado_pdnxmodulocorte from w_base_buscar_interactivo
integer x = 842
integer y = 645
integer height = 637
end type
global w_actualizar_estado_pdnxmodulocorte w_actualizar_estado_pdnxmodulocorte

type variables
TRANSACTION itr_tela
end variables

on w_actualizar_estado_pdnxmodulocorte.create
call super::create
end on

on w_actualizar_estado_pdnxmodulocorte.destroy
call super::destroy
end on

event open;call super::open;//TRANSACTION			itr_tela

itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")



CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF


end event

type pb_cancelar from w_base_buscar_interactivo`pb_cancelar within w_actualizar_estado_pdnxmodulocorte
end type

type pb_buscar from w_base_buscar_interactivo`pb_buscar within w_actualizar_estado_pdnxmodulocorte
end type

event pb_buscar::clicked;call super::clicked;LONG			ll_mod,ll_prior,ll_oc,li_i
Long		li_trazos
DataStore 	lds_ocaprobadas,lds_trazosparc,lds_ocgen,lds_liq
 
//--------------------inicio trazos-----------------------------------------------------//
//lds_ocaprobadas   = Create DataStore
//
//lds_ocaprobadas.DataObject = 'dtb_dtpdnxmodulo_estado6_aprobados'
//
//
//lds_ocaprobadas.SetTransObject(Sqlca)
//
//lds_ocaprobadas.Retrieve()
//
////------------------------------ ciclo sobre dt_agrupapdn de la agrupacion
//For li_i = 1 To lds_ocaprobadas.RowCount()
//	li_trazos=0
//	ll_oc=lds_ocaprobadas.getitemNumber(li_i,"cs_asignacion")
//	
//	SELECT count(*)  
//    INTO :li_trazos  
//    FROM dt_trazosxbase  
//   WHERE dt_trazosxbase.cs_orden_corte = :ll_oc   ;
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no select dt_trazosxbase")
//		return
//	else
//	end if
//	
//	if NOT ISNULL(li_trazos) and li_trazos > 0 then
//		UPDATE dt_pdnxmodulo  
//		  SET co_estado_asigna = 7  
//		WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
//				( dt_pdnxmodulo.co_fabrica = 91 ) AND  
//				( dt_pdnxmodulo.co_planta = 1 ) AND  
//				( dt_pdnxmodulo.cs_asignacion = :ll_oc );
//		if sqlca.sqlcode=-1 then
//			messagebox("error bd","no upd dt_pdnxmodulo")
//			return
//		else
//		end if
//	else
//	end if
//
//	
//NEXT 
//
//destroy lds_ocaprobadas
//commit;
//--------------------fin trazos------------------------------------------------------// 



//--------------------inicio generada oc------------------------------------------------------//  
// lds_trazosparc   = Create DataStore
//
//lds_trazosparc.DataObject = 'dtb_dtpdnxmodulo_estado7_trazosparcial'
//
//
//lds_trazosparc.SetTransObject(Sqlca)
//
//lds_trazosparc.Retrieve()
//
////------------------------------ ciclo sobre dt_agrupapdn de la agrupacion
//For li_i = 1 To lds_trazosparc.RowCount()
//	li_trazos=0
//	ll_oc=lds_trazosparc.getitemNumber(li_i,"cs_asignacion")
//	
//	SELECT count(*)  
//    INTO :li_trazos  
//    FROM h_ordenes_corte  
//   WHERE h_ordenes_corte.cs_orden_corte = :ll_oc   ;
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no select h_ordenes_corte")
//		return
//	else
//	end if
//	
//	if NOT ISNULL(li_trazos) and li_trazos > 0 then
//		UPDATE dt_pdnxmodulo  
//		  SET co_estado_asigna = 9  
//		WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
//				( dt_pdnxmodulo.co_fabrica = 91 ) AND  
//				( dt_pdnxmodulo.co_planta = 1 ) AND  
//				( dt_pdnxmodulo.cs_asignacion = :ll_oc );
//		if sqlca.sqlcode=-1 then
//			messagebox("error bd","no upd dt_pdnxmodulo")
//			return
//		else
//		end if
//	else
//	end if
//
//	
//NEXT 
//
//destroy lds_trazosparc
//commit;
 
 //--------------------fin generada oc------------------------------------------------------//  
 
 //--------------------inicio liquidacion------------------------------------------------------// 
 
 
 
 
//--------------------inicio liquidacion------------------------------------------------------// 

 
 DECLARE cur_pdnxmodulo CURSOR FOR  
  SELECT dt_pdnxmodulo.co_modulo,   
         dt_pdnxmodulo.cs_prioridad,   
         dt_pdnxmodulo.cs_asignacion  
    FROM dt_pdnxmodulo  
   WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
         ( dt_pdnxmodulo.co_fabrica = 91 ) AND  
         ( dt_pdnxmodulo.co_planta = 1 ) AND  
         ( dt_pdnxmodulo.cs_asignacion > 1 )  
			and dt_pdnxmodulo.co_estado_asigna in (9,10)
			and dt_pdnxmodulo.cs_asignacion in (select cs_orden_corte
			from h_ordenes_corte where cs_orden_corte>0 and co_estado=6)
			USING itr_tela;
			
open cur_pdnxmodulo ;

fetch cur_pdnxmodulo into :ll_mod,:ll_prior,:ll_oc ;

do while itr_tela.sqlcode=0
	
	  UPDATE dt_pdnxmodulo  
     SET co_estado_asigna = 11  
   WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
         ( dt_pdnxmodulo.co_fabrica = 91 ) AND  
         ( dt_pdnxmodulo.co_planta = 1 ) AND  
         ( dt_pdnxmodulo.co_modulo = :ll_mod ) AND  
         ( dt_pdnxmodulo.cs_prioridad = :ll_prior )   USING itr_tela
           ;
	if sqlca.sqlcode=-1 then
		messagebox("error bd","no upd")
		return
	else
	end if

	
	fetch cur_pdnxmodulo into :ll_mod,:ll_prior,:ll_oc ;
	
loop

close cur_pdnxmodulo ;

commit USING itr_tela;
//--------------------fin liquidacion------------------------------------------------------// 

//--------------------inicio loteado------------------------------------------------------// 
//lds_liq   = Create DataStore
//
//lds_liq.DataObject = 'dtb_dtpdnxmodulo_estado11_liquidadostot'
//
//
//lds_liq.SetTransObject(Sqlca)
//
//lds_liq.Retrieve()
//
////------------------------------ ciclo sobre dt_agrupapdn de la agrupacion
//For li_i = 1 To lds_liq.RowCount()
//	li_trazos=0
//	ll_oc=lds_liq.getitemNumber(li_i,"cs_asignacion")
//	
//	SELECT count(*)  
//    INTO :li_trazos  
//    FROM h_unidades_reales  
//   WHERE ( h_unidades_reales.cs_orden_corte = :ll_oc ) AND  
//         ( h_unidades_reales.co_estado_lote_con = 8 )   ;
//
//	
//	
//	if sqlca.sqlcode=-1 then
//		messagebox("error bd","no select h_unidades_reales")
//		return
//	else
//	end if
//	
//	if NOT ISNULL(li_trazos) and li_trazos > 0 then
//		UPDATE dt_pdnxmodulo  
//		  SET co_estado_asigna = 15  
//		WHERE ( dt_pdnxmodulo.simulacion = 1 ) AND  
//				( dt_pdnxmodulo.co_fabrica = 91 ) AND  
//				( dt_pdnxmodulo.co_planta = 1 ) AND  
//				( dt_pdnxmodulo.cs_asignacion = :ll_oc );
//		if sqlca.sqlcode=-1 then
//			messagebox("error bd","no upd dt_pdnxmodulo")
//			return
//		else
//		end if
//	else
//	end if
//
//	
//NEXT 
//
//destroy lds_liq
//commit;
//--------------------fin loteado------------------------------------------------------// 
end event

type st_1 from w_base_buscar_interactivo`st_1 within w_actualizar_estado_pdnxmodulocorte
end type

type sle_parametro1 from w_base_buscar_interactivo`sle_parametro1 within w_actualizar_estado_pdnxmodulocorte
end type

type gb_1 from w_base_buscar_interactivo`gb_1 within w_actualizar_estado_pdnxmodulocorte
end type

