HA$PBExportHeader$w_orden_guias_numeracion.srw
forward
global type w_orden_guias_numeracion from window
end type
type cb_recuperar from commandbutton within w_orden_guias_numeracion
end type
type st_1 from statictext within w_orden_guias_numeracion
end type
type sle_raya from singlelineedit within w_orden_guias_numeracion
end type
type cb_cancelar from commandbutton within w_orden_guias_numeracion
end type
type cb_aceptar from commandbutton within w_orden_guias_numeracion
end type
type dw_sort from datawindow within w_orden_guias_numeracion
end type
type gb_1 from groupbox within w_orden_guias_numeracion
end type
end forward

global type w_orden_guias_numeracion from window
integer width = 658
integer height = 1308
boolean titlebar = true
string title = "Ordenamiento"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_recuperar cb_recuperar
st_1 st_1
sle_raya sle_raya
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_sort dw_sort
gb_1 gb_1
end type
global w_orden_guias_numeracion w_orden_guias_numeracion

type variables
Long il_raya,il_orden
end variables

on w_orden_guias_numeracion.create
this.cb_recuperar=create cb_recuperar
this.st_1=create st_1
this.sle_raya=create sle_raya
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_sort=create dw_sort
this.gb_1=create gb_1
this.Control[]={this.cb_recuperar,&
this.st_1,&
this.sle_raya,&
this.cb_cancelar,&
this.cb_aceptar,&
this.dw_sort,&
this.gb_1}
end on

on w_orden_guias_numeracion.destroy
destroy(this.cb_recuperar)
destroy(this.st_1)
destroy(this.sle_raya)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_sort)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

lstr_parametros=message.powerObjectparm


il_orden = lstr_parametros.entero[1]

dw_sort.SetTransObject(sqlca)

dw_sort.Visible = False
cb_aceptar.Visible = False


end event

type cb_recuperar from commandbutton within w_orden_guias_numeracion
integer x = 146
integer y = 148
integer width = 343
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
boolean default = true
end type

event clicked;il_raya = Long(sle_raya.Text) 

If dw_sort.Retrieve(il_orden,il_raya) > 0 Then
	dw_sort.Visible = True
	cb_aceptar.visible = True
Else
	MessageBox('Error','No existen registros para dicha raya, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n')
End if


end event

type st_1 from statictext within w_orden_guias_numeracion
integer x = 46
integer y = 48
integer width = 224
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Raya:"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_raya from singlelineedit within w_orden_guias_numeracion
integer x = 293
integer y = 48
integer width = 315
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_orden_guias_numeracion
integer x = 370
integer y = 1064
integer width = 247
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_orden_guias_numeracion
integer x = 32
integer y = 1064
integer width = 247
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

event clicked;Long ll_filas,ll_orden,ll_espacio,ll_datos,i,ll_cs_trazo,ll_cs_seccion,ll_cs_ext,ll_trazos

datastore ds_sec_ext

dw_sort.AcceptText()

If dw_sort.RowCount() > 0 Then

	For ll_filas = 1 To dw_sort.RowCount()
		ll_espacio = dw_sort.GetItemNumber(ll_filas,'cs_trazo')
		ll_orden = dw_sort.GetItemNumber(ll_filas,'cs_orden_espacio')
		
		SELECT DISTINCT dt_trazosxoc.cs_base_trazos 
		 INTO :ll_trazos
		 FROM dt_trazosxoc,   
				h_base_trazos  
		WHERE ( dt_trazosxoc.cs_agrupacion = h_base_trazos.cs_agrupacion ) and  
				( dt_trazosxoc.cs_base_trazos = h_base_trazos.cs_base_trazos ) and  
				( ( dt_trazosxoc.cs_orden_corte = :il_orden ) AND  
				( h_base_trazos.raya = :il_raya ) )   ;

		
		UPDATE dt_trazosxoc 
	     SET cs_orden_espacio = :ll_orden
		WHERE cs_orden_corte = :il_orden and   
	         cs_base_trazos = :ll_trazos and
				cs_trazo = :ll_espacio;
		
		If sqlca.sqlcode = -1 Then
			MessageBox('Error','No fue posible actualizar el ordenamiento de trazos')
			Rollback;
			Return
		End if
		IF IsNull(ll_orden) OR ll_orden = 0 THEN
			ll_orden = ll_trazos
		END IF
		UPDATE dt_liq_unixespacio 
	     SET cs_orden_espacio = :ll_orden
		WHERE cs_orden_corte = :il_orden and   
	         cs_base_trazos = :ll_trazos and
				cs_trazo = :ll_espacio;
				
		If sqlca.sqlcode = -1 Then
			MessageBox('Error','No fue posible actualizar el ordenamiento de trazos')
			Rollback;
			Return
		End if		
				
	Next
End if

//crear cs_sec_ext

ds_sec_ext=create datastore

ds_sec_ext.dataobject="d_lista_sec_ext"

ds_sec_ext.settransobject(sqlca)

ll_datos=ds_sec_ext.Retrieve(il_orden,ll_trazos)


ll_cs_ext=1
for i=1 to ll_datos
	ll_cs_trazo=ds_sec_ext.getitemnumber(i,"cs_trazo")
	ll_cs_seccion=ds_sec_ext.getitemnumber(i,"cs_seccion")
	
	UPDATE dt_trazosxoc  
	SET cs_sec_ext = :i  
	WHERE ( dt_trazosxoc.cs_orden_corte = :il_orden ) AND  
		( dt_trazosxoc.cs_base_trazos = :ll_trazos ) AND  
		( dt_trazosxoc.cs_trazo = :ll_cs_trazo ) AND  
		( dt_trazosxoc.cs_seccion = :ll_cs_seccion ) 		  ;
		
	if sqlca.sqlcode=-1 then
		messagebox("error base datos","no pudo actualizar secci$$HEX1$$f300$$ENDHEX$$n extendido")
		rollback;
		return
	else
		commit;
	end if

	
next

Close(Parent)


end event

type dw_sort from datawindow within w_orden_guias_numeracion
integer x = 46
integer y = 276
integer width = 558
integer height = 712
integer taborder = 10
string title = "none"
string dataobject = "dff_orden_guias_numeracion"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_orden_guias_numeracion
integer x = 32
integer y = 232
integer width = 585
integer height = 780
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

