HA$PBExportHeader$w_ejecutar_sp_m_lotes_soti_conf.srw
forward
global type w_ejecutar_sp_m_lotes_soti_conf from window
end type
type st_1 from statictext within w_ejecutar_sp_m_lotes_soti_conf
end type
type sle_1 from singlelineedit within w_ejecutar_sp_m_lotes_soti_conf
end type
type cb_cancelar from commandbutton within w_ejecutar_sp_m_lotes_soti_conf
end type
type cb_aceptar from commandbutton within w_ejecutar_sp_m_lotes_soti_conf
end type
type gb_1 from groupbox within w_ejecutar_sp_m_lotes_soti_conf
end type
end forward

global type w_ejecutar_sp_m_lotes_soti_conf from window
integer width = 919
integer height = 732
boolean titlebar = true
string title = "Pasar Lotes"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
sle_1 sle_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_ejecutar_sp_m_lotes_soti_conf w_ejecutar_sp_m_lotes_soti_conf

on w_ejecutar_sp_m_lotes_soti_conf.create
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.sle_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_ejecutar_sp_m_lotes_soti_conf.destroy
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;This.x = 1
This.y = 1
end event

type st_1 from statictext within w_ejecutar_sp_m_lotes_soti_conf
integer x = 105
integer y = 168
integer width = 297
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Corte:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ejecutar_sp_m_lotes_soti_conf
integer x = 407
integer y = 168
integer width = 379
integer height = 72
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

type cb_cancelar from commandbutton within w_ejecutar_sp_m_lotes_soti_conf
integer x = 480
integer y = 456
integer width = 343
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_ejecutar_sp_m_lotes_soti_conf
integer x = 64
integer y = 452
integer width = 343
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Long ll_ordecorte

ll_ordecorte = Long(sle_1.Text)


Execute immediate "SET OPTIMIZATION LOW" ; 

DECLARE generar_lote PROCEDURE &
	FOR pr_m_lotes_soti_conf(:ll_ordecorte);
EXECUTE generar_lote;
Execute immediate "SET OPTIMIZATION HIGH" ;

IF SQLCA.SQLCode = -1 THEN
	ROLLBACK;
	MessageBox("Error Base Datos","Error al ejecutar el stored procedure")			
	Return -1
END IF


MessageBox('Exito','Se pasaron los lotes de forma exitosa, por favor verifique sus datos.')


end event

type gb_1 from groupbox within w_ejecutar_sp_m_lotes_soti_conf
integer x = 55
integer y = 28
integer width = 795
integer height = 324
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

