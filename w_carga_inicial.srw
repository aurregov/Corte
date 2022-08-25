HA$PBExportHeader$w_carga_inicial.srw
forward
global type w_carga_inicial from window
end type
type hpb_1 from hprogressbar within w_carga_inicial
end type
type cb_2 from commandbutton within w_carga_inicial
end type
type cb_1 from commandbutton within w_carga_inicial
end type
type dw_1 from datawindow within w_carga_inicial
end type
type gb_1 from groupbox within w_carga_inicial
end type
end forward

global type w_carga_inicial from window
integer width = 1659
integer height = 556
boolean titlebar = true
string title = "Carga Inicial"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
hpb_1 hpb_1
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_carga_inicial w_carga_inicial

forward prototypes
public function long of_xcol ()
public function long of_corte (long an_simulacion, long an_fabrica, long an_planta)
end prototypes

public function long of_xcol ();DataStore lds_fechas 
Long      ll_i,ll_ref,ll_pedpo,ll_result,ll_libera,ll_cantidad
Long   ll_fabexp,ll_fab,ll_lin,ll_col,ll_ordpdpt,ll_h_orden_corte,ll_ordcr_modelo
String    ls_po,ls_sqlerr,ls_tono
Date      ld_entrega,ld_problema
Decimal ldc_unicort

// Datastore que me ayuda a recuperar las fechas(xcol) de pedpend
lds_fechas = Create DataStore
lds_fechas.DataObject = 'd_fechas_xcol'
lds_fechas.SetTransObject(Sqlca)

// Esta fecha se pone cuando no encontramos registros en pedpend
ld_problema = Date("2005-01-01")

For ll_i = 1 To dw_1.RowCount()
	
	ll_fabexp 	= dw_1.GetItemNumber(ll_i,"co_fabrica_exp")
	ls_po 		= dw_1.GetItemString(ll_i,"po")
	ll_fab 		= dw_1.GetItemNumber(ll_i,"co_fabrica_pt")
	ll_lin 		= dw_1.GetItemNumber(ll_i,"co_linea")
	ll_ref 		= dw_1.GetItemNumber(ll_i,"co_referencia")
	ll_col 		= dw_1.GetItemNumber(ll_i,"co_color_pt")
	ll_pedpo 	= dw_1.GetItemNumber(ll_i,"pedido_po")
	ll_libera   = dw_1.GetItemNumber(ll_i,'cs_liberacion')
	ls_tono     = dw_1.GetItemString(ll_i,'tono')
	ll_cantidad	= dw_1.GetItemNumber(ll_i,'ca_programada')
	
	//validar si esta liquidada
	//con esquema actual
	//ver cuantas unidades estan liquidadas para la orden de produccion produccion
			//traer la orden de produccion
			
			//buscar en la orden de corte la suma de unidades liquidadas
			
			//compara con las unidades que tiene programadas, si ya todas estan cortadas, delete y continua ciclo
	
		Select sum(dt_liquida_unidad.ca_unidades_cortad)
		  Into :ll_ordpdpt
		  From dt_libera_estilos,h_orden_corte,dt_ordcr_modelos,dt_liquida_unidad
		 Where dt_libera_estilos.co_fabrica_exp = :ll_fabexp And
				 dt_libera_estilos.pedido = :ll_pedpo And
				 dt_libera_estilos.nu_orden = :ls_po And
				 dt_libera_estilos.co_fabrica = :ll_fab And
				 dt_libera_estilos.co_linea = :ll_lin And
				 dt_libera_estilos.co_referencia = :ll_ref And
				 dt_libera_estilos.co_color_pt = :ll_col And
				 dt_libera_estilos.cs_liberacion = :ll_libera And
				 dt_libera_estilos.tono = :ls_tono And 
				 h_orden_corte.cs_orden_corte = dt_ordcr_modelos.cs_orden_corte And
				 dt_ordcr_modelos.cs_orden_corte = dt_liquida_unidad.cs_orden_corte And
				 dt_ordcr_modelos.co_modelo = dt_liquida_unidad.co_modelo And
				 dt_ordcr_modelos.sw_automatico = 1 And
				 dt_libera_estilos.cs_ordenpd_pt = h_orden_corte.cs_ordenpd_pt;
				 
		//se determina si se elimina la fila o si se continua con el proceso
			If ll_ordpdpt >= ll_cantidad Then
				dw_1.DeleteRow(ll_i)
			Else
				ll_result = lds_fechas.Retrieve(ll_fabexp,ll_pedpo,ls_po,ll_fab,ll_lin,ll_ref,ll_col)
	
				If ll_result = -1 Then
					MessageBox("Advertencia","Error al consultar la fecha de despacho ." + Sqlca.SqlErrText)
					Return -1
				End If
				
				If ll_result = 0 Then
					ld_entrega = ld_problema
				Else
					ld_entrega = lds_fechas.GetItemDate(1,"fe_entrega")
				End If
					
				dw_1.SetItem(ll_i,"fe_xcol",ld_entrega)
				
			End if
	
Next

dw_1.SetSort("fe_xcol A, gpa A, po A, co_color_pt A, tono A, cs_estilocolortono A")
Return dw_1.Sort()

end function

public function long of_corte (long an_simulacion, long an_fabrica, long an_planta);u_ds_base lds_tallas
Long      ll_i,ll_j,ll_pedido,ll_ref,ll_pedpo,ll_result
Long   li_fabexp,li_fab,li_lin,li_col,li_cslib,li_csest,li_cspar,li_csasi,li_cotp,li_modulo
String    ls_po,ls_tono,ls_sqlerr,ls_csst
Decimal   ldc_programda,ldc_proy,ldc_actual,ldc_munerada
Datetime ldt_felim_prog
Date ld_fecha
Time lt_time

lds_tallas = Create u_ds_base
lds_tallas.DataObject = 'd_carga_dt_talla_pdnxmodulo'
lds_tallas.SetTransObject(Sqlca)


For ll_i = 1 To dw_1.RowCount()
	
	hpb_1.Position = Round((ll_i / dw_1.RowCount()) * 100,0)
	
	li_modulo     = dw_1.GetItemNumber(ll_i,"co_modulo")
	li_fabexp     = dw_1.GetItemNumber(ll_i,"co_fabrica_exp")
	ll_pedido     = dw_1.GetItemNumber(ll_i,"pedido")
	li_cslib      = dw_1.GetItemNumber(ll_i,"cs_liberacion")
	ls_po         = dw_1.GetItemString(ll_i,"po")
	li_fab        = dw_1.GetItemNumber(ll_i,"co_fabrica_pt")
	li_lin        = dw_1.GetItemNumber(ll_i,"co_linea")
	ll_ref        = dw_1.GetItemNumber(ll_i,"co_referencia")
	li_col        = dw_1.GetItemNumber(ll_i,"co_color_pt")
	ls_tono       = dw_1.GetItemString(ll_i,"tono")
	li_csest      = dw_1.GetItemNumber(ll_i,"cs_estilocolortono")
	li_cspar      = dw_1.GetItemNumber(ll_i,"cs_particion")
	ll_pedpo      = dw_1.GetItemNumber(ll_i,"pedido_po")
	li_csasi      = dw_1.GetItemNumber(ll_i,"cs_asignacion")
	ldc_programda = dw_1.GetItemNumber(ll_i,"ca_programada")
	ldc_proy      = dw_1.GetItemNumber(ll_i,"ca_proyectada")
	ldc_actual    = dw_1.GetItemNumber(ll_i,"ca_actual")
	ldc_munerada  = dw_1.GetItemNumber(ll_i,"ca_numerada")
	li_cotp       = dw_1.GetItemNumber(ll_i,"co_tipo_asignacion")
	ls_csst       = dw_1.GetItemString(ll_i,"co_estado_merc")
	
	//busco la minima fecha con planta = 2 y le resto diez dias, esta sera la fecha requerida de fin de corte
	//modificaci$$HEX1$$f300$$ENDHEX$$n realizada por juan carlos restrepo medina noviembre 28 de 2002
	
	select min(fe_inicio_prog)
	into :ldt_felim_prog
	from dt_pdnxmodulo
	where simulacion = 1 and
			co_fabrica = 91 and
			co_planta = 2 and
			co_fabrica_exp = :li_fabexp and
			pedido = :ll_pedido and
			cs_liberacion = :li_cslib and
			po = :ls_po and
			co_fabrica_pt = :li_fab and
			co_linea = :li_lin and
			co_referencia = :ll_ref and
			co_color_pt = :li_col and
			tono = :ls_tono and
			cs_estilocolortono = :li_csest and
			cs_particion = :li_cspar and
			fe_inicio_prog <> '1900-01-01 00:00:00.000';
			
	If Sqlca.SqlCode = -1 Then
		MessageBox('Error','Ocurrio un error de base datos al intentar recuperar la fecha de inicio de confecci$$HEX1$$f300$$ENDHEX$$n')
		Return -1
	End if
	
	If Sqlca.SqlCode = 100 Then
		MessageBox('Error','No existe ningun registro de confecci$$HEX1$$f300$$ENDHEX$$n para el pedido '+String(ll_pedido)+' ,referencia '+String(ll_ref))
		Return -1
	End if
	
	ld_fecha = Date(ldt_felim_prog)
	lt_time = Time(ldt_felim_prog)
	
	ld_fecha = RelativeDate(ld_fecha,-10)
	
	ldt_felim_prog = DateTime(ld_fecha,lt_time)
	
	//fin modificaci$$HEX1$$f300$$ENDHEX$$n
	
	insert into dt_pdnxmodulo  
         ( simulacion,			co_fabrica,				co_planta,				co_modulo,				co_fabrica_exp,   
           pedido,				cs_liberacion,			po,						co_fabrica_pt,			co_linea,		
			  co_referencia,		co_color_pt,			tono,						cs_estilocolortono,	cs_particion,		
			  pedido_po,      	cs_prioridad,			ca_programada,			ca_producida,			ca_pendiente,		
			  co_estado_asigna,  co_curva,				fe_inicio_prog,		fe_fin_prog,			fe_requerida_desp,
			  ca_minutos_std,    co_tipo_asignacion,	ca_personasxmod,		cod_tur,					minutos_jornada,
			  ind_cambio_estilo, ca_unid_base_dia,		orige_uni_base_dia,	tipo_empate,			unidades_empate,   
           metodo_programa,	fuente_dato,			fe_creacion,			fe_actualizacion,    usuario,
			  instancia,			fe_entra_pdn,			tipo_fe_prog,			fe_lim_prog,         fe_desp_programada,
			  indicativo_base,	ca_base_dia_prod,		ca_base_dia_prog,    ca_a_programar,		co_estado_merc,
			  ca_proyectada,		ca_actual,				ca_numerada,         fe_fogueo,				fe_trabajo,
			  cs_asignacion )  
   values ( 1,						91,						1,							701,						:li_fabexp,
				:ll_pedido,			:li_cslib,				:ls_po,              :li_fab,					:li_lin,
				:ll_ref,				:li_col,					:ls_tono,				:li_csest,				:li_cspar,
				:ll_pedpo,        :ll_i,					:ldc_programda,		0,							:ldc_programda,
				1,						0,							null,						null,						null,	
				0,						:li_cotp,            0,							0,							0,
				0,						0,							0,							2,							0,
				0,						0,							current,					current,					user,	
				sitename,			null,						0,							:ldt_felim_prog,     null,
				0,						0,							0,							0,							:ls_csst,
				:ldc_proy,			:ldc_actual,			:ldc_munerada,			null,            		null,
				:li_csasi )  ;

	
	If Sqlca.SqlCode = -1 Then
		ls_sqlerr = Sqlca.SqlErrText
		rollback ;
		MessageBox("Advertencia!","Hubo problemas al insertar los dato. " + ls_sqlerr)
		Return -1
	Else
		ll_result = lds_tallas.Retrieve(an_simulacion,an_fabrica,an_planta,li_modulo,li_fabexp,ll_pedido,li_cslib,&
		            ls_po,li_fab,li_lin,ll_ref,li_col,ls_tono,li_csest,li_cspar )
						
		If ll_result < 0 Then
			ls_sqlerr = Sqlca.SqlErrText
			rollback ;
			MessageBox("Advertencia","Hubo problemas al consultar las tallas. " + ls_sqlerr)
			Return -1
		Else
			For ll_j = 1 To ll_result
				
				lds_tallas.SetItemStatus(ll_j,0,Primary!,New!)
				
				lds_tallas.SetItem(ll_j,"simulacion",1)
				lds_tallas.SetItem(ll_j,"co_fabrica",91)
				lds_tallas.SetItem(ll_j,"co_planta",1)
				lds_tallas.SetItem(ll_j,"co_modulo",701)
				
				lds_tallas.SetItem(ll_j,"ca_producida",0)
				lds_tallas.SetItem(ll_j,"ca_pendiente",lds_tallas.GetItemDecimal(ll_j,"ca_programada"))
				lds_tallas.SetItem(ll_j,"co_est_prog_talla",1)
				lds_tallas.SetItem(ll_j,"fuente_dato",0)
				
			Next
			
			If lds_tallas.Update() = -1 Then
				ls_sqlerr = Sqlca.SqlErrText
				rollback ;
				MessageBox("Advertencia","Hubo problemas al grabar las tallas. " + ls_sqlerr)
				Return -1
			End If
		End If
	End If
	
Next

commit ;

Return 0
end function

on w_carga_inicial.create
this.hpb_1=create hpb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.hpb_1,&
this.cb_2,&
this.cb_1,&
this.dw_1,&
this.gb_1}
end on

on w_carga_inicial.destroy
destroy(this.hpb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;
Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If


dw_1.SetTransObject(Sqlca)

end event

type hpb_1 from hprogressbar within w_carga_inicial
integer x = 101
integer y = 128
integer width = 1413
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 2
end type

type cb_2 from commandbutton within w_carga_inicial
integer x = 818
integer y = 288
integer width = 343
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_1 from commandbutton within w_carga_inicial
integer x = 448
integer y = 288
integer width = 343
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "X-Col"
end type

event clicked;n_cts_param lou_param
Long ll_result


Open(w_parametros_carga_inicial)

lou_param = Message.PowerObjectParm

If IsValid(lou_param) Then
	ll_result = dw_1.Retrieve(lou_param.il_vector[1],lou_param.il_vector[2],lou_param.il_vector[3])
	
	If ll_result > 0 Then
		//validar si ya est$$HEX2$$e1002000$$ENDHEX$$liquidada
		If Parent.Of_XCol() = -1 Then Return  
		//trae 
		If Parent.Of_Corte(lou_param.il_vector[1],lou_param.il_vector[2],lou_param.il_vector[3]) = -1 Then Return		
		
	End If
	
End If

hpb_1.Position = 0 


end event

type dw_1 from datawindow within w_carga_inicial
boolean visible = false
integer x = 32
integer y = 400
integer width = 3104
integer height = 1232
integer taborder = 10
string title = "none"
string dataobject = "d_carga_dt_pdnxmodulo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_carga_inicial
integer x = 41
integer y = 28
integer width = 1531
integer height = 236
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

