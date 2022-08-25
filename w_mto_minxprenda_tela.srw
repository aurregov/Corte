HA$PBExportHeader$w_mto_minxprenda_tela.srw
forward
global type w_mto_minxprenda_tela from w_base_maestrotb_detalletb
end type
end forward

global type w_mto_minxprenda_tela from w_base_maestrotb_detalletb
integer width = 3465
integer height = 2088
string title = "Minutos por Prenda Tela"
string menuname = "m_mantenimiento_minutos"
end type
global w_mto_minxprenda_tela w_mto_minxprenda_tela

type variables
DataWindowChild idc_detalle
Long ii_centro, ii_tipoprod_prendas
end variables

on w_mto_minxprenda_tela.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_minutos" then this.MenuID = create m_mantenimiento_minutos
end on

on w_mto_minxprenda_tela.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;Long ll_tipoprod,ll_fila
Long li_centro,li_subcentro,li_fabrica,li_linea,li_tipotela
DataWindowChild ldc_subcentro, ldc_estilos, ldc_lineas
n_cts_constantes luo_constantes

dw_maestro.SetTransObject(sqlca)
dw_detalle.SetTransObject(sqlca)

luo_constantes = Create n_cts_constantes

ii_centro = luo_constantes.of_consultar_numerico("CENTRO CORTE")

IF ii_centro = -1 THEN
	Return
END IF

ii_tipoprod_prendas = luo_constantes.of_consultar_numerico("PRENDAS")

IF ii_tipoprod_prendas = -1 THEN
	Return
END IF

dw_maestro.GetChild('co_subcentro_pdn',ldc_subcentro)
dw_maestro.GetChild('co_tipo_tela',ldc_estilos)
dw_detalle.GetChild('co_proceso_pdn',idc_detalle)

ldc_subcentro.SetTransObject(sqlca)
ldc_estilos.SetTransObject(sqlca)
idc_detalle.SetTransObject(sqlca)

ldc_subcentro.Retrieve(ii_tipoprod_prendas, ii_centro)
ldc_estilos.Retrieve(ii_tipoprod_prendas)
idc_detalle.Retrieve(ii_centro)

dw_maestro.Retrieve()
dw_maestro.SetFocus()

ll_fila = dw_maestro.GetRow()

IF ll_fila > 0 THEN
	dw_maestro.AcceptText()
	
	
	ll_tipoprod = dw_maestro.GetItemnumber(ll_fila,'co_tipoprod')
	li_centro = dw_maestro.GetItemNumber(ll_fila,'co_centro_pdn')
	li_subcentro = dw_maestro.GetItemNumber(ll_fila,'co_subcentro_pdn')
	li_fabrica = dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
	li_linea = dw_maestro.GetItemNumber(ll_fila,'co_linea')
	li_tipotela = dw_maestro.GetItemNumber(ll_fila,'co_tipo_tela')
	
	
	dw_detalle.Retrieve(ll_tipoprod,li_centro,li_subcentro,li_fabrica,li_linea,li_tipotela)
END IF
end event

event ue_grabar;Long ll_fila,ll_tipoprod,ll_i
Long li_centro,li_subcentro,li_fabrica,li_linea,li_tipotela

dw_maestro.AcceptText()

ll_fila = dw_maestro.GetRow()

ll_tipoprod = dw_maestro.GetItemNumber(ll_fila,'co_tipoprod')
li_centro = dw_maestro.GetItemNumber(ll_fila,'co_centro_pdn')
li_subcentro = dw_maestro.GetItemNumber(ll_fila,'co_subcentro_pdn')
li_fabrica = dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
li_linea = dw_maestro.GetItemNumber(ll_fila,'co_linea')
li_tipotela = dw_maestro.GetItemNumber(ll_fila,'co_tipo_tela')

dw_detalle.AcceptText()

For ll_i = 1 To dw_detalle.RowCount()
	
	If isnull(dw_detalle.GetItemNumber(ll_i,'co_tipoprod')) Then

		dw_detalle.SetItem(ll_i,'co_tipoprod',ll_tipoprod)
		dw_detalle.SetItem(ll_i,'co_centro_pdn',li_centro)
		dw_detalle.SetItem(ll_i,'co_subcentro_pdn',li_subcentro)
		dw_detalle.SetItem(ll_i,'co_fabrica',li_fabrica)
		dw_detalle.SetItem(ll_i,'co_linea',li_linea)
		dw_detalle.SetItem(ll_i,'co_tipo_tela',li_tipotela)
		dw_detalle.SetItem(ll_i,'fe_creacion',f_fecha_servidor())
		dw_detalle.SetItem(ll_i,'fe_actualizacion',f_fecha_servidor())
		dw_detalle.SetItem(ll_i,'usuario',gstr_info_usuario.codigo_usuario)
		dw_detalle.SetItem(ll_i,'instancia',gstr_info_usuario.instancia)
		
	End if
Next

dw_detalle.AcceptText()

If dw_detalle.Update() = -1 Then
	MessageBox('Error','No fue posible actualizar la informaci$$HEX1$$f300$$ENDHEX$$n')
Else
	Commit;
End if

end event

event ue_insertar_maestro;Long ll_fila
//////////////////////////////////////////////////////////////////
// En este evento ademas de que hereda lo del padre, se le 
// adicionaron las siguientes lineas, con el proposito
// de obtener la fila actual en el maestro e iluminarla. 
////////////////////////////////////////////////////////////////
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
  	  dw_maestro.SetItem(il_fila_actual_maestro, 'co_tipoprod', ii_tipoprod_prendas)
	  dw_maestro.SetItem(il_fila_actual_maestro, 'co_centro_pdn', ii_centro)
	 // dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
ELSE
END IF
end event

event ue_insertar_detalle;Long ll_fila

ll_fila = dw_detalle.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
ELSE
	dw_detalle.SetRow(ll_fila)
	dw_detalle.ScrollToRow(ll_fila)
	dw_detalle.SetColumn(1)
	il_fila_actual_detalle = ll_fila
   
	dw_detalle.SelectRow(il_fila_actual_detalle,FALSE)
	il_fila_actual_detalle = dw_detalle.GetRow()

	IF ((il_fila_actual_detalle<> -1) and (NOT ISNULL (il_fila_actual_detalle)) and (il_fila_actual_detalle<>0))THEN
   	dw_detalle.SelectRow(il_fila_actual_detalle,TRUE)
	//	dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", DateTime(Today(), Now()))		
	ELSE
	END IF
END IF

end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_mto_minxprenda_tela
integer x = 23
integer width = 2231
integer height = 1292
string dataobject = "dtb_minxprenda_maestro"
end type

event dw_maestro::itemchanged;String ls_linea
Long ll_tipoprod,ll_fila
Long li_centro,li_subcentro,li_fabrica,li_linea,li_tipotela,li_bandera
DataWindowChild ldc_lineas


This.AcceptText()

ll_fila = This.getRow()

CHOOSE CASE GetColumnName()
	CASE 'co_fabrica'
		li_fabrica = This.GetItemNumber(ll_fila,'co_fabrica')
		This.GetChild('co_linea', ldc_lineas)
		ldc_lineas.SetTransObject(SQLCA)
		ldc_lineas.Retrieve(li_fabrica)
	CASE 'co_linea'
	Case 'co_subcentro_pdn'
		ll_fila = dw_maestro.GetRow()
		dw_maestro.AcceptText()
		li_centro = dw_maestro.GetItemNumber(ll_fila,'co_centro_pdn')
		li_subcentro = dw_maestro.GetItemNumber(ll_fila,'co_subcentro_pdn')
		li_fabrica = dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
		li_linea = dw_maestro.GetItemNumber(ll_fila,'co_linea')
		li_tipotela = dw_maestro.GetItemNumber(ll_fila,'co_tipo_tela')
	
		idc_detalle.Retrieve(li_subcentro)
		dw_detalle.Retrieve(ii_tipoprod_prendas, li_centro, li_subcentro, li_fabrica, li_linea, li_tipotela)
END CHOOSE

If (isnull(ls_linea) Or ls_linea = '') And li_bandera = 1 Then
	This.SetItem(ll_fila,'de_linea','ERROR')
End if
end event

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long ll_tipoprod,ll_fila
Long li_centro,li_subcentro,li_fabrica,li_linea,li_tipotela

ll_fila = dw_maestro.GetRow()

dw_maestro.AcceptText()


ll_tipoprod = dw_maestro.GetItemNumber(ll_fila,'co_tipoprod')
li_centro = dw_maestro.GetItemNumber(ll_fila,'co_centro_pdn')
li_subcentro = dw_maestro.GetItemNumber(ll_fila,'co_subcentro_pdn')
li_fabrica = dw_maestro.GetItemNumber(ll_fila,'co_fabrica')
li_linea = dw_maestro.GetItemNumber(ll_fila,'co_linea')
li_tipotela = dw_maestro.GetItemNumber(ll_fila,'co_tipo_tela')


dw_detalle.Retrieve(ll_tipoprod,li_centro,li_subcentro,li_fabrica,li_linea,li_tipotela)
end event

event dw_maestro::clicked;Long ll_fila

This.AcceptText()

For ll_fila = 1 To This.RowCount()
	This.SelectRow(ll_fila,FALSE)
Next

IF IsSelected (Row ) = FALSE THEN
	This.SelectRow(Row,TRUE)
ELSE 
	This.SelectRow(Row,FALSE)
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_mto_minxprenda_tela
boolean visible = false
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_mto_minxprenda_tela
boolean visible = false
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_mto_minxprenda_tela
integer x = 2272
integer y = 112
integer width = 1129
integer height = 1292
string dataobject = "dtb_minxprenda_detalle"
end type

event dw_detalle::itemchanged;Long ll_fila,ll_tipoprod
Long li_centro,li_subcentro,li_proceso
String ls_proceso

dw_maestro.AcceptText()
dw_detalle.AcceptText()
ll_fila = dw_maestro.GetRow()

CHOOSE CASE GetColumnName()
	CASE 'co_proceso_pdn'
		ll_tipoprod = 1
//		li_centro = 1
//		li_subcentro = 1
		li_centro = dw_maestro.GetItemNumber(ll_fila,'co_centro_pdn')
		li_subcentro = dw_maestro.GetItemNumber(ll_fila,'co_subcentro_pdn')
		li_proceso = dw_detalle.GetItemNumber(dw_detalle.GetRow(),'co_proceso_pdn')
						
		select de_proceso_pdn
		into :ls_proceso
		from m_procesos_pdn
		where co_tipoprod = :ll_tipoprod AND
				co_centro_pdn = :li_centro AND
				co_subcentro_pdn = :li_subcentro AND 
				co_proceso_pdn = :li_proceso;	

		dw_detalle.SetItem(dw_detalle.GetRow(),'de_proceso_pdn',ls_proceso)

END CHOOSE

end event

event dw_detalle::clicked;call super::clicked;Long ll_fila,ll_subcentro

ll_fila = dw_maestro.GetRow()

ll_subcentro = dw_maestro.GetItemNumber(ll_fila,'co_subcentro_pdn')

idc_detalle.retrieve(ll_subcentro)
end event

