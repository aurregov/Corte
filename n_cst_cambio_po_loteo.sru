HA$PBExportHeader$n_cst_cambio_po_loteo.sru
forward
global type n_cst_cambio_po_loteo from nonvisualobject
end type
end forward

global type n_cst_cambio_po_loteo from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_encontrar_po_cambio (string as_po, string as_recipiente, ref uo_dsbase ads_pos_x_pomaster)
public function long of_cambiar_po_loteo (string as_recipiente, string as_po_origen)
public function long of_cambiar_po_antes_loteo (string as_bolsa, string as_bongo, long al_pedido_destino, long al_cantidad, ref string as_bolsa_nueva)
public function long of_crear_bolsa ()
end prototypes

public function long of_encontrar_po_cambio (string as_po, string as_recipiente, ref uo_dsbase ads_pos_x_pomaster);/*	----------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para verificar si a la Po a la que se le esta haciendo el loteo es la m$$HEX1$$e100$$ENDHEX$$s
	proxima a ser despachada, si la Po no es, la funci$$HEX1$$f300$$ENDHEX$$n obtiene la Po correcta.
	La funci$$HEX1$$f300$$ENDHEX$$n obtiene todas las PO que tengan la misma PO master igual a as_po y 
	verifica si esa Po es la de la fecha de entrega mas proxima, sino es, busca las POs-SKU
	destino
	----------------------------------------------------------------------------------	*/

	
uo_dsbase lds_hallar_po_master	
Long ll_ret, ll_i, ll_cliente, ll_fabrica, ll_linea, ll_referencia, ll_talla, ll_color, & 
		ll_ca_numerada_origen, ll_ret_grupo, ll_grupos_cambio[], ll_ret_find, ll_ca_faltante, &
		ll_ca_asignar, ll_ca_asignada, ll_ca_actual, ll_ca_cambiar, ll_ret_find_origen, &
		ll_ca_numerada, ll_m, ll_cs_grupo
Boolean lb_encontro_po = False
String ls_po_master, ls_po_canasta, ls_expresion, ls_expresion_referencias 
n_cst_canasta lnvo_canasta
uo_dsbase lds_h_canasta, lds_dt_canasta, lds_obtener_grupo_cambio//, lds_obtener_referencias_cambio
Datetime ldtm_fecha_servidor	

//Datos pruebas
//String ls_referencia1 ='106825' , ls_referencia2 ='5040', ls_referencia3 = '5110'
//LONG ll_cliente_cambio = 5160

//Datos producci$$HEX1$$f300$$ENDHEX$$n
//String ls_referencia1 ='009800' , ls_referencia2 ='009811', ls_referencia3 = '009811'
//LONG ll_cliente_cambio = 9991






//Verificamos si a alguna referencia de la canasta se le puede hacer cambio de PO
lds_obtener_grupo_cambio = Create uo_dsbase
lds_obtener_grupo_cambio.DataObject = 'd_gr_hallar_grupo_cambio_referencia_com'
lds_obtener_grupo_cambio.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

ll_ret_grupo = lds_obtener_grupo_cambio.Of_retrieve(as_recipiente) 
IF ll_ret_grupo < 0 Then
	Rollback;
	MessageBox("Error","Error al consultar los grupos de referencias para el cambio de po. Por favor informe a Sistemas",Stopsign!)
	Return -1
Elseif ll_ret_grupo = 0 Then
	//Si la referencia no se encuentra en la tabla dt_grupo_cambio_referencia es porque no se le debe de hacer cambio de referencia
	Return 0
Else	
	//si hay se puede hacer cambio de PO , obtenemos los grupos de referencias entre las cuales se puede hacer el cambio
	
	For ll_m = 1 To lds_obtener_grupo_cambio.RowCount()
		ll_grupos_cambio[UpperBound(ll_grupos_cambio) + 1] = lds_obtener_grupo_cambio.GetItemNumber(ll_m,'cs_grupo') 	
	Next
	
End IF


ldtm_fecha_servidor = f_fecha_servidor()

//Hallamos la PO master
lds_hallar_po_master = Create uo_dsbase
lds_hallar_po_master.DataObject = 'd_gr_hallar_po_master_com'
lds_hallar_po_master.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

If lds_hallar_po_master.Of_Retrieve(as_po) <= 0 Then
	Rollback;
	MessageBox("Error","Error obteniendo la PO Master para la Po "+Trim(as_po)+". Por favor Informe a Sistemas",StopSign!)
	Return -1
End IF	

ls_po_master = Trim(lds_hallar_po_master.GetItemString(1,'po_master'))


//Cargamos el recipiente
lds_dt_canasta = Create uo_dsbase
lds_dt_canasta.DataObject = 'd_gr_detalle_canasta_x_ref_com'
lds_dt_canasta.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

	
IF lds_dt_canasta.Of_Retrieve(as_recipiente) <=0 Then
	Rollback;
	MessageBox("Error","Error cargando el recipiente "+as_recipiente+" para hacerle cambio de PO. Por favor informe a sistemas ",StopSign!)
	Return -1
End IF


//Validamos la Po master
IF IsNull(ls_po_master) Or len(Trim(ls_po_master)) <= 0 Then
	
	Rollback;
	MessageBox("Error","Se est$$HEX2$$e1002000$$ENDHEX$$intentado hacer un cambio de PO al recipiente "+Trim(as_recipiente)+" PO "+Trim(as_po)+". Pero la PO Master no tiene valor. Para poder hacer un cambio de Po de esta referencia debe definir la PO master al pedido. Por favor consulte con Ingenieria")
	Return -1
			
End IF


//Consultamos las PO que tengan la misma Po master y el grupo de referencias entre las que se puede hacer el cambio de PO
ads_pos_x_pomaster = Create uo_dsbase
ads_pos_x_pomaster.DataObject = 'd_gr_po_x_po_master_com'
ads_pos_x_pomaster.SetTransObject(SQLCA)

ll_ret = ads_pos_x_pomaster.Of_Retrieve(ls_po_master, ll_grupos_cambio) 

//si ocurre alg$$HEX1$$fa00$$ENDHEX$$n error
If ll_ret <= 0 Then
	Rollback;
	MessageBox("Error","Error al consultar las PO pertenecientes a la PO master "+ls_po_master+" Cliente "+String(ll_cliente)+". Por favor Informe a Sistemas",StopSign!)
	Return -1
	
//Si trae no mas un registro es porque no encontro m$$HEX1$$e100$$ENDHEX$$s Po con la Po master	
Elseif ll_ret = 1 Then
	//si solamente retorna 1, no tendr$$HEX1$$ed00$$ENDHEX$$a otra referencia a la cual hacer el cambio
	Return 0	
End IF


//Ordenamos las PO's por fecha de entrega
ads_pos_x_pomaster.SetSort("fe_entrega A")
ads_pos_x_pomaster.Sort()


//Recorremos los detalles de la canastas, buscando la Po, referencia y cantidad a la que le vamos a hacer cambio de PO
For ll_i = 1 To lds_dt_canasta.RowCount()
	
	//Obtenemos los datos del registro de la canasta
	ll_fabrica 		=	lds_dt_canasta.GetItemNumber(ll_i,'co_fabrica_ref')
	ll_linea 		=	lds_dt_canasta.GetItemNumber(ll_i,'co_linea')
	ll_referencia 	=	lds_dt_canasta.GetItemNumber(ll_i,'co_referencia')
	ll_talla 		=	lds_dt_canasta.GetItemNumber(ll_i,'co_talla')
	ll_color			=	lds_dt_canasta.GetItemNumber(ll_i,'co_color')
	ls_po_canasta	=	Trim(lds_dt_canasta.GetItemString(ll_i,'po'))
	ll_ca_actual	= 	lds_dt_canasta.GetItemNumber(ll_i,'ca_actual')
	ll_cs_grupo		=	lds_dt_canasta.GetItemNumber(ll_i,'cs_grupo')
	
	
	//Si la po de la canasta es diferente a la que se esta loteando no hacemos cambio de po
	if ls_po_canasta <> trim(as_po) Then continue
	
	//Armanos la expresi$$HEX1$$f300$$ENDHEX$$n para buscar el detalle de la Po que coincida con la PO-SKU actual, para esto incluimos la referencia y la Po en la expresi$$HEX1$$f300$$ENDHEX$$n
	ls_expresion ="co_fabrica = "+String(ll_fabrica)+" and co_linea = "+String(ll_linea)+" and co_talla = "+ &
					 String(ll_talla)+" and co_color = "+String(ll_color)+" and nu_orden ='"+Trim(ls_po_canasta)+"' and co_referencia = "+String(ll_referencia)
	

	//Hacemos la busqueda para Obtener la ca_numerada de la PO-SKU
	ll_ret_find_origen = ads_pos_x_pomaster.Find(ls_expresion, 1, ads_pos_x_pomaster.RowCount() + 1)
	
	IF ll_ret_find_origen < 0 Then
		Rollback;
		MessageBox("Error","Error obteniendo la cantidad numerada para el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda: "+ls_expresion,StopSign!)
		Return -1
	Elseif ll_ret_find_origen = 0 Then
		//SI no encuentra es un error, porque la Po-SKU debe de existir
		Rollback;
		MessageBox("Error","No se pudo obtener la cantidad numerada para el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda: "+ls_expresion,StopSign!)
		Return -1
	End IF
	
	
	//Tomamos la ca_numerada de la Po-SKu
	ll_ca_numerada_origen	= 	ads_pos_x_pomaster.GetItemNumber(ll_ret_find_origen,'ca_numerada')
	
	//Colocamos la cantidad n$$HEX1$$fa00$$ENDHEX$$merada en 0
	ads_pos_x_pomaster.SetItem(ll_ret_find_origen,'ca_numerada',0)
	
	
	ll_ret_find = 0
	
	//Mientras no se halla asignado toda la cantidad
	Do While ll_ca_numerada_origen > 0  

		//Obtenemos la cantidad que ya determinamos que va a hacer cambio de PO en el detalle de la canasta
		//ll_ca_cambiar = lds_dt_canasta.GetItemNumber(ll_i,'ca_cambio')

		/*
			Aqui validamos que el cambio de PO no sobrepase las unidades del detalle de la canasta.
			Si todav$$HEX1$$ed00$$ENDHEX$$a tenemos unidades sin asignarle un cambio de Po, debemos hacer la busqueda a cual
			po iria, sino dejamos las unidades donde est$$HEX1$$e100$$ENDHEX$$n
		*/
		//IF ll_ca_cambiar < ll_ca_actual Then
		IF ll_ca_actual > 0 Then
		
			//Se arma la expresion de busqueda cs_grupo, talla, color y cantidad faltante por asignar a la po-sku
			ls_expresion =  "ca_faltante > 0 and co_talla = "+ String(ll_talla)+" and co_color = "+String(ll_color)+ " and cs_grupo = "+String(ll_cs_grupo)
	
			//Buscamos la PO-Referencia con menor fecha de entrega y que le falte unidades por asignar
			ll_ret_find = ads_pos_x_pomaster.Find(ls_expresion, ll_ret_find + 1, ads_pos_x_pomaster.RowCount() + 1)

	
		Else
			
			//Colocamos la variable en cero para que entre al bloque de c$$HEX1$$f300$$ENDHEX$$digo donde deje la cantidad restante en la PO actual
			ll_ret_find = 0
			
		End IF
		
		
		
		//Si ocurre un error buscando
		If ll_ret_find < 0 Then
			Rollback;
			MessageBox("Error","Error al obtener la PO-SKU para el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda: "+ls_expresion,StopSign!)
			Return -1
			
		//Si no encontramos m$$HEX1$$e100$$ENDHEX$$s PO-sku donde asignar y todavia falta cantidad por asignar	
		Elseif ll_ret_find = 0 Then
			
			/*Ac$$HEX2$$e1002000$$ENDHEX$$entra si la cantidad en la canasta es mayor a la cantidad pedida de la PO-SKU, en este
			caso dejamos la cantidad restante en la Po-SKU que se encuentra actualmente*/
			
			//Armanos la expresi$$HEX1$$f300$$ENDHEX$$n para buscar el detalle de la Po que coincida con la PO-SKU actual, para esto incluimos la referencia y la Po en la expresi$$HEX1$$f300$$ENDHEX$$n
			ls_expresion ="co_fabrica = "+String(ll_fabrica)+" and co_linea = "+String(ll_linea)+" and co_talla = "+ &
							 String(ll_talla)+" and co_color = "+String(ll_color)+" and nu_orden ='"+Trim(ls_po_canasta)+"' and co_referencia = "+String(ll_referencia)
			
			//Hacemos la busqueda para asignar toda la cantidad actual a la PO
			ll_ret_find = ads_pos_x_pomaster.Find(ls_expresion, 1, ads_pos_x_pomaster.RowCount() + 1)
			
			IF ll_ret_find < 0 Then
				Rollback;
				MessageBox("Error","Error al buscar la PO-SKU para el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda: "+ls_expresion,StopSign!)
				Return -1
			Elseif ll_ret_find = 0 Then
				//SI no encuentra es un error, porque la Po-SKU debe de existir
				Rollback;
				MessageBox("Error","Error al obtener la PO-SKU para el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda: "+ls_expresion,StopSign!)
				Return -1
			End IF
			
			//Sumamos lo que qued$$HEX2$$f3002000$$ENDHEX$$de la cantidad actual a la cantidad asignada
			ll_ca_asignada = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_asignada')
			//ll_ca_asignada = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_numerada')
			ll_ca_asignada = ll_ca_asignada + ll_ca_numerada_origen
			
//			ll_ca_numerada = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_numerada')
//			ll_ca_numerada = ll_ca_numerada + ll_ca_asignada
			
			ll_ca_numerada_origen = 0
			
			ads_pos_x_pomaster.SetItem(ll_ret_find,'ca_asignada', 0)
			//ads_pos_x_pomaster.SetItem(ll_ret_find,'ca_numerada', ll_ca_asignada)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'ca_numerada', ll_ca_asignada)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'usuario', gstr_info_usuario.codigo_usuario)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'instancia', gstr_info_usuario.instancia)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'fe_actualizacion', ldtm_fecha_servidor)

			
		//Encontramos la Po-Sku con menor fecha que a$$HEX1$$fa00$$ENDHEX$$n no se le a asignado ca_numerada				
		Else
			
			//Obtenemos la cantidad que falta por asignar y la que ya se ha asignado
			ll_ca_faltante = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_faltante')
			ll_ca_asignada = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_asignada')
			//ll_ca_asignada = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_numerada')
			ll_ca_numerada = ads_pos_x_pomaster.GetItemNumber(ll_ret_find,'ca_numerada')
			
			//Solo podemos hacer el cambio de PO m$$HEX1$$e100$$ENDHEX$$ximo por la cantidad actual de la canasta, esta validacion solamente aplica
			//cuando el destino es diferente al origen, es decir, cuando se va a hacer cambio de PO
			IF ll_ca_actual < ll_ca_numerada_origen And (ll_ret_find_origen <> ll_ret_find) Then
				If ll_ca_actual <= ll_ca_faltante Then
					ll_ca_asignar = ll_ca_actual
					ll_ca_numerada_origen = ll_ca_numerada_origen - ll_ca_actual
				Else
					ll_ca_asignar = ll_ca_faltante
					ll_ca_numerada_origen = ll_ca_numerada_origen - ll_ca_faltante
				End IF
			Else
				//Si lo que falta por asignar es menor o igual a lo hay para asignar, lo asignamos todo a esa Po-SKU
				IF ll_ca_numerada_origen <= ll_ca_faltante Then
					ll_ca_asignar	= 	ll_ca_numerada_origen
					ll_ca_numerada_origen = 0
				
				//Si lo pedido es menor que lo que hay para asignar, debemos asignar lo que quepa y asignar lo otro a otra po-sku
				Else
					ll_ca_asignar =  ll_ca_faltante
					ll_ca_numerada_origen = ll_ca_numerada_origen - ll_ca_faltante
				End IF
			End IF	
			
			//Ponemos la cantidad asignada en la PO-Sku			
			ll_ca_asignada = ll_ca_asignada + ll_ca_asignar
			ll_ca_numerada = ll_ca_numerada + ll_ca_asignar
			ads_pos_x_pomaster.SetItem(ll_ret_find,'ca_asignada', ll_ca_asignada)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'ca_numerada', ll_ca_numerada)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'po_origen', ls_po_canasta)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'co_fabrica_origen', ll_fabrica)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'co_linea_origen', ll_linea)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'co_referencia_origen', ll_referencia)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'usuario', gstr_info_usuario.codigo_usuario)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'instancia', gstr_info_usuario.instancia)
			ads_pos_x_pomaster.SetItem(ll_ret_find,'fe_actualizacion', ldtm_fecha_servidor)

			//Si el destino es diferente es porque las unidades de la canastas ya quedan asiganadas a otra po-sku
			IF (ll_ret_find_origen <> ll_ret_find) Then
				//lds_dt_canasta.SetItem(ll_i,'ca_cambio',ll_ca_cambiar+ll_ca_asignar)
				ll_ca_actual = ll_ca_actual - ll_ca_asignar
			Else
				//ll_ca_actual
				//lds_dt_canasta.SetItem(ll_i,'ca_cambio',ll_ca_cambiar)
			ENd IF
			
		End IF
		
	Loop
	
Next



//Verificamos si qued$$HEX2$$f3002000$$ENDHEX$$alguna cantidad asignada a Otra PO-SKU 
ads_pos_x_pomaster.SetFilter("nu_orden <> '"+Trim(as_po)+"' and ca_asignada > 0")
ads_pos_x_pomaster.Filter()


//en ese caso es que hay que hacer cambio de PO
IF ads_pos_x_pomaster.RowCount() > 0 Then
	
//	//Descartamos los detalles a los que no se les va a hacer cambio de Po
//	ads_pos_x_pomaster.RowsDiscard(1, ads_pos_x_pomaster.FilteredCount(), FIlter! )
	ads_pos_x_pomaster.SetFilter('')
	ads_pos_x_pomaster.Filter()
	Return 1

Else
	Return 0
End IF


end function

public function long of_cambiar_po_loteo (string as_recipiente, string as_po_origen);/*	----------------------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para hacer el cambio de PO desde el loteo. Primero se hace el llamado a la funci$$HEX1$$f300$$ENDHEX$$n
	"of_encontrar_po_cambio" que nos indica si al recipiente se le debe de hacer cambio de Po, y no
	llena el datastore lds_cambio_referencia con las PO-SKU a las que debemos cambiar, luego hacemos
	el recorrido por cada Po que se vaya a cambiar y vamos invocando la funcionalidad de cambio de PO
	---------------------------------------------------------------------------------------------- */



Long ll_ret, ll_i, ll_j, ll_k, ll_ret_canasta, ll_ret_find, ll_ca_numerada_actual, ll_ca_asignada, &
	  ll_fabrica, ll_linea, ll_referencia, ll_talla, ll_color, ll_ca_cambiar, ll_referencia_origen, &
	  ll_pedido, ll_n, ll_ca_actual, ll_fabrica_origen, ll_linea_origen, ll_pedido_cambiar
uo_dsbase lds_cambio_referencia, lds_dt_canasta, lds_info_cambio_po
String ls_pos[], ls_po_actual, ls_po_anterior, ls_po_cambiar, ls_expresion, ls_po_origen
n_cst_cambios_po lnvo_cambio_po

Long					ll_sw_loteo_agrupado
n_cts_constantes lnvo_constantes


// FACL - 2020/09/14 - SA60509 - Se anula funcionalidad temporalmente
// 2020/09/15 - SA60509 - Se vuelve a activar
///Return 1

// FACL - 2020/09/18 - SA60509 - Se activa la funcionalidad de cambio de po por constante
lnvo_constantes = Create n_cts_constantes
ll_sw_loteo_agrupado = lnvo_constantes.of_Consultar_Numerico( 'SW_LOTEO_AGRUPADO' )
Destroy lnvo_constantes
IF ll_sw_loteo_agrupado < 0 THEN
	MessageBox('Error','Ocurrio un error al consultar la contante SW_LOTEO_AGRUPADO!',StopSign!)
	Return -1
ElseIf ll_sw_loteo_agrupado <> 1 Then
	Return 0
END IF


// ************* SA60509 - cambio de PO por agrupacion de pedido  ************

//Instanciamos el detalle de la canasta, este es el datawindow con el que le indicamos al objeto de
//cambios de Po a que detalles de la canasta y que cantidad le va a hacer el cambio
lds_dt_canasta = Create uo_dsbase
lds_dt_canasta.DataObject = 'd_gr_detalle_canasta_com'
lds_dt_canasta.SetTransObject(SQLCA)

lnvo_cambio_po.of_set_programa("CPL")
lnvo_cambio_po.ii_cambio = 3

// FACL - 2020/08/10 - SA60509 - Se determina si debe realiza cambio de PO por agrupacion de pedido
lds_info_cambio_po = Create uo_dsbase
lds_info_cambio_po.DataObject = 'd_gr_canasta_x_cambio_po_agrupada'
lds_info_cambio_po.SetTransObject(SQLCA)

ll_ret_canasta = lds_info_cambio_po.Of_Retrieve(as_recipiente)
If ll_ret_canasta < 0 Then
	Rollback;
	MessageBox("Error","Error Consultando la informacion del recipiente "+as_recipiente+" para realizar cambio de PO. Por favor informe a Sistemas",StopSign!)
	Return -1
End IF

If ll_ret_canasta > 0 Then
	// Si tiene agrupacion por PO y se separa despues del Loteo ( tipo_agrupacion >2 )
	lds_info_cambio_po.SetFilter('pedido_agrupa>0 And tipo_agrupacion >2')
	lds_info_cambio_po.Filter()
	
	If lds_info_cambio_po.RowCount() > 0 Then
		ll_ret_canasta = lds_dt_canasta.Of_Retrieve(as_recipiente)
		If ll_ret_canasta <= 0 Then
			Rollback;
			MessageBox("Error","Error Consultando el recipiente "+as_recipiente+" para realizar cambio de PO. Por favor informe a Sistemas",StopSign!)
			Return -1
		End IF
		
		For ll_i = 1 To lds_info_cambio_po.RowCount()
			ll_pedido = lds_info_cambio_po.GetItemNumber( ll_i, 'pedido' )
			ll_fabrica = lds_info_cambio_po.GetItemNumber( ll_i, 'co_fabrica_ref' )
			ll_linea = lds_info_cambio_po.GetItemNumber( ll_i, 'co_linea' )
			ll_referencia = lds_info_cambio_po.GetItemNumber( ll_i, 'co_referencia' )
			ll_talla = lds_info_cambio_po.GetItemNumber( ll_i, 'co_talla' )
			ll_color = lds_info_cambio_po.GetItemNumber( ll_i, 'co_color' )
			ll_pedido_cambiar = lds_info_cambio_po.GetItemNumber( ll_i, 'pedido_agrupa' )
			ls_po_cambiar = Trim(lds_info_cambio_po.GetItemString( ll_i, 'po_agrupada' ) )
			//armamos la expresi$$HEX1$$f300$$ENDHEX$$n para filtrar los detalles que coincidan con la po origen
			ls_expresion ="pedido =  " + String(ll_pedido) + &
				+ " and co_fabrica_ref = "+String(ll_fabrica)+" and co_linea = "+String(ll_linea)+" and co_referencia = "+String(ll_referencia)&
				+" and co_talla = "+  String(ll_talla)+" and co_color = "+String(ll_color)
		
			//Filtramos los detalles que coincidan con la referencias a la que le vamos a hacer el cambio
			lds_dt_canasta.SetFilter(ls_expresion)
			lds_dt_canasta.Filter()
				
			IF lds_dt_canasta.RowCount() <= 0 Then
				Rollback;
				MessageBox("Error","No se encontr$$HEX2$$f3002000$$ENDHEX$$la PO-SKU a la que se le va a realizar el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda : "+ls_expresion,StopSign!)
				Return -1
			End IF
			//Recorremos todos los detalles a los que les vamos a hacer el cambio
			For ll_n = 1 To lds_dt_canasta.RowCount()		
				ll_ca_actual = lds_dt_canasta.GetItemNumber(ll_n,'ca_actual')	
				If ll_ca_actual > 0 Then
					//Colocamos los datos para el cambio de PO
					lds_dt_canasta.SetItem(ll_n,'po', ls_po_cambiar)
					lds_dt_canasta.SetItem(ll_n,'pedido', ll_pedido_cambiar)
					lds_dt_canasta.SetItem(ll_n,'c_pedido', 1)
					lds_dt_canasta.SetItem(ll_n,'c_po', 1)
					lds_dt_canasta.SetItem(ll_n,'c_referencia', 1)
					lds_dt_canasta.SetItem(ll_n,'c_cantidad', 1)
				End If
			Next
		Next
		If lds_dt_canasta.ModifiedCount() > 0 Then
			//Invocamos el cambio de PO
			lnvo_cambio_po.il_fabrica_loteo = 2
			IF lnvo_cambio_po.of_cambio_ref_parcial(as_recipiente, lds_dt_canasta, 505 ,0 ) < 0 Then
				Rollback;
				MessageBox("Error","Error al hacer cambio de recipiente "+Trim(as_recipiente)+". Por favor intente de nuevo, si el problema continua informe a Sistemas. ",StopSign!)
				Return -1
			Else
				MessageBox('Revisar',' cambio de PO recipiente '+Trim(as_recipiente))
				ROLLBACK;
				Return 1
			End If
		End If
		Return 1
	End If
End If
	
					





// ************* Fin SA60509 - cambio de PO por agrupacion de pedido  ************



ll_ret = This.of_encontrar_po_cambio(Trim(as_po_origen),as_recipiente, lds_cambio_referencia)

IF ll_ret = -1 Then
	Return -1
Elseif ll_ret = 0 Then
	//Si el retorno es cero es porque no hay que hacer cambio de PO
	Return 0
End IF


//Si no retorno 0 ni -1 es porque hay que hacer cambio de PO, en ese caso el datastore que se envi$$HEX2$$f3002000$$ENDHEX$$por parametro, tendr$$HEX2$$e1002000$$ENDHEX$$las PO SKU a las que se les va a hacer el cambio con sus respectivas cantidades

ls_po_anterior ='-1'
lds_cambio_referencia.SetSort("nu_orden")
lds_cambio_referencia.Sort()
//recorremos los detalles a los que se les va a hacer el cambio para determinar las PO, adem$$HEX1$$e100$$ENDHEX$$s determinamos la cantidad n$$HEX1$$fa00$$ENDHEX$$merada que queda
For ll_i = 1 To lds_cambio_referencia.RowCount()
	ls_po_actual = Trim(lds_cambio_referencia.GetItemString(ll_i,'nu_orden'))
	
	//excluimos la PO origen
	IF ls_po_actual <> ls_po_anterior and ls_po_actual <> Trim(as_po_origen) Then
		ls_pos[UpperBound(ls_pos) + 1] = ls_po_actual
	End IF
	
	ls_po_anterior =ls_po_actual  
	
	//Aprovechamos el ciclo para calcular la ca_numerada que queda
	//ll_ca_numerada_actual = lds_cambio_referencia.GetItemNumber(ll_i,'ca_numerada')
	//ll_ca_asignada = lds_cambio_referencia.GetItemNumber(ll_i,'ca_asignada')
	//ll_ca_asignada = 0
	//lds_cambio_referencia.SetItem(ll_i,'ca_numerada',ll_ca_numerada_actual+ll_ca_asignada)
	
Next



//Recorremos las Po destino, para hacer el cambio de PO de cada una
For ll_j = 1 To UpperBound(ls_pos)
	ls_po_cambiar = ls_pos[ll_j]	
	
	//Filtramos los datos que tengan la PO que vamos a Cambiar
	lds_cambio_referencia.SetFilter("nu_orden = '"+ls_po_cambiar+"' and ca_asignada > 0")
	lds_cambio_referencia.Filter()


	
	//recorremos los detalles de la PO que vamos a cambiar
	For ll_k = 1 To lds_cambio_referencia.RowCount()
		
		/*	Obtenemos los datos del detalle de la canasta, hacemos esto por cada uno porque seg$$HEX1$$fa00$$ENDHEX$$n 
			el cambio de PO la canasta va a variar entre cada PO que se actualice
		*/
		lds_dt_canasta.Reset()	
		ll_ret_canasta = lds_dt_canasta.Of_Retrieve(as_recipiente)
		iF ll_ret_canasta <= 0 Then
			Rollback;
			MessageBox("Error","Error Consultando el recipiente "+as_recipiente+" para realizar cambio de PO. Por favor informe a Sistemas",StopSign!)
			Return -1
		End IF
		
		
	
		//Obtenemos los valores con los que vamos a hacer la busqueda
		ll_fabrica 				=	lds_cambio_referencia.GetItemNumber(ll_k,'co_fabrica')
		ll_linea 				=	lds_cambio_referencia.GetItemNumber(ll_k,'co_linea')
		ll_referencia 			=	lds_cambio_referencia.GetItemNumber(ll_k,'co_referencia')
		ll_talla 				=	lds_cambio_referencia.GetItemNumber(ll_k,'co_talla')
		ll_color					=	lds_cambio_referencia.GetItemNumber(ll_k,'co_color')
		ll_ca_cambiar			= 	lds_cambio_referencia.GetItemNumber(ll_k,'ca_asignada')
		ls_po_origen			=	Trim(lds_cambio_referencia.GetItemString(ll_k,'po_origen'))
		ll_fabrica_origen 	=	lds_cambio_referencia.GetItemNumber(ll_k,'co_fabrica_origen')
		ll_linea_origen		= 	lds_cambio_referencia.GetItemNumber(ll_k,'co_linea_origen')
		ll_referencia_origen	=	lds_cambio_referencia.GetItemNumber(ll_k,'co_referencia_origen')		
		ll_pedido				=	lds_cambio_referencia.GetItemNumber(ll_k,'pedido') 

		//armamos la expresi$$HEX1$$f300$$ENDHEX$$n para filtrar los detalles que coincidan con la po origen
		ls_expresion ="co_fabrica_ref = "+String(ll_fabrica_origen)+" and co_linea = "+String(ll_linea_origen)+" and co_talla = "+ &
							 String(ll_talla)+" and co_color = "+String(ll_color)+" and po ='"+Trim(ls_po_origen)+"' and co_referencia = "+String(ll_referencia_origen)
		
		
		//Si hubo alg$$HEX1$$fa00$$ENDHEX$$n cambio
		IF ll_referencia_origen <> ll_referencia Or ls_po_origen <> ls_po_cambiar Or &
			ll_fabrica_origen <> ll_fabrica Or ll_linea_origen <> ll_linea THen		
			
			//Filtramos los detalles que coincidan con la referencias a la que le vamos a hacer el cambio
			lds_dt_canasta.SetFilter(ls_expresion)
			lds_dt_canasta.Filter()
			
			IF lds_dt_canasta.RowCount() <= 0 Then
				Rollback;
				MessageBox("Error","No se encontr$$HEX2$$f3002000$$ENDHEX$$la PO-SKU a la que se le va a realizar el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda : "+ls_expresion,StopSign!)
				Return -1
			End IF
			
			
			//Recorremos todos los detalles a los que les vamos a hacer el cambio
			For ll_n = 1 To lds_dt_canasta.RowCount()
			
					
				ll_ca_actual = lds_dt_canasta.GetItemNumber(ll_n,'ca_actual') 	
				
				//Si la cantidad actual de la canasta es menor que la cantidad a cambiar 
				IF ll_ca_actual < ll_ca_cambiar Then
					lds_dt_canasta.SetItem(ll_n,'ca_nueva', ll_ca_actual)				
					ll_ca_cambiar = ll_ca_cambiar - ll_ca_actual
				Else
					if ll_ca_cambiar = 0 Then
						//Si la cantidad es cero ya asign$$HEX2$$f3002000$$ENDHEX$$toda la cantidad
						exit						
					Else
						lds_dt_canasta.SetItem(ll_n,'ca_nueva', ll_ca_cambiar)				
						ll_ca_cambiar = 0
					End IF
					
				End IF
				
				//Colocamos los datos para el cambio de PO
				lds_dt_canasta.SetItem(ll_n,'co_fabrica', ll_fabrica)
				lds_dt_canasta.SetItem(ll_n,'co_linea', ll_linea)
				lds_dt_canasta.SetItem(ll_n,'co_referencia', ll_referencia)
				lds_dt_canasta.SetItem(ll_n,'po', ls_po_cambiar)
				lds_dt_canasta.SetItem(ll_n,'pedido', ll_pedido)
				lds_dt_canasta.SetItem(ll_n,'c_pedido', 1)
				lds_dt_canasta.SetItem(ll_n,'c_po', 1)
				lds_dt_canasta.SetItem(ll_n,'c_referencia', 1)
				lds_dt_canasta.SetItem(ll_n,'c_cantidad', 1)

					
			Next	
	
			lds_dt_canasta.SetFilter('')
			lds_dt_canasta.Filter()	
	
					
			//Invocamos el cambio de PO
			IF lnvo_cambio_po.of_cambio_ref_parcial(as_recipiente, lds_dt_canasta, 505 ,0 ) < 0 Then
				Rollback;
				MessageBox("Error","Error al hacer cambio de recipiente "+Trim(as_recipiente)+". Por favor intente de nuevo, si el problema continua informe a Sistemas. ",StopSign!)
				Return -1
			End IF
			
		End If
				
		
		
	Next
	
	
Next


lds_cambio_referencia.SetFilter("")
lds_cambio_referencia.FIlter()

//lds_cambio_referencia.SaveAs("c:\camb.xls",excel!,true)
//
//rollback;
//MessageBox("cambio_po","ok")
//return 1


IF lds_cambio_referencia.of_Update() = -1 Then
	Rollback;
	MessageBox("Error","Error al actualizar la ca_numerada en los pedidos. Po origen = "+Trim(as_po_origen)+" .Por favor intente de nuevo, si el problema continua informe a sistemas", StopSign!)
	Return -1
Else
	COMMIT;
	if SQLCA.sqlcode = -1 Then
		ROLLBACK;
		MessageBox("Error","No se actualiz$$HEX2$$f3002000$$ENDHEX$$la PO correctamente. Por favor informe a sistemas",StopSign!)
		Return -1
	End IF
End IF


Return 1


end function

public function long of_cambiar_po_antes_loteo (string as_bolsa, string as_bongo, long al_pedido_destino, long al_cantidad, ref string as_bolsa_nueva);/*	----------------------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para hacer el cambio de PO desde el loteo. Primero se hace el llamado a la funci$$HEX1$$f300$$ENDHEX$$n
	"of_encontrar_po_cambio" que nos indica si al recipiente se le debe de hacer cambio de Po, y no
	llena el datastore lds_cambio_referencia con las PO-SKU a las que debemos cambiar, luego hacemos
	el recorrido por cada Po que se vaya a cambiar y vamos invocando la funcionalidad de cambio de PO
	---------------------------------------------------------------------------------------------- */



Long ll_ret, ll_i, ll_j, ll_k, ll_ret_canasta, ll_ret_find, ll_ca_numerada_actual, ll_ca_asignada, &
	  ll_fabrica, ll_linea, ll_referencia, ll_talla, ll_color, ll_ca_cambiar, ll_referencia_origen, &
	  ll_pedido, ll_n, ll_ca_actual, ll_fabrica_origen, ll_linea_origen, ll_pedido_cambiar, ll_b
uo_dsbase lds_cambio_referencia, lds_dt_canasta, lds_info_cambio_po, lds_dt_lectura_bolsas
String ls_pos[], ls_po_actual, ls_po_anterior, ls_po_cambiar, ls_expresion, ls_po_origen
String ls_bolsa_nueva
Long ll_bolsa, ll_ca_bolsa, ll_ca_bolsa_anterior, ll_filas
n_cst_cambios_po lnvo_cambio_po
DateTime ldt_ahora

Long					ll_sw_loteo_agrupado
n_cts_constantes lnvo_constantes


// FACL - 2020/09/18 - SA60509 - Se activa la funcionalidad de cambio de po por constante
//lnvo_constantes = Create n_cts_constantes
//ll_sw_loteo_agrupado = lnvo_constantes.of_Consultar_Numerico( 'SW_LOTEO_AGRUPADO' )
//Destroy lnvo_constantes
//IF ll_sw_loteo_agrupado < 0 THEN
//	MessageBox('Error','Ocurrio un error al consultar la contante SW_LOTEO_AGRUPADO!',StopSign!)
//	Return -1
//ElseIf ll_sw_loteo_agrupado <> 1 Then
//	Return 0
//END IF


// ************* SA60509 - cambio de PO por agrupacion de pedido  ************


// FACL - 2020/08/10 - SA60509 - Se determina si debe realiza cambio de PO por agrupacion de pedido
lds_info_cambio_po = Create uo_dsbase
lds_info_cambio_po.DataObject = 'd_gr_consulta_bolsa_agrupacion'
lds_info_cambio_po.SetTransObject(SQLCA)

ll_ret_canasta = lds_info_cambio_po.Of_Retrieve( as_bolsa, al_pedido_destino )
If ll_ret_canasta < 0 Then
	Rollback;
	MessageBox("Error","Error Consultando la informacion de la bolsa "+as_bolsa+" para realizar cambio de PO. Por favor informe a Sistemas",StopSign!)
	Destroy lds_info_cambio_po
	Return -1
End IF

If ll_ret_canasta > 0 Then
	// Si tiene agrupacion por PO y se separa despues del Loteo ( tipo_agrupacion >2 )
	lds_info_cambio_po.SetFilter('pedido_agrupa>0 And tipo_agrupacion =2')
	lds_info_cambio_po.Filter()
	
	If lds_info_cambio_po.RowCount() > 0 Then
		//Instanciamos el detalle de la canasta, este es el datawindow con el que le indicamos al objeto de
		//cambios de Po a que detalles de la canasta y que cantidad le va a hacer el cambio
		lds_dt_canasta = Create uo_dsbase
		lds_dt_canasta.DataObject = 'd_gr_detalle_canasta_com'
		lds_dt_canasta.SetTransObject(SQLCA)
		
		lnvo_cambio_po.of_Set_Programa("CPL")
		lnvo_cambio_po.ii_cambio = 3
		
		
		SELECT ca_actual into :ll_ca_bolsa
		 FROM admtelas.dt_canasta_corte  
		 Where cs_canasta = :as_bolsa;		
		
		If ll_ca_bolsa <= al_cantidad Then
			as_bolsa_nueva = ''
		Else
			ldt_ahora = f_fecha_servidor()
			
			ll_bolsa = This.of_Crear_Bolsa()
			If ll_bolsa < 0 Then
				Rollback;
				Return -1
			End If
			ls_bolsa_nueva = String( ll_bolsa )
			
			as_bolsa_nueva = ls_bolsa_nueva
			
			ll_ca_bolsa_anterior = ll_ca_bolsa - al_cantidad
			
			Insert into h_canasta_corte (
					cs_canasta,   
					co_fabrica,   
					co_planta,   
					co_estado,   
					packer_id,   
					fe_estado_date,   
					carton_type,   
					carton_size,   
					peso_bruto,   
					peso_neto,   
					pallet_id,   
					pallet_type,   
					bill_of_lading,   
					remision,   
					camion,   
					co_tipoprod,   
					co_centro_pdn,   
					co_subcentro_pdn,   
					ubicacion_actual,   
					ubicacion_anterior,   
					reason_code,   
					atributo1,   
					atributo2,   
					atributo3,   
					instrucciones_esp1,   
					instrucciones_esp2,   
					instrucciones_esp3,   
					fe_envio,   
					fe_creacion,   
					fe_expiracion,   
					fe_actualizacion,   
					usuario,   
					instancia,   
					ano,   
					mes,   
					co_fabrica_act,   
					co_planta_act,   
					co_centro_act,   
					co_subcentro_act,   
					co_modulo,   
					co_modulo_fis,   
					co_tipo_lectura,   
					co_tipo_produccion,   
					estiba_id,   
					estiba_type,   
					co_tipo_atributo,   
					co_centro_res,   
					co_fabrica_fis,   
					co_planta_fis,   
					co_centro_fis,   
					co_subcentro_fis,   
					cs_solicitud,   
					caja_cliente,   
					bodega,   
					shipping_unit,   
					pre_cube_flag,   
					pares,   
					volumen,   
					cons_caja,   
					manifest_nbr,   
					tracking_nbr,   
					ship_via,   
					verified_flag,   
					corte,   
					co_concepto,   
					carton_tags,   
					ubicacion_emp,   
					s_pares,   
					sw_origen,   
					bodega_destino,   
					ob_ordprod,   
					sw_auditoria,   
					iglu,   
					co_fabrica_pro,   
					co_caja,   
					full_case,   
					co_fabric_pro_des,   
					usu_auditoria,   
					pallet_id_padre,   
					co_fabrica_plan,   
					co_planta_plan,   
					co_centro_plan,   
					co_subcentro_plan,   
					co_modulo_plan,   
					prioridad_plan,   
					fe_asignacion_plan,   
					prioridad_gbi,   
					fe_asignacion_gbi,   
					sw_vip,   
					cs_solicitud_insumos,   
					fe_planta,   
					fe_loteo,   
					fe_subcentro,   
					sw_cerrar_elastico,   
					cs_tanda,   
					cs_secundario,   
					fe_llegada_insumos,   
					co_surtido 
			) 
			SELECT :ls_bolsa_nueva,   
					co_fabrica,   
					co_planta,   
					co_estado,   
					packer_id,   
					fe_estado_date,   
					carton_type,   
					carton_size,   
					peso_bruto,   
					peso_neto,   
					pallet_id,   
					pallet_type,   
					bill_of_lading,   
					remision,   
					camion,   
					co_tipoprod,   
					co_centro_pdn,   
					co_subcentro_pdn,   
					ubicacion_actual,   
					ubicacion_anterior,   
					reason_code,   
					atributo1,   
					atributo2,   
					atributo3,   
					instrucciones_esp1,   
					instrucciones_esp2,   
					instrucciones_esp3,   
					fe_envio,   
					fe_creacion,   
					fe_expiracion,   
					fe_actualizacion,   
					usuario,   
					instancia,   
					ano,   
					mes,   
					co_fabrica_act,   
					co_planta_act,   
					co_centro_act,   
					co_subcentro_act,   
					co_modulo,   
					co_modulo_fis,   
					co_tipo_lectura,   
					co_tipo_produccion,   
					estiba_id,   
					estiba_type,   
					co_tipo_atributo,   
					co_centro_res,   
					co_fabrica_fis,   
					co_planta_fis,   
					co_centro_fis,   
					co_subcentro_fis,   
					cs_solicitud,   
					caja_cliente,   
					bodega,   
					shipping_unit,   
					pre_cube_flag,   
					pares,   
					volumen,   
					cons_caja,   
					manifest_nbr,   
					tracking_nbr,   
					ship_via,   
					verified_flag,   
					corte,   
					co_concepto,   
					carton_tags,   
					ubicacion_emp,   
					s_pares,   
					sw_origen,   
					bodega_destino,   
					ob_ordprod,   
					sw_auditoria,   
					iglu,   
					co_fabrica_pro,   
					co_caja,   
					full_case,   
					co_fabric_pro_des,   
					usu_auditoria,   
					pallet_id_padre,   
					co_fabrica_plan,   
					co_planta_plan,   
					co_centro_plan,   
					co_subcentro_plan,   
					co_modulo_plan,   
					prioridad_plan,   
					fe_asignacion_plan,   
					prioridad_gbi,   
					fe_asignacion_gbi,   
					sw_vip,   
					cs_solicitud_insumos,   
					fe_planta,   
					fe_loteo,   
					fe_subcentro,   
					sw_cerrar_elastico,   
					cs_tanda,   
					cs_secundario,   
					fe_llegada_insumos,   
					co_surtido  
			 FROM admtelas.h_canasta_corte  
			 Where cs_canasta = :as_bolsa;
			 
			ll_i = 1 
			ll_pedido = lds_info_cambio_po.GetItemNumber( ll_i, 'pedido' )
			ll_fabrica = lds_info_cambio_po.GetItemNumber( ll_i, 'co_fabrica_ref' )
			ll_linea = lds_info_cambio_po.GetItemNumber( ll_i, 'co_linea' )
			ll_referencia = lds_info_cambio_po.GetItemNumber( ll_i, 'co_referencia' )
			ll_talla = lds_info_cambio_po.GetItemNumber( ll_i, 'co_talla' )
			ll_color = lds_info_cambio_po.GetItemNumber( ll_i, 'co_color' )
			ll_pedido_cambiar = lds_info_cambio_po.GetItemNumber( ll_i, 'pedido' )
			ls_po_cambiar = Trim(lds_info_cambio_po.GetItemString( ll_i, 'po_sap' ) )
	
			Insert into dt_canasta_corte
			SELECT :ls_bolsa_nueva,   
					:ll_fabrica,   
					:ll_linea,   
					:ll_referencia,   
					:ll_talla,   
					co_calidad,   
					:ll_color,   
					cs_orden_corte,   
					lote,   
					cs_espacio,   
					cs_secuencia,   
					:al_cantidad,   
					:al_cantidad,   
					ca_segundas,   
					ca_reproceso,   
					co_fabrica_modulo,   
					co_planta_modulo,   
					co_modulo,   
					fe_creacion,   
					fe_expiracion,   
					fe_actualizacion,   
					usuario,   
					instancia,   
					sw_leido,   
					sw_cerrados,   
					letra,   
					cs_pdn,   
					cs_agrupacion,   
					:ls_po_cambiar po,   
					nu_cut,   
					lote_prenda,   
					ca_fisico,   
					co_ref_exp,   
					co_talla_exp,   
					co_color_exp,   
					packed_units,   
					packed_boxes,   
					upccode,   
					pares,   
					paquetes,   
					s_pares,   
					tono,   
					dim,   
					:al_pedido_destino,   
					co_prepack,   
					co_grupo_cte,   
					co_fabrica_exp,   
					co_linea_exp,   
					co_bodega,   
					cs_unir_oc,   
					categoria_sap,   
					ca_cortexencima  
			 FROM admtelas.dt_canasta_corte
			 Where cs_canasta = :as_bolsa;
			 
			 
			 
	 		lds_dt_lectura_bolsas = Create uo_dsbase
			lds_dt_lectura_bolsas.DataObject = 'ds_dt_lectura_bolsas'
			lds_dt_lectura_bolsas.SetTransObject(SQLCA)
			
			ll_filas = lds_dt_lectura_bolsas.Retrieve( as_bolsa ) 
			
			ll_b = lds_dt_lectura_bolsas.RowCount() + 1
			lds_dt_lectura_bolsas.RowsCopy( 1, 1, Primary!, lds_dt_lectura_bolsas, ll_b, Primary! )

			lds_dt_lectura_bolsas.SetItem( ll_b,'cs_canasta', ls_bolsa_nueva )
			lds_dt_lectura_bolsas.SetItem( ll_b,'cs_canasta_agrupada', as_bolsa )
			lds_dt_lectura_bolsas.SetItem( ll_b,'fe_lectura', ldt_ahora )
			lds_dt_lectura_bolsas.SetItem( ll_b,'fe_creacion', ldt_ahora )
			lds_dt_lectura_bolsas.SetItem( ll_b,'fe_actualizacion', ldt_ahora )
			lds_dt_lectura_bolsas.SetItem( ll_b,'usuario', gstr_info_usuario.codigo_usuario )
			lds_dt_lectura_bolsas.SetItem( ll_b,'instancia', gstr_info_usuario.instancia )
			
			If lds_dt_lectura_bolsas.Update() <> 1 Then
				ROLLBACK;
				MessageBox('Atencion', 'Ocurrio un error al insertar en dt_lectura_bolsas.~r~n' +  lds_dt_lectura_bolsas.is_SQLErrText )
				Return -1
			End If
			 
		End If
		
		
		
		
		
		
		/*
		ll_ret_canasta = lds_dt_canasta.Of_Retrieve(as_bongo)
		If ll_ret_canasta <= 0 Then
			Rollback;
			MessageBox("Error","Error Consultando el bongo "+as_bongo+" para realizar cambio de PO. Por favor informe a Sistemas",StopSign!)
			Return -1
		End IF
		
		lds_dt_canasta.SetFilter( 'cs_canasta = "' + as_bolsa + '"'  )
		lds_dt_canasta.Filter()
		
		
		
		lds_dt_canasta.RowsDiscard( 1, lds_dt_canasta.FilteredCount(), Filter! )
		
		For ll_i = 1 To lds_info_cambio_po.RowCount()
			ll_pedido = lds_info_cambio_po.GetItemNumber( ll_i, 'pedido' )
			ll_fabrica = lds_info_cambio_po.GetItemNumber( ll_i, 'co_fabrica_ref' )
			ll_linea = lds_info_cambio_po.GetItemNumber( ll_i, 'co_linea' )
			ll_referencia = lds_info_cambio_po.GetItemNumber( ll_i, 'co_referencia' )
			ll_talla = lds_info_cambio_po.GetItemNumber( ll_i, 'co_talla' )
			ll_color = lds_info_cambio_po.GetItemNumber( ll_i, 'co_color' )
			ll_pedido_cambiar = lds_info_cambio_po.GetItemNumber( ll_i, 'pedido_agrupa' )
			ls_po_cambiar = Trim(lds_info_cambio_po.GetItemString( ll_i, 'po_agrupada' ) )
			//armamos la expresi$$HEX1$$f300$$ENDHEX$$n para filtrar los detalles que coincidan con la po origen
			ls_expresion ="pedido =  " + String(ll_pedido) + &
				+ " and co_fabrica_ref = "+String(ll_fabrica)+" and co_linea = "+String(ll_linea)+" and co_referencia = "+String(ll_referencia)&
				+" and co_talla = "+  String(ll_talla)+" and co_color = "+String(ll_color)
		
			//Filtramos los detalles que coincidan con la referencias a la que le vamos a hacer el cambio
			lds_dt_canasta.SetFilter(ls_expresion)
			lds_dt_canasta.Filter()
				
			IF lds_dt_canasta.RowCount() <= 0 Then
				Rollback;
				MessageBox("Error","No se encontr$$HEX2$$f3002000$$ENDHEX$$la PO-SKU a la que se le va a realizar el cambio de PO. Por favor informe a Sistemas. ~r~nExpresi$$HEX1$$f300$$ENDHEX$$n de busqueda : "+ls_expresion,StopSign!)
				Return -1
			End IF
			//Recorremos todos los detalles a los que les vamos a hacer el cambio
			For ll_n = 1 To lds_dt_canasta.RowCount()		
				ll_ca_actual = lds_dt_canasta.GetItemNumber(ll_n,'ca_actual')	
				If ll_ca_actual > 0 Then
					//Colocamos los datos para el cambio de PO
					lds_dt_canasta.SetItem(ll_n,'po', ls_po_cambiar)
					lds_dt_canasta.SetItem(ll_n,'pedido', ll_pedido_cambiar)
					lds_dt_canasta.SetItem(ll_n,'ca_nueva', al_cantidad )
					lds_dt_canasta.SetItem(ll_n,'c_pedido', 1)
					lds_dt_canasta.SetItem(ll_n,'c_po', 1)
					lds_dt_canasta.SetItem(ll_n,'c_referencia', 1)
					lds_dt_canasta.SetItem(ll_n,'c_cantidad', 1)
				End If
			Next
		Next
		If lds_dt_canasta.ModifiedCount() > 0 Then
			//Invocamos el cambio de PO
			lnvo_cambio_po.il_fabrica_loteo = 2
			lnvo_cambio_po.ib_mover_kardex = False
			IF lnvo_cambio_po.of_cambio_ref_parcial(as_bolsa, lds_dt_canasta, 505 ,0 ) < 0 Then
				Rollback;
				MessageBox("Error","Error al hacer cambio de recipiente "+Trim(as_bolsa)+". Por favor intente de nuevo, si el problema continua informe a Sistemas. ",StopSign!)
				Return -1
			Else
				MessageBox('Revisar',' cambio de PO recipiente '+Trim(as_bolsa))
				ROLLBACK;
				Return 1
			End If
		End If
		*/
		Return 1
	End If
End If
	
					
// ************* Fin SA60509 - cambio de PO por agrupacion de pedido  ************

Return 1


end function

public function long of_crear_bolsa ();long li_tipoorden, li_fabrica
Long ll_documento

n_cts_constantes luo_constantes
n_cst_funciones_comunes lnvo_funcion

luo_constantes = Create n_cts_constantes
li_fabrica = luo_constantes.of_consultar_numerico("FABRICA TELA")
IF li_fabrica = -1 THEN
	Destroy luo_constantes
	Return -1
END IF

li_tipoorden = luo_constantes.of_consultar_numerico("TIPO CANASTA")
IF li_tipoorden = -1 THEN
	Destroy luo_constantes
	Return -1
END IF

ll_documento = lnvo_funcion.of_consecutivo_ordenes( li_fabrica, li_tipoorden)

Return ll_documento

end function

on n_cst_cambio_po_loteo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_cambio_po_loteo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

