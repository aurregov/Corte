HA$PBExportHeader$w_impresion_marquillas_etiquetas.srw
$PBExportComments$SA49463 E00432  Nueva ventana de impresion de marquillas y etiquetas
forward
global type w_impresion_marquillas_etiquetas from w_preview_de_impresion
end type
type dw_formato from datawindow within w_impresion_marquillas_etiquetas
end type
type st_formatos from statictext within w_impresion_marquillas_etiquetas
end type
type st_pool from statictext within w_impresion_marquillas_etiquetas
end type
type dw_param_marquillas_etiquetas from datawindow within w_impresion_marquillas_etiquetas
end type
type p_1 from picture within w_impresion_marquillas_etiquetas
end type
type dw_oc_x_canastas from datawindow within w_impresion_marquillas_etiquetas
end type
type gb_parametros from groupbox within w_impresion_marquillas_etiquetas
end type
end forward

global type w_impresion_marquillas_etiquetas from w_preview_de_impresion
integer width = 5239
integer height = 2072
string title = "Impresi$$HEX1$$f300$$ENDHEX$$n marquillas y etiquetas"
event ue_postopen ( )
event ue_consultar ( )
dw_formato dw_formato
st_formatos st_formatos
st_pool st_pool
dw_param_marquillas_etiquetas dw_param_marquillas_etiquetas
p_1 p_1
dw_oc_x_canastas dw_oc_x_canastas
gb_parametros gb_parametros
end type
global w_impresion_marquillas_etiquetas w_impresion_marquillas_etiquetas

type variables

Long il_cod_operario, il_cliente, il_sucursal, il_fabrica, il_linea, il_nro_impresoras = 1
Long ii_fila_formato
String is_co_referencia, is_tipo_ref, is_canasta
uo_dsbase ids_guia_num
n_cst_etiqueta iuo_etiquetas

/***********************************************************
SA51561 - E00487 - 27-07-2015 Ceiba/JJ
Comentario: entidad oc x bolsas
***********************************************************/	
n_ds_t_oc_imp_bolsas 	ids_OC_x_Bolsas
n_ds_dt_canasta_corte 	ids_dt_canasta_corte
n_ds_m_turno				ids_m_turno

PRIVATE:
CONSTANT LONG COD_ANT = 13
end variables

forward prototypes
public subroutine wf_cargarinformacionoc_x_canasta (readonly long al_dato)
public function long wf_verificarhoramvtoconhoraturno ()
public function long wf_cargarunidadesimpresas (readonly long al_orden_corte, readonly long al_fila) throws exception
public function long wf_leerconstantes (readonly string al_constante) throws exception
public function long wf_cargarinformaciondeturnos (readonly long al_fila) throws exception
public function long wf_setentidadoc_x_bolsas (readonly long al_orden_corte, readonly long al_canasta, readonly long al_empleado) throws exception
public function long wf_validarregistroduplicadoocxcanastas () throws exception
public subroutine wf_resetinformacionoc_x_canasta ()
public function string wf_leerconstantestexto (readonly string al_constante) throws exception
end prototypes

event ue_consultar();/******************************************************************** 
FunctionName ue_consultar
SA49463 E00432
 <DESC>  Ejecutar consulta y validar resultados obtenidos</DESC>
 <RETURN> none </RETURN>
 <ACCESS> Private
 <ARGS>   </ARGS>
 <USAGE>  Llamada cuando se presiona el boton buscar del menu</USAGE>
 ********************************************************************/

 
Long li_resultado
String ls_referencia, ls_color, ls_talla, ls_separador, ls_composicion1,ls_composicion,ls_composicion2,ls_composicion3,ls_composicion4
Long ll_fabrica, ll_linea, ll_calidad, ll_n, ll_find, ll_empleado, ll_oc


//aceptar los parametros ingresados
If dw_param_marquillas_etiquetas.accepttext() <= 0 Then Return 


ll_empleado = dw_param_marquillas_etiquetas.GetItemNumber(1,'empleado')
ll_oc = dw_param_marquillas_etiquetas.GetItemNumber(1,'orden_corte')

//campo para separar las diferentes composiciones
ls_separador = '/**/'

//consulta la informacion
li_resultado = dw_reporte.Retrieve(is_canasta,ll_oc,ls_separador)
If(li_resultado = 0) Then
	Messagebox("Error", "No existe informaci$$HEX1$$f300$$ENDHEX$$n relacionada con el recipiente", StopSign!)
Elseif (li_resultado < 0) Then
	Messagebox("Error", "Error recuperando la informaci$$HEX1$$f300$$ENDHEX$$n relacionada con el recipiente", StopSign!)
End if

dw_reporte.SetReDraw(False)
//recorre los datos para separar la composicion y asignar el codigo del empleado
For ll_n = 1 to dw_reporte.RowCount()
	//toma la compocision
	ls_composicion = dw_reporte.GetITemString(ll_n,'composicion')
	
	//busca la composicion 2
	ll_find = Pos(ls_composicion,ls_separador)
	//si no encuentra
	If ll_find = 0 Then
		ls_composicion1 = ls_composicion
		ls_composicion2 = ' '
		ls_composicion3 = ' '
		ls_composicion4 = ' '
		
	Else
		//separa la composicion
		//toma la composicion1
		ls_composicion1 = Mid(ls_composicion,1,ll_find - 1)
		//toma el resto de la composicion
		ls_composicion = Mid(ls_composicion,ll_find + len(ls_separador))
		
		//busca la composicion 3
		ll_find = Pos(ls_composicion,ls_separador)
		//si no encuentra
		If ll_find = 0 Then
			ls_composicion2 = ls_composicion
			ls_composicion3 = ' '
			ls_composicion4 = ' '
			
		Else
			//separa la composicion
			//toma la composicion2
			ls_composicion2 = Mid(ls_composicion,1,ll_find - 1)
			//toma el resto de la composicion
			ls_composicion = Mid(ls_composicion,ll_find + len(ls_separador))
			
			//busca la composicion 4
			ll_find = Pos(ls_composicion,ls_separador)
			//si no encuentra
			If ll_find = 0 Then
				ls_composicion3 = ls_composicion
				ls_composicion4 = ' '
				
			Else
				//separa la composicion
				//toma la composicion3
				ls_composicion3 = Mid(ls_composicion,1,ll_find - 1)
				//toma el resto de la composicion
				ls_composicion4 = Mid(ls_composicion,ll_find + len(ls_separador))
			End if
		End if
	End if
	
	//actualiza las composiciones
	dw_reporte.SetItem(ll_n,'composicion',ls_composicion1)
	dw_reporte.SetItem(ll_n,'composicion_2',ls_composicion2)
	dw_reporte.SetItem(ll_n,'composicion_3',ls_composicion3)
	dw_reporte.SetItem(ll_n,'composicion_4',ls_composicion4)
	//actualiza el empleado
	dw_reporte.SetItem(ll_n,'codigo_empleado',ll_empleado)
	
Next

dw_reporte.SetReDraw(True)
end event

public subroutine wf_cargarinformacionoc_x_canasta (readonly long al_dato);/********************************************************************
SA51561 - wf_CargarInformacionOC_x_Canasta 
<DESC> Description: Permite cargar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_dato </ARGS> 
<USAGE> Cargar la informacion de OC x Bolsas </USAGE>
********************************************************************/
dw_oc_x_canastas.Retrieve(al_dato)

end subroutine

public function long wf_verificarhoramvtoconhoraturno ();/********************************************************************
SA51561 - E00487- wf_VerificarHoraMvtoConHoraTurno
<DESC> Description: cargar informacion de turnos </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> recuperar co_turno basado la hora de mvto  </USAGE>
********************************************************************/
Long		ll_fila 
STRING	ls_find

ls_find=String(String(Time(f_fecha_servidor()))+" between hora_ini and hora_fin")
ll_fila=ids_m_turno.find((ls_find),1,ids_m_turno.RowCount())

return ll_fila
end function

public function long wf_cargarunidadesimpresas (readonly long al_orden_corte, readonly long al_fila) throws exception;/********************************************************************
SA51561 - E00487- wf_cargarUnidadesImpresas 
<DESC> Description: la cantidad de unidades impresas para datos de auditoria</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long: al_orden_corte, Long: fila , Son necesarios para la recuperacion orden corte y canasta </ARGS> 
<USAGE> Cargar la informacion dt_canasta_corte</USAGE>
********************************************************************/	
Exception 	ex
ex = create Exception
Try
	IF ids_dt_canasta_corte.of_retrieve(al_orden_corte ,is_canasta,0,0,0,0,0,0,0,0) > 0 THEN 
		RETURN ids_dt_canasta_corte.of_getcantidaddeunidades(al_fila)
	Else
		ex.setmessage("Se presentaron problemas al tratar de recuperar la cantidad de unidades a almancenar")
		Return -1
		throw ex
	End If

	RETURN 1
catch( Throwable ex1 )
	Destroy ids_dt_canasta_corte
	Return -1
	Throw ex1
End try	
	
end function

public function long wf_leerconstantes (readonly string al_constante) throws exception;/********************************************************************
SA51561 - E00487- wf_LeerConstantes 
<DESC> Description: leer constantes</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar constantes</USAGE>
********************************************************************/	
Long	ll_return
n_cts_constantes_tela	luo_constantes_tela //Autoinstanciable
Try
	ll_return = luo_constantes_tela.of_consultar_numerico(al_constante)
	IF ll_return = -1 THEN
		Post MessageBox('Error','Ocurrio un error al momento de leer una de las constantes',StopSign!)
		Return -1
	END IF
	
	RETURN ll_return
catch( Throwable ex1 )
	Return -1
	Throw ex1
End try
end function

public function long wf_cargarinformaciondeturnos (readonly long al_fila) throws exception;/********************************************************************
SA51561 - E00487- wf_cargarInformacionDeTurnos
<DESC> Description: cargar informacion de turnos </DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long: al_fila, Long: fila , Son necesarios para la recuperacion orden corte y canasta </ARGS> 
<USAGE> Cargar la informacion m_turno </USAGE>
********************************************************************/
Long			ll_fila, ll_param[]

Exception 		ex
n_cst_string 	lnv_string
ex 			= 	CREATE Exception
lnv_string 	= 	CREATE n_cst_string

lnv_string.of_convertirstring_array(wf_LeerConstantestexto('RANGO_TURNOS'),ll_param)

Try
	IF ids_m_turno.of_retrieve(wf_LeerConstantes('FABRICA_TELA'),wf_LeerConstantes('PLANTA_MARINILLA'),ll_param) > 0 THEN 
		ll_fila = wf_VerificarHoraMvtoConHoraTurno()
		RETURN ids_m_turno.of_getCodigoTurno(ll_fila)
	Else
		ex.setmessage("Se presentaron problemas al tratar de recuperar informaci$$HEX1$$f200$$ENDHEX$$n sobre los turnos")
		Return -1
		Throw ex
	End If
	
	RETURN 1
catch( Throwable ex1 )
	Destroy ids_m_turno
	Return -1
	Throw ex1
End try
end function

public function long wf_setentidadoc_x_bolsas (readonly long al_orden_corte, readonly long al_canasta, readonly long al_empleado) throws exception;/********************************************************************
SA51561 - E00487- wf_setentidadoc_x_bolsas 
<DESC> Description: Permite Setear la informacion de las Bolsas cuando ha sido impresa la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_dato </ARGS> 
<USAGE> Setear la informacion de OC x Bolsas para luego con los registros seteados realizar el update</USAGE>
********************************************************************/	
Long			ll_Fila
Exception 	ex
ex = create Exception
Try
	ids_OC_x_Bolsas.of_insertarNewRow()
	ll_Fila = ids_OC_x_Bolsas.of_getNumUltimaFila()
	ids_OC_x_Bolsas.of_setordencorte(ll_Fila,al_orden_corte)
	ids_OC_x_Bolsas.of_setcanasta(ll_Fila,al_canasta)
	ids_OC_x_Bolsas.of_setCodEmpleado(ll_Fila,al_empleado)	
	ids_OC_x_Bolsas.of_setturno(ll_Fila,wf_cargarInformacionDeTurnos(ll_Fila))
	ids_OC_x_Bolsas.of_setunidadimpresa(ll_Fila,wf_cargarUnidadesImpresas(al_orden_corte,ll_fila))
	ids_OC_x_Bolsas.of_setestilopdn(ll_Fila,ids_dt_canasta_corte.of_getReferencia(ll_Fila))
	ids_OC_x_Bolsas.of_setdatosusuario_fechas(ll_Fila)
	
	RETURN 1
catch( Throwable ex1 )
	Destroy ids_OC_x_Bolsas
	Return -1
	Throw ex1
End try	

end function

public function long wf_validarregistroduplicadoocxcanastas () throws exception;/********************************************************************
SA51561 - E00487- wf_validarRegistroDuplicadoOCxCanastas  
<DESC> Description: la cantidad de unidades impresas para datos de auditoria</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE>validar por calve primaria primaria orden corte y canasta  </USAGE>
********************************************************************/	
Exception 	ex
ex = create Exception
Try
	IF ids_OC_x_Bolsas.of_retrieve(ids_guia_num.getItemNumber(1,"cs_orden_corte") ,Long(is_canasta)) > 0 THEN 
		ids_OC_x_Bolsas.of_setfechaactualizacion()
	ELSEIF ids_OC_x_Bolsas.RowCount() = 0 THEN 
		wf_SetEntidadOC_x_Bolsas(ids_guia_num.getItemNumber(1,"cs_orden_corte"),long(is_canasta),long(dw_param_marquillas_etiquetas.getItemNumber(1,"empleado")))
	ELSE 
		Return -1
		Throw ex
	End If

	RETURN 1
catch( Throwable ex1 )
	Destroy ids_dt_canasta_corte
	Return -1
	Throw ex1
End try	
	
end function

public subroutine wf_resetinformacionoc_x_canasta ();/********************************************************************
SA51561 - wf_ResetInformacionOC_x_Canasta 
<DESC> Description: Limpiar la informacion de las Bolsas que ya han sido impresas de la Orden de Corte</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> Long : al_dato </ARGS> 
<USAGE> limpiar la informacion de OC x Bolsas </USAGE>
********************************************************************/
dw_oc_x_canastas.Reset()

end subroutine

public function string wf_leerconstantestexto (readonly string al_constante) throws exception;/********************************************************************
SA51561 - E00487- wf_LeerConstantes 
<DESC> Description: leer constantes</DESC> 
<RETURN> None </RETURN> 
<ACCESS> Public
<ARGS> </ARGS> 
<USAGE> Cargar constantes</USAGE>
********************************************************************/	
String	ls_return
n_cts_constantes_tela	luo_constantes_tela //Autoinstanciable

Try
	ls_return = Trim(luo_constantes_tela.of_consultar_texto(al_constante))
	IF isNull(ls_return) or trim(ls_return) = '' THEN
		Post MessageBox('Error','Ocurrio un error al momento de leer una de las constantes',StopSign!)
		Return ''
	END IF
	
	RETURN ls_return
catch( Throwable ex1 )
	Return ''
	Throw ex1
End try
end function

on w_impresion_marquillas_etiquetas.create
int iCurrent
call super::create
this.dw_formato=create dw_formato
this.st_formatos=create st_formatos
this.st_pool=create st_pool
this.dw_param_marquillas_etiquetas=create dw_param_marquillas_etiquetas
this.p_1=create p_1
this.dw_oc_x_canastas=create dw_oc_x_canastas
this.gb_parametros=create gb_parametros
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_formato
this.Control[iCurrent+2]=this.st_formatos
this.Control[iCurrent+3]=this.st_pool
this.Control[iCurrent+4]=this.dw_param_marquillas_etiquetas
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.dw_oc_x_canastas
this.Control[iCurrent+7]=this.gb_parametros
end on

on w_impresion_marquillas_etiquetas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_formato)
destroy(this.st_formatos)
destroy(this.st_pool)
destroy(this.dw_param_marquillas_etiquetas)
destroy(this.p_1)
destroy(this.dw_oc_x_canastas)
destroy(this.gb_parametros)
end on

event open;/******************************************************************** 
FunctionName open
SA49463 E00432
<DESC>  Cargar datawindows y habilitar campos por defecto</DESC>
<RETURN> none </RETURN>
<ACCESS> Private
<ARGS>   </ARGS>
<USAGE>  Llamada cuando se abre la ventana</USAGE>
********************************************************************/
/***********************************************************
SA51561 - 27-07-2015 Ceiba/JJ
Comentario: Se adiciona la transaccional del dw: dw_oc_x_canastas 
***********************************************************/
Long ll_reg

dw_reporte.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
dw_formato.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
dw_oc_x_canastas.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
dw_formato.retrieve()
dw_formato.Selectrow(0,False)
ll_reg = dw_formato.Find('co_etiqueta = "7"',1, dw_formato.RowCount() + 1)
dw_formato.Selectrow(ll_reg,True)
ii_fila_formato = ll_reg

dw_param_marquillas_etiquetas.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
dw_param_marquillas_etiquetas.InsertRow(0)


//objeto de impresion de etiquetas
iuo_etiquetas = Create n_cst_etiqueta

//ocultar opciones que no se usan
/*
m_vista_previa_ppal_buscar.m_archivo.m_guardarcomo.enabled = false
m_vista_previa_ppal_buscar.m_vistaprevia.m_mostrarvistaprevia.enabled = false
m_vista_previa_ppal_buscar.m_vistaprevia.m_anterior.enabled = false
m_vista_previa_ppal_buscar.m_vistaprevia.m_siguiente.enabled = false
*/

ids_guia_num = Create uo_dsbase
ids_guia_num.DataObject = 'd_gr_guias_num_x_oc_parte_canasta'
ids_guia_num.SetTransObject(SQLCA)
/***********************************************************
SA51561 - E00487 - 27-07-2015 Ceiba/JJ
Comentario: inicializar entidad ds
***********************************************************/	
ids_OC_x_Bolsas 		= Create n_ds_t_oc_imp_bolsas
ids_dt_canasta_corte = Create n_ds_dt_canasta_corte
ids_m_turno				= Create n_ds_m_turno
ids_OC_x_Bolsas.SetTransObject(SQLCA)	
ids_dt_canasta_corte.SetTransObject(gnv_recursos.of_get_transaccion_sucia())	
ids_m_turno.SetTransObject(gnv_recursos.of_get_transaccion_sucia())	
end event

event resize;/******************************************************************** 

SA49463 E00432
 <DESC>  Ajustar tama$$HEX1$$f100$$ENDHEX$$os de los datawindow</DESC>
 <RETURN> none </RETURN>
 <ACCESS> Private
 <ARGS>   </ARGS>
 <USAGE>  Llamada cuando se hmodifica el tama$$HEX1$$f100$$ENDHEX$$o de la pantalla</USAGE>
 ********************************************************************/

dw_reporte.Resize(This.Width - 1100, This.Height - 700)
dw_formato.height = This.Height - 700
end event

event ue_imprimir;/******************************************************************** 
SA49463 E00432
 <DESC>  Leer datos del formato a imprimir, y mandar a imprimir usando el objeto existente</DESC>
 <RETURN> none </RETURN>
 <ACCESS> Private
 <ARGS>   </ARGS>
 <USAGE>  Llamada cuando se hace click a la opcion Imprimir del menu</USAGE>
 ********************************************************************/

String ls_etiqueta, ls_impresora, ls_datos[], ls_tag, ls_nombrecolumna, ls_dato, ls_carpeta_impresora
Long li_copias, li_fila, li_fila_formato, li_impresora, li_columna, li_total_columnas, li_max
Long ll_orden_corte

dw_reporte.Accepttext( )
dw_param_marquillas_etiquetas.Accepttext( )

//leer dtos de etiqueta seleccionada
ls_etiqueta = dw_formato.getitemstring(ii_fila_formato, "co_etiqueta")
ls_impresora = dw_formato.getitemstring(ii_fila_formato, "impresora")

ls_carpeta_impresora = dw_param_marquillas_etiquetas.GetItemString(1, "impresora")
IF Isnull(ls_carpeta_impresora) Then ls_carpeta_impresora = ''

ll_orden_corte = dw_param_marquillas_etiquetas.GetItemNumber(1, "orden_corte") 

//determinar codigo de impresora leida
If ( ls_impresora = iuo_etiquetas.NOMBRE_IMPRESORA_SATO) then
	li_impresora = iuo_etiquetas.IMPRESORA_SATo
elseif ( ls_impresora = iuo_etiquetas.NOMBRE_IMPRESORA_ZEBRA) then
	li_impresora = iuo_etiquetas.IMPRESORA_ZEBRA
End if

//asigna la carpeta de la impresora en donde debe quedar el archivo
iuo_etiquetas.is_carpeta_impresora = ls_carpeta_impresora


li_total_columnas = Long(dw_reporte.object.datawindow.column.count)

If (dw_reporte.rowcount( ) > 0 ) Then
	
	//se mira el maximo de numeracion de columnas para iniciar el vector de datos
	li_max = 0
	For li_columna = 1 to li_total_columnas
		ls_nombrecolumna	=	dw_reporte.describe('#'+string(li_columna)+'.name')  
		ls_tag =	dw_reporte.Describe(ls_nombrecolumna+".tag")
		If Isnumber(ls_tag) Then
			If Long(ls_tag) > li_max Then
				li_max = Long(ls_tag)
			End if
		End if
	Next
	
	//inicia el vector de datos en blanco
	For li_fila = 1 to li_max
		ls_datos[li_fila] = ''
	Next
	
	For li_fila = 1 to dw_reporte.rowcount( )
		li_copias = dw_reporte.getitemNumber(li_fila, "cantidad")
		If li_copias > 0 Then
			For li_columna = 1 to li_total_columnas
				ls_nombrecolumna	=	dw_reporte.describe('#'+string(li_columna)+'.name') 
				ls_tag =	dw_reporte.Describe(ls_nombrecolumna+".tag")
				
				If Isnumber(ls_tag) Then
					ls_dato = string(dw_reporte.object.data[li_fila,li_columna])
					If Len(string(dw_reporte.object.data[li_fila,li_columna])) > 0 and trim(ls_dato) = '' Then
						ls_datos[long(ls_tag)] = ' '
					Else
						ls_datos[long(ls_tag)] = Trim(string(dw_reporte.object.data[li_fila,li_columna]))
						
						//mira si es el campo de lote (tag 12)
						If trim(ls_tag) = '12' Then
							//si el campo es menor o igual a uno, se coloca la canasta//la orden de corte
							If IsNumber(ls_datos[long(ls_tag)]) Then
								//If Long(ls_datos[long(ls_tag)]) <= 1 Then
									//ls_datos[long(ls_tag)] = String(ll_orden_corte)
									ls_datos[long(ls_tag)] = trim(is_canasta) 
								//End if
							End if
						End if
					End if
				End if
			Next	
			try
				If iuo_etiquetas.of_imprimiretiqueta( ls_etiqueta, ls_datos, li_impresora, li_copias) > 0 Then
					//actualiza el campo que indica que se imprime la marquilla
					ids_guia_num.SetItem(1,'sw_imp_marquilla',1)
					/***********************************************************
					SA51561 - E00487 - 27-07-2015 Ceiba/JJ
					Comentario: Cargar los datos de auditoria y almacenarlos
					***********************************************************/	
					TRY
						IF IsNull(ids_OC_x_Bolsas) OR IsNull(ids_dt_canasta_corte) OR IsNull(ids_m_turno) THEN Return -1 
						IF wf_validarregistroduplicadoocxcanastas() = -1 THEN RETURN -1						
					CATCH (Throwable ex1 )
						Destroy ids_OC_x_Bolsas
						Return -1
						Throw ex1
					End try
					If ids_guia_num.Of_update() <= 0 Then
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se pudo actualizar el campo que indica que se imprime la marquilla.')
						Return -1
					End if
					
					If ids_OC_x_Bolsas.of_update() <=0 Then
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se pudo almacenar los datos de auditoria referentes a la impresion.')
						Return -1
					End if
					
					If ids_guia_num.Of_Commit() <= 0 Then
						Rollback;
						MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','No se pudo actualizar la que indica que se imprime la marquilla (Commit).')
						Return -1
					End if
				Else
					Messagebox("Error imprimiendo etiquetas", 'No se logro imprimir. Por favor verifique la informaci$$HEX1$$f300$$ENDHEX$$n.~r~n'+ iuo_etiquetas.is_mensaje, StopSign!)
				End if
			catch(Exception le_error)
				Messagebox("Error imprimiendo etiquetas", le_error.getmessage(), StopSign!)
			
			End Try
		End if
	Next
	Messagebox( "Informaci$$HEX1$$f300$$ENDHEX$$n","El proceso ha terminado", Information!)
	/***********************************************************
	SA51561 - 27-07-2015 Ceiba/JJ
	Comentario: Se Refresca informacion de Bolsas Impresas de la OC
	***********************************************************/
	wf_CargarInformacionOC_x_Canasta(dw_param_marquillas_etiquetas.getitemnumber(1,"orden_corte"))
Else
	Messagebox("Error imprimiendo etiquetas", "No hay datos para imprimir", StopSign!)
End if	

Return 1
	
end event

event close;call super::close;
Destroy ids_guia_num
/***********************************************************
SA51561 - 27-07-2015 Ceiba/JJ
Comentario: destruir objetos
***********************************************************/
Destroy ids_OC_x_Bolsas
Destroy ids_dt_canasta_corte
Destroy ids_m_turno
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_impresion_marquillas_etiquetas
integer x = 983
integer y = 524
integer width = 2784
integer height = 760
string dataobject = "d_gr_sq_pool_datos_etiquetas"
boolean hsplitscroll = false
end type

type dw_formato from datawindow within w_impresion_marquillas_etiquetas
integer x = 37
integer y = 524
integer width = 919
integer height = 760
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_tb_sq_listado_m_etiquetas"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;/******************************************************************** 
SA49463 E00432
 <DESC>  Guardar indice del formato seleccionado</DESC>
 <RETURN> none </RETURN>
 <ACCESS> Private
 <ARGS>   </ARGS>
 <USAGE>  Llamada cuando se hace click a una fila del data window</USAGE>
 ********************************************************************/

ii_fila_formato = currentrow

This.SelectRow(0, FALSE)

This.SelectRow(ii_fila_formato, TRUE)
end event

type st_formatos from statictext within w_impresion_marquillas_etiquetas
integer x = 37
integer y = 440
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formatos:"
boolean focusrectangle = false
end type

type st_pool from statictext within w_impresion_marquillas_etiquetas
integer x = 983
integer y = 440
integer width = 507
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos a imprimir:"
boolean focusrectangle = false
end type

type dw_param_marquillas_etiquetas from datawindow within w_impresion_marquillas_etiquetas
integer x = 73
integer y = 96
integer width = 1879
integer height = 296
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_ff_param_etiquetas_marquillas"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Long ll_n, ll_ordencorte, ll_count, ll_parte, ll_reg, ll_band, ll_empleado, ll_longitud
Long li_result, li_preparacion, li_subcentro, li_centro, li_tipo
String ls_po, ls_canasta, ls_parte, ls_chequeo
s_base_parametros lstr_parametros
uo_dsbase lds_validar_empleado
n_cst_bolsa lpo_bolsa
n_cts_constantes luo_constantes
luo_constantes = Create n_cts_constantes
DatawindowChild ldwc_subcentro

Choose Case dwo.name
	Case 'empleado' 
		If Isnull(data) Then 
			Destroy n_cts_constantes
			Return 2
		End if
		
		lds_validar_empleado = Create uo_dsbase
		lds_validar_empleado.DataObject = 'd_gr_validar_empleado_imp_ean'
		lds_validar_empleado.SetTransObject(gnv_recursos.of_get_transaccion_sucia())
		
		//Valida el empleado
		ll_n = lds_validar_empleado.Retrieve(Long(data))
		IF ll_n = 0 Then
			Post MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","El empleado no existe. C$$HEX1$$f300$$ENDHEX$$digo "+ trim(data))
			Destroy lds_validar_empleado
			Destroy n_cts_constantes
			Return 2
		Elseif ll_n < 0 Then
			Post MessageBox("Error","Error buscando el usuario")
			Destroy lds_validar_empleado
			Destroy n_cts_constantes
			Return 2
		End IF
		
		Destroy lds_validar_empleado
		
	case 'orden_corte'
		ll_ordencorte = Long(data)
		IF IsNull(ll_ordencorte) or ll_ordencorte = 0 THEN 
			wf_ResetInformacionOC_x_Canasta()
			RETURN 
		END IF

		/* se comenta validacion por peticion del usuario 16/07/14
		//se verifica que la orden este liquidada
		DECLARE validaroc PROCEDURE &
			FOR pr_valida_en_preliquidacion(:ll_ordencorte);
		EXECUTE validaroc;

		IF SQLCA.SQLCode = -1 THEN
			Post MessageBox("Error Base Datos","Error al ejecutar el stored procedure, pr_valoc_liquida.",StopSign!)			
			Destroy n_cts_constantes
			Return 2
		ELSE
			FETCH validaroc INTO :li_result;
			IF li_result = 0 THEN
				Post MessageBox('Error','La orden de corte no se encuentra liquidada.',StopSign!)
				Destroy n_cts_constantes
				Return 2
			END IF
		END IF
		
		CLOSE validaroc;
		*/	
	   //se verifica que la orden de corte se encuentre en preparacion
	   li_preparacion = luo_constantes.of_consultar_numerico('SUBCENTRO PREPARACIO')
		IF li_preparacion = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el subcentro de preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
			Destroy n_cts_constantes
			Return 2
		END IF
				
				
		li_tipo = luo_constantes.of_consultar_numerico('PRENDAS')
		
		IF li_tipo = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el tipo de prenda',StopSign!)
			Destroy n_cts_constantes
			Return 2
		END IF
		
		li_centro = luo_constantes.of_consultar_numerico('CENTRO CORTE')
		
		IF li_centro = -1 THEN
			Post MessageBox('Error','Ocurrio un error al momento de validar el centro de corte',StopSign!)
			Destroy n_cts_constantes
			Return 2
		END IF
	 
	 
	   SELECT MAX(co_subcentro_pdn)
		  INTO :li_subcentro
		  FROM dt_kamban_corte
		 WHERE cs_orden_corte 	= :ll_ordencorte and
				 co_tipoprod 		= :li_tipo and
				 co_centro_pdn 	= :li_centro and
				 fe_inicial 		is not null and
				 fe_final 			is null; 
				 
		IF sqlca.sqlcode = -1 Then
			Post MessageBox('Error','Ocurrio un error al momento de validar el subcentro',StopSign!)
			Destroy n_cts_constantes
			Return 2
		END IF
		
		/*IF li_subcentro = li_preparacion THEN
		ELSE
			/*
			Post MessageBox('Error','La orden se encuentra en extendido, debe ser cargada a Preparaci$$HEX1$$f300$$ENDHEX$$n.',StopSign!)
			Destroy n_cts_constantes
			Return 2
			*/
		END IF*/
	
		//copia el subcentro y lo filtra
		This.SetItem(1,'co_centro',li_centro)
		This.SetItem(1,'co_subcentro',li_subcentro)
		This.GetChild('de_subcentro',ldwc_subcentro) 
		ldwc_subcentro.SetFilter('co_tipoprod = ' + String(li_tipo) + ' and co_centro_pdn = ' + String(li_centro) + ' and co_subcentro_pdn = ' + String(li_subcentro)  )
		ldwc_subcentro.Filter()
	
		If ldwc_subcentro.RowCount() > 0 Then
			This.SetItem(1,'de_subcentro',ldwc_subcentro.GetItemString(1,'de_subcentro_pdn'))
		Else
			This.SetItem(1,'de_subcentro','')
		End if
		
	   //se modifica para no traer la ventana en el caso de que solo exista una P.O., cuando halla m$$HEX1$$e100$$ENDHEX$$s de una
		//P.O. se debe mostrar la ventana de selecion
		//jcrm
		//agosto  30 de 2007
	   SELECT count(Distinct dt_canasta_corte.po)
		  INTO :ll_count
        FROM dt_canasta_corte      
        WHERE dt_canasta_corte.cs_orden_corte = :ll_ordencorte;  
	
		IF ll_count > 1 THEN
			//despliego las P.O. para la orden de corte, permitiendo al usuario seleccionar con la que quiere trabajar
			lstr_parametros.entero[1] = ll_ordencorte
			OpenWithParm ( w_buscar_po, lstr_parametros)
			lstr_parametros = message.PowerObjectParm	
			If lstr_parametros.hay_parametros Then
				This.SetItem(1,'po',lstr_parametros.cadena[1])
				ls_po = lstr_parametros.cadena[1]
			End if
		ELSE
			SELECT dt_canasta_corte.po
			  INTO :ls_po
			  FROM dt_canasta_corte      
			  WHERE dt_canasta_corte.cs_orden_corte = :ll_ordencorte;  
		  IF SQLCA.SQLCODE = 100 THEN
			  Post MessageBox('Error','No se encontr$$HEX2$$f3002000$$ENDHEX$$ninguna Bolsa asociada a la orden de corte, .',StopSign!)
			  Destroy n_cts_constantes
			  Return 2
		  END IF
			This.SetItem(1,'po',ls_po)
			This.SetItem(1,'codigo_barras','')
			
		END IF
		
		/*
		//Verificar Si la orden de corte ya esta loteada para informar al usuario
		SELECT MAX(co_estado_asigna) 
		  INTO :li_estado_asigna
		  FROM dt_pdnxmodulo
		 WHERE cs_asignacion = :ll_ordencorte; 
		IF li_estado_asigna = 15 THEN
			MessageBox('Advertencia','La orden de corte ya se encuentra Loteada, Verifique')
		END IF
		*/
		
		THIS.SetColumn('codigo_barras')	
		/***********************************************************
		SA51561 - 27-07-2015 Ceiba/JJ
		Comentario: Se verifica que la OC sea la correcta, se procede a cargar informacion de Bolsas Impresas de la OC
		***********************************************************/
		wf_CargarInformacionOC_x_Canasta(THIS.getitemnumber(1,"orden_corte"))
		ids_guia_num.Reset()
		dw_reporte.Reset()
		
	Case 'codigo_barras'
		
		If Trim(data) = '' or IsNull(data) Then 
			Destroy n_cts_constantes
			Return 2
		End if
		ll_ordencorte = This.GetItemNumber(1,'orden_corte')
		ls_po = This.GetItemString(1,'po')
		
		IF isnull(ll_ordencorte) THEN
			Post MessageBox('Advertencia','Antes de verificar es necesario ingresar la orden de corte.',Information!)
			Destroy n_cts_constantes
			Return 2
		END IF
		
		IF isnull(ls_po) THEN
			Post MessageBox('Advertencia','No hay un PO valida, es necesario ingresar la orden de corte.',Information!)
			Destroy n_cts_constantes
			Return 2
		END IF
		
		ll_empleado = This.GetItemNumber(1,'empleado')
		IF isnull(ll_empleado) or ll_empleado <= 0 THEN
			Post MessageBox('Advertencia','Antes de verificar es necesario ingresar el c$$HEX1$$f300$$ENDHEX$$digo del empleado.',Information!)
			Destroy n_cts_constantes
			Return 2
		END IF
		
		/***********************************************************
		SA51561 - 27-07-2015 Ceiba/JJ
		Comentario: Con el cambio en la lectura del codigo de barras de la parte en los ashesivos, 
		se requiere implementar la lectura del codigo de barras nuevo y anterior, en lectura de bolsas 
		el usuario indica si es codigo nuevo o anterior, en esta opcion se realizara de acuerdo a la longitud
		***********************************************************/
		ll_longitud = Len(trim(data))
		//toma el cs_canasta y la parte del codigo de barras
		IF ll_longitud = COD_ANT THEN 
			ls_canasta = Mid(trim(data),1,7)
			ls_parte = Mid(trim(data),8)
		ELSE //Se lee digito de chequeo para saber donde comienza la canasta y parte 
			ls_chequeo = Mid(String(data),1,2)
			ls_canasta = Mid(trim(data),3,7)
			ls_parte = Mid(trim(data),10)
		END IF 
				
		//busca el codigo de la parte
		For ll_n = Len(trim(ls_parte)) -1 to 1 step -1
			If Mid(trim(ls_parte),ll_n,1) = '0' and (Mid(trim(ls_parte),Len(trim(ls_parte)),1) <> '0' or (ll_n + 1) <> Len(trim(ls_parte))) Then
				exit;
			End if
		Next
		
		ls_parte = Mid(trim(ls_parte),1,ll_n -1)
		
		//mira que la parte si sea un numerico
		IF Not IsNumber(ls_parte) THEN
			Post MessageBox('Advertencia','El codigo de la parte no es valido en el codigo de barras.',Information!)
			Destroy n_cts_constantes
			This.Post SetItem(row,'codigo_barras','')
			Return 2
		END IF
		
		//toma la parte
		ll_parte = Long(ls_parte)
		ls_canasta = String(Long(ls_canasta))
		//consulta la informacion
		ll_reg = ids_guia_num.Of_Retrieve(ll_ordencorte, ll_parte, ls_canasta)
		//si trae datos
		If ll_reg > 0 Then
			//toma la canasta
			is_canasta = ls_canasta
			
			//verifica si la parte tiene la marca para imprimir marquilla
			If ids_guia_num.GetItemNumber(1,'sw_marquilla') <> 1 Then
				Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','El paquete le$$HEX1$$ed00$$ENDHEX$$do no lleva Marquilla.')
				ids_guia_num.Reset()
				dw_reporte.Reset()
				Destroy n_cts_constantes
				This.Post SetItem(row,'codigo_barras','')
				Return 2
			End if
			
			//verifica si ya se imprimio la marquilla
			If ids_guia_num.GetItemNumber(1,'sw_imp_marquilla') = 1 Then
				// se pide confirmacion para la impresion
				ll_band = MessageBox('Pregunta','Este paquete ya fue impreso, $$HEX1$$bf00$$ENDHEX$$Desea Reimprimir? SI/NO ',Question!,YesNo!,2)
		
				// si respondieron que si
				If ll_band = 1 Then
				Else
					Destroy n_cts_constantes
					ids_guia_num.Reset()
					dw_reporte.Reset()
					This.Post SetItem(row,'codigo_barras','')
					Return 2
				End if
			End if
			
			//cambia la foto
			p_1.PictureName = Trim(ids_guia_num.GetItemString(1,'ruta_foto')) + '\' + String(ids_guia_num.GetItemNumber(1,'co_producto')) + '.jpg'
			//consulta la informacion para la impresion de marquilla
			Parent.TriggerEvent("ue_consultar") 
		//no trae datos
		ElseIf ll_reg = 0 Then
			Post MessageBox('Advertencia','El codigo de barras ' + Trim(data) + ' no pertenece a la OC ' + String(ll_ordencorte) + &
					' $$HEX2$$f3002000$$ENDHEX$$la marquilla para esta referencia no esta definida para esta impresora.')
			Destroy n_cts_constantes
			dw_reporte.Reset()
			This.Post SetItem(row,'codigo_barras','')
			Return 2
		Else
			Post MessageBox('Advertencia','Ocurrio un inconveniente al consultar la informaci$$HEX1$$f300$$ENDHEX$$n para el codigo de barras ' + Trim(data))
			Destroy n_cts_constantes
			dw_reporte.Reset()
			This.Post SetItem(row,'codigo_barras','')
			Return 2
		End if
End Choose

Destroy n_cts_constantes
end event

type p_1 from picture within w_impresion_marquillas_etiquetas
integer x = 2025
integer y = 44
integer width = 1751
integer height = 388
boolean bringtotop = true
boolean focusrectangle = false
end type

type dw_oc_x_canastas from datawindow within w_impresion_marquillas_etiquetas
integer x = 3781
integer y = 40
integer width = 699
integer height = 396
integer taborder = 20
boolean bringtotop = true
string title = "Bolsas impresas por OC"
string dataobject = "d_sq_gr_oc_x_canastas_imp"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_parametros from groupbox within w_impresion_marquillas_etiquetas
integer x = 50
integer y = 32
integer width = 1929
integer height = 392
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda"
end type

