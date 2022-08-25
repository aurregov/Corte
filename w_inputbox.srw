HA$PBExportHeader$w_inputbox.srw
$PBExportComments$Ventana para pedir ya sea un entero, un decimal o una cadena.
forward
global type w_inputbox from window
end type
type dw_mensaje from datawindow within w_inputbox
end type
end forward

global type w_inputbox from window
integer width = 1157
integer height = 592
boolean titlebar = true
string title = "Untitled"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_mensaje dw_mensaje
end type
global w_inputbox w_inputbox

type variables
String is_msg_error
Long ii_opcion

Datetime idtm_fecha_inicial				//	Usada para almacenar la fecha y hora de apertura de ventana
String is_exporto = 'N'						// Indica si el usuario utilizo guardar como para exportar informacion
uo_dsbase ids_uso								//	ds utilizado para registrar el log de uso
end variables

event open;/* ------------------------------------------------------------------------------------
Evento donde se toman los parametros de la ventana

Cadena[1] = Titulo de la Ventana
Cadena[2] = Mensaje de pregunta en la ventana
Cadena[3] = Mensaje de error de validacion en la ventana

Entero[1] = Variable para elegir que tipo de campo se va a mostrar:
				0	-	Entero,	1	-	Numero(decimal),	2	-	cadena
------------------------------------------------------------------------------------ */

s_base_parametros lsp_parametros

lsp_parametros = Message.PowerObjectParm
If Not lsp_parametros.hay_parametros Then Return

dw_mensaje.InsertRow(0)
// Titulo de la ventana
This.Title = lsp_parametros.Cadena[1]
// Cadena del mensaje
dw_mensaje.SetItem (1, 'Mensaje',lsp_parametros.Cadena[2])
// Opcion de campo a mostrar mostrar
ii_opcion = lsp_parametros.Entero[1]
Choose Case ii_opcion
	Case 0
		// Campo de entero visible
		dw_mensaje.Object.entero.Visible = True
		dw_mensaje.SetColumn('entero')
	Case 1
		// Campo de Numero visible
		dw_mensaje.Object.numero.Visible = True
		dw_mensaje.SetColumn('numero')
	Case 2
		// Campo de Cadena visible
		dw_mensaje.Object.cadena.Visible = True
		dw_mensaje.SetColumn('cadena')
End Choose
// Mensaje de Error
is_msg_error = lsp_parametros.Cadena[3]

If UpperBound(lsp_parametros.Cadena) > 3 Then
	dw_mensaje.SetItem(1,'cadena',lsp_parametros.cadena[4])
End if

end event

on w_inputbox.create
this.dw_mensaje=create dw_mensaje
this.Control[]={this.dw_mensaje}
end on

on w_inputbox.destroy
destroy(this.dw_mensaje)
end on

event show; //n_cst_log_uso lcst_log_uso
//n_cst_control_rva lncst_rva
//Long ll_response_rva
//
////Validacion RVA
//ll_response_rva = lncst_rva.of_validar_ventana(This)
//If ll_response_rva < 0 Then
//	//Messagebox("Error", "Error al validar control RVA, Por favor comuniquese con Sistemas!")
//End If	
//
////Registro en Log Uso
//lcst_log_uso.of_registrar_uso(ids_uso, 'GE', This.ClassName())
//end event
//
//event close;n_cst_log_uso lcst_log_uso
//n_cst_control_rva lncst_rva
//Long ll_response_rva
//
////Actualizar la fecha final en el log uso
//lcst_log_uso.of_registrar_fin_uso(is_exporto,ids_uso )
//
////Validacion RVA cierre
//ll_response_rva = lncst_rva.of_validar_cierre(This)
//If ll_response_rva < 0 Then
//	//Messagebox("Error", "Error al validar control RVA, Por favor comuniquese con Sistemas!")
//End If

GarbageCollect()
end event

type dw_mensaje from datawindow within w_inputbox
integer x = 18
integer y = 28
integer width = 1097
integer height = 456
integer taborder = 10
string title = "none"
string dataobject = "d_gr_inputbox"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;/* ------------------------------------------------------------------------------------
Evento utilizado para validar y retornar un valor dependiendo de la opcion
------------------------------------------------------------------------------------ */

s_base_parametros lsp_parametros
This.AcceptText()

Choose Case dwo.name
	Case 'b_aceptar'
		Choose Case ii_opcion
			Case 0
				// Campo de entero visible
				// Se valida que no sea mayor que 0
				If This.GetItemNumber(1,'entero') < 0 Then
					// se muestra el mensaje de error
					MessageBox('Atencion!',is_msg_error)
					Return
				End If
				// Se retorna el dato
				lsp_parametros.hay_parametros = True
				lsp_parametros.Entero[1] = This.GetItemNumber(1,'entero')
				CloseWithReturn(Parent, lsp_parametros)
			Case 1
				// Campo de numero visible
				// Se valida que no sea mayor que 0
				If This.GetItemNumber(1,'numero') < 0 Then
					// se muestra el mensaje de error
					MessageBox('Atencion!',is_msg_error)
					Return
				End If
				// Se retorna el dato
				lsp_parametros.hay_parametros = True
				lsp_parametros.Decimal[1] = This.GetItemNumber(1,'entero')
				CloseWithReturn(Parent, lsp_parametros)
			Case 2
				// Campo de cadena visible
				// Se valida que no sea mayor que 0
				If Trim(This.GetItemString(1,'cadena')) = '' Then
					// se muestra el mensaje de error
					MessageBox('Atencion!',is_msg_error)
					Return
				End If
				// Se retorna el dato
				lsp_parametros.hay_parametros = True
				lsp_parametros.Cadena[1] = This.GetItemString(1,'cadena')
				CloseWithReturn(Parent, lsp_parametros)
		End Choose		
	Case 'b_cancelar'
		// Se retorna falso en los parametros
		lsp_parametros.hay_parametros = False
		CloseWithReturn(Parent, lsp_parametros)
End Choose
		
end event

