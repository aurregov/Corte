HA$PBExportHeader$u_mes_pasado.sru
forward
global type u_mes_pasado from u_mes
end type
end forward

global type u_mes_pasado from u_mes
end type
global u_mes_pasado u_mes_pasado

on u_mes_pasado.create
call super::create
end on

on u_mes_pasado.destroy
call super::destroy
end on

event constructor;call super::constructor;/*cambia el color de fondo de los tres meses del a$$HEX1$$f100$$ENDHEX$$o anterior
y de los tres meses del a$$HEX1$$f100$$ENDHEX$$o siguiente, tambien desactiva esos meses
para que no se le puedan hacer cambios
*/
This.Object.BackColor = RGB(125,126,234)
This.Object.DisplayOnly = True
end event

