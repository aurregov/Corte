HA$PBExportHeader$w_capas_tipo_tela.srw
forward
global type w_capas_tipo_tela from w_base_maestrotb_detalletb
end type
end forward

global type w_capas_tipo_tela from w_base_maestrotb_detalletb
integer width = 2830
integer height = 2040
string title = "Capas Por Tela de Referencia"
end type
global w_capas_tipo_tela w_capas_tipo_tela

on w_capas_tipo_tela.create
call super::create
end on

on w_capas_tipo_tela.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_borrar_maestro;// Se omite el script
end event

event ue_insertar_maestro;// Se omite el script
end event

event ue_insertar_detalle;call super::ue_insertar_detalle;Long li_tipotejido

IF il_fila_actual_maestro > 0 THEN
	li_tipotejido = dw_maestro.GetItemNumber(il_fila_actual_maestro, "co_ttejido")
	IF IsNull(li_tipotejido) THEN
		dw_detalle.DeleteRow(il_fila_actual_detalle)
		il_fila_actual_detalle = il_fila_actual_detalle - 1
	ELSE
		dw_detalle.SetItem(il_fila_actual_detalle, "co_ttejido", li_tipotejido)
	END IF
END IF
end event

event ue_buscar;s_base_parametros lstr_parametros_retro

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	///////////////////////////////////////////////////////////////////
	// Las siguientes tres lineas, estan llenando la estructura 
	// s_base_parametrospara poder asi desplegar en la ventana 
   // de retroalimentacion el mensaje correspondiente a la 
	// accion que se esta ejecutando.
	//
	///////////////////////////////////////////////////////////////////
	
	lstr_parametros_retro.cadena[1]="Cargando datos ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

	CHOOSE CASE dw_maestro.Retrieve(sle_argumento.text+"%",0)
		CASE -1
			Close(w_retroalimentacion)
			MessageBox("Error datawindow","No se pudo cargar datos", &
			            Exclamation!,Ok!)
			 
			////////////////////////////////////////////////////////////////
       	// Las siguientes cinco lineas, estan llenando la estructura 
      	// s_base_parametros 
      	// para poder asi desplegar en la ventana de errores el mensaje
      	// correspondiente al error reportado por el motor de base de 
			// datos.
       	////////////////////////////////////////////////////////////////
			 
			istr_parametros_error.cadena[1]=sqlca.dbms
			istr_parametros_error.entero[1]=sqlca.sqlcode
			istr_parametros_error.cadena[2]=this.classname()
			istr_parametros_error.cadena[3]="modified"
			istr_parametros_error.cadena[4]=""
			istr_parametros_error.cadena[5] = SQLCA.SQLErrText
			OpenWithParm(w_reporte_errores,istr_parametros_error)
			Close(This)
		CASE 0
			Close(w_retroalimentacion)
			MessageBox("Error datawindows","No se hallaron datos", &
			            Exclamation!,Ok!)
		CASE ELSE
			Close(w_retroalimentacion)
			il_fila_actual_maestro = 1
			dw_maestro.SetRow(il_fila_actual_maestro)
			dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
			dw_maestro.ScrollToRow(il_fila_actual_maestro)
			dw_maestro.SetColumn(1)
			dw_maestro.SetFocus()
	END CHOOSE
ELSE
END IF
end event

event open;////////////////////////////////////////////////////////////////////////
//jfdiafer, 10/09/2012
//FRICE E00321
//se omite el script del papa.
// y se hace un settransobject al datawindow del detalle.
/////////////////////////////////////////////////////////////////////////

Long ll_var

dw_detalle.SetTransObject(SQLCA)

this.menuid.item[2].item[3].enabled = false
this.menuid.item[2].item[4].enabled = false
this.menuid.item[2].item[6].enabled = false
this.menuid.item[2].item[7].enabled = false
this.menuid.item[2].item[9].enabled = false
this.menuid.item[2].item[10].enabled = false

ll_var = w_base_simple::EVENT Open()
end event

event ue_grabar;/////////////////////////////////////////////////////////////////////////
// Con el ACCEPTTEXT para llevar los cambios al buffer.
// El UPDATE para preparar los datos en el servidor.
// El COMMIT para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////////

	 	string ls_referencia
	IF dw_detalle.AcceptText() = -1 THEN
		
	  	ls_referencia = String (dw_maestro.GetitemNumber(il_fila_actual_maestro, 'co_referencia'))
		is_accion = "no accepttext"
		MessageBox("Error","Se presento un error actualizando las capas por tela en la referencia " + ls_referencia,Exclamation!,Ok!)	
		RETURN
	ELSE
		IF dw_detalle.Update() = -1 THEN
			is_accion = "no update"
			ROLLBACK;
			MessageBox("Error","Se presento un error actualizando las capas por tela en la referencia " + ls_referencia,Exclamation!,Ok!)	
			RETURN
		ELSE
			is_accion = "si update"
			COMMIT;
			IF sqlca.sqlcode = -1 THEN
				is_grabada = "no"
				MessageBox("Error","Se presento un error actualizando las capas por tela en la referencia " + ls_referencia,Exclamation!,Ok!)	
			ELSE
				is_grabada = "si"
			END IF
		END IF
	END IF

end event

type dw_maestro from w_base_maestrotb_detalletb`dw_maestro within w_capas_tipo_tela
integer x = 37
integer y = 120
integer width = 2107
integer height = 572
boolean titlebar = false
string dataobject = "dtb_buscar_referencias"
boolean hscrollbar = false
boolean livescroll = false
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;/*
FRICE E00321
jfdiafer, 11-09-2012
Evento que busca las capas maximas por tela asociada a la referencia seleccionada
*/

Long li_fabrica
Long li_linea
string  ls_referencia

IF il_fila_actual_maestro > 0 THEN
	li_fabrica = dw_maestro.GetitemNumber(il_fila_actual_maestro, 'co_fabrica')
	li_linea = dw_maestro.GetitemNumber(il_fila_actual_maestro, 'co_linea')
	ls_referencia = String (dw_maestro.GetitemNumber(il_fila_actual_maestro, 'co_referencia'))
	dw_detalle.Retrieve(li_fabrica, li_linea, ls_referencia)
END IF
end event

type sle_argumento from w_base_maestrotb_detalletb`sle_argumento within w_capas_tipo_tela
end type

event sle_argumento::modified;//se omite el padre
Parent.TriggerEvent("ue_buscar")
end event

type st_1 from w_base_maestrotb_detalletb`st_1 within w_capas_tipo_tela
end type

type dw_detalle from w_base_maestrotb_detalletb`dw_detalle within w_capas_tipo_tela
integer x = 37
integer y = 704
integer width = 2583
integer height = 572
boolean titlebar = false
string dataobject = "dtb_dt_capas_reftela"
boolean hscrollbar = true
end type

event dw_detalle::itemerror;call super::itemerror;return 0
end event

