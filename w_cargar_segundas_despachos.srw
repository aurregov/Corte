HA$PBExportHeader$w_cargar_segundas_despachos.srw
forward
global type w_cargar_segundas_despachos from window
end type
type dw_lista from datawindow within w_cargar_segundas_despachos
end type
type sle_bongo from singlelineedit within w_cargar_segundas_despachos
end type
type cb_cancelar from commandbutton within w_cargar_segundas_despachos
end type
type cb_aceptar from commandbutton within w_cargar_segundas_despachos
end type
type gb_1 from groupbox within w_cargar_segundas_despachos
end type
type gb_2 from groupbox within w_cargar_segundas_despachos
end type
end forward

global type w_cargar_segundas_despachos from window
integer width = 3355
integer height = 1732
boolean titlebar = true
string title = "Cargar a despachos"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
sle_bongo sle_bongo
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
gb_2 gb_2
end type
global w_cargar_segundas_despachos w_cargar_segundas_despachos

on w_cargar_segundas_despachos.create
this.dw_lista=create dw_lista
this.sle_bongo=create sle_bongo
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.dw_lista,&
this.sle_bongo,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1,&
this.gb_2}
end on

on w_cargar_segundas_despachos.destroy
destroy(this.dw_lista)
destroy(this.sle_bongo)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;This.Center = True

dw_lista.SetTransObject(sqlca)


end event

type dw_lista from datawindow within w_cargar_segundas_despachos
integer x = 64
integer y = 272
integer width = 3195
integer height = 1240
integer taborder = 20
string title = "none"
string dataobject = "dtb_reporte_kamban_centros"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_bongo from singlelineedit within w_cargar_segundas_despachos
integer x = 64
integer y = 84
integer width = 613
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cargar_segundas_despachos
integer x = 1198
integer y = 80
integer width = 306
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_cargar_segundas_despachos
integer x = 818
integer y = 80
integer width = 306
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;Long ll_ordencorte,  ll_ref
Long li_subcentro, li_fab, li_lin
Datetime ldt_fecha
String ls_bongo

ldt_fecha = f_fecha_servidor()

ls_bongo = sle_bongo.Text

If isnull(ls_bongo) Then
	messageBox('Advertencia','debe ingresar el n$$HEX1$$fa00$$ENDHEX$$mero de Recipiente.')
	return
Else
	select distinct co_fabrica_ref, co_linea, co_referencia , cs_orden_corte
	into :li_fab, :li_lin, :ll_ref, :ll_ordencorte
	from h_canasta_corte h, dt_canasta_corte dt
	where dt.cs_canasta = h.cs_canasta and
			pallet_id = :ls_bongo ;
		
	//primero se debe validar que la orden de corte no se encuentre en preparacion o extendido
	SELECT co_subcentro_pdn
	  INTO :li_subcentro
	  FROM dt_kamban_corte
	 WHERE cs_orden_corte = :ll_ordencorte AND
	       co_fabrica = :li_fab AND
			 co_linea = :li_lin AND
			 co_referencia = :ll_ref AND
	 		 fe_inicial is not null AND
			 fe_final is null ; 
	
	If sqlca.sqlcode = 0 Then
	
		If li_subcentro = 3 Or li_subcentro = 5 Then
			MessageBox('Error','La Orden de Corte se Encuentra en un subcentro desde el cual no es posible cargarla a despachos.')
			Return
		Else
			If li_subcentro = 7 Then
				MessageBox('Advertencia','La orden de corte se encuentra en Despachos.')
			Else
				//se deben colocar la fecha de lectura para todas las bolsas del subcentro actual como leidas
				Update dt_lectura_bolsas
					Set fe_lectura = :ldt_fecha
				 Where cs_orden_corte = :ll_ordencorte AND
						 co_subcentro_pdn = :li_subcentro;
			End if
		End if
		
	Else
		messageBox('Error','Verifique el subcentro donde se encuentra el recipiente.')
		Return
	End if
	
End if

dw_lista.Retrieve(ll_ordencorte, li_fab, li_lin, ll_ref)
end event

type gb_1 from groupbox within w_cargar_segundas_despachos
integer x = 41
integer y = 20
integer width = 672
integer height = 200
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Recipiente "
end type

type gb_2 from groupbox within w_cargar_segundas_despachos
integer x = 41
integer y = 224
integer width = 3259
integer height = 1324
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

