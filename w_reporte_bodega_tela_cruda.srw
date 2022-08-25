HA$PBExportHeader$w_reporte_bodega_tela_cruda.srw
forward
global type w_reporte_bodega_tela_cruda from w_preview_de_impresion
end type
end forward

global type w_reporte_bodega_tela_cruda from w_preview_de_impresion
integer width = 2999
integer height = 2288
string menuname = "m_vista_preview_filtro_busqueda"
event type long ue_buscar ( )
end type
global w_reporte_bodega_tela_cruda w_reporte_bodega_tela_cruda

type variables
Datawindow idw_filtro
DataStore  ids_filtro,ids_param
cst_adm_conexion icst_lectura
Date idtm_fecha_ini,idtm_fin
String is_programador,is_titulo="Reporte  "
Long il_tela,il_proveedor,il_cliente,il_marca,il_linea,il_estilo,&
il_optejido,il_opestilo
String ls_marca
Long il_buscar_conestilo,il_buscar_sinestilo,il_buscar_contanda,il_buscar_sobrantes


end variables

forward prototypes
public function long of_buscar ()
public function long of_buscar_con_estilo ()
public function long of_cargar_datos ()
public function long of_buscar_sin_estilo ()
public function long of_buscar_con_tanda ()
public function long of_buscar_sobrantes ()
public function long of_mensajes (long a_con_estilo, long a_sin_estilo, long a_sobrantes, long a_ce, long a_se, long a_so)
end prototypes

event type long ue_buscar();open(w_tela_cruda)
Return 1
end event

public function long of_buscar ();//por cada tipo de busqueda hay un retrieve
long ll_data1=1,ll_data2=1,ll_data3=1,ll_data4=1
of_cargar_datos()

//si esta activo el check del filtro entra a cada funcion
If il_buscar_conestilo = 1 Then
	ll_data1=of_buscar_con_estilo()
End If	
If il_buscar_sinestilo = 1 Then
	ll_data2=of_buscar_sin_estilo()
End If
//If il_buscar_contanda = 1 Then
	//ll_data3=of_buscar_con_tanda()
//End If
If il_buscar_sobrantes = 1 Then
	ll_data4=of_buscar_sobrantes()
End If
//si hay mensaje sin retorno
if ((ll_data1=0 or ll_data2=0) Or ll_data4=0) Then
	of_mensajes(ll_data1,ll_data2,ll_data4,il_buscar_conestilo,il_buscar_sinestilo,il_buscar_sobrantes)
End If
//si no hay datos retornados en el datawindows cierra ventana
If ll_data1+ll_data2+ll_data3+ll_data4 = 0 Then
	
	Close(This)
	Return 0
End If

//hace ordenamiento y recaklcula el grupo
dw_reporte.sort()
dw_reporte.groupcalc()

Return 1




Return 1
end function

public function long of_buscar_con_estilo ();//hace el retrieve con los campos del idw
long ll_data
ids_filtro.DataObject ='d_gr_consulta_conestilo'
ids_filtro.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))	

ids_filtro.Retrieve(idtm_fecha_ini,idtm_fin,il_tela,il_proveedor,&
il_cliente,ls_marca,il_linea,il_estilo,il_optejido,il_opestilo,is_programador)
If ids_filtro.Rowcount() < 1 Then
	//Messagebox("Informacion","No se encuentran datos de OP con estilo")
	
   Return 0
End If 
//Messagebox("con",ids_filtro.Rowcount())

ll_data=ids_filtro.RowsCopy(1, &
        ids_filtro.RowCount(), Primary!, dw_reporte, 1, Primary!)

is_titulo = is_titulo+"-"+"Con OP estilo"
Return ll_data
end function

public function long of_cargar_datos ();//Opciones de busqueda
il_buscar_conestilo=idw_filtro.Getitemnumber(1,"op_conestilo")
il_buscar_sinestilo=idw_filtro.Getitemnumber(1,"op_sinestilo")
il_buscar_contanda=idw_filtro.Getitemnumber(1,"op_contanda")
//il_buscar_sobrantes=idw_filtro.Getitemnumber(1,"op_sobrantes")
il_buscar_sobrantes=idw_filtro.Getitemnumber(1,"op_disponible")

//il_buscar_conestilo=idw_filtro.Getitemnumber(1,"op_todatela")

//argumentos de busqueda
idtm_fecha_ini=idw_filtro.GetItemdaTE(1,"fecha_ini")
idtm_fin=idw_filtro.GetItemdate(1,"fecha_fin")
il_tela=idw_filtro.Getitemnumber(1,"tela")
il_proveedor=idw_filtro.Getitemnumber(1,"proovedor")
il_cliente=idw_filtro.Getitemnumber(1,"cliente")
ls_marca=idw_filtro.GetitemString(1,"marca")
il_linea=idw_filtro.Getitemnumber(1,"linea")
il_estilo=idw_filtro.Getitemnumber(1,"estilo")
il_optejido=idw_filtro.Getitemnumber(1,"optejido")
il_opestilo=idw_filtro.Getitemnumber(1,"opestilo")
is_programador=idw_filtro.GetitemString(1,"op_programador")
//si hay argumentos en nulo
If IsNull(il_tela) 		Then il_tela = 0 
If IsNull(il_proveedor) Then il_proveedor = 0
If IsNull(il_cliente)   Then il_cliente = 0
If IsNull(il_marca)     Then il_marca = 0
If IsNull(il_linea)     Then il_linea = 0
If IsNull(il_estilo) 	Then il_estilo = 0
If IsNull(il_optejido) 	Then il_optejido = 0
If IsNull(il_opestilo) 	Then il_opestilo = 0
If IsNull(is_programador)Then is_programador=""
If IsNull(ls_marca)Then ls_marca=""







Return 1
end function

public function long of_buscar_sin_estilo ();//hace el retrieve con los campos del idw
long ll_data
ids_filtro.DataObject ='d_gr_consulta_sinestilo'
ids_filtro.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))	
ids_filtro.Retrieve(idtm_fecha_ini,idtm_fin,il_tela,il_proveedor,&
il_cliente,il_marca,il_linea,il_estilo,il_optejido,il_opestilo,is_programador)
ll_data=ids_filtro.RowsCopy(1, &
        ids_filtro.RowCount(), Primary!, dw_reporte, 1, Primary!)

If ids_filtro.Rowcount() < 1 Then
	//Messagebox("Informacion","No se encuentran datos de OP sin estilo")
	Return 0
End If 
//Messagebox("sin",ids_filtro.Rowcount())
is_titulo = is_titulo+"-"+"Sin OP estilo"
Return ll_data
end function

public function long of_buscar_con_tanda ();//hace el retrieve con los campos del idw
long ll_data
ids_filtro.DataObject ='d_gr_consulta_contanda'
ids_filtro.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))	

ids_filtro.Retrieve(idtm_fecha_ini,idtm_fin,il_tela,il_proveedor,&
il_cliente,il_marca,il_linea,il_estilo,il_optejido,il_opestilo,is_programador)
If ids_filtro.Rowcount() < 1 Then
	//Messagebox("Informacion","No se encuentran datos con tanda")
   Return 0
End If 
//Messagebox("con",ids_filtro.Rowcount())

ll_data=ids_filtro.RowsCopy(1, &
        ids_filtro.RowCount(), Primary!, dw_reporte, 1, Primary!)
//Messagebox("con ll_data",ll_data)
is_titulo = is_titulo+"-"+"Con tanda"
Return ll_data
end function

public function long of_buscar_sobrantes ();//hace el retrieve con los campos del idw
long ll_data
ids_filtro.DataObject ='d_gr_consulta_sobrantes'
ids_filtro.SetTransObject (icst_lectura.of_get_transaccion_sucia( ))	
ids_filtro.Retrieve(idtm_fecha_ini,idtm_fin,il_tela,il_proveedor,&
il_cliente,il_marca,il_linea,il_estilo,il_optejido,il_opestilo,is_programador)
ll_data=ids_filtro.RowsCopy(1, &
        ids_filtro.RowCount(), Primary!, dw_reporte, 1, Primary!)

If ids_filtro.Rowcount() < 1 Then
	//Messagebox("Informacion","No se encuentran datos de sobrantes")
	Return 0
End If 
//Messagebox("sin",ids_filtro.Rowcount())
is_titulo = is_titulo+"-"+"Con Disponibles"
Return ll_data
end function

public function long of_mensajes (long a_con_estilo, long a_sin_estilo, long a_sobrantes, long a_ce, long a_se, long a_so);String ls_men,ls_mensaje

ls_mensaje= " "

If il_optejido > 0 Then
   ls_mensaje += " O.P Tejido: "+ String(il_optejido)+"~n~r"
End If

If il_opestilo > 0 Then
   ls_mensaje += " O.P Estilo: "+ String(il_opestilo)+"~n~r"
End If

If il_tela > 0 Then
	ls_mensaje += " Tela: "+ String(il_tela)+"~n~r"
End If

If il_proveedor  > 0 Then
   ls_mensaje += " Proveedor: "+ String(il_proveedor)+"~n~r"
End If

If il_cliente > 0 Then
   ls_mensaje += " Cliente: "+ String(il_cliente)+"~n~r"
End If

If il_marca > 0 Then
   ls_mensaje += " Marca: "+ String(il_marca)+"~n~r"
End If

If il_linea > 0 Then
   ls_mensaje += " Linea: "+ String(il_linea)+"~n~r"
End If

If il_estilo > 0 Then
   ls_mensaje += " Estilo: "+ String(il_estilo)+"~n~r"
End If
If not isnull(is_programador) and is_programador<>"" Then
   ls_mensaje += " Programador: "+ is_programador+"~n~r"
End If


//falta mirar el mensaje cuando no se encuentra programador

If a_con_estilo=0 and a_ce=1 Then 
	   ls_men="No se encuentran datos de OP con estilo"+"~n~r"
End If
If a_sin_estilo=0 and a_se=1 Then 
	   ls_men=ls_men+"No se encuentran datos de OP sin estilo"+"~n~r"
End If

If a_sobrantes=0 and a_se= 1 Then 
	   ls_men=ls_men+"No se encuentran datos de OP con Disponibles"+"~n~r"
End If

If idtm_fecha_ini<> date("1900-1-1") and idtm_fin <>date("1900-1-1")  Then
	ls_men=ls_men+"No hay datos en este rango de fechas"+"~n~r"
End If

Messagebox("Informaci$$HEX1$$f200$$ENDHEX$$n",ls_men+"~n~r"+ls_mensaje)



/*i
il_tela=idw_filtro.Getitemnumber(1,"tela")
il_proveedor=idw_filtro.Getitemnumber(1,"proovedor")
il_cliente=idw_filtro.Getitemnumber(1,"cliente")
il_marca=idw_filtro.Getitemnumber(1,"marca")
il_linea=idw_filtro.Getitemnumber(1,"linea")
il_estilo=idw_filtro.Getitemnumber(1,"estilo")
il_optejido=idw_filtro.Getitemnumber(1,"optejido")
il_opestilo=idw_filtro.Getitemnumber(1,"opestilo")
is_programador=idw_filtro.GetitemString(1,"op_programador")
*/



Return 1
end function

on w_reporte_bodega_tela_cruda.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_preview_filtro_busqueda" then this.MenuID = create m_vista_preview_filtro_busqueda
end on

on w_reporte_bodega_tela_cruda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;

//recibe como parametro el filtro
idw_filtro = Message.PowerObjectParm
icst_lectura = create  cst_adm_conexion
ids_filtro = Create datastore

//dw_reporte.DataObject = 'd_ext_gr_bodega_tela_cruda'
dw_reporte.DataObject ='d_gr_consulta_conestilo3'
dw_reporte.settransobject(sqlca)

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

If idw_filtro.RowCount() > 0 Then

	dw_reporte.Modify("DataWindow.Print.Preview=No")
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
	is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
	If of_buscar() = 1 Then
		This.Title=is_titulo
	End IF
Else
	Close(This)
End If



end event

event closequery;call super::closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_bodega_tela_cruda
end type

event dw_reporte::doubleclicked;call super::doubleclicked;long ll_data,ll_tanda
ids_param = Create datastore
ids_param.DataObject =dw_reporte.dataobject
//si no tiene tanda retorna la funcion
//If il_buscar_contanda <> 1 Then Return 0 
//si existe registro al hacer click
If Row > 0 Then

	ll_data=dw_reporte.RowsCopy(row, &
        row, Primary!, ids_param, 1, Primary!)
	//si el rowcopy adiciona bien los parametros	
	If ll_data > 0 Then
		OpenSheetWithParm(w_reporte_tandas_tela_cruda,ids_param, &
            	Parent, 2,Layered!)
	End If
End If	

end event

