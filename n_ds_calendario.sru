HA$PBExportHeader$n_ds_calendario.sru
forward
global type n_ds_calendario from datastore
end type
end forward

global type n_ds_calendario from datastore
end type
global n_ds_calendario n_ds_calendario

forward prototypes
public function long of_update ()
public function long of_commit ()
end prototypes

public function long of_update ();Long li_ret

//	Actualiza la B.D. con los cambios hechos en el datastore
li_ret = This.Update()

//	Retorna el valor original de la operacion
Return li_ret
end function

public function long of_commit ();Commit Using SQLCA;

If SQLCA.SQLCode = -1 Then
	RollBack Using SQLCA;
	If SQLCA.SQLCode = -1 Then
		Post MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'RollBack' ha fallado; " &
					+ 'la transaccion no ha sido devuelta completamente en la Base de Datos.' &
					+ '~nPor favor avise al Administrador del Sistema.')
	End If

	MessageBox('Atenci$$HEX1$$f300$$ENDHEX$$n', "La operaci$$HEX1$$f300$$ENDHEX$$n 'Commit' ha fallado; " &
				+ 'los datos no han sido almacenados en la Base de Datos.' &
				+ '~nPor favor avise al Administrador del Sistema.')
	Return -1
End If

Return 1
end function

on n_ds_calendario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ds_calendario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

