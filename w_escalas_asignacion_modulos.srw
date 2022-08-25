HA$PBExportHeader$w_escalas_asignacion_modulos.srw
forward
global type w_escalas_asignacion_modulos from w_base_maestroff_detalletb
end type
end forward

global type w_escalas_asignacion_modulos from w_base_maestroff_detalletb
integer x = 0
integer y = 0
integer width = 2757
integer height = 2040
string menuname = "m_mantenimiento_asignacion_escalas"
end type
global w_escalas_asignacion_modulos w_escalas_asignacion_modulos

on w_escalas_asignacion_modulos.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mantenimiento_asignacion_escalas" then this.MenuID = create m_mantenimiento_asignacion_escalas
end on

on w_escalas_asignacion_modulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Long 					ll_fila,ll_hallados
DateTime 			ldt_fechahora
Long	 			li_co_fabrica_modulo,li_co_planta_modulo,li_co_modulo,li_simulacion
s_base_parametros lstr_parametros
Long				li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_co_talla
LONG					ll_pedido,ll_co_referencia,ll_color_pt,ll_cs_liberacion,ll_ca_unidades,ll_pedido_po
Long				li_cs_estilocolortono,li_co_tipo_asignacion,li_cs_particion
STRING				ls_gpa,ls_nu_orden,ls_tono,ls_tipo_pedido, ls_nu_cut

LONG					ll_ca_programada,ll_ca_producida,ll_ca_personasxmod,ll_ca_unidad_base_dia
LONG					li_unidades_empate
Long				li_co_estado_asigna,li_co_curva,li_cod_tur,li_ind_cambio_estilo,li_orige_uni_base_dia
Long				li_tipo_empate,li_metodo_programa,li_fuente_dato
DATETIME				ldt_fe_inicio_prog,ldt_fe_fin_prog
DECIMAL				ld_ca_minutos_std

This.width = 2757
This.height = 2040

lstr_parametros	=	Message.PowerObjectParm
	
IF lstr_parametros.hay_parametros THEN

	li_simulacion			=lstr_parametros.entero[1]
	li_co_fabrica_modulo	=lstr_parametros.entero[2]
	li_co_planta_modulo	=lstr_parametros.entero[3]
	li_co_modulo			=lstr_parametros.entero[4]	
	li_co_fabrica_exp		=lstr_parametros.entero[5]	
	ll_cs_liberacion		=lstr_parametros.entero[6]
	ls_nu_orden				=lstr_parametros.cadena[1]
	ls_nu_cut				=lstr_parametros.cadena[2]
	li_co_fabrica_ref		=lstr_parametros.entero[7]
	li_co_linea_ref		=lstr_parametros.entero[8]
	ll_co_referencia		=lstr_parametros.entero[9]
	ll_color_pt				=lstr_parametros.entero[10]
	ls_tono					=lstr_parametros.cadena[3]
	li_cs_particion		=lstr_parametros.entero[11]	


		IF ISNULL(li_simulacion) OR ISNULL(li_co_fabrica_modulo) OR ISNULL(li_co_planta_modulo) OR&
			ISNULL(li_co_modulo) OR ISNULL(li_co_fabrica_exp) OR ISNULL(ls_nu_cut) OR&
			ISNULL(ll_cs_liberacion) OR ISNULL(ls_nu_orden) OR ISNULL(li_co_fabrica_ref) OR&
			ISNULL(li_co_linea_ref) OR ISNULL(ll_color_pt) OR ISNULL(ls_tono) OR&
			ISNULL(li_cs_particion) THEN
			
			MessageBox("Error ","Existen datos nulos la ventana de modulo")
			
			RETURN
		ELSE
			ll_hallados = dw_maestro.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
														 li_co_modulo,li_co_fabrica_exp,ll_cs_liberacion,&
														 ls_nu_orden,ls_nu_cut,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
														 ll_color_pt,ls_tono,li_cs_particion)
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
//						MessageBox("Busqueda ok","registros encontrados: "+&
//	             	String(ll_hallados),Information!,Ok!)
						//trae minutos de los estandares, esto va despues para el rowfocuschanged
						
						
						ll_hallados = dw_detalle.Retrieve(li_simulacion,li_co_fabrica_modulo,li_co_planta_modulo,&
														 li_co_modulo,li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
														 ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
														 ll_color_pt,ls_tono,&
														 li_cs_estilocolortono,li_cs_particion)
						IF isnull(ll_hallados) THEN
							MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
						ELSE
							CHOOSE CASE ll_hallados
								CASE -1
									il_fila_actual_detalle = -1
									MessageBox("Error buscando","Error de la base",StopSign!,&
												 Ok!)
								CASE 0
									il_fila_actual_detalle = 0
//									MessageBox("Sin Datos","No hay datos para su criterio",&
//												 Exclamation!,Ok!)
								CASE ELSE
									il_fila_actual_detalle = 1
			//						MessageBox("Busqueda ok","registros encontrados: "+&
			//	             	String(ll_hallados),Information!,Ok!)
			
							END CHOOSE
						END IF
				END CHOOSE
			END IF
		END IF 	
	ELSE
		li_simulacion			=0
		li_co_fabrica_modulo	=0
		li_co_planta_modulo	=0
		li_co_modulo			=0	
		li_co_fabrica_exp		=0
		ll_cs_liberacion		=0
		ls_nu_orden				=""
		ls_nu_cut				=""
		li_co_fabrica_ref		=0
		li_co_linea_ref		=0
		ll_co_referencia		=0
		ll_color_pt				=0
		ls_tono					=""
		li_cs_particion		=0	
	END IF

//TriggerEvent("ue_buscar")

end event

event ue_buscar;//nada
end event

event ue_grabar;/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////

//IF dw_maestro.AcceptText() = -1 THEN
//	is_accion = "no accepttext"
//	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
//	           ,Exclamation!,Ok!)	
//	RETURN
//ELSE
//	IF dw_maestro.Update() = -1 THEN
//		is_accion = "no update"
//		ROLLBACK;
//	   RETURN
//	ELSE
//		is_accion = "si update"
//		COMMIT;
//		IF SQLCA.SQLCode = -1 THEN
//			is_grabada = "no"
//			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
//		ELSE
//			is_grabada = "si"
//		END IF
//	END IF
//END IF
	
//////////////////////////////////////////////////////////////////////////
// En este evento se realizar ACCEPTTEXT para llevar los cambios 
// del detalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////
is_accion = "si update"
IF is_accion = "si update" THEN
	IF dw_detalle.AcceptText() = -1 THEN
		is_accion = "no accepttext"
		Messagebox("Error","No se pudieron realizar los cambios en el detalle",Exclamation!,Ok!)	
		RETURN
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos",Exclamation!,Ok!)	
			RETURN
		ELSE
			is_accion = "si update"
			COMMIT;
			IF SQLCA.SQLCode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","No se pudo hacer los cambios en el detalle para la base de datos" &
								,Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF
END IF

end event

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_escalas_asignacion_modulos
integer x = 23
integer y = 12
integer width = 2670
integer height = 684
string title = "Maestro Asignacion por M$$HEX1$$f300$$ENDHEX$$dulo"
string dataobject = "dff_dt_pdnxmodulo_para_escalas"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
end type

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_escalas_asignacion_modulos
integer x = 14
integer y = 712
integer width = 2683
integer height = 1100
string title = "Detalle de Unidades por Escalas de tallas de asignaci$$HEX1$$f300$$ENDHEX$$n"
string dataobject = "dtb_dt_talla_pdnxmodulo"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

