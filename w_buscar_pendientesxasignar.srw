HA$PBExportHeader$w_buscar_pendientesxasignar.srw
forward
global type w_buscar_pendientesxasignar from w_base_buscar_lista_parametro
end type
type st_simulacion from statictext within w_buscar_pendientesxasignar
end type
type sle_simulacion from singlelineedit within w_buscar_pendientesxasignar
end type
type sle_co_centro from singlelineedit within w_buscar_pendientesxasignar
end type
type sle_co_subcentro from singlelineedit within w_buscar_pendientesxasignar
end type
type st_centro from statictext within w_buscar_pendientesxasignar
end type
type st_subcentro from statictext within w_buscar_pendientesxasignar
end type
type st_2 from statictext within w_buscar_pendientesxasignar
end type
type sle_co_fabrica_exp from singlelineedit within w_buscar_pendientesxasignar
end type
type sle_de_referencia from singlelineedit within w_buscar_pendientesxasignar
end type
type st_de_referencia from statictext within w_buscar_pendientesxasignar
end type
end forward

global type w_buscar_pendientesxasignar from w_base_buscar_lista_parametro
integer x = 0
integer y = 272
integer width = 3835
integer height = 1648
st_simulacion st_simulacion
sle_simulacion sle_simulacion
sle_co_centro sle_co_centro
sle_co_subcentro sle_co_subcentro
st_centro st_centro
st_subcentro st_subcentro
st_2 st_2
sle_co_fabrica_exp sle_co_fabrica_exp
sle_de_referencia sle_de_referencia
st_de_referencia st_de_referencia
end type
global w_buscar_pendientesxasignar w_buscar_pendientesxasignar

type variables
Long   ii_simulacion

Transaction itr_dt
end variables

on w_buscar_pendientesxasignar.create
int iCurrent
call super::create
this.st_simulacion=create st_simulacion
this.sle_simulacion=create sle_simulacion
this.sle_co_centro=create sle_co_centro
this.sle_co_subcentro=create sle_co_subcentro
this.st_centro=create st_centro
this.st_subcentro=create st_subcentro
this.st_2=create st_2
this.sle_co_fabrica_exp=create sle_co_fabrica_exp
this.sle_de_referencia=create sle_de_referencia
this.st_de_referencia=create st_de_referencia
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_simulacion
this.Control[iCurrent+2]=this.sle_simulacion
this.Control[iCurrent+3]=this.sle_co_centro
this.Control[iCurrent+4]=this.sle_co_subcentro
this.Control[iCurrent+5]=this.st_centro
this.Control[iCurrent+6]=this.st_subcentro
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_co_fabrica_exp
this.Control[iCurrent+9]=this.sle_de_referencia
this.Control[iCurrent+10]=this.st_de_referencia
end on

on w_buscar_pendientesxasignar.destroy
call super::destroy
destroy(this.st_simulacion)
destroy(this.sle_simulacion)
destroy(this.sle_co_centro)
destroy(this.sle_co_subcentro)
destroy(this.st_centro)
destroy(this.st_subcentro)
destroy(this.st_2)
destroy(this.sle_co_fabrica_exp)
destroy(this.sle_de_referencia)
destroy(this.st_de_referencia)
end on

event open;LONG 	ll_numero_registros

////desconectar
//Disconnect;
//IF SQLCA.SQLCODE=-1 THEN
////	messagebox ("Error Desconecci$$HEX1$$f300$$ENDHEX$$n","No se pudo desconectar de la Base de datos",Stopsign!,ok!)
//ELSE
////	messagebox ("Desconeccion Exitosa","Se pudo desconectar de la Base de datos")
//END IF
itr_dt = Create Transaction
itr_dt.DBMS=ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_dt.DATABASE=ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_dt.USERID=gstr_info_usuario.codigo_usuario
itr_dt.DBPASS=gstr_info_usuario.password
itr_dt.DBPARM="connectstring='DSN="+SQLCA.DATABASE+";UID="+gstr_info_usuario.codigo_usuario+";PWD="+gstr_info_usuario.password+"DisableBind=1"
itr_dt.ServerName = ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
//SQLCA.Lock = "Cursor Stability"
itr_dt.Lock = "Dirty Read"

CONNECT USING itr_dt;
IF itr_dt.SQLCODE=-1 THEN
//	istr_parametros_error.cadena[1] = sqlca.dbms
//	istr_parametros_error.entero[1] = 9999
//	istr_parametros_error.cadena[2] = this.classname()
//	istr_parametros_error.cadena[3] = "wf_conectar_bd"
//	istr_parametros_error.cadena[4] = "coneccion a la base de datos"
//	istr_parametros_error.cadena[5] = SQLCA.SQLErrText
//	OPENWITHPARM(w_reporte_errores,istr_parametros_error)
//	RETURN(-1)
	messagebox ("Error Conecci$$HEX1$$f300$$ENDHEX$$n","No se pudo conectar la Base de datos",Stopsign!,ok!)
	RETURN
ELSE
	//RETURN(0)
	//messagebox ("Coneccion Exitosa","Se pudo conectar la a Base de datos")
END IF

IF dw_lista.settransobject(itr_dt)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
END IF

dw_lista.modify("dw_lista.readonly=yes")

s_base_parametros lstr_parametros

lstr_parametros	=	Message.PowerObjectParm
	
IF lstr_parametros.hay_parametros THEN
	lstr_parametros.entero[1]=1
	ii_simulacion			=lstr_parametros.entero[1]
	
	sle_simulacion.TEXT=STRING(ii_simulacion)
	
	
ELSE
END IF

end event

type st_1 from w_base_buscar_lista_parametro`st_1 within w_buscar_pendientesxasignar
integer x = 297
integer y = 48
string text = "Grupo:"
end type

type em_dato from w_base_buscar_lista_parametro`em_dato within w_buscar_pendientesxasignar
integer x = 498
integer y = 32
integer width = 393
integer height = 92
textcase textcase = upper!
string mask = ""
end type

event em_dato::modified;//String ls_datocon,ls_de_estilo
//Long ll_numero_registros
//Long		li_co_fabrica_exp,li_simulacion
//
//li_co_fabrica_exp = Long(sle_co_fabrica_exp.Text)
//
//
//ls_datocon=em_dato.Text
////IF ISNULL(em_dato.TEXT) OR em_dato.TEXT=" " THEN
////	ls_datocon=" "
////ELSE
////	ls_datocon 			= "%"+em_dato.Text+"%"
////END IF
//
////IF ISNULL(em_estilo.TEXT) OR em_estilo.TEXT=" " THEN
////	ls_de_estilo=" "
////ELSE
////	ls_de_estilo 			= "%"+em_estilo.Text+"%"
////END IF
//
//li_simulacion=Long(sle_simulacion.TEXT)
//
//IF ISNULL(li_simulacion) THEN
//	MessageBox("Error de datos","Falta el dato de simulaci$$HEX1$$f300$$ENDHEX$$n, por favor verifique")
//	RETURN
//ELSE
//END IF
//
//IF Not IsNull(ls_datocon) THEN
////	ls_datocon = ls_datocon + '%'
//	ls_datocon = ls_datocon 
//	ll_numero_registros = dw_lista.Retrieve(li_co_fabrica_exp,ls_datocon,li_simulacion)
//	//ll_numero_registros = dw_lista.Retrieve(li_co_fabrica_exp,ls_datocon,ls_de_estilo)
//	CHOOSE CASE ll_numero_registros 
//		CASE -1
//			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
//		CASE 0
//			il_fila_actual = 0
//			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
//		CASE ELSE
//			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
//			dw_lista.setrow(1)
//			dw_lista.selectrow(1,true)
//			il_fila_actual = 1
//	END CHOOSE
//END IF
end event

type st_numero_registros from w_base_buscar_lista_parametro`st_numero_registros within w_buscar_pendientesxasignar
integer x = 1010
integer y = 1276
end type

type pb_cancelar from w_base_buscar_lista_parametro`pb_cancelar within w_buscar_pendientesxasignar
integer x = 1609
integer y = 1388
integer taborder = 40
end type

event pb_cancelar::clicked;
s_base_parametros lstr_parametros



Disconnect USING itr_dt;
IF itr_dt.SQLCODE=-1 THEN
	messagebox ("Error Desconecci$$HEX1$$f300$$ENDHEX$$n","No se pudo desconectar de la Base de datos",Stopsign!,ok!)
ELSE
//	messagebox ("Desconeccion Exitosa","Se pudo desconectar de la Base de datos")
END IF

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(parent,lstr_parametros)
end event

type pb_aceptar from w_base_buscar_lista_parametro`pb_aceptar within w_buscar_pendientesxasignar
integer x = 1051
integer y = 1388
integer taborder = 30
end type

event pb_aceptar::clicked;// --------
// Parametros para Envio de correo con datos de PO/estilos sin UPC
// --------
mailSession lms_sesion
mailReturnCode lmrt_retorno
mailMessage lmsg_mensaje
MailFileDescription lmf_attachment

// ------- Variables
Long		ll_upcs, ll_pedido_po, ll_referencia, ll_color
STRING		ls_grupo, ls_po, ls_estilo, ls_color, ls_enter
string ls_S

// ------- Guardamos ASCII del Enter
ls_enter = Char(13)

s_base_parametros lstr_parametros

dw_lista.AcceptText() 

IF il_fila_actual > 0 THEN
	// Prepara variables para Mensaje 
	ls_grupo		=dw_lista.getitemString(il_fila_actual,"gpa")
	ls_estilo 	=dw_lista.getitemstring(il_fila_actual,"de_referencia")
	ll_referencia=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
	ls_po 		=dw_lista.getitemString(il_fila_actual,"nu_orden")
	ls_color		=dw_lista.getitemString(il_fila_actual,"de_color")
	ll_color		=dw_lista.getitemnumber(il_fila_actual,"co_color")
	ll_pedido_po=dw_lista.getitemnumber(il_fila_actual,"pedido_po")


	// Prepara Parametros para retorno
	lstr_parametros.hay_parametros = TRUE
	
	lstr_parametros.entero[1]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica_exp")
	lstr_parametros.entero[2]=dw_lista.getitemnumber(il_fila_actual,"pedido")
	lstr_parametros.cadena[1]=dw_lista.getitemString(il_fila_actual,"gpa")
	lstr_parametros.cadena[2]=dw_lista.getitemString(il_fila_actual,"tipo_pedido")
		
	lstr_parametros.cadena[3]=dw_lista.getitemString(il_fila_actual,"nu_orden")
	lstr_parametros.entero[3]=dw_lista.getitemnumber(il_fila_actual,"co_fabrica")
	lstr_parametros.entero[4]=dw_lista.getitemnumber(il_fila_actual,"co_linea")
	lstr_parametros.entero[5]=dw_lista.getitemnumber(il_fila_actual,"co_referencia")
	lstr_parametros.entero[6]=dw_lista.getitemnumber(il_fila_actual,"co_color")
	lstr_parametros.entero[7]=dw_lista.getitemnumber(il_fila_actual,"cs_liberacion")
	lstr_parametros.entero[8]=dw_lista.getitemnumber(il_fila_actual,"ca_unidades")        //unidades pedidas
	lstr_parametros.cadena[4]=dw_lista.getitemString(il_fila_actual,"tono")
	lstr_parametros.entero[9]=dw_lista.getitemnumber(il_fila_actual,"cs_estilocolortono")  
	lstr_parametros.entero[10]=Long(sle_simulacion.TEXT)
	lstr_parametros.entero[11]=dw_lista.getitemnumber(il_fila_actual,"pedido_po")
	lstr_parametros.entero[12]=dw_lista.getitemnumber(il_fila_actual,"ca_a_asignar")      //unidades a asignar
	lstr_parametros.entero[13]=dw_lista.getitemnumber(il_fila_actual,"ca_faltan")         //unidades pendientes
	
	IF ISNULL(lstr_parametros.cadena[4]) OR lstr_parametros.cadena[4] =" " OR lstr_parametros.cadena[4] ="" THEN
		lstr_parametros.cadena[4]="X"
	ELSE
	END IF
	
	IF lstr_parametros.entero[12]>0 THEN
		//validar que no quede el saldo <= 0
		IF ISNULL(lstr_parametros.entero[13]) THEN
			IF lstr_parametros.entero[12] > lstr_parametros.entero[8] THEN
				MessageBox("Advertencia","No puede Asignar unidades mayores a las pedidas")
				RETURN
			ELSE
			END IF
		ELSE
			IF lstr_parametros.entero[12] > lstr_parametros.entero[13] THEN
				MessageBox("Advertencia","No puede Asignar unidades mayores a las pendientes")
				RETURN
			ELSE
			END IF
		END IF
	ELSE
		IF ISNULL(lstr_parametros.entero[13]) THEN
			lstr_parametros.entero[12]=lstr_parametros.entero[8]
		ELSE
			lstr_parametros.entero[12]=lstr_parametros.entero[13]
		END IF
	END IF
	
	IF lstr_parametros.entero[12] <= 0 THEN
		MessageBox("Advertencia","No puede Asignar unidades en cero")
		RETURN
	ELSE
	END IF
	// ---------
	// Rutina para validar que el estilo tenga UPC y enviar mensaje (mail)
	// ---------
	
	SELECT count(*)
	INTO :ll_upcs 
	FROM pedpend_exp
	WHERE (pedpend_exp.pedido 			 = :lstr_parametros.entero[11]) AND
			(pedpend_exp.co_fabrica 	 = :lstr_parametros.entero[3]) AND
			(pedpend_exp.co_linea 		 = :lstr_parametros.entero[4]) AND
			(pedpend_exp.co_referencia	 = :lstr_parametros.entero[5]) AND
			(pedpend_exp.nu_orden 		 = :lstr_parametros.cadena[3]) AND
			(pedpend_exp.co_color		 = :lstr_parametros.entero[6]) AND
			(pedpend_exp.upc_barcode	 = '            ' OR
			 pedpend_exp.upc_barcode	 = '0           ');

	IF SQLCA.SQLCODE=-1 THEN
		MessageBox("Error Base Datos","No pudo buscar codigos de UPC paa la referencia")
	ELSE
		// --------
		// Se arma y envia el correo correspondiente inofrmado del error
		// --------
		IF ll_upcs > 0 THEN
			// --------------
			// Arma Texto del Correo y lo envia, despues de Preparar ambiente
			// --------------
//			lms_sesion = create mailSession
//
//			lmrt_retorno = lms_sesion.mailLogon(mailNewSession!)
//
//			IF lmrt_retorno <> mailReturnSuccess! THEN
//				MessageBox("Error Correo", 'Error al establecer la sesi$$HEX1$$f300$$ENDHEX$$n de correo')
//				RETURN(1)
//			END IF
//
//			// Arma Texto del correo
//			lmsg_mensaje.Subject = 'Estilos sin UPC En Asignacion Produccion '
//			lmsg_mensaje.NoteText = "La siguiente referencia tiene UPC incompletos " + ls_enter + ls_enter +&
//											" Grupo : "+TRIM(ls_grupo)+ ls_enter + &
//											" Cod.Referencia : "+TRIM(STRING(ll_referencia)) + ls_enter + &
//											" Referencia : "+TRIM(ls_estilo)+ ls_enter + &
//											" P.O. : "+TRIM(ls_po)+ ls_enter + &
//											" Cod.Color : "+TRIM(STRING(ll_color))+ ls_enter + &
//											" Color : "+TRIM(ls_color)+ ls_enter + &
//											" Pedido PO : "+TRIM(STRING(ll_pedido_po)) + ls_enter + ls_enter + &
//											"Por Favor Verificar. Gracias"
//											
//											
//			lmsg_mensaje.Recipient[1].name = 'Coord.Programaci$$HEX1$$f300$$ENDHEX$$n Nicole S.A'  
//			lmsg_mensaje.Recipient[1].name = 'Claudia Irene Franco'
//			
//// -----	lmsg_mensaje.Recipient[1].name = 'Informaci$$HEX1$$f300$$ENDHEX$$n Produccion Nicole S.A' ---- //
//// ----- lo reemplaza Claudia Irene Franco												---- //
//
//			lmrt_retorno = lms_sesion.mailResolveRecipient(lmsg_mensaje.Recipient[1])
//				
//			IF lmrt_retorno = mailReturnSuccess! THEN
//			ELSEIF lmrt_retorno = mailReturnFailure! THEN
//				MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
//				Return(1)
//			ELSE
//				MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
//				Return(1)
//			END IF		
//
//			lmrt_retorno = lms_sesion.mailSend(lmsg_mensaje)
//
//			IF lmrt_retorno <> mailReturnSuccess! THEN
//				MessageBox("Error Correo", 'Error al enviar el mensaje de correo')
//				RETURN(1)
//			END IF	
//		
//			lms_sesion.mailLogoff()
//
//			DESTROY lms_sesion	
		END IF	 // IF ll_upcs > 0 	
	END IF		 // IF SQLCA.SQLCODE=-1 
	

	// Envia Parametros Seleccionados
	closewithreturn(parent,lstr_parametros)
	Return(0)
ELSE
	lstr_parametros.hay_parametros = FALSE
	CloseWithReturn(parent,lstr_parametros)
END IF

end event

type dw_lista from w_base_buscar_lista_parametro`dw_lista within w_buscar_pendientesxasignar
integer x = 9
integer y = 164
integer width = 3776
integer height = 1076
string dataobject = "dtb_buscar_pendientesxasignar"
end type

type st_simulacion from statictext within w_buscar_pendientesxasignar
integer x = 1595
integer y = 48
integer width = 256
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
string text = "Simulaci$$HEX1$$f300$$ENDHEX$$n:"
boolean focusrectangle = false
end type

type sle_simulacion from singlelineedit within w_buscar_pendientesxasignar
integer x = 1851
integer y = 32
integer width = 247
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_co_centro from singlelineedit within w_buscar_pendientesxasignar
integer x = 2400
integer y = 32
integer width = 247
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_co_subcentro from singlelineedit within w_buscar_pendientesxasignar
integer x = 2962
integer y = 32
integer width = 247
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_centro from statictext within w_buscar_pendientesxasignar
integer x = 2203
integer y = 48
integer width = 183
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
string text = "Centro:"
boolean focusrectangle = false
end type

type st_subcentro from statictext within w_buscar_pendientesxasignar
integer x = 2688
integer y = 48
integer width = 247
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
string text = "Subcentro:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_buscar_pendientesxasignar
integer x = 32
integer y = 48
integer width = 96
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
string text = "Cia:"
boolean focusrectangle = false
end type

type sle_co_fabrica_exp from singlelineedit within w_buscar_pendientesxasignar
integer x = 123
integer y = 32
integer width = 137
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "91"
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_de_referencia from singlelineedit within w_buscar_pendientesxasignar
integer x = 1102
integer y = 32
integer width = 462
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_datocon,ls_de_estilo, ls_de_referencia
Long ll_numero_registros
Long		li_co_fabrica_exp,li_simulacion

ls_de_referencia=sle_de_referencia.Text

li_co_fabrica_exp = Long(sle_co_fabrica_exp.Text)

ls_datocon=em_dato.Text
//IF ISNULL(em_dato.TEXT) OR em_dato.TEXT=" " THEN
//	ls_datocon=" "
//ELSE
//	ls_datocon 			= "%"+em_dato.Text+"%"
//END IF

//IF ISNULL(em_estilo.TEXT) OR em_estilo.TEXT=" " THEN
//	ls_de_estilo=" "
//ELSE
//	ls_de_estilo 			= "%"+em_estilo.Text+"%"
//END IF

li_simulacion=Long(sle_simulacion.TEXT)

IF ISNULL(li_simulacion) THEN
	MessageBox("Error de datos","Falta el dato de simulaci$$HEX1$$f300$$ENDHEX$$n, por favor verifique")
	RETURN
ELSE
END IF

IF Not IsNull(ls_datocon) THEN
//	ls_datocon = ls_datocon + '%'
	ls_datocon = ls_datocon 
	ll_numero_registros = dw_lista.Retrieve(li_co_fabrica_exp,ls_datocon,li_simulacion,ls_de_referencia)
	//ll_numero_registros = dw_lista.Retrieve(li_co_fabrica_exp,ls_datocon,ls_de_estilo)
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
END IF
end event

type st_de_referencia from statictext within w_buscar_pendientesxasignar
integer x = 946
integer y = 48
integer width = 155
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
string text = "Estilo :"
boolean focusrectangle = false
end type

