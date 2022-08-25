HA$PBExportHeader$n_cts_validarestadoficha.sru
forward
global type n_cts_validarestadoficha from nonvisualobject
end type
end forward

global type n_cts_validarestadoficha from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_validarfichaactiva (long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color)
end prototypes

public function long of_validarfichaactiva (long ai_fab, long ai_lin, long al_ref, long ai_talla, long al_color);//metodo para determinar el estado de la ficha
//jcrm
//noviembre 1 de 2007
Long ll_count
String ls_error

SELECT count(*)
  INTO :ll_count
  FROM dt_color_modelo
 WHERE co_fabrica 	= :ai_fab AND
 		 co_linea 		= :ai_lin AND
		 co_referencia	= :al_ref AND
		 co_talla		= :ai_talla AND
		 co_color_pt	= :al_color AND
		 co_calidad		= 1 AND
		 id_ficha		<> '1';
		 
IF sqlca.sqlcode = -1 THEN
	ls_error = sqlca.SqlErrText
	Rollback;
	MessageBox('Error','Ocurri$$HEX2$$f3002000$$ENDHEX$$un error al momento de validar el estado de la ficha, ERROR: '+ls_error,StopSign!)
	Return -1
END IF

IF ll_count > 0 THEN
	Rollback;
	MessageBox('Error','La ficha no se encuentra activa, para la talla: '+String(ai_talla)+', en el color: '+String(al_color),StopSign!)
	Return -1
END IF

Return 0
end function

on n_cts_validarestadoficha.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_validarestadoficha.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

