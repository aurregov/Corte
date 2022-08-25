HA$PBExportHeader$w_agrupaciones_2.srw
forward
global type w_agrupaciones_2 from window
end type
type cb_4 from commandbutton within w_agrupaciones_2
end type
type dw_produccion from u_dw_base within w_agrupaciones_2
end type
type cb_3 from commandbutton within w_agrupaciones_2
end type
type dw_parm from u_dw_base within w_agrupaciones_2
end type
type cb_2 from commandbutton within w_agrupaciones_2
end type
type dw_insert from u_dw_base within w_agrupaciones_2
end type
type cb_1 from commandbutton within w_agrupaciones_2
end type
type dw_agrupa from u_dw_base within w_agrupaciones_2
end type
type gb_1 from groupbox within w_agrupaciones_2
end type
type gb_2 from groupbox within w_agrupaciones_2
end type
type gb_3 from groupbox within w_agrupaciones_2
end type
end forward

global type w_agrupaciones_2 from window
integer width = 1824
integer height = 1936
boolean titlebar = true
string title = "Agrupaciones"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_4 cb_4
dw_produccion dw_produccion
cb_3 cb_3
dw_parm dw_parm
cb_2 cb_2
dw_insert dw_insert
cb_1 cb_1
dw_agrupa dw_agrupa
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_agrupaciones_2 w_agrupaciones_2

type variables
DataWindow idw_dato,idw_producto
String is_sql

end variables

forward prototypes
public function long of_crearagrupa ()
public function long of_detalletrazo (long an_agrupa)
end prototypes

public function long of_crearagrupa ();Long   ll_agrupa
String ls_sqlerr


select max(cs_agrupacion)  
  into :ll_agrupa  
  from h_agrupa_pdn  ;
  
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","No se pudo seleccionar el consecutivo de la agrupaco$$HEX1$$ed00$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
	Return -1
End If
	
If IsNull(ll_agrupa) Then ll_agrupa = 0

ll_agrupa ++

insert into h_agrupa_pdn  
   ( cs_agrupacion,co_estado,fe_creacion,fe_actualizacion,   
     usuario,instancia )  
values ( :ll_agrupa,1,current,current,user,sitename )  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","No se pudo seleccionar el consecutivo de la agrupaco$$HEX1$$ed00$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr)
	Return -1
End If

Return ll_agrupa
	

end function

public function long of_detalletrazo (long an_agrupa);Datastore lds_tallas,lds_rayas,lds_colmod,lds_pdntz,lds_tlltz
DataWindow ldw_datos
Long    ll_cspdn,ll_ref,ll_j,ll_cnt,ll_modulo,ll_raya,ll_fab,ll_pedido,ll_base,&
        ll_result,ll_modelo,ll_reftl,ll_carac,ll_diam,ll_color,ll_found,&
		  ll_bsins,ll_unid, ll_co_color
Long li_i,li_tipo,li_lib,li_fabpt,li_lin,li_csest,li_cspar,&
        li_talla,li_csorden,li_raya,li_ryax
String  ls_sqlerr,ls_po,ls_tono


lds_tallas = Create Datastore
lds_rayas  = Create Datastore
lds_colmod = Create Datastore
lds_pdntz  = Create Datastore
lds_tlltz  = Create Datastore

lds_tallas.DataObject = 'd_lista_tallas_produccion'
lds_rayas.DataObject  = 'd_lista_modelos_x_talla'
lds_colmod.DataObject = 'd_lista_color_modelo'
lds_pdntz.DataObject = 'd_lista_trazos_produccion'
lds_tlltz.DataObject = 'd_lista_trazo_tallas_x_produccion'

lds_tallas.SetTransObject(Sqlca)
lds_rayas.SetTransObject(Sqlca)
lds_colmod.SetTransObject(Sqlca)
lds_pdntz.SetTransObject(Sqlca)
lds_tlltz.SetTransObject(Sqlca)

select max(cs_pdn)  
  into :ll_cspdn  
  from dt_agrupa_pdn  
 where cs_agrupacion = :an_agrupa   ;
 
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo obtener el consecutivo de la agrupaci$$HEX1$$f300$$ENDHEX$$n # " + String(an_agrupa) + ".~n~n~nNota: " + ls_sqlerr )
	Return -1
ElseIf IsNull(ll_cspdn) Then
	ll_cspdn = 0
End If

For li_i = 1 To dw_insert.RowCount()
	ll_cspdn ++	
	dw_insert.SetItem(li_i,'cs_agrupacion',an_agrupa)
	dw_insert.SetItem(li_i,'cs_pdn',ll_cspdn)
Next

dw_insert.AcceptText()

If dw_insert.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo grabar la producci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

For li_i = 1 To dw_insert.RowCount()

	ll_fab    = dw_insert.GetItemNumber(li_i,'co_fabrica_exp')
	ll_pedido = dw_insert.GetItemNumber(li_i,'pedido')
	
	li_lib   = dw_insert.GetItemNumber(li_i,'cs_liberacion')
	ls_po    = dw_insert.GetItemString(li_i,'po')
	li_fabpt = dw_insert.GetItemNumber(li_i,'co_fabrica_pt')
	li_lin   = dw_insert.GetItemNumber(li_i,'co_linea')
	ll_ref   = dw_insert.GetItemNumber(li_i,'co_referencia')
	ll_co_color = dw_insert.GetItemNumber(li_i,'co_color_pt')
	li_csest = dw_insert.GetItemNumber(li_i,'cs_estilocolortono')
	li_cspar = dw_insert.GetItemNumber(li_i,'cs_particion')
	ls_tono  = dw_insert.GetItemString(li_i,'tono')
	
	ll_cspdn = dw_insert.GetItemNumber(li_i,'cs_pdn')
	
	// Tallas
	lds_tallas.Retrieve(ll_fab,ll_pedido,li_lib,ls_po,li_fabpt,li_lin,ll_ref,ll_co_color,ls_tono,li_csest,li_cspar)
	
	For ll_j = 1 To lds_tallas.RowCount()
		li_csorden = lds_tallas.GetItemNumber(ll_j,'cs_orden_talla')
		li_talla   = lds_tallas.GetItemNumber(ll_j,'co_talla')
		ll_cnt     = lds_tallas.GetItemNumber(ll_j,'ca_programada')
		
		insert into dt_agrupaescalapdn  
		  ( cs_agrupacion,cs_pdn,co_talla,cs_talla,co_estado,ca_unidades,   
		  fe_creacion,fe_actualizacion,usuario,instancia )  
		values ( :an_agrupa,:ll_cspdn,:li_talla,:li_csorden,1,   
		  :ll_cnt,current,current,user,sitename )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback;
			MessageBox("Advertencia!","No se pudo insertar las tallas.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
	Next

	// Rayas
	lds_rayas.Retrieve(an_agrupa,ll_cspdn)
	
	For ll_j = 1 To lds_rayas.RowCount()
					
		ll_modulo = lds_rayas.GetItemNumber(ll_j,'co_modelo')
		ll_raya   = lds_rayas.GetItemNumber(ll_j,'raya')
		ll_cnt    = lds_rayas.GetItemNumber(ll_j,'ca_unidades')
		
		insert into dt_agrupa_pdn_raya  
		  ( cs_agrupacion,cs_pdn,co_modelo,raya,ca_unidades,   
		  co_tipo,co_estado,fe_creacion,fe_actualizacion,   
		  usuario,instancia )  
		values ( :an_agrupa,:ll_cspdn,:ll_modulo,:ll_raya,:ll_cnt,   
		  1,1,current,current,user,sitename )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback;
			MessageBox("Advertencia!","No se pudo insertar las rayas.~n~n~nNota: " + ls_sqlerr )
			Return -1
		End If
	Next
Next


// base para trazos

select max(cs_base_trazos) 
  into :ll_base
  from h_base_trazos  
 where cs_agrupacion = :an_agrupa ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	Messagebox("Advertencia!","No se pudo obtener el numero para el nuevo trazo.~n~n~nNota :" + ls_sqlerr)
	Return -1
ElseIf IsNull(ll_base) Then
	ll_base = 0
End If

ll_result = lds_colmod.Retrieve(an_agrupa)

If ll_result <= 0 Then 
	rollback ;
	Messagebox("Advertencia!","Hubo un error al recuperar el color modelo para la base.")
	Return -1
End If

li_ryax = -1

For ll_j = 1 To ll_result
	ll_modelo = lds_colmod.GetItemNumber(ll_j,'co_modelo')
	ll_reftl  = lds_colmod.GetItemNumber(ll_j,'co_reftel')
	ll_carac  = lds_colmod.GetItemNumber(ll_j,'co_caract')
	ll_diam   = lds_colmod.GetItemNumber(ll_j,'diametro')
	ll_color  = lds_colmod.GetItemNumber(ll_j,'co_color_te')
	ll_raya   = lds_colmod.GetItemNumber(ll_j,'raya')
	
	If li_ryax <> ll_raya Then
		
		select cs_base_trazos
		  into :ll_found
		  from h_base_trazos
		 where cs_agrupacion = :an_agrupa and
				 raya = :ll_raya ;
		  
		If Sqlca.SqlCode = -1 Then  
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).~n~n~nNota :" + ls_sqlerr)
			Return -1
		ElseIf Sqlca.SqlCode = 100 Then
			ll_base ++
			ll_bsins = ll_base
			
			insert into h_base_trazos  
				( cs_agrupacion,cs_base_trazos,raya,fe_creacion,fe_actualizacion,   
				usuario,instancia )  
			values ( :an_agrupa,:ll_bsins,:ll_raya,current,current,user,sitename) ;
		
			If Sqlca.SqlCode = -1 Then  
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).~n~n~nNota :" + ls_sqlerr)
				Return -1
			End If
		Else
			ll_bsins = ll_found
		End If
	End If
		
	li_ryax = ll_raya
		
	select cs_agrupacion
	  into :ll_found
	  from dt_rayas_telaxbase
	 where cs_agrupacion = :an_agrupa and
			 cs_base_trazos = :ll_bsins and
			 co_modelo = :ll_modelo and
			 co_fabrica_te = 91 and
			 co_reftel = :ll_reftl and
			 co_caract = :ll_carac and
			 diametro = :ll_diam and
			 co_color_te = :ll_color ;
			
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo problemas al buscar las rayas de la base.~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		
		insert into dt_rayas_telaxbase  
				( cs_agrupacion,cs_base_trazos,co_modelo,co_fabrica_te,co_reftel,   
				co_caract,diametro,co_color_te,raya,fe_creacion,fe_actualizacion,   
				usuario,instancia )  
		values ( :an_agrupa,:ll_bsins,:ll_modelo,91,:ll_reftl,:ll_carac,:ll_diam,
					:ll_color,:ll_raya,current,current,user,sitename) ;
					
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","No se pudo insertar el las rayas de los trazos.~n~n~nNota :" + ls_sqlerr)
			Return -1			
		End If		
	End If	
Next

ll_result = lds_pdntz.Retrieve(an_agrupa)

If ll_result <= 0 Then 
	rollback ;
	Messagebox("Advertencia!","Hubo un error la producci$$HEX1$$f300$$ENDHEX$$n por trazos.")
	Return -1
End If

For ll_j = 1 To ll_result
	
	ll_cspdn = lds_pdntz.GetItemNumber(ll_j,'cs_pdn')
	ll_base  = lds_pdntz.GetItemNumber(ll_j,'cs_base_trazos')
	
	select cs_agrupacion
	  into :ll_found 
	  from dt_pdnxbase
	 where cs_agrupacion = :an_agrupa and
	       cs_base_trazos = :ll_base and
			 cs_pdn = :ll_cspdn ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		insert into dt_pdnxbase  
			( cs_agrupacion,cs_base_trazos,cs_pdn,fe_creacion,fe_actualizacion, 
			usuario,instancia )  
		values ( :an_agrupa,:ll_base,:ll_cspdn,current,current,user,sitename) ;
				
		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
			Return -1
		End If
	End If
Next

ll_result = lds_tlltz.Retrieve(an_agrupa)

If ll_result <= 0 Then 
	rollback ;
	Messagebox("Advertencia!","Hubo un error al recuperar las tallas de los trazos.")
	Return -1
End If

For ll_j = 1 To ll_result
	
	ll_cspdn = lds_tlltz.GetItemNumber(ll_j,'cs_pdn')
	ll_base  = lds_tlltz.GetItemNumber(ll_j,'cs_base_trazos')
	li_talla = lds_tlltz.GetItemNumber(ll_j,'co_talla')
	ll_unid  = lds_tlltz.GetItemNumber(ll_j,'ca_unidades')
	
	select cs_agrupacion
	  into :ll_found 
	  from dt_escalaxpdnbase
	 where cs_agrupacion = :an_agrupa and
	       cs_base_trazos = :ll_base and
			 cs_pdn = :ll_cspdn and
			 co_talla = :li_talla ;
	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
		Return -1
	ElseIf Sqlca.SqlCode = 100 Then
		insert into dt_escalaxpdnbase  
         ( cs_agrupacion,cs_base_trazos,cs_pdn,co_talla,cs_talla,ca_unidades,   
           co_estado,fe_creacion,fe_actualizacion,usuario,instancia )  
  		values ( :an_agrupa,:ll_base,:ll_cspdn,:li_talla,:ll_j,   
           :ll_unid,1,current,current,user,sitename )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","Hubo un error al insertar la talla de los trazos(D).~n~n~nNota :" + ls_sqlerr)
			Return -1
		End If
	End If
Next

If idw_producto.Update() = -1 Then
	rollback ;
	Messagebox("Advertencia!","No se pudo grabar el estado de la producci$$HEX1$$f300$$ENDHEX$$n")
	Return -1
End If

commit ;

dw_insert.Reset()

Destroy lds_tallas
Destroy lds_rayas
Destroy lds_colmod
Destroy lds_pdntz
Destroy lds_tlltz

//This.Enabled = False
//d_lista_trazos_produccion

return an_agrupa
end function

on w_agrupaciones_2.create
this.cb_4=create cb_4
this.dw_produccion=create dw_produccion
this.cb_3=create cb_3
this.dw_parm=create dw_parm
this.cb_2=create cb_2
this.dw_insert=create dw_insert
this.cb_1=create cb_1
this.dw_agrupa=create dw_agrupa
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.cb_4,&
this.dw_produccion,&
this.cb_3,&
this.dw_parm,&
this.cb_2,&
this.dw_insert,&
this.cb_1,&
this.dw_agrupa,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_agrupaciones_2.destroy
destroy(this.cb_4)
destroy(this.dw_produccion)
destroy(this.cb_3)
destroy(this.dw_parm)
destroy(this.cb_2)
destroy(this.dw_insert)
destroy(this.cb_1)
destroy(this.dw_agrupa)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;
Long   ll_fila,ll_pedaux,ll_filins,ll_agrupa,ll_fab,ll_pedido,ll_ref,ll_found, ll_co_color
int    li_fabexp,li_lib,li_fabpt,li_lin,li_csest,li_cspar
String ls_tono,ls_po,ls_sqlerr,ls_mesng,ls_deref,ls_decolor,ls_delinea



Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

idw_producto = Message.PowerObjectParm

dw_insert.SetTransObject(Sqlca)
dw_agrupa.SetTransObject(Sqlca)
dw_produccion.SetTransObject(Sqlca)

is_sql = dw_agrupa.GetSqlSelect()

ll_fila = 0

Do
	ll_fila = idw_producto.GetSelectedRow(ll_fila)
	
	If ll_fila > 0 Then 
		
		ll_fab    = idw_producto.GetItemNumber(ll_fila,'co_fabrica_exp')
		ll_pedido = idw_producto.GetItemNumber(ll_fila,'pedido')
		
		li_lib   = idw_producto.GetItemNumber(ll_fila,'cs_liberacion')
		ls_po    = idw_producto.GetItemString(ll_fila,'po')
		li_fabpt = idw_producto.GetItemNumber(ll_fila,'co_fabrica_pt')
		li_lin   = idw_producto.GetItemNumber(ll_fila,'co_linea')
		ll_ref   = idw_producto.GetItemNumber(ll_fila,'co_referencia')
		ll_co_color = idw_producto.GetItemNumber(ll_fila,'co_color_pt')
		li_csest = idw_producto.GetItemNumber(ll_fila,'cs_estilocolortono')
		li_cspar = idw_producto.GetItemNumber(ll_fila,'cs_particion')
		ls_tono  = idw_producto.GetItemString(ll_fila,'tono')
		
		ls_deref   = idw_producto.GetItemString(ll_fila,'de_referencia')
		ls_decolor = idw_producto.GetItemString(ll_fila,'de_color')
		ls_delinea = idw_producto.GetItemString(ll_fila,'de_linea')
		
		select count(*)
        into :ll_found  
        from dt_agrupa_pdn  
       where co_fabrica_exp = :ll_fab and
             pedido = :ll_pedido and  
             cs_liberacion = :li_lib and 
             po = :ls_po and 
             co_fabrica_pt = :li_fabpt and
             co_linea = :li_lin and
             co_referencia = :ll_ref and
             co_color_pt = :ll_co_color and
             tono = :ls_tono and  
             cs_estilocolortono = :li_csest and
             cs_particion = :li_cspar ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","No se pudo consultar la producci$$HEX1$$f300$$ENDHEX$$n en las agrupaciones.")
			Close(This)
			Return
		End If
		
		If ll_found = 0 Then
			idw_producto.SetItem(ll_fila,'co_estado_asigna',2)
			
			ll_filins = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(ll_filins,'co_fabrica_exp',ll_fab)
			dw_insert.SetItem(ll_filins,'pedido',ll_pedido)
			dw_insert.SetItem(ll_filins,'cs_liberacion',li_lib)
			dw_insert.SetItem(ll_filins,'po',ls_po)
			dw_insert.SetItem(ll_filins,'co_fabrica_pt',li_fabpt)
			dw_insert.SetItem(ll_filins,'co_linea',li_lin)
			dw_insert.SetItem(ll_filins,'co_referencia',ll_ref)
			dw_insert.SetItem(ll_filins,'co_color_pt',ll_co_color)
			dw_insert.SetItem(ll_filins,'cs_estilocolortono',li_csest)
			dw_insert.SetItem(ll_filins,'cs_particion',li_cspar)
			dw_insert.SetItem(ll_filins,'tono',ls_tono)
			dw_insert.SetItem(ll_filins,'ca_unidades',idw_producto.GetItemNumber(ll_fila,'ca_programada'))
			dw_insert.SetItem(ll_filins,'de_linea',idw_producto.GetItemString(ll_fila,'de_linea'))
			dw_insert.SetItem(ll_filins,'de_referencia',idw_producto.GetItemString(ll_fila,'de_referencia'))
			dw_insert.SetItem(ll_filins,'usuario',gstr_info_usuario.codigo_usuario)
			dw_insert.SetItem(ll_filins,'instancia',gstr_info_usuario.instancia)
		Else
			ls_mesng = "La producci$$HEX1$$f300$$ENDHEX$$n:~n~n" +&
			           "F$$HEX1$$e100$$ENDHEX$$brica: " + String(ll_fab) + "~n" +&
						  "Pedido: " + String(ll_pedido) + "~n" +&
						  "PO: "  + ls_po + "~n" +&
						  "F$$HEX1$$e100$$ENDHEX$$b Pd: "  + String(li_fabpt) + "~n" +&
						  "L$$HEX1$$ed00$$ENDHEX$$nea: " + String(li_lin) + " " + ls_delinea + "~n" +&
						  "Ref: " + String(ll_ref) + " " + ls_deref + "~n" +&
						  "Color: " + String(ll_co_color)+ " " + ls_decolor + "~n" +&
						  "Tono: " + ls_tono + "~n" +&
						  "Estilo: " + String(li_csest) + "~n" +&
						  "Part: " + String(li_cspar) + "~n~n" +&
						  "ya esta incluida en una agrupaci$$HEX1$$f300$$ENDHEX$$n. $$HEX1$$bf00$$ENDHEX$$Desea continuar sin esta producci$$HEX1$$f300$$ENDHEX$$n?"
			
			If MessageBox("Advertencia!",ls_mesng,Question!,YesNo!) = 2 Then
				Close(This)
				Return
			End If
		End If
	End If
	
loop Until ll_fila = 0

If dw_insert.RowCount() > 0 Then
	
	If MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","$$HEX1$$bf00$$ENDHEX$$Desea crear una nueva agrupaci$$HEX1$$f300$$ENDHEX$$n?",Question!,YesNo!) = 1 Then
		ll_agrupa = of_CrearAgrupa()
		
		If ll_agrupa > 0 Then 
			If Of_detalleTrazo(ll_agrupa) > 0 Then MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
		End If
		
		Close(This)
		Return
	End If
Else
	Close(This)
	Return
End If
	
dw_parm.InsertRow(0)
end event

type cb_4 from commandbutton within w_agrupaciones_2
integer x = 754
integer y = 1708
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Borrar"
end type

event clicked;Long   ll_agrupa,ll_fila,ll_pedido,ll_ref,ll_color
String ls_sqlerr,ls_po,ls_tono
Long    li_fabexp,li_cslib,li_fabpt,li_linea,li_csest,li_cspar,li_i

If MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n","$$HEX1$$bf00$$ENDHEX$$Esta seguro(a) que desea borrar la agrupacci$$HEX1$$f300$$ENDHEX$$n?",Question!,YesNo!,2) = 2 Then Return

ll_fila = dw_agrupa.GetRow()

If ll_fila <= 0 Then
	MessageBox("Advertencia!","Debe seleccionar una agrupaci$$HEX1$$f300$$ENDHEX$$n")
	Return
End If

ll_agrupa = dw_agrupa.GetItemNumber(ll_fila,'cs_agrupacion')


For li_i = 1 To dw_produccion.RowCount()
	
	li_fabexp = dw_produccion.GetItemNumber(li_i,'co_fabrica_exp')
	ll_pedido = dw_produccion.GetItemNumber(li_i,'pedido')
	li_cslib  = dw_produccion.GetItemNumber(li_i,'cs_liberacion')
	ls_po     = dw_produccion.GetItemString(li_i,'po')
	li_fabpt  = dw_produccion.GetItemNumber(li_i,'co_fabrica_pt')
	li_linea  = dw_produccion.GetItemNumber(li_i,'co_linea')
	ll_ref    = dw_produccion.GetItemNumber(li_i,'co_referencia')
	ll_color  = dw_produccion.GetItemNumber(li_i,'co_color_pt')
	ls_tono   = dw_produccion.GetItemString(li_i,'tono')
	li_csest  = dw_produccion.GetItemNumber(li_i,'cs_estilocolortono')
	li_cspar  = dw_produccion.GetItemNumber(li_i,'cs_particion')
	
	update dt_pdnxmodulo  
      set co_estado_asigna = 1  
    where dt_pdnxmodulo.simulacion = 1 and 
          dt_pdnxmodulo.co_fabrica = 91 and 
          dt_pdnxmodulo.co_planta = 1 and  
          dt_pdnxmodulo.co_modulo = 800 and
          dt_pdnxmodulo.co_fabrica_exp = :li_fabexp and  
          dt_pdnxmodulo.pedido = :ll_pedido and 
          dt_pdnxmodulo.cs_liberacion = :li_cslib and 
          dt_pdnxmodulo.po = :ls_po and
          dt_pdnxmodulo.co_fabrica_pt = :li_fabpt and
          dt_pdnxmodulo.co_linea = :li_linea and
          dt_pdnxmodulo.co_referencia = :ll_ref and
          dt_pdnxmodulo.co_color_pt = :ll_color and 
          dt_pdnxmodulo.tono = :ls_tono and 
          dt_pdnxmodulo.cs_estilocolortono = :li_csest and  
          dt_pdnxmodulo.cs_particion = :li_cspar  ;

	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback;
		MessageBox("Advertencia!","No se pudo borrar los trazos para esta agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
		Return -1
	End If	
Next

delete 
  from dt_trazosxbase  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar los trazos para esta agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from dt_escalaxpdnbase  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las escalas de los trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from dt_pdnxbase  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las producciones de los trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from dt_rayas_telaxbase  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las rayas de los trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from h_base_trazos  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar el trazos.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from dt_agrupa_pdn_raya  
 where cs_agrupacion = :ll_agrupa  ;
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las rayas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
 from dt_agrupaescalapdn  
where cs_agrupacion = :ll_agrupa ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las tallas de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from dt_agrupa_pdn  
 where cs_agrupacion = :ll_agrupa ;
 
If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo borrar las producciones de la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

delete 
  from h_agrupa_pdn  
 where cs_agrupacion = :ll_agrupa  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback;
	MessageBox("Advertencia!","No se pudo la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~n~nNota: " + ls_sqlerr )
	Return -1
End If

commit;

MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue borrada con exito.")

dw_agrupa.Reset()
dw_produccion.Reset()
end event

type dw_produccion from u_dw_base within w_agrupaciones_2
integer x = 50
integer y = 1136
integer width = 1691
integer height = 512
integer taborder = 70
string dataobject = "d_borrar_dt_agrupacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_3 from commandbutton within w_agrupaciones_2
integer x = 1335
integer y = 168
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
end type

event clicked;String ls_sintax,ls_dato
Long    li_pos,li_con


dw_parm.AcceptText()

li_con = 0

li_pos = Pos(is_sql,"ORDER")
ls_sintax = Mid(is_sql,1,li_pos -1)

ls_dato = Trim(dw_parm.GetItemString(1,'po'))
If ls_dato <> '' And Not IsNull(ls_dato) Then 
	li_con ++
	ls_sintax += " AND ( dt_agrupa_pdn.po like '%" + ls_dato + "%') "
End If

ls_dato = Trim(dw_parm.GetItemString(1,'gpa'))
If ls_dato <> '' And Not IsNull(ls_dato) Then 
	li_con ++
	ls_sintax += " AND ( peddig.gpa like '%" + ls_dato + "%') "
End If

ls_dato = Trim(dw_parm.GetItemString(1,'de_referencia'))
If ls_dato <> '' And Not IsNull(ls_dato) Then 
	li_con ++
	ls_sintax += " AND ( h_preref_pv.de_referencia like '%" + ls_dato + "%') "
End If

If li_con = 0 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe ingresar un criterio de busqueda.")
	Return
End If

ls_sintax += Mid(is_sql,li_pos,len(is_sql))

dw_agrupa.SetSqlSelect(ls_sintax)

dw_agrupa.Retrieve()

dw_parm.Reset()
dw_parm.InsertRow(0)
end event

type dw_parm from u_dw_base within w_agrupaciones_2
integer x = 55
integer y = 72
integer width = 1184
integer height = 300
integer taborder = 20
string dataobject = "d_parametro_busqueda_agrupacion"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_2 from commandbutton within w_agrupaciones_2
integer x = 389
integer y = 1708
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Grabar"
end type

event clicked;Long ll_agrupa,ll_fila


ll_fila = dw_agrupa.GetRow()

If ll_fila <= 0 Then
	MessageBox("Advertencia!","Debe seleccionar una agrupaci$$HEX1$$f300$$ENDHEX$$n")
	Return
End If

ll_agrupa = dw_agrupa.GetItemNumber(ll_fila,'cs_agrupacion')

If Of_detalleTrazo(ll_agrupa) > 0 Then 
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","La agrupaci$$HEX1$$f300$$ENDHEX$$n " + String(ll_agrupa) + " fue creada con exito." )
Else
	Return
End If	

Close(Parent)
end event

type dw_insert from u_dw_base within w_agrupaciones_2
boolean visible = false
integer x = 1367
integer y = 872
integer width = 306
integer height = 152
integer taborder = 50
string dataobject = "d_insercion_dt_agrupacion"
end type

type cb_1 from commandbutton within w_agrupaciones_2
integer x = 1120
integer y = 1708
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

type dw_agrupa from u_dw_base within w_agrupaciones_2
integer x = 50
integer y = 456
integer width = 1691
integer height = 588
integer taborder = 20
string dataobject = "d_lista_agrupacio_con_peddig"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;Long ll_agrupa

If Row <= 0 Then Return

This.SelectRow(0,False)
This.SelectRow(Row,True)

This.SetRow(Row)

ll_agrupa = This.GetItemNumber(Row,'cs_agrupacion')

dw_produccion.Retrieve(ll_agrupa)

end event

type gb_1 from groupbox within w_agrupaciones_2
integer x = 18
integer y = 400
integer width = 1765
integer height = 676
integer taborder = 10
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

type gb_2 from groupbox within w_agrupaciones_2
integer x = 18
integer y = 16
integer width = 1765
integer height = 380
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar"
end type

type gb_3 from groupbox within w_agrupaciones_2
integer x = 18
integer y = 1080
integer width = 1765
integer height = 604
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Producci$$HEX1$$f300$$ENDHEX$$n"
end type

