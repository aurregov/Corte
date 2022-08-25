HA$PBExportHeader$n_cts_corte_copia.sru
forward
global type n_cts_corte_copia from nonvisualobject
end type
end forward

global type n_cts_corte_copia from nonvisualobject
end type
global n_cts_corte_copia n_cts_corte_copia

type variables
Datastore ids_calendario, ids_procesos, ids_prog_diario
end variables

forward prototypes
public function long of_minutoscalendario (ref date an_inicio, ref decimal adc_mindspini)
public function long of_metodominutos (long ai_simulacion, long ai_fabrica, long ai_planta, long ai_modulo, long ai_prioridad, date ad_inicio, ref uo_dtwndow adw_produccion)
public function long of_update (ref uo_dtwndow adw_produccion)
end prototypes

public function long of_minutoscalendario (ref date an_inicio, ref decimal adc_mindspini);Long ll_flfnd
String ls_festivo


Do
	an_inicio = RelativeDate(an_inicio,1)
						
	ll_flfnd = ids_calendario.Find("fe_mod_calendario = date(~"" + String(an_inicio,"dd/mm/yyyy")+"~")",1,ids_calendario.RowCount())
	
	If ll_flfnd <= 0 Then
		Rollback;
		MessageBox("Advertencia!","No se pudo encontrar los minutos disponibles para la fecha: "+String(an_inicio) + SQLCA.SQLErrText)
		Return -1
	Else
		adc_mindspini = Long(ids_calendario.GetItemDecimal(ll_flfnd,'minutos'))
		ls_festivo    = ids_calendario.GetItemString(ll_flfnd,'co_tipo_dia')
	End If

Loop Until ls_festivo <> 'F'

Return 0
end function

public function long of_metodominutos (long ai_simulacion, long ai_fabrica, long ai_planta, long ai_modulo, long ai_prioridad, date ad_inicio, ref uo_dtwndow adw_produccion);uo_dsbase lds_produccion,lds_minxprenda,lds_fechainici
Long     ll_i,ll_j,ll_pedido,ll_ref,ll_result,ll_flfnd, ll_registro, &
         ll_programado,ll_duracion,ll_undpsb,ll_buscar, ll_color
Long  li_fabexp,li_cslib,li_fabpt,li_lin,li_csest,li_cspar,li_estilo,&
         li_tpprod,li_centro,li_subcentro,li_proceso,li_secuenc
String   ls_po,ls_tono,ls_sqlerr
Decimal  ldc_totmin,ldc_min,ldc_pendiente,ldc_cnt,ldc_mindspini,ldc_mindspfn
Date     ld_inicio,ld_inicio2
DateTime ldt_fin,ldt_inicio,ldt_prdini
Time     lt_hora
String 	ls_linea,ls_estilo,ls_festivo


//	Carga el calendario para la fabrica, planta, modulo, y con fecha modificacion >= ad_inicio
ids_calendario = Create uo_dsbase
ids_calendario.DataObject = 'd_lista_calendario'
ids_calendario.SetTransObject(Sqlca)
ids_calendario.Retrieve(ai_fabrica,ai_planta,ai_modulo,ad_inicio)

//	Carga la producci$$HEX1$$f300$$ENDHEX$$n a la cual se le programara el tiempo	
lds_produccion = Create uo_dsbase
lds_produccion.DataObject = 'd_lista_prod_x_programar'
lds_produccion.SetTransObject(Sqlca)
lds_produccion.Retrieve(ai_simulacion,ai_fabrica,ai_planta,ai_modulo,ai_prioridad)

//	
lds_minxprenda = Create uo_dsbase
lds_minxprenda.DataObject = 'd_lista_minxprenda'
lds_minxprenda.SetTransObject(Sqlca)

//	
lds_fechainici = Create uo_dsbase
lds_fechainici.DataObject = 'd_fecha_inicial'
lds_fechainici.SetTransObject(Sqlca)


//Obtengo el tipo producto, centro y subcentro.
select co_tipoprod,   
       co_centro_pdn,   
       co_subcentro_pdn
  into :li_tpprod,   
       :li_centro,   
       :li_subcentro
  from m_modulos  
 where co_fabrica = :ai_fabrica and
       co_planta 	= :ai_planta and
       co_modulo 	= :ai_modulo    ;

If Sqlca.SqlCode <> 0 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","Hubo un error al buscar el tipo de producto.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

ld_inicio = ad_inicio
lt_hora   = 00:00:00

If ai_prioridad = 1 Then
	ld_inicio = RelativeDate(ld_inicio,-1)
	If This.Of_MinutosCalendario(ld_inicio,ldc_mindspini) = -1 Then
		Return -1
	End If
Else
	ll_result = lds_fechainici.Retrieve(ai_simulacion,ai_fabrica,ai_planta,ai_modulo,ai_prioridad -1,ld_inicio) 
	
	If ll_result < 0 Then
		rollback ;
		MessageBox("Advertencia!","Hubo un error al buscar la fecha de inicio.~n~n~nNota: " + ls_sqlerr )
		Return -1
	ElseIf ll_result = 0 Then
		ld_inicio = RelativeDate(ld_inicio,-1)
		ldc_mindspini = 0 
	Else
		ldc_mindspini = lds_fechainici.GetItemDecimal(ll_result,'ca_min_dispon_fin')
		lt_hora = RelativeTime(00:00:00,ldc_mindspini * 60 )
	End If
End If

For ll_i = 1 To lds_produccion.RowCount()

	li_fabexp 		= lds_produccion.GetitemNumber(ll_i,"co_fabrica_exp")  
	ll_pedido 		= lds_produccion.GetitemNumber(ll_i,"pedido")   
	li_cslib  		= lds_produccion.GetitemNumber(ll_i,"cs_liberacion")   
	ls_po     		= lds_produccion.GetitemString(ll_i,"po")   
	li_fabpt  		= lds_produccion.GetitemNumber(ll_i,"co_fabrica_pt")   
	li_lin    		= lds_produccion.GetitemNumber(ll_i,"co_linea")   
	ll_ref    		= lds_produccion.GetitemNumber(ll_i,"co_referencia")   
	ll_color    		= lds_produccion.GetitemNumber(ll_i,"co_color_pt")   
	ls_tono   		= lds_produccion.GetitemString(ll_i,"tono")   
	li_csest  		= lds_produccion.GetitemNumber(ll_i,"cs_estilocolortono")   
	li_cspar	 		= lds_produccion.GetitemNumber(ll_i,"cs_particion")
	li_estilo 		= lds_produccion.GetitemNumber(ll_i,"co_estilo")
	ldc_pendiente 	= lds_produccion.GetitemDecimal(ll_i,"ca_pendiente")
	
	ll_result = lds_minxprenda.Retrieve(li_tpprod,li_centro,li_subcentro,li_fabpt,li_lin,li_estilo)
	
	If ll_result > 0 Then
		
		//Borro los anteriores procesos
		delete from dt_procesos_plan  
       where simulacion 			= :ai_simulacion and 
             co_fabrica 			= :ai_fabrica and
             co_planta 				= :ai_planta and
             co_modulo 				= :ai_modulo and 
             co_fabrica_exp 		= :li_fabexp and 
             pedido 					= :ll_pedido and
             cs_liberacion 		= :li_cslib and  
             po 						= :ls_po and
             co_fabrica_pt 		= :li_fabpt and 
             co_linea 				= :li_lin and
             co_referencia 		= :ll_ref and 
             co_color_pt 			= :ll_color and
             tono 					= :ls_tono and
             cs_estilocolortono 	= :li_csest and
             cs_particion 			= :li_cspar  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","Hubo un error al borrar los procesos.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
		
		//Inserto los nuevos procesos
		ldc_totmin = 0
		
		For ll_j = 1 To lds_minxprenda.RowCount()
			li_secuenc = lds_minxprenda.GetItemNumber(ll_j,'cs_secuencia')
			li_proceso = lds_minxprenda.GetItemNumber(ll_j,'co_proceso_pdn')
			ldc_min    = lds_minxprenda.GetItemDecimal(ll_j,'min_unidad')
								
			ldc_cnt = ldc_pendiente * ldc_min

			ll_registro = ids_procesos.InsertRow(0)
			ids_procesos.SetItem(ll_registro,'simulacion', ai_simulacion)
			ids_procesos.SetItem(ll_registro,'co_fabrica', ai_fabrica)
			ids_procesos.SetItem(ll_registro,'co_planta', ai_planta)
			ids_procesos.SetItem(ll_registro,'co_modulo', ai_modulo)
			ids_procesos.SetItem(ll_registro,'co_fabrica_exp', li_fabexp)
			ids_procesos.SetItem(ll_registro,'pedido', ll_pedido)
			ids_procesos.SetItem(ll_registro,'cs_liberacion', li_cslib)
			ids_procesos.SetItem(ll_registro,'po', ls_po)
			ids_procesos.SetItem(ll_registro,'co_fabrica_pt', li_fabpt)
			ids_procesos.SetItem(ll_registro,'co_linea', li_lin)
			ids_procesos.SetItem(ll_registro,'co_referencia', ll_ref)
			ids_procesos.SetItem(ll_registro,'co_color_pt', ll_color)
			ids_procesos.SetItem(ll_registro,'tono', ls_tono)
			ids_procesos.SetItem(ll_registro,'cs_estilocolortono', li_csest)
			ids_procesos.SetItem(ll_registro,'cs_particion', li_cspar)
			ids_procesos.SetItem(ll_registro,'co_proces', li_proceso)
			ids_procesos.SetItem(ll_registro,'cs_proceso', li_secuenc)
			ids_procesos.SetItem(ll_registro,'co_metodo_programa', 1)
			ids_procesos.SetItem(ll_registro,'co_consumo_proceso', 1)
			ids_procesos.SetItem(ll_registro,'ca_consumo_estimad', ldc_cnt)
			ids_procesos.SetItem(ll_registro,'unidad_consum_est', 1)
			ids_procesos.SetItem(ll_registro,'estandar_consumo', ldc_min)
			ids_procesos.SetItem(ll_registro,'unidade_consum_std', 1)
			ids_procesos.SetItem(ll_registro,'fe_creacion', f_fecha_servidor())
			ids_procesos.SetItem(ll_registro,'fe_actualizacion', f_fecha_servidor())
			ids_procesos.SetItem(ll_registro,'usuario', gstr_info_usuario.codigo_usuario)
			ids_procesos.SetItem(ll_registro,'instancia', gstr_info_usuario.instancia)
								
//			insert into dt_procesos_plan  
//            ( 	simulacion,				co_fabrica,				co_planta,				co_modulo,
//					co_fabrica_exp, 		pedido,					cs_liberacion,			po,
//					co_fabrica_pt,			co_linea,   			co_referencia,			co_color_pt,
//					tono,						cs_estilocolortono,	cs_particion, 			co_proces,
//					cs_proceso,				co_metodo_programa,	co_consumo_proceso,	ca_consumo_estimad,   
//              	unidad_consum_est,	estandar_consumo,		unidade_consum_std,	fe_creacion,   
//              	fe_actualizacion,		usuario,					instancia )  
//         values ( 
//					:ai_simulacion,		:ai_fabrica,			:ai_planta,				:ai_modulo,
//					:li_fabexp,   			:ll_pedido,				:li_cslib,				:ls_po,
//					:li_fabpt,				:li_lin,					:ll_ref,					:ll_color,   
//              	:ls_tono,				:li_csest,				:li_cspar,				:li_proceso,
//					:li_secuenc,			1,							1,							:ldc_cnt,   
//              	1,							:ldc_min,				1,							current,
//					current,					user,						sitename )  ;
//		
//			If Sqlca.SqlCode = -1 Then
//				ls_sqlerr = Sqlca.SqlErrText
//				rollback ;
//				MessageBox("Advertencia!","Hubo un error al insertar el proceso.~n~n~nNota: " + ls_sqlerr )
//				Return -1
//			End If
			
			//solo tiene en cuenta el tiempo para el extendido
			If li_proceso <> 2 Then ldc_min = 0
			
			ldc_totmin += ldc_min
			
		Next	
		
		//Borro si ya tiene tiempo programado
		delete from  dt_programa_diario  
       where simulacion 			= :ai_simulacion and
             co_fabrica 			= :ai_fabrica and
             co_planta 				= :ai_planta and
             co_modulo 				= :ai_modulo and  
             co_fabrica_exp 		= :li_fabexp and
             pedido 					= :ll_pedido and  
             cs_liberacion 		= :li_cslib and 
             po 						= :ls_po and 
             co_fabrica_pt 		= :li_fabpt and
             co_linea 				= :li_lin and 
             co_referencia 		= :ll_ref and 
             co_color_pt 			= :ll_color and 
             tono 					= :ls_tono and
             cs_estilocolortono 	= :li_csest and
             cs_particion 			= :li_cspar   ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","Hubo un error al borrar los los tiempo.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
				
				
		//Parametros de entrada, fecha inicio y la cantidad de minutos disponibles en esa fecha.
		//Si el valor de los minutos es negativo se debe buscar los minutos en la tabla de 
		//calendario.
		
		li_secuenc = 0
			
		Do While ldc_pendiente > 0
			
			If ldc_mindspini > 0 And Truncate(ldc_mindspini / ldc_totmin,0) > 0 Then
				li_secuenc ++
				
				//Unidades disponibles inicial
				ldc_cnt = ldc_pendiente 
				//Unidades a programar dia
				ll_programado = Truncate(ldc_mindspini / ldc_totmin,0) 
				//Unidades posibles
				ll_undpsb = ll_programado 
				
				//Unidades disponibles final
				If ldc_pendiente >= ll_programado Then
					ldc_pendiente -= ll_programado 
				Else
					ll_programado = ldc_pendiente
					ldc_pendiente = 0
				End If
				
				//minutos disponibles final
				ldc_mindspfn = ldc_mindspini - (ll_programado * ldc_totmin)
				//Duracion  
				ll_duracion = Truncate(ll_programado * ldc_totmin,0)
				
				//Tiempo
				ldt_inicio = DateTime(ld_inicio,lt_hora)
				lt_hora = RelativeTime(lt_hora,ll_duracion * 60)
				lt_hora = RelativeTime(lt_hora,28600 )
				
				//agrego un dia a la fecha final y verifico que no sea festivo
				//modificado marzo 4 del 2003 por: juan carlos restrepo medina
				ld_inicio2 = ld_inicio
				//ld_inicio2 = RelativeDate(ld_inicio2,1)
				ll_buscar = ids_calendario.Find("fe_mod_calendario = date(~"" + String(ld_inicio2,"dd/mm/yyyy")+"~")",1,ids_calendario.RowCount())
				ls_festivo    = ids_calendario.GetItemString(ll_buscar,'co_tipo_dia')
				If ls_festivo <> 'F' Then
				Else 
					ld_inicio2 = RelativeDate(ld_inicio2,1)
				End if
				ldt_fin = DateTime(ld_inicio2,lt_hora)
				
				If li_secuenc = 1 Then 
					ldt_prdini = ldt_inicio
				End If

				ll_registro = ids_prog_diario.InsertRow(0)
				ids_prog_diario.SetItem(ll_registro,'simulacion', ai_simulacion)
				ids_prog_diario.SetItem(ll_registro,'co_fabrica', ai_fabrica)
				ids_prog_diario.SetItem(ll_registro,'co_planta', ai_planta)
				ids_prog_diario.SetItem(ll_registro,'co_modulo', ai_modulo)
				ids_prog_diario.SetItem(ll_registro,'co_fabrica_exp', li_fabexp)
				ids_prog_diario.SetItem(ll_registro,'pedido', ll_pedido)
				ids_prog_diario.SetItem(ll_registro,'cs_liberacion', li_cslib)
				ids_prog_diario.SetItem(ll_registro,'po', ls_po)
				ids_prog_diario.SetItem(ll_registro,'co_fabrica_pt', li_fabpt)
				ids_prog_diario.SetItem(ll_registro,'co_linea', li_lin)
				ids_prog_diario.SetItem(ll_registro,'co_referencia', ll_ref)
				ids_prog_diario.SetItem(ll_registro,'co_color_pt', ll_color)
				ids_prog_diario.SetItem(ll_registro,'tono', ls_tono)
				ids_prog_diario.SetItem(ll_registro,'cs_estilocolortono', li_csest)
				ids_prog_diario.SetItem(ll_registro,'cs_particion', li_cspar)
				ids_prog_diario.SetItem(ll_registro,'cs_fechas', li_secuenc)
				ids_prog_diario.SetItem(ll_registro,'fe_inicio', ldt_inicio)
				ids_prog_diario.SetItem(ll_registro,'ca_unid_dispon_ini', ldc_cnt)
				ids_prog_diario.SetItem(ll_registro,'ca_min_dispon_ini', ldc_mindspini)
				ids_prog_diario.SetItem(ll_registro,'ca_unid_dispon_fin', ldc_pendiente)
				ids_prog_diario.SetItem(ll_registro,'ca_min_dispon_fin', ldc_mindspfn)
				ids_prog_diario.SetItem(ll_registro,'personasxmodulo', 0)
				ids_prog_diario.SetItem(ll_registro,'dia_curva', 0)
				ids_prog_diario.SetItem(ll_registro,'porc_eficiencia', 0)
				ids_prog_diario.SetItem(ll_registro,'ca_unid_posibles', ll_undpsb)
				ids_prog_diario.SetItem(ll_registro,'duracion', ll_duracion)
				ids_prog_diario.SetItem(ll_registro,'fe_fin', ldt_fin)
				ids_prog_diario.SetItem(ll_registro,'ca_programada', ll_programado)
				ids_prog_diario.SetItem(ll_registro,'ca_producida', 0)
				ids_prog_diario.SetItem(ll_registro,'ca_pendiente', ll_programado)
				ids_prog_diario.SetItem(ll_registro,'co_est_prog_dia', 1)
				ids_prog_diario.SetItem(ll_registro,'fuente_dato', 1)
				ids_prog_diario.SetItem(ll_registro,'fe_creacion', f_fecha_servidor())
				ids_prog_diario.SetItem(ll_registro,'fe_actualizacion', f_fecha_servidor())
				ids_prog_diario.SetItem(ll_registro,'usuario', gstr_info_usuario.codigo_usuario)
				ids_prog_diario.SetItem(ll_registro,'instancia', gstr_info_usuario.instancia)
				ids_prog_diario.SetItem(ll_registro,'ca_proyectada', 0)
				ids_prog_diario.SetItem(ll_registro,'ca_actual', 0)
				ids_prog_diario.SetItem(ll_registro,'ca_numerada', 0)
				
//				insert into dt_programa_diario  
//	           ( simulacion,				co_fabrica,				co_planta,				co_modulo,
//				    co_fabrica_exp,			pedido,   				cs_liberacion,			po,
//					 co_fabrica_pt,			co_linea,				co_referencia,			co_color_pt,   
//	             tono,						cs_estilocolortono,	cs_particion,			cs_fechas,
//					 fe_inicio,					ca_unid_dispon_ini, 	ca_min_dispon_ini,	ca_unid_dispon_fin,
//					 ca_min_dispon_fin,		personasxmodulo,		dia_curva,				porc_eficiencia,
//					 ca_unid_posibles,		duracion,				fe_fin,					ca_programada,   
//	             ca_producida,				ca_pendiente,			co_est_prog_dia,		fuente_dato,
//					 fe_creacion,				fe_actualizacion,		usuario,					instancia,
//					 ca_proyectada,			ca_actual,				ca_numerada )  
//	         values ( 
//					:ai_simulacion,			:ai_fabrica,			:ai_planta,				:ai_modulo,
//					:li_fabexp,					:ll_pedido,   			:li_cslib,				:ls_po,
//					:li_fabpt,					:li_lin,					:ll_ref,					:ll_color,
//					:ls_tono,					:li_csest,				:li_cspar,				:li_secuenc,
//					:ldt_inicio,				:ldc_cnt,				:ldc_mindspini,		:ldc_pendiente,   
//	            :ldc_mindspfn,				0,							0,							0,
//					:ll_undpsb,					:ll_duracion,   		:ldt_fin,				:ll_programado,
//					0,								:ll_programado,		1,							1,
//					current,						current,					user,						sitename,
//					0,								0,							0 )  ;
//					 
//					 
//				If Sqlca.SqlCode = -1 Then
//					ls_sqlerr = Sqlca.SqlErrText
//					rollback ;
//					MessageBox("Advertencia!","Hubo un error al insertar los tiempos.~n~n~nNota: " + ls_sqlerr )
//					Return -1
//				End If
				
				If ldc_pendiente > 0 Then
					lt_hora = 00:00:00
					If This.Of_MinutosCalendario(ld_inicio,ldc_mindspini) = -1 Then
						rollback ;
						Return -1
					End If
				Else
					lt_hora = RelativeTime(lt_hora,1)
					ldc_mindspini = ldc_mindspfn
				End If
			Else
				If This.Of_MinutosCalendario(ld_inicio,ldc_mindspini) = -1 Then
					rollback ;
					Return -1
				End If
			End If
		Loop
		
		ll_registro = adw_produccion.Find("simulacion = " + String(ai_simulacion) &
			 +" And co_fabrica = "+String(ai_fabrica)+" And co_planta = "+string(ai_planta) &
			 +" And co_modulo = "+String(ai_modulo)+" And co_fabrica_exp = "+String(li_fabexp) &
			 +" And pedido = "+String(ll_pedido)+" And cs_liberacion = "+String(li_cslib) &
			 +" And po = '"+ls_po+"' And co_fabrica_pt = "+String(li_fabpt) &
			 +" And co_linea = "+String(li_lin)+" And co_referencia = " + String(ll_ref) &
			 +" And co_color_pt = "+String(ll_color)+" And tono = " + String(ls_tono) &
			 +" And cs_estilocolortono = "+String(li_csest)+" And cs_particion = "+String(li_cspar) &
			,1,adw_produccion.RowCount()+1)
		Do While ll_registro > 0
			adw_produccion.SetItem(ll_registro,"fe_inicio_prog", ldt_prdini)
			adw_produccion.SetItem(ll_registro,"fe_fin_prog", ldt_fin)
			adw_produccion.SetItem(ll_registro,"ca_minutos_std", ldc_totmin)
			
			ll_registro++	
			ll_registro = adw_produccion.Find("simulacion = " + String(ai_simulacion) &
				 +" And co_fabrica = "+String(ai_fabrica)+" And co_planta = "+string(ai_planta) &
				 +" And co_modulo = "+String(ai_modulo)+" And co_fabrica_exp = "+String(li_fabexp) &
				 +" And pedido = "+String(ll_pedido)+" And cs_liberacion = "+String(li_cslib) &
				 +" And po = '"+ls_po+"' And co_fabrica_pt = "+String(li_fabpt) &
				 +" And co_linea = "+String(li_lin)+" And co_referencia = " + String(ll_ref) &
				 +" And co_color_pt = "+String(ll_color)+" And tono = " + String(ls_tono) &
				 +" And cs_estilocolortono = "+String(li_csest)+" And cs_particion = "+String(li_cspar) &
				,ll_registro,adw_produccion.RowCount()+1)
		Loop

//		update dt_pdnxmodulo  
//         set fe_inicio_prog 	= :ldt_prdini,   
//             fe_fin_prog 		= :ldt_fin,   
//             ca_minutos_std 	= :ldc_totmin  
//       where simulacion 			= :ai_simulacion and
//             co_fabrica 			= :ai_fabrica and
//             co_planta 				= :ai_planta and
//             co_modulo 				= :ai_modulo and  
//             co_fabrica_exp 		= :li_fabexp and
//             pedido 					= :ll_pedido and  
//             cs_liberacion 		= :li_cslib and 
//             po 						= :ls_po and 
//             co_fabrica_pt 		= :li_fabpt and
//             co_linea 				= :li_lin and 
//             co_referencia 		= :ll_ref and 
//             co_color_pt 			= :ll_color and 
//             tono 					= :ls_tono and
//             cs_estilocolortono 	= :li_csest and
//             cs_particion 			= :li_cspar   ;
//				 
//		If Sqlca.SqlCode = -1 Then
//			ls_sqlerr = Sqlca.SqlErrText
//			rollback ;
//			MessageBox("Advertencia!","Hubo un error al insertar los tiempos.~n~n~nNota: " + ls_sqlerr )
//			Return -1
//		End If
	Else//ll_result > 0
		//Rollback;
		
		select de_linea
		into :ls_linea
		from m_lineas
		where co_fabrica 	= :li_fabpt and
				co_linea 	= :li_lin;
				
		select de_estilo
		into :ls_estilo
		from m_estilos
		where co_tipoprod = 1 and
				co_estilo 	= :li_estilo;
				
		MessageBox('Error','No existen minutos por prenda asociados a la prenda '+Trim(ls_linea)+' tela '+Trim(ls_estilo))
		Return -1
		 
	End If//ll_result > 0

Next

Destroy ids_calendario
Destroy lds_produccion
Destroy lds_minxprenda
Destroy lds_fechainici

Return 0
end function

public function long of_update (ref uo_dtwndow adw_produccion);/*	---------------------------------------------------------------------
	Funcion que actualiza los datastore de procesos y programacion diaria 
	que fueron creados durante la existencia del objeto.
	---------------------------------------------------------------------*/
If ids_procesos.Update() > 0 Then
	If ids_prog_diario.Update() > 0 Then
		If adw_produccion.Update() > 0 Then
			Commit;
		Else
			Return -1
		End If
	Else
		Return -1
	End If
Else
	Return -1
End If

Return 1
end function

on n_cts_corte_copia.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_corte_copia.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//	Utilizado para insertar los nuevos procesos
ids_procesos = Create uo_dsbase
ids_procesos.DataObject = 'd_procesos'
ids_procesos.SetTransObject(Sqlca)

//	Utilizado para para insertar la programacion diaria
ids_prog_diario = Create uo_dsbase
ids_prog_diario.DataObject = 'd_programa_diario'
ids_prog_diario.SetTransObject(Sqlca)

end event

