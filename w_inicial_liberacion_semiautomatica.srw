HA$PBExportHeader$w_inicial_liberacion_semiautomatica.srw
forward
global type w_inicial_liberacion_semiautomatica from window
end type
type cb_1 from commandbutton within w_inicial_liberacion_semiautomatica
end type
type cb_limpiar from commandbutton within w_inicial_liberacion_semiautomatica
end type
type rb_final from radiobutton within w_inicial_liberacion_semiautomatica
end type
type rb_inicial from radiobutton within w_inicial_liberacion_semiautomatica
end type
type cb_cancelar from commandbutton within w_inicial_liberacion_semiautomatica
end type
type cb_aceptar from commandbutton within w_inicial_liberacion_semiautomatica
end type
type cb_recuperar from commandbutton within w_inicial_liberacion_semiautomatica
end type
type dw_lista from datawindow within w_inicial_liberacion_semiautomatica
end type
type dw_criterio from datawindow within w_inicial_liberacion_semiautomatica
end type
type gb_1 from groupbox within w_inicial_liberacion_semiautomatica
end type
type gb_2 from groupbox within w_inicial_liberacion_semiautomatica
end type
end forward

global type w_inicial_liberacion_semiautomatica from window
integer width = 5385
integer height = 2252
boolean titlebar = true
string title = "Estilos Para LIberar"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
cb_limpiar cb_limpiar
rb_final rb_final
rb_inicial rb_inicial
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
cb_recuperar cb_recuperar
dw_lista dw_lista
dw_criterio dw_criterio
gb_1 gb_1
gb_2 gb_2
end type
global w_inicial_liberacion_semiautomatica w_inicial_liberacion_semiautomatica

type variables
DataWindowChild idwc_linea,dwc_fabrica_proceso, dwc_planta_proceso
uo_calendario ipo_calendario
n_cst_ole_calendario ipo_calendario_ole 
end variables

on w_inicial_liberacion_semiautomatica.create
this.cb_1=create cb_1
this.cb_limpiar=create cb_limpiar
this.rb_final=create rb_final
this.rb_inicial=create rb_inicial
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.cb_recuperar=create cb_recuperar
this.dw_lista=create dw_lista
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_1,&
this.cb_limpiar,&
this.rb_final,&
this.rb_inicial,&
this.cb_cancelar,&
this.cb_aceptar,&
this.cb_recuperar,&
this.dw_lista,&
this.dw_criterio,&
this.gb_1,&
this.gb_2}
end on

on w_inicial_liberacion_semiautomatica.destroy
destroy(this.cb_1)
destroy(this.cb_limpiar)
destroy(this.rb_final)
destroy(this.rb_inicial)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.cb_recuperar)
destroy(this.dw_lista)
destroy(this.dw_criterio)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;This.Center = True
s_base_parametros lstr_parametros

dw_lista.SetTransObject(sqlca)
dw_criterio.SetTransObject(sqlca)

Open(w_filtro_liberacion)

dw_criterio.GetChild("ai_fabrica_proceso", dwc_fabrica_proceso)
dwc_fabrica_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia())

dw_criterio.GetChild("ai_planta_proceso", dwc_planta_proceso)
dwc_planta_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia())


dwc_fabrica_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ))
dwc_planta_proceso.SetTransObject(gnv_recursos.of_get_transaccion_sucia( ))
dwc_fabrica_proceso.Retrieve()
dwc_planta_proceso.Retrieve()


dw_criterio.GetChild('co_linea',idwc_linea)
idwc_linea.SetTransObject(sqlca)

idwc_linea.Retrieve(2)

dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

lstr_parametros = Message.PowerObjectParm

OpenUserObject(ipo_calendario)
ipo_calendario.hide( ) 

//se cargan los parametros enviados desde la ventana filtro de liberacion
IF lstr_parametros.hay_parametros = True Then
	dw_criterio.SetItem(1,'co_fabrica',lstr_parametros.entero[2])
	dw_criterio.SetItem(1,'co_linea',lstr_parametros.entero[3])
	dw_criterio.SetItem(1,'co_referencia',lstr_parametros.entero[4])
	dw_criterio.SetItem(1,'op',lstr_parametros.entero[5])
	dw_criterio.SetItem(1,'co_color',lstr_parametros.entero[6])
	dw_criterio.SetItem(1,'fe_inicial',lstr_parametros.fecha[1])
	dw_criterio.SetItem(1,'fe_final',lstr_parametros.fecha[2])
	dw_criterio.SetItem(1,'ai_fabrica_proceso',lstr_parametros.entero[9])
	dw_criterio.SetItem(1,'ai_planta_proceso',lstr_parametros.entero[10])
	
	cb_recuperar.TriggerEvent(Clicked!)
Else
	dw_criterio.SetItem(1,'fe_inicial',Today())
	dw_criterio.SetItem(1,'fe_final',Today())
End if




end event

event closequery;CloseUserObject(ipo_calendario) 


end event

type cb_1 from commandbutton within w_inicial_liberacion_semiautomatica
integer x = 151
integer y = 2020
integer width = 320
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Crea Ref Ag"
end type

event clicked;INTEGER		ll_fila, li_existe, li_result, li_tot_tallas_grabar, li_sin_insertar, li_cte_sumar
LONG			ll_color_pt, ll_op_agrup, ll_op_normal, ll_pedido_agrup
STRING		ls_ref_exp, ls_color_exp, ls_ref_exp_existe, ls_nu_orden_agrup, ls_nu_cut_agrup, ls_ref_exp_agrup


li_sin_insertar = 1
li_cte_sumar = 100
IF gstr_info_usuario.codigo_perfil = 1 OR gstr_info_usuario.codigo_perfil = 16 THEN
	
	ll_fila = dw_lista.GetRow()
    ls_ref_exp = dw_lista.GetItemString(ll_fila,'co_ref_exp')
	ll_color_pt = dw_lista.GetItemNumber(ll_fila,'co_color')
    ll_op_agrup = dw_lista.GetItemNumber(ll_fila,'op_agrupada')
	ls_color_exp = dw_lista.GetItemString(ll_fila,'color_exp')
	ll_op_normal = dw_lista.GetItemNumber(ll_fila,'cs_ordenpd_pt')

	
	SELECT count(*)
	   INTO :li_existe
	  FROM dt_caxpedidos
	WHERE cs_ordenpd_pt = :ll_op_agrup
	     AND co_color = :ll_color_pt
		 AND co_ref_exp = :ls_ref_exp;
	IF (SQLCA.SQLCODE <> 0) THEN
		MessageBox('Error','Error al consultar los datos de la OP agrupada '+ sqlca.sqlerrtext)
		Return
	END IF
	IF li_existe = 0 THEN
		SELECT MAX(co_ref_exp)
	        INTO :ls_ref_exp_agrup
	      FROM dt_caxpedidos
	   WHERE cs_ordenpd_pt = :ll_op_agrup
	        AND co_color = :ll_color_pt;
		IF ls_ref_exp_agrup <> '' THEN
			SELECT count(*)
			  INTO :li_tot_tallas_grabar
			FROM dt_caxpedidos
		   WHERE cs_ordenpd_pt  = :ll_op_normal
				AND co_color = :ll_color_pt
			 AND co_ref_exp = :ls_ref_exp;	
			  
			li_result = MessageBox("Advertencia",'Esta seguro(a) de crear la referencia de ventas en la OP agrupada, se creara con las tallas de la OP que tiene seleccionada, en total son: '+ string(li_tot_tallas_grabar),  Exclamation!, OKCancel!, 2)
		
			IF li_result = 1 THEN
			
				SELECT UNIQUE pedido, nu_orden, nu_cut
					  INTO :ll_pedido_agrup, :ls_nu_orden_agrup, :ls_nu_cut_agrup
					FROM dt_caxpedidos
					WHERE cs_ordenpd_pt = :ll_op_agrup
						AND co_color = :ll_color_pt
					  AND co_ref_exp = :ls_ref_exp_agrup;
				IF (SQLCA.SQLCODE = 0)  AND (SQLCA.SQLNROWS > 0 ) THEN
				ELSE
					MessageBox('Error','Error al consultar los datos de la OP agrupada '+ sqlca.sqlerrtext)
					Return
				END IF
			
				DO WHILE li_sin_insertar = 1
				
					INSERT INTO dt_caxpedidos (cs_ordenpd_pt, co_talla, co_color, co_fabrica_exp, pedido, item, nu_orden, nu_cut, cs_secuencia, ca_color, ca_programada, 
																			 ca_real, proporc_prog, proporc_real, ca_cortada, ca_empacada, co_estado, fe_creacion, fe_actualizacion, usuario, instancia,
															prioridad, ca_liberadas, color_exp, co_Ref_exp, co_Talla_exp, ca_prog_trazos, co_linea_exp)	
						SELECT :ll_op_agrup, co_talla, co_color, co_fabrica_exp, :ll_pedido_agrup, (item + :li_cte_sumar), :ls_nu_orden_agrup, :ls_nu_cut_agrup, cs_secuencia, ca_color, 1, 
										ca_real, proporc_prog, proporc_real, ca_cortada, ca_empacada, co_estado, current, current, user, sitename,
								  prioridad, 0, color_exp, :ls_ref_exp, co_Talla_exp, ca_prog_trazos, co_linea_exp
							FROM dt_caxpedidos
						  WHERE cs_ordenpd_pt  = :ll_op_normal
								AND co_color = :ll_color_pt
							 AND co_ref_exp = :ls_ref_exp;	
								
					IF (SQLCA.SQLCODE = 0)  AND (SQLCA.SQLNROWS > 0 ) THEN
						COMMIT;
						MessageBox('OK','Se grabo correctamente')
						li_sin_insertar = 0
						Return
					ELSE
						IF SQLCA.SQLDBCODE = -268 THEN
							li_sin_insertar = 1
							li_cte_sumar = li_cte_sumar + 100
						ELSE
							ROLLBACK;
							MessageBox('Error','Error al grabar '+ sqlca.sqlerrtext)
							Return
						END IF
					END IF	
				LOOP
			ELSE
				MessageBox('Advertencia','Cancel$$HEX2$$f3002000$$ENDHEX$$el proceso')
				Return
			END IF
		ELSE
			MessageBox('Advertencia','Se encontr$$HEX2$$f3002000$$ENDHEX$$informacion en la OP agrupada de la Ref seleccionada')
			Return
		END IF
	END IF
 
	MessageBox('Advertencia','No tiene permisos para realizar este proceso')
	Return
END IF
end event

type cb_limpiar from commandbutton within w_inicial_liberacion_semiautomatica
integer x = 151
integer y = 1836
integer width = 306
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar"
end type

event clicked;dw_criterio.Reset()
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
end event

type rb_final from radiobutton within w_inicial_liberacion_semiautomatica
integer x = 64
integer y = 1368
integer width = 430
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "F. Final Corte"
end type

type rb_inicial from radiobutton within w_inicial_liberacion_semiautomatica
integer x = 64
integer y = 1304
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "F. Inicial Corte"
boolean checked = true
end type

type cb_cancelar from commandbutton within w_inicial_liberacion_semiautomatica
integer x = 151
integer y = 1720
integer width = 306
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

//CloseWithReturn ( Parent, lstr_parametros )
OpenSheetWithParm(w_existencias_tela_critica, lstr_parametros, W_PRINCIPAL,0,Original!)
end event

type cb_aceptar from commandbutton within w_inicial_liberacion_semiautomatica
integer x = 151
integer y = 1600
integer width = 306
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;
//******************************************************************************
//se invoca la venata de existencia de telas para permitir generar la liberacion
//se comenta el llamado a la ventana de liberacion semiautomatica
//jcrm
//junio 13 de 2008

Long	li_fab, li_lin, li_bodysize, li_talla_pt, li_fab_exp, li_lin_exp, li_result,&
			li_opcion_liberar, li_tipoprod_op, li_tipo_orden, ll_op_selec
LONG		ll_ref, ll_op, ll_fila, ll_unir_op, ll_color_pt, ll_op_agrupada, ll_color_pt_1
STRING	usuario, ls_color_exp, ls_ref_exp, ls_error
INTEGER	li_si_libera, li_existe, posi, li_1, li_cs_prioridad_lib, li_cs_prioridad_lib_ant, li_varias_prioridades_lib, li_agrupa_liberar
s_base_parametros lstr_parametros, lstr_parametros_retro, lstr_tipo_liberacion
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  datos segun Ficha y Existencia en bodega "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

usuario = gstr_info_usuario.codigo_usuario
ll_fila = dw_lista.GetRow()
ll_color_pt = dw_lista.GetItemNumber(ll_fila,'co_color')
ll_op = dw_lista.GetItemNumber(ll_fila,'cs_ordenpd_pt')
ls_color_exp = dw_lista.GetItemString(ll_fila,'color_exp')
li_lin_exp = dw_lista.GetItemNumber(ll_fila,'co_linea_exp')
ls_ref_exp = dw_lista.GetItemString(ll_fila,'co_ref_exp')
ll_op_agrupada =  dw_lista.GetItemNumber(ll_fila,'op_agrupada')
li_si_libera =  dw_lista.GetItemNumber(ll_fila,'sw_libera')
IF li_si_libera = 1 THEN
ELSE
	ll_op_agrupada = 0
END IF

li_cs_prioridad_lib_ant = 0
li_varias_prioridades_lib = 0
IF li_si_libera = 1 THEN		//es una op agrupada, verificar si  son varias referencias agrupadas para que el usuario seleccione cual liberar
//	FOR posi = 1 TO dw_lista.RowCount()
//		li_1 =  dw_lista.GetItemNumber(posi,'sw_libera')
//		IF (posi <> ll_fila)  AND (li_1 <> 1 OR IsNull(li_1)) THEN  //no debe buscar en la fila que le dio clic
//			ll_color_pt_1 = dw_lista.GetItemNumber(ll_fila,'co_color')
//			IF ll_color_pt_1 = ll_color_pt THEN
//				li_cs_prioridad_lib = dw_lista.GetItemNumber(posi,'cs_prioridad_liberacion')
//				IF (li_cs_prioridad_lib <> li_cs_prioridad_lib_ant) AND li_cs_prioridad_lib_ant <> 0 THEN
//					li_varias_prioridades_lib = 1
//					EXIT
//				END IF
//				li_cs_prioridad_lib_ant = li_cs_prioridad_lib
//			END IF
//		END IF=
//	NEXT
IF IsNull(ll_op_agrupada) OR ll_op_agrupada = 0 THEN
ELSE
	li_varias_prioridades_lib = 1  //colocar en comentario la parte anterior y dejar que siempre pregunte, validar si funciona bien
END IF

END IF
//
IF li_varias_prioridades_lib = 1 THEN	//debe seleccionar del color de ventas cual agrupacion va a trabajar
	lstr_parametros.entero[1] = ll_op
	lstr_parametros.entero[2] = ll_color_pt
	lstr_parametros.cadena[1] = ls_ref_exp
	OpenWithParm ( w_seleccionar_agrupacion_liberar, lstr_parametros)
	lstr_parametros = Message.PowerObjectParm	
	IF lstr_parametros.hay_parametros = True THEN
		li_agrupa_liberar = lstr_parametros.entero[1]
		
		//ya tenemos la referencia a liberar, ahora vamos a seleccionar la op, pues pueden existir OPs con tallas que otras no tienen, el usuario decide cual tiene todas las tallas
		lstr_parametros.entero[1] = ll_op
		lstr_parametros.entero[2] = li_agrupa_liberar
		lstr_parametros.entero[3] = ll_color_pt
		OpenWithParm ( w_selec_op_indiv_x_agrupar, lstr_parametros)
		lstr_parametros = Message.PowerObjectParm	
		IF lstr_parametros.hay_parametros = True THEN
			ll_op_selec = lstr_parametros.entero[1]
			ll_op = ll_op_selec
		ELSE
			CLOSE(w_retroalimentacion)
			Return
		END IF
	ELSE
		CLOSE(w_retroalimentacion)
		Return
	END IF
//	//
END IF
//

IF IsNull(ls_ref_exp) THEN
	SELECT co_fabrica, co_linea, co_referencia, co_fabrica_exp, co_ref_exp, cs_unir_op, co_tipoprod, co_tipo_orden
	  INTO :li_fab, :li_lin, :ll_ref, :li_fab_exp, :ls_ref_exp, :ll_unir_op, :li_tipoprod_op, :li_tipo_orden
	  FROM h_ordenpd_pt
	 WHERE cs_ordenpd_pt =  :ll_op;
ELSE
	SELECT co_fabrica, co_linea, co_referencia, co_fabrica_exp,  cs_unir_op, co_tipoprod, co_tipo_orden
	  INTO :li_fab, :li_lin, :ll_ref, :li_fab_exp, :ll_unir_op, :li_tipoprod_op, :li_tipo_orden
 	 FROM h_ordenpd_pt
 	WHERE cs_ordenpd_pt =  :ll_op;

END IF

IF SQLCA.SQLCODE <> 0 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Edvertencia','Error buscando los datos de la referencia en la orden de produccion, intente nuevamente')
	Return
END IF

//control para que los programadores puedan parar la liberacion de una op estilo con el campo co_tipoprod de h_ordenpd_pt
//esto por solicitud de Ubeimar Alvarez y Olga Hernandez que pide que no liberen alguna op por x o y motivo
//jorodrig  junio 9 - 2010
//IF (li_tipoprod_op = 1) OR (li_tipo_orden = 2) OR (li_si_libera = 1) THEN
IF (li_tipoprod_op = 1) OR (li_tipo_orden = 2)  THEN
ELSE
//IF (li_tipoprod_op <> 1) THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Edvertencia','La OP Estilo no Esta marcada como tipo de producto Prenda y tampoco es agrupada, debe hablar con el programador para que cambie el tipo en la OP para poder liberar')
	Return
END IF

//vamos a probar dejar liberar las OP agrupadas para el proyecto de agrupacion de pedidos
IF (li_tipo_orden = 2)  OR (li_si_libera=0) THEN  //no se libera la agrupada sino las individuales
	CLOSE(w_retroalimentacion)
	MessageBox('Edvertencia','La OP Estilo es agrupada,  Solo puede liberar para agrupacion de pedidos')
	SELECT Count(*)
	   INTO :li_existe
	  FROM agrupacion_pedido
      WHERE cs_ordenpd_pt_agrupa = :ll_op;
	IF li_existe = 0 THEN	
		Return
	END IF
END IF
//
//revisar si la referencia es bodysize, esta revision es contando si en el modelo principal cada talla tiene diferente diametro
li_bodysize = luo_liberacion_x_proyeccion.of_revisar_si_bodysize(li_fab, li_lin, ll_ref, ll_color_pt)
IF li_bodysize = 1 THEN
	//La ref es bodysize se debe pedir la talla a liberar
	lstr_parametros.entero[1] = ll_op
	lstr_parametros.entero[2] = ll_color_pt
	OpenWithParm ( w_tallas_op, lstr_parametros)
	lstr_parametros = Message.PowerObjectParm	
	IF lstr_parametros.hay_parametros = True THEN
		li_talla_pt = lstr_parametros.entero[1]
	ELSE
		CLOSE(w_retroalimentacion)
		Return	
	END IF
ELSE
	li_talla_pt = 9999
END IF
IF luo_liberacion_x_proyeccion.of_cargar_temp_ref_liberar(usuario, li_fab, li_lin, ll_ref, ll_color_pt, li_talla_pt, li_bodysize, 0, 0, ll_op,0,0,'0',ls_color_exp,0,ll_op_agrupada,li_agrupa_liberar) = -1 THEN
	CLOSE(w_retroalimentacion)
	Return
END IF

//se debe verificar si se trata de un duo o conjunto
//jcrme
//enero 22 de 2009
IF ll_unir_op = 0 THEN
	li_opcion_liberar = 1
ELSE
	//se asume que siempre que tenga ll_unir_op > 0 es un duo o conjunto
	//jcrm
	//febrero 16 de 2009
//	li_result = luo_liberacion_x_proyeccion.of_validar_duo_conjunto_op(ll_unir_op,ls_error)
//	IF  li_result = 0 THEN
		//se trata de un duo o conjunto se muestra la ventana para escojer el tipo de liberacion
		Open(w_tipo_liberacion)
		lstr_tipo_liberacion = Message.PowerObjectParm //para saber cual tipo de liberacion vamos a trabajar	
		li_opcion_liberar = lstr_tipo_liberacion.entero[1]
		IF li_opcion_liberar = 0 Then
			CLOSE(w_retroalimentacion)
			Return
		End If
//	ELSEIF li_result = -1 THEN
//		CLOSE(w_retroalimentacion)
//		MessageBox('Error',ls_error,StopSign!)
//		Return
//	END IF
END IF

lstr_parametros.entero[1]  = li_fab
lstr_parametros.entero[2]  = li_lin
lstr_parametros.entero[3]  = ll_ref
lstr_parametros.entero[4]  = ll_color_pt
lstr_parametros.entero[5]  = 0
lstr_parametros.entero[6]  = 0
lstr_parametros.entero[7]  = li_talla_pt
lstr_parametros.entero[8]  = ll_op
lstr_parametros.entero[9]  = li_lin_exp
lstr_parametros.entero[10] = li_fab_exp
lstr_parametros.cadena[1]  = ls_ref_exp
lstr_parametros.cadena[2]  = ls_color_exp
lstr_parametros.entero[11] = li_opcion_liberar//1 = equilibrar, 2 = igualar
lstr_parametros.entero[12] = ll_unir_op
lstr_parametros.entero[13] = ll_op_agrupada
lstr_parametros.entero[14] = li_agrupa_liberar


OpenSheetWithParm(w_existencias_tela_critica, lstr_parametros, W_PRINCIPAL,0,Original!)
CLOSE(w_retroalimentacion)
This.TriggerEvent('ue_buscar')
end event

type cb_recuperar from commandbutton within w_inicial_liberacion_semiautomatica
integer x = 151
integer y = 1476
integer width = 306
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
boolean cancel = true
boolean default = true
end type

event clicked;Long li_fab, li_lin, li_fabrica_proceso, li_planta_proceso
Date ld_inicial, ld_final
Long ll_result, ll_ref, ll_ordenpd_pt, ll_color
Long	li_estadodisp, li_centroterm, li_estadopd
String ls_usuario
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_estadopd = luo_constantes.of_consultar_numerico("ESTADO ORDENPD")
IF li_estadopd = -1 THEN
	CLOSE(w_retroalimentacion)
	MessageBox('Error','No fue posible establecer el estado de la orden de producci$$HEX1$$f300$$ENDHEX$$n.')
	Return -1
END IF

dw_criterio.AcceptText()

li_fab 		= dw_criterio.GetItemNumber(1,'co_fabrica')
li_lin 		= dw_criterio.GetItemNumber(1,'co_linea')
ld_inicial 	= dw_criterio.GetItemDate(1,'fe_inicial')
ld_final 	= dw_criterio.GetItemDate(1,'fe_final')


ll_ref			= dw_criterio.GetItemNumber(1,'co_referencia')
ll_ordenpd_pt 	= dw_criterio.GetItemNumber(1,'op')
ll_color			= dw_criterio.GetItemNumber(1,'co_color')

li_fabrica_proceso	= dw_criterio.GetItemNumber(1,'ai_fabrica_proceso')
li_planta_proceso	   = dw_criterio.GetItemNumber(1,'ai_planta_proceso')

//a la fecha del pdp de corte se le restan 4 dias y esa debe ser la produccion a liberar, es decir,  a lo que
//ingresa el usuario como rango de fechas se le restan 4 dias y se busca con ese rango de fechas en el pdp, pasando
//como parametro la fecha (fecha corte en pdp)
//los 4 dias los define Sebastian Uribe en reunion de tela terminda, diciembre 14 - 07



If isnull(li_fab) Then li_fab = 0
If isnull(li_lin) Then li_lin = 0
If isnull(ll_ref) Then ll_ref = 0
If isnull(ll_ordenpd_pt) Then ll_ordenpd_pt = 0
If isnull(ll_color) Then ll_color = 0
IF IsNull(li_fabrica_proceso) THEn li_fabrica_proceso = 0
IF IsNull(li_planta_proceso) THEN li_planta_proceso = 0

IF li_fab = 0 and li_lin = 0 and ll_ref = 0 and ll_ordenpd_pt = 0  and ll_color = 0 THEN
	MessageBox('Advertencia','No ingreso ningun criterio de busqueda, verifique sus datos.')
	Return
END IF

If rb_inicial.Checked = TRUE Then
	ll_result = dw_lista.retrieve(li_fab,&
										li_lin,&
										ld_inicial,&
										ld_final,&
										li_estadopd,&
										ll_ref,&
										ll_color,&
										ll_ordenpd_pt,&
										Date("1900-01-01"),&
										Date("1900-01-01"),&
										li_fabrica_proceso,&
										li_planta_proceso)
ElseIf rb_final.Checked = True Then
	ll_result = dw_lista.retrieve(li_fab,&
										li_lin,&
										Date("1900-01-01"),&
										Date("1900-01-01"),&
										li_estadopd,&
										ll_ref,&
										ll_color,&
										ll_ordenpd_pt,&
										ld_inicial,&
										ld_final, &
										li_fabrica_proceso, &
										li_planta_proceso)

End if



If ll_result > 0 Then
	dw_criterio.Reset()
	dw_criterio.InsertRow(0)
	//dw_criterio.SetItem(1,'fe_inicial',Today())
	//dw_criterio.SetItem(1,'fe_final',Today())
	dw_criterio.SetFocus()
Else
	MessageBox('Advertencia','No existen Registros con el criterio, verifique sus datos.')
End if

end event

type dw_lista from datawindow within w_inicial_liberacion_semiautomatica
integer x = 530
integer y = 64
integer width = 4745
integer height = 2044
integer taborder = 20
string title = "none"
string dataobject = "dtb_inicial_liberacion"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;This.SelectRow(0, FALSE)

This.SelectRow(row, TRUE)
end event

event doubleclicked;cb_aceptar.TriggerEvent(Clicked!)
end event

event retrieveend;Long		li_result, pos, li_fabrica, li_linea, ll_co_centro, ll_fila, li_subcentro, li_borda, li_estampa, li_result2
Long		posi, li_talla, li_falta
LONG			ll_referencia, ll_op_estilo, ll_prog, ll_lib, ll_color
DECIMAL{2}	ld_totmin, ld_tiempo, ld_acumula, ld_cantidad
STRING		ls_proceso, ls_po	
DataStore	lds_dgr_buscar_proceso_estam_borda_x_ref, lds_cant_x_tlla_color_op
s_base_parametros lstr_parametros_retro

lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando tiempos"
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)        
	
lds_dgr_buscar_proceso_estam_borda_x_ref	= Create DataStore
lds_dgr_buscar_proceso_estam_borda_x_ref.DataObject = 'dgr_buscar_proceso_estam_borda_x_ref'
lds_dgr_buscar_proceso_estam_borda_x_ref.SetTransObject(sqlca)

lds_cant_x_tlla_color_op	= Create DataStore
lds_cant_x_tlla_color_op.DataObject = 'ds_cant_x_tlla_color_op'
lds_cant_x_tlla_color_op.SetTransObject(sqlca)
	
	
li_result = dw_lista.RowCount()

FOR pos = 1 TO li_result
	li_fabrica   = dw_lista.GetItemNumber(pos, "co_fabrica")
	li_linea = dw_lista.GetItemNumber(pos, "co_linea")
	ll_referencia = dw_lista.GetItemNumber(pos, "co_referencia")
	ll_op_estilo  = dw_lista.GetItemNumber(pos, "cs_ordenpd_pt")
	ll_color = dw_lista.GetItemNumber(pos, "co_color")
	ls_po    = dw_lista.GetItemString(pos, "nu_orden")
	//ld_cantidad = dw_lista.GetItemNumber(pos, "ca_prog_oc")
	
	DECLARE cur_tiempos CURSOR FOR  
		SELECT DISTINCT co_centro_pdn,
				 ti_total  
		  FROM dt_fichatiempos_cs  
		 WHERE ( dt_fichatiempos_cs.co_fabrica 	= :li_fabrica ) AND  
				 ( dt_fichatiempos_cs.co_linea 		= :li_linea ) AND  
				 ( dt_fichatiempos_cs.co_referencia = :ll_referencia ) AND  
				 ( dt_fichatiempos_cs.co_calidad = 1 ) AND  
				 ( dt_fichatiempos_cs.co_centro_pdn = 1 ) AND
				 ( dt_fichatiempos_cs.ti_total > 0 ) and
				 ( dt_fichatiempos_cs.co_subcentro_pdn not in (8,14));		
			
		OPEN 	cur_tiempos;	
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al abrir proceso de cargar los tiempos")
			Close(w_retroalimentacion)
			Return
		END IF
										
	  ld_acumula = 0													
     FETCH cur_tiempos INTO  :ll_co_centro, :ld_tiempo ; 
	  IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al cargar primer registro para cargar los tiempos")
			Close(w_retroalimentacion)
			Return
	  END IF

	  DO WHILE SQLCA.SQLCODE = 0
		   ld_acumula = ld_acumula + ld_tiempo	
				
			FETCH cur_tiempos INTO  :ll_co_centro, :ld_tiempo ; 
		  IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al cargar ultimo registro para cargar los tiempos")
			Close(w_retroalimentacion)
			Return
		  END IF
	  LOOP
	CLOSE cur_tiempos;
	dw_lista.SetItem(pos, "tiempo", String(ld_acumula))	
	
	li_falta = 0
	//verificar que todas las tallas esten liberadas al 100%, pues en el reporte se traen son los totales
	//pero por talla puede haber diferencias   mayo 7 -2010 jorodrig
	IF lds_cant_x_tlla_color_op.Retrieve(ll_op_estilo,ls_po,ll_color) > 0 THEN
		FOR posi = 1 TO lds_cant_x_tlla_color_op.RowCount()
			li_talla = lds_cant_x_tlla_color_op.GetItemNumber(posi,'co_talla')
			ll_prog  = lds_cant_x_tlla_color_op.GetItemNumber(posi,'prog')
			ll_lib   = lds_cant_x_tlla_color_op.GetItemNumber(posi,'lib')		
			IF ll_prog > ll_lib THEN
				li_falta = 1
			END IF
		NEXT
		IF li_falta = 1 THEN
			dw_lista.SetItem(pos, "falta_tlla",1)	//alguna de las tallas esta pendiente, se marca el % liberado en color naranjado
		END IF
		
	END IF
NEXT

Close(w_retroalimentacion)
Destroy lds_dgr_buscar_proceso_estam_borda_x_ref;
Destroy lds_cant_x_tlla_color_op;

end event

type dw_criterio from datawindow within w_inicial_liberacion_semiautomatica
integer x = 37
integer y = 64
integer width = 466
integer height = 1396
integer taborder = 10
string title = "none"
string dataobject = "dff_paramteros_inicial_liberacion"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long li_fab

This.AcceptText()

choose case GetColumnName()
	case 'co_fabrica'
			li_fab = dw_criterio.GetItemNumber(1,'co_fabrica')
			idwc_linea.Retrieve(li_fab)
end choose

end event

event doubleclicked;


choose case GetColumnName()
	case 'fe_inicial'
			ipo_calendario.of_Show_Calendar(This)
	case 'fe_final'
			ipo_calendario.of_Show_Calendar(This)
end choose
end event

type gb_1 from groupbox within w_inicial_liberacion_semiautomatica
integer x = 512
integer y = 8
integer width = 4818
integer height = 2124
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle "
end type

type gb_2 from groupbox within w_inicial_liberacion_semiautomatica
integer x = 27
integer y = 8
integer width = 475
integer height = 1300
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Criterio "
end type

