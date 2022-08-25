HA$PBExportHeader$n_registrar_sql.sru
forward
global type n_registrar_sql from nonvisualobject
end type
end forward

global type n_registrar_sql from nonvisualobject
end type
global n_registrar_sql n_registrar_sql

type variables
uo_dsbase ids_logsql		//	Datastore utilizado para registrar el sql en la BD
String is_ventana			//	Almacena el nombre de la ventana donde se creo este objeto
end variables

forward prototypes
public function long of_registrar_sql (string objeto, long ai_tipo_sql, string as_sql)
public function long of_registrar_sql (long ai_tipo_sql, string as_sql)
end prototypes

public function long of_registrar_sql (string objeto, long ai_tipo_sql, string as_sql);Long ll_reg

ll_reg = ids_logsql.InsertRow(0)
ids_logsql.SetItem(ll_reg, 'ventana', is_ventana)
ids_logsql.SetItem(ll_reg, 'objeto', objeto)
ids_logsql.SetItem(ll_reg, 'tipo_sql', ai_tipo_sql)
ids_logsql.SetItem(ll_reg, 'sql_enviado', as_sql)

Return 1
end function

public function long of_registrar_sql (long ai_tipo_sql, string as_sql);Long ll_reg

ll_reg = ids_logsql.InsertRow(0)
ids_logsql.SetItem(ll_reg, 'ventana', is_ventana)
ids_logsql.SetItem(ll_reg, 'objeto', '')
ids_logsql.SetItem(ll_reg, 'tipo_sql', ai_tipo_sql)
ids_logsql.SetItem(ll_reg, 'sql_enviado', as_sql)

Return 1
end function

on n_registrar_sql.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_registrar_sql.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_logsql = Create uo_dsbase
ids_logsql.DataObject = 'd_gr_logsql'
ids_logsql.SetTransObject(SQLCA)
end event

