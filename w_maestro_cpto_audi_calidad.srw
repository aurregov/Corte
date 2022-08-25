HA$PBExportHeader$w_maestro_cpto_audi_calidad.srw
forward
global type w_maestro_cpto_audi_calidad from w_base_simple
end type
type gb_1 from groupbox within w_maestro_cpto_audi_calidad
end type
end forward

global type w_maestro_cpto_audi_calidad from w_base_simple
integer width = 2263
integer height = 1684
string title = "Conceptos Auditoria de Calidad"
gb_1 gb_1
end type
global w_maestro_cpto_audi_calidad w_maestro_cpto_audi_calidad

on w_maestro_cpto_audi_calidad.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_maestro_cpto_audi_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event open;call super::open;dw_maestro.Retrieve()
end event

event ue_insertar_maestro;long ll_fila

CHOOSE CASE wf_detectar_cambios (dw_maestro)
	CASE -1
		is_cambios = "error"
		is_accion = "nada"
		RETURN
	CASE 0
		is_cambios = "no"
		is_accion = "nada"
		//No ejecuta ninguna accion
	CASE 1
		is_cambios = "si"	
		CHOOSE CASE MessageBox("Cambios detectados","Desea grabar los cambios en el maestro",Question!,YesNoCancel!)
			CASE 1
				is_accion = "grabo"
				This.TriggerEvent("ue_grabar")
			CASE 2
				dw_maestro.Reset()
				is_accion = "no grabo"
				// NO GRABA Y SIGUE LA INSERCION
			CASE 3
				is_accion = "cancelo"
				RETURN
		END CHOOSE
END CHOOSE

//dw_maestro.Reset()
ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF


   

end event

type dw_maestro from w_base_simple`dw_maestro within w_maestro_cpto_audi_calidad
integer y = 48
integer width = 2085
integer height = 1412
string dataobject = "dgr_maestro_cpto_audi_calidad"
end type

type gb_1 from groupbox within w_maestro_cpto_audi_calidad
integer x = 41
integer y = 8
integer width = 2153
integer height = 1472
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

