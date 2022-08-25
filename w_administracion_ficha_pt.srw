HA$PBExportHeader$w_administracion_ficha_pt.srw
$PBExportComments$Maestro,detalle,subdetalle
forward
global type w_administracion_ficha_pt from w_base_maestroff_detalletb_subdetalletb
end type
type dw_log from datawindow within w_administracion_ficha_pt
end type
type p_grafico from picture within w_administracion_ficha_pt
end type
end forward

global type w_administracion_ficha_pt from w_base_maestroff_detalletb_subdetalletb
integer width = 4265
integer height = 1928
string title = "Mantenimiento Ficha Producto Terminado"
event ue_llamar_empaque pbm_custom09
event ue_llamar_insumos pbm_custom10
dw_log dw_log
p_grafico p_grafico
end type
global w_administracion_ficha_pt w_administracion_ficha_pt

type variables
Long il_inicial, il_final
end variables

on w_administracion_ficha_pt.create
int iCurrent
call super::create
this.dw_log=create dw_log
this.p_grafico=create p_grafico
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_log
this.Control[iCurrent+2]=this.p_grafico
end on

on w_administracion_ficha_pt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_log)
destroy(this.p_grafico)
end on

event open;call super::open;This.Width = 3920
This.Height =1900

dw_log.SetTransObject(SQLCA)
dw_maestro.InsertRow(0)
il_fila_actual_maestro = 1


m_mantenimiento_maestro_detalle_subdet.m_edicion.m_insertarmaestro.ToolbarItemVisible = False
m_mantenimiento_maestro_detalle_subdet.m_edicion.m_borrarmaestro.ToolbarItemVisible = False
m_mantenimiento_maestro_detalle_subdet.m_edicion.m_insertardetalle.ToolbarItemVisible = False
m_mantenimiento_maestro_detalle_subdet.m_edicion.m_borrardetalle.ToolbarItemVisible = False
m_mantenimiento_maestro_detalle_subdet.m_edicion.m_insertarsubdetalle.ToolbarItemVisible = False
m_mantenimiento_maestro_detalle_subdet.m_edicion.m_borrarsubdetalle.ToolbarItemVisible = False
m_mantenimiento_maestro_detalle_subdet.m_archivo.m_grabar.ToolbarItemVisible = False

end event

event ue_insertar_detalle;//Long ll_co_fabrica, ll_co_linea, ll_co_referencia,ll_co_color, ll_co_calidad,ll_co_talla
//Long li_id_ficha
//
//
//	//////////////////////////////////////////////////////////////////////
//	// Se omite el script del papa.
//	// Se adicionan las lineas necesarias para insertar un registro 
//	// en el subdetalle.
//	/////////////////////////////////////////////////////////////////////
//	
//	Long ll_resultado
//	
//	//////////////////////////////////////////////////////////////////////
//	// En el siguiente CHOOSE CASE se esta verificando si hubo cambios en 
//	//	el Subdetalle.
//	//////////////////////////////////////////////////////////////////////
//	
//
//li_id_ficha = Long(dw_maestro.GetitemString(dw_maestro.GetRow(),"id_ficha"))
//IF li_id_ficha <> 1 THEN
//	CHOOSE CASE wf_detectar_cambios (dw_subdetalle)
//		CASE -1
//			is_cambios = "error"
//			is_accion = "nada"
//			message.returnvalue = 1
//			RETURN
//		CASE 0
//			is_cambios = "no"
//			is_accion = "nada"
//			// No ejecuta ninguna accion
//		CASE 1
//			is_cambios = "si"
//			CHOOSE CASE MessageBox("Cambios detectados en el subdetalle...", &
//							"Desea grabar los cambios del maestro y el subdetalle", &
//							 Question!,YesNoCancel!)
//				CASE 1
//					is_accion = "grabo"
//					This.TriggerEvent("ue_grabar")
//				CASE 2
//					is_accion = "no grabo"
//					// no graba y se sale
//				CASE 3
//					is_accion = "cancelo"
//					message.returnvalue = 1
//					RETURN
//			END CHOOSE
//	END CHOOSE
//	
//	IF (is_cambios = "no" AND is_accion = "nada") OR &
//		(is_cambios = "si" AND is_accion <> "cancelo") THEN
//		
//		ll_resultado = w_base_maestroff_detalletb::Event ue_insertar_detalle(ll_resultado,ll_resultado)
//		
//		
////		IF (is_cambios = "no" AND is_accion = "nada") OR &
////			(is_cambios = "si" AND is_accion <> "cancelo") THEN	
//				dw_subdetalle.Reset()
////		END IF
////		Return ll_resultado
//	END IF
//	
//	IF il_fila_actual_maestro > 0 THEN
//		ll_co_fabrica = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
//		ll_co_linea = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_linea")
//		ll_co_referencia = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_referencia")
//		ll_co_talla = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_talla")
//		ll_co_calidad = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_calidad")
//		ll_co_color = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_color_pt")
//		IF IsNull(ll_co_fabrica) OR IsNull(ll_co_linea) OR IsNull(ll_co_referencia)&
//		 OR IsNull(ll_co_talla) OR IsNull(ll_co_calidad) OR IsNull(ll_co_color) THEN
//			 dw_detalle.DeleteRow(il_fila_actual_detalle)
//			 il_fila_actual_detalle = il_fila_actual_detalle -1
//		ELSE
//			dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica",ll_co_fabrica)
//			dw_detalle.SetItem(il_fila_actual_detalle,"co_linea",ll_co_linea)
//			dw_detalle.SetItem(il_fila_actual_detalle,"co_referencia",ll_co_referencia)
//			dw_detalle.SetItem(il_fila_actual_detalle,"co_talla",ll_co_talla)
//			dw_detalle.SetItem(il_fila_actual_detalle,"co_calidad",ll_co_calidad)
//			dw_detalle.SetItem(il_fila_actual_detalle,"co_color_pt",ll_co_color)
//			dw_detalle.Setitem(il_fila_actual_detalle,"fe_creacion",DateTime(today(),Now()))
//			dw_detalle.Setitem(il_fila_actual_detalle,"fe_actualizacion",DateTime(today(),Now()))
//			dw_detalle.Setitem(il_fila_actual_detalle,"usuario",gstr_info_usuario.codigo_usuario)
//			dw_detalle.Setitem(il_fila_actual_detalle,"instancia",gstr_info_usuario.instancia)
//			dw_detalle.SetItem(il_fila_actual_detalle,"raya", il_fila_actual_detalle * 10)
//			dw_detalle.AcceptText()
//		END IF
//	END IF
//END IF 
end event

event ue_insertar_subdetalle;//long ll_co_fabrica, ll_co_linea, ll_co_referencia, ll_co_talla, ll_co_calidad
//long ll_co_color,ll_co_modelo, ll_reftel, ll_fila
//long ll_caract, ll_diametro, ll_colorte, ll_id_ficha
////Cada que se inserta un Subdetalle 
////Se ingresa il_fila_actual_subdetalle como consecutivo
//
//
//	
//	//il_sx = dw_subdetalle.x
//	//il_sy = dw_subdetalle.y
//	//il_sw = dw_subdetalle.width
//	//il_sh = dw_subdetalle.height
//	
//	//dw_subdetalle.x = 20
//	//dw_subdetalle.y = 20
//	//dw_subdetalle.ReSize(this.width - 20, this.height - 20)
//	//dw_subdetalle.BringToTop = TRUE
//	
//ll_id_ficha = Long(dw_maestro.GetitemString(dw_maestro.GetRow(),"id_ficha"))
//IF ll_id_ficha <> 1 THEN
//	IF il_fila_actual_detalle > 0 THEN
//		IF dw_subdetalle.AcceptText() = -1 THEN
//			MessageBox("Error datawindow","No se pudo insertar el registro del subdetalle porque habian ingresos previos con problemas" &
//						,StopSign!)	
//		ELSE
//			ll_fila = dw_subdetalle.InsertRow(0)
//			IF ll_fila = -1 THEN
//				MessageBox("Error datawindow","No se pudo insertar el registro del subdetalle",StopSign!)
//			ELSE
//				dw_subdetalle.SetFocus()
//				dw_subdetalle.SetRow(ll_fila)
//				dw_subdetalle.ScrollToRow(ll_fila)
//				dw_subdetalle.SetColumn(1)
//				il_fila_actual_subdetalle = ll_fila 
//				dw_subdetalle.SelectRow(il_fila_actual_subdetalle,FALSE)
//				il_fila_actual_subdetalle = dw_subdetalle.GetRow()
//				IF ((il_fila_actual_subdetalle <> -1) and (NOT ISNULL (il_fila_actual_subdetalle)) &
//					and (il_fila_actual_subdetalle <> 0))THEN
//					dw_subdetalle.SelectRow(il_fila_actual_subdetalle,TRUE)
//					dw_subdetalle.SetItem(il_fila_actual_subdetalle, "fe_creacion", f_fecha_servidor())
//				ELSE
//				END IF
//			END IF
//		END IF
//	ELSE
//		MessageBox("Advertencia","No puede insertar registros en el subdetalle sin haber seleccionado un registro en el detalle",Exclamation!,OK!)
//	END IF
//	
//	////////////////////////////////////////////////////////////////////
//	// Cuando herede debe capturar los campos claves del detalle en
//	// variables locales y asignarselas al registro insertado en el 
//	// subdetalle
//	////////////////////////////////////////////////////////////////////
//	//IF il_fila_actual_maestro > 0 THEN
//	//	clave1 = dw_maestro.GetitemString(il_fila_actual_maestro,"clave 1")
//	//	clave2 = dw_maestro.GetitemString(il_fila_actual_maestro,"clave 2")
//	//	......
//	//	IF IsNull(clave1) OR IsNull(clave2) THEN
//	//		dw_detalle.DeleteRow(il_fila_actual_detalle)
//	//		il_fila_actual_detalle = il_fila_actual_detalle - 1
//	//	ELSE
//	//		dw_detalle.SetItem(il_fila_actual_detalle,"clave 1",clave1)
//	//		dw_detalle.SetItem(il_fila_actual_detalle,"clave 2",clave2)
//	//		dw_detalle.AcceptText()
//	//	END IF
//	//END IF
//	////////////////////////////////////////////////////////////////////
//	
//	IF il_fila_actual_detalle > 0 THEN
//		ll_co_fabrica = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica")
//		ll_co_linea = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_linea")
//		ll_co_referencia = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_referencia")
//		ll_co_talla = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_talla")
//		ll_co_calidad = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_calidad")
//		ll_co_color = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_color_pt")
//		ll_co_modelo = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_modelo")
//		dw_subdetalle.SetColumn("Co_Parte")
//		IF IsNull(ll_co_fabrica) OR IsNull(ll_co_linea) OR &
//			IsNull(ll_co_referencia) OR IsNull(ll_co_talla) OR IsNull(ll_co_calidad)&
//			 OR IsNull(ll_co_color) OR IsNull(ll_co_modelo)THEN
//				dw_subdetalle.DeleteRow(il_fila_actual_subdetalle)
//				il_fila_actual_subdetalle = il_fila_actual_subdetalle -1 
//		ELSE
//				dw_Subdetalle.SetItem(il_fila_actual_subdetalle,"cs_partes",il_fila_actual_subdetalle)
//				dw_Subdetalle.SetItem(il_fila_actual_subdetalle,"ca_partes",1)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_fabrica",ll_co_fabrica)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_linea",ll_co_linea)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_referencia",ll_co_referencia)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_talla",ll_co_talla)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_calidad",ll_co_calidad)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_color_pt",ll_co_color)
//				dw_subdetalle.SetItem(il_fila_actual_subdetalle,"co_modelo",ll_co_modelo)
//				dw_subdetalle.Setitem(il_fila_actual_subdetalle,"fe_creacion",DateTime(today(), Now()))
//				IF il_fila_actual_subdetalle - 1 > 0 THEN
//					ll_reftel = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle - 1, "co_reftel")
//					ll_caract = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle - 1, "co_caract")
//					ll_diametro = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle - 1, "diametro")
//					ll_colorte = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle - 1, "co_color_te")
//					dw_subdetalle.SetItem(il_fila_actual_subdetalle, "co_reftel", ll_reftel)
//					dw_subdetalle.SetItem(il_fila_actual_subdetalle, "co_caract", ll_caract)
//					dw_subdetalle.SetItem(il_fila_actual_subdetalle, "diametro", ll_diametro)
//					dw_subdetalle.SetItem(il_fila_actual_subdetalle, "co_color_te", ll_colorte)
//				END IF
//				dw_subdetalle.AcceptText()			
//		END IF
//	END IF
//END IF 
end event

event ue_buscar;call super::ue_buscar;//En este Script se sigue la politica de los objetos Base
//que consiste en revisar en que DW no hay datos para
//informar al usuario que no hay datos.
//Esta operacion se realiza para los tres DW.
s_base_parametros lstr_parametros
long ll_hallados, ll_co_fabrica, ll_co_linea, ll_co_referencia, ll_co_talla, ll_co_color
long ll_co_calidad,ll_co_modelo
Transaction ltr_graficos
String ls_ruta, ls_archivo
Long li_id_ficha
Double ld_prc_uti

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	//Se llama la ventana que hace referencia a la tabla de encabezado
	//Para seleccionar un registro existente.
	Open(w_buscar_ficha_pt)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ll_co_fabrica=lstr_parametros.entero[1]
		ll_co_linea =lstr_parametros.entero[2]
		ll_co_referencia=lstr_parametros.entero[3]
		ll_co_talla =lstr_parametros.entero[4]
		ll_co_calidad =lstr_parametros.entero[5]
		ll_co_color =lstr_parametros.entero[6]
	
		//Con los parametros obtenidos, se realiza el Retrieve del maestro
		ll_hallados = dw_maestro.Retrieve(ll_co_fabrica,ll_co_linea,ll_co_referencia,ll_co_talla,&
							ll_co_calidad,ll_co_color)
		
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
					// Vamos a consultar el grafico de la prenda.					
					ltr_graficos = Create Transaction
					ltr_graficos.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
					ltr_graficos.USERID		=	SQLCA.USERID
					ltr_graficos.DBPASS		=	SQLCA.DBPASS
					ltr_graficos.DBPARM		=	"connectstring='DSN="+ltr_graficos.DATABASE+";UID="+ltr_graficos.USERID+";PWD="+ltr_graficos.DBPASS+"'"
					ltr_graficos.ServerName = 	"vesrs00@hilpro01"
					ltr_graficos.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","")					
					
					IF ll_co_fabrica = 2  THEN
						ltr_graficos.DATABASE	=	"system_graf"
					ELSE
						ltr_graficos.DATABASE	=	"system_graf_inf"
					END IF					
					
					CONNECT USING ltr_graficos;
					IF ltr_graficos.SQLCode = -1 THEN
						MessageBox("Error Base Datos","Error al conectarse a la base de datos de gr$$HEX1$$e100$$ENDHEX$$ficos")
					END IF
					
					SELECT de_path, de_archivo
					INTO :ls_ruta, :ls_archivo
					FROM refe_paths
					WHERE co_fabrica    = :ll_co_fabrica AND
							co_linea      = :ll_co_linea   AND
							co_referencia = :ll_co_referencia   AND
							co_talla      = :ll_co_talla   AND
							co_calidad    = :ll_co_calidad AND
							de_orden      = 'Frente'
					USING ltr_graficos;
							
					IF ltr_graficos.SQLCode = -1 THEN
						MessageBox("Error Base Datos","Error al consultar la ruta del archivo")
						ls_ruta = ''
						ls_archivo = ''
					//	Close(w_retroalimentacion)	
					//	Close(This)
					END IF
					
					DISCONNECT USING ltr_graficos;
					
					p_grafico.PictureName = Trim(ls_ruta) + Trim(ls_archivo)
					
//					MessageBox("Busqueda ok","registros encontrados: "+&
//             	String(ll_hallados),Information!,Ok!)
					li_id_ficha=Long(dw_maestro.GetitemString(dw_maestro.getrow(),"id_ficha"))	
					//ld_prc_uti = (dw_detalle.GetItemDecimal(il_fila_actual_maestro,"porc_utilizacion"))/100
					ll_hallados = dw_detalle.Retrieve(ll_co_fabrica,ll_co_linea,ll_co_referencia,ll_co_talla,&
					ll_co_calidad,ll_co_color, li_id_ficha)
					IF isnull(ll_hallados) THEN
						MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
					ELSE
					CHOOSE CASE ll_hallados
						CASE -1
							il_fila_actual_detalle = -1
							MessageBox("Error buscando","Error de la base",StopSign!,&
		                         Ok!)
							dw_subdetalle.Reset()
						CASE 0
							il_fila_actual_detalle= 0
							MessageBox("Sin Datos","No hay datos para su criterio",&
      		                   Exclamation!,Ok!)
							dw_subdetalle.Reset()
						CASE ELSE
							il_fila_actual_detalle= 1
							li_id_ficha=Long(dw_maestro.GetitemString(dw_maestro.getrow(),"id_ficha"))							
							ld_prc_uti =  (dw_detalle.GetItemDecimal(il_fila_actual_maestro,"porc_utilizacion"))/100
							ll_co_modelo = dw_detalle.Getitemnumber(il_fila_actual_detalle,"co_modelo")
							ll_hallados = dw_Subdetalle.Retrieve(ll_co_fabrica,ll_co_linea,ll_co_referencia,ll_co_talla,&
							ll_co_calidad,ll_co_color,ll_co_modelo, li_id_ficha, ld_prc_uti)
							IF isnull(ll_hallados) THEN
								MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
							ELSE
								CHOOSE CASE ll_hallados
									CASE -1
										il_fila_actual_Subdetalle = -1
										MessageBox("Error buscando","Error de la base",StopSign!,&
		   		                      Ok!)
									CASE 0
										il_fila_actual_Subdetalle= 0
										MessageBox("Sin Datos","No hay datos para su criterio",&
			      		                   Exclamation!,Ok!)
									CASE ELSE
										il_fila_actual_Subdetalle= 1
								END CHOOSE
							END IF
				END CHOOSE
			END IF
	END CHOOSE
END IF
ELSE
END IF
ELSE
END IF
end event

event ue_borrar_subdetalle;////cuando se desee borrar un subdetalle se deben actualizar los numeros
////de secuencia de los demas registros que quedan en el DW.
////Si existen 10 registros y se borra el #3, entonces del 4 al 10
////se deben decrementar en uno para llenar el espacio que deja el 3.
//Long li_cont, li_id_ficha
//
//long ll_fila
///////////////////////////////////////////////////////////////////////////
//// SI LA FICHA ESTA EN ESTADO ACTIVA NO DBE DEJAR BORRAR REGISTROS
///////////////////////////////////////////////////////////////////////////
//
//li_id_ficha = Long(dw_maestro.GetitemString(il_fila_actual_maestro,"id_ficha"))
//IF li_id_ficha <> 1 THEN
//	ll_fila = dw_subdetalle.GetRow()
//	CHOOSE CASE ll_fila
//		CASE -1
//			MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del subdetalle ",StopSign!,Ok!)
//		CASE 0
//			MessageBox("Advertencia","No se ha seleccionado la fila a borrar del subdetalle",Exclamation!,Ok!)
//		CASE ELSE
//			IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del subdetalle",Question!,YesNo!) = 1) THEN
//				IF (dw_subdetalle.DeleteRow(ll_fila) = -1) THEN
//					MessageBox("Error datawindow","No pudo borrar del subdetalle",StopSign!,Ok!)
//				ELSE
//					This.TriggerEvent("ue_grabar")
//				END IF
//			ELSE
//			END IF
//	END CHOOSE
//	
//	il_fila_actual_subdetalle = il_fila_actual_subdetalle - 1
//	
//	
//	li_cont = dw_Subdetalle.rowcount()
//	FOR li_cont=il_fila_actual_Subdetalle TO dw_Subdetalle.rowcount()
//		dw_Subdetalle.setitem(li_cont,"cs_partes",li_cont)	
//	NEXT
//	this.triggerevent("ue_grabar")
//END IF
end event

event closequery;//IF (is_cambios = "no") OR (is_cambios = "si" AND is_accion = "no grabo") THEN
//	CHOOSE CASE wf_detectar_cambios (dw_subdetalle)
//		CASE -1
//			is_cambios = "error"
//			is_accion = "nada"
//			message.returnvalue = 1
//			RETURN
//		CASE 0
//			is_cambios = "no"
//			is_accion = "nada"
//			// No ejecuta ninguna accion
//		CASE 1
//			is_cambios = "si"
//			CHOOSE CASE MessageBox("Cambios detectados en el Subdetalle...","Desea grabar los cambios del maestro y el subdetalle",Question!,yesnocancel!,1)
//				CASE 1
//					is_accion = "grabo"
//					This.TriggerEvent("ue_grabar")
//				CASE 2
//					is_accion = "no grabo"
//					// no graba y se sale
//				CASE 3
//					is_accion = "cancelo"
//					message.returnvalue = 1
//					RETURN
//			END CHOOSE
//	END CHOOSE
//ELSE
//END IF
//IF dw_log.AcceptText() = -1 THEN
//	MessageBox("Error DataWindow","Error al grabar en la tabla de log")
//	Return(1)
//END IF
//IF dw_log.Update() = -1 THEN
//	MessageBox("Error Datawindow","Error al grabar en la tabla de log")
//ELSE
//	COMMIT;
////	IF il_final >= il_inicial THEN
////		f_enviar_correo(il_inicial, il_final, This.ClassName())
////	END IF
//END IF
end event

event ue_borrar_detalle;/////////////////////////////////////////////////////////////////////////
//// Se omite el script del papa. Se verifica de que no existan 
//// detalles asociados con el registro del maestro a borrar.
/////////////////////////////////////////////////////////////////////////
//
//Long ll_resultado, li_id_ficha
//
//li_id_ficha = Long(dw_maestro.GetitemString(il_fila_actual_maestro,"id_ficha"))
//IF li_id_ficha <> 1 THEN
//	IF dw_subdetalle.RowCount() > 0 THEN
//		MessageBox("Advertencia","El registro detalle seleccionado tiene subdetalles asociados, no se puede borrar",Exclamation!,OK!)
//	ELSE
//		ll_resultado = w_base_maestroff_detalletb::Event ue_borrar_detalle(ll_resultado,ll_resultado)
//		Return ll_resultado
//	END IF
//END IF 
//
end event

event ue_grabar;////////////////////////////////////////////////////////////////////////////
//// En este evento se realizar ACCEPTTEXT para llevar los cambios 
//// del subdetalle al buffer.
//// El  UPDATE para preparar los datos en el servidor.
//// El  COMMIT para grabar los cambios en la base de datos
////////////////////////////////////////////////////////////////////////////
//
//IF is_accion = "si update" THEN
//	IF dw_subdetalle.AcceptText() = -1 THEN
//		is_accion = "no accepttext"
//		Messagebox("Error","No se pudieron realizar los cambios en el subdetalle",Exclamation!,Ok!)	
//		RETURN
//	ELSE
//		IF dw_subdetalle.Update() = -1 THEN
//			is_accion = "no update"
//			ROLLBACK;
//			MessageBox("Error","No se pudo hacer los cambios en el subdetalle para la base de datos",Exclamation!,Ok!)	
//			RETURN
//		ELSE
//			is_accion = "si update"
//			COMMIT;
//			IF SQLCA.SQLCode = -1 THEN
//				is_grabada = "no"
//				MessageBox("Error","No se pudo hacer los cambios en el subdetalle para la base de datos" &
//								,Exclamation!,Ok!)	
//			ELSE
//				is_grabada = "si"
//			END IF
//		END IF
//	END IF
//END IF
//
//dw_detalle.x = il_dx
//dw_detalle.y = il_dy
//dw_detalle.ReSize(il_dw, il_dh)
//dw_detalle.SetColumn(1)
//
//dw_subdetalle.x = il_sx
//dw_subdetalle.y = il_sy
//dw_subdetalle.ReSize(il_sw, il_sh)
//dw_subdetalle.SetColumn(1)
//
//call super :: ue_grabar
end event

event ue_insertar_maestro;//no
end event

type dw_maestro from w_base_maestroff_detalletb_subdetalletb`dw_maestro within w_administracion_ficha_pt
integer x = 5
integer width = 2633
integer height = 344
integer taborder = 10
boolean titlebar = false
string dataobject = "dff_maestro_ficha_pt"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::updatestart;//Long ll_modificados, ll_registros, ll_referencia, ll_reglog, ll_filamodificada
//Long ll_fabrica, ll_linea, ll_talla, ll_calidad, ll_colorpt, ll_grupoprenda
//Long ll_registros
//String ls_tabla, ls_operacion, ls_columna, ls_usuario, ls_instancia
//String ls_datomodificado, ls_indnuevo, ls_indviejo
//DateTime ldt_fecha
//DateTime ldt_fecha_log
// 
//
//ls_tabla = 'h_ficha_pt'
//ll_registros = 1
//ldt_fecha_log = DateTime(Today(), Now())
//ldt_fecha = DateTime(Today(), Now())
//ls_usuario = gstr_info_usuario.codigo_usuario
//ls_instancia = gstr_info_usuario.instancia
//IF dw_maestro.GetItemStatus(ll_registros, 0, Primary!) = NewModified! THEN
//	ll_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
//	ll_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
//	ll_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
//	ll_talla = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla")
//	ll_calidad = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad")
//	ll_colorpt = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt")
//	dw_maestro.SetItem(ll_filamodificada, "fe_creacion", Today())
//	dw_maestro.SetItem(ll_filamodificada, "usuario", ls_usuario)
//	dw_maestro.SetItem(ll_filamodificada, "instancia", ls_instancia)
//	ls_operacion = 'Creacion'
//	ll_reglog = dw_log.InsertRow(0)
//	IF ll_reglog = -1 THEN
//		MessageBox("Error Datawindow","Error al crear registro de log")
//		Return(1)
//	END IF
//	dw_log.SetItem(ll_reglog, "co_fabrica", ll_fabrica)
//	dw_log.SetItem(ll_reglog, "co_linea", ll_linea)
//	dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
//	dw_log.SetItem(ll_reglog, "co_talla", ll_talla)
//	dw_log.SetItem(ll_reglog, "co_calidad", ll_calidad)
//	dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
//	dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
//	dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
//	dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
//	dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
//	dw_log.SetItem(ll_reglog, "instancia", ls_instancia)
//ELSE
//	ls_operacion = 'Modificacion'
//	IF dw_maestro.GetItemStatus(ll_registros, 0, Primary!) = DataModified! THEN 
//		ls_datomodificado = 'id_ficha'
//		ls_indviejo = dw_maestro.GetItemString(ll_registros, "id_ficha", Primary!, True)
//		ls_indnuevo = dw_maestro.GetItemString(ll_registros, "id_ficha", Primary!, False)					
//		ll_reglog = dw_log.InsertRow(0)
//		IF ll_reglog = -1 THEN
//			MessageBox("Error Datawindow","Error al crear registro de log")
//			Return(1)
//		END IF
//		dw_log.SetItem(ll_reglog, "co_fabrica", ll_fabrica)
//		dw_log.SetItem(ll_reglog, "co_linea", ll_linea)
//		dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
//		dw_log.SetItem(ll_reglog, "co_talla", ll_talla)
//		dw_log.SetItem(ll_reglog, "co_calidad", ll_calidad)
//		dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
//		dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
//		dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
//		dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
//		dw_log.SetItem(ll_reglog, "valor_nuevo", ls_indnuevo)
//		dw_log.SetItem(ll_reglog, "valor_viejo", ls_indviejo)
//		dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
//		dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
//		dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
//	END IF
//END IF
//
//IF This.GetItemStatus(il_fila_actual_maestro, 0, Primary!) = NewModified! OR &
//	This.GetItemStatus(il_fila_actual_maestro, 0, Primary!) = DataModified! THEN
//	ll_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
//	ll_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")	
//
//// Inicialmente este control va a ser solo para las referencias del mercado nacional de Vestimundo.
//
//	IF ll_fabrica = 2 AND ll_linea <> 23 THEN
//		ll_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
//		ll_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
//		ll_talla = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla")
//		ll_calidad = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad")
//		ll_colorpt = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt")
//		
//		SELECT co_grupo_pda
//		INTO :ll_grupoprenda
//		FROM vta_grupos_prenda
//		WHERE co_fabrica = :ll_fabrica AND
//				co_linea = :ll_linea;
//				
//		IF SQLCA.SQLCode = -1 THEN
//			MessageBox("Error Base Datos","Error al verificar el tipo de prenda " + SQLCA.SQLErrText)
//			Return 1
//		END IF
////		IF ll_grupoprenda <> 6 THEN
////			SELECT Count(*)
////			INTO :ll_registros
////			FROM dt_surt_pdn
////			WHERE co_fabrica = :ll_fabrica AND
////					co_linea = :ll_linea AND
////					co_referencia = :ll_referencia AND
////					co_talla = :ll_talla AND
////					co_calidad = 2;
////			IF SQLCA.SQLCode = -1 THEN
////				MessageBox("Error Base Datos","Error al validar el grupo de segundas " + SQLCA.SQLErrText)
////				Return 1
////			END IF
////			IF ll_registros = 0 THEN
////				MessageBox("Advertencia...","No se puede grabar la referencia, no est$$HEX2$$e1002000$$ENDHEX$$asociada a un grupo de segundas")
////				Return 1
////			END IF
////		END IF
//	END IF
//END IF
end event

event dw_maestro::sqlpreview;//String ls_operacion, ls_tabla, ls_usuario, ls_instancia
//Long ll_fabrica, ll_linea, ll_talla, ll_calidad, ll_color
//Long ll_referencia, ll_reglog
//Date ldt_fecha
//DateTime ldt_fecha_log
//
//IF sqltype = PreviewDelete! THEN
//	ls_operacion = 'Borrado'
//	ls_tabla = 'dt_ficha_tiempos'
//	ldt_fecha_log = DateTime(Today(), Now())
//	ldt_fecha = Today()
//	ls_usuario = gstr_info_usuario.codigo_usuario
//	ls_instancia = gstr_info_usuario.instancia
//	ll_fabrica = dw_maestro.GetItemNumber(row, "co_fabrica", buffer, True)
//	ll_linea = dw_maestro.GetItemNumber(row, "co_linea", buffer, True)
//	ll_referencia = dw_maestro.GetItemNumber(row, "co_referencia", buffer, True)
//	ll_talla = dw_maestro.GetItemNumber(row, "co_talla", buffer, True)
//	ll_calidad = dw_maestro.GetItemNumber(row, "co_calidad", buffer, True)
//	ll_color = dw_maestro.GetItemNumber(row, "co_color_pt", buffer, True)
//	ll_reglog = dw_log.InsertRow(0)
//	IF ll_reglog = -1 THEN
//		MessageBox("Error Datawindow","Error al crear registro de log")
//		Return(1)
//	END IF
//	dw_log.SetItem(ll_reglog, "co_fabrica", ll_fabrica)
//	dw_log.SetItem(ll_reglog, "co_linea", ll_linea)
//	dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
//	dw_log.SetItem(ll_reglog, "co_talla", ll_talla)
//	dw_log.SetItem(ll_reglog, "co_calidad", ll_calidad)
//	dw_log.SetItem(ll_reglog, "co_color_pt", ll_color)
//	dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
//	dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
//	dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
//	dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
//	dw_log.SetItem(ll_reglog, "instancia", ls_instancia)
//END IF
end event

event dw_maestro::itemchanged;Long li_fabrica, li_linea, li_talla, li_calidad, li_id_ficha
Long li_fabrica_ini, li_linea_ini, li_talla_ini, li_caract, li_repite
Long li_calidad_ini, li_respuesta, li_registros, li_columna, li_co_linea_plan, li_reg_ped
Long ll_referencia, ll_referencia_ini, ll_hallados, ll_reftel, ll_modelo, ll_color, ll_colorte, ll_color_ini
String ls_descripcion, ls_id_ficha_ant, ls_validacion, ls_instruccion, ls_referencia, ls_color, ls_talla
Datetime ld_ano_mes
Datastore lds_h_ordenpd_pt, lds_peddig
lds_h_ordenpd_pt = Create DataStore
lds_peddig = Create DataStore


lds_peddig.DataObject = 'dgr_pedidos'
lds_h_ordenpd_pt.DataObject = 'dtb_h_ordenpd_pt'

IF lds_peddig.SetTransObject(SQLCA) = -1 THEN
	ls_validacion = "Error al definir el objeto lds_peddig"
	Return(-1)
END IF


IF lds_h_ordenpd_pt.SetTransObject(SQLCA) = -1 THEN
	ls_validacion = "Error al definir el objeto lds_h_ordenpd_pt"
	Return(-1)
END IF


dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
ls_id_ficha_ant  = GetItemString(row, "id_ficha")
dw_maestro.AcceptText()
li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
li_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
ll_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
li_talla = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla")
li_calidad = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad")
ll_color = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt")
IF Dwo.Name = "co_linea" THEN
	SELECT	de_linea
	INTO		:ls_descripcion
	FROM		m_lineas
	WHERE		co_fabrica = :li_fabrica AND
				co_linea = :li_linea;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar la l$$HEX1$$ed00$$ENDHEX$$nea en Vestimundo")
		Return(2)
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			SELECT	de_linea
			INTO		:ls_descripcion
			FROM		m_lineas_inf
			WHERE		co_fabrica = :li_fabrica AND
						co_linea = :li_linea;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al validar la l$$HEX1$$ed00$$ENDHEX$$nea en Infantiles")
				Return(2)
			ELSE
				IF SQLCA.SQLCode = 100 THEN
					MessageBox("Advertencia...","La l$$HEX1$$ed00$$ENDHEX$$nea no existe en la Base de Datos")
					Return(2)
				ELSE
					dw_maestro.SetItem(il_fila_actual_maestro, "m_lineas_de_linea", ls_descripcion)
				END IF
			END IF
		ELSE
			dw_maestro.SetItem(il_fila_actual_maestro, "m_lineas_de_linea", ls_descripcion)			
		END IF
	END IF
	IF (NOT IsNull(li_fabrica)) AND (NOT IsNull(li_linea)) THEN
		f_rcpra_dtos_dddw_param1(this,"co_color_pt",SQLCA,li_fabrica,li_linea)
	ELSE
		f_rcpra_dtos_dddw_param1(this,"co_color_pt",SQLCA,0,0)
	END IF	
END IF
IF Dwo.Name = "co_referencia" THEN
	SELECT	de_referencia
	INTO		:ls_descripcion
	FROM		h_preref_pv
	WHERE		co_fabrica = :li_fabrica AND
				co_linea = :li_linea AND
				(Cast(:ll_referencia as char(15) ) = h_preref_pv.co_referencia ) AND
				co_tipo_ref = 'P';
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar la referencia en Vestimundo")
		Return(2)
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			MessageBox("Advertencia...","La referencia no existe en la base de datos")
			Return(2)
		ELSE
			dw_maestro.SetItem(il_fila_actual_maestro, "de_referencia", ls_descripcion)
		END IF
			
		
	END IF
END IF
IF Dwo.Name = "co_color_pt" THEN
	IF Not IsNull(ll_color) AND Not IsNull(li_talla) THEN
		
		ls_referencia = String(ll_referencia)
		ls_talla		  = String(li_talla)
		ls_color 	  = String(ll_color)
		
		SELECT	Count(*)
		INTO		:li_registros
		FROM		dt_ref_x_col_pv
		WHERE		co_fabrica = :li_fabrica AND
					co_linea = :li_linea AND
					co_referencia = :ls_referencia AND
					co_talla = :ls_talla AND
					co_color = :ls_color;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al validar la talla-color en Vestimundo")
			Return(2)
		ELSE
			IF li_registros = 0 THEN
				SELECT	Count(*)
				INTO		:li_registros
				FROM		dt_ref_x_col_inf
				WHERE		co_fabrica = :li_fabrica AND
							co_linea = :li_linea AND
							co_referencia = :ll_referencia AND
							co_talla = :li_talla AND
							co_color = :ll_color;
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al validar la talla-color en Infantiles")
					Return(2)
				ELSE
					IF li_registros = 0 THEN
						MessageBox("Advertencia...","La talla-color no existe en la Base de Datos")
						Return(2)
					END IF
				END IF
			END IF
		END IF
	END IF

	// VERIFICA QUE TENGA LOS PORCENTAJES DE PARTICIPACION CREADOS 
	ll_color=Long(data)
	SELECT	Count(*)
	  INTO	:li_registros
	  FROM	dt_porccolor
	 WHERE	co_fabrica = :li_fabrica AND
				co_linea = :li_linea AND
				co_referencia = :ll_referencia AND
				co_talla = :li_talla AND
				co_color = :ll_color;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar los porcentajes de participaci$$HEX1$$f300$$ENDHEX$$n de talla-color")
		Return 1
	ELSE
		IF li_registros=0 THEN
			MessageBox("Advertencia...","La talla-color no tiene porcentajes de participaci$$HEX1$$f300$$ENDHEX$$n")
			Return 1
		END IF 
	END IF
END IF
IF Dwo.Name = "co_talla" THEN
	IF Not IsNull(li_talla) AND Not IsNull(ll_color) THEN
		
		ls_referencia = String(ll_referencia)
		ls_talla		  = String(li_talla)
		ls_color 	  = String(ll_color)
		
		SELECT	Count(*)
		INTO		:li_registros
		FROM		dt_ref_x_col_pv
		WHERE		co_fabrica = :li_fabrica AND
					co_linea = :li_linea AND
					co_referencia = :ls_referencia AND
					co_talla = :ls_talla AND
					co_color = :ls_color;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al validar la talla-color en Vestimundo")
			Return(2)
		ELSE
			IF li_registros = 0 THEN
				SELECT	Count(*)
				INTO		:li_registros
				FROM		dt_ref_x_col_inf
				WHERE		co_fabrica = :li_fabrica AND
							co_linea = :li_linea AND
							co_referencia = :ll_referencia AND
							co_talla = :li_talla AND
							co_color = :ll_color;
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al validar la talla-color en Infantiles")
					Return(2)
				ELSE
					IF li_registros = 0 THEN
						MessageBox("Advertencia...","La talla-color no existe en la Base de Datos")
						Return(2)
					END IF
				END IF
			END IF
		END IF
	END IF
END IF
//VERIFICA QUE LA CALIDAD DE LA PRENDA ESTE CREADA EN VENTAS
IF Dwo.Name = "co_calidad" THEN
	
	ls_referencia = String(ll_referencia)
	li_calidad=Long(data)
	SELECT	Count(*)
	  INTO		:li_registros
	  FROM		dt_preref_pv
    WHERE		co_fabrica = :li_fabrica AND
					co_linea = :li_linea AND
					co_referencia = :ls_referencia AND
					co_calidad=:li_calidad;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar la calidad de la prenda en ventas")
		Return(2)
	ELSE
		IF li_registros = 0 THEN
			MessageBox("Advertencia...","La calidad no existe en ventas")
			Return(2)
		END IF
	END IF
END IF 
IF Dwo.Name = "id_ficha" THEN
/////////////////////////////////////////////////////////////
//Solo el administrador de la ficha de prenda puede cambiar 
//los estados de la ficha tecnica 
////////////////////////////////////////////////////////////

//	If	gstr_info_usuario.codigo_perfil <> 20 Then 
//		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","Su perfil no esta autorizado para realizar los cambios")
//		dw_maestro.setitem(row, 'id_ficha', ls_id_ficha_ant)
//		Return 1
//	End If 
	
	IF Long(data) = 1 THEN
			SELECT count(*) 
			  INTO :li_registros
			  FROM dt_ficha_empaque
			 WHERE co_fabrica=:li_fabrica and
					 co_linea=:li_linea and 
					 co_referencia=:ll_referencia and 
					 co_talla = :li_talla and 
					 co_calidad = :li_calidad and 
					 co_color =:ll_color ;
				
			
			SELECT co_linea_plan
			  INTO :li_co_linea_plan
			  FROM h_preref_pv
			 WHERE co_fabrica=:li_fabrica and
					 co_linea=:li_linea and 
				 	(Cast(:ll_referencia as char(15) ) = h_preref_pv.co_referencia ) AND
					 co_tipo_ref = 'P';
			
			// Si la prenda es un accesorio no verifica la ficha de telas
			
			IF li_co_linea_plan <> 95 Then
			
				IF ( Rowcount(dw_subdetalle)> 0 ) AND (li_registros > 0) THEN 
						//Busco todos los modelos que componen la prenda
							DECLARE modelos CURSOR FOR
							SELECT DISTINCT co_modelo
							  FROM dt_modelos
							 WHERE co_fabrica=:li_fabrica and
									 co_linea=:li_linea and 
									 co_referencia=:ll_referencia and 
									 co_talla = :li_talla and 
									 co_calidad = :li_calidad and 
									 co_color_pt=:ll_color;
																				
						IF SQLCA.SQLCode = -1 THEN
							MessageBox("Error Base Datos","Error al definir el cursor de modelos")
							Return
						END IF
				
						OPEN modelos;
						IF SQLCA.SQLCode = -1 THEN
							MessageBox("Error Base Datos","Error al abrir el cursor de modelos")
							Return
						END IF
				
						FETCH modelos INTO :ll_modelo;
						
						IF SQLCA.SQLCode = -1 THEN
							MessageBox("Error Base Datos","Error al leer el primer registro del cursor de modelos")
							CLOSE modelos;
							Return
						END IF
						DO WHILE SQLCA.SQLCode = 0
						//Busco las telas que componen los modelos 
								DECLARE c_modelos CURSOR FOR
									SELECT DISTINCT co_reftel, co_caract, co_color_te, co_repite 
									  FROM dt_color_modelo
									 WHERE co_fabrica=:li_fabrica and
											 co_linea=:li_linea and 
											 co_referencia=:ll_referencia and 
											 co_talla = :li_talla and 
											 co_calidad = :li_calidad and 
											 co_color_pt=:ll_color and
											 co_modelo = :ll_modelo;			
								OPEN c_modelos;
								
								IF SQLCA.SQLCode = -1 THEN
									MessageBox("Error Base Datos","Error al definir el cursor de c_modelos")
									Return
								END IF
								
								IF SQLCA.SQLCode = -1 THEN
									MessageBox("Error Base Datos","Error al abrir el cursor de c_modelos")
									Return
								END IF
						
								FETCH c_modelos INTO :ll_reftel, :li_caract, :ll_colorte, :li_repite; 
					
								
								IF SQLCA.SQLCode = -1 THEN
									MessageBox("Error Base Datos","Error al leer el primer registro del cursor de C_modelos")
									CLOSE c_modelos;
									Return
								END IF
								li_fabrica = 2
								DO WHILE SQLCA.SQLCode = 0
									
									//valido si la  tela existe 
										SELECT count(*)
										  INTO :li_registros
										  FROM h_telas_pre
										 WHERE co_reftel =  :ll_reftel ;
									
										
										IF li_registros = 0 THEN 
											MessageBox("Error","La ficha debe tener las telas definitivas para cambiar de estado")
											dw_maestro.setitem(row, 'id_ficha', ls_id_ficha_ant)
											CLOSE c_modelos; 
											Return 1
										END IF
												
								FETCH c_modelos INTO :ll_reftel, :li_caract, :ll_colorte, :li_repite;
								LOOP
								CLOSE c_modelos; 
						FETCH modelos INTO :ll_modelo;
						LOOP
						CLOSE modelos; 
				END IF
			END IF 
			//verrifica que los insumos de la prenda se encuentren en estado definitivo 		
			IF li_fabrica <> 4 THEN
					 SELECT ano_mes
						INTO :ld_ano_mes
						FROM cf_empaque
					  WHERE co_fabrica=:li_fabrica;
					 
					
					SELECT count(co_referencia) 
					  INTO :li_registros
					  FROM dt_ficha_empaque,
							 s_costo_tmp
					 WHERE dt_ficha_empaque.co_fabrica_me  = s_costo_tmp.co_fabrica and         
							 dt_ficha_empaque.co_producto = s_costo_tmp.co_producto  and          
							 dt_ficha_empaque.co_proveedor = s_costo_tmp.co_proveedor  and          
							 dt_ficha_empaque.co_color_me = s_costo_tmp.co_color  and
							 dt_ficha_empaque.co_fabrica=:li_fabrica and
							 dt_ficha_empaque.co_linea=:li_linea and 
							 dt_ficha_empaque.co_referencia=:ll_referencia and 
							 dt_ficha_empaque.co_talla = :li_talla and 
							 dt_ficha_empaque.co_calidad = :li_calidad and 
							 dt_ficha_empaque.co_color =:ll_color and 
							 s_costo_tmp.ano_mes =:ld_ano_mes and
							 dt_ficha_empaque.co_estado_insumo = "P";
							 
					IF li_registros > 0 THEN 
							MessageBox("Error","La ficha debe tener los insumos definitivos para cambiar de estado")
							dw_maestro.setitem(1,"id_ficha",ls_id_ficha_ant)
							Return 1
					END IF
					//verifica que los estados de los insumos en s_costo_tmp esten "D"
					 
					 SELECT count(co_referencia) 
					  INTO :li_registros
					  FROM dt_ficha_empaque,
							 s_costo_tmp
					 WHERE dt_ficha_empaque.co_fabrica_me  = s_costo_tmp.co_fabrica and         
							 dt_ficha_empaque.co_producto = s_costo_tmp.co_producto  and          
							 dt_ficha_empaque.co_proveedor = s_costo_tmp.co_proveedor  and          
							 dt_ficha_empaque.co_color_me = s_costo_tmp.co_color  and
							 dt_ficha_empaque.co_fabrica=:li_fabrica and
							 dt_ficha_empaque.co_linea=:li_linea and 
							 dt_ficha_empaque.co_referencia=:ll_referencia and 
							 dt_ficha_empaque.co_talla = :li_talla and 
							 dt_ficha_empaque.co_calidad = :li_calidad and 
							 dt_ficha_empaque.co_color =:ll_color and 
							 s_costo_tmp.ano_mes =:ld_ano_mes and
							 s_costo_tmp.estado = "P";
							 
					IF li_registros > 0 THEN 
							MessageBox("Error","La ficha debe tener todos los insumos en estado 'D' para cambiar el estado de la ficha")
							dw_maestro.setitem(1,"id_ficha",ls_id_ficha_ant)
							Return 1
					END IF
			END IF 
	//		ELSE
	//			MessageBox("Error","La ficha debe tener las telas y los insumos definitivos para cambiar de estado")
	//			dw_maestro.setitem(row, 'id_ficha', ls_id_ficha_ant)
	//			Return 1
   //		END IF
	
	END IF 
	
END IF 
	
			
// Cuando se ha realizado alg$$HEX1$$fa00$$ENDHEX$$n cambio en los datos que hacen parte de la clave se va a 
// realizar la consulta de una ficha o se va a crear una nueva.
IF Not IsNull(li_fabrica) AND Not IsNull(li_linea) AND &
	Not IsNull(ll_referencia) AND Not IsNull(li_talla) AND &
	Not IsNull(li_calidad) AND Not IsNull(ll_color) AND dwo.Name <> "id_ficha" THEN
	li_columna = This.GetColumn()

// Se valida si existe una ficha de tela para los datos que se tienen en pantalla y as$$HEX2$$ed002000$$ENDHEX$$
// saber que acci$$HEX1$$f300$$ENDHEX$$n tomar.


	SELECT	Count(*)
	INTO		:li_registros
	FROM		h_ficha_pt
	WHERE		co_fabrica = :li_fabrica AND
				co_linea = :li_linea AND
				co_referencia = :ll_referencia AND
				co_talla = :li_talla AND
				co_calidad = :li_calidad AND
				co_color_pt = :ll_color;

	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar existencia de ficha")
		Return(1)
	ELSE
		IF li_registros > 0 THEN
			
// Si la fila ya existe en la base de datos, "Estado DataModified" se procede a realizar 
// las verificaciones necesarias para consultar otra ficha

			IF dw_maestro.GetItemStatus(il_fila_actual_maestro, 0, Primary!) = DataModified! THEN
				IF dw_maestro.GetItemStatus(il_fila_actual_maestro, "id_ficha", Primary!) = DataModified! OR &
					wf_detectar_cambios(dw_detalle) = 1 OR wf_detectar_cambios(dw_subdetalle) = 1 THEN
					li_respuesta = MessageBox("Cambios Detectados",&
						"Desea grabar las modificaciones realizadas", Question!, YESNOCANCEL!)
					IF li_respuesta = 1 THEN			
				
// Cuando hay cambios y se van a grabar los cambios se guardan en variables auxiliares 
// los valores con los cuales se hizo el retrieve de la ficha que se encuentra en 
// pantalla y se reestablecen en los campos de la ficha. El objetivo de esto es que antes 
// de hacer el update sobre el maestro se tengan los datos originales y no se haga una 
// actualizaci$$HEX1$$f300$$ENDHEX$$n sobre la clave de la ficha.

						li_fabrica_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica", Primary!, True)
						li_linea_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea", Primary!, True)
						ll_referencia_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia", Primary!, True)
						li_talla_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla", Primary!, True)
						li_calidad_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad", Primary!, True)
						ll_color_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt", Primary!, True)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_fabrica_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_linea_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_referencia_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_talla", li_talla_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_calidad", li_calidad_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_color_pt", ll_color_ini)
						dw_maestro.AcceptText()
						Parent.TriggerEvent("ue_grabar")
					ELSE
						IF li_respuesta = 3 THEN
							Return
						END IF
					END IF
				END IF
			END IF
			ll_hallados = dw_maestro.Retrieve(li_fabrica, li_linea, ll_referencia, li_talla, li_calidad, ll_color)
			IF ll_hallados > 0 THEN
				il_fila_actual_maestro = 1
				li_id_ficha=Long(dw_maestro.GetitemString(il_fila_actual_maestro,"id_ficha"))
				ll_hallados = dw_detalle.Retrieve(li_fabrica, li_linea, ll_referencia, li_talla, li_calidad, ll_color, li_id_ficha )
				IF ll_hallados > 0 THEN
					dw_detalle.TriggerEvent("RowFocusChanged")
				ELSE
					dw_subdetalle.Reset()
				END IF
			ELSE
				dw_detalle.Reset()
			END IF
		ELSE
			IF dw_maestro.GetItemStatus(il_fila_actual_maestro, 0, Primary!) = DataModified! THEN
				IF dw_maestro.GetItemStatus(il_fila_actual_maestro, "id_ficha", Primary!) = DataModified! OR &
					wf_detectar_cambios(dw_detalle) = 1 OR wf_detectar_cambios(dw_subdetalle) = 1 THEN
					li_respuesta = MessageBox("Cambios Detectados",&
						"Desea grabar las modificaciones realizadas", Question!, YESNOCANCEL!)
					IF li_respuesta = 1 THEN			
						li_fabrica_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica", Primary!, True)
						li_linea_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea", Primary!, True)
						ll_referencia_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia", Primary!, True)
						li_talla_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla", Primary!, True)
						li_calidad_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad", Primary!, True)
						ll_color_ini = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt", Primary!, True)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_fabrica_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_linea_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_referencia_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_talla", li_talla_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_calidad", li_calidad_ini)
						dw_maestro.SetItem(il_fila_actual_maestro, "co_color_pt", ll_color_ini)
						dw_maestro.AcceptText()
						Parent.TriggerEvent("ue_grabar")
					ELSE
						IF li_respuesta = 3 THEN
							Return
						END IF
					END IF
				END IF
			END IF
			dw_maestro.Reset()
			dw_detalle.Reset()					
			li_registros = dw_maestro.InsertRow(0)
			IF li_registros > 0 THEN
				il_fila_actual_maestro = 1
			ELSE
				MessageBox("Error","Error al insertar fila en el maestro")
				Return
			END IF
			dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_fabrica)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_linea)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_referencia)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_talla", li_talla)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_calidad", li_calidad)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_color_pt", ll_color)			
			dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
			dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
			dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
			dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))			
		END IF		
	END IF
	
END IF
end event

type dw_detalle from w_base_maestroff_detalletb_subdetalletb`dw_detalle within w_administracion_ficha_pt
integer x = 0
integer y = 416
integer width = 2286
integer height = 652
integer taborder = 20
boolean titlebar = false
string dataobject = "dtb_dt_modelos1"
end type

event dw_detalle::rowfocuschanged;call super::rowfocuschanged;Long ll_co_fabrica, ll_co_linea, ll_co_referencia, ll_co_talla
Long ll_co_calidad, ll_co_color, ll_co_modelo
Long li_id_ficha
Double ld_porc_utilizacion

IF il_fila_actual_detalle > 0 THEN
	IF (is_cambios = "no") OR (is_cambios = "si" AND is_accion = "no grabo") THEN
		CHOOSE CASE wf_detectar_cambios (dw_subdetalle)
			CASE -1
				is_cambios = "error"
				is_accion = "nada"
				message.returnvalue = 1
				RETURN 1
			CASE 0
				is_cambios = "no"
				is_accion = "nada"
				// No ejecuta ninguna accion
			CASE 1
				is_cambios = "si"
				CHOOSE CASE MessageBox("Cambios detectados en el Subdetalle...","Desea grabar los cambios del maestro y el subdetalle",Question!,yesnocancel!,1)
					CASE 1
						is_accion = "grabo"
						Parent.TriggerEvent("ue_grabar")
					CASE 2
						is_accion = "no grabo"
						// no graba y se sale
					CASE 3
						is_accion = "cancelo"
						message.returnvalue = 1
						RETURN 1
				END CHOOSE
		END CHOOSE
	ELSE
	END IF
	ll_co_fabrica    = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica")
	ll_co_linea      = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_linea")
	ll_co_referencia = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_referencia")
	ll_co_talla      = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_talla")
   ll_co_calidad    = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_calidad")
	ll_co_color      = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_color_pt")
	ll_co_modelo     = dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_modelo")
	ld_porc_utilizacion = (dw_detalle.GetItemDecimal(il_fila_actual_detalle,"porc_utilizacion"))/100
	
	IF Not IsNull(ll_co_fabrica) AND Not IsNull(ll_co_linea) AND &
		Not IsNull(ll_co_referencia) AND Not IsNull(ll_co_talla) AND &
		Not IsNull(ll_co_calidad) AND Not IsNull(ll_co_color) AND Not IsNull(ll_co_modelo) THEN
		li_id_ficha=Long(dw_maestro.GetitemString(dw_maestro.getrow(),"id_ficha"))							
		dw_subdetalle.Retrieve(ll_co_fabrica,ll_co_linea,ll_co_referencia,ll_co_talla,ll_co_calidad,ll_co_color,ll_co_modelo,li_id_ficha, ld_porc_utilizacion)
	END IF
ELSE
	dw_subdetalle.Reset()
END IF
end event

event dw_detalle::itemchanged;long ll_co_reftel,ll_co_caract, ll_diametro ,ll_cont, ll_ca_partes
decimal ld_area, ld_porc_utilizacion, ld_gramos, ld_ca_grs, ld_ancho
Long fila
Decimal {5} ld_metros

IF dwo.name = "porc_utilizacion" THEN
	IF Dec(data) > 0 THEN
		This.AcceptText()
		ld_porc_utilizacion = (dec(data))/100
		FOR ll_cont = 1 TO dw_subdetalle.Rowcount()
			ld_area = dw_subdetalle.GetItemDecimal(ll_cont,"ca_area")
			ll_diametro = dw_subdetalle.GetItemNumber(ll_cont,"diametro")
			ll_co_reftel = dw_Subdetalle.GetItemNumber(ll_cont,"co_reftel")
			ll_co_caract = dw_Subdetalle.GetItemNumber(ll_cont,"co_caract")
			ll_ca_partes =  dw_Subdetalle.GetItemNumber(ll_cont,"ca_partes")
			IF IsNull(ll_ca_partes) THEN
				ll_ca_partes = 1
			END IF
	   	SELECT h_telas.gr_mt2_terminado
   	 	INTO :ld_gramos  
    		FROM h_telas  
	   	WHERE h_telas.co_reftel = :ll_co_reftel AND
					h_telas.co_caract = :ll_co_caract;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al consultar los gramos de la tela " + SQLCA.SQLErrText)
				Return 2
			ELSE
				IF SQLCA.SQLCode = 100 THEN
					MessageBox("Advertencia...","No se encontr$$HEX2$$f3002000$$ENDHEX$$la tela en la base de datos")
					Return 2
				END IF
			END IF
			IF NOT ISNull(ll_diametro) THEN
				IF NOT ISNull(ld_porc_utilizacion ) THEN
					IF NOT ISNull(ll_co_reftel) THEN
						IF  IsNull(ld_gramos) THEN
							ld_gramos = 0
						END IF
						ld_ca_grs = (((ld_area ) * (ld_gramos) / 10000) / ld_porc_utilizacion) * ll_ca_partes
						dw_subdetalle.SetItem(ll_cont,"ca_grs",ld_ca_grs)
						
						SELECT ancho_abierto_term
						INTO :ld_ancho
						FROM dt_teldiam
						WHERE co_reftel = :ll_co_reftel AND
								co_caract = :ll_co_caract AND
								diametro = :ll_diametro;
						IF SQLCA.SQLCode = -1 THEN
							MessageBox("Error Base Datos","Error al consultar el ancho de la tela " + SQLCA.SQLErrText)
							Return 2
						ELSE
							IF SQLCA.SQLCode = 100 THEN
								MessageBox("Advertencia...","No se encontr$$HEX2$$f3002000$$ENDHEX$$el ancho de la tela")
								Return 2
							ELSE
								IF ld_ancho <> 0 THEN
									ld_metros = ( (ld_area / ld_porc_utilizacion) / ld_ancho ) / 100
								ELSE
									ld_metros = 0
								END IF
								dw_subdetalle.SetItem(ll_cont, "ca_mts", ld_metros)
							END IF
						END IF						
					ELSE
						MessageBox("Error","Debe seleccionar primero la tela antes de ingresar el area")
					END IF
				ELSE
					MessageBox("Error","Debe ingresar primero un porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n en el detalle antes de ingresar el area")
				END IF
			ELSE
				MessageBox("Error","Debe ingresar primero el diametro de la tela antes de ingresar el area")
			END IF
		NEXT
	ELSE
		MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n no puede ser menor o igual a cero")
	END IF
END IF
dw_detalle.SetItem(il_fila_actual_detalle, "usuario", gstr_info_usuario.codigo_usuario)
dw_detalle.SetItem(il_fila_actual_detalle, "instancia", gstr_info_usuario.instancia)
dw_detalle.SetItem(il_fila_actual_detalle, "fe_actualizacion", DateTime(Today(), Now()))
end event

event dw_detalle::updatestart;Long ll_modificados, ll_registros, ll_referencia, ll_reglog, ll_filamodificada
Long ll_modelo, ll_modelonuevo, ll_modeloviejo, ll_regactual, ll_colorpt
Long li_fabrica, li_linea, li_talla, li_calidad
Double ld_porcviejo, ld_porcnuevo, ld_porcentaje
String ls_tabla, ls_operacion, ls_columna, ls_usuario, ls_instancia
String ls_datomodificado, ls_descnuevo, ls_descviejo
DateTime ldt_fecha
DateTime ldt_fecha_log
 

ll_registros = dw_detalle.RowCount()
FOR ll_regactual = 1 TO ll_registros
	IF dw_detalle.GetItemStatus(ll_regactual, 0, Primary!) = NewModified! OR &
		(dw_detalle.GetItemStatus(ll_regactual, 0, Primary!) = DataModified! AND &
		dw_detalle.GetItemStatus(ll_regactual, "porc_utilizacion", Primary!) = DataModified!) THEN
		ld_porcentaje = dw_detalle.GetItemNumber(ll_regactual, "porc_utilizacion")
		IF ld_porcentaje < 0 OR IsNull(ld_porcentaje) THEN
			MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n no puede ser menor o igual a cero")
			Return(1)
		END IF
	END IF
	IF dw_detalle.GetItemStatus(ll_regactual, 0, Primary!) = NewModified! OR &
		(dw_detalle.GetItemStatus(ll_regactual, 0, Primary!) = DataModified! AND &
		dw_detalle.GetItemStatus(ll_regactual, "de_modelo", Primary!) = DataModified!) THEN
		ls_descnuevo = dw_detalle.GetItemString(ll_regactual, "de_modelo")
		li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
		li_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
		ll_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
		li_talla = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla")
		li_calidad = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad")
		ll_colorpt = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt")
		ll_modelo = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_modelo", Primary!, True)				
		SELECT	Count(*)
		INTO		:ll_registros
		FROM		dt_modelos
		WHERE		co_fabrica = :li_fabrica AND
					co_linea = :li_linea AND
					co_referencia = :ll_referencia AND
					co_talla <> :li_talla AND
					co_calidad <> :li_calidad AND
					co_color_pt <> :ll_colorpt AND
					co_modelo = :ll_modelo AND
					de_modelo <> :ls_descnuevo;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al verificar existencia de modelo con diferente nombre")
			Return(1)
		END IF
		IF ll_registros > 1 THEN
			MessageBox("Error","Existen m$$HEX1$$e100$$ENDHEX$$s de dos modelos con descripci$$HEX1$$f300$$ENDHEX$$n diferente")
			Return(1)
		END IF
		SELECT	de_modelo
		INTO		:ls_descviejo
		FROM		dt_modelos
		WHERE		co_fabrica = :li_fabrica AND
					co_linea = :li_linea AND
					co_referencia = :ll_referencia AND
					co_talla <> :li_talla AND
					co_calidad <> :li_calidad AND
					co_color_pt <> :ll_colorpt AND
					co_modelo = :ll_modelo AND
					de_modelo <> :ls_descnuevo;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al verificar existencia de modelo con diferente nombre")
			Return(1)
		ELSE
			IF SQLCA.SQLCode = 0 THEN
				MessageBox("Error","Este modelo tiene la siguiente descripci$$HEX1$$f300$$ENDHEX$$n asociada con otra ficha " + ls_descviejo)
				Return(1)
			END IF
		END IF
	END IF	
NEXT
ls_tabla = 'dt_modelos'
ll_registros = 1
ldt_fecha_log = DateTime(Today(), Now())
ldt_fecha = DateTime(Today(), Now())
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
ll_modificados = dw_detalle.ModifiedCount()
ll_filamodificada = 0
FOR ll_registros = 1 TO ll_modificados
	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	li_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
	ll_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
	li_talla = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla")
	li_calidad = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad")
	ll_colorpt = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt")
	ll_filamodificada = dw_detalle.GetNextModified(ll_filamodificada, Primary!)
	dw_detalle.SetItem(ll_filamodificada, "usuario", ls_usuario)
	dw_detalle.SetItem(ll_filamodificada, "instancia", ls_instancia)
	IF dw_detalle.GetItemStatus(ll_filamodificada, 0, Primary!) = NewModified! THEN
		dw_detalle.SetItem(ll_filamodificada, "fe_creacion", today())
		ls_operacion = 'Creacion'
		ll_modelo = dw_detalle.GetItemNumber(ll_filamodificada, "co_modelo", Primary!, True)		
		ll_reglog = dw_log.InsertRow(0)
		IF ll_reglog = -1 THEN
			MessageBox("Error Datawindow","Error al crear registro de log")
			Return(1)
		END IF
		dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
		dw_log.SetItem(ll_reglog, "co_linea", li_linea)
		dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
		dw_log.SetItem(ll_reglog, "co_talla", li_talla)
		dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
		dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)		
		dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
		dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
		dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
		dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
		dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
		dw_log.SetItem(ll_reglog, "instancia", ls_instancia)
	ELSE
		ls_operacion = 'Modificacion'
		IF dw_detalle.GetItemStatus(ll_filamodificada, "co_modelo", Primary!) = DataModified! THEN 
			ls_datomodificado = 'co_modelo'
			dw_detalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ll_modeloviejo = dw_detalle.GetItemNumber(ll_filamodificada, "co_modelo", Primary!, True)
			ll_modelonuevo = dw_detalle.GetItemNumber(ll_filamodificada, "co_modelo", Primary!, False)					
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modeloviejo)
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(ll_modelonuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(ll_modeloviejo))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_detalle.GetItemStatus(ll_filamodificada, "de_modelo", Primary!) = DataModified! THEN
			ls_datomodificado = 'de_modelo'
			dw_detalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ll_modelo = dw_detalle.GetItemNumber(ll_filamodificada, "co_modelo")
			ls_descviejo = dw_detalle.GetItemString(ll_filamodificada, "de_modelo", Primary!, True)
			ls_descnuevo = dw_detalle.GetItemString(ll_filamodificada, "de_modelo", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", ls_descnuevo)
			dw_log.SetItem(ll_reglog, "valor_viejo", ls_descviejo)
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_detalle.GetItemStatus(ll_filamodificada, "porc_utilizacion", Primary!) = DataModified! THEN
			ls_datomodificado = 'porc_utilizacion'
			dw_detalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ll_modelo = dw_detalle.GetItemNumber(ll_filamodificada, "co_modelo")
			ld_porcviejo = dw_detalle.GetItemNumber(ll_filamodificada, "porc_utilizacion", Primary!, True)
			ld_porcnuevo = dw_detalle.GetItemNumber(ll_filamodificada, "porc_utilizacion", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(ld_porcnuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(ld_porcviejo))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
	END IF
NEXT
end event

event dw_detalle::sqlpreview;String ls_operacion, ls_tabla, ls_usuario, ls_instancia
Long li_fabrica, li_linea, li_talla, li_calidad
Long ll_referencia, ll_reglog, ll_modelo, ll_color
Date ldt_fecha
DateTime ldt_fecha_log

IF sqltype = PreviewDelete! THEN
	ls_operacion = 'Borrado'
	ls_tabla = 'dt_modelos'
	ldt_fecha_log = DateTime(Today(), Now())
	ldt_fecha = Today()
	ls_usuario = gstr_info_usuario.codigo_usuario
	ls_instancia = gstr_info_usuario.instancia
	li_fabrica = dw_detalle.GetItemNumber(row, "co_fabrica", buffer, True)
	li_linea = dw_detalle.GetItemNumber(row, "co_linea", buffer, True)
	ll_referencia = dw_detalle.GetItemNumber(row, "co_referencia", buffer, True)
	li_talla = dw_detalle.GetItemNumber(row, "co_talla", buffer, True)
	li_calidad = dw_detalle.GetItemNumber(row, "co_calidad", buffer, True)
	ll_color = dw_detalle.GetItemNumber(row, "co_color_pt", buffer, True)
	ll_modelo = dw_detalle.GetItemNumber(row, "co_modelo", buffer, True)
	ll_reglog = dw_log.InsertRow(0)
	IF ll_reglog = -1 THEN
		MessageBox("Error Datawindow","Error al crear registro de log")
		Return(1)
	END IF
	dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
	dw_log.SetItem(ll_reglog, "co_linea", li_linea)
	dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
	dw_log.SetItem(ll_reglog, "co_talla", li_talla)
	dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
	dw_log.SetItem(ll_reglog, "co_color_pt", ll_color)
	dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)	
	dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
	dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
	dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
	dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
	dw_log.SetItem(ll_reglog, "instancia", ls_instancia)
END IF
end event

event constructor;ib_insercion_automatica = True
end event

type dw_subdetalle from w_base_maestroff_detalletb_subdetalletb`dw_subdetalle within w_administracion_ficha_pt
integer x = 0
integer y = 1096
integer width = 4197
integer height = 604
integer taborder = 30
boolean titlebar = false
string dataobject = "dtb_dt_color_modelo1_copia"
boolean hscrollbar = false
boolean hsplitscroll = false
end type

event dw_subdetalle::updatestart;Long ll_modificados, ll_registros, ll_referencia, ll_reglog, ll_filamodificada
Long ll_modelo, ll_reftel, ll_reftelnuevo, ll_filas, ll_fila_actual, ll_colorpt
Long li_fabrica, li_linea, li_talla, li_calidad
Long li_caract, li_diametro, li_coparte, li_partes, li_datonuevo, li_datoviejo
Long li_repite, li_comprada
Double ld_colorte, ld_caarea, ld_cagrs, ld_doublenuevo, ld_doubleviejo
String ls_tabla, ls_operacion, ls_columna, ls_usuario, ls_instancia
String ls_datomodificado, ls_descnuevo, ls_descviejo
DateTime ldt_fecha
DateTime ldt_fecha_log
 

ll_filas = dw_subdetalle.RowCount()
FOR ll_fila_actual = 1 TO ll_filas
	IF dw_subdetalle.GetItemStatus(ll_fila_actual, 0, Primary!) = NewModified! OR &
		(dw_subdetalle.GetItemStatus(ll_fila_actual, 0, Primary!) = DataModified! AND &
		(dw_subdetalle.GetItemStatus(ll_fila_actual, "co_reftel", Primary!) = DataModified! OR &
		dw_subdetalle.GetItemStatus(ll_fila_actual, "co_caract", Primary!) = DataModified! OR &
		dw_subdetalle.GetItemStatus(ll_fila_actual, "diametro", Primary!) = DataModified! OR &
		dw_subdetalle.GetItemStatus(ll_fila_actual, "co_color_te", Primary!) = DataModified! OR &
		dw_subdetalle.GetItemStatus(ll_fila_actual, "co_repite", Primary!) = DataModified!)) THEN
		li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
		ll_reftel = dw_subdetalle.GetItemNumber(ll_fila_actual, "co_reftel")
		li_caract = dw_subdetalle.GetItemNumber(ll_fila_actual, "co_caract")
		li_diametro = dw_subdetalle.GetItemNumber(ll_fila_actual, "diametro")
		ld_colorte = dw_subdetalle.GetItemNumber(ll_fila_actual, "co_color_te")
		li_repite = dw_subdetalle.GetItemNumber(ll_fila_actual, "co_repite")
		
// Si la tela es comprada no se valida contra la ficha

		SELECT	sw_comprada
		INTO		:li_comprada
		FROM		h_telas
		WHERE		co_reftel = :ll_reftel AND
					co_caract = :li_caract;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al consultar si la tela es comprada " + SQLCA.SQLErrText)
			Return 1
		END IF
		SELECT	Count(*)
		INTO		:ll_registros
		FROM		dt_telcolo
		WHERE		co_reftel = :ll_reftel AND
					co_caract = :li_caract AND
					diametro = :li_diametro AND
					co_color = :ld_colorte;
//co_fabrica = :li_fabrica AND
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al validar la existencia de la tela")
			Return(1)
		ELSE
			IF ll_registros = 0 THEN
				MessageBox("Error Base Datos","La tela no existe en la base de datos")
				dw_subdetalle.SetColumn("co_reftel")
				dw_subdetalle.SetRow(ll_fila_actual)
				Return(1)
			ELSE
				IF li_comprada = 0 OR IsNull(li_comprada) THEN				
					SELECT	Count(*)
					INTO		:ll_registros
					FROM		h_ficha_mp
					WHERE		co_reftel = :ll_reftel AND
								co_caract = :li_caract AND
								co_color = :ld_colorte AND
								co_repite = :li_repite;
					IF SQLCA.SQLCode = -1 THEN
						MessageBox("Error Base Datos","Error al validar la existencia de la ficha")
						Return(1)
					ELSE
						IF ll_registros = 0 THEN
							MessageBox("Error Base Datos","No existe ficha para esta tela en la base de datos")
							dw_subdetalle.SetColumn("co_reftel")
							dw_subdetalle.SetRow(ll_fila_actual)
							Return(1)
						END IF
					END IF
				END IF
			END IF
		END IF
	END IF
NEXT
ls_tabla = 'dt_color_modelo'
ll_registros = 1
ldt_fecha_log = DateTime(Today(), Now())
ldt_fecha = DateTime(Today(), Now())
ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
ll_modificados = dw_subdetalle.ModifiedCount()
ll_filamodificada = 0
FOR ll_registros = 1 TO ll_modificados
	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	li_linea = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_linea")
	ll_referencia = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_referencia")
	li_talla = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_talla")
	li_calidad = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_calidad")
	ll_colorpt = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_color_pt")
	ll_filamodificada = dw_subdetalle.GetNextModified(ll_filamodificada, Primary!)
	dw_subdetalle.SetItem(ll_filamodificada, "usuario", ls_usuario)
	dw_subdetalle.SetItem(ll_filamodificada, "instancia", ls_instancia)
	ll_modelo = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_modelo")	
	ll_reftel = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_reftel", Primary!, True)
	li_caract = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_caract", Primary!, True)
	li_diametro = dw_subdetalle.GetItemNumber(ll_filamodificada, "diametro", Primary!, True)
	ld_colorte = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_color_te", Primary!, True)
	li_coparte = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_parte", Primary!, True)
	li_repite = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_repite", Primary!, True)
	IF dw_subdetalle.GetItemStatus(ll_filamodificada, 0, Primary!) = NewModified! THEN
		dw_subdetalle.SetItem(ll_filamodificada, "fe_creacion", Today())
		ls_operacion = 'Creacion'
		ll_reglog = dw_log.InsertRow(0)
		IF ll_reglog = -1 THEN
			MessageBox("Error Datawindow","Error al crear registro de log")
			Return(1)
		END IF
		dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
		dw_log.SetItem(ll_reglog, "co_linea", li_linea)
		dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
		dw_log.SetItem(ll_reglog, "co_talla", li_talla)
		dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
		dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)		
		dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
		dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
		dw_log.SetItem(ll_reglog, "co_caract", li_caract)
		dw_log.SetItem(ll_reglog, "diametro", li_diametro)
		dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
		dw_log.SetItem(ll_reglog, "co_repite", li_repite)
		dw_log.SetItem(ll_reglog, "co_parte", li_coparte)
		dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
		dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
		dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
		dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
		dw_log.SetItem(ll_reglog, "instancia", ls_instancia)
	ELSE
		ls_operacion = 'Modificacion'
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "co_reftel", Primary!) = DataModified! THEN 
			ls_datomodificado = 'co_reftel'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ll_reftelnuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_reftel", Primary!, False)					
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(ll_reftelnuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(ll_reftel))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "co_caract", Primary!) = DataModified! THEN
			ls_datomodificado = 'co_caract'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			li_datonuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_caract", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(li_caract))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(li_datonuevo))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "diametro", Primary!) = DataModified! THEN
			ls_datomodificado = 'diametro'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			li_datonuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "diametro", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(li_datonuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(li_diametro))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "co_color_te", Primary!) = DataModified! THEN
			ls_datomodificado = 'co_color_te'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ld_doublenuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_color_te", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(ld_doublenuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(ld_colorte))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "co_parte", Primary!) = DataModified! THEN
			ls_datomodificado = 'co_parte'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			li_datonuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_parte", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(li_datonuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(li_coparte))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "co_repite", Primary!) = DataModified! THEN
			ls_datomodificado = 'co_repite'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			li_datonuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "co_repite", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(li_datonuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(li_repite))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF		
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "ca_partes", Primary!) = DataModified! THEN
			ls_datomodificado = 'ca_partes'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			li_datoviejo = dw_subdetalle.GetItemNumber(ll_filamodificada, "ca_partes", Primary!, True)
			li_datonuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "ca_partes", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(li_datonuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(li_datoviejo))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "ca_area", Primary!) = DataModified! THEN
			ls_datomodificado = 'ca_area'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ld_doubleviejo = dw_subdetalle.GetItemNumber(ll_filamodificada, "ca_area", Primary!, True)
			ld_doublenuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "ca_area", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(ld_doublenuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(ld_doubleviejo))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF		
		IF dw_subdetalle.GetItemStatus(ll_filamodificada, "ca_grs", Primary!) = DataModified! THEN
			ls_datomodificado = 'ca_grs'
			dw_subdetalle.SetItem(ll_filamodificada, "fe_actualizacion", ldt_fecha)
			ld_doubleviejo = dw_subdetalle.GetItemNumber(ll_filamodificada, "ca_grs", Primary!, True)
			ld_doublenuevo = dw_subdetalle.GetItemNumber(ll_filamodificada, "ca_grs", Primary!, False)
			ll_reglog = dw_log.InsertRow(0)
			IF ll_reglog = -1 THEN
				MessageBox("Error Datawindow","Error al crear registro de log")
				Return(1)
			END IF
			dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
			dw_log.SetItem(ll_reglog, "co_linea", li_linea)
			dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
			dw_log.SetItem(ll_reglog, "co_talla", li_talla)
			dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
			dw_log.SetItem(ll_reglog, "co_color_pt", ll_colorpt)
			dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)
			dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)
			dw_log.SetItem(ll_reglog, "co_caract", li_caract)
			dw_log.SetItem(ll_reglog, "diametro", li_diametro)
			dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)
			dw_log.SetItem(ll_reglog, "co_repite", li_repite)			
			dw_log.SetItem(ll_reglog, "co_parte", li_coparte)			
			dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
			dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
			dw_log.SetItem(ll_reglog, "columna", ls_datomodificado)
			dw_log.SetItem(ll_reglog, "valor_nuevo", String(ld_doublenuevo))
			dw_log.SetItem(ll_reglog, "valor_viejo", String(ld_doubleviejo))
			dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
			dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
			dw_log.SetItem(ll_reglog, "instancia", ls_instancia)		
		END IF		
	END IF
NEXT
end event

event dw_subdetalle::sqlpreview;String ls_operacion, ls_tabla, ls_usuario, ls_instancia
Long li_fabrica, li_linea, li_talla, li_calidad
Long li_caract, li_diametro, li_parte
Long ll_referencia, ll_reglog, ll_modelo, ll_reftel, ll_color
Double ld_colorte
Date ldt_fecha
DateTime ldt_fecha_log

IF sqltype = PreviewDelete! THEN
	ls_operacion = 'Borrado'
	ls_tabla = 'dt_color_modelo'
	ldt_fecha_log = DateTime(Today(), Now())
	ldt_fecha = Today()
	ls_usuario = gstr_info_usuario.codigo_usuario
	ls_instancia = gstr_info_usuario.instancia
	li_fabrica = dw_subdetalle.GetItemNumber(row, "co_fabrica", buffer, True)
	li_linea = dw_subdetalle.GetItemNumber(row, "co_linea", buffer, True)
	ll_referencia = dw_subdetalle.GetItemNumber(row, "co_referencia", buffer, True)
	li_talla = dw_subdetalle.GetItemNumber(row, "co_talla", buffer, True)
	li_calidad = dw_subdetalle.GetItemNumber(row, "co_calidad", buffer, True)
	ll_color = dw_subdetalle.GetItemNumber(row, "co_color_pt", buffer, True)
	ll_modelo = dw_subdetalle.GetItemNumber(row, "co_modelo", buffer, True)
	ll_reftel = dw_subdetalle.GetItemNumber(row, "co_reftel", buffer, True)
	li_caract = dw_subdetalle.GetItemNumber(row, "co_caract", buffer, True)
	li_diametro = dw_subdetalle.GetItemNumber(row, "diametro", buffer, True)
	li_parte = dw_subdetalle.GetItemNumber(row, "co_parte", buffer, True)
	ld_colorte = dw_subdetalle.GetItemNumber(row, "co_color_te", buffer, True)
	ll_reglog = dw_log.InsertRow(0)
	IF ll_reglog = -1 THEN
		MessageBox("Error Datawindow","Error al crear registro de log")
		Return(1)
	END IF
	dw_log.SetItem(ll_reglog, "co_fabrica", li_fabrica)
	dw_log.SetItem(ll_reglog, "co_linea", li_linea)
	dw_log.SetItem(ll_reglog, "co_referencia", ll_referencia)
	dw_log.SetItem(ll_reglog, "co_talla", li_talla)
	dw_log.SetItem(ll_reglog, "co_calidad", li_calidad)
	dw_log.SetItem(ll_reglog, "co_color_pt", ll_color)
	dw_log.SetItem(ll_reglog, "co_modelo", ll_modelo)	
	dw_log.SetItem(ll_reglog, "co_reftel", ll_reftel)	
	dw_log.SetItem(ll_reglog, "co_caract", li_caract)		
	dw_log.SetItem(ll_reglog, "diametro", li_diametro)		
	dw_log.SetItem(ll_reglog, "co_parte", li_parte)		
	dw_log.SetItem(ll_reglog, "co_color_te", ld_colorte)		
	dw_log.SetItem(ll_reglog, "operacion", ls_operacion)
	dw_log.SetItem(ll_reglog, "tabla", ls_tabla)
	dw_log.SetItem(ll_reglog, "fe_modificacion", ldt_fecha_log)
	dw_log.SetItem(ll_reglog, "usuario", ls_usuario)
	dw_log.SetItem(ll_reglog, "instancia", ls_instancia)
END IF
end event

event dw_subdetalle::constructor;ib_insercion_automatica = True
end event

event dw_subdetalle::itemchanged;long ll_co_reftel, ll_diametro, ll_ca_partes, ll_co_reftel_sust, ll_reg_sust
Long ll_co_fabrica, ll_color
Long li_caract, li_diametro, li_repite, li_comprada, li_registros, li_terminado
Long li_respuesta, li_rectilineo, li_h_telas, li_compra
Double ld_area, ld_porc_utilizacion, ld_gramos, ld_ca_grs, ld_ancho
Decimal{5} ld_metros

String ls_de_reftel, ls_de_reftel_sust
Long li_tiptel, li_reftel 

Datastore lds_h_telas
lds_h_telas = Create DataStore

lds_h_telas.DataObject = 'dgr_h_telas'

IF lds_h_telas.SetTransObject(SQLCA) = -1 THEN
	Messagebox("Error", "Ocurrio un error definir el objeto lds_h_telas")
	Return 1
END IF

	dw_subdetalle.AcceptText()
	ld_porc_utilizacion = (dw_detalle.GetItemDecimal(il_fila_actual_detalle,"porc_utilizacion"))/100
	ll_co_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	ll_co_reftel = This.GetItemNumber(il_fila_actual_subdetalle, "co_reftel")
	ll_co_reftel_sust = This.GetItemNumber(il_fila_actual_subdetalle, "co_reftel_sustituto")
	li_caract = This.GetItemNumber(il_fila_actual_subdetalle, "co_caract")
	ll_diametro = This.GetItemNumber(This.GetRow(),"diametro")
	ll_ca_partes = This.GetItemNumber(il_fila_actual_subdetalle,"ca_partes")
	
	IF IsNull(ll_ca_partes) THEN
		ll_ca_partes = 1
	END IF
	If Not IsNull(ll_co_reftel) AND Not IsNull(li_caract) AND Not IsNull(ll_diametro)Then
		  If lds_h_telas.retrieve(ll_co_reftel,li_caract) > 0 Then
				ld_ancho			= lds_h_telas.GetitemNumber(1,"dt_telrecurso_ancho_term")
				li_terminado	= lds_h_telas.GetitemNumber(1,"h_telas_co_terminado")	
				ld_gramos		= lds_h_telas.GetitemNumber(1,"h_telas_gr_mt2_terminado")
				li_rectilineo	= lds_h_telas.GetitemNumber(1,"h_telas_id_tipo_rect")
				li_compra		= lds_h_telas.GetitemNumber(1,"h_telas_sw_comprada")
			ELSE
					MessageBox("Error","El c$$HEX1$$f300$$ENDHEX$$digo de la tela no existe en la base de datos")
					Return 1
					
			END IF
			If li_compra = 1 Then
				li_terminado = 1
			End If 
			
			If Not IsNull(li_rectilineo) Then
				ld_ancho =0
			Else
				If IsNull(ld_ancho) Then
					MessageBox("Advertencia","No existe el ancho para la tela " + String(ll_co_reftel))
					Return -2
				End If 
				If IsNull(li_terminado) Then
					MessageBox("Advertencia","No existe el terminado para la tela " + String(ll_co_reftel))
					Return -2
				End If 
			End If 
			
			If IsNull(ld_gramos) Then
				MessageBox("Advertencia","No existen los gramos mt2 para la tela " + String(ll_co_reftel))
				Return	
			End If 
	End If


If dwo.name = "co_reftel_sustituto" Then 
	ll_co_reftel_sust = Long(data)
	Select distinct co_reftel, de_reftel 
	into :ll_reg_sust, :ls_de_reftel_sust 
	from h_telas 
	where co_reftel = :ll_co_reftel_sust;
	If isnull(ll_reg_sust) OR ll_reg_sust = 0 Then
		MessageBox("Error","El c$$HEX1$$f300$$ENDHEX$$digo de la tela sustituta no existe en la base de datos")
		Return 1
	Else 
		This.Setitem(this.getrow(),"de_reftel",ls_de_reftel_sust)
	End If 
End If 

IF Dwo.Name = "ca_area" THEN
	ld_area = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_area")
	IF Not IsNull(ld_porc_utilizacion) AND Not IsNull(ll_co_reftel) THEN

				ld_ca_grs = (((ld_area * ld_gramos) / 10000) / ld_porc_utilizacion) * ll_ca_partes
				This.SetItem(il_fila_actual_subdetalle, "ca_grs", ld_ca_grs)

				IF ld_ancho <> 0 THEN
					ld_metros = ( ( (ld_area / ld_porc_utilizacion) / (ld_ancho * 100 * li_terminado) ) / 100) * ll_ca_partes
				ELSE
					ld_metros = 0
				END IF
				This.SetItem(il_fila_actual_subdetalle, "ca_mts", ld_metros)				

	ELSE
		MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n o el c$$HEX1$$f300$$ENDHEX$$digo de la tela es nulo")
	END IF
END IF

IF Dwo.Name = "ca_grs" THEN
	ld_ca_grs = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_grs")
	IF Not IsNull(ld_porc_utilizacion) AND Not IsNull(ll_co_reftel) THEN	

				IF ld_gramos > 0 THEN
				   ld_area = (((ld_ca_grs ) * (ld_porc_utilizacion ) * 10000) / ld_gramos) *ll_ca_partes
				   This.SetItem(il_fila_actual_subdetalle, "ca_area", ld_area)
				ELSE
					MessageBox("Error","Los gramos de la tela est$$HEX1$$e100$$ENDHEX$$n en cero")
				END IF

	ELSE
		MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n o el c$$HEX1$$f300$$ENDHEX$$digo de la tela es nulo")		
	END IF
END IF
IF Dwo.Name = "ca_partes" THEN
	ld_area = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_area")
	ld_ca_grs = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_grs")	
	IF Not IsNull(ld_porc_utilizacion) AND Not IsNull(ll_co_reftel) THEN

				IF ld_gramos > 0 THEN
					IF Not IsNull(ld_area) THEN
						ld_ca_grs = (((ld_area * ld_gramos) / 10000) / ld_porc_utilizacion) * ll_ca_partes
						This.SetItem(il_fila_actual_subdetalle, "ca_grs", ld_ca_grs)					
					ELSE
						IF Not IsNull(ld_ca_grs) THEN
							ld_area = (((ld_ca_grs ) * (ld_porc_utilizacion ) * 10000) / ld_gramos) *ll_ca_partes				
							This.SetItem(il_fila_actual_subdetalle, "ca_area", ld_area)						
						END IF
					END IF
				ELSE
					MessageBox("Error","Los gramos de la tela est$$HEX1$$e100$$ENDHEX$$n en cero")					
				END IF

	ELSE
		MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n o el c$$HEX1$$f300$$ENDHEX$$digo de la tela es nulo")
	END IF
END IF

IF Dwo.Name = "co_reftel" THEN
	IF Not Isnull(ll_co_reftel) AND Not IsNull(li_caract) THEN
		ld_area = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_area")
		IF ld_area > 0 THEN
			IF Not IsNull(ld_area) THEN
				ld_ca_grs = (((ld_area * ld_gramos) / 10000) / ld_porc_utilizacion) * ll_ca_partes
				This.SetItem(il_fila_actual_subdetalle, "ca_grs", ld_ca_grs)
			END IF
			IF Not IsNull(li_caract) AND Not IsNull(ll_diametro) THEN
				IF ld_ancho <> 0 THEN
					ld_metros = ( (ld_area / ld_porc_utilizacion) / (ld_ancho *100 * li_terminado) ) / 100
				ELSE
					ld_metros = 0
				END IF
			END IF
		ELSE
			ld_ca_grs = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_grs")
			IF Not IsNull(ld_porc_utilizacion) AND Not IsNull(ll_co_reftel) AND &
				Not IsNull(li_caract) THEN	
		
						IF ld_gramos > 0 THEN
						   ld_area = (((ld_ca_grs ) * (ld_porc_utilizacion ) * 10000) / ld_gramos) *ll_ca_partes
						   This.SetItem(il_fila_actual_subdetalle, "ca_area", ld_area)
						ELSE
							MessageBox("Error","Los gramos de la tela est$$HEX1$$e100$$ENDHEX$$n en cero")
						END IF

			ELSE
				MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n o el c$$HEX1$$f300$$ENDHEX$$digo de la tela es nulo")		
			END IF			
		END IF
	END IF
END IF

IF Dwo.Name = "co_caract" THEN
	ld_area = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_area")
	IF ld_area > 0 THEN
		IF Not IsNull(ld_area) THEN

					ld_ca_grs = (((ld_area * ld_gramos) / 10000) / ld_porc_utilizacion) * ll_ca_partes
					This.SetItem(il_fila_actual_subdetalle, "ca_grs", ld_ca_grs)

		END IF
		IF Not IsNull(li_caract) AND Not IsNull(ll_diametro) THEN

					IF ld_ancho <> 0 THEN
						ld_metros = ( (ld_area / ld_porc_utilizacion) / (ld_ancho *100 * li_terminado) ) / 100
					ELSE
						ld_metros = 0
					END IF
					This.SetItem(il_fila_actual_subdetalle, "ca_mts", ld_metros)				
			
		END IF		
	ELSE
		ld_ca_grs = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_grs")
		IF Not IsNull(ld_porc_utilizacion) AND Not IsNull(ll_co_reftel) AND &
			Not IsNull(li_caract) THEN	

					IF ld_gramos > 0 THEN
					   ld_area = (((ld_ca_grs ) * (ld_porc_utilizacion ) * 10000) / ld_gramos) *ll_ca_partes
					   This.SetItem(il_fila_actual_subdetalle, "ca_area", ld_area)
					ELSE
						MessageBox("Error","Los gramos de la tela est$$HEX1$$e100$$ENDHEX$$n en cero")
					END IF

		ELSE
			MessageBox("Error","El porcentaje de utilizaci$$HEX1$$f300$$ENDHEX$$n o el c$$HEX1$$f300$$ENDHEX$$digo de la tela es nulo")		
		END IF					
	END IF
END IF
IF Dwo.Name = "diametro" THEN
	IF Not Isnull(ll_co_reftel) AND Not IsNull(li_caract) AND Not IsNull(ll_diametro) THEN
		ld_area = dw_subdetalle.GetItemDecimal(il_fila_actual_subdetalle, "ca_area")
		IF ld_area > 0 THEN
			IF Not IsNull(li_caract) AND Not IsNull(ll_diametro) THEN

						IF ld_ancho <> 0 THEN
							ld_metros = ( (ld_area / ld_porc_utilizacion) / (ld_ancho *100 * li_terminado) ) / 100
						ELSE
							ld_metros = 0
						END IF
						This.SetItem(il_fila_actual_subdetalle, "ca_mts", ld_metros)				
		
			END IF
		END IF
	END IF
END IF

IF Dwo.Name = "co_color_te" THEN
	ll_color = This.GetItemNumber(il_fila_actual_subdetalle, "co_color_te")
	SELECT Count(*)
	INTO	:li_registros
	FROM	h_telas
	WHERE	h_telas.co_reftel = :ll_co_reftel AND
			h_telas.co_caract = :li_caract;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar en el maestro de telas")
		Return
	END IF
	IF li_registros = 0 THEN
		MessageBox("Error","Referencia de tela no existe en la base de datos")
		Return

	END IF
END IF

IF Dwo.Name = "co_repite" THEN
	ll_color = dw_subdetalle.GetItemNumber(Row, "co_color_te")
	li_repite = dw_subdetalle.GetItemNumber(Row, "co_repite")
	SELECT	sw_comprada
	INTO		:li_comprada
	FROM		h_telas
	WHERE		h_telas.co_reftel = :ll_co_reftel AND
				h_telas.co_caract = :li_caract;
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al verificar si la tela es comprada")
		dw_subdetalle.SetColumn("co_repite")
		Return
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			MessageBox("Error","La tela no existe en la base de datos")
			dw_subdetalle.SetColumn("co_reftel")
			Return
		ELSE
			IF li_comprada = 0 OR IsNull(li_comprada) THEN
				SELECT	Count(*)
				INTO		:li_registros
				FROM		h_ficha_mp
				WHERE		h_ficha_mp.co_reftel = :ll_co_reftel AND
							h_ficha_mp.co_caract = :li_caract AND
							h_ficha_mp.co_color = :ll_color AND
							h_ficha_mp.co_repite = :li_repite;
							
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al verificar existencia de ficha de tela")
					dw_subdetalle.SetColumn("co_repite")
					Return
				ELSE
					IF li_registros = 0 THEN
						li_respuesta = MessageBox("Error","No existe ficha de tela para esta referencia")

					END IF
				END IF
			END IF
		END IF
	END IF
END IF

dw_subdetalle.SetItem(il_fila_actual_subdetalle, "usuario", gstr_info_usuario.codigo_usuario)
dw_subdetalle.SetItem(il_fila_actual_subdetalle, "instancia", gstr_info_usuario.instancia)
dw_subdetalle.SetItem(il_fila_actual_subdetalle, "fe_actualizacion", DateTime(Today(), Now()))
end event

event dw_subdetalle::ue_presionar_tecla;Long li_columnas, li_num_col, li_sigte_col
Long ll_filas, ll_fila_actual

IF Key = KeyEnter! THEN
	li_columnas = Long(This.Object.DataWindow.Column.Count)
	li_num_col = This.GetColumn()
	IF li_columnas = li_num_col THEN
		IF ib_insercion_automatica THEN
			ll_filas = This.RowCount()
			ll_fila_actual = This.GetRow()
			IF ll_filas = ll_fila_actual THEN
				Parent.TriggerEvent("ue_insertar_subdetalle")
			ELSE
				This.SetRow(ll_fila_actual + 1)
			END IF
			li_sigte_col = 1
			DO WHILE This.SetColumn(li_sigte_col) = -1 AND li_sigte_col <= li_columnas
				li_sigte_col = li_sigte_col + 1
			LOOP
		END IF
	ELSE
		li_sigte_col = This.GetColumn() + 1
		DO WHILE This.SetColumn(li_sigte_col) = -1 AND li_sigte_col <= li_columnas
			li_sigte_col = li_sigte_col + 1
		LOOP
	END IF
	Return(1)
END IF
end event

event dw_subdetalle::itemfocuschanged;call super::itemfocuschanged;Long li_fabrica, li_caract, li_repite, li_comprada
Long li_diametro, li_registros, li_respuesta
Long ll_reftel, ll_color
s_base_parametros lstr_parametros

IF Dwo.Name = "co_parte" THEN
	f_rcpra_dtos_dddw(dw_subdetalle, "co_parte", SQLCA)
END IF


// Se puso en comentario esta parte del script y se paso para el itemchanged, debido
// a un error que se estaba presentando al insertar un registro por el evento
// ue_presionar_tecla

//IF Dwo.Name = "ca_area" OR Dwo.Name = "ca_grs" THEN
//	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
//	ll_reftel = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_reftel")
//	li_caract = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_caract")
//	ll_color = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_color_te")
//	li_repite = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_repite")
//	SELECT	sw_comprada
//	INTO		:li_comprada
//	FROM		h_telas
//	WHERE		h_telas.co_reftel = :ll_reftel AND
//				h_telas.co_caract = :li_caract;
//	
//	IF SQLCA.SQLCode = -1 THEN
//		MessageBox("Error Base Datos","Error al verificar si la tela es comprada")
//		dw_subdetalle.SetColumn("co_repite")
//		Return
//	ELSE
//		IF SQLCA.SQLCode = 100 THEN
//			MessageBox("Error","La tela no existe en la base de datos")
//			dw_subdetalle.SetColumn("co_reftel")
//			Return
//		ELSE
//			IF li_comprada = 0 OR IsNull(li_comprada) THEN
//				SELECT	Count(*)
//				INTO		:li_registros
//				FROM		h_ficha_mp
//				WHERE		h_ficha_mp.co_fabrica = :li_fabrica AND
//							h_ficha_mp.co_reftel = :ll_reftel AND
//							h_ficha_mp.co_caract = :li_caract AND
//							h_ficha_mp.co_color = :ll_color AND
//							h_ficha_mp.co_repite = :li_repite;
//							
//				IF SQLCA.SQLCode = -1 THEN
//					MessageBox("Error Base Datos","Error al verificar existencia de ficha de tela")
//					dw_subdetalle.SetColumn("co_repite")
//					Return
//				ELSE
//					IF li_registros = 0 THEN
//						li_respuesta = MessageBox("Error","No existe ficha de tela para esta referencia, " + &
//														"desea crear encabezado de tela", Question!, YesNo!)
//						IF li_respuesta = 1 THEN
//							SELECT	Max(diametro)
//							INTO		:li_diametro
//							FROM		dt_teldiam
//							WHERE		dt_teldiam.co_fabrica = :li_fabrica AND
//										dt_teldiam.co_reftel = :ll_reftel AND
//										dt_teldiam.co_caract = :li_caract;
//							IF SQLCA.SQLCode = -1 THEN
//								MessageBox("Error Base Datos","Error al consultar diametro para crear encabezado")
//								dw_subdetalle.SetColumn("co_repite")							
//								Return
//							END IF
//							INSERT INTO h_ficha_mp(co_fabrica, co_reftel, co_caract, co_color,
//															co_repite, diametro, id_peso, fe_actualizacion,
//															usuario, instancia)
//												VALUES(:li_fabrica, :ll_reftel, :li_caract, :ll_color,
//															:li_repite, :li_diametro, 'A', Current, 
//															:gstr_info_usuario.codigo_usuario,
//															:gstr_info_usuario.instancia);
//							IF SQLCA.SQLCode = -1 THEN
//								MessageBox("Error Base Datos","Error al insertar registro de ficha de tela")
//								dw_subdetalle.SetColumn("co_repite")							
//								Return
//							END IF
//						ELSE
//							dw_subdetalle.SetColumn("co_repite")							
//							Return
//						END IF
//					END IF
//				END IF
//			END IF
//		END IF
//	END IF
//END IF
IF Dwo.Name = "co_repite" THEN
	li_fabrica = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_fabrica")
	ll_reftel = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_reftel")
	li_caract = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_caract")
	ll_color = dw_subdetalle.GetItemNumber(il_fila_actual_subdetalle, "co_color_te")
// Todas las telas estan creadas como f$$HEX1$$e100$$ENDHEX$$brica 2. 
	lstr_parametros.entero[1] = 2
	lstr_parametros.entero[2] = ll_reftel
	lstr_parametros.entero[3] = li_caract
	lstr_parametros.entero[4] = ll_color
	//OpenWithParm(w_consulta_repites_ficha, lstr_parametros)
	lstr_parametros = Message.PowerObjectParm
	IF lstr_parametros.hay_parametros THEN
		dw_subdetalle.SetItem(Row, "co_repite", lstr_parametros.entero[1])
		dw_subdetalle.SetColumn("ca_area")
	END IF
END IF
end event

event dw_subdetalle::doubleclicked;call super::doubleclicked;Long ll_co_reftel
s_base_parametros lstr_parametros

IF dwo.name="dt_color_modelo_co_color_te_sustituto" THEN
	ll_co_reftel = this.GetitemNumber(row,"co_reftel_sustituto") 
		IF IsNull(ll_co_reftel) OR ll_co_reftel = 0 THEN
			Messagebox("Advertencia","Debe primero hacer la asiganacion de la tela sustituta")
			Return
		END IF 
		lstr_parametros.entero[1] = ll_co_reftel
		lstr_parametros.entero[2] = 2
//		OpenWithParm(w_seleccionar_color, lstr_parametros)
		lstr_parametros = Message.PowerObjectParm
		IF lstr_parametros.hay_parametros=True THEN
			This.SetItem(Row,"dt_color_modelo_co_color_te_sustituto", lstr_parametros.entero[1])
			This.SetColumn("ca_area")
		ELSE
			This.SetItem(Row,"dt_color_modelo_co_color_te_sustituto", 0)
			This.SetColumn("ca_area")
		END IF
END IF 
end event

type dw_log from datawindow within w_administracion_ficha_pt
boolean visible = false
integer x = 1321
integer y = 1476
integer width = 146
integer height = 92
integer taborder = 40
boolean bringtotop = true
string dataobject = "dtb_invisible_m_log_ficha"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event updatestart;Long ll_registros, ll_clave, ll_filas, ll_filaactual
String ls_ventana

ll_registros = 0
SELECT	Count(*)
INTO		:ll_registros
FROM 		m_log_ficha;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al asignar clave del log")
	Return(1)
END IF

IF ll_registros = 0 THEN
	ll_clave = 1
ELSE
	SELECT	Max(co_movimiento) + 1
	INTO		:ll_clave
	FROM		m_log_ficha;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al asignar clave del log")
		Return(1)
	END IF
END IF
ll_filas = dw_log.RowCount()
il_inicial = ll_clave
FOR ll_filaactual = 1 TO ll_filas
	dw_log.SetItem(ll_filaactual, "co_movimiento", ll_clave)
	ll_clave = ll_clave + 1
NEXT
il_final = ll_clave - 1
end event

event updateend;dw_log.Reset()
end event

type p_grafico from picture within w_administracion_ficha_pt
integer x = 2811
integer y = 12
integer width = 919
integer height = 1048
boolean bringtotop = true
boolean border = true
boolean focusrectangle = false
end type

