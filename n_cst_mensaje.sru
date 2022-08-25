HA$PBExportHeader$n_cst_mensaje.sru
forward
global type n_cst_mensaje from nonvisualobject
end type
end forward

global type n_cst_mensaje from nonvisualobject
end type
global n_cst_mensaje n_cst_mensaje

type variables
String is_titulo
String is_campos[]
Any ia_valores[]
Long ii_cant = 0
Icon icono = Exclamation!
Button boton = ok!
end variables

forward prototypes
public function long of_mensaje (string as_titulo, string as_msn, s_base_parametros asp_parametros, string as_fin)
public function long of_set_campo (string as_campo, any aa_valor)
public function long of_mensaje (string as_titulo, string as_msn_inicial, string as_msn_final)
end prototypes

public function long of_mensaje (string as_titulo, string as_msn, s_base_parametros asp_parametros, string as_fin);/*
Funci$$HEX1$$f300$$ENDHEX$$n para dar formato a los mensajes que se muestran al usuario.

Parametros:

as_titulo:		Titulo del mensaje
as_msn:			Primer texto del mensaje que se muestra
asp_parametros: Campos que se desean mostrar en el mensaje, en cadena[] estan los encabezados y en Any[] los valores.
as_fin:			Mensaje Final que se muestra despues de los campos

Ej:
as_titulo = 'Error'
as_msn = 'Ocurrio un error:'
asp_parametros.Cadena[1] = 'Param1'
asp_parametros.Cadena[2] = 'Param2'
asp_parametros.Any[1] = 1
asp_parametros.Any[2] = 2
as_fin = 'Verifique el error'
-------------------------
| Error						|
|-----------------------|
| Ocurrio un error:		|
| Param1	Param2			|
| 1		2					|
| Verifique el error		|
-------------------------
*/

String ls_mensaje, ls_formato, ls_valores[], ls_campos[]
Long li_i, li_tamano, li_max_linea = 500


If Len(as_msn) > 0 Then
	ls_mensaje = as_msn + '~r~n'
End If

// Se da formato a los nombres
For li_i = 1 To UpperBound(asp_parametros.Cadena)
	// si es nulo se pon una cadena vacia
	If IsNull (asp_parametros.Cadena[li_i]) Then
		ls_campos[li_i] = ''
	Else
		ls_campos[li_i] = asp_parametros.Cadena[li_i]
	End If
Next

// Se da formato de string a los valores
For li_i = 1 To UpperBound(asp_parametros.Any)
	// si es nulo se pone el texto NULL
	If IsNull (asp_parametros.Any[li_i]) Then
		ls_valores[li_i] = 'NULL'
	Else
		ls_valores[li_i] = Trim (String (asp_parametros.Any[li_i]) )
	End If
Next

// nombre de los campos
For li_i = 1 To UpperBound(asp_parametros.Cadena)
	If li_i > 1 Then	ls_mensaje += '~t'	
	ls_mensaje += ls_campos[li_i]
Next
ls_mensaje += '~r~n'
// los valores de los campos
For li_i = 1 To UpperBound(asp_parametros.Any)
	If li_i > 1 Then	ls_mensaje += '~t'
	ls_mensaje += ls_valores[li_i]
Next

If Len(as_fin) > 0 Then
	ls_mensaje += '~r~n~n' + as_fin
End If

MessageBox(as_titulo, ls_mensaje )

Return 1


end function

public function long of_set_campo (string as_campo, any aa_valor);ii_cant ++
// si es nulo se pon una cadena vacia
If IsNull (as_campo) Then
	is_campos[ii_cant] = ''
Else
	is_campos[ii_cant] = as_campo
End If

// si es nulo se pone el texto NULL
If IsNull (aa_valor) Then
	ia_valores[ii_cant] = 'NULL'
Else
	ia_valores[ii_cant] = Trim (String (aa_valor) )
End If

Return 1
end function

public function long of_mensaje (string as_titulo, string as_msn_inicial, string as_msn_final);String ls_mensaje
Long li_i

If Len(as_msn_inicial) > 0 Then
	ls_mensaje = as_msn_inicial 
End If
If ii_cant > 0 Then
	ls_mensaje += '~r~n'
	// nombre de los campos
	For li_i = 1 To ii_cant
		If li_i > 1 Then	ls_mensaje += '~t'	
		ls_mensaje += is_campos[li_i]
	Next
	ls_mensaje += '~r~n'
	// los valores de los campos
	For li_i = 1 To ii_cant
		If li_i > 1 Then	ls_mensaje += '~t'
		ls_mensaje += ia_valores[li_i]
	Next
	
End If

If Len(as_msn_final) > 0 Then
	ls_mensaje += '~r~n~n' + as_msn_final
End If

MessageBox(as_titulo, ls_mensaje, icono, boton )

Return 1
end function

on n_cst_mensaje.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_mensaje.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

