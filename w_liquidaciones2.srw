HA$PBExportHeader$w_liquidaciones2.srw
forward
global type w_liquidaciones2 from w_base_maestrotb_detalletb_para_tabs
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type dw_encabezado from datawindow within w_liquidaciones2
end type
type dw_otros from uo_dtwndow within w_liquidaciones2
end type
type dw_unidades from uo_dtwndow within w_liquidaciones2
end type
end forward

global type w_liquidaciones2 from w_base_maestrotb_detalletb_para_tabs
integer width = 3013
integer height = 1604
string title = "Administraci$$HEX1$$f300$$ENDHEX$$n Liquidaciones"
string menuname = "m_liquidacion"
event ue_liquidar pbm_custom07
event ue_devolver pbm_custom08
event ue_asignar_desasignar pbm_custom09
dw_encabezado dw_encabezado
dw_otros dw_otros
dw_unidades dw_unidades
end type
global w_liquidaciones2 w_liquidaciones2

type variables
Long il_orden_corte, il_modelo, il_reftel, il_trazo, il_color_te, il_agrupacion, il_color_pt
Long ii_produccion, ii_fabrica, ii_caract,ii_raya
Long ii_diametro, ii_seccion, ii_base
end variables

event ue_liquidar;Long li_liquidacion, li_estado, li_pos_cortar, li_pos_inicial, ll_hallados, li_respuesta, ll_continua
String ls_tipo
s_base_parametros lstr_parametros_retro
Long ll_rollos_nohabilitados, ll_sw_automatico, ll_resultado
Decimal ll_kilos_retal
Datetime ldt_fe_real_inicio
		
IF il_fila_actual_maestro > 0 THEN		
	IF dw_detalle.RowCount() > 0 THEN
		li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
		li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
		IF IsNull(li_liquidacion) THEN
			MessageBox("Advertencia","No ha grabado la liquidacion")
			Return
		END IF
		IF li_estado = 3 OR li_estado = 4 THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
				
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)			
			DECLARE liquidar PROCEDURE FOR
				pr_liq_oc_nueva(:il_orden_corte, :il_agrupacion, :ii_produccion, :il_modelo, :ii_fabrica, 
							:il_reftel, :ii_caract, :ii_diametro, :il_color_te, :il_trazo, :ii_seccion, 
							:ii_base, :li_liquidacion);
			EXECUTE liquidar;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
					ROLLBACK;
				ELSE
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
					ROLLBACK;
				END IF
			ELSE
				COMMIT;
			END IF
			dw_encabezado.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
								ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
			ll_hallados = dw_maestro.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
								ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
			IF isnull(ll_hallados) THEN
				MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
			ELSE
				CHOOSE CASE ll_hallados
					CASE -1
						il_fila_actual_maestro = -1
						MessageBox("Error buscando","Error de la base",StopSign!,&
									 Ok!)
					CASE 0
						il_fila_actual_maestro = 0
						MessageBox("Sin Datos","No hay datos para su criterio",&
									 Exclamation!,Ok!)
					CASE ELSE
						il_fila_actual_maestro = 1
				END CHOOSE
			END IF
			dw_maestro.TriggerEvent("RowFocusChanged")			
			Close(w_retroalimentacion)
		ELSE
			MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n esta debe estar preparada")
		END IF
	ELSE
		MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n debe asignar primero rollos")
	END IF
ELSE
	MessageBox("Advertencia","Para realizar la liquidaci$$HEX1$$f300$$ENDHEX$$n tiene que seleccionar primero un registro de liquidaci$$HEX1$$f300$$ENDHEX$$n")
END IF
end event

event ue_devolver;Long li_liquidacion, li_estado, li_pos_cortar, li_pos_inicial, ll_hallados
Long li_estado_oc
String ls_tipo
s_base_parametros lstr_parametros_retro
		
IF il_fila_actual_maestro > 0 THEN		
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
	li_estado_oc = dw_encabezado.GetItemNumber(1, "co_estado")
	IF IsNull(li_liquidacion) THEN
		MessageBox("Advertencia","No ha grabado la liquidacion")
	ELSE
		IF li_estado = 6 AND (li_estado_oc = 5 OR li_estado_oc = 6) THEN
			lstr_parametros_retro.cadena[1]="Procesando ..."
			lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
			lstr_parametros_retro.cadena[3]="reloj"
		
			OpenWithParm(w_retroalimentacion,lstr_parametros_retro)						
			DECLARE devolver PROCEDURE FOR
				pr_devliq_ordencr(:il_orden_corte, :il_agrupacion, :ii_produccion, :il_modelo, :ii_fabrica, 
							:il_reftel, :ii_caract, :ii_diametro, :il_color_te, :il_trazo, :ii_seccion, 
							:ii_base, :li_liquidacion);
			EXECUTE devolver;
			IF SQLCA.SQLCode = -1 THEN			
				IF SQLCA.SQLDBCode = -746 THEN
					li_pos_cortar = Pos(SQLCA.SQLErrText, 'No changes', 1)
					li_pos_inicial = Pos(SQLCA.SQLErrText, ':', 1)
					MessageBox("Error Base Datos", Mid(SQLCA.SQLErrText, li_pos_inicial + 1, Len(SQLCA.SQLErrText) - (li_pos_inicial + 1)))
				ELSE
					MessageBox("Error Base Datos","Error al ejecutar el stored procedure")
				END IF
				ROLLBACK;
			ELSE
				COMMIT;
			END IF
			Close(w_retroalimentacion)
			dw_encabezado.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
								ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
			ll_hallados = dw_maestro.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
								ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
			IF isnull(ll_hallados) THEN
				MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
			ELSE
				CHOOSE CASE ll_hallados
					CASE -1
						il_fila_actual_maestro = -1
						MessageBox("Error buscando","Error de la base",StopSign!,&
									 Ok!)
					CASE 0
						il_fila_actual_maestro = 0
						MessageBox("Sin Datos","No hay datos para su criterio",&
									 Exclamation!,Ok!)
					CASE ELSE
						il_fila_actual_maestro = 1
				END CHOOSE
			END IF			
			dw_maestro.TriggerEvent("RowFocusChanged")						
		ELSE
			MessageBox("Advertencia","Para poder devolver una liquidacion esta debe estar liquidada")
		END IF
	END IF
ELSE
	MessageBox("Advertencia","Para devolver la liquidaci$$HEX1$$f300$$ENDHEX$$n tiene que seleccionar primero un registro de liquidaci$$HEX1$$f300$$ENDHEX$$n")
END IF
end event

on w_liquidaciones2.create
int iCurrent
call super::create
if this.MenuName = "m_liquidacion" then this.MenuID = create m_liquidacion
this.dw_encabezado=create dw_encabezado
this.dw_otros=create dw_otros
this.dw_unidades=create dw_unidades
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_encabezado
this.Control[iCurrent+2]=this.dw_otros
this.Control[iCurrent+3]=this.dw_unidades
end on

on w_liquidaciones2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_encabezado)
destroy(this.dw_otros)
destroy(this.dw_unidades)
end on

event ue_buscar;s_base_parametros lstr_parametros
long ll_hallados
Long li_estado_orden_corte

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	OpenWithParm(w_buscar_cb_oc_raya_espacio, lstr_parametros)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		il_orden_corte = lstr_parametros.entero[1]
//		il_agrupacion = lstr_parametros.entero[2]
//		ii_produccion = lstr_parametros.entero[3]
//		il_modelo = lstr_parametros.entero[4]
//		ii_fabrica = lstr_parametros.entero[5]
//		il_reftel = lstr_parametros.entero[6]
//		ii_caract = lstr_parametros.entero[7]
//		ii_diametro = lstr_parametros.entero[8]
//		il_color_te = lstr_parametros.entero[9]
		il_trazo = lstr_parametros.entero[2]
		ii_raya = lstr_parametros.entero[3]
//		ii_base = lstr_parametros.entero[12]



		SELECT h_orden_corte.co_estado  
		INTO :li_estado_orden_corte  
		FROM h_orden_corte  
		WHERE h_orden_corte.cs_orden_corte = :il_orden_corte;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar el estado de la orden")
			Return
		END IF
		IF li_estado_orden_corte = 9 THEN 
			Close(w_retroalimentacion)
			MessageBox("Error","La Orden esta fuera de Inventario",Exclamation!,Ok!)	
			RETURN
		END IF 
	  
		dw_encabezado.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, ii_fabrica, il_reftel, &
							ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
							
		ll_hallados = dw_maestro.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, ii_fabrica, &
							il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
							
		IF isnull(ll_hallados) THEN
			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
		ELSE
			CHOOSE CASE ll_hallados
				CASE -1
					il_fila_actual_maestro = -1
					MessageBox("Error buscando","Error de la base",StopSign!,&
                         Ok!)
				CASE 0
					il_fila_actual_maestro = 0
					MessageBox("Sin Datos","No hay datos para su criterio",&
                         Exclamation!,Ok!)
				CASE ELSE
					il_fila_actual_maestro = 1
			END CHOOSE
		END IF
		dw_maestro.TriggerEvent("RowFocusChanged")
	ELSE
	END IF
ELSE
END IF
end event

event ue_insertar_maestro;call super::ue_insertar_maestro;Long li_estado, li_recuperaciones, li_tot_mod_parc
String ls_tipo

IF dw_encabezado.RowCount() > 0 THEN
	li_estado = dw_encabezado.GetItemNumber(1, "co_estado")
	 
	IF (li_estado = 2 OR li_estado = 5 OR li_estado = 7) THEN
		IF IsNull(il_orden_corte) OR IsNull(il_agrupacion) OR IsNull(ii_produccion) OR &
			IsNull(il_modelo) OR IsNull(il_trazo) OR IsNull(ii_seccion) OR IsNull(ii_fabrica) OR &
			IsNull(il_reftel) OR IsNull(ii_caract) OR IsNull(il_color_te) OR IsNull(ii_diametro) THEN
			dw_maestro.DeleteRow(il_fila_actual_maestro)
			il_fila_actual_maestro = il_fila_actual_maestro - 1		
		ELSE
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_orden_corte", il_orden_corte)
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_agrupacion", il_agrupacion)
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_pdn", ii_produccion)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_modelo", il_modelo)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica_tela", ii_fabrica)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_reftel", il_reftel)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_caract", ii_caract)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_color_te", il_color_te)
			dw_maestro.SetItem(il_fila_actual_maestro, "diametro", ii_diametro)
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_trazo", il_trazo)
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_seccion", ii_seccion)	
			dw_maestro.SetItem(il_fila_actual_maestro, "cs_base_trazos", ii_base)
			dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))
		END IF
	ELSE
		MessageBox("Advertencia","No puede hacer liquidaciones de una orden de corte por el estado en que se encuentra")
		dw_maestro.DeleteRow(il_fila_actual_maestro)
		il_fila_actual_maestro = il_fila_actual_maestro - 1			
	END IF
ELSE
	dw_maestro.DeleteRow(il_fila_actual_maestro)
	il_fila_actual_maestro = il_fila_actual_maestro - 1			
END IF
end event

event ue_insertar_detalle;Long li_liquidacion, li_estado

IF il_fila_actual_maestro > 0 THEN
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
	IF li_estado = 3 OR li_estado = 4 THEN
		idw_arreglo_dw[ii_dw_actual].TriggerEvent("adcnar_fla")
	END IF
END IF
end event

event open;Long li_dw_a_inicializar 

This.Width = 2900
This.Height = 1500
This.x = 1
This.y = 1

ii_num_dw = 3
idw_arreglo_dw[1] = dw_detalle
idw_arreglo_dw[2] = dw_unidades
idw_arreglo_dw[3] = dw_otros

dw_encabezado.SetTransObject(SQLCA)

CALL w_base_maestroff_detalletb_para_tabs::open
This.TriggerEvent("ue_buscar")
end event

event ue_borrar_detalle;Long li_estado

li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
IF li_estado = 3 OR li_estado = 4 THEN
	CALL w_base_maestrotb_detalletb_para_tabs::ue_borrar_detalle
END IF
end event

event ue_grabar;call super::ue_grabar;Long ll_hallados

dw_encabezado.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
					ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
ll_hallados = dw_maestro.Retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
					ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, ii_base)
IF isnull(ll_hallados) THEN
	MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
ELSE
	CHOOSE CASE ll_hallados
		CASE -1
			il_fila_actual_maestro = -1
			MessageBox("Error buscando","Error de la base",StopSign!,&
						 Ok!)
		CASE 0
			il_fila_actual_maestro = 0
			MessageBox("Sin Datos","No hay datos para su criterio",&
						 Exclamation!,Ok!)
		CASE ELSE
			il_fila_actual_maestro = 1
	END CHOOSE
END IF
dw_maestro.TriggerEvent("RowFocusChanged")
end event

type dw_maestro from w_base_maestrotb_detalletb_para_tabs`dw_maestro within w_liquidaciones2
integer y = 300
integer width = 2811
integer height = 320
integer taborder = 30
string dataobject = "dtb_liquidaciones_trazos"
boolean vscrollbar = true
boolean border = true
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;Long li_dw_a_inicializar, li_liquidacion, li_estado

IF il_fila_actual_maestro > 0 THEN
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado")
	li_dw_a_inicializar = 1
	DO WHILE li_dw_a_inicializar <= ii_num_dw
		IF li_dw_a_inicializar = 2 THEN
			idw_arreglo_dw[li_dw_a_inicializar].Retrieve(il_orden_corte, il_agrupacion, ii_produccion, &
				il_modelo, ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, il_trazo, ii_seccion, &
				ii_base, li_liquidacion)
		ELSE
			idw_arreglo_dw[li_dw_a_inicializar].Retrieve(il_orden_corte, il_agrupacion, ii_produccion, &
				il_modelo, ii_fabrica, il_reftel, ii_caract, ii_diametro, il_color_te, ii_base, li_liquidacion)			
		END IF
		IF li_estado = 3 OR li_estado = 4 THEN
			idw_arreglo_dw[li_dw_a_inicializar].Modify("DataWindow.ReadOnly=NO")
		ELSE
			idw_arreglo_dw[li_dw_a_inicializar].Modify("DataWindow.ReadOnly=YES")			
		END IF
		li_dw_a_inicializar++
	LOOP
ELSE
	li_dw_a_inicializar = 1
	DO WHILE li_dw_a_inicializar <= ii_num_dw
		idw_arreglo_dw[li_dw_a_inicializar].Reset()
		li_dw_a_inicializar++
	LOOP	
END IF
end event

event dw_maestro::itemchanged;Long li_tipo, li_filas

IF Dwo.Name = "tipo" THEN
	li_tipo = Long(Data)
	IF li_tipo = 1 THEN
		li_filas = This.RowCount()
		IF li_filas > 1 THEN
			MessageBox("Error","Cuando se va a realizar una liquidaci$$HEX1$$f300$$ENDHEX$$n total, no pueden existir m$$HEX1$$e100$$ENDHEX$$s liquidaciones")
			Return 1
		ELSE
			SetItem(Row, "co_estado", 4)
		END IF
	ELSE
		SetItem(Row, "co_estado", 3)
	END IF
END IF
dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
end event

event dw_maestro::updatestart;call super::updatestart;Long li_filas, li_fila_actual, li_liquidacion

li_filas = dw_maestro.Rowcount()

SELECT Max(cs_liquidacion) + 1
INTO :li_liquidacion
FROM dt_liquida_trazo
WHERE cs_orden_corte = :il_orden_corte AND
		cs_agrupacion = :il_agrupacion AND
		cs_pdn = :ii_produccion AND
		co_modelo = :il_modelo AND
		co_fabrica_tela = :ii_fabrica AND
		co_reftel = :il_reftel AND
		co_caract = :ii_caract AND
		diametro = :ii_diametro AND
		co_color_te = :il_color_te AND
		cs_trazo = :il_trazo AND
		cs_seccion = :ii_seccion;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar el consecutivo de liquidaci$$HEX1$$f300$$ENDHEX$$n")
	Return(1)
END IF
IF IsNull(li_liquidacion) THEN
	li_liquidacion = 1
END IF
FOR li_fila_actual = 1 TO li_filas
	IF dw_maestro.GetItemStatus(li_fila_actual, 0, Primary!) = NewModified! THEN
		dw_maestro.SetItem(li_fila_actual, "cs_liquidacion", li_liquidacion)
		li_liquidacion = li_liquidacion + 1
	END IF
NEXT
end event

type tab_1 from w_base_maestrotb_detalletb_para_tabs`tab_1 within w_liquidaciones2
integer x = 5
integer y = 640
integer width = 2139
integer taborder = 60
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_2
this.Control[iCurrent+2]=this.tabpage_3
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from w_base_maestrotb_detalletb_para_tabs`tabpage_1 within tab_1
integer width = 2103
string text = "Rollos Liquidaci$$HEX1$$f300$$ENDHEX$$n"
string picturename = "Custom057!"
end type

type dw_detalle from w_base_maestrotb_detalletb_para_tabs`dw_detalle within w_liquidaciones2
integer x = 9
integer y = 876
integer width = 2853
integer height = 532
string dataobject = "dtb_rollos_liquidacion_trazos_detalle"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

event dw_detalle::adcnar_fla;Long li_liquidacion, li_rollo
Long ll_fila
s_base_parametros lstr_parametros

IF il_fila_actual_maestro > 0 THEN
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")	
	lstr_parametros.entero[1] = il_orden_corte
	lstr_parametros.entero[2] = il_agrupacion
	lstr_parametros.entero[3] = ii_produccion
	lstr_parametros.entero[4] = il_modelo
	lstr_parametros.entero[5] = ii_fabrica
	lstr_parametros.entero[6] = il_reftel
	lstr_parametros.entero[7] = ii_caract
	lstr_parametros.entero[8] = ii_diametro
	lstr_parametros.entero[9] = il_color_te
	lstr_parametros.entero[10] = ii_base
	lstr_parametros.entero[11] = li_liquidacion
//	OpenWithParm(w_seleccionar_rollos, lstr_parametros)
//	lstr_parametros = Message.PowerObjectParm
//	IF lstr_parametros.hay_parametros THEN
//		FOR li_rollo = 2 TO lstr_parametros.entero[1]
			ll_fila = idw_arreglo_dw[ii_dw_actual].InsertRow(0)			
			IF ( ll_fila > 0) THEN
				This.SetItem(ll_fila, "cs_orden_corte", il_orden_corte)
				This.SetItem(ll_fila, "cs_agrupacion", il_agrupacion)
				This.SetItem(ll_fila, "cs_pdn", ii_produccion)
				This.SetItem(ll_fila, "co_modelo", il_modelo)
				This.SetItem(ll_fila, "co_fabrica_tela", ii_fabrica)
				This.SetItem(ll_fila, "co_reftel", il_reftel)
				This.SetItem(ll_fila, "co_caract", ii_caract)
				This.SetItem(ll_fila, "diametro", ii_diametro)
				This.SetItem(ll_fila, "co_color_te", il_color_te)
				This.SetItem(ll_fila, "cs_base_trazos", ii_base)				
				This.SetItem(ll_fila, "cs_liquidacion", li_liquidacion)
//				This.SetItem(ll_fila, "cs_rollo", lstr_parametros.entero[li_rollo])
//				This.SetItem(ll_fila, "ca_cortados", lstr_parametros.decimal[li_rollo])
				This.SetItem(ll_fila, "fe_creacion", DateTime(Today(), Now()))				
			ELSE
				MessageBox("Error DataWindows","Error al insertar una nueva fila")
				Return
			END IF			
//		NEXT
//	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
END IF
end event

event dw_detalle::itemchanged;call super::itemchanged;Long ll_cs_rollo

IF Dwo.Name = 'cs_rollo' THEN
	ll_cs_rollo = Long(Data)

	IF Not IsNull(ll_cs_rollo)  THEN
		//Valida que el rollo exista y que pertenezca a la orden y trae cantidades
		//dw_unidades.SetItem(Row, "ca_unidades_cortad", ll_unidades)
	END IF
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2103
integer height = 112
long backcolor = 79741120
string text = "Unidades"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ArrangeIcons!"
long picturemaskcolor = 553648127
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2103
integer height = 112
long backcolor = 79741120
string text = "Resumen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom089!"
long picturemaskcolor = 553648127
end type

type dw_encabezado from datawindow within w_liquidaciones2
integer x = 41
integer y = 8
integer width = 2894
integer height = 288
integer taborder = 20
boolean bringtotop = true
string dataobject = "dff_consulta_trazos_liquidacionxespacio"
boolean livescroll = true
end type

type dw_otros from uo_dtwndow within w_liquidaciones2
integer x = 9
integer y = 876
integer width = 2853
integer height = 532
integer taborder = 50
string dataobject = "dtb_resumen_consumo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event updatestart;Long li_consecutivo, li_liquidacion, li_filas, li_fila_actual

IF il_fila_actual_maestro > 0 THEN
	IF This.ModifiedCount() > 0 THEN
		li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
		SELECT	Max(cs_consumos) + 1
		INTO		:li_consecutivo
		FROM		dt_resumen_consumo
		WHERE	cs_orden_corte = :il_orden_corte AND
				cs_agrupacion = :il_agrupacion AND
				cs_pdn = :ii_produccion AND
				co_modelo = :il_modelo AND
				co_fabrica_tela = :ii_fabrica AND
				co_reftel = :il_reftel AND
				co_caract = :ii_caract AND
				diametro = :ii_diametro AND
				co_color_te = :il_color_te AND
				cs_base_trazos = :ii_base AND
				cs_liquidacion = :li_liquidacion;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar el consecutivo")
			Return(1)
		END IF
		IF IsNull(li_consecutivo) THEN
			li_consecutivo = 1
		END IF
		li_filas = RowCount()
		FOR li_fila_actual = 1 TO li_filas
			IF GetItemStatus(li_fila_actual, 0, Primary!) = NewModified! THEN
				SetItem(li_fila_actual, "cs_consumos", li_consecutivo)
				li_consecutivo = li_consecutivo + 1
			END IF
		NEXT
	END IF
	dw_otros.AcceptText()
END IF
end event

event adcnar_fla;Long li_liquidacion
Long ll_fila
s_base_parametros lstr_parametros

IF il_fila_actual_maestro > 0 THEN
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	IF Not IsNull(li_liquidacion) THEN
		IF idw_arreglo_dw[ii_dw_actual].AcceptText() = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del detalle porque habian ingresos previos con problemas", StopSign!)	
		ELSE
			ll_fila = idw_arreglo_dw[ii_dw_actual].InsertRow(0)
			IF ll_fila = -1 THEN
				MessageBox("Error datawindow","No se pudo insertar el registro del detalle",StopSign!)
			ELSE
				idw_arreglo_dw[ii_dw_actual].SetRow(ll_fila)
				idw_arreglo_dw[ii_dw_actual].ScrollToRow(ll_fila)
				idw_arreglo_dw[ii_dw_actual].SetColumn(1)
				il_fila_actual_detalle[ii_dw_actual] = ll_fila 
				idw_arreglo_dw[ii_dw_actual].SelectRow(il_fila_actual_detalle[ii_dw_actual],FALSE)
				il_fila_actual_detalle[ii_dw_actual] = idw_arreglo_dw[ii_dw_actual].GetRow()
				IF ((il_fila_actual_detalle[ii_dw_actual]<> -1) and (NOT ISNULL (il_fila_actual_detalle[ii_dw_actual])) and (il_fila_actual_detalle[ii_dw_actual]<>0)) THEN
					idw_arreglo_dw[ii_dw_actual].SelectRow(il_fila_actual_detalle[ii_dw_actual],TRUE)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_orden_corte", il_orden_corte)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_agrupacion", il_agrupacion)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_pdn", ii_produccion)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "co_modelo", il_modelo)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "co_fabrica_tela", ii_fabrica)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "co_reftel", il_reftel)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "co_caract", ii_caract)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "diametro", ii_diametro)					
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "co_color_te", il_color_te)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_trazo", il_trazo)
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_seccion", ii_seccion)					
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_base_trazos", ii_base)										
					idw_arreglo_dw[ii_dw_actual].SetItem(il_fila_actual_detalle[ii_dw_actual], "cs_liquidacion", li_liquidacion)					
				ELSE
				END IF
			END IF
		END IF
	ELSE
		MessageBox("Advertencia...","La liquidaci$$HEX1$$f300$$ENDHEX$$n seleccionada no tiene n$$HEX1$$fa00$$ENDHEX$$mero asignado")
	END IF
ELSE
	MessageBox("Advertencia","No puede insertar registros en el detalle sin haber seleccionado un registro en el maestro",Exclamation!,OK!)
END IF
end event

type dw_unidades from uo_dtwndow within w_liquidaciones2
integer x = 9
integer y = 876
integer width = 2853
integer height = 532
integer taborder = 40
boolean bringtotop = true
string dataobject = "dtb_unidades_liquidacion_trazos_xespacio"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event adcnar_fla;Long li_liquidacion
String  ls_tipo
s_base_parametros lstr_parametros

IF il_fila_actual_maestro > 0 THEN
	li_liquidacion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_liquidacion")
	lstr_parametros.entero[1] = il_orden_corte
	lstr_parametros.entero[2] = il_agrupacion
	lstr_parametros.entero[3] = ii_produccion
	lstr_parametros.entero[4] = il_modelo
	lstr_parametros.entero[5] = ii_fabrica
	lstr_parametros.entero[6] = il_reftel
	lstr_parametros.entero[7] = ii_caract
	lstr_parametros.entero[8] = ii_diametro
	lstr_parametros.entero[9] = il_color_te
	lstr_parametros.entero[10] = il_trazo
	lstr_parametros.entero[11] = ii_seccion
	lstr_parametros.entero[12] = ii_base
	lstr_parametros.entero[13] = li_liquidacion
	OpenWithParm(w_seleccionar_unidades_liquidacion, lstr_parametros)
	dw_maestro.TriggerEvent("RowFocusChanged")
END IF
end event

event itemchanged;Long li_capas, li_paquetes
Long ll_unidades, ll_unidades_ant, ll_diferencia

IF Dwo.Name = 'capas' THEN
	li_capas = Long(Data)
	li_paquetes = dw_unidades.GetItemNumber(Row, "paquetes")
	IF Not IsNull(li_capas) AND Not IsNull(li_paquetes) THEN
		ll_unidades = li_capas * li_paquetes
		dw_unidades.SetItem(Row, "ca_unidades_cortad", ll_unidades)
	END IF
END IF
IF Dwo.Name = 'paquetes' THEN
	li_capas = dw_unidades.GetItemNumber(Row, "capas")
	li_paquetes = Long(Data)
	IF Not IsNull(li_capas) AND Not IsNull(li_paquetes) THEN
		ll_unidades = li_capas * li_paquetes
		dw_unidades.SetItem(Row, "ca_unidades_cortad", ll_unidades)
	END IF
END IF
end event

event updatestart;//Long li_filas, li_fila_actual, li_talla, li_respuesta, li_tipomod
//Long li_fabrica, li_linea, li_registros
//Long ll_unidades, ll_unidades_inicial, ll_diferencia, ll_unidades_prog
//Long ll_ordenpd, ll_ordencorte, ll_modelo, ll_color
//
//ll_ordencorte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
//ll_modelo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_modelo") 
//SELECT sw_automatico
//INTO	:li_tipomod
//FROM	dt_ordcr_modelos
//WHERE	cs_orden_corte = :ll_ordencorte AND
//		co_modelo = :ll_modelo;
//IF SQLCA.SQLCode = -1 THEN
//	MessageBox("Error Base Datos","Error al consultar el tipo de modelo")
//	Return(1)
//END IF
//IF li_tipomod = 1 THEN
//	li_filas = dw_unidades.RowCount()
//	FOR li_fila_actual = 1 TO li_filas
//		IF dw_unidades.GetItemStatus(li_fila_actual, 0, Primary!) = NewModified! OR &
//			(dw_unidades.GetItemStatus(li_fila_actual, 0, Primary!) = DataModified! AND &
//			dw_unidades.GetItemStatus(li_fila_actual, "ca_unidades_cortad", Primary!) = DataModified!) THEN
//			ll_unidades = dw_unidades.GetItemNumber(li_fila_actual, "ca_unidades_cortad")
//			ll_unidades_inicial = dw_unidades.GetItemNumber(li_fila_actual, "ca_unidades_cortad", Primary!, True)
//			ll_diferencia = ll_unidades - ll_unidades_inicial
//			ll_ordencorte = dw_unidades.GetItemNumber(li_fila_actual, "cs_orden_corte")
//			SELECT	cs_ordenpd_pt, co_fabrica, co_linea
//			INTO		:ll_ordenpd, :li_fabrica, :li_linea
//			FROM		h_orden_corte
//			WHERE		cs_orden_corte = :ll_ordencorte;
//			IF SQLCA.SQLCode = -1 THEN
//				MessageBox("Error Base Datos","Error al consultar la orden de producci$$HEX1$$f300$$ENDHEX$$n de la orden de corte")
//				Return(1)
//			END IF
//			IF Not IsNull(ll_ordenpd) THEN
//				SELECT	Count(*)
//				INTO		:li_registros
//				FROM		dt_lineas_pedidos
//				WHERE		co_fabrica = :li_fabrica AND
//							co_linea = :li_linea;
//				IF SQLCA.SQLCode = -1 THEN
//					MessageBox("Error Base Datos","Error al verificar linea por pedidos")
//					Return(1)
//				END IF
//				IF li_registros > 0 THEN
//					li_talla = dw_unidades.GetItemNumber(li_fila_actual, "co_talla")
//					ll_color = dw_unidades.GetItemNumber(li_fila_actual, "co_color_pt")
//					SELECT	ca_pend_corte
//					INTO		:ll_unidades_prog
//					FROM		dt_orden_tllaclor
//					WHERE		cs_ordenpd_pt = :ll_ordenpd AND
//								co_talla = :li_talla AND
//								co_color = :ll_color;
//					IF SQLCA.SQLCode = -1 THEN
//						MessageBox("Error Base Datos","Error al consultar las unidades pendientes en corte")
//						Return(1)
//					END IF
//					IF ll_diferencia > ll_unidades_prog THEN
//						li_respuesta = MessageBox("Advertencia...","Est$$HEX2$$e1002000$$ENDHEX$$sobrepasando las unidades pendientes " + & 
//							"en corte para la talla: " + String(li_talla) + " Desea continuar.", Question!, YesNo!)
//						IF li_respuesta = 2 THEN
//							Return(1)
//						ELSE
//							UPDATE	dt_orden_tllaclor
//							SET		ca_pend_corte = ca_pend_corte - :ll_diferencia
//							WHERE		cs_ordenpd_pt = :ll_ordenpd AND
//										co_color = :ll_color AND
//										co_talla = :li_talla;
//							IF SQLCA.SQLCode = -1 THEN
//								MessageBox("Error Base Datos","Error al actualizar las unidades pendientes en corte")
//								ROLLBACK;
//								Return(1)
//							END IF
//						END IF
//					ELSE
//						UPDATE	dt_orden_tllaclor
//						SET		ca_pend_corte = ca_pend_corte - :ll_diferencia
//						WHERE		cs_ordenpd_pt = :ll_ordenpd AND
//									co_color = :ll_color AND
//									co_talla = :li_talla;
//						IF SQLCA.SQLCode = -1 THEN
//							MessageBox("Error Base Datos","Error al actualizar las unidades pendientes en corte")
//							ROLLBACK;
//							Return(1)
//						END IF				
//					END IF
//				END IF
//			END IF
//		END IF
//	NEXT
//END IF
end event

