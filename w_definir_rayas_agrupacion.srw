HA$PBExportHeader$w_definir_rayas_agrupacion.srw
forward
global type w_definir_rayas_agrupacion from window
end type
type dw_asociacion from datawindow within w_definir_rayas_agrupacion
end type
type dw_telas_referencias from datawindow within w_definir_rayas_agrupacion
end type
type dw_rayas_base from datawindow within w_definir_rayas_agrupacion
end type
type gb_1 from groupbox within w_definir_rayas_agrupacion
end type
type gb_2 from groupbox within w_definir_rayas_agrupacion
end type
type gb_3 from groupbox within w_definir_rayas_agrupacion
end type
end forward

global type w_definir_rayas_agrupacion from window
integer width = 3726
integer height = 1628
boolean titlebar = true
string title = "Definir Rayas Agrupaci$$HEX1$$f300$$ENDHEX$$n"
string menuname = "m_mantenimiento_simple"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_insertar_maestro ( )
event ue_grabar ( )
event ue_borrar_maestro ( )
event ue_buscar ( )
dw_asociacion dw_asociacion
dw_telas_referencias dw_telas_referencias
dw_rayas_base dw_rayas_base
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_definir_rayas_agrupacion w_definir_rayas_agrupacion

type variables
Long il_agrupacion
end variables

forward prototypes
public function long of_actualizar_pdn (long al_basetrazo, long ai_fabrica, long ai_linea, long al_referencia, long ai_operacion)
public function long of_agrupacion (long al_ordencorte, ref long ai_estado)
end prototypes

event ue_insertar_maestro();Long li_fila

li_fila = dw_rayas_base.InsertRow(0)
IF li_fila = -1 THEN
	MessageBox("Error DataWindow","Se present$$HEX2$$f3002000$$ENDHEX$$un error al insertar registro en la datawindow")
	Return
ELSE
	dw_rayas_base.SetItem(li_fila, 'cs_agrupacion', il_agrupacion)
	dw_rayas_base.SetItem(li_fila, 'cs_base_trazos', dw_rayas_base.RowCount())
	dw_rayas_base.SetItem(li_fila, 'fe_creacion', f_fecha_servidor())
	dw_rayas_base.SetItem(li_fila, 'fe_actualizacion', f_fecha_servidor())
	dw_rayas_base.SetItem(li_fila, 'usuario', gstr_info_usuario.codigo_usuario)
	dw_rayas_base.SetItem(li_fila, 'instancia', gstr_info_usuario.instancia)
END IF
end event

event ue_grabar();IF dw_rayas_base.AcceptText() <> -1 THEN
	IF dw_rayas_base.Update() = -1 THEN
		ROLLBACK;		
		MessageBox("Error DataWindow","Error al grabar la informaci$$HEX1$$f300$$ENDHEX$$n de las bases en la base de datos")
		Return
	ELSE
		COMMIT;
	END IF
ELSE
	MessageBox("Error DataWindow","Error al grabar la informaci$$HEX1$$f300$$ENDHEX$$n de las bases")
	Return	
END IF
end event

event ue_borrar_maestro();Long li_fila

IF dw_rayas_base.RowCount() > 0 THEN
	li_fila = dw_rayas_base.GetRow()
	dw_rayas_base.DeleteRow(li_fila)
	This.TriggerEvent("ue_grabar")
END IF
end event

event ue_buscar();Long ll_ordencorte
Long li_estado_agrupa
n_cts_param luo_parametros
	
Open(w_parametro_corte)
 
luo_parametros = Message.PowerObjectParm

IF luo_parametros.is_vector[1] <> 'N' THEN
	ll_ordencorte  = luo_parametros.il_vector[1]
	il_agrupacion = of_agrupacion(ll_ordencorte, li_estado_agrupa)	
	
	If li_estado_agrupa <> 1 Then
		MessageBox("Advertencia...","Estado de agrupaci$$HEX1$$f300$$ENDHEX$$n inconsistente")
		Return
	End If		
	
	IF dw_telas_referencias.Retrieve(il_agrupacion) > 0 THEN
		IF dw_rayas_base.Retrieve(il_agrupacion) > 0 THEN
			dw_rayas_base.TriggerEvent("RowFocusChanged")
		END IF
	END IF
	
END IF
end event

public function long of_actualizar_pdn (long al_basetrazo, long ai_fabrica, long ai_linea, long al_referencia, long ai_operacion);Long li_pdn, li_filas, li_tallas, li_talla, li_estado
Long ll_unidades
u_ds_base luo_pdn_agrupacion, luo_tallas_pdn

luo_pdn_agrupacion = Create u_ds_base

luo_pdn_agrupacion.DataObject = 'dgr_pdn_por_agrupacion_referencia'

IF luo_pdn_agrupacion.SetTransObject(SQLCA) = -1 THEN
	MessageBox("Error DataWindow","Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n de las producciones")
	Return -1
END IF

luo_tallas_pdn = Create u_ds_base

luo_tallas_pdn.DataObject = 'dgr_tallas_por_agrupacion_pdn'

IF luo_tallas_pdn.SetTransObject(SQLCA) = -1 THEN
	MessageBox("Error DataWindow","Error al definir el objeto transacci$$HEX1$$f300$$ENDHEX$$n de las producciones")
	Return -1
END IF

luo_pdn_agrupacion.Retrieve(il_agrupacion, ai_fabrica, ai_linea, al_referencia)

FOR li_filas = 1 TO luo_pdn_agrupacion.RowCount()
	li_pdn = luo_pdn_agrupacion.GetItemNumber(li_filas, "cs_pdn")
	luo_tallas_pdn.Retrieve(il_agrupacion, li_pdn)
	IF ai_operacion = 1 THEN
		
		INSERT INTO dt_pdnxbase(cs_agrupacion, cs_base_trazos, cs_pdn, fe_creacion,
			fe_actualizacion, usuario, instancia)
		VALUES(:il_agrupacion, :al_basetrazo, :li_pdn, Current, Current, User, SiteName);
		
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al insertar la producci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
			Return -1
		END IF
		
		FOR li_tallas = 1 TO luo_tallas_pdn.RowCount()
			li_talla = luo_tallas_pdn.GetItemNumber(li_tallas, "co_talla")
			li_estado = luo_tallas_pdn.GetItemNumber(li_tallas, "co_estado")
			ll_unidades = luo_tallas_pdn.GetItemNumber(li_tallas, "ca_unidades")
			
			INSERT INTO dt_escalaxpdnbase(cs_agrupacion, cs_base_trazos, cs_pdn, co_talla, 
				cs_talla, ca_unidades, co_estado, fe_creacion, fe_actualizacion, usuario,
				instancia)
			VALUES(:il_agrupacion, :al_basetrazo, :li_pdn, :li_talla, :li_tallas, :ll_unidades,
				:li_estado, Current, Current, User, SiteName);
				
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al insertar registro de tallas " + SQLCA.SQLErrText)
				Return -1
			END IF
		NEXT		
	ELSE
		FOR li_tallas = 1 TO luo_tallas_pdn.RowCount()
			li_talla = luo_tallas_pdn.GetItemNumber(li_tallas, "co_talla")
		
			DELETE FROM dt_escalaxpdnbase
			WHERE cs_agrupacion = :il_agrupacion AND
					cs_base_trazos = :al_basetrazo AND
					cs_pdn = :li_pdn AND
					co_talla =:li_talla;
					
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al borrar talla " + SQLCA.SQLErrText)
				Return -1
			END IF
		NEXT
		DELETE FROM dt_pdnxbase
		WHERE cs_agrupacion = :il_agrupacion AND
				cs_base_trazos = :al_basetrazo AND
				cs_pdn = :li_pdn;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al borrar la producci$$HEX1$$f300$$ENDHEX$$n " + SQLCA.SQLErrText)
			Return -1
		END IF
	END IF
NEXT
Return 1
end function

public function long of_agrupacion (long al_ordencorte, ref long ai_estado);Long   ll_agrupa
String ls_sqlerr


select distinct dt_agrupa_pdn.cs_agrupacion, h_agrupa_pdn.co_estado
  into :ll_agrupa, :ai_estado
  from dt_pdnxmodulo, dt_agrupa_pdn, h_agrupa_pdn
 where dt_pdnxmodulo.co_fabrica_exp 		= dt_agrupa_pdn.co_fabrica_exp and
       dt_pdnxmodulo.cs_liberacion 			= dt_agrupa_pdn.cs_liberacion and
       dt_pdnxmodulo.po 						= dt_agrupa_pdn.po and
		 dt_pdnxmodulo.nu_cut					= dt_agrupa_pdn.nu_cut and
       dt_pdnxmodulo.co_fabrica_pt 			= dt_agrupa_pdn.co_fabrica_pt and 
       dt_pdnxmodulo.co_linea 				= dt_agrupa_pdn.co_linea and
       dt_pdnxmodulo.co_referencia 			= dt_agrupa_pdn.co_referencia and  
       dt_pdnxmodulo.co_color_pt 			= dt_agrupa_pdn.co_color_pt and
       dt_pdnxmodulo.tono 						= dt_agrupa_pdn.tono and  
       dt_pdnxmodulo.cs_particion 			= dt_agrupa_pdn.cs_particion and
       dt_pdnxmodulo.cs_asignacion 			= :al_ordencorte and
		 dt_agrupa_pdn.cs_agrupacion			= h_agrupa_pdn.cs_agrupacion;

If Sqlca.SqlCode = -1 Then
	ls_sqlerr = Sqlca.SqlErrText
	rollback ;
	MessageBox("Advertencia!","Hubo un error al recuperar la agrupaci$$HEX1$$f300$$ENDHEX$$n.~n~nNota: " + ls_sqlerr)
	Return -1
ElseIf Sqlca.SqlCode = 100 Then
	MessageBox("Informaci$$HEX1$$f300$$ENDHEX$$n!","Esta orden no tiene agrupaci$$HEX1$$f300$$ENDHEX$$n.")
	Return -1
End If

Return ll_agrupa
end function

on w_definir_rayas_agrupacion.create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.dw_asociacion=create dw_asociacion
this.dw_telas_referencias=create dw_telas_referencias
this.dw_rayas_base=create dw_rayas_base
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.dw_asociacion,&
this.dw_telas_referencias,&
this.dw_rayas_base,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_definir_rayas_agrupacion.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_asociacion)
destroy(this.dw_telas_referencias)
destroy(this.dw_rayas_base)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;Long ll_ordencorte
Long li_estado_agrupa
n_cts_param luo_parametros

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

luo_parametros = Message.PowerObjectParm
IF Not IsValid(luo_parametros) THEN
	Open(w_parametro_corte)
	 
	luo_parametros = Message.PowerObjectParm
	
	IF luo_parametros.is_vector[1] <> 'N' THEN
		ll_ordencorte  = luo_parametros.il_vector[1]
		il_agrupacion = of_agrupacion(ll_ordencorte, li_estado_agrupa)	
		
		If li_estado_agrupa <> 1 Then
			MessageBox("Advertencia...","Estado de agrupaci$$HEX1$$f300$$ENDHEX$$n inconsistente")
			Return
		End If		
		
	END IF
ELSE
	il_agrupacion = luo_parametros.il_vector[1]
END IF
dw_telas_referencias.SetTransObject(SQLCA)
dw_rayas_base.SetTransObject(SQLCA)
dw_asociacion.SetTransObject(SQLCA)
IF dw_telas_referencias.Retrieve(il_agrupacion) > 0 THEN
	IF dw_rayas_base.Retrieve(il_agrupacion) > 0 THEN
		dw_rayas_base.TriggerEvent("RowFocusChanged")
	END IF
END IF


end event

type dw_asociacion from datawindow within w_definir_rayas_agrupacion
integer x = 901
integer y = 908
integer width = 2359
integer height = 476
integer taborder = 20
string title = "none"
string dataobject = "dgr_rayas_telasxbase"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Long li_fabrica, li_linea
Long ll_basetrazos, ll_referencia, ll_basetrazo

IF Row > 0 THEN
	ll_basetrazo = This.GetItemNumber(Row, "cs_base_trazos")
	li_fabrica = This.GetItemNumber(Row, "co_fabrica")
	li_linea = This.GetItemNumber(Row, "co_linea")
	ll_referencia = This.GetItemNumber(Row, "co_referencia")
	IF of_actualizar_pdn(ll_basetrazo, li_fabrica, li_linea, ll_referencia, 2) = 1 THEN
		IF This.DeleteRow(Row) = 1 THEN
			IF This.AcceptText() <> -1 THEN
				IF This.Update() = -1 THEN
					ROLLBACK;				
					MessageBox("Advertencia...","Se present$$HEX2$$f3002000$$ENDHEX$$un problema al borrar registros de asociaci$$HEX1$$f300$$ENDHEX$$n en la base de datos")
				ELSE
					COMMIT;
				END IF
			ELSE
				ROLLBACK;
				MessageBox("Advertencia...","No se pudo llevar los registros a la datawindow")
			END IF
		ELSE
			ll_basetrazos = dw_rayas_base.GetItemNumber(dw_rayas_base.GetRow(), "cs_base_trazos")
			This.Retrieve(il_agrupacion, ll_basetrazos)
		END IF
	ELSE
		ROLLBACK;
	END IF
END IF
end event

type dw_telas_referencias from datawindow within w_definir_rayas_agrupacion
integer x = 59
integer y = 80
integer width = 3566
integer height = 732
integer taborder = 20
string title = "none"
string dataobject = "dgr_rayas_referencias_agrupacion"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Long li_fabrica, li_linea, li_basetrazo, li_fabricate, li_caract, li_diametro
Long li_raya, li_fila_base, li_fila_asociacion
Long ll_referencia, ll_modelo, ll_reftel, ll_colorte
n_cts_constantes luo_constantes

luo_constantes = Create n_cts_constantes

li_fabricate = luo_constantes.of_consultar_numerico("FABRICA TELA")

IF li_fabricate = -1 THEN
	Return
END IF

IF Row > 0 THEN
	li_fila_base = dw_rayas_base.GetRow()
	IF li_fila_base > 0 THEN
		li_basetrazo = dw_rayas_base.GetItemNumber(li_fila_base, 'cs_base_trazos')
		li_fabrica = dw_telas_referencias.GetItemNumber(Row, 'co_fabrica')
		li_linea = dw_telas_referencias.GetItemNumber(Row, 'co_linea')
		ll_referencia = dw_telas_referencias.GetItemNumber(Row, 'co_referencia')
		ll_modelo = dw_telas_referencias.GetItemNumber(Row, 'co_modelo')
		ll_reftel = dw_telas_referencias.GetItemNumber(Row, 'co_reftel')
		li_caract = dw_telas_referencias.GetItemNumber(Row, 'co_caract')
		li_diametro = dw_telas_referencias.GetItemNumber(Row, 'diametro')
		ll_colorte = dw_telas_referencias.GetItemNumber(Row, 'co_color_te')
		li_raya = dw_telas_referencias.GetItemNumber(Row, 'raya')
		li_fila_asociacion = dw_asociacion.InsertRow(0)
		IF li_fila_asociacion = -1 THEN
			MessageBox("Advertencia...","No se present$$HEX2$$f3002000$$ENDHEX$$un error al insertar registro en la asociaci$$HEX1$$f300$$ENDHEX$$n de rayas")
			Return
		END IF
		dw_asociacion.SetItem(li_fila_asociacion, 'cs_agrupacion', il_agrupacion)
		dw_asociacion.SetItem(li_fila_asociacion, 'cs_base_trazos', li_basetrazo)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_fabrica', li_fabrica)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_linea', li_linea)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_referencia', ll_referencia)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_modelo', ll_modelo)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_fabrica_te', li_fabricate)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_reftel', ll_reftel)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_caract', li_caract)
		dw_asociacion.SetItem(li_fila_asociacion, 'diametro', li_diametro)
		dw_asociacion.SetItem(li_fila_asociacion, 'co_color_te', ll_colorte)
		dw_asociacion.SetItem(li_fila_asociacion, 'raya', li_raya)
		dw_asociacion.SetItem(li_fila_asociacion, 'fe_creacion', f_fecha_servidor())
		dw_asociacion.SetItem(li_fila_asociacion, 'fe_actualizacion', f_fecha_servidor())
		dw_asociacion.SetItem(li_fila_asociacion, 'usuario', gstr_info_usuario.codigo_usuario)
		dw_asociacion.SetItem(li_fila_asociacion, 'instancia', gstr_info_usuario.instancia)
		IF dw_asociacion.AcceptText() <> -1 THEN
			IF dw_asociacion.Update() = -1 THEN
				ROLLBACK;				
				MessageBox("Advertencia...","Se present$$HEX2$$f3002000$$ENDHEX$$un problema al insertar registros de asociaci$$HEX1$$f300$$ENDHEX$$n en la base de datos")
			ELSE
				IF of_actualizar_pdn(li_basetrazo, li_fabrica, li_linea, ll_referencia, 1) = 1 THEN
					COMMIT;
				ELSE
					ROLLBACK;
				END IF
			END IF
		ELSE
			ROLLBACK;
			MessageBox("Advertencia...","No se pudo llevar los registros a la datawindow")
		END IF
	END IF
END IF
end event

type dw_rayas_base from datawindow within w_definir_rayas_agrupacion
integer x = 59
integer y = 908
integer width = 741
integer height = 476
integer taborder = 10
string title = "none"
string dataobject = "dgr_mantenimiento_base_trazos"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;Long ll_basetrazos

IF CurrentRow > 0 THEN
	ll_basetrazos = This.GetItemNumber(CurrentRow, "cs_base_trazos")
	dw_asociacion.Retrieve(il_agrupacion, ll_basetrazos)
END IF
end event

type gb_1 from groupbox within w_definir_rayas_agrupacion
integer x = 32
integer y = 16
integer width = 3639
integer height = 828
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Rayas Referencias"
end type

type gb_2 from groupbox within w_definir_rayas_agrupacion
integer x = 32
integer y = 844
integer width = 818
integer height = 568
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Rayas Agrupaci$$HEX1$$f300$$ENDHEX$$n"
end type

type gb_3 from groupbox within w_definir_rayas_agrupacion
integer x = 873
integer y = 844
integer width = 2418
integer height = 568
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Asociaci$$HEX1$$f300$$ENDHEX$$n Rayas"
end type

