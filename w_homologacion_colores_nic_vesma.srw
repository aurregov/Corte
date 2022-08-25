HA$PBExportHeader$w_homologacion_colores_nic_vesma.srw
forward
global type w_homologacion_colores_nic_vesma from w_base_simple
end type
end forward

global type w_homologacion_colores_nic_vesma from w_base_simple
integer width = 960
integer height = 1948
string title = "Homologaci$$HEX1$$f300$$ENDHEX$$n Colores Nicole Vesma"
end type
global w_homologacion_colores_nic_vesma w_homologacion_colores_nic_vesma

on w_homologacion_colores_nic_vesma.create
call super::create
end on

on w_homologacion_colores_nic_vesma.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insertar_maestro;///////////////////////////////////////////////////////////////////////
// En este evento se detecta si hubo cambios en el datawindow, para 
// asignar valores a las variables de instancia is_cambio y is_accion.
//
// Ademas, se inserta una nueva linea, se le evalua el insert y si fue
// exitoso, se posiciona en dicha fila,hace el scroll a dicha fila y
// se posiciona en la primera columna de esta fila.
////////////////////////////////////////////////////////////////////////

long ll_fila

ll_fila = dw_maestro.InsertRow(0)
IF ll_fila = -1 THEN
	MessageBox("Error datawindow","No se pudo insertar el registro del maestro",StopSign!,Ok!)
ELSE
	dw_maestro.SetRow(ll_fila)
	dw_maestro.ScrollToRow(ll_fila)
	dw_maestro.SetColumn(1)
	dw_maestro.SelectRow(0,False)
	il_fila_actual_maestro = ll_fila
	dw_maestro.SetItem(il_fila_actual_maestro, "fe_creacion", f_fecha_servidor())
END IF


   

end event

event open;This.x = 1
This.y = 1
//This.width = 
//This.height = 

dw_maestro.SetTransObject(SQLCA)
IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF

dw_maestro.Retrieve()
end event

type dw_maestro from w_base_simple`dw_maestro within w_homologacion_colores_nic_vesma
integer width = 809
integer height = 1680
string dataobject = "dgr_color_nic_vesma"
end type

event dw_maestro::itemchanged;// Esto toco hacerlo para que no se revienten las aplicaciones de
//	tela, material de empaque, trims, ventas de exportacion; 
//	que en ocasiones no usan estos campos de auditoria.
Long ll_count, ll_color

IF Row > 0 THEN
	This.SetItem(Row, "fe_creacion", f_fecha_servidor())
	This.SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
	This.SetItem(Row, "instancia", gstr_info_usuario.instancia)
END IF

choose case dwo.name
	case 'co_color_vesma'
		ll_color = Long(Data)
		
		SELECT count(*)
		  INTO :ll_count
		  FROM m_color
		 WHERE co_color = :ll_color;
		 
		IF sqlca.sqlcode = -1 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de verificar el color vesma.')
			This.SetItem(row,'co_color_vesma',0)
			Return 2
		END IF
		
		
		IF ll_count = 0 THEN
			MessageBox('Error','C$$HEX1$$f300$$ENDHEX$$digo de color vesma no existe.')
			This.SetItem(row,'co_color_vesma',0)
			Return 2
		END IF
		
end choose

end event

