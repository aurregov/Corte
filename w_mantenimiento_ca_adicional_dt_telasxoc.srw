HA$PBExportHeader$w_mantenimiento_ca_adicional_dt_telasxoc.srw
forward
global type w_mantenimiento_ca_adicional_dt_telasxoc from w_base_tabular
end type
type dw_1 from datawindow within w_mantenimiento_ca_adicional_dt_telasxoc
end type
end forward

global type w_mantenimiento_ca_adicional_dt_telasxoc from w_base_tabular
integer width = 3666
integer height = 1348
string title = "Mantenimiento Cantidad Adicional"
event type any ue_enviar_correo ( )
dw_1 dw_1
end type
global w_mantenimiento_ca_adicional_dt_telasxoc w_mantenimiento_ca_adicional_dt_telasxoc

type variables
LONG il_ordencorte,il_fabrica,il_reftel,il_colortela
STRING is_destela,is_tono,is_decolor,is_grupo
DECIMAL id_catela
end variables

event type any ue_enviar_correo();dw_1.Retrieve(il_ordencorte)
dw_1.SaveAs("C:\Mis documentos\Tela_adicional.htm",HTMLTable!	,false)

string		ls_Emp_Input
Integer	li_FileNum
//Creaci$$HEX1$$f300$$ENDHEX$$n de archivo para enviar como adjunto
li_FileNum = FileOpen("C:\Mis documentos\Tela_adicional.htm", LineMode!, Write!, LockWrite!, Append!)
FileRead(li_FileNum, ls_Emp_Input)
FileClose ( li_FileNum )

/*
mailSession lms_sesion
mailReturnCode lmrt_retorno
mailMessage lmsg_mensaje
MailFileDescription lmf_attachment
*/

s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = "Generando Mensajes ..."
lstr_parametros.cadena[2] = "Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros.cadena[3] = "reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros)

/*
IF SQLCA.SQLCode = 0 THEN
	lms_sesion = create mailSession

	lmrt_retorno = lms_sesion.mailLogon(mailNewSession!)

	IF lmrt_retorno <> mailReturnSuccess! THEN
		MessageBox("Error Correo", 'Error al establecer la sesi$$HEX1$$f300$$ENDHEX$$n de correo')
		RETURN(1)
	END IF
END IF
lmsg_mensaje.Subject = 'Tela adicional para la orden de corte '+ TRIM(string(il_ordencorte))
 
  //lmsg_mensaje.NoteText = 'Fabrica: '+ TRIM(string(il_fabrica)) + TRIM(string(il_reftel)) + TRIM(string(is_destela)) + TRIM(string(il_colortela)) + TRIM(string(is_decolor)) +  TRIM(string(is_tono)) +  TRIM(string(id_catela))                                      

   lmsg_mensaje.AttachmentFile[1].fileType	=	mailAttach!
	lmsg_mensaje.AttachmentFile[1].FileName	=	"Tela_adicional.htm"
	lmsg_mensaje.AttachmentFile[1].PathName	= "C:\Mis documentos\Tela_adicional.htm" 
	lmsg_mensaje.AttachmentFile[1].Position	=	 - 1	
	
	lmsg_mensaje.Recipient[1].name = 'Almacen de Telas' 
	lmsg_mensaje.Recipient[2].name = 'Programadores Orden Corte' 
	lmsg_mensaje.Recipient[3].name = 'Coord.Programaci$$HEX1$$f300$$ENDHEX$$n Nicole S.A' 
	lmsg_mensaje.Recipient[4].name = 'Jorge Eduardo Delgado' //jedelgad@crystal.com.co
	lmsg_mensaje.Recipient[5].name = 'Compras Internacionales Nicole S.A' //ComprasInternacionalesNicoleS.A@crystal.com.co
	lmsg_mensaje.Recipient[6].name = 'Jose Fernando Yazo Vargas' 
	lmsg_mensaje.Recipient[7].name = 'Lucky Brand Nicole' 
	lmsg_mensaje.Recipient[8].name = 'Kenneth Cole Nicole' 
	lmsg_mensaje.Recipient[9].name = 'DKNY Nicole' 
	lmsg_mensaje.Recipient[10].name = 'Replenishment Nicole' //ReplenishmentNicole@crystal.com.co
	lmsg_mensaje.Recipient[11].name = 'Liz Claiborne Nicole' //LizClaiborneNicole@crystal.com.co
	lmsg_mensaje.Recipient[12].name = 'Jones New York Nicole' //JonesNewYorkNicole@crystal.com.co

	lmrt_retorno = lms_sesion.mailResolveRecipient(lmsg_mensaje.Recipient[1]) 
	
	IF lmrt_retorno = mailReturnSuccess! THEN
	ELSEIF lmrt_retorno = mailReturnFailure! THEN
		MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
		Return(1)
	ELSE
		MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
		Return(1)
	END IF		

	lmrt_retorno = lms_sesion.mailSend(lmsg_mensaje)

	IF lmrt_retorno <> mailReturnSuccess! THEN
		MessageBox("Error Correo", 'Error al enviar el mensaje de correo')
		RETURN(1)
	END IF	
	
lms_sesion.mailLogoff()

DESTROY lms_sesion	

Close(w_retroalimentacion)

*/

/*Dbedocal: */
uo_correo	lnv_correo
lnv_correo = CREATE uo_correo

TRY
	lnv_correo.of_enviar_correo('Tela adicional para la orden de corte '+ TRIM(string(il_ordencorte)), ls_Emp_Input ,"tela_adicional")
CATCH(Exception ex)
	Messagebox("Error", ex.getmessage())
END TRY

DESTROY lnv_correo

Close(w_retroalimentacion)

Return(0)
end event

on w_mantenimiento_ca_adicional_dt_telasxoc.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_mantenimiento_ca_adicional_dt_telasxoc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;This.width = 3589
This.height = 1148
dw_1.SetTransObject(SQLCA)

end event

event ue_buscar;// ----
// Ignora el Ancestro para la busqueda
// ----
s_base_parametros lstr_parametros
long ll_hallados
Long li_orden_corte

// Recupera valor digitado
li_orden_corte = Long(sle_argumento.text)

// Recupera datos de archivo
ll_hallados = dw_maestro.Retrieve(li_orden_corte)

// Valida datos recuperados 
IF (li_orden_corte > 0) THEN
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
					MessageBox("Busqueda ok","registros encontrados: "+&
             	String(ll_hallados),Information!,Ok!)
					 il_ordencorte = li_orden_corte
			END CHOOSE
		END IF
END IF

end event

event ue_insertar_maestro;// ----------	
// No se permiten adiciones en este programa
// se inactiva el ancestro
// ----------
end event

event ue_borrar_maestro;// ----------	
// No se permiten borrados en este programa
// se inactiva el ancestro
// ----------
end event

event ue_grabar;call super::ue_grabar;//Dbedocal 26/04/2018
dw_1.Retrieve(il_ordencorte)
dw_1.SaveAs("C:\Mis documentos\Tela_adicional.htm",HTMLTable!	,false)

/*			
mailSession lms_sesion
mailReturnCode lmrt_retorno
mailMessage lmsg_mensaje
MailFileDescription lmf_attachment
*/
s_base_parametros lstr_parametros

lstr_parametros.cadena[1] = "Generando Mensajes ..."
lstr_parametros.cadena[2] = "Espere un momento por favor, esta operacion pude durar unos segundos..."
lstr_parametros.cadena[3] = "reloj"

OpenWithParm(w_retroalimentacion,lstr_parametros)

/*
IF SQLCA.SQLCode = 0 THEN
	lms_sesion = create mailSession

	lmrt_retorno = lms_sesion.mailLogon(mailNewSession!)

	IF lmrt_retorno <> mailReturnSuccess! THEN
		MessageBox("Error Correo", 'Error al establecer la sesi$$HEX1$$f300$$ENDHEX$$n de correo')
		RETURN(1)
	END IF
END IF
lmsg_mensaje.Subject = 'Tela adicional para la orden de corte '+ TRIM(string(il_ordencorte)) + 'Grupo '+is_grupo
 
  //lmsg_mensaje.NoteText = 'Fabrica: '+ TRIM(string(il_fabrica)) + TRIM(string(il_reftel)) + TRIM(string(is_destela)) + TRIM(string(il_colortela)) + TRIM(string(is_decolor)) +  TRIM(string(is_tono)) +  TRIM(string(id_catela))                                      

   lmsg_mensaje.AttachmentFile[1].fileType	=	mailAttach!
	lmsg_mensaje.AttachmentFile[1].FileName	=	"Tela_adicional.htm"
	lmsg_mensaje.AttachmentFile[1].PathName	= "C:\Mis documentos\Tela_adicional.htm" 
	lmsg_mensaje.AttachmentFile[1].Position	=	 - 1	
	
	lmsg_mensaje.Recipient[1].name = 'Almacen de Telas' 
	lmsg_mensaje.Recipient[2].name = 'Programadores Orden Corte' 
	lmsg_mensaje.Recipient[3].name = 'Jorge Eduardo Delgado' 
	lmsg_mensaje.Recipient[4].name = 'Compras Internacionales Nicole S.A' 
	lmsg_mensaje.Recipient[5].name = 'Jose Fernando Yazo Vargas' 
	lmsg_mensaje.Recipient[6].name = 'Oscar Arturo Arredondo Padilla' 
	
	lmrt_retorno = lms_sesion.mailResolveRecipient(lmsg_mensaje.Recipient[1])
	
	IF lmrt_retorno = mailReturnSuccess! THEN
	ELSEIF lmrt_retorno = mailReturnFailure! THEN
		MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
		Return(1)
	ELSE
		MessageBox("Error Correo", "No se pudo encontrar una direcci$$HEX1$$f300$$ENDHEX$$n de correo para el usuario")
		Return(1)
	END IF		

	lmrt_retorno = lms_sesion.mailSend(lmsg_mensaje)

	IF lmrt_retorno <> mailReturnSuccess! THEN
		MessageBox("Error Correo", 'Error al enviar el mensaje de correo')
		RETURN(1)
	END IF	
	
lms_sesion.mailLogoff()

DESTROY lms_sesion	

Close(w_retroalimentacion)
*/

uo_correo	lnv_correo
lnv_correo = CREATE uo_correo

TRY
	lnv_correo.of_enviar_correo('Tela adicional para la orden de corte '+ TRIM(string(il_ordencorte)) + 'Grupo '+is_grupo, "" ,"tela_adicional" , "C:\Mis documentos\Tela_adicional.htm")
CATCH(Exception ex)
	Messagebox("Error", ex.getmessage())
END TRY

DESTROY lnv_correo

Return(0)
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_ca_adicional_dt_telasxoc
integer y = 136
integer width = 3534
integer height = 716
integer taborder = 20
string dataobject = "dtb_mantenimiento_dt_telaxoc_adicional"
end type

event dw_maestro::itemchanged;s_base_parametros lstr_parametros
dw_maestro.AcceptText()

il_ordencorte			= this.GetitemNumber(this.getrow(),"cs_orden_corte")	
il_fabrica				= this.GetitemNumber(this.getrow(),"co_fabrica_1")
il_reftel				= this.GetitemNumber(this.getrow(),"co_reftel_1")
is_destela				= this.GetitemString(this.getrow(),"h_telas_de_reftel")
il_colortela			= this.GetitemNumber(this.getrow(),"co_color_1")
is_decolor				= this.GetitemString(this.getrow(),"m_color_de_color")
is_tono					= this.GetitemString(this.getrow(),"tono")
id_catela				= this.GetitemNumber(this.getrow(),"ca_adicional")
is_grupo					= this.GetitemString(this.getrow(),"m_rollo_co_grupo_cte")

end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_ca_adicional_dt_telasxoc
integer x = 635
integer y = 24
integer width = 466
integer taborder = 10
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_ca_adicional_dt_telasxoc
integer y = 24
integer width = 581
integer height = 72
long backcolor = 67108864
string text = "Orden de Corte a Buscar :"
end type

type dw_1 from datawindow within w_mantenimiento_ca_adicional_dt_telasxoc
boolean visible = false
integer x = 37
integer y = 452
integer width = 3424
integer height = 400
string title = "none"
string dataobject = "dtb_tela_adicional"
boolean border = false
boolean livescroll = true
end type

