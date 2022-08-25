HA$PBExportHeader$w_consulta_ordenpt.srw
forward
global type w_consulta_ordenpt from w_base_maestroff_detalletb_para_tabs
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type dw_confeccion from uo_dtwndow within w_consulta_ordenpt
end type
type dw_tejido from uo_dtwndow within w_consulta_ordenpt
end type
type dw_telas from uo_dtwndow within w_consulta_ordenpt
end type
type dw_tintoreria from uo_dtwndow within w_consulta_ordenpt
end type
type dw_tallas_colores from uo_dtwndow within w_consulta_ordenpt
end type
type dw_corte from uo_dtwndow within w_consulta_ordenpt
end type
end forward

global type w_consulta_ordenpt from w_base_maestroff_detalletb_para_tabs
integer width = 2889
integer height = 1572
string title = "Consulta Orden Producto Terminado"
string menuname = "m_seleccion_trazos"
event ue_imprimir pbm_custom07
dw_confeccion dw_confeccion
dw_tejido dw_tejido
dw_telas dw_telas
dw_tintoreria dw_tintoreria
dw_tallas_colores dw_tallas_colores
dw_corte dw_corte
end type
global w_consulta_ordenpt w_consulta_ordenpt

event ue_imprimir;dw_corte.setFocus()
OpenWithParm(w_opciones_impresion, dw_corte)

end event

on w_consulta_ordenpt.create
int iCurrent
call super::create
if this.MenuName = "m_seleccion_trazos" then this.MenuID = create m_seleccion_trazos
this.dw_confeccion=create dw_confeccion
this.dw_tejido=create dw_tejido
this.dw_telas=create dw_telas
this.dw_tintoreria=create dw_tintoreria
this.dw_tallas_colores=create dw_tallas_colores
this.dw_corte=create dw_corte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_confeccion
this.Control[iCurrent+2]=this.dw_tejido
this.Control[iCurrent+3]=this.dw_telas
this.Control[iCurrent+4]=this.dw_tintoreria
this.Control[iCurrent+5]=this.dw_tallas_colores
this.Control[iCurrent+6]=this.dw_corte
end on

on w_consulta_ordenpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_confeccion)
destroy(this.dw_tejido)
destroy(this.dw_telas)
destroy(this.dw_tintoreria)
destroy(this.dw_tallas_colores)
destroy(this.dw_corte)
end on

event open;This.Width = 2900
This.Height = 1500
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF


ii_num_dw = 7
 
idw_arreglo_dw[1] = dw_detalle
idw_arreglo_dw[2] = dw_tallas_colores
idw_arreglo_dw[3] = dw_telas
idw_arreglo_dw[4] = dw_tejido
idw_arreglo_dw[5] = dw_tintoreria
idw_arreglo_dw[6] = dw_corte
idw_arreglo_dw[7] = dw_confeccion
tab_1.boldselectedtext= true


//Call w_base_maestroff_detalletb_para_tabs::Open

Long li_dw_a_inicializar // vble usada para controlar la posicion del
                            // arreglo que almacena los datawindows que
									 // se van a usar en las carpetas
This.x = 1
This.y = 1

dw_maestro.SetTransObject(SQLCA)

li_dw_a_inicializar = 1

DO WHILE li_dw_a_inicializar <= ii_num_dw
	idw_arreglo_dw[li_dw_a_inicializar].SetTransObject(SQLCA)
	idw_arreglo_dw[li_dw_a_inicializar].Visible = FALSE
	il_fila_actual_detalle[li_dw_a_inicializar] = 0
	li_dw_a_inicializar = li_dw_a_inicializar + 1
LOOP

il_fila_actual_maestro = 0
ii_dw_actual = 1
tab_1.SelectTab(ii_dw_actual)
idw_arreglo_dw[ii_dw_actual].Visible = TRUE
idw_arreglo_dw[ii_dw_actual].BringToTop = TRUE



PostEvent("ue_buscar")
end event

event ue_borrar_detalle;// Se omite el script
end event

event ue_borrar_maestro;// Se omite el script
end event

event ue_buscar;s_base_parametros lstr_parametros
long ll_hallados, ll_ordenpt
Long li_dw_a_inicializar

Open(w_buscar_ordenpd)
lstr_parametros=message.powerObjectparm
IF lstr_parametros.hay_parametros THEN
	ll_ordenpt = lstr_parametros.entero[1]
	ll_hallados = dw_maestro.Retrieve(ll_ordenpt)
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
				li_dw_a_inicializar = 1
				DO WHILE li_dw_a_inicializar <= ii_num_dw
					idw_arreglo_dw[li_dw_a_inicializar].Retrieve(ll_ordenpt)
					li_dw_a_inicializar++
				LOOP				
		END CHOOSE
	END IF
ELSE
END IF
end event

event ue_grabar;// Se omite el script
end event

event ue_insertar_detalle;// Se omite el script
end event

event ue_insertar_maestro;// Se omite el script
end event

event closequery;// Se omite el script
end event

type dw_maestro from w_base_maestroff_detalletb_para_tabs`dw_maestro within w_consulta_ordenpt
integer x = 37
integer y = 12
integer width = 2757
integer height = 244
integer taborder = 70
boolean bringtotop = true
string dataobject = "dff_consulta_ordenpt"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

type tab_1 from w_base_maestroff_detalletb_para_tabs`tab_1 within w_consulta_ordenpt
integer x = 37
integer y = 280
integer width = 2592
integer taborder = 80
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_2
this.Control[iCurrent+2]=this.tabpage_3
this.Control[iCurrent+3]=this.tabpage_4
this.Control[iCurrent+4]=this.tabpage_5
this.Control[iCurrent+5]=this.tabpage_6
this.Control[iCurrent+6]=this.tabpage_7
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

type tabpage_1 from w_base_maestroff_detalletb_para_tabs`tabpage_1 within tab_1
integer width = 2555
string text = "General"
string picturename = "Globals!"
end type

type dw_detalle from w_base_maestroff_detalletb_para_tabs`dw_detalle within w_consulta_ordenpt
integer x = 37
integer y = 400
integer width = 2798
integer height = 764
string dataobject = "dff_info_general_ordenpt"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event dw_detalle::retrieveend;IF rowcount <> 0 AND rowcount <> -1 AND NOT ISNULL(rowcount) THEN
	This.SelectRow(0,FALSE)
	il_fila_actual_detalle[ii_dw_actual] = rowcount
ELSE
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2555
integer height = 112
long backcolor = 79741120
string text = "Tallas Colores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ArrangeTables!"
long picturemaskcolor = 553648127
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2555
integer height = 112
long backcolor = 79741120
string text = "Telas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom057!"
long picturemaskcolor = 553648127
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2555
integer height = 112
long backcolor = 79741120
string text = "Tejido"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "C:\Graficos\rollotela.bmp"
long picturemaskcolor = 553648127
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2555
integer height = 112
long backcolor = 79741120
string text = "Tintorer$$HEX1$$ed00$$ENDHEX$$a"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom073!"
long picturemaskcolor = 553648127
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2555
integer height = 112
long backcolor = 79741120
string text = "Corte"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom091!"
long picturemaskcolor = 553648127
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2555
integer height = 112
long backcolor = 79741120
string text = "Confecci$$HEX1$$f300$$ENDHEX$$n"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "C:\Graficos\camisa.bmp"
long picturemaskcolor = 553648127
end type

type dw_confeccion from uo_dtwndow within w_consulta_ordenpt
integer x = 37
integer y = 400
integer width = 2798
integer height = 664
integer taborder = 20
boolean bringtotop = true
boolean vscrollbar = false
end type

type dw_tejido from uo_dtwndow within w_consulta_ordenpt
integer x = 37
integer y = 400
integer width = 2798
integer height = 660
integer taborder = 60
boolean bringtotop = true
string dataobject = "dtb_tejidoxorden"
boolean hscrollbar = true
boolean livescroll = true
end type

type dw_telas from uo_dtwndow within w_consulta_ordenpt
integer x = 37
integer y = 400
integer width = 2798
integer height = 896
integer taborder = 11
boolean bringtotop = true
string dataobject = "r_tela_ordenpt"
boolean livescroll = true
end type

type dw_tintoreria from uo_dtwndow within w_consulta_ordenpt
integer x = 32
integer y = 400
integer width = 2798
integer height = 900
integer taborder = 50
boolean bringtotop = true
string dataobject = "dtb_consultaorden_tint"
boolean hscrollbar = true
boolean livescroll = true
end type

type dw_tallas_colores from uo_dtwndow within w_consulta_ordenpt
integer x = 37
integer y = 400
integer width = 2798
integer height = 896
integer taborder = 40
boolean bringtotop = true
string dataobject = "dtb_consulta_tallas_colores"
boolean livescroll = true
end type

type dw_corte from uo_dtwndow within w_consulta_ordenpt
integer x = 37
integer y = 400
integer width = 2798
integer height = 900
integer taborder = 30
boolean bringtotop = true
boolean titlebar = true
string title = "Ordenes de Corte"
string dataobject = "dtb_cons_corte"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
end type

