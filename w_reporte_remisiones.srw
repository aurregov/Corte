HA$PBExportHeader$w_reporte_remisiones.srw
forward
global type w_reporte_remisiones from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_remisiones
end type
type cb_1 from commandbutton within w_reporte_remisiones
end type
end forward

global type w_reporte_remisiones from w_preview_de_impresion
integer width = 3424
integer height = 2020
dw_criterio dw_criterio
cb_1 cb_1
end type
global w_reporte_remisiones w_reporte_remisiones

type variables
String is_sql 
end variables

forward prototypes
public function string wf_consultar ()
public function string wf_query (string as_feld)
end prototypes

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

public function string wf_query (string as_feld);STRING ls_where
DATE   ld_fecha

CHOOSE CASE as_feld
	CASE 'remision'
		ls_where = "( h_canasta_corte.remision = "+ String(dw_criterio.GetItemNumber(1,'remision'))+")"
	CASE 'camion'
		ls_where = "( h_canasta_corte.camion like '%"+ Trim(dw_criterio.GetItemString(1,"camion"))+"%' )" +&
					  " and ( h_canasta_corte.co_estado =  "+ '50'+" )"	
	CASE 'bongo'
		ls_where = "( h_canasta_corte.pallet_id = '"+ Trim(dw_criterio.GetItemString(1,'bongo'))+"')"+&
					" and (h_canasta_corte.co_estado = "+ '40'+" )"
END CHOOSE

RETURN ls_where
end function

on w_reporte_remisiones.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_1
end on

on w_reporte_remisiones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_1)
end on

event open;s_base_parametros s_parametros
String ls_nombredw, ls_wparametros

dw_reporte.settransobject(sqlca)
dw_criterio.SetTransObject(sqlca)
dw_criterio.InsertRow(0)

ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

is_sql = dw_reporte.GetSqlSelect()

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_remisiones
integer y = 196
integer width = 3360
string dataobject = "dtb_remision"
end type

type dw_criterio from datawindow within w_reporte_remisiones
integer x = 64
integer y = 40
integer width = 1943
integer height = 76
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dff_parametros_reporte_remision"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_reporte_remisiones
integer x = 2208
integer y = 20
integer width = 343
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
boolean default = true
end type

event clicked;String ls_sintaxis,ls_where

dw_criterio.AcceptText()


ls_sintaxis = is_sql
ls_where = wf_consultar()

IF ls_where <> "" THEN 
	ls_sintaxis += " and " + ls_where
END IF

dw_reporte.SetSqlSelect(ls_sintaxis)	
	
	
If dw_reporte.Retrieve() > 0 Then	
Else
	MessageBox('Advertencia','No existen registros asociados al criterio seleccionado, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n')
End if

dw_criterio.Reset()
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()
end event

