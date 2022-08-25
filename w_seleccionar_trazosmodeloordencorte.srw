HA$PBExportHeader$w_seleccionar_trazosmodeloordencorte.srw
forward
global type w_seleccionar_trazosmodeloordencorte from w_base_buscar_lista
end type
type dw_tallas from datawindow within w_seleccionar_trazosmodeloordencorte
end type
end forward

global type w_seleccionar_trazosmodeloordencorte from w_base_buscar_lista
integer width = 2222
integer height = 1312
string title = "Seleccione un TRAZO para el MODELO"
boolean controlmenu = true
dw_tallas dw_tallas
end type
global w_seleccionar_trazosmodeloordencorte w_seleccionar_trazosmodeloordencorte

type variables
LONG	il_trazo_espacio, il_referencia_esp
Long	il_linea_esp, il_fabrica_esp
end variables

forward prototypes
private function long wf_validar_propor_trazo (long ai_fabrica, long ai_linea, long al_referencia, long al_trazo)
end prototypes

private function long wf_validar_propor_trazo (long ai_fabrica, long ai_linea, long al_referencia, long al_trazo);Long  li_tallas_espacio, li_tallas_ingresa, li_paq_espacio, li_paq_ingresa
Long	li_talla_espa, li_paq_espa, li_paq_trazo_sel


//Primero validamos contando que tengan la misma cantidad de tallas los dos trazos
SELECT count(*)
  INTO :li_tallas_espacio
  FROM dt_tallasxtrazo
 WHERE co_trazo = :il_trazo_espacio
   AND co_fabrica = :il_fabrica_esp
   AND co_linea = :il_linea_esp
   AND co_referencia = :il_referencia_esp;
IF li_tallas_espacio > 0 THEN
	SELECT count(*)
     INTO :li_tallas_ingresa
     FROM dt_tallasxtrazo
    WHERE co_trazo = :al_trazo
      AND co_fabrica = :ai_fabrica
      AND co_linea = :ai_linea
      AND co_referencia = :al_referencia;
	If li_tallas_espacio	 = li_tallas_ingresa THEN
	ELSE
		MessageBox('Advertencia','El trazo Seleccionado no tiene las mismas tallas del trazo del espacio')
		Return 0;
	END IF
END IF
	
//Luego validamos que tengan el mismo total de paquetes los dos trazos
SELECT sum(ca_paquetes)
  INTO :li_paq_espacio
  FROM dt_tallasxtrazo
 WHERE co_trazo = :il_trazo_espacio
   AND co_fabrica = :il_fabrica_esp
   AND co_linea = :il_linea_esp
   AND co_referencia = :il_referencia_esp;
IF li_tallas_espacio > 0 THEN
	SELECT  sum(ca_paquetes)
     INTO :li_paq_ingresa
     FROM dt_tallasxtrazo
    WHERE co_trazo = :al_trazo
      AND co_fabrica = :ai_fabrica
      AND co_linea = :ai_linea
      AND co_referencia = :al_referencia;
	IF li_paq_espacio	 = li_paq_ingresa THEN
	ELSE
		MessageBox('Advertencia','El trazo Seleccionado no tiene los mismas paquetes totales que el trazo del espacio')
		Return 0;
	END IF
END IF

//Ahora validamos que los paquetes en cada talla sean los mismos
DECLARE cur_trazos_espa CURSOR FOR  //cursor con los datos del espacio
	SELECT co_talla, ca_paquetes
	FROM	dt_tallasxtrazo
	WHERE co_trazo = :il_trazo_espacio
	  AND co_fabrica = :il_fabrica_esp
	  AND co_linea = :il_linea_esp
	  AND co_referencia = :il_referencia_esp
	ORDER BY 1;
	OPEN cur_trazos_espa;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al abrir el cursor de los modelos")
		Return 0
	END IF
	
	FETCH cur_trazos_espa INTO :li_talla_espa, :li_paq_espa;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer el primer registro del cursor")
		Return 0
	END IF
	DO WHILE SQLCA.SQLCode = 0
	
		SELECT ca_paquetes
		  INTO :li_paq_trazo_sel
		  FROM dt_tallasxtrazo
		  WHERE co_trazo = :al_trazo
		    AND co_fabrica = :ai_fabrica
		    AND co_linea = :ai_linea
		    AND co_referencia = :al_referencia
			 AND co_talla = :li_talla_espa;
		IF li_paq_trazo_sel <> li_paq_espa  THEN
			MessageBox("Advertencia","El trazo en la talla: " + string(li_talla_espa)+ " tiene diferentes paquetes al trazo del espacio " + string(li_paq_trazo_sel)+ string(li_paq_espa) )
			Return 0
		END IF
		
	
		FETCH cur_trazos_espa INTO :li_talla_espa, :li_paq_espa;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer el siguiente registro del cursor")
			Return 0
		END IF		
	LOOP
	CLOSE cur_trazos_espa;

Return 1;
end function

event open;Long  li_modelo
Long	ll_cotrazo
Long 	ll_numero_registros
s_base_parametros_seleccionar lstr_parametros

lstr_parametros 	= 	Message.PowerObjectParm
il_fabrica_esp 	= 	lstr_parametros.entero1[1]
il_linea_esp		= 	lstr_parametros.entero1[2]
il_referencia_esp	= 	lstr_parametros.entero1[3]
il_trazo_espacio	= 	lstr_parametros.entero1[4]

IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	IF dw_tallas.settransobject(SQLCA)= -1 THEN
		messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
	ELSE
		ll_numero_registros = dw_lista.retrieve(il_fabrica_esp, il_linea_esp, il_referencia_esp)
		CHOOSE CASE ll_numero_registros 
			CASE -1
				MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
				Return
			CASE 0
				il_fila_actual = 0
	//			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
			CASE ELSE
				il_fila_actual = 1
				ll_cotrazo	= dw_lista.GetItemNumber(il_fila_actual, "co_trazo")
				dw_tallas.retrieve(ll_cotrazo, il_fabrica_esp, il_linea_esp, il_referencia_esp)
				
		END CHOOSE
	END IF
END IF

dw_lista.modify("dw_lista.readonly=yes")
dw_tallas.modify("dw_lista.readonly=yes")
dw_lista.setfocus()

end event

on w_seleccionar_trazosmodeloordencorte.create
int iCurrent
call super::create
this.dw_tallas=create dw_tallas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_tallas
end on

on w_seleccionar_trazosmodeloordencorte.destroy
call super::destroy
destroy(this.dw_tallas)
end on

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_trazosmodeloordencorte
boolean visible = false
integer x = 18
integer y = 1096
integer width = 1701
long backcolor = 12632256
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_trazosmodeloordencorte
integer x = 1760
integer y = 1056
integer width = 375
integer height = 132
integer textsize = -8
fontcharset fontcharset = defaultcharset!
string picturename = "cancelar.bmp"
end type

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_trazosmodeloordencorte
integer x = 1367
integer y = 1056
integer width = 375
integer height = 132
integer taborder = 20
integer textsize = -8
fontcharset fontcharset = defaultcharset!
string picturename = "ok.bmp"
end type

event pb_aceptar::clicked;call super::clicked;s_base_parametros lstr_parametros
LONG	ll_trazo_ing,  ll_referencia_ing
Long	li_linea_ing, li_fabrica_ing

IF il_fila_actual > 0 THEN
	//Validar que el trazo seleccionado tenga la misma proporcion del trazo del espacio
	li_fabrica_ing	= dw_lista.GetItemNumber(il_fila_actual, "co_fabrica")
	li_linea_ing	= dw_lista.GetItemNumber(il_fila_actual, "co_linea")
	ll_referencia_ing	= dw_lista.GetItemNumber(il_fila_actual, "co_referencia")
	ll_trazo_ing	= dw_lista.GetItemNumber(il_fila_actual, "co_trazo")

	IF wf_validar_propor_trazo(li_fabrica_ing, li_linea_ing, ll_referencia_ing, ll_trazo_ing) = 1 THEN
		lstr_parametros.hay_parametros = TRUE
		lstr_parametros.entero[1]	= dw_lista.GetItemNumber(il_fila_actual, "co_trazo")
		lstr_parametros.decimal[1]	= dw_lista.GetItemNumber(il_fila_actual, "h_trazos_porc_util")
		closewithreturn(parent,lstr_parametros)
	ELSE
//		lstr_parametros.hay_parametros = FALSE
//		CloseWithReturn(parent,lstr_parametros)
	END IF
END IF



end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_trazosmodeloordencorte
integer x = 18
integer y = 12
integer width = 1701
integer height = 1036
integer taborder = 10
string dataobject = "dtb_seleccionar_trazosmodeloordencorte"
boolean hsplitscroll = true
end type

event dw_lista::rowfocuschanged;call super::rowfocuschanged;Long li_fabrica, li_linea
Long ll_cotrazo, ll_referencia

IF CurrentRow > 0 THEN
	il_fila_actual = CurrentRow
	ll_cotrazo	= dw_lista.GetItemNumber(il_fila_actual, "co_trazo")
	li_fabrica = dw_lista.GetItemNumber(il_fila_actual, "co_fabrica")
	li_linea = dw_lista.GetItemNumber(il_fila_actual, "co_linea")
	ll_referencia = dw_lista.GetItemNumber(il_fila_actual, "co_referencia")
	dw_tallas.retrieve(ll_cotrazo, li_fabrica, li_linea, ll_referencia)
END IF

end event

type dw_tallas from datawindow within w_seleccionar_trazosmodeloordencorte
integer x = 1737
integer y = 8
integer width = 462
integer height = 992
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Tallas Trazo..."
string dataobject = "dtb_detalle_tallasxtrazo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

