HA$PBExportHeader$w_agrupaciones.srw
forward
global type w_agrupaciones from window
end type
type cb_1 from commandbutton within w_agrupaciones
end type
type tab_1 from tab within w_agrupaciones
end type
type tabpage_1 from userobject within tab_1
end type
type cb_3 from commandbutton within tabpage_1
end type
type dw_dt_agrupa from u_dw_base within tabpage_1
end type
type cb_2 from commandbutton within tabpage_1
end type
type dw_h_agrupa from u_dw_base within tabpage_1
end type
type gb_1 from groupbox within tabpage_1
end type
type gb_2 from groupbox within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cb_3 cb_3
dw_dt_agrupa dw_dt_agrupa
cb_2 cb_2
dw_h_agrupa dw_h_agrupa
gb_1 gb_1
gb_2 gb_2
end type
type tabpage_2 from userobject within tab_1
end type
type cb_4 from commandbutton within tabpage_2
end type
type dw_detalle_agrupa from u_dw_base within tabpage_2
end type
type dw_agrupa_borrar from u_dw_base within tabpage_2
end type
type gb_3 from groupbox within tabpage_2
end type
type gb_4 from groupbox within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_4 cb_4
dw_detalle_agrupa dw_detalle_agrupa
dw_agrupa_borrar dw_agrupa_borrar
gb_3 gb_3
gb_4 gb_4
end type
type tab_1 from tab within w_agrupaciones
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_agrupaciones from window
integer width = 2295
integer height = 1712
boolean titlebar = true
string title = "Agrupaciones"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
cb_1 cb_1
tab_1 tab_1
end type
global w_agrupaciones w_agrupaciones

type variables
DataWindow idw_dato
Long ii_fabrica
Long    il_pedido
end variables

on w_agrupaciones.create
this.cb_1=create cb_1
this.tab_1=create tab_1
this.Control[]={this.cb_1,&
this.tab_1}
end on

on w_agrupaciones.destroy
destroy(this.cb_1)
destroy(this.tab_1)
end on

event open;DataWindow ldw_producto
Long    ll_selectrow,ll_fila,ll_pedaux,ll_filins
Long li_fabaux
Boolean lb_ingreso = True


Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If


ldw_producto = Message.PowerObjectParm

tab_1.tabpage_1.dw_h_agrupa.SetTransObject(Sqlca)
tab_1.tabpage_1.dw_dt_agrupa.SetTransObject(Sqlca)
tab_1.tabpage_2.dw_agrupa_borrar.SetTransObject(Sqlca)
tab_1.tabpage_2.dw_detalle_agrupa.SetTransObject(Sqlca)

ll_fila = 0

Do
	ll_fila = ldw_producto.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then 
		ldw_producto.RowsCopy(ll_fila,ll_fila,Primary!,tab_1.tabpage_1.dw_dt_agrupa,tab_1.tabpage_1.dw_dt_agrupa.RowCount()+1, Primary!)
		
		If lb_ingreso Then
			ii_fabrica = ldw_producto.GetItemNumber(ll_fila,'co_fabrica_exp')
			il_pedido  = ldw_producto.GetItemNumber(ll_fila,'pedido')
			lb_ingreso = False
		Else
			li_fabaux = ldw_producto.GetItemNumber(ll_fila,'co_fabrica_exp')
			ll_pedaux = ldw_producto.GetItemNumber(ll_fila,'pedido')
			
			If ii_fabrica <> li_fabaux Or il_pedido <> ll_pedaux Then
				MessageBox("Advertencia!","La producci$$HEX1$$f300$$ENDHEX$$n seleccionada no tiene el mismo pedido.",StopSign!)
				Close(This)
				Return
			End If
		End If 
		
		ll_filins = tab_1.tabpage_1.dw_dt_agrupa.InsertRow(0)
		
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'co_fabrica_exp',ii_fabrica)
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'pedido',il_pedido)
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'cs_liberacion',ldw_producto.GetItemNumber(ll_fila,'cs_liberacion'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'po',ldw_producto.GetItemString(ll_fila,'po'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'co_fabrica_pt',ldw_producto.GetItemNumber(ll_fila,'co_fabrica_pt'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'co_linea',ldw_producto.GetItemNumber(ll_fila,'co_linea'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'co_referencia',ldw_producto.GetItemNumber(ll_fila,'co_referencia'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'co_color_pt',ldw_producto.GetItemNumber(ll_fila,'co_color_pt'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'cs_estilocolortono',ldw_producto.GetItemNumber(ll_fila,'cs_estilocolortono'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'cs_particion',ldw_producto.GetItemNumber(ll_fila,'cs_particion'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'tono',ldw_producto.GetItemString(ll_fila,'tono'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'ca_unidades',ldw_producto.GetItemNumber(ll_fila,'ca_programada'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'de_linea',ldw_producto.GetItemString(ll_fila,'de_linea'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'de_referencia',ldw_producto.GetItemString(ll_fila,'de_referencia'))
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
		tab_1.tabpage_1.dw_dt_agrupa.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)
	End If
	
loop Until ll_fila = 0

tab_1.tabpage_1.dw_h_agrupa.Retrieve(ii_fabrica,il_pedido)
end event

type cb_1 from commandbutton within w_agrupaciones
integer x = 942
integer y = 1460
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cerrar"
end type

event clicked;Close(Parent)
end event

type tab_1 from tab within w_agrupaciones
integer x = 9
integer y = 12
integer width = 2226
integer height = 1424
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;
If newindex = 1 Then
	tab_1.tabpage_1.dw_h_agrupa.Retrieve(ii_fabrica,il_pedido)
Else
	tab_1.tabpage_2.dw_agrupa_borrar.Retrieve(0,0)
	tab_1.tabpage_2.dw_agrupa_borrar.SetFocus()
End If
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2190
integer height = 1308
long backcolor = 67108864
string text = "Adicionar"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_3 cb_3
dw_dt_agrupa dw_dt_agrupa
cb_2 cb_2
dw_h_agrupa dw_h_agrupa
gb_1 gb_1
gb_2 gb_2
end type

on tabpage_1.create
this.cb_3=create cb_3
this.dw_dt_agrupa=create dw_dt_agrupa
this.cb_2=create cb_2
this.dw_h_agrupa=create dw_h_agrupa
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_3,&
this.dw_dt_agrupa,&
this.cb_2,&
this.dw_h_agrupa,&
this.gb_1,&
this.gb_2}
end on

on tabpage_1.destroy
destroy(this.cb_3)
destroy(this.dw_dt_agrupa)
destroy(this.cb_2)
destroy(this.dw_h_agrupa)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type cb_3 from commandbutton within tabpage_1
integer x = 1833
integer y = 1200
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Grabar"
end type

event clicked;n_cts_param_talla luo_pmtalla
n_cts_param luo_param
Datastore lds_tallas,lds_rayas
DataWindow ldw_datos
Long    ll_flasig,ll_csagrup,ll_cspdn,ll_ref,ll_j,ll_cnt,ll_modulo,ll_raya, ll_color
Long li_i,li_tipo,li_lib,li_fabpt,li_lin,li_csest,li_cspar,&
        li_talla,li_csorden
String  ls_sqlerr,ls_po,ls_tono



lds_tallas = Create Datastore
lds_rayas  = Create Datastore

lds_tallas.DataObject = 'd_lista_tallas_produccion'
lds_rayas.DataObject = 'd_lista_modelos_x_talla'

lds_tallas.SetTransObject(Sqlca)
lds_rayas.SetTransObject(Sqlca)

ll_flasig = dw_h_agrupa.GetRow()

If ll_flasig <= 0 Then
	MessageBox("Advertencia!","Debe seleccionar una agrupaci$$HEX1$$f300$$ENDHEX$$n o crear una nueva si es el caso.")
	Return
End If


ll_csagrup = dw_h_agrupa.GetItemNumber(ll_flasig,'cs_agrupacion')

select max(cs_pdn)  
  into :ll_cspdn  
  from dt_agrupa_pdn  
 where cs_agrupacion = :ll_csagrup   ;
 
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo obtener el consecutivo de la agrupaci$$HEX1$$f300$$ENDHEX$$n # " + String(ll_csagrup) + ".~n~n~nNota: " + ls_sqlerr )
	Return
ElseIf IsNull(ll_cspdn) Then
	ll_cspdn = 0
End If

For li_i = 1 To dw_dt_agrupa.RowCount()
	ll_cspdn ++	
	dw_dt_agrupa.SetItem(li_i,'cs_agrupacion',ll_csagrup)
	dw_dt_agrupa.SetItem(li_i,'cs_pdn',ll_cspdn)
Next

dw_dt_agrupa.AcceptText()

If dw_dt_agrupa.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo grabar la producci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return
End If

For li_i = 1 To dw_dt_agrupa.RowCount()
		
	dw_dt_agrupa.SelectRow(0,False)	
	dw_dt_agrupa.SelectRow(li_i,True)	
		
	li_lib   = dw_dt_agrupa.GetItemNumber(li_i,'cs_liberacion')
	ls_po    = dw_dt_agrupa.GetItemString(li_i,'po')
	li_fabpt = dw_dt_agrupa.GetItemNumber(li_i,'co_fabrica_pt')
	li_lin   = dw_dt_agrupa.GetItemNumber(li_i,'co_linea')
	ll_ref   = dw_dt_agrupa.GetItemNumber(li_i,'co_referencia')
	ll_color = dw_dt_agrupa.GetItemNumber(li_i,'co_color_pt')
	li_csest = dw_dt_agrupa.GetItemNumber(li_i,'cs_estilocolortono')
	li_cspar = dw_dt_agrupa.GetItemNumber(li_i,'cs_particion')
	ls_tono  = dw_dt_agrupa.GetItemString(li_i,'tono')
	
	ll_cspdn = dw_dt_agrupa.GetItemNumber(li_i,'cs_pdn')
	
	// Tallas
	li_tipo  = dw_dt_agrupa.GetItemNumber(li_i,'co_tipo_tallas')
		
	If li_tipo = 1 Then
		lds_tallas.Retrieve(ii_fabrica,il_pedido,li_lib,ls_po,li_fabpt,li_lin,ll_ref,ll_color,ls_tono,li_csest,li_cspar)
		
		For ll_j = 1 To lds_tallas.RowCount()
			li_csorden = lds_tallas.GetItemNumber(ll_j,'cs_orden_talla')
			li_talla   = lds_tallas.GetItemNumber(ll_j,'co_talla')
			ll_cnt     = lds_tallas.GetItemNumber(ll_j,'ca_programada')
			
			insert into dt_agrupaescalapdn  
           ( cs_agrupacion,cs_pdn,co_talla,cs_talla,co_estado,ca_unidades,   
           fe_creacion,fe_actualizacion,usuario,instancia )  
  			values ( :ll_csagrup,:ll_cspdn,:li_talla,:li_csorden,1,   
           :ll_cnt,current,current,user,sitename )  ;
	
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback;
				MessageBox("Advertencia!","No se pudo insertar las tallas.~n~n~nNota: " + ls_sqlerr )
				Return
			End If
		Next
	Else
		luo_param.il_vector[1] = ii_fabrica
		luo_param.il_vector[2] = il_pedido
		luo_param.il_vector[3] = li_lib
		luo_param.il_vector[4] = li_fabpt
		luo_param.il_vector[5] = li_lin
		luo_param.il_vector[6] = ll_ref
		luo_param.il_vector[7] = ll_color
		luo_param.il_vector[8] = li_csest
		luo_param.il_vector[9] = li_cspar
		
		luo_param.is_vector[1] = ls_po
		luo_param.is_vector[2] = ls_tono
		
		OpenWithParm(w_tallas_cantidad_produccion,luo_param)		
		
		luo_pmtalla = Message.PowerObjectParm
		
		If IsValid(luo_pmtalla) Then
			For ll_j = 1 To UpperBound(luo_pmtalla.il_talla[])
				li_csorden = luo_pmtalla.il_orden[ll_j]
				li_talla   = luo_pmtalla.il_talla[ll_j]
				ll_cnt     = luo_pmtalla.il_cant[ll_j]
				
				insert into dt_agrupaescalapdn  
				  ( cs_agrupacion,cs_pdn,co_talla,cs_talla,co_estado,ca_unidades,   
				  fe_creacion,fe_actualizacion,usuario,instancia )  
				values ( :ll_csagrup,:ll_cspdn,:li_talla,:li_csorden,1,   
				  :ll_cnt,current,current,user,sitename )  ;
		
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback;
					MessageBox("Advertencia!","No se pudo insertar las tallas.~n~n~nNota: " + ls_sqlerr )
					Return
				End If
			Next
		End If
		
	End If
	
	// Rayas
	li_tipo = dw_dt_agrupa.GetItemNumber(li_i,'co_tipo_rayas')
	
	If li_tipo = 1 Then
		lds_rayas.Retrieve(ll_csagrup,ll_cspdn)
		
		For ll_j = 1 To lds_rayas.RowCount()
						
			ll_modulo = lds_rayas.GetItemNumber(ll_j,'co_modelo')
			ll_raya   = lds_rayas.GetItemNumber(ll_j,'raya')
			ll_cnt    = lds_rayas.GetItemNumber(ll_j,'ca_unidades')
			
			insert into dt_agrupa_pdn_raya  
           ( cs_agrupacion,cs_pdn,co_modelo,raya,ca_unidades,   
           co_tipo,co_estado,fe_creacion,fe_actualizacion,   
           usuario,instancia )  
         values ( :ll_csagrup,:ll_cspdn,:ll_modulo,:ll_raya,:ll_cnt,   
           1,1,current,current,user,sitename )  ;
	
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback;
				MessageBox("Advertencia!","No se pudo insertar las rayas.~n~n~nNota: " + ls_sqlerr )
				Return
			End If
		Next
	Else
		luo_param.il_vector[1] = ll_csagrup
		luo_param.il_vector[2] = ll_cspdn
				
		OpenWithParm(w_rayas_cantidad_produccion,luo_param)		
		
		luo_pmtalla = Message.PowerObjectParm
		
		If IsValid(luo_pmtalla) Then
			For ll_j = 1 To UpperBound(luo_pmtalla.il_talla[])
				ll_modulo = luo_pmtalla.il_orden[ll_j]
				ll_raya   = luo_pmtalla.il_talla[ll_j]
				ll_cnt    = luo_pmtalla.il_cant[ll_j]
				
				insert into dt_agrupa_pdn_raya  
				  ( cs_agrupacion,cs_pdn,co_modelo,raya,ca_unidades,   
				  co_tipo,co_estado,fe_creacion,fe_actualizacion,   
				  usuario,instancia )  
				values ( :ll_csagrup,:ll_cspdn,:ll_modulo,:ll_raya,:ll_cnt,   
				  1,1,current,current,user,sitename )  ;
		
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback;
					MessageBox("Advertencia!","No se pudo insertar las rayas.~n~n~nNota: " + ls_sqlerr )
					Return
				End If
			Next
		End If
	End If
Next


commit ;

dw_dt_agrupa.Reset()

This.Enabled = False


end event

type dw_dt_agrupa from u_dw_base within tabpage_1
integer x = 46
integer y = 572
integer width = 2094
integer height = 572
integer taborder = 50
string dataobject = "d_insercion_dt_agrupacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dberror;call super::dberror;Return 1
end event

type cb_2 from commandbutton within tabpage_1
integer x = 1833
integer y = 72
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Nuevo"
end type

event clicked;Long   ll_fila,ll_agrupa
String ls_sqlerr



select max(cs_agrupacion)  
  into :ll_agrupa  
  from h_agrupa_pdn  ;
  
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlerrText
	rollback ;
	MessageBox("Advertencia!","No se pudo obtener el consecutivo de la asignaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: "+ ls_sqlerr,StopSign!)
	Return
End If


If IsNull(ll_agrupa) Then
	ll_agrupa = 0
End If

ll_agrupa ++

ll_fila = tab_1.tabpage_1.dw_h_agrupa.InsertRow(0)

If ll_fila <= 0 Then
	MessageBox("Advertencia!","No se pudo insertar el encabezado de la agrupaci$$HEX1$$f300$$ENDHEX$$n.",StopSign!)
	Return
End If
	
tab_1.tabpage_1.dw_h_agrupa.SetItem(ll_fila,'cs_agrupacion',ll_agrupa)
tab_1.tabpage_1.dw_h_agrupa.SetItem(ll_fila,'co_fabrica_exp',ii_fabrica)
tab_1.tabpage_1.dw_h_agrupa.SetItem(ll_fila,'pedido',il_pedido)
tab_1.tabpage_1.dw_h_agrupa.SetItem(ll_fila,'usuario',gstr_info_usuario.codigo_usuario)
tab_1.tabpage_1.dw_h_agrupa.SetItem(ll_fila,'instancia',gstr_info_usuario.instancia)

If tab_1.tabpage_1.dw_h_agrupa.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlerrText
	rollback ;
	MessageBox("Advertencia!","No se pudo insertar el encabezado de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: "+ ls_sqlerr,StopSign!)
	Return
Else
	commit ;
End IF
end event

type dw_h_agrupa from u_dw_base within tabpage_1
integer x = 46
integer y = 56
integer width = 1723
integer height = 432
integer taborder = 20
string dataobject = "d_lista_h_agrupa_pdn"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;
If Row <= 0 Then Return

This.SetRow(Row)
This.SelectRow(0,False)
This.SelectRow(Row,True)


end event

type gb_1 from groupbox within tabpage_1
integer x = 14
integer y = 4
integer width = 1792
integer height = 512
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agrupaciones"
end type

type gb_2 from groupbox within tabpage_1
integer x = 14
integer y = 516
integer width = 2162
integer height = 660
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Producci$$HEX1$$f300$$ENDHEX$$n"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2190
integer height = 1308
long backcolor = 67108864
string text = "Borrar"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_4 cb_4
dw_detalle_agrupa dw_detalle_agrupa
dw_agrupa_borrar dw_agrupa_borrar
gb_3 gb_3
gb_4 gb_4
end type

on tabpage_2.create
this.cb_4=create cb_4
this.dw_detalle_agrupa=create dw_detalle_agrupa
this.dw_agrupa_borrar=create dw_agrupa_borrar
this.gb_3=create gb_3
this.gb_4=create gb_4
this.Control[]={this.cb_4,&
this.dw_detalle_agrupa,&
this.dw_agrupa_borrar,&
this.gb_3,&
this.gb_4}
end on

on tabpage_2.destroy
destroy(this.cb_4)
destroy(this.dw_detalle_agrupa)
destroy(this.dw_agrupa_borrar)
destroy(this.gb_3)
destroy(this.gb_4)
end on

type cb_4 from commandbutton within tabpage_2
integer x = 1833
integer y = 1192
integer width = 343
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Borrar"
end type

event clicked;Long   ll_fila,ll_agrupa,ll_pdn
String ls_sqlerr

ll_fila = idw_dato.GetRow()

If ll_fila <= 0 Then
	MessageBox("Advertencia!","Debe seleccionar la agrupaci$$HEX1$$f300$$ENDHEX$$n o producci$$HEX1$$f300$$ENDHEX$$n que desea borrar.")
	Return
End If


If idw_dato.ClassName() = 'dw_agrupa_borrar' Then
	ll_agrupa = dw_agrupa_borrar.GetItemNumber(ll_fila,'cs_agrupacion')
	
	delete from dt_agrupa_pdn_raya  
   where cs_agrupacion = :ll_agrupa ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar las rallas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	End If
	
	delete from dt_agrupaescalapdn  
   where cs_agrupacion = :ll_agrupa ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar las escalas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	End If

	delete from dt_agrupa_pdn  
   where cs_agrupacion = :ll_agrupa  ;

	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar la producci$$HEX1$$f300$$ENDHEX$$n de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	End If
	
	If dw_agrupa_borrar.DeleteRow(ll_fila) = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	ElseIf dw_agrupa_borrar.Update() = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	Else
		commit ;
	End If
	
ElseIf idw_dato.ClassName() = 'dw_detalle_agrupa' Then
	
	ll_agrupa = dw_detalle_agrupa.GetItemNumber(ll_fila,'cs_agrupacion')
	ll_pdn    = dw_detalle_agrupa.GetItemNumber(ll_fila,'cs_pdn')
	
	delete from dt_agrupa_pdn_raya  
   where cs_agrupacion = :ll_agrupa and
	      cs_pdn = :ll_pdn ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar las rallas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	End If
	
	delete from dt_agrupaescalapdn  
   where cs_agrupacion = :ll_agrupa and
	      cs_pdn = :ll_pdn ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar las escalas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	End If

	If dw_detalle_agrupa.DeleteRow(ll_fila) = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar la producci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	ElseIf dw_detalle_agrupa.Update() = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","No se pudo borrar la producci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
		Return
	Else
		commit ;
	End If
End If

end event

type dw_detalle_agrupa from u_dw_base within tabpage_2
integer x = 41
integer y = 608
integer width = 2094
integer height = 504
integer taborder = 70
string dataobject = "d_borrar_dt_agrupacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;
idw_dato = This
end event

event clicked;call super::clicked;
dw_agrupa_borrar.SelectRow(0,False)

If Row <=0 Then Return

This.SetRow(Row)
This.SelectRow(0,False)
This.SelectRow(Row,True)



end event

type dw_agrupa_borrar from u_dw_base within tabpage_2
integer x = 41
integer y = 60
integer width = 2094
integer height = 460
integer taborder = 40
string dataobject = "d_lista_h_agrupa_pdn"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;
dw_detalle_agrupa.SelectRow(0,False)

If Row <=0 Then Return 

This.SetRow(Row)
This.SelectRow(0,False)
This.SelectRow(Row,True)




end event

event getfocus;call super::getfocus;Long ll_fila,ll_agrupa

idw_dato = This


ll_fila = This.GetRow()

If ll_fila > 0 Then
	ll_agrupa = This.GetItemNumber(ll_fila,'cs_agrupacion')
	dw_detalle_agrupa.Retrieve(ll_agrupa)
End If

end event

event rowfocuschanged;call super::rowfocuschanged;Long ll_agrupa


If currentrow <= 0 Then
	dw_detalle_agrupa.Reset()
Else
	ll_agrupa = This.GetItemNumber(currentrow,'cs_agrupacion')
	dw_detalle_agrupa.Retrieve(ll_agrupa)
End If

end event

type gb_3 from groupbox within tabpage_2
integer x = 9
integer y = 4
integer width = 2167
integer height = 556
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agrupaciones"
end type

type gb_4 from groupbox within tabpage_2
integer x = 9
integer y = 556
integer width = 2167
integer height = 600
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

