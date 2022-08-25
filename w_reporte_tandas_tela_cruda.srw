HA$PBExportHeader$w_reporte_tandas_tela_cruda.srw
forward
global type w_reporte_tandas_tela_cruda from w_preview_de_impresion
end type
end forward

global type w_reporte_tandas_tela_cruda from w_preview_de_impresion
string title = "Tanda armada en bodega de tela cruda"
windowstate windowstate = maximized!
event type long ue_buscar ( )
end type
global w_reporte_tandas_tela_cruda w_reporte_tandas_tela_cruda

type variables
Datawindow idw_filtro
DataStore  ids_filtro
cst_adm_conexion icst_lectura
Datetime idtm_fecha_ini,idtm_fin
String is_programador,is_titulo="Reporte  "
Long il_tela,il_proveedor,il_cliente,il_marca,il_linea,il_estilo,&
il_optejido,il_opestilo,il_tanda
Long il_buscar_conestilo,il_buscar_sinestilo,il_buscar_contanda,il_buscar_sobrantes



end variables

forward prototypes
public function long of_buscar ()
public function long of_cargar_datos ()
end prototypes

event type long ue_buscar();
open(w_tela_cruda)

Return 1
end event

public function long of_buscar ();//por cada tipo de busqueda hay un retrieve
long ll_data1,ll_data2,ll_data3,ll_data4
Return(of_cargar_datos())





Return 1
end function

public function long of_cargar_datos ();//Opciones de busqueda


//argumentos de busqueda
il_tela=ids_filtro.GetItemnumber(1,"co_reftel_act")
il_estilo=ids_filtro.Getitemnumber(1,"cs_ordenpd_pt")

If isnull(il_tela) or isnull(il_estilo) Then
  Return 0
End If

Return 1

end function

on w_reporte_tandas_tela_cruda.create
call super::create
end on

on w_reporte_tandas_tela_cruda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;

//recibe como parametro el filtro
ids_filtro = Message.PowerObjectParm
icst_lectura = create  cst_adm_conexion
//ids_filtro = Create datastore
//dw_reporte.DataObject = 'd_ext_gr_bodega_tela_cruda'
dw_reporte.DataObject ='rtb_tandas_armadasxdia3'
dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia( ))

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

If ids_filtro.RowCount() > 0 Then

	dw_reporte.Modify("DataWindow.Print.Preview=No")
	dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
	is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
	
	If of_buscar() = 1 Then
		dw_reporte.Retrieve(il_estilo,il_tela)
	Else
		Close(This)
	
    End IF

	
Else
	Close(This)
End If



end event

event closequery;call super::closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_tandas_tela_cruda
integer height = 1584
end type

