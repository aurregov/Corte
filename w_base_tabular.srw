HA$PBExportHeader$w_base_tabular.srw
$PBExportComments$OBJETO BASE - Ventana utilizada para hacer mantenimientos simples con un tabular en el maestro. Debe Heredarse y adaptar los eventos necesarios.
forward
global type w_base_tabular from w_base_simple
end type
type sle_argumento from singlelineedit within w_base_tabular
end type
type st_1 from statictext within w_base_tabular
end type
end forward

global type w_base_tabular from w_base_simple
sle_argumento sle_argumento
st_1 st_1
end type
global w_base_tabular w_base_tabular

type variables

end variables

on w_base_tabular.create
int iCurrent
call super::create
this.sle_argumento=create sle_argumento
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_argumento
this.Control[iCurrent+2]=this.st_1
end on

on w_base_tabular.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_argumento)
destroy(this.st_1)
end on

event open;call super::open;This.x = 1
This.y = 1

This.TriggerEvent("ue_buscar")


end event

event ue_insertar_maestro;Long ll_fila

//////////////////////////////////////////////////////////////////
// En este evento ademas de que hereda lo del padre, se le 
// adicionaron las siguientes lineas, con el proposito
// de obtener la fila actual en el maestro e iluminarla. 
////////////////////////////////////////////////////////////////
ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
END IF

dw_maestro.SelectRow(il_fila_actual_maestro,FALSE)
il_fila_actual_maestro = dw_maestro.GetRow()

IF ((il_fila_actual_maestro<> -1) and &
     (NOT ISNULL (il_fila_actual_maestro)) and &
	  (il_fila_actual_maestro<>0))THEN
     dw_maestro.SelectRow(il_fila_actual_maestro,TRUE)
	  If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
ELSE
END IF

end event

event ue_buscar;call super::ue_buscar;s_base_parametros lstr_parametros_retro

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

	CHOOSE CASE dw_maestro.Retrieve(sle_argumento.text+"%")
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

type dw_maestro from w_base_simple`dw_maestro within w_base_tabular
integer x = 32
integer y = 156
integer width = 1234
integer height = 508
end type

event dw_maestro::rowfocuschanged;call super::rowfocuschanged;///////////////////////////////////////////////////////////////////
// Esta OVERRIDE.
//// //////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
// Con la siguiente linea, se esta desiluminando la fila que tenia
// el focus. 
/////////////////////////////////////////////////////////////////////

This.Selectrow(il_fila_actual_maestro,FALSE)

/////////////////////////////////////////////////////////////////////
// Con la siguiente linea, se esta  asignado a una variable
// de instancia la fila activa.
//////////////////////////////////////////////////////////////////////

il_fila_actual_maestro = This.GetRow()

//////////////////////////////////////////////////////////////////////
// con las siguientes lineas, le esta mandando a posicionarse
// a la fila activa y se esta iluminado dicha fila.
//////////////////////////////////////////////////////////////////////

This.SetRow(il_fila_actual_maestro)
This.SelectRow(il_fila_actual_maestro,TRUE)

end event

event dw_maestro::clicked;call super::clicked;//////////////////////////////////////////////////////////////////////
// Se evalua si se hizo click sobre una fila valida
//////////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	This.SelectRow(il_fila_actual_maestro,FALSE)
	il_fila_actual_maestro = row
ELSE
END IF

end event

event dw_maestro::doubleclicked;call super::doubleclicked;//////////////////////////////////////////////////////////////////////
// Se evalua si se hizo click sobre una fila valida
//////////////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT IsNull(row) THEN
	This.SelectRow(il_fila_actual_maestro,FALSE)
	il_fila_actual_maestro = row
ELSE
END IF



end event

type sle_argumento from singlelineedit within w_base_tabular
integer x = 325
integer width = 791
integer height = 68
integer taborder = 1
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;//////////////////////////////////////////////////////////////////////
// En este evento se dispara el userObject ue_buscar de esta ventana
//////////////////////////////////////////////////////////////////////

Parent.TriggerEvent("ue_buscar")
end event

type st_1 from statictext within w_base_tabular
integer x = 55
integer y = 12
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 81576884
boolean enabled = false
string text = "Buscar por:"
boolean focusrectangle = false
end type

