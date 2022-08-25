HA$PBExportHeader$w_atender_reposicion.srw
forward
global type w_atender_reposicion from w_base_maestrotb_detalletb
end type
end forward

global type w_atender_reposicion from w_base_maestrotb_detalletb
integer width = 2551
integer height = 2000
string title = "Atender Reposici$$HEX1$$f300$$ENDHEX$$n Tela"
end type
global w_atender_reposicion w_atender_reposicion

type variables
Long ii_rectilineo1, ii_rectilineo2, ii_estado, ii_rechazado, ii_aceptada
Decimal {2} id_porcentaje
DataStore ids_telas_reposicion
end variables

forward prototypes
public function boolean of_asignar_rollos ()
end prototypes

public function boolean of_asignar_rollos ();Long ll_reftel, ll_reftel_act, ll_unidades, ll_unidades_reposicion, ll_unidades_total
Long ll_rollos[], ll_rollo, ll_reposicion, ll_unidades_rollo[], ll_orden_corte
Long ll_unidadeslib, ll_unidades_liberadas[], ll_color, ll_color_act
Long li_caract, li_caract_act, li_fila_actual, li_rollos
Long li_atendida, li_talla, li_talla_act
Decimal{2} ld_metros, ld_metros_reposicion, ld_metros_total, ld_metros_rollo[]
Decimal{2} ld_metroslib, ld_metros_liberados[]
String ls_busqueda
n_cst_rollo luo_rollo

li_fila_actual = 1
ll_reposicion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_reposicion")
ll_orden_corte = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_orden_corte")
ll_reftel_act = 0
li_caract_act = 0
ll_color_act = 0
ld_metros_total = 0
ll_unidades_total = 0
ll_unidades_reposicion = 0
ld_metros_reposicion = 0
li_rollos = 0
DO WHILE li_fila_actual <= dw_detalle.RowCount()
	ld_metros = dw_detalle.GetItemNumber(li_fila_actual, "metros_asignados")
	ll_unidades = dw_detalle.GetItemNumber(li_fila_actual, "unidades_asignadas")	
	IF ld_metros > 0 OR ll_unidades > 0 THEN
		ll_rollo = dw_detalle.GetItemNumber(li_fila_actual, "cs_rollo")
		ll_reftel = dw_detalle.GetItemNumber(li_fila_actual, "co_reftel_act")
		li_caract = dw_detalle.GetItemNumber(li_fila_actual, "co_caract_act")
		ll_color = dw_detalle.GetItemNumber(li_fila_actual, "co_color_act")
		li_talla = dw_detalle.GetItemNumber(li_fila_actual, "co_talla")
		IF ld_metros = 0 AND ll_unidades = 0 THEN
			MessageBox("Advertencia...","El rollo: " + String(ll_rollo) + " no tiene metros o unidades asignadas")
			Return False
		END IF
		li_rollos = li_rollos + 1		
		ll_rollos[li_rollos] = ll_rollo
		ld_metros_rollo[li_rollos] = ld_metros
		ll_unidades_rollo[li_rollos] = ll_unidades
		ld_metros_liberados[li_rollos] = dw_detalle.GetItemNumber(li_fila_actual, "metros_liberados")
		ll_unidades_liberadas[li_rollos] = dw_detalle.GetItemNumber(li_fila_actual, "unidades_liberadas")		
		IF ll_reftel = ll_reftel_act AND li_caract = li_caract_act AND ll_color = ll_color_act AND &
			li_talla = li_talla_act THEN
			ld_metros_total = ld_metros_total + ld_metros
			ll_unidades_total = ll_unidades_total + ll_unidades
		ELSE
			
// Si el codigo de la tela es cero estamos en la primer fila y no debemos hacer nada

			IF ll_reftel_act <> 0 THEN
				IF ld_metros_total > ld_metros_reposicion OR ll_unidades_total > ll_unidades_reposicion THEN
					MessageBox("Advertencia...","El total de metros o unidades que est$$HEX2$$e1002000$$ENDHEX$$asignando para la tela: " + String(ll_reftel_act) + " caracter$$HEX1$$ed00$$ENDHEX$$stica: " + String(li_caract_act) + " color: " + String(ll_color_act) + " es mayor de la requerida")
					Return False
				ELSE
					
// Vamos a actualizar en el DataStore de telas de la reposici$$HEX1$$f300$$ENDHEX$$n la tela a la que se le asigno
// los rollos. Esto para poder verificar al final que a todas las telas de la reposici$$HEX1$$f300$$ENDHEX$$n se les
// asignaron rollos.

					ls_busqueda = "co_reftel = " + String(ll_reftel_act) + " and co_caract = " + String(li_caract_act) + " and co_color = " + String(ll_color_act) + " and co_talla = " + String(li_talla_act)
					ids_telas_reposicion.SetFilter(ls_busqueda)
					ids_telas_reposicion.Filter()
					IF ids_telas_reposicion.RowCount() = 1 THEN
						ids_telas_reposicion.SetItem(ids_telas_reposicion.GetRow(), "atendida", 1)
					ELSE
						MessageBox("Error...","No se pudo encontrar la tela en las telas de la reposici$$HEX1$$f300$$ENDHEX$$n")
						Return False
					END IF
					ids_telas_reposicion.SetFilter("")
					ids_telas_reposicion.Filter()					
				END IF
			END IF
			ll_reftel_act = ll_reftel
			li_caract_act = li_caract
			ll_color_act = ll_color
			li_talla_act = li_talla
			ld_metros_total = ld_metros
			ll_unidades_total = ll_unidades
			ld_metros_reposicion = dw_detalle.GetItemNumber(li_fila_actual, "ca_metros_reposi")
			ll_unidades_reposicion = dw_detalle.GetItemNumber(li_fila_actual, "ca_unidades_reposi")
		END IF
	END IF
	li_fila_actual = li_fila_actual + 1
LOOP

// Verificamos la ultima tela.

IF ld_metros_total > ld_metros_reposicion OR ll_unidades_total > ll_unidades_reposicion THEN
	MessageBox("Advertencia...","El total de metros o unidades que est$$HEX2$$e1002000$$ENDHEX$$asignando para la tela: " + String(ll_reftel_act) + " caracter$$HEX1$$ed00$$ENDHEX$$stica: " + String(li_caract_act) + " color: " + String(ll_color_act) + " es mayor de la requerida")
	Return False
ELSE
	
// Vamos a actualizar en el DataStore de telas de la reposici$$HEX1$$f300$$ENDHEX$$n la tela a la que se le asigno
// los rollos. Esto para poder verificar al final que a todas las telas de la reposici$$HEX1$$f300$$ENDHEX$$n se les
// asignaron rollos.

	ls_busqueda = "co_reftel = " + String(ll_reftel_act) + " and co_caract = " + String(li_caract_act) + " and co_color = " + String(ll_color_act) + " and co_talla = " + String(li_talla_act)
	ids_telas_reposicion.SetFilter(ls_busqueda)
	ids_telas_reposicion.Filter()
	IF ids_telas_reposicion.RowCount() = 1 THEN
		ids_telas_reposicion.SetItem(ids_telas_reposicion.GetRow(), "atendida", 1)
	ELSE
		MessageBox("Error...","No se pudo encontrar la tela en las telas de la reposici$$HEX1$$f300$$ENDHEX$$n")
		Return False
	END IF
END IF

// Antes de asignar los rollos, verificamos que a todas las telas se les asinaron rollos.
ids_telas_reposicion.SetFilter("")
ids_telas_reposicion.Filter()
FOR li_fila_actual = 1 TO ids_telas_reposicion.RowCount()
	li_atendida = ids_telas_reposicion.GetItemNumber(li_fila_actual, "atendida")
	IF li_atendida = 0 THEN
		ll_reftel = ids_telas_reposicion.GetItemNumber(li_fila_actual, "co_reftel")
		li_caract = ids_telas_reposicion.GetItemNumber(li_fila_actual, "co_caract")
		ll_color = ids_telas_reposicion.GetItemNumber(li_fila_actual, "co_color")
		li_talla = ids_telas_reposicion.GetItemNumber(li_fila_actual, "co_talla")
		MessageBox("Advertencia...","La tela " + String(ll_reftel) + " caracter$$HEX1$$ed00$$ENDHEX$$stica: " + String(li_caract) + " color: " + String(ll_color) + " talla: " + String(li_talla) + " no tiene rollos asignados")
		Return False
	END IF
NEXT

// Asignamos los rollos a la reposici$$HEX1$$f300$$ENDHEX$$n

luo_rollo = Create n_cst_rollo
IF Not luo_rollo.of_asignar_rollos_reposicion(ll_orden_corte, ll_reposicion, &
		ll_rollos, ld_metros_rollo, ll_unidades_rollo, li_rollos, ld_metros_liberados, &
		ll_unidades_liberadas) THEN
	Return False
END IF

Destroy luo_rollo
Return True
end function

on w_atender_reposicion.create
call super::create
end on

on w_atender_reposicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;n_cts_constantes luo_constantes

This.width = 2551
This.height = 2000
This.x = 1
This.y = 1

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

luo_constantes = Create n_cts_constantes

id_porcentaje = luo_constantes.of_consultar_numerico("ADICION TELA PROG")

IF id_porcentaje = -1 THEN
	Close(This)
	Return
END IF

ii_rectilineo1 = luo_constantes.of_consultar_numerico("RECTILINEO 1")

IF ii_rectilineo1 = -1 THEN
	Close(This)
	Return
END IF

ii_rectilineo2 = luo_constantes.of_consultar_numerico("RECTILINEO 2")

IF ii_rectilineo2 = -1 THEN
	Close(This)
	Return
END IF

ii_estado = luo_constantes.of_consultar_numerico("ESTADO REPOSICION")

IF ii_estado = -1 THEN
	Close(This)
	Return
END IF

ii_rechazado = luo_constantes.of_consultar_numerico("REPOSICION RECHAZADA")

IF ii_rechazado = -1 THEN
	Close(This)
	Return
END IF

ii_aceptada = luo_constantes.of_consultar_numerico("REPOSICION ACEPTADA")

IF ii_aceptada = -1 THEN
	Close(This)
	Return
END IF

dw_maestro.SetTransObject(SQLCA)

dw_detalle.SetTransObject(SQLCA)

ids_telas_reposicion = Create DataStore

ids_telas_reposicion.DataObject = 'dtb_telas_reposicion'

IF ids_telas_reposicion.SetTransObject(SQLCA) = -1 THEN
	MessageBox("Error","Error al definir la transacci$$HEX1$$f300$$ENDHEX$$n de las telas de la reposici$$HEX1$$f300$$ENDHEX$$n")
	Close(This)
END IF

dw_maestro.Retrieve(ii_estado)
end event

event ue_borrar_maestro;IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SetItem(il_fila_actual_maestro, "co_estadoreposicion", ii_rechazado)
	This.TriggerEvent("ue_grabar")
END IF
end event

event ue_insertar_detalle;//Se omite el script
end event

event ue_insertar_maestro;//Se omite el script
end event

event ue_grabar;Long ll_reposicion
Long li_estado


IF il_fila_actual_maestro > 0 THEN
	li_estado = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_estadoreposicio")
	IF li_estado = ii_rechazado THEN
		IF dw_maestro.AcceptText() = 1 THEN
			IF dw_maestro.Update() = 1 THEN
				COMMIT;
				dw_maestro.Retrieve(ii_estado)
			ELSE
				MessageBox("Error","Error al actualizar la informaci$$HEX1$$f300$$ENDHEX$$n de la reposici$$HEX1$$f300$$ENDHEX$$n")
				ROLLBACK;
			END IF
		ELSE
			MessageBox("Error","Error al actualizar la informaci$$HEX1$$f300$$ENDHEX$$n de la reposici$$HEX1$$f300$$ENDHEX$$n en la DW")
			ROLLBACK;
		END IF
	ELSE
		dw_maestro.AcceptText()
		dw_detalle.AcceptText()
		IF of_asignar_rollos() THEN
			dw_maestro.SetItem(il_fila_actual_maestro, "co_estadoreposicio", ii_aceptada)
			dw_maestro.SetItem(il_fila_actual_maestro, "co_usuario", gstr_info_usuario.codigo_usuario)
			IF dw_maestro.AcceptText() = 1 THEN
				IF dw_maestro.Update() = 1 THEN
					COMMIT;
					dw_maestro.Retrieve(ii_estado)
				ELSE
					ROLLBACK;
					MessageBox("Error","Error al actualizar la informacion de la reposici$$HEX1$$f300$$ENDHEX$$n")
				END IF
			ELSE
				ROLLBACK;
				MessageBox("Error","Error al actualizar la informaci$$HEX1$$f300$$ENDHEX$$n de la reposici$$HEX1$$f300$$ENDHEX$$n en la datawindow")
			END IF
		ELSE
			ROLLBACK;
		END IF
	END IF
END IF
end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_atender_reposicion
integer x = 27
integer y = 24
integer width = 2464
integer height = 520
boolean titlebar = false
string dataobject = "dtb_reposiciones_pendientes"
boolean hscrollbar = false
boolean livescroll = false
end type

event dw_maestro::rowfocuschanged;Integer	pos
Decimal{3}	ld_mts_disp
Long ll_reposicion, ll_unidades_dis

This.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = This.GetRow()
This.SetRow(il_fila_actual_maestro)
This.SelectRow(il_fila_actual_maestro,TRUE)

IF il_fila_actual_maestro > 0 THEN
	ll_reposicion = dw_maestro.GetItemNumber(il_fila_actual_maestro, "cs_reposicion")
	dw_detalle.Retrieve(ll_reposicion, ii_rectilineo1, ii_rectilineo2, gstr_info_usuario.co_planta_pro)
	FOR pos = 1 TO dw_detalle.RowCount()
		ld_mts_disp = dw_detalle.GetItemNumber(pos,'metros_disp')
		dw_detalle.SetItem(pos,'metros_asignados',ld_mts_disp)
		ll_unidades_dis =  dw_detalle.GetItemNumber(pos,'unidades_disp')
		dw_detalle.SetItem(pos,'unidades_asignadas',ll_unidades_dis)
	NEXT
	
	dw_detalle.accepttext()
	ids_telas_reposicion.Retrieve(ll_reposicion, ii_rectilineo1, ii_rectilineo2)
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_atender_reposicion
boolean visible = false
boolean enabled = false
end type

type st_1 from w_base_maestrotb_detalletb`st_1 within w_atender_reposicion
boolean visible = false
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_atender_reposicion
integer x = 27
integer y = 560
integer width = 2464
integer height = 1248
boolean titlebar = false
string dataobject = "dtb_rollos_tela_reposicion"
end type

event dw_detalle::itemchanged;Decimal{2} ld_metrosrollo, ld_metros
Long ll_unidadesrollo, ll_unidades

This.AcceptText()
IF Dwo.Name = 'metros_asignados' THEN
	ld_metrosrollo = This.GetItemNumber(Row, "metros_disp")
	ld_metros = This.GetItemNumber(Row, "metros_asignados")
	IF ld_metros > ld_metrosrollo THEN
		MessageBox("Advertencia...","Los metros a asignar no pueden ser mayores a los metros disponibles del rollo")
		This.SetItem(Row, "metros_asignados", 0)
		Return 1
	END IF
END IF
IF Dwo.Name = 'unidades_asignadas' THEN
	ld_metrosrollo = This.GetItemNumber(Row, "unidades_disp")
	ld_metros = This.GetItemNumber(Row, "unidades_asignadas")
	IF ld_metros > ld_metrosrollo THEN
		MessageBox("Advertencia...","Las unidades a asignar no pueden ser mayores a las unidades disponibles del rollo")
		This.SetItem(Row, "unidades_asignadas", 0)
		Return 1
	END IF
END IF
end event

event dw_detalle::itemfocuschanged;// Se omite el script
end event

event dw_detalle::clicked;IF Row > 0 THEN
	IF This.IsSelected(Row) THEN
		This.SelectRow(Row, False)
	ELSE
		This.SelectRow(Row, True)
	END IF
END IF
end event

event dw_detalle::doubleclicked;	dw_detalle.SetItem(row,'metros_asignados',0)
end event

event dw_detalle::rowfocuschanged;// Se omite el script
end event

