HA$PBExportHeader$w_maestro_tipos_etapas.srw
forward
global type w_maestro_tipos_etapas from w_base_tabular
end type
end forward

global type w_maestro_tipos_etapas from w_base_tabular
string title = "Maestro Tipos de Etapas"
string menuname = "m_mantenimiento_simple"
end type
global w_maestro_tipos_etapas w_maestro_tipos_etapas

on w_maestro_tipos_etapas.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_maestro_tipos_etapas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_buscar;call super::ue_buscar;//s_base_parametros lstr_parametros
//long ll_hallados
//string	ls_de_etapa
//
//IF is_cambios = "no" OR is_accion <> "cancelo" THEN
////	Open(w_buscar)
////	lstr_parametros=message.powerObjectparm
////
////	IF lstr_parametros.hay_parametros THEN
////		arg1=lstr_parametros.cadena[1]
////		arg2=lstr_parametros.cadena[2]
////		arg3=lstr_parametros.entero[1]
////
//		ls_de_etapa=sle_argumento.text
//		ll_hallados = dw_maestro.Retrieve(ls_de_etapa)
//
//		IF isnull(ll_hallados) THEN
//			MessageBox("Error buscando","parametros nulos",Exclamation!,Ok!)
//		ELSE
//			CHOOSE CASE ll_hallados
//				CASE -1
//					il_fila_actual_maestro = -1
//					MessageBox("Error buscando","Error de la base",StopSign!,&
//                         Ok!)
//				CASE 0
//					il_fila_actual_maestro = 0
//					MessageBox("Sin Datos","No hay datos para su criterio",&
//                         Exclamation!,Ok!)
//				CASE ELSE
//					il_fila_actual_maestro = 1
//					MessageBox("Busqueda ok","registros encontrados: "+&
//             	String(ll_hallados),Information!,Ok!)
//			END CHOOSE
//		END IF
////	ELSE
////	END IF
//ELSE
//END IF
//
end event

type dw_maestro from w_base_tabular`dw_maestro within w_maestro_tipos_etapas
string dataobject = "dtb_maestro_tipos_etapas"
end type

type sle_argumento from w_base_tabular`sle_argumento within w_maestro_tipos_etapas
end type

type st_1 from w_base_tabular`st_1 within w_maestro_tipos_etapas
end type

