HA$PBExportHeader$w_trazos.srw
forward
global type w_trazos from window
end type
type tab_1 from tab within w_trazos
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_base within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_base within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_trazos
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_agrupacion from u_dw_base within w_trazos
end type
type gb_1 from groupbox within w_trazos
end type
end forward

global type w_trazos from window
integer width = 1975
integer height = 1892
boolean titlebar = true
string title = "Trazos"
string menuname = "m_mantenimiento_asignacion_trazos"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
integer toolbarx = 1
integer toolbary = 1
event ue_trazos ( )
event ue_grabar ( )
tab_1 tab_1
dw_agrupacion dw_agrupacion
gb_1 gb_1
end type
global w_trazos w_trazos

forward prototypes
public function long of_deletetmp (long an_agrupa, long an_trazo)
end prototypes

event ue_trazos();n_cts_param luo_param,lou_prmpdn
n_cts_param_tela luo_pmtela
Long    ll_trazo,ll_fltz,ll_agrupa,ll_newagp,ll_raya
String  ls_sqlerr
Long li_i


ll_fltz = dw_agrupacion.GetRow()

If ll_fltz<= 0 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Debe seleccionar la agrupaci$$HEX1$$f300$$ENDHEX$$n a la cual le desea crear trazos.")
	Return
End If

ll_agrupa = dw_agrupacion.GetItemNumber(ll_fltz,'cs_agrupacion')
ll_trazo  = Rand(1000000)

// Borro las tablas temporales

// las tablas temporales se utilizaran para hacer todo el proceso en ellas y al final
// pasar la informaci$$HEX1$$f300$$ENDHEX$$n a las tablas definitivas. Esto se hace con el objectivo de disminiur
// los bloqueos en los proceso de trazos.
If Of_DeleteTmp(ll_agrupa,ll_trazo) = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	Messagebox("Advertencia!","No se pudo borrar las tablas temporales. Intente m$$HEX1$$e100$$ENDHEX$$s tarde.~n~n~nNota :" + ls_sqlerr)
	Return
End If

luo_param.il_vector[1] = ll_agrupa
luo_param.il_vector[2] = ll_trazo

OpenWithParm(w_seleccion_color_modulo,luo_param)

luo_pmtela = Message.PowerObjectParm

If IsValid(luo_pmtela) Then
	// Ingreso las telas
	For li_i  = 1 To UpperBound(luo_pmtela.il_modelo) 
				
		insert into t_dt_rayas_telaxba  
         ( cs_agrupacion,cs_base_trazos,co_modelo,co_fabrica_pt,co_reftel,   
           co_caract,diametro,co_color_te,raya )  
  		values ( :ll_agrupa,:ll_trazo,:luo_pmtela.il_modelo[li_i],:luo_pmtela.il_fabrica[li_i],
		   :luo_pmtela.il_reftel[li_i],:luo_pmtela.il_caract[li_i],:luo_pmtela.il_diametro[li_i],   
         :luo_pmtela.il_color[li_i],:luo_pmtela.il_raya[li_i] )  ;

		If Sqlca.SqlCode = -1 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			Messagebox("Advertencia!","No se pudo insertar el las rayas en el temporal.~n~n~nNota :" + ls_sqlerr)
			Return			
		End If
	Next	
		
	OpenWithParm(w_seleccion_trazos_produccion,luo_param)
	
	lou_prmpdn = Message.PowerObjectParm
	
	// Ingreso la producci$$HEX1$$f300$$ENDHEX$$n
	If IsValid(lou_prmpdn) Then
		For li_i  = 1 To UpperBound(lou_prmpdn.il_vector) 
				
			insert into t_dt_pdnxbase  
         	( cs_agrupacion,cs_base_trazos,cs_pdn)  
  			values ( :ll_agrupa,:ll_trazo,:lou_prmpdn.il_vector[li_i] )  ;
 	
			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","No se pudo insertar el las rayas en el temporal.~n~n~nNota :" + ls_sqlerr)
				Return			
			End If
		Next	
		
		OpenWithParm(w_seleccion_tallas_produccion,luo_param)
		
		luo_pmtela = Message.PowerObjectParm
		
		If IsValid(luo_pmtela) Then
			For li_i  = 1 To UpperBound(luo_pmtela.il_modelo) 
				
				insert into t_dt_escalaxpdnbas  
         		( cs_agrupacion,cs_base_trazos,cs_pdn,co_talla,   
               cs_talla,ca_unidades,co_estado )  
  				values ( :ll_agrupa,:ll_trazo,:luo_pmtela.il_modelo[li_i],
				   :luo_pmtela.il_fabrica[li_i],:li_i,:luo_pmtela.il_reftel[li_i],1 ) ;
		
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ;
					Messagebox("Advertencia!","No se pudo insertar el las rayas en el temporal.~n~n~nNota :" + ls_sqlerr)
					Return			
				End If
			Next	
			
			select max(cs_base_trazos) 
   		  into :ll_newagp
    		  from h_base_trazos  
   		 where cs_agrupacion = :ll_agrupa   ;

			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","No se pudo obtener el numero para el nuevo trazo.~n~n~nNota :" + ls_sqlerr)
				Return
			ElseIf IsNull(ll_newagp) Then
				ll_newagp = 0
			Else
				select raya
				  into :ll_raya
				  from h_base_trazos  
				 where cs_agrupacion = :ll_agrupa and
				       cs_base_trazos = :ll_newagp ;
						 
				If Sqlca.SqlCode = -1 Then
					ls_sqlerr = Sqlca.SqlErrText
					rollback ;
					Messagebox("Advertencia!","No se pudo obtener el numero para el nuevo trazo.~n~n~nNota :" + ls_sqlerr)
					Return
				ElseIf IsNull(ll_raya) Then
					ll_raya = 0
				End If
			End If
			
			ll_newagp ++
			ll_raya   += 10
						
			insert into h_base_trazos  
         	( cs_agrupacion,cs_base_trazos,raya,fe_creacion,fe_actualizacion,   
            usuario,instancia )  
  			values ( :ll_agrupa,:ll_newagp,:ll_raya,current,current, user,sitename)  ;

			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","Hubo un error al insertar en el maestro de trazos(D).~n~n~nNota :" + ls_sqlerr)
				Return
			End If
			
			insert into dt_rayas_telaxbase  
            ( cs_agrupacion,cs_base_trazos,co_modelo,co_fabrica_pt,co_reftel,   
            co_caract,diametro,co_color_te,raya,fe_creacion,fe_actualizacion,   
            usuario,instancia )  
         select cs_agrupacion,   
                :ll_newagp,   
                co_modelo,   
                co_fabrica_pt,   
                co_reftel,   
                co_caract,   
                diametro,   
                co_color_te,   
                raya,   
                current,   
                current,   
                user,   
                sitename  
           from t_dt_rayas_telaxba
			 where cs_agrupacion = :ll_agrupa and
			       cs_base_trazos = :ll_trazo ;

			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","Hubo un error al insertar las rayas de los trazos(D).~n~n~nNota :" + ls_sqlerr)
				Return
			End If
			
			insert into dt_pdnxbase  
         	( cs_agrupacion,cs_base_trazos,cs_pdn,fe_creacion,fe_actualizacion, 
				usuario,instancia )  
     		select cs_agrupacion,   
                :ll_newagp,   
                cs_pdn,   
                current,   
                current,   
            	 user,   
            	 sitename  
           from t_dt_pdnxbase 
			 where cs_agrupacion = :ll_agrupa and
			       cs_base_trazos = :ll_trazo ;

			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","Hubo un error al insertar la producci$$HEX1$$f300$$ENDHEX$$n de los trazos(D).~n~n~nNota :" + ls_sqlerr)
				Return
			End If
			
			insert into dt_escalaxpdnbase  
         ( cs_agrupacion,cs_base_trazos,cs_pdn,co_talla,cs_talla,ca_unidades,   
           co_estado,fe_creacion,fe_actualizacion,usuario,instancia )  
     	   select cs_agrupacion,   
                :ll_newagp,   
                cs_pdn,   
                co_talla,   
                cs_talla,   
                ca_unidades,   
                co_estado,   
                current,   
                current,   
                user,   
                sitename  
       	  from t_dt_escalaxpdnbas  
      	 where cs_agrupacion = :ll_agrupa and  
                cs_base_trazos = :ll_trazo ;

			If Sqlca.SqlCode = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				Messagebox("Advertencia!","Hubo un error al insertar las escalas de los trazos(D).~n~n~nNota :" + ls_sqlerr)
				Return
			End If
			
			commit ;
			
			tab_1.tabpage_2.dw_2.Retrieve(ll_agrupa)
			
		Else
			rollback ;
			MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Usted a cancelado el proceso.")			
		End If
	Else
		rollback ;
		MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Usted a cancelado el proceso.")
	End If
Else
	rollback ;
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Usted a cancelado el proceso.")
End If




end event

event ue_grabar();String ls_sqlerr


tab_1.tabpage_2.dw_2.AcceptText()

If tab_1.tabpage_2.dw_2.Update() = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","No se pudo grabar la raya.~n~n~nNota: " + ls_sqlerr )
	Return
Else
	commit ;
End IF
end event

public function long of_deletetmp (long an_agrupa, long an_trazo);

delete from t_dt_rayas_telaxba  
 where cs_agrupacion = :an_agrupa and
       cs_base_trazos = :an_trazo  ;
		 
If Sqlca.SqlCode = -1 Then Return -1

delete from t_dt_pdnxbase  
 where cs_agrupacion = :an_agrupa and  
       cs_base_trazos = :an_trazo  ;

If Sqlca.SqlCode = -1 Then Return -1

delete from t_dt_escalaxpdnbas  
      where cs_agrupacion = :an_agrupa and 
            cs_base_trazos = :an_trazo ;

If Sqlca.SqlCode = -1 Then Return -1

Return 0
end function

on w_trazos.create
if this.MenuName = "m_mantenimiento_asignacion_trazos" then this.MenuID = create m_mantenimiento_asignacion_trazos
this.tab_1=create tab_1
this.dw_agrupacion=create dw_agrupacion
this.gb_1=create gb_1
this.Control[]={this.tab_1,&
this.dw_agrupacion,&
this.gb_1}
end on

on w_trazos.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_agrupacion)
destroy(this.gb_1)
end on

event open;This.X = 1
This.Y = 1

dw_agrupacion.SetTransObject(Sqlca)
tab_1.tabpage_1.dw_1.SetTransObject(Sqlca)
tab_1.tabpage_2.dw_2.SetTransObject(Sqlca)

dw_agrupacion.Retrieve(0,0)

dw_agrupacion.SetFocus()

tab_1.tabpage_2.dw_2.SetTabOrder('raya',10)
end event

type tab_1 from tab within w_trazos
integer x = 23
integer y = 644
integer width = 1888
integer height = 1016
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 1851
integer height = 896
long backcolor = 67108864
string text = "Producci$$HEX1$$f300$$ENDHEX$$n"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_base within tabpage_1
integer x = 5
integer y = 12
integer width = 1838
integer height = 880
integer taborder = 40
string dataobject = "d_borrar_dt_agrupacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 1851
integer height = 896
long backcolor = 67108864
string text = "Trazos"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_base within tabpage_2
integer x = 9
integer y = 12
integer width = 1829
integer height = 876
integer taborder = 30
string dataobject = "d_lista_trazos_x_agrupacion"
end type

type dw_agrupacion from u_dw_base within w_trazos
integer x = 55
integer y = 56
integer width = 1815
integer height = 548
integer taborder = 20
string dataobject = "d_lista_h_agrupa_pdn"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;Long ll_agrupa


If currentrow <= 0 Then
	tab_1.tabpage_1.dw_1.Reset()
	tab_1.tabpage_2.dw_2.Reset()
Else
	ll_agrupa = This.GetItemNumber(currentrow,'cs_agrupacion')
	tab_1.tabpage_1.dw_1.Retrieve(ll_agrupa)
	tab_1.tabpage_2.dw_2.Retrieve(ll_agrupa)
End If

end event

event clicked;call super::clicked;

If Row <=0 Then Return 

This.SetRow(Row)
This.SelectRow(0,False)
This.SelectRow(Row,True)
end event

type gb_1 from groupbox within w_trazos
integer x = 23
integer width = 1888
integer height = 636
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Agrupaci$$HEX1$$f300$$ENDHEX$$n"
borderstyle borderstyle = stylelowered!
end type

