HA$PBExportHeader$uo_dtwndow.sru
$PBExportComments$Control Datawindow Inteligente
forward
global type uo_dtwndow from datawindow
end type
end forward

global type uo_dtwndow from datawindow
integer width = 946
integer height = 364
integer taborder = 1
boolean vscrollbar = true
event adcnar_fla pbm_custom20
event brrar_fla pbm_custom19
event brrar_tdo_flas pbm_custom18
event on_brrar pbm_custom17
event on_insrtar pbm_custom16
event on_actlzar pbm_custom15
event ue_nvo pbm_custom01
event ue_abrir pbm_custom02
event ue_asgnar_dtos pbm_custom03
event ue_presionar_tecla pbm_dwnkey
event type long ue_retrieve ( )
event type long ue_aceptar_texto ( )
end type
global uo_dtwndow uo_dtwndow

type variables
long il_fla_slccnda
Boolean ib_insercion_automatica = False
Boolean ib_sqlpreview 		//	Propiedad utilizada para indicar que se muestre el SQL enviado a la B.D.
Boolean ib_dw_tiene_foco				//	Propiedad utilizada para identificar "foco"
end variables

forward prototypes
public function long of_retrieve ()
public function long of_getparentwindow (ref window aw_padre)
end prototypes

event ue_presionar_tecla;Long li_columnas, li_num_col, li_sigte_col
Long ll_filas, ll_fila_actual

IF Key = KeyEnter! THEN
	li_columnas = Long(This.Object.DataWindow.Column.Count)
	li_num_col = This.GetColumn()
	IF li_columnas = li_num_col THEN
		IF ib_insercion_automatica THEN
			ll_filas = This.RowCount()
			ll_fila_actual = This.GetRow()
			IF ll_filas = ll_fila_actual THEN
				Parent.TriggerEvent("ue_insertar_detalle")
			ELSE
				This.SetRow(ll_fila_actual + 1)
			END IF
			li_sigte_col = 1
			DO WHILE This.SetColumn(li_sigte_col) = -1 AND li_sigte_col <= li_columnas
				li_sigte_col = li_sigte_col + 1
			LOOP
		END IF
	ELSE
		li_sigte_col = This.GetColumn() + 1
		DO WHILE This.SetColumn(li_sigte_col) = -1 AND li_sigte_col <= li_columnas
			li_sigte_col = li_sigte_col + 1
		LOOP
	END IF
	Return(1)
END IF
end event

event type long ue_retrieve();/*	-------------------------------------------------------------------
	Evento que hace el retrieve del datawindow y sin enviar argumentos.
	Retorna la cantidad de registros recuperados de la Base de Datos.
	-------------------------------------------------------------------*/

Return This.Retrieve()
end event

event type long ue_aceptar_texto();/* ---------------------------------------------------------	
	Evento utilizado para validar la ultima entrada de datos
	del usuario en el control de edicion,cuando el Datawindow
	ya no tiene el foco
	---------------------------------------------------------*/
Long li_valor

If ib_dw_tiene_foco = False Then
	li_valor = This.AcceptText()
End If

Return li_valor
end event

public function long of_retrieve ();/*	-------------------------------------------------------------------
	Dispara el evento ue_retrieve() que hace el retrieve basico del dw
	-------------------------------------------------------------------*/
Long ll_valor

ll_valor = This.Event ue_retrieve()
Return ll_valor
end function

public function long of_getparentwindow (ref window aw_padre);/*	---------------------------------------------------------------
	Averigua cual es la ventana padre del objeto y la devuelve en
	la variable por referencia aw_padre.  Sino se tiene exito
	retorna -1 y la aw_padre es puesta en null
	---------------------------------------------------------------*/
powerobject	lpo_padre

lpo_padre = this.GetParent()
// Ciclo para obtener el padre del objeto hasta que sea de tipo Window!
Do While IsValid (lpo_padre) 
	If lpo_padre.TypeOf() <> Window! Then
		lpo_padre = lpo_padre.GetParent()
	Else
		Exit
	End If
Loop

If IsNull(lpo_padre) Or Not IsValid (lpo_padre) Then
	MessageBox("Error de Software", "No se logro Obtener la Ventana Padre" &
				+ "~nPor favor avise al Administrador de este problema", StopSign!)
	SetNull(aw_padre)	
	Return -1
End If

aw_padre = lpo_padre

Return 1
end function

event rowfocuschanged;This.SelectRow(0,FALSE)
This.SelectRow(CurrentRow,TRUE)
IF This.RowCount() = 1 THEN
This.SelectRow(0,FALSE)
END IF

end event

event dberror;s_base_parametros lstr_parametros_error

ROLLBACK;
lstr_parametros_error.cadena[1] = sqlca.dbms
lstr_parametros_error.entero[1] = SQLDBCode
lstr_parametros_error.cadena[2] = this.classname()
lstr_parametros_error.cadena[3] = Parent.Classname()
lstr_parametros_error.cadena[4] = "Error Base Datos en DataWindow"
lstr_parametros_error.cadena[5] = SQLErrText
OPENWITHPARM(w_reporte_errores,lstr_parametros_error)
RETURN(1)
end event

event itemerror;Return(1)
end event

event itemfocuschanged;String	ls_nombrecolumna, ls_tag, ls_describe

w_principal.SetMicroHelp('')

ls_nombrecolumna	=	This.GetColumnName()
ls_describe			=	This.Describe(ls_nombrecolumna+".tag")

ls_tag	=	Trim(ls_describe)

w_principal.SetMicroHelp(ls_tag)


end event

on uo_dtwndow.create
end on

on uo_dtwndow.destroy
end on

event itemchanged;// Esto toco hacerlo para que no se revienten las aplicaciones de
//	tela, material de empaque, trims, ventas de exportacion; 
//	que en ocasiones no usan estos campos de auditoria.

If Pos("a_tela a_material_empaque a_trims a_ventasexportacion a_ventas a_proceso",GetApplication().AppName) = 0 Then
	IF Row > 0 THEN
		This.SetItem(Row, "fe_actualizacion", f_fecha_servidor())
		This.SetItem(Row, "usuario", gstr_info_usuario.codigo_usuario)
		This.SetItem(Row, "instancia", gstr_info_usuario.instancia)
	END IF
End If

end event

event sqlpreview;/*	---------------------------------------------------------------------
	Despliega un mensaje con el SQL que sera enviado a la B.D. siempre y
	cuando la propiedad de ib_sqlpreview este en verdadero.   Esta propiedad
	puede ser fijada en dise$$HEX1$$f100$$ENDHEX$$o de datawindow o desde script.
	---------------------------------------------------------------------*/

If ib_sqlpreview Then messagebox("SQL enviado a la base de datos",sqlsyntax)

end event

event losefocus;/* --------------------------------------------------------------	
	Evento utilizado para validar la $$HEX1$$fa00$$ENDHEX$$ltima entrada de datos del 
	usuario en el control de edici$$HEX1$$f300$$ENDHEX$$n del Datawindow.
	--------------------------------------------------------------*/
ib_dw_tiene_foco = False
This.Event Post ue_aceptar_texto()

end event

event getfocus;/*	---------------------------------------------------------------------
	Evento utilizado para identificar si el datawindow tiene el	foco y
	para actualizar la referencia del datawindow activo (propiedad) en la 
	ventana que lo contiene.
	---------------------------------------------------------------------*/
w_base_simple lw_hoja

If of_GetParentWindow(lw_hoja) < 0 Then Return
ib_dw_tiene_foco = True
lw_hoja.idw_activo = This
lw_hoja.ParentWindow().SetMicrohelp(This.Tag)
end event

