HA$PBExportHeader$w_rollos_liberacion_problemas.srw
forward
global type w_rollos_liberacion_problemas from window
end type
type dw_lista from datawindow within w_rollos_liberacion_problemas
end type
type gb_1 from groupbox within w_rollos_liberacion_problemas
end type
end forward

global type w_rollos_liberacion_problemas from window
integer width = 2683
integer height = 1456
boolean titlebar = true
string title = "Rollos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
gb_1 gb_1
end type
global w_rollos_liberacion_problemas w_rollos_liberacion_problemas

type variables
Long ii_estadodisp, ii_centroterm
end variables

on w_rollos_liberacion_problemas.create
this.dw_lista=create dw_lista
this.gb_1=create gb_1
this.Control[]={this.dw_lista,&
this.gb_1}
end on

on w_rollos_liberacion_problemas.destroy
destroy(this.dw_lista)
destroy(this.gb_1)
end on

event open;Long li_fabrica, li_linea
Long ll_referencia, ll_ordenpd_pt
s_base_parametros lstr_parametros
n_cts_constantes luo_constantes
luo_constantes = Create n_cts_constantes

dw_lista.SetTransObject(sqlca)

lstr_parametros = Message.PowerObjectParm

ll_ordenpd_pt = lstr_parametros.entero[1]

ii_estadodisp = luo_constantes.of_consultar_numerico("ESTADO DISPONIBLE")
IF ii_estadodisp = -1 THEN
	Return -1
END IF
//se modifica el centro de tela terminado a 15 si la fabrica es MARINILLA o 21 si es PEREIRA
//jcrm
//mayo 27 de 2007
IF gstr_info_usuario.co_planta_pro = 2 THEN
	ii_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA TERMINAD")
	IF ii_centroterm = -1 THEN
		CLOSE(w_retroalimentacion)
		MessageBox('Error','No fue posible establecer el centro de los rollos para Marinilla.')
		Return -1
	END IF
END IF

IF gstr_info_usuario.co_planta_pro = 99 THEN
	ii_centroterm = luo_constantes.of_consultar_numerico("CENTRO TELA PEREIRA")
	IF ii_centroterm = -1 THEN
		CLOSE(w_retroalimentacion)
		MessageBox('Error','No fue posible establecer el centro de los rollos para Pereira.')
		Return -1
	END IF
END IF

SELECT Distinct co_fabrica,
		 co_linea,
		 co_referencia
  INTO :li_fabrica,
  		 :li_linea,
		 :ll_referencia
  FROM h_ordenpd_pt
 WHERE cs_ordenpd_pt = :ll_ordenpd_pt; 
 
dw_lista.Retrieve(ll_ordenpd_pt,li_fabrica, li_linea, ll_referencia,ii_estadodisp,ii_centroterm)
end event

type dw_lista from datawindow within w_rollos_liberacion_problemas
integer x = 59
integer y = 64
integer width = 2587
integer height = 1152
integer taborder = 10
string title = "none"
string dataobject = "dgr_rollos_liberacion"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type gb_1 from groupbox within w_rollos_liberacion_problemas
integer x = 41
integer y = 24
integer width = 2619
integer height = 1248
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

