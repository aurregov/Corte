HA$PBExportHeader$n_cts_devolver_trazos.sru
forward
global type n_cts_devolver_trazos from nonvisualobject
end type
end forward

global type n_cts_devolver_trazos from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_devolvertrazo (long al_agrupacion)
end prototypes

public function long of_devolvertrazo (long al_agrupacion);Long li_estado
Long ll_count

//se verifica que la agrupaci$$HEX1$$f300$$ENDHEX$$n tenga estado 2
SELECT co_estado
  INTO :li_estado
  FROM h_agrupa_pdn
 WHERE cs_agrupacion = :al_agrupacion;
 
IF sqlca.sqlcode <> 0 THEN
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar el estado de la agrupaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)
	Return -1
END IF

IF li_estado = 2 THEN
	//se procede a verificar que no tenga asociada ninguna orden de corte para regfresar el estado de la agrupaci$$HEX1$$f300$$ENDHEX$$n.
	SELECT count(*)
	  INTO :ll_count
	  FROM dt_escalasxoc
	 WHERE cs_agrupacion = :al_agrupacion;
   
	IF sqlca.sqlcode <> 0 THEN
		MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de consultar las ordenes de corte asociadas. '+ Sqlca.SqlErrText)
		Return -1
	END IF 
	 
	IF ll_count > 0 THEN
		//existen asociadas ordenes de corte por lo tanto no se puede permitir que se realize la modificaci$$HEX1$$f300$$ENDHEX$$n del estado
	   MessageBox('Error','La agrupaci$$HEX1$$f300$$ENDHEX$$n ya tiene asociadas ordenes de corte, por favor verifique sus datos.')
		Return -1
	ELSE
		//se puede realizar el cambio de estado
		UPDATE h_agrupa_pdn
		   SET co_estado = 1
		 WHERE cs_agrupacion = :al_agrupacion;
		 
		IF sqlca.sqlcode <> 0 THEN
			MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de actualizar el estado de la agrupaci$$HEX1$$f300$$ENDHEX$$n. '+ Sqlca.SqlErrText)	
			Return -1
		END IF
		
	END IF
ELSE
	//el estado no se modifica.
	MessageBox('Error','El estado de la agrupaci$$HEX1$$f300$$ENDHEX$$n no permite devolverlo, verifique sus datos.')
	Return -1
END IF

Return 0


end function

on n_cts_devolver_trazos.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_devolver_trazos.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

