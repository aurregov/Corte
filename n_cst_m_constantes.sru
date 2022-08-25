HA$PBExportHeader$n_cst_m_constantes.sru
forward
global type n_cst_m_constantes from nonvisualobject
end type
end forward

global type n_cst_m_constantes from nonvisualobject autoinstantiate
end type

type variables
String is_variable

Private:
	String is_mensaje, is_texto
	Decimal	idec_numerico
	
end variables

forward prototypes
public function string of_get_mensaje ()
public function long of_constante (string as_variable)
public function string of_get_texto ()
public function decimal of_get_numerico ()
end prototypes

public function string of_get_mensaje ();Return is_mensaje
end function

public function long of_constante (string as_variable);/*******************************************************************************************
Descripci$$HEX1$$f300$$ENDHEX$$n:	Instancia los valores para una constante
					
Argumentos:		
Retorna:			
Autor:			DRT$$HEX1$$a900$$ENDHEX$$
Fecha:			2004-Sep-13
********************************************************************************************/
uo_dsbase lds_constante

lds_constante = Create uo_dsbase
lds_constante.DataObject = 'd_gr_m_constantes_conf'
lds_constante.SetTransObject(SQLCA)

If lds_constante.Of_Retrieve(as_variable) > 0 Then
	is_texto = lds_constante.GetItemString(1,'texto')
	idec_numerico = lds_constante.GetItemDecimal(1,'numerico')
Else
	is_mensaje = "No existe una variable llamada " + String(as_variable) + " en m_constantes."
	Return -1
End If

Return 1

//	MODIFICACION 27-02-2007 PARA MIGRAR A KPO
//SELECT 	TEXTO,
//			numerico
//INTO		:is_texto , :idec_numerico
//FROM		m_constantes
//WHERE		VAR_NOMBRE = :as_variable ;
//
//
//CHOOSE CASE SQLCA.SQLCode
//	CASE 0
//		Return 1
//	CASE 100
//		is_mensaje= "No existe una variable llamada "+String(as_variable) + " en m_constantes."
//		Return 0
//	CASE -1
//		is_mensaje= "Ocurri$$HEX2$$f3002000$$ENDHEX$$un error buscando en m_constantes: "+ SQLCA.SQLErrText
//		Return -1
//END CHOOSE
end function

public function string of_get_texto ();Return is_texto
end function

public function decimal of_get_numerico ();Return idec_numerico
end function

on n_cst_m_constantes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_m_constantes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

