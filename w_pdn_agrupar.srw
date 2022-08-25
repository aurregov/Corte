HA$PBExportHeader$w_pdn_agrupar.srw
forward
global type w_pdn_agrupar from window
end type
type cb_4 from commandbutton within w_pdn_agrupar
end type
type cb_3 from commandbutton within w_pdn_agrupar
end type
type cb_2 from commandbutton within w_pdn_agrupar
end type
type cb_1 from commandbutton within w_pdn_agrupar
end type
type cb_concepto from commandbutton within w_pdn_agrupar
end type
type cb_limpiar from commandbutton within w_pdn_agrupar
end type
type cb_recuperar from commandbutton within w_pdn_agrupar
end type
type dw_parametros from datawindow within w_pdn_agrupar
end type
type dw_pdnagrupa from u_dw_base within w_pdn_agrupar
end type
type dw_pdn from u_dw_base within w_pdn_agrupar
end type
end forward

global type w_pdn_agrupar from window
integer width = 4549
integer height = 2192
boolean titlebar = true
string menuname = "m_mantenimiento_asignacion_trazos"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_trazos ( )
event ue_grabar ( )
event ue_menu ( )
event ue_select ( long an_select )
event ue_borrar ( )
event ue_partir ( )
event ue_consolidar ( )
event ue_filtro ( unsignedlong wparam,  long lparam )
event type long ue_anular ( )
event ue_agrupar_referencias ( )
event ue_grupos ( )
event ue_proporcion ( )
event ue_lote ( )
event ue_habilitar_produccion ( )
event ue_programar_automatico ( )
event ue_anular_reposo ( )
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
cb_concepto cb_concepto
cb_limpiar cb_limpiar
cb_recuperar cb_recuperar
dw_parametros dw_parametros
dw_pdnagrupa dw_pdnagrupa
dw_pdn dw_pdn
end type
global w_pdn_agrupar w_pdn_agrupar

type variables
m_select im_select
Boolean ib_trazo, ib_filtro,ib_ordenar_ascendente, ib_modificar
Long il_fila, il_i, il_ordenpdn, il_agrup, il_ordcte, il_continua 
Long sw_estado, ii_fabrica, ii_planta, ii_centro, ii_estadodisp
Long ii_fabricaref, ii_linea, il_planta_proceso
String is_columna[], is_filtrar
n_cst_configuracion_kpo  invo_modificar


end variables

forward prototypes
public function long of_crearagrupa ()
public function long of_borraragrupa (long an_fila)
public subroutine of_seleccionar_agrupacion (long al_fila)
public function long of_orden_corte ()
public function long of_detalletrazo (long an_agrupa)
public function long of_traer_lote_liberacion ()
public function long of_anular_reposo ()
end prototypes

event ue_trazos();Long   	ll_fila,ll_fab,ll_ref,ll_filins,ll_agrupa,ll_rseult, li_lib, ll_color
Long    	li_fabpt,li_lin,li_cspar,li_simulacion, li_rollos, li_anno_critica, li_semana_critica
Long  li_fabrica_ant, li_linea_ant, li_filas
Long 	li_fab,li_planta, li_agrupada,  ll_op_ant, ll_op
LONG		li_mod, ll_referencia_ant, li_priori, ll_tipo_negocio, ll_find, ll_n
Long 		ll_dif_anchos_tub, ll_dif_anchos_abi, ll_band, ll_m, ll_reposo
String 	ls_po,ls_tono,ls_mensaje,ls_sqlerr,ls_instruccion, ls_cut
DATE	 	ld_fecha
DateTime ldt_fecha_fin_bck, ldt_fecha
Decimal{2} ld_ancho, ld_ancho_inicial, ld_diferencia_ancho, ld_diferencia
n_cts_param luo_parametros
uo_dsbase lds_simulacion, lds_consulta_simulacion, lds_ancho, lds_consulta_ancho, ld_tb_valida_si_lib_agrupada

n_cts_corte_una luo_corte
n_cts_constantes luo_constantes
n_cts_constantes_tela luo_constantes_tela
n_cts_constantes_corte luo_constante_corte

luo_corte = Create n_cts_corte_una
luo_constantes = Create n_cts_constantes

lds_simulacion = Create uo_dsbase
lds_simulacion.DataObject = 'd_gr_dt_simulacion_reposo'
lds_simulacion.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

lds_consulta_simulacion = Create uo_dsbase
lds_consulta_simulacion.DataObject = 'd_gr_dt_simulacion_reposo'
lds_consulta_simulacion.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

lds_ancho = Create uo_dsbase
lds_ancho.DataObject = 'd_gr_anchos_x_liberacion'
lds_ancho.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

lds_consulta_ancho = Create uo_dsbase
lds_consulta_ancho.DataObject = 'd_gr_anchos_x_liberacion'
lds_consulta_ancho.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

ld_tb_valida_si_lib_agrupada = Create uo_dsbase
ld_tb_valida_si_lib_agrupada.DataObject = 'd_tb_valida_si_lib_agrupada'
ld_tb_valida_si_lib_agrupada.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())

//Trae la constante de diferencia permitida en los anchos seg$$HEX1$$fa00$$ENDHEX$$n el tipo de tela 
//de la tabla m_constantes_corte, para tubular (caract = 4) es 'DIFERENCIA_ANCHOS_TUB'; 
//para diferente de caract 4 es 'DIFERENCIA_ANCHOS_ABI'
ll_dif_anchos_tub = luo_constante_corte.of_consultar_numerico("DIFERENCIA_ANCHOS_TUB")
ll_dif_anchos_abi = luo_constante_corte.of_consultar_numerico("DIFERENCIA_ANCHOS_ABI")

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA    ")    
ll_tipo_negocio = luo_constantes.of_consultar_numerico("REPOSO_TIPONEGOCIO")
IF ll_tipo_negocio = -1 THEN
	Rollback;
	MessageBox('Error','No fue posible establecer el tipo negocio para la simulacion.',StopSign!)
	Return 
END IF

ld_diferencia_ancho = luo_constantes.of_consultar_numerico("DIFERENCIA ANCHO")

IF ld_diferencia_ancho = -1 THEN
	ld_diferencia_ancho = 0
END IF

ld_fecha = Date(f_fecha_servidor())
ldt_fecha = f_fecha_servidor()
				
SetNull(li_fabrica_ant)
SetNull(li_linea_ant)
SetNull(ll_referencia_ant)
li_agrupada = 0

FOR li_filas = 1 TO dw_pdn.RowCount()
	IF dw_pdn.IsSelected(li_filas) THEN
		IF IsNull(li_fabrica_ant) THEN
			li_fabrica_ant = dw_pdn.GetItemNumber(li_filas, 'co_fabrica_pt')
			li_linea_ant = dw_pdn.GetItemNumber(li_filas, 'co_linea')
			ll_referencia_ant = dw_pdn.GetItemNumber(li_filas, 'co_referencia')
			ll_op_ant = dw_pdn.GetItemNumber(li_filas, 'cs_ordenpd_pt')
		ELSE
			li_fabpt = dw_pdn.GetItemNumber(li_filas, 'co_fabrica_pt')
			li_lin = dw_pdn.GetItemNumber(li_filas, 'co_linea')
			ll_ref = dw_pdn.GetItemNumber(li_filas, 'co_referencia')
			ll_op = dw_pdn.GetItemNumber(li_filas, 'cs_ordenpd_pt')
			
			IF li_fabrica_ant <> li_fabpt OR li_linea_ant <> li_lin OR ll_referencia_ant <> ll_ref   THEN
				li_agrupada = 1
			END IF
				
			IF ll_op_ant <> ll_op THEN 	//revisar si alguna de las liberaciones es de una agrupada, en ese caso no se pueden juntar liberaciones
				li_lib   	= dw_pdn.GetItemNumber(li_filas,'cs_liberacion')
				ld_tb_valida_si_lib_agrupada.Retrieve(li_lib) 
				IF ld_tb_valida_si_lib_agrupada.Rowcount() > 0 THEN	
					MessageBox("Error!","No puede agrupar liberaciones agrupadas de diferente OP en una OC.")
					Return
				END IF
			END IF
			ll_op_ant = ll_op
	
		END IF
	END IF
NEXT

//-------------------------  limpia dw_pdnagrupa ----------------------//
dw_pdnagrupa.Reset()

//-------------------------  valida que tenga filas seleccionadas -----//
If dw_pdn.GetSelectedRow(0) <= 0 Then 
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar las producciones que desea agrupar.")
	Return
End If

ll_m = 0
ll_reposo = 0
ll_fila = 0
//------------------  ciclo para cargar dw_pdnagrupa con selecc. de dw_pdn -----------//
Do 
	ll_fila = dw_pdn.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then
		//----------------------  valida que estado = 1 -------------------------------//
		If dw_pdn.GetItemNumber(ll_fila,'sw_estado') <> 1 Then
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no puede ser agrupada." )
			Return
		Else
			li_simulacion	= dw_pdn.GetItemNumber(ll_fila,'simulacion')
			ll_fab    		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica_exp')
			li_lib   		= dw_pdn.GetItemNumber(ll_fila,'cs_liberacion')
			ls_po    		= dw_pdn.GetItemString(ll_fila,'po')
			ls_cut			= dw_pdn.GetItemString(ll_fila,'nu_cut')
			li_fabpt 		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica_pt')
			li_lin   		= dw_pdn.GetItemNumber(ll_fila,'co_linea')
			ll_ref   		= dw_pdn.GetItemNumber(ll_fila,'co_referencia')
			ll_color 		= dw_pdn.GetItemNumber(ll_fila,'co_color_pt')
			li_cspar 		= dw_pdn.GetItemNumber(ll_fila,'cs_particion')
			ls_tono  		= dw_pdn.GetItemString(ll_fila,'tono')
			li_priori		= dw_pdn.GetItemNumber(ll_fila,'cs_prioridad')
			li_fab   		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica')
			li_planta		= dw_pdn.GetItemNumber(ll_fila,'co_planta')
			li_mod			= dw_pdn.GetItemNumber(ll_fila,'co_modulo')
			ld_ancho			= dw_pdn.GetItemNumber(ll_fila,'ancho')
			li_rollos		= dw_pdn.GetItemNumber(ll_fila,'rollos_bodega')
			
			IF li_rollos = 0 THEN
				MessageBox("Advertencia...","Esta agrupando liberaciones sin rollos en la bodega")
				dw_pdnagrupa.Reset()
				Return
			END IF				
	
			//busca registro en simulacion
			ll_find = lds_simulacion.Find('pedido = ' + String(li_lib) ,1,lds_simulacion.RowCount() +1)
			//si encuentra registros
			If ll_find <= 0 Then
				//consulta los registros de simulacion para la liberacion
				If lds_consulta_simulacion.Retrieve(li_lib, ll_tipo_negocio) < 0 Then
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error alconsultar simulacion para la liberacion')
					Return 
				End if
				
				//copia los registros
				lds_consulta_simulacion.RowsCopy(1, lds_consulta_simulacion.RowCount() +1, Primary!, lds_simulacion, 1, Primary!)
			End if
			
			//busca registro en simulacion
			ll_find = lds_simulacion.Find('pedido = ' + String(li_lib) ,1,lds_simulacion.RowCount() +1)
			//si encuentra registros
			If ll_find > 0 Then
				lds_simulacion.SetFilter('pedido = ' + String(li_lib))
				lds_simulacion.Filter()
				
				For ll_n = 1 to lds_simulacion.RowCount()
					ll_reposo = 1
					//toma la fecha fin 
					ldt_fecha_fin_bck = lds_simulacion.GetItemDatetime(ll_n,'fecha_fin_bck')
					
					//Si alguno de los registros encontrados tiene la fecha fin bck en nulo 
					If Isnull(ldt_fecha_fin_bck) Then
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La liberaci$$HEX1$$f300$$ENDHEX$$n lleva telas que requieren reposo y a$$HEX1$$fa00$$ENDHEX$$n no ha iniciado el reposo')
						Return 
					End if
					
					//Si alguna de las fecha fin bck es superior a la fecha actual 
					If ldt_fecha_fin_bck > ldt_fecha Then
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La liberaci$$HEX1$$f300$$ENDHEX$$n termina el reposo el ' + String(ldt_fecha_fin_bck) + ', a$$HEX1$$fa00$$ENDHEX$$n no se puede programar')
						Return 
					End if
					
				Next
				
				lds_simulacion.SetFilter('')
				lds_simulacion.Filter()
			End if
			
			//busca registro para el ancho
			ll_find = lds_ancho.Find('cs_liberacion = ' + String(li_lib) ,1,lds_ancho.RowCount() +1)
			//si encuentra registros
			If ll_find <= 0 Then
				//consulta los registros para el ancho
				If lds_consulta_ancho.Retrieve(li_lib) < 0 Then
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el ancho para la liberacion')
					Return 
				End if
				
				//copia los registros
				lds_consulta_ancho.RowsCopy(1, lds_consulta_ancho.RowCount() +1, Primary!, lds_ancho, 1, Primary!)
			End if
			
			//busca registro en 
			ll_find = lds_ancho.Find('cs_liberacion = ' + String(li_lib) ,1,lds_ancho.RowCount() +1)
			//si encuentra registros
			If ll_find > 0 Then
				
				lds_ancho.SetFilter('cs_liberacion = ' + String(li_lib))
				lds_ancho.Filter()
				
				For ll_n = 1 to lds_ancho.RowCount()
					//indica que se compara anchos
					ll_m = 1
					ld_diferencia = Abs(lds_ancho.GetItemDecimal(ll_n, 'ancho_cortable') - lds_ancho.GetItemDecimal(ll_n, 'ancho_tub_term'))
					//mira la constante de diferencia permitida en los anchos seg$$HEX1$$fa00$$ENDHEX$$n el tipo 
					//de tela de la tabla m_constantes_corte, para tubular (caract = 4) es 
					//'DIFERENCIA_ANCHOS_TUB'; para diferente de caract 4 es 'DIFERENCIA_ANCHOS_ABI'
					//If lds_ancho.GetItemNumber(ll_n, 'co_caract') = 4 Then se reemplaza por la siguiente  linea
					If	lds_ancho.GetItemNumber(ll_n, 'co_terminado') = 2 Then
					
						//Si alguna de las diferencias de los anchos es superior a la constante 
						//permitida entonces cancela el proceso
						If ld_diferencia > ll_dif_anchos_tub Then
							Rollback;
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El Rollo ' + String(lds_ancho.GetItemNumber(ll_n, 'cs_rollo')) + &
							' tiene una ancho inicial: ' + String(lds_ancho.GetItemDecimal(ll_n, 'ancho_cortable')) + &
							' y un ancho final de  ' + String(lds_ancho.GetItemDecimal(ll_n, 'ancho_tub_term')) + &
							'. La diferencia es mayor a lo permitido, se cancela el proceso, debe anular la liberaci$$HEX1$$f300$$ENDHEX$$n y volver a liberar')
							Return 
						End if
							
					Else	
						If ld_diferencia > ll_dif_anchos_abi Then
							Rollback;
							MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El Rollo ' + String(lds_ancho.GetItemNumber(ll_n, 'cs_rollo')) + &
							' tiene una ancho inicial: ' + String(lds_ancho.GetItemDecimal(ll_n, 'ancho_cortable')) + &
							' y un ancho final de  ' + String(lds_ancho.GetItemDecimal(ll_n, 'ancho_tub_term')) + &
							'. La diferencia es mayor a lo permitido, se cancela el proceso, debe anular la liberaci$$HEX1$$f300$$ENDHEX$$n y volver a liberar')
							Return 
						End if
					End if
				Next
				
				lds_ancho.SetFilter('')
				lds_ancho.Filter()
			End if
			
			dw_pdn.SetItem(ll_fila,'co_estado_asigna',3)
//			se va a poner en estado 6 para evitar la siguiente ventana  sep 15 - 09
			
		//	dw_pdn.SetItem(ll_fila,'co_estado_asigna',6)
			
			ll_filins = dw_pdnagrupa.InsertRow(0)
			IF li_agrupada = 0 THEN
				IF ll_filins = 1 THEN
					ld_ancho_inicial = ld_ancho
				ELSE
					//***********************************************************************************************************
					//se coloca en comentario para realizar prueba de agrupar referencias de diferentes anchos
					//jcrm - jorodrig
					//octubre 1 de 2008
					
//					IF Abs(ld_ancho - ld_ancho_inicial) > ld_diferencia_ancho THEN
//						MessageBox("Advertencia...","Esta agrupando liberaciones con diferencia en ancho mayor al permitido")
//						dw_pdnagrupa.Reset()
//						Return
//					END IF
					//***********************************************************************************************************
				END IF
			END IF
			
			dw_pdnagrupa.SetItem(ll_filins,'co_fabrica_exp',ll_fab)
			dw_pdnagrupa.SetItem(ll_filins,'cs_liberacion',li_lib)
			dw_pdnagrupa.SetItem(ll_filins,'po',ls_po)
			dw_pdnagrupa.SetItem(ll_filins,'nu_cut',ls_cut)
			dw_pdnagrupa.SetItem(ll_filins,'co_fabrica_pt',li_fabpt)
			dw_pdnagrupa.SetItem(ll_filins,'co_linea',li_lin)
			dw_pdnagrupa.SetItem(ll_filins,'co_referencia',ll_ref)
			dw_pdnagrupa.SetItem(ll_filins,'co_color_pt',ll_color)
			dw_pdnagrupa.SetItem(ll_filins,'cs_particion',li_cspar)
			dw_pdnagrupa.SetItem(ll_filins,'tono',ls_tono)
			dw_pdnagrupa.SetItem(ll_filins,'ca_unidades',dw_pdn.GetItemNumber(ll_fila,'ca_programada'))
			dw_pdnagrupa.SetItem(ll_filins,'de_linea',dw_pdn.GetItemString(ll_fila,'de_linea'))
			dw_pdnagrupa.SetItem(ll_filins,'de_referencia',dw_pdn.GetItemString(ll_fila,'de_referencia'))
			dw_pdnagrupa.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
			dw_pdnagrupa.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)
			dw_pdnagrupa.SetItem(ll_filins,'ancho',ld_ancho)
			
			
			//inicio de programa fechas
			
			////--------------------------------------
			////calculos las fechas de programaci$$HEX1$$f300$$ENDHEX$$n
			////--------------------------------------
			//						
			If li_priori > 1 Then

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
			
//			If luo_corte.Of_MetodoMinutos(1,li_fab,li_planta,li_mod,li_priori,ld_fecha) = -1 Then
//				Rollback;
//				Return
//			End if
			//fin de programa fechas
		End If
	End If
loop Until ll_fila = 0

If ll_m > 0 and ll_reposo > 0 Then
	ll_band = MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', '$$HEX1$$bf00$$ENDHEX$$ya actualizaron los anchos de los rollos despues del reposo?', Question! , YesNo!,2)
	//si respondieron que no se cancela
	If ll_band = 2 Then
		Rollback;
		Return 
	End If	
End if

COMMIT;

//------------------ si cargo dw_pdnagrupa ----------------------------//
If dw_pdnagrupa.RowCount() > 0 Then
	//pregunta si crea a add a agrupacion -------------------//
	ls_mensaje = "$$HEX1$$bf00$$ENDHEX$$Desea crear una nueva agrupaci$$HEX1$$f300$$ENDHEX$$n?~n~nSi responde que no, inmediatamente despues debe seleccionar una producci$$HEX1$$f300$$ENDHEX$$n con una agrupaci$$HEX1$$f300$$ENDHEX$$n valida."
	ll_rseult = MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!",ls_mensaje,Question!,YesNoCancel!)
	//-------------  si desea crear agrupacion -------------------------------//
	If ll_rseult = 1 Then
		ll_agrupa = of_CrearAgrupa()
		
		MessageBox('Agrupacion',String(ll_agrupa))
		
		il_agrup  = ll_agrupa
		dw_pdnagrupa.Sort()

		If ll_agrupa > 0 Then 
			If Of_detalleTrazo(ll_agrupa) > 0 Then 
				//commit ;
				MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
				dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro, li_anno_critica, li_semana_critica,il_planta_proceso)
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
	If of_orden_corte() = -1 Then
		Rollback;
	Else
		Commit;
		If li_agrupada = 1 Then
			luo_parametros.il_vector[1] = ll_agrupa
			OpenSheetWithParm(w_definir_rayas_agrupacion, luo_parametros, This)
		End if
	End if
	dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro, li_anno_critica, li_semana_critica,il_planta_proceso)
End if
//fin de la modificacion jcrm

Destroy n_cts_corte_una
end event

event ue_grabar();Long   	ll_fila,ll_fab,ll_ref,ll_filins,ll_agrupa,ll_rseult,li_mod,ll_color
Long    	li_lib,li_fabpt,li_lin,li_cspar,li_i
String 	ls_po,ls_tono,ls_sqlerr, ls_cut
Long	li_priori,li_fab,li_planta, li_anno_critica, li_semana_critica
DATE		ld_fecha
n_cts_corte luo_corte
n_cts_constantes_tela luo_constantes_tela

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA    ")    


luo_corte = Create n_cts_corte
//------------------------- accepttext a dw_pdn -----------------------------------//
dw_pdn.AcceptText()

//---------  ciclo sobre dw_pdn, carga dw_pdnagrupa con selec y crear agrupaciones --//
For li_i = 1 To dw_pdn.RowCount()
	//---------- blanquea dw_pdnagrupa ------------------------------//
	dw_pdnagrupa.Reset()
	//------------  si estado inicial no marcado para agrupar pero ahora si marcado ---//
	If dw_pdn.GetItemNumber(li_i,'sw_estado') = 1 And dw_pdn.GetItemNumber(li_i,'co_estado_asigna') = 2 Then

		//---------------------- toma los datos de la fila -------------------------------//
		ll_fab    	= dw_pdn.GetItemNumber(li_i,'co_fabrica_exp')
		li_fab   	= dw_pdn.GetItemNumber(li_i,'co_fabrica')
		li_planta   = dw_pdn.GetItemNumber(li_i,'co_planta')
		li_mod   	= dw_pdn.GetItemNumber(li_i,'co_modulo')
		li_lib   	= dw_pdn.GetItemNumber(li_i,'cs_liberacion')
		ls_po    	= dw_pdn.GetItemString(li_i,'po')
		ls_cut		= dw_pdn.GetItemString(li_i,'nu_cut')
		li_fabpt 	= dw_pdn.GetItemNumber(li_i,'co_fabrica_pt')
		li_lin   	= dw_pdn.GetItemNumber(li_i,'co_linea')
		ll_ref   	= dw_pdn.GetItemNumber(li_i,'co_referencia')
		ll_color 	= dw_pdn.GetItemNumber(li_i,'co_color_pt')
		li_cspar 	= dw_pdn.GetItemNumber(li_i,'cs_particion')
		ls_tono  	= dw_pdn.GetItemString(li_i,'tono')
		li_priori  	= dw_pdn.GetItemNumber(li_i,'cs_prioridad')
		
		dw_pdn.SetItem(li_i,'co_estado_asigna',3)
		
		dw_pdn.AcceptText()
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
				    ( dt_programa_diario.cs_liberacion 		= dt_pdnxmodulo.cs_liberacion ) and  
				    ( dt_programa_diario.po 						= dt_pdnxmodulo.po ) and  
				    ( dt_programa_diario.nu_cut					= dt_pdnxmodulo.nu_cut ) and
				    ( dt_programa_diario.co_fabrica_pt 		= dt_pdnxmodulo.co_fabrica_pt ) and  
				    ( dt_programa_diario.co_linea 				= dt_pdnxmodulo.co_linea ) and  
				    ( dt_programa_diario.co_referencia 		= dt_pdnxmodulo.co_referencia ) and  
				    ( dt_programa_diario.co_color_pt 			= dt_pdnxmodulo.co_color_pt ) and  
				    ( dt_programa_diario.tono 					= dt_pdnxmodulo.tono ) and  
				    ( dt_programa_diario.cs_particion 		   = dt_pdnxmodulo.cs_particion ) and  
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
		
		If luo_corte.Of_MetodoMinutos(1,li_fab,li_planta,li_mod,li_priori,ld_fecha) = -1 Then
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error, verifique la informaci$$HEX1$$f300$$ENDHEX$$n e intente nuevamente')
			rollback;
			Return
		Else
			COMMIT;
		End if
		
		
		ll_filins = dw_pdnagrupa.InsertRow(0)
		
		dw_pdnagrupa.SetItem(ll_filins,'co_fabrica_exp',ll_fab)
		dw_pdnagrupa.SetItem(ll_filins,'cs_liberacion',li_lib)
		dw_pdnagrupa.SetItem(ll_filins,'po',ls_po)
		dw_pdnagrupa.SetItem(ll_filins,'nu_cut',ls_cut)
		dw_pdnagrupa.SetItem(ll_filins,'co_fabrica_pt',li_fabpt)
		dw_pdnagrupa.SetItem(ll_filins,'co_linea',li_lin)
		dw_pdnagrupa.SetItem(ll_filins,'co_referencia',ll_ref)
		dw_pdnagrupa.SetItem(ll_filins,'co_color_pt',ll_color)
		dw_pdnagrupa.SetItem(ll_filins,'cs_particion',li_cspar)
		dw_pdnagrupa.SetItem(ll_filins,'tono',ls_tono)
		dw_pdnagrupa.SetItem(ll_filins,'ca_unidades',dw_pdn.GetItemNumber(li_i,'ca_programada'))
		dw_pdnagrupa.SetItem(ll_filins,'de_linea',dw_pdn.GetItemString(li_i,'de_linea'))
		dw_pdnagrupa.SetItem(ll_filins,'de_referencia',dw_pdn.GetItemString(li_i,'de_referencia'))
		dw_pdnagrupa.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
		dw_pdnagrupa.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)

			
		ll_agrupa = of_CrearAgrupa()
		
		If ll_agrupa > 0 Then 
			If Of_detalleTrazo(ll_agrupa) = -1 Then 
				Rollback;
				Return 
			END IF
		End If
	End If
Next

Destroy n_cts_corte

//If of_particion(dw_pdn) = 0 Then
	commit ;
//Else		
//	rollback ; 
//End If
//-----------------------------  retrieve con modulo 701 ---------------------------//
dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro, li_anno_critica, li_semana_critica,il_planta_proceso)
end event

event ue_menu();im_select.m_edicion.PopMenu(w_principal.PointerX(),w_principal.PointerY())


end event

event ue_select(long an_select);Long li_i,li_sw

li_sw = 1

If an_select = 1 Then li_sw = 2
	
For li_i = 1 To dw_pdn.RowCount()
	If dw_pdn.GetItemNumber(li_i,'sw_estado') = 1 Then
		dw_pdn.SetItem(li_i,'co_estado_asigna',li_sw)
	End If
Next


end event

event ue_borrar();Long   ll_fila,ll_fab,ll_pdn,ll_ref,ll_filins,ll_agrupa,ll_rseult, ll_color
Long    li_lib,li_fabpt,li_lin,li_csest,li_cspar, li_anno_critica, li_semana_critica
String ls_po,ls_tono,ls_mensaje
n_cts_constantes_tela luo_constantes_tela

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA    ")    




//-----------  valida que existan producciones seleccionadas --------------------------//
If dw_pdn.GetSelectedRow(0) <= 0 Then 
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar las producciones que desea desagrupar.")
	Return
End If

ls_mensaje = "$$HEX1$$bf00$$ENDHEX$$Desea crear una nueva agrupaci$$HEX1$$f300$$ENDHEX$$n?~n~nSi responde que no, inmediatamente despues debe seleccionar una producci$$HEX1$$f300$$ENDHEX$$n con una agrupaci$$HEX1$$f300$$ENDHEX$$n valida."


ll_fila = 0
//---------------------- ciclo para validar que las pdnes sean validas ----------------//
Do 
	ll_fila = dw_pdn.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then
		If dw_pdn.GetItemNumber(ll_fila,'sw_estado') > 3 Then
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no puede ser desagrupada." )
			Return
		Else
			
			ll_agrupa = dw_pdn.GetItemNumber(ll_fila,'cs_agrupacion')
			ll_pdn    = dw_pdn.GetItemNumber(ll_fila,'cs_pdn')
			
			If IsNull(ll_agrupa) Then
				MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no es valida." )
				Return
			End If
			
			If IsNull(ll_pdn) Then
				MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no es valida." )
				Return
			End If
		
		End If
	End If
loop Until ll_fila = 0


ll_fila = 0
//--------------------- ciclo para borrar pdnes seleccionadas -------------------//
Do 
	ll_fila = dw_pdn.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then

		If Of_BorrarAgrupa(ll_fila) = -1 Then Return
	End If
loop Until ll_fila = 0

commit ;

MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Se borraron las agrupaciones con exito." )
//----------------------------- retrieve con modulo 701  --------------------------//
dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro, li_anno_critica, li_semana_critica,il_planta_proceso)
end event

event ue_partir();Long	li_anno_critica, li_semana_critica
s_base_parametros lstr_parametros
n_cts_constantes_tela luo_constantes_tela

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA    ")    
		
If il_fila > 0 Then
	
	If dw_pdn.GetItemNumber(il_fila,'sw_simulacion') > 0 Then
		MessageBox('Advertencia','La liberaci$$HEX1$$f300$$ENDHEX$$n lleva reposo, esta no se puede partir, debe generar liberaciones separadas')
		Return 
	End if
		
	If dw_pdn.GetItemNumber(il_fila,'co_estado_asigna') = 1 Then	
	
		//invoco ventana para determinar las cantidad en la que desean particionar
		lstr_parametros.entero[1] = dw_pdn.GetItemNumber(il_fila,'simulacion')
		lstr_parametros.entero[2] = dw_pdn.GetItemNumber(il_fila,'co_fabrica')
		lstr_parametros.entero[3] = dw_pdn.GetItemNumber(il_fila,'co_planta') 
		lstr_parametros.entero[4] = dw_pdn.GetItemNumber(il_fila,'co_modulo') 
		lstr_parametros.entero[5] = dw_pdn.GetItemNumber(il_fila,'co_fabrica_exp') 
		lstr_parametros.entero[6] = dw_pdn.GetItemNumber(il_fila,'cs_liberacion') 
		lstr_parametros.cadena[1] = dw_pdn.GetItemString(il_fila,'po') 
		lstr_parametros.cadena[2] = dw_pdn.GetItemString(il_fila,'nu_cut') 
		lstr_parametros.entero[7] = dw_pdn.GetItemNumber(il_fila,'co_fabrica_pt') 
		lstr_parametros.entero[8] = dw_pdn.GetItemNumber(il_fila,'co_linea') 
		lstr_parametros.entero[9] = dw_pdn.GetItemNumber(il_fila,'co_referencia') 
		lstr_parametros.entero[10] = dw_pdn.GetItemNumber(il_fila,'co_color_pt') 
		lstr_parametros.cadena[3] = dw_pdn.GetItemString(il_fila,'tono') 
		lstr_parametros.entero[11] = dw_pdn.GetItemNumber(il_fila,'ca_programada')
		lstr_parametros.entero[12] = dw_pdn.GetItemNumber(il_fila,'cs_particion')
		
		OpenWithParm(w_parametros_particion,lstr_parametros)
	
	//-----------------------------  retrieve con modulo 701 ---------------------------//
		dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro, li_anno_critica, li_semana_critica,il_planta_proceso)
	Else
		MessageBox('Advertencia','No se ha seleccionado el registro a particionar')
	End if
End if

end event

event ue_consolidar();Long li_filas, li_fabricaexp, li_liberaciones = 0, li_fabrica, li_linea
Long li_fabact, li_linact, li_rollos, li_lib_old, li_lib_new, li_anno_critica, li_semana_critica
Long ll_liberacion, ll_referencia, ll_color, ll_refact, ll_colact, ll_tanda, ll_tandact
String ls_orden, ls_cut, ls_usuario, ls_mensaje
n_cst_liberacion luo_liberacion
n_cts_constantes_tela luo_constantes_tela

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA    ")    

li_lib_old = 0 
li_lib_new = 0 
FOR li_filas = 1 TO dw_pdn.RowCount()
	IF dw_pdn.IsSelected(li_filas) THEN
		li_liberaciones = li_liberaciones + 1
		IF li_liberaciones = 1 THEN
			li_fabrica = dw_pdn.GetItemNumber(li_filas, "co_fabrica_pt")
			li_linea = dw_pdn.GetItemNumber(li_filas, "co_linea")
			ll_referencia = dw_pdn.GetItemNumber(li_filas, "co_referencia")
			ll_color = dw_pdn.GetItemNumber(li_filas, "co_color_pt")
			ll_tanda = dw_pdn.GetItemNumber(li_filas, "tanda")
			
			//se captura el usuario de la primera liberaci$$HEX1$$f300$$ENDHEX$$n para que quede  la nueva liberaci$$HEX1$$f300$$ENDHEX$$n con este usuario
			//esto modifico el llamado del metodo of_consolidar_liberaciones,
			//y en el objecto n_cts_liberacion, se tuvieron que modificar los metodos, of_consolidar_liberacions,
			//of_generar_estilos, of_generar_telas, of_generar_escalas y of_generar_rectilineas.
			//este cambio fue solicitado por Hector Osorno.
			//elaborado jcrm
			//fecha junio 8 de 2006
			ls_usuario = dw_pdn.GetItemString(li_filas,'usuario')
			//fin modificacion jcrm
		END IF
		li_fabricaexp = dw_pdn.GetItemNumber(li_filas, "co_fabrica_exp")
		ll_liberacion = dw_pdn.GetItemNumber(li_filas, "cs_liberacion")
		ls_orden = dw_pdn.GetItemString(li_filas, "po")
		ls_cut = dw_pdn.GetItemString(li_filas, "nu_cut")
		li_fabact = dw_pdn.GetItemNumber(li_filas, "co_fabrica_pt")
		li_linact = dw_pdn.GetItemNumber(li_filas, "co_linea")
		ll_refact = dw_pdn.GetItemNumber(li_filas, "co_referencia")
		ll_colact = dw_pdn.GetItemNumber(li_filas, "co_color_pt")
		ll_tandact = dw_pdn.GetItemNumber(li_filas, "tanda")
		li_rollos = dw_pdn.GetItemNumber(li_filas, "rollos_bodega")
		
		//*********************************************************************************************
		//para validar que las liberaciones que se esten agrupando hallan sido generadas por la misma
		//parte es decir, solo es posible consolidar liberaciones si todas son de proyeccion (criticas)
		//o por demanda (moda)
		//jorodrig - jcrm
		//marzo 7 de 2008
		li_lib_new =  luo_liberacion.of_validartipoliberacion(li_fabricaexp,ll_liberacion,ls_mensaje) 
		IF li_lib_new = -1 THEN
			ROLLBACK;
			MessageBox("Error Base Datos","Error al verificar tipo de liberacion " + ls_mensaje,StopSign!)
			Return
		ELSE
			IF li_lib_new <> li_lib_old AND li_lib_old <> 0 THEN
				ROLLBACK;
				MessageBox("Error","No se pueden consolidar liberaciones por proyecci$$HEX1$$f300$$ENDHEX$$n y por demanda.",StopSign!)
				Return
			ELSE
				li_lib_old = li_lib_new
			END IF
		END IF
		//*********************************************************************************************
		
		IF li_fabrica <> li_fabact OR li_linea <> li_linact OR &
			ll_referencia <> ll_refact OR ll_color <> ll_colact OR ll_tanda <> ll_tandact THEN
			ROLLBACK;
			MessageBox("Advertencia...","Esta mezclando referencias o tandas dentro de las liberaciones seleccionadas",StopSign!)
			Return
		END IF
		IF li_rollos = 0 THEN
			ROLLBACK;
			MessageBox("Advertencia...","Est$$HEX2$$e1002000$$ENDHEX$$seleccionando una liberaci$$HEX1$$f300$$ENDHEX$$n que no tiene todos los rollos en la bodega",StopSign!)
			Return
		END IF
		INSERT INTO t_libera_consolida(usuario, co_fabrica_exp, cs_liberacion, nu_orden, nu_cut, 
			co_fabrica_pt, co_linea, co_referencia, co_color_pt)
		VALUES(:gstr_info_usuario.codigo_usuario, :li_fabricaexp, :ll_liberacion, :ls_orden, :ls_cut,
			:li_fabact, :li_linact, :ll_refact, :ll_colact);
		IF SQLCA.SQLCode = -1 THEN
			ROLLBACK;
			MessageBox("Error Base Datos","Error al insertar registro en tabla temporal. " + SQLCA.SQLErrText,StopSign!)
			Return
		END IF
	END IF
NEXT
IF li_liberaciones > 1 THEN
	IF luo_liberacion.of_validar_consolidacion(SQLCA) = -1 THEN
		ROLLBACK;	
		MessageBox("Advertencia...", luo_liberacion.of_getValidacion(),StopSign!)
		Return
	END IF
	IF luo_liberacion.of_consolidar_liberaciones(SQLCA, ls_usuario) = -1 THEN
		ROLLBACK;
		MessageBox("Advertencia...", luo_liberacion.of_getValidacion(),StopSign!)
		Return
	ELSE
		COMMIT;
	END IF			
ELSE
	DELETE FROM t_libera_consolida
	WHERE usuario = :gstr_info_usuario.codigo_usuario;
	IF SQLCA.SQLCode = -1 THEN
		ROLLBACK;
		MessageBox("Error Base Datos","Error al insertar registro en tabla temporal. " + SQLCA.SQLErrText,StopSign!)
	ELSE
		COMMIT;
	END IF		
END IF
dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro,li_anno_critica, li_semana_critica,il_planta_proceso)
end event

event ue_filtro(unsignedlong wparam, long lparam);IF ib_filtro = FALSE THEN
	ib_filtro = TRUE	
ELSE 
	ib_filtro = FALSE	
END IF
end event

event type long ue_anular();Long li_estado, li_result, li_semana_critica, li_anno_critica
Long ll_ordencorte, ll_ordenpdn, ll_unir_oc, ll_count
String ls_destinatario, ls_asunto, ls_cuerpo, ls_error
n_cts_constantes luo_constantes
//n_cts_send_mail luo_mail
n_cts_constantes_tela luo_constantes_tela

//variable de mensaje del correo
String ls_mensaje
//Long li_codigo_email

uo_correo luo_correo
luo_correo = create uo_correo

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA    ")    
//-----------------------------------se verifica que si tenga una fila seleccionada
If il_fila > 0 Then
	//---------------------solo es posible anular cuando el estado de la producci$$HEX1$$f300$$ENDHEX$$n es 1 $$HEX2$$f3002000$$ENDHEX$$3
	If dw_pdn.GetItemNumber(il_fila,'co_estado_asigna') = 1 Or dw_pdn.GetItemNumber(il_fila,'co_estado_asigna') = 3 Or &
	   dw_pdn.GetItemNumber(il_fila,'co_estado_asigna') = 0 Then
	
		//----------------------se modifica el estado a 28(anulada)
		luo_constantes = Create n_cts_constantes;
	
		li_estado = luo_constantes.of_consultar_numerico("ESTADO ANULADA")
		IF li_estado = -1 THEN
			Messagebox("Advertencia!","No se pudo anular la producci$$HEX1$$f300$$ENDHEX$$n")
			Return -1
		END IF
		
		dw_pdn.SetItem(il_fila,'co_estado_asigna',li_estado)
		dw_pdn.SetItem(il_fila,'fe_actualizacion',DateTime(Today(),Now()))
		dw_pdn.SetItem(il_fila,'usuario',gstr_info_usuario.codigo_usuario)
		dw_pdn.SetItem(il_fila,'instancia',gstr_info_usuario.instancia)
	Else
		MessageBox('Error','El estado en el que se encuentra la producci$$HEX1$$f300$$ENDHEX$$n no permite que esta sea anulada.')
		Return -1
	End if
End if

//antes de anular se verifica que no este asociada a otra orden de corte, para el caso de duos o conjuntos
//jcrm
//abril 14 de 2009
ll_unir_oc = dw_pdn.GetItemNumber(il_fila,'cs_unir_oc')
IF ll_unir_oc > 1 THEN
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_pdnxmodulo
	 WHERE cs_unir_oc = :ll_unir_oc;
	 
	IF ll_count > 1 THEN
		li_result = MessageBox("Pregunta",'La O.C. hace parte de un duo o conjunto, el sistema anulara todas las O.C. que lo conforman esta seguro de seguir.',Exclamation!, OKCancel!, 2)
		IF li_result = 1 THEN
			UPDATE dt_pdnxmodulo
				SET co_estado_asigna = 28,
					 fe_actualizacion = current,
					 usuario = user
			 WHERE cs_unir_oc = :ll_unir_oc;
			 
			IF sqlca.sqlcode = -1 THEN
				ls_error = string(sqlca.sqlerrtext)
				Rollback;
				MessageBox('Error','No fue posible anular las O.C., ERROR: '+ls_error)
				Return -1
			END IF
		ELSE
			Return 0
		END IF
	END IF
END IF


//-------------------------se actualiza dw_pdn, quedando el registro anulado
IF ll_count <= 0 or (ll_count = 1 and ll_unir_oc > 1) THEN
	If dw_pdn.Update() = -1 Then
		rollback ;
		Messagebox("Advertencia!","No se pudo anular la producci$$HEX1$$f300$$ENDHEX$$n")
		Return -1
	END IF
END IF	
//Else
	Commit;
	//en este punto se debe generar el correo avisando que la orden de corte fue anulada
	//para esto se debe usar el user object n_cts_send_mail e invocar la funcion
	//of_sendmail enviando los parametros
	//as_asunto, donde se debe colocar el asunto del correo
	//as_destinatario persona o grupo de personas a la que va dirigido el correo
	//as_cuerpo una breve descripcion donde se debe informar el numero de orden anulada.
	
	//traigo la orden de corte y la de produccion
	ll_ordencorte = dw_pdn.GetItemNumber(il_fila,'cs_agrupacion')
	ll_ordenpdn   = dw_pdn.GetItemNumber(il_fila,'cs_ordenpd_pt')
	
	If isnull(ll_ordencorte) Then ll_ordencorte = 0
	If isnull(ll_ordenpdn) Then ll_ordenpdn = 0
	
	//SA56209 - Ceiba/reariase - 01-02-2017
	//envio de correo:verifico el usuario al cual se le envia el correo advirtiendo la anulacion
	
	/*Dbedocal
	SELECT MIN(usuario)
	  INTO :ls_destinatario
	  FROM h_ordenpd_te
	 WHERE cs_ordenpd_pt = :ll_ordenpdn;
	*/ 
	//if li_codigo_email <> -1 then 
		ls_mensaje = 'La orden de corte No. '+String(ll_ordencorte)+' perteneciente a la orden de producci$$HEX1$$f300$$ENDHEX$$n No. '+String(ll_ordenpdn)+' Fue anulada.'
		try
			luo_correo.of_enviar_correo('Anulacion Orden de Corte', ls_mensaje, 'anular_orden_corte')
		catch(	Exception ex)
			Messagebox("Error", ex.getmessage())
		end try 
	//end if
	//Fin SA56209
 
//ls_destinatario = 'jcrestme' 
//-----------------------------  retrieve  ---------------------------//
dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro, li_anno_critica,li_semana_critica,il_planta_proceso)

Return 1
end event

event ue_agrupar_referencias();Long   	ll_fila,ll_fab,ll_ref,ll_filins,ll_agrupa,ll_rseult, li_lib, li_priori, ll_color
Long    	li_fabpt,li_lin,li_cspar,li_simulacion, li_rollos
Long  li_fabrica_ant, li_linea_ant, li_filas, li_semana_critica, li_anno_critica
Long 	li_fab,li_planta, li_agrupada
LONG		li_mod, ll_referencia_ant
String 	ls_po,ls_tono,ls_mensaje,ls_sqlerr,ls_instruccion, ls_cut
DATE	 	ld_fecha
Decimal{2} ld_ancho, ld_ancho_inicial, ld_diferencia_ancho
n_cts_param luo_parametros

n_cts_corte_una luo_corte
n_cts_constantes luo_constantes
n_cts_constantes_tela luo_constantes_tela

li_semana_critica = luo_constantes_tela.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes_tela.of_consultar_numerico("ANO_CRITICA         ")

luo_corte = Create n_cts_corte_una
luo_constantes = Create n_cts_constantes

ld_diferencia_ancho = luo_constantes.of_consultar_numerico("DIFERENCIA ANCHO")

IF ld_diferencia_ancho = -1 THEN
	ld_diferencia_ancho = 0
END IF

//-------------------------  limpia dw_pdnagrupa ----------------------//
dw_pdnagrupa.Reset()

//-------------------------  valida que tenga filas seleccionadas -----//
If dw_pdn.GetSelectedRow(0) <= 0 Then 
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar las producciones que desea agrupar.")
	Return
End If

ll_fila = 0
//------------------  ciclo para cargar dw_pdnagrupa con selecc. de dw_pdn -----------//
Do 
	ll_fila = dw_pdn.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then
		//----------------------  valida que estado = 1 -------------------------------//
		If dw_pdn.GetItemNumber(ll_fila,'sw_estado') <> 1 Then
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La producci$$HEX1$$f300$$ENDHEX$$n en el item " + String(ll_fila) + " no puede ser agrupada." )
			Return
		Else
			li_simulacion	= dw_pdn.GetItemNumber(ll_fila,'simulacion')
			ll_fab    		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica_exp')
			li_lib   		= dw_pdn.GetItemNumber(ll_fila,'cs_liberacion')
			ls_po    		= dw_pdn.GetItemString(ll_fila,'po')
			ls_cut			= dw_pdn.GetItemString(ll_fila,'nu_cut')
			li_fabpt 		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica_pt')
			li_lin   		= dw_pdn.GetItemNumber(ll_fila,'co_linea')
			ll_ref   		= dw_pdn.GetItemNumber(ll_fila,'co_referencia')
			ll_color 		= dw_pdn.GetItemNumber(ll_fila,'co_color_pt')
			li_cspar 		= dw_pdn.GetItemNumber(ll_fila,'cs_particion')
			ls_tono  		= dw_pdn.GetItemString(ll_fila,'tono')
			li_priori		= dw_pdn.GetItemNumber(ll_fila,'cs_prioridad')
			li_fab   		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica')
			li_planta		= dw_pdn.GetItemNumber(ll_fila,'co_planta')
			li_mod			= dw_pdn.GetItemNumber(ll_fila,'co_modulo')
			ld_ancho			= dw_pdn.GetItemNumber(ll_fila,'ancho')
			li_rollos		= dw_pdn.GetItemNumber(ll_fila,'rollos_bodega')
			
			IF li_rollos = 0 THEN
				MessageBox("Advertencia...","Esta agrupando liberaciones sin rollos en la bodega")
				dw_pdnagrupa.Reset()
				Return
			END IF				
	
			dw_pdn.SetItem(ll_fila,'co_estado_asigna',3)
			
			ll_filins = dw_pdnagrupa.InsertRow(0)
//			IF ll_filins = 1 THEN
//				ld_ancho_inicial = ld_ancho
//			ELSE
//				IF Abs(ld_ancho - ld_ancho_inicial) > ld_diferencia_ancho THEN
//					MessageBox("Advertencia...","Esta agrupando liberaciones con diferencia en ancho mayor al permitido")
//					dw_pdnagrupa.Reset()
//					Return
//				END IF
//			END IF
			
			dw_pdnagrupa.SetItem(ll_filins,'co_fabrica_exp',ll_fab)
			dw_pdnagrupa.SetItem(ll_filins,'cs_liberacion',li_lib)
			dw_pdnagrupa.SetItem(ll_filins,'po',ls_po)
			dw_pdnagrupa.SetItem(ll_filins,'nu_cut',ls_cut)
			dw_pdnagrupa.SetItem(ll_filins,'co_fabrica_pt',li_fabpt)
			dw_pdnagrupa.SetItem(ll_filins,'co_linea',li_lin)
			dw_pdnagrupa.SetItem(ll_filins,'co_referencia',ll_ref)
			dw_pdnagrupa.SetItem(ll_filins,'co_color_pt',ll_color)
			dw_pdnagrupa.SetItem(ll_filins,'cs_particion',li_cspar)
			dw_pdnagrupa.SetItem(ll_filins,'tono',ls_tono)
			dw_pdnagrupa.SetItem(ll_filins,'ca_unidades',dw_pdn.GetItemNumber(ll_fila,'ca_programada'))
			dw_pdnagrupa.SetItem(ll_filins,'de_linea',dw_pdn.GetItemString(ll_fila,'de_linea'))
			dw_pdnagrupa.SetItem(ll_filins,'de_referencia',dw_pdn.GetItemString(ll_fila,'de_referencia'))
			dw_pdnagrupa.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
			dw_pdnagrupa.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)
			
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
					  ( dt_programa_diario.cs_liberacion 		= dt_pdnxmodulo.cs_liberacion ) and  
					  ( dt_programa_diario.po 						= dt_pdnxmodulo.po ) and  
					  ( dt_programa_diario.nu_cut					= dt_pdnxmodulo.nu_cut ) and
					  ( dt_programa_diario.co_fabrica_pt 		= dt_pdnxmodulo.co_fabrica_pt ) and  
					  ( dt_programa_diario.co_linea 				= dt_pdnxmodulo.co_linea ) and  
					  ( dt_programa_diario.co_referencia 		= dt_pdnxmodulo.co_referencia ) and  
					  ( dt_programa_diario.co_color_pt 			= dt_pdnxmodulo.co_color_pt ) and  
					  ( dt_programa_diario.tono 					= dt_pdnxmodulo.tono ) and  
					  ( dt_programa_diario.cs_particion 		= dt_pdnxmodulo.cs_particion ) and  
					  ( dt_pdnxmodulo.simulacion 					= 1 ) and  
					  ( dt_pdnxmodulo.co_fabrica 					= :li_fabpt ) and  
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
			
			If luo_corte.Of_MetodoMinutos(1,li_fab,li_planta,li_mod,li_priori,ld_fecha) = -1 Then
				Rollback;
				Return
			End if
			//fin de programa fechas
		End If
	End If
loop Until ll_fila = 0

COMMIT;

//------------------ si cargo dw_pdnagrupa ----------------------------//
If dw_pdnagrupa.RowCount() > 0 Then
	//pregunta si crea a add a agrupacion -------------------//
	ls_mensaje = "$$HEX1$$bf00$$ENDHEX$$Desea crear una nueva agrupaci$$HEX1$$f300$$ENDHEX$$n?~n~nSi responde que no, inmediatamente despues debe seleccionar una producci$$HEX1$$f300$$ENDHEX$$n con una agrupaci$$HEX1$$f300$$ENDHEX$$n valida."
	ll_rseult = MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!",ls_mensaje,Question!,YesNoCancel!)
	//-------------  si desea crear agrupacion -------------------------------//
	If ll_rseult = 1 Then
		ll_agrupa = of_CrearAgrupa()
		
		MessageBox('Agrupacion',String(ll_agrupa))
		
		dw_pdnagrupa.Sort()
		
		li_fabrica_ant = dw_pdnagrupa.GetItemNumber(1, 'co_fabrica_pt')
		li_linea_ant = dw_pdnagrupa.GetItemNumber(1, 'co_linea')
		ll_referencia_ant = dw_pdnagrupa.GetItemNumber(1, 'co_referencia')
	
		li_agrupada = 0
		
		FOR li_filas = 2 TO dw_pdnagrupa.RowCount()
			li_fabpt = dw_pdnagrupa.GetItemNumber(li_filas, 'co_fabrica_pt')
			li_lin = dw_pdnagrupa.GetItemNumber(li_filas, 'co_linea')
			ll_ref = dw_pdnagrupa.GetItemNumber(li_filas, 'co_referencia')
	
			IF li_fabrica_ant <> li_fabpt OR li_linea_ant <> li_lin OR ll_referencia_ant <> ll_ref THEN
				li_agrupada = 1
			END IF
		NEXT
		
		If ll_agrupa > 0 Then 
			If Of_detalleTrazo(ll_agrupa) > 0 Then 
				//commit ;
				//MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
				dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro,li_anno_critica,li_semana_critica,il_planta_proceso)
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
	If of_orden_corte() = -1 Then
		Rollback;
	Else
		Commit;
		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
		If li_agrupada = 1 Then
			luo_parametros.il_vector[1] = ll_agrupa
			OpenWithParm(w_definir_rayas_agrupacion, luo_parametros)
		End if
	End if
	dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro,li_anno_critica,li_semana_critica,il_planta_proceso)
End if
//fin de la modificacion jcrm

Destroy n_cts_corte_una
end event

event ue_grupos();Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_pdn.GetRow()

If ll_fila > 0 Then
	lstr_parametros.entero[1] = dw_pdn.GetItemNumber(ll_fila,'co_fabrica_exp')
	lstr_parametros.cadena[1] = dw_pdn.GetItemString(ll_fila,'po')
	
	OpenWithParm (w_grupos, lstr_parametros)
End if



end event

event ue_proporcion();//evento para mostrar la proporcion utilizada al momento de generar la liberacion de la produccion
//jcrm
//febrero 28 de 2008
s_base_parametros lstr_parametros

lstr_parametros.entero[1] = dw_pdn.GetItemNumber(il_fila,'cs_liberacion')


OpenWithParm ( w_proporcion_liberacion, lstr_parametros)

end event

event ue_lote();//evento para mostrar los lotes utilizados con sus rollos
//jcrm
//febrero 28 de 2008
s_base_parametros lstr_parametros

lstr_parametros.entero[1] = dw_pdn.GetItemNumber(il_fila,'cs_liberacion')


OpenWithParm ( w_rollos_lote, lstr_parametros)
end event

event ue_habilitar_produccion();//evento para permitir colocar una OC en estado de programar (co_estado_asigna = 1) y (cs_asignacion = 1)
//jcrm
//noviembre 12 de 2008
Long ll_fila, ll_unir_oc, ll_op, ll_oc, ll_ref,ll_color_pt
Long li_fab, li_lin
String ls_po

ll_fila = dw_pdn.GetRow()

IF ll_fila <= 0 THEN
	MessageBox('Error','Fila no valida.',StopSign!)
	Return
ELSE
	//se verifica que no sea un duo o conjunto
	ll_unir_oc = dw_pdn.GetItemNumber(ll_fila,'cs_unir_oc')
	
	IF ll_unir_oc > 0 THEN
		MessageBox('Advertencia','La producci$$HEX1$$f300$$ENDHEX$$n hace parte de un d$$HEX1$$fa00$$ENDHEX$$o o conjunto, no es posible habilitarla, consulte con inform$$HEX1$$e100$$ENDHEX$$tica',Exclamation!)
		Return
	END IF
	IF gstr_info_usuario.codigo_perfil <> 9 and  gstr_info_usuario.codigo_perfil <> 19 Then
		IF gstr_info_usuario.codigo_usuario = 'fasernap' THEN
			//se permite realizar el cambio pero no se pueden tener en cuenta los registros que ya fueron loteados o anulados
			//co_estado_asiga IN (15, 28)
			li_fab 		= dw_pdn.GetItemNumber(ll_fila,'co_fabrica_pt')
			li_lin 		= dw_pdn.GetItemNumber(ll_fila,'co_linea')
			ll_ref 		= dw_pdn.GetItemNumber(ll_fila,'co_referencia')
			ll_color_pt = dw_pdn.GetItemNumber(ll_fila,'co_color_pt')
			ll_op 		= dw_pdn.GetItemNumber(ll_fila,'cs_ordenpd_pt')
			ll_oc 		= dw_pdn.GetItemNumber(ll_fila,'cs_asignacion')
			ls_po 		= dw_pdn.GetItemString(ll_fila,'po')
			
			UPDATE dt_pdnxmodulo
			   SET cs_asignacion 	= 1,
					 co_estado_asigna = 1
			 WHERE co_fabrica_pt = :li_fab
			   AND co_linea 		= :li_lin
				AND co_referencia = :ll_ref
				AND co_color_pt 	= :ll_color_pt
				AND cs_ordenpd_pt = :ll_op
				AND cs_asignacion = :ll_oc
				AND po 				= :ls_po
				AND co_estado_asigna not in (15, 28);
				
				
			IF sqlca.sqlcode = -1 THEN
				Rollback;
				MessageBox('Error','Ocurrio un error al momento de habilitar la producci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
				Return
			ELSE
				Commit;
				MessageBox('Exito','La producci$$HEX2$$f3002000$$ENDHEX$$fue modificada, por favor verifique la informaci$$HEX1$$f300$$ENDHEX$$n.')
			END IF
			
		ELSE
			//el cambio no puede habilitarse
			MessageBox('Advertencia','Usuario no habilitado para ejecutar esta opci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
		END IF
	END IF
END IF
end event

event ue_programar_automatico();//generar la programacion automatica de la orden de corte
//jorodrig   sep 14 - 09
Long	li_paquetes, li_result, ll_registros, ll_regactual, ll_fila2
String	ls_error, ls_usuario
n_cts_param luo_param
n_cts_recalcular_unidades luo_unidades
n_cst_orden_corte luo_orden_cte
s_base_parametros  lstr_param
s_base_parametros_seleccionar lstr_parametros_seleccionar
Datastore ls_trazos_definidos

Long    ll_cspdn,ll_ref,ll_j,ll_cnt,ll_modulo,ll_raya,ll_fab,ll_pedido,ll_base,&
        ll_result,ll_modelo,ll_reftl,ll_carac,ll_diam,ll_color,ll_found,&
		  ll_bsins,ll_unid, li_lib, ll_co_color
Long li_i,li_tipo,li_fabpt,li_lin,li_csest,li_cspar,&
        li_talla,li_csorden,li_raya,li_ryax, li_fabtela, li_sin_trazos, li_planta
String  ls_sqlerr,ls_po,ls_tono, ls_cut
n_cts_constantes luo_constantes

//------------------------------  crea datastores
ls_trazos_definidos = Create Datastore
//------------------------------  asigna datastores
ls_trazos_definidos.DataObject 	= 'dgr_trazos_recalculo'
ls_trazos_definidos.SetTransObject(Sqlca)

ls_usuario =  gstr_info_usuario.codigo_usuario

il_agrup = dw_pdn.GetItemNumber(il_fila,'cs_agrupacion')
IF IsNull(il_agrup) OR il_agrup = 0 THEN

	//generaer la agrupacion y el consecutivo de orden de corte, fechas y estado Aprobada
	This.Triggerevent("ue_trazos")
END IF

li_planta = dw_pdn.GetItemNumber(il_fila,'co_planta')

dw_pdn.Accepttext()

//temporal para probar los trazos
il_agrup = dw_pdn.GetItemNumber(il_fila,'cs_agrupacion')
il_ordcte = dw_pdn.GetItemNumber(il_fila,'cs_asignacion')

IF IsNull(il_agrup) OR IsNull(il_ordcte) THEN
	MessageBox("Error Base Datos","Error al buscar la agrupacion y la orden de corte para procesar")
	Return
	
END IF
	
li_sin_trazos = 0

	
//buscar los trazos
li_result = luo_unidades.of_carga_automatica_trazos(il_agrup,il_ordcte)
IF li_result = 1 THEN
	luo_param.is_vector[1] = ls_usuario
	luo_param.il_vector[1] = il_agrup
	OpenWithParm(w_tmp_trazos_sirve, luo_param)
	lstr_parametros_seleccionar	= Message.PowerObjectParm
	IF lstr_parametros_seleccionar.hay_parametros THEN
		ll_registros = lstr_parametros_seleccionar.entero1[1]
				
		FOR ll_regactual = 2 TO ll_registros
			ll_fila2 = ls_trazos_definidos.InsertRow(0)
  			ls_trazos_definidos.SetItem(ll_fila2,'cs_agrupacion',lstr_parametros_seleccionar.entero1[ll_regactual])
			ls_trazos_definidos.SetItem(ll_fila2,'cs_pdn',lstr_parametros_seleccionar.entero2[ll_regactual])
			ls_trazos_definidos.SetItem(ll_fila2,'raya',lstr_parametros_seleccionar.entero3[ll_regactual])
			ls_trazos_definidos.SetItem(ll_fila2,'co_trazo',lstr_parametros_seleccionar.entero4[ll_regactual])
			ls_trazos_definidos.SetItem(ll_fila2,'ca_capas',lstr_parametros_seleccionar.entero5[ll_regactual])
			ls_trazos_definidos.SetItem(ll_fila2,'fe_actualizacion',DateTime(Today(),Now()))
			ls_trazos_definidos.SetItem(ll_fila2,'fe_creacion',DateTime(Today(),Now()))
			ls_trazos_definidos.SetItem(ll_fila2,'usuario',gstr_info_usuario.codigo_usuario)
			ls_trazos_definidos.SetItem(ll_fila2,'instancia',gstr_info_usuario.instancia)
			
		NEXT
		IF ls_trazos_definidos.AcceptText() = 1 THEN
			IF ls_trazos_definidos.Update() = 1 THEN
				COMMIT;
			ELSE
				ROLLBACK;
				MessageBox("Error Base Datos","Error al grabar los trazos a utilizar")
				Return
			END IF
		ELSE
			MessageBox("Advertencia","Error al actualizar los trazos a utilizar")
			Return
		END IF
////	
		
	ELSE
		Rollback;
		MessageBox('Advertencia','Se cancel$$HEX2$$f3002000$$ENDHEX$$la generacion automatica')
		Return
	END IF
	
	
ELSE
	IF MessageBox("Verificacion", "Desea Continuar sin ningun trazo?", Question!, YesNo!, 2) = 2 THEN
		Return
	END IF
	li_sin_trazos = 1
END IF


//recalcular unidades
IF il_agrup > 0 AND il_ordcte > 0 THEN
	IF luo_unidades.of_recalcularoc(il_agrup, il_ordcte) = 0 THEN  //esta correcto
	ELSE
		MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error realizando el rec$$HEX1$$e100$$ENDHEX$$lculo de unidades')
		Return
	END IF
ELSE
	MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error realizando el proceso')
	Return
END IF

IF luo_orden_cte.of_prog_auto_con_trazo(il_agrup,il_ordcte) = 1 THEN
	COMMIT;
	MessageBox('...O.K...','El proceso de programaci$$HEX1$$f300$$ENDHEX$$n termino correctamente, debe generar la orden de corte y verificar los trazos')
END IF


////generar la orden de corte   se activa el 18 enero 2010,  jorodrig
//DECLARE loteo PROCEDURE FOR
//	pr_generar_ordencr(:il_ordcte,:gstr_info_usuario.co_planta_pro);
//EXECUTE loteo;
//IF SQLCA.SQLCode = -1 THEN	
//	IF SQLCA.SQLDBCode = -746 THEN
//		ls_error = SQLCA.SQLErrText
//		ROLLBACK;
//		CLOSE(w_retroalimentacion)
//		MessageBox("Error Base Datos",ls_error)
//		Return
//		//MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
//	ELSE
//		ls_error = SQLCA.SQLErrText
//		ROLLBACK;
//		CLOSE(w_retroalimentacion)
//		MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_generar_ordencr. " +ls_error)
//		Return
//	END IF
//	//ROLLBACK;
//ELSE
//	COMMIT;
//	MessageBox('O.K.','El proceso de generacion de la orden termino bien, puede imprimir el reporte')
//END IF

DESTROY ls_trazos_definidos;

RETURN 
end event

event ue_anular_reposo();
of_anular_reposo()
end event

public function long of_crearagrupa ();Long   ll_agrupa
String ls_sqlerr

//------------------------------------- busca max agrupacion
select max(cs_agrupacion)  
  into :ll_agrupa  
  from h_agrupa_pdn ;
  
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","No se pudo seleccionar el consecutivo de la agrupaci$$HEX1$$f200$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
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
	MessageBox("Advertencia!","No se pudo seleccionar el consecutivo de la agrupaci$$HEX1$$f200$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
	Return -1
End If

Return ll_agrupa
	

end function

public function long of_borraragrupa (long an_fila);//DataStore lds_mdpdn,lds_mdsnpdn
DataStore lds_pdnadr
Long   ll_agrupa,ll_fila,ll_ref,ll_color,ll_modulo, li_cslib
String ls_sqlerr,ls_po,ls_tono, ls_cut
Long    li_fabexp,li_fabpt,li_linea,li_cspar,li_i



//------------------------------- crea datastore lds_pdnadr
lds_pdnadr   = Create DataStore
//lds_mdsnpdn = Create DataStore

//------------------------------- asigna dw d_borrar_dt_agrupacion (dt_agrupa_pdn) a datastore
lds_pdnadr.DataObject = 'd_borrar_dt_agrupacion'
//lds_mdsnpdn.DataObject = 'd_borrar_rayas_agrupacion_no_pdn'

lds_pdnadr.SetTransObject(Sqlca)
//lds_mdsnpdn.SetTransObject(Sqlca)

//------------------------------- trae agrupacion a borrar
ll_agrupa = dw_pdn.GetItemNumber(an_fila,'cs_agrupacion')
ll_modulo = dw_pdn.GetItemNumber(an_fila,'co_modulo')
//------------------------------ recupera la agrupacion a borrar en datastore
lds_pdnadr.Retrieve(ll_agrupa)

//------------------------------ ciclo sobre dt_agrupapdn de la agrupacion
For li_i = 1 To lds_pdnadr.RowCount()
	
	li_fabexp = lds_pdnadr.GetItemNumber(li_i,'co_fabrica_exp')
	li_cslib  = lds_pdnadr.GetItemNumber(li_i,'cs_liberacion')
	ls_po     = lds_pdnadr.GetItemString(li_i,'po')
	ls_cut	 = lds_pdnadr.GetItemString(li_i,'nu_cut')
	li_fabpt  = lds_pdnadr.GetItemNumber(li_i,'co_fabrica_pt')
	li_linea  = lds_pdnadr.GetItemNumber(li_i,'co_linea')
	ll_ref    = lds_pdnadr.GetItemNumber(li_i,'co_referencia')
	ll_color  = lds_pdnadr.GetItemNumber(li_i,'co_color_pt')
	ls_tono   = lds_pdnadr.GetItemString(li_i,'tono')
	li_cspar  = lds_pdnadr.GetItemNumber(li_i,'cs_particion')
		
	//-------------------------------- actualiza estado =1 a dt_pdnxmodulo	
	update dt_pdnxmodulo  
		set co_estado_asigna = 1,
			 cs_asignacion    = 1	
	 where dt_pdnxmodulo.simulacion 				= 1 and 
			 dt_pdnxmodulo.co_fabrica 				= :ii_fabrica and 
			 dt_pdnxmodulo.co_planta 				= :ii_planta and  
			 dt_pdnxmodulo.co_modulo 				= :ll_modulo and
			 dt_pdnxmodulo.co_fabrica_exp 		= :li_fabexp and  
			 dt_pdnxmodulo.cs_liberacion 			= :li_cslib and 
			 dt_pdnxmodulo.po 						= :ls_po and
			 dt_pdnxmodulo.nu_cut					= :ls_cut and
			 dt_pdnxmodulo.co_fabrica_pt 			= :li_fabpt and
			 dt_pdnxmodulo.co_linea 				= :li_linea and
			 dt_pdnxmodulo.co_referencia 			= :ll_ref and
			 dt_pdnxmodulo.co_color_pt 			= :ll_color and 
			 dt_pdnxmodulo.tono 						= :ls_tono and 
			 dt_pdnxmodulo.cs_particion 			= :li_cspar  ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback;
		MessageBox("Advertencia!","No se pudo borrar los trazos para esta agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
		Return -1
	End If	
Next

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
	MessageBox("Advertencia!","No se pudo borrar la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If


destroy lds_pdnadr

Return 0
end function

public subroutine of_seleccionar_agrupacion (long al_fila);Long li_linea, li_linea2, li_rollos
Long ll_ref, ll_color, ll_ordenpd, ll_tanda, ll_fila
Long ll_ref2, ll_color2, ll_ordenpd2, ll_tanda2
Decimal{2} ldc_ancho, ldc_ancho2
String ls_po, ls_po2
//determinos los valores de la fila que acaban de seleccionar
li_linea 	= dw_pdn.GetItemNumber(al_fila,'co_linea')
ll_ref 		= dw_pdn.GetItemNumber(al_fila,'co_referencia')
ll_color 	= dw_pdn.GetItemNumber(al_fila,'co_color_pt')
ll_ordenpd 	= dw_pdn.GetItemNumber(al_fila,'cs_ordenpd_pt')
ll_tanda 	= dw_pdn.GetItemNumber(al_fila,'tanda')
ldc_ancho   = dw_pdn.GetItemNumber(al_fila,'ancho')
ls_po			= dw_pdn.GetItemString(al_fila,'po')

FOR ll_fila = 1 TO dw_pdn.RowCount()
	//miramos que filan son iguales a la fila seleccionada
	li_linea2 	= dw_pdn.GetItemNumber(ll_fila,'co_linea')
	ll_ref2 		= dw_pdn.GetItemNumber(ll_fila,'co_referencia')
	ll_color2	= dw_pdn.GetItemNumber(ll_fila,'co_color_pt')
	ll_ordenpd2 = dw_pdn.GetItemNumber(ll_fila,'cs_ordenpd_pt')
	ll_tanda2 	= dw_pdn.GetItemNumber(ll_fila,'tanda')
	ldc_ancho2  = dw_pdn.GetItemNumber(ll_fila,'ancho')
	ls_po2		= dw_pdn.GetItemString(ll_fila,'po')
	li_rollos	= dw_pdn.GetItemNumber(ll_fila,'rollos_bodega')
	
	IF li_linea = li_linea2 AND ll_ref = ll_ref2 AND ll_color = ll_color2 AND ll_ordenpd = ll_ordenpd2 AND &
	   ll_tanda = ll_tanda2 AND ldc_ancho = ldc_ancho2 AND ls_po = ls_po2 AND li_rollos <> 0 THEN
		dw_pdn.SelectRow(ll_fila, TRUE)
	END IF
NEXT
end subroutine

public function long of_orden_corte ();//genera el numero de orden de corte para toda una misma agrupacion, ya que cada que se agrupa, dicha
//agrupacion es la unica que en ese momento tiene como estado de asignacion 3 y como numero de
//orden de corte 1.
//realizado por juan carlos restrepo medina abril 25 de 2003

Long ll_fila,ll_num_reg,ll_cs_liberacion,ll_cs_prioridad,ll_cs_asignacion,ll_co_estado_asigna,ll_co_est_asig_old,&
	  ll_i,ll_incremento,ll_nuenqueesta,ll_co_fabrica_exp,ll_pedido,ll_co_fabrica_pt,ll_co_linea,ll_co_referencia,&
	  ll_co_color_pt,ll_cs_estilocolortono,ll_numero_agrupa,ll_estado_asigna,ll_i2,&
	  ll_cs_agrupacion,ll_fil,ll_agrupa,ll_agrupa2,ll_ca_pendiente,ll_co_estado_asigna2,ll_unir_oc
String ls_po,ls_referencia,ls_gpa,ls_color,ls_body,ls_tono
DateTime ldt_fe_ini_prog,ldt_fe_fin_prog
TRANSACTION			itr_oc

dw_pdn.AcceptText()

sw_estado = 0

//
//itr_oc 				= 	Create Transaction
//itr_oc.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
//itr_oc.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
//itr_oc.USERID		=	SQLCA.USERID
//itr_oc.DBPASS		=	SQLCA.DBPASS
//itr_oc.DBPARM		=	"connectstring='DSN="+itr_oc.DATABASE+";UID="+itr_oc.USERID+";PWD="+itr_oc.DBPASS+"'"
//itr_oc.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
//itr_oc.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Cursor Stability")
//
//CONNECT USING itr_oc;
//IF itr_oc.SQLCODE = -1 THEN
//   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +itr_oc.sqlerrtext,Stopsign!,OK!)
//   Return -1 
//END IF

dw_pdn.Accepttext()
//Recorro la dw para determinar que registros cambiaron de estado de asignacion  a 3 , a los que cumplan se les asigna
//la orden de corte si esta es igual a 1
FOR ll_i = 1 TO dw_pdn.RowCount()
	ll_co_estado_asigna = dw_pdn.getitemnumber(ll_i,'co_estado_asigna')
	ll_co_est_asig_old = dw_pdn.GetItemNumber(ll_i,'espejo_asignacion')
	ll_cs_asignacion = dw_pdn.GetItemNumber(ll_i,'cs_asignacion') 
	ll_unir_oc = dw_pdn.GetItemNumber(ll_i,'cs_unir_oc')
	
	IF ll_co_estado_asigna = 3 AND ll_cs_asignacion = 1  THEN
		//****************************inicio modificacion
		//modificacion realizada por juan carlos restrepo medina a la manera de capturar el consecutivo,
		//anteriormente se buscaba el numero del consecutivo y luego se actualizaba este en bd, con esto
		//era posible que dos procesos corriendo en simultaneo tomaran el mismo consecutivo y luego los 
		//dos actualizaran el mismo numero, ahorra se va hacer primero el update con lo que se garantiza que dos procesos
		//simultaneos no lo pueden hacer y luego si se consultara el consecutivo.
		//fecha marzo de 2005
		
		//primero actualizo el consecutivo en bd
		update cf_consc_ordenes
			set nu_enque_esta = nu_enque_esta + 1 
			where ( cf_consc_ordenes.tipo_orden = 7 ) and
					( cf_consc_ordenes.co_fabrica = 2 );
		//	using itr_oc;
					
		//If itr_oc.sqlcode <> 0 Then
		IF sqlca.sqlcode <> 0 then
			MessageBox('Error','No fue posible generar el consecutivo de la O.C.'+ itr_oc.SqlErrText, StopSign!)
			sw_estado = 1
	//		DISCONNECT USING itr_oc ;
			Return -1 
		Else
			//si fue exitosa la actualizaci$$HEX1$$f300$$ENDHEX$$n, seleccionamos el consecutivo
			select cf_consc_ordenes.nu_enque_esta  
			  into :ll_nuenqueesta  
			  from cf_consc_ordenes  
			 where ( cf_consc_ordenes.tipo_orden = 7 ) and  
					 ( cf_consc_ordenes.co_fabrica = 2 );
		//	 using itr_oc;
			
			IF sqlca.SQLCode <> 0 OR ISNULL(ll_nuenqueesta) THEN
//					IF itr_oc.SQLCode <> 0 OR ISNULL(ll_nuenqueesta) THEN
				MessageBox("Error","No se pudo encontrar el consecutivo de ordenes de corte, comuniquese con sistemas por favor", StopSign!)
				sw_estado = 1
				Return -1
			End if
			
		End if
		//*******************************fin modificacion	
		
		//generar la orden de corte para todas las agrupaciones
		//ademas se coloca el mismo numerio de unir oc para que no presente inconsistencias de diferentes 
		//consecutivos de duos por tener una OP varias liberaciones
		FOR ll_i2 = 1 TO dw_pdn.RowCount()
			ll_co_estado_asigna2 = dw_pdn.getitemnumber(ll_i2,'co_estado_asigna')
			IF dw_pdn.GetItemNumber(ll_i2,'cs_asignacion') = 1 THEN
				IF ll_co_estado_asigna2 = 3  THEN
					dw_pdn.Setitem(ll_i2,'cs_asignacion',ll_nuenqueesta)
					dw_pdn.SetItem(ll_i2,'cs_unir_oc',ll_unir_oc)
					dw_pdn.SetItem(ll_i2,'co_estado_asigna',6)
					
					il_ordcte = ll_nuenqueesta
				END IF
			END IF
		NEXT
		dw_pdn.update()
		//commit using itr_oc;
		commit;
	END IF
NEXT

//DISCONNECT USING itr_oc ;
//IF itr_oc.SQLCODE = -1 THEN
//   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +itr_oc.sqlerrtext,Stopsign!,OK!)
//   Return -1
//END IF

Return 0
end function

public function long of_detalletrazo (long an_agrupa);Datastore lds_tallas,lds_rayas,lds_colmod,lds_pdntz,lds_tlltz
DataWindow ldw_datos
Long    ll_cspdn,ll_ref,ll_j,ll_cnt,ll_modulo,ll_raya,ll_fab,ll_pedido,ll_base,&
        ll_result,ll_modelo,ll_reftl,ll_carac,ll_diam,ll_color,ll_found,&
		  ll_bsins,ll_unid, li_lib, ll_pendie, ll_co_color
Long li_i,li_tipo,li_fabpt,li_lin,li_csest,li_cspar,&
        li_talla,li_csorden,li_raya,li_ryax, li_fabtela
String  ls_sqlerr,ls_po,ls_tono, ls_cut
Decimal ld_ancho_prueba
n_cts_constantes luo_constantes

//------------------------------  crea datastores
lds_tallas = Create Datastore
lds_rayas  = Create Datastore
lds_colmod = Create Datastore
lds_pdntz  = Create Datastore
lds_tlltz  = Create Datastore

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

luo_constantes = Create n_cts_constantes

li_fabtela = luo_constantes.of_consultar_numerico("FABRICA TELA")
IF li_fabtela = -1 THEN
	Return -1
END IF

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
For li_i = 1 To dw_pdnagrupa.RowCount()
	
	ld_ancho_prueba = dw_pdnagrupa.GetitemNumber(li_i,'ancho')
	ll_cspdn ++	
	dw_pdnagrupa.SetItem(li_i,'cs_agrupacion',an_agrupa)
	dw_pdnagrupa.SetItem(li_i,'cs_pdn',ll_cspdn)
Next

dw_pdnagrupa.AcceptText()

//----------------------------------- graba dw_pdnagrupa
If dw_pdnagrupa.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo grabar la producci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

//---------------------------------------- recorre dt_pdnagrupa para insert tallas y rayas
For li_i = 1 To dw_pdnagrupa.RowCount()

	ll_fab    	= dw_pdnagrupa.GetItemNumber(li_i,'co_fabrica_exp')
	li_lib   	= dw_pdnagrupa.GetItemNumber(li_i,'cs_liberacion')
	ls_po    	= dw_pdnagrupa.GetItemString(li_i,'po')
	ls_cut		= dw_pdnagrupa.GetItemString(li_i,'nu_cut')
	li_fabpt 	= dw_pdnagrupa.GetItemNumber(li_i,'co_fabrica_pt')
	li_lin   	= dw_pdnagrupa.GetItemNumber(li_i,'co_linea')
	ll_ref   	= dw_pdnagrupa.GetItemNumber(li_i,'co_referencia')
	ll_co_color 	= dw_pdnagrupa.GetItemNumber(li_i,'co_color_pt')
	li_cspar 	= dw_pdnagrupa.GetItemNumber(li_i,'cs_particion')
	ls_tono  	= dw_pdnagrupa.GetItemString(li_i,'tono')
	ll_cspdn 	= dw_pdnagrupa.GetItemNumber(li_i,'cs_pdn')
	
	// Tallas
	lds_tallas.Retrieve(ll_fab,li_lib,ls_po,ls_cut,li_fabpt,li_lin,ll_ref,ll_co_color,ls_tono,li_cspar)
	
	For ll_j = 1 To lds_tallas.RowCount()
		li_csorden = lds_tallas.GetItemNumber(ll_j,'cs_orden_talla')
		li_talla   = lds_tallas.GetItemNumber(ll_j,'co_talla')
		ll_cnt     = lds_tallas.GetItemNumber(ll_j,'ca_programada')
		ll_pendie  = lds_tallas.GetItemNumber(ll_j,'ca_pendiente')
		
		IF ll_cnt <> ll_pendie THEN
			rollback;
			MessageBox("Advertencia!","Control para evitar que se da$$HEX1$$f100$$ENDHEX$$en las unidades, informar a sistemas.~n~n~nNota: " + ls_sqlerr )
			Return -1
		END IF
		
		insert into dt_agrupaescalapdn  
		  ( cs_agrupacion,cs_pdn,co_talla,cs_talla,co_estado,ca_unidades,   
		  fe_creacion,fe_actualizacion,usuario,instancia )  
		values ( :an_agrupa,:ll_cspdn,:li_talla,:li_csorden,1,   
		  :ll_cnt,current,current,user,sitename )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback;
			MessageBox("Advertencia!","No se pudo insertar las tallas.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
	Next

	// Rayas
	lds_rayas.Retrieve(an_agrupa,ll_cspdn)
	
	For ll_j = 1 To lds_rayas.RowCount()
					
		ll_modulo = lds_rayas.GetItemNumber(ll_j,'co_modelo')
		ll_raya   = lds_rayas.GetItemNumber(ll_j,'raya')
		ll_cnt    = lds_rayas.GetItemNumber(ll_j,'ca_unidades')
		
		insert into dt_agrupa_pdn_raya  
		  ( cs_agrupacion,cs_pdn,co_modelo,raya,ca_unidades,   
		  co_tipo,co_estado,fe_creacion,fe_actualizacion,   
		  usuario,instancia )  
		values ( :an_agrupa,:ll_cspdn,:ll_modulo,:ll_raya,:ll_cnt,   
		  1,1,current,current,user,sitename )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback;
			MessageBox("Advertencia!","No se pudo insertar las rayas.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
	Next
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
	li_fabpt	 = lds_colmod.GetItemNumber(ll_j,'co_fabrica')
	li_lin	 = lds_colmod.GetItemNumber(ll_j,'co_linea')
	ll_ref	 = lds_colmod.GetItemNumber(ll_j,'co_referencia')
	
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
			
			insert into h_base_trazos  
				( cs_agrupacion,cs_base_trazos,raya,fe_creacion,fe_actualizacion,   
				usuario,instancia )  
			values ( :an_agrupa,:ll_bsins,:ll_raya,current,current,user,sitename) ;
		
			If Sqlca.SqlCode = -1 Then  
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).~n~n~nNota :" + ls_sqlerr)
				Return -1
			End If
		Else
			ll_bsins = ll_found
		End If
	End If
		
	li_ryax = ll_raya
		
   select cs_agrupacion
     into :ll_found
     from dt_rayas_telaxbase
    where cs_agrupacion  = :an_agrupa and
          cs_base_trazos  = :ll_bsins and
			 co_modelo    = :ll_modelo and
			 co_fabrica_te = :li_fabtela and
			 co_reftel    = :ll_reftl and
			 co_caract    = :ll_carac and
			 diametro    = :ll_diam and
			 co_color_te   = :ll_color and
			 co_fabrica   = :li_fabpt and
			 co_linea   = :li_lin and
			 co_referencia  = :ll_ref;

			
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo problemas al buscar las rayas de la base.~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		
		insert into dt_rayas_telaxbase  
				( 	cs_agrupacion,				cs_base_trazos,				co_modelo,				co_fabrica_te,
					co_reftel,					co_caract,						diametro,				co_color_te,
					raya,							fe_creacion,					fe_actualizacion,   	usuario,
					instancia, co_fabrica, co_linea, co_referencia )  
		values ( :an_agrupa,					:ll_bsins,						:ll_modelo,				:li_fabtela,
					:ll_reftl,					:ll_carac,						:ll_diam,				:ll_color,
					:ll_raya,					current,							current,					user,
					sitename, :li_fabpt, :li_lin, :ll_ref) ;
					
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","No se pudo insertar el las rayas de los trazos.~n~n~nNota :" + ls_sqlerr)
			Return -1			
		End If		
	End If	
Next

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
		insert into dt_pdnxbase  
			( cs_agrupacion,cs_base_trazos,cs_pdn,fe_creacion,fe_actualizacion, 
			usuario,instancia )  
		values ( :an_agrupa,:ll_base,:ll_cspdn,current,current,user,sitename) ;
				
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
			Return -1
		End If
	End If
Next

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
		insert into dt_escalaxpdnbase  
         ( 	cs_agrupacion,				cs_base_trazos,					cs_pdn,					co_talla,
				cs_talla,					ca_unidades,   					co_estado,				fe_creacion,
				fe_actualizacion,			usuario,								instancia )  
  		values (
		  		:an_agrupa,					:ll_base,							:ll_cspdn,				:li_talla,
				:ll_j,   					:ll_unid,							1,							current,
				current,						user,									sitename )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","Hubo un error al insertar la talla de los trazos(D).~n~n~nNota :" + ls_sqlerr)
			Return -1
		End If
	End If
Next

If dw_pdn.Update() = -1 Then
	rollback ;
	Messagebox("Advertencia!","No se pudo grabar el estado de la producci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
End If

Destroy lds_tallas
Destroy lds_rayas
Destroy lds_colmod
Destroy lds_pdntz
Destroy lds_tlltz

//This.Enabled = False
//d_lista_trazos_produccion

return an_agrupa
end function

public function long of_traer_lote_liberacion ();//ds_lote_liberacion
return 1
end function

public function long of_anular_reposo ();
/********************************************************************
SA57147 FunctionName: of_anular_reposo
<DESC> Description: Agilizar el proceso de liberaci$$HEX1$$f300$$ENDHEX$$n, se realiza anulacion, se
cargan datos en temp ref liberar y abre ventana para liberar</DESC> 
<RETURN> Long: <LI> 1, X ok <LI> -1, X failed</RETURN> 
<ACCESS> Public/Protected/Private 
********************************************************************/

Long ll_liberacion, ll_reg, ll_talla_pt
Integer	li_existe
String ls_usuario, ls_error
s_base_parametros lstr_parametros
uo_dsbase lds_temp_liberar, lds_telaxmodelo_lib, lds_rollos_tipo1,lds_talla, lds_referencia

If il_fila > 0 Then
	
	//pregunta si quiere anular o no
	ll_reg = MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','$$HEX1$$bf00$$ENDHEX$$Esta seguro de Anular y volver a liberar ?',Question!, yesno!,2)
	//si responden no
	If ll_reg = 2 Then
		Return 1
	End if
	
	ls_usuario =  gstr_info_usuario.codigo_usuario
	ll_liberacion = dw_pdn.GetItemNumber(il_fila,'cs_liberacion') 
	
	
	//valida que no anulen por esa opcion agrupadas
	SELECT Count(*)
	  INTO :li_existe
	  FROM dt_op_agrupa_lib_talla
	 WHERE cs_liberacion = :ll_liberacion; 
	 IF li_existe > 0 THEN
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No puede utilizar esta opcion para anular liberacion de OP agrupadas')
		Return -1
	 END IF

	lds_temp_liberar = Create uo_dsbase
	lds_temp_liberar.DataObject 	= 'd_gr_temp_ref_liberar'
	lds_temp_liberar.SetTransObject(Sqlca)
	
	lds_telaxmodelo_lib = Create uo_dsbase
	lds_telaxmodelo_lib.DataObject = 'd_gr_dt_telaxmodelo_lib_x_lib'
	lds_telaxmodelo_lib.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	lds_rollos_tipo1 = Create uo_dsbase
	lds_rollos_tipo1.DataObject = 'd_gr_dt_rollos_libera_x_lib'
	lds_rollos_tipo1.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	lds_talla = Create uo_dsbase
	lds_talla.DataObject = 'd_gr_talla_pdnmodulo_x_lib'
	lds_talla.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	lds_referencia = Create uo_dsbase
	lds_referencia.DataObject = 'd_gr_dt_pdnxmodulo_x_lib'
	lds_referencia.SetTransObject(gnv_recursos.Of_Get_Transaccion_Sucia())
	
	//realiza la anulacion
	If This.TriggerEvent("ue_anular") <= 0 Then
		Return 1
	End if
	
	//carga informacion por usuario
	If lds_temp_liberar.Retrieve(ls_usuario) >= 0 Then
		
		//trae informacion de telaxmodelo_lib
		If lds_telaxmodelo_lib.Retrieve(ls_usuario, ll_liberacion) < 0 Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informacion de tela por modelo')
			Return -1
		End if
		
		//trae informacion de rollos tipo 1
		If lds_rollos_tipo1.Retrieve(ls_usuario, ll_liberacion) < 0 Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informacion de rollos tipo 1')
			Return -1
		End if
		
		//borra informacion
		lds_temp_liberar.RowsMove(1, lds_temp_liberar.RowCount() + 1, Primary!, lds_temp_liberar, 1, Delete!	)
//		DELETE FROM temp_ref_liberar
//		WHERE usuario = :ls_usuario;
//		IF sqlca.sqlcode = -1 THEN
//			ls_error = sqlca.sqlerrtext
//			Rollback;
//			MessageBox('Error Base de Datos','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de borrar la temporal de referencias, ERROR: '+ls_error,StopSign!)
//			Return -1
//		END IF 
//
		//copia informacion
		lds_telaxmodelo_lib.RowsCopy(1, lds_telaxmodelo_lib.RowCount() + 1, Primary!, lds_temp_liberar, 1, Primary!	)
		lds_rollos_tipo1.RowsCopy(1, lds_rollos_tipo1.RowCount() + 1, Primary!, lds_temp_liberar, 1, Primary!	)
		
		
		//actualiza informacion
		If lds_temp_liberar.Update() <= 0 Then
			Rollback;
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al actualizar informacion')
			Return -1
		End if
		
		Commit;
		//rollback;
		//trae informacion de tallas
		ll_reg = lds_talla.Retrieve( ll_liberacion)
		If ll_reg < 0 Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informacion de tallas. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
			Return -1
		ElseIf ll_reg = 0 Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informacion de tallas para la liberacion. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
			Return -1
		End if
		
		//mira si tiene mas de una talla
		If ll_reg > 1 Then
			ll_talla_pt = 9999
		Else
			ll_talla_pt = lds_talla.GetItemNumber(1,'co_talla')
		End if
		
		//trae informacion de referencia
		ll_reg = lds_referencia.Retrieve(ll_liberacion)
		If ll_reg < 0 Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar informacion de produccion. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
			Return -1
		ElseIf ll_reg = 0 Then
			MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontro informacion de produccion. El proceso de anulaci$$HEX1$$f300$$ENDHEX$$n se realiza con $$HEX1$$e900$$ENDHEX$$xito')
			Return -1
		End if
			
		lstr_parametros.entero[1]  = lds_referencia.GetItemNumber(1,'co_fabrica_pt')
		lstr_parametros.entero[2]  = lds_referencia.GetItemNumber(1,'co_linea')
		lstr_parametros.entero[3]  = lds_referencia.GetItemNumber(1,'co_referencia')
		lstr_parametros.entero[4]  = lds_referencia.GetItemNumber(1,'co_color_pt')
		lstr_parametros.entero[5]  = 0
		lstr_parametros.entero[6]  = 0
		lstr_parametros.entero[7]  = ll_talla_pt
		lstr_parametros.entero[8]  = lds_referencia.GetItemNumber(1,'cs_ordenpd_pt')
		lstr_parametros.entero[9]  = lds_referencia.GetItemNumber(1,'co_linea_exp')
		lstr_parametros.entero[10] = lds_referencia.GetItemNumber(1,'co_fabrica_exp')
		lstr_parametros.cadena[1]  = lds_referencia.GetItemString(1,'co_ref_exp')
		lstr_parametros.cadena[2]  = lds_referencia.GetItemString(1,'co_color_exp')
		lstr_parametros.entero[11] = 1 //opcion_liberar: 1 = equilibrar, 2 = igualar
		lstr_parametros.entero[12] = lds_referencia.GetItemNumber(1,'cs_unir_oc')
		
		lstr_parametros.entero[13] =  lds_referencia.GetItemNumber(1,'op_agrupada')
		lstr_parametros.entero[14] = 0
		 	
		OpenSheetWithParm(w_existencias_tela_critica, lstr_parametros, W_PRINCIPAL,0,Original!)

  
		
	End if

End if

Return 1
end function

on w_pdn_agrupar.create
if this.MenuName = "m_mantenimiento_asignacion_trazos" then this.MenuID = create m_mantenimiento_asignacion_trazos
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_concepto=create cb_concepto
this.cb_limpiar=create cb_limpiar
this.cb_recuperar=create cb_recuperar
this.dw_parametros=create dw_parametros
this.dw_pdnagrupa=create dw_pdnagrupa
this.dw_pdn=create dw_pdn
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.cb_concepto,&
this.cb_limpiar,&
this.cb_recuperar,&
this.dw_parametros,&
this.dw_pdnagrupa,&
this.dw_pdn}
end on

on w_pdn_agrupar.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_concepto)
destroy(this.cb_limpiar)
destroy(this.cb_recuperar)
destroy(this.dw_parametros)
destroy(this.dw_pdnagrupa)
destroy(this.dw_pdn)
end on

event open;STRING	ls_instruccion
//TRANSACTION			itr_tela
Long li_ret
n_cts_constantes luo_constantes

dw_parametros.SetTransObject(SQLCA)

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

//se deshabilitan las opciones del menu para los usuarios que no sean de texografo perfil 16
//en seguridad.
//jcrm
//marzo 27 de 2007
IF gstr_info_usuario.codigo_perfil <> 16 and  gstr_info_usuario.codigo_perfil <> 19 and  gstr_info_usuario.codigo_perfil <> 5 and  gstr_info_usuario.codigo_perfil <> 17 and  gstr_info_usuario.codigo_perfil <> 27 Then
	m_mantenimiento_asignacion_trazos.m_edicion.m_creartrazo.ToolbarItemVisible = False
	m_mantenimiento_asignacion_trazos.m_edicion.m_borrarproducci$$HEX1$$f300$$ENDHEX$$ndeltrazo.ToolbarItemVisible = False
	m_mantenimiento_asignacion_trazos.m_edicion.m_filtrar.ToolbarItemVisible = False
	m_mantenimiento_asignacion_trazos.m_archivo.m_grabar.ToolbarItemVisible = False
	
	m_mantenimiento_asignacion_trazos.m_edicion.m_creartrazo.Visible = False
	m_mantenimiento_asignacion_trazos.m_edicion.m_borrarproducci$$HEX1$$f300$$ENDHEX$$ndeltrazo.Visible = False
	m_mantenimiento_asignacion_trazos.m_edicion.m_filtrar.Visible = False
	m_mantenimiento_asignacion_trazos.m_archivo.m_grabar.Visible = False
	
	dw_pdn.SetTabOrder("fuente_dato",0)
	

	
	dw_pdn.Object.DataWindow.ReadOnly
End if


IF gstr_info_usuario.codigo_perfil <> 9 and  gstr_info_usuario.codigo_perfil <> 19 Then
	IF gstr_info_usuario.codigo_usuario = 'fasernap' OR gstr_info_usuario.codigo_usuario = 'ljgarcia' OR gstr_info_usuario.codigo_usuario = 'jorodrig' OR gstr_info_usuario.codigo_perfil = 16 THEN
	ELSE
		m_mantenimiento_asignacion_trazos.m_edicion.m_anular.ToolbarItemVisible = False
		m_mantenimiento_asignacion_trazos.m_edicion.m_anular.Visible = False
	END IF
END IF

f_rcpra_dtos_dddw_param(dw_parametros, 'co_linea', SQLCA, 0)

dw_parametros.InsertRow(0)

ls_instruccion = "SET LOCK MODE TO WAIT 60 "
EXECUTE IMMEDIATE :ls_instruccion ;
IF SQLCA.SQLCODE = -1 THEN
   MessageBox("ERROR....","Problemas con la base de datos en el modo de bloqueo: " +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

luo_constantes = Create n_cts_constantes;

ii_fabrica = luo_constantes.of_consultar_numerico("FABRICA PLANTA")
IF ii_fabrica = -1 THEN
	Return
END IF
ii_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACIONES")
IF ii_planta = -1 THEN
	Return
END IF
ii_centro = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
IF ii_centro = -1 THEN
	Return
END IF

ii_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF ii_estadodisp = -1 THEN
	Return
END IF

il_planta_proceso = 0
ib_trazo = False
im_select = Create m_select

li_ret = dw_pdn.SetTransObject(SQLCA)
li_ret = dw_pdnagrupa.SetTransObject(SQLCA)

invo_modificar = Create n_cst_configuracion_kpo
//carga perfiles que pueden modificar datos
invo_modificar.of_cargar_configuracion('AMP')
//mira si el perfil tiene permiso de modificar
If invo_modificar.of_validar_datos('entero1',string(gstr_info_usuario.codigo_perfil)) <> 1 Then
	ib_modificar = False
Else
	ib_modificar = True
End if

This.WindowState = Maximized!
end event

event resize;dw_pdn.Resize(This.Width - 75, This.Height - 250)
end event

event closequery;
Destroy im_select
Destroy invo_modificar
end event

event activate;//cuando abren esta ventana y se genera el reporte de orden de corte esta ventana pierde
//el objecto transacional con las dw, con esto se evita que esto suceda
//jcrm
//marzo 29 de 2007
dw_pdn.SetTransObject(SQLCA)
dw_pdnagrupa.SetTransObject(SQLCA)
end event

type cb_4 from commandbutton within w_pdn_agrupar
integer x = 3739
integer y = 20
integer width = 306
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Act Reposo"
end type

event clicked;
	s_base_parametros s_parametros
	LONG		ll_liberacion
	STRING	ls_cod_autorizacion, ls_cod_ingreso
	s_base_parametros lstr_parametros
	n_cts_constantes_tela luo_constantes
	
	
	IF  il_fila > 0  THEN
	
	ls_cod_autorizacion = luo_constantes.of_consultar_texto("PASSWORD_ACT_REPOSO")
	Open(w_password_max_lotes)
	lstr_parametros = Message.PowerObjectParm	
	If lstr_parametros.hay_parametros = True Then
		ls_cod_ingreso = lstr_parametros.cadena[1]
		//se compara el password de las constantes con el digitado por el usuario
		If Trim(ls_cod_autorizacion) <> Trim(ls_cod_ingreso) Then
			MessageBox('Error','El Password ingresado no es valido.')
			Return 
		Else
			//SE PERMITE INGRESAR FILA EN EL DETALLE
			Messagebox('O.K.','El password es correcto')
		End if
	Else
		Return      //no se permite ingresar el dato
	END IF
		
	ll_liberacion = dw_pdn.GetItemNumber(il_fila,'cs_liberacion')
	IF ll_liberacion > 0 THEN
		s_parametros.entero[1] = ll_liberacion
		
	  //abre ventana donde muestra liberacion-tela y fechas de reposo
		OpenWithParm(w_act_fechas_reposo_x_lib,s_parametros,w_principal)
	END IF
ELSE
	MessageBox('Advertencia','No esta autorizado')
END IF
end event

type cb_3 from commandbutton within w_pdn_agrupar
integer x = 3502
integer y = 20
integer width = 233
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "DesAgrup"
end type

event clicked;Long	li_estado
LONG	ll_cs_agrupacion

IF il_fila > 0 THEN
	li_estado = dw_pdn.GetItemNumber(il_fila, "co_estado_asigna_1")
	ll_cs_agrupacion = dw_pdn.GetItemNumber(il_fila, "cs_agrupacion")
	IF (li_estado = 6 OR li_estado = 3 ) AND (ll_cs_agrupacion = 0 OR IsNull(ll_cs_agrupacion)) THEN
		dw_pdn.SetItem(il_fila,"co_estado_asigna_1",1)
		dw_pdn.SetItem(il_fila,"cs_asignacion",1)
		dw_pdn.AcceptText()
		If dw_pdn.Update() = -1 Then
			Rollback ;
			Messagebox("Advertencia!","No se pudo anular la producci$$HEX1$$f300$$ENDHEX$$n")
		//	Return 
		ELSE
			Commit;
			Messagebox("O.K.","Se devolvio el estado al estado inicial y se quit$$HEX2$$f3002000$$ENDHEX$$la OC")
		END IF
	END IF
END IF
end event

type cb_2 from commandbutton within w_pdn_agrupar
integer x = 3282
integer y = 20
integer width = 219
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Trazo ok"
end type

event clicked;Long	li_filas, posi, li_estado, li_estado_solicitud
LONG		ll_op, ll_color
DECIMAL{2}	ld_ancho, ld_ancho1, ld_ancho2
datastore	ld_gr_estado_solicitud_trazo_x_op

s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Buscando informacion de trazos..."
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro) 


ld_gr_estado_solicitud_trazo_x_op	= Create DataStore
ld_gr_estado_solicitud_trazo_x_op.DataObject 		= 'd_gr_estado_solicitud_trazo_x_op'
ld_gr_estado_solicitud_trazo_x_op.SetTransObject(sqlca)

li_filas = dw_pdn.RowCount()
FOR posi = 1 TO li_filas
	ll_op 	= dw_pdn.GetItemNumber(posi,'cs_ordenpd_pt')
	ll_color = dw_pdn.GetItemNumber(posi,'co_color_pt')
	ld_ancho = dw_pdn.GetItemNumber(posi,'ancho') //esta dado en cm
	li_estado = dw_pdn.GetItemNumber(posi,'co_estado_asigna')
	
	IF li_estado > 1 THEN
		ld_ancho = ld_ancho / 100  //se convierte a mts
		ld_ancho1 = ld_ancho + 0.01
		ld_ancho2 = ld_ancho - 0.01
		IF	ld_gr_estado_solicitud_trazo_x_op.retrieve(ll_op, ld_ancho,ld_ancho1,ld_ancho2,ll_color) > 0 THEN
			li_estado_solicitud = ld_gr_estado_solicitud_trazo_x_op.GetItemNumber(1,'estado')
			IF IsNull(li_estado_solicitud) THEN li_estado_solicitud = 2
			dw_pdn.SetItem(posi,'sw_con_trazo',li_estado_solicitud)
		ELSE
			dw_pdn.SetItem(posi,'sw_con_trazo',2)
		END IF
	ELSE
		dw_pdn.SetItem(posi,'sw_con_trazo',-1)
	END IF
	
NEXT

CLOSE(w_retroalimentacion)
end event

type cb_1 from commandbutton within w_pdn_agrupar
integer x = 3003
integer y = 20
integer width = 283
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Convencion"
end type

event clicked;Open(w_convenciones)
end event

type cb_concepto from commandbutton within w_pdn_agrupar
integer x = 2720
integer y = 20
integer width = 283
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "concepto 15"
end type

event clicked;//evento para marcar los rollos de laliberaci$$HEX1$$f300$$ENDHEX$$n selecciona con los conceptos de Molderia o Lote validaci$$HEX1$$f300$$ENDHEX$$n
Long ll_fila
s_base_parametros lstr_parametros

ll_fila = dw_pdn.GetRow()

If ll_fila > 0 Then
	lstr_parametros.entero[1] = dw_pdn.GetItemNumber(ll_fila,'cs_liberacion')
	//abrir ventana donde esten los rollos de la liberaci$$HEX1$$f300$$ENDHEX$$n y donde puedan elegir el concepto por el cual
	//no es posible liberar 
	OpenWithParm ( w_conceptos_texografo_15, lstr_parametros )
End if

end event

type cb_limpiar from commandbutton within w_pdn_agrupar
integer x = 2533
integer y = 20
integer width = 183
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar"
end type

event clicked;dw_parametros.Reset()
dw_parametros.InsertRow(0)
end event

type cb_recuperar from commandbutton within w_pdn_agrupar
integer x = 2263
integer y = 20
integer width = 270
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Long	li_semana_critica,	li_anno_critica
n_cts_constantes_tela luo_constantes

li_semana_critica = luo_constantes.of_consultar_numerico("SEMANA_CRITICA      ")
li_anno_critica = luo_constantes.of_consultar_numerico("ANO_CRITICA         ")

IF dw_parametros.RowCount() = 1 THEN
	dw_parametros.AcceptText()
	ii_fabricaref = dw_parametros.GetItemNumber(1, 'co_fabrica')
	IF IsNull(ii_fabricaref) THEN
		ii_fabricaref = 0
	END IF
	ii_linea = dw_parametros.GetItemNumber(1, 'co_linea')
	IF IsNull(ii_linea) THEN
		ii_linea = 0
	END IF
	il_ordenpdn = dw_parametros.GetItemNumber(1, 'cs_ordenpd_pt')
	IF IsNull(il_ordenpdn) THEN
		il_ordenpdn = 0
	END IF
	il_planta_proceso = dw_parametros.GetItemNumber(1, 'co_planta')
	IF IsNull(il_planta_proceso) THEN
		il_planta_proceso = 0
	END IF
	dw_pdn.Retrieve(ii_estadodisp, ii_centro, ii_fabricaref, ii_linea, il_ordenpdn, gstr_info_usuario.co_planta_pro,li_anno_critica,li_semana_critica,il_planta_proceso)
END IF
end event

type dw_parametros from datawindow within w_pdn_agrupar
integer x = 9
integer y = 24
integer width = 2331
integer height = 100
integer taborder = 10
string title = "none"
string dataobject = "dff_criterio_agrupa_pdn"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_fabrica

IF Dwo.Name = 'co_fabrica' THEN
	f_rcpra_dtos_dddw_param(This, 'co_linea', SQLCA, Long(Data))
END IF
end event

type dw_pdnagrupa from u_dw_base within w_pdn_agrupar
boolean visible = false
integer x = 366
integer y = 752
integer width = 1170
integer height = 724
integer taborder = 20
string dataobject = "d_insercion_dt_agrupacion"
end type

type dw_pdn from u_dw_base within w_pdn_agrupar
integer x = 23
integer y = 140
integer width = 4457
integer height = 1844
integer taborder = 10
string title = ""
string dataobject = "d_lista_pdn_a_agrupar"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event clicked;call super::clicked;Long ll_agrupa,ll_orden,ll_fila,ll_agrupa2, ll_unir_oc_old, ll_unir_oc_new, ll_ordenpd_pt, ll_ordenpd_pt_old
Long li_linea_exp_ori, li_linea_exp, li_fila
String ls_ref_exp_ori, ls_ref_exp, ls_color_exp_ori, ls_color_exp

il_fila = row
If Row <= 0 Then 
	ib_trazo = False
	Return
End If

//se van a colocar el campo de la liberacion en color verde, esto para que sea identificable
//visualmente cuales liberaciones deben de ir juntas por tratarse de un conjunto o duo
//jcrm
//mayo 22 de 2008

FOR li_fila = 1 TO This.RowCount()
	This.SetItem(li_fila,'marca',0)
NEXT

ll_unir_oc_old = This.GetItemNumber(Row,'cs_unir_oc')
ll_ordenpd_pt_old = This.GetItemNumber(Row,'cs_ordenpd_pt')
FOR li_fila = 1 TO This.RowCount()
	ll_unir_oc_new = This.GetItemNumber(li_fila,'cs_unir_oc')
	ll_ordenpd_pt = This.GetItemNumber(li_fila,'cs_ordenpd_pt')
	
	IF (ll_unir_oc_new = ll_unir_oc_old) AND (ll_unir_oc_old <> 0)  THEN
		This.SetItem(li_fila,'marca',1)
	END IF
	//tambien si la OP tiene mas registros se colocan en naranjado.
	//jcrm
	//octubre 7 de 2008
	IF ll_ordenpd_pt_old = ll_ordenpd_pt THEN
		This.SetItem(li_fila,'marca',2)
	END IF
	
NEXT
//
//fin modificacion mayo 22 de 2008

IF row > 0 THEN
	gl_orden_corte = This.GetItemNumber(row,'cs_asignacion')
END IF
	


If ib_trazo Then
	
	ib_trazo = False
	ll_agrupa = This.GetItemNumber(row,'cs_agrupacion')
   ll_orden = This.GetItemNumber(row,'cs_asignacion')
	
	gl_orden_corte = ll_orden
	If Not IsNull(ll_agrupa) Then 
		If Of_detalleTrazo(ll_agrupa) > 0 Then 
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
			dw_pdn.Retrieve(1,91,1,800,gstr_info_usuario.co_planta_pro)
			
			//se trata de un registro que se colocara en una agrupacion existente (ll_agrupa)
			//por lo tanto se debe colocar el mismo numero de orden corte para todos los registros
			//de dicha agrupacion
			//realizado por juan carlos restrepo abril 25 de 2003
			
			For ll_fila = 1 To dw_pdn.RowCount()
				ll_agrupa2 = dw_pdn.GetItemNumber(ll_fila,'cs_agrupacion') 
				If ll_agrupa2 = ll_agrupa Then
					dw_pdn.SetItem(ll_fila,'cs_asignacion',ll_orden)
				End if
			Next
			
			If dw_pdn.Update() = -1 Then
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
	//selecciona todos las po de una misma linea, referencia, color, orden pdn y tanda
	Of_seleccionar_agrupacion(row)
End If

ib_trazo = False


end event

event rbuttondown;call super::rbuttondown;Long ll_ordenpdn, ll_ordenpdn_agrup
s_base_parametros lstr_parametros

IF Row > 0 THEN
	
	If dwo.name = 'cs_liberacion' Then 
		s_base_parametros s_parametros
			
		s_parametros.cadena[1] = 'r_liberacion_escalas'
		s_parametros.entero[1] = This.GetItemNumber(row,'cs_liberacion')
		s_parametros.hay_parametros = TRUE
		
		//llama ventana que actualiza cantidad de impresiones
		OpenSheetWithParm(w_prewiew_liberacion_escalas, s_parametros, w_principal, 1, Layered!)
		//OpenSheetWithParm(w_reporte_liberacion_escala, s_parametros, w_principal, 1, Layered!)
	Else
		ll_ordenpdn = This.GetItemNumber(Row, "cs_ordenpd_pt")
	
		SELECT MAX(cs_ordenpd_pt)
		INTO :ll_ordenpdn_agrup
		FROM dt_ordenes_agrupad
		WHERE cs_ordenpd_pt_agru = :ll_ordenpdn;
		
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar orden agrupada " + SQLCA.SQLErrText)
			Return
		END IF
		
		IF ll_ordenpdn_agrup > 0 THEN
			lstr_parametros.entero[1] = ll_ordenpdn_agrup
			lstr_parametros.entero[2] = ll_ordenpdn
		ELSE
			lstr_parametros.entero[1] = ll_ordenpdn
			lstr_parametros.entero[2] = ll_ordenpdn
		END IF
		
		OpenWithParm(w_muestra_obs_texografo_op, lstr_parametros)
	End if
END IF



end event

event doubleclicked;call super::doubleclicked;Long ll_ordenpdn, ll_color, ll_liberacion
n_cts_param luo_param

IF Row > 0 THEN
	ll_ordenpdn = This.GetItemNumber(Row, "cs_ordenpd_pt")
	ll_color = This.GetItemNumber(Row, "co_color_pt")
	ll_liberacion = This.GetItemNumber(Row, "cs_liberacion")
	
	luo_param.il_vector[1] = ll_ordenpdn
	luo_param.il_vector[2] = ll_color
	luo_param.il_vector[3] = ll_liberacion
	OpenWithParm(w_tallas_liberacion, luo_param)
END IF
end event

event buttonclicked;call super::buttonclicked;String ls_columna, ls_filtro, ls_condicion, ls_tipo_campo, ls_filtro_comun
Long li_resultado
Long ll_filas, ll_j, ll_tanda, ll_lote
s_base_parametros lstr_parametros
n_cts_param			luo_param

ls_filtro_comun = 'rollos_bodega > 0'


If dwo.Name = "b_calidad" Then
//	ll_tanda = This.GetItemNumber(row, "lote")
//	li_fabrica_exp = This.GetItemNumber(row, "co_fabrica_exp")
//	ll_liberacion = This.GetItemNumber(row, "cs_liberacion")
//	ls_nu_orden = 	This.GetItemNumber(row, "po")
//	ls_nu_cut =  This.GetItemNumber(row, "nu_cut")
//	li_fabrica_pt = This.GetItemNumber(row, "co_fabrica_pt")
//	li_linea = This.GetItemNumber(row, "co_linea")
//	ll_referencia = This.GetItemNumber(row, "co_referencia")
//	li_color_pt = This.GetItemNumber(row, "co_color_pt")
//	
	ll_tanda = This.GetItemNumber(row, "tanda")
	ll_lote  = This.GetItemNumber(row, "lote")
	IF ll_tanda < 100 THEN
		luo_param.il_vector[1] = ll_lote
	ELSE
		luo_param.il_vector[1] = ll_tanda
	END IF
	//luo_param.il_vector[1] = This.GetItemNumber(row, "lote")
	luo_param.il_vector[2] = This.GetItemNumber(row, "cs_ordenpd_pt")
	OpenWithParm(w_info_calidad_tanda, luo_param)
End If
//
If dwo.Name = "b_trazos" Then
	luo_param.il_vector[1] = This.GetItemNumber(row, "co_fabrica_pt")
	luo_param.il_vector[2] = This.GetItemNumber(row, "co_linea")
	luo_param.il_vector[3] = This.GetItemNumber(row, "co_referencia")
	OpenWithParm(w_info_trazos_referencia, luo_param)
End If


ls_columna = mid(dwo.name,4)

IF ib_filtro = FALSE THEN
//	IF not isnull(ls_columna) THEN
//		if ib_ordenar_ascendente = FALSE THEN
//			ls_columna = ls_columna + ' A' 
//			ib_ordenar_ascendente = TRUE
//		ELSE
//			ls_columna = ls_columna + ' D' 
//			ib_ordenar_ascendente = FALSE
//		END IF
//		li_resultado = This.setsort(ls_columna)
//		li_resultado = This.sort()
//	END IF
ELSE
	 OPEN (w_parametros_filtro)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ls_filtro = lstr_parametros.cadena[1]
		ls_condicion = lstr_parametros.cadena[2]
		
		IF isnull(ls_filtro) THEN
			ls_filtro = 'Todos'
		END IF
		
		IF ls_filtro <> 'Todos' THEN
			il_i = il_i + 1
			is_columna[il_i] = ls_columna
		
			ls_tipo_campo = TRIM(This.getformat(ls_columna))
	
			CHOOSE CASE ls_tipo_campo
				CASE '[General]','[general]','[GENERAL]'	//Caracteres
					   
						ls_condicion = ' '+ls_condicion + ' '
						IF isnull(is_filtrar) or is_filtrar = '' then
							is_filtrar = ls_columna + ls_condicion +'"'+ ls_filtro+'"'
						else
							is_filtrar = is_filtrar +' AND ' +ls_columna + ls_condicion +'"'+ ls_filtro+'"'
						end if					
				CASE	'dd/mm/yyyy hh:mm','dd/mm/yyyy'		// filtro para fechas
					   IF isnull(is_filtrar) or is_filtrar = '' then						
							if ls_tipo_campo= 'dd/mm/yyyy' then
								is_filtrar = 'date ('+ls_columna +')' + ls_condicion +'date("'+ ls_filtro+'")'										
						   else
								is_filtrar = ls_columna + ls_condicion +'date("'+ ls_filtro+'")'																		
						   end if						
					   ELSE
							is_filtrar = is_filtrar +' AND '+ ls_columna + ls_condicion +'date("'+ ls_filtro+'")'																	
						END IF						
				CASE 	'','#,##0.00','0','#,##0','###,###','###','#######', '###,###,##0', '###,###,##0.00', &
					   '###,###,###,##0', '###,###,###,##0.00', '##0.00'	//N$$HEX1$$fa00$$ENDHEX$$mericos
						IF isnull(is_filtrar) or is_filtrar = '' then
							is_filtrar = ls_columna + ls_condicion + ls_filtro			
						ELSE
							is_filtrar = is_filtrar +' AND ' + ls_columna + ls_condicion + ls_filtro			
						END IF
				END CHOOSE
				This.SetFilter(is_filtrar + ' and ' + ls_filtro_comun)
   			This.Setredraw(FALSE)
				This.Filter( )			
				This.Setredraw(TRUE)	
				ll_filas = This.rowCount()			
				
				IF This.rowCount() <= 0 THEN
					messagebox(parent.title,'No existe informaci$$HEX1$$f300$$ENDHEX$$n por el criterio seleccionado')							
					is_filtrar = ''
					This.SetFilter(is_filtrar + ls_filtro_comun)
					This.Setredraw(FALSE)
					This.Filter( )			
					This.Setredraw(TRUE)
					ll_j = 1
					DO WHILE ll_j <= il_i 
						ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
						This.Modify(ls_columna)				
						ll_j = ll_j + 1
					LOOP
					il_i = 0
					ls_columna = 'cb_'+ls_columna+'.Color = 0'
					This.Modify( ls_columna)
				else
					ls_columna = 'cb_'+ls_columna+'.Color = 255'
					This.Modify( ls_columna)
		   	END IF
		ELSE
			ll_j = 1
			DO WHILE ll_j <= il_i 
				ls_columna = 'cb_'+is_columna[ll_j]+'.Color = 0'
				This.Modify( ls_columna)				
				ll_j = ll_j + 1
			LOOP
			il_i = 0
			is_filtrar = ''
			This.SetFilter(is_filtrar + ls_filtro_comun)
			This.Setredraw(FALSE)
			This.Filter( )		
			This.Setredraw(TRUE)
		END IF
		This.Sort()
		This.GroupCalc()		
	END IF
END IF




end event

event itemchanged;call super::itemchanged;
//mira si el perfil tiene permiso de modificar
If ib_modificar = False Then
	Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se tiene permiso para modificar')
	Return 2
End if
end event

