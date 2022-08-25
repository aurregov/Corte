HA$PBExportHeader$w_solicitud_partir_rollos.srw
forward
global type w_solicitud_partir_rollos from w_base_simple
end type
type gb_1 from groupbox within w_solicitud_partir_rollos
end type
end forward

global type w_solicitud_partir_rollos from w_base_simple
integer width = 1051
integer height = 1812
string title = "Solicitud Partir Rollos"
gb_1 gb_1
end type
global w_solicitud_partir_rollos w_solicitud_partir_rollos

on w_solicitud_partir_rollos.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_solicitud_partir_rollos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event ue_grabar;//se carga en la tabla temp_rollos_partir los rollos ingresados en la ventana
//jcrm
//marzo 27 de 2009
Long li_fila
Long ll_rollo, ll_unidades
Decimal{2} ldc_kilos
String ls_mensaje
n_cts_liberacion_x_proyeccion luo_proyeccion

dw_maestro.AcceptText()

FOR li_fila = 1 TO dw_maestro.RowCount()
	ll_rollo = dw_maestro.GetItemNumber(li_fila,'cs_rollo')	
	ll_unidades = dw_maestro.GetItemNumber(li_fila,'ca_unidades')	
	ldc_kilos = dw_maestro.GetItemNumber(li_fila,'ca_kg')	
	
	//se insertan los datos en temp_rollos_partir, con proceso 5
	IF luo_proyeccion.of_solicitud_partir_rollo(ll_rollo,ll_unidades,ldc_kilos,ls_mensaje) = -1 THEN
		ROLLBACK;
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de crear la solictud, ERROR: '+ls_mensaje)
		Return 
	END IF
NEXT

IF li_fila > 0 THEN
   //grabar datos
	Commit;
	MessageBox('Exito','Se crearon las solictudes de partir rollos con exito.')
ELSE
	return
END IF
end event

type dw_maestro from w_base_simple`dw_maestro within w_solicitud_partir_rollos
integer y = 64
integer width = 910
integer height = 1540
string dataobject = "dgr_solicitud_partir_rollos"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type gb_1 from groupbox within w_solicitud_partir_rollos
integer x = 32
integer y = 16
integer width = 960
integer height = 1604
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

