HA$PBExportHeader$w_autorizacion_capas.srw
forward
global type w_autorizacion_capas from window
end type
type dw_lista from datawindow within w_autorizacion_capas
end type
type st_1 from statictext within w_autorizacion_capas
end type
type cb_cancelar from commandbutton within w_autorizacion_capas
end type
type cb_aceptar from commandbutton within w_autorizacion_capas
end type
type gb_1 from groupbox within w_autorizacion_capas
end type
end forward

global type w_autorizacion_capas from window
integer width = 969
integer height = 1184
boolean titlebar = true
string title = "Autorizaci$$HEX1$$f300$$ENDHEX$$n"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
gb_1 gb_1
end type
global w_autorizacion_capas w_autorizacion_capas

on w_autorizacion_capas.create
this.dw_lista=create dw_lista
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.st_1,&
this.cb_cancelar,&
this.cb_aceptar,&
this.gb_1}
end on

on w_autorizacion_capas.destroy
destroy(this.dw_lista)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.gb_1)
end on

event open;This.Center = True

dw_lista.SetTransObject(sqlca)

dw_lista.InsertRow(0)
end event

type dw_lista from datawindow within w_autorizacion_capas
integer x = 41
integer y = 448
integer width = 827
integer height = 288
integer taborder = 10
string title = "none"
string dataobject = "dff_autorizacion_capas"
boolean border = false
boolean livescroll = true
end type

type st_1 from statictext within w_autorizacion_capas
integer x = 46
integer y = 36
integer width = 864
integer height = 312
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Las capas liquidadas difieren de las capas programadas, en un porcentaje que hace necesario la confirmacion de este cambio por parte de un jefe de salon o del jefe de corte."
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_autorizacion_capas
integer x = 480
integer y = 896
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;s_base_parametros lstr_parametros

lstr_parametros.hay_parametros = False

CloseWithReturn ( parent, lstr_parametros )
end event

type cb_aceptar from commandbutton within w_autorizacion_capas
integer x = 82
integer y = 896
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;s_base_parametros lstr_parametros
String ls_usuario, ls_password
Long li_concepto

dw_lista.AcceptText()

ls_usuario = dw_lista.GetItemString(1,'usuario')
ls_password = dw_lista.GetItemString(1,'password')
li_concepto = dw_lista.GetItemNumber(1,'concepto')

IF IsNull(li_concepto) THEN
	MessageBox('Advertencia','Debe ingresar un concepto.',Exclamation!)
	Return
End if

IF isnull(ls_usuario) OR ls_usuario = '' OR isnull(ls_password) OR ls_password = '' THEN
	MessageBox('Advertencia','Debe ingresar usuario y password.',Exclamation!)
	Return
ELSE
		
	//se valida que el usuario y password sean validos.
	Transaction ltr_Transaction

   ltr_Transaction = Create Transaction
	ltr_Transaction.DBMS =	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
	ltr_Transaction.USERID =	ls_usuario
	ltr_Transaction.DBPASS =	ls_password
	ltr_Transaction.DBPARM =   'DSN="+ltr_Transaction.DATABASE+";UID="+ltr_Transaction.ls_usuario+";PWD="+ltr_Transaction.ls_password+"'
	ltr_Transaction.ServerName = "vesrs00@hilpro01"
	ltr_Transaction.Lock = ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","")					
			
					
	CONNECT USING ltr_Transaction;
		
	IF ltr_Transaction.SQLCODE=-1 THEN	
		MessageBox('Error','Usuario y password no validos.')
		DISCONNECT USING ltr_Transaction;
		Return
	ELSE
		lstr_parametros.hay_parametros = True
		lstr_parametros.cadena[1] = ls_usuario
		lstr_parametros.cadena[2] = ls_password
		lstr_parametros.entero[1] = li_concepto
	END IF
					
	DISCONNECT USING ltr_Transaction;
	
	
END IF

CloseWithReturn ( parent, lstr_parametros )
end event

type gb_1 from groupbox within w_autorizacion_capas
integer x = 37
integer y = 364
integer width = 846
integer height = 432
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

