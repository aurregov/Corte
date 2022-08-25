HA$PBExportHeader$w_buscar_log_pdnxmodulo.srw
forward
global type w_buscar_log_pdnxmodulo from window
end type
type pb_1 from picturebutton within w_buscar_log_pdnxmodulo
end type
type cb_3 from commandbutton within w_buscar_log_pdnxmodulo
end type
type cb_2 from commandbutton within w_buscar_log_pdnxmodulo
end type
type cb_1 from commandbutton within w_buscar_log_pdnxmodulo
end type
type dw_lista from datawindow within w_buscar_log_pdnxmodulo
end type
type dw_criterio from datawindow within w_buscar_log_pdnxmodulo
end type
type gb_1 from groupbox within w_buscar_log_pdnxmodulo
end type
type gb_2 from groupbox within w_buscar_log_pdnxmodulo
end type
end forward

global type w_buscar_log_pdnxmodulo from window
integer width = 4050
integer height = 1732
boolean titlebar = true
string title = "Buscar LOG"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "C:\graficos\movimientos_proceso.ico"
pb_1 pb_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_lista dw_lista
dw_criterio dw_criterio
gb_1 gb_1
gb_2 gb_2
end type
global w_buscar_log_pdnxmodulo w_buscar_log_pdnxmodulo

type variables
String is_sql
datawindowchild idw_planta,idw_linea,idw_referencia

end variables

forward prototypes
public subroutine wf_tiempo ()
public function string wf_query (string as_feld)
public function string wf_consultar ()
end prototypes

public subroutine wf_tiempo ();LONG ll_i,ll_referencia,ll_ordencorte
Long li_linea,li_planta,li_linea2,li_fabrica,li_fabrica2
DECIMAL ldc_tiempo_std
s_base_parametros lstr_parametros

SetPointer(HourGlass!)

dw_lista.AcceptText()

lstr_parametros.cadena[1]="Procesando..."
lstr_parametros.cadena[2]="El sistema esta verificando los tiempos estandar de las referencias, esta operaci$$HEX1$$f300$$ENDHEX$$n puede demorar unos segundos, espere un momento por favor..."
lstr_parametros.cadena[3]="reloj"	
	
OpenWithParm(w_retroalimentacion,lstr_parametros)

FOR ll_i = 1 TO dw_lista.RowCount()
	ll_referencia = dw_lista.GetItemNumber(ll_i,'co_referencia')
	ll_ordencorte = dw_lista.GetItemNumber(ll_i,'cs_ordencorte')
	li_fabrica = dw_lista.GetItemNumber(ll_i,'co_fabrica')
	li_linea = dw_lista.GetItemNumber(ll_i,'co_linea')
	li_planta = dw_lista.GetItemNumber(ll_i,'co_planta')
	
	SELECT DISTINCT co_fabrica, co_linea
	INTO :li_fabrica2, :li_linea2
	FROM dt_total_ordcr
	WHERE co_referencia = :ll_referencia AND
			cs_orden_corte = :ll_ordencorte;
	
	IF SQLCA.SqlCode = -1 OR SQLCA.SqlCode = 100 THEN
		li_fabrica2 = li_fabrica
		li_linea2 = li_linea
	END IF
		
	SELECT sum(m_estandares.tiempo_st)
	  INTO :ldc_tiempo_std
	  FROM m_estandares
	 WHERE m_estandares.co_fabrica = :li_fabrica2 AND
			 m_estandares.co_planta = :li_planta AND
			 m_estandares.co_linea = :li_linea2 AND
			 m_estandares.co_referencia = :ll_referencia AND
			 m_estandares.co_centro_pdn = 2 AND
			 m_estandares.co_subcentro_pdn = 2;
	IF isnull(ldc_tiempo_std) OR ldc_tiempo_std = 0 THEN
		dw_lista.SelectRow(ll_i,TRUE)
	END IF
	
NEXT

CLOSE(w_retroalimentacion)
end subroutine

public function string wf_query (string as_feld);STRING ls_where
DATE   ld_fecha,ld_fecha_1

CHOOSE CASE as_feld
	CASE 'simulacion'
		ls_where = "( mv_log_pdxmoduloup.simulacion ="+ String(dw_criterio.GetItemNumber(1,"simulacion"))+")"
	CASE 'co_fabrica'
		ls_where = "( mv_log_pdxmoduloup.co_fabrica ="+ String(dw_criterio.GetItemNumber(1,"co_fabrica"))+")"
	CASE 'co_planta'
		ls_where = "( mv_log_pdxmoduloup.co_planta ="+ String(dw_criterio.GetItemNumber(1,"co_planta"))+")"
	CASE 'co_modulo'
		ls_where = "( mv_log_pdxmoduloup.co_modulo ="+ String(dw_criterio.GetItemNumber(1,"co_modulo"))+")"
	CASE 'co_fabrica_exp'
		ls_where = "( mv_log_pdxmoduloup.co_fabrica_exp ="+ String(dw_criterio.GetItemNumber(1,"co_fabrica_exp"))+")"
	CASE 'pedido'
		ls_where = "( mv_log_pdxmoduloup.pedido ="+ String(dw_criterio.GetItemNumber(1,"pedido"))+")"
	CASE 'cs_liberacion'
		ls_where = "( mv_log_pdxmoduloup.cs_liberacion ="+ String(dw_criterio.GetItemNumber(1,"cs_liberacion"))+")"
	CASE 'po'
		ls_where = "( mv_log_pdxmoduloup.po like '%"+Trim(dw_criterio.GetItemString(1,"po"))+"%' )"
	CASE 'co_fabrica_pt'
		ls_where = "( mv_log_pdxmoduloup.co_fabrica_pt ="+ String(dw_criterio.GetItemNumber(1,"co_fabrica_pt"))+")"
	CASE 'co_linea'
		ls_where = "( mv_log_pdxmoduloup.co_linea ="+ String(dw_criterio.GetItemNumber(1,"co_linea"))+")"
	CASE 'co_referencia'
		ls_where = "( mv_log_pdxmoduloup.co_referencia ="+ String(dw_criterio.GetItemNumber(1,"co_referencia"))+")"
	CASE 'co_color_pt'
		ls_where = "( mv_log_pdxmoduloup.co_color_pt ="+ String(dw_criterio.GetItemNumber(1,"co_color_pt"))+")"
	CASE 'tono'
		ls_where = "( mv_log_pdxmoduloup.tono like '%"+Trim(dw_criterio.GetItemString(1,"tono"))+"%' )"
	CASE 'cs_estilocolortono'
		ls_where = "( mv_log_pdxmoduloup.cs_estilocolortono ="+ String(dw_criterio.GetItemNumber(1,"cs_estilocolortono"))+")"
	CASE 'cs_particion'
		ls_where = "( mv_log_pdxmoduloup.cs_particion ="+ String(dw_criterio.GetItemNumber(1,"cs_particion"))+")"
	CASE 'fe_movimiento_1'
		ld_fecha = dw_criterio.GetItemDate(1,"fe_movimiento")
		ld_fecha_1 = dw_criterio.GetItemDate(1,"fe_movimiento_1")
		ls_where = "( mv_log_pdxmoduloup.fe_movimiento between DATETIME ("+String(Year(ld_fecha))+"-"+String(Month(ld_fecha))+"-"+String(Day(ld_fecha))+ " and "+String(Year(ld_fecha_1))+"-"+String(Month(ld_fecha_1))+"-"+String(Day(ld_fecha_1))+ ") YEAR TO DAY  )"


END CHOOSE

RETURN ls_where
end function

public function string wf_consultar ();dwItemStatus ldws_status
STRING   ls_object,ls_rest,ls_fieldmod,ls_where = ''
Long  il_pos

dw_criterio.AcceptText()

ls_object = dw_criterio.DESCRIBE("DataWindow.Objects")

DO
	il_pos = Pos(ls_object, '~t')
	IF il_pos = 0 THEN					
		ls_rest = ls_object				
		ls_object = ""					
	ELSE
		ls_rest = Mid(ls_object, 1, il_pos - 1)	
		ls_object = Right(ls_object, Len(ls_object) - il_pos)	
	END IF
	IF ls_rest <> '' AND  Right(ls_rest,2) <> '_t' THEN
		ldws_status = dw_criterio.GetItemStatus(1,ls_rest,Primary!) 
		IF ldws_status = DataModified! THEN
			ls_fieldmod = wf_query (ls_rest)
			IF ls_fieldmod <> '' THEN ls_where += ls_fieldmod  + " AND "
		END IF
	END IF
LOOP WHILE ls_rest <> ''

IF ls_where <> '' THEN ls_where = Mid(ls_where,1,Len(ls_where) -5)

RETURN ls_where
end function

on w_buscar_log_pdnxmodulo.create
this.pb_1=create pb_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_lista=create dw_lista
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.pb_1,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_lista,&
this.dw_criterio,&
this.gb_1,&
this.gb_2}
end on

on w_buscar_log_pdnxmodulo.destroy
destroy(this.pb_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_lista)
destroy(this.dw_criterio)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;STRING ls_sintaxis

THIS.X = 1
THIS.Y = 1
THIS.Width = 4050
THIS.Height = 1732
//Environment le_even
//
//IF GetEnvironment ( le_even ) <> 1 THEN 
//ELSE
////	w_buscar_canasta_argumento.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - w_buscar_canasta_argumento.width) / 2
////	w_buscar_canasta_argumento.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - w_buscar_canasta_argumento.Height) / 2
//END IF

dw_criterio.GetChild('co_planta',idw_planta)
dw_criterio.GetChild('co_linea',idw_linea)
dw_criterio.GetChild('co_referencia',idw_referencia)

dw_lista.SetTransObject(SQLCA)
dw_criterio.SetTransObject(SQLCA)
idw_planta.SetTransObject(SQLCA)
idw_linea.SetTransObject(SQLCA)
idw_referencia.SetTransObject(SQLCA)

idw_planta.Retrieve(2)
idw_linea.Retrieve(2)
idw_referencia.Retrieve(2,1)
dw_criterio.InsertRow(0)

//dw_criterio.SetItem(1,'co_fabrica',2)
//dw_criterio.SetItem(1,'co_planta',1)
//dw_criterio.SetItem(1,'co_linea',1)
//
is_sql = dw_lista.GetSqlSelect()
ls_sintaxis = is_sql

//IF len(gs_canasta) > 0 THEN
//	dw_lista.SetSqlSelect(gs_canasta)
//	dw_lista.Retrieve()
//	wf_tiempo()
//END IF


end event

type pb_1 from picturebutton within w_buscar_log_pdnxmodulo
integer x = 837
integer y = 56
integer width = 123
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\graficos\Borrar.bmp"
alignment htextalign = left!
end type

event clicked;dw_criterio.Reset()
dw_criterio.InsertRow(0)
end event

type cb_3 from commandbutton within w_buscar_log_pdnxmodulo
integer x = 617
integer y = 1512
integer width = 242
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE

CloseWithReturn(PARENT,lstr_parametros)


end event

type cb_2 from commandbutton within w_buscar_log_pdnxmodulo
integer x = 325
integer y = 1512
integer width = 242
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;LONG ll_fila,ll_secuencia,ll_referencia,ll_ordencorte
Long li_fabrica,li_planta,li_linea,li_secuencia
STRING ls_canasta,ls_estado
s_base_parametros lstr_parametros

//lstr_parametros.hay_parametros = FALSE
//ll_fila = dw_lista.GetRow()
//
//IF dw_lista.IsSelected (ll_fila) = FALSE THEN
//	IF ll_fila > 0 THEN
//		lstr_parametros.hay_parametros = TRUE
//		ls_canasta = dw_lista.GetItemString(ll_fila,'cs_canasta')
//		li_fabrica = dw_lista.GetItemNumber(ll_fila,'co_fabrica')
//		li_planta = dw_lista.GetItemNumber(ll_fila,'co_planta')
//		li_linea = dw_lista.GetItemNumber(ll_fila,'co_linea')
//		ll_referencia = dw_lista.GetItemNumber(ll_fila,'co_referencia')
//		ll_ordencorte = dw_lista.GetItemNumber(ll_fila,'cs_ordencorte')
//		li_secuencia = dw_lista.GetItemNumber(ll_fila,'secuencia')
//		ls_estado = dw_lista.GetItemString(ll_fila,'estado')
//		lstr_parametros.cadena[1] = ls_canasta
//		lstr_parametros.entero[2] = li_fabrica
//		lstr_parametros.entero[3] = li_planta
//		lstr_parametros.entero[4] = li_linea
//		lstr_parametros.entero[5] = ll_referencia
//		lstr_parametros.entero[6] = ll_ordencorte
//		lstr_parametros.entero[7] = li_secuencia
//		lstr_parametros.cadena[2] = ls_estado
//	END IF
//	CloseWithReturn(PARENT,lstr_parametros)
//END IF
end event

type cb_1 from commandbutton within w_buscar_log_pdnxmodulo
integer x = 46
integer y = 1512
integer width = 242
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
boolean default = true
end type

event clicked;STRING ls_where,ls_sintaxis
LONG ll_step, ll_max,ll_marca,ll_i,ll_referencia,ll_ordencorte,ll_fabrica2,ll_fabrica
Long li_linea2,li_linea,li_planta
DECIMAL ldc_tiempo_std

dw_criterio.AcceptText()

ls_sintaxis = is_sql
ls_where = wf_consultar()

IF ls_where <> "" THEN 
	ls_sintaxis += " and " + ls_where
END IF

//gs_canasta = ls_sintaxis
dw_lista.SetSqlSelect(ls_sintaxis)
dw_lista.Retrieve()

IF dw_lista.RowCount() = 0 THEN
	MessageBox('Advertencia','No existen LOG que cumplan con el criterio de busqueda')
	ll_marca = 1
END IF

idw_planta.Retrieve(2)
idw_linea.Retrieve(2)


IF ll_marca = 1 THEN 
ELSE
	dw_criterio.Reset()
	dw_criterio.InsertRow(0)
END IF

//para deshabilitar la fila si no tiene  tiempo estandar
//wf_tiempo()




end event

type dw_lista from datawindow within w_buscar_log_pdnxmodulo
integer x = 1019
integer y = 60
integer width = 2971
integer height = 1520
integer taborder = 20
string title = "none"
string dataobject = "dtb_r_log_pdnxmodulo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//If Row <= 0 Then Return
//
//This.SelectRow(0,False)
//This.SelectRow(Row,True)
end event

event doubleclicked;If Row <= 0 Then Return

//This.SelectRow(0,False)
//This.SelectRow(Row,True)

IF isSelected (row) = TRUE THEN
ELSE
	cb_2.TriggerEvent(Clicked!)
END IF
end event

type dw_criterio from datawindow within w_buscar_log_pdnxmodulo
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 140
integer width = 928
integer height = 1316
integer taborder = 10
string title = "none"
string dataobject = "dff_parametros_log_pdnxmodulo"
boolean border = false
boolean livescroll = true
end type

event ue_enter;IF This.AcceptText() = 1 Then
	Send(Handle(this),256,9,Long(0,0))
	Return 0
Else
	Return -1
End If
end event

event itemchanged;LONG ll_fabrica,ll_planta,ll_linea,ll_talla,ll_talla2,ll_color,ll_color2
STRING ls_planta,ls_linea,ls_referencia
LONG ll_referencia

THIS.AcceptText()

CHOOSE CASE GetColumnName()
			
	CASE 'co_fabrica'
		ll_fabrica = dw_criterio.GetItemNumber(1,'co_fabrica')
		ll_linea = dw_criterio.GetItemNumber(1,'co_linea')
		
		IF isnull(ll_linea) THEN ll_linea = 1
		
		idw_planta.Retrieve(ll_fabrica)
		idw_linea.Retrieve(ll_fabrica)
		idw_referencia.Retrieve(ll_fabrica,ll_linea)
		
		
	CASE 'co_linea'
		ll_fabrica = dw_criterio.GetItemNumber(1,'co_fabrica')
		ll_linea = dw_criterio.GetItemNumber(1,'co_linea')
		
		IF isnull(ll_fabrica) THEN ll_fabrica = 2
		
		idw_referencia.Retrieve(ll_fabrica,ll_linea)
			
			
	CASE 'co_talla'
		ll_referencia = dw_criterio.GetItemNumber(1,'co_referencia')
		ll_talla = dw_criterio.GetItemNumber(1,'co_talla')
		
		IF isnull(ll_referencia) THEN
		ELSE
			SELECT DISTINCT co_talla 
			INTO :ll_talla2
			FROM dt_preref
			WHERE co_referencia = :ll_referencia AND
					co_talla = :ll_talla;
					
			IF SQLCA.SqlCode = -1 THEN
				MessageBox('Advertencia','Ocurrio un error al momento de buscar la talla dentro de la referencia')
			END IF
			
			IF SQLCA.SqlCode = 100 THEN
				MessageBox('Advertencia','La talla no corresponde a ninguna matriculada para la referencia')
			END IF
			
		END IF
		
		
	CASE 'co_color'
		ll_referencia = dw_criterio.GetItemNumber(1,'co_referencia')
		ll_color = dw_criterio.GetItemNumber(1,'co_color')
		
		IF isnull(ll_referencia) THEN
		ELSE
			SELECT DISTINCT co_color
			INTO :ll_color2
			FROM dt_ref_x_col
			WHERE co_referencia = :ll_referencia AND
					co_color = :ll_color;
					
			IF SQLCA.SqlCode = -1 THEN
				MessageBox('Advertencia','Ocurrio un error al momento de buscar el color dentro de la referencia')
			END IF
			
			IF SQLCA.SqlCode = 100 THEN
				MessageBox('Advertencia','El color no corresponde a ninguno matriculado para la referencia')
			END IF
			
		END IF
			
	
END CHOOSE

end event

type gb_1 from groupbox within w_buscar_log_pdnxmodulo
integer x = 27
integer y = 20
integer width = 965
integer height = 1448
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 16711680
long backcolor = 67108864
string text = "Criterio de Busqueda"
end type

type gb_2 from groupbox within w_buscar_log_pdnxmodulo
integer x = 992
integer y = 20
integer width = 3035
integer height = 1584
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

