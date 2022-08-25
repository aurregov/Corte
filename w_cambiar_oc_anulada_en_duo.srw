HA$PBExportHeader$w_cambiar_oc_anulada_en_duo.srw
forward
global type w_cambiar_oc_anulada_en_duo from w_base_tabular
end type
type st_2 from statictext within w_cambiar_oc_anulada_en_duo
end type
type em_ord_cte from editmask within w_cambiar_oc_anulada_en_duo
end type
type st_3 from statictext within w_cambiar_oc_anulada_en_duo
end type
type st_4 from statictext within w_cambiar_oc_anulada_en_duo
end type
type cb_reemplazar from commandbutton within w_cambiar_oc_anulada_en_duo
end type
type dw_dt_pdnxmodulo from datawindow within w_cambiar_oc_anulada_en_duo
end type
end forward

global type w_cambiar_oc_anulada_en_duo from w_base_tabular
integer width = 3584
integer height = 1732
string title = "Cambiar Oc Anulada en Duo"
st_2 st_2
em_ord_cte em_ord_cte
st_3 st_3
st_4 st_4
cb_reemplazar cb_reemplazar
dw_dt_pdnxmodulo dw_dt_pdnxmodulo
end type
global w_cambiar_oc_anulada_en_duo w_cambiar_oc_anulada_en_duo

type variables
Long	il_orden_corte
end variables

on w_cambiar_oc_anulada_en_duo.create
int iCurrent
call super::create
this.st_2=create st_2
this.em_ord_cte=create em_ord_cte
this.st_3=create st_3
this.st_4=create st_4
this.cb_reemplazar=create cb_reemplazar
this.dw_dt_pdnxmodulo=create dw_dt_pdnxmodulo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.em_ord_cte
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.cb_reemplazar
this.Control[iCurrent+6]=this.dw_dt_pdnxmodulo
end on

on w_cambiar_oc_anulada_en_duo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.em_ord_cte)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_reemplazar)
destroy(this.dw_dt_pdnxmodulo)
end on

event open;//Esta ventana se utiliza para cambiar el consecutivo (cs_unir_oc en dt_pdnxmodulo) que une las ordenes
//de corte hermana (duo o conjunto) generadas juntas desde la liberacion, 
//El usuario primero anula la orden de corte problema, luego genera la nueva orden de corte  y despues
//de generarla ingresa a esta ventana y realiza el cambio, ingresando el numero de la nueva orden y buscando
//en la lista la orden de corte anulada, selecciona la orden y luego presiona el bot$$HEX1$$f300$$ENDHEX$$n reemplazar.
//realizado por jorodrig  junio 22 - 09  solicitado por ingenieria.


This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF


dw_dt_pdnxmodulo.SettransObject(sqlca)
end event

type dw_maestro from w_base_tabular`dw_maestro within w_cambiar_oc_anulada_en_duo
integer x = 9
integer y = 148
integer width = 3493
integer height = 1092
string dataobject = "dtb_cambiar_oc_anulada_en_duo"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type sle_argumento from w_base_tabular`sle_argumento within w_cambiar_oc_anulada_en_duo
boolean visible = false
integer x = 1298
integer y = 36
integer width = 87
end type

type st_1 from w_base_tabular`st_1 within w_cambiar_oc_anulada_en_duo
boolean visible = false
integer x = 1248
integer y = 32
integer width = 73
end type

type st_2 from statictext within w_cambiar_oc_anulada_en_duo
integer x = 14
integer y = 48
integer width = 457
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
string text = "Ord. Cte Nueva:"
boolean focusrectangle = false
end type

type em_ord_cte from editmask within w_cambiar_oc_anulada_en_duo
integer x = 439
integer y = 32
integer width = 430
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

event modified;

il_orden_corte = Long(em_ord_cte.text)


IF dw_maestro.Retrieve(il_orden_corte) > 0 THEN
ELSE
	MessageBox('Advertencia','No se encontr$$HEX2$$f3002000$$ENDHEX$$ordenes de corte anuladas con el mismo estilo de la orden: '+string(il_orden_corte))
END IF

end event

type st_3 from statictext within w_cambiar_oc_anulada_en_duo
integer x = 55
integer y = 1260
integer width = 2290
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
string text = "Ingrese el n$$HEX1$$fa00$$ENDHEX$$mero de la nueva Orden de Corte,  luego seleccione de la lista la Orden de Corte anulada "
boolean focusrectangle = false
end type

type st_4 from statictext within w_cambiar_oc_anulada_en_duo
integer x = 55
integer y = 1324
integer width = 1056
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
string text = "a remplazar y luego presione el bot$$HEX1$$f300$$ENDHEX$$n reemplazar"
boolean focusrectangle = false
end type

type cb_reemplazar from commandbutton within w_cambiar_oc_anulada_en_duo
integer x = 2373
integer y = 1244
integer width = 645
integer height = 128
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Reemplazar"
end type

event clicked;//Se realiza el cambio del consecutivo que une las ordenes de corte duo o conjunto, se toma el numero de 
//la orden de corte que esta anulada y se le coloca este consecutivo a la nueva orden de corte
//jorodrig   junio 23 - 09


LONG	ll_unir_oc, ll_oc_reemplazar
INT	posi
STRING	ls_usuario
DATETIME ldt_fe_hoy

ls_usuario = gstr_info_usuario.codigo_usuario
ldt_fe_hoy = f_fecha_servidor()

ll_unir_oc = dw_maestro.GetItemNumber(il_fila_actual_maestro,'cs_unir_oc')
ll_oc_reemplazar = dw_maestro.GetItemNumber(il_fila_actual_maestro,'cs_asignacion')

IF ll_unir_oc > 1 THEN
ELSE
	MessageBox('Advertencia','La orden de corte no tiene un consecutivo que la una con otra ordenes')
	Return 
END IF

IF MessageBox("Verificacion", "Esta seguro(a) de reemplazar la orden de corte: "+ string(ll_oc_reemplazar)+ "con esta nueva orden de corte:"+string(il_orden_corte), Question!, YesNo!, 2) = 2 THEN
	Return
END IF


dw_dt_pdnxmodulo.Retrieve(il_orden_corte)
FOR posi = 1 TO dw_dt_pdnxmodulo.RowCount()
	dw_dt_pdnxmodulo.SetItem(posi,'cs_unir_oc',ll_unir_oc)
	dw_dt_pdnxmodulo.SetItem(posi,'fe_actualizacion',ldt_fe_hoy)
	dw_dt_pdnxmodulo.SetItem(posi,'usuario',ls_usuario)
NEXT



IF dw_dt_pdnxmodulo.Accepttext() = -1 THEN
		Messagebox("Error","No se pudieron realizar los cambios para unir la orden de corte" &
	           ,Exclamation!,Ok!)	
	RETURN -1
ELSE
	IF dw_dt_pdnxmodulo.Update() = -1 THEN
		ROLLBACK;
	   RETURN -2
	ELSE
		COMMIT;
		MessageBox('O.K.','Se realizaron los cambios exitosamente')
	END IF
END IF

RETURN 1
end event

type dw_dt_pdnxmodulo from datawindow within w_cambiar_oc_anulada_en_duo
boolean visible = false
integer x = 1157
integer y = 1396
integer width = 974
integer height = 108
integer taborder = 21
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_mantenimiento_dt_pdnxmodulo_x_oc"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

