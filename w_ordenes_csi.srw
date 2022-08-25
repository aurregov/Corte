HA$PBExportHeader$w_ordenes_csi.srw
forward
global type w_ordenes_csi from window
end type
type cb_borrar from commandbutton within w_ordenes_csi
end type
type cb_sacarcsi from commandbutton within w_ordenes_csi
end type
type cb_insertar from commandbutton within w_ordenes_csi
end type
type cb_cerrar from commandbutton within w_ordenes_csi
end type
type cb_grabar from commandbutton within w_ordenes_csi
end type
type dw_lista from datawindow within w_ordenes_csi
end type
type gb_1 from groupbox within w_ordenes_csi
end type
end forward

global type w_ordenes_csi from window
integer width = 2331
integer height = 1736
boolean titlebar = true
string title = "Ordenes CSI"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_borrar cb_borrar
cb_sacarcsi cb_sacarcsi
cb_insertar cb_insertar
cb_cerrar cb_cerrar
cb_grabar cb_grabar
dw_lista dw_lista
gb_1 gb_1
end type
global w_ordenes_csi w_ordenes_csi

forward prototypes
public function long of_grabar ()
end prototypes

public function long of_grabar ();//metodo para grabar en estado 99 en dt_pdnxmodulo y las observaciones en h_ordenes_corte
//jcrm
//abril 15 de 2009
String ls_observacion
Long ll_oc, ll_fila

IF dw_lista.RowCount() <= 0 THEN
	MessageBox('Advertencia','No existen O.C. para colocar en C.S.I.',StopSign!)
	Return -1
END IF

FOR ll_fila = 1 TO dw_lista.RowCount()
	ll_oc = dw_lista.GetItemNumber(ll_fila,'cs_orden_corte')
	ls_observacion = dw_lista.GetItemString(ll_fila,'observacion')
	
	//se valida que la O.C. exista
	
	//se actualizan las observaciones en h_ordenes_corte
		
	//se actualiza el estado a 99 en dt_pdnxmodulo
	
NEXT

//se aceptan los datos en la base de datos

Return 0
end function

on w_ordenes_csi.create
this.cb_borrar=create cb_borrar
this.cb_sacarcsi=create cb_sacarcsi
this.cb_insertar=create cb_insertar
this.cb_cerrar=create cb_cerrar
this.cb_grabar=create cb_grabar
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.cb_borrar,&
this.cb_sacarcsi,&
this.cb_insertar,&
this.cb_cerrar,&
this.cb_grabar,&
this.dw_lista,&
this.gb_1}
end on

on w_ordenes_csi.destroy
destroy(this.cb_borrar)
destroy(this.cb_sacarcsi)
destroy(this.cb_insertar)
destroy(this.cb_cerrar)
destroy(this.cb_grabar)
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1

dw_lista.SetTransObject(SQLCA)
dw_lista.Retrieve()
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF
end event

type cb_borrar from commandbutton within w_ordenes_csi
integer x = 1915
integer y = 232
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Borrar"
end type

event clicked;Long ll_fila

ll_fila = dw_lista.GetRow()

IF ll_fila > 0 THEN
	dw_lista.DeleteRow(ll_fila)
ELSE
	MessageBox('Error','Fila no valida.',StopSign!)
END IF
end event

type cb_sacarcsi from commandbutton within w_ordenes_csi
integer x = 1915
integer y = 428
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sacar C.S.I."
end type

event clicked;Long ll_fila
Long li_marca

FOR ll_fila = 1 TO dw_lista.RowCount()
	li_marca = dw_lista.GetItemNumber(ll_fila,'marca')
	IF li_marca = 1 THEN
		//se coloca el estado actual en el estado para poder asignarlo luego
		dw_lista.SetItem(ll_fila,'co_estado_asigna',9)
	END IF
NEXT

cb_grabar.TriggerEvent(clicked!)

end event

type cb_insertar from commandbutton within w_ordenes_csi
integer x = 1915
integer y = 36
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar"
end type

event clicked;long ll_fila

ll_fila = dw_lista.InsertRow(0)
dw_lista.setItem(ll_fila,'co_estado_asigna',99)
dw_lista.ScrollToRow(ll_fila)


end event

type cb_cerrar from commandbutton within w_ordenes_csi
integer x = 1915
integer y = 820
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;close(Parent)
end event

type cb_grabar from commandbutton within w_ordenes_csi
integer x = 1915
integer y = 624
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar"
end type

event clicked;//metodo para recorrer todos los registros de dw_lista y colocar el estado de CSI 99 o 
//si el usuario quiere sacarlo de CSI se coloca el estado que tenga activo en h_ordenes_corte
//este estado se actualiza en dt_pdnxmodulo y las observaciones se colocan en h_ordenes_corte
//jcrm
//abril 15 de 2009
Long ll_fila, ll_oc
String ls_observacion, ls_mensaje
Long li_estado
Boolean lb_grabar
n_cts_oc_csi luo_csi

lb_grabar = False

dw_lista.AcceptText()


FOR ll_fila = 1 TO dw_lista.RowCount()
	ll_oc = dw_lista.GetItemNumber(ll_fila,'cs_asignacion')
	ls_observacion = dw_lista.GetItemString(ll_fila,'observacion')
	li_estado = dw_lista.GetItemNumber(ll_fila,'co_estado_asigna')
	
	//se valida la O.C
	IF luo_csi.of_validar_oc(ll_oc,ls_mensaje) = -1 THEN
		Rollback;
		MessageBox('Error',ls_mensaje,StopSign!)
		Return 
	END IF
		
	//se carga la observacion en h_ordenes_corte
	IF luo_csi.of_cargar_observacion(ll_oc,ls_observacion,ls_mensaje) = -1 THEN
		Rollback;
		MessageBox('Error',ls_mensaje,StopSign!)
		Return 
	END IF
	
	//se carga el estado csi en dt_pdnxmodulo
	IF luo_csi.of_cargar_estado_csi(ll_oc,li_estado,ls_mensaje) = -1 THEN
		Rollback;
		MessageBox('Error',ls_mensaje,StopSign!)
		Return 
	END IF
	
	lb_grabar = True
	
NEXT

IF lb_grabar = True THEN
	//se aceptan los datos modificados en la pantalla
	Commit;
	dw_lista.Retrieve()
	MessageBox('Exito','Se actualizaron los datos exitosamente.')
	Return
ELSE
	Rollback;
	MessageBox('Advertencia','No se actualizaron datos.')
	Return
END IF

dw_lista.Retrieve()
end event

type dw_lista from datawindow within w_ordenes_csi
integer x = 78
integer y = 56
integer width = 1792
integer height = 1424
integer taborder = 10
string title = "none"
string dataobject = "dgr_ordenes_csi"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;dw_lista.SelectRow(Row, TRUE)
end event

type gb_1 from groupbox within w_ordenes_csi
integer x = 46
integer width = 1842
integer height = 1540
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

