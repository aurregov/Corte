HA$PBExportHeader$n_cts_constantes_tela.sru
forward
global type n_cts_constantes_tela from nonvisualobject
end type
end forward

global type n_cts_constantes_tela from nonvisualobject autoinstantiate
end type

forward prototypes
public function long of_consultar_numerico (string as_constante)
public function string of_consultar_texto (string as_constante)
end prototypes

public function long of_consultar_numerico (string as_constante);Long li_valor

SELECT numerico
INTO :li_valor
FROM m_constant_tela
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
FROM m_constant_tela
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

on n_cts_constantes_tela.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cts_constantes_tela.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

