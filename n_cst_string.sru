HA$PBExportHeader$n_cst_string.sru
forward
global type n_cst_string from nonvisualobject
end type
end forward

global type n_cst_string from nonvisualobject
end type
global n_cst_string n_cst_string

forward prototypes
public function string of_globalreplace (string as_source, string as_old, string as_new, boolean ab_ignorecase)
public function string of_globalreplace (string as_source, string as_old, string as_new)
public subroutine of_convertirstring_array (string as_texto, ref long array[])
end prototypes

public function string of_globalreplace (string as_source, string as_old, string as_new, boolean ab_ignorecase);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_GlobalReplace
//
//	Access:  		public
//
//	Arguments:
//	as_Source		The string being searched.
//	as_Old			The old string being replaced.
//	as_New			The new string.
// ab_IgnoreCase	A boolean stating to ignore case sensitivity.
//
//	Returns:  		string
//						as_Source with all occurrences of as_Old replaced with as_New.
//						If any argument's value is NULL, function returns NULL.
//
//	Description:  	Replace all occurrences of one string inside another with
//						a new string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Long	ll_Start
Long	ll_OldLen
Long	ll_NewLen
String ls_Source

//Check parameters
If IsNull(as_source) or IsNull(as_old) or IsNull(as_new) or IsNull(ab_ignorecase) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//Get the string lenghts
ll_OldLen = Len(as_Old)
ll_NewLen = Len(as_New)

//Should function respect case.
If ab_ignorecase Then
	as_old = Lower(as_old)
	ls_source = Lower(as_source)
Else
	ls_source = as_source
End If

//Search for the first occurrence of as_Old
ll_Start = Pos(ls_Source, as_Old)

Do While ll_Start > 0
	// replace as_Old with as_New
	as_Source = Replace(as_Source, ll_Start, ll_OldLen, as_New)
	
	//Should function respect case.
	If ab_ignorecase Then 
		ls_source = Lower(as_source)
	Else
		ls_source = as_source
	End If
	
	// find the next occurrence of as_Old
	ll_Start = Pos(ls_Source, as_Old, (ll_Start + ll_NewLen))
Loop

Return as_Source

end function

public function string of_globalreplace (string as_source, string as_old, string as_new);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_GlobalReplace
//
//	Access:  		public
//
//	Arguments:
//	as_Source		The string being searched.
//	as_Old			The old string being replaced.
//	as_New			The new string.
// 
//Returns:  		string
//						as_Source with all occurrences of as_Old replaced with as_New.
//						If any argument's value is NULL, function returns NULL.
//
//	Description:  	Replace all occurrences of one string inside another with
//						a new string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//Check parameters

If IsNull(as_source) or IsNull(as_old) or IsNull(as_new) Then
	string ls_null
	SetNull(ls_null)
	Return ls_null
End If

//The default is to ignore Case
as_Source = of_GlobalReplace (as_source, as_old, as_new, True)

Return as_Source


end function

public subroutine of_convertirstring_array (string as_texto, ref long array[]);/********************************************************************
SA51561 Ceiba/JJ - of_convertirString_Array 
<DESC> Description: Permite convertir una cadena de caracteres en un arreglo de numeros</DESC> 
<RETURN> Sin retorno
<ACCESS> Private 
<ARGS> 	as_texto: Cadena de numeros separados por comas 
			array[]: contiene el arreglo con los numeros, ya procesados, esta por referencia 
</ARGS> 
NOTA: Aunque en general existe otro servicio string esta no se eliminar es utilizada por corte 
********************************************************************/
String string_act, ls_mensaje
Long arraylen, stringlen, pos_coma, i, place_tt

stringlen = len(as_texto)
DO WHILE  stringlen > 0 
	pos_coma = pos(as_texto, ",")
	IF pos_coma > 0 THEN
		place_tt = pos_coma - 1
		string_act = Mid(as_texto,0,place_tt)
		as_texto = RIGHT(as_texto,stringlen - pos_coma)
		stringlen = stringlen - pos_coma
	ELSE
		string_act = as_texto
		as_texto = RIGHT(as_texto,stringlen - pos_coma)
		stringlen = 0
	END IF
	string_act = trim(string_act)
	arraylen = UpperBound(array)
	array[arraylen+1] = Long(string_act)
LOOP

end subroutine

on n_cst_string.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_string.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

