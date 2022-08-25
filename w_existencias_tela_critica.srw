HA$PBExportHeader$w_existencias_tela_critica.srw
forward
global type w_existencias_tela_critica from window
end type
type cb_4 from commandbutton within w_existencias_tela_critica
end type
type cb_3 from commandbutton within w_existencias_tela_critica
end type
type cb_duo_conjunto from commandbutton within w_existencias_tela_critica
end type
type cb_xtono from commandbutton within w_existencias_tela_critica
end type
type cb_xtanda from commandbutton within w_existencias_tela_critica
end type
type st_talla from statictext within w_existencias_tela_critica
end type
type sle_talla from singlelineedit within w_existencias_tela_critica
end type
type dw_unidxcolorxtalla from datawindow within w_existencias_tela_critica
end type
type dw_colores_op from datawindow within w_existencias_tela_critica
end type
type dw_partes from datawindow within w_existencias_tela_critica
end type
type cb_inventario from commandbutton within w_existencias_tela_critica
end type
type dw_unid_x_liberar from datawindow within w_existencias_tela_critica
end type
type st_2 from statictext within w_existencias_tela_critica
end type
type cb_2 from commandbutton within w_existencias_tela_critica
end type
type cb_calc_propor from commandbutton within w_existencias_tela_critica
end type
type cb_1 from commandbutton within w_existencias_tela_critica
end type
type cb_calidad from commandbutton within w_existencias_tela_critica
end type
type cb_liberar from commandbutton within w_existencias_tela_critica
end type
type st_1 from statictext within w_existencias_tela_critica
end type
type dw_detalle from datawindow within w_existencias_tela_critica
end type
type dw_colores from datawindow within w_existencias_tela_critica
end type
type dw_maestro from datawindow within w_existencias_tela_critica
end type
type cb_buscar from commandbutton within w_existencias_tela_critica
end type
type cb_cerrar from commandbutton within w_existencias_tela_critica
end type
type dw_lista from datawindow within w_existencias_tela_critica
end type
type gb_1 from groupbox within w_existencias_tela_critica
end type
type gb_2 from groupbox within w_existencias_tela_critica
end type
type gb_3 from groupbox within w_existencias_tela_critica
end type
type gb_4 from groupbox within w_existencias_tela_critica
end type
type gb_5 from groupbox within w_existencias_tela_critica
end type
type gb_6 from groupbox within w_existencias_tela_critica
end type
type dw_equivalencias from datawindow within w_existencias_tela_critica
end type
end forward

global type w_existencias_tela_critica from window
integer width = 4923
integer height = 3636
boolean titlebar = true
string title = "LIBERACION"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
cb_4 cb_4
cb_3 cb_3
cb_duo_conjunto cb_duo_conjunto
cb_xtono cb_xtono
cb_xtanda cb_xtanda
st_talla st_talla
sle_talla sle_talla
dw_unidxcolorxtalla dw_unidxcolorxtalla
dw_colores_op dw_colores_op
dw_partes dw_partes
cb_inventario cb_inventario
dw_unid_x_liberar dw_unid_x_liberar
st_2 st_2
cb_2 cb_2
cb_calc_propor cb_calc_propor
cb_1 cb_1
cb_calidad cb_calidad
cb_liberar cb_liberar
st_1 st_1
dw_detalle dw_detalle
dw_colores dw_colores
dw_maestro dw_maestro
cb_buscar cb_buscar
cb_cerrar cb_cerrar
dw_lista dw_lista
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
dw_equivalencias dw_equivalencias
end type
global w_existencias_tela_critica w_existencias_tela_critica

type variables
Long	ii_ano, ii_semana, ii_fab, ii_lin, ii_talla, ii_tipo_lib, ii_linea_exp, ii_fab_exp,&
         ii_opcion_liberar, ii_act_unid, il_op_agrupada
Long		il_referencia, il_ordenpd_pt, il_cons_lib_duo, il_liberacion_duo, ii_unir_op, il_color_pt
String   is_ref_exp, is_color_exp
Boolean 	ib_tanda
Integer	ii_cs_agrupa_lib

end variables

forward prototypes
public function long of_actualizartemprefliberar ()
public function long of_validardatos ()
public subroutine of_generar_liberacion ()
public function long of_act_datos_raya_dif_ppl (string as_usuario, long al_op, string as_po, long al_color)
public function long of_validar_surtido (string as_po, uo_dsbase ads_ean_sku, long al_row, ref uo_dsbase ads_ean_sin_surtido, ref uo_dsbase ads_ean_sin_instruccion_empaque, ref uo_dsbase ads_ean_sin_procesar)
end prototypes

public function long of_actualizartemprefliberar ();//metodo para actualizar los rollos que se$$HEX1$$f100$$ENDHEX$$alo el usuario, los cuales seran los utilizados por la
//liberacion
//jcrm
//febrero 18 de 2008
Long li_fila, li_fab, li_lin, li_caract, li_dia, li_tipo
String ls_tono, ls_mensaje
Long ll_reftel, ll_color
Boolean lb_marca
n_cts_liberacion_x_proyeccion luo_proyeccion

lb_marca = False
//recorro las datawindos para saber que rollo selecciono el usuario
FOR li_fila = 1 TO dw_lista.RowCount()
	ls_tono = dw_lista.GetItemString(li_fila,'tono')
	li_fab = dw_lista.GetItemNumber(li_fila,'co_fabrica')
	li_lin = dw_lista.GetItemNumber(li_fila,'co_linea')
	ll_reftel = dw_lista.GetItemNumber(li_fila,'co_reftel')
	li_caract = dw_lista.GetItemNumber(li_fila,'co_caract')
	li_dia = dw_lista.GetItemNumber(li_fila,'diametro')
	ll_color = dw_lista.GetItemNumber(li_fila,'co_color_te')
	
	IF dw_lista.GetItemNumber(li_fila,'sw_op_estilo') = 1 THEN
		//marcar rollos 
		li_tipo = 1
		lb_marca = True
		IF luo_proyeccion.of_marcarRollos(ls_tono,li_fab,li_lin,ll_reftel,li_caract,li_dia,ll_color,li_tipo,ls_mensaje) = -1 THEN
			Rollback;
			MessageBox('Error','Se presentaron problemas cargando la tela a liberar, ERROR: '+ls_mensaje,StopSign!)
			Return -1
		END IF
	END IF
//	IF dw_lista.GetItemNumber(li_fila,'sw_stock') = 1 THEN
//		//marcar rollos
//		li_tipo = 2
//		lb_marca = True
//		IF luo_proyeccion.of_marcarRollos(ls_tono,li_fab,li_lin,ll_reftel,li_caract,li_dia,ll_color,li_tipo,ls_mensaje) = -1 THEN
//			Rollback;
//			MessageBox('Error','Se presentaron problemas cargando la tela a liberar, ERROR: '+ls_mensaje,StopSign!)
//			Return -1
//		END IF
//	END IF
//	IF dw_lista.GetItemNumber(li_fila,'sw_otro_estilo') = 1 THEN
//		//marcar rollos
//		li_tipo = 3
//		lb_marca = True
//		IF luo_proyeccion.of_marcarRollos(ls_tono,li_fab,li_lin,ll_reftel,li_caract,li_dia,ll_color,li_tipo,ls_mensaje) = -1 THEN
//			Rollback;
//			MessageBox('Error','Se presentaron problemas cargando la tela a liberar, ERROR: '+ls_mensaje,StopSign!)
//			Return -1
//		END IF
//	END IF
NEXT

IF lb_marca = True THEN
	Return 100
ELSE
	Return 0
END IF
end function

public function long of_validardatos ();//evento para validar que los datos seleccionados para la liberacion
//sean todos validos, que tenga tonos validos, kilos y que una tela color
//no tenga mas de un tono
//jcrm
//febrero 25 de 2008
Long li_marca, li_fila, li_marca_fila, li_fila2,&
		  li_fab, li_lin, li_result, li_marca_kilos, li_tipo_tejido
Long ll_reftel, ll_reftel_fila, ll_ref, ll_color, ll_color_fila, ll_color_pt
String ls_tono, ls_tono_fila, ls_marca, ls_mensaje
Decimal{2} ldc_kilos
s_base_parametros lstr_parametros, lstr_parametros_retro
n_cts_liberacion_x_proyeccion luo_proyeccion

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  rollo a liberar 1/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

ls_marca = 'sw_op_estilo'
FOR li_fila = 1 TO dw_lista.RowCount()	
	If ls_marca = 'sw_op_estilo' Then
		li_marca = dw_lista.GetItemNumber(li_fila,'sw_op_estilo')
	ElseIf ls_marca = 'sw_stock' Then
		li_marca = dw_lista.GetItemNumber(li_fila,'sw_stock')
	ElseIf ls_marca = 'sw_otro_estilo' Then
		li_marca = dw_lista.GetItemNumber(li_fila,'sw_otro_estilo')
	End if
	
	If li_marca = 1 Then
		li_fab = dw_lista.GetItemNumber(li_fila,'co_fabrica')
		li_lin = dw_lista.GetItemNumber(li_fila,'co_linea')
		ll_ref = dw_lista.GetItemNumber(li_fila,'co_referencia')
		ll_color_pt = dw_lista.GetItemNumber(li_fila,'co_color_pt')
		//se seleccionaron kilos para una liberacion se va a realizar la validacion inicial
		//que la fila si tenga tono (A,B $$HEX2$$f3002000$$ENDHEX$$C)
		ls_tono = dw_lista.GetItemString(li_fila,'tono')
		If ls_tono <> 'A' AND ls_tono <> 'B' AND ls_tono <> 'C' OR IsNull(ls_tono) Then
			//***************************************************************************
			//antes de aceptar la validacion se debe establecer si la referncia tiene una tela y un modelo
			//en cuyo caso se omite la validacion de tonos
			li_result = luo_proyeccion.of_contarmodelos(li_fab,li_lin,ll_ref,ll_color_pt,ls_mensaje)
			If li_result = -1 THEN
				//error al momento de validar los modelos de la referencia
				CLOSE(w_retroalimentacion)
				MessageBox('Advertencia',ls_mensaje,StopSign!)
				Return -1
			End if
			If li_result = 100 Then
				//antes de validar el tono debemos verificar si la tela es entretela en tal caso el tono no es
				//importante
				//jcrm
				//agosto 6 de 2008
				ll_reftel = dw_lista.GetItemNumber(li_fila,'co_reftel')
				li_tipo_tejido = luo_proyeccion.of_tipo_tejido(ll_reftel)	
				IF li_tipo_tejido <> 132 THEN
					CLOSE(w_retroalimentacion)
					MessageBox('Advertencia','Debe seleccionar kilos con tono asignado y valido.',StopSign!)
					Return -1
				END IF
			ElseIf li_result = 1 Then
			Else
				CLOSE(w_retroalimentacion)
				MessageBox('Advertencia','No fue posible determinar si se debe validar los tono para la referencia.',StopSign!)
				Return -1
			End if
			//***************************************************************************	
		End if
		//se verifica que los kilos sean validos, mayores a cero
		If ls_marca = 'sw_op_estilo' Then
			ldc_kilos = dw_lista.GetItemNumber(li_fila,'kg_estilo_op_1')
		End if	
		If ls_marca = 'sw_stock' Then
			ldc_kilos = dw_lista.GetItemNumber(li_fila,'kg_estilo_op_2')
		End if	
		If ls_marca = 'sw_otro_estilo' Then
			ldc_kilos = dw_lista.GetItemNumber(li_fila,'kg_estilo_op_3')
		End if	
		If IsNull(ldc_kilos) OR ldc_kilos = 0 Then
			CLOSE(w_retroalimentacion)
			MessageBox('Advertencia','Los kilos selecionados no son validos.',StopSign!)
			Return -1
		End if
		ll_reftel = dw_lista.GetItemNumber(li_fila,'co_reftel')
		ll_color  = dw_lista.GetItemNumber(li_fila,'co_color_te')
		//que una tela no tenga mas de un tono
		For li_fila2 = 1 To dw_lista.RowCount()
			ll_reftel_fila = dw_lista.GetItemNumber(li_fila2,'co_reftel')
			If ll_reftel = ll_reftel_fila AND li_fila2 <> li_fila Then
				li_marca_fila = dw_lista.GetItemNumber(li_fila2,'sw_op_estilo')
				If li_marca_fila = 0 Then
					li_marca_fila = dw_lista.GetItemNumber(li_fila2,'sw_stock')
					If li_marca_fila = 0 Then
						li_marca_fila = dw_lista.GetItemNumber(li_fila2,'sw_otro_estilo')
					End if
				End if
				ls_tono_fila = dw_lista.GetItemString(li_fila2,'tono')
				ll_color_fila = dw_lista.GetItemNumber(li_fila2,'co_color_te')
				If ls_tono <> ls_tono_fila AND li_marca_fila = 1 AND ll_color = ll_color_fila Then
					//*****************************************************************************
					//antes de aceptar la validacion se debe establecer si la referencia tiene una tela y un modelo
					//en cuyo caso se omite la validacion de tonos
					li_result = luo_proyeccion.of_contarmodelos(li_fab,li_lin,ll_ref,ll_color_pt,ls_mensaje)
					If li_result = -1 THEN
						//error al momento de validar los modelos de la referencia
						CLOSE(w_retroalimentacion)
						MessageBox('Advertencia',ls_mensaje,StopSign!)
						Return -1
					End if
					If li_result = 100 Then
						CLOSE(w_retroalimentacion)
						MessageBox('Advertencia','Para una misma tela solo puede seleccionar un tono.',StopSign!)
						Return -1
					ElseIf li_result = 1 Then
					Else
						CLOSE(w_retroalimentacion)
						MessageBox('Advertencia','No fue posible determinar si se debe validar los tono para la referencia.',StopSign!)
						Return -1
					End if
					//*****************************************************************************
//					CLOSE(w_retroalimentacion)
//					MessageBox('Advertencia','Para una misma tela solo puede seleccionar un tono.',StopSign!)
//					Return -1
				End if
			End if
		Next
	Else
		If ls_marca = 'sw_otro_estilo' Then
			//es el ultimo registro que se debe evaluar de la fila, se pasa a la siguiente fila
			ls_marca = 'sw_op_estilo'
		Else
			//aun faltan criterios para evaluar dentro de la fila
			li_fila -=  1
			If ls_marca = 'sw_op_estilo' Then
				ls_marca = 'sw_stock'
			ElseIf ls_marca = 'sw_stock' Then
				ls_marca = 'sw_otro_estilo'
			End if
			
		End if
		
	End if
NEXT

//se verifican que todas las telas tengan seleccionados kilos
ll_reftel = dw_lista.GetItemNumber(1,'co_reftel')
ls_marca = 'sw_op_estilo'
FOR li_fila = 1 TO dw_lista.RowCount()	
	ll_reftel_fila = dw_lista.GetItemNumber(li_fila,'co_reftel')
	IF ll_reftel_fila = ll_reftel THEN
		If ls_marca = 'sw_op_estilo' Then
			li_marca = dw_lista.GetItemNumber(li_fila,'sw_op_estilo')
		ElseIf ls_marca = 'sw_stock' Then
			li_marca = dw_lista.GetItemNumber(li_fila,'sw_stock')
		ElseIf ls_marca = 'sw_otro_estilo' Then
			li_marca = dw_lista.GetItemNumber(li_fila,'sw_otro_estilo')
		End if
		
		IF li_marca = 1 THEN
			li_marca_kilos = li_marca
		END IF
		
		If ls_marca = 'sw_otro_estilo' Then
			//es el ultimo registro que se debe evaluar de la fila, se pasa a la siguiente fila
			ls_marca = 'sw_op_estilo'
		Else
			//aun faltan criterios para evaluar dentro de la fila
			li_fila -=  1
			If ls_marca = 'sw_op_estilo' Then
				ls_marca = 'sw_stock'
			ElseIf ls_marca = 'sw_stock' Then
				ls_marca = 'sw_otro_estilo'
			End if
		End if
	ELSE
		IF li_marca_kilos = 0 THEN
			MessageBox('Error','No todos los modelos tienen seleccionados kilos')
			Return -1
		ELSE
			li_fila -=  1
			ll_reftel = ll_reftel_fila
			li_marca_kilos = 0 
		END IF	
	END IF
NEXT

Return 0
end function

public subroutine of_generar_liberacion ();LONG		ll_unid_color, ll_ref, ll_col, ll_ca_x_liberar
Long	ll_result, li_talla, ll_op_individual, ll_op_agrupadora
Integer	posi, li_fab, li_linea, li_agru, li_selec,li_prio_liberar
STRING	ls_usuario, ls_mensaje, ls_po
DECIMAL{2}	ld_porc_aplicar
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion
n_cts_cargar_temporales_liberacion luo_temporal
s_base_parametros lstr_parametros, lstr_parametros_retro


ld_porc_aplicar = 1
ls_usuario = Trim(gstr_info_usuario.codigo_usuario)
IF sle_talla.text  <> ''  THEN
	sle_talla.TriggerEvent(Modified!)
	ii_talla = Long(sle_talla.text)
ELSE
END IF

IF dw_lista.RowCount() = 0 THEN
	Return
END IF

dw_maestro.Reset()
dw_colores.Reset()
dw_detalle.Reset()

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  rollo a liberar 1/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

//se eliminan los datos de las temporales
If luo_temporal.of_borrarTemporales(ls_usuario) = -1 Then
	Rollback;
	CLOSE(w_retroalimentacion)
	Return
End if

//se validad que los datos seleccionados si puedan ser utilizados en la liberacion
//jcrm
//febrero 25 de 2008
If of_validardatos() = -1 Then
	Rollback;
	CLOSE(w_retroalimentacion)
	Return
End if

//traer el porcentaje a aplicar a la cantidad de tela cuando es una agrupada
FOR posi =1 TO dw_equivalencias.RowCount()
	li_fab = dw_equivalencias.GetItemNumber(posi,'co_fabrica')
	li_linea = dw_equivalencias.GetItemNumber(posi,'co_linea')
	ll_ref = dw_equivalencias.GetItemNumber(posi,'co_referencia')
	ll_col =  dw_equivalencias.GetItemNumber(posi,'co_color')
	li_agru = dw_equivalencias.GetitemNumber(posi,'agruapadas')
	ll_op_individual = dw_equivalencias.GetitemNumber(posi,'cs_ordenpd_pt')
	ll_op_agrupadora = dw_equivalencias.GetitemNumber(posi,'op_agrupadora')
	ll_ca_x_liberar = dw_equivalencias.GetitemNumber(posi,'compute_2')
	li_prio_liberar = dw_equivalencias.GetitemNumber(posi,'prio_liberar')
	
	
	li_selec = dw_equivalencias.GetitemNumber(posi,'selec')
	IF li_selec = 1 THEN
		INSERT INTO temp_op_agrupar(usuario, cs_ordenpd_pt_agru, cs_ordenpd_pt, ca_programar, prioridad)
			  VALUES (:ls_usuario, :ll_op_agrupadora, :ll_op_individual,:ll_ca_x_liberar, :li_prio_liberar);
	END IF
	 

		
NEXT
ld_porc_aplicar = 100

luo_liberacion_x_proyeccion.ib_tanda = ib_tanda
//se debe verificar si la liberacion es por make to stock ii_tipo_lib = 2
//o se trata de una liberacion make to order ii_tipo_lib = 1
//esto es con el fin de unificar en una misma ventana ambas liberaciones.
//jcrm
//junio 11 de 2008

IF ii_tipo_lib = 2 THEN //liberacion make to stock
	//********************************************
	//jcrm
	//febrero 18 de 2008
	//primero se resetean las marcar de los rollos
	IF luo_liberacion_x_proyeccion.of_resetiarmarca(ls_mensaje) = -1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','No fue posible inicializar los rollos, ERROR, '+ls_mensaje,StopSign!)
		Return
	END IF
	//evento para marcar los rollos seleccionados
	ll_result = of_actualizartemprefliberar()
	IF ll_result = 0 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','No encontr$$HEX2$$f3002000$$ENDHEX$$tela para realizar liberacion')
		Return
	ELSEIF ll_result = 1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		//MessageBox('Advertencia','Se presentaron problemas cargando la tela a liberar')
		Return
	END IF
	//Cargamos el total de unidades por estilo-color
	ll_unid_color = dw_lista.GetitemNumber(dw_lista.GetRow(),'tot_unid_liberar')
	//Buscamos la ultima orden de produccion activa para el estilo y utilizamos esta
	//en todos los proceso
	
	//*************************************************************************************************************************
	//se debe modificar la forma de capturar la OP, para que muestre una ventana con las OP de la referecia sin importar las
	//tallas, el encargado de la liberacion eligue la que se ajuste mejor, y las unidades de la liberacion deben respectar 
	//las de la OP sin que estas superen las de las criticas.
	//esto se pidio en la reunion del 12 de septiembre de 2008 en la reunion del sue$$HEX1$$f100$$ENDHEX$$o de BTT
	//jcrm - jorodrig
	//septiembre 15 de 2008
	//*************************************************************************************************************************

	IF ii_talla = 9999  THEN   //no es bodysise, se hace join con la tabla de criticas para que tome todas las tallas
		lstr_parametros.entero[1] = ii_fab
		lstr_parametros.entero[2] = ii_lin
		lstr_parametros.entero[3] = il_referencia
		lstr_parametros.entero[4] = il_color_pt
		lstr_parametros.entero[5] = 9999
		
		OpenWithParm(w_buscar_op_liberacion_duo,lstr_parametros)
		lstr_parametros = Message.PowerObjectParm	
//		il_ordenpd_pt = luo_liberacion_x_proyeccion.of_buscar_op_estilo(ii_fab, ii_lin, il_referencia, il_color_pt, 9999, ii_ano, ii_semana, 1,ii_opcion_liberar)
		IF lstr_parametros.hay_parametros THEN
		//IF il_ordenpd_pt > 0 THEN
			il_ordenpd_pt = lstr_parametros.entero[1]
		ELSE
			rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$una orden de produccion activa con el estilo-color-talla creado y con unidades pendientes, Proceda primero a crear la OP de Estilo')
			Return
		END IF
	ELSE
		//es un bodysize, se busca la op con la talla que se esta programando.
		lstr_parametros.entero[1] = ii_fab
		lstr_parametros.entero[2] = ii_lin
		lstr_parametros.entero[3] = il_referencia
		lstr_parametros.entero[4] = il_color_pt
		lstr_parametros.entero[5] = ii_talla
		
		OpenWithParm(w_buscar_op_liberacion_duo,lstr_parametros)
		lstr_parametros = Message.PowerObjectParm	
//		il_ordenpd_pt = luo_liberacion_x_proyeccion.of_buscar_op_estilo(ii_fab, ii_lin, il_referencia, il_color_pt, ii_talla, ii_ano, ii_semana, 1,ii_opcion_liberar)
		IF lstr_parametros.hay_parametros THEN
			il_ordenpd_pt = lstr_parametros.entero[1]
		//IF il_ordenpd_pt > 0 THEN
		ELSE
			Rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$una orden de produccion activa con el estilo-color-talla creado y con unidades pendientes, Proceda primero a crear la OP de Estilo')
			Return
		END IF
	END IF
	
	//traer la po que tiene asociada la orden de produccion
	SELECT MAX(nu_orden)
	  INTO :ls_po
	  FROM dt_caxpedidos 
	 WHERE cs_ordenpd_pt = :il_ordenpd_pt
		AND co_color = :il_color_pt
		AND ca_liberadas < ca_programada;
	
	
	//Cargamos la tabla temporal de rollos a liberar TEMP_TELA_N
	IF luo_liberacion_x_proyeccion.of_cargar_rollos_tablas_liberacion(ls_usuario, ii_fab, ii_lin, il_referencia, il_color_pt, il_ordenpd_pt, ii_talla, ld_porc_aplicar) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	
	CLOSE(w_retroalimentacion)
	//para mostrar ventana de espera  
	lstr_parametros_retro.cadena[1]="Procesando ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  Estilo-Color-Talla a liberar 2/6 "
	lstr_parametros_retro.cadena[3]="reloj"
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     
	
	//Cargamos la tabla temporal de estilos a liberar TEMP_REFEREN_N ( y colocamos las unidades a liberar)
	//debemos enviar el tipo de liberacion a trabajar 
	//jcrm
	//agosto 26 de 2008
	IF luo_liberacion_x_proyeccion.of_cargar_ref_tablas_liberacion(ii_ano, ii_semana, ii_fab, ii_lin, il_referencia, il_color_pt, ll_unid_color, il_ordenpd_pt, ls_po, ii_talla, ls_usuario, ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp, il_cons_lib_duo,li_agru) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	IF luo_liberacion_x_proyeccion.of_cargar_unid_liberar() <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
		
	dw_colores_op.Retrieve(il_ordenpd_pt)
	
ELSEIF ii_tipo_lib = 1 THEN //liberacion make to order
	//evento para marcar los rollos seleccionados
	ll_result = of_actualizartemprefliberar()
	IF ll_result = 0 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','No encontr$$HEX2$$f3002000$$ENDHEX$$tela para realizar liberacion')
		Return
	ELSEIF ll_result = 1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		//MessageBox('Advertencia','Se presentaron problemas cargando la tela a liberar')
		Return
	END IF
	
	//Cargamos el total de unidades por estilo-color
	ll_unid_color = dw_lista.GetitemNumber(dw_lista.GetRow(),'tot_unid_liberar')
	
	//traer la po que tiene asociada la orden de produccion
	SELECT MAX(nu_orden)
	  INTO :ls_po
	  FROM dt_caxpedidos 
	 WHERE cs_ordenpd_pt = :il_ordenpd_pt
		AND co_color 		= :il_color_pt
		AND color_exp 		= :is_color_exp;
	
	//Cargamos la tabla temporal de rollos a liberar
	IF luo_liberacion_x_proyeccion.of_cargar_rollos_tablas_liberacion(ls_usuario, ii_fab, ii_lin, il_referencia, il_color_pt, il_ordenpd_pt, ii_talla, ld_porc_aplicar) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	CLOSE(w_retroalimentacion)
	//para mostrar ventana de espera  
	lstr_parametros_retro.cadena[1]="Procesando ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  Estilo-Color-Talla a liberar 2/6 "
	lstr_parametros_retro.cadena[3]="reloj"
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     
	
//	//en este punto tenemos todos los datos a liberar, debemos verificar si en el pedido estan los datos como se usaran en la liberacion
//	//esto porque se a presentado casos donde se libera y el pedido habia cambiado, solicitado por Saul Martinez
//	//jcrm
//	//febrero 11 de 2008
//	IF luo_liberacion_x_proyeccion.of_pedido_vs_liberacion(ii_fab, ii_lin, il_referencia, il_color_pt, ii_talla, ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp, ls_po) = -1 THEN
//		Rollback;
//		CLOSE(w_retroalimentacion)
//		MessageBox('Advertencia','El pedido fue modificado o ya no existe, verifique sus datos.')
//		Return
//	END IF
		
	//Cargamos la tabla temporal de estilos a liberar
	IF luo_liberacion_x_proyeccion.of_cargar_ref_tablas_liberacion(0, 0, ii_fab, ii_lin, il_referencia, il_color_pt, ll_unid_color, il_ordenpd_pt, ls_po, ii_talla, ls_usuario, ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp,0,li_agru) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	IF luo_liberacion_x_proyeccion.of_cargar_unid_liberar() <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
END IF
//se cargan los datos en pantalla
ll_result = dw_maestro.Retrieve(ls_usuario)
If ll_result > 0 Then
	dw_colores.Retrieve(ls_usuario, il_ordenpd_pt)
END IF
CLOSE(w_retroalimentacion)


	
	
	
end subroutine

public function long of_act_datos_raya_dif_ppl (string as_usuario, long al_op, string as_po, long al_color);//
Datastore	lds_modelos
Long		li_filas, posi, li_talla, ll_unid, posi2, li_talla_ant
String		ls_filtro


lds_modelos = Create DataStore
lds_modelos.DataObject = 'ds_temp_modelos_ref_act_unid_raya'
lds_modelos.SetTransObject(sqlca)

li_talla_ant = -1
li_filas = lds_modelos.Retrieve(as_usuario,al_op,al_color,as_po)
FOR posi = 1 TO li_filas
	li_talla = lds_modelos.GetitemNumber(posi,'co_talla')
	IF li_talla <> li_talla_ant THEN
		ls_filtro = 'co_talla = '+ string(li_talla)
		lds_modelos.SetFilter(ls_filtro)
		lds_modelos.Filter()	
		ll_unid = lds_modelos.GetitemNumber(1,'unid_real_liberar')
		FOR posi2 = 2 TO lds_modelos.RowCount()
			lds_modelos.Setitem(posi2, 'unid_real_liberar', ll_unid)
		NEXT
	END IF
	li_talla_ant = li_talla
	ls_filtro = ''
	lds_modelos.SetFilter(ls_filtro)
	lds_modelos.Filter()
	
	lds_modelos.Setsort("co_talla, raya")
	lds_modelos.Sort()		
	
NEXT

IF lds_modelos.AcceptText() = -1 THEN
	MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error actualizando la informacion de las unidades en las rayas')
	RETURN -1
END IF
//No se necesita actualizar los datos - jorodrig - jjmonsal 15-09-2016
//	IF lds_modelos.Update() = -1 THEN
//		MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error grabando la informacion de las unidades en cada raya')
//		ROLLBACK;
//	   RETURN -1
//	ELSE
//		COMMIT;
//	END IF




Return 1
end function

public function long of_validar_surtido (string as_po, uo_dsbase ads_ean_sku, long al_row, ref uo_dsbase ads_ean_sin_surtido, ref uo_dsbase ads_ean_sin_instruccion_empaque, ref uo_dsbase ads_ean_sin_procesar);String ls_referencia, ls_talla, ls_color, ls_ean
Long ll_reg
uo_dsbase lds_detalle_surtido, lds_instruccion_empaque

lds_detalle_surtido = Create uo_dsbase
lds_detalle_surtido.DataObject = 'd_gr_hallar_surtido_prepack'
lds_detalle_surtido.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_instruccion_empaque = Create uo_dsbase
lds_instruccion_empaque.DataObject = 'd_gr_hallar_instruccion_empaque'
lds_instruccion_empaque.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

ls_referencia = Trim(ads_ean_sku.GetItemString(al_row, 'co_referencia'))
ls_talla = Trim(ads_ean_sku.GetItemString(al_row, 'co_talla'))
ls_color = Trim(ads_ean_sku.GetItemString(al_row, 'co_color'))
ls_ean = Trim(ads_ean_sku.GetItemString(al_row, 'barcode'))

// Si no se enuentra un detalle de surtido para este ean
If lds_detalle_surtido.Of_Retrieve(ls_referencia, ls_talla, ls_color) <= 0 Then
	ll_reg = ads_ean_sin_surtido.Find("barcode = '" + ls_ean + "'", 1, ads_ean_sin_surtido.RowCount() + 1)
	If ll_reg = 0 Then
		ads_ean_sku.RowsCopy(al_row, al_row, Primary!, ads_ean_sin_surtido, ads_ean_sin_surtido.RowCount() + 1, Primary!)
	End If
Else
	If lds_instruccion_empaque.Of_Retrieve(as_po, lds_detalle_surtido.GetItemString(1, 'co_prepack')) <= 0 Then
		ll_reg = ads_ean_sin_instruccion_empaque.Find("barcode = '" + ls_ean + "'", 1, ads_ean_sin_instruccion_empaque.RowCount() + 1)
		If ll_reg = 0 Then
			ads_ean_sku.RowsCopy(al_row, al_row, Primary!, ads_ean_sin_instruccion_empaque, ads_ean_sin_instruccion_empaque.RowCount() + 1, Primary!)
		End If
	Else
		If lds_instruccion_empaque.GetItemString(1, 'estado') <> '2' And lds_instruccion_empaque.GetItemString(1, 'estado') <> '0' Then
			ll_reg = ads_ean_sin_procesar.Find("barcode = '" + ls_ean + "'", 1, ads_ean_sin_procesar.RowCount() + 1)
			If ll_reg = 0 Then
				ads_ean_sku.RowsCopy(al_row, al_row, Primary!, ads_ean_sin_procesar, ads_ean_sin_procesar.RowCount() + 1, Primary!)
				ads_ean_sin_procesar.SetItem(ads_ean_sin_procesar.RowCount(), 'tipo_pedido', lds_instruccion_empaque.GetItemString(1, 'estado'))
			End If
		End If
	End If
End If


Return 1
end function

on w_existencias_tela_critica.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_duo_conjunto=create cb_duo_conjunto
this.cb_xtono=create cb_xtono
this.cb_xtanda=create cb_xtanda
this.st_talla=create st_talla
this.sle_talla=create sle_talla
this.dw_unidxcolorxtalla=create dw_unidxcolorxtalla
this.dw_colores_op=create dw_colores_op
this.dw_partes=create dw_partes
this.cb_inventario=create cb_inventario
this.dw_unid_x_liberar=create dw_unid_x_liberar
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_calc_propor=create cb_calc_propor
this.cb_1=create cb_1
this.cb_calidad=create cb_calidad
this.cb_liberar=create cb_liberar
this.st_1=create st_1
this.dw_detalle=create dw_detalle
this.dw_colores=create dw_colores
this.dw_maestro=create dw_maestro
this.cb_buscar=create cb_buscar
this.cb_cerrar=create cb_cerrar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.dw_equivalencias=create dw_equivalencias
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_duo_conjunto,&
this.cb_xtono,&
this.cb_xtanda,&
this.st_talla,&
this.sle_talla,&
this.dw_unidxcolorxtalla,&
this.dw_colores_op,&
this.dw_partes,&
this.cb_inventario,&
this.dw_unid_x_liberar,&
this.st_2,&
this.cb_2,&
this.cb_calc_propor,&
this.cb_1,&
this.cb_calidad,&
this.cb_liberar,&
this.st_1,&
this.dw_detalle,&
this.dw_colores,&
this.dw_maestro,&
this.cb_buscar,&
this.cb_cerrar,&
this.dw_lista,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5,&
this.gb_6,&
this.dw_equivalencias}
end on

on w_existencias_tela_critica.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_duo_conjunto)
destroy(this.cb_xtono)
destroy(this.cb_xtanda)
destroy(this.st_talla)
destroy(this.sle_talla)
destroy(this.dw_unidxcolorxtalla)
destroy(this.dw_colores_op)
destroy(this.dw_partes)
destroy(this.cb_inventario)
destroy(this.dw_unid_x_liberar)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_calc_propor)
destroy(this.cb_1)
destroy(this.cb_calidad)
destroy(this.cb_liberar)
destroy(this.st_1)
destroy(this.dw_detalle)
destroy(this.dw_colores)
destroy(this.dw_maestro)
destroy(this.cb_buscar)
destroy(this.cb_cerrar)
destroy(this.dw_lista)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.dw_equivalencias)
end on

event open;Long li_result
String ls_mensaje
LONG		ll_op_individual, ll_ca_x_liberar
INTEGER	li_prio_liberar, li_selec, posi

s_base_parametros lstr_parametros
n_cts_liberacion_x_proyeccion luo_proyeccion
n_cts_cargar_temporales_liberacion luo_cargar_temporales_liberacion

//si el perfil no esta autorizado a liberar se deshabilitan los botones de liberacion
IF gstr_info_usuario.codigo_perfil = 9 OR gstr_info_usuario.codigo_perfil = 13 OR  gstr_info_usuario.codigo_perfil = 17  OR  gstr_info_usuario.codigo_perfil = 27  OR &
   gstr_info_usuario.codigo_perfil = 16 OR gstr_info_usuario.codigo_perfil = 20 OR  gstr_info_usuario.codigo_perfil = 1 OR gstr_info_usuario.codigo_perfil = 5 THEN

ELSE
	cb_buscar.Visible 	= False
	cb_xtanda.Visible 	= False

	cb_liberar.Visible 	= False
	cb_2.Visible 			= False
	cb_1.Visible 			= False
	cb_calidad.Visible 	= False
END IF

lstr_parametros = Message.PowerObjectParm
ii_fab 			= lstr_parametros.entero[1]
ii_lin 			= lstr_parametros.entero[2]
il_referencia 	= lstr_parametros.entero[3]
il_color_pt 	= lstr_parametros.entero[4]
ii_ano 			= lstr_parametros.entero[5]
ii_semana 		= lstr_parametros.entero[6]
ii_talla 		= lstr_parametros.entero[7]
il_ordenpd_pt	= lstr_parametros.entero[8]
ii_linea_exp 	= lstr_parametros.entero[9]
ii_fab_exp		= lstr_parametros.entero[10]
is_ref_exp 		= lstr_parametros.cadena[1]
is_color_exp 	= lstr_parametros.cadena[2]
ii_unir_op		= lstr_parametros.entero[12]
ii_opcion_liberar = lstr_parametros.entero[11] //1 = equilibrar unidades
															  //2 = cantidades iguales	
il_op_agrupada = lstr_parametros.entero[13]

ii_cs_agrupa_lib = 0
ii_cs_agrupa_lib =  lstr_parametros.entero[14]

ii_act_unid = 0															  
IF ii_opcion_liberar = 0 THEN
	cb_buscar.Visible 	= False
	cb_xtanda.Visible 	= False
	cb_liberar.Visible 	= False
	cb_2.Visible 			= False
	cb_1.Visible 			= False
	cb_calidad.Visible 	= False
END IF
															  
//se trae el consecutivo para las liberaciones make to stock, ya que estas pueden ser de duos y conjuntos
IF ii_opcion_liberar = 2 /*ii_tipo_lib = 2*/ THEN
	IF luo_proyeccion.of_cons_lib_duo(il_cons_lib_duo,ls_mensaje) = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de generar el consecutivo de duos y conjuntos, ERROR: '+ls_mensaje,StopSign!)
		Return
	END IF
END IF															  
															  
IF ii_opcion_liberar = 2 THEN
	cb_duo_conjunto.Visible = True
END IF

IF il_ordenpd_pt = 0 THEN  //es liberacion por STOCK, se carga unidades segun criticas
	ii_tipo_lib = 2  //liberacion por make to stock
	dw_unid_x_liberar.DataObject = 'dtb_rep_criticas_liberacion_x_ref_col'
	dw_unid_x_liberar.SetTransObject(sqlca)
//	dw_unid_x_liberar.Retrieve(ii_ano,ii_semana,ii_fab,ii_lin,il_referencia,il_color_pt,ii_linea_exp,is_ref_exp,is_color_exp,ii_opcion_liberar)
ELSE  //es liberacion por PEDIDO, se cargan las unidades a liberar segun la op
	
	//verificar que la referencia no este en las criticas, en este caso se debe liberar
	//por las criticas,  esto se decidio en reunion de sue$$HEX1$$f100$$ENDHEX$$o btt el 15 de agosto del 2008
	
	/*se quita el control temporalmente mientras se encuentra un error en las cantidades
	esto lo solicita Hector Osorno  Oct 6 - 2008
	li_result = luo_cargar_temporales_liberacion.of_referenciacritica(ii_fab,ii_lin,il_referencia,ii_talla,il_color_pt)
	If li_result = 0 Then//es ref de criticas  se sale
		MessageBox('Advertencia','La referencia esta dentro de las criticas, se debe liberar por criticas')
		close(this)
		
	End if
	*/
	ii_tipo_lib = 1  //liberacion por pedido
	dw_unid_x_liberar.DataObject = 'dtb_rep_x_liberar_x_ref_col'
	dw_unid_x_liberar.SetTransObject(sqlca)
	IF il_op_agrupada > 0 THEN
		dw_unid_x_liberar.Retrieve(il_op_agrupada,il_color_pt,is_color_exp,gstr_info_usuario.codigo_usuario)
	ELSE
		dw_unid_x_liberar.Retrieve(il_ordenpd_pt,il_color_pt,is_color_exp,gstr_info_usuario.codigo_usuario)
	END IF	
END IF

dw_partes.SetTransObject(sqlca)
dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(gstr_info_usuario.codigo_usuario,il_ordenpd_pt,il_op_agrupada)
dw_lista.SetFocus()

dw_maestro.SetTransObject(sqlca)
dw_detalle.SetTransObject(sqlca)
dw_colores.SetTransObject(sqlca)
dw_colores_op.SetTransObject(sqlca)
dw_unidxcolorxtalla.SetTransObject(sqlca)
dw_equivalencias.SetTransObject(sqlca)

IF ii_tipo_lib = 1 THEN
	cb_inventario.Visible = True
	sle_talla.Visible = True
	st_talla.Visible = True
	//sle_talla.Text = String(ii_talla)
	dw_colores_op.Retrieve(il_ordenpd_pt)
	gb_1.y = 452
	gb_1.Height = 752
	dw_lista.y = 496
	dw_lista.Height = 688
//	gb_1.y = 104
//	gb_1.Height = 1084
//	dw_lista.y = 156
//	dw_lista.Height = 1020
	//il_cons_lib_duo = 0
	gb_6.Visible = True
	dw_equivalencias.Visible = True
	IF IsNull(ii_fab_exp) OR IsNull(ii_linea_exp) OR IsNull(is_ref_exp) THEN
	ELSE
		li_result = dw_equivalencias.Retrieve(ii_unir_op,is_color_exp,il_op_agrupada,ii_cs_agrupa_lib)
	END IF
ELSE
	gb_1.y = 452
	gb_1.Height = 752
	dw_lista.y = 496
	dw_lista.Height = 688
	gb_6.Visible = True
	dw_equivalencias.Visible = True
	li_result = dw_equivalencias.Retrieve(ii_fab_exp,ii_linea_exp,is_ref_exp,is_color_exp,ii_ano,ii_semana)
	
END IF


IF il_op_agrupada > 0 THEN
	
	
	DELETE FROM temp_op_agrupar
	WHERE usuario = :gstr_info_usuario.codigo_usuario;
	If sqlca.sqlcode = -1 Then
		Rollback;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de eliminar la temporal temp_op_agrupar, se recomiendo cancelar el proceso pues podr$$HEX1$$ed00$$ENDHEX$$a quedar mal liberada ')
		Return -1
	Else
		Commit;	
	End if
	
FOR posi =1 TO dw_equivalencias.RowCount()
	ll_op_individual = dw_equivalencias.GetitemNumber(posi,'cs_ordenpd_pt')
	ll_ca_x_liberar = dw_equivalencias.GetitemNumber(posi,'compute_2')
	li_prio_liberar = dw_equivalencias.GetitemNumber(posi,'prio_liberar')
	li_selec = dw_equivalencias.GetitemNumber(posi,'selec')
	IF li_selec = 1 THEN
		INSERT INTO temp_op_agrupar(usuario, cs_ordenpd_pt_agru, cs_ordenpd_pt, ca_programar, prioridad)
			  VALUES (:gstr_info_usuario.codigo_usuario, :il_op_agrupada, :ll_op_individual,:ll_ca_x_liberar, :li_prio_liberar);
	  	If sqlca.sqlcode = -1 Then
			Rollback;
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar la temporal temp_op_agrupar,con las OP individuales que forman la agrupada, Se recomienda cancelar el proceso pues la agrupada podr$$HEX1$$ed00$$ENDHEX$$a quedar mal liberada ')
			Return -1
		Else
			Commit;	
		End if
	END IF
	 
NEXT
END IF


end event

event closequery;//si el usuario intenta salirse sin haber liberados todas las referencias de un 
//duo o conjunto se debe informar al usuario que estas seran eliminadas del sistema
//jcrm - jorodrig
//agosto 26 de 2008
Long li_respuesta
n_cts_liberacion_x_proyeccion luo_liberacion



IF il_cons_lib_duo > 0 THEN
//	li_respuesta = MessageBox("Advertencia",'Si aun no ha aceptado la liberaci$$HEX1$$f300$$ENDHEX$$n de todas las O.P. que forman el Duo o Conjunto, ~n perdera la informaci$$HEX1$$f300$$ENDHEX$$n de estas, esta seguro de salirse',Exclamation!, YesNo!, 2 )
//	//se anulan las liberaciones que pertenecen al duo o conjunto
//	IF li_respuesta = 1 THEN
		IF luo_liberacion.of_anular_liberacion_duo_conjunto(il_cons_lib_duo) = -1 THEN
				Rollback;
				Return
		ELSE
			Commit;
		END IF
//	ELSE
//		Return
//	END IF
END IF




end event

type cb_4 from commandbutton within w_existencias_tela_critica
integer x = 4087
integer y = 48
integer width = 343
integer height = 96
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "U.Agrup"
end type

event clicked;//

//


IF dw_unid_x_liberar.DataObject = 'dtb_rep_x_liberar_x_ref_col_agru' THEN
	dw_unid_x_liberar.DataObject = 'dtb_rep_x_liberar_x_ref_col'
ELSE
	dw_unid_x_liberar.DataObject = 'dtb_rep_x_liberar_x_ref_col_agru'
END IF
dw_unid_x_liberar.SetTransObject(sqlca)

IF dw_unid_x_liberar.Retrieve(il_op_agrupada,il_color_pt,is_color_exp,gstr_info_usuario.codigo_usuario) = 0 THEN
	 dw_unid_x_liberar.Retrieve(il_ordenpd_pt,il_color_pt,is_color_exp,gstr_info_usuario.codigo_usuario) 
END IF
end event

type cb_3 from commandbutton within w_existencias_tela_critica
boolean visible = false
integer x = 3131
integer y = 20
integer width = 343
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Tela Sustituta"
end type

event clicked;//evento utilizado para poder marcar los rollos con tela sustituta
//y modificarla por la referencia de tela correcta.
//jcrm
//abril 3 de 2009
Long li_centroterm
n_cts_constantes luo_constantes
luo_constantes = Create n_cts_constantes
s_base_parametros lstr_parametros

lstr_parametros.entero[1] = il_ordenpd_pt
lstr_parametros.entero[2] = il_color_pt

li_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
IF li_centroterm = -1 THEN
	MessageBox('Error','No fue posible establecer el centro de los rollos para Marinilla.')
	Return 
END IF

lstr_parametros.entero[3] = li_centroterm

IF IsNull(lstr_parametros.entero[1]) Or IsNull(lstr_parametros.entero[2]) THEN
	MessageBox('Advertencia','Para utilizar esta opci$$HEX1$$f300$$ENDHEX$$n es necesario que ingrese La OP de Estilo y el color.',Exclamation!)
	Return
END IF

OpenSheetWithParm(w_rollos_tela_sustituta, lstr_parametros, w_existencias_tela_critica, 0, Original!)

end event

type cb_duo_conjunto from commandbutton within w_existencias_tela_critica
integer x = 2747
integer y = 20
integer width = 366
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Duo / Conjunto"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.entero[1] = il_cons_lib_duo
lstr_parametros.entero[2] = dw_equivalencias.RowCount()

openwithparm(w_liberaciones_generadas_duos,lstr_parametros)
end event

type cb_xtono from commandbutton within w_existencias_tela_critica
integer x = 736
integer y = 20
integer width = 233
integer height = 84
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "X Tono"
end type

event clicked;n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion
//se revisa si se va a liberar por tanda o por tono, segun lo elegido en la ventana
ib_tanda = false

//El color 601 es el crudo APT, en reunion del 5 -04 - 2011 se define que este solo
//se debe liberar por tanda (calidad - Esteban - ingenieria - Ubeimar - jhonny) en sala RL  jorodrig
IF il_color_pt = 601 THEN
	MessageBox('Advertencia','El color crudo 601 APT solo se puede liberar por tanda')
	Return
END IF

of_generar_liberacion()
//cb_buscar.Triggerevent('clicked')
end event

type cb_xtanda from commandbutton within w_existencias_tela_critica
integer x = 485
integer y = 20
integer width = 233
integer height = 84
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "X Tanda"
end type

event clicked;n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion
//se revisa si se va a liberar por tanda o por tono, segun lo elegido en la ventana
ib_tanda = true

of_generar_liberacion()
//cb_buscar.Triggerevent('clicked')

//cuando se genera la liberacion por tanda, se verifica que si exsitan datos por tanda, si no es asi, se
//habilita la opcion para liberar por tono.
IF dw_colores.RowCount() <= 0 THEN
	cb_xtono.Visible = True
END IF
end event

type st_talla from statictext within w_existencias_tela_critica
boolean visible = false
integer x = 55
integer y = 28
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Talla:"
boolean focusrectangle = false
end type

type sle_talla from singlelineedit within w_existencias_tela_critica
boolean visible = false
integer x = 233
integer y = 20
integer width = 192
integer height = 84
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//se verifica que la talla ingresada si este creada en la OP - Color
//jcrm
//junio 25 de 2008

Long li_talla
long ll_found

li_talla = Long(sle_talla.Text)

ll_found = dw_unid_x_liberar.Find("co_talla = " +String(li_talla), 1, dw_unid_x_liberar.RowCount())

IF ll_found = 0 THEN
	MessageBox('Error','La talla Ingresada no es valida.',StopSign!)
	sle_talla.Text = ''
	Return
ELSE
	ii_talla = li_talla
END IF
	


end event

type dw_unidxcolorxtalla from datawindow within w_existencias_tela_critica
integer x = 3383
integer y = 1748
integer width = 1330
integer height = 656
integer taborder = 190
string title = "none"
string dataobject = "dtb_unidades_libxcolor_talla_exp"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_colores_op from datawindow within w_existencias_tela_critica
integer x = 3378
integer y = 1308
integer width = 1129
integer height = 400
integer taborder = 140
string title = "none"
string dataobject = "dgr_color_op"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Long li_fabrica, li_linea, li_result
Long ll_referencia, ll_pedido, ll_color
STRING	ls_po

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ll_color = This.GetItemNumber(row,'co_color')
ll_pedido = This.GetItemNumber(row,'pedido')
ls_po    = This.GetItemString(row,'nu_orden')


//dw_unidxcolorxtalla.DataObject = 'dtb_unidades_libxcolor_talla_exp'
//dw_unidxcolorxtalla.SetTransObject(sqlca)
li_result = dw_unidxcolorxtalla.Retrieve(il_ordenpd_pt, ls_po, ll_color,ll_pedido, il_op_agrupada,gstr_info_usuario.codigo_usuario )

end event

type dw_partes from datawindow within w_existencias_tela_critica
integer x = 41
integer y = 1984
integer width = 1106
integer height = 432
integer taborder = 160
string title = "none"
string dataobject = "dgr_modelos_partes_liberacion"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cb_inventario from commandbutton within w_existencias_tela_critica
boolean visible = false
integer x = 2350
integer y = 20
integer width = 379
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Inv. en BTT"
end type

event clicked;Long li_fila
s_base_parametros lstr_parametros

li_fila = dw_lista.GetRow()

IF li_fila > 0 THEN
	lstr_parametros.entero[1] = dw_lista.GetItemNumber(li_fila,'co_reftel')
	lstr_parametros.entero[2] = dw_lista.GetItemNumber(li_fila,'co_caract')
	lstr_parametros.entero[3] = dw_lista.GetItemNumber(li_fila,'diametro')
	lstr_parametros.entero[4] = dw_lista.GetItemNumber(li_fila,'co_color_te')
	lstr_parametros.entero[5] = il_ordenpd_pt
ELSE
	MessageBox('Error','Fila seleccionada no valida.',StopSign!)
	Return
END IF

OpenWithParm ( w_inventario_btt_make_to_order, lstr_parametros )
end event

type dw_unid_x_liberar from datawindow within w_existencias_tela_critica
integer x = 4009
integer y = 148
integer width = 855
integer height = 1052
integer taborder = 20
string title = "none"
string dataobject = "dtb_rep_x_liberar_x_ref_col"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_existencias_tela_critica
integer x = 50
integer y = 2432
integer width = 1595
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione la tela a utilizar y luego presione el bot$$HEX1$$f300$$ENDHEX$$n Generar Liberaci$$HEX1$$f300$$ENDHEX$$n"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_existencias_tela_critica
integer x = 1385
integer y = 20
integer width = 315
integer height = 84
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "% Permitido"
end type

event clicked;Long ll_fila, ll_referencia
s_base_parametros lstr_parametros

ll_fila = dw_lista.GetRow()

If ll_fila > 0 Then
	ll_referencia = dw_lista.GetItemNumber(ll_fila,'co_referencia')
	lstr_parametros.entero[1] = ll_referencia
Else
	lstr_parametros.entero[1] = 0
End if

OpenSheetWithParm(w_administracion_porc_permitido_ref,lstr_parametros,w_principal,0,Original!)
end event

type cb_calc_propor from commandbutton within w_existencias_tela_critica
integer x = 2967
integer y = 1652
integer width = 343
integer height = 80
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Calcular"
end type

event clicked;Long		li_prop, li_tot_prop, pos, li_propor_fila
Long			ll_tot_unid, ll_unidades
Decimal{2}	ld_factor

dw_detalle.Accepttext()


FOR pos = 1 TO 1
	li_tot_prop = dw_detalle.GetItemNumber(pos,'tot_propor')
	ll_tot_unid = dw_detalle.GetItemNumber(pos,'tot_unid')
NEXT
ld_factor = (ll_tot_unid / li_tot_prop)


FOR pos = 1 TO dw_detalle.RowCount()
	
	li_propor_fila = dw_detalle.GetItemNumber(pos,'proporcion')
	ll_unidades = ld_factor * li_propor_fila
	dw_detalle.SetItem(pos, 'unid_real_liberar',ll_unidades)
	
NEXT		
	
dw_detalle.Accepttext()
cb_liberar.Enabled = True		
		
	
	


end event

type cb_1 from commandbutton within w_existencias_tela_critica
integer x = 1719
integer y = 20
integer width = 361
integer height = 84
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Unid x Modelo"
end type

event clicked;String ls_usuario
long ll_ordenpd
long	ll_color

s_base_parametros lstr_parametros

ls_usuario = gstr_info_usuario.codigo_usuario

//ll_ordenpd = dw_maestro.getitemnumber(dw_maestro.getrow(),"cs_ordenpd_pt")
ll_color = dw_colores.getitemnumber(dw_colores.getrow(),"co_color")
lstr_parametros.cadena[1] = ls_usuario

lstr_parametros.entero[1] = il_ordenpd_pt
lstr_parametros.entero[2] = ll_color

openwithparm(w_unid_referencias,lstr_parametros)
end event

type cb_calidad from commandbutton within w_existencias_tela_critica
integer x = 2098
integer y = 20
integer width = 233
integer height = 84
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Calidad"
end type

event clicked;Long ll_result
String ls_mensaje
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion
s_base_parametros lstr_parametros, lstr_parametros_retro


IF MessageBox("Verificacion", "Esta seguro de marcar la tela para hacer pruebas de tono en calidad?", Question!, YesNo!, 2) = 2 THEN
	Return
END IF

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  rollo a calidad"
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

//jcrm
//febrero 21 de 2008
//se inicializa el estado de los rollos
IF luo_liberacion_x_proyeccion.of_resetiarmarca(ls_mensaje) = -1 THEN
	Rollback;
	CLOSE(w_retroalimentacion)
	MessageBox('Advertencia','No fue posible inicializar los rollos, ERROR, '+ls_mensaje,StopSign!)
	Return
END IF

//evento para marcar los rollos seleccionados
ll_result = of_actualizartemprefliberar()
IF ll_result = 0 THEN
	Rollback;
	CLOSE(w_retroalimentacion)
	MessageBox('Advertencia','No encontr$$HEX2$$f3002000$$ENDHEX$$tela para realizar liberaci$$HEX1$$f300$$ENDHEX$$n')
	Return
ELSEIF ll_result = -1 THEN
	Rollback;
	CLOSE(w_retroalimentacion)
	MessageBox('Advertencia','Se presentaron problemas cargando la tela a liberar')
	Return
END IF

//se cargan los rollos seleccionados a la tabla que sera utilizada en calida.
//pero antes de esto debemos establecer el tono en el cual se necesita que esten los rollos
//Open(w_tono_calidad)
//lstr_parametros = Message.PowerObjectParm	

//IF lstr_parametros.hay_parametros THEN
	IF luo_liberacion_x_proyeccion.of_cargarRollosCalidad(ls_mensaje,''/*lstr_parametros.cadena[1]*/) = -1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar los rollos para aprobaci$$HEX1$$f300$$ENDHEX$$n de tono. '+ls_mensaje,StopSign!)
		Return
	ELSE
		Commit;
		CLOSE(w_retroalimentacion)
		MessageBox('Exito','Los rollos fueron ingresados a la espera de aprobaci$$HEX1$$f300$$ENDHEX$$n de calidad. ',Exclamation!)
	END IF
//ELSE
//	
//END IF




end event

type cb_liberar from commandbutton within w_existencias_tela_critica
integer x = 987
integer y = 20
integer width = 379
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar Libera"
end type

event clicked;//Evento para cargar los datos generados de la liberacion de las tablas temporal a 
//las tablas de la liberaci$$HEX1$$f300$$ENDHEX$$n
Long 	ll_ordenpd_pt, ll_tanda, ll_referencia,  ll_unid_liberar, ll_unid_real_liberar,ll_tela, ll_diferencia, ll_dif_permitida, ll_n
Long ll_color, ll_color_old, ll_correo_precio_cero
String ls_po, ls_usuario, ls_po_new, ls_po_old, ls_tono, ls_error, ls_mensaje, ls_mensaje_correo, ls_de_referencia, ls_categoria_sap
Long	li_fabrica, li_linea, li_modelos_ficha, li_modelos_liberar, li_critica, posi, li_raya, li_porc_mas_comple, li_tlla
Decimal{4} ldc_ancho
Integer	li_op_agrupada
Dec ldc_valor
n_cts_liberacion_semiautomatica luo_liberar
n_cts_liberacion_x_proyeccion luo_proyeccion
n_cts_cargar_temporales_liberacion luo_cargar_temporales_liberacion
n_cts_constantes_corte luo_constantes
uo_dsbase lds_ean_sku, lds_ean_sin_surtido, lds_ean_sin_instruccion_empaque, lds_ean_sin_procesar
//*********************************************************************
DataStore lds_total_modelos_liberacion, lds_total_modelos_ficha, lds_modelos_ref

lds_total_modelos_liberacion = Create DataStore
lds_total_modelos_liberacion.DataObject = 'ds_total_modelos_liberacion'
lds_total_modelos_liberacion.SetTransObject(sqlca)

lds_total_modelos_ficha = Create DataStore
lds_total_modelos_ficha.DataObject = 'ds_total_modelos_ficha'
lds_total_modelos_ficha.SetTransObject(sqlca)

lds_modelos_ref = Create DataStore
lds_modelos_ref.DataObject = 'ds_modelos_ref'
lds_modelos_ref.SetTransObject(sqlca)


lds_ean_sku = Create uo_dsbase
lds_ean_sku.DataObject = 'd_gr_ean_x_orden_sku_vta'
lds_ean_sku.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_ean_sin_surtido = Create uo_dsbase
lds_ean_sin_surtido.DataObject = 'd_gr_ean_x_orden_sku_vta'
lds_ean_sin_surtido.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_ean_sin_instruccion_empaque = Create uo_dsbase
lds_ean_sin_instruccion_empaque.DataObject = 'd_gr_ean_x_orden_sku_vta'
lds_ean_sin_instruccion_empaque.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

lds_ean_sin_procesar = Create uo_dsbase
lds_ean_sin_procesar.DataObject = 'd_gr_ean_x_orden_sku_vta'
lds_ean_sin_procesar.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ) )

ls_usuario = gstr_info_usuario.codigo_usuario
ll_correo_precio_cero = luo_constantes.of_consultar_numerico("CORREO_PRECIO_CERO")

uo_correo	 lnv_correo
lnv_correo = CREATE uo_correo

IF dw_detalle.AcceptText() = -1 THEN
	MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error actualizando la informacion')
	RETURN 
ELSE
	IF dw_detalle.Update() = -1 THEN
		MessageBox('Error','Se present$$HEX2$$f3002000$$ENDHEX$$un error grabando la informacion')
		ROLLBACK;
	   RETURN 
	ELSE
		COMMIT;
	END IF
END IF



ll_color_old = -1
ls_po_old = ''

//Se crea para verificar los modelos antes de cargar a las tablas de la liberacion, se verifica
//que el total de modelos de la ficha sea igual al total de modelos a cargar mayo 26-2006
li_fabrica = dw_detalle.GetItemNumber(1,'co_fabrica')
li_linea = dw_detalle.GetItemNumber(1,'co_linea')
ll_referencia = dw_detalle.GetItemNumber(1,'co_referencia')
ll_color = dw_detalle.GetItemNumber(1,'co_color')
ll_ordenpd_pt = dw_detalle.GetItemNumber(1,'cs_ordenpd_pt')


li_modelos_ficha = lds_total_modelos_ficha.Retrieve(li_fabrica,li_linea,ll_referencia,ll_color)
li_modelos_liberar = lds_total_modelos_liberacion.Retrieve(ls_usuario,ll_ordenpd_pt)

IF li_modelos_ficha <> li_modelos_liberar THEN
	MessageBox('Error','El total de modelos a liberar es diferente al total de modelos de la ficha, Verifique en el boton Unid x Modelo.')
	cb_xtono.Visible 		= True
	Return
END IF

//*********************************************************************

//Ubeimar y Walter solicitan sacar un mensaje cuando en los complementos se esten liberando
//mas unidades con la tela que se tiene que las que se van a programar, esto para evitar que
//se gasten en los complementos la tela que va para otras op, el % inicial de mas es sobre el 15% segun correo Walter
//nov 22 -2010 jorodrig
lds_modelos_ref.Retrieve(ls_usuario)
lds_modelos_ref.SetFilter('sw_carga =1 and  raya <> 10')
lds_modelos_ref.Filter()
ls_mensaje = ''

li_porc_mas_comple = luo_constantes.of_consultar_numerico("PORC_MAS_LIB_COMPLE")

IF li_porc_mas_comple = -1 THEN
	MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante de cantidad de mas que se puede liberar en complemento, por defecto se deja en 15')
	li_porc_mas_comple = 15
END IF

FOR posi = 1 TO lds_modelos_ref.RowCount()
	ll_unid_liberar 		= lds_modelos_ref.GetitemNumber(posi, 'unid_liberar')
	ll_unid_real_liberar = lds_modelos_ref.GetitemNumber(posi, 'unid_real_liberar')
	ll_dif_permitida		= (ll_unid_real_liberar * li_porc_mas_comple) / 100
	ll_diferencia 			= ll_unid_liberar - ll_unid_real_liberar
	IF ll_diferencia > ll_dif_permitida THEN
		li_tlla = lds_modelos_ref.GetitemNumber(posi, 'co_talla')
		li_raya = lds_modelos_ref.GetitemNumber(posi, 'raya')
		ll_tela = lds_modelos_ref.GetitemNumber(posi, 'co_reftel')
		ls_mensaje = ls_mensaje + '-Talla: ' +TRIM(string(li_tlla)) +'  Raya: ' + TRIM(string(li_raya)) + ' Tela: ' + TRIM(string(ll_tela)) + ' Unddes de m$$HEX1$$e100$$ENDHEX$$s: ' + TRIM(string(ll_diferencia)) + '~n'
	END IF
NEXT
lds_modelos_ref.SetFilter('')
lds_modelos_ref.Filter()

IF ls_mensaje = '' THEN
ELSE
	IF MessageBox("Verificacion", "Unidades de mas: " + ls_mensaje + "Desea continuar?", Question!, YesNo!, 2) = 2 THEN
		Return
	END IF
END IF
//*********************************************************************

ls_usuario = gstr_info_usuario.codigo_usuario
////se trae el consecutivo para las liberaciones make to stock, ya que estas pueden ser de duos y conjuntos
//IF ii_opcion_liberar = 2 /*ii_tipo_lib = 2*/ THEN
//	IF luo_proyeccion.of_cons_lib_duo(il_cons_lib_duo,ls_mensaje) = -1 THEN
//		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de generar el consecutivo de duos y conjuntos, ERROR: '+ls_mensaje,StopSign!)
//		Return
//	END IF
//END IF

ls_po 		  = dw_detalle.GetItemString(1,'po')
ll_ordenpd_pt = dw_detalle.GetItemNumber(1,'cs_ordenpd_pt')
ll_color 	  = dw_detalle.GetItemNumber(1,'co_color')
ldc_ancho     = dw_detalle.getItemNumber(1,'ancho')
ll_tanda 	  = dw_detalle.GetItemNumber(1,'cs_tanda')

//si se realizo algun cambio en las unidades a liberar se debe actualizar en las rayas
//diferentes al modelo ppl   jorodrig dic 22-09
IF ii_act_unid = 1 THEN
	of_act_datos_raya_dif_ppl(ls_usuario,ll_ordenpd_pt, ls_po, ll_color)
END IF

//mirar si es un duo o conjunto para tomar los datos de ventas y evitar que queden en cero
IF (dw_equivalencias.RowCount() > 0)  THEN
	FOR posi = 1 TO dw_equivalencias.RowCount()
		IF ll_ordenpd_pt = dw_equivalencias.GetItemNumber(posi,'cs_ordenpd_pt') AND ll_color =  dw_equivalencias.GetItemNumber(posi,'co_color') THEN
			is_color_exp  = dw_equivalencias.GetitemString(posi,'color_exp')
			is_ref_exp  = dw_equivalencias.GetitemString(posi,'co_ref_exp')
			ii_linea_exp  = dw_equivalencias.GetitemNumber(posi,'co_linea_exp')
			li_op_agrupada  = dw_equivalencias.GetitemNumber(posi,'agruapadas')
		END IF
	NEXT
END IF

//se va a buscar si la referencia es de criticas o no, esto porque no estan liberando lo de
//criticas por la opcion de criticas y las liberaciones no quedan con la marca correcta
//se comentarea por su soliictud de hector osorno mientras se revisan las unidades del
//archivo make to stock octubre 6 de 2008
//li_critica = luo_cargar_temporales_liberacion.of_referenciacritica(li_fabrica, li_linea, ll_referencia,0,ll_color)
//IF li_critica = 0  THEN
//	ii_tipo_lib = 2
//END IF
//una vez cumplidas estas validaciones debemos descargar los datos a las tablas de la liberacion.
If luo_liberar.of_generar_liberacion(ls_usuario,ll_ordenpd_pt,ls_po,ll_color,ldc_ancho,ll_tanda,ii_tipo_lib,ii_linea_exp, is_ref_exp, is_color_exp,il_cons_lib_duo,ii_fab_exp, il_op_agrupada) = -1 Then
	Rollback;
	Return
Else
	Commit;
	
	//verifica si el ean esta en blanco
	ll_n = lds_ean_sku.Of_Retrieve(ll_ordenpd_pt, ls_po, ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp)
	//si trae datos
	If ll_n > 0 Then
		ls_de_referencia = Trim(lds_ean_sku.GetItemString(1,'de_referencia'))
		ls_mensaje_correo = ''
		//recorre los registros y valida que el ean no esten en blanco
		For ll_n = 1 to lds_ean_sku.RowCount()
			//verifica si el ean esta en blanco
			IF Isnull(lds_ean_sku.GetItemString(ll_n,'barcode')) or Trim(lds_ean_sku.GetItemString(ll_n,'barcode')) = '' &
				 or Trim(lds_ean_sku.GetItemString(ll_n,'barcode')) = '0' Then
				ls_mensaje_correo = ls_mensaje_correo + Trim(lds_ean_sku.GetItemString(ll_n,'co_talla')) + ' ' 
			End if
		Next
		
		//si hay ean en cero se envia correo
		If ls_mensaje_correo <> '' Then
			//completa mensaje para el correo
			ls_mensaje_correo = 'Los siguientes SKU de venta tiene el ean en cero. Por favor Crear URGENTE los eanes. Ref Vta ' + &
										Trim(is_ref_exp) + ' - '+ Trim(ls_de_referencia) + ' Color Vta ' + Trim(is_color_exp) + ' Tallas ' + ls_mensaje_correo
			
			//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 34 es el que pertenece a este proceso en la tabla m_usu_correo
			/*
			Declare pr_envia_correo Procedure For pr_envia_correo('URGENTE EAN EN CERO', &
						:ls_mensaje_correo,34, :ls_usuario);
			Execute pr_envia_correo;
			If SQLCA.SQLCODE = -1 Then
				ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
				RollBack;
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Error enviando correo por ean en cero" + ls_error, StopSign!)
				Close pr_envia_correo;
				Return -1
			End If
			// Cierra el procedimiento almacenado declarado
			Close pr_envia_correo;
			*/
		
			TRY
				lnv_correo.of_enviar_correo('URGENTE EAN EN CERO', ls_mensaje_correo, 'EAN_en_cero', ls_usuario)
			CATCH(Exception ex)
				Messagebox("Error", ex.getmessage())
			END TRY
		End if
		
		ls_mensaje_correo = ''
		//recorre los registros y valida que el precio no esten en blanco
		For ll_n = 1 to lds_ean_sku.RowCount()
			//si es nacional o punto blanco se valida precio
			If lds_ean_sku.GetItemString(ll_n,'tipo_pedido') = 'NA' or &
				trim(lds_ean_sku.GetItemString(ll_n,'co_marca')) = '07' Then
				//toma el precio para validarlo
				ldc_valor = lds_ean_sku.getitemDecimal(ll_n, "pr_etiqueta")
				If Isnull(ldc_valor) Then
					ldc_valor = 0
				End if
				
				// FACL - 2017/06/04 - SA56557 - Se agrega control de excluir precio en categorias especiales
				/*
				// FACL - 2017/08/16 - SA57235 - Se mueve control para pr_generar_ordencr
				If ldc_valor <= 0 And lds_ean_sku.GetItemNumber( ll_n, 'sw_excluye_precio' ) = 0 Then
					ls_categoria_sap  = Trim( lds_ean_sku.GetItemString(ll_n,'categoria_sap') )
					ls_mensaje_correo = ls_mensaje_correo + Trim(lds_ean_sku.GetItemString(ll_n,'co_talla')) + ' ' 
				End if
				*/
				
				// Valida si para el EAN existe un surtido y su correspondiente instruccion de empaque
				of_validar_surtido(ls_po, lds_ean_sku, ll_n, lds_ean_sin_surtido, lds_ean_sin_instruccion_empaque, lds_ean_sin_procesar)
			End if
			
		Next
		
		//si hay ean en cero se envia correo
		If ls_mensaje_correo <> '' Then
			// FACL - 2017/06/16 - SA56987 - Se modifica para llamar un SP que envia correo una sola vez por dia.
			//	Declara y Ejecuta procedimiento almacenado para envio de correo para la validacion de precio
			Declare pr_log_valida_precio Procedure For pr_log_valida_precio(
					:ii_fab_exp, :ii_linea_exp, :is_ref_exp, :is_color_exp, :ls_categoria_sap, 
					:ls_de_referencia, :ls_mensaje_correo );
			Execute pr_log_valida_precio;
			If SQLCA.SQLCODE = -1 Then
				ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
				RollBack;
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Error enviando correo por precio en cero" + ls_error, StopSign!)
				Close pr_log_valida_precio;
				Return -1
			End If
			// Cierra el procedimiento almacenado declarado
			Close pr_log_valida_precio;
			
			/*
			//completa mensaje para el correo
			ls_mensaje_correo = 'Los siguientes Materiales tienen el precio en CERO y ya est$$HEX1$$e100$$ENDHEX$$n en CORTE MARINILLA. Por favor verificar el precio. Ref Vta ' + &
										Trim(is_ref_exp) + ' - '+ Trim(ls_de_referencia) + ' Color Vta ' + Trim(is_color_exp) + ' Tallas ' + ls_mensaje_correo
			
			//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 42 es el que pertenece a este proceso en la tabla m_usu_correo
			Declare pr_envia_correo1 Procedure For pr_envia_correo('PRECIO EN CERO', &
						:ls_mensaje_correo,:ll_correo_precio_cero, :ls_usuario);
			Execute pr_envia_correo1;
			If SQLCA.SQLCODE = -1 Then
				ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
				RollBack;
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Error enviando correo por precio en cero" + ls_error, StopSign!)
				Close pr_envia_correo1;
				Return -1
			End If
			// Cierra el procedimiento almacenado declarado
			Close pr_envia_correo1;
			*/
		End if
		
		ls_mensaje_correo = ''
		
		// Si se encontraron eanes sin surtidos enviados desde SAP. SA 56481 JCMR 20-06-2017
		If lds_ean_sin_surtido.RowCount() > 0 Then
			ls_mensaje_correo = "La(s) siguiente referencia o ean, aun no tiene(n) un surtido enviado desde SAP:~r~n" &
									+ "Co_Referencia~tCo_Color~tCo_Talla~tEan~t~t~r~n"
			For ll_n = 1 To lds_ean_sin_surtido.RowCount()
				ls_mensaje_correo = ls_mensaje_correo + Trim(lds_ean_sin_surtido.GetItemString(ll_n, 'co_referencia')) + "~t" &
										+ Trim(lds_ean_sin_surtido.GetItemString(ll_n, 'co_color')) + "~t" &
										+ Trim(lds_ean_sin_surtido.GetItemString(ll_n, 'co_talla')) + "~t" &
										+ Trim(lds_ean_sin_surtido.GetItemString(ll_n, 'barcode')) + "~r~n" 
			Next
		End If
		
		// Si se encontraron eanes sin instruccion de empaque enviados desde SAP. SA 56481 JCMR 20-06-2017
		If lds_ean_sin_instruccion_empaque.RowCount() > 0 Then
			ls_mensaje_correo = ls_mensaje_correo + "~r~n~r~n"
			ls_mensaje_correo = ls_mensaje_correo + "La(s) siguiente referencia o ean, aun no tiene(n) una instruccion de empaque enviada desde SAP:~r~n" &
									+ "Co_Referencia~tCo_Color~tCo_Talla~tEan~t~t~r~n"
			For ll_n = 1 To lds_ean_sin_instruccion_empaque.RowCount()
				ls_mensaje_correo = ls_mensaje_correo + Trim(lds_ean_sin_instruccion_empaque.GetItemString(ll_n, 'co_referencia')) + "~t" &
										+ Trim(lds_ean_sin_instruccion_empaque.GetItemString(ll_n, 'co_color')) + "~t" &
										+ Trim(lds_ean_sin_instruccion_empaque.GetItemString(ll_n, 'co_talla')) + "~t" &
										+ Trim(lds_ean_sin_instruccion_empaque.GetItemString(ll_n, 'barcode')) + "~r~n" 
			Next			
		End If
		
		// Si se encontraron eanes con instruccion de empaque procesada con error. SA 56481 JCMR 20-06-2017
		If lds_ean_sin_procesar.RowCount() > 0 Then
			ls_mensaje_correo = ls_mensaje_correo + "~r~n~r~n"
			ls_mensaje_correo = ls_mensaje_correo + "La(s) siguiente referencia o ean, tiene(n) una instruccion de empaque procesada con error:~r~n" &
									+ "-2: No se ha creado la PO de SAP en KPO.	-3: Hay inconsistencia en los pedidos de KPO para la PO de SAP~r~n" &
									+ "Co_Referencia~tCo_Color~tCo_Talla~tEan~t~tError~r~n"
			For ll_n = 1 To lds_ean_sin_procesar.RowCount()
				ls_mensaje_correo = ls_mensaje_correo + Trim(lds_ean_sin_procesar.GetItemString(ll_n, 'co_referencia')) + "~t" &
										+ Trim(lds_ean_sin_procesar.GetItemString(ll_n, 'co_color')) + "~t" &
										+ Trim(lds_ean_sin_procesar.GetItemString(ll_n, 'co_talla')) + "~t" &
										+ Trim(lds_ean_sin_procesar.GetItemString(ll_n, 'barcode')) + "~t~t" &
										+ Trim(lds_ean_sin_procesar.GetItemString(ll_n, 'tipo_pedido'))
			Next									
		End If
		
		// Si se encontro algun mensaje por enviar. SA 56481 JCMR 20-06-2017
		If ls_mensaje_correo <> '' Then
			//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 43 es el que pertenece a este proceso en la tabla m_usu_correo
			/*
			Declare pr_envia_correo_surtido Procedure For pr_envia_correo('Validacion Surtidos', :ls_mensaje_correo, 43);
			Execute pr_envia_correo_surtido;
			If SQLCA.SQLCODE = -1 Then
				ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
				RollBack;
				MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n", "Error enviando correo por precio en cero" + ls_error, StopSign!)
				Close pr_envia_correo_surtido;
				Return -1
			End If
			// Cierra el procedimiento almacenado declarado
			Close pr_envia_correo_surtido;	
			*/
		
			TRY
				lnv_correo.of_enviar_correo('Validacion Surtidos', ls_mensaje_correo,'validacion_surtidos')
			CATCH(Exception ex_val)
				Messagebox("Error", ex_val.getmessage())
			END TRY
		End If
		
		// Se destruye los ds utilizados durante el proceso
		Destroy lds_ean_sin_surtido
		Destroy lds_ean_sin_instruccion_empaque
		Destroy lds_ean_sin_procesar
	
	ElseIf ll_n = 0 Then
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se encontraron datos para validar ean para la referencia-color de venta. Orden ' + & 
							String(ll_ordenpd_pt) + ' Ref Vta' + Trim(is_ref_exp) + ' Color Vta ' + Trim(is_color_exp) )
	Else
		MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Ocurrio un inconveniente al consultar los eanes para la referencia-color de venta')
	End if
	
End if

DESTROY lnv_correo
//se resetean los datos en pantalla
dw_maestro.Reset()
dw_detalle.Reset()
dw_colores.Reset()
//dw_maestro.Retrieve(ls_usuario)
//dw_detalle.Retrieve(ls_usuario, ll_ordenpd_pt,ll_color,ls_po, ldc_ancho,ll_tanda)

il_liberacion_duo = luo_liberar.il_liberacion


dw_equivalencias.Retrieve(ii_unir_op,is_color_exp,il_op_agrupada,ii_cs_agrupa_lib)
	
FOR posi = 1 TO dw_equivalencias.RowCount()
	IF ll_ordenpd_pt = dw_equivalencias.GetItemNumber(posi,'cs_ordenpd_pt') AND ll_color =  dw_equivalencias.GetItemNumber(posi,'co_color') THEN
		dw_equivalencias.SetItem(posi,'liberada',1)
	END IF
NEXT
dw_equivalencias.Accepttext()
end event

type st_1 from statictext within w_existencias_tela_critica
integer x = 69
integer y = 1200
integer width = 2770
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Doble click sobre los kilos muestra los rollos y permite descartarlos    -  Click derecho sobre el Estilo muestra la ficha del Estilo"
boolean focusrectangle = false
end type

type dw_detalle from datawindow within w_existencias_tela_critica
integer x = 1202
integer y = 1532
integer width = 2126
integer height = 884
string title = "none"
string dataobject = "dtb_detalla_liberacion_x_proyeccion"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;choose case dwo.name
	case 'proporcion'
		cb_liberar.Enabled = False
	ii_act_unid = 1
	
		
end choose



end event

event itemchanged;Long ll_unid_lib


choose case GetColumnName()
	case 'unid_real_liberar'
		ll_unid_lib = This.getItemNumber(Row,'unid_real_liberar')
		
		IF Long(data) > ll_unid_lib Then
			MessageBox('Error','Las unidades a modificar no puede ser mayores.',StopSign!)
			This.SetItem(Row,'unid_real_liberar',ll_unid_lib)
			Return 2
			
		END IF
		ii_act_unid = 1
end choose

end event

event retrieveend;//funcion para igualar las proporciones de liberaciones de duos o conjuntos
//jcrm
//septiembre 9 de 2008
Long li_fila, li_talla, li_proporcion
n_cts_liberacion_x_proyeccion luo_liberar

SetPointer(HourGlass!)

IF il_cons_lib_duo > 0 THEN
	//se trata de un duo o conjunto, se deben recorrer las tallas de la liberacion actual
	//y buscar si hay mas liberaciones del mismo consecutivo de unir liberaciones, y traer el
	//distinct de la proporcion para la talla que se tiene en el momento.
	
	FOR li_fila = 1 TO This.RowCount()
		//traemos la talla actual
		li_talla = This.GetItemNumber(li_fila,'co_talla')
		
		//se debe traer la proporcion de dicha talla
		li_proporcion = luo_liberar.of_proporcion_duo(il_cons_lib_duo,li_talla)
		
		IF li_proporcion <> 0 THEN
			This.SetItem(li_fila,'proporcion',li_proporcion)
		ELSE
			Return
		END IF
	NEXT
	
	
	This.AcceptText()
	//cb_calc_propor.TriggerEvent("clicked")
	
END IF

end event

type dw_colores from datawindow within w_existencias_tela_critica
integer x = 41
integer y = 1540
integer width = 1157
integer height = 428
integer taborder = 170
string title = "none"
string dataobject = "dtb_colores_liberacion_semiautomatica"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;String ls_usuario, ls_po
Long ll_ordenpd_pt, ll_tanda, ll_referencia, ll_reftel, ll_color
Decimal{2} ldc_ancho
Long li_fabrica, li_linea
n_cts_cargar_temporales_liberacion luo_liberacion

This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)

If row > 0 Then
	ls_usuario 	  = gstr_info_usuario.codigo_usuario
	ll_color      = This.GetItemNumber(row,'co_color')
	ls_po			  = This.GetItemString(row,'po')	
	ldc_ancho     = This.GetItemNumber(row,'ancho')
	ll_tanda	     = This.GetItemNumber(row,'cs_tanda')
	ll_reftel     = This.GetItemNumber(row,'co_reftel')
	
	IF luo_liberacion.of_recalcularunidadesmin(il_ordenpd_pt,ll_color,ls_po,ldc_ancho,ll_tanda,ll_reftel, ii_tipo_lib,is_color_exp,il_op_agrupada) = -1 THEN
		Return
	END IF
	
	
	dw_detalle.Retrieve(ls_usuario, il_ordenpd_pt, ll_color, ls_po, ldc_ancho, ll_tanda)
End if

end event

type dw_maestro from datawindow within w_existencias_tela_critica
integer x = 41
integer y = 1300
integer width = 3232
integer height = 232
integer taborder = 130
string title = "none"
string dataobject = "dtb_maestro_liberacion_semiautomatica"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_existencias_tela_critica
boolean visible = false
integer x = 3922
integer y = 12
integer width = 69
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Libera"
end type

event clicked;LONG		ll_unid_color, ll_ref, ll_col
Long	ll_result, li_talla
STRING	ls_usuario, ls_mensaje, ls_po
INTEGER	li_fab, li_linea, posi, li_agru
DECIMAL{2}	ld_porc_aplicar
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion
n_cts_cargar_temporales_liberacion luo_temporal
s_base_parametros lstr_parametros, lstr_parametros_retro

ls_usuario = Trim(gstr_info_usuario.codigo_usuario)
IF sle_talla.text  <> ''  THEN
	sle_talla.TriggerEvent(Modified!)
	ii_talla = Long(sle_talla.text)
ELSE
END IF


IF dw_lista.RowCount() = 0 THEN
	Return
END IF

dw_maestro.Reset()
dw_colores.Reset()
dw_detalle.Reset()

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  rollo a liberar 1/6 "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     


IF il_op_agrupada > 0 THEN
	li_agru = 1
END IF

//traer el porcentaje a aplicar a la cantidad de tela cuando es una agrupada
FOR posi =1 TO dw_equivalencias.RowCount()
	li_fab = dw_equivalencias.GetItemNumber(posi,'co_fabrica')
	li_linea = dw_equivalencias.GetItemNumber(posi,'co_linea')
	ll_ref = dw_equivalencias.GetItemNumber(posi,'co_referencia')
	ll_col =  dw_equivalencias.GetItemNumber(posi,'co_color')
	IF li_fab = ii_fab and li_linea = ii_lin and ll_ref = il_referencia and ll_col = il_color_pt THEN //obtenemos el porcentaje a aplicar a la tela
		ld_porc_aplicar = dw_equivalencias.GetItemNumber(posi,'porc_falta')
		EXIT
	END IF
NEXT


//se eliminan los datos de las temporales
If luo_temporal.of_borrarTemporales(ls_usuario) = -1 Then
	Rollback;
	CLOSE(w_retroalimentacion)
	Return
End if

//se validad que los datos seleccionados si puedan ser utilizados en la liberacion
//jcrm
//febrero 25 de 2008
If of_validardatos() = -1 Then
	Rollback;
	CLOSE(w_retroalimentacion)
	Return
End if

luo_liberacion_x_proyeccion.ib_tanda = ib_tanda
//se debe verificar si la liberacion es por make to stock ii_tipo_lib = 2
//o se trata de una liberacion make to order ii_tipo_lib = 1
//esto es con el fin de unificar en una misma ventana ambas liberaciones.
//jcrm
//junio 11 de 2008

IF ii_tipo_lib = 2 THEN //liberacion make to stock
	
	//********************************************
	//jcrm
	//febrero 18 de 2008
	//primero se resetean las marcar de los rollos
	IF luo_liberacion_x_proyeccion.of_resetiarmarca(ls_mensaje) = -1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','No fue posible inicializar los rollos, ERROR, '+ls_mensaje,StopSign!)
		Return
	END IF
	//evento para marcar los rollos seleccionados
	ll_result = of_actualizartemprefliberar()
	IF ll_result = 0 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','No encontr$$HEX2$$f3002000$$ENDHEX$$tela para realizar liberacion')
		Return
	ELSEIF ll_result = 1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		//MessageBox('Advertencia','Se presentaron problemas cargando la tela a liberar')
		Return
	END IF
	//Cargamos el total de unidades por estilo-color
	ll_unid_color = dw_lista.GetitemNumber(dw_lista.GetRow(),'tot_unid_liberar')
	
	//Buscamos la ultima orden de produccion activa para el estilo y utilizamos esta
	//en todos los proceso
	IF ii_talla = 9999  THEN   //no es bodysise, se hace join con la tabla de criticas para que tome todas las tallas
		il_ordenpd_pt = luo_liberacion_x_proyeccion.of_buscar_op_estilo(ii_fab, ii_lin, il_referencia, il_color_pt, 9999, ii_ano, ii_semana, 1,ii_opcion_liberar)
		IF il_ordenpd_pt > 0 THEN
		ELSE
			rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$una orden de produccion activa con el estilo-color-talla creado y con unidades pendientes, Proceda primero a crear la OP de Estilo')
			Return
		END IF
	ELSE
		//es un bodysize, se busca la op con la talla que se esta programando.
		il_ordenpd_pt = luo_liberacion_x_proyeccion.of_buscar_op_estilo(ii_fab, ii_lin, il_referencia, il_color_pt, ii_talla, ii_ano, ii_semana, 1,ii_opcion_liberar)
		IF il_ordenpd_pt > 0 THEN
		ELSE
			Rollback;
			CLOSE(w_retroalimentacion)
			MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$una orden de produccion activa con el estilo-color-talla creado y con unidades pendientes, Proceda primero a crear la OP de Estilo')
			Return
		END IF
	END IF
	
	//traer la po que tiene asociada la orden de produccion
	SELECT MAX(nu_orden)
	  INTO :ls_po
	  FROM dt_caxpedidos 
	 WHERE cs_ordenpd_pt = :il_ordenpd_pt
		AND co_color = :il_color_pt
		AND ca_liberadas < ca_programada;
	
	
	//Cargamos la tabla temporal de rollos a liberar
	IF luo_liberacion_x_proyeccion.of_cargar_rollos_tablas_liberacion(ls_usuario, ii_fab, ii_lin, il_referencia, il_color_pt, il_ordenpd_pt, ii_talla, ld_porc_aplicar) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	////Vamos a mostrar la lista de rollos que se va a utilizar para que el usuario pueda
	////decidir si continua o descarta algun rollo
	//lstr_parametros.cadena[1] = ls_usuario
	//OpenWithParm(w_seleccion_rollos,lstr_parametros)
	//		
	//lstr_parametros = Message.PowerObjectParm	
	//		
	//If lstr_parametros.hay_parametros = True Then
	//Else	
	//	Rollback;
	//	CLOSE(w_retroalimentacion)
	//	Return
	//End if
	
	CLOSE(w_retroalimentacion)
	//para mostrar ventana de espera  
	lstr_parametros_retro.cadena[1]="Procesando ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  Estilo-Color-Talla a liberar 2/6 "
	lstr_parametros_retro.cadena[3]="reloj"
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     
	
	//Cargamos la tabla temporal de estilos a liberar
	IF luo_liberacion_x_proyeccion.of_cargar_ref_tablas_liberacion(ii_ano, ii_semana, ii_fab, ii_lin, il_referencia, il_color_pt, ll_unid_color, il_ordenpd_pt, ls_po, ii_talla, ls_usuario, ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp,0,li_agru) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	IF luo_liberacion_x_proyeccion.of_cargar_unid_liberar() <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
		
	dw_colores_op.Retrieve(il_ordenpd_pt)
	
ELSEIF ii_tipo_lib = 1 THEN //liberacion make to order
	//evento para marcar los rollos seleccionados
	ll_result = of_actualizartemprefliberar()
	IF ll_result = 0 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		MessageBox('Advertencia','No encontr$$HEX2$$f3002000$$ENDHEX$$tela para realizar liberacion')
		Return
	ELSEIF ll_result = 1 THEN
		Rollback;
		CLOSE(w_retroalimentacion)
		//MessageBox('Advertencia','Se presentaron problemas cargando la tela a liberar')
		Return
	END IF
	
	//Cargamos el total de unidades por estilo-color
	ll_unid_color = dw_lista.GetitemNumber(dw_lista.GetRow(),'tot_unid_liberar')
	
	//traer la po que tiene asociada la orden de produccion
	SELECT MAX(nu_orden)
	  INTO :ls_po
	  FROM dt_caxpedidos 
	 WHERE cs_ordenpd_pt = :il_ordenpd_pt
		AND co_color = :il_color_pt
		AND ca_liberadas < ca_programada;
	
	
	//Cargamos la tabla temporal de rollos a liberar
	IF luo_liberacion_x_proyeccion.of_cargar_rollos_tablas_liberacion(ls_usuario, ii_fab, ii_lin, il_referencia, il_color_pt, il_ordenpd_pt, ii_talla, ld_porc_aplicar) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	CLOSE(w_retroalimentacion)
	//para mostrar ventana de espera  
	lstr_parametros_retro.cadena[1]="Procesando ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  Estilo-Color-Talla a liberar 2/6 "
	lstr_parametros_retro.cadena[3]="reloj"
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     
	
	//Cargamos la tabla temporal de estilos a liberar
	IF luo_liberacion_x_proyeccion.of_cargar_ref_tablas_liberacion(0, 0, ii_fab, ii_lin, il_referencia, il_color_pt, ll_unid_color, il_ordenpd_pt, ls_po, ii_talla, ls_usuario, ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp,0,li_agru) <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
	
	IF luo_liberacion_x_proyeccion.of_cargar_unid_liberar() <> 1 THEN
		CLOSE(w_retroalimentacion)
		Return
	END IF
END IF
//se cargan los datos en pantalla
ll_result = dw_maestro.Retrieve(ls_usuario)
	If ll_result > 0 Then
		dw_colores.Retrieve(ls_usuario, il_ordenpd_pt)
	END IF
	CLOSE(w_retroalimentacion)
	
end event

type cb_cerrar from commandbutton within w_existencias_tela_critica
integer x = 3653
integer y = 20
integer width = 233
integer height = 84
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;//si el usuario intenta salirse sin haber liberados todas las referencias de un 
//duo o conjunto se debe informar al usuario que estas seran eliminadas del sistema
//jcrm - jorodrig
//agosto 26 de 2008
Long li_respuesta
n_cts_liberacion_x_proyeccion luo_liberacion



IF il_cons_lib_duo > 0 THEN
	li_respuesta = MessageBox("Advertencia",'Si aun no ha aceptado la liberaci$$HEX1$$f300$$ENDHEX$$n de todas las O.P. ~n que forman el Duo o Conjunto, perdera la informaci$$HEX1$$f300$$ENDHEX$$n de estas, esta seguro de salirse',Exclamation!, YesNo!, 2 )
	//se anulan las liberaciones que pertenecen al duo o conjunto
	IF li_respuesta = 1 THEN
		IF luo_liberacion.of_anular_liberacion_duo_conjunto(il_cons_lib_duo) = -1 THEN
				Rollback;
				Return
		ELSE
			Commit;
		END IF
	ELSE
		Return
	END IF
END IF


Close(Parent)
end event

type dw_lista from datawindow within w_existencias_tela_critica
integer x = 41
integer y = 496
integer width = 3771
integer height = 688
integer taborder = 10
string title = "none"
string dataobject = "dtb_existencias_tela_critica"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;







////eventom para validar que los tono seleccionados sean validos
////jcrm
////febrero 14 de 2008
//Long li_marca, li_fila, li_marca_fila
//Long ll_reftel, ll_reftel_fila, ll_color, ll_color_fila
//String ls_tono, ls_tono_fila
//Decimal{2} ldc_kilos
//
//choose case GetColumnName()
//	case 'sw_op_estilo', 'sw_stock', 'sw_otro_estilo'
//		li_marca = Long(Data)
//		If li_marca = 1 Then
//			//se seleccionaron kilos para una liberacion se va a realizar la validacion inicial
//			//que la fila si tenga tono (A,B $$HEX2$$f3002000$$ENDHEX$$C)
//			ls_tono = This.GetItemString(Row,'tono')
//			If ls_tono <> 'A' AND ls_tono <> 'B' AND ls_tono <> 'C' OR IsNull(ls_tono) Then
//				MessageBox('Advertencia','Debe seleccionar kilos con tono asignado y valido.',StopSign!)
//				Return 2
//			End if
//			//se verifica que los kilos sean validos, mayores a cero
//			If GetColumnName() = 'sw_op_estilo' Then
//				ldc_kilos = This.GetItemNumber(Row,'kg_estilo_op_1')
//			End if	
//			If GetColumnName() = 'sw_stock' Then
//				ldc_kilos = This.GetItemNumber(Row,'kg_estilo_op_2')
//			End if	
//			If GetColumnName() = 'sw_otro_estilo' Then
//				ldc_kilos = This.GetItemNumber(Row,'kg_estilo_op_3')
//			End if	
//			If IsNull(ldc_kilos) OR ldc_kilos = 0 Then
//				MessageBox('Advertencia','Los kilos selecionados no son validos.',StopSign!)
//				Return 2
//			End if
//			ll_reftel = This.GetItemNumber(Row,'co_reftel')
//			ll_color  = This.GetItemNumber(Row,'co_color_te')
//			//que una tela no tenga mas de un tono
//			For li_fila = 1 To This.RowCount()
//				ll_reftel_fila = This.GetItemNumber(li_fila,'co_reftel')
//				If ll_reftel = ll_reftel_fila AND li_fila <> Row Then
//					li_marca_fila = This.GetItemNumber(li_fila,'sw_op_estilo')
//					If li_marca_fila = 0 Then
//						li_marca_fila = This.GetItemNumber(li_fila,'sw_stock')
//						If li_marca_fila = 0 Then
//							li_marca_fila = This.GetItemNumber(li_fila,'sw_otro_estilo')
//						End if
//					End if
//					ls_tono_fila = This.GetItemString(li_fila,'tono')
//					ll_color_fila = This.GetItemNumber(li_fila,'co_color_te')
//					If ls_tono <> ls_tono_fila AND li_marca_fila = 1 AND ll_color = ll_color_fila Then
//						MessageBox('Advertencia','Para una misma tela solo puede seleccionar un tono.',StopSign!)
//						Return 2
//					End if
//				End if
//			Next
//		End if
//end choose
//
end event

event doubleclicked;String ls_tono, ls_usuario
Long li_fab, li_lin, li_caract, li_diametro, li_tipo
Long ll_reftel, ll_color_te
String ls_password, ls_password_ingresado
n_cts_constantes_corte lpo_const_corte

s_base_parametros  lstr_param



s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = This.GetItemString(Row,'tono')
lstr_parametros.cadena[3] = TRIM(This.GetItemString(Row,'co_estampado'))
lstr_parametros.entero[1] = This.GetItemNumber(Row,'co_fabrica')
lstr_parametros.entero[2] = This.GetItemNumber(Row,'co_linea')
lstr_parametros.entero[3] = This.GetItemNumber(Row,'co_reftel')
lstr_parametros.entero[4] = This.GetItemNumber(Row,'co_caract')
lstr_parametros.entero[5] = This.GetItemNumber(Row,'diametro')
lstr_parametros.entero[6] = This.GetItemNumber(Row,'co_color_te')
lstr_parametros.entero[9] = This.GetItemNumber(Row,'co_referencia')
lstr_parametros.entero[8] = This.GetItemNumber(Row,'co_color_pt')

lstr_parametros.cadena[2] = gstr_info_usuario.codigo_usuario

If IsNull(lstr_parametros.cadena[1]) Then lstr_parametros.cadena[1] = ''

choose case dwo.name
	case 'kg_estilo_op_1'
		lstr_parametros.entero[7] = 1
		OpenWithParm ( w_rollos_liberacion_critica, lstr_parametros )
	case 'kg_estilo_op_2'
		lstr_parametros.entero[7] = 2
		lstr_parametros.cadena[1] = ''
		IF lstr_parametros.cadena[3] = '' THEN
			lstr_parametros.cadena[3] = '0'
		END IF
		OpenWithParm ( w_rollos_liberacion_critica, lstr_parametros )
	case 'kg_estilo_op_3'	

//		ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD TOMAR TELA OTRA OP'))
//		Open(w_password_trazos)
//		lstr_param = message.PowerObjectParm
//
//		If lstr_param.hay_parametros = true Then
//			ls_password_ingresado = Trim(lstr_param.cadena[1])
//			
//			If ls_password_ingresado = ls_password Then
//				// clave correcta				
//			Else
//				MessageBox('Error','Password, no valido.')
//				Return -1
//			End if
//		Else
//			Return -1
//		End if
//

		lstr_parametros.entero[7] = 3
		OpenWithParm ( w_rollos_liberacion_critica, lstr_parametros )
	case 'kg_proc1'	
		lstr_parametros.entero[7] = This.GetItemNumber(Row,'co_referencia')
		lstr_parametros.entero[8] = This.GetItemNumber(Row,'co_color_pt')
		OpenWithParm ( w_existencia_en_proceso_critica, lstr_parametros )

		
end choose

end event

event rbuttondown;Long	ll_fila, li_fabrica, li_linea
LONG		ll_referencia
s_base_parametros lstr_parametros

ll_fila = This.GetRow()

IF ll_fila > 0 THEN
	li_fabrica 	= This.GetItemNumber(ll_fila,'co_fabrica')
	li_linea		= This.GetItemNumber(ll_fila,'co_linea')
	ll_referencia = This.GetItemNumber(ll_fila,'co_referencia')
	
	lstr_parametros.entero[1] = li_fabrica
	lstr_parametros.entero[2] = li_linea
	lstr_parametros.entero[3] = ll_referencia
	
	OpenWithParm ( w_consultar_ficha_prenda, lstr_parametros )
	
END IF
end event

event buttonclicked;s_base_parametros lstr_param

Choose Case Dwo.Name
	Case "b_unidades_liberar"




End Choose
end event

event itemfocuschanged;Long li_fila, li_fab, li_linea
Long ll_reftel, ll_ref, ll_color_pt, ll_color_te


li_fila = dw_lista.GetRow()

IF li_fila > 0 THEN
	li_fab = dw_lista.GetItemnumber(li_fila,'co_fabrica')
	li_linea = dw_lista.GetItemnumber(li_fila,'co_linea')
	ll_reftel = dw_lista.GetItemnumber(li_fila,'co_reftel')
	ll_ref = dw_lista.GetItemnumber(li_fila,'co_referencia')
	ll_color_pt = dw_lista.GetItemnumber(li_fila,'co_color_pt')
	ll_color_te = dw_lista.GetItemnumber(li_fila,'co_color_te')
ELSE
	MessageBox('Error','Fila seleccionada no valida.',StopSign!)
	Return
END IF

dw_partes.Retrieve(ll_reftel, li_fab, li_linea, ll_ref, ll_color_pt, ll_color_te)


end event

event clicked;
String ls_password, ls_password_ingresado
n_cts_constantes_corte lpo_const_corte

s_base_parametros  lstr_param

choose case dwo.name
	
	case 'sw_otro_estilo'	

		ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD TOMAR TELA OTRA OP'))
		Open(w_password_trazos)
		lstr_param = message.PowerObjectParm

		If lstr_param.hay_parametros = true Then
			ls_password_ingresado = Trim(lstr_param.cadena[1])
			
			If ls_password_ingresado = ls_password Then
				// clave correcta				
			Else
				MessageBox('Error','Password, no valido.')
				Return -1
			End if
		Else
			Return -1
		End if
		
end choose

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	IF dw_lista.IsSelected(row) THEN
		this.selectrow(row, False)
	ELSE
		this.selectrow(row, True)		
	END IF
END IF

end event

type gb_1 from groupbox within w_existencias_tela_critica
integer x = 27
integer y = 452
integer width = 3726
integer height = 752
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_existencias_tela_critica
integer x = 27
integer y = 1252
integer width = 3328
integer height = 1180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos Liberaci$$HEX1$$f300$$ENDHEX$$n "
end type

type gb_3 from groupbox within w_existencias_tela_critica
integer x = 4014
integer y = 104
integer width = 462
integer height = 1100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_existencias_tela_critica
integer x = 3369
integer y = 1252
integer width = 1166
integer height = 468
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_5 from groupbox within w_existencias_tela_critica
integer x = 3369
integer y = 1700
integer width = 1362
integer height = 724
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_6 from groupbox within w_existencias_tela_critica
boolean visible = false
integer x = 55
integer y = 108
integer width = 3945
integer height = 352
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Referencias Equivalentes y Agrupadas (fondo azul)   Clic derecho sobre el campo Nro Lib  para detalle de lib x talla y op."
end type

type dw_equivalencias from datawindow within w_existencias_tela_critica
boolean visible = false
integer x = 46
integer y = 156
integer width = 3950
integer height = 292
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dgr_ref_equivalentes_make_to_order"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;Long	li_ca_pendiente
Integer	li_selec

This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)


end event

event doubleclicked;Long	li_fab, li_lin, li_bodysize, li_talla_pt, li_linea_exp, li_fabrica_exp,li_fila
LONG		ll_ref, ll_ordenpd_pt, ll_color_pt
Integer	li_tipo_libe
STRING	usuario, ls_ref_exp,ls_color_exp
BOOLEAN  lb_result
s_base_parametros lstr_parametros, lstr_parametros_retro
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion


dw_maestro.Reset()
dw_colores.Reset()
dw_detalle.Reset()
dw_partes.Reset()

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  datos segun Ficha y Existencia en bodega "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

usuario = gstr_info_usuario.codigo_usuario

FOR li_fila = 1 To dw_equivalencias.RowCount()
	lb_result = dw_equivalencias.IsSelected(li_fila)
	IF lb_result THEN
		li_fab = dw_equivalencias.GetItemNumber(li_fila,'co_fabrica')
		li_lin = dw_equivalencias.GetItemNumber(li_fila,'co_linea')
		ll_ref = dw_equivalencias.GetItemNumber(li_fila,'co_referencia')
		ll_color_pt = dw_equivalencias.GetItemNumber(li_fila,'co_color')
		ll_ordenpd_pt = dw_equivalencias.GetItemNumber(li_fila,'cs_ordenpd_pt')
		il_ordenpd_pt = ll_ordenpd_pt
		ls_color_exp = dw_equivalencias.GetItemString(li_fila,'color_exp')
		li_tipo_libe =  dw_equivalencias.GetItemNumber(li_fila,'tipo_agrupacion')
		
		IF li_tipo_libe = 1 THEN
			MessageBox('Advertencia','Esta referencia solo debe llegar agrupada hasta la liberacion, liberela individual')
			CLOSE(w_retroalimentacion)
			Return
		END IF
		
		//modifico las variables de instancia para permitir la liberacion de la nueva referencia en pantalla
		//jcrm - jorodrig
		//septiembre 2 de 2008
		ii_fab 			= li_fab
		ii_lin 			= li_lin
		il_referencia 	= ll_ref
		il_color_pt 	= ll_color_pt
	END IF
NEXT

li_bodysize = luo_liberacion_x_proyeccion.of_revisar_si_bodysize(li_fab, li_lin, ll_ref, ll_color_pt)

IF luo_liberacion_x_proyeccion.of_cargar_temp_ref_liberar(usuario, li_fab, li_lin, ll_ref, ll_color_pt, ii_talla, li_bodysize, ii_ano, ii_semana,ll_ordenpd_pt,ii_fab_exp, ii_linea_exp, is_ref_exp, is_color_exp,ii_opcion_liberar, il_op_agrupada,ii_cs_agrupa_lib) = -1 THEN
	CLOSE(w_retroalimentacion)
	Return
END IF

dw_lista.Retrieve(gstr_info_usuario.codigo_usuario,il_op_agrupada,il_op_agrupada)
IF ii_tipo_lib = 1 THEN
	dw_unid_x_liberar.Retrieve(il_ordenpd_pt,ll_color_pt,ls_color_exp,gstr_info_usuario.codigo_usuario)
	dw_colores_op.Retrieve(il_ordenpd_pt)
ELSE
	dw_unid_x_liberar.Retrieve(ii_ano,ii_semana,li_fab,li_lin,ll_ref,ll_color_pt,ii_linea_exp,is_ref_exp,is_color_exp,ii_opcion_liberar)
END IF

CLOSE(w_retroalimentacion)


end event

event itemchanged;INT li_selec
LONG	li_ca_pendiente

choose case dwo.name
	
	case 'selec'	
		li_selec = LONG(data)
		IF li_selec = 1 THEN
			li_ca_pendiente = This.GetitemNumber(row,'compute_2')
			IF li_ca_pendiente <=0 THEN
				MessageBox('Advertencia','La OP seleccionada ya liber$$HEX2$$f3002000$$ENDHEX$$el total de unidades programadas.')
			END IF
		END IF
			
end choose

end event

event rbuttondown;

s_base_parametros lstr_parametros



lstr_parametros.entero[1] = This.GetItemNumber(Row,'nro_lib')



choose case dwo.name
	case 'nro_lib'
		lstr_parametros.entero[7] = 1
		OpenWithParm ( w_detalle_lib_agrupada_x_op, lstr_parametros )
		
end choose

end event

