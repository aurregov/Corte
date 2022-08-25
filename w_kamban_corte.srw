HA$PBExportHeader$w_kamban_corte.srw
forward
global type w_kamban_corte from w_base_simple
end type
type gb_1 from groupbox within w_kamban_corte
end type
end forward

global type w_kamban_corte from w_base_simple
integer width = 3689
integer height = 1644
string title = "Kamban Corte"
gb_1 gb_1
end type
global w_kamban_corte w_kamban_corte

event ue_buscar;s_base_parametros lstr_parametros


open(w_parametros_kamban_corte)

lstr_parametros = message.PowerObjectParm	

If lstr_parametros.hay_parametros = True Then
	dw_maestro.Retrieve(lstr_parametros.entero[1],&
					  lstr_parametros.entero[2],&
					  lstr_parametros.entero[3])
					  
Else
					
End if
end event

on w_kamban_corte.create
int iCurrent
call super::create
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
end on

on w_kamban_corte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1

dw_maestro.SetTransObject(SQLCA)

m_mantenimiento_simple.m_edicion.m_insertarmaestro.ToolbarItemVisible = False
m_mantenimiento_simple.m_edicion.m_borrarmaestro.ToolbarItemVisible = False

TriggerEvent('ue_buscar')

dw_maestro.SetFocus()
end event

event ue_insertar_maestro;//
end event

event ue_borrar_maestro;//
end event

type dw_maestro from w_base_simple`dw_maestro within w_kamban_corte
integer x = 41
integer y = 48
integer width = 3557
integer height = 1356
string dataobject = "dtb_kamban_corte"
end type

type gb_1 from groupbox within w_kamban_corte
integer x = 27
integer width = 3579
integer height = 1440
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

