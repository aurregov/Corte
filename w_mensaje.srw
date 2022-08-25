HA$PBExportHeader$w_mensaje.srw
forward
global type w_mensaje from window
end type
type plb_icono from picturelistbox within w_mensaje
end type
type cb_cancelar from commandbutton within w_mensaje
end type
type cb_aceptar from commandbutton within w_mensaje
end type
type mle_mensaje from multilineedit within w_mensaje
end type
type cb_no from commandbutton within w_mensaje
end type
type cb_si from commandbutton within w_mensaje
end type
end forward

global type w_mensaje from window
string tag = "Ventana base para mensajes"
integer width = 1984
integer height = 620
boolean titlebar = true
string title = "Atenci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "Information!"
boolean center = true
event syscommand pbm_syscommand
event type long ue_postopen ( )
event ue_presionar_tecla pbm_keydown
plb_icono plb_icono
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
mle_mensaje mle_mensaje
cb_no cb_no
cb_si cb_si
end type
global w_mensaje w_mensaje

type variables
Datetime idtm_fecha_inicial				//	Usada para almacenar la fecha y hora de apertura de ventana
String is_exporto = 'N'						// Indica si el usuario utilizo guardar como para exportar informacion
uo_dsbase ids_uso								//	ds utilizado para registrar el log de uso
//Long ii_tecla_si, ii_tecla_no, ii_tecla_aceptar, ii_tecla_cancelar
KeyCode ikey_si, ikey_no, ikey_aceptar = KeyA!, ikey_cancelar
String is_sonido =''

Boolean ib_verificar_tecla = False, ib_tecla
Integer ii_tecla
end variables

forward prototypes
public function long wf_set_icono (icon a_icon)
public function long wf_set_botones (button a_boton)
public function long wf_set_icono_default (long ai_boton_default)
public function string of_generar_tecla ()
end prototypes

event syscommand;/*------------------------------------------------------------- 
  Evento usado para garantizar que no se pueda cerrar la ventana
  desde boton close 'X'
  -------------------------------------------------------------*/
Long ll_val

ll_val = 0 
If commandtype = 61536 Then
	Message.Processed   = True
	Return 0
End if
end event

event ue_presionar_tecla;/* Detecta la Inicial del boton para ejecutar el evento
*/

Choose Case key
	Case ikey_aceptar
		If cb_aceptar.Visible Then cb_aceptar.Post Event Clicked()
	Case ikey_si
		If cb_si.Visible Then cb_si.Post Event Clicked()
	Case ikey_no
		If cb_no.Visible Then cb_no.Post Event Clicked()
//	Case ikey_cancelar
//		If cb_cancelar.Visible Then cb_cancelar.Post Event Clicked()
End Choose

If KeyDown( ii_tecla ) Then ib_tecla = True

Return 1

end event

public function long wf_set_icono (icon a_icon);Long li_icono

Choose Case a_icon
	Case Exclamation!
		This.Icon = 'Exclamation!'
		li_icono = 1
	Case Information!
		This.Icon = 'Information!'
		li_icono = 2
	Case None!
		This.Icon = 'None!'
		li_icono = 0
	Case Question!
		This.Icon = 'Question!'
		li_icono = 3
	Case StopSign!
		This.Icon = 'StopSign!'
		li_icono = 4
End Choose

If li_icono > 0 Then
	plb_icono.Reset()
	plb_icono.InsertItem("", li_icono, 1)
End If

Return 1
end function

public function long wf_set_botones (button a_boton);

Choose Case a_boton
	Case abortretryignore!
		cb_aceptar.Visible = False
		cb_si.Text = 'Abortar'
		cb_no.Text = 'Reintentar'
		cb_cancelar.Text = 'Ignorar'
		cb_si.Visible = True
		cb_no.Visible = True
		cb_cancelar.Visible = True
		
		ikey_si = KeyA!
		ikey_no = KeyR!
		ikey_cancelar = KeyC!
	Case ok!
		ikey_aceptar = KeyA!
	Case okcancel!
		cb_aceptar.Visible = False
		cb_si.Text = 'Aceptar'
		cb_no.Text = 'Cancelar'
		cb_si.Visible = True
		cb_no.Visible = True

		ikey_si = KeyA!
		ikey_no = KeyC!
	Case retrycancel!
		cb_aceptar.Visible = False
		cb_si.Text = 'Reintentar'
		cb_no.Text = 'Cancelar'
		cb_si.Visible = True
		cb_no.Visible = True
		ikey_si = KeyR!
		ikey_no = KeyC!
	Case yesno!
		cb_aceptar.Visible = False
		cb_si.Visible = True
		cb_no.Visible = True
		ikey_si = KeyS!
		ikey_no = KeyN!
		ikey_cancelar = KeyC!
	Case yesnocancel!
		cb_aceptar.Visible = False
		cb_si.Visible = True
		cb_no.Visible = True
		cb_cancelar.Visible = True
		ikey_si = KeyS!
		ikey_no = KeyN!
		ikey_cancelar = KeyC!
End Choose

Return 1
end function

public function long wf_set_icono_default (long ai_boton_default);
Choose Case ai_boton_default
	Case 1
		If cb_aceptar.Visible Then
			cb_aceptar.SetFocus()
		Else
			cb_si.SetFocus()
			cb_si.Default = True
		End If
	Case 2
		cb_no.SetFocus()
		cb_no.Default = True
	Case 3
		cb_cancelar.SetFocus()
		cb_cancelar.Default = True
End Choose

Return 1
end function

public function string of_generar_tecla ();String ls_tecla

ii_tecla = Rand(26)
ii_tecla+= 64

ls_tecla = Char(ii_tecla)

Choose Case ls_tecla
	// si la tecla es igual Aceptar, Cancelar, Si, No, Ignorar se mueve a la siguiente
	Case 'A', 'C', 'S', 'N'
		ii_tecla ++
		ls_tecla = Char(ii_tecla)
	// si la tecla es igual Reintentar se mueve a la siguiente a T
	Case 'R'
		ii_tecla +=2
		ls_tecla = Char(ii_tecla)
End Choose

Return ls_tecla
end function

on w_mensaje.create
this.plb_icono=create plb_icono
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.mle_mensaje=create mle_mensaje
this.cb_no=create cb_no
this.cb_si=create cb_si
this.Control[]={this.plb_icono,&
this.cb_cancelar,&
this.cb_aceptar,&
this.mle_mensaje,&
this.cb_no,&
this.cb_si}
end on

on w_mensaje.destroy
destroy(this.plb_icono)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.mle_mensaje)
destroy(this.cb_no)
destroy(this.cb_si)
end on

event open;String ls_sonido, ls_path
s_base_parametros lstr_parametros
n_cst_funciones_comunes lnvo_fun

lstr_parametros = Message.PowerObjectParm
This.Title = lstr_parametros.Cadena[1]
mle_mensaje.Text = lstr_parametros.Cadena[2]
If IsNull( mle_mensaje.Text ) Then  mle_mensaje.Text = 'Mensaje NULO!!!'
wf_set_icono(lstr_parametros.icono[1])
If UpperBound(lstr_parametros.boton) = 1 Then wf_set_botones(lstr_parametros.boton[1])
If UpperBound(lstr_parametros.Entero) = 1 Then wf_set_icono_default(lstr_parametros.Entero[1])
If UpperBound(lstr_parametros.Cadena) = 3 Then
	is_sonido = lstr_parametros.Cadena[3]
Else
	is_sonido = ''
End If

If UpperBound(lstr_parametros.Boolean) > 0 Then 
	ib_verificar_tecla = lstr_parametros.Boolean[1]
	
	If ib_verificar_tecla Then
	
		String ls_tecla
		Integer li_val
		Time lt_hora
		
		lt_hora = Now()
		li_val = Hour(lt_hora) + Minute(lt_hora) + Second(lt_hora)
		
		Randomize(li_val)
		
		ls_tecla = of_generar_tecla()
		mle_mensaje.Text += "~r~n~r~nPresione " + ls_tecla + " si ley$$HEX2$$f3002000$$ENDHEX$$el mensaje."
		
	End If
End If

If mle_mensaje.LineCount() > 4 Then mle_mensaje.VscrollBar = True

//If IsNull( is_sonido ) Or is_sonido = '' Then
//	ls_path = gstr_info_usuario.ruta_sonido
//	If ls_path <> '' Then ls_path += '\'
//	If lstr_parametros.icono[1] = StopSign! Then
//		is_sonido = ls_path + 'error.wav'
//	Else
//		is_sonido = ls_path + 'atencion.wav'
//	End If
//End IF

If is_sonido <> '' Then
	//-- Y las constantes que PlaySound necesita.
	//constant int SND_FILENAME = #00020000, SND_ASYNC = #00000001
	//lnvo_fun.of_Playsound( is_sonido, 1+16 )
	lnvo_fun.of_Playsound( is_sonido )
End If

This.Post Event ue_postopen()
// se deja un timer de 10 minutos
Timer( 600 )

// Clase que contiene los metodos para las pda
n_pda lnvo_pda
// Escondemos la toolbar de la mdi para trabajar con la de la sheet

// Si el dispositivo desde el que visualizamos es una pda
IF lnvo_pda.of_detecta_pda() Then
	this.windowstate=maximized!

	This.width = 1445
	mle_mensaje.x = 0
	mle_mensaje.y = 16
	mle_mensaje.width = 1440
	mle_mensaje.Height = 416
   mle_mensaje.VScrollBar = True

	cb_si.x = 174
	cb_si.y = 448
	cb_aceptar.x = 393
	cb_aceptar.y = 448
	cb_no.x = 562
	cb_no.y = 448
	cb_cancelar.x = 946
	cb_cancelar.y = 448
End If
end event

event show;/*n_cst_log_uso lcst_log_uso
n_cst_control_rva lncst_rva
Long ll_response_rva

//Validacion RVA
ll_response_rva = lncst_rva.of_validar_ventana(This)
If ll_response_rva < 0 Then
	Messagebox("Error", "Error al validar control RVA de Entrada, Por favor comuniquese con Sistemas!")
End If	

//Registro en Log Uso
lcst_log_uso.of_registrar_uso(ids_uso, 'GE', This.ClassName())
*/
end event

event close;/*n_cst_log_uso lcst_log_uso
n_cst_control_rva lncst_rva
Long ll_response_rva

//Actualizar la fecha final en el log uso
lcst_log_uso.of_registrar_fin_uso(is_exporto,ids_uso )

//Validacion RVA cierre
ll_response_rva = lncst_rva.of_validar_cierre(This)
If ll_response_rva < 0 Then
	Messagebox("Error", "Error al validar control RVA de Salida, Por favor comuniquese con Sistemas!")
End If
GarbageCollect()*/
end event

event timer;// para evitar inactividad superior a la permitida
If cb_si.Default Then
	cb_si.Post Event Clicked()
ElseIf cb_no.Default Then
	cb_no.Post Event Clicked()
ElseIf cb_cancelar.Default Then
	cb_cancelar.Post Event Clicked()
Else
	cb_aceptar.Post Event Clicked()
End If
end event

event closequery;If ib_verificar_tecla And Not ib_tecla Then Return 1
end event

type plb_icono from picturelistbox within w_mensaje
integer y = 96
integer width = 146
integer height = 128
integer textsize = -24
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = false
string item[] = {" "}
integer itempictureindex[] = {4}
string picturename[] = {"Exclamation!","Information!","Question!","StopSign!"}
integer picturewidth = 32
integer pictureheight = 32
long picturemaskcolor = 536870912
end type

type cb_cancelar from commandbutton within w_mensaje
boolean visible = false
integer x = 1358
integer y = 372
integer width = 279
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancelar"
end type

event clicked;CloseWithReturn(Parent,3)
end event

type cb_aceptar from commandbutton within w_mensaje
integer x = 805
integer y = 372
integer width = 279
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Aceptar"
boolean default = true
end type

event clicked;CloseWithReturn(Parent,1)
end event

type mle_mensaje from multilineedit within w_mensaje
integer x = 183
integer y = 92
integer width = 1687
integer height = 248
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Texto del mensaje"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type cb_no from commandbutton within w_mensaje
boolean visible = false
integer x = 974
integer y = 372
integer width = 279
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "No"
end type

event clicked;CloseWithReturn(Parent,2)
end event

type cb_si from commandbutton within w_mensaje
boolean visible = false
integer x = 590
integer y = 372
integer width = 279
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Si"
end type

event clicked;CloseWithReturn(Parent,1)
end event

