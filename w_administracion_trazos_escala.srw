HA$PBExportHeader$w_administracion_trazos_escala.srw
forward
global type w_administracion_trazos_escala from w_base_maestroff_detalletb_subdetalletb
end type
type cb_1 from commandbutton within w_administracion_trazos_escala
end type
type dw_refptxtrazo_esc from datawindow within w_administracion_trazos_escala
end type
type dw_tallasxtrazo_esc from datawindow within w_administracion_trazos_escala
end type
end forward

global type w_administracion_trazos_escala from w_base_maestroff_detalletb_subdetalletb
integer x = 0
integer y = 0
integer width = 2725
integer height = 1720
string title = "Administraci$$HEX1$$f300$$ENDHEX$$n Trazos"
cb_1 cb_1
dw_refptxtrazo_esc dw_refptxtrazo_esc
dw_tallasxtrazo_esc dw_tallasxtrazo_esc
end type
global w_administracion_trazos_escala w_administracion_trazos_escala

on w_administracion_trazos_escala.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_refptxtrazo_esc=create dw_refptxtrazo_esc
this.dw_tallasxtrazo_esc=create dw_tallasxtrazo_esc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_refptxtrazo_esc
this.Control[iCurrent+3]=this.dw_tallasxtrazo_esc
end on

on w_administracion_trazos_escala.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_refptxtrazo_esc)
destroy(this.dw_tallasxtrazo_esc)
end on

event open;call super::open;This.width = 2725
This.height = 1720

dw_refptxtrazo_esc.SetTransObject(SQLCA)
dw_tallasxtrazo_esc.SetTransObject(SQLCA)

n_cts_constantes_corte luo_constante_corte
n_cst_string 				lnv_string
Long ll_cont, ll_array[], ll_band
String ls_perfiles

//toma los perfiles
ls_perfiles = luo_constante_corte.of_consultar_texto("PERFIL_TRAZOS_ESCALA")

lnv_string	= CREATE n_cst_string	

//los perfiles los pasa a un arreglo
lnv_string.of_convertirstring_array(ls_perfiles,ll_array)

Destroy lnv_string

ll_band = 0
//busca el perfil en el arreglo 
FOR ll_cont=1 to upperbound(ll_array[]) 
	IF gstr_info_usuario.codigo_perfil = Long(ll_array[ll_cont]) THEN
		ll_band = 1
	END IF
NEXT

//si encontro el perfil
IF ll_band = 1 THEN
ELSE
	This.dw_maestro.enabled = false
	This.dw_detalle.enabled = false
	This.dw_subdetalle.enabled = false
	
END IF

	

end event

event ue_insertar_subdetalle;dw_subdetalle.TriggerEvent("adcnar_fla")
end event

event ue_insertar_detalle;call super::ue_insertar_detalle;Long ll_trazo

IF il_fila_actual_maestro > 0 THEN
	ll_trazo = dw_maestro.GetItemNumber(il_fila_actual_maestro,"co_trazo")
	IF IsNull(ll_trazo) THEN
		dw_detalle.DeleteRow(il_fila_actual_detalle)
		il_fila_actual_detalle = il_fila_actual_detalle - 1
	ELSE
		dw_detalle.SetItem(il_fila_actual_detalle, "co_trazo", ll_trazo)
		dw_detalle.SetItem(il_fila_actual_detalle, "fe_creacion", DateTime(Today(), Now()))
		dw_detalle.AcceptText()
	END IF
END IF
end event

event ue_buscar;call super::ue_buscar;s_base_parametros lstr_parametros
Long li_fabrica, li_linea
Long ll_hallados, ll_trazo, ll_referencia

IF is_cambios = "no" OR is_accion <> "cancelo" THEN
	Open(w_buscar_trazo_lista_mardila)
	lstr_parametros=message.powerObjectparm

	IF lstr_parametros.hay_parametros THEN
		ll_trazo = lstr_parametros.entero[1]
		ll_hallados = dw_maestro.Retrieve(ll_trazo)
		IF isnull(ll_hallados) THEN
			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
		ELSE
			CHOOSE CASE ll_hallados
				CASE -1
					il_fila_actual_maestro = -1
					MessageBox("Error buscando","Error de la base",StopSign!,&
                         Ok!)
				CASE 0
					il_fila_actual_maestro = 0
					MessageBox("Sin Datos","No hay datos para su criterio",&
                         Exclamation!,Ok!)
				CASE ELSE
					il_fila_actual_maestro = 1
					ll_hallados = dw_detalle.Retrieve(ll_trazo)
					CHOOSE CASE ll_hallados
						CASE -1
							il_fila_actual_maestro = -1
							MessageBox("Error buscando","Error de la base",StopSign!,&
										 Ok!)
						CASE 0
							il_fila_actual_detalle = 0
						CASE ELSE
							il_fila_actual_detalle = 1
							li_fabrica = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_fabrica")
							li_linea = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_linea")
							ll_referencia = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_referencia")
							ll_hallados = dw_subdetalle.Retrieve(ll_trazo, li_fabrica, li_linea, ll_referencia)
							IF ll_hallados > 0 THEN
								il_fila_actual_subdetalle = 1
							ELSE
								il_fila_actual_subdetalle = 0
							END IF
							
							ll_hallados = dw_refptxtrazo_esc.Retrieve(ll_trazo, li_fabrica, li_linea, ll_referencia)
							ll_hallados = dw_tallasxtrazo_esc.Retrieve(ll_trazo, li_fabrica, li_linea, ll_referencia)
							
					END CHOOSE
			END CHOOSE
		END IF
	ELSE
	END IF
ELSE
END IF

end event

event ue_insertar_maestro;call super::ue_insertar_maestro;String		ls_molderia
Decimal{2}	ld_ancho, ld_largo, ld_repite, ld_porc_util
Long		li_tipo, li_extendido, li_estado, li_forma


dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", DateTime(Today(), Now()))

IF il_fila_actual_maestro > 1 THEN
	ls_molderia = dw_maestro.GetitemString((il_fila_actual_maestro - 1),"molderia")
	ld_ancho 	= dw_maestro.GetitemDecimal((il_fila_actual_maestro - 1),"ancho")
	ld_largo 	= dw_maestro.GetitemDecimal((il_fila_actual_maestro - 1),"largo")
	li_tipo	 	= dw_maestro.GetitemNumber((il_fila_actual_maestro - 1),"tipo")
	li_extendido= dw_maestro.GetitemNumber((il_fila_actual_maestro - 1),"extendido")
	ld_repite 	= dw_maestro.GetitemDecimal((il_fila_actual_maestro - 1),"repite")
	ld_porc_util= dw_maestro.GetitemDecimal((il_fila_actual_maestro - 1),"porc_util")
	li_estado	= dw_maestro.GetitemNumber((il_fila_actual_maestro - 1),"co_estado_trazo")
	li_forma		= dw_maestro.GetitemNumber((il_fila_actual_maestro - 1),"forma_ext")
	
	dw_maestro.SetItem(il_fila_actual_maestro, "molderia", ls_molderia)
	dw_maestro.SetItem(il_fila_actual_maestro, "ancho", ld_ancho)
	dw_maestro.SetItem(il_fila_actual_maestro, "largo", ld_largo)		
	dw_maestro.SetItem(il_fila_actual_maestro, "tipo", li_tipo)	
	dw_maestro.SetItem(il_fila_actual_maestro, "extendido", li_extendido)
	dw_maestro.SetItem(il_fila_actual_maestro, "repite", ld_repite)
	dw_maestro.SetItem(il_fila_actual_maestro, "porc_util", ld_porc_util)
	dw_maestro.SetItem(il_fila_actual_maestro, "co_estado_trazo", li_estado)	
	dw_maestro.SetItem(il_fila_actual_maestro, "forma_ext", li_forma)

END IF
end event

event ue_grabar;call super::ue_grabar;
IF dw_refptxtrazo_esc.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro",Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_refptxtrazo_esc.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

IF dw_tallasxtrazo_esc.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro",Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_tallasxtrazo_esc.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

end event

type dw_maestro from w_base_maestroff_detalletb_subdetalletb`dw_maestro within w_administracion_trazos_escala
integer y = 16
integer width = 2418
integer height = 472
boolean titlebar = false
string dataobject = "dtb_maestro_trazos"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_maestro::updatestart;Long ll_cs_documento,ll_trazo

IF gstr_info_usuario.codigo_perfil <> 5 THEN
	
END IF

IF il_fila_actual_maestro > 0 THEN

	ll_trazo = dw_maestro.GetitemNumber(il_fila_actual_maestro,"co_trazo")
	
	IF IsNull(ll_trazo) THEN ll_trazo = 0
	
	IF ll_trazo  = 0 THEN

		SELECT max(cf_consecutivos.cs_documento )  
		INTO :ll_cs_documento  
		FROM cf_consecutivos  
		WHERE ( cf_consecutivos.co_fabrica = 2 ) AND  
				( cf_consecutivos.id_documento = 55 );
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox("Error","Hubo Problemas con la base de Datos: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
			Return(1)
		ELSE
			IF SQLCA.SQLCODE = 100 THEN
				MessageBox("Advertencia","No se encontro Consecutivo de Trazo, Favor llamar a Sistemas",Exclamation!,OK!)
				Return(1)
			ELSE
			  IF SQLCA.SQLCODE = 0 THEN
				  ll_cs_documento = ll_cs_documento + 1
				  dw_maestro.SetItem(il_fila_actual_maestro,"co_trazo",ll_cs_documento)
				  dw_maestro.AcceptText()
				  UPDATE cf_consecutivos  
					SET cs_documento = cs_documento + 1  
				  WHERE ( cf_consecutivos.co_fabrica = 2 ) AND  
						 ( cf_consecutivos.id_documento = 55 );
				  IF SQLCA.SQLCODE = 1 THEN
					  MessageBox("Error","Hubo Problemas1 Actualizando Consecutivo de Trazo: "+" "+SQLCA.SQLErrText,Stopsign!,OK!)
					  ROLLBACK;
					  Return(1)
				  END IF
			  END IF
		  END IF
	 END IF
	END IF
END IF
end event

event dw_maestro::itemchanged;DECIMAL{2}	ld_util_trazo, ld_util_ant
	
dw_maestro.SetItem(Row, "fe_actualizacion", DateTime(Today(), Now()))
dw_maestro.SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
dw_maestro.SetItem(Row, "instancia", gstr_info_usuario.instancia)

IF DWO.NAME = "porc_util" THEN
	ld_util_trazo = DEC(DATA)
	ld_util_ant = dw_maestro.GetItemNumber(il_fila_actual_maestro, "porc_util")
	IF ld_util_trazo >= 100 THEN
  		Messagebox('Advertencia', 'El porcentaje de utilizacion debe ser menor que 100')
	   dw_maestro.SetItem(il_fila_actual_maestro, "porc_util", ld_util_ant)
	END If
END IF

end event

type dw_detalle from w_base_maestroff_detalletb_subdetalletb`dw_detalle within w_administracion_trazos_escala
integer x = 32
integer y = 520
integer width = 2167
integer height = 372
boolean titlebar = false
string dataobject = "dtb_referencias_x_trazo"
boolean vscrollbar = false
boolean hsplitscroll = false
end type

event dw_detalle::itemchanged;Long li_linea, li_fabrica
Long ll_referencia
String ls_descripcion, ls_referencia

dw_detalle.AcceptText()
dw_detalle.SetItem(Row, "fe_actualizacion", DateTime(Today(), Now()))
dw_detalle.SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
dw_detalle.SetItem(Row, "instancia", gstr_info_usuario.instancia)
IF Dwo.Name = "co_linea" THEN
	li_fabrica = dw_detalle.GetItemNumber(Row, "co_fabrica")
	li_linea = dw_detalle.GetItemNumber(Row, "co_linea")
	IF Not IsNull(li_fabrica) AND Not IsNull(li_linea) THEN
		SELECT	de_linea
		INTO		:ls_descripcion
		FROM		m_lineas
		WHERE		co_fabrica = :li_fabrica AND
					co_linea = :li_linea;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al validar la l$$HEX1$$ed00$$ENDHEX$$nea en Vestimundo")
			Return(2)
		ELSE
			IF SQLCA.SQLCode = 100 THEN
				SELECT	de_linea
				INTO		:ls_descripcion
				FROM		m_lineas_inf
				WHERE		co_fabrica = :li_fabrica AND
							co_linea = :li_linea;
				IF SQLCA.SQLCode = -1 THEN
					MessageBox("Error Base Datos","Error al validar la l$$HEX1$$ed00$$ENDHEX$$nea en Infantiles")
					Return(2)
				ELSE
					IF SQLCA.SQLCode = 100 THEN
						MessageBox("Advertencia...","La l$$HEX1$$ed00$$ENDHEX$$nea no existe en la base de datos")
						Return(2)
					ELSE
						dw_detalle.SetItem(Row, "m_lineas_de_linea", ls_descripcion)
					END IF
				END IF
			ELSE
				dw_detalle.SetItem(Row, "m_lineas_de_linea", ls_descripcion)				
			END IF
		END IF
	END IF
END IF				
IF Dwo.Name = "co_referencia" THEN
	li_fabrica = dw_detalle.GetItemNumber(Row, "co_fabrica")
	li_linea = dw_detalle.GetItemNumber(Row, "co_linea")
	ll_referencia = dw_detalle.GetItemNumber(Row, "co_referencia")
	ls_referencia = string(ll_referencia)
	SELECT	de_referencia
	INTO		:ls_descripcion
	FROM		h_preref_pv
	WHERE		co_fabrica = :li_fabrica AND
				co_linea = :li_linea AND
				co_referencia = :ls_referencia AND
				co_tipo_ref   = 'P';
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al validar la referencia en Vestimundo")
		Return(2)
	ELSE
		IF SQLCA.SQLCode = 100 THEN
			SELECT	de_referencia
			INTO		:ls_descripcion
			FROM		h_preref_inf
			WHERE		co_fabrica = :li_fabrica AND
						co_linea = :li_linea AND
						co_referencia = :ll_referencia;
			IF SQLCA.SQLCode = -1 THEN
				MessageBox("Error Base Datos","Error al validar la referencia en Infantiles")
				Return(2)
			ELSE 
				IF SQLCA.SQLCode = 100 THEN
					MessageBox("Advertencia...","La referencia no existe en la base de datos")
					Return(2)
				ELSE
					dw_detalle.SetItem(Row, "h_preref_de_referencia", ls_descripcion)
				END IF
			END IF
		ELSE
			dw_detalle.SetItem(Row, "h_preref_de_referencia", ls_descripcion)
		END IF
	END IF
END IF
end event

event dw_detalle::rowfocuschanged;call super::rowfocuschanged;Long li_fabrica, li_linea
Long ll_referencia, ll_trazo

IF il_fila_actual_detalle > 0 THEN
	ll_trazo = dw_detalle.GetitemNumber(il_fila_actual_detalle, "co_trazo")
	li_fabrica = dw_detalle.GetitemNumber(il_fila_actual_detalle, "co_fabrica")
	li_linea = dw_detalle.GetitemNumber(il_fila_actual_detalle, "co_linea")
	ll_referencia = dw_detalle.GetitemNumber(il_fila_actual_detalle, "co_referencia")
	IF Not IsNull(ll_trazo) AND Not IsNull(li_fabrica) AND &
		Not IsNull(li_linea) AND Not IsNull(ll_referencia) THEN
		dw_subdetalle.Retrieve(ll_trazo, li_fabrica, li_linea, ll_referencia)
		 dw_refptxtrazo_esc.Retrieve(ll_trazo, li_fabrica, li_linea, ll_referencia)
		 dw_tallasxtrazo_esc.Retrieve(ll_trazo, li_fabrica, li_linea, ll_referencia)

	END IF
ELSE
	dw_subdetalle.Reset()
END IF



end event

type dw_subdetalle from w_base_maestroff_detalletb_subdetalletb`dw_subdetalle within w_administracion_trazos_escala
integer x = 2208
integer y = 528
integer width = 471
integer height = 748
boolean titlebar = false
string dataobject = "dtb_detalle_tallasxtrazo"
boolean vscrollbar = false
boolean hsplitscroll = false
end type

event dw_subdetalle::adcnar_fla;Long		ll_fabrica, ll_linea, ll_referencia
Long 		ll_cotrazo, ll_talla, ll_capaquetes
Long 		ll_registros, ll_regactual, ll_fila, ll_numregistros
s_base_parametros_seleccionar lstr_parametros

IF il_fila_actual_maestro > 0 THEN
	ll_cotrazo 		=	dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_trazo")		
	ll_fabrica		=	dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_fabrica")		
	ll_linea			=	dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_linea")		
	ll_referencia	=	dw_detalle.GetitemNumber(il_fila_actual_detalle,"co_referencia")		
	
//	IF ll_cotrazo = 0 OR ISNULL(ll_cotrazo) THEN
//		MessageBox("Advertencia","No ha digitado el codigo del trazo", Exclamation!)
//		Return
//	END IF
	
	IF ll_cotrazo <> 0 AND &
		( ll_fabrica = 0 OR ISNULL(ll_fabrica) OR &
		  ll_linea = 0 OR ISNULL(ll_linea) OR &
		  ll_referencia = 0 OR ISNULL(ll_referencia) ) THEN
		MessageBox("Advertencia","No ha digitado la referencia", Exclamation!)
		Return
	END IF	

	lstr_parametros.entero1[1] = ll_cotrazo		
	lstr_parametros.entero1[2] = ll_fabrica		
	lstr_parametros.entero1[3] = ll_linea			
	lstr_parametros.entero1[4] = ll_referencia	

	OpenWithParm(w_seleccionar_tallasordencorte_mardila, lstr_parametros)
	lstr_parametros = Message.PowerObjectParm
	
	IF lstr_parametros.hay_parametros THEN
	
		ll_registros = lstr_parametros.entero1[1]
		FOR ll_regactual = 2 TO ll_registros
			
			ll_fila = InsertRow(0)
			IF ll_fila <> -1 THEN
				ll_talla				=	lstr_parametros.entero1[ll_regactual]

  				SELECT Count(*)  
				INTO :ll_numregistros  
				FROM dt_tallasxtrazo  
				WHERE ( dt_tallasxtrazo.co_trazo = :ll_cotrazo ) AND
						( dt_tallasxtrazo.co_fabrica = :ll_fabrica ) AND
						( dt_tallasxtrazo.co_linea = :ll_linea ) AND
						( dt_tallasxtrazo.co_referencia = :ll_referencia ) AND
     					( dt_tallasxtrazo.co_talla = :ll_talla )   ;
								
				IF ll_numregistros = 0 THEN
					SetItem(ll_fila, "co_trazo", ll_cotrazo)
					SetItem(ll_fila, "co_fabrica", ll_fabrica)
					SetItem(ll_fila, "co_linea", ll_linea)
					SetItem(ll_fila, "co_referencia", ll_referencia)
					SetItem(ll_fila, "co_talla",ll_talla)
					SetItem(ll_fila, "ca_paquetes", 0)
					SetItem(ll_fila, "fe_creacion", DateTime(Today(), Now()))
					SetItem(ll_fila, "fe_actualizacion", DateTime(Today(), Now()))			
					SetItem(ll_fila, "usuario", gstr_info_usuario.codigo_usuario)				
					SetItem(ll_fila, "instancia", gstr_info_usuario.instancia)			
				ELSE
					DeleteRow(ll_fila)
				END IF				
			ELSE
				MessageBox("Error DataWindow","Error al insertar fila")
				Return(-1)
			END IF
		NEXT
		AcceptText()
	END IF
END IF
//Parent.TriggerEvent("ue_grabar")
//dw_detalle.Retrieve(ll_cotrazo)
Return(0)
end event

event dw_subdetalle::itemchanged;dw_subdetalle.SetItem(Row, "fe_actualizacion", DateTime(Today(), Now()))
dw_subdetalle.SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
dw_subdetalle.SetItem(Row, "instancia", gstr_info_usuario.instancia)
end event

type cb_1 from commandbutton within w_administracion_trazos_escala
integer x = 18
integer y = 988
integer width = 315
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Ins Escala"
end type

event clicked;Long	li_fabrica, li_linea, li_tipo_escala, li_escala, li_tot_talla
Long	posi, li_talla, ll_fila_talla_esc, ll_fila_ref_esc
Long		ll_referencia, ll_co_trazo

li_tipo_escala = dw_maestro.GetItemNumber(il_fila_actual_maestro, "forma_ext")
IF li_tipo_escala = 1 THEN
ELSE
	MessageBox('Advertencia','La orden no es tipo escala')
	Return
END IF

IF il_fila_actual_detalle > 0 THEN
ELSE
	MessageBox('Advertencia','No ha seleccionado la fila en el detalle')
	Return
END IF

li_fabrica = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_fabrica")
li_linea = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_linea")
ll_referencia = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_referencia")
ll_co_trazo = dw_detalle.GetItemNumber(il_fila_actual_detalle, "co_trazo")


SELECT MAX(cs_escala)
  INTO :li_escala
  FROM dt_refptxtrazo_esc
 WHERE co_trazo = :ll_co_trazo
   AND co_fabrica = :li_fabrica
   AND co_linea = :li_linea
	AND co_referencia = :ll_referencia;
IF SQLCA.SQLCODE <> 0 THEN
	IF SQLCA.SQLCODE = 100 THEN
		li_escala = 1
	ELSE
		MessageBox('Error', 'Error buscando maxima escala')
		Return
	END IF
ELSE
END IF
IF ISNULL(li_escala) THEN
	li_escala = 0
END IF
li_escala = li_escala + 1
	
//Insertar una fila en maestro de escalas	
ll_fila_ref_esc = dw_refptxtrazo_esc.InsertRow(0)
IF ll_fila_ref_esc = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro de escalas",StopSign!)
ELSE
	dw_refptxtrazo_esc.SetRow(ll_fila_ref_esc)
	dw_refptxtrazo_esc.ScrollToRow(ll_fila_ref_esc)
	dw_refptxtrazo_esc.SetColumn(1)
	
	dw_refptxtrazo_esc.SelectRow(ll_fila_ref_esc,FALSE)
	ll_fila_ref_esc = dw_refptxtrazo_esc.GetRow()
END IF

//LLevar los datos de la referencia al maestro de escalas.	
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "co_trazo", ll_co_trazo)
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "co_fabrica", li_fabrica)
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "co_linea", li_linea)
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "co_referencia", ll_referencia)
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "cs_escala", li_escala)
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "fe_actualizacion", DateTime(Today(), Now()))
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "fe_actualizacion", DateTime(Today(), Now()))
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "usuario", gstr_info_usuario.codigo_usuario)
dw_refptxtrazo_esc.SetItem(ll_fila_ref_esc, "instancia", gstr_info_usuario.instancia)

li_tot_talla = dw_subdetalle.RowCount()

FOR posi = 1 to li_tot_talla
  li_talla = dw_subdetalle.GetItemNumber(posi, "co_talla")

  //Insertar una fila en detalle de escalas	
	ll_fila_talla_esc = dw_tallasxtrazo_esc.InsertRow(0)
	IF ll_fila_talla_esc = -1 THEN
		MessageBox("Error datawindow","No se pudo insertar el registro del detalle de escalas",StopSign!)
	ELSE
		dw_tallasxtrazo_esc.SetRow(ll_fila_talla_esc)
		dw_tallasxtrazo_esc.ScrollToRow(ll_fila_talla_esc)
		dw_tallasxtrazo_esc.SetColumn(1)
		dw_tallasxtrazo_esc.SelectRow(ll_fila_talla_esc,FALSE)
		ll_fila_talla_esc = dw_tallasxtrazo_esc.GetRow()
	END IF
	
	//Llevar los demas datos al detalle de escalas
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "co_trazo", ll_co_trazo)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "co_fabrica", li_fabrica)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "co_linea", li_linea)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "co_referencia", ll_referencia)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "cs_escala", li_escala)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "co_talla", li_talla)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "fe_actualizacion", DateTime(Today(), Now()))
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "fe_actualizacion", DateTime(Today(), Now()))
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "usuario", gstr_info_usuario.codigo_usuario)
	dw_tallasxtrazo_esc.SetItem(ll_fila_talla_esc, "instancia", gstr_info_usuario.instancia)
	
NEXT

IF dw_refptxtrazo_esc.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro",Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_refptxtrazo_esc.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

IF dw_tallasxtrazo_esc.AcceptText() = -1 THEN
	is_accion = "no accepttext"
	Messagebox("Error","No se pudieron realizar los cambios en el maestro",Exclamation!,Ok!)	
	RETURN
ELSE
	IF dw_tallasxtrazo_esc.Update() = -1 THEN
		is_accion = "no update"
		ROLLBACK;
	   RETURN
	ELSE
		is_accion = "si update"
		COMMIT;
		IF SQLCA.SQLCode = -1 THEN
			is_grabada = "no"
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)	
		ELSE
			is_grabada = "si"
		END IF
	END IF
END IF

	
dw_refptxtrazo_esc.Retrieve(ll_co_trazo,li_fabrica,li_linea,ll_referencia)
dw_tallasxtrazo_esc.Retrieve(ll_co_trazo,li_fabrica,li_linea,ll_referencia)

end event

type dw_refptxtrazo_esc from datawindow within w_administracion_trazos_escala
integer x = 357
integer y = 1036
integer width = 1093
integer height = 292
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_ins_refptxtrazo_esc"
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_tallasxtrazo_esc from datawindow within w_administracion_trazos_escala
integer x = 1490
integer y = 944
integer width = 581
integer height = 536
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "dtb_ins_tallasxtrazo_esc"
boolean vscrollbar = true
boolean livescroll = true
end type

