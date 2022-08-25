HA$PBExportHeader$w_liberacion_existencias_ref_linea.srw
forward
global type w_liberacion_existencias_ref_linea from window
end type
type dw_existencia from datawindow within w_liberacion_existencias_ref_linea
end type
type dw_critica from datawindow within w_liberacion_existencias_ref_linea
end type
type gb_1 from groupbox within w_liberacion_existencias_ref_linea
end type
type gb_2 from groupbox within w_liberacion_existencias_ref_linea
end type
end forward

global type w_liberacion_existencias_ref_linea from window
integer width = 5015
integer height = 1984
boolean titlebar = true
string title = "Liberaci$$HEX1$$f300$$ENDHEX$$n Referencias de L$$HEX1$$ed00$$ENDHEX$$nea"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_existencia dw_existencia
dw_critica dw_critica
gb_1 gb_1
gb_2 gb_2
end type
global w_liberacion_existencias_ref_linea w_liberacion_existencias_ref_linea

type variables
boolean ib_agrupar
Long ii_ano, ii_semana
cst_adm_conexion icst_lectura
end variables

on w_liberacion_existencias_ref_linea.create
this.dw_existencia=create dw_existencia
this.dw_critica=create dw_critica
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.dw_existencia,&
this.dw_critica,&
this.gb_1,&
this.gb_2}
end on

on w_liberacion_existencias_ref_linea.destroy
destroy(this.dw_existencia)
destroy(this.dw_critica)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;icst_lectura = create  cst_adm_conexion

dw_critica.settransobject(icst_lectura.of_get_transaccion_sucia())
n_cts_constantes_tela luo_tela


ib_agrupar = True
//se captura la semana y el a$$HEX1$$f100$$ENDHEX$$o de la critica actual.
ii_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
ii_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')
end event

event closequery;icst_lectura.of_destruir_dirty_read( )
end event

type dw_existencia from datawindow within w_liberacion_existencias_ref_linea
integer x = 1975
integer y = 52
integer width = 2976
integer height = 1540
integer taborder = 20
string title = "none"
string dataobject = "dtb_existencias_tela_critica_linea"
boolean border = false
boolean livescroll = true
end type

type dw_critica from datawindow within w_liberacion_existencias_ref_linea
integer x = 27
integer y = 52
integer width = 1906
integer height = 1540
integer taborder = 10
string title = "none"
string dataobject = "dtb_reporte_criticas_liberacion_linea"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event rbuttondown;Long li_fab, li_lin
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

type gb_1 from groupbox within w_liberacion_existencias_ref_linea
integer x = 14
integer width = 1943
integer height = 1628
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

type gb_2 from groupbox within w_liberacion_existencias_ref_linea
integer x = 1961
integer width = 3013
integer height = 1628
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

