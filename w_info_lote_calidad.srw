HA$PBExportHeader$w_info_lote_calidad.srw
forward
global type w_info_lote_calidad from w_base_tabular
end type
type em_1 from editmask within w_info_lote_calidad
end type
end forward

global type w_info_lote_calidad from w_base_tabular
integer width = 3419
integer height = 2148
em_1 em_1
end type
global w_info_lote_calidad w_info_lote_calidad

on w_info_lote_calidad.create
int iCurrent
call super::create
this.em_1=create em_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_1
end on

on w_info_lote_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_1)
end on

type dw_maestro from w_base_tabular`dw_maestro within w_info_lote_calidad
integer width = 3191
integer height = 1784
string dataobject = "dtb_info_lote"
end type

event dw_maestro::retrieveend;call super::retrieveend;Long		li_tot_fila, li_fila
LONG		ll_lote, ll_tanda, ll_op, ll_tela	

li_tot_fila =  dw_maestro.RowCount()

FOR li_fila = 1 TO li_tot_fila
//
	ll_lote    = dw_maestro.GetItemNumber(li_fila, "lote")
	ll_tanda   = dw_maestro.GetItemNumber(li_fila, "cs_tanda")
	ll_op      = dw_maestro.GetItemNumber(li_fila, "cs_orden_pr_act")
	ll_tela    = dw_maestro.GetItemNumber(li_fila, "co_reftel_act")

//	

//		SELECT co_maquina, prioridad  
//		  INTO :li_co_maquina, :li_cs_prioridad
//		  FROM dt_prog_tintoreria
//		 WHERE cs_tanda  = :ll_cs_tanda
//		   AND cs_secundario = :li_cs_secundario
//		   AND cs_ordenpd_pt = :ll_cs_ordenpd_pt
//		   AND co_reftel = :ll_co_reftel
//		   AND cs_lote = :ll_cs_lote
//			AND co_maquina > 0
//		   AND fe_programa = (SELECT max(fe_programa)
//			  					    FROM dt_prog_tintoreria                                       
//								    WHERE cs_tanda  = :ll_cs_tanda                                      
//								    AND cs_secundario = :li_cs_secundario                                         
//								    AND cs_ordenpd_pt = :ll_cs_ordenpd_pt                                     
//								    AND co_reftel = :ll_co_reftel                                         
//								    AND cs_lote = :ll_cs_lote
//									 AND co_maquina > 0)   ;

//			 dw_estado.SetItem(li_fila, "maq_tint", 0)
//			 dw_estado.SetItem(li_fila, "prioridad", 0)
//		END IF
//				

//		
//	//END IF
//	
NEXT
//
end event

type sle_argumento from w_base_tabular`sle_argumento within w_info_lote_calidad
boolean visible = false
end type

type st_1 from w_base_tabular`st_1 within w_info_lote_calidad
string text = "Lote"
end type

type em_1 from editmask within w_info_lote_calidad
integer x = 247
integer y = 12
integer width = 553
integer height = 92
integer taborder = 11
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "############"
end type

event modified;LONG	ll_lote
ll_lote = LONG(em_1.text)
dw_maestro.retrieve(ll_lote)
end event

