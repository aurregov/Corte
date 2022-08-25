HA$PBExportHeader$w_mto_requisitos_x_area.srw
forward
global type w_mto_requisitos_x_area from w_mto_base
end type
type dw_2 from u_dw_base within w_mto_requisitos_x_area
end type
type gb_1 from groupbox within w_mto_requisitos_x_area
end type
type gb_2 from groupbox within w_mto_requisitos_x_area
end type
end forward

global type w_mto_requisitos_x_area from w_mto_base
integer width = 2775
integer height = 1460
string title = "Requisitos por Area"
string menuname = "m_mantenimiento_simple"
boolean resizable = false
dw_2 dw_2
gb_1 gb_1
gb_2 gb_2
end type
global w_mto_requisitos_x_area w_mto_requisitos_x_area

on w_mto_requisitos_x_area.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
this.dw_2=create dw_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.gb_2
end on

on w_mto_requisitos_x_area.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;This.X = 1
This.Y = 1

dw_1.Of_Changed(True)

If dw_1.Of_Conexion(Sqlca,True) = -1 Then
	MessageBox("Advertencia!","No se pudo establecer una conexi$$HEX1$$f300$$ENDHEX$$n con la base de datos.")
	Close(This)
	Return
End If

If dw_2.Of_Conexion(Sqlca,True) = -1 Then
	MessageBox("Advertencia!","No se pudo establecer una conexi$$HEX1$$f300$$ENDHEX$$n con la base de datos.")
	Close(This)
	Return
End If


dw_1.Retrieve()
dw_2.Retrieve()
end event

event ue_borrar_maestro;call super::ue_borrar_maestro;
dw_1.Of_DeleteRow()
end event

event ue_insertar_maestro();call super::ue_insertar_maestro;Long ll_fila,ll_flpd


ll_fila = dw_1.Of_InsertRow(0)

If ll_fila > 0 Then
	ll_flpd = dw_2.GetRow()
	
	dw_1.SetItem(ll_fila,"co_fabrica",dw_2.GetItemNumber(ll_flpd,"co_fabrica"))
	dw_1.SetItem(ll_fila,"co_planta",dw_2.GetItemNumber(ll_flpd,"co_planta"))
	dw_1.SetItem(ll_fila,"co_modulo",dw_2.GetItemNumber(ll_flpd,"co_modulo"))
	dw_1.SetItem(ll_fila,"co_proceso",dw_2.GetItemNumber(ll_flpd,"co_proceso_pdn"))

End If
	
end event

event ue_grabar;String ls_sqlerr



If dw_1.Of_Save() = 1 Then
	ls_sqlerr = Sqlca.SqlerrText
	rollback ;
	MessageBox("Advertencia!","No se pudo grabar los datos.~n~n~nNota: " + ls_sqlerr)
Else
	commit ;
End If
end event

type dw_1 from w_mto_base`dw_1 within w_mto_requisitos_x_area
integer x = 73
integer y = 696
integer width = 2619
integer height = 508
string dataobject = "d_mto_requisitos_por_area"
boolean vscrollbar = true
end type

event dw_1::itemchanged;call super::itemchanged;Long li_fabrica,li_linea
String  ls_delinea

If dwo.Name = 'co_linea' Then
	li_fabrica = This.GetItemNumber(row,'co_fabrica')
	li_linea   = Long(Data)
	
	select de_linea  
     into :ls_delinea  
     from m_lineas  
    where m_lineas.co_fabrica = :li_fabrica and
          m_lineas.co_linea = :li_linea    ;
			 
	This.SetItem(row,'de_linea',ls_delinea)

	
End If
end event

type dw_2 from u_dw_base within w_mto_requisitos_x_area
integer x = 73
integer y = 84
integer width = 2619
integer height = 508
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_procesos_produccion"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;

If currentrow > 0 Then
	This.SelectRow(0,False)
	This.SelectRow(currentrow,True)
	
	dw_1.SetFilter("co_fabrica = " + String(This.GetItemNumber(currentrow,"co_fabrica")) + " and " +&
	               "co_planta = " + String(This.GetItemNumber(currentrow,"co_planta")) + " and " +&
						"co_modulo = " + String(This.GetItemNumber(currentrow,"co_modulo")) + " and " +&
						"co_proceso = " + String(This.GetItemNumber(currentrow,"co_proceso_pdn")))
	dw_1.Filter()

End If
end event

type gb_1 from groupbox within w_mto_requisitos_x_area
integer x = 37
integer y = 24
integer width = 2697
integer height = 608
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Procesos "
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_mto_requisitos_x_area
integer x = 37
integer y = 636
integer width = 2697
integer height = 608
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requisitos"
borderstyle borderstyle = stylelowered!
end type

