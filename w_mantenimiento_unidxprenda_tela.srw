HA$PBExportHeader$w_mantenimiento_unidxprenda_tela.srw
forward
global type w_mantenimiento_unidxprenda_tela from w_base_tabular
end type
end forward

global type w_mantenimiento_unidxprenda_tela from w_base_tabular
integer width = 4018
integer height = 1860
string title = "Unidades por Prenda Tela"
string menuname = "m_mantenimiento_simple"
end type
global w_mantenimiento_unidxprenda_tela w_mantenimiento_unidxprenda_tela

type variables
DataWindowChild idc_subcentro,idc_linea
end variables

on w_mantenimiento_unidxprenda_tela.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_mantenimiento_unidxprenda_tela.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;//END IF
end event

event open;call super::open;m_mantenimiento_simple.m_edicion.m_buscar.Enabled = False

dw_maestro.GetChild('co_linea',idc_linea)
dw_maestro.GetChild('co_subcentro_pdn',idc_subcentro)

idc_subcentro.SetTransObject(SQLCA)
idc_linea.SetTransObject(SQLCA)

idc_subcentro.Retrieve(2)
idc_linea.Retrieve(91)

dw_maestro.retrieve()

end event

event ue_insertar_maestro;Long ll_fila
//////////////////////////////////////////////////////////////////
// En este evento ademas de que hereda lo del padre, se le 
// adicionaron las siguientes lineas, con el proposito
// de obtener la fila actual en el maestro e iluminarla. 
////////////////////////////////////////////////////////////////

idc_subcentro.Retrieve(2)
idc_linea.Retrieve(91)

ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
END IF

dw_maestro.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = dw_maestro.GetRow()

IF ((il_fila_actual_maestro<> -1) and &
     (NOT ISNULL (il_fila_actual_maestro)) and &
	  (il_fila_actual_maestro<>0))THEN
     dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
	  dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
ELSE
END IF

end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_unidxprenda_tela
integer x = 41
integer y = 20
integer width = 3886
integer height = 1604
string dataobject = "dtb_mantenimiento_unidxprenda_tela"
end type

event dw_maestro::itemchanged;Long li_centro,li_fabrica,li_tiprod,li_tipotela,li_linea
Long ll_fila
String ls_estilo

dw_maestro.AcceptText()
ll_fila = dw_maestro.GetRow()

CHOOSE CASE GetColumnName()
	CASE 'co_centro_pdn'
		li_centro = dw_maestro.GetItemNumber(ll_fila,'co_centro_pdn')
		idc_subcentro.Retrieve(li_centro)

	CASE 'co_fabrica'
		li_fabrica = dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
		idc_linea.Retrieve(li_fabrica)
		
	CASE 'co_tipo_tela'
		li_tiprod = dw_maestro.GetItemNumber(ll_fila,'co_tipoprod')
		li_tipotela = dw_maestro.GetItemNumber(ll_fila,'co_tipo_tela')
		
		Select de_estilo
		Into :ls_estilo
		From m_estilos
		Where m_estilos.co_tipoprod = :li_tiprod And
				m_estilos.co_estilo = :li_tipotela;
		
		IF sqlca.sqlcode = -1 THEN
			MessageBox('Error','No fue posible recuperar la descripcion para el tipo de tela dado.')
			Return
		END IF
				
		dw_maestro.SetItem(ll_fila,'descripcion',ls_estilo)		
		
	CASE 'co_tipoprod'
//		li_fabrica = dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
//		li_linea = dw_maestro.GetItemNumber(ll_fila,'co_linea')
//				
//		select m_lineas.de_linea 
//		into   :ls_linea
//    	from   m_lineas
//		where  co_fabrica = :li_fabrica and
//				 co_linea= :li_linea;	
			 

		
END CHOOSE

end event

event dw_maestro::retrieveend;call super::retrieveend;Long ll_i
Long li_tiprod,li_tipotela
String ls_estilo

dw_maestro.AcceptText()

For ll_i = 1 To dw_maestro.RowCount()
	
	li_tiprod = dw_maestro.GetItemNumber(ll_i,'co_tipoprod')
	li_tipotela = dw_maestro.GetItemNumber(ll_i,'co_tipo_tela')
	
	Select de_estilo
	Into :ls_estilo
	From m_estilos
	Where m_estilos.co_tipoprod = :li_tiprod And
			m_estilos.co_estilo = :li_tipotela;
			
	dw_maestro.SetItem(ll_i,'descripcion',ls_estilo)
	
Next
end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_unidxprenda_tela
boolean visible = false
integer x = 69
integer width = 41
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_unidxprenda_tela
boolean visible = false
integer x = 0
integer y = 0
integer width = 69
end type

