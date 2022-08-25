HA$PBExportHeader$w_prioridades_rieles_todos.srw
$PBExportComments$Visualiza y modifica las prioridades de la carga asiganada a los rieles de las mesas de corte
forward
global type w_prioridades_rieles_todos from w_base_tabular
end type
type cbx_filtro from checkbox within w_prioridades_rieles_todos
end type
end forward

global type w_prioridades_rieles_todos from w_base_tabular
integer x = 5
integer y = 4
integer width = 3461
integer height = 2216
string title = "Prioridades Rieles"
cbx_filtro cbx_filtro
end type
global w_prioridades_rieles_todos w_prioridades_rieles_todos

on w_prioridades_rieles_todos.create
int iCurrent
call super::create
this.cbx_filtro=create cbx_filtro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_filtro
end on

on w_prioridades_rieles_todos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_filtro)
end on

event ue_insertar_maestro;
// Override ancestor script

end event

event ue_buscar;
// Override ancestor script

end event

event open;call super::open;

//SetPointer(HourGlass!)
DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;
dw_maestro.SetTransObject(SQLCA)

sle_argumento.SetFocus()

end event

type dw_maestro from w_base_tabular`dw_maestro within w_prioridades_rieles_todos
integer width = 3314
integer height = 1860
integer taborder = 10
string dataobject = "d_prioridades_rieles"
boolean hscrollbar = false
boolean border = true
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_maestro::ue_retrieve;
// Override ancestor script

n_cts_constantes		lpo_constantes
Long						ll_tipo_prendas, &
							ll_centro_corte, &
							ll_rectilineo_1, &
							ll_rectilineo_2, &
							ll_estado_asigna, &
							ll_mesa_inf, &
							ll_mesa_sup, &
							ll_filas

lpo_constantes = Create n_cts_constantes

ll_tipo_prendas = lpo_constantes.of_consultar_numerico("TIPO PRENDAS")
If ll_tipo_prendas = -1 Then
	Return 0
End If

ll_centro_corte = lpo_constantes.of_consultar_numerico("CENTRO CORTE")
If ll_centro_corte = -1 Then
	Return 0
End If

ll_rectilineo_1 = lpo_constantes.of_consultar_numerico("RECTILINEO 1")
If ll_rectilineo_1 = -1 Then
	Return 0
End If

ll_rectilineo_2 = lpo_constantes.of_consultar_numerico("RECTILINEO 2")
If ll_rectilineo_2 = -1 Then
	Return 0
End If

// Este par$$HEX1$$e100$$ENDHEX$$metro es el estado de la asignaci$$HEX1$$f300$$ENDHEX$$n
ll_estado_asigna = 9
// --

// Si se digita un valor para la mesa se toma como argumento,
// sino se hace desde mesa 0 hasta mesa 999999
ll_mesa_inf = Long(sle_argumento.Text)
If ll_mesa_inf > 0 Then
	ll_mesa_sup = ll_mesa_inf
Else
	ll_mesa_sup = 999999
End If
// --

ll_filas = This.Retrieve(ll_tipo_prendas, ll_centro_corte, ll_rectilineo_1, ll_rectilineo_2, ll_estado_asigna, ll_mesa_inf, ll_mesa_sup, gstr_info_usuario.codigo_usuario)

This.SetFocus()

Return ll_filas

end event

event dw_maestro::itemchanged;
// Override ancestor script

Long		ll_mesa, ll_orden_corte, ll_i, ll_n, ll_old, ll_new, ll_actual
String	ls_po

ll_n = This.RowCount()

ll_new = Long(Data)
If ll_new <= 0 Then
	MessageBox("Validaci$$HEX1$$f300$$ENDHEX$$n", "La prioridad debe ser mayor que cero.")
	Return 2
End If

ll_old = This.GetItemNumber(row, "cs_prioridad")

ll_mesa =			This.GetItemNumber(row, "mesa")
ll_orden_corte =	This.GetItemNumber(row, "orden_corte")
ls_po =				This.GetItemString(row, "po")

This.SetRedraw(False)

If cbx_filtro.Checked Then
	This.SetFilter("")
	This.Filter()
	ll_n = This.RowCount()
End If

For ll_i = 1 To ll_n
	ll_actual = This.GetItemNumber(ll_i, "cs_prioridad")
	If ll_mesa = This.GetItemNumber(ll_i, "mesa") Then
		If ll_orden_corte = This.GetItemNumber(ll_i, "orden_corte") And ls_po = This.GetItemString(ll_i, "po") Then
			This.SetItem(ll_i, "cs_prioridad", ll_new)
		Else
			If ll_old > ll_new Then
				If ll_old > ll_actual And ll_new <= ll_actual Then
					This.SetItem(ll_i, "cs_prioridad", ll_actual + 1)
				End If
			Else
				If ll_old < ll_actual And ll_new >= ll_actual Then
					This.SetItem(ll_i, "cs_prioridad", ll_actual - 1)
				End If
			End If
		End If
	End If
Next

This.AcceptText()

This.Sort()
This.GroupCalc()

If cbx_filtro.Checked Then
	This.SetFilter("descripcion_proceso <> 6")
	This.Filter()
End If

This.SetRedraw(True)

end event

event dw_maestro::retrieveend;call super::retrieveend;
If cbx_filtro.Checked Then
	This.SetFilter("descripcion_proceso <> 6")
	This.Filter()
	This.GroupCalc()
End If

end event

type sle_argumento from w_base_tabular`sle_argumento within w_prioridades_rieles_todos
integer y = 12
integer width = 238
integer height = 100
integer taborder = 20
integer textsize = -12
fontcharset fontcharset = ansi!
end type

event sle_argumento::modified;

// Override ancestor script

dw_maestro.TriggerEvent("ue_retrieve")

end event

type st_1 from w_base_tabular`st_1 within w_prioridades_rieles_todos
integer y = 24
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
string text = "Mesa:"
alignment alignment = center!
end type

type cbx_filtro from checkbox within w_prioridades_rieles_todos
integer x = 910
integer y = 28
integer width = 635
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Pendientes"
boolean checked = true
end type

event clicked;
If This.Checked Then
	dw_maestro.SetFilter("descripcion_proceso <> 6")
Else
	dw_maestro.SetFilter("")
End If

dw_maestro.Filter()

end event

