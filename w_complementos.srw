HA$PBExportHeader$w_complementos.srw
forward
global type w_complementos from window
end type
type cb_1 from commandbutton within w_complementos
end type
type cb_cancelar from commandbutton within w_complementos
end type
type cb_aceptar from commandbutton within w_complementos
end type
type sle_parte from singlelineedit within w_complementos
end type
type dw_detalle from datawindow within w_complementos
end type
type gb_1 from groupbox within w_complementos
end type
end forward

global type w_complementos from window
integer width = 1211
integer height = 1384
boolean titlebar = true
string title = "Complementos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
sle_parte sle_parte
dw_detalle dw_detalle
gb_1 gb_1
end type
global w_complementos w_complementos

type variables
Long il_oc
end variables

on w_complementos.create
this.cb_1=create cb_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.sle_parte=create sle_parte
this.dw_detalle=create dw_detalle
this.gb_1=create gb_1
this.Control[]={this.cb_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.sle_parte,&
this.dw_detalle,&
this.gb_1}
end on

on w_complementos.destroy
destroy(this.cb_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.sle_parte)
destroy(this.dw_detalle)
destroy(this.gb_1)
end on

event open;This.Center = True

Long li_result, li_fabrica, li_linea
Long ll_referencia, ll_duo
n_cst_orden_corte luo_corte
s_base_parametros lstr_parametros

dw_detalle.SetTransObject(sqlca)

lstr_parametros = Message.PowerObjectParm	

il_oc = lstr_parametros.entero[1]
li_fabrica = lstr_parametros.entero[2]
li_linea = lstr_parametros.entero[3]
ll_referencia = lstr_parametros.entero[4]

//se establece si la orden de corte hace parte de un duo o conjunto, si es asi se deben mostrar 
//los complementos de las ordenes que componen el duo o conjunto
//jcrm
//noviembre 10 de 2008
ll_duo = luo_corte.of_duo_conjunto(il_oc)

IF ll_duo > 0 THEN
	//es un duo se deben mostrar los complementos de todas las ordenes de corte
	dw_detalle.DataObject = 'dgr_partes_complementos_duo'
	dw_detalle.SetTransObject(sqlca)
	
	li_result = dw_detalle.retrieve(il_oc, li_fabrica, li_linea, ll_referencia)
ELSE
	//se trata de una orden individual
	li_result = dw_detalle.retrieve(il_oc, li_fabrica, li_linea, ll_referencia)
END IF

IF li_result > 0 THEN
ELSE
	//MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','La orden de corte: '+String(il_oc)+' no tiene asociados complementos, el loteo puede continuar.')
	cb_aceptar.TriggerEvent(Clicked!)
END IF
end event

type cb_1 from commandbutton within w_complementos
integer x = 1051
integer y = 1216
integer width = 133
integer height = 84
integer taborder = 30
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clave"
end type

event clicked;STRING	ls_password, ls_password_ingresado
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte

ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD VER CODIGO PARTE'))
//dw_detalle.visible("dig_chequeo",1)

Open(w_password_trazos)
lstr_parametros = message.PowerObjectParm

If lstr_parametros.hay_parametros = true Then
	ls_password_ingresado = Trim(lstr_parametros.cadena[1])
				
	If ls_password_ingresado = ls_password Then
		//clave correcta, continua el proceso
		
		dw_detalle.Modify("dig_chequeo.Visible='1'")
	Else
		MessageBox('Error','Password, no valido.')
	
	End if
Else

End if

end event

type cb_cancelar from commandbutton within w_complementos
integer x = 681
integer y = 1104
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;S_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( Parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_complementos
integer x = 183
integer y = 1104
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Long li_fila, li_marca
String ls_parte
s_base_parametros lstr_parametros

dw_detalle.AcceptText()

FOR li_fila = 1 TO dw_detalle.RowCount()
	li_marca = dw_detalle.GetItemNumber(li_fila,'marca')
	IF li_marca = 0 THEN
//		ls_parte = dw_detalle.GetItemString(li_fila,'m_partes_de_parte')
//		MessageBox('Advertencia','La parte '+Trim(ls_parte)+' aun no ha sido marcada.')
		sle_parte.SetFocus()
		Return
	END IF
NEXT

lstr_parametros.hay_parametros = True

CloseWithReturn ( Parent, lstr_parametros )
end event

type sle_parte from singlelineedit within w_complementos
integer x = 219
integer y = 156
integer width = 686
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event modified;//se adiciona control con digitos de chequeo para evitar que los usuarios digiten el codigo, en los dos primeros
//caracteres se coloca el dia de creacion, estos e imprimen en el cogido de barras y al leer el codigo debe tener
//en los dos primeros campos ese dia de creacion, inicialmente tambien se acepta el 00 por los codigos que ya estan impresos
//pero esto es temporal (or li_digito_chequeo = 0) mientras se vasea la mangera
//jorodrig agosto 26 - 2010 solicita ljgarcia

String ls_parte, ls_oc, ls_chequeo
Long li_fila,li_paso,li_marca, li_digito_chequeo
Long ll_parte,ll_oc

ls_parte = sle_parte.Text

ls_chequeo = Mid(String(ls_parte),1,2)
ls_oc = Mid(String(ls_parte),3,6)
ls_parte = Mid(String(ls_parte),9,12)

li_digito_chequeo = Long(ls_chequeo)
ll_oc= Long(ls_oc)
ll_parte = Long(ls_parte)

//verificamos que la orden de corte su parte si pertenezca a la misma orden de corte
	
IF ll_oc = il_oc THEN
	//marcamos la parte
	FOR li_fila = 1 TO dw_detalle.RowCount()
		IF (ll_parte = dw_detalle.GetItemNumber(li_fila,'co_parte')) AND &
		   (li_digito_chequeo = Long(dw_detalle.GetItemString(li_fila,'dig_chequeo') ) ) THEN
			//marcamos la fila
			dw_detalle.SetItem(li_fila,'marca',1)
			sle_parte.text = ''
			sle_parte.SetFocus()
		END IF
	NEXT
ELSE
	MessageBox('Error','La parte no pertenece a la orden de corte, verifique sus datos.')
END IF

sle_parte.SetFocus()




end event

type dw_detalle from datawindow within w_complementos
integer x = 133
integer y = 296
integer width = 937
integer height = 692
string title = "none"
string dataobject = "dgr_partes_complementos"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_complementos
integer x = 69
integer y = 48
integer width = 1033
integer height = 968
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Complementos "
end type

