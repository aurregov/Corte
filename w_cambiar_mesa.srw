HA$PBExportHeader$w_cambiar_mesa.srw
forward
global type w_cambiar_mesa from w_base_simple
end type
type st_1 from statictext within w_cambiar_mesa
end type
type em_mercada from editmask within w_cambiar_mesa
end type
type dw_tallas from datawindow within w_cambiar_mesa
end type
end forward

global type w_cambiar_mesa from w_base_simple
integer width = 2798
integer height = 608
string menuname = "m_cambiar_mesa"
st_1 st_1
em_mercada em_mercada
dw_tallas dw_tallas
end type
global w_cambiar_mesa w_cambiar_mesa

type variables
Long ii_tipoproducto, ii_centro, ii_estado, ii_subcentro
end variables

on w_cambiar_mesa.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_cambiar_mesa" then this.MenuID = create m_cambiar_mesa
this.st_1=create st_1
this.em_mercada=create em_mercada
this.dw_tallas=create dw_tallas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_mercada
this.Control[iCurrent+3]=this.dw_tallas
end on

on w_cambiar_mesa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_mercada)
destroy(this.dw_tallas)
end on

event open;call super::open;n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

ii_tipoproducto = luo_constantes.of_consultar_numerico("PRENDAS")
IF ii_tipoproducto = -1 THEN
	Close(This)
	Return
END IF

ii_centro = luo_constantes.of_consultar_numerico("CENTRO CORTE")
IF ii_centro = -1 THEN
	Close(This)	
	Return
END IF

ii_subcentro = luo_constantes.of_consultar_numerico("SUBCENTRO EXTENDIDO")
IF ii_subcentro = -1 THEN
	Close(This)	
	Return
END IF

ii_estado = luo_constantes.of_consultar_numerico("ESTADO LIB PROG")

IF ii_estado = -1 THEN
	Close(This)
	Return
END IF

Destroy luo_constantes

IF dw_tallas.SetTransObject(SQLCA) = -1 THEN
	MessageBox("Error DataWindow", "Error asignando transacci$$HEX1$$f300$$ENDHEX$$n a tallas")
	Close(This)
END IF
end event

event ue_grabar;Long li_filas, li_mesa

IF dw_maestro.AcceptText() = -1 THEN
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" ,Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_maestro.Update() = -1 THEN
		Messagebox("Error","No se pudieron realizar los cambios en la base de datos", Exclamation!,Ok!)			
		ROLLBACK;
	   RETURN
	ELSE
		li_mesa = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_modulo")
		FOR li_filas = 1 TO dw_tallas.RowCount()
			dw_tallas.SetItem(li_filas, "co_modulo", li_mesa)			
		NEXT
		IF dw_tallas.Update() = -1 THEN
			Messagebox("Error","No se pudieron realizar los cambios en la base de datos", Exclamation!,Ok!)			
			ROLLBACK;
	   	RETURN			
		ELSE
			COMMIT;
		END IF
	END IF
END IF

RETURN 1
end event

type dw_maestro from w_base_simple`dw_maestro within w_cambiar_mesa
integer x = 37
integer y = 128
integer width = 2702
integer height = 228
string dataobject = "dff_mercada"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type st_1 from statictext within w_cambiar_mesa
integer x = 46
integer y = 28
integer width = 283
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
boolean focusrectangle = false
end type

type em_mercada from editmask within w_cambiar_mesa
integer x = 329
integer y = 28
integer width = 343
integer height = 72
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
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###############"
end type

event modified;Long li_fabrica, li_planta
Long ll_mercada, ll_ordencorte
n_cts_ocfabrica luo_oc

IF IsNumber(em_mercada.Text) THEN
	ll_mercada = Long(em_mercada.Text)
	IF dw_maestro.Retrieve(ll_mercada, ii_estado) > 0 THEN
		li_fabrica = dw_maestro.GetItemNumber(1, "co_fabrica")
		li_planta = dw_maestro.GetItemNumber(1, "co_planta")
		f_rcpra_dtos_dddw_param4(dw_maestro, "co_modulo", SQLCA, li_fabrica, li_planta, ii_tipoproducto, ii_centro, ii_subcentro)
		ll_ordencorte = dw_maestro.GetItemNumber(1, "cs_orden_corte")
		
		
		IF luo_oc.of_validarocfabrica(ll_ordencorte) = -1 THEN
			Return
		END IF
		
		dw_tallas.Retrieve(ll_ordencorte)
		il_fila_actual_maestro = 1
	END IF
END IF
end event

type dw_tallas from datawindow within w_cambiar_mesa
boolean visible = false
integer x = 658
integer y = 24
integer width = 1285
integer height = 148
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "dtb_tallas_produccion"
boolean vscrollbar = true
end type

