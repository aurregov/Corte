HA$PBExportHeader$n_cts_orden_segundo_loteo.sru
forward
global type n_cts_orden_segundo_loteo from nonvisualobject
end type
end forward

global type n_cts_orden_segundo_loteo from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_marcaloteo (long al_orden_corte)
end prototypes

public function long of_marcaloteo (long al_orden_corte);//metodo para colocar marca a la orden de corte y saber si se trata de un segundo
//loteo.
//0 o nulo se trata de una orden sin segundo loteo
//1 orden con segundo loteo sin lotear
//2 orden con segundo loteo loteado
//jcrm
//abril 17 de 2007
Long li_estado, li_count
String ls_error


//se debe saber el valor del loteo en el momento.
SELECT co_estado_loteo
  INTO :li_estado
  FROM h_ordenes_corte
 WHERE cs_orden_corte = :al_orden_corte;
 
 
IF li_estado = 0 Or IsNull(li_estado) Then
	//se debe verificar si hay bolsas loteadas por debajo de las unidades programadas
	SELECT count(*)
	  INTO :li_count
	  FROM dt_canasta_corte
	 WHERE cs_orden_corte = :al_orden_corte AND
	       ca_actual < ca_inicial;
			 
	IF li_count > 1 Then		 
		li_estado = 1
	Else
		li_estado = 0
	END IF
ElseIf li_estado = 1 Then
	li_estado = 2
End if

UPDATE h_ordenes_corte
   SET co_estado_loteo = :li_estado
 WHERE cs_orden_corte = :al_orden_corte;
 
  IF SQLCA.SQLCODE <> 0 THEN
	ls_error = sqlca.SqlErrText
	ROLLBACK;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar h_ordenes_corte. '+ls_error)
	Return -1
 END IF
 


Return 0

end function

on n_cts_orden_segundo_loteo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_orden_segundo_loteo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

