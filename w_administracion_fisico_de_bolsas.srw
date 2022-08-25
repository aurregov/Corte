HA$PBExportHeader$w_administracion_fisico_de_bolsas.srw
forward
global type w_administracion_fisico_de_bolsas from w_base_maestrotb_detalletb
end type
type cb_1 from commandbutton within w_administracion_fisico_de_bolsas
end type
end forward

global type w_administracion_fisico_de_bolsas from w_base_maestrotb_detalletb
integer width = 3689
integer height = 1808
string title = "Inventario F$$HEX1$$ed00$$ENDHEX$$sico de Bongos"
cb_1 cb_1
end type
global w_administracion_fisico_de_bolsas w_administracion_fisico_de_bolsas

on w_administracion_fisico_de_bolsas.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_administracion_fisico_de_bolsas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

event ue_insertar_maestro;call super::ue_insertar_maestro;dw_maestro.setItem(il_fila_actual_maestro,"cs_canasta",Trim(String(f_crear_bolsa()))) 
dw_maestro.Setitem(il_fila_actual_maestro,"fe_creacion",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"fe_actualizacion",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"usuario",gstr_info_usuario.codigo_usuario)
dw_maestro.Setitem(il_fila_actual_maestro,"instancia",gstr_info_usuario.instancia)
dw_maestro.Setitem(il_fila_actual_maestro,"fe_estado_date",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"fe_envio",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"fe_expiracion",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"ano_mes",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"packer_id",gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(il_fila_actual_maestro,'atributo1','M')

dw_maestro.AcceptText()

end event

event ue_insertar_detalle;call super::ue_insertar_detalle;String ls_cs_canasta

ls_cs_canasta = dw_maestro.GetitemString(il_fila_actual_maestro,"cs_canasta")

dw_detalle.Setitem(il_fila_actual_detalle,"cs_canasta",ls_cs_canasta)
dw_detalle.Setitem(il_fila_actual_detalle,"fe_expiracion",datetime(Today(),Now()))
dw_detalle.Setitem(il_fila_actual_detalle,"fe_creacion",datetime(Today(),Now()))
dw_detalle.Setitem(il_fila_actual_detalle,"fe_actualizacion",datetime(Today(),Now()))
dw_detalle.Setitem(il_fila_actual_detalle,"usuario",gstr_info_usuario.codigo_usuario)
dw_detalle.Setitem(il_fila_actual_detalle,"instancia",gstr_info_usuario.instancia)
dw_detalle.AcceptText()
end event

event open;call super::open;//f_rcpra_dtos_dddw_param(dw_maestro,"co_fabrica",SQLCA,0)
////f_rcpra_dtos_dddw_param(dw_maestro,"co_planta",SQLCA,0)
//f_rcpra_dtos_dddw_param(dw_maestro,"co_centro_pdn",SQLCA,0)
//f_rcpra_dtos_dddw_param(dw_maestro,"co_subcentro_pdn",SQLCA,0)
//
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_administracion_fisico_de_bolsas
integer y = 104
integer width = 3543
integer height = 588
string title = "Encabezado del Bongo "
string dataobject = "dtb_administracion_h_canasta_corte"
boolean hsplitscroll = true
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;string ls_cs_canasta
IF il_fila_actual_maestro > 0 THEN
	ls_cs_canasta = Trim(dw_maestro.GetitemString(il_fila_actual_maestro,"cs_canasta"))
	dw_detalle.Retrieve(ls_cs_canasta)
ELSE
	dw_detalle.Reset()
END IF
end event

event dw_maestro::itemchanged;call super::itemchanged;Long ll_co_centro_pdn
dw_maestro.Setitem(il_fila_actual_maestro,"fe_actualizacion",datetime(Today(),Now()))
dw_maestro.Setitem(il_fila_actual_maestro,"usuario",gstr_info_usuario.codigo_usuario)
dw_maestro.Setitem(il_fila_actual_maestro,"instancia",gstr_info_usuario.instancia)
dw_maestro.AcceptText()

IF Dwo.Name = 'co_centro_pdn' THEN
	ll_co_centro_pdn = Long(data)	
	IF ll_co_centro_pdn = 1 THEN
		dw_maestro.Setitem(il_fila_actual_maestro,"co_planta",1)
		dw_maestro.Setitem(il_fila_actual_maestro,"co_subcentro_pdn",5)
	ELSE 	
		IF ll_co_centro_pdn = 2 THEN
			dw_maestro.Setitem(il_fila_actual_maestro,"co_planta",2)
//			dw_maestro.Setitem(il_fila_actual_maestro,"co_subcentro_pdn",2)		
//		ELSE 	
//			MessageBox("Error","Seleccione el tipo de Inventario: CORTE o CONFECCION ",Stopsign!,OK!)
		END IF
	END IF
	dw_maestro.AcceptText()
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_administracion_fisico_de_bolsas
boolean visible = false
integer x = 622
integer width = 654
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_administracion_fisico_de_bolsas
boolean visible = false
integer width = 526
string text = "Buscar por recipiente #:"
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_administracion_fisico_de_bolsas
integer y = 704
integer width = 3543
integer height = 876
string title = "Detalle del Bongo:"
string dataobject = "dtb_administracion_dt_canasta_corte"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event dw_detalle::itemchanged;call super::itemchanged;Long ll_ca_actual , ll_cs_orden_corte, ll_cs_agrupacion
dw_detalle.Setitem(il_fila_actual_detalle,"fe_actualizacion",datetime(Today(),Now()))
dw_detalle.Setitem(il_fila_actual_detalle,"usuario",gstr_info_usuario.codigo_usuario)
dw_detalle.Setitem(il_fila_actual_detalle,"instancia",gstr_info_usuario.instancia)
dw_detalle.AcceptText()

IF Dwo.Name = 'ca_actual' THEN
	This.Accepttext()
	ll_ca_actual = Long(data)

	dw_detalle.GetItemNumber(il_fila_actual_detalle, "ca_actual")
	dw_detalle.Setitem(il_fila_actual_detalle,"ca_inicial",ll_ca_actual)
	dw_detalle.AcceptText()
END IF
IF Dwo.Name = 'cs_orden_corte' THEN
	ll_cs_orden_corte = Long(data)
	SELECT UNIQUE dt_rayas_telaxoc.cs_agrupacion 
	INTO :ll_cs_agrupacion
	FROM dt_rayas_telaxoc
	WHERE dt_rayas_telaxoc.cs_orden_corte = :ll_cs_orden_corte ;
	
	dw_detalle.Setitem(il_fila_actual_detalle,"cs_agrupacion",ll_cs_agrupacion)
//	SELECT dt_rayas_telaxoc unique  cs_agrupacion
//	This.Accepttext()
//	dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_actual")
//	dw_maestro.Setitem(il_fila_actual_maestro,"ca_inicial",ll_ca_actual)
//	dw_detalle.AcceptText()
END IF
end event

event dw_detalle::clicked;call super::clicked;s_base_parametros lstr_parametros
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


//IF This.GetColumnName() = "lote" THEN
//   	
//	this.AcceptText()
//	ll_fila_actual_detalle = this.Getrow()
//	ll_co_parte = this.GetItemNumber(ll_fila_actual_detalle,"co_parte")
//	lstr_parametros.entero[1] = ll_co_parte
//	OpenWithParm(w_buscar_lista_niveles,lstr_parametros)
//	lstr_parametros=message.powerObjectparm
//	IF lstr_parametros.hay_parametros THEN
//	   ll_co_caracteristica    = lstr_parametros.entero[1]
//  	   ls_de_caracteristica    = lstr_parametros.cadena[1]
//		this.SetItem(row,"co_caracteristica",ll_co_caracteristica)	
//		this.SetItem(row,"de_caracteristica",ls_de_caracteristica)
//		this.AcceptText()
//	   this.setcolumn("ca_partes")
//	END IF   
//END IF
//
end event

event dw_detalle::doubleclicked;call super::doubleclicked;Long ll_agrupa,ll_fab,ll_lin,ll_ref,ll_color
s_base_parametros lstr_parametros

ll_agrupa = dw_detalle.GetItemNumber(row,'cs_agrupacion')
ll_ref = dw_detalle.GetItemNumber(row,'co_referencia')
ll_fab = dw_detalle.GetItemNumber(row,'co_fabrica_ref')
ll_lin = dw_detalle.GetItemNumber(row,'co_linea')
ll_color = dw_detalle.GetItemNumber(row,'co_color')

lstr_parametros.entero[1] = ll_agrupa
lstr_parametros.entero[2] = ll_fab
lstr_parametros.entero[3] = ll_lin
lstr_parametros.entero[4] = ll_ref
lstr_parametros.entero[5] = ll_color


OpenWithParm(w_buscar_pdn,lstr_parametros)

lstr_parametros=message.powerObjectparm

If lstr_parametros.cadena[1] = 'SI' Then
	dw_detalle.Setitem(row,'lote',lstr_parametros.entero[1])
	dw_detalle.Setitem(row,'cs_pdn',lstr_parametros.entero[1])
	dw_detalle.AcceptText()
End if
end event

type cb_1 from commandbutton within w_administracion_fisico_de_bolsas
boolean visible = false
integer x = 1376
integer y = 8
integer width = 407
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar por Estilo"
end type

event clicked;OpenSheet(w_administracion_fisico_x_ref,Parent,1,Original! )
end event

