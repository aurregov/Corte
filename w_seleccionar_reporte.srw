HA$PBExportHeader$w_seleccionar_reporte.srw
forward
global type w_seleccionar_reporte from w_base_buscar_lista
end type
end forward

shared variables

end variables

global type w_seleccionar_reporte from w_base_buscar_lista
integer x = 0
integer y = 0
integer width = 2094
integer height = 1232
string title = "Reportes"
end type
global w_seleccionar_reporte w_seleccionar_reporte

type variables

end variables

on w_seleccionar_reporte.create
call super::create
end on

on w_seleccionar_reporte.destroy
call super::destroy
end on

event open;Long li_perfil
long ll_numero_registros

This.X = 1
This.Y = 1
This.Width = 2094
This.Height = 1233
IF dw_lista.settransobject(SQLCA)= -1 THEN
	messagebox("Error Datawindow","No se pudo conectar esta ventana a la base de datos",exclamation!,ok!)
ELSE
	ll_numero_registros = dw_lista.retrieve(gstr_info_usuario.codigo_aplicacion)
	CHOOSE CASE ll_numero_registros 
		CASE -1
			MessageBox("Error datawindow","No pudo traer datos",stopsign!,ok!)
		CASE 0
			il_fila_actual = 0
			st_numero_registros.text=string(ll_numero_registros) + " registros recuperados"
		CASE ELSE
			st_numero_registros.text = String(ll_numero_registros) + " registros recuperados"
			dw_lista.setrow(1)
			dw_lista.selectrow(1,true)
			il_fila_actual = 1
	END CHOOSE
END IF
dw_lista.modify("dw_lista.readonly=yes")
dw_lista.setfocus()
// DEBE MOSTRAR SOLO LOS REPORTES PERMITIDOS PARA EL PERFIL DEL
// USUARIO QUE ABRIO ESTA VENTANA
li_perfil = gstr_info_usuario.codigo_perfil
dw_lista.SetFilter("#5 = 0 or #5 = "+String(li_perfil))
dw_lista.Filter()
end event

type st_numero_registros from w_base_buscar_lista`st_numero_registros within w_seleccionar_reporte
boolean visible = false
integer x = 1449
integer y = 44
end type

type pb_cancelar from w_base_buscar_lista`pb_cancelar within w_seleccionar_reporte
integer x = 1472
integer y = 208
integer width = 581
integer height = 152
end type

event pb_cancelar::clicked;Close(Parent)
end event

type pb_aceptar from w_base_buscar_lista`pb_aceptar within w_seleccionar_reporte
integer x = 1472
integer y = 20
integer width = 581
integer height = 152
string text = "&Mostrar Reporte"
end type

event pb_aceptar::clicked;call super::clicked;String ls_datawindow_seleccionado, ls_wparametros
s_base_parametros s_parametros

// DEBE RECONOCER CUAL FUE EL REPORTE SELECCIONADO Y DEBE ABRIR UNA
// VENTANA QUE MUESTRE EL REPORTE
ls_datawindow_seleccionado = Trim(dw_lista.GetItemString(il_fila_actual, "de_datawindow"))
ls_wparametros					= Trim(dw_lista.GetItemString(il_fila_actual, "de_wparametros"))

s_parametros.cadena[1] = ls_datawindow_seleccionado
s_parametros.cadena[2] = ls_wparametros

OpenSheetWithParm(w_preview_de_impresion, s_parametros, w_principal, 1, Layered!)

// CUANDO SE NECESITE SELECCIONAR UN REPORTE QUE TENGA PARAMETROS, SE 
// DEBE ABRIR UNA VENTANA DE RESPONSE ESPECIFICA QUE LOS PIDA, EN VEZ
// DE ABRIR w_preview_de_impresion, OBVIAMENTE ESA VENTANA DE RESPONSE
// DEBE ABRIR w_preview_de_impresion, ENVIANDOLE LOS PARAMETROS 
// SELECCIONADOS DE ACUERDO A COMO SE INDICA EN EL OPEN DE 
// w_preview_de_impresion

//	CUANDO NECESITE HEREDAR DESDE ESTA VENTANA DEBIDO A CAMBIO DE MENU,
//	DEBE PONER ESTE EVENTO OVERRIDE EN LA HEREDADA Y COPIAR TODO EL 
//	CODIGO CAMBIANDOLE EL NOMBRE DE LA VENTANA A ABRIR
end event

type dw_lista from w_base_buscar_lista`dw_lista within w_seleccionar_reporte
integer x = 23
integer y = 16
integer width = 1367
integer height = 1108
string dataobject = "dtb_seleccionar_reporte"
boolean hscrollbar = false
end type

