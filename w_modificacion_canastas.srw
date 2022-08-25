HA$PBExportHeader$w_modificacion_canastas.srw
forward
global type w_modificacion_canastas from w_base_tabular
end type
end forward

global type w_modificacion_canastas from w_base_tabular
integer width = 2999
integer height = 1500
string title = "Modificaci$$HEX1$$f300$$ENDHEX$$n Canastas"
end type
global w_modificacion_canastas w_modificacion_canastas

type variables
Long il_ordencorte
end variables

forward prototypes
public function long of_validarconceptounidadesmenos ()
end prototypes

public function long of_validarconceptounidadesmenos ();String ls_usuario, ls_usu_autoriza, ls_instancia, ls_password, ls_error, ls_bolsa
Datetime ldt_fecha
Long ll_count, ll_fila, ll_ordencorte
Long li_concepto
Decimal{2} ldc_ca_actual, idc_ca_actual
s_base_parametros lstr_parametros

ls_usuario = gstr_info_usuario.codigo_usuario
ls_instancia = gstr_info_usuario.instancia
ldt_fecha = f_fecha_servidor()

Return 1

//primero se debe llamar la ventana para ingresar el usuario que autoriza
open(w_autorizacion_capas)
lstr_parametros = message.PowerObjectParm	

IF lstr_parametros.hay_parametros THEN
   ls_usu_autoriza = lstr_parametros.cadena[1]	
	ls_password = lstr_parametros.cadena[2]
	li_concepto = lstr_parametros.entero[1]
	
	//si el usuario y password son validos se validad en dt_usuxper que el perfil del usuario
	//sea 12 $$HEX2$$f3002000$$ENDHEX$$13 en tal caso se deja realizar el cambio, de lo contrario el usuario no esta autorizado 
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_usuxper
	 WHERE co_aplicacion = 40 AND
	       co_perfil in (12,13) AND
	       co_usuario = :ls_usu_autoriza;
	
	IF ll_count > 0 THEN
		FOR ll_fila = 1 To dw_maestro.RowCount()

			//se verifica que la cantidad no sea mayor a la que exista en bd
			ls_bolsa = dw_maestro.GetItemString(ll_fila,'cs_canasta')
			ldc_ca_actual = dw_maestro.GetItemNumber(ll_fila,'ca_actual')
			ll_ordencorte = dw_maestro.GetItemNumber(ll_fila,'cs_orden_corte')
			SELECT ca_actual
			 INTO :idc_ca_actual
			 FROM dt_canasta_corte
			WHERE cs_canasta 		= :ls_bolsa	AND
					cs_orden_corte = :il_ordencorte ;
			
			IF sqlca.sqlcode <> 0 THEN
				ls_error = sqlca.SqlErrText
				Rollback;
				MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la cantidad de la bolsa, ERROR: '+ls_error,StopSign!)
				Return -1
			END IF
		
		   IF ldc_ca_actual > idc_ca_actual THEN
				Rollback;
				MessageBox('Error','Las unidades de la bolsa '+ls_bolsa +'no pueden modificarse por unas mayores a las programadas.',StopSign!)
				Return -1
			END IF
		
			IF ldc_ca_actual < idc_ca_actual THEN
				//se graba en el log
				INSERT INTO log_unid_lot  
					( cs_orden_corte,   
					  cs_canasta,   
					  unid_prog,   
					  unid_lot,   
					  autorizacion,   
					  fe_creacion,   
					  usuario,   
					  instancia,   
					  concepto )  
				 VALUES 
					 (:ll_ordencorte,   
					  :ls_bolsa,   
					  :idc_ca_actual,   
					  :ldc_ca_actual,   
					  :ls_usu_autoriza,   
					  :ldt_fecha,   
					  :gstr_info_usuario.codigo_usuario,   
					  :gstr_info_usuario.instancia,   
					  :li_concepto) ;
					  
				IF sqlca.sqlcode = -1 THEN
					ls_error = sqlca.SqlErrText
					Rollback;
					MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de cargar el log, ERROR: '+ls_error)
					Return -1
				End if
			END IF
		NEXT
   ELSE
		MessageBox('Error','El usuario no esta autorizado para permitir este cambio de capas, los unicos autorizados son el Jefe de corte o los jefes de sal$$HEX1$$f300$$ENDHEX$$n.')
		Return -1
	END IF
ELSE //no se selecciono ningun usuario autorizado
	Return -1
END IF

Return 0
end function

on w_modificacion_canastas.create
call super::create
end on

on w_modificacion_canastas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insertar_maestro;call super::ue_insertar_maestro;// Se omite el script
end event

event ue_borrar_maestro;call super::ue_borrar_maestro;// Se omite el script
end event

event ue_buscar;Long ll_ret, ll_ordencorte

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN -1 // Fallo el AcceptText para el Maestro
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios  en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				ll_ret = This.Event ue_grabar(0,0)
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
		END CHOOSE
END CHOOSE

s_base_parametros lstr_parametros_retro

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	///////////////////////////////////////////////////////////////////
	// Las siguientes tres lineas, estan llenando la estructura 
	// s_base_parametrospara poder asi desplegar en la ventana 
   // de retroalimentacion el mensaje correspondiente a la 
	// accion que se esta ejecutando.
	//
	///////////////////////////////////////////////////////////////////
	
	lstr_parametros_retro.cadena[1]="Cargando datos ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

	ll_ordencorte = Long(sle_argumento.Text)
	il_ordencorte = ll_ordencorte
	CHOOSE CASE dw_maestro.Retrieve(ll_ordencorte)
		CASE -1
			Close(w_retroalimentacion)
			MessageBox("Error datawindow","No se pudo cargar datos", &
			            Exclamation!,Ok!)
			 
			////////////////////////////////////////////////////////////////
       	// Las siguientes cinco lineas, estan llenando la estructura 
      	// s_base_parametros 
      	// para poder asi desplegar en la ventana de errores el mensaje
      	// correspondiente al error reportado por el motor de base de 
			// datos.
       	////////////////////////////////////////////////////////////////
			 
			istr_parametros_error.cadena[1]=sqlca.dbms
			istr_parametros_error.entero[1]=sqlca.sqlcode
			istr_parametros_error.cadena[2]=this.classname()
			istr_parametros_error.cadena[3]="modified"
			istr_parametros_error.cadena[4]=""
			istr_parametros_error.cadena[5] = SQLCA.SQLErrText
			OpenWithParm(w_reporte_errores,istr_parametros_error)
			Close(This)
		CASE 0
			Close(w_retroalimentacion)
			MessageBox("Error datawindows","No se hallaron datos", &
			            Exclamation!,Ok!)
		CASE ELSE
			Close(w_retroalimentacion)
			il_fila_actual_maestro = 1
			dw_maestro.SetRow(il_fila_actual_maestro)
			dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
			dw_maestro.ScrollToRow(il_fila_actual_maestro)
			dw_maestro.SetColumn(1)
			dw_maestro.SetFocus()
	END CHOOSE
ELSE
END IF
end event

event open;This.x = 1
This.y = 1
dw_maestro.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

event ue_grabar;Long idc_ca_actual
String ls_bolsa, ls_error
Decimal ldc_ca_actual
Long ll_fila
uo_dsbase lds_ordenpd

dw_maestro.AcceptText()

IF gstr_info_usuario.codigo_perfil = 24  THEN
ELSE
	Rollback;
	MessageBox('Error','Usuario no autorizado para realizar modificaciones.',StopSign!)
	RETURN
END IF


//FOR ll_fila = 1 To dw_maestro.RowCount()
//
//		//se verifica que la cantidad no sea mayor a la que exista en bd
//		ls_bolsa = dw_maestro.GetItemString(ll_fila,'cs_canasta')
//		ldc_ca_actual = dw_maestro.GetItemNumber(ll_fila,'ca_actual')
//		
//		SELECT ca_actual
//	    INTO :idc_ca_actual
//	    FROM dt_canasta_corte
//	   WHERE cs_canasta 		= :ls_bolsa	AND
//			   cs_orden_corte 	= :il_ordencorte ;
//		
//		IF sqlca.sqlcode <> 0 THEN
//			ls_error = sqlca.SqlErrText
//			Rollback;
//			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la cantidad de la bolsa, ERROR: '+ls_error,StopSign!)
//			Return
//		END IF
			
		//validacion para solicitar usuario y concepto al momento de disminuir
		//las unidades de alguna bolsa
		//esto se pidio en el sue$$HEX1$$f100$$ENDHEX$$o del recipiente perfecto.
		//jcrm
		//abril 12 de 2007
		
//		IF ldc_ca_actual < idc_ca_actual THEN
			If of_ValidarConceptoUnidadesMenos() = -1 Then
				Rollback;
				TriggerEvent('ue_buscar')
			ELSE
				ll_fila = dw_maestro.RowCount() + 1
//			End if
		END IF
//NEXT




Long ll_reg, ll_talla, ll_color, ll_find
Long li_sw_cambio_unid
String ls_mensajes, ls_usuario

lds_ordenpd = Create uo_dsbase				
lds_ordenpd.dataobject = "d_gr_ordenpd_talla_color_x_oc"
lds_ordenpd.settransobject(gnv_recursos.of_get_transaccion_sucia())

//consulta la ordenpd 
lds_ordenpd.Of_Retrieve(il_ordencorte)

ls_usuario = gstr_info_usuario.codigo_usuario 
//verifica si se realiza algun cambio
li_sw_cambio_unid = 0 
ls_mensajes = ''
For ll_reg = 1 to dw_maestro.RowCount()
	//si hay cambio en las cantidad
	If (dw_maestro.GetItemNumber(ll_reg,'ca_actual',Primary!, True) <> dw_maestro.GetItemNumber(ll_reg,'ca_actual')) Then
		
		//Toma la talla y color
		ll_talla = dw_maestro.GetItemNumber(ll_reg,'co_talla')
		ll_color = dw_maestro.GetItemNumber(ll_reg,'co_color')
		
		lds_ordenpd.SetFilter('co_talla = ' + String(ll_talla) + &
												' and co_color = ' + String(ll_color) + &
												' and ca_programada > ca_liberadas ' )
		lds_ordenpd.Filter()
		//si las unidades liberadas son menores a las programadas entonces se env$$HEX1$$ed00$$ENDHEX$$a correo,
		//si son superiores no se env$$HEX1$$ed00$$ENDHEX$$a correo
		If lds_ordenpd.RowCount() > 0 Then
			//se llena mensaje para el correo
			ls_mensajes = ls_mensajes + '~r~nLa canasta ' + trim(dw_maestro.GetItemString(ll_reg,'cs_canasta')) + &
								' cambio de unidades, tenia ' + String(dw_maestro.GetItemNumber(ll_reg,'ca_actual',Primary!, True)) + &
								' y los movieron a ' + String(dw_maestro.GetItemNumber(ll_reg,'ca_actual')) + &
								', cambio realizado por ' + Trim(ls_usuario)
	
			li_sw_cambio_unid = 1
		End if
	End if
	
Next


//graba la actualizacion realizada en la datawindow
IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN -1
ELSE
	IF dw_maestro.Update() = -1 THEN
		ROLLBACK;
		Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	   RETURN 
	ELSE
		COMMIT;
		
		//si envia correo por cambio en las unidades
		If li_sw_cambio_unid = 1 Then
			//	Declara y Ejecuta procedimiento almacenado para envio de correo, el codigo 47 es el que pertenece a este proceso en la tabla m_usu_correo
			/*
			Declare pr_envia_correo Procedure For pr_envia_correo('Cambio de unidades en bolsa', &
						:ls_mensajes,47,:ls_usuario);
			Execute pr_envia_correo;
			If SQLCA.SQLCODE = -1 Then
				ls_error = "~n~nDB Error: " + String(SQLCA.SQLDBCODE) + "~n" + SQLCA.SQLErrText
				RollBack;
				MessageBox("Atencion", "Error enviando correo por Cambio de unidades en bolsa" + ls_error, StopSign!)
				Close pr_envia_correo;
			End If
			// Cierra el procedimiento almacenado declarado
			Close pr_envia_correo;
			*/
			uo_correo	lnv_correo
			lnv_correo = CREATE uo_correo
			
			TRY
				lnv_correo.of_enviar_correo('Cambio de unidades en bolsa', ls_mensajes,'cambiounidcaja', ls_usuario)
			CATCH(Exception ex)
				Messagebox("Error", ex.getmessage())
			END TRY
			
			DESTROY lnv_correo  

		End if
	
		Messagebox("Exito","Se modificaron las cantidades en las bolsas." &
	           ,Exclamation!,Ok!)	
	END IF
END IF
end event

type dw_maestro from w_base_tabular`dw_maestro within w_modificacion_canastas
integer y = 92
integer width = 2894
integer height = 1184
integer taborder = 20
string dataobject = "dtb_administracion_dt_canasta_corte"
boolean hscrollbar = false
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::updatestart;call super::updatestart;Long ll_fila, ll_bongo, ll_ordencorte, ll_referencia
Long li_fab, li_planta, li_fabrica, li_linea
String ls_canasta, ls_bongo, ls_po
n_cst_bolsa lpo_bolsa

FOR ll_fila = 1 TO This.RowCount()
	IF This.GetItemStatus(ll_fila, 0, Primary!) = DataModified! AND &
		This.GetItemStatus(ll_fila, "pallet_id", Primary!) = DataModified! THEN
		ls_canasta = This.GetItemString(ll_fila, "cs_canasta")
		ls_bongo = This.GetItemString(ll_fila, "pallet_id")
		
//		//antes de actualizar se debe validar que el bongo si pueda ser utilizado para la oc
//				
//		li_fab 			= Long(Mid( ls_bongo, 1 , 1 ))
//		li_planta 		= Long(Mid( ls_bongo, 2 , 1 ))
//		ll_bongo       = Long(Mid(ls_bongo,3))
//		ll_ordencorte  = Long(sle_argumento.Text)
//		
//		SELECT po, co_fabrica_ref, co_linea, co_referencia
//		  INTO :ls_po, :li_fabrica, :li_linea, :ll_referencia
//		  FROM dt_canasta_corte
//		 WHERE cs_canasta = :ls_canasta; 
//		
//		IF SQLCA.SQLCode = -1 THEN
//			ROLLBACK;
//			MessageBox("Error Base Datos","Error al momento de validar el bongo")
//			Return 1
//		END IF
//		
//		If lpo_bolsa.of_validar_bongo(ll_ordencorte,ll_bongo,li_fab,li_planta,ls_po, li_fabrica, li_linea, ll_referencia ) = -1 Then
//			This.SetItem(ll_fila,'bongo',0)
//			Return 2
//		END IF
		
		UPDATE h_canasta_corte
		SET	pallet_id = :ls_bongo,
				fe_actualizacion = Current,
				usuario = User,
				instancia = SiteName
		WHERE cs_canasta = :ls_canasta;
		IF SQLCA.SQLCode = -1 THEN
			ROLLBACK;
			MessageBox("Error Base Datos","Error al actualizar la canasta")
			Return 1
		END IF
	END IF
NEXT
end event

event dw_maestro::itemchanged;call super::itemchanged;//Long idc_ca_actual
//String ls_bolsa, ls_error
//Decimal ldc_ca_actual
//
//This.AcceptText()
//
//choose case dwo.name
//	case 'ca_actual'
//		//se verifica que la cantidad no sea mayor a la que exista en bd
//		ls_bolsa = This.GetItemString(Row,'cs_canasta')
//		ldc_ca_actual = This.GetItemNumber(Row,'ca_actual')
//		
//		SELECT ca_actual
//	    INTO :idc_ca_actual
//	    FROM dt_canasta_corte
//	   WHERE cs_canasta 		= :ls_bolsa	AND
//			   cs_orden_corte 	= :il_ordencorte ;
//		
//		IF sqlca.sqlcode <> 0 THEN
//			ls_error = sqlca.SqlErrText
//			Rollback;
//			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar la cantidad de la bolsa, ERROR: '+ls_error,StopSign!)
//			Return
//		END IF
//			
//		IF ldc_ca_actual > idc_ca_actual THEN
//					  This.SetItem(Row,'ca_actual',idc_ca_actual)	
//					  MessageBox('Error','La cantidad ingresada no puede ser mayor a la loteada o programada',StopSign!)
//					  Return 2 
//		END IF
//		
//		//validacion para solicitar usuario y concepto al momento de disminuir
//		//las unidades de alguna bolsa
//		//esto se pidio en el sue$$HEX1$$f100$$ENDHEX$$o del recipiente perfecto.
//		//jcrm
//		//abril 12 de 2007
//		
////		IF ldc_ca_actual < idc_ca_actual THEN
////			If of_ValidarConceptoUnidadesMenos(il_ordencorte,ls_bolsa,ldc_ca_actual,idc_ca_actual) = -1 Then
////				This.SetItem(Row,'ca_actual',idc_ca_actual)
////				Return 2
////			End if
////		END IF
//end choose
//
//////graba la actualizacion realizada en la datawindow
////IF dw_maestro.AcceptText() = -1 THEN
////	is_accion = "no accepttext"
////	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
////	           ,Exclamation!,Ok!)	
////	RETURN -1
////ELSE
////	IF dw_maestro.Update() = -1 THEN
////		is_accion = "no update"
////		ROLLBACK;
////	   RETURN -2
////	ELSE
////		is_accion = "si update"
////		COMMIT;
////		IF SQLCA.SQLCode = -1 THEN
////			is_grabada = "no"
////			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)
////			RETURN -3
////		ELSE
////			is_grabada = "si"
////		END IF
////	END IF
////END IF
//
//RETURN 1
end event

type sle_argumento from w_base_tabular`sle_argumento within w_modificacion_canastas
integer x = 357
integer y = 8
integer width = 677
integer taborder = 10
end type

type st_1 from w_base_tabular`st_1 within w_modificacion_canastas
integer width = 283
string text = "Orden Corte:"
end type

