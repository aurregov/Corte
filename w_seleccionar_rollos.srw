HA$PBExportHeader$w_seleccionar_rollos.srw
forward
global type w_seleccionar_rollos from w_base_buscar_lista
end type
type st_4 from statictext within w_seleccionar_rollos
end type
type em_total_kgs from editmask within w_seleccionar_rollos
end type
end forward

global type w_seleccionar_rollos from w_base_buscar_lista
integer x = 142
integer y = 64
integer width = 2363
integer height = 1612
string title = "Seleccione ROLLOS..."
st_4 st_4
em_total_kgs em_total_kgs
end type
global w_seleccionar_rollos w_seleccionar_rollos

type variables
Long il_orden_corte, il_modelo, il_trazo, il_reftel, il_agrupacion, il_colorte
Long ii_seccion, ii_fabrica, ii_caract, ii_diametro, ii_liquidacion
Long ii_produccion, ii_base
end variables

forward prototypes
public function long wf_partir_rollo (long ai_cs_rollo, decimal ad_kilos_sacar)
end prototypes

public function long wf_partir_rollo (long ai_cs_rollo, decimal ad_kilos_sacar);LONG	   ll_cs_ordenpd_te_pg,	ll_cs_ordenpd_te_real,	ll_cs_ordenpr,	ll_co_reftel_pg, ll_cs_orden_pr_act
LONG		ll_co_reftel_act, ll_lote, ll_cs_tanda, ll_cs_ordencr, w_cs_rollo, li_co_maquina_tej, ll_co_color_pg, ll_co_color_act, ll_co_color_pt
Long	li_co_fabrica_pg,	li_co_caract_pg, li_diametro_pg
Long	li_co_fabrica_act, li_co_caract_act, li_diametro_act,	li_co_talla
Long	li_ca_unidades, li_cs_secundario, li_procfis, li_co_centro, li_co_estado_rollo, li_co_proveedor 
STRING	ls_ubicacion,   ls_atributo1, ls_atributo2, ls_usuario, ls_instancia	
DECIMAL{5}  ld_ca_prog,	ld_ca_mt, ld_ca_kg, ld_ca_kg_tenido, v_tenido_hijo, v_tenido_padre
DECIMAL{5}	ld_ancho_tub_term,	ld_gr_mt2_terminado, v_kilos_hijo, mr_partir_ca_prog
DATETIME ldt_fe_creacion, fe_hoy

fe_hoy =  DateTime(Today(), Now())
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia =  gstr_info_usuario.instancia	


SELECT 	cs_ordenpd_te_pg,	cs_ordenpd_te_real,	cs_ordenpr,			co_fabrica_pg,
			co_reftel_pg,		co_caract_pg,			diametro_pg,		co_color_pg,
			cs_orden_pr_act,	co_fabrica_act,		co_reftel_act,		co_caract_act,
			diametro_act,		co_color_act,			co_talla,			co_color_pt,
			ca_unidades,		co_maquina_tej,		lote, 				   cs_tanda,	
			cs_secundario,		ubicacion,				cs_ordencr,			ca_prog,	
			ca_mt,				ca_kg,					ca_kg_tenido,		procfis,
			co_centro,			co_estado_rollo,		ancho_tub_term,	gr_mt2_terminado,
			fe_creacion,		co_proveedor		
	


INTO	   :ll_cs_ordenpd_te_pg,	:ll_cs_ordenpd_te_real,	:ll_cs_ordenpr,		:li_co_fabrica_pg,
			:ll_co_reftel_pg,			:li_co_caract_pg,			:li_diametro_pg,		:ll_co_color_pg,
			:ll_cs_orden_pr_act,		:li_co_fabrica_act,		:ll_co_reftel_act,	:li_co_caract_act,
			:li_diametro_act,		   :ll_co_color_act,			:li_co_talla,			:ll_co_color_pt,	
			:li_ca_unidades,			:li_co_maquina_tej,		:ll_lote, 			   :ll_cs_tanda,
			:li_cs_secundario,		:ls_ubicacion,				:ll_cs_ordencr,		:ld_ca_prog,
			:ld_ca_mt,					:ld_ca_kg,					:ld_ca_kg_tenido,		:li_procfis,	
			:li_co_centro,		   	:li_co_estado_rollo,		:ld_ancho_tub_term,	:ld_gr_mt2_terminado,
			:ldt_fe_creacion,			:li_co_proveedor
			
	

	
FROM		m_rollo
WHERE    cs_rollo = :ai_cs_rollo;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error','Error al buscar datos del rollo')
	Return(0)
END IF

v_kilos_hijo = ad_kilos_sacar
mr_partir_ca_prog =  ld_ca_kg - v_kilos_hijo

v_tenido_hijo = ld_ca_kg_tenido * v_kilos_hijo
v_tenido_hijo = v_tenido_hijo / ld_ca_kg

v_tenido_padre = ld_ca_kg_tenido * mr_partir_ca_prog
v_tenido_padre = v_tenido_padre / ld_ca_kg

UPDATE m_rollo
   SET (ca_kg, ca_kg_tenido, fe_actualizacion, usuario, instancia)
	  = (:mr_partir_ca_prog, :v_tenido_padre, :fe_hoy, :ls_usuario, :ls_instancia)
WHERE cs_rollo = :ai_cs_rollo;	 
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al actualizar kilos de rollo padre al partir')
	Return(0)
END IF
 
SELECT cs_documento
  INTO :w_cs_rollo
  FROM cf_consecutivos
 WHERE co_fabrica = 2
   AND id_documento = 20;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al buscar consecutivo de rollo hijo')
	Return(0)
END IF
w_cs_rollo = w_cs_rollo + 1

ls_atributo1 = 'Hijo de  '+ STRING(ai_cs_rollo)

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
			lote_hilaza,		co_tip_hilaza)
VALUES ( :w_cs_rollo,
		   :ll_cs_ordenpd_te_pg,	:ll_cs_ordenpd_te_real,	:ll_cs_ordenpr,		:li_co_fabrica_pg,
			:ll_co_reftel_pg,			:li_co_caract_pg,			:li_diametro_pg,		:ll_co_color_pg,
			1,								1,								:ll_cs_orden_pr_act,	:li_co_fabrica_act,
			:ll_co_reftel_act,		:li_co_caract_act,		:li_diametro_act,		:ll_co_color_act,
			:li_co_talla,				:ll_co_color_pt,			:li_ca_unidades,		:li_co_maquina_tej,
			:ll_lote, 					:ll_cs_tanda,				:li_cs_secundario,	0,
			1,								:ls_ubicacion,				'',						:ll_cs_ordencr,		
			:v_tenido_padre,			:ld_ca_mt,					:v_kilos_hijo,			 :v_tenido_hijo,
			0,								:li_procfis,				:li_co_centro,			:li_co_estado_rollo,
			0,								0,								'',						1,
			1,								:ls_atributo1,				'',						0,
			0,								0,								:ld_ancho_tub_term,	:ld_gr_mt2_terminado,
			'',							1,								0,							:ldt_fe_creacion,	
			:fe_hoy,						:ls_usuario,				:ls_instancia,			:li_co_proveedor,		
			'',							0)	;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al Insertar rollo hijo')
	ROLLBACK;
	Return(0)
END IF

UPDATE cf_consecutivos
   SET cs_documento = cs_documento + 1
 WHERE co_fabrica = 2
   AND id_documento = 20;
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al actualizar consecutivo de rollo ')
	ROLLBACK;
	Return(0)
END IF

ls_atributo1 = 'Padre de ' + STRING(w_cs_rollo)
UPDATE m_rollo
   SET atributo1 = :ls_atributo1
WHERE cs_rollo = :ai_cs_rollo;	 
IF SQLCA.SQLCODE <> 0 THEN
	Messagebox('Error','Error al actualizar atributo de rollo padre al partir')
	ROLLBACK;
	Return(0)
END IF
    

return(w_cs_rollo)
end function

on w_seleccionar_rollos.create
int iCurrent
call super::create
this.st_4=create st_4
this.em_total_kgs=create em_total_kgs
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.em_total_kgs
end on

on w_seleccionar_rollos.destroy
call super::destroy
destroy(this.st_4)
destroy(this.em_total_kgs)
end on

event open;Long ll_numero_registros
Long li_centro
s_base_parametros lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	il_orden_corte = lstr_parametros.entero[1]
	il_agrupacion = lstr_parametros.entero[2]
	ii_produccion = lstr_parametros.entero[3]
	il_modelo = lstr_parametros.entero[4]
	ii_fabrica = lstr_parametros.entero[5]
	il_reftel = lstr_parametros.entero[6]
	ii_caract = lstr_parametros.entero[7]
	ii_diametro = lstr_parametros.entero[8]
	il_colorte = lstr_parametros.entero[9]
	ii_base = lstr_parametros.entero[10]	
	ii_liquidacion = lstr_parametros.entero[11]
	ll_numero_registros = dw_lista.retrieve(il_orden_corte, il_agrupacion, ii_produccion, il_modelo, &
			ii_fabrica, il_reftel, ii_caract, ii_diametro, il_colorte, ii_base, ii_liquidacion)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
	//			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			il_fila_actual = 1
	END CHOOSE
	
	dw_lista.modify("dw_lista.readonly=yes")
	dw_lista.setfocus()	
END IF
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_rollos
boolean visible = false
integer x = 219
integer y = 868
integer width = 1207
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_rollos
integer x = 1838
integer y = 1340
integer taborder = 90
string picturename = "cancelar.bmp"
end type

event pb_cancelar::clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_rollos
integer x = 1440
integer y = 1340
integer taborder = 80
boolean default = false
string picturename = "ok.bmp"
end type

event pb_aceptar::clicked;call super::clicked;Long ll_filas, ll_filaactual, ll_insertados
s_base_parametros lstr_parametros

ll_filas = dw_lista.RowCount()
ll_insertados = 1
FOR ll_filaactual = 1 TO ll_filas
	IF dw_lista.IsSelected(ll_filaactual) THEN
		ll_insertados = ll_insertados + 1		
		lstr_parametros.entero[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "cs_rollo")
		lstr_parametros.decimal[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_disponible")
	END If
NEXT
IF ll_insertados > 1 THEN
	lstr_parametros.entero[1] = ll_insertados
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros = False	
END IF

CloseWithReturn(Parent, lstr_parametros)

end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_rollos
integer y = 20
integer width = 2299
integer height = 1276
integer taborder = 50
string dataobject = "dtb_seleccionar_rollos"
boolean hscrollbar = false
end type

event dw_lista::rowfocuschanged;// Se omite el script


end event

event dw_lista::doubleclicked;//	NO HACE NADA
end event

event dw_lista::clicked;Decimal{2} ld_disponible, ld_total

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	ld_total = Dec(em_total_kgs.Text)
	IF this.IsSelected(Row) THEN
		This.SelectRow(Row, False)
		ld_disponible = This.GetItemNumber(Row, "ca_disponible")
		ld_total = ld_total - ld_disponible
	ELSE
		This.SelectRow(Row, True)
		ld_disponible = This.GetItemNumber(Row, "ca_disponible")
		ld_total = ld_total + ld_disponible
	END IF
	em_total_kgs.Text = String(ld_total, "###,###.00")
END IF
end event

type st_4 from statictext within w_seleccionar_rollos
integer x = 18
integer y = 1344
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Total Yardas Rollos Seleccionados:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_total_kgs from editmask within w_seleccionar_rollos
integer x = 805
integer y = 1340
integer width = 357
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 65535
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "###,###.00"
end type

