HA$PBExportHeader$w_crear_ordenes.srw
forward
global type w_crear_ordenes from window
end type
type dw_unidades from uo_dtwndow within w_crear_ordenes
end type
type dw_trazos from uo_dtwndow within w_crear_ordenes
end type
type dw_rayas from uo_dtwndow within w_crear_ordenes
end type
type dw_observacion from uo_dtwndow within w_crear_ordenes
end type
type dw_escala from uo_dtwndow within w_crear_ordenes
end type
type dw_corte from uo_dtwndow within w_crear_ordenes
end type
type gb_1 from groupbox within w_crear_ordenes
end type
type gb_2 from groupbox within w_crear_ordenes
end type
type gb_3 from groupbox within w_crear_ordenes
end type
type gb_4 from groupbox within w_crear_ordenes
end type
type gb_5 from groupbox within w_crear_ordenes
end type
type gb_6 from groupbox within w_crear_ordenes
end type
end forward

global type w_crear_ordenes from window
integer width = 3689
integer height = 1844
boolean titlebar = true
string title = "Ordenes"
string menuname = "m_mantenimiento_creacion_orden"
boolean controlmenu = true
boolean minbox = true
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_buscar ( )
event ue_crear_orden ( )
event ue_grabar pbm_custom01
event ue_insertar_detalle pbm_custom01
event ue_borrar_detalle pbm_custom02
event ue_orden ( )
dw_unidades dw_unidades
dw_trazos dw_trazos
dw_rayas dw_rayas
dw_observacion dw_observacion
dw_escala dw_escala
dw_corte dw_corte
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_crear_ordenes w_crear_ordenes

type variables

Integer ii_sw_cambio_tipo
end variables

event ue_buscar();n_cts_param luo_param



Open(w_parametro_corte)

luo_param = Message.PowerObjectParm

If IsValid(luo_param) Then
	dw_corte.Retrieve(luo_param.il_Vector[1])
	dw_escala.Retrieve(luo_param.il_Vector[1])
	dw_observacion.Retrieve(luo_param.il_Vector[1])
	dw_rayas.Retrieve(luo_param.il_Vector[1])
End If


end event

event ue_crear_orden();This.X = 1
This.Y = 1

Open(w_crear_orden_corte)
end event

event ue_grabar;IF dw_escala.AcceptText() = 1 THEN
	IF dw_escala.Update() = 1 THEN
		IF dw_observacion.AcceptText() = 1 THEN
			IF dw_observacion.Update() = 1 THEN
				IF dw_rayas.AcceptText() = 1 THEN
					IF dw_rayas.Update() = 1 THEN
						IF dw_trazos.AcceptText() = 1 THEN
							IF dw_trazos.Update() = 1 THEN
								IF dw_unidades.AcceptText() = 1 THEN
									IF dw_unidades.Update() = 1 THEN
										COMMIT;
									ELSE
										ROLLBACK;
									END IF
								ELSE
									MessageBox("Error...","No se pudieron hacer las actualizaciones de unidades")
									ROLLBACK;
								END IF
							ELSE
								ROLLBACK;
							END IF
						ELSE
							MessageBox("Error...","No se pudieron hacer las actualizaciones de trazos")
							ROLLBACK;							
						END IF
					ELSE
						ROLLBACK;
					END IF
				ELSE
					MessageBox("Error...","No se pudieron hacer las actualizaciones de las rayas")
					ROLLBACK;					
				END IF
			ELSE
				ROLLBACK;
			END IF
		ELSE
			MessageBox("Error...","No se pudieron hacer las actualizaciones de las observaciones")
			ROLLBACK;			
		END IF
	ELSE
		ROLLBACK;
	END IF
ELSE
	MessageBox("Error...","No se pudieron hacer las actualizaciones de las escalas")
	ROLLBACK;	
END IF
end event

event ue_insertar_detalle;Long ll_ordencorte
Long li_fila

IF dw_corte.RowCount() > 0 THEN
	ll_ordencorte = dw_corte.GetItemNumber(1, "cs_orden_corte")
	li_fila = dw_observacion.InsertRow(0)
	dw_observacion.SetItem(li_fila, "cs_orden_corte", ll_ordencorte)
	dw_observacion.SetItem(li_fila, "fe_creacion", f_fecha_servidor())
END IF
end event

event ue_borrar_detalle;Long li_fila

li_fila = dw_observacion.GetRow()
IF li_fila > 0 THEN
	dw_observacion.DeleteRow(li_fila)
END IF
end event

event ue_orden();Long ll_orden
s_base_parametros lstr_parametros

dw_corte.AcceptText()

ll_orden = dw_corte.GetItemNumber(1,'cs_orden_corte')

lstr_parametros.entero[1] = ll_orden

OpenWithParm(w_orden_guias_numeracion,lstr_parametros)
end event

on w_crear_ordenes.create
if this.MenuName = "m_mantenimiento_creacion_orden" then this.MenuID = create m_mantenimiento_creacion_orden
this.dw_unidades=create dw_unidades
this.dw_trazos=create dw_trazos
this.dw_rayas=create dw_rayas
this.dw_observacion=create dw_observacion
this.dw_escala=create dw_escala
this.dw_corte=create dw_corte
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.Control[]={this.dw_unidades,&
this.dw_trazos,&
this.dw_rayas,&
this.dw_observacion,&
this.dw_escala,&
this.dw_corte,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5,&
this.gb_6}
end on

on w_crear_ordenes.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_unidades)
destroy(this.dw_trazos)
destroy(this.dw_rayas)
destroy(this.dw_observacion)
destroy(this.dw_escala)
destroy(this.dw_corte)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
end on

event open;
n_cts_constantes_corte luo_constante_corte
n_cst_string lnv_string
Long ll_cont, ll_array[]
String ls_perfiles


dw_corte.SetTransObject(Sqlca)
dw_escala.SetTransObject(Sqlca)
dw_observacion.SetTransObject(Sqlca)
dw_rayas.SetTransObject(Sqlca)
dw_trazos.SetTransObject(Sqlca)
dw_unidades.SetTransObject(Sqlca)

//toma los perfiles
ls_perfiles = luo_constante_corte.of_consultar_texto("PERFIL_CAMBIO_TIPO")

lnv_string	= CREATE n_cst_string	

//los perfiles los pasa a un arreglo
lnv_string.of_convertirstring_array(ls_perfiles,ll_array)

Destroy lnv_string

ii_sw_cambio_tipo = 0
//busca el perfil en el arreglo 
FOR ll_cont=1 to upperbound(ll_array[]) 
	IF gstr_info_usuario.codigo_perfil = Long(ll_array[ll_cont]) THEN
		ii_sw_cambio_tipo = 1
	END IF
NEXT

If ii_sw_cambio_tipo = 0 Then
	dw_corte.Modify("co_tipo.TabSequence='0'")
End if

This.TriggerEvent("ue_buscar")

end event

type dw_unidades from uo_dtwndow within w_crear_ordenes
integer x = 1454
integer y = 1272
integer width = 2181
integer height = 376
integer taborder = 80
string dataobject = "d_dt_unidadesxtrazo"
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;call super::rbuttondown;s_base_parametros lstr_parametros

IF Row > 0 THEN
	lstr_parametros.entero[1] = This.GetItemNumber(Row, 'cs_orden_corte')
	lstr_parametros.entero[2] = This.GetItemNumber(Row, 'cs_agrupacion')
	lstr_parametros.entero[3] = This.GetItemNumber(Row, 'cs_base_trazos')
	lstr_parametros.entero[4] = This.GetItemNumber(Row, 'cs_trazo')
	lstr_parametros.entero[5] = This.GetItemNumber(Row, 'cs_seccion')
	lstr_parametros.entero[6] = This.GetItemNumber(Row, 'cs_pdn')
	lstr_parametros.entero[7] = This.GetItemNumber(Row, 'co_modelo')
	lstr_parametros.entero[8] = This.GetItemNumber(Row, 'co_fabrica_tela')
	lstr_parametros.entero[9] = This.GetItemNumber(Row, 'co_reftel')
	lstr_parametros.entero[10] = This.GetItemNumber(Row, 'co_caract')
	lstr_parametros.entero[11] = This.GetItemNumber(Row, 'diametro')
	lstr_parametros.entero[12] = This.GetItemNumber(Row, 'co_color_te')
	lstr_parametros.entero[13] = This.GetItemNumber(Row, 'co_talla')
	lstr_parametros.entero[14] = This.GetItemNumber(Row, 'paquetes')	
	OpenWithParm(w_letras_paquetes, lstr_parametros)
END IF
end event

type dw_trazos from uo_dtwndow within w_crear_ordenes
integer x = 1454
integer y = 664
integer width = 2181
integer height = 532
integer taborder = 70
string dataobject = "d_dt_trazozxoc"
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;Long	li_produccion, li_fabtela, li_caract, li_diametro, li_seccion
Long	ll_ordencorte, ll_agrupacion, ll_modelo, ll_reftel, ll_color, ll_basetrazo, ll_trazo

IF CurrentRow > 0 THEN
	ll_ordencorte = This.GetItemNumber(CurrentRow, "cs_orden_corte")
	ll_agrupacion = This.GetItemNumber(CurrentRow, "cs_agrupacion")
	li_produccion = This.GetItemNumber(CurrentRow, "cs_pdn")
	ll_modelo = This.GetItemNumber(CurrentRow, "co_modelo")
	li_fabtela = This.GetItemNumber(CurrentRow, "co_fabrica_tela")
	ll_reftel = This.GetItemNumber(CurrentRow, "co_reftel")
	li_caract = This.GetItemNumber(CurrentRow, "co_caract")
	li_diametro = This.GetItemNumber(CurrentRow, "diametro")
	ll_color = This.GetItemNumber(CurrentRow, "co_color_te")
	ll_basetrazo = This.GetItemNumber(CurrentRow, "cs_base_trazos")
	ll_trazo = This.GetItemNumber(CurrentRow, "cs_trazo")
	li_seccion = This.GetItemNumber(CurrentRow, "cs_seccion")
	dw_unidades.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_modelo, li_fabtela, ll_reftel, &
		li_caract, li_diametro, ll_color, ll_trazo, li_seccion, ll_basetrazo)
END IF
end event

type dw_rayas from uo_dtwndow within w_crear_ordenes
integer x = 1454
integer y = 60
integer width = 2181
integer height = 524
integer taborder = 60
string dataobject = "d_dt_rayas_x_telaoc"
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;Long	li_produccion, li_fabtela, li_caract, li_diametro, li_seccion
Long	ll_ordencorte, ll_agrupacion, ll_modelo, ll_reftel, ll_color
Long	ll_trazo, ll_basetrazo

IF CurrentRow > 0 THEN
	ll_ordencorte = This.GetItemNumber(CurrentRow, "cs_orden_corte")
	ll_agrupacion = This.GetItemNumber(CurrentRow, "cs_agrupacion")
	li_produccion = This.GetItemNumber(CurrentRow, "cs_pdn")
	ll_modelo = This.GetItemNumber(CurrentRow, "co_modelo")
	li_fabtela = This.GetItemNumber(CurrentRow, "co_fabrica_tela")
	ll_reftel = This.GetItemNumber(CurrentRow, "co_reftel")
	li_caract = This.GetItemNumber(CurrentRow, "co_caract")
	li_diametro = This.GetItemNumber(CurrentRow, "diametro")
	ll_color = This.GetItemNumber(CurrentRow, "co_color_te")
	ll_basetrazo = This.GetItemNumber(CurrentRow, "cs_base_trazos")
	dw_trazos.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_basetrazo, ll_modelo, li_fabtela, &
											ll_reftel, li_caract, li_diametro, ll_color)
	ll_trazo = dw_trazos.GetItemNumber(1, "cs_trazo")
	li_seccion = dw_trazos.GetItemNumber(1, "cs_seccion")											
	dw_unidades.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_modelo, li_fabtela, ll_reftel, &
		li_caract, li_diametro, ll_color, ll_trazo, li_seccion, ll_basetrazo)
END IF
end event

type dw_observacion from uo_dtwndow within w_crear_ordenes
integer x = 9
integer y = 1396
integer width = 1394
integer height = 272
integer taborder = 60
string dataobject = "d_dt_observa_oc"
borderstyle borderstyle = stylelowered!
end type

event updatestart;call super::updatestart;Long li_observacion, li_filas, li_fila_actual
Long ll_ordencorte

IF This.ModifiedCount() > 0 THEN
	IF This.RowCount() > 0 THEN
		ll_ordencorte = This.GetItemNumber(1, "cs_orden_corte")
		SELECT Max(cs_observa)
		INTO :li_observacion
		FROM dt_observa_oc
		WHERE cs_orden_corte = :ll_ordencorte;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar el consecutivo de observaciones")
			Return(1)
		END IF
		IF IsNull(li_observacion) THEN
			li_observacion = 1 
		ELSE
			li_observacion = li_observacion + 1
		END IF
	END IF
	li_filas = This.RowCount()
	FOR li_fila_actual = 1 TO li_filas
		IF This.GetItemStatus(li_fila_actual, 0, Primary!) = NewModified! THEN
			This.SetItem(li_fila_actual, "cs_observa", li_observacion)
			li_observacion = li_observacion + 1
		END IF
	NEXT
END IF
end event

type dw_escala from uo_dtwndow within w_crear_ordenes
integer x = 9
integer y = 484
integer width = 1399
integer height = 836
integer taborder = 40
string dataobject = "d_dt_escalasxoc"
borderstyle borderstyle = stylelowered!
end type

type dw_corte from uo_dtwndow within w_crear_ordenes
integer x = 14
integer y = 56
integer width = 1403
integer height = 324
integer taborder = 60
string dataobject = "d_h_ordenes"
boolean vscrollbar = false
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
If dwo.name = 'co_tipo' Then
	//mira si tiene permiso para cambiarlo
	If ii_sw_cambio_tipo = 0 Then 
		Return 2
	End if
End if
end event

type gb_1 from groupbox within w_crear_ordenes
integer width = 1426
integer height = 420
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Corte"
end type

type gb_2 from groupbox within w_crear_ordenes
integer y = 304
integer width = 1431
integer height = 1036
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Escala"
end type

type gb_3 from groupbox within w_crear_ordenes
integer x = 1440
integer width = 2213
integer height = 612
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rayas"
end type

type gb_4 from groupbox within w_crear_ordenes
integer x = 1440
integer y = 608
integer width = 2213
integer height = 612
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trazos"
end type

type gb_5 from groupbox within w_crear_ordenes
integer y = 1336
integer width = 1445
integer height = 344
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Observaciones"
end type

type gb_6 from groupbox within w_crear_ordenes
integer x = 1440
integer y = 1216
integer width = 2213
integer height = 468
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Unidades"
end type

