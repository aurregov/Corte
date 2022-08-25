HA$PBExportHeader$w_partir_escala_de_liberaciones.srw
forward
global type w_partir_escala_de_liberaciones from w_base_buscar_lista
end type
end forward

global type w_partir_escala_de_liberaciones from w_base_buscar_lista
integer width = 1998
integer height = 1292
end type
global w_partir_escala_de_liberaciones w_partir_escala_de_liberaciones

on w_partir_escala_de_liberaciones.create
call super::create
end on

on w_partir_escala_de_liberaciones.destroy
call super::destroy
end on

event open;LONG						ll_pedido,ll_cs_liberacion,ll_co_referencia,ll_color_pt,ll_ca_unidades
Long					li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_cs_estilocolton
Long					li_co_fabrica_tela,li_diametro
STRING					ls_nu_orden,ls_tono
long 						ll_numero_registros,ll_co_reftel,ll_co_color_te
DOUBLE					ld_ancho_cortable
s_base_parametros		lstr_parametros

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	lstr_parametros = Message.PowerObjectParm
	
   IF lstr_parametros.hay_parametros THEN
	
		li_co_fabrica_exp    = lstr_parametros.entero[1]
		ll_pedido            = lstr_parametros.entero[2]
		ll_cs_liberacion 		= lstr_parametros.entero[3]
		ls_nu_orden 			= lstr_parametros.cadena[1]
		li_co_fabrica_ref 	= lstr_parametros.entero[4]
		li_co_linea_ref 		= lstr_parametros.entero[5]
		ll_co_referencia 		= lstr_parametros.entero[6]
		ll_color_pt 			= lstr_parametros.entero[7]
		ls_tono 					= lstr_parametros.cadena[2]
		li_cs_estilocolton 	= lstr_parametros.entero[8]
		ll_ca_unidades 		= lstr_parametros.entero[9]
		li_co_fabrica_tela	= lstr_parametros.entero[10]
		ll_co_reftel			= lstr_parametros.entero[11]
		li_diametro				= lstr_parametros.entero[12]
		ll_co_color_te			= lstr_parametros.entero[13]
		ld_ancho_cortable		= lstr_parametros.decimal[1]
				
		ll_numero_registros = dw_lista.retrieve(li_co_fabrica_exp,ll_pedido,ll_cs_liberacion,&
															 ls_nu_orden,li_co_fabrica_ref,li_co_linea_ref,ll_co_referencia,&
															 ll_color_pt,ls_tono,li_cs_estilocolton,&
															 li_co_fabrica_tela,ll_co_reftel,li_diametro,ll_co_color_te,&
															 ld_ancho_cortable)
		CHOOSE CASE ll_numero_registros 
			CASE -1
				MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
			CASE 0
				il_fila_actual = 0
				st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
			CASE ELSE
				st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
				dw_lista.setrow(1)
				dw_lista.selectrow(1,true)
				il_fila_actual = 1
		END CHOOSE
	ELSE	
	END IF
END IF
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_partir_escala_de_liberaciones
integer x = 425
integer y = 952
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_partir_escala_de_liberaciones
integer x = 1015
integer y = 1048
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_partir_escala_de_liberaciones
integer x = 457
integer y = 1048
end type

event pb_aceptar::clicked;LONG						ll_pedido,ll_cs_liberacion,ll_co_referencia,ll_color_pt,ll_ca_unidades,ll_ca_a_dejar
Long					li_co_fabrica_exp,li_co_fabrica_ref,li_co_linea_ref,li_cs_estilocolton,li_error
STRING					ls_nu_orden,ls_tono
LONG 						ll_numero_registros,ll_filas,ll_insertados,ll_filaactual
s_base_parametros_seleccionar 	lstr_parametros

lstr_parametros.hay_parametros=TRUE		

li_error=0

IF il_fila_actual > 0 THEN
	
	DELETE FROM t_dt_escalasxtela  
		WHERE  t_dt_escalasxtela.usuario 			= :gstr_info_usuario.codigo_usuario    ;
	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base datos","No pudo borrar estilos en la temporal")
		li_error=1
	ELSE
	END IF
ELSE
END IF


	ll_filas = dw_lista.RowCount()
	ll_insertados = 0
	
	lstr_parametros.entero7[1] = 0

	FOR ll_filaactual = 1 TO ll_filas
		//IF dw_lista.IsSelected(ll_filaactual) THEN
			ll_insertados = ll_insertados + 1		
			lstr_parametros.entero1[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "co_talla")
			lstr_parametros.entero2[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_unidades")
			lstr_parametros.entero3[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_numerada")	
			lstr_parametros.entero4[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_a_sacar")
			lstr_parametros.entero5[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_proporcion")
			lstr_parametros.entero6[ll_insertados] = dw_lista.GetItemNumber(ll_filaactual, "ca_a_dejar")
			
			IF ISNULL(lstr_parametros.entero4[ll_insertados]) THEN
			ELSE
				IF lstr_parametros.entero4[ll_insertados] >= 0 THEN
					//lstr_parametros.entero7[ll_insertados] = lstr_parametros.decimal1[ll_insertados] 
					INSERT INTO t_dt_escalasxtela  
							( usuario,   
							  co_talla,   
							  ca_proporcion,   
							  ca_unidades,   
							  ca_numerada,   
							  ca_a_sacar,
							  ca_a_dejar,
							  fe_creacion,   
							  instancia )  
				  VALUES ( :gstr_info_usuario.codigo_usuario,   
							  :lstr_parametros.entero1[ll_insertados],   
							  :lstr_parametros.entero5[ll_insertados],   
							  :lstr_parametros.entero2[ll_insertados],   
							  :lstr_parametros.entero3[ll_insertados],   
							  :lstr_parametros.entero4[ll_insertados],   
							  :lstr_parametros.entero6[ll_insertados],
							  CURRENT,   
							  :gstr_info_usuario.instancia )  ;
							  
					IF SQLCA.SQLCODE=-1 THEN
						MessageBox("Error Base datos","No pudo insertar en tabla temporal de escalas")
					ELSE
					END IF
					
					lstr_parametros.entero7[1] = lstr_parametros.entero7[1] + lstr_parametros.entero4[ll_insertados]
				ELSE
//					MessageBox("Error de Datos","Las unidades a sacar deben ser mayores que cero")
//					li_error=1
					//RETURN    
				END IF
			END IF
			
			

		//END IF
	NEXT



IF li_error = 0 THEN
	
	lstr_parametros.hay_parametros = True
ELSE
	lstr_parametros.hay_parametros 	= False	
	lstr_parametros.entero7[1]			= 0
END IF

CloseWithReturn(Parent, lstr_parametros)


























end event

type dw_lista from w_base_buscar_lista`dw_lista within w_partir_escala_de_liberaciones
integer width = 1938
integer height = 900
string dataobject = "dtb_partir_escalasxtalla"
end type

