HA$PBExportHeader$n_cst_configuracion_kpo.sru
forward
global type n_cst_configuracion_kpo from nonvisualobject
end type
end forward

global type n_cst_configuracion_kpo from nonvisualobject
end type
global n_cst_configuracion_kpo n_cst_configuracion_kpo

type variables

uo_dsbase ids_configuracion
end variables

forward prototypes
public function long of_cargar_configuracion (string as_configuracion)
public function long of_validar_datos (string as_campo, string as_dato)
end prototypes

public function long of_cargar_configuracion (string as_configuracion);
//carga los datos de la configuracion que entra como parametro
If ids_configuracion.Of_Retrieve(as_configuracion) < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","No se logro cargar la configuracion " + Trim(as_configuracion), StopSign!)
	Return -1
End If

Return 1
end function

public function long of_validar_datos (string as_campo, string as_dato);
//funcion para validar si el dato por parametro existe en el campo que se indica tambien por parametro, 
//retorna 1 si encuentra el dato y 0 si no esta

Long ll_reg


//mira si el campo es numero o cadena
If Pos(as_campo,"entero") > 0 Then
	ll_reg = ids_configuracion.Find(trim(as_campo) + " = " + trim(as_dato) &
													, 1, ids_configuracion.RowCount() + 1)
Else
	ll_reg = ids_configuracion.Find(trim(as_campo) + " = '" + trim(as_dato) + "'" &
													, 1, ids_configuracion.RowCount() + 1)
End if


		
//	Si encontro registro de configuracion
If ll_reg > 0 Then
	Return 1
Elseif ll_reg = 0 Then
	Return 0
ElseIf ll_reg < 0 Then
	MessageBox("Atenci$$HEX1$$f300$$ENDHEX$$n","Fallo la busqueda del registro de configuracion, Por favor avisar a informatica", StopSign!)
	Return -1
End If

Return 1
end function

event constructor;ids_configuracion = Create uo_dsbase
ids_configuracion.DataObject = 'd_gr_cf_configuracion_kpo'
ids_configuracion.SetTRansObject(gnv_recursos.of_get_transaccion_sucia())
end event

on n_cst_configuracion_kpo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_configuracion_kpo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Destroy ids_configuracion
end event

