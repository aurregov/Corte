HA$PBExportHeader$w_crear_ordenes_sin_busqueda.srw
forward
global type w_crear_ordenes_sin_busqueda from window
end type
type dw_rollos_mercados from datawindow within w_crear_ordenes_sin_busqueda
end type
type dw_unidades from uo_dtwndow within w_crear_ordenes_sin_busqueda
end type
type dw_trazos from uo_dtwndow within w_crear_ordenes_sin_busqueda
end type
type dw_rayas from uo_dtwndow within w_crear_ordenes_sin_busqueda
end type
type dw_observacion from uo_dtwndow within w_crear_ordenes_sin_busqueda
end type
type dw_escala from uo_dtwndow within w_crear_ordenes_sin_busqueda
end type
type dw_corte from uo_dtwndow within w_crear_ordenes_sin_busqueda
end type
type gb_1 from groupbox within w_crear_ordenes_sin_busqueda
end type
type gb_2 from groupbox within w_crear_ordenes_sin_busqueda
end type
type gb_3 from groupbox within w_crear_ordenes_sin_busqueda
end type
type gb_4 from groupbox within w_crear_ordenes_sin_busqueda
end type
type gb_5 from groupbox within w_crear_ordenes_sin_busqueda
end type
type gb_6 from groupbox within w_crear_ordenes_sin_busqueda
end type
type gb_7 from groupbox within w_crear_ordenes_sin_busqueda
end type
end forward

global type w_crear_ordenes_sin_busqueda from window
integer width = 3831
integer height = 2244
boolean titlebar = true
string title = "Ordenes"
string menuname = "m_mantenimiento_creacion_orden"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_buscar ( )
event ue_crear_orden ( )
event ue_grabar pbm_custom01
event ue_insertar_detalle pbm_custom01
event ue_borrar_detalle pbm_custom02
event ue_orden ( )
event ue_anular_orden ( )
dw_rollos_mercados dw_rollos_mercados
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
gb_7 gb_7
end type
global w_crear_ordenes_sin_busqueda w_crear_ordenes_sin_busqueda

type variables

Integer ii_sw_cambio_tipo
end variables

forward prototypes
public function long of_verificar_estado (long al_orden_corte, ref string as_mensaje)
end prototypes

event ue_buscar();//n_cts_param luo_param
//
//luo_param = Message.PowerObjectParm
//
//If IsValid(luo_param) Then
//	dw_corte.Retrieve(luo_param.il_Vector[1])
//	dw_escala.Retrieve(luo_param.il_Vector[1])
//	dw_observacion.Retrieve(luo_param.il_Vector[1])
//	dw_rayas.Retrieve(luo_param.il_Vector[1])
//End If

n_cts_param luo_param

Open(w_parametro_corte)

luo_param = Message.PowerObjectParm

If IsValid(luo_param) Then
	dw_trazos.Reset()
	dw_unidades.Reset()
	dw_rollos_mercados.Reset()	
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
										IF dw_corte.AcceptText() = 1 THEN
											IF dw_corte.Update() = 1 THEN
												COMMIT;
											ELSE
												ROLLBACK;												
												MessageBox("Error...","No se pudieron has las actualizar en la base de datos")
											END IF
										ELSE
											ROLLBACK;
											MessageBox("Error...","No se pudieron hacer las actualizaciones de la orden de corte")											
										END IF
									ELSE
										ROLLBACK;
										MessageBox("Error...","No se pudieron hacer las actualizaciones en la base de datos de unidades")
									END IF
								ELSE
									ROLLBACK;									
									MessageBox("Error...","No se pudieron hacer las actualizaciones de unidades")
								END IF
							ELSE
								ROLLBACK;
								MessageBox("Error...","No se pudieron hacer las actualizaciones en la base de datos de trazos")								
							END IF
						ELSE
							ROLLBACK;														
							MessageBox("Error...","No se pudieron hacer las actualizaciones de trazos")
						END IF
					ELSE
						ROLLBACK;
						MessageBox("Error...","No se pudieron hacer las actualizaciones en la base de datos de rayas")						
					END IF
				ELSE
					ROLLBACK;										
					MessageBox("Error...","No se pudieron hacer las actualizaciones de las rayas")
				END IF
			ELSE
				ROLLBACK;
				MessageBox("Error...","No se pudieron hacer las actualizaciones en la base de datos de observaciones")
			END IF
		ELSE
			ROLLBACK;						
			MessageBox("Error...","No se pudieron hacer las actualizaciones de las observaciones")
		END IF
	ELSE
		ROLLBACK;
		MessageBox("Error...","No se pudieron hacer las actualizaciones en la base de datos de escalas")		
	END IF
ELSE
	ROLLBACK;		
	MessageBox("Error...","No se pudieron hacer las actualizaciones de las escalas")
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

event ue_anular_orden();Long li_estado, li_respuesta, li_anulacion, ll_tipo_oc_pv, ll_tipo_oc
Long ll_ordencorte, ll_nueva_oc_primera_vez
DateTime ldt_fecha
String ls_error, ls_password,ls_password_ingresado, ls_mensaje
boolean ib_grabar
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes
ll_tipo_oc_pv = luo_constantes.of_consultar_numerico("OC_PRIMERA_VEZ")
IF ll_tipo_oc_pv = -1 THEN
	Return
END IF
Destroy luo_constantes
//n_cts_capas_prog_x_liq luo_capas
//s_base_parametros lstr_parametros

//mensage de utilizacion del trazo, no debe ser usado sin autorizaci$$HEX1$$f300$$ENDHEX$$n superior.
MessageBox('Advertencia','Solo personal autorizado puede anular ordenes de corte, ingrese la contrase$$HEX1$$f100$$ENDHEX$$a.')
ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD ANULAR ORDEN CORTE'))
//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
Open(w_password_trazos)
lstr_parametros = message.PowerObjectParm

If lstr_parametros.hay_parametros = true Then
	ls_password_ingresado = Trim(lstr_parametros.cadena[1])
				
	If ls_password_ingresado = ls_password Then
	Else
		MessageBox('Error','Password, no valido.')
		ib_grabar = False
		Return 
	End if
Else
	ib_grabar = False
	Return 
End if
IF dw_corte.RowCount() > 0 THEN
	ll_ordencorte = dw_corte.GetItemNumber(1, "cs_orden_corte")
	ll_tipo_oc = dw_corte.GetItemNumber(1, "co_tipo")
	//para no dejar anular si el estado es al menos preliquidada
	li_estado = of_verificar_estado(ll_ordencorte, ls_mensaje)
	IF li_estado = -1 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el estado de la O.C., ERROR: '+ls_mensaje,StopSign!)
		Return
	END IF
	
	//li_estado = dw_corte.GetItemNumber(1, "co_estado")
	IF li_estado = 0 THEN
		li_respuesta = MessageBox("Advertencia...","Est$$HEX2$$e1002000$$ENDHEX$$seguro que desea anular la orden: " + String(ll_ordencorte), Question!, YesNo!)
		IF li_respuesta = 1 THEN
			//pedir motivo de anulacion y actualizar h_ordenes_corte
			Open(w_buscar_motivo_anulacion)
			
			lstr_parametros = Message.PowerObjectParm
			
			If lstr_parametros.hay_parametros Then
				li_anulacion = lstr_parametros.entero[1]
				ldt_fecha = f_fecha_servidor()
				
				//se actualizan los datos de la anulacion en h_ordenes_corte
				UPDATE h_ordenes_corte
				   SET co_motivo_anula 		= :li_anulacion,
					    usuario_anulacion 	= :gstr_info_usuario.codigo_usuario,
						 fe_anulacion 			= :ldt_fecha
				 WHERE cs_orden_corte = :ll_ordencorte;		 
				
				If sqlca.sqlcode = -1 Then
					ls_error = Sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de anular la orden. '+ls_error)
					Return 
				Else
					Commit;
				End if
			End if
			
			DECLARE sp_anular PROCEDURE FOR
				pr_anula_orden(:ll_ordencorte);
				
			EXECUTE sp_anular;
			IF SQLCA.SQLCode = -1 THEN
				ls_error = Sqlca.SqlErrText
				ROLLBACK;
				MessageBox("Error Base Datos","Error al ejecutar el SP " + ls_error)
			ELSE
				ls_error = Sqlca.SqlErrText
				COMMIT;
				
				//Si la orden que esta anulando es tipo OC primera vez osea si es tipo 4 entonces 
				//hacemos este query para traer la nueva orden de corte que el sistema marco como oc primera vez

				If ll_tipo_oc_pv = ll_tipo_oc Then

					SELECT Nvl(min(b.cs_asignacion),0)
					INTO :ll_nueva_oc_primera_vez
					FROM dt_pdnxmodulo a, dt_pdnxmodulo b, h_ordenes_corte h
					WHERE a.co_fabrica_pt = b.co_fabrica_pt
					AND a.co_linea = b.co_linea
					AND a.co_referencia = b.co_referencia
					AND b.co_color_pt <> -1
					AND b.cs_asignacion = h.cs_orden_corte
					AND a.cs_asignacion  = :ll_ordencorte
					AND h.co_tipo  = :ll_tipo_oc_pv
					AND b.cs_asignacion <> :ll_ordencorte;
					
					MessageBox("Anulaci$$HEX1$$f300$$ENDHEX$$n exitosa","La orden de corte fue anulada, la nueva OC marcada como primera vez es " + String(ll_nueva_oc_primera_vez) +", favor reimprimirla. ")        
				Else
					MessageBox("Anulaci$$HEX1$$f300$$ENDHEX$$n exitosa","La orden de corte fue anulada")
				End if
			END IF
		END IF
	ELSE
		MessageBox("Advertencia...","El estado de la O.C. no permite anularla, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.")
	END IF
END IF
end event

public function long of_verificar_estado (long al_orden_corte, ref string as_mensaje);//se verifica si la orden de corte se encuentra en dt_liquidaxespacio, no se debe permitir anularla, esto se hace a peticion
//de Javier Garcia
//jcrm
//julio 17 de 2008
Long ll_count


SELECT count(*)
  INTO :ll_count
  FROM dt_liquidaxespacio
 WHERE cs_orden_corte = :al_orden_corte AND
 	    co_estado in (4,5,6,7,8);

IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF

IF ll_count > 0 THEN
	//la orden no se puede anular porque como minimo se encuentra programada parcial
	Return -2
END IF
	

SELECT count(*)
  INTO :ll_count
  FROM dt_liquidaxespacio
 WHERE cs_orden_corte = :al_orden_corte AND
 	    co_estado <= 3;
IF sqlca.sqlcode = -1 THEN
	as_mensaje = sqlca.sqlerrtext
	Return -1
END IF

IF ll_count > 0 THEN
	//la orden esta preliquidada, se pregunta si esta seguro de anular
	IF MessageBox("Verificacion", "La orden se encuentra preliquidada, ests seguro de anular?", Question!, YesNo!, 2) = 2 THEN
		Return -1
	END IF
	DELETE FROM dt_liq_unixespacio
	WHERE cs_orden_corte = :al_orden_corte;
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.sqlerrtext
		Rollback;
		Return -1
	END IF
	
	DELETE FROM dt_liquidaxespacio
	WHERE cs_orden_corte = :al_orden_corte;
	IF sqlca.sqlcode = -1 THEN
		as_mensaje = sqlca.sqlerrtext
		Rollback;
		Return -1
	END IF
	
	//se hace commit para cerrar la transaccion y no generar bloqueos
	COMMIT;
	
	
END IF


Return 0
end function

on w_crear_ordenes_sin_busqueda.create
if this.MenuName = "m_mantenimiento_creacion_orden" then this.MenuID = create m_mantenimiento_creacion_orden
this.dw_rollos_mercados=create dw_rollos_mercados
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
this.gb_7=create gb_7
this.Control[]={this.dw_rollos_mercados,&
this.dw_unidades,&
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
this.gb_6,&
this.gb_7}
end on

on w_crear_ordenes_sin_busqueda.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rollos_mercados)
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
destroy(this.gb_7)
end on

event open;
n_cts_constantes_corte luo_constante_corte
n_cst_string lnv_string
Long ll_cont, ll_array[]
String ls_perfiles


This.x = 1
This.y = 1
n_cts_param luo_param

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

dw_corte.SetTransObject(Sqlca)
dw_escala.SetTransObject(Sqlca)
dw_observacion.SetTransObject(Sqlca)
dw_rayas.SetTransObject(Sqlca)
dw_trazos.SetTransObject(Sqlca)
dw_unidades.SetTransObject(Sqlca)
dw_rollos_mercados.SetTransObject(Sqlca)

n_cts_param lstr_parametros

lstr_parametros = Message.PowerObjectParm

/* Verifica que hayan parametros */
IF lstr_parametros.is_vector[1] = 'S' THEN
		
//	This.TriggerEvent("ue_buscar")
	luo_param = Message.PowerObjectParm
	
	If IsValid(luo_param) Then
		dw_corte.Retrieve(luo_param.il_Vector[1])
		dw_escala.Retrieve(luo_param.il_Vector[1])
		dw_observacion.Retrieve(luo_param.il_Vector[1])
		dw_rayas.Retrieve(luo_param.il_Vector[1])
		dw_trazos.Reset()
		dw_unidades.Reset()
		dw_rollos_mercados.Reset()
	End If
ELSE
//	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
//	return -1
END IF

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


end event

type dw_rollos_mercados from datawindow within w_crear_ordenes_sin_busqueda
integer x = 1454
integer y = 1616
integer width = 2162
integer height = 336
integer taborder = 70
string title = "none"
string dataobject = "dtb_rollos_mercada_raya"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_unidades from uo_dtwndow within w_crear_ordenes_sin_busqueda
integer x = 1454
integer y = 1192
integer width = 2181
integer height = 336
integer taborder = 80
string dataobject = "d_dt_unidadesxtrazo"
borderstyle borderstyle = stylelowered!
end type

type dw_trazos from uo_dtwndow within w_crear_ordenes_sin_busqueda
integer x = 1454
integer y = 624
integer width = 2171
integer height = 492
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

type dw_rayas from uo_dtwndow within w_crear_ordenes_sin_busqueda
integer x = 1454
integer y = 60
integer width = 2181
integer height = 484
integer taborder = 60
string dataobject = "d_dt_rayas_x_telaoc"
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;Long	li_produccion, li_fabtela, li_caract, li_diametro, li_seccion
Long	ll_ordencorte, ll_agrupacion, ll_modelo, ll_reftel, ll_color
Long	ll_trazo, ll_basetrazo, ll_raya

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
	ll_raya = This.GetItemNUmber(CurrentRow,'dt_rayas_telaxoc_raya')
	
	dw_trazos.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_basetrazo, ll_modelo, li_fabtela, &
											ll_reftel, li_caract, li_diametro, ll_color)
	ll_trazo = dw_trazos.GetItemNumber(1, "cs_trazo")
	li_seccion = dw_trazos.GetItemNumber(1, "cs_seccion")											
	dw_unidades.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_modelo, li_fabtela, ll_reftel, &
		li_caract, li_diametro, ll_color, ll_trazo, li_seccion, ll_basetrazo)
	dw_rollos_mercados.Retrieve(ll_ordencorte,ll_raya)	
END IF
end event

event clicked;call super::clicked;Long	li_produccion, li_fabtela, li_caract, li_diametro, li_seccion
Long	ll_ordencorte, ll_agrupacion, ll_modelo, ll_reftel, ll_color
Long	ll_trazo, ll_basetrazo, ll_raya

IF Row > 0 THEN
	ll_ordencorte = This.GetItemNumber(Row, "cs_orden_corte")
	ll_agrupacion = This.GetItemNumber(Row, "cs_agrupacion")
	li_produccion = This.GetItemNumber(Row, "cs_pdn")
	ll_modelo = This.GetItemNumber(Row, "co_modelo")
	li_fabtela = This.GetItemNumber(Row, "co_fabrica_tela")
	ll_reftel = This.GetItemNumber(Row, "co_reftel")
	li_caract = This.GetItemNumber(Row, "co_caract")
	li_diametro = This.GetItemNumber(Row, "diametro")
	ll_color = This.GetItemNumber(Row, "co_color_te")
	ll_basetrazo = This.GetItemNumber(Row, "cs_base_trazos")
	ll_raya = This.GetItemNUmber(Row,'dt_rayas_telaxoc_raya')
	
	dw_trazos.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_basetrazo, ll_modelo, li_fabtela, &
											ll_reftel, li_caract, li_diametro, ll_color)
	ll_trazo = dw_trazos.GetItemNumber(1, "cs_trazo")
	li_seccion = dw_trazos.GetItemNumber(1, "cs_seccion")											
	dw_unidades.Retrieve(ll_ordencorte, ll_agrupacion, li_produccion, ll_modelo, li_fabtela, ll_reftel, &
		li_caract, li_diametro, ll_color, ll_trazo, li_seccion, ll_basetrazo)
	dw_rollos_mercados.Retrieve(ll_ordencorte,ll_raya)	
END IF
end event

type dw_observacion from uo_dtwndow within w_crear_ordenes_sin_busqueda
integer x = 9
integer y = 1696
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

type dw_escala from uo_dtwndow within w_crear_ordenes_sin_busqueda
integer x = 9
integer y = 552
integer width = 1399
integer height = 1060
integer taborder = 40
string dataobject = "d_dt_escalasxoc"
borderstyle borderstyle = stylelowered!
end type

type dw_corte from uo_dtwndow within w_crear_ordenes_sin_busqueda
integer x = 14
integer y = 60
integer width = 1403
integer height = 416
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

type gb_1 from groupbox within w_crear_ordenes_sin_busqueda
integer width = 1431
integer height = 492
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

type gb_2 from groupbox within w_crear_ordenes_sin_busqueda
integer y = 496
integer width = 1431
integer height = 1136
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

type gb_3 from groupbox within w_crear_ordenes_sin_busqueda
integer x = 1440
integer width = 2213
integer height = 572
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

type gb_4 from groupbox within w_crear_ordenes_sin_busqueda
integer x = 1440
integer y = 568
integer width = 2213
integer height = 572
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

type gb_5 from groupbox within w_crear_ordenes_sin_busqueda
integer y = 1636
integer width = 1431
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

type gb_6 from groupbox within w_crear_ordenes_sin_busqueda
integer x = 1440
integer y = 1136
integer width = 2213
integer height = 428
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

type gb_7 from groupbox within w_crear_ordenes_sin_busqueda
integer x = 1440
integer y = 1556
integer width = 2213
integer height = 428
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rollos Mercados "
end type

