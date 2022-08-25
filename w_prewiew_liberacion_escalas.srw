HA$PBExportHeader$w_prewiew_liberacion_escalas.srw
forward
global type w_prewiew_liberacion_escalas from w_preview_de_impresion
end type
end forward

global type w_prewiew_liberacion_escalas from w_preview_de_impresion
integer width = 3561
event guardar_como pbm_custom08
end type
global w_prewiew_liberacion_escalas w_prewiew_liberacion_escalas

type variables

Long il_liberacion
end variables

event guardar_como;long	ll_filas

ll_filas = dw_reporte.RowCount()

IF ll_filas <=0 THEN
	MessageBox("Generar archivo","Error al generar el archivo",Exclamation!)
	Return
ELSE
	dw_reporte.SaveAs("",PSReport! ,false)
END IF
end event

on w_prewiew_liberacion_escalas.create
call super::create
end on

on w_prewiew_liberacion_escalas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;s_base_parametros s_parametros
String ls_nombredw, ls_wparametros,ls_grupo
LONG ll_liberacion


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 



s_parametros = Message.PowerObjectParm

s_parametros = Message.PowerObjectParm

IF s_parametros.hay_parametros = TRUE THEN
	//ls_grupo 	= s_parametros.cadena[1]
	ll_liberacion 	= s_parametros.entero[1]
	
	
	dw_reporte.Retrieve(ll_liberacion)
	
	il_liberacion = ll_liberacion
ELSE
	messagebox(this.title,'No existen par$$HEX1$$e100$$ENDHEX$$metros de b$$HEX1$$fa00$$ENDHEX$$squeda.')
	return -1
END IF

dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")










end event

event close;call super::close;//TRANSACTION			itr_tela
//
//DISCONNECT USING itr_tela ;
//IF itr_tela.SQLCODE=-1 THEN
//	MessageBox("Error base datos","No pudo desconectar de proceso")
//	RETURN 0
//ELSE 
//END IF
//
end event

event ue_imprimir;
Long ll_ret, ll_band, ll_impresiones
uo_dsbase lds_nro_impresion

lds_nro_impresion = Create uo_dsbase
lds_nro_impresion.DataObject = 'd_gr_dt_pdnxmodulo_impresion'
lds_nro_impresion.SetTransObject(SQLCA)

ll_ret = lds_nro_impresion.Of_Retrieve(il_liberacion) 

//si ocurre alg$$HEX1$$fa00$$ENDHEX$$n error
If ll_ret <= 0 Then
	Rollback;
	MessageBox("Error","Error al consultar el numero de impresiones para la liberacion "+String(il_liberacion),StopSign!)
	Return -1
	
//Si trae datos 
Elseif ll_ret > 0 Then
	ll_impresiones = lds_nro_impresion.GetItemNumber(1,'sw_impresion') 
	//mira si tiene impresiones
	If lds_nro_impresion.GetItemNumber(1,'sw_impresion') > 0 Then
		ll_band = MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', 'El reporte ya lo imprimi$$HEX2$$f3002000$$ENDHEX$$' + String(ll_impresiones) + &
				' veces, el ultimo usuario que imprimi$$HEX2$$f3002000$$ENDHEX$$fue ' + Trim(lds_nro_impresion.GetItemString(1,'usuario_impresion')) + &
				'. $$HEX1$$bf00$$ENDHEX$$Desea imprimir el reporte de nuevo?', Question! , YesNo!,2)
		If ll_band = 1 Then
			ll_impresiones = ll_impresiones + 1
		Else
			Return -1
		End If
	Else
		ll_impresiones = 1
	End if
	
	//actualiza datos
	lds_nro_impresion.SetItem(1,'sw_impresion', ll_impresiones)
	lds_nro_impresion.SetItem(1,'usuario_impresion', gstr_info_usuario.codigo_usuario)
	IF lds_nro_impresion.Of_Update() = -1 THEN
		ROLLBACK;
		Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos",Exclamation!,Ok!)
		RETURN -2
	ELSE
		COMMIT;
		IF SQLCA.SQLCode < 0 THEN
			Rollback;
			Messagebox("Error","No se pudo hacer los cambios en el maestro para la base de datos(Commit)",Exclamation!,Ok!)
			RETURN -3
		END IF
	END IF
	
	//imprime reporte
	dw_reporte.setFocus()
	OpenWithParm(w_opciones_impresion, dw_reporte)
End IF

Return 1
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_prewiew_liberacion_escalas
integer width = 3506
string dataobject = "r_liberacion_escalas"
end type

