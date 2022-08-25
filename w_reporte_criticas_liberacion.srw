HA$PBExportHeader$w_reporte_criticas_liberacion.srw
forward
global type w_reporte_criticas_liberacion from w_preview_de_impresion
end type
type sle_ano from singlelineedit within w_reporte_criticas_liberacion
end type
type sle_semana from singlelineedit within w_reporte_criticas_liberacion
end type
type st_1 from statictext within w_reporte_criticas_liberacion
end type
type st_2 from statictext within w_reporte_criticas_liberacion
end type
type cb_recuperar from commandbutton within w_reporte_criticas_liberacion
end type
type cb_1 from commandbutton within w_reporte_criticas_liberacion
end type
type st_3 from statictext within w_reporte_criticas_liberacion
end type
type em_clasifica from editmask within w_reporte_criticas_liberacion
end type
type st_4 from statictext within w_reporte_criticas_liberacion
end type
type em_filtro from editmask within w_reporte_criticas_liberacion
end type
type cb_2 from commandbutton within w_reporte_criticas_liberacion
end type
type st_5 from statictext within w_reporte_criticas_liberacion
end type
type st_6 from statictext within w_reporte_criticas_liberacion
end type
type st_7 from statictext within w_reporte_criticas_liberacion
end type
type cb_3 from commandbutton within w_reporte_criticas_liberacion
end type
type st_8 from statictext within w_reporte_criticas_liberacion
end type
end forward

global type w_reporte_criticas_liberacion from w_preview_de_impresion
integer width = 4617
integer height = 2560
string title = "Produccion a Liberar"
sle_ano sle_ano
sle_semana sle_semana
st_1 st_1
st_2 st_2
cb_recuperar cb_recuperar
cb_1 cb_1
st_3 st_3
em_clasifica em_clasifica
st_4 st_4
em_filtro em_filtro
cb_2 cb_2
st_5 st_5
st_6 st_6
st_7 st_7
cb_3 cb_3
st_8 st_8
end type
global w_reporte_criticas_liberacion w_reporte_criticas_liberacion

type variables
boolean ib_agrupar
Long	ii_ano, ii_semana
s_base_parametros  istr_param
cst_adm_conexion icst_lectura
end variables

event open;This.x = 1
This.y = 1
s_base_parametros lstr_parametros

icst_lectura = create  cst_adm_conexion

dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
n_cts_liberacion_semiautomatica luo_critica
Long li_semana, li_ano
String ls_clasifica

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")

ib_agrupar = True
//se captura la semana y el a$$HEX1$$f100$$ENDHEX$$o de la critica actual.
//jcrm
//diciembre 21 de 2007
li_ano = luo_critica.of_anocriticas()
li_semana = luo_critica.of_semanacritica(li_ano)

sle_ano.Text = String(li_ano)
sle_semana.Text = String(li_semana) 

//***************************************************************
lstr_parametros = Message.PowerObjectParm	

ii_ano =        Long(sle_ano.Text)
ii_semana = 	 Long(sle_semana.Text)

IF len(trim(em_clasifica.text)) = 0 THEN 
	ls_clasifica = ' ' 
ELSE
	ls_clasifica = string(em_clasifica.text)
END IF


IF IsNull(ii_ano) OR ii_ano = 0 THEN
	MessageBox('Advertencia','A$$HEX1$$f100$$ENDHEX$$o invalido, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',exclamation!)
	Return
END IF

IF IsNull(ii_semana) OR ii_semana = 0 THEN
	MessageBox('Advertencia','Semana invalida, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',exclamation!)
	Return
END IF

dw_reporte.Retrieve(ii_ano,&
						  ii_semana,&
						  ls_clasifica,&
						  lstr_parametros.entero[2],&
						  lstr_parametros.entero[3],&
						  lstr_parametros.entero[4],&
						  lstr_parametros.entero[7],&
						  lstr_parametros.entero[6],&
						  lstr_parametros.entero[9])

IF dw_reporte.RowCount() <= 0 THEN
	MessageBox('Advertencia','No existen datos que satisfagan el criterio de busqueda.',exclamation!)
	Return
END IF


end event

on w_reporte_criticas_liberacion.create
int iCurrent
call super::create
this.sle_ano=create sle_ano
this.sle_semana=create sle_semana
this.st_1=create st_1
this.st_2=create st_2
this.cb_recuperar=create cb_recuperar
this.cb_1=create cb_1
this.st_3=create st_3
this.em_clasifica=create em_clasifica
this.st_4=create st_4
this.em_filtro=create em_filtro
this.cb_2=create cb_2
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.cb_3=create cb_3
this.st_8=create st_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_semana
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_recuperar
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.em_clasifica
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_filtro
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.cb_3
this.Control[iCurrent+16]=this.st_8
end on

on w_reporte_criticas_liberacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_semana)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_recuperar)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.em_clasifica)
destroy(this.st_4)
destroy(this.em_filtro)
destroy(this.cb_2)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.cb_3)
destroy(this.st_8)
end on

event resize;dw_reporte.Resize(This.Width - 100, This.Height - 400)
end event

event closequery;call super::closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_criticas_liberacion
integer y = 220
integer width = 4517
integer height = 2072
string dataobject = "dtb_reporte_criticas_liberacion_rep"
end type

event dw_reporte::doubleclicked;call super::doubleclicked;//evento para mostrar el reporte de las ordenes de corte que se encuentran en inventario en proceso (kamban)
//jcrm
//diicembre 21 de 2007
Long ll_fila, ll_referencia
Long li_fabrica, li_linea
s_base_parametros lstr_parametros

ll_fila = dw_reporte.GetRow()

IF ll_fila > 0 THEN
	li_fabrica 	= dw_reporte.GetItemNumber(ll_fila,'co_fabrica')
	li_linea		= dw_reporte.GetItemNumber(ll_fila,'co_linea')
	ll_referencia = dw_reporte.GetItemNumber(ll_fila,'co_referencia')
	
	lstr_parametros.entero[1] = li_fabrica
	lstr_parametros.entero[2] = li_linea
	lstr_parametros.entero[3] = ll_referencia
	
	
	OpenWithParm ( w_criticas_kamban_corte, lstr_parametros )
	
END IF
end event

event dw_reporte::rbuttondown;Long li_fab, li_lin
Long ll_ref, ll_color
string DWfilter2

li_fab = This.GetItemNumber(row,'co_fabrica')
li_lin = This.GetItemNumber(row,'co_linea')
ll_color = This.GetItemNumber(row,'color')
ll_ref = This.GetItemNumber(row,'co_referencia')

If ib_agrupar = True Then
	DWfilter2 = "co_fabrica = "+String(li_fab)+ " and co_linea = "+String(li_lin)+" and co_referencia = "+String(ll_ref)+&
				   " and color = "+String(ll_color)
	ib_agrupar = False				
Else
	DWfilter2 = ''
	ib_agrupar = True
End if
	
This.SetFilter(DWfilter2)
This.Filter()
This.GroupCalc()
end event

event dw_reporte::clicked;call super::clicked;If Row > 0 Then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
End if
end event

type sle_ano from singlelineedit within w_reporte_criticas_liberacion
integer x = 169
integer y = 32
integer width = 201
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_semana from singlelineedit within w_reporte_criticas_liberacion
integer x = 613
integer y = 32
integer width = 119
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_reporte_criticas_liberacion
integer x = 46
integer y = 32
integer width = 123
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "A$$HEX1$$f100$$ENDHEX$$o:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_reporte_criticas_liberacion
integer x = 398
integer y = 32
integer width = 206
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana:"
boolean focusrectangle = false
end type

type cb_recuperar from commandbutton within w_reporte_criticas_liberacion
integer x = 1326
integer y = 20
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
boolean default = true
end type

event clicked;String	ls_clasifica


ii_ano =        Long(sle_ano.Text)
ii_semana = 	 Long(sle_semana.Text)

IF len(trim(em_clasifica.text)) = 0 THEN 
	ls_clasifica = ' ' 
ELSE
	ls_clasifica = string(em_clasifica.text)
END IF


IF IsNull(ii_ano) OR ii_ano = 0 THEN
	MessageBox('Advertencia','A$$HEX1$$f100$$ENDHEX$$o invalido, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',exclamation!)
	Return
END IF

IF IsNull(ii_semana) OR ii_semana = 0 THEN
	MessageBox('Advertencia','Semana invalida, verifique su informaci$$HEX1$$f300$$ENDHEX$$n.',exclamation!)
	Return
END IF

dw_reporte.Retrieve(ii_ano,ii_semana,ls_clasifica,0,0,0,0,0)

IF dw_reporte.RowCount() <= 0 THEN
	MessageBox('Advdertnecia','No existen datos que satisfagan el criterio de busqueda.',exclamation!)
	Return
END IF

end event

type cb_1 from commandbutton within w_reporte_criticas_liberacion
integer x = 1687
integer y = 20
integer width = 297
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Limpiar"
end type

event clicked;sle_ano.Text = ''
sle_semana.Text = ''
end event

type st_3 from statictext within w_reporte_criticas_liberacion
integer x = 754
integer y = 32
integer width = 302
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clasificacion:"
boolean focusrectangle = false
end type

type em_clasifica from editmask within w_reporte_criticas_liberacion
integer x = 1061
integer y = 32
integer width = 165
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!"
string displaydata = "A~tA/B~tB/C~tC/"
end type

type st_4 from statictext within w_reporte_criticas_liberacion
integer x = 2505
integer y = 64
integer width = 498
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cantidad Color Liberar"
boolean focusrectangle = false
end type

type em_filtro from editmask within w_reporte_criticas_liberacion
integer x = 3013
integer y = 48
integer width = 347
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxx"
end type

type cb_2 from commandbutton within w_reporte_criticas_liberacion
integer x = 3374
integer y = 20
integer width = 210
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;string DWfilter2
	
DWfilter2 = "tot_color "+String(em_filtro.text)
dw_reporte.SetFilter(DWfilter2)
dw_reporte.Filter()
dw_reporte.GroupCalc()

end event

type st_5 from statictext within w_reporte_criticas_liberacion
integer x = 3026
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ej.   > 200"
boolean focusrectangle = false
end type

type st_6 from statictext within w_reporte_criticas_liberacion
integer x = 37
integer y = 108
integer width = 1243
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Doble clic en la referencia muestra las ordenes de corte"
boolean focusrectangle = false
end type

type st_7 from statictext within w_reporte_criticas_liberacion
integer x = 37
integer y = 156
integer width = 1504
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clic derecho en el estilo para mostrar por color / listado original"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_reporte_criticas_liberacion
integer x = 2057
integer y = 20
integer width = 361
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Existencias ..."
end type

event clicked;Long	li_fab, li_lin, li_bodysize, li_talla_pt, li_linea_exp, li_fabrica_exp,li_opcion_liberar, li_result
LONG		ll_ref, ll_unidades, ll_color_pt
STRING	usuario, ls_ref_exp, ls_color_exp
s_base_parametros lstr_parametros, lstr_parametros_retro, lstr_tipo_liberacion
n_cts_liberacion_x_proyeccion   luo_liberacion_x_proyeccion

//para mostrar ventana de espera  
lstr_parametros_retro.cadena[1]="Procesando ..."
lstr_parametros_retro.cadena[2]="Espere un momento por favor, Cargando  datos segun Ficha y Existencia en bodega "
lstr_parametros_retro.cadena[3]="reloj"
OpenWithParm(w_retroalimentacion,lstr_parametros_retro)     

usuario = gstr_info_usuario.codigo_usuario

li_fab = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'co_fabrica')
li_lin = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'co_linea')
ll_ref = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'co_referencia')
ll_color_pt = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'color')
li_talla_pt = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'talla')

//se adiciona que tambien tome los datos de las referencias de ventas
//jcrm
//mayo 20 de 2008
li_fabrica_exp = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'co_fabrica_exp')
li_linea_exp = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'co_linea_exp')
ls_ref_exp = dw_reporte.GetItemString(dw_reporte.GetRow(),'estilo_ventas')
ls_color_exp = dw_reporte.GetItemString(dw_reporte.GetRow(),'co_color_exp')

//se debe verificar si la referencia es duo o conjunto, si es asi, se despliega ventana para escojer tipo de liberacion
//opcion 1 = equilibrar unidades, opcion 2 = cantidades iguales
//jcrm
//agosto 21 de 2008
//si no entra a duos y conjuntos debe llebar como tipo liberacion 1 que es la normal
li_opcion_liberar = 1
li_result = luo_liberacion_x_proyeccion.of_verificar_duo_conjunto(li_fabrica_exp,li_linea_exp,ls_ref_exp,ls_color_exp,ii_ano,ii_semana)
IF  li_result = 1 THEN
	//se trata de un duo o conjunto se muestra la ventana para escojer el tipo de liberacion
	Open(w_tipo_liberacion)
	lstr_tipo_liberacion = Message.PowerObjectParm //para saber cual tipo de liberacion vamos a trabajar	
	li_opcion_liberar = lstr_tipo_liberacion.entero[1]
	IF li_opcion_liberar = 0 Then
		CLOSE(w_retroalimentacion)
		Return
	End If
ELSEIF li_result = -1 THEN
	CLOSE(w_retroalimentacion)
	Return
END IF

//se esta presentando error cuando el numero de unidades a liberar es cero, pero el mensaje no es claro para el usuario
//jcrm
//agosto 22 de 2008
IF li_opcion_liberar > 1 THEN
	ll_unidades = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'cant_terminado_ant')
ELSE
	ll_unidades = dw_reporte.GetItemNumber(dw_reporte.GetRow(),'cantidad_por_liberar')
END IF
IF ll_unidades <= 0 THEN
	CLOSE(w_retroalimentacion)
	MEssageBox('Error','Las unidades a liberar deben ser mayores a cero.',StopSign!)
	Return
END IF

//revisar si la referencia es bodysize, esta revision es contando si en el modelo principal cada talla tiene diferene diametro
//si retorna 1 es bodysize, si retorna 0 no es bodysize
li_bodysize = luo_liberacion_x_proyeccion.of_revisar_si_bodysize(li_fab, li_lin, ll_ref, ll_color_pt)
IF li_bodysize = 1 THEN
	//La ref es bodysize
	MessageBox('Mensaje','El Estilo es Bodysize porque tiene varios diametros en el modelo principal, se libera la talla: '+string(li_talla_pt))
ELSE
	li_talla_pt = 9999
END IF
IF luo_liberacion_x_proyeccion.of_cargar_temp_ref_liberar(usuario, li_fab, li_lin, ll_ref, ll_color_pt, li_talla_pt, li_bodysize, ii_ano, ii_semana,0,li_fabrica_exp, li_linea_exp, ls_ref_exp, ls_color_exp,li_opcion_liberar) = -1 THEN
	Rollback;
	CLOSE(w_retroalimentacion)
	Return
END IF

lstr_parametros.entero[1]  = li_fab
lstr_parametros.entero[2]  = li_lin
lstr_parametros.entero[3]  = ll_ref
lstr_parametros.entero[4]  = ll_color_pt
lstr_parametros.entero[5]  = ii_ano
lstr_parametros.entero[6]  = ii_semana
lstr_parametros.entero[7]  = li_talla_pt
lstr_parametros.entero[8]  = 0
lstr_parametros.entero[9]  = li_linea_exp
lstr_parametros.entero[10] = li_fabrica_exp
lstr_parametros.cadena[1]  = ls_ref_exp
lstr_parametros.cadena[2]  = ls_color_exp
lstr_parametros.entero[11] = li_opcion_liberar //1 = equilibrar, 2 = igualar

OpenSheetWithParm(w_existencias_tela_critica, lstr_parametros, W_PRINCIPAL,0,Original!)
CLOSE(w_retroalimentacion)
end event

type st_8 from statictext within w_reporte_criticas_liberacion
integer x = 46
integer y = 2308
integer width = 1541
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Las unidades corte se actualizan a estas horas:  7,11,13,15,19,23"
boolean focusrectangle = false
end type

