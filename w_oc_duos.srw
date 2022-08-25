HA$PBExportHeader$w_oc_duos.srw
forward
global type w_oc_duos from window
end type
type st_1 from statictext within w_oc_duos
end type
type sle_corte from singlelineedit within w_oc_duos
end type
type cb_1 from commandbutton within w_oc_duos
end type
type dw_maestro from datawindow within w_oc_duos
end type
type gb_1 from groupbox within w_oc_duos
end type
end forward

global type w_oc_duos from window
integer width = 1390
integer height = 1872
boolean titlebar = true
string title = "O.C. Duos / Conjuntos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
st_1 st_1
sle_corte sle_corte
cb_1 cb_1
dw_maestro dw_maestro
gb_1 gb_1
end type
global w_oc_duos w_oc_duos

type variables
s_base_parametros  istr_param
cst_adm_conexion icst_lectura
end variables

event open;This.x = 1
This.y = 1


icst_lectura = create  cst_adm_conexion
dw_maestro.settransobject(icst_lectura.of_get_transaccion_sucia())

IF (f_deshabilitar_opciones(this.classname(),this.menuid)= -1) THEN
	Close(This)
END IF


end event

on w_oc_duos.create
this.st_1=create st_1
this.sle_corte=create sle_corte
this.cb_1=create cb_1
this.dw_maestro=create dw_maestro
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.sle_corte,&
this.cb_1,&
this.dw_maestro,&
this.gb_1}
end on

on w_oc_duos.destroy
destroy(this.st_1)
destroy(this.sle_corte)
destroy(this.cb_1)
destroy(this.dw_maestro)
destroy(this.gb_1)
end on

event closequery;icst_lectura.of_destruir_dirty_read( )
end event

type st_1 from statictext within w_oc_duos
integer x = 114
integer y = 56
integer width = 315
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
boolean focusrectangle = false
end type

type sle_corte from singlelineedit within w_oc_duos
integer x = 462
integer y = 52
integer width = 320
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ll_oc, ll_duo
n_cst_orden_corte luo_corte



ll_oc = Long(sle_corte.Text)

IF ll_oc > 0 THEN
	ll_duo = luo_corte.of_duo_conjunto(ll_oc)
	IF dw_maestro.retrieve(ll_duo) <= 0 THEN
		MessageBox('Advertencia','La O.C. no hace parte de un duo o conjunto.',Exclamation!)
		Return
	END IF
ELSE
	MessageBox('Error','N$$HEX1$$fa00$$ENDHEX$$mero de O.C. no es valido.',StopSign!)
	Return
END IF


sle_corte.Text = ''
end event

type cb_1 from commandbutton within w_oc_duos
integer x = 512
integer y = 1572
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;Close(Parent)
end event

type dw_maestro from datawindow within w_oc_duos
integer x = 64
integer y = 220
integer width = 1230
integer height = 1220
string title = "none"
string dataobject = "dgr_oc_po_duo"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_oc_duos
integer x = 41
integer y = 156
integer width = 1280
integer height = 1364
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

