HA$PBExportHeader$corte.sra
$PBExportComments$Generated Application Object
forward
global type corte from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type corte from application
string appname = "corte"
end type
global corte corte

on corte.create
appname = "corte"
message = create message
sqlca = create transaction
sqlda = create dynamicdescriptionarea
sqlsa = create dynamicstagingarea
error = create error
end on

on corte.destroy
destroy( sqlca )
destroy( sqlda )
destroy( sqlsa )
destroy( error )
destroy( message )
end on

