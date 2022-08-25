HA$PBExportHeader$n_cst_mover_kardex.sru
forward
global type n_cst_mover_kardex from nonvisualobject
end type
end forward

global type n_cst_mover_kardex from nonvisualobject autoinstantiate
end type

type variables
String is_programa
uo_dsbase ids_h_canasta, ids_dt_canasta
s_parametros_pr_graba_pdn istr_parametros_pr_graba
end variables

forward prototypes
public function long of_ejecutar_pr_graba_pdn (s_parametros_pr_graba_pdn astr_parametro)
public function long of_obtener_pallets (ref string as_pallets[])
public function long of_mover_kardex (uo_dsbase ads_h_canasta, uo_dsbase ads_dt_canasta, string as_programa, long ai_mueve_kardex, long ai_signo, string as_tipo_actualiza, string as_tipo_lectura, long al_modulo_fis, long ai_afecta_incentivo, boolean ab_usar_origen, string as_canasta_origen, boolean ab_usar_destino, string as_canasta_destino)
end prototypes

public function long of_ejecutar_pr_graba_pdn (s_parametros_pr_graba_pdn astr_parametro);Long li_fab_origen,li_pla_origen,li_cen_origen,li_subcen_origen,li_bodega_origen, &
        li_fab_destino,li_pla_destino,li_cen_destino,li_subcen_destino,li_bodega_destino, &
		  li_cpto_salida,li_cpto_entrada,li_fabrica,li_linea,li_talla,li_calidad, &
		  li_cantidad,li_cant_seg,li_signo,li_afecta_incen, li_fabrica_exp, li_linea_exp, &
		  li_calidad_exp
Long ll_cs_movimiento = 0,ll_turno,ll_lote,ll_modulo,ll_tipoprod,ll_referencia,ll_ano, &
     ll_mes,ll_modulo_fis, ll_co_fabrica_pro, ll_sqldbcode, ll_pedido, ll_fabrica_pro_des, ll_color 
String ls_tipo_lectura,ls_tipo_atributo,ls_tipo_produccion,ls_po,ls_nucut,ls_canasta, &
       ls_canasta_des,ls_tipo_act,ls_constraint,ls_subject,ls_mensaje,ls_sqlerrtext, &
		 ls_error,ls_error_info, ls_ref_exp,ls_talla_exp,ls_color_exp
n_cst_funciones_comunes lnvo_fun		 


ls_tipo_lectura = astr_parametro.tipo_lectura
ls_tipo_atributo = astr_parametro.tipo_atributo
ls_tipo_produccion = astr_parametro.tipo_produccion
ll_turno = astr_parametro.turno
ll_lote = astr_parametro.lote
ll_modulo = astr_parametro.modulo
ls_po = astr_parametro.po
ls_nucut = astr_parametro.nu_cut
ll_tipoprod = astr_parametro.tipoprod
li_fab_origen = astr_parametro.fabrica_origen
li_pla_origen = astr_parametro.planta_origen
li_cen_origen = astr_parametro.centro_origen
li_subcen_origen = astr_parametro.subcentro_origen
li_bodega_origen = astr_parametro.bodega_origen
li_fab_destino = astr_parametro.fabrica_destino
li_pla_destino = astr_parametro.planta_destino
li_cen_destino = astr_parametro.centro_destino
li_subcen_destino = astr_parametro.subcentro_destino
li_bodega_destino = astr_parametro.bodega_destino
ls_canasta = astr_parametro.canasta
ls_canasta_des = astr_parametro.canasta_destino
li_cpto_salida = astr_parametro.cpto_salida
li_cpto_entrada = astr_parametro.cpto_entrada
li_fabrica = astr_parametro.fabrica
li_linea = astr_parametro.linea
ll_referencia = astr_parametro.referencia
li_talla = astr_parametro.talla
li_calidad = astr_parametro.calidad
ll_color = astr_parametro.color
ll_ano = astr_parametro.ano
ll_mes = astr_parametro.mes
li_cantidad = astr_parametro.cantidad
li_cant_seg = astr_parametro.cantidad_seg
li_signo = astr_parametro.signo
li_afecta_incen = astr_parametro.afecta_incen
ls_tipo_act = astr_parametro.tipo_act
ll_modulo_fis = astr_parametro.modulo_fis
ll_co_fabrica_pro = astr_parametro.propietario
ll_fabrica_pro_des = astr_parametro.fabrica_pro_des
ll_pedido = astr_parametro.pedido
li_fabrica_exp = astr_parametro.co_fabrica_exp
li_linea_exp = astr_parametro.co_linea_exp
ls_ref_exp = astr_parametro.co_ref_exp
ls_talla_exp = astr_parametro.co_talla_exp
li_calidad_exp = astr_parametro.co_calidad_exp
ls_color_exp = astr_parametro.co_color_exp

If isnull(ll_fabrica_pro_des) Then
	ll_fabrica_pro_des = 0
End if

Declare pr_graba_produccion Procedure For pr_graba_produccion(:ll_cs_movimiento,:ls_tipo_lectura, 
						 :ls_tipo_atributo, :ls_tipo_produccion, 
						 :ll_turno, :ll_lote, :ll_modulo, :ll_modulo_fis, :ls_po, 
						 :ls_nucut, :ll_tipoprod, :li_fab_origen, 
						 :li_pla_origen, :li_bodega_origen, 
						 :li_cen_origen, :li_subcen_origen, 
						 :li_cpto_salida, :li_fab_destino, 
						 :li_pla_destino, :li_bodega_destino, 
						 :li_cen_destino, :li_subcen_destino, 
						 :li_cpto_entrada, :li_fabrica, :li_linea, 
						 :ll_referencia, :li_talla, :li_calidad, 
						 :ll_color, :ll_ano, :ll_mes, :ls_canasta, 
						 :li_cantidad, :li_cant_seg, :li_signo, 
						 :li_afecta_incen, :ls_canasta_des, 
						 :ls_tipo_act, :ll_co_fabrica_pro, :ll_fabrica_pro_des, 
						 :ll_pedido, :li_fabrica_exp, :li_linea_exp, 
						 :ls_ref_exp, :ls_talla_exp, :li_calidad_exp, 
						 :ls_color_exp, :is_programa);

Execute pr_graba_produccion;

//	Valida la ejecuci$$HEX1$$f300$$ENDHEX$$n del Procedimiento Almacenado
If SQLCA.SQLCode = -1 Then
	ll_sqldbcode = SQLCA.SQLdbcode
	ls_sqlerrtext = SQLCA.SQLErrText
	RollBack;
	//	Captura el nombre del constraint
	ls_constraint = Mid(ls_sqlerrtext,Pos(ls_sqlerrtext,".") + 1)
	ls_constraint = Mid(ls_constraint,1,Pos(ls_constraint,")") - 1)
	//	Llama la funci$$HEX1$$f300$$ENDHEX$$n que encuentra la definic$$HEX1$$f300$$ENDHEX$$n del constraint
	ls_error = lnvo_fun.of_constaint_descripcion(ls_constraint)
	ls_error_info = "Fabrica~tLinea~tReferencia~tTalla~tCalidad~tColor~tLote~tCantidad~r~n" &
						+ String(li_fabrica) + "~t" &
						+ String(li_linea) + "~t" &
						+ String(ll_referencia) + "~t~t" &
						+ String(li_talla) + "~t" &
						+ String(li_calidad) + "~t" &
						+ String(ll_color) + "~t" &
						+ String(ll_lote) + "~t" &
						+ String(li_cantidad)
	//	Si el error es a causa de un constraint en la Base de Datos
	//	muestra el nombre del constraint y su definici$$HEX1$$f300$$ENDHEX$$n
	If ll_sqldbcode = -530 Then
		Beep(1)
		MessageBox("Error de Kardex en: " + ls_canasta + "    Tipo: " + ls_tipo_lectura &
					+ "    Propietario: " + String(ll_co_fabrica_pro), "Fallo el constraint '" &
					+ ls_constraint + "'.~n~n" + ls_error + "~n~nPO: " + ls_po + "   Cut: " + ls_nucut &
					+ "     Origen: " + String(li_fab_origen) + " " + String(li_pla_origen) + " " &
					+ String(li_cen_origen) + " " + String(li_subcen_origen) + "   Destino: " &
					+ String(li_fab_destino) + " " + String(li_pla_destino) + " " &
					+ String(li_cen_destino) + " " + String(li_subcen_destino) + "~n~n" &
					+ ls_error_info, StopSign!)
	Else	//	Sino fallo por un constraint muestra el error que sea devuelto por la B.D.
		Beep(1)
		MessageBox("Error de Kardex en: " + ls_canasta + "    Tipo: " + ls_tipo_lectura &
					+ "    Propietario: " + String(ll_co_fabrica_pro), ls_sqlerrtext + "~n~nPO: " + ls_po &
					+ "   Cut: " + ls_nucut + "     Origen: " + String(li_fab_origen) + " " + String(li_pla_origen) + " " &
					+ String(li_cen_origen) + " " + String(li_subcen_origen) + "   Destino: " &
					+ String(li_fab_destino) + " " + String(li_pla_destino) + " " &
					+ String(li_cen_destino) + " " + String(li_subcen_destino)+ "~n~n" + ls_error_info, StopSign!)
	End If

	Close pr_graba_produccion;
	Return -1
End If

//	Se cierra el procedimiento almacenado
Close pr_graba_produccion;

Return 1
end function

public function long of_obtener_pallets (ref string as_pallets[]);/*	----------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para obtener los bongos
	---------------------------------------------------------------------------------- */

String ls_pallet
Long ll_i,  ll_j
Boolean lb_existe

For ll_i = 1 TO ids_h_canasta.RowCount()
	ls_pallet =	ids_h_canasta.GetItemString(ll_i,'pallet_id')
	If ll_i = 1 Then
		as_pallets[1] = ls_pallet 
	Else
		lb_existe = false
		For ll_j = 1 To UpperBound(as_pallets)
			IF Trim(as_pallets[ll_j]) = Trim(ls_pallet) THen
				lb_existe = true
				continue			
			End IF
		Next	
		IF Not lb_existe THen
			as_pallets[upperbound(as_pallets) + 1 ] = ls_pallet
		End IF
	End IF	

Next
Return 1
end function

public function long of_mover_kardex (uo_dsbase ads_h_canasta, uo_dsbase ads_dt_canasta, string as_programa, long ai_mueve_kardex, long ai_signo, string as_tipo_actualiza, string as_tipo_lectura, long al_modulo_fis, long ai_afecta_incentivo, boolean ab_usar_origen, string as_canasta_origen, boolean ab_usar_destino, string as_canasta_destino);/*	-------------------------------------------------------------------------------------
	Funci$$HEX1$$f300$$ENDHEX$$n para actualizar el kadex. en esta funci$$HEX1$$f300$$ENDHEX$$n se valida se el movimiento que
	se esta haciendo es correcto y se hace el llamado a pr_graba_pdn para que haga el movimiento del
	kardex
	parametros:
	dw cabeza canasta
	de detalle canasta
	programa
	mueve kardex
	signo
	tipo_actualiza
	tipo lectura
	modulo fis
	afecta incentivo
	usar origen--usado para saber si utiliza el parametro as_canasta_origen para el movimiento de cs_canasta, si es falso se usa el pallet_id del detalle de canasta
	canasta origen
	usar destino--usado para saber si utiliza el parametro as_canasta_destino para el movimiento de cs_canasta_destino, si es falso se usa el pallet_id del detalle de canasta
	canasta destino
	------------------------------------------------------------------------------------- */


String ls_conceptos, ls_pallets[], is_pallet_id, ls_error 
Long ll_i, ll_ca_actual, ll_hora_turno, ll_j
Long li_turno, li_ano, li_mes, li_cpto_salida, li_cpto_entrada
n_cst_funciones_comunes lnvo_func

If Not isvalid(ids_h_canasta) Then
	ids_h_canasta = Create uo_dsbase
	ids_h_canasta.DataObject = ads_h_canasta.DataObject
	ids_h_canasta.SetTransObject(SQLCA)
End if


If Not isvalid(ids_dt_canasta) Then
	ids_dt_canasta = Create uo_dsbase
	ids_dt_canasta.DataObject = ads_dt_canasta.DataObject
	ids_dt_canasta.SetTransObject(SQLCA)
End if

//Se hace una copia el datasotore para no hacer modificaciones sobre los que se reciben por referencia
//los datawidow contiene la informaci$$HEX1$$f300$$ENDHEX$$n de las canastas
ids_h_canasta.Reset()
ids_dt_canasta.Reset()

ads_h_canasta.RowsCopy(1, ads_h_canasta.RowCount(), Primary!, ids_h_canasta, 1, Primary!)
ads_dt_canasta.RowsCopy(1, ads_dt_canasta.RowCount(), Primary!, ids_dt_canasta, 1, Primary!)

//Se evalua que los dw de las canastas tengan datos
If ids_h_canasta.RowCount() <= 0 Then
	rollback;
	MessageBox("Error","No hay encabezado de canastas",StopSign!)
	Return -1
End IF

If ids_dt_canasta.RowCount() <= 0 Then
	rollback;
	MessageBox("Error","No hay detalle de canastas",StopSign!)
	Return -2
End IF


//Se obtiene el nombre del programa
is_programa = as_programa


//Seg$$HEX1$$fa00$$ENDHEX$$n el tipo de actualizaci$$HEX1$$f300$$ENDHEX$$n que se requiere
Choose Case ai_mueve_kardex
	
	//Si es cero no mueve ni origen ni destino
	Case 0	
		istr_parametros_pr_graba.subcentro_origen = 0
		istr_parametros_pr_graba.subcentro_destino = 0
	
	//Mueve Origen y Destino
	Case 1
		istr_parametros_pr_graba.subcentro_origen = ids_h_canasta.GetItemNumber(1,'co_subcentro_act')
		istr_parametros_pr_graba.subcentro_destino = ids_h_canasta.GetItemNumber(1,'co_subcentro_pdn')
	
	//Mueve Origen y no mueve Destino
	Case 2
		istr_parametros_pr_graba.subcentro_origen = ids_h_canasta.GetItemNumber(1,'co_subcentro_act')
		istr_parametros_pr_graba.subcentro_destino = 0
	//No Mueve Origen y mueve Destino	
	Case 3
		istr_parametros_pr_graba.subcentro_origen = 0
		istr_parametros_pr_graba.subcentro_destino = ids_h_canasta.GetItemNumber(1,'co_subcentro_pdn')

End Choose


//Se obtiene los datos de origen y destino de la remisi$$HEX1$$f300$$ENDHEX$$n
istr_parametros_pr_graba.fabrica_origen	=	ids_h_canasta.GetItemNumber(1,'co_fabrica_act')
istr_parametros_pr_graba.fabrica_destino 	=	ids_h_canasta.GetItemNumber(1,'co_fabrica')
istr_parametros_pr_graba.planta_origen 	=	ids_h_canasta.GetItemNumber(1,'co_planta_act')
istr_parametros_pr_graba.planta_destino 	= 	ids_h_canasta.GetItemNumber(1,'co_planta')
istr_parametros_pr_graba.centro_origen 	= 	ids_h_canasta.GetItemNumber(1,'co_centro_act')
istr_parametros_pr_graba.centro_destino 	= 	ids_h_canasta.GetItemNumber(1,'co_centro_pdn')
istr_parametros_pr_graba.tipo_lectura 		= 	as_tipo_lectura
istr_parametros_pr_graba.propietario 		= 	ids_h_canasta.GetItemNumber(1,'co_fabrica_pro')
istr_parametros_pr_graba.fabrica_pro_des	= 	ids_h_canasta.GetItemNumber(1,'co_fabric_pro_des')
istr_parametros_pr_graba.tipoprod 			= 	ids_h_canasta.GetItemNumber(1,'co_tipoprod')

//	Si falla al hallar el turno falla
If lnvo_func.of_hallar_turno(li_turno) <= 0 Then Return -3

//	Si falla al hallar el ano mes falla
If lnvo_func.of_hallar_ano_mes(Int(istr_parametros_pr_graba.fabrica_origen), li_ano, li_mes) <= 0 Then Return -4

//	Si falla al hallar los conceptos de origen y destino falla
If lnvo_func.of_hallar_origen_destino(istr_parametros_pr_graba.tipo_lectura, li_cpto_salida, li_cpto_entrada) <= 0 Then Return -5

//	Se almacenan los valores hallados en el objeto que mueve el kardex
istr_parametros_pr_graba.turno = li_turno
istr_parametros_pr_graba.ano = li_ano
istr_parametros_pr_graba.mes = li_mes
istr_parametros_pr_graba.cpto_entrada 	= li_cpto_entrada
istr_parametros_pr_graba.cpto_salida 	= li_cpto_salida

//Obtiene los bongos 
This.of_obtener_pallets(ls_pallets)

//Recorre todos los bongos de la remisi$$HEX1$$f300$$ENDHEX$$n
For ll_j = 1 To UpperBound(ls_pallets)
	is_pallet_id = ls_pallets[ll_j]
	
	//Se deja solo las canastas que pertenezcan al bongo
	ids_h_canasta.SetFilter("pallet_id = '"+is_pallet_id+"'")
	ids_h_canasta.Filter()
	
	//Se evalua que haya quedado por lo menos una canasta
	If ids_h_canasta.RowCount() <= 0 Then
		rollback;
		MessageBox("Error","No se encontr$$HEX2$$f3002000$$ENDHEX$$el bongo :"+is_pallet_id, StopSign!)
		Return -1
	End IF
	
	//Se Deja solo los detalles de canastas que pertenezcan al bongo
	ids_dt_canasta.SetFilter("pallet_id = '"+is_pallet_id+"'")
	ids_dt_canasta.Filter()
	
	//Se evalua que haya quedado por lo menos un detalle de canasta
	If ids_dt_canasta.RowCount() <= 0 Then
		rollback;
		MessageBox("Error","No se encontraron referencias para el bongo :"+is_pallet_id, StopSign!)
		Return -2
	End IF
	
	//Se llenan parametros para el llamado a pr_graba_pdn
	istr_parametros_pr_graba.tipo_atributo 	=	ids_h_canasta.GetItemString(1,'co_tipo_atributo')
	istr_parametros_pr_graba.tipo_produccion 	= 	ids_h_canasta.GetItemString(1,'co_tipo_produccion')
	istr_parametros_pr_graba.modulo 				= 	ids_h_canasta.GetItemNumber(1,'co_modulo')
	
	istr_parametros_pr_graba.afecta_incen 		= 	ai_afecta_incentivo
	istr_parametros_pr_graba.signo 				= 	ai_signo
	
	istr_parametros_pr_graba.tipo_act 			= 	as_tipo_actualiza
	

	
	//Se recorren todos los detalles de las canastas
	For ll_i = 1 To ids_dt_canasta.RowCount()
			
		//Se obtienen los datos del detalle de la canasta	
		istr_parametros_pr_graba.calidad 			=	ids_dt_canasta.GetItemNumber(ll_i,'co_calidad')
		istr_parametros_pr_graba.fabrica 			=	ids_dt_canasta.GetItemNumber(ll_i,'co_fabrica_ref')
		istr_parametros_pr_graba.linea				=	ids_dt_canasta.GetItemNumber(ll_i,'co_linea')
		istr_parametros_pr_graba.referencia			=	ids_dt_canasta.GetItemNumber(ll_i,'co_referencia')
		istr_parametros_pr_graba.lote					= 	ids_dt_canasta.GetItemNumber(ll_i,'lote')
		istr_parametros_pr_graba.cantidad 			= 	ids_dt_canasta.GetItemNumber(ll_i,'ca_actual')
		istr_parametros_pr_graba.cantidad_seg		=	ids_dt_canasta.GetItemNumber(ll_i,'ca_segundas')
		istr_parametros_pr_graba.color 				= 	ids_dt_canasta.GetItemNumber(ll_i,'co_color')
		istr_parametros_pr_graba.talla 				= 	ids_dt_canasta.GetItemNumber(ll_i,'co_talla')

		istr_parametros_pr_graba.modulo_fis 		= 	al_modulo_fis
		IF ab_usar_origen Then
			istr_parametros_pr_graba.canasta 		=  as_canasta_origen
		Else	
			istr_parametros_pr_graba.canasta 			= 	ids_dt_canasta.GetItemString(ll_i,'pallet_id')
		End IF	
		
		IF ab_usar_destino Then
			istr_parametros_pr_graba.canasta_destino 		=  as_canasta_destino
		Else	
			istr_parametros_pr_graba.canasta_destino 	= 	ids_dt_canasta.GetItemString(ll_i,'pallet_id')
		End IF
		
		istr_parametros_pr_graba.nu_cut 				= 	ids_dt_canasta.GetItemString(ll_i,'nu_cut')
		istr_parametros_pr_graba.po 					= 	ids_dt_canasta.GetItemString(ll_i,'po')
		istr_parametros_pr_graba.bodega_origen 	= 	ids_dt_canasta.GetItemNumber(ll_i,'co_bodega')
		istr_parametros_pr_graba.bodega_destino 	= 	ids_dt_canasta.GetItemNumber(ll_i,'co_bodega')

		istr_parametros_pr_graba.pedido = ids_dt_canasta.GetItemNumber(ll_i,'pedido')

		istr_parametros_pr_graba.pedido_destino = ids_dt_canasta.GetItemNumber(ll_i,'pedido')
		istr_parametros_pr_graba.po_destino = ids_dt_canasta.GetItemString(ll_i,'po')
		istr_parametros_pr_graba.nu_cut_destino = ids_dt_canasta.GetItemString(ll_i,'nu_cut')			
		
		istr_parametros_pr_graba.co_fabrica_exp = ids_dt_canasta.GetItemNumber(ll_i,'co_fabrica_exp')
		istr_parametros_pr_graba.co_linea_exp = ids_dt_canasta.GetItemNumber(ll_i,'co_linea_exp')
		istr_parametros_pr_graba.co_ref_exp = ids_dt_canasta.GetItemString(ll_i,'co_ref_exp')
		istr_parametros_pr_graba.co_talla_exp = ids_dt_canasta.GetItemString(ll_i,'co_talla_exp')			
		istr_parametros_pr_graba.co_calidad_exp = ids_dt_canasta.GetItemNumber(ll_i,'co_calidad')
		istr_parametros_pr_graba.co_color_exp = ids_dt_canasta.GetItemString(ll_i,'co_color_exp')
		
		If This.of_ejecutar_pr_graba_pdn(istr_parametros_pr_graba) < 0 Then				
			rollback;
			Return -10
		End IF
		
	Next
Next





return 1
end function

on n_cst_mover_kardex.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_mover_kardex.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

