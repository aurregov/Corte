HA$PBExportHeader$w_solicitud_trazos.srw
forward
global type w_solicitud_trazos from w_base_maestroff_detalletb
end type
type cb_prioridad from commandbutton within w_solicitud_trazos
end type
type dw_imprimir from datawindow within w_solicitud_trazos
end type
type cb_imprimir from commandbutton within w_solicitud_trazos
end type
type dw_usuarios from datawindow within w_solicitud_trazos
end type
type dw_trazadores from datawindow within w_solicitud_trazos
end type
type dw_info_molderias from datawindow within w_solicitud_trazos
end type
type cb_1 from commandbutton within w_solicitud_trazos
end type
end forward

global type w_solicitud_trazos from w_base_maestroff_detalletb
integer x = 5
integer y = 16
integer width = 3159
integer height = 2348
string title = "Solicitud de Trazos"
cb_prioridad cb_prioridad
dw_imprimir dw_imprimir
cb_imprimir cb_imprimir
dw_usuarios dw_usuarios
dw_trazadores dw_trazadores
dw_info_molderias dw_info_molderias
cb_1 cb_1
end type
global w_solicitud_trazos w_solicitud_trazos

type variables
Long il_consec_trazo
Long ii_crear_trazo,ii_graba_maestro
String	is_copy = ''
datawindowchild idw_rayas

end variables

forward prototypes
public function decimal of_traer_porc_util (long ai_fabrica, long ai_linea, long al_referencia, long ai_raya)
public function long of_traer_estab_molderia (long al_tanda, long al_ordenpd_pt, long al_color, long al_tela, long ai_fabrica, long ai_linea, long al_referencia, ref decimal ad_estab_largo, ref decimal ad_estab_ancho)
end prototypes

public function decimal of_traer_porc_util (long ai_fabrica, long ai_linea, long al_referencia, long ai_raya);DECIMAL{2}	ld_porc_util

SELECT MAX(porc_utilizacion)
  INTO :ld_porc_util
  FROM dt_modelos
 WHERE co_fabrica 	= :ai_fabrica
   AND co_linea   	= :ai_linea
	AND co_referencia	= :al_referencia
	AND raya				= :ai_raya
	AND co_calidad    = 1;
IF SQLCA.SQLCODE <> 0 THEN
   MessageBox("Error","Se present$$HEX2$$f3002000$$ENDHEX$$un problema buscando la utilizacion std de ficha: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
	Return 0;
END IF
	
RETURN ld_porc_util;
	
end function

public function long of_traer_estab_molderia (long al_tanda, long al_ordenpd_pt, long al_color, long al_tela, long ai_fabrica, long ai_linea, long al_referencia, ref decimal ad_estab_largo, ref decimal ad_estab_ancho);Long	ll_co_molderia_prenda, ll_color


SELECT MAX(co_molderia_prenda)
  INTO :ll_co_molderia_prenda
  FROM m_norma_cal
 WHERE cs_tanda 		= :al_tanda
   AND cs_ordenpd_pt = :al_ordenpd_pt
	AND co_reftel	 	= :al_tela 
;
	

IF ll_co_molderia_prenda > 0 THEN
	
	SELECT MAX(co_color)
	  INTO :ll_color
	  FROM m_norma_cal
	 WHERE cs_tanda 		= :al_tanda
	   AND cs_ordenpd_pt	= :al_ordenpd_pt
		AND co_reftel		= :al_tela;
	 
	SELECT estab_largo, estan_ancho
	  INTO :ad_estab_largo, :ad_estab_ancho
 	  FROM dt_molderia_prendas
	 WHERE co_fabrica 		= :ai_fabrica
	   AND co_linea			= :ai_linea
		AND co_referencia		= :al_referencia
		AND co_reftel			= :al_tela
		AND co_color			= :ll_color
		AND sw_num_molderia 	= :ll_co_molderia_prenda;

END IF

Return 1
end function

on w_solicitud_trazos.create
int iCurrent
call super::create
this.cb_prioridad=create cb_prioridad
this.dw_imprimir=create dw_imprimir
this.cb_imprimir=create cb_imprimir
this.dw_usuarios=create dw_usuarios
this.dw_trazadores=create dw_trazadores
this.dw_info_molderias=create dw_info_molderias
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_prioridad
this.Control[iCurrent+2]=this.dw_imprimir
this.Control[iCurrent+3]=this.cb_imprimir
this.Control[iCurrent+4]=this.dw_usuarios
this.Control[iCurrent+5]=this.dw_trazadores
this.Control[iCurrent+6]=this.dw_info_molderias
this.Control[iCurrent+7]=this.cb_1
end on

on w_solicitud_trazos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_prioridad)
destroy(this.dw_imprimir)
destroy(this.cb_imprimir)
destroy(this.dw_usuarios)
destroy(this.dw_trazadores)
destroy(this.dw_info_molderias)
destroy(this.cb_1)
end on

event ue_insertar_maestro;Long ll_consec_trazo, ll_orden_crea
n_cst_generar_consecutivo luo_consecutivos

luo_consecutivos = Create n_cst_generar_consecutivo

///////////////////////////////////////////////////////////////////////
// En este evento se detecta si hubo cambios en el datawindow, para 
// asignar valores a las variables de instancia is_cambio y is_accion.
//
// Ademas, se inserta una nueva linea, se le evalua el insert y si fue
// exitoso, se posiciona en dicha fila,hace el scroll a dicha fila y
// se posiciona en la primera columna de esta fila.
////////////////////////////////////////////////////////////////////////

long ll_fila

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"	
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				dw_maestro.Reset()
				is_accion = "no grabo"
				// NO GRABA Y SIGUE LA INSERCION
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

dw_info_molderias.Reset()

f_rcpra_dtos_dddw_param2(dw_maestro,'h_trazos_pend_co_raya',SQLCA,2,6,13011)

ll_fila = dw_maestro.InsertRow(0)
dw_maestro.SetFocus()

IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF


dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))
dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(il_fila_actual_maestro, "h_trazos_pend_solicita", gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)

//
ll_consec_trazo = luo_consecutivos.of_consulta_consecutivo_orden(2, 13)
IF ll_consec_trazo = -1 THEN
ELSE
	Commit;
END IF


//SELECT MAX(cs_trazo)
//  INTO :ll_consec_trazo
//  FROM h_trazos_pend;
//IF SQLCA.SQLCODE = 0 THEN  
//	IF ll_consec_trazo  > 0 THEN
//		ll_consec_trazo = ll_consec_trazo + 1
//	ELSE
//		ll_consec_trazo = 1
//	END IF
	dw_maestro.SetItem(il_fila_actual_maestro, "cs_trazo", ll_consec_trazo)
	il_consec_trazo = ll_consec_trazo
//ELSE
//	Messagebox('Error', 'Error buscando el consecutivo de trazo, intente luego')
//	Return 1
//END IF
//
  
SELECT MAX(order_crea)
INTO :ll_orden_crea
FROM h_trazos_pend
WHERE co_estado_crea in (0,4);
IF SQLCA.SQLCODE = 0 THEN  
	IF ll_orden_crea  > 0 THEN
		ll_orden_crea = ll_orden_crea + 1
	ELSE
		ll_orden_crea = 1
	END IF
	dw_maestro.SetItem(il_fila_actual_maestro, "h_trazos_pend_order_crea", ll_orden_crea)
ELSE
	Messagebox('Error', 'Error buscando el consecutivo de trazo, intente luego')
	Return 1
END IF


end event

event open;Long	ll_rtncode

This.width = 3122
This.height =2168

This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
dw_info_molderias.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

dw_detalle.SetTransObject(SQLCA)

//
//


//dw_maestro.GetChild('h_trazos_pend_co_raya',idw_rayas)
//
//idw_rayas.SetTransObject(SQLCA)
dw_usuarios.SetTransObject(SQLCA)
dw_trazadores.SetTransObject(SQLCA)

//idw_rayas.Retrieve(0,0,0)

//dw_usuarios.Retrieve()
dw_trazadores.Retrieve()
SetPointer(Arrow!)

end event

event ue_buscar;s_base_parametros lstr_parametros
Long	ll_cons_trazo, ll_hallados
Long	ll_ordencorte

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_buscar_solicitud_trazo)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ll_cons_trazo	=	lstr_parametros.entero[1]


		dw_maestro.SetTransObject(SQLCA)
		f_rcpra_dtos_dddw_param2(dw_maestro,'h_trazos_pend_co_raya',SQLCA,2,6,13011)
		ll_hallados = dw_maestro.Retrieve(ll_cons_trazo)
		
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
					dw_detalle.SetTransObject(SQLCA)
					dw_detalle.Retrieve(ll_cons_trazo)
					il_fila_actual_maestro = 1
			END CHOOSE
		END IF
	ELSE
	END IF
ELSE
END IF
end event

event ue_borrar_detalle;ii_crear_trazo = 1
long ll_fila

ll_fila = dw_detalle.GetRow()
CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del detalle ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del detalle",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del detalle",Question!,YesNo!) = 1) THEN
			IF (dw_detalle.DeleteRow(ll_fila) = -1) THEN
				MessageBox("Error datawindow","No pudo borrar del detalle",StopSign!,Ok!)
			ELSE
				il_fila_actual_detalle = ll_fila - 1
				This.TriggerEvent("ue_grabar")
			END IF
		ELSE
		END IF
END CHOOSE



end event

event ue_insertar_detalle;call super::ue_insertar_detalle;dw_detalle.SetItem(il_fila_actual_detalle, "cs_trazo", il_consec_trazo)
end event

event ue_grabar;
ii_graba_maestro = 0
//graba mastro
IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN -1
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN -2
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)
			RETURN -3
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

//graba detalle, cuando grabe desde el updastart no realice el update del detalle.
IF is_accion = "si update" and ii_graba_maestro = 0 THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		Messagebox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN -1
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			RETURN -2
		ELSE
			is_accion = "si update"
			COMMIT;
			IF SQLCA.SQLCode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
								,Exclamation!,Ok!)
				RETURN -3
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF
ii_graba_maestro = 0

RETURN 1

end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_solicitud_trazos
integer x = 27
integer width = 2976
integer height = 952
boolean titlebar = false
string dataobject = "dtb_h_solicitud_trazos"
boolean vscrollbar = false
end type

event dw_maestro::itemchanged;String   	ls_cod_bar, ls_de_referencia, ls_molderia, ls_descripcion, ls_rollo_padre, ls_co_referencia, ls_password, ls_password_ingresado
Long			ll_pos, li_secundario, li_co_fabrica, li_co_linea, li_long_molde, li_talla, li_estado_trazo, li_ruta,li_estado_ant,li_raya
Long			ll_tanda, ll_cs_ordenpd_pt, ll_co_referencia, ll_molderia,ll_reftel, ll_co_color
Long        ll_fila, ll_cs_documento, ll_cs_rollo, ll_rollo_padre, ll_ordenpd_pt
Decimal{2}  ld_ancho_real, ld_util_trazo, ld_util_ant, ld_util_std,ldc_porc, ldc_porc_resta, ldc_porc_suma, ld_estab_largo, ld_estab_ancho
n_cts_constantes_corte lpo_const_corte
s_base_parametros lstr_parametros

IF Row > 0 THEN
	SetItem(Row, "fe_actualizacion", DateTime(Today(), Now()))
	SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
	SetItem(Row, "instancia", gstr_info_usuario.instancia)
END IF

IF DWO.NAME = "cod_bar" THEN
	ls_cod_bar = String(DATA)
	
	ll_pos = Long(Trim(Mid(ls_cod_bar, 10, 1)))
	IF ll_pos > 0 THEN
		ll_tanda = Long(Trim(Mid(ls_cod_bar, 1, 6)))
		li_secundario =  Long(Trim(Mid(ls_cod_bar, 7,1 )))
		li_ruta =  Long(Trim(Mid(ls_cod_bar, 8,2 )))
	ELSE
		ll_tanda = Long(Trim(Mid(ls_cod_bar, 1, 5)))
		li_secundario =  Long(Trim(Mid(ls_cod_bar, 6,1 )))
		li_ruta =  Long(Trim(Mid(ls_cod_bar, 7,2 )))
	END IF
	
	SELECT MIN(dt_lotesxtandas.cs_ordenpd_pt)  
     INTO :ll_cs_ordenpd_pt  
     FROM dt_lotesxtandas  
    WHERE ( dt_lotesxtandas.cs_tanda = :ll_tanda ) AND  
	       ( dt_lotesxtandas.cs_secundario = :li_secundario ) AND
			 ( dt_lotesxtandas.nu_ruta_pdn = :li_ruta );
	IF SQLCA.SQLCODE = 0 THEN
	ELSE
		IF SQLCA.SQLCODE = 100 THEN
			Messagebox('Advertencia', 'No se encontro la orden de producion')
		ELSE
			Messagebox('Error', 'Error buscando la orden de producion')
			Return
		END IF
	END IF

	SELECT h_ordenpd_pt.co_fabrica, h_ordenpd_pt.co_linea, h_ordenpd_pt.co_referencia, h_preref_pv.de_referencia
	  INTO :li_co_fabrica, :li_co_linea, :ll_co_referencia, :ls_de_referencia
	  FROM h_ordenpd_pt, h_preref_pv
	 WHERE h_ordenpd_pt.co_fabrica = h_preref_pv.co_fabrica
	   AND h_ordenpd_pt.co_linea = h_preref_pv.co_linea
		AND cast(h_ordenpd_pt.co_referencia as char(15)) = h_preref_pv.co_referencia
		AND h_preref_pv.co_tipo_ref      = 'P'
		AND h_ordenpd_pt.cs_ordenpd_pt = :ll_cs_ordenpd_pt ;
		
	IF sqlca.sqlcode = 0 THEN
	ELSE
		IF sqlca.sqlcode = 100 THEN
			MessageBox("Advertencia", "No se encontro la descripcion de referencia", Exclamation!)
		ELSE
			MessageBox("Advertencia", "Error buscando descripcion de referencia", Exclamation!)
		END IF
	END IF
	
  SQLCA.LOCK = 'DIRTY READ'
  SELECT co_color
	 INTO :ll_co_color
	 FROM h_tandas
	WHERE ( h_tandas.cs_tanda = :ll_tanda ) AND  
	      ( h_tandas.cs_secundario = :li_secundario )  ;
   IF SQLCA.SQLCODE = 0 THEN
   ELSE
	  IF SQLCA.SQLCODE = 100 THEN
		  Messagebox('Advertencia', 'No se encontro el color, Favor digitarlo')
	  ELSE
	  		Messagebox('Error', 'Error Consultado color y ficho en h_tandas')
	  		Return 
	  END IF
	END IF
 
   SELECT MAX(co_modelo)
	  INTO :ll_molderia
	  FROM dt_modelos
	 WHERE co_fabrica 	= :li_co_fabrica
	   AND co_linea 		= :li_co_linea
		AND co_referencia = :ll_co_referencia
		AND co_color_pt 	= :ll_co_color
		AND co_calidad 	= 1
		AND raya 			= 10;
   IF SQLCA.SQLCODE = 0 THEN
		li_long_molde = LEN(STRING(ll_molderia))
		li_long_molde = li_long_molde - 1
		ls_molderia = STRING(ll_molderia)
		ls_molderia = Mid(ls_molderia,1,li_long_molde)
		ls_molderia = '0' + ls_molderia
   ELSE
	  IF SQLCA.SQLCODE = 100 THEN
		  Messagebox('Advertencia', 'No se pudo encontrar la Molderia, favor digitarla')
	  ELSE
	  		Messagebox('Error', 'Error Consultado Molderia')
	  		Return 
	  END IF
	END IF


	SELECT MAX(dt_rollosxlotes.cs_rollo)  
     INTO :ll_cs_rollo  
     FROM dt_lotesxtandas, dt_rollosxlotes  
    WHERE dt_lotesxtandas.cs_tanda = dt_rollosxlotes.cs_tanda
	   AND dt_lotesxtandas.cs_secundario = dt_rollosxlotes.cs_secundario
		AND dt_lotesxtandas.cs_ordenpd_pt = dt_rollosxlotes.cs_ordenpd_pt
		AND dt_lotesxtandas.cs_lote = dt_rollosxlotes.cs_lote
		AND dt_lotesxtandas.co_reftel = dt_rollosxlotes.co_reftel
		AND dt_lotesxtandas.co_caract = dt_rollosxlotes.co_caract
		AND dt_lotesxtandas.cs_parte = dt_rollosxlotes.cs_parte
	   AND dt_lotesxtandas.cs_tanda = :ll_tanda  
	   AND dt_lotesxtandas.cs_secundario = :li_secundario 
		AND dt_lotesxtandas.nu_ruta_pdn = :li_ruta ;
	IF ll_cs_rollo > 0 THEN
		SELECT atributo2
		  INTO :ls_rollo_padre
		  FROM m_rollo
		 WHERE cs_rollo =  :ll_cs_rollo;
		ll_rollo_padre = LONG(ls_rollo_padre) 
		SELECT ancho_tub_term
 	     INTO :ld_ancho_real
		  FROM m_rollo
		 WHERE cs_rollo = :ll_rollo_padre;
		 
	END IF

	
	IF ld_ancho_real > 50 THEN
		ld_ancho_real = ld_ancho_real / 100
	END IF
	 
	dw_maestro.SetItem(il_fila_actual_maestro, "cs_ordenpd_pt", ll_cs_ordenpd_pt)
	dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_co_fabrica)
	dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_co_linea)
	dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_co_referencia)
	dw_maestro.SetItem(il_fila_actual_maestro, "h_preref_de_referencia", ls_de_referencia)
	dw_maestro.SetItem(il_fila_actual_maestro, "co_color", ll_co_color)
	dw_maestro.SetItem(il_fila_actual_maestro, "ancho", ld_ancho_real)
	dw_maestro.SetItem(il_fila_actual_maestro, "molderia", ls_molderia)
	
		
	//Traer las tallas al detalle
	
	DECLARE cur_tallas CURSOR FOR
	SELECT DISTINCT a.co_talla
	FROM h_ficha_pt a, dt_caxpedidos b, h_ordenpd_pt c
	WHERE c.cs_ordenpd_pt = b.cs_ordenpd_pt
	  AND c.co_fabrica = a.co_fabrica
	  AND c.co_linea = a.co_linea
	  AND c.co_referencia = a.co_referencia
	  AND a.co_color_pt = b.co_color
	  ANd a.co_talla = b.co_talla
	  AND c.cs_ordenpd_pt = :ll_ordenpd_pt
	  AND a.co_fabrica = :li_co_fabrica
	  AND a.co_linea = :li_co_linea
	  AND a.co_referencia = :ll_co_referencia
	  AND a.co_calidad = 1
	ORDER BY co_talla ASC;

	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox('Error','Error al abrir el cursor ')
		Return(1)
	END IF
	
	OPEN cur_tallas;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al abrir el cursor de  Tallas")
		Return
	END IF
		
	FETCH cur_tallas INTO :li_talla;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer el primer registro del cursor de tallas")
		Return
	END IF
		
	DO WHILE SQLCA.SQLCode = 0
				
		IF dw_detalle.AcceptText() = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del detalle ",StopSign!)	
		ELSE
			ll_fila = dw_detalle.InsertRow(0)
			il_fila_actual_detalle = ll_fila 
		END IF
		dw_detalle.SetItem(il_fila_actual_detalle, "co_talla", li_talla)
		dw_detalle.SetItem(il_fila_actual_detalle, "ca_paquetes", 1)
		dw_detalle.SetItem(il_fila_actual_detalle, "cs_trazo", il_consec_trazo)
		
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_actualizacion", DateTime(Today(), Now()))
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", DateTime(Today(), Now()))
		dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
		dw_detalle.SetItem(il_fila_actual_detalle, "instancia", gstr_info_usuario.instancia)

		FETCH cur_tallas INTO :li_talla;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer el siguiente registro del cursor")
			Return
		END IF		
	LOOP
	CLOSE cur_tallas;

	ii_crear_trazo = 0
END IF

IF DWO.NAME = "co_estado_crea" THEN
	li_estado_trazo = Long(DATA)
	
	li_estado_ant = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_crea")
	IF (li_estado_trazo = 1) AND (li_estado_ant = 4)   THEN
		ii_crear_trazo = 1
	ELSEIF li_estado_trazo =0 OR li_estado_trazo = 3 OR li_estado_trazo = 0 THEN
	ELSE
  		Messagebox('Advertencia', 'Solo puede pasar a estado creado un trazo que se este dibujando')		
		Return 1
	END If
END IF

IF DWO.NAME = "porc_util" THEN
	ld_util_trazo = DEC(DATA)
	ld_util_ant = dw_maestro.GetItemNumber(il_fila_actual_maestro, "porc_util")
	IF ld_util_trazo >= 100 THEN
  		Messagebox('Advertencia', 'El porcentaje de utilizacion debe ser menor que 100')
	   dw_maestro.SetItem(il_fila_actual_maestro, "porc_util", ld_util_ant)
	END If
	ld_util_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "porcutil_std")
	
	//validar la utilizacion ingresada contra la std solicta Jaiver Garcia marzo 4 - 2011 jorodrig
	ldc_porc = lpo_const_corte.of_consultar_numerico('PORC UTILIZACION TRAZO')
	If ldc_porc = -1 Then
		ldc_porc = 0 
	End if
	ldc_porc_resta = ld_util_std - ldc_porc
	ldc_porc_suma = ld_util_std + ldc_porc
	
	IF (ld_util_trazo < ldc_porc_resta)  THEN
		MessageBox('Advertencia','Trazo con utilizacion por fuera de lo permitido. Diferencia permitida: '+string(ldc_porc)+ ' Necesita autorizaci$$HEX1$$f300$$ENDHEX$$n para programarlo.')
		ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD AUTORIZACION TRAZO'))
		
		//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
		Open(w_password_trazos)
		lstr_parametros = message.PowerObjectParm
			
		If lstr_parametros.hay_parametros = true Then
			ls_password_ingresado = Trim(lstr_parametros.cadena[1])
						
			If ls_password_ingresado = ls_password Then
			Else
				MessageBox('Error','Password, no valido.')
				THIS.RESET()   				
			End if
		Else
			This.Setitem(row,'porc_util',0)
			THIS.RESET()   	
//			Return 
			
		End if
	Else
		//se permite el uso del trazo.
	End if

		
		

	
END IF


IF DWO.NAME = "co_referencia" THEN
	ll_co_referencia = Long(DATA)
	ls_co_referencia = string(ll_co_referencia)
	
	li_co_fabrica    = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	li_co_linea      = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
	f_rcpra_dtos_dddw_param2(dw_maestro,'h_trazos_pend_co_raya',SQLCA,li_co_fabrica,li_co_linea,ll_co_referencia)
			
	SELECT de_referencia
	  INTO :ls_de_referencia
	  FROM h_preref_pv
    WHERE co_fabrica = :li_co_fabrica
	   AND co_linea = :li_co_linea
		AND co_referencia = :ls_co_referencia
		AND co_tipo_ref      = 'P';

	
	IF ISNULL(ls_de_referencia) THEN
	ELSE
		dw_maestro.SetItem(il_fila_actual_maestro, "h_preref_de_referencia", ls_de_referencia)
	END IF
	
	

END IF

IF DWO.NAME = "co_linea" THEN
	li_co_linea = Long(DATA)
	
	li_co_fabrica    = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	ll_co_referencia      = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
	ls_co_referencia = string(ll_co_referencia)
	
	SELECT de_referencia
	  INTO :ls_de_referencia
	  FROM h_preref_pv
    WHERE co_fabrica = :li_co_fabrica
	   AND co_linea = :li_co_linea
		AND co_referencia = :ls_co_referencia
		AND co_tipo_ref      = 'P';
	IF ISNULL(ls_de_referencia) THEN
		SELECT de_referencia
	     INTO :ls_de_referencia
	     FROM h_preref_inf
       WHERE co_fabrica = :li_co_fabrica
	      AND co_linea = :li_co_linea
		   AND co_referencia = :ll_co_referencia;
	END IF
	IF ISNULL(ls_de_referencia) THEN
	ELSE
		dw_maestro.SetItem(il_fila_actual_maestro, "h_preref_de_referencia", ls_de_referencia)
	END IF
END IF

IF  DWO.NAME = "co_color" THEN
	ll_co_color = Long(DATA)
	
	li_co_fabrica    = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	li_co_linea      = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
	ll_co_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")

	
   SELECT MAX(co_modelo)
	  INTO :ll_molderia
	  FROM dt_modelos
	 WHERE co_fabrica 	= :li_co_fabrica
	   AND co_linea 		= :li_co_linea
		AND co_referencia = :ll_co_referencia
		AND co_color_pt 	= :ll_co_color
		AND co_calidad		= 1
		AND raya 			= 10;
   IF SQLCA.SQLCODE = 0 THEN
		li_long_molde = LEN(STRING(ll_molderia))
		li_long_molde = li_long_molde - 1
		ls_molderia = STRING(ll_molderia)
		ls_molderia = Mid(ls_molderia,1,li_long_molde)
		ls_molderia = '0' + ls_molderia
		dw_maestro.SetItem(il_fila_actual_maestro, "molderia", ls_molderia)
   ELSE
	  IF SQLCA.SQLCODE = 100 THEN
		  Messagebox('Advertencia', 'No se pudo encontrar la Molderia, favor digitarla')
	  ELSE
	  		Messagebox('Error', 'Error Consultado Molderia')
	  		Return 
	  END IF
	END IF
	
	ll_cs_ordenpd_pt	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_ordenpd_pt")
	dw_info_molderias.SetTransObject(SQLCA)
	dw_info_molderias.Retrieve(ll_cs_ordenpd_pt,ll_co_color)
END IF

IF DWO.NAME = "h_trazos_pend_co_raya" THEN
	li_raya = Long(DATA)
	
	li_co_fabrica    	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	li_co_linea      	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
	ll_co_referencia 	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
	ll_co_color			= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color")
	ll_cs_ordenpd_pt	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_ordenpd_pt")
	
	
	ls_cod_bar = dw_maestro.GetItemString(il_fila_actual_maestro, "cod_bar")
	ll_tanda = Long(Trim(Mid(ls_cod_bar, 1, 6)))
	
	//se trae el codigo de la tela al que pertenece la raya, esta se necesita luego para buscar la molderia 
	//jorodig junio 16 - 2011
	
	//realizar prueba.
	SELECT MAX(co_reftel)
	  INTO :ll_reftel
	  FROM dt_color_modelo a, dt_modelos b
	 WHERE a.co_fabrica	= b.co_fabrica
	  	AND a.co_linea		= b.co_linea
		AND a.co_referencia	= b.co_referencia
		AND a.co_color_pt	= b.co_color_pt
		AND a.co_talla		= b.co_talla
		AND a.co_calidad	= b.co_calidad
		AND a.co_modelo	= b.co_modelo
		AND a.co_calidad	= 1
	   AND a.co_fabrica		= :li_co_fabrica
	   AND a.co_linea 		= :li_co_linea
		AND a.co_referencia 	= :ll_co_referencia
		AND a.co_color_pt 	= :ll_co_color
		AND a.co_calidad		= 1
		AND b.raya				= :li_raya;
		
	//con la tela, la orden de corte y la raya traemos la tanda	
	IF ll_reftel > 0 THEN
		
		select MAX(m.lote)
		  into :ll_tanda
	 	  from dt_rollos_libera a, dt_pdnxmodulo b, m_rollo m, dt_telaxmodelo_lib c
		 where a.co_fabrica_exp	= b.co_fabrica_exp
		   and a.cs_liberacion 	= b.cs_liberacion
		   and a.nu_orden 		= b.po
		   and a.nu_cut 			= b.nu_cut
		   and a.co_fabrica_pt 	= b.co_fabrica_pt
		   and a.co_linea 		= b.co_linea
		   and a.co_referencia 	= b.co_referencia
		   and a.co_color_pt 	= b.co_color_pt
		   and a.co_fabrica_exp	= c.co_fabrica_exp
		   and a.cs_liberacion 	= c.cs_liberacion
		   and a.nu_orden 		= c.nu_orden
		   and a.nu_cut 			= c.nu_cut
		   and a.co_fabrica_pt 	= c.co_fabrica_pt
		   and a.co_linea 		= c.co_linea
		   and a.co_referencia 	= c.co_referencia
		   and a.co_color_pt 	= c.co_color_pt
		   and a.cs_rollo 		= m.cs_rollo
		   and a.co_reftel		= c.co_reftel
		   and a.co_caract		= c.co_caract
		   and a.diametro 		= c.diametro
		   and a.co_color_tela	= c.co_color_tela		
		   and b.cs_asignacion 	= :gl_orden_corte
		   and a.co_reftel		= :ll_reftel
		   and c.raya				= :li_raya;
		
		
		ld_estab_largo = 0
		ld_estab_ancho = 0
		of_traer_estab_molderia(ll_tanda, ll_cs_ordenpd_pt,  ll_co_color, ll_reftel, li_co_fabrica, li_co_linea, ll_co_referencia, ld_estab_largo, ld_estab_ancho)
		dw_maestro.SetItem(il_fila_actual_maestro, "h_trazos_pend_estab_largo", ld_estab_largo)
		dw_maestro.SetItem(il_fila_actual_maestro, "h_trazos_pend_estab_ancho", ld_estab_ancho)
	END IF
	
END IF


IF DWO.NAME = "cs_ordenpd_pt" THEN
	ll_ordenpd_pt = Long(DATA)
	
	SELECT co_fabrica, co_linea, co_referencia
	  INTO :li_co_fabrica, :li_co_linea, :ll_co_referencia
	  FROM h_ordenpd_pt
    WHERE cs_ordenpd_pt = :ll_ordenpd_pt ;
	IF ISNULL(ll_co_referencia) THEN
	ELSE
		dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_co_fabrica)
		dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_co_linea)
		dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_co_referencia)
	END IF
	
	f_rcpra_dtos_dddw_param2(dw_maestro,'h_trazos_pend_co_raya',SQLCA,li_co_fabrica,li_co_linea,ll_co_referencia)
		
	SELECT de_referencia
	  INTO :ls_de_referencia
	  FROM h_preref_pv
	 WHERE co_fabrica = :li_co_fabrica
	   AND co_linea = :li_co_linea
      AND (Cast(:ll_co_referencia as char(15) ) = h_preref_pv.co_referencia )
      AND co_tipo_ref = 'P' ;
	IF ISNULL(ls_de_referencia) THEN
	ELSE
		dw_maestro.SetItem(il_fila_actual_maestro, "h_preref_de_referencia", ls_de_referencia)
	END IF

	
		//Traer las tallas al detalle
	
	dw_detalle.Reset()
	
	DECLARE cur_tallas_op CURSOR FOR
	SELECT DISTINCT a.co_talla
	FROM h_ficha_pt a, dt_caxpedidos b, h_ordenpd_pt c
	WHERE c.cs_ordenpd_pt = b.cs_ordenpd_pt
	  AND c.co_fabrica = a.co_fabrica
	  AND c.co_linea = a.co_linea
	  AND c.co_referencia = a.co_referencia
	  AND a.co_color_pt = b.co_color
	  ANd a.co_talla = b.co_talla
	  AND c.cs_ordenpd_pt = :ll_ordenpd_pt
	  AND a.co_fabrica = :li_co_fabrica
	  AND a.co_linea = :li_co_linea
	  AND a.co_referencia = :ll_co_referencia
	  AND a.co_calidad = 1
	ORDER BY co_talla ASC;
	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox('Error','Error al abrir el cursor ')
		Return(1)
	END IF
	
	OPEN cur_tallas_op;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al abrir el cursor de  Tallas")
		Return
	END IF
		
	FETCH cur_tallas_op INTO :li_talla;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer el primer registro del cursor de tallas")
		Return
	END IF
		
	DO WHILE SQLCA.SQLCode = 0
				
		IF dw_detalle.AcceptText() = -1 THEN
			MessageBox("Error datawindow","No se pudo insertar el registro del detalle ",StopSign!)	
		ELSE
			ll_fila = dw_detalle.InsertRow(0)
			il_fila_actual_detalle = ll_fila 
		END IF
		dw_detalle.SetItem(il_fila_actual_detalle, "co_talla", li_talla)
		dw_detalle.SetItem(il_fila_actual_detalle, "ca_paquetes", 1)
		dw_detalle.SetItem(il_fila_actual_detalle, "cs_trazo", il_consec_trazo)
		
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_actualizacion", DateTime(Today(), Now()))
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", DateTime(Today(), Now()))
		dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
		dw_detalle.SetItem(il_fila_actual_detalle, "instancia", gstr_info_usuario.instancia)

		FETCH cur_tallas_op INTO :li_talla;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer el siguiente registro del cursor")
			Return
		END IF		
	LOOP
	CLOSE cur_tallas_op;
	dw_detalle.TriggerEvent(Retrieveend!)
	
END IF

end event

event dw_maestro::updatestart;Long		li_co_fabrica, li_co_linea, li_tot_trazos, li_estado_trazo, li_tot_paquetes_prog, li_existe
Long			ll_co_referencia, ll_cs_documento, ll_ordenpd
Decimal{2}  ld_ancho, ld_estab_largo, ld_estab_ancho, ld_porc_util_ficha		
String		ls_descripcion
s_base_parametros_seleccionar lstr_parametros

STRING 		ls_molderia
DECIMAL{2}	ld_largo, ld_porc_util, ld_repite
Long			li_tipo, li_extendido, li_forma_ext, li_tot_tallas, pos, li_talla, li_paquetes, li_proporcion_creada
Long			li_tot_paquetes_trazo, li_encontro_trazos, li_ya_existe, li_raya
LONG			ll_trazo_probable, ll_solicitud
DATETIME		ldt_fecha
DECIMAL{4}  ld_particip_trazo_crear, ld_particip_trazo_probale
Long			li_unid_menos_ancho
DECIMAL		ldc_porc
n_cts_constantes_corte lpo_const_corte

Long li_fila, li_consecutivo, li_destinatario, li_fila_tot, li_tot_tallas_trazo_prob, li_trazos_ya_creados
String ls_usuario, ls_nombre, ls_comentario, ls_referencia, ls_trazo, ls_observaciones
mailSession lms_sesion
mailReturnCode lmrt_retorno
mailMessage lmsg_mensaje

//variable de mensaje del correo
String ls_mensaje
//Long li_codigo_email

n_cts_constantes_tela luo_constantes 
//Dbedocal: n_cst_tool_msn luo_correo
uo_correo	luo_correo

luo_correo = create uo_correo


//Verficar que no existe un trazo igual
li_unid_menos_ancho = 1

IF il_fila_actual_maestro <= 0 THEN
	RETURN(1)
END IF

li_co_fabrica    = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
li_co_linea      = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
ll_co_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
ld_ancho         = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ancho")
li_encontro_trazos = 0

ldc_porc = lpo_const_corte.of_consultar_numerico('PORC UTILIZACION TRAZO')
If ldc_porc = -1 Then
	ldc_porc = 0 
End if

dw_detalle.AcceptText()

IF ii_crear_trazo= 0 THEN
	
	SELECT COUNT(*)
	  INTO :li_tot_trazos
	  FROM h_trazos, dt_refptxtrazo
	 WHERE h_trazos.co_trazo = dt_refptxtrazo.co_trazo
		AND dt_refptxtrazo.co_fabrica = :li_co_fabrica
		AND dt_refptxtrazo.co_linea = :li_co_linea
		AND dt_refptxtrazo.co_referencia = :ll_co_referencia
		AND ((h_trazos.ancho = :ld_ancho) OR (h_trazos.ancho = :ld_ancho/100) OR (h_trazos.ancho = :ld_ancho - :li_unid_menos_ancho)) ;
	IF li_tot_trazos > 0 THEN
		
		DELETE FROM temp_trazos_prob WHERE usuario = :gstr_info_usuario.codigo_usuario;
		COMMIT;
		
		//Buscar tambien con la proporcion los trazos
		li_tot_paquetes_prog = 0
		li_tot_tallas = dw_detalle.RowCount()	
		FOR pos = 1 TO li_tot_tallas
			 li_tot_paquetes_prog = li_tot_paquetes_prog + dw_detalle.GetItemNumber(pos, "ca_paquetes") 
		NEXT
		FOR pos = 1 TO li_tot_tallas
			li_talla = dw_detalle.GetItemNumber(pos, "co_talla") 
			li_paquetes = dw_detalle.GetItemNumber(pos, "ca_paquetes") 		
			
			ld_particip_trazo_crear = li_paquetes / li_tot_paquetes_prog
			
			DECLARE cur_tallas CURSOR FOR
			SELECT dt_tallasxtrazo.co_trazo, ca_paquetes
			FROM h_trazos, dt_refptxtrazo, dt_tallasxtrazo 
			WHERE h_trazos.co_trazo = dt_refptxtrazo.co_trazo
				AND dt_refptxtrazo.co_fabrica = :li_co_fabrica
				AND dt_refptxtrazo.co_linea = :li_co_linea
				AND dt_refptxtrazo.co_referencia = :ll_co_referencia
				AND dt_refptxtrazo.co_trazo = dt_tallasxtrazo.co_trazo
				AND dt_refptxtrazo.co_fabrica = dt_tallasxtrazo.co_fabrica
				AND dt_refptxtrazo.co_linea = dt_tallasxtrazo.co_linea
				AND dt_refptxtrazo.co_referencia = dt_tallasxtrazo.co_referencia
				AND dt_tallasxtrazo.co_talla = :li_talla
				AND ((h_trazos.ancho = :ld_ancho) OR (h_trazos.ancho = :ld_ancho/100) OR (h_trazos.ancho = :ld_ancho - :li_unid_menos_ancho)) ;
			IF SQLCA.SQLCODE <> 0 THEN
				Messagebox('Error','Error al abrir el cursor ')
				Return(1)
			END IF
			OPEN cur_tallas;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al abrir el cursor de los trazos")
				Return
			END IF
			
			FETCH cur_tallas INTO :ll_trazo_probable, :li_proporcion_creada;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al leer el primer registro del cursor")
				Return
			END IF
			DO WHILE SQLCA.SQLCode = 0
				
				SELECT SUM(ca_paquetes)
				  INTO :li_tot_paquetes_trazo
				  FROM dt_tallasxtrazo
				 WHERE co_trazo = :ll_trazo_probable
				   AND co_fabrica = :li_co_fabrica
					AND co_linea = :li_co_linea
					AND co_referencia = :ll_co_referencia;
							
				SELECT COUNT(*)
				  INTO :li_tot_tallas_trazo_prob
				  FROM dt_tallasxtrazo
				 WHERE co_trazo = :ll_trazo_probable
				   AND co_fabrica = :li_co_fabrica
					AND co_linea = :li_co_linea
					AND co_referencia = :ll_co_referencia;	
			
			   IF li_tot_paquetes_trazo = 0 THEN
					li_tot_paquetes_trazo = 1
				END IF
				ld_particip_trazo_probale = 	li_proporcion_creada / li_tot_paquetes_trazo
				
				IF (ld_particip_trazo_crear = ld_particip_trazo_probale)THEN
				   IF (li_tot_tallas_trazo_prob = li_tot_tallas) THEN
					
						SELECT COUNT(*)
						  INTO :li_existe
						  FROM temp_trazos_prob
						 WHERE usuario =  :gstr_info_usuario.codigo_usuario
						   AND co_trazo = :ll_trazo_probable
							AND co_talla = :li_talla;
						IF li_existe = 0 THEN	
							INSERT INTO temp_trazos_prob (usuario, co_trazo, co_talla)
							VALUES (:gstr_info_usuario.codigo_usuario, :ll_trazo_probable, :li_talla);
						END IF
						li_encontro_trazos = 1
						
					END IF
				END IF
										
				FETCH cur_tallas INTO :ll_trazo_probable, :li_proporcion_creada;
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al leer el siguiente registro del cursor")
					Return
				END IF		
			LOOP
			CLOSE cur_tallas;
			
		NEXT
		
		IF li_encontro_trazos = 1 THEN			
			Messagebox('Advertencia', 'Se encontraron trazos para la misma referencia en el mismo ancho')
			lstr_parametros.entero1[1] = li_co_fabrica
			lstr_parametros.entero1[2] = li_co_linea
			lstr_parametros.entero1[3] = ll_co_referencia
			lstr_parametros.decimal1[1] = ld_ancho
			
			OpenWithParm(w_trazos_existentes_iguales, lstr_parametros)
		
			IF MessageBox("Advertencia", "Aun desea grabar como solicitud el presente trazo?", Question!, YesNo!, 2) = 2 THEN
				Return(1)
			END IF
	
		END IF
	END IF
	
	//Mandar un correo a trazadores sobre trazo a crear, aplica para Marinilla, en nicole no se 
	//enviara correo ya que la persona que pide la creacion del trazo es la misma que lo crea.
	
	IF gstr_info_usuario.co_planta_pro = 2 THEN
	
		//SA56209 - Ceiba/reariase - 08-02-2017
		//envio de correo
		ls_referencia = dw_maestro.GetItemString(il_fila_actual_maestro, "h_preref_de_referencia")
		ll_solicitud = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_trazo")
		//li_codigo_email = luo_constantes.of_consultar_numerico("USU_CORREO_TRAZA")co_aplica=2
		//if li_codigo_email <> -1 then 
			ls_mensaje = 'Favor crear trazo de solicitud: ' + STRING(ll_solicitud) + ' descripcion ' + ls_referencia + '~r~n~r~n' + 'Trazo por crear'
			try
				//Dbedocal 2018-04-26: luo_correo.of_enviar_correo("Trazo Solicitado por Crear", ls_mensaje, li_codigo_email,'')
				luo_correo.of_enviar_correo('Trazo Solicitado por Crear', ls_mensaje, 'trazadores')
			catch(Exception ex)
				Messagebox("Error", ex.getmessage())
			end try
		//end if
		//Fin SA56209
	END IF

END IF
ii_crear_trazo = 0

li_estado_trazo =  dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estado_crea")
IF li_estado_trazo = 1 THEN
	ii_crear_trazo = 1

	IF MessageBox("Advertencia", "Aun desea grabar este trazo como creado?", Question!, YesNo!, 2) = 2 THEN
		Return(1)
	END IF
	
	DO WHILE TRUE

	SELECT max(cf_consecutivos.cs_documento )  
	INTO :ll_cs_documento  
	FROM cf_consecutivos  
	WHERE ( cf_consecutivos.co_fabrica = 2 ) AND  
			( cf_consecutivos.id_documento = 55 );
	IF SQLCA.SQLCODE = -1 THEN
		MessageBox("Error","Hubo Problemas con la base de Datos: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
		Return(1)
	ELSE
		IF SQLCA.SQLCODE = 100 THEN
			MessageBox("Advertencia","No se encontro Consecutivo de Trazo, Favor llamar a Sistemas",Exclamation!,OK!)
			Return(1)
		ELSE
		  IF SQLCA.SQLCODE = 0 THEN
			  ll_cs_documento = ll_cs_documento + 1
			  UPDATE cf_consecutivos  
				SET cs_documento = cs_documento + 1  
			  WHERE ( cf_consecutivos.co_fabrica = 2 ) AND  
					 ( cf_consecutivos.id_documento = 55 );
			  IF SQLCA.SQLCODE = 1 THEN
				  MessageBox("Error","Hubo Problemas1 Actualizando Consecutivo de Trazo: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
				  ROLLBACK;
				  Return(1)
			  END IF
			  COMMIT;
			  
			  SELECT COUNT(*)
			    INTO :li_ya_existe
				 FROM h_trazos
			   WHERE co_trazo = :ll_cs_documento;
			  IF li_ya_existe = 0 THEN
				  EXIT 
			  END IF
		  END IF
		END IF
	END IF
	
LOOP
	
	ls_descripcion = 	 dw_maestro.GetItemString(il_fila_actual_maestro, "h_trazos_pend_de_trazo")
	IF ISNULL(ls_descripcion) THEN
		MessageBox("Advertencia","Debe Ingresar La descripcion del trazo",Exclamation!,OK!)
		Return(1)
	END IF
	
	ldt_fecha        = DateTime(Today(), Now())
	ls_molderia	     = dw_maestro.GetItemString(il_fila_actual_maestro, "molderia")
	ld_ancho         = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "ancho")
	ld_largo			  = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "largo")
	ld_porc_util     = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "porc_util")
	li_tipo			  = dw_maestro.GetItemNumber(il_fila_actual_maestro, "tipo")
	li_extendido     = dw_maestro.GetItemNumber(il_fila_actual_maestro, "extendido")
	li_forma_ext     = dw_maestro.GetItemNumber(il_fila_actual_maestro, "forma_ext")
	ld_repite        = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "repite") 
	ls_observaciones = dw_maestro.GetItemString(il_fila_actual_maestro, "h_trazos_pend_observaciones")
	ld_estab_largo   = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "h_trazos_pend_estab_largo")
	ld_estab_ancho   = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "h_trazos_pend_estab_ancho")
	li_raya			  = dw_maestro.GetItemDecimal(il_fila_actual_maestro, "h_trazos_pend_co_raya")
	IF ld_estab_largo > 0 AND ld_estab_ancho > 0 THEN
	ELSE
		MessageBox('Advertencia','Debe ingresar la estabilidad del trazo, no se cre$$HEX2$$f3002000$$ENDHEX$$el trazo')
		Return 1
	END IF
		
   INSERT INTO h_trazos(co_trazo, de_trazo, molderia, ancho, largo, porc_util, tipo, extendido,
								fe_creacion, fe_actualizacion, usuario, instancia, co_estado_trazo,
								forma_ext, repite, observaciones,optimizado, co_raya)
	VALUES(:ll_cs_documento, :ls_descripcion, :ls_molderia, :ld_ancho, :ld_largo, :ld_porc_util,
          :li_tipo, :li_extendido, :ldt_fecha, :ldt_fecha, :gstr_info_usuario.codigo_usuario,
			 :gstr_info_usuario.instancia, 1, :li_forma_ext, :ld_repite, :ls_observaciones,0, 
			 :li_raya) ;
	IF SQLCA.SQLCODE <> 0 THEN
	   MessageBox("Error","Hubo Problemas Insertando el Trazo: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
		ROLLBACK;
		Return(1)
	END IF
	
	INSERT INTO dt_refptxtrazo(co_trazo, co_fabrica, co_linea, co_referencia, fe_actualizacion,
	                           fe_creacion, usuario, instancia, estab_largo, estab_ancho)
	VALUES (:ll_cs_documento, :li_co_fabrica, :li_co_linea, :ll_co_referencia, :ldt_fecha,
	        :ldt_fecha, :gstr_info_usuario.codigo_usuario, :gstr_info_usuario.instancia,
			  :ld_estab_largo, :ld_estab_ancho	 );
	IF SQLCA.SQLCODE <> 0 THEN
	   MessageBox("Error","Hubo Problemas Insertando la Referencia del  Trazo: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
		ROLLBACK;
		Return(1)
	END IF

	ld_porc_util_ficha = of_traer_porc_util(li_co_fabrica, li_co_linea, ll_co_referencia, li_raya)
	li_tot_tallas = dw_detalle.RowCount()	
	FOR pos = 1 TO li_tot_tallas
		li_talla 	= dw_detalle.GetItemNumber(pos, "co_talla") 
		li_paquetes = dw_detalle.GetItemNumber(pos, "ca_paquetes") 
		
		INSERT INTO dt_tallasxtrazo(co_trazo, co_fabrica, co_linea, co_referencia, co_talla, ca_paquetes,
		                            fe_creacion, fe_actualizacion, usuario, instancia)
		VALUES (:ll_cs_documento, :li_co_fabrica, :li_co_linea, :ll_co_referencia, :li_talla, :li_paquetes,
		        :ldt_fecha, :ldt_fecha, :gstr_info_usuario.codigo_usuario, :gstr_info_usuario.instancia); 
	  	IF SQLCA.SQLCODE <> 0 THEN
		   MessageBox("Error","Hubo Problemas Insertando la Referencia del  Trazo: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
			ROLLBACK;
			Return(1)
		END IF
	NEXT
	

COMMIT;
	MessageBox("O.K","Se cre$$HEX2$$f3002000$$ENDHEX$$exitosamente el Trazo  No."+String(ll_cs_documento),Exclamation!)
ii_graba_maestro = 1
	
	SELECT COUNT(*)
	  INTO :li_trazos_ya_creados
	  FROM dt_refptxtrazo
	 WHERE co_fabrica = :li_co_fabrica
	   AND co_linea = :li_co_linea
		AND co_referencia = :ll_co_referencia;
	dw_usuarios.SetTransObject(SQLCA)
	IF li_trazos_ya_creados > 1 THEN
		dw_usuarios.Retrieve(1)  //correo solo a prog de oc
	ELSE
		dw_usuarios.Retrieve(9)  //correo a prog y molderia
	END IF

	
	//Enviar un correo avisando que se creo el trazo a los programadores de texografo (aplica = 1)
	//y a las personas de molderia en caso de que sea el primer trazo, esto aplica para la planta
	//marinilla, para Nicole no se envia correo ya que la persona que lo crea es la misma
	//que lo solicitad
	
   IF gstr_info_usuario.co_planta_pro = 2 THEN

		//SA56209 - Ceiba/reariase - 08-02-2017
		//envio de correo
		ls_referencia = dw_maestro.GetItemString(il_fila_actual_maestro, "h_trazos_pend_de_trazo")
		ls_trazo = STRING(ll_cs_documento)		
		ll_ordenpd = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_ordenpd_pt")
		//li_codigo_email = luo_constantes.of_consultar_numerico("USU_CORREO_PROG") co_aplica=9
		//if li_codigo_email <> -1 then 
			ls_mensaje = 'Ya esta creado el trazo: ' + Trim(ls_trazo) + ' descripcion ' + TRIM(ls_referencia) +  '  O.P. ' + Trim(STRING(ll_ordenpd)) &
										+ ' % Utilizacion: ' +	Trim(STRING(ld_porc_util)) + ' Ancho: ' +	Trim(STRING(ld_ancho)) + ' Largo: ' +	Trim(STRING(ld_largo)) &
										+  ' Molderia ' + Trim(STRING(ls_molderia))	
			try
				luo_correo.of_enviar_correo( "Trazo Solicitado Creado",ls_mensaje,'programacion_oc')
			catch(	Exception ex2)
				Messagebox("Error", ex2.getmessage())
			end try
		//end if
		//Fin SA56209
	END IF
END IF

end event

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_solicitud_trazos
integer x = 1783
integer y = 988
integer width = 969
integer height = 620
boolean titlebar = false
string dataobject = "dtb_dt_solicitud_trazos"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

event dw_detalle::itemchanged;call super::itemchanged;String ls_talla, ls_ref
Long li_fab, li_lin, li_talla
Long ll_ref

li_fab = dw_maestro.GetItemNumber(1,'co_fabrica')
li_lin = dw_maestro.GetItemNumber(1,'co_linea')
ll_ref = dw_maestro.GetItemNumber(1,'co_referencia')
ls_ref = string(ll_ref)

choose case dwo.name
	case 'co_talla'
		li_talla = Long(Data)
 

	SELECT m_tallas_x_grupo.de_talla
	  INTO :ls_talla
	  FROM  h_preref_pv, m_tallas_x_grupo
	 WHERE h_preref_pv.co_fabrica 		= :li_fab
		AND h_preref_pv.co_linea 			= :li_lin
		AND h_preref_pv.co_referencia 	= :ls_ref
		AND h_preref_pv.co_tipo_ref      = 'P'
		AND h_preref_pv.co_grupo_tlla 	= m_tallas_x_grupo.co_grupo_tlla 
		AND m_tallas_x_grupo.co_talla = :li_talla;
		
		
	This.SetItem(Row,'de_talla',Trim(ls_talla)) 
end choose


 
  
  
  
end event

event dw_detalle::retrieveend;call super::retrieveend;Long li_fila, li_fab, li_lin
Long ll_ref
String ls_talla, ls_ref, li_talla

li_fab = dw_maestro.GetItemNumber(1,'co_fabrica')
li_lin = dw_maestro.GetItemNumber(1,'co_linea')
ll_ref = dw_maestro.GetItemNumber(1,'co_referencia')

FOR li_fila = 1 TO This.RowCount()
	li_talla = string(This.GetItemNumber(li_fila,'co_talla'))
 
 ls_ref = string(ll_ref)

	SELECT m_tallas_x_grupo_pv.de_talla
	  INTO :ls_talla
	  FROM  h_preref_pv, m_tallas_x_grupo_pv
	 WHERE h_preref_pv.co_fabrica 		= :li_fab
		AND h_preref_pv.co_linea 			= :li_lin
		AND h_preref_pv.co_referencia 	= :ls_ref
		AND h_preref_pv.co_tipo_ref      = 'P'
		AND h_preref_pv.co_grupo_tlla 	= m_tallas_x_grupo_pv.co_grupo_tlla 
	   and m_tallas_x_grupo_pv.co_talla = :li_talla;
		
		
	This.SetItem(li_fila,'de_talla',Trim(ls_talla)) 
NEXT
end event

type cb_prioridad from commandbutton within w_solicitud_trazos
integer x = 2775
integer y = 1372
integer width = 270
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Prioridades"
end type

event clicked;String	ls_usuario
Long	li_existe

ls_usuario = gstr_info_usuario.codigo_usuario

li_existe = 0
SELECT COUNT(*)
  INTO :li_existe
  FROM m_usu_correo
 WHERE co_usuario = :ls_usuario
   AND co_aplica = 6;
IF li_existe > 0 THEN	
	OpenSheet(w_rep_trazos_pendientes, w_solicitud_trazos)
ELSE
	MessageBox('Advertencia','No autorizado para modificar Prioridad')
END IF
end event

type dw_imprimir from datawindow within w_solicitud_trazos
boolean visible = false
integer x = 1874
integer y = 984
integer width = 494
integer height = 360
integer taborder = 40
boolean bringtotop = true
string dataobject = "dtb_imp_solicitud_trazo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_imprimir from commandbutton within w_solicitud_trazos
integer x = 2775
integer y = 1188
integer width = 270
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Imprimir"
end type

event clicked;Long 		ll_consec_trazo

IF il_fila_actual_maestro > 0 THEN
	ll_consec_trazo = dw_maestro.GetItemNumber(il_fila_actual_maestro,'cs_trazo')
	DISCONNECT;
	SQLCA.Lock = "DIRTY READ"
	CONNECT USING SQLCA;
	dw_imprimir.SetTransObject(SQLCA)
	//
	dw_imprimir.visible = true
	dw_imprimir.Retrieve(ll_consec_trazo)
	SetPointer(Arrow!)
	
	
	
	dw_imprimir.setFocus()
	
	OpenWithParm(w_opciones_impresion, dw_imprimir)
END IF

end event

type dw_usuarios from datawindow within w_solicitud_trazos
boolean visible = false
integer x = 2158
integer y = 1696
integer width = 338
integer height = 352
integer taborder = 60
boolean bringtotop = true
string dataobject = "dtb_usuarios_enviar_correo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_trazadores from datawindow within w_solicitud_trazos
boolean visible = false
integer x = 2523
integer y = 1600
integer width = 334
integer height = 360
integer taborder = 60
boolean bringtotop = true
string dataobject = "dtb_usuarios_enviar_correo_trazador"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_info_molderias from datawindow within w_solicitud_trazos
integer y = 1344
integer width = 1769
integer height = 608
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_molderias_ops_agrupadas"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_solicitud_trazos
integer y = 1248
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cargar"
end type

event clicked;Long	ll_cs_ordenpd_pt
Long ll_co_color
	
ll_cs_ordenpd_pt	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_ordenpd_pt")
ll_co_color	= dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color")

dw_info_molderias.SetTransObject(SQLCA)
dw_info_molderias.Retrieve(ll_cs_ordenpd_pt,ll_co_color)

end event

