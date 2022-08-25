HA$PBExportHeader$w_programacion_produccion.srw
forward
global type w_programacion_produccion from window
end type
type cb_1 from commandbutton within w_programacion_produccion
end type
type tab_1 from tab within w_programacion_produccion
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_base within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_base within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_programacion_produccion
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_programacion_produccion from window
integer width = 3131
integer height = 1456
boolean titlebar = true
string title = "Programaci$$HEX1$$f300$$ENDHEX$$n de la Producci$$HEX1$$f300$$ENDHEX$$n"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_1 cb_1
tab_1 tab_1
end type
global w_programacion_produccion w_programacion_produccion

on w_programacion_produccion.create
this.cb_1=create cb_1
this.tab_1=create tab_1
this.Control[]={this.cb_1,&
this.tab_1}
end on

on w_programacion_produccion.destroy
destroy(this.cb_1)
destroy(this.tab_1)
end on

event open;n_cts_param luo_param
Long li_tpprod,li_centro,li_subcentro  



Environment le_even

If GetEnvironment ( le_even ) = 1 Then 
	This.x = (PixelsToUnits(le_even.ScreenWidth,XPixelsToUnits!) - This.width) / 2
	This.y = (PixelsToUnits(le_even.ScreenHeight,YPixelsToUnits!) - This.Height) / 2
End If


luo_param = Message.PowerObjectParm

If Not IsValid(luo_param) Then
	Close(This)
	Return
End If
	

w_programacion_produccion.tab_1.tabpage_1.dw_1.SetTransObject(Sqlca)
w_programacion_produccion.tab_1.tabpage_2.dw_2.SetTransObject(Sqlca)

select co_tipoprod,   
       co_centro_pdn,   
       co_subcentro_pdn  
  into :li_tpprod,   
       :li_centro,   
       :li_subcentro  
  from m_modulos  
 where co_fabrica = :luo_param.il_vector[2] and
       co_planta = :luo_param.il_vector[3] and
       co_modulo = :luo_param.il_vector[4]    ;

If Sqlca.SqlCode <> 0 Then
	MessageBox("Advertencia!","Hubo un error al buscar el tipo de producto.~n~n~nNota: " + Sqlca.SqlErrText )
	Return -1
End If

w_programacion_produccion.tab_1.tabpage_1.dw_1.Retrieve(li_tpprod,li_centro,li_subcentro,&
                         luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
								 luo_param.il_vector[4],luo_param.il_vector[5],luo_param.il_vector[6],&
								 luo_param.il_vector[7],luo_param.is_vector[1],luo_param.il_vector[8],&
								 luo_param.il_vector[9],luo_param.il_vector[10],luo_param.il_vector[11],&
								 luo_param.is_vector[2],luo_param.il_vector[12],luo_param.il_vector[13])
								 
w_programacion_produccion.tab_1.tabpage_2.dw_2.Retrieve(luo_param.il_vector[1],luo_param.il_vector[2],luo_param.il_vector[3],&
								 luo_param.il_vector[5],luo_param.il_vector[6],&
								 luo_param.il_vector[7],luo_param.is_vector[1],luo_param.il_vector[8],&
								 luo_param.il_vector[9],luo_param.il_vector[10],luo_param.il_vector[11],&
								 luo_param.is_vector[2],luo_param.il_vector[12],luo_param.il_vector[13],luo_param.il_vector[4])								 
end event

type cb_1 from commandbutton within w_programacion_produccion
integer x = 1344
integer y = 1228
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cerrar"
end type

event clicked;Close(Parent)
end event

type tab_1 from tab within w_programacion_produccion
integer x = 9
integer width = 3072
integer height = 1200
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3035
integer height = 1084
long backcolor = 67108864
string text = "Procesos"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_base within tabpage_1
integer x = 5
integer y = 12
integer width = 3017
integer height = 1064
integer taborder = 20
string dataobject = "d_rep_procesos_plan"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3035
integer height = 1084
long backcolor = 67108864
string text = "Programaci$$HEX1$$f300$$ENDHEX$$n"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_base within tabpage_2
integer x = 9
integer y = 12
integer width = 3008
integer height = 1060
integer taborder = 30
string dataobject = "d_rep_programa_diario"
end type

