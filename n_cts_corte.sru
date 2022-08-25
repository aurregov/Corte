HA$PBExportHeader$n_cts_corte.sru
forward
global type n_cts_corte from nonvisualobject
end type
end forward

global type n_cts_corte from nonvisualobject
end type
global n_cts_corte n_cts_corte

type variables
Datastore ids_calendario
end variables

forward prototypes
public function long of_minutoscalendario (ref date an_inicio, ref decimal adc_mindspini)
public function long of_metodominutos (long ai_simulacion, long ai_fabrica, long ai_planta, long ai_modulo, long ai_prioridad, date ad_inicio)
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

public function long of_metodominutos (long ai_simulacion, long ai_fabrica, long ai_planta, long ai_modulo, long ai_prioridad, date ad_inicio);Datastore lds_produccion,lds_minxprenda,lds_fechainici
Long     ll_i,ll_j,ll_pedido,ll_ref,ll_result,ll_flfnd,&
         ll_programado,ll_duracion,ll_undpsb,ll_buscar, ll_col
Long  li_fabexp,li_cslib,li_fabpt,li_lin,li_csest,li_cspar,li_estilo,&
         li_tpprod,li_centro,li_subcentro,li_proceso,li_secuenc
String   ls_po,ls_tono,ls_sqlerr
Decimal  ldc_totmin,ldc_min,ldc_pendiente,ldc_cnt,ldc_mindspini,ldc_mindspfn
Date     ld_inicio,ld_inicio2
DateTime ldt_fin,ldt_inicio,ldt_prdini
Time     lt_hora
String 	ls_linea,ls_estilo,ls_festivo, ls_cut
Long  li_extender, li_registros, li_planta
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_extender = luo_constantes.of_consultar_numerico("EXTENDER")

IF li_extender = -1 THEN
	Return -1
END IF

// Definicion de los datastore para la manipulacion de los datos
ids_calendario = Create Datastore
lds_produccion = Create Datastore
lds_minxprenda = Create Datastore
lds_fechainici = Create Datastore

ids_calendario.DataObject = 'd_lista_calendario'
lds_produccion.DataObject = 'd_lista_prod_x_programar'
lds_minxprenda.DataObject = 'd_lista_minxprenda'
lds_fechainici.DataObject = 'd_fecha_inicial'

ids_calendario.SetTransObject(Sqlca)
lds_produccion.SetTransObject(Sqlca)
lds_minxprenda.SetTransObject(Sqlca)
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


//Se recupera el calendario
ll_result = ids_calendario.Retrieve(ai_fabrica,ai_planta,ai_modulo,ad_inicio)

//Recupero la produccio a la cual se le programara el tiempo	
li_registros = lds_produccion.Retrieve(ai_simulacion,ai_fabrica,ai_planta,ai_modulo,ai_prioridad)


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
	li_cslib  		= lds_produccion.GetitemNumber(ll_i,"cs_liberacion")   
	ls_po     		= lds_produccion.GetitemString(ll_i,"po")   
	ls_cut			= lds_produccion.GetItemString(ll_i,"nu_cut")
	li_fabpt  		= lds_produccion.GetitemNumber(ll_i,"co_fabrica_pt")   
	li_lin    		= lds_produccion.GetitemNumber(ll_i,"co_linea")   
	ll_ref    		= lds_produccion.GetitemNumber(ll_i,"co_referencia")   
	ll_col    		= lds_produccion.GetitemNumber(ll_i,"co_color_pt")   
	ls_tono   		= lds_produccion.GetitemString(ll_i,"tono")   
	li_cspar	 		= lds_produccion.GetitemNumber(ll_i,"cs_particion")
	li_estilo 		= lds_produccion.GetitemNumber(ll_i,"co_estilo")
	ldc_pendiente 	= lds_produccion.GetitemDecimal(ll_i,"ca_pendiente")

	IF li_fabpt = 4 THEN
		li_planta = 1
	ELSE
		li_planta = 2
	END IF
	
	ll_result = lds_minxprenda.Retrieve(li_tpprod,li_centro,li_fabpt,li_lin,ll_ref,li_planta)
	
	If ll_result > 0 Then
		
		//Borro los anteriores procesos
		delete from dt_procesos_plan  
       where simulacion 			= :ai_simulacion and 
             co_fabrica 			= :ai_fabrica and
             co_planta 				= :ai_planta and
             co_modulo 				= :ai_modulo and 
             co_fabrica_exp 		= :li_fabexp and 
             cs_liberacion 		= :li_cslib and  
             po 						= :ls_po and
				 nu_cut					= :ls_cut and
             co_fabrica_pt 		= :li_fabpt and 
             co_linea 				= :li_lin and
             co_referencia 		= :ll_ref and 
             co_color_pt 			= :ll_col and
             tono 					= :ls_tono and
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
			li_proceso = lds_minxprenda.GetItemNumber(ll_j,'co_operacion')
			ldc_min    = lds_minxprenda.GetItemDecimal(ll_j,'tiempo_st')
								
			ldc_cnt = ldc_pendiente * ldc_min
								
			insert into dt_procesos_plan  
            ( 	simulacion,				co_fabrica,				co_planta,				co_modulo,
					co_fabrica_exp, 		cs_liberacion,			po,						nu_cut,
					co_fabrica_pt,			co_linea,   			co_referencia,			co_color_pt,
					tono,						cs_particion, 			co_proces,
					cs_proceso,				co_metodo_programa,	co_consumo_proceso,	ca_consumo_estimad,   
              	unidad_consum_est,	estandar_consumo,		unidade_consum_std,	fe_creacion,   
              	fe_actualizacion,		usuario,					instancia )  
         values ( 
					:ai_simulacion,		:ai_fabrica,			:ai_planta,				:ai_modulo,
					:li_fabexp,   			:li_cslib,				:ls_po,					:ls_cut,
					:li_fabpt,				:li_lin,					:ll_ref,					:ll_col,   
              	:ls_tono,				:li_cspar,				:li_proceso,
					:li_secuenc,			1,							1,							:ldc_cnt,   
              	1,							:ldc_min,				1,							current,
					current,					user,						sitename )  ;
		
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				MessageBox("Advertencia!","Hubo un error al insertar el proceso.~n~n~nNota: " + ls_sqlerr )
				Return -1
			End If
			
			//solo tiene en cuenta el tiempo para el extendido
			If li_proceso <> li_extender Then ldc_min = 0
			
			ldc_totmin += ldc_min
			
		Next	
		
		//Borro si ya tiene tiempo programado
		delete from  dt_programa_diario  
       where simulacion 			= :ai_simulacion and
             co_fabrica 			= :ai_fabrica and
             co_planta 				= :ai_planta and
             co_modulo 				= :ai_modulo and  
             co_fabrica_exp 		= :li_fabexp and
             cs_liberacion 		= :li_cslib and 
             po 						= :ls_po and 
				 nu_cut					= :ls_cut and
             co_fabrica_pt 		= :li_fabpt and
             co_linea 				= :li_lin and 
             co_referencia 		= :ll_ref and 
             co_color_pt 			= :ll_col and 
             tono 					= :ls_tono and
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
				
				insert into dt_programa_diario  
	           ( simulacion,				co_fabrica,				co_planta,				co_modulo,
				    co_fabrica_exp,			cs_liberacion,			po,						nu_cut,
					 co_fabrica_pt,			co_linea,				co_referencia,			co_color_pt,   
	             tono,						cs_particion,			cs_fechas,
					 fe_inicio,					ca_unid_dispon_ini, 	ca_min_dispon_ini,	ca_unid_dispon_fin,
					 ca_min_dispon_fin,		personasxmodulo,		dia_curva,				porc_eficiencia,
					 ca_unid_posibles,		duracion,				fe_fin,					ca_programada,   
	             ca_producida,				ca_pendiente,			co_est_prog_dia,		fuente_dato,
					 fe_creacion,				fe_actualizacion,		usuario,					instancia,
					 ca_proyectada,			ca_actual,				ca_numerada )  
	         values ( 
					:ai_simulacion,			:ai_fabrica,			:ai_planta,				:ai_modulo,
					:li_fabexp,					:li_cslib,				:ls_po,					:ls_cut,
					:li_fabpt,					:li_lin,					:ll_ref,					:ll_col,
					:ls_tono,					:li_cspar,				:li_secuenc,
					:ldt_inicio,				:ldc_cnt,				:ldc_mindspini,		:ldc_pendiente,   
	            :ldc_mindspfn,				0,							0,							0,
					:ll_undpsb,					:ll_duracion,   		:ldt_fin,				:ll_programado,
					0,								:ll_programado,		1,							1,
					current,						current,					user,						sitename,
					0,								0,							0 )  ;
					 
					 
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ;
					MessageBox("Advertencia!","Hubo un error al insertar los tiempos.~n~n~nNota: " + ls_sqlerr )
					Return -1
				End If
				
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
		
		update dt_pdnxmodulo  
         set fe_inicio_prog 	= :ldt_prdini,   
             fe_fin_prog 		= :ldt_fin,   
             ca_minutos_std 	= :ldc_totmin  
       where simulacion 			= :ai_simulacion and
             co_fabrica 			= :ai_fabrica and
             co_planta 				= :ai_planta and
             co_modulo 				= :ai_modulo and  
             co_fabrica_exp 		= :li_fabexp and
             cs_liberacion 		= :li_cslib and 
             po 						= :ls_po and 
				 nu_cut					= :ls_cut and
             co_fabrica_pt 		= :li_fabpt and
             co_linea 				= :li_lin and 
             co_referencia 		= :ll_ref and 
             co_color_pt 			= :ll_col and 
             tono 					= :ls_tono and
             cs_particion 			= :li_cspar   ;
				 
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","Hubo un error al insertar los tiempos.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
	Else//ll_result > 0
		//Rollback;
		
		select de_linea
		into :ls_linea
		from m_lineas
		where co_fabrica 	= :li_fabpt and
				co_linea 	= :li_lin;
		
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar la descripci$$HEX1$$f300$$ENDHEX$$n de la l$$HEX1$$ed00$$ENDHEX$$nea " + SQLCA.SQLErrText)
			Return -1
		END IF
				
		select de_referencia
		into :ls_estilo
		from h_preref_pv
		where co_fabrica = :li_fabpt and
				co_linea = :li_lin and
				(Cast(:ll_ref as char(15) ) = h_preref_pv.co_referencia ) and
				co_tipo_ref = 'P';
				
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar la descripci$$HEX1$$f300$$ENDHEX$$n de la referencia " + SQLCA.SQLErrText)
			Return -1
		END IF
				
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

on n_cts_corte.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_corte.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

