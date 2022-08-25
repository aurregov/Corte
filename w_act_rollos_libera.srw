HA$PBExportHeader$w_act_rollos_libera.srw
forward
global type w_act_rollos_libera from w_base_simple
end type
type cb_actualizar from commandbutton within w_act_rollos_libera
end type
type cb_salir from commandbutton within w_act_rollos_libera
end type
type cb_insertar from commandbutton within w_act_rollos_libera
end type
type cb_borrar from commandbutton within w_act_rollos_libera
end type
type gb_1 from groupbox within w_act_rollos_libera
end type
end forward

global type w_act_rollos_libera from w_base_simple
integer width = 3365
integer height = 2028
string title = "Actualizar Rollos"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_actualizar cb_actualizar
cb_salir cb_salir
cb_insertar cb_insertar
cb_borrar cb_borrar
gb_1 gb_1
end type
global w_act_rollos_libera w_act_rollos_libera

on w_act_rollos_libera.create
int iCurrent
call super::create
this.cb_actualizar=create cb_actualizar
this.cb_salir=create cb_salir
this.cb_insertar=create cb_insertar
this.cb_borrar=create cb_borrar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_actualizar
this.Control[iCurrent+2]=this.cb_salir
this.Control[iCurrent+3]=this.cb_insertar
this.Control[iCurrent+4]=this.cb_borrar
this.Control[iCurrent+5]=this.gb_1
end on

on w_act_rollos_libera.destroy
call super::destroy
destroy(this.cb_actualizar)
destroy(this.cb_salir)
destroy(this.cb_insertar)
destroy(this.cb_borrar)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
//IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
//	Close(This)
//END IF

dw_maestro.InsertRow(0)
dw_maestro.SetFocus()
end event

event closequery;//no
end event

type dw_maestro from w_base_simple`dw_maestro within w_act_rollos_libera
integer y = 76
integer width = 2784
integer height = 1556
string dataobject = "dff_rollos_act_lib"
end type

event dw_maestro::itemchanged;Long ll_rollo, ll_unidades
Decimal{2} ldc_metros
Long li_centro
String ls_mensaje
n_cts_liberacion_x_proyeccion luo_consumo

//se establecen los kilos o unidades que figuran liberados y el centro del rollo
choose case dwo.name
	case 'cs_rollo'
		ll_rollo = Long(Data)
		
		IF luo_consumo.of_consumo_rollo_15(ll_rollo,ldc_metros,ll_unidades,li_centro,ls_mensaje) = -1 THEN
			MessageBox('Advertencia',ls_mensaje)
			return 2
		END IF
		
		dw_maestro.SetItem(row,'ca_mt',ldc_metros)
		dw_maestro.SetItem(row,'ca_unidades',ll_unidades)
		dw_maestro.SetItem(row,'co_centro',li_centro)
		
		dw_maestro.InsertRow(0)
		
end choose

end event

type cb_actualizar from commandbutton within w_act_rollos_libera
integer x = 2958
integer y = 516
integer width = 343
integer height = 100
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualizar"
end type

event clicked;//metodo para actualizar los metros y unidades de los rollos que figuran con datos liberados
//pero que ya no tienen liberaciones asociadas.
//jcrm
//febrero 13 de 2009
Long li_fila, li_centro
Long ll_rollo, ll_unidades
String ls_mensaje
Decimal{2} ldc_metros
n_cts_liberacion_x_proyeccion luo_consumo
SetPointer(HourGlass!)


//se recoren los rollos que deben ser modificados
FOR li_fila = 1 TO dw_maestro.RowCount()
	ll_rollo = dw_maestro.GetItemNumber(li_fila,'cs_rollo')
	
	IF IsNull(ll_rollo) THEN
		dw_maestro.DeleteRow(li_fila)
		Continue
	END IF
	
	li_centro = dw_maestro.GetItemNumber(li_fila,'co_centro')
	IF li_centro = 15 THEN
		IF luo_consumo.of_act_rollos_mt_unidades(ll_rollo,ls_mensaje) = 0 THEN
			dw_maestro.SetItem(li_fila,'marca',1)
		ELSE
			dw_maestro.SetItem(li_fila,'marca',0)
			dw_maestro.SetItem(li_fila,'observaciones',ls_mensaje)
		END IF
	ELSE
		dw_maestro.SetItem(li_fila,'marca',0)
		dw_maestro.SetItem(li_fila,'observaciones','El rollo no se encuentra en BTT')
	END IF
NEXT	


Commit;
//se colocan los datos nuevamente.
FOR li_fila = 1 TO dw_maestro.RowCount()
	ll_rollo = dw_maestro.GetItemNumber(li_fila,'cs_rollo')
	luo_consumo.of_consumo_rollo_15(ll_rollo,ldc_metros,ll_unidades,li_centro,ls_mensaje) 
			
	dw_maestro.SetItem(li_fila,'ca_mt',ldc_metros)
	dw_maestro.SetItem(li_fila,'ca_unidades',ll_unidades)
	dw_maestro.SetItem(li_fila,'co_centro',li_centro)
NEXT
MessageBox('Fin Proceso','los rollos actualizados exitosamente figuran con cero metros y unidades, los dem$$HEX1$$e100$$ENDHEX$$s tienen la observaci$$HEX1$$f300$$ENDHEX$$n del porque no se pueden actualizar.')

end event

type cb_salir from commandbutton within w_act_rollos_libera
integer x = 2962
integer y = 720
integer width = 343
integer height = 100
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;Close(Parent) 
end event

type cb_insertar from commandbutton within w_act_rollos_libera
integer x = 2958
integer y = 108
integer width = 343
integer height = 100
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insertar"
end type

event clicked;dw_maestro.InsertRow(0)
end event

type cb_borrar from commandbutton within w_act_rollos_libera
integer x = 2958
integer y = 312
integer width = 343
integer height = 100
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Borrar"
end type

event clicked;Long li_fila, li_result


li_fila = dw_maestro.GetRow()

IF li_fila > 0 THEN
	li_result = MessageBox('Pregunta','Esta seguro de borrar la fila seleccionada.',Question!,YesNo!,2)
	
	IF li_result = 1 THEN
		dw_maestro.DeleteRow(li_fila)
	END IF
	
END IF
end event

type gb_1 from groupbox within w_act_rollos_libera
integer x = 46
integer y = 24
integer width = 2857
integer height = 1640
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

