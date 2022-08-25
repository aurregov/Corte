HA$PBExportHeader$w_cortar_rollo.srw
forward
global type w_cortar_rollo from w_base_simple
end type
type st_1 from statictext within w_cortar_rollo
end type
type st_2 from statictext within w_cortar_rollo
end type
type em_mercada from editmask within w_cortar_rollo
end type
type em_rollo from editmask within w_cortar_rollo
end type
type dw_adhesivo from datawindow within w_cortar_rollo
end type
type st_3 from statictext within w_cortar_rollo
end type
type em_raya from editmask within w_cortar_rollo
end type
end forward

global type w_cortar_rollo from w_base_simple
integer width = 2871
integer height = 692
string title = "Cortar Rollo Mercada"
st_1 st_1
st_2 st_2
em_mercada em_mercada
em_rollo em_rollo
dw_adhesivo dw_adhesivo
st_3 st_3
em_raya em_raya
end type
global w_cortar_rollo w_cortar_rollo

type variables
Long ii_pendcortar, ii_cortado, ii_pormercar, ii_yamercada
end variables

forward prototypes
public function long of_sacar_patir_sist_nuevo (long al_mercada, long al_rollo, long ai_raya)
end prototypes

public function long of_sacar_patir_sist_nuevo (long al_mercada, long al_rollo, long ai_raya);//Esta funcion se hizo para actualizar el rollo como partido en el sistema nuevo de partido
//de rollos, esto porque hay rollos que aun se parten por el sistema viejo y estan saliendo
//en la lista de rollos a patir.  jorodrig   mayo 6 - 09

Long	li_existe

SELECT COUNT(*)
  INTO :li_existe
  FROM temp_rollos_partir
 WHERE proceso = 4
   AND partido_fisico = 'f'
	AND cs_rollo_padre = :al_rollo
	AND cs_mercada 	 = :al_mercada
	AND raya           = :ai_raya;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al consultar si el rollo esta por partir en sistema nuevo " + SQLCA.SQLErrText)
	Return -1
END IF


IF li_existe > 0 THEN
	UPDATE temp_rollos_partir
		SET partido_fisico = 't'
	 WHERE proceso = 4
		AND partido_fisico = 'f'
		AND cs_rollo_padre = :al_rollo
		AND cs_mercada 	 = :al_mercada
		AND raya           = :ai_raya;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al actualizar el estado del rollo a partido en sistema nuevo " + SQLCA.SQLErrText)
		Return -1
	END IF
	
END IF
	
Return 1
end function

on w_cortar_rollo.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.em_mercada=create em_mercada
this.em_rollo=create em_rollo
this.dw_adhesivo=create dw_adhesivo
this.st_3=create st_3
this.em_raya=create em_raya
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_mercada
this.Control[iCurrent+4]=this.em_rollo
this.Control[iCurrent+5]=this.dw_adhesivo
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_raya
end on

on w_cortar_rollo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_mercada)
destroy(this.em_rollo)
destroy(this.dw_adhesivo)
destroy(this.st_3)
destroy(this.em_raya)
end on

event open;call super::open;n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

ii_pendcortar = luo_constantes.of_consultar_numerico("ESTADO CORTANDO")

IF ii_pendcortar = -1 THEN
	Close(This)
	Return
END IF

ii_cortado = luo_constantes.of_consultar_numerico("ESTADO CORTADO")

IF ii_cortado = -1 THEN
	Close(This)
	Return
END IF

ii_pormercar = luo_constantes.of_consultar_numerico("ESTADO X MERCAR")
ii_yamercada = luo_constantes.of_consultar_numerico("ESTADO MERCADA")

IF ii_cortado = -1 THEN
	Close(This)
	Return
END IF

dw_adhesivo.SetTransObject(SQLCA)
end event

event ue_grabar;Decimal{2} ld_metros, ld_metros_cortar, ld_mt_rollo, ld_kg_rollo, ld_ancho_std
Long ll_unidades, ll_unidades_cortar, ll_rollo, ll_mercada, ll_rollo_hijo
Decimal{2} ld_kilos_cortar
Long li_raya
n_cst_rollo luo_rollo

IF il_fila_actual_maestro > 0 THEN
	dw_maestro.AcceptText()
	ll_mercada = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_mercada")	
	ll_rollo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_rollo")
	li_raya = dw_maestro.GetItemNumber(il_fila_actual_maestro, "raya")
	ld_metros = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_metros_mercar")
	ld_mt_rollo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "m_rollo_ca_mt")
	ld_kg_rollo = dw_maestro.GetItemNumber(il_fila_actual_maestro, "m_rollo_ca_kg")
	ld_ancho_std = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ancho_std") 
	ld_metros_cortar = dw_maestro.GetItemNumber(il_fila_actual_maestro, "metros_cortados")
	IF ld_mt_rollo > 0 THEN
		ld_kilos_cortar = (ld_metros_cortar * ld_kg_rollo) / ld_mt_rollo
	ELSE
		ld_kilos_cortar = dw_maestro.GetItemNumber(il_fila_actual_maestro, "kilos_cortados")
	END IF
	IF (ld_kilos_cortar > 0) THEN
	ELSE
		IF ld_kg_rollo > 0 THEN
			MessageBox('Advertencia','Los kilos del rollo van a quedar en cero, Verifique')
			Return
		END IF
	END IF
	
	//cuando se parte por sistema viejo hay que actualizar en sistema nuevo el rollo como
	//partido para que no siga apareciendo   jorodrig   mayo  6 - 09
	IF of_sacar_patir_sist_nuevo(ll_mercada, ll_rollo, li_raya) = -1 THEN   //error se sale
		Return
	END IF
	
	
	//ld_kilos_cortar = dw_maestro.GetItemNumber(il_fila_actual_maestro, "kilos_cortados")
	ll_unidades = dw_maestro.GetItemNumber(il_fila_actual_maestro, "ca_unidades_mercar")
	ll_unidades_cortar = dw_maestro.GetItemNumber(il_fila_actual_maestro, "unidades_cortadas")
	IF ld_metros <> ld_metros_cortar OR ll_unidades <> ll_unidades_cortar THEN
		MessageBox("Advertencia...","El n$$HEX1$$fa00$$ENDHEX$$mero de metros o unidades no corresponde con lo asignado en la mercada")
		Return
	ELSE
		luo_rollo = Create n_cst_rollo
		ll_rollo_hijo = luo_rollo.of_cortar_rollo(ll_mercada, ii_pormercar, ll_rollo, ld_metros_cortar, ld_kilos_cortar, ll_unidades_cortar, li_raya, ii_cortado,ld_ancho_std)
		IF ll_rollo_hijo <> -1 THEN
			IF luo_rollo.of_actualizar_mercada(ll_mercada, ll_rollo, ii_cortado, ii_pendcortar, ii_yamercada, li_raya) THEN

				COMMIT;
				MessageBox("Cortado","Rollo cortado")
				dw_maestro.Reset()
				dw_adhesivo.Retrieve(ll_rollo_hijo)
			//	dw_adhesivo.Print()
				
				dw_adhesivo.Reset()
			ELSE
				ROLLBACK;
			END IF
		ELSE
			ROLLBACK;
		END IF
	END IF
END IF
end event

event ue_insertar_maestro;// Se omite el script
end event

event ue_borrar_maestro;// Se omite el script
end event

event closequery;// Se omite el script
end event

type dw_maestro from w_base_simple`dw_maestro within w_cortar_rollo
integer x = 37
integer y = 128
integer width = 2775
integer height = 336
integer taborder = 40
string dataobject = "dff_informacion_rollo"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::itemchanged;// Se omite el script
Long	ll_unid_cortar,ll_unid_rollo
Decimal ld_kg_rollo, ld_kg_cortar

//se establecen los kilos o unidades que figuran liberados y el centro del rollo
choose case dwo.name
	case 'unidades_cortadas'
		ll_unid_cortar = Long(Data)
		
		ld_kg_rollo = This.GetitemNumber(row,'m_rollo_ca_kg')
		ll_unid_rollo = This.GetitemNumber(row,'m_rollo_ca_unidades')
		
		IF ll_unid_rollo > 0 THEN
			ld_kg_cortar = ((ll_unid_cortar * 	ld_kg_rollo) / ll_unid_rollo)
			dw_maestro.SetItem(row,'kilos_cortados',ld_kg_cortar)
		END IF

		
end choose

end event

type st_1 from statictext within w_cortar_rollo
integer x = 658
integer y = 24
integer width = 155
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rollo:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cortar_rollo
integer x = 37
integer y = 24
integer width = 233
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mercada:"
boolean focusrectangle = false
end type

type em_mercada from editmask within w_cortar_rollo
integer x = 261
integer y = 24
integer width = 343
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#######"
end type

event modified;Long ll_mercada, ll_rollo
Long li_raya

IF IsNumber(em_mercada.Text) THEN
	ll_mercada = Long(em_mercada.Text)
	IF ll_mercada <> 0 THEN
		IF IsNumber(em_rollo.Text) THEN
			ll_rollo = Long(em_rollo.Text)
			IF ll_rollo <> 0 THEN
				li_raya = Long(em_raya.Text)				
				IF li_raya <> 0 THEN
					dw_maestro.Retrieve(ll_mercada, ll_rollo, ii_pendcortar, li_raya)
				END IF
			END IF
		END IF
	END IF
END IF
end event

type em_rollo from editmask within w_cortar_rollo
integer x = 800
integer y = 24
integer width = 343
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

event modified;Long ll_mercada, ll_rollo
Long li_raya

IF IsNumber(em_mercada.Text) THEN
	ll_mercada = Long(em_mercada.Text)
	IF ll_mercada <> 0 THEN
		IF IsNumber(em_rollo.Text) THEN
			ll_rollo = Long(em_rollo.Text)
			IF ll_rollo <> 0 THEN
				li_raya = Long(em_raya.Text)				
				IF li_raya <> 0 THEN
					dw_maestro.Retrieve(ll_mercada, ll_rollo, ii_pendcortar, li_raya)
				END IF
			END IF
		END IF
	END IF
END IF
end event

type dw_adhesivo from datawindow within w_cortar_rollo
boolean visible = false
integer x = 1737
integer y = 20
integer width = 686
integer height = 88
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "dff_ficho_rollo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cortar_rollo
integer x = 1170
integer y = 24
integer width = 155
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Raya:"
boolean focusrectangle = false
end type

type em_raya from editmask within w_cortar_rollo
integer x = 1312
integer y = 24
integer width = 169
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##########"
end type

event modified;Long ll_mercada, ll_rollo
Long li_raya

IF IsNumber(em_mercada.Text) THEN
	ll_mercada = Long(em_mercada.Text)
	IF ll_mercada <> 0 THEN
		IF IsNumber(em_rollo.Text) THEN
			ll_rollo = Long(em_rollo.Text)
			IF ll_rollo <> 0 THEN
				li_raya = Long(em_raya.Text)				
				IF li_raya <> 0 THEN
					IF dw_maestro.Retrieve(ll_mercada, ll_rollo, ii_pendcortar, li_raya) > 0 THEN
						il_fila_actual_maestro = 1
					ELSE
						il_fila_actual_maestro = 0
					END IF
				END IF
			END IF
		END IF
	END IF
END IF
end event

