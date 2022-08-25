HA$PBExportHeader$w_buscar_agrupaciones_parametros_liquida.srw
forward
global type w_buscar_agrupaciones_parametros_liquida from window
end type
type rb_2 from radiobutton within w_buscar_agrupaciones_parametros_liquida
end type
type rb_1 from radiobutton within w_buscar_agrupaciones_parametros_liquida
end type
type st_1 from statictext within w_buscar_agrupaciones_parametros_liquida
end type
type rb_prioridad from radiobutton within w_buscar_agrupaciones_parametros_liquida
end type
type rb_po from radiobutton within w_buscar_agrupaciones_parametros_liquida
end type
type cb_limpiar from commandbutton within w_buscar_agrupaciones_parametros_liquida
end type
type cb_cancelar from commandbutton within w_buscar_agrupaciones_parametros_liquida
end type
type cb_aceptar from commandbutton within w_buscar_agrupaciones_parametros_liquida
end type
type cb_buscar from commandbutton within w_buscar_agrupaciones_parametros_liquida
end type
type dw_criterio from datawindow within w_buscar_agrupaciones_parametros_liquida
end type
type gb_1 from groupbox within w_buscar_agrupaciones_parametros_liquida
end type
type dw_lista from datawindow within w_buscar_agrupaciones_parametros_liquida
end type
type gb_2 from groupbox within w_buscar_agrupaciones_parametros_liquida
end type
end forward

global type w_buscar_agrupaciones_parametros_liquida from window
integer width = 3269
integer height = 1400
boolean titlebar = true
string title = "Buscar"
windowtype windowtype = response!
long backcolor = 67108864
rb_2 rb_2
rb_1 rb_1
st_1 st_1
rb_prioridad rb_prioridad
rb_po rb_po
cb_limpiar cb_limpiar
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
cb_buscar cb_buscar
dw_criterio dw_criterio
gb_1 gb_1
dw_lista dw_lista
gb_2 gb_2
end type
global w_buscar_agrupaciones_parametros_liquida w_buscar_agrupaciones_parametros_liquida

type variables
String is_sql
Transaction ltr_graficos
Long 	ii_fabpt,ii_linea,ii_fab
Long il_ref,il_pedido, ii_color
end variables

forward prototypes
public function string wf_consultar ()
public function string wf_query (string as_feld)
end prototypes

public function string wf_consultar ();dwItemStatus ldws_status
STRING   ls_object,ls_rest,ls_fieldmod,ls_where = ''
Long  il_pos

dw_criterio.AcceptText()

ls_object = dw_criterio.DESCRIBE("DataWindow.Objects")

DO
	il_pos = Pos(ls_object, '~t')
	IF il_pos = 0 THEN					
		ls_rest = ls_object				
		ls_object = ""					
	ELSE
		ls_rest = Mid(ls_object, 1, il_pos - 1)	
		ls_object = Right(ls_object, Len(ls_object) - il_pos)	
	END IF
	IF ls_rest <> '' AND  Right(ls_rest,2) <> '_t' THEN
		ldws_status = dw_criterio.GetItemStatus(1,ls_rest,Primary!) 
		IF ldws_status = DataModified! THEN
			ls_fieldmod = wf_query (ls_rest)
			IF ls_fieldmod <> '' THEN ls_where += ls_fieldmod  + " AND "
		END IF
	END IF
LOOP WHILE ls_rest <> ''

IF ls_where <> '' THEN ls_where = Mid(ls_where,1,Len(ls_where) -5)

RETURN ls_where
end function

public function string wf_query (string as_feld);STRING ls_where
DATE   ld_fecha

CHOOSE CASE as_feld
	CASE 'grupo'
		ls_where = "( dt_pdnxmodulo.co_fabrica = "+ String(ii_fab)+") and (dt_pdnxmodulo.pedido = "+String(il_pedido)+")"
	CASE 'estilo'
		ls_where = "( dt_pdnxmodulo.co_fabrica_pt = "+ String(ii_fabpt)+") and (dt_pdnxmodulo.co_linea = "+String(ii_linea)+&
					") and ( dt_pdnxmodulo.co_referencia = "+ String(il_ref)+")"
	CASE 'po'
		ls_where = "( dt_pdnxmodulo.po like '%"+ Trim(dw_criterio.GetItemString(1,"po"))+"%' )"
	CASE 'unidades'
		ls_where = "( dt_pdnxmodulo.ca_pendiente = "+ String(dw_criterio.GetItemNumber(1,"unidades"))+")"
	CASE 'tono'
		ls_where = "( dt_pdnxmodulo.tono like '%"+ Trim(dw_criterio.GetItemString(1,"tono"))+"%' )"
	CASE 'prioridad'
		ls_where = "( dt_pdnxmodulo.cs_prioridad = "+ String(dw_criterio.GetItemNumber(1,"prioridad"))+")"
	CASE 'oc'
		ls_where = "( dt_pdnxmodulo.cs_asignacion = "+ String(dw_criterio.GetItemNumber(1,'oc'))+")"		
END CHOOSE

RETURN ls_where
end function

on w_buscar_agrupaciones_parametros_liquida.create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
this.rb_prioridad=create rb_prioridad
this.rb_po=create rb_po
this.cb_limpiar=create cb_limpiar
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.cb_buscar=create cb_buscar
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.dw_lista=create dw_lista
this.gb_2=create gb_2
this.Control[]={this.rb_2,&
this.rb_1,&
this.st_1,&
this.rb_prioridad,&
this.rb_po,&
this.cb_limpiar,&
this.cb_cancelar,&
this.cb_aceptar,&
this.cb_buscar,&
this.dw_criterio,&
this.gb_1,&
this.dw_lista,&
this.gb_2}
end on

on w_buscar_agrupaciones_parametros_liquida.destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.rb_prioridad)
destroy(this.rb_po)
destroy(this.cb_limpiar)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.cb_buscar)
destroy(this.dw_criterio)
destroy(this.gb_1)
destroy(this.dw_lista)
destroy(this.gb_2)
end on

event open;Environment le_even

IF GetEnvironment ( le_even ) <> 1 THEN 
ELSE
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
END IF

dw_lista.SetTransObject(SQLCA)
dw_criterio.SetTransObject(SQLCA)

dw_criterio.InsertRow(0)


is_sql = dw_lista.GetSqlSelect()

end event

type rb_2 from radiobutton within w_buscar_agrupaciones_parametros_liquida
integer x = 1728
integer y = 88
integer width = 293
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "M$$HEX1$$f300$$ENDHEX$$dulo"
end type

event clicked;dw_lista.SetSort("de_modulo A")
dw_lista.Sort()
end event

type rb_1 from radiobutton within w_buscar_agrupaciones_parametros_liquida
integer x = 1399
integer y = 88
integer width = 306
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Unidades"
end type

event clicked;dw_lista.SetSort("ca_pendiente A")
dw_lista.Sort()
end event

type st_1 from statictext within w_buscar_agrupaciones_parametros_liquida
integer x = 891
integer y = 88
integer width = 306
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ordenar por:"
boolean focusrectangle = false
end type

type rb_prioridad from radiobutton within w_buscar_agrupaciones_parametros_liquida
integer x = 2066
integer y = 88
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Prioridad"
boolean checked = true
end type

event clicked;dw_lista.SetSort("cs_prioridad A")
dw_lista.Sort()
end event

type rb_po from radiobutton within w_buscar_agrupaciones_parametros_liquida
integer x = 1198
integer y = 88
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Po"
end type

event clicked;dw_lista.SetSort("po A")
dw_lista.Sort()
end event

type cb_limpiar from commandbutton within w_buscar_agrupaciones_parametros_liquida
integer x = 302
integer y = 760
integer width = 242
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Limpiar"
end type

event clicked;dw_criterio.Reset()
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
end event

type cb_cancelar from commandbutton within w_buscar_agrupaciones_parametros_liquida
integer x = 558
integer y = 1036
integer width = 242
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;s_base_parametros lst_parametros

lst_parametros.cadena[1] = 'NO'

CloseWithReturn(Parent, lst_parametros)
end event

type cb_aceptar from commandbutton within w_buscar_agrupaciones_parametros_liquida
integer x = 293
integer y = 1036
integer width = 242
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_filas
s_base_parametros lst_parametros

ll_filas = dw_lista.GetRow()

IF ll_filas >= 1 THEN

	lst_parametros.entero[1] = dw_lista.GetItemNumber(ll_filas,'cs_prioridad')
	lst_parametros.entero[2] = dw_lista.GetItemNumber(ll_filas,'co_modulo')
	lst_parametros.cadena[1] = 'SI'
	lst_parametros.cadena[2] = dw_lista.GetItemString(ll_filas,'po')
	
	CloseWithReturn(Parent, lst_parametros)
ELSE
	
END IF
end event

type cb_buscar from commandbutton within w_buscar_agrupaciones_parametros_liquida
integer x = 27
integer y = 1036
integer width = 242
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
boolean default = true
end type

event clicked;STRING ls_where,ls_sintaxis
LONG ll_step, ll_max,ll_marca,ll_i,ll_referencia,ll_ordencorte,ll_fabrica2,ll_fabrica
Long li_linea2,li_linea,li_planta
DECIMAL ldc_tiempo_std

dw_criterio.AcceptText() 

ls_sintaxis = is_sql
ls_where = wf_consultar()

IF ls_where <> "" THEN 
	ls_sintaxis += " and " + ls_where
END IF


dw_lista.SetSqlSelect(ls_sintaxis)
dw_lista.visible = False
dw_lista.Retrieve()
dw_lista.SetSort("cs_prioridad A")
dw_lista.Sort()


IF dw_lista.RowCount() = 0 THEN
	MessageBox('Advertencia','No existen registros que cumplan con el criterio de busqueda')
	ll_marca = 1
END IF


IF ll_marca = 1 THEN 
ELSE
	dw_criterio.Reset()
	dw_criterio.InsertRow(0)
END IF


end event

type dw_criterio from datawindow within w_buscar_agrupaciones_parametros_liquida
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 132
integer width = 754
integer height = 516
integer taborder = 10
string title = "none"
string dataobject = "dff_criterio_buscar_agrupaciones_liquida"
boolean border = false
boolean livescroll = true
end type

event ue_enter;IF This.AcceptText() = 1 Then
	Send(Handle(this),256,9,Long(0,0))
	Return 0
Else
	Return -1
End If
end event

event itemchanged;String ls_estilo,ls_grupo

CHOOSE CASE GetColumnName()
	
	CASE 'grupo'
		
		ls_grupo = Data
		
		select co_fabrica_vta, pedido
		into :ii_fab,:il_pedido
		from peddig
		where gpa = :ls_grupo
		and tipo_pedido="AL";
		
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox('Error','Al recuperar informaci$$HEX1$$f300$$ENDHEX$$n del grupo')
			Return 
		ELSE
			IF Sqlca.sqlcode = 100 THEN 
				MessageBox('Error','No existe informaci$$HEX1$$f300$$ENDHEX$$n del grupo')
				Return 
			END IF	
		END IF
		
		
		
	CASE 'estilo'
		
		ls_estilo = Data
		
		select co_fabrica, co_linea ,co_referencia
		into :ii_fabpt, :ii_linea, :il_ref
		from h_preref
		where de_referencia = :ls_estilo;
		
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox('Error','Al recuperar informaci$$HEX1$$f300$$ENDHEX$$n del estilo')
			Return 
		ELSE
			IF Sqlca.sqlcode = 100 THEN 
				MessageBox('Error','No existe informaci$$HEX1$$f300$$ENDHEX$$n del estilo')
				Return 
			END IF	
		END IF
			
//	CASE 'color'
//		
//		ls_color = Trim(Data)
//		
//		select co_fabrica,co_linea,co_color
//		into :il_color
//		from m_colores
//		where de_color LIKE :ls_color and
//				co_fabrica = :ii_fabpt and
//				co_linea = :ii_linea;
//		
//		IF SQLCA.SQLCODE = -1 THEN
//			MessageBox('Error','Al recuperar informaci$$HEX1$$f300$$ENDHEX$$n del color')
//			Return 
//		ELSE
//			IF Sqlca.sqlcode = 100 THEN 
//				MessageBox('Error','No existe informaci$$HEX1$$f300$$ENDHEX$$n del color')
//				Return 
//			END IF	
//		END IF
		
		
		
END CHOOSE

end event

type gb_1 from groupbox within w_buscar_agrupaciones_parametros_liquida
integer x = 18
integer y = 36
integer width = 791
integer height = 912
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 16711680
long backcolor = 67108864
string text = "Crietrio Busqueda"
end type

type dw_lista from datawindow within w_buscar_agrupaciones_parametros_liquida
integer x = 873
integer y = 188
integer width = 2322
integer height = 1056
integer taborder = 20
string title = "none"
string dataobject = "dgr_lista_buscar_agrupaciones_liquida"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;If Row <= 0 Then Return

//IF isSelected (row) = TRUE THEN
//ELSE
	cb_aceptar.TriggerEvent(Clicked!)
//END IF
end event

event clicked;If Row <= 0 Then Return

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If
end event

event retrieveend;Long ll_fila,ll_fabpt,ll_linea,ll_ref,ll_color,ll_modulo
String ls_ref,ls_color,ls_linea,ls_modulo

SetPointer(Hourglass!)

If dw_lista.RowCount() >= 1 THEN

	FOR ll_fila = 1 TO dw_lista.RowCount()
		ll_fabpt = dw_lista.GetItemNumber(ll_fila,'co_fabrica_pt')
		ll_linea = dw_lista.GetItemNumber(ll_fila,'co_linea')
		ll_ref = dw_lista.GetItemNumber(ll_fila,'co_referencia')
		ll_color = dw_lista.GetItemNumber(ll_fila,'co_color_pt')
		ll_modulo = dw_lista.GetItemNumber(ll_fila,'co_modulo')
		
		select h_preref.de_referencia
		into :ls_ref
		from h_preref
		where co_fabrica = :ll_fabpt and
				co_linea = :ll_linea and
				co_referencia = :ll_ref;
				
		select de_color
		into :ls_color
		from m_colores
		where co_fabrica = :ll_fabpt and
				co_linea = :ll_linea and
				co_color = :ll_color;		
				
		select de_linea
		into :ls_linea
		from m_lineas
		where co_fabrica = :ll_fabpt and
				co_linea = :ll_linea;
				
		select de_modulo
		into :ls_modulo
		from m_modulos
		where co_fabrica = 91 and
				co_planta = 1 and
				co_modulo = :ll_modulo;
						
		dw_lista.SetItem(ll_fila,'de_referencia',ls_ref)		
		dw_lista.SetItem(ll_fila,'de_color',ls_color)
		dw_lista.SetItem(ll_fila,'de_linea',ls_linea)
		dw_lista.SetItem(ll_fila,'de_modulo',ls_modulo)
	NEXT
	
END IF 

dw_lista.Visible = True
end event

type gb_2 from groupbox within w_buscar_agrupaciones_parametros_liquida
integer x = 827
integer y = 36
integer width = 2405
integer height = 1236
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 16711680
long backcolor = 67108864
end type

