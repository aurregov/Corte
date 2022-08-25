HA$PBExportHeader$n_cts_descripciones.sru
forward
global type n_cts_descripciones from nonvisualobject
end type
end forward

global type n_cts_descripciones from nonvisualobject autoinstantiate
end type

forward prototypes
public function string of_proveedor (long al_codigo)
public function string of_producto (long al_codigo)
public function string of_cliente (long al_codigo)
public function string of_recursos_tejido (long al_codigo)
public function string of_tela (long al_codigo)
public function string of_linea (long al_codigo)
public function string of_fabrica (long ai_fabrica)
public function string of_referencia (long al_referencia, long al_fab, long al_lin)
public function string of_proceso (long al_codigo)
public function string of_muestrario (long al_codigo)
public function string of_marca (string as_codigo)
public function string of_color (long al_color)
end prototypes

public function string of_proveedor (long al_codigo);String ls_descripcion

SELECT nitnom
  INTO :ls_descripcion
  FROM vw_proveedores
 WHERE co_proveedor = :al_codigo;

IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el proveedor, ERROR: '+sqlca.SqlErrText)
	return ''
End if

Return ls_descripcion
end function

public function string of_producto (long al_codigo);String ls_descripcion

SELECT de_producto
  INTO :ls_descripcion
  FROM m_empaques_gbi m_matprimas
 WHERE co_producto = :al_codigo;
 
IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el proveedor, ERROR: '+sqlca.SqlErrText)
	return ''
End if

Return ls_descripcion
end function

public function string of_cliente (long al_codigo);String ls_descripcion

SELECT razon_social
  INTO :ls_descripcion
  FROM cc_cliente
 WHERE co_cliente =:al_codigo;

IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el cliente, ERROR: '+sqlca.SqlErrText)
	return ''
End if		  
		  
Return ls_descripcion		  
end function

public function string of_recursos_tejido (long al_codigo);String ls_descripcion

SELECT de_recurso
  INTO :ls_descripcion
  FROM m_recursos_tj_pre
 WHERE co_recurso = :al_codigo ;
 
IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el recurso, ERROR: '+sqlca.SqlErrText)
	return ''
End if
 

Return ls_descripcion
end function

public function string of_tela (long al_codigo);String ls_descripcion
Long	li_estado

SELECT de_reftel, co_estado_tela
  INTO :ls_descripcion, :li_estado
  FROM h_telas_pre
 WHERE co_reftel = :al_codigo; 

IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la tela, ERROR: '+sqlca.SqlErrText)
	return ''
End if

//IF li_estado = 1 THEN
//	MessageBox('Advertencia','La tela que esta programando aun se encuentra en desarrollo. Debe ser activada por la planta de desarrollo')
//	return ''
//END IF

return ls_descripcion

end function

public function string of_linea (long al_codigo);String ls_descripcion

SELECT FIRST 1 de_linea	
  INTO :ls_descripcion
  FROM m_lineas
 WHERE co_linea = :al_codigo;  

IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la l$$HEX1$$ed00$$ENDHEX$$nea, ERROR: '+sqlca.SqlErrText)
	return ''
End if

Return ls_descripcion
end function

public function string of_fabrica (long ai_fabrica);String ls_descripcion, ls_error

SELECT de_fabrica
  INTO :ls_descripcion
  FROM m_fabricas
 WHERE co_fabrica = :ai_fabrica;
 
If sqlca.sqlcode = -1 Then
	ls_error = sqlca.SqlErrText
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar la fabrica, ERROR: '+ls_error)
End if
 
Return ls_descripcion
end function

public function string of_referencia (long al_referencia, long al_fab, long al_lin);//Funcion para retornar la referencia de un producto
//dependiento del codigo de la fabrica y del codigo de
//la linea digitados
//recibe 3 parametros, referencia, fabrica y linea
//retorna la descripcion correspondiente al codigo
//de la referencia
//Angela Nore$$HEX1$$f100$$ENDHEX$$a sep/2006

String ls_descripcion, ls_referencia

ls_referencia = string(al_referencia)

SELECT max (de_referencia)
  INTO :ls_descripcion
  FROM h_preref_pv
 WHERE (co_referencia = :ls_referencia) and
       ( h_preref_pv.co_tipo_ref = 'P') and      
 		 (:al_fab = 0  OR h_preref_pv.co_fabrica = :al_fab)  and
		 (:al_lin = 0  OR h_preref_pv.co_linea = :al_lin);    

IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la referencia, ERROR: '+sqlca.SqlErrText)
	return ''
End if		  
		  
Return ls_descripcion		
end function

public function string of_proceso (long al_codigo);String ls_descripcion

SELECT max(de_ruta_pdn)
  INTO :ls_descripcion
  FROM dt_proceso_ruta
 WHERE cs_proceso_ruta = :al_codigo;
 
IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el proveedor, ERROR: '+sqlca.SqlErrText)
	return ''
End if

Return ls_descripcion
end function

public function string of_muestrario (long al_codigo);String ls_descripcion

SELECT MAX(de_muestrario)
  INTO :ls_descripcion
  FROM m_muestrarios
  WHERE co_muestrario = :al_codigo;
 
IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar el proveedor, ERROR: '+sqlca.SqlErrText)
	return ''
End if

Return ls_descripcion
end function

public function string of_marca (string as_codigo);String ls_descripcion

SELECT de_marca
  INTO :ls_descripcion
  FROM m_marcas_prnda
 WHERE co_marca = :as_codigo;  

IF sqlca.sqlcode = -1 Then
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al consultar la marca, ERROR: '+sqlca.SqlErrText)
	return ''
End if

Return ls_descripcion
end function

public function string of_color (long al_color);String ls_descripcion, ls_error

SELECT de_color
  INTO :ls_descripcion
  FROM m_color
 WHERE co_color = :al_color;
 
If sqlca.sqlcode = -1 Then
	ls_error = sqlca.SqlErrText
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el color, ERROR: '+ls_error)
End if 



Return ls_descripcion
end function

on n_cts_descripciones.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_descripciones.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

