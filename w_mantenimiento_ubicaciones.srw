HA$PBExportHeader$w_mantenimiento_ubicaciones.srw
forward
global type w_mantenimiento_ubicaciones from w_base_tabular
end type
end forward

global type w_mantenimiento_ubicaciones from w_base_tabular
integer width = 2139
integer height = 2184
string title = "Mantenimiento Ubicaciones"
end type
global w_mantenimiento_ubicaciones w_mantenimiento_ubicaciones

on w_mantenimiento_ubicaciones.create
call super::create
end on

on w_mantenimiento_ubicaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;This.width = 2139
This.height = 2184

//IF gstr_info_usuario.codigo_usuario = 'scgirald' or  gstr_info_usuario.codigo_usuario = 'cepulgar' or gstr_info_usuario.codigo_usuario = 'scgirald'  THEN
//ELSE
//	MessageBox('Advertencia','No tiene permisos')
//	Close(this)
//END IF
end event

event ue_borrar_maestro;long ll_fila, ll_tot_rollos

///////////////////////////////////////////////////////////////////
// Identifica la fila activa y la evalua, si la fila activa
// es mayor que cero, evalua mensaje de confirmacion y
// ademas evalua el delete y si este es valido, dispara el grabar,para
// que la fila sea borrada de la base de datos.
///////////////////////////////////////////////////////////////////

//ll_fila=dw_maestro.GetRow()
ll_fila=il_fila_actual_maestro

//Verificar que no tenga rollos en la ubicacion
ll_tot_rollos = LONG(dw_maestro.GetItemString(ll_fila, "tot_rollos"))
IF ll_tot_rollos > 0 THEN
	MessageBox("Advertencia","No Puede borrar una ubicacion que tiene rollos ",StopSign!,Ok!)
	Return 1
END IF

CHOOSE CASE ll_fila
	CASE -1
		MessageBox("Error de datawindow","No se pudo obtener la fila a borrar del maestro ",StopSign!,Ok!)
	CASE 0
		MessageBox("Advertencia","No se ha seleccionado la fila a borrar del maestro",Exclamation!,Ok!)
	CASE ELSE
		IF (MessageBox("Borrar fila ...","Esta seguro de borrar esta fila del maestro",Question!,YesNo!) = 1) THEN
			IF (dw_maestro.DeleteRow(ll_fila) = -1) THEN
				messagebox("Error datawindow","No pudo borrar del maestro",&
				            StopSign!,Ok!)
			ELSE
				This.TriggerEvent("ue_grabar")
   		END IF
		ELSE
		END IF
END CHOOSE



end event

event ue_insertar_maestro;call super::ue_insertar_maestro;IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", Date(Today()))
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)	
END IF
end event

type dw_maestro from w_base_tabular`dw_maestro within w_mantenimiento_ubicaciones
integer x = 23
integer y = 148
integer width = 1952
integer height = 1784
string dataobject = "dtb_mantenimiento_ubicaciones"
end type

event dw_maestro::retrieveend;call super::retrieveend;String	ls_ubicacion, ls_ubicaciones
Long		li_acumulado
Long  li_fila, li_tot_fila


DECLARE ubicaciones CURSOR FOR
 SELECT ubicacion, count(*)
   FROM m_rollo
  WHERE co_centro in (6,7,10,12,15,50,60)
    AND ubicacion is not null
	 AND ca_kg > 0
	 AND co_estado_rollo <> 6
 GROUP BY 1
 ORDER BY 1;
OPEN ubicaciones;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al abrir el cursor de ubicaciones")
	Return(1)
END IF
FETCH ubicaciones INTO :ls_ubicaciones, :li_acumulado;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Error Base Datos","Error al leer el primer registro del cursor de ubicaciones")
	Return(1)
END IF
DO WHILE SQLCA.SQLCode = 0
	
	li_tot_fila =  dw_maestro.RowCount()
	FOR li_fila = 1 TO li_tot_fila
		ls_ubicacion = dw_maestro.GetItemString(li_fila, "co_ubicacion")
		IF TRIM(ls_ubicacion) = TRIM(ls_ubicaciones) THEN
			dw_maestro.SetItem(li_fila, "tot_rollos", string(li_acumulado))
			EXIT;
		END IF
	NEXT		
	FETCH ubicaciones INTO :ls_ubicaciones, :li_acumulado;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer registro del cursor de l$$HEX1$$ed00$$ENDHEX$$neas")
		Return(1)
	END IF		
LOOP


end event

event dw_maestro::itemchanged;call super::itemchanged;STRING	ls_ubicacion, ls_ubicacion_creada
LONG		posi

Choose Case Dwo.Name
	Case "co_ubicacion"		
		ls_ubicacion = STRING(DATA)
		
		FOR posi = 1 TO dw_maestro.RowCount()
			ls_ubicacion_creada = dw_maestro.GetItemString(posi,'co_ubicacion')
			IF TRIM(ls_ubicacion_creada) = TRIM(ls_ubicacion) THEN
				MessageBox('Advertencia','La ubicacion que esta creando ya existe, Verifique')
				Return 1
			END IF
			
		NEXT
End choose
end event

type sle_argumento from w_base_tabular`sle_argumento within w_mantenimiento_ubicaciones
end type

type st_1 from w_base_tabular`st_1 within w_mantenimiento_ubicaciones
end type

