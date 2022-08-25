HA$PBExportHeader$w_rep_liberacion_diaria_critica.srw
forward
global type w_rep_liberacion_diaria_critica from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_rep_liberacion_diaria_critica
end type
type cb_1 from commandbutton within w_rep_liberacion_diaria_critica
end type
type rb_linea from radiobutton within w_rep_liberacion_diaria_critica
end type
type rb_moda from radiobutton within w_rep_liberacion_diaria_critica
end type
type rb_1 from radiobutton within w_rep_liberacion_diaria_critica
end type
type rb_2 from radiobutton within w_rep_liberacion_diaria_critica
end type
end forward

global type w_rep_liberacion_diaria_critica from w_preview_de_impresion
integer width = 3941
integer height = 2544
dw_criterio dw_criterio
cb_1 cb_1
rb_linea rb_linea
rb_moda rb_moda
rb_1 rb_1
rb_2 rb_2
end type
global w_rep_liberacion_diaria_critica w_rep_liberacion_diaria_critica

type variables
s_base_parametros  istr_param
cst_adm_conexion icst_lectura
Boolean ab_linea
end variables

event open;This.x = 1
This.y = 1

icst_lectura = create  cst_adm_conexion

dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
dw_criterio.SetTransObject(icst_lectura.of_get_transaccion_sucia())

dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 


dw_criterio.SetItem(1,'fecha_ini',Today())
dw_criterio.SetItem(1,'fecha_fin',Today())

ab_linea = true


dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

on w_rep_liberacion_diaria_critica.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_1=create cb_1
this.rb_linea=create rb_linea
this.rb_moda=create rb_moda
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_linea
this.Control[iCurrent+4]=this.rb_moda
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
end on

on w_rep_liberacion_diaria_critica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_1)
destroy(this.rb_linea)
destroy(this.rb_moda)
destroy(this.rb_1)
destroy(this.rb_2)
end on

event closequery;call super::closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_rep_liberacion_diaria_critica
integer y = 128
integer width = 3840
string dataobject = "dtb_reporte_liberacion_diaria_criticas"
end type

type dw_criterio from datawindow within w_rep_liberacion_diaria_critica
integer y = 20
integer width = 2450
integer height = 76
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_fechas_liberacion_diaria_critica"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_rep_liberacion_diaria_critica
integer x = 3575
integer y = 8
integer width = 283
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;DateTime ldt_fecha_ini, ldt_fecha_fin
Long li_ano, li_semana, li_planta
n_cts_constantes_tela luo_tela

////se determina el a$$HEX1$$f100$$ENDHEX$$o actual de las criticas
//li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
//
////con el a$$HEX1$$f100$$ENDHEX$$o se busca la maxima semana de las criticas
//li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')

dw_criterio.AcceptText()

li_ano			= dw_criterio.GetItemNumber(1,'ano')
li_semana		= dw_criterio.GetItemNumber(1,'semana')
ldt_fecha_ini 	= dw_criterio.GetItemDateTime(1,'fecha_ini')
ldt_fecha_fin 	= dw_criterio.GetItemDateTime(1,'fecha_fin')
li_planta      = dw_criterio.GetItemNumber(1,'planta')

IF ab_linea = true THEN
	IF IsNull(li_ano) OR IsNull(li_semana) THEN
		MessageBox('Advertencia','Es necesario ingresar a$$HEX1$$f100$$ENDHEX$$o y semana de las criticas.',StopSign!)
		Return
	END IF
END IF



dw_reporte.Retrieve(ldt_fecha_ini,ldt_fecha_fin,li_ano,li_semana,li_planta)


end event

type rb_linea from radiobutton within w_rep_liberacion_diaria_critica
integer x = 2446
integer y = 28
integer width = 338
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
string text = "Necesarias"
boolean checked = true
end type

event clicked;dw_reporte.DataObject = 'dtb_reporte_liberacion_diaria_criticas'
dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
ab_linea = true
end event

type rb_moda from radiobutton within w_rep_liberacion_diaria_critica
integer x = 3045
integer y = 28
integer width = 242
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
string text = "Moda"
end type

event clicked;dw_reporte.DataObject = 'dtb_reporte_liberacion_diaria_moda'
dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
ab_linea = False
end event

type rb_1 from radiobutton within w_rep_liberacion_diaria_critica
integer x = 2793
integer y = 28
integer width = 247
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
string text = "L$$HEX1$$ed00$$ENDHEX$$nea"
end type

event clicked;dw_reporte.DataObject = 'dtb_reporte_liberacion_diaria_linea'
dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
ab_linea = False
end event

type rb_2 from radiobutton within w_rep_liberacion_diaria_critica
integer x = 3282
integer y = 28
integer width = 224
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
string text = "Todo"
end type

event clicked;dw_reporte.DataObject = 'dtb_reporte_liberacion_diaria_todo'
dw_reporte.settransobject(icst_lectura.of_get_transaccion_sucia())
ab_linea = False
end event

