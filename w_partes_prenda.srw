HA$PBExportHeader$w_partes_prenda.srw
forward
global type w_partes_prenda from w_base_maestroff_detalletb
end type
end forward

global type w_partes_prenda from w_base_maestroff_detalletb
integer width = 1833
integer height = 1500
string title = "Partes por Prenda"
string menuname = "m_mantenimiento_partesxprenda"
end type
global w_partes_prenda w_partes_prenda

on w_partes_prenda.create
call super::create
if this.MenuName = "m_mantenimiento_partesxprenda" then this.MenuID = create m_mantenimiento_partesxprenda
end on

on w_partes_prenda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;This.width = 1833
This.height =1500 
end event

event ue_buscar;call super::ue_buscar;s_base_parametros lstr_parametros
long ll_hallados,ll_co_referencia
Long li_co_fabrica,li_co_linea
string	ls_de_linea,ls_de_referencia


IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_buscar_estilos)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		li_co_fabrica=lstr_parametros.entero[1]
		li_co_linea=lstr_parametros.entero[2]
		ll_co_referencia=lstr_parametros.entero[3]
		ls_de_linea=lstr_parametros.cadena[1]
		ls_de_referencia=lstr_parametros.cadena[2]

		ll_hallados = dw_maestro.Retrieve(li_co_fabrica,li_co_linea,ll_co_referencia)
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
					this.triggerevent("ue_insertar_maestro")
					dw_maestro.SetItem(il_fila_actual_maestro, "co_fabrica", li_co_fabrica)
					dw_maestro.SetItem(il_fila_actual_maestro, "co_linea", li_co_linea)
					dw_maestro.SetItem(il_fila_actual_maestro, "co_referencia", ll_co_referencia)
					dw_maestro.SetItem(il_fila_actual_maestro, "de_linea", ls_de_linea)
					dw_maestro.SetItem(il_fila_actual_maestro, "de_referencia", ls_de_referencia)
					dw_maestro.accepttext()
				CASE ELSE
					il_fila_actual_maestro = 1
//					MessageBox("Busqueda ok","registros encontrados: "+&
//             	String(ll_hallados),Information!,Ok!)
					dw_detalle.Retrieve(li_co_fabrica,li_co_linea,ll_co_referencia)
			END CHOOSE
		END IF
	ELSE
	END IF
ELSE
END IF



		
end event

event ue_insertar_maestro;///////////////////////////////////////////////////////////////////////
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

dw_maestro.Reset()
ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	//dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF


////////////////////////////////////////////////////////////////////////
// Se omite el script del papa.
// Se adicionan las lineas necesarias para insertar un registro 
// en el maestro.
///////////////////////////////////////////////////////////////////////

Long ll_resultado

/////////////////////////////////////////////////////////////////////////
// En el siguiente CHOOSE CASE se esta verificando si hubo cambios en el 
// Detalle.
/////////////////////////////////////////////////////////////////////////

CHOOSE CASE wf_detectar_cambios (dw_detalle)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		message.returnvalue = 1
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		// No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados en el detalle...",&
 	               "Desea grabar los cambios del maestro y el detalle",&
               	 Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				message.returnvalue = 1
				RETURN
		END CHOOSE
END CHOOSE

IF (is_cambios = "no" AND is_accion = "nada") OR &
	(is_cambios = "si" AND is_accion <> "cancelo") THEN
	
	//ll_resultado = w_base_simple::Event ue_insertar_maestro(ll_resultado,ll_resultado)
	IF (is_cambios = "no" AND is_accion = "nada") OR &
		(is_cambios = "si" AND is_accion <> "cancelo") THEN	
			dw_detalle.Reset()
	END IF
	Return ll_resultado
END IF





   

end event

event ue_insertar_detalle;call super::ue_insertar_detalle;long	ll_co_referencia
Long li_co_fabrica,li_co_linea


IF il_fila_actual_maestro > 0 THEN
	li_co_fabrica = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_fabrica")
	li_co_linea = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_linea")
	ll_co_referencia = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_referencia")
	IF IsNull(li_co_fabrica) OR IsNull(li_co_linea) OR isnull(ll_co_referencia) THEN
		dw_detalle.DeleteRow(il_fila_actual_detalle)
		il_fila_actual_detalle = il_fila_actual_detalle - 1
	ELSE
		dw_detalle.SetItem(il_fila_actual_detalle,"co_fabrica",li_co_fabrica)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_linea",li_co_linea)
		dw_detalle.SetItem(il_fila_actual_detalle,"co_referencia",ll_co_referencia)
		dw_detalle.SetItem(il_fila_actual_detalle,"cs_parte",il_fila_actual_detalle)
		dw_detalle.AcceptText()
	END IF
END IF
end event

event ue_grabar;/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////

IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN
ELSE
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
END IF
	
//////////////////////////////////////////////////////////////////////////
// En este evento se realizar ACCEPTTEXT para llevar los cambios 
// del detalle al buffer.
// El  UPDATE para preparar los datos en el servidor.
// El  COMMIT para grabar los cambios en la base de datos
//////////////////////////////////////////////////////////////////////////

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

type dw_maestro from w_base_maestroff_detalletb`dw_maestro within w_partes_prenda
integer x = 14
integer y = 16
integer width = 1765
integer height = 380
string title = "Maestro Estilos"
string dataobject = "dff_estilos_h_preref"
boolean hscrollbar = false
boolean vscrollbar = false
end type

type dw_detalle from w_base_maestroff_detalletb`dw_detalle within w_partes_prenda
integer x = 14
integer y = 396
integer width = 1765
integer height = 984
string title = "Detalle Partes por Prenda"
string dataobject = "dtb_detalle_partesxprenda"
end type

