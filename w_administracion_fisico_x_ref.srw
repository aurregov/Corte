HA$PBExportHeader$w_administracion_fisico_x_ref.srw
forward
global type w_administracion_fisico_x_ref from w_base_tabular
end type
end forward

global type w_administracion_fisico_x_ref from w_base_tabular
integer width = 3086
integer height = 1616
string menuname = "m_mantenimiento_simple"
end type
global w_administracion_fisico_x_ref w_administracion_fisico_x_ref

on w_administracion_fisico_x_ref.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_administracion_fisico_x_ref.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_administracion_fisico_x_ref
integer width = 2935
integer height = 1196
string dataobject = "dtb_administracion_dt_canasta_corte_ref"
boolean resizable = true
end type

event dw_maestro::clicked;call super::clicked;s_base_parametros lstr_parametros
Long ll_fabrica, ll_linea, ll_referencia, ll_talla, ll_calidad, ll_color
Long     ll_tipo_nivel, ll_co_nivel, ll_fila_actual_detalle
String ls_de_nivel, ls_referencia, ls_grupo

IF Dwo.Name = "de_referencia" THEN
   ll_fila_actual_detalle = this.Getrow()
	OpenWithParm(w_buscar_lista_referencias,lstr_parametros)
	lstr_parametros=message.powerObjectparm
	IF lstr_parametros.hay_parametros THEN
	   ll_fabrica   = lstr_parametros.entero[1]
  	   ll_linea    = 	lstr_parametros.entero[2]
	   ll_referencia= lstr_parametros.entero[3]
		ll_talla    = 	lstr_parametros.entero[4]
		ll_calidad   = lstr_parametros.entero[5]
		ll_color    = 	lstr_parametros.entero[6]
		ls_referencia	=lstr_parametros.cadena[1]
		ls_grupo	  		=lstr_parametros.cadena[2]
		this.SetItem(row,"co_fabrica_ref",ll_fabrica)	
		this.SetItem(row,"co_linea",ll_linea)	
		this.SetItem(row,"co_referencia",ll_referencia)	
		this.SetItem(row,"co_talla",ll_talla)	
		this.SetItem(row,"co_calidad",ll_calidad)	
		this.SetItem(row,"co_color",ll_color)	
		this.SetItem(row,"de_referencia",ls_referencia)	
		this.SetItem(row,"gpa",ls_grupo)	
		this.AcceptText()
	END IF
END IF
end event

event dw_maestro::itemchanged;call super::itemchanged;Long ll_ca_actual , ll_cs_orden_corte, ll_cs_agrupacion
dw_maestro.Setitem(il_fila_actual_maestro,"fe_actualizacion",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"usuario",gstr_info_usuario.codigo_usuario)
dw_maestro.Setitem(il_fila_actual_maestro,"instancia",gstr_info_usuario.instancia)
dw_maestro.AcceptText()

IF Dwo.Name = 'ca_actual' THEN
	This.Accepttext()
	ll_ca_actual = Long(data)

	dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_actual")
	dw_maestro.Setitem(il_fila_actual_maestro,"ca_inicial",ll_ca_actual)
	dw_maestro.AcceptText()
END IF
IF Dwo.Name = 'cs_orden_corte' THEN
	ll_cs_orden_corte = Long(data)
	SELECT UNIQUE dt_rayas_telaxoc.cs_agrupacion 
	INTO :ll_cs_agrupacion
	FROM dt_rayas_telaxoc
	WHERE dt_rayas_telaxoc.cs_orden_corte = :ll_cs_orden_corte ;
	
	dw_maestro.Setitem(il_fila_actual_maestro,"cs_agrupacion",ll_cs_agrupacion)
END IF
end event

type sle_argumento from w_base_tabular`sle_argumento within w_administracion_fisico_x_ref
end type

type st_1 from w_base_tabular`st_1 within w_administracion_fisico_x_ref
end type

