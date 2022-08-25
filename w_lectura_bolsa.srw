HA$PBExportHeader$w_lectura_bolsa.srw
forward
global type w_lectura_bolsa from window
end type
type cb_4 from commandbutton within w_lectura_bolsa
end type
type dw_1 from datawindow within w_lectura_bolsa
end type
type cbx_2 from checkbox within w_lectura_bolsa
end type
type cbx_1 from checkbox within w_lectura_bolsa
end type
type cb_3 from commandbutton within w_lectura_bolsa
end type
type cb_2 from commandbutton within w_lectura_bolsa
end type
type cb_sobrante from commandbutton within w_lectura_bolsa
end type
type cb_1 from commandbutton within w_lectura_bolsa
end type
type dw_adhesivos from datawindow within w_lectura_bolsa
end type
type sle_parte from singlelineedit within w_lectura_bolsa
end type
type dw_detalle from datawindow within w_lectura_bolsa
end type
type dw_maestro from datawindow within w_lectura_bolsa
end type
type gb_1 from groupbox within w_lectura_bolsa
end type
type gb_2 from groupbox within w_lectura_bolsa
end type
end forward

global type w_lectura_bolsa from window
integer width = 2062
integer height = 1872
boolean titlebar = true
string title = "Lectura Bolsa"
string menuname = "m_mantenimiento_simple"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_grabar ( )
cb_4 cb_4
dw_1 dw_1
cbx_2 cbx_2
cbx_1 cbx_1
cb_3 cb_3
cb_2 cb_2
cb_sobrante cb_sobrante
cb_1 cb_1
dw_adhesivos dw_adhesivos
sle_parte sle_parte
dw_detalle dw_detalle
dw_maestro dw_maestro
gb_1 gb_1
gb_2 gb_2
end type
global w_lectura_bolsa w_lectura_bolsa

type variables
Decimal{2} idc_ca_actual
Long al_parte, il_referencia,il_codigo, al_corte
Long ii_fabrica, ii_linea, ii_centro_corte,  ii_validar, il_marca, ii_ctro_fisico, ii_marca_especial, ii_mostrar_sobrante
Boolean ib_bongo, ib_lote_piloto
uo_dsbase ids_unid_sobrantes_loteo
Time it_entrada_teclado[]
Long ii_cont_fec_entrada = 0
Long il_ca_pedida, il_ca_x_lotear
Boolean ib_reintentar_bongos_sin_pdp = True
end variables

forward prototypes
public function long of_insertar_loteo (long al_ordencorte, long ai_fabrica, long ai_linea, long al_referencia, long al_codigo)
public function long of_validarconceptounidadesmenos (long al_ordencorte, string as_bolsa, decimal adc_cant_new, decimal adc_cant_old)
protected function long of_lotear (long al_orden_corte, string as_po, long al_duo_conjunto)
public function long f_marcar_oc_con_sobras (long al_orden_corte, long ai_marca)
public function long of_marcar_bongo_sobras (long al_bongo, string as_canasta)
public function long of_ops_a_cerrar (long al_ordencorte)
public function long of_verifica_nuevo_grupo_sobrantes (string as_bongos[])
public function long of_marcar_bolsa_pdccon (long al_bongo, string as_canasta)
public function long wf_leerconstantes (readonly string as_constante, readonly string as_error)
public function long wf_leerconstantescorte (readonly string as_constante, readonly string as_error)
public subroutine wf_validaroc_x_op (readonly long al_oc)
end prototypes

event ue_grabar();//Lo que se coloca en comentario de 8 / es que se modifico el 26 de sep 2007  
//primero se verifica que todas las partes hallan sido seleccionadas
Long li_fila, li_marca, li_fab,li_subcentro,li_planta,li_result,li_tipo,li_centro,&
        li_subcentro2,li_result2, ll_datos, ll_cont, ll_n
String ls_parte, ls_bolsa, ls_po,ls_subcentro, ls_modulo, ls_de_modulo, ls_bongo, ls_sw_origen, ls_sw_origen1, ls_pos, ls_bolsa_nueva, ls_po_agrupada, ls_error
Long ll_ordencorte, ll_bongo, ll_modulo, ll_count, ll_duo_conjunto, ll_pedido
Decimal{2} ldc_cantidad
s_base_parametros lstr_parametros 
uo_dsbase lds_po_x_lotear

n_cst_bolsa						lpo_bolsa
n_cst_modulo					lpo_modulo
n_cst_loteo_bongo 			lpo_loteo
n_cts_orden_segundo_loteo	luo_segundo_loteo
n_cst_cambio_po_loteo 		lnvo_cambio_po_loteo

If dw_maestro.AcceptText() <> 1 Then Return

If ib_bongo = False Then
	MessageBox('Advertencia','El n$$HEX1$$fa00$$ENDHEX$$mero del recipiente no puede ser digitado, debe seleccionarse.',StopSign!)
	Return 
End if

lds_po_x_lotear = Create uo_dsbase
lds_po_x_lotear.DataObject = 'd_gr_po_x_lotear'
lds_po_x_lotear.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
			
//se modifica para no generar problemas con las ordenes de corte enviadas a la 
//calle, se hace esto a peticion de Edwin serna
//jcrm
//mayo 2 de 2008
 //se modifica para que todas la ordenes las tome como cortadas en vestimundo
 //ya que falta definir por parte del usuario los posibles casos que se presentan
 //al enviar a cortar a fuera, ya que en ocasiones se debe lotear normal y en 
 //otras no.
 //jcrm
 //mayo 14 de 2008
ii_centro_corte = 90

If ii_centro_corte <> 92 And Handle(GetApplication() ) > 0 Then //se corta en la calle no se verifica las partes
	If dw_detalle.RowCount() > 0 Then
		FOR li_fila = 1 TO dw_detalle.RowCount()
			li_marca = dw_detalle.GetItemNumber(li_fila,'marca')
			IF li_marca = 0 THEN
				ls_parte = dw_detalle.GetItemString(li_fila,'de_parte')
				MessageBox('Advertencia','La parte '+Trim(ls_parte)+' aun no ha sido marcada.',StopSign!)
				Return
			END IF
		NEXT
	Else
		MessageBox('Error','Debe especificar las partes y leerlas.',StopSign!)
		Return
	End if
End if
//todas las partes fueron seleccionadas se deben realizar las actualizaciones en las tablas
//correspondientes.

//************************capturo los datos que seran necesarios para las actualizaciones
ll_ordencorte 	= dw_maestro.GetItemNumber(1,'orden_corte')
ls_po 			= dw_maestro.GetItemString(1,'po')

ll_bongo 		= dw_maestro.GetItemNumber(1,'bongo')
li_fab 			= Long(Mid(String(ll_bongo),1,1))
li_planta 		= Long(Mid(String(ll_bongo),2,1))

ldc_cantidad 	= dw_maestro.GetItemNumber(1,'unidad_bolsa')
ls_bolsa 		= dw_maestro.GetItemString(1,'bolsa')
li_subcentro2 	= dw_maestro.GetItemNumber(1,'subcentro')

ls_subcentro   = dw_maestro.GetItemString(1,'de_subcentro')
li_subcentro   = Long(Mid(String(li_subcentro2),4))
li_tipo 			= Long(Mid(String(li_subcentro2),1,1)) 
li_centro      = Long(Mid(String(li_subcentro2),2,2))

ls_modulo      = dw_maestro.GetItemString(1,'modulo')
ll_modulo		= Long(Mid(ls_modulo,5))
ls_de_modulo   = dw_maestro.GetItemString(1,'de_modulo')


//se valida que todas las bolsas del bongo tenga sean para produccion o sobrantes
ls_bongo = String(ll_bongo)
select count(*), Nvl(max(sw_origen),'') into :ll_cont, :ls_sw_origen
from h_canasta_corte
where pallet_id = :ls_bongo;	

//si ya hay registros
If ll_cont >= 1 Then
	ls_sw_origen1 = trim(dw_maestro.GetItemString(1,'sw_origen'))
	If Isnull(ls_sw_origen1) Then ls_sw_origen1 = ''
	//si el origen de la bolsa es distinto al del recipiente
	If trim(ls_sw_origen) <> trim(ls_sw_origen1) and (trim(ls_sw_origen) = 'S' or trim(ls_sw_origen1) = 'S') Then
		//mira si la bolsa es sobrante
		If ls_sw_origen1 = 'S' Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La bolsa leida es un sobrante pero el recipiente es de produccion normal. No se puede introducir esta bolsa en el recipiente.')
			Return
		Else
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La bolsa leida es de produccion normal pero el recipiente es de sobrante. No se puede introducir esta bolsa en el recipiente.')
			Return
		End if
	End if
End if

//se validad que el auditor de calidad ya halla dado el visto bueno de lo contrario no se permite continuar
//con el proceso de lectura de las bolsas, esto se hace porque las lideres leen toda la produccion y
//la empacan sin que el auditor la revise luego el auditor no desempaca la produccion y la validad
//sin realizarle la revision necesaria
//jcrm
//junio 20 de 2008
//modificacion  agosto 17-2011   JAvier Garcia pide que solo lo pida al momento de lotear
//SELECT count(*) 
//  INTO :ll_count
//  FROM m_auditor_po
// WHERE cs_orden_corte = :ll_ordencorte AND
//		 po = :ls_po;
//			
//IF ll_count > 0 THEN
//	//se deja pasar ya que el auditor ya dio el visto bueno.
//ELSE
//	lstr_parametros.entero[1] = ll_ordencorte
//	lstr_parametros.cadena[1] = ls_po
//	OpenWithparm(w_validar_auditor,lstr_parametros)
//	lstr_parametros = Message.PowerObjectParm
//	//se restringe que no puedan leer sin el codigo ingresado del auditor
//	//jcrm
//	//junio 20 de 2008
//	IF lstr_parametros.hay_parametros = False THEN
//		Rollback;
//		MessageBox('Advertencia','Es necesario que el auditor de calidad halla dado el visto bueno, para iniciar la lectura de las bolsas.',StopSign!)
//		Return 
//	END IF
//END IF
//
//valido el bongo
If lpo_bolsa.of_validar_bongo(ll_ordencorte,ll_bongo,li_fab,li_planta,ls_po, ii_fabrica, ii_linea, il_referencia ) = -1 Then
////////	Rollback;
	Return 
END IF

//valido que el subcentro de loteo sea el mismo al cual se le cargo, solo para primeros loteos
//IF lpo_modulo.of_validarmodulocontrakamban(ll_ordencorte,ls_modulo) = -1 THEN
//	Rollback;
//	Return
//END IF
//
//verificamos que si se halla leido el modulo
IF lpo_modulo.of_descripcion_modulo(ls_modulo,li_tipo,li_centro,li_subcentro,ls_de_modulo, ii_ctro_fisico) = -1 THEN
////////	Rollback;
	Return
END IF

////IF lpo_bolsa.of_actualizar_bolsa(ll_ordencorte,ls_po,ll_bongo,li_fab,li_planta,ldc_cantidad,ls_bolsa,li_subcentro,li_tipo,li_centro,ll_modulo) = -1 THEN
////	Rollback;
////	Return
////END IF

//en este punto sabemos que todas las partes de la bolsa ya fueron leidas ahorra necesitamos saber si es la ultima bolsa
ll_duo_conjunto = 0
li_result2 = lpo_bolsa.of_ultima_bolsa(ll_ordencorte,ls_po, ii_fabrica, ii_linea, il_referencia, ls_bolsa, ll_duo_conjunto, il_marca)
IF li_result2 = -2 THEN
	//Rollback;
	MessageBox('Advertencia','Se present$$HEX2$$f3002000$$ENDHEX$$un error verificando la cantidad de bolsas leidas, intente nuevamente.',StopSign!)
	Return 
END IF

// FACL - 2021/08/05 - ID530 - Se deshabilita cambio de PO
IF li_result2 = -1 THEN
	IF lpo_bolsa.of_actualizar_bolsa(ll_ordencorte,ls_po,ll_bongo,li_fab,li_planta,ldc_cantidad,ls_bolsa,li_subcentro,li_tipo,li_centro,ll_modulo,ii_marca_especial) = -1 THEN
		Rollback;
		Return
	End If
	
	If Handle( GetApplication() ) = 0 Then
		MessageBox( 'Atencion', 'Revisar, se devolvera la transaccion!' )
		ROLLBACK;
		return
	End If
	
	commit;
	li_result = MessageBox("OK", 'Se genero la bolsa exitosamente, Desea Continuar con el mismo recipiente. ', Information!, OKCancel!, 1)
	
	IF li_result = 1 THEN
		dw_maestro.Reset()
		dw_detalle.Reset()
		dw_maestro.InsertRow(0)
		dw_maestro.SetFocus()
		
		dw_maestro.SetItem(1,'orden_corte',ll_ordencorte)
		dw_maestro.SetItem(1,'po',ls_po)
		dw_maestro.SetItem(1,'bongo',ll_bongo)
		dw_maestro.SetItem(1,'subcentro',li_subcentro2)
		dw_maestro.SetItem(1,'de_subcentro',ls_subcentro)
		dw_maestro.SetItem(1,'modulo',ls_modulo)
		dw_maestro.SetItem(1,'de_modulo',ls_de_modulo)
		dw_maestro.SetItem(1,'po_agrupada',ls_po_agrupada)
		dw_maestro.SetItem(1,'pedido',ll_pedido)
		
		dw_maestro.SetColumn(4)
		dw_maestro.Modify("t_sobrante.Text=''")
	ELSE
		dw_maestro.Reset()
		dw_detalle.Reset()
		dw_maestro.InsertRow(0)
		dw_maestro.SetFocus()
		dw_maestro.Modify("t_sobrante.Text=''")
		dw_maestro.Modify("t_agrupada.Text=''")
	END IF
ELSE

	//se trata de la ultima bolsa por lo tanto debemos lotear y generar adhesivos
	//invocar procedimiento para lotear
	
	//pero antes de lotear debemos pedir que se lean las partes (los complementos)
	lstr_parametros.entero[1] = ll_ordencorte
	lstr_parametros.entero[2] = ii_fabrica
	lstr_parametros.entero[3] = ii_linea
	lstr_parametros.entero[4] = il_referencia
	
//	//inserto en mv_lote_auditor
//   IF lpo_loteo.of_cargar_auditor(ll_ordencorte,ls_po ) = -1 THEN
//		FOR li_fila = 1 TO dw_detalle.RowCount()
//			IF al_parte = dw_detalle.GetItemNumber(li_fila,'co_parte') THEN
//				//marcamos la fila
//				dw_detalle.SetItem(li_fila,'marca',0)
//				sle_parte.text = ''
//				sle_parte.SetFocus()
//			END IF
//		NEXT
//		Return
//	END IF
		
	OpenWithParm (w_complementos, lstr_parametros )
	
	lstr_parametros = Message.PowerObjectParm	
	
	IF lstr_parametros.hay_parametros THEN
		//en este punto se han leido todas las bolsas, y los complementos
		//y a peticion de Javier Garcia y Hector Osorno, en reunion del 9 de marzo de 2007
		//del sue$$HEX1$$f100$$ENDHEX$$o de recipiente perfecto se solicitud que solo en este momento se pide 
		//el codigo del auditor de calidad
		//jcrm
		//marzo 13 de 2007
				
		//se verifica si el auditor ya coloco el visto bueno esto es para 
		//no mostrar la ventana cada vez que intenten lotear, y este a fallado
		//ya sea por un bloqueo, o por otras razones.
		//jcrm
		//agosto 30 de 2007
	
 	
	 //se pone en comentario ya que en la parte superior se esta realizando esta validacion antes de ingresar la bolsa
	 
		SELECT count(cs_orden_corte) 
		  INTO :ll_count
		  FROM m_auditor_po
		 WHERE cs_orden_corte = :ll_ordencorte AND
		  	    po = :ls_po;
					
		IF ll_count > 0 THEN
			//se deja pasar ya que el auditor ya dio el visto bueno.
		ELSE
			lstr_parametros.entero[1] = ll_ordencorte
			lstr_parametros.cadena[1] = ls_po
			
			OpenWithparm(w_validar_auditor,lstr_parametros)
			lstr_parametros = Message.PowerObjectParm
			//se restringe que no puedan leer sin el codigo ingresado del auditor
			//jcrm
			//junio 20 de 2008
			IF lstr_parametros.hay_parametros = False  And Handle(GetApplication() ) > 0 THEN
				Rollback;
				MessageBox('Advertencia','Es necesario que el auditor de calidad halla dado el visto bueno, lotear.',StopSign!)
				Return 
			END IF
		END IF
	
		IF lpo_bolsa.of_actualizar_bolsa(ll_ordencorte,ls_po,ll_bongo,li_fab,li_planta,ldc_cantidad,ls_bolsa,li_subcentro,li_tipo,li_centro,ll_modulo, ii_marca_especial) = -1 THEN
			Rollback;
			Return
		END IF
		
		If ii_centro_corte <> 92  And Handle(GetApplication() ) > 0 Then //se corta en la calle no se verifica las partes
			//inserto en mv_lote_auditor 
			IF lpo_loteo.of_cargar_auditor(ll_ordencorte,ls_po ) = -1 THEN 
				FOR li_fila = 1 TO dw_detalle.RowCount()
					IF al_parte = dw_detalle.GetItemNumber(li_fila,'co_parte') THEN
						//marcamos la fila
						dw_detalle.SetItem(li_fila,'marca',0)
//						sle_parte.text = ''
//						sle_parte.SetFocus()
						dw_1.SetItem(1,'parte','')
						dw_1.SetFocus()
					END IF
				NEXT
				Return
			END IF
		End if
		
		//se procede a lotear la orden de corte
		IF of_lotear(ll_ordencorte,ls_po,ll_duo_conjunto) < 0 THEN
			Rollback;
			If ii_centro_corte <> 92 Then //se corta en la calle no se verifica las partes
				FOR li_fila = 1 TO dw_detalle.RowCount()
					IF al_parte = dw_detalle.GetItemNumber(li_fila,'co_parte') THEN
						//marcamos la fila
						dw_detalle.SetItem(li_fila,'marca',0)
//						sle_parte.text = ''
//						sle_parte.SetFocus()
						dw_1.SetItem(1,'parte','')
						dw_1.SetFocus()
					END IF
				NEXT
			End if
			Return
		Else
			//se actualiza el estado del loteo en h_ordenes_corte
			//para un trabajo que esta realizando Oswaldo para Javier Garcia
			//jcrm
			//abril 17 de 2007
			luo_segundo_loteo.of_marcaLoteo(ll_ordencorte)

			//antes de realizar commit se debe colocar la OC en dt_simulacion con estado in activo (I)
			lpo_loteo.of_act_pdp_corte(ll_ordencorte) 

			
			//se verifica si las unidades liberadas son iguales a las loteadas de ser menores se debe
			//mermar estas unidades en las unidades liberadas en dt_caxpedidos, esto para que la persona
			//que libere sepa que debe liberar mas unidades
			//pedido en el sue$$HEX1$$f100$$ENDHEX$$o de tela mayo 23 de 2008 por Jesus Maria Henao
			//jcrm
			//mayo 27 de 2008   retorna -1 si hay error
			IF lpo_loteo.of_actualizar_unidades_liberadas_op(ll_ordencorte) = -1 THEN
				Rollback;
	  		   Return
			END IF
						
			Commit;
			
			dw_maestro.Reset()
			dw_detalle.Reset()
			dw_maestro.InsertRow(0)
			dw_maestro.SetFocus()
			dw_maestro.Modify("t_sobrante.Text=''")
			
			//esta instruccion la coloca Leon Betancur para hacer cambio de PO, oct 27-09
			//lnvo_cambio_po_loteo.of_cambiar_po_loteo(String(ll_bongo),ls_po)   *****************************se debe revisar cambio de PO!!!!!
			
			//llama funcion para cerrar las op(s) que esten por encima del 90%  de la orden de corte loteada
			of_ops_a_cerrar(ll_ordencorte)
			
			//se realiza la modificacion en el Pdp de confeccion con la orden corte
			IF lpo_loteo.of_actualiza_pdp_confeccion_x_oc(ll_ordencorte) < 0 THEN
				Rollback;
	  		   Return
			END IF
			
			// FACL - 2021/09/23 - ID530 - Se limita a que solo reintene la primera vez que grabe
			//stvalenc - 2022-01-26 Se quita la limitacion
//			If ib_reintentar_bongos_sin_pdp Then
//				ib_reintentar_bongos_sin_pdp = False
				// consulta y crea barras en el pdp confeccion de los bongos loteados que tuvieron inconvenientes anteriormente
			IF lpo_loteo.of_crea_bongos_loeados_pdp_confeccion() < 0 THEN
			END IF
//			End If
			
			// FACL - 2019/02/25 - SA59605 - Se Ubica automaticamente los bongos loteados
			IF lpo_loteo.of_Ubicar_Auto_Bongo_Loteado(ll_ordencorte) < 0 THEN
			END IF
			
			//valida si falta por lotear P.O
			If lds_po_x_lotear.Retrieve(ll_ordencorte,ls_po) > 0 Then
				ls_pos = ''
				For ll_n = 1 to lds_po_x_lotear.RowCount()
					ls_pos = trim(ls_pos) + ' ' + Trim(lds_po_x_lotear.GetItemString(ll_n,'po'))
				Next
				
				MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Recuerde que aun le falta por lotear las siguientes P.O.: '+trim(ls_pos))
			End if
		END IF
	ELSE
		//no ingresaron los complementos se realiza rollback y se retorna la pantalla al estado que tenia antes
		//de ingresar la ultima parte.
////////		Rollback;
		If ii_centro_corte <> 92 Then //se corta en la calle no se verifica las partes
			FOR li_fila = 1 TO dw_detalle.RowCount()
				IF al_parte = dw_detalle.GetItemNumber(li_fila,'co_parte') THEN
					//marcamos la fila
					dw_detalle.SetItem(li_fila,'marca',0)
//					sle_parte.text = ''
//					sle_parte.SetFocus()
					dw_1.SetItem(1,'parte','')
					dw_1.SetFocus()
				END IF
			NEXT
		End if
	END IF 
END IF
//se restablece al centro de corte cortado marinilla, ya que la 
//proxima orden de corte puede no ser cortada en la calle y debe 
//procederse a trabajarla con normalidad.
//jcrm
//mayo 8 de 2008
ii_centro_corte = 90


end event

public function long of_insertar_loteo (long al_ordencorte, long ai_fabrica, long ai_linea, long al_referencia, long al_codigo);Long li_max_loteo
string ls_usuario,ls_instancia
datetime dt_fe_actualiza
  
dt_fe_actualiza = f_fecha_servidor()

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
		
SELECT max(cs_loteo)
INTO: li_max_loteo
FROM  mv_loteo_auditor
WHERE mv_loteo_auditor.cs_orden_corte 	= :al_ordencorte  AND  
		mv_loteo_auditor.co_fabrica 		= :ai_fabrica  AND  
		mv_loteo_auditor.co_linea 			= :ai_linea  AND  
		mv_loteo_auditor.co_referencia 	= :al_referencia ;

IF isnull(li_max_loteo) THEN li_max_loteo = 0


INSERT INTO mv_loteo_auditor  
( cs_orden_corte,   
  co_fabrica,   
  co_linea,   
  co_referencia,   
  auditor,   
  fe_creacion,   
  fe_actualizacion,   
  lider,   
  instancia,   
  cs_loteo )  
VALUES ( :al_ordencorte,   
  :ai_fabrica,   
  :ai_linea,   
  :il_referencia,   
  :al_codigo,   
  :dt_fe_actualiza,   
  :dt_fe_actualiza,   
  :ls_usuario,   
  :ls_instancia,   
  :li_max_loteo + 1)  ;
  
  IF sqlca.sqlcode = -1 Then
		ROLLBACK;
		MessageBox('Error','insertando mv_loteo_auditor',StopSign!)
		Return -1
	END IF
  
  
			
	
return 0
end function

public function long of_validarconceptounidadesmenos (long al_ordencorte, string as_bolsa, decimal adc_cant_new, decimal adc_cant_old);String ls_usuario, ls_usu_autoriza, ls_instancia, ls_password, ls_error
Datetime ldt_fecha
Long ll_count
Long li_concepto
s_base_parametros lstr_parametros

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
ldt_fecha = f_fecha_servidor()

//primero se debe llamar la ventana para ingresar el usuario que autoriza
open(w_autorizacion_capas)
lstr_parametros = message.PowerObjectParm	

IF lstr_parametros.hay_parametros THEN
   ls_usu_autoriza = lstr_parametros.cadena[1]	
	ls_password = lstr_parametros.cadena[2]
	li_concepto = lstr_parametros.entero[1]
	
	//si el usuario y password son validos se validad en dt_usuxper que el perfil del usuario
	//sea 12 $$HEX2$$f3002000$$ENDHEX$$13 en tal caso se deja realizar el cambio, de lo contrario el usuario no esta autorizado 
	SELECT count(co_usuario)
	  INTO :ll_count
	  FROM dt_usuxper
	 WHERE co_aplicacion = 40 AND
	       co_perfil in (12,13) AND
	       co_usuario = :ls_usu_autoriza;
	
	IF ll_count > 0 THEN
		//se graba en el log
		INSERT INTO log_unid_lot  
         ( cs_orden_corte,   
           cs_canasta,   
           unid_prog,   
           unid_lot,   
           autorizacion,   
           fe_creacion,   
           usuario,   
           instancia,   
           concepto )  
  		 VALUES 
			 (:al_ordencorte,   
           :as_bolsa,   
           :adc_cant_old,   
           :adc_cant_new,   
           :ls_usu_autoriza,   
           :ldt_fecha,   
           :gstr_info_usuario.codigo_usuario,   
           :gstr_info_usuario.instancia,   
           :li_concepto) ;
			  
		IF sqlca.sqlcode = -1 THEN
			ls_error = sqlca.SqlErrText
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar el log, ERROR: '+ls_error)
		End if
		//se coloca este commit para evitar bloqueos,  jorodrig  nov 20 07
		COMMIT;

   ELSE
		MessageBox('Error','El usuario no esta autorizado para permitir este cambio de capas, los unicos autorizados son el Jefe de corte o los jefes de sal$$HEX1$$f300$$ENDHEX$$n.')
		Return -1
	END IF
ELSE //no se selecciono ningun usuario autorizado
	Return -1
END IF

Return 0
end function

protected function long of_lotear (long al_orden_corte, string as_po, long al_duo_conjunto);/***********************************************************
SA53802 - Ceiba/JJ - 29-10-2015
Comentario: se adiciona el Report dw_ProcesosConfeccion a los dw: dtb_adhesivos_bongo_new_duo y dtb_adhesivos_bongo_new_colores
adicionando los arg de recuperacion an_tipoPdto, an_centro_pdn,an_infoProc, de lectura a constantes:TIPO PRENDAS CONFECCION y MENS_LOTEO_CONF
Nota: el dw dtb_adhesivos_bongo_new no se utiliza en el target 
***********************************************************/
Long 		li_result, li_fab, li_planta, li_tipocentro, li_fabrica, li_tiempo, &
		  		li_loteo_max, li_linea,li_oc_con_sobrante, ll_porc_sobrantes
String 		ls_bongo, ls_canasta, ls_loteo, ls_loteo_max, ls_origen,ls_bongos[], ls_error, ls_body, ls_mensaje = '', ls_po_parm
Long 			ll_fila, ll_fila2, ll_result, ll_found, ll_referencia, ll_n, ll_reg, &
				ll_cantidad_sobrantes, ll_sw_bongo_sobrante,ll_tipoPdto,ll_centro_pdn, li_loteoConf, ll_rows, ll_rown, ll_ca_valida
DateTime 	ldt_fecha
Time 			lt_tiempo
DataStore 	lds_bongo, lds_unidades_talla , lds_canasta_ca

n_cst_loteo_bongo 		lpo_loteo
s_base_parametros 		lstr_parametros
n_cts_constantes 			lpo_constantes
n_cst_orden_corte 		luo_corte
lpo_constantes 			= Create n_cts_constantes
n_cts_constantes_corte 	lnvo_constante_corte

lstr_parametros.cadena[1]="Procesando..."
lstr_parametros.cadena[2]="El sistema esta generando el loteo, esta operacion puede demorar unos segundos, espere un momento por favor..."
lstr_parametros.cadena[3]="reloj"	
		
OpenWithParm(w_retroalimentacion,lstr_parametros)


//************se deshabilito la opcion anterior y se genera como un estandar el tipo de centro pdn
li_tipocentro = lpo_constantes.of_consultar_numerico('TIPO_CENTRO')

IF li_tipocentro = -1 THEN
	Rollback;
	Close(w_retroalimentacion)
	Return -1
END IF

// FACL - 2021/08/05 - ID530 - Si es agrupada no se tiene en cuenta la PO
If dw_maestro.GetItemString(1,'po_agrupada' ) <> '' Then
	ls_po_parm = '0'
Else
	ls_po_parm = as_po
End If

//*********************creo datastore para recorrer los bongos y sus respectivas bolsas
lds_bongo = Create DataStore
lds_bongo.DataObject = 'ds_pallet_id' //**********recorro los bongos de una O.C. - P.O.
lds_bongo.SetTransObject(sqlca)

//***************genero ciclo para recorrer todos los bongos de la orden de corte para la po actual
ll_result = lds_bongo.Retrieve(al_orden_corte,ls_po_parm)
li_oc_con_sobrante = 0
FOR ll_fila2 = 1 To lds_bongo.RowCount()
	ls_bongo = lds_bongo.GetItemString(ll_fila2,'pallet_id')

	SELECT max(atributo3), sw_origen
	  INTO :ls_loteo, :ls_origen
	  FROM h_canasta_corte
	 WHERE pallet_id = :ls_bongo
	GROUP BY 2  ;
	 
	IF ls_origen = 'S' THEN  //si tiene S es porque el bongo esta marcado como produccion sobrante, en este caso si la orden dice que lleva sobrante se puede lotear
		li_oc_con_sobrante = 1
	END IF
	
	IF ls_loteo > ls_loteo_max THEN
		ls_loteo_max = ls_loteo
	END IF
	 
	IF ls_loteo_max = '' OR isnull(ls_loteo) THEN
		ls_loteo_max = '1'
	ELSE
		li_loteo_max = Long(ls_loteo_max)
		li_loteo_max += 1
		ls_loteo_max = String(li_loteo_max)
	END IF
NEXT





//la orden de corte tiene la marca de que lleva sobrantes, si no hay un bongo marcado como sobrante en h_canasta_corte.sw_origen=3 no puede continuar
//abril 23 -2010 jorodrig

//se activa ya que este mensaje ya debe ser restrictivo
//peticion Luis Javier Garcia,Jose Jhony Martinez y Esteban Restrepo 2010-07-13
IF il_marca = 3 AND li_oc_con_sobrante = 0  AND ii_marca_especial <> 3 THEN
   Rollback; //	Rollback;
	MessageBox('Advertencia','La orden de corte tiene unidades sobrantes y no tiene un recipiente marcado como sobrante, debe separar las unidades sobrantes a otro recipiente')
	Close(w_retroalimentacion)
	Return -1 //Return -1
END IF

//Recorremos todas las canasta de la oc para validar que la ca_actual sea mayor que cero o si no mostramos el error y detenemos el proceso
//stvalenc 2022/04/05
lds_canasta_ca = Create DataStore
lds_canasta_ca.DataObject = 'd_gr_valida_ca_bolsa_x_oc' //**********recorro los bongos de una O.C
lds_canasta_ca.SetTransObject(sqlca)
ll_rows = lds_canasta_ca.Retrieve(al_orden_corte,ls_po_parm)

IF ll_rows < 0 then
	Rollback;
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se pudieron consultar los datos de la canasta para la OC")
	return -1
end if

For ll_rown = 1 to lds_canasta_ca.RowCount()
	ll_ca_valida = lds_canasta_ca.GetItemNumber(ll_rown,"ca_actual")
	// si tiene ca_actual es igual a cero, frenamos el proceso y mostramos el error
	IF ll_ca_valida = 0 or isnull(ll_ca_valida) then
		Rollback;
		MessageBox("Error","Existe una bolsa con cantidad actual cero no se puede continuar el proceso. Bongo: "+lds_canasta_ca.GetItemString(ll_rown,"pallet_id")+ " Bolsa: "+ lds_canasta_ca.GetItemString(ll_rown,"cs_canasta") )
		return -1
	end if
next


// FACL - 2021/08/05 - ID530 - Se invoca sp que separa el bongo por referencia y les agrega una letra por cada bongo
DECLARE marca_bongo_agrupado PROCEDURE FOR pr_marca_bongo_agrupado(:al_orden_corte );


EXECUTE marca_bongo_agrupado;
	
IF SQLCA.SQLCode = -1 THEN
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_marca_bongo_agrupado: " + ls_error)	
	CLOSE marca_bongo_agrupado;
	Close(w_retroalimentacion)
	Return -1
END IF
CLOSE marca_bongo_agrupado;


// Se vuelve a cargar los bongos por OC
ll_result = lds_bongo.Retrieve(al_orden_corte,ls_po_parm)
If ll_result < 0 Then
	ROLLBACK;
	MessageBox( 'Atencion', 'Ocurrio al consultar los bongos de la OC!' )
	Close(w_retroalimentacion)
	Return -1
End If


//mira si lotean sobrantes para validar las unidades por talla
If il_marca = 3 and li_oc_con_sobrante > 0 and ii_marca_especial <> 3 Then
	If ids_unid_sobrantes_loteo.RowCount() <= 0 Then
		Rollback; //	Rollback;
		MessageBox('Advertencia','La orden de corte tiene unidades sobrantes y no se encontro las unidades marcadas como sobrantes.')
		Close(w_retroalimentacion)
		Return -1 
	End if
	
	If ll_result > 0 Then
		lds_unidades_talla = Create DataStore
		lds_unidades_talla.DataObject = 'd_gr_sku_cantidad_x_bongo' //**********recorro los bongos de una O.C. - P.O.
		lds_unidades_talla.SetTransObject(sqlca)

		ll_porc_sobrantes = lnvo_constante_corte.of_consultar_numerico('POR_UNID_SOBRA_LOTEO')                     

		IF ll_porc_sobrantes = -1 THEN
			ll_porc_sobrantes = 0
		END IF
		
		For ll_fila = 1 To lds_bongo.RowCount()
			ll_sw_bongo_sobrante = 0
			ls_bongo = lds_bongo.GetItemString(ll_fila,'pallet_id')
			If lds_unidades_talla.Retrieve(ls_bongo) > 0 Then
				For ll_n = 1 to lds_unidades_talla.RowCount()
					//si el bongo esta marcado como sobrantes
					If lds_unidades_talla.GetItemString(ll_n,'sw_origen') = 'S' Then
						ll_sw_bongo_sobrante = 1
						//verifica que la cantidad sea igual para la talla
						ll_reg = ids_unid_sobrantes_loteo.Find('fabrica = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_fabrica_ref')) + &
																			' and linea = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_linea')) + &
																			' and estilo = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_referencia')) + &
																			' and talla = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_talla')) + &
																			' and color = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_color')) &
																			,1,ids_unid_sobrantes_loteo.RowCount()+1)
						
						// FACL - 2021/09/07 - ID530 - Si esta loteando agrupado no importa la referencia
						If ll_reg = 0 And dw_maestro.GetItemString(1,'po_agrupada' ) <> '' Then
							//verifica que la cantidad sea igual para la talla
							ll_reg = ids_unid_sobrantes_loteo.Find('talla = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_talla')) + &
																			' and color = ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_color')) &
																			,1,ids_unid_sobrantes_loteo.RowCount()+1)
						End If
						
						
						//si lo encuentra mira las unidades loteadas contra las solicitadas para sobrantes
						If ll_reg > 0 Then
							
							If ids_unid_sobrantes_loteo.GetItemNumber(ll_reg,'unid_sobrantes') > &
								ids_unid_sobrantes_loteo.GetItemNumber(ll_reg,'unid_loteando') Then
								ll_cantidad_sobrantes = ids_unid_sobrantes_loteo.GetItemNumber(ll_reg,'unid_loteando')
							Else
								ll_cantidad_sobrantes = ids_unid_sobrantes_loteo.GetItemNumber(ll_reg,'unid_sobrantes')
							End if
							
							//compara las unidades
							If Not (lds_unidades_talla.GetItemNumber(ll_n,'ca_actual') >= ll_cantidad_sobrantes  and &
								ll_cantidad_sobrantes + Round((ll_porc_sobrantes/100) * ll_cantidad_sobrantes,0) >= &
								lds_unidades_talla.GetItemNumber(ll_n,'ca_actual')) Then
								
								Rollback; 
								MessageBox('Advertencia','El bongo marcado como sobrantes no tiene las unidades exactas que est$$HEX1$$e100$$ENDHEX$$n sobrando. Bongo ' + Trim(ls_bongo) + &
												' Referencia ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_referencia')) + &
												' Talla ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_talla')) + &
												' Color ' + String(lds_unidades_talla.GetItemNumber(ll_n,'co_color')) + &
												' cantidad bongo ' + String(lds_unidades_talla.GetItemNumber(ll_n,'ca_actual')) + &
												' cantidad sobrantes ' + String(ids_unid_sobrantes_loteo.GetItemNumber(ll_reg,'unid_sobrantes')))
								Close(w_retroalimentacion)
								Destroy lds_unidades_talla
								Return -1 
							End if
							
						Else
							Rollback; 
							MessageBox('Advertencia','No se encontraron unidades sobrantes para validar las unidades loteadas.')
							Close(w_retroalimentacion)
							Destroy lds_unidades_talla
							Return -1 
						End if
					End if
				Next
			Else
				Rollback; 
				MessageBox('Advertencia','No se encontro informacion del bongo a lotear. Bongo ' + Trim(ls_bongo))
				Close(w_retroalimentacion)
				Destroy lds_unidades_talla
				Return -1 
			End if
			
			//si es bongo sobrante
			If ll_sw_bongo_sobrante = 1 Then
				//actualiza fecha de llegada insumo
				DECLARE fe_llegada PROCEDURE &
					FOR pr_fecha_llegada_insumo_x_bongo(:ls_bongo);
				EXECUTE fe_llegada; 
		
				IF SQLCA.SQLCode = -1 THEN
					ls_error = sqlca.sqlerrtext
					Rollback;
					If Isnull(ls_error) Then ls_error = ''
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_fecha_llegada_insumo_x_bongo. " + ls_error,StopSign!)
					Close(w_retroalimentacion)
					Destroy lds_unidades_talla
					CLOSE fe_llegada;
					Return -2
				END IF
				
				CLOSE fe_llegada;
			End if
			
		Next
		
		Destroy lds_unidades_talla
		
		/*****************/
		//toma los bongos a lotear
		ls_bongos = lds_bongo.Object.pallet_id.Primary
		If of_verifica_nuevo_grupo_sobrantes(ls_bongos) <= 0 Then
			Rollback; 
			MessageBox('Advertencia','Ocurrio un inconveniente al verificar el cliente para cambio de grupo en sobrantes.')
			Close(w_retroalimentacion)
			Destroy lds_unidades_talla
			Return -1 
		End if
		/*****************/
		
		
	End if
End if

//*******************veces a sido loteada esta orden corte - po

uo_correo	lnv_correo

uo_dsbase lds_info_oc
lds_info_oc = Create uo_dsbase
lds_info_oc.DataObject = 'd_gr_datos_x_oc'
lds_info_oc.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

Datastore lds_informacion_x_bongo
				
lds_informacion_x_bongo = Create DataStore
lds_informacion_x_bongo.DataObject = 'd_gr_sku_cantidad_x_bongo' //**********recorro los bongos de una O.C. - P.O.
lds_informacion_x_bongo.SetTransObject(sqlca)

select distinct dt_canasta_corte.co_fabrica_ref,
		dt_canasta_corte.co_linea,
		dt_canasta_corte.co_referencia
into :li_fabrica,
	  :li_linea,
	  :ll_referencia
from dt_canasta_corte, h_canasta_corte
where h_canasta_corte.pallet_id = :ls_bongo and
		h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta;

If ll_result > 0 Then
	For ll_fila = 1 To lds_bongo.RowCount()
		ls_bongo = lds_bongo.GetItemString(ll_fila,'pallet_id')
		li_fabrica = Long(Mid(ls_bongo,1,1))
		
		//*********************************se lotean las canastas
		If lpo_loteo.of_loteo_bongo(ls_bongo,li_tipocentro,al_orden_corte,ls_loteo_max) = -1 Then
			Rollback;
			Close(w_retroalimentacion)
			Return -1
		End if
		
		//SA 61237 Confecci$$HEX1$$f300$$ENDHEX$$n Terceros
		//Si est$$HEX2$$e1002000$$ENDHEX$$marcado como Confecci$$HEX1$$f300$$ENDHEX$$n Terceros (h_ordenes_corte.co_tipo = 11) debe enviar correo
		If lds_info_oc.Retrieve(al_orden_corte,as_po,li_fabrica, li_linea, ll_referencia) > 0 Then
			If lds_info_oc.GetItemNumber(1,'co_tipo') = 11 Then		
				If lds_informacion_x_bongo.Retrieve(ls_bongo) > 0 Then
					For ll_n = 1 to lds_informacion_x_bongo.RowCount()
						ls_mensaje = ls_mensaje + &
						 '~r~n Bongo: ' + String(ls_bongo) + &
						 '~r~n Referencia: ' + String(lds_informacion_x_bongo.GetItemNumber(1,'co_referencia')) + ' - ' + Trim(lds_informacion_x_bongo.GetItemString(1,'de_referencia')) + &
						 '~r~n Talla: ' + String(lds_informacion_x_bongo.GetItemNumber(ll_n,'co_talla')) + &
						 '~r~n Color: ' + String(lds_informacion_x_bongo.GetItemNumber(ll_n,'co_color')) + &
						 '~r~n Cantidad: ' + String(lds_informacion_x_bongo.GetItemNumber(ll_n,'ca_actual')) + &
						 '~r~n' + Trim(lds_informacion_x_bongo.GetItemString(ll_n,'texto_marquilla')) + &
						  '~r~n'
					Next
				End If				
			End If
		End If
	Next
	
//Se valida que despues del proceso de loteo no queden canastas en estado 10 y con cantidad > 0
//stvalenc 2022/04/05
ll_rows = lds_canasta_ca.Retrieve(al_orden_corte,ls_po_parm)

IF ll_rows > 0 then
	For ll_rown = 1 to lds_canasta_ca.RowCount()
		ll_ca_valida = lds_canasta_ca.GetItemNumber(ll_rown,"ca_actual")
		IF ll_ca_valida > 0 then
			Rollback;
			MEssageBox("Error","Quedo una bolsa con cantidad mayor a cero sin lotear. Bongo: "+lds_canasta_ca.GetItemString(ll_rown,"pallet_id")+ " Bolsa: "+ lds_canasta_ca.GetItemString(ll_rown,"cs_canasta") )
			return -1
		end if
	next
end if
	
	
If ls_mensaje <> '' Then
		lnv_correo = CREATE uo_correo
					
		TRY
			lnv_correo.of_enviar_correo('Confecci$$HEX1$$f300$$ENDHEX$$n Terceros', ls_mensaje, 'confeccion_terceros')
		CATCH(Exception exp)
			Messagebox("Error", exp.getmessage())
		END TRY
		DESTROY lnv_correo 
	End If
Else
	Rollback; 
	MessageBox('Error','No fue posible determinar los recipientes utilizados en la O.C. y P.O.')
	Close(w_retroalimentacion)
	Return -1
End if
//******************************************ahorra debemos imprimir el bongo
Close(w_retroalimentacion)

//extraigo la hora para determinar el turno
ldt_fecha = f_fecha_servidor()
lt_tiempo = Time(ldt_fecha)
li_tiempo = hour(lt_tiempo)

//select distinct dt_canasta_corte.co_fabrica_ref,
//		dt_canasta_corte.co_linea,
//		dt_canasta_corte.co_referencia
//into :li_fabrica,
//	  :li_linea,
//	  :ll_referencia
//from dt_canasta_corte, h_canasta_corte
//where h_canasta_corte.pallet_id = :ls_bongo and
//		h_canasta_corte.cs_canasta = dt_canasta_corte.cs_canasta;

//se verifica que si se apruebe el loteo
lstr_parametros.cadena[1] = ''
lstr_parametros.entero[1] = 0
lstr_parametros.entero[2] = ll_result
lstr_parametros.entero[3] = al_orden_corte
lstr_parametros.cadena[2] = as_po
lstr_parametros.entero[4] = li_tiempo
lstr_parametros.cadena[3] = ls_loteo_max
lstr_parametros.entero[5] = li_fabrica
lstr_parametros.entero[6] = li_linea
lstr_parametros.entero[7] = ll_referencia

OpenWithParm ( w_validar_loteo, lstr_parametros )

lstr_parametros = Message.PowerObjectParm
If lstr_parametros.hay_parametros = false Then
   Rollback;
	Close(w_retroalimentacion) 
	Return -1
End if
//SA53802 - Ceiba/JJ - 29-10-2015 Valores por defecto para buscar en los est$$HEX1$$e100$$ENDHEX$$ndares de la referencia y procesos
ll_tipoPdto		= wf_leerConstantes('TIPO PRENDAS','el tipo de producto.') //SA53802 - Ceiba/JJ - 29-10-2015
ll_centro_pdn	= wf_leerConstantes('CONFECCION','el centro de confecci$$HEX1$$f300$$ENDHEX$$n') //SA53802 - Ceiba/JJ - 29-10-2015
li_loteoConf 	= wf_leerConstantescorte('MENS_LOTEO_CONF','la configuraci$$HEX1$$f300$$ENDHEX$$n del loteo.') //SA53802 - Ceiba/JJ - 29-10-2015

IF al_duo_conjunto <= 10 THEN
	//no es un duo
	dw_adhesivos.Retrieve('',0,ll_result,al_orden_corte,as_po,li_tiempo,li_fabrica, li_linea, ll_referencia,ls_loteo_max,ll_tipoPdto,ll_centro_pdn,li_loteoConf)
ELSE
	//se trata de un duo, se valida que las unidades sean iguales, inicialmente es solo informativo  jorodrig julio 24-09
	IF luo_corte.of_valida_unid_duo_loteo(al_duo_conjunto) <> 1 THEN
		//se activa marzo 15 -2011 solicita Jaiver Garcia
		Rollback;
		destroy lds_bongo;
		Close(w_retroalimentacion)
		return -1
	END IF
	
	//se trata de un duo se deben traer todos los bongos que lo componen
	dw_adhesivos.DataObject = 'dtb_adhesivos_bongo_new_duo'
	dw_adhesivos.SetTransObject(sqlca)
	//se va a cambiar para probar si sale el adhsevio normal solo con la Orden
	//adiciono al final el argumento de orden de corte 
	//jorodrig sep 21 - 09
	dw_adhesivos.Retrieve('',0,ll_result,al_duo_conjunto,as_po,li_tiempo,li_fabrica, li_linea, ll_referencia,ls_loteo_max,al_orden_corte,ll_tipoPdto,ll_centro_pdn,li_loteoConf)
END IF

//uo_dsbase lds_info_oc
//lds_info_oc = Create uo_dsbase
//lds_info_oc.DataObject = 'd_gr_datos_x_oc'
//lds_info_oc.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
//
//uo_correo	lnv_correo

//consulto datos de la oc
If lds_info_oc.Retrieve(al_orden_corte,as_po,li_fabrica, li_linea, ll_referencia) > 0 Then
	//verificar si la orden de corte tipo co_tipo = 10
	If lds_info_oc.GetItemNumber(1,'co_tipo') = 10 Then
		//toma los datos
		ls_body = 'Se realiz$$HEX2$$f3002000$$ENDHEX$$el loteo de la orden de corte marcada como ORDEN DE CORTE PO nro: ' + &
					 String(al_orden_corte) + '~r~n PO:' + String(as_po) + &
					 '~r~n Gpa:' + Trim(lds_info_oc.GetItemString(1,'gpa')) + &
					 '~r~n OP:' + String(lds_info_oc.GetItemNumber(1,'cs_ordenpd_pt')) + &
					 '~r~n Fabrica:' + String(lds_info_oc.GetItemNumber(1,'co_fabrica_pt')) + &
					 '~r~n Linea:' + String(lds_info_oc.GetItemNumber(1,'co_linea')) + &
					 '~r~n Referenci:' + String(lds_info_oc.GetItemNumber(1,'co_referencia')) + &
					 ' - ' + Trim(lds_info_oc.GetItemString(1,'de_referencia')) + &
					 '~r~n Color:' + String(lds_info_oc.GetItemNumber(1,'co_color_pt')) + &
					 '~r~n Cantidad:' + String(lds_info_oc.GetItemDecimal(1,'ca_programada')) + &
					 '~r~n Cantidad loteada:' + String(lds_info_oc.GetItemDecimal(1,'ca_loteada'))
					 
		lnv_correo = CREATE uo_correo
		
		TRY
			lnv_correo.of_enviar_correo('ORDEN DE CORTE PO', ls_body,'orden_corte_po')
		CATCH(Exception ex)
			Messagebox("Error", ex.getmessage())
		END TRY
		DESTROY lnv_correo 
	End if
End if

Destroy lds_info_oc
Destroy lds_informacion_x_bongo

				
//dw_adhesivos.Retrieve('',0,ll_result,al_orden_corte,as_po,li_tiempo,li_fabrica, li_linea, ll_referencia,ls_loteo_max)
//OpenWithParm(w_opciones_impresion, dw_adhesivos)

destroy lds_bongo;

Return 0

end function

public function long f_marcar_oc_con_sobras (long al_orden_corte, long ai_marca);

UPDATE h_ordenes_corte
   SET co_estado_loteo = :ai_marca
 WHERE cs_orden_corte = :al_orden_corte; 
IF sqlca.sqlcode = -1 Then
	ROLLBACK;
	MessageBox('Error','Marcando la O.C. con unidades sobrantes',StopSign!)
	Return -1
ELSE
	COMMIT;
END IF
 
 
Return 1
end function

public function long of_marcar_bongo_sobras (long al_bongo, string as_canasta);
Long ll_tipo, ll_orden_corte
STRING	ls_bongo
n_cst_loteo_bongo lpo_loteo

ls_bongo = string(al_bongo)

ll_orden_corte = dw_maestro.GetItemNumber(1,'orden_corte')
IF IsNull(ll_orden_corte) or ll_orden_corte <= 0 THEN
	MessageBox('Advertencia','No se ha digitado ninguna orden de corte.')
	Return 1
END IF

/* FACL - 2021/09/23 - ID530 - Se desactiva control - porque tipo 2 ya es una OC normal
//verifica si la orden de corte es MUESTRA VENDEDOR - LOTE PILOTO, tipo = 2 
ll_tipo = lpo_loteo.of_tipo_orden_corte(ll_orden_corte)
//si es para muestras
If ll_tipo = 2 Then
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La orden corte es de tipo MUESTRA VENDEDOR - LOTE PILOTO. No se puede marcar como sobrante.')
	Return 1
Elseif ll_tipo < 0 Then
	MessageBox('Advertencia','No se encontro tipo de la orden de corte para marcar el bongo.')
	Return -1
End if
*/

//se va a marcar todo el bongo como sobrante, pues deben separar esta produccion para luego mercar a parte
//esto se decide en reunion con jdpelaez, Jaime Sierra, Ejsernag, uaalvarez, mfjarami, ljgarcia,hljarami, jorodrig 
//abril16 -2010 realiza jorodrig
//cambio actualizacion del campo prioridad_gbi por instrucciones_esp3 20 06 18
UPDATE h_canasta_corte 
 SET (sw_origen, ob_ordprod, instrucciones_esp3) = ('S', 'Bongo Sobrante Ubicacion Congelada','3')
WHERE cs_canasta = :as_canasta; 
IF sqlca.sqlcode = -1 Then
	ROLLBACK;
	MessageBox('Error','Marcando el bongo como sobrante',StopSign!)
	Return -1
ELSE
	COMMIT;
	dw_maestro.Modify("t_sobrante.Text='Sobrante'")
	dw_maestro.SetItem(1,'sw_origen','S')
END IF 

Return 1
end function

public function long of_ops_a_cerrar (long al_ordencorte);//funcion que determina las op(s) loteadas a mas de un 90% para cerrarlas automaticamente
Long     ll_n, ll_filas, ll_op, ll_op_estilo[], ll_pedido, ll_op_sumary[], ll_sw_cierre_corte
Long  li_retorno
DateTime ldt_fecha
DataStore lds_ops_a_cerrar, lds_consulta_pedido_x_op, lds_consulta_op_agrupada, lds_valida_oc_corte_adelantado
n_cerrar_po lnv_cierre_op

lnv_cierre_op = Create n_cerrar_po

//datastore que consulta las op(s) que se pueden cerrar
lds_ops_a_cerrar = Create DataStore
lds_ops_a_cerrar.DataObject = 'dtb_ops_a_cerrar' 
lds_ops_a_cerrar.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//datastore que consulta si la op es pertenece a una agrupada
lds_consulta_op_agrupada = Create DataStore
lds_consulta_op_agrupada.DataObject = 'dtb_consulta_op_agrupada' 
lds_consulta_op_agrupada.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//datastore que consulta las op(s) que se pueden cerrar
lds_consulta_pedido_x_op = Create DataStore
lds_consulta_pedido_x_op.DataObject = 'dtb_consulta_pedido_x_op' 
lds_consulta_pedido_x_op.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

//datastore que consulta las op(s) que se pueden cerrar
lds_valida_oc_corte_adelantado = Create DataStore
lds_valida_oc_corte_adelantado.DataObject = 'dtb_valida_oc_corte_adelantado' 
lds_valida_oc_corte_adelantado.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ll_filas = lds_ops_a_cerrar.retrieve(al_ordencorte)
ldt_fecha = f_fecha_servidor()
//si hay ops que cerrar
IF ll_filas > 0 THEN
	
	//revisa si la oc es corte adelantado
	IF lds_valida_oc_corte_adelantado.retrieve(al_ordencorte) > 0 THEN
	   ll_sw_cierre_corte = 3
	ELSE
		ll_sw_cierre_corte = 2
	END IF 
	  
	FOR ll_n = 1 TO ll_filas
		ll_op = lds_ops_a_cerrar.getitemnumber(ll_n,"cs_ordenpd_pt")
		
		//revisa si el pedido que se va marcar esta en mas de una op si es asi cancela el cierre de op
		IF lds_consulta_pedido_x_op.retrieve(ll_op) = 1 THEN
			ll_pedido = lds_consulta_pedido_x_op.getitemnumber(1,"pedido")
			
			//si hay op entonces llama funcion que cierra la op
			IF ll_op > 0 THEN
				
				ll_op_estilo[1] = ll_op
								
				//revisa si la op es esta agrupada en otra si es asi
				//valida que no tenga ninguna tela en proceso de la op agrupada
				IF lds_consulta_op_agrupada.retrieve(ll_op) > 0 THEN
					
					ll_op_sumary[1] = lds_consulta_op_agrupada.getitemnumber(1,"cs_ordenpd_pt")				
				   
					IF lnv_cierre_op.of_validar_op_sumary(ll_op_sumary) = 1 THEN	
						
					   //si pasa la validacion cierra la op individual cierra la op
						//si cerro la op entonces pone marca en el pedido(peddig)
						IF lnv_cierre_op.of_cerrar_op_estilo(ll_op_estilo) = 1 THEN
							
							//actualizo el campo sw_cierre_corte en peddig, para indicar que se 
							//que no debe tomarlo symphony
							update peddig
							set sw_cierre_corte = :ll_sw_cierre_corte,
							    fe_cierre_corte = :ldt_fecha
							where pedido = :ll_pedido
							  and (select count(h.cs_ordenpd_pt)
							       from h_ordenpd_pt h, dt_pedidosxorden d
									 where h.cs_ordenpd_pt = d.cs_ordenpd_pt
								      and d.pedido = :ll_pedido
										and h.co_estado_orden in(1,3)
									      ) = 0
							;		
							
							IF sqlca.sqlcode = -1 Then
								ROLLBACK;
							ELSE
								COMMIT;
							END IF					
						END IF						
				   END IF
					
			   ELSE   					 
					 //cierra la op
					//si cerro la op entonces pone marca en el pedido(peddig)
					IF lnv_cierre_op.of_cerrar_op_estilo(ll_op_estilo) = 1 THEN
						
						//actualizo el campo sw_cierre_corte en peddig, para indicar que se 
						//que no debe tomarlo symphony
						update peddig
						set sw_cierre_corte = :ll_sw_cierre_corte,
						    fe_cierre_corte = :ldt_fecha						  
						where pedido = :ll_pedido
						 and (select count(h.cs_ordenpd_pt)
							       from h_ordenpd_pt h, dt_pedidosxorden d
									 where h.cs_ordenpd_pt = d.cs_ordenpd_pt
								      and d.pedido = :ll_pedido
										and h.co_estado_orden in(1,3)
									      ) = 0
						;		
						
						IF sqlca.sqlcode = -1 Then
							ROLLBACK;
						ELSE
							COMMIT;
						END IF					
					END IF	//FIN lnv_cierre_op.of_cerrar_op_estilo(ll_op_estilo) = 1
				END IF		
			END IF
		END IF	
	NEXT
END IF	

DESTROY lds_ops_a_cerrar
DESTROY lds_consulta_pedido_x_op
DESTROY lds_valida_oc_corte_adelantado

RETURN 1
end function

public function long of_verifica_nuevo_grupo_sobrantes (string as_bongos[]);
/*
Funcion para verificar el cliente para cambio de grupo en sobrantes
*/
Long ll_aux, ll_semana, ll_n, ll_pedido, ll_item, ll_reg, ll_aumento_fecha, ll_dias,ll_cantidad,ll_nulo, & 
		ll_pedido_ant, ll_m, ll_cont
String ls_po, ls_referencia, ls_expresion, ls_bongos, ls_bongo, ls_cajas[]
Datetime ldt_fecha
n_cst_funciones_comunes lnvo_funcion
n_cts_constantes_corte lnvo_constante_fecha
s_parametros_calendario lstr_parametros
n_utilidades_simulacion lnvo_simulacion
uo_dsbase lds_semana, lds_bongos_sobrantes, lds_pedpend_exp, lds_peddig, lds_cliente_grupo_sobrantes, lds_grupo, &
			 lds_ped_ref, lds_barras, lds_modulos_cambio, lds_barra_consulta, lds_arbol_pedido, lds_arbol_consulta, &
			 lds_valida_bongo

SetNull(ll_nulo)
lnvo_simulacion.ib_hacer_commit = False
lstr_parametros.Hay_parametros = True

//verifica si el cliente tiene la marca de creaci$$HEX1$$f300$$ENDHEX$$n de grupo nuevo al lotear sobrantes. Si tiene dicha marca entonces
lds_bongos_sobrantes = Create uo_dsbase
lds_bongos_sobrantes.DataObject = 'd_gr_bongos_sobrantes_cambio_grupo'
lds_bongos_sobrantes.SetTransObject(SQLCA)


//mira si los bongos de sobrantes se le deb cambiar de PO
ll_aux = lds_bongos_sobrantes.Of_Retrieve(as_bongos)
//si encuentra se realizan los cambios
If ll_aux > 0 Then
	ll_cont = 1
	//toma los pallet que tiene marcado como sobrantes
	For ll_n = 1 To lds_bongos_sobrantes.RowCount()
		ls_bongo = "(" + Trim(lds_bongos_sobrantes.GetItemString(ll_n,'pallet_id')) + ")"
		If Pos(ls_bongos,ls_bongo) = 0 Then
			ls_bongos += ls_bongo + "~t"
			ls_cajas [ll_cont] = Trim(lds_bongos_sobrantes.GetItemString(ll_n,'pallet_id'))
			ll_cont ++
		End If
	Next
	
	lds_valida_bongo = Create uo_dsbase
	lds_valida_bongo.DataObject = 'd_gr_sw_estado_sobrantes_bongo'
	lds_valida_bongo.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	//recorre los bongos y valida que todas las bolsas esten marcadas como sobrantes
	For ll_cont = 1 To UpperBound(ls_cajas)
		ls_bongo = ls_cajas [ll_cont]
		ll_n = lds_valida_bongo.Of_Retrieve(ls_bongo)
		If ll_n <= 0 Then
			Rollback; 
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informaci$$HEX1$$f300$$ENDHEX$$n para validar si el bongo esta marcado como sobrantes. bongo: ' + trim(ls_bongo))
			Destroy lds_semana
			Destroy lds_bongos_sobrantes
			Destroy lds_ped_ref
			Return -1
		End if
		
		//si si tiene mas de un registro es porque no se tiene todo el bongo marcado como sobrantes
		If lds_valida_bongo.RowCount() <> 1 Then
			Rollback; 
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El bongo ' + trim(ls_bongo) + ' no tiene todas las bolsas marcadas como sobrantes, no se puede continuar con el proceso de loteo.')
			Destroy lds_semana
			Destroy lds_bongos_sobrantes
			Destroy lds_ped_ref
			Return -1
		End if
	Next
	
	Destroy lds_valida_bongo
	
	
	lds_ped_ref = Create uo_dsbase
	lds_ped_ref.DataObject = 'd_gr_pedido_ref_x_bongo_sob_cambio_grupo'
	lds_ped_ref.SetTransObject(SQLCA)

	ldt_fecha = f_fecha_servidor()
	
	//toma la cantidad de dias de aumento para la fecha de despacho
	ll_aumento_fecha = lnvo_constante_fecha.of_consultar_numerico('DIAS_FEC_DESP_LOTEO_SOBRANTES')
	//mira si el dia es miercoles para hacercarlo al miercoles mas proximo
	ll_dias = DayNumber (RelativeDate(Date(ldt_fecha),ll_aumento_fecha))
	//si vale 4 es miercoles
	If ll_dias <> 4 Then
		//se realiza calculo para que de el proximo miercoles
		If ll_dias < 4 Then
			ll_aumento_fecha = ll_aumento_fecha + (4 - ll_dias)
		Else
			ll_aumento_fecha = ll_aumento_fecha + (11 - ll_dias)
		End if
		
	End if
	
	//Crea el datastore con el que se recupera el n$$HEX1$$fa00$$ENDHEX$$mero de semana de la fecha actual 
	lds_semana = Create uo_dsbase
	lds_semana.DataObject = 'd_gr_semana_com'
	lds_semana.SetTransObject(SQLCA)
	ll_n = lds_semana.Of_Retrieve(Date(f_fecha_servidor()))
	If ll_n <= 0 Then
		Rollback; 
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informaci$$HEX1$$f300$$ENDHEX$$n el calendario contable para la fecha ' + &
						String(Date(f_fecha_servidor())))
		Destroy lds_semana
		Destroy lds_bongos_sobrantes
		Destroy lds_ped_ref
		Return -1
	End if
	ll_semana = lds_semana.GetItemNumber(1,'semana')
	Destroy lds_semana
	
	lds_barras = Create uo_dsbase
	lds_barras.DataObject = 'd_gr_barras_pdp_confencion_x_pedido_ref'
	lds_barras.SetTransObject(SQLCA)
	
	lds_arbol_pedido = Create uo_dsbase
	lds_arbol_pedido.DataObject = 'd_gr_dt_arbol_pedido'
	lds_arbol_pedido.SetTransObject(SQLCA)

	
	lds_cliente_grupo_sobrantes = Create uo_dsbase
	lds_cliente_grupo_sobrantes.DataObject = 'd_gr_cliente_grupo_sobrantes'
	lds_cliente_grupo_sobrantes.SetTransObject(SQLCA)
	
	lds_grupo = Create uo_dsbase
	lds_grupo.DataObject = 'd_gr_m_grupos_ventas'
	lds_grupo.SetTransObject(SQLCA)
	
	
	lds_peddig = Create uo_dsbase
	lds_peddig.DataObject = 'd_ff_peddig_exportacion'
	lds_peddig.SetTransObject(SQLCA)
	
	lds_pedpend_exp = Create uo_dsbase
	lds_pedpend_exp.DataObject = 'd_tb_pedpend_exp_x_po'
	lds_pedpend_exp.SetTransObject(SQLCA)
	
	If Trim(lds_bongos_sobrantes.GetItemString(1,'grupo')) = '' or Isnull(lds_bongos_sobrantes.GetItemString(1,'grupo')) or & 
		ll_semana <> lds_bongos_sobrantes.GetItemNumber(1,'semana') Then
		ll_item = 0
		ll_pedido = 0
	Else
		//trae los datos del pedido de la PO nuevo
		ll_aux = lds_pedpend_exp.Of_Retrieve(lds_bongos_sobrantes.GetItemString(1,'grupo'))
		If  ll_aux > 0 Then
			ll_item = lds_pedpend_exp.GetItemNumber(1,'item_primera')
			ll_pedido = lds_pedpend_exp.GetItemNumber(1,'pedido')
		ElseIf  ll_aux = 0 Then
			ll_item = 0
			ll_pedido = 0
		ElseIf  ll_aux < 0 Then
			Rollback; 
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar la informacion de la PO ' + Trim(lds_bongos_sobrantes.GetItemString(1,'grupo')))
			Destroy lds_cliente_grupo_sobrantes
			Destroy lds_bongos_sobrantes
			Destroy lds_grupo
			Destroy lds_ped_ref
			Destroy lds_peddig
			Destroy lds_pedpend_exp
			Destroy lds_barras 
			Destroy lds_arbol_pedido
			Return -1
		End if
	End if

	//recorre la informaci$$HEX1$$f300$$ENDHEX$$n de los bongos
	For ll_aux = 1 to lds_bongos_sobrantes.RowCount()
		//mira si cambia de semana
		If ll_semana <> lds_bongos_sobrantes.GetItemNumber(ll_aux,'semana') Then
			//mira si ya creo el pedido
			If ll_pedido = 0 Then
				
				//calcula la po nueva
				ls_po = Left(Trim(lds_bongos_sobrantes.GetItemString(ll_aux,'de_cliente')),3) + String(ll_semana) + &
							Right(String(Year(Date(ldt_fecha))),2)
							
				// se inserta un registro en el corte que se va a actualizar
				ll_reg = lds_cliente_grupo_sobrantes.InsertRow(0)
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'co_cliente', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_cliente'))
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'semana', lds_bongos_sobrantes.GetItemNumber(ll_aux,'semana'))
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'grupo', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'fe_actualizacion', ldt_fecha)
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'usuario', trim(gstr_info_usuario.nombre_usuario))
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'instancia', trim(gstr_info_usuario.instancia))
				
			// se ponen los registros como modificado para que se lance un update
				lds_cliente_grupo_sobrantes.ResetUpdate()
				lds_cliente_grupo_sobrantes.SetItemStatus(ll_reg, "semana", Primary!, DataModified!)
				lds_cliente_grupo_sobrantes.SetItemStatus(ll_reg, "grupo", Primary!, DataModified!)
				lds_cliente_grupo_sobrantes.SetItemStatus(ll_reg, "fe_actualizacion", Primary!, DataModified!)
				lds_cliente_grupo_sobrantes.SetItemStatus(ll_reg, "usuario", Primary!, DataModified!)
				lds_cliente_grupo_sobrantes.SetItemStatus(ll_reg, "instancia", Primary!, DataModified!)
				
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'semana', ll_semana)
				lds_cliente_grupo_sobrantes.SetItem(ll_reg, 'grupo', ls_po)

				lds_bongos_sobrantes.SetItem(ll_aux, 'semana', ll_semana)
				lds_bongos_sobrantes.SetItem(ll_aux, 'grupo', ls_po)
				lds_bongos_sobrantes.SetItem(ll_aux, 'co_grupo_cte', ls_po)
				

				//toma consecutivo del pedido
				ll_pedido = lnvo_funcion.of_consecutivos(2,'EX')
				If ll_pedido <= 0 Then
					Rollback; 
					MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Fall$$HEX2$$f3002000$$ENDHEX$$la creacion del pedido de sobrantes')
					Destroy lds_cliente_grupo_sobrantes
					Destroy lds_bongos_sobrantes
					Destroy lds_grupo
					Destroy lds_ped_ref
					Destroy lds_peddig
					Destroy lds_pedpend_exp
					Destroy lds_barras 
					Destroy lds_arbol_pedido
					Return -1
				End If
				
				//inserta encabezado de pedido
				ll_reg = lds_peddig.InsertRow(0)
				lds_peddig.SetItem(ll_reg,'co_fabrica_vta', 2)
				lds_peddig.SetItem(ll_reg,'pedido', ll_pedido)
				lds_peddig.SetItem(ll_reg,'ano_contable', Year(Date(ldt_fecha)))
				lds_peddig.SetItem(ll_reg,'mes_contable', Month(Date(ldt_fecha)))
				lds_peddig.SetItem(ll_reg,'tipo_pedido', lds_bongos_sobrantes.GetItemString(ll_aux,'tipo_pedido'))
				lds_peddig.SetItem(ll_reg,'orden_compra', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				lds_peddig.SetItem(ll_reg,'fe_pedido', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'fe_recepcion', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'fe_primer_dpacho', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'fe_ultimo_dpacho', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'fe_cancela_dpacho', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'co_cliente', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_cliente'))
				lds_peddig.SetItem(ll_reg,'co_sucursal', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_sucursal'))
				lds_peddig.SetItem(ll_reg,'co_adhesivo', 2)
				lds_peddig.SetItem(ll_reg,'fe_transmision', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'fe_despacho', RelativeDate(Date(ldt_fecha),ll_aumento_fecha))
				lds_peddig.SetItem(ll_reg,'fe_creacion', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'usuario', gstr_info_usuario.codigo_usuario)
				lds_peddig.SetItem(ll_reg,'fe_actualizacion', ldt_fecha)
				lds_peddig.SetItem(ll_reg,'instancia', gstr_info_usuario.instancia)
				lds_peddig.SetItem(ll_reg,'co_coleccion', 99)
				lds_peddig.SetItem(ll_reg,'gpa', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				//FRICE E00337 JFDIAFER	 			
				lds_peddig.SetItem(ll_reg,'co_proposito_po',lnvo_constante_fecha.of_consultar_texto("PROPOSITO_LECTURA_BOLSA"))
				//SA48504 JFDIAFER
				//lds_peddig.SetItem(ll_reg,'orden_compra', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'po')))
				lds_peddig.SetItem(ll_reg,'zona', lds_bongos_sobrantes.GetItemNumber(ll_aux,'zona'))
				lds_peddig.SetItem(ll_reg,'co_caja', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_caja'))
				lds_peddig.SetItem(ll_reg,'tipo_orden_toc', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'tipo_orden_toc')))
				lds_peddig.SetItem(ll_reg,'co_adhesivo', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'co_adhesivo')))

				//inserta grupo
				ll_reg = lds_grupo.InsertRow(0)
				lds_grupo.SetItem(ll_reg,'co_grupo', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				lds_grupo.SetItem(ll_reg,'de_grupo', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				lds_grupo.SetItem(ll_reg,'de_grupo_digitado', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				lds_grupo.SetItem(ll_reg,'grupo_cte', lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
				lds_grupo.SetItem(ll_reg,'co_cliente', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_cliente'))
				lds_grupo.SetItem(ll_reg,'co_division', 1)
				lds_grupo.SetItem(ll_reg,'co_coordinador', 48)
				lds_grupo.SetItem(ll_reg,'fe_creacion', ldt_fecha)
				lds_grupo.SetItem(ll_reg,'usuario', gstr_info_usuario.codigo_usuario)
				lds_grupo.SetItem(ll_reg,'fe_actualizacion', ldt_fecha)
				lds_grupo.SetItem(ll_reg,'sw_activo', 1)
				
			Else
				
			End if
		End if	
		
		//valida el pedido
		If ll_pedido <= 0 Then
			Rollback; 
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se pudo obtener el pedido de sobrantes para el cambio en el bongo')
			Destroy lds_cliente_grupo_sobrantes
			Destroy lds_bongos_sobrantes
			Destroy lds_grupo
			Destroy lds_ped_ref
			Destroy lds_peddig
			Destroy lds_pedpend_exp
			Destroy lds_barras 
			Destroy lds_arbol_pedido
			Return -1
		End if
		
		//se verifica que si este el sku de produccion
		//busca si el sku de produccion esta en el pedido
		ll_n = lds_pedpend_exp.Find(	'co_fabrica = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_fabrica_ref')) + &
												' and co_linea = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_linea')) + &
												' and co_referencia = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_referencia')) + &
												' and co_talla = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_talla')) + &
												' and co_calidad = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_calidad')) + &
												' and co_color = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_color'))  &
												,1, lds_pedpend_exp.RowCount() +1)
		//si lo encuentra aumenta la cantidad pedida
		If ll_n > 0 then 
			lds_pedpend_exp.SetItem(ll_n,'ca_pedida', lds_pedpend_exp.GetItemDecimal(ll_n,'ca_pedida') + &
												lds_bongos_sobrantes.GetItemDecimal(ll_aux,'ca_actual'))
			lds_pedpend_exp.SetItem(ll_n,'ca_pedida_comprar', lds_pedpend_exp.GetItemDecimal(ll_n,'ca_pedida_comprar') + &
												lds_bongos_sobrantes.GetItemDecimal(ll_aux,'ca_actual'))
		//no lo encuentra, crea el registro en el pedido
		ElseIf ll_n = 0 Then
			//aumenta el valor del item para pedpend_exp
			ll_item ++
			//inserta detalle del pedido
			ll_reg = lds_pedpend_exp.InsertRow(0)
			lds_pedpend_exp.SetItem(ll_reg,'pedido', ll_pedido)
			lds_pedpend_exp.SetItem(ll_reg,'item', ll_item)
			lds_pedpend_exp.SetItem(ll_reg,'nu_cut', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'nu_cut')))
			lds_pedpend_exp.SetItem(ll_reg,'co_fabrica_exp',lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_fabrica_exp'))
			lds_pedpend_exp.SetItem(ll_reg,'co_linea_exp', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_linea_exp'))
			lds_pedpend_exp.SetItem(ll_reg,'co_ref_exp', String(lds_bongos_sobrantes.GetItemString(ll_aux,'co_ref_exp')))
			lds_pedpend_exp.SetItem(ll_reg,'co_talla_exp', String(lds_bongos_sobrantes.GetItemString(ll_aux,'co_talla_exp')))
			lds_pedpend_exp.SetItem(ll_reg,'co_color_exp', String(lds_bongos_sobrantes.GetItemString(ll_aux,'co_color_exp')))
			lds_pedpend_exp.SetItem(ll_reg,'co_calidad', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_calidad'))
			lds_pedpend_exp.SetItem(ll_reg,'ca_pedida',lds_bongos_sobrantes.GetItemDecimal(ll_aux,'ca_actual'))
			lds_pedpend_exp.SetItem(ll_reg,'nu_orden', Trim(lds_bongos_sobrantes.GetItemString(ll_aux,'grupo')))
			lds_pedpend_exp.SetItem(ll_reg,'fe_entrega', RelativeDate(Date(ldt_fecha),ll_aumento_fecha))
			lds_pedpend_exp.SetItem(ll_reg,'fe_recep_esp', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'fe_envio_muestra', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'fe_pp_comment_rec', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'fe_exit_po', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'upc_barcode', lds_bongos_sobrantes.GetItemString(ll_aux,'upc_barcode'))
			lds_pedpend_exp.SetItem(ll_reg,'fe_creacion', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'fe_actualizacion', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'usuario', gstr_info_usuario.codigo_usuario)
			lds_pedpend_exp.SetItem(ll_reg,'instancia', gstr_info_usuario.instancia)
			lds_pedpend_exp.SetItem(ll_reg,'co_cliente_exp', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_cliente'))
			lds_pedpend_exp.SetItem(ll_reg,'co_sucursal_exp', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_sucursal'))
			lds_pedpend_exp.SetItem(ll_reg,'fe_act_exit', ldt_fecha)
			lds_pedpend_exp.SetItem(ll_reg,'co_fabrica',lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_fabrica_ref'))
			lds_pedpend_exp.SetItem(ll_reg,'co_linea', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_linea'))
			lds_pedpend_exp.SetItem(ll_reg,'co_referencia', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_referencia'))
			lds_pedpend_exp.SetItem(ll_reg,'co_talla', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_talla'))
			lds_pedpend_exp.SetItem(ll_reg,'co_color', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_color'))
			lds_pedpend_exp.SetItem(ll_reg,'co_prepack', lds_bongos_sobrantes.GetItemString(ll_aux,'co_prepack'))
			lds_pedpend_exp.SetItem(ll_reg,'categoria_sap', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'categoria_sap')))
			lds_pedpend_exp.SetItem(ll_reg,'co_material_sap', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'co_material_sap')))
			lds_pedpend_exp.SetItem(ll_reg,'co_talla_sap', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'co_talla_sap')))
			lds_pedpend_exp.SetItem(ll_reg,'co_color_sap', trim(lds_bongos_sobrantes.GetItemString(ll_aux,'co_color_sap')))
			lds_pedpend_exp.SetItem(ll_reg,'ca_pedida_comprar',lds_bongos_sobrantes.GetItemDecimal(ll_aux,'ca_actual'))
			lds_pedpend_exp.SetItem(ll_reg,'toc', -1)


		ElseIf ll_n < 0 Then
			Rollback; 
			MessageBox('Advertencia','Se encontro un inconveniente al buscar el sku de produccion en el pedido de grupo de sobrantes.')
			Destroy lds_cliente_grupo_sobrantes
			Destroy lds_bongos_sobrantes
			Destroy lds_grupo
			Destroy lds_ped_ref
			Destroy lds_peddig
			Destroy lds_pedpend_exp
			Destroy lds_barras 
			Destroy lds_arbol_pedido
			Return -1 
		End if	
		
		//busca si el sku de produccion - pedido para mirar el pdp confeccion
		ll_n = lds_ped_ref.Find(	'co_fabrica_ref = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_fabrica_ref')) + &
												' and co_linea = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_linea')) + &
												' and co_referencia = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_referencia')) + &
												' and pedido = ' + String(lds_bongos_sobrantes.GetItemNumber(ll_aux,'pedido'))  &
												,1, lds_ped_ref.RowCount() +1)
		//si lo encuentra aumenta la cantidad pedida
		If ll_n = 0 then 
			ll_reg = lds_ped_ref.InsertRow(0)
			lds_ped_ref.SetItem(ll_reg,'pedido', lds_bongos_sobrantes.GetItemNumber(ll_aux,'pedido'))
			lds_ped_ref.SetItem(ll_reg,'co_fabrica_ref',lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_fabrica_ref'))
			lds_ped_ref.SetItem(ll_reg,'co_linea', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_linea'))
			lds_ped_ref.SetItem(ll_reg,'co_referencia', lds_bongos_sobrantes.GetItemNumber(ll_aux,'co_referencia'))
			lds_ped_ref.SetItem(ll_reg,'ca_actual', lds_bongos_sobrantes.GetItemDecimal(ll_aux,'ca_actual'))
			
		ElseIf ll_n > 0 then
			lds_ped_ref.SetItem(ll_n,'ca_actual', lds_ped_ref.GetItemDecimal(ll_n,'ca_actual') + lds_bongos_sobrantes.GetItemDecimal(ll_aux,'ca_actual'))
		Else
			Rollback; 
			MessageBox('Advertencia','Se encontro un inconveniente al buscar el pedido y la referencia de produccion para el grupo de sobrantes.')
			Destroy lds_cliente_grupo_sobrantes
			Destroy lds_bongos_sobrantes
			Destroy lds_grupo
			Destroy lds_ped_ref
			Destroy lds_peddig
			Destroy lds_pedpend_exp
			Destroy lds_barras 
			Destroy lds_arbol_pedido
			Return -1 
		End if
		
		//actualiza el pedido, po en el bongo
		lds_bongos_sobrantes.SetItem(ll_aux,'pedido',ll_pedido)
		lds_bongos_sobrantes.SetItem(ll_aux,'po',lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
		lds_bongos_sobrantes.SetItem(ll_aux,'co_grupo_cte',lds_bongos_sobrantes.GetItemString(ll_aux,'grupo'))
		

	Next
	
	lds_modulos_cambio = Create uo_dsbase
	lds_modulos_cambio.DataObject = 'd_ff_parametros_subcentro_modulo'
	lds_modulos_cambio.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	lds_barra_consulta = Create uo_dsbase
	lds_barra_consulta.DataObject = lds_barras.DataObject 
	lds_barra_consulta.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

	lds_arbol_consulta = Create uo_dsbase
	lds_arbol_consulta.DataObject = lds_arbol_pedido.DataObject 
	lds_arbol_consulta.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	

	//busca el pedido-referencia para el pdp de confeccion
	For ll_aux = 1 to lds_ped_ref.RowCount()
		//toma el dato del pedido y referencia
		ll_pedido_ant = lds_ped_ref.GetItemNumber(ll_aux,'pedido')
		ls_referencia = left( String(lds_ped_ref.GetItemNumber(ll_aux,'co_fabrica_ref'))+'     ' , 5) + &
							 left( String(lds_ped_ref.GetItemNumber(ll_aux,'co_linea'))+'     ' , 5) + &
							 left( String(lds_ped_ref.GetItemNumber(ll_aux,'co_referencia'))+fill(' ',20), 20) 
							 
		//toma la cantidad
		ll_cantidad = lds_ped_ref.GetItemDecimal(ll_aux,'ca_actual')
		
		//mira si hay datos en el pdp para el pedido-referencia
		ll_n = lds_barra_consulta.of_retrieve(ll_pedido_ant, ls_referencia)
		//si encontro datos
		If ll_n > 0 Then
			//inserta la barra nueva
			lds_barra_consulta.RowsCopy(ll_n, ll_n, Primary!, lds_barras, lds_barras.RowCount() + 1, Primary!)
			
			ll_n = lds_barras.RowCount()
			//se coloca las unidades 
			lds_barras.SetItem(ll_n,'pedido',ll_pedido)
			lds_barras.SetItem(ll_n,'ca_programada',ll_cantidad)
			lds_barras.SetItem(ll_n,'ca_asignada',0)
			//coloca la barra despues de la ultima barra 
			lds_barras.SetItem(ll_n,'fe_inicio_progs', datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_max_final')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_max_final')), 1 ) ))
			lds_barras.SetItem(ll_n,'fe_final_progs', datetime(Date( lds_barras.GetItemDatetime(ll_n,'fe_max_final')),RelativeTime ( Time(lds_barras.GetItemDatetime(ll_n,'fe_max_final')), 3 ) ))
			lds_barras.SetItem(ll_n,'secuencia',ll_nulo)
			lds_barras.SetItem(ll_n,'fe_creacion',ldt_fecha)
			lds_barras.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
			lds_barras.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
			lds_barras.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
			
			//se guarda el modulo para actualizar la produccion
			ls_expresion = 'co_fabrica = ' + String(lds_barras.GetItemNumber(ll_n,'co_fabrica_sim')) + ' and ' + &
								'co_planta = ' + String(lds_barras.GetItemNumber(ll_n,'co_planta')) + ' and ' + &
								'co_centro = ' + String(lds_barras.GetItemNumber(ll_n,'co_centro_pdn')) + ' and ' + &
								'co_subcentro = ' + String(lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn')) + ' and ' + &
								'co_modulo = ' + String(lds_barras.GetItemNumber(ll_n,'co_maquina')) 
								
			If lds_modulos_cambio.Find(ls_expresion ,1, lds_modulos_cambio.RowCount() + 1) <= 0 Then
				ll_m = lds_modulos_cambio.InsertRow(0)
				lds_modulos_cambio.SetItem(ll_m,'co_fabrica', lds_barras.GetItemNumber(ll_n,'co_fabrica_sim'))
				lds_modulos_cambio.SetItem(ll_m,'co_planta', lds_barras.GetItemNumber(ll_n,'co_planta'))
				lds_modulos_cambio.SetItem(ll_m,'co_centro', lds_barras.GetItemNumber(ll_n,'co_centro_pdn'))
				lds_modulos_cambio.SetItem(ll_m,'co_subcentro', lds_barras.GetItemNumber(ll_n,'co_subcentro_pdn'))
				lds_modulos_cambio.SetItem(ll_m,'co_modulo', lds_barras.GetItemNumber(ll_n,'co_maquina'))
			End if
			
			//consulta si ya existe el pedido de sobrantes en dt_arbol_pedido
			ll_n = lds_arbol_consulta.Of_Retrieve(ll_pedido, lds_ped_ref.GetItemNumber(ll_aux,'co_fabrica_ref'), &
															lds_ped_ref.GetItemNumber(ll_aux,'co_linea'), &
															lds_ped_ref.GetItemNumber(ll_aux,'co_referencia'))
			
			//no encuentra datos
			If ll_n = 0 Then
				//consulta el pedido origen en dt_arbol_pedido
				ll_n = lds_arbol_consulta.Of_Retrieve(ll_pedido_ant, lds_ped_ref.GetItemNumber(ll_aux,'co_fabrica_ref'), &
																lds_ped_ref.GetItemNumber(ll_aux,'co_linea'), &
																lds_ped_ref.GetItemNumber(ll_aux,'co_referencia'))
				
				//encuentra datos
				If ll_n > 0 Then
					//inserta la barra nueva
					lds_arbol_consulta.RowsCopy(ll_n, ll_n, Primary!, lds_arbol_pedido, lds_arbol_pedido.RowCount() + 1, Primary!)
					
					ll_n = lds_arbol_pedido.RowCount()
					//coloca el pedido hijo como el pedido de sobrantes
					lds_arbol_pedido.SetItem(ll_n,'pedido_hijo',ll_pedido)
					lds_arbol_pedido.SetItem(ll_n,'fe_creacion',ldt_fecha)
					lds_arbol_pedido.SetItem(ll_n,'fe_actualizacion',ldt_fecha)
					lds_arbol_pedido.SetItem(ll_n,'usuario',gstr_info_usuario.codigo_usuario)
					lds_arbol_pedido.SetItem(ll_n,'instancia', gstr_info_usuario.instancia)
				ElseIf ll_n < 0 Then
					Rollback; 
					MessageBox('Advertencia','Se encontro un inconveniente al consultar dt_arbol_pedido para el pedido y referencia de produccion.')
					Destroy lds_cliente_grupo_sobrantes
					Destroy lds_bongos_sobrantes
					Destroy lds_grupo
					Destroy lds_ped_ref
					Destroy lds_peddig
					Destroy lds_pedpend_exp
					Destroy lds_modulos_cambio
					Destroy lds_barras 
					Destroy lds_arbol_pedido
					Destroy lds_barra_consulta
					Destroy lds_arbol_consulta
					Return -1 
				End if
			ElseIf ll_n < 0 Then
				Rollback; 
				MessageBox('Advertencia','Se encontro un inconveniente al consultar dt_arbol_pedido para el pedido y referencia de produccion para el grupo de sobrantes.')
				Destroy lds_cliente_grupo_sobrantes
				Destroy lds_bongos_sobrantes
				Destroy lds_grupo
				Destroy lds_ped_ref
				Destroy lds_peddig
				Destroy lds_pedpend_exp
				Destroy lds_modulos_cambio
				Destroy lds_barras 
				Destroy lds_arbol_pedido
				Destroy lds_barra_consulta
				Destroy lds_arbol_consulta
				Return -1 
			End if
							
		ElseIf ll_n < 0 Then
			Rollback; 
			MessageBox('Advertencia','Se encontro un inconveniente al consultar la barra de Pdp confeccion  el pedido y la referencia de produccion para el grupo de sobrantes.')
			Destroy lds_cliente_grupo_sobrantes
			Destroy lds_bongos_sobrantes
			Destroy lds_grupo
			Destroy lds_ped_ref
			Destroy lds_peddig
			Destroy lds_pedpend_exp
			Destroy lds_modulos_cambio
			Destroy lds_barras 
			Destroy lds_arbol_pedido
			Destroy lds_barra_consulta
			Destroy lds_arbol_consulta
			Return -1 
		End if
	Next
	
	//realiza la actualizacion del pdp
	If lds_barras.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar la barra en el pdp confeccion con el pedido de sobrantes.')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Destroy lds_barra_consulta
		Destroy lds_arbol_consulta
		Return -1 
	End if
	
	//realiza la actualizacion del dt_arbol_pedido
	If lds_arbol_pedido.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar dt_arbol_pedido con el pedido de sobrantes.')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Destroy lds_barra_consulta
		Destroy lds_arbol_consulta
		Return -1 
	End if
	
	//se actualiza la produccion en el pdp
	For ll_n = 1 to lds_modulos_cambio.RowCount()
		lstr_parametros.entero[1] = lds_modulos_cambio.GetItemNumber(ll_n,'co_modulo') 
		
		If lnvo_simulacion.of_recalcular( lstr_parametros, lds_modulos_cambio.GetItemNumber(ll_n,'co_fabrica') , lds_modulos_cambio.GetItemNumber(ll_n,'co_planta') , &
			lds_modulos_cambio.GetItemNumber(ll_n,'co_centro'),  lds_modulos_cambio.GetItemNumber(ll_n,'co_subcentro') , 1, 0, Date(ldt_fecha)) < 0 Then
			
			Rollback;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n',"Ocurrio un inconveniente al actualizar la producci$$HEX1$$f300$$ENDHEX$$n en PDP de confeccion con la informacion del bongo de sobrantes en la fabrica " + &
								String(lds_modulos_cambio.GetItemNumber(ll_n,'co_fabrica')) + " planta " + String(lds_modulos_cambio.GetItemNumber(ll_n,'co_planta')))
			
			Destroy lds_cliente_grupo_sobrantes
			Destroy lds_bongos_sobrantes
			Destroy lds_grupo
			Destroy lds_ped_ref
			Destroy lds_peddig
			Destroy lds_pedpend_exp
			Destroy lds_modulos_cambio
			Destroy lds_barras 
			Destroy lds_arbol_pedido
			Destroy lds_barra_consulta
			Destroy lds_arbol_consulta
			Return -1 
		End if
	Next
		
	Destroy lds_modulos_cambio
	Destroy lds_barra_consulta
	Destroy lds_arbol_consulta
	
	//realiza las actualizaciones
	If lds_bongos_sobrantes.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar los bongos con el pedido de sobrantes.')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Return -1 
	End if
	
	If lds_grupo.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar el grupo de sobrantes.')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Return -1 
	End if
	
	If lds_peddig.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar el encabezado del pedido de sobrantes.')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Return -1 
	End if
	
	If lds_pedpend_exp.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar el detalle del pedido de sobrantes.')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Return -1 
	End if
	
	If lds_cliente_grupo_sobrantes.of_Update() <= 0 Then
		Rollback; 
		MessageBox('Advertencia','Ocurrio un inconveniente al actualizar el cliente para la creacion de grupos de sobrantes')
		Destroy lds_cliente_grupo_sobrantes
		Destroy lds_bongos_sobrantes
		Destroy lds_grupo
		Destroy lds_ped_ref
		Destroy lds_peddig
		Destroy lds_pedpend_exp
		Destroy lds_barras 
		Destroy lds_arbol_pedido
		Return -1 
	End if
	
ElseIf ll_aux < 0 Then
	Rollback; 
	MessageBox('Advertencia','Se encontro un inconveniente al buscar los bongos para revisar si crea grupo nuevo.')
	Destroy lds_bongos_sobrantes
	Return -1 
End if
			

Destroy lds_cliente_grupo_sobrantes
Destroy lds_bongos_sobrantes
Destroy lds_grupo
Destroy lds_ped_ref
Destroy lds_peddig
Destroy lds_pedpend_exp
Destroy lds_barras 
Destroy lds_arbol_pedido
Return 1
end function

public function long of_marcar_bolsa_pdccon (long al_bongo, string as_canasta);STRING	ls_bongo

ls_bongo = string(al_bongo)


//se marca la bolsa como producion, esto por si inicialmente la leyeron como sobrante
//agosto17 -2012 realiza jorodrig
UPDATE h_canasta_corte
SET (sw_origen, ob_ordprod) = ('', '')
WHERE cs_canasta = :as_canasta;
IF sqlca.sqlcode = -1 Then
	ROLLBACK;
	MessageBox('Error','Marcando el bongo como pdccion',StopSign!)
	Return -1
ELSE
	COMMIT;
	dw_maestro.Modify("t_sobrante.Text=''")
	dw_maestro.SetItem(1,'sw_origen','')
END IF 

Return 1
end function

public function long wf_leerconstantes (readonly string as_constante, readonly string as_error);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : wf_leerConstantes
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes 	luo_constantes

luo_constantes = Create n_cts_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

public function long wf_leerconstantescorte (readonly string as_constante, readonly string as_error);/********************************************************************
SA53802 - Ceiba/JJ - 29-10-2015 FunctionName : wf_leerConstantesCorte
<DESC> Description</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
Long					ll_retorno
Constant Long		ERROR_LEC = -1 , EXITO_LEC = 1
n_cts_constantes_corte 	luo_constantes

ll_retorno = luo_constantes.of_consultar_numerico(as_constante)
IF ll_retorno = ERROR_LEC THEN
	MessageBox('Error','Ocurrio un error al momento de validar '+as_error,StopSign!)
	Return ERROR_LEC
END IF

return ll_retorno 
end function

public subroutine wf_validaroc_x_op (readonly long al_oc);/********************************************************************
SA55269 - Ceiba/jjmonsal - 10-08-2016 FunctionName : wf_ValidarOC_x_Op
<DESC> Description: Validar cuando est$$HEX1$$e100$$ENDHEX$$n loteando una orden de corte, puede pasar que en otro modulo empiecen a lotear otra orden de corte de la misma orden de produccion</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
<ARGS> as_Arg1: Description as_Arg2: Description</ARGS> 
<USAGE> How to use this function.</USAGE>
********************************************************************/
String				ls_mensaje
Long					ll_fila, ll_filas
uo_adm_recursos	luo_adm_recursos
uo_dsbase			lds_validarOC_x_op
Transaction			ltr_temp

Try
	luo_adm_recursos		= Create uo_adm_recursos
	lds_validarOC_x_op	= Create uo_dsbase
	
	lds_validarOC_x_op.dataobject='d_gr_sq_validar_oc_lotear'
	ltr_temp = luo_adm_recursos.of_get_transaccion_sucia( )
	lds_validarOC_x_op.settransobject(ltr_temp)
	ll_filas = lds_validarOC_x_op.of_Retrieve(al_oc)
		
	IF ll_filas > 0 THEN	
		FOR ll_fila=1 TO ll_filas
			ls_mensaje += "O.C: "+String(lds_validarOC_x_op.getItemNumber(ll_fila,'cs_asignacion'))+ "~t Modulo: "+ String(lds_validarOC_x_op.getItemNumber(ll_fila,'co_modulo'))+""
			ls_mensaje += "~r~n"
		NEXT
		MessageBox('Hay Ordenes de Corte de la misma Orden de Producci$$HEX1$$f300$$ENDHEX$$n en otro(s) modulo',ls_mensaje)
	END IF 
	Destroy(luo_adm_recursos)
	Destroy(lds_validarOC_x_op)
	Destroy(ltr_temp)
CATCH(Throwable ex1)
	Destroy(luo_adm_recursos)
	Destroy(lds_validarOC_x_op)
	Destroy(ltr_temp)
	Messagebox("Error al Validar O.C de la misma Orden de Producci$$HEX1$$f300$$ENDHEX$$n", ex1.getmessage(), StopSign!)
End Try
end subroutine

on w_lectura_bolsa.create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.cb_4=create cb_4
this.dw_1=create dw_1
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_sobrante=create cb_sobrante
this.cb_1=create cb_1
this.dw_adhesivos=create dw_adhesivos
this.sle_parte=create sle_parte
this.dw_detalle=create dw_detalle
this.dw_maestro=create dw_maestro
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_4,&
this.dw_1,&
this.cbx_2,&
this.cbx_1,&
this.cb_3,&
this.cb_2,&
this.cb_sobrante,&
this.cb_1,&
this.dw_adhesivos,&
this.sle_parte,&
this.dw_detalle,&
this.dw_maestro,&
this.gb_1,&
this.gb_2}
end on

on w_lectura_bolsa.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.dw_1)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_sobrante)
destroy(this.cb_1)
destroy(this.dw_adhesivos)
destroy(this.sle_parte)
destroy(this.dw_detalle)
destroy(this.dw_maestro)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;This.x = 1
This.y = 1

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

dw_maestro.SetTransObject(sqlca)
dw_detalle.SetTransObject(sqlca)
dw_adhesivos.SetTransObject(sqlca)

ib_bongo = False
ii_validar = 0

dw_maestro.InsertRow(0)
dw_maestro.SetFocus()

ids_unid_sobrantes_loteo = Create uo_dsbase
ids_unid_sobrantes_loteo.DataObject = 'ds_unid_sobrantes_loteo'
ids_unid_sobrantes_loteo.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

dw_1.InsertRow(0)


end event

event close;Destroy ids_unid_sobrantes_loteo
end event

type cb_4 from commandbutton within w_lectura_bolsa
integer x = 1184
integer y = 1472
integer width = 146
integer height = 84
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "test"
end type

event clicked;
//n_cst_bolsa lpo_bolsa



//IF lpo_bolsa.of_actualizar_bolsa( 883640, '3085779625', 221511197, 2, 2, 8, '2531601', 3, 1, 1, 14, 0) = -1 THEN
//	Rollback;
//	Return
//END IF
//commit;


// lpo_loteo.of_act_pdp_corte(ll_ordencorte) 

n_cst_loteo_bongo lpo_loteo

LOng ll_ordencorte = 910681

//se realiza la modificacion en el Pdp de confeccion con la orden corte
IF lpo_loteo.of_actualiza_pdp_confeccion_x_oc(ll_ordencorte) < 0 THEN
	Rollback;
	Return
END IF

// consulta y crea barras en el pdp confeccion de los bongos loteados que tuvieron inconvenientes anteriormente
IF lpo_loteo.of_crea_bongos_loeados_pdp_confeccion() < 0 THEN
END IF

// FACL - 2019/02/25 - SA59605 - Se Ubica automaticamente los bongos loteados
IF lpo_loteo.of_Ubicar_Auto_Bongo_Loteado(ll_ordencorte) < 0 THEN
END IF


rollback;
end event

type dw_1 from datawindow within w_lectura_bolsa
event ue_presiona_tecla pbm_dwnkey
integer x = 183
integer y = 544
integer width = 841
integer height = 96
integer taborder = 110
string title = "none"
string dataobject = "d_gr_campo_parte"
boolean border = false
boolean livescroll = true
end type

event ue_presiona_tecla;

IF Key <> KeyEnter! and Key <> Keytab!  THEN
	ii_cont_fec_entrada ++
	it_entrada_teclado[ii_cont_fec_entrada] = now()
Else
	This.AcceptText()
End if


return 1
end event

event itemchanged;//
String ls_parte, ls_bolsa_padre, ls_bolsa, ls_chequeo
Long li_fila,li_paso,li_marca, li_co_subcentro, li_preparacion, li_digito_chequeo
Long ll_parte,ll_bolsa, ll_bolsa_padre, ll_ordencorte, ll_bongo, ll_n
Decimal{2} ldc_ca_actual
Dec{5} ldc_dif
n_cts_constantes luo_constantes
n_cst_bolsa lpo_bolsa
Time lt_entrada_teclado[]

luo_constantes = Create n_cts_constantes


IF gstr_info_usuario.codigo_usuario = 'jorodrig' THEN
ELSE
If trim(data) = '' or Isnull(data) Then Return 2


If ii_cont_fec_entrada > 1 Then
	For ll_n = 2 to ii_cont_fec_entrada
		ldc_dif = Dec(string(it_entrada_teclado[ll_n], 'ss.fffff'))- Dec(string(it_entrada_teclado[ll_n - 1], 'ss.fffff') )
		
		If ldc_dif > 5000 Then
			Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Entrada invalida por teclado')
			ii_cont_fec_entrada = 0
			it_entrada_teclado = lt_entrada_teclado
			This.Post SetItem(1,'parte','')
			Return 2
		End if
	Next
Else
	Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Entrada invalida por teclado')
	ii_cont_fec_entrada = 0
	it_entrada_teclado = lt_entrada_teclado
	This.Post SetItem(1,'parte','')
	Return 2
End if

END IF

ls_parte = data //sle_parte.Text

li_preparacion = luo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
IF li_preparacion = -1 THEN
	Rollback;
	MessageBox('Error','Ocurrio un error al momento de validar el subcentro de preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	ii_cont_fec_entrada = 0
	it_entrada_teclado = lt_entrada_teclado
	This.Post SetItem(1,'parte','')
	Return 2
END IF

ls_chequeo = Mid(String(ls_parte),1,2)

//mira si toma el codigo anterior
If cbx_1.Checked = True Then
	ls_bolsa 		= Mid(String(ls_parte),1,7)
	ls_parte 		= Mid(String(ls_parte),8)
Else
	ls_bolsa 		= Mid(String(ls_parte),3,7) //Mid(String(ls_parte),1,7)
	ls_parte 		= Mid(String(ls_parte),10) //Mid(String(ls_parte),8)
End if
ls_bolsa_padre = dw_maestro.GetItemString(1,'bolsa')
ll_parte 		= Long(ls_parte)
al_parte 		= Long(ls_parte)
ll_bolsa 		= Long(ls_bolsa)
ll_bolsa_padre = Long(ls_bolsa_padre)
ldc_ca_actual 	= dw_maestro.GetItemNumber(1,'unidad_bolsa')

li_digito_chequeo = Long(ls_chequeo)

//verificar que cada orden de produccion de la orden de corte tenga un bongo  agosto 29 - 2011 jorodrig
ll_ordencorte 	= dw_maestro.GetitemNumber(1,'orden_corte')
ll_bongo 		= dw_maestro.GetitemNumber(1,'bongo')

IF lpo_bolsa.of_validar_bongo_x_pedido(ls_bolsa_padre,ll_ordencorte,ll_bongo) = -1 Then
	sle_parte.text = ''
	ii_cont_fec_entrada = 0
	it_entrada_teclado = lt_entrada_teclado
	This.Post SetItem(1,'parte','')
	Return 2
END IF
//


//no solo se debe verificar que la parte pertenezca a la bolsa si no que tambien sea de la misma bolsa.
IF ll_bolsa_padre = ll_bolsa THEN

	FOR li_fila = 1 TO dw_detalle.RowCount()
		//se tiene en cuenta el digito de chequeo si esta usando el codigo nuevo 
		IF ll_parte = dw_detalle.GetItemNumber(li_fila,'co_parte') and & 
			(li_digito_chequeo = Long(dw_detalle.GetItemString(li_fila,'dig_chequeo') ) or cbx_1.Checked = True ) THEN
			//marcamos la fila
			dw_detalle.SetItem(li_fila,'marca',1)
//			sle_parte.text = ''
//			sle_parte.SetFocus()
			dw_1.Post SetItem(1,'parte','')
			dw_1.SetFocus()
			li_paso = 1
			li_co_subcentro = dw_detalle.GetItemNumber(li_fila,'co_subcentro')
			IF (li_co_subcentro <> li_preparacion) AND li_co_subcentro > 0 THEN
				MessageBox('Advertencia','Tenga presente que la parte digita tiene un proceso especial asociado.',Information!)
			END IF
		END IF
	NEXT
	IF li_paso = 0 THEN
		MessageBox('Error','la parte ingresada no pertenece a esta bolsa.',StopSign!)
		sle_parte.text = ''
		ii_cont_fec_entrada = 0
		it_entrada_teclado = lt_entrada_teclado
		This.Post SetItem(1,'parte','')
		Return 2
	END IF
ELSE
	MessageBox('Error','la parte ingresada no pertenece a esta bolsa. ',StopSign!)
	sle_parte.text = ''
	ii_cont_fec_entrada = 0
	it_entrada_teclado = lt_entrada_teclado
	This.Post SetItem(1,'parte','')
	Return 2
END IF

//si es la ultima parte de la bolsa se dispara el evento de grabar
FOR li_fila = 1 TO dw_detalle.RowCount()
	li_marca = dw_detalle.GetItemNumber(li_fila,'marca')
	IF li_marca = 0 THEN
		ii_cont_fec_entrada = 0
		it_entrada_teclado = lt_entrada_teclado
		This.Post SetItem(1,'parte','')
		Return 2
	END IF
NEXT

IF dw_detalle.RowCount() > 0 THEN
	w_lectura_bolsa.TriggerEvent("ue_grabar")
ELSE
END IF

ii_cont_fec_entrada = 0
it_entrada_teclado = lt_entrada_teclado
This.Post SetItem(1,'parte','')
	

end event

type cbx_2 from checkbox within w_lectura_bolsa
boolean visible = false
integer x = 1120
integer y = 592
integer width = 421
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Codigo Nuevo"
boolean checked = true
end type

event clicked;
//mira si esta selccionado para quitar la otra opcion 
If cbx_2.Checked = True Then
	cbx_1.Checked = False
Else
	cbx_1.Checked = True
End if
end event

type cbx_1 from checkbox within w_lectura_bolsa
boolean visible = false
integer x = 1120
integer y = 532
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Codigo Anterior"
end type

event clicked;

//mira si esta selccionado para quitar la otra opcion 
If cbx_1.Checked = True Then
	cbx_2.Checked = False
Else
	cbx_2.Checked = True
End if
end event

type cb_3 from commandbutton within w_lectura_bolsa
integer x = 1605
integer y = 1476
integer width = 133
integer height = 84
integer taborder = 70
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clave"
end type

event clicked;STRING	ls_password, ls_password_ingresado
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte

ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD VER CODIGO PARTE'))
//dw_detalle.visible("dig_chequeo",1)

Open(w_password_trazos)
lstr_parametros = message.PowerObjectParm

If lstr_parametros.hay_parametros = true Then
	ls_password_ingresado = Trim(lstr_parametros.cadena[1])
				
	If ls_password_ingresado = ls_password Then
		//clave correcta, continua el proceso
		
		dw_detalle.Modify("dig_chequeo.Visible='1'")
	Else
		MessageBox('Error','Password, no valido.')
	
	End if
Else

End if

end event

type cb_2 from commandbutton within w_lectura_bolsa
integer x = 1541
integer y = 340
integer width = 192
integer height = 72
integer taborder = 50
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pdcion"
end type

event clicked;
LONG		ll_bongo, ll_retorno
STRING	ls_bolsa

dw_maestro.Accepttext()
ll_bongo	= dw_maestro.GetItemNumber(1,'bongo')
ls_bolsa = dw_maestro.GetItemString(1,'bolsa')

// stvalencia 2022-04-06 validamos que la bolsa tenga estado 10(sin lotear)
datastore lds_estado_bolsa
lds_estado_bolsa = CREATE datastore
lds_estado_bolsa.DataObject = "d_gr_estado_bolsa_x_cana"
lds_estado_bolsa.SetTransObject (SQLCA)
ll_retorno = lds_estado_bolsa.Retrieve(ls_bolsa)
IF ll_retorno <= 0 then
	MessageBox('Advertencia','No se puedo validar la bolsa')
	Return
else
	IF lds_estado_bolsa.GetItemNumber(1,"co_estado") <> 10 then
		MessageBox('Advertencia','La bolsa ya fue loteada')
		Return
	end if
end if

IF IsNull(ll_bongo) THEN
	MessageBox('Advertencia','Pirmero debe seleccionar el bongo')
	Return
END IF

IF of_marcar_bolsa_pdccon(ll_bongo,ls_bolsa) = -1 THEN
END IF

end event

type cb_sobrante from commandbutton within w_lectura_bolsa
integer x = 1298
integer y = 340
integer width = 233
integer height = 72
integer taborder = 30
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sobrante"
end type

event clicked;
LONG		ll_bongo, ll_retorno
STRING	ls_bolsa
datastore lds_estado_bolsa

dw_maestro.Accepttext()
ll_bongo	= dw_maestro.GetItemNumber(1,'bongo')
ls_bolsa = dw_maestro.GetItemString(1,'bolsa')

// stvalencia 2022-04-06 validamos que la bolsa tenga estado 10(sin lotear)
lds_estado_bolsa = CREATE datastore
lds_estado_bolsa.DataObject = "d_gr_estado_bolsa_x_cana"
lds_estado_bolsa.SetTransObject (SQLCA)
ll_retorno = lds_estado_bolsa.Retrieve(ls_bolsa)
IF ll_retorno <= 0 then
	MessageBox('Advertencia','No se puedo validar la bolsa')
	Return
else
	IF lds_estado_bolsa.GetItemNumber(1,"co_estado") <> 10 then
		MessageBox('Advertencia','La bolsa ya fue loteada')
		Return
	end if
end if

IF IsNull(ll_bongo) THEN
	MessageBox('Advertencia','Primero debe seleccionar el bongo')
	Return
END IF

IF of_marcar_bongo_sobras(ll_bongo,ls_bolsa) = -1 THEN
END IF

end event

type cb_1 from commandbutton within w_lectura_bolsa
integer x = 1600
integer y = 264
integer width = 123
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;Long ll_recipiente
n_cst_loteo_bongo luo_loteo


//Choose Case dwo.Name
//	Case "p_bongo"
		ll_recipiente = luo_loteo.of_generarconsecutivobongo()
		If ll_recipiente > 0 Then
			//se debe colocar el numero del bongo en la ventana de loteo.
			dw_maestro.SetItem(1,'bongo',ll_recipiente)
			ib_bongo = True
		End if
//End Choose
end event

type dw_adhesivos from datawindow within w_lectura_bolsa
boolean visible = false
integer x = 46
integer y = 1504
integer width = 73
integer height = 64
integer taborder = 80
string title = "none"
string dataobject = "dtb_adhesivos_bongo_new_colores"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_parte from singlelineedit within w_lectura_bolsa
boolean visible = false
integer x = 329
integer y = 448
integer width = 731
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_parte, ls_bolsa_padre, ls_bolsa, ls_chequeo
Long li_fila,li_paso,li_marca, li_co_subcentro, li_preparacion, li_digito_chequeo
Long ll_parte,ll_bolsa, ll_bolsa_padre, ll_ordencorte, ll_bongo
Decimal{2} ldc_ca_actual

n_cts_constantes luo_constantes
n_cst_bolsa lpo_bolsa
luo_constantes = Create n_cts_constantes
ls_parte = sle_parte.Text

li_preparacion = luo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
IF li_preparacion = -1 THEN
	Rollback;
	MessageBox('Error','Ocurrio un error al momento de validar el subcentro de preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
	Return 
END IF

ls_chequeo = Mid(String(ls_parte),1,2)

//mira si toma el codigo anterior
If cbx_1.Checked = True Then
	ls_bolsa 		= Mid(String(ls_parte),1,7)
	ls_parte 		= Mid(String(ls_parte),8)
Else
	ls_bolsa 		= Mid(String(ls_parte),3,7) //Mid(String(ls_parte),1,7)
	ls_parte 		= Mid(String(ls_parte),10) //Mid(String(ls_parte),8)
End if
ls_bolsa_padre = dw_maestro.GetItemString(1,'bolsa')
ll_parte 		= Long(ls_parte)
al_parte 		= Long(ls_parte)
ll_bolsa 		= Long(ls_bolsa)
ll_bolsa_padre = Long(ls_bolsa_padre)
ldc_ca_actual 	= dw_maestro.GetItemNumber(1,'unidad_bolsa')

li_digito_chequeo = Long(ls_chequeo)

//verificar que cada orden de produccion de la orden de corte tenga un bongo  agosto 29 - 2011 jorodrig
ll_ordencorte 	= dw_maestro.GetitemNumber(1,'orden_corte')
ll_bongo 		= dw_maestro.GetitemNumber(1,'bongo')

IF lpo_bolsa.of_validar_bongo_x_pedido(ls_bolsa_padre,ll_ordencorte,ll_bongo) = -1 Then
	sle_parte.text = ''
	Return
END IF
//


//no solo se debe verificar que la parte pertenezca a la bolsa si no que tambien sea de la misma bolsa.
IF ll_bolsa_padre = ll_bolsa THEN

	FOR li_fila = 1 TO dw_detalle.RowCount()
		//se tiene en cuenta el digito de chequeo si esta usando el codigo nuevo 
		IF ll_parte = dw_detalle.GetItemNumber(li_fila,'co_parte') and & 
			(li_digito_chequeo = Long(dw_detalle.GetItemString(li_fila,'dig_chequeo') ) or cbx_1.Checked = True ) THEN
			//marcamos la fila
			dw_detalle.SetItem(li_fila,'marca',1)
			sle_parte.text = ''
			sle_parte.SetFocus()
			li_paso = 1
			li_co_subcentro = dw_detalle.GetItemNumber(li_fila,'co_subcentro')
			IF (li_co_subcentro <> li_preparacion) AND li_co_subcentro > 0 THEN
				MessageBox('Advertencia','Tenga presente que la parte digita tiene un proceso especial asociado.',Information!)
			END IF
		END IF
	NEXT
	IF li_paso = 0 THEN
		MessageBox('Error','la parte ingresada no pertenece a esta bolsa.',StopSign!)
		sle_parte.text = ''
		Return
	END IF
ELSE
	MessageBox('Error','la parte ingresada no pertenece a esta bolsa. ',StopSign!)
	sle_parte.text = ''
	Return
END IF

//si es la ultima parte de la bolsa se dispara el evento de grabar
FOR li_fila = 1 TO dw_detalle.RowCount()
	li_marca = dw_detalle.GetItemNumber(li_fila,'marca')
	IF li_marca = 0 THEN
		Return
	END IF
NEXT

IF dw_detalle.RowCount() > 0 THEN
	w_lectura_bolsa.TriggerEvent("ue_grabar")
ELSE
END IF

end event

type dw_detalle from datawindow within w_lectura_bolsa
integer x = 110
integer y = 668
integer width = 1618
integer height = 784
string title = "none"
string dataobject = "dtb_detalle_lectura_bolsas"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_maestro from datawindow within w_lectura_bolsa
event ue_presionar_tecla pbm_dwnkey
integer x = 78
integer y = 76
integer width = 1650
integer height = 360
integer taborder = 10
string title = "none"
string dataobject = "dff_maestro_lectura_bolsas"
boolean border = false
boolean livescroll = true
end type

event ue_presionar_tecla;//Long li_columnas, li_num_col, li_sigte_col
//Long ll_filas, ll_fila_actual
//
//IF Key = KeyEnter! THEN
//	li_columnas = Long(This.Object.DataWindow.Column.Count)
//	li_num_col = This.GetColumn()
//	IF li_columnas = li_num_col THEN
//	ELSE
//		li_sigte_col = This.GetColumn() + 1
//		IF li_sigte_col = 2 THEN
//			li_sigte_col = This.GetColumn() + 2
//		END IF
//		//TriggerEvent(Itemchanged!)
//	END IF
//	Return(1)
//END IF
end event

event doubleclicked;s_base_parametros lstr_parametros
Long ll_ordencorte
String	ls_bolsa, ls_po_agrupada
n_cst_bolsa lpo_bolsa

If This.AcceptText() <> 1 Then Return

Choose Case Dwo.Name
	Case 'po'
		//despliego las P.O. para la orden de corte, permitiendo al usuario seleccionar con la que quiere trabajar
		ll_ordencorte = This.GetItemNumber(1,'orden_corte')
		lstr_parametros.entero[1] = ll_ordencorte
		
		// FACL - 2021/01/29 - SA60509 - Se invoca la ventana de buscar PO de agrupacion
		OpenWithParm ( w_buscar_po_agrupacion, lstr_parametros)
		lstr_parametros = message.PowerObjectParm	
		If lstr_parametros.hay_parametros Then
			dw_maestro.SetItem(1,'po_agrupada', lstr_parametros.cadena[2] )
			dw_maestro.SetItem(1,'pedido', lstr_parametros.entero[1] )
			dw_maestro.SetItem(1,'po',lstr_parametros.cadena[1])
		Else
			OpenWithParm ( w_buscar_po, lstr_parametros)
			lstr_parametros = message.PowerObjectParm	
			
			If lstr_parametros.hay_parametros Then
				dw_maestro.SetItem(1,'po_agrupada', '' )
				dw_maestro.SetItem(1,'pedido', 0 )
				dw_maestro.SetItem(1,'po',lstr_parametros.cadena[1])
			End if
		End If
		
	case 'subcentro'
		//despliego los subcentros para el centro de corte
		Open(w_buscar_subcentros)
		lstr_parametros = message.PowerObjectParm	
		
		If lstr_parametros.hay_parametros Then
			dw_maestro.SetItem(1,'de_subcentro',lstr_parametros.cadena[1])
			dw_maestro.SetItem(1,'subcentro',lstr_parametros.entero[1])
		End if
		
	Case 'bongo'
		lstr_parametros.entero[1] = This.GetItemNumber(1,'orden_corte')
		lstr_parametros.cadena[1] = This.GetItemString(1,'po')
		
		OpenWithParm(w_buscar_recipientes, lstr_parametros)
		
		lstr_parametros = message.PowerObjectParm	
		If lstr_parametros.hay_parametros Then
			dw_maestro.SetItem(1,'bongo',Long(Trim(lstr_parametros.cadena[1])))
			ib_bongo = True
		End if
		
		//verificar que cada orden de produccion de la orden de corte tenga un bongo  agosto 29 - 2011 jorodrig
		ls_bolsa = This.GetItemString(1,'bolsa')
		ll_ordencorte = This.GetItemNumber(1,'orden_corte')
		ls_po_agrupada = Trim( This.GetItemString(1,'po_agrupada' ) )
		If ls_po_agrupada <> '' Then
		Else
			IF lpo_bolsa.of_validar_bongo_x_pedido(ls_bolsa,ll_ordencorte,Long(Trim(lstr_parametros.cadena[1]))) = -1 Then
				This.SetItem(row,'bongo',0)
				This.SetColumn('bongo')
				Return 2
			END IF
		End If

		
end choose
end event

event itemchanged;/***********************************************************
SA53802 - Ceiba/JJ - 29-10-2015
Comentario: Se lee la constante MENS_LOTEO_CONF, TIPO PRENDAS y CONFECCION
***********************************************************/
Long li_subcentro, li_tipo, li_centro, li_fab, li_planta,li_result, li_preparacion, li_despachos, &
			li_extendido, net, li_cpto_critica, li_estado_asigna, li_loteoConf, ll_nulo
String ls_subcentro, ls_po, ls_bolsa, ls_modulo, ls_de_modulo, ls_mensaje, ls_sw_origen, ls_ordenes, ls_po_oc
Long ll_ordencorte, ll_bongo, ll_count, ll_modulo, ll_unir_oc, ll_datos, ll_centro_pdn, ll_n, ll_ret
Long ll_existe_oc_primera_vez, ll_oc_primera_vez, ll_op, ll_colores[],ll_filas, ll_pedido
Decimal{2}ldc_ca_actual

n_cst_bolsa 				lpo_bolsa
n_cst_modulo 				lpo_modulo
n_cts_ocfabrica 			luo_oc
n_cts_constantes 			luo_constantes
s_base_parametros 		lstr_parametros
n_cst_orden_corte 		luo_corte
n_cst_loteo_bongo 		lpo_loteo
uo_dsbase 					lds_unid_sobrantes_loteo
uo_dsbase lds_oc, lds_op_sin_riel
n_cst_funciones_comunes lnvo_funcion
//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro

SetNull(ll_nulo)
//This.AcceptText()
dw_detalle.Modify("dig_chequeo.Visible='0'")
luo_constantes = Create n_cts_constantes

Choose case GetColumnName()
	case 'subcentro'
		li_subcentro = Long(Data) //This.GetItemNumber(1,'subcentro')
		
		li_tipo 			= Long(Mid(String(li_subcentro),1,1))
		li_centro 		= Long(Mid(String(li_subcentro),2,2))
		li_subcentro 	= Long(Mid(String(li_subcentro),4))
				
		SELECT de_subcentro_pdn
		  INTO :ls_subcentro
		  FROM m_subcentros_pdn
		 WHERE m_subcentros_pdn.co_tipoprod   		= :li_tipo AND
		       m_subcentros_pdn.co_centro_pdn 		= :li_centro AND
				 m_subcentros_pdn.co_subcentro_pdn 	= :li_subcentro;
				 
		If sqlca.sqlcode <> 0 Then		
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de establecer el subcentro.',StopSign!)
			Return 2
		Else
			dw_maestro.SetItem(1,'de_subcentro',ls_subcentro)
			dw_maestro.SetItem(1,'subcentro',li_subcentro)
		End if
		
		This.SetColumn('modulo')	
				
	case 'bongo'
		//primero se verifica que el bongo no halla sido ingresado manualmente.
		IF ib_bongo = False Then
			MessageBox('Advertencia','El n$$HEX1$$fa00$$ENDHEX$$mero del recipiente no puede ser digitado, debe seleccionarse.',StopSign!)
			This.SetItem(row,'bongo',0)
			Return 1
		ELSE
			ib_bongo = False
		END IF
		
		//validacion de bongo
		ll_ordencorte 	= This.GetItemNumber(1,'orden_corte')
		
		IF isnull(ll_ordencorte) THEN
			MessageBox('Advertencia','Antes de verificar el recipiente es necesario ingresar la orden de corte.',Information!)
			Return 2
		END IF
		ls_po = This.GetItemString(1,'po')
		
		ll_bongo 		= Long(Data) //This.GetItemNumber(1,'bongo')
		li_fab 			= Long(Mid ( string(ll_bongo), 1 , 1 ))
		li_planta 		= Long(Mid ( string(ll_bongo), 2 , 1 ))
		ls_po = This.GetItemString(1,'po')
		
			
		If lpo_bolsa.of_validar_bongo(ll_ordencorte,ll_bongo,li_fab,li_planta,ls_po, ii_fabrica, ii_linea, il_referencia ) = -1 Then
			//This.SetItem(row,'bongo',0)
			This.SetColumn('bongo')
			Return 1
		END IF
		
		//verificar que cada orden de produccion de la orden de corte tenga un bongo  agosto 29 - 2011 jorodrig
		ls_bolsa = This.GetItemString(1,'bolsa')
		IF lpo_bolsa.of_validar_bongo_x_pedido(ls_bolsa,ll_ordencorte,ll_bongo) = -1 Then
			// This.SetItem(row,'bongo',0)
			This.SetColumn('bongo')
			Return 2
		END IF

//		sle_parte.SetFocus()
		dw_1.SetFocus()
		
	case 'unidad_bolsa'
		//se verifica que la cantidad no sea mayor a la que exista en bd
		ll_ordencorte = This.GetItemNumber(1,'orden_corte')
		ls_bolsa = This.GetItemString(1,'bolsa')
		ll_bongo 		= This.GetItemNumber(1,'bongo')
		ldc_ca_actual = Long(Data) //This.GetItemNumber(1,'unidad_bolsa')
		
		//se comentarea por peticion de las personas del sue$$HEX1$$f100$$ENDHEX$$o de BTT octubre 29 de 2008
		IF ldc_ca_actual > idc_ca_actual THEN
			//puede ser una orden de corte de la bierrebi, las cuales pueden tener una consideracion
			//especial, estas son ingresadas en la tabla h_unid_mas_corte, por parte del jefe de
			//corte, unico con este permiso, para permitir lotear por encima, esto se hace por
			//peticion de Sthepan Reinner ya que cuando esto sucedia tenia que devolver los rollos
			//del 90 al 15 anular la liberacion y volver a generarla.
			//jcrm
			//julio 31 de 2008
			IF luo_corte.of_permiso_mas_loteo(ll_ordencorte) = 0 THEN
				Post MessageBox('Error','La cantidad ingresada no puede ser mayor a la preliquidada',StopSign!)
				//This.SetItem(Row,'unidad_bolsa',idc_ca_actual)
				Return 2 
			END IF
		END IF
				
		//validacion para solicitar usuario y concepto al momento de disminuir
		//las unidades de alguna bolsa
		//esto se pidio en el sue$$HEX1$$f100$$ENDHEX$$o del recipiente perfecto.
		//jcrm
		//abril 12 de 2007
		
		//se modifica por peticion de las personas del sue$$HEX1$$f100$$ENDHEX$$o de BTT octubre de 2008
		IF ldc_ca_actual <> idc_ca_actual THEN
		//IF ldc_ca_actual < idc_ca_actual THEN
			If of_ValidarConceptoUnidadesMenos(ll_ordencorte,ls_bolsa,ldc_ca_actual,idc_ca_actual) = -1 Then
				//This.SetItem(Row,'unidad_bolsa',idc_ca_actual)
				Return 2
			End if
		END IF	
		//si la orden de corte se corta en la calle se cargan todas las bolsas como leidas y se procede a
		//lotear la orden de corte
		//modificacion realizada por peticion de Edwin serna
		//jcrm
		//mayo 2 de 2008
		
		//se coloca en comentarios por problemas  detetados con Edwin Serna ya que no se habia previsto que existian casos
		//donde se debe trabajar la orden de manera normal aun cuando halla sido cortada en la calle.
		//jcrm
		//mayo 13 de 2008
		
//		li_result = lpo_bolsa.of_validar_centro_corte(ll_ordencorte,ls_mensaje)
		ii_centro_corte = 90
//		
//		IF li_result = 92 THEN
//			IF al_corte = 0 THEN
//				Net = MessageBox("Pregunta", 'La orden de corte figura como cortada en un tercero, desea que el sistema realice el loteo automaticamente, odesea leer bolsa a bolsa.', Exclamation!, OKCancel!, 2)
//				IF Net = 1 THEN
//					al_corte = ll_ordencorte
//					ii_centro_corte = li_result
//					//se procede a dar por leidas todas las bolsas de la orden de corte, para proceder a lotearlas
//					IF lpo_bolsa.of_cargar_bolsas_oc_calle(ll_ordencorte,String(ll_bongo),ls_mensaje) = -1 THEN
//						MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento actualizar las bolsas, ERROR: '+ls_mensaje,StopSign!)
//						Return
//					ELSE
//						//se actualizaron todas las bolsas de la orden de corte, se ejecuta el evento de grabar para que 
//						//se genere el loteo del recipiente
//						//MessageBox('Advertencia','La Orden de Corte, esta siendo cortada por un tercero, por lo tanto el sistema dara por leidas todas las bolsas y procedera a lotearlas.',Exclamation!)
//						TriggerEvent('ue_grabar')
//					END IF
//				ELSE
//					al_corte = 0
//				END IF
//			END IF
//		END IF
		//fin modificacion
	case 'bolsa'
		
		// stvalenc validar bolsa en estado 10
		ll_ordencorte = This.GetItemNumber(1,'orden_corte')
		ls_po = This.GetItemString(1,'po')
		ls_bolsa = Trim(Data) // This.GetItemString(1,'bolsa')
		
		IF isnull(ll_ordencorte) THEN
			MessageBox('Advertencia','Antes de verificar la bolsa es necesario ingresar la orden de corte.',Information!)
			Return 2
		END IF
		
		IF isnull(ls_po) THEN
			MessageBox('Advertencia','Antes de verificar la P.O. es necesario ingresar la orden de corte.',Information!)
			Return 2
		END IF
				
		
	   
		//******************************************************************
		//se verifica que la orden de corte se encuentre en preparacion 
		li_preparacion = wf_leerConstantes('SUBCENTRO PREPARACIO','el subcentro de preparaci$$HEX1$$f300$$ENDHEX$$n.')
		IF li_preparacion = -1 THEN Return  2
		
		li_despachos   = wf_leerConstantes('SUBCENTRO FIN CORTE','el subcentro de despachos.')
		IF li_despachos = -1 THEN Return 2		
		
		li_extendido   = wf_leerConstantes('SUBCENTRO EXTENDIDO','el subcentro de extendido.')
		IF li_extendido = -1 THEN Return  2				
				
		li_tipo = wf_leerConstantes('PRENDAS','el tipo de prenda.')
		IF li_tipo = -1 THEN Return 2
		
		li_centro = wf_leerConstantes('CENTRO CORTE','el centro de corte.')
		IF li_centro = -1 THEN Return 2
		
		/*// FACL - 2021/05/18 - ID530 - Si cambia de PO por agrupacion se toma la informacion de la PO destino
		If This.GetItemString(1,'po_agrupada' ) <> '' And Trim(This.GetItemString(1,'po' ))<>Trim(This.GetItemString(1,'po_agrupada' )) Then
			ll_pedido = This.GetItemNumber(1,'pedido' )
			
			uo_dsbase lds_bolsa_agr
			
			lds_bolsa_agr = Create uo_dsbase
			lds_bolsa_agr.DataObject = 'd_gr_consulta_bolsa_agrupacion'
			lds_bolsa_agr.SetTransObject( SQLCA )
			ll_filas = lds_bolsa_agr.Of_Retrieve( ls_bolsa, ll_pedido )
			
			If ll_filas > 0 Then			
				idc_ca_actual = lds_bolsa_agr.GetItemNumber( 1, 'ca_actual' )
				ii_fabrica = lds_bolsa_agr.GetItemNumber( 1, 'co_fabrica_ref' )
				ii_linea = lds_bolsa_agr.GetItemNumber( 1, 'co_linea' )
				il_referencia = lds_bolsa_agr.GetItemNumber( 1, 'co_referencia' )
				il_ca_pedida = lds_bolsa_agr.GetItemNumber( 1, 'ca_pedida' )
				il_ca_x_lotear = lds_bolsa_agr.GetItemNumber( 1, 'ca_x_lotear' )
				
				
				ls_po = This.GetItemString(1,'po_agrupada')
				
				If IsNull( il_ca_pedida ) Then
					MessageBox('Error','La bolsa no pertenece al pedido individual seleccionado!',StopSign!)
					//This.SetItem(row,'bolsa','0')
					Return 2
				End If
			ElseIf ll_filas = 0 Then
				MessageBox('Error','No se encontro informacion de la bolsa con agrupacion',StopSign!)
				Return 2
			Else
				MessageBox('Error','Ocurrio un error al consulta la bolsa con agrupacion',StopSign!)
				Return 2
			End If
		Else
		End If
			*/
			
		  //se conoce la cantida de la bolsa, los demas datos para validar donde se encuentra ubicada la orden	 
		  SELECT ca_actual, co_fabrica_ref, co_linea, co_referencia
			 INTO :idc_ca_actual, :ii_fabrica, :ii_linea, :il_referencia
			 FROM dt_canasta_corte
			WHERE cs_canasta 		= :ls_bolsa	AND
					cs_orden_corte 	= :ll_ordencorte ;
		il_ca_x_lotear = -1
			
		
		IF lpo_bolsa.of_validar_bolsa(ll_ordencorte,ls_po,ls_bolsa) = -1 THEN
			//This.SetItem(row,'bolsa','0')
			Return 2
		END IF

		
	 
	   SELECT MAX(co_subcentro_pdn)
		  INTO :li_subcentro
		  FROM dt_kamban_corte
		 WHERE cs_orden_corte 	= :ll_ordencorte and
				 co_tipoprod 		= :li_tipo and
				 co_centro_pdn 	= :li_centro and
				 co_fabrica       = :ii_fabrica and
				 co_linea         = :ii_linea and
				 co_referencia    = :il_referencia and	
				 fe_inicial 		is not null and
				 fe_final 			is null; 
				 
		IF sqlca.sqlcode = -1 Then
			MessageBox('Error','Ocurrio un error al momento de validar el subcentro',StopSign!)
			Return 2
		END IF
		
		IF li_subcentro = li_preparacion THEN
		ELSE
			IF li_subcentro = li_extendido THEN
				MessageBox('Error','La orden se encuentra en extendido, debe ser cargada a Preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
				Close(w_lectura_bolsa)
				Return 2
			ELSE
				//si se trata de un segundo loteo se debe verificar que la orden de corte no halla sido despachada
				SELECT count(cs_orden_corte)
				  INTO :ll_count
				  FROM dt_kamban_corte
				 WHERE cs_orden_corte 	= :ll_ordencorte and
						 co_tipoprod 		= :li_tipo and
						 co_centro_pdn 	= :li_centro and
						 co_subcentro_pdn = :li_despachos and 
						 co_fabrica       = :ii_fabrica and
						 co_linea         = :ii_linea and
						 co_referencia    = :il_referencia and	
						 fe_inicial 		is not null and
						 fe_final 			is not null; 
			
				IF ll_count > 0 THEN
					//se coloca en comentario, pues pasa con muchas ordenes que les tienen que hacer adiciones   abril7-10 jorodrig
			//		MessageBox('Error','La orden de corte ya fue despachada.',StopSign!)
			//		Close(w_lectura_bolsa)
			//		Return
				END IF
			END IF
		END IF
	   //************************************************************************
		If il_ca_x_lotear < idc_ca_actual And il_ca_x_lotear >= 0 Then
			dw_maestro.SetItem(1,'unidad_bolsa',il_ca_x_lotear)
		Else
			dw_maestro.SetItem(1,'unidad_bolsa',idc_ca_actual)
		End If
	 	
		//realizar retrieve solo por bolsa para quedar con las modificaciones hechas
		//por jose para la ficha
		dw_detalle.SetTransObject(sqlca)
		dw_detalle.Retrieve(ls_bolsa, ll_ordencorte)
		 
		li_subcentro = This.GetItemNumber(1,'subcentro')
		
		IF lpo_bolsa.of_cliente_linea_bolsa(ll_ordencorte,ls_bolsa,ls_po ) = 2 THEN
			//en este caso no se valida que parta el bongo en unidades de mas.  sept 14-2010
			ii_validar = 0
		END IF
		
		/*se cambia esta validacion porque se debe validar el corte por encima para todo 14/09/14*/
		//SA-54194 nfrancog 29/01/2016
		IF ii_validar = 1 THEN
		//IF ii_validar >= 0 THEN
			
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, Estoy verificando si con esta Orden se pasa las unidades de la P.O...."
			lstr_parametros_retro.cadena[3]="reloj"
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)    
						
			lds_unid_sobrantes_loteo = Create uo_dsbase
			lds_unid_sobrantes_loteo.DataObject = 'ds_unid_sobrantes_loteo'
			lds_unid_sobrantes_loteo.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
			
			ll_bongo = 0
			//verificar las unidades loteadas en la op  color - talla para mirar si esta
			//sobrepasando y  avisar al usuario
			//jorodrig feb 16-10
			//verifica si ya se marco la oc con sobrantes, no se vuelve a abrir la ventana 
			If ii_mostrar_sobrante = 1 Then
				//limpia el ds para guardar las unidades sobrantes
				If IsValid(ids_unid_sobrantes_loteo) Then
					ids_unid_sobrantes_loteo.Reset()
				End if
				// FACL - 2021/08/30 - ID530 - Si es un loteo agrupado se invoca la verificacion de sobrantes para agrupacion
				If This.GetItemString(1,'po_agrupada' ) <> '' Then
					ll_ret = lpo_loteo.of_Validar_Unid_Lotear_vs_PO_Agrupa(ll_ordencorte,ls_po,ii_fabrica,ii_linea,il_referencia,string(ll_bongo),lds_unid_sobrantes_loteo)
				Else
					ll_ret = lpo_loteo.of_validar_unid_lotear_vs_po(ll_ordencorte,ls_po,ii_fabrica,ii_linea,il_referencia,string(ll_bongo),lds_unid_sobrantes_loteo)
				End If
						
				If ll_ret < 0 Then
					CLOSE(w_retroalimentacion)
					Destroy lds_unid_sobrantes_loteo
					dw_detalle.Reset()
					Return 2
				ElseIF ll_ret = 1 THEN
					ll_datos = lds_unid_sobrantes_loteo.RowCount()
					IF ll_datos > 0 THEN
						lstr_parametros.ds_datos[1] = lds_unid_sobrantes_loteo
						OpenWithparm(w_unid_sobrantes_loteo,lstr_parametros)
						
						//aca se dede marcar la orden de corte como oc con bongo sobrante (campo co_estado_lote en h_ordenes_corte = 3)
						//con esto se valida que si armen un bongo con unidades sobrantes
						//jorodrig abril 23-2010
						IF f_marcar_oc_con_sobras(ll_ordencorte,3) = -1 THEN //oc con sobrantes
							CLOSE(w_retroalimentacion)
							Destroy lds_unid_sobrantes_loteo
							return 2
						END IF
						
						//guarda las unidades de sobrantes
						lds_unid_sobrantes_loteo.RowsCopy(1,lds_unid_sobrantes_loteo.RowCount(), Primary!, ids_unid_sobrantes_loteo, 1, Primary!)
					ELSE
						IF f_marcar_oc_con_sobras(ll_ordencorte,1) = -1 THEN	//oc sin sobrantes
							CLOSE(w_retroalimentacion)
							Destroy lds_unid_sobrantes_loteo
							return 2
						END IF
						
						//MessageBox('O.K.','Aun no se han cumplido las unidades de la PO, puede continuar sin problemas')
					END IF
				ELSE
					IF f_marcar_oc_con_sobras(ll_ordencorte,1) = -1 THEN	//oc sin sobrantes
						CLOSE(w_retroalimentacion)
						Destroy lds_unid_sobrantes_loteo
						return 2
					END IF
					//MessageBox('O.K.','Aun no se han cumplido las unidades de la PO, puede continuar sin problemas')
				END IF
			End if
			CLOSE(w_retroalimentacion)
			Destroy lds_unid_sobrantes_loteo
			ii_validar = 0
			ii_mostrar_sobrante = 0
		END IF
		
		//mira si el bongo es sobrante
		select max(sw_origen) into :ls_sw_origen
		from h_canasta_corte
		 WHERE cs_canasta = :data;	
		 
		If ls_sw_origen = 'S' Then
			dw_maestro.Modify("t_sobrante.Text='Sobrante'")
			dw_maestro.SetItem(1,'sw_origen','S')
		Else
			dw_maestro.Modify("t_sobrante.Text=''")
			dw_maestro.SetItem(1,'sw_origen','')
		End if

		IF len(String(li_subcentro)) > 0 THEN
//			sle_parte.SetFocus()
			dw_1.SetFocus()
		ELSE
			dw_maestro.SetColumn('subcentro')
		END IF
	
	 case 'orden_corte'
		ll_ordencorte = Long(Data) //This.GetItemNumber(1,'orden_corte')
		ii_validar = 1
		ii_mostrar_sobrante = 1
		//se validad que la orden de corte pertenezca a la fabrica que se esta trabajando
//		IF luo_oc.of_validarocfabrica(ll_ordencorte) = -1 THEN
//			Return
//		END IF
		ls_bolsa = This.GetItemString(1,'bolsa')
//		//se verifica que la orden este liquidada
		DECLARE validaroc PROCEDURE &
			FOR pr_valoc_liquida(:ll_ordencorte);
		EXECUTE validaroc;

		IF SQLCA.SQLCode = -1 THEN
			Post MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_valoc_liquida.",StopSign!)	
			CLOSE validaroc;
			Return 2
		ELSE
			FETCH validaroc INTO :li_result;
			IF li_result = 0 THEN
				Post MessageBox('Error','La orden de corte no se encuentra liquidada.',StopSign!)
				CLOSE validaroc;
				Return 2
			END IF
		END IF
		
		CLOSE validaroc;
		
		lds_oc = Create uo_dsbase
		lds_oc.DataObject = 'd_gr_h_ordenes_corte_x_oc'
		lds_oc.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
		
		lds_op_sin_riel = Create uo_dsbase				
		lds_op_sin_riel.dataobject = "d_gr_op_sin_riel"
		lds_op_sin_riel.settransobject(gnv_recursos.of_get_transaccion_sucia( ))


		//mira si es la ultima oc, busca las ordenes de corte aun pendiente por lotear, debe lotearlas primero antes de esta ultima oc
		ll_n = lds_oc.Of_Retrieve(ll_ordencorte)
		If ll_n > 0 Then
			//si la orden de corte esta marcada como primera vez
			If lds_oc.GetItemNumber(1,'co_tipo') = 4 Then
				If MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","ORDEN CORTE POR PRIMERA VEZ, DEBE EMPACAR LA MUESTRA VENDEDOR, $$HEX1$$bf00$$ENDHEX$$Desea Continuar?",exclamation!,YesNo!,2) = 2 Then
					Destroy lds_oc
					Destroy lds_op_sin_riel
					//This.SetItem(1,'orden_corte',ll_nulo)
					Return 2
				End IF
			End if
			
			//miramos si la orden de corte no esta marcada como ORDEN DE CORTE PO
			If lds_oc.GetItemNumber(1,'co_tipo') <> 10 Then
				//tomamos op y colores
				ll_op = lds_oc.GetItemNumber(1,'cs_ordenpd_pt')
				ll_colores = lds_oc.Object.co_color_pt.Primary
				
				//consulta  si hay ordenes de corte sin asignar riel
				ll_filas = lds_op_sin_riel.Retrieve(ll_op,ll_colores)
				IF ll_filas > 0 THEN
					messagebox("Atenci$$HEX1$$f300$$ENDHEX$$n","Existe la orden de corte: " + String(lds_op_sin_riel.GetItemNumber(1,'cs_orden_corte')) +" Marcada como ORDEN DE CORTE PO sin Lotear, Lotee esta primero" )
					//This.SetItem(1,'orden_corte',ll_nulo)
					Destroy lds_oc
					Destroy lds_op_sin_riel
					RETURN 2
				ElseIF ll_filas < 0 THEN
					messagebox("Error","hubo un error al consultar la orden de produccion")
					//This.SetItem(1,'orden_corte',ll_nulo)
					Destroy lds_oc
					Destroy lds_op_sin_riel
					RETURN 2
				END IF
			End if
			
		ElseIf ll_n < 0 Then
			Post MessageBox('Advertencia','Ocurrio un inconveniente al consultar la OC en ordenes corte.')
			Destroy lds_oc
			Destroy lds_op_sin_riel
			Return 2
		End if
		Destroy lds_oc
		Destroy lds_op_sin_riel
		
		lds_oc = Create uo_dsbase
		lds_oc.DataObject = 'd_gr_oc_pendientes_lotear_x_oc'
		lds_oc.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

		//mira si es la ultima oc, busca las ordenes de corte aun pendiente por lotear, debe lotearlas primero antes de esta ultima oc
		ll_n = lds_oc.Of_Retrieve(ll_ordencorte)
		If ll_n > 0 Then
			//recorre el dw para tomar las oc faltantes
			For ll_n = 1 to lds_oc.RowCount()
				If ll_n = 1 Then
					ls_ordenes = String(lds_oc.GetItemNumber(ll_n,'cs_asignacion'))
				Else
					ls_ordenes = ls_ordenes + ',' + String(lds_oc.GetItemNumber(ll_n,'cs_asignacion'))
				End if
			Next
			
			//muestra mensaje
			Post MessageBox('Advertencia','Las ordenes de corte ' + trim(ls_ordenes) + 'aun esta pendiente por lotear, debe lotearlas primero antes de esta ultima oc')
			Destroy lds_oc
			Return 2
		ElseIf ll_n < 0 Then
			Post MessageBox('Advertencia','Ocurrio un inconveniente al validar si la OC es la ultima.')
			Destroy lds_oc
			Return 2
		End if
		
		Destroy lds_oc
		
	   //se verifica que la orden de corte se encuentre en preparacion
	   li_preparacion = luo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
		IF li_preparacion = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el subcentro de preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
			Return 2
		END IF
				
		li_despachos   = luo_constantes.of_consultar_numerico('SUBCENTRO FIN CORTE')		
		IF li_despachos = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el subcentro de despachos.',StopSign!)
			Return 2
		END IF
		
		li_extendido   = luo_constantes.of_consultar_numerico('SUBCENTRO EXTENDIDO')
		IF li_extendido = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el subcentro de extendido.',StopSign!)
			Return 2
		END IF
		
		li_tipo = luo_constantes.of_consultar_numerico('PRENDAS')		
		IF li_tipo = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el tipo de prenda',StopSign!)
			Return 2
		END IF
		
		li_centro = luo_constantes.of_consultar_numerico('CENTRO CORTE')		
		IF li_centro = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el centro de corte',StopSign!)
			Return 2
		END IF
		
		li_loteoConf = wf_leerconstantescorte('MENS_LOTEO_CONF','la configuraci$$HEX1$$f300$$ENDHEX$$n del loteo.') //SA53802 - Ceiba/JJ - 29-10-2015
		IF li_loteoConf = -1 THEN Return 2
		
		ll_centro_pdn	= wf_leerConstantes('CONFECCION','el centro de confecci$$HEX1$$f300$$ENDHEX$$n') //SA53802 - Ceiba/JJ - 29-10-2015
		IF li_loteoConf = -1 THEN Return 2 
		
		ls_mensaje = lnvo_funcion.of_validarLoteProcesoDobladillo(ll_ordencorte,Long(ls_bolsa),li_tipo,ll_centro_pdn,li_loteoConf) //SA53802 - Ceiba/JJ - 29-10-2015
		IF NOT(IsNull(ls_mensaje)) THEN 
			Post MessageBox('Informaci$$HEX1$$f300$$ENDHEX$$n',ls_mensaje)
		END IF 		

	   SELECT MAX(co_subcentro_pdn)
		  INTO :li_subcentro
		  FROM dt_kamban_corte
		 WHERE cs_orden_corte 	= :ll_ordencorte and
				 co_tipoprod 		= :li_tipo and
				 co_centro_pdn 	= :li_centro and
		//		 co_fabrica       = :ii_fabrica and
		//		 co_linea         = :ii_linea and
		//		 co_referencia    = :il_referencia and	
				 fe_inicial 		is not null and
				 fe_final 			is null; 
				 
		IF sqlca.sqlcode = -1 Then
			Post MessageBox('Error','Ocurrio un error al momento de validar el subcentro',StopSign!)
			Return 2
		END IF
		
		IF li_subcentro = li_preparacion THEN
		ELSE
			IF li_subcentro = li_extendido THEN
				Post MessageBox('Error','La orden se encuentra en extendido, debe ser cargada a Preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
				Close( Parent )
				Return 2
			ELSE
				
			END IF
		END IF
		
		// FACL - 2018/03/13 - SA58127 - Se controla que lotee primero la OC que tiene la marcada por primera vez para la referencia
	   SELECT Count(a.cs_orden_corte), MIN( a.cs_orden_corte )
			INTO :ll_existe_oc_primera_vez, :ll_oc_primera_vez
		FROM h_ordenes_corte a, dt_pdnxmodulo b, dt_pdnxmodulo c
		WHERE a.cs_orden_corte = c.cs_asignacion
			AND b.cs_asignacion = :ll_ordencorte
			AND b.co_fabrica_pt = c.co_fabrica_pt
			AND b.co_linea = c.co_linea
			AND b.co_referencia = c.co_referencia
			AND c.co_estado_asigna <= 11
			AND a.co_tipo = (Select numerico From m_constantes Where var_nombre = 'OC_PRIMERA_VEZ')
			AND b.cs_asignacion <> c.cs_asignacion
		;
		If ll_existe_oc_primera_vez > 0 And 1=0 Then /*************  OJO PRUEBAS   **************/
			Post MessageBox( 'Atenci$$HEX1$$f300$$ENDHEX$$n', 'Existe una Orden de corte de la misma referencia marcada como Primera vez en proceso. '&
				+ 'Debe lotear primero la OC: ' + String(ll_oc_primera_vez) )
			Return 2
		End If

		
		//se modifica para no traer la ventana en el caso de que solo exista una P.O., cuando halla m$$HEX1$$e100$$ENDHEX$$s de una
		//P.O. se debe mostrar la ventana de selecion
		//jcrm
		//agosto  30 de 2007
	   SELECT count(Distinct dt_canasta_corte.po)
		  INTO :ll_count
        FROM dt_canasta_corte      
        WHERE dt_canasta_corte.cs_orden_corte = :ll_ordencorte;  
		  
		// FACL - 2020/07/22 - SA60509 - Se invoca la ventana de buscar PO de agrupacion
		lstr_parametros.entero[1] = ll_ordencorte
		OpenWithParm ( w_buscar_po_agrupacion, lstr_parametros)
		lstr_parametros = message.PowerObjectParm	
		If lstr_parametros.hay_parametros Then
			ls_po = lstr_parametros.cadena[3]
			dw_maestro.SetItem(1,'po_agrupada', lstr_parametros.cadena[2] )
			dw_maestro.SetItem(1,'pedido', lstr_parametros.entero[1] )			
		Else
			ls_po = ''
			dw_maestro.SetItem(1,'po_agrupada', '' )
			dw_maestro.SetItem(1,'pedido', 0 )
		End If
		dw_maestro.Modify("t_agrupada.Text=''")
			
		If ls_po <> '' Then // FACL - 2020/07/22 - SA60509 - Si es un pedido agrupado no se muestra la ventana normal de buscar po
			dw_maestro.Modify("t_agrupada.Text='Agrupada'")
		ElseIF ll_count > 1 THEN
			//despliego las P.O. para la orden de corte, permitiendo al usuario seleccionar con la que quiere trabajar
			lstr_parametros.entero[1] = ll_ordencorte
			
			OpenWithParm ( w_buscar_po, lstr_parametros)
			lstr_parametros = message.PowerObjectParm	
			If lstr_parametros.hay_parametros Then
				ls_po = lstr_parametros.cadena[1]
			End if
		ELSE
			SELECT dt_canasta_corte.po
			  INTO :ls_po
			  FROM dt_canasta_corte      
			  WHERE dt_canasta_corte.cs_orden_corte = :ll_ordencorte;  
			  IF SQLCA.SQLCODE = 100 THEN
				  Post MessageBox('Error','No se encontr$$HEX2$$f3002000$$ENDHEX$$ninguna Bolsa asociada a la orden de corte, .',StopSign!)
				  Return 2
			  END IF
		END IF

		dw_maestro.SetItem(1,'po',ls_po)
		
		//Verificar Si la orden de corte ya esta loteada para informar al usuario
		SELECT MAX(co_estado_asigna) 
		  INTO :li_estado_asigna
		  FROM dt_pdnxmodulo
		 WHERE cs_asignacion = :ll_ordencorte; 
		IF li_estado_asigna = 15 THEN
			Post MessageBox('Advertencia','La orden de corte ya se encuentra Loteada, Verifique')
		END IF

	//Javier pide que se deje quite y se deje solo en el loteo correo agosto 17 - 2011 realiza jorodrig
//    //se verifica que tenga el visto bueno del auditor de calidad	
//		SELECT count(*) 
//		  INTO :ll_count
//		  FROM m_auditor_po
//		 WHERE cs_orden_corte = :ll_ordencorte AND
//		  	    po = :ls_po;
//					
//		IF ll_count =  0 THEN
//			MessageBox('Advertencia','Falta el visto bueno del auditor de calidad.',StopSign!)
//			Return
//		END IF
	
		//verificar si es un lote piloto para llevar la marca al bongo, (tipo 3)
		SELECT MAX(nvl(co_cpto_critica,0))
		  INTO :li_cpto_critica
		  FROM h_ordenes_corte
		 WHERE cs_orden_corte = :ll_ordencorte; 
		IF li_cpto_critica = 3 THEN
			ii_marca_especial = 3
		ELSE
			ii_marca_especial = 0
		END IF
	
	   //se muestran las demas ordenes de corte que conforman el duo o conjunto en caso de serlo
		//jcrm - jorodrig
		//octubre 6 de 2008
		ll_unir_oc = luo_corte.of_duo_conjunto(ll_ordencorte)
		IF ll_unir_oc > 0 THEN
			lstr_parametros.entero[1] = ll_ordencorte
			lstr_parametros.entero[2] = ll_unir_oc
			OpenWithParm ( w_duo_conjunto, lstr_parametros )
		END IF
		
		wf_ValidarOC_x_Op(ll_ordencorte) //SA55269 - Ceiba/jjmonsal - 10-08-2016
		
		This.SetColumn('bolsa')	
	case 'modulo'
		ll_ordencorte 	= This.GetItemNumber(1,'orden_corte')
		li_subcentro 	= This.GetItemNumber(1,'subcentro')
		li_tipo 			= Long(Mid(String(li_subcentro),1,1))
		li_centro 		= Long(Mid(String(li_subcentro),2,2))
		li_subcentro 	= Long(Mid(String(li_subcentro),4))
		ls_modulo      = Trim(Data) //This.GetItemString(1,'modulo')
		li_fab 			= Long(mid(ls_modulo,1,2))
		li_planta 		= Long(mid(ls_modulo,3,2))
		ll_modulo 		= Long(mid(ls_modulo,5))
			
		If lpo_modulo.of_descripcion_modulo(ls_modulo,li_tipo,li_centro,li_subcentro,ls_de_modulo, ii_ctro_fisico) = -1 Then
			// This.SetItem(1,'modulo','')
			Return 2
		Else
			This.SetItem(1,'de_modulo',ls_de_modulo)
		End if
		
		UPDATE dt_kamban_corte
		   SET co_fabrica_planta = :li_fab,
			    co_planta			 = :li_planta,
				 co_modulo			 = :ll_modulo
		 WHERE cs_orden_corte 	= :ll_ordencorte
		   AND co_tipoprod	 	= :li_tipo
			AND co_centro_pdn		= :li_centro
			AND co_subcentro_pdn	= :li_subcentro;
			
			IF sqlca.sqlcode = -1 Then
				ROLLBACK;
				MessageBox('Error','Actualizando dt_kamban_corte',StopSign!)
				Return 2
			ELSE
				COMMIT;
			END IF
			
		
		This.SetColumn('bongo')	
	case 'po'	
		ii_validar = 1
		ii_mostrar_sobrante = 1
		
end choose


end event

event buttonclicked;Long ll_recipiente
n_cst_loteo_bongo luo_loteo


Choose Case dwo.Name
	Case "p_bongo"
		ll_recipiente = luo_loteo.of_generarconsecutivobongo()
		If ll_recipiente > 0 Then
			//se debe colocar el numero del bongo en la ventana de loteo.
			dw_maestro.SetItem(1,'bongo',ll_recipiente)
			ib_bongo = True
		End if
End Choose


end event

type gb_1 from groupbox within w_lectura_bolsa
integer x = 69
integer y = 16
integer width = 1678
integer height = 440
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Maestro "
end type

type gb_2 from groupbox within w_lectura_bolsa
integer x = 69
integer y = 480
integer width = 1678
integer height = 980
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Detalle "
end type

