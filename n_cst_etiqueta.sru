HA$PBExportHeader$n_cst_etiqueta.sru
forward
global type n_cst_etiqueta from nonvisualobject
end type
end forward

global type n_cst_etiqueta from nonvisualobject
end type
global n_cst_etiqueta n_cst_etiqueta

type variables
Long	IMPRESORA_SATO = 1, IMPRESORA_ZEBRA = 2
//SA48643 E00432 
//Constantes de nombres de impresora puestos en las etiquetas
String NOMBRE_IMPRESORA_SATO ="SATO", NOMBRE_IMPRESORA_ZEBRA="ZEBRA"
String RUTA_IMPRESORA_SATO ="RUTA_ETIQUETA_SATO_MAQ", RUTA_IMPRESORA_ZEBRA="RUTA_ETIQUETA_ZEBRA_MAQ"
String is_carpeta_impresora, is_mensaje





end variables

forward prototypes
private function long of_imprimircampos (readonly long ai_archivo, readonly string as_campo[]) throws exception
private function long of_creararchivo (readonly string as_nombreetiqueta, readonly string as_impresora, readonly string as_campos[], readonly string as_copias, readonly long ai_impresora) throws exception
public function long of_imprimiretiqueta (readonly string as_etiqueta, readonly string as_datos[], readonly long ai_impresora, readonly long al_copias) throws exception
private function long of_cargarcampos (readonly string as_etiqueta, readonly string as_datos[], ref string as_campos[]) throws exception
end prototypes

private function long of_imprimircampos (readonly long ai_archivo, readonly string as_campo[]) throws exception;/******************************************************************** 
FunctionName of_imprimircampos
SA48620
 <DESC> funcion que imprime los campos al archivo texto </DESC>
 <RETURN>none </RETURN>
 <ACCESS> Private
 <ARGS> ai_archivo : Buffer del archivo por el cual va a imprimir
        as_campos         : Campos a imprimir ya estann formateados   </ARGS>
 <USAGE> funcion llamada desde of_creararchivo </USAGE>
 ********************************************************************/
Long 	li_totalCampos, li_indice
String 	ls_dato
Exception ex
ex = create Exception
Try
	li_totalCampos = upperBound(as_campo)
	if li_totalCampos = 0 Then 
		ex.setmessage( "No hay campos a imprimir")
		Return -1
		Throw ex
	End if
	
	For li_indice = 1 to li_totalCampos
		if len(as_campo[li_indice]) > 0 Then
			ls_dato = "SET C" + right("00000" + trim(string(li_indice)),5) + '= "' + as_campo[li_indice] + '"'
			If FileWrite(ai_archivo, ls_dato) = -1 Then 
				ex.setmessage( "Al escribir en el archivo")
				Return -1
				Throw ex
			End if
		End if
	Next 
Catch (Throwable ex2)
	Return -1
	Throw ex2
End Try

Return 1

end function

private function long of_creararchivo (readonly string as_nombreetiqueta, readonly string as_impresora, readonly string as_campos[], readonly string as_copias, readonly long ai_impresora) throws exception;/******************************************************************** 
FunctionName of_creararchivo
SA48620
 <DESC> funcion que crea el archivo en la ruta y con el nombre parametrizado </DESC>
 <RETURN>none </RETURN>
 <ACCESS> Private
 <ARGS> as_nombreEtiqueta : Nombre del arte de la etiqueta
        as_impresora      : Nombre de la impresora SATO/ZEBRA
		  as_campos         : Campos a imprimir ya estann formateados
		  as_copias         : numero de copias que se imprimen</ARGS>
 <USAGE> funcion llamada desde of_imprimirEtiqueta </USAGE>
 ********************************************************************/

Long 	li_archivo
String 	ls_nombreRutaArchivo
Exception ex
n_cst_m_constantes luo_constantes
ex = create Exception

Try 
	If ai_impresora = IMPRESORA_SATO Then
		If luo_constantes.of_constante(RUTA_IMPRESORA_SATO) = -1 Then
			ex.setmessage(luo_constantes.of_get_mensaje( ))
			is_mensaje = luo_constantes.of_get_mensaje( )
			Return -1
			Throw (ex)
		End if
		ls_nombreRutaArchivo = trim(luo_constantes.of_get_texto())
	Elseif ai_impresora = IMPRESORA_ZEBRA Then
		If luo_constantes.of_constante(RUTA_IMPRESORA_ZEBRA) = -1 Then
			ex.setmessage(luo_constantes.of_get_mensaje( ))
			is_mensaje = luo_constantes.of_get_mensaje( )
			Return -1
			Throw (ex)
		End if
		ls_nombreRutaArchivo = trim(luo_constantes.of_get_texto())
	End if

	//mira si hay carpeta para la impresora para agregarla a la ruta
	If trim(is_carpeta_impresora) <> '' Then
		ls_nombreRutaArchivo = ls_nombreRutaArchivo + trim(is_carpeta_impresora) +'\'
	End if

	ls_nombreRutaArchivo += gstr_info_usuario.codigo_usuario + string(today(),'yyyy-mm-dd')+'_'+&
									string(now(),'hhmmssffffff')+'.job'
	li_archivo = FileOpen(ls_nombreRutaArchivo, LineMode!, Write!, LockWrite!, Replace!)
	
	If li_archivo < 0 Then	
		ex.setmessage( "Al abrir el archivo "+ls_nombreRutaArchivo)
		is_mensaje = "Error al abrir el archivo "+ls_nombreRutaArchivo
		FileClose(li_archivo)
		Return -1
		Throw (ex)
	End if
	//cierra el archivo para crearlo sino existe
	FileClose(li_archivo)
	
	If Not FileExists(ls_nombreRutaArchivo) Then
		ex.setmessage( "No se creo el archivo para la marquilla. Archivo "+ls_nombreRutaArchivo)
		is_mensaje = "No se creo el archivo para la marquilla. Archivo "+ls_nombreRutaArchivo
		Return -1
		Throw (ex)
	End if
	
	
	//se abre de nuevo el archivo para 
	li_archivo = FileOpen(ls_nombreRutaArchivo, LineMode!, Write!, LockWrite!, Replace!)
	
	If li_archivo < 0 Then	
		ex.setmessage( "Error Al abrir el archivo "+ls_nombreRutaArchivo)
		is_mensaje = "Error Al abrir el archivo "+ls_nombreRutaArchivo
		FileClose(li_archivo)
		Return -1
		Throw (ex)
	End if
	
	
	If FileWrite(li_archivo, 'LABEL "'+ as_nombreEtiqueta+'"') = -1 Then 
		ex.setmessage( "Al escribir en el archivo")
		is_mensaje = "Error al escribir en el archivo"
		FileClose(li_archivo)
		Return -1
		Throw (ex)
	End if
	If FileWrite(li_archivo, 'PRINTER "'+as_impresora+'"') = -1 Then 
		ex.setmessage( "Al escribir en el archivo")
		is_mensaje = "Error al escribir en el archivo"
		FileClose(li_archivo)
		Return -1
		Throw (ex)
	End if
	Try
		If This.of_imprimirCampos(li_archivo, as_campos) <= 0 Then
			ex.setmessage( "Al escribir en el archivo")
			is_mensaje = "Error al escribir en el archivo"
			FileClose(li_archivo)
			Return -1
			Throw (ex)
		End if
	Catch (Throwable ex1)
		Throw ex1
	End try
	If FileWrite(li_archivo, 'PRINT '+as_copias) = -1 Then 
		ex.setmessage( "Al escribir en el archivo")
		is_mensaje = "Error al escribir en el archivo"
		FileClose(li_archivo)
		Return -1
		Throw (ex)
	End if
	If FileWrite(li_archivo, "QUIT") = -1 Then 
		ex.setmessage( "Al escribir en el archivo")
		is_mensaje = "Error al escribir en el archivo"
		FileClose(li_archivo)
		Return -1
		Throw (ex)
	End if
	
	FileClose(li_archivo)
Catch (Throwable ex2)
	Throw ex2
	Return -1
End try

Return 1

end function

public function long of_imprimiretiqueta (readonly string as_etiqueta, readonly string as_datos[], readonly long ai_impresora, readonly long al_copias) throws exception;/******************************************************************** 
FunctionName of_imprimirEtiqueta
SA48620
 <DESC> Funcion principal para la impresion de la etiqueta </DESC>
 <RETURN>none </RETURN>
 <ACCESS> Public
 <ARGS> as_etiqueta : codigo de la etiqueta
        as_datos    : Arreglo con los datos a imprimir
		  ai_impresora: Impresora en la cual se imprime
		  al_copias   : numero de etiquetas a imprimir /si envio cero es para que tome default</ARGS>
 <USAGE> </USAGE>
 ********************************************************************/
uo_dsbase	lds_etiqueta
String 		ls_ruta, ls_impresora, ls_copias, ls_campos[]
Long		li_numeroCopias
Long			ll_filasEtiqueta
Exception ex
ex = create Exception
is_mensaje = ''
Try
	n_cst_m_constantes luo_constantes
	
	If ai_impresora = IMPRESORA_SATO Then
		If luo_constantes.of_constante("NOMBRE_IMPRESORA_SAT") = -1 Then
			ex.setmessage(luo_constantes.of_get_mensaje( ))
			is_mensaje = luo_constantes.of_get_mensaje( )
			Return -1
			Throw (ex)
		End if
		ls_impresora = trim(luo_constantes.of_get_texto())
	Elseif ai_impresora = IMPRESORA_ZEBRA Then
		If luo_constantes.of_constante("NOMBRE_IMPRESORA_ZEB") = -1 Then
			ex.setmessage(luo_constantes.of_get_mensaje( ))
			is_mensaje = luo_constantes.of_get_mensaje( )
			Return -1
			Throw (ex)
		End if
		ls_impresora = trim(luo_constantes.of_get_texto())
	End if
	
	lds_etiqueta = Create uo_dsbase
	lds_etiqueta.dataObject = 'd_sq_tb_m_etiquetas'
	lds_etiqueta.settransObject(gnv_recursos.of_get_transaccion_sucia( ))
	
	ll_filasEtiqueta = lds_etiqueta.retrieve(as_etiqueta)
	If ll_filasEtiqueta > 0 Then
		ls_ruta = trim(lds_etiqueta.GetItemString(1,'ruta'))
		li_numeroCopias = lds_etiqueta.GetItemNumber(1,'numerocopias')
		Try
			If this.of_cargarcampos(as_etiqueta,as_datos,ls_campos)	 <= 0 Then
				Destroy lds_etiqueta
				Return -1
			End if
		catch( Throwable ex1 )
			Destroy lds_etiqueta
			Return -1
			Throw ex1
		End try
	Else
		ex.setmessage( "No hay datos de etiqueta")
		is_mensaje = "No hay datos de etiqueta"
		Destroy lds_etiqueta
		Return -1
		Throw ex
	End if
	If al_copias = 0 Then
		ls_copias = right("000"+trim(string(li_numeroCopias)),3)
	Else
		ls_copias = right("000"+trim(string(al_copias)),3)
	End if
	Try
		If this.of_creararchivo( ls_ruta, ls_impresora, ls_campos, ls_copias, ai_impresora ) <= 0 Then
			Destroy lds_etiqueta
			Return -1
		End if
	Catch(Throwable ex2)
		Destroy lds_etiqueta
		Return -1
		Throw ex2
	End try

Catch (Throwable ex3)
	Return -1
	Throw ex3
End try

Destroy lds_etiqueta
Return 1
end function

private function long of_cargarcampos (readonly string as_etiqueta, readonly string as_datos[], ref string as_campos[]) throws exception;/******************************************************************** 
FunctionName of_cargarCampos
SA48620
 <DESC> Funcion que lee informacion de los campos correspondientes a la etiqueta
        para asignarlos al arreglo de impresion </DESC>
 <RETURN>none </RETURN>
 <ACCESS> Public
 <ARGS> as_etiqueta : codigo de la etiqueta
        as_datos    : Arreglo con los datos a imprimir
		  as_campos   : Arreglo formateado con los datos de configuracion </ARGS>
 <USAGE> es llamada desde of_imprimiretiqueta</USAGE>
 ********************************************************************/

uo_dsbase 	lds_camposEtiqueta
Long		ll_filasCampos, ll_fila, ll_filasArreglo
Long	li_campo, li_longitud
String ls_de_campo
Exception ex
ex = create Exception
is_mensaje = ''
Try
	lds_camposEtiqueta = Create uo_dsbase
	lds_camposEtiqueta.dataobject = 'd_sq_tb_campos_etiquetas'
	lds_camposEtiqueta.settransobject(gnv_recursos.of_get_transaccion_sucia( ))
	
	ll_filasCampos = lds_camposEtiqueta.retrieve(as_etiqueta)
	ll_filasArreglo = upperbound(as_datos)
	If ll_filasCampos > 0 Then
		For ll_fila = 1 to ll_filasCampos
			li_campo = Long(lds_camposEtiqueta.GetItemString(ll_fila,'co_campo'))
			ls_de_campo = lds_camposEtiqueta.GetItemString(ll_fila,'de_campo')
			if li_campo <= ll_filasArreglo Then
				li_longitud = lds_camposEtiqueta.GetItemNumber(ll_fila,'longitudmaxima')
				if len(as_datos[li_campo]) > 0 Then
					as_campos[li_campo] = left(as_datos[li_campo],li_longitud)
				else
					ex.setmessage( "El campo "+ls_de_campo+" est$$HEX2$$e1002000$$ENDHEX$$vacio")
					is_mensaje = "El campo "+ls_de_campo+" est$$HEX2$$e1002000$$ENDHEX$$vacio"
					Destroy lds_camposEtiqueta
					Return -1
					Throw(ex)
				End if
			Else
				ex.setmessage( "Se enviaron datos incorrectos")
				is_mensaje = "Se enviaron datos incorrectos"
				Destroy lds_camposEtiqueta
				Return -1
				Throw(ex)
			End if
		Next
	Else
		ex.setMessage("La etiqueta no tiene configurado campos")
		is_mensaje = "La etiqueta no tiene configurado campos"
		Destroy lds_camposEtiqueta
		Return -1
		Throw(ex)
	End if
	
Catch ( Throwable ex2)
	Destroy lds_camposEtiqueta
	Return -1
	Throw (ex2)
End try

Destroy lds_camposEtiqueta
Return 1
end function

on n_cst_etiqueta.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_etiqueta.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

