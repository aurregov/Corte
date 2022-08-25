HA$PBExportHeader$n_cts_constantes.sru
forward
global type n_cts_constantes from nonvisualobject
end type
end forward

global type n_cts_constantes from nonvisualobject
end type
global n_cts_constantes n_cts_constantes

forward prototypes
public function long of_consultar_numerico (string as_constante)
public function string of_consultar_texto (string as_constante)
public function decimal of_consultar_decimal (string as_constante)
end prototypes

public function long of_consultar_numerico (string as_constante);Long li_valor

SELECT numerico
INTO :li_valor
FROM m_constantes
WHERE var_nombre = :as_constante;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Advertencia!","Hubo un error al buscar el tipo de producto.~n~n~nNota: " + SQLCA.SQLErrText)
	Return(-1)
ELSE
	IF SQLCA.SQLCode = 100 THEN
		MessageBox("Advertencia!","No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante " + as_constante)
		Return(-1)
	ELSE
		Return(li_valor)
	END IF
END IF

end function

public function string of_consultar_texto (string as_constante);String ls_valor

SELECT texto
INTO :ls_valor
FROM m_constantes
WHERE var_nombre = :as_constante;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Advertencia!","Hubo un error al buscar el tipo de producto.~n~n~nNota: " + SQLCA.SQLErrText)
	Return("")
ELSE
	IF SQLCA.SQLCode = 100 THEN
		MessageBox("Advertencia!","No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante " + as_constante)
		Return("")
	ELSE
		Return(ls_valor)
	END IF
END IF
end function

public function decimal of_consultar_decimal (string as_constante);Dec ld_valor

SELECT numerico
INTO :ld_valor
FROM m_constantes
WHERE var_nombre = :as_constante;
IF SQLCA.SQLCode = -1 THEN
	MessageBox("Advertencia!","Hubo un error al buscar el tipo de producto.~n~n~nNota: " + SQLCA.SQLErrText)
	Return(-1)
ELSE
	IF SQLCA.SQLCode = 100 THEN
		MessageBox("Advertencia!","No se encontr$$HEX2$$f3002000$$ENDHEX$$la constante " + as_constante)
		Return(-1)
	ELSE
		Return(ld_valor)
	END IF
END IF

end function

on n_cts_constantes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_constantes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

