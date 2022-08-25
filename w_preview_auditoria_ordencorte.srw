HA$PBExportHeader$w_preview_auditoria_ordencorte.srw
forward
global type w_preview_auditoria_ordencorte from w_preview_de_impresion
end type
type st_4 from statictext within w_preview_auditoria_ordencorte
end type
type em_raya from editmask within w_preview_auditoria_ordencorte
end type
type st_2 from statictext within w_preview_auditoria_ordencorte
end type
type em_fecha_inicial from editmask within w_preview_auditoria_ordencorte
end type
type st_3 from statictext within w_preview_auditoria_ordencorte
end type
type em_fecha_final from editmask within w_preview_auditoria_ordencorte
end type
type aceptar from picturebutton within w_preview_auditoria_ordencorte
end type
type dw_2 from datawindow within w_preview_auditoria_ordencorte
end type
type dw_1 from datawindow within w_preview_auditoria_ordencorte
end type
end forward

global type w_preview_auditoria_ordencorte from w_preview_de_impresion
st_4 st_4
em_raya em_raya
st_2 st_2
em_fecha_inicial em_fecha_inicial
st_3 st_3
em_fecha_final em_fecha_final
aceptar aceptar
dw_2 dw_2
dw_1 dw_1
end type
global w_preview_auditoria_ordencorte w_preview_auditoria_ordencorte

type variables
DATE	id_fecha_inicio,id_fecha_fin
LONG  il_raya,il_fila_actual
TRANSACTION			itr_tela
end variables

event open;LONG ll_raya
This.WindowState = Maximized!
itr_tela 				= 	Create Transaction
itr_tela.DBMS			=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DBMS","")
itr_tela.DATABASE		=	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","DATABASE","")
itr_tela.USERID		=	SQLCA.USERID
itr_tela.DBPASS		=	SQLCA.DBPASS
itr_tela.DBPARM		=	"connectstring='DSN="+itr_tela.DATABASE+";UID="+itr_tela.USERID+";PWD="+itr_tela.DBPASS+"'"
itr_tela.ServerName 	= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","SERVIDOR","")
itr_tela.Lock 			= 	ProfileString(gstr_info_usuario.ruta_ini,"bd aplicacion","LOCK","Dirty read")

CONNECT USING itr_tela;
IF itr_tela.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo conectarse a proceso")
	RETURN 0
ELSE 
END IF


dw_1.SetTransobject(SQLCA)
dw_2.SetTransobject(SQLCA)

dw_1.visible=false
dw_2.visible=false

em_fecha_final.Text=string(today())

end event

on w_preview_auditoria_ordencorte.create
int iCurrent
call super::create
this.st_4=create st_4
this.em_raya=create em_raya
this.st_2=create st_2
this.em_fecha_inicial=create em_fecha_inicial
this.st_3=create st_3
this.em_fecha_final=create em_fecha_final
this.aceptar=create aceptar
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.em_raya
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_fecha_inicial
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_fecha_final
this.Control[iCurrent+7]=this.aceptar
this.Control[iCurrent+8]=this.dw_2
this.Control[iCurrent+9]=this.dw_1
end on

on w_preview_auditoria_ordencorte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.em_raya)
destroy(this.st_2)
destroy(this.em_fecha_inicial)
destroy(this.st_3)
destroy(this.em_fecha_final)
destroy(this.aceptar)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event close;DISCONNECT USING itr_tela ;
IF itr_tela.SQLCODE=-1 THEN
	MessageBox("Error base datos","No pudo desconectar de proceso")
	RETURN 0
ELSE 
END IF

end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_auditoria_ordencorte
integer width = 2715
string dataobject = "dtb_auditoria_ordencortes"
end type

event dw_reporte::doubleclicked;call super::doubleclicked;LONG ll_hallados,ll_ordencorte


s_base_parametros	lstr_parametros

//////////////////////////////////////////////////////////////
// Se verifica si la fila en la que esta posicionada sea valida.
//////////////////////////////////////////////////////////////

IF row <> 0 AND row <> -1 AND NOT ISNULL(row) THEN
	This.SelectRow(il_fila_actual,FALSE)
	il_fila_actual = row
ELSE
END IF

dw_reporte.AcceptText()
ll_ordencorte	= this.GetitemNumber(this.getrow(),"dt_rayas_telaxoc_cs_orden_corte")	
		ll_hallados=dw_1.Retrieve(ll_ordencorte,il_raya)
		ll_hallados=dw_2.Retrieve(ll_ordencorte,il_raya) 		

		IF isnull(ll_hallados) THEN
							MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
						ELSE
							CHOOSE CASE ll_hallados
							CASE -1
								il_fila_actual = -1
								MessageBox("Error buscando","Error de la base",StopSign!,&
											 Ok!)
							CASE 0
								il_fila_actual = 0
								MessageBox("Sin Datos","No hay datos para este grupo",&
											 Exclamation!,Ok!)
							CASE ELSE
								il_fila_actual = 1
								
							END CHOOSE
							
		END IF
										
choose case dwo.name
				case "saldo"
						dw_1.visible=true
				case "ca_cortados"
						dw_1.visible=true
				case "yds_liquidadas"
						dw_2.visible=true
		end choose						

		
		

end event

event dw_reporte::rowfocuschanged;call super::rowfocuschanged;dw_1.visible=false
dw_2.visible=false

end event

type st_4 from statictext within w_preview_auditoria_ordencorte
integer x = 5
integer y = 40
integer width = 201
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Raya:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_raya from editmask within w_preview_auditoria_ordencorte
integer x = 206
integer y = 24
integer width = 297
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "10"
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

event modified;em_raya.SelectText(1, Len(em_raya.Text))
end event

type st_2 from statictext within w_preview_auditoria_ordencorte
integer x = 695
integer y = 40
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Fecha Inicial:"
boolean focusrectangle = false
end type

type em_fecha_inicial from editmask within w_preview_auditoria_ordencorte
integer x = 987
integer y = 24
integer width = 297
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy-mm-dd"
end type

event modified;em_fecha_inicial.SelectText(1, Len(em_fecha_inicial.Text))

end event

type st_3 from statictext within w_preview_auditoria_ordencorte
integer x = 1417
integer y = 40
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Fecha Final:"
boolean focusrectangle = false
end type

type em_fecha_final from editmask within w_preview_auditoria_ordencorte
integer x = 1696
integer y = 24
integer width = 297
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy-mm-dd"
end type

event modified;em_fecha_final.SelectText(1, Len(em_fecha_final.Text))

end event

type aceptar from picturebutton within w_preview_auditoria_ordencorte
integer x = 2427
integer y = 24
integer width = 379
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ver Reporte"
boolean default = true
string picturename = "k:\desarrollo\graficos\ok.bmp"
alignment htextalign = right!
end type

event clicked;
LONG  ll_hallados,ll_raya
DATE ld_fecha_inicial, ld_fecha_final
s_base_parametros 	lstr_parametros


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 


il_raya						=long(em_raya.TEXT)
ld_fecha_inicial			=date(em_fecha_inicial.TEXT)
ld_fecha_final				=date(em_fecha_final.TEXT)


ll_hallados = dw_reporte.Retrieve(il_raya,ld_fecha_inicial,ld_fecha_final)
	
	
	IF isnull(ll_hallados) THEN
		MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
	ELSE
	CHOOSE CASE ll_hallados
			CASE -1
				MessageBox("Error buscando","Error de la base",StopSign!,Ok!)
			CASE 0
				MessageBox("Sin Datos","No hay datos para su criterio",Exclamation!,Ok!)
			CASE ELSE
		END CHOOSE
	END IF
dw_reporte.Modify("DataWindow.Print.Preview=No")
dw_reporte.Modify("DataWindow.Print.Preview.Rulers=No")
is_zoom = dw_reporte.Describe("DataWindow.Print.Preview.Zoom")





end event

type dw_2 from datawindow within w_preview_auditoria_ordencorte
integer x = 50
integer y = 452
integer width = 2597
integer height = 944
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "dtb_rollos_liquidados_oc"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_preview_auditoria_ordencorte
integer x = 869
integer y = 248
integer width = 1038
integer height = 852
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Rollos no liquidados en esta orden de corte"
string dataobject = "dtb_rollos_sin_liquidar"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

