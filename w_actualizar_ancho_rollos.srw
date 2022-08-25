HA$PBExportHeader$w_actualizar_ancho_rollos.srw
forward
global type w_actualizar_ancho_rollos from w_base_simple
end type
type cb_1 from commandbutton within w_actualizar_ancho_rollos
end type
type dw_1 from uo_dtwndow within w_actualizar_ancho_rollos
end type
end forward

global type w_actualizar_ancho_rollos from w_base_simple
integer width = 3086
integer height = 1456
string title = "Actualizar Anchos"
cb_1 cb_1
dw_1 dw_1
end type
global w_actualizar_ancho_rollos w_actualizar_ancho_rollos

on w_actualizar_ancho_rollos.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
end on

on w_actualizar_ancho_rollos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;Long	li_perfil
li_perfil = gstr_info_usuario.codigo_perfil

IF (li_perfil = 13 OR li_perfil = 1 OR li_perfil = 6) THEN  //solo El jefe de corte puede cambiar los rollos
ELSE
	MessageBox('Advrtencia','Solo el jefe de corte puede cambiar datos de rollos')
	close(THIS)
	Return
END IF
dw_1.Insertrow(0)
dw_maestro.SetTransObject(SQLCA)
//dw_maestro.Retrieve(0,0,0,0,0,0,0)
end event

event resize;call super::resize;dw_maestro.Resize(This.Width - 120, This.Height - 600)
end event

type dw_maestro from w_base_simple`dw_maestro within w_actualizar_ancho_rollos
integer y = 408
integer width = 2971
integer height = 828
string dataobject = "dtb_actualizar_ancho_rollos"
end type

event dw_maestro::doubleclicked;call super::doubleclicked;Long ll_reg

If This.AcceptText() <=0 Then Return -1

// con doble clic sobre el campo copie la informaci$$HEX1$$f300$$ENDHEX$$n a los dem$$HEX1$$e100$$ENDHEX$$s registros en la misma columna
If row > 0 Then
	//copia los datos a todos los registros
	For ll_reg = 1 to This.RowCount()
		If dwo.name = 'ancho_tub_term' Then
			This.SetItem(ll_reg,'ancho_tub_term',This.GetItemDecimal(row,'ancho_tub_term'))
		End if
		
	Next
End if
end event

type cb_1 from commandbutton within w_actualizar_ancho_rollos
integer x = 1920
integer width = 667
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Activar Cambio de Unidades"
end type

event clicked;String ls_password, ls_password_ingresado
s_base_parametros lstr_parametros
n_cts_constantes_corte lpo_const_corte

//		
//		
//		
MessageBox('Advertencia','Es necesario autorizaci$$HEX1$$f300$$ENDHEX$$n para activar cambo unidades.')
ls_password = Trim(lpo_const_corte.of_consultar_texto('PASSWORD CAMBIAR UNID ROLLO'))
//
//abro ventana para pedir password de autorizaci$$HEX1$$f300$$ENDHEX$$n
Open(w_password_trazos)
lstr_parametros = message.PowerObjectParm
//		
If lstr_parametros.hay_parametros = true Then
	ls_password_ingresado = Trim(lstr_parametros.cadena[1])
						
	If ls_password_ingresado = ls_password Then
		dw_maestro.SetTabOrder("ca_unidades",40)
	Else
		MessageBox('Error','Password, no valido.')
	END IF
END IF
end event

type dw_1 from uo_dtwndow within w_actualizar_ancho_rollos
integer x = 64
integer y = 116
integer width = 2926
integer height = 252
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_ff_parametros_actualizar_ancho_rollo"
boolean vscrollbar = false
boolean border = false
end type

event buttonclicking;call super::buttonclicking;
Long ll_rollo, ll_op, ll_tanda, ll_tela, ll_color, ll_centro, ll_ir

If dw_1.AcceptText() <= 0 Then Return -1

//toma los datos 
ll_rollo = dw_1.GetItemNumber(1,'rollo')
If Isnull(ll_rollo) Then ll_rollo = 0

ll_op = dw_1.GetItemNumber(1,'op')
If Isnull(ll_op) Then ll_op = 0

ll_tanda = dw_1.GetItemNumber(1,'tanda')
If Isnull(ll_tanda) Then ll_tanda = 0

ll_tela = dw_1.GetItemNumber(1,'tela')
If Isnull(ll_tela) Then ll_tela = 0

ll_color = dw_1.GetItemNumber(1,'color')
If Isnull(ll_color) Then ll_color = 0

ll_centro = dw_1.GetItemNumber(1,'centro')
If Isnull(ll_centro) Then ll_centro = 0

ll_ir = dw_1.GetItemNumber(1,'ir')
If Isnull(ll_ir) Then ll_ir = 0

//alguno de los campos tiene que ser distinto de cero
If ll_rollo = 0 and ll_op = 0 and ll_tanda = 0 and ll_tela = 0 and &
		ll_color = 0 and ll_centro = 0 and ll_ir = 0 Then
		
	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n','Todos los campos estan en cero, debe ingresar alguno para la consulta.')	
	Return 1
End if

//realiza la consulta
dw_maestro.Retrieve(ll_rollo, ll_op, ll_tanda, ll_tela, ll_color, ll_centro, ll_ir)
end event

event itemchanged;//
end event

event getfocus;//
end event

