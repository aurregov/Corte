HA$PBExportHeader$w_concepto_bodega.srw
forward
global type w_concepto_bodega from window
end type
type cb_cancelar from commandbutton within w_concepto_bodega
end type
type cb_grabar from commandbutton within w_concepto_bodega
end type
type dw_lista from datawindow within w_concepto_bodega
end type
type gb_1 from groupbox within w_concepto_bodega
end type
end forward

global type w_concepto_bodega from window
integer width = 2121
integer height = 1452
boolean titlebar = true
string title = "Listado"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_grabar cb_grabar
dw_lista dw_lista
gb_1 gb_1
end type
global w_concepto_bodega w_concepto_bodega

type variables
LONG il_centro,il_co_planeador,il_orden_practn,il_co_reftel_act,il_co_color_act,&
	  il_cs_tanda
end variables

on w_concepto_bodega.create
this.cb_cancelar=create cb_cancelar
this.cb_grabar=create cb_grabar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_cancelar,&
this.cb_grabar,&
this.dw_lista,&
this.gb_1}
end on

on w_concepto_bodega.destroy
destroy(this.cb_cancelar)
destroy(this.cb_grabar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;s_base_parametros lstr_parametros

This.x = 1
This.y = 1

dw_lista.SetTransObject(SQLCA)
dw_lista.Retrieve()

lstr_parametros  = Message.PowerObjectParm	
il_centro 		  = lstr_parametros.entero[1]
il_co_planeador  = lstr_parametros.entero[2] 
il_orden_practn  = lstr_parametros.entero[3] 
il_co_reftel_act = lstr_parametros.entero[4] 
il_co_color_act  = lstr_parametros.entero[5]
il_cs_tanda		  = lstr_parametros.entero[6]




end event

type cb_cancelar from commandbutton within w_concepto_bodega
integer x = 1061
integer y = 1144
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = FALSE
CloseWithReturn(w_concepto_bodega,lstr_parametros)
end event

type cb_grabar from commandbutton within w_concepto_bodega
integer x = 635
integer y = 1144
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar"
end type

event clicked;long ll_currow, ll_cpto_selecc 
boolean lb_result 

ll_currow = dw_lista.getrow()
lb_result = dw_lista.isselected(ll_currow)

dw_lista.settransobject(sqlca)
dw_lista.accepttext()

if lb_result = false then
	messagebox("Advertencia...","Debe Seleccionar un Concepto de Bodega",exclamation!)
else
	ll_cpto_selecc = dw_lista.getitemnumber(dw_lista.getrow(),'co_cpto_bodega')

	IF (il_centro>0) AND (il_co_planeador>0) AND (il_orden_practn>0) AND (il_co_reftel_act>0)  THEN

		update m_rollo
		set   co_planeador =:ll_cpto_selecc,
				fe_act_cpto  = current
		where (co_centro 	     = :il_centro)
		and 	(co_planeador 	  = :il_co_planeador)
		and 	(cs_orden_pr_act = :il_orden_practn)
		and   (co_reftel_act   = :il_co_reftel_act)
		and   (co_color_act    = :il_co_color_act) 
		and 	(cs_tanda 		  = :il_cs_tanda);
		
		IF SQLCA.SQLCODE <> 0 THEN
			Rollback;
			MessageBox('Error...','Se presentaron errores actualizando el concepto de los rollos',stopsign!)
			Return -1
		ELSE
			MessageBox('O.K.','Se actualizaron los rollos para el concepto: ' + string(ll_cpto_selecc),Information!)
		END IF
		commit;
	END IF

end if



end event

type dw_lista from datawindow within w_concepto_bodega
integer x = 96
integer y = 132
integer width = 1943
integer height = 924
integer taborder = 10
string title = "none"
string dataobject = "dgr_cpto_bodega"
boolean border = false
boolean livescroll = true
end type

event clicked;If row > 0 then 
	selectrow(0,false)
	SelectRow(row,true)
END IF
end event

type gb_1 from groupbox within w_concepto_bodega
integer x = 46
integer y = 44
integer width = 2002
integer height = 1048
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Conceptos Bodega"
end type

