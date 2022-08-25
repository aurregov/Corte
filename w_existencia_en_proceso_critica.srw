HA$PBExportHeader$w_existencia_en_proceso_critica.srw
forward
global type w_existencia_en_proceso_critica from w_preview_de_impresion
end type
end forward

global type w_existencia_en_proceso_critica from w_preview_de_impresion
integer width = 3808
integer height = 2248
end type
global w_existencia_en_proceso_critica w_existencia_en_proceso_critica

on w_existencia_en_proceso_critica.create
call super::create
end on

on w_existencia_en_proceso_critica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;Long li_ano, li_semana
n_cts_constantes_tela luo_tela
s_base_parametros lstr_parametros

lstr_parametros = Message.PowerObjectParm	

//DISCONNECT;
//SQLCA.Lock = "DIRTY READ"
//CONNECT USING SQLCA;
//

//se determinan el a$$HEX1$$f100$$ENDHEX$$o y semana de las criticas
li_ano = luo_tela.of_consultar_numerico('ANO_CRITICA')
li_semana = luo_tela.of_consultar_numerico('SEMANA_CRITICA')

dw_reporte.SetTransObject(SQLCA)
dw_reporte.Retrieve(lstr_parametros.entero[1], lstr_parametros.entero[2],lstr_parametros.entero[7],  lstr_parametros.entero[8],lstr_parametros.entero[3], lstr_parametros.entero[6])
Close(w_retroalimentacion)
	
//DISCONNECT;
//SQLCA.Lock = "Cursor Stability"
//CONNECT USING SQLCA;
//
//dw_reporte.SetTransObject(SQLCA)
//
end event

type dw_reporte from w_preview_de_impresion`dw_reporte within w_existencia_en_proceso_critica
integer width = 3712
integer height = 1880
string dataobject = "dtb_existencias_tandas_proceso_criticas"
end type

