HA$PBExportHeader$w_buscar_bongo.srw
forward
global type w_buscar_bongo from window
end type
type dw_criterio from datawindow within w_buscar_bongo
end type
type cb_buscar from commandbutton within w_buscar_bongo
end type
type cb_cancelar from commandbutton within w_buscar_bongo
end type
type cb_aceptar from commandbutton within w_buscar_bongo
end type
type cbx_pendiente from checkbox within w_buscar_bongo
end type
type dw_lista from datawindow within w_buscar_bongo
end type
type gb_1 from groupbox within w_buscar_bongo
end type
type gb_2 from groupbox within w_buscar_bongo
end type
end forward

global type w_buscar_bongo from window
integer width = 2939
integer height = 1256
boolean titlebar = true
string title = "Buscar Recipiente"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_criterio dw_criterio
cb_buscar cb_buscar
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
cbx_pendiente cbx_pendiente
dw_lista dw_lista
gb_1 gb_1
gb_2 gb_2
end type
global w_buscar_bongo w_buscar_bongo

type variables
Long il_fab,il_pla,il_mod,il_pedido,il_ref
Long ii_fab,ii_linea,ii_fabpt
String is_sql
s_base_parametros istr_parametros


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
	CASE 'grupo'
		ls_where = "( dt_agrupa_pdn.co_fabrica_exp = "+ String(ii_fab)+") and (dt_agrupa_pdn.pedido = "+String(il_pedido)+")"
	CASE 'estilo'
		ls_where = "( h_preref_pv.co_fabrica = "+ String(ii_fabpt)+") and (h_preref_pv.co_linea = "+String(ii_linea)+&
					") and ( co_referencia = "+ String(il_ref)+")"
	CASE 'po'
		ls_where = "( dt_agrupa_pdn.po like '%"+ Trim(dw_criterio.GetItemString(1,"po"))+"%' )"
	CASE 'tono'
		ls_where = "( dt_agrupa_pdn.tono like '%"+ Trim(dw_criterio.GetItemString(1,"tono"))+"%' )"
	CASE 'color'
		ls_where = "( dt_canasta_corte.co_color = "+ String(dw_criterio.GetItemNumber(1,"color"))+")"
	CASE 'oc'
		ls_where = "( dt_canasta_corte.cs_orden_corte = "+ String(dw_criterio.GetItemNumber(1,'oc'))+")"	
END CHOOSE

RETURN ls_where
end function

on w_buscar_bongo.create
this.dw_criterio=create dw_criterio
this.cb_buscar=create cb_buscar
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.cbx_pendiente=create cbx_pendiente
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.dw_criterio,&
this.cb_buscar,&
this.cb_cancelar,&
this.cb_aceptar,&
this.cbx_pendiente,&
this.dw_lista,&
this.gb_1,&
this.gb_2}
end on

on w_buscar_bongo.destroy
destroy(this.dw_criterio)
destroy(this.cb_buscar)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.cbx_pendiente)
destroy(this.dw_lista)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;dw_criterio.SetTransObject(sqlca)
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

is_sql = dw_lista.GetSqlSelect()


il_fab = 0
il_pla = 0
il_mod = 1









end event

type dw_criterio from datawindow within w_buscar_bongo
integer x = 37
integer y = 76
integer width = 814
integer height = 500
integer taborder = 20
string title = "none"
string dataobject = "dff_criterio_buscar_bongos"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_estilo,ls_grupo

CHOOSE CASE GetColumnName()
	
	CASE 'grupo'
		
		ls_grupo = Data
		
		select co_fabrica_vta, pedido
		into :ii_fab,:il_pedido
		from peddig
		where gpa = :ls_grupo
		and tipo_pedido="AL";
		
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox('Error','Al recuperar informaci$$HEX1$$f300$$ENDHEX$$n del grupo')
			Return 
		ELSE
			IF Sqlca.sqlcode = 100 THEN 
				MessageBox('Error','No existe informaci$$HEX1$$f300$$ENDHEX$$n del grupo')
				Return 
			END IF	
		END IF
		
		
		
	CASE 'estilo'
		
		ls_estilo = Data
		
		//dbedocal SA - 57348: Modificar Long por Integer (Cambio de color)
		select co_fabrica, co_linea, cast(h_preref_pv.co_referencia as Integer) as co_referencia
		into :ii_fabpt, :ii_linea, :il_ref
		from h_preref_pv
		where de_referencia = :ls_estilo;
		
		IF SQLCA.SQLCODE = -1 THEN
			MessageBox('Error','Al recuperar informaci$$HEX1$$f300$$ENDHEX$$n del estilo')
			Return 
		ELSE
			IF Sqlca.sqlcode = 100 THEN 
				MessageBox('Error','No existe informaci$$HEX1$$f300$$ENDHEX$$n del estilo')
				Return 
			END IF	
		END IF
			
//	CASE 'color'
//		
//		ls_color = Trim(Data)
//		
//		select co_fabrica,co_linea,co_color
//		into :ii_color
//		from m_colores
//		where de_color LIKE :ls_color and
//				co_fabrica = :ii_fabpt and
//				co_linea = :ii_linea;
//		
//		IF SQLCA.SQLCODE = -1 THEN
//			MessageBox('Error','Al recuperar informaci$$HEX1$$f300$$ENDHEX$$n del color')
//			Return 
//		ELSE
//			IF Sqlca.sqlcode = 100 THEN 
//				MessageBox('Error','No existe informaci$$HEX1$$f300$$ENDHEX$$n del color')
//				Return 
//			END IF	
//		END IF
		
		
		
END CHOOSE

end event

type cb_buscar from commandbutton within w_buscar_bongo
integer x = 18
integer y = 832
integer width = 265
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

event clicked;String ls_where,ls_sintaxis,ls_complemento
Long ll_marca

TRANSACTION			itr_tela

itr_tela 				= 	Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_lista.SetTransObject(itr_tela)

ls_sintaxis = is_sql
ls_where = wf_consultar()

If il_mod = 0 Then
	ls_complemento = ' and dt_canasta_corte.co_modulo = '+ String(il_mod)
End if


IF ls_where <> "" THEN 
	ls_sintaxis += " and " + ls_where + ls_complemento
ELSE
	ls_sintaxis += ls_complemento
END IF

dw_lista.SetSqlSelect(ls_sintaxis)
dw_lista.visible = False
dw_lista.Retrieve()
dw_lista.SetSort("cs_prioridad A")
dw_lista.Sort()

IF dw_lista.RowCount() = 0 THEN
	//MessageBox('Advertencia','No existen registros que cumplan con el criterio de busqueda')
	ll_marca = 1
END IF

IF ll_marca = 1 THEN 
ELSE
	dw_criterio.Reset()
	dw_criterio.InsertRow(0)
END IF

DISCONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF



end event

type cb_cancelar from commandbutton within w_buscar_bongo
integer x = 617
integer y = 832
integer width = 265
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;
istr_parametros.cadena[1] = 'N'

CloseWithReturn(Parent,istr_parametros)
end event

type cb_aceptar from commandbutton within w_buscar_bongo
integer x = 315
integer y = 832
integer width = 265
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_fila

ll_fila = dw_lista.getRow()

IF ll_fila >= 1 THEN
	
	istr_parametros.cadena[1] = 'S'
	istr_parametros.cadena[2] = dw_lista.GetItemString(ll_fila,'h_canasta_corte_pallet_id')

	CloseWithReturn(Parent,istr_parametros)
END IF



end event

type cbx_pendiente from checkbox within w_buscar_bongo
integer x = 41
integer y = 576
integer width = 334
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendientes"
boolean lefttext = true
end type

event clicked;If cbx_pendiente.Checked = true Then
	il_fab = 91
	il_pla = 1
	il_mod = 0
Else
	il_fab = 0
	il_pla = 0
	il_mod = 1
End if
end event

type dw_lista from datawindow within w_buscar_bongo
integer x = 946
integer y = 68
integer width = 1943
integer height = 984
integer taborder = 10
string title = "none"
string dataobject = "dtb_buscar_bongo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;If Row <= 0 Then Return

If KeyDown(KeyControl!) Then
	This.SelectRow(Row,Not IsSelected(Row))
Else
	This.SelectRow(0,False)
	This.SelectRow(Row,True)
End If
end event

event doubleclicked;If Row <= 0 Then Return

cb_aceptar.TriggerEvent(Clicked!)

end event

event retrieveend;If This.RowCount() > 0 Then
Else
	MessageBox('Advertencia','No existe ningun registro, por favor verifique su informaci$$HEX1$$f300$$ENDHEX$$n')
End if

dw_lista.Visible = True
end event

event buttonclicked;String ls_columna

ls_columna = dwo.name

choose case ls_columna
	case 'bongo'
		This.SetSort("h_canasta_corte_pallet_id A")
		This.Sort()
		
	case 'grupo'
		This.SetSort("gpa A, h_canasta_corte_pallet_id A")
		This.Sort()
end choose

end event

type gb_1 from groupbox within w_buscar_bongo
integer x = 18
integer y = 12
integer width = 864
integer height = 680
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_buscar_bongo
integer x = 914
integer y = 12
integer width = 1998
integer height = 1064
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

