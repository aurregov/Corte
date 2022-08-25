HA$PBExportHeader$w_criticas_kamban_corte.srw
forward
global type w_criticas_kamban_corte from window
end type
type dw_maestro from datawindow within w_criticas_kamban_corte
end type
end forward

global type w_criticas_kamban_corte from window
integer width = 3872
integer height = 2192
boolean titlebar = true
string title = "Ordenes de Corte"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_imprimir ( )
dw_maestro dw_maestro
end type
global w_criticas_kamban_corte w_criticas_kamban_corte

on w_criticas_kamban_corte.create
this.dw_maestro=create dw_maestro
this.Control[]={this.dw_maestro}
end on

on w_criticas_kamban_corte.destroy
destroy(this.dw_maestro)
end on

event open;Long li_ano, li_semana
n_cts_constantes_tela luo_tela
s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

DISCONNECT;
SQLCA.Lock = "DIRTY READ"
CONNECT USING SQLCA;


//se determinan el a$$HEX1$$f100$$ENDHEX$$o y semana de las criticas
li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')

dw_maestro.SetTransObject(SQLCA)
dw_maestro.Retrieve(lstr_parametros.entero[1], lstr_parametros.entero[2], lstr_parametros.entero[3], 0, 0, gstr_info_usuario.co_planta_pro, li_ano, li_semana)

dw_maestro.SetFilter("co_subcentro_pdn <> 7")
dw_maestro.Filter( )

Close(w_retroalimentacion)
	
DISCONNECT;
SQLCA.Lock = "Cursor Stability"
CONNECT USING SQLCA;

dw_maestro.SetTransObject(SQLCA)

end event

type dw_maestro from datawindow within w_criticas_kamban_corte
integer x = 37
integer y = 44
integer width = 3762
integer height = 2020
integer taborder = 10
string title = "none"
string dataobject = "dw_reporte_kamban_po_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

