HA$PBExportHeader$w_buscar_filter.srw
forward
global type w_buscar_filter from window
end type
type cb_4 from commandbutton within w_buscar_filter
end type
type cb_3 from commandbutton within w_buscar_filter
end type
type cb_2 from commandbutton within w_buscar_filter
end type
type cb_1 from commandbutton within w_buscar_filter
end type
type dw_lista from datawindow within w_buscar_filter
end type
type dw_criterio from datawindow within w_buscar_filter
end type
type gb_1 from groupbox within w_buscar_filter
end type
type gb_2 from groupbox within w_buscar_filter
end type
end forward

global type w_buscar_filter from window
integer width = 2953
integer height = 1480
boolean titlebar = true
string title = "Ventana busquedad"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_lista dw_lista
dw_criterio dw_criterio
gb_1 gb_1
gb_2 gb_2
end type
global w_buscar_filter w_buscar_filter

forward prototypes
public function string wf_query (string as_feld)
public function string wf_consultar ()
end prototypes

public function string wf_query (string as_feld);STRING ls_where
DATE   ld_fecha

CHOOSE CASE as_feld
	CASE 'grupo'
	//	ls_where = "( dt_pdnxmodulo.co_fabrica ="+ String(ii_fab)+") and (dt_pdnxmodulo.pedido ="+String(il_pedido)+")"
	CASE 'estilo'
	//	ls_where = "( dt_pdnxmodulo.co_fabrica_pt ="+ String(ii_fabpt)+") and (dt_pdnxmodulo.co_linea ="+String(ii_linea)+&
	//				") and ( dt_pdnxmodulo.co_referencia ="+ String(il_ref)+")"
	CASE 'po'
	//	ls_where = "( dt_pdnxmodulo.po like '%"+ Trim(dw_criterio.GetItemString(1,"po"))+"%' )"
	CASE 'unidades'
	//	ls_where = "( dt_pdnxmodulo.ca_pendiente ="+ String(dw_criterio.GetItemNumber(1,"unidades"))+")"
	CASE 'tono'
	//	ls_where = "( dt_pdnxmodulo.tono like '%"+ Trim(dw_criterio.GetItemString(1,"tono"))+"%' )"
	CASE 'prioridad'
	//	ls_where = "( dt_pdnxmodulo.cs_prioridad ="+ String(dw_criterio.GetItemNumber(1,"prioridad"))+")"

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
			//ls_fieldmod = wf_query (ls_rest)
			IF ls_fieldmod <> '' THEN ls_where += ls_fieldmod  + "  ,  "
		END IF
	END IF
LOOP WHILE ls_rest <> ''

IF ls_where <> '' THEN ls_where = Mid(ls_where,1,Len(ls_where) -5)

RETURN ls_where
end function

on w_buscar_filter.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_lista=create dw_lista
this.dw_criterio=create dw_criterio
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_lista,&
this.dw_criterio,&
this.gb_1,&
this.gb_2}
end on

on w_buscar_filter.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_lista)
destroy(this.dw_criterio)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type cb_4 from commandbutton within w_buscar_filter
integer x = 325
integer y = 720
integer width = 261
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Limpiar"
boolean cancel = true
end type

type cb_3 from commandbutton within w_buscar_filter
integer x = 325
integer y = 1016
integer width = 247
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
boolean default = true
end type

type cb_2 from commandbutton within w_buscar_filter
integer x = 608
integer y = 1016
integer width = 247
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

type cb_1 from commandbutton within w_buscar_filter
integer x = 41
integer y = 1016
integer width = 247
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

type dw_lista from datawindow within w_buscar_filter
integer x = 901
integer y = 64
integer width = 1975
integer height = 1260
integer taborder = 20
string title = "none"
string dataobject = "dtb_dt_pdnxmodulo2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_criterio from datawindow within w_buscar_filter
integer x = 50
integer y = 48
integer width = 759
integer height = 656
integer taborder = 10
string title = "none"
string dataobject = "dff_criterio_buscar_filter"
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_buscar_filter
integer x = 37
integer y = 8
integer width = 818
integer height = 848
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_buscar_filter
integer x = 878
integer y = 12
integer width = 2021
integer height = 1332
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

