HA$PBExportHeader$w_buscar_por_remision.srw
forward
global type w_buscar_por_remision from w_base_tabular
end type
type cb_generar from commandbutton within w_buscar_por_remision
end type
type cb_buscar from commandbutton within w_buscar_por_remision
end type
type em_despacho from editmask within w_buscar_por_remision
end type
type em_remision from editmask within w_buscar_por_remision
end type
type st_2 from statictext within w_buscar_por_remision
end type
type st_3 from statictext within w_buscar_por_remision
end type
type cb_1 from commandbutton within w_buscar_por_remision
end type
end forward

global type w_buscar_por_remision from w_base_tabular
integer width = 3561
integer height = 1948
string title = "Consulta por referencia"
string menuname = "m_vista_previa"
event ue_imprimir pbm_custom05
cb_generar cb_generar
cb_buscar cb_buscar
em_despacho em_despacho
em_remision em_remision
st_2 st_2
st_3 st_3
cb_1 cb_1
end type
global w_buscar_por_remision w_buscar_por_remision

event ue_imprimir;

dw_maestro.setFocus()
OpenWithParm(w_opciones_impresion, dw_maestro)

end event

on w_buscar_por_remision.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.cb_generar=create cb_generar
this.cb_buscar=create cb_buscar
this.em_despacho=create em_despacho
this.em_remision=create em_remision
this.st_2=create st_2
this.st_3=create st_3
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.cb_buscar
this.Control[iCurrent+3]=this.em_despacho
this.Control[iCurrent+4]=this.em_remision
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cb_1
end on

on w_buscar_por_remision.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.cb_buscar)
destroy(this.em_despacho)
destroy(this.em_remision)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_1)
end on

event open;This.x = 1
This.y = 1

dw_maestro.SetTransObject(sqlca)

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

	CHOOSE CASE dw_maestro.Retrieve(Long(sle_argumento.text))
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
//			MessageBox("Error datawindows","No se hallaron datos", &
//			            Exclamation!,Ok!)
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

type dw_maestro from w_base_tabular`dw_maestro within w_buscar_por_remision
integer y = 128
integer width = 3465
integer height = 1520
integer taborder = 40
string dataobject = "dtb_remision_sontinsa"
boolean border = true
end type

type sle_argumento from w_base_tabular`sle_argumento within w_buscar_por_remision
integer y = 12
integer width = 480
integer height = 84
integer taborder = 10
end type

type st_1 from w_base_tabular`st_1 within w_buscar_por_remision
integer y = 16
end type

type cb_generar from commandbutton within w_buscar_por_remision
integer x = 1134
integer y = 8
integer width = 663
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar archivo Excel"
end type

event clicked;long	ll_filas

ll_filas = dw_maestro.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","No hay datos para enviar a Excel",Exclamation!)
	Return
ELSE
	dw_maestro.SaveAs("",Excel5!,false)
END IF
end event

type cb_buscar from commandbutton within w_buscar_por_remision
integer x = 832
integer y = 8
integer width = 265
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
end type

event clicked;String ls_nombredw


//

ls_nombredw 	= 'dtb_remision_sontinsa'
dw_maestro.DataObject = ls_nombredw

IF len(trim(sle_argumento.text)) > 0 THEN
	parent.TriggerEvent("ue_buscar")
END IF
end event

type em_despacho from editmask within w_buscar_por_remision
integer x = 2025
integer y = 12
integer width = 283
integer height = 92
integer taborder = 20
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
string mask = "########"
end type

type em_remision from editmask within w_buscar_por_remision
integer x = 2615
integer y = 12
integer width = 283
integer height = 92
integer taborder = 30
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
string mask = "########"
end type

type st_2 from statictext within w_buscar_por_remision
integer x = 1865
integer y = 28
integer width = 165
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desp:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_buscar_por_remision
integer x = 2359
integer y = 32
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rem Exp:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_buscar_por_remision
integer x = 2907
integer y = 12
integer width = 242
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;String ls_nombredw
Long	ll_despacho, ll_remision

ls_nombredw 	= 'dbt_reporte_remision_exp_despacho'
dw_maestro.DataObject = ls_nombredw

IF len(trim(em_despacho.text)) = 0 THEN
	ll_despacho = 0
ELSE
	ll_despacho = Long(em_despacho.text)
END IF

IF len(trim(em_remision.text)) = 0 THEN
	ll_remision = 0
ELSE
	ll_remision = Long(em_remision.text)
END IF




DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;
dw_maestro.SetTransObject(SQLCA)
//
dw_maestro.visible = true
dw_maestro.Retrieve(ll_despacho,ll_remision)
SetPointer(Arrow!)

end event

