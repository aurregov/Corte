HA$PBExportHeader$n_cst_reporte_centro_15.sru
forward
global type n_cst_reporte_centro_15 from nonvisualobject
end type
end forward

global type n_cst_reporte_centro_15 from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_conceptos_nivel_tintoreria (long ai_concepto)
public function long f_conceptos_ref_15 (long ai_concepto)
public function long f_complemento_compras (long ai_concepto)
public function long of_tela_comprada (long al_reftel, long ai_caract)
public function long of_actualiza_tanda (long al_tanda, long al_lote, long al_op, long al_reftel)
public function long of_consecutivo (long ai_fab, long ai_documento, long ai_incrementa)
public function long of_desmarcar_rollos_15 (long al_op, long al_reftel, long al_color_te, long ai_centro, long ai_concepto, long ai_concepto_poner, long al_lote)
public function long of_insert_movimiento (long ai_centro, long al_documento, long al_op, long ai_fab, long ai_linea, long al_referencia, long al_color_pt, long al_reftel, long al_color_te, decimal ad_kg_detenido, datetime adt_fe_ingreso_15, long al_tanda, long al_lote, long al_ficho, long ai_tipoprod, long ai_ctro_pdn, long ai_subctro_pdn, decimal ad_kg_proceso, datetime adt_fe_ingreso_pro, long ai_tipo_reg, long ai_cpto, long ai_ctro_proc)
public function long of_busca_tela_en_kamban (long ai_fab, long ai_linea, long al_ref, long al_op, long al_color_pt, long al_reftel, long al_color_te, long ai_centro, long al_consecutivo, long ai_concepto, long al_lote_15, datetime adt_fe_concepto)
end prototypes

public function long of_conceptos_nivel_tintoreria (long ai_concepto);//metodo para permitir cargar los datos de segundo nivel del reporte de 
//conceptos del centro 15
//elaborado jcrm  -jorodrig
//fecha agosto 25 de 2006
Long ll_fila, ll_op, ll_reftel, ll_ref, ll_fila2, ll_reftel_ficha, ll_count
Long ll_op_15, ll_reftel_15, ll_consecutivo, ll_lote, ll_tanda, ll_lote_15, ll_color_te, ll_colorpt_ficha, ll_colorte_ficha, ll_color_te_15
Long li_fab, li_lin
Long ll_fila3, li_centro, li_result, li_result1, li_inserto, li_cpto_desmarca
Decimal	ld_kg_ctro_15, ld_kg_proceso
Datetime	ldt_fe_ingreso_15, ldt_fe_concepto
DataStore lds_rollo, lds_ficha, lds_colores_pt_ficha

lds_rollo 				= Create DataStore
lds_colores_pt_ficha = Create DataStore
lds_ficha 				= Create DataStore

lds_rollo.DataObject 			  = 'ds_rollo_tintoreria'
lds_colores_pt_ficha.DataObject = 'ds_colores_pt_conceptos_centro15'
lds_ficha.DataObject 			  = 'ds_ficha_conceptos_centro15'

lds_rollo.SetTransObject(sqlca)
lds_colores_pt_ficha.SetTransObject(sqlca)
lds_ficha.SetTransObject(sqlca)

li_centro = 15
li_cpto_desmarca = 66
//se eliminan todos los datos de la tabla tempporal para el concepto
DELETE FROM mv_centro15_nivel2 
WHERE concepto = :ai_concepto;
Commit;

If sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar los datos de la temporal, ERROR: '+sqlca.SqlErrText )
	Return -1
End if

lds_rollo.Retrieve(ai_concepto)

//se traen del rollo la op, tela y color_tela
For ll_fila = 1 To lds_rollo.RowCount()
	ll_op_15       = lds_rollo.GetItemNumber(ll_fila,'cs_orden_pr_act')
	ll_reftel_15   = lds_rollo.GetItemNumber(ll_fila,'co_reftel_act')
	ll_color_te_15 = lds_rollo.GetItemNUmber(ll_fila,'co_color_act') 
	ld_kg_ctro_15  = lds_rollo.GetItemNUmber(ll_fila,'tot_kilos') 
	ll_lote_15     = lds_rollo.GetItemNUmber(ll_fila,'lote') 

	SELECT MIN(fe_act_cpto)
	  INTO :ldt_fe_concepto
	  FROM m_rollo
	 WHERE co_centro = 15
		AND cs_orden_pr_act = :ll_op_15
		AND co_reftel_act = :ll_reftel_15
		AND co_color_act = :ll_color_te_15
		AND lote = :ll_lote_15
		AND ca_kg > 0;
	IF IsNull(ldt_fe_concepto) THEN
		ldt_fe_concepto = ldt_fe_ingreso_15
	END IF

		
	//se traen de h_ordenpd_pt la fabrica, linea y referencia
	SELECT DISTINCT co_fabrica,
			 co_linea,
			 co_referencia
	  INTO :li_fab,
	  		 :li_lin,
			 :ll_ref
	  FROM h_ordenpd_pt
	 WHERE cs_ordenpd_pt = :ll_op_15; 
	
	If sqlca.sqlcode = -1 Then
		MessageBox('Advertencia','No fue posible establecer la fabrica, l$$HEX1$$ed00$$ENDHEX$$nea y referencia de la O.P. No. '+String(ll_op))
		Return -1
	End if
	
	
	ll_consecutivo = of_consecutivo(2,21,1)
	IF ll_consecutivo > 0 THEN
	ELSE
		Return -1
	END IF
		
   li_inserto = 0

	//traer de dt_color_modelo los colores de prenda que se pueden hacer con la tela que hay en el 15
	lds_colores_pt_ficha.Retrieve(ll_op_15,li_fab,li_lin,ll_ref,ll_reftel_15,ll_color_te_15)
	
	For ll_fila2 = 1 To lds_colores_pt_ficha.RowCount()
		ll_colorpt_ficha = lds_colores_pt_ficha.GetItemNumber(ll_fila2,'co_color_pt')
		
		//ahora con cada color voy a traer las demas telas que lleva para buscar cual esta en tintoreria
		//traer de dt_color_modelo los colores de prenda que se pueden hacer con la tela que hay en el 15
		li_result1 = lds_ficha.Retrieve(li_fab,li_lin,ll_ref,ll_colorpt_ficha)
		For ll_fila3 = 1 To li_result1
			 ll_reftel_ficha = lds_ficha.GetItemNumber(ll_fila3,'co_reftel')
			 ll_colorte_ficha = lds_ficha.GetItemNumber(ll_fila3,'co_color_te')
			
			//buscar cual de estas tela esta en el centro tintoreria
			SELECT sum(ca_kg)
			  INTO :ld_kg_proceso
			  FROM m_rollo
			 WHERE cs_orden_pr_act = :ll_op_15 AND
			       co_reftel_act = :ll_reftel_ficha AND
					 lote  =  :ll_lote_15 AND
					 co_centro 		IN (7,10,50,60) AND
					 co_color_act 	= :ll_colorte_ficha  ;
			If sqlca.sqlcode = -1 Then
				MessageBox('Advertencia','No fue posible establecer si hay tela en tintoreria.')
				Return -1
			End if
			
			If ld_kg_proceso > 0 Then
				//la tela se encuentra en tintoreria se cargan los datos a la tabla para que los muestre en el reporte
			
				li_result = of_busca_tela_en_kamban(li_fab,li_lin,ll_ref,ll_op_15,ll_colorpt_ficha,ll_reftel_ficha,&
		      ll_colorte_ficha,li_centro,ll_consecutivo,ai_concepto,ll_lote_15, ldt_fe_concepto)			
				IF li_result = -1 Then
					ROLLBACK;
					MessageBox('Advertencia','No fue posible cargar los datos de la tintoreria  ')
					Return -1
				ELSE
					COMMIT;
				END IF
				IF li_result  = 1 THEN  //si inserto algo en la tabla, no se cambia el cpto del rollo
					li_inserto = 1
				END IF
				
			Else
				//la tela no esta entintoreria se debe buscar la siguiente tela
			End if
		NEXT
	NEXT
		
	IF li_inserto = 1 THEN	
		//Se inserto el detalle de donde estaba la tela en tintoreria, debe insertar el registro que esta parado en terminado
		ll_tanda = 0

		
		IF of_insert_movimiento(li_centro,ll_consecutivo,ll_op_15,li_fab,li_lin,ll_ref,0,ll_reftel_15,ll_color_te_15,&
									 ld_kg_ctro_15,ldt_fe_concepto,ll_tanda,ll_lote_15,0,0,0,0,0,ldt_fe_ingreso_15,1,ai_concepto,0 ) = 1 THEN
			 COMMIT;
		ELSE
			ROLLBACK;
			Return -1
		END IF
	ELSE
		//No encontr$$HEX2$$f3002000$$ENDHEX$$en tintoreria datos, debe desmarcar los rollos que tenia marcados en el 15
		li_result = of_desmarcar_rollos_15(ll_op_15, ll_reftel_15, ll_color_te_15, li_centro, ai_concepto, li_cpto_desmarca, ll_lote_15) 
	END IF
	
Next

Return 0
end function

public function long f_conceptos_ref_15 (long ai_concepto);return 1

//metodo para permitir cargar los datos de segundo nivel del reporte de 
//conceptos del centro 15
//elaborado jcrm  -jorodrig
//fecha agosto 25 de 2006
Long ll_fila, ll_op, ll_reftel, ll_ref, ll_fila2, ll_reftel_ficha, ll_count, ll_color_pt
Long ll_op_15, ll_reftel_15, ll_consecutivo, ll_lote, ll_tanda, ll_lote_15, ll_color_te, ll_colorpt_ficha, ll_colorte_ficha, ll_color_te_15
Long li_fab, li_lin
Long ll_fila3, li_centro, li_result, li_result1, li_inserto, li_cpto_desmarca
Decimal	ld_kg_ctro_15, ld_kg_proceso
Datetime	ldt_fe_ingreso_15, ldt_fe_concepto
DataStore lds_rollo, lds_ficha, lds_colores_pt_ficha

lds_rollo 				= Create DataStore
lds_colores_pt_ficha = Create DataStore
lds_ficha 				= Create DataStore

lds_rollo.DataObject 			  = 'ds_rollo_tintoreria'
lds_colores_pt_ficha.DataObject = 'ds_colores_pt_conceptos_centro15'
lds_ficha.DataObject 			  = 'ds_ficha_conceptos_centro15'

lds_rollo.SetTransObject(sqlca)
lds_colores_pt_ficha.SetTransObject(sqlca)
lds_ficha.SetTransObject(sqlca)

li_centro = 15
li_cpto_desmarca = 66
//se eliminan todos los datos de la tabla tempporal para el concepto
DELETE FROM mv_centro15_nivel2 
WHERE concepto = :ai_concepto;
Commit;

If sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar los datos de la temporal, ERROR: '+sqlca.SqlErrText )
	Return -1
End if

lds_rollo.Retrieve(ai_concepto)

//se traen del rollo la op, tela y color_tela
For ll_fila = 1 To lds_rollo.RowCount()
	ll_op_15       = lds_rollo.GetItemNumber(ll_fila,'cs_orden_pr_act')
	ll_reftel_15   = lds_rollo.GetItemNumber(ll_fila,'co_reftel_act')
	ll_color_te_15 = lds_rollo.GetItemNUmber(ll_fila,'co_color_act') 
	ld_kg_ctro_15  = lds_rollo.GetItemNUmber(ll_fila,'tot_kilos') 
	ll_lote_15     = lds_rollo.GetItemNUmber(ll_fila,'lote') 
	
	
	
	SELECT MIN(fe_act_cpto)
	  INTO :ldt_fe_concepto
	  FROM m_rollo
	 WHERE co_centro = 15
		AND cs_orden_pr_act = :ll_op_15
		AND co_reftel_act = :ll_reftel_15
		AND co_color_act = :ll_color_te_15
		AND lote = :ll_lote_15;
	IF IsNull(ldt_fe_concepto) THEN
		ldt_fe_concepto = ldt_fe_ingreso_15
	END IF
	
	//se traen de h_ordenpd_pt la fabrica, linea y referencia
	SELECT DISTINCT co_fabrica,
			 co_linea,
			 co_referencia
	  INTO :li_fab,
	  		 :li_lin,
			 :ll_ref
	  FROM h_ordenpd_pt
	 WHERE cs_ordenpd_pt = :ll_op_15; 
	
	If sqlca.sqlcode = -1 Then
		MessageBox('Advertencia','No fue posible establecer la fabrica, l$$HEX1$$ed00$$ENDHEX$$nea y referencia de la O.P. No. '+String(ll_op))
		Return -1
	End if
		
	ll_consecutivo = of_consecutivo(2,21,1)
	IF ll_consecutivo > 0 THEN
	ELSE
		Return -1
	END IF
		
	SELECT co_color
	  INTO :ll_color_pt
	  FROM h_lote_tela
	 WHERE cs_lote = :ll_lote_15; 
	  
	li_inserto = 0

	//traer de dt_color_modelo los colores de prenda que se pueden hacer con la tela que hay en el 15
	lds_colores_pt_ficha.Retrieve(ll_op_15,li_fab,li_lin,ll_ref,ll_reftel_15,ll_color_te_15)
	
	For ll_fila2 = 1 To lds_colores_pt_ficha.RowCount()
		ll_colorpt_ficha = lds_colores_pt_ficha.GetItemNumber(ll_fila2,'co_color_pt')
		
		//ahora con cada color voy a traer las demas telas que lleva para buscar cual esta en tintoreria
		//traer de dt_color_modelo los colores de prenda que se pueden hacer con la tela que hay en el 15
		li_result1 = lds_ficha.Retrieve(li_fab,li_lin,ll_ref,ll_colorpt_ficha)
		For ll_fila3 = 1 To li_result1
			 ll_reftel_ficha = lds_ficha.GetItemNumber(ll_fila3,'co_reftel')
			 ll_colorte_ficha = lds_ficha.GetItemNumber(ll_fila3,'co_color_te')
			
			//buscar cual de estas tela esta en el centro tintoreria
			SELECT sum(ca_kg)
			  INTO :ld_kg_proceso
			  FROM m_rollo
			 WHERE cs_orden_pr_act = :ll_op_15 AND
			       co_reftel_act = :ll_reftel_ficha AND
					 lote  =  :ll_lote_15 AND
					 co_centro 		IN (7,10,50,60) AND
					 co_color_act 	= :ll_colorte_ficha  ;
			If sqlca.sqlcode = -1 Then
				MessageBox('Advertencia','No fue posible establecer si hay tela en tintoreria.')
				Return -1
			End if
			
			If ld_kg_proceso > 0 Then
				//la tela se encuentra en tintoreria se cargan los datos a la tabla para que los muestre en el reporte
			
				li_result = of_busca_tela_en_kamban(li_fab,li_lin,ll_ref,ll_op_15,ll_colorpt_ficha,ll_reftel_ficha,&
		      ll_colorte_ficha,li_centro,ll_consecutivo,ai_concepto,ll_lote_15,ldt_fe_concepto)			
				IF li_result = -1 Then
					ROLLBACK;
					MessageBox('Advertencia','No fue posible cargar los datos de la tintoreria  ')
					Return -1
				ELSE
					COMMIT;
				END IF
				IF li_result  = 1 THEN  //si inserto algo en la tabla, no se cambia el cpto del rollo
					li_inserto = 1
				END IF
				
			Else
				//la tela no esta entintoreria se debe buscar la siguiente tela
			End if
		NEXT
	NEXT
		
	IF li_inserto = 1 THEN	
		//Se inserto el detalle de donde estaba la tela en tintoreria, debe insertar el registro que esta parado en terminado
		ll_tanda = 0
		IF of_insert_movimiento(li_centro,ll_consecutivo,ll_op_15,li_fab,li_lin,ll_ref,0,ll_reftel_15,ll_color_te_15,&
									 ld_kg_ctro_15,ldt_fe_ingreso_15,ll_tanda,ll_lote_15,0,0,0,0,0,ldt_fe_ingreso_15,1,ai_concepto,0 ) = 1 THEN
			 COMMIT;
		ELSE
			ROLLBACK;
			Return -1
		END IF
	ELSE
		//No encontr$$HEX2$$f3002000$$ENDHEX$$en tintoreria datos, debe desmarcar los rollos que tenia marcados en el 15
		li_result = of_desmarcar_rollos_15(ll_op_15, ll_reftel_15, ll_color_te_15, li_centro, ai_concepto, li_cpto_desmarca, ll_lote_15) 
	END IF
	
Next

Return 0
end function

public function long f_complemento_compras (long ai_concepto);//metodo para permitir cargar los datos de segundo nivel del reporte de 
//conceptos del centro 15
//elaborado jcrm  -jorodrig
//fecha agosto 25 de 2006
Long ll_fila, ll_op, ll_reftel, ll_ref, ll_fila2, ll_reftel_ficha, ll_count
Long ll_op_15, ll_reftel_15, ll_consecutivo, ll_lote, ll_tanda, ll_lote_15, ll_color_te, ll_colorpt_ficha, ll_colorte_ficha, ll_color_te_15
Long li_fab, li_lin
Long ll_fila3, li_centro, li_result, li_result1, li_inserto, li_cpto_desmarca
Long	li_caract_ficha, li_comprada, li_result3, ll_fila4, li_lleva_comprada, li_centro_proc
Decimal	ld_kg_ctro_15, ld_kg_proceso
Datetime	ldt_fe_ingreso_15
DataStore lds_rollo, lds_ficha, lds_colores_pt_ficha, lds_kilos_x_centro_x_op_x_tela

lds_rollo 				= Create DataStore
lds_colores_pt_ficha = Create DataStore
lds_ficha 				= Create DataStore
lds_kilos_x_centro_x_op_x_tela 				= Create DataStore

lds_rollo.DataObject 			  = 'ds_rollo_tintoreria_sin_lote'
lds_colores_pt_ficha.DataObject = 'ds_colores_pt_conceptos_centro15'
lds_ficha.DataObject 			  = 'ds_ficha_conceptos_centro15'
lds_kilos_x_centro_x_op_x_tela.DataObject  = 'ds_kilos_x_centro_x_op_x_tela'

lds_rollo.SetTransObject(sqlca)
lds_colores_pt_ficha.SetTransObject(sqlca)
lds_ficha.SetTransObject(sqlca)
lds_kilos_x_centro_x_op_x_tela.SetTransObject(sqlca)

li_centro = 15
li_cpto_desmarca = 66
//se eliminan todos los datos de la tabla tempporal para el concepto
DELETE FROM mv_centro15_nivel2 
WHERE concepto = :ai_concepto;
Commit;

If sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar los datos de la temporal, ERROR: '+sqlca.SqlErrText )
	Return -1
End if

lds_rollo.Retrieve(ai_concepto)

//se traen del rollo la op, tela y color_tela
For ll_fila = 1 To lds_rollo.RowCount()
	ll_op_15       = lds_rollo.GetItemNumber(ll_fila,'cs_orden_pr_act')
	ll_reftel_15   = lds_rollo.GetItemNumber(ll_fila,'co_reftel_act')
	ll_color_te_15 = lds_rollo.GetItemNUmber(ll_fila,'co_color_act') 
	ld_kg_ctro_15  = lds_rollo.GetItemNUmber(ll_fila,'tot_kilos') 
	ll_lote_15     = 0
	
	//se traen de h_ordenpd_pt la fabrica, linea y referencia
	SELECT DISTINCT co_fabrica,
			 co_linea,
			 co_referencia
	  INTO :li_fab,
	  		 :li_lin,
			 :ll_ref
	  FROM h_ordenpd_pt
	 WHERE cs_ordenpd_pt = :ll_op_15; 
	
	If sqlca.sqlcode = -1 Then
		MessageBox('Advertencia','No fue posible establecer la fabrica, l$$HEX1$$ed00$$ENDHEX$$nea y referencia de la O.P. No. '+String(ll_op))
		Return -1
	End if
	
	ll_consecutivo = of_consecutivo(2,21,1)
	IF ll_consecutivo > 0 THEN
	ELSE
		Return -1
	END IF
		
   li_inserto = 0
	li_lleva_comprada = 0
	
	//traer de dt_color_modelo los colores de prenda que se pueden hacer con la tela que hay en el 15
	lds_colores_pt_ficha.Retrieve(ll_op_15,li_fab,li_lin,ll_ref,ll_reftel_15,ll_color_te_15)
	
	For ll_fila2 = 1 To lds_colores_pt_ficha.RowCount()
		ll_colorpt_ficha = lds_colores_pt_ficha.GetItemNumber(ll_fila2,'co_color_pt')
		
		
		//ahora con cada color voy a traer las demas telas que lleva para buscar cual esta en tintoreria
		//traer de dt_color_modelo los colores de prenda que se pueden hacer con la tela que hay en el 15
		li_result1 = lds_ficha.Retrieve(li_fab,li_lin,ll_ref,ll_colorpt_ficha)
		For ll_fila3 = 1 To li_result1
			 ll_reftel_ficha = lds_ficha.GetItemNumber(ll_fila3,'co_reftel')
			 ll_colorte_ficha = lds_ficha.GetItemNumber(ll_fila3,'co_color_te')
 			 li_caract_ficha  = lds_ficha.GetItemNumber(ll_fila3,'co_caract')
			
			//revisamos si la tela es comprada
			li_comprada = of_tela_comprada(ll_reftel_ficha,li_caract_ficha)
			
			//solo si la tela es comprada continuamos
			IF ((li_comprada = 1) AND (ll_reftel_ficha <> ll_reftel_15)) THEN
				li_lleva_comprada = 1
				li_result3 = lds_kilos_x_centro_x_op_x_tela.Retrieve(ll_op_15,ll_reftel_ficha,ll_colorte_ficha)
				IF li_result3 > 0 THEN
					//Insertamos diciendo donde hay tela
					FOR ll_fila4 = 1 To li_result3
						 li_centro_proc = lds_kilos_x_centro_x_op_x_tela.GetItemNumber(ll_fila4,'co_centro')
						 ld_kg_proceso  = lds_kilos_x_centro_x_op_x_tela.GetItemNumber(ll_fila4,'ca_kg')
						 ldt_fe_ingreso_15  = lds_kilos_x_centro_x_op_x_tela.GetItemDateTime(ll_fila4,'fe_actualizacion')
	
						IF of_insert_movimiento(li_centro,ll_consecutivo,ll_op_15,li_fab,li_lin,ll_ref,ll_colorpt_ficha,ll_reftel_ficha,ll_colorte_ficha,&
											 0,ldt_fe_ingreso_15,ll_tanda,ll_lote_15,0,0,0,0,ld_kg_proceso,ldt_fe_ingreso_15,2,ai_concepto, li_centro_proc ) = 1 THEN
							COMMIT;
						ELSE
							ROLLBACK;
							Return -1
						END IF
					NEXT
				ELSE
					//Insertamos diciendo que la tela comprada no se ha comprado
					IF of_insert_movimiento(li_centro,ll_consecutivo,ll_op_15,li_fab,li_lin,ll_ref,ll_colorpt_ficha,ll_reftel_ficha,ll_colorte_ficha,&
											 0,ldt_fe_ingreso_15,ll_tanda,ll_lote_15,0,0,0,0,0,ldt_fe_ingreso_15,2,ai_concepto, 999 ) = 1 THEN
						COMMIT;
					ELSE
						ROLLBACK;
						Return -1
					END IF
				END IF
				
			END IF
		NEXT
		
	
	NEXT
		
	IF li_lleva_comprada = 1 THEN	
		//Se inserto el detalle de donde estaba la tela en tintoreria, debe insertar el registro que esta parado en terminado
		ll_tanda = 0
		IF of_insert_movimiento(li_centro,ll_consecutivo,ll_op_15,li_fab,li_lin,ll_ref,0,ll_reftel_15,ll_color_te_15,&
									 ld_kg_ctro_15,ldt_fe_ingreso_15,ll_tanda,ll_lote_15,0,0,0,0,0,ldt_fe_ingreso_15,1,ai_concepto,li_centro) = 1 THEN
			 COMMIT;
		ELSE
			ROLLBACK;
			Return -1
		END IF
	ELSE
		//No encontr$$HEX2$$f3002000$$ENDHEX$$en tintoreria datos, debe desmarcar los rollos que tenia marcados en el 15
		li_result = of_desmarcar_rollos_15(ll_op_15, ll_reftel_15, ll_color_te_15, li_centro, ai_concepto, li_cpto_desmarca, ll_lote_15) 
	END IF
	
Next

Return 0
end function

public function long of_tela_comprada (long al_reftel, long ai_caract);
Long li_comprada

select sw_comprada
 into :li_comprada
from h_telas
where co_reftel = :al_reftel
  and co_caract = :ai_caract;
 
return li_comprada; 
end function

public function long of_actualiza_tanda (long al_tanda, long al_lote, long al_op, long al_reftel);//Esta funcion se encarga de actualizar en el kamban de tintoreria la tanda
//que esta atrasando la produccion del 15 con el concepto por liberar

UPDATE dt_lotesxtandas
SET cs_espera = 2   //por liberar
WHERE cs_tanda = :al_tanda
  AND cs_ordenpd_pt = :al_op
  AND cs_lote = :al_lote
  AND co_reftel = :al_reftel;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error','Se presentaron errores Actualizando en el kamban de tintoreria la tanda a x liberar')
	Return -1
END IF  
  
 COMMIT;
  
RETURN 1
end function

public function long of_consecutivo (long ai_fab, long ai_documento, long ai_incrementa);Long ll_consecutivo

ll_consecutivo= 0
//determino el numero del consecutivo
SELECT cs_documento 
  INTO :ll_consecutivo
  FROM cf_consecutivos  
 WHERE co_fabrica = :ai_fab  AND  
		 id_documento = :ai_documento ;

IF SQLCA.Sqlcode = -1 THEN
	ROLLBACK  ;
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el consecutivo')
	Return -1 
END IF
         

UPDATE cf_consecutivos
   SET cs_documento = cs_documento + :ai_incrementa
 WHERE co_fabrica = :ai_fab  AND  
		 id_documento = :ai_documento ;	

IF SQLCA.Sqlcode = -1 THEN
	ROLLBACK;
	MessageBox('Error Base Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el consecutivo')
	Return -1 
END IF

COMMIT;

ll_consecutivo = ll_consecutivo + 1

Return ll_consecutivo
end function

public function long of_desmarcar_rollos_15 (long al_op, long al_reftel, long al_color_te, long ai_centro, long ai_concepto, long ai_concepto_poner, long al_lote);Long ll_fila
Long	ll_rollo
Datetime	ldt_fecha
DataStore lds_lista_rollos_cambar_concepto

lds_lista_rollos_cambar_concepto = Create DataStore
lds_lista_rollos_cambar_concepto.DataObject = 'ds_lista_rollos_cambar_concepto'
lds_lista_rollos_cambar_concepto.SetTransObject(sqlca)

ldt_fecha = f_fecha_servidor()

lds_lista_rollos_cambar_concepto.Retrieve(al_op,al_reftel,al_color_te,ai_centro,ai_concepto, al_lote)

//se traen del rollo la op, tela y color_tela
For ll_fila = 1 To lds_lista_rollos_cambar_concepto.RowCount()
	ll_rollo       = lds_lista_rollos_cambar_concepto.GetItemNumber(ll_fila,'cs_rollo')
	UPDATE m_rollo
	SET (co_planeador, fe_act_cpto) = (:ai_concepto_poner, :ldt_fecha)
	WHERE cs_rollo = :ll_rollo;
	IF SQLCA.SQLCODE <> 0 THEN
		Rollback;
		MessageBox('Error','Se presento un error desmarcando los rollos del concepto')
		Return -1
	ELSE
		Commit;
	END IF
Next

Return 1


//
end function

public function long of_insert_movimiento (long ai_centro, long al_documento, long al_op, long ai_fab, long ai_linea, long al_referencia, long al_color_pt, long al_reftel, long al_color_te, decimal ad_kg_detenido, datetime adt_fe_ingreso_15, long al_tanda, long al_lote, long al_ficho, long ai_tipoprod, long ai_ctro_pdn, long ai_subctro_pdn, decimal ad_kg_proceso, datetime adt_fe_ingreso_pro, long ai_tipo_reg, long ai_cpto, long ai_ctro_proc);DATETIME	ldt_fe_hoy
STRING	ls_usuario, ls_instancia



INSERT INTO mv_centro15_nivel2 (co_centro, cs_pendiente, op, co_fabrica, co_linea, co_referencia,
			   co_color_pt, co_reftel, co_color_te, kg_detenidos, fe_ingreso_15, cs_tanda, lote, ficho,
				co_tipoprod, co_centro_pdn, co_subcentro_pdn, kg_proceso, fe_ingreso_pro, tipo_reg,
				fe_actualizacion, usuario,	instancia, concepto, co_ctro_proc)
	  VALUES (:ai_centro, :al_documento, :al_op, :ai_fab, :ai_linea, :al_referencia, :al_color_pt,
	  			:al_reftel, :al_color_te, :ad_kg_detenido, :adt_fe_ingreso_15, :al_tanda, :al_lote, :al_ficho,
				:ai_tipoprod, :ai_ctro_pdn, :ai_subctro_pdn, :ad_kg_proceso, :adt_fe_ingreso_pro, :ai_tipo_reg,
				:ldt_fe_hoy, :ls_usuario, :ls_instancia, :ai_cpto, :ai_ctro_proc);  
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error','Se presentaron errores insertando los datos')
	Return -1
END IF
				
				
Return 1		
end function

public function long of_busca_tela_en_kamban (long ai_fab, long ai_linea, long al_ref, long al_op, long al_color_pt, long al_reftel, long al_color_te, long ai_centro, long al_consecutivo, long ai_concepto, long al_lote_15, datetime adt_fe_concepto);Long		 li_ctro_pdn, li_subctro_pdn, ll_fila
Long			ll_tanda, ll_lote, ll_ficho
Decimal		ld_kg_proceso
Datetime		ldt_fe_ingreso

DataStore lds_busca_proceso_tela_ctro_tinto

lds_busca_proceso_tela_ctro_tinto = Create DataStore
lds_busca_proceso_tela_ctro_tinto.DataObject = 'ds_busca_proceso_tela_ctro_tinto'
lds_busca_proceso_tela_ctro_tinto.SetTransObject(sqlca)


lds_busca_proceso_tela_ctro_tinto.Retrieve(ai_fab,ai_linea,al_ref,al_op,al_color_te,al_reftel,al_lote_15)

//se traen del rollo la op, tela y color_tela
For ll_fila = 1 To lds_busca_proceso_tela_ctro_tinto.RowCount()
	ll_ficho       = lds_busca_proceso_tela_ctro_tinto.GetItemNumber(ll_fila,'cs_ficho')
	ll_tanda   		= lds_busca_proceso_tela_ctro_tinto.GetItemNumber(ll_fila,'cs_tanda')
	ll_lote 			= lds_busca_proceso_tela_ctro_tinto.GetItemNUmber(ll_fila,'lote') 
	li_ctro_pdn 	= lds_busca_proceso_tela_ctro_tinto.GetItemNUmber(ll_fila,'co_centro_pdn') 
	li_subctro_pdn = lds_busca_proceso_tela_ctro_tinto.GetItemNUmber(ll_fila,'co_subcentro_pdn') 
	ld_kg_proceso  = lds_busca_proceso_tela_ctro_tinto.GetItemNUmber(ll_fila,'kilos') 
	ldt_fe_ingreso = lds_busca_proceso_tela_ctro_tinto.GetItemDatetime(ll_fila,'fe_ingreso') 
	
	IF of_insert_movimiento(ai_centro,al_consecutivo,al_op,ai_fab,ai_linea,al_ref,al_color_pt,al_reftel,&
	                        al_color_te,0,adt_fe_concepto,ll_tanda,ll_lote,ll_ficho,2,li_ctro_pdn,li_subctro_pdn,&
									ld_kg_proceso,ldt_fe_ingreso,2,ai_concepto,0 ) = 1 THEN
	ELSE
		Return -1
	END IF
	
	of_actualiza_tanda(ll_tanda,ll_lote,al_op,al_reftel)


NEXT

Return 1


//
end function

on n_cst_reporte_centro_15.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_reporte_centro_15.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

