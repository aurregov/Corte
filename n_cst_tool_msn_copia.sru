HA$PBExportHeader$n_cst_tool_msn_copia.sru
forward
global type n_cst_tool_msn_copia from nonvisualobject
end type
end forward

global type n_cst_tool_msn_copia from nonvisualobject
end type
global n_cst_tool_msn_copia n_cst_tool_msn_copia

type variables
String is_campos[]
Long ii_tama$$HEX1$$f100$$ENDHEX$$o[]
//String ls_valores[]
s_base_parametros istr_valores[]
end variables

forward prototypes
public function long of_asignar_texto (long al_row, string as_campo, string as_valor)
public function long of_limpiar_msn ()
public function string of_get_mensaje ()
public subroutine of_enviar_correo (string as_asunto, string as_contenido, long al_aplicacion) throws exception
end prototypes

public function long of_asignar_texto (long al_row, string as_campo, string as_valor);Long ll_rcampo, ll_row, li_tam

If al_row = 0 Then

Else
	ll_row = al_row	
End If


For ll_rcampo = 1 To UpperBound(is_campos)
	If is_campos[ll_rcampo] = Trim(as_campo) Then
		Exit
	End If
Next


ll_row = UpperBound(istr_valores)

If ll_rcampo > UpperBound(is_campos) Then
	is_campos[ll_rcampo] = Trim(as_campo)
	ii_tama$$HEX1$$f100$$ENDHEX$$o[ll_rcampo] = Len(Trim(as_campo))
	
End If

If ll_rcampo = 1 Then
	ll_row ++
End If



istr_valores[ll_row].Any[ll_rcampo] = Trim(as_valor)


If ii_tama$$HEX1$$f100$$ENDHEX$$o[ll_rcampo] < Len( Trim(as_valor) ) Then
	
End If

Return 1
end function

public function long of_limpiar_msn ();String ls_campos[]
Long li_tama$$HEX1$$f100$$ENDHEX$$o[]
s_base_parametros lstr_valores[]


is_campos = ls_campos
ii_tama$$HEX1$$f100$$ENDHEX$$o = li_tama$$HEX1$$f100$$ENDHEX$$o
istr_valores = lstr_valores


Return 1
end function

public function string of_get_mensaje ();Long li_i, li_j
String ls_msn, ls_campos, ls_valores


// Se da formato a los nombres
For li_i = 1 To UpperBound(is_campos)
	// si es nulo se pon una cadena vacia
	If IsNull (is_campos[li_i]) Then is_campos[li_i] = ''
	
Next


For li_i = 1 To UpperBound(istr_valores)
	// Se da formato de string a los valores
	For li_j = 1 To UpperBound(istr_valores[li_i].Any)
		// si es nulo se pone el texto NULL
		If IsNull (istr_valores[li_i].Any[li_j]) Then
			istr_valores[li_i].Any[li_j] = 'NULL'
		Else
			istr_valores[li_i].Any[li_j] = Trim (String (istr_valores[li_i].Any[li_j]) )
		End If
	Next
Next



// nombre de los campos
For li_i = 1 To UpperBound(is_campos)
	If li_i > 1 Then	ls_campos += '~t'	
	ls_campos += is_campos[li_i]
Next
//ls_mensaje += '~r~n'

For li_i = 1 To UpperBound(istr_valores)
	If li_i > 1 Then	ls_valores += '~r~n'
	// los valores de los campos
	For li_j = 1 To UpperBound(istr_valores[li_i].Any)
		If li_j > 1 Then	ls_valores += '~t'
		ls_valores += istr_valores[li_i].Any[li_j]
	Next
Next

If ls_campos <> '' Or ls_valores <> '' Then
	ls_msn = ls_campos + '~r~n' + ls_valores
End If


Return ls_msn
end function

public subroutine of_enviar_correo (string as_asunto, string as_contenido, long al_aplicacion) throws exception;
end subroutine

on n_cst_tool_msn_copia.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_tool_msn_copia.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

