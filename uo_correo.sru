HA$PBExportHeader$uo_correo.sru
forward
global type uo_correo from nonvisualobject
end type
end forward

global type uo_correo from nonvisualobject
end type
global uo_correo uo_correo

forward prototypes
public subroutine of_enviar_correo (string as_asunto, string as_mensaje, string as_programa, string as_usuario) throws exception
public subroutine of_enviar_correo (string as_asunto, string as_mensaje, string as_programa) throws exception
end prototypes

public subroutine of_enviar_correo (string as_asunto, string as_mensaje, string as_programa, string as_usuario) throws exception;/*Dbedocal 23/04/2018: Se crea funci$$HEX1$$f300$$ENDHEX$$n gen$$HEX1$$e900$$ENDHEX$$rica, para el manejo de env$$HEX1$$ed00$$ENDHEX$$o de correos, 
eliminando c$$HEX1$$f300$$ENDHEX$$digo quemado y con un funcionamiento m$$HEX1$$e100$$ENDHEX$$s Din$$HEX1$$e100$$ENDHEX$$mico.*/


Exception ex
ex = create Exception  

DECLARE pr_envia_email PROCEDURE FOR
		  PR_ENVIAR_EMAIL(:as_programa, :as_mensaje, :as_asunto, :as_usuario ) USING SQLCA; 
			
EXECUTE pr_envia_email ;
 
IF SQLCA.SQLCODE = -1 THEN 
	CLOSE pr_envia_email;
	ex.setmessage("Error enviando correo: "+ SQLCA.sqlerrtext)
	throw(ex)
ELSE
	CLOSE pr_envia_email;
END IF

end subroutine

public subroutine of_enviar_correo (string as_asunto, string as_mensaje, string as_programa) throws exception;/*Dbedocal 23/04/2018: Se crea funci$$HEX1$$f300$$ENDHEX$$n gen$$HEX1$$e900$$ENDHEX$$rica, para el manejo de env$$HEX1$$ed00$$ENDHEX$$o de correos, 
eliminando c$$HEX1$$f300$$ENDHEX$$digo quemado y con un funcionamiento m$$HEX1$$e100$$ENDHEX$$s Din$$HEX1$$e100$$ENDHEX$$mico.*/


of_enviar_correo( as_asunto, as_mensaje, as_programa, "" )

end subroutine

on uo_correo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_correo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

