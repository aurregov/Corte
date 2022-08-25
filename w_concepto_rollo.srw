HA$PBExportHeader$w_concepto_rollo.srw
forward
global type w_concepto_rollo from window
end type
type st_2 from statictext within w_concepto_rollo
end type
type st_1 from statictext within w_concepto_rollo
end type
type dw_lista from datawindow within w_concepto_rollo
end type
type gb_1 from groupbox within w_concepto_rollo
end type
end forward

global type w_concepto_rollo from window
integer width = 3543
integer height = 2168
boolean titlebar = true
string title = "Detelle por proceso"
string menuname = "m_vista_previa"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
event ue_imprimir ( )
st_2 st_2
st_1 st_1
dw_lista dw_lista
gb_1 gb_1
end type
global w_concepto_rollo w_concepto_rollo

event ue_imprimir();dw_lista.setFocus()
OpenWithParm(w_opciones_impresion, dw_lista)

end event

on w_concepto_rollo.create
if this.MenuName = "m_vista_previa" then this.MenuID = create m_vista_previa
this.st_2=create st_2
this.st_1=create st_1
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.st_2,&
this.st_1,&
this.dw_lista,&
this.gb_1}
end on

on w_concepto_rollo.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;Long  li_centro
String	ls_de_centro
s_base_parametros lstr_parametros

This.Width =  3506
This.Height = 2100

lstr_parametros = Message.PowerObjectParm	
li_centro = lstr_parametros.entero[1]
ls_de_centro = lstr_parametros.cadena[1]

dw_lista.SetTransObject(sqlca)
dw_lista.Retrieve(li_centro,ls_de_centro)

end event

event closequery;DISCONNECT;
SQLCA.Lock = "CURSOR STABILITY"
CONNECT USING SQLCA;
end event

type st_2 from statictext within w_concepto_rollo
integer x = 32
integer y = 1880
integer width = 1431
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clic derecho en el concepto, para ver el nombre del responsable"
boolean focusrectangle = false
end type

type st_1 from statictext within w_concepto_rollo
integer x = 32
integer y = 1816
integer width = 2149
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dobleclic en el concepto resaltado, para ver el detalle de las telas que no permiten liberar a corte."
boolean focusrectangle = false
end type

type dw_lista from datawindow within w_concepto_rollo
integer x = 50
integer y = 60
integer width = 3406
integer height = 1720
integer taborder = 10
string title = "none"
string dataobject = "dtb_concepto_rollo"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;String ls_concepto
Long li_result, li_concepto
s_base_parametros lstr_parametros
n_cst_reporte_centro_15 luo_reporte

//para mostrar ventana de espera  
s_base_parametros lstr_parametros_retro
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando los datos..."
lstr_parametros_retro.cadena[3]="reloj"
 


ls_concepto = dw_lista.GetItemString(Row,'m_cpto_bodega_de_cpto_bodega')
		

li_result = MessageBox('Advertencia', 'Desea consultar el detalle para el concepto: '+ls_concepto, Exclamation!, OKCancel!, 2)

IF li_result = 1 THEN
	OpenWithParm(w_retroalimentacion,lstr_parametros_retro)
	li_concepto = dw_lista.GetItemNumber(Row,'m_cpto_bodega_co_cpto_bodega')
	//se invoca el user obeject para cargar tabla temporal y mostrar el reporte.
	If li_concepto = 67 Then
		If luo_reporte.of_conceptos_nivel_tintoreria(li_concepto) = 0 Then
			//abrimos ventana mostrando los datos de la tabla mv_centro15_nivel2
			lstr_parametros.entero[1] = li_concepto
			lstr_parametros.entero[2] = 1
			lstr_parametros.cadena[1] = ls_concepto
			OpenSheetWithParm ( w_concepto_centro15_nivel2, lstr_parametros, parent)
		End if
	Else
		IF li_concepto = 73 THEN
			If luo_reporte.f_complemento_compras(li_concepto) = 0 Then
			//abrimos ventana mostrando los datos de la tabla mv_centro15_nivel2
				lstr_parametros.entero[1] = li_concepto
				lstr_parametros.entero[2] = 1
				lstr_parametros.cadena[1] = ls_concepto
				OpenSheetWithParm ( w_concepto_centro15_nivel2, lstr_parametros, parent)
			End if
		ELSE
			lstr_parametros.entero[1] = li_concepto
			lstr_parametros.entero[2] = 2
			lstr_parametros.cadena[1] = ls_concepto
			OpenSheetWithParm ( w_concepto_centro15_nivel2, lstr_parametros, parent)
		END IF
	END IF
END IF

CLOSE(w_retroalimentacion)
end event

event retrieveend;LONG	ll_unidades, tot_unidades
Long	li_cpto, li_fab, li_lin, li_fila, li_tot_fila
DECIMAL	ld_kg,ld_unid_x_kg

li_tot_fila =  dw_lista.RowCount()

FOR li_fila = 1 TO li_tot_fila

	li_cpto = dw_lista.GetItemNumber(li_fila, "m_cpto_bodega_co_cpto_bodega")
	
	tot_unidades = 0
	ll_unidades = 0
	
	DECLARE fichos CURSOR FOR
	 SELECT h.co_fabrica, h.co_linea, sum(m.ca_kg)
     FROM m_rollo m, h_ordenpd_pt h
    WHERE m.cs_orden_pr_act = h.cs_ordenpd_pt
      AND m.co_centro = 15
      AND m.co_planeador = :li_cpto
		AND ca_kg > 0
    GROUP BY 1,2;
	OPEN fichos;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al empezar proceso de c$$HEX1$$e100$$ENDHEX$$lculo de unidades segun kilos, intente de nuevo en unos segundos")
		Return(1)
	END IF
	FETCH fichos INTO :li_fab, :li_lin, :ld_kg ;
	IF SQLCA.SQLCode = -1 THEN
		MessageBox("Error Base Datos","Error al leer el primer registro en proceso de c$$HEX1$$e100$$ENDHEX$$lculo de unidades segun kilos, intente de nuevo en unos segundos")
		Return(1)
	END IF
	DO WHILE SQLCA.SQLCode = 0
		
	 SELECT MAX(unid_kg)
     INTO :ld_unid_x_kg
     FROM m_lineas_agrup
    WHERE co_fabrica = :li_fab
      AND co_linea_agrup = :li_lin;
   IF IsNULL(ld_unid_x_kg) OR (ld_unid_x_kg  = 0) THEN
		messagebox('error','linea sin unidades x kilo: ' + string(li_lin) + ' Fabrica: ' + string(li_fab))
   ELSE
      ll_unidades = ld_kg * ld_unid_x_kg;
      tot_unidades = tot_unidades + ll_unidades;
   END IF

	FETCH fichos INTO :li_fab, :li_lin, :ld_kg ;
		IF SQLCA.SQLCode = -1 THEN
			MessageBox("Error Base Datos","Error al leer registro en proceso de c$$HEX1$$e100$$ENDHEX$$lculo de unidades segun kilos, intente de nuevo en unos segundos")
			Return(1)
		END IF		
	LOOP
	CLOSE fichos;
	dw_lista.SetItem(li_fila, "Unidades", tot_unidades)

NEXT
end event

event rbuttondown;//evento para mostrar el reponsable del concepto en el cual se dio clic derecho
String ls_concepto, ls_responsable, ls_usuario

ls_concepto = This.GetItemString(Row,'m_cpto_bodega_de_cpto_bodega')
ls_responsable = This.GetItemString(Row,'responsable')

SELECT de_usuario
  INTO :ls_usuario
  FROM m_usuario
 WHERE co_usuario = :ls_responsable; 
 

If sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el responsable, ERROR: '+sqlca.SqlErrText)
	Return
End if

If IsNull(ls_usuario) Or ls_usuario = '' Then
	MessageBox('Advertencia','El concepto: '+Trim(ls_concepto)+' no tiene asignado responsable.')
	Return
Else
	MessageBox('',Trim(ls_usuario)+' Es el responsable del concepto: '+Trim(ls_concepto))
End if


end event

type gb_1 from groupbox within w_concepto_rollo
integer x = 27
integer y = 8
integer width = 3456
integer height = 1796
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

