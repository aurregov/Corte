HA$PBExportHeader$w_base_cxe.srw
forward
global type w_base_cxe from w_base_simple
end type
type cb_activacion from commandbutton within w_base_cxe
end type
type cb_ver_informacion from commandbutton within w_base_cxe
end type
type cb_aceptar from commandbutton within w_base_cxe
end type
type cb_cancelar from commandbutton within w_base_cxe
end type
end forward

global type w_base_cxe from w_base_simple
integer width = 2560
integer height = 1452
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string icon = "Query5!"
boolean center = true
event type long ue_activar_cxe ( )
event type long ue_desactivar_cxe ( )
cb_activacion cb_activacion
cb_ver_informacion cb_ver_informacion
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
end type
global w_base_cxe w_base_cxe

type variables
Datastore ids_registro				//	Utilizado para hacer referencia al datawindow de la ventana
end variables

forward prototypes
public function long uf_desactivar_cxe ()
public function long of_retrieve ()
public function long of_evento_sistema (long ai_xpos, long ai_ypos, unsignedlong aul_evento)
end prototypes

event type long ue_activar_cxe();/* --------------------------------------------------------------------------	
	Evento que activa el modo consulta del Datawindow maestro de esta ventana.
   --------------------------------------------------------------------------*/
Long li_boton, li_contador, li_numero_columnas
String ls_modificacion, ls_resultado

If IsValid(dw_maestro) Then	//	Si existe un Datawindow para validar en la ventana
	If dw_maestro.AcceptText() = -1 Then Return -1
	//	Si hay datos del usuario sin salvar pregunta si quiere salvarlos o no y 
	//	ejecuta de acuerdo a la opcion del usuario
	If dw_maestro.ModifiedCount() + dw_maestro.DeletedCount() > 0 Then
		li_boton = MessageBox("Activar Consulta por Ejemplo --> " + This.Title,"Desea guardar los cambios antes de continuar.",Question!,YesNOCancel! )
		Choose Case li_boton
			Case 1	//	Se dispara evento que graba en la base de datos y continua si se tiene exito
				This.TriggerEvent("ue_grabar")
				If is_grabada <> "si" Then
					If This.WindowState = Minimized! Then This.WindowState = Normal!
						BringToTop = True
						Return -1
				End If
			Case 2	//	Se posterga actualizar los cambios hechos a los datos
			Case 3	//	Se aborta el proceso de activaci$$HEX1$$f300$$ENDHEX$$n de Consulta por Ejemplo
				Return -3
			Case Else
				MessageBox("Error de Software","Manejo de Caja de Mensajes con problemas" &
							+ "~nPor favor avise al Administrador de este problema", StopSign!)
				Return -2
		End Choose
	End if
	
	//	Prepara el Datawindows Object para permitir sobreescribir las mascaras de edicion
	//	que tenga el datawindow maestro
	li_numero_columnas = Long(dw_maestro.Describe("DataWindow.Column.Count"))
	For li_contador = 1 To li_numero_columnas
		If  match("editmask",dw_maestro.Describe("#"+string(li_contador)+".Edit.Style")) Then
			ls_modificacion += "#"+string(li_contador)+".Criteria.Override_Edit=yes "
		End If
	Next

	//	Modifica el Datawindow Object con la informacion preparada
	If ls_modificacion <> "" Then
		ls_resultado = dw_maestro.Modify(ls_modificacion)
	End If	
	
	//	Coloca el Datawindow Maestro en modo de consulta x ejemplo (query by example)
	ls_resultado = dw_maestro.Modify("datawindow.querymode=yes")
	If ls_resultado <> "" Then Return -1
		ib_modo_consulta = True
		cb_activacion.Text = "Desactivar"
Else
	MessageBox("Operaci$$HEX1$$f300$$ENDHEX$$n No Valida", "No hay un objeto de datos activo")
	Return 0
End If

Return 1
end event

event type long ue_desactivar_cxe();/* -------------------------------------------------------------------	
	Evento que desactiva el modo de Consulta por Ejemplo en dw_maestro.
	Ocurre solo cuando el usuario estando en modo de consulta vuelve
	a hacer click sobre el boton de consulta por ejemplo.
   -------------------------------------------------------------------*/
Long li_boton, li_contador, li_numero_columnas
String ls_nombre_columna, ls_resultado

If IsValid(dw_maestro) Then	//	Si existe un Datawindow para validar en la ventana
	dw_maestro.AcceptText()
	li_boton = MessageBox("Desactivar Consulta por Ejemplo --> " + This.Title,"Desea borrar el criterio " &
			+ "de selecci$$HEX1$$f300$$ENDHEX$$n antes de continuar." &
			+"~n~nEn caso afirmativo, tenga en cuenta que la informaci$$HEX1$$f300$$ENDHEX$$n (registros borrados " &
			+" y registros modificados o nuevos que estan filtrados) que no se haya guardado " &
			+"antes de activar Consulta por Ejemplo; sera descartada de memoria.",Exclamation!,YesNOCancel!,2)
	Choose Case li_boton
		Case 1	//	Se borra el criterio de selecci$$HEX1$$f300$$ENDHEX$$n
			ls_resultado = dw_maestro.Modify("datawindow.queryclear=yes")
			ls_resultado = dw_maestro.Modify("datawindow.querymode=no")
			If ls_resultado <> "" Then Return -1
			ib_modo_consulta = False
			cb_activacion.Text = "Activar"
			ib_cxe_criterio = False
			Return 1
		Case 2	//	No se borra el criterio de seleccion pero si se desactiva el modo de consulta
			ls_resultado = dw_maestro.Modify("datawindow.querymode=no")
			If ls_resultado <> "" Then Return -1
			ib_modo_consulta = False
			cb_activacion.Text = "Activar"
			ib_cxe_criterio = True
			Return 2
		Case 3	//	Se aborta el proceso de desactivar Consulta por Ejemplo
			Return 3
		Case Else
			MessageBox("Error de Software","Manejo de Caja de Mensajes con problemas" &
						+ "~nPor favor avise al Administrador de este problema", StopSign!)
			Return -2
	End Choose
Else
	MessageBox("Operaci$$HEX1$$f300$$ENDHEX$$n No Valida", "No hay un objeto de datos activo")
	Return 0
End If
end event

public function long uf_desactivar_cxe ();/* ------------------------------------------------------------	
	Desactiva el modo de Consulta por Ejemplo en esta ventana
	teniendo en cuenta si borrar el criterio de selecci$$HEX1$$f300$$ENDHEX$$n o no
	------------------------------------------------------------*/
Long li_numero_columnas, li_contador
String ls_modificacion

li_numero_columnas = Long(dw_maestro.Describe("DataWindow.Column.Count"))
For li_contador = 1 To li_numero_columnas
	If  match("editmask",dw_maestro.Describe("#"+string(li_contador)+".Edit.Style")) Then
		ls_modificacion += "#"+string(li_contador)+".Criteria.Override_Edit=no "
	End If
Next
If ls_modificacion <> "" Then dw_maestro.Modify(ls_modificacion)

//	Limpia la consulta del datawindow
dw_maestro.Modify("datawindow.queryclear=yes")
//This.uf_refrescar_icono_cxe (False,"Query!",False)
ib_cxe_criterio = False

//	Si no logra regresar al modo normal retorna -1
If dw_maestro.Modify("datawindow.querymode=no") <> "" Then Return -1

ib_modo_consulta = False
cb_activacion.Text = "Activar"
Return 1
end function

public function long of_retrieve ();/*	--------------------------------------------------------
	Retorna el total de registros leidos de la base de datos
	--------------------------------------------------------*/
Long ll_valor

ll_valor = dw_maestro.Retrieve()
Return ll_valor
end function

public function long of_evento_sistema (long ai_xpos, long ai_ypos, unsignedlong aul_evento);/*	--------------------------------------------------------
	Si el evento es el boton cerrar 'X' del menu de control
	de la ventana y existe un boton cb_cancelar; ejecuta el
	scrip del evento clicked del boton
	--------------------------------------------------------*/
If aul_evento = 61536 Then
	If IsValid(cb_cancelar) Then cb_cancelar.TriggerEvent(Clicked!)
End If

Return 1
end function

on w_base_cxe.create
int iCurrent
call super::create
this.cb_activacion=create cb_activacion
this.cb_ver_informacion=create cb_ver_informacion
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_activacion
this.Control[iCurrent+2]=this.cb_ver_informacion
this.Control[iCurrent+3]=this.cb_aceptar
this.Control[iCurrent+4]=this.cb_cancelar
end on

on w_base_cxe.destroy
call super::destroy
destroy(this.cb_activacion)
destroy(this.cb_ver_informacion)
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
end on

event open;call super::open;/*	---------------------------------------------------------
	Valida que si se pueda utilizar consulta por ejemplo en
	el datawindow maestro.  No se puede con datawindow:
	Label, Graph, Crosstab, RichText, Nup
	---------------------------------------------------------*/
If Pos("23467", dw_maestro.Describe("DataWindow.Processing")) > 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n"," Consulta por ejemplo no esta disponible para este dw")
	cb_activacion.Enabled = False
End If
end event

type dw_maestro from w_base_simple`dw_maestro within w_base_cxe
integer width = 2354
integer height = 1064
end type

event dw_maestro::itemchanged;//

end event

type cb_activacion from commandbutton within w_base_cxe
string tag = "Activa y/o desactiva el modo de consulta por ejemplo"
integer x = 59
integer y = 1124
integer width = 489
integer height = 100
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Activa"
end type

event clicked;
If Not ib_modo_consulta Then
	If Parent.Event ue_activar_cxe() < 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible activar Consulta Por Ejemplo", StopSign!)
	End If
Else
	If Parent.Event ue_desactivar_cxe() < 0 Then
		MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Imposible Desactivar Consulta Por Ejemplo", StopSign!)
	End If
End If
end event

type cb_ver_informacion from commandbutton within w_base_cxe
string tag = "Recupera l informaci$$HEX1$$f300$$ENDHEX$$n de la base de datos teniendo en cuenta la consulta"
integer x = 585
integer y = 1124
integer width = 489
integer height = 100
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ver Informaci$$HEX1$$f300$$ENDHEX$$n"
end type

event clicked;/*	--------------------------------------------------------
	Hace la lectura de la base de datos y desactiva el modo
	de Consulta por Ejemplo.
	--------------------------------------------------------*/
Long ll_registros
Long li_valor

//	Verifica el ultimo dato digitado por usuario
If ib_modo_consulta Then 
	dw_maestro.AcceptText()
Else
	If dw_maestro.AcceptText() = -1 Then Return -1
End If

ll_registros = of_retrieve()

// Si esta en modo de Consulta por Ejemplo lo desactiva
If ib_modo_consulta Then	
	li_valor = Parent.uf_desactivar_cxe() 	
	Choose Case li_valor
		Case -1
			MessageBox("Error de Software", "Imposible desactivar Consulta por Ejemplo."&
				+ " Fall$$HEX2$$f3002000$$ENDHEX$$alguna operaci$$HEX1$$f300$$ENDHEX$$n 'Modify'." &
				+ "~nPor favor avise al Administrador de este problema", StopSign!)
			Return -1
		Case -2
			Return -2
	End Choose
End If

Return ll_registros
end event

type cb_aceptar from commandbutton within w_base_cxe
integer x = 1678
integer y = 1124
integer width = 343
integer height = 100
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

type cb_cancelar from commandbutton within w_base_cxe
integer x = 2071
integer y = 1124
integer width = 343
integer height = 100
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

