HA$PBExportHeader$w_reporte_numeracion_fusionado.srw
forward
global type w_reporte_numeracion_fusionado from w_preview_de_impresion
end type
type dw_criterio from datawindow within w_reporte_numeracion_fusionado
end type
type cb_1 from commandbutton within w_reporte_numeracion_fusionado
end type
type gb_1 from groupbox within w_reporte_numeracion_fusionado
end type
end forward

global type w_reporte_numeracion_fusionado from w_preview_de_impresion
integer width = 3173
integer height = 2052
dw_criterio dw_criterio
cb_1 cb_1
gb_1 gb_1
end type
global w_reporte_numeracion_fusionado w_reporte_numeracion_fusionado

event open;This.X = 1
This.Y = 1
This.Width = 4100
This.Height = 1750

TRANSACTION			itr_tela
STRING	ls_instruccion

itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_reporte.SetTransObject(itr_tela)
dw_criterio.SetTransObject(itr_tela)
dw_criterio.InsertRow(0)
dw_criterio.SetFocus()

DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

on w_reporte_numeracion_fusionado.create
int iCurrent
call super::create
this.dw_criterio=create dw_criterio
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_criterio
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_reporte_numeracion_fusionado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_criterio)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_reporte_numeracion_fusionado
integer y = 164
integer height = 1380
string dataobject = "dtb_reporte_numeracion_fusionado"
end type

type dw_criterio from datawindow within w_reporte_numeracion_fusionado
integer x = 91
integer y = 52
integer width = 750
integer height = 76
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_reporte_numeracion_fusionado"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_reporte_numeracion_fusionado
integer x = 1079
integer y = 48
integer width = 343
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Recuperar"
end type

event clicked;TRANSACTION			itr_tela
STRING	ls_instruccion
Long li_proceso

itr_tela = Create Transaction
itr_tela.DBMS		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE	=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName = 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 		= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La conexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

dw_criterio.SetTransObject(itr_tela)
dw_reporte.SetTransObject(itr_tela)

dw_criterio.AcceptText()

li_proceso = dw_criterio.GetItemNumber(1,'proceso')

If li_proceso < 1 Then Return


dw_reporte.Retrieve(li_proceso)


DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE = -1 THEN
   MessageBox("ERROR....","La desconexi$$HEX1$$f300$$ENDHEX$$n para abrir esta ventana (dr)" +sqlca.sqlerrtext,Stopsign!,OK!)
   Return
END IF

end event

type gb_1 from groupbox within w_reporte_numeracion_fusionado
integer x = 82
integer y = 8
integer width = 773
integer height = 136
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
end type

