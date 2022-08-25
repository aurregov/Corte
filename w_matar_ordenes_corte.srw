HA$PBExportHeader$w_matar_ordenes_corte.srw
forward
global type w_matar_ordenes_corte from w_base_tabular
end type
type em_fecha from editmask within w_matar_ordenes_corte
end type
end forward

global type w_matar_ordenes_corte from w_base_tabular
integer width = 1609
integer height = 1500
string title = "Matar Ordenes Corte"
em_fecha em_fecha
end type
global w_matar_ordenes_corte w_matar_ordenes_corte

on w_matar_ordenes_corte.create
int iCurrent
call super::create
this.em_fecha=create em_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_fecha
end on

on w_matar_ordenes_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_fecha)
end on

event ue_buscar;Date ldt_fecha
s_base_parametros lstr_parametros_retro

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios  en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				is_accion = "no grabo"
				// no graba y se sale
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	
	lstr_parametros_retro.cadena[1]="Cargando datos ..."
	lstr_parametros_retro.cadena[2]="Espere un momento por favor, esta operacion pude durar unos segundos..."
	lstr_parametros_retro.cadena[3]="reloj"

	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)

	ldt_fecha = Date(em_fecha.Text)
	CHOOSE CASE dw_maestro.Retrieve(ldt_fecha)
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
			OpenWithParm(w_reporte_errores,istr_parametros_error)
			Close(This)
		CASE 0
			Close(w_retroalimentacion)
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

event ue_insertar_maestro;call super::ue_insertar_maestro;IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))
END IF
end event

event open;call super::open;Long li_resultado

This.width = 1250
This.height = 1500

OpenWithParm(w_conexion_devolver_liquidacion, 13)
li_resultado = Message.DoubleParm
IF li_resultado = 0 THEN
	MessageBox("Error","No est$$HEX2$$e1002000$$ENDHEX$$autorizado")
	Close(This)
END IF

//nada
end event

event ue_grabar;Long ll_co_concepto

/////////////////////////////////////////////////////////////////////
// En este evento se realiza el ACCEPTTEXT para llevar los
// datos al buffer. El UPDATE() para preparar los datos a grabar y
// el COMMIT, para grabar los cambios en la base de datos
/////////////////////////////////////////////////////////////////////


ll_co_concepto = dw_maestro.GetitemNumber(il_fila_actual_maestro,'co_cpto_mataoc')

IF ISNULL(ll_co_concepto) THEN
	Messagebox("Error","No ha ingresado el concepto para matar la orden",Exclamation!,Ok!)	
	Return
END IF


IF dw_maestro.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro" &
	           ,Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_maestro.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF
	
end event

type dw_maestro from w_base_tabular`dw_maestro within w_matar_ordenes_corte
integer x = 37
integer width = 1518
integer height = 1136
integer taborder = 10
string dataobject = "dtb_ordencr_muertas"
boolean hscrollbar = false
boolean border = true
boolean hsplitscroll = false
end type

event dw_maestro::itemchanged;IF il_fila_actual_maestro > 0 THEN
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_actualizacion", DateTime(Today(), Now()))
	dw_maestro.SetItem(il_fila_actual_maestro, "usuario", gstr_info_usuario.codigo_usuario)
	dw_maestro.SetItem(il_fila_actual_maestro, "instancia", gstr_info_usuario.instancia)
END IF
end event

type sle_argumento from w_base_tabular`sle_argumento within w_matar_ordenes_corte
boolean visible = false
integer x = 32
integer y = 72
integer taborder = 20
end type

type st_1 from w_base_tabular`st_1 within w_matar_ordenes_corte
integer x = 32
integer y = 4
integer height = 60
end type

type em_fecha from editmask within w_matar_ordenes_corte
integer x = 32
integer y = 60
integer width = 315
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

event modified;Parent.TriggerEvent("ue_buscar")
end event

