HA$PBExportHeader$w_preview_variaciones_detalle.srw
forward
global type w_preview_variaciones_detalle from w_preview_de_impresion
end type
type st_1 from statictext within w_preview_variaciones_detalle
end type
end forward

global type w_preview_variaciones_detalle from w_preview_de_impresion
integer width = 3438
st_1 st_1
end type
global w_preview_variaciones_detalle w_preview_variaciones_detalle

type variables
DATE	id_fecha_inicio,id_fecha_fin
LONG  il_raya,il_fila_actual
end variables

event open;LONG 					ll_ordencorte,ll_raya
DATE				ld_fecha_inicio,ld_fecha_fin

s_base_parametros s_parametros
//dw_1.SetTransobject(SQLCA)
//dw_2.SetTransobject(SQLCA)
//
//dw_1.visible=false
//dw_2.visible=false

s_parametros = Message.PowerObjectParm

ll_ordencorte		= s_parametros.entero[1]
ll_raya				= s_parametros.entero[3]
ld_fecha_inicio 	= s_parametros.fecha[1]
ld_fecha_fin 		= s_parametros.fecha[2]

il_raya				= ll_raya
id_fecha_inicio 	= ld_fecha_inicio
id_fecha_fin 		= ld_fecha_fin


dw_reporte.settransobject(sqlca)
ii_ancho= dw_reporte.width 
ii_alto = dw_reporte.height
ii_posx = dw_reporte.x   
ii_posy = dw_reporte.y 

dw_reporte.Retrieve(ll_ordencorte,ll_raya,ld_fecha_inicio,ld_fecha_fin)
dw_reporte.GroupCalc()
end event

on w_preview_variaciones_detalle.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_preview_variaciones_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

type dw_reporte from w_preview_de_impresion`dw_reporte within w_preview_variaciones_detalle
integer y = 136
integer width = 3365
string dataobject = "dtb_variaciones_espacio"
end type

event dw_reporte::doubleclicked;//LONG ll_hallados,ll_ordencorte
//STRING ls_grupo
//s_base_parametros	lstr_parametros
//
//////////////////////////////////////////////////////////////////
//// Se verifica si la fila en la que esta posicionada sea valida.
//////////////////////////////////////////////////////////////////
//
//IF row <> 0 AND row <> -1 AND NOT ISNULL(row) THEN
//	This.SelectRow(il_fila_actual,FALSE)
//	il_fila_actual = row
//ELSE
//END IF
//
//dw_reporte.AcceptText()
//ll_ordencorte	= this.GetitemNumber(this.getrow(),"dt_liquidaxespacio_cs_orden_corte")	
//		ll_hallados=dw_1.Retrieve(ll_ordencorte,il_raya,id_fecha_inicio,id_fecha_fin)
//		ll_hallados=dw_2.Retrieve(ll_ordencorte,il_raya,id_fecha_inicio,id_fecha_fin) 		
//
//		IF isnull(ll_hallados) THEN
//							MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//						ELSE
//							CHOOSE CASE ll_hallados
//							CASE -1
//								il_fila_actual = -1
//								MessageBox("Error buscando","Error de la base",StopSign!,&
//											 Ok!)
//							CASE 0
//								il_fila_actual = 0
//								MessageBox("Sin Datos","No hay datos para este grupo",&
//											 Exclamation!,Ok!)
//							CASE ELSE
//								il_fila_actual = 1
//								
//							END CHOOSE
//							
//		END IF
//										
//choose case dwo.name
//					case "dt_liquidaxespacio_cs_orden_corte"
//						dw_1.visible=true
//				case "yds_reales"
//						dw_2.visible=true
//				//case "pedpend_exp_co_ref_exp"
//				//		dw_3.visible=true
//		end choose						
//
//		
//		
//
end event

event dw_reporte::rowfocuschanged;call super::rowfocuschanged;//dw_1.visible=false
//dw_2.visible=false
end event

type st_1 from statictext within w_preview_variaciones_detalle
integer x = 32
integer y = 64
integer width = 864
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Se debe imprimir en papel tama$$HEX1$$f100$$ENDHEX$$o oficio"
boolean focusrectangle = false
end type

