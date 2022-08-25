HA$PBExportHeader$n_cerrar_aplicacion.sru
$PBExportComments$Esta clase maneja el cierre de la aplicacion a solicitud de los desarrolladores de la aplicacion y dependiendo de un tiempo  predeterminado por los desarrolladores.
forward
global type n_cerrar_aplicacion from nonvisualobject
end type
end forward

global type n_cerrar_aplicacion from nonvisualobject
event type long ue_posconstructor ( )
end type
global n_cerrar_aplicacion n_cerrar_aplicacion

type variables
Protected:
String is_mensaje
Long il_segundos
Time lt_time_ini
uo_timer invo_timer
uo_timer_cerrar_aplicacion  invo_timer_aplicacion

end variables

forward prototypes
public function long of_wait (datetime adtm_target)
public function boolean of_isvalid (date ad_source)
public function datetime of_relativedatetime (datetime adtm_start, long al_offset)
public function long of_wait (unsignedlong al_seconds)
public function boolean of_isvalid (datetime adtm_source)
public function long of_destroy ()
public function long of_set_tiempo_mensaje (long al_segundos, string as_mensaje)
end prototypes

event type long ue_posconstructor();/*	------------------------------------------------------------------------
	Evento que ocurre inmediatamente despues de creado el objeto. Crea un
	objeto timer que cierra la plicacion segun los parametros de la Oficina
	de Sistemas;  y crea otro objeto timer que se encarga de recordarle al
	usuario cada 30 segundos el proximo cierre de la aplicacion.   
	Adicionalmente muestra el mensaje inicial enviado desde sistemas
	------------------------------------------------------------------------*/

invo_timer_aplicacion = Create uo_timer_cerrar_aplicacion
invo_timer_aplicacion.Start(il_segundos)

invo_timer = Create uo_timer
invo_timer.start(30)
invo_timer.of_set_intervalo_tiempo(lt_time_ini,RelativeTime(lt_time_ini,il_segundos))

MessageBox("Mensaje de Sistemas     " + String(Now(),"hh:mm:ss am/pm"),&
												is_mensaje + "~n~nMuchas Gracias")

Return 1
end event

public function long of_wait (datetime adtm_target);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_Wait
//
//	Access:  		public
//
//	Arguments:
//	adtm_Target 	Target DateTime.
//
//	Returns:  		long
//						1 if function waited the expected time.
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function returns -1.
//
//	Description:  	Given a datetime, will wait until datetime is reached.
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

date 	ldt_value

//Check parameters
If IsNull(adtm_Target) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

//There is only need to test the Date portion of the DateTime.
ldt_value = Date(adtm_Target)

//Check for invalid date
If Not of_IsValid(ldt_value) Then
	Return -1
End If

//Wait until Target datetime
DO UNTIL DateTime(Today(),Now()) >= adtm_Target
	Yield() //Yields control to other graphic objects, including objects that are not PB.
LOOP

Return 1

end function

public function boolean of_isvalid (date ad_source);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_IsValid
//
//	Access:  		public
//
//	Arguments:
//	ad_source 			Date to test.
//
//	Returns:  		boolean
//						True if argument contains a valid date.
//						If any argument's value is NULL, function returns False.
//						If any argument's value is Invalid, function returns False.
//
//	Description:  	Given a date, will determine if the Date is valid.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.04 Enhanced for more complete checking.
//	6.0.01 Remove invalid date comparison
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

long 	li_year
long	li_month
long	li_day

// Initialize test values.
li_year = Year(ad_source)
li_month = Month(ad_source)
li_day = Day(ad_source)

// Check for nulls.
If IsNull(ad_source) Or IsNull(li_year) or IsNull(li_month) or IsNull(li_day) Then
	Return False
End If

// Check for invalid values.
If	li_year <= 0 or li_month <= 0 or li_day <= 0 Then
	Return False
End If

// Passed all testing.
Return True

end function

public function datetime of_relativedatetime (datetime adtm_start, long al_offset);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_RelativeDatetime
//
//	Access:  		public
//
//	Arguments:
//	adtm_start 		Starting datetime point of calculation.
//	al_offset     	Number of seconds before/after datetime to be returned.
//
//	Returns:		 	Datetime
//						Relative datetime.
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function returns 1900-01-01.
//
//	Description:  	Given a datetime, find the relative datetime +/- n seconds
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.03	Fix to return time as 00:00:00:000000 on invalid date check
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright $$HEX2$$a9002000$$ENDHEX$$1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

datetime ldt_null
date ld_sdate
time lt_stime
long ll_date_adjust
long ll_time_adjust, ll_time_test

//Check parameters
If IsNull(adtm_start) or IsNull(al_offset) Then
	SetNull(ldt_null)
	Return ldt_null
End If

//Check for invalid date
If Not of_IsValid(adtm_start) Then
	Return ldt_null
End If

//Initialize date and time portion
ld_sdate = date(adtm_start)
lt_stime = time(adtm_start)

//Find out how many days are contained
//Note: 86400 is # of seconds in a day
ll_date_adjust = al_offset /  86400
ll_time_adjust = mod(al_offset, 86400)

//Adjust date portion
ld_sdate = RelativeDate(ld_sdate, ll_date_adjust)

//Adjust time portion
//	Allow for time adjustments periods crossing over days
//	Check for time rolling forwards a day
If ll_time_adjust > 0 then
	ll_time_test = SecondsAfter(lt_stime,time('23:59:59'))
	If ll_time_test < ll_time_adjust Then
		ld_sdate = RelativeDate(ld_sdate,1)
		ll_time_adjust = ll_time_adjust - ll_time_test -1
		lt_stime = time('00:00:00')
	End If
	lt_stime = RelativeTime(lt_stime, ll_time_adjust)
//Check for time rolling backwards a day
ElseIf  ll_time_adjust < 0 then
	ll_time_test = SecondsAfter(lt_stime,time('00:00:00'))
	If   ll_time_test > ll_time_adjust Then
		ld_sdate = RelativeDate(ld_sdate,-1)
		ll_time_adjust = ll_time_adjust - ll_time_test +1
		lt_stime = time('23:59:59')
	End If
	lt_stime = RelativeTime(lt_stime, ll_time_adjust)
End If

return(datetime(ld_sdate,lt_stime))
end function

public function long of_wait (unsignedlong al_seconds);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_Wait
//
//	Access:  		public
//
//	Arguments:
//	al_seconds 		Wait this many Seconds.
//
//	Returns:  		long
//						1 if function waited the expected time.
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function returns -1.
//
//	Description:  	Given a datetime, will wait until datetime is reached.
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

datetime ldtm_target
long	li_ret

//Check parameters
If IsNull(al_seconds) Then
	Return al_seconds
End If

//Check invalid parameters
If al_seconds <= 0 Then
	Return -1
End If

//Get the Target DateTime
ldtm_target = of_RelativeDatetime(DateTime(Today(),Now()), al_seconds)

//Perform the actual wait.
li_ret = of_Wait(ldtm_target)

Return li_ret

end function

public function boolean of_isvalid (datetime adtm_source);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_IsValid
//
//	Access:  		public
//
//	Arguments:
//	adtm_source		DateTime to test.
//
//	Returns:  		boolean
//						True if argument is a valid datetime.
//						If any argument's value is NULL, function returns False.
//						If any argument's value is Invalid, function returns False.
//
//	Description:  	Given a datetime, will determine if the Datetime is valid.
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

date 	ldt_value

//Check parameters
If IsNull(adtm_source) Then
	Return False
End If

//There is only need to test the Date portion of the DateTime.
//Can't tell if time is invalid because 12am is 00:00:00:000000
ldt_value = Date(adtm_source)

//Check for invalid date
If Not of_IsValid(ldt_value) Then
	Return False
End If

Return True

end function

public function long of_destroy ();/*	-------------------------------------------------------------------
	Destruye los timer creados por el servicio de cerrar aplicacion.
	-------------------------------------------------------------------*/

Destroy invo_timer
Destroy invo_timer_aplicacion

Return 1
end function

public function long of_set_tiempo_mensaje (long al_segundos, string as_mensaje);/*	-------------------------------------------------------------------
	Fija los segundos que esperara el servicio antes de cerrar la 
	aplicacion y el mensaje inicial que debe mostrar el servicio al 
	usuario para advertirlo que debe cerrar la aplicacion.
	------------------------------------------------------------------*/
il_segundos = al_segundos
is_mensaje = as_mensaje

Return 1
end function

on n_cerrar_aplicacion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cerrar_aplicacion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;lt_time_ini = now()
This.Post Event ue_posconstructor()
end event

event destructor;Destroy invo_timer
Destroy invo_timer_aplicacion

end event

