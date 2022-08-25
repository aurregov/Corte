HA$PBExportHeader$w_mercar_tela_pda.srw
forward
global type w_mercar_tela_pda from w_base_pda
end type
type st_1 from statictext within w_mercar_tela_pda
end type
type st_2 from statictext within w_mercar_tela_pda
end type
type st_3 from statictext within w_mercar_tela_pda
end type
type sle_mesa from singlelineedit within w_mercar_tela_pda
end type
type sle_oc from singlelineedit within w_mercar_tela_pda
end type
type sle_tot_rollos from singlelineedit within w_mercar_tela_pda
end type
type st_4 from statictext within w_mercar_tela_pda
end type
type st_5 from statictext within w_mercar_tela_pda
end type
type sle_rollo_leido from singlelineedit within w_mercar_tela_pda
end type
type sle_ubicacion_leida from singlelineedit within w_mercar_tela_pda
end type
type gb_1 from groupbox within w_mercar_tela_pda
end type
type gb_2 from groupbox within w_mercar_tela_pda
end type
end forward

global type w_mercar_tela_pda from w_base_pda
integer width = 1381
integer height = 1504
string title = "Mercada Tela"
st_1 st_1
st_2 st_2
st_3 st_3
sle_mesa sle_mesa
sle_oc sle_oc
sle_tot_rollos sle_tot_rollos
st_4 st_4
st_5 st_5
sle_rollo_leido sle_rollo_leido
sle_ubicacion_leida sle_ubicacion_leida
gb_1 gb_1
gb_2 gb_2
end type
global w_mercar_tela_pda w_mercar_tela_pda

type variables
Boolean ib_sort_asc, ib_mercada
 
end variables

on w_mercar_tela_pda.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_mesa=create sle_mesa
this.sle_oc=create sle_oc
this.sle_tot_rollos=create sle_tot_rollos
this.st_4=create st_4
this.st_5=create st_5
this.sle_rollo_leido=create sle_rollo_leido
this.sle_ubicacion_leida=create sle_ubicacion_leida
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_mesa
this.Control[iCurrent+5]=this.sle_oc
this.Control[iCurrent+6]=this.sle_tot_rollos
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_rollo_leido
this.Control[iCurrent+10]=this.sle_ubicacion_leida
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_mercar_tela_pda.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_mesa)
destroy(this.sle_oc)
destroy(this.sle_tot_rollos)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_rollo_leido)
destroy(this.sle_ubicacion_leida)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;ib_sort_asc = True
end event

type dw_maestro from w_base_pda`dw_maestro within w_mercar_tela_pda
integer x = 142
integer y = 420
integer width = 1033
integer height = 716
integer taborder = 0
string dataobject = "dgr_mercada_tela_pda"
end type

event dw_maestro::buttonclicked;call super::buttonclicked;IF dwo.Name = "b_ubicacion" THEN
	IF ib_sort_asc = True THEN
		This.SetSort("ubicacion desc")
		This.Sort()
		ib_sort_asc = False
	ELSE
		This.SetSort("ubicacion asc")
		This.Sort()
		ib_sort_asc = True
	END IF
END IF
end event

type st_1 from statictext within w_mercar_tela_pda
integer x = 23
integer y = 68
integer width = 142
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mesa:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mercar_tela_pda
integer x = 882
integer y = 68
integer width = 123
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.C.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_mercar_tela_pda
integer x = 293
integer y = 1188
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total Rollos Mercados:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mesa from singlelineedit within w_mercar_tela_pda
integer x = 160
integer y = 68
integer width = 718
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//se debe indentificar la mesa y con esto se debe traer la orden de corte
//que segun el pdp tine la menor fecha de inicio y que este activa y en estado
//por mercar
//jcrm - jorodrig
//febrero 25 de 2009
Long li_mesa
String ls_mensaje
Long ll_maquina, ll_oc
n_cst_mercada_tela luo_merca

IF len(sle_mesa.text) > 20 THEN
	//se leyo el codigo de barras del riel, se debe sacar el numero de mesa
	li_mesa = Long(Mid(sle_mesa.text,21))
ELSE
	//se digito la mesa, por parte del usuario de forma manual
	li_mesa = Long(sle_mesa.text)
END IF

//con el numero de mesa, se trae el codigo de la maquina, para poder buscarla en dt_simulacion
ll_maquina = luo_merca.of_determinar_maquina(li_mesa,ls_mensaje)

IF ll_maquina = -1 THEN
	MessageBox('Error',ls_mensaje)
	Return 
ELSE
	//ya se tiene la maquina se debe establecer cual es la orden de corte
	//que segun el pdp debe mercarse
	IF luo_merca.of_determinar_oc(ll_oc,ls_mensaje,ll_maquina) = -1 THEN
		MessageBox('Error',ls_mensaje)
		Return 
	ELSE
		sle_oc.Text = String(ll_oc)
		sle_tot_rollos.Text = '0'
		dw_maestro.retrieve(ll_oc)
	END IF
	
END IF




end event

type sle_oc from singlelineedit within w_mercar_tela_pda
integer x = 1010
integer y = 68
integer width = 293
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type sle_tot_rollos from singlelineedit within w_mercar_tela_pda
integer x = 832
integer y = 1188
integer width = 178
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type st_4 from statictext within w_mercar_tela_pda
integer x = 160
integer y = 160
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tarjeta Rollo "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_mercar_tela_pda
integer x = 681
integer y = 160
integer width = 530
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ubicaci$$HEX1$$f300$$ENDHEX$$n Nueva"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_rollo_leido from singlelineedit within w_mercar_tela_pda
integer x = 160
integer y = 232
integer width = 343
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;//metodo para generar la mercada de los rollos y modificar la ubicacion de los mismos
//jcrm - jorodrig
//marzo 9 de 2009
Long ll_oc_leida, ll_oc_dw, ll_rollo
Long li_fila,li_rollos_mercados
Boolean lb_grabar
String ls_mensaje, ls_ubicacion
n_cst_mercada_tela luo_mercar

IF len(sle_ubicacion_leida.text) > 1 THEN
	//ya se ingreso la ubicacion y se debe mirar si el rollo ingresado corresponde aun rollo
	//en la parte del datawindos
	IF len(sle_rollo_leido.Text) <= 0 THEN
		Return
	END IF
	ll_oc_leida = Long(sle_rollo_leido.Text)
	ib_mercada = False
	
	FOR li_fila = 1 TO dw_maestro.RowCount()
		ll_oc_dw = dw_maestro.GetItemNumber(li_fila,'cs_rollo')
		IF ll_oc_dw = ll_oc_leida THEN
			dw_maestro.SetItem(li_fila,'marca',1) //se coloca marca de leido en el rollo
			dw_maestro.SetItem(li_fila,'ubicacion_nueva',sle_ubicacion_leida.text) //se actualiza la ubicacion del rollo
			
			li_rollos_mercados = Long(sle_tot_rollos.Text)
			sle_tot_rollos.Text = String(li_rollos_mercados + 1)
			
			IF ib_mercada = False THEN
				//se debe colocar la mercada en estado "MERCANDO"
				IF luo_mercar.of_estado_mercada(ll_oc_dw,10,ls_mensaje) = 0 THEN //mercada por mercar
					ib_mercada = True
				ELSE
					Rollback;
					MessageBox('Error Mercando',ls_mensaje)
					Return
				END IF
			END IF
		END IF
	NEXT
	
	//si todos los rollos tienen marca de procesados se debe generar la mercada
	//y actualizar la ubicacion de los rollos
	FOR li_fila = 1 TO dw_maestro.RowCount()
		IF dw_maestro.GetItemNumber(li_fila,'marca') = 0 THEN
		   lb_grabar = False	
			li_fila = dw_maestro.RowCount() + 1
		ELSE
			lb_grabar = True
		END IF
	NEXT
	
	IF lb_grabar = False THEN
		//es porque faltan rollos por leer
	ELSE
		//se leyeron todos los rollos se deben actualizar la mercada y la ubicacion de los rollos
		IF luo_mercar.of_estado_mercada(ll_oc_dw,4,ls_mensaje) = -1 THEN //mercada generada
			Rollback;
			MessageBox('Error Mercada Generada',ls_mensaje)
			Return
		END IF
		
		dw_maestro.AcceptText()
		FOR li_fila = 1 TO dw_maestro.RowCount()
			//actualizar ubicacion rollos
			ll_rollo = dw_maestro.GetItemNumber(li_fila,'cs_rollo')
			ls_ubicacion = dw_maestro.GetItemString(li_fila,'ubicacion_nueva')
			
			IF luo_mercar.of_act_ubicacion_rollo(ll_rollo,ls_ubicacion,ls_mensaje) = -1 THEN
				Rollback;
				MessageBox('Error Ubicaci$$HEX1$$f300$$ENDHEX$$n Rollos',ls_mensaje)
				Return
			END IF
		NEXT
	END IF
END IF

IF lb_grabar = False THEN
	//no se ha realizado el proceso de mercada ya que faltan rollos por procesar.
ELSE
	//ya se leyeron todos los rollos y estos fueron procesados existosamente.
	Commit;
	MessageBox('Exito','Mercada OK.')
END IF
end event

type sle_ubicacion_leida from singlelineedit within w_mercar_tela_pda
integer x = 686
integer y = 232
integer width = 530
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;IF len(sle_rollo_leido.Text) > 1 THEN
	sle_rollo_leido.TriggerEvent(Modified!)
END IF
end event

type gb_1 from groupbox within w_mercar_tela_pda
integer x = 14
integer y = 24
integer width = 1312
integer height = 356
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_mercar_tela_pda
integer x = 128
integer y = 376
integer width = 1074
integer height = 784
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

