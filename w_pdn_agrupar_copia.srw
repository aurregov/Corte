HA$PBExportHeader$w_pdn_agrupar_copia.srw
forward
global type w_pdn_agrupar_copia from w_base_simple
end type
end forward

global type w_pdn_agrupar_copia from w_base_simple
integer width = 3685
integer height = 2148
string title = "Agrupaci$$HEX1$$f300$$ENDHEX$$n Producci$$HEX1$$f300$$ENDHEX$$n"
string menuname = "m_mantenimiento_asignacion_trazos"
windowstate windowstate = maximized!
event type long ue_postopen ( )
event type long ue_select ( long ai_select )
event type long ue_trazos ( )
event type long ue_borrar ( )
event ue_partir ( )
end type
global w_pdn_agrupar_copia w_pdn_agrupar_copia

type variables
Boolean ib_trazo = False
Long il_fila
Long ii_sw_estado
uo_dsbase ids_pdnagrupa
end variables

forward prototypes
public function long of_detalletrazo (long an_agrupa)
public function long of_crearagrupa ()
public function long of_orden_corte ()
public function long of_borraragrupa (long an_fila)
end prototypes

event type long ue_postopen();/*	---------------------------------------------------------------------
	Crea un objeto de transaccion y se conecta a la BD en modo dirty read;
	hace la lectura inicial de la pantalla en un datastore que utiliza 
	el objeto de transaccion creado.   Luego los datos traidos por 
	el datastore son copiados al dw_maestro de la ventana.
	---------------------------------------------------------------------*/
Transaction	itr_tela
uo_dsbase lds_pdn

//itr_tela 				= 	Create Transaction
//itr_tela.DBMS			=	SQLCA.DBMS
//itr_tela.DATABASE		=	SQLCA.DATABASE
//itr_tela.USERID		=	SQLCA.USERID
//itr_tela.DBPASS		=	SQLCA.DBPASS
//itr_tela.DBPARM		=	SQLCA.DBPARM
//itr_tela.ServerName 	= 	SQLCA.SERVERNAME
//itr_tela.Lock 			= 	"Dirty read"
//
//CONNECT USING itr_tela;
//IF itr_tela.SQLCODE = -1 THEN
//   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
//   Return -1
//END IF
//
//lds_pdn = Create uo_dsbase
//lds_pdn.DataObject = "d_lista_pdn_a_agrupar"
//lds_pdn.SetTransObject(itr_tela)
//lds_pdn.Retrieve(1,91,1,701)
//dw_maestro.Object.Data = lds_pdn.Object.Data
//dw_maestro.ResetUpdate()
//
//DISCONNECT USING itr_tela ;
//IF itr_tela.SQLCODE = -1 THEN
//   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
//   Return -2
//END IF
//
//Destroy lds_pdn
Return 1
end event

event type long ue_select(long ai_select);/*	---------------------------------------------------------------------
	Evento que selecciona o quita la seleccion de cada registro modificando
	el estado de asignacion de cada registro.
	---------------------------------------------------------------------*/
Long li_i,li_sw

li_sw = 1

If ai_select = 1 Then li_sw = 2

For li_i = 1 To dw_maestro.RowCount()
	If dw_maestro.GetItemNumber(li_i,'sw_estado') = 1 Then
		dw_maestro.SetItem(li_i,'co_estado_asigna',li_sw)
	End If
Next

Return 1
end event

event type long ue_trazos();Long   	ll_fila,ll_fab,ll_pedido,ll_ref,ll_filins,ll_agrupa,ll_rseult, ll_color
Int    	li_lib,li_fabpt,li_lin,li_csest,li_cspar,li_priori,li_simulacion
Long 	li_fab,li_planta
LONG		li_mod
String 	ls_po,ls_tono,ls_mensaje,ls_sqlerr,ls_instruccion
DATE	 	ld_fecha	

n_cts_corte_una_copia luo_corte

luo_corte = Create n_cts_corte_una_copia

//-------------------------  limpia ids_pdnagrupa ----------------------//
ids_pdnagrupa.Reset()

//-------------------------  valida que tenga filas seleccionadas -----//
If dw_maestro.GetSelectedRow(0) <= 0 Then 
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar las producciones que desea agrupar.")
	Return -1
End If

ll_fila = 0
//------------------  ciclo para cargar ids_pdnagrupa con selecc. de dw_maestro -----------//
Do 
	ll_fila = dw_maestro.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then
		//----------------------  valida que estado = 1 -------------------------------//
		If dw_maestro.GetItemNumber(ll_fila,'sw_estado') <> 1 Then
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no puede ser agrupada." )
			Return -2
		Else
			li_simulacion	= dw_maestro.GetItemNumber(ll_fila,'simulacion')
			ll_fab    		= dw_maestro.GetItemNumber(ll_fila,'co_fabrica_exp')
			ll_pedido 		= dw_maestro.GetItemNumber(ll_fila,'pedido')
			li_lib   		= dw_maestro.GetItemNumber(ll_fila,'cs_liberacion')
			ls_po    		= dw_maestro.GetItemString(ll_fila,'po')
			li_fabpt 		= dw_maestro.GetItemNumber(ll_fila,'co_fabrica_pt')
			li_lin   		= dw_maestro.GetItemNumber(ll_fila,'co_linea')
			ll_ref   		= dw_maestro.GetItemNumber(ll_fila,'co_referencia')
			ll_color 		= dw_maestro.GetItemNumber(ll_fila,'co_color_pt')
			li_csest 		= dw_maestro.GetItemNumber(ll_fila,'cs_estilocolortono')
			li_cspar 		= dw_maestro.GetItemNumber(ll_fila,'cs_particion')
			ls_tono  		= dw_maestro.GetItemString(ll_fila,'tono')
			li_priori		= dw_maestro.GetItemNumber(ll_fila,'cs_prioridad')
			li_fab   		= dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
			li_planta		= dw_maestro.GetItemNumber(ll_fila,'co_planta')
			li_mod			= dw_maestro.GetItemNumber(ll_fila,'co_modulo')
	
			dw_maestro.SetItem(ll_fila,'co_estado_asigna',3)
			
			ll_filins = ids_pdnagrupa.InsertRow(0)
			
			ids_pdnagrupa.SetItem(ll_filins,'co_fabrica_exp',ll_fab)
			ids_pdnagrupa.SetItem(ll_filins,'pedido',ll_pedido)
			ids_pdnagrupa.SetItem(ll_filins,'cs_liberacion',li_lib)
			ids_pdnagrupa.SetItem(ll_filins,'po',ls_po)
			ids_pdnagrupa.SetItem(ll_filins,'co_fabrica_pt',li_fabpt)
			ids_pdnagrupa.SetItem(ll_filins,'co_linea',li_lin)
			ids_pdnagrupa.SetItem(ll_filins,'co_referencia',ll_ref)
			ids_pdnagrupa.SetItem(ll_filins,'co_color_pt',ll_color)
			ids_pdnagrupa.SetItem(ll_filins,'cs_estilocolortono',li_csest)
			ids_pdnagrupa.SetItem(ll_filins,'cs_particion',li_cspar)
			ids_pdnagrupa.SetItem(ll_filins,'tono',ls_tono)
			ids_pdnagrupa.SetItem(ll_filins,'ca_unidades',dw_maestro.GetItemNumber(ll_fila,'ca_programada'))
			ids_pdnagrupa.SetItem(ll_filins,'de_linea',dw_maestro.GetItemString(ll_fila,'de_linea'))
			ids_pdnagrupa.SetItem(ll_filins,'de_referencia',dw_maestro.GetItemString(ll_fila,'de_referencia'))
			ids_pdnagrupa.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
			ids_pdnagrupa.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)
			
			//inicio de programa fechas
			
			////--------------------------------------
			////calculos las fechas de programaci$$HEX1$$f300$$ENDHEX$$n
			////--------------------------------------
			//						
			If li_priori > 1 Then
				select max(Date(dt_programa_diario.fe_inicio)) 
				  into :ld_fecha
				from dt_pdnxmodulo,   
					  dt_programa_diario  
			  where ( dt_programa_diario.simulacion 			= dt_pdnxmodulo.simulacion ) and  
					  ( dt_programa_diario.co_fabrica 			= dt_pdnxmodulo.co_fabrica ) and  
					  ( dt_programa_diario.co_planta  			= dt_pdnxmodulo.co_planta ) and  
					  ( dt_programa_diario.co_modulo  			= dt_pdnxmodulo.co_modulo ) and  
					  ( dt_programa_diario.co_fabrica_exp 		= dt_pdnxmodulo.co_fabrica_exp ) and  
					  ( dt_programa_diario.pedido 				= dt_pdnxmodulo.pedido ) and  
					  ( dt_programa_diario.cs_liberacion 		= dt_pdnxmodulo.cs_liberacion ) and  
					  ( dt_programa_diario.po 						= dt_pdnxmodulo.po ) and  
					  ( dt_programa_diario.co_fabrica_pt 		= dt_pdnxmodulo.co_fabrica_pt ) and  
					  ( dt_programa_diario.co_linea 				= dt_pdnxmodulo.co_linea ) and  
					  ( dt_programa_diario.co_referencia 		= dt_pdnxmodulo.co_referencia ) and  
					  ( dt_programa_diario.co_color_pt 			= dt_pdnxmodulo.co_color_pt ) and  
					  ( dt_programa_diario.tono 					= dt_pdnxmodulo.tono ) and  
					  ( dt_programa_diario.cs_estilocolortono = dt_pdnxmodulo.cs_estilocolortono ) and  
					  ( dt_programa_diario.cs_particion 		= dt_pdnxmodulo.cs_particion ) and  
					  ( dt_pdnxmodulo.simulacion 					= 1 ) and  
					  ( dt_pdnxmodulo.co_fabrica 					= :li_fabpt ) and  
					  ( dt_pdnxmodulo.co_planta  					= :li_planta ) and 
					  ( dt_pdnxmodulo.co_modulo  					= :li_mod ) and  
					  ( dt_pdnxmodulo.cs_prioridad 				= :li_priori -1 )  ;
												  
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					MessageBox("Advertencia!","Hubo un error al buscar la fecha de inicio.~n~n~nNota: " + ls_sqlerr )
					Return -3
				End If
				
				If IsNull(ld_fecha) Then
					ld_fecha = Date(f_fecha_servidor())
				End IF
			Else
				ld_fecha = Date(f_fecha_servidor())
			End If
			
			If luo_corte.Of_MetodoMinutos(1,li_fab,li_planta,li_mod,li_priori,ld_fecha,dw_maestro) = -1 Then
				Rollback;
				Return -4
			End if
			//fin de programa fechas
		End If
	End If
loop Until ll_fila = 0

//	Actualiza todas las modificaciones hechas hasta este momento:
//	Inserta nuevos procesos, programacion diaria y nuevas fechas de inicio, fin y 
//	cantidad de minutos en dw_maestro
If luo_corte.Of_Update(dw_maestro) < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la actualizaci$$HEX1$$f300$$ENDHEX$$n de la programacion diaria y los procesos.")
	Return -5
End If

COMMIT;

//------------------ si cargo ids_pdnagrupa ----------------------------//
If ids_pdnagrupa.RowCount() > 0 Then
	//pregunta si crea a add a agrupacion -------------------//
	ls_mensaje = "$$HEX1$$bf00$$ENDHEX$$Desea crear una nueva agrupaci$$HEX1$$f300$$ENDHEX$$n?~n~nSi responde que no, inmediatamente despues debe seleccionar una producci$$HEX1$$f300$$ENDHEX$$n con una agrupaci$$HEX1$$f300$$ENDHEX$$n valida."
	ll_rseult = MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!",ls_mensaje,Question!,YesNoCancel!)
	//-------------  si desea crear agrupacion -------------------------------//
	If ll_rseult = 1 Then
		ll_agrupa = of_CrearAgrupa()
		
		MessageBox('Agrupacion',String(ll_agrupa))
		
		If ll_agrupa > 0 Then 
			If Of_detalleTrazo(ll_agrupa) > 0 Then 
				commit ;
				MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
				dw_maestro.Retrieve(1,91,1,701)
			Else
				//coloca en estado 1
				This.Dynamic Trigger Event ue_select(2)
			End If
		End If
	ElseIf ll_rseult = 2 Then  //desea add a agrupacion existente
		ib_trazo = True
	Else
		//coloca en estado 1
		This.Dynamic Trigger Event ue_select(2)
	End If
End If

//se genera el n$$HEX1$$fa00$$ENDHEX$$mero de orden de corte para la nueva agrupacion creada
//realizado por juan carlos restrepo abril 25 de 2003
If ib_trazo = False Then
	If of_orden_corte() < 0 Then Return -6
	dw_maestro.Retrieve(1,91,1,701)
End if
//fin de la modificacion jcrm

Destroy luo_corte

Return 1
end event

event type long ue_borrar();Long   ll_fila,ll_fab,ll_pdn,ll_ref,ll_filins,ll_agrupa,ll_rseult, ll_agrupacion[], ll_color
Int    li_lib,li_fabpt,li_lin,li_csest,li_cspar, li_contador
String ls_po,ls_tono,ls_mensaje



//-----------  valida que existan producciones seleccionadas --------------------------//
If dw_maestro.GetSelectedRow(0) <= 0 Then 
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar las producciones que desea desagrupar.")
	Return -1
End If

//ls_mensaje = "$$HEX1$$bf00$$ENDHEX$$Desea crear una nueva agrupaci$$HEX1$$f300$$ENDHEX$$n?~n~nSi responde que no, inmediatamente despues debe seleccionar una producci$$HEX1$$f300$$ENDHEX$$n con una agrupaci$$HEX1$$f300$$ENDHEX$$n valida."


ll_fila = 0
//---------------------- ciclo para validar que las pdnes sean validas ----------------//
Do 
	ll_fila = dw_maestro.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then
		If dw_maestro.GetItemNumber(ll_fila,'sw_estado') > 3 Then
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no puede ser desagrupada." )
			Return -2
		Else
			
			ll_agrupa = dw_maestro.GetItemNumber(ll_fila,'cs_agrupacion')
			ll_pdn    = dw_maestro.GetItemNumber(ll_fila,'cs_pdn')
			
			If IsNull(ll_agrupa) Then
				MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no es valida." )
				Return -3
			End If
			
			If IsNull(ll_pdn) Then
				MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no es valida." )
				Return -4
			End If
			//	Almacena las agrupaciones encontradas que se desea desagrupar
			If UpperBound(ll_agrupacion) = 0 Then
				ll_agrupacion[1] = ll_agrupa
			Else
				ll_agrupacion[UpperBound(ll_agrupacion)+1] = ll_agrupa
			End If
		End If
	End If
loop Until ll_fila = 0

//	Borra toda la informacion relacionada con las agrupaciones seleccionadas
//	de las tablas : dt_trazosxbase, dt_escalaxpdnbase, dt_pdnxbase, dt_rayas_telaxbase, 
//	h_base_trazos, dt_agrupa_pdn_raya, dt_agrupaescalapdn, dt_agrupa_pdn, h_agrupa_pdn
For li_contador = 1 To UpperBound(ll_agrupacion)
	If Of_BorrarAgrupa(ll_agrupacion[li_contador]) = -1 Then Return -5
Next
ll_fila = 0

//	Las producciones seleccionadas son desagrupadas
Do While dw_maestro.GetSelectedRow(ll_fila) > 0
	ll_fila = dw_maestro.GetSelectedRow(ll_fila)
	dw_maestro.SetItem(ll_fila,"co_estado_asigna",1)
	dw_maestro.SetItem(ll_fila,"cs_asignacion",1)		
loop 

//	Actualiza las producciones desagrupadas en la B.D.
If dw_maestro.Update() > 0 Then
	Commit;
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Se borraron las agrupaciones con exito." )
Else
	RollBack;
	MessageBox("Advertencia!","No se pudo borrar los trazos para esta agrupaci$$HEX1$$f300$$ENDHEX$$n.")
	Return -6
End If

//ll_fila = 0
////--------------------- ciclo para borrar pdnes seleccionadas -------------------//
//Do 
//	ll_fila = dw_maestro.GetSelectedRow(ll_fila)
//	
//	If ll_fila > 0 Then
//
//		If Of_BorrarAgrupa(ll_fila) = -1 Then Return -5
//	End If
//loop Until ll_fila = 0
//commit ;

//MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Se borraron las agrupaciones con exito." )

//----------------------------- retrieve con modulo 701  --------------------------//
dw_maestro.Retrieve(1,91,1,701)

Return 1
end event

event ue_partir();//Long ll_fila,ll_i
//
//dw_pdn.AccepTText()
//   	
//ll_fila = dw_pdn.GetRow()		
		
If il_fila > 0 Then

	If of_particion(dw_maestro,il_fila) = 0 Then
		commit ;
	Else		
		rollback ; 
	End If
	//-----------------------------  retrieve con modulo 701 ---------------------------//
	dw_maestro.Retrieve(1,91,1,701)
Else
	MessageBox('Advertencia','No se ha seleccionado el registro a particionar')
End if

end event

public function long of_detalletrazo (long an_agrupa);uo_dsbase lds_tallas,lds_rayas,lds_colmod,lds_pdntz,lds_tlltz, &
			 lds_dt_agrupaescalapdn, lds_dt_agrupa_pdn_raya, lds_h_base_trazos, &
			 lds_dt_rayas_telaxbase, lds_dt_pdnxbase, lds_dt_escalaxpdnbase
DataWindow ldw_datos
Long    ll_cspdn,ll_ref,ll_j,ll_cnt,ll_modulo,ll_raya,ll_fab,ll_pedido,ll_base,&
        ll_result,ll_modelo,ll_reftl,ll_carac,ll_diam,ll_color,ll_found,&
		  ll_bsins,ll_unid, ll_registro, ll_co_color
Long li_i,li_tipo,li_lib,li_fabpt,li_lin,li_csest,li_cspar,&
        li_talla,li_csorden,li_raya,li_ryax,li_fabtl
String  ls_sqlerr,ls_po,ls_tono

lds_dt_agrupaescalapdn = Create uo_dsbase
lds_dt_agrupaescalapdn.DataObject = "d_insercion_dt_agrupaescalapdn"
lds_dt_agrupaescalapdn.SetTransObject(SQLCA)

lds_dt_agrupa_pdn_raya = Create uo_dsbase
lds_dt_agrupa_pdn_raya.DataObject = "d_insercion_dt_agrupa_pdn_raya"
lds_dt_agrupa_pdn_raya.SetTransObject(SQLCA)

lds_h_base_trazos = Create uo_dsbase
lds_h_base_trazos.DataObject = "d_insercion_h_base_trazos"
lds_h_base_trazos.SetTransObject(SQLCA)

lds_dt_rayas_telaxbase = Create uo_dsbase
lds_dt_rayas_telaxbase.DataObject = "d_insercion_dt_rayas_telaxbase"
lds_dt_rayas_telaxbase.SetTransObject(SQLCA)

lds_dt_pdnxbase = Create uo_dsbase
lds_dt_pdnxbase.DataObject = "d_insercion_dt_pdnxbase"
lds_dt_pdnxbase.SetTransObject(SQLCA)

lds_dt_escalaxpdnbase = Create uo_dsbase
lds_dt_escalaxpdnbase.DataObject = "d_insercion_dt_escalaxpdnbase"
lds_dt_escalaxpdnbase.SetTransObject(SQLCA)


//------------------------------  crea datastores
lds_tallas = Create uo_dsbase
lds_rayas  = Create uo_dsbase
lds_colmod = Create uo_dsbase
lds_pdntz  = Create uo_dsbase
lds_tlltz  = Create uo_dsbase

//------------------------------  asigna datastores
lds_tallas.DataObject 	= 'd_lista_tallas_produccion'
lds_rayas.DataObject  	= 'd_lista_modelos_x_talla'
lds_colmod.DataObject 	= 'd_lista_color_modelo'
lds_pdntz.DataObject 	= 'd_lista_trazos_produccion'
lds_tlltz.DataObject 	= 'd_lista_trazo_tallas_x_produccion'

lds_tallas.SetTransObject(Sqlca)
lds_rayas.SetTransObject(Sqlca)
lds_colmod.SetTransObject(Sqlca)
lds_pdntz.SetTransObject(Sqlca)
lds_tlltz.SetTransObject(Sqlca)

//--------------------- busca max pdn de agrupacion
select max(cs_pdn)  
  into :ll_cspdn  
  from dt_agrupa_pdn  
 where cs_agrupacion = :an_agrupa   ;
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo obtener el consecutivo de la agrupaci$$HEX1$$f300$$ENDHEX$$n # " + String(an_agrupa) + ".~n~n~nNota: " + ls_sqlerr )
	Return -1
ElseIf IsNull(ll_cspdn) Then
	ll_cspdn = 0
End If

//---- coloca agrupacion y consecutivo de pdns en agrupacion a pdns
For li_i = 1 To ids_pdnagrupa.RowCount()
	ll_cspdn ++	
	ids_pdnagrupa.SetItem(li_i,'cs_agrupacion',an_agrupa)
	ids_pdnagrupa.SetItem(li_i,'cs_pdn',ll_cspdn)
Next

ids_pdnagrupa.AcceptText()

//----------------------------------- graba ids_pdnagrupa
If ids_pdnagrupa.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo grabar la producci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//---------------------------------------- recorre dt_pdnagrupa para insert tallas y rayas
For li_i = 1 To  ids_pdnagrupa.RowCount()

	ll_fab    	= ids_pdnagrupa.GetItemNumber(li_i,'co_fabrica_exp')
	ll_pedido 	= ids_pdnagrupa.GetItemNumber(li_i,'pedido')
	li_lib   	= ids_pdnagrupa.GetItemNumber(li_i,'cs_liberacion')
	ls_po    	= ids_pdnagrupa.GetItemString(li_i,'po')
	li_fabpt 	= ids_pdnagrupa.GetItemNumber(li_i,'co_fabrica_pt')
	li_lin   	= ids_pdnagrupa.GetItemNumber(li_i,'co_linea')
	ll_ref   	= ids_pdnagrupa.GetItemNumber(li_i,'co_referencia')
	ll_co_color 	= ids_pdnagrupa.GetItemNumber(li_i,'co_color_pt')
	li_csest 	= ids_pdnagrupa.GetItemNumber(li_i,'cs_estilocolortono')
	li_cspar 	= ids_pdnagrupa.GetItemNumber(li_i,'cs_particion')
	ls_tono  	= ids_pdnagrupa.GetItemString(li_i,'tono')
	ll_cspdn 	= ids_pdnagrupa.GetItemNumber(li_i,'cs_pdn')
	
	// Tallas
	lds_tallas.Retrieve(ll_fab,ll_pedido,li_lib,ls_po,li_fabpt,li_lin,ll_ref,ll_co_color,ls_tono,li_csest,li_cspar)
	
	For ll_j = 1 To lds_tallas.RowCount()
		li_csorden = lds_tallas.GetItemNumber(ll_j,'cs_orden_talla')
		li_talla   = lds_tallas.GetItemNumber(ll_j,'co_talla')
		ll_cnt     = lds_tallas.GetItemNumber(ll_j,'ca_programada')
		
		ll_registro = lds_dt_agrupaescalapdn.InsertRow(0)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"cs_agrupacion", an_agrupa)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"cs_pdn", ll_cspdn)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"co_talla", li_talla)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"cs_talla", li_csorden)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"co_estado", 1)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"ca_unidades", ll_cnt)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"fe_creacion", f_fecha_servidor())
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"fe_actualizacion", f_fecha_servidor())
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"usuario", gstr_info_usuario.codigo_usuario)
		lds_dt_agrupaescalapdn.SetItem(ll_registro,"instancia", gstr_info_usuario.instancia)

//		insert into dt_agrupaescalapdn  
//		  ( cs_agrupacion,cs_pdn,co_talla,cs_talla,co_estado,ca_unidades,   
//		  fe_creacion,fe_actualizacion,usuario,instancia )  
//		values ( :an_agrupa,:ll_cspdn,:li_talla,:li_csorden,1,   
//		  :ll_cnt,current,current,user,sitename )  ;
//
//		If Sqlca.SqlCode = -1 Then
//			ls_sqlerr = Sqlca.SqlErrText
//			rollback;
//			MessageBox("Advertencia!","No se pudo insertar las tallas.~n~n~nNota: " + ls_sqlerr )
//			Return -1
//		End If
	Next

	If lds_dt_agrupaescalapdn.Update() < 0 Then
		MessageBox("Advertencia!","No se pudo insertar las tallas.")
		Return -2
	End If

	// Rayas
	lds_rayas.Retrieve(an_agrupa,ll_cspdn)
	
	For ll_j = 1 To lds_rayas.RowCount()
					
		ll_modulo = lds_rayas.GetItemNumber(ll_j,'co_modelo')
		ll_raya   = lds_rayas.GetItemNumber(ll_j,'raya')
		ll_cnt    = lds_rayas.GetItemNumber(ll_j,'ca_unidades')
		
		ll_registro = lds_dt_agrupa_pdn_raya.InsertRow(0)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"cs_agrupacion", an_agrupa)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"cs_pdn", ll_cspdn)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"co_modelo", ll_modulo)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"raya", ll_raya)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"ca_unidades", ll_cnt)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"co_tipo", 1)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"co_estado", 1)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"fe_creacion", f_fecha_servidor())
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"fe_actualizacion", f_fecha_servidor())
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"usuario", gstr_info_usuario.codigo_usuario)
		lds_dt_agrupa_pdn_raya.SetItem(ll_registro,"instancia", gstr_info_usuario.instancia)

//		insert into dt_agrupa_pdn_raya  
//		  ( cs_agrupacion,cs_pdn,co_modelo,raya,ca_unidades,   
//		  co_tipo,co_estado,fe_creacion,fe_actualizacion,   
//		  usuario,instancia )  
//		values ( :an_agrupa,:ll_cspdn,:ll_modulo,:ll_raya,:ll_cnt,   
//		  1,1,current,current,user,sitename )  ;
//
//		If Sqlca.SqlCode = -1 Then
//			ls_sqlerr = Sqlca.SqlErrText
//			rollback;
//			MessageBox("Advertencia!","No se pudo insertar las rayas.~n~n~nNota: " + ls_sqlerr )
//			Return -1
//		End If
	Next
	If lds_dt_agrupa_pdn_raya.Update() < 0 Then
		MessageBox("Advertencia!","No se pudo insertar las rayas.")
		Return -3
	End If
Next

// base para trazos

select max(cs_base_trazos) 
  into :ll_base
  from h_base_trazos  
 where cs_agrupacion = :an_agrupa ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	Messagebox("Advertencia!","No se pudo obtener el numero para el nuevo trazo.~n~n~nNota :" + ls_sqlerr)
	Return -1
ElseIf IsNull(ll_base) Then
	ll_base = 0
End If

ll_result = lds_colmod.Retrieve(an_agrupa)

If ll_result <= 0 Then 
	rollback ;
	Messagebox("Advertencia!","Los datos entre la ficha y la liberaci$$HEX1$$f300$$ENDHEX$$n no son consistentes, es posible que la ficha la hayan cambiado despu$$HEX1$$e900$$ENDHEX$$s de generar la liberaci$$HEX1$$f300$$ENDHEX$$n.")
	Return -1
End If

li_ryax = -1

For ll_j = 1 To ll_result
	ll_modelo = lds_colmod.GetItemNumber(ll_j,'co_modelo')
	ll_reftl  = lds_colmod.GetItemNumber(ll_j,'co_reftel')
	ll_carac  = lds_colmod.GetItemNumber(ll_j,'co_caract')
	ll_diam   = lds_colmod.GetItemNumber(ll_j,'diametro')
	ll_color  = lds_colmod.GetItemNumber(ll_j,'co_color_te')
	ll_raya   = lds_colmod.GetItemNumber(ll_j,'raya')
	li_fabtl  = lds_colmod.GetItemNumber(ll_j,'co_fabrica_tela')
	
	If li_ryax <> ll_raya Then
		
		select cs_base_trazos
		  into :ll_found
		  from h_base_trazos
		 where cs_agrupacion = :an_agrupa and
				 raya = :ll_raya ;
		  
		If Sqlca.SqlCode = -1 Then  
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).~n~n~nNota :" + ls_sqlerr)
			Return -1
		ElseIf Sqlca.SqlCode = 100 Then
			ll_base ++
			ll_bsins = ll_base

			ll_registro = lds_h_base_trazos.InsertRow(0)
			lds_h_base_trazos.SetItem(ll_registro,"cs_agrupacion", an_agrupa)
			lds_h_base_trazos.SetItem(ll_registro,"cs_base_trazos", ll_bsins)
			lds_h_base_trazos.SetItem(ll_registro,"raya", ll_raya)
			lds_h_base_trazos.SetItem(ll_registro,"fe_creacion", f_fecha_servidor())
			lds_h_base_trazos.SetItem(ll_registro,"fe_actualizacion", f_fecha_servidor())
			lds_h_base_trazos.SetItem(ll_registro,"usuario", gstr_info_usuario.codigo_usuario)
			lds_h_base_trazos.SetItem(ll_registro,"instancia", gstr_info_usuario.instancia)
			
//			insert into h_base_trazos  
//				( cs_agrupacion,cs_base_trazos,raya,fe_creacion,fe_actualizacion,   
//				usuario,instancia )  
//			values ( :an_agrupa,:ll_bsins,:ll_raya,current,current,user,sitename) ;
//		
//			If Sqlca.SqlCode = -1 Then  
//				ls_sqlerr = Sqlca.SqlErrText
//				rollback ;
//				Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).~n~n~nNota :" + ls_sqlerr)
//				Return -1
//			End If
		Else
			ll_bsins = ll_found
		End If
	End If
		
	li_ryax = ll_raya
		
	select cs_agrupacion
	  into :ll_found
	  from dt_rayas_telaxbase
	 where cs_agrupacion 	= :an_agrupa and
			 cs_base_trazos 	= :ll_bsins and
			 co_modelo 			= :ll_modelo and
			 co_fabrica_te 	= :li_fabtl and
			 co_reftel 			= :ll_reftl and
			 co_caract 			= :ll_carac and
			 diametro 			= :ll_diam and
			 co_color_te 		= :ll_color ;
			
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo problemas al buscar las rayas de la base.~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		
		ll_registro = lds_dt_rayas_telaxbase.InsertRow(0)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"cs_agrupacion", an_agrupa)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"cs_base_trazos", ll_bsins)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"co_modelo", ll_modelo)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"co_fabrica_te", li_fabtl)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"co_reftel", ll_reftl)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"co_caract", ll_carac)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"diametro", ll_diam)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"co_color_te", ll_color)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"raya", ll_raya)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"fe_creacion", f_fecha_servidor())
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"fe_actualizacion", f_fecha_servidor())
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"usuario", gstr_info_usuario.codigo_usuario)
		lds_dt_rayas_telaxbase.SetItem(ll_registro,"instancia", gstr_info_usuario.instancia)
		
//		insert into dt_rayas_telaxbase  
//				( 	cs_agrupacion,				cs_base_trazos,				co_modelo,				co_fabrica_te,
//					co_reftel,					co_caract,						diametro,				co_color_te,
//					raya,							fe_creacion,					fe_actualizacion,   	usuario,
//					instancia )  
//		values ( :an_agrupa,					:ll_bsins,						:ll_modelo,				:li_fabtl,
//					:ll_reftl,					:ll_carac,						:ll_diam,				:ll_color,
//					:ll_raya,					current,							current,					user,
//					sitename) ;
//					
//		If Sqlca.SqlCode = -1 Then
//			ls_sqlerr = Sqlca.SqlErrText
//			rollback ;
//			Messagebox("Advertencia!","No se pudo insertar el las rayas de los trazos.~n~n~nNota :" + ls_sqlerr)
//			Return -1			
//		End If		
	End If	
Next

If lds_h_base_trazos.Update() > 0 Then
	If lds_dt_rayas_telaxbase.Update() < 0 Then
		Messagebox("Advertencia!","No se pudo insertar el las rayas de los trazos.")
		Return -5
	End If		
Else
	Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).")
	Return -4
End If
	
ll_result = lds_pdntz.Retrieve(an_agrupa)

If ll_result <= 0 Then 
	rollback ;
	Messagebox("Advertencia!","Hubo un error en la producci$$HEX1$$f300$$ENDHEX$$n por trazos.")
	Return -1
End If

For ll_j = 1 To ll_result
	
	ll_cspdn = lds_pdntz.GetItemNumber(ll_j,'cs_pdn')
	ll_base  = lds_pdntz.GetItemNumber(ll_j,'cs_base_trazos')
	
	select cs_agrupacion
	  into :ll_found 
	  from dt_pdnxbase
	 where cs_agrupacion 	= :an_agrupa and
	       cs_base_trazos 	= :ll_base and
			 cs_pdn 				= :ll_cspdn ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		
		ll_registro = lds_dt_pdnxbase.InsertRow(0)
		lds_dt_pdnxbase.SetItem(ll_registro,"cs_agrupacion", an_agrupa)
		lds_dt_pdnxbase.SetItem(ll_registro,"cs_base_trazos", ll_base)
		lds_dt_pdnxbase.SetItem(ll_registro,"cs_pdn", ll_cspdn)
		lds_dt_pdnxbase.SetItem(ll_registro,"fe_creacion", f_fecha_servidor())
		lds_dt_pdnxbase.SetItem(ll_registro,"fe_actualizacion", f_fecha_servidor())
		lds_dt_pdnxbase.SetItem(ll_registro,"usuario", gstr_info_usuario.codigo_usuario)
		lds_dt_pdnxbase.SetItem(ll_registro,"instancia", gstr_info_usuario.instancia)
		
//		insert into dt_pdnxbase  
//			( cs_agrupacion,cs_base_trazos,cs_pdn,fe_creacion,fe_actualizacion, 
//			usuario,instancia )  
//		values ( :an_agrupa,:ll_base,:ll_cspdn,current,current,user,sitename) ;
//				
//		If Sqlca.SqlCode = -1 Then
//			ls_sqlerr = Sqlca.SqlErrText
//			rollback ;
//			Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
//			Return -1
//		End If
	End If
Next

If lds_dt_pdnxbase.Update() <0 Then
	Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).")
	Return -6
End If

ll_result = lds_tlltz.Retrieve(an_agrupa)

If ll_result <= 0 Then 
	rollback ;
	Messagebox("Advertencia!","Hubo un error al recuperar las tallas de los trazos.")
	Return -1
End If

For ll_j = 1 To ll_result
	
	ll_cspdn = lds_tlltz.GetItemNumber(ll_j,'cs_pdn')
	ll_base  = lds_tlltz.GetItemNumber(ll_j,'cs_base_trazos')
	li_talla = lds_tlltz.GetItemNumber(ll_j,'co_talla')
	ll_unid  = lds_tlltz.GetItemNumber(ll_j,'ca_unidades')
	
	select cs_agrupacion
	  into :ll_found 
	  from dt_escalaxpdnbase
	 where cs_agrupacion = :an_agrupa and
	       cs_base_trazos = :ll_base and
			 cs_pdn = :ll_cspdn and
			 co_talla = :li_talla ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		
		ll_registro = lds_dt_escalaxpdnbase.InsertRow(0)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"cs_agrupacion", an_agrupa)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"cs_base_trazos", ll_base)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"cs_pdn", ll_cspdn)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"co_talla", li_talla)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"cs_talla", ll_j)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"ca_unidades", ll_unid)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"co_estado", 1)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"fe_creacion", f_fecha_servidor())
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"fe_actualizacion", f_fecha_servidor())
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"usuario", gstr_info_usuario.codigo_usuario)
		lds_dt_escalaxpdnbase.SetItem(ll_registro,"instancia", gstr_info_usuario.instancia)
		
//		insert into dt_escalaxpdnbase  
//         ( 	cs_agrupacion,				cs_base_trazos,					cs_pdn,					co_talla,
//				cs_talla,					ca_unidades,   					co_estado,				fe_creacion,
//				fe_actualizacion,			usuario,								instancia )  
//  		values (
//		  		:an_agrupa,					:ll_base,							:ll_cspdn,				:li_talla,
//				:ll_j,   					:ll_unid,							1,							current,
//				current,						user,									sitename )  ;
//
//		If Sqlca.SqlCode = -1 Then
//			ls_sqlerr = Sqlca.SqlErrText
//			rollback ;
//			Messagebox("Advertencia!","Hubo un error al insertar la talla de los trazos(D).~n~n~nNota :" + ls_sqlerr)
//			Return -1
//		End If
	End If
Next

//If lds_dt_agrupaescalapdn.Update() > 0 Then
//	If lds_dt_agrupa_pdn_raya.Update() > 0 Then
//		If lds_h_base_trazos.Update() > 0 Then
//			If lds_dt_rayas_telaxbase.Update() > 0 Then
//				If lds_dt_pdnxbase.Update() > 0 Then
					If lds_dt_escalaxpdnbase.Update() > 0 Then
						If dw_maestro.Update() = -1 Then
							rollback ;
							Messagebox("Advertencia!","No se pudo grabar el estado de la producci$$HEX1$$f300$$ENDHEX$$n")
							Return -8
						End If
					Else
						Messagebox("Advertencia!","Hubo un error al insertar la talla de los trazos(D).")
						Return -7
					End If
//				Else
//					Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).")
//					Return -6
//				End If
//			Else
//				Messagebox("Advertencia!","No se pudo insertar el las rayas de los trazos.")
//				Return -5
//			End If
//		Else
//			Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).")
//			Return -4
//		End If
//	Else
//		MessageBox("Advertencia!","No se pudo insertar las rayas.")
//		Return -3
//	End If
//Else
//	MessageBox("Advertencia!","No se pudo insertar las tallas.")
//	Return -2
//End If

Destroy lds_tallas
Destroy lds_rayas
Destroy lds_colmod
Destroy lds_pdntz
Destroy lds_tlltz
Destroy lds_dt_agrupaescalapdn
Destroy lds_dt_agrupa_pdn_raya
Destroy lds_h_base_trazos
Destroy lds_dt_rayas_telaxbase
Destroy lds_dt_pdnxbase
Destroy lds_dt_escalaxpdnbase

//This.Enabled = False
//d_lista_trazos_produccion

return an_agrupa
end function

public function long of_crearagrupa ();Long   ll_agrupa
String ls_sqlerr

//------------------------------------- busca max agrupacion
select max(cs_agrupacion)  
  into :ll_agrupa  
  from h_agrupa_pdn ;
  
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","No se pudo seleccionar el consecutivo de la agrupaco$$HEX1$$ed00$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
	Return -1
End If
	
If IsNull(ll_agrupa) Then ll_agrupa = 0

//--------------------- ++ agrupacion
ll_agrupa ++

//--------------------- insert into h_agrupa_pdn
insert into h_agrupa_pdn  
   ( cs_agrupacion,co_estado,fe_creacion,fe_actualizacion,   
     usuario,instancia )  
values ( :ll_agrupa,1,current,current,user,sitename )  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","No se pudo seleccionar el consecutivo de la agrupaco$$HEX1$$ed00$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
	Return -1
End If

Return ll_agrupa
	

end function

public function long of_orden_corte ();//genera el numero de orden de corte para toda una misma agrupacion, ya que cada que se agrupa, dicha
//agrupacion es la unica que en ese momento tiene como estado de asignacion 3 y como numero de
//orden de corte 1.
//realizado por juan carlos restrepo medina abril 25 de 2003

Long ll_fila,ll_num_reg,ll_cs_liberacion,ll_cs_prioridad,ll_cs_asignacion,ll_co_estado_asigna,ll_co_est_asig_old,&
	  ll_i,ll_incremento,ll_nuenqueesta,ll_co_fabrica_exp,ll_pedido,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,&
	  ll_co_color_pt,ll_cs_estilocolortono,ll_numero_agrupa,ll_estado_asigna,ll_i2,&
	  ll_cs_agrupacion,ll_fil,ll_agrupa,ll_agrupa2,ll_ca_pendiente,ll_co_estado_asigna2, ll_registro
String ls_po,ls_referencia,ls_gpa,ls_color,ls_body,ls_tono
DateTime ldt_fe_ini_prog,ldt_fe_fin_prog

dw_maestro.AcceptText()

ii_sw_estado = 0

//busco el numero de consecutivo para la orden de corte.		
select cf_consc_ordenes.incremento, cf_consc_ordenes.nu_enque_esta  
into :ll_incremento, :ll_nuenqueesta  
from cf_consc_ordenes  
where ( cf_consc_ordenes.tipo_orden = 3 ) and  
		( cf_consc_ordenes.co_fabrica = 2 );

IF SQLCA.SQLCode <> 0 OR ISNULL(ll_incremento) OR ISNULL(ll_nuenqueesta) THEN
	MessageBox("Error","No se pudo encontrar el consecutivo de ordenes de corte, comuniquese con sistemas por favor", StopSign!)
	ii_sw_estado = 1
	Return -1
ELSE
	//actualizo el n$$HEX1$$fa00$$ENDHEX$$mero del consecutivo para las ordenes de corte
	ll_nuenqueesta = ll_nuenqueesta + ll_incremento
	update cf_consc_ordenes
	set nu_enque_esta = :ll_nuenqueesta
	where ( cf_consc_ordenes.tipo_orden = 3 ) and
			( cf_consc_ordenes.co_fabrica = 2 );
END IF

//	generar la orden de corte para todas las agrupaciones
ll_registro = dw_maestro.RowCount() + 1
ll_num_reg = dw_maestro.Find("espejo_asignacion = 3 And cs_asignacion = 1",1,ll_registro)
Do While ll_num_reg > 0
	dw_maestro.Setitem(ll_num_reg,'cs_asignacion',ll_nuenqueesta)
	ll_num_reg++
	ll_num_reg = dw_maestro.Find("espejo_asignacion = 3 And cs_asignacion = 1",ll_num_reg,ll_registro)
Loop

If dw_maestro.update() > 0 Then
	Commit;
Else
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudo actualizar la orden de corte, comuniquese con sistemas por favor", StopSign!)
	Return -2
End If

////Recorro la dw para determinar que registros cambiaron de estado de asignacion  a 3 , a los que cumplan se les asigna
////la orden de corte si esta es igual a 1
//FOR ll_i = 1 TO dw_maestro.RowCount()
//	ll_co_estado_asigna = dw_maestro.getitemnumber(ll_i,'co_estado_asigna')
//	ll_co_est_asig_old = dw_maestro.GetItemNumber(ll_i,'espejo_asignacion')
//	ll_cs_asignacion = dw_maestro.GetItemNumber(ll_i,'cs_asignacion') 
//	
//	IF ll_co_estado_asigna = 3 AND ll_cs_asignacion = 1  THEN
//		//busco el numero de consecutivo para la orden de corte.		
//		select cf_consc_ordenes.incremento, cf_consc_ordenes.nu_enque_esta  
//		into :ll_incremento, :ll_nuenqueesta  
//		from cf_consc_ordenes  
//		where ( cf_consc_ordenes.tipo_orden = 3 ) and  
//				( cf_consc_ordenes.co_fabrica = 2 );
//		
//		IF SQLCA.SQLCode <> 0 OR ISNULL(ll_incremento) OR ISNULL(ll_nuenqueesta) THEN
//			MessageBox("Error","No se pudo encontrar el consecutivo de ordenes de corte, comuniquese con sistemas por favor", StopSign!)
//			ii_sw_estado = 1
//			Return -1
//		ELSE
//			//actualizo el n$$HEX1$$fa00$$ENDHEX$$mero del consecutivo para las ordenes de corte
//			ll_nuenqueesta = ll_nuenqueesta + ll_incremento
//			update cf_consc_ordenes
//			set nu_enque_esta = :ll_nuenqueesta
//			where ( cf_consc_ordenes.tipo_orden = 3 ) and
//					( cf_consc_ordenes.co_fabrica = 2 );
//		END IF
//
//		//generar la orden de corte para todas las agrupaciones
//		FOR ll_i2 = 1 TO dw_maestro.RowCount()
//			ll_co_estado_asigna2 = dw_maestro.getitemnumber(ll_i2,'co_estado_asigna')
//			IF dw_maestro.GetItemNumber(ll_i2,'cs_asignacion') = 1 THEN
//				IF ll_co_estado_asigna2 = 3  THEN
//					dw_maestro.Setitem(ll_i2,'cs_asignacion',ll_nuenqueesta)
//				END IF
//			END IF
//		NEXT
//		dw_maestro.update()
//	END IF
//NEXT

Return 1
end function

public function long of_borraragrupa (long an_fila);//DataStore lds_mdpdn,lds_mdsnpdn
uo_dsbase lds_pdnadr
Long   ll_agrupa,ll_fila,ll_pedido,ll_ref,ll_color,ll_modulo
String ls_sqlerr,ls_po,ls_tono
//Int    li_fabexp,li_cslib,li_fabpt,li_linea,li_csest,li_cspar,li_i



//------------------------------- crea datastore lds_pdnadr
lds_pdnadr   = Create uo_dsbase
//lds_mdsnpdn = Create DataStore

//------------------------------- asigna dw d_borrar_dt_agrupacion (dt_agrupa_pdn) a datastore
lds_pdnadr.DataObject = 'd_borrar_dt_agrupacion'
//lds_mdsnpdn.DataObject = 'd_borrar_rayas_agrupacion_no_pdn'

lds_pdnadr.SetTransObject(Sqlca)
//lds_mdsnpdn.SetTransObject(Sqlca)

//------------------------------- trae agrupacion a borrar
ll_agrupa = dw_maestro.GetItemNumber(an_fila,'cs_agrupacion')
//ll_modulo = dw_maestro.GetItemNumber(an_fila,'co_modulo')
//------------------------------ recupera la agrupacion a borrar en datastore
lds_pdnadr.Retrieve(ll_agrupa)

//------------------------------ ciclo sobre dt_agrupapdn de la agrupacion
//For li_i = 1 To lds_pdnadr.RowCount()
//	
//	li_fabexp = lds_pdnadr.GetItemNumber(li_i,'co_fabrica_exp')
//	ll_pedido = lds_pdnadr.GetItemNumber(li_i,'pedido')
//	li_cslib  = lds_pdnadr.GetItemNumber(li_i,'cs_liberacion')
//	ls_po     = lds_pdnadr.GetItemString(li_i,'po')
//	li_fabpt  = lds_pdnadr.GetItemNumber(li_i,'co_fabrica_pt')
//	li_linea  = lds_pdnadr.GetItemNumber(li_i,'co_linea')
//	ll_ref    = lds_pdnadr.GetItemNumber(li_i,'co_referencia')
//	ll_color  = lds_pdnadr.GetItemNumber(li_i,'co_color_pt')
//	ls_tono   = lds_pdnadr.GetItemString(li_i,'tono')
//	li_csest  = lds_pdnadr.GetItemNumber(li_i,'cs_estilocolortono')
//	li_cspar  = lds_pdnadr.GetItemNumber(li_i,'cs_particion')
//		
//	//-------------------------------- actualiza estado =1 a dt_pdnxmodulo	
//	update dt_pdnxmodulo  
//		set co_estado_asigna = 1,
//			 cs_asignacion    = 1	
//	 where dt_pdnxmodulo.simulacion 				= 1 and 
//			 dt_pdnxmodulo.co_fabrica 				= 91 and 
//			 dt_pdnxmodulo.co_planta 				= 1 and  
//			 dt_pdnxmodulo.co_modulo 				= :ll_modulo and
//			 dt_pdnxmodulo.co_fabrica_exp 		= :li_fabexp and  
//			 dt_pdnxmodulo.pedido 					= :ll_pedido and 
//			 dt_pdnxmodulo.cs_liberacion 			= :li_cslib and 
//			 dt_pdnxmodulo.po 						= :ls_po and
//			 dt_pdnxmodulo.co_fabrica_pt 			= :li_fabpt and
//			 dt_pdnxmodulo.co_linea 				= :li_linea and
//			 dt_pdnxmodulo.co_referencia 			= :ll_ref and
//			 dt_pdnxmodulo.co_color_pt 			= :ll_color and 
//			 dt_pdnxmodulo.tono 						= :ls_tono and 
//			 dt_pdnxmodulo.cs_estilocolortono 	= :li_csest and  
//			 dt_pdnxmodulo.cs_particion 			= :li_cspar  ;
//	
//	If Sqlca.SqlCode = -1 Then
//		ls_sqlerr = Sqlca.SqlErrText
//		rollback;
//		MessageBox("Advertencia!","No se pudo borrar los trazos para esta agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
//		Return -1
//	End If	
//Next

//-------------------------- borra dt_trazosxbase de la agrupacion
delete 
  from dt_trazosxbase  
 where cs_agrupacion = :ll_agrupa ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar los trazos para esta agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra dt_escalaxpdnbase de la agrupacion
delete 
  from dt_escalaxpdnbase  
 where cs_agrupacion = :ll_agrupa ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las escalas de los trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra dt_pdnxbase de la agrupacion
delete 
  from dt_pdnxbase  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las producciones de los trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra dt_rayas_telaxbase de la agrupacion
delete 
  from dt_rayas_telaxbase  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las rayas de los trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra h_base_trazos de la agrupacion
delete 
  from h_base_trazos  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar el trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra dt_agrupa_pdn_raya de la agrupacion
delete 
  from dt_agrupa_pdn_raya  
 where cs_agrupacion = :ll_agrupa  ;
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las rayas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra dt_agrupaescalapdn de la agrupacion
delete 
 from dt_agrupaescalapdn  
where cs_agrupacion = :ll_agrupa ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las tallas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra dt_agrupa_pdn de la agrupacion
delete 
  from dt_agrupa_pdn  
 where cs_agrupacion = :ll_agrupa ;
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las producciones de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//-------------------------- borra h_agrupa_pdn de la agrupacion
delete 
  from h_agrupa_pdn  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If


//destroy lds_pdnadr

Return 0
end function

on w_pdn_agrupar_copia.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_asignacion_trazos" then this.MenuID = create m_mantenimiento_asignacion_trazos
end on

on w_pdn_agrupar_copia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*	---------------------------------------------------------------------

	---------------------------------------------------------------------*/
This.Event Post ue_postopen()

ids_pdnagrupa = Create uo_dsbase
ids_pdnagrupa.DataObject = "d_insercion_dt_agrupacion_copia"
ids_pdnagrupa.SetTransObject(SQLCA)

dw_maestro.Retrieve(1,91,1,701)
end event

event close;call super::close;Destroy ids_pdnagrupa
end event

event ue_grabar;Long   	ll_fila,ll_fab,ll_pedido,ll_ref,ll_filins,ll_agrupa,ll_rseult,li_mod, ll_color
Int    	li_lib,li_fabpt,li_lin,li_csest,li_cspar,li_i
String 	ls_po,ls_tono,ls_sqlerr
Long	li_priori,li_fab,li_planta
DATE		ld_fecha
n_cts_corte_copia luo_corte

luo_corte = Create n_cts_corte_copia
//------------------------- accepttext a dw_maestro -----------------------------------//
dw_maestro.AcceptText()

//---------  ciclo sobre dw_maestro, carga ids_pdnagrupa con selec y crear agrupaciones --//
For li_i = 1 To dw_maestro.RowCount()
	//---------- blanquea ids_pdnagrupa ------------------------------//
	ids_pdnagrupa.Reset()
	//------------  si estado inicial no marcado para agrupar pero ahora si marcado ---//
	If dw_maestro.GetItemNumber(li_i,'sw_estado') = 1 And dw_maestro.GetItemNumber(li_i,'co_estado_asigna') = 2 Then

		//---------------------- toma los datos de la fila -------------------------------//
		ll_fab    	= dw_maestro.GetItemNumber(li_i,'co_fabrica_exp')
		ll_pedido 	= dw_maestro.GetItemNumber(li_i,'pedido')
		li_fab   	= dw_maestro.GetItemNumber(li_i,'co_fabrica')
		li_planta   = dw_maestro.GetItemNumber(li_i,'co_planta')
		li_mod   	= dw_maestro.GetItemNumber(li_i,'co_modulo')
		li_lib   	= dw_maestro.GetItemNumber(li_i,'cs_liberacion')
		ls_po    	= dw_maestro.GetItemString(li_i,'po')
		li_fabpt 	= dw_maestro.GetItemNumber(li_i,'co_fabrica_pt')
		li_lin   	= dw_maestro.GetItemNumber(li_i,'co_linea')
		ll_ref   	= dw_maestro.GetItemNumber(li_i,'co_referencia')
		ll_color 	= dw_maestro.GetItemNumber(li_i,'co_color_pt')
		li_csest 	= dw_maestro.GetItemNumber(li_i,'cs_estilocolortono')
		li_cspar 	= dw_maestro.GetItemNumber(li_i,'cs_particion')
		ls_tono  	= dw_maestro.GetItemString(li_i,'tono')
		li_priori  	= dw_maestro.GetItemNumber(li_i,'cs_prioridad')
		
		dw_maestro.SetItem(li_i,'co_estado_asigna',3)
		
		dw_maestro.AcceptText()
		//--------------------------------------
		//calculos las fechas de programaci$$HEX1$$f300$$ENDHEX$$n
		//--------------------------------------
		
		//---------------------------- calcula la fecha base para programar fechas -------------------//
		If li_priori > 1 Then
			select max(Date(dt_programa_diario.fe_inicio)) 
			  into :ld_fecha
			from dt_pdnxmodulo,   
				  dt_programa_diario  
		  where ( dt_programa_diario.simulacion 			= dt_pdnxmodulo.simulacion ) and  
				  ( dt_programa_diario.co_fabrica 			= dt_pdnxmodulo.co_fabrica ) and  
				  ( dt_programa_diario.co_planta  			= dt_pdnxmodulo.co_planta ) and  
				  ( dt_programa_diario.co_modulo  			= dt_pdnxmodulo.co_modulo ) and  
				  ( dt_programa_diario.co_fabrica_exp 		= dt_pdnxmodulo.co_fabrica_exp ) and  
				  ( dt_programa_diario.pedido 				= dt_pdnxmodulo.pedido ) and  
				  ( dt_programa_diario.cs_liberacion 		= dt_pdnxmodulo.cs_liberacion ) and  
				  ( dt_programa_diario.po 						= dt_pdnxmodulo.po ) and  
				  ( dt_programa_diario.co_fabrica_pt 		= dt_pdnxmodulo.co_fabrica_pt ) and  
				  ( dt_programa_diario.co_linea 				= dt_pdnxmodulo.co_linea ) and  
				  ( dt_programa_diario.co_referencia 		= dt_pdnxmodulo.co_referencia ) and  
				  ( dt_programa_diario.co_color_pt 			= dt_pdnxmodulo.co_color_pt ) and  
				  ( dt_programa_diario.tono 					= dt_pdnxmodulo.tono ) and  
				  ( dt_programa_diario.cs_estilocolortono = dt_pdnxmodulo.cs_estilocolortono ) and  
				  ( dt_programa_diario.cs_particion 		= dt_pdnxmodulo.cs_particion ) and  
				  ( dt_pdnxmodulo.simulacion 					= 1 ) and  
				  ( dt_pdnxmodulo.co_fabrica 					= :li_fab ) and  
				  ( dt_pdnxmodulo.co_planta  					= :li_planta ) and 
				  ( dt_pdnxmodulo.co_modulo  					= :li_mod ) and  
				  ( dt_pdnxmodulo.cs_prioridad 				= :li_priori -1 )  ;
											  
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				MessageBox("Advertencia!","Hubo un error al buscar la fecha de inicio.~n~n~nNota: " + ls_sqlerr )
				Return
			End If
			
			If IsNull(ld_fecha) Then
				ld_fecha = Date(f_fecha_servidor())
			End IF
		Else
			ld_fecha = Date(f_fecha_servidor())
		End If
		
		If luo_corte.Of_MetodoMinutos(1,li_fab,li_planta,li_mod,li_priori,ld_fecha,dw_maestro) = -1 Then
			MessageBox('Error','Ocurrio un error, verifique la informaci$$HEX1$$f300$$ENDHEX$$n e intente nuevamente')
			rollback;
			Return
		ELSE
			COMMIT;
		End if
		
		
		ll_filins = ids_pdnagrupa.InsertRow(0)
		
		ids_pdnagrupa.SetItem(ll_filins,'co_fabrica_exp',ll_fab)
		ids_pdnagrupa.SetItem(ll_filins,'pedido',ll_pedido)
		ids_pdnagrupa.SetItem(ll_filins,'cs_liberacion',li_lib)
		ids_pdnagrupa.SetItem(ll_filins,'po',ls_po)
		ids_pdnagrupa.SetItem(ll_filins,'co_fabrica_pt',li_fabpt)
		ids_pdnagrupa.SetItem(ll_filins,'co_linea',li_lin)
		ids_pdnagrupa.SetItem(ll_filins,'co_referencia',ll_ref)
		ids_pdnagrupa.SetItem(ll_filins,'co_color_pt',ll_color)
		ids_pdnagrupa.SetItem(ll_filins,'cs_estilocolortono',li_csest)
		ids_pdnagrupa.SetItem(ll_filins,'cs_particion',li_cspar)
		ids_pdnagrupa.SetItem(ll_filins,'tono',ls_tono)
		ids_pdnagrupa.SetItem(ll_filins,'ca_unidades',dw_maestro.GetItemNumber(li_i,'ca_programada'))
		ids_pdnagrupa.SetItem(ll_filins,'de_linea',dw_maestro.GetItemString(li_i,'de_linea'))
		ids_pdnagrupa.SetItem(ll_filins,'de_referencia',dw_maestro.GetItemString(li_i,'de_referencia'))
		ids_pdnagrupa.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
		ids_pdnagrupa.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)

			
		ll_agrupa = of_CrearAgrupa()
		
		If ll_agrupa > 0 Then 
			If Of_detalleTrazo(ll_agrupa) = -1 Then 
				Rollback;
				Return 
			END IF
		End If
	End If
Next

Destroy luo_corte

//If of_particion(dw_maestro) = 0 Then
	commit ;
//Else		
//	rollback ; 
//End If
//-----------------------------  retrieve con modulo 701 ---------------------------//
dw_maestro.Retrieve(1,91,1,701)



end event

type dw_maestro from w_base_simple`dw_maestro within w_pdn_agrupar_copia
integer x = 27
integer y = 16
integer width = 3584
integer height = 1868
string dataobject = "d_lista_pdn_a_agrupar_copia"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

event dw_maestro::rbuttondown;call super::rbuttondown;/*	---------------------------------------------------------------------
	Crea un menu popup al presionar boton derecho del mouse cuando se 
	esta trabajando sobrev el datawindow maestro.
	---------------------------------------------------------------------*/
m_select lm_select

lm_select = Create m_select
lm_select.m_edicion.PopMenu(w_principal.PointerX(),w_principal.PointerY())
Destroy lm_select
end event

event dw_maestro::buttonclicked;call super::buttonclicked;String ls_columna

ls_columna = dwo.name

choose case ls_columna
	case 'cb_grupo'
		This.SetSort("gpa A, cs_agrupacion A, cs_prioridad A")
		This.Sort()
		
	case 'cb_agrupa'
		This.SetSort("cs_agrupacion A, gpa A , cs_prioridad")
		This.Sort()
	
	case 'cb_estilo'
		This.SetSort("de_referencia A, gpa A, cs_agrupacion A, cs_prioridad A")
		This.Sort()
		
	case 'cb_oc'
		This.SetSort("cs_asignacion A, cs_agrupacion A, gpa A, cs_prioridad A")
		This.Sort()	
		
	case 'cb_prioridad'
		This.SetSort("co_modulo A, cs_prioridad A")
		This.Sort()	
	
	case 'cb_original'
		This.SetSort("cs_agrupacion A,cs_pdn A,gpa A,de_referencia A,de_color A")
		This.Sort()	
end choose















end event

event dw_maestro::clicked;call super::clicked;Long ll_agrupa,ll_orden,ll_fila,ll_agrupa2
il_fila = row
If Row <= 0 Then 
	ib_trazo = False
	Return
End If

If ib_trazo Then
	
	ib_trazo = False
	ll_agrupa = This.GetItemNumber(row,'cs_agrupacion')
   ll_orden = This.GetItemNumber(row,'cs_asignacion')
	
	If Not IsNull(ll_agrupa) Then 
		If Of_detalleTrazo(ll_agrupa) > 0 Then 
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
			dw_maestro.Retrieve(1,91,1,800)
			
			//se trata de un registro que se colocara en una agrupacion existente (ll_agrupa)
			//por lo tanto se debe colocar el mismo numero de orden corte para todos los registros
			//de dicha agrupacion
			//realizado por juan carlos restrepo abril 25 de 2003
			
			For ll_fila = 1 To dw_maestro.RowCount()
				ll_agrupa2 = dw_maestro.GetItemNumber(ll_fila,'cs_agrupacion') 
				If ll_agrupa2 = ll_agrupa Then
					dw_maestro.SetItem(ll_fila,'cs_asignacion',ll_orden)
				End if
			Next
			
			If dw_maestro.Update() = -1 Then
				Rollback;
				MessageBox('Error','Ocurrio un error al momento de generar el n$$HEX1$$fa00$$ENDHEX$$mero de Orden de Corte')
				Return
			End if
			//fin de la modificacion jcrm
			
		End If
	Else
		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","No selecciono una agrupaci$$HEX1$$f300$$ENDHEX$$n valida.")
		Parent.Dynamic Trigger Event ue_select(2)
	End If
	Return
End If

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If

ib_trazo = False
end event

