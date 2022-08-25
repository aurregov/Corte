HA$PBExportHeader$w_crear_orden_corte.srw
forward
global type w_crear_orden_corte from window
end type
type st_2 from statictext within w_crear_orden_corte
end type
type tab_1 from tab within w_crear_orden_corte
end type
type tabpage_1 from userobject within tab_1
end type
type dw_trazo from u_dw_base within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_trazo dw_trazo
end type
type tabpage_2 from userobject within tab_1
end type
type dw_pdn from u_dw_base within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_pdn dw_pdn
end type
type tab_1 from tab within w_crear_orden_corte
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_base from u_dw_base within w_crear_orden_corte
end type
type cb_2 from commandbutton within w_crear_orden_corte
end type
type cb_1 from commandbutton within w_crear_orden_corte
end type
type em_1 from editmask within w_crear_orden_corte
end type
type st_1 from statictext within w_crear_orden_corte
end type
end forward

global type w_crear_orden_corte from window
integer width = 2903
integer height = 1160
boolean titlebar = true
string title = "Crear Orden"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
st_2 st_2
tab_1 tab_1
dw_base dw_base
cb_2 cb_2
cb_1 cb_1
em_1 em_1
st_1 st_1
end type
global w_crear_orden_corte w_crear_orden_corte

type variables
Long il_agrupa
end variables

forward prototypes
public function long of_consorden ()
public function long of_anomes (ref datetime adt_anomes)
end prototypes

public function long of_consorden ();String ls_sqlerr
Long   ll_consec,ll_increm


select incremento,   
       nu_enque_esta  
  into :ll_increm,   
       :ll_consec  
  from cf_consc_ordenes  
 where tipo_orden = 3 and  
       co_fabrica = 2   ;

If Sqlca.SqlCode <> 0 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","Hubo un error al buscar el consecutivo de la orden.")
	Return -1
End If
	
	
update cf_consc_ordenes
   set nu_enque_esta = nu_enque_esta + :ll_increm
 where tipo_orden = 3 and
		 co_fabrica = 2   ;

If Sqlca.SqlCode <> 0 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","Hubo un error al buscar el consecutivo de la orden.")
	Return -1
Else
	Return ll_consec
End If
end function

public function long of_anomes (ref datetime adt_anomes);String ls_sqlerr


select cf_produc.ano_mes
  into :adt_anomes
  from cf_produc
 where co_fabrica = 91 ;
 
If Sqlca.SqlCode <> 0 Then 
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertenica!","Hubo un error al buscar la fecha de producci$$HEX1$$f300$$ENDHEX$$n~n~n~nNota: " + ls_sqlerr,StopSign!)
	Return -1
End If

Return 0
 

end function

on w_crear_orden_corte.create
this.st_2=create st_2
this.tab_1=create tab_1
this.dw_base=create dw_base
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_1=create em_1
this.st_1=create st_1
this.Control[]={this.st_2,&
this.tab_1,&
this.dw_base,&
this.cb_2,&
this.cb_1,&
this.em_1,&
this.st_1}
end on

on w_crear_orden_corte.destroy
destroy(this.st_2)
destroy(this.tab_1)
destroy(this.dw_base)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_1)
destroy(this.st_1)
end on

event open;
Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If

dw_base.SetTransObject(Sqlca)
tab_1.tabpage_1.dw_trazo.SetTransObject(Sqlca)
tab_1.tabpage_2.dw_pdn.SetTransObject(Sqlca)

end event

type st_2 from statictext within w_crear_orden_corte
integer x = 1787
integer y = 40
integer width = 1061
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione los trazos con le tecla ctrl presionada"
boolean focusrectangle = false
end type

type tab_1 from tab within w_crear_orden_corte
event create ( )
event destroy ( )
integer x = 960
integer y = 132
integer width = 1888
integer height = 756
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
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

Long ll_agrupa,ll_base,ll_trazo,ll_fila


If newindex = 2 Then
	
	ll_fila = tab_1.tabpage_1.dw_trazo.GetRow()
	
	If ll_fila > 0 Then
		ll_agrupa = tab_1.tabpage_1.dw_trazo.GetItemNumber(ll_fila,'cs_agrupacion')
		ll_base   = tab_1.tabpage_1.dw_trazo.GetItemNumber(ll_fila,'cs_base_trazos')
		ll_trazo  = tab_1.tabpage_1.dw_trazo.GetItemNumber(ll_fila,'cs_trazo')
		tab_1.tabpage_2.dw_pdn.Retrieve(ll_agrupa,ll_base,ll_trazo)
	Else
		tab_1.tabpage_2.dw_pdn.Reset()
	End If
End If
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 1851
integer height = 636
long backcolor = 67108864
string text = "Trazo"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_trazo dw_trazo
end type

on tabpage_1.create
this.dw_trazo=create dw_trazo
this.Control[]={this.dw_trazo}
end on

on tabpage_1.destroy
destroy(this.dw_trazo)
end on

type dw_trazo from u_dw_base within tabpage_1
integer y = 8
integer width = 1847
integer height = 628
integer taborder = 20
string dataobject = "d_lista_trazos_x_base_agrupacion"
end type

event clicked;call super::clicked;

If Row <= 0 Then Return

This.SetRow(Row)

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 1851
integer height = 636
long backcolor = 67108864
string text = "Producci$$HEX1$$f300$$ENDHEX$$n por Trazo"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_pdn dw_pdn
end type

on tabpage_2.create
this.dw_pdn=create dw_pdn
this.Control[]={this.dw_pdn}
end on

on tabpage_2.destroy
destroy(this.dw_pdn)
end on

type dw_pdn from u_dw_base within tabpage_2
integer y = 8
integer width = 1847
integer height = 624
integer taborder = 20
string dataobject = "d_trazosbase_orden_corte"
end type

type dw_base from u_dw_base within w_crear_orden_corte
integer x = 23
integer y = 132
integer width = 928
integer height = 756
integer taborder = 20
string dataobject = "d_lista_trazos_x_agrupacion"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;Long ll_agrupa,ll_base,ll_rslt


tab_1.tabpage_2.dw_pdn.Reset()

If currentrow <= 0 Then
	tab_1.tabpage_1.dw_trazo.Reset()
Else
	ll_agrupa = This.GetItemNumber(currentrow,'cs_agrupacion')
	ll_base   = This.GetItemNumber(currentrow,'cs_base_trazos')

	If tab_1.tabpage_1.dw_trazo.Retrieve(ll_agrupa,ll_base) > 0 Then
		tab_1.tabpage_1.dw_trazo.SetRow(1)
	End If
End If
end event

event clicked;call super::clicked;
If Row <= 0 Then Return

This.SetRow(Row)
This.SelectRow(0,False)
This.SelectRow(Row,True)

end event

type cb_2 from commandbutton within w_crear_orden_corte
integer x = 1477
integer y = 908
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cerrar"
end type

event clicked;
Close(Parent)
end event

type cb_1 from commandbutton within w_crear_orden_corte
integer x = 1083
integer y = 908
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Crear &Orden"
end type

event clicked;DataStore lds_cnttalla,lds_rayas,lds_pdntz,lds_sctzpdn
String    ls_sqlerr
Long      ll_orden,ll_agrupa,ll_base,ll_tprog,ll_prog,ll_trazo,ll_rsult1,ll_pdn,&
          ll_progtll,ll_rsult2,ll_rsult3,ll_modelo,ll_reftel,ll_carac,ll_diamet,ll_color,&
			 ll_rsult4,ll_cntst,ll_seccion,ll_capa
Long       li_numsel,li_fila,li_raya,li_flbs,li_i,li_talla,li_mraya,li_j,li_swaut,ll_tmp,&
          li_k,li_l
DateTime  ldt_anomes
Decimal   ldc_prop,ldc_ancho
Long      ll_vtrazo[]

			
SetPointer(HourGlass!)
			
If tab_1.tabpage_1.dw_trazo.RowCount() = 0 Then Return

li_numsel = 0
li_fila   = 0
ll_tprog  = 0 

Do
	li_fila = tab_1.tabpage_1.dw_trazo.GetSelectedRow(li_fila)
	
	If li_fila > 0 Then 
		li_numsel ++ 
							
		ll_agrupa = tab_1.tabpage_1.dw_trazo.GetItemNumber(li_fila,'cs_agrupacion')
		ll_base   = tab_1.tabpage_1.dw_trazo.GetItemNumber(li_fila,'cs_base_trazos')
		ll_prog   = tab_1.tabpage_1.dw_trazo.GetItemNumber(li_fila,'cantidad')
		
		ll_vtrazo[li_numsel] = tab_1.tabpage_1.dw_trazo.GetItemNumber(li_fila,'cs_trazo')
		
		If li_numsel = 1 Then 
			li_flbs = dw_base.GetRow()
			
			li_raya = dw_base.GetItemNumber(li_flbs,'raya')
		End If
		
		If li_raya = 10 Then
			ll_tprog += ll_prog
		End If
	End If
		
Loop Until li_fila = 0

If li_numsel = 0 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar los trazos a los cuales les desea craer la orden.")
	Return
End If


ll_orden = Of_ConsOrden()

If ll_orden = -1 Then Return
If of_anomes(ldt_anomes) = -1 Then Return 

insert into h_ordenes_corte  
       ( cs_orden_corte,co_estado,co_tipo,fe_prog_orden,fe_liquidacion,   
         ca_unidades_prog,ca_unidades_cortad,co_ruta,ano_mes,fe_creacion,   
         fe_actualizacion,usuario,instancia )  
values ( :ll_orden,1,1,current,null,:ll_tprog,0,1,:ldt_anomes,   
         current,current,user,sitename )  ;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","Hubo un error al insertar la orden.~n~n~nNota: " + ls_sqlerr,StopSign!)
	Return
End If


//escalas
lds_cnttalla = Create DataStore
lds_rayas    = Create DataStore
lds_pdntz    = Create DataStore
lds_sctzpdn  = Create DataStore
 
lds_cnttalla.DataObject = 'd_lista_produccion_trazos_pdn_talla'
lds_rayas.DataObject    = 'd_lista_rayas_telasoc'
lds_pdntz.DataObject    = 'd_pdn_acumulada_trazos'
lds_sctzpdn.DataObject  = 'd_seciones_x_trazos_pdn'

lds_cnttalla.SetTransObject(Sqlca)
lds_rayas.SetTransObject(Sqlca)
lds_pdntz.SetTransObject(Sqlca)
lds_sctzpdn.SetTransObject(Sqlca)

ll_rsult1 = lds_pdntz.Retrieve(ll_agrupa,ll_base,ll_vtrazo)

If ll_rsult1 <= 0 Then
	rollback ;
	MessageBox("Advertencia!","No se pudo recuperar la producci$$HEX1$$f300$$ENDHEX$$n para los trazos seleccionados.",StopSign!)
	Return
End If

For li_k = 1 To ll_rsult1
	ll_pdn  = lds_pdntz.GetItemNumber(li_k,'cs_pdn')
	ll_prog = lds_pdntz.GetItemNumber(li_k,'cantidad')
	
	ll_rsult2 = lds_cnttalla.Retrieve(ll_agrupa,ll_base,ll_vtrazo,ll_pdn)
	
	If ll_rsult2 <= 0 Then
		rollback ;
		MessageBox("Advertencia!","Hubo un error al recuperar las tallas de la producci$$HEX1$$f300$$ENDHEX$$n.",StopSign!)
		Return
	End If
	
	ll_rsult4 = lds_sctzpdn.Retrieve(ll_agrupa,ll_base,ll_pdn)
	
	If ll_rsult4 <= 0 Then
		rollback ;
		MessageBox("Advertencia!","Hubo un error recuperar las secciones por trazo.",StopSign!)
		Return
	End If
	
	For li_i = 1 To ll_rsult2
		li_talla   = lds_cnttalla.GetItemNumber(li_i,'co_talla')
		ll_progtll = lds_cnttalla.GetItemNumber(li_i,'cantidad')
		
		ldc_prop = (ll_progtll / ll_prog ) * 100
		
		insert into dt_escalasxoc  
			( cs_orden_corte,cs_agrupacion,cs_pdn,co_talla,cs_orden,   
			  ca_programada,ca_proporcion,fe_creacion,fe_actualizacion,   
			  usuario,instancia )  
		values ( :ll_orden,:ll_agrupa,:ll_pdn,:li_talla,:li_i,:ll_progtll,   
			:ldc_prop,current,current,user,sitename )  ;


		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia!","Hubo un error al insertar las escalas.~n~n~nNota: " + ls_sqlerr,StopSign!)
			Return
		End If
		
		
		// Rayas
		ll_rsult3 = lds_rayas.Retrieve(ll_agrupa,ll_pdn,li_talla,ll_base)
				
		If ll_rsult3 <= 0 Then
			rollback ;
			MessageBox("Advertencia!","Hubo un error al recuperar los modelos de la producci$$HEX1$$f300$$ENDHEX$$n.",StopSign!)
			Return
		End If
			
		For li_j = 1 To ll_rsult3
			ll_modelo = lds_rayas.GetItemNumber(li_j,'co_modelo')
			ll_reftel = lds_rayas.GetItemNumber(li_j,'co_reftel')
			ll_carac  = lds_rayas.GetItemNumber(li_j,'co_caract')
			ll_diamet = lds_rayas.GetItemNumber(li_j,'diametro')
			ll_color  = lds_rayas.GetItemNumber(li_j,'co_color_te')
			li_mraya  = lds_rayas.GetItemNumber(li_j,'raya')
			ldc_ancho = lds_rayas.GetItemDecimal(li_j,'ancho')
			
			li_swaut = 2 
			If li_mraya = 10 Then li_swaut = 1 
			
			select cs_orden_corte  
			  into :ll_tmp  
			  from dt_rayas_telaxoc  
			 where cs_orden_corte = :ll_orden and 
					 cs_agrupacion = :ll_agrupa and
					 cs_pdn = :ll_pdn and
					 co_modelo = :ll_modelo and
					 co_fabrica_tela = 91 and
					 co_reftel = :ll_reftel and
					 co_caract = :ll_carac and
					 diametro = :ll_diamet and
					 co_color_te = :ll_color  ;

			
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				MessageBox("Advertencia!","Hubo un error al buscar las rayas.~n~n~nNota: " + ls_sqlerr,StopSign!)
				Return
			ElseIf Sqlca.SqlCode = 100 Then
				
				insert into dt_rayas_telaxoc  
					 ( cs_orden_corte,cs_agrupacion,cs_pdn,co_modelo,co_fabrica_tela,co_reftel,   
						co_caract,diametro,co_color_te,raya,ancho,co_estado,co_tipo,sw_automatico,   
						consxunid_std,consumoxescala,fe_creacion,fe_actualizacion,usuario,instancia )  
				values ( :ll_orden,:ll_agrupa,:ll_pdn,:ll_modelo,91,:ll_reftel,   
						:ll_carac,:ll_diamet,:ll_color,:li_mraya,:ldc_ancho,1,1,:li_swaut,0,0,   
						current,current,user,sitename )  ;

				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ;
					MessageBox("Advertencia!","Hubo un error al insertar las rayas.~n~n~nNota: " + ls_sqlerr,StopSign!)
					Return
				Else
					For li_l = 1 To ll_rsult4
						ll_trazo   = lds_sctzpdn.GetItemNumber(li_l,'cs_trazo')
						ll_seccion = lds_sctzpdn.GetItemNumber(li_l,'cs_seccion')
						ll_capa    = lds_sctzpdn.GetItemNumber(li_l,'capas')
						ll_cntst   = lds_sctzpdn.GetItemNumber(li_l,'cantidad')
						
						insert into dt_trazosxoc  
							( cs_orden_corte,cs_agrupacion,cs_pdn,co_modelo,co_fabrica_tela,   
							  co_reftel,co_caract,diametro,co_color_te,co_trazo,cs_seccion,   
							  capas,ca_programada,ca_stdxunidad,ca_consumo_std,co_estado,   
							  tipo,fe_creacion,fe_actualizacion,usuario, instancia )  
					   values ( :ll_orden, :ll_agrupa,:ll_pdn,:ll_modelo,91,:ll_reftel,   
							  :ll_carac,:ll_diamet,:ll_color,:ll_trazo,:ll_seccion,:ll_capa,   
							  :ll_cntst,0,0,1,1,current,current,user,sitename )  ;
			
						If Sqlca.SqlCode = -1 Then
							ls_sqlerr = Sqlca.SqlErrText
							rollback ;
							MessageBox("Advertencia!","Hubo un error al insertar los trazos.~n~n~nNota: " + ls_sqlerr,StopSign!)
							Return
						End If
						
					Next
				End If
			End If
		Next
	Next
Next

commit ;

Destroy lds_cnttalla
Destroy lds_rayas
Destroy lds_pdntz
Destroy lds_sctzpdn

MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Se creo la orden n$$HEX1$$fa00$$ENDHEX$$mero " + String(ll_orden))
end event

type em_1 from editmask within w_crear_orden_corte
integer x = 768
integer y = 24
integer width = 448
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

event modified;


il_agrupa = Long(This.Text)

tab_1.tabpage_1.dw_trazo.Reset()
tab_1.tabpage_2.dw_pdn.Reset()
dw_base.Reset()

If Not IsNull(il_agrupa) Then
	dw_base.Retrieve(il_agrupa)
End If
end event

type st_1 from statictext within w_crear_orden_corte
integer x = 23
integer y = 40
integer width = 731
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Digite el n$$HEX1$$fa00$$ENDHEX$$mero de la agrupaci$$HEX1$$f300$$ENDHEX$$n"
boolean focusrectangle = false
end type

