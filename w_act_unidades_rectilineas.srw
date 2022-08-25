HA$PBExportHeader$w_act_unidades_rectilineas.srw
$PBExportComments$Actualizar las unidades de rectilineos en corte
forward
global type w_act_unidades_rectilineas from w_base_tabular
end type
type dw_lds_imprimir_rollo from datawindow within w_act_unidades_rectilineas
end type
end forward

global type w_act_unidades_rectilineas from w_base_tabular
integer width = 2107
integer height = 1832
string title = "Actualizacion de unidades a Rectilineos"
string menuname = "m_cortar_rollos_rectilineos"
event ue_partir ( )
event ue_partir_mover ( )
dw_lds_imprimir_rollo dw_lds_imprimir_rollo
end type
global w_act_unidades_rectilineas w_act_unidades_rectilineas

forward prototypes
public function long of_partir_rectilineos (long al_rollo, long al_unid_act, long al_unid_devolver, decimal ad_mts_padre, decimal ad_kg_padre, long ai_movimiento)
public function long of_mover_bodega (long ai_concepto, long ai_origen, long ai_destino, long al_rollo, long al_tela, long ai_caract, long ai_diametro, long al_color, long al_op, long al_lote, decimal ad_kilos, long ai_fab_propietario, decimal ad_metros)
end prototypes

event ue_partir();//Este procedimiento parte un rollo que se encuentra en  corte
//generando un rollo hijo, el rollo se deja en corte sin orden 
//de corte y en estado disponible.

Long	li_tot_filas, li_fila, ll_tot_reg, li_actualizo
LONG		ll_rollo, ll_unid_act, ll_unid_devolver, ll_result, ll_ordenpd_pt
DECIMAL{3}	ld_mts_padre, ld_kg_padre
STRING	ls_rollos_partio, ls_usuario	

IF MessageBox("Advertencia", "Esta Seguro de Partir los rollos?", Question!, YesNo!, 2) = 2 THEN
	Return
END IF

ll_result = 0
li_actualizo = 0
ls_rollos_partio = ' '
li_tot_filas = dw_maestro.RowCount()
IF li_tot_filas > 0 THEN
	dw_maestro.Accepttext()
	FOR li_fila = 1 TO li_tot_filas
		ll_rollo = dw_maestro.GetItemNumber(li_fila, 'cs_rollo') 
		ll_unid_act = dw_maestro.GetItemNumber(li_fila, 'ca_unidades') 
		ll_unid_devolver = dw_maestro.GetItemNumber(li_fila, 'unid_devolver') 
		ld_mts_padre = dw_maestro.GetItemNumber(li_fila, 'ca_mt') 
		ld_kg_padre = dw_maestro.GetItemNumber(li_fila, 'ca_kg') 
		ll_ordenpd_pt = dw_maestro.GetItemNumber(li_fila, 'm_rollo_cs_orden_pr_act') 
		IF (ll_unid_devolver >= ll_unid_act) THEN
			MessageBox('Advertencia','El rollo: ' + string(ll_rollo) + ' Tiene mayor las unidades a dejar que las &
							 que tiene el rollo' )
			Return
		END IF
		IF (ll_unid_act = 0) THEN
			MessageBox('Advertencia','El rollo: ' + string(ll_rollo) + ' Tiene Unidades Actuales en Cero')
		ELSE
			IF (ll_unid_devolver < ll_unid_act) AND (ll_unid_devolver > 0) THEN
				ll_result = of_partir_rectilineos(ll_rollo,ll_unid_act,ll_unid_devolver,ld_mts_padre,ld_kg_padre,0)
				IF ll_result = 0 THEN
					Rollback;
					MessageBox('Error','Se produjo un error partiendo los rectilineos')
					Return
				END IF
				ls_rollos_partio = ls_rollos_partio + string(ll_result) + ' - '
				li_actualizo = 1
			END IF
		END IF
		
	NEXT
	
	IF li_actualizo = 1 THEN
		COMMIT;
		MessageBox('O.K.','Proceso Correcto, se Generaron los rollos hijos: ' + ls_rollos_partio)
	END IF
	
ELSE
	MessageBox('Error','No se encontraron registros')
END IF

ls_usuario = gstr_info_usuario.codigo_usuario
ll_tot_reg = dw_lds_imprimir_rollo.Retrieve(ll_ordenpd_pt, 0, 0, 0,0, ls_usuario)

OpenWithParm(w_opciones_impresion, dw_lds_imprimir_rollo)


end event

event ue_partir_mover();//Este procedimiento parte un rollo que se encuentra en  corte
//generando un rollo hijo y luego mueve el rollo hijo a tela
//terminada, dejando el hijo sin orden de corte.

Long	li_tot_filas, li_fila, ll_tot_reg, li_actualizo
LONG		ll_rollo, ll_unid_act, ll_unid_devolver, ll_result, ll_ordenpd_pt
DECIMAL{3}	ld_mts_padre, ld_kg_padre
STRING	ls_rollos_partio, ls_usuario	

IF MessageBox("Advertencia", "Esta Seguro de Partir los rollos?", Question!, YesNo!, 2) = 2 THEN
	Return
END IF

ll_result = 0
li_actualizo = 0
ls_rollos_partio = ' '
li_tot_filas = dw_maestro.RowCount()
IF li_tot_filas > 0 THEN
	dw_maestro.Accepttext()
	FOR li_fila = 1 TO li_tot_filas
		ll_rollo = dw_maestro.GetItemNumber(li_fila, 'cs_rollo') 
		ll_unid_act = dw_maestro.GetItemNumber(li_fila, 'ca_unidades') 
		ll_unid_devolver = dw_maestro.GetItemNumber(li_fila, 'unid_devolver') 
		ld_mts_padre = dw_maestro.GetItemNumber(li_fila, 'ca_mt') 
		ld_kg_padre = dw_maestro.GetItemNumber(li_fila, 'ca_kg') 
		ll_ordenpd_pt = dw_maestro.GetItemNumber(li_fila, 'm_rollo_cs_orden_pr_act') 
		IF (ll_unid_devolver >= ll_unid_act) THEN
			MessageBox('Advertencia','El rollo: ' + string(ll_rollo) + ' Tiene mayor las unidades a dejar que las &
							 que tiene el rollo' )
			Return
		END IF
		IF (ll_unid_act = 0) THEN
			MessageBox('Advertencia','El rollo: ' + string(ll_rollo) + ' Tiene Unidades Actuales en Cero')
		ELSE
			IF (ll_unid_devolver < ll_unid_act) AND (ll_unid_devolver > 0) THEN
				ll_result = of_partir_rectilineos(ll_rollo,ll_unid_act,ll_unid_devolver,ld_mts_padre,ld_kg_padre,1)
				IF ll_result = 0 THEN
					Rollback;
					MessageBox('Error','Se produjo un error partiendo los rectilineos')
					Return
				END IF
				ls_rollos_partio = ls_rollos_partio + string(ll_result) + ' - '
				li_actualizo = 1
			END IF
		END IF
		
	NEXT
	
	IF li_actualizo = 1 THEN
		COMMIT;
		MessageBox('O.K.','Proceso Correcto, se Generaron los rollos hijos: ' + ls_rollos_partio)
	END IF
	
ELSE
	MessageBox('Error','No se encontraron registros')
END IF

ls_usuario = gstr_info_usuario.codigo_usuario
ll_tot_reg = dw_lds_imprimir_rollo.Retrieve(ll_ordenpd_pt, 0, 0, 0,0, ls_usuario)

OpenWithParm(w_opciones_impresion, dw_lds_imprimir_rollo)


end event

public function long of_partir_rectilineos (long al_rollo, long al_unid_act, long al_unid_devolver, decimal ad_mts_padre, decimal ad_kg_padre, long ai_movimiento);LONG 		ll_unid_nuevo_rollo, w_cs_rollo, ll_unid_padre, ll_co_color_pg, ll_co_color_act, ll_co_color_pt
STRING	ls_atributo1
Long	ll_result, li_concepto, li_destino
DECIMAL{3}	ld_mts_nuevo_rollo, ld_kg_nuevo_rollo, ld_mts_dejar_padre, ld_kg_dejar_padre

Long	li_co_fabrica_pg, li_co_caract_pg, li_diametro_pg, li_planeador, li_planta, li_co_fabrica_act, &
			li_procfis, li_co_proveedor, li_calidad, li_co_caract_act, li_diametro_act, li_co_talla, &
			li_co_maquina_tej, li_cs_secundario, li_co_centro, li_co_estado_rollo, li_caract_final, &
			li_fab_propietario
LONG		ll_cs_ordenpd_te_pg, ll_cs_ordenpd_te_real, ll_cs_ordenpr, ll_co_reftel_pg, ll_cs_orden_pr_act, ll_co_reftel_act, &
			ll_lote, ll_cs_tanda, ll_cs_ordencr
STRING	ls_ubicacion, ls_lote_hilaza, ls_tono, ls_usuario, ls_instancia
DECIMAL{3}	ld_prog_padre, ld_mts_padre, ld_kg_padre, ld_tenido_padre, ld_ancho_tub_term, ld_gr_mt2_terminado
DATETIME	ld_fe_actual

ld_fe_actual =  DateTime(Today(), Now())
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia =  gstr_info_usuario.instancia	

ll_unid_nuevo_rollo = al_unid_devolver
ld_mts_nuevo_rollo = (al_unid_devolver * ad_mts_padre) / al_unid_act
ld_kg_nuevo_rollo =  (al_unid_devolver * ad_kg_padre) / al_unid_act

ld_mts_dejar_padre = ad_mts_padre - ld_mts_nuevo_rollo
ld_kg_dejar_padre  = ad_kg_padre - ld_kg_nuevo_rollo
ll_unid_padre = al_unid_act - al_unid_devolver

SELECT cs_documento
  INTO :w_cs_rollo
  FROM cf_consecutivos
 WHERE co_fabrica = 2
   AND id_documento = 20;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al buscar consecutivo de rollo hijo')
	Return(0)
END IF

UPDATE cf_consecutivos
   SET cs_documento = cs_documento + 1
 WHERE co_fabrica = 2
   AND id_documento = 20;
IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK;
	Messagebox('Error','Error al actualizar consecutivo de rollo ')
	Return(0)
END IF

SELECT   cs_ordenpd_te_pg,	cs_ordenpd_te_real,	cs_ordenpr,			co_fabrica_pg,			co_reftel_pg,	
         co_caract_pg,		diametro_pg,		   co_color_pg,		co_planeador,		   co_planta,
			cs_orden_pr_act,	co_fabrica_act,		co_reftel_act,		co_caract_act,			diametro_act,	
			co_color_act,		co_talla,		   	co_color_pt,		co_maquina_tej,   	lote,
			cs_tanda,			cs_secundario,			ubicacion,			cs_ordencr,				ca_prog,			
			ca_mt,				ca_kg,					ca_kg_tenido,		procfis,					co_centro,	
			co_estado_rollo,	co_calidad,				ancho_tub_term,	gr_mt2_terminado,		co_proveedor,	
			lote_hilaza,		co_caract_final,		co_tono, 		   co_fab_propietario
  INTO   :ll_cs_ordenpd_te_pg,	:ll_cs_ordenpd_te_real,	:ll_cs_ordenpr,		:li_co_fabrica_pg,	:ll_co_reftel_pg,
         :li_co_caract_pg,			:li_diametro_pg,		   :ll_co_color_pg,		:li_planeador,			:li_planta,		
			:ll_cs_orden_pr_act,	   :li_co_fabrica_act,		:ll_co_reftel_act,	:li_co_caract_act,	:li_diametro_act,		
			:ll_co_color_act,			:li_co_talla,				:ll_co_color_pt,		:li_co_maquina_tej,  :ll_lote, 	
			:ll_cs_tanda,				:li_cs_secundario,		:ls_ubicacion,			:ll_cs_ordencr,		:ld_prog_padre,	
			:ld_mts_padre,				:ld_kg_padre,				:ld_tenido_padre,		:li_procfis,			:li_co_centro,	
			:li_co_estado_rollo,		:li_calidad,				:ld_ancho_tub_term,	:ld_gr_mt2_terminado,:li_co_proveedor,	
			:ls_lote_hilaza,			:li_caract_final,			:ls_tono,				:li_fab_propietario	
  FROM m_rollo
 WHERE cs_rollo = :al_rollo; 
IF SQLCA.SQLCODE = 0 THEN
ELSE
	ROLLBACK;
	Messagebox('Error','Error al traer datos de rollo padre')
	Return(0)
END IF
 
w_cs_rollo = w_cs_rollo + 1

ls_atributo1 = 'Hijo de  '+ STRING(al_rollo)

INSERT INTO m_rollo (cs_rollo, 
	      cs_ordenpd_te_pg,	cs_ordenpd_te_real,	cs_ordenpr,			co_fabrica_pg,
			co_reftel_pg,		co_caract_pg,			diametro_pg,		co_color_pg,
			co_planeador,		co_planta,				cs_orden_pr_act,	co_fabrica_act,
			co_reftel_act,		co_caract_act,			diametro_act,		co_color_act,
			co_talla,			co_color_pt,			ca_unidades,		co_maquina_tej,
			lote, 				cs_tanda,				cs_secundario,		co_maquina_tint,
			bodega,				ubicacion,				cs_ordenbp,			cs_ordencr,		
			ca_prog,				ca_mt,					ca_kg,				ca_kg_tenido,
			pedexpor,			procfis,					co_centro,			co_estado_rollo,
			prioridad,			marca,					corte,				paso,
			co_calidad,			atributo1,				atributo2,			ancho_abierto_crud,
			ancho_abierto_term,ancho_tub_crudo,		ancho_tub_term,	gr_mt2_terminado,
			localizacion_ant,	cs_secuencia_prog,	sw_impresion,		fe_creacion,	
			fe_actualizacion,	usuario,					instancia,			co_proveedor,	
			lote_hilaza,		co_tip_hilaza,			co_caract_final,	co_tono,
			co_fab_propietario)
VALUES ( :w_cs_rollo,
		   :ll_cs_ordenpd_te_pg,	:ll_cs_ordenpd_te_real,	:ll_cs_ordenpr,		:li_co_fabrica_pg,
			:ll_co_reftel_pg,			:li_co_caract_pg,			:li_diametro_pg,		:ll_co_color_pg,
			:li_planeador,				:li_planta,					:ll_cs_orden_pr_act,	:li_co_fabrica_act,
			:ll_co_reftel_act,		:li_co_caract_act,		:li_diametro_act,		:ll_co_color_act,
			:li_co_talla,				:ll_co_color_pt,			:ll_unid_nuevo_rollo,:li_co_maquina_tej,
			:ll_lote, 					:ll_cs_tanda,				:li_cs_secundario,	0,
			1,								:ls_ubicacion,				'',						0,		
			:ld_kg_nuevo_rollo,		:ld_mts_nuevo_rollo,		:ld_kg_nuevo_rollo,	:ld_kg_nuevo_rollo,
			0,								:li_procfis,				:li_co_centro,			2,
			0,								0,								'',						1,
			:li_calidad,				:ls_atributo1,				'',						0,
			0,								0,								:ld_ancho_tub_term,	:ld_gr_mt2_terminado,
			'',							1,								0,							:ld_fe_actual,	
			:ld_fe_actual,				:ls_usuario,				:ls_instancia,			:li_co_proveedor,		
			'',							0,								:li_caract_final,		:ls_tono,
			:li_fab_propietario)	;
IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK;
	Messagebox('Error','Error al Insertar rollo hijo')
	Return(0)
END IF

ls_atributo1 = 'Padre de ' + STRING(w_cs_rollo)
UPDATE m_rollo
   SET ca_mt		 = :ld_mts_dejar_padre,
		 ca_kg		 = :ld_kg_dejar_padre,	
     	 ca_unidades = :ll_unid_padre,
	    atributo1   = :ls_atributo1,
       fe_actualizacion = :ld_fe_actual,
		 usuario 	= :ls_usuario,
		 instancia	= :ls_instancia
WHERE cs_rollo = :al_rollo;	 
IF SQLCA.SQLCODE <> 0 THEN
	ROLLBACK;
	Messagebox('Error','Error al actualizar atributo de rollo padre al partir')
	Return(0)
END IF

IF ai_movimiento = 1 THEN   //mover al 15 se pone fijo por ahora el concepto y origen
	li_concepto = 16   //concepto de devolucion del 90 al 15
	li_destino = 15	//centro bodega de tela terminada
	ll_result = of_mover_bodega(li_concepto,li_co_centro,li_destino,w_cs_rollo,ll_co_reftel_act,li_co_caract_act,li_diametro_act, &
               ll_co_color_act,ll_cs_orden_pr_act,ll_lote,ld_kg_nuevo_rollo,li_fab_propietario,ld_mts_nuevo_rollo)
	IF ll_result = 1 THEN
	ELSE
		ROLLBACK;
		Return 0
	END IF
END IF


RETURN w_cs_rollo   //salio correctamente de partir el rollo
end function

public function long of_mover_bodega (long ai_concepto, long ai_origen, long ai_destino, long al_rollo, long al_tela, long ai_caract, long ai_diametro, long al_color, long al_op, long al_lote, decimal ad_kilos, long ai_fab_propietario, decimal ad_metros);STRING	ls_usuario, ls_instancia, ls_mensaje
LONG		ll_documento
Long	li_co_caract_nue
DATETIME	ldt_ano_mes

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia

SELECT ano_mes
  INTO :ldt_ano_mes
  FROM cf_user_prod
 WHERE usuario = :ls_usuario;
 IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al buscar el a$$HEX1$$f100$$ENDHEX$$o_mes')
	RETURN 0
END IF

//traer documento
SELECT cs_concepto
  INTO :ll_documento
  FROM m_consecutivos
 WHERE co_fabrica  = 2
	AND co_concepto = :ai_concepto;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al buscar el numero del documento')
	RETURN 0
END IF
		
ll_documento = ll_documento + 1 

UPDATE m_consecutivos
SET cs_concepto = :ll_documento
WHERE co_fabrica  = 2
  AND co_concepto = :ai_concepto;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al actualizar el numero del documento')
	RETURN 0
END IF
	  
//Inserta en h_kardex
INSERT INTO h_kardex ( co_fabrica, co_concepto, documento, documento_ext, origen, destino,
							  fe_kardex, hora, ano_mes, usuario, instancia, co_fab_propietario )
VALUES (2, :ai_concepto, :ll_documento, :ll_documento, :ai_origen, :ai_destino, CURRENT,
		  CURRENT, :ldt_ano_mes, :ls_usuario, :ls_instancia, :ai_fab_propietario );
IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
	ROLLBACK;
   Messagebox('Error',ls_mensaje)
	RETURN 0
END IF

//Valida la ruta de la caract
SELECT m_rutas.co_caract_nue
  INTO :li_co_caract_nue
  FROM m_rutas 
 WHERE m_rutas.co_concepto  = :ai_concepto
   AND m_rutas.origen = :ai_origen
   AND m_rutas.destino = :ai_destino
	AND m_rutas.co_caract = :ai_caract;
IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
  	ROLLBACK;
	Messagebox('Error',ls_mensaje)
	RETURN 0
END IF

SELECT ca_kg
  INTO :ad_kilos
  FROM m_rollo
 WHERE cs_rollo = :al_rollo;
IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
  	ROLLBACK;
	Messagebox('Error',ls_mensaje)
	RETURN 0
END IF

//Inserta en dt_kardex
INSERT INTO dt_kardex (co_fabrica, co_concepto, documento, item, cs_rollo, cs_ordenpd, co_reftel, co_caract,
                       co_color, diametro, ubicacion, ca_kardex_kg, ca_kardex_mt, pr_kardex, co_recurso,
                       co_caractn, lote, fe_ingreso, usuario_upd, fe_actualizacion, usuario, instancia,
							  co_fab_propietario)
				   VALUES (2, :ai_concepto, :ll_documento, 1, :al_rollo, :al_op, :al_tela, :ai_caract,
                       :al_color, :ai_diametro, 0, :ad_kilos, :ad_metros, 0, 0, :li_co_caract_nue,
							  :al_lote, current, :ls_usuario, current, :ls_usuario, :ls_instancia, :ai_fab_propietario )	;			
IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
	ROLLBACK;
	Messagebox('Error',ls_mensaje)
	RETURN 0
END IF

UPDATE m_rollo 
SET co_centro = :ai_destino,
	 co_caract_act = :ai_caract,
	 fe_actualizacion = current,
	 usuario = :ls_usuario,
	 instancia = :ls_instancia
WHERE cs_rollo = :al_rollo;	 
IF SQLCA.SQLCODE <> 0 THEN
	ls_mensaje = SQLCA.SQLERRTEXT
	ROLLBACK;
	Messagebox('Error',ls_mensaje)
	RETURN 0
END IF

RETURN 1

end function

on w_act_unidades_rectilineas.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_cortar_rollos_rectilineos" then this.MenuID = create m_cortar_rollos_rectilineos
this.dw_lds_imprimir_rollo=create dw_lds_imprimir_rollo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lds_imprimir_rollo
end on

on w_act_unidades_rectilineas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lds_imprimir_rollo)
end on

event open;//nada

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF


This.x = 1
This.y = 1

dw_lds_imprimir_rollo.SetTransObject(SQLCA)
end event

event ue_insertar_maestro;//no insertar
end event

event ue_borrar_maestro;//no borrar
end event

event ue_grabar;//no
end event

type dw_maestro from w_base_tabular`dw_maestro within w_act_unidades_rectilineas
integer y = 104
integer width = 1979
integer height = 1468
integer taborder = 20
string dataobject = "dtb_act_unidades_rectilineas"
end type

event dw_maestro::itemchanged;//nada

end event

type sle_argumento from w_base_tabular`sle_argumento within w_act_unidades_rectilineas
integer y = 4
integer width = 494
integer height = 88
integer taborder = 10
integer textsize = -10
fontcharset fontcharset = ansi!
end type

event sle_argumento::modified;LONG	ll_orden_corte
ll_orden_corte = LONG(sle_argumento.text)

dw_maestro.settransobject(sqlca)
dw_maestro.Retrieve(ll_orden_corte)


end event

type st_1 from w_base_tabular`st_1 within w_act_unidades_rectilineas
integer y = 16
integer weight = 700
fontcharset fontcharset = ansi!
string text = "Ord Cte:"
end type

type dw_lds_imprimir_rollo from datawindow within w_act_unidades_rectilineas
boolean visible = false
integer x = 1317
integer y = 12
integer width = 686
integer height = 276
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_tarjetas_rollos_programacion"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

