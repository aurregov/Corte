HA$PBExportHeader$w_mantenimiento_agrupaciones.srw
forward
global type w_mantenimiento_agrupaciones from window
end type
type dw_agrupacion from datawindow within w_mantenimiento_agrupaciones
end type
type dw_escalas_tela from datawindow within w_mantenimiento_agrupaciones
end type
type dw_produccion_tela from datawindow within w_mantenimiento_agrupaciones
end type
type dw_rayas_tela from datawindow within w_mantenimiento_agrupaciones
end type
type dw_bases_trazos from datawindow within w_mantenimiento_agrupaciones
end type
type dw_rayas_agrupacion from datawindow within w_mantenimiento_agrupaciones
end type
type dw_escalas_agrupacion from datawindow within w_mantenimiento_agrupaciones
end type
type dw_produccion_agrupacion from datawindow within w_mantenimiento_agrupaciones
end type
type gb_1 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_2 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_3 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_4 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_5 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_6 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_7 from groupbox within w_mantenimiento_agrupaciones
end type
type gb_8 from groupbox within w_mantenimiento_agrupaciones
end type
end forward

global type w_mantenimiento_agrupaciones from window
integer width = 3621
integer height = 1948
boolean titlebar = true
string title = "Agrupaciones"
string menuname = "m_mantenimiento_agrupacion"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
event ue_insertar_detalle ( )
event ue_borrar_detalle ( )
dw_agrupacion dw_agrupacion
dw_escalas_tela dw_escalas_tela
dw_produccion_tela dw_produccion_tela
dw_rayas_tela dw_rayas_tela
dw_bases_trazos dw_bases_trazos
dw_rayas_agrupacion dw_rayas_agrupacion
dw_escalas_agrupacion dw_escalas_agrupacion
dw_produccion_agrupacion dw_produccion_agrupacion
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
gb_8 gb_8
end type
global w_mantenimiento_agrupaciones w_mantenimiento_agrupaciones

type variables
DataWindow idw_activa
end variables

forward prototypes
public subroutine of_insert_escalas_tela ()
public subroutine of_insert_rayas_tela ()
public subroutine of_insert_pdn_base ()
public subroutine of_insert_base_trazos ()
end prototypes

event ue_insertar_detalle;If idw_activa = dw_agrupacion Or idw_activa = dw_escalas_agrupacion Or idw_activa = dw_produccion_agrupacion Or &
	idw_activa = dw_rayas_agrupacion Or idw_activa = dw_produccion_tela Or idw_activa = dw_escalas_tela  Or &
	idw_activa = dw_rayas_tela Then
Else
	idw_activa.InsertRow(0)
End if

If idw_activa = dw_bases_trazos Then
	of_insert_base_trazos()
	If dw_bases_trazos.Update() = -1 Then
		MessageBox('Error','Ocurrio un error al momento de grabar h_bases_trazos')
		Rollback;
		Return
	End if
	
	dw_rayas_tela.AcceptText()
	If dw_rayas_tela.Update() = -1 Then
		MessageBox('Error','Ocurrio un error al momento de grabar en dt_rayas_telaxbase')
		Rollback;
		Return
	End if
End if

If idw_activa = dw_produccion_tela Then
	of_insert_pdn_base()
	If dw_produccion_tela.Update() = -1 Then
		MessageBox('Error','Ocurrio un error al momento de grabar dt_pdnxbase')
		Rollback;
		Return
	End if
End if

If idw_activa = dw_escalas_tela Then
	of_insert_escalas_tela()
	If dw_escalas_tela.Update() = -1 Then
		MessageBox('Error','Ocurrio un error al momento de grabar dt_pdnxbase')
		Rollback;
		Return
	End if
End if

If idw_activa = dw_rayas_tela Then
	of_insert_rayas_tela()
	If dw_rayas_tela.Update() = -1 Then
		MessageBox('Error','Ocurrio un error al momento de grabar dt_rayas_telaxbase')
		Rollback;
		Return
	End if
	
End if

end event

event ue_borrar_detalle;Long li_resp,li_pdn
Long ll_fila,ll_base,ll_agrupa,ll_pdn,ll_talla,ll_count,ll_modelo,ll_fabte,ll_reftel,ll_caract,ll_diametro,ll_color

//------------------------------
//eliminaci$$HEX1$$f300$$ENDHEX$$n de las escalas
//------------------------------
If idw_activa = dw_escalas_tela Then
	
	idw_activa.AcceptText()
	
	ll_fila = idw_activa.GetRow()
 	ll_agrupa = idw_activa.GetItemNumber(ll_fila,'cs_agrupacion') 
	ll_base = idw_activa.GetItemNumber(ll_fila,'cs_base_trazos') 
	ll_pdn = idw_activa.GetItemNumber(ll_fila,'cs_pdn') 
	ll_talla = idw_activa.GetItemNumber(ll_fila,'co_talla') 
	 
	 
   select count(*)
	Into :ll_count
	from dt_trazosxbase
	Where cs_agrupacion = :ll_agrupa and
			cs_base_trazos = :ll_base and
			cs_pdn = :ll_pdn and
			co_talla = :ll_talla;
	If ll_count >= 1 Then
		MessageBox('Error','Para eliminar la escala no puede existir relaci$$HEX1$$f300$$ENDHEX$$n con dt_trazosxbase')
		Rollback;
		Return
	Else//ll_count >= 1
		idw_activa.AcceptText()
		If idw_activa.RowCount() = 1 Then
			
			ll_fila = dw_produccion_tela.GetRow()
			li_pdn = dw_produccion_tela.GetItemNumber(ll_fila,'cs_pdn')
			li_resp = MessageBox('Advertencia','Esta es la ultima escala de la Producci$$HEX1$$f300$$ENDHEX$$n  '+String(li_pdn)+' Si realmente desea eliminarla, el sistema hara lo propio con la producci$$HEX1$$f300$$ENDHEX$$n', Question!,YesNoCancel!, 3)
			If li_resp = 1 Then
				
				
				ll_fila = dw_produccion_tela.GetRow()
				ll_agrupa = dw_produccion_tela.GetItemNumber(ll_fila,'cs_agrupacion') 
				ll_base = dw_produccion_tela.GetItemNumber(ll_fila,'cs_base_trazos') 
				ll_pdn = dw_produccion_tela.GetItemNumber(ll_fila,'cs_pdn') 
				
				select count(*)
				Into :ll_count
				from dt_trazosxbase
				Where cs_agrupacion = :ll_agrupa and
						cs_base_trazos = :ll_base and
						cs_pdn = :ll_pdn;
				If ll_count >= 1 Then
					MessageBox('Error','Para eliminar la escala no puede existir relaci$$HEX1$$f300$$ENDHEX$$n con dt_trazosxbase')
					Rollback;
					Return
				Else//ll_count >= 1
					idw_activa.DeleteRow(0)
					dw_produccion_tela.DeleteRow(0)
					dw_produccion_tela.SetFocus()
				End if//ll_count >= 1
			End if
		Else
			idw_activa.DeleteRow(0)
		End if
	End if//ll_count >= 1
End if


//--------------------------------
//eliminaci$$HEX1$$f300$$ENDHEX$$n de las rayas
//--------------------------------
If idw_activa = dw_rayas_tela Then
	
	idw_activa.AcceptText()
	
	ll_fila = idw_activa.GetRow()
 	ll_agrupa = idw_activa.GetItemNumber(ll_fila,'cs_agrupacion') 
	ll_base = idw_activa.GetItemNumber(ll_fila,'cs_base_trazos') 
	ll_modelo = idw_activa.GetItemNumber(ll_fila,'co_modelo') 
	ll_fabte = idw_activa.GetItemNumber(ll_fila,'co_fabrica_te')
	ll_reftel = idw_activa.GetItemNumber(ll_fila,'co_reftel')
	ll_caract = idw_activa.GetItemNumber(ll_fila,'co_caract')
	ll_diametro = idw_activa.GetItemNumber(ll_fila,'diametro')
	ll_color = idw_activa.GetItemNumber(ll_fila,'co_color_te')
	
	select count(*)
	Into :ll_count
	from dt_trazosxbase
	Where cs_agrupacion = :ll_agrupa and
			cs_base_trazos = :ll_base and
			co_modelo = :ll_modelo and
			co_fabrica_te = :ll_fabte and
			co_reftel = :ll_reftel and
			co_caract = :ll_caract and
			diametro = :ll_diametro and
			co_color_te = :ll_color;
	
	If ll_count >= 1 Then
		MessageBox('Error','No es posible eliminar la raya debido a que existe una relaci$$HEX1$$f300$$ENDHEX$$n con dt_trazosxbase')
		Rollback;
		Return
	Else//ll_count >= 1
		//If idw_activa.RowCount() = 1 Then
			//idw_activa.DeleteRow(0)
				
		
			//idw_activa.DeleteRow(0)
		
			
		//Else//idw_activa.RowCount() = 1  
			idw_activa.DeleteRow(0)
		//End if//idw_activa.RowCount() = 1
	End if//ll_count >= 1
End if//idw_activa = dw_rayas_tela


//-------------------------------------
//eliminacion de la produccion
//-------------------------------------
If idw_activa = dw_produccion_tela Then
	
	idw_activa.AcceptText()
	
	If idw_activa.RowCount() >= 1 Then
	
		ll_fila = idw_activa.GetRow()
		ll_agrupa = idw_activa.GetItemNumber(ll_fila,'cs_agrupacion') 
		ll_base = idw_activa.GetItemNumber(ll_fila,'cs_base_trazos') 
		ll_pdn = idw_activa.GetItemNumber(ll_fila,'cs_pdn') 
		
		
		select count(*)
		Into :ll_count
		from dt_trazosxbase
		Where cs_agrupacion = :ll_agrupa and
				cs_base_trazos = :ll_base and
				cs_pdn = :ll_pdn ;
		
		If ll_count >= 1 Then
			MessageBox('Error','No es posible eliminar la raya debido a que existe una relaci$$HEX1$$f300$$ENDHEX$$n con dt_trazosxbase')
			Rollback;
			Return
		Else//ll_count >= 1
			If idw_activa.RowCount() = 1 Then
				If dw_rayas_tela.RowCount() = 0 Then
					ll_fila = dw_bases_trazos.GetRow()
					ll_base = dw_bases_trazos.GetItemNumber(ll_fila,'Raya')
					li_resp = MessageBox('Advertencia','Esta es la ultima producci$$HEX1$$f300$$ENDHEX$$n de la base  '+String(ll_base)+' Si realmente desea eliminarla, el sistema hara lo propio con la base', Question!,YesNoCancel!, 3)			
					If li_resp = 1 Then
						
//						ll_fila = dw_bases_trazos.GetRow()
//						ll_agrupa = dw_bases_trazos.GetItemNumber(ll_fila,'cs_agrupacion') 
//						ll_base = dw_bases_trazos.GetItemNumber(ll_fila,'cs_base_trazos') 
//						
//						select count(*)
//						Into :ll_count
//						from dt_trazosxbase
//						Where cs_agrupacion = :ll_agrupa and
//								cs_base_trazos = :ll_base;
//								
//						If ll_count >= 1 Then
//							MessageBox('Error','Para eliminar la escala no puede existir relaci$$HEX1$$f300$$ENDHEX$$n con dt_trazosxbase')
//							Rollback;
//							Return
//						Else//ll_count >= 1 		
							idw_activa.DeleteRow(0)
//							dw_bases_trazos.DeleteRow(0)
//							dw_bases_trazos.SetFocus()
//						End if//ll_count >= 1 
					End if//li_resp = 1 
					
				Else//dw_produccion_tela.RowCount() = 0 
					idw_activa.DeleteRow(0)
				End if//dw_produccion_tela.RowCount() = 0 
				
			Else//idw_activa.RowCount() = 1  
				idw_activa.DeleteRow(0)
			End if//idw_activa.RowCount() = 1
		End if//ll_count >= 1
	End if//idw_activa.RowCount() < 1
End if//idw_activa = dw_rayas_tela


//-------------------------------------
//eliminacion de la base
//-------------------------------------
If idw_activa = dw_bases_trazos Then
	
	idw_activa.AcceptText()
	
	ll_fila = idw_activa.GetRow()
 	ll_agrupa = idw_activa.GetItemNumber(ll_fila,'cs_agrupacion') 
	ll_base = idw_activa.GetItemNumber(ll_fila,'cs_base_trazos') 
		 
	 
   select count(*)
	Into :ll_count
	from dt_trazosxbase
	Where cs_agrupacion = :ll_agrupa and
			cs_base_trazos = :ll_base;
	If ll_count >= 1 Then
		MessageBox('Error','No es posible eliminar la base seleccionada, debido a que existe una relaci$$HEX1$$f300$$ENDHEX$$n con dt_trazosxbase ')
	Else
		idw_activa.DeleteRow(0)
	End if
End if











dw_escalas_tela.AcceptText()
dw_produccion_tela.AcceptText()
dw_rayas_tela.AcceptText()
dw_bases_trazos.AcceptText()


If dw_escalas_tela.Update() = -1 Then
	Rollback;
Else 
	If dw_produccion_tela.Update() = -1 Then
		Rollback;
	End if
End if

If dw_rayas_tela.Update() = -1 Then
	Rollback;
End if

If dw_bases_trazos.Update() = -1 Then
	Rollback;
End if


end event

public subroutine of_insert_escalas_tela ();n_cts_param luo_param
n_cts_param_raya luo_raya
Long ll_raya,ll_asigna,ll_fila,ll_fabte,ll_modelo,ll_reftel,ll_caract,ll_diametro,ll_color,ll_agrupa,ll_pdn,ll_fila2,&
		ll_i,ll_trazos

dw_produccion_tela.AcceptText()

ll_agrupa = dw_produccion_tela.GetItemNumber(dw_produccion_tela.GetRow(),'cs_agrupacion')
ll_pdn = dw_produccion_tela.GetItemNumber(dw_produccion_tela.GetRow(),'cs_pdn')
ll_trazos = dw_produccion_tela.GetItemNumber(dw_produccion_tela.GetRow(),'cs_base_trazos')

dw_bases_trazos.AcceptText()
		
luo_param.il_vector[1] = ll_agrupa
luo_param.il_vector[2] = ll_pdn
luo_param.il_vector[3] = ll_trazos

OpenWithParm(w_buscar_escalas_tela,luo_param)

luo_raya = Message.PowerObjectParm

SetPointer(Hourglass!)

If luo_raya.il_fila[1] >= 1 Then
	For ll_fila = 1 To luo_raya.il_fila[1]
		
		dw_escalas_tela.InsertRow(0)
		dw_escalas_tela.AcceptText()
		ll_fila2 = dw_escalas_tela.RowCount()
	
		dw_escalas_tela.SetItem(ll_fila2,'cs_agrupacion',ll_agrupa)
		dw_escalas_tela.SetItem(ll_fila2,'cs_base_trazos',ll_trazos)
		dw_escalas_tela.SetItem(ll_fila2,'cs_pdn',ll_pdn)
		dw_escalas_tela.SetItem(ll_fila2,'co_talla',luo_raya.il_modelo[ll_fila])
		dw_escalas_tela.SetItem(ll_fila2,'cs_talla',luo_raya.il_reftel[ll_fila])
		dw_escalas_tela.SetItem(ll_fila2,'ca_unidades',luo_raya.il_diametro[ll_fila])
		dw_escalas_tela.SetItem(ll_fila2,'co_estado',luo_raya.il_caract[ll_fila])
		dw_escalas_tela.SetItem(ll_fila2,'fe_creacion', f_fecha_servidor())
		dw_escalas_tela.SetItem(ll_fila2,'fe_actualizacion', f_fecha_servidor())
		dw_escalas_tela.SetItem(ll_fila2,'usuario', gstr_info_usuario.codigo_usuario)
		dw_escalas_tela.SetItem(ll_fila2,'instancia', gstr_info_usuario.instancia)
	Next
End if
end subroutine

public subroutine of_insert_rayas_tela ();n_cts_param_raya luo_raya
n_cts_param luo_param
Long ll_raya,ll_asigna,ll_fila,ll_fabte,ll_modelo,ll_reftel,ll_caract,ll_diametro,ll_color,ll_agrupa,ll_trazos,&
		ll_base,ll_i,ll_count

dw_bases_trazos.AcceptText()

ll_agrupa = dw_bases_trazos.GetItemNumber(dw_bases_trazos.GetRow(),'cs_agrupacion')
ll_trazos = dw_bases_trazos.GetItemNumber(dw_bases_trazos.GetRow(),'cs_base_trazos')

luo_param.il_vector[1] = ll_agrupa
luo_param.il_vector[2] = ll_trazos

OpenWithParm(w_buscar_rayasxbase_insert,luo_param)

luo_raya = Message.PowerObjectParm

SetPointer(Hourglass!)

dw_rayas_tela.AcceptText()

ll_count = dw_rayas_tela.RowCount()

If luo_raya.il_fila[1] >= 1 Then
	For ll_fila = 1 To luo_raya.il_fila[1]
		If isnull(ll_fila) Then
			ll_fila = 0
		End if
		dw_rayas_tela.InsertRow(0)
				
		dw_rayas_tela.SetItem(ll_fila + ll_count,'co_modelo',luo_raya.il_modelo[ll_fila])
		dw_rayas_tela.SetItem(ll_fila + ll_count,'co_reftel',luo_raya.il_reftel[ll_fila])
		dw_rayas_tela.SetItem(ll_fila + ll_count,'co_caract',luo_raya.il_caract[ll_fila])
		dw_rayas_tela.SetItem(ll_fila + ll_count,'diametro',luo_raya.il_diametro[ll_fila])
		dw_rayas_tela.SetItem(ll_fila + ll_count,'co_color_te',luo_raya.il_color[ll_fila])
		dw_rayas_tela.SetItem(ll_fila + ll_count,'raya',luo_raya.il_raya[ll_fila])
		
		ll_modelo = luo_raya.il_modelo[ll_fila]
		
		//busco co_fabrica_tela
		select distinct co_fabrica_tela
		into :ll_fabte
		from dt_telaxmodelo_lib,dt_agrupa_pdn,dt_agrupaescalapdn
		where dt_telaxmodelo_lib.co_fabrica_exp = dt_agrupa_pdn.co_fabrica_exp and
				dt_telaxmodelo_lib.pedido = dt_agrupa_pdn.pedido and
				dt_telaxmodelo_lib.cs_liberacion = dt_agrupa_pdn.cs_liberacion and
				dt_telaxmodelo_lib.nu_orden = dt_agrupa_pdn.po and
				dt_telaxmodelo_lib.co_fabrica_pt = dt_agrupa_pdn.co_fabrica_pt and
				dt_telaxmodelo_lib.tono = dt_agrupa_pdn.tono and
				dt_telaxmodelo_lib.cs_estilocolortono = dt_agrupa_pdn.cs_estilocolortono and
				dt_telaxmodelo_lib.co_modelo = :ll_modelo and
				/*dt_telaxmodelo_lib.co_reftel = :ll_reftel and
				dt_telaxmodelo_lib.co_caract = :ll_caract and
				dt_telaxmodelo_lib.diametro = :ll_diametro and
				dt_telaxmodelo_lib.co_color_tela = :ll_color and
				dt_telaxmodelo_lib.raya = :ll_raya and*/
				dt_agrupa_pdn.cs_agrupacion = :ll_agrupa /*and
				dt_agrupaescalapdn.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion and
				dt_agrupaescalapdn.cs_pdn = dt_agrupa_pdn.cs_pdn and
				dt_agrupaescalapdn.co_talla = dt_color_modelo.co_talla and
				dt_color_modelo.co_fabrica = dt_agrupa_pdn.co_fabrica_pt and
				dt_color_modelo.co_linea = dt_agrupa_pdn.co_linea and
				dt_color_modelo.co_referencia = dt_agrupa_pdn.co_referencia and
				dt_color_modelo.co_color_te = dt_agrupa_pdn.co_color_pt*/;
		
		dw_rayas_tela.SetItem(ll_fila + ll_count,'co_fabrica_te',ll_fabte)
		dw_rayas_tela.SetItem(ll_fila + ll_count,'cs_agrupacion',ll_agrupa)
		dw_rayas_tela.SetItem(ll_fila + ll_count,'cs_base_trazos',ll_trazos)
		dw_rayas_tela.SetItem(ll_fila + ll_count, "fe_creacion", f_fecha_servidor())
		dw_rayas_tela.SetItem(ll_fila + ll_count, "fe_actualizacion", f_fecha_servidor())
		dw_rayas_tela.SetItem(ll_fila + ll_count, "usuario", gstr_info_usuario.codigo_usuario)
		dw_rayas_tela.SetItem(ll_fila + ll_count, "instancia", gstr_info_usuario.instancia)
		
	Next

End if
end subroutine

public subroutine of_insert_pdn_base ();n_cts_param luo_param
Long ll_raya,ll_asigna,ll_fila,ll_fabte,ll_modelo,ll_reftel,ll_caract,ll_diametro,ll_color,ll_agrupa,ll_trazos,ll_fila2,&
		ll_i

dw_bases_trazos.AcceptText()

ll_agrupa = dw_bases_trazos.GetItemNumber(dw_bases_trazos.GetRow(),'cs_agrupacion')
ll_trazos = dw_bases_trazos.GetItemNumber(dw_bases_trazos.GetRow(),'cs_base_trazos')

dw_bases_trazos.AcceptText()
		
luo_param.il_vector[1] = ll_agrupa
luo_param.il_vector[2] = ll_trazos

OpenWithParm(w_buscar_produccion_base,luo_param)

luo_param = Message.PowerObjectParm

SetPointer(Hourglass!)

If luo_param.il_vector[3] >= 1 Then
	For ll_fila = 1 To luo_param.il_vector[3]
		
		For ll_i = 1 To dw_produccion_tela.RowCount()
			If luo_param.il_vector2[ll_fila] = dw_produccion_tela.GetItemNumber(ll_i,'cs_pdn') Then
				MessageBox('Error','La Producci$$HEX1$$f300$$ENDHEX$$n No. '+String(luo_param.il_vector2[ll_fila])+' ya existe')
				Return
			End if
		Next
		
		dw_produccion_tela.InsertRow(0)
//		ll_fila2 = dw_produccion_tela.ScrollToRow(dw_produccion_tela.RowCount())
	
//		dw_produccion_tela.SetItem(ll_fila2,'cs_agrupacion',ll_agrupa)
//		dw_produccion_tela.SetItem(ll_fila2,'cs_base_trazos',ll_trazos)
//		dw_produccion_tela.SetItem(ll_fila2,'cs_pdn',luo_param.il_vector2[ll_fila])
//		dw_produccion_tela.SetItem(ll_fila2, "fe_creacion", f_fecha_servidor())
//		dw_produccion_tela.SetItem(ll_fila2, "fe_actualizacion", f_fecha_servidor())
//		dw_produccion_tela.SetItem(ll_fila2, "usuario", gstr_info_usuario.codigo_usuario)
//		dw_produccion_tela.SetItem(ll_fila2, "instancia", gstr_info_usuario.instancia)
		
		dw_produccion_tela.SetItem(ll_fila,'cs_agrupacion',ll_agrupa)
		dw_produccion_tela.SetItem(ll_fila,'cs_base_trazos',ll_trazos)
		dw_produccion_tela.SetItem(ll_fila,'cs_pdn',luo_param.il_vector2[ll_fila])
		dw_produccion_tela.SetItem(ll_fila, "fe_creacion", f_fecha_servidor())
		dw_produccion_tela.SetItem(ll_fila, "fe_actualizacion", f_fecha_servidor())
		dw_produccion_tela.SetItem(ll_fila, "usuario", gstr_info_usuario.codigo_usuario)
		dw_produccion_tela.SetItem(ll_fila, "instancia", gstr_info_usuario.instancia)
		
	Next
End if
end subroutine

public subroutine of_insert_base_trazos ();n_cts_param_raya luo_raya
n_cts_param luo_param
Long ll_raya,ll_asigna,ll_fila,ll_fabte,ll_modelo,ll_reftel,ll_caract,ll_diametro,ll_color,ll_agrupa,ll_trazos,&
		ll_base,ll_i

dw_bases_trazos.AcceptText()

ll_agrupa = dw_bases_trazos.GetItemNumber(dw_bases_trazos.GetRow(),'cs_agrupacion')
ll_trazos = dw_bases_trazos.GetItemNumber(dw_bases_trazos.GetRow(),'cs_base_trazos')

dw_bases_trazos.AcceptText()

dw_bases_trazos.ScrollToRow(dw_bases_trazos.RowCount())
	 
ll_raya = dw_bases_trazos.GetItemNumber(dw_bases_trazos.RowCount() - 1,'raya')
ll_base = dw_bases_trazos.GetItemNumber(dw_bases_trazos.RowCount() - 1,'cs_base_trazos')

//dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(),'raya',ll_raya + 10)
dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(),'cs_base_trazos',ll_base + 1)

dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(), "cs_agrupacion",ll_agrupa)
dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(), "fe_creacion", f_fecha_servidor())
dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(), "fe_actualizacion", f_fecha_servidor())
dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(), "usuario", gstr_info_usuario.codigo_usuario)
dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(), "instancia", gstr_info_usuario.instancia)		

dw_bases_trazos.AcceptText()
	
	
ll_asigna = dw_agrupacion.GetItemNumber(1,'cs_agrupacion')
luo_param.il_vector[1] = ll_asigna

OpenWithParm(w_buscar_rayasxbase2,luo_param)

luo_raya = Message.PowerObjectParm

dw_bases_trazos.SetItem(dw_bases_trazos.RowCount(),'raya',luo_raya.il_raya[1])

SetPointer(Hourglass!)

If luo_raya.il_fila[1] >= 1 Then
	For ll_fila = 1 To luo_raya.il_fila[1]
		dw_rayas_tela.InsertRow(0)
		dw_rayas_tela.SetItem(ll_fila,'co_modelo',luo_raya.il_modelo[ll_fila])
		dw_rayas_tela.SetItem(ll_fila,'co_reftel',luo_raya.il_reftel[ll_fila])
		dw_rayas_tela.SetItem(ll_fila,'co_caract',luo_raya.il_caract[ll_fila])
		dw_rayas_tela.SetItem(ll_fila,'diametro',luo_raya.il_diametro[ll_fila])
		dw_rayas_tela.SetItem(ll_fila,'co_color_te',luo_raya.il_color[ll_fila])
		dw_rayas_tela.SetItem(ll_fila,'raya',luo_raya.il_raya[ll_fila])
		
		ll_modelo = luo_raya.il_modelo[ll_fila]
		
		//busco co_fabrica_tela
		select distinct co_fabrica_tela
		into :ll_fabte
		from dt_telaxmodelo_lib,dt_agrupa_pdn,dt_agrupaescalapdn
		where dt_telaxmodelo_lib.co_fabrica_exp = dt_agrupa_pdn.co_fabrica_exp and
				dt_telaxmodelo_lib.pedido = dt_agrupa_pdn.pedido and
				dt_telaxmodelo_lib.cs_liberacion = dt_agrupa_pdn.cs_liberacion and
				dt_telaxmodelo_lib.nu_orden = dt_agrupa_pdn.po and
				dt_telaxmodelo_lib.co_fabrica_pt = dt_agrupa_pdn.co_fabrica_pt and
				dt_telaxmodelo_lib.tono = dt_agrupa_pdn.tono and
				dt_telaxmodelo_lib.cs_estilocolortono = dt_agrupa_pdn.cs_estilocolortono and
				dt_telaxmodelo_lib.co_modelo = :ll_modelo and
				dt_agrupa_pdn.cs_agrupacion = :ll_agrupa;
				
		IF SQLCA.SQLCODE=-1 THEN
			MessageBox("Error Base Datos","No pudo traer fabrica de la tela")
			Return
		ELSE
		END IF
		
		dw_rayas_tela.SetItem(ll_fila,'co_fabrica_te',ll_fabte)
		dw_rayas_tela.SetItem(ll_fila,'cs_agrupacion',ll_agrupa)
		dw_rayas_tela.SetItem(ll_fila,'cs_base_trazos',ll_base + 1)
		dw_rayas_tela.SetItem(ll_fila, "fe_creacion", f_fecha_servidor())
		dw_rayas_tela.SetItem(ll_fila, "fe_actualizacion", f_fecha_servidor())
		dw_rayas_tela.SetItem(ll_fila, "usuario", gstr_info_usuario.codigo_usuario)
		dw_rayas_tela.SetItem(ll_fila, "instancia", gstr_info_usuario.instancia)
		
	Next

End if
end subroutine

on w_mantenimiento_agrupaciones.create
if this.MenuName = "m_mantenimiento_agrupacion" then this.MenuID = create m_mantenimiento_agrupacion
this.dw_agrupacion=create dw_agrupacion
this.dw_escalas_tela=create dw_escalas_tela
this.dw_produccion_tela=create dw_produccion_tela
this.dw_rayas_tela=create dw_rayas_tela
this.dw_bases_trazos=create dw_bases_trazos
this.dw_rayas_agrupacion=create dw_rayas_agrupacion
this.dw_escalas_agrupacion=create dw_escalas_agrupacion
this.dw_produccion_agrupacion=create dw_produccion_agrupacion
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
this.gb_8=create gb_8
this.Control[]={this.dw_agrupacion,&
this.dw_escalas_tela,&
this.dw_produccion_tela,&
this.dw_rayas_tela,&
this.dw_bases_trazos,&
this.dw_rayas_agrupacion,&
this.dw_escalas_agrupacion,&
this.dw_produccion_agrupacion,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5,&
this.gb_6,&
this.gb_7,&
this.gb_8}
end on

on w_mantenimiento_agrupaciones.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_agrupacion)
destroy(this.dw_escalas_tela)
destroy(this.dw_produccion_tela)
destroy(this.dw_rayas_tela)
destroy(this.dw_bases_trazos)
destroy(this.dw_rayas_agrupacion)
destroy(this.dw_escalas_agrupacion)
destroy(this.dw_produccion_agrupacion)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
destroy(this.gb_8)
end on

event open;This.X = 1 
This.Y = 1
This.Width = 3800
This.Height = 1850

dw_agrupacion.SetTransObject(sqlca)
dw_bases_trazos.SetTransObject(sqlca)
dw_escalas_agrupacion.SetTransObject(sqlca)
dw_escalas_tela.SetTransObject(sqlca)
dw_produccion_agrupacion.SetTransObject(sqlca)
dw_produccion_tela.SetTransObject(sqlca)
dw_rayas_agrupacion.SetTransObject(sqlca)
dw_rayas_tela.SetTransObject(sqlca)

dw_agrupacion.InsertRow(0)



end event

type dw_agrupacion from datawindow within w_mantenimiento_agrupaciones
integer x = 37
integer y = 116
integer width = 1330
integer height = 100
integer taborder = 10
string title = "none"
string dataobject = "dff_mantenimiento_h_agrupa_pdn"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long ll_agrupacion,ll_pdn,ll_estado

This.AcceptText()

CHOOSE CASE GetColumnName()
		
	CASE 'cs_agrupacion'
		ll_agrupacion = dw_agrupacion.GetItemNumber(1,'cs_agrupacion')
		
		select co_estado
		into :ll_estado
		from h_agrupa_pdn
		where cs_agrupacion = :ll_agrupacion;
		
		If Sqlca.SqlCode = -1 Or Sqlca.SqlCode = 100 Then
			MessageBox('Error','No existe ninguna agrupaci$$HEX1$$f300$$ENDHEX$$n con el c$$HEX1$$f300$$ENDHEX$$digo digitado')
			Return 1
		Else
			dw_agrupacion.SetItem(1,'co_estado',ll_estado)
						
			dw_produccion_agrupacion.Retrieve(ll_agrupacion)
			dw_produccion_agrupacion.SetFocus()
			dw_bases_trazos.Retrieve(ll_agrupacion)
			dw_bases_trazos.TriggerEvent(RowFocusChanged!)
		End if
END CHOOSE

end event

event getfocus;gb_4.textcolor = Rgb(0,0,255)
gb_2.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_agrupacion
end event

event itemerror;return 1
end event

type dw_escalas_tela from datawindow within w_mantenimiento_agrupaciones
integer x = 2546
integer y = 1012
integer width = 1001
integer height = 640
integer taborder = 40
string title = "none"
string dataobject = "dtb_mantenimiento_dt_escalaxpdnbase"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;gb_8.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_2.textcolor = Rgb(0,0,0)

idw_activa = dw_escalas_tela
end event

event clicked;Long ll_fila

dw_escalas_tela.AcceptText()

For ll_fila = 1 To dw_escalas_tela.RowCount()
	dw_escalas_tela.SelectRow(ll_fila,FALSE)
Next

IF IsSelected (Row ) = FALSE THEN
	dw_escalas_tela.SelectRow(Row,TRUE)
ELSE 
	dw_escalas_tela.SelectRow(Row,FALSE)
END IF
end event

type dw_produccion_tela from datawindow within w_mantenimiento_agrupaciones
integer x = 2085
integer y = 1012
integer width = 343
integer height = 636
integer taborder = 30
string title = "none"
string dataobject = "dtb_mantenimiento_dt_pdnxbase"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemfocuschanged;Long ll_agrupa,ll_trazos,ll_pdn,ll_fila

This.AcceptText()


ll_fila = GetRow()

ll_agrupa = This.GetItemNumber(ll_fila,'cs_agrupacion')
ll_trazos = This.GetItemNumber(ll_fila,'cs_base_trazos')
ll_pdn = This.GetItemNumber(ll_fila,'cs_pdn')

dw_escalas_tela.Retrieve(ll_agrupa,ll_trazos,ll_pdn)

end event

event getfocus;gb_7.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_2.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_produccion_tela



end event

event clicked;IF IsSelected (Row ) = FALSE THEN
	dw_produccion_tela.SelectRow(Row,TRUE)
ELSE 
	dw_produccion_tela.SelectRow(Row,FALSE)
END IF
end event

event rowfocuschanged;Long ll_agrupa,ll_trazos,ll_pdn,ll_fila

This.AcceptText()


ll_fila = this.GetRow()

If ll_fila > 0 Then

	ll_agrupa = This.GetItemNumber(ll_fila,'cs_agrupacion')
	ll_trazos = This.GetItemNumber(ll_fila,'cs_base_trazos')
	ll_pdn = This.GetItemNumber(ll_fila,'cs_pdn')
	
	dw_escalas_tela.Retrieve(ll_agrupa,ll_trazos,ll_pdn)

End if

end event

type dw_rayas_tela from datawindow within w_mantenimiento_agrupaciones
integer x = 2053
integer y = 468
integer width = 1477
integer height = 384
integer taborder = 20
string title = "none"
string dataobject = "dtb_dt_rayas_telaxbase"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;gb_6.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_2.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_rayas_tela
end event

event clicked;Long ll_fila

dw_rayas_tela.AcceptText()

For ll_fila = 1 To dw_rayas_tela.RowCount()
	dw_rayas_tela.SelectRow(ll_fila,FALSE)
Next


IF IsSelected (Row ) = FALSE THEN
	dw_rayas_tela.SelectRow(Row,TRUE)
ELSE 
	dw_rayas_tela.SelectRow(Row,FALSE)
END IF
end event

type dw_bases_trazos from datawindow within w_mantenimiento_agrupaciones
integer x = 2098
integer y = 108
integer width = 814
integer height = 244
integer taborder = 10
string title = "none"
string dataobject = "dtb_mantenimiento_h_base_trazos"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemfocuschanged;//Long ll_agrupa,ll_trazos,ll_fila,ll_pdn
//
//This.AcceptText()
//
//
//ll_fila = GetRow()
//
//ll_agrupa = This.GetItemNumber(ll_fila,'cs_agrupacion')
//ll_trazos = This.GetItemNumber(ll_fila,'cs_base_trazos')
//
//dw_rayas_tela.Retrieve(ll_agrupa,ll_trazos)
//dw_produccion_tela.Retrieve(ll_agrupa,ll_trazos)
//
//If dw_produccion_tela.RowCount() >= 1 Then
//	
//	dw_produccion_tela.AcceptText()
//	
//	ll_fila = dw_produccion_tela.GetRow()
//	
//	ll_pdn = dw_produccion_tela.GetItemNumber(ll_fila,'cs_pdn')
//	
//	dw_escalas_tela.Retrieve(ll_agrupa,ll_trazos,ll_pdn)
//Else
//	dw_escalas_tela.Reset()
//	
//End if
end event

event getfocus;gb_5.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_2.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_bases_trazos
end event

event clicked;Long ll_fila

dw_bases_trazos.AcceptText()

For ll_fila = 1 To dw_bases_trazos.RowCount()
	dw_bases_trazos.SelectRow(ll_fila,FALSE)
Next

IF IsSelected (Row ) = FALSE THEN
	dw_bases_trazos.SelectRow(Row,TRUE)
ELSE 
	dw_bases_trazos.SelectRow(Row,FALSE)
END IF
end event

event rowfocuschanged;Long ll_agrupa,ll_trazos,ll_fila,ll_pdn

This.AcceptText()

ll_fila = This.GetRow()

ll_agrupa = This.GetItemNumber(ll_fila,'cs_agrupacion')
ll_trazos = This.GetItemNumber(ll_fila,'cs_base_trazos')

dw_rayas_tela.Retrieve(ll_agrupa,ll_trazos)
dw_produccion_tela.Retrieve(ll_agrupa,ll_trazos)

If dw_produccion_tela.RowCount() >= 1 Then
	
	dw_produccion_tela.AcceptText()
	
	ll_fila = dw_produccion_tela.GetRow()
	
	ll_pdn = dw_produccion_tela.GetItemNumber(ll_fila,'cs_pdn')
	
	dw_escalas_tela.Retrieve(ll_agrupa,ll_trazos,ll_pdn)
Else
	dw_escalas_tela.Reset()
	
End if
end event

event itemchanged;//verifica los datos y la consistencia de los mismos al momento que el usuario cambie la base de
//incompleta a completa

Long ll_agrupa,ll_base,ll_count,ll_estado

This.AcceptText()

CHOOSE CASE GetColumnName()
	CASE 'co_estado'
		ll_estado = This.GetItemNumber(This.GetRow(),'co_estado')
						
			If ll_estado = 2 Then
			
				//---------------------------------------
				//1.  verificaci$$HEX1$$f300$$ENDHEX$$n de datos en producci$$HEX1$$f300$$ENDHEX$$n, escalas y en rayas
				//---------------------------------------
				ll_agrupa = This.GetItemNumber(This.GetRow(),'cs_agrupacion')
				ll_base = This.GetItemNumber(This.GetRow(),'cs_base_trazos')
				
				//verifico en dt_rayas_telaxbase
				select count(*)
				into :ll_count
				from dt_rayas_telaxbase
				where cs_agrupacion = :ll_agrupa and
						cs_base_trazos = :ll_base;
				
				If ll_count < 1 Then
					MessageBox('Error','No es posible cambiar el estado de la base, ya que no tiene asociadas rayas')
					This.SetItem(This.GetRow(),'co_estado',1)
					Return 
				End if
				
				
				//verifico en dt_pdnxbase
				select count(*)
				into :ll_count
				from dt_rayas_telaxbase
				where cs_agrupacion = :ll_agrupa and
						cs_base_trazos = :ll_base;
						
				If ll_count < 1 Then
					MessageBox('Error','No es posible cambiar el estado de la base, ya que no tiene asociadas producciones')
					This.SetItem(This.GetRow(),'co_estado',1)
					Return 
				End if		
						
				//verifico en dt-escalaxpdnbase
				select count(*)
				into :ll_count
				from dt_escalaxpdnbase
				where cs_agrupacion = :ll_agrupa and
						cs_base_trazos = :ll_base;
						
				If ll_count < 1 Then
					MessageBox('Error','No es posible cambiar el estado de la base, ya que no tiene asociadas escalas')
					This.SetItem(This.GetRow(),'co_estado',1)
					Return 
				End if		
			
	
			
				//----------------------------------
				//2.  verificaci$$HEX1$$f300$$ENDHEX$$n en consistencia de datos en raya tela de acuerdo a la ficha
				//----------------------------------
				
				
				 select count(*)
					into :ll_count
					from h_base_trazos,   
						  dt_rayas_telaxbase,   
						  dt_color_modelo,   
						  dt_agrupa_pdn,   
						  dt_agrupaescalapdn  
				where ( dt_rayas_telaxbase.cs_agrupacion = h_base_trazos.cs_agrupacion ) and  
						( dt_rayas_telaxbase.cs_base_trazos = h_base_trazos.cs_base_trazos ) and  
						( dt_rayas_telaxbase.co_modelo = dt_color_modelo.co_modelo ) and  
						( dt_rayas_telaxbase.co_reftel = dt_color_modelo.co_reftel ) and  
						( dt_rayas_telaxbase.co_caract = dt_color_modelo.co_caract ) and  
						( dt_rayas_telaxbase.diametro = dt_color_modelo.diametro ) and  
						( dt_rayas_telaxbase.co_color_te = dt_color_modelo.co_color_te ) and  
						( h_base_trazos.cs_agrupacion = dt_agrupa_pdn.cs_agrupacion ) and  
						( dt_agrupa_pdn.co_fabrica_pt = dt_color_modelo.co_fabrica ) and  
						( dt_agrupa_pdn.co_linea = dt_color_modelo.co_linea ) and  
						( dt_agrupa_pdn.co_referencia = dt_color_modelo.co_referencia ) and  
						( dt_agrupa_pdn.cs_agrupacion = dt_agrupaescalapdn.cs_agrupacion ) and  
						( dt_agrupa_pdn.cs_pdn = dt_agrupaescalapdn.cs_pdn ) and  
						( dt_agrupaescalapdn.co_talla = dt_color_modelo.co_talla ) and  
						( ( h_base_trazos.cs_agrupacion = :ll_agrupa ) AND  
						( h_base_trazos.cs_base_trazos = :ll_base ))   ;
				
				If ll_count < 1 Then
					MessageBox('Error','No es posible cambiar el estado de la base, por inconsistencias de datos con la ficha')
					This.SetItem(This.GetRow(),'co_estado',1)			
					Rollback;
					Return
				End if
			End if//ll_estado = 2		
		
END CHOOSE

end event

type dw_rayas_agrupacion from datawindow within w_mantenimiento_agrupaciones
integer x = 919
integer y = 1236
integer width = 1051
integer height = 396
integer taborder = 30
string title = "none"
string dataobject = "dtb_mantenimiento_dt_agrupa_pdn_raya"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;gb_3.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_2.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_rayas_agrupacion
end event

type dw_escalas_agrupacion from datawindow within w_mantenimiento_agrupaciones
integer x = 18
integer y = 1236
integer width = 800
integer height = 420
integer taborder = 20
string title = "none"
string dataobject = "dtb_mantenimiento_dt_agrupaescalapdn"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;gb_2.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_1.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_escalas_agrupacion
end event

type dw_produccion_agrupacion from datawindow within w_mantenimiento_agrupaciones
integer x = 18
integer y = 484
integer width = 1943
integer height = 600
integer taborder = 10
string title = "none"
string dataobject = "dtb_mantenimiento_dt_agrupa_pdn"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rowfocuschanged;Long ll_agrupa,ll_pdn,ll_fila

This.AcceptText()


ll_fila = This.GetRow()

ll_agrupa = This.GetItemNumber(ll_fila,'cs_agrupacion')
ll_pdn = This.GetItemNumber(ll_fila,'cs_pdn')

dw_escalas_agrupacion.Retrieve(ll_agrupa,ll_pdn)
dw_rayas_agrupacion.Retrieve(ll_agrupa,ll_pdn)

end event

event getfocus;gb_1.textcolor = Rgb(0,0,255)
gb_4.textcolor = Rgb(0,0,0)
gb_2.textcolor = Rgb(0,0,0)
gb_3.textcolor = Rgb(0,0,0)
gb_5.textcolor = Rgb(0,0,0)
gb_6.textcolor = Rgb(0,0,0)
gb_7.textcolor = Rgb(0,0,0)
gb_8.textcolor = Rgb(0,0,0)

idw_activa = dw_produccion_agrupacion
end event

event clicked;Long ll_fila

dw_produccion_agrupacion.AcceptText()

For ll_fila = 1 To dw_produccion_agrupacion.RowCount()
	dw_produccion_agrupacion.SelectRow(ll_fila,FALSE)
Next


IF IsSelected (Row ) = FALSE THEN
	dw_produccion_agrupacion.SelectRow(Row,TRUE)
ELSE 
	dw_produccion_agrupacion.SelectRow(Row,FALSE)
END IF
end event

type gb_1 from groupbox within w_mantenimiento_agrupaciones
integer x = 5
integer y = 408
integer width = 2002
integer height = 696
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Producci$$HEX1$$f300$$ENDHEX$$n Agrupaci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_2 from groupbox within w_mantenimiento_agrupaciones
integer x = 5
integer y = 1168
integer width = 832
integer height = 504
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Escalas Agrupaci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_3 from groupbox within w_mantenimiento_agrupaciones
integer x = 901
integer y = 1168
integer width = 1106
integer height = 504
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rayas Agrupaci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_4 from groupbox within w_mantenimiento_agrupaciones
integer x = 5
integer y = 44
integer width = 1403
integer height = 204
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agrupaci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_5 from groupbox within w_mantenimiento_agrupaciones
integer x = 2039
integer y = 44
integer width = 891
integer height = 324
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bases Trazos"
end type

type gb_6 from groupbox within w_mantenimiento_agrupaciones
integer x = 2034
integer y = 408
integer width = 1536
integer height = 476
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rayas Tela"
end type

type gb_7 from groupbox within w_mantenimiento_agrupaciones
integer x = 2039
integer y = 940
integer width = 439
integer height = 736
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Producci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_8 from groupbox within w_mantenimiento_agrupaciones
integer x = 2519
integer y = 940
integer width = 1056
integer height = 732
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Escalas Tela"
end type

