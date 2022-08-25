HA$PBExportHeader$n_cerrar_po.sru
$PBExportComments$//objeto utilizado para realizar el proceso de cierre en tintorer$$HEX1$$ed00$$ENDHEX$$a de una po o de una sola op de estilo.
forward
global type n_cerrar_po from nonvisualobject
end type
end forward

global type n_cerrar_po from nonvisualobject
end type
global n_cerrar_po n_cerrar_po

forward prototypes
public function long of_cerrar_op_estilo (ref long an_op_estilo[])
public function long of_cerrar_tempo (ref long an_op_estilo[])
public function long of_cerrar_hlza (long an_op_estilo[])
public function long of_validar_op_sumary (long an_op_sumary[])
end prototypes

public function long of_cerrar_op_estilo (ref long an_op_estilo[]);/*------------of_cerrar_opestilo----------------------------------
El proceso de cerrar una OP de estilo se realiza de la siguiente forma:

*verificar que la op no est$$HEX2$$e9002000$$ENDHEX$$cerrada con anterioridad.

1.	El sistema debe abrir una ventana donde pida La OP de Estilo a cerrar,
2.	El usuario ingresa el n$$HEX1$$fa00$$ENDHEX$$mero de la OP de Estilo.
3.	El sistema debe buscar con la OP de Estilo en la tabla h_ordenpd_pt traer la fabrica, l$$HEX1$$ed00$$ENDHEX$$nea,  referencia  y cliente y buscar el nombre de la referencia en la tabla h_preref_pv y en nombre del cliente en la tabla cc_cliente y los n$$HEX1$$fa00$$ENDHEX$$meros de po de la tabla dt_pedidosxorden el campo nu_orden,  desplegar estos datos en la pantalla.
4.	El usuario presiona el bot$$HEX1$$f300$$ENDHEX$$n de Cerrar OP para inicial el proceso.
5.	El sistema pregunta si est$$HEX2$$e1002000$$ENDHEX$$seguro de cerrar La OP y dejar disponibles los rollos y cajas que hay en el proceso
6.	El usuario confirma o rechaza la acci$$HEX1$$f300$$ENDHEX$$n
7.	Si confirma la acci$$HEX1$$f300$$ENDHEX$$n, el sistema realiza las siguiente tareas:
7.1	Mostrar mensaje diciendo:  colocando cajas disponibles
7.2	Buscar las cajas que hay en la tabla cajas con ca_kilos_act > 0 y con el campo co_orden_pdcion igual a la orden de producci$$HEX1$$f300$$ENDHEX$$n asignada, si existe alguna con el campo pull_list = 1 se debe mostrar mensaje diciendo al usuario que existen cajas reservadas sin entregar si desea continuar con el proceso, si dice que si se continua si dice que no se sale sin grabar
7.3	Tomar cada caja e insertar en el log de cambios de cajas,   esta es la tabla mv_log_cajasup, si se le cambio el pull_list y la OP se debe insertar dos registros por cada caja, en el campo columna  se coloca 'co_orden_pdccion' o 'pull_list' seg$$HEX1$$fa00$$ENDHEX$$n lo que se cambia y en valor viejo y valor nuevo los valores que tenia y como quedo la caja.
7.4	Marcar las cajas con co_orden_pdcion = 0 y pull_list = 0
7.5	Buscar si existen pedidos de hilaza creados en la tabla h_pedido_hilazas con join con el campo dt_pedido_cajas con el campo h_pedido_hilazas.cs_ordenpd_pt igual a la OP ingresada y con h_pedido_hilazas.estado  = 1  y en la tabla dt_pedido_cajas.cs_caja_ent = 0, si existe alguno se debe poner el campo h_pedido_hilazas.estado = 2.
7.6	Mostrar mensaje diciendo: colocando rollos disponibles
7.7	Buscar las OP de tejido que hay en la tabla h_op_tejido  que tienen la OP ingresada en el campo cs_ordenpd_pt,  y con estado  = 1 y con esos numeros de OP de tejido buscar en m_rollo en el campo cs_orden_pr_act = op_tejido y con co_estado_rollo = 1, si encontramos algun rollo se cambia el campo co_planeador por 2.
7.8	Buscar los rollos que hay en centros con estado = 2 y centro diferente de 99 y colocar el campo co_planeador = 2.
7.9	Colocar el campo co_estado_orden en h_ordenpd_pt = 6 (cumplida) tomar el numero de las constantes m_constant_tela con var_nombre = 'OP_ESTILO_CUMPLIDA'
7.10	Buscar en h_ordenpd_te y h_op_tejido las op con el campo cs_ordenpd_pt = a la OP ingresada por el usuario y colocar el campo co_estado_orden en h_ordenpd_te y co_estado_orden en h_op_tejido = 10 (cumplida)  tomar el numero de las constantes m_constant_tela con var_nombre = 'OP_TEJIDO_CUMPLIDA'
7.11	Buscar en dt_detalle_telas_op todos los registros con el campo cs_ordenpd_pt igual a la OP ingresada, buscar los que tengan  co_Estado diferente de 16  (constante en m_constant_tela = TE$$HEX1$$d100$$ENDHEX$$IDO_COMPLETA     ) y mirar si alguno tiene ca_kilos_tint menor que  ca_kilos_prog, si existe mostrar al usuario si continua proceso y si continua colocar estado en 16 (contantes)
7.12	Crear observaci$$HEX1$$f300$$ENDHEX$$n  sobre cerrado de la op en la tabla h_ordenpd_pt campo observaci$$HEX1$$f300$$ENDHEX$$n, decir : 'OP cerrada por: ' user 'fecha cerrada: ' current (El campo aun no se ha creado en vesrs00, solo en marrs01)
7.13	Cargar log de op cerradas, la tabla se llama mv_log_cierra_op, en esta se debe insertar la op y cada uno de los rollos con sus kilos y las cajas con sus kilos y conos que se cambiaron de estado.

adicion  Se valida que si la op tiene rollos en proceso de te$$HEX1$$f100$$ENDHEX$$ido y acabado (centro 7 y 10) no se puede cerrar   feb 12 - 2009 jorodrig
-----------------------------------------------------------------*/


Long ll_numero_cajas, ll_i, ll_cs_caja, ll_fila, ll_orden,ll_fila_log, ll_cs_rollo, ll_numero_cajas2
Long ll_tintura_completa,ll_opestilo_cumplida, ll_optejido_cumplida, ll_ordenes[]
uo_dsbase lds_cajas, lds_log, lds_pedido_hilaza, lds_rollos_op, lds_rollos_sin
uo_dsbase  lds_actualiza_optejido, lds_infoop , ld_gr_rollos_de_op_en_proceso
uo_dsbase lds_actualiza_ordentejido, lds_telas_op, lds_log_cierre_op, lds_consecutivo_cajas,lds_actualiza_optejido_pdp,&
          lds_cajas_cabeza, lds_cantidad_en_reserva, lds_actualiza_estado_solicitud, lds_gr_rollos_en_centro_cero
Long li_res, li_rollos_proceso
Datetime ldt_fe_servidor
n_cts_constantes_tela n_cons_tela
String ls_ops, ls_cs_caja, ls_pallet_id
Long ll_cajas[], ll_k, ll_cs_solicitud, ll_filas_centro_cero
Long ll_consec_sig_caja, ll_fila_cons_log, ll_reftel, ll_conos_reserv, ll_conos_reserv_caja, ll_conos_tot
Long li_cpto_cerrar,li_centro
Decimal{3} ldc_cantidad_reserv, ldc_cantidad_reserv_caja, ldc_cantidad_tot
s_base_parametros lstr_parametros

lds_infoop=						Create uo_dsbase
lds_cajas = 				   Create uo_dsbase
lds_log   = 				   Create uo_dsbase
lds_pedido_hilaza = 		   Create uo_dsbase
lds_rollos_op = 			   Create uo_dsbase
lds_rollos_sin = 			   Create uo_dsbase
lds_actualiza_optejido=    Create uo_dsbase
lds_actualiza_optejido_pdp=Create uo_dsbase
lds_actualiza_ordentejido= Create uo_dsbase
lds_telas_op = 				Create uo_dsbase
lds_log_cierre_op=			Create uo_dsbase
lds_consecutivo_cajas=		Create uo_dsbase
ld_gr_rollos_de_op_en_proceso  = Create uo_dsbase
lds_cajas_cabeza               = Create uo_dsbase
lds_cantidad_en_reserva        = Create uo_dsbase
lds_actualiza_estado_solicitud = Create uo_dsbase
lds_gr_rollos_en_centro_cero   = Create uo_dsbase

lds_infoop.DataObject = "d_gr_info_opestilo"
lds_infoop.SetTransObject(SQLCA)

//cajas de las ordenes de op estilo
lds_cajas.DataObject = "d_gr_cajas_ordenes"
lds_cajas.SetTransObject(SQLCA)

//cajas de las ordenes de op estilo
lds_cajas_cabeza.DataObject = "d_gr_cajas_ordenes_encabezado"
lds_cajas_cabeza.SetTransObject(SQLCA)

//actualiza estado en dt_solic_x_caja_gbi
lds_actualiza_estado_solicitud.DataObject = "dtb_actualiza_estado_solicitud"
lds_actualiza_estado_solicitud.SetTransObject(SQLCA)

//trae las cantidad de kilos y conos reservados por caja y solicitud
lds_cantidad_en_reserva.DataObject = "dtb_cantidades_reserv_x_solici_y_caja"
lds_cantidad_en_reserva.SetTransObject(SQLCA) 

//registra en el log de cajas
lds_log.DataObject = "d_gr_log_cajas"
lds_log.SetTransObject(SQLCA)

//busca pedidos de hilaza
lds_pedido_hilaza.DataObject = "d_gr_pedido_hilaza"
lds_pedido_hilaza.SetTransObject(SQLCA)

//carga los rollos asignados a op tejido
lds_rollos_op.DataObject= "d_gr_rollos_opestilo"
lds_rollos_op.SetTransObject(SQLCA)

//carga los rollos sin asignar
lds_rollos_sin.DataObject = "d_gr_rollos_sin_asignar"
lds_rollos_sin.SetTransObject(SQLCA)

//actualizar estado de op tejido
lds_actualiza_optejido.DataObject= "d_gr_actualizar_op_tejido"
lds_actualiza_optejido.SetTransObject(SQLCA)

//actualizar estado de op PDP
lds_actualiza_optejido_pdp.DataObject= "d_gr_actualiza_op_tejido_pdp"
lds_actualiza_optejido_pdp.SetTransObject(SQLCA)

//actualizar ordenes de tejido
lds_actualiza_ordentejido.DataObject = "d_gr_actualizar_orden_tejido"
lds_actualiza_ordentejido.SetTransObject(SQLCA)

//actualizar estado tintura op estilo en dt_detalle_telas_op
lds_telas_op.DataObject = "d_gr_cerrar_tin_opestilo"
lds_telas_op.SetTransObject(SQLCA)

//log de cierre op.
lds_log_cierre_op.DataObject = "d_gr_log_cierre_op"
lds_log_cierre_op.SetTransObject(SQLCA)

//m$$HEX1$$e100$$ENDHEX$$ximo valor del campo n$$HEX1$$fa00$$ENDHEX$$mero por caja en log de cajas
lds_consecutivo_cajas.DataObject = "d_gr_consecutivo_cajas"
lds_consecutivo_cajas.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//Rollos pendientes en el proceso de tintoreria y acabados
ld_gr_rollos_de_op_en_proceso.DataObject = "d_gr_rollos_de_op_en_proceso"
ld_gr_rollos_de_op_en_proceso.SetTransObject(SQLCA)

//Rollos pendientes en tejido
lds_gr_rollos_en_centro_cero.DataObject = "dtb_rollos_centro_cero_x_op_estilo"
lds_gr_rollos_en_centro_cero.SetTransObject(SQLCA)

li_rollos_proceso = ld_gr_rollos_de_op_en_proceso.Retrieve(an_op_estilo)
IF li_rollos_proceso = 0 THEN
ELSE	
	Return -1	
END IF

//concepto automatico de cierre de Op
li_cpto_cerrar = 12
ldt_fe_servidor = f_fecha_servidor()

ls_ops = ""
ls_pallet_id = ""

//buca la informaci$$HEX1$$f300$$ENDHEX$$n para todas las op estilo
If lds_infoop.Retrieve(an_op_estilo) <= 0 Then
	Rollback using SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al consultar informaci$$HEX1$$f300$$ENDHEX$$n de las OP Estilo")
	Return -1
End If

w_principal.SetMicroHelp("Colocando cajas disponibles...")

//se buscan las cajas de las op estilo con kilos act > 0
ll_numero_cajas  = lds_cajas.Of_Retrieve(an_op_estilo)
ll_numero_cajas2 = lds_cajas_cabeza.Of_Retrieve(an_op_estilo)

If ll_numero_cajas <= 0 Then
	If ll_numero_cajas = -1 Then
		Rollback using SQLCA;
		//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error buscando cajas de ordenes relacionadas con OP Estilo: " + ls_ops)
		Return -1
	End If
Else
	
	//buscar los consecutivos de cajas, para determinar luego en que n$$HEX1$$fa00$$ENDHEX$$mero va cada una en el log
	For ll_i = 1 To ll_numero_cajas
		ll_cajas[ll_i]	= LONG(lds_cajas.GetItemstring(ll_i,"cs_canasta"))
	Next 
	
	//trae el consecutivo de la caja con el valor m$$HEX1$$e100$$ENDHEX$$ximo del campo n$$HEX1$$fa00$$ENDHEX$$mero si existe.
	If lds_consecutivo_cajas.Retrieve(ll_cajas) < 0 Then
		Rollback using SQLCA;
		//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error determinando los consecutivos de cajas")	
		Return -1
	End If

	//recorre todas las cajas para registrar en el log lo que se cambia (numero orden o pull_list)
	//el pull_list =1 indica que la caja est$$HEX2$$e1002000$$ENDHEX$$reservada
	//y a la vez realizar el cambio en la caja
	//con esto se liberan las cajas	
	lds_log_cierre_op.Retrieve(an_op_estilo) //cargar los registros por si tiene para que no falle el insert
	
	For ll_i = 1 To ll_numero_cajas
		ll_orden = lds_cajas.GetItemNumber(ll_i,"co_orden_pdcion")	
		ll_cs_caja = LONG(lds_cajas.GetItemString(ll_i,"cs_canasta"))
		ls_cs_caja = trim(lds_cajas.GetItemString(ll_i,"cs_canasta"))
		
		//**nuevo
		IF lds_cantidad_en_reserva.retrieve(ls_cs_caja,an_op_estilo) <= 0 THEN
			Rollback using SQLCA;
			//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al consultar informaci$$HEX1$$f300$$ENDHEX$$n de las cantidades reservadas")	
	      Return -1
	   END IF		
				
		ll_fila_cons_log =lds_consecutivo_cajas.Find("cs_caja= "+ String(ll_cs_caja) ,1,lds_consecutivo_cajas.RowCount()+1)
		
		Choose Case ll_fila_cons_log
			Case 0
				ll_consec_sig_caja = 1
			Case is> 0
				ll_consec_sig_caja = lds_consecutivo_cajas.GetItemNumber(ll_fila_cons_log,"numero")
				ll_consec_sig_caja = ll_consec_sig_caja + 1
			Case is<0
				Rollback using SQLCA;
				//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","no fue posible encontrar el consecutivo de caja en el log de operaciones.")
			   Return  -1
		End Choose
		
		//log para cierre op
		ll_fila_log = lds_log_cierre_op.InsertRow(0)
		
		//registra la caja en el log de cierre op estilo con el n$$HEX1$$fa00$$ENDHEX$$mero de op estilo correspondiente
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_ordenpd_pt",ll_orden)
		lds_log_cierre_op.SetItem(ll_fila_log, "consecutivo",ll_fila_log)
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_caja",ll_cs_caja)
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_kilos",lds_cajas.GetItemNumber(ll_i,"ca_kilos_act"))
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_conos",lds_cajas.GetItemNumber(ll_i,"ca_conos_act"))
		lds_log_cierre_op.SetItem(ll_fila_log, "usuario",gstr_info_usuario.codigo_usuario)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_creacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_actualizacion",ldt_fe_servidor)
				
		
		//establecer en el log el cambio de orden de producci$$HEX1$$f300$$ENDHEX$$n a cero.
		ll_fila = lds_log.InsertRow(0)	
		lds_log.SetItem(ll_fila,"cs_caja",ll_cs_caja)
		lds_log.SetItem(ll_fila,"numero",ll_consec_sig_caja)
		lds_log.SetItem(ll_fila,"columna","co_orden_pdcion")
		lds_log.SetItem(ll_fila,"valor_viejo",String(ll_orden))
		lds_log.SetItem(ll_fila,"valor_nuevo",'0')
		lds_log.SetItem(ll_fila,"fe_movimiento",ldt_fe_servidor)
		lds_log.SetItem(ll_fila,"usuario",gstr_info_usuario.codigo_usuario)
		lds_log.SetItem(ll_fila,"instancia",gstr_info_usuario.instancia)
		lds_log.SetItem(ll_fila,"fe_actulizacion",ldt_fe_servidor)
		
		//si la caja est$$HEX2$$e1002000$$ENDHEX$$reservada genera otro registro en el log
		//para cambiar pull_list = 0
		If lds_cajas.GetItemNumber(ll_i,"pull_list") = 1 Then
			ll_consec_sig_caja = ll_consec_sig_caja + 1
			ll_fila = lds_log.InsertRow(0)	
			lds_log.SetItem(ll_fila,"cs_caja",ll_cs_caja)
			lds_log.SetItem(ll_fila,"numero",ll_consec_sig_caja)
			lds_log.SetItem(ll_fila,"columna","pull_list")
			lds_log.SetItem(ll_fila,"valor_viejo",'1')
			lds_log.SetItem(ll_fila,"valor_nuevo",'0')
			lds_log.SetItem(ll_fila,"fe_movimiento",ldt_fe_servidor)
			lds_log.SetItem(ll_fila,"usuario",gstr_info_usuario.codigo_usuario)
			lds_log.SetItem(ll_fila,"instancia",gstr_info_usuario.instancia)
			lds_log.SetItem(ll_fila,"fe_actulizacion",ldt_fe_servidor)

			//poner el n$$HEX1$$fa00$$ENDHEX$$mero de pull_list= 0
			lds_cajas.SetItem(ll_i,"pull_list",2)
		End If
		
		ldc_cantidad_reserv      = lds_cantidad_en_reserva.getitemdecimal(1,"ca_kilos")
		ll_conos_reserv          = lds_cantidad_en_reserva.getitemnumber(1,"ca_conos")
		ldc_cantidad_reserv_caja = lds_cajas.getitemdecimal(ll_i,"ca_reservada")
		ll_conos_reserv_caja     = lds_cajas.getitemnumber(ll_i,"ca_reservada_conos")
		
		//se pone en comentario para indentificar problema de inconsistencia
	  /* IF (ldc_cantidad_reserv_caja >= ldc_cantidad_reserv) AND (ll_conos_reserv_caja >= ll_conos_reserv) THEN
	   	ldc_cantidad_tot = ldc_cantidad_reserv_caja - ldc_cantidad_reserv
		   ll_conos_tot     = ll_conos_reserv_caja -ll_conos_reserv
	   ELSE	
			//lo pone en cero siempre y cuando no tenga mas solicitudes pendientes
			
			ldc_cantidad_tot = 0
			ll_conos_tot = 0			
			
	   END IF	*/
		
		IF (ldc_cantidad_reserv_caja >= ldc_cantidad_reserv) AND (ll_conos_reserv_caja >= ll_conos_reserv) THEN
	   	ldc_cantidad_tot = ldc_cantidad_reserv_caja - ldc_cantidad_reserv
		   ll_conos_tot     = ll_conos_reserv_caja -ll_conos_reserv
			
			//poner el n$$HEX1$$fa00$$ENDHEX$$mero de orden en 0
			lds_cajas_cabeza.SetItem(ll_i,"co_orden_pdcion",0)
			lds_cajas_cabeza.SetItem(ll_i,"pull_list",2)
			lds_cajas_cabeza.SetItem(ll_i,"pallet_id",ls_pallet_id)		
			lds_cajas.SetItem(ll_i,"ca_reservada",ldc_cantidad_tot)
			lds_cajas.SetItem(ll_i,"ca_reservada_conos",ll_conos_tot)
			lds_cajas.SetItem(ll_i,"co_maquina_prov",0)			
	   ELSE	
		   //Rollback using SQLCA;
			//Return -1
	   END IF

	Next
End If //fin si existen cajas

w_principal.SetMicroHelp("Cerrando pedidos hilaza...")

//buscar pedidos de hilaza para todas las op estilo de la PO y cambiar estado a 2
If lds_pedido_hilaza.Of_Retrieve(an_op_estilo) > 0 Then
   For ll_i = 1 To lds_pedido_hilaza.RowCount()
		ll_cs_solicitud = lds_pedido_hilaza.GetItemNumber(ll_i,"cs_solicitud")
		lds_pedido_hilaza.SetItem(ll_i,"co_estado_merc",'A')
		
		If lds_actualiza_estado_solicitud.Retrieve(ll_cs_solicitud) < 0 Then
		   Rollback using SQLCA;
			//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al consultar las solicitudes de reserva")	
	      Return -1
		End If
		
		If lds_actualiza_estado_solicitud.RowCount() > 0 Then
			For ll_k = 1 To lds_actualiza_estado_solicitud.RowCount()
				lds_actualiza_estado_solicitud.SetItem(ll_k,"estado","A")
			Next
			
			If lds_actualiza_estado_solicitud.Update() < 0 Then
				Rollback using SQLCA;
				//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar las solicitudes de hilaza")
				Return -1
			End If		
		End If				
		
	Next	
End If

w_principal.SetMicroHelp("Colocando rollos disponibles...")

lds_log_cierre_op.Retrieve(an_op_estilo) //cargar los registros por si tiene para que no falle el insert

//buscar rollos de op estilo asignados, con estado 1
//y colocar co_planeador = 2  estado disponible
//registrar el rollo en log de cierre
If lds_rollos_op.Of_Retrieve(an_op_estilo) > 0 Then
	For ll_i = 1 To lds_rollos_op.RowCount()
		lds_rollos_op.SetItem(ll_i,"co_planeador",2)
      ll_cs_rollo = lds_rollos_op.GetItemNumber(ll_i,"cs_rollo")
		ll_orden = lds_rollos_op.GetItemNumber(ll_i,"cs_ordenpd_pt")
	   //log para cierre op
	   ll_fila_log = lds_log_cierre_op.InsertRow(0)
	
		//registra el rollo en el log de cierre op estilo con el n$$HEX1$$fa00$$ENDHEX$$mero correspondiente de op estilo.
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_ordenpd_pt",ll_orden)
		lds_log_cierre_op.SetItem(ll_fila_log, "consecutivo",ll_fila_log)
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_rollo",ll_cs_rollo)
		lds_log_cierre_op.SetItem(ll_fila_log, "ca_kilos",lds_rollos_op.GetItemNumber(ll_i,"ca_kg"))
		lds_log_cierre_op.SetItem(ll_fila_log, "ca_conos",0)
		lds_log_cierre_op.SetItem(ll_fila_log, "usuario",gstr_info_usuario.codigo_usuario)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_creacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_actualizacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "ca_unidades",lds_rollos_op.GetItemNumber(ll_i,"ca_unidades"))
	Next
End If
	

//se buscan rollos de la op estilo sin asignar, con estado = 2
// centro diferente de 99 y estado igual a 2
// se coloca co_planeador = 2 concepto disponible
//se registrar en el log de cierre op estilo
If lds_rollos_sin.Of_Retrieve(an_op_estilo) > 0 Then
   For ll_i = 1 To lds_rollos_sin.RowCount()
		lds_rollos_sin.SetItem(ll_i,"co_planeador",2)
		ll_cs_rollo = lds_rollos_sin.GetItemNumber(ll_i,"cs_rollo")
		ll_orden = lds_rollos_sin.GetItemNumber(ll_i,"cs_orden_pr_act")
		ll_reftel = lds_rollos_sin.GetItemNumber(ll_i,"co_reftel_act")
		li_centro = lds_rollos_sin.GetItemNumber(ll_i,"co_centro")

	   
		//log para cierre op
	   ll_fila_log = lds_log_cierre_op.InsertRow(0)
	
		//registra el rollo en el log de cierre op estilo
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_ordenpd_pt",ll_orden)
		lds_log_cierre_op.SetItem(ll_fila_log, "consecutivo",ll_fila_log)
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_rollo",ll_cs_rollo)
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_kilos",lds_rollos_sin.GetItemNumber(ll_i,"ca_kg"))
		lds_log_cierre_op.SetItem(ll_fila_log,"co_reftel",ll_reftel)
		lds_log_cierre_op.SetItem(ll_fila_log,"co_centro",li_centro)
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_conos",0)
		lds_log_cierre_op.SetItem(ll_fila_log, "usuario",gstr_info_usuario.codigo_usuario)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_creacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_actualizacion",ldt_fe_servidor)   
		lds_log_cierre_op.SetItem(ll_fila_log, "ca_unidades",lds_rollos_sin.GetItemNumber(ll_i,"ca_unidades"))
	
	Next
End If

w_principal.SetMicroHelp("Estableciendo OP Estilo como cumplida...")

//traer el valor del estado de op estilo cumplida
ll_opestilo_cumplida = n_cons_tela.Of_consultar_numerico('OP_ESTILO_CUMPLIDA')

If ll_opestilo_cumplida = -1 Then
	Rollback using SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar la constante de estado cumplida para OP Estilo")
	Return -1
End If

//coloca todas las op estilo de la PO como cumplidas
For ll_i = 1 To lds_infoop.RowCount()
	lds_infoop.SetItem(ll_i,"co_estado_orden",ll_opestilo_cumplida)
   lds_infoop.SetItem(ll_i,"co_cpto_cierra",li_cpto_cerrar)
	lds_infoop.SetItem(ll_i,"fe_actualizacion",ldt_fe_servidor)
	lds_infoop.SetItem(ll_i,"observacion","OP Cer:"+ & 
				trim(gstr_info_usuario.codigo_usuario)+ " fe: "+ String(ldt_fe_servidor,"dd/mm/yyyy"))
Next 

w_principal.SetMicroHelp("Estableciendo OP Tejido como cumplida...")
ll_filas_centro_cero = lds_gr_rollos_en_centro_cero.Of_Retrieve(an_op_estilo)

//Controla que no se cambie el estado a OPs de Tejido con rollos pendientes por tejer
If ll_filas_centro_cero > 0 OR ll_filas_centro_cero < 0 Then
	Rollback using SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","La Op " + String(an_op_estilo) + " tiene rollos pendientes por tejer")
   Return -1
End If

//traer el valor del estado de op tejido cumplida
ll_optejido_cumplida = n_cons_tela.Of_consultar_numerico('OP_TEJIDO_CUMPLIDA')

If ll_optejido_cumplida = -1 Then
	Rollback using SQLCA;
	Return -1	
End If

//buscar las op tejido relacionadas con todas las op estilo de la PO
If lds_actualiza_optejido.Of_Retrieve(an_op_estilo) > 0 Then
  // MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar las op tejido relacionadas con op estilo: "+ ls_ops)
  // Return -1
  //actualiza el estado de las op tejido para establecerlas como cumplidas
	For ll_i = 1 To lds_actualiza_optejido.RowCount()
		lds_actualiza_optejido.SetItem(ll_i,"co_estado_orden",ll_optejido_cumplida)
		lds_actualiza_optejido.SetItem(ll_i,"fe_actualizacion",ldt_fe_servidor)
		lds_actualiza_optejido.SetItem(ll_i,"usuario",gstr_info_usuario.codigo_usuario)
	Next
End If

//buscar las op tejido relacionadas con todas las op estilo de la PDP
If lds_actualiza_optejido_pdp.Of_Retrieve(an_op_estilo) > 0 Then
  // MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar las op tejido relacionadas con op estilo: "+ ls_ops)
  // Return -1
  //actualiza el estado de las op tejido para establecerlas como cumplidas
	For ll_i = 1 To lds_actualiza_optejido_pdp.RowCount()
		lds_actualiza_optejido_pdp.SetItem(ll_i,"co_estado","I")
		lds_actualiza_optejido_pdp.SetItem(ll_i,"fe_actualizacion",ldt_fe_servidor)
		lds_actualiza_optejido_pdp.SetItem(ll_i,"usuario",gstr_info_usuario.codigo_usuario)
	Next
End If

w_principal.SetMicroHelp("Estableciendo Ordenes de Tejido como cumplidas...")

//busca las ordenes de tejido relacionadas con todas las op estilode la PO
If lds_actualiza_ordentejido.Of_Retrieve(an_op_estilo) <= 0 Then
	Rollback using SQLCA;
   //MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar las ordenes de tejido relacionadas con la op estilo: " + String(an_op_estilo))
   Return -1
End If

//actualiza el estado de las ordenes tejido para establecerlas como cumplidas
For ll_i = 1 To lds_actualiza_ordentejido.RowCount()
	lds_actualiza_ordentejido.SetItem(ll_i,"co_estado_orden",ll_optejido_cumplida)
Next

//buscar constante de tintura completa.
ll_tintura_completa = n_cons_tela.Of_consultar_numerico('TE$$HEX1$$d100$$ENDHEX$$IDO_COMPLETA')

//no encontr$$HEX2$$f3002000$$ENDHEX$$constante
If  ll_tintura_completa = -1 Then
	Rollback using SQLCA;
	Return -1
End If

lds_telas_op.Of_Retrieve(an_op_estilo)

//quita los pendientes de tintura para todas las op estilo de la PO.
For ll_i = 1 To lds_telas_op.RowCount()
	lds_telas_op.SetItem(ll_i,"co_estado",ll_tintura_completa)
Next

/*-------------------------- Inicio actualizaci$$HEX1$$f300$$ENDHEX$$n de la informaci$$HEX1$$f300$$ENDHEX$$n---------------------------*/

If lds_cajas.Update() < 0 Then
	ROLLBACK USING SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar cajas disponibles")
	Return -1
End If

If lds_cajas_cabeza.Update() < 0 Then
	ROLLBACK USING SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar cajas disponibles")
	Return -1
End If

If lds_log.Update() < 0  Then
	ROLLBACK USING SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar log de cajas")
	Return -1
End If

If lds_pedido_hilaza.Update() < 0 Then
	ROLLBACK USING SQLCA;
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar pedidos de hilaza")
	Return -1
End If

If lds_rollos_op.Update() < 0 Then
	ROLLBACK USING SQLCA;
   //MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar rollos disponibles")
	Return -1
End If

If lds_rollos_sin.Update() < 0 Then
	ROLLBACK USING SQLCA;
   //MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar rollos disponibles")
	Return -1
End If

If lds_actualiza_optejido.Update() < 0 Then
	ROLLBACK USING SQLCA;
   //MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar O.P de Tejido")
	Return -1
End If

If lds_actualiza_optejido_pdp.Update() < 0 Then
	ROLLBACK USING SQLCA;
//   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar O.P de Tejido en el PDP")
	Return -1
End If

If lds_actualiza_ordentejido.Update() < 0 Then
	ROLLBACK USING SQLCA;
//   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar ordenes de tejido")
	Return -1
End If

If lds_telas_op.Update() < 0 Then
	ROLLBACK USING SQLCA;
//   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar estado tintura")
	Return -1
End If

If lds_log_cierre_op.Update() < 0 Then
	ROLLBACK USING SQLCA;
//   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error registrando log de cierre de O.P de Estilo")
	Return -1
End If

If lds_infoop.Update() < 0 Then
	ROLLBACK USING SQLCA;
//   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error actualizando informaci$$HEX1$$f300$$ENDHEX$$n de  O.P de Estilo: "+ ls_ops)
	Return -1
End If


COMMIT USING SQLCA;


DESTROY lds_infoop;
DESTROY lds_cajas
DESTROY lds_log
DESTROY lds_pedido_hilaza
DESTROY lds_rollos_op
DESTROY lds_rollos_sin
DESTROY lds_actualiza_optejido
DESTROY lds_actualiza_optejido_pdp
DESTROY lds_actualiza_ordentejido
DESTROY lds_telas_op
DESTROY lds_log_cierre_op
DESTROY lds_consecutivo_cajas
DESTROY ld_gr_rollos_de_op_en_proceso
DESTROY lds_cajas_cabeza               
DESTROY lds_cantidad_en_reserva        
DESTROY lds_actualiza_estado_solicitud 

/*-------------------------- Fin actualizaci$$HEX1$$f300$$ENDHEX$$n de la informaci$$HEX1$$f300$$ENDHEX$$n---------------------------*/

w_principal.SetMicroHelp("")


Return 1
end function

public function long of_cerrar_tempo (ref long an_op_estilo[]);/*------------of_cerrar_opestilo----------------------------------
El proceso de cerrar una OP de estilo se realiza de la siguiente forma:

*verificar que la op no est$$HEX2$$e9002000$$ENDHEX$$cerrada con anterioridad.

1.	El sistema debe abrir una ventana donde pida La OP de Estilo a cerrar,
2.	El usuario ingresa el n$$HEX1$$fa00$$ENDHEX$$mero de la OP de Estilo.
3.	El sistema debe buscar con la OP de Estilo en la tabla h_ordenpd_pt traer la fabrica, l$$HEX1$$ed00$$ENDHEX$$nea,  referencia  y cliente y buscar el nombre de la referencia en la tabla h_preref_pv y en nombre del cliente en la tabla cc_cliente y los n$$HEX1$$fa00$$ENDHEX$$meros de po de la tabla dt_pedidosxorden el campo nu_orden,  desplegar estos datos en la pantalla.
4.	El usuario presiona el bot$$HEX1$$f300$$ENDHEX$$n de Cerrar OP para inicial el proceso.
5.	El sistema pregunta si est$$HEX2$$e1002000$$ENDHEX$$seguro de cerrar La OP y dejar disponibles los rollos y cajas que hay en el proceso
6.	El usuario confirma o rechaza la acci$$HEX1$$f300$$ENDHEX$$n
7.	Si confirma la acci$$HEX1$$f300$$ENDHEX$$n, el sistema realiza las siguiente tareas:
7.1	Mostrar mensaje diciendo:  colocando cajas disponibles
7.2	Buscar las cajas que hay en la tabla cajas con ca_kilos_act > 0 y con el campo co_orden_pdcion igual a la orden de producci$$HEX1$$f300$$ENDHEX$$n asignada, si existe alguna con el campo pull_list = 1 se debe mostrar mensaje diciendo al usuario que existen cajas reservadas sin entregar si desea continuar con el proceso, si dice que si se continua si dice que no se sale sin grabar
7.3	Tomar cada caja e insertar en el log de cambios de cajas,   esta es la tabla mv_log_cajasup, si se le cambio el pull_list y la OP se debe insertar dos registros por cada caja, en el campo columna  se coloca 'co_orden_pdccion' o 'pull_list' seg$$HEX1$$fa00$$ENDHEX$$n lo que se cambia y en valor viejo y valor nuevo los valores que tenia y como quedo la caja.
7.4	Marcar las cajas con co_orden_pdcion = 0 y pull_list = 0
7.5	Buscar si existen pedidos de hilaza creados en la tabla h_pedido_hilazas con join con el campo dt_pedido_cajas con el campo h_pedido_hilazas.cs_ordenpd_pt igual a la OP ingresada y con h_pedido_hilazas.estado  = 1  y en la tabla dt_pedido_cajas.cs_caja_ent = 0, si existe alguno se debe poner el campo h_pedido_hilazas.estado = 2.
7.6	Mostrar mensaje diciendo: colocando rollos disponibles
7.7	Buscar las OP de tejido que hay en la tabla h_op_tejido  que tienen la OP ingresada en el campo cs_ordenpd_pt,  y con estado  = 1 y con esos numeros de OP de tejido buscar en m_rollo en el campo cs_orden_pr_act = op_tejido y con co_estado_rollo = 1, si encontramos algun rollo se cambia el campo co_planeador por 2.
7.8	Buscar los rollos que hay en centros con estado = 2 y centro diferente de 99 y colocar el campo co_planeador = 2.
7.9	Colocar el campo co_estado_orden en h_ordenpd_pt = 6 (cumplida) tomar el numero de las constantes m_constant_tela con var_nombre = 'OP_ESTILO_CUMPLIDA'
7.10	Buscar en h_ordenpd_te y h_op_tejido las op con el campo cs_ordenpd_pt = a la OP ingresada por el usuario y colocar el campo co_estado_orden en h_ordenpd_te y co_estado_orden en h_op_tejido = 10 (cumplida)  tomar el numero de las constantes m_constant_tela con var_nombre = 'OP_TEJIDO_CUMPLIDA'
7.11	Buscar en dt_detalle_telas_op todos los registros con el campo cs_ordenpd_pt igual a la OP ingresada, buscar los que tengan  co_Estado diferente de 16  (constante en m_constant_tela = TE$$HEX1$$d100$$ENDHEX$$IDO_COMPLETA     ) y mirar si alguno tiene ca_kilos_tint menor que  ca_kilos_prog, si existe mostrar al usuario si continua proceso y si continua colocar estado en 16 (contantes)
7.12	Crear observaci$$HEX1$$f300$$ENDHEX$$n  sobre cerrado de la op en la tabla h_ordenpd_pt campo observaci$$HEX1$$f300$$ENDHEX$$n, decir : 'OP cerrada por: ' user 'fecha cerrada: ' current (El campo aun no se ha creado en vesrs00, solo en marrs01)
7.13	Cargar log de op cerradas, la tabla se llama mv_log_cierra_op, en esta se debe insertar la op y cada uno de los rollos con sus kilos y las cajas con sus kilos y conos que se cambiaron de estado.
-----------------------------------------------------------------*/


Long ll_numero_cajas, ll_i, ll_cs_caja, ll_fila, ll_orden,ll_fila_log, ll_cs_rollo
Long ll_tintura_completa,ll_opestilo_cumplida, ll_optejido_cumplida, ll_ordenes[]
uo_dsbase lds_cajas, lds_log, lds_pedido_hilaza, lds_rollos_op, lds_rollos_sin
uo_dsbase  lds_actualiza_optejido, lds_infoop
uo_dsbase lds_actualiza_ordentejido, lds_telas_op, lds_log_cierre_op, lds_consecutivo_cajas
Long li_res
Datetime ldt_fe_servidor
n_cts_constantes_tela n_cons_tela
String ls_ops
Long ll_cajas[]
Long ll_consec_sig_caja, ll_fila_cons_log

lds_infoop=						Create uo_dsbase
lds_cajas = 				   Create uo_dsbase
lds_log   = 				   Create uo_dsbase
lds_pedido_hilaza = 		   Create uo_dsbase
lds_rollos_op = 			   Create uo_dsbase
lds_rollos_sin = 			   Create uo_dsbase
lds_actualiza_optejido=    Create uo_dsbase
lds_actualiza_ordentejido= Create uo_dsbase
lds_telas_op = 				Create uo_dsbase
lds_log_cierre_op=			Create uo_dsbase
lds_consecutivo_cajas=		Create uo_dsbase

//ls_ordenes = dw_infoop.Object.nu_orden.current

lds_infoop.DataObject = "d_gr_info_opestilo_2"
lds_infoop.SetTransObject(SQLCA)

//cajas de las ordenes de op estilo
lds_cajas.DataObject = "d_gr_cajas_ordenes"
lds_cajas.SetTransObject(SQLCA)

//registra en el log de cajas
lds_log.DataObject = "d_gr_log_cajas"
lds_log.SetTransObject(SQLCA)

//busca pedidos de hilaza
lds_pedido_hilaza.DataObject = "d_gr_pedido_hilaza"
lds_pedido_hilaza.SetTransObject(SQLCA)

//carga los rollos asignados a op tejido
lds_rollos_op.DataObject= "d_gr_rollos_opestilo"
lds_rollos_op.SetTransObject(SQLCA)

//carga los rollos sin asignar
lds_rollos_sin.DataObject = "d_gr_rollos_sin_asignar"
lds_rollos_sin.SetTransObject(SQLCA)

//actualizar estado de op tejido
lds_actualiza_optejido.DataObject= "d_gr_actualizar_op_tejido"
lds_actualiza_optejido.SetTransObject(SQLCA)

//actualizar ordenes de tejido
lds_actualiza_ordentejido.DataObject = "d_gr_actualizar_orden_tejido"
lds_actualiza_ordentejido.SetTransObject(SQLCA)

//actualizar estado tintura op estilo en dt_detalle_telas_op
lds_telas_op.DataObject = "d_gr_cerrar_tin_opestilo"
lds_telas_op.SetTransObject(SQLCA)

//log de cierre op.
lds_log_cierre_op.DataObject = "d_gr_log_cierre_op"
lds_log_cierre_op.SetTransObject(SQLCA)

//m$$HEX1$$e100$$ENDHEX$$ximo valor del campo n$$HEX1$$fa00$$ENDHEX$$mero por caja en log de cajas
lds_consecutivo_cajas.DataObject = "d_gr_consecutivo_cajas"
lds_consecutivo_cajas.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ldt_fe_servidor = f_fecha_servidor()

ls_ops = ""

//en este ciclo se crea una cadena con todas las op estilo de la PO a cerrar
For ll_i = 1 To UpperBound(an_op_estilo)
	If ll_i = 1 Then
		ls_ops = ls_ops + String(an_op_estilo[ll_i]) 
	Else	
		ls_ops = ls_ops + "-" + String(an_op_estilo[ll_i])
	End If	
Next

//buca la informaci$$HEX1$$f300$$ENDHEX$$n para todas las op estilo
If lds_infoop.Retrieve(an_op_estilo) <= 0 Then
	//MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al consultar informaci$$HEX1$$f300$$ENDHEX$$n de las OP Estilo")
	//Return -1
End If

w_principal.SetMicroHelp("Colocando cajas disponibles...")


//se buscan las cajas de las op estilo con kilos act > 0
ll_numero_cajas = lds_cajas.Of_Retrieve(an_op_estilo)

If ll_numero_cajas <= 0 Then
	If ll_numero_cajas = -1 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error buscando cajas de ordenes relacionadas con OP Estilo: " + ls_ops)
		Return -1
	End If
Else

//se buscan cajas reservadas para todas las op estilo
If lds_cajas.Find("pull_list= 1",1,(ll_numero_cajas + 1)) >0 Then
//	li_res = MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Existen cajas reservadas sin entregar $$HEX1$$bf00$$ENDHEX$$Desea continuar con el proceso? ",Question!, OKCancel!, 2)
//	If li_res <> 1 Then //si no acept$$HEX1$$f300$$ENDHEX$$, sale 
	//	Return 0 
	//End If
End If

//buscar los consecutivos de cajas, para determinar luego en que n$$HEX1$$fa00$$ENDHEX$$mero va cada una en el log
For ll_i = 1 To ll_numero_cajas
	ll_cajas[ll_i]	= lds_cajas.GetItemNumber(ll_i,"cs_caja")
Next 

//trae el consecutivo de la caja con el valor m$$HEX1$$e100$$ENDHEX$$ximo del campo n$$HEX1$$fa00$$ENDHEX$$mero si existe.
If lds_consecutivo_cajas.Retrieve(ll_cajas) < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Ocurri$$HEX2$$f3002000$$ENDHEX$$un error determinando los consecutivos de cajas")	
	Return -1
End If

	//recorre todas las cajas para registrar en el log lo que se cambia (numero orden o pull_list)
	//el pull_list =1 indica que la caja est$$HEX2$$e1002000$$ENDHEX$$reservada
	//y a la vez realizar el cambio en la caja
	//con esto se liberan las cajas
	For ll_i = 1 To ll_numero_cajas
		ll_orden = lds_cajas.GetItemNumber(ll_i,"co_orden_pdcion")	
		ll_cs_caja = lds_cajas.GetItemNumber(ll_i,"cs_caja")
		
		ll_fila_cons_log =lds_consecutivo_cajas.Find("cs_caja= "+ String(ll_cs_caja) ,1,lds_consecutivo_cajas.RowCount()+1)
		
		Choose Case ll_fila_cons_log
			Case 0
				ll_consec_sig_caja = 1
			Case is> 0
				ll_consec_sig_caja = lds_consecutivo_cajas.GetItemNumber(ll_fila_cons_log,"numero")
				ll_consec_sig_caja = ll_consec_sig_caja + 1
			Case is<0
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","no fue posible encontrar el consecutivo de caja en el log de operaciones.")
			   Return  -1
		End Choose
		
		//log para cierre op
		ll_fila_log = lds_log_cierre_op.InsertRow(0)
		
		//registra la caja en el log de cierre op estilo con el n$$HEX1$$fa00$$ENDHEX$$mero de op estilo correspondiente
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_ordenpd_pt",ll_orden)
		lds_log_cierre_op.SetItem(ll_fila_log, "consecutivo",ll_fila_log)
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_caja",ll_cs_caja)
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_kilos",lds_cajas.GetItemNumber(ll_i,"ca_kilos_act"))
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_conos",lds_cajas.GetItemNumber(ll_i,"ca_conos_act"))
		lds_log_cierre_op.SetItem(ll_fila_log, "usuario",gstr_info_usuario.codigo_usuario)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_creacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_actualizacion",ldt_fe_servidor)
		
		
		//establecer en el log el cambio de orden de producci$$HEX1$$f300$$ENDHEX$$n a cero.
		ll_fila = lds_log.InsertRow(0)	
		lds_log.SetItem(ll_fila,"cs_caja",ll_cs_caja)
		lds_log.SetItem(ll_fila,"numero",ll_consec_sig_caja)
		lds_log.SetItem(ll_fila,"columna","co_orden_pdcion")
		lds_log.SetItem(ll_fila,"valor_viejo",String(ll_orden))
		lds_log.SetItem(ll_fila,"valor_nuevo",'0')
		lds_log.SetItem(ll_fila,"fe_movimiento",ldt_fe_servidor)
		lds_log.SetItem(ll_fila,"usuario",gstr_info_usuario.codigo_usuario)
		lds_log.SetItem(ll_fila,"instancia",gstr_info_usuario.instancia)
		lds_log.SetItem(ll_fila,"fe_actulizacion",ldt_fe_servidor)
		
		//si la caja est$$HEX2$$e1002000$$ENDHEX$$reservada genera otro registro en el log
		//para cambiar pull_list = 0
		If lds_cajas.GetItemNumber(ll_i,"pull_list") = 1 Then
			ll_consec_sig_caja = ll_consec_sig_caja + 1
			ll_fila = lds_log.InsertRow(0)	
			lds_log.SetItem(ll_fila,"cs_caja",ll_cs_caja)
			lds_log.SetItem(ll_fila,"numero",ll_consec_sig_caja)
			lds_log.SetItem(ll_fila,"columna","pull_list")
			lds_log.SetItem(ll_fila,"valor_viejo",'1')
			lds_log.SetItem(ll_fila,"valor_nuevo",'0')
			lds_log.SetItem(ll_fila,"fe_movimiento",ldt_fe_servidor)
			lds_log.SetItem(ll_fila,"usuario",gstr_info_usuario.codigo_usuario)
			lds_log.SetItem(ll_fila,"instancia",gstr_info_usuario.instancia)
			lds_log.SetItem(ll_fila,"fe_actulizacion",ldt_fe_servidor)

			//poner el n$$HEX1$$fa00$$ENDHEX$$mero de pull_list= 0
			lds_cajas.SetItem(ll_i,"pull_list",0)
		End If
		
		//poner el n$$HEX1$$fa00$$ENDHEX$$mero de orden en 0
		lds_cajas.SetItem(ll_i,"co_orden_pdcion",0)

	Next
End If //fin si existen cajas

w_principal.SetMicroHelp("Cerrando pedidos hilaza...")

//buscar pedidos de hilaza para todas las op estilo de la PO y cambiar estado a 2
If lds_pedido_hilaza.Of_Retrieve(an_op_estilo) > 0 Then
   For ll_i = 1 To lds_pedido_hilaza.RowCount()
		lds_pedido_hilaza.SetItem(ll_i,"estado",2)
	Next	
End If

w_principal.SetMicroHelp("Colocando rollos disponibles...")

//buscar rollos de op estilo asignados, con estado 1
//y colocar co_planeador = 2  estado disponible
//registrar el rollo en log de cierre
If lds_rollos_op.Of_Retrieve(an_op_estilo) > 0 Then
	For ll_i = 1 To lds_rollos_op.RowCount()
		lds_rollos_op.SetItem(ll_i,"co_planeador",2)
      ll_cs_rollo = lds_rollos_op.GetItemNumber(ll_i,"cs_rollo")
		ll_orden = lds_rollos_op.GetItemNumber(ll_i,"cs_ordenpd_pt")
	   //log para cierre op
	   ll_fila_log = lds_log_cierre_op.InsertRow(0)
	
		//registra el rollo en el log de cierre op estilo con el n$$HEX1$$fa00$$ENDHEX$$mero correspondiente de op estilo.
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_ordenpd_pt",ll_orden)
		lds_log_cierre_op.SetItem(ll_fila_log, "consecutivo",ll_fila_log)
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_rollo",ll_cs_rollo)
		lds_log_cierre_op.SetItem(ll_fila_log, "ca_kilos",lds_rollos_op.GetItemNumber(ll_i,"ca_kg"))
		lds_log_cierre_op.SetItem(ll_fila_log, "ca_conos",0)
		lds_log_cierre_op.SetItem(ll_fila_log, "usuario",gstr_info_usuario.codigo_usuario)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_creacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_actualizacion",ldt_fe_servidor)
	Next
End If
	

//se buscan rollos de la op estilo sin asignar, con estado = 2
// centro diferente de 99 y estado igual a 2
// se coloca co_planeador = 2 concepto disponible
//se registrar en el log de cierre op estilo
If lds_rollos_sin.Of_Retrieve(an_op_estilo) > 0 Then
   For ll_i = 1 To lds_rollos_sin.RowCount()
		lds_rollos_sin.SetItem(ll_i,"co_planeador",2)
		ll_cs_rollo = lds_rollos_sin.GetItemNumber(ll_i,"cs_rollo")
		ll_orden = lds_rollos_sin.GetItemNumber(ll_i,"cs_orden_pr_act")
	   
		//log para cierre op
	   ll_fila_log = lds_log_cierre_op.InsertRow(0)
	
		//registra el rollo en el log de cierre op estilo
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_ordenpd_pt",ll_orden)
		lds_log_cierre_op.SetItem(ll_fila_log, "consecutivo",ll_fila_log)
		lds_log_cierre_op.SetItem(ll_fila_log, "cs_rollo",ll_cs_rollo)
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_kilos",lds_rollos_sin.GetItemNumber(ll_i,"ca_kg"))
		lds_log_cierre_op.SetItem(ll_fila_log,"ca_conos",0)
		lds_log_cierre_op.SetItem(ll_fila_log, "usuario",gstr_info_usuario.codigo_usuario)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_creacion",ldt_fe_servidor)
		lds_log_cierre_op.SetItem(ll_fila_log, "fe_actualizacion",ldt_fe_servidor)   
	
	Next
End If

w_principal.SetMicroHelp("Estableciendo OP Estilo como cumplida...")

//traer el valor del estado de op estilo cumplida
ll_opestilo_cumplida = n_cons_tela.Of_consultar_numerico('OP_ESTILO_CUMPLIDA')

If ll_opestilo_cumplida = -1 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar la constante de estado cumplida para OP Estilo")
	Return -1
End If

//coloca todas las op estilo de la PO como cumplidas
For ll_i = 1 To lds_infoop.RowCount()
	lds_infoop.SetItem(ll_i,"co_estado_orden",ll_opestilo_cumplida)
	lds_infoop.SetItem(ll_i,"observacion","OP Cerr. usu: "+ & 
				gstr_info_usuario.codigo_usuario+ " fe: "+ String(ldt_fe_servidor))
Next 

w_principal.SetMicroHelp("Estableciendo OP Tejido como cumplida...")

//traer el valor del estado de op tejido cumplida
ll_optejido_cumplida = n_cons_tela.Of_consultar_numerico('OP_TEJIDO_CUMPLIDA')

If ll_optejido_cumplida = -1 Then
	Return -1	
End If

//buscar las op tejido relacionadas con todas las op estilo de la PO
If lds_actualiza_optejido.Of_Retrieve(an_op_estilo) > 0 Then
  // MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar las op tejido relacionadas con op estilo: "+ ls_ops)
  // Return -1
  //actualiza el estado de las op tejido para establecerlas como cumplidas
	For ll_i = 1 To lds_actualiza_optejido.RowCount()
		lds_actualiza_optejido.SetItem(ll_i,"co_estado_orden",ll_optejido_cumplida)
		lds_actualiza_optejido.SetItem(ll_i,"fe_actualizacion",ldt_fe_servidor)
		lds_actualiza_optejido.SetItem(ll_i,"usuario",gstr_info_usuario.codigo_usuario)
	Next
End If



w_principal.SetMicroHelp("Estableciendo Ordenes de Tejido como cumplidas...")

//busca las ordenes de tejido relacionadas con todas las op estilode la PO
If lds_actualiza_ordentejido.Of_Retrieve(an_op_estilo) <= 0 Then
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No fue posible determinar las ordenes de tejido relacionadas con la op estilo: " + String(an_op_estilo))
   Return -1
End If

//actualiza el estado de las ordenes tejido para establecerlas como cumplidas
For ll_i = 1 To lds_actualiza_ordentejido.RowCount()
	lds_actualiza_ordentejido.SetItem(ll_i,"co_estado_orden",ll_optejido_cumplida)
Next

//buscar constante de tintura completa.
ll_tintura_completa = n_cons_tela.Of_consultar_numerico('TE$$HEX1$$d100$$ENDHEX$$IDO_COMPLETA')

//no encontr$$HEX2$$f3002000$$ENDHEX$$constante
If  ll_tintura_completa = -1 Then
	Return -1
End If

//si existen registro pendientes en tintura para alguna de las op estilo de la PO
//pregunta al usuario si continua el proceso.

If lds_telas_op.Of_Retrieve(an_op_estilo) <= 0 Then
   //no existen registrospendientes
Else //pregunta si continua
//	li_res = MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Existen Pendientes de tintura $$HEX1$$bf00$$ENDHEX$$Desea continuar con el proceso? ",Question!, OKCancel!, 2)
  // If li_res <> 1 Then //si no acept$$HEX1$$f300$$ENDHEX$$, sale 
//      Return 0 
 //  End If
End If

//quita los pendientes de tintura para todas las op estilo de la PO.
For ll_i = 1 To lds_telas_op.RowCount()
	lds_telas_op.SetItem(ll_i,"co_estado",ll_tintura_completa)
Next

/*-------------------------- Inicio actualizaci$$HEX1$$f300$$ENDHEX$$n de la informaci$$HEX1$$f300$$ENDHEX$$n---------------------------*/

If lds_cajas.Update() < 0 Then
	ROLLBACK USING SQLCA;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar cajas disponibles")
	Return -1
End If

If lds_log.Update() < 0  Then
	ROLLBACK USING SQLCA;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar log de cajas")
	Return -1
End If

If lds_pedido_hilaza.Update() < 0 Then
	ROLLBACK USING SQLCA;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar pedidos de hilaza")
	Return -1
End If

If lds_rollos_op.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar rollos disponibles")
	Return -1
End If

If lds_rollos_sin.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al colocar rollos disponibles")
	Return -1
End If

If lds_actualiza_optejido.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar O.P de Tejido")
	Return -1
End If

If lds_actualiza_ordentejido.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar ordenes de tejido")
	Return -1
End If


If lds_telas_op.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error al actualizar estado tintura")
	Return -1
End If

If lds_log_cierre_op.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error registrando log de cierre de O.P de Estilo")
	Return -1
End If

If lds_infoop.Update() < 0 Then
	ROLLBACK USING SQLCA;
   MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Error actualizando informaci$$HEX1$$f300$$ENDHEX$$n de  O.P de Estilo: "+ ls_ops)
	Return -1
End If


COMMIT USING SQLCA;


Destroy lds_infoop					
Destroy lds_cajas 			   
Destroy lds_log   			  
Destroy lds_pedido_hilaza 	   
Destroy lds_rollos_op 			  
Destroy lds_rollos_sin 		  
Destroy lds_actualiza_optejido 
Destroy lds_actualiza_ordentejido
Destroy lds_telas_op 
Destroy lds_log_cierre_op
Destroy lds_consecutivo_cajas


/*-------------------------- Fin actualizaci$$HEX1$$f300$$ENDHEX$$n de la informaci$$HEX1$$f300$$ENDHEX$$n---------------------------*/

w_principal.SetMicroHelp("")

//presenta mensaje de exito del proceso.
/*If UpperBound(an_op_estilo) = 1 Then //una sola op estilo
	MessageBox("Mensaje","La O.P de estilo " + String(an_op_estilo[1]) + " fue cerrada con $$HEX1$$e900$$ENDHEX$$xito")
Else //se cierra una PO con varias op estilo.
	MessageBox("Mensaje","Las O.P de estilo " + ls_ops + " fueron cerradas con $$HEX1$$e900$$ENDHEX$$xito")
End If*/

Return 1
end function

public function long of_cerrar_hlza (long an_op_estilo[]);RETURN 1
end function

public function long of_validar_op_sumary (long an_op_sumary[]);Long ll_rollos_proceso

  
uo_dsbase ld_gr_rollos_de_op_en_proceso, lds_gr_rollos_en_centro_cero //, //lds_infoop 

//lds_infoop=						Create uo_dsbase
ld_gr_rollos_de_op_en_proceso  = Create uo_dsbase
lds_gr_rollos_en_centro_cero   = Create uo_dsbase

//lds_infoop.DataObject = "d_gr_info_opestilo"
//lds_infoop.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//Rollos pendientes en el proceso de tintoreria y acabados
ld_gr_rollos_de_op_en_proceso.DataObject = "d_gr_rollos_de_op_en_proceso"
ld_gr_rollos_de_op_en_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//Rollos pendientes en tejido
lds_gr_rollos_en_centro_cero.DataObject = "dtb_rollos_centro_cero_x_op_estilo"
lds_gr_rollos_en_centro_cero.SetTransObject(gnv_recursos.of_get_transaccion_sucia())


//controla que no tenga kilos en los centros
ll_rollos_proceso = ld_gr_rollos_de_op_en_proceso.Retrieve(an_op_sumary)
IF ll_rollos_proceso = 0 THEN
ELSE
//	DESTROY lds_infoop;
	DESTROY ld_gr_rollos_de_op_en_proceso
	DESTROY lds_gr_rollos_en_centro_cero         
	Return -1	
END IF


//Controla que no tenga OPs de Tejido con rollos pendientes por tejer
If lds_gr_rollos_en_centro_cero.Of_Retrieve(an_op_sumary) = 0 Then
ELSE
	//DESTROY lds_infoop;
   DESTROY ld_gr_rollos_de_op_en_proceso
   DESTROY lds_gr_rollos_en_centro_cero         
   Return -1
End If

//DESTROY lds_infoop;
DESTROY ld_gr_rollos_de_op_en_proceso
DESTROY lds_gr_rollos_en_centro_cero         


//si no retorna -1 es por que no tiene tela la op sumary asi que cierra tambien la op sumary
of_cerrar_op_estilo(an_op_sumary)

Return 1
end function

on n_cerrar_po.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cerrar_po.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

