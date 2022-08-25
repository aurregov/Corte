HA$PBExportHeader$w_conexion_devolver_liquidacion.srw
forward
global type w_conexion_devolver_liquidacion from window
end type
type pb_desconectar from picturebutton within w_conexion_devolver_liquidacion
end type
type pb_conectar from picturebutton within w_conexion_devolver_liquidacion
end type
type dw_perfil from datawindow within w_conexion_devolver_liquidacion
end type
type sle_password from singlelineedit within w_conexion_devolver_liquidacion
end type
type sle_co_usuario from singlelineedit within w_conexion_devolver_liquidacion
end type
type st_perfil from statictext within w_conexion_devolver_liquidacion
end type
type st_password from statictext within w_conexion_devolver_liquidacion
end type
type st_usuario from statictext within w_conexion_devolver_liquidacion
end type
type gb_captura from groupbox within w_conexion_devolver_liquidacion
end type
type gb_picture from groupbox within w_conexion_devolver_liquidacion
end type
end forward

global type w_conexion_devolver_liquidacion from window
integer x = 910
integer y = 452
integer width = 1234
integer height = 1340
boolean titlebar = true
string title = "Sistema de Seguridad"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
pb_desconectar pb_desconectar
pb_conectar pb_conectar
dw_perfil dw_perfil
sle_password sle_password
sle_co_usuario sle_co_usuario
st_perfil st_perfil
st_password st_password
st_usuario st_usuario
gb_captura gb_captura
gb_picture gb_picture
end type
global w_conexion_devolver_liquidacion w_conexion_devolver_liquidacion

type variables
long	il_cod_aplic
Transaction gtr_dev_liq
Long il_perfil
end variables

event open;string	ls_usuario,ls_password,ls_perfil
long		ll_filas,ll_cont_fila

il_perfil = Message.DoubleParm
gtr_dev_liq = Create Transaction

gtr_dev_liq.DBMS=ProfileString(gstr_info_usuario.ruta_ini,"bd seguridad","DBMS","")
gtr_dev_liq.DATABASE=ProfileString(gstr_info_usuario.ruta_ini,"bd seguridad","DATABASE","")
gtr_dev_liq.USERID=SQLCA.USERID
gtr_dev_liq.DBPASS=SQLCA.DBPASS
gtr_dev_liq.DBPARM="connectstring='DSN="+SQLCA.DATABASE+";UID=" + SQLCA.USERID + ";PWD=" + SQLCA.DBPASS
gtr_dev_liq.ServerName = ProfileString(gstr_info_usuario.ruta_ini,"bd seguridad","SERVIDOR","")
gtr_dev_liq.Lock = "Cursor Stability"

CONNECT USING gtr_dev_liq;
IF gtr_dev_liq.SQLCODE=-1 THEN
	MessageBox ("Error Conexi$$HEX1$$f300$$ENDHEX$$n","No se pudo conectar la Base de datos",Stopsign!,ok!)
ELSE
	dw_perfil.SetTransObject(gtr_dev_liq)
	il_cod_aplic = gstr_info_usuario.codigo_aplicacion
	dw_perfil.Retrieve(il_cod_aplic)
END IF


end event

event close;Disconnect Using gtr_dev_liq;
end event

on w_conexion_devolver_liquidacion.create
this.pb_desconectar=create pb_desconectar
this.pb_conectar=create pb_conectar
this.dw_perfil=create dw_perfil
this.sle_password=create sle_password
this.sle_co_usuario=create sle_co_usuario
this.st_perfil=create st_perfil
this.st_password=create st_password
this.st_usuario=create st_usuario
this.gb_captura=create gb_captura
this.gb_picture=create gb_picture
this.Control[]={this.pb_desconectar,&
this.pb_conectar,&
this.dw_perfil,&
this.sle_password,&
this.sle_co_usuario,&
this.st_perfil,&
this.st_password,&
this.st_usuario,&
this.gb_captura,&
this.gb_picture}
end on

on w_conexion_devolver_liquidacion.destroy
destroy(this.pb_desconectar)
destroy(this.pb_conectar)
destroy(this.dw_perfil)
destroy(this.sle_password)
destroy(this.sle_co_usuario)
destroy(this.st_perfil)
destroy(this.st_password)
destroy(this.st_usuario)
destroy(this.gb_captura)
destroy(this.gb_picture)
end on

type pb_desconectar from picturebutton within w_conexion_devolver_liquidacion
integer x = 699
integer y = 1076
integer width = 393
integer height = 124
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&ancelar"
boolean cancel = true
string picturename = "c:\graficos\cancelar.bmp"
alignment htextalign = right!
end type

event clicked;//CloseWithReturn(parent,"Error")
Close(parent)
end event

type pb_conectar from picturebutton within w_conexion_devolver_liquidacion
integer x = 192
integer y = 1080
integer width = 393
integer height = 124
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Conectar"
boolean default = true
string picturename = "c:\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;string	ls_usuario,ls_password
long		ll_perfil,ll_fila,ll_retorno

ls_usuario = sle_co_usuario.text
ll_fila = dw_perfil.GetRow()
IF ll_fila = 0 THEN
	MessageBox("Seleccionar Perfil","Primero debe seleccionarse el perfil",Exclamation!)
	Return
END IF


	  SELECT produc.dt_usuxper.co_perfil
    INTO :ll_perfil  
    FROM produc.dt_usuxper
   WHERE produc.dt_usuxper.co_aplicacion = :il_cod_aplic AND
			produc.dt_usuxper.co_usuario = :ls_usuario AND
			produc.dt_usuxper.co_perfil = :il_perfil
	Using gtr_dev_liq;
	
	IF ll_perfil = dw_perfil.GetItemNumber(ll_fila,"co_perfil") THEN
		ll_retorno = 1
		CloseWithReturn(parent,ll_retorno)
		//gl_usuario=ls_usuario
		
	ELSE
		ll_retorno = 0
		CloseWithReturn(parent,ll_retorno)
		
	END IF	

end event

type dw_perfil from datawindow within w_conexion_devolver_liquidacion
integer x = 407
integer y = 712
integer width = 745
integer height = 272
integer taborder = 30
string dataobject = "dtb_lista_perfiles"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;SelectRow(0,False)
SelectRow(row,true)
end event

type sle_password from singlelineedit within w_conexion_devolver_liquidacion
integer x = 416
integer y = 592
integer width = 421
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
boolean password = true
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

type sle_co_usuario from singlelineedit within w_conexion_devolver_liquidacion
integer x = 416
integer y = 452
integer width = 421
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

type st_perfil from statictext within w_conexion_devolver_liquidacion
integer x = 96
integer y = 732
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Perfil:"
boolean focusrectangle = false
end type

type st_password from statictext within w_conexion_devolver_liquidacion
integer x = 96
integer y = 596
integer width = 306
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Password:"
boolean focusrectangle = false
end type

type st_usuario from statictext within w_conexion_devolver_liquidacion
integer x = 96
integer y = 460
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Usuario:"
boolean focusrectangle = false
end type

type gb_captura from groupbox within w_conexion_devolver_liquidacion
integer x = 27
integer y = 360
integer width = 1152
integer height = 668
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_picture from groupbox within w_conexion_devolver_liquidacion
integer x = 27
integer y = 20
integer width = 1152
integer height = 356
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 79741120
end type

