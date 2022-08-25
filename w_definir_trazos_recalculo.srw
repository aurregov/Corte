HA$PBExportHeader$w_definir_trazos_recalculo.srw
forward
global type w_definir_trazos_recalculo from window
end type
type dw_partes from datawindow within w_definir_trazos_recalculo
end type
type dw_trazos_definidos from u_dw_base within w_definir_trazos_recalculo
end type
type dw_oc from u_dw_base within w_definir_trazos_recalculo
end type
type dw_pdn_talla from u_dw_base within w_definir_trazos_recalculo
end type
type dw_produccion from u_dw_base within w_definir_trazos_recalculo
end type
type dw_trazo from u_dw_base within w_definir_trazos_recalculo
end type
end forward

global type w_definir_trazos_recalculo from window
integer width = 3662
integer height = 2608
boolean titlebar = true
string title = "Secciones por Trazos"
string menuname = "m_seleccion_trazos"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_buscar ( )
event ue_seleccionar_trazos ( )
event ue_gra ( )
event ue_borrar_trazos ( )
event ue_grabar ( )
event ue_recalcular ( )
event ue_recalcular_unidades ( )
dw_partes dw_partes
dw_trazos_definidos dw_trazos_definidos
dw_oc dw_oc
dw_pdn_talla dw_pdn_talla
dw_produccion dw_produccion
dw_trazo dw_trazo
end type
global w_definir_trazos_recalculo w_definir_trazos_recalculo

type variables

Long il_orden,il_agrupa,il_numtalla,il_numpdn,il_liberacion,il_ordenpd, il_color
Boolean ib_tzbs = False
Long ii_fabrica, ii_planta, ii_simulacion, ii_aprobado, ii_pdn, ii_tipo,ii_fabexp
String is_po
end variables

forward prototypes
public subroutine of_consumos (long an_agrupacion, long an_basetrazo, long an_espacio, long an_seccion)
public function long of_buscar ()
public function long of_cuadro (long an_fila)
public function long of_agrupacion (long an_orden, ref long ai_estado_agrupa)
public function long of_calcular_aprogramar ()
public function long of_valida_po_raya ()
public function long of_validar_trazo (long al_trazo)
protected subroutine of_cargar_trazos_recalculo (long al_fila)
public function long of_consultar_trazos (long al_agrupa, long ai_base, decimal ad_ancho, decimal ad_anchoini)
public subroutine of_filtrar_trazos (long al_fila)
public function long of_liberacion ()
public function long of_restar_aprogramar (long al_fila, long ai_marca, decimal adc_porc_ficha, decimal adc_porc_trazo)
end prototypes

event ue_buscar();n_cts_param luo_param
Long ll_result
Long li_estado_agrupa

This.Title = "Definir Trazos"

dw_pdn_talla.Reset()
dw_produccion.Reset()
dw_trazo.Reset()
dw_oc.Reset()
dw_trazos_definidos.Reset()
dw_partes.Reset()

Open(w_parametro_corte)
 
luo_param = Message.PowerObjectParm

If luo_param.is_vector[1] <> 'N' Then
	il_orden  = luo_param.il_vector[1]
	il_agrupa = of_agrupacion(il_orden, li_estado_agrupa)

	If il_agrupa = -1 Then Return
	
	If li_estado_agrupa <> 1 Then
		MessageBox("Advertencia...","Estado de agrupaci$$HEX1$$f300$$ENDHEX$$n inconsistente")
		Return
	End If
	Of_Buscar()
End If
end event

event ue_seleccionar_trazos();Long li_filas, li_raya, li_fila_raya, li_seleccion
Long ll_trazo
Decimal{2} ld_ancho, ld_largo, ld_utilizacion
String ls_trazo

FOR li_filas = 1 TO dw_produccion.RowCount()
	IF dw_produccion.IsSelected(li_filas) THEN
		li_fila_raya = dw_trazo.GetRow()
		li_raya = dw_trazo.GetItemNumber(li_fila_raya, "raya")
		ll_trazo = dw_produccion.GetItemNumber(li_filas, "co_trazo")
		ls_trazo = dw_produccion.GetItemString(li_filas, "de_trazo")
		ld_ancho = dw_produccion.GetItemNumber(li_filas, "ancho")
		ld_largo = dw_produccion.GetItemNumber(li_filas, "largo")
		ld_utilizacion = dw_produccion.GetItemNumber(li_filas, "porc_util")
		li_seleccion = dw_trazos_definidos.InsertRow(0)
		IF li_seleccion = -1 THEN
			MessageBox("Error DW","Error al insertar fila de selecci$$HEX1$$f300$$ENDHEX$$n")
			Return
		ELSE
			dw_trazos_definidos.SetItem(li_seleccion, "cs_agrupacion", il_agrupa)
			dw_trazos_definidos.SetItem(li_seleccion, "raya", li_raya)
			dw_trazos_definidos.SetItem(li_seleccion, "co_trazo", ll_trazo)
			dw_trazos_definidos.SetItem(li_seleccion, "de_trazo", ls_trazo)			
			dw_trazos_definidos.SetItem(li_seleccion, "ancho", ld_ancho)
			dw_trazos_definidos.SetItem(li_seleccion, "largo", ld_largo)
			dw_trazos_definidos.SetItem(li_seleccion, "porc_util", ld_utilizacion)
			dw_trazos_definidos.SetItem(li_seleccion, "fe_creacion", f_fecha_servidor())
			dw_trazos_definidos.SetItem(li_seleccion, "fe_actualizacion", f_fecha_servidor())
			dw_trazos_definidos.SetItem(li_seleccion, "usuario", gstr_info_usuario.codigo_usuario)
			dw_trazos_definidos.SetItem(li_seleccion, "instancia", gstr_info_usuario.instancia)
		END IF
	END IF
NEXT

IF dw_trazos_definidos.AcceptText() = 1 THEN
	IF dw_trazos_definidos.Update() = 1 THEN
		COMMIT;
		This.of_cuadro(dw_trazo.GetRow())
	ELSE
		MessageBox("Error Base Datos","Error al actualizar los datos en la base de datos")
		ROLLBACK;
	END IF
ELSE
	MessageBox("Error DataWindow","Error al actualizar los datos")
END IF

dw_produccion.SelectRow(0, False)
end event

event ue_borrar_trazos();Long li_filas

FOR li_filas = 1 TO dw_trazos_definidos.RowCount()
	IF dw_trazos_definidos.IsSelected(li_filas) THEN
		dw_trazos_definidos.DeleteRow(li_filas)
		li_filas = li_filas - 1
	END IF
NEXT

IF dw_trazos_definidos.AcceptText() = 1 THEN
	IF dw_trazos_definidos.Update() = 1 THEN
		COMMIT;
		This.of_cuadro(dw_trazo.GetRow())
	ELSE
		MessageBox("Error Base Datos","Error al actualizar los datos en la base de datos")
		ROLLBACK;
	END IF
ELSE
	MessageBox("Error DataWindow","Error al actualizar los datos")
END IF	

dw_trazos_definidos.SelectRow(0, False)
end event

event ue_grabar();Long li_j, ll_totaldw, ll_totalmas, ll_totalmenos, ll_totalaprog, ll_ordenpd, ll_count
Long ll_pendiente, ll_unidadestope
String ls_talla
Long li_talla, li_rectilineo1 ,li_rectilineo2, li_marca, li_tiptel, li_filas, li_estado_lib
Decimal{2} ldc_porcentaje, ld_porcentaje1, ld_porcentaje2
n_cts_constantes lpo_constantes

lpo_constantes = Create n_cts_constantes

ld_porcentaje1 = lpo_constantes.of_consultar_numerico("PORC PROG OC")

IF ld_porcentaje1 = -1 THEN
	Return
END IF

ld_porcentaje2 = lpo_constantes.of_consultar_numerico("PORC PROG OC -100")

IF ld_porcentaje2 = -1 THEN
	Return
END IF

ll_unidadestope = lpo_constantes.of_consultar_numerico("UNIDS TOPE RECALCULO")

IF ll_unidadestope = -1 THEN
	Return
END IF 
//se valida que lo que se va a programar este dentro de la tolerancia del 5% del total de la P.O.

//pero antes se debe saber si se trata de rectilineo o bodysize, si es asi se realiza la validacion del
//% a nivel de talla de lo contrario se realiza a nivel de totales

li_rectilineo1 = lpo_constantes.of_consultar_numerico('RECTILINEO 1')
 
IF li_rectilineo1 = -1 THEN
	Return 
END IF

li_rectilineo2 = lpo_constantes.of_consultar_numerico('RECTILINEO 2')
 
IF li_rectilineo2 = -1 THEN
	Return 
END IF

li_marca = 0

FOR li_filas = 1 TO dw_trazo.RowCount()
	li_tiptel = dw_trazo.GetItemnumber(li_filas, 'co_tiptel')
	IF li_tiptel = li_rectilineo1 OR li_tiptel = li_rectilineo2 THEN
		li_marca = 1
	END IF
NEXT

IF li_marca = 0 THEN
	//no es rectilineo, entonces verificamos si se trata de un bodysize, como se tiene la orden de corte
	//con esta se sabe la orden de produccion
	ll_ordenpd = dw_oc.GetItemNumber(dw_oc.GetRow(),'cs_ordenpd_pt')
	 
	 //con la orden de porduccion se averigua si es bodysize
	 Select count(*)
	   into :ll_count
		from h_ordenpd_te
	  where cs_ordenpd_pt = :ll_ordenpd and
	        sw_bodysize = 1;
			  
		If sqlca.sqlcode = -1 Then
			MessageBox('Error','Ocurrio un error al momento de establecer si se trata de un BodySize. '+Sqlca.SqlErrText)
			Return
		End if
	 	  
	If ll_count > 0 Then
		li_marca = 1
	End if
			
End if

////Traemos el tipo de liberacion para saber si es de criticas (1) automatica(2) o semiautomatica(3)
////en el tipo 1 no se validan unidades contra la op   jorodrig - jcreste  marzo 4-08
//Select co_est_liberacion
//  Into :li_estado_lib
//  From h_liberar_escalas
// Where co_fabrica_exp = 2
//   And cs_liberacion = :il_liberacion;
//	If sqlca.sqlcode <> 0 then
// 		MessageBox('Error','No se encontr$$HEX2$$f3002000$$ENDHEX$$el tipo de la liberacion. '+Sqlca.SqlErrText)
//		Return
//	End if
  

//averiguo el porcentaje permitido
//ldc_porcentaje = lpo_constantes.of_consultar_numerico('PORCENTAJE TRAZO')
//
//IF ldc_porcentaje = -1 THEN
//	Return
//END IF

//If li_estado_lib = 1 THEN   //es liberacion por criticas, en este caso no se validan unidades contra la op
//Else
	//para evaluar talla por talla si es bodysize o rectilineo
	For li_j = 1 To il_numtalla
		//total de la p.o para la primera talla
		ll_totaldw = dw_pdn_talla.GetItemNumber(1,"talla" + String(li_j))
		ll_pendiente = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() - 2,"talla" + String(li_j))
		IF ll_totaldw = ll_pendiente OR li_marca = 1 THEN
			IF ll_totaldw <= ll_unidadestope THEN
				ldc_porcentaje = ld_porcentaje2
			ELSE
				ldc_porcentaje = ld_porcentaje1
			END IF
		ELSE
			ldc_porcentaje = ld_porcentaje1
		END IF
		IF li_marca = 1 THEN
			ll_totalmenos = ll_totaldw - ((ll_totaldw * ldc_porcentaje)/100)
			ll_totalmas = Ceiling(ll_totaldw + ((ll_totaldw * ldc_porcentaje)/100))		
		ELSE
			ll_totalmas = Ceiling(ll_pendiente + ((ll_pendiente * ldc_porcentaje)/100))
		END IF
		//ya se tiene el rango de tolerancia, ahorra debemos conocer el total a a programar
		ll_totalaprog = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount()-1,"talla" + String(li_j))
		IF li_marca = 1 THEN
			If ll_totalaprog >= ll_totalmenos And ll_totalaprog <= ll_totalmas Then
			Else
				IF gstr_info_usuario.co_planta_pro = 2 THEN
					ls_talla = dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") 
					MessageBox('Error','El total a programar de la talla: '+Trim(ls_talla)+', no esta dentro de lo permitido.')
					Return
				END IF
			End if
		ELSE
			IF ll_totalaprog > ll_totalmas THEN
				IF gstr_info_usuario.co_planta_pro = 2 THEN
					ls_talla = dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") 
					MessageBox('Error','El total a programar de la talla: '+Trim(ls_talla)+', no esta dentro de lo permitido.')
					Return	
				END IF
			END IF
		END IF
	Next
	
	ll_totaldw = 0
	ldc_porcentaje = ld_porcentaje2
	//se evalua cuando no es ni bodysize ni rectilineo, osea se evalua la totalidad
	ll_totaldw = dw_pdn_talla.GetItemNumber(1,"talla" + String(il_numtalla + 1))
	ll_pendiente = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() - 2,"talla" + String(il_numtalla + 1))
	ll_totalmas = Ceiling(ll_totaldw +((ll_totaldw * ldc_porcentaje)/100))
	ll_totalmenos = ll_totaldw -((ll_totaldw * ldc_porcentaje)/100)
	//ya se tiene el rango de tolerancia, ahorra debemos conocer el total a a programar
	ll_totalaprog = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() -1 ,"talla" + String(il_numtalla + 1))
	If ll_totalaprog >= ll_totalmenos And ll_totalaprog <= ll_totalmas Then
	Else
		If ll_totalaprog > 0 Then
			IF gstr_info_usuario.co_planta_pro = 2 THEN
				MessageBox('Error','El total a programar no esta dentro de lo permitido.')
				Return
			END IF
		End if
	End if

//End If

IF dw_trazos_definidos.AcceptText() = 1 THEN
	IF dw_trazos_definidos.Update() = 1 THEN
		COMMIT;
		//This.of_cuadro(dw_trazo.GetRow())
	ELSE
		ROLLBACK;
		MessageBox("Error Base Datos","Error al actualizar la base de datos")
	END IF
ELSE
	MessageBox("Advertencia","Error al actualizar los datos")
END IF

//actualizar po
dw_pdn_talla.Reset()
dw_produccion.Reset()
dw_oc.Reset()
dw_partes.Reset()
dw_trazos_definidos.Reset()
dw_trazo.TriggerEvent(RowFocusChanged!)
end event

event ue_recalcular();Long li_respuesta,li_pdn, li_raya, li_fila_busca, li_base
Long ll_fila, ll_unidades,ll_result,ll_modelo,ll_result1
String ls_error,ls_po
Decimal{2}	ld_ancho, ld_anchoini
Datastore lds_agrupa_pdn_raya,lds_temp_trazo,lds_agrupapdn_raya
n_cts_cargar_temporales_liberacion luo_temporal
n_cts_liberacion_semiautomatica luo_liberacion

//*********************************** primero verifico la liberaci$$HEX1$$f300$$ENDHEX$$n y su estado ***********************************
//IF of_liberacion() = 3 THEN
//	IF of_valida_po_raya() = -1 THEN
//		Rollback;
//		Return
//	ELSE
//		//se trata de una liberaci$$HEX1$$f300$$ENDHEX$$n semiautomatica, debo saber como es el porcentaje de utilizacion del trazo con respecto
//		//al porcentaje de utilizacion de la ficha
//		lds_agrupa_pdn_raya = CREATE Datastore
//		lds_agrupa_pdn_raya.DataObject = 'ds_agrupa_pdn_raya'
//		lds_agrupa_pdn_raya.settransobject(sqlca)
//				
//		ll_result = lds_agrupa_pdn_raya.retrieve(il_agrupa)
//		
//		DELETE FROM temporal_trazo
//		WHERE temporal_trazo.usuario  = :gstr_info_usuario.codigo_usuario;
//		
//		IF SQLCA.SQLCODE <> 0 THEN
//			ls_error= sqlca.sqlErrText
//			ROLLBACK;
//			MessageBox('Error of_recporc', 'Al borrar la temporal de trazos :'  + ls_error)
//			RETURN ;
//		END IF	
//		
//		FOR ll_fila=1 TO ll_result
//			li_pdn 	 = lds_agrupa_pdn_raya.getitemnumber(ll_fila,'cs_pdn')
//			li_raya 	 = lds_agrupa_pdn_raya.getitemnumber(ll_fila,'raya')
//			ll_modelo = lds_agrupa_pdn_raya.getitemnumber(ll_fila,'co_modelo')
//
//			li_fila_busca = dw_trazo.Find("raya = " + string(li_raya), 1, dw_trazo.RowCount())
//	
//			IF li_fila_busca > 0 THEN
//				Of_Cuadro(li_fila_busca)
//				li_base = dw_trazo.GetItemNumber(li_fila_busca,'cs_base_trazos')
//				ld_ancho = dw_pdn_talla.GetItemNumber(dw_pdn_talla.GetRow(), "ancho_cortable") / 100
//				ld_anchoini = ld_ancho - 0.01	
//				IF of_consultar_trazos(il_agrupa, li_base, ld_ancho, ld_anchoini) = -1 THEN
//					Rollback;
//					return
//				END IF
//			END IF
//		
//			IF luo_temporal.of_recalcular_porcutil(li_pdn,li_raya,il_agrupa,il_color,il_liberacion,ii_fabexp,ll_modelo) = -1 THEN
//				Rollback;
//				Return 
//			END IF
//		NEXT
//		//se calcula el menor nro de unidades en los modelos
//		//y se actualizan las unidades por talla de los modelos en la tabla temporal_trazo
//		IF luo_temporal.of_menorunds()=-1 THEN
//			Rollback;
//			Return
//		END IF
//		//ahora se deben comparar las unidades y los metros de la liberaci$$HEX1$$f300$$ENDHEX$$n
//		//con las unidades y los metros del trazo
//		FOR ll_fila = 1 TO ll_result
//			ll_modelo = lds_agrupa_pdn_raya.getitemnumber(ll_fila,'co_modelo')
//			IF luo_temporal.of_comparar_undsmts(ii_fabexp,il_liberacion,ll_modelo,il_color)=-1 THEN
//				Rollback;
//				Return
//			END IF	
//		NEXT
//		//se calcula el menor nro de unidades en los modelos
//		//y se actualizan las unidades por talla de los modelos en la tabla temporal_trazo
//		IF luo_temporal.of_menorunds()=-1 THEN
//			Return
//		END IF
//		//en este punto debo realizar las atualizaciones de las tablas de la liberacion
//		IF luo_liberacion.of_actualizar_liberacion(ii_fabexp,il_liberacion,il_ordenpd,il_color) = -1 THEN
//			Rollback;
//			Return
//		ELSE
//			COMMIT;		
//			MessageBox("Recalculo exitoso","Se realiz$$HEX2$$f3002000$$ENDHEX$$el recalculo de las unidades")
//			This.TriggerEvent("ue_buscar")
//		END IF
//	END IF
//ELSE
	//no se trata de una liberaci$$HEX1$$f300$$ENDHEX$$n semiautomatica, se debe recalcular con el proceso para liberaciones
	//automaticas o manuales.
//	********************** proceso de recalculo de unidades para liberaciones automaticas o manuales *****************
	If of_valida_po_raya() = -1 Then
		Return
	Else
		li_respuesta = MessageBox("Recalculo Liberaci$$HEX1$$f300$$ENDHEX$$n","Est$$HEX2$$e1002000$$ENDHEX$$seguro de ejecutar este proceso", Question!, YesNo!)
		IF li_respuesta = 1 THEN
			DECLARE pr_recalcular PROCEDURE FOR
				pr_recalcular_liberacion(:il_agrupa,:gstr_info_usuario.fabrica);
				
			EXECUTE pr_recalcular;
			IF SQLCA.SQLCode = -1 THEN
				ls_error = SQLCA.SQLErrText
				ROLLBACK;		
				MessageBox("Error Base Datos","Error al ejecutar el proceso de recalculo de unidades " + ls_error)
			ELSE
				COMMIT;		
				MessageBox("Recalculo exitoso","Se realiz$$HEX2$$f3002000$$ENDHEX$$el recalculo de las unidades")
				This.TriggerEvent("ue_buscar")
			END IF
		END IF
	End if
//END IF
end event

event ue_recalcular_unidades();//evento para recalcular las unidades de una orden de corte despues de ser 
//programada en texografo, sin necesidad de borrar la liberacion anterior y
//tener que crear una nueva, ac$$HEX2$$e1002000$$ENDHEX$$se va a tomar la liberacion que existe y con base
//en esta se va a realizar el recalculo
//jcrm
//enero 17 de 2008
String ls_mensaje
n_cts_recalcular_unidades luo_unidades

//antes de racalcular unidades se verifica que la proporcion de los trazos sea igual a la proporci$$HEX1$$f300$$ENDHEX$$n
//realizada en la liberaci$$HEX1$$f300$$ENDHEX$$n, esto solo se validara inicialmente para las liberaciones make to stop
//esto se realiza por peticion de las personas que intervienen en el sue$$HEX1$$f100$$ENDHEX$$o de BTT el d$$HEX1$$ed00$$ENDHEX$$a 23 de abril
//jcrm
//abril 29 de 2008

//por el momento solo sera informativo, luego de validarse con la gente de texografo se pasara a colocar como 
//restrictivo.
IF luo_unidades.of_validar_proporcion(il_orden,ls_mensaje) = -1 THEN
	IF MessageBox('Advertencia','Liberaci$$HEX1$$f300$$ENDHEX$$n y trazos con proporciones diferentes,~n en el momento este mensaje es solo informativo,~n el proceso continuara normalmente,~n desea continuar.',Exclamation!,OKCancel!,2) = 2 THEN
		Return
	END IF
END IF

luo_unidades.of_recalcularoc(il_agrupa,il_orden)
end event

public subroutine of_consumos (long an_agrupacion, long an_basetrazo, long an_espacio, long an_seccion);
end subroutine

public function long of_buscar ();Long ll_result

ll_result = dw_trazo.Retrieve(il_agrupa, il_orden)
	
If ll_result <= 0 Then
	MessageBox("Advertencia!","Hubo errores al recuperar la producci$$HEX1$$f300$$ENDHEX$$n. posiblemente no tiene creado el numero de capas para la linea y tipo de tejido")
	dw_trazo.Reset()
	dw_produccion.Reset()
	Return -1
Else
	of_filtrar_trazos(1)
	//This.Title = "Secciones por Trazos :=: N$$HEX1$$fa00$$ENDHEX$$mero Orden " + String(il_orden) + " Agrupaci$$HEX1$$f300$$ENDHEX$$n:" + String (il_agrupa)
End If

//dw_oc.Retrieve (il_agrupa, ii_fabrica, ii_planta)
//dw_oc.Retrieve(il_agrupa)
//dw_produccion.Retrieve(il_agrupa)

This.Title = "Secciones por Trazos :=: N$$HEX1$$fa00$$ENDHEX$$mero Orden " + String(il_orden) + " Agrupaci$$HEX1$$f300$$ENDHEX$$n:" + String (il_agrupa)

Return 0
end function

public function long of_cuadro (long an_fila);//modificacion para poder mostrar las cantidades pendientes y programadas por cada talla - po
//elaborada por juan carlos restrepo medina, marzo de 2005

DataStore lds_tallas, lds_cant, lds_seleccion, lds_tllanal, lds_tllaexp
Long         ll_i,li_swv,li_talla,li_j, li_raya, li_fabant, li_linant, li_fabricapt
Long        ll_pdn,ll_pdnant,ll_fila,ll_cant,ll_total,ll_flfn,ll_ctpg,ll_trazo,&
            ll_modelo,ll_fab,ll_ref,ll_carac,ll_diamt,ll_color,ll_rslt, ll_refant,&
				ll_liberada
String      ls_title,ls_tag, ls_condicion,ls_talla
Long		li_co_fabrica_exp,li_cs_liberacion,li_co_linea,li_cs_paticion,&
				li_tllanal, li_tllaexp
Long			ll_co_referencia,ll_co_color_pt,ll_co_color_te, ll_fila_pend, ll_fila_prog,&
				ll_found,ll_programado, ll_pendiente, ll_fila_aprog, ll_totalprog, ll_totalpend,&
				ll_totalaprog, ll_fila2, ll_grantotalaprog
String		ls_po,ls_de_referencia,ls_tono,ls_de_color_1, ls_cut
Decimal	   ld_ancho_cortable
Decimal{2}	ld_yield

dw_trazo.AcceptText()

ll_trazo  	= dw_trazo.GetItemNumber(an_fila,'cs_base_trazos')
li_raya 		= dw_trazo.GetItemNumber(an_fila, 'raya')

dw_pdn_talla.Reset()

lds_tallas 		= Create DataStore
lds_cant   		= Create DataStore
lds_seleccion 	= Create DataStore
lds_tllanal 	= Create DataStore
lds_tllaexp 	= Create DataStore

lds_tallas.DataObject 		= 'd_distintas_tallas_trazos_recalculo'
lds_cant.DataObject   		= 'd_lista_trazo_cantidad_talla_recalculo'
lds_seleccion.DataObject 	= 'd_lista_cantidad_trazos_seleccionados'
lds_tllanal.DataObject		= 'ds_cantidades_criticas'
lds_tllaexp.DataObject     = 'ds_cantidades_exportacion'


lds_tallas.SetTransObject(Sqlca)
lds_cant.SetTransObject(Sqlca)
lds_seleccion.SetTransObject(Sqlca)
lds_tllanal.SetTransObject(sqlca)
lds_tllaexp.SetTransObject(sqlca)

il_numtalla = lds_tallas.Retrieve(il_agrupa,ll_trazo,is_po,ii_pdn)
li_tllanal = lds_tllanal.Retrieve(il_agrupa,is_po,il_color,ii_pdn,2008,8)
li_tllaexp = lds_tllaexp.Retrieve(il_agrupa,is_po,il_color,ii_pdn)

If il_numtalla <= 0 Then
	MessageBox("Advertencia!","Este agrupaci$$HEX1$$f300$$ENDHEX$$n no tiene tallas.")
	Return 1
End If

For ll_i = 1 To 23
	If il_numtalla >= ll_i Then
		li_swv   = 1
		ls_title = String(lds_tallas.GetItemNumber(ll_i,'co_talla'))
		//ls_title = String(lds_tallas.GetItemString(ll_i,'de_talla'))
	Else
		li_swv = 0
		If (il_numtalla + 1) = ll_i Then  ls_title = 'Total'
		If (il_numtalla + 1) >= ll_i Then li_swv   = 1
	End If
	
	dw_pdn_talla.Modify("talla" + String(ll_i) + "_t.Text='" + ls_title + "'")
	dw_pdn_talla.Modify("talla" + String(ll_i) + "_t.Visible='" + String(li_swv) + "'")
	dw_pdn_talla.Modify("talla" + String(ll_i) + ".Visible='" + String(li_swv) + "'")
	dw_pdn_talla.Modify("talla" + String(ll_i) + ".tag='" + ls_title + "'")
Next

ll_rslt = lds_cant.Retrieve(il_agrupa, ll_trazo, is_po, ii_pdn)

If ll_rslt > 0 Then
	ll_pdnant = lds_cant.GetItemNumber(1,'cs_pdn')
	ll_total  = 0
	il_numpdn = 1
	
	For ll_i = 1 To lds_cant.RowCount()
	
		ll_pdn    = lds_cant.GetItemNumber(ll_i,'cs_pdn')
		li_talla  = lds_cant.GetItemNumber(ll_i,'co_talla')
		ll_cant   = lds_cant.GetItemNumber(ll_i,'ca_unidades')
		ll_color	 = lds_cant.GetItemNumber(ll_i, 'co_color_te')
		//ls_talla  = lds_cant.GetItemString(ll_i,'de_talla')
		
//		ls_condicion = "co_modelo = " + String(ll_modelo) + " and co_fabrica_te = "+ String(ll_fab) + &
//							" and co_reftel = " + String(ll_ref) + " and co_caract = " + String(ll_carac) + &
//							" and diametro = " + String(ll_diamt) + " and co_color_te = " + String(ll_color) + &
//							" and cs_pdn = " + String(ll_pdn) + " and co_talla = " + String(li_talla)

		If ll_i = 1 Then 
			ll_fila = dw_pdn_talla.InsertRow(0)
			dw_pdn_talla.AcceptText()
			//se crean las filas para contener la informacion de lo pendiente y programado
			ll_fila_prog = dw_pdn_talla.InsertRow(0)
			ll_fila_pend = dw_pdn_talla.InsertRow(0)
			ll_fila_aprog = dw_pdn_talla.InsertRow(0)
			
			dw_pdn_talla.SetItem(ll_fila_prog,'marca',1)
			dw_pdn_talla.SetItem(ll_fila_pend,'marca',2)
			dw_pdn_talla.SetItem(ll_fila_aprog,'marca',3)
			
		ElseIf ll_pdn <> ll_pdnant Then 
			ll_fila  = dw_pdn_talla.InsertRow(0)
			dw_pdn_talla.AcceptText()
			//se crean las filas para contener la informacion de lo pendiente y programado
			ll_fila_prog = dw_pdn_talla.InsertRow(0)
			ll_fila_pend = dw_pdn_talla.InsertRow(0)
			ll_fila_aprog = dw_pdn_talla.InsertRow(0)
			
			dw_pdn_talla.SetItem(ll_fila_prog,'marca',1)
			dw_pdn_talla.SetItem(ll_fila_pend,'marca',2)
			dw_pdn_talla.SetItem(ll_fila_aprog,'marca',3)
			
			il_numpdn ++
			ll_total = 0
		End If

		li_co_fabrica_exp			=lds_cant.GetItemNumber(ll_i,'co_fabrica_exp')
		li_fabricapt				=lds_cant.GetItemNumber(ll_i,'co_fabrica_pt')
		li_cs_liberacion			=lds_cant.GetItemNumber(ll_i,'cs_liberacion')
		ls_po							=Trim(lds_cant.GetItemString(ll_i,'po'))
		ls_cut						=Trim(lds_cant.GetItemString(ll_i,'nu_cut'))		
		li_co_linea					=lds_cant.GetItemNumber(ll_i,'co_linea')
		ll_co_referencia			=lds_cant.GetItemNumber(ll_i,'co_referencia')
		ls_de_referencia			=Trim(lds_cant.GetItemString(ll_i,'de_referencia'))
		ll_co_color_pt				=lds_cant.GetItemNumber(ll_i,'co_color_pt')
		ld_yield						=lds_cant.GetItemNumber(ll_i,'yield')
		ls_tono						=Trim(lds_cant.GetItemString(ll_i,'tono'))
		li_cs_paticion				=lds_cant.GetItemNumber(ll_i,'cs_particion')
		ll_co_color_te				=lds_cant.GetItemNumber(ll_i, 'co_color_te')
		ls_de_color_1				=lds_cant.GetItemString(ll_i, 'de_color')
		ld_ancho_cortable			=lds_cant.GetItemNumber(ll_i, 'ancho_cortable')
		
		//********************** inicio modificacion noviembre 1 de 2007 ********************************
		//en este punto se debe realizar la validacion del estado de la ficha, pues aca se tienen los
		//datos de fabrica, linea, referencia, talla y color
		//jcrm
		//noviembre 1 de 2007
		
		
		//**********************  fin modificacion noviembre 1 de 2007 **********************************
		
		dw_pdn_talla.SetItem(ll_fila,"co_fabrica",li_co_fabrica_exp)
		dw_pdn_talla.SetItem(ll_fila,"cs_liberacion",li_cs_liberacion)
		dw_pdn_talla.SetItem(ll_fila,"po",ls_po)
		dw_pdn_talla.SetItem(ll_fila,"nu_cut",ls_cut)
		//dw_pdn_talla.SetItem(ll_fila,"co_linea",Trim(lds_cant.GetItemString(ll_i,'de_lin')))
		dw_pdn_talla.SetItem(ll_fila,"co_fabrica_pt",(lds_cant.GetItemNumber(ll_i,'co_fabrica_pt')))
		dw_pdn_talla.SetItem(ll_fila,"co_lin",(lds_cant.GetItemNumber(ll_i,'co_linea')))
		dw_pdn_talla.SetItem(ll_fila,"co_referencia",Trim(lds_cant.GetItemString(ll_i,'de_referencia')))
		dw_pdn_talla.SetItem(ll_fila,"co_ref",(lds_cant.GetItemNumber(ll_i,'co_referencia')))
		dw_pdn_talla.SetItem(ll_fila,"co_color",lds_cant.GetItemNumber(ll_i,'co_color_pt'))
		dw_pdn_talla.SetItem(ll_fila, "yield", ld_yield)
		dw_pdn_talla.SetItem(ll_fila,"tono",Trim(lds_cant.GetItemString(ll_i,'tono')))
		dw_pdn_talla.SetItem(ll_fila,"par",lds_cant.GetItemNumber(ll_i,'cs_particion'))
		dw_pdn_talla.SetItem(ll_fila, "co_color_te", lds_cant.GetItemNumber(ll_i, 'co_color_te'))
		dw_pdn_talla.SetItem(ll_fila, "de_color_te", lds_cant.GetItemString(ll_i, 'de_color'))
		dw_pdn_talla.SetItem(ll_fila, "ancho_cortable", lds_cant.GetItemNumber(ll_i, 'ancho_cortable'))
		dw_pdn_talla.SetItem(ll_fila, "orden", 0)
		
		ll_total += ll_cant
		
		ll_pdnant = ll_pdn
		
		For li_j = 1 To il_numtalla
			If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
			  //If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = ls_talla Then
				dw_pdn_talla.SetItem(ll_fila,"talla" + String(li_j),ll_cant)
				//en este punto se debe averiguar las cantidades pendientes y programadas
				//primero busco en las nacionales
				ll_found = lds_tllanal.Find( "co_talla = "+String(li_talla) ,1, lds_tllanal.RowCount())
														
				If ll_found > 0 Then
					//se hallo registro y se carga en la dw
					//se encontro registro en exportaciones y se carga la dw
					ii_tipo = 2
					ll_liberada = lds_tllanal.GetItemNumber(ll_found,'ca_liberada')
					ll_programado = lds_tllanal.GetItemNumber(ll_found,'ca_programada')
					
					If ll_liberada > ll_programado Then ll_programado = ll_liberada
					
					ll_pendiente = lds_tllanal.GetItemNumber(ll_found,'ca_prog_trazos')
					If isnull(ll_pendiente) Then ll_pendiente = 0
					ll_pendiente = ll_programado - ll_pendiente
					dw_pdn_talla.SetItem(ll_fila_prog,'marca',1)
					dw_pdn_talla.AcceptText()
					dw_pdn_talla.SetItem(ll_fila_prog,"talla" + String(li_j),ll_programado)
					dw_pdn_talla.SetItem(ll_fila_pend,"talla" + String(li_j),ll_pendiente)
					dw_pdn_talla.SetItem(ll_fila_pend,'marca',2)
					dw_pdn_talla.SetItem(ll_fila_aprog,"talla" + String(li_j),0)
					dw_pdn_talla.SetItem(ll_fila_aprog,'marca',3)
					
					ll_totalprog = ll_totalprog + ll_programado
					ll_totalpend = ll_totalpend + ll_pendiente
	
				Else
					//no se encontro registro en nacionales, se debe buscar en exportacion
					ll_found = lds_tllaexp.Find( "co_talla = "+String(li_talla) ,1, lds_tllaexp.RowCount())
					If ll_found > 0 Then
						
						ii_tipo = 1
						ll_programado = lds_tllaexp.GetItemNumber(ll_found,'ca_programada')
						ll_pendiente =  lds_tllaexp.GetItemNumber(ll_found,'ca_prog_trazos')
						If isnull(ll_pendiente) Then ll_pendiente = 0
						ll_pendiente = ll_programado - ll_pendiente
						dw_pdn_talla.SetItem(ll_fila_prog,'marca',1)
						dw_pdn_talla.AcceptText()
						dw_pdn_talla.SetItem(ll_fila_prog,"talla" + String(li_j),ll_programado)
						dw_pdn_talla.SetItem(ll_fila_pend,"talla" + String(li_j),ll_pendiente)
						dw_pdn_talla.SetItem(ll_fila_pend,'marca',2)
						dw_pdn_talla.SetItem(ll_fila_aprog,"talla" + String(li_j),0)
						dw_pdn_talla.SetItem(ll_fila_aprog,'marca',3)
					
						ll_totalprog = ll_totalprog + ll_programado
						ll_totalpend = ll_totalpend + ll_pendiente
							
					Else
						//no se encontro registro ni en nacional ni en exportacion, mensaje y salir
						MessageBox('Error','No fue posible establecer cantidades ni pendiente, ni programadas.')
						
						Return 1
					End if
				End if
				
				Exit
			End If
		Next 
		
		
		
		dw_pdn_talla.SetItem(ll_fila,"pdn",ll_pdn)
		dw_pdn_talla.SetItem(ll_fila_prog,"talla" + String(il_numtalla + 1),ll_totalprog)
		dw_pdn_talla.SetItem(ll_fila_pend,"talla" + String(il_numtalla + 1),ll_totalpend)
		dw_pdn_talla.SetItem(ll_fila,"talla" + String(il_numtalla + 1),ll_total)
	Next
End If

ll_rslt = lds_seleccion.Retrieve(il_agrupa, li_raya,ii_pdn)

If ll_rslt > 0 Then

	For ll_i = 1 To lds_seleccion.RowCount()
		li_co_fabrica_exp	=	lds_seleccion.GetItemNumber(ll_i,'co_fabrica')
		li_co_linea			=	lds_seleccion.GetItemNumber(ll_i,'co_linea')
		ll_co_referencia	=	lds_seleccion.GetItemNumber(ll_i,'co_referencia')
		li_talla   			=	lds_seleccion.GetItemNumber(ll_i,'co_talla')		
		ll_cant   			=	lds_seleccion.GetItemNumber(ll_i,'unidades')
		
		ls_condicion = "co_fabrica_pt = " + String(li_co_fabrica_exp) + " and co_lin = "+ String(li_co_linea) + &
							" and co_ref = " + String(ll_co_referencia)
							
		ll_rslt = dw_pdn_talla.Find(ls_condicion, 1, dw_pdn_talla.Rowcount())
		
		If ll_rslt <> 0 Then

			If ll_i = 1 Then 
				//ll_fila = dw_pdn_talla.InsertRow(0)
				ll_fila = dw_pdn_talla.RowCount()
			ElseIf li_co_fabrica_exp <> li_fabant OR li_co_linea <> li_linant OR &
						ll_co_referencia <> ll_refant Then 
				//ll_fila  = dw_pdn_talla.InsertRow(0)
				ll_fila = dw_pdn_talla.RowCount()
				ll_total = 0
			End If
			
			dw_pdn_talla.SetItem(ll_fila,"co_fabrica_pt", li_co_fabrica_exp)
			dw_pdn_talla.SetItem(ll_fila,"co_lin", li_co_linea)
			dw_pdn_talla.SetItem(ll_fila,"co_ref", ll_co_referencia)
			dw_pdn_talla.SetItem(ll_fila,"co_referencia", lds_seleccion.GetItemString(ll_i, "de_referencia"))
			dw_pdn_talla.SetItem(ll_fila, "orden", 1)
			
			ll_total += ll_cant
			
			For li_j = 1 To il_numtalla
				If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
				  //If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = ls_talla Then
					dw_pdn_talla.SetItem(ll_fila,"talla" + String(li_j),ll_cant)
					Exit
				End If
			Next 
		End If
		li_fabant	=	li_co_fabrica_exp
		li_linant	=	li_co_linea
		ll_refant	=	ll_co_referencia		
	Next
   
End If

//se coloca la fila para determinar el resultado de lo que esta liberado y lo que se esta llevando a programar
ll_fila2 = dw_pdn_talla.InsertRow(0)
dw_pdn_talla.SetItem(ll_fila2,'marca',4)

For li_j = 1 To il_numtalla
		ll_totalaprog = dw_pdn_talla.GetItemNumber(ll_fila_aprog,"talla" + String(li_j))	
		ll_grantotalaprog += ll_totalaprog
		ll_total = dw_pdn_talla.GetItemNumber(1,"talla" + String(li_j))
		dw_pdn_talla.SetItem(ll_fila2,"talla" + String(li_j),ll_total - ll_totalaprog)
Next 
//los totales
dw_pdn_talla.SetItem(ll_fila_aprog,"talla" + String(il_numtalla + 1),ll_grantotalaprog)
ll_totalaprog = dw_pdn_talla.GetItemNumber(ll_fila_aprog,"talla" + String(il_numtalla + 1))	
ll_total = dw_pdn_talla.GetItemNumber(1,"talla" + String(il_numtalla + 1))
dw_pdn_talla.SetItem(ll_fila2,"talla" + String(il_numtalla + 1),ll_total - ll_totalaprog)





Destroy lds_tallas
Destroy lds_cant
Destroy lds_seleccion
//dw_pdn_talla.Sort()
//dw_pdn_talla.GroupCalc()

Return 0
end function

public function long of_agrupacion (long an_orden, ref long ai_estado_agrupa);Long   ll_agrupa
Long li_estado
String ls_sqlerr


select distinct dt_agrupa_pdn.cs_agrupacion, dt_pdnxmodulo.co_estado_asigna,
			h_agrupa_pdn.co_estado
  into :ll_agrupa, :li_estado, :ai_estado_agrupa
  from dt_pdnxmodulo, dt_agrupa_pdn, h_agrupa_pdn
 where dt_pdnxmodulo.co_fabrica_exp 		= dt_agrupa_pdn.co_fabrica_exp and
       dt_pdnxmodulo.cs_liberacion 			= dt_agrupa_pdn.cs_liberacion and
       dt_pdnxmodulo.po 						= dt_agrupa_pdn.po and
		 dt_pdnxmodulo.nu_cut					= dt_agrupa_pdn.nu_cut and
       dt_pdnxmodulo.co_fabrica_pt 			= dt_agrupa_pdn.co_fabrica_pt and 
       dt_pdnxmodulo.co_linea 				= dt_agrupa_pdn.co_linea and
       dt_pdnxmodulo.co_referencia 			= dt_agrupa_pdn.co_referencia and  
       dt_pdnxmodulo.co_color_pt 			= dt_agrupa_pdn.co_color_pt and
       dt_pdnxmodulo.tono 						= dt_agrupa_pdn.tono and  
       dt_pdnxmodulo.cs_particion 			= dt_agrupa_pdn.cs_particion and
       dt_pdnxmodulo.cs_asignacion 			= :an_orden and
		 dt_agrupa_pdn.cs_agrupacion			= h_agrupa_pdn.cs_agrupacion;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	If Sqlca.SqlCode = -284 THEN
		MessageBox("Advertencia!","Hubo un error al recuperar la agrupaci$$HEX1$$f300$$ENDHEX$$n, las_liberaciones no tienen el mismo estado.")		
	Else
		MessageBox("Advertencia!","Hubo un error al recuperar la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~nNota: " + ls_sqlerr)
	End If
	rollback ;	
	Return -1
ElseIf Sqlca.SqlCode = 100 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Esta orden no tiene agrupaci$$HEX1$$f300$$ENDHEX$$n.")
	Return -1
End If

If li_estado <> ii_aprobado Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","Esta orden de corte no est$$HEX2$$e1002000$$ENDHEX$$aprobada por planeaci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
End If

Return ll_agrupa
end function

public function long of_calcular_aprogramar ();Long li_j, li_talla, li_paquete, li_capas
Long ll_fila, ll_trazo, ll_fila2, ll_total, ll_totaldw, ll_totalpend,ll_grantotal
Long ll_liberado, ll_unidadestope 
Decimal{2} ld_ancho, ld_anchoini, ld_porcentaje1, ld_porcentaje2, ld_porcentaje
DataStore lds_paq
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

ld_porcentaje1 = luo_constantes.of_consultar_numerico("PORC PROG OC")

IF ld_porcentaje1 = -1 THEN
	Return -1
END IF

ld_porcentaje2 = luo_constantes.of_consultar_numerico("PORC PROG OC -100")

IF ld_porcentaje2 = -1 THEN
	Return -1
END IF

ll_unidadestope = luo_constantes.of_consultar_numerico("UNIDS TOPE RECALCULO")

IF ll_unidadestope = -1 THEN
	Return -1
END IF 

dw_trazos_definidos.AcceptText()

lds_paq = Create DataStore
lds_paq.DataObject = 'ds_trazos_x_talla'
lds_paq.SetTransObject(sqlca)

If dw_pdn_talla.RowCount() > 0 THEN
	ld_ancho = dw_pdn_talla.GetItemNumber(1, "ancho_cortable") / 100
	//ld_ancho = 1.98
	ld_anchoini = ld_ancho - 0.01
End If
	
//saber cuales trazos fueron seleccionados
For ll_fila = 1 To dw_trazos_definidos.RowCount()
	ll_trazo = dw_trazos_definidos.GetItemNumber(ll_fila,'co_trazo')
	li_capas = dw_trazos_definidos.GetItemNumber(ll_fila,'ca_capas')
	lds_paq.Retrieve(ll_trazo, il_agrupa, ii_pdn)
	For ll_fila2 = 1 To lds_paq.RowCount()
		//ya se pueden obtener los paquetes y las tallas
		li_talla = lds_paq.GetItemNumber(ll_fila2,'co_talla')
		li_paquete = lds_paq.GetItemNumber(ll_fila2,'ca_paquetes')
		
		ll_total = li_capas * li_paquete
		//modifico el dato en los datos a programar
		For li_j = 1 To il_numtalla
			If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
				//primero traigo el valor que tiene en dw
				ll_totaldw = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() -1   ,"talla" + String(li_j))
				ll_total = ll_total + ll_totaldw
				
				//luego se valida que el total no este por encima de lo pendiente
				ll_totalpend = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() - 2,"talla" + String(li_j))
				ll_liberado = dw_pdn_talla.GetItemNumber(1, "talla" + String(li_j))
				IF ii_tipo = 2 THEN
					ll_totalpend = ll_totalpend * 1.05
				END IF
				
				If ll_total <= ll_totalpend Then
					dw_pdn_talla.SetItem(dw_pdn_talla.RowCount() -1 ,"talla" + String(li_j),ll_total)
					Exit
				Else
					MessageBox('Advertencia','Las unidades son superirores a las pendientes.')
					Return -1 
				End if
			End If
		Next
		ll_total = 0
	Next
Next


Return 0
			
			
			
			
			
			



end function

public function long of_valida_po_raya ();Long ll_fila, ll_fila2
Long li_raya, li_result, li_raya2,li_marca
Datastore lds_raya

lds_raya = Create DataStore
lds_raya.DataObject = 'dtb_poxagrupacion'
lds_raya.setTransObject(sqlca)

For ll_fila = 1 To dw_trazo.RowCount()
	li_raya = dw_trazo.GetItemNumber(ll_fila,'raya')
	li_result = lds_raya.Retrieve(il_agrupa,li_raya)
	li_marca = 0
	If li_result > 0 Then
		For ll_fila2 = 1 To li_result
			li_raya2 = lds_raya.GetItemNumber(ll_fila2,'raya_1')
			If li_raya = li_raya2 Then
				li_marca += 1
			End if
		Next
		If li_marca > 0 And li_marca <> li_result Then
			MessageBox('Advertencia','No todas las P.O. de la raya: '+String(li_raya)+' tienen trazos definidos')
			Return -1
		End if
	Else
		MessageBox('Error','Inconsistencia de datos, no se encontro P.O. para la raya: '+String(li_raya))
		Return -1
	End if
Next

Return 0
end function

public function long of_validar_trazo (long al_trazo);Long li_j, li_talla, li_paquete, li_capas, li_marca
Long ll_fila, ll_trazo, ll_fila2, ll_total, ll_totaldw, ll_totalpend,ll_gran_total,&
	  ll_totalaprog, ll_fila_aprog, ll_grantotalaprog	
Decimal{2} ld_ancho, ld_anchoini
DataStore lds_paq

lds_paq = Create DataStore
lds_paq.DataObject = 'ds_trazos_x_talla'
lds_paq.SetTransObject(sqlca)
	
lds_paq.Retrieve(al_trazo,il_agrupa,ii_pdn)

For ll_fila2 = 1 To lds_paq.RowCount()
	//ya se pueden obtener los paquetes y las tallas
	li_talla = lds_paq.GetItemNumber(ll_fila2,'co_talla')
	
	//modifico el dato en los datos a programar
	For li_j = 1 To il_numtalla
		If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
			li_marca = 0
			Exit
		Else
			li_marca = 1
		End If
	Next
	ll_total = 0
	If li_marca = 1 Then
		MessageBox('Advertencia','La talla: '+String(li_talla)+' no existe en la liberaci$$HEX1$$f300$$ENDHEX$$n.')
		Return 1
	End if
Next

Return 0

			
end function

protected subroutine of_cargar_trazos_recalculo (long al_fila);Long ll_fila, ll_fila2, ll_trazo, ll_filadw, ll_trazo2
Long li_raya, li_pdn
Decimal{2} ldc_ancho, ldc_largo, ldc_porc
String ls_trazo

dw_trazo.AcceptText()

//recorro la dw de trazos para saber cuales han sido seleccionados y poder reconstruir la dw de trazos definidos
//For ll_fila =  1 To dw_produccion.RowCount()
	//If dw_produccion.IsSelected(ll_fila) Then
		//se cargan los datos del trazo
		ll_trazo = dw_produccion.GetItemNumber(al_fila,'co_trazo')
		li_pdn 	= dw_oc.GetItemNumber(dw_oc.GetRow(),'cs_pdn')
		li_raya 	= dw_trazo.GetItemNumber(dw_trazo.GetRow(),'raya')
		
		
		//verifico que el dato no exista
			For ll_filadw = 1 To dw_trazos_definidos.RowCount()
				ll_trazo2 	=  dw_trazos_definidos.GetItemNumber(ll_filadw,'co_trazo')
				
				If ll_trazo2 = ll_trazo Then 
					MessageBox('Advertencia','El trazo ya se en cuentra seleccionado')
					Return
				End if
			Next
		
		Select ancho, largo, porc_util, de_trazo
		  into :ldc_ancho, :ldc_largo, :ldc_porc, :ls_trazo
		  from h_trazos
		 where co_trazo = :ll_trazo; 
		 
		If sqlca.sqlcode <> 0 Then
			MessageBox('Error','No fue posible establecer los datos del trazo.',StopSign!)
		Else
			ll_fila2 = dw_trazos_definidos.InsertRow(0)
				
			//cargo los datos en pantalla
			dw_trazos_definidos.SetItem(ll_fila2,'cs_agrupacion',il_agrupa)
			dw_trazos_definidos.SetItem(ll_fila2,'cs_pdn',li_pdn)
			dw_trazos_definidos.SetItem(ll_fila2,'raya',li_raya)
			dw_trazos_definidos.SetItem(ll_fila2,'co_trazo',ll_trazo)
			dw_trazos_definidos.SetItem(ll_fila2,'de_trazo',ls_trazo)
			dw_trazos_definidos.SetItem(ll_fila2,'ancho',ldc_ancho)
			dw_trazos_definidos.SetItem(ll_fila2,'largo',ldc_largo)
			dw_trazos_definidos.SetItem(ll_fila2,'porc_util',ldc_porc)
			
		End if
//	Else
//		
//	End If
//Next

dw_trazos_definidos.AcceptText()
end subroutine

public function long of_consultar_trazos (long al_agrupa, long ai_base, decimal ad_ancho, decimal ad_anchoini);//La condicion para mostrar los trazos actualmente es que tengan un ancho con diferencia de 1 cm
//y que los datos en la tabla dt_refptxtrazo sean los mismos en fabrica - linea - referencia
//de la tabla dt_pdnxmodulo ademas que si el trazo tiene 3 referencias para utilizarlo debe tener
//la orden de corte armada con 3 referencias
//jorodrig mayo 28 - 09


DECLARE sp_createmp PROCEDURE FOR
	pr_creatab_constrazo();
	
EXECUTE sp_createmp;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al crear las tablas temporales " + SQLCA.SQLErrText)
	ROLLBACK;
	Return -1
END IF

INSERT INTO temp_reftrazo(co_fabrica, co_linea, co_referencia)
SELECT DISTINCT co_fabrica, co_linea, co_referencia
FROM dt_rayas_telaxbase
WHERE cs_agrupacion = :al_agrupa AND
		cs_base_trazos = :ai_base;
		
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al insertar las referencias en la temporal " + SQLCA.SQLErrText)
	ROLLBACK;
	Return -1
END IF 

DECLARE sp_constrazo PROCEDURE FOR
	pr_constrazo_agrupa(:ad_ancho, :ad_anchoini);
	
EXECUTE sp_constrazo;

IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar los trazos de la agrupacion " + SQLCA.SQLErrText)
	ROLLBACK;
	Return -1		
END IF

COMMIT;
Return 1
end function

public subroutine of_filtrar_trazos (long al_fila);//funcion que filtra los datos de los trazos, para que solo salgan los que esten en el rango de utilizaci$$HEX1$$f300$$ENDHEX$$n.
//con respecto a la ficha, y pertenezcan a la raya que se esta trabajando

Long li_raya
Decimal{0} ldc_porc_util, ldc_porc
string ls_expresion
n_cts_constantes_corte lpo_const_corte

//traigo la raya y el porcentaje de utilizacion de la ficha
li_raya = dw_trazo.GetItemNumber(al_fila,'raya')
//ldc_porc_util = dw_trazo.GetItemNumber(al_fila,'porc_utilizacion')

//debo conocer cual es el porcentaje de tolerancia permitido
//ldc_porc = lpo_const_corte.of_consultar_numerico('PORC UTILIZACION TRAZO')
//
//If ldc_porc = -1 Then
//	ldc_porc = 0 
//End if

//realizo el filtro de los trazos.
//ldc_porc_util = ldc_porc_util - ldc_porc

//ls_expresion = " co_raya = "+String(li_raya)+" and porc_utili >= "+String(ldc_porc_util)
ls_expresion = " co_raya = "+String(li_raya)
dw_produccion.SetFilter(ls_expresion)
dw_produccion.Filter( )





end subroutine

public function long of_liberacion ();
Long li_estado

//*********************** se debe saber inicialmente cual es el numero de la liberacion ***************************

SELECT DISTINCT cs_liberacion,co_fabrica_exp
  INTO :il_liberacion,:ii_fabexp
  FROM dt_agrupa_pdn
 WHERE cs_agrupacion = :il_agrupa AND
 		 cs_pdn = :ii_pdn;
		  
		  
//*************** debo saber si la liberacion fue semiautomatica co_est_liberacion = 3 en h_liberar_escalas *******
SELECT co_est_liberacion
  INTO :li_estado
  FROM h_liberar_escalas
 WHERE cs_liberacion = :il_liberacion;
 
 
IF li_estado = 3 THEN
	Return 3
ELSE
	Return 0
END IF
end function

public function long of_restar_aprogramar (long al_fila, long ai_marca, decimal adc_porc_ficha, decimal adc_porc_trazo);	//ai_marca = 2 se resta, =1 se suma

Long li_j, li_talla, li_paquete, li_capas, li_result
Long ll_fila, ll_trazo, ll_fila2, ll_total, ll_totaldw, ll_totalpend,ll_gran_total,&
	  ll_totalaprog, ll_fila_aprog, ll_grantotalaprog, ll_liberado, ll_unidadestope
Decimal{2} ld_ancho, ld_anchoini, ld_porcentaje, ld_porcentaje1, ld_porcentaje2
String ls_mensaje
DataStore lds_paq
n_cts_constantes luo_constantes
n_cst_liberacion luo_liberacion

luo_constantes = Create n_cts_constantes

ld_porcentaje1 = luo_constantes.of_consultar_numerico("PORC PROG OC")

IF ld_porcentaje1 = -1 THEN
	Return -1
END IF

ld_porcentaje2 = luo_constantes.of_consultar_numerico("PORC PROG OC -100")

IF ld_porcentaje2 = -1 THEN
	Return -1
END IF

ll_unidadestope = luo_constantes.of_consultar_numerico("UNIDS TOPE RECALCULO")

IF ll_unidadestope = -1 THEN
	Return -1
END IF 


//dw_trazos_definidos.AcceptText()

lds_paq = Create DataStore
lds_paq.DataObject = 'ds_trazos_x_talla'
lds_paq.SetTransObject(sqlca)
	
ll_trazo = dw_trazos_definidos.GetItemNumber(al_fila,'co_trazo')
li_capas = dw_trazos_definidos.GetItemNumber(al_fila,'ca_capas')
lds_paq.Retrieve(ll_trazo,il_agrupa,ii_pdn)

For ll_fila2 = 1 To lds_paq.RowCount()
	//ya se pueden obtener los paquetes y las tallas
	li_talla = lds_paq.GetItemNumber(ll_fila2,'co_talla')
	li_paquete = lds_paq.GetItemNumber(ll_fila2,'ca_paquetes')
	
	ll_total = li_capas * li_paquete
	//modifico el dato en los datos a programar
	For li_j = 1 To il_numtalla
		If dw_pdn_talla.Describe("talla" + String(li_j) + ".tag") = String(li_talla) Then
			//primero traigo el valor que tiene en dw
			ll_totaldw = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() - 1,"talla" + String(li_j))
			If ai_marca = 1 Then
				ll_total = ll_total + ll_totaldw
			Else
				If ll_totaldw = 0 Then
			
				Else
					ll_total =  ll_totaldw - ll_total
				End if
				If ll_total < 0 Then ll_total = 0
			End if
			
			//luego se valida que el total no este por encima de lo pendiente
			ll_totalpend = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() - 2,"talla" + String(li_j))
			ll_liberado = dw_pdn_talla.GetItemNumber(1,"talla" + String(li_j))
			
			IF ll_totalpend = ll_liberado THEN
				IF ll_totalpend <= ll_unidadestope THEN
					ld_porcentaje = 1 + (ld_porcentaje2 / 100)
				ELSE
					ld_porcentaje = 1 + (ld_porcentaje1 / 100)
				END IF
			ELSE
				ld_porcentaje = 1 + (ld_porcentaje1 / 100)
			END IF
			ll_totalpend = Ceiling(ll_totalpend * ld_porcentaje)
			
			If ll_total <= ll_totalpend Then
				dw_pdn_talla.SetItem(dw_pdn_talla.RowCount() -1,"talla" + String(li_j),ll_total)
				Exit
			Else
				//si la liberacion es realizada por las criticas se deja programar por encima
				//jcrm
				//marzo 10 de 2008
				li_result = luo_liberacion.of_obtenerliberacion(il_orden,ls_mensaje) 
				IF li_result = -1 THEN
					MessageBox('Error','Ocurrio un error al momento de determinar el tipo de liberaci$$HEX1$$f300$$ENDHEX$$n. '+ls_mensaje,StopSign!)
					Return 1
				END IF
				
				//1 cuando la liberacion es de criticas, en este caso se permite sobrepasar el numero de unidades,
				//diferente de uno, debe respectarse las unidades programadas por lo tanto la validacion
				//de no sobrepasar en lo programado el numero de unidades continua.
				//jcrm
				//marzo 10 de 2008
				IF li_result <> 1 THEN 
					IF gstr_info_usuario.co_planta_pro = 2 THEN
						MessageBox('Advertencia','Las unidades son superirores a las pendientes.',StopSign!)
						Return 1
					END IF
				END IF
			End if
					
		End If
	Next
	ll_total = 0
	
Next

ll_gran_total = 0
For li_j = 1 To il_numtalla
	ll_totaldw = dw_pdn_talla.GetItemNumber(dw_pdn_talla.RowCount() -1 ,"talla" + String(li_j))
	ll_gran_total += ll_totaldw
	dw_pdn_talla.SetItem(dw_pdn_talla.RowCount() -1 ,"talla" + String(il_numtalla + 1),ll_gran_total)
Next

//se coloca la fila para determinar el resultado de lo que esta liberado y lo que se esta llevando a programar
ll_fila2 = dw_pdn_talla.RowCount()
For li_j = 1 To il_numtalla
		ll_totalaprog = dw_pdn_talla.GetItemNumber(ll_fila2 -1 ,"talla" + String(li_j))	
		ll_grantotalaprog += ll_totalaprog
		ll_total = dw_pdn_talla.GetItemNumber(1,"talla" + String(li_j))
		dw_pdn_talla.SetItem(ll_fila2,"talla" + String(li_j),ll_total - ll_totalaprog)
Next 
//los totales
dw_pdn_talla.SetItem(ll_fila_aprog,"talla" + String(il_numtalla + 1),ll_grantotalaprog)
ll_totalaprog = dw_pdn_talla.GetItemNumber(ll_fila2 -1,"talla" + String(il_numtalla + 1))	
ll_total = dw_pdn_talla.GetItemNumber(1,"talla" + String(il_numtalla + 1))
dw_pdn_talla.SetItem(ll_fila2,"talla" + String(il_numtalla + 1),ll_total - ll_totalaprog)


Return 0
end function

on w_definir_trazos_recalculo.create
if this.MenuName = "m_seleccion_trazos" then this.MenuID = create m_seleccion_trazos
this.dw_partes=create dw_partes
this.dw_trazos_definidos=create dw_trazos_definidos
this.dw_oc=create dw_oc
this.dw_pdn_talla=create dw_pdn_talla
this.dw_produccion=create dw_produccion
this.dw_trazo=create dw_trazo
this.Control[]={this.dw_partes,&
this.dw_trazos_definidos,&
this.dw_oc,&
this.dw_pdn_talla,&
this.dw_produccion,&
this.dw_trazo}
end on

on w_definir_trazos_recalculo.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_partes)
destroy(this.dw_trazos_definidos)
destroy(this.dw_oc)
destroy(this.dw_pdn_talla)
destroy(this.dw_produccion)
destroy(this.dw_trazo)
end on

event open;TRANSACTION			itr_tela
STRING	ls_instruccion
n_cts_constantes luo_constantes

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

itr_tela = Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

//se deshabilitan las opciones del menu para los usuarios que no sean de texografo.
//jcrm
//marzo 27 de 2007
IF (gstr_info_usuario.codigo_perfil = 16) OR (gstr_info_usuario.codigo_perfil = 19) OR (gstr_info_usuario.codigo_perfil = 5) THEN
	IF gstr_info_usuario.codigo_usuario = 'fasernap' or gstr_info_usuario.codigo_usuario = 'ccescoba' &
	   OR gstr_info_usuario.codigo_usuario = 'jdpalaci' THEN
		m_seleccion_trazos.m_edicion.m_recalcularliberacion.Visible = True
		m_seleccion_trazos.m_edicion.m_recalcularliberacion.Enabled = True
		m_seleccion_trazos.m_edicion.m_recalcularliberacion.ToolbarItemVisible = True

	END IF
ELSE
	m_seleccion_trazos.m_edicion.m_insertarmaestro.ToolbarItemVisible = False
	m_seleccion_trazos.m_edicion.m_borrarmaestro.ToolbarItemVisible = False
	m_seleccion_trazos.m_edicion.m_recalcularliberacion.ToolbarItemVisible = False
	m_seleccion_trazos.m_archivo.m_grabar.ToolbarItemVisible = False
	
	m_seleccion_trazos.m_edicion.m_insertarmaestro.Visible = False
	m_seleccion_trazos.m_edicion.m_borrarmaestro.Visible = False
	m_seleccion_trazos.m_edicion.m_recalcularliberacion.Visible = False
	m_seleccion_trazos.m_archivo.m_grabar.Visible = False
	
	dw_produccion.Object.DataWindow.ReadOnly
	dw_trazo.Object.DataWindow.ReadOnly
	dw_oc.Object.DataWindow.ReadOnly
	dw_trazos_definidos.Object.DataWindow.ReadOnly
	dw_partes.Object.DataWindow.ReadOnly
END IF


dw_produccion.SetTransObject(itr_tela)
dw_trazo.SetTransObject(itr_tela)
dw_oc.SetTransObject(itr_tela)
dw_trazos_definidos.SetTransObject(itr_tela)
dw_partes.SetTransObject(itr_tela)

ls_instruccion = "SET LOCK MODE TO WAIT 60 "
EXECUTE IMMEDIATE :ls_instruccion USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","Problemas con la base de datos en el modo de bloqueo: " +sqlca.sqlerrtext,Stopsign!,OK!)
   Return(-1)
END IF

luo_constantes = Create n_cts_constantes
ii_fabrica = luo_constantes.of_consultar_numerico("FABRICA PLANTA")
IF ii_fabrica = -1 THEN
	Return
END IF
ii_planta = luo_constantes.of_consultar_numerico("PLANTA LIBERACIONES")
IF ii_planta = -1 THEN
	Return
END IF

ii_simulacion = luo_constantes.of_consultar_numerico("SIMULACION")
IF ii_simulacion = -1 THEN
	Return
END IF

ii_aprobado= luo_constantes.of_consultar_numerico("LIBERACION APROBADA")
IF ii_aprobado = -1 THEN
	Return
END IF

This.TriggerEvent("ue_buscar")

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_produccion.SetTransObject(sqlca)
dw_trazo.SetTransObject(sqlca)
dw_oc.SetTransObject(sqlca)
dw_trazos_definidos.SetTransObject(sqlca)
dw_partes.SetTransObject(sqlca)
end event

type dw_partes from datawindow within w_definir_trazos_recalculo
integer x = 2871
integer y = 688
integer width = 754
integer height = 512
integer taborder = 40
string title = "none"
string dataobject = "dgr_partes_modelo"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_trazos_definidos from u_dw_base within w_definir_trazos_recalculo
integer x = 1701
integer y = 1212
integer width = 1925
integer height = 740
integer taborder = 50
string dataobject = "dgr_trazos_recalculo"
end type

event clicked;call super::clicked;If Row <= 0 Then Return

If This.IsSelected(Row) Then
	This.SelectRow(Row, False)
Else
	This.SelectRow(Row,True)
End If
end event

event itemchanged;Long ll_capas, ll_capas_optimas
dwItemStatus l_status
Decimal{0} ldc_porc_util, ldc_porc_trazo

//modificacion solicitada por Hector Osorno, para poder controlar que no queden poquitos de tela sobrantes de la 
//liberacion.
//en este punto se debe establecer el % de utilizacion de la ficha y del trazo, si el del trazo es mayor, 
//es que se pueden generar mas unidades con la misma tela, pero en la funcion of_restar_aprogramar existe una 
//validaci$$HEX1$$f300$$ENDHEX$$n que no permite que se programen m$$HEX1$$e100$$ENDHEX$$s unidades de las pendientes, por lo que se debe saber cuantas
//unidades de m$$HEX1$$e100$$ENDHEX$$s podrian ser hechas, para sumar estas unidades al total de pendientes y que el sistema
//valide que no se pase de lo pendiente m$$HEX1$$e100$$ENDHEX$$s las unidades de m$$HEX1$$e100$$ENDHEX$$s, si no se pasan el sistema debe sugerir al
//usuario pobrar el trazo con un numero mayor de capas.
//elaborado por jcrm
//fecha junio 9 de 2006

//porcentaje de utilizacion de la ficha
//ldc_porc_util = dw_trazo.GetItemNumber(dw_trazo.GetRow(),'porc_utilizacion')
//porcentaje de utilizacion del trazo seleccionado
//ldc_porc_trazo = This.GetItemNUmber(row,'porc_utili')

//estos dos porcentajes se deben enviar en la funci$$HEX1$$f300$$ENDHEX$$n para con estos poder sumar las unidades de m$$HEX1$$e100$$ENDHEX$$s a las unidades
//pendientes, con esto se permite utilizar toda la tela pero saldran m$$HEX1$$e100$$ENDHEX$$s unidades de las pendientes.

If Row > 0  Then
	This.SetItem(Row,"fe_actualizacion",DateTime(Today(),Now()))
	This.SetItem(Row,"fe_creacion",DateTime(Today(),Now()))
	This.SetItem(Row,"usuario",gstr_info_usuario.codigo_usuario)
	This.SetItem(Row,"instancia",gstr_info_usuario.instancia)
End If
//se debe saber si se trata de una modificacion del dato o si es la primera vez que se esta modificando luego
//del retrieve o del update
ll_capas = This.GetItemNumber(row,'ca_capas')

If of_restar_aprogramar(row,2,ldc_porc_util,ldc_porc_trazo) = 1 Then
	This.setItem(row,'ca_capas',ll_capas)
	of_restar_aprogramar(row,2,ldc_porc_util,ldc_porc_trazo)
	Return 2
End if

This.AcceptText()
If of_restar_aprogramar(row,1,ldc_porc_util,ldc_porc_trazo) = 1 Then
	This.setItem(row,'ca_capas',ll_capas)
	of_restar_aprogramar(row,2,ldc_porc_util,ldc_porc_trazo)
	Return 2
End if
//****************************modificado junio 16 de 2005
ll_capas_optimas = dw_trazo.GetItemNumber(dw_trazo.GetRow(),'capas') / 2

IF ll_capas_optimas < ll_capas Then
	MessageBox('Advertencia','Chequee si los paquetes del trazo son divisibles por 2, si es as$$HEX1$$ed00$$ENDHEX$$, no acepte este trazo.')
End if
//***************************

end event

event retrieveend;call super::retrieveend;//of_calcular_aprogramar()
end event

event doubleclicked;call super::doubleclicked;Long li_result

li_result = MessageBox("Advertencia", 'Esta seguro que desea eliminar la fila', Exclamation!, OKCancel!, 2)

IF li_result = 1 THEN
	of_restar_aprogramar(row,2,1,1)
	This.DeleteRow(row)
END IF

end event

type dw_oc from u_dw_base within w_definir_trazos_recalculo
integer x = 18
integer y = 8
integer width = 1431
integer height = 680
integer taborder = 10
string dataobject = "dtb_poxagrupacion"
boolean vscrollbar = true
end type

event clicked;call super::clicked;Decimal{2} ld_ancho, ld_anchoini
Long li_raya, li_result, li_base
Long ll_fila, li_fila, ll_modelo
dwItemStatus ls_status


//primero se verifica si existen datos en dw_trazos_definidos, si los hay se pregunta
//si se desea grabar dicha informacion.

ll_fila = dw_trazos_definidos.RowCount()

If This.IsSelected(row) Then
Else
	For li_fila = 1 To ll_fila 
		If ll_fila > 0 Then
			ls_status = dw_trazos_definidos.GetItemStatus(li_fila, 0, Primary!)
			IF ls_status = DataModified! Or ls_status = NewModified! THEN
				li_result = MessageBox("Advertencia", 'Desea Grabar los cambios realizados', Exclamation!, OKCancel!, 2)
				IF li_result = 1 THEN
					TriggerEvent('ue_grabar')
				END IF	
			End if
		End if
	Next
End if

This.SelectRow(0,False)

If Row <= 0 Then Return

If isnull(Row) Then Row = 1

If This.IsSelected(row) Then
	
	This.SelectRow(Row,False)
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
	
	is_po = This.GetItemString(row,'po')
	il_color = This.GetItemNumber(row,'co_color_pt')
	ii_pdn = This.GetItemNumber(row,'cs_pdn')
	il_ordenpd = This.getItemNumber(row,'cs_ordenpd_pt')
	
	Of_Cuadro(dw_trazo.GetRow())
	
	li_raya = dw_trazo.GetItemNumber(dw_trazo.GetRow(), "raya") 
	
	dw_trazos_definidos.Retrieve(il_agrupa, li_raya,ii_pdn)
	
	li_base = dw_trazo.GetItemNumber(dw_trazo.GetRow(),'cs_base_trazos')
	ld_ancho = dw_pdn_talla.GetItemNumber(dw_pdn_talla.GetRow(), "ancho_cortable") / 100
	//Javier Garcia dice que esto no puede estar. que tiene que ser el mismo ancho
	//jorodrig mayo 6 -2010
//	ld_anchoini = ld_ancho - 0.01	
	ld_anchoini = ld_ancho - 0.00
	
	
	IF of_consultar_trazos(il_agrupa, li_base, ld_ancho, ld_anchoini) = 1 THEN
		dw_produccion.Retrieve(gstr_info_usuario.codigo_usuario)
	END IF
End if
end event

event retrieveend;call super::retrieveend;Long li_raya, li_raya2
Long ll_fila

//ahorra el visto bueno solo debe a parecer cuando las unidades porgramadas esten dentro del 
//rango del 5% mas o menos de las unidades liberadas.

//********************inicio de la modificacion
//This.TriggerEvent(Clicked!)
//*********************fin de la modificacion


//***************************asi estaba inicialmente
For ll_fila = 1 To dw_trazo.RowCount()
	If dw_trazo.IsSelected(ll_fila) Then
		li_raya = dw_trazo.GetItemNumber(ll_fila,'raya')
		Exit
	End If
Next


For ll_fila = 1 To This.RowCount()
	li_raya2 = This.GetItemNumber(ll_fila,'raya')
	If li_raya = li_raya2 Then
		This.SetItem(ll_fila,'raya',1)
		This.SelectRow(ll_fila,True)
	Else
		This.SetItem(ll_fila,'raya',0)
	End if
Next

This.TriggerEvent(Clicked!)
end event

type dw_pdn_talla from u_dw_base within w_definir_trazos_recalculo
integer x = 1481
integer y = 8
integer width = 2144
integer height = 680
integer taborder = 20
string dataobject = "d_cuadro_pdn_x_tallas_seleccion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;
Return 1
end event

type dw_produccion from u_dw_base within w_definir_trazos_recalculo
integer x = 14
integer y = 1212
integer width = 1641
integer height = 740
integer taborder = 40
string dataobject = "d_lista_trazos_tallasxtrazo_definicion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If Row <= 0 Then Return
//
//If This.IsSelected(Row) Then
//	This.SelectRow(Row, False)
//Else
//	This.SelectRow(Row,True)
//End If


end event

event doubleclicked;call super::doubleclicked;Long li_raya, li_fila,li_raya2
Long ll_agrupacion, ll_fila, ll_trazo, ll_trazo2
Decimal{0} ldc_porc_util, ldc_porc, ldc_porc_trazo, ldc_porc_resta, ldc_porc_suma
String ls_password, ls_password_ingresado
n_cts_constantes_corte lpo_const_corte
s_base_parametros lstr_parametros

If Row <= 0 Then Return
li_fila = This.GetRow()
ll_trazo = This.GetItemNumber(li_fila,'co_trazo')

If of_validar_trazo(ll_trazo) = 0 Then
	li_fila = This.GetRow()
	
	If li_fila > 0 Then
		//se realizo la validacion del trazo ahora se verifica que el trazo este dentro del porcentaje
		//permitido
		//traigo el porcentaje de utilizacion de la ficha
		ldc_porc_util = dw_trazo.GetItemNumber(dw_trazo.GetRow(),'porc_utilizacion')
		
		//debo conocer cual es el porcentaje de tolerancia permitido para la fabrica que se esta trabajando
		IF gstr_info_usuario.co_planta_pro = 2 THEN		
			ldc_porc = lpo_const_corte.of_consultar_numerico('PORC UTILIZACION TRAZO')
		ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
			ldc_porc = lpo_const_corte.of_consultar_numerico('PORC UTILIZACION TRAZO NICOLE')
		END IF
		
		If ldc_porc = -1 Then
			ldc_porc = 0 
		End if
		
		//debo conocer el porcentaje de utilizacion del trazo seleccionado
		ldc_porc_trazo = This.GetItemNUmber(li_fila,'porc_utili')
		if isnull(ldc_porc_trazo) Then ldc_porc_trazo = 0
		//si el poecentaje de utilizacion es menor al de la ficha hasta en un 2%, se debe restringuir el uso
		//para un usuario calificado.
		
		ldc_porc_resta = ldc_porc_util - ldc_porc
		
		ldc_porc_suma = ldc_porc_util + ldc_porc
		
		If (ldc_porc_trazo < ldc_porc_resta) OR (ldc_porc_trazo > ldc_porc_suma) Then
			//mensage de utilizacion del trazo, no de be ser usado sin autorizaci$$HEX1$$f300$$ENDHEX$$n superior.
			MessageBox('Advertencia','Trazo por debajo del porcentaje de la ficha, necesita autorizaci$$HEX1$$f300$$ENDHEX$$n para programarlo.')
			IF gstr_info_usuario.co_planta_pro = 2 THEN
				ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO'))
			ELSEIF gstr_info_usuario.co_planta_pro = 99 THEN
				ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO'))
			END IF
			
			//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
			Open(w_password_trazos)
			lstr_parametros = message.PowerObjectParm
			
			If lstr_parametros.hay_parametros = true Then
				ls_password_ingresado = Trim(lstr_parametros.cadena[1])
							
				If ls_password_ingresado = ls_password Then
				Else
					MessageBox('Error','Password, no valido.')
					Return
				End if
			Else
				Return
			End if
		Else
			//se permite el uso del trazo.
		End if
		
		//se cargan los datos de la dw_trazos_definidos
		of_cargar_trazos_recalculo(li_fila)
	End if
End if













	
end event

type dw_trazo from u_dw_base within w_definir_trazos_recalculo
integer x = 14
integer y = 688
integer width = 2811
integer height = 512
integer taborder = 30
string dataobject = "d_lista_base_rayasxbase_v2"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;Long ll_trazo
Long li_raya
Decimal{2} ld_ancho, ld_anchoini

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

ib_tzbs = False

//li_raya = This.GetItemNumber(row,'raya')
//
//dw_oc.Retrieve(il_agrupa,li_raya)
//
dw_produccion.Reset()
dw_trazos_definidos.Reset()
dw_pdn_talla.Reset()







	

end event

event rowfocuschanged;call super::rowfocuschanged;Long li_raya, li_base, li_fabrica, li_linea
Long ll_modelo, ll_referencia
Decimal{2} ld_ancho, ld_anchoini

This.SelectRow(0,False)

If isnull(currentrow) Then currentrow = 1
This.SelectRow(currentrow,True)

If currentrow > 0 Then
	li_raya = This.GetItemNumber(currentrow,'raya')
	ll_modelo = This.GetItemNumber(CurrentRow,'co_modelo')
	li_fabrica = This.GetItemNumber(CurrentRow,'co_fabrica')
	li_linea = This.GetItemNumber(CurrentRow,'co_linea')
	ll_referencia = This.GetItemNumber(CurrentRow,'co_referencia')
	dw_oc.Retrieve(il_agrupa, li_raya)
	dw_partes.Retrieve(ll_modelo,li_fabrica,li_linea,ll_referencia)
	//se deben filtrar los datos de los trazos para que solo salgan los que estan en el rango del porcentaje
	//de utilizaci$$HEX1$$f300$$ENDHEX$$n y adem$$HEX1$$e100$$ENDHEX$$s sean de la raya que se esta trabajando
	of_filtrar_trazos(currentRow)
	
	
//	li_base = This.GetItemNumber(currentrow,'cs_base_trazos')
//	ld_ancho = dw_pdn_talla.GetItemNumber(dw_pdn_talla.GetRow(), "ancho_cortable") / 100
//	ld_anchoini = ld_ancho - 0.01
//	
//	IF of_consultar_trazos(il_agrupa, li_base, ld_ancho, ld_anchoini) = 1 THEN
//		dw_produccion.Retrieve(gstr_info_usuario.codigo_usuario)
//	END IF
End if
end event

