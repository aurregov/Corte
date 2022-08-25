HA$PBExportHeader$w_preview_variaciones_detallado.srw
forward
global type w_preview_variaciones_detallado from w_preview_de_impresion
end type
type st_1 from statictext within w_preview_variaciones_detallado
end type
end forward

global type w_preview_variaciones_detallado from w_preview_de_impresion
integer width = 4078
string title = "Vista Preliminar de Reportes..pr"
st_1 st_1
end type
global w_preview_variaciones_detallado w_preview_variaciones_detallado

on w_preview_variaciones_detallado.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_preview_variaciones_detallado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event open;
LONG 					ll_cs_ordenpd_pt,ll_color_pt,ll_raya

STRING				ls_grupo,ls_estilo

DATETIME					ld_fecha_inicio,ld_fecha_fin

s_base_parametros s_parametros

s_parametros = Message.PowerObjectParm

ls_grupo 			= s_parametros.cadena[1]
ll_cs_ordenpd_pt	= s_parametros.entero[1]
ll_color_pt			= s_parametros.entero[2]
ll_raya				= s_parametros.entero[3]
ls_estilo 			= s_parametros.cadena[2]
ld_fecha_inicio 	= s_parametros.fechahora[1]
ld_fecha_fin 		= s_parametros.fechahora[2]


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(ls_grupo, ll_cs_ordenpd_pt, ls_estilo, ll_color_pt,ll_raya,ld_fecha_inicio,ld_fecha_fin)
dw_reporte.GroupCalc()
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_variaciones_detallado
integer x = 14
integer width = 3913
string dataobject = "dtb_reporte_variaciones_detallado_corte"
end type

type st_1 from statictext within w_preview_variaciones_detallado
integer x = 23
integer y = 48
integer width = 974
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
string text = "Reporte para imprimir en Hoja Tama$$HEX1$$f100$$ENDHEX$$o Oficio"
boolean focusrectangle = false
end type

